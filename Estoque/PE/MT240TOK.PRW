#include 'rwmake.ch'      

/*/{Protheus.doc} User Function MT240TOK
	(long_description)
	@type  Function
	@author Wellington Santos
	@since 17/01/2007
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history Chamado 051482 - William Costa    - 03/09/2019 - OS 052798 || ALMOXARIFADO || EDUARDO || 8429 || BAIXAR ESTOQUE - Identificado que enquanto nao fecha o estoque fica produtos e enderecos com saldo zero na tabela SBF isso estava atrapalhando a query que mostrava saldo zerado no retorno.
	@history Chamado 054816 - FWNM             - 09/01/2020 - OS 056218 || ALMOXARIFADO || CRISTIANO || 3547 || BAIXA REQUISICAO-RNX
	@history Chamado 055729 - FERNANDO SIGOLI  - 10/02/2020 - OS 057128 || CONTROLADORIA || FRED_SANTOS || 8947 || ESTOQUE NEGATIVO  
	@history Ticket 69574   - Abel Babini      - 25/04/2022 - Projeto FAI
	@history ticket 75276   - Antonio Domingos - 30/06/2022 - Transferencia - Desvincular produto do endere�o
	@history ticket TI - Antonio Domingos - 23/05/2023 - Revis�o Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 25/05/2023 - Revis�o Ajuste Nova Empresa
/*/

