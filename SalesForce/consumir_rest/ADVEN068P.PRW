#Include "Totvs.ch"
#Include "Restful.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADVEN068P      �Autor  �Everson      � Data �  22/12/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para envio de cadastro de usu�rios ao SalesForce.    ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADVEN068P(cDe,cAte,lAut,cExpSql,lSA3,lZC4) // U_ADVEN068P("000001","000001",.F.,"",.T.,.F.) U_ADVEN068P("","",.F.," AND A3_NIVETAB = '4' ")

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local aArea   	:= GetArea()

	Default cDe 	:= ""
	Default lAut	:= .F.
	Default cExpSql	:= ""
	Default lSA3	:= .T.
	Default lZC4	:= .F.

	Private lSA3c	:= lSA3
	Private lZC4c	:= lZC4

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Fun��o para envio de cadastro de usu�rios ao SalesForce.')

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
���Programa  �Processar      �Autor  �Everson      � Data �  22/12/2017   ���
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
	Local lLogin	:= .F.
	Local cQuery	:= ""
	Local cServTab	:= "/services/data/v41.0/sobjects/User/"
	Local cCmpChv	:= "CHVSF"
	Local cObjeto	:= "usu�rio"
	Local cChvExt	:= "Code__c/"
	Local cMsg		:= ""

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
	Aadd(aParametros,"ADVEN068P")
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

		//Processa({|| Static Call(ADVEN075P,ProcessarB,@aParametros,.F.,"PATCH",{},.F.,.T.,"",.T.,.F.) },"Aguarde","Processando registro(s) ...",.T.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		Processa({|| u_VEN075A4( @aParametros,.F.,"PATCH",{},.F.,.T.,"",.T.,.F.) },"Aguarde","Processando registro(s) ...",.T.)


	Else
		//Static Call(ADVEN075P,ProcessarB,@aParametros,.F.,"PATCH",{},.F.,.T.,"",.T.,.F.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_VEN075A4( @aParametros,.F.,"PATCH",{},.F.,.T.,"",.T.,.F. )
		//Static Call(ADVEN075P,ProcessarB,@aParametros,.F.,"PATCH",{})

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
	Local aArea		:= GetArea()
	Local cJson	 	:= ""
	Local cAliasTab	:= cNmAlias
	Local cDescCargo:= ""
	Local cProfile	:= ""
	Local cPapel	:= ""

	Local cCodUsuario:= ""
	Local cSuperv   := ""
	Local cSupervi  := ""
	Local cGerent   := ""
	Local cGerente  := ""
	Local cDireto   := ""
	Local cDiretor  := ""

	//
	cJson := ""
	cJson += '{'

	If lSA3c // Base tabela SA3 - Cadastro de vendedores.

		cJson += '"method" : "' + cMetodo + '",'
		cJson += '"url" : ' + Iif(cMetodo == "POST",'"v41.0/sobjects/User"', '"v41.0/sobjects/User/' + cChvExt +  Alltrim(cValtoChar((cAliasTab)->CHVSF)) + '"') + ','
		cJson += '"richInput":{'

		//
		If cMetodo == "POST"

			cJson += '"Code__c":"' + Alltrim(cValToChar((cAliasTab)->A3_CODUSR)) + '", '

		EndIf

		cJson += '"Username" : "'  + Alltrim(cValToChar((cAliasTab)->A3_XLOGSF)) + '",'

		cJson += '"Codigo_Vendedor__c" : "' + Alltrim(cValToChar((cAliasTab)->A3_COD)) + '",'

		//
		DbSelectArea("SA3")
		cCodUsuario := Alltrim(cValToChar((cAliasTab)->A3_COD))

		//
		If Alltrim(cValToChar((cAliasTab)->A3_XCARGSF)) == "1"     //.And. Alltrim(cValToChar((cAliasTab)->A3_CODUSR)) <> cSupervi  //.And. (cSupervi <> cCodUsuario) //Vendedor.

			cSuperv  := Posicione("SA3",1,xFilial("SA3") + cCodUsuario,"A3_SUPER")
			cSupervi := supSA3(cSuperv)
			If Alltrim(cValToChar((cAliasTab)->A3_CODUSR)) <> cSupervi
				cJson += '"Manager":{ "Code__c":"' + cSupervi + '" },'

			EndIf

		ElseIf Alltrim(cValToChar((cAliasTab)->A3_XCARGSF)) == "2" //.And. Alltrim(cValToChar((cAliasTab)->A3_CODUSR)) <> cGerente  //.And. (cGerente <> cCodUsuario) //Supervisor.

			cGerent  := Posicione("SA3",1,xFilial("SA3") + cCodUsuario,"A3_GEREN")
			cGerente := supSA3(cGerent)
			If Alltrim(cValToChar((cAliasTab)->A3_CODUSR)) <> cGerente
				cJson += '"Manager":{ "Code__c":"' + cGerente + '" },'

			EndIf

		ElseIf Alltrim(cValToChar((cAliasTab)->A3_XCARGSF)) == "3"  //.And. Alltrim(cValToChar((cAliasTab)->A3_CODUSR)) <> cDiretor //.And. (cDireto <> cCodUsuario) //Gerente.

			cDireto  := Posicione("SA3",1,xFilial("SA3") + cCodUsuario,"A3_XDIRET")
			cDiretor := supSA3(cDireto)
			If Alltrim(cValToChar((cAliasTab)->A3_CODUSR)) <> cDiretor
				cJson += '"Manager":{ "Code__c":"' + cDiretor + '" },'

			EndIf

		ElseIf Alltrim(cValToChar((cAliasTab)->A3_XCARGSF)) == "4"  //.And. Alltrim(cValToChar((cAliasTab)->A3_CODUSR)) <> cDiretor //.And. (cDireto <> cCodUsuario) //Diretor.

			cDireto  := Posicione("SA3",1,xFilial("SA3") + cCodUsuario,"A3_XDIRET")
			cDiretor := supSA3(cDireto)
			If Alltrim(cValToChar((cAliasTab)->A3_CODUSR)) <> cDiretor
				cJson += '"Manager":{ "Code__c":"' + cDiretor + '" },'

			EndIf

		EndIf

		//
		cDescCargo := ""
		If Alltrim(cValToChar((cAliasTab)->A3_XCARGSF)) == "1"
			cDescCargo := " - Vendedor"

		ElseIf Alltrim(cValToChar((cAliasTab)->A3_XCARGSF)) == "2"
			cDescCargo := " - Supervisor"

		ElseIf Alltrim(cValToChar((cAliasTab)->A3_XCARGSF)) == "3"
			cDescCargo := " - Gerente"

		ElseIf Alltrim(cValToChar((cAliasTab)->A3_XCARGSF)) == "4"
			cDescCargo := " - Diretor"

		EndIf

		//
		cProfile := Alltrim(cValToChar(Posicione("SX5",1,xFilial("SX5") + "ZG" + Alltrim(cValToChar((cAliasTab)->A3_XSFPERF)), "X5_DESCRI" )))
		cJson += '"Profile" : {"Name" : "' + cProfile + '"},'
		cPapel   := Alltrim(cValToChar(Posicione("SX5",1,xFilial("SX5") + "ZH" + Alltrim(cValToChar((cAliasTab)->A3_XSFPAPE)), "X5_DESCRI" )))
		cJson += '"UserRole" : {"Name" : "' + cPapel + '"},'
		cJson += '"Cargo__c":"'+ Alltrim(cValToChar((cAliasTab)->A3_XCARGSF)) + cDescCargo + '",'
		cJson += '"Email" : "'     + Alltrim(cValToChar((cAliasTab)->A3_EMAIL)) + '",'
		cJson += '"FirstName" : "' + Alltrim(cValToChar((cAliasTab)->A3_COD)) + '",'
		cJson += '"LastName" : "'  + Alltrim(cValToChar((cAliasTab)->A3_XNFSF)) + '",'
		cJson += '"Alias" : "'     + Alltrim(cValToChar((cAliasTab)->A3_COD)) + 'AD",'
		cJson += '"Department":"Comercial",'
		cJson += '"Phone":"",'
		cJson += '"IsActive": ' + Iif(Alltrim(cValToChar((cAliasTab)->A3_XBLQSF)) == "2","false","true") +  ','
		cJson += '"TimeZoneSidKey" : "America/Sao_Paulo",'
		cJson += '"LocaleSidKey" : "pt_BR",'
		cJson += '"EmailEncodingKey" : "ISO-8859-1",'
		cJson += '"LanguageLocaleKey" : "pt_BR",'
		cJson += '"CompanyName":"Adoro S.A.",'
		cJson += '"Ramal_usuario_pabx__c":"' + Alltrim(cValTochar((cAliasTab)->A3_XSFRAMA)) + '",'
		cJson += '"Codigo_usuario_leucotron__c":"' + Alltrim(cValTochar((cAliasTab)->A3_XCODLEU)) + '"'

		cJson += '}'

	ElseIf lZC4c //Base tabela ZC4 - Usu�rios SalesForce.

		cJson += '"method" : "' + cMetodo + '",'
		cJson += '"url" : ' + Iif(cMetodo == "POST",'"v41.0/sobjects/User"', '"v41.0/sobjects/User/' + cChvExt +  Alltrim(cValtoChar((cAliasTab)->CHVSF)) + '"') + ','
		cJson += '"richInput":{'

		//
		If cMetodo == "POST"

			cJson += '"Code__c":"' + Alltrim(cValToChar((cAliasTab)->ZC4_CODUSR)) + '", '

		EndIf

		cJson += '"Username" : "'  + Alltrim(cValToChar((cAliasTab)->ZC4_LOGSF)) + '",'
		cJson += '"Codigo_Vendedor__c" : "",'

		//
		If ! Empty(Alltrim(cValToChar((cAliasTab)->ZC4_SUPER)))
			DbSelectArea("SA3")
			cCodUsuario := Alltrim(cValToChar((cAliasTab)->ZC4_COD))
			cSuperv    := Posicione("ZC4",1,xFilial("ZC4") + cCodUsuario,"ZC4_SUPER")
			cSupervi   := Posicione("SA3",1,xFilial("SA3") + cSuperv    ,"A3_CODUSR")

		ElseIf ! Empty(Alltrim(cValToChar((cAliasTab)->ZC4_GEREN)))
			cSupervi :=  Posicione("SA3",1,xFilial("SA3") + Alltrim(cValToChar((cAliasTab)->ZC4_GEREN))  ,"A3_CODUSR")//"001103" // Alltrim(cValToChar((cAliasTab)->ZC4_GEREN))

		Else
			cSupervi := Posicione("SA3",1,xFilial("SA3")  + Alltrim(cValToChar((cAliasTab)->ZC4_XDIRET)) ,"A3_CODUSR") //"001103" // Alltrim(cValToChar((cAliasTab)->ZC4_XDIRET))

		EndIf

		//
		If cSupervi <> Alltrim(cValToChar((cAliasTab)->ZC4_CODUSR))
			cJson += '"Manager":{ "Code__c":"' + cSupervi + '" },'

		EndIf

		//
		cDescCargo := ""
		If Alltrim(cValToChar((cAliasTab)->ZC4_NIVETA)) == "5"
			cDescCargo := " - Promotor"

		ElseIf Alltrim(cValToChar((cAliasTab)->ZC4_NIVETA)) == "6"
			cDescCargo := " - Administracao"

		EndIf

		cProfile := Alltrim(cValToChar(Posicione("SX5",1,xFilial("SX5") + "ZG" + Alltrim(cValToChar((cAliasTab)->ZC4_SFPERF)), "X5_DESCRI" )))
		cJson += '"Profile" : {"Name" : "' + cProfile + '"},'
		cPapel   := Alltrim(cValToChar(Posicione("SX5",1,xFilial("SX5") + "ZH" + Alltrim(cValToChar((cAliasTab)->ZC4_SFPAPE)), "X5_DESCRI" )))
		cJson += '"UserRole" : {"Name" : "' + cPapel + '"},'
		cJson += '"Cargo__c":"'+ Alltrim(cValToChar((cAliasTab)->ZC4_NIVETA)) + cDescCargo + '",'
		cJson += '"Email" : "'     + Alltrim(cValToChar((cAliasTab)->ZC4_EMAIL)) + '",'
		cJson += '"FirstName" : "' + Alltrim(cValToChar((cAliasTab)->ZC4_COD)) + '",'
		cJson += '"LastName" : "'  + Alltrim(cValToChar((cAliasTab)->ZC4_NREDUZ)) + '",'
		cJson += '"Alias" : "'     + Alltrim(cValToChar((cAliasTab)->ZC4_COD)) + 'AD",'
		cJson += '"Department":"' + cValToChar(obterDepart( Val(cValToChar((cAliasTab)->ZC4_DEPART)),"ZC4_DEPART" )) + '",' // <<<<<<<< Definir
		cJson += '"Phone":"",'
		cJson += '"IsActive": ' + Iif(Alltrim(cValToChar((cAliasTab)->ZC4_BLQSF)) == "2","false","true") +  ',' //
		cJson += '"TimeZoneSidKey" : "America/Sao_Paulo",'
		cJson += '"LocaleSidKey" : "pt_BR",'
		cJson += '"EmailEncodingKey" : "ISO-8859-1",'
		cJson += '"LanguageLocaleKey" : "pt_BR",'
		cJson += '"CompanyName":"Adoro S.A."'

		cJson += '}'

	EndIf

	cJson += '},'

	//
	SA3->(DbCloseArea())

	//
	RestArea(aArea)

