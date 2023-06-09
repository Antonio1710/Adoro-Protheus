#include 'rwmake.ch'

/*{Protheus.doc} User Function MTA410
	PE para atualizar os Pesos do pedido, conforme padroes da Adoro
	@type  Function
	@author WELLINGTON SANTOS
	@since 17/01/2007
	@version 01
	@history Chamado 052170 - Adriana       - 04/10/2019 - NF EXPORTACAO SAFEGG 
	@history Chamado 056368 - William Costa - 06/03/2020 - Colocado GetArea e Adicioando DBSELECTAREA para as tabelas SA1,SA2,SA4 estavamos com erro na c�pia de pedido que n�o estava posicionado nessas tabelas corretamente.
	@history Ticket  TI    - Leonardo P. Monteiro - 26/02/2022 - Inclus�o de conouts no fonte. 
	@hsitory Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	@history ticket TI - Antonio Domingos - 22/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 25/05/2023 - Revis�o Ajuste Nova Empresa 1634
	@history ticket TI - Antonio Domingos - 02/06/2023 - Valida��o Ajuste Nova Empresa
*/

User Function MTA410

	Local _lRet     := .T.  
	Local cVend     := ''
	Local nProd     := ''
	Local cGrupProd := ''
	Local aArea     := GetArea()
	Local aAreaSA1  := SA1->(GetArea())
	Local aAreaSA2  := SA2->(GetArea())
	Local aAreaSA4  := SA4->(GetArea())
	Local i			:= 1
	Local _i		:= 1
	Local nTotLin	:= Len(aCols)
	//Local cFilRN:= GetMv("MV_#RNFIL",,"02|06|07|0B") //Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI

	Private _lEECFat	:= GetMv("MV_EECFAT") //por Adriana em 04/10/2019-chamado 052170
	Private lSfInt	:= (IsInCallStack('U_RESTEXECUTE') .OR. IsInCallStack('RESTEXECUTE'))
	Private _cEmpFL6 := SuperGetMv("MV_#EMPFL6",.F.,"0102|0106|0107|010B|1301") //Codigos de Empresas+Filiais Ativas Grupo 6//ticket TI - Antonio Domingos - 22/05/2023

	Public _lVldRot := Space(03)
	//Conout( DToC(Date()) + " " + Time() + " MTA410 >>> INICIO PE" )

	// Posicao no array aHEADER
	_nPValor  := aScan( aHeader, {|x| x[2] = "C6_VALOR" } )
	_nPCaixas := aScan( aHeader, {|x| x[2] = "C6_UNSVEN"} )
	_nPKilos  := aScan( aHeader, {|x| x[2] = "C6_QTDVEN"} )
	_nPSegUM  := aScan( aHeader, {|x| x[2] = "C6_SEGUM" } )
	_nPTES    := aScan( aHeader, {|x| x[2] = "C6_TES" } )
	_nPCLAS   := aScan( aHeader, {|x| x[2] = "C6_CLASFIS" } )
	_nPItem   := aScan( aHeader, {|x| x[2] = "C6_ITEM" } )
	nProd     := aScan( aHeader, {|x| x[2] = "C6_PRODUTO" } )

	_nTotalPed := 0
	_nTotalCx  := 0
	_nTotalKg  := 0
	_nTotalBr  := 0
	
	//verifica se placa e uf do veiculo est�o preenchidos - SPED
	//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	//if ! Empty(Alltrim(cValToChar(M->C5_PLACA))) .and.  Empty(Alltrim(cValToChar(M->C5_UFPLACA))) .and. Alltrim(xFilial("SC5")) $ cFilRN .and. ALLTRIM(CEMPANT)$_cEmpAt1 //incluida filial 07 em 13/08/14 
	//ticket TI - Antonio Domingos - 22/05/2023 
	if ! Empty(Alltrim(cValToChar(M->C5_PLACA))) .and.  Empty(Alltrim(cValToChar(M->C5_UFPLACA))) .and. ALLTRIM(CEMPANT)+Alltrim(xFilial("SC5")) $ _cEmpFL6
		IF IsInCallStack('U_ADVEN002P')  == .T.
			Aadd(aPedidos,{cchave, ;
			''    , ;
			''    , ;
			''    , ;
			'Ve�culo com cadastro incompleto! Preencha o Estado (UF) da Placa do Ve�culo!' , ;
			cVendedor}) 

		ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
			Aadd(aPedidos,{'Ve�culo com cadastro incompleto! Preencha o Estado (UF) da Placa do Ve�culo!'})

		ELSE

			Alert("Ve�culo com cadastro incompleto! Preencha o Estado (UF) da Placa do Ve�culo!")

		ENDIF

		_lRet := .F.
	elseIf !CliFor_OK()
		_lRet := .F.
	elseIf !Empty(M->C5_TRANSP)
		_lRet := Transp_OK()
	else

		For i:=1 To nTotLin

			if !acols[i][len(aheader)+1] //verifica se esta deletado
				_nTotalCx   := _nTotalCx   + aCols[i][_nPCaixas] // Soma qtd caixas (2a. UM)
				//			_nTotalKg   := _nTotalKg   + aCols[i][_nPKilos]  // Soma qtd peso   <1a. UM)
				_nTotalKg   := _nTotalKg   + iif(aCols[i][_nPSegUM]="BS",0,aCols[i][_nPKilos])  // Soma qtd peso   <1a. UM)     //alterado por Adriana, se bolsa nao soma 1a unidade como peso

				dbSelectAreA('SZC')
				dbSetOrder(1)
				dbSeek( xFilial('SZC') + aCols[i][_nPSegUM] )
				If Found()
					_nTotalBr   := _nTotalBr + (aCols[i][_nPCaixas] * SZC->ZC_TARA) // PESO BRUTO
				Else
					If Alltrim(aCols[i][_nPSegUM]) <> ""                             //Incluido 12/07/11 - Ana. Tratamento para peso duplicado
						_nTotalBr   := _nTotalBr + (aCols[i][_nPCaixas] * 1)         // PESO BRUTO
					Else
						_nTotalBr   := _nTotalBr                                     // PESO BRUTO				
					Endif	
				EndIf
			endif
		Next

		If M->C5_EST = "EX" .and. !_lEECFat //por Adriana em 04/10/2019-chamado 052170 (Valida Transportadora, se exporta��o e m�dulo SIGAEEC desabilitado) 

			If Empty(M->C5_TRANSP)
				Alert("Para pedidos de Exporta��o, sem utiliza��o do SIGAEEC, � obrigat�rio informar Transportadora!")
				_lRet := .F.  
			Endif

		Else //por Adriana em 04/10/2019-chamado 052170(Mantem peso digitado, se exporta��o e m�dulo SIGAEEC desabilitado)
		
			//Mauricio 26/04/10 - incluido tratamento para peso duplicado fiiais 03/04/05.
			If cEmpAnt == "02"
				M->C5_PBRUTO  := _nTotalKg
			Else
				M->C5_PBRUTO  := _nTotalBr + _nTotalKg
			Endif	
			M->C5_PESOL   := _nTotalKg
			M->C5_VOLUME1 := _nTotalCx
		
		Endif
		//fim chamado 052170 

	Endif
	//Tratamento para validar TES utilizada e Classificacao Fiscal - Mauricio Chamado 008687 - Inicio
	For _i:=1 To nTotLin

		if !acols[_i][len(aheader)+1] //verifica se esta deletado
			_cTES  := aCols[_i][_nPTES] 
			_cClas := aCols[_i][_nPCLAS]

			dbSelectAreA("SF4")
			dbSetOrder(1)
			dbSeek( xFilial("SF4") + aCols[_i][_nPTES] )
			IF found()
				if substr(aCols[_i][_nPCLAS],2,2) <> SF4->F4_SITTRIB
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'A Situacao tributaria do item '+aCols[_i][_nPITEM]+' deste pedido esta diferente da classificacao cadastrada na TES.Tecle enter no campo TES para atualizar!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'A Situacao tributaria do item '+aCols[_i][_nPITEM]+' deste pedido esta diferente da classificacao cadastrada na TES.'})

					ELSE
						MsgInfo("A Situacao tributaria do item "+aCols[_i][_nPITEM]+" deste pedido esta diferente da classificacao cadastrada na TES."+chr(13)+chr(13)+"Tecle enter no campo TES para atualizar!","Alerta")
					ENDIF

					_lRet := .F.
				Endif   
			Endif   			   
		endif
	Next

	// ** INICIO CHAMADO 031176 - LOGISTICA ADICIONAR PEDIDO DE VENDA DE UNIFORME - WILLIAM COSTA ** //

	If !lSfInt

		cVend := Posicione("SA1",1,xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI,"A1_VEND")

		FOR _i:=1 TO LEN(aCols)

			IF !acols[_i][LEN(aheader)+1] //verifica se esta deletado

				cGrupProd := Posicione("SB1",1,xFilial("SB1")+aCols[_i][nProd],"B1_GRUPO")

				IF __cUserID $ GETMV("MV_#USULPE")

					IF ALLTRIM(cVend)      <> '000442'  .AND. ;
					(ALLTRIM(cGrupProd) <> '9023'    .OR. ;
					ALLTRIM(cGrupProd)  <> '9024')

						MSGSTOP('Ol� ' + ALLTRIM(cUserName) + ', n�o � possivel efetivar o pedido!!!' + CHR(13) + CHR(10) + ;
						'Informe um Cliente Transportador ou um produto que esteja no grupo 9023 ou 9024, obrigado.', 'Pedido n�o efetivado' )				
						_lRet := .F.             	
						EXIT

					ELSE

						_lRet := .T.             	

					ENDIF
				ENDIF
			ENDIF
		NEXT

	EndIf

	// ** FINAL CHAMADO 031176 - LOGISTICA ADICIONAR PEDIDO DE VENDA DE UNIFORME - WILLIAM COSTA ** //

	RestArea(aArea)
	RestArea(aAreaSA2)
	RestArea(aAreaSA4)
	RestArea(aAreaSA1)

	//Conout( DToC(Date()) + " " + Time() + " MTA410 >>> FINAL PE" )

