#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"

/*/{Protheus.doc} User Function MT110LOK
	Ponto de Entrada para validar a exist�ncia de centro de custos
	e item cont�bil.
	@type  Function
	@author F�brica Tradicional
	@since 17/07/2008
	@version 01
	@history 06.07.09 - Mauricio HC - Chamado 004603 de obrigar preenchimento do campo Projeto quando C.Custo iniciado por 9.
	@history 08/01/19 - FWNM - Chamado n. 046284 - Novas regras alteracao valor
	@history 047931 || OS 049195 || CONTROLADORIA || ANDRESSA || 45968437 || C.CUSTO X LOTE -RNX2 - FWNM - 19/03/2019
	@history 048414 || OS 049698 || CONTROLADORIA || ANDRESSA || 45968437 || NOTAS -LOTE RNX2 - FWNM - 10/04/2019
	@history Everson, 04/11/2020, Chamado 2562. Valida��o de estudo de projeto vinculado � solicita��o de compra.
	@history ticket  8582 - Fernando Macieira - 08/02/2021 - Replicar OP na pr�xima linha
	@history ticket 10573 - Fernando Macieira - 08/03/2021 - Ponto de Corre��o - Manuten��o de Ativos
	@history ticket 69712 - Fernando Macieira - 15/03/2022 - Integra��o Notas Centro de Custo 5134 - Item 113
	@history ticket TI    - Fernando Macieira - 22/03/2022 - For�ar publica��o
	@history ticket 71057 - Fernando Macieira - 08/04/2022 - Item cont�bil Lan�amentos da Filial 0B - Itapira
	@history ticket 74027 - TI                - 22/06/2022 - Pedido de Compra e Documento de Entrada CC 5318 - Item 111
	@history ticket 85790 - 16/01/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - ITEM CONT�BIL
	@history Everson, 13/02/2023, ticket 87842 - Valida��o uso de OP.
	@history Everson, 16/02/2023, ticket 88670 - Valida��o de saldo e data de projeto.
	@history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
	@history ticket 94010 - 25/05/2023 - Fernando Macieira - EMPRESAS NOVAS (EMPRESAS 11, 12 E 13) - ITEM CONT�BIL 221
/*/
User Function MT110LOK()

	Local aAreaAtu1	:= GetArea()
	Local lRetorno	:= .T.
	Local aAprov	:= {}
	Local nLoop		:= 0
	Local nPConta	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C1_CONTA" } )
	Local nPCusto	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C1_CC" } )
	Local nPItemCta	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C1_ITEMCTA" } )
	Local nPClasse	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C1_CLVL" } )
	Local nPProduto	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C1_PRODUTO" } )
	Local nPProjeto	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C1_PROJADO" } )
	Local nPCodProj	:= aScan( aHeader, { |x| AllTrim( x[2] ) == "C1_CODPROJ" } )
	Local nTotal	:= 0
	Local cConta	:= aCols[n,nPConta]
	Local cCusto	:= aCols[n,nPCusto]
	Local cItemCta	:= aCols[n,nPItemCta]
	Local cClasse	:= aCols[n,nPClasse]
	Local cProjeto	:= aCols[n,nPProjeto]
	Local cProduto	:= aCols[n,nPProduto]
	Local cCodProj	:= aCols[n,nPCodProj]
	Local lSldAtv  := GetMV("MV_#PRJSLD",,".T.")
	//Local cFasePrj := GetMV("MV_PRJINIC",,"05")
	//Local cFaseRej := GetMV("MV_#FASREJ",,"01")
	Local cFaseApr := GetMV("MV_#FASEOK",,"03")
	Local cEstPrj  := Alltrim(cValToChar(aCols[n, aScan( aHeader, { |x| AllTrim( x[2] ) == "C1_XITEMST" } ) ]))
	//Local cOp  := "" 
	//Local nAux := 0
	Local cMVItemCta := ""
	Local cItemNEW := GetMV("MV_#ITMNEW",,"221")

	Private _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 22/05/2023

	//�����������������������������������������������������������������������������������������Ŀ
	//� Se deixou o centro de custo em branco n�o permite inclus�o                              �
	//�������������������������������������������������������������������������������������������
	If lRetorno .And. Empty( cCusto )
		Aviso(	"MT110LOK-01",;
		"� obrigat�rio o preenchimento do Centro de Custo.",;
		{ "&Retorna" },,;
		"Conte�do em Branco" )
		lRetorno	:= .F.
	EndIf
	
	//�����������������������������������������������������������������������������������������Ŀ
	//� Se deixou o item cont�bil em branco n�o permite inclus�o                                �
	//�������������������������������������������������������������������������������������������
	If lRetorno .And. Empty( cItemCta )
		Aviso(	"MT110LOK-02",;
		"� obrigat�rio o preenchimento do Item Cont�bil.",;
		{ "&Retorna" },,;
		"Conte�do em Branco" )
		lRetorno	:= .F.
	EndIf 
	
	//�����������������������������������������������������������������������������������������Ŀ
	//� Obriga informar a classe de valor se a conta iniciar por 31 e o centro de custo por 6   �
	//�������������������������������������������������������������������������������������������
	If SubStr( cConta, 1, 2 ) == "31" .And. SubStr ( cCusto, 1, 1 ) == "6" .And. Empty( SubStr( cClasse, 1, 1 ) )
		Aviso(	"MT110LOK-03",;
		"Conta Cont�bil: " + AllTrim( cConta ) + " Centro de Custo: " + cCusto + "." + Chr(13) + Chr(10) +;
		"� obrigat�rio o preenchimento da Classe de Valor.",;
		{ "&Retorna" },,;
		"Conte�do em Branco" )
		lRetorno	:= .F.
		//MSGSTOP( "Obrigatorio preenchimento da Classe de Valor", "ATEN��O", "ALERT")
		//_lRet := .F.
	EndIf
	
	//�����������������������������������������������������������������������������������������Ŀ
	//� Obriga informar o projeto se o centro de custo iniciar por 9                            �
	//�������������������������������������������������������������������������������������������
	If SubStr( cCusto, 1, 1) == "9" .And. Empty( cProjeto )
		Aviso(	"MT110LOK-04",;
		"Centro de Custo: " + cCusto + "." + Chr(13) + Chr(10) +;
		"� obrigat�rio o preenchimento do Projeto.",;
		{ "&Retorna" },,;
		"Conte�do em Branco" )
		lRetorno	:= .F.
	EndIf
	
	//�������������������������������������������������������������������������������������������������Ŀ
	//� Se o centro de custo nao iniciar por 9 nao pode haver codigo do projeto.Mauricio -Chamado 007547�
	//���������������������������������������������������������������������������������������������������
	If !Empty(cProjeto) .And. SubStr( cCusto, 1, 1) <> "9"
		Aviso(	"MT110LOK-05",;
		"Centro de Custo: " + cCusto + "." + Chr(13) + Chr(10) +;
		"Nao pode ter o campo projeto preenchido.",;
		{ "&Retorna" },,;
		"Conte�do em Branco" )
		lRetorno	:= .F.
	EndIf
	
	//�����������������������������������������������������������������������������������������Ŀ
	//� Faz verificacao se o projeto se encontra encerrado ou nao para aceitar lancamento       �
	//�������������������������������������������������������������������������������������������
	DbSelectArea("AF8")
	DbSetOrder(1)
	if dbseek(xFilial("AF8")+cProjeto)
		if AF8->AF8_ENCPRJ == "1"
			Aviso(	"MT110LOK-06",;
			"Projeto: " + cProjeto + "." + Chr(13) + Chr(10) +;
			"Projeto ja se encontra encerrado. Deve ser utilizado outro projeto",;
			{ "&Retorna" },,;
			"Conte�do em Branco" )
			lRetorno	:= .F.
		endif
	EndIf
	
	//�����������������������������������������������������������������������������������������Ŀ
	//� Obriga informar o codigo do projeto se o campo Projeto estiver preenchido               �
	//�������������������������������������������������������������������������������������������
	If cEmpAnt $ _cEmpAt1 //ticket TI - Antonio Domingos - 22/05/2023 
		If !Empty( cProjeto ) .And. Empty(cCodProj)
			Aviso(	"MT110LOK-09",;
			"Projeto: " + cProjeto + "." + Chr(13) + Chr(10) +;
			"� obrigat�rio o preenchimento do Codigo do Projeto.",;
			{ "&Retorna" },,;
			"Conte�do em Branco" )
			lRetorno	:= .F.
		ElseIf Empty( cProjeto ) .And. !Empty(cCodProj)
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == "C1_CODPROJ"})] := "   "
		EndIf
	Endif
	
	// Projetos - FWNM - 16/02/2018
	If lRetorno
		
		If !gdDeleted(n)
			
			cPrj   := gdFieldGet("C1_PROJADO", n)
			cCC    := gdFieldGet("C1_CC", n)
			
			dDtDig := msDate()

			// @history ticket 69712 - Fernando Macieira - 15/03/2022 - Integra��o Notas Centro de Custo 5134 - Item 113
			cMVItemCta := GetMV("MV_#ITM113",,"113")
			If AllTrim(cCC) $ GetMV("MV_#CC5134",,"5134")
				gdFieldPut("C1_ITEMCTA", cMVItemCta, n)
			EndIf
			//

			// @history ticket 71057 - Fernando Macieira - 08/04/2022 - Item cont�bil Lan�amentos da Filial 0B - Itapira
			If AllTrim(cEmpAnt) == "01" .and. AllTrim(cFilAnt) == "0B"
				cMVItemCta := AllTrim(GetMV("MV_#ITACTD",,"125"))
				gdFieldPut("C1_ITEMCTA", cMVItemCta, n)
			EndIf
			//

			// @history ticket 74027 - TI                - 22/06/2022 - Pedido de Compra e Documento de Entrada CC 5318 - Item 111
			If AllTrim(cCC) == "5318" .or. Left(AllTrim(cCC),1) == "7"
				gdFieldPut("C1_ITEMCTA", "111", n)
			EndIf
			//
		
			// @history ticket 94010 - 25/05/2023 - Fernando Macieira - EMPRESAS NOVAS (EMPRESAS 11, 12 E 13) - ITEM CONT�BIL 221
			If AllTrim(FWCodEmp()) == "11" .or. AllTrim(FWCodEmp()) == "12" .or. AllTrim(FWCodEmp()) == "13"
				gdFieldPut("C1_ITEMCTA", cItemNEW, n)
			EndIf
			// 

			// Consiste exig�ncia ou n�o do projeto
			lPrjInv := Left(AllTrim(cCC),1) == "9"
			
			// qdo prj investimento
			If lPrjInv .and. !Alltrim(cCC) $ GetMV("MV_#CCPADR")
				
				If Empty(cPrj)
					lRetorno := .f.
					
					Aviso(	"MT110LOK-07",;
					"Centro de Custo: " + cCC + "." + Chr(13) + Chr(10) +;
					"� obrigat�rio o preenchimento do Projeto.",;
					{ "&Retorna" },,;
					"Conte�do em Branco" )
				EndIf
				
				
				// Consiste CC permitidos para aquele projeto (ZC1)
				If lRetorno
					
					ZC1->( dbSetOrder(1) ) // ZC1_FILIAL+ZC1_PROJET+ZC1_CC
					If ZC1->( !dbSeek(xFilial("ZC1")+cPrj+cCC) )
						
						lRetorno := .f.
						
						Aviso(	"MT110LOK-11",;
						"Centro Custo n�o permitido para este projeto! Verifique..." + chr(13) + chr(10) +  chr(13) + chr(10)+;
						"CC: " + cCC + " - " + Posicione("CTT",1,xFilial("CTT")+cCC,"CTT_DESC01") + chr(13) + chr(10) +;
						"Projeto: " + cPrj + " - " + AF8->AF8_DESCRI,;
						{ "&Retorna" },,;
						"Projeto x CC permitidos" )
						
					EndIf
					
				EndIf
				
				
				// Consiste filial/planta permitida para aquele CC
				If lRetorno
					
					If Left(AllTrim(cPrj),2) <> cFilAnt
						
						lRetorno := .f.
						
						Aviso(	"MT110LOK-12",;
						"Este projeto n. " + AllTrim(cPrj) + " n�o pertence a esta filial! Verifique..." + chr(13) + chr(10) +  chr(13) + chr(10)+;
						"Filial/Planta: " + cFilAnt + chr(13) + chr(10) +;
						"Projeto/Planta: " + Left(AllTrim(cPrj),2),;
						{ "&Retorna" },,;
						"Projeto x Filial/Planta" )
						
					EndIf
					
				EndIf
				
				
				// consisto valor/saldo, fase e vigencia do prj
				If lRetorno
					
					If !Empty(cPrj)
						
						AF8->( dbSetOrder(1) ) // AF8_FILIAL+AF8_PROJET
						If AF8->( dbSeek(xFilial("AF8")+cPrj) )
							
							// Consistencia do projeto
							If lSldAtv
								
								// Consiste apenas projetos que possuem valor
								If AF8->AF8_XVALOR > 0
									
									
									// Consiste fase do projeto para checar se esta na central de aprovacao
									//If AllTrim(cFasePrj) == AllTrim(AF8->AF8_FASE) // Chamado n. 046284
									If AllTrim(AF8->AF8_FASE) <> AllTrim(cFaseApr) // Se fase diferente de aprovada // Chamado n. 046284
										
										lRetorno := .f.
										
										Aviso(	"MT110LOK-09",;
										"Projeto n. " + AllTrim(cPrj) + " n�o foi aprovado na Central de Aprova��o! " + chr(13) + chr(10) + "Uso ainda n�o permitido..." + chr(13) + chr(10) + ;
										"",;
										{ "&Retorna" },,;
										"Projeto n�o aprovado" )
										
									EndIf
									
									
									// Consiste datas previstas do projeto (AF8) x data de digita��o oriunda do servidor do documento
									If lRetorno
										
										If dDtDig < AF8->AF8_START .or. dDtDig > AF8->AF8_FINISH
											
											lRetorno := .f.
											
											Aviso(	"MT110LOK-10",;
											"Vig�ncia do projeto n. " + AllTrim(cPrj) + " est� fora! Verifique..." + chr(13) + chr(10) +  chr(13) + chr(10)+;
											"Data Digita��o: " + DtoC(dDtDig) + chr(13) + chr(10) +;
											"In�cio-Fim Projeto: " + DtoC(AF8->AF8_START) + " - " + DtoC(AF8->AF8_FINISH),;
											{ "&Retorna" },,;
											"Vig�ncia do Projeto" )
											
										EndIf
										
									EndIf
									
								EndIf
								
							EndIf
							
						EndIf
						
					EndIf
					
				EndIf
				
			Else
				
				If !Empty(cPrj)
					lRetorno := .f.
					
					Aviso(	"MT110LOK-08",;
					"Centro de Custo: " + cCC + "." + Chr(13) + Chr(10) +;
					"N�o permitido o preenchimento do Projeto.",;
					{ "&Retorna" },,;
					"N�o permitido informar projeto para CC que n�o � investimento" )
				EndIf
				
			EndIf
			
		EndIf
		
	EndIf
	
	//�����������������������������������������������������������������������������������������Ŀ
	//� Verifica se todos os itens tem o mesmo grupo de aprova��o em fun��o do centro de custo  �
	//� e item cont�bil                                                                         �
	//�������������������������������������������������������������������������������������������
	If lRetorno
		//�������������������������������������������������������������������������������������Ŀ
		//� S� valida se houver mais de um elemento no aCols                                    �
		//���������������������������������������������������������������������������������������
		If Len( aCols ) > 0
			//���������������������������������������������������������������������������������Ŀ
			//� Obtem a estrutura de aprova��o do centro de custo da linha posicionada          �
			//�����������������������������������������������������������������������������������
			aAprov	:= U_GetAprov( cCusto, cItemCta, nTotal, cProduto )
			//���������������������������������������������������������������������������������Ŀ
			//� Se n�o encontrar aprovador, n�o deixa colocar o pedido                          �
			//�����������������������������������������������������������������������������������
			If Len( aAprov ) == 0
				Aviso(	"MT110LOK-13",;
				"N�o foi localizado controle de al�ada para o centro de custo/Item Cont�bil.",;
				{ "&Retorna" },,;
				"C.Custo/Item: " + cCusto + "/" + cItemCta )
				lRetorno	:= .F.
			Else
				//���������������������������������������������������������������������������������Ŀ
				//� Varre todo o array para valida��o                                               �
				//�����������������������������������������������������������������������������������
				For nLoop := 1 To Len( aCols )
					//�����������������������������������������������������������������������������Ŀ
					//� S� valida se n�o for a linha posicionada                                    �
					//�������������������������������������������������������������������������������
					If !( aCols[nLoop,Len( aHeader ) + 1] ) .And. nLoop <> n
						lRetorno	:= VldCCusto( aCols[nLoop,nPCusto], cCusto, aCols[nLoop,nPItemCta], cItemCta, aAprov )
					EndIf
					//�����������������������������������������������������������������������������Ŀ
					//� Se teve erro na valida��o aborta retornando inv�lido                        �
					//�������������������������������������������������������������������������������
					If !lRetorno
						Exit
					EndIf
				Next nLoop
			EndIf
		EndIf
	EndIf

	//Everson - 04/11/2020. Chamado 2562.
	//Valida se h� item de estudo atrelado ao projeto.
	If lRetorno .And. ! Empty( cProjeto ) .And. Empty( cEstPrj )

		//
		If Upper(Alltrim(cValToChar(Posicione("AF8",1, FWxFilial("AF8") + cProjeto,"AF8_XESTUD")))) == "S"
			Aviso(	"MT110LOK-15",;
			"Projeto: " + cProjeto + "." + Chr(13) + Chr(10) +;
			"� obrigat�rio o preenchimento do c�digo do estudo do projeto.",;
			{ "&Retorna" },,;
			"Conte�do em Branco" )
			lRetorno	:= .F.

		EndIf 

	EndIf
	//

	// Chamado n. 047931 || OS 049195 || CONTROLADORIA || ANDRESSA || 45968437 || C.CUSTO X LOTE -RNX2 - FWNM - 19/03/2019
	If lRetorno
		lRetorno := ChkZCN()
	EndIf
	// 

	//@history ticket 10573 - Fernando Macieira - 08/03/2021 - Ponto de Corre��o - Manuten��o de Ativos
	If lRetorno
		lRetorno := ChkCCOP()
	EndIf

	PutCTD() // @history ticket 85790 - 16/01/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - ITEM CONT�BIL

	//Everson - 13/02/2023 - ticket 87842.
	lRetorno := lRetorno .And. U_ADMNT022P(gdFieldGet("C1_OP", n), "")

	//Everson - 16/02/2023 - Ticket 88670.
	If lRetorno .And. ! gdDeleted(n) .And. ! Empty(cProjeto)
		lRetorno := vldSldPrj(cProjeto)
		
	EndIf
	//

	restarea(aAreaAtu1)

