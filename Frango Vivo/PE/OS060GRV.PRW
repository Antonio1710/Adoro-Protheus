#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OS060GRV  � Autor � MAURICIO - MDS TEC � Data �  23/06/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Grava campo customizado para integracao entre Sistemas     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ADORO                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function OS060GRV()
Local _aArea := GetArea()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'ampo customizado para integracao entre Sistemas')


If INCLUI					
   Reclock("DA3",.F.)
	  DA3->DA3_XINTEG := "I"  &&alteracao		
   DA3->(MsUnlock())	
Endif

RestArea(_aArea)
Return(.T.)