#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function LP610CC
	Execblock utilizado para retornar o centro de custo
	@type  Function
	@author Everaldo Casaroli
	@since 11/11/2007
	@version 01
	@history Chamado 050440 - William Costa   - 18/07/2019 - Adicionado grupo 0543
	@history Chamado 050115 - FWNM            - 05/08/2019 - Integracao Kassai
	@history Chamado 052561 - FWNM            - 14/10/2019 - Regra RNX2       
	@history Chamado 053445 - FWNM            - 19/11/2019 - 053445 || OS 054828 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || ACERTO LPS
	@history Chamado 054957 - FWNM            - 15/01/2020 - OS 056365 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP 610
	@history Chamado 056634 - FWNM            - 13/03/2020 - || OS 058079 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || CHAMADO 055812
	@history Chamado 056639 - FWNM            - 13/03/2020 - || OS 058088 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP610
	@history Chamado 058963 - Everson         - 17/06/2020 - 058963 || OS 060456 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP 610
	@history Chamado 060160 - FWNM            - 03/08/2020 - || OS 061652 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || 610 - PRODUTO 391129
	@history Chamado 060154 - FWNM            - 03/08/2020 - || OS 061651 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP – 610
	@history Chamado 060339 - FWNM            - 06/08/2020 - || OS 061850 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP610CTA - RNX2
	@history Chamado 060629 - Everson         - 17/08/2020 - || OS 062127 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LANC PADRAO
	@history ticket     483 - FWNM            - 26/08/2020 - CONTROLADORIA || DRIELE_LEME || 8507 || AJUSTE LP 610-001
	@history ticket    9226 - Fernando Maciei - 25/02/2021 - Lançamento Padrão 610-001 - abertura/alteração
	@history ticket   16175 - Fernando Maciei - 30/06/2021 - Alteração LP -Receita serviço Ceres
	@history ticket   66325 - Everson - 07/01/2022 - Tratamento para filial 04.
	@history Ticket TI 		- Leonardo P. Monteiro - Fontes compilados emergencialmente 13/01/2022 11:44.
	@history Ticket TI 		- Leonardo P. Monteiro - 	@history Ticket TI - Leonardo P. Monteiro - Fontes compilados emergencialmente 13/01/2022 11:44.
	@history Ticket 69333 	- Leonardo P. Monteiro - 07/03/2021 - Compatibilização de estercos (Grp. 9037) na conta 337110003 e Centro de Custo 6140.
	@history Ticket 69336 	- Leonardo P. Monteiro - 07/03/2021 - Compatibilização de estercos (Grp. 9048) no Centro de Custo 6140.
	@history ticket 78559 - Antonio Domingos - 24/08/2022 - Alteração de LP dos programas internos das regras
	@history ticket 80450 - Antonio Domingos - 22/09/2022 - Inclusao de regra programas U_LP610CC(), U_610002() , U_LPCTHCC
	@history ticket 84143 - Antonio Domingos - 30/11/2022 - Alterar lp 610-001 - incl - fat- rec clientes - produto 190590
	@history ticket 85727 - 29/12/2022 - Fernando Macieira - Receitas eventuais - Empresa Adoro
	@history ticket 85725 - 03/01/2023 - Fernando Macieira - Receita de vendas e Serviços - Intercompany (Empresa ADORO)
	@history ticket 85727 - 04/01/2023 - Fernando Macieira - Receitas eventuais - Empresa Adoro - CC
	@history ticket 87941 - 06/02/2023 - Fernando Macieira - Receita de vendas e Serviços - Intercompany (Empresa SAFEGG)
	@history ticket 90947 - Antonio Domingos - 03/04/2023 - Ajuste LPs nova operação Despojos / Itapir
	@history ticket 90947 - Antonio Domingos - 04/04/2023 - Incluido regra no LP620-002
	@history ticket 91149 - Antonio Domingos - 06/04/2023 - LP 610-001 SAFEGG
