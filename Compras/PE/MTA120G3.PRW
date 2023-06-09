#Include 'Protheus.ch'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MTA120G3 � Autor � �verson             � Data �  30/08/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � No laco de grava��o dos itens da SC na fun��o A110GRAVA,   ���
���				 executado ap�s gravar o item da SC, a cada item gravado da ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MTA120G3()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aArea			:= GetArea()
	Local aInformacoes 	:= PARAMIXB
	Local cTpCompra		:= ""
	Local cNumSC			:= SC7->C7_NUMSC
	
	//Remove espa�os em branco.
	cNumSC := Alltrim(cValToChar(cNumSC))
	
	If ! Empty(cNumSC)
		cTpCompra	:= obterTpCompra(cNumSC)
		cTpCompra	:= Alltrim(cValToChar(cTpCompra))
	
		SC7->C7_XGRCOMP:= cTpCompra
	
	EndIf
	
	RestArea(aArea)
	
Return Nil
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �obterTpCompra � Autor � �verson        � Data �  31/08/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o obt�m o Tp. Compra na solicita��o de compra         ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function obterTpCompra(cNumSC)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aArea	:= GetArea()
	Local cOpc		:= ""
	
	//Remove espa�os em branco.
	cNumSC	:= Alltrim(cValToChar(cNumSC))

	DbSelectArea("SC1")
	SC1->(DbSetOrder(1))
	SC1->(DbGoTop())
	
	If ! SC1->(DbSeek(xFilial("SC1") + cNumSC))
		Return cOpc
		
	EndIf
	
	cOpc := Alltrim(cValToChar(SC1->C1_XGRCOMP))
	
	RestArea(aArea)
	
Return cOpc