#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F090TIPO  �Autor  �Fernando Macieira   � Data � 23/09/2019  ���
�������������������������������������������������������������������������͹��
���Desc.     � Este ponto de entrada permitir� selecionar quais tipos de  ���
���          � t�tulos ser�o desconsiderados na baixa a pagar autom�tica. ���
���          � Com a utiliza��o deste ponto de entrada, o filtro da rotina���
���          � ir� respeitar somente o que for retornado da user function.���
�������������������������������������������������������������������������͹��
���Uso       � Chamado n. 051715 || OS 053037 || FINANCAS || ANA || 8384  ���
���          � || BAIXA EM LOTE                                           ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F090TIPO()

	Local cNewTp := GetMV("MV_#CPBXAU",,"PA|NDF")
	Local cTipos := ParamIxb[1]
	
	cTipos += "|" + cNewTp //SERAO DESCONSIDERADOS
	
Return cTipos