Return( lRetorno )

/*/{Protheus.doc} VldCCusto
	Fun��o para validar se o centro de custo digitado tem a mesma
	estrutura de aprova��o dos demias centros de custos.	
	@type  Static Function
	@author Almir Bandina
	@since 
	@version 01
	/*/
Static Function VldCCusto( cCCLinha, cCCOrig, cItLinha, cItOrig, aAprov )

	//�����������������������������������������������������������������������������������������Ŀ
	//� Define as vari�veis utilizadas na rotina                                                �
	//�������������������������������������������������������������������������������������������
	Local aAux		:= U_GetAprov( cCCLinha, cItLinha )
	Local lRetorno	:= .T.
	Local nLoop		:= 0
	//�����������������������������������������������������������������������������������������Ŀ
	//� Varre o array auxiliar e procura no array de aprovadores se existe                      �
	//�������������������������������������������������������������������������������������������
	For nLoop := 1 To Len( aAux )
		If aScan( aAprov, { |x| x[1] == aAux[nLoop,01] } ) == 0
			lRetorno	:= .F.
			Exit
		EndIf
	Next nLoop
	//�����������������������������������������������������������������������������������������Ŀ
	//� Faz a interface com o usu�rio da diverg�ncia de estrutura de aprova��o                  �
	//�������������������������������������������������������������������������������������������
	If !lRetorno
		Aviso(	"MT110LOK-14",;
		"Existem aprovadores diferentes para o centro de custo/Item Cont�bil informado." + Chr(13) + Chr(10) +;
		"Selecione um centro de custo/Item Cont�bil com a mesma estrutura de aprova��o.",;
		{ "&Retorna" }, 2,;
		"Centro de Custo/Item: " + cCCOrig + "/" + cItOrig )
	EndIf

