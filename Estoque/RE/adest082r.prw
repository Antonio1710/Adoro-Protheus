#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#Include 'TOTVS.ch'
#include 'fwbrowse.ch'   
#INCLUDE "topconn.ch"
 #define CRLF Chr(13)+Chr(10)
/*/{Protheus.doc} ADEST082R - Relatorio de Movimentações Exporta Excel
)
    @type  Function
    @author Antonio Domingos
    @since 22/11/2022
    @version TKT -83108 - RELATÓRIO MOVIMENTAÇÃO
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    @see (links_or_references) u_ADEST082R()
    @Ticket 83108, Data 22/11/2022, Antonio Domingos, Relatorio de Movimentação
/*/

User Function ADEST082R(aParam)
Local bProcess 		:= {|oSelf| Executa(oSelf) }
Local aInfoCustom 	:= {}
Local cTxtIntro	    := "Rotina responsável pela extracao em EXCEL de relação das Movimentações"
local lSetEnv       := .f.

cPara      := ""
cAssunto   := "Relatorio de Movimentações em Excel"
cCorpo     := "Relatorio de Movimentações em Excel"
aAnexos    := {}
lMostraLog := .F.
lUsaTLS    := .T.
Private aParamBox		:= {}
Private aRet			:= {}
Private lJob          := IsBlind()
Private oProcess
Private cMVPAR01   
Private cMVPAR02   
Private dMVPAR03   
Private dMVPAR04  
Private nMVPAR05
Private cMVPAR06  
Private cMVPAR07
Private cMVPAR08  
Private cMVPAR09
Private cMVPAR10  
Private cMVPAR11  

Private czEMP
Private czFIL

If lJob
	RpcSetType(3)
	lSetEnv  := RpcSetEnv(aParam[1],aParam[2],,,"")
    czEMP    := aParam[1]   
    czFIL    := aParam[2]   
    
    PREPARE ENVIRONMENT EMPRESA czEMP FILIAL czFIL MODULO "EST"
    cPara      :=  SuperGetMv('MV_#EST082', .f. ,"fabio.souza@adoro.com.br" ) 
    
    oProcess := Executa()
Else
	Aadd( aParamBox ,{1,"Grupo De"  	,Space(TAMSX3("BM_GRUPO")[1]),"" ,'.T.',"SBM",'.T.',50,.F.})
	Aadd( aParamBox ,{1,"Grupo Até"  	,Space(TAMSX3("BM_GRUPO")[1]),"" ,'.T.',"SBM",'.T.',50,.F.})
	Aadd( aParamBox ,{1,"Data De"  		,CTOD(""),"" ,'.T.',"",'.T.',50,.F.})
	Aadd( aParamBox ,{1,"Data Até"  	,CTOD(""),"" ,'.T.',"",'.T.',50,.F.})
	Aadd( aParamBox ,{1,"Produto De"  	,Space(TAMSX3("B1_COD")[1]) ,"" ,'.T.',"SB1",'.T.',80,.F.})
	Aadd( aParamBox ,{1,"Produto Até"   ,Space(TAMSX3("B1_COD")[1]) ,"" ,'.T.',"SB1",'.T.',80,.F.})
	Aadd( aParamBox ,{1,"Local De"      ,Space(TAMSX3("B2_LOCAL")[1]),"" ,'.T.',"NNR",'.T.',30,.F.})
	Aadd( aParamBox ,{1,"Local Até"     ,Space(TAMSX3("B2_LOCAL")[1]),"" ,'.T.',"NNR",'.T.',30,.F.})
	Aadd( aParamBox ,{1,"Endereço De"   ,Space(TAMSX3("BE_LOCALIZ")[1]) ,"" ,'.T.',"SBE",'.T.',80,.F.})
	Aadd( aParamBox ,{1,"Endereço Até"  ,Space(TAMSX3("BE_LOCALIZ")[1]) ,"" ,'.T.',"SBE",'.T.',80,.F.})
	aAdd( aParamBox	,{3,"Considera prod bloqueados"		,1,{'Todos','Sim','Não'},100,"",.F.})
	
    if ParamBox(aParamBox,"Parâmetros",@aRet)
        oProcess := tNewProcess():New("ADEST082R","Relação das movimentações de Produtos.",bProcess,cTxtIntro,,aInfoCustom, .T.,5, "Relatório de Movimentações", .T. )
    EndIf

Endif

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatório de Movimentações')

