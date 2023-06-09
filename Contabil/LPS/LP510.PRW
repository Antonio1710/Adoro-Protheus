
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP 510 001� Autor �Mauricio - HC Consys� Data � 26/06/09    ���
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

User Function VL510001()                 
Local nVlrTmp  := 0
Local _nValor  := 0

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

If !SE2->E2_TIPO $ "AB-/LEA/GIR/CAM/RUR/FOL" .AND. SE2->E2_MULTNAT <> "1" .AND. !SE2->E2_PREFIXO $ "GPE/FIS" .AND. !SE2->E2_FORNECE == '001770' .AND. ALLTRIM(SE2->E2_NATUREZ) <> '22817'
   nVlrTmp := iif(SE2->E2_MOEDA==1,SE2->E2_VALOR, SE2->E2_VLCRUZ)
   _nValor := nVlrTmp+SE2->E2_IRRF+SE2->E2_INSS+SE2->E2_ISS+SE2->E2_PIS+SE2->E2_COFINS+SE2->E2_CSLL
Else
   _nValor := 0
Endif       

Return(_nValor)

