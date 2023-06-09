#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �TESTE     �Autor  �Fernando Macieira   � Data �  05/15/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Inicializador padrao D3_DOC                                ���
���          � Chamado 040287                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
?�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ADEST029P()

	Local cQuery   := ""
	Local cAnoMes  := ""
	Local cNextCod := ""
	Local cNextSeq := "00001"

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Inicializador padrao D3_DOC')
	
	// *** INICIO CHAMADO WILLIAM COSTA - 13/06/2018 - 041928 || CONTROLADORIA || DANIELLE_MEIRA || D3_DOC DIVERGENTE *** //
	IF ALLTRIM(FUNNAME()) == 'MATA185' // Baixa de Solicitacao ao Armazem
	
		cNextCod := SCP->CP_NUM
	
		Return cNextCod
	
	ENDIF
	// *** FINAL CHAMADO WILLIAM COSTA - 13/06/2018 - 041928 || CONTROLADORIA || DANIELLE_MEIRA || D3_DOC DIVERGENTE *** //
	
	cAnoMes := Subs(AllTrim(DtoS(dDataBase)),3,2) + Subs(AllTrim(DtoS(dDataBase)),5,2)
	
	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf
	
	cQuery := " SELECT MAX(D3_DOC) AS NEXT_DOC "
	cQuery += " FROM " + RetSqlName("SD3")
	cQuery += " WHERE D3_DOC LIKE '"+cAnoMes+"%' "
	cQuery += " AND D_E_L_E_T_='' "
	
	tcQuery cQuery New Alias "Work"
	
	Work->( dbGoTop() )
	
	If !Empty(Work->NEXT_DOC)
		cNextCod := Soma1(Work->NEXT_DOC)
	Else
		cNextCod := cAnoMes + cNextSeq
	EndIf
	
	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf

Return cNextCod