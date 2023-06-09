#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "RwMake.ch"
#Include "Totvs.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} User Function MA410MNU
	(
		P.E. de MATA410. Ponto de entrada disparado antes da abertura do Browse, 
		caso Browse inicial da rotina esteja habilitado, ou antes da apresenta��o do Menu de op��es, 
		caso Browse inicial esteja desabilitado. Para habilitar ou desabilitar o Browse, entre na rotina, 
		clique em Configura��es/Browse Inicial e selecione a op��o desejada:
			Sim - Habilitar Browse Inicial
			N�o - Desabilitar Browse Inicial
			Este ponto de entrada pode ser utilizado para inserir novas op��es no array aRotina.
	)
	@type  Function
	@author Vicente de Paula
	@since 26/02/2020
	@version 10
	@history chamado 056247 - FWNM     - 16/04/2020 - || OS 057671 || FINANCEIRO || LUIZ || 8451 || BOLETO BRADESCO WS
	@history chamado TI     - FWNM     - 05/08/2020 - || OS 057671 || FINANCEIRO || LUIZ || 8451 || BOLETO BRADESCO WS
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history Ticket 69574   - Abel Bab - 21/03/2022 - Projeto FAI
	@history Ticket 69574   - Sigoli   - 26/05/2022 - Projeto FAI - corre��o error log -variable does not exist CFILAN on U_ALTSFEXP
	@history Ticket 18465   - Everson  - 06/06/2022 - Adicionada rotina para altera��o de placa na filial 03.
	@history Ticket 18465   - Everson  - 28/06/2022 - Adicionada rotina para enviar registro ao barramento na filial 03.
	@history Everson, 09/12/2022, Ticket 84684 - Tratamento para envio de pedido de venda para o SF.
	@history Everson, 03/02/2023, ticket   18465 Tratamento para altera��o de placa no pedido de venda.
	@history ticket TI - Antonio Domingos - 17/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 22/05/2023 - Revis�o Ajuste Nova Empresa
/*/
User function MA410MNU()

	local aArea     := GetArea()

	aadd( aRotina, { "Solicita Aprov. Refaturamento", "U_ADFAT007P",0,8})
	aadd( aRotina, { "Refaturamento", "U_ALTPEDREF('P',0,'')",0,4})
	aadd( aRotina, { "Rel.Status PV", "U_ADFIN029P()",0,5})
	aadd( aRotina, { "Monitora PV"  , "U_ADVEN049P()",0,8})
	aadd( aRotina, { "Env. SF"      , "U_pedSfExp()" ,0,9})		//Everson - 22/03/2018. Chamado 037261.
	aadd( aRotina, { "Altera CondPag", "U_ADVEN092P()",0,8})	// Ricardo Lima - 10/05/18
	aadd( aRotina, { "Altera SF"      , "U_AltSfExp()" ,0,10})	//Everson - 22/03/2018. Chamado 037261.
 //   aAdd( aRotina, { 'Registra Bol Bradesco WS'     , "u_BolBrad()" , 0, 5 }) // Chamado n. 056247 || OS 057671 || FINANCEIRO || LUIZ || 8451 || BOLETO BRADESCO WS - FWNM - 16/04/2020 // chamado TI     - FWNM     - 05/08/2020 - || OS 057671 || FINANCEIRO || LUIZ || 8451 || BOLETO BRADESCO WS
    aAdd( aRotina, { 'Imprime PDF Bol Bradesco WS'  , "u_RunHCRFB()", 0, 6 }) // Chamado n. 056247 || OS 057671 || FINANCEIRO || LUIZ || 8451 || BOLETO BRADESCO WS - FWNM - 16/04/2020

	//Everson - 06/06/2022. Chamado 18465.
	If cFilAnt == "03"
		aadd( aRotina, { "Altera Placa"      , "U_altPlSC5()" ,0,11})
		aadd( aRotina, { "Env Barramento"    , "U_MA4101()" ,0,11})

	EndIf

	RestArea(aArea)

return NIL

/*/{Protheus.doc} User Function pedSfExp
	(Chamado 037261 - Exporta dados para o Sales Force.)
	@type  Function
	@author Everson
	@since 22/03/18
	@version 1