/*/
User Function LP610cc()

	Local _cCusto  := ""   
	Local aArea    := SD2->(GetArea())  // Incluido Cellvla 17-04-2014
	Local cInterCo := GetMV("MV_#GRPADO",,"016652|054283|031017") // 016652 (CERES) / 054283 (SAFEGG) / 031017 (RNX2)

	//U_ADINF009P('LP610' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	If ALLTRIM(SD2->D2_GRUPO) $ "0511 0541 0542 0543 " //BUSCA POR SUBGRUPO// Alterado por Adriana em 18/03/15 - chamado 022330 // Chamado 050440 William Costa 18/07/2019 
	   IF SUBSTR(SD2->D2_CF,1,1)$"1,5"
		  _cCusto:="6120"
	   ELSEIF SUBSTR(SD2->D2_CF,1,1)$"2,6"                                  
		  _cCusto:="6220"	
	   ELSEIF SUBSTR(SD2->D2_CF,1,1)$"3,7"
		  _cCusto:="6920"
	   endif
	                    
	ELSEIF ALLTRIM(SD2->D2_GRUPO) $ "0911/0912/0913" //alterado de == para $ chamado 036288 william  //BUSCA POR SUBGRUPO alterado william chamado 026894
		If ALLTRIM(SD2->D2_CF)$"5101/5102/5922" 
			_cCusto:="6130"
		ELSEIF ALLTRIM(SD2->D2_CF)$"6101/6102" 
			_cCusto:="6230"
		ELSEIF ALLTRIM(SD2->D2_CF)$"7101/7102" 
			_cCusto:="6930"
		Endif			

	ELSEIF ALLTRIM(SD2->D2_GRUPO) == "9008" //BUSCA POR SUBGRUPO
		If ALLTRIM(SD2->D2_CF)$"5118/5101" 
			_cCusto:="6150"
		Endif

	//@history Ticket 69333 	- Leonardo P. Monteiro - 	Compatibilização de estercos (Grp. 9037) na conta 337110003 e Centro de Custo 6140.
	//@history Ticket 69336 	- Leonardo P. Monteiro - 07/03/2021 - Compatibilização de estercos (Grp. 9048) no Centro de Custo 6140.
	ELSEIF ALLTRIM(SD2->D2_GRUPO)$"9037/9048" 
			_cCusto:="6140"

	ELSEIF ALLTRIM(SD2->D2_CF)$"5252"
		//_cCusto:="1102"
		 _cCusto:="6140" //fernando sigoli 17/08/2018 - Chamado: 043244                                     
	
	ELSEIF SUBSTR(SD2->D2_CF,1,1)$"1,5"
		_cCusto:="6110"
		
	ELSEIF SUBSTR(SD2->D2_CF,1,1)$"2,6"                                  
		_cCusto:="6210"
		
	ELSEIF SUBSTR(SD2->D2_CF,1,1)$"3,7"
		_cCusto:="6910"
		
	ENDIF
	  
	IF ALLTRIM(SD2->D2_CF) == "" // Incluido em 01/11/10 - Ana. Pois se o CFOP estiver em branco ira gerar error.log
		Alert("CFOP da NF: " + SD2->D2_DOC + " emitida em: "+ DTOC(SD2->D2_EMISSAO) +" em branco. Favor verificar!")     
	ENDIF                         
	
	// Inclusão em 17-04-2014 - Cellvla - Tratar a Variavel _cCusto quando retornar vazia
	
	// Tratamento do centro de custo para a Filial 03 - 24-02-2015.
	If !Empty(SD2->D2_CCUSTO) .AND. SD2->D2_FILIAL $ "03/04"
		_cCusto:= SD2->D2_CCUSTO 
	Endif  
	
	//kpi Alterado 24-03-2015
	If !Empty(SD2->D2_CCUSTO) .AND. SD2->D2_FILIAL $ "05"
		_cCusto:= "6150" 
	Endif
	// Fim do Tratamento 24-02-2015.
	
	If Empty(_cCusto) 
		_cCusto:= SD2->D2_CCUSTO
	Endif
	
	// Adicionado William Costa data 01/03/2016 chamado 027321
	// Adicionado William Costa data 26/10/2018 o Grupo 0928 044479 || OS 045619 || CONTROLADORIA || MONIK_MACEDO || 8956 || LP 610-001
	IF ALLTRIM(SD2->D2_GRUPO) $ "0921 0922 0923 0924 0925 0926 0927 0928" 
		_cCusto:="6180"
	ENDIF	
	
	// *** INICIO CHAMADO 034241 / 041751 - WILLIAM COSTA *** //
	IF ALLTRIM(SD2->D2_GRUPO) $ "9023/9024/9020/9030" 
		_cCusto:="6140"
	ENDIF
	// *** FINAL CHAMADO 034241 / 041751 - WILLIAM COSTA *** //
	
	// *** INICIO CHAMADO 045972 - WILLIAM COSTA *** //
	//IF ALLTRIM(SD2->D2_COD) $ "113069/113071/113081/113093/142476"
	IF ALLTRIM(SD2->D2_COD) $ "113069/113071/113081/113093/142476/147679/148257/149104/149105/149106" // Chamado n. 056639 || OS 058088 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP610 - FWNM - 13/03/2020 //Chamado 058963 - Everson - 17/06/2020. //Chamado 060629 - Everson - 17/08/2020.
		IF SUBSTR(SD2->D2_CF,1,1)$"1,5"
		  _cCusto:="6190"
		ELSEIF SUBSTR(SD2->D2_CF,1,1)$"2,6"                                  
		  _cCusto:="6290"	
		ENDIF
	ENDIF
	// *** FINAL CHAMADO 045972 - WILLIAM COSTA *** //
	
	// Chamado n. 053445 || OS 054828 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || ACERTO LPS - fwnm - 19/11/2019
	If cEmpAnt == "01" .and. SD2->D2_FILIAL == "03"
		If Alltrim(SD2->D2_COD) == "391650"
			_cCusto := "6140"
		Endif
	EndIf

	// Chamado n. 060160 || OS 061652 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || 610 - PRODUTO 391129 - FWNM - 03/08/2020
	If AllTrim(SD2->D2_COD) == "391129" //(OLEO TRIDECANTER)
		If Left(AllTrim(SD2->D2_CF),1) == "5"
			_cCusto := "6140"
		ElseIf Left(AllTrim(SD2->D2_CF),1) == "6"
			_cCusto := "6240"
		EndIf
	EndIf
	//

	// Chamado n. 060154 || OS 061651 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP – 610 - FWNM - 03/08/2020
	If AllTrim(SD2->D2_GRUPO) == "9040"
		If Left(AllTrim(SD2->D2_CF),1) == "5"
			_cCusto := "6140"
		ElseIf Left(AllTrim(SD2->D2_CF),1) == "6"
			_cCusto := "6240"
		EndIf
	EndIf
	//

	// Chamado n. 060339 || OS 061850 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP610CTA - RNX2 - FWNM - 06/08/2020
	If AllTrim(cEmpAnt) == "07"

		If Left(AllTrim(SD2->D2_CF),1) == "5"
			_cCusto := "6110"
		ElseIf Left(AllTrim(SD2->D2_CF),1) == "6"
			_cCusto := "6210"
		EndIf

		If AllTrim(SD2->D2_COD) $ "384837|384838"

			If Left(AllTrim(SD2->D2_CF),1) == "5"
				_cCusto := "6142"
			ElseIf Left(AllTrim(SD2->D2_CF),1) == "6"
				_cCusto := "6242"
			EndIf

		Else

			If AllTrim(SD2->D2_CF) == "5102"
				_cCusto := "6140"
			ElseIf AllTrim(SD2->D2_CF) == "6102"
				_cCusto := "6240"
			EndIf

		EndIf

	EndIf
	//

	//@history ticket 483 - FWNM - 26/08/2020 - CONTROLADORIA || DRIELE_LEME || 8507 || AJUSTE LP 610-001
	If AllTrim(cEmpAnt) == "09"
		
		_cCusto := "6170"

		If AllTrim(SD2->D2_COD) == "386914"

			If Left(AllTrim(SD2->D2_CF),1) == "5"
				_cCusto := "6141"
			ElseIf Left(AllTrim(SD2->D2_CF),1) == "6"
				_cCusto := "6241"
			EndIf
		
		ElseIf AllTrim(SD2->D2_COD) == "384413"

			If Left(AllTrim(SD2->D2_CF),1) == "5"
				_cCusto := "6110"
			ElseIf Left(AllTrim(SD2->D2_CF),1) == "6"
				_cCusto := "6210"
			EndIf

		ElseIf AllTrim(SD2->D2_COD) == "391650"

			If Left(AllTrim(SD2->D2_CF),1) == "5"
				_cCusto := "6140"
			ElseIf Left(AllTrim(SD2->D2_CF),1) == "6"
				_cCusto := "6240"
			EndIf

		EndIf

	EndIf
	//

	// @history ticket    9226 - Fernando Maciei - 25/02/2021 - Lançamento Padrão 610-001 - abertura/alteração
	// LP610CC= Se a CFOP for igual a 5124 , Centro de custos: 6170 ou se a CFOP for igual a 6124, Centro de custos  6270
	If AllTrim(SD2->D2_CF) == "5124"
		_cCusto := "6170"
	ElseIf AllTrim(SD2->D2_CF) == "6124"
		_cCusto := "6270"
	EndIf
	//ticket 80450 - Antonio Domingos - 22/09/2022 - Inclusao de regra programas U_LP610CC(), U_610002() , U_LPCTHCC
	//U_LP610CC()
	If SD2->D2_FILIAL = '0B'
		//Se a D2_FILIAL for 0B E  D2_CF  = 5102 e D2_GRUPO diferente de 0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314, então Centro custo 6111
	    If ALLTRIM(SD2->D2_CF) = '5102' .AND. !(SD2->D2_GRUPO $ '0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314')
			_cCusto := '6111'
		//Se a D2_FILIAL for 0B E  D2_CF  = 6102 e D2_GRUPO diferente de 0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314, então Centro custo 6211
		ElseIf ALLTRIM(SD2->D2_CF) = '6102' .AND. !(SD2->D2_GRUPO $ '0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314')
			_cCusto := '6211'
		//Se a D2_FILIAL for 0B E  D2_CF  = 5102//5403 e D2_GRUPO igual  542/0511/0541, então Centro custo 6121
		ElseIf ALLTRIM(SD2->D2_CF) $ '5102/5403' .AND. SD2->D2_GRUPO $ '542/0511/0541'
			_cCusto := '6121'
		//Se a D2_FILIAL for 0B E  D2_CF  = 6102/6403 e D2_GRUPO igual  542/0511/0541, então Centro custo 6221
		ElseIf ALLTRIM(SD2->D2_CF) $ '6102/6403' .AND. SD2->D2_GRUPO $ '542/0511/0541'
			_cCusto := '6221'
		//Se a D2_FILIAL for 0B E  D2_CF  = 5102 e D2_GRUPO igual 0213/0312/0313/0318/0317/0319/0454/0314, então Centro custo 6191
		ElseIf ALLTRIM(SD2->D2_CF) = '5102' .AND. SD2->D2_GRUPO $ '0213/0312/0313/0318/0317/0319/0454/0314'
			_cCusto := '6191'
		//Se a D2_FILIAL for 0B E  D2_CF  = 6102 e D2_GRUPO igual 0213/0312/0313/0318/0317/0319/0454/0314, então Centro custo 6291
		ElseIf ALLTRIM(SD2->D2_CF) = '6102' .AND. SD2->D2_GRUPO $ '0213/0312/0313/0318/0317/0319/0454/0314'
			_cCusto := '6291'
		EndIf
	EndIf
	
	//Alterar o LP 610 para que as vendas do produto 190590 ( QUIRERA) 
	//, independente da Filial seja contabilizado no centro de custo 6140
	//ticket 84143 - Antonio Domingos - 30/11/2022
	If AllTrim(SD2->D2_COD) == "190590"
		_cCusto := "6140"
	EndIf

	//@history ticket 85727 - 04/01/2023 - Fernando Macieira - Receitas eventuais - Empresa Adoro - CC
	If AllTrim(SD2->D2_CLIENTE) $ cInterCo .and. AllTrim(SD2->D2_LOCAL) $ ("02|48|99")
		_cCusto := "6140"
	EndIf
	
	//ticket 90947 - Antonio Domingos - 03/04/2023
	//Por favor incluir a regra: para a Filial 0B e Cliente 251256 contabilizar no centro de custo 6143
	If SD2->D2_FILIAL == '0B' .AND. SD2->D2_CLIENTE == "251256"
		_cCusto := "6143"
	EndIf

	//@history ticket 91149 - 05/04/2023 - Antonio Domingos - LP 610-001 SAFEGG
	If cEmpAnt == "09" .And. AllTrim(SD2->D2_CLIENTE) $ cInterCo .And. ALLTRIM(SD2->D2_CF) $ "5124"
		_cCusto := "6170"
	EndIf

	RestArea(aArea)
	// Fim do Tratamento - Cellvla

RETURN(_cCusto)

/*/{Protheus.doc} User Function LP610002
	Atendimento chamado 008221 solicitado pela Rosana
	@type  Function
	@author Sem autor
	@since Sem data
	@version 01
	@history Chamado 008221
