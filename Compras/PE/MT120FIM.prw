#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function MT120FIM
    O ponto se encontra no final da fun��o A120PEDIDO. Ap�s a restaura��o do filtro da FilBrowse depois de fechar a opera��o realizada no pedido de compras, � a ultima instru��o da fun��o A120Pedido.
    @type  Function
    @author FWNM
    @since 15/04/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @chamado 057440 || OS 058919 || TECNOLOGIA || LUIZ || 8451 || HIST. APROVACAO
    @history Chamado 057827 - FWNM                  - 30/04/2020 - || OS 059306 || SUPRIMENTOS || IARA_MOURA || 8415 || ERRO LOG
    @history Chamado TI     - FWNM                  - 14/05/2020 - Preencher campo CR_XLEGAPP
    @history Chamado 15804  - Leonardo P. Monteiro  - 08/07/2021 - Grava informa��es adicionais do Pedido de Compra.
    @history Chamado 15804  - Leonardo P. Monteiro  - 26/08/2021 - Inclus�o do nome do munic�pio.
    @history Chamado 15804  - Leonardo P. Monteiro  - 31/08/2021 - Corre��o de error.log.
    @history Chamado 34655  - Abel Babini           - 28/09/2021 - Corre��o preenchimento do campo C7_XSOLIC
    @history Chamado 64070  - Everson               - 03/02/2022 - Tratamento para zerar valor de frete do item.
    @history Chamado TI     - Everson               - 07/02/2022 - Tratamento para zerar valor de frete do item.
    @history Ticket 18465   - Everson               - 19/07/2022 - Rotina para envio para o barramento.
    @history Ticket  76847  - Fernando Macieira     - 20/07/2021 - falha aprova��o pedido de compra
    @history Ticket 18465   - Everson           - 21/07/2022 - Envio de registro para o barramento.
    @history Ticket 18465   - Everson           - 22/09/2022 - Envio de registro para o barramento.
    @history Ticket 18465   - Eveson            - 18/10/2022 - Tratamento para envio do pedido para o barramento ap�s aprova��o autom�tica vinculada ao contrato de compra.
    @history Ticket 18465   - Eveson            - 16/11/2022 - Corre��o da filial.
    @history Everson, 16/02/2023, ticket 88099 - Adicionado log para Op/Os. 
