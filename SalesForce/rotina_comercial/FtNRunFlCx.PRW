#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FtNRunFlCx     �Autor  �Everson      � Data �  17/04/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Ponto de entrada para execu��o ou n�o do fluxo de caixa.    ���
���    �http://tdn.totvs.com/pages/releaseview.action?pageId=269071293    ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/ 
User Function FTNRUNFLCX()
 
	Local lRet := .F. // N�o executar� o processamento do fluxo de caixa, ap�s a gera��o do pedido de venda.

Return lRet