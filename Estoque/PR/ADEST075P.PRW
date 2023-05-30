#Include "Totvs.ch"
#Include "Topconn.ch"

Static xPula := Chr(13) + Chr(10)

/*/{Protheus.doc} User Function ADEST075P
    Liberação de sequestro de pesagem.
    Lib sequestro pesagem
    Chamado 18465.
    @type  Function
    @author Everson
    @since 05/04/2022
    @version 01
    @history Everson, 07/10/2022, ticket 18465 - Opções para liberação de sequestro.
    @history Everson, 17/01/2023, ticket 18465 - Adiciona informação de tes na geração de devolução para o fornecedor.
    @history Everson, 21/02/2023, ticket 18465 - Correção posicionamento na tabela ZIG.
/*/
User Function ADEST075P() // U_ADEST075P()

    //Variáveis.
    Local oLibSeq   := Nil
    Local aRadio    := libOpcoes()
    Local oFechar   := Nil
    Local oPnMaster := Nil
    Local oPesagens := Nil
    Local aPesagens := {}
    Local oDtIni    := Nil
    Local dDtIni    := Date()-30
    Local oDtFim    := Nil
    Local dDtFim    := Date()
    Local cObservao := Space(100)
    Local oFilDest  := Nil
    Local cFilDest  := ""
    Local aFilDest  := getFiliais(cEmpAnt)
    
    Private oConfirm  := Nil
    Private oRadio    := Nil
    Private nRadio    := 1
    Private nQtdOrd   := 0
    Private nQtdBal   := 0
    Private nQtdDif   := 0
    Private nPerTot   := 0
    Private nPerDif   := 0

    oLibSeq			  := MsDialog():Create()
	oLibSeq:cName     := "oLibSeq"
	oLibSeq:cCaption  := "Liberação de Pesagens Sequestradas"
	oLibSeq:nLeft     := 34
	oLibSeq:nTop      := 222
	oLibSeq:nWidth    := 1200
	oLibSeq:nHeight   := 600
	oLibSeq:lShowHint := .F.
	oLibSeq:lCentered := .T.

        oDtIni := TGet():New(003,005,{|u|If(PCount() == 0,dDtIni,dDtIni := u)}, oLibSeq,070,010,"@D",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtIni",,,,.T.,,,"Data Inicial",1) 

        oDtFim := TGet():New(003,080,{|u|If(PCount() == 0,dDtFim,dDtFim := u)}, oLibSeq,070,010,"@D",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtFim",,,,.T.,,,"Data Final",1) 

        TButton():New(010,155,"Filtrar", oLibSeq,{||;
            MsAguarde({|| carPesagens(dDtIni, dDtFim, oPesagens, @aPesagens) }, "Aguarde", "Carregando registros...");
        },035,011,,,.F.,.T.,.F.,,.F.,,,.F. )

        TGet():New(003,195,{|u|If(PCount() == 0,nQtdOrd,nQtdOrd := u)}, oLibSeq, 070,015,"@E 999,999,999.999",,0,16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"nQtdOrd",,,,.T.,,,"Qtde. Ordem",1)  
        TGet():New(003,270,{|u|If(PCount() == 0,nQtdBal,nQtdBal := u)}, oLibSeq, 070,015,"@E 999,999,999.999",,0,16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"nQtdBal",,,,.T.,,,"Qtde. Balança",1)  
        TGet():New(003,345,{|u|If(PCount() == 0,nQtdDif,nQtdDif := u)}, oLibSeq, 070,015,"@E 999,999,999.999",,0,16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"nQtdDif",,,,.T.,,,"Qtde. Diferença",1)  
        TGet():New(003,420,{|u|If(PCount() == 0,nPerTot,nPerTot := u)}, oLibSeq, 070,015,"@E 999,999,999.999",,0,16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"nPerTot",,,,.T.,,,"%Tot",1)  
        TGet():New(003,495,{|u|If(PCount() == 0,nPerDif,nPerDif := u)}, oLibSeq, 070,015,"@E 999,999,999.999",,0,16777215,,.F.,,.T.,,.F.,{|| .F. },.F.,.F.,,.F.,.F. ,,"nPerDif",,,,.T.,,,"%Dif",1)  

        oPnMaster := TPanel():New(030,005,,oLibSeq,,,,,,590,200)
 
        oPesagens := FwBrowse():New()
        oPesagens:setOwner(oPnMaster)
        oPesagens:setDataArray()
        oPesagens:setArray(aPesagens)
        oPesagens:disableConfig()
        oPesagens:disableReport()
    
        oPesagens:AddMarkColumns({|| Iif(aPesagens[oPesagens:nAt,01], "LBOK", "LBNO")},;
                                  {|| selecReg(oPesagens, @aPesagens)})
    
        oPesagens:addColumn({"Data"              , {||aPesagens[oPesagens:nAt,02]}, "D", ""                  , 1, 010    ,   , .T. , , .F.,, "aPesagens[oPesagens:nAt,02]",, .F., .T., , "ID2" })
        oPesagens:addColumn({"Hora"              , {||aPesagens[oPesagens:nAt,03]}, "C", ""                  , 1, 008    ,   , .T. , , .F.,, "aPesagens[oPesagens:nAt,03]",, .F., .T., , "ID3" })
        oPesagens:addColumn({"Produto"           , {||aPesagens[oPesagens:nAt,04]}, "C", ""                  , 1, 060    ,   , .T. , , .F.,, "aPesagens[oPesagens:nAt,04]",, .F., .T., , "ID4" })
        oPesagens:addColumn({"Ordem/Agrup."      , {||aPesagens[oPesagens:nAt,05]}, "C", ""                  , 1, 010    ,   , .T. , , .F.,, "aPesagens[oPesagens:nAt,05]",, .F., .T., , "ID5" })
        oPesagens:addColumn({"Tipo"              , {||aPesagens[oPesagens:nAt,15]}, "C", ""                  , 1, 005    ,   , .T. , , .F.,, "aPesagens[oPesagens:nAt,15]",, .F., .T., , "ID15"})
        oPesagens:addColumn({"Operação"          , {||aPesagens[oPesagens:nAt,06]}, "C", ""                  , 1, 020    ,   , .T. , , .F.,, "aPesagens[oPesagens:nAt,06]",, .F., .T., , "ID6" })
        oPesagens:addColumn({"Veículo"           , {||aPesagens[oPesagens:nAt,07]}, "C", ""                  , 1, 007    ,   , .T. , , .F.,, "aPesagens[oPesagens:nAt,07]",, .F., .T., , "ID7" })
        oPesagens:addColumn({"Peso Inicial"      , {||aPesagens[oPesagens:nAt,08]}, "N", "@E 999,999,999.999", 2, 015    ,   , .T. , , .F.,, "aPesagens[oPesagens:nAt,08]",, .F., .T., , "ID8" })
        oPesagens:addColumn({"Peso Final"        , {||aPesagens[oPesagens:nAt,09]}, "N", "@E 999,999,999.999", 2, 015    ,   , .T. , , .F.,, "aPesagens[oPesagens:nAt,09]",, .F., .T., , "ID9" })
        oPesagens:addColumn({"Peso Liquido"      , {||aPesagens[oPesagens:nAt,10]}, "N", "@E 999,999,999.999", 2, 015    ,   , .T. , , .F.,, "aPesagens[oPesagens:nAt,10]",, .F., .T., , "ID10"})

        oPesagens:Activate()

        oRadio := TRadMenu():New (235,005,aRadio,,oLibSeq,,,,,,,,500,15,,,,.T.)
        oRadio:bSetGet := {|u| Iif(PCount() == 0, nRadio, nRadio := u)}
        oRadio:lHoriz := .T.
        oRadio:bChange := {|| Iif(nRadio <> 4 , oFilDest:disable(), oFilDest:enable()) }
        oRadio:disable()

        TGet():New(250,005,{|u|If(PCount() == 0,cObservao,cObservao := u)}, oLibSeq, 255,015,"",,0,16777215,,.F.,,.T.,,.F.,{|| .T. },.F.,.F.,,.F.,.F. ,,"cObservao",,,,.T.,,,"Obs.:",1)  

	    oFilDest := TComboBox():New(250,265,{|u|if(PCount() > 0 ,cFilDest := u,cFilDest)},;
	    aFilDest,100,15, oLibSeq,,{|| },,,,.T.,,,,/*{|| nRadio == 4 }*/,,,,,"cFilDest","Filial Destino",1)

        oFechar := TButton():New(270,510,"Fechar", oLibSeq,{|| oLibSeq:End() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        oFechar:SetCss("QPushButton{background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #FF0000, stop: 1 #8C1717);color: white}")	

        oConfirm := TButton():New(270,555,"Confirmar", oLibSeq,{|| Iif( ! confirmar(oPesagens, aPesagens, nRadio, cObservao, cFilDest), Nil, Eval({||carPesagens(dDtIni, dDtFim, oPesagens, @aPesagens), zeraDados()}) ) },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
        oConfirm:disable()

    oLibSeq:Activate(,,,.T.,{||.T.},, {|| carPesagens(dDtIni, dDtFim, oPesagens, @aPesagens) })

Return Nil
/*/{Protheus.doc} getFiliais
    Retorna filiais.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function getFiliais(cEmp)

    //Variáveis.
    Local aArea     := GetArea()
    Local aFiliais  := {}
    Local aFilAux   := FWAllFilial()
    Local nAux      := 1
    Local aSM0Data2 := {}

    For nAux := 1 To Len(aFilAux)

        aSM0Data2 := FWSM0Util():GetSM0Data(cEmp, aFilAux[nAux])

        Aadd(aFiliais, Alltrim(cValToChar(aSM0Data2[2][2])) + "=" + Alltrim(cValToChar(aSM0Data2[3][2])))

    Next nAux

    RestArea(aArea)

Return aFiliais
/*/{Protheus.doc} carPesagens
    Carrega registros de pesagens s equestradas.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function carPesagens(dDtIni, dDtFim, oPesagens, aPesagens)

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cProduto  := ""
    Local cOperacao := ""
    Local nIndex    := 0

    cQuery    := " SELECT * FROM " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG WHERE ZIG_FILIAL = '" + FWxFilial("ZIG") + "' AND ZIG_DTPES2 >= '" + DToS(dDtIni) + "' AND ZIG_DTPES2 <= '" + DToS(dDtFim) + "' AND ZIG_INICIA = '4' AND ZIG_TPSEQU = '1' AND ZIG.D_E_L_E_T_ = '' ORDER BY ZIG_ORDEM "

    aPesagens := {}

    If Select("D_PES") > 0 
        D_PES->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_PES"
    DbSelectArea("D_PES")
    While ! D_PES->(Eof())

        nIndex := Iif(D_PES->ZIG_AGRUPA == "1", 3, 2)
        cProduto := getDes(D_PES->ZIG_ORDEM, nIndex)

        If ! U_ADFAT17U(D_PES->ZIG_CTPATI)
            D_PES->(DbSkip())
            Loop
            
        EndIf

        If D_PES->ZIG_TPMOV == "R" .And. ZIB->ZIB_STATUS == "6" //Everson - 21/02/2023 - ticket 18465.
            D_PES->(DbSkip())
            Loop

        EndIf

        cOperacao := Alltrim(cValToChar(Posicione("ZI9", 1, FWxFilial("ZI9") + ZIB->ZIB_CODROT, "ZI9_ROTEIR")))

        Aadd(aPesagens,{;
            .F.,;                       //01 - Marcação.
            SToD(D_PES->ZIG_DTPES2),;   //02 - Data da última pesagem.
            D_PES->ZIG_HRPES2,;         //03 - Hora da última pesagem.
            cProduto,;                  //04 - Produtos.
            D_PES->ZIG_ORDEM,;          //05 - Ordem de pesagem.
            cOperacao,;                 //06 - Operação.
            D_PES->ZIG_PLACA,;          //07 - Placa.
            D_PES->ZIG_PESINI,;         //08 - Pesagem inicial.
            D_PES->ZIG_PESFIM,;         //09 - Pesagem final.
            D_PES->ZIG_PESOLI,;         //10 - Peso liquido.
            D_PES->ZIG_PESORD,;         //11 - Peso da ordem.
            D_PES->ZIG_UNTOLE,;         //12 - Unidade de medida da tolerância.
            D_PES->ZIG_QTTOLE,;         //13 - Tolerância.
            D_PES->ZIG_QUEBRA,;         //14 - Quebra.
            D_PES->ZIG_TPMOV,;          //15 - Tipo movimento.
            D_PES->ZIG_AGRUPA,;         //16 - Agrupada.
            D_PES->ZIG_NUMERO;          //17 - Número do ticket de pesagem.
        })

        D_PES->(DbSkip())

    End
    D_PES->(DbCloseArea())

    oPesagens:setArray(aPesagens)
    oPesagens:Refresh()

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} getDes
    Carrega produtos.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function getDes(cNmOrdem, nIndex)

    //Variáveis.
    Local aArea     := GetArea()
    Local cProduto  := ""

    DbSelectArea("ZIF")
    ZIF->(DbSetOrder(nIndex))
    If ! ZIF->( DbSeek( FWxFilial("ZIF") + cNmOrdem ) )
        MsgInfo("Ordem/agrupador " + cNmOrdem + " não localizada(o).", "Função getDes(ADEST075P)")
        RestArea(aArea)
        RestArea(aArea)

    EndIf

    If nIndex == 2

         cProduto := U_ADFAT176(ZIF->ZIF_PRDSAG, ZIF->ZIF_PRDPRO)

    ElseIf nIndex == 3

        While ! ZIF->(Eof()) .And. FWxFilial("ZIF") == ZIF->ZIF_FILIAL .And. ZIF->ZIF_AGRUPA == cNmOrdem

            cProduto += U_ADFAT176(ZIF->ZIF_PRDSAG, ZIF->ZIF_PRDPRO) + Space(1)

            ZIF->(DbSkip())

        End

    EndIf

    RestArea(aArea)

Return cProduto
/*/{Protheus.doc} selecReg
    Marca registro.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function selecReg(oBrowse, aArquivo)

    //Variáveis.
    Local nAux      := 1
    Local nLinha    := oBrowse:nAt
    Local lMarca    := !aArquivo[oBrowse:nAt,1]
    Local nPerCTol  := 0
    Local nPerCDif  := 0
    Local cTpMovi   := Alltrim(cValToChar(aArquivo[oBrowse:nAt,15]))

    aArquivo[oBrowse:nAt,01] := lMarca
    
    For nAux := 1 To Len(aArquivo)

        If nAux <> nLinha
            aArquivo[nAux, 01] := .F.

        EndIf

    Next nAux

    If !lMarca
        
        zeraDados()
        oRadio:setOption(1)
        oRadio:disable()
        oConfirm:disable()

    Else

        If aArquivo[oBrowse:nAt,12] == "PC"
            nPerCTol := aArquivo[oBrowse:nAt,13]

        Else
            nPerCTol := Iif(aArquivo[oBrowse:nAt,11] == 0, 0, Round(aArquivo[oBrowse:nAt,13]/aArquivo[oBrowse:nAt,11] * 100,2))

        EndIf

        nPerCDif := Iif(aArquivo[oBrowse:nAt,11] == 0, 0, Round(aArquivo[oBrowse:nAt,14]/aArquivo[oBrowse:nAt,11] * 100,2))

        nQtdOrd   := aArquivo[oBrowse:nAt,11]
        nQtdBal   := aArquivo[oBrowse:nAt,10]
        nQtdDif   := aArquivo[oBrowse:nAt,14]
        nPerTot   := nPerCTol
        nPerDif   := nPerCDif

        oRadio:enable()

        If cTpMovi == "E"
            oRadio:setOption(1)
            oRadio:enableItem(5, .F.)

            oConfirm:enable()

        ElseIf cTpMovi == "O"
            oRadio:setOption(1)
            oRadio:enableItem(5, .T.)

            oConfirm:enable()

        ElseIf cTpMovi == "R"
            oRadio:enableItem(1, .F.)
            oRadio:enableItem(2, .F.)
            oRadio:enableItem(3, .F.)
            oRadio:enableItem(4, .F.)
            oRadio:enableItem(5, .T.)
            oRadio:enableItem(6, .F.)
            oRadio:setOption(5)
            
            oConfirm:enable()

        ElseIf cTpMovi == "S"
            oRadio:disable()
            oConfirm:disable()

        EndIf

    EndIf

    oBrowse:Refresh()

Return Nil
/*/{Protheus.doc} zeraDados
    Zera variáveis do cabeçalho da interface.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function zeraDados()

    nQtdOrd   := 0
    nQtdBal   := 0
    nQtdDif   := 0
    nPerTot   := 0
    nPerDif   := 0

Return Nil
/*/{Protheus.doc} confirmar
    Processa a ação da liberação do sequestro da pesagem.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function confirmar(oPesagens, aPesagens, nRadio, cObservao, cFilDest)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local aDados    := ""
    Local nAux      := 1
    Local cNmOrdem  := ""

    If nRadio == Nil .Or. nRadio <= 0
        MsgInfo("Selecione uma opção.", "Função confirmar(ADEST075P)")
        RestArea(aArea)
        Return .F.

    EndIf

    For nAux := 1 To Len(aPesagens)
        If aPesagens[nAux,01]
            aDados := AClone(aPesagens[nAux])

        EndIf

    Next nAux

    If Len(aDados) <= 0
        MsgInfo("Selecione uma pesagem sequestrada.", "Função confirmar(ADEST075P)")
        RestArea(aArea)
        Return .F.

    EndIf

    cNmOrdem := aDados[5]

    If ! MsgYesNo("Deseja liberar a ordem de pesagem " + cNmOrdem + ".", "Função confirmar(ADEST075P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If nRadio == 1 //Desconto financeiro.
        MsAguarde({|| lRet := descFin(cNmOrdem, aDados, nRadio, cObservao) }, "Função confirmar(ADEST075P)", "Gerando desconto...")

    ElseIf nRadio == 2 //Quebra de estoque.
        MsAguarde({|| lRet := lancQbr(cNmOrdem, aDados, nRadio, cObservao) }, "Função confirmar(ADEST075P)", "Gerando lançamento de estoque...")

    ElseIf nRadio == 3 //Devolução Fornecedor.
        MsAguarde({|| lRet := devFor(cNmOrdem, aDados, nRadio, cObservao) }, "Função confirmar(ADEST075P)", "Gerando devolução...")

    ElseIf nRadio == 4 //Transferência Filial.
        MsAguarde({|| lRet := transFil(cNmOrdem, aDados, nRadio, cObservao, cFilDest) }, "Função confirmar(ADEST075P)", "Gerando transferência...")

    ElseIf nRadio == 5 //Liberação Fábrica.
        MsAguarde({|| lRet := libFabr(cNmOrdem, aDados, nRadio, cObservao) }, "Função confirmar(ADEST075P)", "Liberando fábrica...")

    ElseIf nRadio == 6 //Complemento Fornecedor.
        MsAguarde({|| lRet := compForn(cNmOrdem, aDados, nRadio, cObservao) }, "Função confirmar(ADEST075P)", "Conferindo complemento...")

    EndIf

    If lRet
        MsgInfo("Processo finalizado", "Função confirmar(ADEST075P)")

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} descFin
    Efetua desconto financeiro.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function descFin(cNmOrdem, aDados, nRadio, cObservao)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cTicket   := aDados[17]
    Local cTitulo   := ""
    Local cSerie    := ""
    Local cFornec   := ""
    Local cLoja     := ""
    Local cItem     := ""
    Local nTotLiq   := 0
    Local cNaturez  := GetMv("MV_#EST751",,"22905")
    Local cItemC    := GetMv("MV_#EST752",,"")
    Local cCTADeb   := ""
    Local cCTACre   := GetMv("MV_#EST753",,"335220001")
    Local cCCC      := GetMv("MV_#EST755",,"")
    Local cHist     := "QUEBRA DE PESO BALANCA "
    Local nQuebra   := 0
    Local nVlrUnit  := 0
    Local cCond     := "0"
    Local lAgrupa   := .F.
    Local cProduto  := ""

    //Busca pela ordem de pesagem.
    If ! U_ADFAT16A(cNmOrdem) 

        //Busca pelo Agrupador.
        If ! U_ADFAT16F(cNmOrdem)
            Help(Nil, Nil, "Função descFin(ADEST075P)", Nil, "Ordem de pesagem/agrupador " + cNmOrdem + " não localizado." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        Else
            lAgrupa := .T.

        EndIf

    EndIf

    If ! U_ADFAT195(cTicket)
        Help(Nil, Nil, "Função descFin(ADEST075P)", Nil, "Ticket de pesagem " + cValToChar(cTicket) + " não localizado." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    cTitulo := ZIF->ZIF_NF
    cSerie  := ZIF->ZIF_SERIE
    cFornec := ZIF->ZIF_FORNEC
    cLoja   := ZIF->ZIF_LJFORN
    cItem   := Padl(Alltrim(cValToChar(ZIF->ZIF_ITEMNF)),4,"0")
    cProduto:= Alltrim(cValToChar(ZIF->ZIF_PRDPRO))
    cProduto:= cProduto + Space(TamSX3("D1_COD")[1] - Len(cProduto))
    nQuebra := Abs(ZIG->ZIG_QUEBRA)

    DbSelectArea("SD1")
    SD1->(DbSetOrder(1))
    If ! SD1->(DbSeek( FWxFilial("SD1") + cTitulo + cSerie + cFornec + cLoja +  cProduto + cItem ))
        Help(Nil, Nil, "Função descFin(ADEST075P)", Nil, "Nota fiscal " + cValToChar(cTitulo) + cValToChar(cSerie) + " não localizada." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    nVlrUnit := SD1->D1_VUNIT

    nTotLiq := Round(nQuebra * nVlrUnit,2)
    
    cHist   += "PRD " + Alltrim(cValToChar(ZIF->ZIF_PRDPRO)) + " QTD " + cValToChar(nQuebra) + " VLRUNT " + cValToChar(nVlrUnit)

    Begin Transaction

        //Lança desconto financeiro.
        If ! pDescFin(cTitulo, cFornec, cLoja, cCond, nTotLiq, cHist, cNaturez, cItemC, cCTADeb, cCTACre, cCCC)
            DisarmTransaction()
            Break

        EndIf

        //Envia registro para o barramento.
        If ! U_ADEST751(cNmOrdem, cTicket, ZIF->ZIF_PRDPRO, ZIF->ZIF_PRDSAG, cObservao, nRadio, "", "")
            DisarmTransaction()
            Break

        EndIf

        //Atualiza o status do ticket de pesagem.
        If ! U_ADFAT194(cTicket, cValToChar(nRadio), cObservao)
            DisarmTransaction()
            Break

        EndIf

        If !lAgrupa

            //Atualiza status da ordem de pesagem.
            If ! U_ADFAT164(cNmOrdem, "13", 1)
                DisarmTransaction()
                Break

            EndIf

        Else

            If ! U_ADFAT160(cNmOrdem, "13", 1)
                DisarmTransaction()
                Break

            EndIf

        EndIf

        lRet := .T.

    End Transaction

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} pDescFin
    Processa desconto financeiro.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function pDescFin(cTitulo, cFornec, cLoja, cCond, nTotLiq, cHist, cNaturez, cItemC, cCTADeb, cCTACre, cCCC)

	//Variáveis.
	Local aArea	 	:= GetArea()
	Local lRet		:= .T.
	Local aArray 	:= {}
	Local dData		:= Nil
	Local aRet		:= {}
	Local cParcela	:= Padl("1",TamSX3("E2_PARCELA")[1],"0")
	Local cQuery	:= ""
	
	Private lMsErroAuto := .F.
	
	// If Empty(cNaturez) .Or. Empty(cItemC) .Or. Empty(cCTADeb) .Or. Empty(cCTACre) //.Or. Empty(cCCC)
	// 	MsgInfo("Há parâmetro(s), para lançamento de NDF, não parametrizados.","Função pDescFin(ADEST075P)")
	// 	RestArea(aArea)
	// 	Return .F.
		
	// EndIf
	
    cQuery := ""
	cQuery += " SELECT  " 
	cQuery += " MAX(E2_PARCELA) AS E2_PARCELA  " 
	cQuery += " FROM " 
	cQuery += " " + RetSqlName("SE2") + " (NOLOCK) AS SE2 " 
	cQuery += " WHERE " 
	cQuery += " E2_FILIAL = '" + FWxFilial("SE2") + "' " 
	cQuery += " AND E2_PREFIXO = 'MAN' " 
	cQuery += " AND E2_NUM = '" + cTitulo + "' " 
	cQuery += " AND E2_TIPO = 'NDF' " 
	cQuery += " AND E2_FORNECE = '" + cFornec + "' " 
	cQuery += " AND E2_LOJA    = '" + cLoja + "' " 
	cQuery += " AND SE2.D_E_L_E_T_ = '' " 
	
	If Select("D_PARCSE2") > 0
		D_PARCSE2->(DbCloseArea())
		
	EndIf
	
	TcQuery cQuery New Alias "D_PARCSE2"
	DbSelectArea("D_PARCSE2")
	D_PARCSE2->(DbGoTop())
		cParcela := Soma1( Iif( Empty(Alltrim(cValToChar(D_PARCSE2->E2_PARCELA))),"0",Alltrim(cValToChar(D_PARCSE2->E2_PARCELA)) ) )
		cParcela := Padl(cParcela,TamSX3("E2_PARCELA")[1],"0")
	D_PARCSE2->(DbCloseArea())

    aRet := Condicao(nTotLiq,cCond,,Date())
	
	dData := aRet[1][1]
	
	aArray := { { "E2_PREFIXO"  , "MAN"     , Nil },;
	            { "E2_NUM"      , cTitulo   , Nil },;
	            { "E2_PARCELA"  , cParcela  , Nil },;
	            { "E2_TIPO"     , "NDF"     , Nil },;
	            { "E2_NATUREZ"  , cNaturez  , Nil },;
	            { "E2_FORNECE"  , cFornec   , Nil },;
	            { "E2_LOJA"     , cLoja     , Nil },;
	            { "E2_EMISSAO"  , Date()    , Nil },;
	            { "E2_HIST"     , cHist     , Nil },;
	            { "E2_VENCTO"   , dData     , Nil },;
	            { "E2_VENCREA"  , dData     , Nil },;
	            { "E2_VALOR"    , nTotLiq   , Nil },;		                        
	            { "E2_ITEMD"    , cItemC    , Nil },;
	            { "E2_ITEMC"    , cItemC    , Nil },;
	            { "E2_DEBITO"   , cCTADeb   , Nil },;
	            { "E2_CREDIT"   , cCTACre   , Nil },;
                { "E2_MOEDA"    , 1         , Nil }}
	
	// aArray := FWVetByDic(aArray ,"SE2", .F., 1)
	SetFunName("FINA050")
	MSExecAuto({|x,y| FINA050(x,y)}, aArray, 3)
	 
	If lMsErroAuto
        lRet := .F.
	    MostraErro()
	    
	EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} lancQbr
    Lança quebra de estoque.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function lancQbr(cNmOrdem, aDados, nRadio, cObservao)
    
    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cTicket   := aDados[17]
    Local lAgrupa   := .F.

    //Busca pela ordem de pesagem.
    If ! U_ADFAT16A(cNmOrdem) 

        //Busca pelo Agrupador.
        If ! U_ADFAT16F(cNmOrdem)
            Help(Nil, Nil, "Função lancQbr(ADEST075P)", Nil, "Ordem de pesagem/agrupador " + cNmOrdem + " não localizado." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        Else
            lAgrupa := .T.

        EndIf

    EndIf

    Begin Transaction

        //Gera registro de quebra de estoque no Protheus. (SD3)
        // If ! U_ADEST750(cNmOrdem, cTicket, aDados, nRadio, cObservao)
        //     DisarmTransaction()
        //     Break

        // EndIf

        //Envia registro para o barramento.
        If ! U_ADEST751(cNmOrdem, cTicket, ZIF->ZIF_PRDPRO, ZIF->ZIF_PRDSAG, cObservao, nRadio, "", "")
            DisarmTransaction()
            Break

        EndIf

        //Atualiza o status do ticket de pesagem.
        If ! U_ADFAT194(cTicket, cValToChar(nRadio), cObservao)
            DisarmTransaction()
            Break

        EndIf

	    If !lAgrupa

            //Atualiza status da ordem de pesagem.
            If ! U_ADFAT164(cNmOrdem, "13", 1)
                DisarmTransaction()
                Break

            EndIf

        Else

            If ! U_ADFAT160(cNmOrdem, "13", 1)
                DisarmTransaction()
                Break

            EndIf

        EndIf

        lRet := .T.

    End Transaction

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADEST750
    Process liberação por quebra.
    @type  User Function
    @author Everson
    @since 18/07/2022
    @version 01
/*/
User Function ADEST750(cTM, cProduto, nQuant, cLocal, cCC)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .T.

    // Local aCabec    := {}
    // Local aItem     := {}
    // Local aItens    := {}
    // Local cDoc      := ""
    // Local dData     := Date()

    // Private lMsErroAuto := .F.

    // Aadd(aCabec, {"D3_FILIAL",  FWxFilial("SD3"),  Nil})
    // Aadd(aCabec, {"D3_DOC",     cDoc,              Nil})
    // Aadd(aCabec, {"D3_TM",      cTM,               Nil})
    // Aadd(aCabec, {"D3_EMISSAO", dData,             Nil})

	// Aadd(aItem, {"D3_FILIAL",   FWxFilial("SD3"),  Nil})
	// Aadd(aItem, {"D3_DOC",      cDoc,              Nil})
	// Aadd(aItem, {"D3_COD",      cProduto,          Nil})
	// Aadd(aItem, {"D3_QUANT",    nQuant,            Nil})
	// Aadd(aItem, {"D3_LOCAL",    cLocal,            Nil})
	// Aadd(aItem, {"D3_CC",       cCC,               Nil})	

	// Aadd(aItens, aItem) 
	
	// MSExecAuto({|x,y,z| MATA241(x,y,z)}, aCabec, aItens, 3)

	// If lMsErroAuto
    //     lRet := .F.
	//     MostraErro()
    //    
	// EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} devFor
    Processa devolução para o fornecedor.
    @type  Static Function
    @author Everson
    @since 05/10/2022
    @version 01
/*/
Static Function devFor(cNmOrdem, aDados, nRadio, cObservao)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cTicket   := aDados[17]
    Local cTpPed    := "D"
    Local cNFOri    := ""
    Local cSerie    := ""
    Local cFornec   := ""
    Local cLoja     := ""
    Local aCampo    := {}
    Local cNmForn   := ""
    Local cItem     := ""
    Local cCliFor   := ""
    Local cTpFrt    := "S"
    Local cProduto  := ""
    Local nQuebra   := ""
    Local nVlrUnit  := 0
    Local cTes      := ""//Alltrim(cValToChar(GetMv("MV_#EST757",,"")))
    Local cLocPad   := ""
    Local cNvPed    := ""
    Local cEmail    := Alltrim(cValToChar(GetMv("MV_#EST756",,"noemi.ximenes@adoro.com.br;lucimara.luiz@adoro.com.br;rosangela@adoro.com.br;sistemas@adoro.com.br")))
    Local cMsgEmail := ""
    Local lAgrupa   := .F.

    //Busca pela ordem de pesagem.
    If ! U_ADFAT16A(cNmOrdem) 

        //Busca pelo Agrupador.
        If ! U_ADFAT16F(cNmOrdem)
            Help(Nil, Nil, "Função devFor(ADEST075P)", Nil, "Ordem de pesagem/agrupador " + cNmOrdem + " não localizado." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        Else
            lAgrupa := .T.

        EndIf

    EndIf

    //Busca pela ordem de pesagem / Agrupador.
    If ! U_ADFAT16A(cNmOrdem) .And. ! U_ADFAT16F(cNmOrdem)
        Help(Nil, Nil, "Função devFor(ADEST075P)", Nil, "Ordem de pesagem/agrupador " + cNmOrdem + " não localizado." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If ! U_ADFAT195(cTicket)
        Help(Nil, Nil, "Função devFor(ADEST075P)", Nil, "Ticket de pesagem " + cValToChar(cTicket) + " não localizado." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    cNFOri  := ZIF->ZIF_NF
    cSerie  := ZIF->ZIF_SERIE
    cFornec := ZIF->ZIF_FORNEC
    cLoja   := ZIF->ZIF_LJFORN
    cItem   := Padl(Alltrim(cValToChar(ZIF->ZIF_ITEMNF)),4,"0")
    cCliFor := ZIF->ZIF_CLIFOR
    cProduto:= Alltrim(cValToChar(ZIF->ZIF_PRDPRO))
    cProduto:= cProduto + Space(TamSX3("D1_COD")[1] - Len(cProduto))
    nQuebra := Abs(ZIG->ZIG_QUEBRA)
    cTes    := ZIG->ZIG_TES

    //Everosn, 17/01/2023, ticket 18465.
    If Empty(cTes)
        Help(Nil, Nil, "Função devFor(ADEST075P)", Nil, "Não há TES informado no ticket de pesagem (ZIG), para geração do pedido de devolução." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf
    
    DbSelectArea("SD1")
    SD1->(DbSetOrder(1))
    If ! SD1->(DbSeek( FWxFilial("SD1") + cNFOri + cSerie + cFornec + cLoja +  cProduto + cItem ))
        Help(Nil, Nil, "Função devFor(ADEST075P)", Nil, "Nota fiscal " + cValToChar(cNFOri) + cValToChar(cSerie) + " não localizada." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    nVlrUnit := SD1->D1_VUNIT

    cLocPad  := SD1->D1_LOCAL

    nTotLiq := Round(nQuebra * nVlrUnit,2)

    If ! getInfo(cCliFor, @aCampo, cFornec, cLoja)
        Help(Nil, Nil, "Função devFor(ADEST075P)", Nil, "Não foi possível obter os dados do fornecedor " + cValToChar(cFornec) + "/" + cValToChar(cLoja) + "." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    //Condição de pagamento.
    aCampo[5,2] := "000"

    Begin Transaction

        //Gera pedido de devolução.
        If ! U_ADEST752(cNmOrdem, cTpPed, cCliFor, cFornec, cLoja, aCampo, cTpFrt,;
                        "", "", "", nQuebra, cProduto,;
                        nVlrUnit, nTotLiq, cTes, cLocPad,;
                        cNFOri, cSerie, cItem,;
                        @cNvPed)
            DisarmTransaction()
            Break

        EndIf

        //Envia registro para o barramento.
        If ! U_ADEST751(cNmOrdem, cTicket, ZIF->ZIF_PRDPRO, ZIF->ZIF_PRDSAG, cObservao, nRadio, "", "")
            DisarmTransaction()
            Break

        EndIf

        //Atualiza o status do ticket de pesagem.
        If ! U_ADFAT194(cTicket, cValToChar(nRadio), cObservao)
            DisarmTransaction()
            Break

        EndIf

	    If !lAgrupa

            //Atualiza status da ordem de pesagem.
            If ! U_ADFAT164(cNmOrdem, "13", 1)
                DisarmTransaction()
                Break

            EndIf

        Else

            If ! U_ADFAT160(cNmOrdem, "13", 1)
                DisarmTransaction()
                Break

            EndIf

        EndIf

        cNmForn := aCampo[6,2]

        cMsgEmail := "Gerado pedido de devolução " + cNvPed + " Filial " + cFilAnt + xPula
        cMsgEmail += "Nota fiscal de entrada " + cNFOri + "-" + cSerie + xPula
        cMsgEmail += "Fornecedor " + cFornec + "/" + cLoja + " " + cNmForn + xPula + xPula + xPula
        cMsgEmail += "*** Necessário verificar o TES do pedido antes de emitir a NF ***" + xPula

        lRet := .T.

    End Transaction

    If lRet
        //ENVIAEMAIL(cFrom, cTos, cMensagem, cSubject, cAttachment)
        U_EnviaEmail(GetMv("MV_RELFROM"), cEmail, cMsgEmail, "Pedido de devolução " + cNvPed,"")

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADEST752
    Gera pedido SC5.
    @type  User Function
    @author Everson
    @since 06/10/2022
    @version 01
/*/
User Function ADEST752(cNmOrdem, cTpPed, cCliFor, cCodCliFor, cLoja, aCampo, cTpFrt,;
                       cPlaca, cTransp, cUFPlaca, nPesoLiq, cProduto,;
                       nVlrUnit, nTotal, cTes, cLocPad,;
                       cNFOri, cSerOri, cItemOri,;
                       cNvPed, cMsgError)

    //Variáveis.
    Local aArea  := GetArea()
    Local lRet   := .F.
    Local aCabec := {}
    Local aLinha := {}
    Local aItens := {}

    Private lMsErroAuto    := .F.
    Private lMsHelpAuto    := .T.
    Private lAutoErrNoFile := .F.

    Default cNvPed    := ""
    Default cMsgError := ""

    Aadd( aCabec, { "C5_TIPO"	  , cTpPed, Nil } )
    Aadd( aCabec, { "C5_CLIENTE"  , cCodCliFor, Nil } )
    Aadd( aCabec, { "C5_LOJACLI"  , cLoja, Nil } )
    Aadd( aCabec, { "C5_CONDPAG"  , aCampo[5,2], Nil } )
    Aadd( aCabec, { "C5_ENDERE"   , aCampo[1,2], Nil } )
    Aadd( aCabec, { "C5_EST"      , aCampo[2,2], Nil } )
    Aadd( aCabec, { "C5_BAIRRO"   , aCampo[3,2], Nil } )
    Aadd( aCabec, { "C5_CIDADE"   , aCampo[4,2], Nil } )
    Aadd( aCabec, { "C5_DTENTR"   , Date() + 7 , Nil } )
    Aadd( aCabec, { "C5_EMISSAO"  , Date()   , Nil } )

    Aadd( aCabec, { "C5_TPFRETE"  , cTpFrt  , .F. } )

    If Upper(cTpFrt) <> "S" //Everson - 13/09/2022. Ticket 79849.
        Aadd( aCabec, { "C5_FRETE"    , 0       , .F. } )
        Aadd( aCabec, { "C5_PLACA"    , cPlaca  , .F. } )
        Aadd( aCabec, { "C5_TRANSP"   , cTransp , .F. } )
        Aadd( aCabec, { "C5_UFPLACA"  , cUFPlaca, .F. } )

    EndIf
    
    Aadd( aCabec, { "C5_PESOL"    , nPesoLiq, Nil } )
    Aadd( aCabec, { "C5_PESOTOT"  , nPesoLiq, Nil } )
    Aadd( aCabec, { "C5_XORDPES"  , cNmOrdem, .F. } )

    //Item.
    Aadd( aLinha, { "C6_ITEM"	 , "001"	, Nil } )
    Aadd( aLinha, { "C6_PRODUTO" , cProduto	, Nil } )
    Aadd( aLinha, { "C6_UNSVEN"	 , nPesoLiq	,0 , Nil } )
    Aadd( aLinha, { "C6_PRCVEN"	 , nVlrUnit	,0 , Nil } )
    Aadd( aLinha, { "C6_VALOR"	 , nTotal	,0 , Nil } )
    Aadd( aLinha, { "C6_TES"	 , cTes	    ,.F. } )
    Aadd( aLinha, { "C6_LOCAL"	 , cLocPad  , Nil } )
    Aadd( aLinha, { "C6_PRUNIT"	 , nVlrUnit	,0 , Nil } )

    //Devolução.
    If cTpPed == "D"
        Aadd( aLinha, { "C6_NFORI"	    , cNFOri	,0 , Nil } )
        Aadd( aLinha, { "C6_SERIORI"	, cSerOri	,0 , Nil } )
        Aadd( aLinha, { "C6_ITEMORI"	, cItemOri	,0 , Nil } )

    EndIf

    //Itens.
    Aadd(aItens, aLinha)

    aCabec := FWVetByDic(aCabec,"SC5",.F.,1)
    aItens := FWVetByDic(aItens,"SC6",.T.,1)

    MSExecAuto( { |x, y, z, p| MATA410(x, y, z,,,,,,, p) }, aCabec, aItens, 3 )

    If lMsErroAuto
        cMsgError := MostraErro() 

    Else
        cNvPed := SC5->C5_NUM
        lRet := .T.

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} getInfo
    Obtém informações de cliente e fornecedor.
    @type  Static Function
    @author Everson
    @since 06/10/2022
    @version 01
/*/
Static Function getInfo(cCliFor, aCampo, cCodCF, cLoja)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())

    DbSelectArea("SA2")
    SA2->(DbSetOrder(1))
    SA2->(DbGoTop())

    If cCliFor == "C"

        If ! SA1->( DbSeek( FWxFilial("SA1") + cCodCF + cLoja))
            MsgInfo("Cliente " + cCodCF + cLoja + " não localizado.", "Função gerPedS(ADFAT017P)")

        Else
            lRet := .T.
            aCampo  := {{"A1_END", SA1->A1_END}, {"A1_EST", SA1->A1_EST}, {"A1_BAIRRO", SA1->A1_BAIRRO}, {"A1_CIDADE", SA1->A1_Mun}, {"A1_COND", SA1->A1_COND}, {"A1_NOME", SA1->A1_NOME}}

        EndIf

    Else

        If ! SA2->( DbSeek( FWxFilial("SA2") + cCodCF + cLoja))
            MsgInfo("Fornecedor " + cCodCF + cLoja + " não localizado.", "Função gerPedS(ADFAT017P)")

        Else
            lRet := .T.
            aCampo  := {{"A2_END", SA2->A2_END}, {"A2_EST", SA2->A2_EST}, {"A2_BAIRRO", SA2->A2_BAIRRO}, {"A2_CIDADE", SA2->A2_Mun}, {"A2_COND", SA2->A2_COND}, {"A2_NOME", SA2->A2_NOME}}

        EndIf

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} transFil
    Processa transferência entre filiais.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function transFil(cNmOrdem, aDados, nRadio, cObservao, cFilDest)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cTicket   := aDados[17]
    Local cTpPed    := "N"
    Local cNFOri    := ""
    Local cSerie    := ""
    Local cFornec   := ""
    Local cLoja     := ""
    Local aCampo    := {}
    Local cItem     := ""
    Local cCliFor   := ""
    Local cTpFrt    := "S"
    Local cProduto  := ""
    Local nQuebra   := ""
    Local nVlrUnit  := 0
    Local cTes      := Alltrim(cValToChar(GetMv("MV_#EST758",,"713")))
    Local cLocPad   := ""
    Local cNvPed    := ""
    Local cEmail    := Alltrim(cValToChar(GetMv("MV_#EST756",,"noemi.ximenes@adoro.com.br;lucimara.luiz@adoro.com.br;rosangela@adoro.com.br;sistemas@adoro.com.br")))
    Local cMsgEmail := ""
    Local aFilDest  := {}
    Local lAgrupa   := .F.

    //Busca pela ordem de pesagem.
    If ! U_ADFAT16A(cNmOrdem) 

        //Busca pelo Agrupador.
        If ! U_ADFAT16F(cNmOrdem)
            Help(Nil, Nil, "Função transFil(ADEST075P)", Nil, "Ordem de pesagem/agrupador " + cNmOrdem + " não localizado." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        Else
            lAgrupa := .T.

        EndIf

    EndIf

    If ! U_ADFAT195(cTicket)
        Help(Nil, Nil, "Função transFil(ADEST075P)", Nil, "Ticket de pesagem " + cValToChar(cTicket) + " não localizado." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    cNFOri  := ZIF->ZIF_NF
    cSerie  := ZIF->ZIF_SERIE
    cFornec := ZIF->ZIF_FORNEC
    cLoja   := ZIF->ZIF_LJFORN
    cItem   := Padl(Alltrim(cValToChar(ZIF->ZIF_ITEMNF)),4,"0")
    cCliFor := "C"
    cProduto:= Alltrim(cValToChar(ZIF->ZIF_PRDPRO))
    cProduto:= cProduto + Space(TamSX3("D1_COD")[1] - Len(cProduto))
    nQuebra := Abs(ZIG->ZIG_QUEBRA)
    
    DbSelectArea("SD1")
    SD1->(DbSetOrder(1))
    If ! SD1->(DbSeek( FWxFilial("SD1") + cNFOri + cSerie + cFornec + cLoja +  cProduto + cItem ))
        Help(Nil, Nil, "Função transFil(ADEST075P)", Nil, "Nota fiscal " + cValToChar(cNFOri) + cValToChar(cSerie) + " não localizada." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    nVlrUnit := SD1->D1_VUNIT

    cLocPad  := SD1->D1_LOCAL

    nTotLiq := Round(nQuebra * nVlrUnit,2)

    aFilDest := obtCodFil(cFilDest)

    If ! getInfo(cCliFor, @aCampo, aFilDest[1], aFilDest[2])
        Help(Nil, Nil, "Função transFil(ADEST075P)", Nil, "Não foi possível obter os dados do fornecedor " + cValToChar(cFornec) + "/" + cValToChar(cLoja) + "." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    Begin Transaction

        //Gera pedido de devolução.
        If ! U_ADEST752(cNmOrdem, cTpPed, cCliFor, aFilDest[1], aFilDest[2], aCampo, cTpFrt,;
                        "", "", "", nQuebra, cProduto,;
                        nVlrUnit, nTotLiq, cTes, cLocPad,;
                        "", "", "",;
                        @cNvPed)
            DisarmTransaction()
            Break

        EndIf

        //Envia registro para o barramento.
            //ADEST751(cNumOrd, cTicket, cPrdProth, cPrdSAG, cObs, nTpLib, cEmpDest, cFilDest, cNmFilDest)
        If ! U_ADEST751(cNmOrdem, cTicket, ZIF->ZIF_PRDPRO, ZIF->ZIF_PRDSAG, cObservao, nRadio, cEmpAnt, cFilDest)
            DisarmTransaction()
            Break

        EndIf

        //Atualiza o status do ticket de pesagem.
        If ! U_ADFAT194(cTicket, cValToChar(nRadio), cObservao)
            DisarmTransaction()
            Break

        EndIf

	    If !lAgrupa

            //Atualiza status da ordem de pesagem.
            If ! U_ADFAT164(cNmOrdem, "13", 1)
                DisarmTransaction()
                Break

            EndIf

        Else

            If ! U_ADFAT160(cNmOrdem, "13", 1)
                DisarmTransaction()
                Break

            EndIf

        EndIf

        cMsgEmail := "Gerado pedido de tranferência " + cNvPed + " Filial " + cFilAnt + xPula
        cMsgEmail += "Nota fiscal de entrada " + cNFOri + "-" + cSerie + xPula
        cMsgEmail += "Fornecedor " + cFornec + "/" + cLoja + " " + xPula + xPula + xPula
        cMsgEmail += "*** Necessário verificar o TES do pedido antes de emitir a NF ***" + xPula

        lRet := .T.

    End Transaction

    If lRet
        //ENVIAEMAIL(cFrom, cTos, cMensagem, cSubject, cAttachment)
        U_EnviaEmail(GetMv("MV_RELFROM"), cEmail, cMsgEmail, "Pedido de transferência " + cNvPed,"")

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} obtCodFil
    Retorna código e loja da filial de destino.
    @type  Static Function
    @author Everson
    @since 06/10/2022
    @version 01
/*/
Static Function obtCodFil(cFilDest)

    //Variáveis.
    Local aFilDest  := FWSM0Util():GetSM0Data( cEmpAnt , cFilDest, {"M0_CGC"})[1]
    Local cCGC      := aFilDest[2]

    DbSelectArea("SA1")
    SA1->(DbSetOrder(3))
    SA1->(DbSeek( FwxFilial("SA1") + cCGC ))


Return { SA1->A1_COD, SA1->A1_LOJA }
/*/{Protheus.doc} libFabr
    Processa liberação fábrica.
    Processo de liberação utilizado apenas para o tipo de pesagem R - Ração.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function libFabr(cNmOrdem, aDados, nRadio, cObservao)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cTicket   := aDados[17]

    Begin Transaction

        If ! U_ADFAT194(cTicket, cValToChar(nRadio), cObservao) //Atualiza o status do ticket de pesagem.
            DisarmTransaction()
            Break

        EndIf

        If ! U_ADFAT164(cNmOrdem, "7", 1) //Atualiza status da ordem de pesagem.
            DisarmTransaction()
            Break

        EndIf

        lRet := .T.

    End Transaction

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} compForn
    Processa complemento fornecedor.
    @type  Static Function
    @author Everson
    @since 05/04/2022
    @version 01
/*/
Static Function compForn(cNmOrdem, aDados, nRadio, cObservao)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cTicket   := aDados[17]
    Local cNFOri    := ""
    Local cSerie    := ""
    Local lAgrupa   := .F.

    //Busca pela ordem de pesagem.
    If ! U_ADFAT16A(cNmOrdem) 

        //Busca pelo Agrupador.
        If ! U_ADFAT16F(cNmOrdem)
            Help(Nil, Nil, "Função compForn(ADEST075P)", Nil, "Ordem de pesagem/agrupador " + cNmOrdem + " não localizado." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        Else
            lAgrupa := .T.

        EndIf

    EndIf

    If ! U_ADFAT195(cTicket)
        Help(Nil, Nil, "Função compForn(ADEST075P)", Nil, "Ticket de pesagem " + cValToChar(cTicket) + " não localizado." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    cNFOri  := ZIG->ZIG_NFCOMP
    cSerie  := ZIG->ZIG_SRCOMP

    If Empty(cNFOri) .Or. Empty(cSerie)
        Help(Nil, Nil, "Função compForn(ADEST075P)", Nil, "Não há nota fiscal de complemento informada." , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    Begin Transaction

        //Envia registro para o barramento.
        If ! U_ADEST751(cNmOrdem, cTicket, ZIF->ZIF_PRDPRO, ZIF->ZIF_PRDSAG, cObservao, nRadio, "", "")
            DisarmTransaction()
            Break

        EndIf

        //Atualiza o status do ticket de pesagem.
        If ! U_ADFAT194(cTicket, cValToChar(nRadio), cObservao)
            DisarmTransaction()
            Break

        EndIf

	    If !lAgrupa

            //Atualiza status da ordem de pesagem.
            If ! U_ADFAT164(cNmOrdem, "13", 1)
                DisarmTransaction()
                Break

            EndIf

        Else

            If ! U_ADFAT160(cNmOrdem, "13", 1)
                DisarmTransaction()
                Break

            EndIf

        EndIf

        lRet := .T.

    End Transaction

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} libOpcoes
    Opções de liberação de sequestro.
    @type  Static Function
    @author Everson
    @since 04/10/2022
    @version 01
/*/
Static Function libOpcoes()
Return {"Desconto Financeiro","Quebra de Estoque",;
                  "Devolução Fornecedor","Transferência Filial",;
                  "Liberação Fábrica", "Complemento Fornecedor"}
/*/{Protheus.doc} ADEST751
    Envia registro para o barramento.
    @type  User Function
    @author Everson
    @since 04/10/2022
    @version 01
/*/
User Function ADEST751(cNumOrd, cTicket, cPrdProth, cPrdSAG, cObs, nTpLib, cEmpDest, cFilDest)

    //Variáveis.
    Local aArea     := GetArea()
    Local aRadio    := libOpcoes()
    Local oJson     := JsonObject():New()
    Local oJsonD    := JsonObject():New()
    Local oJsonF    := Nil
    Local cData     := DToS(Date())
    Local cHora     := Time()
    Local cId       := FWUUIDV1(.T.)
    Local cTopico   := "liberacoes_de_sequestro_protheus"
    Local cOperacao := "I"
    Local cDados    := ""

    If ! U_ADFAT195(cTicket)
        MsgInfo("Ticket de pesagem " + cValToChar(cTicket) + " não localizado.", "Função ADEST751")
        RestArea(aArea)
        Return .F.

    EndIf

    U_ADFAT270(oJson, cData, cHora, cId, cTopico, cOperacao)

    oJsonD['ticketDePesagem'] := Alltrim(cValToChar(cTicket))
    oJsonD['ordemdePesagem']  := Alltrim(cValToChar(ZIG->ZIG_ORDEM))
    oJsonD['agrupador']       := Iif(ZIG->ZIG_AGRUPA == "1", "Sim", "Não")
    oJsonD['produtoProtheus'] := Alltrim(cValToChar(cPrdProth))
    oJsonD['produtoSAG']      := Alltrim(cValToChar(cPrdSAG))
    oJsonD['quebraKg']        := ZIG->ZIG_QUEBRA
    oJsonD['observacao']      := Alltrim(cValToChar(cObs))
    oJsonD['tipoLiberacao']   := nTpLib
    oJsonD['descLiberacao']   := Alltrim(cValToChar(aRadio[nTpLib]))

    If nTpLib == 4
        oJsonF    := JsonObject():New()
        oJsonF['empresaDest'] := Alltrim(cValToChar(cEmpDest))
        oJsonF['filialDest']  := Alltrim(cValToChar(cFilDest))

        oJsonD['transferencia'] := oJsonF

    EndIf

    oJson['dados'] := oJsonD

    cDados := oJson:toJson()

    FreeObj(oJson)
    FreeObj(oJsonD)

    If ValType("oJsonF") <> "U"
        FreeObj(oJsonF)

    EndIf

    lRet := U_ADFAT27B(cOperacao, cTopico, cId, cDados, cData, cHora)

    RestArea(aArea)

Return lRet
