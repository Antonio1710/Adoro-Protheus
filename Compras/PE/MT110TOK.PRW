#Include 'Protheus.ch'
#include 'AP5mail.ch'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA110OK  � Autor � Everson            � Data �  29/08/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Valida inclus�o de Solicita��o de Compra.                  ���
�������������������������������������������������������������������������͹��
���Uso       � Compras.                                                   ���
�������������������������������������������������������������������������ͼ��
���Adriana     �24/05/2019�TI-Devido a substituicao email para shared     ���
���            �          �relay, substituido MV_RELACNT p/ MV_RELFROM    ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
@history Everson, 16/02/2023, ticket 88099 - Adicionado log para Op/Os. 
@history Antonio Domingos, 03/05/2023, ticket 92837 - Altera��o Mensagem de inclus�o de solicita��o de compras
@history Antonio Domingos, 15/05/2023, ticket 93540 - Erro no Sistema Protheus - Gerar Pedido para CTE.
/*/
User Function MT110TOK()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
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
		MsgStop("� necess�rio informar o c�digo do comprador.","Fun��o MTA110OK")
		RestArea(aArea) 
		Return .F.
		
	EndIf
	
	//Everson- 29/08/2016. Valida ponto de entrada MT110TEL.
	//Everson- 29/08/2016. Valida vari�vel p�blica cGrCompra.
	//Criada no ponto de entrada MT110TEL.
	If lRotHabil .And. Type("cGrCompra") == "C" .And. Empty(Alltrim(cValToChar(cGrCompra)))
		MsgStop("� necess�rio informar o campo Tp. Compra.","Fun��o MTA110OK")
		RestArea(aArea)
		Return .F.
			
	EndIf
	
	//Everson- 01/11/2016. Chamado 029625.
	//Verifica se ser� enviado e-mail ao comprador(o c�digo do usu�rio do comprador deve estar no par�metro MV_#USERFI).
	cCodUserComp := Posicione("SY1",1,xFilial("SY1") + Alltrim(cValToChar(CCODCOMPR)),"Y1_USER")
	If (Alltrim(cValToChar(cCodUserComp)) $(cUsuarios))
	
		PswOrder(1)
		If PswSeek( Alltrim(cValToChar(cCodUserComp)), .T. )
			cEmailComp := Alltrim(cValToChar(PSWRET()[1][14])) // Retorna vetor com informa��es do usu�rio
			MsAguarde({||enviarEmail("Inclus�o de Solicita��o de Compra Filial: "+cFilAnt+" - "+cDescGrComp,"Inclu�da a solicita��o de compra " +; //Antonio Domingos, 03/05/2023, ticket 92837
				" Filial: "+cFilAnt+" Numero: "+Alltrim(cValToChar(CA110NUM)) + ".",cEmailComp)},"Envio de E-mail",cEmailComp) //Antonio Domingos, 03/05/2023, ticket 92837
			
		EndIf
	
	EndIF
	
	// *** INICIO CHAMADO 041667 || CONTROLADORIA || REINALDO_FRANCISCHINELLI || REGRA COPIA SC WILLIAM COSTA 24/05/2018 *** //
	IF lCopia == .T.
	
		FOR nCont:=1 TO LEN(aCols)
		
			IF Acols[nCont][nPosUM] <> Posicione("SB1",1,xFilial("SB1")+Acols[nCont][nPosCod],"B1_UM")
			
				MsgAlert("OL� " + Alltrim(cUserName)                                                  + CHR(10) + CHR(13)+;
				         " ITEM: " +Acols[nCont][nPosItem]                                                               +;
				         " PRODUTO: " +ALLTRIM(Acols[nCont][nPosCod])                                 + CHR(10) + CHR(13)+;
				         "N�O � PERMITIDO GERAR COPIA DE SOLICITACAO DE COMPRA COM UNIDADE DE MEDIDA"                    +;
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

				U_ADMNT220(aCols[nCont][nPosOP], "", Iif(INCLUI, "INCLUS�O ", "ALTERA��O ") + "DE SOLICITA��O DE COMPRA " + CA110NUM, "")
				Exit

			EndIf

		Next nCont

	EndIf
	
	RestArea(aArea)
	
Return(lRet)
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �enviarEmail � Autor � Everson         � Data �  01/11/2016 ���
�������������������������������������������������������������������������͹��
���Descricao �Envia e-mail para o comprador indicado na SC.               ���
�������������������������������������������������������������������������͹��
���Uso       � Compras.                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function enviarEmail(cAssunto,cMensagem,email)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
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
