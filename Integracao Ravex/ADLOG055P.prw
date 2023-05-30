#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"   
#INCLUDE "XMLXFUN.CH"  

/*{Protheus.doc} User Function ADLOG055P
	Programa consumir de webservice ravex para Exporta��o de Pedidos Ravex
	@type  Function
	@author WILLIAM COSTA
	@since 08/04/2019
	@version 01
	@history Chamado 058323 - WILLIAM COSTA - 20/05/2020 - Adicionado no NOACENTO o Apostofro para retirar 
	@history Chamado 058410 - WILLIAM COSTA - 27/05/2020 - Adicionado AND no SELECT para liberar
	@history Chamado 058578 - WILLIAM COSTA - 02/06/2020 - Adicionado a quantidade de Caixas no envio do Ravex para Roteiriza��o.
	@history Chamado 060513 - Everson       - 17/08/2020 - Criado par�metro para determinar o tamanho do lote de envio de pedidos ao Ravex.
	@history Chamado 1892   - WILLIAM COSTA - 24/09/2020 - Refeito logico de Peso Bruto e Peso Liquido do Objeto OWSPEDIDO, capa do pedido, pois as vezes os pesos brutos e liquidos se perder, fazendo a somatoria pelos Itens, sempre funciona, ent�o foi feita a altera��o e validado
	@history Chamado 67991  - Everson       - 27/04/2022 - Tratamento para informar se o pedido foi reprogramado.
	@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
	@history Ticket 78062   - Everson       - 29/11/2022 - Tratamento para enviar de pedidos de venda vinculados a fornecedor.
	@history Ticket 78062   - Everson       - 30/11/2022 - Corre��o errorlog.
	@history Ticket TI      - Sigoli        - 24/05/2025 - tratamento Nova Empres Vista
*/
User Function ADLOG055P()

	Private oWs         := NIL
	Private OWSPEDIDO   := NIL
	Private OWSITEM     := NIL
	Private oResp       := ''
	Private aSays       := {}
	Private aButtons    := {}   
	Private cCadastro   := "Exporta��o Ravex"    
	Private nOpca       := 0
	Private cPerg       := 'ADLOG055P' 
	Private nId         := 0
	Private cErro       := ''
	Private cCFOP       := "( "+Alltrim(GETMV("MV_#CFOPRD"))+" )"
	Private cEndereco   := ''
	Private cBairro     := ''
	Private cCidade     := '' 
	Private cCep        := ''
	Private cEstado     := ''
	Private nLTRC       := 0
	Private nTotReg     := 0
	Private cPedidos    := ''
	Private aRot        := {}      
	Private aRots       := {}
	Private nLote       := GetMv("MV_#RAVLT",,200)//200 //Everson - 17/08/2020. Chamado 060513.
	Private nLoteIni    := 0
	Private nLoteFin    := 0
	Private cRetXML     := ''
		
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Programa consumir de webservice ravex para Importacao de Pedidos Ravex')
	
	//+------------------------------------------------+
	//|Cria grupo de perguntas.                        |
	//+------------------------------------------------+
	 //@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
	 //MontaPerg()
	 Pergunte(cPerg,.T.)
	 
	 //+-----------------------------------------------+
	//|Monta Form Batch - Interface com o usu�rio.     |            
	//+------------------------------------------------+
	Aadd(aSays,"Este programa tem a finalidade de Consumir WebService Ravex " )
	Aadd(aSays,"Exportar Pedidos para o Ravex" )
    
	Aadd(aButtons, { 5,.T.,{|o| Pergunte(cPerg,.T.) }})
	Aadd(aButtons, { 1,.T.,{|o| nOpca:=1, o:oWnd:End(), Processa({||IMPORTPED()},"Consumindo WebService","Aguarde...")}})
	Aadd(aButtons, { 2,.T.,{|o| nOpca:=2, o:oWnd:End() }})
	
	FormBatch(cCadastro, aSays, aButtons) 
	
RETURN(NIL)

