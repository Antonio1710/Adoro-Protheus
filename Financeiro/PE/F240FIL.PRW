#include "rwmake.ch"        

/*/{Protheus.doc} User Function F240FIL
	Central Aprova��o
	@type  Function
	@author Ricardo Lima
	@since 14/11/2017
	@chamado 038609
	@history Chamado 052034 - FWNM         - 23/09/2019 - Retirar filtro de valor nos DOC/TED 
	@history Chamado 051382 - FWNM         - 29/11/2019 - Filtro Automatico Geracao Bordero
	@history Chamado 053347 - FWNM         - 29/11/2019 - 053347 || OS 054719 || FINANCAS || EDUARDO || 8352 || IMPLANTAR CENTRAL
	@history Ticket    4883 - Abel Babini  - 04/01/2021 - Gera��o de border�s autom�tica
	@history Ticket    4883 - Abel Babini  - 05/01/2021 - Corre��o para execu��o da rotina de border� manual
	@history Ticket    4883 - Abel Babini  - 08/01/2021 - Implementa��o de novas modalidades de pagamento
/*/
User Function F240FIL()

	Local cFiltro  := ""
	
	// Chamado n. 051382 || OS 052713 || FINANCAS || DRIELE || 8376 || FINA240 - fwnm - 12/09/2019
	Local nValor   := GetMV("MV_#VLRDOC",,4999.99) 
	Local cModNulo := GetMV("MV_#BORNUL",,"58")
	
	//Ticket    4883 - Abel Babini  - 08/01/2021 - Implementa��o de novas modalidades de pagamento
	Local cNatGPS := GetMV("MV_#BORGPS",,"22406,")
	Local cNatDRF := GetMV("MV_#BORDRF",,"22307,22406,22404,22603,22604,22606,22607,")
	Local cNatCON := GetMV("MV_#BORCON",,"20503,")
	Local cNatIMP := GetMV("MV_#BORIMP",,"22406,22610,22608,")
	Local cNatFGT := GetMV("MV_#BORFGT",,"22306,")
	
	IF !FWIsInCallStack("xAutBor") //Ticket   4883 - Abel Babini - 04/01/2021 - Gera��o de border�s autom�tica
		// Chamado n. 051382 || OS 052713 || FINANCAS || DRIELE || 8376 || FINA240 - fwnm - 12/09/2019
		mv_par05 := 2
		Aviso("F240FIL-01", "Se este border� estiver sendo gerado para o CNAB Fornecedores / SISPAG, informe as Modalidades de Pagamento abaixo para que o sistema filtre automaticamente os t�tulos... " + Chr(10) + Chr(13) + Chr(10) + Chr(13)+;
						"01 = (Cr�dito em Conta Corrente) " + Chr(10) + Chr(13) +;
						"30 = (Boletos pr�prio banco) " + Chr(10) + Chr(13) +;
						"31 = (Boletos outros bancos) " + Chr(10) + Chr(13) +;
						"58 = (T�tulo s/ Border�) " + Chr(10) + Chr(13) +;
						"03 = (DOC) valor at� " + Transform(nValor,"@E 999,999,999.99") + Chr(10) + Chr(13) +;
						"41 = (TED) valor acima de " + Transform(nValor,"@E 999,999,999.99") , {"OK"}, 3, "Modalidades v�lidas para CNAB FORNECEDORES! Campo A2_BANCO e par�metro MV_#VLRDOC...")

	ELSE
		//Est� sendo executado pelo Painel de Pagamentos
		//Defini��o dos par�metros da rotina
		mv_par01 := 3 //Considera t�tulos 1-Normais, 2-Adiantamentos, 3-Ambos
		mv_par02 := 1 //Considera Filiais 1-Sim, 2-N�o
		mv_par03 := aRet[1] //Filial De
		mv_par04 := aRet[2]//Filial At�
		mv_par05 := 1 //marca t�tulos automaticamente 1-Sim, 2-N�o
		mv_par06 := 1 //C�lculo dos impostos 1-Vencimento real, 2-Gera��o do border�, 3-Ambas
		mv_par07 := 2 //Mostra lan�amento 1-Sim, 2-N�o
		mv_par08 := 2 //Seleciona Filiais 1-Sim, 2-N�o
		mv_par09 := 2 //Considera forma de pagamento 1-Sim, 2-N�o
		mv_par10 := 2 //Considera agendamento 1-Sim, 2-N�o
		mv_par11 := CTOD('01/01/2001') //Data agendamento de
		mv_par12 := CTOD('31/12/2049') //Data agendamento at�
	ENDIF

	If cModPgto $ "01"	// 01-credito em conta corrente
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. IIF(EMPTY(SE2TMP->E2_BANCO),SA2->A2_BANCO,SE2TMP->E2_BANCO)==cPort240 .and. empty(SE2TMP->E2_CODBAR) "
	
	ElseIf cModPgto $ "03"	// 03-DOC
		// Chamado n. 052034 || OS 053364 || FINANCAS || FLAVIA || 8461 || BORDERO PAGAMENTO - fwnm - 23/09/2019
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. IIF(EMPTY(SE2TMP->E2_BANCO),SA2->A2_BANCO,SE2TMP->E2_BANCO)<>cPort240 .and. IIF(EMPTY(SE2TMP->E2_BANCO),SA2->A2_BANCO,SE2TMP->E2_BANCO)<>'   ' .and. empty(SE2TMP->E2_CODBAR) "
	
	ElseIf cModPgto $ "41"	// 41-TED
		// Chamado n. 052034 || OS 053364 || FINANCAS || FLAVIA || 8461 || BORDERO PAGAMENTO - fwnm - 23/09/2019
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. IIF(EMPTY(SE2TMP->E2_BANCO),SA2->A2_BANCO,SE2TMP->E2_BANCO)<>cPort240 .and. IIF(EMPTY(SE2TMP->E2_BANCO),SA2->A2_BANCO,SE2TMP->E2_BANCO)<>'   ' .and. empty(SE2TMP->E2_CODBAR) "
	
	ElseIf cModPgto $ "30"	// 30-LIQUIDACAO TITULOS PROPRIO BANCO
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. !Empty(SE2TMP->E2_CODBAR) .and. Left(AllTrim(SE2TMP->E2_CODBAR),3)==cPort240 "

	ElseIf cModPgto $ "31"	// 31-PAGAMENTO DE TITULOS EM OUTRO BANCO                    
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. !Empty(SE2TMP->E2_CODBAR) .and. Left(AllTrim(SE2TMP->E2_CODBAR),3)<>cPort240 "

	//INICIO Ticket    4883 - Abel Babini  - 08/01/2021 - Implementa��o de novas modalidades de pagamento
	ElseIf cModPgto $ "13" .AND. FWIsInCallStack("xAutBor") // 13-CONCESSION�RIAS
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. !Empty(SE2TMP->E2_CODBAR) .AND. Left(AllTrim(SE2TMP->E2_CODBAR),2)=='84' .AND. AllTrim(SE2TMP->E2_NATUREZ) $ '"+cNatCON+"' "

	ElseIf cModPgto $ "16" .AND. FWIsInCallStack("xAutBor") // 16-PAGAMENTO DE TRIBUSTO DARF NORMAL
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. !Empty(SE2TMP->E2_CODBAR) .AND. Left(AllTrim(SE2TMP->E2_CODBAR),3)=='856' .AND. AllTrim(SE2TMP->E2_NATUREZ) $ '"+cNatDRF+"' "

	ElseIf cModPgto $ "17" .AND. FWIsInCallStack("xAutBor") // 17-PAGAMENTO DE TRIBUSTO GPS
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. !Empty(SE2TMP->E2_CODBAR) .AND. Left(AllTrim(SE2TMP->E2_CODBAR),2)=='81' .AND. AllTrim(SE2TMP->E2_NATUREZ) $ '"+cNatGPS+"' "

	ElseIf cModPgto $ "11" .AND. FWIsInCallStack("xAutBor") // 11-CONTAS E TRIBUTOS COM CODIGO DE BARRAS
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. !Empty(SE2TMP->E2_CODBAR) .AND. Left(AllTrim(SE2TMP->E2_CODBAR),3)=='858' .AND. ALLTRIM(SE2TMP->E2_PORTADO) = '237' .AND. AllTrim(SE2TMP->E2_NATUREZ) $ '"+cNatFGT+"' "

	ElseIf cModPgto $ "35" .AND. FWIsInCallStack("xAutBor") // 35-FGTS
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. !Empty(SE2TMP->E2_CODBAR) .AND. Left(AllTrim(SE2TMP->E2_CODBAR),3)=='858' .AND. ALLTRIM(SE2TMP->E2_PORTADO) $ ('341','422') .AND. AllTrim(SE2TMP->E2_NATUREZ) $ '"+cNatFGT+"' "

	ElseIf cModPgto $ "91" .AND. FWIsInCallStack("xAutBor") // 91-TRIBUTOS
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. !Empty(SE2TMP->E2_CODBAR) .AND. Left(AllTrim(SE2TMP->E2_CODBAR),3)=='858' .AND. AllTrim(SE2TMP->E2_NATUREZ) $ '"+cNatIMP+"' "
	//FIM Ticket    4883 - Abel Babini  - 08/01/2021 - Implementa��o de novas modalidades de pagamento


	ElseIf cModPgto $ cModNulo	// 58-NULO - S/ COD BARRAS E BANCO NO FORNECEDOR             
		cFiltro := " SA2->(dbseek(FWxFilial('SA2')+SE2TMP->E2_FORNECE+SE2TMP->E2_LOJA)) .and. Empty(SE2TMP->E2_NUMBOR) "
	EndIf

	If Empty(cFiltro)
		cFiltro := "E2_XDIVERG <> 'S' "
	Else
		cFiltro += " .and. E2_XDIVERG <> 'S' "
	EndIf

Return(cFiltro)
