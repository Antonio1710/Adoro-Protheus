#Include "Totvs.ch"
#Include "Topconn.ch"
/*/{Protheus.doc} ADVEN074P
	Fun��o para envio de notas fiscais ao SalesForce.
	Chamado 037261.
	@type  Function
	@author Everson
	@since 12/01/2018
	@version 01
	@history Everson, 23/09/2021, Chamado 44817. Tratamento para marcar as notas fiscais j� enviadas.
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	/*/
User Function ADVEN074P(cEmp,cFili,cParamBsc,lAut,cExpSql,lCancelada) // U_ADVEN074P("01","02","",.F.," AND F2_DOC = '001295801' ") // U_ADVEN074P("01","02","001200752SF1",.F.,"",.T.)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local aArea   	:= GetArea()
	
	Default cEmp	   := "01"
	Default cFili	   := "02"
	Default cParamBsc  := ""
	Default lAut	   := .F.
	Default cExpSql	   := ""
	Default lCancelada := .F.
	
	Private cEmpC	  := cEmp
	Private cFiliC    := cFili
	Private lCanc	  := lCancelada
	Private lMrkCanc  := .F.

	Conout("IN�CIO ADVEN074P >>>>>>>>>>>>>>>>>>>>>>>>>")
	
	//
	If ! lAut
		MsAguarde({|| Processar(cParamBsc,lAut,cExpSql,cEmp,cFili,lCancelada,1) },"Aguarde","Enviando registros(SF)...")
	
	Else
		Processar(cParamBsc,lAut,cExpSql,cEmp,cFili,lCancelada,1)
		Conout("ADVEN074P - In�cio envio de notas de sa�da canceladas.")
		lMrkCanc := .T.
		Processar("",lAut,cExpSql,cEmp,cFili,.T.,2)
		Conout("ADVEN074P - Fim envio de notas de sa�da canceladas.")
		              
	EndIf

	Conout("FIM ADVEN074P >>>>>>>>>>>>>>>>>>>>>>>>>")
	
	//
	RestArea(aArea)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Processar      �Autor  �Everson      � Data �  12/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processamento dos envios.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function Processar(cParamBsc,lAut,cExpSql,cEmp,cFili,lCancelada,nOpc)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	Local aParametros := {}
	Local aResponse	:= {}
	Local cMsg		:= ""
	Local lLogin	:= .F.
	Local cQuery	:= ""
	Local cServTab	:= "/services/data/v41.0/sobjects/Faturamento__c/"
	Local cCmpChv	:= "CHVSF"
	Local cObjeto	:= "cabe�alho nota fiscal"
	Local cChvExt	:= "Chave_Externa__c/"
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
	cQuery := scriptSql(nOpc,cParamBsc,cExpSql,cEmp,cFili,lCancelada)

	//Adiciona par�metros ao vetor.
	Aadd(aParametros,aResponse)
	Aadd(aParametros,"ADVEN074P")
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
		//Processa({|| Static Call(ADVEN075P,ProcessarB,@aParametros,,"",@aRetOk,Iif(lCanc,.F.,.T.),.T.,"",.T.,.F.) },"Aguarde","Processando cabe�alho NF sa�da(SF)...",.T.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		Processa({|| u_VEN075A4( @aParametros,,"",@aRetOk,Iif(lCanc,.F.,.T.),.T.,"",.T.,.F.) },"Aguarde","Processando cabe�alho NF sa�da(SF)...",.T.)
		//Processa({|| itemNEnv(lAut,aResponse) },"Aguarde","Processando item NF sa�da(SF) n�o processado...",.T.)
		
	Else
		//Static Call(ADVEN075P,ProcessarB,@aParametros,,"",@aRetOk,Iif(lCanc,.F.,.T.),.T.,"",.T.,.F.,lMrkCanc)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A4( @aParametros,,"",@aRetOk,Iif(lCanc,.F.,.T.),.T.,"",.T.,.F.,lMrkCanc )
		If nOpc == 1
			itemNEnv(lAut,aResponse)
		
		EndIf
		
	EndIf

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �montJson     �Autor  �Everson     � Data �  19/12/2017      ���
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
	Local cData		:= ""
	Local cPedido	:= Alltrim(cValToChar(Posicione("SD2",3,xFilial("SD2") + (cNmAlias)->F2_DOC + (cNmAlias)->F2_SERIE ,"D2_PEDIDO")))
	Local cPedSF	:= Alltrim(cValToChar(Posicione("SC5",1,xFilial("SC5") + cPedido   ,"C5_XPEDSAL")))

	//
	cJson += '{'

	cJson += '"method" : "' + cMetodo + '",'
	cJson += '"url" : ' + Iif(cMetodo == "POST",'"v41.0/sobjects/Faturamento__c"', '"v41.0/sobjects/Faturamento__c/' + cChvExt +  Alltrim(cValtoChar((cNmAlias)->CHVSF)) + '"') + ','
		cJson += '"richInput":{'
			
			//
			If lCanc //Envio de data de cancelamento de nota fiscal.
				
				cData := Alltrim(cValToChar(((cNmAlias)->F3_DTCANC)))
				cData := Substr(cData,1,4) + "-" + Substr(cData,5,2) + "-" + Substr(cData,7,2)
				cJson += '"Data_Cancelamento__c":"' + cData + '"'
			
			Else
			
				//
				If cMetodo == "POST"
					
					cJson += '"Chave_Externa__c" : "'  + Alltrim(cValToChar((cNmAlias)->CHVSF))    + '",'
					
				EndIf
				
				cJson += '"Cliente__r" : {'
					cJson += '"Chave_Externa__c" : "'   + Alltrim(cValToChar((cNmAlias)->F2_CLIENTE)) + Alltrim(cValToChar((cNmAlias)->F2_LOJA)) + '"'
				cJson += '},'
				
				//
				If ! Empty(cPedSF)
					cJson += '"Pedido__r" : {'
						cJson += '"Codigo_Protheus__c" : "' + cPedido + '"'
					cJson += '},'
				
				EndIf
				
				//
				If ! Empty(Alltrim(cValToChar(((cNmAlias)->F3_DTCANC))))
					cData := Alltrim(cValToChar(((cNmAlias)->F3_DTCANC)))
					cData := Substr(cData,1,4) + "-" + Substr(cData,5,2) + "-" + Substr(cData,7,2)
					cJson += '"Data_Cancelamento__c":"' + cData + '",'	
				
				EndIf	
				
				//
				cJson += '"Numero_Nota__c" : "'    + Alltrim(cValToChar((cNmAlias)->F2_DOC))   + '",'
				cJson += '"Numero_Serie__c" : "'   + Alltrim(cValToChar((cNmAlias)->F2_SERIE)) + '",'
				cJson += '"Filial__c" : "'    + Alltrim(cValToChar((cNmAlias)->F2_FILIAL))   + '",'
				cJson += '"Empresa__c" : "'   + cEmpC + '",'			
				cJson += '"Valor_Total__c" : "'           + cValToChar((cNmAlias)->F2_VALBRUT) + '",'
				cJson += '"Peso_Total_Bruto_Kg__c" : "'   + cValToChar((cNmAlias)->F2_PBRUTO) + '",'
				cJson += '"Peso_Total_Liquido_Kg__c" : "' + cValToChar((cNmAlias)->F2_PLIQUI) + '",'
				cJson += '"Tipo_Nota__c" : "S",'
				cData := Alltrim(cValToChar(((cNmAlias)->F2_EMISSAO)))
				cData := Substr(cData,1,4) + "-" + Substr(cData,5,2) + "-" + Substr(cData,7,2)
				cJson += '"Data_Emissao__c" : "'      + cData + '"'		
			
			EndIf
		
		cJson += '}'

	cJson += '},'
	
