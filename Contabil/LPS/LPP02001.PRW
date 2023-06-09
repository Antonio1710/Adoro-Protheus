#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LPP02001  �Autor  �Fernando Macieira   � Data �  17/10/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina baixa provisao por transferencia.                   ���
���          � Devera executar apenas quando transf entre empresa.        ���
���          � Chamado n. 043889 (Monik e Tamires - Controladoria)        ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

Par�metro: MV_TRFAMES (http://tdn.totvs.com/pages/releaseview.action?pageId=364914692)

Verbas necess�rias:
F�rias - Baixa Transfer�ncias � (Opcionais)
0239 - Valor Provis�o (783)
0260 � Adicional (784)
0261 - Um Ter�o (785)
0240 � INSS (786)
0241 � FGTS (787)

13 - Baixa Transfer�ncias � (Opcionais)
0270 - Valor Provis�o (811)
0271 � Adicional (812)
0272 � INSS (813)
0273 � FGTS (814)

*/

User Function LPP02001()

Local nVlr     := 0
Local cQuery   := ""
Local cSitFolh := ""
Local aAreaSRA := SRA->( GetArea() )

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')


If AllTrim(SRZ->RZ_MAT) == "zzzzzz" // Contabiliza��o por CC
	
	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf
	
	cQuery := " SELECT RZ_FILIAL, RZ_MAT "
	cQuery += " FROM " + RetSqlName("SRZ")
	cQuery += " WHERE RZ_FILIAL='"+SRZ->RZ_FILIAL+"' "
	cQuery += " AND RZ_CC='"+SRZ->RZ_CC+"' "
	cQuery += " AND RZ_PD='"+SRZ->RZ_PD+"' "
	cQuery += " AND RZ_TIPO='"+SRZ->RZ_TIPO+"' "
	cQuery += " AND RZ_TPC='"+SRZ->RZ_TPC+"' "
	cQuery += " AND RZ_MAT<>'zzzzzz' "
	cQuery += " AND D_E_L_E_T_='' "
	
	tcQuery cQuery New Alias "Work"
	
	Work->( dbGoTop() )
	
	If Work->( !EOF() )
		cSitFolh := Posicione("SRA", 1, Work->RZ_FILIAL+Work->RZ_MAT, "RA_SITFOLH")
		
		If cSitFolh == "D" .and. ExistSRE(Work->RZ_FILIAL, Work->RZ_MAT)
			nVlr := Abs(SRZ->RZ_VAL)
		EndIf
		
	EndIf
	
Else // Contabilizacao por matricula
	cSitFolh := Posicione("SRA", 1, SRZ->RZ_FILIAL+SRZ->RZ_MAT, "RA_SITFOLH")
	
	If cSitFolh == "D" .and. ExistSRE(SRZ->RZ_FILIAL, SRZ->RZ_MAT)
		nVlr := Abs(SRZ->RZ_VAL)
	EndIf
	
EndIf

If Select("Work") > 0
	Work->( dbCloseArea() )
EndIf

RestArea( aAreaSRA )

Return nVlr



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LPP02001  �Autor  �Microsiga           � Data �  10/17/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para verificar se o funcionario foi transferido     ���
���          � entre empresas.                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ExistSRE(cRZ_FILIAL, cRZ_MAT)

Local lRet   := .f.
Local cQuery := ""

If Select("WorkSRE")
	WorkSRE->( dbCloseArea() )
EndIf

cQuery := " SELECT RE_EMPD, RE_EMPP "
cQuery += " FROM " + RetSqlName("SRE")
cQuery += " WHERE RE_FILIAL='"+FWxFilial("SRE")+"' "
cQuery += " AND RE_EMPD='"+cEmpAnt+"' "
cQuery += " AND RE_FILIALD='"+cRZ_FILIAL+"' "
cQuery += " AND RE_MATD='"+cRZ_MAT+"' "
cQuery += " AND D_E_L_E_T_='' "

tcQuery cQuery New Alias "WorkSRE"

WorkSRE->( dbGoTop() )

If WorkSRE->( !EOF() )
	If WorkSRE->RE_EMPD <> WorkSRE->RE_EMPP
		lRet := .t.
	EndIf
EndIf

If Select("WorkSRE")
	WorkSRE->( dbCloseArea() )
EndIf

Return lRet
