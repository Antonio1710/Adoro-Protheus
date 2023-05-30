#Include "PROTHEUS.CH"
#Include "APWEBSRV.CH"
#Include "TBICONN.CH"
#Include "TBICODE.CH"
 
/*/
{Protheus.doc} User Function MT116TOK
	Este ponto de entrada pertence a rotina de digitação de conhecimento de frete, MATA116(). É executado na rotina de
    inclusão do conhecimento de frete, A116INCLUI(), quando a tela com o conhecimento e os itens são montados. 
	@type  Function
	@author Abel Babini  
	@since 18/06/2019
	@version 01
	@history  Ch.049508 - Abel Babini - 17/06/2019 - Valida Ped Compra CTE
	@history  Ch. 050177 - Abel Babini - 01/07/2019 - Ajuste na validação
	@history  Ch. 049468 - Abel Babini - 22/07/2019 - Valida Recusa Adoro
	@history  Ch. 050434 - Abel Babini - 30/07/2019 - Valida CTE x Produto 
	@history  Ch. 051082 - Abel Babini - 13/08/2019 - CTE X PED. COMP
	@history  Ch. 051294 - Abel Babini - 27/08/2019 - Incluido condição OR para excluir CTE sem precisar validar Pedido de Compra 
	@history  Ch. 052387 - Abel Babini - 08/10/2019 - Valida CTE x Pedido (Noemi)
	@history  tkt T.I    - Sigoli      - 05/11/2021 - Tratamento errolog  - type mismatch on +=  on U_VLDPCCTE(RECNFECTE.PRW) 16/07/2021 12:02:18 line : 3632
	@history Chamado 62250  - Leonardo P. Monteiro  - 23/11/2020 - Gravação da data de entrega da Nfe.
	@history Everson, 23/11/2022, ticket 18465 - Tratamento para validação com a rotina de entrada de matéria-prima.
	@history Everson, 28/11/2022, ticket 18465 - Alterada posição de validação de CT-e.
	@history Everson, 01/12/2022, ticket 18465 - Tratamento para que a tela do pedido de compra apareça.
	@history Everson, 02/01/2023, ticket 18465 - Correção para obter o número e sério do documento e envio de exclusão para o barramento.
	@history Everson, 12/01/2022, ticket 18465 - Tratamento para validação com a rotina de entrada de matéria-prima.
	@history Everson, 06/03/2023, ticket 18465 - Tratamento para encerramento de pedido de compra.
	@history Everson, 17/03/2023, ticket 18465 - Colocada a tolerância para encerramento do pedido de compra.
	@history Everson, 10/04/2023, ticket 89933 - Alterar pedido desconsiderando roteiro por filial
*/
User Function MT116TOK()

	//Variáveis.
	Local aArea	       := GetArea() //Everson - 23/11/2022 - ticket 18465.
	Local lRet         := .T.
	Local nCont	       := 1
	Local cChave       := ""
	Local cCodFor      := ""
	Local cLojFor      := ""
	Local  i      	   := 0 //Chamado: 034249 Fernando Sigoli 29/09/2017
	Local  cMensagem   := ""
	Local cNfOrig      := ""
	Local cSerieOrig   := ""
	Local cForOrig     := ""
	Local cLojaOrig    := "" 
	Local cDoc	   	   := ""    //Everson - 24/11/2022 - ticket 18465.
	Local cSerie       := ""  //Everson - 24/11/2022 - ticket 18465.
	Local nPosProd     := Ascan(aHeader, { |X| Alltrim(X[2]) == "D1_COD" })
	Local nPosTot      := Ascan(aHeader, { |X| Alltrim(X[2]) == "D1_TOTAL" })
	Local nPosPedido   := Ascan(aHeader, { |X| Alltrim(X[2]) == "D1_PEDIDO" }) //Chamado: 034249 Fernando Sigoli 29/09/2017
	Local nPosItPed    := Ascan(aHeader, { |X| Alltrim(X[2]) == "D1_ITEMPC" }) //Chamado: 034249 Fernando Sigoli 29/09/2017
	Local lIncCXml	   := IsInCallStack("U_CENTNFEXM") .And. INCLUI 	  

	//Everson - 23/11/2022 - ticket 18465.
	//Quando passar pela central, nao validar o pedido de compra, uma vez que a informaçao do pedido na central é obrigatorio
	If (  (IsInCallStack( "U_CEXMCONTR" ) .Or. IsInCallStack( "U_RECNFECTE" ) ) .And. ! INCLUI) //Ch.051294 - 27/08/2019 - Abel Babini Filho - Incluido condição OR para excluir CTE sem precisar validar Pedido de Compra //Everson - 01/12/2022 - ticket 84249.		
		RestArea(aArea)
		Return .T.

	EndIf
	
	//Entrada pela Central XML.
	If lIncCXml //Ch.051294 - 27/08/2019 - Abel Babini Filho - Incluido condição OR para excluir CTE sem precisar validar Pedido de Compra //Everson - 23/11/2022 - ticket 18465. //Everson - 23/11/2022 - ticket 18465.
		
		cChave  := RECNFCTE->XML_CHAVE
		cCodFor	:= Posicione("SA2",3,FWxFilial("SA2")+RECNFCTE->XML_EMIT,"A2_COD")
		cLojFor	:= Posicione("SA2",3,FWxFilial("SA2")+RECNFCTE->XML_EMIT,"A2_LOJA")

		//Everson - 02/01/2022 - Ticket 18465.
		cSerie	:= Substr(Alltrim(cValToChar(RECNFCTE->XML_NUMNF)), 1, 3)
		cDoc    := Substr(Alltrim(cValToChar(RECNFCTE->XML_NUMNF)), 4, 12)

		lRet    := U_MT116T1(cChave, cCodFor, cLojFor, cDoc, cSerie, nPosProd, nPosTot, nPosPedido, nPosItPed)

	//Entrada pela integração Protheus x SAG.
	ElseIf Upper(Alltrim(Funname())) == "INTNFEB" //Everson - 23/11/2022 - ticket 18465.
	
		cNfOrig     := StrZero(Val(Iif(Alltrim(cPnfOri) == "",cDocOri,cPnfOri)),9)
		cSerieOrig  := Iif(Alltrim(cPseriOri)           == "",cSerieOri,cPseriOri) 
		cForOrig    := Iif(Alltrim(cPforneceOri)        == "",cFornecOri,cPforneceOri)
		cLojaOrig   := Iif(Alltrim(cPLojaOri)           == "",cLojaForOri,cPLojaOri)
		
		For nCont := 1 To Len(aCols)
		    
			SqlBuscaNotaOrig(cNfOrig, cSerieOrig, cForOrig, cLojaOrig)

			While TRB->(!Eof())
			
				If Alltrim(TRB->D1_COD) <> Alltrim(aCols[nCont, nPosProd])
				
					lRet := .F.  
		
					cMensagem := "MT116TOK-02"                                           + "<br>" + ;
									"<b>Produto Diferente de Nota Original com Nota de Frete,"       + ;
									" favor verificar </b>"                                 + "<br>" + ;
									"Nota: "            + cDocFrete                         + "<br>" + ; 
									"Serie: "           + cSerieFrete                       + "<br>" + ; 
									"Fornecedor: "      + cForneceFrete                     + "<br>" + ; 
									"Loja: "            + cLojaFrete                        + "<br>" + ; 
									"Nota Orig: "       + cNfOrig                           + "<br>" + ; 
									"Serie Orig: "      + cSerieOrig                        + "<br>" + ; 
									"Fornecedor Orig: " + cFornecOrig                       + "<br>" + ; 
									"Loja Orig: "       + cLojaOrig                         + "<br>" + ;
									"Prod Orig: "       + Alltrim(TRB->D1_COD)              + "<br>" + ;
									"Prod Frete: "      + Alltrim(aCols[nCont,nPosProd])    + "<br>" + ;
									"<b>Nota não Importada !!! </b>"
						
						
					EmailNota(cMensagem)		             
					
					If Alltrim(cMensFinal) == ""
		
						cMensFinal += 'Nota(s) Fiscal(is) Não Importadas: ' + cDocFrete
						
					Else
					
						cMensFinal += ', ' + cDocFrete
					
					EndIf
						
				EndIf
				
				If aCols[nCont,nPosTot] < 1
				
					lRet := .F.  
		
					cMensagem := "MT116TOK-03"                                            + "<br>" + ;
									"<b>Valor Total da Nota de Frete menor que um real,"              + ;
									" favor verificar </b>"                                  + "<br>" + ;
									"Nota: "            + cDocFrete                          + "<br>" + ; 
									"Serie: "           + cSerieFrete                        + "<br>" + ; 
									"Fornecedor: "      + cForneceFrete                      + "<br>" + ; 
									"Loja: "            + cLojaFrete                         + "<br>" + ; 
									"Nota Orig: "       + cNfOrig                            + "<br>" + ; 
									"Serie Orig: "      + cSerieOrig                         + "<br>" + ; 
									"Fornecedor Orig: " + cFornecOrig                        + "<br>" + ; 
									"Loja Orig: "       + cLojaOrig                          + "<br>" + ;
									"Prod Frete: "      + Alltrim(aCols[nCont,nPosProd])     + "<br>" + ;
									"Vl Total: "        + cValtoChar(aCols[nCont,nPosTot]) + "<br>" + ;
									"<b>Nota não Importada !!! </b>"
						
						
					EmailNota(cMensagem)		             
					
					If Alltrim(cMensFinal) == ""
		
						cMensFinal += 'Nota(s) Fiscal(is) Não Importadas: ' + cDocFrete
						
					Else
					
						cMensFinal += ', ' + cDocFrete
					
					EndIf
						
				EndIf
				
				TRB->(DbSkip())

			End
			
			TRB->(DbCloseArea())

		Next nCont
	
	Else //Chamado: 034249 Fernando Sigoli 29/09/2017
		
		Begin Transaction

			DbSelectArea("SC7")
			SC7->(DbGoTop())
			SC7->(DbSetOrder(1)) 

			If Empty(Alltrim(aCols[1,nPosPedido]))
				lRet := .F.
				DisarmTransaction()
				Break

			EndIf

			If SC7->(DbSeek(FWxFilial("SC7") + Alltrim(aCols[1,nPosPedido])))

				While SC7->(!Eof()) .and. SC7->C7_FILIAL == FWxFilial("SC7") .and. SC7->C7_NUM == Alltrim(aCols[1, nPosPedido])
					
					RecLock("SC7",.F.)
						SC7->C7_QUJE 	:= 1
						SC7->C7_XDTENTR := dDatabase
					SC7->(MsunLock())  
					
					SC7->(DbSkip())	

				End

			Else
				lRet := .F.
				DisarmTransaction()
				Break

			EndIf

		End Transaction

		If ! lRet
			uMsgErr("Atenção, pedido de compra não encontrado " + Alltrim(aCols[1, nPosPedido]) + " - CTE")

		EndIf
        
		//Everson - 28/11/2022 - ticket 18465.
		If lRet
		
			For i := 1 To Len(aCols)
			
				If Empty(Alltrim(aCols[i, nPosPedido]))
					lRet := .F.  
					uMsgErr("Atenção, pedido de compra não vinculado ao documento - CTE")
					Exit
				
				EndIf
			
			Next i

		EndIf

   	EndIf