Return cJson
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �scriptSql     �Autor  �Everson      � Data �  18/12/2017    ���
�������������������������������������������������������������������������͹��
���Desc.     �Script sql para consulta.                                   ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function scriptSql(nOpc,cParamBsc,cExpSql,cEmp,cFili,lCancelada)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local cQuery := ""	
	Local cDt	 := Alltrim( cValToChar( GetMv("MV_#SFDTPD" ) ))
	
	Default nOpc := 1

	Conout("ADVEN074P scriptSql script SF2")

	//
	cParamBsc := Alltrim(cValToChar(cParamBsc))

	//
	cQuery := ""
	cQuery += " SELECT "
	cQuery += " DISTINCT 'SF2' AS TAB, 'S' + '" + cEmp + "' + RTRIM(LTRIM(F2_FILIAL)) + RTRIM(LTRIM(F2_CLIENTE)) + RTRIM(LTRIM(F2_LOJA)) + RTRIM(LTRIM(F2_DOC)) +  RTRIM(LTRIM(F2_SERIE)) AS CHVSF, " 
	cQuery += " F2_FILIAL, F2_DOC, F2_SERIE, F2_CLIENTE, F2_LOJA, F2_VALBRUT, F2_PBRUTO, F2_PLIQUI, F2_EMISSAO, F2_XSALES AS IDSALES, F3_DTCANC " 
	cQuery += " FROM " 
	cQuery += " SF2" + cEmp + "0 (NOLOCK) AS SF2 " 
	
	//
	If nOpc == 1
		cQuery += " LEFT OUTER JOIN "
	
	ElseIf nOpc == 2
		cQuery += " INNER JOIN "
		
	EndIf

	cQuery += " (SELECT F3_FILIAL, F3_NFISCAL, F3_SERIE, F3_CLIENT, F3_LOJA, F3_DTCANC FROM SF3" + cEmp + "0 (NOLOCK) WHERE F3_FILIAL = '" + cFili + "' AND F3_DTCANC <> '' AND D_E_L_E_T_ = '') AS SF3 "
	cQuery += " ON "
	cQuery += " F2_DOC = F3_NFISCAL "
	cQuery += " AND F2_SERIE = F3_SERIE "
	cQuery += " AND F2_CLIENTE = F3_CLIENT "
	cQuery += " AND F2_LOJA = F3_LOJA "
	
	//
	If cFili == "02" .And. nOpc == 1
	
		 cQuery += " INNER JOIN " 
		 cQuery += " ( " 
			 cQuery += " SELECT " 
			 cQuery += " C5_FILIAL, C5_NOTA, C5_SERIE, C5_CLIENTE, C5_LOJACLI " 
			 cQuery += " FROM " + RetSqlName("SC5") + " (NOLOCK) AS SC5 " 
			 cQuery += " WHERE " 
			 cQuery += " C5_FILIAL = '" + cFili + "' "
			 
			 If IsInCallStack("U_ADVEN083P")
				 cQuery += " AND C5_NOTA NOT IN ('','XXXXXXXXX') " 
				 cQuery += " AND C5_SERIE <> '' " 
				 cQuery += " AND C5_EMISSAO >= '" + cDt + "' " 
			 
			 EndIf
			 
			 cQuery += " AND C5_XPEDSAL <> '' " 
			 cQuery += " AND SC5.D_E_L_E_T_ = '' " 
		 cQuery += " ) AS PEDIDO " 
		 cQuery += " ON F2_FILIAL = PEDIDO.C5_FILIAL " 
		 cQuery += " AND F2_DOC = PEDIDO.C5_NOTA " 
		 cQuery += " AND F2_SERIE = PEDIDO.C5_SERIE " 
		 cQuery += " AND F2_CLIENTE = PEDIDO.C5_CLIENTE " 
		 cQuery += " AND F2_LOJA = PEDIDO.C5_LOJACLI " 

	EndIf
	
	cQuery += " WHERE " 
	cQuery += " F2_FILIAL = '" + cFili + "' "

	//cQuery += " AND F2_DOC = '002341625' "
	
	//
	If nOpc == 2
		cQuery += " AND F2_XSFENVC <> '2' "
		cQuery += " AND F2_XSALES <> '' "
		
	EndIf

	//
	If ! Empty(cParamBsc)
		cQuery += " AND RTRIM(LTRIM(F2_DOC)) + RTRIM(LTRIM(F2_SERIE)) = '" + cParamBsc + "' " 

	EndIf
	
	//
	If ! Empty(cExpSql)
		cQuery += cExpSql + Iif(nOpc == 1," AND F2_XSALES = '' ","")
	
	EndIf
	
	//
	If !lCancelada
		cQuery += " AND SF2.D_E_L_E_T_ = '' " 
		
		//
		If IsInCallStack("ADVEN083P") .And. nOpc == 1
			cQuery += " AND F2_XSALES = '' "
		
		EndIf
	
	EndIf

	cQuery += " ORDER BY F2_DOC, F2_SERIE " 
	