/*/
User function LP610002()

	Local _cCusto := ""
	Local cInterCo := GetMV("MV_#GRPADO",,"016652|054283|031017") // 016652 (CERES) / 054283 (SAFEGG) / 031017 (RNX2)

	U_ADINF009P('LP610' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	//IF (ALLTRIM(SD2->D2_COD)=="100232" .OR. ALLTRIM(SD2->D2_COD)=="182898")
	If ALLTRIM(SD2->D2_GRUPO) $ "0511 0541 0542" //BUSCA POR SUBGRUPO// Alterado por Adriana em 18/03/15 - chamado 022330
	   IF SUBSTR(SD2->D2_CF,1,1)$"1,5"
		  _cCusto:="6120"
	   ELSEIF SUBSTR(SD2->D2_CF,1,1)$"2,6"                                  
		  _cCusto:="6220"	
	   ELSEIF SUBSTR(SD2->D2_CF,1,1)$"3,7"
		  _cCusto:="6920"
	   endif
	
	ELSEIF SUBSTR(SD2->D2_CF,1,1)$"1,5"
		_cCusto:="6110"
		
	ELSEIF SUBSTR(SD2->D2_CF,1,1)$"2,6"                                  
		_cCusto:="6210"
		
	ELSEIF SUBSTR(SD2->D2_CF,1,1)$"3,7"
		_cCusto:="6910"	
	ENDIF 
	
	IF ALLTRIM(SD2->D2_GRUPO) $ "0911 0912 0913" //BUSCA POR SUBGRUPO// Alterado por William em 16/02/16 - chamado 026894
	   IF SUBSTR(SD2->D2_CF,1,1)$"1,5"
		  _cCusto:="6130"
	   ELSEIF SUBSTR(SD2->D2_CF,1,1)$"2,6"                                  
		  _cCusto:="6230"	
	   ENDIF
	ENDIF 
	
	// Adicionado William Costa data 01/03/2016 chamado 027321
	//IF ALLTRIM(SD2->D2_GRUPO) $ "0921 0922 0923 0924 0925 0926 0927 " 
	IF ALLTRIM(SD2->D2_GRUPO) $ "0921 0922 0923 0924 0925 0926 0927 0928"  //fernando sigoli 17/08/2018 - Chamado: 043244
		_cCusto:="6180"
	ENDIF   
	
	// *** INICIO CHAMADO 034241 / 041751 - WILLIAM COSTA *** //
    IF ALLTRIM(SD2->D2_GRUPO) $ "9023/9024/9020/9030" .OR. ;
       ALLTRIM(SD2->D2_COD)   $ "800207" //CHAMADO WILLIAM COSTA 14/11/2018 - 044884 || OS 046044 || CONTROLADORIA || MONIK_MACEDO || 8956 || LP 610-002
	    _cCusto:="6140"
    ENDIF
    // *** FINAL CHAMADO 034241 / 041751 - WILLIAM COSTA *** //
	
	// *** INICIO CHAMADO 045972 - WILLIAM COSTA *** //
	//IF ALLTRIM(SD2->D2_COD) $ "113069/113071/113081/113093/142476"
	IF ALLTRIM(SD2->D2_COD) $ "113069/113071/113081/113093/142476/147679/148257/149104/149105/149106" // Chamado n. 056639 || OS 058088 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP610 - FWNM - 13/03/2020 //Chamado 058963 - Everson - 17/06/2020. //Chamado 060629 - Everson - 17/08/2020.
		IF SUBSTR(SD2->D2_CF,1,1)$"1,5"
		  _cCusto:="6190"
		ELSEIF SUBSTR(SD2->D2_CF,1,1)$"2,6"                                  
		  _cCusto:="6290"	
		ENDIF
	ENDIF
	// *** FINAL CHAMADO 045972 - WILLIAM COSTA *** //

	// Chamado n. 053445 || OS 054828 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || ACERTO LPS - fwnm - 19/11/2019
	If cEmpAnt == "01" .and. SD2->D2_FILIAL == "03"
		If Alltrim(SD2->D2_COD) == "391650"
			_cCusto := "6140"
		Endif
	EndIf

	// Chamado n. 060160 || OS 061652 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || 610 - PRODUTO 391129 - FWNM - 03/08/2020
	If AllTrim(SD2->D2_COD) == "391129" //(OLEO TRIDECANTER)
		If Left(AllTrim(SD2->D2_CF),1) == "5"
			_cCusto := "6140"
		ElseIf Left(AllTrim(SD2->D2_CF),1) == "6"
			_cCusto := "6240"
		EndIf
	EndIf
	//

	// Chamado n. 060154 || OS 061651 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP – 610 - FWNM - 03/08/2020
	If AllTrim(SD2->D2_GRUPO) == "9040"
		If Left(AllTrim(SD2->D2_CF),1) == "5"
			_cCusto := "6140"
		ElseIf Left(AllTrim(SD2->D2_CF),1) == "6"
			_cCusto := "6240"
		EndIf
	EndIf
	//

	// Chamado n. 060339 || OS 061850 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || LP610CTA - RNX2 - FWNM - 06/08/2020
	If AllTrim(cEmpAnt) == "07"

		If Left(AllTrim(SD2->D2_CF),1) == "5"
			_cCusto := "6142"
		ElseIf Left(AllTrim(SD2->D2_CF),1) == "6"
			_cCusto := "6242"
		EndIf

	EndIf
	//ticket 80450 - Antonio Domingos - 22/09/2022 - Inclusao de regra programas U_LP610CC(), U_610002() , U_LPCTHCC
	//U_LP610002()
	If SD2->D2_FILIAL == '0B'
		//Se a D2_FILIAL for 0B E  D2_CF  = 5102 e D2_GRUPO diferente de 0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314, então Centro custo 6111
		If ALLTRIM(SD2->D2_CF) == '5102' .AND. !(SD2->D2_GRUPO $ '0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314')
			_cCusto := '6111'
		//Se a D2_FILIAL for 0B E  D2_CF  = 6102 e D2_GRUPO diferente de 0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314, então Centro custo 6211
		ElseIf ALLTRIM(SD2->D2_CF) == '6102' .AND. !(SD2->D2_GRUPO $ '0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314')
			_cCusto := 6211
		//Se a D2_FILIAL for 0B E  D2_CF  = 5102//5403 e D2_GRUPO igual  542/0511/0541, então Centro custo 6121
		ElseIf ALLTRIM(SD2->D2_CF) $ '5102/5403' .AND. SD2->D2_GRUPO $ '542/0511/0541'
			_cCusto := 6121
		//Se a D2_FILIAL for 0B E  D2_CF  = 6102/6403 e D2_GRUPO igual  542/0511/0541, então Centro custo 6221
		ElseIf ALLTRIM(SD2->D2_CF) $ '6102/6403' .AND. SD2->D2_GRUPO $ '542/0511/0541'
			_cCusto := 6221
		//Se a D2_FILIAL for 0B E  D2_CF  = 5102 e D2_GRUPO igual 0213/0312/0313/0318/0317/0319/0454/0314, então Centro custo 6191
		ElseIf ALLTRIM(SD2->D2_CF) == '5102'  .AND. SD2->D2_GRUPO $ '0213/0312/0313/0318/0317/0319/0454/0314'
			_cCusto := 6191
		//Se a D2_FILIAL for 0B E  D2_CF  = 6102 e D2_GRUPO igual 0213/0312/0313/0318/0317/0319/0454/0314, então Centro custo 6291
		ElseIf ALLTRIM(SD2->D2_CF) == '6102'  .AND. SD2->D2_GRUPO $ '0213/0312/0313/0318/0317/0319/0454/0314'
			_cCusto := 6291
		EndIf
	EndIf

	//@history ticket 85727 - 04/01/2023 - Fernando Macieira - Receitas eventuais - Empresa Adoro - CC
	If AllTrim(SD2->D2_CLIENTE) $ cInterCo .and. AllTrim(SD2->D2_LOCAL) $ ("02|48|99")
		_cCusto := "6140"
	EndIf

	//ticket 90947 - Antonio Domingos - 04/04/2023.
	//Por favor incluir a regra: para a Filial 0B e Cliente 251256 contabilizar no centro de custo 6143
	If SD2->D2_FILIAL == '0B' .AND. SD2->D2_CLIENTE == "251256"
		_cCusto := "6143"
	EndIf

return(_cCusto)

/*/{Protheus.doc} User Function LP610CTA
	Execblock utilizado para retornar a conta contabil
	CHAMADO PELO LP 610 E PELO PONTO DE ENTRADA MSD2460
	@type Function
	@author Everaldo Casaroli
	@since 13/11/2007
	@version 01
	@history Chamado 
