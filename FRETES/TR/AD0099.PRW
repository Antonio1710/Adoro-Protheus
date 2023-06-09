#INCLUDE "rwmake.ch"
/*
��������������������������������������������������������������������������
��������������������������������������������������������������������������
����������������������������������������������������������������������ͻ��
���MANUTENCAO|Autor  � DANIEL PITTHAN SILVEIRA    � Data �  10/27/06   ���
����������������������������������������������������������������������͹��
���Desc.     �ALTERADO O 'SET FILTER' PELO FILTRO DA MICROSIGA         ���
���          �                                                         ���
����������������������������������������������������������������������͹��
���Uso       � AP                                                      ���
����������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������
��������������������������������������������������������������������������
*/
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AD0099    � Autor � HERALDO C.HEBLING  � Data �  16/02/04   ���
�������������������������������������������������������������������������͹��
���Descricao � Este programa tem a finalidade de possibilitar a inclusao  ���
���          � de solicitacoes de PAGAMENTO ANTECIPADO, para pagamento    ���
���          � de Transportadoras                                         ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Sistema de controle de fretes                              ���
�������������������������������������������������������������������������Ĵ��
���REVISAO   � Revidado por Daniel 23/10/06 - removido o SET FILTER       |��
���			 � 															  |��
���   		 � 															  |��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function AD0099

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Este programa tem a finalidade de possibilitar a inclusao de solicitacoes de PAGAMENTO ANTECIPADO, para pagamento de Transportadoras')

cPerg   := "AD0099"
Pergunte(cPerg,.T.)
//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := "Solicitacao de Pagamentos Antecipados"

aCores := { { 'Z9_STATUS = "1"    ', 'ENABLE'      },;  // Cores padroes do semaforo
			{ 'Z9_STATUS = "2"    ', 'BR_AZUL'     },;  // Verde - ENABLE - Vermelho DISABLE
			{ 'Z9_STATUS = "3"    ', 'DISABLE'     }}

//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Private aRotina := {{"Pesquisar","AxPesqui",0,1} ,;
					{"Visualizar","AxVisual",0,2} ,;
					{"Incluir","AxInclui",0,3} ,;
					{"Alterar","U_AD0104",0,4} ,;
					{"Excluir","U_AD0105",0,5},;
					{"Legenda","U_AD0101",0,6} }

Private cDelFunc := ".T."
Private cString := "SZ9"
Private aIndSZ9    := {}
Private bFiltraBrw := {|| Nil}

If mv_par01==1
	dbSelectArea("SZ9")
	dbSetOrder(1)
	//Set filter to Z9_STATUS == "1"
	
	//���������������������������������������������������������Ŀ
	//�FILTRO DA MICROSIGA + R�PIDO                             �
	//�����������������������������������������������������������
	
	cCondicao  := " Z9_STATUS == '1' "
	bFiltraBrw := {|| FilBrowse("SZ9",@aIndSZ9,@cCondicao)}
	Eval(bFiltraBrw)
	
Else
	dbSelectArea("SZ9")
	dbSetOrder(1)
Endif

dbSelectArea(cString)
mBrowse( 6,1,22,75,cString,,,,,, aCores)

//������������������������������������������������������������������������Ŀ
//� Deleta o filtro utilizando a funcao FilBrowse                     	   �
//��������������������������������������������������������������������������
EndFilBrw("SZ9",aIndSZ9)

//SET FILTER TO
Return
