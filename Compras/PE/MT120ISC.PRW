#include "rwmake.ch"
#include "protheus.ch"

/*/{Protheus.doc} User Function nomeFunction
	Grava codigo do projeto no pedido de compra
	@type  Function
	@author Mauricio
	@since 06/07/2009
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history Chamado 004603
	@history Chamado 053656 - FWNM    - 28/11/2019 - 053656 || OS 055039 || COMPRAS || GRAZIELE_ALMEIDA || 8346 || PEDIDO DE COMPRA
	@history Chamado 2562   - Everson - 04/11/2020 - Tratamento para gravar o item de estudo da solicita��o de compra para o pedido de compra. 
	@history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 22/05/2023 - Revis�o Ajuste Nova Empresa
/*/
User Function MT120ISC()

	Local nX := 0   
	Private _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 22/05/2023

	if cEmpAnt $ _cEmpAt1 //ticket TI - Antonio Domingos - 22/05/2023 
	
		For nX := 1 To Len(aHeader)

			If Trim(aHeader[nX][2]) == "C7_PROJETO"
				aCols[n][nX] := SC1->C1_PROJADO 
			ElseIf Trim(aHeader[nX][2]) == "C7_CODPROJ"
				aCols[n][nX] := SC1->C1_CODPROJ 
			
			// Chamado n. 053656 || OS 055039 || COMPRAS || GRAZIELE_ALMEIDA || 8346 || PEDIDO DE COMPRA - fwnm - 28/11/2019
			ElseIf Trim(aHeader[nX][2]) == "C7_XOBSINT"
				aCols[n][nX] := SC1->C1_XOBSINT
			//

			//Everson - 04/11/2020. Chamado 2562.
			ElseIf Trim(aHeader[nX][2]) == "C7_XITEMST"
				aCols[n][nX] := SC1->C1_XITEMST
			//

			EndIf

		Next nX
		
	endif
	
Return(Nil)