/*/
User Function pedSfExp()

	Local aArea	   	:= GetArea()
	Local oTelMenu	:= Nil
	Local oDe		:= Nil
	Local oAt		:= Nil
	Local oCanc  	:= Nil
	Local oOk		:= Nil

	Private aItems	:= {'1=Pedido','2=NF do pedido','3=Cadastro cliente','4=NF Devolu��o','5=Ocorr. Logistica','6=Cond. Pag.'}
	Private cCombo1 := ""
	Private oCombo1	:= Nil
	Private cDe		:= SC5->C5_NUM
	Private cAte	:= SC5->C5_NUM

	oTelMenu			:= MsDialog():Create()
	oTelMenu:cName     := "oTelMenu"
	oTelMenu:cCaption  := "Envio SalesForce"
	oTelMenu:nLeft     := 34
	oTelMenu:nTop      := 222
	oTelMenu:nWidth    := 250
	oTelMenu:nHeight   := 320
	oTelMenu:lShowHint := .F.
	oTelMenu:lCentered := .T.

	//
	cCombo1:= aItems[1]
	oCombo1 := TComboBox():New(025,010,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
		aItems,100,20,oTelMenu,,{|| };
		,,,,.T.,,,,,,,,,'cCombo1')

	oDe := TGet():New(060,010,{|u|If(PCount() == 0,cDe,cDe := u)},oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cDe",,,,.T.,,,"Pedido de :",1)

	oAt := TGet():New(090,010,{|u|If(PCount() == 0,cAte,cAte := u)},oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cAte",,,,.T.,,,"Pedido at�:",1)

	oOk     := TButton():New(126,010,"Enviar"  ,oTelMenu,{|| exProdSfExp(cCombo1,cDe,cAte), oTelMenu:End() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
	oCanc   := TButton():New(126,075,"Cancelar",oTelMenu,{|| oTelMenu:End() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )

	oTelMenu:Activate(,,,.T.,{||.T.},,{||  })

	RestArea(aArea)

Return Nil

/*/{Protheus.doc} Static Function exProdSfExp
	(Chamado 037261. Envia tabela de pre�o para o SalesForce.)
	@type  Function
	@author Everson
	@since 19/03/2018
	@version 1
