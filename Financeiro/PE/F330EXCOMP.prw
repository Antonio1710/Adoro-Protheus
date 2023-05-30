#include 'totvs.ch'
/*/{Protheus.doc} F330EXCOMP
Ponto de entrada para tratamento de instrucoes de cobranca
@type function
@version 12.1.33
@author Rodrigo Mello
@since 27/04/2023
@return variant, return_description
@history ticket 88193   - Rodrigo Mello | Flek Solutions - 27/04/2023 - Projeto Nexxera Instrucoes de cobranca
/*/

user function F330EXCOMP()

    local i
    local cQuery := ""

    for i:=1 to len(PARAMIXB[1])
        if PARAMIXB[1,i,11]
            cQuery := "update " + RetSQLName("FI2")
            cQuery += " set D_E_L_E_T_ = '*' , R_E_C_D_E_L_ = R_E_C_N_O_"
            cQuery += " where "
            cQuery += "     D_E_L_E_T_ = '' "
            cQuery += " and FI2_FILIAL = '" + xFilial("FI2") + "' "
            if !alltrim(SE1->E1_TIPO) $ ( MVRECANT+MV_CRNEG )
                cQuery += " and FI2_PREFIX+FI2_TITULO+FI2_PARCEL = '" + PARAMIXB[1,i,1] + PARAMIXB[1,i,2] + PARAMIXB[1,i,3] + "'"
            else
                cQuery += " and FI2_PREFIX+FI2_TITULO+FI2_PARCEL = '" + PARAMIXB[1,i,7] + "'"
            endif
            cQuery += " and FI2_CODCLI = '" + SE1->E1_CLIENTE + "'"
            cQuery += " and FI2_LOJCLI = '" + SE1->E1_LOJA + "'"
            cQuery += " and FI2_GERADO = '2'"
            if TCSqlExec(cQuery) < 0
                FWAlertWarning(TCSQLError(), "Instruções de cobrança")
            endif
        endif
    next i

return .T.
