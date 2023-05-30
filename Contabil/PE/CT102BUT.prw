#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function CT102BUT 
    Ponto de Entrada que permite adicionar novos botões para o array arotina, no menu da mbrowse em lançamentos contábeis automáticos.
    @type  Function
    @author Fernando Macieira
    @since 29/09/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @ticket 53785 - Log inclusão/ Alteração - Protheus
    @history ticket 83525 - 04/01/2023 - Fernando Macieira - Integração Folha de Pagamento - Preenchimento do LotexCC manual
    @history ticket 83525 - 10/02/2023 - Fernando Macieira - Integração Folha de Pagamento - Preenchimento do LotexCC manual - dialog
    @history ticket 83824 - 15/02/2023 - Fernando Macieira - Preenchimento classe de valor - dialog
/*/
User Function CT102BUT()

    Local aBotao := {}
    
    aAdd( aBotao, { '* Log Inclusão/Alteração',"u_LogCT2", 0, 3 })
    aAdd( aBotao, { '* Preenche Lote Recria (Folha)'     ,"u_PutZCN" , 0, 3 }) // @history ticket 83525 - 04/01/2023 - Fernando Macieira - Integração Folha de Pagamento - Preenchimento do LotexCC manual
    aAdd( aBotao, { '* Preenche Classe Valor (Folha)'    ,"u_PutCLVL", 0, 3 }) // @history ticket 83824 - 15/02/2023 - Fernando Macieira - Preenchimento classe de valor - dialog
    
Return(aBotao)

/*/{Protheus.doc} User Function LogCT2
    (long_description)
    @type  Function
    @author FWNM
    @since 29/09/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function LogCT2()

    Local cIncLog := USRFULLNAME(SUBSTR(EMBARALHA(CT2->CT2_USERGI,1),3,6))
    Local cAltLog := USRFULLNAME(SUBSTR(EMBARALHA(CT2->CT2_USERGA,1),3,6))

    msgAlert( "Inclusão: " + cIncLog + Chr(13)+Chr(10) + " Alteração: " + cAltLog )
    
Return 

