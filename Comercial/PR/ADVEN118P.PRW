#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static xPula        := Chr(13) + Chr(10)
Static cTbMast      := "ZJA"
Static cTbDeta      := "ZJB"
Static cCarteiras   := ""
Static aCodigos     := {}
Static cCodUsr      := ""
Static lAdm         := .F.
Static lBack        := .F.
Static lVend        := .F.
Static lSuperv      := .F.
Static lDiret       := .F.
Static oWebEngine   := Nil
Static cUrl         := ""
Static cStatUpt     := "1/2/3/4"
Static nLimite      := 0
Static nLimiteD     := 0
Static nQtdTitPe    := 0
Static cCodLjUlIF   := ""
Static lAltEMC1     := .T.

/*/{Protheus.doc} User Function ADVEN118P
    Pedido de Venda MVC.
    Chamado 91301.
    @type  Function
    @author Everson
    @since 03/04/2023
    @version 01
/*/
User Function ADVEN118P()

    //Variáveis.
    Local oBrowse := Nil

    carVariaveis()

    If ! (lAdm .Or. lBack .Or. lVend .Or. lSuperv .Or. lDiret)
        Return Nil

    EndIf
    
    oBrowse := FwLoadBrw("ADVEN118P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 03/04/2023
    @version 01
/*/
Static Function BrowseDef()

    //Variáveis.
    Local oBrowse   := FwMBrowse():New()
    Local cFiltro   := "ZJA->ZJA_CODVEN = 'XXXXXX'"
    Local nAux      := 1
    // Local nInterval := GetMv("MV_#VEN1181",,10000)

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetMenuDef("ADVEN118P")
    oBrowse:SetAttach(.T.)
    oBrowse:SetOpenChart(.T.)
    // oBrowse:SetTimer({|| oBrowse:Refresh() }, nInterval)

    If lVend .Or. lSuperv
        
        aCodigos := Separa(cCarteiras, "/", .F.) 
        
        If Len(aCodigos) > 0

            cFiltro := ""
            
            For nAux := 1 To Len(aCodigos)

                cFiltro += "ZJA->ZJA_CODVEN = '" + aCodigos[nAux] + "' .OR. "

            Next nAux

            cFiltro := Substr(cFiltro, 1, Len(cFiltro) - 6)

        EndIf
        

    EndIf
    
    If ! lAdm .And. ! lBack .And. ! lDiret
        oBrowse:SetFilterDefault(cFiltro)

    EndIf

    oBrowse:AddLegend("ZJA->ZJA_STATPA  = '1'" , "ENABLE"    , "Pedido de Venda em aberto", "STPED")
    oBrowse:AddLegend("ZJA->ZJA_STATPA  = '5'" , "DISABLE"   , "Pedido de Venda encerrado", "STPED")
    oBrowse:AddLegend("ZJA->ZJA_STATPA  = '4'" , "BR_AMARELO", "Pedido de Venda liberado",  "STPED")
    oBrowse:AddLegend("ZJA->ZJA_STATPA  = '2'" , "BR_AZUL"   , "Pedido de Venda com Bloquedo de Regra", "STPED")
    oBrowse:AddLegend("ZJA->ZJA_STATPA  = '3'" , "BR_LARANJA", "Pedido de Venda com Bloquedo de Verba", "STPED")
    oBrowse:AddLegend("ZJA->ZJA_STATPA  = '6'" , "BR_PRETO"  , "Pedido de Venda Cancelado", "STPED")

    oBrowse:AddLegend("ZJA->ZJA_INTSC5  = '2'" , "BR_MARROM", "Não integrado","STINT")
    oBrowse:AddLegend("ZJA->ZJA_INTSC5  = '1'" , "BR_VERDE" , "Integrado", "STINT")
    oBrowse:AddLegend("ZJA->ZJA_INTSC5  = '3'" , "BR_PINK"  , "Erro", "STINT")

Return oBrowse
/*/{Protheus.doc} carVariaveis
    Carrega variáveis estáticas.
    @type  Static Function
    @author Everson
    @since 19/04/2023
    @version 01
/*/
Static Function carVariaveis()

    //Variáveis.
    Local aArea     := GetArea()

    cUrl    := "https://app.powerbi.com/reportEmbed?reportId=3ac292b3-b4d4-43f4-8f25-8f9b5e0f6d7c&autoAuth=true&ctid=eaad24ff-5c02-4ce3-abc4-c818c1dfc4fa&filter=fLimiteFinanceiro/IdCliente eq "
    // cUrl := "https://app.powerbi.com/groups/3aba88c1-6ad3-42ef-a7d2-f1b4bbaeba5f/reports/9eb6eaf6-bc09-4857-bbfd-87f050c40c8c/ReportSection166073de2c318946a826?chromeless=true&filter=dVendedor/Carteira eq "
    // cUrl := "https://app.powerbi.com/groups/3aba88c1-6ad3-42ef-a7d2-f1b4bbaeba5f/reports/3ac292b3-b4d4-43f4-8f25-8f9b5e0f6d7c/ReportSection?chromeless=true&filter=fLimiteFinanceiro/IdCliente eq "

    U_ADVE118Q(@cCodUsr, @lAdm, @lBack, @lVend, @lSuperv, @lDiret)
    
    If lAdm .Or. lBack .Or. lDiret
        RestArea(aArea)
        Return Nil

    EndIf
    
    cCarteiras := U_ADVE118G()  

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADVE118Q
    Retorna tipo do usuário.
    @type  Function
    @author Everson
    @since 04/05/2023
    @version 01
/*/
User Function ADVE118Q(cCodUsr, lAdm, lBack, lVend, lSuperv, lDiret)

    //Variáveis.
    Local aArea   := GetArea()
    Local cUsrLib := GetMv("MV_#VE1181",,"")

    If FWIsAdmin() .And. Pergunte("ADVEN118P2", .T.)
        cCodUsr := MV_PAR01 //"000870"//__cUserId  "000216"//
        lAdm    := .F.//FWIsAdmin()

    Else
        cCodUsr := __cUserId
        lAdm    := FWIsAdmin() 

    EndIf

    lBack   := cCodUsr $cUsrLib

    // If lAdm .Or. lBack
    //     RestArea(aArea)
    //     Return Nil

    // EndIf

    DbSelectArea("SA3")
    SA3->(DbSetOrder(7))
    SA3->(DbGoTop())
    If ! SA3->(DbSeek(FWxFilial("SA3") + cCodUsr))
        RestArea(aArea)
        Return Nil

    EndIf

    If SA3->A3_XCARGSF == "1"
        lVend      := .T.

    ElseIf SA3->A3_XCARGSF == "2"
        lSuperv    := .T.

    ElseIf SA3->A3_XCARGSF == "4"
        lDiret     := .T.

    EndIf

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 03/04/2023
    @version 01
/*/
Static Function MenuDef()

    //Variáveis
    Local aRotina := {}

    ADD OPTION aRotina TITLE "Visualizar"         ACTION "U_ADVE1180(1)"  OPERATION MODEL_OPERATION_VIEW ACCESS 0
    ADD OPTION aRotina TITLE "Incluir"            ACTION "U_ADVE1180(3)"  OPERATION  3 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"            ACTION "U_ADVE1180(4)"  OPERATION  4 ACCESS 0
    ADD OPTION aRotina TITLE "Cancelar"           ACTION "U_ADVE1180(11)" OPERATION 11 ACCESS 0
    ADD OPTION aRotina TITLE "Resumo"             ACTION "MsAguarde({|| U_ADVE118E() }, 'Aguarde', 'Processando')"  OPERATION 12 ACCESS 0
    ADD OPTION aRotina TITLE "Lib. EDI"           ACTION "MsAguarde({|| U_ADVE118U() }, 'Aguarde', 'Processando')"  OPERATION 13 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar Dt Entrega" ACTION "MsAguarde({|| U_ADVE118X() }, 'Aguarde', 'Processando')"  OPERATION 14 ACCESS 0
    ADD OPTION aRotina TITLE "Alterar Dt Entrega" ACTION "MsAguarde({|| U_ADVE118X() }, 'Aguarde', 'Processando')"  OPERATION 14 ACCESS 0
    // ADD OPTION aRotina TITLE "Solicita Aprov. Refaturamento" ACTION "MsAguarde({|| U_ADV1180L() }, 'Aguarde', 'Processando')"  OPERATION 15 ACCESS 0
    // ADD OPTION aRotina TITLE "Monitora PV"        ACTION "MsAguarde({|| U_ADVEN049P() }, 'Aguarde', 'Processando')"  OPERATION 16 ACCESS 0

Return aRotina
/*/{Protheus.doc} User Function ADVE1180
    CRUD.
    @type  Function
    @author Everson
    @since 03/04/2023
    @version 01
/*/
User Function ADVE1180(nOpc)

    //Variáveis.
    Local aArea     := GetArea()
    Local cAcao     := ""
    Local cMsgPgAnt := ""
    Local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T., Nil},{.T., Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
    Local cEFBack   := cEmpAnt + cFilAnt
    Local aMensagem := RetSX3Box(GetSX3Cache("ZJA_MSPANT", "X3_CBOX"),,,1)

    If nOpc == 2
        cAcao := "Visualizar"

    ElseIf nOpc == 3
        cAcao := "Incluir"

    ElseIf nOpc == 4
        cAcao := "Alterar"

    ElseIf nOpc == 5
        cAcao := "Excluir"

    ElseIf nOpc == 6
        cAcao := "Copiar"

    EndIf

    If (nOPc == 4 .Or. nOpc == 5 .Or. nOpc == 11) 

        If ZJA->ZJA_TPPED  $"7"
            Help(Nil, Nil, "Função ADVE1180(ADVEN118P)", Nil, "Não é possível realizar a operação em pedido de remessa.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return Nil

        EndIf
    
        If U_ADVE118Y(ZJA->ZJA_CONDPA) .And. (Empty(ZJA->ZJA_EDI) .Or. (!Empty(ZJA->ZJA_EDI) .And. ZJA->ZJA_LIBEDI == "1"))
            Help(Nil, Nil, "Função ADVE1180(ADVEN118P)", Nil, "Operação não permitida. Pedido possui condição de pagamento antecipado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return Nil

        EndIf

        If !(ZJA->ZJA_STATUS $cStatUpt)
            Help(Nil, Nil, "Função ADVE1180(ADVEN118P)", Nil, "Operação não permitida devido ao status do pedido.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return Nil

        EndIf

        If ! Empty(ZJA->ZJA_PLACA)
            Help(Nil, Nil, "Função ADVE1180(ADVEN118P)", Nil, "Operação não permitida, pedido já possui placa vinculada.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return Nil

        EndIf

    EndIf

    If nOpc == 11

        If ! MsgYesNo("Deseja cancelar o pedido " + ZJA->ZJA_NUM + " ?", "Função ADVE1180(ADVEN118P)")
            RestArea(aArea)
            Return Nil

        EndIf

        MsAguarde({|| cancPedV(ZJA->ZJA_NUM, ZJA->ZJA_LOCEXP) }, "Aguarde", "Processando"  )

    Else

        nLimite      := ZJA->ZJA_LIMITE
        nLimiteD     := ZJA->ZJA_LIMITD
        nQtdTitPe    := ZJA->ZJA_QTDTIT

        If nOpc == 4 .And. cNumEmp <> ZJA->ZJA_LOCEXP
            altFilial(ZJA->ZJA_LOCEXP)
  
        EndIf

            If ! Empty(ZJA->ZJA_MSPANT)
                cMsgPgAnt := aMensagem[Val(ZJA->ZJA_MSPANT)][3]

            EndIf

            FWExecView(cAcao + cMsgPgAnt, "ADVEN118P", nOpc, , , , , aButtons)

            lAltEMC1 := .T.

        If cEFBack <> cNumEmp
            altFilial(cEFBack)

        EndIf

    EndIf

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} cancPedV
    Cancela pedido de venda.
    @type  Static Function
    @author Everson
    @since 11/05/2023
    @version 01
/*/
Static Function cancPedV(cPedido, cLocExp)

    //Variáveis.
    Local aArea     := GetArea()
    Local oPedido   := Nil
    Local aError    := {}
    Local cMsgError := ""

    If ! U_ADVE1182(cPedido, cLocExp)
        Help(Nil, Nil, "Função cancPedV(ADVEN118P)", Nil, "Pedido " + cPedido + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Nil

    EndIf

    oPedido := FWLoadModel("ADVEN118P")
    oPedido:SetOperation(MODEL_OPERATION_UPDATE)
    oPedido:Activate()

        oPedido:SetValue("MD_MASTER", "ZJA_STATPA", "6") //Pedido cancelado.
        oPedido:SetValue("MD_MASTER", "ZJA_STATUS", "8") //Pedido cancelado.
        oPedido:SetValue("MD_MASTER", "ZJA_PARSUP", "2") //Remove da aprovação supervisor.
        oPedido:SetValue("MD_MASTER", "ZJA_PARDIR", "2") //Remove da aprovação diretor.

        If oPedido:VldData()
            oPedido:CommitData()

        Else
            aError := oPedido:GetErrorMessage()
            cMsgError += Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

        EndIf

    oPedido:DeActivate()
    oPedido:Destroy()
    oPedido := Nil

    If ! Empty(cMsgError)
        Help(Nil, Nil, "Função cancPedV(ADVEN118P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    Else
        MsgInfo("Processo finalizado.", "Função cancPedV(ADVEN118P)")

    EndIf

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} ADVE118G
    Carrega as carteiras do usuário.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE118G()

    //Variáveis.
    Local aArea      := GetArea()
    Local cCarteiras := ""
    Local cSupervisor  := Posicione("SA3", 7, FWxFilial("SA3") + cCodUsr, "A3_SUPER")

    If lVend

        DbSelectArea("SA3")
        SA3->(DbSetOrder(7))
        If SA3->(DbSeek(FWxFilial("SA3") + cCodUsr))

            While ! SA3->(Eof()) .And. SA3->A3_CODUSR == cCodUsr
                
                cCarteiras += SA3->A3_COD + "/"

                SA3->(DbSkip())

            End

        EndIf

    ElseIf lSuperv

        DbSelectArea("SA3")
        SA3->(DbSetOrder(5))
        If SA3->(DbSeek(FWxFilial("SA3") + cSupervisor))

            While ! SA3->(Eof()) .And. SA3->A3_SUPER == cSupervisor
                
                cCarteiras += SA3->A3_COD + "/"

                SA3->(DbSkip())

            End

        EndIf       

    EndIf

    RestArea(aArea)

Return cCarteiras
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 03/04/2023
    @version 01
/*/
Static Function ModelDef()
    
    //Variáveis.
    Local bPre      := {|| .T. }
    Local bPost     := {|oModel| vldPos(oModel) }
    Local bCancel   := {|| .T. }
    Local bLinhaOk  := {|oModel| fValidGrid(oModel) }
    Local oModel    := MPFormModel():New("ADVE118", bPre, bPost, /*bCommit*/, bCancel)
    Local oStrMast  := FwFormStruct(1, cTbMast)
    Local oStrDeta  := FwFormStruct(1, cTbDeta)       
    Local nEM       := 0

    oModel:AddFields("MD_MASTER", Nil, oStrMast)

    oModel:AddGrid("MD_GRID", "MD_MASTER", oStrDeta, , bLinhaOk)

    oModel:SetRelation("MD_GRID", {{"ZJB_FILIAL", 'FWxFilial("' + cTbMast + '")'}, {"ZJB_NUM", "ZJA_NUM"}, {"ZJB_LOCEXP", "ZJA_LOCEXP"}}, (cTbDeta)->(IndexKey(1)))
    oModel:GetModel("MD_GRID"):SetUniqueLine({"ZJB_PRODUT"}) 

    oModel:GetModel("MD_GRID"):SetMaxLine(10000)

    oModel:AddCalc("ADVE118I", "MD_MASTER", "MD_GRID", "ZJB_REMOV1", "LIMITE"  , "FORMULA", { || .T. },,"Limite do Cliente"    , {|oModel| nLimite   })
    oModel:AddCalc("ADVE118I", "MD_MASTER", "MD_GRID", "ZJB_REMOV1", "LIMITED" , "FORMULA", { || .T. },,"Limite Disponível"    , {|oModel| nLimiteD  })
    oModel:AddCalc("ADVE118I", "MD_MASTER", "MD_GRID", "ZJB_REMOV2", "QTDTITPE", "FORMULA", { || .T. },,"Qtd Títulos Pendentes", {|oModel| nQtdTitPe })

    oModel:AddCalc("ADVE118I", "MD_MASTER", "MD_GRID", "ZJB_VALOR", "IT", "FORMULA", { || .T. },,"IT"  , {|oModel| calcIt(oModel) })
    oModel:AddCalc("ADVE118I", "MD_MASTER", "MD_GRID", "ZJB_VALOR", "EM", "FORMULA", { || .T. },,"EM/T", {|oModel| nEM := calcEM(oModel), carEM(oModel, nEm), lAltEMC1 := .F., nEM })
    oModel:AddCalc("ADVE118I", "MD_MASTER", "MD_GRID", "ZJB_VALOR", "IP", "FORMULA", { || .T. },,"IP"  , {|oModel| calcIP(oModel) })

    oModel:AddCalc("ADVE118I", "MD_MASTER", "MD_GRID", "ZJB_VALOR" , "TT_PEDIDO",  "SUM", { || .T. },, "Valor do Pedido")
    oModel:AddCalc("ADVE118I", "MD_MASTER", "MD_GRID", "ZJB_UNSVEN", "TT_CAIXAS",  "SUM", { || .T. },, "Total Caixas")
    oModel:AddCalc("ADVE118I", "MD_MASTER", "MD_GRID", "ZJB_QTDVEN", "TT_PLIQ"  ,  "SUM", { || .T. },, "Total Peso Líquido")
    
    oModel:SetPrimaryKey({})

Return oModel

/*/{Protheus.doc} carEM
    Atualiza campo com o EM calculado.
    @type  Static Function
    @author user
    @since 24/05/2023
    @version 01
/*/
Static Function carEM(oModel, nEm)

    //Variáveis.
    Local aArea  := GetArea()
    Local nEmAnt := oModel:GetValue("MD_MASTER", "ZJA_EM")

    If nEmAnt == nEm .Or.! (oModel:nOperation == 3  .Or. (oModel:nOperation == 4 .And. ! lAltEMC1))
        RestArea(aArea)
        Return Nil

    EndIf
    
    oModel:SetValue("MD_MASTER", "ZJA_EM", nEM)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} calcIt
    Calcula o IT (Índice de Tabela) do pedido de venda.
    @type  Static Function
    @author Everson
    @since 04/04/2023
    @version 01
/*/
Static Function calcIt(oModel)

    //Variáveis.
    Local aArea      := GetArea()
    Local nVlr       := 0
    Local aSaveLines := FWSaveRows()
    Local oGrid      := oModel:GetModel("MD_GRID")
    Local nLinhas    := oGrid:Length()
    Local nDenoIT    := 0
    Local nVolTotPed := 0
    Local nAux       := 1

    For nAux := 1 To nLinhas

        oGrid:GoLine(nAux) 
        
        If oGrid:IsDeleted()
            Loop

        EndIf

        nDenoIT += oGrid:GetValue("ZJB_IT") * oGrid:GetValue("ZJB_QTDVEN")

        nVolTotPed += oGrid:GetValue("ZJB_QTDVEN")

    Next nAux

    If nVolTotPed > 0
        nVlr := (nDenoIT/nVolTotPed)/100 

    EndIf

    FWRestRows(aSaveLines)

    RestArea(aArea)

Return nVlr
/*/{Protheus.doc} calcEM
    Calcula a EM (Eficiência de Mercado) do pedido de venda.
    @type  Static Function
    @author Everson
    @since 04/04/2023
    @version 01
/*/
Static Function calcEM(oModel)

    //Variáveis.
    Local aArea      := GetArea()
    Local nVlr       := 0
    Local aSaveLines := FWSaveRows()
    Local oGrid      := oModel:GetModel("MD_GRID")
    Local nLinhas    := oGrid:Length()
    Local nDenoEM    := 0
    Local nVolTotPed := 0
    Local nAux       := 1

    For nAux := 1 To nLinhas

        oGrid:GoLine(nAux) 
        
        If oGrid:IsDeleted()
            Loop

        EndIf

        nDenoEM += oGrid:GetValue("ZJB_EM") * oGrid:GetValue("ZJB_QTDVEN")

        nVolTotPed += oGrid:GetValue("ZJB_QTDVEN")

    Next nAux

    If nVolTotPed > 0
        nVlr := Round((nDenoEM/nVolTotPed), 1)

    EndIf

    FWRestRows(aSaveLines)

    RestArea(aArea)

Return nVlr
/*/{Protheus.doc} calcIP
    Calcula IP (Índice de Preço) do pedido de venda.
    @type  Static Function
    @author Everson
    @since 04/04/2023
    @version 01
/*/
Static Function calcIP(oModel)

    //Variáveis.
    Local aArea      := GetArea()
    Local nVlr       := 0
    Local aSaveLines := FWSaveRows()
    Local oGrid      := oModel:GetModel("MD_GRID")
    Local nLinhas    := oGrid:Length()
    Local nDenoIP    := 0
    Local nVolTotPed := 0
    Local nAux       := 1

    For nAux := 1 To nLinhas

        oGrid:GoLine(nAux) 
        
        If oGrid:IsDeleted()
            Loop

        EndIf

        nDenoIP += oGrid:GetValue("ZJB_IP") * oGrid:GetValue("ZJB_QTDVEN")

        nVolTotPed += oGrid:GetValue("ZJB_QTDVEN")

    Next nAux

    If nVolTotPed > 0
        nVlr := (nDenoIP/nVolTotPed)/100

    EndIf

    FWRestRows(aSaveLines)

    RestArea(aArea)

Return nVlr
/*/{Protheus.doc} vldPos
    Valida pedido antes de salvar.
    @type  Static Function
    @author Everson
    @since 03/04/2023
    @version 01