/*/
User Function LP610cta()

	Local _cConta     := "" //fwnmacieira 07/08/2018 
	Local aArea       := SD2->(GetArea()) // Incluido Cellvla 17-04-2014
	Local cLPCINT 	  := SuperGetMV("MV_#LPCINT",.F.,"097623/097658/014999")
	Local cLPEPCI     := SuperGetMV("MV_#LPEPCI",.F.,"100096/100097/100098/151296")
	//Local cCtaCliIntC := TABELA("Z@","A05",.F.)
    Local _cCtaRecEvInt := TABELA("Z@","RG8",.F.) //337110011  - Conta Receitas Eventuais Intercompany
	Local cInterCo    := GetMV("MV_#GRPADO",,"016652|054283|031017") // 016652 (CERES) / 054283 (SAFEGG) / 031017 (RNX2)

	//U_ADINF009P('LP610' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	// @history ticket 87941 - 06/02/2023 - Fernando Macieira - Receita de vendas e Serviços - Intercompany (Empresa SAFEGG)
	If AllTrim(FWCodEmp()) == "09"
		cInterCo := GetMV("MV_#GRPADO",,"027601|024288|025663|025652|014999|054051") // 027601 (FL02) / 024288 (FL01) / 025663 (FL04) / 025652 (F05) / 014999 (FL03) e 054051 (RNX2)
	EndIf
	
	IF ALLTRIM(SD2->D2_GRUPO) == "0911" //BUSCA POR SUBGRUPO

		If ALLTRIM(SD2->D2_CF)$"5101/5102/6101/6102/6107" 
			// @history ticket 85725 - 03/01/2023 - Fernando Macieira - Receita de vendas e Serviços - Intercompany (Empresa ADORO)
			If AllTrim(SD2->D2_CLIENTE) $ cInterCo
				If AllTrim(SD2->D2_CF) == "5124"
					_cConta := '311110005'
				Else
					_cConta := '311110004' 
				EndIf
			Else
				_cConta:=TABELA("Z@","R70",.F.) 
			EndIf			
			//
		ELSEIF ALLTRIM(SD2->D2_CF)$"7101/7102" 
			_cConta:=TABELA("Z@","R80",.F.) 
		Endif			

	Else	
	 
	 	IF SF4->F4_XCTB=="S".AND. SF4->F4_XTM$"S01,S14" .AND.  Alltrim(SD2->D2_CF)$'5102/6102' .AND. SD2->D2_FILIAL=='02' .AND. Alltrim(SD2->D2_TP) <> 'PA' //Alterado por Adriana para nao contabilizar legumes como sucata - chamado 028093
			
			// *** INICIO CHAMADO 041751 WILLIAM COSTA 24/05/2018 *** //
			// *** INICIO CHAMADO 055812 WILLIAM COSTA 19/02/2020 *** //
			
			IF Alltrim(SD2->D2_GRUPO) $ "9040" // Chamado n. 056634 || OS 058079 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || CHAMADO 055812 - FWNM - 13/03/2020
			
				_cConta:='337110001'
			
			ELSE
			
				If AllTrim(SD2->D2_CLIENTE) $ cInterCo
					// @history ticket 85725 - 03/01/2023 - Fernando Macieira - Receita de vendas e Serviços - Intercompany (Empresa ADORO)
					_cConta := '337110011' // @history ticket 85727 - 29/12/2022 - Receitas eventuais - Empresa Adoro
				Else
					_cConta := '337110003'
				EndIf
			
			ENDIF

			// *** FINAL CHAMADO 055812 WILLIAM COSTA 19/02/2020 *** //
			// *** FINAL CHAMADO 041751 WILLIAM COSTA 24/05/2018 *** //
			
		//ELSEIF SF4->F4_XCTB=="S".AND. SF4->F4_XTM$"S01,S14" .AND.  Alltrim(SD2->D2_CF)$'5102/6102' .AND. (SD2->D2_FILIAL=='03' .OR. SD2->D2_FILIAL=='04') // Chamado n. 050115 || OS 051421 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || INTEGRACAO KASSAI - FWNM - 05/08/2019 
		ELSEIF SF4->F4_XCTB=="S".AND. SF4->F4_XTM$"S01,S14" .AND.  Alltrim(SD2->D2_CF)$'5102/6102' .AND. (SD2->D2_FILIAL=='03' .OR. SD2->D2_FILIAL=='04' .or. SD2->D2_FILIAL=='05')

			If AllTrim(SD2->D2_CLIENTE) $ cInterCo
				_cConta := '337110011' // @history ticket 85727 - 29/12/2022 - Receitas eventuais - Empresa Adoro
			Else
				_cConta := '337110003'
			EndIf
	
		ELSEIF SF4->F4_XCTB=="S".AND. SF4->F4_XTM$"S01,S14"
			// @history ticket 85725 - 03/01/2023 - Fernando Macieira - Receita de vendas e Serviços - Intercompany (Empresa ADORO)
			If AllTrim(SD2->D2_CLIENTE) $ cInterCo
				If AllTrim(SD2->D2_CF) == "5124"
					_cConta := '311110005'
				Else
					_cConta := '311110004' 
				EndIf
			Else
				_cConta:=TABELA("Z@","R00",.F.)
			EndIf			
		
		ELSEIF SF4->F4_XCTB=="S".AND. SF4->F4_XTM$"S02"
			_cConta:=TABELA("Z@","R10",.F.)
		                               
		ELSEIF SF4->F4_XCTB=="S".AND. SF4->F4_XTM$"S03"
			_cConta:=TABELA("Z@","R20",.F.)
		
		ELSEIF SF4->F4_XCTB=="S".AND. SF4->F4_XTM$"S04"

			If AllTrim(SD2->D2_CLIENTE) $ cInterCo
				_cConta := '337110011' // @history ticket 85727 - 29/12/2022 - Receitas eventuais - Empresa Adoro
			Else
				_cConta := '337110003'
			EndIf

		Endif  
			
	ENDIF
	 
 	// Inclusão do Tratamento do CFOP de Venda de Entrega Futura  (CELLVLA) 17-04-2014
	IF ALLTRIM(SD2->D2_CF)$"5922/6922" // Inclusão do Tratamento do CFOP de Venda de Entrega Futura  
		_cConta:= "111210003"
    ENDIF
    
    // *** INICIO CHAMADO 034241 - WILLIAM COSTA *** //
    IF ALLTRIM(SD2->D2_GRUPO) $ "9023/9024" .AND. ALLTRIM(SD2->D2_CF)$"5102/6102" 

		If AllTrim(SD2->D2_CLIENTE) $ cInterCo
			_cConta := '337110011' // @history ticket 85727 - 29/12/2022 - Receitas eventuais - Empresa Adoro
		Else
		    _cConta := "337110003"
		EndIf

    ENDIF
    // *** FINAL CHAMADO 034241 - WILLIAM COSTA *** //
    
	//@history Ticket 69333 	- Leonardo P. Monteiro - 	Compatibilização de estercos (Grp. 9037) na conta 337110003 e Centro de Custo 6140.
	IF ALLTRIM(SD2->D2_GRUPO) $ "9037" .AND. ALLTRIM(SD2->D2_CF)$"5102/6102" 

		If AllTrim(SD2->D2_CLIENTE) $ cInterCo
			_cConta := '337110011' // @history ticket 85727 - 29/12/2022 - Receitas eventuais - Empresa Adoro
		Else
			_cConta := "337110003"
		EndIf

    ENDIF

    // *** INICIO CHAMADO 034750 - WILLIAM COSTA *** //
    IF ALLTRIM(SD2->D2_GRUPO) $ "9040" // Chamado n. 056634 || OS 058079 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || CHAMADO 055812 - FWNM - 13/03/2020
	    _cConta:= "337110001"
    ENDIF                      
    // *** FINAL CHAMADO 034750 - WILLIAM COSTA *** //

	// Chamado n. 060160 || OS 061652 || CONTROLADORIA || TAMIRES_SERAFIM || 8503 || 610 - PRODUTO 391129 - FWNM - 03/08/2020
	If AllTrim(SD2->D2_COD) == "391129" //(OLEO TRIDECANTER)

		If AllTrim(SD2->D2_CLIENTE) $ cInterCo
			_cConta := '337110011' // @history ticket 85727 - 29/12/2022 - Receitas eventuais - Empresa Adoro
		Else
			_cConta := "337110003"
		EndIf

	EndIf
	//

	// Chamado n. 052561 || OS 053911 || CONTROLADORIA || FELIPE_CAPOVILA || 8464 || ALTERACAO LPS - FWNM - 14/10/2019
	/*
	\"EMPRESA RNX2\"
	POR FAVOR, ALTERAR OS LPS CONFORME ABAIXO :
	LP 610/001 - CFOP 5122 ( PRODUTOS 384837 E 384838 ) CONTABILIZAR A CONTA CREDITO 411120001 RECEITA VENDA IMOBILIZADO
	LP 610/001 - CFOP 5122 ( PRODUTOS 384413 ) CONTABILIZAR A CONTA CREDITO 311110001 MERCADO INTERNO
	*/
	If AllTrim(cEmpAnt) == "07"

		_cConta := "311110001"
		
		If Right(AllTrim(SD2->D2_CF),3) == "551"
			_cConta := "411120001"
		ElseIf Right(AllTrim(SD2->D2_CF),3) == "102"

			If AllTrim(SD2->D2_CLIENTE) $ cInterCo
				_cConta := '337110011' // @history ticket 85727 - 29/12/2022 - Receitas eventuais - Empresa Adoro
			Else
				_cConta := "337110003"
			EndIf

		EndIf

	EndIf
	//
	

	//@history ticket 483 - FWNM - 26/08/2020 - CONTROLADORIA || DRIELE_LEME || 8507 || AJUSTE LP 610-001
	If AllTrim(cEmpAnt) == "09"
		
		_cConta := "311110002"

		If AllTrim(SD2->D2_COD) == "386914"
			_cConta := "311110001"
		
		ElseIf AllTrim(SD2->D2_COD) == "384413"
			_cConta := "311110001"

		ElseIf AllTrim(SD2->D2_COD) == "391650"

			If AllTrim(SD2->D2_CLIENTE) $ cInterCo
				_cConta := '337110011' // @history ticket 85727 - 29/12/2022 - Receitas eventuais - Empresa Adoro
			Else
				_cConta := "337110003"
			EndIf
		EndIf
		//@history ticket 91149 - 05/04/2023 - Antonio Domingos - LP 610-001 SAFEGG
		If  AllTrim(SD2->D2_CLIENTE) $ cInterCo 
			_cConta := '311110004'
			If ALLTRIM(SD2->D2_CF) $ "5124"
				_cConta := '311110005'
			EndIf
		EndIf

	EndIf
	//

	// @history ticket    9226 - Fernando Maciei - 25/02/2021 - Lançamento Padrão 610-001 - abertura/alteração
	// LP610CTA= Se a CFOP for igual a 5124 ou 6124  conta: 311110002 – Filial 04
	If cFilAnt == "04" .and. Right(AllTrim(SD2->D2_CF),3) == "124"
		_cConta := "311110002"
	EndIf

	// @history ticket   16175 - Fernando Maciei - 30/06/2021 - Alteração LP -Receita serviço Ceres
	If AllTrim(cEmpAnt) == "02" //CERES

		// Se CFOP "5124/6124"; produto "151296" = CONTA 311110002.
		If Right(AllTrim(SD2->D2_CF),3) == "124" .and. AllTrim(SD2->D2_COD) == "151296"
			_cConta := "311110002"
		EndIf
		// @history ticket   78559 - Antonio Domingos - 24/08/2022 - Alteração de LP dos programas internos das regras
		// @history ticket   81819 - Antonio Domingos - 17/10/2022 - LP de Receitas Eventuais/ Cliente - Empresa CERES
		//cLPCINT 	   := SuperGetMV("MV_#LPCINT",.F.,"097623/097658/014999") //Clientes intercompany
		//cLPEPCI      := SuperGetMV("MV_#LPEPCI",.F.,"100096/100097/100098/151296") //Exceção de codigos de produtos para Receitas Eventuais Intercompany
		//_cCtaRecEvInt := TABELA("Z@","RG8",.F.) //337110011  - Conta Receitas Eventuais Intercompany
		If SD2->D2_CLIENTE $ cLPCINT //If SD2->D2_CLIENTE $ "097623/097658/014999"
			_cConta := "311110004"
			If SUBSTR(SD2->D2_CF,1,4) == "5124"
				_cConta := "311110005"
			EndIf
			If !ALLTRIM(SD2->D2_COD) $ cLPEPCI //Exceção de codigos de produtos
				_cConta := _cCtaRecEvInt
			EndIf
		EndIf
		//

	EndIf
	//

	//Everson - 07/01/2022. Chamado 66325.
	If cEmpAnt == "01" .And. cFilAnt == "04" .And.; 
	   AllTrim(cValToChar(SD2->D2_CF)) == "5101" .And.; 
	   AllTrim(cValToChar(SD2->D2_COD)) == "391650"
		
			If AllTrim(SD2->D2_CLIENTE) $ cInterCo
				_cConta := '337110011' // @history ticket 85727 - 29/12/2022 - Receitas eventuais - Empresa Adoro
			Else
				_cConta := "337110003"
			EndIf

	EndIf

	// @history ticket 85725 - 03/01/2023 - Fernando Macieira - Receita de vendas e Serviços - Intercompany (Empresa ADORO)
	/*
	If AllTrim(SD2->D2_CLIENTE) $ cInterCo
		If AllTrim(SD2->D2_CF) == "5124"
			_cConta := '311110005'
		Else
			_cConta := '311110004' 
		EndIf
	EndIf
	*/

	RestArea(aArea) 
    // Fim do Tratamento (CELLVLA)

