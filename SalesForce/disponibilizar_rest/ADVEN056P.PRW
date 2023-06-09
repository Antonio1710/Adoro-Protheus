#Include "Totvs.ch"
#Include "Restful.ch"

User Function ADVEN056P()
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �emailxml     �Autor  �Everson      � Data �  09/10/2017     ���
�������������������������������������������������������������������������͹��
���Desc.     �Servi�o REST para atualiza��o de e-mail de receb. XML.      ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
WsRestFul emailxml Description "Servi�o REST para atualiza��o de receb. XML de clientes."

	WsMethod Put Description "Atualiza e-mail de receb. XML de clientes. "   WsSyntax "/emailxml"

End WsRestFul

WsMethod Put WsService emailxml

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aArea			:= GetArea()
	Local cCRLF			:= Chr(13) + Chr(10)
	Local cFormatAceito := "application/json"
	Local cBody 		:= Self:GetContent()
	Local cFormato		:= Alltrim(cValToChar(Self:GetAccept()))
	Local cContentType	:= Self:GetHeader("Content-Type")
	Local cCodUsuario	:= Self:GetHeader("UsrVend")
	Local cNumPed		:= ""
	Local oParseJSON
	Local cJsonResp		:= ""
	Local cCodCli		:= ""
	Local cLojaCli		:= ""
	Local cEmail		:= ""
	Local aParametros	:= Self:aURLParms
	Local cCodLoja		:= ""
	Local cUrlServ		:= Self:GetPath()
	Private cHoraExec	:= Time()

	U_ADINF009P('ADVEN056P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Servi�o REST para atualiza��o de e-mail de receb. XML')
	
	//
	Self:SetContentType(cFormatAceito)
	
	//
	If Len(aParametros) == 0
	
	   //
	   //Static Call(ADVEN075P,grvLog,cCodUsuario,"",cCodLoja,cBody,"Obrigat�rio informar o c�digo e loja do cliente.",cUrlServ,"PUT")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,"",cCodLoja,cBody,"Obrigat�rio informar o c�digo e loja do cliente.",cUrlServ,"PUT")

	
	   SetRestFault(400,EncodeUtf8("Obrigat�rio informar o c�digo e loja do cliente."))
	   RestArea(aArea)
	   Return .F.
	   
	EndIf
	
	//Obt�m o n�mero do pedido de venda.
	cCodLoja := Alltrim(cValToChar(aParametros[1]))
	
	//
	If Empty(cCodUsuario)

	   //
	   //Static Call(ADVEN075P,grvLog,cCodUsuario,"",cCodLoja,cBody,"C�digo de usu�rio n�o informado (UsrVend).",cUrlServ,"PUT")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,"",cCodLoja,cBody,"C�digo de usu�rio n�o informado (UsrVend).",cUrlServ,"PUT")

	
	   SetRestFault(403,EncodeUtf8("C�digo de usu�rio n�o informado (UsrVend)."))
	   RestArea(aArea)
	   Return .F.
	   
	EndIf
	
	//Atribui usu�rio.
	__cUserId := cCodUsuario
	
	//
	If ! FWJsonDeserialize(cBody, @oParseJSON)
	
		//
	    //Static Call(ADVEN075P,grvLog,cCodUsuario,"",cCodLoja,cBody,"Ocorreu erro na desserializa��o do Json.",cUrlServ,"PUT")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,"",cCodLoja,cBody,"Ocorreu erro na desserializa��o do Json.",cUrlServ,"PUT")
	
		SetRestFault(400,EncodeUtf8("Ocorreu erro na desserializa��o do Json."))
		RestArea(aArea)
		Return .F.
			
	EndIf
	
	//
	If cFormato <> cFormatAceito
	
	    //
	    //Static Call(ADVEN075P,grvLog,cCodUsuario,"",cCodLoja,cBody,"Formato de dados " + cFormato + ", no Accept do cabe�alho da requisi��o, n�o suportado.",cUrlServ,"PUT")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,"",cCodLoja,cBody,"Formato de dados " + cFormato + ", no Accept do cabe�alho da requisi��o, n�o suportado.",cUrlServ,"PUT")
	
		SetRestFault(400,EncodeUtf8("Formato de dados " + cFormato + ", no Accept do cabe�alho da requisi��o, n�o suportado."))
		RestArea(aArea)
		Return .F.
		
	ElseIf cContentType <> cFormatAceito
	
		//
	    //Static Call(ADVEN075P,grvLog,cCodUsuario,"",cCodLoja,cBody,"Formato de dados " + cContentType + ", no Content-Type do cabe�alho da requisi��o, n�o suportado.",cUrlServ,"PUT")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,"",cCodLoja,cBody,"Formato de dados " + cContentType + ", no Content-Type do cabe�alho da requisi��o, n�o suportado.",cUrlServ,"PUT")
	
		SetRestFault(400,EncodeUtf8("Formato de dados " + cContentType + ", no Content-Type do cabe�alho da requisi��o, n�o suportado."))
		RestArea(aArea)
		Return .F.
	
	ElseIf Empty(cBody)
	
		//
	    //Static Call(ADVEN075P,grvLog,cCodUsuario,"",cCodLoja,cBody,"Json n�o encontrado no corpo da requisi��o.",cUrlServ,"PUT")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,"",cCodLoja,cBody,"Json n�o encontrado no corpo da requisi��o.",cUrlServ,"PUT")
	
		SetRestFault(400,EncodeUtf8("Json n�o encontrado no corpo da requisi��o."))
		RestArea(aArea)
		Return .F.
						
	EndIf
	
	//Atribui usu�rio.
	cCodCli		:= Alltrim(cValToChar(Substr(cCodLoja,1,6)))
	cLojaCli	:= Alltrim(cValToChar(Substr(cCodLoja,7,2)))
	cEmail		:= FwNoAccent(Alltrim(cValToChar(oParseJSON:A1_EMAIL)))
	
	FreeObj(oParseJSON)
	oParseJSON := Nil
	
	//Valida e-mail.
/*	If ! IsEmail(cEmail)
		SetRestFault(400,EncodeUtf8("E-mail " + cEmail +  " inv�lido."))
		RestArea(aArea)
		Return .F.
		
	EndIf*/
	
	//Localiza o cliente.
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	If ! SA1->(DbSeek(xFilial("SA1") + cCodCli + cLojaCli))
	
		//
	    //Static Call(ADVEN075P,grvLog,cCodUsuario,"",cCodLoja,cBody,"Cliente n�o encontrado " + cCodCli + "/" + cLojaCli + ".",cUrlServ,"PUT")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,"",cCodLoja,cBody,"Cliente n�o encontrado " + cCodCli + "/" + cLojaCli + ".",cUrlServ,"PUT")
	
		SetRestFault(404,EncodeUtf8("Cliente n�o encontrado " + cCodCli + "/" + cLojaCli + "."))
		RestArea(aArea)
		Return .F.
			
	EndIf
	
	//Atualiza o e-mail para recebimento de xml.
	RecLock("SA1",.F.)
		Replace SA1->A1_EMAIL With cEmail
	MsUnlock()
	
	SA1->(DbCloseArea())
	
	//
	Self:SetResponse('')
	
	//
	cHoraExec := ELAPTIME(cHoraExec, Time())
	//Static Call(ADVEN075P,grvLog,cCodUsuario,"",cCodLoja,cBody,"",cUrlServ,"PUT",cHoraExec)
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	u_VEN075A0(cCodUsuario,"",cCodLoja,cBody,"",cUrlServ,"PUT",cHoraExec)

	
	RestArea(aArea)
	
Return .T.
