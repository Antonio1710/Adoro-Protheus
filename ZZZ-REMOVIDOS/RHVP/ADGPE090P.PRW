#Include 'Topconn.ch'
#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'Totvs.ch

Static oRegChkD   := Nil

/*/{Protheus.doc} User Function ADGPE090P
    Job para envio de informações de funcionários.
    para o AWS (ABM). Chamado 16834.
    @type  Function
    @author Everson
    @since 24/06/2022
    @version 01
    @history Everson, 09/11/2022, ticket 83210 - Adicionado envio de vínculo funcionário x rota.
    @history Everson, 23/12/2022, ticket 83210 - Adicionado envio de vínculo funcionário x rota.
    @history Everson, 28/12/2022, ticket 83210 - Ajuste na consulta RM - V5.
    @history Everson, 25/01/2023, ticket 83210 - Adicionado tratamento para não haver envio de rota sem código.
    @history Everson, 01/02/2023, ticket 83210 - Tratamento para desvincular rotas de demitidos.
    @history Everson, 17/04/2023, ticket 91883 - Tratamento para remover registro duplicados na ABM.
    @history Everson, 24/04/2023, ticket 91883 - Tratamento para remover linhas do usuário.
/*/
User Function ADGPE090P() // U_ADGPE090P()

    //Variáveis.
    Private cLinked  := ""
    Private cSGBD    := ""

    RpcClearEnv()
	RPCSetType(3)
	RpcSetEnv("01","02",,,,GetEnvServer(),{ })
        
        U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Job para envio de informações de funcionários')

        cLinked  := GetMV("MV_#RMLINK",,"RM") 
        cSGBD    := GetMV("MV_#RMSGBD",,"" + cSGBD + "")

        logZBN("1")

            processa(.T.)

        logZBN("2")

	RpcClearEnv()

Return Nil
/*/{Protheus.doc} processa
    Processa o obtenção/envio.
    @type  Static Function
    @author Everson
    @since 24/06/2022
    @version 01
/*/
Static Function processa(lAut)

    //Variáveis.
    Local cUrl      := Alltrim(cValToChar(GetMV("MV_#URLABM",,"https://abmbus.com.br:8181/api")))
    Local cChave    := Alltrim(cValToChar(GetMV("MV_#CHVABM",,"eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiJhZG9yb19hcGlAYWJtcHJvdGVnZS5jb20uYnIiLCJleHAiOjE3NTY5NTkxMTJ9.vH0awO8mbiyWeqbzjVEClDePtC95qeOX8T-2w6LiNA_HJt1I-DCLEX1EPjRRMxZyKB68qb8ZhuT8eUQa3J1wzA")))
    Local nCodEmp   := GetMV("MV_#EMPABM",,3528804)
    Local cUsrPai   := GetMV("MV_#USRABM",,95)

    oRegChkD := THashMap():New()

    obtDados(cUrl, cChave)

    envDados(nCodEmp, cUsrPai, cUrl, cChave)

    If ValType(oRegChkD) == "O"
        oRegChkD:Clean()
        FreeObj(oRegChkD)

    EndIf

Return Nil
/*/{Protheus.doc} obtDados
    Processa a obtenção de dados.
    @type  Static Function
    @author Everson
    @since 24/06/2022
    @version 01
/*/
Static function obtDados(cUrl, cChave)

    //Variáveis.
    Local aArea     := GetArea()
    Local cServico  := "/passageiro/novo/all/95"
    Local cMetodo   := "Get"
    Local cMsg      := ""
    Local oJson     := Nil
    Local nAux      := 1
    Local oObj      := Nil
    Local cMat      := ""
    Local cIdABM    := ""
    Local xVal      := ""
    Local cStatus   := ""

    If envReq(cUrl, cServico, cMetodo, cChave, "", @cMsg)

        oJson := JsonObject():new()
        oJson:fromJson(cMsg)

        For nAux := 1 To Len(oJson)

            xVal    := ""
            oObj    := oJson[nAux]
            cMat    := Alltrim(cValToChar(oObj['matricula']))
            cStatus := Upper(Alltrim(cValToChar(oObj['status'])))
            cIdABM  := obtId(oObj)

            If cStatus == "ATIVO"

                oRegChkD:Get(cMat, @xVal)

                oRegChkD:Set(cMat, cIdABM + "/" + Alltrim(cValToChar(xVal)))

            EndIf

        Next nAux

        FreeObj(oJson)
        oJson := Nil

    EndIf

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} envDados
    Processa o envio.
    @type  Static Function
    @author Everson
    @since 24/06/2022
    @version 01
