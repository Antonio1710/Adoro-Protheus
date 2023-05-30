#INCLUDE "rwmake.ch"

/*/{Protheus.doc} User Function nomeFunction
	Retorna o numero do item contabeil de SD1 para o lp 660-000
	@type  Function
	@author hcconsys
	@since 21/05/07
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 71057 - Fernando Macieira - 08/04/2022 - Item contábil Lançamentos da Filial 0B - Itapira
	@history ticket 86123 - 05/01/2023 - FERNANDO MACIEIRA - Compras/Fornecedores Intercompany (Empresa Adoro)
	@history ticket 87948 - 06/02/2023 - FERNANDO MACIEIRA - Compras/Fornecedores Intercompany (Empresa SAFEGG)
	@history ticket 91913 - 26/04/2023 - Antonio Domingos - Alteração LPs 660-000 - 650-001 - 650-006 - 650-007 // Empresa Adoro
	@history ticket TI - Antonio Domingos - 20/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 23/05/2023 - Revisão Ajuste Nova Empresa
/*/
User Function LP660()

	Local  _aArea   := GetArea()
	Local _aAreaSF1 := SF1->(GetArea())
	Local _aAreaSD1 := SD1->(GetArea())
	Local _aAreaSDE := SDE->(GetArea())
	Local _cPIt125  := SuperGetmv("MV_#PIT125",.F.,"856470/856472") //Produtos para Item da Conta "125" //ticket 91913 - 26/04/2023 - Antonio Domingos

	Local _cItemCta := ""  
	Private _cEmpFL1 := SuperGetMv("MV_#EMPFL1",.F.,"0102/1301") //Codigos de Empresas+Filiais Ativas Grupo 1 //ticket TI - Antonio Domingos - 20/05/2023

	U_ADINF009P('LP660' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial("SD1") + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA,.T.)

	If SD1->D1_RATEIO <> "1"
		_cItemCta	:= SD1->D1_ITEMCTA
		If empty(_cItemCta)
			//ticket TI - Antonio Domingos - 20/05/2023 
			_cItemCta := iif(alltrim(cEmpAnt)+SD1->D1_FILIAL$_cEmpFL1,"121",iif(SD1->D1_FILIAL=="06","122",iif(SD1->D1_FILIAL=="07","123",iif(SD1->D1_FILIAL=="08","115",iif(SD1->D1_FILIAL=="09","116","114")))))
		EndIf

	Else
		
		//LER ARQUIVO DE RATEIO
		
		dbSelectArea("SDE")
		dbSetOrder(1)
		dbSeek(xFilial("SDE") + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA + SD1->D1_ITEM,.T.)
		
		_cItemCta	:= SDE->DE_ITEMCTA
		If empty(_cItemCta)
			//ticket TI - Antonio Domingos - 20/05/2023 
			_cItemCta := iifalltrim(cEmpAnt)+(SDE->DE_FILIAL$_cEmpFL1,"121",iif(SDE->DE_FILIAL=="06","122",iif(SD1->D1_FILIAL=="07","123",iif(SD1->D1_FILIAL=="08","115",iif(SD1->D1_FILIAL=="09","123","116")))))
		EndIf
		
	Endif

	// @history ticket 71057 - Fernando Macieira - 08/04/2022 - Item contábil Lançamentos da Filial 0B - Itapira
	If AllTrim(cEmpAnt) == "01" .and. AllTrim(cFilAnt) == "0B"
		_cItemCta := AllTrim(GetMV("MV_#ITACTD",,"125"))
	EndIf
	//
	//ticket 91913 - 26/04/2023 - Antonio Domingos
    //Criar uma regra que quando tiver os produtos 856470 e 856472 sejam contabilizados no item 125, independente da filial da nota.
    If ALLTRIM(SD1->D1_COD) $ _cPIt125
        _cItemCta := "125"
	EndIf
	
	RestArea(_aArea)
	RestArea(_aAreaSF1)
	RestArea(_aAreaSD1)
	RestArea(_aAreaSDE)

Return(_cItemCta) 
					

// Rotina para tratar o retorno da Natureza de opercao para LP 660.
// *******************************************************************
// @history ticket 80865 - Antonio Domingos - 04/10/2022 - LP de Compra/ Fornecedores - Empresa CERES
User Function LP660SED()