STATIC FUNCTION IMPORTPED()

	oWs := WSSiviraFullWebService():New() //WSSiviraFullWebService():New()

	oWs:cLogin := 'adoro_user_ws'
	oWs:cSenha := 'SdUdWSdA'
	 
	//se a pergunta n�o tiver preenchida corretamente da mensagem de erro.
	IF EMPTY(MV_PAR01)         .OR.;
	   EMPTY(MV_PAR01)         .OR.;
       ALLTRIM(MV_PAR04) == ''       
       
    	MSGSTOP("OL� " + Alltrim(cUserName) + ", Par�metros n�o cadastrados corretamente, impossivel continuar.", "ADLOG055P-01")
    	 
	    RETURN(NIL)   
       
    ENDIF  
    
	SqlPedidos()             
	nTotReg  := Contar("TRC","!Eof()")
	nLoteIni := 1
	nLoteFin := nTotReg / nLote
	ProcRegua(nTotReg)
	TRC->(DbGoTop())

	//Everson - 29/11/2022 - ticket 78062.
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	
	//Everson - 29/11/2022 - ticket 78062.
	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))
	SA2->(DbGoTop())
	
	While TRC->(!EOF())
	
		nLTRC := nLTRC + 1 //soma linha do n�
		IncProc("PV: " + TRC->C5_NUM + ' Tot Ped: ' + CVALTOCHAR(nLTRC) + '/' +  CVALTOCHAR(nTotReg) + ' Tot Lote: ' + CVALTOCHAR(nLoteIni) + '/' +  CVALTOCHAR(nLoteFin))
		
		//Aadd(aClientes,u_ADLOG043P(TRC->C5_CLIENTE,TRC->C5_LOJACLI)) //Enviar o Cliente para o Ravex
		
		cEndereco  := ''
		cBairro    := ''
		cCidade    := '' 
		cCep       := ''

		//Everson - 29/11/2022 - ticket 78062.
		cLatitude  := ''
		cLongitude := ''
		cNome	   := ''
		cCNPJ 	   := ''

		//Everson - 29/11/2022 - ticket 78062.
		If TRC->C5_TIPO == "B"

			If ! SA2->(DbSeek( FWxFilial("SA2") + TRC->C5_CLIENTE + TRC->C5_LOJACLI ) )
				TRC->(DbSkip())
				Loop

			EndIf

			cEndereco  	:= SA2->A2_END
			cBairro    	:= SA2->A2_BAIRRO
			cCidade    	:= SA2->A2_MUN
			cCep       	:= SA2->A2_CEP
			cEstado    	:= SA2->A2_EST
			cLatitude 	:= SA2->A2_XLATITU
			cLongitude	:= SA2->A2_XLONGIT
			cNome		:= SA2->A2_NOME
			cCNPJ		:= SA2->A2_CGC
			
		Else

			If ! SA1->(DbSeek( FWxFilial("SA1") + TRC->C5_CLIENTE + TRC->C5_LOJACLI ) )
				TRC->(DbSkip())
				Loop

			EndIf

			cLatitude 	:= SA1->A1_XLATITU
			cLongitude	:= SA1->A1_XLONGIT
			cNome		:= SA1->A1_NOME
			cCNPJ		:= SA1->A1_CGC
			
			//Ticket 78062   - Everson       - 30/11/2022.
			IF Alltrim(SA1->A1_SATIV1)="50" .and. Alltrim(SA1->A1_SATIV2)$"51,52,53"

				cEndereco  := SA1->A1_ENDENT
				cBairro    := SA1->A1_BAIRROE
				cCidade    := SA1->A1_MUNE
				cCep       := SA1->A1_CEPE
				cEstado    := SA1->A1_ESTE

			ElseIf SA1->A1_IMPENT = "S" //Adoro  para endere�o de entrega diferente e cozinha industrial    

				cEndereco  := SA1->A1_ENDENT
				cBairro    := SA1->A1_BAIRROE
				cCidade    := SA1->A1_MUNE
				cCep       := SA1->A1_CEPE
				cEstado    := SA1->A1_ESTE

			Else 

				cEndereco  := SA1->A1_END
				cBairro    := SA1->A1_BAIRRO
				cCidade    := SA1->A1_MUN 
				cCep       := SA1->A1_CEP
				cEstado    := SA1->A1_EST

			Endif	

		EndIf
		
		OWSPEDIDO                      := SiviraFullWebService_PEDIDO():New()
		OWSPEDIDO:CBAIRROCLIENTE       := ALLTRIM(NOACENTO2(cBairro))
		OWSPEDIDO:CCEPCLIENTE          := ALLTRIM(cCep)
		OWSPEDIDO:CCIDADECLIENTE       := ALLTRIM(NOACENTO2(cCidade))
		OWSPEDIDO:CCNPJCLIENTE         := Iif(TRC->C5_TIPO == "B", ALLTRIM(cCNPJ), Alltrim(TRC->C5_CLIENTE + TRC->C5_LOJACLI))  //Everson - 29/11/2022 - ticket 78062.
		OWSPEDIDO:CCNPJREMETENTE       := ALLTRIM(RetField('SM0',1,cEmpAnt+cFilAnt,'M0_CGC'))
		OWSPEDIDO:CCNPJUNIDADE         := ALLTRIM(RetField('SM0',1,cEmpAnt+cFilAnt,'M0_CGC'))
		OWSPEDIDO:CDATAPEDIDO          := SUBSTR(TRC->C5_DTENTR,1,4)+ '-' + SUBSTR(TRC->C5_DTENTR,5,2)+ '-' + SUBSTR(TRC->C5_DTENTR,7,2) +  "T" + '00:00:00'
		OWSPEDIDO:CENDERECOCLIENTE     := ALLTRIM(NOACENTO2(cEndereco))
		OWSPEDIDO:CESTADOCLIENTE       := ALLTRIM(cEstado)
		OWSPEDIDO:CESTIMATIVAENTREGA   := SUBSTR(TRC->C5_DTENTR,1,4)+ '-' + SUBSTR(TRC->C5_DTENTR,5,2)+ '-' + SUBSTR(TRC->C5_DTENTR,7,2) +  "T" + '00:00:00' 
		OWSPEDIDO:CNOMECLIENTE         := NoAcento2(cNome) //Everson - 29/11/2022 - ticket 78062.
		OWSPEDIDO:CNUMERO              := TRC->C5_NUM
		OWSPEDIDO:CORDEMCARREGAMENTO   := ALLTRIM(TRC->C5_ROTEIRO)
		OWSPEDIDO:NCUBAGEM             := 0
		OWSPEDIDO:NIDEMBARCADOR        := 0
		OWSPEDIDO:NIDREMETENTE         := 0
		OWSPEDIDO:NIDUNIDADE           := 0  
		OWSPEDIDO:NLATITUDECLIENTE     := VAL(STRTRAN(cLatitude,',','.'))  //Everson - 29/11/2022 - ticket 78062.
		OWSPEDIDO:NLONGITUDECLIENTE    := VAL(STRTRAN(cLongitude,',','.')) //Everson - 29/11/2022 - ticket 78062.
		OWSPEDIDO:NPESOBRUTO           := BUSCAPBRUTO(TRC->C5_NUM,TRC->C5_PBRUTO) //TRC->C5_PBRUTO
		OWSPEDIDO:NPESOLIQUIDO         := BUSCAPLIQUI(TRC->C5_NUM,TRC->C5_PESOL) //TRC->C5_PESOL
		OWSPEDIDO:NQTDEVOLUMES         := TRC->C5_VOLUME1
		OWSPEDIDO:NSEQUENCIAPROGRAMADA := VAL(TRC->C5_SEQUENC)
		OWSPEDIDO:NVALORPEDIDO         := TRC->C5_XTOTPED
		OWSPEDIDO:NIDOPERADORLOGISTICO := 0
		OWSPEDIDO:NQTDECAIXAS          := TRC->C5_VOLUME1

		OWSPEDIDO:lREENTREGA           := Iif(Alltrim(cValToChar(TRC->C5_PRIOR)) == "R", .T., .F.) //Everson - 27/04/2022. Chamado 67991.

		cPedidos                       := cPedidos + IIF(ALLTRIM(cPedidos) == '',TRC->C5_NUM,';' + TRC->C5_NUM)
					
		AAdd(oWs:OWSPEDIDOS:OWSPEDIDO, OWSPEDIDO)
		
		/////// ************INICIO CRIA VETOR E VARIAVEIS DE ITENS******************************************
		oWs:OWSPEDIDOS:OWSPEDIDO[nLTRC]:OWSITENS := SiviraFullWebService_ArrayOfItemPedido():New() 
		/////// ************FINAL CRIA VETOR E VARIAVEIS DE ITENS******************************************
		
		SqlItens(TRC->C5_NUM)
		While TRD->(!EOF()) 
		
			//IncProc("Item PV: " + TRD->C6_PRODUTO + '||' + ALLTRIM(TRD->B1_DESC))
			
			OWSITEM                := SiviraFullWebService_ItemPedido():New()    
			OWSITEM:CCODIGO        := ALLTRIM(TRD->C6_PRODUTO)
			OWSITEM:CDESCRICAO     := ALLTRIM(TRD->B1_DESC)
			OWSITEM:CUNIDADE       := ALLTRIM(TRD->C6_UM)
			OWSITEM:NCUBAGEM       := 0
			OWSITEM:NPESOBRUTO     := TRD->PESOBRUTO
			OWSITEM:NPESOLIQUIDO   := TRD->C6_QTDVEN
			OWSITEM:NQUANTIDADE    := TRD->C6_QTDVEN
			OWSITEM:NVALORUNITARIO := TRD->C6_PRCVEN
			
			AAdd(oWs:OWSPEDIDOS:OWSPEDIDO[nLTRC]:OWSITENS:OWSITEMPEDIDO, OWSITEM)
				
			TRD->(dbSkip())
		ENDDO //FECHA WHILE DO TRE
		
		TRD->(dbCloseArea())

		aRot := {}
		AAdd(aRot,DTOC(STOD(TRC->C5_DTENTR)))
		AAdd(aRot,TRC->C5_ROTEIRO)
		AAdd(aRot,TRC->C5_NUM)
		AAdd(aRots,aRot) 

		IF nLTRC == nLote .AND. nTotReg > nLote

			ENVIOWSRAVEX()
			nLTRC    := 0
			nLoteIni := nLoteIni + 1
			nTotReg  := nTotReg - nLote

		ENDIF
			
		TRC->(dbSkip())
	
	ENDDO //FECHA WHILE DO TRC
	nLTRC := 0 // Zera o contador de linha do SQL TRC  
	TRC->(dbCloseArea())

	IncProc("Enviando Pedidos para o WebService Ravex") 

	ENVIOWSRAVEX()
	
	u_GrLogZBE (Date(),TIME(),cUserName," RAVEX - EXPORTAR PEDIDOS","LOGISTICA","ADLOG055P",IIF(nId == 1,"Pedidos com Sucesso: " + cPedidos,"Pedidos com Erro: " + cPedidos),ComputerName(),LogUserName())
		
	IF LEN(aRots) > 0
    
		cMetodo := 'Roteiro'
	    nId     := 1
    	EmailViagem('Roteiro',nId,'IMPORTA_ROTEIRO')
    
    ENDIF     

	IncProc("Processamento Finalizado")        
	
