#Include "Totvs.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADVEN072P      �Autor  �Everson      � Data �  05/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para envio de tabela de pre�o ao SalesForce.         ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
@history Everson, 10/03/2023, ticket TI - N�o enviar tabela de pre�o ao SF, caso a empresa logada n�o for empresa 01 e filial 02.
*/
User Function ADVEN072P(cDe,cAte,lAut,cExpSql) // U_ADVEN072P("","",.F.," AND DA0_FILIAL = '02' AND D_E_L_E_T_ = '' ")

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aArea   	:= GetArea()
	
	Default cDe 	  := ""
	Default cAte	  := ""
	Default lAut	  := .F.
	Default cExpSql	  := ""

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Fun��o para envio de tabela de pre�o ao SalesForce')
	
	//Everson - 10/03/2023.
	If cEmpAnt + cFilAnt <> "0102"
		RestArea(aArea)
		Return Nil
	
	EndIf

	//
	If ! lAut
		MsAguarde({|| Processar(cDe,cAte,lAut,cExpSql) },"Aguarde","Enviando registros(SF)...")
	
	Else
		Processar(cDe,cAte,lAut,cExpSql)
		
	EndIf

	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Processar      �Autor  �Everson      � Data �  05/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento dos envios.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Processar(cDe,cAte,lAut,cExpSql)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aParametros := {}
	Local aResponse	:= {}
	Local cMsg		:= ""
	Local lLogin	:= .F.
	Local cQuery	:= ""
	Local cServTab	:= "/services/data/v41.0/sobjects/Pricebook2/"
	Local cCmpChv	:= "CHVSF"
	Local cObjeto	:= "cabe�alho tabela pre�o"
	Local cChvExt	:= "Codigo__c/"
	Local aRetOk	:= {}

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
	Aadd(aParametros,"ADVEN072P")
	Aadd(aParametros,cQuery)
	Aadd(aParametros,lAut)
	Aadd(aParametros,cServTab)
	Aadd(aParametros,cCmpChv)
	Aadd(aParametros,cObjeto)
	Aadd(aParametros,"montJson")
	Aadd(aParametros,cChvExt)
	Aadd(aParametros,.F.)

	//Processa os registros (cabe�alho da tabela de pre�o).
	If  ! lAut
		//Processa({|| Static Call(ADVEN075P,ProcessarB,@aParametros,.F.,"PATCH",@aRetOk,.T.) },"Aguarde","Processando tabela de pre�o(SF)...",.T.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		Processa({|| u_VEN075A4(@aParametros,.F.,"PATCH",@aRetOk,.T.) },"Aguarde","Processando tabela de pre�o(SF)...",.T.)

	Else
		//Static Call(ADVEN075P,ProcessarB,@aParametros,.F.,"PATCH",@aRetOk,.T.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A4( @aParametros,.F.,"PATCH",@aRetOk,.T. )

	EndIf
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �montJson     �Autor  �Everson     � Data �  05/01/2018      ���
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
	Local cJson	 	:= ""
	CONOUT("Atualiza tab " + Alltrim(cValtoChar((cNmAlias)->CHVSF)))
	//Monta json.
	cJson += '{'

	cJson += '"method" : "' + cMetodo + '",'
	cJson += '"url" : ' + Iif(cMetodo == "POST",'"v41.0/sobjects/Pricebook2"', '"v41.0/sobjects/Pricebook2/' + cChvExt +  Alltrim(cValtoChar((cNmAlias)->CHVSF)) + '"') + ','
		cJson += '"richInput":{'	
			
			//
			If cMetodo == "POST"
				cJson += '"Codigo__c" : "' + Alltrim(cValToChar((cNmAlias)->DA0_CODTAB)) + '",'
		
			EndIf
			
			//
			cJson += '"Name" : "' + Alltrim(cValToChar((cNmAlias)->DA0_CODTAB)) + '-' + Alltrim(cValToChar((cNmAlias)->DA0_DESCRI)) + '",'
			cJson += '"IsActive" : ' + Iif( Alltrim(cValToChar((cNmAlias)->DA0_ATIVO)) == "1","true","false") +  ','
			
			cJson += '"Vendedor__c" : "'   + Alltrim(cValToChar((cNmAlias)->DA0_XVENDE)) + '",'
			cJson += '"Supervisor__c" : "' + Alltrim(cValToChar((cNmAlias)->DA0_XSUPER)) + '",'
			cJson += '"Gerente__c" : "'    + Alltrim(cValToChar((cNmAlias)->DA0_XGEREN)) + '",'
			cJson += '"Diretor__c" : "'    + Alltrim(cValToChar((cNmAlias)->DA0_XDIRET)) + '"'
	
		cJson += '}'

	cJson += '},'