Return cQuery
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �itemNEnv     �Autor  �Everson        � Data �  11/06/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para enviar os itens n�o processados para SalesForce.���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function itemNEnv(lAut,aResponse)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aArea	:= GetArea()
	
	//
	Conout("In�cio ADVEN074P - Corre��o envio de itens notas fiscais de sa�da.")
	
	//
	envItens("",lAut,"",aResponse)
	
	//
	Conout("Fim ADVEN074P - Corre��o envio de itens notas fiscais de sa�da.")
	
	//
	RestArea(aArea)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �envItens     �Autor  �Everson        � Data �  05/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para enviar os itens da nota fiscal de sa�da.        ���
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
	//Local lLogin	:= .F.
	Local cQuery	:= ""
	Local cServTab	:= "/services/data/v41.0/sobjects/Item_do_Faturamento__c/"
	Local cCmpChv	:= "CHVSF"
	Local cObjeto	:= "item nota fiscal sa�da"
	Local cChvExt	:= "Chave_Externa__c/"
	Local aRetOk	:= {}
	
	//
	cQuery := iscriptsql(cParamBsc)
	
	//Adiciona par�metros ao vetor.
	Aadd(aParametros,aResponse)
	Aadd(aParametros,"ADVEN074P")
	Aadd(aParametros,cQuery)
	Aadd(aParametros,lAut)
	Aadd(aParametros,cServTab)
	Aadd(aParametros,cCmpChv)
	Aadd(aParametros,cObjeto)
	Aadd(aParametros,"imontJson")
	Aadd(aParametros,cChvExt)
	Aadd(aParametros,.F.)
	
	//Processa os registros.
	If  ! lAut
		//Processa({|| Static Call(ADVEN075P,ProcessarB,@aParametros,,,@aRetOk) },"Aguarde","Processando registro(s) ...",.T.)
		//Processa({|| Static Call(ADVEN075P,ProcessarB,@aParametros,,"",@aRetOk,.F.,.T.,"",.T.,.F.) },"Aguarde","Processando registro(s) ...",.T.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		Processa({|| u_VEN075A4(@aParametros,,"",@aRetOk,.F.,.T.,"",.T.,.F.) },"Aguarde","Processando registro(s) ...",.T.)
		
	Else
		//Static Call(ADVEN075P,ProcessarB,@aParametros,,"",@aRetOk,.F.,.T.,"",.T.,.F.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A4( @aParametros,,"",@aRetOk,.F.,.T.,"",.T.,.F. )
		
	EndIf
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �imontJson     �Autor  �Everson     � Data �  15/01/2018     ���
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
	Local cPedSF	:= Alltrim(cValToChar(Posicione("SC5",1,xFilial("SC5") + (cNmAlias)->D2_PEDIDO   ,"C5_XPEDSAL")))
	Local cVend		:= ""
	Local cDtEmiPed	:= ""
	Local cUsr		:= ""
	Local cEnvMet	:= Upper(Alltrim(cValToChar(GetMv("MV_#SFEVFT"))))

	//		
	cJson += '{'
		cJson += '"method" : "' + cMetodo + '",'
		cJson += '"url" : ' + Iif(cMetodo == "POST",'"v41.0/sobjects/Item_do_Faturamento__c"', '"v41.0/sobjects/Item_do_Faturamento__c/' + cChvExt +  Alltrim(cValtoChar((cNmAlias)->CHVSF)) + '"') + ','
		cJson += '"richInput":{'
	
		//
		If cMetodo == "POST"
			
			cJson += '"Chave_Externa__c":"' + Alltrim(cValToChar((cNmAlias)->CHVSF)) + '",'
			
			cJson += '"Faturamento__r" : {'
				cJson += '"Chave_Externa__c" : "' + Alltrim(cValToChar((cNmAlias)->CHFAT)) + '"'
			cJson += '},'
		
		EndIf
		
