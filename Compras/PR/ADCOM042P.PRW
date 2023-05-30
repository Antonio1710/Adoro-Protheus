#Include "Totvs.ch"
#Include "FWMVCDef.ch"

Static cTbMast := "ZIO"
Static cTitulo := "Contrato de Compra de Matéria Prima"
Static xPula   :=  Chr(13) + Chr(10)

Static lAtuPed := .F.

/*/{Protheus.doc} User Function tstmvc
    Contrato de Compra de Matéria Prima.
    Cad Padr Prod Compra
    Chamado 18465.
    @type  Function
    @author Everson
    @since 07/12/2021
    @version 01
    @history Everson, 03/10/2022, Ticket 18465 - Adicionada eliminação de resíduo do pedido de compra.
    @history Everson, 10/10/2022, Ticket 18465 - Tratamento para validar fornecedor.
    @history Everson, 18/10/2022, Ticket 18465 - Tratamento para envio do pedido para o barramento após aprovação automática vinculada ao contrato de compra.
    @history Everson, 20/10/2022, Ticket 18465 - Tratamento para salvar número do contrato no pedido de compra.
    @history Everson, 25/10/2022, Ticket 18465 - Tratamento para salvar a versão do contrato no pedido de compra.
    @history Everson, 28/10/2022, Ticket 18465 - Adicionado envio manual do contrato para o barramento.
    @history Everson, 05/12/2022, Ticket 18465 - Adicionado tipo de frete.
    @history Everson, 28/12/2022, Ticket 18465 - Tratamento para zerar aliquotas de ICMS e IPI.
    @history Everson, 29/12/2022, Ticket 18465 - Tratamento para o usuário informar aliquotas de ICMS e IPI, valor e data de emissão do contrato.
    @history Everson, 04/01/2023, Ticket 18465 - Tratamento para visualização do contrato.
    @history Everson, 05/01/2023, Ticket 18465 - Tratamento para inclusão de moeda.
    @history Everson, 09/01/2023, Ticket 18465 - Adicionada rotina de programação de entrega ao menu.
    @history Everson, 18/01/2023, Ticket 18465 - Adicionado envio de e-mail na solicitação de aprovação e aprovação do contrato.
    @history Everson, 19/01/2023, Ticket 18465 - Processo de compra de MP com entrega futura.
    @history Everson, 20/01/2023, Ticket 18465 - Processo de compra de MP com armazenagem em terceiro.
    @history Everson, 23/01/2023, Ticket 18465 - Processo de compra de MP com armazenagem em terceiro.
    @history Everson, 25/01/2023, Ticket 18465 - Processo de compra de MP com armazenagem em terceiro.
    @history Everson, 26/01/2023, Ticket 18465 - Correção errorlog.
    @history Everson, 03/02/2023, Ticket 18465 - Alterado processo de geração de pedido/aprovação.
    @history Everson, 06/02/2023, Ticket 18465 - Correção no sequencial para não pular numeração.
    @history Everson, 20/02/2023, Ticket 18465 - Melhoria para atualizar pedidos de compra e venda vinculados ao contrato.
    @history Everson, 21/02/2023, Ticket 18465 - Adicionada função para cópia de contrato.
    @history Everson, 02/03/2023, Ticket 18465 - Adicionada a impressão de pedido de compra.
    @history Everson, 03/03/2023, Ticket 18465 - Função para encerramento automático de contrato.
    @history Everson, 13/03/2023, Ticket 18465 - Adicionada função para envio do registro para aprovação no app.
    @history Everson, 13/03/2023, Ticket 18465 - Correção errorlog.
    @history Everson, 14/03/2023, Ticket 18465 - Adicionado pedido de compra na aprovação do app.
    @history Everson, 15/03/2023, Ticket 18465 - Adicionado preço unitário do pedido de compra na aprovação do app.
    @history Everson, 17/03/2023, Ticket 18465 - Adicionada opção para alteração de contrato com quantidade parcial.
    @history Everson, 27/03/2023, Ticket 90573 - Tratamento para não gera novos pedidos, quando já há pedidos vinculados.
    @history Wagner,  25/04/2023, Ticket 91984 - Taxa Ptax alterada para 0 na geração dos pedidos..
    @history Wagner,  27/04/2023, Ticket 92896 - Alteração de tipo de frete.
/*/
User Function ADCOM042P() // ADCOM042P()

    //Variáveis.
    Local oBrowse := Nil

    U_ADCOM417()

    oBrowse := FwLoadBrw("ADCOM042P")

    oBrowse:Activate()

    U_ADCOM417()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 07/12/2021
    @version 01
/*/
Static Function BrowseDef()

    //Variáveis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    oBrowse:AddLegend("ZIO->ZIO_STATUS = '1'", "BR_BRANCO"   , "Aberto")
    oBrowse:AddLegend("ZIO->ZIO_STATUS = '2'", "BR_AZUL"     , "Enviado para Aprovação")
    oBrowse:AddLegend("ZIO->ZIO_STATUS = '3'", "BR_VERDE"    , "Aprovado")
    oBrowse:AddLegend("ZIO->ZIO_STATUS = '4'", "BR_VERMELHO" , "Reprovado")
    oBrowse:AddLegend("ZIO->ZIO_STATUS = '5'", "BR_MARROM"   , "Ped Gerado")
    oBrowse:AddLegend("ZIO->ZIO_STATUS = '7'", "BR_LARANJA"  , "Parcialmente Atendido")
    oBrowse:AddLegend("ZIO->ZIO_STATUS = '8'", "BR_PINK"     , "Encerrado Manual")
    oBrowse:AddLegend("ZIO->ZIO_STATUS = '6'", "BR_PRETO"    , "Encerrado")

    oBrowse:SetFilterDefault(" " + cTbMast + "_FILIAL = '" + FWxFilial(cTbMast) + "' ")

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 07/12/2021
    @version 01
/*/
Static Function MenuDef()

    //Variáveis.
    Local aRotina := {}
    Local cAprova := Alltrim(cValToChar(GetMv("MV_#COM411",,"")))

    ADD OPTION aRotina TITLE "Pesquisar"  ACTION "PesqBrw"          	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.ADCOM042P" 	OPERATION MODEL_OPERATION_VIEW      ACCESS 0
    ADD OPTION aRotina TITLE "Incluir" 	  ACTION "U_ADCOM421()" 	    OPERATION MODEL_OPERATION_INSERT    ACCESS 0
    ADD OPTION aRotina TITLE "Alterar"    ACTION "U_ADCOM422()"   	    OPERATION MODEL_OPERATION_UPDATE    ACCESS 0
    ADD OPTION aRotina TITLE "Excluir" 	  ACTION "U_ADCOM423()"   	    OPERATION MODEL_OPERATION_DELETE    ACCESS 0
    ADD OPTION aRotina TITLE "Cópia"      ACTION "U_ADCOM42H()"      	OPERATION 9                         ACCESS 0

    ADD OPTION aRotina TITLE "Gerar Pedido"   ACTION "MsAguarde({|| U_ADCOM429(3) }, 'Aguarde', 'Processando...')" OPERATION 10  ACCESS 0 //Everson, 27/03/2023, Ticket 90573.
    
    ADD OPTION aRotina TITLE "Env Aprovacao"  ACTION "U_ADCOM427(ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO)" OPERATION 11  ACCESS 0
    
    
    If FWIsAdmin() .Or. __cUserID $cAprova
        ADD OPTION aRotina TITLE "Aprovar"   ACTION "U_ADCOM424('A', ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO)" OPERATION 12  ACCESS 0

        ADD OPTION aRotina TITLE "Reprovar"  ACTION "U_ADCOM424('R', ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO)" OPERATION 13  ACCESS 0

    EndIf

    ADD OPTION aRotina TITLE "Encerrar Manual"      ACTION "MsAguarde({|| U_ADCOM42A(.T., ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO) }, 'Aguarde', 'Processando...')" OPERATION 14  ACCESS 0

    ADD OPTION aRotina TITLE "Env Barramento"       ACTION "U_ADCOM42D()"  OPERATION 15  ACCESS 0 //Everson - 28/10/2022 - ticket 18465.

    ADD OPTION aRotina TITLE "Programação Entrada"  ACTION "U_ADCOM045P()" OPERATION 16  ACCESS 0 //Everson - 09/01/2022 - ticket 18465.
    
    ADD OPTION aRotina TITLE "Imprimir Ped MP"      ACTION "U_ADCOM046R()" OPERATION 16  ACCESS 0 //Everson - 02/03/2022 - ticket 18465.

    ADD OPTION aRotina TITLE "PA"                   ACTION "U_ADCOM42J()"  OPERATION 17  ACCESS 0 //Everson - 03/03/2022 - ticket 18465.

Return aRotina
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 07/12/2021
    @version 01
/*/
Static Function ModelDef()
    
    //Variáveis.
    Local oModel    := Nil
    Local oStrMast  := FWFormStruct(1, cTbMast, {|cCampo| Alltrim(cCampo) $ getCmps()})
    Local oStrGrid  := FWFormStruct(1, cTbMast)
    Local bPost     := {|oModel| vldPos(oModel) }
    Local bLinhaOk  := {|oModel| fValidGrid(oModel) }
    Local bPreGrid  := {|oStrGrid, nLine, cAction, cIDField, xValue, xCurrentValue| pValidGrid(oStrGrid, nLine, cAction, cIDField, xValue, xCurrentValue)}
 
    oModel := MPFormModel():New("ADCOM42", /*bPreValidacao*/, bPost, /*bCommit*/, /*bCancel*/ )
 
    oModel:AddFields("MD_MASTER", NIL, oStrMast)
    oModel:AddGrid("MD_GRID", "MD_MASTER", oStrGrid, bPreGrid, bLinhaOk)
 
    oModel:SetRelation("MD_GRID", {;
            {"ZIO_FILIAL", 'FWxFilial("' + cTbMast + '")'},;
            {"ZIO_EMISSA", "ZIO_EMISSA"},;
            {"ZIO_NUMERO", "ZIO_NUMERO"},;
            {"ZIO_VERSAO", "ZIO_VERSAO"},;
            {"ZIO_DESC"  , "ZIO_DESC"},;
            {"ZIO_TIPO"  , "ZIO_TIPO"},;
            {"ZIO_STATUS", "ZIO_STATUS"},;
            {"ZIO_DTINI" , "ZIO_DTINI"},;
            {"ZIO_DTFIM ", "ZIO_DTFIM"},;
            {"ZIO_INCLUS", "ZIO_INCLUS"},;
            {"ZIO_ALTERA", "ZIO_ALTERA"},;
            {"ZIO_DTAPRO", "ZIO_DTAPRO"},;
            {"ZIO_HRAPRO", "ZIO_HRAPRO"},;
            {"ZIO_CODAPR", "ZIO_CODAPR"},;
            {"ZIO_NMAPRO", "ZIO_NMAPRO"},;
            {"ZIO_LGENCM", "ZIO_LGENCM"};
        }, (cTbMast)->(IndexKey(2)))

    oModel:SetPrimaryKey({})

    oModel:GetModel("MD_MASTER"):SetFldNoCopy( { "ZIO_EMISSA", "ZIO_NUMERO", "ZIO_VERSAO", "ZIO_STATUS", "ZIO_INCLUS", "ZIO_ALTERA", "ZIO_DTAPRO", "ZIO_HRAPRO", "ZIO_CODAPR", "ZIO_NMAPRO", "ZIO_LGENCM" } )
    oModel:GetModel("MD_GRID"):SetFldNoCopy( { "ZIO_PEDCOM", "ZIO_PEDCO2", "ZIO_PEDARM" } )

Return oModel
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 07/12/2021
    @version 01
