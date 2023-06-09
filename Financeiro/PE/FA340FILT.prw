#Include "Protheus.Ch"

/*/{Protheus.doc} User Function FA340FILT
	PE na rotina de compensacao do contas a pagar. N�o permite que titulos nao liberados sejam compensados.
	@type  Function
	@author Ana Helena Barreta 
	@since 23/07/2013
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@chamado 038609
    @history Chamado 038611 - Ricardo Lima - 03/01/2018 - N�o permitido baixa de titulo gerados por pedido de compra com a condicao de pagamento "ICM", tera que ser feito por Compensacao - Projeto Financas   
	@history Chamado 053347 - FWNM         - 29/11/2019 - 053347 || OS 054719 || FINANCAS || EDUARDO || 8352 || IMPLANTAR CENTRAL
    @history Chamado 056247 - FWNM         - 15/05/2020 - OS 059676 || FINANCAS || LUIZ || 8451 || CONTAS APAGAR
/*/
User Function FA340FILT()      

	Local lRet := .T.

	Local E2NUM     := SE2->E2_NUM 
	Local E2PREFIXO := SE2->E2_PREFIXO 
	Local E2FORNECE := SE2->E2_FORNECE 
	Local E2LOJA    := SE2->E2_LOJA
	Local E2DIVERG  := SE2->E2_XDIVERG
	Local lPgICM    := .F.
	Local cTpDivf   := "000004"

	If ALLTRIM(DTOS(E2_DATALIB)) == ""
		lRet := .F.
	Endif   

    // Chamado n. 058216 || OS 059676 || FINANCAS || LUIZ || 8451 || CONTAS APAGAR - FWNM - 15/05/2020
    If AllTrim(SE2->E2_XDIVERG) == "S" .or. AllTrim(SE2->E2_RJ) == "X" 
    	lRet := .F.
        MsgAlert("T�tulo n�o pode ser movimentado pois est� aguardando aprova��o!", "Central Aprova��o")
	EndIf
    //

	// RICARDO LIMA - 03/01/18
	IF lRet
		DbSelectArea("SF1")
		DbSetOrder(1) // SF10101 F1_FILIAL, F1_DOC, F1_SERIE, F1_FORNECE, F1_LOJA, F1_TIPO, R_E_C_N_O_, D_E_L_E_T_
		if DbSeek( FwxFilial("SF1") +  E2NUM + E2PREFIXO + E2FORNECE + E2LOJA  )
			IF SF1->F1_COND = "ICM"
				IF EMPTY(E2DIVERG)
					lPgICM := .T.
				ENDIF
			ENDIF			
		endif
	ENDIF

	IF lPgICM 	 	
		If MsgYesNo("Titulo gerado a partir de um Pedido de Compra de ICMS, antes de Realizar a Baixa e necessario enviar para aprova��o, Deseja Enviar?")
			lRet := .F.
			
			SE2->E2_XDIVERG := 'S'
			DbSelectArea("SX5")
			DbSetOrder(1)
			DbSeek( FwxFilial("SX5") + 'Z9' + cTpDivf )
			
			// gera registro para aprovacao		
			RecLock("ZC7",.T.)
				ZC7->ZC7_FILIAL := FwxFilial("SE2")
				ZC7->ZC7_PREFIX	:= SE2->E2_PREFIXO
				ZC7->ZC7_NUM   	:= SE2->E2_NUM
				ZC7->ZC7_PARCEL	:= SE2->E2_PARCELA
				ZC7->ZC7_TIPO   := SE2->E2_TIPO // Ricardo Lima - 27/03/18
				ZC7->ZC7_CLIFOR	:= SE2->E2_FORNECE
				ZC7->ZC7_LOJA  	:= SE2->E2_LOJA
				ZC7->ZC7_VLRBLQ	:= SE2->E2_VALOR
				ZC7->ZC7_TPBLQ 	:= cTpDivf
				ZC7->ZC7_DSCBLQ	:= ALLTRIM(SX5->X5_DESCRI) + " - " + "TITULOS DE ICMS"
				ZC7->ZC7_RECPAG := "P"	 
				ZC7->ZC7_USRALT := __cUserID 						 		
			MSUnlock()    	     	
		else
			lRet := .F.
		endif   	 	
	ENDIF
	//endif

Return(lRet)