User Function MT240TOK

	Local _lTOk         := .T.   
	Local nEst	        := 0
	//Local nSomaEndereco := 0
	Local cB1_Localiz   := ''
	Local cBE_Localiz   := ''
	Local cBZ_Localiz   := '' 
	Local cBF_Localiz   := '' 
	Local nSaldoSB2     := 0
	Local nSaldoSBF     := 0  
	//Local cFilSF:= GetMv("MV_#SFFIL",,"02|0B|") 	//Ticket 69574   - Abel Babini          - 25/04/2022 - Projeto FAI
	//Local cEmpSF:= GetMv("MV_#SFEMP",,"01|") 		//Ticket 69574   - Abel Babini          - 25/04/2022 - Projeto FAI
	Private _cEmpFL3 := SuperGetMv("MV_#EMPFL3",.F.,"0102/010B/1301") //Codigos de Empresas+Filiais Ativas Grupo 3 //ticket TI - Antonio Domingos - 20/05/2023

	If SubStr(M->D3_CC,1,1) = '9'
		If Empty(M->D3_PROJETO)
			MsgAlert('INFORME O PROJETO !!!','Aten��o')
			_lTOk := .F.
		EndIf
	EndIf                                                
	
	//��������������������������������������������������������������������������
	//�INICIO - TRATAMENTO VALIDA��O SALDO MOVIMENTA��O INTERNA 10/12/2015 - KF�
	//��������������������������������������������������������������������������
	//If cFilAnt $ '02|03' .and. alltrim(M->D3_LOCAL) $ '02|04' // Chamado n. 054816 || OS 056218 || ALMOXARIFADO || CRISTIANO || 3547 || BAIXA REQUISICAO-RNX - FWNM - 09/01/2020
	
	If Alltrim(M->D3_LOCAL) $ '02|04|09|29'  //Chamado n. 055729 || OS 057128 || CONTROLADORIA || FRED_SANTOS || 8947 || ESTOQUE NEGATIVO - Fernando Sigoli 10/02/2020  
			
		dbSelectArea("SB2")
		dbSeek(xFilial("SB2")+M->D3_COD+M->D3_LOCAL)
		//IF ALLTRIM(M->D3_TM) == '001'
		If Left(ALLTRIM(M->D3_TM),1) <= "4"
			nEst:=SaldoMov(Nil,Nil,Nil,.T.,Nil,Nil,Nil,dDatabase) + M->D3_QUANT
		ELSE
			nEst:=SaldoMov(Nil,Nil,Nil,.T.,Nil,Nil,Nil,dDatabase) - M->D3_QUANT
		ENDIF	
			
		If nEst< 0 
			MsgInfo("Opera��o n�o permitida! Produto ficara com estoque negativo!" + " ["+ alltrim(M->D3_COD)+"/"+ Alltrim(M->D3_LOCAL) + "]" ,"[MT240TOK-01] - Estoque Negativo")
		   _lTOk := .F.
		EndIf
	EndIf
	
	//�����������������������������������������������������������������������
	//�FIM - TRATAMENTO VALIDA��O SALDO MOVIMENTA��O INTERNA 10/12/2015 - KF�
	//�����������������������������������������������������������������������
	
	// *** INICIO CHAMADO 036032  WILLIAM COSTA*** //
	//IF Alltrim(cEmpAnt) $ cEmpSF .AND. ;
	   //Alltrim(cFilAnt) $ cFilSF .AND. ;
	   If Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ _cEmpFL3 .AND.; //ticket TI - Antonio Domingos - 20/05/2023 - ticket TI - Antonio Domingos - 25/05/2023
	   (IsInCallStack('MATA185')   == .T.  .OR.  ;
	    IsInCallStack('ADEST006P') == .T.)
		
	    SqlBuscaProduto(M->D3_COD,M->D3_LOCAL,M->D3_LOCALIZ)
	    
	    While TRD->(!EOF())
	                  
            cB1_Localiz := TRD->B1_LOCALIZ
            cBF_Localiz := TRD->BF_LOCALIZ
            cBZ_Localiz := TRD->BZ_LOCALIZ  
           
        	TRD->(dbSkip())
		ENDDO
		TRD->(dbCloseArea())
		
		IF ALLTRIM(cB1_Localiz)   == 'S' .AND. ALLTRIM(M->D3_LOCALIZ) == ''
		   //ALLTRIM(cBE_Localiz)  <> ''  .AND. ;
		    
			MsgAlert("Ol� " + Alltrim(cusername) + ", N�o � Possivel fazer a baixa, informe o endereco do produto:  " + M->D3_COD, "MT240TOK - Ponto de Entrada - 1")
		
			_lTOk := .F.
			
		ENDIF
		
		IF ALLTRIM(cB1_Localiz)  == 'S'  .AND. ;
		   (ALLTRIM(cBZ_Localiz) == ''    .OR. ;
		   ALLTRIM(cBZ_Localiz)  == 'N') 
		   
		    MsgAlert("Ol� " + Alltrim(cusername) + ", N�o � Possivel fazer a baixa, o produto:  " + M->D3_COD + "n�o esta marcado com endere�o igual a sim na tabela SBZ", "MT240TOK - Ponto de Entrada - 2")
		
			_lTOk := .F.
			
		ENDIF
		/* ticket 75726 - 01/07/2022 - Antonio Domingos - Retirado trava por endere�o
		IF ALLTRIM(cB1_Localiz)   == 'S' .AND. ;
		   ALLTRIM(cBE_Localiz)   <> ''  .AND. ;
		   ALLTRIM(M->D3_LOCALIZ) <> ''  .AND. ;
		   ALLTRIM(M->D3_LOCALIZ) <> ALLTRIM(cBE_Localiz)
		
			MsgAlert("Ol� " + Alltrim(cusername) + ", N�o � Possivel fazer a baixa, o endereco do produto:  " + M->D3_COD + "n�o corresponde com o cadastro de Endere�os", "MT240TOK - Ponto de Entrada - 3")
		
			_lTOk := .F.
			
		ENDIF
		*/
		IF ALLTRIM(cB1_Localiz)   == 'S' .AND. ;
		   ALLTRIM(cBF_Localiz)   <> ''  .AND. ;
		   ALLTRIM(M->D3_LOCALIZ) <> ''  .AND. ;
		   ALLTRIM(M->D3_LOCALIZ) == ALLTRIM(cBE_Localiz)
		   
		   SqlSaldoProduto(M->D3_COD,M->D3_LOCAL,M->D3_LOCALIZ)
	    
		    While TRE->(!EOF())
		                  
		    	cBF_Localiz   := TRE->BF_LOCALIZ
		    	nSaldoSB2     := TRE->B2_QATU
		    	nSaldoSBF     := TRE->BF_QUANT 
	           
	        	TRE->(dbSkip())
			ENDDO
			TRE->(dbCloseArea())
			
			IF nSaldoSB2 <> nSaldoSBF
		
				MsgAlert("Ol� " + Alltrim(cusername) + ", N�o � Possivel fazer a baixa, o Saldo do Produto:  " + M->D3_COD + "est� diferente entre SB2 e SBF, SB2:" + CVALTOCHAR(nSaldoSB2) + " SBF:" + CVALTOCHAR(nSaldoSBF), "MT240TOK - Ponto de Entrada - 4")
		
				_lTOk := .F.
				
			ENDIF
			
			IF ALLTRIM(cBF_Localiz) <> ALLTRIM(cBE_Localiz)
			
				MsgAlert("Ol� " + Alltrim(cusername) + ", N�o � Possivel fazer a baixa, o endereco do produto:  " + M->D3_COD + "n�o corresponde com o Saldo de Localiza��o SBF", "MT240TOK - Ponto de Entrada - 5")
			
				_lTOk := .F.
				
			ENDIF	
		ENDIF
	ENDIF
	// *** FINAL CHAMADO 036032  WILLIAM COSTA*** //

