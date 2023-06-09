#INCLUDE "PROTHEUS.CH" 

STATIC aComboTipoSA := {}
STATIC cComboTipoSa := Space(1) 
STATIC nComboTipoSa := 1
STATIC oComboTipoSa := Nil

/*/{Protheus.doc} User Function MT105SCR
	LOCALIZA��O  : Nas rotinas de inclus�o, altera��o, visualiza��o e exclus�o das Solicita��es ao Almoxarifado. 
	EM QUE PONTO : Encontra-se dentro da rotina que monta a dialog da Solicita��o ao Almoxarifado; 
	Disponibiliza como parametro o Objeto da dialog; 'oDlg' para manipula��o do usuario e a op��o selecionada 
	(inclus�o/ altera��o/visualiza��o/ exclus�o )
	Utilizacao: Cria um campo Combo Box no cabecalho da solicitacao ao armazem no do campo TIPO, 
	verifica se e de baixa normal ou transferencia entre armazens 
	@type  Function
	@author William Costa
	@since 08/08/2016
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history chamado 055188 - FWNM    - 17/02/2020 - OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA
	@history ticket  35699  - SIGOLI  - 01/10/2021 - Rotina estava desposicionada na exclusao da solciita��o por item
	@history ticket  63372  - Leonardo P. Monteiro  - 05/11/2021 - Posicionamento do campo 'Tipo' fora de posi��o no cabe�alho quando selecionada a op��o de visualiza��o. 
/*/
User Function MT105SCR() 
    
    Local aArea 	:= GetArea()
	Local oDlg      := ParamIxb[1]
	Local nPosicao  := ParamIxb[2]
	Local oSize 
	Local oSize2  
	Local cComboTxt   := "Transf Manutencao"
	Local cUsrManut := GetMV("MV_#MANUSU",,"001428") 
	
	cComboTipoSa := Space(1) 
	nComboTipoSa := 1
	oComboTipoSa := Nil
	
	
	IF __cUserID $ GETMV("MV_#USUTRA") .or. __cUserID $ cUsrManut 
	
		oSize := FwDefSize():New()             
		oSize:AddObject( "CABECALHO",  100, 5, .T., .T. ) // Totalmente dimensionavel
		oSize:AddObject( "GETDADOS" ,  100, 85, .T., .T. ) // Totalmente dimensionavel 
		
		oSize:lProp 	:= .T. // Proporcional             
		oSize:aMargins 	:= { 3, 3, 3, 3 } // Espaco ao lado dos objetos 0, entre eles 3 
		
		oSize:Process() // Dispara os calculos 
		 
		
		//��������������������������������������������������������������Ŀ
		//� Divide cabe�alho                                             �
		//����������������������������������������������������������������
		oSize2 := FwDefSize():New()
		
		oSize2:aWorkArea := oSize:GetNextCallArea( "CABECALHO" ) 
		
		oSize2:AddObject( "NUMERO"  ,  20, 100, .T., .T.) // Dimensionavel
		oSize2:AddObject( "SOLICIT" ,  20, 100, .T., .T.) // Dimensionavel  
		oSize2:AddObject( "DATA"    ,  20, 100, .T., .T.) // Dimensionavel
		  
		oSize2:lLateral := .T.            //Calculo em Lateral
		oSize2:lProp    := .T.            // Proporcional             
		oSize2:aMargins := { 3, 3, 0, 0 } // Espaco ao lado dos objetos 0, entre eles 3 
		
		oSize2:Process() // Dispara os calculos   
	
		aComboTipoSA := {} // Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 17/02/2020
		aAdd( aComboTipoSA, 'Normal' )
		aAdd( aComboTipoSA, 'Transferencia' )

		// Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 17/02/2020
		If __cUserID $ cUsrManut 
			aAdd( aComboTipoSA, cComboTxt ) 
		EndIf
		//
		
		IF nPosicao == 3 //.OR. nPosicao == 2
		     
			@ oSize2:GetDimension("DATA","LININI") + 2, oSize2:GetDimension("DATA","COLINI") + 91 SAY OemToAnsi("Tipo") SIZE 268, 8 OF oDlg PIXEL
			@ oSize2:GetDimension("DATA","LININI") + 2, oSize2:GetDimension("DATA","COLINI") + 111 COMBOBOX oComboTipoSa VAR cComboTipoSa ITEMS aComboTipoSA SIZE 60,10 PIXEL OF oDlg on change nComboTipoSa := oComboTipoSa:nAt
		
		ELSE
				
			IF DBSEEK(xFilial("SCP")+cA105Num, .T.) 
				                                        
				IF SCP->CP_XTIPO == 'N'
					
					cComboTipoSa := 'Normal'
					
				ElseIf AllTrim(SCP->CP_XTIPO) == 'T'     
					    
					cComboTipoSa := 'Transferencia'

				ElseIf AllTrim(SCP->CP_XTIPO) == 'M' // Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 17/02/2020
					     
					cComboTipoSa := cComboTxt
				ENDIF
				
			ENDIF
			
			// @history ticket  63372  - Leonardo P. Monteiro  - 05/11/2021 - Posicionamento do campo 'Tipo' fora de posi��o no cabe�alho quando selecionada a op��o de visualiza��o. 	
			@ oSize2:GetDimension("DATA","LININI") + 2, oSize2:GetDimension("DATA","COLINI") + 91 SAY OemToAnsi("Tipo") SIZE 268, 8 OF oDlg PIXEL
			@ oSize2:GetDimension("DATA","LININI") + 2, oSize2:GetDimension("DATA","COLINI") + 111 COMBOBOX oComboTipoSa VAR cComboTipoSa ITEMS aComboTipoSA SIZE 60,10 PIXEL OF oDlg on change nComboTipoSa := oComboTipoSa:nAt
		ENDIF 
		

	ENDIF
	

	RestArea(aArea)
	