/*		cJson += '"Faturamento__r" : {'
			cJson += '"Chave_Externa__c" : "' + Alltrim(cValToChar((cNmAlias)->CHFAT)) + '"'
		cJson += '},'*/
		
		//
		If ! Empty(cPedSF)
			cJson += '"Pedido__r" : {'
				cJson += '"Codigo_Protheus__c" : "' + Alltrim(cValToChar((cNmAlias)->D2_PEDIDO)) + '"'
			cJson += '},'
		
			cJson += '"Produto_do_pedido__r" : {'
				cJson += '"Chave_Externa__c" : "' + Alltrim(cValToChar((cNmAlias)->D2_PEDIDO)) + Alltrim(cValToChar((cNmAlias)->D2_COD)) + '"'
			cJson += '},'
		
		Else
			
			cJson += '"Produto__r": {"Codigo__c": "' + Alltrim(cValToChar((cNmAlias)->D2_COD)) + '"},'
		
		EndIf
		
		//
		If ! Empty(cPedSF) .And. cEnvMet == "S"
			
			cVend		:= Alltrim(cValToChar(Posicione("SC5",1,xFilial("SC5") + (cNmAlias)->D2_PEDIDO   ,"C5_VEND1")))
			cVend		:= Alltrim(cValToChar(Posicione("SA3",1, xFilial("SA3") + cVend, "A3_XAGRSF" )))
			If Empty(cVend)
				cVend		:= Alltrim(cValToChar(Posicione("SC5",1,xFilial("SC5") + (cNmAlias)->D2_PEDIDO   ,"C5_VEND1")))
				
			EndIF
			
			cDtEmiPed	:= Alltrim(DToS(Posicione("SC5",1,xFilial("SC5") + (cNmAlias)->D2_PEDIDO   ,"C5_EMISSAO")))
			cDtEmiPed	:= Substr(cDtEmiPed,1,4) + "-" + Substr(cDtEmiPed,5,2) + "-" + Substr(cDtEmiPed,7,2)
			cUsr		:= Alltrim(cValToChar(Posicione("SA3",1,xFilial("SA3") + cVend  ,"A3_CODUSR")))
		
			cJson += '"Meta_Vendedor__r" : {'
				cJson += '"Chave_Externa__c" : "' + cVend + Alltrim(cValToChar((cNmAlias)->D2_COD)) + cDtEmiPed +  '"'
			cJson += '},'
		
		EndIf
		
		//cJson += '"ICMS__c" : "'           + Alltrim(cValToChar((cNmAlias)->D2_VALICM)) + '",
		cJson += '"ICMS__c" : "'           + Alltrim(cValToChar((cNmAlias)->D2_PICM))   + '",
		cJson += '"Quantidade__c" : "'     + Alltrim(cValToChar((cNmAlias)->D2_QUANT))  + '",'
		cJson += '"Preco_Unitario__c" : "' + Alltrim(cValToChar((cNmAlias)->D2_PRCVEN)) + '",'
		cJson += '"Valor_Total__c" : "'    + Alltrim(cValToChar((cNmAlias)->D2_TOTAL))  + '"'
		
		cJson += '}'
		
	cJson += '},'
		
