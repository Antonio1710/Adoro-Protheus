#Include "Totvs.ch"

/*/{Protheus.doc} User Function CEXMBTNFE
	Ponto entrada para incluir botão na Central XML  
	@type  Function
	@author Abel Babini Filho
	@since 11/02/2019
	@version version
	@history Chamado 045978 - Abel Babini Filho - 11/02/2019 - Botao que permita ao usuario marcar registros como recusados. Esta marcação terá efeito apenas no relatório de XML´s pendentes de escrituração / classificação fiscal.
	@history Chamado 058532 - Adriana Oliveira  - 15/06/2020 - Incluir botao para trocar XML de filial
	@history Chamado 058532 - Adriana Oliveira  - 18/06/2020 - Inclusao LOG ZBE ao trocar XML de filial
	@history Ticket  18465  - Everson           - 24/08/2022 - Incluída rotina para informar a placa do veículo.
	@history Ticket  86422  - Abel Babini       - 13/02/2022 - Criação de rotina para separação de itens na Central XML conforme Poder de Terceiros
	@history Ticket  86422  - Abel Babini       - 14/02/2022 - Atualização do fonte na produção
	@history Ticket  91591  - Rafael Moraes Rosa- 18/04/2023 - Criada uma validação para garantir que a emissão dos docs. poder de terceiro seja inferior ou igual a emissão do doc. de amarração
	/*/

User Function CEXMBTNFE()
	
	Local aRetorno	:= Array( 03 )
	
	//Chamado 058532 - Alterado por Adriana para incluir mais botoes em 15/06/2020
	aRetorno[1]	:= "ADORO"			//[01] - Descricao da Funcao (Sera exibida no menu lateral)
	aRetorno[2]	:= "TRMIMG32.PNG"	//[02] - Imagem (Precisa estar no repositorio)
	aRetorno[3]	:= "CEXNFEBT"	    //[03] - Funcao de Usuario (User Function)
	//Fim Chamado 058532- Alterado por Adriana em 15/06/2020

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'CENTRALXML- P.E para incluir botão na Central XML ')
	
Return aRetorno                

/*/{Protheus.doc} User Function CEXNFEBT
	Cria tela com os botões customizados na Central XML - Chamado 058532
	@type  Static Function
	@author Adriana Oliveira
	@since 15/06/2020
	/*/

