#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AXFV2     � Autor � Gustavo Gonela     � Data �  11/01/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Balanca                                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP5 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXFV2 

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Balanca')


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cString
cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

_cNum   := space(6) // Numero da Guia de Pesagem
_cTipo  := space(1) // Tipo da Pesagem

Private cString := "ZV2"

dbSelectArea("ZV2")
dbSetOrder(1)

AxCadastro(cString,"Pesagem Manual",cVldAlt,cVldExc)

Return
 
