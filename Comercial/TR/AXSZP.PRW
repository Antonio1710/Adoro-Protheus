#INCLUDE "rwmake.ch"

user function AXSZP   

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'AxCadastro em SZP - REGIOES DOS SEGMENTOS DE MERCADO')

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AXSZP    � Autor � Rogerio Eduardo Nutti � Data � 27/09/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � AxCadastro em SZP - REGIOES DOS SEGMENTOS DE MERCADO       ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Adoro Alimenticia                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
AxCadastro("SZP","Regioes dos Segmentos de Mercado")     

Return



