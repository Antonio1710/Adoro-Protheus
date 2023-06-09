#include "rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} User Function nomeFunction
    CHAMADO:037647 - Gera ordem de produ��o e aponta a mesma por integra��o do SAG         
    Quando a OP for excluida no SAG e gravado um log, a partir                             
    desse log, o protheus estorna o apontamento e faz a exclusao                            
    @type  Function
    @author Ricardo Lima
    @since 01/11/2018
    @version 01
    @history Chamado 048153 || OS 049415 || CONTROLADORIA || ANDRESSA || 45968437 OP DE OVOS - FWNM - 03/04/2019
    @history Chamado 049347 || OS 050685 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || SAG VS PROTHEUS || FWNM - 24/05/2019
    @history Chamado 058675 || OS 060648 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || SAG X SAFEEG - Everson 23/06/2020
    @history Ticket T.I.    - Leonardo P. Monteiro - 28/12/2021 - Corre��o na falha de conex�o com o linkedserver. Session Provider: Physical connection is not usable [xFFFFFFFF].
    @history Ticket 65674   - ADRIANO SAVOINE      - 28/12/2021 - Gerado no sistema o novo campo para trazer a descri��o do Tipo Ovo.
    @history Ticket T.I.    - Leonardo P. Monteiro - 04/01/2022 - Ajuste da empresa '07' para '01' e filial '01' para '03'.
    @history Ticket 66335   - Jonathan.Carvalho    - 06/01/2022 - Criado o STATUSOP do lado do SAG para n�o importar novamente os registros.
    @history Ticket TI      - Leonardo P. Monteiro - Fontes compilados emergencialmente 13/01/2022 11:44.
    @history Ticket TI      - Leonardo P. Monteiro - 17/01/2022 - Corre��o de error.log.
    @hystory Ticket 67537   - Fernando Macieira    - 02/02/2022 - Importa��o de Ovos - Ordem de Produ��o
    @hystory Ticket 69257   - Fernando Macieira    - 08/03/2022 - Redundancia na consist�ncia de duplica��o das OPs
    @history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33    
	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
    @history Ticket 84332 - Jonathan Carvalho - 02/12/2022 - Inclus�o do Tipo Ovo C = 7
    @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O
