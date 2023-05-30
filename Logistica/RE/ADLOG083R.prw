#INCLUDE "PROTHEUS.ch"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TBICONN.CH"
#Include 'TOTVS.ch'
#INCLUDE "topconn.ch"
#DEFINE CRLF CHR(13)+CHR(10)

/*/{Protheus.doc} ADLOG083R - Relatorio de envio de e-mail de CNH a Vencer
    @type  Function
    @author Antonio Domingos
    @since 31/08/2022
    @version 01
    @history Ticket  77042  - 25/07/2022 - Antonio Domingos - AMBIENTE 39- CADASTRO DE MOTORISTAS- ADICIONAR CAMPOS E WORKFLOW
/*/
User Function ADLOG083R(aParam)

    Local bProcess 		:= {|oSelf| Executa(oSelf) }
    Local cPerg 		:= "ADLOG083R"
    Local aInfoCustom 	:= {}
    Local cTxtIntro	    := "Rotina respons·vel envio de e-mail de CNH a Vencer"
    Private lJob        := IsBlind() 
    aParam              := If(valtype(aparam)='C',Array(2),Array(2))
    Default aParam    	:= Array(2)
    Default aParam[1] 	:= "01"
    Default aParam[2] 	:= "02"
    Private oProcess
    Private dMVPAR01    := DATE()
    Private cMVPAR02    := aParam[1]
    Private cMVPAR03    := aParam[2]
    Private czEMP
    Private czFIL
    Private cAdPara    := ""    
    Private nAdDias1   := 7 
    Private nAdDias2   := 1
    Private cAssunto   := "Aviso de CNH a Vencer"
    Private cCorpo     := " "
    Private aAnexos    := {}
    Private lMostraLog := .F.
    Private lUsaTLS    := .T.

    If Select("SX6") == 0
        lJob := .T.
    Else
        lJob := .f.
    EndIf
    //
   
    If lJob
        RPCClearEnv()
        RPCSetType(3)  //Nao consome licensas
        RpcSetEnv(aParam[1],aParam[2],,,,GetEnvServer(),{ }) //Abertura do ambiente em rotinas autom·ticas	
        //
        czEMP    := aParam[1]   
        czFIL    := aParam[2]  
        dMVPAR01 := Date() //Stod( Left( Dtos( Date() ),6 )+"01" )
        cMVPAR02 := czFIL
        cMVPAR03 := czFIL
        nAdDias1   := SuperGetMV("AD_LOG083A",.F.,7) //Numero de dias de vencto para o primeiro e-mail de aviso para data de validade da CNH a Vencer
        nAdDias2   := SuperGetMV("AD_LOG083B",.F.,1) //Numero de dias de vencto para o segundo e-mail de aviso  para data de validade da CNH a Vencer
        //    
        Qout(" JOB ADLOG083R-Protheus - 01 - Parametros dMVPAR01="+ Dtoc(dMVPAR01) + ", dMVPAR02=" + cMVPAR02 +", cMVPAR03="+ cMVPAR03 )
        //   
        logZBN("1") 
        oProcess := Executa()
        logZBN("2") 
        //
    Else
        nAdDias1   := SuperGetMV("AD_LOG083A",.F.,7) //Numero de dias de vencto para o primeiro e-mail de aviso para data de validade da CNH a Vencer
        nAdDias2   := SuperGetMV("AD_LOG083B",.F.,1) //Numero de dias de vencto para o segundo e-mail de aviso  para data de validade da CNH a Vencer
        oProcess := tNewProcess():New("ADLOG083R","Aviso de CNH a Vencer",bProcess,cTxtIntro,cPerg,aInfoCustom, .T.,5, "CNH a Vencer", .T. )
    Endif

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Envio de e-mail de CNH de Motorista a Vencer')

Return

