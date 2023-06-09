#Include "Protheus.ch"
#include 'Fileio.ch'
#Include 'Totvs.ch'
#Include 'Restful.ch'
#Include 'Topconn.ch' 

/*/{Protheus.doc} Everson Function ADEST079P
    Rotina para lan�amento autom�tico de solicita��o ao armaz�m referente ao consumo de combust�vel em Rio Claro.
    Chamado 75260.
    @type  Function
    @author Everson
    @since 23/06/2022
    @version 01
/*/
User Function ADEST079P() // U_ADEST079P()

    //Vari�veis.
    Private cLinkedServer := ""

    RpcClearEnv()
    RPCSetType(3)
	RpcSetEnv("01","04",,,,GetEnvServer(),{ })

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Requisi��o de abastecimento')

    Sleep(Random(0, 7)*1000)

    DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADEST079P'))

        If ZBN->ZBN_STATUS == "2" .Or. ( ZBN->ZBN_STATUS == "1" .And. ( ZBN->ZBN_DATA < Date() .Or. ElapTime(ZBN->ZBN_HORA, Time()) > "00:10:00" ))

            cLinkedServer := Alltrim(cValToChar(GetMv("MV_#LKSWRC",,"")))

            Conout( DToC(Date()) + " " + Time() + " ADEST079P - In�cio - " )
            logZBN("1")
            logZBE("ADEST079P - In�cio")

            //Importa os dados do WinFleet.
            impDados()

            //Gera solicita��o ao armaz�m.
            gerSolic()

            //Gera pr�-requisi��o ao armaz�m.
            gerPreReq()

            //Baixa solicita��o ao armaz�m.
            baxSolic() 

            logZBE("ADEST079P - Fim")

            logZBN("2")
            Conout( DToC(Date()) + " " + Time() + " ADEST079P - Fim" )

        EndIf

    EndIf

    RpcClearEnv()

