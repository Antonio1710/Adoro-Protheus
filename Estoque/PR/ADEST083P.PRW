#INCLUDE "rwmake.ch"

/*/{Protheus.doc} ADEST083P()
	Busca o Calculo do Custo Medio na sequencia
	SB2-B2_CM1, SB1-B1_UPRC, SB9-B9_CM1
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
	@history ticket 87224 - Antonio Domingos  - 23/01/2022 - ERRO DE CUSTEIO TRANSFERECIAS RE4 E DE4
	/*/
User Function ADEST083P(_cD3_FILIAL,_cD3_COD,_cD3_LOCAL,_nD3_CUSTO1,_nD3_QUANT)

If IsInCallStack("MATA260") .OR. IsInCallStack("MATA261")
	//ticket 87224 - Antonio Domingos  - 23/01/2022
	If _nD3_CUSTO1 <= 0  
		SB2->(DbSeek(_cD3_FILIAL+_cD3_COD+_cD3_LOCAL))
		If (_nD3_CUSTO1 / _nD3_QUANT) < SB2->B2_CM1 .And. SB2->B2_CM1 > 0
			_nD3_CUSTO1 := SB2->B2_CM1 * _nD3_QUANT
		EndIf
	EndIf
	If _nD3_CUSTO1 <= 0 
		SB1->(DbSeek(xFilial("SB1")+_cD3_COD))
		If (_nD3_CUSTO1 / _nD3_QUANT) < SB1->B1_UPRC .And. SB1->B1_UPRC > 0
			_nD3_CUSTO1 := SB1->B1_UPRC * _nD3_QUANT
		EndIf
	EndIf
	If _nD3_CUSTO1 <= 0 
		_dDtUltFec := FirstDay(dDatabase)-1
		SB9->(DbSeek(_cD3_FILIAL+_cD3_COD+_cD3_LOCAL+DTOS(_dDtUltFec)))
		If (_nD3_CUSTO1 / _nD3_QUANT) < SB9->B9_CM1 .And. SB9->B9_CM1 > 0
			_nD3_CUSTO1 := SB9->B9_CM1 * _nD3_QUANT
		EndIf
	EndIf
EndIf

Return(_nD3_CUSTO1)

