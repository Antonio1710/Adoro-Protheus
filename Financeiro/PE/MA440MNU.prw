#INCLUDE "rwmake.ch"   

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  MA440MNU  � Autor � Fernando Sigoli     � Data �  06/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Adiciona rotina no menu libera��o de pedidos               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA440MNU()

    AADD(aRotina, {'*Rel.Pedidos', 'U_ADFIN029P()', 0, 0, 0, .F.} )

Return