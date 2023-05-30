#Include "Protheus.ch"
#Include "Topconn.ch"

Static xPula   := Chr(13) + Chr(10)
Static cCodUsr := ""
Static lAdm    := .F.
Static lBack   := .F.
Static lVend   := .F.
Static lSuperv := .F.
Static lDiret  := .F.

/*/{Protheus.doc} User Function ADVEN130P
    Gestão de Preços Mínimos.
    @type  Function
    @author Everson
    @since 26/05/2023
    @version 01
/*/
User Function ADVEN130P()

    //Variáveis.
    Local oContainer := Nil
    Local aCampos    := getCmps()
    Local nCWidth    := (((Len(aCampos)-5)/2)*83)
    Local nWidth     := 365 + Iif(nCWidth < 0, 0, nCWidth)

    carVariaveis()

    If ! (lAdm .Or. lBack .Or. lDiret)
        Return Nil

    EndIf

    oDialog			  := MsDialog():Create()
	oDialog:cName     := "oDialog"
	oDialog:cCaption  := "Gestão de Preços Mínimos"
	oDialog:nLeft     := 34
	oDialog:nTop      := 222
	oDialog:nWidth    := 1200
	oDialog:nHeight   := 600
	oDialog:lShowHint := .F.
	oDialog:lCentered := .T.

        oScroll := TScrollArea():New(oDialog)
        oScroll:Align := CONTROL_ALIGN_ALLCLIENT

        oContainer := TPanel():Create(oScroll, 010, 010, ,,,,,, nWidth,300)

        oScroll:SetFrame( oContainer )

        u_BrwArray(oContainer, aCampos)

     oDialog:Activate()

Return Nil
/*/{Protheus.doc} carVariaveis
    Carrega variáveis estáticas.
    @type  Static Function
    @author Everson
    @since 26/05/2023
    @version 01
/*/
Static Function carVariaveis()

    //Variáveis.
    Local aArea     := GetArea()

    U_ADVE118Q(@cCodUsr, @lAdm, @lBack, @lVend, @lSuperv, @lDiret)

    RestArea(aArea)

Return Nil
Static Function u_BrwArray(oContainer, aCampos)
 
    Local oFwBrowse   := Nil
    Local aColumns    := {}
    Local aItems      :={}
    Local nX
 
 
    oFwBrowse := FWBrowse():New(oContainer)
    oFwBrowse:SetDataArrayoBrowse()  //Define utilização de array
 
    aItems := LoadItems()      //Carregar os itens que irão compor o conteudo do grid
    oFwBrowse:SetArray(aItems) //Indica o array utilizado para apresentação dos dados no Browse.
 
    aColumns := RetColumns( aItems, aCampos)
 
    //Cria as colunas do array
    For nX := 1 To Len(aColumns )
        oFwBrowse:AddColumn( aColumns[nX] )
    Next
 
    oFwBrowse:SetOwner(oContainer)
    oFwBrowse:SetDescription( "Browse com Array" )
     oFwBrowse:DisableConfig()
    oFwBrowse:DisableReport()
    oFwBrowse:SetInsert(.T.)
    oFwBrowse:SetEditCell(.T., {|| .t. })
    // oFwBrowse:oBrowse:SetIniWindow({|| init(oFwBrowse) })
    oFwBrowse:Activate()
 
 
Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 29/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function init(oFwBrowse)
    
Return Nil
 
