#Include "Totvs.ch"
#Include "FWMVCDef.ch"
#Include "Topconn.ch"
#Include "Apwebsrv.ch"

Static cTbMast      := "ZIH"
Static cTitulo      := "Pesagem Guardian"
Static cTiMast      := "Dados da pesagem Guardian"
Static xPula        := Chr(13) + Chr(10)
Static cTxtSaida    := "DIRIJA-SE A SAIDA"
Static cTxtFabri    := "DIRIJA-SE A FABRICA"
Static cTxtSeq1     := "PESO DIVERGENTE COM A ORDEM"
Static cTxtSeq2     := "LACRES NAO INFORMADOS"
Static cTxtSeq3     := "APONTAMENTO DE SACARIA NAO REALIZADO"
Static cPtControle  := "PONTO_PESAGEM"

Static cProdGuard   := "WS G"
Static cCodGuard    := "01"

/*/{Protheus.doc} User Function ADFAT024P
    Pesagens Guardian.
    Cad Pesagens Guardian
    Chamado 18465.
    @type  Function
    @author Everson
    @since 02/12/2021
    @version 01
    @history Everson, 31/05/2022, ticket 18465. Tratamento para carga sequestrada.
    @history Everson, 30/09/2022, ticket 18465. Adicionada geração de pedido de saída para ração.
    @history Everson, 06/02/2023, ticket 18465 - Rotina para processar regitros do barramento de comunicação do job com a balança.
/*/
User Function ADFAT024P() // U_ADFAT024P()

    //Variáveis.
    Local oBrowse := FwLoadBrw("ADFAT024P")

    oBrowse:Activate()

Return Nil
/*/{Protheus.doc} BrowseDef
    @type  Static Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
Static Function BrowseDef()

    //Variáveis.
    Local oBrowse := FwMBrowse():New()

    oBrowse:SetAlias(cTbMast)
    oBrowse:SetDescription(cTitulo)

    oBrowse:SetMenuDef("ADFAT024P")

Return oBrowse
/*/{Protheus.doc} MenuDef
    @type  Static Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
Static Function MenuDef()

    //Variáveis.
    Local aRotina := {}

	ADD OPTION aRotina TITLE "Pesquisar" 		ACTION "PesqBrw"          	OPERATION 1   ACCESS 0
	ADD OPTION aRotina TITLE "Visualizar" 		ACTION "VIEWDEF.ADFAT024P" 	OPERATION MODEL_OPERATION_VIEW   ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"    		ACTION "VIEWDEF.ADFAT024P" 	OPERATION MODEL_OPERATION_INSERT ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"    		ACTION "VIEWDEF.ADFAT024P" 	OPERATION MODEL_OPERATION_UPDATE ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"    		ACTION "VIEWDEF.ADFAT024P" 	OPERATION MODEL_OPERATION_DELETE ACCESS 0
	ADD OPTION aRotina TITLE "Importar Dados"   ACTION "U_ADFAT24E()"       OPERATION 10  ACCESS 0

Return aRotina
/*/{Protheus.doc} ModelDef
    @type  Static Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
Static Function ModelDef()
    
    //Variáveis.
    Local bPre      := {|| .T. }
    Local bPost     := {|| .T. }
    Local bCancel   := {|| .T. }
    Local oModel    := MPFormModel():New("ADFAT24", bPre, bPost, /*bCommit*/, bCancel)
    Local oStrMast  := FwFormStruct(1, cTbMast)                                                
     
    //AddFields(<cId >, <cOwner >, <oModelStruct >, <bPre >, <bPost >, <bLoad >)
    oModel:AddFields("MD_MASTER", Nil, oStrMast)

    oModel:SetPrimaryKey({})

    oModel:SetDescription(cTitulo)

    oModel:GetModel("MD_MASTER"):SetDescription(cTiMast)

Return oModel
/*/{Protheus.doc} ViewDef
    @type  Static Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
Static Function ViewDef()
    
    //Variáveis.
    Local oView     := FwFormView():New()
    Local oModel    := FwLoadModel("ADFAT024P")
    Local oStrMast  := FwFormStruct(2, cTbMast)

    oView:SetModel(oModel)

    oView:AddField("VW_MASTER", oStrMast, "MD_MASTER")

Return oView
/*/{Protheus.doc} ADFAT241
    Cadastro de ticket de pesagem no Guardian. 
    @type  User Function
    @author Everson
    @since 01/12/2021
    @version 01
