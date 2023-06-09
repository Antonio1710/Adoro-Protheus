#INCLUDE "PROTHEUS.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include 'TOTVS.ch'
#INCLUDE "topconn.ch"
#DEFINE CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} ADMNT014R - Relatorio de custo de requisi��o de almoxarifado
    @type  Function
    @author Denis Guedes
    @since 02/06/2021
    @version 01
    @history Ticket: TI    - 11/06/2021 - ADRIANO SAVOINE - Corrigida a query da consulta para agrupar os dados.
    @history Ticket: 13556 - 25/06/2021 - LEONARDO P. MONTEIRO - Corre��o da rotina para execu��o via schedule.
    @history Ticket: 63902 - 23/11/2021 - TIAGO STOCCO - Corre��o da QUERY para desprezar os estornados da SD3
    @history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
    @history Ticket 76482  - 15/07/2022 - ADRIANO SAVOINE - Corrigido o programa para rodar Schedule na vers�o Protheus V33.
    @history Ticket 76482  - 15/07/2022 - ADRIANO SAVOINE - Corrigido o programa para rodar Schedule na vers�o Protheus V33.
    @history Ticket 76312  - 18/07/2022 - Fernando Macieira - RELATORIO DE CUSTOS
    @history Ticket 76312  - 19/07/2022 - Fernando Macieira - ERROR LOG
    @history Ticket 75264  - 26/07/2022 - Antonio Domingos - Relat�rio " Requisi��o Transfer�ncia "