Return cJson
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �iscriptSql     �Autor  �Everson      � Data �  15/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Script sql para consulta itens.                             ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function iscriptSql(cParamBsc)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local cQuery := ""

	Conout("ADVEN074P scriptSql script SD2")	

	//
	cParamBsc := Alltrim(cValToChar(cParamBsc))

	//
	If ! Empty(cParamBsc)
		cQuery := ""
		cQuery += " SELECT " 
		cQuery += " 'SD2' AS TAB,'S' + '" + cEmpC + "' + RTRIM(LTRIM(D2_FILIAL)) + RTRIM(LTRIM(D2_DOC)) +  RTRIM(LTRIM(D2_SERIE)) + RTRIM(LTRIM(D2_CLIENTE)) + RTRIM(LTRIM(D2_LOJA)) + RTRIM(LTRIM(D2_COD)) + RTRIM(LTRIM(D2_ITEM)) AS CHVSF, "
		cQuery += " 'S' + '" + cEmpC + "' + RTRIM(LTRIM(D2_FILIAL)) + RTRIM(LTRIM(D2_CLIENTE)) + RTRIM(LTRIM(D2_LOJA)) + RTRIM(LTRIM(D2_DOC)) +  RTRIM(LTRIM(D2_SERIE)) AS CHFAT, "
		cQuery += " D2_FILIAL, D2_PEDIDO, D2_CLIENTE, D2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_DOC, D2_SERIE, D2_ITEM, D2_VALICM, D2_BASEICM, D2_PICM, D2_XIDSF AS IDSALES " 
		cQuery += " FROM " 
		cQuery += " SD2" + cEmpC + "0 (NOLOCK) AS SD2 " 
		cQuery += " WHERE " 
		cQuery += " SD2.D_E_L_E_T_ = '' " 
		cQuery += " AND D2_FILIAL = '" + cFiliC + "' " 
		cQuery += " AND ( 'S' + '" + cEmpC + "' + RTRIM(LTRIM(D2_FILIAL)) + RTRIM(LTRIM(D2_CLIENTE)) + RTRIM(LTRIM(D2_LOJA)) + RTRIM(LTRIM(D2_DOC)) +  RTRIM(LTRIM(D2_SERIE)) ) = '" + Alltrim(cValToChar(cParamBsc)) + "' " 
		
	Else
		cQuery := ""
		cQuery += " SELECT  " 
		cQuery += " 'SD2' AS TAB,'S' + '" + cEmpC + "' + RTRIM(LTRIM(D2_FILIAL)) + RTRIM(LTRIM(D2_DOC)) +  RTRIM(LTRIM(D2_SERIE)) + RTRIM(LTRIM(D2_CLIENTE)) + RTRIM(LTRIM(D2_LOJA)) + RTRIM(LTRIM(D2_COD)) + RTRIM(LTRIM(D2_ITEM)) AS CHVSF, "
		cQuery += " 'S' + '" + cEmpC + "' + RTRIM(LTRIM(D2_FILIAL)) + RTRIM(LTRIM(D2_CLIENTE)) + RTRIM(LTRIM(D2_LOJA)) + RTRIM(LTRIM(D2_DOC)) +  RTRIM(LTRIM(D2_SERIE)) AS CHFAT, "
		cQuery += " D2_FILIAL, D2_PEDIDO, D2_CLIENTE, D2_LOJA, D2_COD, D2_QUANT, D2_PRCVEN, D2_TOTAL, D2_DOC, D2_SERIE, D2_ITEM, D2_VALICM, D2_BASEICM, D2_PICM, D2_XIDSF AS IDSALES " 
		cQuery += " FROM " 
		cQuery += " SD2" + cEmpC + "0 (NOLOCK) AS SD2 " 
		cQuery += " INNER JOIN " 
		cQuery += " SF2" + cEmpC + "0 (NOLOCK) AS SF2 " 
		cQuery += " ON F2_FILIAL = D2_FILIAL " 
		cQuery += " AND F2_DOC = D2_DOC " 
		cQuery += " AND F2_SERIE = D2_SERIE " 
		cQuery += " WHERE " 
		cQuery += " SD2.D_E_L_E_T_ = '' " 
		cQuery += " AND SF2.D_E_L_E_T_ = '' " 
		cQuery += " AND F2_XSALES <> '' " 
		cQuery += " AND D2_XIDSF = '' " 
		cQuery += " AND DATEDIFF(DAY,F2_EMISSAO,GETDATE()) <= 2 " 
		cQuery += " AND D2_FILIAL = '" + cFiliC + "' " 	
		cQuery += " ORDER BY D2_DOC "
		
	EndIf
	
