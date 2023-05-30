#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
/*�������������������������������������������������������������������������������������������
���������������������������������������������������������������������������������������������
�����������������������������������������������������������������������������������������ͻ��
���                            TOTVS S/A - F�brica Tradicional                            ���
�����������������������������������������������������������������������������������������͹��
���Programa    �MT120LEG�Ponto de Entrada para acrescentar nova cor aos pedidos de compra ���
���            �        �                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Projeto/PL  �PL_03 - Pedido de Compra (Valida��es e Controle de Rejei��o               ���
�����������������������������������������������������������������������������������������͹��
���Solicitante �99.99.99�                                                                 ���
�����������������������������������������������������������������������������������������͹��
���Autor       �25.03.08�Almir Bandina                                                    ���
�����������������������������������������������������������������������������������������͹��
���Par�metros  �Nil                                                                       ���
�����������������������������������������������������������������������������������������͹��
���Retorno     �Nil.                                                                      ���
�����������������������������������������������������������������������������������������͹��
���Observa��es �                                                                          ���
�����������������������������������������������������������������������������������������͹��
���Altera��es  � 99.99.99 - Consultor - Descri��o da Altera��o                            ���
�����������������������������������������������������������������������������������������ͼ��
���������������������������������������������������������������������������������������������
�������������������������������������������������������������������������������������������*/
User Function MT120LEG()
//�����������������������������������������������������������������������������������������Ŀ
//� Define as vari�veis utilizadas na rotina                                                �
//�������������������������������������������������������������������������������������������
Local aAux	:= PARAMIXB[1] 

//�����������������������������������������������������������������������������������������Ŀ
//� Adiciona nova cor ao array de legendas                                                  �
//�������������������������������������������������������������������������������������������
aAdd( aAux, { "BR_MARROM", "Rejeitado pelo Aprovador" } )

Return( aAux )