// *******************************************************************
	Local  _aArea      := GetArea()
	Local _aAreaSE2	   := SE2->(GetArea())
	Local _aAreaSDE	   := SDE->(GetArea())    
	Local _cContaSED   := "" 
	Local _cMVLP660F   := SuperGetMV("MV_#LP660F",.F.,"000003/004303/000217") //Fornecedores Nacionais
	Local cInterCo     := GetMV("MV_#GRPFOR",,"000437|017976|026698|025700") // 000437 (Ceres)/ 017976 (RNX2)/ 026698 (Safegg)/ 025700 (CLML)

	U_ADINF009P('LP660' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

	//@history ticket 87948 - 06/02/2023 - FERNANDO MACIEIRA - Compras/Fornecedores Intercompany (Empresa SAFEGG)
	If AllTrim(FWCodEmp()) == "09"
		cInterCo := GetMV("MV_#GRPFOR",,"000217|002922|015513|027468|000437|017976") // 000217 / 002922 / 015513 / 027468 e 000437 (CERES) e 017976 (RNX2) 
	EndIf
	
	// @history ticket 86123 - 05/01/2023 - FERNANDO MACIEIRA - Compras/Fornecedores Intercompany (Empresa Adoro)
	If AllTrim(SF1->F1_FORNECE) $ cInterCo
		_cContaSED := "211110008"
	Else

		//ticket 80865 - Antonio Domingos - 04/10/2022 - LP de Compra/ Fornecedores - Empresa CERES
		If SM0->M0_CODIGO = '02' .And. SF1->F1_FORNECE $ _cMVLP660F //CERES
			_cContaSED := TABELA("Z@","P03",.F.) 
		Else
			// ***************** INICIO ALTERACAO CHAMADO 024322 ********************************************** //
			SqlTitPag(Xfilial("SE2"),SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_SERIE,SF1->F1_DOC)
			/*BEGINDOC
			//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
			//³apos a atualizacao do sistema protheus no dia 03/08/2015, passou-se no momento do estorno da classificacao³
			//³da nota de entrada foi alterado pela totvs, anteriormente fazia o seguinte processo:                      ³
			//³ESTORNO NF COMPRAS -> LANCAMENTOS PADROES -> EXCLUSAO DO TITULO                                           ³
			//³agora com a alteracao ficou assim                                                                         ³
			//³ESTORNO NF COMPRAS -> EXCLUSAO DO TITULO -> LANCAMENTOS PADROES                                           ³
			//³portanto foi refeito esse select para ler arquivos do SE2 deletados mais ordenado por R_E_C_N_O_          ³
			//³para garantir que pegue o ultimo excluido.                                                                ³
			//³EXPLICACAO POR WILLIAM COSTA                                                                              ³
			//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
			ENDDOC*/
			
			While TRB->(!EOF())
							
				_cContaSED	:=	TRB->ED_CONTA 
						
				TRB->(dbSkip())
			ENDDO
			TRB->(dbCloseArea()) 
		EndIf
		// ***************** INICIO ALTERACAO CHAMADO 024322 ********************************************** //


		/*
		//SA2->(  dbSetOrder(1) )
		//SA2->( dbSeek(XFILIAL("SA2")+SF1->F1_FORNECE+SF1->F1_LOJA) )
		SE2->(  dbSetOrder(6) )
		SE2->( dbSeek(XFILIAL("SE2")+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC) )

		SED->(  dbSetOrder(1) )
		//SED->( dbSeek( XFILIAL("SED")+SA2->A2_NATUREZ) )
		SED->( dbSeek( XFILIAL("SED")+SE2->E2_NATUREZ) )

		_cContaSED	:=	SED->ED_CONTA 

		RestArea(_aArea)
		RestArea(_aAreaSE2)
		RestArea(_aAreaSDE)
		*/

	EndIf

	RestArea(_aArea)
	RestArea(_aAreaSE2)
	RestArea(_aAreaSDE)

Return (_cContaSED)

Static Function SqlTitPag(cFil,cFornece,cLoja,cPrefixo,cDoc)                        

	BeginSQL Alias "TRB"
			%NoPARSER% 
			SELECT TOP(1) SED.ED_CONTA
					FROM %Table:SE2% SE2 WITH(NOLOCK), %Table:SED% SED WITH(NOLOCK) 
					WHERE SE2.E2_FILIAL  = %EXP:cFil%
					AND SE2.E2_FORNECE = %EXP:cFornece%
					AND SE2.E2_LOJA    = %EXP:cLoja%
					AND SE2.E2_PREFIXO = %EXP:cPrefixo%
					AND SE2.E2_NUM     = %EXP:cDoc%
					AND SE2.E2_NATUREZ = SED.ED_CODIGO

			ORDER BY SE2.R_E_C_N_O_ DESC
	EndSQl             

RETURN(NIL) 


