#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#Include 'TOTVS.ch'
#include 'fwbrowse.ch'   
#INCLUDE "topconn.ch"

#define CRLF Chr(13)+Chr(10)

/*/{Protheus.doc} ADFISR051R - CAT83 - Relatorio Evolução do Produto / Exporta Excel
)
    @type  Function
    @author Antonio Domingos..
    @since 25/10/2022
    @version TKT - 78168
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    @see (links_or_references) u_ADFISR051R()
    @Ticket  78168, Data 25/10/2022, Antonio Domingos, RELATÓRIOS PORTARIA CAT/83..
    @Ticket  78168, Data 08/02/2023, Antonio Domingos, RELATÓRIOS PORTARIA CAT/83...Ajuste de Impressão
/*/

User Function ADFIS051R()

Local bProcess 		:= {|oSelf| Executa(oSelf) }
//
Local aInfoCustom 	:= {}
Local cTxtIntro	    := "Rotina responsável pela extracao em EXCEL de Evolução Produto"
 Local cDescBox	 := "Parametros"
Local aParamBox  := {}   
Local aRet 		 := {}

cPara      := ""
cAssunto   := "Evolução Produto em Excel"
cCorpo     := "Evolução Produto em Excel"
aAnexos    := {}
lMostraLog := .F.
lUsaTLS    := .T.

Private oProcess
Private dMVPAR01   := DATE() //DATA DE CARREGAMENTO
Private dMVPAR02   := DATE() //DATA DE CARREGAMENTO
Private czEMP      := cEmpAnt
Private czFIL      := cFilAnt
Private cMVPAR03   := CriaVar("B1_COD",.F.)
Private cMVPAR04   := CriaVar("B1_COD",.F.)
Private cMVPAR05   := CriaVar("B1_LOCPAD",.F.)
Private cMVPAR06   := CriaVar("B1_LOCPAD",.F.)

Aadd( aParamBox,{ 1, "Data Ini: ", dMVPAR01	,"","","","",50, .T. } )
Aadd( aParamBox,{ 1, "Data Fim: ", dMVPAR02	,"","","","",50, .T. } )
Aadd( aParamBox ,{1,"Do  Produto:",cMVPAR03,"" ,'.T.',"SB1",'.T.',80,.F.,})
Aadd( aParamBox ,{1,"Ate Produto:",cMVPAR04,"" ,'.T.',"SB1",'.T.',80,.F.,})
Aadd( aParamBox ,{1,"Do  Armazem:",cMVPAR05,"" ,'.T.',"NNR",'.T.',30,.F.,})
Aadd( aParamBox ,{1,"Ate Armazem:",cMVPAR06,"" ,'.T.',"NNR",'.T.',30,.F.,})

If ParamBox( aParamBox, cDescBox, @aRet ) // com opção salvar
     //If ParamBox( aParamBox, cDescBox, @aRet, , , , , , , , .F., .F. ) // Sem opção salvar 
    oProcess := tNewProcess():New("ADFISR051R","Cat 83 - Evolução Produto.",bProcess,cTxtIntro,,aInfoCustom, .T.,5, "Relação Roteiro", .T. )

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio Evolução do Produto ')
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

