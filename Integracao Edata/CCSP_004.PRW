#Include "RwMake.ch"             
#Include "Protheus.ch"
#Include "Topconn.ch" 
#INCLUDE "TOTVS.CH"

/*/{Protheus.doc} User Function CCSP_004
	(Gera pedido de vendas para transportados devido a quebra na devolu�ao)
	@type  Function
	@author Fernando Sigoli
	@since 07/12/2022
	@version 01
	@history Ticket TI     - Fernando Sigoli 26/11/2018	Tratameneto para gerar aprova��o de refaturamento automatico, na gera�a� PDV.
	@history Ticket 044314 - Ricardo Lima    12/12/2018 Controle de Frete, ser� gerado um registro de desconto nas movimenta��es de frete, esse movimento de desconto passar� por al�ada de aprova��o, n�o ser� mais gerado o pedido de vendas para o transportador.
	@history Ticket 044314 - Ricardo Lima    21/01/2019 Ajuste no retorno da nova rotina de devolu��o de vendaque gera desconto para o transportador.
	@history Ticket 044314 - Everson         19/03/2019 Removido desconto pela nota gera��o da nota de sa�da.
	@history Ticket 069574 - Abel Babini     25/04/2022 Projeto FAI
	@history Ticket TI     - Adriano Savoine 07/12/2022 Ajustado o Campo para gerar Pedido com a Quantidade destinada.
	/*/

