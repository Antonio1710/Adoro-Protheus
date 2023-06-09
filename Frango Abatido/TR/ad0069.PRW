
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���MANUTENCAO�AD0069    �Autor  �DANIEL              � Data �  10/31/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � REMOVIDO 'SET FILTER'                                                           ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

#include "rwmake.ch"  

User Function AD0069   

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'REMOVIDO SET FILTER')

SetPrvt("CCADASTRO,AROTINA,")

/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������--����������������������������������������������������������Ŀ��
��� ADO0069.PRW    � Programa de interface da Balanca Rodoviaria Portaria    ���
���                � Saida das Pesagens Diversas.                            |��
���                � O Advanced Protheus nao contempla esta op�ao            |��
���                � Especifico Ad'oro Alimenticia                           ���
������������--��������������������������������������������������������������Ĵ��
��� Werner/Gustavo � 16/09/03 �                                              ���
��������������--�������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
Static _cTipPes  := "A"
Public _cEntrada := "S"


dbSelectArea("ZV2")
dbSetOrder(01)  
Private aIndSZ9    := {}   
Private bFiltraBrw := {|| Nil}
//Set Filter to ZV2_TIPOPE == _cTipPes .AND. ZV2_ENTSAI == _cEntrada
cCondicao  := " ZV2->ZV2_TIPOPE == '"+_cTipPes+"' .AND. ZV2->ZV2_ENTSAI == '"+_cEntrada+"' "
bFiltraBrw := {|| FilBrowse("ZV2",@aIndSZ9,@cCondicao)}
Eval(bFiltraBrw)


CCadastro := "Pesagem Diversas (Saidas) - Balanca  "
aRotina := {  { "Pesquisar  "   ,"AxPesqui"              , 0 , 1},;
              { "Visualizar  "  ,"axVisual"              , 0 , 2},;
              { "1a. Pesagem "  ,'U_AD0060("S")', 0 , 3},;
              { "2a. Pesagem "  ,'ExecBlock("AD0070",)'   , 0 , 4},;                      
              { "Imprimir Guia" ,'ExecBlock("AD0156")'  , 0 , 5} }

mBrowse( 6, 1,22,75,"ZV2")
//{ "1a. Pesagem "  ,'ExecBlock("AD0060",)'   , 0 , 3},;


EndFilBrw("ZV2",aIndSZ9)
Return

