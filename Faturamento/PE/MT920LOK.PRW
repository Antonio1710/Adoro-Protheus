#Include "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT920LOK  �Autor  �Abel Babini Filho   � Data �  26/08/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela do Painel Fiscal                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
���Chamado   �                                                            ���
���n.051235  � Apenas Inclusao NF Complemento ICMS via MATA920 NF Manual  ���
���          � de Entrada - Abel Babini - 30/04/2019                      ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function MT920LOK()
	Local lRet := .F. 
	
	// cTipo => N=NORMAL || I=COMPL ICMS || D=DEVOLUCAO || B=BENEFICIAMENTO || P=COMPL IPI || C=COMPL PRECO FRETE
	If cTipo == "I" .and. AllTrim(FunName())=="MATA920" .AND. Inclui
		lRet := .T.
	Else
		Aviso("INCLUS�O N�O PERMITIDA", "Apenas NF de Complemento de ICMS poder� ser inclu�da atrav�s desta rotina", {"Fechar"}, 2)
	Endif
	
Return lRet