Return cJson
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �supSA3        �Autor  �Everson      � Data �  03/04/2018    ���
�������������������������������������������������������������������������͹��
���Desc.     �Obt�m o c�digo de usu�rio do superior.                      ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function supSA3(cCod)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local aArea	 := GetArea()
	Local cQuery := ""
	Local cUsrSup:= ""

	//
	cCod := Alltrim(cValToChar(cCod))

	//
	cQuery += " SELECT "
	cQuery += " CASE WHEN A3_XAGRSF = '' OR A3_XAGRSF IS NULL THEN A3_CODUSR ELSE MANAGER.USRM END AS USRM "
	cQuery += " FROM "
	cQuery += " " + RetSqlName("SA3") + " AS SA3 "
	cQuery += " LEFT OUTER JOIN "
	cQuery += " (SELECT A3_COD AS CODM, A3_CODUSR AS USRM FROM " + RetSqlName("SA3") + " AS SA3 WHERE SA3.D_E_L_E_T_ = '') AS MANAGER ON "
	cQuery += " A3_XAGRSF = MANAGER.CODM "
	cQuery += " WHERE "
	cQuery += " SA3.D_E_L_E_T_ = '' "
	cQuery += " AND A3_COD = '" + cCod + "' "

	//
	If Select("D_MANAGER") > 0
		D_MANAGER->(DbCloseArea())

	EndIf

	//
	TcQuery cQuery New Alias "D_MANAGER"
	DbSelectArea("D_MANAGER")
	cUsrSup := Alltrim(cValToChar(D_MANAGER->USRM))
	D_MANAGER->(DbCloseArea())

	//
	RestArea(aArea)

