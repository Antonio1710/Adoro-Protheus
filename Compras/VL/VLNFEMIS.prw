#include "rwmake.ch" 

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � VLNFEMIS � Autor � ADRIANA OLIVEIRA   � Data �  26/05/2014 ���
�������������������������������������������������������������������������͹��
���Item      � VALIDACAO DATA DE EMISSAO NFE                              ���
�������������������������������������������������������������������������͹��
���Descri��o � Preenche corretamente a natureza quando nota de devolucao  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Ad'oro                                          ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function VLNFEMIS

   // ticket 84085 - 01/12/2022 - Fernando Macieira - TRANSFERENCIA DE ATIVO IMOBILIZADO nota fiscal n�o aparece no Faturamento
	If AllTrim(FUNNAME())=="ATFA060" .or. IsInCallStack("ATFA060")
		Return .t.
	EndIf

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

	if FunName() = "MATA103"  // Documento de Entrada
		if cTipo $ "DB" .and. l103Class
			_cNat := Posicione("SA1",1,xFilial("SA1")+ca100for+cloja,"A1_NATUREZ")
			MaFisAlt("NF_NATUREZA",_cNat)
		endif       
	Endif

Return .t.