Return cJson
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �scriptSql     �Autor  �Everson      � Data �  05/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Script sql para consulta cabe�alho.                         ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function scriptSql(cDe,cAte,cExpSql)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local cQuery := ""	

	//
	cDe := Alltrim(cValToChar(cDe))
	cExpSql	  := Alltrim(cValToChar(cExpSql))

	//
	cQuery := ""
	cQuery += " SELECT DA0_CODTAB AS CHVSF, DA0_CODTAB, DA0_DESCRI, DA0_ATIVO, DA0_XVENDE, DA0_XSUPER, DA0_XGEREN, DA0_XDIRET " 
	cQuery += " FROM " 
	cQuery += " " + RetSqlName("DA0") + " (NOLOCK) AS DA0 " 
	cQuery += " WHERE " 
	cQuery += " DA0.D_E_L_E_T_ = '' " 
	cQuery += " AND DA0_FILIAL = '" + cFilAnt + "' "
	cQuery += " AND DA0_XSALES = '2' "

	//
	If ! Empty(cAte)
		cQuery += " AND DA0_CODTAB >= '" + cDe + "' " 
		cQuery += " AND DA0_CODTAB <= '" + cAte + "' " 

	EndIf
	
	//
	If ! Empty(cExpSql)
		cQuery += cExpSql
		
	EndIf

	cQuery += " ORDER BY DA0_CODTAB " 

Return cQuery
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �envItens     �Autor  �Everson        � Data �  12/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o envio de itens.                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function envItens(cParamBsc,lAut,cChvTab,aResponse)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local aParametros := {}
	Local cQuery	:= ""
	Local cServTab	:= "/services/data/v41.0/sobjects/PricebookEntry/"
	Local cCmpChv	:= "CHVSF"
	Local cObjeto	:= "item tabela de pre�o"
	Local cChvExt	:= "Chave_Externa__c/"
	Local aRetOk	:= {}
	
	//Obt�m a query.
	cQuery := iscriptSql(cParamBsc)
	
	//Adiciona par�metros ao vetor.
	Aadd(aParametros,aResponse)
	Aadd(aParametros,"ADVEN072P")
	Aadd(aParametros,cQuery)
	Aadd(aParametros,lAut)
	Aadd(aParametros,cServTab)
	Aadd(aParametros,cCmpChv)
	Aadd(aParametros,cObjeto)
	Aadd(aParametros,"imontJson")
	Aadd(aParametros,cChvExt)
	Aadd(aParametros,.F.)
	
	//Processa os registros em lote.
	If  ! lAut
		//Processa({|| Static Call(ADVEN075P,ProcessarB,@aParametros,,"",@aRetOk) },"Aguarde","Processando registro(s) itens ...",.T.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		Processa({|| u_VEN075A4( @aParametros,,"",@aRetOk,.F.,.T.,"",.T.,.F.) },"Aguarde","Processando registro(s) itens ...",.T.)
		
	Else				
		//Static Call(ADVEN075P,ProcessarB,@aParametros,,"",@aRetOk,.F.,.T.,"",.T.,.F.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A4( @aParametros,,"",@aRetOk,.F.,.T.,"",.T.,.F. )
		//Static Call(ADVEN075P,ProcessarB,@aParametros,,"",@aRetOk,.F.,.T.,"",.T.,.F.)
	
	EndIf

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �imontJson     �Autor  �Everson     � Data �  05/01/2018     ���
�������������������������������������������������������������������������͹��
���Desc.     �Monta json.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function imontJson(cMetodo,cChvExt,cNmAlias)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local cJson	 	:= ""
	
	//
	cJson += '{'
		cJson += '"method" : "' + cMetodo + '",'
		cJson += '"url" : ' + Iif(cMetodo == "POST",'"v41.0/sobjects/PricebookEntry"', '"v41.0/sobjects/PricebookEntry/' + cChvExt +  Alltrim(cValtoChar((cNmAlias)->CHVSF)) + '"') + ','
		cJson += '"richInput":{'	
	
			If cMetodo == "POST"
				cJson += '"Chave_Externa__c" : "' + Alltrim(cValToChar((cNmAlias)->CHVSF)) + '",'
				cJson += '"Product2" : {'
					cJson += '"Codigo__c" : "' + Alltrim(cValToChar((cNmAlias)->DA1_CODPRO)) + '"'
				cJson += '},'
				cJson += '"Pricebook2": {'
					cJson += '"Codigo__c" : "' + Alltrim(cValToChar((cNmAlias)->DA1_CODTAB)) + '"'
				cJson += '},'
				
			EndIf
			
