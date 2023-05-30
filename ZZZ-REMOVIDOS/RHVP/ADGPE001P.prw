#include "protheus.ch"
#include "topconn.ch"
#Include "Tbiconn.ch"

/*/{Protheus.doc} User Function ADGPE001P
    Cadastra e atualiza funcionários no Protheus a partir do RM
    @type  Function
    @author Fernando Macieira
    @since 09/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @ticket 78944 - Projeto -- Integração RM x Protheus
    RA_DESEPS	varchar	no	254
    RA_TCFMSG	varchar	no	250
    RA_LOGRDSC	varchar	no	80
    RA_MSG	varchar	no	80
    @history ticket 78944 - Fernando Macieira - 24/10/2022 - Implementação WF
/*/
User Function ADGPE001P(aParam)

	Local i        
    Local cEmpRun   := ""
    Local aEmpresas := {}

	Default aParam    := Array(2)
	Default aParam[1] := "01"
	Default aParam[2] := "02"

	Private cLinked   := "" 
	Private cSGBD     := "" 
    Private cProces   := "00001"

	// Inicializo ambiente
	rpcClearEnv()
	rpcSetType(3)
		
	If !rpcSetEnv(aParam[1],aParam[2] ,,,,,{"SM0"})
		ConOut( " [ ADGPE001P ] - Não foi possível inicializar o ambiente, empresa " + aParam[1] + ", filial " + aParam[2] )
		Return
	EndIf

    cLinked := GetMV("MV_#RMLINK",,"RM") 
    cSGBD   := GetMV("MV_#RMSGBD",,"CCZERN_119204_RM_PD")
    cEmpRun := GetMV("MV_#RMEMP",,"01|02|07|09")

	// debug - inibir
    //cEmpRun := "09"
    // debug - inibir
    
    // Carrega Empresas para processamentos
	dbSelectArea("SM0")
	dbSetOrder(1)
	SM0->(dbGoTop())
	Do While SM0->(!EOF())
		If (SM0->M0_CODIGO $ cEmpRun)
			aAdd(aEmpresas, { AllTrim(SM0->M0_CODIGO), AllTrim(SM0->M0_CODFIL) } ) // debug - voltar
            //aAdd(aEmpresas, { "01", "0A" } ) // debug - INIBIR
            //aAdd(aEmpresas, { "01", "0B" } ) // debug - INIBIR
		EndIf
		SM0->( dbSkip() )
	EndDo

    // Processa empresas
    For i:=1 to Len(aEmpresas)

		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv( aEmpresas[ i,1 ] , aEmpresas[ i,2 ] )

        logZBN("1")
            RunGPE001P()
        logZBN("2")

    Next i

    // Enviar email
    aEmps := Separa(cEmpRun,"|")
    For i:=1 to Len(aEmps)

		RpcClearEnv()
		RpcSetType(3)
		RpcSetEnv( aEmps[i] , "01" )

        SendMail()

    Next i

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 09/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function RunGPE001P()

    Local nRegsLidos := 0
    Local nTotREG    := 0
    Local nRegsInc   := 0
    Local nRegsAlt   := 0

    Local cQuery     := ""
    Local aDadSRA    := {}
    Local nOpc       := 0
    Local aLogAuto   := {}
    Local nAux
    Local cLogTxt    := ""

    Local lDemissa   := .f.
    Local lFerias    := .f.
    Local lAfasta    := .f.

    Private cColigada := GetColigada()

    RM := GetNextAlias()
			
    cQuery := " SELECT * FROM OPENQUERY ( " + cLinked + ", '
    cQuery += "				SELECT PFUNC.CODFILIAL, PFUNC.CHAPA, PFUNC.NOME, PPESSOA.SEXO, PPESSOA.ESTADOCIVIL, PPESSOA.ESTADONATAL, PPESSOA.NACIONALIDADE, PPESSOA.DTNASCIMENTO, PFUNC.CODCCUSTO, PFUNC.DATAADMISSAO, PFUNC.CODFUNCAO, PFUNC.CODRECEBIMENTO, PPESSOA.CARTEIRATRAB, PPESSOA.SERIECARTTRAB, PPESSOA.CPF, PFUNC.CODHORARIO, PFUNC.RECMODIFIEDON, CONVERT(VARCHAR(8), (PFUNC.DATADEMISSAO), 112) DATADEMISSAO, PPESSOA.CARTIDENTIDADE,
    cQuery += "                    CHECKSUM(PFUNC.NOME + PPESSOA.ESTADOCIVIL + PFUNC.CODCCUSTO + PFUNC.CODFUNCAO + PFUNC.CODHORARIO + PPESSOA.CPF + PPESSOA.CARTIDENTIDADE) CHKSUM
	//cQuery += "                    HASHBYTES(''SHA1'',PFUNC.NOME + PPESSOA.ESTADOCIVIL + PFUNC.CODCCUSTO + PFUNC.CODFUNCAO + PFUNC.CODHORARIO + PPESSOA.CPF) HASH1,
	//cQuery += "                    HASHBYTES(''SHA2_512'',PFUNC.NOME + PPESSOA.ESTADOCIVIL + PFUNC.CODCCUSTO + PFUNC.CODFUNCAO + PFUNC.CODHORARIO + PPESSOA.CPF) HASH2

    cQuery += "				FROM [" + cSGBD + "].[DBO].[PFUNC] AS PFUNC WITH (NOLOCK)

    cQuery += "				INNER JOIN [" + cSGBD + "].[DBO].[PPESSOA] AS PPESSOA WITH (NOLOCK)
	cQuery += "				ON PPESSOA.CODIGO = PFUNC.CODPESSOA

    cQuery += " WHERE PFUNC.CODCOLIGADA=''"+cColigada+"''"
    
    //cQuery += " AND PFUNC.CODFILIAL=''"+AllTrim(FWCodFil())+"''"
    cQuery += " AND PFUNC.CODFILIAL = ( SELECT GFILIAL.CODFILIAL
    cQuery += "		FROM [" + cSGBD + "].[DBO].[GFILIAL] AS GFILIAL WITH (NOLOCK)
	cQuery += "     WHERE GFILIAL.CODCOLIGADA=''"+cColigada+"''"
	cQuery += "     AND GFILIAL.IDINTEGRACAO=''"+AllTrim(FWCodFil())+"''" 
    cQuery += " )
    
    cQuery += " AND ( CONVERT(VARCHAR(8), (PFUNC.DATAADMISSAO), 112) LIKE ''"+Left(DtoS(msDate()),6)+"%'' OR
    cQuery += "       CONVERT(VARCHAR(8), (PFUNC.RECMODIFIEDON), 112) LIKE ''"+Left(DtoS(msDate()),6)+"%'' )

    // DEBUG
    //cQuery += " AND PPESSOA.CPF=''55912124843'' "    
    //cQuery += " AND PPESSOA.CPF=''29737723899'' "    
    // DEBUG

    cQuery += " ORDER BY 10 DESC 
    //cQuery += " ORDER BY 18 DESC // DEBUG
    cQuery += " ')

	tcQuery cQuery New Alias RM

    RM->( dbGoTop() )
    Eval( { || nTotREG:=0, RM->( dbEval( { || nTotREG++ } ) ), RM->(dbGoTop() ) } )
    logZBN("3", nTotREG)
    
    RM->( dbGoTop() )
    Do While RM->( !EOF() )

        nRegsLidos++

        logZBN("4", nRegsLidos)
        
        /*If nRegsLidos == 5122
            lDebug := .t.
        EndIf*/
        
        cSituFolh  := ""
        dDemissa   := CtoD("//")
        lDemissa   := .f.
        lFerias    := .f.
        lAfasta    := .f.

        cChkSum    := AllTrim(Str(RM->CHKSUM)) // CHECKSUM(PFUNC.NOME + PPESSOA.ESTADOCIVIL + PFUNC.CODCCUSTO + PFUNC.CODFUNCAO + PFUNC.CODHORARIO + PPESSOA.CPF) CHKSUM
        //cHASH1     := RM->HASH1
        //cHASH2     := RM->HASH2

        // chave SRA
        cFilSRA    := AllTrim(fDeParaRM("GFILIAL",RM->CODFILIAL))
        cMat       := Right(AllTrim(RM->CHAPA),6)

        SRA->( dbSetOrder(1) ) // RA_FILIAL, RA_MAT, RA_NOME, R_E_C_N_O_, D_E_L_E_T_
        If SRA->( !dbSeek(cFilSRA+cMat) )

            nOpc := 3 // Inclusao

        Else
            
            nOpc := 4 // Alteracao

            // Trava para impedir que o sistema mude os autonomos e prolabores para celetistas e também irá parar com mensagem em tela
            If AllTrim(SRA->RA_PROCES) <> AllTrim(cProces)
                RM->( dbSkip() )
                Loop
            EndIf

            // Demitido não altera +
            If AllTrim(SRA->RA_SITFOLH) == "D" .and. StoD(RM->DATADEMISSAO) == SRA->RA_DEMISSA
                RM->( dbSkip() )
                Loop
            EndIf

            // Demissao
            If !Empty(AllTrim(RM->DATADEMISSAO)) .and. AllTrim(RM->DATADEMISSAO) <= DtoS(msDate())
                If AllTrim(SRA->RA_SITFOLH) <> "D"
                    lDemissa  := .t.
                    cSituFolh := "D"
                    dDemissa  := StoD(RM->DATADEMISSAO)
                EndIf
            EndIf

            If !lDemissa 
                If AllTrim(SRA->RA_SITFOLH) <> "D"
                    lFerias := GetFerias(RM->CHAPA)
                    If lFerias
                        cSituFolh := "F"
                    EndIf
                EndIf
            EndIf

            If !lDemissa .and. !lFerias
                If AllTrim(SRA->RA_SITFOLH) <> "D"
                    lAfasta := GetAfasta(RM->CHAPA)
                    If lAfasta
                        cSituFolh := "A"
                    EndIf
                EndIf
            EndIf

            If AllTrim(cChkSum) == AllTrim(SRA->RA_DESEPS)
                If !lDemissa .and. !lFerias .and. !lAfasta
                    RM->( dbSkip() )
                    Loop
                EndIf
            EndIf

        EndIf

        // debug
        /*RM->( dbSkip() )
        Loop*/
        // debug

        cNome      := RM->NOME
        cSexo      := RM->SEXO
        cUF        := RM->ESTADONATAL
        cNaciona   := RM->NACIONALIDADE
        dNasc      := RM->DTNASCIMENTO
        cCC        := RM->CODCCUSTO
        dAdmissa   := RM->DATAADMISSAO
        
        cCatFunc   := RM->CODRECEBIMENTO // ???
        cTipoPgt   := RM->CODRECEBIMENTO
        cNumCP     := RM->CARTEIRATRAB
        cSerCP     := RM->SERIECARTTRAB
        cCPF       := RM->CPF
        cRG        := RM->CARTIDENTIDADE
        
        nHrsMes    := 220 // ???
        nHrsSem    := 44 // ???
        cHOParc    := "1" // ???
        cCompSab   := "1" // ???
        cAdtPoSe   := "***N**" // ???
        cProces    := '00001'
        cRacaCor   := "9" // nao informado
        cTemFilho  := "" // ????

        // VER NO RM
        cTipoADM   := "RM" // Tabela 38 dentro do SX5
        cViemRAI   := "RM" // Tabela 25 dentro do SX5
        cGrInRAI   := "RM" // Tabela 26 dentro do SX5

        // DE/PARA 
        cCodFunc   := fDeParaRM("SRJ",RM->CODFUNCAO)
        cTurTra    := fDeParaRM("SR6",RM->CODHORARIO) //"RM" // EXISTCPO("SR6")
        cEst       := fDeParaRM("PCODESTCIVIL",RM->ESTADOCIVIL)

        If nOpc == 4
            If SRA->RA_DEMISSA           == dDemissa                .and.;
                AllTrim(SRA->RA_CC)      == AllTrim(cCC)            .and.;
                AllTrim(SRA->RA_SITFOLH) == AllTrim(cSituFolh)      .and.;
                AllTrim(SRA->RA_TNOTRAB) == AllTrim(cTurTra)        .and.;
                AllTrim(SRA->RA_CODFUNC) == AllTrim(cCodFunc)       .and.;
                AllTrim(SRA->RA_CIC)     == AllTrim(cCPF)           .and.;
                AllTrim(SRA->RA_RG)      == AllTrim(cRG)            .and.;
                AllTrim(SRA->RA_DESEPS)  == AllTrim(cChkSum)

                RM->( dbSkip() )
                Loop
            EndIf
        EndIf

        aDadSRA := {}
        aAdd( aDadSRA,{"RA_FILIAL" 		, cFilSRA	  , Nil })
        aAdd( aDadSRA,{"RA_MAT" 		, cMat		  , Nil })
        aAdd( aDadSRA,{'RA_NOME'		, cNome	      , Nil })
        aAdd( aDadSRA,{'RA_NOMECMP'		, cNome	      , Nil })
        aAdd( aDadSRA,{'RA_SEXO'		, cSexo       , Nil })
        aAdd( aDadSRA,{'RA_ESTCIVI'		, cEst        , Nil })
        aAdd( aDadSRA,{'RA_NATURAL'		, cUF         , Nil })
        aAdd( aDadSRA,{'RA_NACIONA'		, cNaciona    , Nil })
        aAdd( aDadSRA,{'RA_NASC'		, dNasc       , Nil })
        aAdd( aDadSRA,{'RA_CC'			, cCC         , Nil })
        aAdd( aDadSRA,{'RA_ADMISSA'		, dAdmissa    , Nil })
        aAdd( aDadSRA,{'RA_OPCAO'		, dAdmissa+30 , Nil })
        aAdd( aDadSRA,{'RA_HRSMES'		, nHrsMes     , Nil })
        aAdd( aDadSRA,{'RA_HRSEMAN'		, nHrsSem     , Nil })
        aAdd( aDadSRA,{'RA_CODFUNC'		, cCodFunc	  , Nil })
        aAdd( aDadSRA,{'RA_CATFUNC'		, cCatFunc    , Nil })
        aAdd( aDadSRA,{'RA_TIPOPGT'		, cTipoPgt    , Nil })
        aAdd( aDadSRA,{'RA_HOPARC'		, cHOParc     , Nil })
        aAdd( aDadSRA,{'RA_COMPSAB'		, cCompSab    , Nil })
        aAdd( aDadSRA,{'RA_ADTPOSE'		, cAdtPoSe    , Nil })
        aAdd( aDadSRA,{'RA_PROCES'		, cProces     , Nil })
        aAdd( aDadSRA,{'RA_RACACOR'		, cRacaCor    , Nil })
        aAdd( aDadSRA,{'RA_CIC'		    , cCPF        , Nil })
        aAdd( aDadSRA,{'RA_RG'		    , cRG         , Nil })
        aAdd( aDadSRA,{'RA_SITFOLH'		, cSituFolh   , Nil })
        aAdd( aDadSRA,{'RA_DEMISSA'		, dDemissa    , Nil })

        aAdd( aDadSRA,{'RA_DESEPS'		, cChkSum     , Nil })

        If nOpc == 3
            aAdd( aDadSRA,{'RA_TIPOADM'		, cTipoADM  , Nil })
            aAdd( aDadSRA,{'RA_VIEMRAI'		, cViemRAI  , Nil })
            aAdd( aDadSRA,{'RA_GRINRAI'		, cGrInRAI  , Nil })
            aAdd( aDadSRA,{'RA_TNOTRAB'		, cTurTra   , Nil })
        EndIf

        lMsErroAuto     := .F.
        lMSHelpAuto     := .T.
        lAutoErrNoFile  := .T.

        If nOpc == 3 // debug
            
            dbSelectArea("SRA")
            msExecAuto({|x,y,k,w| GPEA010(x,y,k,w)},nil,nil,aDadSRA,nOpc)

            If lMsErroAuto

                //MostraErro()
                cLogTxt := ""
                aLogAuto := {}
                aLogAuto := GetAutoGRLog()
                For nAux := 1 To Len(aLogAuto)
                    cLogTxt += aLogAuto[nAux] + chr(13) + chr(10)
                Next

                //gera log - // @history ticket 68820   - Fernand Macieira- 17/03/2022 - Mudança de conceito, para que o campo ZD_BLQRAVE seja preenchido automaticamente (campo ficará apenas visual)
                u_GrLogZBE(msDate(),TIME(),cUserName,cLogTxt,"RM","ADGPE001P",;
                "FUNCIONARIO RM NAO ATUALIZADO " + cEmpAnt + "/" + cFilSRA + " " + cMat + " " + AllTrim(cNome),ComputerName(),LogUserName())
            
            Else

                nRegsInc++

            EndIf
        
        EndIf

        // Double Check
        //If nOpc == 4

            SRA->( dbSetOrder(1) ) // RA_FILIAL, RA_MAT, RA_NOME, R_E_C_N_O_, D_E_L_E_T_
            If SRA->( dbSeek(cFilSRA+cMat) )

                If AllTrim(SRA->RA_SITFOLH)  <> AllTrim(cSituFolh) .or.;
                    AllTrim(SRA->RA_DESEPS)  <> AllTrim(cChkSum)   .or.;
                    AllTrim(SRA->RA_CC)      <> AllTrim(cCC)       .or.;
                    AllTrim(SRA->RA_TNOTRAB) <> AllTrim(cTurTra)   .or.;
                    AllTrim(SRA->RA_CODFUNC) <> AllTrim(cCodFunc)  .or.;
                    AllTrim(SRA->RA_CIC)     <> AllTrim(cCPF)      .or.;
                    AllTrim(SRA->RA_RG)      <> AllTrim(cRG)

                    RecLock("SRA", .F.)

                        If AllTrim(SRA->RA_SITFOLH) <> AllTrim(cSituFolh)
                            SRA->RA_SITFOLH := cSituFolh
                        EndIf

                        If AllTrim(cSituFolh) == "D"
                            SRA->RA_DEMISSA := dDemissa
                        EndIf

                        If AllTrim(SRA->RA_DESEPS) <> AllTrim(cChkSum)
                            SRA->RA_DESEPS := cChkSum
                        EndIf

                        If AllTrim(SRA->RA_CC) <> AllTrim(cCC)
                            SRA->RA_CC := cCC
                        EndIf

                        If AllTrim(SRA->RA_TNOTRAB) <> AllTrim(cTurTra)
                            SRA->RA_TNOTRAB := cTurTra
                        EndIf

                        If AllTrim(SRA->RA_CODFUNC) <> AllTrim(cCodFunc)
                            SRA->RA_CODFUNC := cCodFunc
                        EndIf

                        If AllTrim(SRA->RA_CIC) <> AllTrim(cCPF)
                            SRA->RA_CIC := cCPF
                        EndIf

                        If AllTrim(SRA->RA_RG) <> AllTrim(cRG)
                            SRA->RA_RG := cRG
                        EndIf

                    SRA->( msUnLock() )

                    nRegsAlt++

                EndIf

            EndIf

        //EndIf

        RM->( dbSkip() )

    EndDo

    // Grv log incluidos
    If nRegsInc > 0
        logZBN("5", nRegsInc)
    EndIf

    // Grv log Alterados
    If nRegsAlt > 0
        logZBN("6", nRegsAlt)
    EndIf

    If Select("RM") > 0
        RM->( dbCloseArea() )
    EndIf
    
