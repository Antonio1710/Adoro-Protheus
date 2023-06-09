#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F450FIL1  �Autor  �Fernando Macieira   � Data �   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada F450FIL1, utilizado na compensacao entre  ���
���          � Carteiras. Decisao de desenvolver para nao depender do F12.���
�������������������������������������������������������������������������͹��
���Chamado   � 048895 || OS 050173 || FINANCAS || LIGIA || 8479 ||        ���
���          � || COMPENSACOES X BORDEAP                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*/{Protheus.doc} User Function F450FIL1
	Descricao �Ponto de Entrada F450FIL1, utilizado na compensacao entre
	Carteiras. Decisao de desenvolver para nao depender do F12.			
	@type  Function
	@author Fernando Macieir
	@since 29/07/2019
	@version 01
	@history Chamado 048895 || OS 050173 || FINANCAS || LIGIA || 8479 || || COMPENSACOES X BORDEAP. 
	@history Ticket  9080 - Leonardo P. Monteiro - 05/02/2021 - Adiciona ao filtro a condi��o se j� houve a compensa��o do border� no t�tulo. Assim, possibilita a compensa��o entre carteiras do saldo restante.
	/*/
User Function F450FIL1()

	Local c450Fil := ""
	//Ticket  9080 - Leonardo P. Monteiro - 05/02/2021 - Adiciona ao filtro a condi��o se j� houve a compensa��o do border� no t�tulo. Assim, possibilita a compensa��o entre carteiras do saldo restante.                                             
	//c450Fil += " AND SE2.E2_NUMBOR='' "
	c450Fil += " AND (SE2.E2_NUMBOR  = '' OR " 
	c450Fil += " 	 (SE2.E2_NUMBOR != '' "
	c450Fil += " 		AND EXISTS(SELECT SE5.E5_DOCUMEN "
	c450Fil += " 				   FROM "+ RetSqlName("SE5") +" SE5 "
	c450Fil += " 				   WHERE SE5.D_E_L_E_T_='' AND SE5.E5_FILIAL=SE2.E2_FILIAL AND SE5.E5_PREFIXO=SE2.E2_PREFIXO AND SE5.E5_NUMERO=SE2.E2_NUM AND "
	c450Fil += " 						 SE5.E5_PARCELA=SE2.E2_PARCELA AND SE5.E5_TIPO=SE2.E2_TIPO AND SE5.E5_CLIFOR=SE2.E2_FORNECE AND SE5.E5_LOJA=SE2.E2_LOJA AND "
	c450Fil += " 						 SE5.E5_DOCUMEN=SE2.E2_NUMBOR AND SE5.E5_SITUACA=''))) "

Return c450Fil
