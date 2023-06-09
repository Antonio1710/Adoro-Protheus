#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#Include 'AP5mail.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADFAT011P  � Autor � Everson           � Data � 16/11/2018  ���
�������������������������������������������������������������������������͹��
���Descricao �Job para integra��o de dados de cargas do Edata no Protheus.���
�������������������������������������������������������������������������͹��
���Uso       �Chamado .                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADFAT011P() //U_ADFAT011P()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������	
	Local cEmp 		:= "01"
	Local cFil 		:= "02"
	
	//Inicia o ambiente.
	RPCSetType(3)
	RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{ })
		
		conout("In�cio integra��o de dados de cargas no Edata no Protheus.")
		logZBN("1") //Log in�cio.
		
		U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Job para integra��o de dados de cargas do Edata no Protheus')

		//Static Call(ADFAT009P,dadosEdata,DToS(Date()),DToS(Date()),.T.)
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_FAT009A0( DToS(Date()),DToS(Date()),.T. ) 
		
		//Static Call(ADFAT009P,dadosEdata,"20181112","20181112",.T.)
		
		logZBN("2") //Log fim.
		conout("Fim integra��o de dados de cargas no Edata no Protheus.")
	
	//Fecha o ambiente.
	RpcClearEnv()

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �logZBN            � Autor � Everson � Data �  16/11/2018    ���
�������������������������������������������������������������������������͹��
���Descricao �Gera log na ZBN.                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado .                                             ���
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
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADFAT011P'))
	
		RecLock("ZBN",.F.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADFAT011P'
			ZBN_STATUS	:= cStatus
	
		MsUnlock() 
		
	Else
	
		RecLock("ZBN",.T.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_DATA    := Date()
			ZBN_HORA    := cValToChar(Time())
			ZBN_ROTINA	:= 'ADFAT011P'
			ZBN_STATUS	:= cStatus
	
		MsUnlock() 	
	
	EndIf
	
	ZBN->(dbCloseArea())
		
	RestArea(aArea)

Return Nil
