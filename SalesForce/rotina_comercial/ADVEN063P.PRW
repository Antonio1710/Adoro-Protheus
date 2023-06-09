#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Apwizard.ch"
#Include "Fileio.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADVEN063P   � Autor � Everson          � Data �  22/11/17   ���
�������������������������������������������������������������������������͹��
���Descricao �Importa��o de c�digo de grupo de compras.                   ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADVEN063P() // U_ADVEN063P()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������  
	Local aArea := GetArea()
	Local cArq	:= ""

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Importa��o de c�digo de grupo de compras')
	
	//
	cArq	:= cGetFile("Arquivo CSV|*.csv", "Selecione o arquivo CSV com os grupos de compra.",,'C:\',.T., GETF_LOCALHARD + GETF_NETWORKDRIVE)
	cArq	:= Alltrim(cValToChar(cArq))

	//
	If Empty(cArq)
		RestArea(aArea)
		Return Nil

	EndIf
		
	//
	Processa({|| processar(cArq) },"Lendo arquivo...")

	//
	MsgInfo("Arquivo processado.","Fun��o ADVEN063P")
	
	//
	RestArea(aArea)	
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �processar   � Autor � Everson          � Data �  22/11/17   ���
�������������������������������������������������������������������������͹��
���Descricao �Processa arquivo CSV.                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function processar(cArq)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������  
	Local aArea			:= GetArea()
	Local nHdl			:= 0
	Local nTotLinhas	:= 0
	Local aLinha		:= {}
	Local cBuffer		:= ""
	Local nLinha		:= 0

	Local cCodCli		:= ""
	Local cLojaCli		:= ""
	Local cCodGrp		:= ""

	//Abre o Arquivo.
	nHdl := FT_FUse(cArq) 

	//Valida abertura do arquivo.
	If nHdl == -1
		MsgStop("N�o foi poss�vel abrir o arquivo " + Chr(13) + Chr(13) + cArq + ".","Fun��o ADVEN063P")
		Return Nil

	EndIf

	//
	FT_FGoTop()

	//
	nTotLinhas := FT_FLastRec()

	//Atribui o tamanho da r�gua.
	ProcRegua(nTotLinhas)

	//
	nLinha := 0
	While ! FT_FEof()

		nLinha++

		cBuffer:= DecodeUTF8(FT_FReadln())

		aLinha	:= StrToKarr(cBuffer,";")

/*		//
		If Len(aLinha) <> 3
			MsgStop("Por favor, reveja o arquivo CSV, pois o total de campos por linha deve ser igual a 3, mas a linha " + cValToChar(nLinha) + " est� com " + cValToChar(Len(aLinha)) + " campo(s).","Fun��o ADVEN063P")
			RestArea(aArea)	
			Return Nil

		EndIf*/

		//
		cCodCli		:= Alltrim(cValToChar(aLinha[1]))
		cLojaCli	:= Alltrim(cValToChar(aLinha[2]))
		cCodGrp		:= Alltrim(cValToChar(aLinha[3]))

		IncProc("Processando cliente | " + cCodCli + "/" + cLojaCli + " | " + cCodGrp)

		//
		DbSelectArea("SA1")
		SA1->(DbSetOrder(1))
		SA1->(DbGoTop())
		If ! SA1->( DbSeek(xFilial("SA1") + cCodCli + cLojaCli) )
			MsgStop("Cliente " + cCodCli + "/" + cLojaCli + " n�o encontrado (SA1).","Fun��o ADVEN063P")
			FT_FSkip()
			Loop

		EndIf

		//
		DbSelectArea("PB3")
		PB3->(DbSetOrder(11))
		PB3->(DbGoTop())
		If ! PB3->( DbSeek(xFilial("PB3") + cCodCli + cLojaCli) )
			MsgStop("Cliente " + cCodCli + "/" + cLojaCli + " n�o encontrado (PB3).","Fun��o ADVEN063P")
			FT_FSkip()
			Loop

		EndIf
		
		//
		BeginTran()
			
			//
			DbSelectArea("ZBE")
			RecLock("ZBE",.T.)
				Replace ZBE_FILIAL 	With xFilial("ZBE")
				Replace ZBE_DATA 	With dDataBase
				Replace ZBE_HORA 	With Time()
				Replace ZBE_USUARI	With Upper(Alltrim(cUserName))
				Replace ZBE_LOG	    With "CAMPO A1_VEND DE " + SA1->A1_XGRPCOM + " PARA " + cCodGrp + " | PB3_XGRPCO DE " + PB3->PB3_XGRPCO  + " PARA " + cCodGrp
				Replace ZBE_MODULO	With "COMERCIAL"
				Replace ZBE_ROTINA	With "ADVEN063P"
				Replace ZBE_PARAME	With "CLIENTE: " + cCodCli + "/" + cLojaCli
			ZBE->(MsUnlock())
		
			//Altera dados na SA1.
			DbSelectArea("SA1")
			RecLock("SA1",.F.)
				Replace SA1->A1_XGRPCOM With cCodGrp
			SA1->(MsUnLock())
	
			//Altera dados na PB3.
			DbSelectArea("PB3")
			RecLock("PB3",.F.)
				Replace PB3->PB3_XGRPCO With cCodGrp
			PB3->(MsUnLock())
		
		EndTran()
		
		FT_FSkip()

	EndDo

	//
	RestArea(aArea)		

Return Nil