Local cTimeNow  := ""
Local cDirLocal := "C:\TEMP\"
Local _cPlanilha := "EV"
Local _cTitulo   := "EVOLUCAO PRODUTOS - "+DTOC(mv_par01)+" A "+DTOC(mv_par02)
Local _nCount1,_nCount2,_nCount3 := 0
Local _cAlias1 := GetNextAlias()
Local _cAlias2 := ""
Local _cAlias3 := GetNextAlias()
Local _aNomMes   := {"JANEIRO","FEVEREIRO","MARCO","ABRIL","MAIO","JUNHO","JULHO","AGOSTO","SETEMBRO","OUTUBRO","NOVEMBRO","DEZEMBRO"}
Local _aNumMes   := {"01","02","03","04","05","06","07","08","09","10","11","12"}
Local _n1,_n2,_N4,_n5 := 1
Local _aCampos2   := {}
Local _aCampos3   := {}
Local _aColunas :={}
Local _cZVHAlias  := "ZVH"
Private _dDtAnoIni,_dDtAnoFim,_dDtJanIni,_dDtJanFim,_dDtFevIni,_dDtFevFim,_dDtMarIni,_dDtMarFim,_dDtAbrIni,_dDtAbrFim
Private _dDtMaiIni,_dDtMaiFim,_dDtJunIni,_dDtJunFim,_dDtJulIni,_dDtJulFim,_dDtAgoIni,_dDtAgoFim,_dDtSetIni,_dDtSetFim
Private _dDtOutIni,_dDtOutFim,_dDtNovIni,_dDtNovFim,_dDtDezIni,_dDtDezFim
Private  _cQuery  := ""
Private oExcel  	:= FwMsExcel():New()
Private cNomArq := "EV_"+DTOS(dDatabase)+TIME()
Private cDIRARQ := "C:\TEMP\"
Private cDIRREDE := "\SPOOL\"

    //Inicia a Montagem do cabec da Planilha configurado pela tabela ZVH-Configuração de Evolução do Produto  
    oExcel:AddworkSheet(_cPlanilha) // Planilha
    oExcel:AddTable (_cPlanilha,_cTitulo) // Titulo da Planilha (Cabeçalho)
    oExcel:AddColumn(_cPlanilha,_cTitulo,"Código",1,1)
    oExcel:AddColumn(_cPlanilha,_cTitulo,"Descrição",1,1)
    oExcel:AddColumn(_cPlanilha,_cTitulo,"Mês",1,1)
    aAdd(_aColunas, "COD")	
    aAdd(_aColunas, "DESCRI")	
    aAdd(_aColunas, "NOMMES")	
    
    // Inicio da criação dos campos do Arquivo de Trabalho 2
    aAdd(_aCampos2, {'COD',"C",015, 0} )	
    aAdd(_aCampos2, {'DESCRI',"C",100, 0} )	
    aAdd(_aCampos2, {'NUMMES',"C",002, 0} )	
    aAdd(_aCampos2, {'NOMMES',"C",003, 0} )	

    // Inicio da criação dos campos do Arquivo de Trabalho 3
    aAdd(_aCampos3, {'B1_COD',"C",015, 0} )	
    aAdd(_aCampos3, {'B1_DESC',"C",040, 0} )	
    aAdd(_aCampos3, {'DESCRI',"C",040, 0} )	
    aAdd(_aCampos3, {'SIGLA',"C",06, 0} )	
    aAdd(_aCampos3, {'TIPOAC',"C",01, 0} )	
    aAdd(_aCampos3, {'JANEIRO',"N",017, 2} )	
    aAdd(_aCampos3, {'FEVEREIRO',"N",017, 0} )	
    aAdd(_aCampos3, {'MARCO',"N",017, 2} )		
    aAdd(_aCampos3, {'ABRIL',"N",017, 2} )		
    aAdd(_aCampos3, {'MAIO',"N",017, 2} )		
    aAdd(_aCampos3, {'JUNHO',"N",017, 2} )		
    aAdd(_aCampos3, {'JULHO',"N",017, 2} )		
    aAdd(_aCampos3, {'AGOSTO',"N",017, 2} )		
    aAdd(_aCampos3, {'SETEMBRO',"N",017, 2} )		
    aAdd(_aCampos3, {'OUTUBRO',"N",017, 2} )		
    aAdd(_aCampos3, {'NOVEMBRO',"N",017, 2} )		
    aAdd(_aCampos3, {'DEZEMBRO',"N",017, 2} )	

    // Crio TRB para impressão
    // https://tdn.totvs.com.br/display/framework/FWTemporaryTable
    oTempTable := FWTemporaryTable():New(_cAlias3)

    oTempTable:SetFields(_aCampos3)
    oTempTable:AddIndex("01", {"B1_COD"} )
    oTempTable:Create()

    dbSelectArea(_cAlias3)
    
    //Tabela de Configuração dos Filtros da Query
    dbSelectArea(_cZVHAlias)
    dbSetOrder(1)        
    (_cZVHAlias)->(dbGotop())
    While !(_cZVHAlias)->(Eof()) .And. ZVH->ZVH_FILIAL == xFilial("ZVH")
        //Monta a Query baseada na tabela ZVH-Param.Rel. Ev.Produtos        
        If ZVH_TABELA <> 'XXX'
            _cQuery :=""
            fMontQry(ZVH_TABELA,ALLTRIM(ZVH_DESCRI),ZVH_SIGLA,alltrim(ZVH_TES),alltrim(ZVH_CFOP),alltrim(ZVH_MINTCF),;
            alltrim(ZVH_MINTTM),ZVH_AESTOQ,ZVH_GDUPLI,alltrim(ZVH_CONDIC),ZVH_TIPOAC)

            MemoWrite("C:\TEMP\ADFIS051R_"+ZVH_TABELA+"_"+ALLTRIM(ZVH_DESCRI)+".SQL",_cQuery)
            
            IF Select (_cAlias1) > 0
                (_cAlias1)->(DbCloseArea())
            EndIf

            DbUseArea(.T., "TOPCONN", TcGenQry(,,_cQuery), _cAlias1)
            
            DbSelectArea(_cAlias1)
            Count to _nCount1
            (_cAlias1)->(dbGotop())
            oProcess:SetRegua1(_nCount1)
            While !(_cAlias1)->(Eof())
                oProcess:IncRegua1("Processando Reg: "+(_cAlias1)->B1_COD+(_cAlias1)->SIGLA)        
                dbSelectArea(_cAlias3)
                RecLock(_cAlias3,.T.)
                    (_cAlias3)->B1_COD:=(_cAlias1)->B1_COD 
                    (_cAlias3)->B1_DESC:=(_cAlias1)->B1_DESC
                    (_cAlias3)->DESCRI:=(_cAlias1)->DESCRI
                    (_cAlias3)->SIGLA:=(_cAlias1)->SIGLA
                    (_cAlias3)->TIPOAC:=(_cAlias1)->TIPOAC
                    (_cAlias3)->JANEIRO:=(_cAlias1)->JANEIRO
                    (_cAlias3)->FEVEREIRO:=(_cAlias1)->FEVEREIRO
                    (_cAlias3)->MARCO:=(_cAlias1)->MARCO
                    (_cAlias3)->ABRIL:=(_cAlias1)->ABRIL
                    (_cAlias3)->MAIO:=(_cAlias1)->MAIO
                    (_cAlias3)->JUNHO:=(_cAlias1)->JUNHO
                    (_cAlias3)->JULHO:=(_cAlias1)->JULHO
                    (_cAlias3)->AGOSTO:=(_cAlias1)->AGOSTO
                    (_cAlias3)->SETEMBRO:=(_cAlias1)->SETEMBRO
                    (_cAlias3)->OUTUBRO:=(_cAlias1)->OUTUBRO
                    (_cAlias3)->NOVEMBRO:=(_cAlias1)->NOVEMBRO
                    (_cAlias3)->DEZEMBRO:=(_cAlias1)->DEZEMBRO
                (_cAlias3)->(MsUnlock())
                (_cAlias1)->(dbSkip())
            EndDo
            (_cAlias1)->(dbCloseArea())
        EndIf
        
        //Continua a Montagem do cabec da Planilha configurado pela tabela ZVH-Configuração de Evolução do Produto
        oExcel:AddColumn(_cPlanilha,_cTitulo,(_cZVHAlias)->ZVH_DESCRI,1,1)	
        //Continuação da criação dos campos do arquivo de trabalho        
        If AScan(_aCampos2, {|x| AllTrim(x[1]) == (_cZVHAlias)->ZVH_SIGLA}) = 0 
            aAdd(_aCampos2, {(_cZVHAlias)->ZVH_SIGLA,"N",017,2})
        EndIf
        If AScan(_aColunas, (_cZVHAlias)->ZVH_SIGLA) = 0 
            aAdd(_aColunas, (_cZVHAlias)->ZVH_SIGLA)	
        EndIf
        (_cZVHAlias)->(dbSkip())
    EndDo