Return( _lTOk)

/*/{Protheus.doc} Static Function SqlBuscaProduto
	(long_description)
	@type  Static Function
	@author William Costa
	@since 03/09/2019
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function SqlBuscaProduto(cCodProd,cLocal,cLocaliz)

	LOCAL  cFil := xFilial("SD3")

	BeginSQL Alias "TRD"
			%NoPARSER%  
			   SELECT B1_LOCALIZ,BE_CODPRO,BE_LOCALIZ,BZ_LOCALIZ,BF_LOCALIZ
			     FROM %Table:SB1% WITH (NOLOCK)
			LEFT JOIN %Table:SBE% WITH (NOLOCK)
			       ON BE_FILIAL               = %EXP:cFil%
			      AND BE_CODPRO               = B1_COD
			      AND BE_LOCAL                = %EXP:cLocal% 
			      AND BE_LOCALIZ              = %EXP:cLocaliz% 
				  AND %Table:SBE%.D_E_L_E_T_ <> '*'
			LEFT JOIN %Table:SBZ% WITH (NOLOCK)
				   ON BZ_FILIAL               = '02'
				  AND BZ_COD                  = B1_COD
				  AND %Table:SBZ%.D_E_L_E_T_ <> '*'
				  AND %Table:SBE%.D_E_L_E_T_ <> '*'
			LEFT JOIN %Table:SBF% SBF WITH (NOLOCK)
					ON BF_FILIAL   = %EXP:cFil%
					AND BF_PRODUTO = B1_COD
					AND BF_LOCAL   = %EXP:cLocal% 
					AND BF_LOCALIZ = %EXP:cLocaliz% 
					AND SBF.%NotDel%  
			    WHERE B1_COD                  = %EXP:cCodProd% 
			      AND %Table:SB1%.D_E_L_E_T_ <> '*'
	EndSQl             
	If TRD->(!Eof()) .AND. Empty(TRD->BE_CODPRO)
		TRD->(dbCloseArea())
		BeginSQL Alias "TRD"
				%NoPARSER%  
				SELECT B1_LOCALIZ,BZ_LOCALIZ,BF_LOCALIZ
					FROM %Table:SB1% SB1 WITH (NOLOCK)
				LEFT JOIN %Table:SBF% SBF WITH (NOLOCK)
					ON BF_FILIAL   = %EXP:cFil%
					AND BF_PRODUTO = B1_COD
					AND BF_LOCAL   = %EXP:cLocal% 
					AND BF_LOCALIZ = %EXP:cLocaliz% 
					AND SBF.%NotDel% 
				LEFT JOIN %Table:SBZ% SBZ WITH (NOLOCK)
					ON BZ_FILIAL               = '02'
					AND BZ_COD                  = B1_COD
					AND SBZ.%NotDel% 
					WHERE B1_COD = %EXP:cCodProd% 
					AND SB1.%NotDel% 
		EndSQl             
	EndIf
RETURN(NIL)

/*/{Protheus.doc} Static Function SqlBuscaProduto
	(long_description)
	@type  Static Function
	@author William Costa
	@since 03/09/2019
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function SqlSaldoProduto(cCodProd,cLocal,cLocaliz)

	LOCAL  cFil := xFilial("SD3")

	BeginSQL Alias "TRE"
			%NoPARSER%  
			    SELECT B2_COD,BF_PRODUTO,BF_LOCAL,SUM(BF_QUANT) AS BF_QUANT,,B2_QATU
				  FROM %Table:SB2%
			  LEFT JOIN %Table:SBF%
				     ON BF_FILIAL                = B2_FILIAL
				    AND BF_LOCAL                 = B2_LOCAL
				    AND BF_PRODUTO               = B2_COD
				    AND BF_QUANT                 > 0 // WILLIAM COSTA 03/09/2019 - CHAMADO 051482 || OS 052798 || ALMOXARIFADO || EDUARDO || 8429 || BAIXAR ESTOQUE      
				    AND %Table:SBF%.D_E_L_E_T_  <> '*'
				  WHERE B2_FILIAL               = %EXP:cFil%
				    AND B2_LOCAL                = %EXP:cLocal%
				    AND B2_COD                  = %EXP:cCodProd%
				    AND %Table:SB2%.D_E_L_E_T_ <> '*'
					GROUP BY B2_COD,BF_PRODUTO,BF_LOCAL,B2_QATU //ANTONIO DOMINGOS - TICKET 75276 || ALMOXARIFADO || EDUARDO || 8429 || TRANSFERENCIA       
				    AND %Table:SBF%.D_E_L_E_T_  <> '*'
	EndSQl             

RETURN(NIL)