Return lRet
/*/{Protheus.doc} MT116T1
	Validação pra inclusão de CT-e via Central XML.
	@type  Static Function
	@author user
	@since 18/06/2019
	@version 01
/*/
User Function MT116T1(cChave, cCodFor, cLojFor, cNum, cSerie, nPosProd, nPosTot, nPosPedido, nPosItPed)

	//Variáveis.
	Local aArea		:= GetArea()
	Local lRet 		:= .F.
	Local oDlgGPC	:= Nil
	Local oSelPed	:= Nil
	Local oSayPC    := Nil
	Local oSayIT    := Nil
	Local oGetPV    := Nil
	Local oGetIT    := Nil
	Local oBtnOk    := Nil
	Local oBtnCan   := Nil
	Local cPedido   := Space( TamSx3("C7_NUM")[01] )
	Local cItemPC	:= "0001"

	DbSelectArea("ZCW")
	ZCW->(DbSetOrder(2))
	If ZCW->(DbSeek(FWxFilial("ZCW") + cChave))
		uMsgErr("Este CTe foi recusado e não pode ser classificado. Consulte o Depto. Fiscal!")   
		RestArea(aArea)
		Return .F.

	EndIf	
		
	Define MsDialog oDlgGPC Title "Selecionar Pedido de Compra" From 000, 000  To 165, 310 Colors 0, 16777215 Pixel Style 128

		oDlgGPC:lEscClose     := .F. //Nao permite sair ao se pressionar a tecla ESC.
	
		@ 007, 007 Group oSelPed To 060, 147 Prompt " Informe o Pedido de Compra" Of oDlgGPC Color 0, 16777215 Pixel
		
		@ 022, 015 SAY oSayPC Prompt "Pedido de Compra:" Size 050, 007 Of oDlgGPC Colors 0, 16777215 Pixel
		@ 022, 080 SAY oSayIT Prompt "Item:" 			 Size 050, 007 Of oDlgGPC Colors 0, 16777215 Pixel
		
		@ 032, 015 MSGET oGetPV VAR cPedido Size 060, 010 Of oDlgGPC Colors 0, 16777215 Pixel Valid !Empty(cPedido) 
		@ 032, 080 MSGET oGetIT VAR cItemPC Size 060, 010 Of oDlgGPC Colors 0, 16777215 Pixel Valid !Empty(cItemPC) 
		
		Define SButton oBtnOk	From 068, 046 Type 01 Of oDlgGPC Enable Action( Iif( U_MT116T3(cPedido, cItemPC, cCodFor, cLojFor, cNum, cSerie, nPosProd, nPosTot, nPosPedido, nPosItPed), ( lRet := .T., oDlgGPC:End() ), lRet := .F. ) ) //Everson - 23/11/2022 - ticket 18465.
		Define SButton oBtnCan 	From 068, 079 Type 02 Of oDlgGPC Enable Action( lRet:= .F., uMsgErr("Não é possível continuar sem selecionar um pedido válido!"), oDlgGPC:End() )             //Everson - 23/11/2022 - ticket 18465.
	
	Activate MsDialog oDlgGPC Centered

	RestArea(aArea)