DbSelectArea(_cAlias3)
Count to _nCount3
(_cAlias3)->(dbGotop())
oProcess:SetRegua1(_nCount3)

If (_cAlias3)->(!EOF())

        _cAlias2 := "TRB_SB1"

        If Select(_cAlias2) > 0
            (_cAlias2)->( dbCloseArea() )
        EndIf
		
        // Crio TRB para impressão
        // https://tdn.totvs.com.br/display/framework/FWTemporaryTable
        oTempTable := FWTemporaryTable():New(_cAlias2)

        oTempTable:SetFields(_aCampos2)
        oTempTable:AddIndex("01", {"COD","NUMMES"} )
        oTempTable:Create()

        
        //oTempTable:Delete()  

    aStruct := (_cAlias2)->(dbStruct())
    
    While !(_cAlias3)->(EOF())
           oProcess:IncRegua1("Processando Produto: "+(_cAlias3)->B1_COD)        
           For _n1 := 1 to Len(_aNomMes)
                dbSelectArea(_cAlias2)
                If !dbSeek((_cAlias3)->B1_COD+_aNumMes[_n1]) 
                        RECLOCK(_cAlias2,.T.)
                        (_cAlias2)->COD    := (_cAlias3)->B1_COD
                        (_cAlias2)->NUMMES := _aNumMes[_n1]
                    else
                        RECLOCK(_cAlias2,.F.)
                EndIf
                (_cAlias2)->NOMMES := _aNomMes[_n1]
                (_cAlias2)->DESCRI := (_cAlias3)->B1_DESC
                If !Empty((_cAlias3)->&(_aNomMes[_n1]))
                    For _n2 := 5 to Len(aStruct)
                        If ALLTRIM((_cAlias3)->SIGLA) == ALLTRIM((_cAlias2)->(FieldName(_n2)))
                            //Se tipo do Acumulador for igual a 1, Soma valor no SaldoFinal
                            If (_cAlias3)->TIPOAC == '1'
                                (_cAlias2)->&(FieldName(_n2)) := (_cAlias3)->&(_aNomMes[_n1])
                                (_cAlias2)->SLDFIM += (_cAlias2)->&(FieldName(_n2))   
                            //Se Tipo do Acumlador for igual a 2, Subtrai valor do Saldo Final
                            ElseIf (_cAlias3)->TIPOAC == '2'
                                (_cAlias2)->&(FieldName(_n2)) := ((_cAlias3)->&(_aNomMes[_n1]) * -1)
                                (_cAlias2)->SLDFIM += (_cAlias2)->&(FieldName(_n2))   
                            else
                                (_cAlias2)->&(FieldName(_n2)) := (_cAlias3)->&(_aNomMes[_n1])
                            EndIf
                            //Obs: Para não somar e nem subtrair do saldo final, cadastrar o Tipo de Acumulador como 3=não acumula
                        EndIf
                    Next _n2
                EndIf
            Next _n1
        (_cAlias3)->(dbSkip())
    EndDo

    (_cAlias3)->(DbCloseArea())
   
    aNomeCampos  := {}
    aDadosCampos := {}

    dbSelectArea(_cAlias2)
    Count to _nCount2
    oProcess:SetRegua2(_nCount2)
    (_cAlias2)->(dbGotop())
    While (_cAlias2)->(!EOF())
        oProcess:IncRegua2("Gerando Excel..."+(_cAlias2)->COD)        
        aDadosCampos:={}
        _n4:=0
        
        (_cAlias2)->&(FieldName(Len(_aColunas)+1)) := (_cAlias2)->&(FieldName(Len(_aColunas)-1)) - (_cAlias2)->&(FieldName(Len(_aColunas)))
        
        For _n4 := 1 to Len(_aColunas)
            If Valtype((_cAlias2)->&(_aColunas[_n4])) == "C"
                AADD(aDadosCampos,alltrim((_cAlias2)->&(_aColunas[_n4])))
            Else
                AADD(aDadosCampos,alltrim(Transform((_cAlias2)->&(_aColunas[_n4]),"@E 99,999,999,999.99")))
            EndIf
        Next _n4
        //INICIO - Ticket  78168, Data 08/02/2023 - Ajuste de Impressão
        //Zera as variaveis para acumular valores de movimentos nas tabelas SB9, SD1, SD2, SD3
        _nVlTt_B9     := 0
        _nVlTt_D1D2D3 := 0
        //Acumula os valores nas variaveis de movimentos para validação se a linha da planilha vai ser gerada ou não        
        For _n5 := 4 to Len(aDadosCampos)-3
            If _n5 == 4
                _nVlTt_B9 += abs(val(aDadosCampos [_n5]))
            ElseIf _n5 > 4
                _nVlTt_D1D2D3 += abs(val(aDadosCampos [_n5]))
            EndIf
        Next
        //Valida se houve movimentação e saldo inicial para gravar ou não a linha da planilha
        //Se SD1, SD2, SD3 igual a vazio e SB9 <> 0 não trazer no relatório
        If _nVlTt_D1D2D3 == 0 .And. _nVlTt_B9 <> 0 .or. _nVlTt_D1D2D3 == 0 .And. _nVlTt_B9 == 0
            _lGravaLinha := .f.
        Else
            _lGravaLinha := .T.
        EndIf
        //Se linha validada gera Excel
        If _lGravaLinha
            oExcel:AddRow(_cPlanilha,_cTitulo,aDadosCampos)
        EndIf
        //FIM - Ticket  78168, Data 08/02/2023 - Ajuste de Impressão
        (_cAlias2)->(dbSkip())
    EndDo

    cTimeNow   := TIME()
    cDIRREDE:= "\rel_log\"
    cNomArq := "REL_EV_CA83_"+_cPlanilha+"_"+czEMP+"_"+czFIL+"_"+DTOS(dDatabase)+"_"+STRTRAN(cTimeNow,":","")+".XLS"
   
    oExcel:Activate()

    MsAguarde({||Processa({|| oExcel:GetXMLFile(cDIRREDE+cNomArq) })},"Processanento", "Gerando arquivo XML, aguarde....")
    nStatus:=__CopyFile((cDIRREDE+cNomArq),(cDIRLOCAL+cNomArq)) 		
	FERASE(cDIRREDE+cNomArq) 
	
	oExcelApp:=MsExcel():New()                                         
    oExcelApp:WorkBooks:Open( cDIRLOCAL+cNomArq ) // Abre uma planilha
    oExcelApp:SetVisible(.T.)