/*/
User Function MT120FIM()

    Local aArea      := GetArea()
    Local aAreaSC7   := SC7->( GetArea() )
    Local nQtdApr    := 0
    
    //Local lCYCONAPRO := .f.
    Private cPCOri   := ""
    Private nOpc     := PARAMIXB[1] // 9 = C�pia
    Private cNumPC   := PARAMIXB[2]
    Private nBotao   := PARAMIXB[3] // 0 = Cancelar, 1 = Confirmar/OK

    If nOpc == 2 .or. nBotao == 0 // Visualizar ou Cancelar
        Return
    EndIf


    If ALTERA .or. nOpc == 4

        If Select("Work") > 0
            Work->( dbCloseArea() )
        EndIf

        // Somo qtd vezes que o PC j� foi aprovado
        cQuery := " SELECT COUNT(DISTINCT CY_VERSAO) TT_LIBERADOS
        cQuery += " FROM " + RetSqlName("SCY") + " (NOLOCK)
        cQuery += " WHERE CY_FILIAL='"+FWxFilial("SCY")+"' 
        cQuery += " AND CY_NUM='"+cNumPC+"'       
        cQuery += " AND CY_CONAPRO='L'
        cQuery += " AND D_E_L_E_T_=''

        tcQuery cQuery New Alias "Work"

        Work->( dbGoTop() )
        
        If Work->TT_LIBERADOS > 0
            nQtdApr := Work->TT_LIBERADOS + 1

            If Select("Work") > 0
                Work->( dbCloseArea() )
            EndIf

            // Gravo campo C7_XQTDAPR
            SC7->( dbGoTop() )
            SC7->( dbSetOrder(1) ) // C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN, R_E_C_N_O_, D_E_L_E_T_
            If SC7->( dbSeek(FWxFilial("SC7")+cNumPC) )

                Do While SC7->( !EOF() ) .and. SC7->C7_FILIAL==FWxFilial("SC7") .and. SC7->C7_NUM==cNumPC

                    RecLock("SC7", .f.)
                        SC7->C7_XQTDAPR := nQtdApr

                    SC7->( msUnLock() )

                    SC7->( dbSkip() )

                EndDo

            EndIf

        EndIf

    EndIf

    // Chamado n. 057440 || OS 058919 || TECNOLOGIA || LUIZ || 8451 || HIST. APROVACAO - FWNM - 20/04/2020 - 
    If IsInCallStack("A120Copia") // Chamado n. 057827 || OS 059306 || SUPRIMENTOS || IARA_MOURA || 8415 || ERRO LOG - FWNM - 30/04/2020
        
        If lSubsPC //Vari�vel P�blica inicializada no PE MT120CPE contido dentro do MT120F.PRW
        
            cPCOri := SC7->C7_XPEDORI

            aSC7 := SC7->( GetArea() )
            nQtdApr := Posicione("SC7",1,SC7->C7_FILIAL+cPCOri,"C7_XQTDAPR") + 1
            RestArea( aSC7 )

            // Gravo campo C7_XQTDAPR
            SC7->( dbGoTop() )
            SC7->( dbSetOrder(1) ) // C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN, R_E_C_N_O_, D_E_L_E_T_
            If SC7->( dbSeek(FWxFilial("SC7")+cNumPC) )

                Do While SC7->( !EOF() ) .and. SC7->C7_FILIAL==FWxFilial("SC7") .and. SC7->C7_NUM==cNumPC

                    RecLock("SC7", .f.)
                        SC7->C7_XQTDAPR := nQtdApr
                    SC7->( msUnLock() )

                    SC7->( dbSkip() )

                EndDo

            EndIf
        
        EndIf

    EndIf
    //

    // Legenda APP - Central Aprova��o
    UpAPP() 
    // Grava informa��es adicionais.
    fGrvInf()

    //Everson - 03/02/2020. Chamado 64070.
    lmpFrt(SC7->C7_NUM)

    ////Everson - 18/10/2022 - ticket 18465.
    //Everson - 19/07/2022. Chamado 18465.
    U_grvSC7Barr(cNumPC, ALTERA, INCLUI, nOpc)//Ticket 18465   - Everson - 22/09/2022 - Envio de registro para o barramento.

    //Everson - 16/02/2023 - ticket 88099.
    If INCLUI .Or. nOpc == 3 .And. ! Empty(SC7->C7_OP)
        U_ADMNT220(SC7->C7_OP, "", "INCLUS�O DE PEDIDO DE COMPRA " + SC7->C7_NUM, "")

    EndIf

    //Everson - 16/02/2023 - ticket 88099.
    If ALTERA .Or. nOpc == 4 .And. ! Empty(SC7->C7_OP)
        U_ADMNT220(SC7->C7_OP, "", "ALTERA��O DE PEDIDO DE COMPRA " + SC7->C7_NUM, "")

    EndIf

    RestArea( aAreaSC7 )
    RestArea(aArea)

Return

Static Function fGrvInf()
    Local cQuery    := ""
    Local cSolic    := ""
    Local cRazao    := ""
    Local cEst      := ""
    Local cMun      := ""

    //@history Chamado 15804  - Leonardo P. Monteiro  - 08/07/2021 - Grava informa��es adicionais do Pedido de Compra.
    if (ALTERA .or. nOpc == 4) .or. (INCLUI .or. nOpc == 3) .OR. nOpc == 9
        // Gravo campo C7_XQTDAPR
        SC7->( dbGoTop() )
        SC7->( dbSetOrder(1) ) // C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN, R_E_C_N_O_, D_E_L_E_T_
        If SC7->( dbSeek(FWxFilial("SC7")+cNumPC) )
            cQuery  := " SELECT A2_NOME, A2_EST, A2_MUN "
            cQuery  += " FROM "+ RetSqlName("SA2") +" SA2 "
            cQuery  += " WHERE D_E_L_E_T_='' AND A2_FILIAL='"+ xFilial("SA2") +"' AND A2_COD='"+ SC7->C7_FORNECE +"' AND A2_LOJA='"+ SC7->C7_LOJA +"'; "

            tcQuery cQuery ALIAS "QSA2" NEW

            if QSA2->(!eof())
                cRazao  := QSA2->A2_NOME
                cEst    := QSA2->A2_EST
                cMun    := QSA2->A2_MUN
            endif

            QSA2->(dbCloseArea())
            
            While SC7->( !EOF() ) .and. SC7->C7_FILIAL==FWxFilial("SC7") .and. SC7->C7_NUM==cNumPC
                
                if EMPTY(Alltrim(SC7->C7_XSOLIC))
                    if !Empty(SC7->C7_NUMSC) .and. !Empty(SC7->C7_ITEMSC)

                        cQuery  := " SELECT C1_USER "
                        cQuery  += " FROM "+ RetSqlName("SC1") +" SC1 "
                        cQuery  += " WHERE D_E_L_E_T_='' AND C1_FILIAL='"+ xFilial("SC1") +"' AND C1_NUM='"+ SC7->C7_NUMSC +"' AND C1_ITEM='"+ SC7->C7_ITEMSC +"'; "

                        tcQuery cQuery ALIAS "QSC1" NEW

                        if QSC1->(!eof())
                            cSolic := QSC1->C1_USER
                            cSolic := Alltrim(cSolic)+"-"+AllTrim(UsrFullName(cSolic))    
                        endif

                        QSC1->(dbCloseArea())

                    else
                        cSolic := Alltrim(SC7->C7_USER)+"-"+AllTrim(UsrFullName(SC7->C7_USER))
                    endif
                ELSE
                    cSolic := Alltrim(SC7->C7_XSOLIC) //Chamado 34655  - Abel Babini           - 28/09/2021 - Corre��o preenchimento do campo C7_XSOLIC
                endif

                RecLock("SC7", .f.)
                    
                    if !EMPTY(cSolic)
                        SC7->C7_XSOLIC := cSolic
                    Endif
                    
                    if !EMPTY(cRazao)
                        SC7->C7_XRAZAO := cRazao
                    Endif

                    if !EMPTY(cEst)
                        SC7->C7_XEST := cEst
                    Endif

                    if !EMPTY(cMun)
                        SC7->C7_XMUN := cMun
                    Endif


                SC7->( msUnLock() )

                SC7->( dbSkip() )

            EndDo

        EndIf
    ENDIF

return
/*/{Protheus.doc} Static Function UpApp
    Fun��o para gerenciar flag que ser� utilizado pelo APP na Central de Aprova��o
    @type  Static Function
    @author FWNM
    @since 16/04/2020
    @version version
    @param param_name, param_type param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @chamado 057440 || OS 058919 || TECNOLOGIA || LUIZ || 8451 || HIST. APROVACAO
