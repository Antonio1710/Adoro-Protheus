#include "totvs.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function DPCTB102GR
    PE logo após gravação da CT2
    @type  Function
    @author Fernando Macieira
    @since 28/06/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history ticket 73451 - 28/06/2022 - Fernando Macieira - Validação R33
    @history ticket 73451 - Fernando Macieira - 04/07/2022 - Padronização lote RM
    @history ticket 73451 - 05/07/2022 - Fernando Macieira - Travamento na exclusão do lote manual
    @history ticket 73451 - 13/07/2022 - Fernando Macieira - Publicação
    @history ticket 77295 - 30/08/2022 - Fernando Macieira - A INTEGRAÇÃO DE CONTABILIZAÇÃO DA RM NÃO ESTA FUNCIONANDO
    @history ticket 80939 - 31/10/2022 - Fernando Macieira - Erro na integração contábil do RM => Protheus (apenas quando possui 2 ou + filiais iguais para integrar)
    @history ticket TI    - 30/11/2022 - Fernando Macieira - Erro na integração contábil do RM => Protheus (decimo terceiro)
    @history ticket 83824 - 26/12/2022 - Fernando Macieira - Preenchimento classe de valor na integração da folha de pagamento para os centros de custo começados em 9 (centros de custo de projeto)
    @history ticket 83525 - 26/12/2022 - Fernando Macieira - Integração Folha de Pagamento - Preenchimento do LotexCC
