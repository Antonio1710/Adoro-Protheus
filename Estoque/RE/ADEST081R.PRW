#Include 'Protheus.ch'
#include 'TopConn.CH'

/*/{Protheus.doc} User Function AD01109
	Relatorio de solicitação de armazem por tecnico
	@type  Function
	@author Jonathan Carvalho
	@since 05/10/2022
	@version version
	@history ticket 80057 - Jonathan Carvalho 20/04/2022 - Criação do Relatorio 
/*/
User Function ADEST081R() 

	Local oReport := Nil
	Local cPerg := "ADEST081R" 
	
	Pergunte(cPerg,.T.) //SX1 Perguntas cadastradas
	
	oReport := RptStruc(cPerg)
	oReport:PrintDialog()

Return

Static Function RPTStruc(cNome)

	Local oReport := Nil
	Local oSection1:= Nil
	Local oSection2:= Nil
	
	oReport := TReport():New(cNome,"Relatório de Requisição por Tecnico",cNome,{|oRperot| RPTPRINT(oReport)},"Relatório de Requisição por Tecnico")
	oReport:SetLandscape(.T.)//Definindo a Orientação como Paisagem
	oReport:SetTotalInLine(.F.)
	
	oSection1 := TRSection():New(oReport, "Tecnico",, ,.F.,.T.)
	TRCell():New(oSection1,"TECNICO"		 ,"TEMP","TECNICO"   ,"@!",30)
	
	oSection2 := TRSection():New(oReport, "Requisição",{"SCP"}, NIL,.F.,.T.)
    TRCell():New(oSection2,"REQUISICAO"       ,"TEMP","Requisicao" 	        ,"@!"          ,15)
	TRCell():New(oSection2,"EMISSAO"          ,"TEMP","Emissao" 	        ,"@!"          ,15)
	TRCell():New(oSection2,"COD_PRODUTO"      ,"TEMP","Codigo Produto"      ,"@!"          ,12)
	TRCell():New(oSection2,"DESCRICAO"        ,"TEMP","Descricao"	        ,"@!"          ,30)
	TRCell():New(oSection2,"MEDIDA"           ,"TEMP","Un.Medida"	        ,"@!"          ,8)
	TRCell():New(oSection2,"QUANTIDADE"	      ,"TEMP","Quantidade"    		,"@!"          ,10)
	TRCell():New(oSection2,"VALOR_UNITARIO"	  ,"TEMP","Valor Unitario" 		,"@E 999999.99",10)	
	TRCell():New(oSection2,"VALOR_TOTAL"	  ,"TEMP","Valor Total"    		,"@E 999999.99",15)	
	
	TRFunction():New(oSection2:Cell("VALOR_TOTAL"),,"SUM",,,"@E 999999.99",,.T.,.F.,.T.)
	
	oSection2:SetTotalInLine(.F.)	
	oSection1:SetPageBreak(.T.) //Quebra de seção
	oSection1:SetTotalText(" ")

Return (oReport)

Static Function RPTPrint(oReport)
	Local oSection1 := oReport:Section(1)
	Local oSection2 := oReport:Section(2)
	Local cQuery    := ""
	Local cNumTec   := ""

    cQuery += " SELECT SCP.CP_FILIAL AS FILIAL, " 
    cQuery += " CP_EMISSAO AS EMISSAO, "
	cQuery += " CP_CC AS CENTRO_CUSTO, "
    cQuery += " SCP.CP_NUM AS REQUISICAO, "
	cQuery += " CP_PRODUTO AS COD_PRODUTO, "
	cQuery += " CP_DESCRI AS DESCRICAO, "
	cQuery += " CP_UM AS MEDIDA, "
	cQuery += " CP_QUANT AS QUANTIDADE,  "
	cQuery += " B2_CM1 AS VALOR_UNITARIO,  "
	cQuery += " (CP_QUANT * B2_CM1) AS VALOR_TOTAL ,  "
    cQuery += " CP_OBS AS TECNICO "
	cQuery += " FROM "+RETSQLNAME("SCP")+" SCP (NOLOCK) "
	cQuery += " INNER JOIN "+RETSQLNAME("SB2")+" SB2 (NOLOCK) ON SCP.CP_PRODUTO = SB2.B2_COD AND SCP.CP_FILIAL = B2_FILIAL AND B2_LOCAL = '04' "
	cQuery += " WHERE SCP.CP_FILIAL = '"+Alltrim(MV_PAR05)+"'"
    cQuery += " AND SCP.CP_EMISSAO BETWEEN '"+DToS(MV_PAR01)+"' AND '"+DToS(MV_PAR02)+"' "
    cQuery += " AND SCP.CP_CC = '"+MV_PAR03+"' "
    cQuery += " AND CP_QUANT = CP_QUJE "
    cQuery += " AND	SCP.D_E_L_E_T_= '' "

    If !Empty(Alltrim(MV_PAR04))

        cQuery += " AND SCP.CP_OBS = '"+Alltrim(MV_PAR04)+"'"

    EndIf

    cQuery += " ORDER BY TECNICO, EMISSAO "
	
	//Verifica se a tabela ja está aberta criação da tabela temporaria.
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
			Exit //caso usuario solicitar o cancelamento da impressão vai parar o processo
		EndIf
		//Iniciando a primeira seção
		oSection1:Init()
		oReport:IncMeter()
		
		cNumTec := Alltrim(TEMP->TECNICO)
		IncProc("Imprimindo Requisições do "+ Alltrim(TEMP->TECNICO))
			
		//Imprimindo primeira seção:
		oSection1:Cell("TECNICO"):SetValue(Alltrim(TEMP->TECNICO))
		oSection1:Printline()		
		
		//Iniciar a impressão da seção 2
		oSection2:Init()
		
		//verifica se o campo de observação e igual, se sim, imprime os dados da requisição
		While Alltrim(TEMP->TECNICO) == cNumTec

			oReport:IncMeter()
			
			IncProc("Imprimindo Solicitações..."+ Alltrim(TEMP->REQUISICAO))
            oSection2:Cell("REQUISICAO"):SetValue(TEMP->REQUISICAO)
			oSection2:Cell("EMISSAO"):SetValue(TEMP->EMISSAO)
			oSection2:Cell("COD_PRODUTO"):SetValue(TEMP->COD_PRODUTO)
			oSection2:Cell("DESCRICAO"):SetValue(TEMP->DESCRICAO)
			oSection2:Cell("MEDIDA"):SetValue(TEMP->MEDIDA)			
			oSection2:Cell("QUANTIDADE"):SetValue(TEMP->QUANTIDADE)		
			oSection2:Cell("VALOR_UNITARIO"):SetValue(TEMP->VALOR_UNITARIO)
			oSection2:Cell("VALOR_TOTAL"):SetValue(TEMP->VALOR_TOTAL)	
			oSection2:Printline()
		
			TEMP->(dbSkip())
			
		EndDo
		//Finalizo a segunda seção para que seja reiniciada para proximo registro
		oSection2:Finish()		
		//Imprimo uma linha para separar uma NCM da outra
		oReport:ThinLine()		
		//Finalizo a primeira seção
		oSection1:Finish()	
			
	EndDo
			
Return


