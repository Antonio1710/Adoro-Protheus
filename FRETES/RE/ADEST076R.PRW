#Include 'Protheus.ch'
#include 'TopConn.CH'

/*/{Protheus.doc} User Function AD01109
	Relatorio de Abastecimento por Transportadora
	@type  Function
	@author Jonathan Carvalho
	@since 20/04/2022 
	@version version
	@history ticket 66832 - Jonathan Carvalho 20/04/2022 - Cria��o do Relatorio 
	@history ticket 66832 - Jonathan Carvalho 22/04/2022 - Corre��o na coluna Hora Fim 
/*/
User Function ADEST076R() 

	Local oReport := Nil
	Local cPerg := "ADEST076R" 
	
	Pergunte(cPerg,.T.) //SX1 Perguntas cadastradas
	
	oReport := RptStruc(cPerg)
	oReport:PrintDialog()

Return

Static Function RPTStruc(cNome)

	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	
	oReport := TReport():New(cNome,"Relat�rio de Abastecimento por Transportadadora",cNome,{|oRperot| RPTPRINT(oReport)},"Relat�rio de Abastecimento por Transportadadora")
	oReport:SetLandscape(.T.)//Definindo a Orienta��o como Paisagem
	oReport:SetTotalInLine(.F.)
	
	oSection1 := TRSection():New(oReport, "Transportadora",{"SA2"}, ,.F.,.T.)
	TRCell():New(oSection1,"CODTRANS"		 ,"TEMP","CODIGO"    ,"@!",30)
	TRCell():New(oSection1,"TRANSPORTADORA"  ,"TEMP","NOME"	     ,"@!",40)
	TRCell():New(oSection1,"S10"             ,"TEMP","VALOR S10" ,"@!",20)
	TRCell():New(oSection1,"S500"            ,"TEMP","VALOR S500","@!",20)
	
	oSection2 := TRSection():New(oReport, "Abastecimentos",{"ZBB"}, NIL,.F.,.T.)
	TRCell():New(oSection2,"DATA_INICIO"      ,"TEMP","Data Inicio"	        ,"@!"          ,10)
	TRCell():New(oSection2,"HORA_INICIO"      ,"TEMP","Hora Inicio"	        ,"@!"          ,8)
	TRCell():New(oSection2,"DATA_FIM"         ,"TEMP","Data Fim"	        ,"@!"          ,10)
	TRCell():New(oSection2,"HORA_FIM"         ,"TEMP","Hora Fim"	        ,"@!"          ,8)
	TRCell():New(oSection2,"PLACA"	          ,"TEMP","Placa"	    		,"@!"          ,10)
	TRCell():New(oSection2,"VOLUME"	          ,"TEMP","Quantidade"  		,"@E 999999.99",10)	
	TRCell():New(oSection2,"VALOR"	          ,"TEMP","Pre�o"	    		,"@E 999999.99",15)	
	TRCell():New(oSection2,"BOMBA"	          ,"TEMP","Bomba"	    		,"@!"          ,30)	

	TRFunction():New(oSection2:Cell("VOLUME"),,"SUM",,,"@E 999999.99",,.T.,.F.,.T.)
	TRFunction():New(oSection2:Cell("VALOR"),, "SUM",,,"@E 999999.99",,.T.,.F.,.T.) 

	oSection2:SetTotalInLine(.F.)	
	oSection1:SetPageBreak(.T.) //Quebra de se��o
	oSection1:SetTotalText(" ")

Return (oReport)

