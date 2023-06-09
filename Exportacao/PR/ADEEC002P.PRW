#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ADEEC002P  �Autor  �Fernando Macieira   � Data �  07/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Utilizado no X3_VLDUSER do campo YE_VLFISCA e tambem  no   ���
���          � X3_WHEN d campo YE_TX_COMP                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
���versionamento:                                                         ���
���Everson - 28/01/2019. Chamado 046725. Removida valida��o de PTAX       ���
���menor que a taxa fiscal.                                               ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ADEEC002P()

	Local lRet := .t.
	Local cMoeda := M->YE_MOEDA
	Local nTaxa  := M->YE_VLCON_C
	Local nTxFis := M->YE_VLFISCA

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Utilizado no X3_VLDUSER do campo YE_VLFISCA e tambem  no X3_WHEN d campo YE_TX_COMP')
	
	/*
	criar uma trava para as moedas US$ / EUR / EUV , colocando a condi��o que a PTAX das moedas sempre ser�o maiores e diferentes do que a TAXA FISCAL (1,0000) 
	CAMPO YE_VLCON_C > <> YE_VLFISCA
	*/
	
	If AllTrim(cMoeda) $ "US$#EUR#EUV"
		If nTaxa == nTxFis
			lRet := .f.
			Aviso("ADEEC002P-01", "PTAX n�o pode ser igual a taxa fiscal", {"&Ok"},, "Grava��o n�o permitida!")
		EndIf
	
		//Everson - 28/01/2019. Chamado 046725.
	/*	If lRet
			If nTaxa <= nTxFis
				lRet := .f.
				Aviso("ADEEC002P-02", "PTAX precisa ser maior que a taxa fiscal", {"&Ok"},, "Grava��o n�o permitida!")
			EndIf
		EndIf*/
		//
	
	EndIf

Return lRet