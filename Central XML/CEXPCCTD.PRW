#INCLUDE "Totvs.ch"
#INCLUDE "PROTHEUS.CH"
#Include "RwMake.ch"
#Include "topconn.ch"
#INCLUDE "FILEIO.CH"
#INCLUDE "TBICONN.CH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CEXPCCTD  �Autor  �Abel Babini Filho   � Data �  21/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Tela do Painel Fiscal                                      ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
���Chamado   �                                                            ���
���Interno TI�Tolerancia no recebimento de Frete-Abel Babini - 08/07/2019 ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CEXPCCTD
	Local lRetorno	:= .T.
	Local nPTot		:= 0
	Local nPPed		:= 0
	Local nRegSC7	:= SC7->(RecNo())
	Local nVlTCTe	:= 0
	Local nVlTPed	:= 0
	Local nVlTol	:= GETMV("MV_#TOLCTE",,0)
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'CENTRALXML- P.E Tela do Painel Fiscal   ')
	
	 
	For i:=1 to Len(aHeader)
		IF aHeader[i,2]=="XIT_TOTNFE"
			nPTot	:= i
		ENDIF
		IF aHeader[i,2]=="XIT_PEDIDO"
			nPPed	:= i
		ENDIF
	Next i
	
	For i:=1 to len(aCols)
		nVlTCTe += aCols[i,nPTot]
	Next i
	
	While !SC7->(eof()) .AND. SC7->C7_NUM == aCols[1,nPPed]
		nVlTPed += SC7->C7_TOTAL
		SC7->(dbSkip())
	EndDo
	SC7->(dbGoTo(nRegSC7))
	
	IF Abs(nVlTCTe - nVlTPed) > nVlTol
		lRetorno := .F.
	ELSE
		lRetorno := .T.
	ENDIF
	
Return lRetorno