/*/
Static function envDados(nCodEmp, cUsrPai, cUrl, cChave)

    //Variáveis.
    Local aArea     := GetArea()
    Local cServico  := "/passageiro"
    Local cMetodo   := "Post"
    Local cQuery    := scptSql()
    Local cAlias    := ""
    Local cBody     := ""
    Local cMsg      := ""
    Local cHash     := ""
    Local cIdABM    := ""

    cAlias := GetNextAlias()
    DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)
    DbSelectArea(cAlias)
    (cAlias)->(DbGoTop())

    If (cAlias)->(Eof())
        (cAlias)->(DbCloseArea())
        RestArea(aArea)
        Return Nil
    EndIf 

    Conout( DToC(Date()) + " " + Time() + " ADGPE090P - processa - qtd registros " + cValToChar( Contar(cAlias,"!Eof()") ) )

    (cAlias)->(DbGoTop())
    While ! (cAlias)->(Eof())
        
        cIdABM      := ""
        cMsg        := ""
        cLEntrada   := ""
        cLSaida     := ""
        
        If Empty((cAlias)->ID_ABM)
            cMetodo := "Post"
        Else
            cMetodo := "Put"

        EndIf

        If ! Empty(cValToChar((cAlias)->ID_ABM))
            U_ADGPE901(cAlias, cUrl, cServico, (cAlias)->CHAPA, cChave, nCodEmp, cUsrPai, cValToChar((cAlias)->ID_ABM))

        EndIf

        cBody := geraJson(cAlias, cMetodo, nCodEmp, cUsrPai)

        cHash := Alltrim(cValToChar(SHA1(cBody + Alltrim(cValToChar((cAlias)->CODLENTRADA)) + Alltrim(cValToChar((cAlias)->CODLSAIDA)) )))

        If cHash == Alltrim(cValToChar((cAlias)->XHASH))
            (cAlias)->(DbSkip())
            Loop

        EndIf

        //Envio do cadastro do funcionário.
        lRetEnv := envReq(cUrl, cServico, cMetodo, cChave, cBody, @cMsg)

        If ! lRetEnv
            envErros(cMsg)
            (cAlias)->(DbSkip())
            Loop

        EndIf

        cIdABM := obtId(cMsg)

        cIdABM := Alltrim(Iif(Empty(cIdABM), cValToChar((cAlias)->ID_ABM), cIdABM))
        
        //Everson - 14/04/2023 - ticket 91883.
        If cMetodo == "Post"
            tratSucess(Alltrim(cValToChar((cAlias)->CODPESSOA)), "", cIdABM) 

        EndIf

        //Everson - 09/11/2022. Ticket 83210.
        If ! Empty(cIdABM)

            lRetEnv := .T.
            
            If Alltrim(cValToChar((cAlias)->SITUACAO)) <> "Demitido" .And. Substr((cAlias)->LINHA_ENTRADA,1,1) <> "-" .And. Substr((cAlias)->LINHA_SAIDA,1,1) <> "-"
                
                cLEntrada := Substr((cAlias)->LINHA_ENTRADA,1,10)
                cLSaida   := Substr((cAlias)->LINHA_SAIDA,1,10)
                
                lRetEnv := U_ADGPE900(nCodEmp, cUsrPai, cUrl, cChave, cIdABM, cLEntrada, cLSaida, @cMsg)

            ElseIf  Alltrim(cValToChar((cAlias)->SITUACAO)) == "Demitido"

                lRetEnv := U_ADGPE900(nCodEmp, cUsrPai, cUrl, cChave, cIdABM, "", "", @cMsg)

            EndIf
            
            If ! lRetEnv
                envErros(cMsg)
                (cAlias)->(DbSkip())
                Loop

            EndIf

        EndIf

        tratSucess(Alltrim(cValToChar((cAlias)->CODPESSOA)), cHash, cIdABM)

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} obtId
    Obtém o Id da ABM da resposta.
    @type  Static Function
    @author Everson
    @since 23/12/2022
    @version 01
/*/
Static Function obtId(xMsg)

    //Variáveis.
    Local cId   := ""
    Local oJson := Nil

    If ValType(xMsg) == "J"
        cId := cValToChar(xMsg['id'])

    Else
        oJson := JsonObject():new()
        oJson:fromJson(xMsg)

        cId := cValToChar(oJson['id'])
 
        FreeObj(oJson)
        oJson := Nil
    
    EndIf

