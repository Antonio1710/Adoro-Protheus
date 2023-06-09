#Include 'Protheus.ch'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110GRV � Autor � �verson             � Data �  30/08/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � No laco de grava��o dos itens da SC na fun��o A110GRAVA,   ���
���			   executado ap�s gravar o item da SC, a cada item gravado da ���
���          � SC o ponto � executado.									  ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT110GRV()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	
	//Inicio - tratamento para regra do execAuto - Chamado: 037886 - Fernando Sigoli 07/11/2017
	If(Type("lRotHabil")=="U")
		lRotHabil := .T.
	EndIf	
	
	If(Type("cGrCompra")=="U")
		cGrCompra := '1'
	EndIf	
	
	If(Type("cHora")=="U")
		cHora := TIME()
	EndIf	
	
	//Fim - tratamento para regra do execAuto - Chamado: 037886 - Fernando Sigoli 07/11/2017
	
	
	If lRotHabil //�verson - 29/08/2016. Valida ponto de entrada MT110TEL.
	
		//Grava o grupo de compra selecionado na solicita��o de compra.
		DbSelectArea("SC1")
		RecLock("SC1",.F.) 
			SC1->C1_XGRCOMP := Alltrim(cValToChar(cGrCompra))
			SC1->C1_XHORASC := cHora
		SC1->(MsUnlock()) 
	
	EndIf
	
	RestArea(aArea)
	
Return Nil