#INCLUDE "rwmake.ch"

/*/XX
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Ado0001   � Autor � Gustavo Gonela     � Data �  20/11/02   ���
�������������������������������������������������������������������������͹��
���Descricao � Programa para cadastro de Supervisores                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Area Comercial                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function axszr

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Programa para cadastro de Supervisores')

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cString
cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZR"

dbSelectArea("SZR")
dbSetOrder(1)

AxCadastro(cString,"Cadastro de Supervisores",cVldAlt,cVldExc)

Return