/*/
User Function DPCTB102GR()

    Local lOKDOC  	 := .F.
	Local lSair		 := .F.
    Local oCmpDOC    := Array(01)
	Local oBtnDOC    := Array(02)

    Private nOpcLct  := ParamIxb[1]
    Private dDtLct   := ParamIxb[2]
    Private cLtLct   := ParamIxb[3]
    Private cSbLtLct := ParamIxb[4]
    Private cDocLct  := ParamIxb[5]

    Private cLotMan  := GetMV("MV_#DOCMAN",,"008860")
	Private cNewDOC  := CriaVar("CT2_DOC")

    If GetRpoRelease() >= "12.1.033"

        If (nOpcLct == 3 .or. nOpcLct == 7) .and. AllTrim(cLtLct) $ cLotMan .and. IsInCallStack("CTBA102") .and. AllTrim(FunName()) == "CTBA102"
        
            Do While .t.

                DEFINE MSDIALOG oDlgPrj TITLE "Lançamento manual - Número DOC" FROM 0,0 TO 100,350  OF oMainWnd PIXEL
                
                    @ 003, 003 TO 050,165 PIXEL OF oDlgPrj
                    
                    @ 010,020 Say "Documento:" of oDlgPrj PIXEL
                    @ 005,060 MsGet oCmpDOC Var cNewDOC SIZE 70,12 of oDlgPrj PIXEL Valid !Empty(cNewDOC)
                    
                    @ 030,015 BUTTON oBtnDOC[01] PROMPT "Confirma"     of oDlgPrj   SIZE 68,12 PIXEL ACTION (lOKDOC := .T., oDlgPrj:End()) 
                    @ 030,089 BUTTON oBtnDOC[02] PROMPT "Cancela"      of oDlgPrj   SIZE 68,12 PIXEL ACTION (lSair  := .T., lOKDOC := .F., oDlgPrj:End()) 
                    
                ACTIVATE MSDIALOG oDlgPrj CENTERED

                If lSair
                    If MsgYesNo("Você clicou no botão sair... A nova numeração não será gravada! Tem certeza de que deseja sair sem gravar o novo número de documento?", "Confirmação cancelamento novo número DOC")
                        u_GrLogZBE(msDate(),TIME(),cUserName,"SIG","CONTABILIDADE","CTBA102",;
                        "Usuario clicou no botao SAIR e confirmou NAO GRAVAR o novo numero do documento manual, mantido " + cDocLct + ", informado e ignorado " + cNewDOC, ComputerName(), LogUserName() )
                        Exit
                    Else
                        lSair := .f.
                    EndIf
                EndIf

                If lOKDOC
                    If !Empty(cNewDOC)
                        If Len(AllTrim(cNewDOC)) <> TamSX3("CT2_DOC")[1]
                            lOKDOC := .f.
                            Alert("Número do documento n. " + cNewDoc + " informado precisa ter a mesma quantidade de caracteres do tamanho do campo que é " + AllTrim(Str(TamSX3("CT2_DOC")[1])) + " ! Verifique...")
                        Else
                            If fExistCT2(cNewDOC)
                                lOKDOC := .f.
                                Alert("Número de documento n. " + cNewDoc + " informado já existe nesta data para este lote! Verifique...")
                            Else
                                u_GrLogZBE(msDate(),TIME(),cUserName,"SIG","CONTABILIDADE","CTBA102",;
                                "Usuario CONFIRMOU a gravacao do novo numero do documento manual, de " + cDocLct + " para " + cNewDOC, ComputerName(), LogUserName() )
                                Exit
                            EndIf
                        EndIf
                    Else
                        lOKDOC := .f.
                        Alert("Número de documento obrigatório para lançamentos manuais! Verifique...")
                    EndIf
                EndIf
            
            EndDo

            If lOKDOC
                MsgRun( "Número original " + cDocLct + " pelo novo informado " + cNewDOC,"Alterando...", { || GrvNewDoc(cNewDOC) } )
            EndIf

        EndIf
    
    EndIf

    //@history ticket 73451 - Fernando Macieira - 04/07/2022 - Padronização lote RM
    //FixLtRM() // @history ticket TI    - 30/11/2022 - Fernando Macieira - Erro na integração contábil do RM => Protheus (decimo terceiro)
    //FixLtRM2() // @history ticket TI    - 30/11/2022 - Fernando Macieira - Erro na integração contábil do RM => Protheus (decimo terceiro)

    // @history ticket 83824 - 26/12/2022 - Fernando Macieira - Preenchimento classe de valor na integração da folha de pagamento para os centros de custo começados em 9 (centros de custo de projeto)
    PutCLVL()
    
    // @history ticket 83525 - 26/12/2022 - Fernando Macieira - Integração Folha de Pagamento - Preenchimento do LotexCC
    PutZCN()
    
Return

/*/{Protheus.doc} Grava novo numero DOC para lançamentos manuais
    DANIELLE PINHEIRO MEIRA
    15/06/2022 17:21
    Macieira,
    Conforme falamos, seguiremos da forma proposta.
    NO SIG, na inclusão/copia de lançamentos do lote 999999 o sistema abrirá uma “tela” para preenchimento do número do documento com 6 dígitos.
    Na produção, na inclusão/copia de lançamentos do lote 008860 o sistema abrirá uma “tela” para preenchimento do número do documento com 6 dígitos.
    @type  Static Function
    @author FWNM
    @since 27/06/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GrvNewDoc(cNewDOC)

    Local aArea    := GetArea()
    Local aAreaCT2 := CT2->( GetArea() )
    Local aAreaCTF := CTF->( GetArea() )
    Local cQuery   := ""
    Local lMsg     := .f.
    Local lLockCTF := .t.

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

    cQuery := " SELECT R_E_C_N_O_ RECNO
    cQuery += " FROM " + RetSqlName("CT2") + " (NOLOCK)
    cQuery += " WHERE CT2_FILIAL='"+CT2->CT2_FILIAL+"'
    cQuery += " AND CT2_DATA='"+DtoS(dDtLct)+"'
    cQuery += " AND CT2_LOTE='"+cLtLct+"'
    cQuery += " AND CT2_SBLOTE='"+cSbLtLct+"'
    cQuery += " AND CT2_DOC='"+cDocLct+"'
    cQuery += " AND D_E_L_E_T_=''

    tcQuery cQuery New Alias "Work"

    Begin Transaction

        Work->( dbGoTop() )
        Do While Work->( !EOF() )

            CT2->( dbGoTo(Work->RECNO) )

            u_GrLogZBE(msDate(),TIME(),cUserName,"SIG","CONTABILIDADE","CTBA102",;
            "NOVO NUMERO, ORIGINAL " + cDocLct + " NOVO " + cNewDOC + " - DT/LOTE " + DtoC(CT2->CT2_DATA)+"/"+CT2->CT2_LOTE, ComputerName(), LogUserName() )

            RecLock("CT2", .F.)
                CT2->CT2_DOC := cNewDOC
            CT2->( msUnLock() )

            lMsg     := .t.

            Work->( dbSkip() )

        EndDo

        // @history ticket 73451 - 05/07/2022 - Fernando Macieira - Travamento na exclusão do lote manual
        If lMsg

            CTF->( DbSetOrder(1) ) // CTF_FILIAL, CTF_DATA, CTF_LOTE, CTF_SBLOTE, CTF_DOC, R_E_C_N_O_, D_E_L_E_T_
            If CTF->( dbSeek(FWxFilial("CTF")+DtoS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+cDocLct) )
                
                RecLock("CTF", .F.)
                    CTF->CTF_DOC := cNewDOC
                CTF->( msUnLock() )
            
            Else

                lLockCTF := .t.
                CTF->( DbSetOrder(1) ) // CTF_FILIAL, CTF_DATA, CTF_LOTE, CTF_SBLOTE, CTF_DOC, R_E_C_N_O_, D_E_L_E_T_
                If CTF->( dbSeek(FWxFilial("CTF")+DtoS(CT2->CT2_DATA)+CT2->CT2_LOTE+CT2->CT2_SBLOTE+cNewDOC) )
                    lLockCTF := .f.
                EndIf

                RecLock("CTF", lLockCTF)
                    CTF->CTF_FILIAL := FWxFilial("CTF")
                    CTF->CTF_DATA   := CT2->CT2_DATA
                    CTF->CTF_LOTE   := CT2->CT2_LOTE
                    CTF->CTF_SBLOTE := CT2->CT2_SBLOTE
                    CTF->CTF_DOC    := cNewDOC
                    CTF->CTF_USADO  := "S"
                CTF->( msUnLock() )

            EndIf
            //

        EndIf

    End Transaction

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

    If lMsg
        MsgInfo("Número do documento manual alterado com sucesso!" + chr(13)+chr(10)+;
            "Data: " + DtoC(dDtLct) + chr(13)+chr(10)+;
            "Lote: " + cLtLct + chr(13)+chr(10)+;
            "SubLote: " + cSbLtLct + chr(13)+chr(10)+;
            "Documento Original: " + cDocLct, "Novo n. documento: " + cNewDOC)
    EndIf

    RestArea( aArea )
    RestArea( aAreaCT2 )
    RestArea( aAreaCTF )