Return 

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 09/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fDeParaRM(cTab,cChave)

    Local xRet 
    Local cQuery  := ""
    Local cFilSRJ := ""
    Local cFilSR6 := ""
    Local cFilRCJ := ""

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

    If cTab == "SRJ"
        
        cFilSRJ := FWxFilial("SRJ")
        If !Empty(cFilSRJ)
            cFilSRJ := cFilSRA
        EndIf

        cQuery := " SELECT RJ_FUNCAO
        cQuery += " FROM " + RetSqlName("SRJ") + " (NOLOCK)
        cQuery += " WHERE RJ_FILIAL='"+cFilSRJ+"' 
        cQuery += " AND RJ_XCODRM='"+cChave+"'
        cQuery += " AND D_E_L_E_T_=''

        tcQuery cQuery New Alias "Work"

        Work->( dbGoTop() )
        If Work->( !EOF() )
            xRet := Work->RJ_FUNCAO
        Else
            //xRet := "RM"
            xRet := GetSRJ(cChave)
        EndIf
        
    ElseIf cTab == "GFILIAL"

        cQuery := " SELECT * FROM OPENQUERY ( " + cLinked + ", '
        cQuery += "				SELECT ISNULL(IDINTEGRACAO,'''') IDINTEGRACAO 
        cQuery += "				FROM [" + cSGBD + "].[DBO].[GFILIAL] AS GFILIAL WITH (NOLOCK)
        cQuery += "             WHERE CODCOLIGADA=''" + cColigada + "'' "
        cQuery += "             AND CODFILIAL=''"+AllTrim(Str(cChave))+"'' "
        cQuery += " ')

        tcQuery cQuery New Alias "Work"

        Work->( dbGoTop() )
        If Work->( !EOF() )
            xRet := Work->IDINTEGRACAO
        EndIf

        If Empty(xRet)
            xRet := AllTrim(StrZero(cChave,2))
        EndIf

        // Inclusão RCJ
        cFilRCJ := FWxFilial("RCJ")
        If !Empty(cFilRCJ)
            cFilRCJ := AllTrim(xRet)
        EndIf

        RCJ->( dbSetOrder(1) ) // RCJ_FILIAL, RCJ_CODIGO, R_E_C_N_O_, D_E_L_E_T_
        If RCJ->( !dbSeek(cFilRCJ+cProces) )
            
            RecLock("RCJ", .T.)
                RCJ->RCJ_FILIAL := cFilRCJ
                RCJ->RCJ_ORIGEM := "1"
                RCJ->RCJ_CODIGO := cProces
                RCJ->RCJ_DESCRI := "CELETISTA/ESTAGIARIO MENSAL"
            RCJ->( msUnLock() )

        EndIf

    ElseIf cTab == "SR6"

        cFilSR6 := FWxFilial("SR6")
        If !Empty(cFilSR6)
            cFilSR6 := cFilSRA
        EndIf
        
        cQuery := " SELECT R6_TURNO
        cQuery += " FROM " + RetSqlName("SR6") + " (NOLOCK)
        cQuery += " WHERE R6_FILIAL='"+cFilSR6+"' 
        cQuery += " AND R6_XCODRM='"+cChave+"'
        cQuery += " AND D_E_L_E_T_=''

        tcQuery cQuery New Alias "Work"

        Work->( dbGoTop() )
        If Work->( !EOF() )
            xRet := Work->R6_TURNO
        Else
            //xRet := "RM"
            xRet := GetSR6(cChave)
        EndIf

    ElseIf cTab == "PCODESTCIVIL"

        xRet := "C"

        cQuery := " SELECT * FROM OPENQUERY ( " + cLinked + ", '
        cQuery += "				SELECT CODINTERNO, DESCRICAO
        cQuery += "				FROM [" + cSGBD + "].[DBO].[PCODESTCIVIL] AS PCODESTCIVIL WITH (NOLOCK)
        cQuery += "             WHERE CODINTERNO=''"+cChave+"'' "
        cQuery += " ')

        tcQuery cQuery New Alias "Work"

        Work->( dbGoTop() )
        If Work->( !EOF() )
            
            xRet := Work->CODINTERNO

            If xRet == "D"     // DESQUITADO
                xRet := "Q"
            ElseIf xRet == "E" // UNIAO ESTAVEL
                xRet := "M"
            ElseIf xRet == "I" // DIVORCIADO
                xRet := "D"
            ElseIf xRet == "O" // OUTROS
                xRet := "M"
            ElseIf xRet == "P" // SEPARADO
                xRet := "Q"
            Else
                xRet := "C"
            EndIf

        EndIf

    EndIf

    If Select("Work") > 0
        Work->( dbCloseArea() )
    EndIf

