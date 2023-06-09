#Include "Totvs.ch"
#Include "Topconn.ch"
/*/{Protheus.doc} User Function ADVEN073P
	Fun��o para envio de custos ao SalesForce. Chamado 037261.
	@type  Function
	@author Everson
	@since 10/01/2018
	@version 01
	@history Everson, 19/05/2020. Chamado 056977. Adicionado pre�o m�nimo do supervisor.
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history Everson, 10/03/2023, ticket TI - N�o enviar custo ao SF, caso a empresa logada n�o for empresa 01 e filial 02.
	/*/
User Function ADVEN073P(cDe,cAte,lAut,cExpSql,lAltTabPrc) // U_ADVEN073P("20200519","20200519",.T.)

	//Vari�veis.	
	Local aArea   := GetArea()

	//
	Default cDe 		:= ""
	Default cAte		:= ""
	Default lAut		:= .F.
	Default cExpSql 	:= ""
	Default lAltTabPrc	:= .F.
	
	Private lAltTab		:= lAltTabPrc

	//Everson - 10/03/2023.
	If cEmpAnt + cFilAnt <> "0102"
		RestArea(aArea)
		Return Nil
	
	EndIf

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Fun��o para envio de custos ao SalesForce')

	//
	If ! lAut
		MsAguarde({|| Processar(cDe,cAte,lAut,cExpSql) },"Aguarde","Processando registros(SF)...")

	Else
		Processar(cDe,cAte,lAut,cExpSql)

	EndIf

	//
	RestArea(aArea)

Return Nil
/*/{Protheus.doc} Processar
	Processamento dos envios. 
	@type  Static Function
	@author Everson 
	@since 10/01/2018
	@version 01
	/*/
Static Function Processar(cDe,cAte,lAut,cExpSql)

	//Vari�veis.
	Local aParametros 	:= {}
	Local aResponse		:= {}
	Local lLogin		:= .F.
	Local cQuery		:= ""
	Local cServTab		:= "/services/data/v41.0/sobjects/Custo__c/"
	Local cCmpChv		:= "CHVSF"
	Local cObjeto		:= "custo"
	Local cChvExt		:= "Chave_Externa__c/"
	Local aRetOk		:= {}
	Local cMsg			:= ""

	//Efetura login no SalesForce.
	//lLogin := Static Call(ADVEN075P,loginSF,@aResponse,@cMsg,lAut)
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
    lLogin := u_VEN075A1(@aResponse,@cMsg,lAut)

	//
	If ! lLogin
		Return Nil

	EndIf
	
	//Obt�m a query.
	cQuery := scriptSql(cDe,cAte,cExpSql)
	
	//Adiciona par�metros ao vetor.
	Aadd(aParametros,aResponse)
	Aadd(aParametros,"ADVEN073P")
	Aadd(aParametros,cQuery)
	Aadd(aParametros,lAut)
	Aadd(aParametros,cServTab)
	Aadd(aParametros,cCmpChv)
	Aadd(aParametros,cObjeto)
	Aadd(aParametros,"montJson")
	Aadd(aParametros,cChvExt)
	Aadd(aParametros,.F.)
	
	//Processa os registros.
	If  ! lAut
		//Processa({|| Static Call(ADVEN075P,ProcessarB,@aParametros,.F.,"PATCH",@aRetOk) },"Aguarde","Processando registro(s) ...",.T.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		Processa({|| u_VEN075A4(@aParametros,.F.,"PATCH",@aRetOk) },"Aguarde","Processando registro(s) ...",.T.)
	Else
		//Static Call(ADVEN075P,ProcessarB,@aParametros,.F.,"PATCH",@aRetOk)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A4( @aParametros,.F.,"PATCH",@aRetOk )
		
	EndIf

Return Nil
/*/{Protheus.doc} montJson
	Monta json. 
	@type  Static Function
	@author Everson 
	@since 19/12/2017
	@version 01
	/*/
