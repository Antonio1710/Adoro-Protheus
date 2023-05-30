#INCLUDE "PROTHEUS.CH" 
#INCLUDE "topconn.CH" 

/*/{Protheus.doc} User Function nomeFunction
	utilizado para retornar a conta contabil debito
	@type  Function
	@author WILLIAM COSTA
	@since 19/01/2017
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 86120 - 05/01/2023 - FERNANDO MACIEIRA - Devolução de vendas - Intercompany (Empresa Adoro)
	@history ticket 87944 - 06/02/2023 - FERNANDO MACIEIRA - Devolução de vendas - Intercompany (Empresa SAFEGG)
/*/
User Function LP640001(cParam)

	Local cConta       := ''
	Local cCentroCusto := ''
	Local cRetorno     := ''
	Local aArea        := SD1->(GetArea()) 
	Local cInterCo     := GetMV("MV_#GRPADO",,"016652|054283|031017") // 016652 (CERES) / 054283 (SAFEGG) / 031017 (RNX2)
	
	// @history ticket 87941 - 06/02/2023 - Fernando Macieira - Receita de vendas e Serviços - Intercompany (Empresa SAFEGG)
	If AllTrim(FWCodEmp()) == "09"
		cInterCo := GetMV("MV_#GRPADO",,"027601|024288|025663|025652|014999|054051") // 027601 (FL02) / 024288 (FL01) / 025663 (FL04) / 025652 (F05) / 014999 (FL03) e 054051 (RNX2)
	EndIf
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	IF cParam == 'CONTA'

		IF SF4->F4_XCTB         == "S"       .AND. ;
		   SF4->F4_XTM           $ "E18/E08" .AND. ;
		   SD1->D1_TIPO         == "D"       .AND. ;
		   !(SA1->A1_EST        == "EX")     .AND. ;
		   ALLTRIM(SD1->D1_TES) == "218"
		
			cConta   := '311220004'
			
		// inicio chamado 034919		
		ELSEIF SF4->F4_XCTB         == "S"       .AND. ;
		       SF4->F4_XTM           $ "E18/E08" .AND. ;
		       SD1->D1_TIPO         == "D"       .AND. ;
		       !(SA1->A1_EST        == "EX")     .AND. ;
		       ALLTRIM(SD1->D1_TES) == "02D"
		
			cConta   := '311220004'					
			
		ELSEIF SF4->F4_XCTB         == "S"       .AND. ;
		       SF4->F4_XTM           $ "E18/E08" .AND. ;
		       SD1->D1_TIPO         == "D"       .AND. ;
		       !(SA1->A1_EST        == "EX")     .AND. ;
		       !ALLTRIM(SD1->D1_CF) == "2503"    
		
			// @history ticket 86120 - 05/01/2023 - FERNANDO MACIEIRA - Devolução de vendas - Intercompany (Empresa Adoro)
			If AllTrim(SD1->D1_FORNECE) $ cInterCo
				cConta := "311220007"
			Else
				cConta := TABELA("Z@","R75",.F.)
			EndIf
		
		// inicio chamado 034809	
		ELSEIF SF4->F4_XCTB         == "S"   .AND. ;
		       SF4->F4_XTM           $ "E19" .AND. ;
		       SD1->D1_TIPO         == "D"   .AND. ;
		       !(SA1->A1_EST        == "EX") .AND. ;
		       ALLTRIM(SD1->D1_TES)  $ "148/03J" //WILLIAM COSTA - CHAMADO 041393 02/05/2018
		
			cConta   := '411120003'	  
			
		ELSE	
		
			cConta   := TABELA("Z@","R76",.F.)
			
		ENDIF	
		
		cRetorno := cConta
		
	ELSE
	
		IF SD1->D1_GRUPO$"0921/0922/0923/0924/0925/0926/0927"
		
			cCentroCusto:= "6180"  
			
		ELSEIF SD1->D1_GRUPO$"0542/0511/0541" .AND. ALLTRIM(SD1->D1_CF)$"1410/1210/1910" //adicionado cfop 1910 - fernando sigoli 18/12/2017 Chamado: 038715
		 
			cCentroCusto:= "6120"
			
		ELSEIF SD1->D1_GRUPO$"0542/0511/0541" .AND. ALLTRIM(SD1->D1_CF)$"2410/2201/2910" //adicionado cfop 2910 - fernando sigoli 18/12/2017 Chamado: 038715	
		
			cCentroCusto:= "6220" 
			
		ELSEIF SD1->D1_GRUPO$"0911/0912/0913" .AND. SUBSTR(ALLTRIM(SD1->D1_CF),1,1) == '1'	
		
			cCentroCusto:= "6130"
			
		ELSEIF SD1->D1_GRUPO$"0911/0912/0913" .AND. SUBSTR(ALLTRIM(SD1->D1_CF),1,1) == '2'	
		
			cCentroCusto:= "6230"
			
		ELSEIF SD1->D1_GRUPO$"9041" .AND. ALLTRIM(SD1->D1_TES) == '148' .AND. ALLTRIM(SD1->D1_FILIAL) == '02'	
		
			cCentroCusto:= "5201"		
			
		ELSEIF SD1->D1_GRUPO$"9041" .AND. ALLTRIM(SD1->D1_TES) == '148' .AND. ALLTRIM(SD1->D1_FILIAL) == '03'	
		
			cCentroCusto:= "5141"			
			
		ELSEIF SD1->D1_GRUPO$"9041" .AND. ALLTRIM(SD1->D1_TES) == '148' .AND. ALLTRIM(SD1->D1_FILIAL) == '04'	
		
			cCentroCusto:= "5121"				
			
		ELSEIF SUBSTR(ALLTRIM(SD1->D1_CF),1,1) == '2'
		
			cCentroCusto:= "6210"
		
		ElseIf AllTrim(SD1->D1_GRUPO) $ "0543" // Chamado n. 051146 || OS 052499 || CONTROLADORIA || THIAGO || 8439 || LP 640 - FWNM - 19/08/2019
		
			cCentroCusto:= "6190"  

		ELSE	  
		
			cCentroCusto:= "6110"
			
		ENDIF
		
		cRetorno     := cCentroCusto
	
    ENDIF
   
	RestArea(aArea) 
    
RETURN(cRetorno)                                           
