#INCLUDE "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ADVEN027P    � Autor � ADRIANA OLIVEIRA � Data �  09/08/16 ���
�������������������������������������������������������������������������͹��
���Descricao � Manutencao no cadastro de Calendario TECLAN                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ADVEN027P
Local aRotAdic :={}

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Manutencao no cadastro de Calendario TECLAN')

aadd(aRotAdic,{ "Atual.Mailing Semanal","U_ADVEN028P()", 0 , 6 })
aadd(aRotAdic,{ "Atual.Mailing Geral","U_ADVEN024P()", 0 , 6 })

AxCadastro("ZBC","Calendario Semanal para TECLAN", , ,aRotAdic , , , , , , , , ,)    

Return()