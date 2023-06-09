/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���MANUTENCAO�AD0059    �Autor  �DANIEL              � Data �  10/31/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �REMOVIDO O 'SET FILTER'                                     ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"  

User Function AD0059()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'REMOVIDO SET FILTER')

SetPrvt("CCADASTRO,AROTINA,")

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� ADO0059.PRW  � Programa de interface da Balanca Rodoviaria Portaria    ���
���              � com a Pesagem Diversas.                                 |��
���              � O Advanced Protheus nao contempla esta op�ao            |��
���              � Especifico Ad'oro Alimenticia                           ���
��������������������������������������������������������������������������Ĵ��
��� Gustavo      � 12/08/03 �                                              ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/

Static _cTipPes  := "A"
Public _cEntrada := "E"

dbSelectArea("ZV2")
dbSetOrder(01)  
Private aIndSZ9    := {}     
Private bFiltraBrw := {|| Nil}
//Set Filter to ZV2->ZV2_TIPOPE == _cTipPes .AND. ZV2->ZV2_ENTSAI == _cEntrada
cCondicao  := " ZV2->ZV2_TIPOPE == '"+_cTipPes+"' .AND. ZV2->ZV2_ENTSAI == '"+_cEntrada+"' "
bFiltraBrw := {|| FilBrowse("ZV2",@aIndSZ9,@cCondicao)}
Eval(bFiltraBrw)


CCadastro := "Pesagem Diversas (Entradas) - Balanca  "
aRotina := {  { "Pesquisar  "   ,"AxPesqui"              , 0 , 1},;
              { "Visualizar  "  ,"axVisual"              , 0 , 2},;
              { "1a. Pesagem "  ,'U_AD0060("E")', 0 , 3},;
              { "2a. Pesagem "  ,'ExecBlock("AD0061")'   , 0 , 4},;                      
              { "Imprimir Guia" ,'ExecBlock("AD0156")'  , 0 , 5} }

mBrowse( 6, 1,22,75,"ZV2")
//{ "1a. Pesagem "  ,'ExecBlock("AD0060")'   , 0 , 3},;



EndFilBrw("ZV2",aIndSZ9)
Return