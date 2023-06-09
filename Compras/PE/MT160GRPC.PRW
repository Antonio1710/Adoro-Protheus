#Include 'Protheus.ch'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT160GRPC � Autor � �verson            � Data �  02/09/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada disponibilizado para grava��o de valores  ���
���			   � e campos espec�ficos do Pedido de Compra (SC7).Executado   ���
���          � durante a  gera��o do pedido de compra na an�lise da cota��o���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT160GRPC()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aArea			:= GetArea()
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
���Programa  �obterTpCompra � Autor � �verson        � Data �  02/09/2016 ���
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