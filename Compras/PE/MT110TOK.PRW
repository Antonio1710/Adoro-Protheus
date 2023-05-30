#Include 'Protheus.ch'
#include 'AP5mail.ch'
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMTA110OK  บ Autor ณ Everson            บ Data ณ  29/08/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณ Valida inclusใo de Solicita็ใo de Compra.                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras.                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑบAdriana     ณ24/05/2019ณTI-Devido a substituicao email para shared     บฑฑ
ฑฑบ            ณ          ณrelay, substituido MV_RELACNT p/ MV_RELFROM    บฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
@history Everson, 16/02/2023, ticket 88099 - Adicionado log para Op/Os. 
@history Antonio Domingos, 03/05/2023, ticket 92837 - Altera็ใo Mensagem de inclusใo de solicita็ใo de compras
@history Antonio Domingos, 15/05/2023, ticket 93540 - Erro no Sistema Protheus - Gerar Pedido para CTE.
/*/
User Function MT110TOK()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declara็ใo de variแveis                                             ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local aArea        := GetArea()
	Local cFiliais     := Alltrim(cValToChar(GetMv("MV_#GERCFI"))) //Everson- 23/11/2016. Chamado 031436.
	Local cUsuarios    := Alltrim(cValToChar(GetMv("MV_#USERFI"))) //Everson- 26/10/2016. Chamado 029625.
	Local cCodUserComp := ""
	Local nCont        := 0
	Local nPosCod      := Ascan( aHeader, { |x| Alltrim( x[2] ) == "C1_PRODUTO"} )
	Local nPosUM       := Ascan( aHeader, { |x| Alltrim( x[2] ) == "C1_UM" 	} )
	Local nPosItem     := Ascan( aHeader, { |x| Alltrim( x[2] ) == "C1_ITEM" 	} )
	Local lRet         := .T.
		Local nPosGrComp   := Ascan( aHeader, { |x| Alltrim( x[2] ) == "C1_XGRCOMP" } )
	//Antonio Domingos, 15/05/2023, ticket 93540
	Local _cGrCompra   := acols[1][nPosGrComp]
	Local cDescGrComp  := If(alltrim(funname())<>"MATA110".OR.Empty(_cGrCompra),"Normal",Upper(If(_cGrCompra=="1","Normal","Urgente"))) //Antonio Domingos, 03/05/2023, ticket 92837
	
	//Everson - 16/02/2023 - ticket 88099.		
	Local nPosOP	   := Ascan( aHeader, { |x| Alltrim( x[2] ) == "C1_OP"} )

	//tratamento para regra do execAuto - Chamado: 037886 - Fernando Sigoli 07/11/2017
	If(Type("lRotHabil")=="U")
		lRotHabil := .T.
	EndIf	

	//Everson- 23/11/2016. Chamado 031436.
	If  cFilAnt $(cFiliais) .And. Empty(Alltrim(cValToChar(CCODCOMPR)))
		MsgStop("ษ necessแrio informar o c๓digo do comprador.","Fun็ใo MTA110OK")
		RestArea(aArea) 
		Return .F.
		
	EndIf
	
	//Everson- 29/08/2016. Valida ponto de entrada MT110TEL.
	//Everson- 29/08/2016. Valida variแvel p๚blica cGrCompra.
	//Criada no ponto de entrada MT110TEL.
	If lRotHabil .And. Type("cGrCompra") == "C" .And. Empty(Alltrim(cValToChar(cGrCompra)))
		MsgStop("ษ necessแrio informar o campo Tp. Compra.","Fun็ใo MTA110OK")
		RestArea(aArea)
		Return .F.
			
	EndIf
	
	//Everson- 01/11/2016. Chamado 029625.
	//Verifica se serแ enviado e-mail ao comprador(o c๓digo do usuแrio do comprador deve estar no parโmetro MV_#USERFI).
	cCodUserComp := Posicione("SY1",1,xFilial("SY1") + Alltrim(cValToChar(CCODCOMPR)),"Y1_USER")
	If (Alltrim(cValToChar(cCodUserComp)) $(cUsuarios))
	
		PswOrder(1)
		If PswSeek( Alltrim(cValToChar(cCodUserComp)), .T. )
			cEmailComp := Alltrim(cValToChar(PSWRET()[1][14])) // Retorna vetor com informa็๕es do usuแrio
			MsAguarde({||enviarEmail("Inclusใo de Solicita็ใo de Compra Filial: "+cFilAnt+" - "+cDescGrComp,"Incluํda a solicita็ใo de compra " +; //Antonio Domingos, 03/05/2023, ticket 92837
				" Filial: "+cFilAnt+" Numero: "+Alltrim(cValToChar(CA110NUM)) + ".",cEmailComp)},"Envio de E-mail",cEmailComp) //Antonio Domingos, 03/05/2023, ticket 92837
			
		EndIf
	
	EndIF
	
	// *** INICIO CHAMADO 041667 || CONTROLADORIA || REINALDO_FRANCISCHINELLI || REGRA COPIA SC WILLIAM COSTA 24/05/2018 *** //
	IF lCopia == .T.
	
		FOR nCont:=1 TO LEN(aCols)
		
			IF Acols[nCont][nPosUM] <> Posicione("SB1",1,xFilial("SB1")+Acols[nCont][nPosCod],"B1_UM")
			
				MsgAlert("OLม " + Alltrim(cUserName)                                                  + CHR(10) + CHR(13)+;
				         " ITEM: " +Acols[nCont][nPosItem]                                                               +;
				         " PRODUTO: " +ALLTRIM(Acols[nCont][nPosCod])                                 + CHR(10) + CHR(13)+;
				         "NรO ษ PERMITIDO GERAR COPIA DE SOLICITACAO DE COMPRA COM UNIDADE DE MEDIDA"                    +;
				         " DIFERENTE DO CADASTRO DE PRODUTO"                                          + CHR(10) + CHR(13)+;
				         " UM SC: "+Acols[nCont][nPosUM]                                                                 +;
				         " UM PROD: " + Posicione("SB1",1,xFilial("SB1")+Acols[nCont][nPosCod],"B1_UM"), "MT110TOK-01")
				lRet:= .F.
				EXIT
			
			ENDIF
		NEXT
	ENDIF
	
	// *** FINAL CHAMADO 041667 || CONTROLADORIA || REINALDO_FRANCISCHINELLI || REGRA COPIA SC WILLIAM COSTA 24/05/2018 *** //

	//Everson - 16/02/2023 - ticket 88099.
	If lRet .And. nPosOP > 0

		For nCont := 1 To Len(aCols)

			If ! Empty(aCols[nCont][nPosOP])

				U_ADMNT220(aCols[nCont][nPosOP], "", Iif(INCLUI, "INCLUSรO ", "ALTERAวรO ") + "DE SOLICITAวรO DE COMPRA " + CA110NUM, "")
				Exit

			EndIf

		Next nCont

	EndIf
	
	RestArea(aArea)
	
Return(lRet)
/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณenviarEmail บ Autor ณ Everson         บ Data ณ  01/11/2016 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณEnvia e-mail para o comprador indicado na SC.               บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Compras.                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
/*/
Static Function enviarEmail(cAssunto,cMensagem,email)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declara็ใo de variแvies.
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	 Local lOk           := .T.
	 Local cBody         := cMensagem
	 Local cErrorMsg     := ""
	 Local aFiles        := {}
	 Local cServer       := Alltrim(GetMv("MV_RELSERV"))
	 Local cAccount      := AllTrim(GetMv("MV_RELACNT"))
	 Local cPassword     := AllTrim(GetMv("MV_RELPSW"))
	 Local cFrom         := AllTrim(GetMv("MV_RELFROM")) //Por Adriana em 24/05/2019 substituido MV_RELACNT por MV_RELFROM
	 Local cTo           := email
	 Local lSmtpAuth     := GetMv("MV_RELAUTH",,.F.)
	 Local lAutOk        := .F.
	 Local cAtach        := ""   
	 Local cSubject      := ""
	
	//Assunto do e-mail.
	 cSubject := cAssunto
	 
	 //Conecta ao servidor SMTP.
	 Connect Smtp Server cServer Account cAccount  Password cPassword Result lOk
	 
	 If !lAutOk
	    If ( lSmtpAuth )
	       lAutOk := MailAuth(cAccount,cPassword)
	       
	    Else
	       lAutOk := .T.
	       
	    EndIf
	    
	 EndIf
	 
	 If lOk .And. lAutOk   
	    
	    //Envia o e-mail.     
	    Send Mail From cFrom To cTo Subject cSubject Body cBody ATTACHMENT cAtach Result lOk  
	     
	    //Tratamento de erro no envio do e-mail.          
	    If !lOk
	       Get Mail Error cErrorMsg
	       ConOut("3 - " + cErrorMsg)
	       
	    EndIf
	    
	 Else
	    Get Mail Error cErrorMsg
	    ConOut("4 - " + cErrorMsg)
	    
	 EndIf
	 
	 If lOk
	    Disconnect Smtp Server
	    
	 EndIf
	
Return Nil