Return( lRetorno )

/*/{Protheus.doc} ChkZCN
	@type  Static Function
	@author Microsiga
	@since 03/19/2019
	@version 01
/*/
Static Function ChkZCN()

	Local lRet     := .t.
	Local cEmpZCN  := GetMV("MV_#ZCNEMP",,"07")
	Local aAreaZCN := ZCN->( GetArea() )
	Local cLoteZCN := ""
	Local cCC      := ""

	// Empresas autorizadas
	If cEmpAnt $ cEmpZCN
	
		cCC      := gdFieldGet("C1_CC", n)
		cLoteZCN := gdFieldGet("C1_XLOTECC", n)

		// Lote Recria informado
		If !Empty(cLoteZCN)

			ZCN->( dbSetOrder(1) ) // ZCN_FILIAL+ZCN_LOTE                                                                                                                                             
			If ZCN->( dbSeek( FWxFilial("ZCN")+cLoteZCN ) )
			
				// Consisto lote encerrado
				If AllTrim(ZCN->ZCN_STATUS) == "E" 
					lRet := .f.
					Alert("[MT110LOK-ZCN1] - Lote Recria com status Encerrado! Contate a contabilidade...")
				EndIf
				
				// Consisto CC informado
				If lRet
					If AllTrim(cCC) <> AllTrim(ZCN->ZCN_CENTRO)
					  lRet := .f.
					  Alert("[MT110LOK-ZCN2] - Lote Recria n�o amarrado com o Centro de Custo informado! Contate a contabilidade...")
					EndIf
				EndIf
				
			Else
			
				// Lote informado nao cadastrado na ZCN
				lRet := .f.
				Alert("[MT110LOK-ZCN3] - Lote Recria n�o cadastrado! Contate a contabilidade...")

			EndIf

		EndIf
		
		// Chamado n. 048414 || OS 049698 || CONTROLADORIA || ANDRESSA || 45968437 || NOTAS -LOTE RNX2 - FWNM - 10/04/2019
		// CC informado
		If lRet
			If !Empty(cCC)

				ZCN->( dbSetOrder(2) ) // ZCN_FILIAL+ZCN_DESCLT
				If ZCN->( dbSeek( FWxFilial("ZCN")+cCC ) )
				
					If Empty(cLoteZCN)
						lRet := .f.  
						Alert("[MT110LOK-ZCN4] - Centro de Custo informado possui Lote Recria amarrado! Informe o Lote Recria ou contate a contabilidade...")
					EndIf
		
				EndIf
	
			EndIf
		EndIf
		//

	EndIf
	
	RestArea( aAreaZCN )