Return xRet

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 29/09/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GetColigada()

    Local cRetColig := ""

    If AllTrim(FWCodEmp()) == "01"
        cRetColig := "1"
    ElseIf AllTrim(FWCodEmp()) == "02"
        cRetColig := "2"
    ElseIf AllTrim(FWCodEmp()) == "07"
        cRetColig := "3"
    ElseIf AllTrim(FWCodEmp()) == "09"
        cRetColig := "4"
    EndIf

Return cRetColig

/*/{Protheus.doc} logZBN
    Log de execução de job.
    @type  Static Function
    @author 
    @since 10/09/2020
    @version 01
/*/
Static Function logZBN(cStatus, nRegs)

    Local lLockZBN := .t.
    //Local cQuery   := ""
    Local cRotZBN  := "ADGPE001P"

    Default nRegs := 0

	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(FWxFilial("ZBN") + cRotZBN))
        lLockZBN := .F.
    EndIf

    RecLock("ZBN", lLockZBN)

        If AllTrim(cStatus) == "1" // Inicio
            ZBN_FILIAL  := FWxFilial("ZBN")
            ZBN_ROTINA	:= cRotZBN
            ZBN_DATA    := msDate()
            ZBN_HORA    := Time()
            ZBN_STATUS	:= cStatus
        EndIf

        If AllTrim(cStatus) == "2" // Fim
        
            ZBN_STATUS := cStatus
            ZBN_DATAPR := msDate()
            ZBN_HORAPR := Time()
        
        ElseIf AllTrim(cStatus) == "3" // tt lidos
        
            ZBN_DESCRI := "TT REGS A PROCESSAR " + AllTrim(Str(nRegs))
        
        ElseIf AllTrim(cStatus) == "4" // lidos
        
            ZBN_HORAIN  := Time()
            //ZBN_PERDES := "TT PROCESSADOS " + AllTrim(Str(nRegs))
            ZBN_QTDVEZ := nRegs

        ElseIf AllTrim(cStatus) == "5" // incluídos
        
            ZBN_PERIOD := "TT INCLUIDOS " + AllTrim(Str(nRegs))

        ElseIf AllTrim(cStatus) == "6" // alterados

            ZBN_PERDES := "TT ALTERADOS " + AllTrim(Str(nRegs))

        EndIf

    ZBN->( MsUnlock() )

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 05/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GetSRJ(cChave)

    Local cRet   := "RM"
    Local cQuery := ""
    Local cFilSRJ := FWxFilial("SRJ")

    If !Empty(cFilSRJ)
        cFilSRJ := cFilSRA
    EndIf

    SRJ->( dbSetOrder(1) ) // RJ_FILIAL, RJ_FUNCAO, R_E_C_N_O_, D_E_L_E_T_
    If SRJ->( dbSeek(cFilSRJ+cChave) )
        cRet := SRJ->RJ_FUNCAO
    Else

        // BUSCO DADOS DO RM
        If Select("WorkRJ") > 0
            WorkRJ->( dbCloseArea() )
        EndIf
        
        cQuery := " SELECT * FROM OPENQUERY ( " + cLinked + ", '
        cQuery += "				SELECT NOME, CBO, CBO2002
        cQuery += "				FROM [" + cSGBD + "].[DBO].[PFUNCAO] AS PFUNCAO WITH (NOLOCK)
        cQuery += "             WHERE CODCOLIGADA=''" + cColigada + "'' "
        cQuery += "             AND CODIGO=''"+cChave+"'' "
        cQuery += " ')

        tcQuery cQuery New Alias "WorkRJ"

        WorkRJ->( dbGoTop() )
        If WorkRJ->( !EOF() )

            RecLock("SRJ", .T.)
                SRJ->RJ_FILIAL := cFilSRJ
                SRJ->RJ_FUNCAO := cChave
                SRJ->RJ_DESC   := AllTrim(WorkRJ->NOME)
                SRJ->RJ_CBO    := WorkRJ->CBO
                SRJ->RJ_CODCBO := WorkRJ->CBO2002
            SRJ->( msUnLock() )

            cRet := cChave

        EndIf
    
    EndIf

    If Select("WorkRJ") > 0
        WorkRJ->( dbCloseArea() )
    EndIf