Return cId
/*/{Protheus.doc} ADGPE900
    Vincula funcionário a rota.
    @type  User Function
    @author Everson
    @since 09/11/2022
    @version 01
/*/
User Function ADGPE900(nCodEmp, cUsrPai, cUrl, cChave, cIdABM, cLEntrada, cLSaida, cMsg)

    //Variáveis.
    Local aArea     := GetArea()
    Local lRetEnv   := .F.
    Local cServico  := "/passageiro/vincula-por-codigo"
    Local cBody     := ""
    Local oJson     := Nil
    Local aRotas    := {}

    If !Empty(cLEntrada)
        Aadd(aRotas, cLEntrada)

    EndIf

    If !Empty(cLSaida)
        Aadd(aRotas, cLSaida)

    EndIf

    cBody += "["

        oJson := JsonObject():new()

        oJson['idPassageiro'] := Val(cIdABM)
        oJson['codigos']      := aRotas

        cBody += oJson:toJSON()

        FreeObj(oJson)
        oJson := Nil

    cBody += "]"

    lRetEnv := envReq(cUrl, cServico, "Post", cChave, cBody, @cMsg)

    RestArea(aArea)

Return lRetEnv
/*/{Protheus.doc} tratSucess
    Grava id da api no cadastro do funcionário.
    @type  Static Function
    @author Everson
    @since 05/07/2022
    @version 01
/*/
Static Function tratSucess(cMat, cHash, cIdABM)
    
    //Variáveis.
    Local aArea := GetArea()
    Local cUpt  := ""

    Default cHash  := ""

    Conout( DToC(Date()) + " " + Time() + " ADGPE090P - tratSucess")

    cUpt := " UPDATE OPENQUERY ( " + cLinked + ", "
    cUpt += " ' SELECT RA_XIDABM, RA_XHASH "
    cUpt += " FROM [" + cSGBD + "].[DBO].[VPCOMPL] "
    cUpt += " WHERE CODPESSOA = ''" + cMat + "'' "
    cUpt += " ' ) "      
    cUpt += " SET "
    
    cUpt += " RA_XIDABM = " + Iif(!Empty(cIdABM),"'" + cIdABM + "'", "RA_XIDABM ") + " "

    If ! Empty(cHash)
        cUpt += " , RA_XHASH = '" + cHash + "' "

    EndIf

    If TCSqlExec(cUpt) < 0
        envErros("Erro ao fazer update na tabela PFCOMPL do sistema RM " + TCSQLError())
        Conout( DToC(Date()) + " " + Time() + " ADGPE090P - tratSucess " + TCSQLError() )

    EndIf

    Conout( DToC(Date()) + " " + Time() + " ADGPE090P - tratSucess - cUpt " + cUpt )

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} scptSql
    Retorna o script Sql.
    @type  Static Function
    @author Everson
    @since 24/06/2022
    @version 01
