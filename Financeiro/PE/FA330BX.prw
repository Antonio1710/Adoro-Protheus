#include "totvs.ch"
/*/{Protheus.doc} FA330BX
Ponto de entrada para tratamento de intrucoes de cobranca
@type function
@version 12.1.33
@author Rodrigo Mello
@since 27/04/2023
@return variant, return_description
@history ticket 88193   - Rodrigo Mello | Flek Solutions - 27/04/2023 - Projeto Nexxera Instrucoes de cobranca
/*/
user function FA330BX()

    local nPosTit := 0

    if !alltrim(SE1->E1_TIPO) $ ( MVRECANT+MV_CRNEG )
        if !(SE1->E1_TIPO $ MVABATIM ) .AND. !empty(SE1->E1_IDCNAB) .AND. !empty(SE1->E1_PORTADO)
            nPosTit := AScan( aTitulos, {|u| u[1]+u[2]+u[3]+u[4] == SE1->(E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)})
            U_ADFIN136P(/*lDelFI2*/ , val(aTitulos[nPosTit,6]) >= val(aTitulos[nPosTit,7]) )
        endif

    endif

return