/*/
Static Function ViewDef()
    
    //Variáveis.
    Local oView     := Nil
    Local oModel    := FWLoadModel('ADCOM042P')
    Local cCampos   := getCmps()
    Local oStrMast  := FWFormStruct(2, cTbMast, {|cCampo| AllTRim(cCampo)   $ cCampos})
    Local oStrGrid  := FWFormStruct(2, cTbMast, {|cCampo| !(Alltrim(cCampo) $ cCampos)})

    oView:= FWFormView():New() 
    oView:SetModel(oModel)              
 
    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")
    oView:AddGrid("VW_GRID",    oStrGrid, "MD_GRID",,{|| gridFocus() })
 
    oView:CreateHorizontalBox("MAIN", 35)
    oView:CreateHorizontalBox("GRID", 65)

    oView:SetOwnerView("VW_MASTER", 'MAIN')
    oView:SetOwnerView("VW_GRID", 'GRID')
    oView:EnableControlBar(.T.)
 
    oView:AddIncrementField("VW_GRID", "ZIO_ITEM")

    oView:SetViewProperty( "VW_GRID" , "ENABLENEWGRID" ) 
    // oView:SetViewProperty( "VW_GRID", "GRIDNOORDER")
    oView:SetViewProperty( "VW_GRID", "GRIDFILTER", {.T.}) 
    oView:SetViewProperty( "VW_GRID", "GRIDSEEK", {.T.})

    oView:AddUserButton("Padrão Para Compra","",{|oView| U_ADCOM428(oView) } ,"",, {MODEL_OPERATION_INSERT ,MODEL_OPERATION_UPDATE, MODEL_OPERATION_VIEW} , .T. )   
    
    // oView:AddUserButton("Entregas","",{|oView| U_ADCOM417(), U_ADCOM428(oView) } ,"",, {MODEL_OPERATION_VIEW} , .T. )   

Return oView
/*/{Protheus.doc} getCmps
    Retorna campos do cabeçalho.
    @type  Static Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
Static Function getCmps()
Return "ZIO_FILIAL;ZIO_EMISSA;ZIO_NUMERO;ZIO_VERSAO;ZIO_DESC;ZIO_TIPO;ZIO_DTINI;ZIO_DTFIM;ZIO_STATUS;ZIO_INCLUS;ZIO_ALTERA;ZIO_DTAPRO;ZIO_HRAPRO;ZIO_CODAPR;ZIO_NMAPRO;ZIO_LGENCM;ZIO_FILENT;"
/*/{Protheus.doc} fValidGrid
    Valida linha.
    @type  Static Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
Static Function fValidGrid(oModelGRID)

    //Variáveis.
    Local lRet      := .T.
    Local nAux      := 0
    Local cTipo     := FWFldGet("ZIO_TIPO")
    Local lMp       := .F.

    For nAux := 1 To oModelGRID:Length() 

        oModelGRID:GoLine(nAux) 
         
        If oModelGRID:IsDeleted()
            Loop

        EndIf

        lMp := Alltrim(cValToChar(Posicione("SB1", 1, FWxFilial("SB1") + oModelGRID:GetValue("ZIO_CODPRO"), "B1_TIPO"))) == "MP"

        If Empty(Alltrim(cValToChar(oModelGRID:GetValue("ZIO_TPFRT"))))
            Help(Nil, Nil, "fValidGrid (ADCOM042P)", Nil, "Atenção! O item " + oModelGRID:GetValue("ZIO_ITEM") + " não possui tipo de frete vinculado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

        If Empty(oModelGRID:GetValue("ZIO_CODPRO")) .Or. Empty(oModelGRID:GetValue("ZIO_DESPRD"));
            .Or. oModelGRID:GetValue("ZIO_VLUNIT") <= 0 .Or. oModelGRID:GetValue("ZIO_QUANT") <= 0;
            .Or. oModelGRID:GetValue("ZIO_VLRTOT") <= 0 .Or. Empty(oModelGRID:GetValue("ZIO_CODFOR"));
            .Or. Empty(oModelGRID:GetValue("ZIO_LJFORN")) .Or. Empty(oModelGRID:GetValue("ZIO_CONDPA"));
            .Or. Empty(oModelGRID:GetValue("ZIO_CC"));
            .Or. Empty(oModelGRID:GetValue("ZIO_MOEDA"))

            lRet := .F.
            Help(Nil, Nil, "fValidGrid (ADCOM042P)", Nil, "Necessário informar o produto, moeda, valor unitário, quantidade, fornecedor, condição de pagamento e centro de custo.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            Exit
            
        EndIf

        //Everson - 10/10/2022 - Ticket 18465.
        If lRet .And. U_ADCOM42C(oModelGRID:GetValue("ZIO_CODFOR"), oModelGRID:GetValue("ZIO_LJFORN"))
            lRet := .F.
            Help(Nil, Nil, "fValidGrid (ADCOM042P)", Nil, "Fornecedor " + cValToChar(oModelGRID:GetValue("ZIO_CODFOR")) + "/" + cValToChar(oModelGRID:GetValue("ZIO_LJFORN")) + " está bloqueado pelo departamento de qualidade.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            Exit

        EndIf

        If lRet .And. cTipo <> "3" .And. ( ! Empty(oModelGRID:GetValue("ZIO_FORARM")) .Or. ! Empty(oModelGRID:GetValue("ZIO_LJFRAR")) .Or. ! Empty(oModelGRID:GetValue("ZIO_NMARMA")))
            lRet := .F.
            Help(Nil, Nil, "fValidGrid (ADCOM042P)", Nil, "Contrato não é de armazenagem em terceiro, mas os dados do fornecedor de armazenagem estão preenchidos.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            Exit

        EndIf

        If lRet .And. cTipo == "3" .And. (Empty(oModelGRID:GetValue("ZIO_FORARM")) .Or. Empty(oModelGRID:GetValue("ZIO_LJFRAR")) .Or. Empty(oModelGRID:GetValue("ZIO_NMARMA"))) .And. lMp
            lRet := .F.
            Help(Nil, Nil, "fValidGrid (ADCOM042P)", Nil, "Necessário informar os dados do fornecedor de armazenagem.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            Exit

        EndIf

        If lRet .And. cTipo == "3" .And. U_ADCOM42C(oModelGRID:GetValue("ZIO_FORARM"), oModelGRID:GetValue("ZIO_LJFRAR"))
            lRet := .F.
            Help(Nil, Nil, "fValidGrid (ADCOM042P)", Nil, "Fornecedor " + cValToChar(oModelGRID:GetValue("ZIO_FORARM")) + "/" + cValToChar(oModelGRID:GetValue("ZIO_LJFRAR")) + " está bloqueado pelo departamento de qualidade.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            Exit

        EndIf

        If lRet .And. cTipo == "3" .And. ! lMp .And. ( ! Empty(oModelGRID:GetValue("ZIO_FORARM")) .Or. ! Empty(oModelGRID:GetValue("ZIO_LJFRAR")) .Or. ! Empty(oModelGRID:GetValue("ZIO_NMARMA")))
            lRet := .F.
            Help(Nil, Nil, "fValidGrid (ADCOM042P)", Nil, "O produto " + oModelGRID:GetValue("ZIO_CODPRO") + " não é matéria-prima, mas os dados do fornecedor de armazenagem estão preenchidos.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            Exit

        EndIf

    Next nAux
 
Return lRet
/*/{Protheus.doc} pValidGrid
    Pré-validação da linha.
    @type  Static Function
    @author Everson
    @since 20/02/2023
    @version 01
/*/
Static Function pValidGrid(oStrGrid, nLine, cAction, cIDField, xValue, xCurrentValue)

    //Variáveis.
    Local aArea     := GetArea()
    Local cPed      := oStrGrid:GetValue("ZIO_PEDCOM")
    Local cPedRem   := oStrGrid:GetValue("ZIO_PEDCO2")
    Local cPedArm   := oStrGrid:GetValue("ZIO_PEDARM")

    If cAction == 'DELETE' .And. (! Empty(cPed) .Or. ! Empty(cPedRem) .Or. ! Empty(cPedArm))
        Help(Nil, Nil, "Função pValidGrid(ADCOM042P)", Nil, "Linha não pode ser excluída, pois já possui pedido vinculado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If cAction == "CANSETVALUE" .And. cIDField == "ZIO_CODFOR" .And. ! Empty(cPed)
        RestArea(aArea)
        Return .F.

    EndIf

    If cAction == "CANSETVALUE" .And. cIDField == "ZIO_FORARM" .And. ! Empty(cPedArm)
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)
    
Return .T.
/*/{Protheus.doc} vldPos
    Pós validação.
    @type  Static Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