/*/
Static Function scptSql()

    //Variáveis.
    Local cQuery := ""

    cQuery := ""
    cQuery += " SELECT " 
    cQuery += " *    " 
    cQuery += " FROM OPENQUERY(" + cLinked + ",'   " 
    cQuery += " SELECT   " 
    cQuery += " PFUNC.CODCOLIGADA,   " 
    cQuery += " GCOLIGADA.NOME             AS EMPRESA,   " 
    cQuery += " PFUNC.CODFILIAL,   " 
    cQuery += " GFILIAL.NOMEFANTASIA       AS FILIAL,   " 
    cQuery += " PFUNC.CODSECAO,   " 
    cQuery += " PSECAO.DESCRICAO           AS SECAO,   " 
    cQuery += " PFUNC.CODFUNCAO,   " 
    cQuery += " PFUNCAO.NOME               AS FUNCAO,   " 
    cQuery += " PFUNC.REGATUAL,   " 
    cQuery += " PFUNC.CHAPA,   " 
    cQuery += " PPESSOA.CODIGO             AS CODPESSOA,   " 
    cQuery += " PPESSOA.NOME,   " 
    cQuery += " PFUNC.CODHORARIO,   " 
    cQuery += " AHORARIO.DESCRICAO         AS HORARIO,   " 
    cQuery += " PFCOMPL.PTOCREDENCIAL      AS CREDENCIAL_DIMEP,   " 
    cQuery += " /*  CASE   " 
    cQuery += " WHEN PPESSOA.CANDIDATO = 1  " 
    cQuery += " AND PFUNC.CHAPA IS NULL   " 
    cQuery += " THEN ''Sim''   " 
    cQuery += " ELSE ''Não''   " 
    cQuery += " END                        AS CANDIDATO, */  " 
    cQuery += " PFUNC.DATAADMISSAO,   " 
    cQuery += " PFUNC.DATADEMISSAO,   " 
    cQuery += " DTIPORUA.DESCRICAO         AS TIPORUA,   " 
    cQuery += " PPESSOA.RUA,   " 
    cQuery += " PPESSOA.NUMERO,   " 
    cQuery += " DTIPOBAIRRO.DESCRICAO      AS TIPOBAIRRO,   " 
    cQuery += " PPESSOA.BAIRRO,   " 
    cQuery += " PPESSOA.CIDADE,   " 
    cQuery += " PPESSOA.ESTADO,   " 
    cQuery += " PPESSOA.CEP,   " 
    cQuery += " VPCOMPL.FRETENTR           AS CODLENTRADA,   " 
    cQuery += " GCONSIST.DESCRICAO         AS LINHA_ENTRADA, " 
    cQuery += " VPCOMPL.FRETSAI            AS CODLSAIDA,  " 
    cQuery += " GCONSIST2.DESCRICAO        AS LINHA_SAIDA,  " 
    cQuery += " VPCOMPL.RA_XIDABM          AS ID_ABM,   " 
    cQuery += " VPCOMPL.RA_XHASH           AS XHASH,   " 
    cQuery += " VPCOMPL.RECCREATEDON       AS CRIACAO_CPO_COMPL_PESSOA,   " 
    cQuery += " VPCOMPL.RECMODIFIEDON      AS MODIF_CPO_COMPL_PESSOA,   " 
    cQuery += " PFUNC.RECCREATEDON         AS CRIACAO_FUNC,   " 
    cQuery += " PFUNC.RECMODIFIEDON        AS MODIF_FUNC,   " 
    cQuery += " PPESSOA.RECCREATEDON       AS CRIACAO_PESSOA,   " 
    cQuery += " PPESSOA.RECMODIFIEDON      AS MODIF_PESSOA,   " 
    cQuery += " FERIAS.DATAINICIO          AS INICIO_FERIAS,   " 
    cQuery += " FERIAS.DATAFIM             AS FINAL_FERIAS,   " 
    cQuery += " AFAST.DTINICIO             AS INICIO_AFAST,   " 
    cQuery += " AFAST.DTFINAL              AS FINAL_AFAST, " 
    cQuery += " (SELECT TOP (1) DTANOTACAO " 
    cQuery += " FROM  " 
    cQuery += " [" + cSGBD + "].[DBO].[PANOTAC]  " 
    cQuery += " WHERE  " 
    cQuery += " PANOTAC.CODPESSOA = PPESSOA.CODIGO " 
    cQuery += " AND PANOTAC.TIPO = 14 " 
    cQuery += " ORDER BY PANOTAC.DTANOTACAO DESC)AS DEM_FUTURA,   " 
    cQuery += " CASE   " 
    cQuery += " WHEN AFAST.DTINICIO IS NOT NULL   " 
    cQuery += " THEN ''Afastado''   " 
    cQuery += " WHEN CONVERT(VARCHAR(10),GETDATE(),102) BETWEEN CONVERT(VARCHAR(10),FERIAS.DATAINICIO,102) AND CONVERT(VARCHAR(10),FERIAS.DATAFIM,102)   " 
    cQuery += " THEN ''Férias''      " 
    cQuery += " WHEN CONVERT(VARCHAR(10),PFUNC.DATADEMISSAO,102) <= CONVERT(VARCHAR(10),GETDATE(),102)   " 
    cQuery += " THEN ''Demitido''   " 
    cQuery += " WHEN EXISTS (SELECT TOP (1) DTANOTACAO " 
    cQuery += " FROM  " 
    cQuery += " [" + cSGBD + "].[DBO].[PANOTAC]  " 
    cQuery += " WHERE  " 
    cQuery += " PANOTAC.CODPESSOA = PPESSOA.CODIGO  " 
    cQuery += " AND PANOTAC.TIPO = 14 " 
    cQuery += " AND GETDATE() > DTANOTACAO + 1 " 
    cQuery += " ORDER BY PANOTAC.DTANOTACAO DESC)   " 
    cQuery += " THEN ''Demitido''   " 
    cQuery += " ELSE ''Ativo''   " 
    cQuery += " END AS SITUACAO   " 
    cQuery += "  " 
    cQuery += " FROM  " 
    cQuery += " [" + cSGBD + "].[DBO].[PPESSOA] " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[PFUNC] " 
    cQuery += " ON PFUNC.CODPESSOA = PPESSOA.CODIGO  " 
    cQuery += "  " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[GCOLIGADA]  " 
    cQuery += " ON PFUNC.CODCOLIGADA = GCOLIGADA.CODCOLIGADA     " 
    cQuery += "  " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[GFILIAL]  " 
    cQuery += " ON PFUNC.CODCOLIGADA = GFILIAL.CODCOLIGADA  " 
    cQuery += " AND PFUNC.CODFILIAL = GFILIAL.CODFILIAL  " 
    cQuery += "  " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[PSECAO] " 
    cQuery += " ON PFUNC.CODCOLIGADA = PSECAO.CODCOLIGADA   " 
    cQuery += " AND PFUNC.CODSECAO = PSECAO.CODIGO      " 
    cQuery += "       " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[PFUNCAO]   " 
    cQuery += " ON PFUNC.CODCOLIGADA = PFUNCAO.CODCOLIGADA   " 
    cQuery += " AND PFUNC.CODFUNCAO = PFUNCAO.CODIGO     " 
    cQuery += "      " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[PCODSITUACAO]  " 
    cQuery += " ON PFUNC.CODSITUACAO = PCODSITUACAO.CODCLIENTE     " 
    cQuery += "  " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[DTIPORUA]  " 
    cQuery += " ON PPESSOA.CODTIPORUA = DTIPORUA.CODIGO     " 
    cQuery += "  " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[DTIPOBAIRRO]  " 
    cQuery += " ON PPESSOA.CODTIPOBAIRRO = DTIPOBAIRRO.CODIGO      " 
    cQuery += "  " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[VPCOMPL] " 
    cQuery += " ON VPCOMPL.CODPESSOA = PPESSOA.CODIGO     " 
    cQuery += "  " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[AHORARIO]  " 
    cQuery += " ON PFUNC.CODCOLIGADA = AHORARIO.CODCOLIGADA  " 
    cQuery += " AND PFUNC.CODHORARIO = AHORARIO.CODIGO       " 
    cQuery += "  " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[PFCOMPL] " 
    cQuery += " ON PFUNC.CODCOLIGADA = PFCOMPL.CODCOLIGADA  " 
    cQuery += " AND PFUNC.CHAPA = PFCOMPL.CHAPA       " 
    cQuery += "  " 
    cQuery += " LEFT JOIN ( " 
    cQuery += " SELECT PFUFERIASPER.CODCOLIGADA,    " 
    cQuery += " PFUFERIASPER.CHAPA,    " 
    cQuery += " PFUFERIASPER.DATAINICIO,    " 
    cQuery += " PFUFERIASPER.DATAFIM,    " 
    cQuery += " CONVERT(VARCHAR(10),GETDATE(),102)  HOJE,    " 
    cQuery += " CONVERT(VARCHAR(10),PFUFERIASPER.DATAINICIO,102) DATAINI,    " 
    cQuery += " CONVERT(VARCHAR(10),PFUFERIASPER.DATAFIM,102) DATAFINAL       " 
    cQuery += " FROM  " 
    cQuery += " [" + cSGBD + "].[DBO].[PFUFERIASPER] " 
    cQuery += "  " 
    cQuery += " WHERE  " 
    cQuery += " CONVERT(VARCHAR(10),PFUFERIASPER.DATAINICIO,102) = CONVERT(VARCHAR(10),GETDATE(),102))  AS FERIAS " 
    cQuery += " ON PFUNC.CODCOLIGADA = FERIAS.CODCOLIGADA    " 
    cQuery += " AND PFUNC.CHAPA = FERIAS.CHAPA     " 
    cQuery += "  " 
    cQuery += " LEFT JOIN  ( " 
    cQuery += " SELECT PFHSTAFT.CODCOLIGADA,    " 
    cQuery += " PFHSTAFT.CHAPA,    " 
    cQuery += " PFHSTAFT.DTINICIO,    " 
    cQuery += " PFHSTAFT.DTFINAL       " 
    cQuery += "  " 
    cQuery += " FROM   " 
    cQuery += " [" + cSGBD + "].[DBO].[PFHSTAFT]     " 
    cQuery += "  " 
    cQuery += " WHERE  " 
    cQuery += " GETDATE() BETWEEN PFHSTAFT.DTINICIO  " 
    cQuery += " AND ISNULL(PFHSTAFT.DTFINAL,''2999-12-31 23:59:59'') ) AS AFAST    " 
    cQuery += " ON AFAST.CODCOLIGADA = PFUNC.CODCOLIGADA    " 
    cQuery += " AND AFAST.CHAPA = PFUNC.CHAPA  " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[GCONSIST] " 
    cQuery += " ON PFUNC.CODCOLIGADA = GCONSIST.CODCOLIGADA " 
    cQuery += " AND VPCOMPL.FRETENTR = GCONSIST.CODINTERNO " 
    cQuery += " AND GCONSIST.CODTABELA = ''FRETENTR'' " 
    cQuery += "  " 
    cQuery += " LEFT JOIN  " 
    cQuery += " [" + cSGBD + "].[DBO].[GCONSIST] AS GCONSIST2 " 
    cQuery += " ON PFUNC.CODCOLIGADA = GCONSIST2.CODCOLIGADA " 
    cQuery += " AND VPCOMPL.FRETSAI = GCONSIST2.CODINTERNO " 
    cQuery += " AND GCONSIST2.CODTABELA = ''FRETSAI''        " 
    cQuery += " WHERE  " 
    cQuery += " VPCOMPL.FRETENTR IS NOT NULL " 
    cQuery += " AND  (PFUNC.CODSITUACAO <> ''D'' OR CONVERT(VARCHAR(10),PFUNC.DATADEMISSAO,102) BETWEEN CONVERT(VARCHAR(10),GETDATE()-7,102) AND CONVERT(VARCHAR(10),GETDATE(),102)) " 
    cQuery += " /* " 
    cQuery += " AND (CONVERT(VARCHAR(10),PPESSOA.RECMODIFIEDON,102) = CONVERT(VARCHAR(10),GETDATE(),102) OR CONVERT(VARCHAR(10),PPESSOA.RECCREATEDON,102) = CONVERT(VARCHAR(10),GETDATE(),102) OR CONVERT(VARCHAR(10),PFUNC.RECMODIFIEDON,102) = CONVERT(VARCHAR(10),GETDATE(),102) OR CONVERT(VARCHAR(10),PFUNC.RECCREATEDON,102) = CONVERT(VARCHAR(10),GETDATE(),102) OR CONVERT(VARCHAR(10),VPCOMPL.RECMODIFIEDON,102) = CONVERT(VARCHAR(10),GETDATE(),102) OR CONVERT(VARCHAR(10),VPCOMPL.RECCREATEDON,102) = CONVERT(VARCHAR(10),GETDATE(),102)))    " 
    cQuery += " AND PFCOMPL.FRETADO IS NOT NULL*/ " 
    cQuery += " ORDER BY  " 
    cQuery += " PFUNC.CODCOLIGADA, " 
    cQuery += " PFUNC.CHAPA " 
    cQuery += "  " 
    cQuery += " ') " 
    
    cQuery += " WHERE CHAPA IS NOT NULL AND CHAPA <> '' " 

    // cQuery += " WHERE SITUACAO = 'Demitido' " 

    // cQuery += " WHERE CHAPA = '02020039' " 

    Conout( DToC(Date()) + " " + Time() + " ADGPE090P - scptSql - cQuery " + cValToChar(cQuery) )
    
