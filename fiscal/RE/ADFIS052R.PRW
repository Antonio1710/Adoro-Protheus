#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#Include 'TOTVS.ch'
#include 'fwbrowse.ch'   
#INCLUDE "topconn.ch"
 #define CRLF Chr(13)+Chr(10)
/*/{Protheus.doc} ADFISR052R - CAT 83 -Relatorio Ordem de Produção / Exporta Excel
)
    @type  Function
    @author Antonio Domingos..
    @since 25/10/2022
    @version TKT - 78168
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    @see (links_or_references) u_ADFISR052R()
    @Ticket  78168, Data 25/10/2022, Antonio Domingos, RELATÓRIOS PORTARIA CAT/83

/*/

User Function ADFIS052R()

Local bProcess 		:= {|oSelf| Executa(oSelf) }
//
Local aInfoCustom 	:= {}
Local cTxtIntro	    := "Rotina responsável pela extracao em EXCEL de Ordem de Produção"
//Local cPerg         := "ADFIS052R"
Local aParamBox     := {}   
Local aRet 		    := {}   
Local cDescBox	    := "Informe a Data Inicial e Final para geração do Relatório."
cPara      := ""
cAssunto   := "Ordem de Produção em Excel"
cCorpo     := "Ordem de Produção em Excel"
aAnexos    := {}
lMostraLog := .F.
lUsaTLS    := .T.

Private oProcess
Private dMVPAR01   := DATE() //DATA DE CARREGAMENTO
Private dMVPAR02   := DATE() //DATA DE CARREGAMENTO
Private czEMP      := cEmpAnt
Private czFIL      := cFilAnt

Aadd( aParamBox,{ 1, "Data Ini: ", dMVPAR01	,"","","","",50, .T. } )
Aadd( aParamBox,{ 1, "Data Fim: ", dMVPAR02	,"","","","",50, .T. } )

If ParamBox( aParamBox, cDescBox, @aRet ) // com opção salvar
     //If ParamBox( aParamBox, cDescBox, @aRet, , , , , , , , .F., .F. ) // Sem opção salvar 
        
    oProcess := tNewProcess():New("ADFISR052R","Cat 83 - Ordem de Produção.",bProcess,cTxtIntro,,aInfoCustom, .T.,5, "Relação Roteiro", .T. )

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio Ordem de Produção ')
EndIf

Return
/*/{Protheus.doc} Executa(oProcess) //Processamento do Relatorio
    @type  Function Static
    @author Antonio Domingos..
    @since 25/10/2022
    @version TKT - 78168
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
/*/
Static Function Executa(oProcess)

Local cTimeNow   := ""
Local cDirLocal  := "C:\TEMP\"
Local _cPlanilha := "OP"
Local _cTitulo   := "CAT83 - Ordem de Produção"
Local _nCount1   := 0
Local _cAlias1   := GetNextAlias()
Local _sDtAnoIni :=  dtos(mv_par01)
Local _sDtAnoFim :=  dtos(MV_par02)
Local _cMVCAT83A := SUPERGETMV("MV_#CAT83A",.F.,"010/510/999/997/497") //TODOS TMS USADOS NA CAT83 FUNCAO ASDFIS052R
Local _cMVCAT83B := SUPERGETMV("MV_#CAT83B",.F.,"497") //TMS PARA VALORES NEGATIVOS USADOS NA CAT83 FUNCAO ASDFIS052R
Local _cD3TM_IN  
Private oExcel   := FwMsExcel():New()
Private cNomArq  := "OP_"+DTOS(dDatabase)+TIME()
Private cDIRARQ  := "C:\TEMP\"
Private cDIRREDE := "\SPOOL\"

_cMVCAT83A  := STRTRAN(_cMVCAT83A,"/","','")
_cD3TM_IN   := "%SD3.D3_TM IN ('" + _cMVCAT83A + "')%"

_cTitulo    := _cTitulo
oExcel:AddworkSheet(_cPlanilha) // Planilha
oExcel:AddTable (_cPlanilha,_cTitulo) // Titulo da Planilha (Cabeçalho)
oExcel:AddColumn(_cPlanilha,_cTitulo,"DATA" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"OP" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"CODIGO" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"DESCRICAO" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"TIPO" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"Quantidade" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"Data de Inicio" ,1,1)	
oExcel:AddColumn(_cPlanilha,_cTitulo,"Data de Encerramento" ,1,1)	

