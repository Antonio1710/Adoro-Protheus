#include "totvs.ch"

/*/{Protheus.doc} User Function F330ATLIS
    Ponto de Entrada criado em carater de urg�ncia pois a TOTVS n�o est� conseguindo resolver o problema de compensa��o dos tipos DSF
    Chamado TOTVS #14955491 
    @type  Function
    @author FWNM
    @since 11/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history ticket 77962 - 11/08/2022 - Fernando Macieira - ERRO COMPENSA��O DSF
/*/
User Function F330ATLIS()

    Local cMV_CRNEG := "NCC|DSF"
    
    If !(AllTrim(MV_CRNEG) $ "DSF")
        MV_CRNEG := cMV_CRNEG
    EndIf
    
Return