Static Function vldPos(oModel)

    //Variáveis.
    Local aArea      := GetArea()
    Local lRet       := .T.
    Local nOperation := oModel:GetOperation()
    Local cDesc      := oModel:GetValue("MD_MASTER","ZIO_DESC")
    Local dDtIni     := oModel:GetValue("MD_MASTER","ZIO_DTINI")
    Local dDtFim     := oModel:GetValue("MD_MASTER","ZIO_DTFIM")
    Local dDtEmiss   := oModel:GetValue("MD_MASTER","ZIO_EMISSA")
    Local cTipo      := oModel:GetValue("MD_MASTER","ZIO_TIPO")

    If lRet .And. nOperation == MODEL_OPERATION_INSERT

        If Empty(cDesc) .Or. Empty(dDtIni) .Or. Empty(dDtFim) .Or. Empty(cTipo) .Or. Empty(dDtEmiss)
            lRet := .F.
            Help(Nil, Nil, "Função vldPos(ADCOM042P)", Nil, "Necessário preencher data de emissão, descrição, data inicial, data final e tipo do contrato.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        
        EndIf

        If lRet
            oModel:SetValue("MD_MASTER", "ZIO_INCLUS", DToC(Date()) + " " + Time() + " " + Alltrim(cUserName))

        EndIf

        If lRet
            lRet := fValidGrid(oModel:GetModel("MD_GRID"))

        EndIf

    EndIf

    If lRet .And. nOperation == MODEL_OPERATION_UPDATE

        oModel:SetValue("MD_MASTER", "ZIO_ALTERA", DToC(Date()) + " " + Time() + " " + Alltrim(cUserName))

        If lRet .And.; 
           ! IsInCallStack("U_ADCOM427") .And.; //Envia contrato para aprovação.
           ! IsInCallStack("U_ADCOM424") .And.; //Aprova contrato.
           ! IsInCallStack("U_ADCOM429") .And.; //Gera pedido de compra.
           ! IsInCallStack("U_ADCOM42I") .And.; //Encerramento automático do contrato.
           ! IsInCallStack("U_ADCOM42A")        //Encerra contrato manualmente.

            lRet := gridFocus() .And. fValidGrid(oModel:GetModel("MD_GRID"))

            If lRet

                oModel:SetValue("MD_MASTER", "ZIO_DTAPRO", CToD(" / / "))
                oModel:SetValue("MD_MASTER", "ZIO_HRAPRO", "")
                oModel:SetValue("MD_MASTER", "ZIO_CODAPR", "")
                oModel:SetValue("MD_MASTER", "ZIO_NMAPRO", "")
                
                If oModel:GetValue("MD_MASTER", "ZIO_STATUS") $"2/3/4"
                    oModel:SetValue("MD_MASTER", "ZIO_STATUS", "5")

                EndIf

            EndIf

        EndIf

    EndIf

    If lRet .And. nOperation == MODEL_OPERATION_DELETE

        If U_ADCOM425(oModel:GetValue("MD_MASTER","ZIO_NUMERO"), oModel:GetValue("MD_MASTER","ZIO_VERSAO"))
            U_ADCOM42K("D", ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO, ZIO->ZIO_CODFOR, ZIO->ZIO_LJFORN, ZIO->ZIO_DESC)

        EndIf

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} gridFocus
    Função executada quando a grid ganha foco.
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
Static Function gridFocus()

    //Variáveis.
    Local aArea     := GetArea()
    Local oModel    := FWModelActive()
    Local oView     := FWViewActive()
    Local cDesc     := oModel:GetValue("MD_MASTER","ZIO_DESC")
    Local dDtIni    := oModel:GetValue("MD_MASTER","ZIO_DTINI")
    Local dDtFim    := oModel:GetValue("MD_MASTER","ZIO_DTFIM")
    Local dDtEmiss  := oModel:GetValue("MD_MASTER","ZIO_EMISSA")
    Local cTipo     := oModel:GetValue("MD_MASTER","ZIO_TIPO")
    Local cFilEnt   := oModel:GetValue("MD_MASTER","ZIO_FILENT")
    Local nOperation:= oModel:GetOperation() 

    //Everson - 04/01/2023 - ticket 18465.
    If nOperation == 1 .Or. nOperation == 2
        RestArea(aArea)
        Return .T.

    EndIf

    If Empty(cDesc) .Or. Empty(dDtIni) .Or. Empty(dDtFim) .Or. Empty(cTipo) .Or. Empty(dDtEmiss) .Or. Empty(cFilEnt)
        Help(Nil, Nil, "Função gridFocus(ADCOM042P)", Nil, "Necessário preencher data de emissão, descrição, data inicial, data final, tipo do contrato e filial de entrega.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        
        If ValType(oView) == "O"
            oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIO_DESC"):OCtrl:SetFocus()

        EndIf

        RestArea(aArea)
        Return .F.

    EndIf

    // If dDtIni < Date()
    //     Help(Nil, Nil, "Função gridFocus(ADCOM042P)", Nil, "Data inicial não pode ser menor que a data corrente.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
    //     oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIO_DESC"):OCtrl:SetFocus()
    //     RestArea(aArea)
    //     Return .F.

    // EndIf

    If dDtIni > dDtFim
        Help(Nil, Nil, "Função gridFocus(ADCOM042P)", Nil, "Data inicial não pode ser maior que a data final.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        If ValType(oView) == "O"
            oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIO_DESC"):OCtrl:SetFocus()

        EndIf

        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function ADCOM421
    Inclusão.
    @type  Function
    @author user
    @since 04/08/2022
    @version 01
/*/
User Function ADCOM421()

    //Variáveis.
    Local aEnableButtons := {}

    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.T., "Confirmar"})
    Aadd(aEnableButtons, {.T., "Cancelar"})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})

    FWExecView("", "ADCOM042P", 3, , , , , aEnableButtons)

Return Nil
/*/{Protheus.doc} User Function ADCOM422
    Alteração.
    @type  Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
User Function ADCOM422()

    //Variáveis.
    Local aArea  := GetArea()
    // Local cVerAnt:= ""
    Local aEnableButtons := {}

    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.T., "Confirmar"})
    Aadd(aEnableButtons, {.T., "Cancelar"})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})

    If ZIO_STATUS $ "6/8"
        Help(Nil, Nil, "Função ADCOM422(ADCOM042P)", Nil, "Operação não permitida, contrato encerrado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Nil

    EndIF

    FWExecView("", "ADCOM042P", 4, , , , , aEnableButtons)
    
    // If ZIO->ZIO_STATUS $"1" //Aberto, enviado para aprovação, aprovado, reprovado.
    
    //     FWExecView("", "ADCOM042P", 4, , , , , aEnableButtons)

    // Else

    //     If ! MsgYesNo("O status do contrato não permite alteração. Deseja criar uma nova versão?", "Função ADCOM422(ADCOM042P)")
    //         RestArea(aArea)
    //         Return Nil
        
    //     EndIf

    //     cVerAnt := obtVerAnt(ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO, .T.)

    //     If ! Empty(cVerAnt)
    //         Help(Nil, Nil, "Função ADCOM422(ADCOM042P)", Nil, "Já há a versao " + cVerAnt + " do contrato " + ZIO->ZIO_NUMERO + " em aberto. Altere esta versão ou exclua a mesma.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
    //         RestArea(aArea)
    //         Return Nil

    //     EndIf

    //     FWExecView("", "ADCOM042P", 9, , , , , aEnableButtons)

    // EndIf
    
    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADCOM422
    Exclusão.
    @type  Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
User Function ADCOM423()

    //Variáveis.
    Local aArea  := GetArea()

    If ZIO->ZIO_STATUS <> "1" //Aberto
        Help(Nil, Nil, "Função ADCOM423(ADCOM042P)", Nil, "Operação não permitida.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return Nil

    EndIf

    FWExecView("", "ADCOM042P", 5)
    
    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADCOM424
    Aprova contrato.
    @type  Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
User Function ADCOM424(cAcao, cContrato, cVersao, lAut, cMsgError)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oModel    := Nil
    Local aError    := {}
    Local cVerAnt   := ""
    Local cTxtAcao  := Iif(cAcao == "A", "aprovar", "reprovar")
    Local cEmail    := Alltrim(cValToChar(GetMv("MV_#COM422",,"sistemas@adoro.com.br")))
    Local cMsgEmail := ""

    Default lAut      := .F.
    Default cMsgError := ""

    If ! U_ADCOM425(cContrato, cVersao)
        cMsgError := "Contrato " + cContrato + " versão " + cVersao + " não localizado."
        Help(Nil, Nil, "Função ADCOM424(ADCOM042P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If ZIO->ZIO_STATUS <> "2"
        cMsgError := "Operação não permitida, contrato precisa ser enviado para aprovação, ou já passou pelo processo de aprovação."
        Help(Nil, Nil, "Função ADCOM424(ADCOM042P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .T.

    EndIf

    If ! lAut .And. ! MsgYesNo("Deseja " + cTxtAcao + " o contrato " + cContrato + " versão " + cVersao + "?", "Função ADCOM424(ADCOM042P)")
        RestArea(aArea)
        Return .F.

    EndIf
    
    Begin Transaction

        oModel := FwLoadModel("ADCOM042P")
        oModel:SetOperation(MODEL_OPERATION_UPDATE)
        oModel:Activate()

        oModel:SetValue("MD_MASTER", "ZIO_DTAPRO"   , Date())
        oModel:SetValue("MD_MASTER", "ZIO_HRAPRO"   , Time())
        oModel:SetValue("MD_MASTER", "ZIO_CODAPR"   , __cUserID)
        oModel:SetValue("MD_MASTER", "ZIO_NMAPRO"   , cUserName)
        oModel:SetValue("MD_MASTER", "ZIO_STATUS"   , Iif(cAcao == "A", "3", "4"))

        If oModel:VldData()
        
            oModel:CommitData()

            cVerAnt := obtVerAnt(cContrato, cVersao, .F.)

            If ! Empty(cVerAnt)

                If ! U_ADCOM42A(.F., cContrato, cVerAnt)
                    DisarmTransaction()
                    Break

                EndIf

            EndIf

            If cAcao == "A"

                //Everson - 03/02/2023 - ticket 18465 - Aprovação dos pedidos de compra.
                If ! U_ADCOM425(cContrato, cVersao)
                    lRet := .F.
                    cMsgError := "Contrato " + cContrato + " versão " + cVersao + " não localizado."
                    DisarmTransaction()
                    Break

                EndIf

                While ! ZIO->(Eof()) .And. ZIO->ZIO_FILIAL == FWxFilial("ZIO") .And. ZIO->ZIO_NUMERO == cContrato .And. ZIO->ZIO_VERSAO == cVersao

                    If ! Empty(ZIO->ZIO_PEDCOM) .And. ! aprSC7(ZIO->ZIO_PEDCOM, @cMsgError)         
                        DisarmTransaction()
                        Break

                    EndIf

                    If ! Empty(ZIO->ZIO_PEDCO2) .And. ! aprSC7(ZIO->ZIO_PEDCO2, @cMsgError)             
                        DisarmTransaction()
                        Break

                    EndIf
                
                    ZIO->(DbSkip())

                End

            // ElseIf cAcao == "R" .And. ! cncPdCom(cContrato, cVersao, @cMsgError)
            //     DisarmTransaction()
            //     Break

            End
            //

            lRet := .T.

        Else
            aError := oModel:GetErrorMessage()
            cMsgError := Alltrim(cValToChar(aError[MODEL_MSGERR_MESSAGE]))
            DisarmTransaction()
            Break

        EndIf

        If U_ADCOM425(cContrato, cVersao)
            U_ADCOM42K("D", ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO, ZIO->ZIO_CODFOR, ZIO->ZIO_LJFORN, ZIO->ZIO_DESC)

        EndIf

    End Transaction

    oModel:DeActivate()
    oModel:Destroy()
    oModel := Nil

    If ! Empty(cMsgError)
        Help(Nil, Nil, "Função ADCOM424(ADCOM042P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    Else
        
        //Everson - 18/01/2023 - Ticket 18465.
        cMsgEmail := "Contrato de compra de matéria-prima " + cContrato + " versão " + cVersao + xPula
        cMsgEmail += "foi " + Iif(cAcao == "A", "aprovado", "reprovado") + " pelo usuário " + cUserName + "." + xPula

        U_EnviaEmail(GetMv("MV_RELFROM"), cEmail, cMsgEmail, "Aprovação de Contrato de MP " + cContrato + " V. " + cVersao,"")

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} aprSC7
    Aprovação pedido de compra.
    @type  Static Function
    @author Everson
    @since 03/02/2023
    @version 01
/*/
Static Function aprSC7(cNumPc, cMsgErro)

    //Variáveis.
    Local aArea := GetArea()

    Default cMsgErro := ""

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    If ! SC7->( DbSeek( FWxFilial("SC7") + cNumPc ) )
        cMsgErro := "Pedido " + cValToChar(cNumPc) + " não localizado"
        RestArea(aArea)
        Return .F.       

    EndIf

    RecLock("SC7", .F.)
        SC7->C7_CONAPRO := "L"
    MsUnlock()

    U_grvSC7Barr(SC7->C7_NUM, .T., .F., 4)

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} User Function obtVerAnt
    Obtém a versao anterior em aberta do contrato.
    @type  Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
Static Function obtVerAnt(cContrato, cVersao, lAberto)

    //Variáveis
    Local aArea   := GetArea()
    Local cVerAnt := Iif(lAberto, "0", "9999")

    Default lAberto := .F.

    If ! U_ADCOM425(cContrato)
        RestArea(aArea)
        Return ""

    EndIF

    While ! ZIO->(Eof()) .And. ZIO->ZIO_FILIAL == FWxFilial("ZIO") .And. ZIO->ZIO_NUMERO == cContrato

        If lAberto
            
            If ZIO->ZIO_STATUS $ "1/2/3/4" .And. ZIO->ZIO_VERSAO <> cVersao
                cVerAnt := ZIO->ZIO_VERSAO
                Exit

            EndIf

        Else

            If ZIO->ZIO_STATUS $ "5/7" .And. ZIO->ZIO_VERSAO <> cVersao
                cVerAnt := ZIO->ZIO_VERSAO
                Exit
                
            EndIf

        EndIf

        ZIO->(DbSkip())

    End

    If lAberto .And. cVerAnt == "0"
        cVerAnt := ""

    ElseIf ! lAberto .And. cVerAnt == "9999"
        cVerAnt := ""

    EndIf

    RestArea(aArea)

Return cVerAnt
/*/{Protheus.doc} User Function ADCOM424
    Posiciona no registro.
    @type  Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
User Function ADCOM425(cContrato, cVersao)

    //Variáveis.
    Local lRet := .F.

    Default cContrato := ""
    Default cVersao   := ""

    DbSelectArea("ZIO")
    ZIO->(DbSetOrder(2))
    lRet := ZIO->( DbSeek( FWxFilial("ZIO") + cContrato + cVersao ) )

Return lRet
/*/{Protheus.doc} User Function ADCOM426
    Atualiza campo.
    @type  Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
User Function ADCOM426(cContrato, cVersao, cCampo, xValor, cMsgError)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local aError    := {}
    Local oModel    := Nil
    
    Default cMsgError := ""

    If ! U_ADCOM425(cContrato, cVersao)
        cMsgError := "Contrato " + cContrato + " versão " + cVersao + " não localizado."
        Help(Nil, Nil, "Função ADCOM426(ADCOM042P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    oModel := FwLoadModel("ADCOM042P")
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
       Help(Nil, Nil, "Função ADCOM426(ADCOM042P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADCOM427
    Envia para aprovação.
    @type  Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
User Function ADCOM427(cContrato, cVersao)

    //Variáveis.
    Local aArea     := GetArea()
    Local cEmail    := Alltrim(cValToChar(GetMv("MV_#COM423",,"sistemas@adoro.com.br")))
    Local cMsgEmail := ""

    If ! U_ADCOM425(cContrato, cVersao)
        MsgInfo("Contrato " + cContrato + " versão " + cVersao + " não localizado.", "Função ADCOM427(ADCOM042P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If ZIO->ZIO_STATUS <> "5" //Everson - 03/02/2023 - ticket 18465.
        Help(Nil, Nil, "Função ADCOM427(ADCOM042P)", Nil, "Contrato " + ZIO->ZIO_NUMERO + " versão " + ZIO->ZIO_VERSAO + " já passou por processo de aprovação ou está em aberto.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .T.

    EndIf

    If ! MsgYesNo("Deseja enviar o contrato " + ZIO->ZIO_NUMERO + " versão " + ZIO->ZIO_VERSAO + " para aprovação?", "Função ADCOM427(ADCOM042P)")
        RestArea(aArea)
        Return .F.

    EndIf

    lRet := U_ADCOM426(ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO, "ZIO_STATUS", "2")

    //Everson - 18/01/2023 - Ticket 18465.
    If lRet

        U_ADCOM42K("I", ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO, ZIO->ZIO_CODFOR, ZIO->ZIO_LJFORN, ZIO->ZIO_DESC)
        
        cMsgEmail := "Contrato de compra de matéria-prima " + ZIO->ZIO_NUMERO + " versão " + ZIO->ZIO_VERSAO + xPula
        cMsgEmail += "está pendente de aprovação." + xPula

        U_EnviaEmail(GetMv("MV_RELFROM"), cEmail, cMsgEmail, "Pendente Aprovação de Contrato de MP " + ZIO->ZIO_NUMERO + " V. " + ZIO->ZIO_VERSAO,"")

    EndIf
    
    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADCOM428
    Lançamento de padrão de compra.
    @type  Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
User Function ADCOM428(oView)

    //Variáveis.
    Local aArea     := GetArea()
    Local oHeader   := oView:GetModel("MD_MASTER")
    Local oGrid     := oView:GetModel("MD_GRID")
    Local cProduto  := oGrid:GetValue("ZIO_CODPRO")
    Local cContrato := oHeader:GetValue("ZIO_NUMERO")
    Local cVersao   := oHeader:GetValue("ZIO_VERSAO")
    Local cItemCT   := oGrid:GetValue("ZIO_ITEM")
    Local cFornece  := oGrid:GetValue("ZIO_CODFOR")
    Local cLoja     := oGrid:GetValue("ZIO_LJFORN")
    Local cNmFornec := oGrid:GetValue("ZIO_NMFORN")
    Local nOperation:= oHeader:GetOperation()
    Local aEnableButtons := {}

    If nOperation <> 1 .And. nOperation <> 2 .And. ! fValidGrid(oGrid)
        RestArea(aArea)
        Return .F.

    EndIf

    If ! U_ADQUA71(cProduto)
        Help(Nil, Nil, "Função ADCOM428(ADCOM042P)", Nil, "Não há exame cadastrado para o produto " + cProduto + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If nOperation <> 1 .And. ! MsgYesNo("Deseja fazer o preenchimento do padrão de compra?", "Função ADCOM428(ADCOM042P)")
        RestArea(aArea)
        Return .F.
        
    EndIf

    If ! U_ADCOM412(cContrato, cVersao, cItemCT, cFornece, cLoja, cProduto) .And. ! U_ADCOM411(cContrato, cVersao, cItemCT, cFornece, cLoja, cNmFornec, cProduto)
        Help(Nil, Nil, "Função ADCOM428(ADCOM042P)", Nil, "Não foi possível carregar os registros.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.T., "Confirmar"})
    Aadd(aEnableButtons, {.T., "Cancelar"})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    Aadd(aEnableButtons, {.F., Nil})
    
    If U_ADCOM412(cContrato, cVersao, cItemCT, cFornece, cLoja, cProduto) 
        FWExecView("", "ADCOM041P", Iif(nOperation == 1, 1, 4), , , , , aEnableButtons)

    Else
        Help(Nil, Nil, "Função ADCOM428(ADCOM042P)", Nil, "Não foi possível carregar os registros.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    RestArea(aArea)
    
Return .T.
/*/{Protheus.doc} ADCOM429
    Gera pedido de compra.
    @type  Static Function
    @author Everson
    @since 04/08/2022
    @version 01
/*/
User Function ADCOM429(nOpcE, aLAltera, aLInclui, aLExclui) // U_ADCOM429 - Everson, 17/03/2023, Ticket 18465. 

    //Variáveis.
    Local aArea     := GetArea()
    Local oView     := FWViewActive()
    Local nOpc      := nOpcE
    Local lRet      := .F.
    Local cContrato := ZIO->ZIO_NUMERO
    Local cVersao   := ZIO->ZIO_VERSAO
    Local aCab      := {}
    Local aLinha    := {}
    Local aItens    := {}
    Local cFornece  := ""
    Local cLoja     := ""
    Local cCond     := ""
    Local cNumPc    := ""
    Local cProduto  := ""
    Local nQuant    := 0
    Local nPrcUnt   := 0
    Local nVlrTot   := 0
    Local cCC       := ""
    Local cResp     := Alltrim(cValToChar(GetMv("MV_#COM421",,"FERNANDO LUTFALLA")))
    Local cObs      := ""
    Local cMsgErro  := ""
    Local nAlICMS   := 0
    Local nAlIPI    := 0
    Local dDtBack   := dDataBase
    Local nTaxaM    := 0
    Local cItensPC  := ""
    Local cItensPV  := ""
    Local lProdMP   := .F.
    Local nLinha    := 1
    Local lExecAuto := .F.
    Local cPedCndAnt:= ""
    Local cCondAnt  := Alltrim(cValToChar(GetMv("MV_#COM424",,"00")))

    Private lMsErroAuto    := .F.
    Private lMsHelpAuto    := .T.
    Private lAutoErrNoFile := .F.

    //Everson, 17/03/2023, Ticket 18465.
    Default nOpcE    := 3
    Default aLAltera := {}
    Default aLInclui := {}
    Default aLExclui := {}

    If ! U_ADCOM425(cContrato, cVersao)
        MsgInfo("Contrato " + cContrato + " versão " + cVersao + " não localizado.", "Função ADCOM429(ADCOM042P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If nOpc == 3 .And. ZIO->ZIO_STATUS <> "1" //Everson - 03/02/2023 - ticket 18465.
        MsgInfo("Operação não permitida. É necessário que o contrato esteja com status aberto.", "Função ADCOM429(ADCOM042P)")
        RestArea(aArea)
        Return .F.

    EndIf

    If nOpc == 3 .And. ! MsgYesNo("Deseja gerar pedido(s) de compra para o contrato " + cContrato + " versão " + cVersao + "?", "Função ADCOM429(ADCOM042P)")
        RestArea(aArea)
        Return .F.

    EndIf

	DbSelectArea("SA2")
	SA2->(DbSetOrder(1))

	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))

	DbSelectArea("SB1")
	SB1->(DbSetOrder(1))

    Begin Transaction

        While ! ZIO->(Eof()) .And. ZIO->ZIO_FILIAL == FWxFilial("ZIO") .And. ZIO->ZIO_NUMERO == cContrato .And. ZIO->ZIO_VERSAO == cVersao

            nOpc      := nOpcE
            lExecAuto := .F.

            If nOpc == 3 .Or. Ascan(aLInclui, nLinha) > 0
                lExecAuto := .T.
                nOpc      := 3

            ElseIf Ascan(aLExclui, nLinha) > 0
                nOpc := 5
                lExecAuto := .T.

            ElseIf Ascan(aLAltera, nLinha) > 0
                nOpc := 4
                lExecAuto := .T.
                
            EndIf
            
            nTaxaM    := 0
            lProdMP   := .F.
            dDataBase := ZIO->ZIO_EMISSA
            
            If ZIO->ZIO_MOEDA <> "1"

                
                //nTaxaM := RecMoeda(dDataBase, "0" + ZIO->ZIO_MOEDA)  // Wagner - 25/04/2023 - Ticket 91984
                nTaxaM := 0

                // Wagner - 25/04/2023 - Ticket 91984
                /*                 
                If nTaxaM <= 0
                    cMsgErro := "Não há moeda cadastrada para data " + DToC(dDataBase)
                    DisarmTransaction()
                    Break

                EndIf */

            EndIf

            aCab   := {}
            aLinha := {}
            aItens := {}

            If ZIO->ZIO_TIPO $"3" .And. lProdMP .And. (ZIO->ZIO_ITEM $cItensPV)

                cFornece := ZIO->ZIO_FORARM
                cLoja    := ZIO->ZIO_LJFRAR

            Else

                cFornece := ZIO->ZIO_CODFOR
                cLoja    := ZIO->ZIO_LJFORN

                If nOpc == 4 .Or. nOpc == 5
                
                    If ! SC7->( DbSeek( FWxFilial("SC7") + ZIO->ZIO_PEDCOM ))
                        cMsgErro := "Pedido de compra " + ZIO->ZIO_PEDCOM + " não localizado"
                        DisarmTransaction()
                        Break

                    EndIf

                    If SC7->C7_QUJE > 0
                        cMsgErro := "Pedido de compra " + ZIO->ZIO_PEDCOM + " já possui entregas realizadas e não poderá ser alterado"
                        ZIO->(DbSkip())
                        nLinha++
                        Loop

                    EndIf

                    If Empty(cNumPc) .Or. Empty(ZIO->ZIO_PEDCO2)
                        cNumPc := ZIO->ZIO_PEDCOM

                    Else
                        cNumPc := ZIO->ZIO_PEDCO2

                    EndIf
                    
                    Aadd(aCab,{"C7_NUM", cNumPc})

                EndIf

            EndIf

            cCond    := ZIO->ZIO_CONDPA
            cProduto := ZIO->ZIO_CODPRO
            nQuant   := ZIO->ZIO_QUANT
            nPrcUnt  := ZIO->ZIO_VLUNIT
            nVlrTot  := ZIO->ZIO_VLRTOT
            cCC      := ZIO->ZIO_CC
            cObs     := ZIO->ZIO_OBS
            nAlICMS  := ZIO->ZIO_ALICMS
            nAlIPI   := ZIO->ZIO_ALQIPI

            If ! SB1->(DbSeek( FWxFilial("SB1") + cProduto ))
                cMsgErro := "Produto " + cProduto + " não localizado"
                DisarmTransaction()
                Break

            EndIf

            lProdMP := Alltrim(cValToChar(SB1->B1_TIPO)) == "MP"
            
            If nOpc == 3

                Aadd(aCab,{"C7_FILENT"	, FWxFilial("SC7")})
                Aadd(aCab,{"C7_EMISSAO"	, dDataBase	})
                Aadd(aCab,{"C7_DATPRF"	, dDataBase	})
                Aadd(aCab,{"C7_FORNECE"	, cFornece  })
                Aadd(aCab,{"C7_LOJA" 	, cLoja  	})

            ElseIf nOpc == 4

                Aadd(aCab,{"C7_FILENT"	, SC7->C7_FILENT })
                Aadd(aCab,{"C7_EMISSAO"	, SC7->C7_EMISSAO })
                Aadd(aCab,{"C7_DATPRF"	, SC7->C7_DATPRF })
                Aadd(aCab,{"C7_FORNECE"	, SC7->C7_FORNECE })
                Aadd(aCab,{"C7_LOJA" 	, SC7->C7_LOJA })

            EndIf

            Aadd(aCab,{"C7_COND"	, cCond   	})
            Aadd(aCab,{"C7_TXMOEDA"	, nTaxaM   	})
            Aadd(aCab,{"C7_CONTATO"	, ""        })
            Aadd(aCab,{"C7_TPFRETE"	, ZIO->ZIO_TPFRT }) //Everson - 05/12/2022 - ticket 18465.
            Aadd(aCab,{"C7_MOEDA"	, Val(cValToChar(ZIO->ZIO_MOEDA)) }) //Everson - 05/12/2022 - ticket 18465.

            Aadd(aLinha,{"C7_PRODUTO" , cProduto, Nil})
            Aadd(aLinha,{"C7_QUANT"   , nQuant  , Nil})
            Aadd(aLinha,{"C7_PRECO"   , nPrcUnt , Nil})
            Aadd(aLinha,{"C7_TOTAL"   , nVlrTot , Nil})
            Aadd(aLinha,{"C7_CC" 	  , cCC     , Nil})
            Aadd(aLinha,{"C7_XRESPON" , cResp   , Nil})
            Aadd(aLinha,{"C7_OBS" 	  , cObs    , Nil}) 

            Aadd(aLinha,{"C7_PICM"   , nAlICMS, Nil})
            Aadd(aLinha,{"C7_IPI"    , nAlIPI, Nil})

            Aadd(aItens,aLinha)

            If nOpc == 4

                While ! SC7->(Eof()) .And. SC7->C7_FILIAL == FWxFilial("SC7") .And. SC7->C7_NUM == cNumPc

                    aLinha := {} 
                    Aadd(aLinha,{"LINPOS","C7_ITEM", SC7->C7_ITEM})
                    Aadd(aLinha,{"AUTDELETA","S", Nil})        
                    Aadd(aLinha,{"C7_FILIAL" , FWxFilial("SC7")  , Nil})  
                    Aadd(aLinha,{"C7_NUM"    , cNumPc            , Nil})          	      
                    Aadd(aLinha,{"C7_ITEM"   , SC7->C7_ITEM      , Nil})
                    Aadd(aLinha,{"C7_PRODUTO", SC7->C7_PRODUTO   , Nil})
                    Aadd(aLinha,{"C7_QUANT"  , SC7->C7_QUANT     , Nil})
                    Aadd(aLinha,{"C7_PRECO"  , SC7->C7_PRECO     , Nil})
                    Aadd(aLinha,{"C7_TOTAL"  , SC7->C7_TOTAL     , Nil})

                    Aadd(aItens,aLinha)

                    SC7->(DbSkip())

                End

            EndIf
            
            If nOpc == 3

                cNumPc := u_SXESXF("SC7")
                SC7->( DbGoTop() )
                Do While .T.

                    SC7->( DbSetOrder(1) )

                    If SC7->( DbSeek( FwxFilial("SC7") + cNumPc ) )
                        cNumPc := u_SXESXF("SC7")

                    Else
                        Exit

                    EndIf

                EndDo

                Aadd(aCab,{"C7_NUM", cNumPc})

            EndIf

            lMsErroAuto := .F.         

            If lExecAuto
                SetFunName("MATA120")
                MSExecAuto({|u,v,x,y| MATA120(u,v,x,y)}, 1, aCab, aItens, nOpc) 

            EndIf

            If lMsErroAuto 
                lRet := .F.
                cMsgErro := MostraErro()
                DisarmTransaction()
                Break

            Else 

                DbSelectArea("SC7")
                SC7->(DbSetOrder(1))
                If ! SC7->( DbSeek( FWxFilial("SC7") + cNumPc ) )
                    lRet := .F.
                    cMsgErro := "Pedido " + cValToChar(cNumPc) + " não localizado"
                    DisarmTransaction()
                    Break

                EndIf

                If Alltrim(cValToChar(SC7->C7_COND)) $cCondAnt
                    cPedCndAnt += cNumPc + xPula

                EndIf

                If cNumPc <> SC7->C7_NUM
                    lRet := .F.
                    cMsgErro := "Pedido divergente " + cValToChar(cNumPc) + " " + cValToChar(SC7->C7_NUM)
                    DisarmTransaction()
                    Break

                EndIf

                RecLock("SC7", .F.)
                    SC7->C7_CONAPRO := "B"
                    SC7->C7_XCTRCOM := ZIO->ZIO_NUMERO
                    SC7->C7_XTPCONT := ZIO->ZIO_TIPO
                    SC7->C7_XCTRVER := ZIO->ZIO_VERSAO //Everson - 25/10/2022 - ticket 18465.
                    SC7->C7_TPFRETE := ZIO->ZIO_TPFRT  //Wagner - 27/04/2023 - Ticket 92896
                MsUnlock()

                ////Everson - 03/02/2023 - ticket 18465.
                // //Everson - 20/10/2022 - ticket 18465.
                If nOpc == 3
                
                    RecLock("ZIO", .F.)
                        
                        If !(ZIO->ZIO_ITEM $cItensPC)
                            ZIO->ZIO_PEDCOM := cNumPc

                        Else
                            ZIO->ZIO_PEDCO2 := cNumPc

                        EndIf

                    MsUnlock() 

                EndIf

                If TCSqlExec("UPDATE " + RetSqlName("SCR") + " SET D_E_L_E_T_ = '*' WHERE CR_FILIAL = '" + FWxFilial("SCR") + "' AND CR_NUM = '" + cNumPc + "' AND D_E_L_E_T_ = ''") < 0
                    lRet := .F.
                    cMsgErro := "Não foi possivel liberar o pedido " +  cNumPc + " " + xPula + TCSqlError()
                    DisarmTransaction()
                    Break

                EndIf

                U_grvSC7Barr(cNumPc, .T., .F., 4) //Everson - 18/10/2022 - ticket 18465.

                lRet := .T.

            EndIf

            dDataBase := dDtBack
            
            //Flag para gerar pedido de compra para recebimento das remessas.
            If ZIO->ZIO_TIPO $"2/3" .And. lProdMP .And. !(ZIO->ZIO_ITEM $cItensPC)
                cItensPC += ZIO->ZIO_ITEM + "/"
                Loop

            EndIf

            //Flag para gerar pedido de venda de saída para armazenagem.
            If ZIO->ZIO_TIPO $"3" .And. lProdMP .And. !(ZIO->ZIO_ITEM $cItensPV) .And. ! Empty(ZIO->ZIO_FORARM) .And. ! Empty(ZIO->ZIO_LJFRAR)

                cItensPV += ZIO->ZIO_ITEM + "/"

                If ! gerPedS(lExecAuto, nOpc, ZIO->ZIO_PEDARM, cContrato, cVersao, ZIO->ZIO_FORARM, ZIO->ZIO_LJFRAR, cProduto, nQuant, nPrcUnt, nVlrTot, @cMsgErro)
                    DisarmTransaction()
                    Break

                EndIf

            EndIf

            ZIO->(DbSkip())

            nLinha++

        End

        If lRet .And. ! U_ADCOM426(cContrato, cVersao, "ZIO_STATUS", "5")
            lRet := .F.
            DisarmTransaction()
            Break
            
        EndIf

    End Transaction

    If ! Empty(cPedCndAnt)
        MsgInfo("Os pedidos abaixo necessitam de programação para pagamento antecipado. " + xPula + cPedCndAnt, "Função ADCOM429(ADCOM042P)")

    EndIf

    If ValType(oView) == "O"
        oView:SetUpdateMessage("Contrato de Compra de MP", Iif(!Empty(cMsgErro), cMsgErro, "Processo finalizado."))

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function gerPedS
    Gera pedido de saída.
    @type  Function
    @author Everson
    @since 20/01/2023
    @version 01
/*/
Static Function gerPedS(lExecAuto, nOpc, cNumPed, cContrato, cVersao, cFornece, cLjForn, cProduto, nPesoTot, nVlrUnit, nTotal, cMsgError)

    //Variáveis.
    Local aArea    := GetArea()
    Local cEmail   := Alltrim(cValToChar(GetMv("MV_#EST756",,"noemi.ximenes@adoro.com.br;lucimara.luiz@adoro.com.br;rosangela@adoro.com.br;sistemas@adoro.com.br")))
    Local cMsgEmail:= ""
    Local cTes     := ""
    Local aCabec   := {}
    Local aLinha   := {}
    Local aItens   := {}
    Local cCliFor  := "F"

    Local cTpPed   := ""
    Local aCampo   := {}
    Local cLocPad  := ""

    Private lMsErroAuto    := .F.
    Private lMsHelpAuto    := .T.
    Private lAutoErrNoFile := .F.

    Default cMsgError      := ""

    If nOpc == 4 .Or. nOpc == 5

        DbSelectArea("SC5")
        SC5->(DbSetOrder(1))
        SC5->(DbGoTop())

        If ! SC5->( DbSeek(FWxFilial("SC5") + cNumPed) )
            cMsgError := "Pedido de venda " + cNumPed + " não localizado(SC5)"
            RestArea(aArea)
            Return .F.

        EndIf

        If ! Empty(SC5->C5_NOTA)
            cMsgError := "Pedido de venda " + cNumPed + " possui NF vinculada(C5_NOTA)"
            RestArea(aArea)
            Return .F.

        EndIf

        DbSelectArea("SC6")
        SC6->(DbSetOrder(1))
        SC6->(DbGoTop())

        If ! SC6->( DbSeek(FWxFilial("SC6") + cNumPed) )
            cMsgError := "Pedido de venda " + cNumPed + " não localizado(SC6)"
            RestArea(aArea)
            Return .F.

        EndIf

    EndIf

    If ! getInfo(cCliFor, @aCampo, @cTpPed, cFornece, cLjForn, @cMsgError)
        RestArea(aArea)
        Return .F.

    EndIf

    If aCampo[2,2] <> "SP"
        cTes := Alltrim(cValToChar(GetMv("MV_#COM413",,"827")))
    Else
        cTes := Alltrim(cValToChar(GetMv("MV_#COM412",,"827")))

    EndIf

    If nOpc == 3

        Aadd( aCabec, { "C5_TIPO"	  , cTpPed     , Nil } )
        Aadd( aCabec, { "C5_CLIENTE"  , cFornece   , Nil } )
        Aadd( aCabec, { "C5_LOJACLI"  , cLjForn    , Nil } )
        Aadd( aCabec, { "C5_LOJAENT"  , cLjForn    , Nil } )
        Aadd( aCabec, { "C5_CONDPAG"  , aCampo[5,2], Nil } )
        Aadd( aCabec, { "C5_ENDERE"   , aCampo[1,2], Nil } )
        Aadd( aCabec, { "C5_EST"      , aCampo[2,2], Nil } )
        Aadd( aCabec, { "C5_BAIRRO"   , aCampo[3,2], Nil } )
        Aadd( aCabec, { "C5_CIDADE"   , aCampo[4,2], Nil } )
        Aadd( aCabec, { "C5_DTENTR"   , Date() + 30, Nil } )
        Aadd( aCabec, { "C5_EMISSAO"  , Date()     , Nil } )
        Aadd( aCabec, { "C5_TPFRETE"  , "S"        , Nil } )
        Aadd( aCabec, { "C5_PESOL"    , nPesoTot   , Nil } )
        Aadd( aCabec, { "C5_PESOTOT"  , 0          , Nil } )
        Aadd( aCabec, { "C5_MENNOTA"  , "MERCADORIA ARMAZENADA QUE DEVERÁ RETORNAR", Nil } )

        Aadd( aCabec, { "C5_XCOTRMP"  , cContrato  , Nil } )
        Aadd( aCabec, { "C5_XVCTRMP"  , cVersao    , Nil } )

    ElseIf nOpc == 4

        Aadd( aCabec, { "C5_FILIAL"	  , FWxFilial("SC5") , Nil } )
        Aadd( aCabec, { "C5_NUM"	  , cNumPed          , Nil } )

    EndIf

    If ! RetArqProd(cProduto)
        cLocPad := Posicione("SBZ",1, FWxFilial("SBZ") + cProduto, "BZ_LOCPAD")
        
    Else
        cLocPad := Posicione("SB1",1, FWxFilial("SB1") + cProduto, "B1_LOCPAD")

    EndIf

    nPesoTot := Round(nPesoTot, 2)

    Aadd( aLinha, { "C6_ITEM"	 , "01"	    , Nil } )
    Aadd( aLinha, { "C6_PRODUTO" , cProduto	, Nil } )
    Aadd( aLinha, { "C6_UNSVEN"	 , nPesoTot	,0 , Nil } )
    Aadd( aLinha, { "C6_PRCVEN"	 , nVlrUnit	,0 , Nil } )
    Aadd( aLinha, { "C6_VALOR"	 , nTotal	,0 , Nil } )
    Aadd( aLinha, { "C6_TES"	 , cTes	    ,.F. } )
    Aadd( aLinha, { "C6_LOCAL"	 , cLocPad  , Nil } )
    Aadd( aLinha, { "C6_PRUNIT"	 , nVlrUnit	,0 , Nil } )

    Aadd(aItens, aLinha)
    
    If nOpc == 4

        While ! SC6->(Eof()) .And. SC6->C6_FILIAL == FWxFilial("SC6") .And. SC6->C6_NUM == cNumPed

            aLinha := {} 
            Aadd(aLinha,{"LINPOS","C6_ITEM",SC6->C6_ITEM})
            Aadd(aLinha,{"AUTDELETA","S", Nil})        
            Aadd(aLinha,{"C6_FILIAL" , FWxFilial("SC6") , Nil})  
            Aadd(aLinha,{"C6_NUM"    , cNumPed        , Nil})          	      
            Aadd(aLinha,{"C6_ITEM"   , SC6->C6_ITEM   , Nil})
            Aadd(aLinha,{"C6_PRODUTO", SC6->C6_PRODUTO, Nil})
            Aadd(aLinha,{"C6_QTDVEN" , SC6->C6_QTDVEN ,0 , Nil})
            Aadd(aLinha,{"C6_PRCVEN" , SC6->C6_PRCVEN ,0 , Nil})
            Aadd(aLinha,{"C6_VALOR"  , SC6->C6_VALOR  ,0 , Nil}) 
            Aadd(aLinha,{"C6_UNSVEN" , SC6->C6_UNSVEN ,0 , Nil})

            aAdd(aItens,aLinha)

            SC6->(DbSkip())

        End

    EndIf

    lMsErroAuto := .F.
    If lExecAuto
        MSExecAuto( { |x, y, z, p| MATA410(x, y, z,,,,,,, p) }, aCabec, aItens, nOpc)

    EndIf

    If lMsErroAuto
        cMsgError := MostraErro()
        RestArea(aArea)
        Return .F.

    Else

        If nOpc == 3

            RecLock("ZIO", .F.)
                ZIO->ZIO_PEDARM := SC5->C5_NUM
            ZIO->(MsUnlock())

            cMsgEmail := "Gerado pedido de remessa para armazenagem " + SC5->C5_NUM + " Filial " + cFilAnt + xPula
            cMsgEmail += "Fornecedor " + cFornece + "/" + cLjForn + " " + xPula + xPula + xPula
            cMsgEmail += "*** Necessário verificar o TES do pedido antes de emitir a NF ***" + xPula

            U_EnviaEmail(GetMv("MV_RELFROM"), cEmail, cMsgEmail, "Pedido de devolução " + SC5->C5_NUM,"")

        EndIf
  
    EndIf

    RestArea(aArea)

Return .T.
/*/{Protheus.doc} getInfo
    Obtém informações de cliente e fornecedor.
    @type  Static Function
    @author Everson
    @since 10/06/2022
    @version 01
/*/
Static Function getInfo(cCliFor, aCampo, cTpPed, cCodCF, cLoja, cMsgError)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.

    Default cMsgError := ""

    DbSelectArea("SA1")
    SA1->(DbSetOrder(1))
    SA1->(DbGoTop())

    DbSelectArea("SA2")
    SA2->(DbSetOrder(1))
    SA2->(DbGoTop())

    If cCliFor == "C"

        If ! SA1->( DbSeek( FWxFilial("SA1") + cCodCF + cLoja))
            cMsgError := "Cliente " + cCodCF + cLoja + " não localizado."

        Else
            lRet := .T.
            aCampo  := {{"A1_END", SA1->A1_END}, {"A1_EST", SA1->A1_EST}, {"A1_BAIRRO", SA1->A1_BAIRRO}, {"A1_CIDADE", SA1->A1_Mun}, {"A1_COND", SA1->A1_COND}}
            cTpPed  := "N"

        EndIf

    Else

        If ! SA2->( DbSeek( FWxFilial("SA2") + cCodCF + cLoja))
            cMsgError := "Fornecedor " + cCodCF + cLoja + " não localizado."

        Else
            lRet := .T.
            aCampo  := {{"A2_END", SA2->A2_END}, {"A2_EST", SA2->A2_EST}, {"A2_BAIRRO", SA2->A2_BAIRRO}, {"A2_CIDADE", SA2->A2_Mun}, {"A2_COND", SA2->A2_COND},  {"A2_COND", SA2->A2_COND}}
            cTpPed  := "B"

        EndIf

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADCOM42A
    Encerrar contrato manualmente.
    @type  Function
    @author Everson
    @since 05/08/2022
    @version 01
/*/
User Function ADCOM42A(lPergunta, cContrato, cVersao)

    //Variáveis.
    Local aArea      := GetArea()
    Local lRet       := .F.
    Local cMsgErro   := ""

    Default lPergunta  := .F.

    If ! U_ADCOM425(cContrato, cVersao)
        Help(Nil, Nil, "Função ADCOM42A(ADCOM042P)", Nil, "Contrato " + cContrato + " versão " + cVersao + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If !(ZIO->ZIO_STATUS $"1/2/3/4/5/7")
        Help(Nil, Nil, "Função ADCOM42A(ADCOM042P)", Nil, "Status do contrato não permite encerramento.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If lPergunta .And. ! MsgYesNo("Deseja encerrar o contrato " + cContrato + " versão " + cVersao + "?", "Função ADCOM42A(ADCOM042P)")
        RestArea(aArea)
        Return .F.

    EndIf

    Begin Transaction

        //Elimina resíduo dos pedidos de compra em aberto.
        If ! cncPdCom(cContrato, cVersao, @cMsgErro)
            DisarmTransaction()
            Break

        EndIf

        If ! U_ADCOM426(cContrato, cVersao, "ZIO_STATUS", "8", @cMsgErro)
            DisarmTransaction()
            Break

        EndIf

        lRet := .T.

    End Transaction

    If lPergunta .And. Empty(cMsgErro)
        MsgInfo("Processo finalizado", "Função ADCOM42A(ADCOM042P)")

    ElseIf lPergunta .And. ! Empty(cMsgErro)
        MsgInfo(cMsgErro, "Função ADCOM42A(ADCOM042P)")

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} cncPdCom
    Cancela pedidos de compra vinculados ao contrato.
    @type  Static Function
    @author Everson
    @since 05/08/2022
    @version 01
/*/
Static Function cncPdCom(cContrato, cVersao, cMsgErro)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cPedME    := ""
    Local cPedMF    := ""
    Local cPedSa    := ""
    Local cQuery    := ""
    Local cAliasNxt := ""

    Default cMsgErro := ""

    If ! U_ADCOM425(cContrato, cVersao)
        Help(Nil, Nil, "Função cncPdCom(ADCOM042P)", Nil, "Contrato " + cContrato + " versão " + cVersao + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    DbSelectArea("SC5")
    SC5->(DbSetOrder(1))
    SC5->(DbGoTop())

    cQuery := " SELECT * FROM " + RetSqlName("ZIO") + " (NOLOCK) AS ZIO WHERE ZIO_FILIAL = '" + FWxFilial("ZIO") + "' AND ZIO_NUMERO = '" + cContrato + "' AND ZIO_VERSAO = '" + cVersao + "' AND ZIO.D_E_L_E_T_ = '' ORDER BY ZIO_ITEM "

    cAliasNxt := GetNextAlias()
    DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasNxt, .F., .T.)
    (cAliasNxt)->(DbGoTop())

    Begin Transaction

        While ! (cAliasNxt)->(Eof())

            cPedSa := (cAliasNxt)->ZIO_PEDARM
            cPedME := (cAliasNxt)->ZIO_PEDCOM
            cPedMF := (cAliasNxt)->ZIO_PEDCO2

            If ! Empty(cPedSa) .And. SC5->(DbSeek( FWxFilial("SC5") + cPedSa ))
                
                lRet := U_ADVEN902(@cMsgErro, cPedSa, .F.)

                If ! lRet
                    cMsgErro += xPula
                    DisarmTransaction()
                    Break

                EndIf

            EndIf

            If ! Empty(cPedME)

                lRet := U_ADCOM420(cPedME) //Elimina resíduo dos pedidos de compra em aberto.

                If ! lRet
                    cMsgErro += "Não foi possível eliminar resíduo do pedido " + cPedME + "." + xPula
                    DisarmTransaction()
                    Break

                EndIf

            EndIf

            If lRet .And. ! Empty(cPedMF)

                lRet := U_ADCOM420(cPedMF) //Elimina resíduo dos pedidos de compra em aberto.

                If ! lRet
                    cMsgErro += "Não foi possível eliminar resíduo do pedido " + cPedMF + "." + xPula
                    DisarmTransaction()
                    Break

                EndIf

            EndIf

            (cAliasNxt)->(DbSkip())

        End

        lRet := .T.

    End Transaction
    
    (cAliasNxt)->(DbCloseArea())
    
    RestArea(aArea)
    
Return lRet
/*/{Protheus.doc} User Function ADVN110
    Ponto de entrada.
    @type  Function
    @author Everson
    @since 01/08/2022
    @version 01
/*/
User Function ADCOM42()

    //Variáveis.
    Local aParam    := PARAMIXB 
    Local xRet      := .T. 
    Local oObj      := "" 
    Local cIdPonto  := "" 
    Local cIdModel  := "" 
    Local oModelX   := Nil
    Local oView     := Nil
    Local oGrid     := Nil
    Local cNumero   := ""
    Local cVersao   := ""
    // Local nAux      := 1
    Local cOperacao := ""
    Local nOperation:= 0
    Local cNvNumero := ""

    If aParam <> Nil
    
        oObj     := aParam[1]
        cIdPonto := aParam[2]
        cIdModel := aParam[3]

        If cIdPonto == "MODELCOMMITNTTS"

            oModelx := FWModelActive()

            If Valtype(oModelx) == "O"
            
                nOperation  := oObj:GetOperation()
                cNumero     := oModelx:GetValue("MD_MASTER", "ZIO_NUMERO")
                cVersao     := oModelx:GetValue("MD_MASTER", "ZIO_VERSAO")

                If nOperation == MODEL_OPERATION_INSERT
                    cOperacao := "I"

                ElseIf nOperation == MODEL_OPERATION_UPDATE
                    cOperacao := "A"

                ElseIf nOperation == MODEL_OPERATION_DELETE
                    cOperacao := "D"

                EndIf

                If ! Empty(cOperacao) .And. ! Empty(cNumero) .And. ! Empty(cVersao)
                    grvBarr(cOperacao, cNumero, cVersao)

                EndIf

                If cOperacao == "A" .And. ! Empty(cNumero) .And. ! Empty(cVersao) .And. U_ADCOM425(cNumero, cVersao)
                    U_ADCOM42K("D", ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO, ZIO->ZIO_CODFOR, ZIO->ZIO_LJFORN, ZIO->ZIO_DESC)

                EndIf

            EndIf

        ElseIf cIdPonto == "MODELCOMMITTTS"

            If ! IsInCallStack("U_ADCOM426") .And. ! IsInCallStack("U_ADCOM424") .And. oObj:GetOperation() == MODEL_OPERATION_UPDATE

                oModelX := FwModelActive()

                atlPedido(oModelX)

            EndIf
    
        ElseIf cIdPonto == "BUTTONBAR"
    
            oModelX := FwModelActive()
            oGrid   := oModelX:GetModel("MD_GRID")

            cNumero := oModelX:GetValue("MD_MASTER","ZIO_NUMERO")
        
            // If oModelX:IsCopy()

            //     cNumero := ZIO->ZIO_NUMERO

            //     FWFldPut("ZIO_NUMERO", cNumero)
            //     FWFldPut("ZIO_VERSAO", obtVersao(cNumero))
            //     FWFldPut("ZIO_STATUS", "1")
            //     // FWFldPut("ZIO_DTINI" , CToD(" / /"))
            //     // FWFldPut("ZIO_DTFIM" , CToD(" / /"))

            //     For nAux := 1 To oGrid:Length() 
            //         oGrid:GoLine(nAux) 
            //         oGrid:LoadValue("ZIO_PEDCOM", "")

            //     Next nAux
                
            //     oView := FWViewActive()

            //     If ValType(oView) == "O"
            //         oView:Refresh()
            //         oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIO_DTINI"):OCtrl:SetFocus()

            //     EndIf

            If (oModelX:GetOperation() == MODEL_OPERATION_INSERT ) .And. Empty(cNumero)
                    
                    cNvNumero := GetSXENum("ZIO", "ZIO_NUMERO")
                    FWFldPut("ZIO_NUMERO", cNvNumero)

                    oView := FWViewActive()

                    If ValType(oView) == "O"
                        oView:Refresh()
                        oView:GetViewObj("VW_MASTER")[3]:GetFWEditCTRL("ZIO_DTINI"):OCtrl:SetFocus()

                    EndIf

            EndIf

            xRet := {}
        
        EndIf
    
    EndIf

Return xRet
/*/{Protheus.doc} ADCOM42H
    Carregar dados da grid.
    @type  User Function
    @author Everson
    @since 21/02/2023
    @version 01
/*/
User Function ADCOM42H()

    //Variáveis.
    Local aArea        := GetArea()
    Local cTitulo      := "Cópia"
    Local cPrograma    := "ADCOM042P"
    Local nOperation   := MODEL_OPERATION_INSERT
    Local cNvNumero    := ""
    Local oModel       := Nil
    Local oGrid        := Nil
    Local cContrato    := ZIO->ZIO_NUMERO
    Local cVersao      := ZIO->ZIO_VERSAO
    Local nAux         := 1

    If ! U_ADCOM425(cContrato, cVersao)
        RestArea(aArea)
        Return .F.

    EndIf
    
    oModel := FWLoadModel(cPrograma)
    oModel:SetOperation(nOperation)
    oModel:Activate(.T.)

    cNvNumero := GetSXENum("ZIO", "ZIO_NUMERO")

    oModel:SetValue("MD_MASTER", "ZIO_FILIAL",  ZIO->ZIO_FILIAL)
    oModel:SetValue("MD_MASTER", "ZIO_NUMERO",  cNvNumero)
    oModel:SetValue("MD_MASTER", "ZIO_VERSAO",  "001")
    oModel:SetValue("MD_MASTER", "ZIO_DESC"  ,  ZIO->ZIO_DESC)
    oModel:SetValue("MD_MASTER", "ZIO_TIPO"  ,  ZIO->ZIO_TIPO)
    oModel:SetValue("MD_MASTER", "ZIO_DTINI"  ,  ZIO->ZIO_DTINI)
    oModel:SetValue("MD_MASTER", "ZIO_DTFIM"  ,  ZIO->ZIO_DTFIM)
    oModel:SetValue("MD_MASTER", "ZIO_STATUS" ,  "1")
    oModel:SetValue("MD_MASTER", "ZIO_FILENT" ,  ZIO->ZIO_FILENT)

    oGrid := oModel:GetModel("MD_GRID")

    While ! ZIO->(Eof()) .And. ZIO->ZIO_FILIAL == FWxFilial("ZIO") .And. ZIO->ZIO_NUMERO == cContrato

        If nAux > 1
            oGrid:addLine()

        EndIf

        oGrid:SetValue("ZIO_ITEM", ZIO->ZIO_ITEM)
        oGrid:SetValue("ZIO_CODPRO", ZIO->ZIO_CODPRO)
        oGrid:SetValue("ZIO_DESPRD", ZIO->ZIO_DESPRD)
        oGrid:SetValue("ZIO_UM", ZIO->ZIO_UM)
        oGrid:SetValue("ZIO_VLUNIT", ZIO->ZIO_VLUNIT)
        oGrid:SetValue("ZIO_QUANT", ZIO->ZIO_QUANT)
        oGrid:SetValue("ZIO_VLRTOT", ZIO->ZIO_VLRTOT)
        oGrid:SetValue("ZIO_CODFOR", ZIO->ZIO_CODFOR)
        oGrid:SetValue("ZIO_LJFORN", ZIO->ZIO_LJFORN)
        oGrid:SetValue("ZIO_NMFORN", ZIO->ZIO_NMFORN) 
        oGrid:SetValue("ZIO_CONDPA", ZIO->ZIO_CONDPA) 
        //oGrid:SetValue("ZIO_PEDCOM", ZIO->ZIO_PEDCOM) 
        oGrid:SetValue("ZIO_OBS", ZIO->ZIO_OBS)  
        oGrid:SetValue("ZIO_CC", ZIO->ZIO_CC)  
        oGrid:SetValue("ZIO_TPFRT", ZIO->ZIO_TPFRT)  
        oGrid:SetValue("ZIO_MOEDA", ZIO->ZIO_MOEDA)  
        oGrid:SetValue("ZIO_ALICMS", ZIO->ZIO_ALICMS)  
        oGrid:SetValue("ZIO_ALQIPI", ZIO->ZIO_ALQIPI)  
        oGrid:SetValue("ZIO_FORPAG", ZIO->ZIO_FORPAG)  
        //oGrid:SetValue("ZIO_PEDCO2", ZIO->ZIO_PEDCO2)  
        oGrid:SetValue("ZIO_FORARM", ZIO->ZIO_FORARM)  
        oGrid:SetValue("ZIO_LJFRAR", ZIO->ZIO_LJFRAR)  
        oGrid:SetValue("ZIO_NMARMA", ZIO->ZIO_NMARMA)  

        ZIO->(DbSkip())
        
        nAux++
            
    End

    oGrid:SetLine(1)

    FWExecView( cTitulo , cPrograma, nOperation, /*oDlg*/, {|| .T. } ,/*bOk*/ , /*nPercReducao*/, /*aEnableButtons*/, /*bCancel*/ , /*cOperatId*/, /*cToolBar*/, oModel )
    
    oModel:DeActivate()

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} grvBarr
    Salva o registro para enviar ao barramento.
    @type  Static Function
    @author Everson
    @since 26/07/2022
    @version 01
/*/
Static Function grvBarr(cOperacao, cNumero, cVersao)

    //Variáveis.
    Local aArea     := GetArea()
    Local cFilter   := ""
    Local cCmp      := getCmps()
    Local cTopico   := "contrato_de_compra_de_mp_protheus"

    cFilter := " ZIO_FILIAL ='" + FWxFilial("ZIO") + "' .And. ZIO_NUMERO = '" + cNumero + "' .And. ZIO_VERSAO = '" + cVersao + "' "

    U_ADFAT27D("ZIO", 2, FWxFilial("ZIO") + cNumero + cVersao,;
        "ZIO", 4, FWxFilial("ZIO") + cNumero + cVersao, "ZIO_ITEM", cFilter,;
        cTopico, cOperacao,;
        .T., .T., .T.,;
        cCmp) 

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} Function obtVersao
    Obtém próximo número de versão.
    @type  Static Function
    @author Everson
    @since 01/08/2022
    @version 01
/*/
Static Function obtVersao(cContrato)

    //Variáveis.
    Local aArea   := GetArea()
    Local cVersao := "001"

    If U_ADCOM425(cContrato)

        While ! ZIO->(Eof()) .And. ZIO->ZIO_FILIAL == FWxFilial("ZIO") .And. ZIO->ZIO_NUMERO == cContrato

            If ZIO->ZIO_VERSAO > cVersao
                cVersao := ZIO->ZIO_VERSAO

            EndIf

            ZIO->(DbSkip())
            
        End

        cVersao := Soma1(cVersao)

    EndIf

    RestArea(aArea)

Return cVersao
/*/{Protheus.doc} User Function ADCOM42A
    Posiciona no registro pelo pedido de compra.
    @type  Function
    @author Everson
    @since 09/08/2022
    @version 01
/*/
User Function ADCOM42B(cPedido)

    //Variáveis.

    DbSelectArea("ZIO")
    ZIO->(DbSetOrder(5))

Return ZIO->( DbSeek( FWxFilial("ZIO") + cPedido ) )
/*/{Protheus.doc} User Function ADCOM42G
    Posiciona no registro pelo pedido de saída para armazenagem.
    @type  Function
    @author Everson
    @since 09/08/2022
    @version 01
/*/
User Function ADCOM42G(cPedido)

    //Variáveis.

    DbSelectArea("ZIO")
    ZIO->(DbSetOrder(8))

Return ZIO->( DbSeek( FWxFilial("ZIO") + cPedido ) )
/*/{Protheus.doc} User Function ADCOM420
    Elimina resíduo de pedido de compra.
    @type  Function
    @author Everson
    @since 03/10/2022
    @version 01
/*/
User Function ADCOM420(cPedido)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local cBkpMod   := nModulo

    DbSelectArea("SC7")
    SC7->( DbSetOrder(1) )
    If ! SC7->(DbSeek( FWxFilial("SC7") + cPedido ))
        MsgInfo("Pedido de compra " + cPedido + " não localizado.", "Função ADCOM420(ADCOM042P)")
        Return .F.

    EndIf

    nModulo := 17
    MV_PAR01  := 100
    MV_PAR02  := SC7->C7_EMISSAO
    MV_PAR03  := SC7->C7_EMISSAO
    MV_PAR04  := cPedido
    MV_PAR05  := cPedido
    MV_PAR06  := "               "
    MV_PAR07  := "ZZZZZZZZZZZZZZZ"
    MV_PAR08  := 1
    MV_PAR09  := SC7->C7_FORNECE
    MV_PAR10  := SC7->C7_FORNECE
    MV_PAR11  := SC7->C7_DATPRF
    MV_PAR12  := SC7->C7_DATPRF
    MV_PAR13  := 1
    MV_PAR14  := "    "
    MV_PAR15  := "ZZZZ"
    MV_PAR16  := 1
    MV_PAR17  := 1

    lRet := MATA235(.T.) 

    nModulo := cBkpMod

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADCOM42C
    Função retornar se o cliente está bloqueado pela qualidade.
    @type  Function
    @author Everson
    @since 10/10/2022
    @version 01
/*/
User Function ADCOM42C(cCodigo, cLoja)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.

    Default cCodigo := ""
    Default cLoja   := ""

    DbSelectArea("SA2")
    SA2->( DbSetOrder(1) )
    If ! SA2->( DbSeek( FWxFilial("SA2") + cCodigo + cLoja ) )
        RestArea(aArea)
        Return .F.

    EndIf

    lRet := FieldPos("A2_XBLQUAL") > 0 .And. SA2->A2_XBLQUAL == "B"

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADCOM42D
    (long_description)
    @type  Function
    @author Everson
    @since 28/10/2022
    @version 02
/*/
User Function ADCOM42D(cContrato, cVersao)

    //Variáveis.
    Local aArea := GetArea()

    If ! MsgYesNo("Deseja enviar o contrato " + cValToChar(ZIO->ZIO_NUMERO) + " " +  cValToChar(ZIO->ZIO_VERSAO) + " para o barramento?", "Função ADCOM42D")
        RestArea(aArea)
        Return Nil

    EndIf

    MsAguarde({|| grvBarr("A", ZIO->ZIO_NUMERO, ZIO->ZIO_VERSAO) }, "Aguarde", "Processando...")

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADCOM42E
    Posiciona no registro pelo pedido de compra de remessa.
    @type  Function
    @author Everson
    @since 09/08/2022
    @version 01
/*/
User Function ADCOM42E(cPedido)

    //Variáveis.
    Local lRet := .F.

    DbSelectArea("ZIO")
    ZIO->(DbSetOrder(6))
    lRet := ZIO->( DbSeek( FWxFilial("ZIO") + cPedido ) )

Return lRet
/*/{Protheus.doc} User Function ADCOM42F
	Valida pedido de entrada de matéria-prima.
	Ticket 18465.
	@type  Static Function
	@author Everson
	@since 19/01/2023
	@version 01
/*/
User Function ADCOM42F(cPedido, cProduto, cTes, lLibera)

	//Variáveis.
	Local aArea 	    := GetArea()
	Local cFiliais      := Alltrim(GetMv("MV_#FAT171",,"")) //Ticket 18465   - Everson - 21/07/2022.
    Local lFin          := .F.
    Local lEst          := .F.
    Local lPesRemessa   := .F.

	If !(cFilAnt $cFiliais)
        RestArea(aArea)
        Return .T.

    EndIf

	If Empty(cPedido) .Or. Empty(cProduto) .And. Empty(cTes)
        RestArea(aArea)
        Return .T.

    EndIf

    DbSelectArea("SB1")
    SB1->(DbSetOrder(1))
    SB1->(DbGoTop())
    If ! SB1->(DbSeek( FWxFilial("SB1") + cProduto )) 
		Help(Nil, Nil, "ADCOM42F (ADCOM042P)", Nil, "Produto " + cProduto + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    If SB1->B1_TIPO <> "MP"
        RestArea(aArea)
        Return .T.

    EndIf

    lFin := Posicione("SF4", 1, FWxFilial("SF4") + cTES, "F4_DUPLIC")  == "S"
	lEst := Posicione("SF4", 1, FWxFilial("SF4") + cTES, "F4_ESTOQUE") == "S"

	//Gera financeiro mas é pedido de remessa.
    If U_ADCOM42E(cPedido) .And. ZIO->ZIO_TIPO $"2/3" //Everson 20/01/2023. Ticket 18465.
    
        If lFin 
            Help(Nil, Nil, "ADCOM42F (ADCOM042P)", Nil, "O Tes utilizado gera financeiro, mas está vinculado ao pedido " + cPedido + " de remessa. Contrato de MP " + ZIO->ZIO_NUMERO + " " + ZIO->ZIO_VERSAO, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        EndIf

        //Valida de o pedido de envio para armazenagem existe e está faturado.
        If  ZIO->ZIO_TIPO $"3"

            DbSelectArea("SC5")
            SC5->(DbSetOrder(1))
            SC5->(DbGoTop())
            If ! SC5->( DbSeek( FwxFilial("SC5") + ZIO->ZIO_PEDARM ) )
                Help(Nil, Nil, "ADCOM42F (ADCOM042P)", Nil, "Pedido " + ZIO->ZIO_PEDARM  + " de envio para armazenagem não localizado. Contrato de MP " + ZIO->ZIO_NUMERO + " " + ZIO->ZIO_VERSAO, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                RestArea(aArea)
                Return .F.

            Else

                If Empty(SC5->C5_NOTA)
                    Help(Nil, Nil, "ADCOM42F (ADCOM042P)", Nil, "Pedido " + SC5->C5_NUM  + " de envio para armazenagem não está faturado. Contrato de MP " + ZIO->ZIO_NUMERO + " " + ZIO->ZIO_VERSAO, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
                    RestArea(aArea)
                    Return .F.

                EndIf

            EndIf

        EndIf

        lPesRemessa := .T.
    
    EndIf

	//Gera estoque mas é pedido de que gera financeiro.
	If U_ADCOM42B(cPedido) 
    
        If ZIO->ZIO_TIPO $"2" .And. lEst
            Help(Nil, Nil, "ADCOM42F (ADCOM042P)", Nil, "O Tes utilizado não gera financeiro, mas está vinculado ao pedido " + cPedido + ". Contrato de MP " + ZIO->ZIO_NUMERO + " " + ZIO->ZIO_VERSAO, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        EndIf
    
        If ZIO->ZIO_TIPO $"3" .And. (! lEst .Or. ! lFin) //Para compra com armazenagem em terceiro, a nota de compra movimenta estoque e financeiro.
            Help(Nil, Nil, "ADCOM42F (ADCOM042P)", Nil, "O Tes utilizado precisa gerar financeiro e estoque. Contrato de MP " + ZIO->ZIO_NUMERO + " " + ZIO->ZIO_VERSAO, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        EndIf

	EndIf

    If lPesRemessa .And. lLibera

        DbSelectArea("SC7")
        SC7->(DbSetOrder(1))
        SC7->(DbGoTop())
        If ! SC7->(DbSeek( FWxFilial("SC7") + cPedido ))
            Help(Nil, Nil, "ADCOM42F (ADCOM042P)", Nil, "Pedido " + cPedido + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
            RestArea(aArea)
            Return .F.

        EndIf

        If SC7->C7_CONAPRO <> "L"

            RecLock("SC7", .F.)
                SC7->C7_CONAPRO := "L"
            SC7->(MsUnlock())

            U_grvSC7Barr(cPedido, .T., .F., 4)

        EndIf

    EndIf

	RestArea(aArea)
	
Return .T.
/*/{Protheus.doc} atlPedido
    Altera os pedidos vinculados ao contrato.
    @type  Static Function
    @author Everson
    @since 16/02/2023
    @version 01
/*/
Static Function atlPedido(oModelX)

    //Variáveis.
    Local aArea         := GetArea()
    Local lRet          := .F.
    Local cContrato     := oModelx:GetValue("MD_MASTER", "ZIO_NUMERO")
    Local cVersao       := oModelx:GetValue("MD_MASTER", "ZIO_VERSAO")
    Local cStatus       := oModelx:GetValue("MD_MASTER", "ZIO_STATUS")
    Local oModelGRID    := oModelx:GetModel("MD_GRID")
    Local aLInclui      := oModelGRID:GetLinesChanged(MODEL_GRID_LINECHANGED_INSERTED) //Everson, 17/03/2023, Ticket 18465.
    Local aLAltera      := oModelGRID:GetLinesChanged(MODEL_GRID_LINECHANGED_UPDATED)  //Everson, 17/03/2023, Ticket 18465.
    Local aLExclui      := oModelGRID:GetLinesChanged(MODEL_GRID_LINECHANGED_DELETED)  //Everson, 17/03/2023, Ticket 18465.

    If cStatus == "1"
        RestArea(aArea)
        Return .T.
        
    EndIf

    If ! U_ADCOM425(cContrato, cVersao)
        Help(Nil, Nil, "atlPedido(ADCOM042P)", Nil, "Contrato " + cContrato + " versão " + cVersao + " não localizado.", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        RestArea(aArea)
        Return .F.

    EndIf

    lAtuPed := .T.

    MsAguarde({|| lRet := U_ADCOM429(4, aLAltera, aLInclui, aLExclui) }, "Aguarde", "Atualizando pedidos...") //Everson, 17/03/2023, Ticket 18465.

    lAtuPed := .F.

    RestArea(aArea)
    
Return lRet 
/*/{Protheus.doc} User Function ADCOM42I
    Abertura/Encerramento automático do contrato.
    @type  Function
    @author Everson
    @since 03/03/2023
    @version 01
/*/
User Function ADCOM42I(cContrato, cVersao)

    //Variáveis.
    Local aArea     := GetArea()
    Local cStatus   := ""
    Local lRet      := .T.
    Local lEnc      := .F.
    Local nParAt    := 0
    Local cStatUp   := ""

    Default cContrato := ""
    Default cVersao   := ""

    If Empty(cContrato) .Or. Empty(cVersao)

        U_GrLogZBE(Date(), Time(), cUserName, "NECESSARIO INFORMAR NUMERO DO CONTRATO E VERSAO", "FATURAMENTO","ADCOM42I",;
                   cContrato + " " + cVersao, ComputerName(), LogUserName())

        RestArea(aArea)
        Return .F.

    EndIf

    If ! U_ADCOM425(cContrato, cVersao)

        U_GrLogZBE(Date(), Time(), cUserName, "CONTRATO DE MP NAO LOCALIZADO", "FATURAMENTO","ADCOM42I",;
                   cContrato + " " + cVersao, ComputerName(), LogUserName())

        RestArea(aArea)
        Return .F.

    EndIf

    cStatus := ZIO->ZIO_STATUS

    If cStatus == "8"
        U_GrLogZBE(Date(), Time(), cUserName, "FECHAR CONTRATO JA ENCERRADO MANUALMENTE", "FATURAMENTO","ADCOM42I",;
                   cContrato + " " + cVersao, ComputerName(), LogUserName())

        RestArea(aArea)
        Return .F.

    EndIf

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbGoTop())

    DbSelectArea("SC5")
    SC5->(DbSetOrder(1))
    SC5->(DbGoTop())

    While ! ZIO->(Eof()) .And. ZIO->ZIO_FILIAL == FWxFilial("ZIO") .And. ZIO->ZIO_NUMERO == cContrato .And. ZIO->ZIO_VERSAO == cVersao

        cPedC1 := ZIO->ZIO_PEDCOM
        cPedC2 := ZIO->ZIO_PEDCO2
        cPedV1 := ZIO->ZIO_PEDARM

        If ! Empty(cPedC1) .And. SC7->(DbSeek( FWxFilial("SC7") + cPedC1))
            lEnc := SC7->C7_ENCER == "E"
            nParAt += SC7->C7_QUJE

        Else
            lEnc := .F.

        EndIf

        If lEnc .And. ! Empty(cPedC2) 
            
            If SC7->(DbSeek( FWxFilial("SC7") + cPedC2)) 
                lEnc := SC7->C7_ENCER == "E"
                nParAt += SC7->C7_QUJE

            Else
                lEnc := .F.

            EndIf

        EndIf

        If lEnc .And. ! Empty(cPedV1) 
            lEnc := SC5->(DbSeek( FWxFilial("SC5") + cPedV1)) .And. Empty(SC5->C5_NOTA)

        EndIf

        If ! lEnc
            Exit

        EndIf

        ZIO->(DbSkip())

    End

    If (cStatus == "6" .And. lEnc) //Fechar contrato já encerrado.

        U_GrLogZBE(Date(), Time(), cUserName, "FECHAR CONTRATO JA ENCERRADO", "FATURAMENTO","ADCOM42I",;
                   cContrato + " " + cVersao, ComputerName(), LogUserName())

        RestArea(aArea)
        Return .T.

    EndIf

    cStatUp := Iif(nParAt > 0, "7", "3")

    If (cStatus == cStatUp .And. ! lEnc) //Abrir contrato já aberto.

        U_GrLogZBE(Date(), Time(), cUserName, "ABRIR CONTRATO JA ABERTO", "FATURAMENTO","ADCOM42I",;
                cContrato + " " + cVersao, ComputerName(), LogUserName())

        RestArea(aArea)
        Return .T.

    EndIf

    lRet := U_ADCOM426(cContrato, cVersao, "ZIO_STATUS", Iif(lEnc, "6", cStatUp))

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADCOM42J
    Chamada da rotina de PA.
    @type  Function
    @author Everson
    @since 03/03/2023
    @version 01
/*/
User Function ADCOM42J()

    //Variáveis.
    Local aArea     := GetArea()
    Local cPedido   := ZIO->ZIO_PEDCOM

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbGoTop())
    If ! SC7->(DbSeek( FWxFilial("SC7") + cPedido ))
        MsgInfo("Pedido " + cPedido + " não localizado(SC7).", "Função ADCOM42J(ADCOM042P)")
        RestArea(aArea)
        Return Nil

    EndIf

    U_ADFIN081P()

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADCOM42K
	Envia registro para aprovação.
	@type  Function
	@author Everson
	@since 10/03/2023
	@version 01
/*/
User Function ADCOM42K(nOpc, cContrato, cVersao, cFornece, cLoja, cDescricao)

	//Variáveis.	
	Local aArea		:= GetArea()
	Local cTpBloq   := "000021"
	Local cOrigem   := "ADCOM042P"
    Local nValor    := 0
    Local cPedidos  := ""
    Local cQuery    := ""
    Local cAliasNxt := ""
    Local cUpdt     := " UPDATE " + RetSqlName("ZC7") + " SET D_E_L_E_T_ = '*', R_E_C_D_E_L_ = R_E_C_N_O_ WHERE ZC7_FILIAL = '" + FWxFilial("ZC7") + "' AND ZC7_NUM = '" + cContrato + "' AND ZC7_PREFIX = '" + cVersao + "' AND ZC7_RECPAG = 'C' AND ZC7_TPBLQ = '" + cTpBloq + "' AND D_E_L_E_T_ = '' "

	DbSelectArea("ZC7")
	ZC7->(DbSetOrder(5))
	ZC7->(DbGoTop())

    TcSqlExec(cUpdt)

    If ZC7->(DbSeek( FWxFilial("ZC7") + Padr(Alltrim(cVersao), TamSX3("ZC7_PREFIX")[1]," ") + Padr(Alltrim(cContrato), TamSX3("ZC7_NUM")[1]," ") +  cOrigem))

        While ! ZC7->(Eof());
                .And. ZC7->ZC7_FILIAL = FwxFilial("ZC7");
                .And. ZC7->ZC7_CLIFOR = cFornece;
                .And. ZC7->ZC7_LOJA = cLoja;
                .And. ZC7->ZC7_PREFIX = cVersao;
                .And. ZC7->ZC7_NUM = cContrato;
                .And. ZC7->ZC7_TPBLQ = cTpBloq;
                .And. ZC7->ZC7_ORIGEM = cOrigem

            RecLock("ZC7",.F.)
                ZC7->(DbDelete())
            MSUnlock()

            ZC7->(DbSkip())

        End

    EndIf

	If nOpc == "I" .Or. nOPc == "A"

        cQuery := " SELECT ZIO_VLRTOT, ZIO_PEDCOM FROM " + RetSqlName("ZIO") + " (NOLOCK) ZIO WHERE ZIO_FILIAL = '" + FWxFilial("ZIO") + "' AND ZIO_NUMERO = '" + cContrato + "' AND ZIO_VERSAO = '" + cVersao + "' AND D_E_L_E_T_ = '' "

        cAliasNxt := GetNextAlias()
        DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cAliasNxt, .F., .T.)
        (cAliasNxt)->(DbGoTop())

        If ! (cAliasNxt)->(Eof())

            While ! (cAliasNxt)->(Eof())

                nValor   += Val(cValToChar((cAliasNxt)->ZIO_VLRTOT))

                cPedidos += Alltrim(cValToChar((cAliasNxt)->ZIO_PEDCOM)) + " VlUnt " + Alltrim(cValToChar(Transform(ZIO->ZIO_VLUNIT, PesqPict("ZIO", "ZIO_PEDCOM")))) + " - "

                (cAliasNxt)->(DbSkip())

            End

            cPedidos := Substr(cPedidos, 1 , Len(cPedidos)-3)

        EndIf
        
        (cAliasNxt)->(DbCloseArea())

		RecLock("ZC7",.T.)
			ZC7->ZC7_FILIAL := FwxFilial("ZC7")
			ZC7->ZC7_PREFIX := cVersao
			ZC7->ZC7_NUM    := cContrato
			ZC7->ZC7_CLIFOR := cFornece
			ZC7->ZC7_LOJA   := cLoja
			ZC7->ZC7_TPBLQ  := cTpBloq
			ZC7->ZC7_DSCBLQ := Alltrim(cDescricao) + " - Ped.: " + cPedidos
			ZC7->ZC7_RECPAG := "C"	
			ZC7->ZC7_VLRBLQ := nValor
			ZC7->ZC7_DATA   := Date()
			ZC7->ZC7_USRALT := __cUserID
			ZC7->ZC7_ORIGEM	:= cOrigem
		MSUnlock()

	EndIf

	RestArea(aArea)

Return .T.
