#include "protheus.ch"

/*/{Protheus.doc} User Function FA040GRV
    O ponto de entrada FA040GRV sera executado apos a gravacao de todos os dados referentes ao titulo e antes da contabilizacao.
    @type  Function
    @author Fernando Macieira
    @since 11/11/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @ticket 83225 - ITEM CONTA D - (TABELA E1) - Sempre que for filial 0B ser preenchido com item 125
/*/
User Function FA040GRV()

    Local cItemCta := GetMV("MV_#CTD0B",,"125")

    If (AllTrim(FWCodFil())=="0B" .or. FWxFilial("SE1")=="0B") .and. AllTrim(FWCodEmp()) == "01"

        RecLock("SE1", .F.)
            SE1->E1_ITEMD := cItemCta
            SE1->E1_ITEMC := cItemCta
        SE1->( msUnLock() )

    EndIf
    
Return
