#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F110BTOK  �Autor  �Fernando Macieira   � Data � 09/09/2019  ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para consistir a data da baixa            ���
���          � Parametros MV_BXDTFIN + MV_DATAFIN n�o atenderam no padrao!���
�������������������������������������������������������������������������͹��
���Chamado   � n. 051017 - Desenvolver tratativa no estorno e             ���
���          � cancelamento na mesma data da baixa - TI - FWNM - 09/09/19 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F110BtOK()

	Local lRet := .t.
	Local dDataFin := GetMV("MV_DATAFIN")
	
	If dDataBase < dDataFin
		lRet := .f.
		Aviso("F110BTOK-01", "Baixa n�o permitida! Financeiro bloqueado nesta data. Ajuste a database ou contate o departamento financeiro...",{"OK"},, "MV_DATAFIN: " + DtoC(dDataFin))
	EndIf

Return lRet