/*/
Static Function exProdSfExp(cCombo1,cDe,cAte)

	Local cExpSql := ""

	If FindFunction("U_ADVEN050P") .And. cCombo1 == "1"
		//Static Call(M410STTS,envSF,,," AND C5_NUM BETWEEN '" + cDe + "' AND '" + cAte + "' AND C5_NOTA <>'' AND C5_SERIE <> '' AND C5_NOTA <> 'XXXXXXXXX' ")
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_10STTSA0( ,," AND C5_NUM BETWEEN '" + cDe + "' AND '" + cAte + "' AND C5_NOTA <>'' AND C5_SERIE <> '' AND C5_NOTA <> 'XXXXXXXXX' ")
		
		u_10STTSA0( ,," AND C5_NUM BETWEEN '" + cDe + "' AND '" + cAte + "' AND C5_NOTA <>'' AND C5_SERIE <> '' AND C5_NOTA <> 'XXXXXXXXX' ") //Everson - 09/12/2022 - Ticket 84684.

	EndIf

	If FindFunction("U_ADVEN074P") .And. cCombo1 == "2"

		cExpSql := " AND RTRIM(LTRIM(F2_DOC)) + RTRIM(LTRIM(F2_SERIE)) IN ( "
		cExpSql += " SELECT RTRIM(LTRIM(C5_NOTA)) + RTRIM(LTRIM(C5_SERIE)) AS NF FROM " + RetSqlName("SC5") + " AS SC5 "
		cExpSql += " WHERE C5_FILIAL = '" + cFilAnt + "' AND  C5_NUM BETWEEN '" + cDe + "' AND '" + cAte + "' AND C5_NOTA <>'' AND C5_SERIE <> '' AND C5_NOTA <> 'XXXXXXXXX' "
		cExpSql += " ) "

		U_ADVEN074P(cEmpAnt,cFilAnt,"",.F.,cExpSql)

	EndIf

	If FindFunction("U_ADVEN076P") .And. cCombo1 == "3"
		cExpSql := " AND RTRIM(LTRIM(A1_COD)) + RTRIM(LTRIM(A1_LOJA)) IN ( "
		cExpSql += " SELECT RTRIM(LTRIM(C5_CLIENTE)) + RTRIM(LTRIM(C5_LOJACLI)) AS CLI FROM " + RetSqlName("SC5") + " AS SC5 "
		cExpSql += " WHERE C5_FILIAL = '" + cFilAnt + "' AND  C5_NUM BETWEEN '" + cDe + "' AND '" + cAte + "' "
		cExpSql += " ) "

		U_ADVEN076P("","",.F.,cExpSql,,.T.,"")
	EndIf

	If FindFunction("U_ADVEN077P") .And. cCombo1 == "4"
		cExpSql := " AND RTRIM(F1_FILIAL) +  RTRIM(F1_DOC) + RTRIM(F1_SERIE) + RTRIM(F1_FORNECE) + RTRIM(F1_LOJA) IN ( "
		cExpSql += " SELECT  "
		cExpSql += " DISTINCT RTRIM(D1_FILIAL) +  RTRIM(D1_DOC) + RTRIM(D1_SERIE) + RTRIM(D1_FORNECE) + RTRIM(D1_LOJA)  "
		cExpSql += " FROM " + RetSqlName("SD1") + " (NOLOCK) AS SD1 "
		cExpSql += " INNER JOIN "
		cExpSql += " " + RetSqlName("SC5") + " (NOLOCK) AS SC5 ON "
		cExpSql += " D1_FILIAL = C5_FILIAL "
		cExpSql += " AND D1_NFORI = C5_NOTA "
		cExpSql += " AND D1_SERIORI = C5_SERIE "
		cExpSql += " AND D1_FORNECE = C5_CLIENTE "
		cExpSql += " AND D1_LOJA = C5_LOJACLI "
		cExpSql += " WHERE  "
		cExpSql += " D1_FILIAL = '" + cFilAnt + "'  "
		cExpSql += " AND C5_NUM BETWEEN '" + cDe + "' AND '" + cAte + "' "
		cExpSql += " AND SC5.D_E_L_E_T_ = '' "
		cExpSql += " AND SD1.D_E_L_E_T_ = '' "
		cExpSql += " ) "

		//ADVEN077P(cEmp,cFili,cParamBsc,lAut,cExpSql,lItem)
		U_ADVEN077P(cEmpAnt,cFilAnt,"",.F.,cExpSql,.F.)
	EndIf

	If FindFunction("U_ADVEN084P") .And. cCombo1 == "5"
		cExpSql := " AND RTRIM(LTRIM(F2_DOC)) + RTRIM(LTRIM(F2_SERIE)) IN ( "
		cExpSql += " SELECT RTRIM(LTRIM(C5_NOTA)) + RTRIM(LTRIM(C5_SERIE)) AS NF FROM " + RetSqlName("SC5") + " AS SC5 "
		cExpSql += " WHERE C5_FILIAL = '" + cFilAnt + "' AND  C5_NUM BETWEEN '" + cDe + "' AND '" + cAte + "' AND C5_NOTA <>'' AND C5_SERIE <> '' AND C5_NOTA <> 'XXXXXXXXX' "
		cExpSql += " ) "

		U_ADVEN084P("","",.F.,cExpSql)
	EndIf

	If FindFunction("U_ADVEN070P") .And. cCombo1 == "6"
		cExpSql := " AND E4_CODIGO IN ( "
		cExpSql += " SELECT C5_CONDPAG FROM " + RetSqlName("SC5") + " AS SC5 WHERE C5_FILIAL = '" + cFilAnt + "' AND  C5_NUM BETWEEN '" + cDe + "' AND '" + cAte + "' AND D_E_L_E_T_ = ''  "
		cExpSql += " ) "

		U_ADVEN070P("","",.F.,cExpSql)
	EndIf

Return Nil

/*/{Protheus.doc} User Function AltSfExp
	(Chamado 037261. Chama a altera��o do pedido de venda.)
	@type  Function
	@author Everson
	@since 13/05/2018
	@version 1
	@history ticket TI - Antonio Domingos - 17/05/2023 - Ajuste Nova Empresa
