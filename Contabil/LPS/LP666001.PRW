#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP666001  �Autor  �Fernando Macieira   � Data � 18/06/2019  ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao chamada no LP 666-001 no campo CT5_CCD              ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������͹��
���Chamado   � 049848 || OS 051136 || CONTROLADORIA || DANIELLE_MEIRA     ���
���          � || 8459 || LP 666-001 - FWNM - 18/06/2019                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function LP666001()
                   
	Local cRet := ""

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	If AllTrim(SD3->D3_LOCAL) == "A624"
		cRet := "7134"
	
	ElseIf AllTrim(SD3->D3_LOCAL) == "D609"
		cRet := "7140"
	
	ElseIf AllTrim(SD3->D3_LOCAL) == "GF01"
		cRet := "7515"

	ElseIf AllTrim(SD3->D3_LOCAL) == "GF02"
		cRet := "7525"
		
	ElseIf AllTrim(SD3->D3_LOCAL) == "GF03"
		cRet := "7535"
		
	ElseIf AllTrim(SD3->D3_LOCAL) == "G961"
		cRet := "7543"

	ElseIf AllTrim(SD3->D3_LOCAL) == "MARL"
		cRet := "7551"
                     
	ElseIf AllTrim(SD3->D3_LOCAL) == "P0102"
		cRet := "7615"

	ElseIf AllTrim(SD3->D3_LOCAL) == "P0405"
		cRet := "7625"

	ElseIf AllTrim(SD3->D3_LOCAL) == "I019"
		cRet := "7660"
		
	Else
		cRet := "6110"

    EndIf

Return cRet