/*/
Static Function UpApp()

    Local cQuery     := ""
    Local cUltVersao := ""
    Local nUltTotal  := 0
    Local lDifTotal  := .f.
    Local cLegendaPC := "1" // Primeira aprova��o

    If lSubsPC //Vari�vel P�blica inicializada no PE MT120CPE contido dentro do MT120F.PRW
        
        cLegendaPC := "4" // PC substitu�do

    Else

        If Select("Work") > 0
            Work->( dbCloseArea() )
        EndIf

        // Pego dados antes da �ltima altera��o para compara��es que determinar�o as legendas
        cQuery := " SELECT CY_VERSAO
        cQuery += " FROM " + RetSqlName("SCY") + " (NOLOCK)
        cQuery += " WHERE CY_FILIAL='"+FWxFilial("SCY")+"' 
        cQuery += " AND CY_NUM='"+cNumPC+"'       
        cQuery += " AND CY_CONAPRO='L'
        cQuery += " AND D_E_L_E_T_=''
        cQuery += " ORDER BY 1 DESC

        tcQuery cQuery New Alias "Work"

        Work->( dbGoTop() )
            
        If Work->( !EOF() )
            cUltVersao := Work->CY_VERSAO
        EndIf

        If Select("Work") > 0
            Work->( dbCloseArea() )
        EndIf

        // Pego �ltimo valor total do PC - SCY
        cQuery := " SELECT SUM(CY_TOTAL) CY_TOTAL
        cQuery += " FROM " + RetSqlName("SCY") + " (NOLOCK)
        cQuery += " WHERE CY_FILIAL='"+FWxFilial("SCY")+"' 
        cQuery += " AND CY_NUM='"+cNumPC+"'       
        cQuery += " AND CY_VERSAO='"+cUltVersao+"' 
        cQuery += " AND CY_CONAPRO='L'
        cQuery += " AND D_E_L_E_T_=''

        tcQuery cQuery New Alias "Work"

        nUltTotal := Work->CY_TOTAL

        If Select("Work") > 0
            Work->( dbCloseArea() )
        EndIf

        // Pego valor total do PC atual
        cQuery := " SELECT SUM(C7_TOTAL) C7_TOTAL
        cQuery += " FROM " + RetSqlName("SC7") + " (NOLOCK)
        cQuery += " WHERE C7_FILIAL='"+FWxFilial("SC7")+"' 
        cQuery += " AND C7_NUM='"+cNumPC+"'       
        cQuery += " AND D_E_L_E_T_=''

        tcQuery cQuery New Alias "Work"

        // Efetuo comparacoes para definir legenda
        // Total diferente
        If !Empty(cUltVersao)
            If Work->C7_TOTAL <> nUltTotal
                lDifTotal := .t.
            Else
                cLegendaPC := "2" // Altera��o com valor mantido
            EndIf
        EndIf

        // Defino legenda
        If lDifTotal
            cLegendaPC := "3" // Total diferente da �ltima altera��o
        EndIf

    EndIf

    // Gravo campo C7_XQTDAPR
    SC7->( dbGoTop() )
    SC7->( dbSetOrder(1) ) // C7_FILIAL, C7_NUM, C7_ITEM, C7_SEQUEN, R_E_C_N_O_, D_E_L_E_T_
    If SC7->( dbSeek(FWxFilial("SC7")+cNumPC) )

        Do While SC7->( !EOF() ) .and. SC7->C7_FILIAL==FWxFilial("SC7") .and. SC7->C7_NUM==cNumPC

            RecLock("SC7", .f.)
                SC7->C7_XLEGAPP := cLegendaPC
            SC7->( msUnLock() )

            SC7->( dbSkip() )

        EndDo

    EndIf

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

    // Chamado TI - FWNM - 14/05/2020 - Preenche campo customizado CR_XLEGAPP
    // Grava SCR
    //SCR->( dbSetOrder(4) ) // CR_FILIAL, CR_NUM, R_E_C_N_O_, D_E_L_E_T_
    SCR->( dbOrderNickName("SCRNUM") ) // CR_FILIAL, CR_NUM, R_E_C_N_O_, D_E_L_E_T_ // @history Ticket  76847  - Fernando Macieira - 20/07/2021 - falha aprova��o pedido de compra
    If SCR->( dbSeek(FWxFilial("SCR")+cNumPC) )

        Do While SCR->( !EOF() ) .and. SCR->CR_FILIAL==FWxFilial("SCR") .and. AllTrim(SCR->CR_NUM)==AllTrim(cNumPC)

            RecLock("SCR", .f.)
                SCR->CR_XLEGAPP := cLegendaPC
            SCR->( msUnLock() )
        
            SCR->( dbSkip() )

        EndDo

    EndIf

Return
/*/{Protheus.doc} lmpFrt
    Fun��o limpa frete.
    Chamado 64070.
    @type  Function
    @author Everson
    @since 03/02/2022
    @version 01
    /*/
Static Function lmpFrt(cNumPed)

    //Vari�veis.
    Local aArea := GetArea()

    DbSelectArea("SC7")
    SC7->(DbSetOrder(1))
    If SC7->(DbSeek( FWxFilial("SC7") + cNumPed) )

        While ! SC7->(Eof()) .And. FWxFilial("SC7") == SC7->C7_FILIAL .And. SC7->C7_NUM == cNumPed //Everson - 07/02/2022. Chamado TI.

            If SC7->C7_FRETE == 0

                RecLock("SC7", .F.)
                    SC7->C7_VALFRE := 0
                SC7->(MsUnLock())

            EndIf

            SC7->(DbSkip())

        End

    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} grvSC7Barr
    Salva o registro para enviar ao barramento.
    @type  User Function
    @author Everson
    @since 19/07/2022
    @version 01
/*/
User Function grvSC7Barr(cNumero, ALTERA, INCLUI, nOpc) //Everson - 18/10/2022 - ticket 18465.

    //Vari�veis.
    Local aArea     := GetArea()
    Local cFilter   := ""
    Local cCmp      := "C7_FILIAL;C7_NUM;C7_EMISSAO;C7_FORNECE;C7_LOJA;C7_COND;C7_CONTATO;C7_FILENT;C7_MOEDA;C7_TX;"
    Local cTopico   := "pedidos_de_compra_protheus"
    Local cOperacao := ""
    Local cFiliais  := Alltrim(GetMv("MV_#FAT171",,"")) //Ticket 18465   - Everson - 21/07/2022.

    If !(cFilAnt $cFiliais)
        RestArea(aArea)
        Return Nil

    EndIf

    If (ALTERA .Or. nOpc == 4) 
        cOperacao := "A"

    ElseIf(INCLUI .Or. nOpc == 3) .Or. nOpc == 9 
        cOperacao := "I"
    
    ElseIf nOpc == 5
        cOperacao := "D"

    Else
        RestArea(aArea)
        Return Nil

    EndIf

    cFilter := " C7_FILIAL ='" + FWxFilial("SC7") + "' .And. C7_NUM = '" + cNumero + "' "

    U_ADFAT27D("SC7", 1, FWxFilial("SC7") + cNumero,;
        "SC7", 1, FWxFilial("SC7") + cNumero, "C7_ITEM", cFilter,; //Everson - 16/11/2022 - Ticket 18465.
        cTopico, cOperacao,;
        .T., .T., .T.,;
        cCmp) 

    RestArea(aArea)

Return Nil
