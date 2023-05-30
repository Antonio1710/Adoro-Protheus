#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#Include "Topconn.ch"
#Include "FWPrintSetup.ch"
#Include "Rptdef.ch"

Static cTbMast  := "ZIN"
Static cTitulo  := "Entrada de matéria-prima"
Static cTiMast  := "Dados da entrada de matéria-prima"
Static xPula    := Chr(13) + Chr(10)

/*/{Protheus.doc} User Function ADFAT063P
    Entrada de Matéria-prima.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 31/10/2022
    @version 01
    @history Everson, 21/11/2022, ticket 18465 - melhoria da rotina de entrada de matéria-prima.
    @history Everson, 24/11/2022, ticket 18465 - valida CT-e rejeitado.
    @history Everson, 14/12/2022, ticket 18465 - Tratamento para errorlog.
    @history Everson, 16/12/2022, ticket 18465 - Removida validação de valor de frete.
    @history Everson, 29/12/2022, ticket 18465 - Adicionado campo de data de recebimento e validação de quantidade pela programação de recebimento(ZIP).
    @history Everson, 02/01/2023, ticket 18465 - Melhoria para acrescentar preço unitário e saldo do pedido de compra na consulta padrão customizada.
    @history Everson, 05/01/2023, ticket 18465 - Removida validação de alteração para registros que já possuem ordem de pesagem vinculada, função para atualização de status.
    @history Everson, 09/01/2023, ticket 18465 - Tratamento para não selecionar pedido de compra encerrado.
    @history Everson, 12/01/2023, ticket 18465 - Melhoria para inclusão de CT-e.
    @history Everson, 13/01/2023, ticket 18465 - Atualiza o status do registro na entrada de matéria-prima.
    @history Everson, 17/01/2023, ticket 18465 - Tratamento para lançamento de CT-e.
    @history Everson, 18/01/2023, ticket 18465 - Tratamento para informar o item do pedido de compra do CT-e.
    @history Everson, 25/01/2023, ticket 18465 - Adicionado validação de total e quantidade lançados x NF, quando houver chave da NF.
    @history Everson, 26/01/2023, ticket 18465 - Corrigida validação de quantidade.
    @history Everson, 01/02/2023, ticket 18465 - Adicionada verificação de transferência entre filiais.
    @history Everson, 08/02/2023, ticket 18465 - Tratamento para validar transferência entre filiais.
    @history Everson, 08/02/2023, ticket 18465 - Atualização da data de recebimento da entrada de matéria-prima. 
    @history Everson, 24/02/2023, ticket 18465 - Tratamento para contemplar desconto. 
    @history Everson, 06/03/2023, ticket 18465 - Tratamento para apontar o pedido de compra do CT-e na linha do item. 
    @history Everson, 06/03/2023, ticket 18465 - Tratamento para exbir pedidos de compra bloqueados. 
    @history Everson, 07/03/2023, ticket 18465 - Tratamento para validação de preço unitário. 
    @history Everson, 07/03/2023, ticket 18465 - Tratamento para validação de quantidade. 
    @history Everson, 09/03/2023 - ticket 18465 - Alterada validação de bloqueio de quantiade para pedido.
    @history Everson, 09/03/2023 - ticket 18465 - Ajuste desconto.
    @history Everson, 10/03/2023 - ticket 18465 - Correção para quando haver mais de uma linha na NF.
    @history Everson, 11/03/2023 - ticket 18465 - Ajuste tolerância de quantidade, preço unitário e preço total.
    @history Everson, 17/03/2023 - ticket 18465 - Adicionada validação de preço unitário.
    @history Everson, 17/03/2023 - ticket 18465 - Correção validação CT-e.
    @history Everson, 21/03/2023 - ticket 90446 - Adicionada a validação para formulário próprio.
    @history Everson, 21/03/2023 - ticket 90447 - Alterada a cor da legenda do registro de CT-e.
    @history Everson, 21/03/2023 - ticket 18465 - Trava para não excluir registro com NF e/ou CT-e lançados.
    @history Everson, 23/03/2023 - ticket 90614 - Correção errorlog.
    @history Everson, 31/03/2023 - ticket 18465 - Adicionados campos Desconto NF e Outros.
    @history Everson, 04/04/2023 - ticket 18465 - Correção mensagem de tolerância CT-e.
    @history Jonathan, 05/04/2023 - ticket 90938 - Criação Consulta Pedido de Compra. 
    @history Wagner,  14/04/2023 - ticket 91979 - Validação de NF com IPI.
    @history Wagner,  26/04/2023 - ticket 92687 - Validação Valor Total Entrada com Pedido de Compra Moeda Estrangeira.
    @history Wagner,  10/05/2023 - ticket 93612 - Correção error log no lançamento de nota com moeda dolar em 2 linhas.
    @history Jonathan 12/05/2023 - Ticket 92392 - Incluido função para cancelar Ct-e e envio para a integração
    @history Jonathan 15/05/2023 - Ticket 92507 - Inclusão de consulta pedido FRETES
    @history Jonathan 22/05/2023 - Ticket 92392 - Correção e adaptação para envio da integração para exclusão e inclusão 
    @history Jonathan 25/05/2023 - Ticket 94532 - Retirar junção de alteração da NF

/*/
User Function ADFAT063P() // U_ADFAT063P()

    //Variáveis.
    Local oBrowse := FwLoadBrw("ADFAT063P")

    SetBrwCHGAll(.F.)

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 31/10/2022
    @version 01
/*/
Static Function BrowseDef()

    //Variáveis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    oBrowse:SetFilterDefault(" " + cTbMast + "_FILIAL = '" + FWxFilial(cTbMast) + "' ")

    oBrowse:AddLegend("ZIN->ZIN_STATUS = '1'" , "BR_AZUL"         , "Aberta")
    oBrowse:AddLegend("ZIN->ZIN_STATUS = '2'" , "BR_VERMELHO"     , "Ordem de Pesagem")
    oBrowse:AddLegend("ZIN->ZIN_STATUS = '3'" , "BR_VERDE"        , "Pesagem inicial")
    oBrowse:AddLegend("ZIN->ZIN_STATUS = '4'" , "BR_VERDE_ESCURO" , "Pesagem final")
    oBrowse:AddLegend("ZIN->ZIN_STATUS = '5'" , "BR_BRANCO"       , "Pendente Integração")
    oBrowse:AddLegend("ZIN->ZIN_STATUS = '6'" , "BR_PRETO"        , "NF lançada")
    oBrowse:AddLegend("ZIN->ZIN_STATUS = '7'" , "BR_VIOLETA"      , "CT-E lançado")  //Everson - 21/03/2023 - ticket 90447.
    oBrowse:AddLegend("ZIN->ZIN_STATUS = '8'" , "BR_PINK"         , "Cancelado")     //Jonathan - 24/04/2023 - ticket 91286
    oBrowse:AddLegend("ZIN->ZIN_STATUS = '9'" , "BR_AMARELO"      , "CT-E Cancelada")//Jonathan - 12/05/2023 - ticket 92392

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 31/10/2022
    @version 01
/*/
Static Function MenuDef()

    //Variáveis.
    Local aRotina := {}
    Local cUsrCanc := Alltrim(GETMV("MV_#ALTSTC", ,"000000"))

    ADD OPTION aRotina TITLE "Pesquisar"      ACTION "PesqBrw"          	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 	  ACTION "VIEWDEF.ADFAT063P" 	OPERATION MODEL_OPERATION_VIEW      ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" 	      ACTION "VIEWDEF.ADFAT063P" 	OPERATION MODEL_OPERATION_INSERT    ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"        ACTION "U_ADFAT63P()" 	    OPERATION MODEL_OPERATION_UPDATE    ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" 	      ACTION "U_ADFAT63T()"     	OPERATION MODEL_OPERATION_DELETE    ACCESS 0
    //Jonathan - 24/04/2023 Ticket 91286
    If FWIsAdmin() .Or. __cUserID $ cUsrCanc
        ADD OPTION aRotina TITLE "Cancelar" 	  ACTION "U_ADFAT63O(ZIN->ZIN_DOC, ZIN->ZIN_SERIE, ZIN->ZIN_FORNEC, ZIN->ZIN_LOJA, 'NF', '8')"     	OPERATION MODEL_OPERATION_DELETE    ACCESS 0
        //Jonathan - 12/05/2023 Ticket 92392
        ADD OPTION aRotina TITLE "CT-E Cancelar"  ACTION "U_ADFAT63O(ZIN->ZIN_DOCTE, ZIN->ZIN_SERCTE, ZIN->ZIN_FORCTE, ZIN->ZIN_LOJCTE, 'CTE', '9')" OPERATION MODEL_OPERATION_DELETE    ACCESS 0  	
    EndIf
    ADD OPTION aRotina TITLE "Gera Ord Pes"   ACTION "U_ADFAT63C(ZIN->ZIN_CTPATI, ZIN->ZIN_DOC, ZIN->ZIN_SERIE, ZIN->ZIN_FORNEC, ZIN->ZIN_LOJA)" 	OPERATION 11    ACCESS 0
    ADD OPTION aRotina TITLE "Excl Ord Pes"   ACTION "U_ADFAT63H(ZIN->ZIN_CTPATI, ZIN->ZIN_DOC, ZIN->ZIN_SERIE, ZIN->ZIN_FORNEC, ZIN->ZIN_LOJA)" 	OPERATION 12    ACCESS 0

    ADD OPTION aRotina TITLE "Env Barramento" ACTION 'MsAguarde({|| U_ADFAT63D() }, "Aguarde", "Enviando...")'       OPERATION 13  ACCESS 0

