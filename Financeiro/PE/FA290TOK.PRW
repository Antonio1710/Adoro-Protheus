#include "totvs.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function FA290TOK
	PE para consistir se o n�mero da fatura est� em uso e/ou os t�tulos que ser�o gerados
	@type  Function
	@author Fernando Macieira
	@since 12/07/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 76254 - 12/07/2022 - GERA��O DE FATURAS - CONTAS A PAGAR
/*/
User Function FA290TOK()

	Local i
	Local lRet      := .t.
	Local cQuery    := ""
	Local cColsPre  := CriaVar("E2_PREFIXO")
	Local cColsNum  := CriaVar("E2_NUM")
	Local cColsPar  := CriaVar("E2_PARCELA")
	Local cColsTip  := CriaVar("E2_TIPO")
	Local cFornLoja := IIF(mv_par01 == 1,cForn+cLoja,cFornp+cLojaP)

	For i:=1 to Len(aCols)

		If !gdDeleted(i)

			cColsPre := gdFieldGet("E2_PREFIXO",i)
			cColsNum := gdFieldGet("E2_NUM",i)
			cColsPar := gdFieldGet("E2_PARCELA",i)
			cColsTip := gdFieldGet("E2_TIPO",i)
			
			SE2->( dbSetOrder(1) ) // E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, R_E_C_N_O_, D_E_L_E_T_
			If SE2->( dbSeek(FWxFilial("SE2")+cColsPre+cColsNum+cColsPar+cColsTip+cFornLoja) )
				lRet := .f.
				MESSAGEBOX( "T�tulo j� existe na base! Fatura n�o ser� gerada... ", "T�tulo: " + cColsPre+cColsNum+cColsPar+cColsTip+cFornLoja, 16 )
				Exit
			EndIf

		EndIf

	Next i

	If lRet

		If Select("Work") > 0
			Work->( dbCloseArea() )
		EndIf

		cQuery := " SELECT E2_FATPREF, E2_FATURA, E2_TIPOFAT
		cQuery += " FROM " + RetSqlName("SE2") + "(NOLOCK)
		cQuery += " WHERE E2_FATURA='"+AllTrim(cFatura)+"' 
		cQuery += " AND D_E_L_E_T_=''

		tcQuery cQuery New Alias "Work"

		Work->( dbGoTop() )
		If Work->( !EOF() )
			lRet := .f.
			MESSAGEBOX( "Fatura j� existe na base! Fatura n�o ser� gerada... ", "Fatura: " + cFatura, 16 )
		EndIf

		If Select("Work") > 0
			Work->( dbCloseArea() )
		EndIf

	EndIf
	
Return lRet