Return(_lRet)

// Valida dados do cadastro de clientes e fornecedores para NF-e
Static Function CliFor_OK()

	Local _lRet:=.T.
	//Local cFilRN:= GetMv("MV_#RNFIL",,"02|06|07|0B")//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	Local _cEmpFL6 := SuperGetMv("MV_#EMPFL6",.F.,"0102|0106|0107|010B|1301") //Codigos de Empresas+Filiais Ativas Grupo 6//ticket TI - Antonio Domingos - 02/06/2023

	//IF (Alltrim(xFilial("SC5")) $ cFilRN) .and. ALLTRIM(CEMPANT)=="01" //ALTERADO LEONARDO (HC) PARA CONTEMPLAR FILIAL 06 - ITUPEVA //incluida filial 07 em 13/08/14
	If Alltrim(cEmpAnt)+Alltrim(xFilial("SC5")) $ _cEmpFL6  //ticket TI - Antonio Domingos - 22/05/2023 

		IF !lSfInt .And. M->C5_TIPO $ "DB"

			DBSELECTAREA("SA2")
			DBGOTOP()
			DBSETORDER(1)
			IF SA2->(dbSeek(xFilial("SA2")+M->C5_CLIENTE+M->C5_LOJACLI))

				If Empty(SA2->A2_BAIRRO) .and. SA2->A2_EST <> 'EX'
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Fornecedor com cadastro incompleto!!! Preencha o bairro!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Fornecedor com cadastro incompleto!!! Preencha o bairro!'})

					ELSE

						Alert("Fornecedor com cadastro incompleto!!! Preencha o bairro!")

					ENDIF

					_lRet := .F.
				Elseif Empty(SA2->A2_END) 
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Fornecedor com cadastro incompleto!!! Preencha o Endereco!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Fornecedor com cadastro incompleto!!! Preencha o Endereco!'})

					ELSE

						Alert("Fornecedor com cadastro incompleto!!! Preencha o Endereco!")

					ENDIF

					_lRet := .F.
				ElseIf Empty(SA2->A2_CEP) .and. SA2->A2_EST <> 'EX'
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Fornecedor com cadastro incompleto!!! Preencha o CEP!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Fornecedor com cadastro incompleto!!! Preencha o CEP!'})

					ELSE

						Alert("Fornecedor com cadastro incompleto!!! Preencha o CEP!")

					ENDIF

					_lRet := .F.
				ElseIf At(SA2->A2_CEP,"-") > 0
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Fornecedor com cadastro inconsistente!!! CEP com caracter - inv�lido!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Fornecedor com cadastro inconsistente!!! CEP com caracter - inv�lido!'})

					ELSE

						Alert("Fornecedor com cadastro inconsistente!!! CEP com caracter - inv�lido!")

					ENDIF

					_lRet := .F.
				ElseIf Len(Alltrim(SA2->A2_CEP)) <> 8  .and. SA2->A2_EST <> 'EX'
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Fornecedor com cadastro inconsistente!!! CEP inv�lido!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Fornecedor com cadastro inconsistente!!! CEP inv�lido!'})

					ELSE

						Alert("Fornecedor com cadastro inconsistente!!! CEP inv�lido!")

					ENDIF

					_lRet := .F.
				ElseIf Empty(SA2->A2_COD_MUN)
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Fornecedor com cadastro incompleto!!! Preencha o C�digo de Munic�pio!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Fornecedor com cadastro incompleto!!! Preencha o C�digo de Munic�pio!'})

					ELSE

						Alert("Fornecedor com cadastro incompleto!!! Preencha o C�digo de Munic�pio!")

					ENDIF

					_lRet := .F.
				ElseIf !CC2->(dbSeek(xFilial("CC2")+SA2->A2_EST+SA2->A2_COD_MUN))
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Fornecedor com inconsistente!!! C�digo de Munic�pio inv�lido!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Fornecedor com inconsistente!!! C�digo de Munic�pio inv�lido!'})

					ELSE

						Alert("Fornecedor com inconsistente!!! C�digo de Munic�pio inv�lido!")

					ENDIF

					_lRet := .F.
				ElseIf Len(Alltrim(Str(FisGetTel(SA2->A2_DDD+SA2->A2_TEL)[3]))) > 10
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Fornecedor com cadastro inconsistente!!! DDD+Telefone > 10 posi��es!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Fornecedor com cadastro inconsistente!!! DDD+Telefone > 10 posi��es!'})

					ELSE

						Alert("Fornecedor com cadastro inconsistente!!! DDD+Telefone > 10 posi��es!")

					ENDIF

					_lRet := .F.         
				ElseIf !IE(SA2->A2_INSCR,SA2->A2_EST,.F.) .and. SA2->A2_EST <> 'EX'
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Inscricao Estadual do Fornecedor Invalida!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Inscricao Estadual do Fornecedor Invalida!'})

					ELSE

						Alert("Inscricao Estadual do Fornecedor Invalida!")

					ENDIF

					_lRet := .F.         
				Endif
			ENDIF	
		ELSE

			DBSELECTAREA("SA1")
			DBGOTOP()
			DBSETORDER(1)
			IF SA1->(dbSeek(xFilial("SA1")+M->C5_CLIENTE+M->C5_LOJACLI))

				If Empty(SA1->A1_BAIRRO) .and. SA1->A1_EST <> 'EX'
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Cliente com cadastro incompleto!!! Preencha o bairro!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Cliente com cadastro incompleto!!! Preencha o bairro!'})

					ELSE

						Alert("Cliente com cadastro incompleto!!! Preencha o bairro!")

					ENDIF

					_lRet := .F.
				Elseif Empty(SA1->A1_END)
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Cliente com cadastro incompleto!!! Preencha o Endereco!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Cliente com cadastro incompleto!!! Preencha o Endereco!'})

					ELSE

						Alert("Cliente com cadastro incompleto!!! Preencha o Endereco!")

					ENDIF

					_lRet := .F.
				ElseIf Empty(SA1->A1_CEP) .and. SA1->A1_EST <> 'EX'
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Cliente com cadastro incompleto!!! Preencha o CEP!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Cliente com cadastro incompleto!!! Preencha o CEP!'})

					ELSE

						Alert("Cliente com cadastro incompleto!!! Preencha o CEP!")

					ENDIF

					_lRet := .F.
				ElseIf At(SA1->A1_CEP,"-") > 0
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Cliente com cadastro inconsistente!!! CEP com caracter - inv�lido!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Cliente com cadastro inconsistente!!! CEP com caracter - inv�lido!'})

					ELSE

						Alert("Cliente com cadastro inconsistente!!! CEP com caracter - inv�lido!")

					ENDIF
					_lRet := .F.
				ElseIf Len(Alltrim(SA1->A1_CEP)) <> 8 .and. SA1->A1_EST <> 'EX'
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Cliente com cadastro inconsistente!!! CEP inv�lido!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Cliente com cadastro inconsistente!!! CEP inv�lido!'})

					ELSE

						Alert("Cliente com cadastro inconsistente!!! CEP inv�lido!")

					ENDIF

					_lRet := .F.
				ElseIf Empty(SA1->A1_COD_MUN)
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Cliente com cadastro incompleto!!! Preencha o C�digo de Munic�pio!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Cliente com cadastro incompleto!!! Preencha o C�digo de Munic�pio!'})

					ELSE

						Alert("Cliente com cadastro incompleto!!! Preencha o C�digo de Munic�pio!")

					ENDIF

					_lRet := .F.
				ElseIf !CC2->(dbSeek(xFilial("CC2")+SA1->A1_EST+SA1->A1_COD_MUN))
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Cliente com inconsistente!!! C�digo de Munic�pio inv�lido!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Cliente com inconsistente!!! C�digo de Munic�pio inv�lido!'})

					ELSE

						Alert("Cliente com inconsistente!!! C�digo de Munic�pio inv�lido!")

					ENDIF

					_lRet := .F.
				ElseIf Len(Alltrim(Str(FisGetTel(SA1->A1_DDD+SA1->A1_TEL)[3]))) > 10
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Cliente com cadastro inconsistente!!! DDD+Telefone > 10 posi��es! ' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Cliente com cadastro inconsistente!!! DDD+Telefone > 10 posi��es! '})

					ELSE

						Alert("Cliente com cadastro inconsistente!!! DDD+Telefone > 10 posi��es! ")

					ENDIF

					_lRet := .F.
				ElseIf !IE(SA1->A1_INSCR,SA1->A1_EST,.F.) .and. SA1->A1_EST <> 'EX'
					IF IsInCallStack('U_ADVEN002P')  == .T.
						Aadd(aPedidos,{cchave, ;
						''    , ;
						''    , ;
						''    , ;
						'Inscricao Estadual do Cliente Invalida!' , ;
						cVendedor}) 

					ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
						Aadd(aPedidos,{'Inscricao Estadual do Cliente Invalida!'})

					ELSE

						Alert("Inscricao Estadual do Cliente Invalida!")

					ENDIF

					_lRet := .F.         
				Endif
			ENDIF	
		Endif
	Endif                  