RETURN(NIL)

STATIC FUNCTION ENVIOWSRAVEX()
	
	IF oWs:ImportarPedidos()

		oResp   := oWs:oWSImportarPedidosResult
		cRetXML += ORESP:CMENSAGEM + CHR(13) + CHR(10) + CHR(13) + CHR(10)  
		nId     := 1  
		
	ELSE
		
		nId   := -1
		aRots := {}
		cErro := GetWSCError()
		MsgStop("OL� " + Alltrim(cUserName) + CHR(13) + CHR(10) + ;
				"Roteiro Inicial: " + MV_PAR03 + " Roteiro Final: " + MV_PAR04 + CHR(13) + CHR(10) + ;
				"Com erro entre em contato com a T.I." + CHR(13) + CHR(10) + ;
				"Msg Erro: " + GetWSCError(), "ADLOG055P-03")
		
	ENDIF

RETURN(NIL)	

//STATIC FUNCTION MontaPerg()  
//                                
//	Private bValid := NIL 
//	Private cF3    := NIL
//	Private cSXG   := NIL
//	Private cPyme  := NIL
//	
//	U_xPutSx1(cPerg,'01','Data Entrega de  ?','','','mv_ch01','D',08,0,0,'G',bValid,cF3  ,cSXG,cPyme,'MV_PAR01')
//	U_xPutSx1(cPerg,'02','Data Entrega Ate ?','','','mv_ch02','D',08,0,0,'G',bValid,cF3  ,cSXG,cPyme,'MV_PAR02')
//	U_xPutSx1(cPerg,'03','Roteiro Ini de   ?','','','mv_ch03','C',03,0,0,'G',bValid,cF3  ,cSXG,cPyme,'MV_PAR03')
//	U_xPutSx1(cPerg,'04','Roteiro Fin Ate  ?','','','mv_ch04','C',03,0,0,'G',bValid,cF3  ,cSXG,cPyme,'MV_PAR04')
//	
//    Pergunte(cPerg,.T.)
//	
//RETURN(NIL)

