#include "rwmake.ch"  

User Function AD0093()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Menu para Lancamentos de Lancto de Desc./Acresc.')

SetPrvt("CCADASTRO,AROTINA,")

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� AD0093.PRW   � Menu para Lancamentos de Lancto de Desc./Acresc.        ���
���              � Uso Logistica                                           ���
��������������������������������������������������������������������������Ĵ��
��� Gustavo      � 24/11/03 �                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

dbSelectArea("SZK")
dbSetOrder(09) // Indice Placa Pagto + Data Entrega + Roteiro 
dbGoTop()

CCadastro := "Controle de Descontos e Acrescimos"
aRotina := { { "Pesquisar     "  ,"AxPesqui"             , 0 , 1},;
              { "Visualizar    "  ,"axVisual"            , 0 , 2},;
              { "Incluir       "  ,"axInclui"            , 0 , 3},;
              { "Alterar       "  ,"axAltera"            , 0 , 4},;
              { "Excluir       "  ,'ExecBlock("AD0068")' , 0 , 5},;
              { "Desc./Acres.  "  ,'ExecBlock("AD0094")' , 0 , 6},;
              { "Fech. Mensal  "  ,'ExecBlock("AD0097")' , 0 , 7} }
              
mBrowse( 6, 1,22,75,"SZK") 

Return
