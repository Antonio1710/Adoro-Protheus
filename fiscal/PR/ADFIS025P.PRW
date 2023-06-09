
#include "protheus.ch"
#include "topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADFIS025P �Autor  �Fernando Macieira   � Data �  04/23/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao para consistir especies que serao permitidas via    ���
���          � rotina pre-nota e documento de entrada                     ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ADFIS025P()

Local lRet    := .T.

Local cEspBlq := GetMV("MV_#NFEESP",,"CTE#SPED")
Local cEmpAut := GetMV("MV_#NFEEMP",,"")
Local cLogAut := GetMV("MV_#NFEUSR",,"")

Local cSpecLo := IIF(AllTrim(FunName()) == "MATA116",c116Especie,cEspecie) //fernando sigoli Chamado: 041718 18/05/2018 

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Funcao para consistir especies que serao permitidas via rotina pre-nota e documento de entrada')

// N�o validar qdo central xml
If !IsInCallStack("CENTNFEXM")
	
	// Consisto especies nao permitidas
	If AllTrim(cSpecLo) $ cEspBlq
		
		// Consisto as empresas/filiais que n�o dever�o sofrer consist�ncias
		If !(cEmpAut $ AllTrim(cEmpAnt)+"/"+AllTrim(cFilAnt))
			
			// Consisto o login que poder� incluir manualmente sem bloqueio
			If !(cLogAut $ AllTrim(__cUserID))
				
				// Validar somente no DOCUMENTO ENTRADA
				If AllTrim(FunName()) == "MATA103" .or. AllTrim(FunName()) == "MATA116"
				
					lRet := .F.
					
					// Aviso ao usuario
					Aviso(	"ADFIS025P-01",;
					"Esp�cie n�o permitida por esta rotina... Utilize a Central XML ou PR�-NOTA!" + chr(13) + chr(10) +;
					"" + chr(13) + chr(10) +;
					"" ,;
					{ "&OK" },,;
					"Esp�cie n�o permitida" )
				
				EndIf

			EndIf
			
		EndIf
		
	EndIf
	
EndIf


Return lRet