STATIC FUNCTION NoAcento2(cString)

	Local cChar  := ""
	Local nX     := 0 
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "�����"+"�����"
	Local cCircu := "�����"+"�����"
	Local cTrema := "�����"+"�����"
	Local cCrase := "�����"+"�����" 
	Local cTio   := "����"
	Local cCecid := "��"
	Local cMaior := "&lt;"
	Local cMenor := "&gt;"
	
	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf		
			nY:= At(cChar,cTio)
			If nY > 0          
				cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
			EndIf		
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next
	
	If cMaior$ cString 
		cString := strTran( cString, cMaior, "" ) 
	EndIf
	If cMenor$ cString 
		cString := strTran( cString, cMenor, "" )
	EndIf
	
	cString := StrTran( cString, CRLF, " " )
	
	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|' 
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX

	//Especifico Adoro devido a erro XML n�o solucionado versao 3.10
	cString := StrTran(cString,"&","e")
	cString := StrTran(cString,"'","")
	
Return(cString)

STATIC FUNCTION EmailViagem(cMetodo,nId,cmensagem)

    Local cServer      := Alltrim(GetMv("MV_INTSERV"))  
    Local cAccount     := AllTrim(GetMv("MV_INTACNT"))
    Local cPassword    := AllTrim(GetMv("MV_INTPSW"))
    Local cFrom        := AllTrim(GetMv("MV_INTACNT"))
    Local cTo          := AllTrim(GetMv("MV_#USUENT"))
    Local lOk          := .T.  
    Local lAutOk       := .F. 
    Local lSmtpAuth    := GetMv("MV_RELAUTH",,.F.) 
    Local cSubject     := ""  
    Local cBody        := ""
    Local cAtach       := ""               
        
	//***************************** INICIO ENVIO DE EMAIL CONFIRMANDO A GERACAO DO PEDIDO DE VENDA **************
                            
    _cStatEml    := cMetodo 
    cBody        := RetHTML(_cStatEml,nId,cmensagem)
    lOk          := .T.  
    lAutOk       := .F. 
    Connect Smtp Server cServer Account cAccount Password cPassword Result lOk
	                        
	IF lAutOk == .F.
		IF ( lSmtpAuth )
			lAutOk := MailAuth(cAccount,cPassword)
	    ELSE
	        lAutOk := .T.
	    ENDIF
	ENDIF

	IF lOk .And. lAutOk     
	   cSubject := "WEBSERVICE ENVIO ROTEIROS"          
	   Send Mail From cFrom To cTo Subject cSubject Body cBody ATTACHMENT cAtach Result lOk                                           
	ENDIF            
	
	IF lOk
	   Disconnect Smtp Server
	ENDIF
				                        
    //****************************** FINAL ENVIO DE EMAIL CONFIRMANDO A GERACAO DO PEDIDO DE VENDA **************

