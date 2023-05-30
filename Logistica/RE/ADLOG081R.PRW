#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#Include 'TOTVS.ch'
#include 'fwbrowse.ch'   
#INCLUDE "topconn.ch"
 #define CRLF Chr(13)+Chr(10)
/*/{Protheus.doc} ADLOG081R - Relatorio de Roteiro / Exporta Excel
)
    @type  Function
    @author Antonio Domingos..
    @since 15/08/2022
    @version TKT - 77061
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    @see (links_or_references) u_ADLOG081R()
    @Ticket  77061, Data 15/08/2022, Antonio Domingos, Solicitação relatório de roteiro...
/*/

User Function ADLOG081R(aParam)
Local bProcess 		:= {|oSelf| Executa(oSelf) }
Local cPerg 		:= "ADLOG081R "
Local aInfoCustom 	:= {}
Local cTxtIntro	    := "Rotina responsável pela extracao em EXCEL de relação de Roteiro"
local lSetEnv       := .f.

cPara      := ""
cAssunto   := "Relação de Roteiro em Excel"
cCorpo     := "Relação de Roteiro em Excel"
aAnexos    := {}
lMostraLog := .F.
lUsaTLS    := .T.

//Local cEmp 		:= "01"
//Local cFil 		:= "02"

		//RPCClearEnv()
		//RPCSetType(3)
		//RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{ })		

Private lJob          := IsBlind()
Private oProcess
Private dMVPAR01   := DATE() //DATA DE CARREGAMENTO
Private dMVPAR02   := DATE() //DATA DE CARREGAMENTO
Private cMVPAR03   := "" //FILIAL-2
Private cMVPAR04   := "zz" //FILIAL-2
Private cMVPAR05   := "" //VEICULO-8
Private cMVPAR06   := "zzzzzzzz" //VEICULO-8
Private cMVPAR07   := "" //CODIGO-8
Private cMVPAR08   := "zzzzzzzz" //CODIGO-8
Private cMVPAR09   := "" //GRANJA-6
Private cMVPAR10   := "zzzzzz" //GRANJA-6
Private czEMP
Private czFIL
Private _cMV_xLOG081  := SuperGetMV("MV_xLOG081",.f.,"0201") //Filtro de Empresa+Filial para tratamento de colunas especificas

//Aadd(aInfoCustom,{"Visualizar",{|oCenterPanel| visualiza(oCenterPanel)},"WATCH" })
//Aadd(aInfoCustom,{"Relatorio" ,{|oCenterPanel| Relat(oCenterPanel) },"RELATORIO"})

If SELECT("SX6") == 0
    lJob := .T.
ELSE
    lJob := .F.
EndIf

If lJob
	RpcSetType(3)
	lSetEnv  := RpcSetEnv(aParam[1],aParam[2],,,"")
    czEMP    := aParam[1]   
    czFIL    := aParam[2]   
    
    PREPARE ENVIRONMENT EMPRESA czEMP FILIAL czFIL MODULO "EST"
    cPara      :=  SuperGetMv('ZZ_LOG081R', .f. ,"denis.souza@adoro.com.br" ) 
    
    oProcess := Executa()
Else
    oProcess := tNewProcess():New("ADLOG081R","Relação de Roteiro.",bProcess,cTxtIntro,cPerg,aInfoCustom, .T.,5, "Relação Roteiro", .T. )
Endif

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio de Roteiro ')

Return
/*/{Protheus.doc} Executa(oProcess) //Processamento do Relatorio
    @type  Function Static
    @author Antonio Domingos..
    @since 15/08/2022
    @version TKT - 77061
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
/*/
Static Function Executa(oProcess)

Local cTimeNow  := ""
Local cDirLocal := "C:\TEMP\"
Local _cPlanilha := "RT"
Local _cTitulo   := "Relação de Roteiro"
Local _nCountRT
Local cQuery:= ""
Private oExcel  	:= FwMsExcel():New()
Private cNomArq
Private cDIRARQ
Private cDIRREDE

