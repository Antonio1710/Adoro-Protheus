#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} MA261TRD3
	PE MA261TRD3 - Atualiza campos após a gravação da transferência (D3_CUSTO1)
	@type  User Function 
	@author Antonio Domingos
	@since 12/12/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 84416 - Antonio Domingos  - 09/12/2022 - ERRO DE CUSTEIO TRANSFERECIAS RE4 E DE4
	/*/

User Function MA261TRD3
	
	Local aRecSD3 := PARAMIXB[1]
	Local nX := 1
	Local cScan := Ascan(AHEADER,{ |x| x[2] == 'D3_QUANT'})
	Local aGetArea := GetArea()

	For nX := 1 To Len(aRecSD3)
	
		SD3->(DbGoto(aRecSD3[nX][1])) // Requisicao RE4
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Customizacoes de usuario      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		IF cScan > 0
			RecLock('SD3', .F.)
			SD3->D3_CUSTO1 := U_ADEST083P(SD3->D3_FILIAL,SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_CUSTO1,SD3->D3_QUANT)
			MsUnlock()
		Endif
		
		SD3->(DbGoto(aRecSD3[nX][2])) // Devolucao DE4
		//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
		//³ Customizacoes de usuario      ³
		//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
		IF cScan > 0
			RecLock('SD3', .F.)
			SD3->D3_CUSTO1 := U_ADEST083P(SD3->D3_FILIAL,SD3->D3_COD,SD3->D3_LOCAL,SD3->D3_CUSTO1,SD3->D3_QUANT)
			MsUnlock()
		Endif
	
	Next nX

	RestArea(aGetArea)

Return