Return cQuery

/*/{Protheus.doc} geraJson
    Gera json.
    @type  Static Function
    @author Everson
    @since 24/06/2022
    @version 01
/*/
Static Function geraJson(cAlias, cMetodo, nCodEmp, cUsrPai, lInativa, cIdABM)

    //Variáveis.
    Local aArea     := GetArea()
    Local oJson     := JsonObject():new()
    Local oEmp      := JsonObject():new()
    Local oUsrPai   := JsonObject():new()
    Local cJson     := ""

    Default lInativa := .F.

    oEmp['id']      := nCodEmp
    oUsrPai['id']   := cUsrPai

    If cMetodo == "Put"
        oJson['id']        := Iif(! lInativa, Val(cValToChar((cAlias)->ID_ABM)), Val(cIdABM))

    EndIf

    oJson['nome']       := U_ADFAT50O(Alltrim(cValToChar((cAlias)->NOME)))
    oJson['endereco']   := U_ADFAT50O(Alltrim(cValToChar((cAlias)->RUA))) + ", " + U_ADFAT50O(Alltrim(cValToChar((cAlias)->NUMERO))) + ", " + U_ADFAT50O(Alltrim(cValToChar((cAlias)->BAIRRO))) + ", " +  U_ADFAT50O(Alltrim(cValToChar((cAlias)->CIDADE))) + ", " + U_ADFAT50O(Alltrim(cValToChar((cAlias)->ESTADO))) + ", " + U_ADFAT50O(Alltrim(cValToChar((cAlias)->CEP)))
    oJson['matricula']  := Iif(Empty(Alltrim(cValToChar((cAlias)->CHAPA))), Alltrim(cValToChar((cAlias)->CODPESSOA)), Alltrim(cValToChar((cAlias)->CHAPA)))
    oJson['cargo']      := U_ADFAT50O(Alltrim(cValToChar((cAlias)->FUNCAO)))
    oJson['empresa']    := oEmp
    oJson['usuarioPai'] := oUsrPai

    If ! lInativa
        oJson['status']     := iif(Alltrim(cValToChar((cAlias)->SITUACAO)) == "Ativo", 1, Iif(Alltrim(cValToChar((cAlias)->SITUACAO)) == "Demitido", 2, 3))

    Else
        oJson['status']     := 2

    EndIf

    oJson['rfid']       := U_ADFAT50O(Alltrim(cValToChar((cAlias)->CREDENCIAL_DIMEP)))
    oJson['cidade']     := U_ADFAT50O(Alltrim(cValToChar((cAlias)->CIDADE)))
    oJson['bairro']     := U_ADFAT50O(Alltrim(cValToChar((cAlias)->BAIRRO)))
    oJson['estado']     := U_ADFAT50O(Alltrim(cValToChar((cAlias)->ESTADO)))
    oJson['entrada']    := Alltrim(cValToChar((cAlias)->CODLENTRADA))
    oJson['saida']      := Alltrim(cValToChar((cAlias)->CODLSAIDA))

    cJson := oJson:toJSON()

    Conout( DToC(Date()) + " " + Time() + " ADGPE090P - geraJson - cJson " + cJson )

    FreeObj(oJson)
    oJson := Nil

    FreeObj(oEmp)
    oEmp := Nil

    FreeObj(oUsrPai)
    oUsrPai := Nil

    RestArea(aArea)

