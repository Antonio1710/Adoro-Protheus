#include "totvs.ch"

/*/{Protheus.doc} User Function FA290OK
	PE para consistir se o n�mero da fatura est� em uso
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
User Function FA290OK()

	Local lRet := .t.

	If !LockByName(AllTrim(cFatura), .T., .F.)
		lRet := .f.
		MESSAGEBOX( "N�mero da fatura est� em uso, na tela do seu colega de trabalho! Pe�a para ele finalizar a opera��o que ap�s as baixas o sistema efetiva a numera��o e voc� poder� continuar com seguran�a... ", "Fatura n. " + cFatura, 16 )
	Else
		lRet := .t.
	EndIf
	
Return lRet
