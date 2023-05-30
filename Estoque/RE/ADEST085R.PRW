#Include "Protheus.ch"
#include "TopConn.CH"

/*/{Protheus.doc} User Function ADEST085R
	ticket 18465 - Relatorio de pesagem de ração. 
	@type  Function
	@author Everson
	@since 08/03/2023
	@version 01
	@history Everson, 14/03/2023, ticket 18465 - Alterada a ordenação da query.
/*/
User Function ADEST085R() // U_ADEST085R()

    //Variáveis.
    Local aArea := GetArea()
	Local oReport := Nil
	Local cPerg := "ADEST085R" 
	
	If ! Pergunte(cPerg,.T.)
        RestArea(aArea)
        Return Nil

    EndIf
	
	oReport := RptStruc(cPerg)
	oReport:PrintDialog()

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} RPTStruc
    Gera estrutura do relatório.
    @type  Static Function
    @author Everson
    @since 08/03/2023
    @version 01
/*/
Static Function RPTStruc(cPerg)

    //Variáveis.
    Local cNome     := "ADEST085R"
    Local cTitulo   := "Listagem das Entradas de Matéria-Prima"
	Local oReport   := Nil
	Local oSection1 := Nil
	Local oBreak1	:= Nil
	
	oReport := TReport():New(cNome,cTitulo, cPerg,{|oReport| RPTPRINT(oReport)},cTitulo)
	oReport:SetLandscape(.T.)
	oReport:DisableOrientation(.T.)
	
	oSection1 := TRSection():New(oReport, "Pedidos",{"SC5"}, ,.F.,.T.)

	TRCell():New(oSection1,"DRRECEB" ,"D_LISTA","Recebimento"   ,"@!",10)
	TRCell():New(oSection1,"ORDEMPE" ,"D_LISTA","Guia" 			,"@!",10)
	TRCell():New(oSection1,"PRODUTO" ,"D_LISTA","Produto"		,"@!",30)
	TRCell():New(oSection1,"PEDCOM"  ,"D_LISTA","Pedido" 		,"@!",07)
	TRCell():New(oSection1,"NF"      ,"D_LISTA","N. Fiscal"   	,"@!",10)
	TRCell():New(oSection1,"SERIE"   ,"D_LISTA","Série"   		,"@!",05)
	TRCell():New(oSection1,"PLACA"   ,"D_LISTA","Placa"     	,"@!",07)
	TRCell():New(oSection1,"FORNECE" ,"D_LISTA","Pessoa" 		,"@!",35)
	TRCell():New(oSection1,"LOTE"    ,"D_LISTA","Lote" 			,"@!",08)
	TRCell():New(oSection1,"QTDNF"   ,"D_LISTA","QT. N. Fiscal"	,"@E 999,999,999.999",15,,,"RIGHT")
	TRCell():New(oSection1,"QTDBAL"  ,"D_LISTA","QT. Bal."	  	,"@E 999,999,999.999",15,,,"RIGHT")
	// TRCell():New(oSection1,"PRCUNT"  ,"D_LISTA","Unitário"	 	,,,,,"RIGHT")	
	// TRCell():New(oSection1,"VLRNF"   ,"D_LISTA","Valor NF"		,,,,,"RIGHT")
	// TRCell():New(oSection1,"VLRUNT"  ,"D_LISTA","Pu. (N.F.)"   	,,,,,"RIGHT")
	TRCell():New(oSection1,"UF"	     ,"D_LISTA","UF" 			,"@!",04)
	TRCell():New(oSection1,"OBS"     ,"D_LISTA","Obs" 			,"@!",15)

	oBreak1 := TRBreak():New(oReport, oSection1:Cell("PRODUTO"), "Totais",.F.)
	
	TRFunction():New(oSection1:Cell("QTDNF") ,Nil,"SUM",oBreak1,"","@E 999,999,999.999",/*uFormula*/,.F.,.F.)
	TRFunction():New(oSection1:Cell("QTDBAL"),Nil,"SUM",oBreak1,"","@E 999,999,999.999",/*uFormula*/,.F.,.F.)

	TRFunction():New(oSection1:Cell("QTDNF"),"Total Geral" ,"SUM" ,,,"@E 999,999,999,999,999.999",,.F.,.T.)
	TRFunction():New(oSection1:Cell("QTDBAL"),"Total Geral" ,"SUM",,,"@E 999,999,999,999,999.999",,.F.,.T.)

