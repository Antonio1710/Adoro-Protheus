#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADFIS026R �Autor  �Fernando Sigoli     �Data  �  15/05/2018 ���
�������������������������������������������������������������������������͹��
���Descricao �WorkFlow Notas Classificadas e Manifestada como Canceladas  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro S/A.                                                 ���
�������������������������������������������������������������������������ͼ��
���Adriana     �24/05/2019�TI-Devido a substituicao email para shared     ���
���            �          �relay, substituido MV_RELACNT p/ MV_RELFROM    ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADFIS026R()   

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������	
	Local cEmp 		:= "01"
	Local cFil 		:= "02"

	//Inicia o ambiente.
	RPCClearEnv()
	RPCSetType(3)
	RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{ })

	// Garanto uma �nica thread sendo executada - // Adoro - Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - fwnm - 30/06/2020
	If !LockByName("ADFIS026R", .T., .F.)
		ConOut("[ADFIS026R] - Existe outro processamento sendo executado! Verifique...")
		RPCClearEnv()
		Return
	EndIf

	logZBN("1")

	// @history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	//FWMonitorMsg(ALLTRIM(PROCNAME()))

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'WorkFlow Notas Classificadas e Manifestada como Canceladas')

	procRel()

	logZBN("2")

	//��������������������������������������?
	//�Destrava a rotina para o usu�rio	    ?
	//��������������������������������������?
	UnLockByName("ADFIS026R")

	//Fecha o ambiente.
	RpcClearEnv()

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
	Local cAssunto	:= "Notas Classificadas e Manifestada com Status Cancelada "
	Local cMensagem	:= ""
	Local cEmail	:= GetMV("MV_#USUNFC",,"fernando.sigoli@adoro.com.br") 
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
	cMensagem += '<p style="color:red">Seguem abaixo Todas as Notas Classificadas e Manifestada com Status Cancelada</p>'
	cMensagem += '<hr>'
	cMensagem += '<table border="1">'
	cMensagem += '<tr style="background-color: black;color:white">'
	cMensagem += '<td>Filial</td>'
	cMensagem += '<td>Tipo</td>'
	cMensagem += '<td>Num Nota</td>'
	cMensagem += '<td>Serie</td>'
	cMensagem += '<td>Especie</td>'
	cMensagem += '<td>Data Emissao</td>'
	cMensagem += '<td>Data Digita��o</td>'
	cMensagem += '<td>Vlr.Bruto</td>'
	cMensagem += '<td>Chave</td>'
	cMensagem += '<td>Fornecedor</td>'
	cMensagem += '<td>Loja</td>'
	cMensagem += '<td>Razao</td>'
	cMensagem += '</tr>'

	TcQuery cQuery New Alias "DADOS"
	DbSelectArea("DADOS")
	DADOS->(DbGoTop())

	While ! DADOS->(Eof())
	
		cMensagem += '<tr>'
		cMensagem += '<td>' + cValToChar(DADOS->F1_FILIAL)                                			+ '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->F1_TIPO)                                			+ '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->F1_DOC)                                   			+ '</td>'		
		cMensagem += '<td>' + cValToChar(DADOS->F1_SERIE)                                 			+ '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->F1_ESPECIE)                               			+ '</td>'
		cMensagem += '<td>' + cValToChar(DTOC(STOD(DADOS->F1_EMISSAO)))                   			+ '</td>'
		cMensagem += '<td>' + cValToChar(DTOC(STOD(DADOS->F1_DTDIGIT)))                   			+ '</td>'
		cMensagem += '<td>' + cValToChar(Transform(DADOS->F1_VALBRUT,"@E 999,999,999.99"))			+ '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->(DADOS->F1_CHVNFE))                    				+ '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->(DADOS->F1_FORNECE))                   				+ '</td>'
		cMensagem += '<td>' + cValToChar(DADOS->(DADOS->F1_LOJA))                      				+ '</td>'
		cMensagem += '<td>' + cValToChar(IIF(DADOS->F1_TIPO = 'D',POSICIONE("SA1",1,xFilial("SA1")+DADOS->F1_FORNECE + DADOS->F1_LOJA,"A1_NOME"),POSICIONE("SA2",1,xFilial("SA2")+DADOS->F1_FORNECE + DADOS->F1_LOJA,"A2_NOME")))+ '</td>'
                                         
	
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
	
	cQuery := " SELECT "
	cQuery += " F1_FILIAL,F1_TIPO,F1_DOC, F1_SERIE,F1_ESPECIE, F1_EMISSAO,F1_DTDIGIT,F1_VALBRUT,F1_CHVNFE, F1_FORNECE, F1_LOJA " 
	cQuery += " FROM " + RetSqlName("SF1") + "  SF1 with (nolock) INNER JOIN " + RetSqlName("C00") + "  C00 with (nolock) ON "
	cQuery += " SF1.F1_FILIAL = C00.C00_FILIAL  AND SF1.F1_CHVNFE = C00.C00_CHVNFE "
	cQuery += " WHERE "
	cQuery += " C00_SITDOC = '3' "
	cQuery += " AND SF1.D_E_L_E_T_ = '' "
	cQuery += " AND C00.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY F1_FILIAL, F1_DOC "
	
	
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
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADFIS026R'))

		RecLock("ZBN",.F.)

		ZBN_FILIAL  := xFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= 'ADFIS026R'
		ZBN_DESCRI  := 'WORFLOW NOTAS CLASSIFICADAS E CANCELADAS'
		ZBN_STATUS	:= cStatus

		MsUnlock() 

	Else

		RecLock("ZBN",.T.)

		ZBN_FILIAL  := xFilial("ZBN")
		ZBN_DATA    := Date()
		ZBN_HORA    := cValToChar(Time())
		ZBN_ROTINA	:= 'ADFIS026R'
		ZBN_DESCRI  := 'WORFLOW NOTAS CLASSIFICADAS E CANCELADAS'
		ZBN_STATUS	:= cStatus

		MsUnlock() 	

	EndIf

	ZBN->(dbCloseArea())

	//
	RestArea(aArea)

Return Nil