/*/
Static Function vldPos(oModel)

    //Variáveis.
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    Local nIT        := 0
    Local nEM        := 0
    Local nIP        := 0
    Local nTTPed     := oModel:GetValue("ADVE118I", "TT_PEDIDO")
    Local nTTPes     := oModel:GetValue("ADVE118I", "TT_PLIQ")
    Local nTTCax     := oModel:GetValue("ADVE118I", "TT_CAIXAS")
    Local cCodCli    := oModel:GetValue("MD_MASTER", "ZJA_CLIENT")
    Local cLojCli    := oModel:GetValue("MD_MASTER", "ZJA_LOJACL")
    Local cCodCliVo  := oModel:GetValue("MD_MASTER", "ZJA_CLIEVO")
    Local cLojCliVo  := oModel:GetValue("MD_MASTER", "ZJA_LOJAVO")
    Local cTpPed     := oModel:GetValue("MD_MASTER", "ZJA_TPPED")
    Local cRede      := oModel:GetValue("MD_MASTER", "ZJA_CODRED")
    Local cIdProcO   := oModel:GetValue("MD_MASTER", "ZJA_IDPRED")
    Local cVendedor  := oModel:GetValue("MD_MASTER", "ZJA_CODVEN")
    Local cLocExp    := oModel:GetValue("MD_MASTER", "ZJA_LOCEXP")
    Local dData      := oModel:GetValue("MD_MASTER", "ZJA_DTENTR")
    Local cCdPg      := oModel:GetValue("MD_MASTER", "ZJA_CONDPA")
    Local cPlaca     := oModel:GetValue("MD_MASTER", "ZJA_PLACA")
    Local cStatus    := oModel:GetValue("MD_MASTER", "ZJA_STATUS")
    Local cPedido    := oModel:GetValue("MD_MASTER", "ZJA_NUM")
    Local nLmDisp    := oModel:GetValue("MD_MASTER", "ZJA_LIMITD")
    Local cIdProcN   := ""
    Local nPedMin    := obtPedMin(cCodCli, cLojCli)
    Local lAltDtM    := IsInCallStack("U_ADVE118X")

    If lRet .And. (nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE)

        If lRet .And. nOperation == MODEL_OPERATION_UPDATE .And. !(cStatus $cStatUpt)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADVEN118P)", Nil, "Operação não permitida devido ao status do pedido.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        If lRet .And. !Empty(cPlaca)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADVEN118P)", Nil, "Operação não permitida, placa vinculada.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        //Pendência de processamento SC5.
        oModel:SetValue("MD_MASTER", "ZJA_INTSC5", "2")

        If nOperation == MODEL_OPERATION_INSERT
            oModel:SetValue("MD_MASTER", "ZJA_ACASC5", "1")

        ElseIf nOperation == MODEL_OPERATION_UPDATE
            oModel:SetValue("MD_MASTER", "ZJA_ACASC5", Iif(cStatus == "8", "3", "2"))

        ElseIf nOperation == MODEL_OPERATION_DELETE
            oModel:SetValue("MD_MASTER", "ZJA_ACASC5", "3")

        EndIf

        //Recalcula indicadores.
        recInd()

        nIT := Round(oModel:GetValue("ADVE118I", "IT"), 2)
        nEM := Round(oModel:GetValue("ADVE118I", "EM"), 2)
        nIP := Round(oModel:GetValue("ADVE118I", "IP"), 2)

        //Carrega variáveis.
        oModel:SetValue("MD_MASTER", "ZJA_IT"   , nIT)
        oModel:SetValue("MD_MASTER", "ZJA_EM"   , nEM)
        oModel:SetValue("MD_MASTER", "ZJA_IP"   , nIP)
        oModel:SetValue("MD_MASTER", "ZJA_VALOR", nTTPed)
        oModel:SetValue("MD_MASTER", "ZJA_PESL" , nTTPes)
        oModel:SetValue("MD_MASTER", "ZJA_VOL"  , nTTCax)

        //Carrega campos cálculados dependentes da grid no cabeçalho e grid.
        carCmpClc(oModel)

        If nOperation == MODEL_OPERATION_INSERT 
            oModel:SetValue("MD_MASTER", "ZJA_DTINC", Date())
            oModel:SetValue("MD_MASTER", "ZJA_HRINC", Time())

            If U_ADVE118Y(cCdPg) //Verifica se a condição de pagamento é para pagamento antecipado.
                oModel:SetValue("MD_MASTER", "ZJA_MSPANT", "1")
                
            EndIf

        EndIf

        If IsInCallStack("U_ADVE1230") .Or. IsInCallStack("U_ADVE1240") //Aprovação varejo e aprovação rede.
            oModel:SetValue("MD_MASTER", "ZJA_TPALT", "2") //Tipo de processamento a ser realizado pelo job ADVEN127P. R = msexecauto.
        
        Else
            oModel:SetValue("MD_MASTER", "ZJA_TPALT", "1")

        EndIf

        If obRotLib() //Rotinas que não necessitam de vaidação. 
            RestArea(aArea)
            Return .T.

        EndIf

        //Valida data de entrega.
        lRet := lRet .And. U_ADVE118B(dData)

        If ! lAltDtM //Não é alteração de data de entrega em massa.

            //Valida cliente.
            lRet := lRet .And. U_ADVE1185(cCodCli, cLojCli, .F.)

            //Valida cliente venda à ordem.
            If lRet .And. cTpPed == "4"
                lRet := U_ADVE1185(cCodCliVo, cLojCliVo, .T.)

            EndIf

            //Valida cabeçalho.
            lRet := lRet .And. gridFocus()

            If nOperation == MODEL_OPERATION_INSERT

                //Valida local de expedição.
                lRet := lRet .And. U_ADVE118N(cLocExp) 


            EndIf
            
            //Valida condição de pagamento.
            lRet := lRet .And. U_ADVE118D(cCdPg)

            //Valida valor mínimo do pedido.
            If lRet .And. nPedMin > nTTPed
                lRet := .F.
                Help(Nil, Nil, "Função vldPos(ADVEN118P)", Nil, "Valor mínimo do pedido não atingido." + xPula + "Ped. Mínimo " + Transform(nPedMin, "@E 999,999.99"), 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

            EndIf

            //Verifica limite disponível do cliente.
            If lRet 
            
                If ! IsBlind() .And. nTTPed > nLmDisp.And. ! MsgYesNo("O valor total do pedido (" + Alltrim(cValToChar(Transform(nTTPed, pesqPict("ZJA","ZJA_LIMITD"))))  + ") é maior que o limite disponível (" + Alltrim(cValToChar(Transform(nLmDisp, pesqPict("ZJA","ZJA_LIMITD"))))  + "). Deseja prosseguir?", "Função vldPos")            
                    lRet := .F.
                    Help(Nil, Nil, "Função vldPos(ADVEN118P)", Nil, "Operação cancelada.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

                EndIf

            EndIf

            //Carrega número do pedido de remessa.
            If nOperation == MODEL_OPERATION_INSERT .And. cTpPed $"4"
                oModel:SetValue("MD_MASTER", "ZJA_NUMREM" , U_ADVE1183())

            EndIf

        EndIf

        //Processo para verificar necessidade de aprovação.
        If lRet
            lRet := U_ADVE118O(oModel, cCodCli, cLojCli, cRede, cVendedor, oModel:GetValue("MD_MASTER","ZJA_DTENTR"), nIT, nEM, nIP)
        
        EndIf
        
        //Verifica demais pedidos da rede com o mesmo Id de processamento, para o id anterior.
        If lRet .And. ! Empty(cIdProcO)
            lRet := retPedRed(cIdProcO, cPedido)

        EndIf

        //Verifica demais pedidos da rede com o mesmo Id de processamento, para o id atual.
        cIdProcN := oModel:GetValue("MD_MASTER", "ZJA_IDPRED")
        If lRet .And. ! Empty(cIdProcN) .And. cIdProcN <> cIdProcO
            lRet := retPedRed(cIdProcN, cPedido)

        EndIf

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} obRotLib
    Rotinas que não necessitam de validação.
    @type  Static Function
    @author Everson
    @since 24/05/2023
    @version 01
/*/
Static Function obRotLib()

    //Variáveis.

    //Pedido de remessa.
    If  IsInCallStack("U_ADVE1223");      //Rotina de corte.
        .Or. IsInCallStack("U_ADVE1230"); //Aprovar pedidos de venda varejo.     
        .Or. IsInCallStack("cancPedV");   //Cancela pedido de venda.     
        .Or. IsInCallStack("U_ADVE1262"); //Processamento de rede.     
        .Or. IsInCallStack("retPedRed");  //Retorna o processamento dos pedidos de rede já processados.    
        .Or. IsInCallStack("U_ADVE1240"); //Aprovação de rede.    
        .Or. IsInCallStack("U_ADVE118R")  //Geração de pedido de remessa.   
    
        Return .T.

    EndIf
    
Return .F.
/*/{Protheus.doc} carCmpClc
    Carrega campos cálculados dependentes da grid no cabeçalho e grid.
    @type  Static Function
    @author Everson
    @since 16/05/2023
    @version 01
/*/
Static Function carCmpClc(oModel)

    //Variáveis.
    Local aArea      := GetArea()
    Local aSaveLines := FWSaveRows()
    Local oGrid      := oModel:GetModel("MD_GRID")
    Local cCodCli    := oModel:GetValue("MD_MASTER", "ZJA_CLIENT")
    Local cLojCli    := oModel:GetValue("MD_MASTER", "ZJA_LOJACL")
    Local cEst       := Posicione("SA1", 1, FWxFilial("SA1") + cCodCli + cLojCli, "A1_EST")
    Local cMuni      := Posicione("SA1", 1, FWxFilial("SA1") + cCodCli + cLojCli, "A1_COD_MUN")
    Local nQtdVend   := 0
    Local nVlrFrt    := obtFrete(cEst, cMuni) //Valor do frete.
    Local nPrcTab    := 0
	Local nPesBrt    := 0
	Local nToTab     := 0
    Local nIP        := 0
    Local nNumIT     := 0
    Local nNumITT    := 0
    Local nAux       := 1
    Local nLinhas    := oGrid:Length()
    Local aPrecos    := {}
    Local nMinVend   := 0
    Local nMinSupe   := 0

    For nAux := 1 To nLinhas

        oGrid:GoLine(nAux) 
        
        If oGrid:IsDeleted()
            Loop

        EndIf

        cProduto := oGrid:GetValue("ZJB_PRODUT")
        nPrcTab  := U_ADVE1188(cProduto)          //Preço de tabela.
        nQtdVend := oGrid:GetValue("ZJB_QTDVEN")  //Quantidade vendida (kg).
        nVolVend := oGrid:GetValue("ZJB_UNSVEN")  //Quantidade vendida (cxs).
        nNumIT   := nQtdVend * (oGrid:GetValue("ZJB_IT")/100) //Numerador IT.
        nIP      := oGrid:GetValue("ZJB_IP")

        nToTab   += nQtdVend * nPrcTab //Total preço de tabela.
        nNumITT  += nNumIT             //Numerador IT total.
        nPesBrt  += (nVolVend * obtTara(cProduto)) + nQtdVend //Peso bruto.

        oGrid:SetValue("ZJB_XIPTAB", Round(nIP   , TamSX3("ZJB_XIPTAB")[2]))
        oGrid:SetValue("ZJB_TOTDIG", Round(nNumIT, TamSX3("ZJB_TOTDIG")[2]))
        oGrid:SetValue("ZJB_PBTTV" , Round(nQtdVend * nPrcTab, TamSX3("ZJB_PBTTV")[2]))

        If nQtdVend > 0
            oGrid:SetValue("ZJB_PLTTV" , Round((nNumIT) / nQtdVend, TamSX3("ZJB_PLTTV")[2]))

        EndIf

        aPrecos  := obtPrcs(cProduto, nPrcTab)
        nMinVend := aPrecos[1]
        nMinSupe := aPrecos[2]

        oGrid:SetValue("ZJB_PLTAB" , nPrcTab)   //Preço tabela de preço.
        oGrid:SetValue("ZJB_TOTTAB", nPrcTab)   //Preço tabela de preço (No SF os dois campos tem o mesmo valor).
        oGrid:SetValue("ZJB_PLTVD" , nMinVend)  //Mínimo vendedor.
        oGrid:SetValue("ZJB_PLTSP" , nMinSupe)  //Mínimo supervisor.

    Next nAux

    oModel:SetValue("MD_MASTER", "ZJA_FRETAP", nVlrFrt)
    oModel:SetValue("MD_MASTER", "ZJA_TOTTAB", Round(nToTab, TamSX3("ZJA_TOTTAB")[2]))
    oModel:SetValue("MD_MASTER", "ZJA_TOTDIG", Round(nNumITT, TamSX3("ZJA_TOTDIG")[2]))
    oModel:SetValue("MD_MASTER", "ZJA_DESCTB", Round(nToTab - nNumITT, TamSX3("ZJA_DESCTB")[2]))
    oModel:SetValue("MD_MASTER", "ZJA_PBRUTO", Round(nPesBrt, TamSX3("ZJA_PBRUTO")[2]))

    FWRestRows(aSaveLines)

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} obtTara
    Retorna tara.
    @type  Static Function
    @author Everson
    @since 16/05/2023
    @version 01
/*/
Static Function obtTara(cProduto)

    //Variáveis.
    Local aArea := GetArea()
    Local nTara := 1

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())

    DbSelectArea("SZC")
    SZC->(DbSetOrder(1))
    SZC->(DbGoTop())

    If SB1->(DbSeek(FWxFilial("SB1") + cProduto)) .And. SZC->(DbSeek(FWxFilial("SZC") + SB1->B1_SEGUM))
        nTara += SZC->ZC_TARA
    
    EndIf

    RestArea(aArea)
    
Return Iif(nTara <= 0, 1, nTara)
/*/{Protheus.doc} fValidGrid
    Valida itens do pedido de venda.
    @type  Static Function
    @author Everson
    @since 05/05/2023
    @version 01
/*/
Static Function fValidGrid(oGrid)

    //Variáveis.
    Local aArea      := GetArea()
    Local cProduto   := ""
    Local nVlrNeg    := 0
    Local nPrcTab    := ""
          
    If oGrid:IsDeleted() .Or. obRotLib()
        RestArea(aArea)
        Return .T.

    EndIf

    //Valida produto.
    cProduto := oGrid:GetValue("ZJB_PRODUT")

    If ! U_ADVE1187(cProduto)
        RestArea(aArea)
        Return .F.
        
    EndIf

    //Valida preço
    nVlrNeg := oGrid:GetValue("ZJB_PRCVEN")
    nPrcTab := U_ADVE1188(cProduto)

    If ! U_ADVE118A(nVlrNeg, cProduto, nPrcTab)
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)
    
Return .T.
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 03/04/2023
    @version 01
/*/
Static Function ViewDef()
    
    //Variáveis.
    Local oView     := FwFormView():New()
    Local oModel    := FwLoadModel("ADVEN118P")
    Local oStrMast  := FwFormStruct(2, cTbMast)
    Local oStrDeta  := FwFormStruct(2, cTbDeta)
    Local oStrInd   := FWCalcStruct(oModel:GetModel("ADVE118I"))
    Local cCSS      := ""

    oView:SetModel(oModel)

    oView:AddField("VW_CALC"  , oStrInd,  "ADVE118I")
    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")
    oView:AddGrid("VW_GRID"   , oStrDeta, "MD_GRID",,{|| gridFocus() })
    // oView:AddOtherObject("VW_INDIC", {|oPanel| geraGraf(oPanel)})

    // oView:CreateHorizontalBox("INDICADOR", 08)
    // oView:CreateHorizontalBox("INFERIOR",  92)

    // oView:CreateFolder("PASTAS", "INFERIOR")
    //     oView:AddSheet("PASTAS", "ABA01", "Pedido")
    //     // oView:AddSheet("PASTAS", "ABA02", "Indicadores")
    //     oView:AddSheet("PASTAS", "ABA03", "Logs")

    //     oView:CreateHorizontalBox("BOX_SUPERIOR" , 55,,, "PASTAS", "ABA01")
    //     oView:CreateHorizontalBox("BOX_MEIO"     , 45,,, "PASTAS", "ABA01")

        // oView:CreateHorizontalBox("BOX_TOTAL"    , 100,,, "PASTAS", "ABA02")

    oView:CreateHorizontalBox("INDICADOR"   , 08)
    oView:CreateHorizontalBox("BOX_SUPERIOR", 46)
    oView:CreateHorizontalBox("BOX_MEIO"    , 46)

    oView:SetOwnerView("VW_CALC"  , "INDICADOR")
    oView:SetOwnerView("VW_MASTER", "BOX_SUPERIOR")
    oView:SetOwnerView("VW_GRID"  , "BOX_MEIO")

    // oView:SetOwnerView("VW_INDIC"  , "BOX_TOTAL")

    oView:AddIncrementField("VW_GRID", "ZJB_ITEM")

    If lVend .Or. lSuperv
        oStrMast:RemoveField("ZJA_TPPED")

    EndIf

    If ! lAdm .And. ! lBack // Remove os campos para o usuários que não sejam admin do sistema ou backoffice do comercial.
        oStrMast:RemoveField("ZJA_STATUS")
        oStrMast:RemoveField("ZJA_STATPA")
        oStrMast:RemoveField("ZJA_OK")
        oStrMast:RemoveField("ZJA_IT")
        oStrMast:RemoveField("ZJA_IP")
        oStrMast:RemoveField("ZJA_MSPANT")
        oStrMast:RemoveField("ZJA_VALOR")
        oStrMast:RemoveField("ZJA_PESL")
        oStrMast:RemoveField("ZJA_VOL")
        oStrMast:RemoveField("ZJA_PBRUTO")
        oStrMast:RemoveField("ZJA_TOTDIG")
        oStrMast:RemoveField("ZJA_TOTTAB")
        oStrMast:RemoveField("ZJA_DESCTB")
        oStrMast:RemoveField("ZJA_FRETAP")
        oStrMast:RemoveField("ZJA_TPALT")
        oStrMast:RemoveField("ZJA_ROBO")
        oStrMast:RemoveField("ZJA_NOTA")
        oStrMast:RemoveField("ZJA_SERIE")
        oStrMast:RemoveField("ZJA_PLACA")
        oStrMast:RemoveField("ZJA_NUMREM")
        oStrMast:RemoveField("ZJA_LIMITE")
        oStrMast:RemoveField("ZJA_LIMITD")
        oStrMast:RemoveField("ZJA_QTDTIT")
        
        oStrDeta:RemoveField("ZJB_PRCTAB")
        oStrDeta:RemoveField("ZJB_IT")
        oStrDeta:RemoveField("ZJB_IP")
        oStrDeta:RemoveField("ZJB_EM")
        oStrDeta:RemoveField("ZJB_CIFSFR")
        oStrDeta:RemoveField("ZJB_NUM")
        oStrDeta:RemoveField("ZJB_LOCEXP")
        oStrDeta:RemoveField("ZJB_XIPTAB")
        oStrDeta:RemoveField("ZJB_TOTDIG")
        oStrDeta:RemoveField("ZJB_TOTTAB")
        oStrDeta:RemoveField("ZJB_PRTABV")
        oStrDeta:RemoveField("ZJB_PBTTV")
        oStrDeta:RemoveField("ZJB_PLTTV")
        oStrDeta:RemoveField("ZJB_PLTVD")
        oStrDeta:RemoveField("ZJB_PLTSP")
        oStrDeta:RemoveField("ZJB_PLTAB")
        oStrDeta:RemoveField("ZJB_REMOV1")
        oStrDeta:RemoveField("ZJB_REMOV2")

        oStrInd:RemoveField("TT_CAIXAS")
        oStrInd:RemoveField("IT")
        oStrInd:RemoveField("IP")
        oStrInd:RemoveField("EM")
        oStrInd:RemoveField("QTDTITPE")

    EndIf

    oView:AddUserButton("Histórico de Compra","",{|oView| MsAguarde({|| U_ADVE118L(oView) }, "Aguarde", "Processando...") }, "", , {MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE}, .T.) 

    // oView:AddUserButton("Status Financeiro"  ,"",{|oView| MsAguarde({|| U_ADVE1181(oView) }, "Aguarde", "Processando...") }, "", , {MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE}, .T.)  
    
    oView:AddUserButton("Posição do Cliente", "", {|oView| MsAguarde({|| U_ADV1180E(oView) }, "Aguarde", "Processando...") }, "", , {MODEL_OPERATION_INSERT, MODEL_OPERATION_UPDATE}, .T.)  

    oView:SetFieldAction("ZJA_CLIEVO" , {|oView, cIDView, cField, xValue| Iif(Empty(xValue), lmpCliVO(oView) , Nil)})
    oView:SetFieldAction("ZJA_LOJAVO" , {|oView, cIDView, cField, xValue| Iif(Empty(xValue), lmpCliVO(oView) , Nil)})
    oView:SetFieldAction("ZJA_TPPED"  , {|oView, cIDView, cField, xValue| Iif(xValue <> "4", lmpCliVO(oView) , Nil)})

    oView:SetFieldAction("ZJA_LOCEXP" , {|oView, cIDView, cField, xValue| atlLcExp(oView, xValue), U_ADEST732()})

    oView:SetFieldAction("ZJA_CLIENT" , {|oView, cIDView, cField, xValue| atlLcExp(oView, oView:GetModel("MD_MASTER"):GetValue("ZJA_LOCEXP")), lmpGrid(), carLmtCli() })
    oView:SetFieldAction("ZJA_LOJACL" , {|oView, cIDView, cField, xValue| atlLcExp(oView, oView:GetModel("MD_MASTER"):GetValue("ZJA_LOCEXP")), lmpGrid(), carLmtCli() })

    oView:SetFieldAction("ZFA_DTENTR" , {|oView, cIDView, cField, xValue| pedEnFut(oView:GetModel())})

    oView:SetFieldAction("ZJA_NUMPCO" , {|oView, cIDView, cField, xValue| carPedGrid(oView, "ZJB_NUMPCO", xValue)})
    oView:SetFieldAction("ZJA_ITEMPC" , {|oView, cIDView, cField, xValue| carPedGrid(oView, "ZJB_ITEMPC", xValue)})

    // cCSS := "QTableWidget{border: 1px solid black;}"

    // oView:SetViewProperty("VW_GRID", "SETCSS", {cCSS})
    
Return oView
/*/{Protheus.doc} lmpGrid
    Apaga produtos da grid na alteração do cliente.
    @type  Static Function
    @author Everson
    @since 22/05/2023
    @version 01
/*/
Static Function lmpGrid()

    //Variáveis.
    Local aArea     := GetArea()
    Local oModel    := FWModelActive()
    Local cCliente  := ""
    Local cLoja     := ""

    If ValType(oModel) <> "O"
        RestArea(aArea)
        Return Nil

    EndIf

    cCliente := oModel:GetModel("MD_MASTER"):GetValue("ZJA_CLIENT")
    cLoja    := oModel:GetModel("MD_MASTER"):GetValue("ZJA_LOJACL")

    If cCodLjUlIF == cCliente + cLoja
        RestArea(aArea)
        Return Nil
        
    EndIf

    U_ADEST732()

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} carLmtCli
    Carrega variáveis de limites dos clientes limites do cliente.
    @type  Static Function
    @author Everson
    @since 22/05/2023
    @version 01
