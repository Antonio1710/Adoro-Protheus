#include "rwmake.ch"  
User Function metasup()  

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Programa para cadastro de Supervisores')

SetPrvt("CCADASTRO,AROTINA,")
/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� metasup.prx  � Menu para egetuar manuten��es no cadastro de metas super���
���              � O Advanced Protheus nao contempla esta op�a�             ��
���              � Especifico Ad'oro Alimenticia                           ���
��������������������������������������������������������������������������Ĵ��
��� Marcos Bido  � 10/10/02 �                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

dbSelectArea("SZL")
dbSetOrder(01)
CCadastro := "Metas de Vendas Supervisores    "
aRotina := {  { "Pesquisar"     ,"AxPesqui"            , 0 , 1},;
              { "Visualizar"    ,"axVisual"            , 0 , 2},;
              { "Incluir   "    ,"axInclui"            , 0 , 3},;
              { "Alterar   "    ,"axAltera"            , 0 , 4},;
              { "Excluir   "    ,"axDeleta"            , 0 , 5},;
   	          { "Metas Pre�o"   ,'ExecBlock("AD0149")' , 0 , 6},;
  	          { "Metas Volume"  ,'ExecBlock("AD0148")' , 0 , 7}}


mBrowse( 6, 1,22,75,"SZL")


Return
