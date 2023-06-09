#Include "Protheus.ch"
#Include "Topconn.ch"
/*/{Protheus.doc} User Function ADEEC004P
    Fun��o valida o peso de embalagem entre as tabelas
    EE5 e SZC.
    @type  Function
    @author Everson
    @since 09/10/2020
    @version 01
    @history Chamado 8465 - Leonardo P. Monteiro - 04/03/2021 - Inclus�o das valida��es do projeto de exporta��o.
    @history tkt    85096 - Fernando Sigoli      - 15/12/2022 - Exporta��o de ovos, nao validar embalagens
    
    /*/
User Function ADEEC004P(cProduto) // U_ADEEC004P(M->EE8_COD_I) U_ADEEC004P("145178")

    //Vari�veis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cQuery    := scpSql(cProduto)
    //PGA - Chamada das valida��es da PGA em rela��o ao cadastro.
    Local oEST055P  := ADEST055P():New()
    Local cProdExc  := Alltrim(SuperGetMV("MV_#PRDEXC",,"342977")) 
    //
    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Fun��o valida o peso de embalagem entre as tabelas')
    //
    cProduto := Alltrim(cValToChar(cProduto))

    //
    If Empty(cProduto) .or. Alltrim(cProduto) $ cProdExc //'342977' //PRODUTO OVO NAO VALIDA EMBALGEM
        lRet := .T.
        RestArea(aArea)
        Return lRet

    EndIf

    //
    If Select("D_DPROEX") > 0
        D_DPROEX->(DbCloseArea())

    EndIf

    //
    TcQuery cQuery New Alias "D_DPROEX"
    DbSelectArea("D_DPROEX")
    D_DPROEX->(DbGoTop())
    If D_DPROEX->(Eof())
        MsgStop("N�o foi poss�vel validar a embalagem do produto " + cProduto + ".","Fun��o ADEEC004P(ADEEC004P)")

    Else 
        
        //
        If D_DPROEX->EE5_PESO <> D_DPROEX->ZC_TARA
            MsgStop("Diverg�ncia de peso de embalagem EE5 x SZC." + Chr(13) + Chr(10) +;
                    "EE5 peso: " + cValToChar(D_DPROEX->EE5_PESO) + Chr(13) + Chr(10) +;
                    "SZC peso: " + cValToChar(D_DPROEX->ZC_TARA),"Fun��o ADEEC004P(ADEEC004P)")

        Else 
            lRet := .T.

        EndIF

    EndIf

    //
    D_DPROEX->(DbGoTop())

    if lRet .and. oEST055P:lPrcPGA
        // Tkt 8465 - LPM - Valida se o produto est� cadastrado e vinculado ao cadastro PGA.
        lRet := oEST055P:PGAVldPrd(cProduto, M->EE7_PAISET, Alltrim(Funname()))
    endif

    //
    RestArea(aArea)

Return lRet

/*/{Protheus.doc} scpSql
    Script sql.
    @type  Static Function
    @author Everson
    @since 09/10/2020
    @version 01
    /*/
Static Function scpSql(cProduto)

    //Vari�veis.
    Local cQuery := ""

    //
    cQuery += " SELECT " 
    cQuery += " B1_COD, B1_CODEMB, B1_SEGUM, EE5_PESO, ZC_TARA " 
    cQuery += " FROM " 
    cQuery += " " + RetSqlName("SB1") + " (NOLOCK) AS SB1 " 
    cQuery += " INNER JOIN " 
    cQuery += " " + RetSqlName("EE5") + " (NOLOCK) AS EE5 ON " 
    cQuery += " B1_CODEMB = EE5_CODEMB " 
    cQuery += " INNER JOIN " 
    cQuery += " " + RetSqlName("SZC") + " (NOLOCK) AS SZC ON " 
    cQuery += " B1_SEGUM = ZC_UNIDADE " 
    cQuery += " WHERE " 
    cQuery += " B1_FILIAL = '" + FWxFilial("SB1") + "' " 
    cQuery += " AND B1_COD = '" + cProduto + "' " 
    cQuery += " AND SB1.D_E_L_E_T_ = '' " 
    cQuery += " AND EE5.D_E_L_E_T_ = '' " 
    cQuery += " AND SZC.D_E_L_E_T_ = '' " 

Return cQuery
