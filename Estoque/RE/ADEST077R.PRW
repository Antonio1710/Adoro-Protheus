#Include "Protheus.ch"
#include "TopConn.CH"

/*/{Protheus.doc} User Function ADEST077R
	Relatorio de pesagem de ração.
	@type  Function
	@author Everson
	@since 31/05/2022
	@version version
	@history, Everson, 09/06/2022, ticket 18465 - Adicionado filtro por placa.
	@history, Everson, 28/06/2022, ticket 75316 - Adicionado filtro por data da pesagem final e totalizador de peso líquido.
	@history, Jonathan 29/07/2022, tikcet 76074 - Adicionado pergunta para filtro e consulta de SubProduto
	@history, Everson, 31/08/2022, ticket 77584 - Adicionada informação de nota fiscal de devolução.
	@history, Everson, 06/03/2023, ticket 18465 - Adicionada pesagem de entrada.
/*/
User Function ADEST077R() // U_ADEST077R()

    //Variáveis.
    Local aArea := GetArea()
	Local oReport := Nil
	Local cPerg := "ADEST077R" 
	
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
    @since 31/05/2022
    @version 01
/*/
Static Function RPTStruc(cPerg)

    //Variáveis.
    Local cNome     := "ADEST077R"
    Local cTitulo   := "Lista de Pesagem"
	Local oReport   := Nil
	Local oSection1 := Nil
	
	oReport := TReport():New(cNome,cTitulo, cPerg,{|oReport| RPTPRINT(oReport)},cTitulo)
	oReport:SetLandscape(.T.)
	
	oSection1 := TRSection():New(oReport, "Pedidos",{"SC5"}, ,.F.,.T.)

	If MV_PAR05 = 1 //Listagem de pesagem Ração Jonathan 29/07/2022, tikcet 76074
		TRCell():New(oSection1,"ROTEIRO" ,"D_LISTA","Roteiro"   ,"@!",15)
		TRCell():New(oSection1,"ORDERAC" ,"D_LISTA","Ord Ração" ,"@!",15)
		TRCell():New(oSection1,"GRANJA"  ,"D_LISTA","Granja" 	,"@!",15)
		TRCell():New(oSection1,"LOTE"    ,"D_LISTA","Lote"   	,"@!",15)

	EndIf

	TRCell():New(oSection1,"ORDEPES" ,"D_LISTA","Ord Pes."   ,"@!",15)
	TRCell():New(oSection1,"TICKET"  ,"D_LISTA","Ticket"     ,"@!",10)
	TRCell():New(oSection1,"DATAINI" ,"D_LISTA","Dt Pes. inicial" ,"@!",10)
	TRCell():New(oSection1,"HORAINI" ,"D_LISTA","Hr Pes. inicial" ,"@!",08)
	TRCell():New(oSection1,"DATAFIM" ,"D_LISTA","Dt Pes. final"	  ,"@!",10)
	TRCell():New(oSection1,"HORAFIM" ,"D_LISTA","Hr Pes. final"	  ,"@!",08)
	TRCell():New(oSection1,"PLACA"   ,"D_LISTA","Placa"	 ,"@!",10)	
	TRCell():New(oSection1,"PRODUTO" ,"D_LISTA","Produto","@!",15)	
	TRCell():New(oSection1,"PESO"    ,"D_LISTA","Peso"   ,"@!",15,,,"RIGHT")

	If MV_PAR05 = 1 .Or. MV_PAR05 = 2
		TRCell():New(oSection1,"PEDV","D_LISTA","Pedido" ,"@!",06)

	EndIf

	TRCell():New(oSection1,"NF"  	,"D_LISTA","NF"   	 ,"@!",15)

	If MV_PAR05 = 1 .Or. MV_PAR05 = 2
		TRCell():New(oSection1,"NFDEV"  ,"D_LISTA","NF Dev" ,"@!",15)

	EndIf

	TRFunction():New(oSection1:Cell("PESO"),"Total Geral" ,"SUM",,,"@E 999,999,999,999,999.999",,.F.,.T.)

Return (oReport)
/*/{Protheus.doc} RPTPrint
    Gera relatório.
    @type  Static Function
    @author Everson
    @since 31/05/2022
    @version 01
