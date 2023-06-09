/*/{Protheus.doc} User Function ADFIN133P
	Valida��o de placa para verificar vinculo com a transportadora
	@type  Function
	@author Jonathan Carvalho
	@since 07/06/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
    @ticket 72807 - Jonathan Carvalho - 07/06/2022 verifica��o de vinculo entre placa e transportadora
	@ticket 79828 - Jonathan Carvalho - 15/09/2022 valida��o de campo n�o irar funcionar na MATA310 - transferencia entre Filiais
	@ticket 79828 - Jonathan Carvalho - 16/09/2022 realizado corre��o no retorno da valida��o.
	/*/

User Function ADFIN133P()

	Local lRet := .F.

	If !IsInCallStack('MATA310')
		//Procura pela placa + transportadora
		DbSelectArea("ZV4")
		ZV4->(dbSetOrder(1))
		if ZV4->(dbseek(xFilial("ZV4")+Alltrim(M->C5_PLACA))) .AND. ZV4->ZV4_FORNEC == M->C5_TRANSP 

			lRet := .T.

		else
			MsgInfo('Placa n�o vinculada com a Transportadora', 'Aten��o')
			lRet := .T. //Corre��o no returno da valida��o			
		Endif	
	else
		lRet := .T.			
	EndIf	
    
Return lRet