BeginSql Alias _cAlias1

SELECT D3_EMISSAO AS DDATA,
    SD3.D3_OP AS COP,
    SD3.D3_COD AS CCODIGO,
    SB1.B1_DESC AS CDESCRICAO,
    SD3.D3_TM AS CTM,
    SD3.D3_QUANT AS NQuantidade,
    SC2.C2_EMISSAO AS DDATAINIOP,
    SC2.C2_DATPRF AS DDATAENCOP 
    FROM %Table:SD3% SD3 (NOLOCK)
        INNER JOIN %Table:SB1% SB1 (NOLOCK)
        ON SB1.B1_FILIAL = %xFilial:SB1%
    AND SB1.B1_COD = SD3.D3_COD
    AND SB1.%NotDel%
    INNER JOIN %Table:SC2% SC2 (NOLOCK)
        ON SC2.C2_FILIAL = %xFilial:SC2%
        AND SC2.C2_NUM+SC2.C2_ITEM+SC2.C2_SEQUEN = SD3.D3_OP
        AND SC2.%NotDel%
    WHERE SD3.D3_FILIAL = %xFilial:SD3%
        AND SD3.D3_EMISSAO BETWEEN  %Exp:_sDtAnoIni% AND  %Exp:_sDtAnoFim%
        AND SD3.%NotDel%
        AND SD3.D3_OP NOT LIKE '%OS%'
        AND %exp:_cD3TM_IN%
    ORDER BY SD3.D3_EMISSAO,SD3.D3_OP,SC2.C2_NUM,SC2.C2_ITEM,SC2.C2_SEQUEN,SD3.D3_TM

ENDSQL

cQuery	:= GetLastQuery()[2]

MemoWrite("C:\TEMP\ADFIS052R.SQL",cQuery)


DbSelectArea(_cAlias1)
Count to _nCount1
(_cAlias1)->(dbGotop())
oProcess:SetRegua1(_nCount1)

If (_cAlias1)->(!EOF())

    dbSelectArea(_cAlias1)
    Count to _nCount1
    oProcess:SetRegua2(_nCount1)
    (_cAlias1)->(dbGotop())
    While (_cAlias1)->(!EOF())
        oProcess:IncRegua1("Processando OP..."+(_cAlias1)->COP)        
        oExcel:AddRow(_cPlanilha,_cTitulo,{STOD((_cAlias1)->DDATA),;
                                            (_cAlias1)->COP,;
                                            (_cAlias1)->CCODIGO,;
                                            (_cAlias1)->CDESCRICAO,;
                                            IF((_cAlias1)->CTM=="010","Produçao","Componente"),;
                                            IF((_cAlias1)->CTM $ _cMVCAT83B,(_cAlias1)->NQUANTIDADE*-1,(_cAlias1)->NQUANTIDADE),;
                                            STOD((_cAlias1)-> DDATAINIOP),;
                                            STOD((_cAlias1)->DDATAENCOP)})
        (_cAlias1)->(dbSkip())
    EndDo

    cTimeNow   := TIME()
    cDIRREDE:= "\spool\"
    cNomArq := "REL_OP_CA83_"+_cPlanilha+"_"+czEMP+"_"+czFIL+"_"+DTOS(dDatabase)+"_"+STRTRAN(cTimeNow,":","")+".XLS"
   
    oExcel:Activate()

    MsAguarde({||Processa({|| oExcel:GetXMLFile(cDIRREDE+cNomArq) })},"Processanento", "Gerando arquivo XML, aguarde....")
    nStatus:=__CopyFile((cDIRREDE+cNomArq),(cDIRLOCAL+cNomArq)) 		
	FERASE(cDIRREDE+cNomArq) 
	
	oExcelApp:=MsExcel():New()                                         
    oExcelApp:WorkBooks:Open( cDIRLOCAL+cNomArq ) // Abre uma planilha
    oExcelApp:SetVisible(.T.)

EndIf

Return

