#include "rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} User Function ADEST034P
    Gera lote de producao por integra��o do SAG.
    @type  Function
    @author Ricado Lima
    @since 01/11/2018
    @version 01
    @history Ricardo Lima-CHAMADO:037647-03/01/2019-ajuste na query
    @history Adriana - CHAMADO TI-27/05/2019: Corre�ao error.log expected N->C,function STR on U_ADEST034P
    @history Leon Toledo - CHAMADO 051560 - 09/09/2019: Criada valida��o para Codigo e Descri��o antes da 
    integra��o do Lote do SAG no Protheus.
    @history Everson  - Chamado 058675 - 23/06/2020. Adicionado tratamento para importa��o de lotes para mais de uma empresa/filial no Protheus.
    @history Everson  - Chamado 059658 - 30/07/2020. Tratamento para n�o importar lote sem data.
    @history Everson  - Chamado 7989   - 13/01/2021. Inclu�do tratamento por filial.
	@history Sigoli	  - Tkt: 17876     - 04/08/2021. Feito tratamento na rotina para atender todas as empresa configuradas no scheduled 
    @hostory Sigoli   - TKT: T.I       - Removido log , pois esta gerando muito log nos scheduledsRemovido log , pois esta gerando muito log nos scheduleds
    @history Macieira - ticket 67703   - 04/02/2022 - Cadastro de Lote - Lote Recria x Ccusto.
    @history Macieira - ticket 67703   - 07/02/2022 - Cadastro de Lote - Lote Recria x Ccusto.
    @history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
    @history Ticket 85733 - 28/12/2022 - Fernando Macieira - OPERA��O NOVA MATRIZES - CADASTRO DE LOTES ADFAT008P
    @history Ticket 89304 - 02/03/2023 - Fernando Macieira - Complemento do Ticket 85733 (OPERA��O NOVA MATRIZES - CADASTRO DE LOTES ADFAT008P)
    @history Ticket 90781 - 30/03/2023 - Jonathan Carvalho - Inclus�o de rotina para alimentar todas as Granjas nas filiais ADM 03|0S
    @history Ticket 89304 - 29/03/2023 - Fernando Macieira - Complemento do Ticket 85733 (OPERA��O NOVA MATRIZES - CADASTRO DE LOTES ADFAT008P)
    @history Ticket 89304 - 10/04/2023 - Jonathan Carvalho - Retirado fun��o de altera��o do Fonte.
    @history Ticket 92727 - 08/05/2023 - Jonathan Carvalho - Incluido novamente a fun��o de altera��o porem n�o vai alterar o STATUS do LOTE 
