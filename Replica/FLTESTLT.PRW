#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FLTESTLT  �Autor  �Microsiga           � Data �  01/18/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para tratar a exclusao de lancamentos     ���
���          �contabeis em lote - SERVIDOR PRODUCAO.                      ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro - Utilizado no ambiente PRODUCAO                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FLTESTLT()

Local lRet := .t.
Local aParam	:= PARAMIXB
Local lServPR := GetMv("MV_#SERVPR",,.F.)
Local cProces := Posicione("SX5",1,Space(2)+"_X","X5_CHAVE")

If lServPR
	If cProces == "PROCES"
		lRet := .f.
		Aviso(	"Lan�amento Cont�bil",;
		"Este lancamento nao podera ser movimentado. Processamento SIG em andamento. Contate a Contabilidade.",;
		{"&Ok"},,;
		"Altera��o Inv�lida" )
		// msgStop("Processamento em andamento. Contate a Contabilidade!")
	EndIf
EndIf

Return lRet