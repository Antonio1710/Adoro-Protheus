#Include "rwmake.ch"
#Include "protheus.ch"
#Include "topconn.ch"

/*/{Protheus.doc} User Function ADEST060P
    Rotina para sele��o de Requisitos de Mercado.
    Chamado 8465
    @type  Function
    @author Leonardo P. Monteiro
    @since 22/02/2021
    @version 01
	@history Chamado 8465 - Leonardo P. Monteiro - 30/04/2021 - Melhoria na rotina para cria��o da sub-categoria do PGA.
    /*/
User Function ADEST062P(cZE1Reg, cZEDReg)

	//Define quais colunas (campos da TTRB) serao exibidas na MsSelect
	Local cCampos			:= " B1_COD,B1_DESC,B1_XPGAMER,B1_XPGACAT"
	
	Private oGetPesq
	Private oGroup1
	Private oGet
	Private oDlg
	Private oOrdem
	Private oButton
	Private aCampos 		:= {}
	Private aColsBco		:= {}
	Private aHeaderBco		:= {}
	Private aItens			:= {"C�digo","Descri��o"}
	Private cPesquisa		:= space(60)
	Private cOrdem			:= ""
	Private aButtons		:= {}
	Private nCont			:= 0
	Private nRetorno		:= 1

	Private cFOpen			:= ""
	Private oOk 			:=	LoadBitmap( GetResources(), "LBOK")
	Private oNo 			:=	LoadBitmap( GetResources(), "LBNO")
	Private bOk				:= {|| nRetorno := fOk(cZE1Reg, cZEDReg),odlg:End()}
	Private aParamBox		:= {}
	Private aRet			:= {}

	Default cZE1Reg			:= ""
	Default cZEDReg			:= ""

	Aadd( aParamBox ,{1,"Produto De"  						,Space(35),"" ,'.T.',"SB1",'.T.',80,.F.})
	Aadd( aParamBox ,{1,"Produto At�"  						,Space(35),"" ,'.T.',"SB1",'.T.',80,.F.})
	Aadd( aParamBox ,{1,"Tipo De"  							,Space(2) ,"" ,'.T.',"SZE",'.T.',80,.F.})
	Aadd( aParamBox ,{1,"Tipo At�"  						,Space(2) ,"" ,'.T.',"SZE",'.T.',80,.F.})
	aAdd( aParamBox	,{ 3,"Considera prod bloqueados"		,1,{'Todos','Sim','N�o'},100,"",.F.})
	aAdd( aParamBox	,{ 3,"Considera prod c/ req. mercado"	,1,{'Todos','Sim','N�o'},100,"",.F.})

    if ParamBox(aParamBox,"Par�metros",@aRet)

		aHeaderBco 	:= MontCabec(cCampos, , 1)
		aColsBco	:= MontDados(cZE1Reg, cZEDReg)

		if len(aColsBco) > 0
			@ 050,001 TO 600, 600 DIALOG oDlg TITLE "..:: Sele��o de Produtos ::.."

			oGroup1 	:= tGroup():New(033,002,75,300,'Pesquisar',oDlg,,,.T.)
			oOrdem 		:= tComboBox():New(43,10,{|u|if(PCount()>0,cOrdem:=u,cOrdem)},aItens,80,20,oGroup1,,{|| fOrdena()},,,,.T.,,,,,,,,,'nOrdem')
			oGetPesq	:= TGet():New(43,90,{|u| if(PCount()>0,cPesquisa:=u,cPesquisa)}, oGroup1,133,14,'',,,,,,,.T.,,,,,,,,,,'cPesquisa')
			oButton		:=tButton():New(43,227,'Pesquisa',oDlg,{||fPesquisa(1)},70,14,,,,.T.)
			oGet		:= MsNewGetDados():New(077,003,260,300, 2,"AllwaysTrue","AllwaysTrue",,{"B1_DESC"},,nCont,"AllwaysTrue", "AllwaysTrue","", oDlg, aHeaderBco, aColsBco, "AllwaysTrue")	
			oGet:oBrowse:BldBlclick := {|| fSeleciona()}
			
			ACTIVATE DIALOG oDlg On Init (EnchoiceBar(oDlg,{|| MsAguarde(bOk,"Processando, aguarde...","Aguarde..." )},{|| cRetorno := "", oDlg:End()},,aButtons)) CENTER
		else
			msginfo("N�o existe itens dispon�veis para inclus�o.")
		endif

		IF Select("Query1") > 1
			DbCloseArea("Query1")
		EndIF
	
	endif

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),' Rotina para sele��o de Requisitos de Mercado')