/*/
User Function ADEST034P(aParam)

    Local lAutoJob  := .F.
    Local cEmpRun   := "01"
    Local cFilRun   := ""
    Local aEmpresas := {}
    Local aDadSM0   := {}
    Local i, y

    Default aParam    := Array(2)
	Default aParam[1] := "01"
	Default aParam[2] := "03"

    If Select("SX6") == 0
	    lAutoJob := .T.
    EndIf

    If lAutoJob

        RpcClearEnv()
        RpcSetType(3)
        RpcSetEnv(aParam[1],aParam[2],,,,GetEnvServer(),{ }) 

        //	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
        //FWMonitorMsg(ALLTRIM(PROCNAME()))

        // @history Ticket 85733 - 28/12/2022 - Fernando Macieira - OPERA��O NOVA MATRIZES - CADASTRO DE LOTES ADFAT008P
        cEmpRun := GetMV("MV_#ZCNEMP",,"01")
        cFilRun := GetMV("MV_#ZCNFIL",,"03|04|0C|0D|0E|0F|0G|0H|0I|0J|0K|0L|0M|0N|0O|0P|0Q|0R|0S")

        // Carrega Empresas para processamentos
        aDadSM0  := FWLoadSM0()
        For y:=1 to Len(aDadSM0)
            If (aDadSM0[y,1] $ cEmpRun) .and. (aDadSM0[y,2] $ cFilRun)
                aAdd(aEmpresas, { aDadSM0[y,1], aDadSM0[y,2] } )
            EndIf
        Next y

        // Processa empresas
        For i:=1 to Len(aEmpresas)

            RpcClearEnv()
            RpcSetType(3)
            RpcSetEnv( aEmpresas[ i,1 ] , aEmpresas[ i,2 ] )

            Conout( DToC(Date()) + " " + Time() + " ADEST034P - In�cio Job de importa��o de lotes de cria��o do SAG. Emp/Fil " + cEmpAnt + "/" + cFilAnt )
            logZBN("1","ADEST034P")
                procRot() //Everson - Chamado 058675 -23/06/2020.
            logZBN("2","ADEST034P")
            Conout( DToC(Date()) + " " + Time() + " ADEST034P - Fim Job de importa��o de lotes de cria��o do SAG. Emp/Fil " + cEmpAnt + "/" + cFilAnt )

        Next i
        //

    EndIf

Return Nil  

/*/{Protheus.doc} procRot
    Processa rotina dos lotes de cria��o SAG. Chamado 058675.
    **** Fun��o tamb�m executada via Static Call no fonte ADEST048P ***
    @type  Static Function
    @author Everson.
    @since 23/06/2020
    @version 01
    /*/
Static Function procRot()

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Gera lote de producao por integra��o do SAG')

    // Garanto uma �nica thread sendo executada - // Adoro - Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - fwnm - 30/06/2020
    If !LockByName("EST034P"+AllTrim(cEmpAnt)+AllTrim(cFilAnt), .T., .F.)
        ConOut("[ADEST034P] - Existe outro processamento sendo executado! Verifique...")
        RPCClearEnv()
        Return
    EndIf

    //
    incluiLt()

    //Ticket 90781 - Jonathan Carvalho 30/03/2023
    incluiLt2()

    alteraLt()

    //
    deleteLt()

    UnLockByName("EST034P"+AllTrim(cEmpAnt)+AllTrim(cFilAnt))

Return Nil 

/*/{Protheus.doc} incluiLt
    Processa importa��es de inclus�es de lotes de cria��o SAG.
    @type  Static Function
    @author Ricardo Lima.
    @since 01/11/2018
    @version 01
    /*/
Static Function incluiLt()

    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cFilGranj := GetMV("MV_#ZCNFIL",,"03|04|0C|0D|0E|0F|0G|0H|0I|0J|0K|0L|0M|0N|0O|0P|0Q|0R|0S") //GetMV("MV_#ZCNGRJ",,"0C|0D|0E|0F|0G|0H|0I|0J|0K|0L|0M|0N|0O|0P|0Q|0R") // @history Ticket 89304 - 02/03/2023 - Fernando Macieira - Complemento do Ticket 85733 (OPERA��O NOVA MATRIZES - CADASTRO DE LOTES ADFAT008P)

    //
    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - incluiLt - In�cio importa��o de inclus�es.")

    //Integra lote do SAG no Protheus.
    cQuery := sqlInLot()

    //
    If Select("ADEST34I") > 0
        ADEST34I->(DbCloseArea())
    EndIf

    //
    TcQuery cQuery New Alias "ADEST34I"

    DbSelectArea("ZCN")
    ZCN->(DbSetOrder(1)) //1 ZCN_FILIAL , ZCN_LOTE 
    While ADEST34I->(!Eof())

        // @history Ticket 85733 - 28/12/2022 - Fernando Macieira - OPERA��O NOVA MATRIZES - CADASTRO DE LOTES ADFAT008P
        lInc := .t.
        If AllTrim(FWCodEmp()) == "01" .and. AllTrim(FWCodFil()) $ cFilGranj

            lInc := .f.
            
            If Select("WorkX5") > 0
                WorkX5->( dbCloseArea() )
            EndIf

            cQueryX5 := " SELECT X5_CHAVE
            cQueryX5 += " FROM " + RetSqlName("SX5") + " (NOLOCK) 
            cQueryX5 += " WHERE X5_FILIAL='"+FWxFilial("SX5")+"' "
            cQueryX5 += " AND X5_TABELA='_L' 
            cQueryX5 += " AND D_E_L_E_T_=''

            tcQuery cQueryX5 New Alias "WorkX5"

            WorkX5->( dbGoTop() )
            Do While WorkX5->( !EOF() )

                If Upper(AllTrim(WorkX5->X5_CHAVE)) $ Upper(AllTrim(ADEST34I->NOMELOTE))
                    lInc := .t.
                    Exit
                EndIf

                WorkX5->( dbSkip() )
                
            EndDo

            If Select("WorkX5") > 0
                WorkX5->( dbCloseArea() )
            EndIf

        EndIf
        
        If lInc

            If (!Empty(ADEST34I->CODILOTE) .OR. (!Empty(ADEST34I->NOMELOTE)))    //Leon Toledo | 09/09/2019 | Chamado: 051560
                ZCN->(dbGoTop())
                If ZCN->(DbSeek( FWxFilial("ZCN") + Alltrim(Str(ADEST34I->CODILOTE)) ))
                    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - incluiLt - Lote: " + cValToChar(ADEST34I->CODILOTE) + " j� integrado, registro ignorado.")
                Else
                    RecLock("ZCN",.T.)
                        ZCN->ZCN_FILIAL := FWxFilial("ZCN")
                        ZCN->ZCN_LOTE   := Alltrim(Str(ADEST34I->CODILOTE))
                        ZCN->ZCN_DESCLT := ADEST34I->NOMELOTE
                        ZCN->ZCN_TIPO   := IIF(ADEST34I->RECRLOTE=1,'RECRIA','PRODUCAO')
                        ZCN->ZCN_CENTRO := ''
                        ZCN->ZCN_DESCCC := ''
                        ZCN->ZCN_DATLOT := ADEST34I->DATALOTE
                        ZCN->ZCN_STATUS := IIF(Empty(ADEST34I->ENCELOTE),'A','E')
                    ZCN->( Msunlock() )

                    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - incluiLt - Lote: " + cValToChar(ADEST34I->CODILOTE) + " integrado com sucesso.")
                EndIf

            Else
                
                ConOut( DToC(Date()) + " " + Time() + " ADEST034P - incluiLt - Lote: " + cValToChar(ADEST34I->CODILOTE) + " incompleto (c�digo ou descri��o).")

            EndIf

        EndIf

        //
        ADEST34I->(DbSkip())

    End

    //
    ADEST34I->(DbCloseArea())

    //
    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - incluiLt - Fim importa��o de inclus�es.")

    //
    RestArea(aArea)

Return Nil 

/*/{Protheus.doc} incluiLt2
    Processa importa��es de inclus�es de lotes para Filial ADM
    @type  Static Function
    @author Jonathan Carvalho.
    @since 30/03/2023
    @version 01
    /*/
Static Function incluiLt2()

    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cFilGranj := GetMV("MV_#ZCNFI2",,"03|0S") 

    //
    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - incluiLt - In�cio importa��o de inclus�es.")

    //Integra lote do SAG no Protheus.
    cQuery := sqlInLot()

    //
    If Select("ADEST34I") > 0
        ADEST34I->(DbCloseArea())
    EndIf

    //
    TcQuery cQuery New Alias "ADEST34I"

    DbSelectArea("ZCN")
    ZCN->(DbSetOrder(1)) //1 ZCN_FILIAL , ZCN_LOTE 
    While ADEST34I->(!Eof())

        lInc := .F.

        If AllTrim(FWCodEmp()) == "01" .and. AllTrim(FWCodFil()) $ cFilGranj

            If Select("WorkX5") > 0
                WorkX5->( dbCloseArea() )
            EndIf

            cQueryX5 := " SELECT X5_CHAVE
            cQueryX5 += " FROM " + RetSqlName("SX5") + " (NOLOCK) 
            cQueryX5 += " WHERE X5_TABELA='_L' "
            cQueryX5 += " AND D_E_L_E_T_=''

            tcQuery cQueryX5 New Alias "WorkX5"

            WorkX5->( dbGoTop() )
            Do While WorkX5->( !EOF() )

                If Upper(AllTrim(WorkX5->X5_CHAVE)) $ Upper(AllTrim(ADEST34I->NOMELOTE))
                    lInc := .t.
                    Exit
                EndIf

                WorkX5->( dbSkip() )
                
            EndDo

            If Select("WorkX5") > 0
                WorkX5->( dbCloseArea() )
            EndIf
        Else
            //Se n�o for a filial ADM pula
            Exit

        EndIf
        
        If lInc

            If (!Empty(ADEST34I->CODILOTE) .OR. (!Empty(ADEST34I->NOMELOTE)))   
                ZCN->(dbGoTop())
                If ZCN->(DbSeek( FWxFilial("ZCN") + Alltrim(Str(ADEST34I->CODILOTE)) ))
                    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - incluiLt - Lote: " + cValToChar(ADEST34I->CODILOTE) + " j� integrado, registro ignorado.")
                Else
                    RecLock("ZCN",.T.)
                        ZCN->ZCN_FILIAL := FWxFilial("ZCN")
                        ZCN->ZCN_LOTE   := Alltrim(Str(ADEST34I->CODILOTE))
                        ZCN->ZCN_DESCLT := ADEST34I->NOMELOTE
                        ZCN->ZCN_TIPO   := IIF(ADEST34I->RECRLOTE=1,'RECRIA','PRODUCAO')
                        ZCN->ZCN_CENTRO := ''
                        ZCN->ZCN_DESCCC := ''
                        ZCN->ZCN_DATLOT := ADEST34I->DATALOTE
                        ZCN->ZCN_STATUS := IIF(Empty(ADEST34I->ENCELOTE),'A','E')
                    ZCN->( Msunlock() )

                    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - incluiLt - Lote: " + cValToChar(ADEST34I->CODILOTE) + " integrado com sucesso.")
                EndIf

            Else
                
                ConOut( DToC(Date()) + " " + Time() + " ADEST034P - incluiLt - Lote: " + cValToChar(ADEST34I->CODILOTE) + " incompleto (c�digo ou descri��o).")

            EndIf

        EndIf

        //
        ADEST34I->(DbSkip())

    End

    //
    ADEST34I->(DbCloseArea())

    //
    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - incluiLt - Fim importa��o de inclus�es.")

    //
    RestArea(aArea)

Return Nil 

/*/{Protheus.doc} alteraLt
    Processa importa��es de altera��es de lotes de cria��o SAG.
    @type  Static Function
    @author Ricardo Lima.
    @since 01/11/2018
    @version 01
    /*/
Static Function alteraLt()

    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cDataIni  := GetMv("MV_#ADE331" , .F. , "01/01/2019")
    //Local cZCNStatus := ""

    //
    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - alteraLt - In�cio importa��o de altera��es.")

    // Integracao para Atualizar Lote no Protheus que foram Alterado no SAG
    cQuery := sqlAlLot(cDataIni)

    //
    If Select("ADEST34A") > 0
        ADEST34A->(DbCloseArea())
    EndIf

    //
    TcQuery cQuery New Alias "ADEST34A"

    While ADEST34A->(!Eof())
        DbSelectArea("ZCN")
        ZCN->(DbSetOrder(1))
        IF ZCN->(DbSeek( FWxFilial("ZCN") + Alltrim(Str(ADEST34A->CODILOTE)) ))
            
            // @history Ticket 89304 - 29/03/2023 - Fernando Macieira - Complemento do Ticket 85733 (OPERA��O NOVA MATRIZES - CADASTRO DE LOTES ADFAT008P)
            // @history Macieira - ticket 67703   - 04/02/2022 - Cadastro de Lote - Lote Recria x Ccusto
            /* @history Jonathan - ticket 92727  - 08/05/2023 - N�o alterar o status do lote. 
            If Empty(ADEST34A->ENCELOTE)
                cZCNStatus := "A"
            Else
                cZCNStatus := "E"
            EndIf
            */

            RecLock("ZCN",.F.)
                ZCN->ZCN_DESCLT := ADEST34A->NOMELOTE
                ZCN->ZCN_TIPO   := IIF(ADEST34A->RECRLOTE=1,'RECRIA','PRODUCAO')
                ZCN->ZCN_DATCAN := ADEST34A->ENCELOTE
                ZCN->ZCN_LOGUPD := Alltrim(Str(ADEST34A->CODILOG_))
                //ZCN->ZCN_STATUS := cZCNStatus // @history Macieira - ticket 67703   - 04/02/2022 - Cadastro de Lote - Lote Recria x Ccusto.
                //ZCN->ZCN_STATUS := IIF(Empty(ADEST34A->ENCELOTE),'A','E')
            ZCN->( Msunlock() )
            //ConOut( DToC(Date()) + " " + Time() + " ADEST034P - alteraLt - Lote: " + cValToChar(ADEST34A->CODILOTE) + " atualizado com sucesso.") //Tkt: T.I  - Fernando Sigoli - Removido log , pois esta gerando muito log nos scheduleds
        EndIf

        //
        ADEST34A->(DbSkip())

    End

    //
    ADEST34A->(DbCloseArea())

    //
    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - alteraLt - Fim importa��o de altera��es.")

    //
    RestArea(aArea)

