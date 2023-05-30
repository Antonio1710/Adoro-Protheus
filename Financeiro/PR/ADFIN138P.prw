#include "totvs.ch"
/*/{Protheus.doc} ADFIN138P
Funcao que retorna o valor de baixas conforme motivo de baixa solicitado (E5_MOTBX)
@type function
@version 12.1.33
@author Rodrigo Mello
@since 04/05/2023
@param cTipoSoma, character, param_description
@return variant, return_description
@history ticket 88193   - Rodrigo Mello | Flek Solutions - 04/05/2023 - Projeto Nexxera Instrucoes de cobranca
/*/
user function ADFIN138P( cTipoSoma )

    local nRet := 0
    private aBaixas := Sel070Baixa( "VL /V2 /BA /RA /CP /LJ /"+MV_CRNEG,SE1->E1_PREFIXO,SE1->E1_NUM,SE1->E1_PARCELA,SE1->E1_TIPO,,,SE1->E1_CLIENTE,SE1->E1_LOJA,,,,,,.T.)
    default cTipoSoma := "CMP"

    aEval( aBaixas, {|u| iif( u[29] $ cTipoSoma, nRet += u[8], Nil) } )

return nRet
