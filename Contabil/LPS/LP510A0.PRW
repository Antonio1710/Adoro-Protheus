
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP 510 031� Autor �Mauricio - HC Consys� Data � 26/06/09    ���
�������������������������������������������������������������������������͹��
���Desc.     � Utilizado LP 510-001 - Chamado 004469 - Rosana             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
@history chamado 63633 - Leonardo P. Monteiro - 012/11/2021 - Corre��o dos valores em segunda moeda.
*/

User Function LP510A0()                 
Local nVlrTmp  := 0
Local _nValor  := 0

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

IF !(AllTrim(SE2->E2_NATUREZ)$"20820/22817/22301/22318/22402/20828/20827") .AND.; 
     SE2->E2_MULTNAT<>"1" .AND.; 
   !ALLTRIM(SE2->E2_TIPO)$"AB-/LEA/GIR/RUR/NF/TX/INS/ISS/RJ" .AND.; 
   !SE2->E2_PREFIXO$"GPE"


   nVlrTmp := iif(SE2->E2_MOEDA==1,SE2->E2_VALOR, SE2->E2_VLCRUZ)
   _nValor := nVlrTmp
Else
   _nValor := 0
Endif       

Return(_nValor)