/*/
Static Function RPTPrint(oReport)

    //Variáveis.
	Local oSection1 := oReport:Section(1)
	Local cQuery    := ""
	Local cNFDev	:= ""

	If MV_PAR05 = 1 //Ração Jonathan 29/07/2022, tikcet 76074

		cQuery := ""
		cQuery += " SELECT " 
		
			cQuery += " ZIF_ROTEIR, " 
			cQuery += " ZIR_NUMERO, " 
			cQuery += " ZIF_NUMERO, " 
			cQuery += " ZIG_NUMERO, ZIG_DTPES1, ZIG_HRPES1, " 
			cQuery += " ZIG_DTPES2, ZIG_HRPES2, " 
			cQuery += " ZIG_PLACA, " 
			cQuery += " ZIR_DESGRJ, " 
			cQuery += " ZIR_DESC, " 
			cQuery += " ZIR_DESLOT, " 
			cQuery += " ZIG_PESOLI, C5_NUM, C5_NOTA+C5_SERIE AS NF, ZIF_PRDPRO " 
		cQuery += " FROM " 
			cQuery += " " + RetSqlName("ZIF") + " (NOLOCK) AS ZIF " 
			cQuery += " INNER JOIN " 
			cQuery += " " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG ON " 
			cQuery += " ZIF_FILIAL = ZIG_FILIAL " 
			cQuery += " AND ZIF_NUMERO = ZIG_ORDEM " 
			cQuery += " INNER JOIN " 
			cQuery += " " + RetSqlName("ZIR") + " (NOLOCK) AS ZIR ON  " 
			cQuery += " ZIF_FILIAL = ZIR_FILIAL " 
			cQuery += " AND ZIF_NUMERO = ZIR_ORDEM " 

			cQuery += " LEFT OUTER JOIN "
			cQuery += " " + RetSqlName("SC5") + " (NOLOCK) AS SC5 ON "
			cQuery += " ZIF_FILIAL = C5_FILIAL "
			cQuery += " AND ZIF_NUMERO = C5_XORDPES "

			cQuery += " LEFT OUTER JOIN "
			cQuery += " " + RetSqlName("ZHR") + " (NOLOCK) AS ZHR ON "
			cQuery += " C5_FILIAL = ZHR_FILIAL "
			cQuery += " AND C5_NUM = ZHR_NVPED "
			cQuery += " AND ZHR.D_E_L_E_T_ = '' " 

		cQuery += " WHERE " 
			cQuery += " ZIF_FILIAL = '" + FWxFilial("ZIF") + "' " 
			//cQuery += " AND ZIG_DTPES1 >= '" + DToS(MV_PAR01) + "' " 
			cQuery += " AND ZIG_DTPES2 >= '" + DToS(MV_PAR01) + "' "  //Everson, 28
			cQuery += " AND ZIG_DTPES2 <= '" + DToS(MV_PAR02) + "' "  
			cQuery += " AND ZIG_PLACA >= '" + cValToChar(MV_PAR03) + "' "  //Everson, 09/06/20222, ticket 18465 - Adicionado filtro por placa.
			cQuery += " AND ZIG_PLACA <= '" + cValToChar(MV_PAR04) + "' "  //Everson, 09/06/20222, ticket 18465 - Adicionado filtro por placa.
			cQuery += " AND ZIG_DTPES2 <> ''  "  
			
			cQuery += " AND C5_PEDSAG = '' "

			cQuery += " AND ZHR_NVPED IS NULL "
			
			cQuery += " AND ZIF.D_E_L_E_T_ = '' " 
			cQuery += " AND ZIG.D_E_L_E_T_ = '' " 
			cQuery += " AND SC5.D_E_L_E_T_ = '' " 

		cQuery += " ORDER BY ZIF_ROTEIR, ZIR_NUMERO, ZIF_NUMERO, ZIG_NUMERO " 

	ElseIf MV_PAR05 = 2 //SubProduto Jonathan 29/07/2022, tikcet 76074

		cQuery := ""
		cQuery += " SELECT " 
        cQuery += " ZIF_NUMERO, " 
        cQuery += " ZIG_NUMERO, " 
        cQuery += " ZIG_DTPES1, " 
        cQuery += " ZIG_HRPES1, " 
        cQuery += " ZIG_DTPES2, ZIG_HRPES2, " 
        cQuery += " ZIG_PLACA, " 
        cQuery += " B1_DESC, " 
        cQuery += " ZIG_PESOLI, " 
        cQuery += " C5_NUM, " 
        cQuery += " C5_NOTA+C5_SERIE AS NF, ZIF_PRDPRO " 
        
        cQuery += " FROM  " + RetSqlName("ZIF") + " (NOLOCK) AS ZIF " 
        cQuery += " INNER JOIN " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG " 
        cQuery += " ON ZIF_FILIAL = ZIG_FILIAL AND ZIF_NUMERO = ZIG_ORDEM " 
		cQuery += " LEFT JOIN " + RetSqlName("SC6") + " (NOLOCK) AS SC6 "
		cQuery += " ON ZIF_FILIAL = C6_FILIAL AND ZIF_NUMERO = C6_XORDPES "
        cQuery += " LEFT JOIN " + RetSqlName("SC5") + " (NOLOCK) AS SC5 "
		cQuery += " ON ZIF_FILIAL = C5_FILIAL AND C6_NUM = C5_NUM "
        cQuery += " LEFT JOIN " + RetSqlName("SB1") + " (NOLOCK) AS SB1 "
		cQuery += " ON B1_COD = ZIF_PRDPRO "

    	cQuery += " WHERE " 
        cQuery += " ZIF_FILIAL = '" + FWxFilial("ZIF") + "' " 
        cQuery += " AND ZIG_DTPES2 BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' "  
        cQuery += " AND ZIG_PLACA BETWEEN '" + cValToChar(MV_PAR03) + "' AND '" + cValToChar(MV_PAR04) + "' "  
        cQuery += " AND ZIG_DTPES2 <> ''  "  
		
		//cQuery += " AND C5_NOTA <> '' "

		cQuery += " AND ZIF.D_E_L_E_T_ = '' " 
        cQuery += " AND ZIG.D_E_L_E_T_ = '' " 
        cQuery += " AND SC5.D_E_L_E_T_ = '' " 
        cQuery += " AND ZIF_TPMOVI <> 'R' "

    	cQuery += " ORDER BY ZIF_ROTEIR " 

	ElseIf MV_PAR05 = 3 //Entradas - Everson - ticket 18465 - 06/03/2023.

		cQuery := ""
		cQuery += " SELECT   " 
			cQuery += " ZIF_ROTEIR,   " 
			cQuery += " ZIF_NUMERO,   " 
			cQuery += " ZIG_NUMERO,   " 
			cQuery += " ZIG_DTPES1,   " 
			cQuery += " ZIG_HRPES1,   " 
			cQuery += " ZIG_DTPES2,  " 
			cQuery += " ZIG_HRPES2,   " 
			cQuery += " ZIG_PLACA,   " 
			cQuery += " B1_DESC,   " 
			cQuery += " ZIG_PESOLI,   " 
			cQuery += " ZIF_PRDPRO,   " 
			cQuery += " ZIF_NF+ZIF_SERIE AS NF   " 
		cQuery += " FROM   " 
			cQuery += " " + RetSqlName("ZIF") + " (NOLOCK) AS ZIF   " 
			cQuery += " INNER JOIN " + RetSqlName("ZIG") + " (NOLOCK) AS ZIG  ON  " 
			cQuery += " ZIF_FILIAL = ZIG_FILIAL  " 
			cQuery += " AND ZIF_NUMERO = ZIG_ORDEM   " 
			cQuery += " LEFT JOIN " + RetSqlName("SB1") + " (NOLOCK) AS SB1  ON  " 
			cQuery += " B1_COD = ZIF_PRDPRO   " 
		cQuery += " WHERE   " 
			cQuery += " ZIF_FILIAL = '" + FWxFilial("ZIF") + "' " 
			cQuery += " AND ZIG_DTPES2 BETWEEN '" + DToS(MV_PAR01) + "' AND '" + DToS(MV_PAR02) + "' " 
			cQuery += " AND ZIG_PLACA BETWEEN '" + cValToChar(MV_PAR03) + "' AND '" + cValToChar(MV_PAR04) + "' " 
			cQuery += " AND ZIG_DTPES2 <> ''    " 
			cQuery += " AND ZIF.D_E_L_E_T_ = ''   " 
			cQuery += " AND ZIG.D_E_L_E_T_ = ''    " 
			cQuery += " AND ZIF_TPMOVI = 'E'   " 
		cQuery += " ORDER BY  " 
			cQuery += " ZIF_ROTEIR " 

	EndIf
		
	If Select("D_LISTA") > 0
		D_LISTA->(DbCloseArea())

	EndIf
			
	TcQuery cQuery New Alias "D_LISTA"
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

		oSection1:Cell("ORDEPES"):SetValue(D_LISTA->ZIF_NUMERO)	
		oSection1:Cell("TICKET"):SetValue(D_LISTA->ZIG_NUMERO)	
		oSection1:Cell("DATAINI"):SetValue(DToC(D_LISTA->ZIG_DTPES1))	
		oSection1:Cell("HORAINI"):SetValue(D_LISTA->ZIG_HRPES1)	
		oSection1:Cell("DATAFIM"):SetValue(DToC(D_LISTA->ZIG_DTPES2))	
		oSection1:Cell("HORAFIM"):SetValue(D_LISTA->ZIG_HRPES2)	
		oSection1:Cell("PLACA"):SetValue(D_LISTA->ZIG_PLACA)	
		oSection1:Cell("PESO"):SetValue(Transform(D_LISTA->ZIG_PESOLI, "@E 999,999,999.999"))
		oSection1:Cell("NF"):SetValue(D_LISTA->NF)	
		
		If MV_PAR05 = 1 //Ração Jonathan 29/07/2022, tikcet 76074
			oSection1:Cell("ROTEIRO"):SetValue(D_LISTA->ZIF_ROTEIR)
			oSection1:Cell("ORDERAC"):SetValue(D_LISTA->ZIR_NUMERO)	
			oSection1:Cell("GRANJA"):SetValue(D_LISTA->ZIR_DESGRJ)	
			oSection1:Cell("PRODUTO"):SetValue(D_LISTA->ZIR_DESC)
			oSection1:Cell("LOTE"):SetValue(D_LISTA->ZIR_DESLOT)	
		
		EndIf
		
		If MV_PAR05 = 2 .Or. MV_PAR05 = 3 // SubProduto Jonathan 29/07/2022, tikcet 76074
			oSection1:Cell("PRODUTO"):SetValue(D_LISTA->B1_DESC)

		EndIf

		If MV_PAR05 = 1 .Or. MV_PAR05 = 2
			oSection1:Cell("PEDV"):SetValue(D_LISTA->C5_NUM)	
			//Everson - 31/08/2022. Ticket 77584.
			cNFDev := obtNFDev(D_LISTA->NF, D_LISTA->ZIF_PRDPRO)
			oSection1:Cell("NFDEV"):SetValue(cNFDev)
			//

		EndIf

		oSection1:Printline()	

        D_LISTA->(DbSkip())	
			
	End

    oSection1:Finish()	
			
Return Nil
/*/{Protheus.doc} obtNFDev
	Retorna o número/séria da nota fiscal de devolução.
	Ticket 77584.
	@type  Static Function
	@author Everson
	@since 31/08/2022
	@version 01
