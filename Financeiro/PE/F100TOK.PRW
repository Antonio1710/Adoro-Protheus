#Include "Protheus.ch"

/*/{Protheus.doc} User Function F100TOK
	Ponto Entrada Confirma��o Movimento Banc�rio
	@type  Function
	@author Everson
	@since 26/10/2017
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 78418 - 26/08/2022 - Fernando Macieira - CAMPO COD. VALOR - MOVIMENTO BANCARIO
	@history ticket 81491 - 28/02/2023 - Abel Babini       - Tirar a obrigatoriedade da qtd de tarifas
	@history ticket TI - Antonio Domingos - 23/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 30/05/2023 - Ajuste Nova Empresa
/*/
User Function F100TOK()
		
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������	
	Local aArea		:= GetArea()
	//Local cNaturezas:= GetMv("MV_#TARIFA")
	//Local nVlrTar   := 0              //Chamado:038828  fernando Sigoli 09/01/2017
	Private _cEmpAt8 := SuperGetMv("MV_#EMPAT8",.F.,"01/02/03/06/13") //Codigo de Empresas Ativas Grupo 8 //ticket TI - Antonio Domingos - 23/05/2023

	// @history ticket 78418 - 26/08/2022 - Fernando Macieira - CAMPO COD. VALOR - MOVIMENTO BANCARIO
	If Left(AllTrim(M->E5_CCD),1) == "9" .and. Empty(M->E5_CLVLDB)
		Alert("Preenchimento obrigat�rio do campo 'Cl Valor Deb' para CCusto D�bito iniciado com 9! Verifique...")
		Return .f.
	EndIf

	If Left(AllTrim(M->E5_CCC),1) == "9" .and. Empty(M->E5_CLVLCR)
		Alert("Preenchimento obrigat�rio do campo 'Cl Valor Crd' para CCusto Cr�dito iniciado com 9! Verifique...")
		Return .f.
	EndIf
	// 
	
	//Everson - 14/12/2017. Chamado 038693.
	If !( alltrim(cEmpAnt) $ _cEmpAt8 ) //ticket TI - Antonio Domingos - 23/05/2023 
		RestArea(aArea)
		Return .T.
		
	EndIf
	
	//ticket 81491 - 28/02/2023 - Abel Babini       - Tirar a obrigatoriedade da qtd de tarifas
	//Valida se o campo de tarifa foi informado.
	/*
	If IsInCallStaCk("FA100PAG") .And. (Alltrim(cValToChar(M->E5_NATUREZ)) $cNaturezas) .And.;
	   (Empty(Alltrim(cValTochar(M->E5_XTARIFA))) .Or. M->E5_XQTDTAR <= 0)
	   
	   MsgStop("Para a natureza informada � necess�rio informar o c�digo da tarifa banc�ria e quantidade da mesma.","Fun��o F100TOK")
	   RestArea(aArea)
	   Return .F.
	   
	ElseIf ! IsInCallStaCk("FA100PAG") .And.;
	   (! Empty(Alltrim(cValTochar(M->E5_XTARIFA))) .Or. M->E5_XQTDTAR > 0)
	   
	   MsgStop("Para esta opera��o n�o � necess�rio informar o c�digo da tarifa banc�ria e quantidade da mesma.","Fun��o F100TOK")
	   RestArea(aArea)
	   Return .F.
	   	
	EndIf
	
	//Chamado: 038828 09/01/18 - Fernado Sigoli
	//Inicio
	If IsInCallStaCk("FA100PAG") .And. (Alltrim(cValToChar(M->E5_NATUREZ)) $cNaturezas) .And.;
	   (!Empty(Alltrim(cValTochar(M->E5_XTARIFA))) .Or. M->E5_XQTDTAR > 0)
	
		nVlrTar := Posicione('ZC2',1,xFilial("ZC2")+Alltrim(M->E5_XTARIFA),"ZC2_VALOR")
		nVlrTar := (nVlrTar*M->E5_XQTDTAR)
		
		If nVlrTar <> M->E5_VALOR
			
			If !MsgYesNo("Aten��o! Existe diverg�ncia de valores Total X Cadastro de Tarifa ","DESEJA CONTINUAR?")
				RestArea(aArea)
				Return .F.
			EndIf
			
		EndIf
	
	EndIf
	//Fim
	*/
	RestArea(aArea)
	
Return .T.
