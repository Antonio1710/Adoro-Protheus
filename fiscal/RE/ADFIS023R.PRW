#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADFIS023R �Autor  �WILLIAM COSTA       �Data  �  13/04/2018 ���
�������������������������������������������������������������������������͹��
���Descricao �WORKFLOW DE DOACOES REALIZADAS POR OUTRO APROVADOR          ���
���          �SERA ENVIADO AO CAIO E AO JAIR                              ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro S/A.                                                 ���
�������������������������������������������������������������������������ͼ��
���Adriana     �24/05/2019�TI-Devido a substituicao email para shared     ���
���            �          �relay, substituido MV_RELACNT p/ MV_RELFROM    ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADFIS023R()   

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
	If !LockByName("ADFIS023R", .T., .F.)
		ConOut("[ADFIS023R] - Existe outro processamento sendo executado! Verifique...")
		RPCClearEnv()
		Return
	EndIf

	logZBN("1")

	//@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	//FWMonitorMsg(ALLTRIM(PROCNAME()))

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'WORKFLOW DE DOACOES REALIZADAS POR OUTRO APROVADOR SERA ENVIADO AO CAIO E AO JAIR')

	procRel()

	logZBN("2")

	//Fecha o ambiente.
	RpcClearEnv()

	//��������������������������������������?
	//�Destrava a rotina para o usu�rio	    ?
	//��������������������������������������?
	UnLockByName("ADFIS023R")

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �procRel   �Autor  �Fernando Sigoli     �Data  �  29/03/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera relat�rio.                                             ���
�������������������������������������������������������������������������͹��
���Uso       �Adoro S/A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function procRel()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������	
	Local aArea		:= GetArea()
	Local cAssunto	:= "WorkFlow Aprova��es de Doa��es"
	Local cMensagem	:= ""
	Local cEmail	:= GetMv("MV_#EMADOA")
	Local cQuery	:= ""

	//
	cQuery := scriptSql()

	//
	If Select("DADOS") > 0
		DADOS->(DbCloseArea())

	EndIf

	//
	cMensagem += '<html>'
	cMensagem += '<body>'
	cMensagem += '<p style="color:red">Seguem abaixo Todas as Aprova��es de Doa��o Semanal dos dias: ' + DTOC(DATE()-8) + ' at� ' + DTOC(DATE()-1) + '.</p>'
	cMensagem += '<hr>'
	cMensagem += '<table border="1">'
	cMensagem += '<tr style="background-color: black;color:white">'
	cMensagem += '<td>Filial</td>'
	cMensagem += '<td>Num Nota</td>'
	cMensagem += '<td>Num Pedido</td>'
	cMensagem += '<td>Tipo</td>'
	cMensagem += '<td>Data Emissao</td>'
	cMensagem += '<td>Data Entrega</td>'
	cMensagem += '<td>Cliente-Loja</td>'
	cMensagem += '<td>Nome</td>'
	cMensagem += '<td>Produto</td>'
	cMensagem += '<td>Descri��o</td>'
	cMensagem += '<td>Quantidade</td>'
	cMensagem += '<td>Pre�o Unit�rio</td>'
	cMensagem += '<td>Total</td>'
	cMensagem += '<td>Aprovador</td>'
	cMensagem += '</tr>'

	TcQuery cQuery New Alias "DADOS"
	DbSelectArea("DADOS")
	DADOS->(DbGoTop())

	While ! DADOS->(Eof())

		cMensagem += '<tr>'
		cMensagem += '<td>' + cValToChar(DADOS->C5_FILIAL)                                + '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->C5_NOTA)                                  + '</td>'		
		cMensagem += '<td>' + cValToChar(DADOS->C5_NUM)                                   + '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->C5_TIPO)                                  + '</td>'
		cMensagem += '<td>' + cValToChar(DTOC(STOD(DADOS->C5_EMISSAO)))                   + '</td>'
		cMensagem += '<td>' + cValToChar(DTOC(STOD(DADOS->C5_DTENTR)))                    + '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->C5_CLIENTE)                               + '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->C5_NOMECLI)                               + '</td>' 
		cMensagem += '<td>' + cValToChar(DADOS->C6_PRODUTO)                               + '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->C6_DESCRI)                                + '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->C6_QTDVEN)                                + '</td>'
		cMensagem += '<td>' + cValToChar(Transform(DADOS->C6_PRCVEN,"@E 999,999,999.99")) + '</td>'
		cMensagem += '<td>' + cValToChar(Transform(DADOS->C6_VALOR,"@E 999,999,999.99"))  + '</td>'
		cMensagem += '<td>' + cValToChar(UsrRetName(DADOS->C5_APRVDOA))                               + '</td>'

		cMensagem += '</tr>'

		DADOS->(DbSkip())

	EndDo
	cMensagem += '</table>'
	cMensagem += '</body>'
	cMensagem += '</html>'

	DADOS->(DbCloseArea())

	//
	processarEmail(cAssunto,cMensagem,cEmail)

	//
	RestArea(aArea)