Return cRet

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 05/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GetSR6(cChave)

    Local cRet   := "RM"
    Local cQuery := ""
    Local cFilSR6 := FWxFilial("SR6")

    If !Empty(cFilSR6)
        cFilSR6 := cFilSRA
    EndIf

    SR6->( dbSetOrder(1) ) // R6_FILIAL, R6_TURNO, R_E_C_N_O_, D_E_L_E_T_
    If SR6->( dbSeek(cFilSR6+cChave) )
        cRet := SR6->R6_TURNO
    Else

        // BUSCO DADOS DO RM
        If Select("WorkR6") > 0
            WorkR6->( dbCloseArea() )
        EndIf
        
        cQuery := " SELECT * FROM OPENQUERY ( " + cLinked + ", '
        cQuery += "				SELECT DESCRICAO
        cQuery += "				FROM [" + cSGBD + "].[DBO].[AHORARIO] AS AHORARIO WITH (NOLOCK)
        cQuery += "             WHERE CODCOLIGADA=''" + cColigada + "'' "
        cQuery += "             AND CODIGO=''"+cChave+"'' "
        cQuery += " ')

        tcQuery cQuery New Alias "WorkR6"

        WorkR6->( dbGoTop() )
        If WorkR6->( !EOF() )

            RecLock("SR6", .T.)
                SR6->R6_FILIAL := cFilSR6
                SR6->R6_TURNO  := cChave
                SR6->R6_DESC   := AllTrim(WorkR6->DESCRICAO)
            SR6->( msUnLock() )

            cRet := cChave

        EndIf
    
    EndIf

    If Select("WorkR6") > 0
        WorkR6->( dbCloseArea() )
    EndIf

