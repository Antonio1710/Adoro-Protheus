#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CADZZX   � Autor � Mauricio - MDS TEC � Data �  15/08/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Tela para cadastro de faixas para rotina Classcli2         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESPEC�FICO A'DORO                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADZZX()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Faixa por Volume(cxs) e IPCT')

dbSelectArea("ZZX")
dbSetOrder(1)

AxCadastro("ZZX",OemToAnsi("Cadastro de Faixa por Volume(cxs) e IPCT"),".T.",".T.")

Return()