#include "rwmake.ch"
#include "topconn.ch"
/*/                                                 	
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Funcao    � ADVEN008P     � Autor � Mauricio - MDS TEC � Data �  16/09/15  ��
����������������������������������������������������������������������������Ĵ��
���Descricao � Tela de manutencao da tabela W1 do SX5 na filial 02           ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
���������������������������������������������������������������������������������
/*/

User Function ADVEN020P()
cCadastro := "Manutencao das Regioes Comerciais"
aAutoCab    := {}
aAutoItens  := {}
PRIVATE aRotina := { { "Pesquisar" ,  "AxPesqui"  , 0 , 1},;  // "Pesquisar"
       				  { "Visualizar",   "C160Visual", 0 , 2},;  // "Visualizar"
					  { "Incluir",   "C160Inclui", 0 , 3},;  // "Incluir"
					  { "Alterar",   "C160Altera", 0 , 4},;  // "Alterar"
					  { "Excluir",   "C160Deleta", 0 , 5} }  // "Excluir"

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Tela de manutencao da tabela W1 do SX5 na filial 02 ')
              					  
DbSelectArea("SX5")           
DbSetOrder(1)
If  !DbSeek(xFilial("SX5")+"W2",.F.)
   //MsgAlert(xFilial("SX5"))
   MsgAlert("Voce deve estar na filial 02(Varzea) para dar manuten��o nesta tabela!")
Else   
   c160altera("SX5",,3)
Endif
        
return()         