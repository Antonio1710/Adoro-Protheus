#INCLUDE "protheus.ch"

/*/{Protheus.doc} User Function MTA105LIN
    LOCALIZACAO: Function A105LinOk() - Validar a linha da Solicita��o ao Almoxarifado digitada.
    DESCRICAO : Pode ser utilizado para validar os dados na linha da solicita��o ao almoxarifado digitada.             
    UTILIZACAO: Se tiver marcado o campo CP_XTIPO == T verifica Saldo em estoque cria armazem na SB2 e obriga a digitacao 
    dos campos CP_XLOCDES e CP_XPRODES Local e Produto Destino
    @author Heverson Gomes
    @since 22/04/2008
    @history chamado 046284 - FWNM     		- 08/01/2019 - Novas regras alteracao valor
    @history chamado 047931 - FWNM     		- 20/03/2019 - OS 049195 || CONTROLADORIA || ANDRESSA || 45968437 || C.CUSTO X LOTE -RNX2
    @history chamado 048414 - FWNM     		- 10/04/2019 - OS 049698 || CONTROLADORIA || ANDRESSA || 45968437 || NOTAS -LOTE RNX2
    @history chamado 051136 - William  		- 16/08/2019 - OS 052452 || CONTROLADORIA || REINALDO || 8947 || REQUISICAO X C.CUSTO - INCLUSAO DE TRAVA PARA LANCAMENTO DE SOLICITACAO DE ARMAZEM SE O USUARIO NAO ESTIVER COM LIBERACAO DE CENTOR DE CUSTO 
    @history chamado 050722 - William  		- 26/08/2019 - OS 052025 || MANUTENCAO || DEBORA || 8935 || DEBORA MANUTENCAO - SOLICITADO PELA MANUTENCAO A CRIACAO DE UM CAMPO NA SOLICITACAO AO ARMAZEM DE CODIGO DO BEM QUANDO FOR O CENTRO DE CUSTO 5304 OBRIGAR A DIGITAR O CODIGO DO BEM. 
    @history chamado 055188 - FWNM     		- 18/02/2020 - OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA
	@history chamado 053926 - Everson    	- 28/02/2020 - Tratamento para lan�amento autom�tico de solicita��o ao armaz�m.
	@history chamado T.I    - Tiago Sttoco	- 13/05/2020 - Tratamento para validar somente na inclusao da s.a
	@history chamado 058732 - Everson     	- 16/06/2020 - Tratamento para lan�amento autom�tico de solicita��o ao armaz�m VP.
	@history chamado 059784 - Abel Babini 	- 21/07/2020 - Retirar obrigatoriedade do campo CP_XCODBEM
	@history chamado 999    - William Costa	- 10/09/2020 - Ajustado a mensagem de erro que mostra na tela do usuario de codigo do bem para numero da ordem de produ��o.
	@history chamado 3113   - William Costa	- 08/10/2020 - Adicionado valida��o para pedir a ordem de produ��o, somente para a empresa Adoro, filial de v�rzea, as outras empresas e filiais n�o obrigar a informar ordem de produ��o evitando erros de saida de estoque errada
	@history ticket  6467   - Fernando Maci - 14/12/2020 - Erro Rotina Solicita��o ao Armazem - MATA105
	@history ticket  T.I.   - Tiago Stoco	- 26/02/2021 - Corre��o de fontes.
    @history ticket   15402 - Fernando Maci	- 10/06/2021 - REQUISI��ES ALMOXARIFADO - CC 5131 FILIAL 03
	@history ticket   19122 - Sigoli	    - 21/09/2021 - REQUISI��ES ALMOXARIFADO - CC 5318 - item contabil 111 - FILIAL 03
	@history ticket 71057 - Fernando Macieira - 08/04/2022 - Item cont�bil Lan�amentos da Filial 0B - Itapira
	@history ticket 77603 - Fernando Macieira - 04/08/2022 - Ceres - Solicita��o Almoxarifado - Requisi��es - Vincula��o item cont�bil 124
	@history ticket 85790 - 16/01/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - ITEM CONT�BIL
	@history ticket 84724 - 07/02/2023 - Everson - Adicionado item de estudo.
	@history Everson, 13/02/2023, ticket 87842 - Valida��o uso de OP.
	@history ticket 89178 - 28/02/2023 - Fernando Macieira - A regra na filial 03 �, usar item 114, com exce��o de 5131 e 5134 deve ser item 113 e centros de custos iniciados com 7 deve ser item 111
	@history chamado 058732 - Everson - 24/03/2023 - Tratamento para lan�amento autom�tico de solicita��o ao armaz�m Safeegg.
	@history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 23/05/2023 - Revis�o Ajuste Nova Empresa
	@history ticket 94010 - 25/05/2023 - Fernando Macieira - EMPRESAS NOVAS (EMPRESAS 11, 12 E 13) - ITEM CONT�BIL 221
/*/
User Function MTA105LIN()

	Local _aArea 	  := GetArea()
	Local _AreaSCP	  := SCP->(GetArea())
	Local lRet   	  := .T.
	Local _nPositem	  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "CP_ITEMCTA" })
	Local _nPosGrp	  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "CP_GRUPO"   }) //Everaldo Casaroli 11/11/2008
	Local nPosCC	  := ASCAN(aHeader, {|x| Alltrim(x[2]) == "CP_CC"      }) //Everaldo Casaroli 11/11/2008
	Local _NPOSPROJ   := ASCAN(aHeader, {|x| ALLTRIM(x[2]) == "CP_CONPRJ"  })
	Local _NPOSCProj  := ASCAN(aHeader, {|x| ALLTRIM(x[2]) == "CP_CODPROJ" })
	Local nLocal      := ASCAN(aHeader, {|x| ALLTRIM(x[2]) == "CP_LOCAL"   })
	Local nProduto    := ASCAN(aHeader, {|x| ALLTRIM(x[2]) == "CP_PRODUTO" })
	Local nXLocDes    := ASCAN(aHeader, {|x| ALLTRIM(x[2]) == "CP_XLOCDES" })
	Local nXProDes    := ASCAN(aHeader, {|x| ALLTRIM(x[2]) == "CP_XPRODES" })
	Local nPosQuant   := ASCAN(aHeader, {|x| ALLTRIM(x[2]) == "CP_QUANT"   })
	Local nPosXtipo   := ASCAN(aHeader, {|x| ALLTRIM(x[2]) == "CP_XTIPO"   })
	Local nPosOP  	  := ASCAN(aHeader, {|x| ALLTRIM(x[2]) == "CP_OP" })
	Local _ItemCta	  := SuperGetMV("MV_AD_ITEM") // ITEM CONTABIL PERMITIDO NA FILIAL
	Local nQtdEstoque := 0
	Local nItemEst    := ASCAN(aHeader, {|x| ALLTRIM(x[2]) == "CP_XITEMST" }) //Everson - 07/02/2023 - ticket 84724.
	
	// FWNM - 02/03/2018 - Projetos Investimentos
	Local lSldAtv  := GetMV("MV_#PRJSLD",,".T.")
	//Local cFasePrj := GetMV("MV_PRJINIC",,"05")
	
	// Chamado n. 046284
	//Local cFaseRej := GetMV("MV_#FASREJ",,"01")
	Local cFaseApr := GetMV("MV_#FASEOK",,"03")
	// 
	Local lValidUser := .F.

	// Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 17/02/2020
	Local lManut    := AllTrim(gdFieldGet("CP_XTIPO",n))=="M" 
	Local cCCusto   := GetMV("MV_#MANUCC",,"5304")
	Local cLocMan   := GetMV("MV_#MANLO2",,"02")
	Local cUsrManut := GetMV("MV_#MANUSU",,"001428") 
    Local cLocalMan := GetMV("MV_#MANLOC",,"48")
	Local i         := 0 
	Local y			:= 0
	Private _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 23/05/2023
	Private _cEmpFL1 := SuperGetMv("MV_#EMPFL1",.F.,"0102/1301") //Codigos de Empresas+Filiais Ativas Grupo 1 //ticket TI - Antonio Domingos - 23/05/2023
	
	//@history ticket 6467   - Fernando Maci - 14/12/2020 - Erro Rotina Solicita��o ao Armazem - MATA105
	If lCopia
		gdFieldPut("CP_EMISSAO", dDatabase, n)		
	EndIf
	//
	
	// *** INICIO WILLIAM COSTA 16/08/2019 CHAMADO 051136 || OS 052452 || CONTROLADORIA || REINALDO_FRANCISCHINELLI || 8947 || REQUISICAO X C.CUSTO *** // 
	
	//Pesquisa no PAE se existe a amarra��o usu�rio x centro de custo                         
	DBSELECTAREA("PAE")
	DBSETORDER(1)
	IF DBSEEK(FWxFilial("PAE")+__cUserId, .T.)
	
        WHILE PAE->(!EOF()) .AND. PAE->PAE_FILIAL == FWxFilial("PAE") .AND. PAE->PAE_CODUSR == __cUserId
            
            IF aCols[n,nPosCC]   >= PAE->PAE_CCINI  .AND.; 
                aCols[n,nPosCC]   <= PAE->PAE_CCFIM  .AND.;
                aCols[n,_nPosGrp] >= PAE->PAE_GRPINI .AND.; 
                aCols[n,_nPosGrp] <= PAE->PAE_GRPFIM
                
                lValidUser	:= .T.
                
            ENDIF
            
            PAE->(DBSKIP())
            
        ENDDO
	
	ELSE
	
		lValidUser	:= .F.
	
	ENDIF
	
	IF lValidUser == .F. .And. ! isInCallStack("U_ADEST043P") .And. ! isInCallStack("U_ADLOG022P") .And. !IsInCallStack("U_ADEST079P") .And. !IsInCallStack("U_ADEST086P") //Everson - 28/02/2020. Chamado 053926. //Everson - 16/06/2020. Chamado 058732. //Everson - 24/03/2023. Chamado 90612.
	
		Aviso("MT105LIN",;
		      "O centro de custo informado n�o esta autorizado para o usu�rio." + Chr(13) + Chr(10) +;
		      "Selecione um centro de custo v�lido para o usu�rio. Case Necess�rio ligue para a Controladoria Liberar o Centro de Custo",;
		      {"&Retorna"}, 2,;
		      "Centro de Custo: " + ALLTRIM(aCols[n,nPosCC]) + ' e Grupo de Produto: ' + ALLTRIM(aCols[n,_nPosGrp]))
		lRet:= .F.
		
	ENDIF
	
	// *** FINAL WILLIAM COSTA 16/08/2019 CHAMADO 051136 || OS 052452 || CONTROLADORIA || REINALDO_FRANCISCHINELLI || 8947 || REQUISICAO X C.CUSTO *** //
	
	//&&Valida se o projeto esta encerrado ou nao
	DbSelectArea("AF8")
	DbSetOrder(1)
	if dbseek(xFilial("AF8")+ACOLS[N,_NPOSPROJ])
		if AF8->AF8_ENCPRJ == "1"
			MsgAlert("O Projeto "+ACOLS[N,_NPOSPROJ]+" se encontra ENCERRADO e nao aceita mais lancamentos.")
			lRet:= .F.
		endif

		//Everson - 07/02/2023. Chamado 84724.
		If lRet .And. nItemEst > 0 .And. Upper(Alltrim(cValToChar(AF8->AF8_XESTUD))) == "S" .And. Empty(Alltrim(cValToChar(aCols[n,nItemEst])))
			lRet	:= .F.
			Aviso(	"MTA105LIN",;
			"Projeto: " + ACOLS[N,_NPOSPROJ] + "." + Chr(13) + Chr(10) +;
			"Necess�rio informar o item de estudo do projeto.",;
			{ "&Retorna" },,;
			"" )
					
		EndIf
		//

	endif
	
	//Obriga informar o codigo do projeto se o campo Projeto estiver preenchido               
	If cEmpAnt $ _cEmpAt1 //ticket TI - Antonio Domingos - 23/05/2023 
		//If !Empty( ACOLS[N,_NPOSPROJ] ) .And. Empty(ACOLS[N,_NPOSCProj])
		If SubStr(ACOLS[N,nPosCC], 1, 1) == "9" .And. Empty(ACOLS[N,_NPOSCProj])
			Aviso(	"MTA105LIN",;
			"Projeto: " + ACOLS[N,_NPOSCProj] + "." + Chr(13) + Chr(10) +;
			"� obrigat�rio o preenchimento do Codigo do Projeto.",;
			{ "&Retorna" },,;
			"Conte�do em Branco" )
			lRet	:= .F.
		ElseIf Empty(ACOLS[N,_NPOSPROJ]) .And. !Empty(ACOLS[N,_NPOSCProj])
			aCols[n,aScan(aHeader,{|x| AllTrim(x[2]) == "CP_CODPROJ"})] := "   "
		EndIf
	Endif
	
    // Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 18/02/2020
	If lManut 

	    // consisto logins permitidos
        If !(__cUserID $ cUsrManut)
            lRet := .f.
            MsgStop("Solicita��o de Armaz�m de Transfer�ncia de Manuten��o n�o est� autorizado, par�metro MV_#MANUSU", "[MTA105LIN-01] - Transfer�ncia de Manuten��o - Login")
        EndIf

	    // consisto almoxarifado origem
		If lRet
			If !(AllTrim(gdFieldGet("CP_LOCAL",n)) $ cLocMan)
			    lRet := .f.
				MsgStop("Solicita��o de Armaz�m de Transfer�ncia de Manuten��o precisa estar contido no almoxarifado " + cLocMan, "[MTA105LIN-02] - Transfer�ncia de Manuten��o - Almoxarifado origem")
			EndIf
		EndIf

        // consisto CCusto permitido
        If lRet
            If !(AllTrim(gdFieldGet("CP_CC",n)) $ cCCusto)
                lRet := .f.
                MsgStop("Solicita��o de Armaz�m de Transfer�ncia de Manuten��o precisa estar contido no CCusto " + cCCusto, "[MTA105LIN-03] - Transfer�ncia de Manuten��o - Centro Custo")
            EndIf
        EndIf

        // Consisto local destino
        If Empty(AllTrim(aCols[n,nXLocDes])) .or. !(AllTrim(aCols[n,nXLocDes]) $ cLocalMan)
            lRet := .f.
            MsgStop("Solicita��o de Armaz�m de Transfer�ncia de Manuten��o precisa ter algum destes locais de destino informado " + cLocalMan, "[MTA105LIN-04] - Transfer�ncia de Manuten��o - Local Destino")
        EndIf
                
        // Consisto locais origem x destino
        If AllTrim(aCols[n,nXLocDes]) == AllTrim(aCols[n,nLocal])
            lRet := .f.
            MsgStop("Solicita��o de Armaz�m de Transfer�ncia de Manuten��o precisa ter local origem diferente do destino", "[MTA105LIN-05] - Transfer�ncia de Manuten��o - Local Origem x Destino")
        EndIf
                
        // Consisto produto destino
        If Empty(AllTrim(aCols[n,nXProDes]))
            lRet := .f.
            MsgStop("Solicita��o de Armaz�m de Transfer�ncia de Manuten��o precisa ter produto destino informado", "[MTA105LIN-06] - Transfer�ncia de Manuten��o - Produto Destino")
        EndIf

    Else

        // *** INICIO BLOCO K CHAMADOS 029892 E 037716 - WILLIAM COSTA 17/11/2017 *** //
        IF __cUserID $ GETMV("MV_#USUTRA")
            
            IF ALLTRIM(ACOLS[n,nPosXtipo]) == 'T'
                
                IF ALLTRIM(ACOLS[n,nXLocDes]) == ''
                    
                    ALERT("MTA105LIN - Devido a Ser uma Transfer�ncia, necess�rio informar o campo Local Destino, favor verificar!!!")
                    
                    lRet := .F.
                    
                ENDIF
                
                IF ALLTRIM(ACOLS[n,nXLocDes]) == ALLTRIM(ACOLS[n,nLocal])
                    
                    ALERT("MTA105LIN - Devido a Ser uma Transfer�ncia, necess�rio informar o campo Local Destino diferente de Local Origem, favor verificar!!!")
                    
                    lRet := .F.
                    
                ENDIF
                
                IF ALLTRIM(ACOLS[n,nXProDes]) == ''
                    
                    ALERT("MTA105LIN - Devido a Ser uma Transfer�ncia, necess�rio informar o campo Produto Destino, favor verificar!!!")
                    
                    lRet := .F.
                    
                ENDIF
                
                IF !(ALLTRIM(ACOLS[n,nPosCC]) $ GETMV("MV_#CCTRAN"))
                    
                    ALERT("MTA105LIN - Devido a Ser uma Transfer�ncia, liberado somente esses centro de Custos: " + GETMV("MV_#CCTRAN") + ", favor verificar!!!")
                    
                    lRet := .F.
                    
                ENDIF
                
                // *** INICIO CHAMADO 038430 WILLIAM COSTA *** //

                // travar para aceitar produtos somente que pertence aos grupo 9006/9007/9037.
                IF !(Posicione("SB1",1,xFilial("SB1")+ALLTRIM(ACOLS[n,nProduto]),"B1_GRUPO")  $ GETMV("MV_#GPTRAN"))
                    
                    ALERT("MTA105LIN - Devido a Ser uma Transfer�ncia, liberado somente esses Grupos de Produtos: " + GETMV("MV_#GPTRAN") + ", favor verificar!!!")
                    
                    lRet := .F.
                    
                ENDIF
                
                // Resolver caso do local destino estar indo em branco
                IF ACOLS[n,nXLocDes] == ''
                    ACOLS[n,nXLocDes] := '03    '
                ENDIF
                
                // Resolver caso do produto destino estar indo em branco
                IF ACOLS[n,nXProDes] == ''
                    ACOLS[n,nXProDes] := ACOLS[n,nProduto]
                ENDIF

                // *** FINAL CHAMADO 038430 WILLIAM COSTA *** //

            EndIf

        EndIf

    EndIf

    // Consist�ncias para destino
    If lManut .or. AllTrim(gdFieldGet("CP_XTIPO",n))=="T"

        IF lRet == .T.
                    
            DbSelectArea("SB2")
            SB2->(DbSetOrder(1))
            If !SB2->(DbSeek( xFilial("SB2") + ACOLS[n,nXProDes] + ACOLS[n,nXLocDes],.T.))
                IF MsgNoYes( "Deseja Criar o Produto no armazem de destino?")
                    CriaSB2(ACOLS[n,nXProDes],ACOLS[n,nXLocDes])
                ELSE
                    SB2->( DBCLOSEAREA() )
                    lRet := .F.
                    RETURN(lRet)
                ENDIF
            ENDIF
                    
            SB2->( DBCLOSEAREA() )
        
        ENDIF
        
        IF lRet == .T.
                    
            DbSelectArea("SB2")
            SB2->(DbSetOrder(1))
            IF SB2->(DbSeek( xFilial("SB2") + ACOLS[n,nProduto] + ACOLS[n,nLocal],.T.))
                nQtdEstoque := SaldoMov(Nil,Nil,Nil,.T.,Nil,Nil,Nil,dDatabase) - ACOLS[n,nPosQuant]
            ENDIF
                    
            IF nQtdEstoque < 0
                Alert("MTA105LIN - Opera��o n�o permitida! Produto ficara com estoque negativo! " + "["+ alltrim(ACOLS[n,nProduto])+"/"+ Alltrim(ACOLS[n,nLocal]) + "]" ,"Atencao")
                SB2->( DBCLOSEAREA() )
                lRet := .F.
            ENDIF
                    
            SB2->( DBCLOSEAREA() )
                    
        ENDIF

    	// *** FINAL BLOCO K CHAMADOS 029892 E 037716 - WILLIAM COSTA 17/11/2017 *** //
	
    EndIf
	
	// Projetos - FWNM - 06/04/2018
	If lRet
		
		If !gdDeleted(n)
			
			dDtDig  := msDate()
			
			cPrj    := gdFieldGet("CP_CONPRJ", n)
			cCC     := gdFieldGet("CP_CC", n)
			
			lPrjInv := Left(AllTrim(cCC),1) == "9"
			
			// Qdo for prj investimento
			If lPrjInv .and. ( !Alltrim(cCC) $ GetMV("MV_#CCPADR") )
				
				If Empty(cPrj)
					lRet := .f.
					
					Aviso(	"MTA105LIN-06",;
					"Centro de Custo: " + cCC + "." + Chr(13) + Chr(10) +;
					"� obrigat�rio o preenchimento do Projeto.",;
					{ "&Retorna" },,;
					"Conte�do em Branco" )
				EndIf
				
				// Consiste CC permitidos para aquele projeto (ZC1)
				If lRet
					
					ZC1->( dbSetOrder(1) ) // ZC1_FILIAL+ZC1_PROJET+ZC1_CC
					If ZC1->( !dbSeek(xFilial("ZC1")+cPrj+cCC) )
						
						lRet := .f.
						
						Aviso(	"MTA105LIN-03",;
						"Centro Custo n�o permitido para este projeto! Verifique..." + chr(13) + chr(10) +  chr(13) + chr(10)+;
						"CC: " + cCC + " - " + Posicione("CTT",1,xFilial("CTT")+cCC,"CTT_DESC01") + chr(13) + chr(10) +;
						"Projeto: " + cPrj + " - " + AF8->AF8_DESCRI,;
						{ "&Retorna" },,;
						"Projeto x CC permitidos" )
						
					EndIf
					
				EndIf
				
				// Consiste filial/planta permitida para aquele CC
				If lRet
					
					If Left(AllTrim(cPrj),2) <> cFilAnt
						
						lRet := .f.
						
						Aviso(	"MTA105LIN-04",;
						"Este projeto n. " + AllTrim(cPrj) + " n�o pertence a esta filial! Verifique..." + chr(13) + chr(10) +  chr(13) + chr(10)+;
						"Filial/Planta: " + cFilAnt + chr(13) + chr(10) +;
						"Projeto/Planta: " + Left(AllTrim(cPrj),2),;
						{ "&Retorna" },,;
						"Projeto x Filial/Planta" )
						
					EndIf
					
				EndIf
				
				// Consistencia valores/saldos, fase e vigencia
				If lRet
					
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

										lRet := .f.
										
										Aviso(	"MTA105LIN-01",;
										"Projeto n. " + AllTrim(cPrj) + " n�o foi aprovado na Central de Aprova��o! " + chr(13) + chr(10) + "Uso ainda n�o permitido..." + chr(13) + chr(10) + ;
										"",;
										{ "&Retorna" },,;
										"Projeto n�o aprovado" )
										
									EndIf
									
									If lRet
							
										// Consiste datas previstas do projeto (AF8) x data de digita��o oriunda do servidor do documento
										If dDtDig < AF8->AF8_START .or. dDtDig > AF8->AF8_FINISH
											
											lRet := .f.
											
											Aviso(	"MTA105LIN-02",;
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
					
					// Grava valor do projeto
					nQtd   := gdFieldGet("CP_QUANT", n)
					cProd  := gdFieldGet("CP_PRODUTO", n)
					cAlm   := gdFieldGet("CP_LOCAL", n)
					
					nPrjVlr := UpSB2(cProd, cAlm, nQtd)
					
					If nPrjVlr > 0
						gdFieldPut("CP_XPRJVLR", nPrjVlr, n)
						
					Else
						lRet := .f.
						Aviso(	"MTA105LIN-05",;
						"Projeto n. " + AllTrim(cPrj) + " n�o foi valorizado... Custo m�dio no SB2 zerado!" + chr(13) + chr(10) + ;
						"",;
						{ "&Retorna" },,;
						"Projeto sem valor" )
						
					EndIf
					
					// Consistencia do projeto
					If lSldAtv
						
						AF8->( dbSetOrder(1) ) // AF8_FILIAL+AF8_PROJET
						AF8->( dbSeek(xFilial("AF8")+cPrj) )
						
						// Consiste apenas projetos que possuem valor
						If AF8->AF8_XVALOR > 0
							
							If lRet
								
								// Consiste saldo projeto
								nSldPrj := u_ADCOM017P(cPrj)
								
								If nPrjVlr > nSldPrj
									
									lRet := .f.
									
									Aviso(	"MTA105LIN-08",;
									"Saldo do projeto n. " + AllTrim(cPrj) + " insuficiente! Verifique..." + chr(13) + chr(10) +  chr(13) + chr(10)+;
									"[SA] L�quido: " + Transform(nPrjVlr, PesqPict("SCP","CP_XPRJVLR")) + chr(13) + chr(10) +;
									"[PRJ] Saldo: " + Transform(nSldPrj, PesqPict("SCP","CP_XPRJVLR")),;
									{ "&Retorna" },,;
									"Projeto sem saldo" )
									
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
				
			Else
				
				If !Empty(cPrj)
					lRet := .f.
					
					Aviso(	"MTA105LIN-07",;
					"Centro de Custo: " + cCC + "." + Chr(13) + Chr(10) +;
					"N�o permitido o preenchimento do Projeto.",;
					{ "&Retorna" },,;
					"N�o permitido informar projeto para CC que n�o � investimento" )
				EndIf
			EndIf
		EndIf
	EndIf
	
	// FWNM - 23/03/2018 - Totaliza projetos informados nos itens para confrontar com o saldo do mesmo
	If lRet
		
		// Controle Saldo Projeto ativo
		If lSldAtv
			
			aTtPrj := {} // armazenar� os dados do projeto para totalizar e consistir
			
			For i:=1 to Len(aCols)
				
				If !gdDeleted(i)
					
					cPrj    := gdFieldGet("CP_CONPRJ", i)

                    // @history ticket   15402 - Fernando Maci	- 10/06/2021 - REQUISI��ES ALMOXARIFADO - CC 5131 FILIAL 03
                    If AllTrim(cEmpAnt) == "01" .and. AllTrim(cFilAnt) == "03" 
					
						If AllTrim(gdFieldGet("CP_CC", i)) $ GetMV("MV_#SCPCC",,"5131")
						
							gdFieldPut("CP_ITEMCTA", GetMV("MV_#CPITCT",,"113"), i)
						
						ElseIf AllTrim(gdFieldGet("CP_CC", i)) $ GetMV("MV_#SCPC2",,"5318") //ticket   19122 - Sigoli -  21/09/2021	
						
							gdFieldPut("CP_ITEMCTA", GetMV("MV_#CPITCT",,"111"), i)
						
						EndIf
					
					EndIf
                    //

					// @history ticket 71057 - Fernando Macieira - 08/04/2022 - Item cont�bil Lan�amentos da Filial 0B - Itapira
					If AllTrim(cEmpAnt) == "01" .and. AllTrim(cFilAnt) == "0B"
						gdFieldPut("CP_ITEMCTA", AllTrim(GetMV("MV_#ITACTD",,"125")), i)
					EndIf
					//

					If !Empty(cPrj)
						
						// Projeto Investimento
						cCC     := gdFieldGet("CP_CC", i)
						lPrjInv := Left(AllTrim(cCC),1) == "9"
						
						If lPrjInv .and. !Alltrim(cCC) $ GetMV("MV_#CCPADR")
							
							nTt     := gdFieldGet("CP_XPRJVLR", i)
							
							// Valor do projeto do item
							nTtPrj := nTt
							
							aAdd( aTtPrj, {	cPrj,;
							nTtPrj } )
							
						EndIf
					EndIf
				EndIf
			Next i
			
			// Consiste total projeto
			aSort( aTtPrj,,, { |x,y| x[1] < y[1] } )
			
			cColsPrj := ""
			nColsTot := 0
			
			For y:=1 to Len(aTtPrj)
				
				If y == 1 // primeira linha
					cColsPrj := aTtPrj[y,1]
					nColsTot := aTtPrj[y,2]
					
				Else
					// Se for o mesmo projeto
					If cColsPrj == aTtPrj[y,1]
						nColsTot += aTtPrj[y,2] // totalizo os valores
						
					// Consisto saldo x total dos itens
					Else
						
						AF8->( dbSetOrder(1) ) // AF8_FILIAL+AF8_PROJET
						If AF8->( dbSeek(xFilial("AF8")+cColsPrj) )
							
							// Consiste apenas projetos que possuem valor
							If AF8->AF8_XVALOR > 0
								
								// Consiste saldo informado no documento de entrada x saldo do projeto (AF8)
								nSldPrj := u_ADCOM017P(cColsPrj)
								
								If nColsTot > nSldPrj
									
									lRet := .f.
									
									Aviso(	"MTA105LIN-09",;
									"Saldo do projeto n. " + AllTrim(cColsPrj) + " insuficiente! Verifique..." + chr(13) + chr(10) +  chr(13) + chr(10)+;
									"[SA] Tt L�quido itens: " + Transform(nColsTot, PesqPict("SCP","CP_XPRJVLR")) + chr(13) + chr(10) +;
									"[PRJ] Saldo: " + Transform(nSldPrj, PesqPict("SCP","CP_XPRJVLR")),;
									{ "&Retorna" },,;
									"Projeto sem saldo" )
									
								Else
									// zero variaveis para proximo projeto
									cColsPrj := aTtPrj[y,1]
									nColsTot := aTtPrj[y,2]
									
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next y
			
			// Consisto o �ltimo projeto do acols - N�O RETIRAR !!!
			If lRet
				
				AF8->( dbSetOrder(1) ) // AF8_FILIAL+AF8_PROJET
				If AF8->( dbSeek(xFilial("AF8")+cColsPrj) )
					
					// Consistencia do projeto
					If lSldAtv
						
						// Consiste apenas projetos que possuem valor
						If AF8->AF8_XVALOR > 0
							
							// Consiste saldo informado no documento de entrada x saldo do projeto (AF8)
							nSldPrj := u_ADCOM017P(cColsPrj)
							
							If nColsTot > nSldPrj
								
								lRet := .f.
								
								Aviso(	"MTA105LIN-10",;
								"Saldo do projeto n. " + AllTrim(cColsPrj) + " insuficiente! Verifique..." + chr(13) + chr(10) +  chr(13) + chr(10)+;
								"[SA] Tt L�quido itens: " + Transform(nColsTot, PesqPict("SCP","CP_XPRJVLR")) + chr(13) + chr(10) +;
								"[PRJ] Saldo: " + Transform(nSldPrj, PesqPict("SCP","CP_XPRJVLR")),;
								{ "&Retorna" },,;
								"Projeto sem saldo" )
								
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
	EndIf
	
	// Chamado n. 047931 || OS 049195 || CONTROLADORIA || ANDRESSA || 45968437 || C.CUSTO X LOTE -RNX2 - FWNM - 20/03/2019
	If lRet
		lRet := ChkZCN()
	EndIf
	// 
	
	// *** INICIO WILLIAM COSTA 26/08/2019 CHAMADO 050722 || OS 052025 || MANUTENCAO || DEBORA || 8935 || DEBORA MANUTENCAO *** // 
	
	IF lRet == .T. .AND. Alltrim(FunName())== "MATA105" // Tiago Sttoco - 13/05/2020 - Trtamento para validar somente na inclusao da s.a
	
		// *** INICIO Chamado 059784 - Abel Babini 	- 21/07/2020 - Retirar obrigatoriedade do campo CP_XCODBEM, e acrescentada Obrigatoriedade do campo CP_OP
		// *** INICIO Chamado 8580 - Tiago Stocco - 26/02/21 - Adicionado a Empresa 02 Ceres para n�o zerar o campo OP e obrigar a OP quando for da manuten��o.
		IF (alltrim(cEmpAnt)+alltrim(cFilAnt) $ _cEmpFL1) .or. cEmpAnt == '02' //ticket TI - Antonio Domingos - 23/05/2023 
		
			IF ALLTRIM(aCols[n,nPosOP]) == ''

				IF ALLTRIM(aCols[n,nPosCC]) $ GetMV("MV_#CCSOAR",,'5304')
				
					IF ALLTRIM(aCols[n,_nPosGrp]) $ GetMV("MV_#GPSOAR",,'9023/9024/9052/9053')
					
						lRet := .T.
					
					ELSE
					
						Aviso("MTA105LIN-11",;
							"Obrigatorio Informar a Ordem de Produ��o, para o centro de custo 5304"+ chr(13) + chr(10) +  chr(13) + chr(10),;
							{ "&Retorna" },,;
							"Ordem de Produ��o sem informa��o" )
					
						lRet := .F.
					
					ENDIF
				ENDIF
			ENDIF

		ELSE

			aCols[n,nPosOP] := '' // Limpa o campo de Op enquanto n�o est� instalado em outras empresas

		ENDIF
	ENDIF
	
	// *** FINAL WILLIAM COSTA 26/08/2019 CHAMADO 050722 || OS 052025 || MANUTENCAO || DEBORA || 8935 || DEBORA MANUTENCAO *** //

	PutCTD() // @history ticket 85790 - 16/01/2023 - Fernando Macieira - OPERA��O NOVA MATRIZES - ITEM CONT�BIL	

	//Everson - 13/02/2023 - ticket 87842.
	lRet := lRet .And. U_ADMNT022P(gdFieldGet("CP_OP", n), "")

	// VERIFICA se item contabil � permitido na filial
	If lRet
		if  _nPosItem > 0 .And. !alltrim(cValToChar(aCols[n,_nPosItem])) $ _ItemCta //Everson - 30/01/2023 - ticket 87496.
			MsgAlert("Item Contabil " + alltrim(cValToChar(aCols[n,_nPosItem])) + " nao permitido nesta filial !") //Everson - 30/01/2023 - ticket 87496.
			lRet:= .F.
		endif
	EndIf

	//&&Chamado 006786 - Mauricio 14/05/10.
	// Valida caso seja digitado projeto se o centro de custo inicia por 9.Chamado
	If lRet
		if  !(Empty(aCols[n,_NPOSPROJ])) .AND. Substr(aCols[n,nPosCC],1,1) <> "9"
			MsgAlert("O centro de custo " + alltrim(aCols[n,nPosCC]) + " nao permite utilizar codigo de projeto.")
			lRet:= .F.
		endif
	EndIf
	
	//Valida a Conta Contabil - Everaldo Casaroli 11/11/2008 em substituicao ao AD0205.PRW
	dbSelectArea("SZ0")
	dbSetOrder(1)
	If !SZ0->(dbSeek( xFilial("SZ0") + aCols[n,nPosCC] + aCols[n,_nPosGrp]))
		Alert("Centro de Custo "+alltrim(aCols[n,nPosCC])+" x Grupo "+alltrim(aCols[n,_nPosGrp])+" Nao autorizado")
		lRet:= .F. 
	endif
	//Everaldo Casaroli 11/11/2008 - fim


	RestArea(_AreaSCP)
	RestArea(_aArea)

Return(lRet)

/*/{Protheus.doc} Static Function UPSB2
    Forma valor do projeto pelo custo medio
    @type  Static Function
    @author FWNM
    @since 03/02/2018  
/*/
Static Function UpSB2(cProd, cAlm, nQtd)

	Local nValor := 0
	
	SB2->( dbSetOrder(1) ) // B2_FILIAL+B2_COD+B2_LOCAL
	If SB2->( dbSeek(xFilial("SB2")+cProd+cAlm) )
		nValor := nQtd * SB2->B2_CM1
	EndIf

Return nValor

/*/{Protheus.doc} Static Function ChkZCN
    Consiste lote recria RNX2
    @type  Static Function
    @author FWNM
    @since 20/03/2019
/*/
Static Function ChkZCN()

	Local lRet     := .t.
	Local cEmpZCN  := GetMV("MV_#ZCNEMP",,"07")
	Local aAreaZCN := ZCN->( GetArea() )
	Local cLoteZCN := ""
	Local cCC      := ""

	// Empresas autorizadas
	If cEmpAnt $ cEmpZCN
	
		cCC      := gdFieldGet("CP_CC", n)
		cLoteZCN := gdFieldGet("CP_XLOTECC", n)

		// Lote Recria informado
		If !Empty(cLoteZCN)

			ZCN->( dbSetOrder(1) ) // ZCN_FILIAL+ZCN_LOTE                                                                                                                                             
			If ZCN->( dbSeek( FWxFilial("ZCN")+cLoteZCN ) )
			
				// Consisto lote encerrado
				If AllTrim(ZCN->ZCN_STATUS) == "E" 
					lRet := .f.
					Alert("[MTA105LIN-ZCN1] - Lote Recria com status Encerrado! Contate a contabilidade...")
				EndIf
				
				// Consisto CC informado
				If lRet
					If AllTrim(cCC) <> AllTrim(ZCN->ZCN_CENTRO)
					  lRet := .f.
					  Alert("[MTA105LIN-ZCN2] - Lote Recria n�o amarrado com o Centro de Custo informado! Contate a contabilidade...")
					EndIf
				EndIf
				
			Else
			
				// Lote informado nao cadastrado na ZCN
				lRet := .f.
				Alert("[MTA105LIN-ZCN3] - Lote Recria n�o cadastrado! Contate a contabilidade...")

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
						Alert("[MTA105LIN-ZCN4] - Centro de Custo informado possui Lote Recria amarrado! Informe o Lote Recria ou contate a contabilidade...")
					EndIf
		
				EndIf
	
			EndIf
		EndIf
		//
	
	EndIf
	
	RestArea( aAreaZCN )

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
	Local cCC      := AllTrim(gdFieldGet("CP_CC",n))
	Local cItemNEW := GetMV("MV_#ITMNEW",,"221")

	If FWCodEmp() == "01" .and. AllTrim(fwCodFil()) $ GetMV("MV_#GRANJS",,"0C|0D|0E|0F|0G|0H|0I|0J|0K|0L|0M|0N|0O|0P|0Q|0R|0S")
		gdFieldPut("CP_ITEMCTA", cItemCTD, n)
	EndIf

	//@history ticket 89178 - 28/02/2023 - Fernando Macieira - 
	// A regra na filial 03 �, usar item 114, 
	// com exce��o de 5131 e 5134 deve ser item 113 
	// e centros de custos iniciados com 7 deve ser item 111
	If AllTrim(FWCodEmp()) == "01" .and. AllTrim(FWCodFil()) == "03"
		
		cItemCTD := "114"

		If cCC $ "5131|5134"
			cItemCTD := "113"
		EndIf

		If Left(cCC,1) == "7"
			cItemCTD := "111"
		EndIf

		gdFieldPut("CP_ITEMCTA", cItemCTD, n)

	EndIf

	// @history ticket 77603 - Fernando Macieira - 04/08/2022 - Ceres - Solicita��o Almoxarifado - Requisi��es - Vincula��o item cont�bil 124
	If AllTrim(FWCodEmp()) == "02"
		gdFieldPut("CP_ITEMCTA", GetMV("MV_#CPIT02",,"124"), n)
	EndIf

	// @history ticket 94010 - 25/05/2023 - Fernando Macieira - EMPRESAS NOVAS (EMPRESAS 11, 12 E 13) - ITEM CONT�BIL 221
	If AllTrim(FWCodEmp()) == "11" .or. AllTrim(FWCodEmp()) == "12" .or. AllTrim(FWCodEmp()) == "13"
		gdFieldPut("CP_ITEMCTA", cItemNEW, n)
	EndIf
	// 
	
Return