EndIf

Return

/*/{Protheus.doc} fMontQry() - Monta Query dinamica configurada na Tabela ZVH - Configuração do Relatorio CAT83 - Evolução do Produto

    @type  Static Function
    @author Antonio Domingos..
    @since 25/10/2022
    @version TKT - 78168
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    @see (links_or_references) u_ADFISR051R()
    @Ticket  78168, Data 25/10/2022, Antonio Domingos, RELATÓRIOS PORTARIA CAT/83

/*/

Static Function fMontQry(_cTABELA,_cDESCRI,_cSIGLA,_cTES,_cCFOP,_cMINTCF,_cMINTTM,_cAESTOQ,_cGDUPLI,_cCONDIC,_cTIPOAC)
    
    Local _cCpoQtde := If(_cTabela == "SD1","D1_QUANT"  ,If(_cTabela=="SD2","D2_QUANT"  ,If(_cTabela=="SD3","D3_QUANT"  ,If(_cTabela=="ZBL","ZBL_QTD"  ,"B9_QINI"))))
    Local _cCpoData := If(_cTabela == "SD1","D1_DTDIGIT",If(_cTabela=="SD2","D2_EMISSAO",If(_cTabela=="SD3","D3_EMISSAO"  ,If(_cTabela=="ZBL","ZBL_DT_EST"  ,"B9_DATA"))))
    Local _cCpoTpES := If(_cTabela == "SD1","D1_TES"    ,If(_cTabela=="SD2","D2_TES"    ,"D3_TM"))
    Local _cCpoCod  := If(_cTabela == "SD1","D1_COD"    ,If(_cTabela=="SD2","D2_COD"    ,If(_cTabela=="SD3","D3_COD"  ,If(_cTabela=="ZBL","ZBL_COD_IT"  ,"B9_COD"))))
    Local _cCpoCF   := If(_cTabela == "SD1","D1_CF"     ,If(_cTabela=="SD2","D2_CF"     ,"D3_CF"))
    Local _cFilTab  := If(_cTabela == "SD1","D1_FILIAL" ,If(_cTabela=="SD2","D2_FILIAL" ,If(_cTabela=="SD3","D3_FILIAL"  ,If(_cTabela=="ZBL","ZBL_UNIDAD"  ,"B9_FILIAL"))))
    Local _cCpoArm  := If(_cTabela == "SD1","D1_LOCAL"  ,If(_cTabela=="SD2","D2_LOCAL"  ,If(_cTabela=="SD3","D3_LOCAL"   ,If(_cTabela=="ZBL"," ","B9_LOCAL"))))

    //Preparação das variaveis para o comando IN() do SQL.
    _cTES    := Strtran(_cTES,"/","','")
    _cCFOP   := Strtran(_cCFOP,"/","','")
    _cMINTCF := Strtran(_cMINTCF,"/","','")
    _cMINTTM := Strtran(_cMINTTM,"/","','")

    //Datas para calculo mensal Inicio e Fim de Mês
    //_fMontData(mv_par01,mv_par02)

    _dDtAnoIni :=  CTOD("01/01/"+Str(Year(mv_par01),4,0))
    _dDtAnoFim  :=  CTOD("31/12/"+Str(Year(mv_par01),4,0))
    
    If _cTabela == "SB9" //Datas para saldo inicial por mês
        _dDataIni := LastDay(FirstDay(mv_par01)-1)
        _dDataFim := mv_par02
        //_dDataIni :=  _dDataFim := LastDay(FirstDay(_dDtAnoIni)-1)
        _dDtJanIni := _dDtJanFim := LastDay(_dDtAnoIni-1)
        _dDtFevIni := _dDtFevFim := LastDay(_dDtJanIni+1) 
        _dDtMarIni := _dDtMarFim := LastDay(_dDtFevIni+1) 
        _dDtAbrIni := _dDtAbrFim := LastDay(_dDtMarIni+1)
        _dDtMaiIni := _dDtMaiFim := LastDay(_dDtAbrIni+1)
        _dDtJunIni := _dDtJunFim := LastDay(_dDtMaiIni+1) 
        _dDtJulIni := _dDtJulFim := LastDay(_dDtJunIni+1) 
        _dDtAgoIni := _dDtAgoFim := LastDay(_dDtJulIni+1)
        _dDtSetIni := _dDtSetFim := LastDay(_dDtAgoIni+1) 
        _dDtOutIni := _dDtOutFim := LastDay(_dDtSetIni+1) 
        _dDtNovIni := _dDtNovFim := LastDay(_dDtOutIni+1) 
        _dDtDezIni := _dDtDezFim := LastDay(_dDtNovIni+1) 
    else //Datas para calculo mensal Inicio e Fim de Mês
        _dDataIni := mv_par01
        _dDataFim := MV_par02
        _fMontData(mv_par01,mv_par02)
    EndIf
    
    If !Empty(_cQuery)
        _cQuery += "UNION "+CRLF
    EndIf
    _cQuery += " SELECT B1_COD,B1_DESC,'"+_cDESCRI+"' AS DESCRI,'"+_cSIGLA+"' AS SIGLA, '"+_cTIPOAC+"' AS TIPOAC, "+CRLF
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtJanIni)+"' AND '"+DTOS(_dDtJanFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) JANEIRO, "+CRLF
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtFevIni)+"' AND '"+DTOS(_dDtFevFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) FEVEREIRO, "+CRLF
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtMarIni)+"' AND '"+DTOS(_dDtMarFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) MARCO, "+CRLF
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtAbrIni)+"' AND '"+DTOS(_dDtAbrFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) ABRIL, "+CRLF
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtMaiIni)+"' AND '"+DTOS(_dDtMaiFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) MAIO, "+CRLF 
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtJunIni)+"' AND '"+DTOS(_dDtJunFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) JUNHO, "+CRLF 
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtJulIni)+"' AND '"+DTOS(_dDtJulFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) JULHO, "+CRLF 
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtAgoIni)+"' AND '"+DTOS(_dDtAgoFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) AGOSTO, "+CRLF 
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtSetIni)+"' AND '"+DTOS(_dDtSetFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) SETEMBRO, "+CRLF
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtOutIni)+"' AND '"+DTOS(_dDtOutFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) OUTUBRO, "+CRLF
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtNovIni)+"' AND '"+DTOS(_dDtNovFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) NOVEMBRO, "+CRLF
    _cQuery += "  SUM(IIF("+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDtDezIni)+"' AND '"+DTOS(_dDtDezFim)+"' , "+_cTabela+"."+_cCpoQtde+" ,0)) DEZEMBRO "+CRLF
    _cQuery += "  FROM "+RETSQLNAME(_cTabela)+" "+_cTabela+" (NOLOCK) "+CRLF
    If _cTabela $ "SD1/SD2"    
       _cQuery += " INNER JOIN "+RETSQLNAME('SF4')+" SF4 (NOLOCK)"
       _cQuery += " ON SF4.F4_FILIAL = '"+xFilial("SF4")+"'"
       _cQuery += " AND SF4.F4_CODIGO = "+_cTabela+"."+_cCpoTpES+""
       If !Empty(_cAESTOQ)
           _cQuery += " AND RTRIM(SF4.F4_ESTOQUE) = '"+_cAESTOQ+"'"
       EndIf
       If !Empty(_cGDUPLI)
           _cQuery += " AND RTRIM(SF4.F4_DUPLIC) = '"+_cGDUPLI+"'"
       EndIf
       _cQuery += "    AND SF4.D_E_L_E_T_ = ' ' "+CRLF 
    EndIf
    _cQuery += " INNER JOIN "+RETSQLNAME('SB1') +" SB1  (NOLOCK)"
    _cQuery += " ON SB1.B1_FILIAL = '"+xFilial('SB1')+"'"
    _cQuery += " AND SB1.B1_COD = "+_cTabela+"."+_cCpoCod+""
    _cQuery += " AND SB1.B1_MSBLQL <> '1'"
    _cQuery += " AND SB1.D_E_L_E_T_ = ' '"+CRLF
    _cQuery += " WHERE "+_cTabela+".D_E_L_E_T_ = ' '"
    _cQuery += "    AND "+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS(_dDataIni)+"' AND '"+DTOS(_dDataFim)+"' "+CRLF //Ticket  78168, Data 08/02/2023
    //_cQuery += " AND "+_cTabela+"."+_cCpoData+"  BETWEEN '"+DTOS( _dDataIni)+"' AND '"+DTOS(_dDtAnoFim)+"'"
    _cQuery += " AND "+_cTabela+".D_E_L_E_T_ = ' '"
    If _cTabela $ "SD1/SD2"
        If !Empty(_cCFOP)
            _cQuery += " AND RTRIM("+_cTabela+"."+_cCpoCF+" ) IN('"+_cCFOP+"')"
        EndIf
        If !Empty(_cTES)
            _cQuery += " AND "+_cTabela+"."+_cCpoTpES+" IN('"+_cTES+"')"
        EndIf
    EndIf
    If _cTabela == "SD3"
        If !Empty(_cMINTCF)
            _cQuery += " AND "+_cTabela+"."+_cCpoCF+" IN('"+_cMINTCF+"')"
        EndIf
        If !Empty(_cMINTTM)
            _cQuery += " AND "+_cTabela+"."+_cCpoTpES+" IN('"+_cMINTTM+"')"
        EndIf
    EndIf
    If !Empty(_cCONDIC)
        _cQuery += " AND  "+_cCONDIC+"  "
    EndIf
    _cQuery += " AND "+_cTabela+"."+_cCpoCod+" BETWEEN '"+mv_par03+"' AND '"+mv_par04+"'"
    If _cTabela = "ZBL"
        _cQuery += " AND "+_cFilTab+" = '"+xFilial("SB2")+"' " //Pego o xFilial da SB2 porque a ZBL está com ZBL_FILIAL = ' '
        _cQuery += " AND ZBL_IND_ES = '0' " //ZBL-BLOCOK - Deve ser considerado apenas o Indicador de estoque = 0
    Else
        _cQuery += " AND "+_cFilTab+" = '"+xFilial(_cTabela)+"' "
    EndIf
    If !Empty(_cCpoArm)
        _cQuery += " AND "+_cTabela+"."+_cCpoArm+" BETWEEN '"+mv_par05+"' AND '"+mv_par06+"'"
    EndIf
    _cQuery += " GROUP BY B1_COD,B1_DESC "+CRLF 