Return cRet

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 10/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GetFerias(cChapa)

    Local lRet   := .f.
    Local cQuery := ""
    
    If Select("D_FERIAS") > 0
		D_FERIAS->( DbCloseArea() )
	EndIf

    cQuery := " SELECT * FROM OPENQUERY ( " + cLinked + ", ' "
	cQuery += "		  SELECT PFUFERIASPER.CHAPA, "
	cQuery += "						SITUACAOFERIAS, "
	cQuery += "						DATAINICIO, "
	cQuery += "						DATAFIM "
	cQuery += "					FROM [" + cSGBD + "].[DBO].[PFUFERIASPER] AS PFUFERIASPER WITH (NOLOCK) "
	cQuery += "					INNER JOIN [" + cSGBD + "].[DBO].[PFUFERIASRECIBO] AS PFUFERIASRECIBO WITH (NOLOCK) "
	cQuery += "							ON PFUFERIASRECIBO.CODCOLIGADA = PFUFERIASPER.CODCOLIGADA "
	cQuery += "						   AND PFUFERIASRECIBO.CHAPA       = PFUFERIASPER.CHAPA "
	cQuery += "						   AND PFUFERIASRECIBO.DATAPAGTO   = PFUFERIASPER.DATAPAGTO "
	cQuery += "					     WHERE PFUFERIASPER.CODCOLIGADA    = ''" + cColigada + "'' "
	cQuery += "					       AND CONVERT(VARCHAR(8), GETDATE(), 112) BETWEEN CONVERT(VARCHAR(8), DATAINICIO, 112) AND CONVERT(VARCHAR(8), DATAFIM, 112) "
    cQuery += "					       AND PFUFERIASPER.CHAPA = ''"+AllTrim(cChapa)+"'' "
	cQuery += " ') "

	TcQuery cQuery New Alias "D_FERIAS"

    D_FERIAS->( dbGoTop() )
    If D_FERIAS->( !EOF() ) .and. AllTrim(SRA->RA_SITFOLH) <> "F"
        lRet := .t.
    EndIf

    If Select("D_FERIAS") > 0
		D_FERIAS->( DbCloseArea() )
	EndIf

