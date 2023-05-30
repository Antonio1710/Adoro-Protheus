#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function MT116GRV
	Este ponto de entrada pertence a rotina de digitação de conhecimento de frete, MATA116(). É executado na rotina de  
	inclusão do conhecimento de frete, A116INCLUI(), quando a tela com o conhecimento e os itens são montados.            
	WORKFLOW CHAMADOS -SCHEDULE
	@type  Function
	@author William Costa
	@since 22/01/2016
	@history Ch.Interno TI - Abel Babini - 17/06/19 - Preenche Tipo CTe
	@history Ticket  67715 - Abel Babini - 07/02/22 - Preenche local padrão quando existente na SBZ - Indicador de Produtos
	@history ticket TI - Antonio Domingos - 19/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 22/05/2023 - Revisão Ajuste Nova Empresa
	/*/


User Function MT116GRV() 

	Local nPosLocal  := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_LOCAL"})     
	Local nPosProd   := aScan(aHeader,{ |x| Upper(AllTrim(x[2])) == "D1_COD"})     
	Local nCont      := 0  
	Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 17/05/2023	
	
	//IF cEmpAnt <> "01"   &&somente executa para empresa Adoro.
    IF cEmpAnt $ _cEmpAt1  //ticket TI - Antonio Domingos - 19/05/2023 
		RETURN(NIL)
	ENDIF
	

	FOR nCont := 1 TO LEN(aCols)                  
	    
	    //TROCA QUANDO FOR FILIAL 03                 
		IF XFILIAL() == '03' .AND. ALLTRIM(FUNNAME())=="INTNFEB"
		
			aCols[nCont][nPosLocal] := IIF(!RetArqProd(aCols[nCont][nPosProd]),POSICIONE("SBZ",1,xFilial("SBZ")+aCols[nCont][nPosProd],"BZ_LOCPAD"),POSICIONE("SB1",1,xFilial("SB1")+aCols[nCont][nPosProd],"B1_LOCPAD")) //LTERACAO REFERENTE A TABELA SBZ INDICADORES DE PRODUTOS CHAMADO 030317 - WILLIAM COSTA     

		//INICIO Ticket  67715 - Abel Babini - 07/02/22 - Preenche local padrão quando existente na SBZ - Indicador de Produtos
		ELSEIF xFilial() == '03' .And. Alltrim(cValToChar(CESPECIE)) == "CTE" .and. Alltrim(POSICIONE("SBZ",1,xFilial("SBZ")+aCols[nCont][nPosProd],"BZ_LOCPAD")) != ''
	    aCols[nCont][nPosLocal] := POSICIONE("SBZ",1,xFilial("SBZ")+aCols[nCont][nPosProd],"BZ_LOCPAD")
			//FIM Ticket  67715 - Abel Babini - 07/02/22 - Preenche local padrão quando existente na SBZ - Indicador de Produtos
		ENDIF	
	
	NEXT  

	//INICIO CHAMADO INTERNO TI - Abel Babini - 17/06/19 - Preenche Tipo CTe Automaticamente
	If IsInCallStack("MATA116") 
	
		If Type("aNFeDANFE") == "A" .And. Alltrim(cValToChar(CESPECIE)) == "CTE"
		
			aNFeDANFE[18] := "N - Normal"
		
		ElseIf Type("aNFeDANFE") == "A" .And. Alltrim(cValToChar(CESPECIE)) <> "CTE"
		
			aNFeDANFE[18] := ""
			
		EndIf

	Endif
	//FIM CHAMADO INTERNO TI - Abel Babini - 17/06/19 - Preenche Tipo CTe Automaticamente
Return 
