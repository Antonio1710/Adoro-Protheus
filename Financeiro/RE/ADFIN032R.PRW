#Include "Protheus.ch"
#Include "Topconn.ch"
#Include 'AP5mail.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADFIN032R � Autor � Everson            � Data �  23/05/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � Envio autom�tico do relat�rio Lan�amentos Cont�beis -      ���
���			 � Resultado Financeiro.                                      ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADFIN032R() 

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
	If !LockByName("ADFIN032R", .T., .F.)
		ConOut("[ADFIN032R] - Existe outro processamento sendo executado! Verifique...")
		RPCClearEnv()
		Return
	EndIf

	//	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
	//FWMonitorMsg(ALLTRIM(PROCNAME()))

	logZBN("1") //Log in�cio.

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Envio autom�tico do relat�rio Lan�amentos Cont�beis - Resultado Financeiro.')
	
	//
	//Static Call(ADFIN030P,envMaillcrf,.T.)
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	u_FIN030A0(.T.)
	
	logZBN("2") //Log fim.

	//Fecha o ambiente.
	RpcClearEnv()

	//��������������������������������������?
	//�Destrava a rotina para o usu�rio	    ?
	//��������������������������������������?
	UnLockByName("ADFIN032R")

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �logZBN    � Autor � Everson            � Data �  24/05/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � Log Job.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
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
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADFIN032R'))
	
		RecLock("ZBN",.F.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_ROTINA	:= 'ADFIN032R'
			ZBN_DESCRI  := ' Gerar relat�rio Lan�amentos Cont�beis-Resultado Financeiro'
			ZBN_DATA    := dDataBase
			ZBN_HORA    := TIME()
			ZBN_PERIOD  := '1'
			ZBN_PERDES  := 'DIA'
			ZBN_QTDVEZ  := 1
			ZBN_HORAIN  := '09:00:00'
			ZBN_DATAPR  := dDataBase + 1
			ZBN_HORAPR  := '09:00:00'
			ZBN_STATUS	:= cStatus
	
		MsUnlock() 
		
	Else
	
		RecLock("ZBN",.T.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_ROTINA	:= 'ADFIN032R'
			ZBN_DESCRI  := ' Gerar relat�rio Lan�amentos Cont�beis-Resultado Financeiro'
			ZBN_DATA    := dDataBase
			ZBN_HORA    := TIME()
			ZBN_PERIOD  := '1'
			ZBN_PERDES  := 'DIA'
			ZBN_QTDVEZ  := 1
			ZBN_HORAIN  := '09:00:00'
			ZBN_DATAPR  := dDataBase + 1
			ZBN_HORAPR  := '09:00:00'
			ZBN_STATUS	:= cStatus
	
		MsUnlock() 	
	
	EndIf
	
	ZBN->(dbCloseArea())
		
	RestArea(aArea)

Return Nil