Return lRet

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 10/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GetAfasta(cChapa)

    Local lRet   := .f.
    Local cQuery := ""
    
    If Select("D_AFAST") > 0
		D_AFAST->( DbCloseArea() )
	EndIf

	cQuery := " SELECT * FROM OPENQUERY ( " + cLinked + ", ' "
	cQuery += " 		SELECT        CHAPA, "
	cQuery += " 					  TIPO, "
	cQuery += " 					  DTINICIO AS DATAINICIO, "
	cQuery += " 					  DTFINAL AS DATAFIM "
	cQuery += " 				  FROM [" + cSGBD + "].[DBO].[PFHSTAFT] AS PFHSTAFT WITH (NOLOCK) "
	cQuery += " 				 WHERE CODCOLIGADA = ''" + cColigada + "'' " 
	cQuery += " 				   AND ( CONVERT(VARCHAR(8), GETDATE(), 112) BETWEEN CONVERT(VARCHAR(8), DTINICIO, 112) AND CONVERT(VARCHAR(8), DTFINAL, 112) " 
	cQuery += " 				         OR CONVERT(VARCHAR(8), DTFINAL, 112) IS NULL ) "
	cQuery += "					       AND CHAPA = ''"+AllTrim(cChapa)+"'' "
    cQuery += " ') "

	TcQuery cQuery New Alias "D_AFAST"

    D_AFAST->( dbGoTop() )
    If D_AFAST->( !EOF() ) .and. AllTrim(SRA->RA_SITFOLH) <> "A"
        lRet := .t.
    EndIf

    If Select("D_AFAST") > 0
		D_AFAST->( DbCloseArea() )
	EndIf