Return Nil
/*/{Protheus.doc} impDados
    Importa dados de abastecimento para o Protheus.
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function impDados()

    //Vari�veis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local cNumReg   := ""

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - impDados - In�cio importa��o de dados." )
    logZBE("ADEST079P - impDados - In�cio importa��o de dados.")

    cQuery := scriptWinFl()

    If Select("D_DADOS") > 0
        D_DADOS->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_DADOS"
    DbSelectArea("D_DADOS")
    D_DADOS->(DbGoTop())

    While ! D_DADOS->(Eof())

        cNumReg := Alltrim(cValToChar(D_DADOS->ABASEQ))

        DbSelectArea("ZBB")
        ZBB->(DbSetOrder(3))
        ZBB->(DbGoTop())
        If ZBB->(DbSeek( FWxFilial("ZBB") + "C" + cNumReg ))

            If ZBB->ZBB_ESTOQU == .F.

                Reclock("ZBB",.F.)
                
                    ZBB->ZBB_DTINI  := SToD(StrTran(Alltrim(D_DADOS->DATALIB),"-",""))
                    ZBB->ZBB_HRINI  := D_DADOS->HRLB
                    ZBB->ZBB_DTFIM  := SToD(StrTran(Alltrim(D_DADOS->DATA),"-",""))
                    ZBB->ZBB_HRFIM  := D_DADOS->HR
                    ZBB->ZBB_VOLUME := D_DADOS->QTD
                    ZBB->ZBB_PLACA  := D_DADOS->VEICULO
                    ZBB->ZBB_PLAORI := D_DADOS->VEICULO
                    ZBB->ZBB_SISTEM := "C" 
                    ZBB->ZBB_CCWINF := Alltrim(cValToChar(D_DADOS->EMPRESA))

                ZBB->(MsUnlock())

            EndIf

            logZBE("Alterou ZBB " + cNumReg)

        Else
            CONOUT(StrTran(Alltrim(D_DADOS->DATALIB),"-",""))
            CONOUT(StrTran(Alltrim(D_DADOS->DATA),"-",""))
       
            Reclock("ZBB",.T.)
            
                ZBB->ZBB_IDABAS := cNumReg
                ZBB->ZBB_DTINI  := SToD(StrTran(Alltrim(D_DADOS->DATALIB),"-",""))
                ZBB->ZBB_HRINI  := D_DADOS->HRLB
                ZBB->ZBB_DTFIM  := SToD(StrTran(Alltrim(D_DADOS->DATA),"-",""))
                ZBB->ZBB_HRFIM  := D_DADOS->HR
                ZBB->ZBB_VOLUME := D_DADOS->QTD
                ZBB->ZBB_PLACA  := D_DADOS->VEICULO
                ZBB->ZBB_PLAORI := D_DADOS->VEICULO
                ZBB->ZBB_SISTEM := "C" 
                ZBB->ZBB_CCWINF := Alltrim(cValToChar(D_DADOS->EMPRESA))
                ZBB->ZBB_BOMBA  := "S10"
                ZBB->ZBB_ESTOQU := .F.
                ZBB->ZBB_LOGIST := .F.
                ZBB->ZBB_CTAPLU := .F.
                                    
            ZBB->(MsUnlock()) 

            logZBE("Incluiu ZBB " + cNumReg)

        EndIf

        D_DADOS->(DbSkip())

    End

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - impDados - Fim importa��o de dados." )
    logZBE("ADEST079P - impDados - Fim importa��o de dados.")

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} scriptWinFl
    (long_description)
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function scriptWinFl()

    //Vari�veis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local nMaxProt  := getMaxPro()
    
    cQuery := " SELECT EMPRESA, CAST(DATALIB AS VARCHAR) AS DATALIB, CAST(HORALIB AS VARCHAR) AS HRLB, CAST(DATA AS VARCHAR) AS DATA, CAST(HORA AS VARCHAR) AS HR, VEICULO, ABASEQ, QTD, ENCERRANTE FROM "
    cQuery += " OPENQUERY(" + cLinkedServer + ",'SELECT EMPRESA, DATALIB, DATA, HORALIB, HORA, VEICULO, ABASEQ, QTD, ENCERRANTE FROM ABASTECIMENTOS WHERE  ABASEQ > " + cValToChar(nMaxProt) + " ORDER BY ABASEQ ') "

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - scriptWinFl - cQuery " + cQuery )

    RestArea(aArea)

Return cQuery
/*/{Protheus.doc} getMaxPro
    Obt�m o �ltimo registro de abastecimento WinFleet no Protheus.
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function getMaxPro()

    //Vari�veis.
	Local aArea	 := GetArea()
    Local cQuery := ""
    Local nMax   := 0

    //
    //cQuery := " SELECT ISNULL(MAX(ZBB_IDABAS),0) AS ZBB_IDABAS FROM " + RetSqlName("ZBB") + " (NOLOCK) AS ZBB WHERE ZBB_FILIAL = '" + FWxFilial("ZBB") + "' AND ZBB_SISTEM = 'C' AND ZBB.D_E_L_E_T_ = '' "

    cQuery := " SELECT ISNULL(MAX(CAST(ZBB_IDABAS AS INTEGER)),0) AS ZBB_IDABAS FROM " + RetSqlName("ZBB") + " (NOLOCK) AS ZBB WHERE ZBB_SISTEM = 'C' AND ZBB.D_E_L_E_T_ = '' "

    //
    TcQuery cQuery New Alias "MAX_PROTH"
    DbSelectArea("MAX_PROTH")
    MAX_PROTH->(DbGoTop())
        nMax := Val(cValToChar(MAX_PROTH->ZBB_IDABAS))
    MAX_PROTH->(DbCloseArea())

    //
    RestArea(aArea)