/*/
User Function AltSfExp()

	Local aArea	:= GetArea()
	Local cUser	:= ""
	//Local cFilSF:= GetMv("MV_#SFFIL",,"02|0B|") //Ticket 69574   - Abel Bab - 21/03/2022 - Projeto FAI
	//Local cEmpSF:= GetMv("MV_#SFEMP",,"01|") //Ticket 69574   - Abel Bab - 21/03/2022 - Projeto FAI
	Private _cEmpFL3 := SuperGetMv("MV_#EMPFL3",.F.,"0102/010B/1301") //Codigo de Empresas+Filiais Ativas Grupo 3 //ticket TI - Antonio Domingos - 17/05/2023
	//If !cEmpAnt$cEmpSF .Or. !cFilAnt$cFilSF .Or. Alltrim(cValToChar( SC5->C5_XGERSF )) <> "2" //Ticket 69574   - Abel Babini      - 21/03/2022 - Projeto FAI
	If !alltrim(cEmpAnt)+alltrim(cFilAnt) $ _cEmpFL3  .Or. Alltrim(cValToChar( SC5->C5_XGERSF )) <> "2" //ticket TI - Antonio Domingos - 17/05/2023 
		RestArea(aArea)
		Return Nil
	EndIf

	//Usu�rios que podem alterar o pedido de venda.
	cUser := GetMv("MV_#SFUSAL",,"")

	If ! (__cUserId $cUser)
		MsgStop("Usu�rio sem premiss�o.","Fun��o AltSfExp (M410MNU)")
		RestArea(aArea)
		Return Nil
	EndIf
	
	/*
	If ! Empty(Alltrim(cValToChar( SC5->C5_NOTA )))
		MsgStop("Campo nota fiscal do pedido est� preenchido.","Fun��o AltSfExp (M410MNU)")
		RestArea(aArea)
		Return Nil
	EndIf
	*/
	
	If ! Empty(Alltrim(cValToChar( SC5->C5_PLACA )))
		MsgStop("Campo placa do pedido est� preenchido, para alterar o pedido entrar em contato com a Log�stica.","Fun��o AltSfExp (M410MNU)")
		RestArea(aArea)
		Return Nil
	EndIf

	RESTEXECUTE()

	RestArea(aArea)

Return Nil

/*/{Protheus.doc} RESTEXECUTE
	(Chamado 037261.Executa a altera��o do pedido de venda.)
	@type  Static Function
	@author Everson
	@since 13/05/2018
	@version 1
/*/
Static Function RESTEXECUTE()

	Local aArea		:= GetArea()
	Local nRet 		:= 0
	local lPedBloq	:= .F.

	//Checa libera��o do pedido de venda.
	lPedBloq := Iif( Alltrim(cValToChar( SC5->C5_BLQ )) == "1",.T.,.F.)

	SetFunName("RESTEXECUTE")
	nRet := A410Altera("SC5",SC5->( Recno() ), 4 )

	//Se alterou o pedido de venda, gera log.
	If nRet <> 0

		//Static Call(ADVEN086P,chkLiber,Alltrim(cValToChar( SC5->C5_NUM )),lPedBloq)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN090A0( Alltrim(cValToChar( SC5->C5_NUM )),lPedBloq ) 
		//Obs: O fonte ADVEN086P nao possuia a funcao chklib, foi utizada do fonte ADVEN090P que aparentemente tem a finalidade desejada.

		DbSelectArea("ZBE")
		RecLock("ZBE",.T.)
		Replace ZBE_FILIAL 	   	WITH xFilial("ZBE")
		Replace ZBE_DATA 	   	WITH dDataBase
		Replace ZBE_HORA 	   	WITH Time()
		Replace ZBE_USUARI	    WITH Upper(Alltrim(cUserName))
		Replace ZBE_LOG	        WITH "ALTERACAO PEDIDO DE VENDA SF " + Alltrim(cValToChar( SC5->C5_NUM ))
		Replace ZBE_MODULO	    WITH "COMERCIAL"
		Replace ZBE_ROTINA	    WITH "AltSfExp"
		Replace ZBE_PARAME      WITH Alltrim(cValToChar( SC5->C5_NUM ))
		ZBE->( MsUnLock())

	EndIf

	RestArea(aArea)