Return lRet

/*/{Protheus.doc} User Function C1OP
	Fun��o utilizada nos gabilhos dos campos (C1_QUANT, seq 002)
	Sintaxe: If(FindFunction("U_C1OP"),u_C1OP(),Space(TamSX3("C1_OP")[1]))
	@type  Function
	@author Fernando Macieira
	@since 08/02/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 8582 - Fernando Macieira - 08/02/2021 - Replicar OP na pr�xima linha
/*/
User Function C1OP()

	Local cOP  := ""
	Local nAux := 0

	If !ALTERA

		nAux := n-1
		If nAux < 1
			nAux := 1
		Else
			nAux := n-1
		EndIf

		If !gdDeleted(n) .and. !Empty( gdFieldGet("C1_OP", nAux) )
			cOP := gdFieldGet("C1_OP", nAux)
		EndIf

		If !Empty(cOP)
			gdFieldPut("C1_OP", cOP, n)
		EndIf

	EndIf
	//

Return cOP

/*/{Protheus.doc} Static Function ChkCCOP
	Realizar trava no CC 5304 - sempre ter que preencher o campo OP
	@type  Function
	@author user
	@since 08/03/2021
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	ticket 10573 - Fernando Macieira - 08/03/2021 - Ponto de Corre��o - Manuten��o de Ativos
/*/
Static Function ChkCCOP()

	Local lRet    := .t.
	Local cCC5304 := GetMV("MV_#MNTCC",,"5304")
	Local cOP     := ""
	Local cCC     := ""

	cCC := gdFieldGet("C1_CC", n)
	cOP := gdFieldGet("C1_OP", n)

	If AllTrim(cCC) $ AllTrim(cCC5304)

		If Empty(cOP)
			
			lRet := .f.
			Alert("[MT110LOK-CCOP] - Obrigat�rio o preenchimento da OP para estes centro de custo ( " + cCC5304 + " ), conforme exig�ncia departamento de manuten��o." )

		EndIf

	EndIf