Return nMax
/*/{Protheus.doc} gerSolic
    Processa registros.
    @type  Static processa
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function gerSolic()

    //Vari�veis.
    Local aArea     := GetArea()
    Local aAreaMS   := {}
    Local cNumReg   := ""
    Local cProd     := GetMv("MV_#DIESEL")
    Local nQtd      := 0
    Local aCC       := Separa(Alltrim(GetMv("MV_#CDIESE")),"/",.T.)
    Local cCC       := ""
    Local cObs      := ""
    Local aCab      := {}
    Local aItens    := {}
    Local cNumero   := ""
    Local cQuery    := ""
    Local nRecZBB   := 0
    Local cErro     := ""
    Local aErroLog  := {}
    Local cMsgErro  := ""

    Private lMsErroAuto := .F.
    Private lMsHelpAuto := .T.

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - gerSolic - In�cio gera��o de solicita��o ao armaz�m." )
    logZBE("ADEST079P - gerSolic - In�cio gera��o de solicita��o ao armaz�m.")

    cQuery := scriptSolic()

    If Select("D_DADOS") > 0
        D_DADOS->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_DADOS"
    DbSelectArea("D_DADOS")
    D_DADOS->(DbGoTop())

    While ! D_DADOS->(Eof())

        cNumero := ""
        cMsgErro:= ""
        aCab    := {}
        aItens  := {}
        nRecZBB := Val(cValToChar(D_DADOS->REC))
        cNumReg := Alltrim(cValToChar(D_DADOS->ZBB_IDABAS))

        Sleep(Random(0, 10)*1000)

        cNumero := getNumSA(cNumReg)

        If ! Empty(cNumero) //Everson, 06/04/2022 - Ticket - 70330.
            D_DADOS->(DbSkip())
            Loop

        EndIf

        cNumero := ""
        cCC     := aCC[Val(cValToChar(D_DADOS->ZBB_CCWINF))]
        nQtd    := Val(cValToChar(D_DADOS->ZBB_VOLUME))
        cObs    := cNumReg + " " + Alltrim(cValToChar(D_DADOS->ZBB_PLACA)) + " " + Alltrim(D_DADOS->ZBB_DTFIM) + " " + Alltrim(cValToChar(D_DADOS->ZBB_HRFIM))

        Conout( DToC(Date()) + " " + Time() + " ADEST079P - cCC " + cCC )
        Conout( DToC(Date()) + " " + Time() + " ADEST079P - ADEST079P " + cObs )

        DbSelectArea( "SB1" )
        SB1->( DbSetOrder( 1 ) )
        ddatabase := SToD(Alltrim(D_DADOS->ZBB_DTFIM))

        aCab := {}
        //Aadd( aCab, { "CP_NUM"     ,cNumero  , Nil }) //Everson - 23/06/2022. Chamado 053926.
        Aadd( aCab, { "CP_EMISSAO" ,SToD(Alltrim(D_DADOS->ZBB_DTFIM)), Nil })

        aItens := {}
        Aadd( aItens, {} )
        Aadd( aItens[ Len( aItens ) ],{"CP_ITEM"    ,"01"     , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_PRODUTO" ,cProd    , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_CC"      ,cCC      , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_QUANT"   ,nQtd     , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_OBS"     ,cObs     , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_XCOMBUS" ,cNumReg  , Nil } )
        Aadd( aItens[ Len( aItens ) ],{"CP_XSISCOM" ,"C"      , Nil } )

        SB1->( DbSetOrder( 1 ) )
        SCP->( DbSetOrder( 1 ) )

        VarInfo("aCab"  ,aCab)
        VarInfo("aItens",aItens)

        lMsErroAuto := .F.
        lMsHelpAuto	:= .T.

        Private n := 1

        Sleep(Random(0, 5)*1000)

        Begin Transaction 

            aAreaMS := GetArea()
            MsExecAuto( { | x, y, z | Mata105( x, y , z ) }, aCab, aItens , 3 )
            RestArea(aAreaMS)

            cErro    := ""
            aErroLog := {}
            
            If lMsErroAuto
               
                aErroLog := GetAutoGrLog()

                If Len(aErroLog) > 0

                    cErro += EncodeUtf8(StrTran(StrTran(Alltrim(cValToChar(aErroLog[1])),Chr(13),""),Chr(10),""))

                EndIf

                logZBE("gerSolic - Erro gera��o solicita��o " + cValToChar(cNumReg) + " " + cErro)

            Else

                cNumero := getNumSA(cNumReg) //Everson - 23/06/2022. Chamado 053926.

                If ! Empty(cNumero) //Everson - 23/06/2022. Chamado 053926.
                    DbSelectArea("ZBB")
                    ZBB->(DbGoTo(nRecZBB))

                    If ! Empty(Alltrim(cValToChar(ZBB->ZBB_NUMSA))) //Everson, 06/04/2022 - Ticket - 70330 .
                        cMsgErro := "O Id " + cNumReg + " j� possui a ordem " + ZBB->ZBB_NUMSA + " vinculada "
                        DisarmTransaction()
                        Break

                    EndIf

                    RecLock("ZBB",.F.)
                        ZBB->ZBB_ESTOQU := .T.
                        ZBB->ZBB_NUMSA  := cNumero
                    ZBB->(MsUnlock())

                    logZBE("Incluiu SCP / ID ABAST" + cNumero + " / " + cNumReg)

                Else
                    cMsgErro := "N�o houve retorno da consulta com a SA"
                    DisarmTransaction()
                    Break

                EndIf

            EndIf

        End Transaction 

        If ! Empty(cMsgErro)
            logZBE(cMsgErro)

        EndIf

        D_DADOS->(DbSkip())

    End

    ddatabase := Date()

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - gerSolic - Fim gera��o de solicita��o ao armaz�m.")
    logZBE("ADEST079P - gerSolic - Fim gera��o de solicita��o ao armaz�m.")

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function getNumSA(cNumReg)

    //Vari�veis.
	Local aArea	 := GetArea()
    Local cNum   := ""
    Local cQuery := ""

    cNumReg := Alltrim(cValToChar(cNumReg))

    cQuery := ""
    cQuery += " SELECT  " 
    cQuery += " CP_NUM  " 
    cQuery += " FROM  " 
    cQuery += " " + RetSqlName("SCP") + " (NOLOCK) AS SCP " 
    cQuery += " WHERE " 
    cQuery += " CP_FILIAL = '" + FWxFilial("SCP") +  "' " 
    cQuery += " AND CP_XCOMBUS = '" + cNumReg + "' " 
    cQuery += " AND SCP.D_E_L_E_T_ = '' " 

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - getNumSA - cQuery " + cQuery )

    If Select("D_NUMSA") > 0
        D_NUMSA->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_NUMSA"
    DbSelectArea("D_NUMSA")
    D_NUMSA->(DbGoTop())
    If ! D_NUMSA->(Eof())
        cNum := D_NUMSA->CP_NUM

    EndIf
    D_NUMSA->(DbCloseArea())

    RestArea(aArea)

Return cNum
/*/{Protheus.doc} scriptSolic
    (long_description)
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function scriptSolic()

    //Vari�veis.
	Local aArea	 := GetArea()
    Local cQuery := ""

    cQuery := ""
    cQuery += " SELECT " 
    cQuery += "  CAST(ZBB_IDABAS AS INTEGER)  ZBB_IDABAS, " 
    cQuery += " ZBB_CCWINF, " 
    cQuery += " ZBB_PLACA, " 
    cQuery += " ZBB_DTFIM, " 
    cQuery += " ZBB_HRFIM, " 
    cQuery += " ZBB_VOLUME, " 
    cQuery += " ZBB.R_E_C_N_O_ AS REC " 
    cQuery += " FROM " 
    cQuery += " " + RetSqlName("ZBB") + " (NOLOCK) AS ZBB " 
    cQuery += " WHERE " 
    cQuery += " ZBB_FILIAL = '" + FWxFilial("ZBB") + "' " 
    cQuery += " AND ZBB_ESTOQU = 'F' " 
    cQuery += " AND ZBB_SISTEM IN ('C','D') " 
    cQuery += " AND ZBB_APRMOV  = '' "  
    cQuery += " AND LEN(ZBB_PLACA) > 6 "
    cQuery += " AND ZBB.D_E_L_E_T_ = '' "
    cQuery += " ORDER BY 1  " 

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - scriptSolic - cQuery " + cQuery )

    RestArea(aArea)
    