/*/
Static Function carLmtCli()

    //Variáveis.
    Local aArea     := GetArea()
    Local oModel    := FWModelActive()
    Local oView     := FWViewActive()
    Local cCliente  := ""
    Local cLoja     := ""
    Local aDDFin    := ""

    If ValType(oModel) <> "O"
        RestArea(aArea)
        Return Nil

    EndIf

    cCliente := oModel:GetModel("MD_MASTER"):GetValue("ZJA_CLIENT")
    cLoja    := oModel:GetModel("MD_MASTER"):GetValue("ZJA_LOJACL")

    If cCodLjUlIF == cCliente + cLoja
        RestArea(aArea)
        Return Nil
        
    EndIf

    If Empty(cCliente) .Or. Empty(cLoja)
        RestArea(aArea)
        Return Nil

    EndIf

    cCodLjUlIF := cCliente + cLoja

    MsAguarde({|| aDDFin := statFin(cCliente + cLoja) }, "Aguarde", "Carregando informações financeiras")

    nLimite      := aDDFin[1]
    nLimiteD     := aDDFin[2]
    nQtdTitPe    := aDDFin[3]

    oModel:GetModel("MD_MASTER"):SetValue("ZJA_LIMITE", aDDFin[1])
    oModel:GetModel("MD_MASTER"):SetValue("ZJA_LIMITD", aDDFin[2])
    oModel:GetModel("MD_MASTER"):SetValue("ZJA_QTDTIT", aDDFin[3])

    oModel:GetModel("ADVE118I"):SetValue("LIMITE",   aDDFin[1])
    oModel:GetModel("ADVE118I"):SetValue("LIMITED",  aDDFin[2])
    oModel:GetModel("ADVE118I"):SetValue("QTDTITPE", aDDFin[3])

    If ValType(oView) == "O"
        oView:Refresh()
        
    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} carPedGrid
    Carrega número do pedido de compra/item do cliente para a grid.
    @type  Static Function
    @author Everson
    @since 19/05/2023
    @version 01
/*/
Static Function carPedGrid(oView, cCampo, cValor)

    //Variáveis.
    Local aArea      := GetArea()
    Local aSaveLines := FWSaveRows()
    Local oModel     := FWModelActive()
    Local oGrid      := oModel:GetModel("MD_GRID")
    Local nLinhas    := oGrid:Length()
    Local nAux       := 1

    Default cCampo  := ""
    Default cValor  := Space(TamSX3(cCampo)[1])

    If Empty(cCampo)
        FWRestRows(aSaveLines)
        RestArea(aArea)
        Return Nil

    EndIf

    For nAux := 1 To nLinhas
        
        oGrid:GoLine(nAux) 

        If oGrid:IsDeleted()
            Loop

        EndIf

        oGrid:SetValue(cCampo, cValor)

    Next nAux

    FWRestRows(aSaveLines)

    oView:Refresh()

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} pedEnFut
    Altera pedido para entrega.
    @type  Static Function
    @author Everson
    @since 08/05/2023
    @version 01
