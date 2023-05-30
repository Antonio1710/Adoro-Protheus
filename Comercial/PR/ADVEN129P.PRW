
#Include "Protheus.ch"
#Include "Topconn.ch"

Static xPula   := Chr(13) + Chr(10)
Static cCodUsr := ""
Static lAdm    := .F.
Static lBack   := .F.
Static lSuperv := .F.
Static lDiret  := .F.
Static lVend   := .F.  

/*/{Protheus.doc} User Function ADVEN129P
    Rotina para acompanhamento de cotas x total vendido.
    Ticket 91301.
    @type  Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
User Function ADVEN129P()

    //Variáveis.
    Local aCoord	:= FWGetDialogSize(oMainWnd)
    Local oDialog   := Nil
    Local aTitulos	:= { "Ad'oro VP", "Ad'oro Itapira", "Vista Foods"}
    Local aPages	:= {"Plan01","Plan02", "Plan03"}

    carVariaveis()

    If ! (lAdm .Or. lBack .Or. lDiret .Or. lSuperv)
        Return Nil

    EndIf

    oDialog			  := MsDialog():Create()
	oDialog:cName     := "oDialog"
	oDialog:cCaption  := "Cotas"
	oDialog:nTop      := aCoord[1]
	oDialog:nLeft     := aCoord[2]
	oDialog:nHeight   := aCoord[3]
	oDialog:nWidth    := aCoord[4]
	oDialog:lShowHint := .F.
	oDialog:lCentered := .T.

        oFolder:= TFolder():New(000, 000, aTitulos, aPages, oDialog)
        oFolder:Align := CONTROL_ALIGN_ALLCLIENT

        //Várzea.
        oBrVP := getBrowse(oFolder:aDialogs[1], "0102")
        oBrVP:Activate()

        //Itapira.
        oBRIT := getBrowse(oFolder:aDialogs[2], "010B")
        oBRIT:Activate()

        //Vista Foods.
        oBRVF := getBrowse(oFolder:aDialogs[3], "1301")
        oBRVF:Activate()

     oDialog:Activate()
    
Return Nil
/*/{Protheus.doc} carVariaveis
    Carrega variáveis estáticas.
    @type  Static Function
    @author Everson
    @since 29/05/2023
    @version 01
/*/
Static Function carVariaveis()

    //Variáveis.
    Local aArea     := GetArea()

    U_ADVE118Q(@cCodUsr, @lAdm, @lBack, @lVend, @lSuperv, @lDiret)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} getBrowse
    
    @type  Static Function
    @author Everson
    @since 29/05/2023
    @version 01
/*/
Static Function getBrowse(oContainer, cLocExp)
    
    //Variáveis.
    Local oFwBrowse   := Nil
    Local aColumns    := {}
    Local aItems      :={}
    Local nX
 
    oFwBrowse := FWBrowse():New(oContainer)
    oFwBrowse:SetDataArrayoBrowse()
 
    aItems := carDados(cLocExp)      
    oFwBrowse:SetArray(aItems)
 
    aColumns := RetColumns(aItems)
 
    For nX := 1 To Len(aColumns )
        oFwBrowse:AddColumn(aColumns[nX])

    Next
 
    oFwBrowse:SetOwner(oContainer)
    oFwBrowse:DisableConfig()
    oFwBrowse:DisableReport()
 
Return oFwBrowse
/*/{Protheus.doc} RetColumns
    Retorna colunas.
    @type  Static Function
    @author Everson
    @since 29/05/2023
    @version 01
/*/
Static Function RetColumns(aItems)

    //Variáveis.
    Local aColumns  := {}
    Local nAux      := 1
    Local aCampos   := getCmps()

    For nAux := 1 To Len(aCampos)
 
        Aadd(aColumns, {;
                            aCampos[nAux][5],;               // [n][01] Título da coluna
                            {|oBrw| aItems[oBrw:At(), 1] },; // [n][02] Code-Block de carga dos dados
                            aCampos[nAux][2],;               // [n][03] Tipo de dados
                            aCampos[nAux][6],;               // [n][04] Máscara
                            aCampos[nAux][7],;               // [n][05] Alinhamento (0=Centralizado, 1=Esquerda ou 2=Direita)
                            aCampos[nAux][3],;               // [n][06] Tamanho
                            aCampos[nAux][4],;               // [n][07] Decimal
                            .F.,;                            // [n][08] Indica se permite a edição
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

    Aadd(aCampos, {"PRODUT", "C", TamSX3("B1_COD")[1]     , 0, "Código"      , pesqPict("SB1", "B1_COD") , 1})
    Aadd(aCampos, {"DESCRI", "C", TamSX3("B1_DESC")[1]    , 0, "Des Produto" , pesqPict("SB1", "B1_DESC"), 1})
    Aadd(aCampos, {"TOTAL",  "N", TamSX3("ZJB_PRCVEN")[1] , 0, "Total"       , "@E 999,999,999", 2})
    Aadd(aCampos, {"VENDA",  "N", TamSX3("ZJB_PRCVEN")[1] , 0, "Venda"       , "@E 999,999,999", 2})
    Aadd(aCampos, {"SALDO",  "N", TamSX3("ZJB_PRCVEN")[1] , 0, "Saldo"       , "@E 999,999,999", 2})

Return aCampos
/*/{Protheus.doc} carDados
    Carrega dados.
    @type  Static Function
    @author Everson
    @since 29/05/2023
    @version 01
/*/
Static Function carDados(cLocExp)

    //Variáveis.
   Local aLinha     := {}
    
    Aadd(aLinha,{ Space(TamSX3("B1_COD")[1]), Space(TamSX3("B1_DESC")[1]), 0, 0, 0})

Return aLinha