/*/
User Function ADMNT014R(aParam)

    Local bProcess 		:= {|oSelf| Executa(oSelf) }
    Local cPerg 		:= "ADMNT014R"
    Local aInfoCustom 	:= {}
    Local cTxtIntro	    := "Rotina respons�vel pela extracao EXCEL do custo de requisi��o de almoxarifado"
    // @history Ticket 76312  - 18/07/2022 - Fernando Macieira - RELATORIO DE CUSTOS
    Private lJob          := IsBlind() // @history Ticket 76312  - 19/07/2022 - Fernando Macieira - ERROR LOG 
    Default aParam    	:= Array(2)
    Default aParam[1] 	:= "01"
    Default aParam[2] 	:= "02"
    Private oProcess
    Private dMVPAR01   
    Private dMVPAR02   
    Private cMVPAR03   
    Private cMVPAR04  
    Private czEMP
    Private czFIL
    Private cPara      := ""
    Private cAssunto   := "Rela��o do custo de requisi��o de almoxarifado"
    Private cCorpo     := "Rela��o do custo de requisi��o de almoxarifado"
    Private aAnexos    := {}
    Private lMostraLog := .F.
    Private lUsaTLS    := .T.

    // @history Ticket 76312  - 18/07/2022 - Fernando Macieira - RELATORIO DE CUSTOS
    If Select("SX6") == 0
        lJob := .T.
    Else
        lJob := .f.
    EndIf
    //
   
    If lJob
   
        // @history Ticket 76312  - 18/07/2022 - Fernando Macieira - RELATORIO DE CUSTOS
            RPCClearEnv()
            RPCSetType(3)  //Nao consome licensas
            RpcSetEnv(aParam[1],aParam[2],,,,GetEnvServer(),{ }) //Abertura do ambiente em rotinas autom�ticas	
            //
            czEMP    := aParam[1]   
            czFIL    := aParam[2]  
    
            //@history Ticket: 13556 - 25/06/2021 - LEONARDO P. MONTEIRO - Corre��o da rotina para execu��o via schedule.
            dMVPAR01	:= Stod( Left( Dtos( Date() ),6 )+"01" )
            dMVPAR02	:= Date()
            
            cMVPAR03 := czFIL
            cMVPAR04 := czFIL
            
            Qout(" JOB ADMNT-Protheus - 01 - Parametros dMVPAR01="+ Dtoc(dMVPAR01) + ", dMVPAR02=" + Dtoc(dMVPAR02) +", cMVPAR03="+ cMVPAR03 +", cMVPAR04="+cMVPAR04+" ")
            
            //PREPARE ENVIRONMENT EMPRESA czEMP FILIAL czFIL MODULO "EST" // @history Ticket 76312  - 18/07/2022 - Fernando Macieira - RELATORIO DE CUSTOS
            cPara      :=  SuperGetMv('ZZ_MNT014R', .f. ,"sonia.silva@adoro.com.br;hercules.moreira@adoro.com.br;debora.silva@adoro.com.br") //"sonia.silva@adoro.com.br;hercules.moreira@adoro.com.br;debora.silva@adoro.com.br" )
            
            logZBN("1") //Log in�cio // @history Ticket 76312  - 18/07/2022 - Fernando Macieira - RELATORIO DE CUSTOS
            oProcess := Executa()
            logZBN("2") //Log fim // @history Ticket 76312  - 18/07/2022 - Fernando Macieira - RELATORIO DE CUSTOS
    
    Else
        oProcess := tNewProcess():New("ADMNT014R","Custo de requisi��o",bProcess,cTxtIntro,cPerg,aInfoCustom, .T.,5, "Custo de requisi��o", .T. )
    Endif

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Rel. de custo de requisi��o de almoxarifado ')

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 19/07/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function Executa(oProcess)

    Local cQry1      := ""
    Local cQry2      := ""
    Local cAlias1    := GetNextAlias()
    Local cAlias2    := GetNextAlias()
    Local _cCusto1   := SuperGetMv("AD_MNT14R1",.F.,"5213/5217/5304")
    Local _cCusto2   := SuperGetMv("AD_MNT14R2",.F.,"5304")
    Local _cTitulo   := " "
    
    Private oExcel  	:= FwMsExcelXlsx():New() // @history Ticket 76312  - 19/07/2022 - Fernando Macieira - ERROR LOG 
    Private cNomArq
    Private cDIRARQ
    Private cDIRREDE

    aAnexos:={}

    //@history Ticket: 13556 - 25/06/2021 - LEONARDO P. MONTEIRO - Corre��o da rotina para execu��o via schedule.
    If !lJob
        dMVPAR01	:= MV_PAR01
        dMVPAR02	:= MV_PAR02
        cMVPAR03	:= MV_PAR03
        cMVPAR04	:= MV_PAR04
        czEMP       := cEmpAnt
        czFIL       := cFilAnt  
    EndIf

    _cTitulo   := "Rel.Custo Req. Almox."+" De "+Dtoc(dMVPAR01)+" a "+Dtoc(dMVPAR02)+" - Da Filial "+cMVPAR03+" At� "+cMVPAR04

    oExcel:AddworkSheet("Custo") // Planilha
    oExcel:AddTable ("Custo",_cTitulo) // Titulo da Planilha (Cabeçalho)
    oExcel:AddColumn("Custo",_cTitulo,"FILIAL"         ,1,1)
    oExcel:AddColumn("Custo",_cTitulo,"GRUPO"	         ,1,1)
    oExcel:AddColumn("Custo",_cTitulo,"DESCRI��O"	     ,1,1)
    oExcel:AddColumn("Custo",_cTitulo,"CUSTO"		     ,3,3,.T.)

    _cCusto1 := STRTRAN(_cCusto1,"/","','")

    cQry1    := " SELECT  "+CRLF
    cQry1    += " D3_FILIAL, "+CRLF
    cQry1    += " D3_GRUPO, "+CRLF
    cQry1    += " BM_DESC, "+CRLF
    cQry1    += " SUM(D3_CUSTO1) AS D3_CUSTO1 "+CRLF    // Ticket: TI - 11/06/2021 - ADRIANO SAVOINE
    cQry1    += " FROM "+RetSqlName("SD3")+" (NOLOCK) D3  "+CRLF 
    cQry1    += " INNER JOIN "+RetSqlName("SBM")+" (NOLOCK) BM ON  "+CRLF 
    cQry1    += " BM_FILIAL = '"+xFilial("SBM")+"'  "+CRLF
    cQry1    += " AND D3_GRUPO = BM_GRUPO "+CRLF
    cQry1    += " AND BM.D_E_L_E_T_ = ' '  "+CRLF
    cQry1    += " WHERE  "+CRLF
    cQry1    += " D3_EMISSAO BETWEEN '"+DTOS(dMVPAR01)+"' AND '"+DTOS(dMVPAR02)+"'  "+CRLF
    cQry1    += " AND D3_FILIAL BETWEEN '"+cMVPAR03+"' AND '"+cMVPAR04+"'  "+CRLF
    cQry1    += " AND D3_TM = '501'  "+CRLF
    cQry1    += " AND D3_CC IN ('"+_cCusto1+"')  "+CRLF
    cQry1    += " AND D3.D_E_L_E_T_ = ' '  "+CRLF
    cQry1    += " AND D3_ESTORNO <> 'S'  "+CRLF //Ticket: 63902 - 23/11/2021 - TIAGO STOCCO
    cQry1    += " GROUP BY D3_FILIAL,D3_GRUPO,BM_DESC  "+CRLF  // Ticket: TI - 11/06/2021 - ADRIANO SAVOINE
    cQry1    += " ORDER BY D3_FILIAL,D3_GRUPO  "+CRLF

    //MemoWrite("c:\TEMP\ADMNT014R_01.SQL", cQry1)
  
    IF Select (cAlias1) > 0
        (cAlias1)->(DbCloseArea())
    EndIf

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQry1), cAlias1)
    DbSelectArea(cAlias1)
    DbGotop()

    If (cAlias1)->(!EOF())
        While (cAlias1)->(!EOF())
            oExcel:AddRow("Custo",_cTitulo,{	(cAlias1)->D3_FILIAL,;
                                                (cAlias1)->D3_GRUPO     ,;
                                                (cAlias1)->BM_DESC	   ,;
                                                (cAlias1)->D3_CUSTO1	    ;
                                            })	
            (cAlias1)->(DbSkip())
        EndDo
        (cAlias1)->(DbCloseArea())
        
    EndIf

    oExcel:AddworkSheet("TRFMAN") // Planilha
    oExcel:AddTable ("TRFMAN",_cTitulo) // Titulo da Planilha (Cabeçalho)
    oExcel:AddColumn("TRFMAN",_cTitulo,"FILIAL"         ,1,1)
    oExcel:AddColumn("TRFMAN",_cTitulo,"GRUPO"	         ,1,1)
    oExcel:AddColumn("TRFMAN",_cTitulo,"DESCRI��O"	     ,1,1)
    oExcel:AddColumn("TRFMAN",_cTitulo,"CUSTO"		     ,3,3,.T.)

    _cCusto2 := STRTRAN(_cCusto2,"/","','")

    cQry2    := " SELECT "+CRLF
    cQry2    += " B2_FILIAL,B1_GRUPO, BM_DESC,SUM(B2_VATU1) B2_VATU1 "+CRLF
    cQry2    += " FROM "+RetSqlName("SB2")+" (NOLOCK) SB2 "+CRLF  	
    cQry2    += " INNER JOIN "+RetSqlName("SB1")+" (NOLOCK) SB1 ON ( B1_FILIAL = '  ' AND SB1.B1_COD = SB2.B2_COD  ) "+CRLF  	
    cQry2    += " INNER JOIN "+RetSqlName("NNR")+" (NOLOCK) NNR ON ( NNR_FILIAL = '  ' AND NNR.NNR_CODIGO = SB2.B2_LOCAL  ) "+CRLF  
    cQry2    += " INNER JOIN "+RetSqlName("SBM")+" (NOLOCK) SBM "+CRLF  
    cQry2    += " ON SBM.BM_FILIAL = '  ' AND SBM.BM_GRUPO = SB1.B1_GRUPO AND SBM.D_E_L_E_T_ = ' '   "+CRLF
    cQry2    += " WHERE  B2_FILIAL BETWEEN '"+cMVPAR03+"' AND '"+cMVPAR04+"'  "+CRLF
    cQry2    += " AND   SB1.B1_GRUPO BETWEEN '    ' AND 'ZZZZ' "+CRLF 
    //cQry2    += " AND  	SB1.B1_TIPO  IN('MM','MC') "+CRLF
    cQry2    += " AND  	SB1.B1_DESC BETWEEN  '                              '  "+CRLF
    cQry2    += " AND   'ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ '  "+CRLF
    cQry2    += " AND  	SB2.B2_LOCAL BETWEEN '48    ' AND '48    '   "+CRLF
    cQry2    += " AND   SB1.B1_COD    BETWEEN '               '  "+CRLF
    cQry2    += " AND   'ZZZZZZZZZZZZZZZ'  AND  	NNR.D_E_L_E_T_ = ' '  "+CRLF 	
    cQry2    += " AND   SB2.D_E_L_E_T_ = ' '  	AND SB1.D_E_L_E_T_ = ' '  "+CRLF
    cQry2    += " AND   SB2.B2_VATU1 <> 0 "+CRLF
    cQry2    += " GROUP BY B2_FILIAL, B1_GRUPO, BM_DESC "+CRLF

    //MemoWrite("c:\TEMP\ADMNT014R_02.SQL", cQry2)

    IF Select (cAlias2) > 0
        (cAlias2)->(DbCloseArea())
    EndIf

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQry2), cAlias2)
    DbSelectArea(cAlias2)
    DbGotop()

    If (cAlias2)->(!EOF())
        While (cAlias2)->(!EOF())
            oExcel:AddRow("TRFMAN",_cTitulo,{	(cAlias2)->B2_FILIAL,;
                                                (cAlias2)->B1_GRUPO,;
                                                (cAlias2)->BM_DESC,;
                                                (cAlias2)->B2_VATU1;
                                            })	
            (cAlias2)->(DbSkip())
        EndDo
        (cAlias2)->(DbCloseArea())
        
    EndIf

    If !(lJob)
        cDIRARQ := "c:\temp\"
        cNomArq := "REL_CUSTO_"+czEMP+"_"+czFIL+".XLS" 
    Else
        cDIRARQ := "\DATA\"
        cNomArq := "_"+czEMP+"_"+czFIL+".XLS" 
    EndIf
        
    oExcel:Activate()

    If !(lJob)
        MsAguarde({||Processa({|| oExcel:GetXMLFile(cDIRARQ+cNomArq) })},"Processanento", "Gerando arquivo XML, aguarde....")
    Else
            
        oExcel:GetXMLFile(cDIRARQ+cNomArq)

        /*
        cDIRREDE := "\RELATORIO\"
        nStatus  := __CopyFile((cDIRARQ+cNomArq),(cDIRREDE+cNomArq)) 
        If FError() == 25 //Arquivo já existe na pasta destino
            FERASE(cDIRREDE+cNomArq) 
            nStatus:= __CopyFile((cDIRARQ+cNomArq),(cDIRREDE+cNomArq)) 
        EndIf
        */

    Endif

    //oExcelApp:=MsExcel():New()             // @history Ticket 76312  - 19/07/2022 - Fernando Macieira - ERROR LOG
        
    If !lJob

        oExcelApp:=MsExcel():New()             // @history Ticket 76312  - 19/07/2022 - Fernando Macieira - ERROR LOG
        //oExcelApp:=FwMsExcelXlsx():New()             // @history Ticket 76312  - 19/07/2022 - Fernando Macieira - ERROR LOG

        oExcelApp:WorkBooks:Open( cDIRARQ+cNomArq ) // Abre uma planilha
        oExcelApp:SetVisible(.T.)
            
        /*
            cDIRARQ := "\DATA\"
            cNomArq := "REL_CUSTO_"+cEmpAnt+"_"+cFilAnt+".XLS" 
            aAdd(aAnexos, cDIRARQ+cNomArq)
            oExcel:GetXMLFile(cDIRARQ+cNomArq)
            cPara      :=  SuperGetMv('ZZ_MNT014R', .f. ,"denis.guedes@dtmit.com.br" ) 
            fEnvMail(cPara, cAssunto, cCorpo, aAnexos, lMostraLog, lUsaTLS)
            */
    Else
        aAdd(aAnexos, cDIRARQ+cNomArq)
        fEnvMail(cPara, cAssunto, cCorpo, aAnexos, lMostraLog, lUsaTLS)
    EndIf
        