/*/
Static Function pedEnFut(oModel)

    //Variáveis.
    Local dData  := oModel:GetValue("MD_MASTER", "ZJA_DTENTR")
    Local cTpPed := oModel:GetValue("MD_MASTER", "ZJA_TPPED")

    If ! U_ADVE1201()
        Help(Nil, Nil, "Função pedEnFut(ADVEN118P)", Nil, "Não há parametrização de pedido ativa.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Nil

    EndIf

    If dData > ZJD->ZJD_LMVDF .And. cTpPed <> "5"
        FWFldPut("ZJA_TPPED", "5")

    ElseIf dData <= ZJD->ZJD_LMVDF .And. cTpPed <> "1"
        FWFldPut("ZJA_TPPED", "1")

    EndIf

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} ADVE118N
    Valida alteração do local de expedição.
    @type  Static Function
    @author Everson
    @since 04/05/2023
    @version 01
/*/
User Function ADVE118N(cLocExp) // U_ADVE118N(M->ZJA_LOCEXP)

    //Variáveis.
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local aSaveLines := FWSaveRows()
    Local oModel     := FWModelActive()
    Local oGrid      := oModel:GetModel("MD_GRID")
    Local nLinhas    := oGrid:Length()
    Local nAux       := 1
    Local cProduto   := ""

    Return .T. //Os itens da grid estão sendo apagados com a alteração do local de expedição.

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())

    For nAux := 1 To nLinhas
        
        oGrid:GoLine(nAux) 

        If oGrid:IsDeleted()
            Loop

        EndIf

        cProduto := oGrid:GetValue("ZJB_PRODUT")

        If Empty(cProduto)
            Loop

        EndIf

        If ! SB1->(DbSeek( FWxFilial("SB1") + cProduto ))
            lRet := .F.
            Help(Nil, Nil, "Função ADVE118N(ADVEN118P)", Nil, "Produto " + cProduto + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            Exit

        EndIf

        If ! Empty(SB1->B1_XLOCAEX) .And. Alltrim(SB1->B1_XLOCAEX) <> Alltrim(cLocExp)
            lRet := .F.
            Help(Nil, Nil, "Função ADVE118N(ADVEN118P)", Nil, "Produto " + cProduto + " não pode ser expedido pela filial corrente.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            Exit
        
        EndIf

    Next nAux
    
    FWRestRows(aSaveLines)

    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} atlLcExp
    Carrega nova empresa/filial e número do pedido, quando o local de expedição for alterado.
    @type  Static Function
    @author Everson
    @since 05/05/2023
    @version 01
/*/
Static Function atlLcExp(oView, cLocExp)

    //Variáveis.
    Local aArea := GetArea()
    Local cNum  := ""

    If cLocExp ==  cEmpAnt+cFilAnt
        RestArea(aArea)
        Return .T.
        
    EndIf

    MsAguarde({|| altFilial(cLocExp) }, "Aguarde", "Alterando filial.")

    MsAguarde({|| cNum := U_ADVE1183() }, "Aguarde", "Carregando número do pedido")

    If Empty(cNum)
        Help(Nil, Nil, "Função ADVE118N(ADVEN118P)", Nil, "Não foi possível obter o número do pedido de venda para o local de expedição " + cLocExp + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    FWFldPut("ZJA_NUM", cNum)

    recInd()

    If ValType(oView) == "O"
        oView:Refresh()

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} altFilial
    Altera empresa/filial.
    @type  Static Function
    @author Everson
    @since 04/05/2023
    @version 01
/*/
Static Function altFilial(cLocExp)

    //Variáveis.

    DbCloseAll()
    
    cEmpAnt := Substr(cLocExp, 1, 2)
    cFilAnt := Substr(cLocExp, 3, 2)
    cNumEmp := cEmpAnt + cFilAnt
    OpenSM0(cNumEmp)
    OpenFile(cNumEmp)
    OpenSXs(NIL, NIL, NIL, NIL, cEmpAnt, , "SX3", NIL, .F.)
    
Return Nil
/*/{Protheus.doc} geraGraf
    Carrega página web do Power BI.
    @type  Static Function
    @author Everson
    @since 13/04/2023
    @version 01
/*/
Static Function geraGraf(oPanel)


    Private oWebChannel := TWebChannel():New()
    Private nPort := oWebChannel::connect()
   
    oWebEngine := TWebEngine():New(oPanel, 0, 0, 100, 100,, nPort)
    
    // Cria componente
    
    //oWebEngine:Reload()
    oWebEngine:ClearCache()
    oWebEngine:bLoadFinished := {|self,url| }

    MsAguarde({|| oWebEngine:navigate(cUrl + "'25035800' ") }, "Aguarde", "Carregando indicadores")
    
    oWebEngine:Align := CONTROL_ALIGN_ALLCLIENT

Return Nil
/*/{Protheus.doc} gridFocus
    Valida dados do cabeçalho quando a grid ganha foco.
    @type  Static Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
Static Function gridFocus()

    //Variáveis.
    Local aArea   := GetArea()
    Local oModel  := FWModelActive()
    Local oView   := FWViewActive()
    Local cCodigo := oModel:GetValue("MD_MASTER", "ZJA_CLIENT")
    Local cLoja   := oModel:GetValue("MD_MASTER", "ZJA_LOJACL")
    Local cCondP  := oModel:GetValue("MD_MASTER", "ZJA_CONDPA")
    Local dDTEnt  := oModel:GetValue("MD_MASTER", "ZJA_DTENTR")
    Local cTpFrt  := oModel:GetValue("MD_MASTER", "ZJA_TPFRET")
    Local cLocExp := oModel:GetValue("MD_MASTER", "ZJA_LOCEXP")

    If Empty(cCodigo) .Or. Empty(cLoja) .Or. Empty(cCondP) .Or. Empty(dDTEnt) .Or. Empty(cTpFrt) .Or. Empty(cLocExp)
        
        Help(Nil, Nil, "Função gridFocus(ADVEN118P)", Nil, "Necessário informar o código e loja do cliente, condição de pagamento, data de entrega, local de expedição e tipo de frete.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        
        If ValType(oView) == "O"
            oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZJA_CLIENT"):OCtrl:SetFocus()

        EndIf
        
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} ADVE1181
    Exibe informações financeiras do cliente.
    @type  Function
    @author Everson
    @since 04/04/2023
    @version 01
/*/
User Function ADVE1181(oView)

    //Variáveis.
    Local aArea      := GetArea()
    Local oModel     := FWModelActive()
    Local cCodigo    := oModel:GetValue("MD_MASTER","ZJA_CLIENT")
    Local cLoja      := oModel:GetValue("MD_MASTER","ZJA_LOJACL")
    Local cNome      := Alltrim(cValToChar(oModel:GetValue("MD_MASTER","ZJA_NOMECL")))
    Local oModal     := Nil
    Local oContainer := Nil
    Local cConta     := ""
    Local cLimite    := ""
    Local cLimDsp    := ""
    Local cTitPend   := ""
    Local cVlPend    := ""
    Local aDDFin     := {}

    If Empty(cCodigo) .Or. Empty(cLoja)
        MsgInfo("Necessário informar código do cliente e loja.", "ADVE1181(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    aDDFin := statFin(cCodigo+cLoja)

    If Len(aDDFin) <= 0
        MsgInfo("Não há dados para o cliente informado.", "ADVE1181(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    cConta   := cCodigo + "/" + cLoja + " - " + cNome
    cLimite  := Alltrim(cValToChar(Transform(aDDFin[1], "@E 999,999,999.99"))) 
    cLimDsp  := Alltrim(cValToChar(Transform(aDDFin[2], "@E 999,999,999.99")))
    cTitPend := Alltrim(cValToChar(Transform(aDDFin[3], "@E 999,999")))
    cVlPend  := Alltrim(cValToChar(Transform(aDDFin[4], "@E 999,999,999.99")))

    oModal := FWDialogModal():New() 
    oModal:SetBackground( .T. ) 
	oModal:setTitle("Status Financeiro")
	oModal:setSize( 150 , 210 )
    oModal:EnableFormBar( .T. )
    oModal:SetEscClose(.F.)
	oModal:createDialog()
    oModal:CreateFormBar()

        oModal:AddButton( "Ok", {|| oModal:DeActivate() }, "Confirmar", , .T., .F., .T., )

       	oContainer := TPanel():New( ,,, oModal:getPanelMain() )
	    oContainer:Align := CONTROL_ALIGN_ALLCLIENT

        TGroup():New(010,005,095,205,"",oContainer,,,.T.)
            TSay():New(015,010,{||"Data " + DToC(Date())}                      ,oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(027,010,{||"Conta " + cConta}                           ,oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(037,010,{||"Limite Total R$ " + cLimite}                ,oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(057,010,{||"Limite Disponível R$ " + cLimDsp}           ,oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(047,010,{||"Títulos Pendentes " + cTitPend}             ,oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(067,010,{||"Valor dos Títulos Pendentes R$ " + cVlPend} ,oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)       

    oModal:Activate()

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} statFin
    Retorna array com informações financeiras.
    @type  Static Function
    @author Everson
    @since 04/05/2023
    @version 01
/*/
Static Function statFin(cCodLoja)

	//Variáveis.	
	Local aArea		:= GetArea()
    Local aDDFin    := {}
	// Local cQuery	:= ""
    // Local cAlias    := GetNextAlias()

	// cQuery := ""	
	// cQuery += " SELECT    " 
	// cQuery += " ISNULL(B_REDE.ZF_REDE,'') AS CODREDE, " 
	// cQuery += " ISNULL(MAX(B_REDE.ZF_LCREDE),0) +    " 
	// cQuery += " SUM(CASE WHEN B_CLIENTE.A1_MSBLQL = '2' AND ISNULL(B_REDE.ZF_REDE,'') = '' THEN ISNULL(B_CLIENTE.A1_LC,0) ELSE 0 END) AS LM_T,  " 
	// cQuery += "   " 
	// cQuery += " (   " 
	// cQuery += " ISNULL(MAX(B_REDE.ZF_LCREDE),0) +    " 
	// cQuery += " SUM(CASE WHEN B_CLIENTE.A1_MSBLQL = '2' AND ISNULL(B_REDE.ZF_REDE,'') = '' THEN ISNULL(B_CLIENTE.A1_LC,0) ELSE 0 END)   " 
	// cQuery += " ) - SUM(CASE WHEN B_CLIENTE.A1_MSBLQL = '2' THEN ISNULL(B_TITULO.E1_SALDO,0) ELSE 0 END) AS LM_DISP,    " 
	// cQuery += "  " 
	// cQuery += " ISNULL(SUM(B_TABERTO.E1_SALDO),0) AS VLR_T_AB,   " 
	// cQuery += " ISNULL(SUM(B_TABERTO.TOTTIT),0) AS TIT_T_AB " 
	// cQuery += "  " 
	// cQuery += " FROM   " 
	// cQuery += " (   " 
	// cQuery += " SELECT   " 
	// cQuery += " A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_VEND, A1_CGC, LEFT(A1_CGC,8) AS RAIZ_CGC, A1_LC, A1_MSBLQL, A1_DTCAD, A1_DTREAT, A1_COND, A1_REDE, A1_SATIV1   " 
	// cQuery += " FROM   " 
	// cQuery += " " + RetSqlName("SA1") + " (NOLOCK) SA1   " 
	// cQuery += " WHERE    " 
	// cQuery += " SA1.D_E_L_E_T_=''   " 
	// cQuery += " AND RTRIM(LTRIM(A1_COD)) + RTRIM(LTRIM(A1_LOJA)) = '" + cCodLoja + "'  " 
	// cQuery += " UNION " 
	// cQuery += " SELECT " 
	// cQuery += " A1_FILIAL, A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_VEND, A1_CGC, LEFT(A1_CGC,8) AS RAIZ_CGC, A1_LC, A1_MSBLQL, A1_DTCAD, A1_DTREAT, A1_COND, A1_REDE, A1_SATIV1   " 
	// cQuery += " FROM " 
	// cQuery += " " + RetSqlName("SA1") + " (NOLOCK) AS SA1 " 
	// cQuery += " WHERE  " 
	// cQuery += " LEFT(A1_CGC,8) " 
	// cQuery += " IN ( " 
	// cQuery += " SELECT ZF_CGCMAT FROM " + RetSqlName("SZF") + " (NOLOCK) AS SZF WHERE SZF.D_E_L_E_T_ = '' AND ZF_REDE IN " 
	// cQuery += " ( " 
	// cQuery += " SELECT   " 
	// cQuery += " SZF.ZF_REDE " 
	// cQuery += " FROM   " 
	// cQuery += " " + RetSqlName("SA1") + " (NOLOCK) SA1 " 
	// cQuery += " LEFT OUTER JOIN " 
	// cQuery += " " + RetSqlName("SZF") + " (NOLOCK) SZF " 
	// cQuery += " ON  LEFT(A1_CGC,8)  = ZF_CGCMAT " 
	// cQuery += " WHERE    " 
	// cQuery += " SA1.D_E_L_E_T_=''   " 
	// cQuery += " AND SZF.D_E_L_E_T_ = '' " 
	// cQuery += " AND RTRIM(LTRIM(A1_COD)) + RTRIM(LTRIM(A1_LOJA)) = '" + cCodLoja + "'   " 
	// cQuery += " ) " 
	// cQuery += " GROUP BY       " 
	// cQuery += " ZF_CGCMAT, ZF_REDE  " 
	// cQuery += " )   " 
	// cQuery += " ) AS B_CLIENTE   " 
	// cQuery += " LEFT OUTER JOIN   " 
	// cQuery += " (   " 
	// cQuery += " SELECT      " 
	// cQuery += " E1_CLIENTE, E1_LOJA, SUM(E1_SALDO) AS E1_SALDO     " 
	// cQuery += " FROM      " 
	// cQuery += " " + RetSqlName("SE1") + " (NOLOCK) AS SE1     " 
	// cQuery += " WHERE      " 
	// cQuery += " SE1.D_E_L_E_T_ = ''     " 
	// cQuery += " AND E1_SALDO > 0   " 
	// cQuery += " AND E1_PORTADO <>'P13'   " 
	// cQuery += " AND E1_TIPO IN ('NF ', 'NCI', 'NDC')   " 
	// cQuery += " GROUP BY      " 
	// cQuery += " E1_CLIENTE, E1_LOJA   " 
	// cQuery += " ) AS B_TITULO   " 
	// cQuery += " ON B_CLIENTE.A1_COD = B_TITULO.E1_CLIENTE   " 
	// cQuery += " AND B_CLIENTE.A1_LOJA = B_TITULO.E1_LOJA   " 
	// cQuery += " LEFT OUTER JOIN      " 
	// cQuery += " (       " 
	// cQuery += " SELECT        " 
	// cQuery += " ZF_CGCMAT, ZF_REDE, SUM(ZF_LCREDE) AS ZF_LCREDE       " 
	// cQuery += " FROM        " 
	// cQuery += " " + RetSqlName("SZF") + " (NOLOCK) SZF       " 
	// cQuery += " WHERE        " 
	// cQuery += " SZF.D_E_L_E_T_=''       " 
	// cQuery += " GROUP BY       " 
	// cQuery += " ZF_CGCMAT, ZF_REDE       " 
	// cQuery += " ) AS B_REDE     " 
	// cQuery += " ON B_CLIENTE.RAIZ_CGC =  B_REDE.ZF_CGCMAT    " 
	// cQuery += " LEFT OUTER JOIN   " 
	// cQuery += " (   " 
	// cQuery += " SELECT    " 
	// cQuery += " E1_CLIENTE,E1_LOJA, SUM(E1_SALDO) AS E1_SALDO,  COUNT(DISTINCT E1_NUM + E1_PREFIXO) AS TOTTIT, " 
	// cQuery += " SUM(CASE WHEN CAST(E1_VENCREA AS DATE) < CAST(GETDATE() AS DATE) THEN E1_SALDO ELSE 0 END) AS ATRASO   " 
	// cQuery += " FROM    " 
	// cQuery += " " + RetSqlName("SE1") + " (NOLOCK) SE1   " 
	// cQuery += " WHERE    " 
	// cQuery += " (SE1.D_E_L_E_T_=' ')    " 
	// cQuery += " AND E1_SALDO > 0   " 
	// cQuery += " AND E1_PORTADO <> 'P13'   " 
	// cQuery += " AND E1_TIPO IN ('NF')   " 
	// cQuery += " GROUP BY E1_CLIENTE,E1_LOJA   " 
	// cQuery += " ) AS B_TABERTO   " 
	// cQuery += " ON B_CLIENTE.A1_COD = B_TABERTO.E1_CLIENTE   " 
	// cQuery += " AND B_CLIENTE.A1_LOJA = B_TABERTO.E1_LOJA  " 
	// cQuery += " GROUP BY " 
	// cQuery += " B_REDE.ZF_REDE " 

    // DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    // (cAlias)->(DbGoTop())

    // If (cAlias)->(Eof())
    //     (cAlias)->(DbCloseArea())
    //     RestArea(aArea)
    //     Return {}

    // EndIf

    // Aadd(aDDFin, (cAlias)->LM_T)     //Limite total.
    // Aadd(aDDFin, (cAlias)->LM_DISP)  //Limite disponível.
    // Aadd(aDDFin, (cAlias)->TIT_T_AB) //Títulos em aberto.
    // Aadd(aDDFin, (cAlias)->VLR_T_AB) //Valor dos títulos em aberto.

    // (cAlias)->(DbCloseArea())


    U_ConsLimFin(Substr(cCodLoja, 1, 6),"Out","", SToD("20000101"), SToD("30001231"))

    Aadd(aDDFin, _nVlLmCad)          //Limite total.
    Aadd(aDDFin, _nValLim)           //Limite disponível.
    Aadd(aDDFin, 0) //Títulos em aberto.
    Aadd(aDDFin, _nSldTit)           //Valor dos títulos em aberto.

	RestArea(aArea)

Return aDDFin
/*/{Protheus.doc} ADVE1182
    Posiciona no registro pelo número do pedido e local de expedição..
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE1182(cPedido, cLocExp)

    //Variáveis.

    DbSelectArea("ZJA")
    ZJA->(DbSetOrder(3))
    ZJA->(DbGoTop())

Return ZJA->(DbSeek(FWxFilial("ZJA") + cPedido + cLocExp))
/*/{Protheus.doc} ADVE118Z
    Posiciona no registro pelo id do processamento de rede.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE118Z(cIdProcR, cLocExp)

    //Variáveis.

    DbSelectArea("ZJA")
    ZJA->(DbSetOrder(4))
    ZJA->(DbGoTop())

Return ZJA->(DbSeek(FWxFilial("ZJA") + cIdProcR + cLocExp))
/*/{Protheus.doc} User Function ADVE1183
    Obtém sequencial da SC5.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE1183() // U_ADVE1183()

    //Variáveis.
    Local aArea   := GetArea()
	Local cPedido := "" //"XXXXX" + cValToChar(Randomize(0, 9))

    // If cFilAnt == "0B"
    //     cPedido := "YYYYY" + cValToChar(Randomize(0, 9))
        
    // EndIf

    DbSelectArea("SC5")
    SC5->(DbSetOrder(1))
    SC5->(DbGoTop())

    DbSelectArea("ZCI")
	ZCI->(DbSetOrder(2))
    ZCI->(DbGoTop())

    DbSelectArea("ZJA")
	ZJA->(DbSetOrder(1))
    ZJA->(DbGoTop())

	Do While .T.

		cPedido := GetSxeNum("SC5","C5_NUM")
		
		While SC5->(DbSeek(FWxFilial( "SC5" ) + cPedido))
			ConfirmSX8()
			cPedido := GetSxeNum("SC5", "C5_NUM")

		End

		While ZCI->(DbSeek(FWxFilial( "ZCI" ) + cPedido))
			ConfirmSX8()
			cPedido := GetSxeNum("SC5", "C5_NUM")

		End

		While ZJA->(DbSeek(FWxFilial("ZJA") + cPedido))
			ConfirmSX8()
			cPedido := GetSxeNum("SC5", "C5_NUM")

		End

		ConfirmSX8() 

		If SC5->(!DbSeek(FWxFilial("SC5") + cPedido))
			Exit

		EndIf

	End

    RestArea(aArea)
                 
Return cPedido
/*/{Protheus.doc} User Function ADVE1184
    Filtro consulta padrão cliente.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE1184() // U_ADVE1184()

    //Variáveis.
    
Return .T. //SA1->A1_MSBLQL == '2' .And. ((lAdm .Or. lBack) .Or. (SA1->A1_VEND $cCarteiras .And. SA1->A1_XLOCEXP == (cEmpAnt + cFilAnt)))
/*/{Protheus.doc} User Function ADVE1185
    Valida cliente.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE1185(cCodigo, cLoja, lVendOrd) // U_ADVE1185(M->ZJA_CLIENT, M->ZJA_LOJACL)

    //Variáveis.
    Local aArea     := GetArea()
    Local oModel    := FWModelActive()
    Local cCodCli   := oModel:GetValue("MD_MASTER", "ZJA_CLIENT")
    Local cLojCli   := oModel:GetValue("MD_MASTER", "ZJA_LOJACL")
    Local dData     := Nil

    Default cCodigo := ""
    Default cLoja   := ""
    Default lVendOrd:= .F.

    If IsInCallStack("U_ADVE118R")
        RestArea(aArea)
        Return .T.

    EndIf

    If lVendOrd .And. (Empty(cCodCli) .Or. Empty(cLojCli))
        Help(Nil, Nil, "Função ADVE1185(ADVEN118P)", Nil, "Necessário informar o cliente e loja antes de selecionar o cliente venda à ordem .", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If Empty(cCodigo) .Or. Empty(cLoja)
        RestArea(aArea)
        Return .T.

    EndIf

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())
    If ! SA1->(DbSeek(FWxFilial("SA1") + cCodigo + cLoja))
        Help(Nil, Nil, "Função ADVE1185(ADVEN118P)", Nil, "Cliente " + cCodigo + "/" + cLoja + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If SA1->A1_MSBLQL <> "2"
        Help(Nil, Nil, "Função ADVE1185(ADVEN118P)", Nil, "Cliente " + cCodigo + "/" + cLoja + " bloqueado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If lVendOrd .And.;
       oModel:GetValue("MD_MASTER", "ZJA_CLIENT") + oModel:GetValue("MD_MASTER", "ZJA_LOJACL") == oModel:GetValue("MD_MASTER", "ZJA_CLIEVO") + oModel:GetValue("MD_MASTER", "ZJA_LOJAVO")
       Help(Nil, Nil, "Função ADVE1185(ADVEN118P)", Nil, "Cliente e cliente venda à ordem são iguais.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
       RestArea(aArea)
       Return .F.

    EndIf

    If ! lAdm .And. ! lBack .And. ! lDiret .And. ! (SA1->A1_VEND $cCarteiras) .And. ! (SA1->A1_XVEND2 $cCarteiras) 
        Help(Nil, Nil, "Função ADVE1185(ADVEN118P)", Nil, "Cliente " + cCodigo + "/" + cLoja + " não pertence à carteira.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    //Preenche data de entrega.
    If ! lVendOrd .And. ! IsInCallStack("vldPos")
        dData := U_ADVE118K()
        FWFldPut("ZJA_DTENTR", dData)

    EndIf

    //Preenche o tipo de pedido para venda ordem.
    If lVendOrd .And. ! IsInCallStack("vldPos")
        FWFldPut("ZJA_TPPED", "4")

    EndIf

    //Carrega Power BI.
    If ValType(oWebEngine) == "O"
        MsAguarde({|| oWebEngine:navigate(cUrl + "'" + cCodigo + cLoja + "' ") }, "Aguarde", "Carregando indicadores...")	

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADVE1186
    Filtro consulta padrão produtos.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE1186() // U_ADVE1186()

    //Variáveis.

Return .T. //SB1->B1_MSBLQL == "2" .And. ((lAdm .Or. lBack .Or. lDiret) .Or. (SB1->B1_XSALES == "2" .And. (Empty(SB1->B1_XLOCAEX) .Or. SB1->B1_XLOCAEX == (cEmpAnt + cFilAnt))))
/*/{Protheus.doc} User Function ADVE1187
    Valida produto.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE1187(cProduto) // U_ADVE1187(M->ZJB_PRODUT)

    //Variáveis.
    Local aArea     := GetArea()
    Local oModel    := FWModelActive()
    Local cLocExp   := oModel:GetValue("MD_MASTER", "ZJA_LOCEXP")

    Default cProduto := ""
    
    If Empty(cProduto) .Or. IsInCallStack("carHitGrd")
        RestArea(aArea)
        Return .T.

    EndIf

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())
    If ! SB1->(DbSeek(FWxFilial("SB1") + cProduto))
        Help(Nil, Nil, "Função ADVE1187(ADVEN118P)", Nil, "Produto " + cProduto + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If SB1->B1_MSBLQL <> "2"
        Help(Nil, Nil, "Função ADVE1187(ADVEN118P)", Nil, "Produto " + cProduto + " bloqueado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If lAdm .Or. lBack .Or. lDiret
        RestArea(aArea)
        Return .T.

    EndIf

    If SB1->B1_XSALES <> "2"
        Help(Nil, Nil, "Função ADVE1187(ADVEN118P)", Nil, "Produto " + cProduto + " não disponível para venda.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If ! Empty(SB1->B1_XLOCAEX) .And. Alltrim(SB1->B1_XLOCAEX) <> Alltrim(cLocExp)
        Help(Nil, Nil, "Função ADVE1187(ADVEN118P)", Nil, "Produto " + cProduto + " não pode ser expedido pela filial corrente.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADVE1188
    Retorna preço de tabela do produto.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE1188(cProduto) // U_ADVE1188(M->ZJB_PRODUT)

    //Variáveis.
    Local aArea   := GetArea()
    Local nPrcTab := 0
    Local oModel  := FWModelActive()
    Local cTabela := oModel:GetValue("MD_MASTER", "ZJA_TABELA")

    DbSelectArea("DA1")
    DA1->(DbSetOrder(1))
    DA1->(DbGoTop())

    If ! DA1->(DbSeek(FWxFilial("DA1") + cTabela + cProduto))
        RestArea(aArea)
        Return 0

    EndIf

    nPrcTab := DA1->DA1_XPRLIQ

    RestArea(aArea)

Return nPrcTab
/*/{Protheus.doc} User Function ADVE1189
    Calcula o preço total na linha do pedido.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE1189(cProduto, nCaixas, nVlrNeg) // U_ADVE1189(M->ZJB_PRODUT, M->ZJB_QTDVEN, M->ZJB_PRCVEN)

    //Variáveis.
    Local aArea   := GetArea()
    Local nVlrTot := 0

    Default cProduto := ""
    Default nCaixas  := 0
    Default nVlrNeg  := 0

    If Empty(cProduto) .Or. nCaixas <= 0 .Or. nVlrNeg <= 0
        RestArea(aArea)
        Return 0

    EndIf

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())
    If ! SB1->(DbSeek(FWxFilial("SB1") + cProduto))
        RestArea(aArea)
        Return 0

    EndIf

Return nVlrTot
/*/{Protheus.doc} User Function ADVE118A
    Valida preço do produto.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE118A(nVlrNeg, cProduto, nPrcTab) // U_ADVE118A(M->ZJB_PRCVEN)

    //Variáveis.
    Local aArea      := GetArea()
    Local oModel     := FWModelActive()
    Local oGrid      := oModel:GetModel("MD_GRID")
    Local nPrcMax    := 0 
    Local nMinSupe   := 0
    Local nMinVend   := 0

    Default cProduto := oGrid:GetValue("ZJB_PRODUT")
    Default nPrcTab  := U_ADVE1188(cProduto)
    Default nVlrNeg  := 0

    If nVlrNeg <= 0
        Help(Nil, Nil, "Função ADVE118A(ADVEN118P)", Nil, "Necessário informar valor positivo.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If Empty(cProduto)
        Help(Nil, Nil, "Função ADVE118A(ADVEN118P)", Nil, "Necessário informar o produto.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    //Obtém preços.
    //{nMinVend, nMinSupe, nMinCIA, nPrcMax}
    aPrecos  := obtPrcs(cProduto, nPrcTab)
    nMinVend := aPrecos[1]
    nMinSupe := aPrecos[2]
    nMinCIA  := aPrecos[3]
    nPrcMax  := aPrecos[4]
    
    //Valida preço máximo
    If nPrcMax < nVlrNeg
        Help(Nil, Nil, "Função ADVE118A(ADVEN118P)", Nil, "Restrição por preço máximo (" + cProduto + "). " + xPula + "Prc Max. " + Transform(nPrcMax, "@E 999,999.99"), 1)
        RestArea(aArea)
        Return .F.

    EndIf

    If ! lSuperv .And. nVlrNeg > 0 .And. nMinSupe > nVlrNeg
        Help(Nil, Nil, "Função ADVE118A(ADVEN118P)", Nil, "Preço mínimo não permito pelo supervisor (" + cProduto + "). " + xPula + "Min. Supervisor " + Transform(nMinSupe, "@E 999,999.99"), 1)
        RestArea(aArea)
        Return .F.

    EndIf

    If ! lDiret .And. nVlrNeg > 0 .And. nMinCIA > nVlrNeg
        Help(Nil, Nil, "Função ADVE118A(ADVEN118P)", Nil, "Preço mínimo não permito pela CIA (" + cProduto + ")." + xPula + "Min. CIA " + Transform(nMinCIA, "@E 999,999.99"), 1)
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} obtPrcs
    Retorna preços mínimo vendedor, supervisor e CIA. Preço.
    @type  Static Function
    @author Everson
    @since 16/05/2023
    @version 01
/*/
Static Function obtPrcs(cProduto, nPrcTab)

    //Variáveis.
    Local aArea         := GetArea()
    Local oModel        := FWModelActive()
    Local cCodCli       := oModel:GetValue("MD_MASTER", "ZJA_CLIENT")
    Local cLojCli       := oModel:GetValue("MD_MASTER", "ZJA_LOJACL")
    Local cTabCod       := oModel:GetValue("MD_MASTER", "ZJA_TABELA")
    Local cTpFrt        := oModel:GetValue("MD_MASTER", "ZJA_TPFRET")
    Local cEst          := Posicione("SA1", 1, FWxFilial("SA1") + cCodCli + cLojCli, "A1_EST")
    Local cMuni         := Posicione("SA1", 1, FWxFilial("SA1") + cCodCli + cLojCli, "A1_COD_MUN")
    Local nCusto        := 0
    Local nFrete        := 0
    Local nTbFob        := 0
    Local nDesCom       := 0
    Local nPrcMax       := 0
    Local nPrcPrt       := 0
    Local nTPIP         := 0
    Local aAlcadas      := {}
    Local nAlcadaV      := 1
    Local nAlcadaS      := 1
    Local nAlcadaD      := 1   
    Local cVendedor     := oModel:GetValue("MD_MASTER", "ZJA_CODVEN")
    Local cSupervisor   := Posicione("SA3", 1, FWxFilial("SA3") + cVendedor, "A3_SUPER")
    Local nCdMinSup     := 0
    Local nMinSupe      := 0
    Local nMinVend      := 0

    nCusto   := obtCusto(cProduto)                           //Custo.
    nFrete   := Iif(cTpFrt == "F", 0, obtFrete(cEst, cMuni)) //Frete.
    nTbFob   := nPrcTab                                      //Tabela FOB.
    nDesCom  := obtDesc(cCodCli, cLojCli, cProduto)/100      //Desconto comercial (contrato).
    nPrcMax  := obtPrcMax(cProduto)                          //Preço máximo.
    nPrcPrt  := U_ADVE118T()                                 //Preço de partida.
    nTPIP    := obtVlrIp(cProduto)                           //Tabela IP.

    aAlcadas := obtAlcadas(cTabCod)

    If Len(aAlcadas) > 0
        nAlcadaV :=  aAlcadas[1,1]/100  //Alçada vendedor.
        nAlcadaS :=  aAlcadas[1,2]/100  //Alçada supervisor.
        nAlcadaD :=  aAlcadas[1,4]/100  //Alçada diretor.

    EndIf

    //Preço mínimo companhia.
    nMinCIA := U_ADVE118V(cProduto) //Preço mínimo CIA.
    If nMinCIA > 0
        nMinCIA := Round((nMinCIA + nFrete) / Iif((1-nDesCom) == 0, 1, (1-nDesCom)), 2) 

    EndIf

    nMinSupe := obtPMinS(cProduto)
    If nMinSupe > 0
        nMinSupe := Round((nMinSupe + nFrete) / Iif((1-nDesCom) == 0, 1, (1-nDesCom)), 2) 

    EndIf

    //Preço mínimo vendedor.
    If ! obtCdVen(cProduto, cVendedor, @nMinVend)
        nMinVend := nAlcadaS * nPrcPrt

    Else
       nMinSupe :=  Round((nMinVend) / Iif((1-nDesCom) == 0, 1, (1-nDesCom)), 2) //O preço mínimo do vendedor passa a valer como mínimo do supervisor, pois o mínimo do supervisor é a trava para o vendedor.
        
    EndIf

    //Regra para passar preço exceção do supervisor para o vendedor.
    //Preço mínimo supervisor.
    If obtCdSup(cProduto, cSupervisor, @nCdMinSup)
        //nMinSupe := Round((nCdMinSup + nFrete) / Iif((1-nDesCom) == 0, 1, (1-nDesCom)), 2) 
        nMinCIA  := Round((nCdMinSup) / Iif((1-nDesCom) == 0, 1, (1-nDesCom)), 2) 

    EndIf

    RestArea(aArea)
    
Return {nMinVend, nMinSupe, nMinCIA, nPrcMax}
/*/{Protheus.doc} User Function ADVE118B
    Valida data de entrega.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE118B(dData) // U_ADVE118B(M->ZJA_DTENTR)

    //Variáveis.
    Local aArea   := GetArea()
    Local oModel  := FWModelActive()
    Local cCodCli := oModel:GetValue("MD_MASTER", "ZJA_CLIENT")
    Local cLojCli := oModel:GetValue("MD_MASTER", "ZJA_LOJACL")
    Local dDtMax  := Nil
    Local dDtMin  := Nil
    Local cTpPed  := oModel:GetValue("MD_MASTER", "ZJA_TPPED")

    If IsInCallStack("U_ADVE118K") .Or. IsInCallStack("U_ADVE118R")
        RestArea(aArea)
        Return .T.

    EndIf

    If Empty(cCodCli) .Or. Empty(cLojCli)
        Help(Nil, Nil, "Função ADVE118B(ADVEN118P)", Nil, "Necessário informar código do cliente e loja.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If ! U_ADVE1201()
        Help(Nil, Nil, "Função ADVE118B(ADVEN118P)", Nil, "Não há parametrização de pedido ativa.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf
    
    If dData <= Date()
        Help(Nil, Nil, "Função ADVE118B(ADVEN118P)", Nil, "Data de entrega inválida.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If Dow(dData) == 1
        Help(Nil, Nil, "Função ADVE118B(ADVEN118P)", Nil, "Não é possível selecionar um domingo como data de entrega.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    //Valida data máxima.
    dDtMax := U_ADVE118M()

    If dDtMax < dData
        Help(Nil, Nil, "Função ADVE118B(ADVEN118P)", Nil, "Data de entrega inválida. Maior data possível " + DToC(dDtMax) + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    //Obtém data mínima.
    dDtMin := U_ADVE118K()

    If dDtMin > dData
        Help(Nil, Nil, "Função ADVE118B(ADVEN118P)", Nil, "Data de entrega inválida. Menor data possível " + DToC(dDtMin) + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If (dData > Date() + ZJD->ZJD_LMVDF) .And. cTpPed == "4"
        Help(Nil, Nil, "Função ADVE118B(ADVEN118P)", Nil, "Não é possível lançar data de 'Venda futura' para pedido 'Venda à ordem'.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf 

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADVE118K
    Retorna data de entrega mínima.
    @type  Function
    @author Everson
    @since 19/04/2023
    @version 01
/*/
User Function ADVE118K()

    //Variáveis.
    Local aArea   := GetArea()
    Local dData   := Date() + 1
    Local oModel  := FWModelActive()
    Local cCodCli := oModel:GetValue("MD_MASTER", "ZJA_CLIENT")
    Local cLojCli := oModel:GetValue("MD_MASTER", "ZJA_LOJACL")
    Local lIntEst := .F.

    If Empty(cCodCli) .Or. Empty(cLojCli)
        RestArea(aArea)
        Return Date() + 1

    EndIf

    lIntEst := Alltrim(cValToChar(Posicione("SA1", 1, FWxFilial("SA1") + cCodCli + cLojCli, "A1_EST"))) <> "SP"

    If (! lIntEst .And. lVend   .And. ZJD->ZJD_VHREST < Time()) .Or.;  //Vendedor estadual.
       (lIntEst   .And. lVend   .And. ZJD->ZJD_VHRINT < Time()) .Or.;      //Vendedor interestadual.
       (! lIntEst .And. (lSuperv .Or. lDiret) .And. ZJD->ZJD_SHREST < Time()) .Or.;  //Supervisor estadual.
       (lIntEst   .And. (lSuperv .Or. lDiret) .And. ZJD->ZJD_SHRINT < Time() )         //Supervisor interestadual.
        
        dData := dData + 1

    EndIf

    If Dow(dData) == 1
        dData := dData + 1

    EndIf

    RestArea(aArea)

Return dData
/*/{Protheus.doc} User Function ADVE118M
    Retorna a data de entrega máxima.
    @type  Function
    @author Everson
    @since 04/05/2023
    @version 01
/*/
User Function ADVE118M()

    //Variáveis.
    Local aArea  := GetArea()
    Local dDtMax := Nil
    
    If ! U_ADVE1201()
        Help(Nil, Nil, "Função ADVE118M(ADVEN118P)", Nil, "Não há parametrização de pedido ativa.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Date() + 1

    EndIf

    dDtMax := Date() + ZJD->ZJD_NMAXDE

Return dDtMax
/*/{Protheus.doc} User Function ADVE118P
    Limite venda futura.
    @type  Function
    @author Everson
    @since 04/05/2023
    @version 01
/*/
User Function ADVE118P()

    //Variáveis.
    Local aArea  := GetArea()
    Local dDtMax := Nil
    
    If ! U_ADVE1201()
        Help(Nil, Nil, "Função ADVE118P(ADVEN118P)", Nil, "Não há parametrização de pedido ativa.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Date() + 1

    EndIf

    dDtMax := Date() + ZJD->ZJD_LMVDF

Return Nil
/*/{Protheus.doc} User Function ADVE118C
    Consulta específica para condição de pagamento.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE118C(cCodigo, cLoja) // U_ADVE118C(M->ZJA_CLIENT, M->ZJA_LOJACL)

    //Variáveis.
    Local aArea     := GetArea()
    Local oDlg, oLbx
    Local aCpos     := {}
    Local aRet      := {}
    Local cQuery    := ""
    Local cAlias    := ""
    Local lRet      := .F.
    Local cCondCli  := ""
    Local cDescri   := ""

    If Empty(cCodigo) .Or. Empty(cLoja)
        RestArea(aArea)
        Return .T.

    EndIf

    cCondCli := Posicione("SA1", 1, FWxFilial("SA1") + cCodigo + cLoja, "A1_COND")
    cDescri  := Posicione("SE4", 1, FWxFilial("SE4") + cCondCli, "E4_DESCRI")

    Aadd(aCpos,{cCondCli, cDescri})

    cAlias := GetNextAlias()

    cQuery := " SELECT DISTINCT ZJC_CODF, ZJC_DESCF FROM " + RetSqlName("ZJC") + " (NOLOCK) AS ZJC WHERE ZJC_FILIAL = '" + FWxFilial("ZJC") + "' AND ZJC_CODP = '" + cCondCli + "' AND ZJC.D_E_L_E_T_ = '' ORDER BY ZJC_CODF "

    cQuery := ChangeQuery(cQuery)

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)

    While (cAlias)->(!Eof())

        Aadd(aCpos,{(cAlias)->(ZJC_CODF), (cAlias)->(ZJC_DESCF)})

        (cAlias)->(dbSkip())

    End

    (cAlias)->(DbCloseArea())

    DEFINE MSDIALOG oDlg TITLE /*STR0083*/ "Condições de Pagamento" FROM 0,0 TO 240,500 PIXEL

        @ 10,10 LISTBOX oLbx FIELDS HEADER 'Roteiro' /*"Roteiro"*/, 'Código' /*"Produto"*/, 'Descrição' SIZE 230,95 OF oDlg PIXEL

        oLbx:SetArray(aCpos)
        oLbx:bLine      := {|| {aCpos[oLbx:nAt,1], aCpos[oLbx:nAt,2]}}
        oLbx:bLDblClick := {|| {oDlg:End(), lRet:=.T., aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2]}}}

    DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (oDlg:End(), lRet:=.T., aRet := {oLbx:aArray[oLbx:nAt,1],oLbx:aArray[oLbx:nAt,2]})  ENABLE OF oDlg

    ACTIVATE MSDIALOG oDlg CENTER

    FreeObj(oDlg)
    oDlg := Nil
    FreeObj(oLbx)
    oLbx := Nil

    If Len(aRet) > 0 .And. lRet
        
        If Empty(aRet[1])
            lRet := .F.
        
        Else
            SE4->(dbSetOrder(1))
            SE4->(dbSeek(xFilial("SE4")+aRet[1]))

        EndIf

    EndIf

Return lRet
/*/{Protheus.doc} User Function ADVE118D
    Valida condição de pagamento.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADVE118D(cCdPg) // U_ADVE118D(M->ZJA_CONDPA)

    //Variáveis.
    Local aArea     := GetArea()
    Local cCodigo   := M->ZJA_CLIENT
    Local cLoja     := M->ZJA_LOJACL
    Local cCondCli  := Posicione("SA1", 1, FWxFilial("SA1") + cCodigo + cLoja, "A1_COND")

    Default cCdPg   := ""

    If IsInCallStack("U_ADVE118R")
        RestArea(aArea)
        Return .T.

    EndIf

    If Empty(cCdPg)
        RestArea(aArea)
        Return .T.

    EndIf

    If Alltrim(cValToChar(cCondCli)) == Alltrim(cValToChar(cCdPg))
        RestArea(aArea)
        Return .T.

    EndIf

    If Empty(cCondCli)
        RestArea(aArea)
        Return .F.

    EndIf

    DbSelectArea("ZJC")
    ZJC->(DbSetOrder(2))
    ZJC->(DbGoTop())

    If ! ZJC->(DbSeek(FWxFilial("ZJC") + cCondCli + cCdPg))
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADVE118H
    Gatilho quantidade em Kg.
    @type  Function
    @author Everson
    @since 13/04/2023
    @version 01)
/*/
User Function ADVE118H(cProduto, nCaixas) // U_ADVE118H(M->ZJB_PRODUT, M->ZJB_UNSVEN)

    //Variáveis.
    Local aArea     := GetArea()
    Local nQtdKg    := 0

    If nCaixas <= 0
        RestArea(aArea)
        Return 0

    EndIf

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())
    If ! SB1->(DbSeek(FWxFilial("SB1") + cProduto))
        RestArea(aArea)
        Return 0

    EndIf

    If SB1->B1_TIPCONV == "D"
        nQtdKg := nCaixas * SB1->B1_CONV

    ElseIf SB1->B1_TIPCONV == "M"
        nQtdKg := nCaixas/SB1->B1_CONV

    Else
        nQtdKg := nCaixas

    EndIf

    RestArea(aArea)
    
Return nQtdKg
/*/{Protheus.doc} User Function ADVE118I
    Cálculo de IP, IT e EM na linha do produto.
    @type  Function
    @author Everson
    @since 13/04/2023
    @version 01
/*/
User Function ADVE118I(cInd) // U_ADVE118I("IT") U_ADVE118I("EM") U_ADVE118I("IP")  

    //Variáveis.
    Local aArea     := GetArea()
    Local nVlr      := 0
    Local oModel    := FWModelActive()
    Local oGrid     := oModel:GetModel("MD_GRID")
    Local nPrcVe    := oGrid:GetValue("ZJB_PRCVEN")
    Local cProduto  := oGrid:GetValue("ZJB_PRODUT")
    Local cCodCli   := oModel:GetValue("MD_MASTER", "ZJA_CLIENT")
    Local cLojCli   := oModel:GetValue("MD_MASTER", "ZJA_LOJACL")
    Local cEst      := Posicione("SA1", 1, FWxFilial("SA1") + cCodCli + cLojCli, "A1_EST")
    Local cMuni     := Posicione("SA1", 1, FWxFilial("SA1") + cCodCli + cLojCli, "A1_COD_MUN")
    Local nCusto    := obtCusto(cProduto)
    Local nDesconto := obtDesc(cCodCli, cLojCli, cProduto)/100
    Local nFrete    := obtFrete(cEst, cMuni)
    Local nPrcNgFob := nPrcVe * (1- nDesconto) - nFrete
    Local nTabIP    := obtVlrIp(cProduto)
    Local nTbFob    := U_ADVE1188(cProduto)

    If cInd == "IT" .And. nPrcVe > 0 .And. nTbFob > 0
        nVlr := Round((nPrcNgFob/nTbFob) * 100, TamSX3("ZJB_IT")[2])

    ElseIf cInd == "EM" .And. nPrcVe > 0
        nCusto := obtCusto(cProduto)
        nVlr   := (nPrcNgFob - nCusto) * 1000

    ElseIf cInd == "IP" .And. nPrcVe > 0 .And. nTabIP > 0
        nVlr := Round((nPrcNgFob/nTabIP) * 100, TamSX3("ZJB_IT")[2])
        
    EndIf

    RestArea(aArea)
    
Return nVlr
/*/{Protheus.doc} User Function ADVE118J
    Valida tipo de pedido.
    @type  Function
    @author Everson
    @since 13/04/2023
    @version 01
/*/
User Function ADVE118J(cTpPed) // U_ADVE118J(M->ZJA_TPPED)  

    //Variáveis.
    Local aArea := GetArea()

    If IsInCallStack("U_ADVE1185") .Or. IsInCallStack("lmpCliVO") .Or. IsInCallStack("U_ADVE118R") .Or. IsInCallStack("pedEnFut")
        RestArea(aArea)
        Return .T.

    EndIf

    If ! lAdm .And. ! lBack
        Help(Nil, Nil, "Função ADVE118J(ADVEN118P)", Nil, "Usuário sem permissão para alterar o tipo do pedido.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If Empty(cTpPed)
        Help(Nil, Nil, "Função ADVE118J(ADVEN118P)", Nil, "Necessário informar o tipo do pedido.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If !(cTpPed $"1/3")
        Help(Nil, Nil, "Função ADVE118J(ADVEN118P)", Nil, "Não é possível utilizar o tipo de pedido selecionado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)
    
Return .T.
/*/{Protheus.doc} lmpCliVO
    Remove dados do cliente de venda à ordem.
    @type  Static Function
    @author Everson
    @since 04/05/2023
    @version 01
/*/
Static Function lmpCliVO(oView)

    FWFldPut("ZJA_TPPED" , "1")
    FWFldPut("ZJA_CLIEVO", Space(TamSX3("ZJA_CLIEVO")[1]))
    FWFldPut("ZJA_LOJAVO", Space(TamSX3("ZJA_LOJAVO")[1]))
    FWFldPut("ZJA_NOMEVO", Space(TamSX3("ZJA_NOMEVO")[1]))

    If ValType(oView) == "O"
        oView:Refresh()

    EndIf

Return Nil
/*/{Protheus.doc} obtCusto
    Obtém custo do produto.
    @type  Static Function
    @author Everson
    @since 18/04/2023
    @version 01
/*/
Static Function obtCusto(cProduto)

    //Variáveis.
    Local aArea  := GetArea()
    Local nVlr   := 0
    Local cGRupo := Posicione("SB1", 1, FWxFilial("SB1") + cProduto, "B1_GRUPO")
    Local cQuery := " SELECT TOP 1 ZZS_VALOR FROM " + RetSqlName("ZZS") + " (NOLOCK) AS ZZS WHERE ZZS_FILIAL = '" + FWxFilial("ZZS") + "' AND ZZS_GRUPO = '" + cGRupo + "' AND ZZS.D_E_L_E_T_ = '' ORDER BY ZZS_DATA DESC "
    Local cAlias := GetNextAlias()

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    nVlr := Val(cValToChar((cAlias)->ZZS_VALOR))

    (cAlias)->(DbCloseArea())

    RestArea(aArea)
    
Return nVlr
/*/{Protheus.doc} ADVE118T
    Preço de partida.
    @type  Static Function
    @author Everson
    @since 02/05/2023
    @version 01
/*/
User Function ADVE118T()

    //Variáveis.
    Local aArea     := GetArea()
    Local nVlr      := 0
    Local oModel    := FWModelActive()
    Local oGrid     := oModel:GetModel("MD_GRID")
    Local cProduto  := oGrid:GetValue("ZJB_PRODUT")
    
    If Empty(cProduto)
        RestArea(aArea)
        Return 0

    EndIf

    nTbFob    := U_ADVE1188(cProduto)
    cCodCli   := oModel:GetValue("MD_MASTER", "ZJA_CLIENT")
    cLojCli   := oModel:GetValue("MD_MASTER", "ZJA_LOJACL")
    cEst      := Posicione("SA1", 1, FWxFilial("SA1") + cCodCli + cLojCli, "A1_EST")
    cMuni     := Posicione("SA1", 1, FWxFilial("SA1") + cCodCli + cLojCli, "A1_COD_MUN")
    nFrete    := obtFrete(cEst, cMuni)
    nDesconto := obtDesc(cCodCli, cLojCli, cProduto)/100
    
    nVlr := nTbFob + nFrete

    If nDesconto > 0
        nVlr := nVlr/(1-nDesconto)

    EndIf

    RestArea(aArea)
    
Return nVlr
/*/{Protheus.doc} obtFrete
    Obtém valor de frete.
    @type  Static Function
    @author Everson
    @since 18/04/2023
    @version 01
/*/
Static Function obtFrete(cEst, cMuni)

    //Variáveis.
    Local aArea  := GetArea()
    Local nVlr   := 0
    Local cQuery := ""
    Local cAlias := GetNextAlias()

    cQuery := ""
    cQuery += " SELECT  " 
	    cQuery += " CC2_EST, CC2_CODMUN, CC2_XREGIA, FRTREG.ZZI_VALOR AS FRTREG, FRTEST.ZZI_VALOR AS FRTEST " 
	cQuery += " FROM  " 
        cQuery += " " + RetSqlName("CC2") + " (NOLOCK) AS CC2  " 
        cQuery += " LEFT OUTER JOIN " 
        cQuery += " (SELECT ZZI_REGIAO,ZZI_VALOR FROM " + RetSqlName("ZZI") + " (NOLOCK) AS ZZI WHERE ZZI.D_E_L_E_T_ = '') AS FRTREG " 
        cQuery += " ON CC2_XREGIA = FRTREG.ZZI_REGIAO " 
        cQuery += " LEFT OUTER JOIN " 
        cQuery += " (SELECT ZZI_ESTADO, MAX(ZZI_VALOR) AS ZZI_VALOR FROM " + RetSqlName("ZZI") + " (NOLOCK) AS ZZI WHERE ZZI.D_E_L_E_T_ = '' GROUP BY ZZI_ESTADO) AS FRTEST " 
        cQuery += " ON CC2_EST = FRTEST.ZZI_ESTADO " 
	cQuery += " WHERE  " 
        cQuery += " CC2_FILIAL = '' " 
        cQuery += " AND CC2_EST = '" + cEst + "' " 
        cQuery += " AND CC2_CODMUN = '" + cMuni + "' "
        cQuery += " AND CC2.D_E_L_E_T_ = '' "

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    
    (cAlias)->(DbGoTop())
        
        nVlr := Val(cValToChar((cAlias)->FRTREG))

        If nVlr <= 0
            nVlr := Val(cValToChar((cAlias)->FRTEST))

        EndIf

    (cAlias)->(DbCloseArea())

    RestArea(aArea)
    
Return nVlr
/*/{Protheus.doc} obtDesc
    Obtém desconto do cliente.
    @type  Static Function
    @author Everson
    @since 18/04/2023
    @version 01
/*/
Static Function obtDesc(cCodCli, cLojCli, cProduto)

    //Variáveis.
    Local aArea := GetArea()
    Local nVlr  := Posicione("SA1", 1, FWxFilial("SA1") + cCodCli + cLojCli, "A1_DESC")

    DbSelectArea("ZC5")
    ZC5->(DbSetOrder(1))
    ZC5->(DbGoTop())
    If ZC5->(DbSeek( FWxFilial("ZC5") + cCodCli + cLojCli + cProduto ))

        nVlr := ZC5->ZC5_ANIVER + ZC5->ZC5_FORNEC + ZC5->ZC5_LOGIST + ZC5->ZC5_REINAU + ZC5->ZC5_QBRTRC + ZC5->ZC5_ASSOCI + ZC5->ZC5_CRESCI + ZC5->ZC5_INVCOO + ZC5->ZC5_WEB

    EndIf

    RestArea(aArea)

Return nVlr
/*/{Protheus.doc} obtVlrIp
    Retorna o preço da tabela IP.
    @type  Static Function
    @author Everson
    @since 18/04/2023
    @version 01
/*/
Static Function obtVlrIp(cProduto)

    //Variáveis.
    Local aArea  := GetArea()
    Local cTabIP := Alltrim(cValToChar( GetMv("MV_#SFTBIP") ))
    Local nVlr   := 0

    DbSelectArea("DA1")
    DA1->(DbSetOrder(1))
    DA1->(DbGoTop())

    If DA1->(DbSeek(FWxFilial("DA1") + cTabIP + cProduto))
        nVlr := DA1->DA1_XPRLIQ

    EndIf

    RestArea(aArea)
    
Return nVlr
/*/{Protheus.doc} obtPrcMax
    Retorna o preço máximo do produto.
    @type  Static Function
    @author Everson
    @since 18/04/2023
    @version 01
/*/
Static Function obtPrcMax(cProduto)

    //Variáveis.
    Local aArea  := GetArea()
    Local cTab   := "Y00"

    DbSelectArea("DA1")
    DA1->(DbSetOrder(1))
    DA1->(DbGoTop())

    If DA1->(DbSeek( FWxFilial("DA1") + cTab + cProduto ))
        nVlr := DA1_XPRLIQ

    EndIf

    RestArea(aArea)

Return nVlr
/*/{Protheus.doc} obtPMinS
    Retorna o preço mínimo supervisor do produto (limite vendedor).
    @type  Static Function
    @author Everson
    @since 18/04/2023
    @version 01
/*/
Static Function obtPMinS(cProduto)

    //Variáveis.
    Local aArea  := GetArea()
    Local cTab   := "Z00"

    DbSelectArea("DA1")
    DA1->(DbSetOrder(1))
    DA1->(DbGoTop())

    If DA1->(DbSeek( FWxFilial("DA1") + cTab + cProduto ))
        nVlr := DA1_XPRLIQ

    EndIf

    RestArea(aArea)

Return nVlr
/*/{Protheus.doc} User Function ADVE118V
    Retorna o preço mínimo companhia do produto (limite supervisor).
    @type  Static Function
    @author Everson
    @since 18/04/2023
    @version 01
/*/
User Function ADVE118V(cProduto)

    //Variáveis.
    Local aArea  := GetArea()
    Local nVlr   := 0
    Local cTab   := "Z01"

    DbSelectArea("DA1")
    DA1->(DbSetOrder(1))
    DA1->(DbGoTop())

    If DA1->(DbSeek( FWxFilial("DA1") + cTab + cProduto ))
        nVlr := DA1_XPRLIQ

    EndIf

    RestArea(aArea)

Return nVlr
/*/{Protheus.doc} obtAlcadas
    Retorna alçadas.
    @type  Static Function
    @author Everson
    @since 18/04/2023
    @version 01
/*/
Static Function obtAlcadas(cTabCod)

    //Variáveis.
    Local aArea    := GetArea()
    Local aAlcadas := {}

    DbSelectArea("DA0")
    DA0->(DbSetOrder(1))
    DA0->(DbGoTop())

    If DA0->(DbSeek( FWxFilial("DA0") + cTabCod))
        
        Aadd(aAlcadas, {;
                        Iif(DA0->DA0_XVENDE == 0, 100, DA0->DA0_XVENDE),;
                        Iif(DA0->DA0_XSUPER == 0, 100, DA0->DA0_XSUPER),;
                        Iif(DA0->DA0_XGEREN == 0, 100, DA0->DA0_XGEREN),;
                        Iif(DA0->DA0_XDIRET == 0, 100, DA0->DA0_XDIRET); 
                        })

    EndIf

    RestArea(aArea)

Return aAlcadas
/*/{Protheus.doc} obtCdSup
    Obtém liberação de preço mínimo para o supervisor.
    @type  Static Function
    @author Everson
    @since 18/04/2023
    @version 01
/*/
Static Function obtCdSup(cProduto, cSupervisor, nVlr)

    //Variáveis.
    Local aArea  := GetArea()
    Local lRet   := .F.
    Local cQuery := "SELECT R_E_C_N_O_ AS REC FROM " + RetSqlName("ZJE") + " WHERE ZJE_FILIAL = '" + FWxFilial("ZJE") + "' AND ZJE_PRODUT = '" + cProduto + "' AND ZJE_ATIVO = '1' AND ZJE_SUPERV IS NOT NULL AND D_E_L_E_T_ = '' ORDER BY ZJE_CODIGO"
    Local cAlias := GetNextAlias()

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)

    DbSelectArea("ZJE")
    ZJE->(DbGoTop())

    While (cAlias)->(!Eof())

        ZJE->(DbGoTo(Val(cValToChar((cAlias)->REC))))

        If cSupervisor $Alltrim(cValToChar(ZJE->ZJE_SUPERV))
            lRet := .T.
            nVlr := ZJE->ZJE_PRECMI
            Exit

        EndIf

        (cAlias)->(dbSkip())

    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} obtCdVen
    Obtém liberação de preço mínimo para o vendedor.
    @type  Static Function
    @author Everson
    @since 18/04/2023
    @version 01
/*/
Static Function obtCdVen(cProduto, cVendedor, nVlr)

    //Variáveis.
    Local aArea  := GetArea()
    Local lRet   := .F.
    Local cQuery := "SELECT R_E_C_N_O_ AS REC FROM " + RetSqlName("ZJE") + " WHERE ZJE_FILIAL = '" + FWxFilial("ZJE") + "' AND ZJE_PRODUT = '" + cProduto + "' AND ZJE_ATIVO = '1' AND ZJE_VENDED IS NOT NULL AND D_E_L_E_T_ = '' ORDER BY ZJE_CODIGO"
    Local cAlias := GetNextAlias()

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)

    DbSelectArea("ZJE")
    ZJE->(DbGoTop())

    While (cAlias)->(!Eof())

        ZJE->(DbGoTo(Val(cValToChar((cAlias)->REC))))

        If cVendedor $Alltrim(cValToChar(ZJE->ZJE_VENDED))
            lRet := .T.
            nVlr := ZJE->ZJE_PRECMI
            Exit

        EndIf

        (cAlias)->(dbSkip())

    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} obtPedMin
    Obtém valor do pedido mínimo do cliente.
    @type  Static Function
    @author Everson
    @since 19/04/2023
    @version 01
/*/
Static Function obtPedMin(cCodCli, cLojCli)

    //Variáveis.
    Local aArea := GetArea()
    Local nVlr  := 0

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())
    If SA1->(DbSeek(FWxFilial("SA1") + cCodCli + cLojCli))
        nVlr := SA1->A1_XPEDMIN

    EndIf

    RestArea(aArea)
    
Return nVlr
/*/{Protheus.doc} obtDSup
    Retorna dados do supervisor.
    @type  Static Function
    @author Everson
    @since 19/04/2023
    @version 01
/*/
Static Function obtDSup(cVendedor)

    //Variáveis.
    Local aArea         := GetArea()
    Local aDados        := {"", "", ""} 
    Local cSupervisor   := Posicione("SA3", 1, FWxFilial("SA3") + cVendedor, "A3_SUPER")


    DbSelectArea("SA3")
    SA3->(DbSetOrder(1))
    SA3->(DbGoTop())

    If SA3->(DbSeek(FWxFilial("SA3") + cSupervisor))
        aDados[1] := cSupervisor
        aDados[2] := SA3->A3_NOME
        aDados[3] := SA3->A3_CODUSR

    EndIf

    RestArea(aArea)
    
Return aDados
/*/{Protheus.doc} obtDDrt
    Retorna dados do diretor.
    @type  Static Function
    @author Everson
    @since 19/04/2023
    @version 01
/*/
Static Function obtDDrt(cVendedor)

    //Variáveis.
    Local aArea     := GetArea()
    Local aDados    := {"", "", ""} 
    Local cDiretor  := ""

    DbSelectArea("SA3")
    SA3->(DbSetOrder(1))
    SA3->(DbGoTop())

    If SA3->(DbSeek(FWxFilial("SA3") + cVendedor))
        cDiretor := SA3->A3_XDIRET

    EndIf

    DbSelectArea("SA3")
    SA3->(DbSetOrder(1))
    SA3->(DbGoTop())

    If SA3->(DbSeek(FWxFilial("SA3") + cDiretor))
        aDados[1] := SA3->A3_COD
        aDados[2] := SA3->A3_NOME
        aDados[3] := SA3->A3_CODUSR

    EndIf

    RestArea(aArea)
    
Return aDados
/*/{Protheus.doc} ADVE118L
    Histórico de compras.
    @type  Static Function
    @author Everson
    @since 02/05/2023
    @version 01
/*/
User Function ADVE118L(oView)

    //Variáveis.
    Local aArea     := GetArea()
    Local oModel    := FWModelActive()
    Local cCodigo   := oModel:GetValue("MD_MASTER","ZJA_CLIENT")
    Local cLoja     := oModel:GetValue("MD_MASTER","ZJA_LOJACL")
    Local cLocExp   := oModel:GetValue("MD_MASTER","ZJA_LOCEXP")
    Local cQuery    := ""
    Local nDHist    := 0
    Local cTitulo   := ""
    Local cAlias    := ""
    Local oModal    := Nil
    Local cDesPrd   := ""
    Local oBrowse   := Nil
    Local oTempTable:= Nil
    Local cAliasTab := ""
    Local aFields   := {}
    Local lRetGrd   := .F.
    Local cProdutos := ""

    If Empty(cCodigo) .Or. Empty(cLoja)
        MsgInfo("Necessário informar código do cliente e loja.", "ADVE118L(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    If Empty(cLocExp)
        MsgInfo("Necessário informar o local de expedição.", "ADVE118L(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    If ! U_ADVE1201()
        MsgInfo("Não há cadastro de parâmetros de pedidos ativo.", "ADVE118L(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    cProdutos := obtProdGrid()

    nDHist  := ZJD->ZJD_DHISTO
    cTitulo := "Histórico de Compras - " + cValToChar(nDHist) + " dia(s)"

    cQuery := " SELECT D2_COD, COUNT(DISTINCT D2_PEDIDO) AS FREQ, ISNULL(AVG(D2_QTSEGUM),0) AS MEDIA, ISNULL(MAX(D2_QTSEGUM),0) AS QTDMAX "
        cQuery += " FROM " + RetSqlName("SD2") + " (NOLOCK) AS SD2 INNER JOIN " + RetSqlName("SB1") + " (NOLOCK) AS SB1 ON D2_COD = B1_COD  AND SB1.D_E_L_E_T_ = '' "
    cQuery += " WHERE "
        //cQuery += " D2_FILIAL = '" + FWxFilial("SD2") + "' "
        cQuery += " D2_CLIENTE = '" + cCodigo + "' AND D2_LOJA = '" + cLoja + "' "
        cQuery += " AND DATEDIFF(DAY, D2_EMISSAO, GETDATE()) <= " + cValToChar(nDHist) + " "
        cQuery += " AND (B1_XLOCAEX = '' OR B1_XLOCAEX = '" + cLocExp + "') "
        cQuery += " AND SD2.D_E_L_E_T_ = '' "
        cQuery += " AND B1_MSBLQL =  '2' "
        cQuery += " AND B1_XSALES =  '2' "

        If ! Empty(cProdutos)
            cQuery += " AND B1_COD NOT IN (" + cProdutos + ") "

        EndIf

    cQuery += " GROUP BY D2_COD "
    cQuery += " ORDER BY FREQ DESC"

    cAlias := GetNextAlias()

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    If (cAlias)->(Eof())
        (cAlias)->(DbCloseArea())
        MsgInfo("Não há dados disponíveis.", "ADVE118L(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    cAliasTab := GetNextAlias()

    oTempTable := FWTemporaryTable():New(cAliasTab)

    aFields := {}
    Aadd(aFields, {"XXB1COD" , "C",  TamSX3("B1_COD")[1]  , 0})
    Aadd(aFields, {"XXB1DESC", "C",  TamSX3("B1_DESC")[1] , 0})
    Aadd(aFields, {"XXFREQ"  , "N",  12 , 0})
    Aadd(aFields, {"XXMEDIA" , "N",  12 , 0})
    Aadd(aFields, {"XXMAX"   , "N",  12 , 0})
    Aadd(aFields, {"XXQTDCX" , "N",  TamSX3("ZJB_UNSVEN")[1] , TamSX3("ZJB_UNSVEN")[2]})
    Aadd(aFields, {"XXPRCUT" , "N",  TamSX3("ZJB_PRCVEN")[1] , TamSX3("ZJB_PRCVEN")[2]})
        
    oTempTable:SetFields( aFields )
    // oTempTable:AddIndex("1", {"XXFREQ"} )
    // oTempTable:AddIndex("2", {"XXB1COD"} )
    // oTempTable:AddIndex("3", {"XXB1DESC"} )
    // oTempTable:AddIndex("4", {"XXMEDIA"} )
    // oTempTable:AddIndex("5", {"XXMAX"} )
    oTempTable:Create()

    While ! (cAlias)->(Eof())

        cDesPrd := Posicione("SB1", 1, FWxFilial("SB1") + (cAlias)->D2_COD, "B1_DESC")

        RecLock(cAliasTab, .T.)
            (cAliasTab)->XXB1COD  := (cAlias)->D2_COD
            (cAliasTab)->XXB1DESC := cDesPrd
            (cAliasTab)->XXFREQ   := Round((cAlias)->FREQ,0)
            (cAliasTab)->XXMEDIA  := Round((cAlias)->MEDIA,0)
            (cAliasTab)->XXMAX    := Round((cAlias)->QTDMAX,0)
            (cAliasTab)->XXQTDCX  := 0
            (cAliasTab)->XXPRCUT  := 0
        (cAliasTab)->(MsUnlock())

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    oModal := FWDialogModal():New() 
    oModal:SetBackground( .T. ) 
	oModal:setTitle(cTitulo)
	oModal:setSize( 300 , 500 )
    oModal:EnableFormBar( .T. )
    oModal:SetEscClose(.F.)
	oModal:createDialog()
    oModal:CreateFormBar()

        oModal:AddButton("Confirmar", {|| lRetGrd := carHitGrd(oView, cAliasTab), Iif(lRetGrd, oModal:DeActivate(), Nil) } , "Confirmar", , .T., .F., .T., )
        oModal:AddButton("Cancelar" , {|| oModal:DeActivate() } , "Cancelar" , , .T., .F., .T., )

       	oContainer := TPanel():New( ,,, oModal:getPanelMain() )
	    oContainer:Align := CONTROL_ALIGN_ALLCLIENT

        oBrowse := FwBrowse():New()
        oBrowse:SetOwner(oContainer)
        oBrowse:DisableFilter()
        oBrowse:DisableConfig()
        oBrowse:DisableReport()
        oBrowse:DisableSeek()
        oBrowse:DisableSaveConfig()
        oBrowse:SetAlias(cAliasTab)
        oBrowse:SetDataTable()
        oBrowse:SetEditCell(.T., {|| .T. }) 
        
        oBrowse:AddColumn({"Produto"     , {|| (cAliasTab)->XXB1COD }, "C", pesqPict("SB1","B1_COD")     , 1, TamSX3("B1_COD")[1]   ,     , .F. , {|| .T. }, .F.,, "XXB1COD"  ,, .F., .T., , "XB1COD"})
        oBrowse:AddColumn({"Descricão"   , {|| (cAliasTab)->XXB1DESC}, "C", pesqPict("SB1","B1_DESC")    , 1, TamSX3("B1_DESC")[1]  ,     , .F. , {|| .T. }, .F.,, "XXB1DESC" ,, .F., .T., , "XB1DESC"})
        oBrowse:AddColumn({"Frequência"  , {|| (cAliasTab)->XXFREQ  }, "N", "@E 999,999,999,999"         , 2, 3,                          , .F. , {|| .T. }, .F.,, "XXFREQ"   ,, .F., .T., , "XFREQ"})
        oBrowse:AddColumn({"Média"       , {|| (cAliasTab)->XXMEDIA }, "N", "@E 999,999,999,999"         , 2, 3,                          , .F. , {|| .T. }, .F.,, "XXMEDIA"  ,, .F., .T., , "XMEDIA"})
        oBrowse:AddColumn({"Máximo"      , {|| (cAliasTab)->XXMAX   }, "N", "@E 999,999,999,999"         , 2, 3,                          , .F. , {|| .T. }, .F.,, "XXMAX"    ,, .F., .T., , "XMAX"})
        oBrowse:AddColumn({"Qtd. Caixas" , {|| (cAliasTab)->XXQTDCX }, "N", pesqPict("ZJB","ZJB_UNSVEN") , 2, TamSX3("ZJB_UNSVEN")[1] , TamSX3("ZJB_UNSVEN")[2]  , .T. , {|| Positivo() }, .F.,, "XXQTDCX"  ,, .F., .T., , "XZJBUNSVEN"})
        oBrowse:AddColumn({"Preço"       , {|| (cAliasTab)->XXPRCUT }, "N", pesqPict("ZJB","ZJB_PRCVEN") , 2, TamSX3("ZJB_PRCVEN")[1] , TamSX3("ZJB_PRCVEN")[2]  , .T. , {|| lRet := Positivo() .And. U_ADVE118A(XXPRCUT, (cAliasTab)->XXB1COD, U_ADVE1188((cAliasTab)->XXB1COD)), Iif(!lRet, XXPRCUT := 0, Nil), lRet }, .F.,, "XXPRCUT"  ,, .F., .T., , "XZJBPRCVEN"})

        oBrowse:Activate()

    oModal:Activate()

    oTempTable:Delete()

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} nomeStaticFunction
    Retorna os códigos de produtos que já estão na grid. 
    @type  Static Function
    @author Everson
    @since 17/05/2023
    @version 01
/*/
Static Function obtProdGrid()

    //Variáveis.
    Local aArea      := GetArea()
    Local cCodigo    := ""
    Local cProdutos  := ""
    Local oModel     := FWModelActive()
    Local oGrid      := oModel:GetModel("MD_GRID")
    Local aSaveLines := FWSaveRows()
    Local nLinhas    := oGrid:Length() 
    Local nAux       := 1

    For nAux := 1 To nLinhas

        oGrid:GoLine(nAux) 
        
        If oGrid:IsDeleted()
            Loop

        EndIf

        cCodigo := Alltrim(cValToChar(oGrid:GetValue("ZJB_PRODUT")))

        If Empty(cCodigo)
            Loop

        EndIf

        cProdutos += "'"  + cCodigo + "',"

    Next nAux

    If ! Empty(cProdutos)
        cProdutos := Substr(cProdutos, 1, Len(cProdutos)-1)

    EndIf

    FWRestRows(aSaveLines)

    RestArea(aArea)
    
Return cProdutos
/*/{Protheus.doc} carHitGrd
    Carrega a grid com os produtos selecionados no histórico de compras.
    @type  Static Function
    @author Everson
    @since 02/05/2023
    @version 01
/*/
Static Function carHitGrd(oView, cAliasTab)

    //Variáveis.
    Local aArea  := GetArea()
    Local lRet   := .F.
    Local oModel := oView:GetModel()
    Local cNum   := oModel:GetValue("MD_MASTER", "ZJA_NUM")
    Local oGrid  := oView:GetModel("MD_GRID")
    Local nAux   := oGrid:Length() 

    // U_ADEST732()

    oView:refresh()

    (cAliasTab)->(DbGoTop())

    While ! (cAliasTab)->(Eof())

        If (cAliasTab)->XXQTDCX > 0 .And. (cAliasTab)->XXPRCUT > 0

            If nAux > 1 .Or. (nAux == 1 .And. ! Empty(oGrid:GetValue("ZJB_PRODUT")))
                oGrid:addLine()

            EndIf

            oGrid:SetValue("ZJB_FILIAL" , FWxFilial("ZJB") )
            oGrid:SetValue("ZJB_NUM"    , cNum )
            oGrid:SetValue("ZJB_PRODUT" , (cAliasTab)->XXB1COD )
            oGrid:SetValue("ZJB_DESCRI" , (cAliasTab)->XXB1DESC)
            oGrid:SetValue("ZJB_UNSVEN" , (cAliasTab)->XXQTDCX )
            oGrid:SetValue("ZJB_PRCVEN" , (cAliasTab)->XXPRCUT )

            nAux++

            lRet := .T.

        EndIf

        (cAliasTab)->(DbSkip())

    End

    If lRet
        oView:GetViewObj("VW_GRID")[3]:GotFocus()
        oGrid:GoLine(1)
        oView:refresh()

    Else
        Help(Nil, Nil, "Função carHitGrd(ADVEN118P)", Nil, "Não há registro a ser carregado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} User Function ADVE118Y
    Verifica se a condição é de pagamento antecipado pagamento atencipado.
    @type  Function
    @author Everson
    @since 04/05/2023
    @version 01
/*/
User Function ADVE118Y(cCdPg)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := Alltrim(cValToChar(Posicione("SE4", 1, FWxFilial("SE4") + cCdPg, "E4_CTRADT"))) == "1"

    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} User Function ADVE118S
    Valida tipo de frete.
    @type  Function
    @author Everson
    @since 05/05/2023
    @version 01
/*/
User Function ADVE118S(cTpFrt) // U_ADVE118S(M->ZJA_TPFRET)

    //Variáveis.
    Local aArea  := GetArea()
    Local oModel := FWModelActive()
    Local lRet   := fValidGrid(oModel:GetModel("MD_GRID"))

    //Recalcula indicadores.
    If lRet
        recInd()
        
    EndIf

    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} recInd
    Recalcula indicadores.
    @type  Static Function
    @author Everson
    @since 05/05/2023
    @version 01
/*/
Static Function recInd()

    //Variáveis.
    Local aArea      := GetArea()
    Local oModel     := FWModelActive()
    Local oGrid      := oModel:GetModel("MD_GRID")
    Local aSaveLines := FWSaveRows()
    Local nLinhas    := oGrid:Length() 
    Local nAux       := 1

    For nAux := 1 To nLinhas

        oGrid:GoLine(nAux) 
        
        If oGrid:IsDeleted()
            Loop

        EndIf

        nIt := U_ADVE118I("IT") 
        nEm := U_ADVE118I("EM") 
        nIp := U_ADVE118I("IP")

        oGrid:SetValue("ZJB_IT", nIt)
        oGrid:SetValue("ZJB_EM", nEm)
        oGrid:SetValue("ZJB_IP", nIp)

    Next nAux

    calcIt(oModel)
	calcEM(oModel)
	calcIP(oModel)

    FWRestRows(aSaveLines)

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} User Function ADVE118O
    Processo de aprovação.
    @type  Function
    @author Everson
    @since 05/05/2023
    @version 01
/*/
User Function ADVE118O(oModel, cCodCli, cLojCli, cRede, cVendedor, dData, nIT, nEM, nIP)

    //Variáveis.
    Local aArea     := GetArea()
    Local cMsgAprv  := ""
    Local aSuper    := {}
    Local lPenApr   := .F.
    Local aDiret    := {}
    Local aAprov    := U_ADVE118F(nIT, nEM, nIP, @cMsgAprv)
    Local cVendRed  := ""

    If aAprov[1] //Mínimo permitido.
        Help(Nil, Nil, "Função ADVE118O(ADVEN118P)", Nil, cMsgAprv, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    oModel:ClearField("MD_MASTER", "ZJA_DTASUP")
    oModel:ClearField("MD_MASTER", "ZJA_HRASUP")
    oModel:ClearField("MD_MASTER", "ZJA_DTADIR")
    oModel:ClearField("MD_MASTER", "ZJA_HRADIR")

    //Varejo.
    If Empty(cRede)

        If aAprov[2] //Pendente aprovação supervisor.

            aSuper := obtDSup(cVendedor)

            If Empty(aSuper[1])
                Help(Nil, Nil, "Função ADVE118O(ADVEN118P)", Nil, "Não há supervisor vinculado ao vendedor " + cVendedor + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                RestArea(aArea)
                Return .F.

            EndIf

            lPenApr := .T.
            oModel:SetValue("MD_MASTER", "ZJA_PARSUP" , "1")        //Pendente supervisor.
            oModel:SetValue("MD_MASTER", "ZJA_APRSUP" , aSuper[1])  //Código do supervisor.
            oModel:SetValue("MD_MASTER", "ZJA_NMSUPE" , aSuper[2])  //Nome do supervisor.
            oModel:SetValue("MD_MASTER", "ZJA_USRSUP" , aSuper[3])  //Usuário do supervisor.

        Else
            oModel:SetValue("MD_MASTER", "ZJA_PARSUP" , "2") //Não precisa de aprovação.
            oModel:ClearField("MD_MASTER", "ZJA_APRSUP")     //Código do supervisor.
            oModel:ClearField("MD_MASTER", "ZJA_NMSUPE")     //Nome do supervisor.
            oModel:ClearField("MD_MASTER", "ZJA_USRSUP")     //Usuário do supervisor.

        EndIf

        If aAprov[3] //Pendente aprovação diretor.
            
            aDiret := obtDDrt(cVendedor)

            If Empty(aDiret[1])
                Help(Nil, Nil, "Função ADVE118O(ADVEN118P)", Nil, "Não há diretor vinculado ao vendedor " + cVendedor + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                RestArea(aArea)
                Return .F.

            EndIf

            lPenApr := .T.
            oModel:SetValue("MD_MASTER", "ZJA_PARDIR" , "1")        //Pendente diretor.
            oModel:SetValue("MD_MASTER", "ZJA_APRDIR" , aDiret[1])  //Código do diretor.
            oModel:SetValue("MD_MASTER", "ZJA_NMDIRE" , aDiret[2])  //Nome do diretor.
            oModel:SetValue("MD_MASTER", "ZJA_USRDIR" , aDiret[3])  //Usuário do diretor.

        Else
            oModel:SetValue("MD_MASTER", "ZJA_PARDIR" , "2")  //Não precisa de aprovação.
            oModel:ClearField("MD_MASTER", "ZJA_APRDIR") //Código do diretor.
            oModel:ClearField("MD_MASTER", "ZJA_NMDIRE") //Nome do diretor.
            oModel:ClearField("MD_MASTER", "ZJA_USRDIR") //Nome do diretor.

        EndIf

        If lPenApr
            oModel:SetValue("MD_MASTER", "ZJA_STATUS" , "2")  //Pendente comercial.
            oModel:SetValue("MD_MASTER", "ZJA_STATPA" , "2")  //Pedido Bloquedo por Regra.

        Else
            oModel:SetValue("MD_MASTER", "ZJA_STATUS" , "1")  //Aprovado comercial.
            oModel:SetValue("MD_MASTER", "ZJA_STATPA" , "4")  //Pedido liberado.

        EndIf
        
    EndIf

    //Rede.
    If ! Empty(cRede)

        cVendRed := Posicione("SA1", 1, FWxFilial("SA1") + cRede + "00", "A1_VEND") //Obtém o vendedor da loja matriz.

        aSuper := obtDSup(cVendRed) //Obtém o supervisor da loja matriz.

        If Empty(aSuper[1])
            Help(Nil, Nil, "Função ADVE118O(ADVEN118P)", Nil, "Não há supervisor vinculado ao vendedor " + cVendRed + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        EndIf

        aDiret := obtDDrt(cVendRed)

        If Empty(aDiret[1])
            Help(Nil, Nil, "Função ADVE118O(ADVEN118P)", Nil, "Não há diretor vinculado ao vendedor " + cVendRed + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        EndIf

        oModel:SetValue("MD_MASTER", "ZJA_PARSUP" , "2")        //Sem necessidade de aprovar..
        oModel:SetValue("MD_MASTER", "ZJA_APRSUP" , aSuper[1])  //Código do supervisor.
        oModel:SetValue("MD_MASTER", "ZJA_NMSUPE" , aSuper[2])  //Nome do supervisor.
        oModel:SetValue("MD_MASTER", "ZJA_USRSUP" , aSuper[3])  //Usuário do supervisor.

        oModel:SetValue("MD_MASTER", "ZJA_PARDIR" , "2")        //Sem necessidade de aprovar.
        oModel:SetValue("MD_MASTER", "ZJA_APRDIR" , aDiret[1])  //Código do diretor.
        oModel:SetValue("MD_MASTER", "ZJA_NMDIRE" , aDiret[2])  //Nome do diretor.
        oModel:SetValue("MD_MASTER", "ZJA_USRDIR" , aDiret[3])  //Usuário do diretor.
        
        oModel:SetValue("MD_MASTER", "ZJA_STATUS" , "3")        //Pendente aprovação rede.
        oModel:SetValue("MD_MASTER", "ZJA_STATPA" , "2")        //Pedido Bloquedo por Regra.

        //Indicador de processamento de rede.
        oModel:ClearField("MD_MASTER", "ZJA_RIT") 
        oModel:ClearField("MD_MASTER", "ZJA_REM")
        oModel:ClearField("MD_MASTER", "ZJA_RIP") 
        oModel:ClearField("MD_MASTER", "ZJA_RVALOR")
        oModel:ClearField("MD_MASTER", "ZJA_RPESL") 
        oModel:ClearField("MD_MASTER", "ZJA_RVOL")
        oModel:ClearField("MD_MASTER",  "ZJA_DTPRED")
        oModel:ClearField("MD_MASTER",  "ZJA_HRPRED")

        oModel:SetValue("MD_MASTER", "ZJA_IDPRED" , cRede + "_" + DToS(dData)) //Id Processamento de rede.

    EndIf

    RestArea(aArea)
    
Return .T.
/*/{Protheus.doc} ADVE118F
    Fluxo de aprovação.
    @type  Function
    @author Everson
    @since 19/04/2023
    @version 01
/*/
User Function ADVE118F(nIT, nEM, nIP, cMsg)

    //Variáveis.
    Local lAprV := .F.
    Local lAprS := .F. //Necessita de aprovação do supervisor.
    Local lAprD := .F. //Necessita de aprovaçaõ do diretor.

    Default cMsg := ""

    If ! U_ADVE1201()
        Help(Nil, Nil, "Função ADVE118F(ADVEN118P)", Nil, "Não há parametrização de pedido ativa.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return {.T., .T., .T.}

    EndIf

    If nIT < (ZJD->ZJD_ITVEND/100)
        cMsg := "Valor de IT menor do que o mínimo permitido."
        lAprV := .T.
        
    EndIf      

    If nIP < (ZJD->ZJD_IPVEND/100)
        cMsg := "Valor de IP menor do que o mínimo permitido."
        lAprV := .T.
        
    EndIf      

    If nEM < ZJD->ZJD_EMVEND 
        cMsg := "Valor de EM menor do que o mínimo permitido."
        lAprV := .T.
        
    EndIf      

    If nIT < (ZJD->ZJD_ITSUPE/100) .Or. nIP < (ZJD->ZJD_IPSUPE/100) .Or. nEM < ZJD->ZJD_EMSUPE 
        lAprS := .T.
        
    EndIf      

    If nIT < (ZJD->ZJD_ITDIRE/100) .Or. nIP < (ZJD->ZJD_IPDIRE/100) .Or. nEM < ZJD->ZJD_EMDIRE 
        lAprD := .T.

    EndIf      

Return {lAprV, lAprS, lAprD}
/*/{Protheus.doc} User Function ADVE118
    Ponto de entrada.
    @type  Function
    @author Everson
    @since 05/05/2023
    @version 01
/*/
User Function ADVE118()

    //Variáveis.
    Local aParam    := PARAMIXB 
    Local xRet      := .T. 
    Local oObj      := "" 
    Local cIdPonto  := "" 
    Local cTpPed    := ""
    Local nOperation:= 0
    Local cNum      := ""
    Local cOperacao := ""
    Local cLog      := ""

    If aParam <> Nil
    
        oObj     := aParam[1]
        cIdPonto := aParam[2]

        If cIdPonto == "MODELCOMMITNTTS" //Fora da transação.

            nOperation  := oObj:GetOperation()

            If nOperation == MODEL_OPERATION_INSERT

                RecLock("ZJA", .F.)
                    ZJA->ZJA_ROBO := Iif(mod(Recno(), 2) == 0, "B", "A")
                ZJA->(MsUnlock())

            EndIf

        ElseIf cIdPonto == "MODELCOMMITTTS" //Dentro da transação.

            nOperation  := oObj:GetOperation()
            cNum        := oObj:GetValue("MD_MASTER", "ZJA_NUM")
            cOperacao   := Iif(nOperation == 3, "INCLUSÃO", Iif(nOperation == 4, "ALTERAÇÃO", "EXCLUSÃO"))
            cLog        := cOperacao + " " + cNum

            U_ADVE118W(cLog, cNum, "")
            
        ElseIf cIdPonto == "MODELPOS" //Validação ao clicar confirmar.

            cTpPed := oObj:GetValue("MD_MASTER", "ZJA_TPPED")

            If ! IsInCallStack("U_ADVE118R") .And. cTpPed $("4")
                xRet := U_ADVE118R(oObj, cTpPed, oObj:GetOperation())

            EndIf
        
        EndIf
    
    EndIf

Return xRet
/*/{Protheus.doc} User Function ADVE118R
    Gera pedido de remessa.
    @type  Function
    @author Everson
    @since 05/05/2023
    @version 01
/*/
User Function ADVE118R(oObj, cTpPed, nOperation)

    //Variáveis.
    Local aArea      := GetArea()
    Local lRet       := .F.
    Local oModel     := Nil
    Local aError     := {}
    Local cMsgError  := ""
    Local cNum       := oObj:GetValue("MD_MASTER", "ZJA_NUMREM")
    Local cLocExp    := oObj:GetValue("MD_MASTER", "ZJA_LOCEXP")

    If nOperation == MODEL_OPERATION_UPDATE .Or. nOperation == MODEL_OPERATION_DELETE

        If ! U_ADVE1182(cNum, cLocExp)
            Help(Nil, Nil, "Função ADVE118R(ADVEN118P)", Nil, "Pedido de remessa não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        EndIf

    EndIf

    oModel := FWLoadModel("ADVEN118P")
    oModel:SetOperation(nOperation)
    oModel:Activate()

    If nOperation <> MODEL_OPERATION_DELETE
    
        carCabec(@oObj, @oModel, cNum, nOperation, cTpPed)

        carItens(@oObj, @oModel, cNum, nOperation)

    EndIf

    If oModel:VldData()
        oModel:CommitData()
        lRet := .T.

    Else
        lRet := .F.
        aError := oModel:GetErrorMessage()
        cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

    EndIf

    oModel:DeActivate()
    oModel:Destroy()
    oModel := Nil

    If ! Empty(cMsgError)
       Help(Nil, Nil, "Função ADVE118R(ADVEN118P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} carCabec
    Carrega cabeçalho do model.
    @type  Static Function
    @author Everson
    @since 05/05/2023
    @version 01
/*/
Static Function carCabec(oOrigem, oRemessa, cNum, nOperation, cTpPed)

    //Variáveis.
    Local aArea      := GetArea()
    Local aCampos    := oOrigem:GetModel("MD_MASTER"):GetStruct():GetFields()
    Local cCampo     := ""
    Local xValor     := Nil
    Local cCodCliVo  := oOrigem:GetValue("MD_MASTER", "ZJA_CLIEVO")
    Local cLojCliVo  := oOrigem:GetValue("MD_MASTER", "ZJA_LOJAVO")
    Local cNmCliVo   := oOrigem:GetValue("MD_MASTER", "ZJA_NOMEVO")
    Local cCdPg      := oOrigem:GetValue("MD_MASTER", "ZJA_CONDPA")
    Local dData      := oOrigem:GetValue("MD_MASTER", "ZJA_DTENTR")
    Local cTpFrt     := oOrigem:GetValue("MD_MASTER", "ZJA_TPFRET")

    Local cPendAS    := oOrigem:GetValue("MD_MASTER", "ZJA_PARSUP")
    Local cCodSAp    := oOrigem:GetValue("MD_MASTER", "ZJA_APRSUP")
    Local cNmSAp     := oOrigem:GetValue("MD_MASTER", "ZJA_NMSUPE")
    Local cUsSAp     := oOrigem:GetValue("MD_MASTER", "ZJA_USRSUP")
    Local dDtSAp     := oOrigem:GetValue("MD_MASTER", "ZJA_DTASUP")
    Local cHrSAp     := oOrigem:GetValue("MD_MASTER", "ZJA_HRASUP")

    Local cPendAD    := oOrigem:GetValue("MD_MASTER", "ZJA_PARDIR")
    Local cCodDAp    := oOrigem:GetValue("MD_MASTER", "ZJA_APRDIR")
    Local cNmSDp     := oOrigem:GetValue("MD_MASTER", "ZJA_NMDIRE")
    Local cUsSDp     := oOrigem:GetValue("MD_MASTER", "ZJA_USRDIR")
    Local dDtDAp     := oOrigem:GetValue("MD_MASTER", "ZJA_DTADIR")
    Local cHrDAp     := oOrigem:GetValue("MD_MASTER", "ZJA_HRADIR")
    Local cCodVend   := oOrigem:GetValue("MD_MASTER", "ZJA_CODVEN")


    Local nAux       := 1

    For nAux := 1 To Len(aCampos)

        cCampo  := aCampos[nAux, 3]
        xValor  := oOrigem:GetValue("MD_MASTER", cCampo)

        oRemessa:SetValue("MD_MASTER", cCampo, xValor)

    Next nAux

    lmpCliVO(Nil)
    
    oRemessa:SetValue("MD_MASTER", "ZJA_NUM"   , cNum)
    oRemessa:SetValue("MD_MASTER", "ZJA_CODVEN", cCodVend)

    If cTpPed == "4"
        oRemessa:SetValue("MD_MASTER", "ZJA_TPPED" , "7")
        oRemessa:SetValue("MD_MASTER", "ZJA_CLIENT", cCodCliVo)
        oRemessa:SetValue("MD_MASTER", "ZJA_LOJACL", cLojCliVo)
        oRemessa:SetValue("MD_MASTER", "ZJA_NOMECL", cNmCliVo)

    ElseIf cTpPed == "5"
        oRemessa:SetValue("MD_MASTER", "ZJA_TPPED" , "8")

    EndIf

    //Aprovação supervisor.
    oRemessa:SetValue("MD_MASTER", "ZJA_PARSUP" , cPendAS) //Pendente supervisor.
	oRemessa:SetValue("MD_MASTER", "ZJA_APRSUP" , cCodSAp) //Código do supervisor.
	oRemessa:SetValue("MD_MASTER", "ZJA_NMSUPE" , cNmSAp)  //Nome do supervisor.
	oRemessa:SetValue("MD_MASTER", "ZJA_USRSUP" , cUsSAp)  //Usuário do supervisor.
	oRemessa:SetValue("MD_MASTER", "ZJA_DTASUP" , dDtSAp)  //Data aprovação do supervisor.
	oRemessa:SetValue("MD_MASTER", "ZJA_HRASUP" , cHrSAp)  //Hora aprovação do supervisor.

    //Aprovação diretor.
    oRemessa:SetValue("MD_MASTER", "ZJA_PARDIR" , cPendAD) //Pendente diretor.
    oRemessa:SetValue("MD_MASTER", "ZJA_APRDIR" , cCodDAp) //Código do diretor.
    oRemessa:SetValue("MD_MASTER", "ZJA_NMDIRE" , cNmSDp)  //Nome do diretor.
    oRemessa:SetValue("MD_MASTER", "ZJA_USRDIR" , cUsSDp)  //Usuário do diretor.
    oRemessa:SetValue("MD_MASTER", "ZJA_DTADIR" , dDtDAp)  //Data aprovação do diretor.
    oRemessa:SetValue("MD_MASTER", "ZJA_HRADIR" , cHrDAp)  //Hora aprovação do diretor.
    
    oRemessa:ClearField("MD_MASTER", "ZJA_NUMREM")         //Número da remessa.     
    oRemessa:SetValue("MD_MASTER", "ZJA_CONDPA", cCdPg)    //Condição de pagamento. 
    oRemessa:SetValue("MD_MASTER", "ZJA_DTENTR", dData)    //Data de entrega.
    oRemessa:SetValue("MD_MASTER", "ZJA_TPFRET", cTpFrt)   //Tipo de frete.

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} carItens
    Carrega itens do model.
    @type  Static Function
    @author Everson
    @since 05/05/2023
    @version 01
/*/
Static Function carItens(oOrigem, oRemessa, cNum, nOperation)

    //Variáveis.
    Local aArea      := GetArea()
    Local aSaveLines := FWSaveRows()
    Local aCampos    := oOrigem:GetModel("MD_GRID"):GetStruct():GetFields()
    Local oGrid      := oOrigem:GetModel("MD_GRID")
    Local nLinhas    := oGrid:Length()
    Local oGrid2     := oRemessa:GetModel("MD_GRID")
    Local cCampo     := ""
    Local xValor     := Nil
    Local nAux       := 1
    Local nAux2      := 1

    For nAux := 1 To nLinhas

        oGrid:GoLine(nAux)
        oGrid2:GoLine(nAux)

        If nOperation == MODEL_OPERATION_INSERT .And. nAux > 1
            oGrid2:addLine()

        EndIf
    
        If oGrid:IsDeleted()
            oGrid2:DeleteLine()
            Loop

        EndIf

        For nAux2 := 1 To Len(aCampos)

            cCampo  := aCampos[nAux2, 3]
            xValor  := oGrid:GetValue(cCampo)

            If cCampo == "ZJB_NUM"
                oGrid2:LoadValue(cCampo, cNum)

            Else
                oGrid2:LoadValue(cCampo, xValor)

            EndIf

        Next nAux2

    Next nAux

    FWRestRows(aSaveLines)

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} User Function ADVE118E
    Gera resumo do pedido de venda.
    @type  Function
    @author Everson
    @since 08/05/2023
    @version 01
/*/
User Function ADVE118E()

    //Variáveis.
    Local aArea     := GetArea()
    Local oModal    := Nil
    // Local oScroll   := Nil
    Local oContainer:= Nil
    Local aItens    := obtItens(ZJA->ZJA_NUM, ZJA->ZJA_LOCEXP)
    Local nLimite   := 23
    Local nMSpace   := Iif(Len(aItens) - nLimite > 0, aItens - nLimite , 0) * 30
    Local nAux      := 1
    Local nLinha    := 0
    Local oFont     := TFont():New(,,-14,.T.)
    Local cEndEnt   := ""


    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())
    If SA1->(DbSeek( FWxFilial("SA1") + ZJA->ZJA_CLIENT + ZJA->ZJA_LOJACL ))
        cEndEnt := Alltrim(SA1->A1_ENDENT) + ", " + Alltrim(SA1->A1_BAIRROE) + ", " + Alltrim(SA1->A1_MUNE) + "-" + Alltrim(SA1->A1_ESTE)

    EndIf

    oModal := FWDialogModal():New() 
    oModal:SetBackground( .T. ) 
	oModal:setTitle("Resumo do Pedido de Venda")
	oModal:setSize(330 + nMSpace, 650)
    oModal:EnableFormBar(.T.)
    oModal:SetEscClose(.F.)
	oModal:createDialog()
    oModal:CreateFormBar()

        oModal:AddButton( "Ok", {|| oModal:DeActivate() }, "Confirmar", , .T., .F., .T., )

        // oScroll := TScrollArea():New(oModal:getPanelMain(), 01, 01, 330, 600)

        oContainer := TPanel():New( ,,, oModal:getPanelMain())
	    oContainer:Align := CONTROL_ALIGN_ALLCLIENT     

        TGroup():New(010, 010, 075, 640, "Pedido", oContainer,,,.T.)
            TSay():New(020, 015,{||"Número do Pedido de Venda"  },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(030, 015,{|| ZJA->ZJA_NUM                },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)

            TSay():New(020, 120,{||"Data de Entrega"            },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(030, 120,{|| DToC(ZJA->ZJA_DTENTR)       },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)

            TSay():New(020, 240,{||"Valor do Pedido"            },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(030, 240,{|| Alltrim(Transform(ZJA->ZJA_VALOR, "@E 9,999,999,999.99")) },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)

            TSay():New(020, 380,{||"Total Peso Líquido (Kg)"    },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(030, 380,{|| Alltrim(Transform(ZJA->ZJA_PESL , "@E 999,999,999,999.9"))  },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)

            TSay():New(020, 540,{||"Total Volume"               },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(030, 540,{|| Alltrim(Transform(ZJA->ZJA_VOL, "@E 999,999,999,999")) },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)

            TSay():New(040, 015,{||"Código do Cliente"  },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(050, 015,{|| ZJA->ZJA_CLIENT + " " + ZJA->ZJA_LOJACL },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)

            TSay():New(040, 120,{||"Condição de pagamento" },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(050, 120,{|| Posicione("SE4", 1 , FWxFilial("SE4") + ZJA->ZJA_CONDPA, "E4_DESCRI") },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)

            TSay():New(040, 240,{||"Nome"                    },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,085,010)
            TSay():New(050, 240,{|| Alltrim(ZJA->ZJA_NOMECL) },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,085,010)
           
            TSay():New(040, 330,{||"Endereço de entrega"     },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(050, 330,{|| cEndEnt                  },oContainer,,oFont,,,,.T.,CLR_BLACK,CLR_WHITE,300,020)

        TGroup():New(080, 010, 280 + nMSpace, 640, "Detalhes", oContainer,,,.T.)
            TSay():New(090, 015,{||"Código do Produto" },oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(090, 080,{||"Descrição"         },oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(090, 350,{||"Caixas"            },oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(090, 430,{||"Preço Unitário"    },oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
            TSay():New(090, 540,{||"Preço"             },oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)

            nLinha := 090 + 10

            For nAux := 1 To Len(aItens)

                cProduto := Alltrim(aItens[nAux][1])
                cDesc    := Alltrim(aItens[nAux][2])
                nCaixas  := aItens[nAux][3]
                nVlrUnt  := aItens[nAux][4]
                nTotal   := aItens[nAux][5]

                TSay():New(nLinha, 015,{|| cProduto },oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
                TSay():New(nLinha, 080,{|| cDesc    },oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
                TSay():New(nLinha, 350,{|| Alltrim(Transform(nCaixas, pesqPict("ZJB","ZJB_UNSVEN"))) },oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
                TSay():New(nLinha, 430,{|| Alltrim(Transform(nVlrUnt, pesqPict("ZJB","ZJB_VALOR")))  },oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)
                TSay():New(nLinha, 540,{|| Alltrim(Transform(nTotal,  pesqPict("ZJB","ZJB_VALOR")))  },oContainer,,,,,,.T.,CLR_BLACK,CLR_WHITE,200,010)

                nLinha += 10

            Next

            // oScroll:SetFrame(oContainer)

    oModal:Activate()
    
    RestArea(aArea)

Return Nil
/*/{Protheus.doc} obtItens
    Retorna itens do pedido para o resumo.
    @type  Static Function
    @author Everson
    @since 08/05/2023
    @version 01
/*/
Static Function obtItens(cPedido, cLocExp)

    //Variáveis.
    Local aArea   := GetArea()
    Local aItens  := {}
    Local nVlrUnt := 0 

    DbSelectArea("ZJB")
    ZJB->(DbGoTop())
    If ! ZJB->(DbSeek( FWxFilial("ZJB") + cPedido ))
        RestArea(aArea)
        Return {}

    EndIf

    While ! ZJB->(Eof()) .And. ZJB->ZJB_FILIAL == FWxFilial("ZJB") .And. ZJB->ZJB_NUM == cPedido .And. ZJB->ZJB_LOCEXP == cLocExp

        nVlrUnt := ZJB_VALOR/ZJB_UNSVEN

        Aadd(aItens, { ZJB->ZJB_PRODUT, ZJB->ZJB_DESCRI, ZJB->ZJB_UNSVEN, nVlrUnt, ZJB->ZJB_VALOR})

        ZJB->(DbSkip())

    End

    RestArea(aArea)

Return aItens
/*/{Protheus.doc} User Function ADVE118U
    Libera pedidos EDI.
    @type  Function
    @author Everson
    @since 08/05/2023
    @version 01
/*/
User Function ADVE118U()

    //Variáveis.
    Local aArea := GetArea()

    If Empty(ZJA->ZJA_EDI) .Or. ZJA->ZJA_LIBEDI <> "2"
        RestArea(aArea)
        Return Nil

    EndIf

    If ! MsgYesNo("Deseja efetuar a liberação do pedido " + ZJA->ZJA_NUM + "?", "Função ADVE118U(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    RecLock("ZJA", .F.)
        ZJA->ZJA_LIBEDI  := "1"
        ZJA->ZJA_DTELIB  := Date()
        ZJA->ZJA_HRELIB  := Time()
        ZJA->ZJA_USELIB  := cUserName
    ZJA->(MsUnlock())

    MsgInfo("Pedido liberado", "Função ADVE118U(ADVEN118P)")

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADVE118X
    Alteração de data de entrega em massa.
    @type  Function
    @author Everson
    @since 10/05/2023
    @version 01
/*/
User Function ADVE118X()

    //Variáveis.
    Local aArea      := GetArea()
    Local cLocExp    := ""
    Local dDtAtual   := Nil 
    Local cPedDe     := ""
    Local cPedAte    := ""
    Local dDtNova    := Nil
    Local cQuery     := ""
    Local cFiltro    := ""
    Local nAux       := 1
    Local cAlias     := ""
    Local oPedido    := Nil
    Local aError     := {}
    Local cMsgError  := ""

    If ! Pergunte("ADVEN118P1", .T.)
        RestArea(aArea)
        Return Nil

    EndIf

    cLocExp  := cLocExp := Iif(MV_PAR01 == 1, "0102", Iif(MV_PAR01 == 2, "010B", ""))
    dDtAtual := MV_PAR02 
    cPedDe   := MV_PAR03
    cPedAte  := MV_PAR04
    dDtNova  := MV_PAR05

    If Empty(cLocExp) .Or. Empty(dDtAtual) .Or. Empty(cPedDe) .Or. Empty(cPedAte) .Or. Empty(dDtNova)
        MsgInfo("É necessário preencher todos os parâmetros da pergunta.", "Função ADVE118X(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    cQuery := "" 
    cQuery += " SELECT  " 
        cQuery += " ZJA_NUM " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA " 
    cQuery += " WHERE " 
        cQuery += " ZJA_FILIAL = '" + FWxFilial("ZJA") + "' " 
        cQuery += " AND ZJA_LOCEXP = '" + cLocExp + "' " 
        cQuery += " AND ZJA_DTENTR = '" + DToS(dDtAtual) + "' " 
        cQuery += " AND ZJA_NUM BETWEEN '" + cPedDe + "' AND '" + cPedAte + "' " 
        
        If ! lAdm .And. ! lBack .And. ! lDiret
                        
            If Len(aCodigos) > 0
                
                For nAux := 1 To Len(aCodigos)

                    cFiltro += "'" + aCodigos[nAux] + "',"

                Next nAux

                cFiltro := Substr(cFiltro, 1, Len(cFiltro) - 1)

            EndIf

            cQuery += " AND ZJA_CODVEN IN (" + cFiltro + ") " 

        EndIf
        
        cQuery += " AND ZJA_STATUS IN ('1', '2', '3') " 
        cQuery += " AND ZJA_TPPED NOT IN ('7', '8') " 
        cQuery += " AND ZJA_PLACA = '' " 
        cQuery += " AND ZJA.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY " 
    cQuery += " ZJA_NUM " 

    cAlias := GetNextAlias()
    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    If (cAlias)->(Eof())
        (cAlias)->(DbCloseArea())
        MsgInfo("Não há dados para os parâmetros informados.", "Função ADVE118X(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    While ! (cAlias)->(Eof())

        cPedido := (cAlias)->ZJA_NUM

        If ! U_ADVE1182(cPedido, cLocExp)
            cMsgError += cPedido + " pedido não localizado " + xPula
            (cAlias)->(DbSkip())
            Loop

        EndIf

        oPedido := FWLoadModel("ADVEN118P")
        oPedido:SetOperation(MODEL_OPERATION_UPDATE)
        oPedido:Activate()

            oPedido:SetValue("MD_MASTER", "ZJA_DTENTR", dDtNova)

            If oPedido:VldData()
                oPedido:CommitData()

            Else
                aError := oPedido:GetErrorMessage()
                cMsgError += cPedido + " " + Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE])) + xPula

            EndIf

        oPedido:DeActivate()
        oPedido:Destroy()
        oPedido := Nil

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    If ! Empty(cMsgError)
        cMsgError := "Os pedidos abaixo apresentaram erro: " + xPula + cMsgError
        Help(Nil, Nil, "Função ADVE118X(ADVEN118P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    Else
        MsgInfo("Processo finalizado.", "Função ADVE118X(ADVEN118P)")

    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} Function retPedRed
    Retorna o processamento dos pedidos de rede já processados.
    @type  Static
    @author Everson
    @since 12/05/2023
    @version 01
/*/
Static Function retPedRed(cIdProcR, cPedOrg)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .T.
    Local cCodCli   := ""
    Local cLojCli   := ""
    Local cRede     := ""
    Local cVendedor := ""
    Local dData     := Nil
    Local nIT       := 0
    Local nEM       := 0
    Local nIP       := 0
    Local oPedido   := Nil
    Local cMsgError := ""
    Local aError    := {}
    Local cPedido   := ""
    Local cLocExp   := ""
    Local cQuery    := ""
    Local cAlias    := ""

    //Localiza os registros com o mesmo id de processamento de rede.
    If ! U_ADVE118Z(cIdProcR, "")
        RestArea(aArea)
        Return .T.

    EndIf
    
    cQuery := " SELECT * FROM " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA WHERE ZJA_FILIAL = '" + FWxFilial("ZJA") + "' AND ZJA_IDPRED = '" + cIdProcR + "' AND ZJA_NUM <> '" + cPedOrg + "' AND ZJA_DTPRED <> '' AND ZJA_TPPED NOT IN ('7', '8') AND ZJA_STATUS IN ('1','3','4') AND ZJA.D_E_L_E_T_ = '' ORDER BY ZJA_NUM "
    cAlias := GetNextAlias()
    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    Begin Transaction

        While ! (cAlias)->(Eof())

            cPedido := (cAlias)->ZJA_NUM
            cLocExp := (cAlias)->ZJA_LOCEXP

            If cPedOrg == cPedido
                (cAlias)->(DbSkip())
                Loop

            EndIf

            //Posiciona no pedido de compra.
            If ! U_ADVE1182(cPedido, cLocExp)
                (cAlias)->(DbSkip())
                Loop

            EndIf

            //Verifica se o pedido já possui a informação de processamento de rede e se o status do pedido permite atualização.
            If Empty((cAlias)->ZJA_DTPRED) .Or. ! ((cAlias)->ZJA_STATUS $cStatUpt)
                (cAlias)->(DbSkip())
                Loop

            EndIf

            If (cAlias)->ZJA_TPPED == "7" .Or. (cAlias)->ZJA_TPPED == "8" //remessas.
                (cAlias)->(DbSkip())
                Loop

            EndIf

            cCodCli   := (cAlias)->ZJA_CLIENT
            cLojCli   := (cAlias)->ZJA_LOJACL
            cRede     := (cAlias)->ZJA_CODRED
            cVendedor := (cAlias)->ZJA_CODVEN
            dData     := SToD((cAlias)->ZJA_DTENTR)
            nIT       := (cAlias)->ZJA_IT
            nEM       := (cAlias)->ZJA_EM
            nIP       := (cAlias)->ZJA_IP

            oPedido := FWLoadModel("ADVEN118P")
            oPedido:SetOperation(MODEL_OPERATION_UPDATE)
            oPedido:Activate()

                lRet := U_ADVE118O(oPedido, cCodCli, cLojCli, cRede, cVendedor, dData, nIT, nEM, nIP)

                If ! lRet
                    DisarmTransaction()
                    Break

                EndIf

                If oPedido:VldData()
                    oPedido:CommitData()

                Else
                    lRet := .F.
                    aError := oPedido:GetErrorMessage()
                    cMsgError += cRede + " " + cPedido + " " + Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE])) + xPula
                    DisarmTransaction()
                    Break

                EndIf

            oPedido:DeActivate()
            oPedido:Destroy()
            oPedido := Nil

            (cAlias)->(DbSkip())

        End

    End Transaction

    (cAlias)->(DbCloseArea())

    If ! Empty(cMsgError)
        Help(Nil, Nil, "Função retPedRed(ADVEN118P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} User Function ADVE118W
    Log tabela ZBE.
    @type  Function
    @author Everson
    @since 15/05/2023
    @version 01
/*/
User Function ADVE118W(cLog, cParam, cMemo)

    //Variáveis.
    Local aArea := GetArea()

    Default cMsg   := ""
    Default cParam := ""
    Default cMemo  := ""

    RecLock("ZBE", .T.)
		Replace ZBE_FILIAL 	With FWxFilial("ZBE")
		Replace ZBE_DATA 	With Date()
		Replace ZBE_HORA 	With Time()
		Replace ZBE_USUARI	With Upper(Alltrim(cUserName))
		Replace ZBE_LOG	    With cLog
		Replace ZBE_PARAME  With cParam
		Replace ZBE_MODULO	With "COMERCIAL"
		Replace ZBE_ROTINA	With "ADVEN118P"
    ZBE->(MsUnlock()) 

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} User Function ADV1180A
    Altera status no pedido de venda. (faturamento)
    @type  Function
    @author Everson
    @since 15/05/2023
    @version 01
/*/
User Function ADV1180A(cPedido, cNota, cSerie, lFat)

	//Variáveis.
	Local aArea    := GetArea()
	Local cLocExp  := cEmpAnt+cFilAnt
    Local cStatusA := "5"
    Local cStatus  := "6"

    Default lFat  := .T. // .T. = Geração de NF, .F. = Estorno de NF.

	If ! U_ADVE1182(cPedido, cLocExp)
		RestArea(aArea)
		Return Nil

	EndIf

    If ! lFat
        cStatusA := "2"
        cStatus  := Iif(Empty(ZJA->ZJA_CODRED), "2", "3")

    EndIf

	RecLock("ZJA", .F.)
		ZJA->ZJA_STATPA := cStatusA
		ZJA->ZJA_STATUS := cStatus
		ZJA->ZJA_NOTA   := cNota
		ZJA->ZJA_SERIE  := cSerie
        ZJA->ZJA_INTSC5 := "1"
	ZJA->(MsUnlock())

	RestArea(aArea)
	
Return Nil
/*/{Protheus.doc} User Function ADV1180B
    Vincula placa ao pedido de venda.
    @type  Function
    @author Everson
    @since 15/05/2023
    @version 01
/*/
User Function ADV1180B(cPedido, cPlaca)

	//Variáveis.
	Local aArea    := GetArea()
	Local cLocExp  := cEmpAnt+cFilAnt

	If ! U_ADVE1182(cPedido, cLocExp)
		RestArea(aArea)
		Return Nil

	EndIf

	RecLock("ZJA", .F.)
		ZJA->ZJA_PLACA  := cPlaca
        ZJA->ZJA_INTSC5 := "1"
	ZJA->(MsUnlock())

	RestArea(aArea)
	
Return Nil
/*/{Protheus.doc} User Function ADV1180C
    Preço CIF sem contrato.
    @type  Function
    @author Everson
    @since 19/05/2023
    @version 01
/*/
User Function ADV1180C(nVlrNg) // U_ADV1180C(M->ZJB_PRCVEN)

    //Variáveis.
    Local aArea     := GetArea()
    Local oModel    := FWModelActive()
    Local oGrid     := oModel:GetModel("MD_GRID")
    Local cCodCli   := oModel:GetValue("MD_MASTER", "ZJA_CLIENT")
    Local cLojCli   := oModel:GetValue("MD_MASTER", "ZJA_LOJACL")
    Local cProduto  := oGrid:GetValue("ZJB_PRODUT")
    Local nVlr      := 0
    Local nDesconto := 0

    If  nVlrNg <= 0 .Or. Empty(cProduto) .Or. Empty(cCodCli) .Or. Empty(cLojCli)
        RestArea(aArea)
        Return 0

    EndIf
    
    nDesconto := obtDesc(cCodCli, cLojCli, cProduto)/100

    If nDesconto <= 0
        RestArea(aArea)
        Return nVlrNg

    EndIf
    
    nVlr := Round(nVlrNg * (1-nDesconto),2)

    RestArea(aArea)
    
Return nVlr
/*/{Protheus.doc} User Function ADV1180D
    Inicializador de dos campos de pedido/imte de compra do cliente.
    @type  Function
    @author Everson
    @since 22/05/2023
    @version 01
/*/
User Function ADV1180D(cCmp) // U_ADV1180D("ZJA_NUMPCO") U_ADV1180D("ZJA_ITEMPC")

    //Variáveis.
    Local aArea  := GetArea()
    Local cRet   := ""
    Local oModel := FWModelActive()

    If ValType(oModel) <> "O"
        RestArea(aArea)
        Return Space(TamSX3(cCmp)[1])

    EndIf

    cRet := oModel:GetModel("MD_MASTER"):GetValue(cCmp)

    RestArea(aArea)

Return cRet
/*/{Protheus.doc} User Function ADV1180E
    Posição do cliente.
    @type  Function
    @author Everson
    @since 22/05/2023
    @version 01
/*/
User Function ADV1180E(oView)

    //Variáveis.
    Local aArea    := GetArea()
    Local oModel   := oView:GetModel("MD_MASTER")
    Local cCodCli  := oModel:GetValue("ZJA_CLIENT")
    Local cLoja    := oModel:GetValue("ZJA_LOJACL")

    If Empty(cCodCli) .Or. Empty(cLoja)
        MsgInfo("Necessário informar o código e loja do cliente.", "Função ADV1180E(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())
    If ! SA1->(DbSeek( FWxFilial("SA1") + cCodCli + cLoja ))
        MsgInfo("Cliente " + cCodCli + "/" + cLoja + " não localizado.", "Função ADV1180E(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    If Alltrim(GETMV("MV_#REFAZ")) == '.T.'  
        MsAguarde({|| U_ADFIN035P(cCodCli) }, "Aguarde", "Processando refaz cliente...")
    
    EndIf

    aRotina	:= {{"Pesquisar", "AxPesqui"  , 0 , 1},; //"Pesquisar"
                {"Visualizar", "AxVisual" , 0 , 2},; //"Visualizar"
                {"Consultar", "FC010CON"  , 0 , 2},; //"Consultar"
                {"Impressao", "FC010IMP"  , 0 , 4}}  //"Impressao"

    If ! Pergunte("FIC010",.T.)
        RestArea(aArea)
        Return Nil

    EndIf

    Fc010con("SA1", SA1->(Recno()), 2)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADV1180F
    Consulta específica para cliente.
    @type  Function
    @author Everson
    @since 05/04/2023
    @version 01
/*/
User Function ADV1180F() // U_ADV1180F()

    //Variáveis.
    Local oModal, oContainer, oSearchB, oGrid, oFiltro, oLbx
    Local aCpos     := {}
    Local aRet      := {}
    Local cQuery    := ""
    Local cAlias    := ""
    Local lRet      := .F.
    Local nAux      := 1
    Local cCarteiras:= ""
    Local cFiltro   := Space(200)
    Local aBackUp   := {}

    cAlias := GetNextAlias()

    cQuery += " SELECT  " 
        cQuery += " * " 
    cQuery += " FROM ( " 
        cQuery += " SELECT " 
            cQuery += " A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_CGC, A1_END, A1_REDE, A1_VEND, A1_XVEND2," 
            cQuery += " A1_COD + A1_LOJA + A1_NOME + A1_NREDUZ + A1_CGC + A1_END + A1_REDE + A1_VEND AS FILTRO " 
        cQuery += " FROM " 
            cQuery += " " + RetSqlName("SA1") + " (NOLOCK) AS SA1 " 
        cQuery += " WHERE " 
            cQuery += " A1_FILIAL = '" + FWxFilial("SA1") + "' " 

            If ! lAdm .And. ! lBack .And. ! lDiret

                If Len(aCodigos) > 0
                    
                    For nAux := 1 To Len(aCodigos)

                        cCarteiras += "'" + aCodigos[nAux] + "',"

                    Next nAux

                    cCarteiras := Substr(cCarteiras, 1, Len(cCarteiras) - 1)
                    
                    cQuery += " AND ( A1_VEND IN (" + cCarteiras + ") OR A1_XVEND2 IN (" + cCarteiras + ") ) "

                EndIf

            EndIf

            cQuery += " AND A1_MSBLQL = '2' " 
            cQuery += " AND SA1.D_E_L_E_T_ = '' " 
    cQuery += " )AS FONTE " 
    cQuery += " ORDER BY FONTE.A1_REDE, FONTE.A1_COD, FONTE.A1_LOJA " 

    cQuery := ChangeQuery(cQuery)

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)

    While (cAlias)->(!Eof())

        Aadd(aCpos,{(cAlias)->(A1_COD), (cAlias)->(A1_LOJA), (cAlias)->(A1_NOME), (cAlias)->(A1_NREDUZ), (cAlias)->(A1_CGC), (cAlias)->(A1_END), (cAlias)->(A1_VEND), (cAlias)->(A1_XVEND2), (cAlias)->(A1_REDE), (cAlias)->(FILTRO)})

        (cAlias)->(dbSkip())

    End

    (cAlias)->(DbCloseArea())

    If Len(aCpos) <= 0
        MsgInfo("Não há dados disponíveis.", "Função ADV1180F(ADVEN118P)")
        Return .F.

    EndIf

    aBackUp := aClone(aCpos)

    oModal := FWDialogModal():New() 
    oModal:SetBackground( .T. ) 
	oModal:setTitle("Clientes")
	oModal:setSize( 300 , 600 )
    oModal:EnableFormBar( .T. )
    oModal:SetEscClose(.F.)
	oModal:createDialog()
    oModal:CreateFormBar()

        oContainer := TPanel():New( ,,, oModal:getPanelMain())
        oContainer:Align := CONTROL_ALIGN_ALLCLIENT

            oSearchB := TPanel():New(001, 010, , oContainer,,.T.,,,, 580, 030)
            oGrid    := TPanel():New(025, 010, , oContainer,,.T.,,,, 580, 220)

            oFiltro  := TGet():New(001, 001,{|u|If(PCount() == 0, cFiltro, cFiltro := u)}, oSearchB, 580, 010, "@!",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cFiltro",,,,.T.,,,"Filtro",1)
            oFiltro:bGetKey := {|self, cText, nKey| filtResult(oModal, oLbx, @lRet, aRet, cText, @aCpos, @aBackUp)}
            
            oLbx := FwBrowse():New()
            oLbx:SetOwner(oGrid)
            oLbx:SetDataArray()
            oLbx:SetArray(aCpos)
            oLbx:DisableConfig()
            oLbx:DisableReport()
            oLbx:bLDblClick := {|| lRet := .T., aRet := {oLbx:oData:aArray[oLbx:nAt,1], oLbx:oData:aArray[oLbx:nAt,2]},  oModal:DeActivate()}

            oLbx:addColumn({"Código"    , {||aCpos[oLbx:nAt,01]}, "C", "", 2, 006,, .T. , , .F.,, "aCpos[oLbx:nAt,01]",, .F., .T., , "ID01" })
            oLbx:addColumn({"Loja"      , {||aCpos[oLbx:nAt,02]}, "C", "", 1, 002,, .T. , , .F.,, "aCpos[oLbx:nAt,02]",, .F., .T., , "ID02" })
            oLbx:addColumn({"Nome"      , {||aCpos[oLbx:nAt,03]}, "C", "", 1, 020,, .T. , , .F.,, "aCpos[oLbx:nAt,03]",, .F., .T., , "ID03" })
            oLbx:addColumn({"Nm Reduz"  , {||aCpos[oLbx:nAt,04]}, "C", "", 1, 020,, .T. , , .F.,, "aCpos[oLbx:nAt,04]",, .F., .T., , "ID04" })
            oLbx:addColumn({"CNPJ"      , {||aCpos[oLbx:nAt,05]}, "C", "", 2, 014,, .T. , , .F.,, "aCpos[oLbx:nAt,05]",, .F., .T., , "ID05" })
            oLbx:addColumn({"Endereço"  , {||aCpos[oLbx:nAt,06]}, "C", "", 1, 030,, .T. , , .F.,, "aCpos[oLbx:nAt,06]",, .F., .T., , "ID06" })
            oLbx:addColumn({"Vendedor"  , {||aCpos[oLbx:nAt,07]}, "C", "", 1, 006,, .T. , , .F.,, "aCpos[oLbx:nAt,07]",, .F., .T., , "ID07" })
            oLbx:addColumn({"Vendedor2" , {||aCpos[oLbx:nAt,08]}, "C", "", 1, 006,, .T. , , .F.,, "aCpos[oLbx:nAt,08]",, .F., .T., , "ID08" })
            oLbx:addColumn({"Rede"      , {||aCpos[oLbx:nAt,09]}, "C", "", 1, 006,, .T. , , .F.,, "aCpos[oLbx:nAt,09]",, .F., .T., , "ID09" })
            
            oLbx:Activate()

    oModal:Activate()

    FreeObj(oModal)
    oModal := Nil
    FreeObj(oContainer)
    oContainer := Nil
    FreeObj(oFiltro)
    oFiltro := Nil
    FreeObj(oLbx)
    oLbx := Nil

    If Len(aRet) > 0 .And. lRet
        
        If Empty(aRet[1])
            lRet := .F.
        
        Else
            DbSelectArea("SA1")
            SA1->(dbSetOrder(1))
            SA1->(DbGoTop())
            SA1->(dbSeek(xFilial("SA1") + aRet[1] + aRet[2]))

        EndIf

    EndIf

Return lRet
/*/{Protheus.doc} filtResult
    Filtra resultados.
    @type  Static Function
    @author Everson
    @since 22/05/2023
    @version 01
/*/
Static Function filtResult(oModal, oLbx, lRet, aRet, cTexto, aCpos, aBackUp)

    //Variáveis.
    Local nAux      := 1
    Local nAux2     := 1
    Local aTextos   := {}
    Local cTxtBsc   := "" 
    Local lAdiciona := .F. 
    Local nLimBusca := 2

    cTexto := Alltrim(cValToChar(cTexto))

    If ! Empty(cTexto) .And. Len(cTexto) < nLimBusca
        Return Nil

    EndIf

    aCpos := {}

    If Empty(cTexto)

        For nAux := 1 To Len(aBackUp)

            Aadd(aCpos,{ aBackUp[nAux][1], aBackUp[nAux][2], aBackUp[nAux][3], aBackUp[nAux][4], aBackUp[nAux][5], aBackUp[nAux][6], aBackUp[nAux][7], aBackUp[nAux][8], aBackUp[nAux][9], aBackUp[nAux][10]})

        Next nAux   

    Else

        aTextos := Separa(cTexto, " ", .F.)

        For nAux := 1 To Len(aBackUp)

            lAdiciona := .F.

            For nAux2 := 1 To Len(aTextos)

                cTxtBsc := Alltrim(cValToChar(aTextos[nAux2]))

                If Empty(cTxtBsc) .Or. Len(cTxtBsc) < nLimBusca
                    Loop

                EndIf

                lAdiciona := Upper(Alltrim(cValToChar(cTxtBsc))) $Upper(Alltrim(cValToChar(aBackUp[nAux][10])))

                If ! lAdiciona
                    Exit

                EndIf

            Next nAux2

            If ! lAdiciona
                lAdiciona := Upper(Alltrim(cValToChar(cTexto))) $Upper(Alltrim(cValToChar(aBackUp[nAux][10])))

            EndIf

            If lAdiciona
                Aadd(aCpos,{ aBackUp[nAux][1], aBackUp[nAux][2], aBackUp[nAux][3], aBackUp[nAux][4], aBackUp[nAux][5], aBackUp[nAux][6], aBackUp[nAux][7], aBackUp[nAux][8], aBackUp[nAux][9], aBackUp[nAux][10]})

            EndIf

        Next nAux   

    EndIf

    If Len(aCpos) <= 0
        Aadd(aCpos, {"", "", "", "", "", "", "", "", ""})

    EndIf

    oLbx:Reset()
    oLbx:SetArray(aCpos)
    oLbx:Refresh()

Return Nil
/*/{Protheus.doc} User Function ADV1180G
    Reprovação financeira pedido de venda.
    @type  Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
User Function ADV1180G(cPedido)

	//Variáveis.
	Local aArea    := GetArea()
	Local cLocExp  := cEmpAnt+cFilAnt
    Local cStatusA := "5"
    Local cStatus  := "5"

	If ! U_ADVE1182(cPedido, cLocExp)
		RestArea(aArea)
		Return Nil

	EndIf

	RecLock("ZJA", .F.)
		ZJA->ZJA_STATPA := cStatusA
		ZJA->ZJA_STATUS := cStatus
        ZJA->ZJA_INTSC5 := "1"
	ZJA->(MsUnlock())

	RestArea(aArea)
	
Return Nil
/*/{Protheus.doc} User Function ADV1180H
    Aprovação financeira do pedido de venda.
    @type  Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
User Function ADV1180H(cPedido)

	//Variáveis.
	Local aArea    := GetArea()
	Local cLocExp  := cEmpAnt+cFilAnt
    Local cStatus  := "4"

	If ! U_ADVE1182(cPedido, cLocExp)
		RestArea(aArea)
		Return Nil

	EndIf

	RecLock("ZJA", .F.)
		ZJA->ZJA_STATUS := cStatus
        ZJA->ZJA_INTSC5 := "1"
	ZJA->(MsUnlock())

	RestArea(aArea)
	
Return Nil
/*/{Protheus.doc} User Function ADV1180I
    Atualização da mensagem de pedido com pagamento antecipado.
    @type  Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
User Function ADV1180I(cPedido)

	//Variáveis.
	Local aArea    := GetArea()
	Local cLocExp  := cEmpAnt+cFilAnt

	If ! U_ADVE1182(cPedido, cLocExp)
		RestArea(aArea)
		Return Nil

	EndIf

    DbSelectArea("SC5")
    SC5->(DbSetOrder(1))
    SC5->(DbGoTop())

     If ! SC5->(DbSeek(FWxFilial("SC5") + cPedido))
		RestArea(aArea)
		Return Nil

    EndIf

    If ! SC5->C5_XWSPAGO $"S/M"
		RestArea(aArea)
		Return Nil

    EndIf

    RecLock("ZJA", .F.)
        ZJA->ZJA_MSPANT := "2"
    ZJA->(MsUnlock())

	RestArea(aArea)
	
Return Nil
/*/{Protheus.doc} User Function ADV1180J
    Eliminação de resíduo do pedido de venda.
    @type  Function
    @author Everson
    @since 24/05/2023
    @version 01
/*/
User Function ADV1180J(cPedido)

	//Variáveis.
	Local aArea    := GetArea()
	Local cLocExp  := cEmpAnt+cFilAnt

	If ! U_ADVE1182(cPedido, cLocExp)
		RestArea(aArea)
		Return Nil

	EndIf

	RecLock("ZJA", .F.)
		ZJA->ZJA_STATUS := "8"
        ZJA->ZJA_STATPA := "5"
        ZJA->ZJA_INTSC5 := "1"
	ZJA->(MsUnlock())

	RestArea(aArea)
	
Return Nil
/*/{Protheus.doc} User Function ADV1180J
    Eliminação de resíduo do pedido de venda.
    @type  Function
    @author Everson
    @since 24/05/2023
    @version 01
/*/
User Function ADV1180K(cCliente, cLoja) // U_ADV1180K(M->ZJA_CLIENT, M->ZJA_LOJACL)

    //Variáveis.
    Local aArea     := GetArea()
    Local cCodVend  := ""

    If Empty(cCliente) .Or. Empty(cLoja)
        RestArea(aArea)
        Return ""

    EndIf

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())
    If SA1->(DbSeek( FWxFilial("SA1") + cCliente + cLoja ))
        
        If lSuperv .Or. lVend
            If SA1->A1_VEND $cCarteiras
                cCodVend := SA1->A1_VEND

            Else
                cCodVend := SA1->A1_XVEND2

            EndIf

        Else
            cCodVend := SA1->A1_VEND

        EndIf

    EndIf

    RestArea(aArea)

Return cCodVend
/*/{Protheus.doc} User Function ADV1180L
    Solicitação de refaturamento.
    @type  Function
    @author Everson
    @since 25/05/2023
    @version 01
/*/
User Function ADV1180L(cCliente, cLoja)

    //Variáveis.
    Local aArea   := GetArea()
    Local cEFBack := cEmpAnt + cFilAnt
    Local cPedido := ZJA->ZJA_NUM  
    Local cLocExp := ZJA->ZJA_LOCEXP

    If ZJA->ZJA_INTSC5 <> "1"
        MsgInfo("Pedido " + cPedido + " ainda não integrado na SC5.", "Função ADV1180L(ADVEN118P)")
        RestArea(aArea)
        Return Nil

    EndIf

    If cNumEmp <> cLocExp
        altFilial(cLocExp)

    EndIf

        DbSelectArea("SC5")
        SC5->(DbSetOrder(1))
        If SC5->(DbSeek( FWxFilial("SC5") + cPedido))
            MsgAguarde({|| U_ADFAT007P() }, "Aguarde", "Processando...")

        Else
            MsgInfo("Pedido " + cPedido + " ainda não localizado na SC5.", "Função ADV1180L(ADVEN118P)") 

        EndIf

    If cNumEmp <> cEFBack
        altFilial(cEFBack)

    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADV1180M
    Regra para gatilho de cliente para o campo loja.
    @type  Function
    @author Everson
    @since 29/05/2023
    @version 01
/*/
User Function ADV1180M(cCliente)

    //Variáveis.
    Local aArea := GetArea()
    Local cLoja := Space(2)

    If Empty(cCliente)
        RestArea(aArea)
        Return cLoja
    
    EndIf
    
    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    If SA1->(DbSeek( FWxFilial("SA1") + cCliente + "00" )) .And. SA1->A1_MSBLQL == "2"
        cLoja := "00"

    EndIf

    RestArea(aArea)
    
Return cLoja
