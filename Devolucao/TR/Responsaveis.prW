#include "rwmake.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Responsaveis �Autor  �Ricardo Baldoni  � Data �  11/20/02   ���
�������������������������������������������������������������������������͹��
���Desc.     �Faz o AxCadastro dos Responsaveis pelas Devolucoes de       ���
���          �Produtos                                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Depto. de Logistica                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function Responsa 

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

dbSelectArea("SZU")
dbSetOrder(1)
dbGoTop()
AxCadastro("SZU",'Cadastro de Responsaveis (Devolucao)',".T.",".T.")
Return( .T. )