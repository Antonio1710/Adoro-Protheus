#include 'totvs.ch'
/*/{Protheus.doc} FA330CMP
Ponto de entrada para tratamento de instrucoes de cobranca
@type function
@version 12.1.33
@author Rodrigo Mello
@since 27/04/2023
@return variant, return_description
@history ticket 88193   - Rodrigo Mello | Flek Solutions - 27/04/2023 - Projeto Nexxera Instrucoes de cobranca
/*/
user function FA330CMP()

    local aArea := SE1->(GetArea())

    if !alltrim(cTipoTit) $ ( MVRECANT+MV_CRNEG )
        SE1->(dbGoTo(nRecno))
        if !(SE1->E1_TIPO $ MVABATIM ) .AND. !empty(SE1->E1_IDCNAB) .AND. !empty(SE1->E1_PORTADO)
            U_ADFIN136P(/*lDelFI2*/ , cSaldo >= nValor)
        endif

        SE1->(restArea(aArea))
    endif
    
return 
