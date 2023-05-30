#include "protheus.ch"
#include "topconn.ch"
#Include "Tbiconn.ch"

/*/{Protheus.doc} User Function ADLFV011R
	WF - Schedule - Acompanhamento Frango Vivo Chamado 038867
	@type  Function
	@author Fernando Macieira
	@since 05/09/2018
	@version 01
	@history Chamado 046464 - William  				- 15/01/2019 - Nใo mostra notas que tiveram devolucoes no relatorio de frango vivo
	@history Chamado TI     - Adriana  				- 24/05/2019 - Devido a substituicao email para shared relay, substituido MV_RELACNT p/ MV_RELFROM
	@history Chamado 055444 - William  				- 11/02/2020 - Ajustado error log do programa ADINF009P estava na posi็ใo errada
	@history Chamado 055979 - Abel Babini			- 28/02/2020 - COMPLEMENTO FRANGO VIVO - Melhoria no filtro que identifica se estแ PENDENTE ou RECEBIDO
	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	@history ticket 71972 - Fernando Macieira - 28/04/2022 - Complemento Frango Vivo - Granja HH - Filial 0A
	@history ticket 72339 - Fernando Macieira - 03/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
	@history ticket 72339 - Fernando Macieira - 04/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
	@history ticket 72339 - Fernando Macieira - 16/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo filial/granja
	@history ticket 72339 - Fernando Macieira - 20/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo de logs pois manualmente o email dispara e no schedule nใo
	@history ticket 72339 - Fernando Macieira - 23/05/2022 - Tratamento array para passagem do parโmetro
	@history ticket 75333 - Everson  - 29/06/2022 - Alterada a ordena็ใo dos registros do relat๓rio para ordem de abate.
	@history ticket 80876 - Jonathan - 26/10/2022 - Cria็ใo da coluna ORIGEM e DESTINO e corre็ใo da baixas de NF pendentes
	@history ticket 85390 - Antonio  - 25/01/2023 -Validacao fontes v33 - dic. banco de dados.
	@history Ticket 89710 - Adriano Savoine   - 10/03/2023 - Alterado o indice da tabela Temporaria.
	@history Ticket 89439 - Jonathan Carvalho - 15/03/2023 - Ajuste no Fonte email parou de disparar
/*/
User Function ADLFV011R(aParam)

	Local cQuery  := ""
	Local nDias   := ""
	
	// Dados do PV/NF
	Local cCliCod := ""
	Local cCliLoj := ""
	Local cProdPV := ""
	Local cTESPV  := ""

	// @history ticket 72339 - Fernando Macieira - 23/05/2022 - Tratamento array para passagem do parโmetro
	Local cEmpJob, cFilJob

	Default aParam    	:= Array(2)
	Default aParam[1] 	:= "01"
	Default aParam[2] 	:= "02"

	//Default cEmpJob := "01"
	//Default cFilJob := "02"

	cEmpJob := aParam[1]
	cFilJob := aParam[2]
	//
	
	// Filial Frango Vivo
	Private cFilGranjas  := ""
	
	Private cArquivo, cPath, cMails, cDescri, cRootPath, cFilPre, cFornCod, cLojaCod, cEspLFV, cProduto, cTESPre

	// Inicializa ambiente
	RpcClearEnv()
	RpcSetType(3)

	If !RpcSetEnv( cEmpJob, cFilJob )
		ConOut("[ADLFV011R] - Ambiente nใo inicializado! Verifique...") // @history ticket 72339 - Fernando Macieira - 20/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo de logs pois manualmente o email dispara e no schedule nใo
		Return .F.
	Else
		logZBN("Ambiente inicializado " + cEmpJob + "/" + cFilJob) // @history ticket 72339 - Fernando Macieira - 20/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo de logs pois manualmente o email dispara e no schedule nใo
	EndIf
	
	// @history ticket 72339 - Fernando Macieira - 20/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo de logs pois manualmente o email dispara e no schedule nใo
	// Garanto uma ๚nica thread sendo executada - // Adoro - Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - fwnm - 29/06/2020
	/*
	If !LockByName("ADLFV011R", .T., .F.)
		ConOut("[ADLFV011R] - Existe outro processamento sendo executado! Verifique...")
		RPCClearEnv()
		Return
	EndIf
	*/
	//

	// @history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	//FWMonitorMsg(ALLTRIM(PROCNAME()))
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'WF - Schedule - Acompanhamento Frango Vivo')
	
	// Carrega Variaveis
	nDias   := GetMV("MV_#LFVDIA",,3)
	
	// Filial Frango Vivo
	cFilGranjas    := GetMV("MV_#GRANJA",,"03|0A") // GetMV("MV_#LFVFIL",,"03") // @history ticket 71972 - Fernando Macieira - 28/04/2022 - Complemento Frango Vivo - Granja HH - Filial 0A
	
	//cFilGranjas := "0A" // DEBUG - INIBIR
	
	// Dados do PV/NF
	cCliCod := GetMV("MV_#LFVCLI",,"027601|248103") // @history ticket 72339 - Fernando Macieira - 04/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
	cCliLoj := GetMV("MV_#LFVLOJ",,"00")
	cProdPV := GetMV("MV_#LFVPRD",,"300042") 
	cTESPV  := GetMV("MV_#LFVTES",,"701")
	
	// Dados da Nota Entrada Classificada
	cFilPre   := GetMV("MV_#LFVPRE",,"02")
	cFornCod  := GetMV("MV_#LFVFOR",,"000217")
	cLojaCod  := GetMV("MV_#LFVLOJ",,"01")
	cEspLFV   := GetMV("MV_#LFVESP",,"SPED")
	cProduto  := GetMV("MV_#LFVPRD",,"300042")  
	cTESPre   := GetMV("MV_#LFVTEE",,"031")

	// @history ticket 72339 - Fernando Macieira - 04/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
	cFilPre0B   := GetMV("MV_#LFVABA",,"0B")
	// @history ticket 80876 - Jonathan Carvalho - 26/10/2022 - Codigo Fornecedor da Filial 0A
	cFornCod0A  := GetMV("MV_#LFVABA",,"030057")
	
	// Emails
	cMails  :=  GetMV("MV_#LFVMA3",,"danielle.meira@adoro.com.br;reinaldo.francischinelli@adoro.com.br;fwnmacieira@gmail.com") 
	cDescri := "ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - " + AllTrim(DtoC(msDate()))
	
	// Cria arquivo TMP
	CriaTMP()
	
	cDateWFAnt  := ""
	cDateWF     := DtoS( (msDate()-nDias) )
	
	// Trato Janeiro
	cDateWFAnt  := Right(Left(AllTrim(DtoS(msDate())),6),2)
	If cDateWFAnt <> "01"
		cDateWFAnt     := AllTrim(Str(Val(Left(AllTrim(DtoS(msDate())),6))-1))+"01"
	Else 
		cDateWFAnt     := AllTrim(Str((Val(Left(AllTrim(DtoS(msDate())),4))-1)))+"1201"
	EndIf
	
	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf
	
	cQuery := " SELECT D2_FILIAL, D2_DOC, D2_SERIE, D2_PEDIDO, D2_EMISSAO, D2_COD, D2_TES, D2_QUANT, D2_UM, D2_CLIENTE  
	cQuery += " FROM " + RetSqlName("SD2") + " (NOLOCK) 
	//cQuery += " WHERE D2_FILIAL='"+cFilGranjas+"' " // @history ticket 71972 - Fernando Macieira - 28/04/2022 - Complemento Frango Vivo - Granja HH - Filial 0A
	cQuery += " WHERE D2_FILIAL IN " + FormatIn(cFilGranjas,"|")
	//cQuery += " AND D2_CLIENTE='"+cCliCod+"' " // @history ticket 72339 - Fernando Macieira - 04/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
	cQuery += " AND D2_CLIENTE IN " + FormatIn(cCliCod,"|")
	cQuery += " AND D2_LOJA='"+cCliLoj+"' 
	cQuery += " AND D2_COD='"+cProdPV+"'
	cQuery += " AND D2_TES='"+cTESPV+"' 
	cQuery += " AND D2_EMISSAO BETWEEN '"+cDateWFAnt+"' AND '"+cDateWF+"' 
	cQuery += " AND D2_DOC NOT IN (SELECT D1_NFORI FROM " + RetSqlName("SD1") + " WHERE D1_FILIAL = D2_FILIAL AND D1_NFORI = D2_DOC AND D1_SERIORI = D2_SERIE AND D1_ITEMORI = D2_ITEM AND D1_COD = D2_COD AND D_E_L_E_T_ <> '*') " //chamado: 046464 - 15/01/2019 - William
	cQuery += " AND D_E_L_E_T_='' 
	cQuery += " ORDER BY 1,5
	
	tcQuery cQuery New Alias "Work"
	
	aTamSX3 := TamSX3("D2_EMISSAO")
	tcSetField("Work", "D2_EMISSAO", aTamSX3[3], aTamSX3[1], aTamSX3[2])
	
	aTamSX3 := TamSX3("D2_QUANT")
	tcSetField("Work", "D2_QUANT", aTamSX3[3], aTamSX3[1], aTamSX3[2])
	
	Work->( dbGoTop() )
	Do While Work->( !EOF() )
		GrvArquivo( Work->D2_FILIAL, Work->D2_DOC, Work->D2_SERIE, Work->D2_PEDIDO, Work->D2_EMISSAO, Work->D2_QUANT, Work->D2_UM, Work->D2_CLIENTE )
		Work->( dbSkip() )
	EndDo
	
	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf
	
	// Gero XLS para envio no anexo do email
	//GeraXLS() -- Inibido conf. diretriz Reginaldo e Danielle em 14/05/2018 -- Solicitado para gerar conte๚do no corpo do email
	
	// Enviar email
	EmailFVL()
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ?
	//ณDestrava a rotina para o usuแrio	    ?
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤ?
	//UnLockByName("ADLFV011R") // @history ticket 72339 - Fernando Macieira - 20/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo de logs pois manualmente o email dispara e no schedule nใo

	RpcClearEnv()
	RpcSetType(3)

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณWFLFV     บAutor  ณMicrosiga           บ Data ณ  05/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function CriaTMP()

	Local aStru		:= {}
	Local cDirDocs  := MsDocPath()
	Local aAreaAtu  := GetArea()
	Local oTrb

	cArquivo  := "ATMP" //ticket 85390 - Antonio - 25/01/2023
	
	If Select(cArquivo) > 0  //ticket 85390 - Antonio - 25/01/2023
		//DbSelectArea(cArquivo)  //ticket 85390 - Antonio - 25/01/2023 //ticket 89439 - Jonathan 15/03/2023
		(cArquivo)->(DbCloseArea())  //ticket 85390 - Antonio - 25/01/2023
	Endif

	// Cria arq tmp
	
	/*
	ORIGEM / DESTINO / DATA EMISSรO / NF / GRANJA / GRANJADA / Nบ GTA (Guia Transporte Animal)/ STATUS
	No campo STATUS:
	RECEBIDO - Quando a NF Foi pesada pela Balan็a;
	PENDENTE - Quando a Nota Fiscal ainda nใo chegou no Abate.
	*/
	
	//aStru := {} //ticket 85390 - Antonio - 25/01/2023 

	oTrb:= FWTemporaryTable():New(cArquivo) //Ticket 89439 - Jonathan 15/03/2023

	AADD (aStru,{"ORIGEM"	  , "C", TamSX3("D2_FILIAL")[1]  , 0}) //ticket 85390 - Antonio - 25/01/2023
	AADD (aStru,{"DESTINO"	  , "C", TamSX3("D2_FILIAL")[1]  , 0}) //ticket 85390 - Antonio - 25/01/2023
	AADD (aStru,{"EMISSAO"	  , "D", TamSX3("D2_EMISSAO")[1] , 0})
	AADD (aStru,{"NF"         , "C", TamSX3("D2_DOC")[1]     , 0})
	AADD (aStru,{"SERIE"      , "C", TamSX3("D2_SERIE")[1]   , 0})
	AADD (aStru,{"GRANJA"     , "C", TamSX3("ZV1_RGRANJ")[1] , 0})
	AADD (aStru,{"GRANJADA"   , "C", TamSX3("C5_MENNOT2")[1] , 0})
	AADD (aStru,{"QUANTIDADE" , "N", TamSX3("D2_QUANT")[1]   , TamSX3("D2_QUANT")[2]})
	AADD (aStru,{"UM"         , "C", TamSX3("D2_UM")[1]      , 0})
	AADD (aStru,{"ABATE"	  , "C", 10          			 , 0})
	AADD (aStru,{"STATUS"     , "C", 08                      , 0})
	AADD (aStru,{"FILIAL"     , "C", TamSX3("D2_FILIAL")[1]  , 0})

	oTrb:SetFields(aStru) //Ticket 89439 - Jonathan 15/03/2023
	//oTrb:= FWTemporaryTable():New(cArquivo, aStru) //ticket 85390 - Antonio  - 25/01/2023
	oTrb:AddIndex("01", {"ABATE","FILIAL","NF"} ) //ticket 85390 - Antonio  - 25/01/2023
	//Ticket 89710 - Adriano Savoine - 10/03/2023

	/*dbCreate(cArquivo,aStru)
	dbUseArea(.T.,,cArquivo,cArquivo,.F.,.F.)
	// @history ticket 72339 - Fernando Macieira - 16/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo filial/granja
	cNameIdx := FileNoExt(cArquivo)
	//DBCreateIndex(cNameIdx,'FILIAL+NF')
	DBCreateIndex(cNameIdx,'ABATE+FILIAL+NF') //Everson - 29/06/2022. Chamado 75333.*/
	//

	//Ticket 89439 - Jonathan 15/03/2023
	oTrb:Create()
	DbSelectArea(cArquivo)
	//
	
	RestArea( aAreaAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณADLFV011R บAutor  ณMicrosiga           บ Data ณ  05/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GrvArquivo(cD2_FILIAL, cD2_DOC, cD2_SERIE, cD2_PEDIDO, dD2_EMISSAO, nD2_QUANT, cD2_UM, cD2_CLIENTE)

	Local cStatus     := "PENDENTE"
	Local cGranjada   := ""
	Local cZV1_RGRANJ := ""
	Local aZV1_RGRANJ := {}
	Local dDataAbate  := "" 
	Local aAreaAtu    := GetArea()
	Local cFilDest    := "" //Ticket 80876 - Jonathan Carvalho 26/10/2022
	Local _lContinua  //ticket 85390 - Antonio  - 25/01/2023

	//Ticket 80876 - Jonathan Carvalho 26/10/2022
	If Alltrim(cD2_CLIENTE) == "248103"
		cFilDest := "0B"
	else
		cFilDest := "02"
	EndIf

	//GRANJADA
	SC5->( dbSetOrder(1) ) // C5_FILIAL+C5_NUM
	If SC5->( dbSeek(cD2_FILIAL+cD2_PEDIDO) ) // @history ticket 72339 - Fernando Macieira - 03/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
		cGranjada := AllTrim(SC5->C5_MENNOT2)
	EndIf
	
	//Granja e Status
	aZV1_RGRANJ := LoadZV1(cD2_FILIAL, cD2_DOC, cD2_SERIE) // @history ticket 72339 - Fernando Macieira - 03/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
	
	If !Empty(aZV1_RGRANJ)
		// Granja
		cZV1_RGRANJ := aZV1_RGRANJ[1]
		dDataAbate  := aZV1_RGRANJ[3]
		
		// Status
		// Modificado conforme diretriz Danielle - buscar SD1 (CLASSIFICADA)
		/*
		If !Empty(aZV1_RGRANJ[2])
			cStatus := "RECEBIDO"
		EndIf
		*/
	Else
		lDebug := .t.	
	EndIf
	
	// Dados da Nota Entrada Classificada
	// @history ticket 72339 - Fernando Macieira - 04/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
	If AllTrim(cD2_FILIAL) == "03" // Granja 03
		SD1->( dbSetOrder(1) ) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		// Busco abatedouro 02
		If SD1->( dbSeek(cFilPre+cD2_DOC+cD2_SERIE+cFornCod+cLojaCod+cProduto) )		
			SF1->( dbSetOrder(1) ) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
			If SF1->( dbSeek(cFilPre+cD2_DOC+cD2_SERIE+cFornCod+cLojaCod+SD1->D1_TIPO) ) //Chamado 055979 - Abel Babini			- 28/02/2020 - COMPLEMENTO FRANGO VIVO - Melhoria no filtro que identifica se estแ PENDENTE ou RECEBIDO
				If !Empty(SD1->D1_TES) .AND. !Empty(SF1->F1_STATUS)
					cStatus := "RECEBIDO"
				EndIf
			EndIf
		// Busco abatedouro 0B
		ElseIf SD1->( dbSeek(cFilPre0B+cD2_DOC+cD2_SERIE+cFornCod+cLojaCod+cProduto) )		 
			SF1->( dbSetOrder(1) ) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
			If SF1->( dbSeek(cFilPre0B+cD2_DOC+cD2_SERIE+cFornCod+cLojaCod+SD1->D1_TIPO) ) //Chamado 055979 - Abel Babini			- 28/02/2020 - COMPLEMENTO FRANGO VIVO - Melhoria no filtro que identifica se estแ PENDENTE ou RECEBIDO
				If !Empty(SD1->D1_TES) .AND. !Empty(SF1->F1_STATUS)
					cStatus := "RECEBIDO"
				EndIf
			EndIf
		EndIf
	ElseIf AllTrim(cD2_FILIAL) == "0A" // Granja HH
		SD1->( dbSetOrder(1) ) // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEM
		// Busco abatedouro 02
		If SD1->( dbSeek(cFilPre+cD2_DOC+cD2_SERIE+cFornCod0A+cLojaCod+cProduto) )		
			SF1->( dbSetOrder(1) ) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
			If SF1->( dbSeek(cFilPre+cD2_DOC+cD2_SERIE+cFornCod0A+cLojaCod+SD1->D1_TIPO) ) 
				If !Empty(SD1->D1_TES) .AND. !Empty(SF1->F1_STATUS)
					cStatus := "RECEBIDO"
				EndIf
			EndIf
		// Busco abatedouro 0B
		ElseIf SD1->( dbSeek(cFilPre0B+cD2_DOC+cD2_SERIE+cFornCod0A+cLojaCod+cProduto) )		
			SF1->( dbSetOrder(1) ) // F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO
			If SF1->( dbSeek(cFilPre0B+cD2_DOC+cD2_SERIE+cFornCod0A+cLojaCod+SD1->D1_TIPO) ) //Chamado 055979 - Abel Babini			- 28/02/2020 - COMPLEMENTO FRANGO VIVO - Melhoria no filtro que identifica se estแ PENDENTE ou RECEBIDO
				If !Empty(SD1->D1_TES) .AND. !Empty(SF1->F1_STATUS)
					cStatus := "RECEBIDO"
				EndIf
			EndIf
		EndIf
	EndIf
	
	/*
	No campo STATUS:
	RECEBIDO - Quando a NF Foi pesada pela Balan็a;
	PENDENTE - Quando a Nota Fiscal ainda nใo chegou no Abate.
	*/
	_lContinua:=.f. //ticket 85390 - Antonio  - 25/01/2023
	If Select(cArquivo) > 0  //ticket 85390 - Antonio  - 25/01/2023
		_lContinua := .t. //ticket 85390 - Antonio  - 25/01/2023 
	EndIf
	// Listar apenas pendente conf. diretriz Reginaldo e Danielle em 14/05/2018
	If AllTrim(cStatus) == "PENDENTE" .And. _lContinua //ticket 85390 - Antonio  - 25/01/2023
	
		RecLock(cArquivo, .t.)
		
		(cArquivo)->ORIGEM   		:= cD2_FILIAL // @history ticket 72339 - Fernando Macieira - 16/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo filial/granja
		(cArquivo)->DESTINO			:= cFilDest
		(cArquivo)->EMISSAO    		:= dD2_EMISSAO
		(cArquivo)->NF         		:= cD2_DOC
		(cArquivo)->SERIE      		:= cD2_SERIE
		(cArquivo)->GRANJA     		:= cZV1_RGRANJ
		(cArquivo)->GRANJADA   		:= cGranjada
		(cArquivo)->QUANTIDADE 		:= nD2_QUANT
		(cArquivo)->UM         		:= cD2_UM
		(cArquivo)->ABATE      		:= dDataAbate  
		(cArquivo)->STATUS     		:= cStatus
		
		(cArquivo)->( msUnLock() )
	
	EndIf
	
	RestArea( aAreaAtu )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณADLFV011R บAutor  ณMicrosiga           บ Data ณ  05/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function GeraXLS()

	Local cDirDocs  := MsDocPath()
	Local aAreaAtu  := GetArea()
	
	cIniFile   := GetAdv97()
	cRootPath  := GetPvProfString(GetEnvServer(),"RootPath","ERROR", cIniFile )
	cStartPath := GetPvProfString(GetEnvServer(),"StartPath","ERROR", cIniFile )
	
	cPathData := cRootPath+"\LFV\"
	cPath     := cRootPath + cStartPath
	
	dbSelectArea(cArquivo)
	(cArquivo)->( dbCloseArea() )
	
	If !ExistDir(cPathData)
		MakeDir(cPathData)
	EndIf
	
	If !ExistDir(cPath+"\LFV\")
		MakeDir(cPath)
	EndIf
	
	If !ExistDir("\LFV\")
		MakeDir("\LFV\")
	EndIf
	
	fErase( cPath+"LFV\WFLFV.XLS" )
	fErase( cRootPath+"\LFV\WFLFV.XLS" )
	fErase( cPath+"WFLFV.XLS" )
	fErase("\LFV\WFLFV.XLS")
	
	// Copio arquivo tmp para pasta LFV abaixo do rootpath jแ renomeando
	__CopyFile(cStartPath+cArquivo+GetDBExtension(), "\LFV\WFLFV.XLS" )
	
	
	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Deleta arquivo de Trabalho                                   ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	fErase( cArquivo+GetDBExtension() )
	fErase( cArquivo+OrdBagExt() )

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณADLFV011R บAutor  ณMicrosiga           บ Data ณ  05/09/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function LoadZV1(cD2_FILIAL, cD2_DOC, cD2_SERIE) 

	Local cQuery := ""
	Local aZV1_RGRANJ := {}
	Local cFilAbat    := GetMV("MV_#ABATES",,"02|0B") // @history ticket 72339 - Fernando Macieira - 04/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
	
	If Select("WorkZV1")
		WorkZV1->( dbCloseArea() )
	EndIf
	
	cQuery := " SELECT ZV1_RGRANJ, ZV1_STATUS , CONVERT(VARCHAR(10),CAST(ZV1_DTABAT AS DATE),3) AS ZV1_DTABAT
	cQuery += " FROM " + RetSqlName("ZV1") + " ZV1 (NOLOCK) 
	cQuery += " INNER JOIN ZFC010 ZFC (NOLOCK) ON ZFC_FILIAL=ZV1_FILIAL AND ZFC_NUMERO=ZV1_NUMOC AND ZFC_FILORI='"+cD2_FILIAL+"' AND ZFC.D_E_L_E_T_='' " // @history ticket 72339 - Fernando Macieira - 03/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
	//cQuery += " WHERE ZV1_FILIAL='"+FWxFilial("ZV1")+"' " // @history ticket 72339 - Fernando Macieira - 04/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO
	cQuery += " WHERE ZV1_FILIAL IN " + FormatIn(cFilAbat,"|")
	cQuery += " AND ZV1_NUMNFS LIKE '%"+AllTrim(Str(Val(cD2_DOC)))+"' 
	cQuery += " AND ZV1_SERIE='"+cD2_SERIE+"' 
	cQuery += " AND ZV1.D_E_L_E_T_='' 
	
	tcQuery cQuery New Alias "WorkZV1"
	
	// Populo array
	WorkZV1->( dbGoTop() )
	If WorkZV1->( !EOF() )
		aAdd( aZV1_RGRANJ, WorkZV1->ZV1_RGRANJ )
		aAdd( aZV1_RGRANJ, WorkZV1->ZV1_STATUS )
		aAdd( aZV1_RGRANJ, WorkZV1->ZV1_DTABAT ) //Chamado:043187 - Fernnado sigoli 20/08/2018
	Else	
		lDebug := .t.
	EndIf
		
	If Select("WorkZV1")
		WorkZV1->( dbCloseArea() )
	EndIf

Return aZV1_RGRANJ

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณADLFV011R บAutor  ณFernando Macieira   บ Data ณ  04/18/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ Envia email com dados do PV Complemento Frango Vivo        บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Adoro                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function EmailFVL()

	logZBN(cDescri) // @history ticket 72339 - Fernando Macieira - 20/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo de logs pois manualmente o email dispara e no schedule nใo
	ProcRel()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณlogZBN    บAutor  ณFernando Sigoli     บData  ณ  29/03/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescricao ณGera log na ZBN.                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso: Adoro S/A                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/

Static Function logZBN(cDescri)

	Local aArea	:= GetArea()
	Local cNomeRotina := "ADLFV011R"

	Default cDescri := ""
	
	DbSelectArea("ZBN")
	RecLock("ZBN",.T.)
		ZBN_FILIAL  := xFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= cNomeRotina
		ZBN_DESCRI  := cDescri
	MsUnlock()
		
	ZBN->(dbCloseArea())
	
	RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณprocRel   บAutor  ณFernando Sigoli     บData  ณ  29/03/2018 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณGera relat๓rio.                                             บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAdoro S/A                                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function procRel()

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declara็ใo de variแvies.
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local aArea		:= GetArea()
	Local cAssunto	:= cDescri
	Local cMensagem	:= ""
	
	//
	cMensagem += '<html>'
	cMensagem += '<body>'
	cMensagem += '<p style="color:red">'+cValToChar(cDescri)+'</p>'
	cMensagem += '<hr>'
	cMensagem += '<table border="1">'
	cMensagem += '<tr style="background-color: black;color:white">'
	cMensagem += '<td>Origem</td>' // @history ticket 72339 - Fernando Macieira - 16/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo filial/granja
	cMensagem += '<td>Destino</td>'
	cMensagem += '<td>Emissao</td>'
	cMensagem += '<td>Nota Fiscal</td>'
	cMensagem += '<td>S้rie</td>'
	cMensagem += '<td>Granja</td>'
	cMensagem += '<td>Granjada</td>'
	cMensagem += '<td>Quantidade</td>'
	cMensagem += '<td>UM</td>'
	cMensagem += '<td>Abate</td>'
	cMensagem += '<td>Status</td>'
	cMensagem += '</tr>'
	
	If SELECT(cArquivo) > 0 //ticket 85390 - Antonio  - 25/01/2023
	
		dbSelectArea(cArquivo)
		(cArquivo)->( dbGoTop() )
		Do While (cArquivo)->( !EOF() )
			
			cMensagem += '<tr>'
			cMensagem += '<td>' + cValToChar((cArquivo)->ORIGEM)	    							 + '</td>' // @history ticket 72339 - Fernando Macieira - 16/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo filial/granja
			cMensagem += '<td>' + cValToChar((cArquivo)->DESTINO)   		 						 + '</td>'
			cMensagem += '<td>' + cValToChar((cArquivo)->EMISSAO)    								 + '</td>'
			cMensagem += '<td>' + cValToChar((cArquivo)->NF)       									 + '</td>'
			cMensagem += '<td>' + cValToChar((cArquivo)->SERIE)   									 + '</td>'
			cMensagem += '<td>' + cValToChar((cArquivo)->GRANJA)   									 + '</td>'
			cMensagem += '<td>' + cValToChar((cArquivo)->GRANJADA)   							     + '</td>'
			cMensagem += '<td>' + cValToChar(Transform((cArquivo)->QUANTIDADE,"@E 999,999,999.99"))  + '</td>'
			cMensagem += '<td>' + cValToChar((cArquivo)->UM)     									 + '</td>'
			cMensagem += '<td>' + cValToChar((cArquivo)->ABATE)    									 + '</td>' //Chamado:043187 - Fernnado sigoli 20/08/2018
			cMensagem += '<td>' + cValToChar((cArquivo)->STATUS)       								 + '</td>'
			cMensagem += '</tr>'
			
			(cArquivo)->( dbSkip() )
			
		EndDo
		
		cMensagem += '</table>'
		cMensagem += '</body>'
		cMensagem += '</html>'
		
		//
		ProcessarEmail(cAssunto,cMensagem,cMails)
		
	EndIf //ticket 85390 - Antonio  - 25/01/2023
	//
	RestArea(aArea)

Return Nil

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณprocessarEmail บAutor  ณFernando Sigoli     บData  ณ  29/03/2018 บฑฑ
ฑฑฬออออออออออุอออออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณConfigura็๕es de e-mail.                                         บฑฑ
ฑฑฬออออออออออุอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณAdoro S/A                                                        บฑฑ
ฑฑศออออออออออฯอออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ProcessarEmail(cAssunto,cMensagem,email)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณ Declara็ใo de variแvies.
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	Local aArea			:= GetArea()
	Local lOk           := .T.
	Local cBody         := cMensagem
	Local cErrorMsg     := ""
	Local aFiles        := {}
	Local cServer       := Alltrim(GetMv("MV_RELSERV"))
	Local cAccount      := AllTrim(GetMv("MV_RELACNT"))
	Local cPassword     := AllTrim(GetMv("MV_RELPSW"))
	Local cFrom         := AllTrim(GetMv("MV_RELFROM")) //Por Adriana em 24/05/2019 substituido MV_RELACNT por MV_RELFROM
	Local cTo           := email
	Local lSmtpAuth     := GetMv("MV_RELAUTH",,.F.)
	Local lAutOk        := .F.
	Local cAtach        := ""
	//Local cAtach        := "\LFV\WFLFV.XLS"
	Local cSubject      := ""
	
	//Assunto do e-mail.
	cSubject := cAssunto
	
	//Conecta ao servidor SMTP.
	Connect Smtp Server cServer Account cAccount  Password cPassword Result lOk
	
	If !lAutOk
		If ( lSmtpAuth )
			lAutOk := MailAuth(cAccount,cPassword)
		Else
			lAutOk := .T.
		EndIf
	EndIf
	
	If lOk .And. lAutOk

		// debug - inibir
		//cTo := "fwnmacieira@gmail.com;" + cTo
		
		//Envia o e-mail.
		Send Mail From cFrom To cTo Subject cSubject Body cBody ATTACHMENT cAtach Result lOk
		
		//Tratamento de erro no envio do e-mail.
		If !lOk
			Get Mail Error cErrorMsg
			ConOut("3 - " + cErrorMsg)
			logZBN("Erro envio email " + cErrorMsg) // @history ticket 72339 - Fernando Macieira - 20/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo de logs pois manualmente o email dispara e no schedule nใo
		Else
			ConOut(	"ADLFV011R - Email enviado com sucesso! Emails: " + cMails )
			logZBN("Enviado " + cMails) // @history ticket 72339 - Fernando Macieira - 20/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo de logs pois manualmente o email dispara e no schedule nใo
		EndIf
		
	Else

		Get Mail Error cErrorMsg
		ConOut("4 - " + cErrorMsg)
		logZBN("SMTP falhou" + cErrorMsg) // @history ticket 72339 - Fernando Macieira - 20/05/2022 - workflow - ACOMPANHAMENTO DAS NOTAS FISCAIS DE FRANGO VIVO - inclusใo de logs pois manualmente o email dispara e no schedule nใo
	
	EndIf
	
	If lOk
		Disconnect Smtp Server
	EndIf
	
	RestArea(aArea)

Return Nil
