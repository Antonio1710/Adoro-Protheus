#include "rwmake.ch"  

User Function AD0063()

SetPrvt("CCADASTRO,AROTINA,")

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Menu para Controle dos Fretes')

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� AD0063   � Menu para Controle dos Fretes                              ���
���          �                                                            ���
���          � Especifico Ad'oro Alimenticia                              ���
�������������������������������������������������������������������������͹��
��� Werner   � 28/08/03 - Uso Logistica                                   ���
�������������������������������������������������������������������������͹��
���MANUTENCAO�NUMERO �Autor - Descricao              � Data               ���
�������������������������������������������������������������������������͹��
���Desc.     �[1]     DANIEL    Removido o filtro na Tabela      17/01/07 ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/



//Removido Daniel [1]
// Parametro do Filtro
//_nFiltFV := Getmv("MV_FRETAB")


dbSelectArea("SZK")
dbSetOrder(08)
dbGoTop()

CCadastro := "Controle de Frete  "
aRotina := { { "Pesquisar   "  ,"AxPesqui"                 , 0 , 1},;
              { "Visualizar  "  ,"axVisual"                 , 0 , 2},;
              { "Incluir     "  ,"axInclui"                 , 0 , 3},;
              { "Alterar     "  ,"axAltera"                 , 0 , 4},;
              { "Exclui      "  ,'ExecBlock("AD0068")'      , 0 , 5},;
              { "Consulta    "  ,'ExecBlock("AD0071")'      , 0 , 6}}


//Removido Daniel [1]
// +-----------------------------------+
// | Cria Filtro para o mBrowse        |
// +-----------------------------------+
/*
Private aIndSZK   := {}
Private bFiltraBrw := {|| Nil}                          
cCondicao  := xFilial("SZK") + Alltrim(_nFiltFV) 
bFiltraBrw := {|| FilBrowse("SZK",@aIndSZK,@cCondicao)}
Eval(bFiltraBrw)
*/           

mBrowse( 6, 1,22,75,"SZK")

dbSelectArea("SZK")
dbSetOrder(08)

//Removido Daniel [1]
//������������������������������������������������������������������������Ŀ
//� Deleta o filtro utilizando a funcao FilBrowse                     	   �
//��������������������������������������������������������������������������
//EndFilBrw("SZK",aIndSZK)


Return