If lJob
    //Solicitado pelo usuário que sem venha listado 2 anos de OS.
    dMVPAR01	:= DATE()     //DATA-2
    dMVPAR02	:= DATE()     //DATA-2
    cMVPAR03	:= " "        //FILIAL-2
    cMVPAR04	:= "ZZ"       //FILIAL-2
    cMVPAR05    := " "        //VEICULO-8
    cMVPAR06    := "ZZZZZZZZ" //VEICULO-8
    cMVPAR07    := " "        //CODIGO-8
    cMVPAR08    := "ZZZZZZZZ" //CODIGO-8
    cMVPAR09    := " "        //GRANJA-6
    cMVPAR10    := "ZZZZZZ"   //GRANJA-6
else
    dMVPAR01	:= MV_PAR01 //DATA-2
    dMVPAR02	:= MV_PAR02 //DATA-2
    cMVPAR03    := MV_PAR03 //FILIAL-2
    cMVPAR04    := MV_PAR04 //FILIAL-2
    cMVPAR05    := MV_PAR05 //VEICULO-8
    cMVPAR06    := MV_PAR06 //VEICULO-8
    cMVPAR07    := MV_PAR07 //CODIGO-8
    cMVPAR08    := MV_PAR08 //CODIGO-8
    cMVPAR09    := MV_PAR09 //GRANJA-6
    cMVPAR10    := MV_PAR10 //GRANJA-6    
EndIf
_cTitulo    := _cTitulo
oExcel:AddworkSheet(_cPlanilha) // Planilha
oExcel:AddTable (_cPlanilha,_cTitulo) // Titulo da Planilha (Cabeçalho)
oExcel:AddColumn(_cPlanilha,_cTitulo,"FILIAL"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"VEICULO"        ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"MOTORISTA"      ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"NOME MOTORISTA" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"TRANSPORTADORA" ,1,1)	 
oExcel:AddColumn(_cPlanilha,_cTitulo,"NOME TRANSPORTADORA",1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"CODIGO"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"GRANJA"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"COD FOR GRANJA" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"LOJ FOR GRANJA" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"MUN FOR GRANJA" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"NRLOTE"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"GALPAO"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"GAIOLA"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"AVEGA"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"TOTAL"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"PESPRE"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"FRTVLR"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"FRTPED"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"SEQUEN"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"EQUIPE"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"AVESRE"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"PESREA"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"DTACAR"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"HRAPRE"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"DTAPRE"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"DTAREA"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"HRAREA"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"MOTIVO"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"VIAGEM"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"TIPVIA"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"LACRES"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"NUMERO"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"STATUS"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"AMARRA"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"GUIAPE"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"APANHA"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"HRCHEG"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"OBSERV"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"FILORI"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"PEDVEN"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"NUMEDA"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"STAEDA"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"NUMSAG"         ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"STASAG"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"NF"         ,1,1)	    
oExcel:AddColumn(_cPlanilha,_cTitulo,"SERIE"         ,1,1)	

IF Select ("cAliasZFC") > 0
	cAliasZFC->(DbCloseArea())
EndIf