Return (oReport)
/*/{Protheus.doc} RPTPrint
    Gera relatório.
    @type  Static Function
    @author Everson
    @since 08/03/2023
    @version 01
/*/
Static Function RPTPrint(oReport)

    //Variáveis.
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cProd		:= ""

	cQuery := ""
	cQuery += " SELECT   " 
		cQuery += " ZIN_DTRECE,  " 
		cQuery += " ZIF_STATUS,  " 
		cQuery += " ZIF_NUMERO,  " 
		cQuery += " ZIF_PEDCOM,  " 
		cQuery += " ZIF_FORNEC,  " 
		cQuery += " ZIF_LJFORN,  " 
		cQuery += " ZIF_NMFOR,   " 
		cQuery += " ZIF_LOTE,    " 
		cQuery += " ZIF_QUANT,   " 
		cQuery += " ZIG_NUMERO,  " 
		cQuery += " ZIG_DTPES1,  " 
		cQuery += " ZIG_HRPES1,  " 
		cQuery += " ZIG_DTPES2,  " 
		cQuery += " ZIG_HRPES2,  " 
		cQuery += " ZIF_PLACA,   " 
		cQuery += " B1_DESC,     " 
		cQuery += " ZIG_PESOLI,  " 
		cQuery += " ZIF_PRDPRO,  " 
		cQuery += " ZIF_NF, 	 "
		cQuery += " ZIF_SERIE 	 " 

	cQuery += " FROM   " 
	
		cQuery += " " + RetSqlName("ZIF") + " (NOLOCK) AS ZIF   " 
		cQuery += " LEFT JOIN " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG  ON  " 
		cQuery += " ZIF_FILIAL = ZIG_FILIAL  " 
		cQuery += " AND ZIF_NUMERO = ZIG_ORDEM   " 
		cQuery += " AND ZIG.D_E_L_E_T_ = ''    " 

		cQuery += " INNER JOIN " + RetSqlName("ZIN") + " (NOLOCK) AS ZIN  ON  " 
		cQuery += " ZIF_FILIAL = ZIN_FILIAL  " 
		cQuery += " AND ZIF_NUMERO = ZIN_ORDPES "
		cQuery += " AND ZIN.D_E_L_E_T_ = ''    " 

		cQuery += " LEFT JOIN " + RetSqlName("SB1") + " (NOLOCK) AS SB1  ON  " 
		cQuery += " B1_COD = ZIF_PRDPRO   " 
		cQuery += " AND SB1.D_E_L_E_T_ = ''    "

	cQuery += " WHERE   " 
		cQuery += " ZIF_FILIAL = '" + FWxFilial("ZIF") + "' " 
		cQuery += " AND ZIN_DTRECE BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' " 
		cQuery += " AND ZIF_PLACA  BETWEEN '" + cValToChar(MV_PAR03) + "' AND '" + cValToChar(MV_PAR04) + "' " 
		cQuery += " AND ZIF_TPMOVI = 'E'   " 
		cQuery += " AND ZIF.D_E_L_E_T_ = ''   " 

	cQuery += " ORDER BY  " 
		cQuery += " ZIF_PRDPRO, ZIN_DTRECE, ZIF_NUMERO "  //Everson, 14/03/2023, ticket 18465.
		
	If Select("D_LISTA") > 0
		D_LISTA->(DbCloseArea())

	EndIf
			
	TcQuery cQuery New Alias "D_LISTA"
    
	TCSetField("D_LISTA", "ZIN_DTRECE", "D")
    TCSetField("D_LISTA", "ZIG_DTPES1", "D")
    TCSetField("D_LISTA", "ZIG_DTPES2", "D")
			
	DbSelectArea("D_LISTA")
	D_LISTA->(DbGoTop())

	oReport:SetMeter(Contar("D_LISTA","!Eof()"))

    D_LISTA->(DbGoTop())

    oSection1:Init()
			
	While ! D_LISTA->(Eof())
        
		If oReport:Cancel()
			Exit

		EndIf

		oReport:IncMeter()

		If Val(cValToChar(D_LISTA->ZIG_PESOLI)) <= 0 .And. Alltrim(cValToChar(D_LISTA->ZIF_STATUS)) <> "7"
			D_LISTA->(DbSkip())	
			Loop

		EndIf

		cProd := Alltrim(cValToChar(Posicione("SB1", 1, FWxFilial("SB1") + D_LISTA->ZIF_PRDPRO, "B1_DESC")))
		cUF	  := Alltrim(cValToChar(Posicione("SA2", 1, FWxFilial("SA2") + D_LISTA->ZIF_FORNEC + D_LISTA->ZIF_LJFORN, "A2_EST")))	

		oSection1:Cell("DRRECEB"):SetValue(DToC(D_LISTA->ZIN_DTRECE))	
		oSection1:Cell("ORDEMPE"):SetValue(D_LISTA->ZIF_NUMERO)	
		oSection1:Cell("PRODUTO"):SetValue(Substr(Alltrim(cValToChar(D_LISTA->ZIF_PRDPRO)) + " " + cProd, 1, 30))	
		oSection1:Cell("PEDCOM"):SetValue(D_LISTA->ZIF_PEDCOM)	
		oSection1:Cell("NF"):SetValue(D_LISTA->ZIF_NF)	
		oSection1:Cell("SERIE"):SetValue(D_LISTA->ZIF_SERIE)	
		oSection1:Cell("PLACA"):SetValue(D_LISTA->ZIF_PLACA)	
		oSection1:Cell("FORNECE"):SetValue(Substr(D_LISTA->ZIF_FORNEC + " " + D_LISTA->ZIF_LJFORN + " " + Alltrim(cValToChar(D_LISTA->ZIF_NMFOR)), 1, 35))	
		oSection1:Cell("LOTE"):SetValue(D_LISTA->ZIF_LOTE)	
		oSection1:Cell("QTDNF"):SetValue(D_LISTA->ZIF_QUANT)	
		oSection1:Cell("QTDBAL"):SetValue(Val(cValToChar(D_LISTA->ZIG_PESOLI)))	
		// oSection1:Cell("PRCUNT"):SetValue(D_LISTA->ZIF_NUMERO)	
		// oSection1:Cell("VLRNF"):SetValue(D_LISTA->ZIF_NUMERO)	
		// oSection1:Cell("VLRUNT"):SetValue(D_LISTA->ZIF_NUMERO)	
		oSection1:Cell("UF"):SetValue(cUF)	

		If Alltrim(cValToChar(D_LISTA->ZIF_STATUS)) == "7"
			oSection1:Cell("OBS"):SetValue("Transferência")	

		Else
			oSection1:Cell("OBS"):SetValue("")	
			
		EndIf

		oSection1:Printline()	

        D_LISTA->(DbSkip())	
			
	End

    oSection1:Finish()	
			
Return Nil