Return

/*/{Protheus.doc} nomeStaticFunction fExistCT2()
    Checa se o número informado já existe na base na mesma data e no mesmo lote manual
    @type  Static Function
    @author FWNM
    @since 27/06/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fExistCT2(cNewDOC)

    Local aArea  := GetArea()
    Local lRet   := .f.
    Local cQuery := ""

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

    cQuery := " SELECT R_E_C_N_O_ RECNO
    cQuery += " FROM " + RetSqlName("CT2") + " (NOLOCK)
    cQuery += " WHERE CT2_FILIAL='"+CT2->CT2_FILIAL+"'
    cQuery += " AND CT2_DATA='"+DtoS(dDtLct)+"'
    cQuery += " AND CT2_LOTE='"+cLotMan+"'
    cQuery += " AND CT2_SBLOTE='"+cSbLtLct+"'
    cQuery += " AND CT2_DOC='"+cNewDOC+"'
    cQuery += " AND D_E_L_E_T_=''

    tcQuery cQuery New Alias "Work"

    Work->( dbGoTop() )
    If Work->( !EOF() )
        lRet := .t.
        u_GrLogZBE(msDate(),TIME(),cUserName,"SIG","CONTABILIDADE","CTBA102",;
        "NUMERO do documento manual informado já existe na base nesta data com o mesmo lote " + cNewDOC, ComputerName(), LogUserName() )
    EndIf

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

    RestArea( aArea )
    
Return lRet

/*/{Protheus.doc} nomeStaticFunction
    Padroniza lote vindo do RM
    @type  Static Function
    @author FWNM
    @since 30/06/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FixLtRM()

    Local aArea    := GetArea()
    Local aAreaCT2 := CT2->( GetArea() )
    Local aAreaCTF := CTF->( GetArea() )
    Local cQuery   := ""
    Local cLtFolha := GetMV("MV_#LOTERM",,"008890")
    Local lCTF     := .f.
    Local lLockCTF := .t.

    If AllTrim(CT2->CT2_ORIGEM) == "CTBI102"

        If Select("Work") > 0
            Work->( dbCloseArea() )
        EndIf

        cQuery := " SELECT R_E_C_N_O_ RECNO
        cQuery += " FROM " + RetSqlName("CT2") + " (NOLOCK)
        cQuery += " WHERE CT2_FILIAL='"+FWxFilial("CT2")+"'
        cQuery += " AND CT2_DATA='"+DtoS(dDtLct)+"'
        cQuery += " AND CT2_LOTE='"+cLtLct+"'
        cQuery += " AND CT2_SBLOTE='"+cSbLtLct+"'
        cQuery += " AND CT2_DOC='"+cDocLct+"'
        cQuery += " AND D_E_L_E_T_=''

        tcQuery cQuery New Alias "Work"

        Begin Transaction

            Work->( dbGoTop() )
            Do While Work->( !EOF() )

                CT2->( dbGoTo(Work->RECNO) )

                If CT2->CT2_LOTE <> cLtFolha

                    u_GrLogZBE(msDate(),TIME(),cUserName,"FOLHA","CONTABILIDADE","DPCTB102GR",;
                    "LOTE RM, ORIGINAL " + cLtLct + " NOVO " + cLtFolha + " - DT/DOC " + DtoC(CT2->CT2_DATA)+"/"+CT2->CT2_DOC, ComputerName(), LogUserName() )

                    RecLock("CT2", .F.)
                        CT2->CT2_LOTE := cLtFolha
                    CT2->( msUnLock() )

                    lCTF     := .t.

                EndIf

                Work->( dbSkip() )

            EndDo

            // @history ticket 80939 - 31/10/2022 - Fernando Macieira - Erro na integração contábil do RM => Protheus (apenas quando possui 2 ou + filiais iguais para integrar)
            If lCTF

                // Digo ao Protheus que essa numeraçaõ foi usada para garantir que o número do documento da próxima integração gere um sequencial
                CTF->( DbSetOrder(1) ) // CTF_FILIAL, CTF_DATA, CTF_LOTE, CTF_SBLOTE, CTF_DOC, R_E_C_N_O_, D_E_L_E_T_
                If CTF->( dbSeek(FWxFilial("CTF")+DtoS(dDtLct)+cLtLct+cSbLtLct+cDocLct) )

                    RecLock("CTF", .f.)
                        CTF->CTF_USADO  := "S"
                    CTF->( msUnLock() )

                    u_GrLogZBE(msDate(),TIME(),cUserName,"FOLHA","CONTABILIDADE","DPCTB102GR",;
                    "ALTEROU CTF LOTE ORIGINAL " + cLtLct + " PARA PROXIMA CONTABILIZACAO PEGAR DOC SEQUENCIAL", ComputerName(), LogUserName() )

                EndIf

                // Incluo o sequencial do lote alterado 008890 para que o próximo seja 000002
                lLockCTF := .t.

                CTF->( DbSetOrder(1) ) // CTF_FILIAL, CTF_DATA, CTF_LOTE, CTF_SBLOTE, CTF_DOC, R_E_C_N_O_, D_E_L_E_T_
                If CTF->( dbSeek(FWxFilial("CTF")+DtoS(CT2->CT2_DATA)+cLtFolha+CT2->CT2_SBLOTE+CT2->CT2_DOC) )
                    lLockCTF := .f.
                EndIf

                RecLock("CTF", lLockCTF)
                    CTF->CTF_FILIAL := FWxFilial("CTF")
                    CTF->CTF_DATA   := CT2->CT2_DATA
                    CTF->CTF_LOTE   := cLtFolha
                    CTF->CTF_SBLOTE := CT2->CT2_SBLOTE
                    CTF->CTF_DOC    := CT2->CT2_DOC
                    CTF->CTF_USADO  := "S"
                CTF->( msUnLock() )

                u_GrLogZBE(msDate(),TIME(),cUserName,"FOLHA","CONTABILIDADE","DPCTB102GR",;
                "INCLUIU CTF LOTE " + cLtFolha + " PARA PROXIMA CONTABILIZACAO PEGAR DOC SEQUENCIAL", ComputerName(), LogUserName() )

            EndIf

        End Transaction

    EndIf

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

    RestArea( aArea )
    RestArea( aAreaCT2 )
    RestArea( aAreaCTF )