/*/{Protheus.doc} Executa(oProcess)
    (long_description)
    @type  Static Function
    @author Antonio Domingos
    @since 31/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history Ticket  77042  - 25/07/2022 - Antonio Domingos - AMBIENTE 39- CADASTRO DE MOTORISTAS- ADICIONAR CAMPOS E WORKFLOW    
/*/
Static Function Executa(oProcess)

    Local _cAlias1   := GetNextAlias()
    
    Private cNomArq := "REL_LOG\CNH_a Vencer_"+DTOS(dMVPAR01)+"_"+TIME()
    Private cDIRARQ := "C:\TEMP\"
    Private cDIRREDE := "\REL_LOG\"
    Private cMotorista := ""
    Private cCPF := ""
    Private cCelular := ""
    Private cCNH := ""
    Private cVencCNH := ""
    aAnexos:={}

    cAdDias1 := alltrim(Str(nAdDias1))
    cAdDias2 := alltrim(Str(nAdDias2))
    
    If !lJob
        dMVPAR01	:= DATE()
        //czEMP       := cEmpAnt
        //czFIL       := cFilAnt  
    else
        Conout("ADLOG83R CNH a Vencer - Inicio de Processamento - Data: "+Dtoc(dMVPAR01)+" Hor·rio "+TIME())
    EndIf

    BeginSQL Alias _cAlias1
		%NoPARSER%  
        SELECT LTRIM(STR((DATEDIFF(day, %Exp:DTOS(dMVPAR01)%,ZVC_CNHVCT)),3)) AS DIAS_VENC,ZVC.ZVC_CNHVCT,ZVC.ZVC_BUONNY,ZVC.ZVC_EMLMOT,ZVC.ZVC_DTVALI,ZVC.*,SA4.A4_EMAIL,SA4.A4_XEMAILN 
        FROM %table:ZVC% ZVC (NOLOCK)
		INNER JOIN %table:SA4% SA4 (NOLOCK) 
        ON SA4.A4_FILIAL =  %xFilial:SA4%
        AND SA4.A4_COD = ZVC.ZVC_CODTRP 
        AND SA4.%notDel%
        WHERE ZVC_FILIAL = %xFilial:ZVC%
        AND SA4.A4_EMAIL <> ' '
        AND SA4.A4_XEMAILN <> ' '
        AND ZVC.ZVC_EMLMOT <> ' '
        AND ZVC.ZVC_MOTBLQ <> 'T'
        AND 
        (LTRIM(STR((DATEDIFF(day, %Exp:DTOS(dMVPAR01)%,ZVC_CNHVCT)),3)) = %Exp:cAdDias1% OR 
        LTRIM(STR((DATEDIFF(day, %Exp:DTOS(dMVPAR01)%,ZVC_CNHVCT)),3)) = %Exp:cAdDias2%) 
        AND ZVC.%notDel%
	EndSQl             
    
    DbSelectArea(_cAlias1)
    DbGotop()

    If (_cAlias1)->(!EOF())
        While (_cAlias1)->(!EOF())
            //ValidaÁ„o da variavel cPara
            cPara  := " "
            //aAdd(aAnexos, cDIRARQ+cNomArq)
            If !Empty((_cAlias1)->ZVC_EMLMOT)
                cPara  += alltrim((_cAlias1)->ZVC_EMLMOT)
            EndIf
            If !Empty((_cAlias1)->A4_EMAIL)
                If !Empty(cPara)
                    cPara += ";"
                EndIf
                cPara  += alltrim((_cAlias1)->A4_EMAIL)
            EndIf
            If !Empty((_cAlias1)->A4_XEMAILN)
                If !Empty(cPara)
                    cPara += ";"
                EndIf
                cPara  += alltrim((_cAlias1)->A4_XEMAILN)
            EndIf
            If Empty(cPara)
                (_cAlias1)->(dbSkip())
                Loop
            EndIf
            //Carrega variaveis para o Corpo do e-mail
            cNomMotorista  := (_cAlias1)->ZVC_MOTORI
            cCPFMotorista  := (_cAlias1)->ZVC_CPF   
            cCelMotorista  := (_cAlias1)->ZVC_TELPRI
            cCNHMotorista  := (_cAlias1)->ZVC_CNH   
            cVencCNH       := DTOC(STOD((_cAlias1)->ZVC_CNHVCT))
                //Monta o Corpo do e-mail em html
                cCorpo := '<html>'
                cCorpo += '<head>'
                cCorpo += '	<title>Editor HTML Online</title>'
                cCorpo += '</head>'
                cCorpo += '<body>'
                cCorpo += '	<div style="text-align: left;">'
                cCorpo += '		<table align="left" border="1" cellpadding="1" cellspacing="1" style="width: 500px">'
                cCorpo += '			<thead>'
                cCorpo += '				<tr>'
                cCorpo += '					<th scope="col">'
                cCorpo += '						<span style="background-color:#d3d3d3;">Motorista&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></th>'
                cCorpo += '					<th scope="col">'
                cCorpo += '						<span style="background-color:#d3d3d3;">CPF&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</span></th>'
                cCorpo += '				</tr>'
                cCorpo += '			</thead>'
                cCorpo += '			<tbody>'
                cCorpo += '				<tr>'
                cCorpo += '					<td>'
                cCorpo += '						'+alltrim(cNomMotorista)+'</td>'
                cCorpo += '					<td>'
                cCorpo += '						'+cCPFMotorista+'</td>'
                cCorpo += '				</tr>'
                cCorpo += '				<tr>'
                cCorpo += '					<td>'
                cCorpo += '						<strong><span style="background-color:#d3d3d3;">Celular&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;</span></strong></td>'
                cCorpo += '					<td>'
                cCorpo += '						'+cCelMotorista+'</td>'
                cCorpo += '				</tr>'
                cCorpo += '			</tbody>'
                cCorpo += '		</table>'
                cCorpo += '		<p>'
                cCorpo += '			&nbsp;</p>'
                cCorpo += '		<p>'
                cCorpo += '			&nbsp;</p>'
                cCorpo += '		<table border="1" cellpadding="1" cellspacing="1" style="width: 500px">'
                cCorpo += '			<thead>'
                cCorpo += '				<tr>'
                cCorpo += '					<th scope="col">'
                cCorpo += '						<span style="background-color:#d3d3d3;">Reg.CNH&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</span></th>'
                cCorpo += '					<th scope="col">'
                cCorpo += '						<span style="background-color:#d3d3d3;">Venc. CNH&nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp; &nbsp;&nbsp;</span></th>'
                cCorpo += '				</tr>'
                cCorpo += '			</thead>'
                cCorpo += '			<tbody>'
                cCorpo += '				<tr>'
                cCorpo += '					<td>'
                cCorpo += '						'+cCNHMotorista+'</td>'
                cCorpo += '					<td>'
                cCorpo += '						'+cVencCNH+'</td>'
                cCorpo += '				</tr>'
                cCorpo += '			</tbody>'
                cCorpo += '		</table>'
                cCorpo += '		<table align="left" border="1" cellpadding="1" cellspacing="1" style="width: 500px">'
                cCorpo += '			<tbody>'
                cCorpo += '				<tr>'
                cCorpo += '					<td style="text-align: center;">'
                cCorpo += '						<span style="color:#ff0000;"><strong>AVISO: FAVOR REGULARIZE DADOS! SUJEITO A BLOQUEIO</strong></span></td>'
                cCorpo += '				</tr>'
                cCorpo += '			</tbody>'
                cCorpo += '		</table>'
                cCorpo += '		<p>'
                cCorpo += '			&nbsp;</p>'
                cCorpo += '		<p>'
                cCorpo += '			&nbsp;</p>'
                cCorpo += '		<p>'
                cCorpo += '			&nbsp;</p>'
                cCorpo += '	</div>'
                cCorpo += '	<p>'
                cCorpo += '		&nbsp;</p>'
                cCorpo += '	<p>'
                cCorpo += '		&nbsp;</p>'
                cCorpo += '	<p>'
                cCorpo += '		&nbsp;</p>'
                cCorpo += '</body>'
                cCorpo += '</html>'
            //envia e-mail de aviso para CNH de motorista a Vencer - 1 pra 1
            fEnvMail(cPara, cAssunto, cCorpo, aAnexos, lMostraLog, lUsaTLS)
            If lJob
                Conout("ADLOG83R CNH a Vencer - Motorista: "+cNomMotorista+" Cpf: "+cCPFMotorista+" Celular: "+cCelMotorista+" CNH: "+cCNHMotorista+" Vencto: "+cVencCNH)
            EndIf
            (_cAlias1)->(DbSkip())
        EndDo
    else
        If lJob
            Conout("ADLOG83R CNH a Vencer - N„o h· registros para processamento!")
        EndIf
    EndIf
        
    (_cAlias1)->(dbCloseArea())

    If lJob
        Conout("ADLOG83R CNH a Vencer - Fim de Processamento - Data: "+Dtoc(dMVPAR01)+" Hor·rio "+TIME())
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
    
   

    //Se tiver em branco o destinat√°rio, o assunto ou o corpo do email
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
 
        //Define se ir√° utilizar o TLS
        If lUsaTLS
            oSrv:SetUseTLS(.T.)
        EndIf
 
        //Inicializa conex√£o
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
                //Realiza a autentica√ß√£o do usu√°rio e senha
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
        //Se for para mostrar o log visualmente e for processo com interface com o usu√°rio, mostra uma mensagem na tela
        If lMostraLog .And. !lJob
            Aviso("Log", cLog, {"Ok"}, 2)
        EndIf
    EndIf
 
     RestArea(aArea)

Return lRet

/*/{Protheus.doc} logZBN
	(Gera log na ZBN. Chamado 037261)
	@type  Static Function
	@author Everson
	@since 29/03/2019
	@version 01
/*/
Static Function logZBN(cStatus)

	Local aArea	:= GetArea()
    Local cRotina := "ADLOG083R"
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