Return nRetorno

Static Function fOk(cZE1Reg, cZEDReg)
	Local nRet := 0

	Local nPosOk		:= Ascan( oGet:aHeader, { |x| Alltrim(x[2]) == "OK"  })
	Local nPosChave		:= Ascan( oGet:aHeader, { |x| Alltrim(x[2]) == "B1_COD" })
	local nA			:= 0
	
	DbSelectArea("SB1")
	SB1->(DbsetOrder(1))

	For nA := 1 TO Len(oGet:aCols)  
		If oGet:aCols[nA][nPosOk] == oOk
			
			if SB1->(Dbseek(xFilial("SB1")+left(oGet:aCols[nA][nPosChave]+space(15),15),.F.))
				if fExcrel(SB1->B1_COD, cZE1Reg)
					if Reclock("SB1",.F.)
						SB1->B1_XPGAMER := cZE1Reg
						SB1->B1_XPGACAT := cZEDReg
						SB1->(MsUnlock())
					endif
				endif
			Endif
		EndIf
	Next nA

return nRet

/* Excluir todos os relacionamentos anteriores na tabela ZE4. */
Static Function fExcrel(cProduto, cZE1Reg)
	Local cQuery 	:= ""
	Local lRet		:= .T.
	DbSelectArea("ZE4")

	cQuery := " SELECT R_E_C_N_O_ REGISTRO "
	cQuery += " FROM "+ RetSqlName("ZE4") +" "
	cQuery += " WHERE D_E_L_E_T_='' AND ZE4_FILIAL='"+ xFilial("ZE4") +"' AND ZE4_ZE1REG != '"+cZE1Reg+"' AND ZE4_CODPRD='"+ cProduto +"'; "

	TcQuery cQuery ALIAS "QZE4" NEW

	while QZE4->(!EOF())
		ZE4->(DbGoto(QZE4->registro))	
		if reclock("ZE4",.F.)
				ZE4->(DbDelete())
			msunlock("ZE4")
		else
			lRet := .F.
		endif

		QZE4->(DbSkip())
	enddo

	QZE4->(DbCloseArea())

return lRet

Static Function fSeleciona()
	Local nPosOk			:= Ascan( oGet:aHeader, { |x| Alltrim(x[2]) == "OK"	})
	//Local lRet 			:= .T.

	If oGet:aCols[oGet:oBrowse:nAt][nPosOk] == oNo
		oGet:aCols[oGet:oBrowse:nAt][nPosOk] := oOk
	Else 
		oGet:aCols[oGet:oBrowse:nAt][nPosOk] := oNo
	EndIf


Return

//Fun��o respons�vel pela cria��o dos arquivos de trabalho.
Static Function fCriaTrab(cAlias)

	Local cArqTrab 	:= NIL  

	cArqTrab			:= FWTemporaryTable():New(cAlias, aStrut)
	cArqTrab:AddIndex("01",{"B1_COD"})
    cArqTrab:AddIndex("02",{"B1_DESC"})
	
	cArqTrab:Create()
 
	cAlias 		:= cArqTrab:GetAlias()
	cTableName 	:= cArqTrab:GetRealName()
  
	DbSelectArea(cAlias)
	
	(cAlias)->(DbSetOrder(1))
Return cArqTrab

/* fOrdena */
Static Function fOrdena()
	//alert("Ordena")
	//C�digo
	If oOrdem:Nat == 1
		aSort(oGet:aCols,,,{|x,y| x[1]+x[2]<y[1]+y[2]})
	ElseIf oOrdem:Nat == 2
		aSort(oGet:aCols,,,{|x,y| x[3]<y[3]})
	EndIf

	oGet:oBrowse:refresh()
Return

/* fPesquisa */
Static Function fPesquisa(nTipo, cAlias)
	Local nPos	:= 0
	Local cPesq := Alltrim(cPesquisa)

	If nTipo == 1
		If !Empty(cPesq)

			If oOrdem:Nat == 1
				nPos := aScanX( oGet:aCols, { |X,Y| UPPER(cPesq) == Left( UPPER(Alltrim(X[2])),Len(cPesq) ) })
			ElseIf oOrdem:Nat == 2
				nPos := aScanX( oGet:aCols, { |X,Y| UPPER(cPesq) == Left( UPPER(Alltrim(X[3])),Len(cPesq) ) })
			EndIf                                                                               

			oGet:goTo(nPos)
			oGet:oBrowse:refresh()
		EndIf

	EndIf

