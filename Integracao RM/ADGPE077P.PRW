#INCLUDE "TOTVS.CH"
#INCLUDE "TOPCONN.CH"
/*/{Protheus.doc} User Function ADGPE077P
    Tela de retirada de kits na expedi��o(Frango).
    @type  Function
    @author Leonardo P. Monteiro
    @since 07/09/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)

    U_ADGPE076P()
/*/

User function ADGPE077P()
    Local cTitle    := "..:: Tela de Coleta Kits Frango (Expedi��o) ::.."
    
    U_ADGPE076P(1, cTitle)

    //
    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Tela de Coleta Kits Frango (Expedi��o) ')


return