/*			cJson += '"Product2" : {'
				cJson += '"Codigo__c" : "' + Alltrim(cValToChar((cNmAlias)->DA1_CODPRO)) + '"'
			cJson += '},'
			cJson += '"Pricebook2": {'
				cJson += '"Codigo__c" : "' + Alltrim(cValToChar((cNmAlias)->DA1_CODTAB)) + '"'
			cJson += '},'*/
			
			cJson += '"IsActive" : ' + Iif( Alltrim(cValToChar((cNmAlias)->DA1_ATIVO)) == "1","true","false") +  ','
			cJson += '"UnitPrice" : "' + Alltrim(cValToChar((cNmAlias)->DA1_XPRLIQ)) + '"'
						
		cJson += '}'
		
	cJson += '},'

Return cJson
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �iscriptSql     �Autor  �Everson      � Data �  05/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Script sql para consulta itens.                             ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function iscriptSql(cParamBsc,cAliasTab,cCampo)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local cQuery := ""	

	//
	cParamBsc := Alltrim(cValToChar(cParamBsc))
	
	//
	cQuery := ""
	cQuery += " SELECT RTRIM(LTRIM(DA1_CODPRO))+RTRIM(LTRIM(DA1_CODTAB)) AS CHVSF, DA1_CODPRO, DA1_CODTAB, DA1_XPRLIQ, DA1_ATIVO, DA1_XIDSF AS IDSALES " 
	cQuery += " FROM " 
	cQuery += " " + RetSqlName("DA1") + " (NOLOCK) AS DA1 INNER JOIN " + RetSqlName("SB1") + " (NOLOCK) AS SB1 ON DA1_CODPRO = B1_COD " 
	cQuery += " WHERE " 
	cQuery += " DA1.D_E_L_E_T_ = '' " 
	cQuery += " AND SB1.D_E_L_E_T_ = '' " 
	cQuery += " AND DA1_FILIAL = '" + cFilAnt + "' "
	cQuery += " AND DA1_CODTAB = '" + cParamBsc + "' " 
	cQuery += " AND B1_XSALES = '2' "
	cQuery += " ORDER BY DA1_CODTAB, DA1_CODPRO " 
	
Return cQuery
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �mrkReg         �Autor  �Everson      � Data �  04/04/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Script sql para consulta itens.                             ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function mrkReg(cChave,lAut,cId,cMetodo,aResponse,cAliasS)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local cUpdate := ""
	Local cMsg	  := ""
	
	//Remove Marca de nota de sa�da e c�digo da empresa.
	cChave := Alltrim(cValToChar(cChave))
	cId    := Alltrim(cValToChar(cId))

	//
	If Empty(cId)
		Return Nil
	
	EndIf
	
	//
	cUpdate := " UPDATE " + RetSqlName("DA1") + " SET DA1_XIDSF = '" + cId + "' WHERE DA1_FILIAL = '" + cFilAnt + "' AND RTRIM(LTRIM(DA1_CODPRO))+RTRIM(LTRIM(DA1_CODTAB)) = '" + cChave + "' AND D_E_L_E_T_ = '' "
	
	//Atualiza o registro na SF2.
	If TCSqlExec(cUpdate) < 0
		
		cMsg := "N�o foi poss�vel atualizar o registro SF2 " + cChave + Chr(13) + Chr(10) + "TCSQLError() " + TCSQLError()
		If !lAut
			MsgAlert(cMsg,"Fun��o mrkReg (ADVEN072P)")
			
		Else
			//Static Call(ADVEN075P,envErros,cMsg + "Fun��o mrkReg (ADVEN072P)")
			//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
			u_VEN075A2( cMsg + "Fun��o mrkReg (ADVEN072P)" )	
			
		EndIf
	
	EndIf
	
Return Nil