Static Function RPTPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local cNumCod   := ""
	
	cQuery += " SELECT CONVERT(VARCHAR(30), CONVERT(DATETIME,ZBB_DTINI), 103) AS DATA_INICIO, " 
	cQuery += " ZBB_HRINI AS HORA_INICIO, "
	cQuery += " CONVERT(VARCHAR(30), CONVERT(DATETIME, ZBB_DTFIM), 103) AS DATA_FIM, "
	cQuery += " ZBB_HRFIM AS HORA_FIM, "
	cQuery += " ZBB_PLACA PLACA, "
	cQuery += " SA2.A2_COD CODTRANS,  "
	cQuery += " SA2.A2_NOME TRANSPORTADORA,  "
	cQuery += " ZBB_VOLUME VOLUME,  "
	cQuery += " CASE WHEN ZBB_BOMBA = 'S10' THEN ROUND((ZBB_VOLUME * '"+cValToChar(MV_PAR05)+"'),2) ELSE ROUND((ZBB_VOLUME * '"+cValToChar(MV_PAR06)+"'),2) END AS VALOR, "
	cQuery += " ZBB_BOMBA BOMBA,  "
	cQuery += " '  R$ '+'"+cValToChar(MV_PAR05)+"' AS S10,  "
	cQuery += " '  R$ '+'"+cValToChar(MV_PAR06)+"' AS S500  "
	cQuery += " FROM "+RETSQLNAME("ZBB")+" ZBB (NOLOCK) "
	cQuery += " INNER JOIN "+RETSQLNAME("DA3")+" DA3 (NOLOCK) ON ZBB.ZBB_PLACA = DA3.DA3_COD "
	cQuery += " INNER JOIN "+RETSQLNAME("SA2")+" SA2 (NOLOCK) ON SA2.A2_COD = DA3.DA3_XTRANS "
	cQuery += " WHERE (ZBB.ZBB_DTINI BETWEEN '"+Dtos(MV_PAR01)+"' AND '"+Dtos(MV_PAR02)+"')  "
	cQuery += " AND (SA2.A2_COD BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') "
	cQuery += " AND	ZBB.ZBB_APRMOV <> 'N' AND ZBB.D_E_L_E_T_= '' "
	cQuery += " ORDER BY PLACA, DATA_INICIO "
	
	//Verifica se a tabela ja est� aberta cria��o da tabela temporaria.
	If Select("TEMP") <> 0
		DbSelectArea("TEMP")
		DbCloseArea()
	EndIf
			
	TCQUERY cQuery NEW ALIAS "TEMP"
			
	DbSelectArea("TEMP")
	TEMP->(dbGoTop())

	oReport:SetMeter(TEMP->(LASTREC()))
			
	While !EOF()
		If oReport:Cancel()
			Exit //caso usuario solicitar o cancelamento da impress�o vai parar o processo
		EndIf
		//Iniciando a primeira se��o
		oSection1:Init()
		oReport:IncMeter()
		
		cNumCod := TEMP->PLACA
		IncProc("Imprimindo Transportadora "+ Alltrim(TEMP->CODTRANS))
			
		//Imprimindo primeira se��o:
		oSection1:Cell("CODTRANS"):SetValue(TEMP->CODTRANS)
		oSection1:Cell("TRANSPORTADORA"):SetValue(TEMP->TRANSPORTADORA)	
		oSection1:Printline()		
		
		//Iniciar a impress�o da se��o 2
		oSection2:Init()
		
		//verifica se o codigo do cliente � o mesmo, se sim, imprime os dados do pedido
		While TEMP->PLACA == cNumCod

			oReport:IncMeter()
			
			IncProc("Imprimindo Abastecimentos..."+ Alltrim(TEMP->PLACA))
			oSection2:Cell("DATA_INICIO"):SetValue(TEMP->DATA_INICIO)
			oSection2:Cell("HORA_INICIO"):SetValue(TEMP->HORA_INICIO)
			oSection2:Cell("DATA_FIM"):SetValue(TEMP->DATA_FIM)
			oSection2:Cell("HORA_FIM"):SetValue(TEMP->HORA_FIM)			
			oSection2:Cell("PLACA"):SetValue(TEMP->PLACA)		
			oSection2:Cell("VOLUME"):SetValue(TEMP->VOLUME)
			oSection2:Cell("VALOR"):SetValue(TEMP->VALOR)	
			oSection2:Cell("BOMBA"):SetValue(TEMP->BOMBA)
			oSection2:Printline()
		
			TEMP->(dbSkip())
			
		EndDo
		//Finalizo a segunda se��o para que seja reiniciada para proximo registro
		oSection2:Finish()		
		//Imprimo uma linha para separar uma NCM da outra
		oReport:ThinLine()		
		//Finalizo a primeira se��o
		oSection1:Finish()	
			
	EndDo
			
Return


