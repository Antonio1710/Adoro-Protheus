#Include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADLOG058P � Autor � Everson            � Data �  01/07/2019 ���
�������������������������������������������������������������������������͹��
���Descricao �Emiss�o autom�tica de CT-e .                                ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 044314.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADLOG058P(cRoteiro,cDtEntr)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������	
	Local cEmp 			:= "01"
	Local cFil 		:= "02"
	
	Default cRoteiro 	:= ""
	Default cDtEntr		:= ""
	
	//Inicia o ambiente.
	RPCSetType(3)
	RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{ })
		
		Conout( DToC(Date()) + " " + Time() + " ADLOG058P - 1 - In�cio gera��o autom�tica de CT-e" )
		
		//
		If ! Empty(cRoteiro) .And. ! Empty(cDtEntr) .And. SToD(cDtEntr) >= Date()
		
			Conout( DToC(Date()) + " " + Time() + " ADLOG058P - 2 - In�cio gera��o autom�tica de CT-e - cRoteiro/cDtEntr " + cRoteiro + " " + DToC(SToD(cDtEntr)) )
			
			U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Emiss�o autom�tica de CT-e .')

			logZBE("In�cio gera��o de CT-e " + cRoteiro + "-" + DToC(SToD(cDtEntr)) )
				
				DbSelectArea("ZFK")
				ZFK->(DbSetOrder(2))
				ZFK->(DbGoTop())
				If ! ZFK->(DbSeek( FWxFilial("ZFK") + cDtEntr + cRoteiro + "1" ))
					
					Conout( DToC(Date()) + " " + Time() + " ADLOG058P - 3 - In�cio gera��o autom�tica de CT-e - cRoteiro/cDtEntr " + cRoteiro + " " + DToC(SToD(cDtEntr)) )
					
					//Static Call(ADLOG057P,geraCTERot,cRoteiro,cDtEntr)
					//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
					////nao modificado pois nao existe a funcao geraCTERot no projeto
				
				EndIf
			
			logZBE("Fim gera��o de CT-e " + cRoteiro + "-" + DToC(SToD(cDtEntr)) )
		
		EndIf
		
		Conout( DToC(Date()) + " " + Time() + " ADLOG058P - 4 - Fim gera��o autom�tica de CT-e" )

	//Fecha o ambiente.
	RpcClearEnv()
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �logZBE    � Autor � Everson            � Data �  01/07/2019 ���
�������������������������������������������������������������������������͹��
���Descricao �Gera log na tabela ZBE.                                     ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 044314.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function logZBE(cMensagem)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                            |
	//�����������������������������������������������������������������������	
	Local aArea	:= GetArea()

	//
	DbSelectArea("ZBE")
	RecLock("ZBE",.T.)
		Replace ZBE_FILIAL 	   	With xFilial("ZBE")
		Replace ZBE_DATA 	   	With dDataBase
		Replace ZBE_HORA 	   	With Time()
		Replace ZBE_USUARI	    With Upper(Alltrim(cUserName))
		Replace ZBE_LOG	        With cMensagem
		Replace ZBE_MODULO	    With "LOGISTICA"
		Replace ZBE_ROTINA	    With "ADLOG058P" 
	MsUnlock()

	//
	RestArea(aArea)

Return Nil
