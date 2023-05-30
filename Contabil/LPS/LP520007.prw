#INCLUDE "PROTHEUS.CH"

/*{Protheus.doc} User Function LP520007
	Excblock utilizado para retornar o Conta Contabil debito
	@type  Function
	@author WILLIAM COSTA
	@since 27/01/2017
	@version 01
	@history Chamado 049561 - William Costa  - 06/06/2019 - Tratamento para quando o motivo da Baixa foir BCF ou BPQ, pular e nao gravar Lancamento. 
	@history Chamado 3284 - William Costa    - 13/10/2020 - Adicionado regra de exceção para titulos com tipo PR não serem contabilizados.
	@history ticket 79332 - Antonio Domingos - 12/09/2022 - Abertura do LP 520-007 - Clientes CERES.
	@history Ticket 80115 - Abel Babini      - 19/09/2022 - LP Baixa de títulos receber - EMPRESA CERES
	@history Ticket 86182 - 09/01/2023 - Fernando Macieira - Baixa recebimento de clientes (Empresa Adoro)
	@history Ticket 86182 - 02/02/2023 - Fernando Macieira - Baixa recebimento de clientes (Empresa Adoro)	
	@history Ticket 87950 - 06/02/2023 - Fernando Macieira - Baixa recebimento de clientes (Empresa SAFEGG)
*/	
User Function LP520007()

	Local cConta := ''
	Local cParCliIntC := SuperGetMV("MV_XCLINTC",.F.,"097623/097658/014999")
	Local cCtaCliIntC := TABELA("Z@","A05",.F.)
	Local cCodClBx    := GetMV("MV_#LPBXRC",,"") //Ticket 80115 - Abel Babini      - 19/09/2022 - LP Baixa de títulos receber - EMPRESA CERES
	Local cCtaClBx    := TABELA("Z@","A06",.F.)
	Local cInterCo := GetMV("MV_#GRPADO",,"016652|054283|031017") // 016652 (CERES) / 054283 (SAFEGG) / 031017 (RNX2) // @history Ticket 86182 - 09/01/2023 - Fernando Macieira - Baixa recebimento de clientes (Empresa Adoro)
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

	//@history Ticket 87950 - 06/02/2023 - Fernando Macieira - Baixa recebimento de clientes (Empresa SAFEGG)
	If AllTrim(FWCodEmp()) == "09"
		cInterCo := GetMV("MV_#GRPADO",,"027601|024288|025663|025652|014999|054051") // 027601 (FL02) / 024288 (FL01) / 025663 (FL04) / 025652 (F05) / 014999 (FL03) e 054051 (RNX2)
	EndIf

    // @history Ticket 86182 - 09/01/2023 - Fernando Macieira - Baixa recebimento de clientes (Empresa Adoro)
	If AllTrim(SE5->E5_CLIFOR) $ cInterCo
		cConta := "111210005" // DUPLICATAS A RECEBER INTERCOMPANY
	Else
		cConta := IIF(Alltrim(cEmpAnt)=='02' .AND. SE5->E5_CLIFOR $ cCodClBx .AND. ALLTRIM(SE5->E5_TIPO) == 'NF',cCtaCliIntC,IIF(SM0->M0_CODIGO=='02' .AND. SE5->E5_CLIFOR $ cParCliIntC .AND. ALLTRIM(SE5->E5_TIPO) == 'NCI',cCtaClBx,IIF(ALLTRIM(SE1->E1_TIPO)=="NDC","111720002",IIF(ALLTRIM(SE1->E1_TIPO)=="JP","191110097",IIF(ALLTRIM(SE1->E1_TIPO)=="CH","111230001",IIF(!EMPTY(SA1->A1_CONTA),SA1->A1_CONTA,IIF(SA1->A1_EST<>"EX",TABELA("Z@","A00",.F.),TABELA("Z@","A01",.F.))))))))
		// @history Ticket 86182 - 02/02/2023 - Fernando Macieira - Baixa recebimento de clientes (Empresa Adoro)	
		If ALLTRIM(SE5->E5_TIPO) == 'NCI'
			cConta := "111720004" // TITULOS A RECEBER PARTES RELACIONADAS
		EndIf
		//
	EndIf

RETURN(cConta) 

/*/{Protheus.doc} User Function nomeFunction
	(long_description)
	@type  Function
	@author user
	@since 07/02/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function LP520VLR()

	Local nValor := 0
	
	U_ADINF009P('LP520007' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	//Ajuste William Costa 06/06/2019 chamado 049561
 	nValor:= IF(SE1->E1_NATUREZ="10150",0,IF(!SE5->E5_MOTBX$"DAC,LIQ,DEV,SIN,DEA,JPN,SDD,BCF,BPQ".AND.!SE5->E5_TIPO$"RA /NCC/NCI/BON/PR " .AND. !SE5->E5_TIPODOC $ "J2",SE5->E5_VALOR-SE5->E5_VLJUROS-SE5->E5_VLMULTA+SE5->E5_VLDESCO-SE5->E5_VLCORRE,0))

Return (nValor) 