RETURN(NIL)   

Static Function RetHTML(_cStatEml,nId,cmensagem)

	Local cRet       := "" 
	Local nContEmail := 0

	cRet := "<p <span style='"
	cRet += 'font-family:"Calibri"'
	cRet += "'><b>WEBSERVICE ENVIO ROTEIROS............: </b>" 
	cRet += "<br>"                                                                                        
	cRet += "<b>STATUS.............: </b>"
	
	IF _cStatEml == 'Roteiro' .AND. nId == 1 // viagem ok
 	
	   cRet += " WEBSERVICE ENVIO ROTEIROS COM SUCESSO"
	   cRet += "<br>"
	   cRet += "<br>"
	   
	   FOR nContEmail:=1 TO LEN(aRots)
	   
	   		cRet += 'Data de Entrega: ' + aRots[nContEmail][1] + ' Roteiro: ' + aRots[nContEmail][2] + ' Pedido: ' + aRots[nContEmail][3] + ' Roteiro Importado.' + "<br>"
	
	   NEXT

	   cRet += "<br>"
	   cRet += "<br>"
	   cRet += "Mensagem de Retorno WebService Ravex:"
	   cRet += cRetXML
	   
	ENDIF	
	
	IF (_cStatEml == 'Roteiro' .AND. nId == -1) .OR. ;
	   (_cStatEml == 'Roteiro' .AND. nId == 0 )      // Viagem com erro
 	
	   cRet += " WEBSERVICE ROTEIRO COM ERRO, favor verificar"
	   cRet += "<br>"
	   cRet += "<br>"
	   
	   cRet += 'Data de Entrega Ini: ' + DTOC(MV_PAR01) + ' Data de Entrega Fin: ' + DTOC(MV_PAR02) + ' e Roteiro Ini: ' + MV_PAR03 + ' Roteiro Fin: ' + MV_PAR04 + ' ' + cmensagem  + ' n�o encontrada no protheus'

	ENDIF  
	
	cRet += "<br>"
	cRet += "<br><br>ATT, <br> TI <br><br> E-mail gerado por processo automatizado."
	cRet += "<br>"
	cRet += '</span>'
	cRet += '</body>'
	cRet += '</html>'
      
