#Include "Protheus.ch"
#Include "RwMake.ch"
#Include "Totvs.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"
#Include "Fileio.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADFIS019P   �Autor  �Everson           � Data �04/07/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Pend�ncias de Devolu��o Rom. Log�stica.                     ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 036092.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADFIS019P() // U_ADFIS019P()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local oDlg  
	
	Local oPnl1
	Local oPnl2
	Local oPnl3
	Local bMuda		:= {|| oPnl1:lVisibleControl := (oTTabs:nOption == 1)}
	
	Local oDadosNFPen
	Local oDadosD
	Local oDadosDi
	
	Local aAltDr	:= {}
	Local aHNFPen		:= {}
	Local aColsDr	:= {}
	
	Local aAltDd	:= {}
	Local aHDd		:= {}
	Local aColsDd	:= {}
	
	Local aAltDi	:= {}
	Local aHDi		:= {}
	Local aColsDi	:= {}
	
	Local oGroup1
	Local oCSV
	Local oRel
	Local oFechar
	
	Local oTxtPnl1
	Local oTxtPnl2
	Local oTxtPnl3
	
	Local oNFIni
	Local oNFFim
	
	Local oExMot
	
	Local oFont := TFont():New(,,-15,.T.)
	
	Private cNFIni  := Space(9)
	Private cNFFim	:= "999999999"
	
	Private cExMot	:= Space(200)
	
	Private dDtIni := SToD(cValToChar(Year(Date()))+"0101")
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Pend�ncias de Devolu��o Rom. Log�stica.')
	
	//
	logAcesso("PENDENCIAS DEVOLUCAO ROM LOGISTICA")
	
	//
	oDlg		   := MsDialog():Create()
	oDlg:cName     := "oDlg"
	oDlg:cCaption  := "Pend�ncias de Devolu��o Rom. Log�stica"
	oDlg:nLeft     := 34
	oDlg:nTop      := 222
	oDlg:nWidth    := 1200
	oDlg:nHeight   := 560
	oDlg:lShowHint := .F.
	oDlg:lCentered := .T.
	
		//
		oDtIni  := TGet():New(002,005,{|u|If(PCount() == 0,dDtIni,dDtIni := u)},oDlg,050,010,"@D", {|| NaoVazio() },0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtIni",,,,.T.,,,"Data inicial devolu��o:",1) 
		
		oNFIni	:= TGet():New(002,063,{|u|If(PCount() == 0,cNFIni,cNFIni := u)},oDlg,050,010,"@E 999999999",Nil,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cNFIni",,,,.T.,,,"Nota de:",1) 
		
		oNFFim	:= TGet():New(002,121,{|u|If(PCount() == 0,cNFFim,cNFFim := u)},oDlg,050,010,"@E 999999999", {|| NaoVazio() },0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cNFFim",,,,.T.,,,"Nota At�:",1) 
		
		oExMot	:= TGet():New(002,179,{|u|If(PCount() == 0,cExMot,cExMot := u)},oDlg,150,010,"@", {|| NaoVazio() },0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cExMot",,,,.T.,,,"Excluir Motivos:",1) 
		oExMot:bGotFocus := {|| getMotivo(@oExMot,@cExMot) }
		
		oAtlGrid := TButton():New(009,335,"Atualizar",oDlg,{|| MsAguarde({|| carrNFPen(@oDadosNFPen,@aHNFPen,dDtIni) },"Aguarde","Carregando dados...") },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
		
		//dDtFim := Date()
		//oDtFim := TGet():New(002,060,{|u|If(PCount() == 0,dDtFim,dDtFim := u)},oDlg,050,010,"@D",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"dDtFim",,,,.T.,,,"Data Fim:",1) 
	
		//
		aTab   := {'NF Faltantes'}
		oTTabs := TTabs():New(025,005,aTab,Nil,oDlg,Nil,CLR_HRED,Nil,.T.,Nil,590,223,Nil)
		oTTabs:SetOption(1)
		oTTabs:bAction := bMuda
		
		//
		oPnl1 := TPanel():New(001,001,"",oTTabs,,.T.,,CLR_BLACK,CLR_WHITE,588,211)
			
			oTxtPnl1 := TSay():New(005,005,{||'NF Faltantes'},oPnl1,,oFont,,,,.T.,CLR_RED,CLR_WHITE,200,20)
			
			Aadd(aHNFPen,{"Filial"     ,"ZD_FILIAL" ,"",TamSX3("ZD_FILIAL")[1]  , 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"Dt. Dev."   ,"ZD_DTDEV"  ,"",10, 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"NF Orig."   ,"ZD_NUMNF"  ,"",TamSX3("ZD_NUMNF")[1]   , 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"Sr Orig."   ,"ZD_SERIE"  ,"",TamSX3("ZD_SERIE")[1]   , 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"C�d. Cli."  ,"ZD_CODCLI" ,"",TamSX3("ZD_CODCLI")[1]  , 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"Loja"       ,"ZD_LOJA"   ,"",TamSX3("ZD_LOJA")[1]    , 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"Nome Cli."  ,"ZD_NOMECLI","",TamSX3("ZD_NOMECLI")[1] , 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"Pedido"     ,"ZD_PEDIDO" ,"",TamSX3("ZD_PEDIDO")[1]  , 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"Mot. Dev."  ,"ZD_DESCMOT","",TamSX3("ZD_DESCMOT")[1] , 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"Placa"      ,"ZD_PLACA"  ,"",TamSX3("ZD_PLACA")[1]   , 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"Roteiro"    ,"ZD_ROTEIRO","",TamSX3("ZD_ROTEIRO")[1] , 0,"","" ,"C","",""})
			Aadd(aHNFPen,{"Tp. Dev."   ,"ZD_DEVTOT" ,"",TamSX3("ZD_DEVTOT")[1]  , 0,"","" ,"C","",""})
			
			//
			oDadosNFPen := MsNewGetDados():New(020,001,210,587,,"Allwaystrue()","Allwaystrue()","",aAltDr,1,999,Nil,Nil,Nil,oPnl1,aHNFPen,@aColsDr)
			
		//
		oGroup1  := TGroup():Create(oDlg,250,005,265,595,"",,,.T.)
			oCSV 	 := TButton():New(253,010,"CSV",oDlg,{||  MsAguarde({|| grLRCCSV(oDadosNFPen,aHNFPen,"NFDEVFALT_" + cUserName + "_" + DToS(Date()) + "_" + StrTran(cValToChar(Time()),":","") + ".CSV")},"Aguarde","Gerando CSV...") },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
			oRel 	 := TButton():New(253,055,"Relat�rio",oDlg,{|| MsAguarde({|| gerRel(oDadosNFPen,aHNFPen,dDtIni) },"Aguarde","Gerando relat�rio") },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
			oFechar	 := TButton():New(253,550,"Fechar",oDlg,{|| oDlg:End() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
			oFechar:SetCss("QPushButton{background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #FF0000, stop: 1 #8C1717);color: white}")	
		
		//
		Eval(bMuda)
		
	oDlg:Activate(,,,.T.,{||.T.},,{|| MsAguarde({|| carrNFPen(@oDadosNFPen,@aHNFPen,dDtIni) },"Aguarde","Carregando dados...") })
	
	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �getMotivo      �Autor  �Everson        � Data �05/07/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Obt�m motivos de devolu��o.                                 ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 036092.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function getMotivo(oExMot,cExMot)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������		
	Local aArea		:= GetArea()
	Local cTitulo	:=""
	Local MvPar
	Local MvParDef	:=""
	Local nTam 		:= 2 
	Local nX 		:= 0
	Local nLen 		:= 0
	Local cQuery 	:= ""
	
	Private aGrupo	:={}
	
	//
	cQuery := ""
	cQuery += " SELECT "
	cQuery += " DISTINCT ZS_COD, ZS_DESCRI "
	cQuery += " FROM "
	cQuery += " " + RetSqlName("SZS") + " (NOLOCK) AS SZS "
	cQuery += " WHERE "
	cQuery += " SZS.D_E_L_E_T_ = '' "
	cQuery += " ORDER BY ZS_COD, ZS_DESCRI "
	
	//
	If Select("D_MDEV") > 0
		D_MDEV->(DbCloseArea())
		
	EndIf
	
	//
	TcQuery cQuery New Alias "D_MDEV"	
	D_MDEV->(DbGoTop())
	CursorWait()
	While ! D_MDEV->(Eof())
	
		Aadd(aGrupo,Alltrim(cValToChar(D_MDEV->ZS_COD)) + " - " + Alltrim(cValToChar(D_MDEV->ZS_DESCRI)))
		MvParDef += Alltrim(cValToChar(D_MDEV->ZS_COD))
		
		D_MDEV->(DbSkip())
		
	Enddo
	CursorArrow()
	                        
	//        
	If f_Opcoes(@MvPar,"C�digos de Devolu��o",aGrupo,MvParDef,12,49,.F., nTam, Len(aGrupo))
	
		mvpar := StrTran(mvpar, "*", "")
		nLen := Len(mvpar)-1
	
		For nX := 0 To nLen Step nTam
			mvpar := SubStr(mvpar, 1, nX+nTam+Int(nX/nTam))+","+SubStr(mvpar, nX+nTam+Int(nX/nTam)+1, Len(mvpar))
			
		Next nX
		
		_nTam := LEN(MVPAR)
		MVPAR := SUBSTR(MVPAR,1,_nTAM-1)
		
		cExMot := MVPAR
		oExMot:Refresh() 
	
	EndIf	
	
	//							 
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �gerRel      �Autor  �Everson           � Data �05/07/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera relat�rio.                                             ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 036092.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function gerRel(oDadosNFPen,aHNFPen,dDtIni)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������		
	Local aArea		:= GetArea()
	Local cGrvChart	:= ""
	Local i			:= 1
	Local w			:= 1
	Local nColuna	:= 2300
	Local nLinhas	:= 200
	Local nQtdLinha := 0
	Local oFont1 	:= TFont():New('Courier new',,-18,.T.)
	Local oFont2 	:= TFont():New('Courier new',,-12,.T.)
	Local oFont3 	:= TFont():New('Courier new',,-12,.T.)
	Local nPagina	:= 1
	
	//
	oFont1:Bold := .T.
	oFont3:Bold := .T.	

    // Monta objeto para impress�o
    oPrint := TMSPrinter():New("Pend�ncias de Devolu��o Rom. Log�stica")

    //
    oPrint:SetLandScape()
    
    // Inicia p�gina
    oPrint:StartPage() 
    
    //
    oPrint:Say(100,50,"Pend�ncias de Devolu��o Rom. Log�stica - ( data inicial " + DToC(dDtIni) + " ) - Pagina " + Alltrim(cValToChar(Transform(nPagina,"@E 999,999,999"))) ,oFont1)  
    oPrint:Say(175,50,"Emitido por " + cUserName + " em " + DToC(Date()) + " - " + cValToChar(Time()) ,oFont2) 
    oPrint:Say(250,50,"Qtd. NF: " + Alltrim(cValToChar(Transform(Len(oDadosNFPen:aCols),"@E 999,999,999"))) ,oFont3)
    
    //
    nLinhas  += 150
    nColunas := 100
    For w := 1 To Len(aHNFPen)
    		oPrint:Say(nLinhas,nColunas,Alltrim(cValToChar(aHNFPen[w][1])),oFont3)
    		
    		If Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_NOMECLI"
    			nColunas += 550
    			
    		ElseIf Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_DESCMOT"
    			nColunas += 450
    			
    		ElseIf Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_FILIAL" .Or. Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_LOJA" .Or. Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_SERIE"
    			nColunas += 185
    			
    		Else
    			nColunas += 250
    		
    		EndIf
    		
    Next w        
    
    //
    nLinhas  += 100
    nColunas := 100
    
    //
    For i := 1 To Len(oDadosNFPen:aCols)
    	
    	//
    	nQtdLinha++
    	
    	//
    	For w := 1 To Len(aHNFPen)
    		oPrint:Say(nLinhas,nColunas,Substr(Alltrim(cValToChar(oDadosNFPen:aCols[i][w])),1,16),oFont2)
    		
    		If Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_NOMECLI"
    			nColunas += 550
    			
    		ElseIf Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_DESCMOT"
    			nColunas += 450
    			
    		ElseIf Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_FILIAL" .Or. Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_LOJA" .Or. Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_SERIE"
    			nColunas += 185
    			
    		Else
    			nColunas += 250
    		
    		EndIf
    		
    	Next w
    	
    	//
    	nColunas := 100
    	
    	//
    	nLinhas += 50
    	
    	If nQtdLinha >= 35
    	
		    // Termina a p�gina
		    oPrint:EndPage()
		    
		    // Inicia p�gina
		    oPrint:StartPage()
		    
		    //
		    nPagina++
		    oPrint:Say(100,50,"Pend�ncias de Devolu��o Rom. Log�stica - ( data inicial " + DToC(dDtIni) + " ) - Pagina " + Alltrim(cValToChar(Transform(nPagina,"@E 999,999,999"))) ,oFont1)  
		    oPrint:Say(175,50,"Emitido por " + cUserName + " em " + DToC(Date()) + " - " + cValToChar(Time()) ,oFont2)  
		    oPrint:Say(250,50,"Qtd. NF: " + Alltrim(cValToChar(Transform(Len(oDadosNFPen:aCols),"@E 999,999,999"))) ,oFont3)
		    
		    //
		    nLinhas	 := 200
		    nLinhas  += 150
		    nColunas := 100
		    For w := 1 To Len(aHNFPen)
		    		oPrint:Say(nLinhas,nColunas,Alltrim(cValToChar(aHNFPen[w][1])),oFont3)
		    		
		    		If Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_NOMECLI"
		    			nColunas += 550
		    			
		    		ElseIf Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_DESCMOT"
		    			nColunas += 450
		    			
		    		ElseIf Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_FILIAL" .Or. Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_LOJA" .Or. Alltrim(cValToChar(aHNFPen[w][2])) == "ZD_SERIE"
		    			nColunas += 185
		    			
		    		Else
		    			nColunas += 250
		    		
		    		EndIf
		    		
		    Next w
		    
		    nLinhas  += 100
		    nColunas := 100
		    nQtdLinha := 0
    	
    	EndIf
    
    Next i
    
    // Termina a p�gina
    oPrint:EndPage()
                       
    // Mostra tela de visualiza��o de impress�o
    oPrint:Preview() 
    
    //
    MS_Flush() 
	
	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �carrNFPen   �Autor  �Everson           � Data �05/07/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Carrega registros de pend�ncias de NF.                      ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 036092.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function carrNFPen(oDadosNFPen,aHNFPen,dDtIni)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local cQuery	:= ""
	
	//
	oDadosNFPen:aCols := {}
	oDadosNFPen:Refresh()
	
	//
	cQuery := scripNFPen(dDtIni)
	cQuery += " ORDER BY ZD_FILIAL, ZD_NUMNF, ZD_SERIE, ZD_CODCLI, ZD_LOJA "
	
	//
	If Select("D_NFPEN") > 0
		D_NFPEN->(DbCloseArea())
		
	EndIf
	
	MsAguarde({||DBUseArea(.T., "TOPCONN", TCGenQry(NIL,NIL,cQuery),"D_NFPEN" , .F., .T. )},"Aguarde","Carregando dados...")
	DbSelectArea("D_NFPEN")
	D_NFPEN->(DbGoTop())
	If D_NFPEN->(Eof())
	
		Aadd(oDadosNFPen:aCols , Array(Len(aHNFPen) + 1) )
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols), Len(oDadosNFPen:aCols[1]) ] := .F.
		
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_FILIAL" })] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_DTDEV"  })] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_NUMNF"  })] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_SERIE"  })] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_CODCLI" })] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_LOJA"   })] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_NOMECLI"})] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_PEDIDO" })] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_DESCMOT"})] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_PLACA"  })] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_ROTEIRO"})] := ""
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_DEVTOT" })] := ""
			
	EndIf
	
	//
	While ! D_NFPEN->(Eof())

		Aadd(oDadosNFPen:aCols , Array(Len(aHNFPen) + 1) )
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols), Len(oDadosNFPen:aCols[1]) ] := .F.
		
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_FILIAL" })] := D_NFPEN->ZD_FILIAL
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_DTDEV"  })] := DToC(SToD(D_NFPEN->ZD_DTDEV))
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_NUMNF"  })] := D_NFPEN->ZD_NUMNF
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_SERIE"  })] := D_NFPEN->ZD_SERIE
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_CODCLI" })] := D_NFPEN->ZD_CODCLI
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_LOJA"   })] := D_NFPEN->ZD_LOJA
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_NOMECLI"})] := D_NFPEN->ZD_NOMECLI
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_PEDIDO" })] := D_NFPEN->ZD_PEDIDO
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_DESCMOT"})] := D_NFPEN->ZD_DESCMOT
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_PLACA"  })] := D_NFPEN->ZD_PLACA
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_ROTEIRO"})] := D_NFPEN->ZD_ROTEIRO
		oDadosNFPen:aCols[Len(oDadosNFPen:aCols),Ascan(aHNFPen,{|x| AllTrim(x[2]) == "ZD_DEVTOT" })] := D_NFPEN->ZD_DEVTOT
			
		D_NFPEN->(DbSkip())
		
	EndDo
	
	//
	oDadosNFPen:Refresh()
	
	//
	RestArea(aArea)
		
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �scripNFPen  �Autor  �Everson           � Data �05/07/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Script de registros pendentes de nf de devolu��o.           ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 036092.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function scripNFPen(dDtIni)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local aExtMot	:= {}
	
	//
	cQuery := ""
	cQuery += " SELECT  " 
	cQuery += " ZD_FILIAL, ZD_NUMNF, ZD_SERIE, ZD_CODCLI, ZD_LOJA, ZD_NOMECLI, ZD_PEDIDO, ZD_DEVTOT, ZD_DTDEV, ZD_DESCMOT, ZD_PLACA, ZD_ROTEIRO, SD1.D1_DOC, SD1.D1_SERIE " 
	cQuery += " FROM  " 
	cQuery += " " + RetSqlName("SZD") + " (NOLOCK) SZD " 
	cQuery += " LEFT OUTER JOIN " 
	cQuery += " ( " 
	cQuery += " SELECT  " 
	cQuery += " DISTINCT D1_FILIAL, D1_NFORI, D1_SERIORI, D1_DOC, D1_SERIE " 
	cQuery += " FROM  " 
	cQuery += " " + RetSqlName("SD1") + " (NOLOCK) SD1 " 
	cQuery += " WHERE  " 
	cQuery += " SD1.D_E_L_E_T_<>'*' " 
	cQuery += " AND D1_CF IN  " 
	cQuery += " ('1201','2201','1410','1208','2410','1910','2910','1202','2202','1949')  " 
	cQuery += " ) AS SD1 " 
	cQuery += " ON SZD.ZD_FILIAL = SD1.D1_FILIAL " 
	cQuery += " AND SZD.ZD_NUMNF = SD1.D1_NFORI " 
	cQuery += " AND SZD.ZD_SERIE = SD1.D1_SERIORI " 
	cQuery += " WHERE  " 
	cQuery += " SZD.D_E_L_E_T_ = '' " 
	cQuery += " AND ZD_DTDEV >= '" + DToS(dDtIni) + "'  " 
	cQuery += " AND ZD_DEVTOT IN ('T','P')  " 
	cQuery += " AND (SD1.D1_DOC IS NULL OR SD1.D1_DOC = '') " 
	cQuery += " AND ZD_NUMNF >= '" + Padl(Alltrim(cValToChar(cNFIni)),9,"0") + "' "
	cQuery += " AND ZD_NUMNF <= '" + Padl(Alltrim(cValToChar(cNFFim)),9,"0") + "' "
	
	//
	If ! Empty(Alltrim(cValToChar(cExMot)))
	
		aExtMot := StrToKarr(cExMot,",")
		
		cExMot := ""
		For i := 1 To Len(aExtMot)
			cExMot += "'" + Alltrim(cValToChar(aExtMot[i])) + "',"
		Next i
		
		cExMot := Alltrim(cValToChar(cExMot))
		cExMot := Substr(cExMot,1,Len(cExMot) - 1)
	
		cQuery += " AND ZD_MOTIVO NOT IN (" + Alltrim(cValToChar(cExMot)) + ") "
	
	EndIf
	
	//
	RestArea(aArea)