cQuery := "SELECT ZFC_FILIAL,	ZFC_VEICUL,	ZFC_CODIGO,	ZFC_GRANJA,	ZFC_NRLOTE,	ZFC_GALPAO,	ZFC_GAIOLA,	ZFC_AVEGA,"+CRLF
cQuery += "       ZFC_TOTAL,	ZFC_PESPRE,	ZFC_FRTVLR,	ZFC_FRTPED,	ZFC_SEQUEN,	ZFC_EQUIPE,	ZFC_AVESRE,	ZFC_PESREA,"+CRLF
cQuery += "       ZFC_DTACAR,	ZFC_HRAPRE,	ZFC_DTAPRE,	ZFC_DTAREA,	ZFC_HRAREA,	ZFC_MOTIVO,	ZFC_VIAGEM,	ZFC_TIPVIA,"+CRLF
cQuery += "       ZFC_LACRES,	ZFC_NUMERO,	ZFC_STATUS,	ZFC_AMARRA,	ZFC_GUIAPE,	ZFC_APANHA,	ZFC_HRCHEG,	ZFC_OBSERV,"+CRLF
cQuery += "       ZFC_FILORI,	ZFC_PEDVEN,	ZFC_NUMEDA,	ZFC_STAEDA,	ZFC_NUMSAG,	ZFC_STASAG, ZFC_NF,	    ZFC_SERIE,	"+CRLF
cQuery += "       SA2.A2_MUN,   DA3_XTRANS, A4_NOME,    DA3_MOTORI, DA4_NOME,   ZF3_FORCOD, ZF3_FORLOJ"+CRLF
cQuery += "       FROM "+RETSQLNAME('ZFC')+" ZFC (NOLOCK) "+CRLF
cQuery += "         LEFT OUTER JOIN "+RETSQLNAME('ZF3')+" ZF3 (NOLOCK)"+CRLF
cQuery += "             ON ZF3.ZF3_FILIAL = '"+xfilial('SA2')+"' "+CRLF
cQuery += "             AND ZF3.ZF3_GRACOD = ZFC.ZFC_GRANJA"+CRLF
cQuery += "             AND ZF3.D_E_L_E_T_ = ' '"+CRLF
cQuery += "         LEFT OUTER JOIN "+RETSQLNAME('SA2')+" SA2 (NOLOCK)"+CRLF
cQuery += "             ON SA2.A2_FILIAL = '"+xfilial('SA2')+"' "+CRLF
cQuery += "             AND SA2.A2_COD = ZF3.ZF3_FORCOD"+CRLF
cQuery += "             AND SA2.A2_LOJA = ZF3.ZF3_FORLOJ"+CRLF
cQuery += "             AND SA2.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "         LEFT OUTER JOIN "+RETSQLNAME('DA3')+" DA3 (NOLOCK)"+CRLF
cQuery += "             ON DA3.DA3_FILIAL = '"+xfilial('DA3')+"' "+CRLF
cQuery += "             AND DA3.DA3_COD = ZFC.ZFC_VEICUL"+CRLF        
cQuery += "             AND DA3.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "         LEFT OUTER JOIN "+RETSQLNAME('DA4')+" DA4 (NOLOCK)"+CRLF
cQuery += "             ON DA4.DA4_FILIAL = '"+xfilial('DA4')+"' "+CRLF
cQuery += "             AND DA4.DA4_COD = DA3.DA3_MOTORI"+CRLF
cQuery += "             AND DA4.D_E_L_E_T_ = ' ' "+CRLF
cQuery += "         LEFT OUTER JOIN SA4010 SA4 (NOLOCK) "+CRLF
cQuery += "             ON SA4.A4_FILIAL = '"+xfilial('SA4')+"' "+CRLF
cQuery += "             AND SA4.A4_COD = DA3.DA3_XTRANS "+CRLF
cQuery += "             AND SA4.D_E_L_E_T_ = ' '  "+CRLF
cQuery += "       WHERE ZFC_DTACAR BETWEEN '"+DTOS(dMVPAR01)+"' AND '"+DTOS(dMVPAR02)+"'  "+CRLF
cQuery += "         AND ZFC_FILIAL BETWEEN '"+cMVPAR03+"' AND '"+cMVPAR04+"' "+CRLF
cQuery += "         AND ZFC_VEICUL BETWEEN '"+cMVPAR05+"' AND '"+cMVPAR06+"' "+CRLF
cQuery += "         AND ZFC_CODIGO BETWEEN '"+cMVPAR07+"' AND '"+cMVPAR08+"' "+CRLF
cQuery += "         AND ZFC_GRANJA BETWEEN '"+cMVPAR09+"' AND '"+cMVPAR10+"' "+CRLF
cQuery += "         AND ZFC.D_E_L_E_T_ = ' '"+CRLF
cQuery += "       ORDER BY ZFC_FILIAL,ZFC_DTACAR,ZFC_VEICUL,ZFC_CODIGO,ZFC_GRANJA"+CRLF

Memowrite('C:\TEMP\ADLOG081R.SQL',cQuery)
    
If Select("cAliasZFC") > 0
    cAliasZFC->(DbCloseArea())
EndIf
	
TcQuery cQuery New Alias "cAliasZFC"