RETURN(_cConta)                                           

/*/{Protheus.doc} User Function LP610CD4
	Execblock utilizado para retornar a conta debito no LP 610-004
	@type Function
	@author Ana Helena
	@since 09/05/2011
	@version 01
	@history Chamado 
/*/
User Function LP610cd4                  

	Local _cConta := "" 

	U_ADINF009P('LP610' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	//IIF(ALLTRIM(SD2->D2_CF)$"5102/6102/5252",TABELA("Z@","R05",.F.),TABELA("Z@","R03",.F.))
		     
	IF ALLTRIM(SD2->D2_GRUPO) == "0911" //BUSCA POR SUBGRUPO
		If ALLTRIM(SD2->D2_CF)$"5101/5102/6101/6102/5922" 
			_cConta := TABELA("Z@","R03",.F.)
		Endif			
	Else  
	
		If ALLTRIM(SD2->D2_CF)$"5102/6102/5252"
			_cConta := TABELA("Z@","R05",.F.)
		Else  
			_cConta := TABELA("Z@","R03",.F.)
		Endif	 
		
	ENDIF

RETURN(_cConta)  

/*/{Protheus.doc} User Function LP610CD5
	Execblock utilizado para retornar a conta debito no LP 610-005
	@type Function
	@author Ana Helena
	@since 09/05/2011
	@version 01
	@history Chamado 
/*/
User Function LP610cd5                  

	Local _cConta := ""   
	
	U_ADINF009P('LP610' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	     
	//IIF(ALLTRIM(SD2->D2_CF)$"5102/6102/5252",TABELA("Z@","R06",.F.),TABELA("Z@","R04",.F.))
		     
	IF ALLTRIM(SD2->D2_GRUPO) == "0911" //BUSCA POR SUBGRUPO
		If ALLTRIM(SD2->D2_CF)$"5101/5102/6101/6102/5922" 
			_cConta := TABELA("Z@","R04",.F.)
		Endif			
	Else  
	
		If ALLTRIM(SD2->D2_CF)$"5102/6102/5252"
			_cConta := TABELA("Z@","R06",.F.)
		Else  
			_cConta := TABELA("Z@","R04",.F.)
		Endif	 
		
	ENDIF

RETURN(_cConta)  

/*/{Protheus.doc} User Function LP610CLV
	Execblock utilizado para retornar a classe de valor deb/cred no LP 610, sequencias 002, 004 e 005
	@type Function
	@author Ana Helena
	@since 09/05/2011
	@version 01
	@history Chamado 
/*/
User Function LP610clv                  

	Local _cClv := ""   
	
	U_ADINF009P('LP610' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	                                                                                             
	//LP610-002:
	//IIF(ALLTRIM(SD2->D2_CF)=="5252","120",SUBSTR(SB1->B1_XGRUPO,2,1)+SA1->A1_SATIV1)
	     
	//IIF(ALLTRIM(SD2->D2_CF)$"5102/6102/5252","",SUBSTR(SB1->B1_XGRUPO,2,1)+SA1->A1_SATIV1)
		     
	IF ALLTRIM(SD2->D2_GRUPO) == "0911" //BUSCA POR SUBGRUPO
		If ALLTRIM(SD2->D2_CF)$"5101/5102/6101/6102/5922" 
			_cClv := SUBSTR(SB1->B1_XGRUPO,2,1)+SA1->A1_SATIV1
		Endif			
	Else  
	
		If ALLTRIM(SD2->D2_CF)$"5252"
			_cClv := ""
		Else  
			_cClv := SUBSTR(SB1->B1_XGRUPO,2,1)+SA1->A1_SATIV1
		Endif	 
		
	ENDIF

RETURN(_cClv)


#include "protheus.ch"

/*/{Protheus.doc} User Function LP610CC
	Execblock utilizado para retornar o centro de custo
	@type  Function
	@author Everaldo Casaroli
	@since 11/11/2007
	@version 01
	@history ticket 84143 - Antonio Domingos - 30/11/2022 - Alterar lp 610-001 - incl - fat- rec clientes - produto 190590
/*/
User Function LP610ITC()

	Local _cItemC := ""   
	Local _cMVPIC114 := SUPERGETMV("MV_#PIC114",.F.,"190590") //PRODUTOS COM ITEM DA CONTA 114 INDEPENDENTE DA FILIAL
	
	If cEmpAnt == '01' .AND. ALLTRIM(SD2->D2_COD) $ _cMVPIC114
		_cItemC := "114"
	Else
		_cItemC := IIF(SD2->D2_FILIAL $"01/02","121",IIF(SD2->D2_FILIAL $"03/05",U_ITEMCTA(),IIF(SD2->D2_FILIAL =="07","123",IIF(SD2->D2_FILIAL=="08","115",IIF(SD2->D2_FILIAL=="09","116",IIF(SD2->D2_FILIAL=="0B","125",IIF(SD2->D2_FILIAL=="0A","113",112)))))))                         
	EndIf

Return(_cItemC)