Return cJson
/*/{Protheus.doc} envReq
    Envia requisição.
    @type  Static Function
    @author Everson
    @since 24/06/2022
    @version 01
/*/
Static Function envReq(cUrl, cServico, cMetodo, cChave, cBodyRq, cMsg)

    //Variáveis.
	Local aArea 		:= GetArea()
	Local lRet			:= .T.
	Local oRestClient 	:= Nil
	Local lRest			:= .F.

    Private aHeader	:= {}
    Private cBody       := cBodyRq

	Default cServico	:= ""
	Default cBody		:= ""
	Default cMsg		:= ""
	Default aResponse	:= {}

    Aadd(aHeader, "Content-Type: application/json")
	Aadd(aHeader, "Authorization: " + cChave)

	oRestClient := FWRest():New(cUrl)
	oRestClient:setPath(cServico)

    If cMetodo == "Post"
        oRestClient:SetPostParams(cBody)
        lRest := oRestClient:Post(aHeader)

    ElseIf cMetodo == "Put"
        lRest := oRestClient:Put(aHeader, cBody)

    ElseIf cMetodo == "Get"
        lRest := oRestClient:Get(aHeader)

    Endif

	cMsg := ""

	If ! lRest

		If Substr(Alltrim(cValToChar(oRestClient:GetLastError())),1,1) <> "2" 

			cMsg := Alltrim(cValToChar(oRestClient:GetLastError())) + Chr(13) + Chr(10)
			cMsg += "URL: "      + cUrl + Chr(13) + Chr(10)
			cMsg += "EndPoint: " + cServico + Chr(13) + Chr(10)
			cMsg += "Método: "   + cMetodo + Chr(13) + Chr(10)
			cMsg += "Body: "     + Chr(13) + Chr(10) + cValToChar(cBody) + Chr(13) + Chr(10)
			cMsg += "Resp: "     + Chr(13) + Chr(10) + Alltrim(cValToChar(oRestClient:GetResult())) + Chr(13) + Chr(10)
			lRet := .F.

		EndIf

	EndIf
	
	If lRet 
        cMsg := Alltrim(cValToChar(oRestClient:GetResult()))

	EndIf

	FreeObj(oRestClient)
	oRestClient := Nil
	RestArea(aArea)