Return cUsrSup
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �obterDepart   �Autor  �Everson      � Data �  21/03/2018    ���
�������������������������������������������������������������������������͹��
���Desc.     �Obtem departamento.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function obterDepart(nOPc,cCampo)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local cConteudo := ""
	Local aDepart	:= ""
	Local cDepart	:= ""

	//
	If nOPc <= 0
		RestArea(aArea)
		Return cDepart

	EndIf

	//
	DbSelectArea('SX3')
	SX3->(DbSetOrder(2))
	If SX3->(DbSeek(cCampo))

		cConteudo := X3CBox()

		//
		If !Empty(cConteudo)
			aDepart := StrToKarr(cConteudo,";")
			cDepart := aDepart[nOPc]
			cDepart := Alltrim(cValToChar(StrTran(cDepart, cValToChar(nOPc)+"=","")))

		EndIf

	EndIf

	//
	RestArea(aArea)

Return cDepart
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
Static Function scriptSql(cDe,cAte,cExpSql)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local cQuery := ""

	//
	cDe 	:= Alltrim(cValToChar(cDe))
	cAte	:= Alltrim(cValToChar(cAte))
	cExpSql	:= Alltrim(cValToChar(cExpSql))

	//
	If lSA3c
		cQuery := ""
		cQuery += " SELECT A3_CODUSR AS CHVSF, A3_COD, A3_CODUSR, A3_NIVETAB, A3_NOME, A3_MSBLQL, A3_XSFRAMA, A3_XCODLEU, A3_EMAIL, A3_XSFPERF, A3_XSFPAPE, A3_XIDSF AS IDSALES, A3_NREDUZ, A3_XNFSF, A3_XCARGSF, A3_XLOGSF, A3_XBLQSF  "
		cQuery += " FROM "
		cQuery += " " + RetSqlName("SA3") + " (NOLOCK) AS SA3 "
		cQuery += " WHERE "
		cQuery += " SA3.D_E_L_E_T_ = '' "
		cQuery += " AND A3_XSALES = '2' "
		cQuery += " AND A3_EMAIL NOT IN ('','.') "
		cQuery += " AND A3_COD <> '' "
		cQuery += " AND A3_CODUSR <> '' "
		cQuery += " AND A3_XCARGSF <> '' "
		cQuery += " AND A3_XSFPERF <> '' "
		cQuery += " AND A3_XSFPAPE <> '' "
		cQuery += " AND ((A3_COD = A3_XAGRSF) OR (A3_XAGRSF = '')) "

		//
		If ! Empty(cAte)
			cQuery += " AND A3_COD >= '" + cDe + "' "
			cQuery += " AND A3_COD <= '" + cAte + "' "

		EndIf

		//
		If ! Empty(cExpSql)
			cQuery += cExpSql

		EndIf

		cQuery += " ORDER BY A3_XCARGSF DESC, A3_CODUSR "

	ElseIf lZC4c //Base tabela ZC4 - Usu�rios SalesForce.

		cQuery += " SELECT "
		cQuery += " ZC4_CODUSR AS CHVSF , ZC4_CODUSR, ZC4_NIVETA, ZC4_SFPERF, ZC4_NOME, ZC4_COD, ZC4_MSBLQL, ZC4_SFPAPE, ZC4_DEPART, ZC4_EMAIL, ZC4_IDSF AS IDSALES, ZC4_SUPER, ZC4_GEREN, ZC4_XDIRET, ZC4_NREDUZ, ZC4_LOGSF, ZC4_BLQSF "
		cQuery += " FROM "
		cQuery += " " + RetSqlName("ZC4") + " AS ZC4 (NOLOCK) "
		cQuery += " WHERE "
		cQuery += " ZC4.D_E_L_E_T_ = '' "
		cQuery += " AND ZC4_CODUSR <> '' "
		cQuery += " AND ZC4_COD    <> '' "
		cQuery += " AND ZC4_NIVETA <> '' "
		cQuery += " AND ZC4_SALES = '2' "
		cQuery += " AND ZC4_SFPERF <> '' "
		cQuery += " AND ZC4_SFPAPE <> '' "

		If ! Empty(cAte)
			cQuery += " AND ZC4_COD >= '" + cDe + "' "
			cQuery += " AND ZC4_COD <= '" + cAte + "' "

		EndIf

		//
		If ! Empty(cExpSql)
			cQuery += cExpSql

		EndIf

		cQuery += " ORDER BY ZC4_COD "

	EndIf

Return cQuery
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �mrkReg         �Autor  �Everson      � Data �  21/03/2018   ���
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
	If lSA3c
		cUpdate := " UPDATE " + RetSqlName("SA3") + " SET A3_XIDSF = '" + cId + "' WHERE D_E_L_E_T_ = '' AND A3_CODUSR = '" + cChave + "' "

	ElseIf lZC4c
		cUpdate := " UPDATE " + RetSqlName("ZC4") + " SET ZC4_IDSF = '" + cId + "' WHERE D_E_L_E_T_ = '' AND ZC4_CODUSR = '" + cChave + "' "

	EndIf

	//Atualiza o registro.
	If TCSqlExec(cUpdate) < 0

		cMsg := "N�o foi poss�vel atualizar o registro " + cChave + Chr(13) + Chr(10) + "TCSQLError() " + TCSQLError()
		If !lAut
			MsgAlert(cMsg,"Fun��o mrkReg (ADVEN068P)")

		Else
			//Static Call(ADVEN075P,envErros,cMsg + "Fun��o mrkReg (ADVEN068P)")
			//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
			u_VEN075A2( cMsg + "Fun��o mrkReg (ADVEN068P)" )

		EndIf

	EndIf

Return Nil