Return Nil

/*/{Protheus.doc} deleteLt
    Processa importa��es de exclus�es de lotes de cria��o SAG.
    @type  Static Function
    @author Ricardo Lima.
    @since 01/11/2018
    @version 01
    /*/
Static Function deleteLt()

    Local aArea     := GetArea()
    Local cQuery    := ""

    //
    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - alteraLt - In�cio importa��o de exclus�es.")

    // Integracao para excluir do Protheus lotes que foram excluidos do SAG
    // RICARDO LIMA-CHAMADO:037647-03/01/2019
    cQuery := sqlDeLot()

    //
    If Select("ADEST34D") > 0
        ADEST34D->(DbCloseArea())
    EndIf

    //
    TcQuery cQuery New Alias "ADEST34D"
    While ADEST34D->(!Eof())
        DbSelectArea("ZCN")
        ZCN->(DbSetOrder(1))
        IF ZCN->(DbSeek( FWxFilial("ZCN") + Alltrim(ADEST34D->ZCN_LOTE) )) //Por Adriana em 27/05/2019 Chamado TI
            RecLock("ZCN",.F.)
                dbDelete()
            Msunlock()
            ConOut( DToC(Date()) + " " + Time() + " ADEST034P - Lote: " + cValToChar(ADEST34D->CODILOTE) + " exclu�do com sucesso.") //Por Adriana em 27/05/2019 Chamado TI.
        EndIf
        ADEST34D->(dbSkip())
    End

    //
    ConOut( DToC(Date()) + " " + Time() + " ADEST034P - alteraLt - Fim importa��o de exclus�es.")

    //
    RestArea(aArea)

