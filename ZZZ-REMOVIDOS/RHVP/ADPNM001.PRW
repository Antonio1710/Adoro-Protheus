#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "RWMAKE.CH"     
#INCLUDE "TOPCONN.CH"
#INCLUDE "PONWORK.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPNM001  �Autor  �NGSi                � Data �  18/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para Start do Processo de Leitura                    ���
���          �e apontamento do Ponto.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico ADORO                                           ���
�������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������Ĵ��
���Programador � Data   �Chamado�  Motivo da Alteracao                    ���
�������������������������������������������������������������������������Ĵ��
���Adriana     �11/06/19�  TI   �Conout para acompanhamento de email,     ���
���            �        �       �correcao autenticacao email, correcao    ���
���            �        �       �error.log Alias does not exist: ZBN      ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ADPNM001(aParam)

Local nOpca := 0
Local aRegs	:={}
Local cPerg := ""
Local aSays:={ }, aButtons:= { } 
Local cPathArq 
Local cNewArq

Private lGrvZa4 := .F.
Private _lJob 
private _cEmp
private _cFil
private cEol  :=   CHR(13)+CHR(10)
                
//����������������������������������������������������������������������������������������������������Ŀ
//|Verifica se a Rotina esta recebendo Parametros - Caso esteja a mesma esta sendo executada pelo JOB  �
//������������������������������������������������������������������������������������������������������

If aParam == Nil
	_lJob := .F.
Else
	_lJob := aParam[1]
	_cEmp := aParam[2]
	_cFil := aParam[3]

	RPCClearEnv()
    RPCSetType(3)  //Nao consome licensas

	PREPARE ENVIRONMENT EMPRESA ( _cEmp ) FILIAL ( _cFil ) Modulo "PON" Tables "RFD", "RFE", "SP8", "SP0"

	// Garanto uma �nica thread sendo executada - // Adoro - Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - fwnm - 29/06/2020
	If !LockByName("ADPNM001"+_cEmp, .T., .F.)
		ConOut("[ADPNM001] - Existe outro processamento sendo executado! Verifique...")
		RPCClearEnv()
		Return
	EndIf

	// @history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	//FWMonitorMsg(ALLTRIM(PROCNAME()))

	//INICIO CHAMADO 033882 - WILLIAM COSTA - Grava log de Execucao Schedule
	logZBN("1") //Log in�cio.
	//FINAL CHAMADO 033882 - WILLIAM COSTA - Grava log de Execucao Schedule

EndIf

GeraArq()	  

	//��������������������������������������?
	//�Destrava a rotina para o usu�rio	    ?
	//��������������������������������������?
	UnLockByName("ADPNM001"+cEmpAnt)

Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPNM001  �Autor  �GILBERTO - NGSI     � Data �  18/09/15   ���
�������������������������������������������������������������������������͹��
���Desc.     �Rotina para gera��o do arquivo texto para ser utilizado na  ���
���          �leitura e apontamento do Ponto.                             ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico ADORO                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GeraArq()

Local cQuery_ 
Local cPathArq 
Local dDataDe  
Local dDataAte 
Local cMatDe  
Local cMatAte 
Local cCont
Local nRet
Local lGrvLido	:= .F.     
Local cRelogio  := GetMv( "MV_#RELOG" , .F. , "" )   //Apenas relogios ativos para o schedule, que tem arquivo txt, Ex: relogio99.txt, onde 99 e o codigo constante no parametro
local x
//Local cPergPon 	:= ""
//Local lAchou	:= .F.


RpcSetEnv(_cEmp, _cFil,, 'FOLHA' )   //Seta o Ambiente