/*/
User Function ADFAT241(cUrl,oRetSolic,cErro,cPlcCarret,cPlcVeic,cTag,cFluxo,cTickProth,nPesIni, cOpPesIni, cPerifIni)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oGuardian := WSWS_GUARDIAN():New()
    Local cTimStamp := FWTimeStamp(5)

    oGuardian:_URL := cUrl
    oGuardian:OWSDADOSTICKET:cCodigo := cTickProth
    oGuardian:OWSDADOSTICKET:cPlacaCarreta  := cPlcCarret
    oGuardian:OWSDADOSTICKET:cPlacaVeiculo  := cPlcVeic
    oGuardian:OWSDADOSTICKET:cTagAssociado  := cTag
    oGuardian:OWSDADOSTICKET:lAceitaPesoLiquidoZero  := .F.
    oGuardian:OWSDADOSTICKET:nPesoAlvo  := Nil
    oGuardian:OWSDADOSTICKET:nPesoBrutoOrigem  := 0
    oGuardian:OWSDADOSTICKET:nPesoMinimoOrigem  := 0
    oGuardian:OWSDADOSTICKET:nPesoMaximoOrigem  := 0
    oGuardian:OWSDADOSTICKET:nPesoTotalOrigem  := 0
    oGuardian:OWSDADOSTICKET:cFluxo := cFluxo
    oGuardian:OWSDADOSTICKET:nTipoDoFatorDeCorrecao := 0
    oGuardian:OWSDADOSTICKET:cReferenciaIntegracao := cTickProth
    oGuardian:OWSDADOSTICKET:nNumeroTotalCompatimentos := 0
    oGuardian:OWSDADOSTICKET:nTipoIdentificacaoCompartimento := 0
    oGuardian:OWSDADOSTICKET:lMarcardoParaCancelar := .F.
    oGuardian:OWSDADOSTICKET:lOCRMarcardoParaNaoValida := .F.
    oGuardian:OWSDADOSTICKET:nNumeroConteineres := 0

    If nPesIni > 0
        oGuardian:OWSDADOSTICKET:nPesoDaPesagemInicial := nPesIni
        oGuardian:OWSDADOSTICKET:cDataDaPesagemInicial := cTimStamp
        oGuardian:OWSDADOSTICKET:cOperacaoDaPesagemInicial := cOpPesIni
        oGuardian:OWSDADOSTICKET:cPerifericoDaPesagemInicial := cPerifIni

    EndIf
    
    If oGuardian:CadastraTicketGuardian()
        
        If oGuardian:nErro = 303221
            lRet := .T.
            oRetSolic := oGuardian:oWSCadastraTicketGuardianResult

        Else
            cErro := cValToChar(oGuardian:nErro) + " " + Alltrim(cValToChar(oGuardian:cErroMSG))

        EndIf

    Else
        cErro := "GetWSCError " + GetWSCError()
        
    EndIf 

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT242
    Altera a tag. 
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT242(cUrl,oRetSolic,cErro,cPlcCarret,cPlcVeic,cTag,cFluxo,cTickProth)
    
    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oGuardian := WSWS_GUARDIAN():New()

    oGuardian:_URL := cUrl
    oGuardian:OWSDADOSTICKET:cCodigo := cTickProth
    oGuardian:OWSDADOSTICKET:cPlacaCarreta  := cPlcCarret
    oGuardian:OWSDADOSTICKET:cPlacaVeiculo  := cPlcVeic
    oGuardian:OWSDADOSTICKET:cTagAssociado  := cTag
    oGuardian:OWSDADOSTICKET:nPesoTotalOrigem := 0

    oGuardian:oWSCFGALTERACAO:lIgnoraTransportadora := .T.
    oGuardian:oWSCFGALTERACAO:lIgnoraEmissor := .T.
    oGuardian:oWSCFGALTERACAO:lIgnoraItens := .T.
    oGuardian:oWSCFGALTERACAO:lIgnoraMotorista := .T.
    oGuardian:oWSCFGALTERACAO:lIgnoraDocumentos := .T.
    oGuardian:oWSCFGALTERACAO:lIgnoraCamposAdicionais := .T.
    oGuardian:oWSCFGALTERACAO:lIgnoraFatorCorrecao := .T.
    oGuardian:oWSCFGALTERACAO:lIgnoraConteineres := .T.
    oGuardian:oWSCFGALTERACAO:lIgnoraFluxo := .T.
    
    If oGuardian:AlteraTicketGuardian()
    
        If oGuardian:nErro = 303221
            lRet := .T.
            oRetSolic := oGuardian:oWSAlteraTicketGuardianResult

        Else
            cErro := cValToChar(oGuardian:nErro) + " " + Alltrim(cValToChar(oGuardian:cErroMSG))

        EndIf

    Else
        cErro := "GetWSCError " + GetWSCError()
        
    EndIf 

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT243
    Exporta dados do ticket de pesagem. 
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT243(cUrl,oRetSolic,cErro)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oGuardian := WSWS_GUARDIAN():New()

    oGuardian:_URL := cUrl
    
    If oGuardian:ExportaTicketsMarcados()
        
        If oGuardian:nErro = 0
            lRet := .T.
            oRetSolic := oGuardian:oWSExportaTicketsMarcadosResult

        Else
            cErro := cValToChar(oGuardian:nErro) + " " + Alltrim(cValToChar(oGuardian:cErroMSG))

        EndIf

    Else
        cErro := "GetWSCError " + GetWSCError()
        
    EndIf 

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT244
    Confirma leitura dos tickets exportados. 
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT244(cUrl, cMsgError)

    //Variáveis.
    Local aArea       := GetArea()
    Local lRet        := .F.
    Local oRetSolic   := Nil
    Local oGuardian   := WSWS_GUARDIAN():New()
    Local cEmilErr    := GetMv("MV_#FAT291",,"everson.silva@adoro.com.br;wagner.moro@adoro.com.br")

    Default cMsgError   := ""
    
    If Empty(cUrl)
        cMsgError := "Url não informada."
        Help(Nil, Nil, "Função ADFAT244(ADFAT024P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        Return .F.

    EndIf

    oGuardian:_URL := cUrl
    
    If oGuardian:ConfirmaLeituraTicketsMarcados()
        
        If oGuardian:nErro = 0
            lRet := .T.
            oRetSolic := oGuardian:oWSConfirmaLeituraTicketsMarcadosResult

        Else
            cMsgError := cValToChar(oGuardian:nErro) + " " + Alltrim(cValToChar(oGuardian:cErroMSG))

        EndIf

    Else
        cMsgError := "GetWSCError " + GetWSCError()
        
    EndIf 

    If ! lRet
        U_EnviaEmail(GetMv("MV_RELFROM"), cEmilErr, cMsgError, "Erro Comunicação Balança - Confirmar dados - ADFAT244","")

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT245
    Remonta fluxo. 
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT245(cUrl, lRetSolic, cErro, cCodTicket, cFluxo)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oGuardian := WSWS_GUARDIAN():New()

    oGuardian:_URL := cUrl
    oGuardian:cticketCodigo := cCodTicket
    oGuardian:cfluxoCodigo  := cFluxo
    oGuardian:cproduto := cProdGuard
    oGuardian:ccodigo := cCodGuard
    
    If oGuardian:RemontaFluxo()
        nRetSolic := oGuardian:lRemontaFluxoResult
        lRet := .T.

    Else
        cErro := "GetWSCError " + GetWSCError()
        
    EndIf 

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT246
    Cancela última operação.
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT246(cUrl,cErro,cCodTicket)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oGuardian := WSWS_GUARDIAN():New()

    oGuardian:_URL := cUrl
    oGuardian:cticketCodigo := cCodTicket
    oGuardian:cproduto := cProdGuard
    oGuardian:ccodigo := cCodGuard
    
    If oGuardian:CancelaUltimaOperacaoAtiva()

        If oGuardian:nSaiErro = 0
            lRet := oGuardian:lCancelaUltimaOperacaoAtivaResult

        Else 
            cErro := Alltrim(cValToChar(oGuardian:nSaiErro)) + " " + Alltrim(cValToChar(oGuardian:cSaiErroMSG))

        EndIf 

    Else
        cErro := "GetWSCError " + GetWSCError()
        
    EndIf 

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT247
    Refaz última operação. 
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT247(cUrl,cErro,cCodTicket)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oGuardian := WSWS_GUARDIAN():New()

    oGuardian:_URL := cUrl
    oGuardian:cticketCodigo := cCodTicket
    oGuardian:cproduto := cProdGuard
    oGuardian:ccodigo := cCodGuard
    
    If oGuardian:RefazUltimaOperacaoAtiva()

        If oGuardian:nSaiErro = 0
            lRet := oGuardian:lRefazUltimaOperacaoAtivaResult

        Else 
            cErro := Alltrim(cValToChar(oGuardian:nSaiErro)) + " " + Alltrim(cValToChar(oGuardian:cSaiErroMSG))

        EndIf 

    Else
        cErro := "GetWSCError " + GetWSCError()
        
    EndIf 

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT248
    Envia mensagem para o display.
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT248(cUrl,nRetSolic,cErro,cPontoCont,nPosicao,cMensagem,nTempo)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oGuardian := WSWS_GUARDIAN():New()

    oGuardian:_URL := cUrl
    oGuardian:cPontoControle := cPontoCont
    oGuardian:nPosicao := nPosicao
    oGuardian:cMensagem := cMensagem
    oGuardian:nTempo := nTempo

    If oGuardian:EnviaMensagemDisplay()

        If oGuardian:nErro = 0
            lRet := .T.
            nRetSolic := oGuardian:nEnviaMensagemDisplayResult

        Else
            cErro := cValToChar(oGuardian:nErro) + " " + Alltrim(cValToChar(oGuardian:cErroMSG))

        EndIf

    Else
        cErro := "GetWSCError " + GetWSCError()

    EndIf 

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT249
    Manutenção de ticket. 
    1 = Bloquear, 2 = Desbloquear, 3 = Encerrar, 4 = Cancelar  
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT249(cUrl,cErro,cCodTicket,nNumOp)
    
    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oGuardian := WSWS_GUARDIAN():New()

    oGuardian:_URL := cUrl
    oGuardian:cticketCodigo := cCodTicket
    oGuardian:nnumOperacao  := nNumOp
    oGuardian:cproduto := cProdGuard
    oGuardian:ccodigo := cCodGuard
    
    If oGuardian:ManutencaoTicket()
        lRet := oGuardian:lManutencaoTicketResult

    Else
        cErro := "GetWSCError " + GetWSCError()
        
    EndIf 

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT24A
    Solicita foto avulsa. 
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT24A(cUrl,nNumRet,cErro,cCodPonCont,cPosCam,cCaminho,cNmFoto)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oGuardian := WSWS_GUARDIAN():New()

    oGuardian:_URL := cUrl
    oGuardian:ccodigoPontoControle := cCodPonCont
    oGuardian:cposicaoCamera := cPosCam
    oGuardian:ccaminhoFoto := cCaminho
    oGuardian:cnomeFoto := cNmFoto
    oGuardian:cproduto := cProdGuard
    oGuardian:ccodigo := cCodGuard

    If oGuardian:SolicitaFotoAvulsa()

        If oGuardian:nErro = 0
            lRet := .T.
            nNumRet := Val(cValToChar(oGuardian:nSolicitaFotoAvulsaResult))

        Else
            cErro := cValToChar(oGuardian:nErro) + " " + Alltrim(cValToChar(oGuardian:cErroMSG))

        EndIf

    Else
        cErro := "GetWSCError " + GetWSCError()

    EndIf 

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT24B
    Solicita retorno da foto avulsa. 
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT24B(cUrl,oRetSolic,nIdSolic,cProduto,cCodigo)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local oGuardian := WSWS_GUARDIAN():New()

    oGuardian:_URL := cUrl
    oGuardian:nidSolicitacaoAvulsa := nIdSolic
    oGuardian:cproduto := cProdGuard
    oGuardian:ccodigo := cCodGuard

    If oGuardian:SolicitaRetornoFotoAvulsa()
        lRet := .T.
        oRetSolic := oGuardian:oWSSolicitaRetornoFotoAvulsaResult

    Else
        cErro := "GetWSCError " + GetWSCError()

    EndIf 

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT24C
    Obtém registros de pesagem.
    @type  User Function
    @author Everson
    @since 02/12/2021
    @version 01
/*/
User Function ADFAT24C()

    //Variáveis.
    Local oRetSolic := Nil
    Local cMsgError := ""
    Local aRet      := {}
    Local cBalanca  := Alltrim(cValToChar(GetMv("MV_#URLBAL",,"000002")))
    Local cUrl      := Alltrim(cValToChar(Posicione("DX5", 1, FWxFilial("DX5") + cBalanca, "DX5_URL")))
    Local cEmilErr  := GetMv("MV_#FAT291",,"everson.silva@adoro.com.br;wagner.moro@adoro.com.br")
    Local nCount    := 0
    Local nQtdReg   := GetMv("MV_#FAT241",, 10)

    If Empty(cUrl)
        cMsgError := "Balança " + cBalanca + " não possui URL vinculado."
        U_EnviaEmail(GetMv("MV_RELFROM"), cEmilErr, cMsgError, "Erro Comunicação Balança - Obter dados - ADFAT24C","")
        Help(Nil, Nil, "Função ADFAT24C(ADFAT024P)", Nil, cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
        Return .F.

    EndIf

    Begin Transaction

        While nCount <= nQtdReg

            If U_ADFAT243(cUrl, @oRetSolic, @cMsgError)
            
                cMsgError := ""
                aRet := oRetSolic:OWSTICKET

                If Len(aRet) <= 0
                    Exit 

                EndIf

                If ! U_ADFAT24F(aRet, @cMsgError)
                    DisarmTransaction() 
                    Break

                Else

                    If ! U_ADFAT244(cUrl, @cMsgError)
                        DisarmTransaction() 
                        Break

                    EndIf

                EndIf

            Else
                DisarmTransaction() 
                Break

            EndIf

            FreeObj(oRetSolic)
            oRetSolic := NIL
            nCount++

        End

    End Transaction

    If ValType(oRetSolic)
        FreeObj(oRetSolic)

    EndIf

    oRetSolic := Nil
    
    If ! Empty(cMsgError)
        U_EnviaEmail(GetMv("MV_RELFROM"), cEmilErr, cMsgError, "Erro Comunicação Balança - Obter dados - ADFAT24C","")
        Help(Nil, Nil, "Função ADFAT24C(ADFAT024P)", Nil, "Erro na consulta à balança (ADFAT243)." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

    EndIf

Return .T.
/*/{Protheus.doc} ADFAT24F
    Salva registros de pesagem vindo do webservice soap.
    @type  User Function
    @author Everson
    @since 03/12/2021
    @version 01
/*/
User Function ADFAT24F(aRet, cMsgError)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local nAux      := 1
    Local oReg      := Nil
    Local nAux2     := 1
    Local oModel    := Nil
    Local lInsert   := .T.
    Local cTickProth:= ""
    Local cTktGuad  := ""
    Local cPlaca    := ""
    Local nPeso     := 0
    Local nPesoLiq  := 0
    Local cFluxo    := ""
    Local cCodSitu  := ""
    Local cTag      := ""
    Local dDTPesa   := Nil
    Local cHrPesa   := ""
    Local cCodigo   := ""
    
    Default cMsgError := ""

    For nAux := 1 To Len(aRet)

        cTickProth  := Alltrim(cValToChar(aRet[nAux]:CREFERENCIAINTEGRACAO))
        cTktGuad    := Alltrim(cValToChar(aRet[nAux]:CCODIGO))
        cTag        := Alltrim(cValToChar(aRet[nAux]:CTAGASSOCIADO))
        cFluxo      := Alltrim(cValToChar(aRet[nAux]:CCODIGOFLUXOTICKET))
        dDTPesa     := SToD(StrTran(Substr(Alltrim(cValToChar(aRet[nAux]:CDATAPESAGEM)),1,10),"-",""))
        cHrPesa     := Substr(Alltrim(cValToChar(aRet[nAux]:CDATAPESAGEM)),12,8)
        
        oReg := aRet[nAux]:OWSOPERACAOTICKET:OWSOPERACAOTICKET
        
        For nAux2 := 1 To Len(oReg)

            cCodigo     := Alltrim(cValToChar(oReg[nAux2]:CCODIGO))
            cTpOp       := Alltrim(cValToChar(oReg[nAux2]:NTIPOOPERACAOCODIGO))
            cPlaca      := StrTran(Alltrim(cValToChar(oReg[nAux2]:CPLACAVEICULO)),"-","")
            cCodSitu    := Alltrim(cValToChar(oReg[nAux2]:NESTADO))
            nPeso       := Val(cValToChar(oReg[nAux2]:NPESO))
            nPesoLiq    := Val(cValToChar(oReg[nAux2]:NPESOLIQOBTIDO))
            
            oModel := FwLoadModel("ADFAT024P")

            lInsert := .T.
            DbSelectArea("ZIH")
            ZIH->(DbSetOrder(4))
            If ZIH->(DbSeek( FWxFilial("ZIH") + cTktGuad + cCodigo ))
                oModel:SetOperation(MODEL_OPERATION_UPDATE)
                lInsert := .F.

            Else
                oModel:SetOperation(MODEL_OPERATION_INSERT)

            EndIf

            oModel:Activate() 

            If lInsert
                oModel:SetValue("MD_MASTER", "ZIH_TKTPRO", cTickProth)
                oModel:SetValue("MD_MASTER", "ZIH_TKTGUA", cTktGuad)
                oModel:SetValue("MD_MASTER", "ZIH_CODIGO", cCodigo)

            EndIf

            oModel:SetValue("MD_MASTER", "ZIH_PLACA" , cPlaca)
            oModel:SetValue("MD_MASTER", "ZIH_SITUAC", cCodSitu)
            oModel:SetValue("MD_MASTER", "ZIH_CODOPE", cTpOp)
            oModel:SetValue("MD_MASTER", "ZIH_DTOPER", dDTPesa)
            oModel:SetValue("MD_MASTER", "ZIH_HROPER", cHrPesa)
            oModel:SetValue("MD_MASTER", "ZIH_PESO"  , nPeso)
            oModel:SetValue("MD_MASTER", "ZIH_PESOLI", nPesoLiq)
            oModel:SetValue("MD_MASTER", "ZIH_FLUXO" , cFluxo)
            oModel:SetValue("MD_MASTER", "ZIH_TAG"   , cTag)

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
                Help(Nil, Nil, "Função ADFAT24F(ADFAT024P)", Nil, "Erro: " + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

            EndIf

        Next nAux2

    Next nAux

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT24G
    Salva registros de pesagem vindos do barramento json.
    @type  User Function
    @author Everson
    @since 23/03/2022
    @version 01
/*/
User Function ADFAT24G(aRet, cMsgError)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRet      := .F.
    Local nAux      := 1
    Local oModel    := Nil
    Local lInsert   := .T.
    Local cTickProth:= ""
    Local cTktGuad  := ""
    Local cPlaca    := ""
    Local nPeso     := 0
    Local nPesoLiq  := 0
    Local cFluxo    := ""
    Local cCodSitu  := ""
    Local cTag      := ""
    Local dDTPesa   := Nil
    Local cHrPesa   := ""
    Local cCodigo   := ""
    
    Default cMsgError := ""

    For nAux := 1 To Len(aRet)

        cTickProth  := aRet[nAux][1]
        cTktGuad    := aRet[nAux][2]
        cTag        := aRet[nAux][3]
        cFluxo      := aRet[nAux][4]
        dDTPesa     := SToD(aRet[nAux][5])
        cHrPesa     := aRet[nAux][6]
        
        cCodigo     := aRet[nAux][7]
        cTpOp       := aRet[nAux][8]
        cPlaca      := aRet[nAux][9]
        cCodSitu    := aRet[nAux][10]
        nPeso       := aRet[nAux][11]
        nPesoLiq    := aRet[nAux][12]
        
        oModel := FwLoadModel("ADFAT024P")

        lInsert := .T.
        DbSelectArea("ZIH")
        ZIH->(DbSetOrder(4))
        If ZIH->(DbSeek( FWxFilial("ZIH") + cTktGuad + cCodigo ))
            oModel:SetOperation(MODEL_OPERATION_UPDATE)
            lInsert := .F.

        Else
            oModel:SetOperation(MODEL_OPERATION_INSERT)

        EndIf

        oModel:Activate() 

        If lInsert
            oModel:SetValue("MD_MASTER", "ZIH_TKTPRO", cTickProth)
            oModel:SetValue("MD_MASTER", "ZIH_TKTGUA", cTktGuad)
            oModel:SetValue("MD_MASTER", "ZIH_CODIGO", cCodigo)

        EndIf

        oModel:SetValue("MD_MASTER", "ZIH_PLACA" , cPlaca)
        oModel:SetValue("MD_MASTER", "ZIH_SITUAC", cCodSitu)
        oModel:SetValue("MD_MASTER", "ZIH_CODOPE", cTpOp)
        oModel:SetValue("MD_MASTER", "ZIH_DTOPER", dDTPesa)
        oModel:SetValue("MD_MASTER", "ZIH_HROPER", cHrPesa)
        oModel:SetValue("MD_MASTER", "ZIH_PESO"  , nPeso)
        oModel:SetValue("MD_MASTER", "ZIH_PESOLI", nPesoLiq)
        oModel:SetValue("MD_MASTER", "ZIH_FLUXO" , cFluxo)
        oModel:SetValue("MD_MASTER", "ZIH_TAG"   , cTag)

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
            Help(Nil, Nil, "Função ADFAT24F(ADFAT024P)", Nil, "Erro: " + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

    Next nAux

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT24D
    Processa registros de pesagem.
    @type  User Function
    @author Everson
    @since 06/12/2021
    @version 01
/*/
User Function ADFAT24D()

    //Variáveis.
    Local aArea         := GetArea()
    Local cQuery        := ""
    Local nTpPesa       := ""
    Local cMsgError     := ""
    Local lRetSlvP      := .F.
    Local aRecAtu       := {}
    Local lBarramento   := GetMv("MV_#ADF251",,.T.)
    Local nPesoLiq      := 0

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " ZIH_TKTPRO, ZIH_CODOPE, ZIH_PESO, ZIH_PESOLI, " 
        cQuery += " ZIH_DTOPER, ZIH_HROPER, ZIH.R_E_C_N_O_ AS REC, ZIG_PLACA, ZIG_NUMERO, ZIG_ORDEM, ZIG_CTPATI, ZIG_INICIA " 
    cQuery += " FROM  " 
        cQuery += " " + RetSqlName("ZIH") + " (NOLOCK) AS ZIH " 
        cQuery += " INNER JOIN "
        cQuery += " " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG ON "
        cQuery += " ZIH_FILIAL = ZIG_FILIAL "
        cQuery += " AND ZIH_TKTPRO = ZIG_NUMERO "
    cQuery += " WHERE  " 
        cQuery += " ZIH_FILIAL = '" + FWxFilial("ZIH") + "'  " 
        cQuery += " AND ZIH_PROCES = '2' " 
        cQuery += " AND ZIH.D_E_L_E_T_ = '' " 
        cQuery += " AND ZIG.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY  " 
        cQuery += " ZIH_DTOPER, ZIH_HROPER, REC " 

    TcQuery cQuery New Alias "D_TKT"
    DbSelectArea("D_TKT")
    While ! D_TKT->(Eof())

        cMsgError   := ""
        nTpPesa     := Iif( Alltrim(cValToChar(D_TKT->ZIH_CODOPE)) == "2", 1, 2)

        If Alltrim(cValToChar(D_TKT->ZIH_CODOPE)) == "8"
            nPesoLiq := D_TKT->ZIH_PESO
        
        Else
            nPesoLiq := D_TKT->ZIH_PESOLI

        EndIf

        If D_TKT->ZIG_INICIA == "3" //Everson - 31/05/2022. Chamado 18465.
            cMsgError := "ADFAT24D(ADFAT024P)-TICKET " + D_TKT->ZIH_TKTPRO + " JÁ ENCERRADO. PESAGEM NÃO PODE SER PROCESSADA."
            lRetSlvP := .T.

        ElseIf Alltrim(cValToChar(D_TKT->ZIH_CODOPE)) $"2/3/8"
        
            //Grava pesagem.
            lRetSlvP := U_ADFAT24H(lBarramento, D_TKT->ZIG_CTPATI, D_TKT->ZIH_TKTPRO, nTpPesa, D_TKT->ZIH_PESO, nPesoLiq, @cMsgError) 

        Else
            lRetSlvP := .T.

        EndIf
            
        Aadd(aRecAtu, {D_TKT->REC, lRetSlvP, cMsgError})

        D_TKT->(DbSkip())

    End
    D_TKT->(DbCloseArea())

    If Len(aRecAtu) > 0
        atuPeGua(aRecAtu)

    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT24H
    Atualiza ticket de pesagem.
    @type  User Function
    @author Everson
    @since 29/03/2022
    @version 01
/*/
User Function ADFAT24H(lBarramento, cCp, cTicket, nTpPesa, nPeso, nPesoLiq, cMsgError)

    //Variáveis.
    Local aArea         := GetArea()
    Local lRet          := .F.
    Local nTpSeq        := 0
    Local cAcaSeq       := ""
    Local lSequestra    := .F.
    Local cBalanca      := ""
    Local cUrl          := ""
    Local cFlxFinal     := Alltrim(cValToChar(GetMv("MV_#ADF241",,"F3")))
    Local cFlxRmt       := ""
    Local cTktGuar      := ""
    Local cMsgDisplay   := ""

    Default cMsgError := ""

    //Posiciona no controle de pátio.
    If ! U_ADFAT17U(cCP)
        cMsgError := "Controle de pátio " + cCP + " não localizado."
        RestArea(aArea)
        Return .F.

    EndIf

    //Posiciona no fluxo de pesagem.
    If ! U_ADFAT195(cTicket)
        cMsgError := "Ticket de pesagem " + cTicket + " não localizado."
        RestArea(aArea)
        Return .F.

    EndIf

    //Obtém ticket do Guardina, código da balança e url do web service da balança.
    cTktGuar    := ZIG->ZIG_NUMGUA
    cBalanca    := ZIG->ZIG_BALANC
    cUrl        := Alltrim(cValToChar(Posicione("DX5" , 1, FwxFilial("DX5") + cBalanca, "DX5_URL")))
    cFlxRmt     := Alltrim(cValToChar( Posicione("ZI9", 1, FwxFilial("ZI9") + ZIB->ZIB_CODROT, "ZI9_FXGURE") ))

    //Registra pesagem.
    lRet := U_ADFAT171(cBalanca, cTicket, nPeso, nPesoLiq, nTpPesa, "1", "2", "", {}, @nTpSeq, @cAcaSeq, @lSequestra, @cMsgError)

    //Abre pesagem inicial do ticket seguinte.
    lRet := lRet .And. U_ADFAT17I(nTpPesa, cBalanca, cCP, cTicket, nPeso, "1", "2", "", {}, nTpSeq, cAcaSeq, lSequestra,  @cMsgError)

    If lRet .And. nTpPesa == 2 //Pesagem final.

        If ! lSequestra //Pesagem processada sem erro e não sequestrada.

            //Verifica se há mais tickets de pesagem a serem enviados.
            lRet := U_ADFAT24I(ZIG->ZIG_CTPATI, ZIG->ZIG_NUMERO, nPeso, @cMsgError)

            //Everson, 30/09/2022. Ticket 18465.
            //Gera pedido de saída.
            If ZIG->ZIG_TPMOV == "R"
                U_ADFAT24K(@cMsgError, "GERA PV RACAO", "", Nil, Nil, Nil, Nil, {ZIG->ZIG_ORDEM, cTicket})

            EndIf
            //

        ElseIf lSequestra .And. cAcaSeq == "R" //Pesagem processada sem erro, sequestrada com remonte.

            lRet := U_ADFAT24J(cUrl, cTicket, cTktGuar, nTpSeq, cFlxRmt, @cMsgError)
        
        ElseIf lSequestra .And. cAcaSeq == "S" //Pesagem processada sem erro, sequestrada com liberação.

            cMsgDisplay := getMsgSeq(nTpSeq)

            lRet := U_ADFAT24K(@cMsgError, "MENSAGEM DISPLAY", cUrl, {cPtControle, 0, cMsgDisplay, 5, cTicket})

            lRet := U_ADFAT24K(@cMsgError, "MENSAGEM DISPLAY", cUrl, {cPtControle, 0, cTxtSaida, 0, cTicket})

            lRet := U_ADFAT24K(@cMsgError, "REMONTA FLUXO", cUrl, Nil, {cTktGuar, cFlxFinal, cTicket})

        EndIf

    EndIf

    If ! lRet
        cMsgError += "ADFAT24H(ADFAT024P)-" + cMsgError

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADFAT24J
    Processa pesagem sequestrada com remonte de fluxo.
    @type  User Function
    @author Everson
    @since 30/03/2022
    @version 01
/*/
User Function ADFAT24J(cUrl, cTicket, cTktGuar, nTpSeq, cFlxRmt, cMsgError)

    //Variáveis.
    Local aArea         := GetArea()
    Local lRet          := .F.
    Local cMsgErr1      := ""
    Local nAux          := 1
    Local nQtdLoop      := 2
    Local cMsgDisplay   := ""

    Default cMsgError := ""

    //Cancela última operação ativa.
    U_ADFAT246(cUrl, @cMsgErr1, cTktGuar)

    lRet := U_ADFAT24K(@cMsgError, "REMONTA FLUXO", cUrl, Nil, {cTktGuar, cFlxRmt, cTicket})

    cMsgError += cMsgErr1 + " " + cMsgError

    If lRet
        
        cMsgDisplay := getMsgSeq(nTpSeq)
    
        For nAux := 1 To nQtdLoop

            lRet := U_ADFAT24K(@cMsgError, "MENSAGEM DISPLAY", cUrl, {cPtControle, 0, cMsgDisplay, 5, cTicket})

            lRet := U_ADFAT24K(@cMsgError, "MENSAGEM DISPLAY", cUrl, {cPtControle, 0, cTxtFabri, 5, cTicket})

        Next

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} getMsgSeq
    Mensagens de sequestro.
    @type  User Function
    @author Everson
    @since 01/04/2022
    @version 01
/*/
Static Function getMsgSeq(nTpSeq)

    //Variáveis.
    Local cMsgDisplay := ""

    //Envia mensagem para o display.
    If nTpSeq == 1 //Quebra de peso.

        cMsgDisplay := cTxtSeq1

    ElseIf nTpSeq == 2 //Apontamento de lacre.

        cMsgDisplay := cTxtSeq2

    ElseIf nTpSeq == 3 //Apontamento de ensacado.

        cMsgDisplay := cTxtSeq3

    EndIf

Return cMsgDisplay
/*/{Protheus.doc} ADFAT24I
    Envia próximo ticket de pesagem para o web service da balança.
    @type  User Function
    @author Everson
    @since 30/03/2022
    @version 01
/*/
User Function ADFAT24I(cCp, cTktAnt, nPesIni, cMsgError)

    //Variáveis.
    Local aArea         := GetArea()
    Local lRet          := .T.
    Local cQuery        := ""
    Local cFlxRmt       := ""
    Local cTag          := ""
    Local cPlaca        := ""
    Local cTktProtheus  := ""
    Local cNmOrdem      := ""
    Local cUrl          := ""
    Local cBalanca      := ""
    Local cFlxFinal     := Alltrim(cValToChar(GetMv("MV_#ADF241",,"F3")))
    Local cTktGAng      := Posicione("ZIG", 1, FWxFilial("ZIG") + cTktAnt, "ZIG_NUMGUA")
    Local cMsgErr1      := ""
    
    Default cTktGuar    := ""

    Default cMsgError := ""

    If ! U_ADFAT17U(cCP)
        cMsgError := "ADFAT24I(ADFAT024P)-Controle de pátio " + cCp + " não localizado"
        RestArea(aArea)
        Return .F.

    EndIF

    cQuery := " SELECT TOP 1 ZIG_NUMERO, ZIG_ORDEM, ZIG_NUMGUA FROM " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG WHERE ZIG_FILIAL = '" + FWxFilial("ZIG") + "' AND ZIG_CTPATI = '" + cCP + "' AND ZIG_INICIA = '2' AND ZIG_NUMGUA = '' ORDER BY ZIG_SEQTKT "

    If Select("D_PRXTK") > 0
        D_PRXTK->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_PRXTK"
    DbSelectArea("D_PRXTK")
    D_PRXTK->(DbGoTop())

    If ! D_PRXTK->(Eof())

        cFlxRmt     := Alltrim(cValToChar( Posicione("ZI9", 1, FwxFilial("ZI9") + ZIB->ZIB_CODROT, "ZI9_FXGURE") ))
        cTag        := ZIB->ZIB_TAG
        cPlaca      := ZIB->ZIB_PLACA
        cTpOrdem    := ZIB->ZIB_TPMOVI
        cTktProtheus:= D_PRXTK->ZIG_NUMERO
        cTktGuar    := D_PRXTK->ZIG_NUMGUA
        cNmOrdem    := D_PRXTK->ZIG_ORDEM
        cBalanca    := Posicione("ZIG", 1, FWxFilial("ZIG") + cTktProtheus, "ZIG_BALANC")
        cUrl        := Alltrim(cValToChar(Posicione("DX5" , 1, FwxFilial("DX5") + cBalanca, "DX5_URL")))

        U_ADFAT24K(@cMsgErr1, "ENCERRA TICKET", cUrl, Nil, Nil, {cTktGAng, 3, cTktAnt})

        //Envia novo ticket de pesagem para balança.
        lRet := U_ADFAT17S(cTpOrdem, cPlaca, cTag, cTktProtheus, cFlxRmt, cNmOrdem, nPesIni, cBalanca, cUrl, "PI_INICIAL", "MCA_PESAGEM",@cMsgError)

        lRet := U_ADFAT24K(@cMsgError, "MENSAGEM DISPLAY", cUrl, {cPtControle, 0, cTxtFabri, 0, cTktAnt})

        cMsgError += cMsgErr1 + " " + cMsgError

    Else

        cBalanca := Posicione("ZIG", 1, FWxFilial("ZIG") + cTktAnt, "ZIG_BALANC")
        cTktGuar := Posicione("ZIG", 1, FWxFilial("ZIG") + cTktAnt, "ZIG_NUMGUA")

        cUrl     := Alltrim(cValToChar(Posicione("DX5" , 1, FwxFilial("DX5") + cBalanca, "DX5_URL")))
        
        lRet     := U_ADFAT24K(@cMsgError, "MENSAGEM DISPLAY", cUrl, {cPtControle, 0, cTxtSaida, 0, cTktAnt})

        lRet     := U_ADFAT24K(@cMsgError, "REMONTA FLUXO", cUrl, Nil, {cTktGuar, cFlxFinal, cTktAnt})

    EndIf

    D_PRXTK->(DbCloseArea())

    If ! lRet
        cMsgError += "ADFAT24I(ADFAT024P)-" + cMsgError

    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} atuPeG
    Atualiza registros de pesagem vindos do Guardian.
    @type  Static Function
    @author Everson
    @since 06/12/2021
    @version 01
/*/
Static Function atuPeGua(aRecAtu)

    //Variáveis.
    Local aArea     := GetArea()
    Local nAux      := 1
    Local lRet      := .F.
    Local oModel    := Nil
    Local cMsgError := ""
    Local cEmilErr  := GetMv("MV_#FAT291",,"everson.silva@adoro.com.br;wagner.moro@adoro.com.br")

    For nAux := 1 To Len(aRecAtu)
    
        DbSelectArea("ZIH")
        ZIH->(DbGoTo(aRecAtu[nAux][1]))

        oModel := FwLoadModel("ADFAT024P")
        oModel:SetOperation(MODEL_OPERATION_UPDATE)
        oModel:Activate()

        If aRecAtu[nAux][2]
            oModel:SetValue("MD_MASTER", "ZIH_PROCES", "1")

        Else
            oModel:SetValue("MD_MASTER", "ZIH_PROCES", "1") //Everson - 24/05/2022. Chamado 18465.
            oModel:SetValue("MD_MASTER", "ZIH_ERRO", aRecAtu[nAux][3])
            
        EndIf

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

        If ! aRecAtu[nAux][2]
            U_EnviaEmail(GetMv("MV_RELFROM"), cEmilErr, aRecAtu[nAux][3], "Erro Comunicação Balança","")
            
        EndIf

        If ! Empty(cMsgError)
            Help(Nil, Nil, "Função atuPeGua(ADFAT024P)", Nil, "Erro na atualização de registro de pesagem Guardian." + xPula + cMsgError, 1, 0, Nil, Nil, Nil, Nil, Nil, {""})

        EndIf

    Next nAux

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADFAT24E
    Processa importação.
    @type  User Function
    @author Everson
    @since 06/12/2021
    @version 01
/*/
User Function ADFAT24E()

    MsAguarde({|| U_ADFAT24C() },"Aguarde","Obtendo dados...")
    MsAguarde({|| U_ADFAT24D() },"Aguarde","Processando registros...")

Return Nil
/*/{Protheus.doc} ADFAT24
    Ponto de entrada.
    @type  User Function
    @author Everson
    @since 17/05/2022
    @version 01
/*/
User Function ADFAT24()

    //Variáveis.
    Local aArea       := GetArea()
	Local aParam	  := PARAMIXB
	Local xRet 		  := .T.
	Local oObj 		  := ""
	Local cIdPonto 	  := ""
	Local cIdModel 	  := ""
    Local oModelx     := Nil
    Local nOperation  := 0
    Local cNumero     := ""
    Local lBarramento := GetMv("MV_#ADF251",,.T.) //Registros de pesagem vindos do barramento.
    
	If aParam <> Nil

		oObj 	    := aParam[1]
		cIdPonto    := aParam[2]
		cIdModel    := aParam[3]
        nOperation  := oObj:GetOperation()

		If cIdPonto == "MODELCOMMITNTTS" .And. ! lBarramento

            oModelx := FWModelActive()
            cNumero := oModelx:GetValue("MD_MASTER", "ZIH_TKTGUA") + oModelx:GetValue("MD_MASTER", "ZIH_CODIGO")

            If nOperation == MODEL_OPERATION_INSERT
                cOperacao := "I"

            ElseIf nOperation == MODEL_OPERATION_UPDATE
                cOperacao := "A"

            ElseIf nOperation == MODEL_OPERATION_DELETE
                cOperacao := "D"

            EndIf

            If ! Empty(cOperacao) .And. ! Empty(cNumero)
                grvBarr(cOperacao, cNumero)

            EndIf

		EndIf

	EndIf

    RestArea(aArea)

Return xRet
/*/{Protheus.doc} grvBarr
    Salva o registro para enviar ao barramento.
    @type  User Function
    @author Everson
    @since 17/05/2022
    @version 01
/*/
Static Function grvBarr(cOperacao, cNumero)

    //Variáveis.
    Local aArea := GetArea()

	U_ADFAT27C(cTbMast, 4, "pesagens_guardian", cOperacao, FWxFilial(cTbMast) + cNumero)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} User Function ADFAT24K
    Salva registro a ser enviado para balança.
    @type  Function
    @author Everson
    @since 03/02/2023
    @version 01
/*/
User Function ADFAT24K(cMsgError, cTpEnvio, cUrl, aMsgDisplay, aRemtFlx, aEncTkt, aCadTkt, aGerPvR)
    
    //Variáveis.
    Local aArea     := GetArea()
    Local oJson     := JsonObject():New()
    Local oJsonD    := JsonObject():New()
    Local cData     := DToS(Date())
    Local cHora     := Time()
    Local cId       := FWUUIDV1(.T.)
    Local cTopico   := "comunicacao_balanca"
    Local cOperacao := "I"
    Local cDados    := ""

    Default cMsgError := ""

    U_ADFAT270(oJson, cData, cHora, cId, cTopico, cOperacao)

    oJsonD['tipoDeEnvio']   := cTpEnvio
    oJsonD['url']           := cUrl

    If cTpEnvio == "MENSAGEM DISPLAY"
        oJsonD['ptControle'] := aMsgDisplay[1]
        oJsonD['posicao']    := aMsgDisplay[2]
        oJsonD['msgDisplay'] := aMsgDisplay[3]
        oJsonD['tempo']      := aMsgDisplay[4]
        oJsonD['tktProtheus']:= aMsgDisplay[5]


    ElseIf cTpEnvio == "REMONTA FLUXO"
        oJsonD['tktGuardian'] := aRemtFlx[1]
        oJsonD['fluxo']       := aRemtFlx[2]
        oJsonD['tktProtheus'] := aRemtFlx[3]

    ElseIf cTpEnvio == "ENCERRA TICKET"
        oJsonD['tktGuardian'] := aEncTkt[1]
        oJsonD['operacao']    := aEncTkt[2]
        oJsonD['tktProtheus'] := aEncTkt[3]

    ElseIf cTpEnvio == "CADASTRA TICKET"
        oJsonD['ordemPesagem']   := aCadTkt[1]
        oJsonD['tpOrdemPesagem'] := aCadTkt[2]
        oJsonD['placaCarreta']   := aCadTkt[3]
        oJsonD['placaVeiculo']   := aCadTkt[4]
        oJsonD['tag']            := aCadTkt[5]
        oJsonD['fluxo']          := aCadTkt[6]
        oJsonD['tktProtheus']    := aCadTkt[7]
        oJsonD['pesoInicial']    := aCadTkt[8]
        oJsonD['opPesoInicial']  := aCadTkt[9]
        oJsonD['perPesoInicial'] := aCadTkt[10]

    ElseIf cTpEnvio == "GERA PV RACAO"
        oJsonD['ordemPesagem']   := aGerPvR[1]
        oJsonD['tktProtheus']    := aGerPvR[2]

    EndIf

    oJson['dados'] := oJsonD

    cDados := oJson:toJson()

    FreeObj(oJson)
    FreeObj(oJsonD)

    lRet := U_ADFAT27B(cOperacao, cTopico, cId, cDados, cData, cHora, "B")

    If ! lRet
        cMsgError += "ERRO AO SALVAR DADOS NO BARRAMENTO - " + cTpEnvio + " - ZIQ" + xPula
        
    EndIf

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} User Function ADFAT24L
    Obtém tickets a balança por data.
    @type  Function
    @author Everson
    @since 06/02/2023
    @version 01
/*/
User Function ADFAT24L(cUrl, oRetSolic, cErro, cdataInicial, cdataFinal)

    //Variáveis.
    Local aArea := GetArea()
    Local lRet  := .F.
    Local oGuardian := WSWS_GUARDIAN():New()

    oGuardian:_URL := cUrl
    oGuardian:cdataInicial  := cdataInicial
    oGuardian:cdataFinal    := cdataFinal
    oGuardian:cproduto      := cProdGuard
    oGuardian:ccodigo       := cCodGuard
    
    If oGuardian:ConsultaTicketsPorPeriodo()
    
        If oGuardian:nErro = 0
            lRet := .T.
            oRetSolic := oGuardian:oWSConsultaTicketsPorPeriodoResult

        Else
            cErro := cValToChar(oGuardian:nErro) + " " + Alltrim(cValToChar(oGuardian:cErroMSG))

        EndIf

    Else
        cErro := "GetWSCError " + GetWSCError()
        
    EndIf 

    RestArea(aArea)

Return lRet
