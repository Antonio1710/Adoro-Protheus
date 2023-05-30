#Include "Totvs.ch"
#Include "Topconn.ch"
#Include "FWPrintSetup.ch"
#Include "RptDef.ch"

/*/{Protheus.doc} User Function ADCOM046R
    Impressão do pedido de compra de matéria-prima.
    Ticket 18465.
    @type  Function
    @author Everson
    @since 04/01/2023
    @version 01
    @history Everson, 09/01/2023 - ticket 18465 - Impressão da quantidade programada para entrega.
    @history Everson, 20/02/2023 - ticket 18465 - Tratamento para impressão de cabeçalho, conforme a filial de entrega do contrato de compra.
    @history Everson, 02/03/2023 - Ticket 18465 - Tratamento para adicionar a impressão de pedido de compra na tela de contrato de MP.
    @history Everson, 03/03/2023 - Ticket 18465 - Tratamento para adicionar a impressão de horário de produto Micro.
    @history Everson, 15/03/2023 - Ticket 18465 - Adicionada observação do campo memo.
    @history Jonathan, 04/04/2023 - Ticket 90851 - Adicionado filtro de impressão do relatorio
    @history Wagner, 15/05/2023 -  Ticket 93468 - Adicionada tipo da operação 2 e 3 ao relatorio
/*/
User Function ADCOM046R()

    //Variáveis.
    Local cPedido := SC7->C7_NUM

    If IsInCallStack("U_ADCOM042P")

        cPedido := ZIO->ZIO_PEDCOM

        If Empty(cPedido)
            MsgInfo("Não há pedido de compra vinculado.", "Função ADCOM046R")
            Return Nil

        EndIf


    Else
        cPedido := SC7->C7_NUM

    EndIf

    If ! MsgYesNo("Deseja imprimir o pedido " + cPedido + "?", "Função ADCOM046R")
        Return Nil

    EndIf

    MsAguarde({|| processa(cPedido) }, "Aguarde", "Imprimindo...")