Return lRet

/*/{Protheus.doc} nomeStaticFunction PutCTD
	ticket 85790 - 16/01/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - ITEM CONT�BIL
	@type  Static Function
	@author FWNM
	@since 16/01/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function PutCTD()

	Local cItemCTD := GetMV("MV_#ITM111",,"111")
	Local cItemNEW := GetMV("MV_#ITMNEW",,"221")

	If FWCodEmp() == "01" .and. AllTrim(fwCodFil()) $ GetMV("MV_#GRANJS",,"0C|0D|0E|0F|0G|0H|0I|0J|0K|0L|0M|0N|0O|0P|0Q|0R|0S")
		gdFieldPut("C1_ITEMCTA", cItemCTD, n)
	EndIf
	
	// @history ticket 94010 - 25/05/2023 - Fernando Macieira - EMPRESAS NOVAS (EMPRESAS 11, 12 E 13) - ITEM CONT�BIL 221
	If AllTrim(FWCodEmp()) == "11" .or. AllTrim(FWCodEmp()) == "12" .or. AllTrim(FWCodEmp()) == "13"
		gdFieldPut("C1_ITEMCTA", cItemNEW, n)
	EndIf
	// 

Return

/*/{Protheus.doc} nomeStaticFunction
	Ticket 88670.
	Valida��o do projeto.
	@type  Static Function
	@author Everson
	@since 16/02/2023
	@version 01
