#Include 'Protheus.ch'
#Include 'FwMvcDef.ch'
#Include 'Parmtype.ch'
#Include 'Topconn.ch'

//Vari�veis Est�ticas.
Static cTitulo := 'Usu�rios - SalesForce'
Static xPula   := Chr(13) + Chr(10)
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADVEN059P   � Autor � Everson          � Data �  13/11/17   ���
�������������������������������������������������������������������������͹��
���Descricao �Cadastro de promotores.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADVEN059P() // U_ADVEN059P()
		
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������	
	Local aArea	   := GetArea()
	Local oBrowse  := Nil
	Local cFunName := FunName()
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de promotores')
	
	ChkFile("ZC4")
	
	SetFunName("ADVEN059P")
		
		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias("ZC4")
		oBrowse:SetDescription(cTitulo)

		oBrowse:Activate()
		
	SetFunName(cFunName)
	
	RestArea(aArea)
	
Return Nil

Static Function ModelDef()
		
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������
	Local oModel := Nil
	Local oStruct:= FwFormStruct(1,'ZC4')
	
	oModel:= MpFormModel():New('_VEN059P',Nil)
	oModel:AddFields('MASTERALIAS',Nil,oStruct)
	oModel:SetDescription(cTitulo)
	oModel:GetModel('MASTERALIAS'):SetDescription(cTitulo)
	
	oModel:SetPrimaryKey({})

Return oModel

Static Function ViewDef()
		
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������
	Local oModel := ModelDef()
	Local oStruct:= FwFormStruct(2,'ZC4')
	Local oView  := FwFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField('VIEW_MASTER',oStruct,'MASTERALIAS')
	oView:CreateHorizontalBox('TELA',100)
	oView:SetOwnerView('VIEW_MASTER','TELA')

Return oView

Static Function MenuDef()

	Local aRotina 		:= {}

	ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.ADVEN059P' OPERATION 2  ACCESS 0
	ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.ADVEN059P' OPERATION 3  ACCESS 0
	ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.ADVEN059P' OPERATION 4  ACCESS 0
	ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.ADVEN059P' OPERATION 5  ACCESS 0
	ADD OPTION aRotina Title 'Imprimir'    Action 'VIEWDEF.ADVEN059P' OPERATION 8  ACCESS 0
	ADD OPTION aRotina Title 'Copiar'      Action 'VIEWDEF.ADVEN059P' OPERATION 9  ACCESS 0
	ADD OPTION aRotina Title 'SF Exportar' Action 'U_exUSSfExp()'     OPERATION 10 ACCESS 0
	ADD OPTION aRotina TITLE "Env AWS"     ACTION "U_ADVEN591()"      OPERATION 11  ACCESS 0
	
Return aRotina
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �exDCSfExp      � Autor � Everson       � Data �  25/02/18   ���
�������������������������������������������������������������������������͹��
���Descricao �Exporta dados para o Sales Force.                           ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function exUSSfExp()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local cCodigo	:= ""

	U_ADINF009P('ADVEN059P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de promotores')

	//
	If ! MsgYesNo("Deseja enviar o registro para o Sales Force?","Fun��o sfExportar")
		RestArea(aArea)
		Return Nil

	EndIf
	
	//
	If FindFunction("U_ADVEN068P")
		cCodigo := Alltrim(cValToChar(ZC4->ZC4_COD))
		U_ADVEN068P(cCodigo,cCodigo,.F.,"",.F.,.T.)
		
	EndIf

	//
	RestArea(aArea)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �_VEN060P    � Autor � Everson         � Data �  01/03/18    ���
�������������������������������������������������������������������������͹��
���Descricao �Ponto de entrada para envio de inser��o/altera��o. SalesForce���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function _VEN059P()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local aParam    := PARAMIXB
	Local oObj      := ""
	Local cIdPonto  := ""
	Local cIdModel  := ""
	Local cFlgEnv	:= ""
	Local cCodigo	:= ""

	U_ADINF009P('ADVEN059P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de promotores')
	
	//
	If aParam <> NIL
		
		//
		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]

		//
		If cIdPonto == 'FORMCOMMITTTSPOS'
			
			//
			If Findfunction("U_ADVEN068P")
			
				cFlgEnv := Alltrim(cValToChar( oObj:GetModel('MASTERALIAS'):GetValue(cIdModel, 'ZC4_SALES' ) ) )
				
				//
				If cFlgEnv == "2"
					cCodigo := Alltrim(cValToChar( oObj:GetModel('MASTERALIAS'):GetValue(cIdModel, 'ZC4_COD' ) ) )
					U_ADVEN068P(cCodigo,cCodigo,.F.,"",.F.,.T.)
				
				EndIf
			
			EndIf
			
		EndIf

	EndIf
	
	//
	RestArea(aArea)
	