Static Function RetColumns(aItems, aCampos)

    //Variáveis.
    Local aColumns  := {}
    Local nAux      := 1

    For nAux := 1 To Len(aCampos)
 
        Aadd(aColumns, {;
                            aCampos[nAux][5],;               // [n][01] Título da coluna
                            {|oBrw| aItems[oBrw:At(), 1] },; // [n][02] Code-Block de carga dos dados
                            aCampos[nAux][2],;               // [n][03] Tipo de dados
                            aCampos[nAux][6],;               // [n][04] Máscara
                            aCampos[nAux][7],;               // [n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
                            aCampos[nAux][3],;               // [n][06] Tamanho
                            aCampos[nAux][4],;               // [n][07] Decimal
                            .T.,;                            // [n][08] Indica se permite a edição
                            {|| },;                          // [n][09] Code-Block de validação da coluna após a edição
                            .F.,;                            // [n][10] Indica se exibe imagem
                            Nil,;                            // [n][11] Code-Block de execução do duplo clique
                            aCampos[nAux][1],;               // [n][12] Variável a ser utilizada na edição (ReadVar)
                            {|| AlwaysTrue()},;              // [n][13] Code-Block de execução do clique no header
                            .F.,;                            // [n][14] Indica se a coluna está deletada
                            .F.,;                            // [n][15] Indica se a coluna será exibida nos detalhes do Browse
                            {},;                             // [n][16] Opções de carga dos dados (Ex: 1=Sim, 2=Não)
                            "ID" + cValToChar(nAux)})        // [n][17] Id da coluna


    Next nAux
 
Return aColumns
/*/{Protheus.doc} getCmps
    Retorna os campos utilizados.
    @type  Static Function
    @author Everson
    @since 26/05/2023
    @version 01
/*/
Static Function getCmps()

    //Variáveis.
    Local aCampos  := {}
    Local aCodigos := dadosSup()
    Local nAux     := 1

    Aadd(aCampos, {"LOCEXP", "C", TamSX3("ZJA_LOCEXP")[1] , 0, "Local Expedição" , pesqPict("ZJA", "ZJA_LOCEXP"), 1})
    Aadd(aCampos, {"PRODUT", "C", TamSX3("B1_COD")[1]     , 0, "Produto"         , pesqPict("SB1", "B1_COD")    , 1})
    Aadd(aCampos, {"DESCRI", "C", TamSX3("B1_DESC")[1]    , 0 , "Des Produto"    , pesqPict("SB1", "B1_DESC")   , 1})
    Aadd(aCampos, {"PRECTO", "N", TamSX3("ZJB_PRCVEN")[1] , TamSX3("ZJB_PRCVEN")[2], "R$", pesqPict("ZJB", "ZJB_PRCVEN"), 2})
    Aadd(aCampos, {"BLTQT",  "C", 1                       , 0, "Bloqueado", "@!", 1})

    // For nAux := 1 To Len(aCodigos)
    //     Aadd(aCampos, {"VL"+aCodigos[nAux], "N", TamSX3("ZJB_PRCVEN")[1] , TamSX3("ZJB_PRCVEN")[2], "R$", pesqPict("ZJB", "ZJB_PRCVEN"), 10})
    //     Aadd(aCampos, {"BL"+aCodigos[nAux], "C", 1                       , 0, "Bloqueado", "@!", 10})

    // Next nAux

Return aCampos
Static Function LoadItems()

    //Variáveis.
   Local aLinha     := {}
   Local nX
 
    For nX := 1 To 1
        aAdd(aLinha,{ Space(TamSX3("ZJA_LOCEXP")[1]), Space(TamSX3("B1_COD")[1]), Space(TamSX3("B1_DESC")[1]), 0, Space(1)})
    Next
Return aLinha
/*/{Protheus.doc} dadosSup
    Retorna código dos supervisores.
    @type  Static Function
    @author Everson
    @since 26/05/2023
    @version 01
/*/
Static Function dadosSup()

    //Variáveis.
    Local cQuery := ""
    Local aDados := {}
    Local cAlias := GetNextAlias()

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " DISTINCT A3_COD " 
    cQuery += " FROM  " 
        cQuery += " " + RetSqlName("SA3") + " (NOLOCK) AS SA3 " 
    cQuery += " WHERE  " 
        cQuery += " A3_FILIAL = '" + FWxFilial("SA3") + "' " 
        cQuery += " AND A3_COD = A3_SUPER  " 
        cQuery += " AND D_E_L_E_T_ = ''  " 
    cQuery += " ORDER BY A3_COD " 

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    While ! (cAlias)->(Eof())

        Aadd(aDados, (cAlias)->A3_COD)

        (cAlias)->(DbSkip())

    End
    
Return aDados
