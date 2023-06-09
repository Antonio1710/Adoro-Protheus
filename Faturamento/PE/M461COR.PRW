#INCLUDE "PROTHEUS.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �M461COR   � Autor � ADRIANA            � Data �  07/08/08   ���
�������������������������������������������������������������������������Ĵ��
���Desc.     �Ponto de entrada para incluir botao de consulta ao pedido   ���
���          �de venda na tela de geracao da nota fiscal                  ���
���          �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Faturamento                                                 ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.          	  ���
�������������������������������������������������������������������������Ĵ��
���Programador� Data   � BOPS �  Motivo da Alteracao                  	  ���
�������������������������������������������������������������������������Ĵ��
���           �        �      �                                           ���
���           �        �      �                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function M461COR

    Local _ACOR := PARAMIXB 

    // ticket 84085 - 01/12/2022 - Fernando Macieira - TRANSFERENCIA DE ATIVO IMOBILIZADO nota fiscal n�o aparece no Faturamento
	If AllTrim(FUNNAME())=="ATFA060" .or. IsInCallStack("ATFA060")
		Return _ACOR
	EndIf
    
    AADD( aRotina, {"Pedido","U_VisPC", 0 , 2 , 0 , NIL} )  

Return _ACOR

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �VISPC     � Autor � ADRIANA            � Data �  07/08/08   ���
�������������������������������������������������������������������������Ĵ��
���Desc.     �Funcao para visualizar o pedido de venda na tela de geracao ���
���          �da nota fiscal. Devido a rotina padrao utilizar um alias    ���
���          �SC5 tivemos que reabrir a tabela para considerar todos os   ���
���          �campos                                                      ���
�������������������������������������������������������������������������Ĵ��
���Uso       �Faturamento                                                 ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.          	  ���
�������������������������������������������������������������������������Ĵ��
���Programador� Data   � BOPS �  Motivo da Alteracao                  	  ���
�������������������������������������������������������������������������Ĵ��
���           �        �      �                                           ���
���           �        �      �                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function VISPC

Local _AREASC5 := GETAREA("SC5")
Local _AREASC6 := GETAREA("SC6")  
Local _CHAVE := SC9->C9_PEDIDO  
Local _RECNO := 0
DbSelectArea("SC5")
DbCloseArea()

DbSelectArea("SC5")
DBSeek(XFILIAL("SC5")+_CHAVE)
_Recno := SC5->(Recno())

A410Visual("SC5",_RECNO,2)

RestArea(_AREASC5)
RestArea(_AREASC6)

Return