Return .T.
/*/{Protheus.doc} User Function ADVEN591
	Envia cadastro para o AWS.
	@type  Function
	@author user
	@since 31/07/2022
	@version 01
/*/
User Function ADVEN591()

	//Vari�veis.
	Local aArea  	:= GetArea()
	Local cMsgError	:= ""
	Local cUrl   	:= Alltrim(cValToChar(GetMV("MV_#VEN591",,"http://3.140.145.105:8082/api")))
	Local cToken 	:= ""
	Local lReRest	:= .F.
	Local cPrtDe	:= ""
	Local cPrtAte 	:= ""

	If ! Pergunte("ADVEN0591", .T.)
		RestArea(aArea)
		Return Nil

	EndIf

	cPrtDe	:= MV_PAR01
	cPrtAte := MV_PAR02

	MsAguarde({|| lReRest := U_ADVEN592(cUrl, @cToken, @cMsgError) }, "Fun��o ADVEN592(ADVEN059P)", "Efetuando login...")

	If ! lReRest
		MsgInfo("N�o foi poss�vel efetuar login " + xPula + cMsgError, "Fun��o ADVEN592(ADVEN059P)")
		RestArea(aArea)
		Return Nil

	EndIf
	
	MsAguarde({|| procEnv(cPrtDe, cPrtAte, cUrl, cToken) }, "Fun��o ADVEN592(ADVEN059P)", "Enviando cadastros...")

	RestArea(aArea)

Return Nil
/*/{Protheus.doc} procEnv
	Processa envio de cadastro.
	@type  Static Function
	@author Everson
	@since 31/07/2022
	@version 01
/*/
Static Function procEnv(cPrtDe, cPrtAte, cUrl, cToken)

	//Vari�veis.
	Local aArea 	:= GetArea()
	Local cServico	:= ""
	Local cQuery	:= ""
	Local oJson     := Nil
	Local cBody		:= ""
	Local cDefPass  := Alltrim(cValToChar(GetMV("MV_#VEN594",,"123456")))
	Local cCodAWS	:= ""
	Local cMetodo	:= ""
	Local cMsg		:= ""
	Local lRetEnv	:= .F.

	cQuery := ""
	cQuery += " SELECT "
		cQuery += " ZC4_IDAWS, ZC4_NOME, ZC4_EMAIL, ZC4_COD " 
	cQuery += " FROM " 
		cQuery += " " + RetSqlName("ZC4") + " (NOLOCK) AS ZC4 " 
	cQuery += " WHERE " 
		cQuery += " ZC4_FILIAL = '" + FwxFilial("ZC4") + "' " 
		cQuery += " AND ZC4_COD >= '" + cPrtDe + "' " 
		cQuery += " AND ZC4_COD <= '" + cPrtAte + "' " 
		cQuery += " AND ZC4.D_E_L_E_T_ = '' " 
	cQuery += " ORDER BY ZC4_COD " 

	If Select("D_PROMOT") > 0
		D_PROMOT->(DbCloseArea())

	EndIf

	TcQuery cQuery New Alias "D_PROMOT"
	DbSelectArea("D_PROMOT")
	D_PROMOT->(DbGoTop())

	While ! D_PROMOT->(Eof())

		cCodAWS := Alltrim(cValToChar(D_PROMOT->ZC4_IDAWS))
		
		If Empty(cCodAWS)
			cMetodo := "Post"
			cServico	:= "/users"

		Else
			cMetodo := "Put"
			cServico	:= "/users/" + cCodAWS

		EndIf

		oJson := JsonObject():new()

		oJson['userName']   := Alltrim(cValToChar(D_PROMOT->ZC4_NOME))
		oJson['name'] 		:= Alltrim(cValToChar(D_PROMOT->ZC4_NOME))
		oJson['email'] 		:= Alltrim(cValToChar(D_PROMOT->ZC4_EMAIL))
		oJson['portfolio'] 	:= Alltrim(cValToChar(D_PROMOT->ZC4_COD))

		If cMetodo == "Post"
			oJson['password'] 	:= cDefPass

		EndIf
		
		cBody := oJson:toJSON()

		FreeObj(oJson)
		oJson := Nil

		lRetEnv := U_ADVEN593(cUrl, cServico, cMetodo, cToken, cBody, @cMsg)

        If ! lRetEnv
            U_TExTelaMen("Erro - Promotor " + D_PROMOT->ZC4_COD, cMsg, "Arial",10,,.F.,.F.)
            D_PROMOT->(DbSkip())
            Loop

        ElseIf lRetEnv .And. (cMetodo == "Post" .Or. cMetodo == "Put") 
            tratSucess(cMsg, D_PROMOT->ZC4_COD)

        EndIf

		D_PROMOT->(DbSkip())

	End

	D_PROMOT->(DbCloseArea())

	MsgInfo("Processo finalizado", "Fun��o procEnv(ADVEN059P)")

	RestArea(aArea)