/*/{Protheus.doc} User Function PutZCN()
    Os lançamentos de despesa dos centros de custo 7(centros de custo das granjas) vem com o campo Lote x CC preenchido com o lote da granja.
    Essa informação serve para fazer o rateio do custo dos ovos.
    Agora que a folha de pagamento das granjas serão despesa da Adoro, nós precisamos que essa informação suba na contabilização da folha também.
    @type  Static Function
    @author FWNM
    @since 04/01/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @ticket 83525 - 26/12/2022 - Fernando Macieira - Integração Folha de Pagamento - Preenchimento do LotexCC manual
/*/
User Function PutZCN()

    Local cQuery := ""
    Local cCodRecria := ""
    Local cNomRecria := ""

    Local lOkDlg  	:= .F.
	
	Local oCmpPrj  := Array(01)
	Local oBtnPrj  := Array(02)
	Local cAAAAMM  := Left(DtoS(msDate()),4)+"/"+Subs(DtoS(msDate()),5,2)

    //If AllTrim(GetEnvServer()) == "PMACIEIRA" .or. AllTrim(GetEnvServer()) == "PFWNM"
    
    //@history ticket 83525 - 08/02/2023 - Fernando Macieira - Integração Folha de Pagamento - Preenchimento do LotexCC manual - dialog
	DEFINE MSDIALOG oDlgPrj TITLE "Lote Recria - Folha" FROM 0,0 TO 100,350  OF oMainWnd PIXEL
	
		@ 003, 003 TO 050,165 PIXEL OF oDlgPrj
		
		@ 010,020 Say "Informe AAAA/MM:" of oDlgPrj PIXEL
		@ 005,070 MsGet oCmpPrj Var cAAAAMM SIZE 70,12 of oDlgPrj PIXEL Valid (!Empty(cAAAAMM)) Picture "@E 9999/99"
		
		@ 030,015 BUTTON oBtnPrj[01] PROMPT "Confirma"     of oDlgPrj   SIZE 68,12 PIXEL ACTION (lOkDlg := .t., oDlgPrj:End()) 
		@ 030,089 BUTTON oBtnPrj[02] PROMPT "Cancela"      of oDlgPrj   SIZE 68,12 PIXEL ACTION (lOkDlg := .f., oDlgPrj:End())
		
	ACTIVATE MSDIALOG oDlgPrj CENTERED

    If lOkDlg

        cAAAAMM := StrTran(cAAAAMM,"/","")
        
        If Select("WorkCT2") > 0
            WorkCT2->( dbCloseArea() )
        EndIf

        cQuery := " SELECT R_E_C_N_O_ RECNO
        cQuery += " FROM " + RetSqlName("CT2") + " (NOLOCK)
        cQuery += " WHERE CT2_ORIGEM='CTBI102'
        cQuery += " AND D_E_L_E_T_=''
        cQuery += " AND CT2_DATA LIKE '"+cAAAAMM+"%' 

        tcQuery cQuery new alias "WorkCT2"

        WorkCT2->( dbGoTop() )
        Do While WorkCT2->( !EOF() )

            CT2->( dbGoTo(WorkCT2->RECNO) )

            If AllTrim(CT2->CT2_ORIGEM) == "CTBI102"

                // Crédito
                If Left(AllTrim(CT2->CT2_CCC),1) == "7"

                    cCodRecria := ""
                    cNomRecria := ""

                    // Busco Lote Recria
                    If Select("Work") > 0
                        Work->( dbCloseArea() )
                    EndIf

                    cQuery := " SELECT TOP 1 ZCN_LOTE, ZCN_DESCLT 
                    cQuery += " FROM " + RetSqlName("ZCN") + " (NOLOCK)
                    cQuery += " WHERE ZCN_FILIAL='"+CT2->CT2_FILORI+"' 
                    cQuery += " AND ZCN_CENTRO='"+CT2->CT2_CCC+"'
                    cQuery += " AND ZCN_STATUS='A'
                    cQuery += " AND D_E_L_E_T_=''
                    cQuery += " ORDER BY R_E_C_N_O_

                    tcQuery cQuery New Alias "Work"

                    Work->( dbGoTop() )
                    If Work->( !EOF() )
                        cCodRecria := Work->ZCN_LOTE
                        cNomRecria := Work->ZCN_DESCLT
                    EndIf

                    If Select("Work") > 0
                        Work->( dbCloseArea() )
                    EndIf

                    // gravo lote na contabilização
                    If !Empty(cCodRecria) .or. !Empty(cNomRecria)
                        RecLock("CT2", .F.)
                            CT2->CT2_XLTXCC := cCodRecria
                            CT2->CT2_XDLXCC := cNomRecria
                        CT2->( msUnLock() )
                    EndIf

                EndIf

                // Débito (PRIORIZAR se diferente)
                If Left(AllTrim(CT2->CT2_CCD),1) == "7"

                    cCodRecria := ""
                    cNomRecria := ""

                    // Busco Lote Recria
                    If Select("Work") > 0
                        Work->( dbCloseArea() )
                    EndIf

                    cQuery := " SELECT TOP 1 ZCN_LOTE, ZCN_DESCLT 
                    cQuery += " FROM " + RetSqlName("ZCN") + " (NOLOCK)
                    cQuery += " WHERE ZCN_FILIAL='"+CT2->CT2_FILORI+"' 
                    cQuery += " AND ZCN_CENTRO='"+CT2->CT2_CCD+"'
                    cQuery += " AND ZCN_STATUS='A'
                    cQuery += " AND D_E_L_E_T_=''
                    cQuery += " ORDER BY R_E_C_N_O_

                    tcQuery cQuery New Alias "Work"

                    Work->( dbGoTop() )
                    If Work->( !EOF() )
                        cCodRecria := Work->ZCN_LOTE
                        cNomRecria := Work->ZCN_DESCLT
                    EndIf

                    If Select("Work") > 0
                        Work->( dbCloseArea() )
                    EndIf

                    // gravo lote na contabilização
                    If !Empty(cCodRecria) .or. !Empty(cNomRecria)
                        RecLock("CT2", .F.)
                            CT2->CT2_XLTXCC := cCodRecria
                            CT2->CT2_XDLXCC := cNomRecria
                        CT2->( msUnLock() )
                    EndIf

                EndIf

            EndIf

            WorkCT2->( dbSkip() )

        EndDo

        If Select("WorkCT2") > 0
            WorkCT2->( dbCloseArea() )
        EndIf

        msgInfo("Lote Recria Folha - Processamento finalizado - AAAAMM Informado: " + cAAAAMM)

    Else

        Alert("Você não clicou no botão CONFIRMAR! Nenhuma ação realizada...")

    EndIf

Return