Return Nil

/*/{Protheus.doc} sqlIntLot
    Script sql para consulta de lotes no SAG (inclus�o). Chamado 058675.
    @type  Static Function
    @author Everson
    @since 23/06/2020
    @version 01
    /*/
Static Function sqlInLot()

    Local cQuery := ""

    //
    cQuery += " SELECT CODILOTE, NOMELOTE, RECRLOTE, DATALOTE, ENCELOTE "
    cQuery += " FROM SCSRV03.SAG.dbo.MPGELOTE WITH(NOLOCK) "
    cQuery += " WHERE CODILOTE NOT IN ( "
    cQuery += "     SELECT ZCN_LOTE "
    cQuery += "     FROM "+RetSqlName("ZCN")+" ZCN WITH(NOLOCK)"
    cQuery += "     WHERE ZCN.D_E_L_E_T_ = ' ' AND ZCN_FILIAL = '"  + FWxFilial("ZCN") + "' ) AND DATALOTE <> '' AND DATALOTE IS NOT NULL " //Everson - 30/07/2020. Chamado 059658. //Everson - 13/01/2020. Chamado 7989.
    cQuery += " ORDER BY CODILOTE "

Return cQuery

/*/{Protheus.doc} sqlAlLot
    Script sql para consulta de lotes no SAG (altera��o). Chamado 058675.
    @type  Static Function
    @author Everson
    @since 23/06/2020
    @version 01
/*/
Static Function sqlAlLot(cDataIni)

    Local cQuery := ""

    //
    //cQuery += " SELECT CODILOTE, NOMELOTE, RECRLOTE, ENCELOTE, CODILOG_ "
    cQuery += " SELECT TOP 1 CODILOTE, NOMELOTE, RECRLOTE, ENCELOTE, CODILOG_ " // @history Macieira - ticket 67703   - 04/02/2022 - Cadastro de Lote - Lote Recria x Ccusto
    cQuery += " FROM SCSRV03.SAG.dbo.MPLOLOTE LOTE "
    cQuery += " WHERE PSITLOG_ = 'A' "
    cQuery += " AND CODILOTE IN ( "
    cQuery += "     SELECT ZCN_LOTE "
    cQuery += "     FROM "+RetSqlName("ZCN")+" ZCN "
    cQuery += "     WHERE ZCN.D_E_L_E_T_ = ' ' AND ZCN_FILIAL = '"  + FWxFilial("ZCN") + "' ) " //Everson - 13/01/2020. Chamado 7989.
    cQuery += " AND CODILOG_ > ( "
    cQuery += "     SELECT MAX(ZCN_LOGUPD) " //@history Ticket 92727 inclus�o de altera��o
    cQuery += "     FROM "+RetSqlName("ZCN")+" ZCN "
    cQuery += "     WHERE ZCN.D_E_L_E_T_ = ' ' AND ZCN_FILIAL = '"  + FWxFilial("ZCN") + "' " // @history Ticket 89304 - 02/03/2023 - Fernando Macieira - Complemento do Ticket 85733 (OPERA��O NOVA MATRIZES - CADASTRO DE LOTES ADFAT008P)
    cQuery += "     AND ZCN_LOTE = LOTE.CODILOTE ) " //@history Ticket 92727 inclus�o de altera��o
    //cQuery += " AND DATALOTE >= '" + cDataIni + "' " // @history Macieira - ticket 67703   - 07/02/2022 - Cadastro de Lote - Lote Recria x Ccusto

    // DEBUG - INIBIR
    //cQuery += " and CODILOTE='1243'

    // cQuery += " ORDER BY CODILOTE, CODILOG_ "
    cQuery += " ORDER BY CODILOTE, CODILOG_ DESC " // @history Macieira - ticket 67703   - 04/02/2022 - Cadastro de Lote - Lote Recria x Ccusto

