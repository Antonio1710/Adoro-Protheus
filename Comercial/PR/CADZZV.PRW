#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CADZZV   � Autor � Mauricio - MDS TEC � Data �  14/03/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Tela para cadastro de agrupadores                          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESPEC�FICO A'DORO                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADZZV()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Agrupadores')

dbSelectArea("ZZV")
dbSetOrder(1)

AxCadastro("ZZV",OemToAnsi("Cadastro de Agrupadores"),".T.",".T.")


Return