/*/
User Function ADEST033P()  // U_ADEST033P()

    //Vari�veis.
    Local lAutoJob      := .F.
    Private cDataIni    := ""

    //
    If Select("SX6") == 0
	    lAutoJob := .T.
    EndIf

    //
    If lAutoJob

        RpcClearEnv()
        RpcSetType(3)
        //@Ticket T.I.  - Leonardo P. Monteiro - 04/01/2022 - Ajuste da empresa '07' para '01' e filial '01' para '03'.
        RpcSetEnv("01","03")

        // Garanto uma �nica thread sendo executada - // Adoro - Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - fwnm - 30/06/2020
        If !LockByName("ADEST033P", .T., .F.)
            ConOut("[ADEST033P] - Existe outro processamento sendo executado! Verifique...")
            RPCClearEnv()
            Return
        EndIf

        //ConOut( "[ADEST033P] - "+DToC(Date())+" "+Time()+" - In�cio Job importa��o de Ops.")
        //	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
        //FWMonitorMsg(ALLTRIM(PROCNAME()))

    EndIf

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Gera ordem de produ��o e aponta a mesmo por integra��o do SAG Quando a OP for excluida no SAG e gravado um log, a partir desse log, o protheus estorna o apontamento e faz a exclusao')
    
    cDataIni    := Dtos(Date()-60)

    u_GrLogZBE( Date(),;
                TIME(),;
                cUserName,;
                "00 - In�cio da integra��o com o SAG",;
                "ESTOQUE E CUSTOS",;
                "ADEST033P",;
                "[ADEST033P] - cEmpAnt/cFilAnt: "+cEmpAnt+cFilAnt+" -  "+DToC(Date())+" "+Time()+" - In�cio Job importa��o de Ops.",;
                ComputerName(),;
                LogUserName())

    //Leonardo - 27/12/2021 - Checa a conex�o com a database do SAG.
    if fChkSAG()
        //Everson - 23/06/2020 - Chamado 058675.
        procRot(lAutoJob)
    else
        u_GrLogZBE( Date(),;
                    TIME(),;
                    cUserName,;
                    "01-Erro na abertura do LinkedServer c\ o SAG",;
                    "ESTOQUE E CUSTOS",;
                    "ADEST033P",;
                    "[ADEST033P] - cEmpAnt/cFilAnt: "+cEmpAnt+cFilAnt+" -  "+DToC(Date())+" "+Time()+" - Erro na abertura do LinkedServer para integra��o com o Protheus.",;
                    ComputerName(),;
                    LogUserName())
    endif
    
    If lAutoJob 

        //��������������������������������������?
        //�Destrava a rotina para o usu�rio	    ?
        //��������������������������������������?
        UnLockByName("ADEST033P")

        //ConOut( DToC(Date()) + " " + Time() + " ADEST033P - Fim Job importa��o de Ops.")
        u_GrLogZBE( Date(),;
                TIME(),;
                cUserName,;
                "99 - T�rmino da integra��o com o SAG",;
                "ESTOQUE E CUSTOS",;
                "ADEST033P",;
                "[ADEST033P] - cEmpAnt/cFilAnt: "+cEmpAnt+cFilAnt+" -  "+DToC(Date()) + " " + Time() + " ADEST033P - Fim Job importa��o de Ops.",;
                ComputerName(),;
                LogUserName())

		RpcClearEnv()

	EndIf

Return Nil

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 13/02/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fChkSAG()

    Local lRet      := .F.
	Local cQuery    := ""
    Local cDataIni := Dtos(Date()-60)

	//Verifica se o linkedServer esta ativo
	cQuery := " SELECT TOP(1) 1 AS CONEXAO FROM  OPENQUERY(SCSRV03, ' SELECT * FROM SAG.dbo.INGEOVOS WHERE DATAOVOS >= ''" + cDataIni + "'' AND TIPOOVOS=''PROD'' ');"
    //cQuery += " OPENQUERY(SCSRV03, 'SELECT TOP(1) 1 AS CONEXAO FROM SAG.dbo.INGEOVOS WHERE DATAOVOS >= ''" + cDataIni + "'' AND TIPOOVOS=''PROD'' ') "
	
	If TcSqlExec(cQuery) < 0
		lRet := .F.
	else
        lRet := .T.
    Endif

return lRet


/*/{Protheus.doc} procRot
    Processa rotina.
    @type  Static Function
    @author Ricardo Lima.
    @since 01/11/2018
    @version 01
/*/
Static Function procRot(lAutoJob)

    Local NReg := 0

    incluiOp(lAutoJob,@NReg)

    deleteOp(lAutoJob)

    If !lAutoJob

        If NReg > 0
            ApMsgInfo("Protheus Atualizado com OP do SAG.","Fun��o procRot(ADEST033P)") 
            ConOut( DToC(Date()) + " " + Time() + " ADEST033P - procRot - Protheus Atualizado com OP do SAG.")
        Else
            ApMsgInfo("N�o Existe DADOS para atualizar o Protheus.","Fun��o procRot(ADEST033P)") 
            ConOut( DToC(Date()) + " " + Time() + " ADEST033P - procRot - N�o Existe DADOS para atualizar o Protheus.")
        EndIf

    Endif

Return Nil 

/*/{Protheus.doc} incluiOp
    Inclui Ops.
    @type  Static Function
    @author user
    @since 23/06/2020
    @version 01
