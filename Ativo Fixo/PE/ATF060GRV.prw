#include "protheus.ch"

/*/{Protheus.doc} User Function nomeFunction
    PE antes tela msg das NFs geradas, ap�s finaliza��o da transfer�ncia e sua contabiliza��o
    @type  Function
    @author Fernando Macieira
    @since 14/11/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history ticket 82578 - 14/11/2022 - Fernando Macieira - Transfer�ncia de Ativo - Lock SX5
/*/
User Function ATF060GRV()
    
	// ticket 84085 - 01/12/2022 - Fernando Macieira - TRANSFERENCIA DE ATIVO IMOBILIZADO nota fiscal n�o aparece no Faturamento
	If AllTrim(FUNNAME())=="ATFA060" .or. IsInCallStack("ATFA060")
		Return
	EndIf


    //msgInfo("tela 1 - ATF060GRV - Transfer�ncia realizada com sucesso!")
    
    //msUnLockAll()
    //DisarmTransaction()

    /*
    Break
    KillApp(.T.)
    __QUIT()
    */

Return
