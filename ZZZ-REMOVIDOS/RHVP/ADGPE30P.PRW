#include "protheus.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CESTAB    �Autor  �Fernando Macieira   � Data � 09/02/2018  ���
�������������������������������������������������������������������������͹��
���Desc.     � Formula U_CESTAB                                           ���
���          � Apaga verbas de cesta basica de acordo com as regras       ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function CESTAB()

Local aAreaSRC, aAreaRGB, aAreaAtu
Local lFalta    := .f.
Local nQtdHoras := 0

// Regra - hora m�nima para exclusao
Local nRef := 2.01

// Verbas envolvidas
Local cPDFalta := "409" // Verba 409 (Falta - Desconto)
Local cPDCesta := "441" // Verba 441 (Cesta B�sica - Desconto)
Local cPDBase  := "770" // Verba 770 (Cesta B�sica - Base)
Local cPDEmp   := "788" // Verba 788 (Cesta B�sica Parte Empresa - Base)

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Apaga verbas de cesta basica de acordo com as regras')

// Checa empresa e filial permitida
//If cEmpAnt == "01" .and. AllTrim(SRA->RA_FILIAL) == "02"
If (cEmpAnt == "01" .and. AllTrim(SRA->RA_FILIAL) == "02") .OR. (cEmpAnt == "02")  // Alterado por Adriana para atender Ceres -  chamado 040408
	
	aAreaSRC  := SRC->( GetArea() )
	aAreaRGB  := RGB->( GetArea() )
	aAreaAtu  := GetArea()
	
	// Funcion�rio possui falta
	RGB->( dbSetOrder(1) ) // RGB_FILIAL+RGB_MAT+RGB_PD+RGB_PERIOD+RGB_SEMANA+RGB_SEQ
	If RGB->( dbSeek(xFilial("RGB")+SRA->RA_MAT+cPDFalta) )
		
		// Referencia em Horas
		If AllTrim(RGB->RGB_TIPO1) == "H"
			lFalta := .t.
			nQtdHoras := RGB->RGB_HORAS
		EndIf
	
	EndIf
	
	If !lFalta
		SRC->( dbSetOrder(1) )   // RC_FILIAL+RC_MAT+RC_PD+RC_CC+RC_SEMANA+RC_SEQ
		If SRC->( dbSeek(xFilial("SRC")+SRA->RA_MAT+cPDFalta) )
			
			// Referencia em Horas
			If AllTrim(SRC->RC_TIPO1) == "H"
				lFalta := .t.          
				nQtdHoras := RGB->RGB_HORAS
			EndIf
		
		EndIf
	
	EndIf
	
	
	If lFalta
		
		// Minimo para dele��o das verbas
		If nQtdHoras > nRef
			
			// Apaga as verbas - Tabela SRC
			fDelPd(cPDCesta)
			fDelPd(cPDBase)
			fDelPd(cPDEmp)
			
			
			// Apaga verbas - Tabela RGB
			RGB->( dbSetOrder(1) ) // RGB_FILIAL+RGB_MAT+RGB_PD+RGB_PERIOD+RGB_SEMANA+RGB_SEQ
			
			// Cesta Basica - Desconto
			If RGB->( dbSeek(xFilial("RGB")+SRA->RA_MAT+cPDCesta) )
				RecLock("RGB", .f.)
					RGB->( dbDelete() )
				RGB->( msUnLock() )
			EndIf
			
			// Cesta Basica - Base
			If RGB->( dbSeek(xFilial("RGB")+SRA->RA_MAT+cPDBase) )
				RecLock("RGB", .f.)
					RGB->( dbDelete() )
				RGB->( msUnLock() )
			EndIf
			
			// Cesta Basica - Empresa
			If RGB->( dbSeek(xFilial("RGB")+SRA->RA_MAT+cPDEmp) )
				RecLock("RGB", .f.)
					RGB->( dbDelete() )
				RGB->( msUnLock() )
			EndIf
			
		EndIf
		
	EndIf
	
	RestArea( aAreaAtu )
	RestArea( aAreaRGB )
	RestArea( aAreaSRC )
	
EndIf


Return