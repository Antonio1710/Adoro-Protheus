#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CADZZ5   � Autor � Mauricio - MDS TEC � Data �  10/04/13   ���
�������������������������������������������������������������������������͹��
���Descricao � Tela para cadastro de grupo/produtos no relatorio de cober-���
���          � tura inteligente.                                          ���
�������������������������������������������������������������������������͹��
���Uso       � ESPEC�FICO A'DORO                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
  
User Function CADZZ5()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Tela para cadastro de grupo/produtos no relatorio de cobertura inteligente.')

dbSelectArea("ZZ5")
dbSetOrder(1)

AxCadastro("ZZ5",OemToAnsi("Cadastro para Cobertura Inteligente"),".T.",".T.")

Return()