/*/
Static Function vldSldPrj(cProjeto)

	//Vari�veis.
	Local aArea		:= GetArea()
	Local lRet		:= .T.
	Local lVlDtPrj	:= GetMv("MV_#MT1101",, .F.)
	Local nVlrPrj	:= GetMv("MV_#MT1102",, 100)
	Local nSldPrj	:= 0

	If ! lVlDtPrj
		RestArea(aArea)
		Return .T.

	EndIf
	
	DbSelectArea("AF8")
	AF8->(DbSetOrder(1))
	If AF8->(DbSeek(FWxFilial("AF8") + cProjeto))

		nSldPrj := U_ADCOM017P(cProjeto)

		If nSldPrj < nVlrPrj

			lRet	:= .F.
			Aviso(	"MT110LOK-16",;
			"Projeto: " + cProjeto + "." + Chr(13) + Chr(10) +;
			"Projeto possui saldo menor que R$ " + Transform(nVlrPrj, "@E 999,999,999.99")  + "." + Chr(13) + Chr(10) +;
			"Saldo do projeto R$ " + Transform(nSldPrj, "@E 999,999,999.99")  + ".",;
			{ "&Retorna" },,;
			"Conte�do em Branco" )

		EndIf

		If lRet .And. ! (AF8->AF8_START <= Date() .And. AF8->AF8_FINISH >= Date())

			lRet	:= .F.
			Aviso(	"MT110LOK-17",;
			"Projeto: " + cProjeto + "." + Chr(13) + Chr(10) +;
			"Projeto est� fora da data vigente." + Chr(13) + Chr(10) +;
			"In�cio: " + DToC(AF8->AF8_START) + " Fim: " + DToC(AF8->AF8_FINISH),;
			{ "&Retorna" },,;
			"Conte�do em Branco" )

		EndIf

	EndIf

	RestArea(aArea)

Return lRet