/*/{Protheus.doc} User Function PutCLVL()
    CLASSE DE VALOR ser preenchido na integração da folha de pagamento para os centros de custo começados em 9 (centros de custo de projeto).
    A informação é utilizada pela controladoria para rateios e cálculo de custo.
    @type  Static Function
    @author FWNM
    @since 15/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history ticket 83824 - 15/02/2023 - Fernando Macieira - Preenchimento classe de valor - dialog
/*/
User Function PutCLVL()

    Local cQuery := ""
    Local cClVl := ""
    Local lOkDlg  	:= .F.
	
	Local oCmpPrj  := Array(01)
	Local oBtnPrj  := Array(02)
	Local cAAAAMM  := Left(DtoS(msDate()),4)+"/"+Subs(DtoS(msDate()),5,2)

	DEFINE MSDIALOG oDlgPrj TITLE "Classe Valor - Folha" FROM 0,0 TO 100,350  OF oMainWnd PIXEL
	
		@ 003, 003 TO 050,165 PIXEL OF oDlgPrj
		
		@ 010,020 Say "Informe AAAA/MM:" of oDlgPrj PIXEL
		@ 005,070 MsGet oCmpPrj Var cAAAAMM SIZE 70,12 of oDlgPrj PIXEL Valid (!Empty(cAAAAMM)) Picture "@E 9999/99"
		
		@ 030,015 BUTTON oBtnPrj[01] PROMPT "Confirma"     of oDlgPrj   SIZE 68,12 PIXEL ACTION (lOkDlg := .t., oDlgPrj:End()) 
		@ 030,089 BUTTON oBtnPrj[02] PROMPT "Cancela"      of oDlgPrj   SIZE 68,12 PIXEL ACTION (lOkDlg := .f., oDlgPrj:End())
		
	ACTIVATE MSDIALOG oDlgPrj CENTERED

    If lOkDlg

        cAAAAMM := StrTran(cAAAAMM,"/","")
        
        If Select("WorkCT2") > 0
            WorkCT2->( dbCloseArea() )
        EndIf

        cQuery := " SELECT R_E_C_N_O_ RECNO
        cQuery += " FROM " + RetSqlName("CT2") + " (NOLOCK)
        cQuery += " WHERE CT2_ORIGEM='CTBI102'
        cQuery += " AND D_E_L_E_T_=''
        cQuery += " AND CT2_DATA LIKE '"+cAAAAMM+"%' 

        tcQuery cQuery new alias "WorkCT2"

        WorkCT2->( dbGoTop() )
        Do While WorkCT2->( !EOF() )

            CT2->( dbGoTo(WorkCT2->RECNO) )

            If AllTrim(CT2->CT2_ORIGEM) == "CTBI102"

                // Regras
                If ( AllTrim(CT2->CT2_CCD) == "9998" .and. AllTrim(CT2->CT2_ITEMD) == "121" ) .or. ( AllTrim(CT2->CT2_CCC) == "9998" .and. AllTrim(CT2->CT2_ITEMC) == "121" )
                    cClVl := "021708003"
                ElseIf ( AllTrim(CT2->CT2_CCD) == "9998" .and. AllTrim(CT2->CT2_ITEMD) == "114" ) .or. ( AllTrim(CT2->CT2_CCC) == "9998" .and. AllTrim(CT2->CT2_ITEMC) == "114" )
                    cClVl := "999999994"
                ElseIf ( AllTrim(CT2->CT2_CCD) == "9612" .and. AllTrim(CT2->CT2_ITEMD) == "114" ) .or. ( AllTrim(CT2->CT2_CCC) == "9612" .and. AllTrim(CT2->CT2_ITEMC) == "114" )
                    cClVl := "999999996"
                EndIf

                // Gravações
                
                //////////////
                // REGRA 01 //
                //////////////

                // Débito
                If AllTrim(CT2->CT2_CCD) == "9998" .and. AllTrim(CT2->CT2_ITEMD) == "121"
                    RecLock("CT2", .F.)
                        CT2->CT2_CLVLDB := cClVl
                    CT2->( msUnLock() )
                EndIf

                // Crédito
                If AllTrim(CT2->CT2_CCC) == "9998" .and. AllTrim(CT2->CT2_ITEMC) == "121"
                    RecLock("CT2", .F.)
                        CT2->CT2_CLVLCR := cClVl
                    CT2->( msUnLock() )
                EndIf

                //////////////
                // REGRA 02 //
                //////////////
                
                // Débito
                If AllTrim(CT2->CT2_CCD) == "9998" .and. AllTrim(CT2->CT2_ITEMD) == "114"
                    RecLock("CT2", .F.)
                        CT2->CT2_CLVLDB := cClVl
                    CT2->( msUnLock() )
                EndIf

                // Crédito
                If AllTrim(CT2->CT2_CCC) == "9998" .and. AllTrim(CT2->CT2_ITEMC) == "114"
                    RecLock("CT2", .F.)
                        CT2->CT2_CLVLCR := cClVl
                    CT2->( msUnLock() )
                EndIf

                //////////////
                // REGRA 03 //
                //////////////
                
                // Débito
                If AllTrim(CT2->CT2_CCD) == "9612" .and. AllTrim(CT2->CT2_ITEMD) == "114"
                    RecLock("CT2", .F.)
                        CT2->CT2_CLVLDB := cClVl
                    CT2->( msUnLock() )
                EndIf

                // Crédito
                If AllTrim(CT2->CT2_CCC) == "9612" .and. AllTrim(CT2->CT2_ITEMC) == "114"
                    RecLock("CT2", .F.)
                        CT2->CT2_CLVLCR := cClVl
                    CT2->( msUnLock() )
                EndIf

            EndIf

            WorkCT2->( dbSkip() )

        EndDo

        If Select("WorkCT2") > 0
            WorkCT2->( dbCloseArea() )
        EndIf

        msgInfo("Classe Valor Folha - Processamento finalizado - AAAAMM Informado: " + cAAAAMM)

    Else

        Alert("Você não clicou no botão CONFIRMAR! Nenhuma ação realizada...")

    EndIf

Return