User Function CCSP_004()

	Local cPerg := "CCSP04"
	// Local oSay,oSay2,oSay3
	//Local oBtn1,oBtn2,oBtn3
	Local oDlg        

	 U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Gera pedido de vendas para transportados devido a quebra na devolu�ao')

    //Cria as perguntas no SX1
	//@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
	//AjustaSX1(cPerg)         
	
	//Mostra a tela de perguntas
	Pergunte(cPerg,.T.)    	
	
	DEFINE MSDIALOG oDlg FROM  96,9 TO 320,612 TITLE OemToAnsi("Tela de filtro") PIXEL
	@ 11,6 TO 90,287 LABEL "" OF oDlg  PIXEL
	@ 16, 15 SAY OemToAnsi("Este programa faz as corre��es financeiras com as devolu��es de vendas") SIZE 268, 8 OF oDlg PIXEL


	DEFINE SBUTTON FROM 93, 193 TYPE 5  ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
	DEFINE SBUTTON FROM 93, 223 TYPE 1  ACTION If(.T.,(Processa({|lEnd| U_TlItensD()},OemToAnsi("Processando devolu��es"),OemToAnsi("Processando..."),.F.),oDlg:End()),) ENABLE OF oDlg
	DEFINE SBUTTON FROM 93, 253 TYPE 2  ACTION oDlg:End() ENABLE OF oDlg
	ACTIVATE MSDIALOG oDlg CENTERED

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �TLItensD   �Autor �Leonardo Rios     � Data �25/09/2014   	  ���
�������������������������������������������������������������������������͹��
���Desc.    �Tela para mostrar o itens retornados conforme a query a ser  ���
���         � contruida com base na regra o nos parametros de filtro      ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TlItensD()

	Local oDlg
	Local oTPanel
	Local oGetDados
	Local aHeader     := {}
	Local aCols       := {}
	Local aButtons    := {}                                   
	Local aCampos     := {}  //Array aCampos utilizado para colocar quais campos dever� fazer uma busca para o array aHeader
	Local aAlias	  := {"SB1", "SD1", "SZD"} //Array aAlias utilizado para colocar em quais tabelas dever� fazer uma busca
	Local aAlter      := NIL    
	// Local aCols2	  := {}
	// Local aAux2		  := {}
	Local cSuperDel   := NIL   
	Local cLinOk      := "AllwaysTrue"
	Local cTudoOk     := "AllwaysTrue"
	Local cFieldOk    := "AllwaysTrue"
	Local cDelOk      := "AllwaysTrue"
	Local cIniCpos    := NIL
	Local cMens		  := ""
	Local nResultado  := 0 //Resultado da diferen�a do EDATAs
	Local nOpc        := Nil//2 // op��o 2 para apenas visualizar os meus itens da tela
	Local nFreeze     := 000 //quantidade minima de linhas na minha tela
	Local nMax        := 999 //quantidade m�xima de linhas na minha tela
	Local nPosParou   := 0  
	Local cLnkSrv		:= Alltrim(SuperGetMV("MV_#UEPSRV",,"LNKMIMS")) //Ticket 69574   - Abel Babini          - 25/04/2022 - Projeto FAI
	Local x := 0
	Local y := 0

	Private ALTERA	  := .T.
	Private aAux	  := {} //Array auxiliar utilizado para guardar informa��es que ser�o necessarias
	Private aDocumento:= {}
	Private cProduto  := ""
	Private oProduto
	//Private cPlaca	  := ""
	Private nValorTot := 0

	U_ADINF009P('CCSP_004' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Gera pedido de vendas para transportados devido a quebra na devolu�ao')

	AADD( aCampos, {"D1_DOC"} )
	AADD( aCampos, {"B1_COD", "B1_DESC"} )
	AADD( aCampos, {"D1_QUANT"} )
	AADD( aCampos, {"ZD_DESCMOT", "ZD_OBSER"} )
	aAdd( aHeader, { '', 'CHECKBOL', '@BMP', 10, 0,,, 'C',, 'V' ,  ,  , 'mark'   , 'V', 'S' } )

	//@history Ticket 70142  - Rodrigo / Flek Solution - 18/07/2022 - Ajustes Dic. de dados no Banco	
	// Carrega aHeader
	//dbSelectArea( "SX3" )   
	//SX3->( dbSetOrder( 2 ) ) // Campo                
	For x:=1 To Len(aCampos)
		For y:= 1 To Len(aCampos[x]) //s� estou usando a variavel x porque tamb�m possui o valor 3
			//If SX3->( dbSeek( aCampos[x, y] ) )
				AADD( aHeader, { 	AllTrim( GetSX3Cache( aCampos[x,y], 'X3_TITULO')),; // 01 - Titulo
									GetSX3Cache( aCampos[x,y], 'X3_CAMPO')		,;	// 02 - Campo
									GetSX3Cache( aCampos[x,y], 'X3_PICTURE')	,;	// 03 - Picture
									GetSX3Cache( aCampos[x,y], 'X3_TAMANHO')	,;	// 04 - Tamanho
									GetSX3Cache( aCampos[x,y], 'X3_DECIMAL')	,;	// 05 - Decimal
									GetSX3Cache( aCampos[x,y], 'X3_VALID') 		,;	// 06 - Valid
									GetSX3Cache( aCampos[x,y], 'X3_USADO')  	,;	// 07 - Usado
									GetSX3Cache( aCampos[x,y], 'X3_TIPO')   	,;	// 08 - Tipo
									GetSX3Cache( aCampos[x,y], 'X3_F3')			,;	// 09 - F3
									GetSX3Cache( aCampos[x,y], 'X3_CONTEXT') 	,;  // 10 - Contexto
									GetSX3Cache( aCampos[x,y], 'X3_CBOX')		,; 	// 11 - ComboBox
									GetSX3Cache( aCampos[x,y], 'X3_RELACAO') 	,;  // 12 - Relacao
									GetSX3Cache( aCampos[x,y], 'X3_INIBRW')  	,;	// 13 - Inicializador Browse
									GetSX3Cache( aCampos[x,y], 'X3_BROWSE') 	,;	// 14 - Mostra no Browse
									GetSX3Cache( aCampos[x,y], 'X3_VISUAL')  	})
			//EndIf
		Next y
	Next x
          
	// Retirar no ambiente ADORO
	If(Len(aHeader) == 7)
		AADD( aHeader, { 	'Diferen�a'		,;
							aHeader[4, 2 ]	,;
							aHeader[4, 3 ]	,;
							aHeader[4, 4 ]	,;
							aHeader[4, 5 ]	,;
							aHeader[4, 6 ]	,;
							aHeader[4, 7 ]	,;
							aHeader[4, 8 ]	,;
							aHeader[4, 9 ]	,;
							aHeader[4, 10]	,;
							aHeader[4, 11]	,;
							aHeader[4, 12]	,;
							aHeader[4, 13]	,;
							aHeader[4, 14]	,;
							aHeader[4, 15]	  } )
	EndIf

	//Query utilizada para buscar os itens de devolu��o que ser�o mostrados na tela e para buscar informa��es auxiliares
	cQuery := " SELECT SD1.D1_COD AS PRODUTO_COD, SD1.D1_QUANT AS QUANTIDADE, SD1.D1_VUNIT AS VALOR_UNITARIO, SD1.D1_ITEM AS ITEM, SD1.D1_FORNECE AS FORNECE, "
	cQuery += " SD1.D1_LOJA AS LOJA, SD1.R_E_C_N_O_ AS RECNO_D1,  SD1.D1_NFORI AS NF_ORIGEM, SD1.D1_SERIORI AS SERIE_ORIGEM, SD1.D1_FILIAL AS FILIAL, SD1.D1_SERIE AS SERIE,  "
	cQuery += " SD1.D1_DOC AS DOC, SD1.D1_MSIDENT AS MSIDENT, SD1.D1_TES AS TES, "
	cQuery += " SF1.R_E_C_N_O_ AS RECNO_F1, SF1.F1_PLACA AS PLACA, "
	cQuery += " SZD.ZD_DESCMOT AS MOTIVO, SZD.ZD_OBSER AS OBSER "
	cQuery += " FROM "+RetSQLName("SD1")+ " SD1, "+RetSQLName("SZD")+ " SZD, " +RetSQLName("SF1")+ " SF1 "    
	cQuery += " WHERE SD1.D1_TIPO = 'D' "
	cQuery += " AND F1_PLACA BETWEEN '" +ALLTRIM(mv_par01)+ "' AND '" +ALLTRIM(mv_par02)+ "' "
	cQuery += " AND F1_DTDIGIT BETWEEN '" +DTOS(mv_par03)+ "' AND '" +DTOS(mv_par04)+ "' "
	cQuery += " AND SD1.D1_CTRDEVO <> ' ' AND SD1.D1_XPVDEV = ' ' AND D1_MSIDENT <> ' ' AND D1_TES <> ' '  "
	cQuery += " AND SD1.D1_CTRDEVO = SZD.ZD_CONTROL "
	cQuery += " AND SF1.F1_FILIAL=D1_FILIAL AND SF1.F1_DOC = SD1.D1_DOC AND SF1.F1_SERIE=D1_SERIE  AND SF1.F1_FORNECE = SD1.D1_FORNECE AND SF1.F1_LOJA=D1_LOJA "
	cQuery += " AND SD1.D_E_L_E_T_ = ' ' AND SZD.D_E_L_E_T_ = ' ' AND SF1.D_E_L_E_T_ = ' ' "

	If Select("TMP_WEB") > 0
 	   TMP_WEB->(dbCloseArea())
    EndIf

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP_WEB",.F.,.T.)
	dbSelectArea("TMP_WEB")
                
    TMP_WEB->(dbGoTop())

    While TMP_WEB->(!Eof())         
    
        SB1->(dbSetOrder(1))
        SB1->(dbSeek(xFilial("SB1") + TMP_WEB->PRODUTO_COD)) 
        
        cDescSB1 := SB1->(B1_DESC)
        cUnidSB1 := SB1->(B1_UM)
        cLocPSB1 := SB1->(B1_LOCPAD)

   		AADD(aCols,	{ 'LBNO'							 						,;
					  TMP_WEB->DOC						 						,;
   		   			  TMP_WEB->PRODUTO_COD		 		 						,;
   					  ALLTRIM(cDescSB1)					 						,;
  					  ConvUm(TMP_WEB->PRODUTO_COD, TMP_WEB->QUANTIDADE, 0, 2)	,;
 					  TMP_WEB->MOTIVO					 						,;
  					  ""								 						,;
  					  0							  		 						,;
  					  .F. 								   						  })//posi��o 7=observa��o; posi��o 8=diferen�a
  					  
		AADD(aAux, { TMP_WEB->VALOR_UNITARIO	,;
					 cUnidSB1				 	,;
					 TMP_WEB->FORNECE			,;
					 TMP_WEB->LOJA				,;
					 TMP_WEB->NF_ORIGEM			,;                                                                  	
					 TMP_WEB->SERIE_ORIGEM		,;
					 TMP_WEB->FILIAL			,;
					 TMP_WEB->ITEM				,;
					 TMP_WEB->DOC				,;
					 TMP_WEB->SERIE				,;
					 TMP_WEB->MSIDENT 			,;
					 cLocPSB1					,;
					 TMP_WEB->RECNO_D1			,;
 					 TMP_WEB->RECNO_F1			,;
 					 TMP_WEB->TES				,;
 					 TMP_WEB->PLACA				  })
                                                             
	    TMP_WEB->(dbSkip())
	Enddo

	TMP_WEB->(dbCloseArea())                      
	
	If(Len(aCols) < 1 .And. Len(aAux) < 1 )
		aHeader := {}
	EndIf                      
	
	nPosParou := 0
	For x:=1 To Len(aCols)  
		If(aAux[x] == Nil .OR. aCols[x] == Nil)
			nPosParou := x-1
			Exit
		EndIf                                   
		//Ticket TI - Adriano Savoine 07/12/2022
		cQuery := " SELECT (QN_EMBAAJUS + QN_EMBADEST) AS DIFERENCA, FL_FATUMOTIAJUSDEVOVEND AS FATURA "
		cQuery += " FROM ["+cLnkSrv+"].[SMART].[dbo].[VW_PEDIDEVOVEND_01] "
		cQuery += " WHERE IE_PEDIDEVOVEND= "+ ALLTRIM(STR(aAux[x, 14])) + " AND ID_ITEMPEDIDEVOVEND= " +ALLTRIM(STR(aAux[x, 13]))
	
		If Select("TMP_WEB") > 0
	 	   TMP_WEB->(dbCloseArea())
	    EndIf
	
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP_WEB",.F.,.T.)
		dbSelectArea("TMP_WEB")
	
	    TMP_WEB->(dbGoTop())
		
		nResultado := -1
	    While TMP_WEB->(!Eof())
	    	If( TMP_WEB->FATURA == 1)
	            nResultado := TMP_WEB->DIFERENCA
			Else        
				nResultado := 0	
			EndIf              
			
			TMP_WEB->(dbSkip())
		Enddo		        	
		
		TMP_WEB->(dbCloseArea())
		
		If(nResultado > 0)
			aCols[x, 8] := nResultado
		Else
			ADEL(aCols, x)
			ADEL(aAux , x)                            
			x -= 1
		EndIf

	Next x
	
	ASIZE( aCols, nPosParou)
	ASIZE( aAux , nPosParou)
    
    If( Len(aCols) < 1 )
    	aCols := {}
    	aAux := {}
    	aHeader := {}
    	
    	U_ExTelaMen("Faturamento contra Trasnportador","N�o foi encontrada nenhuma nota para ser mostrado em tela","Arial",10,,.F.,.T.)

    Endif
	
	DEFINE MSDIALOG oDlg TITLE "Tela de sele��o para Faturamento do Transportador" FROM 000, 000 TO 549, 950 PIXEL

		oGetDados := MsNewGetDados():New( 012, 002, 120, 265, nOpc, cLinOk, cTudoOk, cIniCpos, aAlter, nFreeze, nMax, cFieldOk, cSuperDel, cDelOk, oDlg, aHeader, aCols )
		oGetDados:oBrowse:Align := CONTROL_ALIGN_ALLCLIENT
		oGetDados:oBrowse:bLDblClick := {|| oGetDados:EditCell(),  oGetDados:aCOLS[oGetDados:nAt,1]:= GetData(oGetDados:nAt, oGetDados:aCOLS[oGetDados:nAt,3],oGetDados:aCOLS[oGetDados:nAt,8], oGetDados:aCOLS[oGetDados:nAt,1], oTPanel, aCols) }//Iif(Empty(oGetDados:aCOLS[oGetDados:nAt,1]) == 'LBOK','LBNO','LBOK')}
	
		oTPanel := TPanel():New(0,0,"",oDlg,NIL,.T.,.F.,NIL,NIL,0,16,.T.,.F.)
		oTPanel:Align := CONTROL_ALIGN_BOTTOM
		
		@ 5,1   SAY "Total R$ " OF oTPanel SIZE 100,10 PIXEL
		@ 20,3  MSGET oProduto Var cProduto Picture "@!s" Size 40,10 OF oDlg
        
	ACTIVATE MSDIALOG oDlg CENTERED  ON INIT EnchoiceBar( oDlg, { || ValidData(oGetDados, aCols, oDlg) }, { || U_ExTelaMen("Faturamento contra Trasnportador", "Processo cancelado!", "Arial", 10, , .F., .T.), oDlg:End() },, aButtons )

Return
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �GetData   �Autor �Leonardo Rios     � Data �25/09/2014   	  ���
�������������������������������������������������������������������������͹��
���Desc.    � Fun��o para valida��o da linha em que foi selecionado o  	  ���
���         � checkbox e para altera��o do valor total					  ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function GetData(nLin, cCod,nQnt, cMark, oTPanel, aCols)

Local nVlrUnit	:= aAux[nLin, 1]
Local nFatorPrc := GetMV("MV_X_PERTR", .F., 1.25)
Local nQtde     := nQnt//ConvUm(cCod,0,nQnt,1) //O valor do EDATA j� me traz a diferen�a
Local lBloqCli	 := .F. //vari�vel para dizer se o cliente esta bloqueado
Local lPossuiT	 := .F. //vari�vel para dizer se possui um transportador
Local cDocumento := aAux[nLin, 9]
Local aSF2TrnspAx:= {}
Local aSA4TrnspAx:= {}
Local x := 0
Local y := 0

	aSF2TrnspAx := {}
	cQuery := " SELECT F2_TRANSP AS TRANSPORTA "
	cQuery += " FROM " +RetSQLName("SF2")+ " SF2 "
	cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' "
	cQuery += " AND  SF2.F2_CLIENTE = '"+aAux[nLin, 3]+"' "
	cQuery += " AND  SF2.F2_LOJA = '"+aAux[nLin, 4]+"' "
	cQuery += " AND  SF2.F2_DOC = '"+aAux[nLin, 5]+"' "
	cQuery += " AND  SF2.F2_SERIE = '"+aAux[nLin, 6]+"' "
	cQuery += " AND  SF2.F2_FILIAL = '"+aAux[nLin, 7]+"' "

	If Select("TMP_WEB") > 0
 	   TMP_WEB->(dbCloseArea())
    EndIf

	dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP_WEB",.F.,.T.)
	dbSelectArea("TMP_WEB")

    TMP_WEB->(dbGoTop())

    While TMP_WEB->(!Eof())
   		AADD(aSF2TrnspAx, TMP_WEB->TRANSPORTA )
	    TMP_WEB->(dbSkip())
	Enddo

	TMP_WEB->(dbCloseArea())

	If(Len(aSF2TrnspAx) < 1)
		AADD(aSF2TrnspAx, "" )
	EndIf

	//---------------------------------------------------------------------
	
	If(!Empty(ALLTRIM(aSF2TrnspAx[1])) )
		aSA4TrnspAx := {}
		cQuery := " SELECT A4_CGC AS CNPJ "
		cQuery += " FROM " +RetSQLName("SA4")+ " SA4 "
		cQuery += " WHERE SA4.D_E_L_E_T_ = ' ' "
		cQuery += " AND A4_COD = '"+aSF2TrnspAx[1]+"' "

		If Select("TMP_WEB") > 0
	 	   TMP_WEB->(dbCloseArea())
	    EndIf
	
		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP_WEB",.F.,.T.)
		dbSelectArea("TMP_WEB")
	                
	    TMP_WEB->(dbGoTop())	
	
	    While TMP_WEB->(!Eof())	
	   		AADD(aSA4TrnspAx, TMP_WEB->CNPJ )	
		    TMP_WEB->(dbSkip())
		Enddo	

		TMP_WEB->(dbCloseArea())
		
		If(Len(aSA4TrnspAx) < 1)
			AADD(aSA4TrnspAx, "" )
		EndIf
		
		//---------------------------------------------------------------------
		
		If(!Empty(ALLTRIM(aSA4TrnspAx[1])) )
			aTransp := {}
			cQuery := " SELECT A1_COD AS TRANSPORTE, A1_MSBLQL AS BLOQUEADO "
			cQuery += " FROM " +RetSQLName("SA1")+ " SA1 "
			cQuery += " WHERE SA1.D_E_L_E_T_ = ' ' "
			cQuery += " AND A1_CGC = '"+aSA4TrnspAx[1]+"' "
	
			If Select("TMP_WEB") > 0
		 	   TMP_WEB->(dbCloseArea())
		    EndIf
		
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP_WEB",.F.,.T.)
			dbSelectArea("TMP_WEB")
		                
		    TMP_WEB->(dbGoTop())	
		
		    While TMP_WEB->(!Eof())	
		    	If(ALLTRIM(TMP_WEB->BLOQUEADO) == '1' )
			   		lBloqCli := .T.
		   		EndIf
		   		
		   		If(!Empty(ALLTRIM(TMP_WEB->TRANSPORTE)) )
			   		lPossuiT := .T.
		   		EndIf
		   		
			    TMP_WEB->(dbSkip())
			    
			Enddo	
	
			TMP_WEB->(dbCloseArea())	

		EndIf
	EndIf
                           
	If(lBloqCli)                                                                     
		U_ExTelaMen("Faturamento contra Trasnportador","N�o � poss�vel usar esta devolu��o porque o cliente relacionado a ela esta bloqueado!","Arial",10,,.F.,.T.)
		Return 'LBNO'
	EndIf

	If(!lPossuiT)
		U_ExTelaMen("Faturamento contra Trasnportador","N�o � poss�vel usar esta devolu��o porque n�o possui um transportador","Arial",10,,.F.,.T.)
		Return 'LBNO'
	EndIf      
	
	If(aCols[nLin, 8] == -1)
		U_ExTelaMen("Faturamento contra Trasnportador","N�o � poss�vel usar esta devolu��o porque n�o foi processado a nota no EDATA","Arial",10,,.F.,.T.)
		Return 'LBNO'
	EndIf
	
	If(aCols[nLin, 8] == 0)
		U_ExTelaMen("Faturamento contra Trasnportador","N�o � poss�vel usar esta devolu��o porque n�o houve diverg�ncia na devolu��o","Arial",10,,.F.,.T.)
		Return 'LBNO'
	EndIf
	
	If( Empty(ALLTRIM(aAux[nLin, 15])) )
		U_ExTelaMen("Faturamento contra Trasnportador","N�o � poss�vel usar esta devolu��o porque n�o foi classificada ainda","Arial",10,,.F.,.T.)
		Return 'LBNO'
	EndIf
	
	
	If( Alltrim(cMark) == "LBOK" ) 		
		For x:=1 To Len(aDocumento)
					
			If( Alltrim(aDocumento[x, 1]) == cDocumento )
			
				If( Len(aDocumento[x, 2]) > 1 )
					For y:=1 To Len(aDocumento[x,2])
						
						If( aDocumento[x,2,y] == nLin )
							ADEL(aDocumento[x, 2], y)
							ASIZE(aDocumento[x, 2], Len(aDocumento[x, 2])-1)
							
							Exit								
						EndIf	
																			
					Next y
					
				Else
					ADEL(aDocumento, x)					
					ASIZE( aDocumento, Len(aDocumento)-1)
				EndIf
				
			  	Exit
			EndIf
		Next x
		
	Else
		If(Len(aDocumento) < 1)
			Aadd(aDocumento, {cDocumento, {nLin} } )
			
		Else        
			lEnctrei := .F.
			
			For x:=1 To Len(aDocumento)
				If( Alltrim(aDocumento[x, 1]) == cDocumento )
					lEnctrei := .T.
					Aadd(aDocumento[x, 2], nLin)
				  	Exit
				EndIf
			Next x
			
			If(lEnctrei == .F.)
				Aadd(aDocumento, {cDocumento, {nLin} } )
			EndIf				
		EndIf
		
	EndIf


nValorTot := Iif( ALLTRIM(cMark) == 'LBOK',	nValorTot-((nQtde)*nVlrUnit*nFatorPrc),	nValorTot+((nQtde)*nVlrUnit*nFatorPrc)  ) 

cProduto := ALLTRIM(TRANSFORM(nValorTot, "@E 999,999.99"))
oProduto:Refresh()

Return Iif(ALLTRIM(cMark) == 'LBOK','LBNO','LBOK')




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �ValidData  �Autor �Leonardo Rios     � Data �25/09/2014   	  ���
�������������������������������������������������������������������������͹��
���Desc.    � Fun��o para valida��o das linhas ap�s clicar no bot�o		  ���
���         � confirmar da tela											  ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ValidData(oGetDados, aCols, oDlg)
    
Local lEncontrei := .F.
Local lRetorno 	 := .F.
Local aCabecalho := {}
Local aItem 	 := {}
Local aItens 	 := {}              
Local aTransp 	 := {}
Local aSF2TrnspAx:= {}
Local aSA4TrnspAx:= {}
Local cNumPedVend:= ""
Local cAlias 	 := "SD1"         
Local nFatorPrc  := GetMV("MV_X_PERTR", .F., 1.25)
Local nPosicao	 := 0
Local nCount	 := 0
//12/12/2018 - Ricardo Lima - 044314
Local cF1DOC     := ''
Local cF1SERIE   := ''
Local cF1FORNE   := ''
Local cF1LOJA    := ''
Local nVlrDev    := 0
Local x          := 0
Local p          := 0
Local DV         := 0
Local nI         := 0
Local y          := 0

Begin Transaction
	
   	For y:=1 To Len(aDocumento)
   		cNumPedVen := GetSxeNum("SC5","C5_NUM")    	
	   	ConfirmSx8()
	   	
	   	aItens 		:= {}
	   	aCabecalho  := {}
	   	
	   	For x:=1 To Len(aDocumento[y, 2])   			
   			If( Alltrim( oGetDados:aCols[aDocumento[y, 2, x],1] ) == 'LBOK' )
   				lEncontrei :=.T.
				nPosicao   := aDocumento[y, 2, x]
	            aItem 	   := {}                   
				nCount++
				cTes := GetMV("MV_X_TESFD",.F.,"501")
			     
				aAdd(aItem, {"C6_ITEM"		, StrZero(nCount, 2)				 					,	Nil })
				aAdd(aItem, {"C6_PRODUTO"	, aCols[nPosicao, 3]						  			,	Nil })
				aAdd(aItem, {"C6_UNSVEN"	, aCols[nPosicao, 8]									,	Nil })
				aAdd(aItem, {"C6_PRCVEN"  	, ( aAux[nPosicao,1]*nFatorPrc  )						,	Nil })
				aAdd(aItem, {"C6_UM" 	 	, aAux[nPosicao, 2]										,	Nil })
				aAdd(aItem, {"C6_QTDVEN"	, ConvUm(aCols[nPosicao, 3], 0,	aCols[nPosicao,8], 1)	,	.F. })
				aAdd(aItem, {"C6_TES"   	, IIF( Empty( Alltrim(cTes) ), "501", cTes) 			,	Nil })
				aAdd(aItem, {"C6_PRUNIT"   	, ( aAux[nPosicao, 1]*nFatorPrc )					 	,	Nil })
				aAdd(aItem, {"C6_XIDNDEV"  	, aAux[nPosicao, 11]							 		,	Nil })
				aAdd(aItem, {"C6_XRECSD1"  	, aAux[nPosicao, 13]								 	,	Nil })
				
				aAdd(aItens, aItem)
   			EndIf
   		Next x
		
		cCondPag := GetMV("MV_X_CONDFD",.F.,"021")

		AADD(aCabecalho, {"C5_NUM"		, cNumPedVen									, Nil} )
		AADD(aCabecalho, {"C5_TIPO"		, "N"											, Nil} )
		AADD(aCabecalho, {"C5_DTENTR"	, DaySub(ddatabase, 5)							, Nil} )		
		AADD(aCabecalho, {"C5_EMISSAO"	, DaySub(ddatabase, 5)							, Nil} )		
		AADD(aCabecalho, {"C5_XAPREFA"	, "S"											, Nil} )//Chamado: TI - Fernando Sigoli 26/11/2018 
		AADD(aCabecalho, {"C5_XOBSRFA"	, "REFATURAMENTO TRANSPORTADOR"		            , Nil} )//Chamado: TI - Fernando Sigoli 26/11/2018 
		AADD(aCabecalho, {"C5_REFATUR"	, ''	  	            						, Nil} )//Chamado: TI - Fernando Sigoli 26/11/2018 
		AADD(aCabecalho, {"C5_XUSREFA"	, __cUserId		            					, Nil} )//Chamado: TI - Fernando Sigoli 26/11/2018 

		aSF2TrnspAx := {}
		cQuery := " SELECT F2_TRANSP AS TRANSPORTA "
		cQuery += " FROM " +RetSQLName("SF2")+ " SF2 "
		cQuery += " WHERE SF2.D_E_L_E_T_ = ' ' "
		cQuery += " AND  SF2.F2_CLIENTE = '"+aAux[nPosicao, 3]+"' "
		cQuery += " AND  SF2.F2_LOJA = '"+aAux[nPosicao, 4]+"' "
		cQuery += " AND  SF2.F2_DOC = '"+aAux[nPosicao, 5]+"' "
		cQuery += " AND  SF2.F2_SERIE = '"+aAux[nPosicao, 6]+"' "
		cQuery += " AND  SF2.F2_FILIAL = '"+aAux[nPosicao, 7]+"' "

		If Select("TMP_WEB") > 0
	 	   TMP_WEB->(dbCloseArea())
	    EndIf

		dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP_WEB",.F.,.T.)
		dbSelectArea("TMP_WEB")

	    TMP_WEB->(dbGoTop())

	    While TMP_WEB->(!Eof())
	   		AADD(aSF2TrnspAx, TMP_WEB->TRANSPORTA )
		    TMP_WEB->(dbSkip())
		Enddo

		TMP_WEB->(dbCloseArea())

		If(Len(aSF2TrnspAx) < 1)
			AADD(aSF2TrnspAx, "" )
		EndIf

		//---------------------------------------------------------------------
		
		If(!Empty(ALLTRIM(aSF2TrnspAx[1])) )
			aSA4TrnspAx := {}
			cQuery := " SELECT A4_CGC AS CNPJ "
			cQuery += " FROM " +RetSQLName("SA4")+ " SA4 "
			cQuery += " WHERE SA4.D_E_L_E_T_ = ' ' "
			cQuery += " AND A4_COD = '"+aSF2TrnspAx[1]+"' "
	
			If Select("TMP_WEB") > 0
		 	   TMP_WEB->(dbCloseArea())
		    EndIf
		
			dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP_WEB",.F.,.T.)
			dbSelectArea("TMP_WEB")
		                
		    TMP_WEB->(dbGoTop())	
		
		    While TMP_WEB->(!Eof())	
		   		AADD(aSA4TrnspAx, TMP_WEB->CNPJ )	
			    TMP_WEB->(dbSkip())
			Enddo	
	
			TMP_WEB->(dbCloseArea())
			
			If(Len(aSA4TrnspAx) < 1)
				AADD(aSA4TrnspAx, "" )
			EndIf
			
			//---------------------------------------------------------------------
			
			If(!Empty(ALLTRIM(aSA4TrnspAx[1])) )
				aTransp := {}
				cQuery := " SELECT A1_COD AS TRANSPORTE, A1_MSBLQL AS BLOQUEADO, A1_LOJA AS LOJA "
				cQuery += " FROM " +RetSQLName("SA1")+ " SA1 "
				cQuery += " WHERE SA1.D_E_L_E_T_ = ' ' "
				cQuery += " AND A1_CGC = '"+aSA4TrnspAx[1]+"' "
		
				If Select("TMP_WEB") > 0
			 	   TMP_WEB->(dbCloseArea())
			    EndIf
			
				dbUseArea(.T.,"TOPCONN",TCGENQRY(,,cQuery),"TMP_WEB",.F.,.T.)
				dbSelectArea("TMP_WEB")
			                
			    TMP_WEB->(dbGoTop())	
			
			    While TMP_WEB->(!Eof())	
			    	If(ALLTRIM(TMP_WEB->BLOQUEADO) != '1' )
				   		AADD(aTransp, TMP_WEB->TRANSPORTE )
				   		AADD(aTransp, TMP_WEB->LOJA )
			   		EndIf
				    TMP_WEB->(dbSkip())
				    
				Enddo	
		
				TMP_WEB->(dbCloseArea())
				
				If(Len(aTransp) < 2)
					AADD(aTransp, "" )
					AADD(aTransp, "" )
				EndIf
			EndIf
		EndIf
		
		AADD(aCabecalho, {"C5_CLIENTE"	, IIF(Len(aTransp) < 2, "", aTransp[1]) , Nil} )
		AADD(aCabecalho, {"C5_LOJACLI"	, IIF(Len(aTransp) < 2, "", aTransp[2])	, Nil} )
		//12/12/2018 - Ricardo Lima - 044314
		nVlrDev := 0
		For p:=1 to Len(aItens)
			nVlrDev += aItens[p,4,2] * aItens[p,6,2]
		Next
		For DV:=1 To Len(aAux)
			cF1DOC    := aAux[DV,09]
			cF1SERIE  := aAux[DV,10]
			cF1FORNE  := aAux[DV,03]
			cF1LOJA   := aAux[DV,04]
		Next DV
		
		//12/12/2018 - Ricardo Lima - 044314
		lRetorno := U_ADR100(cFilAnt,aCabecalho,aItens,3)   
		IF lRetorno
			//19/03/2019-Everson-044314
			//Processa({|| U_ADLOG047P( cF1DOC , cF1SERIE , cF1FORNE , cF1LOJA , nVlrDev ) },,'Processando...') // 21/01/2019 - Ricardo Lima - 044314
		EndIf
		
		If(lRetorno)
		    //Ap�s o cadastro do Execauto eu preciso flegar o campo D1_XPVDEV para que ele n�o seja filtrado novamente em um
		    //poss�vel pedido com os itens novamente
			dbSelectArea(cAlias)
			dbSetOrder(1)
			
			For nI:=1 To Len(aAux)
				If(ALLTRIM(oGetDados:aCols[nI,1]) == 'LBOK' )

	            	dbSeek( xFilial(cAlias) + aAux[nI, 9] + aAux[nI, 10] + aAux[nI, 3] + aAux[nI, 4] + aCols[nI, 3] + aAux[nI, 8])

					If Found()
				    	RecLock(cAlias,.F.)
				        
				        Replace SD1->D1_XPVDEV With '1'
				        MsUnLock(cAlias)
					EndIf
		    	EndIf
			Next nI                                                               
			                                                           
			cMens := "Gerado com sucesso !"
			cMens := "Pedido de Venda "+cNumPedVen+" : " + cMens
			
			U_ExTelaMen("Faturamento contra Trasnportador",cMens,"Arial",10,,.F.,.T.)
			
			oDlg:End()

		Else                                             
			RollBackSx8()
			DisarmTransaction()                  

			cMens := "Houve um problema ao ser executado o ExecAuto para o Pedido de Vendas !"
			cMens := "Pedido de Venda "+cNumPedVen+" do transportador "+ IIF(Len(aTransp) < 2, "", aTransp[1]) +": " + cMens
			
			U_ExTelaMen("Faturamento contra Transportador",cMens,"Arial",10,,.F.,.T.)
			
			oDlg:End()
		EndIf
		
	Next y


	If(!lEncontrei)
		//alerta n�o foi selecionado nenhum valor		
		cMens := "N�o foi selecionado nenhum item para ser gerado o Pedido de Venda !"
		
		U_ExTelaMen("Faturamento contra Trasnportador",cMens,"Arial",10,,.F.,.T.)		

	EndIf
	
End Transaction
	
Return




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa �AjustaSX1 �Autor  �Leonardo Rios    � Data �24/09/2014   	  ���
�������������������������������������������������������������������������͹��
���Desc.    �Insere novas perguntas ao sx1 para a tela de perguntas da    ���
���         �funcionalidade de corre��o financeira na devolu��o de vendas ���
�������������������������������������������������������������������������͹��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Static Function AjustaSX1(cPerg)
//
////��������������������������������������Ŀ
////� Variaveis utilizadas para parametros �
////� mv_par01	  // Placa  		  	 �
////� mv_par02	  // Entrada 		  	 �
////�����������������������������������������
//
//PutSx1(cPerg, "01", "Placa de     "    , "Placa de     " , "Placa de    ", "mv_cha", "C", TamSX3("ZD_PLACA"	 )[1], 0, 1, "G", "NaoVazio()", ""   , "", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1(cPerg, "02", "Placa ate    "    , "Placa ate    " , "Placa ate   ", "mv_chb", "C", TamSX3("ZD_PLACA"	 )[1], 0, 1, "G", "NaoVazio()", ""   , "", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1(cPerg, "03", "Entrada de   "    , "Entrada de   " , "Entrada de  ", "mv_chc", "D", TamSX3("D1_DTDIGIT")[1], 0, 1, "G",           "", ""   , "", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1(cPerg, "04", "Entrada ate  "    , "Entrada ate  " , "Entrada ate ", "mv_chd", "D", TamSX3("D1_DTDIGIT")[1], 0, 1, "G",           "", ""   , "", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//
//Return