Return Nil
/*/{Protheus.doc} tratSucess
    Grava id da api no cadastro do promotor.
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
Static Function tratSucess(xMsg, cCodigo)
    
    //Vari�veis.
    Local aArea := GetArea()
    Local oJson := JsonObject():new()
    Local cId   := ""

	oJson := JsonObject():new()
	oJson:fromJson(xMsg)

	cId := cValToChar(oJson['_id'])

	FreeObj(oJson)
	oJson := Nil

	DbSelectArea("ZC4")
	ZC4->(DbSetOrder(1))
	ZC4->(DbGoTop())

	If ZC4->(DbSeek( FwxFilial("ZC4") + cCodigo ))

		RecLock("ZC4", .F.)
			ZC4->ZC4_IDAWS := cId
		ZC4->(MsUnlock())

	EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADVEN591
	Efetua login.
	@type  User Function
	@author Everson
	@since 31/07/2022
	@version 01
/*/
User Function ADVEN592(cUrl, cToken, cMsgError)

	//Vari�veis.
	Local aArea  	:= GetArea()
	Local lRet   	:= .F.
	Local cServico 	:= "/auth/signin"
	Local cUser  	:= Alltrim(cValToChar(GetMV("MV_#VEN592",,"sistemas@adoro.com.br")))
	Local cPassword := Alltrim(cValToChar(GetMV("MV_#VEN593",,"123456")))
	Local aHeader	:= {}
	Local oJson     := JsonObject():new()
	Local cBody		:= ""
	Local cMsg		:= ""
	Local lRest		:= .F.
	
	Default cToken	:= ""

	Aadd(aHeader, "Content-Type: application/json")
	
	oJson['email']    := cUser
	oJson['password'] := cPassword

	cBody := oJson:toJSON()

	FreeObj(oJson)
	oJson := Nil

	oRestClient := FWRest():New(cUrl)
	oRestClient:setPath(cServico)

	oRestClient:SetPostParams(cBody)
	lRest := oRestClient:Post(aHeader)

	If ! lRest
		cMsgError := Alltrim(cValToChar(oRestClient:GetLastError())) + xPula + Alltrim(cValToChar(oRestClient:GetResult()))
		
	Else
		lRet := .T.
		cMsg := Alltrim(cValToChar(oRestClient:GetResult()))

		oJson := JsonObject():new()
        oJson:fromJson(cMsg)

		cToken := oJson['accessToken']

		FreeObj(oJson)
		oJson := Nil

	EndIf

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADVEN593
    Envia requisi��o.
    @type  User Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
User Function ADVEN593(cUrl, cServico, cMetodo, cToken, cBodyRq, cMsg)

    //Vari�veis.
	Local aArea 		:= GetArea()
	Local lRet			:= .T.
	Local oRestClient 	:= Nil
	Local lRest			:= .F.

    Private aHeader	:= {}
    Private cBody       := cBodyRq

	Default cServico	:= ""
	Default cBody		:= ""
	Default cMsg		:= ""
	Default aResponse	:= {}

    Aadd(aHeader, "Content-Type: application/json")
	Aadd(aHeader, "x-access-token: " + cToken)

	oRestClient := FWRest():New(cUrl)
	oRestClient:setPath(cServico)

    If cMetodo == "Post"
        oRestClient:SetPostParams(cBody)
        lRest := oRestClient:Post(aHeader)

    ElseIf cMetodo == "Put"
        lRest := oRestClient:Put(aHeader, cBody)

    Endif

	cMsg := ""

	If ! lRest

		If Substr(Alltrim(cValToChar(oRestClient:GetLastError())),1,1) <> "2" 

			cMsg := Alltrim(cValToChar(oRestClient:GetLastError())) + Chr(13) + Chr(10)
			cMsg += "URL: "      + cUrl + Chr(13) + Chr(10)
			cMsg += "EndPoint: " + cServico + Chr(13) + Chr(10)
			cMsg += "M�todo: "   + cMetodo + Chr(13) + Chr(10)
			cMsg += "Body: "     + Chr(13) + Chr(10) + cValToChar(cBody) + Chr(13) + Chr(10)
			cMsg += "Resp: "     + Chr(13) + Chr(10) + Alltrim(cValToChar(oRestClient:GetResult())) + Chr(13) + Chr(10)
			lRet := .F.

		EndIf

	EndIf
	
	If lRet 
        cMsg := Alltrim(cValToChar(oRestClient:GetResult()))

	EndIf

	FreeObj(oRestClient)
	oRestClient := Nil
	RestArea(aArea)

Return lRet