Return(cRet)     

STATIC FUNCTION BUSCAPBRUTO(cNum,nPesoPed)

	Local nPeso := 0

	nPeso := nPesoPed

	SqlPeso(cNum)
	While TRE->(!EOF()) 
	
		nPeso := TRE->PESOBRUTO
			
		TRE->(dbSkip())
	ENDDO //FECHA WHILE DO TRE
	
	TRE->(dbCloseArea())

RETURN(nPeso)

STATIC FUNCTION BUSCAPLIQUI(cNum,nPesoPed)

	Local nPeso := 0

	nPeso := nPesoPed

	SqlPeso(cNum)
	While TRE->(!EOF()) 
	
		nPeso := TRE->PESOLIQ
			
		TRE->(dbSkip())
	ENDDO //FECHA WHILE DO TRE
	
	TRE->(dbCloseArea())

RETURN(nPeso)

STATIC FUNCTION SqlPedidos()

	Local cDtIni := DTOS(MV_PAR01)
    Local cDtFin := DTOS(MV_PAR02)	
     
    BeginSQL Alias "TRC"
			%NoPARSER% 
				SELECT SC5.C5_NUM,
				       SC5.C5_FILIAL,
				       SC5.C5_EMISSAO, 
					   SC5.C5_DTENTR,
					   SC5.C5_ROTEIRO,
					   SC5.C5_CLIENTE,
					   SC5.C5_LOJACLI,
					   SC5.C5_PBRUTO,
					   SC5.C5_PESOL,
					   SC5.C5_SEQUENC,
					   SC5.C5_XTOTPED,
					   SC5.C5_VOLUME1,
					   SC5.C5_PRIOR, //Everson - 27/04/2022. Chamado 67991.
					   SC5.C5_TIPO
				  FROM %Table:SC5% SC5 /*WITH(NOLOCK)*/ 
			     WHERE SC5.C5_FILIAL   = %EXP:FWXFILIAL('SC5')%
				   AND SC5.C5_DTENTR  >= %EXP:cDtIni%
				   AND SC5.C5_DTENTR  <= %EXP:cDtFin%
				   AND SC5.C5_ROTEIRO >= %EXP:MV_PAR03%
				   AND SC5.C5_ROTEIRO <= %EXP:MV_PAR04%
				   AND SC5.C5_NOTA     = '' 
				   AND SC5.C5_SERIE    = ''
				   AND SC5.%notDel%

				ORDER BY SC5.C5_FILIAL,SC5.C5_DTENTR,SC5.C5_ROTEIRO,SC5.C5_NUM
				
    EndSQl          