Return lRet

//INICIO Chamado 049508 - Abel Babini - 18/06/2019 - Validação do Pedido de Compra antes do Lançamento do CT-e
User Function MT116T3(cPedido, cItemPC, cCodFor, cLojFor, cNum, cSerie, nPosProd, nPosTot, nPosPedido, nPosItPed) //Everson - 23/11/2022 - ticket 18465.

	//Variáveis.
	Local aArea		:= GetArea() //Everson - 23/11/2022 - ticket 18465.
	Local nRet      := 0
	Local nRecOri	:= 0
	Local nValNF	:= 0
	Local nValPC	:= 0
	Local nDifPCNF	:= 0
	Local lPCxNF	:= .T.
	Local nVlTol	:= GETMV("MV_#TOLCTE",,0)
	Local aPrdPed	:= {} //Ch. 050434 - Abel Babini - Valida CTE x Produto (Noemi) - 30/07/2019
	Local aPrdCte	:= {} //Ch. 050434 - Abel Babini - Valida CTE x Produto (Noemi) - 30/07/2019
	Local lPrdDif	:= .F. //Ch. 050434 - Abel Babini - Valida CTE x Produto (Noemi) - 30/07/2019
	Local cFiliais  := Alltrim(GetMv("MV_#FAT171",,"")) //Everson - 23/11/2022 - ticket 18465.
	Local i			:= 1

	If Empty(cPedido) .Or. Empty(cItemPC)
		uMsgErr("Pedido não informado!")
		RestArea(aArea)
		Return .F.

	EndIf
	
	//Everson - 23/11/2022 - ticket 18465.
	//CT-e vinculado à rotina de entrada de matéria-prima.
	If (cFilAnt $cFiliais) 

		nRet := U_MT116T2(cPedido, cItemPC, cCodFor, cLojFor, cNum, cSerie, "I", nPosTot, @nRecOri)
	
		If nRet == 1 //Erro.
			RestArea(aArea)
			Return .F.

		EndIf

		If nRet == 2 //Processado.
			cargPC(aCols, nRecOri, cPedido, cItemPC, nPosPedido, nPosItPed)
			RestArea(aArea)
			Return .T.

		EndIf

	EndIf
	//

	DbSelectarea("SC7")
	SC7->( DbSetorder( 1 ) )
	If ! SC7->( DbSeek( FWxFilial("SC7") + cPedido + cItemPC ) ) .OR. ;
				! (Alltrim(SC7->C7_FORNECE) == Alltrim(cCodFor)) .OR. ;
				! (Alltrim(SC7->C7_LOJA) == Alltrim(cLojFor)) .OR.;
				! (Alltrim(SC7->C7_CONAPRO) == 'L')

		uMsgErr("Pedido não localizado ou inválido!")
		RestArea(aArea)
		Return .F.
		
	EndIf	
				
	nRecOri := SC7->(RecNo())
	lPCxNF	:= .T.

	//nCont := 1 //Ch.050177 - Abel Babini - Ajuste na validação - 01/07/2019
	While ! SC7->(Eof()) .And. ;
			SC7->C7_FILIAL = FWxFilial("SC7") .And. ;
			SC7->C7_NUM == cPedido .And. ;
			Alltrim(SC7->C7_FORNECE) == Alltrim(cCodFor) .And. ;
			Alltrim(SC7->C7_LOJA) == Alltrim(cLojFor) 
		
			nValPC += SC7->C7_TOTAL
		
		If !(Ascan(aPrdPed,SC7->C7_PRODUTO) > 0) //051082 || OS 052395 || FISCAL || ELIZABETE || 8424 || CTE X PED. COMP  ||ABEL BABINI || 13/08/2019
			Aadd(aPrdPed,SC7->C7_PRODUTO)//INICIO Ch. 050434 - Abel Babini - Valida CTE x Produto (Noemi) - 30/07/2019
		
		EndIf

		//nCont += 1 //Ch.050177 - Abel Babini - Ajuste na validação - 01/07/2019
		SC7->(DbSkip())

	End

	SC7->(DbGoTo(nRecOri))

	//INICIO Ch.050177 - Abel Babini - Ajuste na validação - 01/07/2019
	For i:= 1 To Len(aCols)
		nValNF += aCols[i][nPosTot]
		If !(Ascan(aPrdCte,aCols[i][nPosProd]) > 0) //051082 || OS 052395 || FISCAL || ELIZABETE || 8424 || CTE X PED. COMP  ||ABEL BABINI || 13/08/2019
			Aadd(aPrdCte,aCols[i][nPosProd])//INICIO Ch. 050434 - Abel Babini - Valida CTE x Produto (Noemi) - 30/07/2019
		
		EndIf

	Next i

	If !nValNF == nValPC
		lPCxNF := .F.
		nDifPCNF := nValNF - SC7->C7_TOTAL

	EndIf
	//FIM Ch.050177 - Abel Babini - Ajuste na validação - 01/07/2019
	
	//INICIO Ch. 050434 - Abel Babini - Valida CTE x Produto (Noemi) - 30/07/2019
	Asort(aPrdCte)
	Asort(aPrdPed)

	lPrdDif := .F.
	If ! (Len(aPrdCte) == Len(aPrdPed)) //Ch. 052387 - Abel Babini - Valida CTE x Pedido (Noemi) - 08/10/2019
		lPrdDif := .T.

	Else
		For i:= 1 To Len(aPrdCte)
			If ! (Alltrim(aPrdCte[i]) == Alltrim(aPrdPed[i]))
				lPrdDif := .T.
				Exit
			
			EndIf

		Next i

	EndIf
	//FIM Ch. 050434 - Abel Babini - Valida CTE x Produto (Noemi) - 30/07/2019
	
	If !lPCxNF .And. ABS(nDifPCNF) > nVlTol //!(SC7->C7_TOTAL = nValNF)
		uMsgErr("Valor do Pedido ("+Alltrim(Str(nValPC))+") diverge do valor do CTE ("+Alltrim(Str(nValNF))+"). Não é possível continuar.")			
		RestArea(aArea)
		Return .F.

	ElseIf lPrdDif //INICIO Ch. 050434 - Abel Babini - Valida CTE x Produto (Noemi) - 30/07/2019
		uMsgErr("Os produtos do pedido divergem dos produtos da NF Original. Não é possível continuar.")			
		RestArea(aArea)
		Return .F.

	EndIf //FIM Ch. 050434 - Abel Babini - Valida CTE x Produto (Noemi) - 30/07/2019

	SC7->(DbGoTo(nRecOri))

	Begin Transaction

		While ! SC7->(Eof()) .And. ;
				SC7->C7_FILIAL = FWxFilial("SC7") .And. ;
				SC7->C7_NUM == cPedido

			RecLock( "SC7", .F. )
				SC7->C7_QUJE 	:= 1
				//@history Chamado 62250  - Leonardo P. Monteiro  - 23/11/2020 - Gravação da data de entrega da Nfe.
				SC7->C7_XDTENTR := dDatabase
			MsunLock()
			
			SC7->(DbSkip())

		End

	End Transaction

	cargPC(aCols, nRecOri, cPedido, cItemPC, nPosPedido, nPosItPed)

	RestArea(aArea)

