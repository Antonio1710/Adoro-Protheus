#INCLUDE "TOTVS.CH" 
#INCLUDE "PROTHEUS.CH" 
#INCLUDE "RWMAKE.CH"
#INCLUDE "XMLXFUN.CH"  


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADINF008R �Autor  �WILLIAM COSTA       � Data �  02/06/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     �RELATORIO QUE LISTA A QUANTIDADE DE USUARIOS ON-LINE NO MO- ���
���          �MENTO A PARTIR DO SLAVE DO BALANCE                          ���
�������������������������������������������������������������������������͹��
���Uso       � SIGATEC - TI                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION ADINF008R()

	LOCAL   oSrv     := NIL
	LOCAL   cEnv     := "PRODUCAO" //Ambiente
	LOCAL   aUsers   := {}
	LOCAL   nIdx     := 0
	LOCAL   aServers := {}
	LOCAL   aTmp     := {}
	LOCAL   nCont    := 0
	LOCAL   nCont1   := 0	
	LOCAL   nCont2   := 0
	LOCAL   nTotUser := 0
	LOCAL   Arq      := "C:\temp\TotUsuariosProtheus.csv" //Nome do Arquivo a Gerar
	Local   Path     :=  Arq  //Local de Gera��o do Arquivo
	PRIVATE nHdl     := NIL
	PRIVATE nH       := NIL
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'RELATORIO QUE LISTA A QUANTIDADE DE USUARIOS ON-LINE NO MOMENTO A PARTIR DO SLAVE DO BALANCE')

	nHdl := fCreate(Path) //Cria Arquivo para grava��o das etiquetas
	cVar := "Nome de usu�rio; "                 + ;
	        "Nome da m�quina local; "           + ;
	        "ID da Thread;"                     + ;
	        "Servidor;"                         + ;   
	        "Nome da fun��o;"                   + ;
	        "Ambiente;"                         + ;
	        "Data e hora da conex�o;"           + ;
	        "Tempo em que a thread;"            + ;
	        "N�mero de instru��es;"             + ;
	        "N�mero de instru��es por segundo;" + ;
	        "Observa��es;"                      + ;
	        "Mem�ria consumida;"                + ;
	        " ID do processo;"                  + ;
	        chr(13) + chr(10)
	
	// neste caso, quero apenas o balance, que me retorna todos os slaves conectados.
	Aadd(aServers, {"10.5.1.1", 4321})
	// voce pode tamb�m adicionar outros servers fora do balance, como servers de web ou workflows.
	Aadd(aServers, {"10.5.1.1", 12342})
	//aadd(aServers, {"127.0.0.1", 7002})
	// etc [...]
	
	FOR nIdx := 1 TO LEN(aServers)
	     // conecta no slave via rpc
	     oSrv := rpcconnect(aServers[nIdx,1], aServers[nIdx,2], cEnv, "01", "01")
	     IF VALTYPE(oSrv) == "O"
	          oSrv:callproc("RPCSetType", 3)
	          // chama a funcao remotamente no server, retornando a lista de usuarios conectados
	          aTmp := oSrv:callproc("GetUserInfoArray")
	          aadd(aUsers, aclone(aTmp))
	          aTmp := nil
	          // limpa o ambiente
	          oSrv:callproc("RpcClearEnv")
	          // fecha a conexao
	          rpcdisconnect(oSrv)
	     ELSE
	          RETURN "Falha ao obter a lista de usuarios."
	     ENDIF
	NEXT nIdx     
	
	FOR nCont := 1 TO LEN(aUsers) 
               
		nTotUser := nTotUser + LEN(aUsers[nCont])
		
		FOR nCont1 := 1 TO LEN(aUsers[nCont])         
		
			FOR nCont2 := 1 TO LEN(aUsers[nCont][nCont1])
	                           
				IF nCont2 <> 7
				
				cVar += IIF(VALTYPE(aUsers[nCont][nCont1][nCont2]) == 'C', aUsers[nCont][nCont1][nCont2], CVALTOCHAR(aUsers[nCont][nCont1][nCont2])) + ';'
				
				ELSE
				
					cVar += ''
				ENDIF
    		NEXT nCont2 
    	
    		cVar += chr(13) + chr(10)
    			
        NEXT nCont1                         
	NEXT nCont
	
	ALERT("Usu�rios OnLine ("+ALLTRIM(STR(nTotUser))+") e Ambiente:" + cEnv)
	
	Set Century OFF
    If fWrite(nHdl,cVar,Len(cVar)) != Len(cVar) //Gravacao do arquivo
    	If !MsgAlert("Ocorreu um erro na gravacao do arquivo !!","Atencao!")
        	fClose(nHdl)
            Return
        Endif
    Endif
	fClose(nHdl)  
		
	MsAguarde({||shellExecute("Open", Arq, "NULL", "C:\",3)},"Aguarde","Abrindo relat�rio...")

RETURN (NIL)
