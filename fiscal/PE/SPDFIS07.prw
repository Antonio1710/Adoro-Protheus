#include 'protheus.ch'
/*/{Protheus.doc} User Function SPDFIS07
	Ponto de entrada que permite a customização do Código da da Conta Contábil no registro H010 do SPED Fiscal.
	MODELO PE PADRAO TOTVS-ATENCAO AO ALTERAR
	@type  Function
	@author ADRIANA OLIVEIRA
	@since 20/03/18
	@history Chamado 047912  - Adriana Oliveira  - 14/03/2019 - ajuste conforme documentacao Portal Totvs (tdn.totvs.com/pages/releaseview.action?pageId=60771763)
	@history Chamado 047912  - Adriana Oliveira  - 19/03/2019 - ajuste para outros tipos de operacao
	@history Ticket 69236    - Abel Babini       - 15/03/2022 - criação de novas regras
	@history Ticket 69236    - Abel Babini       - 28/03/2022 - Ajuste dos códigos de produtos
	@history ticket 88595    - Fernando Macieira - 14/03/2023 - BLOCO H - Importação Dados 2022
	@history ticket 88595    - Fernando Sigoli   - 15/03/2023 - BLOCO H - Importação Dados 2022
	@history ticket TI - Antonio Domingos - 30/05/2023 - Revisão Ajuste Nova Empresa
/*/
User Function SPDFIS07()

	Local cCodProduto := PARAMIXB[1] //Codigo do Produto
	Local cSituacao   := PARAMIXB[2] // Situação do inventario
	Local cRetorno    := SB1->B1_CONTA // @history ticket 88595 - 14/03/2023 - Fernando Macieira - BLOCO H - Importação Dados 2022
	Local cCodForn    := Alltrim(SA2->A2_COD)
	Private _cEmpFL1   := SuperGetMv("MV_#EMPFL1",.F.,"0102/1301") //Codigos de Empresas+Filiais Ativas Grupo 1 //ticket TI - William Costa - 23/05/2023
	Private _cEmpFL7   := SuperGetMv("MV_#EMPFL7",.F.,"010B/1301") //Codigos de Empresas+Filiais Ativas Grupo 7 //ticket TI - William Costa - 23/05/2023

	//    2- Item de propriedade de terceiros em posse do informante
	If cSituacao == '1' .and. Alltrim(cCodProduto) <> "383369" .and. Alltrim(cCodProduto) <> "100252"
		cRetorno := "111580001" 
	EndIf

	//    1- Item de propriedade do informante em posse de terceiros
	If cSituacao == '0' .and. Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ _cEmpFL1 .and. (Alltrim(cCodProduto) == "349368" .or. Alltrim(cCodProduto) == "349369") //ticket TI - William Costa - 24/05/2023
		cRetorno := "111540002"
	ElseIf cSituacao == '1' .and. ( Alltrim(cCodProduto) == "383369" .or. Alltrim(cCodProduto) == "385351" ) // @history ticket 88595 - 14/03/2023 - Fernando Macieira - BLOCO H - Importação Dados 2022
		cRetorno := "111580002"
	ElseIf cSituacao == '1' .and. cCodForn = '018786'  .and. ( Alltrim(cCodProduto) == "100252" .or.; // fernando Sigoli  15/03/2023 - BLOCO H - Importação Dados 2022
									Alltrim(cCodProduto) == "121807" .or.;
									Alltrim(cCodProduto) == "121810" .or.;
									Alltrim(cCodProduto) == "129151" .or.;
									Alltrim(cCodProduto) == "153720" .or.;
									Alltrim(cCodProduto) == "144427" .or.;
									Alltrim(cCodProduto) == "154002" .or.;
									Alltrim(cCodProduto) == "185497" .or.;
									Alltrim(cCodProduto) == "192260" .or.;
									Alltrim(cCodProduto) == "192578" .or.;
									Alltrim(cCodProduto) == "192959" .or.;
									Alltrim(cCodProduto) == "196468" )
	
	
			cRetorno := "111580004"
	
	/*ElseIf cSituacao == '1' .and. ( Alltrim(cCodProduto) == "100252" .or.;
									Alltrim(cCodProduto) == "121807" .or.;
									Alltrim(cCodProduto) == "121810" .or.;
									Alltrim(cCodProduto) == "129151" .or.;
									Alltrim(cCodProduto) == "153720" .or.;
									Alltrim(cCodProduto) == "144427" .or.;
									Alltrim(cCodProduto) == "154002" .or.;
									Alltrim(cCodProduto) == "185497" .or.;
									Alltrim(cCodProduto) == "192260" .or.;
									Alltrim(cCodProduto) == "192578" .or.;
									Alltrim(cCodProduto) == "192959" .or.;
									Alltrim(cCodProduto) == "196468" )*/
	
		
	
	EndIf

	//@history ticket 88595 - 14/03/2023 - Fernando Macieira - BLOCO H - Importação Dados 2022

	/*
	Regras a serem acrescentadas na rotina (sobrepondo as regras antigas):
	Se for Filial 0B, situação 0, B1_TIPO = PA, CONTA CONTABIL 111510006
	Se for Filial 0B, situação 0, B1_TIPO = MP, CONTA CONTABIL 111530013
	Se for Filial 0B, situação 1, B1_TIPO = PA, CONTA CONTABIL 111580004
	Se for filial 0B, situação 1, B1_TIPO = MP, CONTA CONTABIL 111580001
	*/

	If Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ _cEmpFL7 .and. AllTrim(SB1->B1_TIPO) == "PA" .and. AllTrim(cSituacao) == '0' //ticket TI - William Costa - 24/05/2023
		cRetorno := "111510006"
	ElseIf Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ _cEmpFL7 .and. AllTrim(SB1->B1_TIPO) == "MP" .and. AllTrim(cSituacao) == '0' //ticket TI - William Costa - 24/05/2023
		cRetorno := "111530013"
	ElseIf Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ _cEmpFL7 .and. AllTrim(SB1->B1_TIPO) == "PA" .and. AllTrim(cSituacao) == '1' //ticket TI - William Costa - 24/05/2023
		cRetorno := "111580004"
	ElseIf Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ _cEmpFL7 .and. AllTrim(SB1->B1_TIPO) == "MP" .and. AllTrim(cSituacao) == '1' //ticket TI - William Costa - 24/05/2023
		cRetorno := "111580001"
	EndIf
	//

Return cRetorno
