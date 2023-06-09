#Include "Totvs.ch"
#Include "Restful.ch"

User Function ADVEN064P()
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �comissoes         � Autor � Everson   � Data �  18/12/2017  ���
�������������������������������������������������������������������������͹��
���Descricao �Servi�o REST para c�lculo de comiss�o.                      ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
WsRestFul comissoes Description "Servi�o REST para c�lculo de comiss�o."

	WsMethod Post Description "Retorno de valor de comiss�o do pedido."   WsSyntax "/comissoes"

End WsRestFul

WsMethod Post WsService comissoes
	
	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aArea			:= GetArea()
	Local cFormatAceito := "application/json"
	Local cFormato		:= Alltrim(cValToChar(Self:GetAccept()))
	Local cNumPed		:= ""
	Local cCodUsuario	:= Self:GetHeader("UsrVend")
	Local cResJson		:= ""
	Local cBody 		:= Self:GetContent()
	Local oParseJSON
	Local cHoraExec	    := Time()
	Local cUrlServ		:= Self:GetPath()

	U_ADINF009P('ADVEN064P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Servi�o REST para c�lculo de comiss�o')
	
	//
	Self:SetContentType(cFormatAceito)
	
	//Static Call(ADVEN075P,grvLog,cCodUsuario,"","","","",cUrlServ,"POST")
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	u_VEN075A0( cCodUsuario,"","","","",cUrlServ,"POST" )

	//
	If Empty(cCodUsuario)
		SetRestFault(403,EncodeUtf8("C�digo de usu�rio n�o informado (UsrVend)."))
		RestArea(aArea)
		Return .F.

	EndIf

	//Atribui usu�rio.
	__cUserId := cCodUsuario
	
	//
	If cFormato <> cFormatAceito
		SetRestFault(400,EncodeUtf8("Formato de dados " + cFormato + ", no Accept do cabe�alho da requisi��o, n�o suportado."))
		RestArea(aArea)
		Return .F.
		
	ElseIf Empty(cBody)
		SetRestFault(400,EncodeUtf8("Json n�o encontrado no corpo da requisi��o."))
		RestArea(aArea)
		Return .F.
				
	EndIf
	
	//
	If ! FWJsonDeserialize(cBody, @oParseJSON)
		SetRestFault(400,EncodeUtf8("Ocorreu erro na desserializa��o do Json."))
		RestArea(aArea)
		Return .F.

	EndIf
	
	//
	SC5->(DbCloseArea())
	
	//
	cResJson := jsonComissao(oParseJSON)
	
	//
	Self:SetResponse(EncodeUtf8(cResJson))
	
	//
	cHoraExec := ELAPTIME(cHoraExec, Time())
	//grvLog(cUsuario,cIdSF,cNumP,cJson,cErro,Url,cMetodo,cTmProc
	//Static Call(ADVEN075P,grvLog,cCodUsuario,"","","","",cUrlServ,"POST",cHoraExec)
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	u_VEN075A0( cCodUsuario,"","","","",cUrlServ,"POST",cHoraExec )

	//
	FreeObj(oParseJSON)
	oParseJSON := Nil
	RestArea(aArea)
	
Return .T.
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �jsonComissao      � Autor � Everson   � Data �  26/12/2017  ���
�������������������������������������������������������������������������͹��
���Descricao �Monta json com os dados de comiss�o.                        ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function jsonComissao(oParseJSON)
	
	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aArea			:= GetArea()
	Local nVlrComisso	:= 0
	Local cJson			:= ""
	
	//
	nVlrComisso := calcVlrComiss(oParseJSON)
	
	//
	cJson := '{'
	cJson += '"comissao":"' + Alltrim(cValToChar(Transform(nVlrComisso,"@E 999,999,999.99"))) + '"'
	cJson += '}'
	
	//
	RestArea(aArea)
	
Return cJson
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �calcVlrComiss     � Autor � Everson   � Data �  18/12/2017  ���
�������������������������������������������������������������������������͹��
���Descricao �Efetua o c�lculo do valor da comiss�o.                      ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function calcVlrComiss(oParseJSON)
	
	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aArea := GetArea()
	Local nVlr	:= 0
	
	//
	RestArea(aArea)
	
Return nVlr
