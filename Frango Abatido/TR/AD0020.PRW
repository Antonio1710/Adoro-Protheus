
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���MANUTENCAO�AD0020    �Autor  �DANIEL	             � Data �  10/31/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � REMOVIDO 'SET FILTER                                       ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"  

User Function AD0020() 

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'REMOVIDO SET FILTER')

SetPrvt("CCADASTRO,AROTINA,")

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� ADO0020.PRW  � Programa de interface da Balanca Rodoviaria Portaria    ���
���              � com a Devolucao do Frango Abatido                       |��
���              � O Advanced Protheus nao contempla esta op�ao            |��
���              � Especifico Ad'oro Alimenticia                           ���
��������������������������������������������������������������������������Ĵ��
��� Gustavo      � 13/01/03 �                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

dbSelectArea("ZV2")
dbSetOrder(01)
//Set Filter to ZV2_TIPOPE == 'D'

//DANIEL		
//���������������������������������������������������������Ŀ
//�FILTRO DA MICROSIGA + R�PIDO                             �
//�����������������������������������������������������������

Private aIndSZ9    := {}
Private bFiltraBrw := {|| Nil}
cCondicao  := " ZV2_TIPOPE == 'D' "
bFiltraBrw := {|| FilBrowse("ZV2",@aIndSZ9,@cCondicao)}
Eval(bFiltraBrw)

CCadastro := "Pesagem de veiculos  - Balanca  "
aRotina := {  { "Pesquisar  "   ,"AxPesqui"              , 0 , 1},;
              { "Visualizar  "  ,"axVisual"              , 0 , 2},;
              { "1a. Pesagem "  ,'ExecBlock("AD0021")'   , 0 , 3},;
              { "2a. Pesagem "  ,'ExecBlock("AD0022")'   , 0 , 4},;                      
              { "Imprimir Guia" ,'ExecBlock("AD0156")'  , 0 , 5} }

mBrowse( 6, 1,22,75,"ZV2")


EndFilBrw("ZV2",aIndSZ9)
Return

