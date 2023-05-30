#include 'totvs.ch'
/*/{Protheus.doc} F450SE1C
Ponto de entrada para tratamento de instrucoes de cobranca
@type function
@version 12.1.33
@author Rodrigo Mello
@since 27/04/2023
@return variant, return_description
@history ticket 88193   - Rodrigo Mello | Flek Solutions - 27/04/2023 - Projeto Nexxera Instrucoes de cobranca
/*/
user function F450SE1C() 

    if !alltrim(SE1->E1_TIPO) $ ( MVRECANT+MV_CRNEG+MVABATIM ) .and. !empty(SE1->E1_IDCNAB) .AND. !empty(SE1->E1_PORTADO)
        U_ADFIN136P(.T. /*lDelFI2,lBaixa*/)
    endif

return
