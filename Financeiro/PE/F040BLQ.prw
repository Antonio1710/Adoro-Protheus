#include "protheus.ch"

/*/{Protheus.doc} User Function F040BLQ
	PE Contas Receber
	@type  Function
	@author Fernando Macieira
	@since 20/03/2019
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 87598 - 03/02/2023 - Fernando Macieira - Exclus�o AB-
	@history ticket 87598 - 07/02/2023 - Fernando Macieira - Exclus�o AB-
/*/
User Function F040BLQ()

	Local lRet     := .t.
	Local dDataEmi := SE1->E1_EMISSAO 
	Local dDataFin := GetMV("MV_DATAFIN")
	Local cTipos   := GetMV("MV_#040BLQ",,"AB-") // @history ticket 87598 - 03/02/2023 - Fernando Macieira - Exclus�o AB-
	
	If INCLUI .or. ALTERA
		If dDataBase < dDataFin 
			lRet := .f.
			Aviso("F040BLQ-01", "Movimenta��o n�o permitida! Financeiro bloqueado nesta data. Mude a database ou contate o departamento financeiro...",{"OK"},, "MV_DATAFIN: " + DtoC(dDataFin))
		EndIf
	
	Else
		
		If dDataEmi < dDataFin 
			lRet := .f.
			//Aviso("F040BLQ-02", "Movimenta��o n�o permitida! Financeiro bloqueado nesta data. Contate o departamento financeiro...",{"OK"},, "MV_DATAFIN: " + DtoC(dDataFin))
		EndIf

		 // @history ticket 87598 - 07/02/2023 - Fernando Macieira - Exclus�o AB-
		If (AllTrim(SE1->E1_TIPO) $ cTipos) .and. AllTrim(SE1->E1_LA)<>"S"
			lRet := .t.
		EndIf

		If !lRet
			Aviso("F040BLQ-02", "Movimenta��o n�o permitida! Financeiro bloqueado nesta data. Contate o departamento financeiro...",{"OK"},, "MV_DATAFIN: " + DtoC(dDataFin))		
		EndIf
		//

	EndIf
	
Return lRet
