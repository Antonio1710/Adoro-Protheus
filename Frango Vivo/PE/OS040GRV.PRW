#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OS040GRV  � Autor � MAURICIO - MDS TEC � Data �  23/06/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Grava campo customizado para integracao SAG                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ADORO                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function OS040GRV()
Local _aArea := GetArea()


U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Grava campo customizado para integracao SAG')


If INCLUI					
   Reclock("DA4",.F.)
	  DA4->DA4_XINTEG := "I"  &&alteracao		
   DA4->(MsUnlock())	
Endif

RestArea(_aArea)
Return(.T.)