Return Nil
/*/{Protheus.doc} processa
    Processa impressão de ticket de pesagem do tipo "Ração".
    @type  Static Function
    @author Everson
    @since 04/01/2023
    @version 01
/*/
Static Function processa(cPedido)

    //Variáveis.
    Local aArea             := GetArea()
    Local nLinha            := 330
    Local cCabec0           := ""
    Local cCabec1           := ""
    Local cCabec2           := ""
    Local cCabec3           := ""
    Local cCabec4           := ""
    Local cCabec5           := ""
    Local cCabec6           := ""
    Local lAdjustToLegacy   := .F.
    Local lDisableSetup     := .T.
    Local oPrinter          := Nil
    Local oFt10N            := TFont():New("Arial",10,10,,.F.,,,,.F.,.F.)
    Local oFt12N            := TFont():New("Arial",12,12,,.F.,,,,.F.,.F.)
    Local oFt12B            := TFont():New("Arial",12,12,,.T.,,,,.F.,.F.)
    Local oFt14B            := TFont():New("Arial",14,14,,.T.,,,,.F.,.F.)
    Local oFt16B            := TFont():New("Arial",16,16,,.T.,,,,.F.,.F.)
    Local oFt14BV           := TFont():New("Arial",16,16,,.T.,,,,.F.,.F.)
    Local cDtPed            := ""
    Local cFornece          := ""
    Local cCNPJ             := ""
    Local cInscr            := ""
    Local cTelef            := ""
    Local cEnder            := ""
    Local cBairro           := ""
    Local cCEP              := ""
    Local cCidade           := ""
    Local cUF               := ""
    Local cTpFrt            := ""
    Local cMoeda            := ""
    Local cFPag             := ""
    Local aOpFPag           := RetSX3Box(GetSX3Cache("ZIO_FORPAG", "X3_CBOX"),,,1)
    Local cNpag             := ""
    Local cSitPed           := ""
    Local nQtdTot           := 0
    Local nVlrTot           := 0
    Local lMdEstr           := .T.
    Local cTexFilAnt        := FWxFilial("SC7")
    Local cObs              := ""
    Local cObs2             := ""
    Local cGrpMicro         := Alltrim(cValToChar(GetMv("MV_#COM461",,"9003")))
    Local cTipoOp           := ""
    Local cTipoCom          := ""


    //Everson - 20/02/2023 - ticket 18465.
    DbSelectArea("ZIO")
    ZIO->(DbSetOrder(5))
    If ZIO->(DbSeek( FWxFilial("ZIO") + cPedido ))

        If ! Empty(ZIO->ZIO_FILENT)
            cTexFilAnt := ZIO->ZIO_FILENT

        EndIf

        If ! Empty(ZIO->ZIO_FORPAG)
            cFPag := aOpFPag[Val(cValToChar(ZIO->ZIO_FORPAG))][3]

        EndIf

        cObs2 := Alltrim(cValToChar(ZIO->ZIO_OBS)) //Everson - 15/03/2023 - ticket 18465.
        
        cTipoOp := ZIO->ZIO_TIPO
        
        If cTipoOp $ "2|3" //Wagner - 15/05/2023 - ticket 93468
            If cTipoOp == "2"
                cTipoCom := "Compra entrega futura"
            Else
                cTipoCom := "Compra armazenagem em terceiro"
            Endif
        Endif
    EndIf

    If cTexFilAnt == "03"
        cCabec0 := "AD'ORO SÃO CARLOS"
        cCabec1 := "CNPJ: 60.037.058/0004-84 INC. EST: 637.098.844.113"
        cCabec2 := "EST.S.CARLOS A RIB.BONITO KM 157"
        cCabec3 := "Bairro/Localidade: Zona Rural"
        cCabec4 := "CEP : 13.560-000"
        cCabec5 := "Fone : (016) 21063500"
        cCabec6 := "Cidade: São Carlos UF: SP"

    ElseIf cTexFilAnt == "05"
        cCabec0 := "AD'ORO FÁBRICA DE RAÇÃO MATRIZES"
        cCabec1 := "CNPJ: 60.037.058/0018-80 INC. EST: 637.321.320.111"
        cCabec2 := "Rod. SP 215 KM 154"
        cCabec3 := "Bairro/Localidade: Zona Rural"
        cCabec4 := "CEP : 13.560-000"
        cCabec5 := "Fone : (016) 21063500"
        cCabec6 := "Cidade: São Carlos UF: SP"

    EndIf

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    SC7->(DbGoTop())
    If ! SC7->( DbSeek( FWxFilial("SC7") + cPedido ) )
        MsgInfo("Pedido não localizado " + cPedido, "Função processa(ADCOM046R)")
        RestArea(aArea)
        Return Nil

    EndIf

    DbSelectArea("SA2")
    SA2->(DbSetOrder(1))
    SA2->(DbGoTop())
    If ! SA2->(DbSeek( FWxFilial("SA2") + SC7->C7_FORNECE + SC7->C7_LOJA))
        MsgInfo("Fornecedor não localizado " + SC7->C7_FORNECE + SC7->C7_LOJA, "Função processa(ADCOM046R)")
        RestArea(aArea)
        Return Nil

    EndIf

    cDtPed   := DToC(SC7->C7_EMISSAO)
    cFornece := SC7->C7_FORNECE + " " + SC7->C7_LOJA + " - " + Alltrim(cValToChar(SA2->A2_NOME))
    cCNPJ    := Alltrim(cValToChar(SA2->A2_CGC))
    cInscr   := Alltrim(cValToChar(SA2->A2_INSCR))
    cTelef   := "(" + Alltrim(cValToChar(SA2->A2_DDD)) + ") " + Alltrim(cValToChar(SA2->A2_TEL)) 
    cEnder   := Alltrim(cValToChar(SA2->A2_END))
    cBairro  := Alltrim(cValToChar(SA2->A2_BAIRRO))
    cCEP     := Alltrim(cValToChar(SA2->A2_CEP))
    cCidade  := Alltrim(cValToChar(SA2->A2_MUN))
    cUF      := Alltrim(cValToChar(SA2->A2_EST))

    If SC7->C7_TPFRETE == "F"
        cTpFrt   := "Destinatário (FOB)"

    ElseIf SC7->C7_TPFRETE == "C"
        cTpFrt   := "Emitente (CIF)"

    EndIf

    If SC7->C7_MOEDA == 1
        lMdEstr  := .F.
        cMoeda   := "Real"

    ElseIf SC7->C7_MOEDA == 2
        cMoeda   := "Dólar"

    ElseIf SC7->C7_MOEDA == 3
        cMoeda   := "Euro"

    EndIf

    cNpag    := Alltrim(cValToChar(Posicione("SE4", 1, FWxFilial("SE4") + SC7->C7_COND, "E4_DESCRI")))

    cSitPed  := Iif(SC7->C7_CONAPRO == "L", "Aprovado", "Liberado")

    oPrinter := FWMSPrinter():New(cPedido, IMP_PDF, lAdjustToLegacy, , lDisableSetup,,,,,,,,2)
 
    oPrinter:StartPage()

        oPrinter:SayBitmap (30, 20, "\img_ticket_racao\logotipo.png", 56.5, 50)
        oPrinter:SayAlign(30, 20, cCabec0, oFt16B, 555, 30,,2)
        
        oPrinter:SayAlign(055, 20, cCabec1, oFt12N, 555, 20,,2,0)
        oPrinter:SayAlign(065, 20, cCabec2, oFt12N, 555, 20,,2,0)
        oPrinter:SayAlign(075, 20, cCabec3, oFt12N, 555, 20,,2,0)
        oPrinter:SayAlign(085, 20, cCabec4, oFt12N, 555, 20,,2,0)
        oPrinter:SayAlign(095, 20, cCabec5, oFt12N, 555, 20,,2,0)
        
        oPrinter:SayAlign(105, 20, cCabec6, oFt12N, 555, 20,,2,0)

        oPrinter:Say(050, 480, "Pedido", oFt12B)
        oPrinter:Say(060, 480, cPedido, oFt12N)

        oPrinter:Say(075, 480, "Data Pedido", oFt12B)
        oPrinter:Say(085, 480, cDtPed, oFt12N)

        oPrinter:Say(100, 480, "Emitido em", oFt12B)
        oPrinter:Say(110, 480, DToC(Date()) + " " + Time(), oFt12N)

        oPrinter:Line(120, 20, 120, 575)

        //Coluna 1.
            oPrinter:Say(140,  20, "Fornecedor / Cliente", oFt14B)
                oPrinter:Say(160, 20, "Nome / Razão Social", oFt12B)
                oPrinter:Say(170, 20, cFornece, oFt12N)

                oPrinter:Say(190, 20, "CPF/CNPJ", oFt12B)
                oPrinter:Say(200, 20, cCNPJ, oFt12N)

                oPrinter:Say(190, 100, "Inscrição Estadual", oFt12B)
                oPrinter:Say(200, 100, cInscr, oFt12N)

                oPrinter:Say(190, 210, "Fone", oFt12B)
                oPrinter:Say(200, 210, cTelef, oFt12N)

                oPrinter:Say(220,  20, "Endereço", oFt12B)
                oPrinter:Say(230,  20, cEnder, oFt12N)

                oPrinter:Say(230, 330, "TRANSPORTADOR / TIPO DE NEGOCIAÇÃO DE PAGAMENTO/ MOEDA", oFt10N)

                oPrinter:Say(250,  20, "Bairro", oFt12B)
                oPrinter:Say(260,  20, cBairro, oFt12N)

                oPrinter:Say(250, 210, "CEP", oFt12B)
                oPrinter:Say(260, 210, cCEP, oFt12N)

                //
                oPrinter:Say(250, 330, "Tipo Frete", oFt12B)
                oPrinter:Say(260, 330, cTpFrt, oFt12N)

                oPrinter:Say(250, 400, "Moeda", oFt12B)
                oPrinter:Say(260, 400, cMoeda, oFt12N)

                oPrinter:Say(250, 450, "Forma Pgto", oFt12B)
                oPrinter:Say(260, 450, cFPag, oFt12N)
                //

                oPrinter:Say(280,  20, "Cidade", oFt12B)
                oPrinter:Say(290,  20, cCidade, oFt12N)

                oPrinter:Say(280, 210, "UF", oFt12B)
                oPrinter:Say(290, 210, cUF, oFt12N)

                //
                oPrinter:Say(280, 330, "Cond. Pagamento", oFt12B)
                oPrinter:Say(290, 330, cNpag, oFt12N)

                oPrinter:Say(280, 450, "Situação do Pedido", oFt12B)
                oPrinter:Say(290, 450, cSitPed, oFt12N)
                //

            oPrinter:Line(310, 20, 310, 575)
            
            oPrinter:Say(330,  20, "Dados Produtos", oFt14B)

            nLinha := 350

            oPrinter:Say(nLinha,  20, "Produto", oFt12B)
            oPrinter:Say(nLinha, 180, "UM", oFt12B)
            oPrinter:Say(nLinha, 205, "Quantidade", oFt12B)
            oPrinter:Say(nLinha, 270, "Preço Unt.", oFt12B)
            oPrinter:Say(nLinha, 330, "Preço Total", oFt12B)
            oPrinter:Say(nLinha, 400, "% ICMS", oFt12B)
            oPrinter:Say(nLinha, 460, "% IPI", oFt12B)
            oPrinter:Say(nLinha, 500, "Pln de Contas", oFt12B)

            While ! SC7->(Eof()) .And. SC7->C7_FILIAL == FWxFilial("SC7") .And. SC7->C7_NUM == cPedido

                If Alltrim(cValToChar(Posicione("SB1", 1, FWxFilial("SB1") + SC7->C7_PRODUTO, "B1_GRUPO"))) $cGrpMicro
                    cObs := "Data/Horário de coleta de Segunda a Sexta das 08:00 às 16:00. "

                EndIf

                nLinha += 10

                nQtdTot += SC7->C7_QUANT
                nVlrTot += SC7->C7_TOTAL

                oPrinter:SayAlign(nLinha,  20,  Alltrim(cValToChar(SC7->C7_PRODUTO)) + " - " + Alltrim(cValToChar(SC7->C7_DESCRI)), oFt10N, 150, 5,,0,2) 

                oPrinter:SayAlign(nLinha, 180,  Alltrim(cValToChar(SC7->C7_UM)), oFt10N, 50, 5,,0,2) 

                oPrinter:SayAlign(nLinha, 195,  Alltrim(cValToChar(Transform(SC7->C7_QUANT, "@E 999,999,999.999"))), oFt10N, 60, 5,,1,2)

                oPrinter:SayAlign(nLinha, 265,  Alltrim(cValToChar(Transform(SC7->C7_PRECO, "@E 999,999,999.9999"))), oFt10N, 50, 5,,1,2)

                oPrinter:SayAlign(nLinha, 320,  Alltrim(cValToChar(Transform(SC7->C7_TOTAL, "@E 999,999,999.99"))), oFt10N, 60, 5,,1,2)

                oPrinter:SayAlign(nLinha, 407,  Alltrim(cValToChar(Transform(SC7->C7_PICM, "@E 999.9999"))), oFt10N, 30, 5,,1,2)

                oPrinter:SayAlign(nLinha, 457,  Alltrim(cValToChar(Transform(SC7->C7_IPI, "@E 999.9999"))), oFt10N, 30, 5,,1,2)

                oPrinter:SayAlign(nLinha, 500,  Alltrim(cValToChar(SC7->C7_CC)), oFt10N, 50, 5,,1,2)       

                SC7->(DbSkip())

            End

            nLinha += 20

            oPrinter:SayAlign(nLinha,  20,  "Totais", oFt12N, 50, 5,,0,2) 

            oPrinter:SayAlign(nLinha, 205,  Alltrim(cValToChar(Transform(nQtdTot, "@E 999,999,999.999"))), oFt12B, 50, 5,,1,2)

            oPrinter:SayAlign(nLinha, 330,  Alltrim(cValToChar(Transform(nVlrTot, "@E 999,999,999.99"))), oFt12B, 50, 5,,1,2)

            nLinha += 30

            oPrinter:Line(nLinha, 20, nLinha, 575)

            nLinha += 20

            oPrinter:Say(nLinha,  20, "Entregas Programadas", oFt14B)

            If lMdEstr
                oPrinter:Say(nLinha, 270, "Atenção! Cotação em moeda estrangeira: " + cMoeda, oFt14BV,,CLR_HRED)

            EndIf

            nLinha += 20

            oPrinter:Say(nLinha,  20, "Produto", oFt12B)
            oPrinter:Say(nLinha, 205, "Dt Prevista", oFt12B)
            oPrinter:Say(nLinha, 270, "Qtd Prevista", oFt12B)
            oPrinter:Say(nLinha, 340, "% Qtd Total", oFt12B)

            DbSelectArea("ZIP")
            ZIP->(DbSetOrder(3))
            ZIP->(DbGoTop())
            If ZIP->( DbSeek( FWxFilial("ZIP") + cPedido ) )

                While ! ZIP->(Eof()) .And. ZIP->ZIP_FILIAL == FwxFilial("ZIP") .And. ZIP->ZIP_PEDIDO == cPedido                    

                    If ZIP->ZIP_RELAT == '1' //Ticket 90851 - Jonathan 04/04/2023

                        nLinha += 10

                        oPrinter:SayAlign(nLinha,  20,  Alltrim(cValToChar(ZIP->ZIP_PRODUT)) + " - " + Alltrim(cValToChar(ZIP->ZIP_DESPRT)), oFt12N, 150, 5,,0,2) 
                        oPrinter:SayAlign(nLinha, 215,  DToC(ZIP->ZIP_DTENTR), oFt12N, 150, 5,,0,2) 
                        oPrinter:SayAlign(nLinha, 275,  Alltrim(cValToChar(Transform(ZIP->ZIP_QUANT, "@E 999,999,999.999"))), oFt12N, 60, 5,,1,2)
                        oPrinter:SayAlign(nLinha, 340,  Alltrim(cValToChar(Transform(ZIP->ZIP_QUANT/ZIP->ZIP_QTDPED, "@E 999.99"))), oFt12N, 50, 5,,1,2)
                    
                    EndIf

                    ZIP->(DbSkip())

                End

            EndIf

            nLinha += 40

            oPrinter:Say(nLinha, 20, Iif(!Empty(cObs), cObs, "Obs: Data/Horário de coleta de Segunda a Sábado das 07:00 às 20:00. "), oFt12N)

            nLinha += 10
            
            oPrinter:Say(nLinha, 20, cTipoCom, oFt12N)
            
            nLinha += 10

            oPrinter:Say(nLinha, 20, cObs2, oFt12N)

            nLinha += 60

            oPrinter:Say(nLinha,  20, "________________________________________", oFt12N)
            oPrinter:Say(nLinha, 330, "________________________________________", oFt12N)
            
            nLinha += 10

            oPrinter:Say(nLinha,  20, "Comprador", oFt12N)
            oPrinter:Say(nLinha, 330, "Gerência/Supervisão", oFt12N)

    oPrinter:EndPage()

    oPrinter:Setup()

    If oPrinter:nModalResult == PD_OK
        oPrinter:Preview()

    EndIf

    RestArea(aArea)

Return Nil