RETURN(NIL)

STATIC FUNCTION SqlItens(cNum)

	Local cWhere := ''
	
	cWhere := '%' + cCFOP + '%'
     
    BeginSQL Alias "TRD"
			%NoPARSER%
            SELECT C6_PRODUTO,
                   B1_DESC,
				   C6_UM,
			       C6_ENTREG, 
				   C6_QTDVEN,
			       CASE WHEN (SELECT TOP(1) ZC_TARA FROM  %TABLE:SZC%  SZC WITH(NOLOCK) WHERE ZC_UNIDADE = C6_SEGUM) IS NOT NULL THEN (C6_UNSVEN * (SELECT TOP(1) ZC_TARA FROM SZC010 WITH(NOLOCK) WHERE ZC_UNIDADE = C6_SEGUM)) ELSE 0 END + C6_QTDVEN AS PESOBRUTO,
			       C6_UNSVEN,
				   C6_PRCVEN 
		      FROM %TABLE:SC6% SC6 WITH(NOLOCK) 
		INNER JOIN %TABLE:SB1% SB1 WITH(NOLOCK) 
			    ON B1_FILIAL               = '  ' 
			   AND B1_COD                  = C6_PRODUTO
			   AND SB1.D_E_L_E_T_      <> '*' 
		     WHERE C6_FILIAL               = %EXP:FWXFILIAL('SC6')%
		       AND C6_NUM                  = %EXP:cNum%
		       AND (C6_QTDVEN - C6_QTDENT) > 0 
		       AND C6_CF              NOT IN %EXP:cWhere%
		       AND SC6.D_E_L_E_T_      <> '*'
		
			   ORDER BY C6_ITEM
	    		
    EndSQl          

RETURN(NIL)

STATIC FUNCTION SqlPeso(cNum)

	Local cWhere := ''
	
	cWhere := '%' + cCFOP + '%'
     
    BeginSQL Alias "TRE"
			%NoPARSER%
			SELECT SUM(PESOBRUTO) AS PESOBRUTO , SUM(PESOLIQ) AS PESOLIQ
              FROM (SELECT CASE WHEN (SELECT TOP(1) ZC_TARA FROM SZC010 WITH(NOLOCK) WHERE ZC_UNIDADE = C6_SEGUM) IS NOT NULL THEN (C6_UNSVEN * (SELECT TOP(1) ZC_TARA FROM SZC010 WITH(NOLOCK) WHERE ZC_UNIDADE = C6_SEGUM)) ELSE 0 END + C6_QTDVEN AS PESOBRUTO,
                           C6_QTDVEN AS PESOLIQ 
		              FROM %TABLE:SC6% SC6 WITH(NOLOCK) 
		              INNER JOIN %TABLE:SB1%  SB1 WITH(NOLOCK) 
			                  ON B1_FILIAL               = '  ' 
			                 AND B1_COD                  = C6_PRODUTO
			                 AND SB1.D_E_L_E_T_      <> '*' 
		                   WHERE C6_FILIAL               = %EXP:FWXFILIAL('SC6')%
		                     AND C6_NUM                  = %EXP:cNum%
		                     AND (C6_QTDVEN - C6_QTDENT) > 0 
		                     AND C6_CF              NOT IN %EXP:cWhere%
		                     AND SC6.D_E_L_E_T_      <> '*') AS FONTES
	    		
    EndSQl          

RETURN(NIL)