Return

Static Function fEnvMail(cPara, cAssunto, cCorpo, aAnexos, lMostraLog, lUsaTLS)

    Local aArea        := GetArea()
    Local nAtual       := 0
    Local lRet         := .T.
    Local oMsg         := Nil
    Local oSrv         := Nil
    Local nRet         := 0
    Local cFrom        := Alltrim(GetMV("MV_RELACNT"))
    Local cUser        := SubStr(cFrom, 1, At('@', cFrom)-1)
    Local cPass        := Alltrim(GetMV("MV_RELPSW"))
    Local cSrvFull     := Alltrim(GetMV("MV_RELSERV"))
    Local cServer      := Iif(':' $ cSrvFull, SubStr(cSrvFull, 1, At(':', cSrvFull)-1), cSrvFull)
    Local nPort        := Iif(':' $ cSrvFull, Val(SubStr(cSrvFull, At(':', cSrvFull)+1, Len(cSrvFull))), 587)
    Local nTimeOut     := GetMV("MV_RELTIME")
    Local cLog         := ""
    Default cPara      := ""
    Default cAssunto   := ""
    Default cCorpo     := ""
    Default aAnexos    := {}
    Default lMostraLog := .F.
    Default lUsaTLS    := .F.
 
    //Se tiver em branco o destinatário, o assunto ou o corpo do email
    If Empty(cPara) .Or. Empty(cAssunto) .Or. Empty(cCorpo)
        cLog += "001 - Destinatario, Assunto ou Corpo do e-Mail vazio(s)!" + CRLF
        lRet := .F.
    EndIf
 
    If lRet
        //Cria a nova mensagem
        oMsg := TMailMessage():New()
        oMsg:Clear()
 
        //Define os atributos da mensagem
        oMsg:cFrom    := cFrom
        oMsg:cTo      := cPara
        oMsg:cSubject := cAssunto
        oMsg:cBody    := cCorpo
 
        //Percorre os anexos
        For nAtual := 1 To Len(aAnexos)
            //Se o arquivo existir
            If File(aAnexos[nAtual])
 
                //Anexa o arquivo na mensagem de e-Mail
                nRet := oMsg:AttachFile(aAnexos[nAtual])
                If nRet < 0
                    cLog += "002 - Nao foi possivel anexar o arquivo '"+aAnexos[nAtual]+"'!" + CRLF
                EndIf
 
            //Senao, acrescenta no log
            Else
                cLog += "003 - Arquivo '"+aAnexos[nAtual]+"' nao encontrado!" + CRLF
            EndIf
        Next
 
        //Cria servidor para disparo do e-Mail
        oSrv := tMailManager():New()
 
        //Define se irá utilizar o TLS
        If lUsaTLS
            oSrv:SetUseTLS(.T.)
        EndIf
 
        //Inicializa conexão
        nRet := oSrv:Init("", cServer, cUser, cPass, 0, nPort)
        If nRet != 0
            cLog += "004 - Nao foi possivel inicializar o servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
            lRet := .F.
        EndIf
 
        If lRet
            //Define o time out
            nRet := oSrv:SetSMTPTimeout(nTimeOut)
            If nRet != 0
                cLog += "005 - Nao foi possivel definir o TimeOut '"+cValToChar(nTimeOut)+"'" + CRLF
            EndIf
 
            //Conecta no servidor
            nRet := oSrv:SMTPConnect()
            If nRet <> 0
                cLog += "006 - Nao foi possivel conectar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
                lRet := .F.
            EndIf
 
            If lRet
                //Realiza a autenticação do usuário e senha
                nRet := oSrv:SmtpAuth(cFrom, cPass)
                If nRet <> 0
                    cLog += "007 - Nao foi possivel autenticar no servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
                    lRet := .F.
                EndIf
 
                If lRet
                    //Envia a mensagem
                    nRet := oMsg:Send(oSrv)
                    If nRet <> 0
                        cLog += "008 - Nao foi possivel enviar a mensagem: " + oSrv:GetErrorString(nRet) + CRLF
                        lRet := .F.
                    EndIf
                EndIf
 
                //Disconecta do servidor
                nRet := oSrv:SMTPDisconnect()
                If nRet <> 0
                    cLog += "009 - Nao foi possivel disconectar do servidor SMTP: " + oSrv:GetErrorString(nRet) + CRLF
                EndIf
            EndIf
        EndIf
    EndIf
 
    //Se tiver log de avisos/erros
    If !Empty(cLog)
        cLog := "fEnvMail - "+dToC(Date())+ " " + Time() + CRLF + ;
            "Funcao - " + FunName() + CRLF + CRLF +;
            "Existem mensagens de aviso: "+ CRLF +;
            cLog
        If lJob
            ConOut(cLog)
        EndIf
        //Se for para mostrar o log visualmente e for processo com interface com o usuário, mostra uma mensagem na tela
        If lMostraLog .And. !lJob
            Aviso("Log", cLog, {"Ok"}, 2)
        EndIf
    EndIf
 
    RestArea(aArea)

