#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AXSZI    � Autor � Gustavo Gonela     � Data �  19/12/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Lancamentos de Descontos e Acrescimos                      ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Logistica                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AXSZI


//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.

Private cString := "SZI"

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Lancamentos de Descontos e Acrescimos')

dbSelectArea("SZI")
dbSetOrder(4)

AxCadastro(cString,"Lancamentos de Descontos e Acrescimos",cVldAlt,cVldExc)

Return