Return(NIL) 

/*/{Protheus.doc} User Function ADEST019P
	gatilho SCP_PRODUTO SEQ 010 CP_XTIPO
	@type  Function
	@author user
	@since 17/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function ADEST019P()
	
	Local cGatilho := ''
	Local cUsrManut := GetMV("MV_#MANUSU",,"001428") // Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 17/02/2020

	cGatilho := IIF(__cUserID $ GETMV("MV_#USUTRA") .AND. nComboTipoSa == 2, 'T', 'N')                              
	cGatilho := Iif(__cUserID $ cUsrManut .and. nComboTipoSa == 3, 'M', 'N') 	// Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 17/02/2020

RETURN(cGatilho)

/*/{Protheus.doc} User Function ADEST020P
	gatilho SCP_PRODUTO SEQ 011 CP_XLOCDES
	@type  Function
	@author user
	@since 17/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function ADEST020P()

	Local cGatilho := ''
	// Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 17/02/2020
	Local cUsrManut := GetMV("MV_#MANUSU",,"001428") 
	Local cLocalMan := GetMV("MV_#MANLOC",,"48")
	//

	cGatilho := IIF(__cUserID $ GETMV("MV_#USUTRA") .AND. nComboTipoSa == 2, '03', '')                              
	cGatilho := Iif(__cUserID $ cUsrManut .and. nComboTipoSa == 3, cLocalMan, '') 	// Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 17/02/2020

RETURN(cGatilho) 

/*/{Protheus.doc} User Function ADEST021P
	//gatilho SCP_PRODUTO SEQ 012 CP_XPRODES
	@type  Function
	@author user
	@since 17/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
User Function ADEST021P()
	
	Local cGatilho := ''                      
	Local cUsrManut := GetMV("MV_#MANUSU",,"001428") // Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 17/02/2020

	cGatilho := IIF(__cUserID $ GETMV("MV_#USUTRA") .AND. nComboTipoSa == 2, M->CP_PRODUTO, '')
	cGatilho := Iif(__cUserID $ cUsrManut .and. nComboTipoSa == 3, M->CP_PRODUTO, '') // Chamado n. 055188 || OS 056599 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || NOVA OPERACAO VENDA - FWNM - 17/02/2020

RETURN(cGatilho)