/*/
Static Function incluiOp(lAutoJob,NReg)

    //Vari�veis.
    Local aArea    := GetArea()
    Local cQuery   := ""
    Local cDescLt  := ""
    Local lLoteOk  := .t.
    Local lLockZCV := .T.
    Local lExistOP := .f.
    
    // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O
    Private cFilSAG  := "" 
    Private cFilBkp  := cFilAnt

    ConOut( DToC(Date()) + " " + Time() + " ADEST033P - incluiOp - In�cio importa��o de Ops.")
    
    // Chamado n. 049347 || OS 050685 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || SAG VS PROTHEUS || FWNM - 24/05/2019
    cDescLt  := GetMV("MV_#LOTSAG",,"COBB")
    
    cQuery += sqlInOp()

    If Select("ADEST33I") > 0
		ADEST33I->(DbCloseArea())
	EndIf

	TcQuery cQuery New Alias "ADEST33I"

    If !lAutoJob
        Count To NReg
        ProcRegua( NReg )
    EndIf

    //
    dbSelectArea("ADEST33I")
    dbGoTop()

    While ADEST33I->(!Eof())

        ConOut( DToC(Date()) + " " + Time() + " ADEST033P - incluiOp - importando OP " + Alltrim(Str(ADEST33I->CODIOVOS)))

        // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O - TE05LOTE
        cFilSAG := AllTrim(ADEST33I->TE05LOTE)
        If Empty(cFilSAG)
            ADEST33I->( dbSkip() )
            Loop
        Else
            cFilAnt := cFilSAG
        EndIf
        
        // @hystory Ticket 69257   - Fernando Macieira    - 08/03/2022 - Redundancia na consist�ncia de duplica��o das OPs
        lExistOP := ChkOPZCV(Alltrim(Str(ADEST33I->CODIOVOS)))

        If !lExistOP

            // Chamado n. 049347 || OS 050685 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || SAG VS PROTHEUS || FWNM - 24/05/2019
            lLoteOk := ChkLote(Alltrim(Str(ADEST33I->CODILOTE)), cDescLt)
            
            If lLoteOk 

                // @hystory Ticket 67537   - Fer Macieira    - 02/02/2022 - Importa��o de Ovos - Ordem de Produ��o
                ZCV->( dbSetOrder(1) ) // ZCV_FILIAL, ZCV_CODOP, R_E_C_N_O_, D_E_L_E_T_
                If ZCV->( dbSeek(FWxFilial("ZCV")+PadR(Alltrim(Str(ADEST33I->CODIOVOS)),TamSX3("ZCV_CODOP")[1])) )
                    lLockZCV := .F.
                Else
                    lLockZCV := .T.
                EndIf
            
                RecLock("ZCV", lLockZCV)
                    ZCV->ZCV_FILIAL := FWxFilial("ZCV")
                    ZCV->ZCV_CODOP  := Alltrim(Str(ADEST33I->CODIOVOS))
                    ZCV->ZCV_CODTIP := Alltrim(Str(ADEST33I->CODITPOV))
                    ZCV->ZCV_CDLOTE := Alltrim(Str(ADEST33I->CODILOTE))
                    ZCV->ZCV_DATA   := ADEST33I->DATAOVOS
                    ZCV->ZCV_IDADEO := ADEST33I->IDADOVOS
                    ZCV->ZCV_QTDOVO := ADEST33I->QTDEOVOS
                    ZCV->ZCV_CODAOJ := Alltrim(Str(ADEST33I->CODIALOJ))
                    // Chamado 048153 || OS 049415 || CONTROLADORIA || ANDRESSA || 45968437 || OP DE OVOS - FWNM - 01/04/2019
                    ZCV->ZCV_DESCLT := Posicione("ZCN",1,FWxFilial("ZCN")+PadR(Alltrim(Str(ADEST33I->CODILOTE)),TamSX3("ZCN_LOTE")[1]),"ZCN_DESCLT")
                    ZCV->ZCV_DESCTP := Alltrim(ADEST33I->NOMETPOV)//Adriano Savoine - 28/12/2021 - Ticket : 65674
        
                ZCV->( MsUnlock() )
                
                ConOut( DToC(Date()) + " " + Time() + " ADEST033P - incluiOp - Incluido a OP SAG Numero: " + Alltrim(Str(ADEST33I->CODIOVOS)))
            
            EndIf

        EndIf

        ADEST33I->(DbSkip())

        If !lAutoJob
            IncProc() 
        Endif

    End 

    ADEST33I->(DbCloseArea())

    ConOut( DToC(Date()) + " " + Time() + " ADEST033P - incluiOp - Fim importa��o de Ops.")

    RestArea(aArea)

    cFilAnt := cFilBkp // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O

Return Nil 

/*/{Protheus.doc} deleteOp
    Exclui Ops.
    @type  Static Function
    @author user
    @since 23/06/2020
    @version 01
    /*/
Static Function deleteOp(lAutoJob)

    Local aArea    := GetArea()
    Local cQuery   := ""

    // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O
    Private cFilSAG  := "" 
    Private cFilBkp  := cFilAnt

    ConOut( DToC(Date()) + " " + Time() + " ADEST033P - deleteOp - In�cio exclus�o de Ops.")

    // Exclus�o de OP
    cQuery := sqlDeOp()
    
    If Select("ADEST33D") > 0
		ADEST33D->(DbCloseArea())
	EndIf

	TcQuery cQuery New Alias "ADEST33D"

    DbSelectArea("ADEST33D")
    ADEST33D->(DbGoTop())
    While ADEST33D->(!Eof())

        // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O - TE05LOTE
        cFilSAG := AllTrim(ADEST33D->TE05LOTE)
        If Empty(cFilSAG)
            ADEST33D->( dbSkip() )
            Loop
        Else
            cFilAnt := cFilSAG
        EndIf

        DbSelectArea("ZCV")
        ZCV->(DbSetOrder(1))
        If ZCV->(DbSeek( FWxFilial("ZCV") + Alltrim(Str(ADEST33D->CODIOVOS))))
            RecLock("ZCV",.F.)
                ZCV->(DbDelete())
            MsUnlock()
            ConOut( DToC(Date()) + " " + Time() + " ADEST033P - deleteOp - Excluido a OP SAG Numero: " + Alltrim(Str(ADEST33D->CODIOVOS)))
        Endif  

        ADEST33D->(DbSkip())

    End

    ConOut( DToC(Date()) + " " + Time() + " ADEST033P - deleteOp - Fim exclus�o de Ops.")

    RestArea(aArea)

    cFilAnt := cFilBkp // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O
	
Return Nil

/*/{Protheus.doc} ChkLote
    Checa se lote pode ser importado. Chamado 049347.
    @type  Static Function
    @author Microsiga 
    @since 05/24/2019
    @version 01
    /*/
Static Function ChkLote(cCodLt, cDescLt)

    Local aArea  := GetArea()
	Local lOk    := .t.
	Local cQuery := ""
	
	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf

	cQuery += " SELECT COUNT(1) TT "
	cQuery += " FROM " + RetSqlName("ZCN") + " (NOLOCK) "
	cQuery += " WHERE ZCN_FILIAL='"+FWxFilial("ZCN")+"' " // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O
	cQuery += " AND ZCN_LOTE='"+cCodLt+"' "
	cQuery += " AND ZCN_DESCLT LIKE '%"+cDescLt+"%' "
	cQuery += " AND D_E_L_E_T_='' "
	
	TcQuery cQuery New alias "Work"
	DbSelectArea("Work")
	Work->(DbGoTop())
	
	If Work->TT >= 1
		lOk := .F. // Lote nao autorizado a importar
	EndIf

	If Select("Work") > 0
		Work->(DbCloseArea())
	EndIf

    ConOut( DToC(Date()) + " " + Time() + " ADEST033P - ChkLote - checa lote " + cValToChar(cCodLt) + " lOk " + cValToChar(lOk))

    RestArea(aArea)

Return lOk

/*/{Protheus.doc} sqlInOp
    Script sql para importa��o de ordens de produ��o.
    @type  Static Function
    @author Everson
    @since 23/06/2020
    @version 01
    /*/
Static Function sqlInOp()

    Local cQuery   := ""
    Local cDataIni := Dtos(Date()-60)
   
    /*
    cQuery += " SELECT CODIOVOS, INGEOVOS.CODITPOV, INCATPOV.NOMETPOV, CODILOTE, DATAOVOS, IDADOVOS, QTDEOVOS, CODIALOJ "
    cQuery += " FROM SCSRV03.SAG.dbo.INGEOVOS AS INGEOVOS "
    cQuery += " LEFT JOIN SCSRV03.SAG.dbo.POCaEmpr AS POCAEMPR "
    cQuery += " ON POCAEMPR.PCODEMPR=INGEOVOS.PEMPOVOS " //Everson - 23/06/2020. Chamado 058675.
    cQuery += " LEFT JOIN SCSRV03.SAG.dbo.INCATPOV AS INCATPOV " //Adriano Savoine - 28/12/2021 - Ticket : 65674
    cQuery += " ON INCATPOV.CODITPOV = INGEOVOS.CODITPOV " //Adriano Savoine - 28/12/2021 - Ticket : 65674
    cQuery += " WHERE DATAOVOS >= '" + cDataIni + "' "
    cQuery += " AND TIPOOVOS='PROD' "
    cQuery += " AND POCAEMPR.Te07Empr = '" + cEmpAnt + "' " //Everson - 23/06/2020. Chamado 058675.
    cQuery += " AND CODIOVOS NOT IN ( "
	cQuery += "     SELECT ZCV_CODOP FROM " + RetSqlName("ZCV") + " ZCV "
	cQuery += "     WHERE D_E_L_E_T_ = ' ' ) "
    cQuery += " ORDER BY CODIOVOS "
    */
    
    //@Ticket T.I.  - Leonardo P. Monteiro - 04/01/2022 - Ajuste da empresa '07' para '01' e filial '01' para '03'.
    //@Ticket 66335 - Jonathan.Carvalho - 06/01/2022 - Criado o STATUSOP
    cQuery += " SELECT *
    cQuery += " FROM "
    cQuery += " OPENQUERY(SCSRV03,"
    cQuery += "  'SELECT CODIOVOS, INGEOVOS.CODITPOV, INCATPOV.NOMETPOV, INGEOVOS.CODILOTE, DATAOVOS, IDADOVOS, QTDEOVOS, CODIALOJ, TE05LOTE "
    cQuery += "   FROM SAG.dbo.INGEOVOS AS INGEOVOS  "
    cQuery += "         LEFT JOIN SAG.dbo.POCaEmpr AS POCAEMPR  ON POCAEMPR.PCODEMPR=INGEOVOS.PEMPOVOS  "
    cQuery += "         LEFT JOIN SAG.dbo.INCATPOV AS INCATPOV ON INCATPOV.CODITPOV = INGEOVOS.CODITPOV " //Adriano Savoine - 28/12/2021 - Ticket : 65674
    //cQuery += "   WHERE DATAOVOS >= ''" + cDataIni + "'' AND STATUSOP <> ''I''  AND TIPOOVOS=''PROD''  AND POCAEMPR.Te07Empr = ''" + cEmpAnt + "'' ') A "
    // @hystory Ticket 67537   - Fer Macieira    - 02/02/2022 - Importa��o de Ovos - Ordem de Produ��o
    // @history Ticket 84332 - Jonathan Carvalho - 02/12/2022 - Inclus�o do Tipo Ovo C = 7
    
    // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O
    cQuery += "         LEFT JOIN SAG.dbo.MPCALOTE AS MPCALOTE ON MPCALOTE.CODILOTE = INGEOVOS.CODILOTE
    //

    cQuery += "   WHERE DATAOVOS >= ''" + cDataIni + "'' AND TIPOOVOS=''PROD''  AND INGEOVOS.CODITPOV IN (''5'',''6'', ''7'') AND POCAEMPR.Te07Empr = ''" + cEmpAnt + "'' ') A "
    cQuery += " WHERE   "
    cQuery += "     CODIOVOS NOT IN ( "
	cQuery += "     SELECT ZCV_CODOP FROM " + RetSqlName("ZCV") + " ZCV "
	cQuery += "     WHERE D_E_L_E_T_ = ' ' ) "
    cQuery += " ORDER BY CODIOVOS "

