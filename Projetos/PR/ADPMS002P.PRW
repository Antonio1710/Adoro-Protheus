#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPMS002P �Autor  �Fernando Macieira   � Data �  01/05/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para efetuar automaticamente o rateio dos projetos  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ADPMS002P(cCodPrj, cRevisa, nValor)

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Rotina para efetuar automaticamente o rateio dos projetos')

// Popula Cab. Rateio Prj - ZCD
RecLock("ZCD", .T.)

	ZCD->ZCD_FILIAL := xFilial("ZCD")
	ZCD->ZCD_PROJET := cCodPrj
	ZCD->ZCD_REVISA := cRevisa
	ZCD->ZCD_VALOR  := nValor
	
ZCD->( msUnLock() )


// Popula Itens Rateio Prj - ZCE
RecLock("ZCE", .T.)

	ZCE->ZCE_FILIAL := xFilial("ZCE")
	ZCE->ZCE_PROJET := cCodPrj
	ZCE->ZCE_REVISA := cRevisa
	ZCE->ZCE_VALOR  := nValor
	ZCE->ZCE_PERIOD := AnoMes(msDate())
	ZCE->ZCE_DETAIL := "[ DISTRIBUICAO EFETUADA AUTOMATICAMENTE - ADPMS002P ]"
	
ZCE->( msUnLock() )


Aviso(	"ADPMS002P-01",;
"Distribui��o realizada automaticamente! " + chr(13) + chr(10) + "Caso desejar realizar manualmente a distribui��o dos valores nos per�odos v� em: " + chr(13) + chr(10) + "[ Projetos -> Gerenciamento de Projetos -> A��es Relacionadas -> Cronograma Financeiro ]...",;
{ "&OK" },,;
"Cronograma Financeiro Autom�tico - Projetos" )


Return
