#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CADZZW   � Autor � Mauricio - MDS TEC � Data �  22/08/12   ���
�������������������������������������������������������������������������͹��
���Descricao � Tela para cadastro de faixas para Tabela faixas carteiras  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ESPEC�FICO A'DORO                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function CADZZW()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Faixas Carteria VENDEDORES')

dbSelectArea("ZZW")
dbSetOrder(1)

AxCadastro("ZZW",OemToAnsi("Cadastro de Faixas Carteria VENDEDORES"),".T.",".T.")

Return()