Return cQuery 

/*/{Protheus.doc} sqlDeOp
    Script sql para exclus�o de ordens de produ��o.
    @type  Static Function
    @author Everson
    @since 23/06/2020
    @version 01
/*/
Static Function sqlDeOp()

    Local cQuery := ""
    Local cDataIni := Dtos(Date()-60)

    /*
    cQuery := " SELECT * FROM "
    cQuery += " OPENQUERY(SCSRV03, "
    cQuery += " 'SELECT CODIOVOS "
    cQuery += "  FROM SAG.dbo.INLOOVOS "
    cQuery += "  WHERE DATAOVOS >= ''" + cDataIni + "'' AND PSITLOG_=''D'' ') SAG "
    cQuery += " WHERE CODIOVOS IN ( SELECT ZCV_CODOP FROM "+RetSqlName("ZCV")+" ZCV WHERE D_E_L_E_T_ = ' ' ) "
    */

    // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O
    cQuery := " SELECT * FROM "
    cQuery += " OPENQUERY(SCSRV03, "
    cQuery += " 'SELECT CODIOVOS, TE05LOTE "
    cQuery += "  FROM SAG.dbo.INLOOVOS "
    cQuery += "  LEFT JOIN SAG.dbo.MPGELOTE MPCALOTE ON MPCALOTE.CODILOTE = INLOOVOS.CODILOTE "
    cQuery += "  WHERE DATAOVOS >= ''" + cDataIni + "'' AND PSITLOG_=''D'' ') SAG "
    cQuery += " WHERE CODIOVOS IN ( SELECT ZCV_CODOP FROM "+RetSqlName("ZCV")+" ZCV WHERE D_E_L_E_T_ = ' ' ) "