Return lRet
/*/{Protheus.doc} envErros
    Gera log de erro.
    @type  Static Function
    @author Everson
    @since 24/06/2022
    @version 01
/*/
Static Function envErros(cMsg)

    //Variáveis.
    Local aArea := GetArea()
    Local cPara := GetMv("MV_#EAWS",,"")//"everson.silva@adoro.com.br"

	Conout( DToC(Date()) + " " + Time() + " ADGPE090P - envErros - cMsg " + cMsg)
	U_enviarEmail(cPara,"Erro Integração - ABM", "ADGPE090P - envErros" + Chr(13) + Chr(10) + cMsg)

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} logZBN
    Gera log do Job na tabela ZBN.
    @type  Static Function
    @author Everson
    @since 24/06/2022
    @version 01
/*/
Static Function logZBN(cStatus)

    //Variáveis.
	Local aArea	:= GetArea()

	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADGPE090P'))

		RecLock("ZBN",.F.)

            ZBN_FILIAL  := xFilial("ZBN")
            ZBN_DATA    := Date()
            ZBN_HORA    := cValToChar(Time())
            ZBN_ROTINA	:= 'ADGPE090P'
            ZBN_STATUS	:= cStatus

		MsUnlock() 

	Else

		RecLock("ZBN",.T.)

            ZBN_FILIAL  := xFilial("ZBN")
            ZBN_DATA    := Date()
            ZBN_HORA    := cValToChar(Time())
            ZBN_ROTINA	:= 'ADGPE090P'
            ZBN_STATUS	:= cStatus

		MsUnlock() 	

	EndIf

	ZBN->(dbCloseArea())

	RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADGPE901
    Inativa regitros duplicados.
    @type Function
    @author Everson
    @since 14/04/2023
    @version 01
/*/
User Function ADGPE901(cAlias, cUrl, cServico, cMat, cChave, nCodEmp, cUsrPai, cIdABM)

    //Variáveis.
    Local aArea     := GetArea()
    Local cCodDpc   := ""
    Local xVal      := ""
    Local aDados    := {}
    Local nAux      := 1
    Local cBody     := ""
    Local cMsg      := ""

    cMat   := Alltrim(cValToChar(cMat))
    cIdABM := Alltrim(cValToChar(cIdABM))

    oRegChkD:Get(cMat, @xVal)

    aDados := Separa(xVal, "/", .F.)

    //Inativa registro duplicados.
    For nAux := 1 To Len(aDados)

        cMsg := ""

        cCodDpc := Alltrim(cValToChar(aDados[nAux]))

        If cCodDpc <> cIdABM

            cBody := geraJson(cAlias, "Put", nCodEmp, cUsrPai, .T., cCodDpc)

            //Envio do cadastro do funcionário.
            lRetEnv := envReq(cUrl, cServico, "Put", cChave, cBody, @cMsg)


            If ! lRetEnv
                envErros(cMsg)
                Loop

            EndIf

            //Remove linha.
            lRetEnv := U_ADGPE900(nCodEmp, cUsrPai, cUrl, cChave, cCodDpc, "", "", @cMsg)

            If ! lRetEnv
                envErros(cMsg)

            EndIf

        EndIf

    Next nAux

    RestArea(aArea)
    
Return Nil
