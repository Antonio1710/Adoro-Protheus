#Include "Totvs.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} User Function ADVEN052P
	Fun��o para envio de parecer ao SalesForce. 
	@type  Function
	@author Everson
	@since 22/01/2018
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 76863 - 26/07/2022 - Fernando Macieira - ERRO ATUALIZA��O DE CADASTRO CLIENTE
/*/
User Function ADVEN052P(cCodPB3,cLojaPB3,lAut,cTexto,cTipo,cExpSql,aResponse) // U_ADVEN052P("190162","00",.F.)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������		
	Local aArea   := GetArea()

	Default cCodPB3  := ""
	Default cLojaPB3 := ""
	Default lAut	 := .F.
	Default cTexto   := ""
	Default cTipo	 := ""
	Default cExpSql	 := ""
	Default aResponse:= {}

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Fun��o para envio de parecer ao SalesForce')
	
	//
	If ! lAut
		MsAguarde({|| Processar(cCodPB3,cLojaPB3,lAut,cTexto,cTipo,cExpSql,aResponse) },"Aguarde","Processando parecer(SF)...")

	Else
		              Processar(cCodPB3,cLojaPB3,lAut,cTexto,cTipo,cExpSql,aResponse)

	EndIf

	//
	RestArea(aArea)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Processar      �Autor  �Everson      � Data �  22/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento dos envios.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Processar(cCodPB3,cLojaPB3,lAut,cTexto,cTipo,cExpSql,aResponse)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aParametros := {}
	Local cMsg		:= ""
	Local lLogin	:= .F.
	Local cQuery	:= ""
	Local cServTab	:= "/services/data/v41.0/sobjects/Parecer__c/"
	Local cCmpChv	:= "CHVSF"
	Local cObjeto	:= "parecer"
	Local cChvExt	:= ""
	
	Default aResponse := {}

	//Efetura login no SalesForce.
	If Len(aResponse) <= 0
		//lLogin := Static Call(ADVEN075P,loginSF,@aResponse,@cMsg,lAut)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
    	lLogin := u_VEN075A1(@aResponse,@cMsg,lAut)
	
		//
		If ! lLogin
			Return Nil
	
		EndIf
	
	EndIf

	//Obt�m a query.
	cQuery := scriptSql(cCodPB3,cLojaPB3,lAut,cTexto,cTipo,cExpSql)

	//Adiciona par�metros ao vetor.
	Aadd(aParametros,aResponse)
	Aadd(aParametros,"ADVEN052P")
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
		//Processa({|| Static Call(ADVEN075P,ProcessarB,@aParametros,.F.,"POST",{}) },"Aguarde","Processando cadastro cliente(SF)...",.T.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		Processa({|| u_VEN075A4(@aParametros,.F.,"POST",{}) },"Aguarde","Processando cadastro cliente(SF)...",.T.)

	Else
		//Static Call(ADVEN075P,ProcessarB,@aParametros,.F.,"POST",{})
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A4( @aParametros,.F.,"POST",{} )

	EndIf
					
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �montJson     �Autor  �Everson     � Data �  22/01/2018      ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta json.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function montJson(cMetodo,cChvExt,cNmAlias)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local aArea	:= GetArea()
	Local cJson	:= ""

	cJson += '{'
	cJson += '"method" : "' + cMetodo + '",'
	cJson += '"url" : ' + Iif(cMetodo == "POST",'"v41.0/sobjects/Parecer__c"', '"v41.0/sobjects/Parecer__c/' + cChvExt +  Alltrim(cValtoChar((cNmAlias)->CHVSF)) + '"') + ','
	cJson += '"richInput":{'
			
		//Solicita��o de documenta��o.
		If Alltrim(cValToChar((cNmAlias)->TIPO)) == "A"
	
			cJson += '"Parecer__c" : "Documenta��o - ' + Alltrim(cValToChar((cNmAlias)->TEXTO)) + '",'
			cJson += '"Usuario__c" : "' + Upper(Alltrim(cUserName)) + '",'
			cJson += '"Status__c" : "P",'
			cJson += '"Lead__c" : "'    + Alltrim(cValToChar((cNmAlias)->PB3_XSALES)) + '"'	
			
		ElseIf Alltrim(cValToChar((cNmAlias)->TIPO)) == "B" //Atualiza��o SA1.
		
			cJson += '"Parecer__c" : " Atualiza��o - ' + Alltrim(cValToChar((cNmAlias)->TEXTO)) + '",'
			cJson += '"Usuario__c" : "' + Upper(Alltrim(cUserName)) + '",'
			cJson += '"Status__c" : "A",'
			cJson += '"Conta__r" : {'
				cJson += '"Chave_Externa__c" : "' + Alltrim(cValToChar((cNmAlias)->PB3_CODSA1)) + Alltrim(cValToChar((cNmAlias)->PB3_LOJSA1)) + '"'
			cJson += '},'
			cJson += '"Codigo_PB3__c":"' + Alltrim(cValToChar((cNmAlias)->PB3_COD))    + Alltrim(cValToChar((cNmAlias)->PB3_LOJA))   + '",'
			cJson += '"Codigo_SA1__c":"' + Alltrim(cValToChar((cNmAlias)->PB3_CODSA1)) + Alltrim(cValToChar((cNmAlias)->PB3_LOJSA1)) + '"'		
				
		//Json para novo cliente rejeitado.
		ElseIf Alltrim(cValToChar((cNmAlias)->TIPO)) == "C" .And. !Empty(Alltrim(cValToChar((cNmAlias)->PB3_XSALES))) .And. Substr(Alltrim(cValToChar((cNmAlias)->PB3_MOTACE)),1,2) $("01|06") .And.;
		Empty((cNmAlias)->PB3_CODSA1) .And.;
		Empty((cNmAlias)->PB3_LOJSA1)
	
			cJson += '"Parecer__c" : "Rejei��o de Pr�-cadastro - ' + Alltrim(cValToChar((cNmAlias)->TEXTO)) + '",'
			cJson += '"Usuario__c" : "' + Upper(Alltrim(cUserName)) + '",'
			cJson += '"Status__c" : "R",'
			cJson += '"Lead__c" : "'    + Alltrim(cValToChar((cNmAlias)->PB3_XSALES)) + '"'	
	
		//Json para novo cliente aprovado (necess�rio primeiro enviar o cadastro do cliente - Account).
		ElseIf Alltrim(cValToChar((cNmAlias)->TIPO)) == "D" .And. !Empty(Alltrim(cValToChar((cNmAlias)->PB3_XSALES))) .And. Substr(Alltrim(cValToChar((cNmAlias)->PB3_MOTACE)),1,2) $("01|06") .and.;
			Empty((cNmAlias)->PB3_CODSA1) .And.;
			Empty((cNmAlias)->PB3_LOJSA1) // @history ticket 76863 - 26/07/2022 - Fernando Macieira - ERRO ATUALIZA��O DE CADASTRO CLIENTE - Inclu�do Empty((cNmAlias)->PB3_CODSA1) e Empty((cNmAlias)->PB3_LOJSA1)

	
			cJson += '"Parecer__c" : "Aprova��o de Pr�-cadastro - ' + Alltrim(cValToChar((cNmAlias)->TEXTO)) + '",'
			cJson += '"Usuario__c" : "'  + Upper(Alltrim(cUserName)) + '",'
			cJson += '"Status__c" : "A",'
			cJson += '"Lead__c" : "'     + Alltrim(cValToChar((cNmAlias)->PB3_XSALES)) + '",'
			cJson += '"Conta__r" : {'
				cJson += '"Chave_Externa__c" : "' + Alltrim(cValToChar((cNmAlias)->PB3_CODSA1)) + Alltrim(cValToChar((cNmAlias)->PB3_LOJSA1)) + '"'
			cJson += '},'
			cJson += '"Codigo_PB3__c":"' + Alltrim(cValToChar((cNmAlias)->PB3_COD))    + Alltrim(cValToChar((cNmAlias)->PB3_LOJA))   + '",'
			cJson += '"Codigo_SA1__c":"' + Alltrim(cValToChar((cNmAlias)->PB3_CODSA1)) + Alltrim(cValToChar((cNmAlias)->PB3_LOJSA1)) + '"'
	
		//Inser��o de parecer para solicita��o de atualiza��o reprovada.
		ElseIf Alltrim(cValToChar((cNmAlias)->TIPO)) == "C" .And. !(Substr(Alltrim(cValToChar((cNmAlias)->PB3_MOTACE)),1,2) $("01|06")) .And. Alltrim(cValToChar((cNmAlias)->PB3_SITUAC)) == "3" .And.;
		!Empty((cNmAlias)->PB3_CODSA1) .And.;
		!Empty((cNmAlias)->PB3_LOJSA1)

			cJson += '"Parecer__c" : "Atualiza��o Rejeitada - ' + Alltrim(cValToChar((cNmAlias)->PB3_MOTACE)) + " - " + Alltrim(cValToChar((cNmAlias)->TEXTO)) + '",'
			cJson += '"Usuario__c" : "' + Upper(Alltrim(cUserName)) + '",'
			cJson += '"Status__c" : "R",'
			cJson += '"Conta__r" : {'
			cJson += '"Chave_Externa__c" : "' + Alltrim(cValToChar((cNmAlias)->PB3_CODSA1)) + Alltrim(cValToChar((cNmAlias)->PB3_LOJSA1)) + '"'
			cJson += '},'
			cJson += '"Codigo_PB3__c":"' + Alltrim(cValToChar((cNmAlias)->PB3_COD))    + Alltrim(cValToChar((cNmAlias)->PB3_LOJA))   + '",'
			cJson += '"Codigo_SA1__c":"' + Alltrim(cValToChar((cNmAlias)->PB3_CODSA1)) + Alltrim(cValToChar((cNmAlias)->PB3_LOJSA1)) + '"'
	
		//Inser��o de parecer para solicita��o de atualiza��o de cliente aprovado.
		ElseIf Alltrim(cValToChar((cNmAlias)->TIPO)) == "D" .And. !(Substr(Alltrim(cValToChar((cNmAlias)->PB3_MOTACE)),1,2) $("01|06")) .And. Alltrim(cValToChar((cNmAlias)->PB3_SITUAC)) == "".And.;
		!Empty((cNmAlias)->PB3_CODSA1) .And.;
		!Empty((cNmAlias)->PB3_LOJSA1)
	
			cJson += '"Parecer__c" : " Atualiza��o - ' + Alltrim(cValToChar((cNmAlias)->PB3_MOTACE)) + Alltrim(cValToChar((cNmAlias)->TEXTO)) + '",'
			cJson += '"Usuario__c" : "' + Upper(Alltrim(cUserName)) + '",'
			cJson += '"Status__c" : "A",'
			cJson += '"Conta__r" : {'
				cJson += '"Chave_Externa__c" : "' + Alltrim(cValToChar((cNmAlias)->PB3_CODSA1)) + Alltrim(cValToChar((cNmAlias)->PB3_LOJSA1)) + '"'
			cJson += '},'
			cJson += '"Codigo_PB3__c":"' + Alltrim(cValToChar((cNmAlias)->PB3_COD))    + Alltrim(cValToChar((cNmAlias)->PB3_LOJA))   + '",'
			cJson += '"Codigo_SA1__c":"' + Alltrim(cValToChar((cNmAlias)->PB3_CODSA1)) + Alltrim(cValToChar((cNmAlias)->PB3_LOJSA1)) + '"'
			
		EndIf
	
		cJson += '}'
	cJson += '},'
	
	//
	RestArea(aArea)

Return cJson
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �scriptSql       �Autor  �Everson     � Data �  22/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Script sql.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function scriptSql(cCodPB3,cLojaPB3,lAut,cTexto,cTipo,cExpSql)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������
	Local cQuery := ""

	//
	cQuery := ""
	cQuery += " SELECT PB3_XSALES AS CHVSF, '" + cTexto + "' AS TEXTO, '" + cTipo + "' AS TIPO, "
	cQuery += " PB3_COD, PB3_LOJA, PB3_SITUAC, PB3_SITUAC, PB3_CODSA1, PB3_LOJSA1, PB3_MOTACE, PB3_XSALES, PB3_XCASO "
	cQuery += " FROM "
	cQuery += " " + RetSqlName("PB3") + " (NOLOCK) AS PB3 "
	cQuery += " WHERE "
	cQuery += " PB3.D_E_L_E_T_ = '' "
	
	If !Empty(cCodPB3) .And. !Empty(cLojaPB3)
		cQuery += " AND PB3_COD  = '" + cCodPB3 + "' "
		cQuery += " AND PB3_LOJA = '" + cLojaPB3 + "' "
	
	EndIf
	
	//
	If !Empty(cExpSql)
		cQuery += cExpSql
		
	EndIF

Return cQuery