Return cQuery

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author FWNM
    @since 08/03/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @hystory Ticket 69257   - Fernando Macieira    - 08/03/2022 - Redundancia na consist�ncia de duplica��o das OPs
/*/
Static Function ChkOPZCV(cOPSAG)

    Local lRet := .f.

    If Select("WorkZCV") > 0
        WorkZCV->( dbCloseArea() )
    EndIf

    cQuery := " SELECT ZCV_CODOP
    cQuery += " FROM " + RetSqlName("ZCV") + " (NOLOCK)
    cQuery += " WHERE ZCV_FILIAL='"+FWxFilial("ZCV")+"' " // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - APONTAMENTO DE PRODU��O
    cQuery += " AND ZCV_CODOP='"+cOPSAG+"'
    cQuery += " AND D_E_L_E_T_=''

    tcQuery cQuery New Alias "WorkZCV"

    WorkZCV->( dbGoTop() )

    If WorkZCV->( !EOF() )
        lRet := .t.
    EndIf

    If Select("WorkZCV") > 0
        WorkZCV->( dbCloseArea() )
    EndIf
    
Return lRet

/*/{Protheus.doc} u_EST033A0
Ticket 70142 - Substituicao de funcao Static Call por User Function MP 12.1.33
@type function
@version 1.0
@author Edvar   / Flek Solution
@since 16/03/2022
@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
/*/
Function u_EST033A0( uPar1 )
Return( procRot(uPar1) )
