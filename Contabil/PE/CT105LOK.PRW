#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function CT105LOK
	O ponto de entrada CT105LOK � utilizado na fun��o de valida��o da linhaOk da Getdados Function CT105LOK
	@type  Function
	@author Fernando Sigoli
	@since 28/11/2017
	@history Chamado 038144- Fernando Sigoli  - 28/11/2017
	@history Chamado T.I   - Fernando Sigoli  - 12/01/2021 - Voltar Vers�o do dia 04/02/2020, com organiza��o e limpeza de linhas cometadas
/*/

User Function CT105LOK()

	Local lRet := .T.

	If TMP->CT2_DC == "1" .and. Alltrim(TMP->CT2_CREDIT) <> ""   
		Alert("Se Tipo do Lan�amento = Debito, a Conta Credito n�o deve ser preenchida! Verifique")
		lRet:=.F.
	Endif
	
	If TMP->CT2_DC == "2" .and. Alltrim(TMP->CT2_DEBITO) <> ""   
		Alert("Se Tipo do Lan�amento = Credito, a Conta Debito n�o deve ser preenchida! Verifique")
		lRet:=.F.	
	Endif
	
	If TMP->CT2_DC == "1" .and. Alltrim(TMP->CT2_ITEMC) <> ""   
		Alert("Se Tipo do Lan�amento = Debito, o Item Conta Credito n�o deve ser preenchido! Verifique")
		lRet:=.F.
	Endif
	
	If TMP->CT2_DC == "2" .and. Alltrim(TMP->CT2_ITEMD) <> "" 
		Alert("Se Tipo do Lan�amento = Credito, o Item Conta Debito n�o deve ser preenchido! Verifique")
		lRet:=.F.	
	Endif

Return(lRet)