Return aRotina
/*/{Protheus.doc} User Function ADFAT63P
    Exclusão de lançamento.
    @type  Function
    @author Everson
    @since 13/01/2023
    @version 01
/*/
User Function ADFAT63T()

    //Variáveis.
    Local aArea := GetArea()

    If ZIN->ZIN_STATUS $"6/7"
        Help(Nil, Nil, "ADFAT63T(ADFAT063P)", Nil, "Operação não permitida. NF e/ou CT-e já lançados.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Nil

    EndIf

    FWExecView(cTitulo, "ADFAT063P", 5)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADFAT63P
    Alteração.
    @type  Function
    @author Everson
    @since 13/01/2023
    @version 01
/*/
User Function ADFAT63P()

    //Variáveis.
    Local aArea  := GetArea()

    If ZIN->ZIN_STATUS == "7"
        Help(Nil, Nil, "ADFAT63P(ADFAT063P)", Nil, "Operação não permitida. NF e CT-e já lançados.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Nil
    
    EndIf

    FWExecView(cTitulo, "ADFAT063P", 4)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 31/10/2022
    @version 01
/*/
Static Function ModelDef()
    
    //Variáveis.
    Local oModel    := Nil
    Local cCampos   := getCmps()
    Local oStrMast  := FWFormStruct(1, cTbMast, {|cCampo| AllTRim(cCampo) $ cCampos .Or. cCampo = "ZIN_TESCTE" })
    Local oStrGrid  := FWFormStruct(1, cTbMast)
    Local bPost     := {|oModel| vldPos(oModel)}

    oModel := MPFormModel():New("ADFAT63", /*bPreValidacao*/, bPost, /*bCommit*/, /*bCancel*/ )
    
    //AddFields(<cId >, <cOwner >, <oModelStruct >, <bPre >, <bPost >, <bLoad >)
    oModel:AddFields("MD_MASTER", Nil, oStrMast)
    oModel:AddGrid("MD_GRID", "MD_MASTER", oStrGrid,,{|oModelGrid| fValidGrid(oModelGrid, oModel:GetModel("MD_MASTER"), oModel) },,,)
 
    oModel:SetRelation("MD_GRID", {;
            {"ZIN_FILIAL"  , 'FWxFilial("' + cTbMast + '")'},;
            {"ZIN_CHAVE"   , "ZIN_CHAVE"},;
            {"ZIN_DOC"     , "ZIN_DOC"},;
            {"ZIN_SERIE"   , "ZIN_SERIE"},;
            {"ZIN_EMISS"   , "ZIN_EMISS"},;
            {"ZIN_FORNEC"  , "ZIN_FORNEC"},;
            {"ZIN_LOJA"    , "ZIN_LOJA"},;
            {"ZIN_NOME"    , "ZIN_NOME"},;
            {"ZIN_CTPATI"  , "ZIN_CTPATI"},;
            {"ZIN_PLACA"   , "ZIN_PLACA"},;
            {"ZIN_CHVCTE"  , "ZIN_CHVCTE"},;
            {"ZIN_FORMUL"  , "ZIN_FORMUL"},;
            {"ZIN_ESPECI"  , "ZIN_ESPECI"},;
            {"ZIN_DTRECE"  , "ZIN_DTRECE"},;
            {"ZIN_VLFRT"   , "ZIN_VLFRT"},;
            {"ZIN_DOCTE"   , "ZIN_DOCTE"},;
            {"ZIN_SERCTE"  , "ZIN_SERCTE"},;
            {"ZIN_EMISCT"  , "ZIN_EMISCT"},;
            {"ZIN_VLRCTE"  , "ZIN_VLRCTE"},;
            {"ZIN_FORCTE"  , "ZIN_FORCTE"},;
            {"ZIN_LOJCTE"  , "ZIN_LOJCTE"},;
            {"ZIN_NMCTE"   , "ZIN_NMCTE"},;
            {"ZIN_TESCTE"  , "ZIN_TESCTE"},;
            {"ZIN_NATCTE"  , "ZIN_NATCTE"},;
            {"ZIN_DCTO"    , "ZIN_DCTO"},;
            {"ZIN_OUTROS"  , "ZIN_OUTROS"};
        }, (cTbMast)->(IndexKey(1)))

    oModel:SetDescription(cTiMast)
    oModel:SetPrimaryKey({})
        
    oModel:AddCalc("ADFAT63TOT", "MD_MASTER", "MD_GRID", "ZIN_TOTAL" , "ZIN_VLTITE",  "SUM", { || .T. },,"Valor Itens")
    oModel:AddCalc("ADFAT63TOT", "MD_MASTER", "MD_GRID", "ZIN_DESCON", "ZIN_TOTDESC", "FORMULA", { || .T. },,"Total Descontos", {|oModel| U_ADFAT63U(oModel, .F.) })
    oModel:AddCalc("ADFAT63TOT", "MD_MASTER", "MD_GRID", "ZIN_TOTAL" , "ZIN_VLRTOT",  "FORMULA", { || .T. },,"Valor Total (Itens + Frete + Outros - Desconto NF)", {|oModel| U_ADFAT63J(oModel) })
    oModel:AddCalc("ADFAT63TOT", "MD_MASTER", "MD_GRID", "ZIN_QUANT" , "ZIN_QTDTOT",  "SUM", { || .T. },,"Qtd Total")

Return oModel
/*/{Protheus.doc} User Function ADFAT63J
    Calcula o valor total.
    @type  Function
    @author Everson
    @since 16/01/2023
    @version 01
/*/
User Function ADFAT63J(oModel)

    //Variáveis.
    Local aArea  := GetArea()
    Local nTotal := 0
    
    nTotal := oModel:GetValue("ADFAT63TOT","ZIN_VLTITE") + oModel:GetValue("MD_MASTER","ZIN_VLFRT") + oModel:GetValue("MD_MASTER","ZIN_OUTROS") - oModel:GetValue("MD_MASTER","ZIN_DCTO")

    RestArea(aArea)

Return nTotal
/*/{Protheus.doc} User Function ADFAT63U
    Calcula o valor total.
    @type  Function
    @author Everson
    @since 31/03/2023
    @version 01
/*/
User Function ADFAT63U(oModel, lUpdate)

    //Variáveis.
    Local aArea     := GetArea()
    Local nTotal    := 0
    Local oModelGRID:= oModel:GetModel("MD_GRID")
    Local nLinhas   := oModelGRID:Length() 
    Local nLinha    := oModelGRID:GetLine()
    Local nTotDesc  := 0
    Local nAux      := 1

    Default lUpdate := .F.

    For nAux := 1 To nLinhas

        oModelGRID:GoLine(nAux) 

        If oModelGRID:IsDeleted()
            Loop

        EndIf

        nTotDesc += Val(cValToChar(oModelGRID:GetValue("ZIN_DESCON")))

    Next nAux      

    oModelGRID:GoLine(nLinha)
    
    nTotal := oModel:GetValue("MD_MASTER","ZIN_DCTO") +  nTotDesc

    If lUpdate
        oModel:SetValue("ADFAT63TOT", "ZIN_TOTDESC", nTotal)

    EndIf

    RestArea(aArea)

Return nTotal
/*/{Protheus.doc} fValidGrid
    Valida linha.
    @type  Static Function
    @author Everson
    @since 03/11/2022
    @version 01
/*/
Static Function fValidGrid(oModelGRID, oModel, oModelPr)

    //Variáveis.
    Local lRet      := .T.
    Local nAux      := 0
    Local cFornec   := oModel:GetValue("ZIN_FORNEC")
    Local cLoja     := oModel:GetValue("ZIN_LOJA")
    Local cDoc      := oModel:GetValue("ZIN_DOC")
    Local cSerie    := oModel:GetValue("ZIN_SERIE")
    Local oModelHEA := oModel:GetModel("MD_MASTER")
    Local cFormProp := oModelHEA:GetValue("MD_MASTER","ZIN_FORMUL") //Everson - 21/03/2023 - ticket 90446.
    Local nRetCTE   := 0
    Local cRecebe   := DToS(oModelHEA:GetValue("MD_MASTER","ZIN_DTRECE"))
    Local nOperation:= oModel:GetOperation()
    Local lTransf   := U_ADFAT63R(cDoc, cSerie)
    Local nLinha    := oModelGRID:GetLine()
    Local nLinhas   := oModelGRID:Length() 
    Local nStart    := 1

    Local cTpFrt    := ""

    //Carga da central xml.
    If IsInCallStack("U_ADFAT636")
        Return .T.

    EndIf

    If ! IsInCallStack("vldPos")
        nStart  := nLinha
        nLinhas := nLinha

    EndIf
 
    For nAux := nStart To nLinhas

        oModelGRID:GoLine(nAux) 

        If oModelGRID:IsDeleted()
            Loop

        EndIf

        If nOperation == MODEL_OPERATION_INSERT .And. Empty(oModelGRID:GetValue("ZIN_STATUS"))
            oModelGRID:SetValue("ZIN_STATUS", "1")

        EndIf
         
        If ! oModelGRID:IsDeleted() .And.;
            (;
                Empty(oModelGRID:GetValue("ZIN_PRODUT")) .Or. Empty(oModelGRID:GetValue("ZIN_DESC"));
                .Or. oModelGRID:GetValue("ZIN_QUANT") <= 0 .Or. oModelGRID:GetValue("ZIN_VLRUNT") <= 0;
                .Or. (! lTransf .And. Empty(oModelGRID:GetValue("ZIN_PEDCOM")));
            )

                lRet := .F.
                Help(Nil, Nil, "fValidGrid(ADFAT063P)", Nil, "Necessário informar o produto, quantidade, valor e pedido de compra.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                Exit
                
        EndIf

        //Everson - 21/03/2023 - ticket 90446.
        If cFormProp == "S" .And. (Empty(oModelGRID:GetValue("ZIN_TES")) .Or. Empty(oModelGRID:GetValue("ZIN_NATURE")))
            lRet := .F.
            Help(Nil, Nil, "fValidGrid(ADFAT063P)", Nil, "Necessário informar o TES e a natureza para nota de formulário próprio.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            Exit

        EndIf

        //Valida fornecedor alternativo.
        If ! lTransf .And. ! U_ADFAT635(oModelGRID:GetValue("ZIN_PEDCOM"), cFornec, cLoja)
            lRet := .F.
            Help(Nil, Nil, "fValidGrid(ADFAT063P)", Nil, "Fornecedor inválido.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            Exit

        EndIf

        //Valida quantidade.
        If ! lTransf .And. U_ADFAT63Q() .And. ! U_ADFAT634(oModelPr, oModelGRID, oModelGRID:GetValue("ZIN_PEDCOM"), oModelGRID:GetValue("ZIN_ITEMPC"), oModelGRID:GetValue("ZIN_QUANT"), cRecebe) //Everson - 29/12/2022. Ticket 18465.
            lRet := .F.
            Exit

        EndIf

        //Valida preço.
        If ! lTransf .And. ! U_ADFAT633(oModelHEA, oModelGRID)
            lRet := .F.
            Exit

        EndIf

        If ! lTransf .And. ! Empty(oModelGRID:GetValue("ZIN_PEDCOM"))

            cTpFrt := Posicione("SC7", 1, FWxFilial("SC7") + oModelGRID:GetValue("ZIN_PEDCOM"), "C7_TPFRETE")

            //Valida CT-e.
            If lRet .And. cTpFrt == "F" 

                If (Empty(oModelGRID:GetValue("ZIN_PEDCTE")) .Or. Empty(oModelGRID:GetValue("ZIN_ITPCCT")) .Or. Empty(oModelGRID:GetValue("ZIN_CONDCT")))
                    lRet := .F.
                    Help(Nil, Nil, "fValidGrid(ADFAT063P)", Nil, "Necessário informar o pedido de compra do CT-e.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                    Exit
                
                Else
                    lRet := ! (vldPrCTE(oModelHEA, .T.) == 3)
                    Exit

                EndIf
            
            EndIf

            //Valida CT-e.
            If lRet .And. cTpFrt <> "F" 
 
                nRetCTE := vldPrCTE(oModelHEA, .F.)

                If nRetCTE == 2
                
                    If Empty(oModelGRID:GetValue("ZIN_PEDCTE")) .And. Empty(oModelGRID:GetValue("ZIN_ITPCCT")) .And. Empty(oModelGRID:GetValue("ZIN_CONDCT"))
                        Help(Nil, Nil, "Função fValidGrid(ADFAT063P)", Nil, "O frete não é Fob, mas os dados de CT-e estão preenchidos.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

                    Else
                        lRet := .F.
                        Help(Nil, Nil, "fValidGrid(ADFAT063P)", Nil, "Necessário informar o pedido de compra do CT-e.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                        Exit

                    EndIf

                ElseIf nRetCTE == 3
                    lRet := .F.
                    Exit

                EndIf
            
            EndIf

        EndIf

    Next nAux

    oModelGRID:GoLine(nLinha)
 
Return lRet
/*/{Protheus.doc} ADFAT63R
    Verifica se é nota de transferência.
    @type  Function
    @author Everson
    @since 01/02/2023
    @version 01
/*/
User Function ADFAT63R(cDoc, cSerie)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cQuery    := ""
    Local aFieldSM0 := { ;
        "M0_CODIGO",;    //Posição [1]
        "M0_CODFIL",;    //Posição [2]
        "M0_NOMECOM",;   //Posição [3]
        "M0_CGC",;       //Posição [4]
        "M0_INSCM",;     //Posição [5]
        "M0_CIDENT",;    //Posição [6]
        "M0_ESTENT",;    //Posição [7]
        "M0_ENDENT",;    //Posição [8]
        "M0_BAIRENT",;   //Posição [9]
        "M0_CEPENT",;    //Posição [10]
        "M0_COMPENT",;   //Posição [11]
        "M0_TEL";        //Posição [12]
    }
    Local aSM0Data2 := FWSM0Util():GetSM0Data(, cFilAnt, aFieldSM0)
    Local cCGC      := aSM0Data2[4][2]
    Local cNewAlias := GetNextAlias()

    cQuery := ""
    cQuery += " SELECT " 
        cQuery += " C5_NOTA, C5_SERIE " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZHS") + " (NOLOCK) AS ZHS " 
        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("SC5") + " (NOLOCK) AS SC5 ON " 
        cQuery += " ZHS_FILIAL = C5_FILIAL " 
        cQuery += " AND ZHS_NVPED = C5_NUM " 
        cQuery += " AND SC5.D_E_L_E_T_ = '' " 
        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("SA1") + " (NOLOCK) AS SA1 ON " 
        cQuery += " C5_CLIENTE = A1_COD " 
        cQuery += " AND C5_LOJACLI = A1_LOJA " 
        cQuery += " AND SA1.D_E_L_E_T_ = '' " 
    cQuery += " WHERE " 
        cQuery += " ZHS.D_E_L_E_T_ = '' " 
        cQuery += " AND C5_NOTA = '" + cDoc + "' " 
        cQuery += " AND C5_SERIE LIKE '%" + Alltrim(cValToChar(cSerie)) + "%'"  //Everson - 08/02/2023 - ticket 18465.
        cQuery += " AND A1_CGC = '" + cCGC + "' " 

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)
    (cNewAlias)->(DbGoTop())

    lRet := ! (cNewAlias)->(Eof())

    (cNewAlias)->(DbCloseArea())

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} vldPrCTE
    Valida Preenchimento do CTE.
    @type  Static Function
    @author user
    @since 12/01/2023
    @version 01
/*/
Static Function vldPrCTE(oModel, lObrigatorio)

    //Variáveis.
    Local nRet      := 2
    Local cCTE      := oModel:GetValue("MD_MASTER", "ZIN_DOCTE")
    Local cSerieCTE := oModel:GetValue("MD_MASTER", "ZIN_SERCTE")
    Local dEmiss    := oModel:GetValue("MD_MASTER", "ZIN_EMISCT")
    Local nVlrCTe   := oModel:GetValue("MD_MASTER", "ZIN_VLRCTE")
    Local cFornCTE  := oModel:GetValue("MD_MASTER", "ZIN_FORCTE")
    Local cLojaCTE  := oModel:GetValue("MD_MASTER", "ZIN_LOJCTE")
    Local cNomeCTE  := oModel:GetValue("MD_MASTER", "ZIN_NMCTE")
    Local cTesCTE   := oModel:GetValue("MD_MASTER", "ZIN_TESCTE")
    Local cNatCTE   := oModel:GetValue("MD_MASTER", "ZIN_NATCTE")

    Local cString   := Alltrim(cCTE + cSerieCTE + DToS(dEmiss) + Iif(nVlrCTe > 0, "Vlr", "") + cFornCTE + cLojaCTE + cNomeCTE + cTesCTE + cNatCTE)

    If ! lObrigatorio .And. Empty(cString)
        Return 1

    EndIf

    If  Empty(cCTE);
                .Or. Empty(cSerieCTE);
                .Or. Empty(dEmiss);
                .Or. nVlrCTe <= 0;
                .Or. Empty(cFornCTE);
                .Or. Empty(cLojaCTE);
                .Or. Empty(cNomeCTE);
                .Or. Empty(cTesCTE);
                .Or. Empty(cNatCTE)

        nRet := 3
        Help(Nil, Nil, "Função vldPrCTE(ADFAT063P)", Nil, "Necessário informar todos os dados do cabeçalho do CTE.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                
    EndIf
    
Return nRet
/*/{Protheus.doc} vldPos
    Pós validação.
    @type  Static Function
    @author Everson
    @since 31/10/2022
    @version 01
/*/
Static Function vldPos(oModel)

    //Variáveis.
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    Local cCP        := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_CTPATI")))
    Local cPlaca     := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_PLACA")))
    Local cNF        := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_DOC")))
    Local cSerie     := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_SERIE")))
    Local cFornec    := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_FORNEC")))
    Local cLoja      := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_LOJA")))
    Local cChave     := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_CHAVE")))
    Local cChvCTE    := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_CHVCTE")))
    Local cFilial    := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_FILIAL"))) //@history Jonathan 22/05/2023 - Ticket 92392 


    Local nDescNF    := oModel:GetValue("MD_MASTER", "ZIN_DCTO")

    Local nVlrTotal  := oModel:GetValue("ADFAT63TOT", "ZIN_VLRTOT")
    Local oModelGRID := oModel:GetModel("MD_GRID")
    Local nLinhas    := oModelGRID:Length()
    Local nAux       := 1
    Local cStatus    := ""
    Local cMsgError  := ""

    Local cCTE       := oModel:GetValue("MD_MASTER","ZIN_DOCTE")
    Local cSerieCTE  := oModel:GetValue("MD_MASTER","ZIN_SERCTE")
    Local cFornCTE   := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_FORCTE")))
    Local cLjCTE     := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_LOJCTE")))
    Local nLinha     := oModelGRID:GetLine()

    // Local nTotalKg   := oModel:GetValue("ADFAT63TOT", "ZIN_QTDTOT")
    // Local cPedCTE    := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_PEDCTE")))
    // Local cItPdCTE   := Alltrim(cValToChar(oModel:GetValue("MD_MASTER", "ZIN_ITPCCT")))

    Local nStQtdTot  := 0
    Local nStVlrTot  := 0
    Local nStDescont := 0
    Local nTotDesc   := 0
    Local nValIPI    := 0
    Local cNmOrdem   := ""
    
    //Jonathan - 24/04/2023 Ticket 91286
    Local cUsrCanc := Alltrim(GETMV("MV_#ALTSTC", ,"000000"))
    Local cScrip3  := "" //@history Jonathan 22/05/2023 - Ticket 92392

    //Inclusão.
    If lRet .And. nOperation == MODEL_OPERATION_INSERT .And. ! IsInCallStack("U_ADFAT63L") .And. ! IsInCallStack("U_ADFAT63M") //Everson - 29/12/2022. Ticket 18465. //Everson - 05/01/2023. Ticket 18465.

        If lRet .And. ! Empty(cChave)

            If obtTotNF(oModelGRID, nLinhas, cChave, @nStVlrTot, @nStQtdTot, @nTotDesc, @nStDescont, @nValIPI) // Wagner,  14/04/2023 - ticket 91979 - Validação de NF com IPI.

                // Wagner,  14/04/2023 - ticket 91979 - Validação de NF com IPI.

                If nValIPI > 0
                    If lRet .And. (nStVlrTot-nValIPI)  <> nVlrTotal 
                        lRet := .F.
                        Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "Valor total está divergente com a NF." + xPula + xPula +;
                        "Valor NF: " + Transform(nStVlrTot-nValIPI, "@E 999,999,999.9999") + xPula +;
                        "Valor Digitado: " + Transform(nVlrTotal, "@E 999,999,999.9999") + xPula +;
                        "Valor IPI: " + Transform(nValIPI, "@E 999,999,999.9999"), 1, 0)

                    Endif
                Else
                    If lRet .And. nStVlrTot <> nVlrTotal
                        lRet := .F.
                        Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "Valor total está divergente com a NF." + xPula + xPula +;
                        "Valor NF: " + Transform(nStVlrTot, "@E 999,999,999.9999") + xPula +;
                        "Valor Digitado: " + Transform(nVlrTotal, "@E 999,999,999.9999"), 1, 0)

                    EndIf
                EndIf
                
                If lRet .And. nStDescont <> (nTotDesc + nDescNF)
                    lRet := .F.
                    Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "Valor total de desconto está divergente com a NF."+ xPula + xPula +;
                    "Valor NF: " + Transform(nStDescont, "@E 999,999,999.9999") + xPula +;
                    "Valor Digitado: " + Transform(nTotDesc, "@E 999,999,999.9999"), 1, 0)

                EndIf

            EndIf

            // If lRet .And. nStQtdTot <> nTotalKg
            //     lRet := .F.
            //     Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "Quantidade está divergente com a NF.", 1, 0)

            // EndIf

        EndIf

        If lRet .And. U_ADFAT638(cNF, cSerie, cFornec, cLoja) .And. ( ! Empty(cCTE) .And. U_ADFAT638(cCTE, cSerieCTE, cFornCTE, cLjCTE) )
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "NF e CT-e já lançados nos documentos de entrada (SF1).", 1, 0 )

        EndIf

        If lRet .And. Empty(cCP)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADFAT063P)",,"Necessário informar o número do controle de pátio.", 1, 0 )

        EndIf
        
        If lRet .And. Empty(cPlaca)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADFAT063P)",,"Necessário informar a placa.", 1, 0 )

        EndIf
        
        If lRet .And. Len(cPlaca) <> 7
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADFAT063P)",,"A placa precisa ter 7 caracteres.", 1, 0 )

        EndIf

        If lRet .And. U_ADFAT639(cNF, cSerie, cFornec, cLoja) .Or. (!Empty(cChave) .And. U_ADFAT63A(cChave))
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADFAT063P)",,"Nota fiscal já lançada na entrada de matéria-prima.", 1, 0 )

        EndIf

        lRet := lRet .And. gridFocus(oModel, Nil)
        
        lRet := lRet .And. fValidGrid(oModelGRID, oModel:GetModel("MD_MASTER"), oModel)

        If lRet .And. ! Empty(cChvCTE)
            lRet := U_ADFAT63I(cChvCTE)
        
        EndIf

        //Deixar essa chamada sempre por último.
        If lRet .And. ! Empty(cCTE)
            lRet := movCTE(oModelGRID, cCTE, cSerieCTE, cFornCTE, cLjCTE, "I")

        EndIf

    EndIf

    //Alteração.
    If lRet .And. nOperation == MODEL_OPERATION_UPDATE .And. ! IsInCallStack("U_ADFAT63L") .And. ! IsInCallStack("U_ADFAT63M") //Everson - 29/12/2022. Ticket 18465. //Everson - 05/01/2023. Ticket 18465.

        If lRet .And. ! Empty(cChave)
            
            If obtTotNF(oModelGRID, nLinhas, cChave, @nStVlrTot, @nStQtdTot, @nTotDesc, @nStDescont, @nValIPI) // Wagner,  14/04/2023 - ticket 91979 - Validação de NF com IPI.             

                // Wagner,  14/04/2023 - ticket 91979 - Validação de NF com IPI.
                If nValIPI > 0
                    If lRet .And. (nStVlrTot-nValIPI)  <> nVlrTotal
                        lRet := .F.
                        Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "Valor total está divergente com a NF." + xPula + xPula +;
                        "Valor NF: " + Transform(nStVlrTot-nValIPI, "@E 999,999,999.9999") + xPula +;
                        "Valor Digitado: " + Transform(nVlrTotal, "@E 999,999,999.9999") + xPula +;
                        "Valor IPI: " + Transform(nValIPI, "@E 999,999,999.9999"), 1, 0)

                    Endif
                Else
                    If lRet .And. nStVlrTot <> nVlrTotal
                        lRet := .F.
                        Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "Valor total está divergente com a NF." + xPula + xPula +;
                        "Valor NF: " + Transform(nStVlrTot-nValIPI, "@E 999,999,999.9999") + xPula +;
                        "Valor Digitado: " + Transform(nVlrTotal, "@E 999,999,999.9999"), 1, 0)

                    EndIf
                Endif 

                If lRet .And. nStDescont <> (nTotDesc + nDescNF)
                    lRet := .F.
                    Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "Valor total de desconto está divergente com a NF."+ xPula + xPula +;
                    "Valor NF: " + Transform(nStDescont, "@E 999,999,999.9999") + xPula +;
                    "Valor Digitado: " + Transform(nTotDesc, "@E 999,999,999.9999"), 1, 0)

                EndIf

            EndIf

            // If lRet .And. nStQtdTot <> nTotalKg
            //     lRet := .F.
            //     Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "Quantidade está divergente com a NF.", 1, 0)

            // EndIf

        EndIf

        If lRet .And. U_ADFAT638(cNF, cSerie, cFornec, cLoja) .And. ( ! Empty(cCTE) .And. U_ADFAT638(cCTE, cSerieCTE, cFornCTE, cLjCTE) )
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "NF e CT-e já lançados nos documentos de entrada (SF1).", 1, 0 )

        EndIf

        lRet := lRet .And. gridFocus(oModel, Nil)

        lRet := lRet .And. fValidGrid(oModelGRID, oModel:GetModel("MD_MASTER"), oModel)

        //Everson - 05/01/2023 - Ticket 18465.
        If lRet

            For nAux := 1 To nLinhas

                oModelGRID:GoLine(nAux) 

                If oModelGRID:IsDeleted()
                    Loop

                EndIf

                cStatus := Alltrim(cValToChar(oModelGRID:GetValue("ZIN_STATUS")))

                If cStatus == "5"
                    oModelGRID:SetValue("ZIN_STATUS", "4")

                EndIf

                 //Jonathan - 12/05/2023 - ticket 92392
                If (FWIsAdmin() .Or. __cUserID $ cUsrCanc) 

                    If FWAlertYesNo("Mudar o Status da CT-e?", "Status CT-e")
                        //@history Jonathan 22/05/2023 - Ticket 92392
                        oModelGrid:SetValue("ZIN_STATUS", "6")
                        cScrip3 := "UPDATE SGNFE010 SET D1_MSEXP = '' WHERE F1_ESPECIE = 'CTE' AND F1_FILIAL = '" + cFilial + "' AND F1_DOC = '" + cCTE + "' AND F1_SERIE = '" + cSerieCTE + "' AND F1_FORNECE = '" + cFornCTE + "' AND F1_LOJA = '" + cLjCTE + "'"

                    //@history Jonathan 25/05/2023 - Ticket 94532  
                    //else  
                    //    @history Jonathan 22/05/2023 - Ticket 92392  
                    //    oModelGrid:SetValue("ZIN_STATUS", "4")                      
                    //    cScrip3 := "UPDATE SGNFE010 SET D1_MSEXP = '' WHERE F1_FILIAL = '" + cFilial + "' AND F1_DOC = '" + cNF + "' AND F1_SERIE = '" + cSerie + "' AND F1_FORNECE = '" + cFornec + "' AND F1_LOJA = '" + cLoja + "'"
                        
                    EndIf               
                    
                    If TcSqlExec(cScrip3) < 0
                        Help(Nil, Nil, "ADFAT63O(ADFAT063P)", Nil, "Erro ao atualizar o envio para integracao. " + TCSQLError() , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

                    EndIf

                EndIf

            Next nAux      

            oModelGRID:GoLine(nLinha)

        EndIf

        If lRet .And. ! Empty(cChvCTE)
            lRet := U_ADFAT63I(cChvCTE)
        
        EndIf

        //Deixar essas chamadas sempre por último.
            If lRet .And. ! Empty(cCTE)
                lRet := movCTE(oModelGRID, cCTE, cSerieCTE, cFornCTE, cLjCTE, "E")

            EndIf

            If lRet .And. ! Empty(cCTE)
                lRet := movCTE(oModelGRID, cCTE, cSerieCTE, cFornCTE, cLjCTE, "I")

            EndIf
        //

    EndIf

    //Exclusão.
    If lRet .And. nOperation == MODEL_OPERATION_DELETE 

        If lRet .And. U_ADFAT638(cNF, cSerie, cFornec, cLoja) .And. ( ! Empty(cCTE) .And. U_ADFAT638(cCTE, cSerieCTE, cFornCTE, cLjCTE) )
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "NF e CT-e já lançados nos documentos de entrada (SF1).", 1, 0 )

        EndIf
    
        If lRet .And. ! U_ADFAT63B(oModel, @cMsgError)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADFAT063P)",, cMsgError, 1, 0 )

        EndIf

        If lRet

            For nAux := 1 To nLinhas

                oModelGRID:GoLine(nAux) 

                If oModelGRID:IsDeleted()
                    Loop

                EndIf

                cNmOrdem := oModelGRID:GetValue("ZIN_ORDPES")

                If Empty(cNmOrdem)
                    Loop
                    
                EndIf

                If U_ADFAT58F(cNmOrdem)
                    lRet := .F.
                    Help(Nil, Nil, "Função vldPos(ADFAT063P)",, "Há registro de transferência entre filiais para ordem de pesagem " + cNmOrdem + ".", 1, 0 )
                    Exit

                EndIf

            Next nAux

            oModelGRID:GoLine(nLinha)

        EndIf

        //Deixar essa chamada sempre por último.
        If lRet .And. ! Empty(cCTE)
            lRet := movCTE(oModelGRID, cCTE, cSerieCTE, cFornCTE, cLjCTE, "E")

        EndIf

    EndIf

    RestArea(aArea)
  
Return lRet
/*/{Protheus.doc} movCTE
    Faz o lançamento da quantidade no pedido de compra.
    @type  Static Function
    @author Everson
    @since 03/03/2023
    @version 01
/*/
Static Function movCTE(oModelGRID, cCTE, cSerieCTE, cFornCTE, cLjCTE, cOpc)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local nLinhas   := oModelGRID:Length()
    Local nAux      := 1
    Local cPedCTE   := ""
    Local cItPdCTE  := ""
    Local nTotalKg  := 0

    Local nLinha    := oModelGRID:GetLine()

    Begin Transaction

        For nAux := 1 To nLinhas

            oModelGRID:GoLine(nAux) 

            If oModelGRID:IsDeleted()
                Loop

            EndIf

            cPedCTE   := oModelGRID:GetValue("ZIN_PEDCTE")
            cItPdCTE  := oModelGRID:GetValue("ZIN_ITPCCT")
            nTotalKg  := oModelGRID:GetValue("ZIN_QUANT")

            If Empty(cPedCTE)
                Loop
                
            EndIf

            If ! lancCTE(cOpc, cCTE, cSerieCTE, cPedCTE, cItPdCTE, cFornCTE, cLjCTE, nTotalKg)
                DisarmTransaction()
                Break

            EndIf

        Next nAux

        lRet := .T.

    End Transaction

    oModelGRID:GoLine(nLinha)

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} obtTotNF
    Retorna peso e valor da NF.
    @type  Static Function
    @author Everson
    @since 25/01/2023
    @version 01
/*/
Static Function obtTotNF(oModelGRID, nLinhas, cChave, nStVlrTot, nStQtdTot, nTotDesc, nStDescont, nValIPI)

    //Variáveis.
    Local lRet      := .T.
    Local cQuery    := " SELECT SUM(XIT_QTENFE) AS XIT_QTENFE, SUM(XIT_TOTNFE) AS XIT_TOTNFE, SUM(XIT_VALDES) AS XIT_VALDES, SUM(XIT_VALIPI) XIT_VALIPI FROM RECNFXMLITENS WHERE XIT_CHAVE = '" + cChave + "' AND D_E_L_E_T_ = '' "
    Local cNewAlias := GetNextAlias()
    Local nAux      := 1
    Local cXmlAtu   := ""
    Local aDados    := {}

    Local nLinha    := oModelGRID:GetLine()

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)
    (cNewAlias)->(DbGoTop())
    
    nValIPI =  Val(cValToChar((cNewAlias)->XIT_VALIPI))
    lRet := Val(cValToChar((cNewAlias)->XIT_TOTNFE)) > 0

    If lRet

        For nAux := 1 To nLinhas

            oModelGRID:GoLine(nAux) 

            If oModelGRID:IsDeleted()
                Loop

            EndIf

            nTotDesc += Val(cValToChar(oModelGRID:GetValue("ZIN_DESCON")))

        Next nAux      

        oModelGRID:GoLine(nLinha)

    EndIf

    U_DbSelArea( "RECNFXML", .F., 1 )
    DbSeek( cChave )

    If DbSeek( cChave )

        cXmlAtu	:= RECNFXML->XML_ARQ

        aDados := U_ADFAT637("", "", cXmlAtu, .F.)

        // 1 - Valor produto, 2 Valor NF, 3- Valor desconto.
        nStDescont := aDados[1][3]
        
        nStVlrTot  := aDados[1][2]
        

    EndIf
    
    nStQtdTot := Val(cValToChar((cNewAlias)->XIT_QTENFE))

    (cNewAlias)->(DbCloseArea())

Return lRet
/*/{Protheus.doc} gridFocus
    Função executada quando a grid ganha foco.
    @type  Static Function
    @author Everson
    @since 31/10/2022
    @version 01
/*/
Static Function gridFocus(oModel, oView)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .T.
    Local cChave    := oModel:GetValue("MD_MASTER","ZIN_CHAVE")
    Local cNF       := oModel:GetValue("MD_MASTER","ZIN_DOC")
    Local cSerie    := oModel:GetValue("MD_MASTER","ZIN_SERIE")
    Local dEmiss    := oModel:GetValue("MD_MASTER","ZIN_EMISS")
    Local cFornec   := oModel:GetValue("MD_MASTER","ZIN_FORNEC")
    Local cLoja     := oModel:GetValue("MD_MASTER","ZIN_LOJA")
    Local cNome     := oModel:GetValue("MD_MASTER","ZIN_NOME")
    Local dReceb    := oModel:GetValue("MD_MASTER","ZIN_DTRECE")
    Local nOperation:= oModel:GetOperation()
    Local cMsgError := ""
    
    // Local cProduto  := Alltrim(cValToChar(GetMV("MV_#FAT631",,"801607")))
    // Local oCabec    := oModel:GetModel("MD_MASTER")
    // Local cPedCTE   := oModel:GetValue("MD_MASTER", "ZIN_PEDCTE")
    // Local cItPCCTE  := oModel:GetValue("MD_MASTER", "ZIN_ITPCCT")

    //Validação NF.

        If Empty(cNF) .Or. Empty(cSerie) .Or. Empty(dEmiss) .Or. Empty(cFornec) .Or. Empty(cLoja) .Or. Empty(cNome) .Or. Empty(dReceb)//.Or. Empty(cPlaca)
            lRet := .F.
            Help(Nil, Nil, "Função gridFocus(ADFAT063P)", Nil, "Necessário informar os dados do cabeçalho NF.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        //Valida nota fiscal.
        If nOperation == MODEL_OPERATION_INSERT .And. U_ADFAT638(cNF, cSerie, cFornec, cLoja) 
            lRet := .F.
            Help(Nil, Nil, "gridFocus(ADFAT063P)", Nil, "Documento já lançado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        //Valida se já há entrada de matéria-prima vinculada à NF.
        If nOperation == MODEL_OPERATION_INSERT .And. ( U_ADFAT639(cNF, cSerie, cFornec, cLoja) .Or. (! Empty(cChave) .And. U_ADFAT63A(cChave)) )
            lRet := .F.
            Help(Nil, Nil, "Função gridFocus(ADFAT063P)",,"Nota fiscal já lançada na entrada de matéria-prima.", 1, 0 )

        EndIf

        If ! Empty(cChave) .And. ! vldChave(cChave, cNF, cSerie, cFornec, cLoja, dEmiss, @cMsgError)
            lRet := .F.
            Help(Nil, Nil, "Função gridFocus(ADFAT063P)",, cMsgError, 1, 0 )

        EndIf

        If ! lRet .And. Valtype(oView) == "O"
            oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIN_DOC"):OCtrl:SetFocus()
            RestArea(aArea)
            Return .F.

        EndIf

    //Validação de CT-e.

        // If (nOperation == MODEL_OPERATION_INSERT .Or. nOperation == MODEL_OPERATION_UPDATE) .And. ! Empty(cPedCTE) .And. ! prcPdCT(oCabec, cPedCTE, cItPCCTE, cProduto)
        //     lRet := .F.
        //     Help(Nil, Nil, "Função gridFocus(ADFAT063P)", Nil, "Pedido de compra de CT-e inválido.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        // EndIf

        // If ! lRet .And. Valtype(oView) == "O"
        //     oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIN_DOCTE"):OCtrl:SetFocus()
        //     RestArea(aArea)
        //     Return .F.

        // EndIf

    RestArea(aArea)
        
Return lRet
/*/{Protheus.doc} vldExclusao
    Valida exclusão.
    @type  Function
    @author Everson
    @since 14/11/2022
    @version 01
/*/
User Function ADFAT63B(oModel, cMsgError)

    //Variáveis.
    Local lRet       := .T.
    Local nAux       := 1
    Local oModelGRID := oModel:GetModel("MD_GRID")
    Local nLinhas    := oModelGRID:Length()
    Local cNmOrdem   := ""

    Local nLinha     := oModelGRID:GetLine()

    Default cMsgError:= ""

    Begin Transaction

        For nAux := 1 To nLinhas

            oModelGRID:GoLine(nAux) 

            If oModelGRID:IsDeleted()
                Loop

            EndIf

            cNmOrdem := oModelGRID:GetValue("ZIN_ORDPES")

            If lRet .And. ! Empty(cNmOrdem) .And. U_ADFAT16A(cNmOrdem) //Posiciona na ordem de pesagem.

                If ! U_ADFAT179(ZIF->ZIF_PLACA, ZIF->ZIF_CTPATI, "", .F.) //Verifica se há controle de pátio aberto para placa informada.
                    lRet := .F.
                    cMsgError := "Há controle de pátio diferente de " + ZIF->ZIF_CTPATI + " aberto para placa."
                    DisarmTransaction()
                    Break 

                EndIf

                If ! U_ADFAT16I(ZIF->ZIF_CTPATI, ZIF->ZIF_NUMERO, ZIF->ZIF_AGRUPA, @cMsgError)
                    lRet := .F.
                    DisarmTransaction()
                    Break 

                EndIf

            EndIf

        Next nAux

        oModelGRID:GoLine(nLinha)

    End Transaction

    If ! lRet .And. ! Empty(cMsgError) .And. ! Empty(cNmOrdem)
        U_ADFAT173("Exclusão de ordem : " + cMsgError, cNmOrdem, "", "PROTHEUS")

    EndIF

Return lRet
/*/{Protheus.doc} vldExclusao
    Gera ordem de pesagem.
    @type  Function
    @author Everson
    @since 14/11/2022
    @version 01
/*/
User Function ADFAT63C(cCP, cNF, cSerie, cFornec, cLoja)

    //Variávies.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cMsgError := ""
    Local cOrdem    := ""

    If ! MsgYesNo("Deseja gerar ordem de pesagem?", "Função ADFAT63C(ADFAT063P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If ! U_ADFAT639(cNF, cSerie, cFornec, cLoja)
        Help(Nil, Nil, "Função ADFAT63C(ADFAT063P)",, "Nota fiscal " + cNF + "/" + cSerie + "-" + cFornec + cLoja + " não localizada na entrada de matéria-prima.", 1, 0 )
        RestArea(aArea)
        Return .F.

    EndIf

    lRet := U_ADFAT16L(cCP, cNF, cSerie, cFornec, cLoja, @cOrdem, @cMsgError)

    If lRet 
        grvBarr("A", cNF, cSerie, cFornec, cLoja)

        Help(Nil, Nil, "Função ADFAT63C(ADFAT063P)",, "Ordens de pesagem geradas: " + xPula + cOrdem, 1, 0 )

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 31/10/2022
    @version 01
/*/
Static Function ViewDef()
    
    //Variáveis.
    Local oModel    := FWLoadModel("ADFAT063P")
    Local oView     := Nil
    Local cCampos   := getCmps()
    Local oStrMast  := FWFormStruct(2, cTbMast, {|cCampo| AllTRim(cCampo) $ cCampos .Or. cCampo = "ZIN_TESCTE" })
    Local oStrGrid  := FWFormStruct(2, cTbMast, {|cCampo| !(Alltrim(cCampo) $ cCampos) .And. cCampo <> "ZIN_TESCTE" })
    Local oStrTotal := FWCalcStruct( oModel:GetModel("ADFAT63TOT") )

    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")
    oView:AddGrid("VW_GRID",    oStrGrid, "MD_GRID",,{|| gridFocus(oView:GetModel(), oView) })
    oView:AddField("VW_CALC",   oStrTotal,"ADFAT63TOT")
 
    oView:CreateHorizontalBox("MAIN", 50)
    oView:CreateHorizontalBox("GRID", 40)
    oView:CreateHorizontalBox("CALC", 10)

    oView:SetOwnerView("VW_MASTER", "MAIN")
    oView:SetOwnerView("VW_GRID", "GRID")
    oView:SetOwnerView("VW_CALC", "CALC")

    oView:EnableControlBar(.T.)

    oView:AddIncrementField("VW_GRID", "ZIN_ITEM")

    If U_ADFAT63Q() 
        oView:AddUserButton("Pedido Compra"     ,"",{|oView| U_ADFAT630(oView) } ,"",, {MODEL_OPERATION_INSERT ,MODEL_OPERATION_UPDATE} , .T. ) 

    EndIf

    oView:AddUserButton("Pedido Compra CT-e","",{|oView| U_ADFAT63N(oView) } ,"",, {MODEL_OPERATION_INSERT ,MODEL_OPERATION_UPDATE} , .T. ) 

    //Ticket 90938 - Jonathan 05/04/2023
    oView:AddUserButton("Consulta Pedido Compra","",{|oView| U_ADFAT63Z(oView) } ,"",,, .T. ) 

    If ! U_ADFAT63Q() 

        oModel:GetModel("MD_GRID"):SetNoDeleteLine(.T.)
        oModel:GetModel("MD_GRID"):SetNoInsertLine(.T.)
        oModel:GetModel('MD_GRID'):SetNoUpdateLine(.T.)

    EndIf

    oView:SetFieldAction("ZIN_VLFRT",  { |oView, cIDView, cField, xValue| atlQtd(oView), oView:Refresh() })

    oView:SetFieldAction("ZIN_DCTO",   { |oView, cIDView, cField, xValue| atlQtd(oView), U_ADFAT63U(oModel, .T.), oView:Refresh() })

    oView:SetFieldAction("ZIN_OUTROS", { |oView, cIDView, cField, xValue| atlQtd(oView), oView:Refresh() })

Return oView
/*/{Protheus.doc} atlQtd
    Atribui valor total.
    @type  Static Function
    @author Everson
    @since 17/01/2023
    @version 01
/*/
Static Function atlQtd(oView)

    //Variáveis.
    Local oModel := oView:GetModel()
    Local nTotal := U_ADFAT63J(oModel:GetModel())
    
    oModel:SetValue("ADFAT63TOT", "ZIN_VLRTOT", nTotal)

Return Nil
/*/{Protheus.doc} User Function ADFAT63Q
    Função para habilitar e desabilitar campo do cabeçalho da NF.
    @type  Function
    @author Everson
    @since 13/01/2023
    @version 01
/*/
User Function ADFAT63Q()
Return !(ALTERA .And. ZIN->ZIN_STATUS == "6" )
/*/{Protheus.doc} vldChave
    Valida chave x NF, série, fornecedor e loja.
    @type  Static Function
    @author Everson
    @since 14/11/2022
    @version 01
/*/
Static Function vldChave(cChave, cNF, cSerie, cFornec, cLoja, dEmiss, cMsgError)

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := sqlTabXML(cChave)
    Local cNewAlias := GetNextAlias()
    Local cCNPJSA2  := ""
    Local cFornO    := ""
    Local cLojaO    := ""
    Local cTpNFE    := Alltrim(cValToChar(GetMv("MV_#FAT633",,"55")))

    Default cMsgError := ""

    DbSelectArea("SA2")
    SA2->(DbSetOrder(1))
    SA2->(DbGoTop())
    If ! SA2->( DbSeek( FWxFilial("SA2") + cFornec + cLoja ) )
        cMsgError := "Fornecedor não localizado: " + cFornec + cLoja + "."
        RestArea(aArea)
        Return .F.

    EndIf

    cCNPJSA2 := Alltrim(cValToChar(SA2->A2_CGC)) 

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)

    (cNewAlias)->(DbGoTop())

    If (cNewAlias)->(Eof())

        If ! (Substr(cChave, 21, 2) $cTpNFE)
            cMsgError := "Modelo da NF constante na chave diverge do modelo de NF-e." + xPula + xPula + "Chave: " + Substr(cChave, 21, 2)
            (cNewAlias)->(DbCloseArea())
            RestArea(aArea)
            Return .F.

        EndIf

        If Empty(dEmiss)
           cMsgError := "Necessário informar a emissão da NF."
            (cNewAlias)->(DbCloseArea())
            RestArea(aArea)
            Return .F.

        EndIf

        If Right((Year2Str(dEmiss) + Month2Str(dEmiss)),4) <> Substr(cChave, 3, 4)
            cMsgError := "Verifique a emissão da NF." + xPula + xPula + "Emissão informada (AA/MM): " + (Year2Str(dEmiss) + Month2Str(dEmiss)) + xPula + "Emissão chave (AA/MM): " + Substr(cChave, 3, 4)
            (cNewAlias)->(DbCloseArea())
            RestArea(aArea)
            Return .F.

        EndIf

        If (Padl(Alltrim(cValToChar(cSerie)), 3, "0") + cNF) <> Substr(cChave, 23, 12)
            cMsgError := "Verifique a série e número." + xPula + xPula + "Série + número informados: " + (Padl(Alltrim(cValToChar(cSerie)), 3, "0") + cNF) + xPula + "Série + número chave: " + Substr(cChave, 23, 12)
            (cNewAlias)->(DbCloseArea())
            RestArea(aArea)
            Return .F.

        EndIf
        
        If ! IsInCallStack("vldPos")
            cMsgError := "Chave NF-e não localizada: " + cChave + "."

        EndIf

        (cNewAlias)->(DbCloseArea())
        RestArea(aArea)
        Return .T.

    EndIf

    If Alltrim(cValToChar(cSerie + cNF)) <> Alltrim(cValToChar((cNewAlias)->XML_NUMNF))
        cMsgError := "Chave não corresponde à NF: " + cNF + cSerie + "."
        (cNewAlias)->(DbCloseArea())
        RestArea(aArea)
        Return .F.

    EndIf

    cFornO := Posicione("SA2", 3, FWxFilial("SA2") + Alltrim(cValToChar((cNewAlias)->XML_EMIT)) , "A2_COD")
    cLojaO := Posicione("SA2", 3, FWxFilial("SA2") + Alltrim(cValToChar((cNewAlias)->XML_EMIT)) , "A2_LOJA")

    If cCNPJSA2 <> Alltrim(cValToChar((cNewAlias)->XML_EMIT)) .And. ! U_ADFAT635("", cFornec, cLoja, cFornO, cLojaO)
        cMsgError := "Chave não corresponde ao fornecedor: " + cFornec + cLoja  + "."
        (cNewAlias)->(DbCloseArea())
        RestArea(aArea)
        Return .F.

    EndIf

    (cNewAlias)->(DbCloseArea())

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} getCmps
    Função retorna campos do cabeçalho.
    @type  Static Function
    @author Everson
    @since 31/10/2022
    @version 01
/*/
Static Function getCmps()
Return "ZIN_FILIAL;ZIN_CHAVE;ZIN_DOC;ZIN_SERIE;ZIN_EMISS;ZIN_FORNEC;ZIN_LOJA;ZIN_NOME;ZIN_FORMUL;ZIN_ESPECI;ZIN_CTPATI;ZIN_PLACA;ZIN_CHVCTE;ZIN_DOCTE;ZIN_SERCTE;ZIN_FORCTE;ZIN_LOJCTE;ZIN_NMCTE;ZIN_VLFRT;ZIN_DTRECE;ZIN_NATCTE;ZIN_EMISCT;ZIN_VLRCTE;ZIN_DCTO;ZIN_OUTROS"
/*/{Protheus.doc} ADFAT57
    Ponto de entrada.
    @type  User Function
    @author Everson
    @since 31/10/2022
    @version 01
/*/
User Function ADFAT63()

    //Variáveis.
    Local aArea     := GetArea()
	Local aParam	:= PARAMIXB
	Local xRet 		:= .T.
	Local oObj 		:= ""
	Local cIdPonto 	:= ""
	Local cIdModel 	:= ""
    Local oModelx   := Nil
    Local nOperation:= 0

    Local cNF       := ""
    Local cSerie    := ""
    Local cFornec   := ""
    Local cLoja     := ""

	If aParam <> Nil

		oObj 	    := aParam[1]
		cIdPonto    := aParam[2]
		cIdModel    := aParam[3]
        nOperation  := oObj:GetOperation()

		If cIdPonto == "MODELCOMMITNTTS"

            oModelx := FWModelActive()

            If ValType(oModelx) == "O"

                cNF     := oModelx:GetValue("MD_MASTER", "ZIN_DOC")
                cSerie  := oModelx:GetValue("MD_MASTER", "ZIN_SERIE")
                cFornec := oModelx:GetValue("MD_MASTER", "ZIN_FORNEC")
                cLoja   := oModelx:GetValue("MD_MASTER", "ZIN_LOJA")

                If nOperation == MODEL_OPERATION_INSERT
                    cOperacao := "I"

                ElseIf nOperation == MODEL_OPERATION_UPDATE
                    cOperacao := "A"

                ElseIf nOperation == MODEL_OPERATION_DELETE
                    cOperacao := "D"

                EndIf

                If ! Empty(cOperacao) .And. ! Empty(cNF) .And. ! Empty(cSerie) .And. ! Empty(cFornec) .And. ! Empty(cLoja)
                    grvBarr(cOperacao, cNF, cSerie, cFornec, cLoja)

                EndIf

            EndIf

		EndIf

	EndIf

    RestArea(aArea)

Return xRet
/*/{Protheus.doc} grvBarr
    Salva o registro para enviar ao barramento.
    @type  Static Function
    @author Everson
    @since 31/10/2022
    @version 01
/*/
Static Function grvBarr(cOperacao, cNF, cSerie, cFornec, cLoja)

    //Variáveis.
    Local aArea     := GetArea()
    Local cFilter   := ""
    Local cCmp      := "ZIN_TESCTE;" + getCmps()
    Local cNumero   := cNF + cSerie + cFornec + cLoja
    
    cFilter := " ZIN_FILIAL ='" + FWxFilial("ZIN") + "' .And. ZIN_DOC = '" + cNF + "' .And. ZIN_SERIE = '" + cSerie + "' .And. ZIN_FORNEC = '" + cFornec + "' .And. ZIN_LOJA = '" + cLoja + "' "

    U_ADFAT27D("ZIN", 1, FWxFilial("ZIN") + cNumero,;
        "ZIN", 3, FWxFilial("ZIN") + cNumero, "ZIN_ITEM", cFilter,;
        "entradas_materia_prima_protheus", cOperacao,;
        .T., .T., .T.,;
        cCmp)
 
    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADFAT630
    Consulta padrão para pedido de compra.
    @type  Function
    @author Everson
    @since 03/11/2022
    @version 01
/*/
User Function ADFAT630(oView)

    //Variáveis.
    Local aArea     := GetArea()
    Local oDlg      := Nil 
    Local oLbx      := Nil
    Local aCpos     := {}
    Local aRet      := {}
    Local cQuery    := ""
    Local cAlias    := GetNextAlias()
    Local lRet      := .F.
    Local oCabec    := oView:GetModel("MD_MASTER")
    Local oGrid     := oView:GetModel("MD_GRID")
    Local nLinha    := oGrid:GetLine()
    Local cNomeF    := ""

    Local cFornec   := Alltrim(cValToChar(oCabec:GetValue("ZIN_FORNEC")))
    Local cLoja     := Alltrim(cValToChar(oCabec:GetValue("ZIN_LOJA")))
    Local cProduto  := Alltrim(cValToChar(oGrid:GetValue("ZIN_PRODUT")))

    Local cPreco    := ""
    Local cSaldo    := ""
    Local nSaldo    := 0
    Local cStatus   := ""

    If Empty(cFornec) .Or. Empty(cLoja) .Or. Empty(cProduto)
        MsgInfo("Necessário informar fornecedor e produto.", "Função ADFAT630(ADFAT063P)")
        RestArea(aArea)
        Return Nil

    EndIf

    cQuery := " SELECT "
    cQuery += " C7_NUM, C7_FORNECE, C7_LOJA, C7_PRODUTO, C7_DESCRI, C7_ITEM, C7_PRECO, C7_QUANT - C7_QUJE AS SALDO, C7_CONAPRO "
        cQuery += " FROM " + RetSqlName("SC7") + " (NOLOCK) AS SC7 "
    cQuery += " WHERE "
        cQuery += " C7_FILIAL = '" + FWxFilial("SC7") + "' "
        cQuery += " AND C7_FORNECE = '" + cFornec  + "' "
        cQuery += " AND C7_LOJA = '"   + cLoja    + "' "
        cQuery += " AND C7_PRODUTO = '" + cProduto + "' "
        cQuery += " AND C7_QUANT > C7_QUJE AND C7_RESIDUO = '' AND SC7.D_E_L_E_T_ = '' "
        //cQuery += "  AND C7_CONAPRO = 'L'  "
        cQuery += " AND C7_ENCER <> 'E' " //Everson - 09/01/2023 - Ticket 18465. 
        cQuery += " AND C7_OBS <> 'SAG' " //Everson - 09/01/2023 - Ticket 18465. 

    cQuery += " UNION ALL "

    cQuery += " SELECT "
    cQuery += " C7_NUM, C7_FORNECE, C7_LOJA, C7_PRODUTO, C7_DESCRI, C7_ITEM, C7_PRECO, C7_QUANT - C7_QUJE AS SALDO, C7_CONAPRO "
        cQuery += " FROM " + RetSqlName("SC7") + " (NOLOCK) AS SC7 "
    cQuery += " WHERE "
        cQuery += " C7_FILIAL = '" + FWxFilial("SC7") + "' "
        cQuery += " AND C7_FORNECE + C7_LOJA IN ( "

            cQuery += " SELECT " 
                cQuery += " DISTINCT CPW_CODIGO + CPW_LOJA AS CODLOJA " 
            cQuery += " FROM  " 
                cQuery += " " + RetSqlName("CPW") + " (NOLOCK) AS CPW  " 
                cQuery += " INNER JOIN " 
                cQuery += " " + RetSqlName("CPX") + " (NOLOCK) AS CPX ON " 
                cQuery += " CPW_FILIAL = CPX_FILIAL " 
                cQuery += " AND CPW_CODIGO = CPX_CODIGO " 
                cQuery += " AND CPW_LOJA = CPX_LOJA " 
            cQuery += " WHERE " 
                cQuery += " CPW_FILIAL = '" + FWxFilial("CPW") + "' " 
                cQuery += " AND CPX_CODFOR = '" + cFornec + "' " 
                cQuery += " AND CPX_LOJFOR = '" + cLoja + "' " 
                cQuery += " AND CPW.D_E_L_E_T_ = '' " 
                cQuery += " AND CPX.D_E_L_E_T_ = '' " 

        cQuery += " ) "
        cQuery += " AND C7_PRODUTO = '" + cProduto + "' "
        cQuery += " AND C7_QUANT > C7_QUJE AND C7_RESIDUO = '' AND SC7.D_E_L_E_T_ = '' "
        //cQuery += " AND C7_CONAPRO = 'L'  "
        cQuery += " AND C7_ENCER <> 'E' " //Everson - 09/01/2023 - Ticket 18465. 
        cQuery += " AND C7_OBS <> 'SAG' " //Everson - 09/01/2023 - Ticket 18465. 

    cQuery += " ORDER BY C7_NUM "

    cQuery := ChangeQuery(cQuery)

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

    While (cAlias)->(!Eof())

        cNomeF := Alltrim(cValToChar(Posicione("SA2", 1, FWxFilial("SA2") + (cAlias)->C7_FORNECE + (cAlias)->C7_LOJA, "A2_NOME")))

        cPreco := Alltrim(cValToChar( Transform((cAlias)->C7_PRECO, "@E 999,999,999.9999") ))

        nSaldo := U_ADFAT63F((cAlias)->C7_NUM, (cAlias)->C7_ITEM, "NF", .T.)

        If nSaldo <= 0
            (cAlias)->(DbSkip())
            Loop

        EndIf

        cSaldo  := Alltrim(cValToChar( Transform(nSaldo, "@E 999,999,999.999") ))
        cStatus := Iif((cAlias)->C7_CONAPRO == "L", "Liberado", "Bloqueado")

        Aadd(aCpos,{ cStatus, (cAlias)->C7_NUM, (cAlias)->C7_FORNECE, cNomeF, (cAlias)->C7_LOJA, (cAlias)->C7_PRODUTO, (cAlias)->C7_DESCRI, (cAlias)->C7_ITEM, cPreco, cSaldo })

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    If Len(aCpos) < 1
        Aadd(aCpos,{" ", " ", " ", " ", " ", " ", " ", " ", " ", " "})

    EndIf

    DEFINE MSDIALOG oDlg TITLE /*STR0083*/ "Pedido de Compra" FROM 0,0 TO 240,500 PIXEL

        @ 10,10 LISTBOX oLbx FIELDS HEADER "Status", "Pedido", "Cod", "Loja", "Nome", "Produto", "Desc", "Item", "Prc Unt", "Saldo" SIZE 230,95 OF oDlg PIXEL

        oLbx:SetArray( aCpos )
        oLbx:bLine     := {|| {aCpos[oLbx:nAt,1], aCpos[oLbx:nAt,2], aCpos[oLbx:nAt,3], aCpos[oLbx:nAt,4], aCpos[oLbx:nAt,5], aCpos[oLbx:nAt,6], aCpos[oLbx:nAt,7], aCpos[oLbx:nAt,8], aCpos[oLbx:nAt,9], aCpos[oLbx:nAt,10] }}
        oLbx:bLDblClick := {|| {oDlg:End(), lRet:=.T., aRet := { oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,8] }}}

    DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (oDlg:End(), lRet:=.T., aRet := { oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,8] })  ENABLE OF oDlg
    ACTIVATE MSDIALOG oDlg CENTER

    If Len(aRet) > 0 .And. lRet

        If ! Empty(aRet[1])
            procPedC(oGrid, aRet[1], aRet[2], nLinha)

        EndIf

    EndIf

    RestArea(aArea)

Return Nil

/*/{Protheus.doc} User Function ADFAT63Z
    Consultar todos os pedido de compra.
    @type  Function
    @author Jonathan Carvalho
    @since 05/04/2023
    @version 01
/*/
User Function ADFAT63Z(oView)

    //Variáveis.
    Local aArea     := GetArea()
    Local oDlg      := Nil 
    Local oLbx      := Nil
    Local aCpos     := {}
    //Local aRet      := {}
    Local cQuery    := ""
    Local cAlias    := GetNextAlias()
    //Local lRet      := .F.
    Local oCabec    := oView:GetModel("MD_MASTER")
    Local oGrid     := oView:GetModel("MD_GRID")
    //Local nLinha    := oGrid:GetLine()
    Local cNomeF    := ""

    Local cFornec   := Alltrim(cValToChar(oCabec:GetValue("ZIN_FORNEC")))
    Local cLoja     := Alltrim(cValToChar(oCabec:GetValue("ZIN_LOJA")))
    //Local cForCte   := Alltrim(cValToChar(oCabec:GetValue("ZIN_FORCTE")))
    //Local cLojCte   := Alltrim(cValToChar(oCabec:GetValue("ZIN_LOJCTE")))
    //Local cProduto  := Alltrim(cValToChar(oGrid:GetValue("ZIN_PRODUT")))
    Local cPedProd  := Alltrim(cValToChar(oGrid:GetValue("ZIN_PEDCOM")))

    Local cPreco    := ""
    Local cSaldo    := ""
    Local nSaldo    := 0
    Local cStatus   := ""

    
    If Empty(cFornec) .Or. Empty(cLoja) //.Or. Empty(cProduto)
        MsgInfo("Necessário informar fornecedor.", "Função ADFAT63Z(ADFAT063P)")
        RestArea(aArea)
        Return Nil

    EndIf

    //Jonathan Carvalho, 15/05/2023 - Ticket 92507
    cContrato := Posicione("SC7", 1, FWxFilial("SC7") + cPedProd, "C7_XCTRCOM")
    cItemCrt  := Posicione("SC7", 1, FWxFilial("SC7") + cPedProd, "C7_XCTRVER")

    //Jonathan Carvalho, 15/05/2023 - Ticket 92507
    If Empty(cPedProd)
    
        cQuery := " SELECT "
        cQuery += " C7_NUM, C7_FORNECE, C7_LOJA, C7_PRODUTO, C7_DESCRI, C7_ITEM, C7_PRECO, C7_QUANT - C7_QUJE AS SALDO, C7_CONAPRO, "
        cQuery += " CASE WHEN C7_MOEDA = '1' THEN 'REAL' WHEN C7_MOEDA = '2' THEN 'DOLAR' WHEN C7_MOEDA = '4' THEN 'EURO' ELSE '' END AS C7_MOEDA "
            cQuery += " FROM " + RetSqlName("SC7") + " (NOLOCK) AS SC7 "
        cQuery += " WHERE "
            cQuery += " C7_FILIAL = '" + FWxFilial("SC7") + "' "
            cQuery += " AND C7_FORNECE = '" + cFornec  + "' "
            cQuery += " AND C7_LOJA = '"   + cLoja    + "' "
            cQuery += " AND C7_CC = '8006' "
            cQuery += " AND C7_QUANT > C7_QUJE AND C7_RESIDUO = '' AND SC7.D_E_L_E_T_ = '' "
            //cQuery += "  AND C7_CONAPRO = 'L'  "
            cQuery += " AND C7_ENCER <> 'E' " 
            cQuery += " AND C7_OBS <> 'SAG' "  

        cQuery += " UNION ALL "

        cQuery += " SELECT "
        cQuery += " C7_NUM, C7_FORNECE, C7_LOJA, C7_PRODUTO, C7_DESCRI, C7_ITEM, C7_PRECO, C7_QUANT - C7_QUJE AS SALDO, C7_CONAPRO, "
        cQuery += " CASE WHEN C7_MOEDA = '1' THEN 'REAL' WHEN C7_MOEDA = '2' THEN 'DOLAR' WHEN C7_MOEDA = '4' THEN 'EURO' ELSE '' END AS C7_MOEDA "
            cQuery += " FROM " + RetSqlName("SC7") + " (NOLOCK) AS SC7 "
        cQuery += " WHERE "
            cQuery += " C7_FILIAL = '" + FWxFilial("SC7") + "' "
            cQuery += " AND C7_FORNECE + C7_LOJA IN ( "

                cQuery += " SELECT " 
                    cQuery += " DISTINCT CPW_CODIGO + CPW_LOJA AS CODLOJA " 
                cQuery += " FROM  " 
                    cQuery += " " + RetSqlName("CPW") + " (NOLOCK) AS CPW  " 
                    cQuery += " INNER JOIN " 
                    cQuery += " " + RetSqlName("CPX") + " (NOLOCK) AS CPX ON " 
                    cQuery += " CPW_FILIAL = CPX_FILIAL " 
                    cQuery += " AND CPW_CODIGO = CPX_CODIGO " 
                    cQuery += " AND CPW_LOJA = CPX_LOJA " 
                cQuery += " WHERE " 
                    cQuery += " CPW_FILIAL = '" + FWxFilial("CPW") + "' " 
                    cQuery += " AND CPX_CODFOR = '" + cFornec  + "' " 
                    cQuery += " AND CPX_LOJFOR = '"   + cLoja    + "' " 
                    cQuery += " AND CPW.D_E_L_E_T_ = '' " 
                    cQuery += " AND CPX.D_E_L_E_T_ = '' " 

            cQuery += " ) "
            cQuery += " AND C7_CC = '8006' "
            cQuery += " AND C7_QUANT > C7_QUJE AND C7_RESIDUO = '' AND SC7.D_E_L_E_T_ = '' "
            //cQuery += " AND C7_CONAPRO = 'L'  "
            cQuery += " AND C7_ENCER <> 'E' " 
            cQuery += " AND C7_OBS <> 'SAG' " 
            
    //Jonathan Carvalho, 15/05/2023 - Ticket 92507
    Else

        cQuery := " SELECT "
        cQuery += " C7_NUM, C7_FORNECE, C7_LOJA, C7_PRODUTO, C7_DESCRI, C7_ITEM, C7_PRECO, C7_QUANT - C7_QUJE AS SALDO, C7_CONAPRO,  "
        cQuery += " CASE WHEN C7_MOEDA = '1' THEN 'REAL' WHEN C7_MOEDA = '2' THEN 'DOLAR' WHEN C7_MOEDA = '4' THEN 'EURO' ELSE '' END AS C7_MOEDA "
            cQuery += " FROM " + RetSqlName("SC7") + " (NOLOCK) AS SC7 "
        cQuery += " WHERE "
            cQuery += " C7_FILIAL = '" + FWxFilial("SC7") + "' "
            //cQuery += " AND C7_FORNECE = '" + cFornec  + "' "
            //cQuery += " AND C7_LOJA = '"   + cLoja    + "' "
            cQuery += " AND C7_PRODUTO = '801607' "
            cQuery += " AND C7_QUANT > C7_QUJE AND C7_RESIDUO = '' AND SC7.D_E_L_E_T_ = '' "
            //cQuery += "  AND C7_CONAPRO = 'L' "
            cQuery += " AND C7_ENCER <> 'E' "
            cQuery += " AND C7_OBS <> 'SAG' " 
            cQuery += " AND C7_XCTRCOM+C7_XCTRVER = '" + cContrato + cItemCrt + "' " 

    EndIf

    cQuery += " ORDER BY C7_NUM "

    cQuery := ChangeQuery(cQuery)

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

    While (cAlias)->(!Eof())

        cNomeF := Alltrim(cValToChar(Posicione("SA2", 1, FWxFilial("SA2") + (cAlias)->C7_FORNECE + (cAlias)->C7_LOJA, "A2_NOME")))

        cPreco := Alltrim(cValToChar( Transform((cAlias)->C7_PRECO, "@E 999,999,999.9999") ))

        nSaldo := U_ADFAT63F((cAlias)->C7_NUM, (cAlias)->C7_ITEM, "NF", .T.)

        If nSaldo <= 0
            (cAlias)->(DbSkip())
            Loop

        EndIf

        cSaldo  := Alltrim(cValToChar( Transform(nSaldo, "@E 999,999,999.999") ))
        cStatus := Iif((cAlias)->C7_CONAPRO == "L", "Liberado", "Bloqueado")

        Aadd(aCpos,{ cStatus, (cAlias)->C7_NUM, (cAlias)->C7_FORNECE, cNomeF, (cAlias)->C7_LOJA, (cAlias)->C7_PRODUTO, (cAlias)->C7_DESCRI, (cAlias)->C7_ITEM, (cAlias)->C7_MOEDA, cPreco, cSaldo })

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    If Len(aCpos) < 1
        Aadd(aCpos,{" ", " ", " ", " ", " ", " ", " ", " ", " ", " "})

    EndIf

    DEFINE MSDIALOG oDlg TITLE /*STR0083*/ "Pedido de Compra" FROM 0,0 TO 240,500 PIXEL

        @ 10,10 LISTBOX oLbx FIELDS HEADER "Status", "Pedido", "Cod", "Loja", "Nome", "Produto", "Desc", "Item", "Moeda", "Prc Unt", "Saldo" SIZE 230,95 OF oDlg PIXEL

        oLbx:SetArray( aCpos )
        oLbx:bLine     := {|| {aCpos[oLbx:nAt,1], aCpos[oLbx:nAt,2], aCpos[oLbx:nAt,3], aCpos[oLbx:nAt,4], aCpos[oLbx:nAt,5], aCpos[oLbx:nAt,6], aCpos[oLbx:nAt,7], aCpos[oLbx:nAt,8], aCpos[oLbx:nAt,9], aCpos[oLbx:nAt,10] }}
        //oLbx:bLDblClick := {|| {oDlg:End(), lRet:=.T., aRet := { oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,8] }}}

    //DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (oDlg:End(), lRet:=.T., aRet := { oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,8] })  ENABLE OF oDlg
    ACTIVATE MSDIALOG oDlg CENTER

    /*
    If Len(aRet) > 0 .And. lRet

        If ! Empty(aRet[1])
            procPedC(oGrid, aRet[1], aRet[2], nLinha)

        EndIf

    EndIf
    */

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} procPedC
    Atribui pedido de compra.
    @type  Static Function
    @author Everson
    @since 03/11/2022
    @version 01
/*/
Static Function procPedC(oGrid, cPedido, cItem, nLinha)

    //Variáveis.
    Local aArea     := GetArea()
    Local nQuant    := 0

    limpCTE(oGrid)

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbGoTop())
    If ! SC7->(DbSeek( FWxFilial("SC7") + cPedido + cItem ))
        Help(Nil, Nil, "Função procPedC(ADFAT063P)", Nil, "Pedido " + cPedido + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    //Retorna saldo do pedido de compra.
    nQuant := U_ADFAT63F(cPedido, cItem, "NF")

    oGrid:GoLine(nLinha)

    If SC7->C7_CONAPRO <> 'L' 
        oGrid:SetValue("ZIN_QUANT" , 0)
        oGrid:SetValue("ZIN_VLRUNT", 0)
        oGrid:SetValue("ZIN_TOTAL" , 0)
        oGrid:SetValue("ZIN_PEDCOM", "")
        oGrid:SetValue("ZIN_ITEMPC", "")
        oGrid:SetValue("ZIN_CONDPA", "")

        MsgInfo("Pedido " + cPedido + " não está liberado.", "Função procPedC(ADFAT063P)")

        RestArea(aArea)
        Return .F.

    EndIf

    If nQuant < 0

        oGrid:SetValue("ZIN_QUANT" , 0)
        oGrid:SetValue("ZIN_VLRUNT", 0)
        oGrid:SetValue("ZIN_TOTAL" , 0)
        oGrid:SetValue("ZIN_PEDCOM", "")
        oGrid:SetValue("ZIN_ITEMPC", "")
        oGrid:SetValue("ZIN_CONDPA", "")

        RestArea(aArea)
        Return .F.

    EndIf

    nTotal := nQuant * SC7->C7_PRECO

    If oGrid:GetValue("ZIN_QUANT") == 0 .And. oGrid:GetValue("ZIN_VLRUNT") == 0 .And. oGrid:GetValue("ZIN_TOTAL") == 0

        oGrid:SetValue("ZIN_QUANT" , nQuant)
        oGrid:SetValue("ZIN_VLRUNT", SC7->C7_PRECO)
        oGrid:SetValue("ZIN_TOTAL" , nTotal)

    EndIf

    oGrid:SetValue("ZIN_PEDCOM", SC7->C7_NUM)
    oGrid:SetValue("ZIN_ITEMPC", SC7->C7_ITEM)
    oGrid:SetValue("ZIN_CONDPA", SC7->C7_COND)

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADFAT631
    Formata número da NF.
    @type  Function
    @author Everson
    @since 03/11/2022
    @version 01
/*/
User Function ADFAT631()

    //Variáveis.
    Local cDoc := Alltrim(cValToChar(M->ZIN_DOC ))
    
    If ! Empty(cDoc)
        FWFldPut("ZIN_DOC", Padl(cDoc, 9, "0"))

    EndIf

Return .T.
/*/{Protheus.doc} User Function ADFAT632
    Carrega informações da Central XML.
    @type  Function
    @author Everson
    @since 09/11/2022
    @version 01
/*/
User Function ADFAT632(cChave) // U_ADFAT632(M->ZIN_CHAVE)

    //Variáveis.
    Local aArea     := GetArea()
    Local cXmlAtu   := ""
    Local cFCNPJ    := ""
    Local cPlaca    := ""
    Local cFornec   := ""
    Local cLoja     := ""
    Local cNmF      := ""
    Local dEmissao  := Nil
    Local aDados    := {}
    Local aFiliais  := FWLoadSM0()
    Local nPosFil   := Ascan(aFiliais, {|x| x[01] == cEmpAnt .And. Alltrim(x[02]) == cFilAnt })
    Local cCGCFil   := Alltrim(cValToChar(aFiliais[nPosFil][18]))

    cChave := Alltrim(cValToChar(cChave))

    If Empty(cChave)
        RestArea(aArea)
        Return .T.

    EndIf

    If Len(cChave) <> 44

        cabecNF("", "", "", CToD(" / / "), "", "", "")

        U_ADEST732()

        Help(Nil, Nil, "ADFAT632 (ADFAT063P)", Nil, "A chave precisa ter 44 caracteres.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    DbSelectArea("SF1")
    SF1->(DbSetOrder(8))
    SF1->(DbGoTop())
    If SF1->( DbSeek( FWxFilial("SF1") + cChave ) )
        
        cabecNF("", "", "", CToD(" / / "), "", "", "")

        U_ADEST732()

        Help(Nil, Nil, "ADFAT632 (ADFAT063P)", Nil, "Documento já lançado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If INCLUI .And. U_ADFAT63A(cChave)

        cabecNF("", "", "", CToD(" / / "), "", "", "")

        U_ADEST732()

        Help(Nil, Nil, "ADFAT632 (ADFAT063P)", Nil, "Chave já consta na entrada de matéria-prima.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    U_DbSelArea( "RECNFXML", .F., 1 )
	DbSeek( cChave )

    If ! DbSeek( cChave )

        If ! IsInCallStack("vldPos")
            // cabecNF("", "", "", CToD(" / / "), "", "", "")

            // U_ADEST732()

            MsgInfo("Chave NF-e " + cChave + " não localizada.", "Função ADFAT632(ADFAT063P)")

        EndIf

        RestArea(aArea)
        Return .T.

    EndIf

    If cCGCFil <> Alltrim(cValToChar(RECNFXML->XML_DEST))

        cabecCTE("", "", "", "", "", "")

        U_ADEST732()

        Help(Nil, Nil, "ADFAT632 (ADFAT063P)", Nil, "Chave " + cChave + " não pertence a filial corrente.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    cXmlAtu	:= RECNFXML->XML_ARQ
    cFCNPJ  := RECNFXML->XML_EMIT

    DbSelectArea("SA2")
    SA2->(DbSetOrder(3))
    SA2->(DbGoTop())

    If ! SA2->(DbSeek( FWxFilial("SA2") + cFCNPJ ))

        cabecCTE("", "", "", "", "", "")

        U_ADEST732()

        Help(Nil, Nil, "ADFAT632 (ADFAT063P)", Nil, "CNPJ " + cFCNPJ + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    cFornec := SA2->A2_COD
    cLoja   := SA2->A2_LOJA
    cNmF    := SA2->A2_NOME
    aDados  := U_ADFAT637(cFornec, cLoja, cXmlAtu)

    cChave   := Alltrim(cValToChar(RECNFXML->XML_CHAVE))
    cFCNPJ   := Alltrim(cValToChar(RECNFXML->XML_EMIT))
    cSerie   := Substr(Alltrim(cValToChar(RECNFXML->XML_NUMNF)), 1, 3)
    cNF      := Substr(Alltrim(cValToChar(RECNFXML->XML_NUMNF)), 4, 12)
    dEmissao := RECNFXML->XML_EMISSA

    MsAguarde({|| U_ADFAT636( cChave, cNF, cSerie, dEmissao, cFornec, cLoja, Alltrim(cValToChar(cNmF)), cPlaca, aDados ) }, "Aguarde", "Carregando dados...")

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} sqlTabXML
    Script sql para consulta de arquivo XML.
    @type  Static Function
    @author Everson
    @since 14/11/2022
    @version 01
/*/
Static Function sqlTabXML(cChave)

    //Variáveis.
    Local cQuery := ""

    cQuery := " SELECT "

    //cQuery += " FONTE.XML_CHAVE, FONTE.XML_EMIT, FONTE.XML_NUMNF, FONTE.XML_EMISSA, FONTE.REC, CAST(FONTE.XML_ARQ AS VARCHAR) AS XML_ARQ "
    
    cQuery += " FONTE.XML_CHAVE, FONTE.XML_EMIT, FONTE.XML_NUMNF, FONTE.XML_EMISSA, FONTE.REC, '' AS XML_ARQ "
    
    cQuery += " FROM ( "

        cQuery += " SELECT  " 
            cQuery += " XML_CHAVE, XML_EMIT, XML_NUMNF, XML_EMISSA, R_E_C_N_O_ AS REC, ISNULL(CAST(CAST(XML_ARQ AS VARBINARY(MAX)) AS VARCHAR(MAX)),'') AS XML_ARQ " 
        cQuery += " FROM RECNFXML (NOLOCK)  " 
        cQuery += " WHERE " 
            cQuery += " XML_CHAVE = '" + cChave + "' AND XML_ARQCAN IS NULL" 
            cQuery += " AND D_E_L_E_T_=''  "  

    cQuery += " ) AS FONTE "

Return cQuery
/*/{Protheus.doc} User Function ADFAT637
    Obtém os itens da NF.
    @type  Function
    @author Everson
    @since 11/11/2022
    @version 01
/*/
User Function ADFAT637(cCodF, cLojaF, cXML, lItem)

    //Variáveis.
    Local aArea     := GetArea()
    Local aDados    := {}
    Local cError    := ""
    Local cWarning  := ""
    Local oXml      := XmlParser( cXML, "_", @cError, @cWarning )
    Local oProd     := Nil
    Local nCount    := 1
    Local aProduto  := {}
    Local cProd     := ""
    Local cDesc     := ""
    Local nQuant    := 0
    Local nPrcUnt   := 0
    Local nVlTot    := 0
    Local cUm       := 0
    Local nVlProd   := 0
    Local nVlNF     := 0

    Default lItem   := .T.

    If Empty(cXML)
        RestArea(aArea)
        Return aDados

    EndIf

    If (oXml == NIL )
        MsgStop("Falha ao gerar Objeto XML : " + cError + " / " + cWarning, "ADFAT637 (ADFAT063P)")
        RestArea(aArea)
        Return aDados

    Endif

    If lItem

        oProd := XmlChildEx(oXMl:_NFEPROC:_NFE:_INFNFE, "_DET")

        If ValType(oProd) == "O"

            aProduto := obtProd(cCodF, cLojaF, oProd:_PROD:_CPROD:TEXT)

            cProd    := aProduto[1]
            cDesc    := aProduto[2]
            nQuant   := Val(oProd:_PROD:_QCOM:TEXT )
            nPrcUnt  := Val(oProd:_PROD:_VUNCOM:TEXT)
            nVlTot   := Val(oProd:_PROD:_VPROD:TEXT)
            cUm      := Alltrim(cValToChar(oProd:_PROD:_UCOM:TEXT))

            Aadd(aDados, { cProd, cDesc, nQuant, nPrcUnt, nVlTot, cUm })

        ElseIf ValType(oProd) == "A"

            For nCount := 1 To Len(oProd)
                
                aProduto := obtProd(cCodF, cLojaF, oProd[nCount]:_PROD:_CPROD:TEXT)

                cProd    := aProduto[1]
                cDesc    := aProduto[2]
                nQuant   := Val(oProd[nCount]:_PROD:_QCOM:TEXT )
                nPrcUnt  := Val(oProd[nCount]:_PROD:_VUNCOM:TEXT)
                nVlTot   := Val(oProd[nCount]:_PROD:_VPROD:TEXT)
                cUm      := Alltrim(cValToChar(oProd[nCount]:_PROD:_UCOM:TEXT))

                Aadd(aDados, { cProd, cDesc, nQuant, nPrcUnt, nVlTot, cUm }) 

            Next Count

        EndIf

    Else //Cabeçalho

        nVlProd := Val(cValToChar(oXMl:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VPROD:TEXT))
        nVlNF   := Val(cValToChar(oXMl:_NFEPROC:_NFE:_INFNFE:_TOTAL:_ICMSTOT:_VNF:TEXT))
        nVlDesc := nVlProd - nVlNF
        nVlDesc := Iif(nVlDesc < 0, 0, nVlDesc)

        Aadd(aDados, {nVlProd, nVlNF, nVlDesc})

    EndIf

    FreeObj(oProd)
    oProd := Nil

    RestArea(aArea)

Return aDados
/*/{Protheus.doc} obtProd
    Retorna o código do produto Protheus.
    @type  Static Function
    @author Everson
    @since 11/11/2022
    @version 01
/*/
Static Function obtProd(cCodF, cLojaF, cProd)

    //Variáveis.
    Local aArea     := GetArea()
    Local cPrdProth := ""
    Local cDesc     := ""
    Local cQuery    := " SELECT A5_PRODUTO, A5_NOMPROD FROM " + RetSqlName("SA5") + " (NOLOCK) AS SA5 WHERE A5_FILIAL = '" + FWxFilial("SA5") + "' AND A5_FORNECE = '" + cCodF + "' AND A5_LOJA = '" + cLojaF + "' AND A5_CODPRF = '" + cProd + "' AND SA5.D_E_L_E_T_ = '' "
    Local cNewAlias := GetNextAlias()
    
    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)
    (cNewAlias)->(DbGoTop())

        If ! (cNewAlias)->(Eof())

            cPrdProth := Alltrim(cValToChar( (cNewAlias)->A5_PRODUTO ))

            If ! Empty(cPrdProth)
                cDesc     := Posicione("SB1", 1, FWxFilial("SB1") + cPrdProth, "B1_DESC")

            EndIf

        EndIf

    (cNewAlias)->(DbCloseArea())

    RestArea(aArea)

Return { cPrdProth, cDesc }
/*/{Protheus.doc} User Function ADFAT636
    Carrega dados da Central XML.
    @type  Function
    @author Everson
    @since 11/11/2022
    @version 01
/*/
User Function ADFAT636( cChave, cNF, cSerie, dEmissao, cCodF, cLojaF, cNomeF, cPlaca, aDados)

    //Variáveis.
    Local aArea     := GetArea()
    Local nAux      := 1
    Local oView     := FWViewActive()
    Local oGrid     := oView:GetModel("MD_GRID")
    Local oCabec    := oView:GetModel("MD_MASTER")

    U_ADEST732()

    oView:refresh()
    
    cCP := oCabec:GetValue("ZIN_CTPATI")

    If Len(aDados) > 0

        For nAux := 1 To Len(aDados)

            If nAux > 1
                oGrid:addLine()

            EndIf

            cabecNF(cChave, cNF, cSerie, dEmissao, cCodF, cLojaF, cNomeF, cPlaca)

            cProduto := aDados[nAux][1]
            cDesc    := aDados[nAux][2]
            nQuant   := aDados[nAux][3]
            nVlrUnit := aDados[nAux][4]
            nTotal   := aDados[nAux][5]

            oGrid:setValue("ZIN_PRODUT", cProduto)
            oGrid:setValue("ZIN_DESC"  , cDesc)
            oGrid:setValue("ZIN_QUANT" , nQuant)
            oGrid:setValue("ZIN_VLRUNT", nVlrUnit)
            oGrid:setValue("ZIN_TOTAL" , nTotal)
            oGrid:setValue("ZIN_STATUS", "1")

        Next nAux    

        oGrid:goLine(1)
        
    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} cabecNF
    Carrega dados no cabeçalho.
    @type  Static Function
    @author Everson
    @since 11/11/2022
    @version 01
/*/
Static Function cabecNF(cChave, cNF, cSerie, dEmissao, cCodF, cLojaF, cNomeF, cPlaca)

    //Variáveis.

    FWFldPut("ZIN_CHAVE" , cChave)
    FWFldPut("ZIN_DOC"   , cNF)
    FWFldPut("ZIN_SERIE" , cSerie)
    FWFldPut("ZIN_EMISS" , dEmissao)
    FWFldPut("ZIN_FORNEC", cCodF)
    FWFldPut("ZIN_LOJA"  , cLojaF)
    FWFldPut("ZIN_NOME"  , cNomeF)
    // FWFldPut("ZIN_PLACA" , cPlaca)

Return Nil
/*/{Protheus.doc} User Function ADFAT633
    Valida preço.
    @type  Function
    @author Everson
    @since 09/11/2022
    @version 01
/*/
User Function ADFAT633(oModelHEA, oModelGRID)

    //Variáveis.
    Local aArea         := GetArea()
    Local cPedPreco     := ""
    Local cNfePreco     := ""
    Local cErroVunit    := ""
    Local nAux          := 1
    Local cProduto      := ""
    Local cCodpcnf      := ""
    Local cItepcnf      := ""
    Local nVlrttnf      := 0
    Local nVlrnflc      := 0
    Local nVlrDlr       := 0
    Local cSimbMoe      := "R$"
    Local cQuery        := ""
    Local nTotPed       := 0
    Local cErroTot      := ""
    Local nPreco        := 0
    Local nLinhas       := oModelGRID:Length() 
    Local dEmissao      := oModelHEA:GetValue("MD_MASTER", "ZIN_EMISS")
    Local nPVlUnit      := (GetMv("MV_#FAT634",,0.03)/100)+1
    Local nTolTotal     := (GetMv("MV_#FAT636",,0)/100) + 1
    Local nTotNFLF      := 0

    Local nLinha        := oModelGRID:GetLine()

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))


    For nAux := 1 To nLinhas
        // 93612 - Wagner - 10/05/2023
        DbSelectArea("SM2")
        SM2->(DbSetOrder(1))

        oModelGRID:GoLine(nAux) 
         
        If oModelGRID:IsDeleted()
            Loop

        EndIf
        
        cProduto := oModelGRID:GetValue("ZIN_PRODUT")

        If oModelGRID:GetValue("ZIN_QUANT") <= 0
            Help(Nil, Nil, "ADFAT633 (ADFAT063P)", Nil, "Necessário informar a quantidade." + xPula + xPula + cProduto, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        EndIf

        nPreco   := oModelGRID:GetValue("ZIN_TOTAL")/oModelGRID:GetValue("ZIN_QUANT")

        cCodpcnf := oModelGRID:GetValue("ZIN_PEDCOM")
        cItepcnf := oModelGRID:GetValue("ZIN_ITEMPC")

        nVlrttnf := 0
        nVlrnflc := 0
        nVlrDlr  := 0
        cSimbMoe := "R$"

        If nPreco <= 0
            Loop

        EndIf

        If Empty(cCodpcnf) .Or. Empty(cItepcnf)
            Loop

        EndIf
            
        SC7->(DbGoTop())
        If ! SC7->(DbSeek( FWxFilial("SC7") + cCodpcnf + cItepcnf ))		
            Loop

        EndIf	

        SB1->(DbGoTop())
        If ! SB1->(DbSeek(FWxFilial("SB1") + SC7->C7_PRODUTO))
            Loop

        EndIf   

        nTotPed  := SC7->C7_TOTAL 

        //Valida o valor total.
        If SC7->C7_MOEDA > 1 //Moeda estrangeira.

            cSimbMoe := Alltrim(GetMv("MV_SIMB" + Str(SC7->C7_MOEDA,1),,""))
            nVlrDlr  := 0

            If SC7->C7_TXMOEDA == 0

                SM2->(DbGoTop())
                If SM2->(DbSeek(DToS(dEmissao)))

                    nVlrDlr := &("M2_MOEDA"+Str(SC7->C7_MOEDA,1))
                    
                    If nVlrDlr == 0
                        Help(Nil, Nil, "ADFAT633 (ADFAT063P)", Nil, "Pedido de compra na moeda " + Str(SC7->C7_MOEDA,1) + " sem cotacao, verifique cadastro de moedas na data: " + DToC(dEmissao) + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                        RestArea(aArea)
                        Return .F.

                    EndIf

                Else
                    Help(Nil, Nil, "ADFAT633 (ADFAT063P)", Nil, "Pedido de compra na moeda " + Str(SC7->C7_MOEDA,1) + " sem cotacao cadastrada na data: " + DToC(dEmissao) + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                    RestArea(aArea)
                    Return .F.

                EndIf

            Else
                nVlrDlr := SC7->C7_TXMOEDA

            EndIf

            cPedPreco := Transform(Round(((SC7->C7_PRECO * nPVlUnit) * nVlrDlr)*nPVlUnit,4), "@E 999,999.9999")
            cNfePreco := Transform(Round(nPreco, 4)                , "@E 999,999.9999")
            
            If cPedPreco < cNfePreco 

                cErroVunit := "Valor unitario da NF está maior que o Valor Unitario "+ xPula + "do item do Pedido (taxa)" + Alltrim(cCodpcnf) + "/" + cItepcnf + xPula +;
                              "Valor Unitario NF: R$" + cNfePreco + xPula +;
                              "Valor Unitario PC: R$" + cPedPreco + xPula +;
                              "Tolerância (MV_#FAT634): " + cValToChar(GetMv("MV_#FAT634",,0)) + "%"

                Help(Nil, Nil, "ADFAT633 (ADFAT063P)", Nil, cErroVunit, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                RestArea(aArea)
                Return .F.  
            
            EndIf

            cQuery := " SELECT F1_STATUS, D1_FILIAL, D1_PEDIDO, D1_ITEMPC, ISNULL(SUM(TOTAL/TAXA),0) D1_TOTAL "
            cQuery += " FROM ( "
            cQuery += " SELECT F1_STATUS, D1_FILIAL, D1_PEDIDO, D1_ITEMPC, D1_EMISSAO, D1_TOTAL-D1_VALDEV TOTAL,
            cQuery += " (SELECT C7_MOEDA FROM "+RetSqlName("SC7")+" C7 WHERE C7_FILIAL = '"+FWxFilial("SC7")+"' AND C7_NUM = '"+cCodpcnf+"' AND C7.D_E_L_E_T_ = ' ' ) MOEDA,"
            cQuery += " (SELECT M2_MOEDA"+STR(SC7->C7_MOEDA,1)+" FROM "+RetSqlName("SM2")+" M2 WHERE M2_DATA = D1_EMISSAO AND M2.D_E_L_E_T_='' ) TAXA "
            cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
            cQuery += " INNER JOIN "+RetSqlName("SF1")+" SF1 ON SF1.F1_FILIAL = SD1.D1_FILIAL AND  SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA AND SF1.D_E_L_E_T_ = '' " // por Adriana em 03/06/2020 - solicitacao do Fernando Sigoli //Ticket 65109   - Abel Babini			- 13/12/2021 - Ajuste na query, na clausula INNER JOIN, de F1_LOJA para D1_LOJA e acrescentando o campo FILIAL
            cQuery += " WHERE D1_FILIAL = '"+FWxFilial("SD1")+"' "
            cQuery += " AND D1_PEDIDO = '"+cCodpcnf+"' AND D1_ITEMPC = '"+cItepcnf+"' "
            cQuery += " AND SF1.F1_STATUS <> '' "
            cQuery += " AND SD1.D_E_L_E_T_ = '') NOTA "
            cQuery += " GROUP BY F1_STATUS, D1_FILIAL, D1_PEDIDO, D1_ITEMPC "

            cNewAlias := GetNextAlias()
            DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)

            nVlrnflc := (cNewAlias)->D1_TOTAL
    
            nVlrttnf := obtTotPed(oModelGRID, cCodpcnf, cItepcnf)

            oModelGRID:GoLine(nAux) 
        
            nVlrttnf := nVlrttnf / nVlrDlr

            (cNewAlias)->(DbCloseArea())

        Else

            cPedPreco := Transform(Round(SC7->C7_PRECO * nPVlUnit,4), "@E 999,999.9999")
            cNfePreco := Transform(Round(nPreco,4)       , "@E 999,999.9999")
            
            If cPedPreco < cNfePreco 

                cErroVunit := "Valor unitario da NF está maior que o Valor Unitario "+ xPula + "do item do Pedido " + Alltrim(cCodpcnf) + "/" + cItepcnf + xPula +;
                              "Valor Unitario NF: R$" + cNfePreco + xPula + ;
                              "Valor Unitario PC: R$" + cPedPreco + xPula

                Help(Nil, Nil, "ADFAT633 (ADFAT063P)", Nil, cErroVunit, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                RestArea(aArea)
                Return .F.  
            
            EndIf

            cQuery := " SELECT D1_FILIAL, D1_PEDIDO, D1_ITEMPC, ISNULL(SUM(D1_TOTAL-D1_VALDEV),0) D1_TOTAL "
            cQuery += " FROM "+RetSqlName("SD1")+" SD1 "
            cQuery += " INNER JOIN "+RetSqlName("SF1")+" SF1 ON SF1.F1_FILIAL = SD1.D1_FILIAL AND SD1.D1_DOC = SF1.F1_DOC AND SD1.D1_SERIE = SF1.F1_SERIE AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA = SD1.D1_LOJA AND SF1.D_E_L_E_T_ = '' " // por Adriana em 03/06/2020 - solicitacao do Fernando Sigoli //Ticket 65109   - Abel Babini			- 13/12/2021 - Ajuste na query, na clausula INNER JOIN, de F1_LOJA para D1_LOJA e acrescentando o campo FILIAL
            cQuery += " WHERE D1_FILIAL = '"+FWxFilial("SD1")+"' "
            cQuery += " AND D1_PEDIDO = '"+cCodpcnf+"' AND D1_ITEMPC = '"+cItepcnf+"' "
            cQuery += " AND SF1.F1_STATUS <> '' "
            cQuery += " AND SD1.D_E_L_E_T_ = '' "
            cQuery += " GROUP BY F1_STATUS,D1_FILIAL, D1_PEDIDO, D1_ITEMPC "

            cNewAlias := GetNextAlias()
            DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)

            nVlrnflc := (cNewAlias)->D1_TOTAL
    
            nVlrttnf := obtTotPed(oModelGRID, cCodpcnf, cItepcnf)

            oModelGRID:GoLine(nAux) 

            (cNewAlias)->(DbCloseArea())
                
        EndIf

        //Wagner - 26/04/2023 - ticket 92687
        If SC7->C7_MOEDA > 1
            nTotNFLF := (nVlrnflc/nVlrDlr)                 
        Else
            nTotNFLF := nVlrnflc                 
        EndIf

        If Round( (nVlrttnf + nTotNFLF) ,2) > Round( (nTotPed * nTolTotal) ,2)

            cErroTot := "Incluindo esse Lançamento, o valor das entradas, será maior que o valor do item do Pedido " + Alltrim(cCodpcnf) + "-" + Alltrim(cItepcnf) + xPula + xPula+;
                        "Documentos já Lançados" + Chr(9) + cSimbMoe + Transform(nVlrnflc, PesqPict("SC7","C7_TOTAL")) + xPula+;
                        "Documento Atual"        + Chr(9) + cSimbMoe + Transform(nVlrttnf, PesqPict("SC7","C7_TOTAL")) + xPula +;
                        "Total Documentos"       + Chr(9) + cSimbMoe + Transform(nVlrnflc + nVlrttnf, PesqPict("SC7","C7_TOTAL")) + xPula +;
                        "Total Item Pedido"      + Chr(9) + Chr(9) + cSimbMoe + Transform(nTotPed, PesqPict("SC7","C7_TOTAL")) + xPula +;
                        "Tolerância (MV_#FAT636): " + cValToChar(GetMv("MV_#FAT636",,0)) + "%"

            Help(Nil, Nil, "ADFAT633 (ADFAT063P)", Nil, cErroTot, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            oModelGRID:GoLine(nLinha)
            RestArea(aArea)
            Return .F.

        EndIf

    Next nAux

    oModelGRID:GoLine(nLinha)
        
Return .T.
/*/{Protheus.doc} obtTotPed
    Retorna total em moeda utilizado do pedido dentro do lançamento.
    @type  Static Function
    @author Everson
    @since 10/11/2022
    @version 01
/*/
Static Function obtTotPed(oModelGRID, cCodpcnf, cItepcnf)

    //Variáveis.
    Local aArea     := GetArea()
    Local cPedGrid  := ""
    Local cItemGrid := ""
    Local nTotal    := 0
    Local nCount    := 1
    Local nLinhas   := oModelGRID:Length() 
    Local nLinha    := oModelGRID:GetLine()

    For nCount := 1 To nLinhas

        oModelGRID:GoLine(nCount)  

        If oModelGRID:IsDeleted()
            Loop

        EndIf

        cPedGrid  :=  oModelGRID:GetValue("ZIN_PEDCOM")
        cItemGrid :=  oModelGRID:GetValue("ZIN_ITEMPC")
         
        If ! oModelGRID:IsDeleted() .And. cCodpcnf = cPedGrid .And. cItepcnf = cItemGrid
            nTotal += oModelGRID:GetValue("ZIN_TOTAL")

        EndIf  
                    
    Next nCount

    oModelGRID:GoLine(nLinha)

    RestArea(aArea)

Return nTotal
/*/{Protheus.doc} User Function ADFAT634
    Valida quantidade.
    @type  Function
    @author Everson
    @since 09/11/2022
    @version 01
/*/
User Function ADFAT634(oModel, oModelGRID, cPedido, cItem, nQuant, cRecebe) //Everson - 29/12/2022. Ticket 18465.

    //Variáveis.
    Local aArea         := GetArea()
    Local cProduto      := ""
    Local nQtdPed       := 0
    Local cErroQtd      := ""
    Local nQtdPrg       := 0
    Local nQtdTot       := 0
    Local nTolQuant     := (GetMv("MV_#FAT635",,0)/100)+1
    Local nLinhas       := oModelGRID:Length() 
    Local nLinha        := oModelGRID:GetLine()
    Local nAux          := 1

    If Empty(cPedido) .Or. Empty(cItem)
        Help(Nil, Nil, "ADFAT634 (ADFAT063P)", Nil, "Necessário informar o pedido e item.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If nQuant <= 0
        Help(Nil, Nil, "ADFAT634 (ADFAT063P)", Nil, "Necessário informar a quantidade do item " + cPedido + " " + cItem + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    //Valida se há saldo disponível.
    If U_ADFAT63F(cPedido, cItem, "NF") < 0
        Help(Nil, Nil, "ADFAT634 (ADFAT063P)", Nil, "Não há saldo suficiente para o pedido " + cPedido + " " + cItem + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    For nAux := 1 To nLinhas

        oModelGRID:GoLine(nAux) 

        If oModelGRID:IsDeleted()
            Loop

        EndIf

        If Alltrim(cValToChar(oModelGRID:GetValue("ZIN_PEDCOM"))) + Alltrim(cValToChar(oModelGRID:GetValue("ZIN_ITEMPC"))) == Alltrim(cValToChar(cPedido)) +  Alltrim(cValToChar(cItem))
            nQtdTot += oModelGRID:GetValue("ZIN_QUANT")

        EndIf

    Next nAux

    oModelGRID:GoLine(nLinha)

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbGoTop())
    If ! SC7->(DbSeek( FWxFilial("SC7") + cPedido + cItem ))
        Help(Nil, Nil, "ADFAT634 (ADFAT063P)", Nil, "Pedido de compra/item não localizado: " + cPedido + " " + cItem + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    cProduto := SC7->C7_PRODUTO

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())
    If ! SB1->(DbSeek(FWxFilial("SB1") + cProduto))
        Help(Nil, Nil, "ADFAT634 (ADFAT063P)", Nil, "Produto não localizado: " + cProduto + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf 

    //Everson - 29/12/2022. Ticket 18465.
    If U_ADCOM450(cRecebe, cPedido, cItem, cProduto, @nQtdPrg) 
    
        If ( nQtdPrg - nQtdTot ) < 0
            Help(Nil, Nil, "ADFAT634 (ADFAT063P)", Nil, "Não há saldo suficiente para recebimento pela programação de entrega. Produto " + cProduto + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.
            
        EndIf

    EndIf 

    nQtdPed  := (SC7->C7_QUANT * nTolQuant) - SC7->C7_QUJE   

    //Valida se o saldo disponível é suficiente.
    If nQtdPed < nQuant
    
        cErroQtd := "Quantidade da NF está maior que a quantidade do item do Pedido " + cPedido + "/ " + cItem + xPula + ;
                    "Quantidade NF: " + Transform(nQuant, "@E 999,999.99") + xPula + "Quantidade PC: " + Transform(nQtdPed * nTolQuant, "@E 999,999.99") + xPula +;
                    "Tolerância (MV_#FAT635): " + cValToChar(GetMv("MV_#FAT635",,0)) + "%"

        Help(Nil, Nil, "ADFAT634 (ADFAT063P)", Nil, cErroQtd, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

Return .T.
/*/{Protheus.doc} User Function ADFAT635
    Valida fornecedor alternativo.
    @type  Function
    @author Everson
    @since 09/11/2022
    @version 01
/*/
User Function ADFAT635(cPedido, cFornec, cLoja, cFornO, cLojaO)

    //Variáveis.
    Local aArea     := GetArea()

    Default cFornO  := ""
    Default cLojaO  := ""

    If ! Empty(cPedido)

        DbSelectArea("SC7")
        SC7->(DbSetOrder(1))
        If ! SC7->(DbSeek( FWxFilial("SC7") + cPedido ))
            Help(Nil, Nil, "ADFAT635 (ADFAT063P)", Nil, "Pedido de compra " + cPedido + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        EndIf

        cFornO := SC7->C7_FORNECE
        cLojaO := SC7->C7_LOJA

        If SC7->C7_FORNECE == cFornec .And. SC7->C7_LOJA == cLoja
            RestArea(aArea)
            Return .T.

        EndIf

    EndIF

    DbSelectArea("CPX")
    CPX->(DbSetOrder(1))
    CPX->(DbGoTop())
    If ! CPX->( DbSeek( FWxFilial("CPX") + cFornO + cLojaO + cFornec + cLoja ) )
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADFAT638
    Valida nota fiscal.
    @type  Function
    @author Everson
    @since 11/11/2022
    @version 01
/*/
User Function ADFAT638(cNF, cSerie, cFornec, cLoja)

    //Variávies.

    cSerie += Space(TamSX3("F1_SERIE")[1] - Len(cSerie))

    DbSelectArea("SF1")
    SF1->(DbSetOrder(1))
    SF1->(DbGoTop())

Return SF1->( DbSeek( FWxFilial("SF1") + cNF + cSerie + cFornec + cLoja ) )
/*/{Protheus.doc} User Function ADFAT639
    Posiciona no registro pela nf + serie + fornece + loja.
    @type  Function
    @author Everson
    @since 14/11/2022
    @version 01
/*/
User Function ADFAT639(cNF, cSerie, cFornec, cLoja, nIndex)

    //Variáveis.

    Default nIndex := 1

    cSerie := cSerie + Space(TamSx3("F1_SERIE")[1] - Len(cSerie))

    DbSelectArea("ZIN")
    ZIN->(DbSetOrder(nIndex))
    ZIN->(DbGoTop())

Return ZIN->( DbSeek( FWxFilial("ZIN") + cNF + cSerie + cFornec + cLoja ) )
/*/{Protheus.doc} User Function ADFAT63A
    Posiciona no registro pela chave.
    @type  Function
    @author Everson
    @since 14/11/2022
    @version 01
/*/
User Function ADFAT63A(cChave)

    //Variáveis.

    DbSelectArea("ZIN")
    ZIN->(DbSetOrder(2))
    ZIN->(DbGoTop())

Return ZIN->( DbSeek( FWxFilial("ZIN") + cChave ) )
/*/{Protheus.doc} User Function ADFAT63D
    Envia entrada de matéria-prima para o barramento.
    @type  Function
    @author Everson
    @since 14/11/2022
    @version 01
/*/
User Function ADFAT63D()

    //Variáveis.
    Local aArea     := GetArea()
    Local cNF       := ZIN->ZIN_DOC
    Local cSerie    := ZIN->ZIN_SERIE
    Local cFornec   := ZIN->ZIN_FORNEC
    Local cLoja     := ZIN->ZIN_LOJA

    If ! MsgYesNo("Deseja enviar a entrada de matéria-prima ?", "Função ADFAT63D(ADFAT063P)")
        RestArea(aArea)
        Return Nil

    EndIf

    grvBarr("A", cNF, cSerie, cFornec, cLoja)

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} User Function ADFAT63E
    Valida controle de pátio.
    @type  Function
    @author Everson
    @since 14/11/2022
    @version 01
/*/
User Function ADFAT63E(cCP) // U_ADFAT63E(M->ZIN_CTPATI)

    //Variáveis.
    Local aArea := GetArea()

    //Posiciona no registro de pátio selecionado.
    If ! U_ADFAT17U(cCP)
        MsgInfo("Controle de pátio " + cCP + " não localizado.", "Função ADFAT63E(ADFAT063P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If ZIB->ZIB_TPMOVI <> "E"
        MsgInfo("Controle de pátio " + cCP + " não é do tipo 'Entrada'.", "Função ADFAT63E(ADFAT063P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If ZIB->ZIB_STATUS <> "1"
        MsgInfo("Controle de pátio " + cCP + " não está aberto.", "Função ADFAT63E(ADFAT063P)")
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADFAT63F
    Retorna saldo do pedido de compra.
    @type  Function
    @author Everson
    @since 14/11/2022
    @version 01
/*/
User Function ADFAT63F(cPedido, cItem, cTipo, lConGrid)

    //Variáveis.
    Local aArea         := GetArea()
    Local nQtdZIN       := 0
    Local nQtdSD1       := 0
    Local nQtdDif       := 0
    Local nQuant        := 0
    Local cNewAlias     := GetNextAlias()
    Local cQuery        := ""
    Local nTotModel     := 0
    Local nQtdJE        := 0
    Local nTolQuant     := (GetMv("MV_#FAT635",,0.03)/100)+1

    Default cTipo       := ""
    Default lConGrid    := .T.

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbGoTop())
    If ! SC7->(DbSeek( FWxFilial("SC7") + cPedido + cItem ))
    
        If lConGrid
            Help(Nil, Nil, "ADFAT63F(ADFAT063P)", Nil, "Pedido " + cPedido + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        RestArea(aArea)
        Return 0

    EndIf

    cQuery += " SELECT " 
    cQuery += " ( " 
        cQuery += " SELECT  " 
        cQuery += " ISNULL(SUM(ZIN_QUANT), 0) AS ZIN_QUANT  " 
        cQuery += " FROM  " 
        cQuery += " " + RetSqlName("ZIN") + " (NOLOCK) ZIN  " 
        cQuery += " WHERE  " 
        cQuery += " ZIN_FILIAL = '" + FWxFilial("ZIN") + "'  " 

        If cTipo == "NF"
            cQuery += " AND ZIN_PEDCOM = '" + cPedido + "'  " 
            cQuery += " AND ZIN_ITEMPC = '" + cItem + "'  " 

        Else
            cQuery += " AND ZIN_PEDCTE = '" + cPedido + "'  " 

        EndIf
        
        If ALTERA
            cQuery += " AND ZIN_FORNEC + ZIN_LOJA + ZIN_DOC + ZIN_SERIE <> '" + ZIN->ZIN_FORNEC + ZIN->ZIN_LOJA + ZIN->ZIN_DOC + ZIN->ZIN_SERIE + "'  " 

        EndIf

        cQuery += " AND ZIN.D_E_L_E_T_ = '' "
        cQuery += " AND ZIN.ZIN_STATUS <> '8' " //Jonathan - 24/04/2023 - Ticket 91286 
    cQuery += " ) AS QTD_ZIN, " 

    cQuery += " ( " 
        cQuery += " SELECT  " 
        cQuery += " ISNULL(SUM(ZIN_QUANT), 0) AS ZIN_QUANT  " 
        cQuery += " FROM  " 
        cQuery += " " + RetSqlName("ZIN") + " (NOLOCK) ZIN  " 
        cQuery += " WHERE  " 
        cQuery += " ZIN_FILIAL = '" + FWxFilial("ZIN") + "'  " 
        cQuery += " AND ZIN_PEDCTE = '" + cPedido + "'  " 
        cQuery += " AND ZIN.D_E_L_E_T_ = '' " 
        cQuery += " AND ZIN.ZIN_STATUS <> '8' "  //Jonathan - 24/04/2023 - Ticket 91286

        If ALTERA
            cQuery += " AND ZIN_FORNEC + ZIN_LOJA + ZIN_DOC + ZIN_SERIE = '" + ZIN->ZIN_FORNEC + ZIN->ZIN_LOJA + ZIN->ZIN_DOC + ZIN->ZIN_SERIE + "'  " 

        EndIf

    cQuery += " ) AS QTD_CTE, " 

    cQuery += " ( " 
        cQuery += " SELECT  " 
        cQuery += " ISNULL(SUM(D1_QUANT), 0) AS D1_QUANT  " 
        cQuery += " FROM  " 
        cQuery += " " + RetSqlName("SD1") + " (NOLOCK) AS SD1 " 
        cQuery += " WHERE  " 
        cQuery += " D1_FILIAL = '" + FWxFilial("SD1") + "'  " 
        cQuery += " AND D1_PEDIDO = '" + cPedido + "'  " 
        cQuery += " AND D1_ITEMPC = '" + cItem + "'  " 
        cQuery += " AND SD1.D_E_L_E_T_ = '' " 
    cQuery += " ) AS QTD_SD1 " 

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)

    (cNewAlias)->(DbGoTop())

    If (cNewAlias)->(Eof())
        (cNewAlias)->(DbCloseArea())
        RestArea(aArea)
        Return nQuant

    EndIf

    //Quantidade lançada na rotina de entrada de matéria-prima.
    nQtdZIN := Val(cValToChar((cNewAlias)->QTD_ZIN))

    //Quantidade já utilizada nos documentos de entrada.
    nQtdSD1 := Val(cValToChar((cNewAlias)->QTD_SD1))

    //Quantidade constante na rotina de entrada de matéria-prima, mas sem o documento fiscal lançado.
    nQtdDif := Iif(nQtdZIN - nQtdSD1 > 0, nQtdZIN - nQtdSD1, 0)

    nQtdCTE :=  Val(cValToChar((cNewAlias)->QTD_CTE))

    (cNewAlias)->(DbCloseArea())

    //Quantidade total.
    If lConGrid .And. cTipo == "CTE"
        
        nTotModel := qtdToCTe(cPedido, cItem)

    ElseIf lConGrid .And. cTipo == "NF"

        nTotModel := qtdToNF(cPedido, cItem)

    EndIf

    //Quantidade já entregue.
    nQtdJE := Iif(cTipo == "CTE", SC7->C7_QUJE - nQtdCTE, nQtdSD1)
    nQtdJE := Iif(nQtdJE < 0, 0, nQtdJE)

    //Quantidade do pedido - (Quantidade já entregue + quantidade constante na entrada de matéria-prima, mas não do documento de entrada + quantidade da grid)
    nQuant := (SC7->C7_QUANT * nTolQuant) - ( nQtdJE + nQtdDif + nTotModel )
    
    RestArea(aArea)

Return nQuant
/*/{Protheus.doc} qtdToCTe
    Retorna a quantidade total do Pedido de compra do CT-e utilizada no lançamento.
    @type  Static Function
    @author Everson
    @since 17/03/2023
    @version 01
/*/
Static Function qtdToCTe(cPedido, cItem)

    //Variáveis.
    Local aArea         := GetArea()
    Local nTotModel     := 0
    Local oModel        := FWModelActive()
    Local oModelGRID    := oModel:GetModel("MD_GRID")
    Local nLinha        := oModelGRID:GetLine()
    Local nAux          := 1
    Local nLinhas       := oModelGRID:Length() 

    For nAux := 1 To nLinhas

        oModelGRID:GoLine(nAux) 

        If oModelGRID:IsDeleted()
            Loop

        EndIf

        If Alltrim(cValToChar(oModelGRID:GetValue("ZIN_PEDCTE"))) + Alltrim(cValToChar(oModelGRID:GetValue("ZIN_ITPCCT"))) == Alltrim(cValToChar(cPedido)) +  Alltrim(cValToChar(cItem))
            nTotModel += oModelGRID:GetValue("ZIN_QUANT")

        EndIf

    Next nAux

    oModelGRID:GoLine(nLinha)

    RestArea(aArea)

Return nTotModel
/*/{Protheus.doc} qtdToCTe
    Retorna a quantidade total do Pedido de compra do NF utilizada no lançamento.
    @type  Static Function
    @author Everson
    @since 17/03/2023
    @version 01
/*/
Static Function qtdToNF(cPedido, cItem)

    //Variáveis.
    Local aArea         := GetArea()
    Local nTotModel     := 0
    Local oModel        := FWModelActive()
    Local oModelGRID    := oModel:GetModel("MD_GRID")
    Local nLinha        := oModelGRID:GetLine()
    Local nAux          := 1
    Local nLinhas       := oModelGRID:Length() 

    For nAux := 1 To nLinhas

        oModelGRID:GoLine(nAux) 

        If oModelGRID:IsDeleted()
            Loop

        EndIf

        If Alltrim(cValToChar(oModelGRID:GetValue("ZIN_PEDCOM"))) + Alltrim(cValToChar(oModelGRID:GetValue("ZIN_ITEMPC"))) == Alltrim(cValToChar(cPedido)) +  Alltrim(cValToChar(cItem))
            nTotModel += oModelGRID:GetValue("ZIN_QUANT")

        EndIf

    Next nAux

    oModelGRID:GoLine(nLinha)

    RestArea(aArea)

Return nTotModel
/*/{Protheus.doc} User Function ADFAT63H
    Exclui ordem de pesagem.
    @type  Function
    @author Everson
    @since 17/11/2022
    @version 01
/*/
User Function ADFAT63H(cCP, cNF, cSerie, cFornec, cLoja)
    
    //Variávies.
    Local aArea     := GetArea()
    Local lRet      := .T.
    Local cMsgError := ""
    Local cNmOrdem  := ""

    If ! MsgYesNo("Deseja excluir ordem de pesagem?", "Função ADFAT63C(ADFAT063P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If ! U_ADFAT639(cNF, cSerie, cFornec, cLoja)
        Help(Nil, Nil, "Função ADFAT63H(ADFAT063P)",, "Nota fiscal " + cNF + "/" + cSerie + "-" + cFornec + cLoja + " não localizada na entrada de matéria-prima.", 1, 0 )
        RestArea(aArea)
        Return .F.

    EndIf

    Begin Transaction

        While ! ZIN->(Eof()) .And. ZIN->ZIN_FILIAL == FWxFilial("ZIN") .And.;
            ZIN->ZIN_DOC == cNF .And. ZIN->ZIN_SERIE == cSerie .And.;
            ZIN->ZIN_FORNEC == cFornec .And. ZIN->ZIN_LOJA == cLoja

            cNmOrdem := ZIN->ZIN_ORDPES

            If ! Empty(cNmOrdem) .And. U_ADFAT16A(cNmOrdem) //Posiciona na ordem de pesagem.

                If ! Empty(ZIF->ZIF_AGRUPA)
                    lRet := .F.
                    cMsgError := "É necessário desfazer o agrupamento para realizar a exclusão."
                    DisarmTransaction()
                    Break 

                EndIf

                If ! U_ADFAT179(ZIF->ZIF_PLACA, ZIF->ZIF_CTPATI, "", .F.) //Verifica se há controle de pátio aberto para placa informada.
                    lRet := .F.
                    cMsgError := "Há controle de pátio diferente de " + ZIF->ZIF_CTPATI + " aberto para placa."
                    DisarmTransaction()
                    Break 

                EndIf

                If ! U_ADFAT16I(ZIF->ZIF_CTPATI, ZIF->ZIF_NUMERO, ZIF->ZIF_AGRUPA, @cMsgError)
                    lRet := .F.
                    DisarmTransaction()
                    Break 

                EndIf

            EndIf

            RecLock("ZIN", .F.)
                ZIN->ZIN_ORDPES := ""
                ZIN->ZIN_STATUS := "1" //Everson - 05/01/2023. Ticket 18465.
            MsUnlock()

            ZIN->(DbSkip())

        End

    End Transaction

    If ! lRet
        Help(Nil, Nil, "ADFAT63H(ADFAT063P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    Else
        grvBarr("A", cNF, cSerie, cFornec, cLoja)
        MsgInfo("Processo concluído.", "ADFAT63H(ADFAT063P)")

    EndIf

    RestArea(aArea)
    
Return Nil
/*/{Protheus.doc} User Function ADFAT63I
    Carrega informações da Central XML - CTE.
    @type  Function
    @author Everson
    @since 17/11/2022
    @version 01
/*/
User Function ADFAT63I(cChave) // U_ADFAT63I(M->ZIN_CHVCTE)

    //Variáveis.
    Local aArea     := GetArea()
    Local cXmlAtu   := ""
    Local cFCNPJ    := ""
    Local cFornec   := ""
    Local cLoja     := ""
    Local cNmF      := ""
    Local aFiliais  := FWLoadSM0()
    Local nPosFil   := Ascan(aFiliais, {|x| x[01] == cEmpAnt .And. Alltrim(x[02]) == cFilAnt })
    Local cCGCFil   := Alltrim(cValToChar(aFiliais[nPosFil][18]))
    Local dEmissa   := Nil
    Local nVlrTot   := 0
    Local oModel    := FWModelActive()
    Local dEmiss    := oModel:GetValue("MD_MASTER", "ZIN_EMISCT")
    Local cCTE      := oModel:GetValue("MD_MASTER", "ZIN_DOCTE")
    Local cSerie    := oModel:GetValue("MD_MASTER", "ZIN_SERCTE")
    Local oModelGRID:= oModel:GetModel("MD_GRID")
    Local nQtdTot   := oModel:GetValue("ADFAT63TOT", "ZIN_QTDTOT")
    Local cTpCTE    := Alltrim(cValToChar(GetMv("MV_#FAT632",,"57")))

    If nQtdTot <= 0
        Help(Nil, Nil, "ADFAT63I(ADFAT063P)", Nil, "Necessário informar os dados da NF.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    cChave := Alltrim(cValToChar(cChave))

    If Empty(cChave)

        cabecCTE("", "", "", "", "", "", CToD(" / / "), 0)

        limpCTE(oModelGRID)

        RestArea(aArea)
        Return .T.

    EndIf

    If Len(cChave) <> 44

        cabecCTE("", "", "", "", "", "", CToD(" / / "), 0)

        limpCTE(oModelGRID)

        Help(Nil, Nil, "ADFAT63I(ADFAT063P)", Nil, "A chave precisa ter 44 caracteres.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    //Everson - 24/11/2022 - ticket 18465 - Valida CT-e rejeitado.
    DbSelectArea("ZCW")
	ZCW->(DbSetOrder(2))
	If ZCW->(DbSeek(FWxFilial("ZCW") + cChave))
    
        cabecCTE("", "", "", "", "", "", CToD(" / / "), 0)

        limpCTE(oModelGRID)

        Help(Nil, Nil, "ADFAT63I(ADFAT063P)", Nil, "Este CTe foi recusado e não pode ser classificado. Consulte o Depto. Fiscal.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""}) 
		RestArea(aArea)
		Return .F.

	EndIf	

    U_DbSelArea("RECNFCTE", .F., 1 )
	DbSeek( cChave )

    If ! DbSeek( cChave )

        If IsInCallStack("vldPos")

            If ! (Substr(cChave, 21, 2) $cTpCTE)
                cMsgError := "Modelo do CT-e constante na chave diverge do modelo de NF-e." + xPula + xPula + "Chave: " + Substr(cChave, 21, 2)
                RestArea(aArea)
                Return .F.

            EndIf

            If Empty(dEmiss)
                cMsgError := "Necessário informar a emissão do CT-e."
                RestArea(aArea)
                Return .F.

            EndIf

            If Right((Year2Str(dEmiss) + Month2Str(dEmiss)),4) <> Substr(cChave, 3, 4)
                cMsgError := "Verifique a emissão do CT-e." + xPula + xPula + "Emissão informada (AA/MM): " + (Year2Str(dEmiss) + Month2Str(dEmiss)) + xPula + "Emissão chave (AA/MM): " + Substr(cChave, 3, 4)
                RestArea(aArea)
                Return .F.

            EndIf

            If (Padl(Alltrim(cValToChar(cSerie)), 3, "0") + cCTE) <> Substr(cChave, 23, 12)
                cMsgError := "Verifique a série e número." + xPula + xPula + "Série + número informados: " + (Padl(Alltrim(cValToChar(cSerie)), 3, "0") + cCTE) + xPula + "Série + número chave: " + Substr(cChave, 23, 12) //Everson, 23/03/2023 - ticket 90614.
                RestArea(aArea)
                Return .F.

            EndIf

        EndIf

        If ! IsInCallStack("vldPos")
            // cabecCTE("", "", "", "", "", "", CToD(" / / "), 0)

            // limpCTE(oModelGRID)

            MsgInfo("Chave CT-e " + cChave + " não localizada.", "ADFAT63I(ADFAT063P)")

        EndIf

        RestArea(aArea)
        Return .T.

    EndIf

    If cCGCFil <> Alltrim(cValToChar(RECNFCTE->XML_DEST))

        cabecCTE("", "", "", "", "", "", CToD(" / / "), 0)

        limpCTE(oModelGRID)

        Help(Nil, Nil, "ADFAT63I(ADFAT063P)", Nil, "Chave " + cChave + " não pertence a filial corrente.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    cXmlAtu	:= RECNFCTE->XML_ARQ
    cFCNPJ  := RECNFCTE->XML_EMIT

    DbSelectArea("SA2")
    SA2->(DbSetOrder(3))
    SA2->(DbGoTop())

    If ! SA2->(DbSeek( FWxFilial("SA2") + cFCNPJ ))
        Help(Nil, Nil, "ADFAT63I(ADFAT063P)", Nil, "CNPJ " + cFCNPJ + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    cFornec := SA2->A2_COD
    cLoja   := SA2->A2_LOJA
    cNmF    := SA2->A2_NOME
    //aDados  := U_ADFAT637(cFornec, cLoja, cXmlAtu)

    cChave   := Alltrim(cValToChar(RECNFCTE->XML_CHAVE))
    cFCNPJ   := Alltrim(cValToChar(RECNFCTE->XML_EMIT))
    cSerie   := Substr(Alltrim(cValToChar(RECNFCTE->XML_NUMNF)), 1, 3)
    cNF      := Substr(Alltrim(cValToChar(RECNFCTE->XML_NUMNF)), 4, 12)
    dEmissa  := RECNFCTE->XML_EMISSA
    nVlrTot  := RECNFCTE->XML_TOTCTE

    If U_ADFAT638(cNF, cSerie, cFornec, cLoja)

        cabecCTE("", "", "", "", "", "", CToD(" / / "), 0)

        limpCTE(oModelGRID)

        Help(Nil, Nil, "ADFAT63I(ADFAT063P)", Nil, "CT-e já consta nos documentos de entrada.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .T.

    EndIf

    cabecCTE(cChave, cNF, cSerie, cFornec, cLoja, cNmF, dEmissa, nVlrTot)

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} cabecNF
    Carrega dados no cabeçalho.
    @type  Static Function
    @author Everson
    @since 11/11/2022
    @version 01
/*/
Static Function cabecCTE(cChave, cNF, cSerie, cCodF, cLojaF, cNomeF, dEmissa, nVlrTot)

    //Variáveis.
    Default cChave  := ""
    Default cNF     := ""
    Default cSerie  := ""
    Default cCodF   := ""
    Default cLojaF  := ""
    Default cNomeF  := ""
    Default dEmissa := CToD(" / / ")
    Default nVlrTot := 0

    FWFldPut("ZIN_CHVCTE" , cChave)
    FWFldPut("ZIN_DOCTE"  , cNF)
    FWFldPut("ZIN_SERCTE" , cSerie)
    FWFldPut("ZIN_FORCTE" , cCodF)
    FWFldPut("ZIN_LOJCTE" , cLojaF)
    FWFldPut("ZIN_NMCTE"  , cNomeF)
    FWFldPut("ZIN_EMISCT" , dEmissa)
    FWFldPut("ZIN_VLRCTE" , nVlrTot)

Return Nil
/*/{Protheus.doc} User Function ADFAT63G
    Posiciona no registro pela ordem de pesagem.
    @type  Function
    @author Everson
    @since 29/12/2022
    @version 01
/*/
User Function ADFAT63G(cNmOrdem)

    //Variáveis.

    DbSelectArea("ZIN")
    ZIN->(DbSetOrder(4))
    ZIN->(DbGoTop())

Return ZIN->( DbSeek( FWxFilial("ZIN") + cNmOrdem ) )
/*/{Protheus.doc} User Function ADFAT63K
    Atualiza registro.
    @type  Function
    @author Everson
    @since 29/12/2022
    @version 01
/*/
User Function ADFAT63K(cCampo, xValor, cMsgError)
    
    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oModel    := Nil
    Local aError    := {}

    Default cMsgError := ""

    oModel := FwLoadModel("ADFAT063P")
    oModel:SetOperation(MODEL_OPERATION_UPDATE)
    oModel:Activate() 

    oModel:SetValue("MD_MASTER", cCampo, xValor)

    If oModel:VldData()
        oModel:CommitData()
        lRet := .T.

    Else
        aError := oModel:GetErrorMessage()
        cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))

    EndIf

    oModel:DeActivate()
    oModel:Destroy()
    oModel := Nil

    If ! Empty(cMsgError)
        Help(Nil, Nil, "Função ADFAT63K(ADCOM045P)", Nil, "Erro na atualização de registro de entrada de MP." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADFAT63L
    Atualiza data de recebimento.
    @type  Function
    @author Everson
    @since 29/12/2022
    @version 01
/*/
User Function ADFAT63L(cNmOrdem, dData, lOrdAgrp) //Everson - 08/02/2023 - Ticket 18465. 

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cNewAlias := ""
    Local cNF       := ""
    Local cSerie    := ""
    Local cFornec   := ""
    Local cLoja     := ""

    //Everson - 08/02/2023 - Ticket 18465.
    If ! lOrdAgrp

        If ! U_ADFAT63G(cNmOrdem)
            RestArea(aArea)
            Return .F.

        EndIf

        cNF       := ZIN->ZIN_DOC
        cSerie    := ZIN->ZIN_SERIE
        cFornec   := ZIN->ZIN_FORNEC
        cLoja     := ZIN->ZIN_LOJA

        RecLock("ZIN", .F.)
            ZIN->ZIN_DTRECE := dData
        ZIN->(MsUnlock())

        grvBarr("A", cNF, cSerie, cFornec, cLoja)

    ElseIf U_ADFAT16F(cNmOrdem)

        cNewAlias := GetNextAlias()

        cQuery := " SELECT ZIF_NUMERO FROM " + RetSqlName("ZIF") + " (NOLOCK) AS ZIF WHERE ZIF_FILIAL = '" + FWxFilial("ZIF") + "' AND ZIF_AGRUPA = '" + cNmOrdem + "' AND ZIF.D_E_L_E_T_ = '' ORDER BY ZIF_NUMERO "

        DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)

        If (cNewAlias)->(Eof())
            (cNewAlias)->(DbCloseArea())
            RestArea(aArea)
            Return .F.

        EndIf

        While ! (cNewAlias)->(Eof())

            If ! U_ADFAT63G((cNewAlias)->ZIF_NUMERO)
                (cNewAlias)->(DbCloseArea())
                RestArea(aArea)
                Return .F.

            EndIf

            cNF       := ZIN->ZIN_DOC
            cSerie    := ZIN->ZIN_SERIE
            cFornec   := ZIN->ZIN_FORNEC
            cLoja     := ZIN->ZIN_LOJA

            RecLock("ZIN", .F.)
                ZIN->ZIN_DTRECE := dData
            ZIN->(MsUnlock())


            (cNewAlias)->(DbSkip())
            
        End
        
        (cNewAlias)->(DbCloseArea())
        
        grvBarr("A", cNF, cSerie, cFornec, cLoja)

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADFAT63M
    Atualiza o status.
    @type  Function
    @author Everson
    @since 05/01/2023
    @version 01
/*/
User Function ADFAT63M(cNmOrdem, nTpPesa, lOrdAgrp)

    //Variáveis.
    Local aArea     := GetArea()
    Local cStatus   := Iif(nTpPesa == 1, "3", "4")
    Local cQuery    := ""
    Local cNewAlias := ""
    Local cNF       := ""
    Local cSerie    := ""
    Local cFornec   := ""
    Local cLoja     := ""

    If ! lOrdAgrp

        If ! U_ADFAT63G(cNmOrdem)
            RestArea(aArea)
            Return .F.

        EndIf

        cNF       := ZIN->ZIN_DOC
        cSerie    := ZIN->ZIN_SERIE
        cFornec   := ZIN->ZIN_FORNEC
        cLoja     := ZIN->ZIN_LOJA

        RecLock("ZIN", .F.)
            ZIN->ZIN_STATUS := cStatus
        ZIN->(MsUnlock())

        grvBarr("A", cNF, cSerie, cFornec, cLoja)

    ElseIf U_ADFAT16F(cNmOrdem)

        cNewAlias := GetNextAlias()

        cQuery := " SELECT ZIF_NUMERO FROM " + RetSqlName("ZIF") + " (NOLOCK) AS ZIF WHERE ZIF_FILIAL = '" + FWxFilial("ZIF") + "' AND ZIF_AGRUPA = '" + cNmOrdem + "' AND ZIF.D_E_L_E_T_ = '' ORDER BY ZIF_NUMERO "

        DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)

        If (cNewAlias)->(Eof())
            (cNewAlias)->(DbCloseArea())
            RestArea(aArea)
            Return .F.

        EndIf

        While ! (cNewAlias)->(Eof())

            If ! U_ADFAT63G((cNewAlias)->ZIF_NUMERO)
                (cNewAlias)->(DbCloseArea())
                RestArea(aArea)
                Return .F.

            EndIf

            cNF       := ZIN->ZIN_DOC
            cSerie    := ZIN->ZIN_SERIE
            cFornec   := ZIN->ZIN_FORNEC
            cLoja     := ZIN->ZIN_LOJA

            RecLock("ZIN", .F.)
                ZIN->ZIN_STATUS := cStatus
            ZIN->(MsUnlock())


            (cNewAlias)->(DbSkip())
            
        End
        
        (cNewAlias)->(DbCloseArea())
        
        grvBarr("A", cNF, cSerie, cFornec, cLoja)

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} ADFAT63O
    Atualiza status no registro pelo número da NF/CT-e.
    @type  Static Function
    @author Everson
    @since 13/01/2023
    @version 01
/*/
User Function ADFAT63O(cDoc, cSerie, cFornec, cLoja, cTipo, cStatus)

    //Variáveis.
    Local aArea     := GetArea()
    Local cScript   := ""
    Local cScrip2   := "" //@history Jonathan 22/05/2023 - Ticket 92392

    If IsInCallStack("U_INTNFEB") .And. Type("nRadio") == "N" .And. nRadio == 3 .And. IsDigit(cSerie)
        cSerie := cValToChar(Val(cSerie))

    EndIf

    If ! IsInCallStack("U_INTNFEB") .And. ! U_ADFAT639(cDoc, cSerie, cFornec, cLoja, Iif(cTipo == "NF", 1, 6))
        RestArea(aArea)
        Return .T.

    EndIf
    //Jonathan - 12/05/2023 - ticket 92392
    If Empty(cDoc) .OR. Empty(cSerie) .OR. Empty(cFornec) .OR. Empty(cLoja) 
        MsgInfo("CT-e não localizada!!!", "Função ADFAT63N(ADFAT063P)")
        RestArea(aArea)
        Return .T.
    EndIf

    If cTipo == "CTE"
        cScript := "UPDATE " + RetSqlName("ZIN") + " SET ZIN_STATUS = '" + cStatus + "' WHERE ZIN_FILIAL = '" + FWxFilial("ZIN") + "' AND ZIN_DOCTE = '" + cDoc + "' AND ZIN_SERCTE = '" + cSerie + "' AND ZIN_FORCTE = '" + cFornec + "' AND ZIN_LOJCTE = '" + cLoja + "' AND D_E_L_E_T_ = '' "
        //@history Jonathan 22/05/2023 - Ticket 92392
        cScrip2 := "UPDATE SGNFE010 SET D1_MSEXP = '' WHERE F1_ESPECIE = 'CTE' AND F1_FILIAL = '" + FWxFilial("ZIN") + "' AND F1_DOC = '" + cDoc + "' AND F1_SERIE = '" + Alltrim(cSerie) + "' AND F1_FORNECE = '" + cFornec + "' AND F1_LOJA = '" + cLoja + "'"
    
    Else
        cScript := "UPDATE " + RetSqlName("ZIN") + " SET ZIN_STATUS = '" + cStatus + "' WHERE ZIN_FILIAL = '" + FWxFilial("ZIN") + "' AND ZIN_DOC = '" + cDoc + "' AND ZIN_SERIE = '" + cSerie + "' AND ZIN_FORNEC = '" + cFornec + "' AND ZIN_LOJA = '" + cLoja + "' AND D_E_L_E_T_ = '' "
        //@history Jonathan 22/05/2023 - Ticket 92392
        //cScrip2 := "UPDATE SGNFE010 SET D1_MSEXP = '' WHERE F1_FILIAL = '" + FWxFilial("ZIN") + "' AND F1_DOC = '" + cDoc + "' AND F1_SERIE = '" + cSerie + "' AND F1_FORNECE = '" + cFornec + "' AND F1_LOJA = '" + cLoja + "'"
    
    EndIf
    
    If TcSqlExec(cScript) < 0
        Help(Nil, Nil, "ADFAT63O(ADFAT063P)", Nil, "Erro ao atualizar o status do registro de entrada de matéria-prima. " + TCSQLError() , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    //@history Jonathan 22/05/2023 - Ticket 92392
    If TcSqlExec(cScrip2) < 0
        Help(Nil, Nil, "ADFAT63O(ADFAT063P)", Nil, "Erro ao atualizar o envio para integracao. " + TCSQLError() , 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    grvBarr("A", ZIN->ZIN_DOC, ZIN->ZIN_SERIE, ZIN->ZIN_FORNEC, ZIN->ZIN_LOJA)

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADFAT63N
    Consulta padrão para pedido de compra do CT-e.
    @type  Function
    @author Everson
    @since 11/01/2023
    @version 01
/*/
User Function ADFAT63N(oView)

    //Variáveis.
    Local aArea     := GetArea()
    Local oDlg      := Nil 
    Local oLbx      := Nil
    Local aCpos     := {}
    Local aRet      := {}
    Local cQuery    := ""
    Local cAlias    := GetNextAlias()
    Local lRet      := .F.
    Local oModel    := oView:GetModel()
    Local oCabec    := oModel:GetModel("MD_MASTER")
    Local oModelGRID:= oModel:GetModel("MD_GRID")
    Local nLinha    := oModelGRID:GetLine()
    Local cNomeF    := ""

    Local cFornec   := Alltrim(cValToChar(oCabec:GetValue("ZIN_FORCTE")))
    Local cLoja     := Alltrim(cValToChar(oCabec:GetValue("ZIN_LOJCTE")))
    Local cProduto  := Alltrim(cValToChar(GetMV("MV_#FAT631",,"801607")))
    Local nQtdTot   := oModel:GetValue("ADFAT63TOT", "ZIN_QTDTOT")

    Local cPedProd  := Alltrim(cValToChar(oModelGRID:GetValue("ZIN_PEDCOM")))
    Local cContrato := ""
    Local cItemCrt  := ""

    Local cPreco    := ""
    Local cSaldo    := ""
    Local cStatus   := ""
    Local nSaldo    := 0

    If Empty(cPedProd)
        MsgInfo("Necessário informar o pedido de compra do produto.", "Função ADFAT63N(ADFAT063P)")
        RestArea(aArea)
        Return Nil

    EndIf

    cContrato := Posicione("SC7", 1, FWxFilial("SC7") + cPedProd, "C7_XCTRCOM")
    cItemCrt  := Posicione("SC7", 1, FWxFilial("SC7") + cPedProd, "C7_XCTRVER")

    If nQtdTot <= 0
        MsgInfo("Necessário informar os dados da NF.", "Função ADFAT63N(ADFAT063P)")
        RestArea(aArea)
        Return Nil

    EndIf

    If Empty(cFornec) .Or. Empty(cLoja) .Or. Empty(cProduto)
        MsgInfo("Necessário informar fornecedor.", "Função ADFAT63N(ADFAT063P)")
        RestArea(aArea)
        Return Nil

    EndIf

    cQuery := " SELECT "
    cQuery += " C7_NUM, C7_FORNECE, C7_LOJA, C7_PRODUTO, C7_DESCRI, C7_ITEM, C7_PRECO, C7_QUANT - C7_QUJE AS SALDO, C7_CONAPRO  "
        cQuery += " FROM " + RetSqlName("SC7") + " (NOLOCK) AS SC7 "
    cQuery += " WHERE "
        cQuery += " C7_FILIAL = '" + FWxFilial("SC7") + "' "
        cQuery += " AND C7_FORNECE = '" + cFornec  + "' "
        cQuery += " AND C7_LOJA = '"   + cLoja    + "' "
        cQuery += " AND C7_PRODUTO = '" + cProduto + "' "
        cQuery += " AND C7_QUANT > C7_QUJE AND C7_RESIDUO = '' AND SC7.D_E_L_E_T_ = '' "
        //cQuery += "  AND C7_CONAPRO = 'L' "
        cQuery += " AND C7_ENCER <> 'E' "
        cQuery += " AND C7_OBS <> 'SAG' " 
        cQuery += " AND C7_XCTRCOM+C7_XCTRVER = '" + cContrato + cItemCrt + "' " 

    cQuery += " UNION ALL "

    cQuery += " SELECT "
    cQuery += " C7_NUM, C7_FORNECE, C7_LOJA, C7_PRODUTO, C7_DESCRI, C7_ITEM, C7_PRECO, C7_QUANT - C7_QUJE AS SALDO, C7_CONAPRO   "
        cQuery += " FROM " + RetSqlName("SC7") + " (NOLOCK) AS SC7 "
    cQuery += " WHERE "
        cQuery += " C7_FILIAL = '" + FWxFilial("SC7") + "' "
        cQuery += " AND C7_FORNECE + C7_LOJA IN ( "

            cQuery += " SELECT " 
                cQuery += " DISTINCT CPW_CODIGO + CPW_LOJA AS CODLOJA " 
            cQuery += " FROM  " 
                cQuery += " " + RetSqlName("CPW") + " (NOLOCK) AS CPW  " 
                cQuery += " INNER JOIN " 
                cQuery += " " + RetSqlName("CPX") + " (NOLOCK) AS CPX ON " 
                cQuery += " CPW_FILIAL = CPX_FILIAL " 
                cQuery += " AND CPW_CODIGO = CPX_CODIGO " 
                cQuery += " AND CPW_LOJA = CPX_LOJA " 
            cQuery += " WHERE " 
                cQuery += " CPW_FILIAL = '" + FWxFilial("CPW") + "' " 
                cQuery += " AND CPX_CODFOR = '" + cFornec + "' " 
                cQuery += " AND CPX_LOJFOR = '" + cLoja + "' " 
                cQuery += " AND CPW.D_E_L_E_T_ = '' " 
                cQuery += " AND CPX.D_E_L_E_T_ = '' " 

        cQuery += " ) "
        cQuery += " AND C7_PRODUTO = '" + cProduto + "' "
        cQuery += " AND C7_QUANT > C7_QUJE AND C7_RESIDUO = '' AND SC7.D_E_L_E_T_ = '' "
        //cQuery += "  AND C7_CONAPRO = 'L' 
        cQuery += " AND C7_ENCER <> 'E' " 
        cQuery += " AND C7_OBS <> 'SAG' "
        cQuery += " AND C7_XCTRCOM+C7_XCTRVER = '" + cContrato + cItemCrt + "' " 

    cQuery += " ORDER BY C7_NUM "

    cQuery := ChangeQuery(cQuery)

    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

    While (cAlias)->(!Eof())

        nSaldo := U_ADFAT63F((cAlias)->C7_NUM, (cAlias)->C7_ITEM, "CTE", .T.)

        If nSaldo <= 0
            (cAlias)->(DbSkip())
            Loop

        EndIf

        cNomeF := Alltrim(cValToChar(Posicione("SA2", 1, FWxFilial("SA2") + (cAlias)->C7_FORNECE + (cAlias)->C7_LOJA, "A2_NOME")))

        cPreco := Alltrim(cValToChar( Transform((cAlias)->C7_PRECO, "@E 999,999,999.9999") ))
        cSaldo := Alltrim(cValToChar( Transform(nSaldo, "@E 999,999,999.999") ))

        cStatus := Iif((cAlias)->C7_CONAPRO == "L", "Liberado", "Bloqueado")

        Aadd(aCpos,{ cStatus, (cAlias)->C7_NUM, (cAlias)->C7_FORNECE, cNomeF, (cAlias)->C7_LOJA, (cAlias)->C7_PRODUTO, (cAlias)->C7_DESCRI, (cAlias)->C7_ITEM, cPreco, cSaldo })

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    If Len(aCpos) < 1
        Aadd(aCpos,{" ", " ", " ", " ", " ", " ", " ", " ", " ", " "})

    EndIf

    DEFINE MSDIALOG oDlg TITLE /*STR0083*/ "Pedido de Compra" FROM 0,0 TO 240,500 PIXEL

        @ 10,10 LISTBOX oLbx FIELDS HEADER "Status", "Pedido", "Cod", "Loja", "Nome", "Produto", "Desc", "Item", "Prc Unt", "Saldo" SIZE 230,95 OF oDlg PIXEL

        oLbx:SetArray( aCpos )
        oLbx:bLine     := {|| {aCpos[oLbx:nAt,1], aCpos[oLbx:nAt,2], aCpos[oLbx:nAt,3], aCpos[oLbx:nAt,4], aCpos[oLbx:nAt,5], aCpos[oLbx:nAt,6], aCpos[oLbx:nAt,7], aCpos[oLbx:nAt,8], aCpos[oLbx:nAt,9], aCpos[oLbx:nAt,10] }}
        oLbx:bLDblClick := {|| {oDlg:End(), lRet:=.T., aRet := { oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,8], oLbx:aArray[oLbx:nAt,6] }}}

    DEFINE SBUTTON FROM 107,213 TYPE 1 ACTION (oDlg:End(), lRet:=.T., aRet := { oLbx:aArray[oLbx:nAt,2], oLbx:aArray[oLbx:nAt,8], oLbx:aArray[oLbx:nAt,6] })  ENABLE OF oDlg
    ACTIVATE MSDIALOG oDlg CENTER

    If Len(aRet) > 0 .And. lRet

        If ! Empty(aRet[1])
            prcPdCT(oModel, oModelGRID, aRet[1], aRet[2], aRet[3], nLinha)

        EndIf

    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} prcPdCT
    Atribui pedido de compra.
    @type  Static Function
    @author Everson
    @since 11/01/2023
    @version 01
/*/
Static Function prcPdCT(oModel, oModelGRID, cPedido, cItem, cProduto, nLinha)

    //Variáveis.
    Local aArea     := GetArea()
    Local nQuant    := 0
    Local nVlTotal  := oModel:GetValue("MD_MASTER", "ZIN_VLRCTE")
    Local nPVlUnit  := (GetMv("MV_#FAT634",,0.03)/100)+1
    Local nTolTotal := (GetMv("MV_#FAT636",,0)/100) + 1
    Local cErroVunit:= ""
    Local nPrcUnit  := 0
    Local nPreco    := 0
    Local cPedPreco := ""
    Local cNfePreco := ""
    Local cSimbMoe  := "R$"
    Local nTotModel := 0
    Local nQtdItem  := oModelGRID:GetValue("ZIN_QUANT")

    If nVlTotal <= 0
        MsgInfo("Necessário informar o valor do CT-e.", "Função prcPdCT(ADFAT063P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If nQtdItem <= 0
        MsgInfo("Necessário informar a quantidade do produto.", "Função prcPdCT(ADFAT063P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If ! posSC7(cPedido, cItem, cProduto)
        MsgInfo("Pedido " + cPedido + " não localizado.", "Função prcPdCT(ADFAT063P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If SC7->C7_CONAPRO <> 'L' 
        
        limpCTE(oModelGRID)

        MsgInfo("Pedido " + cPedido + " não está liberado.", "Função prcPdCT(ADFAT063P)")
        RestArea(aArea)
        Return .F.

    EndIf

    //Retorna saldo do pedido de compra.
    nQuant := U_ADFAT63F(cPedido, SC7->C7_ITEM, "CTE")

    If nQuant < 0

        limpCTE(oModelGRID)

        MsgInfo("Pedido " + cPedido + " não possui saldo.", "Função prcPdCT(ADFAT063P)")
        RestArea(aArea)
        Return .F.

    EndIf
            
    nTotModel := qtdToCTe(cPedido, cItem)

    If nTotModel <= 0
        nTotModel := nQtdItem
        
    EndIf
    
    oModelGRID:GoLine(nLinha)

    nPrcUnit := (SC7->C7_PRECO * nPVlUnit) 
    nPreco   := (nVlTotal/nTotModel)

    If nPrcUnit < nPreco
        
        limpCTE(oModelGRID)

        cPedPreco := Transform(Round(nPrcUnit, 4), PesqPict("SC7","C7_PRECO"))
        cNfePreco := Transform(Round(nPreco, 4)  , PesqPict("SC7","C7_PRECO"))

        cErroVunit := "Valor unitario do CT-e está maior que o Valor Unitario do item do Pedido " + Alltrim(SC7->C7_NUM) + "/" + SC7->C7_ITEM + xPula +;
                      "Valor Unitario CT-e: R$" + cNfePreco + xPula +;
                      "Valor Unitario PC:   R$" + cPedPreco + xPula +;
                      "Tolerância (MV_#FAT634): " + cValToChar(GetMv("MV_#FAT634",,0)) + "%"

        Help(Nil, Nil, "prcPdCT (ADFAT063P)", Nil, cErroVunit, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.  

    EndIf

    If Round((nQuant * nPreco) ,2) > Round( (SC7->C7_TOTAL * nTolTotal) ,2)

        limpCTE(oModelGRID)

        cErroTot := "Valor total está maior que valor total disponível no pedido de compra " + Alltrim(SC7->C7_NUM) + "-" + Alltrim(SC7->C7_ITEM) + xPula + xPula+;
                    "Documento Atual"        + Chr(9) + cSimbMoe + Transform(Round((nQuant * nPreco) ,2), PesqPict("SC7","C7_TOTAL")) + xPula +; //Everson, 04/04/2023 - ticket 18465.
                    "Total Item Pedido"      + Chr(9) + Chr(9) + cSimbMoe + Transform(Round( (SC7->C7_TOTAL * nTolTotal) ,2), PesqPict("SC7","C7_TOTAL")) + xPula +; //Everson, 04/04/2023 - ticket 18465.
                    "Tolerância (MV_#FAT636): " + cValToChar(GetMv("MV_#FAT636",,0)) + "%"

        Help(Nil, Nil, "prcPdCT (ADFAT063P)", Nil, cErroTot, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        oModelGRID:GoLine(nLinha)
        RestArea(aArea)
        Return .F.

    EndIf

    oModelGRID:SetValue("ZIN_PEDCTE", SC7->C7_NUM)
    oModelGRID:SetValue("ZIN_ITPCCT", SC7->C7_ITEM)
    oModelGRID:SetValue("ZIN_CONDCT", SC7->C7_COND)

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} limpCTE
    Limpa dados do pedido do CT-e.
    @type  Static Function
    @author Everson
    @since 03/03/2023
    @version 01
/*/
Static Function limpCTE(oModelGRID)

    oModelGRID:SetValue("ZIN_PEDCTE", "")
    oModelGRID:SetValue("ZIN_CONDCT", "")
    oModelGRID:SetValue("ZIN_ITPCCT", "")
    
Return Nil
/*/{Protheus.doc} lancCTE
    Valida e baixa quantidade do pedido de CT-e.
    @type  Static Function
    @author Everson
    @since 12/01/2023
    @version 01
/*/
Static Function lancCTE(cOpc, cCTE, cSerieCTE, cPedido, cItem, cFornCTE, cLjCTE, nTotalKg)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cProduto  := Alltrim(cValToChar(GetMV("MV_#FAT631",,"801607")))

    If U_ADFAT638(cCTE, cSerieCTE, cFornCTE, cLjCTE)
        RestArea(aArea)
        Return .T.

    EndIf

    cProduto := cProduto + Space( TamSX3("C7_PRODUTO")[1] - Len(cProduto))

    If ! posSC7(cPedido, cItem, cProduto)
        Help(Nil, Nil, "Função lancCTE(ADFAT063P)", Nil, "Pedido " + cPedido + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    //Valida pedido do CT-e.
    lRet := U_MT116T2(cPedido, SC7->C7_ITEM, cFornCTE, cLjCTE, cCTE, cSerieCTE, cOpc, 0, 0, nTotalKg) == 2

    RestArea(aArea)
    
Return lRet

/*/{Protheus.doc} posSC7
    Posiciona no pedido de compra pelo número do pedido mais o produto.
    @type  Function
    @author Everson
    @since 17/01/2023
    @version 01
/*/
Static Function posSC7(cPedido, cItem, cProduto)

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := " SELECT R_E_C_N_O_ AS REC FROM " + RetSqlName("SC7") + " (NOLOCK) AS SC7 WHERE C7_FILIAL = '" + FWxFilial("SC7") + "' AND C7_NUM = '" + cPedido + "' AND C7_ITEM = '" + cItem + "' AND C7_PRODUTO = '" + cProduto + "' AND D_E_L_E_T_ = '' "
    Local cNewAlias := GetNextAlias()
    Local nRecno    := 0

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .T., .T.)
    (cNewAlias)->(DbGoTop())
    
        If (cNewAlias)->(Eof())
            (cNewAlias)->(DbCloseArea())
            RestArea(aArea)
            Return .F.

        EndIf

        nRecno := Val(cValToChar((cNewAlias)->REC))
    
    (cNewAlias)->(DbCloseArea())

    DbSelectArea("SC7")
    SC7->(DbGoTop())
    SC7->(DbGoTo(nRecno))

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADFAT631
    Formata número do CT-E.
    @type  Function
    @author Everson
    @since 07/03/2023
    @version 01
/*/
User Function ADFAT63S()

    //Variáveis.
    Local cDoc := Alltrim(cValToChar(M->ZIN_DOCTE ))
    
    If ! Empty(cDoc)
        FWFldPut("ZIN_DOCTE", Padl(cDoc, 9, "0"))

    EndIf

Return .T.