U_ADINF009P('ADPNM001' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Rotina para Start do Processo de Leitura e apontamento do Ponto.')

cEMail    := GETMV( "NG_SPMAIL",,"" )

		FOR X:=1 TO 20 //10 alterado por Adriana chamado 034890 EM 28/04/2017
            
			If strzero(x,2) $ cRelogio //Incluido por Adriana chamado 034890 EM 28/04/2017

            	IF _lJOB
   	 	        	cPathArq := "\relogio\"+DTOS(DATE()) +"\relogio"+ STRZERO(X,2)+ ".TXT"

   		    	ELSE   
    		    	cPathArq := "Z:\Saida\relogio"+ STRZERO(X,2)+ ".TXT"
            	ENDIF
            
		    	cNewArq  := "\RELOGIO\RELOGIO"+ STRZERO(X,2) + ".TXT"

				COPY FILE &(cPathArq) TO &(cNewArq)

				If !File(cPathArq)
 					Conout("Erro. Arquivo nao copiado: ",cNewArq ) 
 				Else
 					Conout("OK. Arquivo copiado: ",cNewArq )  				
				EndIf
				
			Endif
		    
		 NEXT X   

		// Chamada da Rotina de Leitura e Apontamento
		u_XPonScheduler( {_cEmp	,;	//01 -> Codigo da Empresa no SIGAMAT
					     _cFil,;            //               _cFil	,;	//02 -> Codigo da Filial no SIGAMAT
						.T.		,;	//03 -> Utilizar os Parametros do SX1 para o Processo de Leitura / Apontamento
						.T.		,;	//04 -> Limitar a Data Final do Apontamento aa DataBase do Sistema
						.T.		,;	//05 -> Efetuar o Apontamento Por Filial
						.F.		,;	//06 -> Efetua Apontamento para Relogios nao Lidos
						.T.		,;	//07 -> Forcar o Reapontamento das Marcacoes   
						.T.		 ;  //08 -> Processa apenas a filial passada como parametro 
					   })
	
		// Renomeia o Arquivo Texto Apos o Processamento
		 FOR X:=1 TO 20 //10 alterado por Adriana chamado 034890 EM 28/04/2017

			If strzero(x,2) $ cRelogio //Incluido por Adriana chamado 034890 EM 28/04/2017

		    	cPathArq := "\RELOGIO\RELOGIO"+ STRZERO(X,2)+ ".TXT"
		    	cNewArq  := "\RELOGIO\RELOGIO"+ STRZERO(X,2)+ "-" + Dtos(Date()) + "-" + StrTran(Time(),":","") + ".TXT"
		    	If fRename( cPathArq, cNewArq ) < 0
	    			Conout('Rotina ADPNM001 - Erro ao Renomear o arquivo texto ' + cPathArq)
		    	Else
			    	Conout('Rotina ADPNM001 - Arquivo texto renomeado para ' + cNewArq)
		    	EndIf 
		    	
			Endif
		    
		 NEXT X   


    /// tratamento do envio de email

    cSubject  := "PROCESSAMENTO DO SCHEDULLE DO PONTO - Empresa "+_cEmp  //acrescentada empresa ao assunto do email.

    cMensagem := '<p>O Schedulle de Leitura e apontamento foi processado!</p>' + cEol
    cMensagem += '<p>Data: '+DTOC(date()) + ' as ' + Time() + cEol

    cEmail    := cEMail 
    
    aFiles := {}
    
    lTEXT := .t. 
    
    //alterado por Adriana para acompanhar envio em 11/06/19
    If fEnvMail( cSubject, cMensagem, cEMail, aFiles, lText )
    	Conout("Rotina ADPNM001 - Empresa "+_cEmp+" eMail enviado.") 
    else
    	Conout("Rotina ADPNM001 - Empresa "+_cEmp+" eMail NAO enviado.")
    Endif
    //
    /// fim do tratamento do envio do email.
    

	/*
	�����������������������������������������������������������������������Ŀ
	� Finaliza o Ambiente da Empresa										�
	�������������������������������������������������������������������������*/
		If _lJob 

			logZBN("2") //Log fim.	//Alterado por Adriana chamada antes de resetar o ambiente em 11/06/19

			RESET ENVIRONMENT

			Conout('Rotina ADPNM001 - Finalizada')
			CONOUT('')
			
		endif	

Return()

/*
�����������������������������������������������������������������������Ŀ
� As Instrucoes Abaixo deverao ser Incluidas no INI do Server			�
�������������������������������������������������������������������������

[ONSTART]
JOBS=LEITURA_CLASSIFICACAO	//Define o Nome do Job

[LEITURA_CLASSIFICACAO]		//Configuracoes do Job
Main=u_StartJobPon			//ou Main=wfStart() se tiver apenas uma empresa
Environment=Environment		//Nome do Environment que devera ser utilizado


�����������������������������������������������������������������������Ŀ
� A chamada abaixo devera ser Incluida no Agendamento do WorkFlow		�
�������������������������������������������������������������������������
u_PonScheduler(		"01"	,;	//01 -> Codigo da Empresa no SIGAMAT
				 	"01"	,;	//02 -> Codigo da Filial no SIGAMAT
				 	.F.		,;	//03 -> Utilizar os Parametros do SX1 para o Processo de Leitura / Apontamento
				 	.T.		,;	//04 -> Limitar a Data Final do Apontamento aa DataBase do Sistema
				 	.T.		,;	//05 -> Efetuar o Apontamento Por Filial
				 	.F.		,;	//06 -> Efetua Apontamento para Relogios nao Lidos
				 	.F.		,;	//07 -> Forcar o Reapontamento das Marcacoes   
				 	.F.		 ;  //08 -> Processa apenas a filial passada como parametro 
			   )

�����������������������������������������������������������������������Ŀ
�Fun��o    �PonScheduler � Autor � GILBERTO - NGSI    � Data �18/09/2015�
�����������������������������������������������������������������������Ĵ
�Descri��o �Prepara o Ambiente da Empresa e Executa a  Leitura/Apontamen�
�          �to														    �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �u_PonScheduler( aUserDefParam )								�
�����������������������������������������������������������������������Ĵ
�Parametros�aUserDefParam -> Array contendo os Parametros do Usuario	�
�          �       														�
�Conteudo  �aUserDefParam[1]Codigo da Empresa no SIGAMAT				�
�          �       														�
�          �aUserDefParam[2]Codigo da Filial no SIGAMAT  				�
�          �       														�
�          �aUserDefParam[3]Se .T. caracterizara que o Programa   devera�
�          �                utilizar os Parametros do Programa de  Leitu�
�          �                ra/Apontamento, confome Definidos pelo 	Usua�
�          �                rio. Caso Contrario Ira considerar os Parame�
�          �                tros De/Ate de Forma Generica. 				�
�          �       														�
�          �aUserDefParam[4]Se a Data Fim dos Parametros deve ser Litida�
�          �                da a Menor Data entra a DataBase e o Fim  do�
�          �                Periodo de Apontamento						�
�          �aUserDefParam[5]Se Deve Processar Por Filial                �
�          �aUserDefParam[6]Se Deve Efetuar Apontamento Quando nao Conse�
�          �                gui Ler o Arquivo do Relogio                �
�          �aUserDefParam[7]Se Deve Forcar o Reapontamento 				�
�          �aUserDefParam[8]Se Utiliza a Filial passada como a que deve-�
�          �                ra ser processada como parametro.			�
�����������������������������������������������������������������������Ĵ
�Uso       �PonWork                                                    	�
�����������������������������������������������������������������������Ĵ
�Observacao�Essa Funcao devera ser Cadastrada no Agendamento           	�
�������������������������������������������������������������������������*/
User Function XPonScheduler( aUserDefParam )

//	_cEmp	,;	//01 -> Codigo da Empresa no SIGAMAT
//	_cFil	,;	//02 -> Codigo da Filial no SIGAMAT
//	.T.		,;	//03 -> Utilizar os Parametros do SX1 para o Processo de Leitura / Apontamento
//	.T.		,;	//04 -> Limitar a Data Final do Apontamento aa DataBase do Sistema
//	.T.		,;	//05 -> Efetuar o Apontamento Por Filial
//	.F.		,;	//06 -> Efetua Apontamento para Relogios nao Lidos
//	.T.		,;	//07 -> Forcar o Reapontamento das Marcacoes   
//	.T.		 ;  //08 -> Processa apenas a filial passada como parametro 


Local aFiliais			:= {}
Local cEmp				:= ""
Local cFil				:= ""
Local lWorkFlow		    := .T.
Local lUserDefParam		:= aUserDefParam[3]
Local lLimitaDataFim	:= aUserDefParam[4]
Local lProcFilial		:= aUserDefParam[5]
Local lApontaNaoLidas	:= aUserDefParam[6]
Local lForceReaponta	:= aUserDefParam[7]  
Local lSomentecFil		:= aUserDefParam[8]
Local nUserParam		:= 0.00
Local nLenParam			:= 0.00
Local nFilial			:= 0.00

Local dDataDe
Local dDataAte
Local cPergPon 	:= ""
Local lAchou	:= .F.

U_ADINF009P('ADPNM001' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Rotina para Start do Processo de Leitura e apontamento do Ponto.')

/*
�����������������������������������������������������������������������Ŀ
� Enviando Mensagens para o Console do Server                 			�
�������������������������������������������������������������������������*/
ConOut("")
ConOut( STR0001 )	//"Iniciando U_PonScheduler()..."
ConOut("")

/*
�����������������������������������������������������������������������Ŀ
� Verifica os Parametros passados          								�
�������������������������������������������������������������������������*/
IF ( !Empty( aUserDefParam ) .and. ValType( aUserDefParam ) == "A" )
	nLenParam := Len( aUserDefParam )
	For nUserParam := 1 To nLenParam
		Do Case
			Case ( nUserParam == 1 ) ; cEmp          	:= IF( ( ValType( aUserDefParam[ nUserParam ] ) == "C" ) , aUserDefParam[ nUserParam ] , ""	 )
			Case ( nUserParam == 2 ) ; cFil				:= IF( ( ValType( aUserDefParam[ nUserParam ] ) == "C" ) , aUserDefParam[ nUserParam ] , ""	 )
			Case ( nUserParam == 3 ) ; lUserDefParam	:= IF( ( ValType( aUserDefParam[ nUserParam ] ) == "L" ) , aUserDefParam[ nUserParam ] , .F. )
			Case ( nUserParam == 4 ) ; lLimitaDataFim	:= IF( ( ValType( aUserDefParam[ nUserParam ] ) == "L" ) , aUserDefParam[ nUserParam ] , .T. )
			Case ( nUserParam == 5 ) ; lProcFilial		:= IF( ( ValType( aUserDefParam[ nUserParam ] ) == "L" ) , aUserDefParam[ nUserParam ] , .F. )
			Case ( nUserParam == 6 ) ; lApontaNaoLidas	:= IF( ( ValType( aUserDefParam[ nUserParam ] ) == "L" ) , aUserDefParam[ nUserParam ] , .F. )
			Case ( nUserParam == 7 ) ; lForceReaponta	:= IF( ( ValType( aUserDefParam[ nUserParam ] ) == "L" ) , aUserDefParam[ nUserParam ] , .F. )
			Case ( nUserParam == 8 ) ; lSomentecFil		:= IF( ( ValType( aUserDefParam[ nUserParam ] ) == "L" ) , aUserDefParam[ nUserParam ] , .F. )
		End Case
	Next nUserParam
EndIF

/*
�����������������������������������������������������������������������Ŀ
� Verifica se Empresa/Filial foram Passados								�
�������������������������������������������������������������������������*/
IF !Empty( cEmp ) .and. !Empty( cFil )

	/*
	�����������������������������������������������������������������������Ŀ
	� Enviando Mensagens para o Console do Server                 			�
	�������������������������������������������������������������������������*/
	ConOut("")
	ConOut( STR0002 ) //"Preparando Ambiente da Empresa. Aguarde... "
	ConOut("")
	
	/*
	�����������������������������������������������������������������������Ŀ
	� Prepara Ambiente da Empresa											�
	�������������������������������������������������������������������������*/
//	PREPARE ENVIRONMENT EMPRESA ( cEmp ) FILIAL ( cFil ) Modulo "PON" Tables "RFD", "RFE", "SP8", "SP0", "ZA4"
	
		/*
		�����������������������������������������������������������������������Ŀ
		� Redefine nModulo de forma a Garantir que o Modulo seja o SIGAPON		�
		�������������������������������������������������������������������������*/
		SetModulo( "SIGAPON" , "PON" )

		/*
		�����������������������������������������������������������������������Ŀ
		� Enviando Mensagens para o Console do Server                 			�
		�������������������������������������������������������������������������*/
		ConOut("")
		ConOut("ROTINA PonScheduler - AJUSTANDO RESPOSTAS NO GRUPO DE PERGUNTA PNM010...")
		ConOut("")
		
		//�����������������������������������������������������������������������Ŀ
		//�GRAVA PARAMETROS PARA LEITURA E APONTAMENTO	                         �
		//�������������������������������������������������������������������������
		cPergPon	:= PADR("PNM010",LEN(SX1->X1_GRUPO))
		
		//If Val(Strtran(Left(Time(),5) ,":",".")) > 03.00
		//	dDataDe  := DTOS(Date())
		//Else
		//	dDataDe  := DTOS(Date()-1)
		//EndIf

		dDataDe  := DTOS(Date()-1)
		dDataAte := DTOS(Date())
		
		IF DAY(Date()) = 18 				
		   DDATABASE:= DATE() - 1
		ENDIF
		   
		DbSelectArea("SX1")
		DbSetOrder(1)
		  
		IF lAchou := ( SX1->( dbSeek( cPergPon + "01" , .T. ) ) )
			While SX1->(!EOF()) .And. SX1->X1_GRUPO == cPergPon
				RecLock("SX1",.F.)
				    If SX1->X1_ORDEM == "01"          // filial de
						SX1->X1_CNT01 := "0"  // cFil 
				    ElseIf SX1->X1_ORDEM == "02"     // filial ate
						SX1->X1_CNT01 := "99" // cFil 
				    ElseIf SX1->X1_ORDEM == "03"     //Centro de Custo De ?          
						SX1->X1_CNT01 := "0"		    
				    ElseIf SX1->X1_ORDEM == "04"     //Centro de Custo Ate ?         
						SX1->X1_CNT01 := "ZZZZZZZZZ"		    
				    ElseIf SX1->X1_ORDEM == "05"     //Turno De ?                    
						SX1->X1_CNT01 := "0"
				    ElseIf SX1->X1_ORDEM == "06"     //Turno Ate ?                   
						SX1->X1_CNT01 := "ZZZ"
				    ElseIf SX1->X1_ORDEM == "07"     //Matricula De ?                
						SX1->X1_CNT01 := "0"
				    ElseIf SX1->X1_ORDEM == "08"     //Matricula Ate ?                
						SX1->X1_CNT01 := "ZZZZZZ"
				    ElseIf SX1->X1_ORDEM == "09"     //Nome De ?                     
						SX1->X1_CNT01 := "A"
				    ElseIf SX1->X1_ORDEM == "10"     //Nome Ate ?                     
						SX1->X1_CNT01 := "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
				    ElseIf SX1->X1_ORDEM == "11"     //Relogio De ?                  
						SX1->X1_CNT01 := "0  "
				    ElseIf SX1->X1_ORDEM == "12"     //Relogio Ate ?                 
						SX1->X1_CNT01 := "999"
				    ElseIf SX1->X1_ORDEM == "13"     //Periodo Inicial ?             
						SX1->X1_CNT01 := dDataDe
				    ElseIf SX1->X1_ORDEM == "14"     //Periodo Final ?               
						SX1->X1_CNT01 := dDataAte
				    ElseIf SX1->X1_ORDEM == "15"     //Regra de Apont.De ?           
						SX1->X1_CNT01 := "01"
				    ElseIf SX1->X1_ORDEM == "16"     //Regra de Apont.Ate ?          
						SX1->X1_CNT01 := "99"        
				    ElseIf SX1->X1_ORDEM == "17"     // Processamento ?               
						SX1->X1_CNT01 :=  "3" //Space( Len( SX1->X1_CNT01 ) )
				    ElseIf SX1->X1_ORDEM == "18"	//Leitura/Apontamento ?         	    		    		    		    		    		    		    		    		    		    		    		    
						SX1->X1_CNT01 :=  "5" //Space( Len( SX1->X1_CNT01 ) )
				    ElseIf SX1->X1_ORDEM == "19"	//Reapontar ?                   	    		    		    		    		    		    		    		    		    		    		    		    
						SX1->X1_CNT01 :=  "3"  //Space( Len( SX1->X1_CNT01 ) )
				    ElseIf SX1->X1_ORDEM == "20"	// Ler a partir do ?            	    		    		    		    		    		    		    		    		    		    		    		    
						SX1->X1_CNT01 :=  "1"   //Space( Len( SX1->X1_CNT01 ) )
				    ElseIf SX1->X1_ORDEM == "21"	//Categorias ?                  	    		    		    		    		    		    		    		    		    		    		    		    
						SX1->X1_CNT01 := "ACDEGHIJMPST"
				    ElseIf SX1->X1_ORDEM == "22"	//Situacoes a gerar ?           	    		    		    		    		    		    		    		    		    		    		    		    
						SX1->X1_CNT01 := " ADFT"
					EndIf		    		    		    		    		    				
				MsUnLock()
			    SX1->(DbSkip())
			EndDo
				
		EndIF	
		
		/*
		�����������������������������������������������������������������������Ŀ
		� Processando a Leitura/Apontamento                           			�
		�������������������������������������������������������������������������*/
		IF ( lProcFilial )
		
			If lSomentecFil 
				/*
				�����������������������������������������������������������������������Ŀ
				� Processa somente a Filial passada como parametro            			�
				�������������������������������������������������������������������������*/
				aFiliais := GetFilRecnos(cEmpAnt, cFil, cFil)
			Else 
				/*
				�����������������������������������������������������������������������Ŀ
				� Processa todas as Filiais da Empresa passada como parametro  			�
				�������������������������������������������������������������������������*/
				aFiliais := GetFilRecnos(cEmpAnt , Space(FWGETTAMFILIAL), Replicate("Z", FWGETTAMFILIAL))
			Endif
        
            For nFilial := 1 To Len( aFiliais )
			
				/*
				�����������������������������������������������������������������������Ŀ
				� Posiciona o SM0 na Filial a ser Processada                  			�
				�������������������������������������������������������������������������*/
				SM0->( dbGoto( aFiliais[ nFilial , 02 ] ) )

				/*
				�����������������������������������������������������������������������Ŀ
				� Enviando Mensagens para o Console do Server                 			�
				�������������������������������������������������������������������������*/
				ConOut("")
				//"Inicio da Leitura/Apontamento em: "###" as "
				ConOut( STR0003  + Dtoc( MsDate() ) + STR0004 + Time() )
				ConOut("")
				//"Empresa: "
				ConOut( STR0005 + SM0->( FWGETCODFILIAL + " - " + AllTrim( M0_NOMECOM ) ) )
				ConOut("")
				//"Filial:  "
				ConOut( STR0006 + SM0->( FWGETCODFILIAL + " - " + AllTrim( M0_FILIAL ) + "/" + AllTrim( M0_NOME ) ) )
				ConOut("")

				/*
				�����������������������������������������������������������������������Ŀ
				� Chamada a Funcao de Leitura e Apontamento das Marcacoes     			�
				�������������������������������������������������������������������������*/
				Ponm010(	lWorkFlow					,;	//Define Que a Chamada Esta Sendo Efetuada Atraves do WorkFlow
						 	lUserDefParam				,;	//Verifica Se Devera Considerar os Parametros Pre-Definidos Pelo Usuario
						 	lLimitaDataFim				,;	//Verifica Se Devera Limitar a Data Fim a Menor Data entre a DataBase e o Periodo Final de Apontamento
							aFiliais[ nFilial , 01 ]	,;	//Filial a ser processada
						 	lProcFilial					,;	//Processo por Filial
						 	lApontaNaoLidas				,;	//Se Aponta as Marcacoes para as Filiais nao Lidas
						 	lForceReaponta				 ;	//Forcar o Reapontamento das Marcacoes
						)

				/*
				�����������������������������������������������������������������������Ŀ
				� Garante o Posicionamento no SIGAMAT                         			�
				�������������������������������������������������������������������������*/
				SM0->( MsGoto( aFiliais[ nFilial , 02 ] ) )

				/*
				�����������������������������������������������������������������������Ŀ
				� Enviando Mensagens para o Console do Server                 			�
				�������������������������������������������������������������������������*/
				ConOut("")
				// "Final da Leitura/Apontamento em: "###" as "
				ConOut(STR0007 + Dtoc( MsDate() ) + STR0004 + Time() )
				ConOut("")
				//"Empresa: "
				ConOut(STR0005 + SM0->( M0_CODIGO + " - " + AllTrim( M0_NOMECOM ) ) )
				ConOut("")
				//"Filial:  "
				ConOut(STR0006 + FWGETCODFILIAL + " - " +  SM0->(AllTrim(M0_FILIAL) + "/" + AllTrim(M0_NOME) ) )
				ConOut("")

            Next nFilial
		Else

			/*
			�����������������������������������������������������������������������Ŀ
			� Enviando Mensagens para o Console do Server                 			�
			�������������������������������������������������������������������������*/
			ConOut("")
			//"Inicio da Leitura/Apontamento em: "###" as "
			ConOut( STR0003  + Dtoc( MsDate() ) + STR0004 + Time() )
			ConOut("")

			/*
			�����������������������������������������������������������������������Ŀ
			� Chamada a Funcao de Leitura e Apontamento das Marcacoes     			�
			�������������������������������������������������������������������������*/
			Ponm010(	lWorkFlow					,;	//Define Que a Chamada Esta Sendo Efetuada Atraves do WorkFlow
					 	lUserDefParam				,;	//Verifica Se Devera Considerar os Parametros Pre-Definidos Pelo Usuario
					 	lLimitaDataFim				,;	//Verifica Se Devera Limitar a Data Fim a Menor Data entre a DataBase e o Periodo Final de Apontamento
						cFil						,;	//Filial a ser processada
					 	lProcFilial					,;	//Processo por Filial
					 	lApontaNaoLidas				,;	//Se Aponta as Marcacoes para as Filiais nao Lidas
					 	lForceReaponta				 ;	//Forcar o Reapontamento das Marcacoes
					)

			/*
			�����������������������������������������������������������������������Ŀ
			� Enviando Mensagens para o Console do Server                 			�
			�������������������������������������������������������������������������*/
			ConOut("")
			// "Final da Leitura/Apontamento em: "###" as "
			ConOut( STR0007 + Dtoc( MsDate() ) + STR0004 + Time() )
			ConOut("")

		EndIF		
		
	/*
	�����������������������������������������������������������������������Ŀ
	� Enviando Mensagens para o Console do Server                 			�
	�������������������������������������������������������������������������*/
	ConOut("")
	ConOut( STR0008 )	//"Encerrando Ambiente da Empresa. Aguarde... "
	ConOut("")
	/*
	�����������������������������������������������������������������������Ŀ
	� Finaliza o Ambiente da Empresa										�
	�������������������������������������������������������������������������*/
//	RESET ENVIRONMENT

Else

	/*
	�����������������������������������������������������������������������Ŀ
	� Enviando Mensagens para o Console do Server                 			�
	�������������������������������������������������������������������������*/
	ConOut("")
	ConOut( STR0009 )	//"Nao foi possivel concluir o processo. Empresa ou Filial Invalidas."
	ConOut("")

EndIF

/*
�����������������������������������������������������������������������Ŀ
� Enviando Mensagens para o Console do Server                 			�
�������������������������������������������������������������������������*/
ConOut("")
ConOut("Finalizando U_PonScheduler()...")
ConOut("")
	
Return( NIL )

/*
�����������������������������������������������������������������������Ŀ
�Fun��o    �StartJobPon  � Autor � NGSI               � Data �21/11/2001�
�����������������������������������������������������������������������Ĵ
�Descri��o �Start do Processo de WorkFlow                               �
�����������������������������������������������������������������������Ĵ
�Sintaxe   �u_StartJobPon												�
�����������������������������������������������������������������������Ĵ
�Parametros�															�
�����������������������������������������������������������������������Ĵ
�Uso       �PonWork                                                    	�
�����������������������������������������������������������������������Ĵ
�Observacao�Essa Funcao devera ser Incluida no .INI do Server          	�
�������������������������������������������������������������������������*/
User Function ADStartJobPon()

Local aEmpFil := Array( 02 )

aEmpFil[ 01 ] := "01"	//Codigo da Empresa confome SIGAMAT
aEmpFil[ 02 ] := "02"	//Codigo da Filial  confome SIGAMAT

Return( wfStart( aEmpFil ) )                            
                           

USER FUNCTION TSTPON
           //job / empresa / filial
U_ADPNM001({.T. , "01"    ,  "02" })

RETURN()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � fEnvMail �Autor  � Adilson Silva      � Data � 19/04/2012  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para Envio de Emails.                               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � MP10                                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fEnvMail( cSubject, cMensagem, cEMail, aFiles, lText )

Local lEnvioOK    := .F.			// Variavel que verifica se foi conectado OK
Local cMailConta  := GETMV( "MV_RELACNT" ) //alterado por Adriana para corrigir problema na autenticacao do email 11/06/19 
Local cMailServer := GETMV( "MV_RELSERV" ) //alterado por Adriana para corrigir problema na autenticacao do email 11/06/19 
Local cMailSenha  := GETMV( "MV_RELPSW" ) //alterado por Adriana para corrigir problema na autenticacao do email 11/06/19 
Local cMailFrom   := GETMV( "MV_RELFROM" ) //alterado por Adriana para corrigir problema na autenticacao do email 11/06/19 
Local lMailAuth   := GETMV( "MV_RELAUTH",,.F. )
Local lAutentic	  := .F.

//��������������������������������������������������������������Ŀ
//� Envia email                                                  �
//����������������������������������������������������������������
If !Empty(cMailServer) .And. !Empty(cMailConta) 

   CONNECT SMTP SERVER cMailServer ACCOUNT cMailConta PASSWORD cMailSenha RESULT lOk
   
   //-- Faz autenticacao no servidor //alterado por Adriana para corrigir problema na autenticacao do email 11/06/19 

	if lAutentic = .F.
		IF lMailAuth
			lAutentic := MailAuth(cMailConta, cMailSenha)
		ELSE
			lAutentic := .T.
		ENDIF
	ENDIF


   //��������������������������������������������������������������Ŀ
   //� Envia o email                                                �
   //����������������������������������������������������������������
   If lOk .And. lAutentic
   	  Conout("Rotina ADPNM001 - Empresa "+_cEmp+" SMTP OK.")     //incluido por Adriana para acompanhar envio em 11/06/19 
      If ( MailSend( cMailFROM, {cEmail}, {}, {}, cSubject, cMensagem, aFiles, lText ))
         lEnvioOK := .T.
      EndIf
   Else
   	  Conout("Rotina ADPNM001 - Empresa "+_cEmp+" SMTP nao Autenticou."+iif(lOk,"lOk=.t.","lOk=.F.")+iif(lAutentic,"lAutentic=.T.","lAutentic=.F."))     //incluido por Adriana para acompanhar envio em 11/06/19 
   EndIf
   MailSmtpOff()
EndIf

Return( lEnvioOK )  

Static Function logZBN(cStatus)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local aArea	:= GetArea()
	
	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADPNM001'))
	
		RecLock("ZBN",.F.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_ROTINA	:= 'ADPNM001'
			ZBN_DESCRI  := 'Leitura e Apontamento de Marca��es de Ponto-Adoro'
			ZBN_DATA    := dDataBase
			ZBN_HORA    := TIME()
			ZBN_PERIOD  := '1'
			ZBN_PERDES  := 'DIA'
			ZBN_QTDVEZ  := 1
			ZBN_HORAIN  := '08:00:00'
			ZBN_DATAPR  := dDataBase + 1
			ZBN_HORAPR  := '08:00:00'
			ZBN_STATUS	:= cStatus
			
		MsUnlock() 
		
	Else
	
		RecLock("ZBN",.T.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_ROTINA	:= 'ADPNM001'
			ZBN_DESCRI  := 'Leitura e Apontamento de Marca��es de Ponto-Adoro'
			ZBN_DATA    := dDataBase
			ZBN_HORA    := TIME()
			ZBN_PERIOD  := '1'
			ZBN_PERDES  := 'DIA'
			ZBN_QTDVEZ  := 1
			ZBN_HORAIN  := '08:00:00'
			ZBN_DATAPR  := dDataBase + 1
			ZBN_HORAPR  := '08:00:00'
			ZBN_STATUS	:= cStatus
	
		MsUnlock() 	
	
	EndIf
	
	ZBN->(dbCloseArea())
		
	RestArea(aArea)

Return Nil