Static Function montJson(cMetodo,cChvExt,cNmAlias)

	//Vari�veis.
	Local cJson	    := ""
	
	//
	cJson += '{'
		cJson += '"method" : "' + cMetodo + '",'
        cJson += '"url" : ' + Iif(cMetodo == "POST",'"v41.0/sobjects/Custo__c"', '"v41.0/sobjects/Custo__c/' + cChvExt + Alltrim(cValtoChar((cNmAlias)->CHVSF)) + '"') + ','
		cJson += '"richInput":{'
			
			//Valida se � necess�rio enviar c�digo e data. Envio apenas para opera��o de inser��o.
			If cMetodo == "POST"
				cJson += '"Produto__r" : {'
					cJson += '"Codigo__c" : "' + Alltrim(cValtoChar((cNmAlias)->B1_COD)) + '"'
				cJson += '},'
				cJson += '"Data__c" : "' + Alltrim(cValtoChar((cNmAlias)->DT_SF)) + '",'
			
			EndIf

			cJson += '"Produto__r" : {'
				cJson += '"Codigo__c" : "' + Alltrim(cValtoChar((cNmAlias)->B1_COD)) + '"'
			cJson += '},'
			cJson += '"Data__c" : "' + Alltrim(cValtoChar((cNmAlias)->DT_SF)) + '",'			
			cJson += '"Preco_Maximo__c": "' + Alltrim(cValtoChar((cNmAlias)->VL_MAX)) + '",'
			cJson += '"Preco_Minimo__c": "' + Alltrim(cValtoChar((cNmAlias)->VL_MIN)) + '",'
			cJson += '"Preco_Meta__c"  : "' + Alltrim(cValtoChar((cNmAlias)->VL_MET)) + '",'
			cJson += '"Preco_Min_Supervisor__c" : "' + Alltrim(cValtoChar((cNmAlias)->VL_SUP)) + '",' //Everson - 19/05/2020. Chamado 056977.
			cJson += '"Preco_Custo__c" : "' + Alltrim(cValtoChar((cNmAlias)->VL_CUS)) + '"'
			
		cJson += '}'
	cJson += '},'
	
Return cJson
/*/{Protheus.doc} scriptSql
	Script sql para consulta de produtos.
	@type  Static Function
	@author Everson 
	@since 26/12/2017
	@version 01
	/*/
Static Function scriptSql(cDe,cAte,cExpSql)

	//Vari�veis.
	Local cQuery := ""

	//
	cQuery += " SELECT " 
	cQuery += " RTRIM(LTRIM(B1_COD)) + SUBSTRING(ZZS_DATA,1,4) + '-' + SUBSTRING(ZZS_DATA,5,2) + '-' + SUBSTRING(ZZS_DATA,7,2) AS CHVSF,  " 
	cQuery += " SUBSTRING(ZZS_DATA,1,4) + '-' + SUBSTRING(ZZS_DATA,5,2) + '-' + SUBSTRING(ZZS_DATA,7,2) AS DT_SF,  " 
	cQuery += " ZZS_DATA, B1_COD, ZZS_VALOR AS VL_CUS, ZZS_PRMETA AS VL_MET, MAXI.DA1_XPRLIQ AS VL_MAX, MINI.DA1_XPRLIQ AS VL_MIN, SUPER.DA1_XPRLIQ AS VL_SUP " //Everson - 19/05/2020. Chamado 056977.
	cQuery += " FROM    " 
	cQuery += " " + RetSqlName("ZZS") + "  (NOLOCK) AS ZZS   " 
	cQuery += " LEFT OUTER JOIN   " 
	cQuery += " " + RetSqlName("SB1") + "  (NOLOCK) AS SB1   " 
	cQuery += " ON ZZS_GRUPO = B1_GRUPO   " 
	cQuery += " LEFT OUTER JOIN " 
	cQuery += " (SELECT DA1_CODPRO, DA1_XPRLIQ FROM " + RetSqlName("DA1") + " (NOLOCK) AS DA1 WHERE DA1_FILIAL = '" + xFilial("DA1") + "' AND DA1_CODTAB IN ('Y00') AND DA1.D_E_L_E_T_ = '') AS MAXI " 
	cQuery += " ON B1_COD = MAXI.DA1_CODPRO " 
	cQuery += " LEFT OUTER JOIN " 
	cQuery += " (SELECT DA1_CODPRO, DA1_XPRLIQ FROM " + RetSqlName("DA1") + " (NOLOCK) AS DA1 WHERE DA1_FILIAL = '" + xFilial("DA1") + "' AND DA1_CODTAB IN ('Z01') AND DA1.D_E_L_E_T_ = '') AS MINI " 
	cQuery += " ON B1_COD = MINI.DA1_CODPRO " 

	//Everson - 19/05/2020. Chamado 056977.
	cQuery += " LEFT OUTER JOIN " 
	cQuery += " (SELECT DA1_CODPRO, DA1_XPRLIQ FROM " + RetSqlName("DA1") + " (NOLOCK) AS DA1 WHERE DA1_FILIAL = '" + xFilial("DA1") + "' AND DA1_CODTAB IN ('Z00') AND DA1.D_E_L_E_T_ = '') AS SUPER " 
	cQuery += " ON B1_COD = SUPER.DA1_CODPRO " 
	//

	cQuery += " WHERE   " 
	cQuery += " ZZS.D_E_L_E_T_ = ''   " 
	cQuery += " AND SB1.D_E_L_E_T_ = ''   " 
	cQuery += " AND B1_XSALES = '2' " 
	
	//
	If ! Empty(cAte)
		cQuery += " AND ZZS_DATA >= '" + cDe + "'   " 
		cQuery += " AND ZZS_DATA <= '" + cAte + "'  " 
	
	EndIf
	
	//
	If ! Empty(cExpSql)
		cQuery += cExpSql
	
	EndIf
	
	cQuery += " ORDER BY ZZS_DATA, B1_GRUPO, B1_COD " 
	
Return cQuery
