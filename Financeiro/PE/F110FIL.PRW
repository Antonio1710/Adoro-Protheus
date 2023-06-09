#include "PROTHEUS.CH"
#include "TOPCONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �F110FIL   �Autor  �Fernando Macieira   � Data �  06/12/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para filtrar markbrowse na baixa em lote  ���
���          � automatica multifilial - CHAMADO N. 045499                 ���
�������������������������������������������������������������������������͹��
���Uso       � ADORO                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function F110FIL()

	Local cNewFiltro := ""
	
	Private cPerg    := "F110FIL"
	
	//+------------------------------------------------+
	//|Cria grupo de Perguntas                         |
	//+------------------------------------------------+
	//@history Ticket 70142  - Edvar / Flek Solution - 06/04/2022 - Retirada de fun��o PUTSX1
	//MontaPerg()
	
	Pergunte(cPerg, .T.)
	
	cNewFiltro += " E1_NUM BETWEEN '"+MV_PAR05+"' AND '"+MV_PAR06+"' "
	cNewFiltro += " AND E1_PORTADO BETWEEN '"+MV_PAR01+"' AND '"+MV_PAR02+"' "
	cNewFiltro += " AND EXISTS ( SELECT 'X' FROM " + RetSqlName("SA1") + " WHERE A1_COD=E1_CLIENTE AND A1_LOJA=E1_LOJA AND A1_CODRED BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"' " + " AND D_E_L_E_T_='' ) "
	
	Pergunte(cPerg, .F.)
	
	// Restauro pergunte padrao
	Pergunte( "FIN110", .F. )
	
Return cNewFiltro

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MontaPerg �Autor  �Fernando Macieira   � Data �  12/06/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria grupo de perguntas                                    ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Static Function MontaPerg()
//
//	Private bValid	:= Nil
//	Private cF3		:= Nil
//	Private cSXG	:= Nil
//	Private cPyme	:= Nil
//	
//	U_xPutSx1(cPerg,'01','Portador de          ?','','','mv_ch01','C',03,					  0,0,'G',bValid,"SA6BCO",cSXG,cPyme,'MV_PAR01')
//	U_xPutSx1(cPerg,'02','Portador at�         ?','','','mv_ch02','C',03,					  0,0,'G',bValid,"SA6BCO",cSXG,cPyme,'MV_PAR02')
//	U_xPutSx1(cPerg,'03','Rede de              ?','','','mv_ch03','C',06,					  0,0,'G',bValid,"SZF",   cSXG,cPyme,'MV_PAR03')
//	U_xPutSx1(cPerg,'04','Rede at�             ?','','','mv_ch04','C',06,					  0,0,'G',bValid,"SZF",   cSXG,cPyme,'MV_PAR04')
//	U_xPutSx1(cPerg,'05','T�tulo de            ?','','','mv_ch05','C',09,					  0,0,'G',bValid,"",      cSXG,cPyme,'MV_PAR05')
//	U_xPutSx1(cPerg,'06','T�tulo at�           ?','','','mv_ch06','C',09,					  0,0,'G',bValid,"",      cSXG,cPyme,'MV_PAR06')
//	U_xPutSx1(cPerg,'07','Hist�rico na Baixa   ?','','','mv_ch07','C',TamSX3("E5_HISTOR")[1],0,0,'G',bValid,"",     cSXG,cPyme,'MV_PAR07')
//	
//	Pergunte(cPerg, .F.)
//
//Return