Return cQuery
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �grLRCCSV    �Autor  �Everson           � Data �05/07/2017   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera arquivo CSV.                                           ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 036092.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function grLRCCSV(oRegistros,aHReg,cArq)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������		
	Local aArea		:= GetArea()
	Local i			:= 1
	Local w			:= 1
	Local cDir		:= ""
	Local nHdl
	Local cEof		:= Chr(13) + Chr(10)
	Local cLin		:= ""
	
	cDir := cGetFile("Arquivo CSV.", "Selecione o diret�rio para salvar o CSV",,'C:\',.T.,GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_NETWORKDRIVE)
	
	//
	If Empty(Alltrim(cValToChar(cDir)))
		Return Nil
		
	EndIf
	
	//Cria o arquivo no disco.
	nHdl := FCreate(cDir + cArq,0)
	
	//Verifica se foi poss�vel criar o arquivo.
	If nHdl == -1
����	MsgAlert("O Arquivo n�o " + cArq + " pode ser criado:" + cEof + STR(FERROR()),"Fun��o grLRCCSV")
		Return Nil
		
	EndIf
	
	//
	cLin := ""
	For i := 1 To Len(aHReg)
		cLin += cValToChar(aHReg[i][1]) + ";"
	
	Next i
	
	cLin += cEof
	
	For i := 1 To Len(oRegistros:aCols)
	
		For w := 1 To Len(aHReg)
			
			If Alltrim(cValToChar(aHReg[w][8])) == "N"
			
				cLin += Transform(Val(cValToChar(oRegistros:aCols[i][w])),"@E 999,999,999.99") + ";"
				
			Else
				cLin += cValToChar(oRegistros:aCols[i][w]) + ";"
			
			EndIf
		
		Next w
		
		cLin += cEof
		
		FWrite(nHdl,cLin,Len(cLin))
		
		cLin := ""
	
	Next i
	
	//Fecha o arquivo.
	FClose(nHdl)
	
	WinExec("Explorer.exe" + Space(1) + cDir )
	
	MsgInfo("Arquivo gerado.","Fun��o grLRCCSV")
	
	RestArea(aArea)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �logAcesso         � Autor � Everson � Data �  06/07/2017    ���
�������������������������������������������������������������������������͹��
���Descricao �Log de acesso de rotina.                                    ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 036092.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function logAcesso(cRotina)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������		
	Local aArea		:= GetArea()
	
	cRotina := Alltrim(cValToChar(cRotina))

	//Log.
	RecLock("ZBE",.T.)
		ZBE->ZBE_FILIAL := xFilial()
		ZBE->ZBE_DATA	:= Date()
		ZBE->ZBE_HORA	:= cValToChar(Time())
		ZBE->ZBE_USUARI	:= cUserName
		ZBE->ZBE_LOG	:= "ACESSO A ROTINA " + cRotina
		ZBE->ZBE_MODULO	:= "FISCAL"
		ZBE->ZBE_ROTINA	:= "ADFIS019P"
	MsUnlock()
	
	RestArea(aArea)
	
Return Nil