Return Nil
/*/{Protheus.doc} altPlSC5
	Altera placa do pedido de venda.
	Chamado 18465.
	@type  Static Function
	@author Everson
	@since 06/06/2022
	@version 1
/*/
User Function altPlSC5()

	//Vari�veis.
	Local aArea := GetArea()
	Local lRet  := .F.

	//Valida filial.
	If SC5->C5_FILIAL <> "03"
		MsgInfo("Filial inv�lida.", "Fun��o altPlSC5(MA410MNU)")
		RestArea(aArea)
		Return .F.

	EndIf

	//Valida nota fiscal.
	If ! Empty(SC5->C5_NOTA)
		MsgInfo("Pedido j� possui nota fiscal vinculada.", "Fun��o altPlSC5(MA410MNU)")
		RestArea(aArea)
		Return .F.

	EndIf

	//Valida se � pedido de sa�da vinculado a ordem de pesagem de ra��o.
	If ! Empty(SC5->C5_XORDPES)
		MsgInfo("Somente pedido vinculado � ordem de pesagem de sa�da pode ter a placa alterada.", "Fun��o altPlSC5(MA410MNU)")
		RestArea(aArea)
		Return .F.

	EndIf	

	//Valida se h� ordem/ticket de pesagem vinculado.
	If ! U_ADFAT41A(SC5->C5_NUM, .T.)
		RestArea(aArea)
		Return .F.

	EndIf

	If ! Pergunte("MA410MNU", .T.)
		RestArea(aArea)
		Return .F.

	EndIf

	If !FWIsAdmin() .And. Empty(MV_PAR01) //Everson - 03/02/2023.
		MsgInfo("� necess�rio informar a placa.", "Fun��o altPlSC5(MA410MNU)")
		RestArea(aArea)
		Return .F.

	EndIf

	DbSelectArea("SC6")
	SC6->(DbSetOrder(1))
	SC6->(DbGoTop())

	DbSelectArea("SC9")
	SC9->(DbSetOrder(1))
	SC9->(DbGoTop())

	Begin Transaction

		If SC9->( DbSeek( FWxFilial("SC9") + SC5->C5_NUM ) )

			While ! SC9->(Eof()) .And. SC9->C9_FILIAL == FWxFilial("SC9") .And. SC9->C9_PEDIDO == SC5->C5_NUM

				RecLock("SC9", .F.)
					SC9->C9_PLACA := MV_PAR01
				SC9->(MsUnLock())

				SC9->(DbSkip())

			End

		EndIf

		RecLock("SC5", .F.)
			SC5->C5_PLACA = MV_PAR01
		SC5->(MsUnlock())

		u_GrLogZBE(msDate(),TIME(),cUserName," ALTERACAO PLACA","FATURAMENTO","MA410MNU",;
		"Placa do pedido " + cValToChar(SC5->C5_NUM) + " alterada para " + cValToChar(MV_PAR01) + ".",ComputerName(),LogUserName())

		lRet := .T.

	End Transaction

	If lRet
		MsgInfo("Placa do pedido " + cValToChar(SC5->C5_NUM) + " alterada para " + cValToChar(MV_PAR01) + ".", "Fun��o altPlSC5(MA410MNU)")

	EndIf

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} MA4101
	Envia registro para o barramento.
	Chamado 18465.
	@type  Static Function
	@author Everson
	@since 28/06/2022
	@version 1
/*/
User Function MA4101()

	//Vari�veis.
	Local aArea 	:= GetArea()
	Local cPedido 	:= SC5->C5_NUM
	Local cFilter	:= ""

	If ! MsgYesNo("Deseja enviar o pedido de venda " + cPedido + " para o barramento ?","Fun��o MA4101(MA410MNU)")
		RestArea(aArea)
		Return Nil

	EndIf

	cFilter := " C6_FILIAL ='" + FWxFilial("SC6") + "' .And. C6_NUM = '" + cPedido + "' "

	U_ADFAT27D("SC5", 1, FWxFilial("SC5") + cPedido,;
		"SC6", 1, FWxFilial("SC6") + cPedido, "C6_ITEM",cFilter,;
		"pedidos_de_saida_protheus", "A",;
		.T., .T.,.T., Nil)

	MsgInfo("Pedido enviado.","Fun��o MA4101(MA410MNU)")

	RestArea(aArea)

Return Nil