Return lRet

/*/{Protheus.doc} SendMail 
	Envia email com dados do PV Complemento Frango Vivo 
	@type  Static Function
	@author Fernando Macieira 
	@since 04/18/2018
	@version 01
/*/
Static Function SendMail(lAuto)

	Local cAssunto	:= "[ FUNCIONARIOS ] - JOB INTEGRACAO RM X PROTHEUS - PROCESSAMENTO DE " + DtoC(msDate()) + " - EMPRESA " + FWCodEmp()
	Local cMensagem	:= ""
	Local cQuery	:= ""
    Local cIncs     := "TT INCLUIDOS 0"
    Local cAlts     := "TT ALTERADOS 0"

    Default lAuto   := .t.

    Private cMails  := GetMV("MV_#GPEMAI",,"alex.cabral@adoro.com.br;carlos.felippe@adoro.com.br;livia.cruz@adoro.com.br;sistemas@adoro.com.br")

	cMensagem += '<html>'
	cMensagem += '<body>'
	cMensagem += '<p style="color:red">'+cValToChar(cAssunto)+'</p>'
	cMensagem += '<hr>'
	cMensagem += '<table border="1">'
	cMensagem += '<tr style="background-color: black;color:white">'

    cMensagem += '<td>Empresa</td>'
    cMensagem += '<td>Filial</td>'
	cMensagem += '<td>Data Início</td>'
	cMensagem += '<td>Hora Início</td>'
	cMensagem += '<td>Registros lidos RM</td>'
    cMensagem += '<td>Registros Processados</td>'
	cMensagem += '<td>Incluídos Protheus</td>'
	cMensagem += '<td>Atualizados Protheus</td>'
	cMensagem += '<td>Data Fim</td>'
	cMensagem += '<td>Hora Fim</td>'

	cMensagem += '</tr>'

	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf

    cQuery := " SELECT ZBN_FILIAL, ZBN_DESCRI, ZBN_DATA, ZBN_HORA, ZBN_PERIOD, ZBN_PERDES, ZBN_DATAPR, ZBN_HORAPR, ZBN_QTDVEZ
    cQuery += " FROM " + RetSqlName("ZBN") + " (NOLOCK)
    cQuery += " WHERE ZBN_ROTINA='ADGPE001P'
    cQuery += " AND ZBN_DATA='"+DtoS(msDate())+"'
    cQuery += " AND D_E_L_E_T_=''

    tcQuery cQuery New Alias "Work"

    Work->( dbGoTop() )
	Do While Work->( !EOF() )

        If "INCLUIDO" $ AllTrim(Work->ZBN_PERIOD)
            cIncs := AllTrim(Work->ZBN_PERIOD)
        EndIf

        If "ALTERADO" $ AllTrim(Work->ZBN_PERDES)
            cAlts := AllTrim(Work->ZBN_PERDES)
        EndIf

		cMensagem += '<tr>'

		cMensagem += '<td>' + cValToChar(FWCodEmp())    + '</td>'
        cMensagem += '<td>' + cValToChar(Work->ZBN_FILIAL)    + '</td>'
		cMensagem += '<td>' + cValToChar(Work->ZBN_DATA)      + '</td>'
		cMensagem += '<td>' + cValToChar(Work->ZBN_HORA)      + '</td>'
		cMensagem += '<td>' + cValToChar(Work->ZBN_DESCRI)    + '</td>'
		cMensagem += '<td>' + cValToChar(Work->ZBN_QTDVEZ)    + '</td>'
		cMensagem += '<td>' + cValToChar(cIncs)               + '</td>'
		cMensagem += '<td>' + cValToChar(cAlts)               + '</td>'
		cMensagem += '<td>' + cValToChar(Work->ZBN_DATAPR)    + '</td>'
		cMensagem += '<td>' + cValToChar(Work->ZBN_HORAPR)    + '</td>'
		
		cMensagem += '</tr>'
		
		Work->( dbSkip() )
		
	EndDo

	cMensagem += '</table>'
	cMensagem += '</body>'
	cMensagem += '</html>'

	//
	ProcessarEmail(cAssunto,cMensagem,cMails,lAuto)

	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf

Return

/*/{Protheus.doc} ProcessarEmail 
	Configurações de e-mail. 
	@type  Static Function
	@author Fernando Sigoli 
	@since 29/03/2018
	@version 01
/*/
Static Function ProcessarEmail(cAssunto,cMensagem,email,lAuto)

	Local lOk           := .T.
	Local cBody         := cMensagem
	Local cErrorMsg     := ""
	Local cServer       := Alltrim(GetMv("MV_RELSERV"))
	Local cAccount      := AllTrim(GetMv("MV_RELACNT"))
	Local cPassword     := AllTrim(GetMv("MV_RELPSW"))
	Local cFrom         := AllTrim(GetMv("MV_RELFROM")) //Por Adriana em 24/05/2019 substituido MV_RELACNT por MV_RELFROM
	Local cTo           := email
	Local lSmtpAuth     := GetMv("MV_RELAUTH",,.F.)
	Local lAutOk        := .F.
	Local cAtach        := "" //cRootPath+"\LFV\LFV.XML"
	Local cSubject      := ""

	//Assunto do e-mail.
	cSubject := cAssunto

	// Anexo
	StrTran( cAtach, "\\", "\" )

	//Conecta ao servidor SMTP.
	Connect Smtp Server cServer Account cAccount  Password cPassword Result lOk

	//
	If !lAutOk
		If ( lSmtpAuth )
			lAutOk := MailAuth(cAccount,cPassword)
		Else
			lAutOk := .T.
		EndIf
	EndIf

	//
	If lOk .And. lAutOk
		
		//Envia o e-mail.
		Send Mail From cFrom To cTo Subject cSubject Body cBody ATTACHMENT cAtach Result lOk
		
		//Tratamento de erro no envio do e-mail.
		If !lOk
			Get Mail Error cErrorMsg
			ConOut("3 - " + cErrorMsg)
			//LogMsg('ADGPE001P', FAC_FRAME_, SEV_NOTICE_, 1, '', '', '[ADGPE001P] - JOB - ' + cErrorMsg) // @history Ticket: 69945 - 25/03/2022 - Fernan Macieira - Tratamento da setagem da empresa/filial
		EndIf
		
	Else

		Get Mail Error cErrorMsg
		ConOut("4 - " + cErrorMsg)
		//LogMsg('ADGPE001P', FAC_FRAME_, SEV_NOTICE_, 1, '', '', '[ADGPE001P] - JOB - ' + cErrorMsg) // @history Ticket: 69945 - 25/03/2022 - Fernan Macieira - Tratamento da setagem da empresa/filial
		
	EndIf

	If lOk
		Disconnect Smtp Server
	EndIf

Return