Return Nil


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �scriptSql �Autor  �Fernando Sigoli     �Data  �  29/03/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     �Script sql.                                                 ���
�������������������������������������������������������������������������͹��
���Uso       �Adoro S/A                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function scriptSql()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������	
	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local cData		:= DToS(Date() - 3)

	cQuery := " SELECT C5_FILIAL, "
	cQuery += "        C5_NOTA,  "
	cQuery += "        C5_NUM,  " 
	cQuery += "        C5_TIPO,"
	cQuery += "        C5_EMISSAO, "
	cQuery += "        C5_DTENTR, " 
	cQuery += "        C5_CLIENTE+'-'+C5_LOJACLI AS C5_CLIENTE, "
	cQuery += "        C5_NOMECLI, "
	cQuery += "        C6_PRODUTO, "
	cQuery += "        C6_DESCRI, "
	cQuery += "        C6_QTDVEN, "
	cQuery += "        C6_PRCVEN, "
	cQuery += "        C6_VALOR, "
	cQuery += "        C5_APRVDOA "
	cQuery += " FROM " + RetSqlName("SC5") + " WITH(NOLOCK), " + RetSqlName("SC6") + " WITH(NOLOCK)"  
    cQuery += " WHERE C5_FILIAL                             = '02' " 
	cQuery += "   AND C5_EMISSAO                           >= CONVERT(VARCHAR(8), GETDATE() - 8, 112) "
	cQuery += "   AND C5_EMISSAO                           <= CONVERT(VARCHAR(8), GETDATE() - 1, 112) "  
	cQuery += "   AND C5_APRVDOA                           <> '' "
	cQuery += "   AND C5_APRVDOA                           <> '000559' "
	cQuery += "   AND " + RetSqlName("SC5") + ".D_E_L_E_T_ <> '*' "   
	cQuery += "   AND C6_FILIAL                             = C5_FILIAL "
	cQuery += "   AND C6_NUM                                = C5_NUM "
	cQuery += "   AND C6_CLI                                = C5_CLIENTE "
	cQuery += "   AND C6_LOJA                               = C5_LOJACLI "  
	cQuery += "   AND " + RetSqlName("SC5") + ".D_E_L_E_T_ <> '*' "
	cQuery += "  ORDER BY C5_FILIAL,C5_NUM   "
	
	RestArea(aArea)

Return cQuery

/*
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
������������������������������������������������������������������������������ͻ��
���Programa  �processarEmail �Autor  �Fernando Sigoli     �Data  �  29/03/2018 ���
������������������������������������������������������������������������������͹��
���Desc.     �Configura��es de e-mail.                                         ���
������������������������������������������������������������������������������͹��
���Uso       �Adoro S/A                                                        ���
������������������������������������������������������������������������������ͼ��
����������������������������������������������������������������������������������
����������������������������������������������������������������������������������
*/
Static Function processarEmail(cAssunto,cMensagem,email)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local aArea			:= GetArea()
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

	//
	If !lAutOk
		If ( lSmtpAuth )
			lAutOk := MailAuth(cAccount,cPassword)

		Else
			lAutOk := .T.

		EndIf

	EndIf

	//
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

	//
	RestArea(aArea)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �logZBN    �Autor  �Fernando Sigoli     �Data  �  29/03/2018 ���
�������������������������������������������������������������������������͹��
���Descricao �Gera log na ZBN.                                            ���
�������������������������������������������������������������������������͹��
���Uso: Adoro� S/A                                                        ���
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
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADFIS023R'))

		RecLock("ZBN",.F.)

		ZBN_FILIAL  := xFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= 'ADFIS023R'
		ZBN_DESCRI  := 'WORFLOW PEDIDOS DE DOACOES'
		ZBN_STATUS	:= cStatus

		MsUnlock() 

	Else

		RecLock("ZBN",.T.)

		ZBN_FILIAL  := xFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= 'ADFIS023R'
		ZBN_DESCRI  := 'WORFLOW PEDIDOS DE DOACOES'
		ZBN_STATUS	:= cStatus

		MsUnlock() 	

	EndIf

	ZBN->(dbCloseArea())

	//
	RestArea(aArea)

Return Nil
