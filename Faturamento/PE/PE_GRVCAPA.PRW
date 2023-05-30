#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} User Function EECFAT2
	Ponto de entrada pra gravar SC5 a partir da Exportacao
	@type  Function
	@author user
	@since 06/11/2009
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function EECFAT2()    

	Local cParam := ""
	Local cVenEEC := GetMV("MV_#EECVEN",,"000443")
	
	IF Type("ParamIXB") == "C"
		cParam:= PARAMIXB
	Else
		cParam:= PARAMIXB[1]
	Endif

	If cParam == "PE_GRVCAPA"

		AADD(aCab,{"C5_MENNOTA",M->EE7_MENSG,nil})
		AADD(aCab,{"C5_MENNOT2",M->EE7_MENSG2,nil})
		AADD(aCab,{"C5_MENNOT3",M->EE7_MENSG3,nil})

		// @history ticket 88245 - 21/02/2023 - Fernando Macieira - PEDIDO EXPORTAÇÃO DE OVOS
		_lEEC := VldEEC()
		If _lEEC
			AADD(aCab,{"C5_VEND1",cVenEEC,nil})
		EndIf

	EndIf

Return()

/*/{Protheus.VldEEC() // @history ticket 88245 - 21/02/2023 - Fernando Macieira - PEDIDO EXPORTAÇÃO DE OVOS
	(long_description)
	@type  Static Function
	@author user
	@since 21/02/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function VldEEC() // @history ticket 88245 - 21/02/2023 - Fernando Macieira - PEDIDO EXPORTAÇÃO DE OVOS

	Local lTemOvo := .f.
	Local cOvoEEC := GetMV("MV_#EECOVO",,"342977")
	Local aAreaWork := {}

	If AllTrim(FunName()) == "EECAP100"

    	aAreaWork := WorkIt->( GetArea() )

		WorkIt->( dbGoTop() )

        Do While WorkIt->(!EOF())
            
			If AllTrim(WorkIt->EE8_COD_I) $ cOvoEEC
				lTemOvo := .t.
				Exit
			EndIf

			WorkIt->( dbSkip() )

		EndDo

		RestArea(aAreaWork)

	EndIf

Return lTemOvo
