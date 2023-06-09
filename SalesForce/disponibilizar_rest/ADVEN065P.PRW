#include 'Fileio.ch'
#Include 'Totvs.ch'
#Include 'Restful.ch'
#Include 'AP5mail.ch'
#Include 'Topconn.ch'

#Include 'RPTDEF.ch'
#Include 'FWPrintSetup.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADVEN065P      �Autor  �Everson      � Data �  21/12/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Servi�o Rest para gera��o de relat�rios em html.            ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADVEN065P(cEmp,cFili,cVend,cCodigoSF,cJobAux) // U_ADVEN065P("01","02","000005","001W000000dH2gV")

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local cQuery 	:= ""
	Local cEmailVd	:= ""
	Local cUser 	:= ""
	Local cEmailSp	:= ""
	Local nHandle	:= 0
	Local nTamFile	:= 0
	Local cString	:= ""
	Local cHoraExec := Time()

	Private cNmRelRest := ""

	//Inicia o ambiente.
	RPCSetType(3)
	RpcSetEnv(cEmp,cFili,,,,GetEnvServer(),{ })	
	Conout("Inicializado processo ADVEN065P")

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Servi�o Rest para gera��o de relat�rios em html')
	
	//Static Call(ADVEN075P,grvLog,"",cCodigoSF,cVend,"","","ADVEN065P","POST")
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	u_VEN075A0("",cCodigoSF,cVend,"","","ADVEN065P","POST")

	//PutGlbValue(cJobAux,"1")
	//GlbUnlock()

	//Executa rotina para cria��o do relat�rio.
	//Static Call(ADFIN031R,gerarRelatorio,cVend,"","","",@cNmRelRest)
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	u_FIN031A0(cVend,"","","",@cNmRelRest)

	//			
	nHandle  := fopen(cNmRelRest, FO_READWRITE + FO_SHARED )
	nTamFile := fSeek(nHandle,0,2)
	fSeek(nHandle,0,0)
	nQtd    := FRead( nHandle, @cString, nTamFile)
	cString := Encode64(cString)

	//Envia relat�rio.
	Processar(cString,cCodigoSF,cVend)

	//
	FClose(nHandle)

	//Apaga relat�rio.
	FErase(cNmRelRest)
	
	//
	cHoraExec := ELAPTIME(cHoraExec, Time())
	//Static Call(ADVEN075P,grvLog,"",cCodigoSF,cVend,"","","ADVEN065P","POST",cHoraExec)
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	u_VEN075A0("",cCodigoSF,cVend,"","","ADVEN065P","POST",cHoraExec)

	
	//Fecha o ambiente.
	RpcClearEnv()	

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Processar      �Autor  �Everson      � Data �  03/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento dos envios.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Processar(cString,cCodigoSF,cVend)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local cServico	:= "/services/data/v41.0/sobjects/ContentVersion/" //Trocar por MV ou tabela gen�rica.
	Local cResJson	:= ""
	Local aResponse	:= {}
	Local cMsg		:= ""
	Local cHoraExec	:= Time()

	//Efetura login no SalesForce.
	//lLogin := Static Call(ADVEN075P,loginSF,@aResponse,@cMsg,.F.)
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
    lLogin := u_VEN075A1(@aResponse,@cMsg,.F.)

	//
	If ! lLogin
		Return Nil

	EndIf

	//
	cResJson += '{'

		cResJson += '"Title" : "Relat�rio de faturamento ' + cVend + ' ",'
		cResJson += '"FirstPublishLocationId" : "' + cCodigoSF + '",'
		cResJson += '"PathOnClient" : "Faturamento_' + cVend + '_.html",'
		cResJson += '"VersionData" :"' + cString + '"'

	cResJson += '}'

	//Envia o relat�rio so servi�o do SalesForce.
	If ! U_ADVEN075P(cServico,"POST",cResJson,@cMsg,aResponse)
		Conout("Ocorreu erro no envio do relat�rio financeiro " + cValToChar(cVend) + " no SalesForce." + Chr(13) + Chr(10) + cMsg)
		
		//Static Call(ADVEN075P,grvLog,"",cCodigoSF,cVend,cResJson,"Ocorreu erro no envio do relat�rio financeiro " + cValToChar(cVend) + " no SalesForce." + Chr(13) + Chr(10) + cMsg,"ADVEN065P","POST")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0("",cCodigoSF,cVend,cResJson,"Ocorreu erro no envio do relat�rio financeiro " + cValToChar(cVend) + " no SalesForce." + Chr(13) + Chr(10) + cMsg,"ADVEN065P","POST")

		
		//Static Call(envErros,envErros,"Ocorreu erro no envio do relat�rio financeiro " + cValToChar(cVend) + " no SalesForce." + Chr(13) + Chr(10) + cMsg)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A2("Ocorreu erro no envio do relat�rio financeiro " + cValToChar(cVend) + " no SalesForce." + Chr(13) + Chr(10) + cMsg)
		
	EndIf

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �relatorios     �Autor  �Everson      � Data �  29/11/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Servi�o Rest para gera��o de relat�rios em pdf.             ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
WsRestFul relatorios Description "Servi�o REST para gera��o de relat�rios."

	WsMethod Post Description "Retorno de relat�rio."   WsSyntax "/relatorios"

