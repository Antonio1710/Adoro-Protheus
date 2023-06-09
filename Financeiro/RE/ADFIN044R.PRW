#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADFIN044R  � Autor � Everson           � Data �  30/10/17   ���
�������������������������������������������������������������������������͹��
���Descricao �Relat�rio de tarifas banc�rias.                             ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037320.                                            ���
�������������������������������������������������������������������������ͼ��
���Adriana     �24/05/2019�TI-Devido a substituicao email para shared     ���
���            �          �relay, substituido MV_RELACNT p/ MV_RELFROM    ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADFIN044R() // U_ADFIN044R()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������	
	Local cEmp 		:= "01"
	Local cFil 		:= "02"
	
	//Inicia o ambiente.
	RPCClearEnv()
	RPCSetType(3)
	RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{ })
	
	// Garanto uma �nica thread sendo executada - // Adoro - Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - fwnm - 29/06/2020
	If !LockByName("ADFIN044R", .T., .F.)
		ConOut("[ADFIN044R] - Existe outro processamento sendo executado! Verifique...")
		RPCClearEnv()
		Return
	EndIf

	logZBN("1")

	//	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	//FWMonitorMsg(ALLTRIM(PROCNAME()))
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relat�rio de tarifas banc�rias.')

	procRel()
    	
    logZBN("2")
	
	//Fecha o ambiente.
	RpcClearEnv()

	//��������������������������������������?
	//�Destrava a rotina para o usu�rio	    ?
	//��������������������������������������?
	UnLockByName("ADFIN044R")

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADFIN044R  � Autor � Everson           � Data �  30/10/17   ���
�������������������������������������������������������������������������͹��
���Descricao �Gera eelat�rio de tarifas banc�rias.                        ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037320.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function procRel()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������	
	Local cQuery   := ""
	Local cAssunto := "Tarifa banc�ria"
	Local email	   := GetMv("MV_#EMTARI")
	Local cMensagem:= ""
	Local nAux	   := 0
	
	//
	cQuery := scriptSql()
	
	//
	If Select("DADOS") > 0
		DADOS->(DbCloseArea())
		
	EndIf
	
	//
	cMensagem += '<html>'
	cMensagem += '<body>'
	cMensagem += '<p style="color:red">Seguem abaixo tarifas banc�rias com diverg�ncia.</p>'
	cMensagem += '<hr>'
	cMensagem += '<table border="1">'
	cMensagem += '<tr style="background-color: black;color:white">'
	cMensagem += '<td>Empresa</td>'
	cMensagem += '<td>Filial</td>'
	cMensagem += '<td>Cod. Tarifa</td>'
	cMensagem += '<td>Tarifa</td>'
	cMensagem += '<td>Banco</td>'
	cMensagem += '<td>Agencia</td>'
	cMensagem += '<td>Conta</td>'
	cMensagem += '<td>Data</td>'
	cMensagem += '<td>Natureza</td>'
	cMensagem += '<td>Quantidade</td>'
	cMensagem += '<td>Vlr Total</td>'
	cMensagem += '<td>Vlr Unit</td>'
	cMensagem += '<td>Vlr Cadastro</td>'
	cMensagem += '<td>Diferen�a</td>'
	cMensagem += '<td>Dif. Total</td>'
	cMensagem += '</tr>'
	TcQuery cQuery New Alias "DADOS"
	DbSelectArea("DADOS")
	DADOS->(DbGoTop())
	While ! DADOS->(Eof())
		
		If Val(Transform(DADOS->DIFT     ,"@E 999,999,999.99")) <> 0 //Everson - 14/12/2017. Chamado 038693.
		
			nAux++
			
			cMensagem += '<tr>'
				
				cMensagem += '<td>' + cValToChar(DADOS->EMPRESA)    + '</td>'	
				cMensagem += '<td>' + cValToChar(DADOS->E5_FILIAL)  + '</td>'		
				cMensagem += '<td>' + cValToChar(DADOS->E5_XTARIFA) + '</td>'
				cMensagem += '<td>' + cValToChar(DADOS->ZC2_TARIFA) + '</td>'
				cMensagem += '<td>' + cValToChar(DADOS->ZC2_BANCO)  + '</td>'
				cMensagem += '<td>' + cValToChar(DADOS->ZC2_AGENCI) + '</td>'
				cMensagem += '<td>' + cValToChar(DADOS->ZC2_CONTA)  + '</td>'
				cMensagem += '<td>' + DToC(SToD(DADOS->E5_DATA))    + '</td>'
				cMensagem += '<td>' + cValToChar(DADOS->E5_NATUREZ) + '</td>'
				cMensagem += '<td align="right">' + Transform(DADOS->E5_XQTDTAR,"@E 999,999,999.99")  + '</td>'
				cMensagem += '<td align="right">' + Transform(DADOS->E5_VALOR  ,"@E 999,999,999.99")  + '</td>'
				cMensagem += '<td align="right">' + Transform(DADOS->VLR_UNIT  ,"@E 999,999,999.99")  + '</td>'
				cMensagem += '<td align="right">' + Transform(DADOS->ZC2_VALOR ,"@E 999,999,999.99")  + '</td>'
				cMensagem += '<td align="right">' + Transform(DADOS->DIF       ,"@E 999,999,999.99")  + '</td>'
				cMensagem += '<td align="right">' + Transform(DADOS->DIFT      ,"@E 999,999,999.99")  + '</td>'
			
			cMensagem += '</tr>'
		
		EndIf
		
		DADOS->(DbSkip())
		
	EndDo
	cMensagem += '</table>'
	cMensagem += '</body>'
	cMensagem += '</html>'
	
	DADOS->(DbCloseArea())
	
	//Enviar e-mail.
	If nAux > 0
		processarEmail(cAssunto,cMensagem,email)
	
	EndIf

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �scriptSql      �Autor  �Everson         �Data �  26/10/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     �Scrip sql.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado  037320.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function scriptSql()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������		
	Local cNaturezas:= GetMv("MV_#TARIFA")
	Local aNaturezas:= {}
	Local i			:= 1
	Local cNatFormat:= ""
	
	//
	If Empty(cNaturezas)
		conout("O par�metro MV_#TARIFA n�o est� preenchido - Fun��o ADFIN044R")
		Return Nil
		
	EndIf
	
	//
	aNaturezas := StrToKarr(cNaturezas,"/")
	For i := 1 To Len(aNaturezas)
	
		cNatFormat += "'" + Alltrim(cValToChar(aNaturezas[i])) + "',"
		
	Next i
	cNatFormat := Substr(cNatFormat,1,Len(cNatFormat)-1)
	
	//
	//Everson - 14/12/2017. Chamado 038693.
	cQuery := ""
	cQuery += " SELECT " 
	cQuery += " '01' AS EMPRESA,   " 
	cQuery += " E5_FILIAL,   " 
	cQuery += " E5_XTARIFA,   " 
	cQuery += " ZC2_TARIFA,   " 
	cQuery += " ZC2_BANCO,   " 
	cQuery += " ZC2_AGENCI,   " 
	cQuery += " ZC2_CONTA,   " 
	cQuery += " E5_DATA,   " 
	cQuery += " E5_NATUREZ,   " 
	cQuery += " E5_VALOR,   " 
	cQuery += " E5_XQTDTAR, " //Chamado: 038829 02/01/2018 - Fernando Sigoli  
	cQuery += " E5_VALOR/E5_XQTDTAR AS VLR_UNIT,   " 
	cQuery += " ZC2_VALOR,   " 
	cQuery += " ZC2_VALOR-(E5_VALOR/E5_XQTDTAR) AS DIF, ((ZC2_VALOR-(E5_VALOR/E5_XQTDTAR))*E5_XQTDTAR) AS DIFT   " 
	cQuery += " FROM   " 
	cQuery += " SE5010  AS SE5 WITH (NOLOCK)   " 
	cQuery += " LEFT OUTER JOIN   " 
	cQuery += " ZC2010 AS ZC2 WITH (NOLOCK)   " 
	cQuery += " ON E5_FILIAL = ZC2_FILIAL   " 
	cQuery += " AND E5_XTARIFA = ZC2_CODIGO   " 
	cQuery += " WHERE   " 
	cQuery += " SE5.D_E_L_E_T_ = ''   " 
	cQuery += " AND ZC2.D_E_L_E_T_ = ''   " 
	cQuery += " AND E5_NATUREZ IN ( " + cNatFormat + " )   " 
	cQuery += " AND E5_RECPAG = 'P'   " 
	cQuery += " AND E5_SITUACA NOT IN ('C','E','X')   " 
	cQuery += " AND E5_XTARIFA <> ''   " 
	cQuery += " AND E5_XQTDTAR > 0   " 
	cQuery += " AND ZC2_VALOR-(E5_VALOR/E5_XQTDTAR) <> 0   " 
	cQuery += "  " 
	cQuery += " UNION ALL " 
	cQuery += "  " 
	cQuery += " SELECT   " 
	cQuery += " '02' AS EMPRESA, " 
	cQuery += " E5_FILIAL,   " 
	cQuery += " E5_XTARIFA,   " 
	cQuery += " ZC2_TARIFA,   " 
	cQuery += " ZC2_BANCO,   " 
	cQuery += " ZC2_AGENCI,   " 
	cQuery += " ZC2_CONTA,   " 
	cQuery += " E5_DATA,   " 
	cQuery += " E5_NATUREZ,   " 
	cQuery += " E5_VALOR,   " 
	cQuery += " E5_XQTDTAR, "  //Chamado: 038829 02/01/2018 - Fernando Sigoli
	cQuery += " E5_VALOR/E5_XQTDTAR AS VLR_UNIT,   " 
	cQuery += " ZC2_VALOR,   " 
	cQuery += " ZC2_VALOR-(E5_VALOR/E5_XQTDTAR) AS DIF, ((ZC2_VALOR-(E5_VALOR/E5_XQTDTAR))*E5_XQTDTAR) AS DIFT   " 
	cQuery += " FROM   " 
	cQuery += " SE5020  AS SE5 WITH (NOLOCK)   " 
	cQuery += " LEFT OUTER JOIN   " 
	cQuery += " ZC2020 AS ZC2 WITH (NOLOCK)   " 
	cQuery += " ON E5_FILIAL = ZC2_FILIAL   " 
	cQuery += " AND E5_XTARIFA = ZC2_CODIGO   " 
	cQuery += " WHERE   " 
	cQuery += " SE5.D_E_L_E_T_ = ''   " 
	cQuery += " AND ZC2.D_E_L_E_T_ = ''   " 
	cQuery += " AND E5_NATUREZ IN ( " + cNatFormat + " )   " 
	cQuery += " AND E5_RECPAG = 'P'   " 
	cQuery += " AND E5_SITUACA NOT IN ('C','E','X')   " 
	cQuery += " AND E5_XTARIFA <> ''   " 
	cQuery += " AND E5_XQTDTAR > 0   " 
	cQuery += " AND ZC2_VALOR-(E5_VALOR/E5_XQTDTAR) <> 0   " 
	cQuery += "  " 
	cQuery += " UNION ALL " 
	cQuery += "  " 
	cQuery += " SELECT   " 
	cQuery += " '03' AS EMPRESA, " 
	cQuery += " E5_FILIAL,   " 
	cQuery += " E5_XTARIFA,   " 
	cQuery += " ZC2_TARIFA,   " 
	cQuery += " ZC2_BANCO,   " 
	cQuery += " ZC2_AGENCI,   " 
	cQuery += " ZC2_CONTA,   " 
	cQuery += " E5_DATA,   " 
	cQuery += " E5_NATUREZ,   " 
	cQuery += " E5_VALOR,   "  
	cQuery += " E5_XQTDTAR, " //Chamado: 038829 02/01/2018 - Fernando Sigoli 
	cQuery += " E5_VALOR/E5_XQTDTAR AS VLR_UNIT,   " 
	cQuery += " ZC2_VALOR,   " 
	cQuery += " ZC2_VALOR-(E5_VALOR/E5_XQTDTAR) AS DIF, ((ZC2_VALOR-(E5_VALOR/E5_XQTDTAR))*E5_XQTDTAR) AS DIFT   " 
	cQuery += " FROM   " 
	cQuery += " SE5030  AS SE5 WITH (NOLOCK)   " 
	cQuery += " LEFT OUTER JOIN   " 
	cQuery += " ZC2030 AS ZC2 WITH (NOLOCK)   " 
	cQuery += " ON E5_FILIAL = ZC2_FILIAL   " 
	cQuery += " AND E5_XTARIFA = ZC2_CODIGO   " 
	cQuery += " WHERE   " 
	cQuery += " SE5.D_E_L_E_T_ = ''   " 
	cQuery += " AND ZC2.D_E_L_E_T_ = ''   " 
	cQuery += " AND E5_NATUREZ IN ( " + cNatFormat + " )   " 
	cQuery += " AND E5_RECPAG = 'P'   " 
	cQuery += " AND E5_SITUACA NOT IN ('C','E','X')   " 
	cQuery += " AND E5_XTARIFA <> ''   " 
	cQuery += " AND E5_XQTDTAR > 0   " 
	cQuery += " AND ZC2_VALOR-(E5_VALOR/E5_XQTDTAR) <> 0   " 
	cQuery += "  " 
	cQuery += " UNION ALL " 
	cQuery += "  " 
	cQuery += " SELECT   " 
	cQuery += " '06' AS EMPRESA, " 
	cQuery += " E5_FILIAL,   " 
	cQuery += " E5_XTARIFA,   " 
	cQuery += " ZC2_TARIFA,   " 
	cQuery += " ZC2_BANCO,   " 
	cQuery += " ZC2_AGENCI,   " 
	cQuery += " ZC2_CONTA,   " 
	cQuery += " E5_DATA,   " 
	cQuery += " E5_NATUREZ,   " 
	cQuery += " E5_VALOR,   "  
	cQuery += " E5_XQTDTAR, " //Chamado: 038829 02/01/2018 - Fernando Sigoli
	cQuery += " E5_VALOR/E5_XQTDTAR AS VLR_UNIT,   " 
	cQuery += " ZC2_VALOR,   " 
	cQuery += " ZC2_VALOR-(E5_VALOR/E5_XQTDTAR) AS DIF, ((ZC2_VALOR-(E5_VALOR/E5_XQTDTAR))*E5_XQTDTAR) AS DIFT   " 
	cQuery += " FROM   " 
	cQuery += " SE5060  AS SE5 WITH (NOLOCK)   " 
	cQuery += " LEFT OUTER JOIN   " 
	cQuery += " ZC2060 AS ZC2 WITH (NOLOCK)   " 
	cQuery += " ON E5_FILIAL = ZC2_FILIAL   " 
	cQuery += " AND E5_XTARIFA = ZC2_CODIGO   " 
	cQuery += " WHERE   " 
	cQuery += " SE5.D_E_L_E_T_ = ''   " 
	cQuery += " AND ZC2.D_E_L_E_T_ = ''   " 
	cQuery += " AND E5_NATUREZ IN ( " + cNatFormat + " )   " 
	cQuery += " AND E5_RECPAG = 'P'   " 
	cQuery += " AND E5_SITUACA NOT IN ('C','E','X')   " 
	cQuery += " AND E5_XTARIFA <> ''   " 
	cQuery += " AND E5_XQTDTAR > 0   " 
	cQuery += " AND ZC2_VALOR-(E5_VALOR/E5_XQTDTAR) <> 0   " 
	
	cQuery += " ORDER BY EMPRESA, E5_FILIAL, "	
	cQuery += " ZC2_BANCO,   " 
	cQuery += " ZC2_AGENCI,  " 
	cQuery += " ZC2_CONTA,   " 
	cQuery += " E5_DATA      " //Chamado: 038829 02/01/2018 - Fernando Sigoli 
	