Return cQuery
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �mrkReg         �Autor  �Everson      � Data �  13/02/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para marcar o registro como j� enviado ao SalesForce.���
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
	//Local cUpdate := ""
	Local lErro   := .T.
	Local cMsg	  := ""
	Local cChaveB := ""
	
	//Remove Marca de nota de sa�da e c�digo da empresa.
	cChave := Alltrim(cValToChar(cChave))
	cId    := Alltrim(cValToChar(cId))
	
	//
	If Empty(cId) .And. ! lMrkCanc
		Return Nil
	
	EndIf
	
	//Everson, 23/09/2021, Chamado 44817
	If lMrkCanc
		cChaveB:= (cAliasS)->F2_FILIAL + (cAliasS)->F2_CLIENTE + (cAliasS)->F2_LOJA + (cAliasS)->F2_DOC +  (cAliasS)->F2_SERIE
		Conout('ADVEN074P mrkReg lMrkCanc')
		DbSelectArea("SF2")
		SF2->(DbSetOrder(2))
		If SF2->(DbSeek(cChaveB))
			If RecLock("SF2",.F.)
				SF2->F2_XSFENVC := '2'
				MsUnlock("SF2")
				
				lErro := .F.
				Conout('ADVEN074P mrkReg lMrkCanc OK')
				
			EndIf

		EndIf
		//cUpdate := "UPDATE SF2" + cEmpC + "0 SET F2_XSFENVC = '2' WHERE ( 'S' + '" + cEmpC + "' + '" + cFiliC + "' + RTRIM(LTRIM(F2_CLIENTE)) + RTRIM(LTRIM(F2_LOJA)) + RTRIM(LTRIM(F2_DOC)) +  RTRIM(LTRIM(F2_SERIE)) ) = '" + cChave + "' "
		//Conout("Envio de cancelamento NF sa�da " + cChave )
		
	ElseIf Alltrim(cValToChar((cAliasS)->TAB)) == "SF2"
		cChaveB:= (cAliasS)->F2_FILIAL + (cAliasS)->F2_CLIENTE + (cAliasS)->F2_LOJA + (cAliasS)->F2_DOC +  (cAliasS)->F2_SERIE
		Conout('ADVEN074P mrkReg Alltrim(cValToChar((cAliasS)->TAB)) == "SF2"')
		DbSelectArea("SF2")
		SF2->(DbSetOrder(2))
		If SF2->(DbSeek(cChaveB))
			If RecLock("SF2",.F.)
				SF2->F2_XSALES := cId
				MsUnlock("SF2")
				
				lErro := .F.
				Conout('ADVEN074P mrkReg Alltrim(cValToChar((cAliasS)->TAB)) == "SF2" >>> OK')

			EndIf

		EndIf
		//cUpdate := "UPDATE SF2" + cEmpC + "0 SET F2_XSALES = '" + cId + "' WHERE D_E_L_E_T_ = '' AND ( 'S' + '" + cEmpC + "' + '" + cFiliC + "' + RTRIM(LTRIM(F2_CLIENTE)) + RTRIM(LTRIM(F2_LOJA)) + RTRIM(LTRIM(F2_DOC)) +  RTRIM(LTRIM(F2_SERIE)) ) = '" + cChave + "' "
	
	ElseIf Alltrim(cValToChar((cAliasS)->TAB)) == "SD2"
		cChaveB := (cAliasS)->D2_FILIAL + (cAliasS)->D2_DOC + (cAliasS)->D2_SERIE + (cAliasS)->D2_CLIENTE + (cAliasS)->D2_LOJA + (cAliasS)->D2_COD + (cAliasS)->D2_ITEM
		Conout('Alltrim(cValToChar((cAliasS)->TAB)) == "SD2"')
		DbSelectArea("SD2")
		SD2->(DbSetOrder(3))
		If SD2->(DbSeek(cChaveB))
			If RecLock("SD2",.F.)
				SD2->D2_XIDSF := cId
				MsUnlock("SF2")
				
				lErro := .F.
				Conout('ADVEN074P mrkReg Alltrim(cValToChar((cAliasS)->TAB)) == "SD2" >>> OK')

			EndIf

		EndIf

		//cUpdate := "UPDATE SD2" + cEmpC + "0 SET D2_XIDSF = '" + cId + "' WHERE D_E_L_E_T_ = '' AND  ( 'S' + '" + cEmpC + "' + '" + cFiliC + "' + RTRIM(LTRIM(D2_DOC)) +  RTRIM(LTRIM(D2_SERIE)) + RTRIM(LTRIM(D2_CLIENTE)) + RTRIM(LTRIM(D2_LOJA)) + RTRIM(LTRIM(D2_COD)) + RTRIM(LTRIM(D2_ITEM))) = '" + cChave + "' "
		
	EndIf
	
	//Atualiza o registro na SF2.
	If lErro
		
		cMsg := "N�o foi poss�vel atualizar o registro " + cChave
		Conout('ADVEN074P mrkReg ' + cMsg)
		If !lAut
			MsgAlert(cMsg,"Fun��o mrkReg (ADVEN074P)")
			
		Else
			//Static Call(ADVEN075P,envErros,cMsg + "Fun��o mrkReg (ADVEN074P)")
			//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
			u_VEN075A2( cMsg + "Fun��o mrkReg (ADVEN074P)" )
		EndIf	
		
	EndIF
	
Return Nil