Return cQuery
/*/{Protheus.doc} gerPreReq
    Gera pr�-requisi��o ao armaz�m.
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function gerPreReq()

    //Vari�veis.
    Local aArea         := GetArea()
    Local cFiltraSCP    := " CP_XSISCOM = 'C' "

    Pergunte("MTA106",.F.)

    PARAMIXB1   := .F.
    PARAMIXB2   := MV_PAR01==1
    PARAMIXB3   := If(Empty(cFiltraSCP), {|| .T.}, {|| &cFiltraSCP})
    PARAMIXB4   := MV_PAR02==1
    PARAMIXB5   := MV_PAR03==1
    PARAMIXB6   := MV_PAR04==1
    PARAMIXB7   := MV_PAR05
    PARAMIXB8   := MV_PAR06
    PARAMIXB9   := MV_PAR07==1
    PARAMIXB10  := MV_PAR08==1
    PARAMIXB11  := MV_PAR09
    PARAMIXB12  := .T.
    MaSAPreReq(PARAMIXB1,PARAMIXB2,PARAMIXB3,PARAMIXB4,PARAMIXB5,PARAMIXB6,PARAMIXB7,PARAMIXB8,PARAMIXB9,PARAMIXB10,PARAMIXB11,PARAMIXB12)   

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} baxSolic
    Baixa solicita��o ao armaz�m.
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function baxSolic() 

    //Vari�veis.
    Local aArea         := GetArea()
    Local aAreaMS       := {}
    Local cQuery        := scriptBaix()
    Local aCamposSCP    := {}
    Local aCamposSD3    := {}
    Local cTpMov        := Alltrim(cValToChar(GetMv("MV_#TPMVBX")))
    Local cErro         := ""

    Private lMsErroAuto := .F.
    Private lMsHelpAuto	:= .T.

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - baxSolic - In�cio baixa gera��o de solicita��o ao armaz�m." )
    logZBE("ADEST079P - gerSolic - In�cio baixa de solicita��o ao armaz�m.")

    If Select("D_BAIXAS") > 0
        D_BAIXAS->(DbCloseArea())

    EndIf

    TcQuery cQuery New Alias "D_BAIXAS"
    DbSelectArea("D_BAIXAS")
    D_BAIXAS->(DbGoTop())
    If D_BAIXAS->(Eof())
        D_BAIXAS->(DbCloseArea())
        RestArea(aArea)
        Return Nil 

    EndIf 

    DbSelectArea("SCP")
    SCP->(DbSetOrder(1))

    While ! D_BAIXAS->(Eof())

        ddatabase := SToD(D_BAIXAS->CP_EMISSAO)

        aCamposSCP := {{"CP_NUM"  ,D_BAIXAS->CP_NUM   ,Nil},;
                       {"CP_ITEM" ,D_BAIXAS->CP_ITEM  ,Nil},;
                       {"CP_QUANT",D_BAIXAS->CP_QUANT ,Nil}}

        aCamposSD3 := {{"D3_TM"      ,cTpMov              ,Nil},; // Tipo do Mov.
                       {"D3_COD"     ,D_BAIXAS->CP_PRODUTO,Nil},;
                       {"D3_LOCAL"   ,D_BAIXAS->CP_LOCAL  ,Nil},;
                       {"D3_DOC"     ,D_BAIXAS->CP_NUM    ,Nil},; // No.do Docto.
                       {"D3_NUMSA"   ,D_BAIXAS->CP_NUM    ,Nil},; // No.do solicita��o.
                       {"D3_EMISSAO" ,SToD(D_BAIXAS->CP_EMISSAO),Nil}}
        
        lMsHelpAuto	:= .T.
        lMsErroAuto := .F.

        VarInfo("aCamposSCP",aCamposSCP)
        VarInfo("aCamposSD3",aCamposSD3)

        aAreaMS := GetArea()
        MSExecAuto({|v,x,y| MATA185(v,x,y)},aCamposSCP,aCamposSD3,1)
        RestArea(aAreaMS)

        cErro    := ""
        aErroLog := {}
        If lMsErroAuto
        
            aErroLog := GetAutoGrLog()

            If Len(aErroLog) > 0

                cErro += EncodeUtf8(StrTran(StrTran(Alltrim(cValToChar(aErroLog[1])),Chr(13),""),Chr(10),""))

            EndIf

            logZBE("baxSolic - Erro baixa " + cValToChar(D_BAIXAS->CP_NUM ) + " " + cErro)
            VarInfo("aErroLog",aErroLog)

        Else

            logZBE("baxSolic - baixa " + cValToChar(D_BAIXAS->CP_NUM ) )

        EndIf

        D_BAIXAS->(DbSkip())

    End

    D_BAIXAS->(DbCloseArea())

    ddatabase := Date()

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - baxSolic - Fim baixa gera��o de solicita��o ao armaz�m." )
    logZBE("ADEST079P - gerSolic - Fim baixa de solicita��o ao armaz�m.")

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} scriptBaix
    Script sql com solicita��es pendentes de baixa.
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function scriptBaix()

    //Vari�veis.
    Local aArea := GetArea()
    Local cQuery:= ""
    
    cQuery := " SELECT CP_NUM, CP_ITEM, CP_QUANT, CP_PRODUTO, CP_LOCAL, CP_EMISSAO "
    cQuery += " FROM " 
    cQuery += " " + RetSqlName("SCP") + " "
    cQuery += " (NOLOCK) AS SCP "
    cQuery += " WHERE CP_FILIAL = '" + FWxFilial("SCP") + "' "
    cQuery += " AND CP_STATUS = '' " 
    cQuery += " AND CP_XSISCOM = 'C' "
    cQuery += " AND SCP.D_E_L_E_T_ = '' "
    cQuery += " ORDER BY CP_NUM "

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - scriptBaix - cQuery " + cQuery )

    RestArea(aArea)

Return cQuery
/*/{Protheus.doc} fechReg
    Realiza fechamento do registro no WinFleet.
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function fechReg(cNumReg,lFecha)

    //Vari�veis.
    Local aArea := GetArea()
    Local lRet  := .T.
    Local cUpdt := ""

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - fechReg - cNumReg " + cNumReg )

    cNumReg := Alltrim(cValToChar(cNumReg))

    If lFecha
        cUpdt := " UPDATE OPENQUERY(" + cLinkedServer + ",'SELECT USUARIO, ABASEQ, FLAG FROM ABASTECIMENTOS WHERE FLAG = ''N'' AND ABASEQ = ''" + cNumReg + "'' ') "
        cUpdt += " SET FLAG = 'S' WHERE ABASEQ = '" + cNumReg + "'; "

    Else
        cUpdt := " UPDATE OPENQUERY(" + cLinkedServer + ",'SELECT USUARIO, ABASEQ, FLAG FROM ABASTECIMENTOS WHERE FLAG = ''S'' AND ABASEQ = ''" + cNumReg + "'' ') "
        cUpdt += " SET FLAG = 'N' WHERE ABASEQ = '" + cNumReg + "'; "

    EndIf

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - fechReg - cUpdt - lFecha " + cValToChar(lFecha) + " " + cUpdt )

    If TCSqlExec(cUpdt) < 0
        lRet  := .F.
        Conout( DToC(Date()) + " " + Time() + " ADEST079P - fechReg - " + TCSqlError() )

    EndIf

    Conout( DToC(Date()) + " " + Time() + " ADEST079P - fechReg - lRet " + cValToChar(lRet) )

    RestArea(aArea)