Return

/*/{Protheus.doc} nomeStaticFunction
    Padroniza lote vindo do RM
    @type  Static Function
    @author FWNM
    @since 30/11/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function FixLtRM2()

    Local aArea    := GetArea()
    Local aAreaCT2 := CT2->( GetArea() )
    Local aAreaCTF := CTF->( GetArea() )
    Local cQuery   := ""
    Local cLtFolha := GetMV("MV_#LOTERM",,"008890")
    Local lCTF     := .f.
    Local lLockCTF := .t.
    Local cNextDoc := ""

    If AllTrim(CT2->CT2_ORIGEM) == "CTBI102"

        cNextDoc := getNextDoc()
        
        // Altero lote contábil para padrão Protheus (RM é sequencial)
        If Select("Work") > 0
            Work->( dbCloseArea() )
        EndIf

        cQuery := " SELECT R_E_C_N_O_ RECNO
        cQuery += " FROM " + RetSqlName("CT2") + " (NOLOCK)
        cQuery += " WHERE CT2_FILIAL='"+FWxFilial("CT2")+"'
        cQuery += " AND CT2_DATA='"+DtoS(dDtLct)+"'
        cQuery += " AND CT2_LOTE='"+cLtLct+"'
        cQuery += " AND CT2_SBLOTE='"+cSbLtLct+"'
        cQuery += " AND CT2_DOC='"+cDocLct+"'
        cQuery += " AND D_E_L_E_T_=''

        tcQuery cQuery New Alias "Work"

        Begin Transaction

            Work->( dbGoTop() )
            Do While Work->( !EOF() )

                CT2->( dbGoTo(Work->RECNO) )

                If CT2->CT2_LOTE <> cLtFolha

                    u_GrLogZBE(msDate(),TIME(),cUserName,"FOLHA","CONTABILIDADE","DPCTB102GR",;
                    "1 - LOTE RM, ORIGINAL " + cLtLct + " NOVO " + cLtFolha + " - DT/DOC/LINHA " + DtoC(CT2->CT2_DATA)+"/"+CT2->CT2_DOC+"/"+CT2->CT2_LINHA, ComputerName(), LogUserName() )

                    // Documento sequencial do lote 008890
                    RecLock("CT2", .F.)
                        CT2->CT2_DOC  := cNextDoc
                    CT2->( msUnLock() )

                    // Lote padrão Protheus folha
                    RecLock("CT2", .F.)
                        CT2->CT2_LOTE := cLtFolha
                    CT2->( msUnLock() )

                    lCTF     := .t.

                EndIf

                Work->( dbSkip() )

            EndDo

            If lCTF

                /////////////////////////////
                // sequencial lote Protheus
                /////////////////////////////
                // Digo ao Protheus que essa numeraçaõ foi usada para garantir que o número do documento da próxima integração gere um sequencial
                CTF->( DbSetOrder(1) ) // CTF_FILIAL, CTF_DATA, CTF_LOTE, CTF_SBLOTE, CTF_DOC, R_E_C_N_O_, D_E_L_E_T_
                If CTF->( dbSeek(FWxFilial("CTF")+DtoS(dDtLct)+cLtLct+cSbLtLct+cDocLct) )

                    RecLock("CTF", .f.)
                        CTF->CTF_USADO  := "S"
                    CTF->( msUnLock() )

                    u_GrLogZBE(msDate(),TIME(),cUserName,"FOLHA","CONTABILIDADE","DPCTB102GR",;
                    "2 - ALTEROU CTF LOTE ORIGINAL " + cLtLct + " PARA PROXIMA CONTABILIZACAO PEGAR DOC SEQUENCIAL", ComputerName(), LogUserName() )

                EndIf

                // Incluo o sequencial do lote alterado 008890 para que o próximo seja 000002
                lLockCTF := .t.

                CTF->( DbSetOrder(1) ) // CTF_FILIAL, CTF_DATA, CTF_LOTE, CTF_SBLOTE, CTF_DOC, R_E_C_N_O_, D_E_L_E_T_
                If CTF->( dbSeek(FWxFilial("CTF")+DtoS(CT2->CT2_DATA)+cLtFolha+CT2->CT2_SBLOTE+CT2->CT2_DOC) )
                    lLockCTF := .f.
                EndIf

                RecLock("CTF", lLockCTF)
                    CTF->CTF_FILIAL := FWxFilial("CTF")
                    CTF->CTF_DATA   := CT2->CT2_DATA
                    CTF->CTF_LOTE   := cLtFolha
                    CTF->CTF_SBLOTE := CT2->CT2_SBLOTE
                    CTF->CTF_DOC    := CT2->CT2_DOC
                    CTF->CTF_USADO  := "S"
                CTF->( msUnLock() )

                u_GrLogZBE(msDate(),TIME(),cUserName,"FOLHA","CONTABILIDADE","DPCTB102GR",;
                "3 - INCLUIU CTF LOTE " + cLtFolha + " PARA PROXIMA CONTABILIZACAO PEGAR DOC SEQUENCIAL", ComputerName(), LogUserName() )


                ///////////////////////
                // sequencial lote RM
                ///////////////////////
                // Digo ao Protheus que essa numeraçaõ foi usada para garantir que o número do documento da próxima integração gere um sequencial
                CTF->( DbSetOrder(1) ) // CTF_FILIAL, CTF_DATA, CTF_LOTE, CTF_SBLOTE, CTF_DOC, R_E_C_N_O_, D_E_L_E_T_
                If CTF->( dbSeek(FWxFilial("CTF")+DtoS(dDtLct)+cLtFolha+cSbLtLct+cNextDoc) )

                    RecLock("CTF", .f.)
                        CTF->CTF_USADO  := "S"
                    CTF->( msUnLock() )

                    u_GrLogZBE(msDate(),TIME(),cUserName,"FOLHA","CONTABILIDADE","DPCTB102GR",;
                    "4 - ALTEROU CTF LOTE ORIGINAL " + cLtLct + " PARA PROXIMA CONTABILIZACAO PEGAR DOC SEQUENCIAL", ComputerName(), LogUserName() )

                EndIf

                // Incluo o sequencial do lote alterado 008890 para que o próximo seja 000002
                lLockCTF := .t.

                CTF->( DbSetOrder(1) ) // CTF_FILIAL, CTF_DATA, CTF_LOTE, CTF_SBLOTE, CTF_DOC, R_E_C_N_O_, D_E_L_E_T_
                If CTF->( dbSeek(FWxFilial("CTF")+DtoS(CT2->CT2_DATA)+cLtFolha+CT2->CT2_SBLOTE+CT2->CT2_DOC) )
                    lLockCTF := .f.
                EndIf

                RecLock("CTF", lLockCTF)
                    CTF->CTF_FILIAL := FWxFilial("CTF")
                    CTF->CTF_DATA   := CT2->CT2_DATA
                    CTF->CTF_LOTE   := cLtFolha
                    CTF->CTF_SBLOTE := CT2->CT2_SBLOTE
                    CTF->CTF_DOC    := CT2->CT2_DOC
                    CTF->CTF_USADO  := "S"
                CTF->( msUnLock() )

                u_GrLogZBE(msDate(),TIME(),cUserName,"FOLHA","CONTABILIDADE","DPCTB102GR",;
                "5- INCLUIU CTF LOTE " + cLtFolha + " PARA PROXIMA CONTABILIZACAO PEGAR DOC SEQUENCIAL", ComputerName(), LogUserName() )

            EndIf

        End Transaction

    EndIf

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

    RestArea( aArea )
    RestArea( aAreaCT2 )
    RestArea( aAreaCTF )

Return


/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author FWNM
    @since 30/11/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function getNextDoc()

    Local cNextDoc := "000001"
    Local aAreaCT2 := CT2->( GetArea() )

    Do While .t.
    
        // Pego o próximo documento do lote 008890
        If Select("Work") > 0
            Work->( dbCloseArea() )
        EndIf

        cQuery := " SELECT ISNULL(MAX(CT2_DOC),'000000') AS NEXT_DOC
        cQuery += " FROM " + RetSqlName("CT2") + " (NOLOCK)
        cQuery += " WHERE CT2_FILIAL='"+FWxFilial("CT2")+"'
        cQuery += " AND CT2_DATA='"+DtoS(dDtLct)+"'
        cQuery += " AND CT2_LOTE='"+cLtLct+"'
        cQuery += " AND CT2_SBLOTE='"+cSbLtLct+"'
        cQuery += " AND D_E_L_E_T_=''

        tcQuery cQuery New Alias "Work"

        Work->( dbGoTop() )
        If Work->( !EOF() )
            cNextDoc := Soma1(AllTrim(Work->NEXT_DOC))
        EndIf

        CT2->( dbSetOrder(1) )
        If CT2->( dbSeek(FWxFilial("CT2")+DtoS(dDtLct)+cLtLct+cSbLtLct+cNextDoc) )
            cNextDoc := Soma1(AllTrim(CT2->CT2_DOC))
        Else
            Exit
        EndIf

    EndDo

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

    RestArea( aAreaCT2 )
    
Return cNextDoc

/*/{Protheus.doc} Static Function PutCLVL()
    CLASSE DE VALOR ser preenchido na integração da folha de pagamento para os centros de custo começados em 9 (centros de custo de projeto).
    A informação é utilizada pela controladoria para rateios e cálculo de custo.
    @type  Static Function
    @author FWNM
    @since 26/12/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    ticket 83824 - 26/12/2022 - Fernando Macieira - Preenchimento classe de valor na integração da folha de pagamento para os centros de custo começados em 9 (centros de custo de projeto)
/*/
Static Function PutCLVL()

    Local cClVl := ""
    
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

Return

/*/{Protheus.doc} Static Function PutZCN()
    Os lançamentos de despesa dos centros de custo 7(centros de custo das granjas) vem com o campo Lote x CC preenchido com o lote da granja.
    Essa informação serve para fazer o rateio do custo dos ovos.
    Agora que a folha de pagamento das granjas serão despesa da Adoro, nós precisamos que essa informação suba na contabilização da folha também.
    @type  Static Function
    @author FWNM
    @since 26/12/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @ticket 83525 - 26/12/2022 - Fernando Macieira - Integração Folha de Pagamento - Preenchimento do LotexCC
/*/
Static Function PutZCN()

    Local cQuery := ""
    Local cCodRecria := ""
    Local cNomRecria := ""

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

Return