/*/
Static Function obtNFDev(cNFSer, cProduto)

	//Variáveis.
	Local aArea  	:= GetArea()
	Local cNF	 	:= ""
	Local cQuery 	:= ""
	Local cNewAlias	:= GetNextAlias()

	Default lSaida	:= .T.

	cQuery := ""
	cQuery += " SELECT  " 
		cQuery += " TOP 1 D1_DOC+D1_SERIE AS NF " 
	cQuery += " FROM " 
		cQuery += " " + RetSqlName("SD2") + " (NOLOCK) AS SD2 " 
		cQuery += " INNER JOIN " 
		cQuery += " " + RetSqlName("SD1") + " (NOLOCK) AS SD1 ON " 
		cQuery += " D2_FILIAL = D1_FILIAL " 
		cQuery += " AND D2_DOC = D1_NFORI " 
		cQuery += " AND D2_SERIE = D1_SERIORI " 
		cQuery += " AND D2_ITEM = D1_ITEMORI " 
		cQuery += " AND D2_CLIENTE = D1_FORNECE " 
		cQuery += " AND D2_LOJA = D1_LOJA " 
		cQuery += " AND SD1.D_E_L_E_T_ = '' " 
	cQuery += " WHERE  " 
		cQuery += " D2_FILIAL ='" + FWxFilial("SD2") + "' " 
		cQuery += " AND D2_DOC+D2_SERIE = '" + cNFSer + "' " 
		cQuery += " AND D2_COD = '" + cProduto + "' " 
		cQuery += " AND SD2.D_E_L_E_T_ = '' " 

	DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cNewAlias, .F., .T.)

	(cNewAlias)->(DbGoTop())

		cNF := Alltrim(CValToChar((cNewAlias)->NF))

	(cNewAlias)->(DbCloseArea())

	RestArea(aArea)

Return cNF