Return .T.

//*** Fun��o MontCabec - Monta o cabe�alho.
Static Function MontCabec(cCampos, cAlias,nTipoArray)
	Local aArea 	:= GetArea()
	Local X			:= 0
	Local aHeaderA	:= {}
	Local aCampo	:= {}
	Local nX		:= 0
	Local aHeaderA	:= {}

	IF nTipoArray == 1
		AADD( aHeaderA,{"",;
		"OK",;
		"@BMP",;
		2,;
		0,;
		/*X3_VALID*/,;
		"",;
		"C",;
		"",;
		"V"})
	ElseIF nTipoArray == 2
		AADD(aHeaderA,{ "OK",,"Mark","@!"})
	ElseIf nTipoArray == 3
		AADD(aHeaderA,{"OK"     ,"L"	,1		,0		})
	ElseIf nTipoArray == 4
		AADD(aHeaderA,{""     ,{||IIF((cAlias)->OK,oOK,oNO)}	,"@!"	,"CENTER"	,02		,.T.})
	EndIF

	aCampos := Separa(cCampos,",",.F.)

	For nX	:= 1 TO Len(aCampos)
		aCampo	:= Separa(aCampos[nX]," AS ",.F.)
		IF LEN(aCampo) > 1
			aCampos[nX]	:= Alltrim(aCampo[2])
		ElseIf LEN(aCampo) == 1
			aCampos[nX]	:= allTrim(aCampo[1])
		EndIF

		aCampo	:= Separa(aCampos[nX],".",.F.)
		IF LEN(aCampo) > 1
			aCampos[nX]	:= AllTrim(aCampo[2])
		ElseIf LEN(aCampo) == 1
			aCampos[nX]	:= allTrim(aCampo[1])
		EndIF

	NExt nX


	dbselectArea("SX3")
	DbSetOrder(2)
	//WHILE !EOF() .AND. X3_ARQUIVO == cAlias
	For X := 1 TO LEN(aCampos)
		cCampos := Alltrim(aCampos[X])
		
		IF dbSeek(cCampos,.T.) 
			IF cNivel >= GetSX3Cache(cCampos, "X3_NIVEL")
				// Objetos normais que utilizam os dados completo do dicion�rio.
				If nTipoArray = 1
					AADD(aHeaderA, { TRIM(X3Titulo()),;
					GetSX3Cache(cCampos, "X3_CAMPO"),;
					GetSX3Cache(cCampos, "X3_PICTURE"),;
					IIF(GetSX3Cache(cCampos, "X3_TAMANHO") > 40 .AND. Alltrim(GetSX3Cache(cCampos, "X3_CAMPO")) != "ZM2_CHAVE",40, GetSX3Cache(cCampos, "X3_TAMANHO")),;
					GetSX3Cache(cCampos, "X3_DECIMAL"),;
					GetSX3Cache(cCampos, "X3_VALID"),;
					GetSX3Cache(cCampos, "X3_USADO"),;
					GetSX3Cache(cCampos, "X3_TIPO"),;
					GetSX3Cache(cCampos, "X3_F3"),;
					GetSX3Cache(cCampos, "X3_CONTEXT")}) 
					// Utilizado somente MsSelect
				ElseIf nTipoArray == 2
					AADD( aHeaderA, { GetSX3Cache(cCampos, "X3_CAMPO"),;
					,;
					TRIM(X3Titulo()),;
					GetSX3Cache(cCampos, "X3_PICTURE"),})
					// Utilizado Para cri��o de arquivos de trabalho.
				ElseIF nTipoArray == 3
					AADD( aHeaderA, { GetSX3Cache(cCampos, "X3_CAMPO"),;
					GetSX3Cache(cCampos, "X3_TIPO"),;
					GetSX3Cache(cCampos, "X3_TAMANHO"),;
					GetSX3Cache(cCampos, "X3_DECIMAL")})			   
				ElseIF nTipoArray == 4
					AADD( aHeaderA, { TRIM(X3Titulo()),;
					&("{| | "+ Alltrim(cAlias) +"->"+Alltrim(GetSX3Cache(cCampos, "X3_CAMPO"))+" }"),;
					Alltrim(GetSX3Cache(cCampos, "X3_PICTURE")),;
					IIF(GetSX3Cache(cCampos, "X3_TAMANHO") > 40 .AND. Alltrim(GetSX3Cache(cCampos, "X3_CAMPO")) != "ZM2_CHAVE",40, GetSX3Cache(cCampos, "X3_TAMANHO")),;
					IIF(GetSX3Cache(cCampos, "X3_TIPO") == "N", "RIGHT","CENTER"),;
					.F.})			   
					// AADD(aHeaderA,{"ST"     ,{|| GetStatus() 		}	,"@!"	,"CENTER"	,02		,.T.})			        				        	
				EndIF
			ENDIF
		Endif
	Next nI


	RestArea(aArea)
