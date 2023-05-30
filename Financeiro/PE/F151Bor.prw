#include 'totvs.ch'
/*/{Protheus.doc} F151Bor
Filtro utilizado na rotina de instrucoes CNAB para nao enviar titulos bloqueados.
@type function
@version 12.1.33
@author Rodrigo Mello
@since 12/05/2023
@return variant, return_description

@history ticket 88193   - Rodrigo Mello | Flek Solutions - 28/04/2023 - Projeto Nexxera Instrucoes de cobranca
/*/

user function F151Bor()

    local lRet := Fa150PesqBord( FI2_NUMBOR, , 'R' /*Carteira*/ )
    local aArea := GetArea()
    local cSeekSE1 := FI2_FILIAL+FI2_PREFIX+FI2_TITULO+FI2_PARCEL+FI2_TIPO+FI2_CODCLI+FI2_LOJCLI // nao pode apontar para o alias FI2, pois utiliza arq. temporario

    dbSelectArea("SE1")
    SE1->(dbSetOrder(1))
    SE1->(dbGotop())
    if lRet .and. SE1->(dbSeek(cSeekSE1)) // .and. SE1->E1_EMISSAO >= CTOD("17/05/2023")
        lRet := SE1->E1_XDIVERG <> 'S'
    endif
    SE1->(dbCloseArea())
    restArea(aArea)

return lRet 