Return _lRet

//Valida dados da transportadora
Static Function Transp_OK()

	Local _lRet:=.T.
	//Local cFilRN:= GetMv("MV_#RNFIL",,"02|06|07|0B") //Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	Local _cEmpFL6 := SuperGetMv("MV_#EMPFL6",.F.,"0102|0106|0107|010B|1301") //Codigos de Empresas+Filiais Ativas Grupo 6//ticket TI - Antonio Domingos - 02/06/2023

	//if Alltrim(xFilial("SC5")) $ cFilRN .and. ALLTRIM(CEMPANT)=="01" //incluida filial 07 em 13/08/14
	If Alltrim(cEmpAnt)+Alltrim(xFilial("SC5")) $ _cEmpFL6  //ticket TI - Antonio Domingos - 22/05/2023 

		DBSELECTAREA("SA4")
		DBGOTOP()
		DBSETORDER(1)
		IF SA4->(dbSeek(xFilial("SA4")+M->C5_TRANSP))

			If Empty(SA4->A4_INSEST) .and. SA4->A4_EST <> 'EX'
				IF IsInCallStack('U_ADVEN002P')  == .T.
					Aadd(aPedidos,{cchave, ;
					''    , ;
					''    , ;
					''    , ;
					'Transportadora com cadastro incompleto!!! Preencha Inscricao Estadual!' , ;
					cVendedor}) 

				ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
					Aadd(aPedidos,{'Transportadora com cadastro incompleto!!! Preencha Inscricao Estadual!'})	

				ELSE

					Alert("Transportadora com cadastro incompleto!!! Preencha Inscricao Estadual!")

				ENDIF

				_lRet := .F.         
			ElseIf !IE(SA4->A4_INSEST,SA4->A4_EST,.F.) .and. SA4->A4_EST <> 'EX'
				IF IsInCallStack('U_ADVEN002P')  == .T.
					Aadd(aPedidos,{cchave, ;
					''    , ;
					''    , ;
					''    , ;
					'Transportadora com cadastro incosistente!!! Inscricao Estadual Inv�lida!' , ;
					cVendedor}) 

				ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
					Aadd(aPedidos,{'Transportadora com cadastro incosistente!!! Inscricao Estadual Inv�lida!'})

				ELSE

					Alert("Transportadora com cadastro incosistente!!! Inscricao Estadual Inv�lida!")

				ENDIF

				_lRet := .F.         
			Endif
		ENDIF	
	Endif

	//por Adriana em 04/10/2019-chamado 052170 (Valida Placa, se exporta��o e m�dulo SIGAEEC desabilitado) 
	If M->C5_EST = "EX" .and. !_lEECFat //por Adriana em 04/10/2019-chamado 052170 (Valida Placa, se exporta��o e m�dulo SIGAEEC desabilitado) 

		If Empty(M->C5_PLACA) .or. Empty(M->C5_UFPLACA)
			Alert("Para pedidos de Exporta��o, sem utiliza��o do SIGAEEC, � obrigat�rio informar Placa e Estado da Placa do Ve�culo!")
			_lRet := .F.  
		Else
			dbSelectArea( "ZV4" )
			dbSetOrder( 01 )
				
			If !(dbSeek( xFilial( "ZV4" ) + M->C5_PLACA )) 
				Alert("Veiculo/Placa n�o Cadastrada!!! Solicite o Cadastramento � Log�stica.")
				_lRet := .F.  
			Endif
		Endif
		
	Endif
	//fim chamado 052170 

Return _lRet