return aHeaderA



Static Function PosCampo(cCampo)
	Local nPos	:= 0

	nPos := Ascan(aCampos,Alltrim(cCampo))

	//RestArea(aArea)
Return nPos


//LPM 2012-04-16 - Fun��o para montagem do Cabe�alho. 
//*** Fun��o MontDados - Monta a consulta e preenche a array.
STATIC FUNCTION MontDados(cZE1Reg, cZEDReg)
	Local cEOL		:= chr(13) + chr(10)
	Local aColsA	:= {}
	Local nI		:= 0

	// Eetua a consulta 

	If Select("QRY") > 0 
		QRY->(DBCLOSEAREA())
	EndIF

	cQry := " SELECT DISTINCT B1.B1_COD, B1.B1_DESC, B1.B1_TIPO, B1.B1_XPGAMER, B1_XPGACAT, ISNULL(B1.R_E_C_N_O_,0) SB1REG " + cEOL
	cQry += " FROM "+ RetSqlName("SB1") +" (NOLOCK) B1 " + cEOL
	cQry += " WHERE B1.D_E_L_E_T_='' AND B1.B1_FILIAL = '"+ xFilial("SB1") +"' AND B1.B1_TIPO NOT IN ('MO','MM','MC','IM','SV','MP','ME','') " + cEOL
	cQry += " 		AND B1.B1_COD  BETWEEN  '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' " + cEOL
	cQry += " 		AND B1.B1_TIPO BETWEEN  '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"' " + cEOL
	// Produtos bloqueados.
	IF MV_PAR05 == 2
		cQry += " 		AND B1.B1_MSBLQL ='1' " + cEOL
	elseIF MV_PAR05 == 3
		cQry += " 		AND B1.B1_MSBLQL !='1' " + cEOL
	ENDIF
	// Produtos sem requisito de mercado.
	IF MV_PAR06 == 2
		cQry += " 		AND B1.B1_XPGAMER !='' " + cEOL
	ElseIf MV_PAR06 == 3
		cQry += " 		AND B1.B1_XPGAMER ='' " + cEOL
	ENDIF
	cQry += " ORDER BY B1.B1_COD, B1.B1_DESC; " + cEOL

	TcQuery cQry alias "QRY" new
	//TCSETFIELD("QRY","YA_CODGI","C")

	Count TO nCont

	QRY->(DBGOTOP())

	IF nCont != 0
		WHILE qry->(!EOF())
			AADD( aColsA, Array(LEN(aHeaderBco) + 1 ) )	
			FOR nI := 1 TO LEN(aHeaderBco)

				If nI == 1
					if Alltrim(QRY->B1_XPGAMER) == Alltrim(cZE1Reg) .and. Alltrim(QRY->B1_XPGACAT) == Alltrim(cZEDReg)
						aColsA[LEN(aColsA),nI] := oOk
					else
						aColsA[LEN(aColsA),nI] := oNO
					endif
				Else
					aColsA[LEN(aColsA),nI] := &("QRY->"+alltrim(aHeaderBco[nI,2])) 	
				EndIf
			Next nI

			aColsA[Len(aColsA), Len(aHeaderBco) +1 ] := .F.
			QRY->(dbSkip())
		END		

	ELSE
		AADD(aColsA, Array(LEN(aHeaderBco)+1))
		FOR nI := 1 TO LEN(aHeaderBco)
			If !"OK"$aHeaderBco[nI,2]
				aColsA[1, nI] := CriaVar(aHeaderBco[nI,2], .F.)
			Else
				aColsA[LEN(aColsA),nI] := oNO
			EndIf
		NEXT nI                                       

		aColsA[1, LEN(aHeaderBco)+1] := .F.
	ENDIF

	If Select("QRY") > 0 
		DBCLOSEAREA("QRY")
	EndIF

RETURN aColsA
