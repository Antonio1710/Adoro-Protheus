#INCLUDE "RWMAKE.CH"
#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function MT116OK
	Ponto de Entrada - Confirma a exclusão da Nota de Conhecimento de Frete- CTE
	@type User Function
	@author Fernando Sigoli
	@since 30/09/2017
	@history Chamado 034249 - Fernando Sigoli - 30/09/2017 - Confirma a Exclusão da Nota de Conhecimento de Frete - CTE
	@history Chamado 059025 - Abel Babini     - 30/06/2020 - Valida se a Emissão da NF está  dentro do parâmetro MV_#DTEMIS
	@history Chamado 3886   - Everson  - 23/10/2020 - Declaração de variável devido a error log.
	@history Chamado 62250  - Leonardo P. Monteiro  - 23/11/2020 - Gravação da data de entrega da Nfe.
	@history Everson, 23/11/2022, ticket 18465 - Tratamento para validação com a rotina de entrada de matéria-prima.
	@history Everson, 02/01/2023, ticket 18465 - Envio de exclusão para o barramento.
	@history Everson, 13/01/2023, ticket 18465 - Atualiza o status do registro na entrada de matéria-prima.
/*/
User Function MT116OK()
	Local aArea		:= GetArea()
	Local ExpL1 	:= PARAMIXB[1]
	Local ExpL2 	:= .T.// Validações do usuário 
	Local cPedido 	:= ""
	Local cItemPC	:= ""
	Local cCodFor   := "" 	
	Local cLojFor   := ""	
	Local cNum      := "" 	
	Local cSerie    := ""

	Local dDtLEmis := GetMV('MV_#DTEMIS') //Everson - 23/10/2020. Chamado 3886.

	If ExpL1 //exclusao
	
		//INICIO Chamado 059025 - Abel    - 30/06/2020 - Valida se a Emissão da NF está  dentro do parâmetro MV_#DTEMIS
		IF SF1->F1_EMISSAO <= dDtLEmis .AND. ALLTRIM(SF1->F1_STATUS) <> '' //Apenas para Documentos já classificados.
			MsgStop("Nota fiscal não pode ser excluída, pois a data de emissão está bloqueada, Consulte o Depto. Fiscal (MV_#DTEMIS).","Função A100DEL-1")
			ExpL2 := .F.
		ENDIF
		//FIM Chamado 059025 - Abel    - 30/06/2020 - Valida se a Emissão da NF está  dentro do parâmetro MV_#DTEMIS

		IF ExpL2
			Dbselectarea("SD1")
			Dbsetorder(1)	
			If SD1->(dbseek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA,.T. ))	
				While !Eof() .and. xFilial("SD1")+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA == SD1->D1_FILIAL+SD1->D1_DOC+SD1->D1_SERIE+SD1->D1_FORNECE+SD1->D1_LOJA

					//Everson - 23/11/2022 - ticket 18465.
					cPedido := Alltrim(SD1->D1_PEDIDO)	
					cItemPC := SD1->D1_ITEMPC	
					cCodFor := SD1->D1_FORNECE
					cLojFor := SD1->D1_LOJA	
					cNum    := SD1->D1_DOC	
					cSerie  := SD1->D1_SERIE
					//

					Exit						                        
				
					DbSelectArea("SD1")
					SD1->(dbSkip())			
				EndDo
			
			EndIf


			
			//Everson - 23/11/2022 - ticket 18465.
			//If ! Empty(cPedido)
				ExpL2 := U_MT116O1(cPedido, cItemPC, cCodFor, cLojFor, cNum, cSerie)

			//EndIf
			//

			//Everson - 03/01/2023 - ticket 18465.
			If ExpL2
				grvBarr(5, cNum+cSerie+cCodFor+cLojFor)

			EndIf
			//

		ENDIF


	EndIf

	RestArea(aArea)

Return ExpL2
/*/{Protheus.doc} atlSC7
	Atualiza pedido de compra.
	Ticket 18465.
	@type   Function
	@author Everson
	@since 23/11/2022
	@version 01
/*/
User Function MT116O1(cPedido, cItemPC, cCodFor, cLojFor, cNum, cSerie)

	//Variáveis.
	Local aArea 	:= GetArea()
	Local cFiliais  := Alltrim(GetMv("MV_#FAT171",,""))
	Local nRet		:= 0

	//CT-e vinculado à rotina de entrada de matéria-prima.
	If (cFilAnt $cFiliais) 

		If  U_ADFAT639(cNum, cSerie, cCodFor, cLojFor, 6)
	
			cPedido :=  ZIN->ZIN_PEDCTE

			nRet := U_MT116T2(cPedido, "0001", cCodFor, cLojFor, cNum, cSerie, "E")
		
			If nRet == 1 //Erro.
				RestArea(aArea)
				Return .F. 

			EndIf

			If nRet == 2 //Processado.

				//Everson - 13/01/2023 - Ticket 18465.
				U_ADFAT63O(cNum, cSerie, cCodFor, cLojFor, "CTE", "6")

				RestArea(aArea)
				Return .T.

			EndIf

		EndIf

	EndIf
	//

	Begin Transaction

		DbSelectArea("SC7")
		SC7->(dbgotop())
		SC7->(dbSetOrder(1)) 
		If SC7->( DbSeek(xFilial("SC7") + cPedido ) )

			While SC7->(!EOF()) .and. SC7->C7_FILIAL == xFilial("SC7") .and. SC7->C7_NUM == cPedido

				RecLock("SC7",.F.)
					SC7->C7_QUJE 	:= 0
					//@history Chamado 62250  - Leonardo P. Monteiro  - 23/11/2020 - Gravação da data de entrega da Nfe.
					SC7->C7_XDTENTR := Stod("")
				MsunLock()
				
				SC7->(DbSkip())	

			End
			
		EndIf  
	
	End Transaction

	RestArea(aArea)

Return .T.
/*/{Protheus.doc} grvBarr
    Salva o registro para enviar ao barramento.
    @type  User Function
    @author Everson
    @since 02/01/2022
    @version 01
/*/
Static Function grvBarr(nOpc, cNumero)

    //Variáveis.
    Local aArea     := GetArea()
    Local cFilter   := ""
    Local cTopico   := "documentos_de_entrada_protheus"
    Local cOperacao := ""
    Local cFiliais  := Alltrim(GetMv("MV_#FAT171",,"")) //Ticket 18465   - Everson - 21/07/2022.

    If !(cFilAnt $cFiliais)
        RestArea(aArea)
        Return Nil

    EndIf

    If nOpc == 4 
        cOperacao := "A"

    ElseIf nOpc == 3 
        cOperacao := "I"
    
    ElseIf nOpc == 5
        cOperacao := "D"

    Else
        RestArea(aArea)
        Return Nil

    EndIf
    
    cFilter := " D1_FILIAL ='" + FWxFilial("SD1") + "' .And. D1_DOC = '" + SF1->F1_DOC + "' .And. D1_SERIE = '" + SF1->F1_SERIE + "' .And. D1_FORNECE = '" + SF1->F1_FORNECE + "' .And. D1_LOJA = '" + SF1->F1_LOJA  + "' "
    
    U_ADFAT27D("SF1", 1, FWxFilial("SF1") + cNumero,;
               "SD1", 1, FWxFilial("SD1") + cNumero, "D1_COD+D1_ITEM",cFilter,;
               cTopico, cOperacao,;
               .T., .T.,.T., Nil)

    RestArea(aArea)

Return Nil