End WsRestFul
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �relatorios     �Autor  �Everson      � Data �  25/01/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Servi�o Rest para gera��o de relat�rios em pdf.             ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
WsMethod Post WsService relatorios

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aArea			:= GetArea()
	Local cFormatAceito := "application/json"
	Local cNomeArq		:= ""
	Local cCodUsuario	:= Self:GetHeader("UsrVend")
	Local cCodRel		:= ""
	Local cContentType	:= Self:GetHeader("Content-Type")
	Local cBody 		:= Self:GetContent()
	Local oParseJSON	:= Nil
	Local cCodigoSF		:= ""
	Local cCodVendedor	:= ""
	Local cFormato		:= Alltrim(cValToChar(Self:GetAccept()))
	Local lRetP			:= .T.
	Local cJobAux		:= ""
	Local cUrlServ		:= Self:GetPath()
	Private cHoraExec	:= Time()
		
	//Desserializa a string Json (converte em objeto json).
	If ! FWJsonDeserialize(cBody, @oParseJSON)
	
		//
		//Static Call(ADVEN075P,grvLog,cCodUsuario,cCodigoSF,cCodVendedor,cBody,"Ocorreu erro na desserializa��o do Json.",cUrlServ,"POST")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,cCodigoSF,cCodVendedor,cBody,"Ocorreu erro na desserializa��o do Json.",cUrlServ,"POST")
		
		SetRestFault(400,EncodeUtf8("Ocorreu erro na desserializa��o do Json."))
		RestArea(aArea)
		Return .F.

	EndIf
	
	//
	//Static Call(ADVEN075P,grvLog,cCodUsuario,cCodigoSF,cCodVendedor,cBody,"",cUrlServ,"POST")
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	u_VEN075A0(cCodUsuario,cCodigoSF,cCodVendedor,cBody,"",cUrlServ,"POST")
	
	//Obt�m o c�digo da requisi��o do SalesForce e c�digo do vendedor.
	cCodigoSF := Alltrim(cValToChar(oParseJSON:codigoSF))
	cCodVendedor := Alltrim(cValToChar(oParseJSON:A3_COD))

	//Verifica se foi poss�vel obter o c�digo de usu�rio do vendedor.
	If Empty(cCodUsuario)
	
		//
		//Static Call(ADVEN075P,grvLog,cCodUsuario,cCodigoSF,cCodVendedor,cBody,"C�digo de usu�rio n�o informado (UsrVend).",cUrlServ,"POST")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,cCodigoSF,cCodVendedor,cBody,"C�digo de usu�rio n�o informado (UsrVend).",cUrlServ,"POST")
		
		SetRestFault(403,EncodeUtf8("C�digo de usu�rio n�o informado (UsrVend)."))
		RestArea(aArea)
		Return .F.

	EndIf
	
	//Atribui usu�rio.
	__cUserId := cCodUsuario

	//Verifica o formato de dados aceito na resposta.
	If cFormato <> cFormatAceito
	
		//
		//Static Call(ADVEN075P,grvLog,cCodUsuario,cCodigoSF,cCodVendedor,cBody,"Formato de dados " + cFormato + ", no Accept do cabe�alho da requisi��o, n�o suportado.",cUrlServ,"POST")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,cCodigoSF,cCodVendedor,cBody,"Formato de dados " + cFormato + ", no Accept do cabe�alho da requisi��o, n�o suportado.",cUrlServ,"POST")
		
		SetRestFault(400,EncodeUtf8("Formato de dados " + cFormato + ", no Accept do cabe�alho da requisi��o, n�o suportado."))
		RestArea(aArea)
		Return .F.

	ElseIf cContentType <> cFormatAceito //Verifica o formato no corpo da requisi��o.
	
		//
		//Static Call(ADVEN075P,grvLog,cCodUsuario,cCodigoSF,cCodVendedor,cBody,"Formato de dados " + cContentType + ", no Content-Type do cabe�alho da requisi��o, n�o suportado.",cUrlServ,"POST")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,cCodigoSF,cCodVendedor,cBody,"Formato de dados " + cContentType + ", no Content-Type do cabe�alho da requisi��o, n�o suportado.",cUrlServ,"POST")
		
		SetRestFault(400,EncodeUtf8("Formato de dados " + cContentType + ", no Content-Type do cabe�alho da requisi��o, n�o suportado."))
		RestArea(aArea)
		Return .F.

	ElseIf Empty(cBody) //Verifica se o corpo da requisi��o n�o est� vazio.
	
		//
		//Static Call(ADVEN075P,grvLog,cCodUsuario,cCodigoSF,cCodVendedor,cBody,"Json n�o encontrado no corpo da requisi��o.",cUrlServ,"POST")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A0(cCodUsuario,cCodigoSF,cCodVendedor,cBody,"Json n�o encontrado no corpo da requisi��o.",cUrlServ,"POST")
		
		SetRestFault(400,EncodeUtf8("Json n�o encontrado no corpo da requisi��o."))
		RestArea(aArea)
		Return .F.

	EndIf

	//Cria vari�vel global para controle da thread.
	//cJobAux := Upper(cCodVendedor + cValToChar( Randomize(0,9000)) )
	//PutGlbValue(cJobAux,"0")
	//GlbUnlock()
	
	//conout("cCodigoSF >>>>>>>>>>>> " + cCodigoSF)
	//conout("cCodVendedor >>>>>>>>>> " + cCodVendedor)
	
	//Inicia o Job na requisi��o.
	StartJob("U_ADVEN065P",GetEnvServer(),.F.,cEmpAnt,cFilAnt,cCodVendedor,cCodigoSF,cJobAux)
	
	//Checa se o job foi inicializado.
/*	Sleep(1000)
	While lRetP
		
		If cValToChar(GetGlbValue(cJobAux)) == "0"// Job n�o inicializou.
			SetRestFault(500,EncodeUtf8("N�o foi poss�vel inicializar o Job."))
			RestArea(aArea)
			Return .F.
				
		ElseIf cValToChar(GetGlbValue(cJobAux)) == "1" //Job inicializou.
			lRetP := .F.
			
		EndIf
		
	EndDo*/
	
	//Limpa vari�vel global.
	//ClearGlbValue(cJobAux)
	
	//Atribui o formato no cabe�alho da reposta.
	Self:SetContentType(cFormatAceito)
	Self:SetResponse(EncodeUtf8('{"mensagem":"Requisi��o aceita."}'))
	
	//
	//Sleep(1500)
	
	//
	cHoraExec := ELAPTIME(cHoraExec, Time())
	//Static Call(ADVEN075P,grvLog,cCodUsuario,cCodigoSF,cCodVendedor,cBody,"",cUrlServ,"POST",cHoraExec)
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	u_VEN075A0(cCodUsuario,cCodigoSF,cCodVendedor,cBody,"",cUrlServ,"POST",cHoraExec)

	//
	RestArea(aArea)

Return .T.