Return
/*/{Protheus.doc} Executa(oProcess) //Processamento do Relatorio
    @type  Function Static
    @author Antonio Domingos..
    @since 22/11/2022
    @version TKT - 83108
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
/*/
Static Function Executa(oProcess)

Local _cAlias    := GetNextAlias()
//Local _cHrTot    := ""
//Local _cCodExec  := ""
//Local _cNmExec   := ""
Local cTimeNow  := ""
Local cDirLocal := "C:\TEMP\"
Local _cPlanilha := "RM"
Local _cTitulo   := "Relatório de Movimentações"
//Local _nCount
Local _nCountSS
Local _cWhere
Private oExcel  	:= FwMsExcel():New()
Private dDataIni	
Private dDataFim
Private cNomArq
Private cDIRARQ
Private cDIRREDE
Private cMVPAR05

If lJob
    cMVPAR01	:= " "
    cMVPAR02	:= "ZZZZ"
    dMVPAR03    := YearSub(Date(), 2)
    dMVPAR04    := date()
    cMVPAR05    := " "
    cMVPAR06    := "ZZZZZZZZZZZZZZ"
    cMVPAR07    := " "
    cMVPAR08	:= "ZZZZ"
    cMVPAR09	:= " "
    cMVPAR10    := "ZZZZ"
    cMVPAR11    := "1"
Else
    cMVPAR01	:= MV_PAR01
    cMVPAR02	:= MV_PAR02
    dMVPAR03	:= MV_PAR03
    dMVPAR04	:= MV_PAR04
    cMVPAR05	:= MV_PAR05
    cMVPAR06    := MV_PAR06
    cMVPAR07    := MV_PAR07
    cMVPAR08	:= MV_PAR08
    cMVPAR09    := MV_PAR09
    cMVPAR10    := MV_PAR10
    cMVPAR11    := MV_PAR11
EndIf

_cWhere := If(STR(CMVPAR11,1,0)$"12","%SB1.B1_MSBLQL = '2'%","%SB1.B1_MSBLQL = '1'%") 

_cTitulo    := _cTitulo+"-"+cMVPAR05
oExcel:AddworkSheet(_cPlanilha) // Planilha
oExcel:AddTable (_cPlanilha,_cTitulo) // Titulo da Planilha (Cabeçalho)
oExcel:AddColumn(_cPlanilha,_cTitulo,"Produto"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"Descrição"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"Desc.Compl."         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"Armazem"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"UM"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"Qtd Atual"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"Qtde Cons."         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"Grupo"         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"Val.Total Atu."         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"Custo Medio Atu."         ,1,1)
oExcel:AddColumn(_cPlanilha,_cTitulo,"Endereço"         ,1,1)

Beginsql Alias _cAlias
    %NoPARSER%  
    SELECT B2_COD,B1_DESC,B1_DESCOMP,B2_LOCAL,B1_UM,B2_QATU,B1_GRUPO,B2_VATU1,B2_CM1,B2_LOCALIZ,D3_TM,SUM(D3_QUANT) D3_QTDCON
        FROM %Table:SB2% SB2 (NOLOCK)
        INNER JOIN %Table:SB1% SB1 (NOLOCK)
            ON B1_FILIAL = %xFilial:SB1%
            AND SB1.B1_COD = B2_COD
            AND SB1.B1_GRUPO BETWEEN %Exp:cMVPAR01% AND %Exp:cMVPAR02%
            AND %Exp:_cWhere%
            AND SB1.%NotDel%
        LEFT OUTER JOIN %Table:SD3% SD3 (NOLOCK)
            ON SD3.D3_FILIAL = SB2.B2_FILIAL
            AND SD3.D3_COD = B1_COD
            AND SD3.D3_LOCAL = SB2.B2_LOCAL
            AND SD3.D3_EMISSAO BETWEEN %Exp:DTOS(dMVPAR03)% and %Exp:DTOS(dMVPAR04)%
            AND SD3.D3_TM > '500'
            AND SD3.%NotDel%
        WHERE SB2.B2_FILIAL = %xFilial:SB2%
            AND SB2.B2_COD BETWEEN %Exp:cMVPAR05% AND %Exp:cMVPAR06%
            AND SB2.B2_LOCAL BETWEEN %Exp:cMVPAR07% AND %Exp:cMVPAR08%
            AND SB2.B2_LOCALIZ BETWEEN %Exp:cMVPAR09% AND %Exp:cMVPAR10%
            AND SB2.%NotDel%
        GROUP BY B2_COD,B1_DESC,B1_DESCOMP,B2_LOCAL,B1_UM,B2_QATU,B1_GRUPO,B2_VATU1,B2_CM1,B2_LOCALIZ,D3_TM
