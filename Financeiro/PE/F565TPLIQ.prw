#include "protheus.ch"

/*/{Protheus.doc} User Function nomeFunction
    PE na liquidação
    @type  Function
    @author FWNM
    @since 17/11/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history Ticket 83514 - 17/11/2022 - Fernando Macieira - TABELA SE2 - COM ITEM ERRADO
/*/
User Function F565TPliq()

    Local cItemCta := GetMV("MV_#CTD0B",,"125") 

    If (AllTrim(FWCodFil())=="0B" .or. FWxFilial("SE2")=="0B") .and. AllTrim(FWCodEmp()) == "01"
        RecLock("SE2", .F.)
            SE2->E2_ITEMC := cItemCta
            SE2->E2_ITEMD := cItemCta
        SE2->( msUnLock() )
    EndIf

Return