User Function CEXNFEBT()      

	Local oBtnCan	:= Nil
	Local oBtn01	:= Nil //Recusa XML
	Local oBtn02	:= Nil //Tranfere XML Filial

	Private oDlgAdr	:= Nil

	DEFINE MSDIALOG oDlgAdr TITLE "Customizações Adoro" FROM 000, 000  TO 165, 310 COLORS 0, 16777215 PIXEL style 128
	oDlgAdr:lEscClose     := .T. //Permite sair ao pressionar ESC
	
	@ 010, 010 SAY OemToAnsi("Selecione a opção desejada:") SIZE 150, 025 OF oDlgAdr COLORS 0, 16777215 PIXEL
	oBtn01 := TButton():New( 018, 010, "Recusa XML",oDlgAdr,{||U_CERECUSA()}, 60,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBtn02 := TButton():New( 018, 080, "Transfere XML Filial",oDlgAdr,{||U_CEXTRFIL()}, 60,20,,,.F.,.T.,.F.,,.F.,,,.F. )
	oBtn03 := TButton():New( 043, 010, "Informar Placa",oDlgAdr,{||U_CEXTRPla()}, 60,20,,,.F.,.T.,.F.,,.F.,,,.F. ) //Ticket  18465 - Incluída rotina para informar a placa do veículo.
	oBtn04 := TButton():New( 043, 080, "Separa Itens Poder 3s.",oDlgAdr,{||U_CEXSpPT()}, 60,20,,,.F.,.T.,.F.,,.F.,,,.F. ) //Ticket  18465 - Incluída rotina para informar a placa do veículo.
	
	DEFINE SBUTTON oBtnCan 	FROM 068, 130 TYPE 02 OF oDlgAdr ENABLE Action( oDlgAdr:End() )

	ACTIVATE MSDIALOG oDlgAdr CENTERED

Return 

/*/{Protheus.doc} User Function CEXSpPT
	Separa os itens do XML baseado no Poder de Terceiros
	@type  Static Function
	@author Abel Babini
	@since 10/01/2023
	Ticket  86422  - Abel Babini       - 13/02/2022 - Criação de rotina para separação de itens na Central XML conforme Poder de Terceiros
	/*/
User Function CEXSpPT()
	Local _aArea	:= getArea()
	Local cQryPdT	:= GetNextAlias()
	Local cFornPT := GetMV("MV_#CXMLPT",,"03149501")
	// Local cFornXML := Alltrim(RtForXML())
	Local cCodPrdP := ''
	Local nPrcUnX := 0
	Local aSB6Rem := {}
	Local i := 0
	Local nQtdXML := 0
	Local cQryCXML := GetNextAlias()
	Local cAuxPrdX := ''
	Local nAxPrUnX := 0
	Local lLimpaPd := .F.
	// Local cQryUpdX := ''

	Local cITMsg	:= "" //Rafael Moraes Rosa - Ticket 91591
	Local cITMsgFim	:= "" //Rafael Moraes Rosa - Ticket 91591

	If MSGYESNO(" Confirma a separação dos itens da Nota? ")
		If MSGYESNO(" Deseja Limpar as informações do Pedido de Compra (Pedido e Item) ? ")
			lLimpaPd := .T.
		Endif

		BEGINSQL Alias cQryCXML
			SELECT 
				CAB.XML_CHAVE, CAB.XML_EMIT, CAB.XML_NUMNF, CAB.XML_CLIFOR, CAB.R_E_C_N_O_  AS XML_RECNO,
				CAB.XML_EMISSA, //Rafael Moraes Rosa - Ticket 91591
				XIT_ITEM, XIT_CODNFE, XIT_CODPRD, XIT_TPPROD, XIT_DESCRI, XIT_QTENFE, XIT_UMNFE, 
				XIT_PRCNFE, XIT_QTE, XIT_UM, XIT_PRUNIT, XIT_TOTAL, XIT_TOTNFE, XIT_TES, XIT_CF, 
				XIT_CFNFE, XIT_NCM, XIT_NCMPRD, XIT_PEDIDO, XIT_ITEMPC, XIT_VALDES, XIT_BASICM, 
				XIT_PICM, XIT_VALICM, XIT_BASIPI, XIT_PIPI, XIT_VALIPI, XIT_BASPIS, XIT_PPIS, 
				XIT_VALPIS, XIT_BASCOF, XIT_PCOF, XIT_VALCOF, XIT_BASRET, XIT_PMVA, XIT_VALRET, 
				XIT_CLASFI, XIT_NUMFCI, XIT_AGLDES, XIT_CC, XIT_CONTA, XIT_ITEMCT, XIT_LOCAL, 
				XIT_NFORI, XIT_SRORI, XIT_ITORI, XIT_LOTEC, XIT_LOTEN, XIT_DTLOT, XIT_IDENB6, 
				XIT_VFRETE, XIT_CSTXML, XIT_INFADP, XIT_OP, XIT_EANXML, XIT_QTECON, XIT_CESTXM, XIT_CESTPR, 
				XIT_VOUTRO, XIT_BASNDE, XIT_ALQNDE, XIT_ICMNDE, XIT_ALQCSN, XIT_ICMSSN, 
				XIT_CSTPIS, XIT_CSTCOF, XIT_LOTEF, XIT_ALFPST, XIT_BSFPST, XIT_CSTICM, XIT_CSTIPI, XIT.R_E_C_N_O_ AS XIT_RECNO, A2_COD, A2_LOJA
			FROM RECNFXMLITENS XIT
			INNER JOIN RECNFXML CAB ON
				CAB.XML_CHAVE = XIT.XIT_CHAVE AND
				CAB.%notDel%
			LEFT JOIN %TABLE:SA2% SA2 ON
				A2_CGC = CAB.XML_EMIT AND
				SA2.%notDel%
			WHERE 
				XIT_CHAVE = %Exp:RECNFXML->XML_CHAVE%
			AND XIT.%notDel%
			AND XIT_IDENB6 = ''
			AND CAB.XML_STATF1 = ''
			ORDER BY XIT_CODNFE
		ENDSQL
		//ATENÇÃO: A ORDEM DE PROCESSAMENTO DEVE SER O PRODUTO PARA POSSIBILITAR MANTER O HISTÓRICO DO ARRAY DE SALDO DE PODER DE TERCEIROS

		WHILE !(cQryCXML)->(eof())
			
			//Valida se o Fornecedor foi localizado no protheus
			// IF Empty(cFornXML)
			IF Empty(Alltrim((cQryCXML)->A2_COD))
				Aviso("Atenção", "Não foi localizado fornecedor ativo para o CNPJ do XML posicionado", {"OK"}, 3)
				EXIT
			ENDIF
		
			//Valida se o produto tem a Amarração Produto x Fornecedor
			cCodPrdP := Alltrim(RtPrdXML((cQryCXML)->A2_COD,(cQryCXML)->A2_LOJA,(cQryCXML)->XIT_CODNFE))
			nPrcUnX := (cQryCXML)->XIT_PRUNIT

			IF (cQryCXML)->XML_CLIFOR == 'F' .AND. (cQryCXML)->A2_COD+(cQryCXML)->A2_LOJA $ cFornPT
				//*****************************************************************************************************************
				//Verifica se o item atual não foi encontrado na amarração Produto Fornecedor ou se possui mais de uma amarração.
				//Nesses casos, pula o item
				IF Empty(Alltrim(cCodPrdP))
					(cQryCXML)->(dbSkip())
					Loop
				ENDIF
				//*****************************************************************************************************************
				//Verifica se o item atual já está com o Poder de Terceiros Preenchido. EM caso afirmativo, pula o item
				IF !Empty(Alltrim((cQryCXML)->XIT_IDENB6))
					(cQryCXML)->(dbSkip())
					Loop
				ENDIF

				//Verifica se o produto do XML é o mesmo ou mudou. 
				//Só Podemos fazer outra consulta na SB6 (Poder de Terceiros) se o produto for diferente
				IF Empty(Alltrim(cAuxPrdX)) .OR. Alltrim(cAuxPrdX) != cCodPrdP .OR. nAxPrUnX != nPrcUnX
				
					//*****************************************************************************************************************
					//INICIO Verifica se existe remessa disponível no Poder de Terceiros com Saldo para o Produto e preço do item atual. 
					BEGINSQL Alias cQryPdT
						SELECT
							B6_FILIAL,
							B6_CLIFOR,
							B6_LOJA,
							B6_PRODUTO,
							B6_LOCAL,
							B6_SEGUM,
							B6_DOC,
							B6_SERIE,
							B6_EMISSAO,
							B6_QUANT,
							B6_PRUNIT,
							B6_TES,
							B6_UENT,
							B6_CUSTO1,
							B6_DTDIGIT,
							B6_UM,
							B6_QTSEGUM,
							B6_IDENT,
							B6_TPCF,
							B6_SALDO,
							B6_PODER3,
							B6_TIPO,
							D2_ITEM
						FROM %TABLE:SB6% SB6
						LEFT JOIN %TABLE:SD2% SD2 ON
							SD2.D2_FILIAL = SB6.B6_FILIAL AND
							SD2.D2_DOC = SB6.B6_DOC AND
							SD2.D2_SERIE = SB6.B6_SERIE AND
							SD2.D2_IDENTB6 = SB6.B6_IDENT AND
							SD2.%notDel%
						WHERE 
							B6_FILIAL = %Exp:cFilAnt% AND
							B6_CLIFOR = %Exp:(cQryCXML)->A2_COD% AND 
							B6_LOJA = %Exp:(cQryCXML)->A2_LOJA% AND 
							B6_PRODUTO = %Exp:cCodPrdP% AND
							B6_PRUNIT = %Exp:(cQryCXML)->XIT_PRCNFE% AND
							B6_SALDO > 0 AND  
							SB6.%notDel%
						ORDER BY B6_EMISSAO, B6_DOC
					ENDSQL
					//Reinicia a variável de Saldo de Poder de Terceiros
					aSB6Rem := {}
					WHILE !(cQryPdT)->(eof())
						AADD(aSB6Rem,{;
							(cQryPdT)->B6_FILIAL,;
							(cQryPdT)->B6_CLIFOR,;
							(cQryPdT)->B6_LOJA,;
							(cQryPdT)->B6_PRODUTO,;
							(cQryPdT)->B6_LOCAL,;
							(cQryPdT)->B6_SEGUM,;
							(cQryPdT)->B6_DOC,;
							(cQryPdT)->B6_SERIE,;
							(cQryPdT)->B6_EMISSAO,;
							(cQryPdT)->B6_QUANT,;
							(cQryPdT)->B6_PRUNIT,;
							(cQryPdT)->B6_TES,;
							(cQryPdT)->B6_UENT,;
							(cQryPdT)->B6_CUSTO1,;
							(cQryPdT)->B6_DTDIGIT,;
							(cQryPdT)->B6_UM,;
							(cQryPdT)->B6_QTSEGUM,;
							(cQryPdT)->B6_IDENT,;
							(cQryPdT)->B6_TPCF,;
							(cQryPdT)->B6_SALDO,;
							(cQryPdT)->B6_PODER3,;
							(cQryPdT)->B6_TIPO,;
							(cQryPdT)->D2_ITEM})

						(cQryPdT)->(dbSkip())
					ENDDO
					(cQryPdT)->(dbCloseArea())

					//Se nâo existir remessa, cancelar a execução
					IF len(aSB6Rem) == 0
						(cQryCXML)->(dbSkip())
						Loop
						// Aviso("Atenção", "Não foram localizadas remessas (Poder Terc.) para o produto: "+cCodPrdP+". O processamento foi cancelado!" , {"CANCEL"}, 3)
						// Exit
					ENDIF
					//FIM Verifica se existe remessa disponível no Poder de Terceiros com Saldo para o Produto e preço do item atual. 
					//*****************************************************************************************************************
					cAuxPrdX := cCodPrdP
					nAxPrUnX := nPrcUnX
				ENDIF

				//*****************************************************************************************************************
				//INICIO Separação dos itens do XML pelo Poder de Terceiros 			
				nQtdXML := (cQryCXML)->XIT_QTENFE
				
				FOR i:=1 to len(aSB6Rem) //Rafael Moraes Rosa - Ticket 91591 - INICIO
							IF nQtdXML > 0
								IF (cQryCXML)->XML_EMISSA >= aSB6Rem[i,9]
									nQtdXML -= aSB6Rem[i,20]
								ELSE
									cITMsg		:= ALLTRIM(aSB6Rem[i,4]) + CHR(13)+CHR(10)
									cITMsgFim	:= cITMsgFim + cITMsg
									EXIT
								ENDIF
							ELSE
								EXIT
							ENDIF

				NEXT I //Rafael Moraes Rosa - Ticket 91591 - FIM

				IF Empty(cITMsg) //Rafael Moraes Rosa - Ticket 91591

					//INICIO Separação dos itens do XML pelo Poder de Terceiros 			
					nQtdXML := (cQryCXML)->XIT_QTENFE
					
					WHILE nQtdXML > 0
						//Se não houver remessas com saldo disponível, atualiza a quantidade e vai para o próximo item.
						IF len(aSB6Rem) == 0
							("RECNFXMLITENS")->(dbGoto((cQryCXML)->XIT_RECNO))
							RecLock("RECNFXMLITENS",.F.)
								("RECNFXMLITENS")->XIT_QTENFE := nQtdXML
								("RECNFXMLITENS")->XIT_QTE			:= nQtdXML //(cQryCXML)->XIT_QTE
								("RECNFXMLITENS")->XIT_TOTAL		:= Round(nQtdXML*(cQryCXML)->XIT_PRUNIT,2) //(cQryCXML)->XIT_TOTAL
								("RECNFXMLITENS")->XIT_TOTNFE	:= Round(nQtdXML*(cQryCXML)->XIT_PRUNIT,2) //(cQryCXML)->XIT_TOTNFE
								IF lLimpaPd
									("RECNFXMLITENS")->XIT_PEDIDO := ''
									("RECNFXMLITENS")->XIT_ITEMPC := ''
								ENDIF
							("RECNFXMLITENS")->(MSUNLOCK())
							EXIT
						ENDIF
						FOR i:=1 to len(aSB6Rem)
								//Se a Quantidade do Poder de Terceiros é Maior ou Igual a Qtd XML, 
								//1 - Diminuir a Quantidade do Poder de Terceiros
								//2 - Zerar a QtdXML		
								//3 - Atualizar item na Central XML (Identificador B6 e Quantidade)
								//Observação: A quantidade é atualizada para atender quando é necessário separar os itens.
								IF aSB6Rem[i,20] >= nQtdXML

									//Atualiza o Identificador de Poder de Terc no Item do XML 	
									("RECNFXMLITENS")->(dbGoto((cQryCXML)->XIT_RECNO))
									
									RecLock("RECNFXMLITENS",.F.)
										("RECNFXMLITENS")->XIT_IDENB6 := aSB6Rem[i,18]
										("RECNFXMLITENS")->XIT_LOCAL		:= aSB6Rem[i,5]
										("RECNFXMLITENS")->XIT_NFORI		:= aSB6Rem[i,7]
										("RECNFXMLITENS")->XIT_SRORI		:= aSB6Rem[i,8]
										("RECNFXMLITENS")->XIT_ITORI		:= aSB6Rem[i,23]

										("RECNFXMLITENS")->XIT_QTENFE := nQtdXML
										("RECNFXMLITENS")->XIT_QTE			:= nQtdXML //(cQryCXML)->XIT_QTE
										("RECNFXMLITENS")->XIT_TOTAL		:= Round(nQtdXML*(cQryCXML)->XIT_PRUNIT,2) //(cQryCXML)->XIT_TOTAL
										("RECNFXMLITENS")->XIT_TOTNFE	:= Round(nQtdXML*(cQryCXML)->XIT_PRUNIT,2) //(cQryCXML)->XIT_TOTNFE
										IF lLimpaPd
											("RECNFXMLITENS")->XIT_PEDIDO := ''
											("RECNFXMLITENS")->XIT_ITEMPC := ''
										ENDIF
									("RECNFXMLITENS")->(MSUNLOCK())

									aSB6Rem[i,20] -= nQtdXML
									nQtdXML := 0

									IF aSB6Rem[i,20] == 0
										ADEL(aSB6Rem,i)
										ASIZE(aSB6Rem,Len(aSB6Rem)-1)
									ENDIF
									EXIT

								//Se a Quantidade do Poder de Terceiros é menor que a Qtd XML,
								//1 - Zerar a Qtd do Poder de Terceiros
								//2 - Diminuir a Qtd XML
								//3 - Refazer o processo com o próximo item do Poder de Terceiros.
								//4 - Adiciona uma nova linha no XML
								ELSE
									//Adiciona uma nova linha para o XML
									cQryPxIt := GetNextAlias()
									BEGINSQL Alias cQryPxIt
										SELECT MAX(CAST(XIT_ITEM AS INTEGER))+1 AS PROXIMO
										FROM RECNFXMLITENS XIT
										WHERE 
											XIT.XIT_CHAVE = %Exp:(cQryCXML)->XML_CHAVE% AND
											XIT.%notDel%
									ENDSQL
									cNxIt = StrZero((cQryPxIt)->PROXIMO,4)
									(cQryPxIt)->(DBCLOSEAREA())	
									DbSelectArea("RECNFXMLITENS")
									RecLock("RECNFXMLITENS",.T.)
										("RECNFXMLITENS")->XIT_CHAVE		:= (cQryCXML)->XML_CHAVE
										("RECNFXMLITENS")->XIT_ITEM		:= cNxIt
										("RECNFXMLITENS")->XIT_CODNFE	:= (cQryCXML)->XIT_CODNFE
										("RECNFXMLITENS")->XIT_CODPRD	:= (cQryCXML)->XIT_CODPRD
										("RECNFXMLITENS")->XIT_TPPROD	:= (cQryCXML)->XIT_TPPROD
										("RECNFXMLITENS")->XIT_DESCRI	:= (cQryCXML)->XIT_DESCRI
										("RECNFXMLITENS")->XIT_QTENFE	:= aSB6Rem[i,20]
										("RECNFXMLITENS")->XIT_UMNFE		:= (cQryCXML)->XIT_UMNFE
										("RECNFXMLITENS")->XIT_PRCNFE	:= (cQryCXML)->XIT_PRCNFE
										("RECNFXMLITENS")->XIT_QTE			:= aSB6Rem[i,20] //(cQryCXML)->XIT_QTE
										("RECNFXMLITENS")->XIT_UM			:= (cQryCXML)->XIT_UM
										("RECNFXMLITENS")->XIT_PRUNIT	:= (cQryCXML)->XIT_PRUNIT
										("RECNFXMLITENS")->XIT_TOTAL		:= Round(aSB6Rem[i,20]*(cQryCXML)->XIT_PRUNIT,2) //(cQryCXML)->XIT_TOTAL
										("RECNFXMLITENS")->XIT_TOTNFE	:= Round(aSB6Rem[i,20]*(cQryCXML)->XIT_PRUNIT,2) //(cQryCXML)->XIT_TOTNFE
										("RECNFXMLITENS")->XIT_TES			:= Alltrim((cQryCXML)->XIT_TES)
										("RECNFXMLITENS")->XIT_CF			:= Alltrim((cQryCXML)->XIT_CF)
										("RECNFXMLITENS")->XIT_CFNFE		:= (cQryCXML)->XIT_CFNFE
										("RECNFXMLITENS")->XIT_NCM			:= (cQryCXML)->XIT_NCM
										("RECNFXMLITENS")->XIT_NCMPRD	:= (cQryCXML)->XIT_NCMPRD
										IF lLimpaPd
											("RECNFXMLITENS")->XIT_PEDIDO := ''
											("RECNFXMLITENS")->XIT_ITEMPC := ''
										ELSE
											("RECNFXMLITENS")->XIT_PEDIDO	:= (cQryCXML)->XIT_PEDIDO
											("RECNFXMLITENS")->XIT_ITEMPC	:= (cQryCXML)->XIT_ITEMPC
										ENDIF
										("RECNFXMLITENS")->XIT_VALDES	:= (cQryCXML)->XIT_VALDES
										("RECNFXMLITENS")->XIT_BASICM	:= (cQryCXML)->XIT_BASICM
										("RECNFXMLITENS")->XIT_PICM		:= (cQryCXML)->XIT_PICM
										("RECNFXMLITENS")->XIT_VALICM	:= (cQryCXML)->XIT_VALICM
										("RECNFXMLITENS")->XIT_BASIPI	:= (cQryCXML)->XIT_BASIPI
										("RECNFXMLITENS")->XIT_PIPI		:= (cQryCXML)->XIT_PIPI
										("RECNFXMLITENS")->XIT_VALIPI	:= (cQryCXML)->XIT_VALIPI
										("RECNFXMLITENS")->XIT_BASPIS	:= (cQryCXML)->XIT_BASPIS
										("RECNFXMLITENS")->XIT_PPIS		:= (cQryCXML)->XIT_PPIS
										("RECNFXMLITENS")->XIT_VALPIS	:= (cQryCXML)->XIT_VALPIS
										("RECNFXMLITENS")->XIT_BASCOF	:= (cQryCXML)->XIT_BASCOF
										("RECNFXMLITENS")->XIT_PCOF		:= (cQryCXML)->XIT_PCOF
										("RECNFXMLITENS")->XIT_VALCOF	:= (cQryCXML)->XIT_VALCOF
										("RECNFXMLITENS")->XIT_BASRET	:= (cQryCXML)->XIT_BASRET
										("RECNFXMLITENS")->XIT_PMVA		:= (cQryCXML)->XIT_PMVA
										("RECNFXMLITENS")->XIT_VALRET	:= (cQryCXML)->XIT_VALRET
										("RECNFXMLITENS")->XIT_CLASFI	:= Alltrim((cQryCXML)->XIT_CLASFI)
										("RECNFXMLITENS")->XIT_NUMFCI	:= Alltrim((cQryCXML)->XIT_NUMFCI)
										("RECNFXMLITENS")->XIT_AGLDES	:= Alltrim((cQryCXML)->XIT_AGLDES)
										("RECNFXMLITENS")->XIT_CC			:= Alltrim((cQryCXML)->XIT_CC)
										("RECNFXMLITENS")->XIT_CONTA		:= Alltrim((cQryCXML)->XIT_CONTA)
										("RECNFXMLITENS")->XIT_ITEMCT	:= Alltrim((cQryCXML)->XIT_ITEMCT)
										("RECNFXMLITENS")->XIT_LOTEC		:= Alltrim((cQryCXML)->XIT_LOTEC)
										("RECNFXMLITENS")->XIT_LOTEN		:= Alltrim((cQryCXML)->XIT_LOTEN)
										("RECNFXMLITENS")->XIT_DTLOT		:= STOD((cQryCXML)->XIT_DTLOT)
										("RECNFXMLITENS")->XIT_VFRETE	:= (cQryCXML)->XIT_VFRETE
										("RECNFXMLITENS")->XIT_CSTXML	:= (cQryCXML)->XIT_CSTXML
										("RECNFXMLITENS")->XIT_INFADP	:= Alltrim((cQryCXML)->XIT_INFADP)
										("RECNFXMLITENS")->XIT_OP			:= Alltrim((cQryCXML)->XIT_OP)
										("RECNFXMLITENS")->XIT_EANXML	:= Alltrim((cQryCXML)->XIT_EANXML)
										("RECNFXMLITENS")->XIT_QTECON	:= (cQryCXML)->XIT_QTECON
										("RECNFXMLITENS")->XIT_CESTXM	:= Alltrim((cQryCXML)->XIT_CESTXM)
										("RECNFXMLITENS")->XIT_CESTPR	:= Alltrim((cQryCXML)->XIT_CESTPR)
										("RECNFXMLITENS")->XIT_VOUTRO	:= (cQryCXML)->XIT_VOUTRO
										("RECNFXMLITENS")->XIT_BASNDE	:= (cQryCXML)->XIT_BASNDE
										("RECNFXMLITENS")->XIT_ALQNDE	:= (cQryCXML)->XIT_ALQNDE
										("RECNFXMLITENS")->XIT_ICMNDE	:= (cQryCXML)->XIT_ICMNDE
										("RECNFXMLITENS")->XIT_ALQCSN	:= (cQryCXML)->XIT_ALQCSN
										("RECNFXMLITENS")->XIT_ICMSSN	:= (cQryCXML)->XIT_ICMSSN
										("RECNFXMLITENS")->XIT_CSTPIS	:= Alltrim((cQryCXML)->XIT_CSTPIS)
										("RECNFXMLITENS")->XIT_CSTCOF	:= Alltrim((cQryCXML)->XIT_CSTCOF)
										("RECNFXMLITENS")->XIT_LOTEF		:= Alltrim((cQryCXML)->XIT_LOTEF)
										("RECNFXMLITENS")->XIT_ALFPST	:= (cQryCXML)->XIT_ALFPST
										("RECNFXMLITENS")->XIT_BSFPST	:= (cQryCXML)->XIT_BSFPST
										("RECNFXMLITENS")->XIT_CSTICM	:= Alltrim((cQryCXML)->XIT_CSTICM)
										("RECNFXMLITENS")->XIT_CSTIPI	:= Alltrim((cQryCXML)->XIT_CSTIPI)

										("RECNFXMLITENS")->XIT_IDENB6	:= Alltrim(aSB6Rem[i,18])
										("RECNFXMLITENS")->XIT_LOCAL		:= Alltrim(aSB6Rem[i,5])
										("RECNFXMLITENS")->XIT_NFORI		:= Alltrim(aSB6Rem[i,7])
										("RECNFXMLITENS")->XIT_SRORI		:= Alltrim(aSB6Rem[i,8])
										("RECNFXMLITENS")->XIT_ITORI		:= Alltrim(aSB6Rem[i,23])
										
									("RECNFXMLITENS")->(MSUNLOCK())

									nQtdXML -= aSB6Rem[i,20]
									aSB6Rem[i,20] := 0
									ADEL(aSB6Rem,i)
									ASIZE(aSB6Rem,Len(aSB6Rem)-1)
									EXIT
									// Aviso("TESTE", "PASSOU AQUI", {"OK"}, 3)
								ENDIF
						NEXT i
					ENDDO
					//FIM Separação dos itens do XML pelo Poder de Terceiros 
					//*****************************************************************************************************************
				
				ELSE //Rafael Moraes Rosa - Ticket 91591 - INICIO
					cITMsg	:= ""

				ENDIF//Rafael Moraes Rosa - Ticket 91591 - FIM
			ELSE
				Aviso("Atenção", "O XML selecionado não poder ser utilizado ou o Fornecedor não está no parâmetro MV_#CXMLPT", {"OK"}, 3)
				EXIT
			ENDIF

			(cQryCXML)->(dbSKip())
		ENDDO

		IF !Empty(cITMsgFim) //Rafael Moraes Rosa - Ticket 91591 - INICIO
			FWAlertWarning("Os produtos abaixo estao com a emissao de documentos para amarracao superior a emissao do documento primario:" + CHR(13)+CHR(10) + CHR(13)+CHR(10) + cITMsgFim, "Doc.Emissao Invalida")
		EndIf //Rafael Moraes Rosa - Ticket 91591 - FIM

		(cQryCXML)->(dbCloseArea())
		Aviso("Atenção", "Processo finalizado com sucesso", {"OK"}, 3)
	ELSE
		Aviso("Atenção", "Processo Cancelado pelo usuário", {"CANCEL"}, 3)
	ENDIF

	RestArea(_aArea)
Return nil

/*/{Protheus.doc} User Function RtForXML
	Retorna codigo Fornecedor Protheus relacionado ao XML
	@type  Static Function
	@author Abel Babini
	@since 25/02/2019
	/*/

Static Function RtForXML()
	Local cRet := ''
	Local cQryFor := GetNextAlias()

	BEGINSQL Alias cQryFor
		SELECT TOP 1
			A2_COD,
			A2_LOJA
		FROM %TABLE:SA2% SA2
		WHERE 
			A2_CGC = %Exp:RECNFXML->XML_EMIT%
			AND SA2.%notDel%
			AND SA2.A2_MSBLQL <> '1'
	ENDSQL

	cRet := (cQryFor)->A2_COD+(cQryFor)->A2_LOJA
	(cQryFor)->(dbCloseArea())
Return cRet

/*/{Protheus.doc} User Function RtPrdXML
	Retorna Produto Protheus vinculado ao Codigo do Fornecedor
	@type  Static Function
	@author Abel Babini
	@since 25/02/2019
	/*/

Static Function RtPrdXML(cCodForn,cLojForn,cPrdForn)
	Local cRet := ''
	Local cQryPrd := GetNextAlias()
	Local nNumPrd := 0

	BEGINSQL Alias cQryPrd
		SELECT
			A5_PRODUTO
		FROM %TABLE:SA5% SA5
		WHERE 
			A5_FILIAL = %Exp:cFilAnt% AND
			A5_FORNECE = %Exp:cCodForn% AND
			A5_LOJA = %Exp:cLojForn% AND
			A5_CODPRF = %Exp:cPrdForn% AND
			SA5.%notDel%
	ENDSQL
	
	cRet := aLLTRIM((cQryPrd)->A5_PRODUTO)
	nNumPrd := 0
	//Verifica se existe mais de um produto na amarração Produto x Fornecedor.
	//Se existir, não fará o vínculo de Poder de Terceiros
	WHILE ! (cQryPrd)->(eof())
		nNumPrd += 1
		(cQryPrd)->(dbSkip())
	ENDDO
	(cQryPrd)->(dbCloseArea())

	IF nNumPrd > 1
		cRet := ''
	ENDIF
Return cRet

/*/{Protheus.doc} User Function CERECUSA
	Recusa registro do XML selecionado / posicionado
	@type  Static Function
	@author Abel Babini
	@since 25/02/2019
	/*/

User Function CERECUSA()
	Local _aArea	:= getArea()
	Local cCodigo	:= ""
	Local cLoja		:= ""
	Local cMotivo	:= space(100)
	Local oMotivo
	Local cMsg1		:= "Digite o motivo pelo qual o XML selecionado está sendo recusado. Este bloqueio afeta APENAS"
	Local cMsg2		:= "o relatório de XML´s pendentes. (ADFIS027R.PRW) Utilize o relatório para listar os XML´s"
	Local cMsg3		:= "recusados."
	
	Private oDlg

	If Alltrim(RECNFXML->XML_KEYF1) == ""
	
		If RECNFXML->XML_CLIFOR = 'C' //nf cliente
			cCodigo := Posicione("SA1",3,xFilial("SA1")+RECNFXML->XML_EMIT,"A1_COD")
		    cLoja   := Posicione("SA1",3,xFilial("SA1")+RECNFXML->XML_EMIT,"A1_LOJA")
		Else					
			cCodigo := Posicione("SA2",3,xFilial("SA2")+RECNFXML->XML_EMIT,"A2_COD")
		    cLoja   := Posicione("SA2",3,xFilial("SA2")+RECNFXML->XML_EMIT,"A2_LOJA")
		EndIf
		
		dbSelectArea('ZCW')
		dbSetOrder(2)
		If ! ZCW->(dbSeek(xFilial('ZCW')+RECNFXML->XML_CHAVE))
				
			DEFINE MSDIALOG oDlg from 000,000 to 200,600 title "Motivo de Recusa do XML" pixel
			@ 005,005 Say OemToAnsi("Motivo: ") PIXEL COLORS CLR_HBLUE OF oDlg 
			@ 005,050 MsGet oMotivo VAR cMotivo SIZE 200,08  PIXEL OF oDlg Valid !empty(Alltrim(cMotivo))
			@ 030,150 BUTTON "Cancela"  OF oDlg SIZE 030,015 PIXEL ACTION DlgOk(.f.)
			@ 030,200 BUTTON "Confirma" OF oDlg SIZE 030,015 PIXEL ACTION DlgOk(.t.,cMotivo,cCodigo,cLoja)
	
			@ 065,005 Say OemToAnsi(cMsg1) PIXEL COLORS CLR_HRED OF oDlg                                                  
			@ 075,005 Say OemToAnsi(cMsg2) PIXEL COLORS CLR_HRED OF oDlg                                                  
			@ 085,005 Say OemToAnsi(cMsg3) PIXEL COLORS CLR_HRED OF oDlg                                                  
			
			ACTIVATE MSDIALOG oDlg CENTER
		Else
			IF MessageBox('XML já recusado. Deseja remover a recusa?','Exclusão Recusa XML',1)=1
				dbSelectArea('ZCW')
				dbSetOrder(2)
				If ZCW->(dbSeek(xFilial('ZCW')+RECNFXML->XML_CHAVE))
					RecLock("ZCW",.F.)
					ZCW->(dbDelete())
					ZCW->(MsUnlock())
					u_GrLogZBE (Date(),;
								TIME(),;
								cUserName,;
								"EXCLUSAO RECUSA DE XML","FISCAL","CEXMBTNFE",;
			                    "NF: "+substr(RECNFXML->XML_NUMNF,4,9)+" Serie: " +substr(RECNFXML->XML_NUMNF,1,3)+ " User: " +__cUserId,;
			                    ComputerName(),;
			                    LogUserName())		
				Endif			
			Else
				Alert("XML já recusado. Não é possível continuar.")
			Endif
			
		Endif
	Else
		Alert("Nota Fiscal já classificada. Impossível bloquear!")
	Endif
	ZCW->(dbCloseArea())
	RestArea(_aArea)
Return Nil

/*/{Protheus.doc} Static Function DlgOk
	Grava informações de recusa do XML na tabela ZCW
	@type  Static Function
	@author Abel Babini
	@since 25/02/2019
	/*/
	
static function DlgOk(lPar,cMotivo,cCodigo,cLoja)

	If lPar
		Reclock("ZCW",.T.)
		ZCW->ZCW_FILIAL	:= xFilial('ZCW')	
		ZCW->ZCW_DATA	:= dDatabase
		ZCW->ZCW_NFISCA	:= substr(RECNFXML->XML_NUMNF,4,9)
		ZCW->ZCW_SERIE	:= substr(RECNFXML->XML_NUMNF,1,3)
		ZCW->ZCW_CLIFOR	:= cCodigo
		ZCW->ZCW_LOJA	:= cLoja
		ZCW->ZCW_CHVNFE	:= RECNFXML->XML_CHAVE
		ZCW->ZCW_OBSERV	:= Alltrim(cMotivo)
		ZCW->(MsUnlock())
		
		u_GrLogZBE (Date(),;
					TIME(),;
					cUserName,;
					"INCLUSAO RECUSA DE XML","FISCAL","CEXMBTNFE",;
                    "NF: "+substr(RECNFXML->XML_NUMNF,4,9)+" Serie: " +substr(RECNFXML->XML_NUMNF,1,3)+" Motivo: "+ Alltrim(cMotivo) +" User: " +__cUserId,;
                    ComputerName(),;
                    LogUserName())		
	Else
		Alert('Operação Cancelada')
	Endif
oDlg:end()
Return

/*/{Protheus.doc} CEXTRFIL
	Troca destinatario do XML, para possibilitar gerar a NF na filial de entrega - Chamado 058532
	@type  Static Function
	@author Adriana Oliveira
	@since 15/06/2020
	/*/

User Function CEXTRFIL()
	
	If !Empty( RECNFXML->XML_KEYF1 )  
		Alert( "Nota Fiscal já classificada, impossível transferir XML!" )
	elseif !Alltrim(__CUSERID) $ GetMV("MV_#USUCTF")
		Alert( "Usuário sem permissão para transferir XML! Solicite autorização ao departamento Fiscal." )
	Else
		//Chamado 058532 - Alterado por Adriana para gerar log de alteracao em 18/06/2020
		u_GrLogZBE (Date(),;
			TIME(),;
			cUserName,;
			"TRANSFERENCIA XML DE FILIAL","FISCAL","CEXMBTNFE",;
			"NF: "+substr(RECNFXML->XML_NUMNF,4,9)+" Serie: " +substr(RECNFXML->XML_NUMNF,1,3)+ " User: " +__cUserId,;
			ComputerName(),;
			LogUserName())		
		U_CEXMTRDE()
	EndIf
	
Return Nil
/*/{Protheus.doc} User Function nomeFunction
	(long_description)
	@type  Function
	@author Everson
	@since 24/08/2022
	@version 01
/*/
User Function CEXTRPla()

	//Variáveis.
	Local aArea  := GetArea()
	Local cChave := RECNFXML->XML_CHAVE

	DbSelectArea("SF1")
	SF1->(DbSetOrder(8))
	If ! SF1->( DbSeek( FwxFilial("SF1") + cChave ) )
		MsgInfo("Chave " + cChave + " não localizada.", "Função CEXTRPla(CEXMBTNFE)")
		RestArea(aArea)
		Return Nil

	EndIf

	If ! Empty(SF1->F1_STATUS)
		MsgInfo("Nota fiscal já está classificada.", "Função CEXTRPla(CEXMBTNFE)")
		RestArea(aArea)
		Return Nil

	EndIf

	If ! Pergunte("CEXMBTNFE1", .T.)
		RestArea(aArea)
		Return Nil

	EndIf

	If Empty(MV_PAR01)
		RestArea(aArea)
		Return Nil

	EndIf

	RecLock("SF1", .F.)
		SF1->F1_PLACA := MV_PAR01
	MsUnlock()

	MsgInfo("Placa atribuída à nota fiscal.", "Função CEXTRPla(CEXMBTNFE)")

	RestArea(aArea)

Return Nil