EndSql

aQuery := GetLastQuery()
/*
[1] cAlias - Alias usado para abrir o Cursor.
[2] cQuery - Query executada.
[3] aCampos - Array de campos com critério de conversão especificados.
[4] lNoParser - Caso .T., não foi utilizada ChangeQuery() na String original.
[5] nTimeSpend - Tempo, em segundos, utilizado para a abertura do Cursor.
*/
If Len(aQuery) > 0
    cQuery := aQuery[2]
    Memowrite("C:\TEMP\ADEST082R.SQL",cQuery)
EndIf

DbSelectArea(_cAlias)
Count to _nCountSS
(_cAlias)->(dbGotop())
oProcess:SetRegua1(_nCountSS)
If (_cAlias)->(!EOF())
    While (_cAlias)->(!EOF())
        
        oProcess:IncRegua1("Processando...Rel.Mov."+RTRIM((_cAlias)->B2_COD)+" "+RTRIM((_cAlias)->B1_DESC))        
        
        oExcel:AddRow(_cPlanilha,_cTitulo,{	B2_COD,;
                                        	B1_DESC,;
                                            B1_DESCOMP,;
                                            B2_LOCAL,;
                                            B1_UM,;
                                            B2_QATU,;
                                            D3_QTDCON,;
                                            B1_GRUPO,;
                                            B2_VATU1,;
                                            B2_CM1,;
                                            B2_LOCALIZ})	// Linha
        (_cAlias)->(dbSkip())

    EndDo
    (_cAlias)->(DbCloseArea())
    If !(lJob)
        cTimeNow   := TIME()
        cDIRREDE := "\SPOOL\"
        cNomArq := "REL_MOV_"+_cPlanilha+"_"+cEmpAnt+"_"+cFilAnt+"_"+DTOS(dDatabase)+"_"+STRTRAN(cTimeNow,":","")+".XLS" 
    Else
        cTimeNow   := TIME()
        cDIRREDE:= "\SPOOL\"
        cNomArq := "REL_MOV_"+_cPlanilha+"_"+czEMP+"_"+czFIL+"_"+DTOS(dDatabase)+"_"+STRTRAN(cTimeNow,":","")+".XLS"
        cNomZip := "REL_MOV_"+_cPlanilha+"_"+czFIL+"_"+DTOS(dDatabase)+"_"+STRTRAN(cTimeNow,":","")+".ZIP"
    EndIf
    oExcel:Activate()
    If !(lJob)
        MsAguarde({||Processa({|| oExcel:GetXMLFile(cDIRREDE+cNomArq) })},"Processanento", "Gerando arquivo XML, aguarde....")
        __CopyFile((cDIRREDE+cNomArq),(cDIRLOCAL+cNomArq)) 		
	Else
        oExcel:GetXMLFile(cDIRREDE+cNomArq)

        fZip(cDIRARQ+cNomZip,{cDIRREDE+cNomArq})
        cDIRREDE :="\SPOOL\"
        nStatus:= __CopyFile((cDIRREDE+cNomArq),(cDIRLOCAL+cNomArq)) 		
		If FError() == 25 //Arquivo já existe na pasta destino
			//FERASE(cDIRREDE+cNomArq) 
            nStatus:= __CopyFile((cDIRREDE+cNomArq),(cDIRLOCAL+cNomArq)) 
		EndIf
    Endif

    If !(lJob)
    	oExcelApp := MsExcel():New()
        oExcelApp:WorkBooks:Open( cDIRLOCAL+cNomArq ) // Abre uma planilha
        oExcelApp:SetVisible(.T.)
    Else
        aAdd(aAnexos, cDIRLOCAL+cNomZip)
        fEnvMail(cPara, cAssunto, cCorpo, aAnexos, lMostraLog, lUsaTLS)
	EndIf
else
   Aviso("ADEST082R-001. Atenção!", "Não há dados para serem apresentados! Verifique os parâmetros!!!", {"OK"}, 3) 
EndIf

Return

/*/{Protheus.doc} Executa(oProcess) //Processamento do Relatorio
    @type  Function Static
    @author Antonio Domingos
    @since 22/11/2022
    @version TKT - 83103
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
