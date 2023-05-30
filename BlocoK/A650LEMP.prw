/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �A650LEMP  �Autor  �Microsiga           � Data �  02/24/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Altera o local do empenho para o almoxarifado 02            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
@history ticket TI - Antonio Domingos - 17/05/2023 - Ajuste Nova Empresa
@history ticket TI - Antonio Domingos - 22/05/2023 - Revis�o Ajuste Nova Empresa
*/

User Function A650LEMP

Local cAlEst  := GetMv('MV_X_ALPRO',.F.,"03")
Private _cEmpFL1 := SuperGetMv("MV_#EMPFL1",.F.,"0102/1301") //Codigo de Empresas+Filiais Ativas Grupo 1 //ticket TI - Antonio Domingos - 17/05/2023

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Altera o local do empenho para o almoxarifado 02')

If !(alltrim(cEmpant)+alltrim(cFilant) $ _cEmpFL1) //ticket TI - Antonio Domingos - 17/05/2023
	cAlEst := SB1->B1_LOCPAD
EndIf   

Return PadR(cAlEst,(TamSX3("D3_LOCAL")[1]))
