#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"   
#INCLUDE "XMLXFUN.CH"
#INCLUDE "Rwmake.ch"
#INCLUDE 'Topconn.ch' 

/*{Protheus.doc} User Function MT170SLD
	� executado dentro do la�o onde  � feito o c�lculo do saldo do produto de todos os almoxarifados. O resultado do c�lculo do saldo � guardado na vari�vel nSaldo. O ponto de entrada � executado ap�s a atualiza��o desta vari�vel, produto a produto (todos os almoxarifados). N�o trazer mais produtos com ponto de pedido < 0
	@type  Function
	@author WILLIAM COSTA
	@since 23/09/2020
	@version 01
	
*/

User Function MT170SLD( )

    Local nQuant    := PARAMIXB[1]     //-- Saldo calculado pelo sistema
    Local cProd     := PARAMIXB[2]     //-- C�dido do produto
    Local cLocal    := PARAMIXB[3]     //-- Armaz�m do produto
    Local nNewSaldo := 0 

    IF nQuant < 0

        nNewSaldo := 0

    ELSE

        nNewSaldo := nQuant

    ENDIF        

Return (nNewSaldo)