Return(_cQuery)
/*/{Protheus.doc} _fMontData(_dDataIni,_dDataFim)
    Monta Datas para calculo mensal Inicio e Fim de Mês
    @type  Static Function
    @author Antonio Domingos..
    @since 25/10/2022
    @version TKT - 78168
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    @see (links_or_references) u_ADFISR051R()
    @Ticket  78168, Data 25/10/2022, Antonio Domingos, RELATÓRIOS PORTARIA CAT/83

/*/
Static Function _fMontData(_dDataIni,_dDataFim)

    _dDtJanIni :=  CTOD("01/01/"+Str(Year(_dDataIni),4,0))
    _dDtJanFim :=  LastDay(CTOD("01/01/"+Str(Year(_dDataIni),4,0)))
    _dDtFevIni :=  CTOD("01/02/"+Str(Year(_dDataIni),4,0))
    _dDtFevFim :=  LastDay(CTOD("01/02/"+Str(Year(_dDataIni),4,0)))
    _dDtMarIni :=  CTOD("01/03/"+Str(Year(_dDataIni),4,0))
    _dDtMarFim :=  LastDay(CTOD("01/03/"+Str(Year(_dDataIni),4,0)))
    _dDtAbrIni :=  CTOD("01/04/"+Str(Year(_dDataIni),4,0))
    _dDtAbrFim :=  LastDay(CTOD("01/04/"+Str(Year(_dDataIni),4,0)))
    _dDtMaiIni :=  CTOD("01/05/"+Str(Year(_dDataIni),4,0))
    _dDtMaiFim :=  LastDay(CTOD("01/05/"+Str(Year(_dDataIni),4,0)))
    _dDtJunIni :=  CTOD("01/06/"+Str(Year(_dDataIni),4,0))
    _dDtJunFim :=  LastDay(CTOD("01/06/"+Str(Year(_dDataIni),4,0)))
    _dDtJulIni :=  CTOD("01/07/"+Str(Year(_dDataIni),4,0))
    _dDtJulFim :=  LastDay(CTOD("01/07/"+Str(Year(_dDataIni),4,0)))
    _dDtAgoIni :=  CTOD("01/08/"+Str(Year(_dDataIni),4,0))
    _dDtAgoFim :=  LastDay(CTOD("01/08/"+Str(Year(_dDataIni),4,0)))
    _dDtSetIni :=  CTOD("01/09/"+Str(Year(_dDataIni),4,0))
    _dDtSetFim :=  LastDay(CTOD("01/09/"+Str(Year(_dDataIni),4,0)))
    _dDtOutIni :=  CTOD("01/10/"+Str(Year(_dDataIni),4,0))
    _dDtOutFim :=  LastDay(CTOD("01/10/"+Str(Year(_dDataIni),4,0)))
    _dDtNovIni :=  CTOD("01/11/"+Str(Year(_dDataIni),4,0))
    _dDtNovFim :=  LastDay(CTOD("01/11/"+Str(Year(_dDataIni),4,0)))
    _dDtDezIni :=  CTOD("01/12/"+Str(Year(_dDataIni),4,0))
    _dDtDezFim :=  LastDay(CTOD("01/12/"+Str(Year(_dDataIni),4,0)))

Return