Return .T.
/*/{Protheus.doc} cargPC
	Carrega pedido de compra na grid.
	@type  Static Function
	@author Everson
	@since 24/11/2022
	@version 01
/*/
Static Function cargPC(aCols, nRecOri, cPedido, cItemPC, nPosPedido, nPosItPed)

	//Variáveis.
	Local aArea := GetArea()
	Local i     := 1
	Local aXItPC:= {}

	DbSelectArea("SC7")
	SC7->(DbSetOrder(1))
	SC7->(DbGoTop())

	SC7->(DbGoTo(nRecOri))

	While ! SC7->(Eof()) .And. ;
			SC7->C7_FILIAL = FWxFilial("SC7") .And. ;
			SC7->C7_NUM == cPedido
		
		Aadd(aXItPC, SC7->C7_ITEM) //Ch.050177 - Abel Babini - Ajuste na validação - 01/07/2019

		SC7->(DbSkip())

	End

	For i := 1 To Len(aCols)
		aCols[i][nPosPedido] := cPedido
		aCols[i][nPosItPed]	 := Iif(i>Len(aXItPC), cItemPC, aXItPC[i])
		
	Next i

	RestArea(aArea)	

Return Nil
/*/{Protheus.doc} User Function MT116T2
	Retorna quantidade do CT-e que está na rotina de entrada de matéria-prima.
	@type   Function
	@author Everson
	@since 22/11/2022
	@version 01
	0 = Lançamento não realizado pela rotina de entrada de matéria-prima.
	1 = Erro
	2 = Processado
/*/
User Function MT116T2(cPedido, cItem, cForn, cLoja, cNum, cSerie, cOpc, nPosTot, nRecOri, nQuant) // U_MT116T2(cPedido, cItemPC, cCodFor, cLojFor, cNum, cSerie, cOpc, nPosTot, nRecOri)
	
	//Variáveis.
	Local aArea  	:= GetArea()
	Local cQuery 	:= ""
	Local cAlias 	:= GetNextAlias()
	Local lIncl  	:= cOpc == "I"
	Local nToleQ 	:= GetMv("MV_#116T1",,0)
	Local nToleV 	:= GetMv("MV_#116T2",,0)
	Local nQtdUs 	:= 0
	Local nQtTol 	:= 0
	Local nVlrUs 	:= 0
	Local nVrlTol	:= 0
	Local lLock	 	:= GetMv("MV_#116T3",,.T.)
	Local nTolQuant := (GetMv("MV_#FAT635",,0)/100)+1

	Default nRecOri := 0
	Default nQuant  := 0

	If lLock //.And. ! LockByName("MT116T2", .T., .T.)
		RestArea(aArea)
		Conout( DToC(Date()) + " " + Time() + " MT116TOK - MT116T2 - função já está sendo utilizada")
		Return 1

	EndIf

		DbSelectArea("SC7")
		SC7->(DbSetOrder(1))
		SC7->(DbGoTop())
		If ! SC7->(DbSeek( FWxFilial("SC7") + cPedido + cItem ))
		
			If lIncl
				Help(Nil, Nil, "Função MT116T2(M116TOK)", Nil, "Pedido CTE não localizado: " + cPedido + " " + cItem + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
				RestArea(aArea)
				Return 1

			Else
				RestArea(aArea)
				Return 2

			EndIf

		EndIf

		If lIncl .And. SC7->C7_CONAPRO <> "L"
			Help(Nil, Nil, "Função MT116T2(M116TOK)", Nil, "Pedido CTE não está aprovado: " + cPedido + " " + cItem + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
			RestArea(aArea)
			Return 1

		EndIf

		If lIncl .And. SC7->C7_RESIDUO == "S"
			Help(Nil, Nil, "Função MT116T2(M116TOK)", Nil, "Pedido CTE com eliminação de resíduo: " + cPedido + " " + cItem + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
			RestArea(aArea)
			Return 1

		EndIf

		//Valida  fornecedor.
		If lIncl .And. SC7->C7_FORNECE <> cForn .Or. SC7->C7_LOJA <> cLoja

			//Valida entrega por terceiro.
			DbSelectArea("CPX")
			CPX->(DbSetOrder(1))
			CPX->(DbGoTop())
			If ! CPX->( DbSeek( FWxFilial("CPX") + SC7->C7_FORNECE  + SC7->C7_LOJA  + cForn + cLoja ) )
				Help(Nil, Nil, "Função MT116T2(M116TOK)", Nil, "Fornecedor CTE inválido: " + cForn + " " + cLoja + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
				RestArea(aArea)
				Return 1

			EndIf

		EndIf

		nRecOri := SC7->(RecNo())
		
		If nQuant <= 0

			cQuery := " SELECT "
				cQuery += " ISNULL(SUM(ZIN_QUANT), 0) AS ZIN_QUANT "
			cQuery += " FROM "
				cQuery += " " + RetSqlName("ZIN") + " (NOLOCK) AS ZIN "
			cQuery += " WHERE "
				cQuery += " ZIN_FILIAL = '" + FWxFilial("ZIN") + "' "
				cQuery += " AND ZIN_FORCTE = '" + cForn + "' "
				cQuery += " AND ZIN_LOJCTE = '" + cLoja + "' "
				cQuery += " AND ZIN_DOCTE = '" + cNum + "' "
				cQuery += " AND ZIN_SERCTE = '" + cSerie + "' "
				cQuery += " AND ZIN.D_E_L_E_T_ = '' "

			cAlias := GetNextAlias()

			DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery),cAlias,.T.,.T.)

			(cAlias)->(DbGoTop())

			nQuant := Val(cValToChar((cAlias)->ZIN_QUANT))

			(cAlias)->(DbCloseArea())

			If nQuant <= 0
				RestArea(aArea)
				Return 0

			EndIf

		EndIf

		If cOpc == "I" 

			nQtdUs := (SC7->C7_QUJE + nQuant)
			nQtTol := (SC7->C7_QUANT * (1+(nToleQ/100)))

			nVlrUs := ((SC7->C7_QUJE + nQuant) * SC7->C7_PRECO)
			nVrlTol:= (SC7->C7_TOTAL  * (1+(nToleV/100)))
		
			If (nQtdUs <= nQtTol); //Valida quantidade.
			.And. (nVlrUs <= nVrlTol) //Valida preço total.

				RecLock( "SC7", .F. )
					SC7->C7_QUJE 	:= SC7->C7_QUJE + nQuant
					SC7->C7_XDTENTR := dDatabase
					If (SC7->C7_QUJE + nQuant) >= (SC7->C7_QUANT * nTolQuant) //Everson - 17/03/2023. ticket 18465.
						SC7->C7_ENCER   := "E"
					EndIf
				SC7->(MsunLock())

			Else
				Help(Nil, Nil, "Função MT116T2(M116TOK)", Nil, "Pedido CTE não possui saldo suficiente: " + cPedido + " " + cItem + ".", 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
				RestArea(aArea)
				Return 1
				
			EndIf

		ElseIf cOpc == "E" 
		
			nQuant := Iif((SC7->C7_QUJE - nQuant) >= 0, SC7->C7_QUJE - nQuant, 0)

			RecLock( "SC7", .F. )
				SC7->C7_QUJE   := nQuant
				SC7->C7_ENCER  := ""
				If nQuant == 0
					SC7->C7_XDTENTR := SToD("")

				EndIf

			SC7->(MsunLock())

		Else
			Help(Nil, Nil, "Função MT116T2(M116TOK)", Nil, "Não foi possível ajustar a quantidade entregue do pedido CTE " + cPedido + " " + cItem + ". Opção inválida (cOpc) " + cValToChar(cOpc), 1, 0, Nil, Nil, Nil, Nil, Nil, {""})
			RestArea(aArea)
			Return 1

		EndIf

	If lLock
		UnLockByName("MT116T2", .T., .T.)

	EndIf

	RestArea(aArea)

Return 2

Static Function SqlBuscaNotaOrig(cNfOrig, cSerieOrig, cForOrig, cLojaOrig) 

	Local cFil := FWxFilial("SD1")
                                                                         
	BeginSQL Alias "TRB"
			%NoPARSER%  
			SELECT D1_FILIAL,
			       D1_DOC,
				   D1_SERIE,
				   D1_COD,
				   D1_TOTAL
			  FROM %Table:SD1% 
			 WHERE D1_FILIAL   = %EXP:cFil%
			   AND D1_DOC      = %EXP:cNfOrig%
			   AND D1_SERIE    = %EXP:cSerieOrig%
			   AND D1_FORNECE  = %EXP:cForOrig%
			   AND D1_LOJA     = %EXP:cLojaOrig%
			   AND D_E_L_E_T_ <> '*'
	EndSQl             
RETURN(NIL) 

STATIC FUNCTION EmailNota(cMensagem)		             

    Local cServer      := Alltrim(GetMv("MV_RELSERV"))  
    Local cAccount     := AllTrim(GetMv("MV_RELACNT"))
    Local cPassword    := AllTrim(GetMv("MV_RELPSW"))
    Local cFrom        := AllTrim(GetMv("MV_RELACNT"))
    Local cTo          := AllTrim(GetMv("MV_#EMAFIS"))
    Local lOk          := .T.  
    Local lAutOk       := .F. 
    Local lSmtpAuth    := GetMv("MV_RELAUTH",,.F.) 
    Local cSubject     := ""  
    Local cBody        := ""
    Local cAtach       := ""               
    
	//** INICIO ENVIO DE EMAIL CONFIRMANDO A GERACAO DO PEDIDO DE VENDA ** \\
                            
    cBody        := RetHTML(cMensagem)
    lOk          := .T.  
    lAutOk       := .F. 
    Connect Smtp Server cServer Account cAccount Password cPassword Result lOk
	                        
	If lAutOk == .F.
		If ( lSmtpAuth )
			lAutOk := MailAuth(cAccount,cPassword)
	    Else
	        lAutOk := .T.
	    EndIf

	EndIf

	If lOk .And. lAutOk     
	   cSubject := "INTEGRACAO SAG x PROTHEUS FRETE "          
	   Send Mail From cFrom To cTo Subject cSubject Body cBody ATTACHMENT cAtach Result lOk

	EndIf            
	
	If lOk
	   Disconnect Smtp Server

	EndIf
				                        
    //** FINAL ENVIO DE EMAIL CONFIRMANDO A GERACAO DO PEDIDO DE VENDA ** \\

RETURN(NIL)   


Static Function RetHTML(cmensagem)

	Local cRet       := "" 

	cRet := "<p <span style='"
	cRet += 'font-family:"Calibri"'
	cRet += "'><b>INTEGRACAO SAG X PROTHEUS............: </b>" 
	cRet += "<br>"                                                                                        
	cRet += "<b>STATUS.............: </b>"
	cRet += " INTEGRACAO DE FRETE COM ERRO"
	cRet += "<br>"
	cRet += "<br>"
	cRet += cmensagem
	cRet += "<br>"
	cRet += "<br><br>ATT, <br> TI <br><br> E-mail gerado por processo automatizado."
	cRet += "<br>"
	cRet += '</span>'
	cRet += '</body>'
	cRet += '</html>'
      
Return(cRet)  	                             

//Valida o Pedido de Compras digitado 
Static Function uMsgErr( cTxtErr )
	Local oDlgErr	:= Nil
	Local oBtnCan	:= Nil

	DEFINE MSDIALOG oDlgErr TITLE "Erro na seleção!" FROM 000, 000  TO 165, 310 COLORS 0, 16777215 PIXEL style 128
	oDlgErr:lEscClose     := .T. //Permite sair ao se pressionar a tecla ESC.
	
	DEFINE SBUTTON oBtnCan 	FROM 068, 079 TYPE 02 OF oDlgErr ENABLE Action( oDlgErr:End() )
	
	@ 005, 010 SAY OemToAnsi(cTxtErr) SIZE 150, 025 OF oDlgErr COLORS 0, 16777215 PIXEL

	ACTIVATE MSDIALOG oDlgErr CENTERED

Return
