#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function F340VALOK
	Valida a execu��o da corre��o monter�ria e garante que os par�metros est�o corretos.
	@type  Function
	@author Leonardo P. Monteiro
	@since 07/01/2021
	@version 01
	@history Chamado   7690 - LPM		   - 07/01/2021 - Chamado 7690||OS ||Financeiro||Wagner Ferreira||RAMAL|| Ponto de entrada para valida��o da rotina Corre��o Monet�ria e garantir que os par�metros est�o de acordo com as regras Ad'oro."
*/

User Function F350CONF()
    Local lRet      := .T.
    Local dUltDia   := LastDay(dDatabase)
    
    If dUltDia != dDatabase
        Msginfo("A rotina 'Corre��o Monet�ria'(FINA350) somente pode ser executada com a DATABASE do sistema no �ltimo dia do m�s "+ Dtoc(dUltDia) +".")
        
        lRet := .F.
        MsgAlert("A rotina 'Corre��o Monet�ria'(FINA350) n�o foi executada!" )
    Elseif MV_PAR08 == 0 .OR. MV_PAR09 == 0
        Msginfo("Os campos 'Taxa de Venda' e 'Taxa de Compras' precisam ser informados para a execu��o do c�lculo.")
        
        lRet := .F.
    Else
        lRet := .T.
    Endif 
 
return lRet
