#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} User Function ADMNT023R
    Ticket 88099 - Relatório de utilização de OS.
    @type  Function
    @author Everson
    @since 16/02/2023
    @version 01
    @history Everson, 22/02/2023, ticket 88099 - adicionada coluna de horário.
/*/
User Function ADMNT023R() // U_ADMNT023R()

    //Variáveis.
    Local aArea     := GetArea()
	Local oReport   := Nil
	Local cPerg     := "ADMNT023R" 
	
	If ! Pergunte(cPerg, .T.)
        RestArea(aArea)
        Return Nil

    EndIf
	
	oReport := ReportDef(cPerg, MV_PAR01, MV_PAR02, MV_PAR03, MV_PAR04)
	oReport:PrintDialog()

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} Static Function ReportDef								   
	@type  Static Function
	@author Everson
	@since 16/02/2022
	@version 01
/*/
Static Function ReportDef(cPerg, cOsDe, cOsAte, dDtDe, dDtAte)

    //Variáveis.
	Local oReport   := Nil
    Local cTitulo   := "Movimentação OS"

	oReport:= TReport():New("ADMNT023R", cTitulo, cPerg, {|oReport| ReportPrint(oReport, cOsDe, cOsAte, dDtDe, dDtAte)}, cTitulo)
	oReport:SetLandscape()
	oReport:SetTotalInLine(.F.)

	oSection1:= TRSection():New(oReport, cTitulo, "")
	oSection1:SetHeaderPage()

	TRCell():New(oSection1,"OS"      , ,"Ordem de Serviço" , /*Picture*/,  10, ,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"DATA"    , ,"Data"             , /*Picture*/,  10, ,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"HORA"    , ,"Hora"             , /*Picture*/,  08, ,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"USUARIO" , ,"Usuário"          , /*Picture*/,  30, ,/*{|| code-block de impressao }*/)
	TRCell():New(oSection1,"ACAO"    , ,"Ação"             , /*Picture*/, 120, ,/*{|| code-block de impressao }*/)

Return oReport
/*/{Protheus.doc} Static Function ReportPrint								   
	@type  Static Function
	@author Everson
	@since 16/02/2022
	@version 01
/*/
Static Function ReportPrint(oReport, cOsDe, cOsAte, dDtDe, dDtAte)

    //Variáveis.
    Local aArea     := GetArea()
    Local oRegistro := oReport:Section(1)
    Local cQuery    := ""
    Local cAlias    := GetNextAlias()
    Local cTpBlq    := Alltrim(cValToChar(GetMv("MV_#DMT221",,"SC0001,SC0002")))
    Local aTpBlq    := Separa(cTpBlq)
    Local nCount    := 1
    Local cFiltro   := ""

    For nCount := 1 To Len(aTpBlq)
        cFiltro += "'" + aTpBlq[nCount] + "',"

    Next nCount

    cFiltro := Substr(cFiltro, 1, Len(cFiltro) -1)

    cQuery := ""
    // cQuery += " SELECT " 
    //     cQuery += " TJ_DTORIGI, TJ_ORDEM, TJ_USUAINI, 'INCLUSÃO OS' AS ACAO " 
    // cQuery += " FROM " 
    //     cQuery += " " + RetSqlName("STJ") + " (NOLOCK) AS STJ " 
    // cQuery += " WHERE " 
    //     cQuery += " TJ_FILIAL = '" + FWxFilial("STJ") + "' " 
    //     cQuery += " AND TJ_SERVICO IN (" + cFiltro + ") " 
    //     cQuery += " AND STJ.D_E_L_E_T_ = '' " 
    // cQuery += " UNION ALL " 
    cQuery += " SELECT  " 
        cQuery += " ZBE_DATA AS TJ_DTORIGI, ZBE_PARAME AS TJ_ORDEM, ZBE_USUARI AS TJ_USUAINI, ZBE_LOG AS ACAO, ZBE_HORA AS HORA " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZBE") + " (NOLOCK) AS ZBE " 
    cQuery += " WHERE " 
        cQuery += " ZBE_FILIAL = '" + FWxFilial("ZBE") + "' " 
        cQuery += " AND ZBE_ROTINA = 'ADMNT220' " 
        cQuery += " AND ZBE_PARAME BETWEEN '" + cOsDe + "' AND '" + cOsAte + "' " 
        cQuery += " AND ZBE_DATA BETWEEN '" + DToS(dDtDe) + "' AND '" + DToS(dDtAte) + "' " 
        cQuery += " AND ZBE.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY TJ_ORDEM, TJ_DTORIGI, HORA " 

    DbUseArea(.t., "TOPCONN", TcGenQry(,, cQuery), cAlias, .F., .T.)

    (cAlias)->(DbGoTop())
    
    While ! (cAlias)->(Eof())

        oRegistro:IncMeter()
		
		oRegistro:Init()
		
		If oReport:Cancel()
			oReport:PrintText(OemToAnsi("Cancelado"))
			Exit
		EndIf
		
		//Impressao propriamente dita....
		oRegistro:Cell("OS"):SetBlock( {|| (cAlias)->TJ_ORDEM} )
		oRegistro:Cell("DATA"):SetBlock( {|| DToC(SToD((cAlias)->TJ_DTORIGI)) } )
		oRegistro:Cell("HORA"):SetBlock( {|| (cAlias)->HORA } )
		oRegistro:Cell("USUARIO"):SetBlock( {|| (cAlias)->TJ_USUAINI} )
		oRegistro:Cell("ACAO"):SetBlock( {|| (cAlias)->ACAO} )

		oRegistro:PrintLine()
		oReport:IncMeter()

        (cAlias)->(DbSkip())

    End

    oRegistro:Finish()

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return Nil
