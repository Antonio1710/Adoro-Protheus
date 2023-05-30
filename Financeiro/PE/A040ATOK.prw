#include "totvs.ch"
/*/{Protheus.doc} A040AtOk
Ponto de entrada para tratamento de intrucoes de cobranca - 
Nao deve apresentar a tela para o usuario manipular as instrucoes de cobranca
@type function
@version 12.1.33
@author Rodrigo Mello
@since 28/04/2023
@history ticket 88193   - Rodrigo Mello | Flek Solutions - 28/04/2023 - Projeto Nexxera Instrucoes de cobranca
@return variant, return_description
/*/
user function A040AtOk()
return PARAMIXB[1]