Return lRet

/*/{Protheus.doc} u_MNT014A0
Ticket 70142 - Substituicao de funcao Static Call por User Function MP 12.1.33
@type function
@version 1.0
@author Edvar   / Flek Solution
@since 16/03/2022
@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
/*/
Function u_MNT014A0( uPar1, uPar2, uPar3, uPar4, uPar5, uPar6 )
Return( fEnvMail( uPar1, uPar2, uPar3, uPar4, uPar5, uPar6 ) )

/*/{Protheus.doc} logZBN
	(Gera log na ZBN. Chamado 037261)
	@type  Static Function
	@author Everson
	@since 29/03/2019
	@version 01
/*/
Static Function logZBN(cStatus)

	Local aArea	:= GetArea()
    Local cRotina := "ADMNT014R"
    Local lLock   := .t.
	
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 

	If ZBN->( dbSeek(FWxFilial("ZBN") + cRotina) )
        lLock := .f.
    EndIf
	
    RecLock("ZBN", lLock)
        ZBN_FILIAL  := FWxFilial("ZBN")
        ZBN_DATA    := msDate()
        ZBN_HORA    := cValToChar(Time())
        ZBN_ROTINA	:= cRotina
        ZBN_STATUS	:= cStatus
    ZBN->( msUnlock() )

	RestArea(aArea)

Return
