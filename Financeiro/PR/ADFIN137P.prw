/*/{Protheus.doc} ADFIN137P
Cadastro de regras para automacao de instrucoes de cobranca
@type function
@version 12.1.33
@author Rodrigo Mello
@since 13/04/2023
@return variant, return_description
@history ticket 88193   - Rodrigo Mello | Flek Solutions - 27/04/2023 - Projeto Nexxera Instrucoes de cobranca
/*/
User function ADFIN137P()

    dbSelectArea("ZJG")
    ZJG->(dbSetOrder(1))
    AxCadastro("ZJG", "Automacao Instrucoes Bancarias")

return