DbSelectArea("cAliasZFC")
Count to _nCountRT
cAliasZFC->(dbGotop())
oProcess:SetRegua1(_nCountRT)
If cAliasZFC->(!EOF())
    While cAliasZFC->(!EOF())
        oProcess:IncRegua1("Processando RT..."+cEmpAnt+"/"+cAliasZFC->ZFC_FILIAL+"-"+cAliasZFC->ZFC_VEICUL)        
        oExcel:AddRow(_cPlanilha,_cTitulo,{	ZFC_FILIAL,;
			   ZFC_VEICUL,	DA3_MOTORI, DA4_NOME,   DA3_XTRANS, A4_NOME,    ZFC_CODIGO,	ZFC_GRANJA, ZF3_FORCOD,;  
               ZF3_FORLOJ,  A2_MUN,     ZFC_NRLOTE, ZFC_GALPAO,	ZFC_GAIOLA,	ZFC_AVEGA,  ZFC_TOTAL,	ZFC_PESPRE,;
               ZFC_FRTVLR,  ZFC_FRTPED,	ZFC_SEQUEN, ZFC_EQUIPE,	ZFC_AVESRE,	ZFC_PESREA, STOD(ZFC_DTACAR),	ZFC_HRAPRE,;
               STOD(ZFC_DTAPRE),  ZFC_DTAREA,	ZFC_HRAREA, ZFC_MOTIVO,	ZFC_VIAGEM,	ZFC_TIPVIA, ZFC_LACRES,	ZFC_NUMERO,;
               ZFC_STATUS,  ZFC_AMARRA,	ZFC_GUIAPE, ZFC_APANHA,	ZFC_HRCHEG,	ZFC_OBSERV, ZFC_FILORI,	ZFC_PEDVEN,;
               ZFC_NUMEDA,  ZFC_STAEDA,	ZFC_NUMSAG, ZFC_STASAG, ZFC_NF,     ZFC_SERIE})	// Linha
        cAliasZFC->(dbSkip())
    EndDo
    cAliasZFC->(DbCloseArea())
    If !(lJob)
        cTimeNow   := TIME()
        cDIRREDE := "\rel_log\"
        cNomArq := "REL_"+_cPlanilha+"_"+cEmpAnt+"_"+cFilAnt+"_"+DTOS(dDatabase)+"_"+STRTRAN(cTimeNow,":","")+".XLS" 
    Else
        cTimeNow   := TIME()
        cDIRREDE:= "\rel_log\"
        cNomArq := "REL_"+_cPlanilha+"_"+czEMP+"_"+czFIL+"_"+DTOS(dDatabase)+"_"+STRTRAN(cTimeNow,":","")+".XLS"
        cNomZip := "REL_"+_cPlanilha+"_"+czFIL+"_"+DTOS(dDatabase)+"_"+STRTRAN(cTimeNow,":","")+".ZIP"
    EndIf
    oExcel:Activate()
    If !(lJob)
        MsAguarde({||Processa({|| oExcel:GetXMLFile(cDIRREDE+cNomArq) })},"Processanento", "Gerando arquivo XML, aguarde....")
        nStatus:=__CopyFile((cDIRREDE+cNomArq),(cDIRLOCAL+cNomArq)) 		
		FERASE(cDIRREDE+cNomArq) 
	Else
        oExcel:GetXMLFile(cDIRREDE+cNomArq)

        fZip(cDIRARQ+cNomZip,{cDIRREDE+cNomArq})
     	//@Ticket 13242 ini
        cDIRREDE :="\rel_log\"
        nStatus:= __CopyFile((cDIRREDE+cNomArq),(cDIRLOCAL+cNomArq)) 		
		FERASE(cDIRREDE+cNomArq) 
    Endif
	oExcelApp:=MsExcel():New()                                         
	
    If !(lJob)
        oExcelApp:WorkBooks:Open( cDIRLOCAL+cNomArq ) // Abre uma planilha
        oExcelApp:SetVisible(.T.)
    Else
        aAdd(aAnexos, cDIRLOCAL+cNomZip)
        fEnvMail(cPara, cAssunto, cCorpo, aAnexos, lMostraLog, lUsaTLS)
	EndIf
EndIf

Return

/*/{Protheus.doc} Executa(oProcess) //Processamento do Relatorio
    @type  Function Static
    @author Antonio Domingos
    @since 21/06/2022
    @version TKT - 77061
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
/*/
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
        ConOut(cLog)
 
        //Se for para mostrar o log visualmente e for processo com interface com o usuário, mostra uma mensagem na tela
        If lMostraLog .And. ! IsBlind()
            Aviso("Log", cLog, {"Ok"}, 2)
        EndIf
    EndIf
 
    RestArea(aArea)
Return lRet