Return cQuery
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �processarEmail �Autor  �Everson         �Data �  26/10/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     �Configura��es de e-mail.     ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado  037320.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function processarEmail(cAssunto,cMensagem,email)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
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
	    
	    //Envia o e-mail.     
	    Send Mail From cFrom To cTo Subject cSubject Body cBody ATTACHMENT cAtach Result lOk  
	     
	    //Tratamento de erro no envio do e-mail.          
	    If !lOk
	       Get Mail Error cErrorMsg
	       ConOut("3 - " + cErrorMsg)
	       
	    EndIf
	    
	 Else
	    Get Mail Error cErrorMsg
	    ConOut("4 - " + cErrorMsg)
	    
	 EndIf
	 
	 If lOk
	    Disconnect Smtp Server
	    
	 EndIf
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �logZBN            � Autor � Everson � Data �  30/10/2017    ���
�������������������������������������������������������������������������͹��
���Descricao �Gera log na ZBN.                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037320.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function logZBN(cStatus)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local aArea	:= GetArea()
	
	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADFIN044R'))
	
		RecLock("ZBN",.F.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADFIN044R'
			ZBN_STATUS	:= cStatus
	
		MsUnlock() 
		
	Else
	
		RecLock("ZBN",.T.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADFIN044R'
			ZBN_STATUS	:= cStatus
	
		MsUnlock() 	
	
	EndIf
	
	ZBN->(dbCloseArea())
		
	RestArea(aArea)

Return Nil