Return cQuery

/*/{Protheus.doc} sqlDeLot
    Script sql para consulta de lotes no SAG (exclus�o). Chamado 058675.
    @type  Static Function
    @author Everson
    @since 23/06/2020
    @version 01
    /*/
Static Function sqlDeLot()

    //Vari�veis.
    Local cQuery := ""

    cQuery += " SELECT ZCN_LOTE "
    cQuery += " FROM " + RetSqlName("ZCN") + " ZCN "
    cQuery += " WHERE ZCN_LOTE IN ( "
    cQuery += "     SELECT CODILOTE "
    cQuery += "     FROM SCSRV03.SAG.dbo.MPLOLOTE "
    cQuery += "     WHERE PSITLOG_ = 'D' ) "
    cQuery += " AND ZCN.D_E_L_E_T_ = ' ' AND ZCN_FILIAL = '"  + FWxFilial("ZCN") + "' " //Everson - 13/01/2020. Chamado 7989.

Return cQuery

/*/{Protheus.doc} logZBN
    Gera log na tabela ZBN. Chamado 058675.
    @type  Static Function
    @author Everson
    @since 23/06/2020
    @version 01
/*/
Static Function logZBN(cStatus,cJob)

    //Vari�veis.
	Local aArea	:= GetArea()
	
	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + cJob))
	
		RecLock("ZBN",.F.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_ROTINA	:= cJob 
			ZBN_DATA    := dDataBase
			ZBN_HORA    := Time()
			ZBN_STATUS	:= cStatus
			
		MsUnlock() 
		
	Else
	
		RecLock("ZBN",.T.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_ROTINA	:= cJob 
			ZBN_DATA    := dDataBase
			ZBN_HORA    := Time()
			ZBN_STATUS	:= cStatus
	
		MsUnlock() 	
	
	EndIf
	
	ZBN->(dbCloseArea())
		
	RestArea(aArea)

Return Nil

/*/{Protheus.doc} u_EST034A0
Ticket 70142 - Substituicao de funcao Static Call por User Function MP 12.1.33
@type function
@version 1.0
@author Edvar   / Flek Solution
@since 16/03/2022
@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
/*/
Function u_EST034A0()
Return( procRot() )