Return lRet
/*/{Protheus.doc} logZBN
    Gera log do Job na tabela ZBN.
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function logZBN(cStatus)

    //Vari�veis.
	Local aArea	:= GetArea()

	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADEST079P'))

		RecLock("ZBN",.F.)

		ZBN_FILIAL  := xFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= 'ADEST079P'
		ZBN_STATUS	:= cStatus

		MsUnlock() 

	Else

		RecLock("ZBN",.T.)

		ZBN_FILIAL  := xFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= 'ADEST079P'
		ZBN_STATUS	:= cStatus

		MsUnlock() 	

	EndIf

	ZBN->(dbCloseArea())

	RestArea(aArea)

Return Nil
/*/{Protheus.doc} logZBE
    Gera log na tabela ZBE.
    @type  Static Function
    @author Everson
    @since 23/06/2022
    @version 01
    /*/
Static Function logZBE(cMensagem)

    //Vari�veis.
	Local aArea	:= GetArea()

	DbSelectArea("ZBE")
	RecLock("ZBE",.T.)
		Replace ZBE_FILIAL 	   	With xFilial("ZBE")
		Replace ZBE_DATA 	   	With dDataBase
		Replace ZBE_HORA 	   	With Time()
		Replace ZBE_USUARI	    With Upper(Alltrim(cUserName))
		Replace ZBE_LOG	        With cMensagem
		Replace ZBE_MODULO	    With "LOGISTICA"
		Replace ZBE_ROTINA	    With "ADEST079P" 
	MsUnlock()

	RestArea(aArea)

Return Nil
