#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "Rwmake.ch"
#Include "Tbiconn.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �              �Autor  �Everson          �Data �  09/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Interface para apontamento de motivo de cliente sem compra. ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADVEN035P() // U_ADVEN035P()

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//����������������������������������������������������������������
	Local cDtIniFim	:= GetMv("MV_#PZCSCP")
	Local aDtIniFim	:= {}
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Interface para apontamento de motivo de cliente sem compra.')
	
	//
	logAcesso("PREENCHIMENTO DE AN�LISE DE CLIENTE SEM COMPRAS")
	
	//Remove espa�os em branco.
	cDtIniFim := Alltrim(cValToChar(cDtIniFim))
	
	//Verifica se o par�metro est� preenchido.
	If Empty(cDtIniFim)
		MsgStop("O par�metro de datas limites n�o est� preenchido(MV_#PZCSCP).","Fun��o ADVEN035P")
		Return Nil
		
	EndIf
	
	//Transforma string em vetor.
	aDtIniFim := StrToKarr(cDtIniFim,"/")
	
	//Valida as informa��es do vetor.
	If Len(aDtIniFim) <> 2
		MsgStop("Por favor, verifique se o par�metros de datas limites est� preenchido corretamente(MV_#PZCSCP).","Fun��o ADVEN035P")
		Return Nil
		
	EndIf
	
	//Valida a data atual com os par�metros de data inicial e final das an�lises a serem realizadas.
	If (Date() < SToD(cValToChar(aDtIniFim[1]))) .Or. (Date() > SToD(cValToChar(aDtIniFim[2])))
		MsgStop("N�o h� an�lise a ser feita.","Fun��o ADVEN035P")
		Return Nil
		
	EndIf
	
	//Monta tela para ser feita a an�lise de clientes sem compras.
	telaAnalise(aDtIniFim[1],aDtIniFim[2])
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �telaAnalise      �Autor  �Everson       �Data �  09/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Interface para an�lise de clientes sem compras.             ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function telaAnalise(cDtPrDe,cDtPrAt)

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//����������������������������������������������������������������
	Local cVendedor		:= ""
	Local aDados			:= ""
	Local oAnalise	
	Local aHAnalise	  	:= {}
	Local aColsAnalise 	:= {}
	Local aAltAnalise		:= {}
	
	//Cria objeto MsDialog.
	oDlgAnalise:= MsDialog():Create()
	oDlgAnalise:cName     := "oDlgAnalise"
	oDlgAnalise:cCaption  := "An�lise de Clientes sem Compras"
	oDlgAnalise:nLeft     := 34
	oDlgAnalise:nTop      := 222
	oDlgAnalise:nWidth    := 1100
	oDlgAnalise:nHeight   := 550
	oDlgAnalise:lShowHint := .F.
	oDlgAnalise:lCentered := .T.
	
	//Cria bot�o de cancelamento de cria��o de OS.
	oSBtn02:= SBUTTON():Create(oDlgAnalise)
	oSBtn02:cName := "oSBtn02"
	oSBtn02:cCaption := "Encerrar"
	oSBtn02:nLeft := 1037
	oSBtn02:nTop := 495
	oSBtn02:nWidth := 50
	oSBtn02:nHeight := 20
	oSBtn02:lShowHint := .F.
	oSBtn02:lReadOnly := .F.
	oSBtn02:Align := 0
	oSBtn02:lVisibleControl := .T.
	oSBtn02:bAction := {||oDlgAnalise:End()}
	
	//Cria bot�o de cancelamento de cria��o de OS.
	oSBtn03:= SBUTTON():Create(oDlgAnalise)
	oSBtn03:cName := "oSBtn03"
	oSBtn03:cCaption := "Legenda"
	oSBtn03:nLeft := 005
	oSBtn03:nTop := 495
	oSBtn03:nWidth := 120
	oSBtn03:nHeight := 20
	oSBtn03:lShowHint := .F.
	oSBtn03:lReadOnly := .F.
	oSBtn03:Align := 0
	oSBtn03:lVisibleControl := .T.
	oSBtn03:bAction := {||lgdAgenda()}
	
	//Cria Header dos clientes selecionados.
	Aadd(aHAnalise,{" "			,"LEG"    , "@BMP"	,01,0,.T.,"","","","R","","",.F.,"V","","","",""})
	//Aadd(aHAnalise,{"Carteira"	,"CARTEI"	,"@!" 	  	,TamSX3("A3_COD")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"PDV"		,"CODCLI"	,"@!" 	  	,TamSX3("A1_COD")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"Loja"		,"LOJA"	,"@!" 	  	,TamSX3("A1_LOJA")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"Rede"		,"REDE"	,"@!"	  	,TamSX3("A1_REDE")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"RSocial"	,"RSOCIAL"	,"@!"	  	,TamSX3("A1_NOME")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"Ender."		,"ENDER"	,"@!"	  	,TamSX3("A1_END")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"Bairro"		,"BAIRRO"	,"@!"	  	,TamSX3("A1_BAIRRO")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"Munic."		,"MUNICIP"	,"@!"	  	,TamSX3("A1_MUN")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"Telef."		,"TELEF"	,"@!"	  	,TamSX3("A1_TEL")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"Contato"	,"CONTATO"	,"@!"	  	,TamSX3("A1_CONTATO")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"Dt.Cad."	,"DTCAD"	,"@!"	  	,10,0,"","","C","",""})
	Aadd(aHAnalise,{"Ult.Comp."	,"DTULCOM"	,"@!"	  	,10,0,"","","C","",""})
	Aadd(aHAnalise,{"Dt.Reat."	,"DTREAT"	,"@!"	  	,10,0,"","","C","",""})
	Aadd(aHAnalise,{"E-mail"		,"EMAIL"	,"@!"	  	,TamSX3("A1_EMAIL")[1],0,"","","C","",""})
	Aadd(aHAnalise,{"Reg."		,"REGIS"	,"@!"	  	,15,0,"","","C","",""})
	
	oAnalise := MsNewGetDados():New(005,004,230,545,,"Allwaystrue()","Allwaystrue()","",aAltAnalise,Nil,999,Nil,Nil,Nil,oDlgAnalise,aHAnalise,@aColsAnalise)
	oAnalise:oBrowse:bLDblClick := {||telaDeEdicao(oAnalise,aHAnalise,cDtPrDe,cDtPrAt)}
	
	//Exibe a janela.
	oDlgAnalise:Activate(,,,.T.,{||.T.},,{||CursorWait(),carregarDados(oAnalise,aHAnalise,cDtPrDe,cDtPrAt)})
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �carregarDados    �Autor  �Everson       �Data �  09/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Carregar dados.                                             ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function carregarDados(oAnalise,aHAnalise,cDtPrDe,cDtPrAt)

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//����������������������������������������������������������������
	Local cQuery	  := scriptSql(cDtPrDe,cDtPrAt)
	Local oVermelho := LoadBitmap(GetResources(),"BR_VERMELHO")
	Local oVerde 	  := LoadBitmap(GetResources(),"BR_VERDE")
	Local xLegenda  := ""
	
	//Remove os dados da aCols.
	oAnalise:aCols := {}
	
	//Verifica se o alias j� existe.
	If Select("REGISTROS") > 0
		REGISTROS->(DbCloseArea())
		
	EndIf
	
	//Executa consulta no BD.
	TcQuery cQuery New Alias "REGISTROS"
	
	DbSelectArea("REGISTROS")
	REGISTROS->(DbGoTop())
	
	While ! REGISTROS->(Eof())
		
		If Empty(Alltrim(cValToChar(REGISTROS->MOT)))
			xLegenda := oVermelho
				
		Else
			xLegenda := oVerde
			
		EndIf
		
	
			Aadd(oAnalise:aCols , Array(Len(aHAnalise)+1) )
			oAnalise:aCols[Len(oAnalise:aCols), Len(oAnalise:aCols[1]) ] := .F.
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "LEG"    })] := xLegenda
			//oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "CARTEI" })] := REGISTROS->CART
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "CODCLI" })] := REGISTROS->PDV
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "LOJA"   })] := REGISTROS->LOJA
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "REDE"   })] := REGISTROS->REDE
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "RSOCIAL"})] := REGISTROS->RSOCIAL
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "ENDER"  })] := REGISTROS->ENDERECO
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "BAIRRO" })] := REGISTROS->BAIRRO
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "MUNICIP"})] := REGISTROS->MUNICIPIO
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "TELEF"  })] := REGISTROS->TELEFONE
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "CONTATO"})] := REGISTROS->CONTATO
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "DTCAD"  })] := REGISTROS->DATA_CAD
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "DTULCOM"})] := REGISTROS->ULT_COM
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "DTREAT" })] := REGISTROS->DATA_REAT
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "EMAIL"  })] := REGISTROS->E_MAIL
			oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "REGIS"  })] := cValToChar(REGISTROS->REC)
	
		REGISTROS->(DbSkip())
		
	EndDo
	
	If Len(oAnalise:aCols) == 0
	
		Aadd(oAnalise:aCols , Array(Len(aHAnalise)+1) )
		oAnalise:aCols[Len(oAnalise:aCols), Len(oAnalise:aCols[1]) ] := .F.
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "LEG"    })] := ""
		//oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "CARTEI" })] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "CODCLI" })] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "LOJA"   })] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "REDE"   })] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "RSOCIAL"})] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "ENDER"  })] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "BAIRRO" })] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "MUNICIP"})] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "TELEF"  })] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "CONTATO"})] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "DTCAD"  })] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "DTULCOM"})] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "DTREAT" })] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "EMAIL"  })] := ""
		oAnalise:aCols[Len(oAnalise:aCols),Ascan(aHAnalise,{|x| AllTrim(x[2]) == "REGIS"  })] := ""
	
	EndIf
	
	DbCloseArea("REGISTROS")
	
	oAnalise:Refresh()

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �telaDeEdicao     �Autor  �Everson       �Data �  09/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Preenchimento do motivo e n�o compra do cliente.            ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function telaDeEdicao(oAnalise,aHAnalise,cDtPrDe,cDtPrAt)

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//����������������������������������������������������������������
	Local oButton1
	Local oButton2
	Local oComboBo1
	Local cComboBox
	Local aMotivos	:= {}
	Local oGet1
	Local cGet1 := ""
	Local oGet2
	Local cGet2 := ""
	Local oGet3
	Local cGet3 := ""
	Local oGet4
	Local cGet4 := ""
	Local oGet5
	Local cGet5 := ""
	Local oGroup1
	Local oSay1
	Local oSay2
	Local oSay3
	Local oSay4
	Local oSay5
	Local oSay6
	Local oSay7
	Local oSay8
	Local oDlg
	Local aMotEObs	:= {}
	Local oGet6
	Local cGet6
	Local oSay9
	Local oGet7
	Local cGet7
	Local oGet8
	Local cGet8
	Local oSay10
	Local oSay11
	Local oGet11
	Local cGet11
	
	cGet1 := oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "CODCLI"})]
	cGet3 := oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "REDE"})]
	cGet2 := oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "RSOCIAL"})]
	cGet4 := oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "LOJA"})]
	cGet6 := oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "ENDER"})]
	cGet7 := oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "BAIRRO"})]
	cGet8 := oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "MUNICIP"})]
	cGet11:= oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "CONTATO"})]
	
	aMotEObs := carrMoteObs(oAnalise,aHAnalise)
	
	//
	If Len(aMotEObs) > 0
		cComboBox	:= aMotEObs[1][1]
		cGet5		:= aMotEObs[1][2]
		
	EndIf
	
	//Obt�m os motivos de n�o haver compras.
	aMotivos := motivosNaoCompra()

  DEFINE MSDIALOG oDlg TITLE "" FROM 000, 000  TO 450, 445 COLORS 0, 16777215 PIXEL Style 128
    
    @ 004, 018 SAY oSay5 PROMPT "Por favor, informe o motivo pelo qual o cliente n�o efetuou compras no per�odo." SIZE 191, 014 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 021, 008 GROUP oGroup1 TO 206, 216 OF oDlg COLOR 0, 16777215 PIXEL
    
    @ 023, 012 SAY oSay1 PROMPT "C�digo:" SIZE 030, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 034, 012 MSGET oGet1 VAR cGet1 SIZE 032, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    
    @ 023, 061 SAY oSay2 PROMPT "Loja:" SIZE 029, 010 OF oDlg COLORS 0, 16777215 PIXEL
    @ 034, 107 MSGET oGet4 VAR cGet3 SIZE 032, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    
    @ 023, 108 SAY oSay3 PROMPT "Rede:" SIZE 031, 009 OF oDlg COLORS 0, 16777215 PIXEL
    @ 034, 059 MSGET oGet3 VAR cGet4 SIZE 032, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    
    @ 051, 011 SAY oSay4 PROMPT "Raz�o Social:" SIZE 092, 011 OF oDlg COLORS 0, 16777215 PIXEL
    @ 063, 011 MSGET oGet2 VAR cGet2 SIZE 196, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    
    @ 079, 011 SAY oSay8 PROMPT "Endere�o:" SIZE 092, 011 OF oDlg COLORS 0, 16777215 PIXEL
    @ 090, 011 MSGET oGet6 VAR cGet6 SIZE 130, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    
    @ 079, 146 SAY oSay9 PROMPT "Bairro:" SIZE 092, 011 OF oDlg COLORS 0, 16777215 PIXEL
    @ 090, 146 MSGET oGet7 VAR cGet7 SIZE 067, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    
    @ 109, 012 SAY oSay10 PROMPT "Cidade:" SIZE 068, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 119, 012 MSGET oGet8 VAR cGet8 SIZE 130, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    
    @ 109, 146 SAY oSay11 PROMPT "Contato:" SIZE 068, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 119, 146 MSGET oGet11 VAR cGet11 SIZE 067, 010 OF oDlg COLORS 0, 16777215 PIXEL When .F.
    
    @ 138, 012 SAY oSay7 PROMPT "Motivo:" SIZE 068, 008 OF oDlg COLORS 0, 16777215 PIXEL
    @ 148, 012 MSCOMBOBOX oComboBo1 VAR cComboBox ITEMS aMotivos SIZE 088, 010 OF oDlg COLORS 0, 16777215 PIXEL
    
    @ 165, 012 SAY oSay6 PROMPT "Observa��es:" SIZE 041, 009 OF oDlg COLORS 0, 16777215 PIXEL

    @ 175, 012 GET oGet5 VAR cGet5 MEMO OF oDlg SIZE 200,025 PIXEL
    
    //
    @ 208, 124 BUTTON oButton1 PROMPT "Ok"       SIZE 040, 014 OF oDlg PIXEL Action(ok_Edicao(oDlg,oAnalise,aHAnalise,cComboBox,cGet5,cDtPrDe,cDtPrAt))
    @ 208, 177 BUTTON oButton2 PROMPT "Cancelar" SIZE 040, 014 OF oDlg PIXEL Action(oDlg:End())
    

  ACTIVATE MSDIALOG oDlg CENTERED
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �motivosNaoCompra �Autor  �Everson       �Data �  09/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Confirmou edi��o dos dados.                                 ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function motivosNaoCompra()

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//���������������������������������������������������������������� 
	Local cQuery	:= ""
	Local aRetorno:= {}
	
	Aadd(aRetorno,"")
	
	//Monta script sql.
	cQuery := ""
	cQuery += " SELECT * " 
	cQuery += " FROM " 
	cQuery += " " + RetSqlName("SX5") + " AS SX5 " 
	cQuery += " WHERE " 
	cQuery += " SX5.D_E_L_E_T_ = '' " 
	cQuery += " AND X5_FILIAL = '" + xFilial("SX5") + "' " 
	cQuery += " AND X5_TABELA = 'ZY' AND X5_DESCSPA = '1' ORDER BY CAST(X5_CHAVE AS NUMERIC) " 
	
	//Checa se o alias existe.
	If Select("MOT_NC") > 0
		MOT_NC->(DbCloseArea())
		
	EndIf
	
	//Executa consulta no BD.
	TcQuery cQuery New Alias "MOT_NC"
	
	
	//Preenche vari�vel de retorno.
	DbSelectArea("MOT_NC")
	MOT_NC->(DbGoTop())
	
	While ! MOT_NC->(Eof())
		
		Aadd(aRetorno,Alltrim(cValToChar(MOT_NC->X5_CHAVE)) + "=" +	Alltrim(cValToChar(MOT_NC->X5_DESCRI)))
		
		MOT_NC->(DbSkip())
		
	EndDo
	
	DbCloseArea("MOT_NC")

Return aRetorno
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ok_Edicao        �Autor  �Everson       �Data �  09/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Confirmou edi��o dos dados.                                 ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ok_Edicao(oTela,oAnalise,aHAnalise,cMotivo,cObs,cDtPrDe,cDtPrAt)

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//����������������������������������������������������������������
	Local nLinha    := Val(cValToChar(oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "REGIS"})]))
	Local oVermelho := LoadBitmap(GetResources(),"BR_VERMELHO")
	Local oVerde 	  := LoadBitmap(GetResources(),"BR_VERDE")
	Local xLegenda  := ""
	
	DbSelectArea("ZBI")
	ZBI->(DbGoTop())
	ZBI->(DbGoto(nLinha))
	
	RecLock("ZBI",.F.)
		Replace ZBI->ZBI_MOTIVO With cMotivo
		Replace ZBI->ZBI_OBS	   With cObs
	MsUnlock()
	
	If Empty(Alltrim(cValToChar(cMotivo)))
		xLegenda := oVermelho
		
	Else
		xLegenda := oVerde
		
	EndIf
	
	oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "LEG"})] := xLegenda
	oAnalise:Refresh()
	
	//Atualiza o objeto oAnalise.
	//carregarDados(oAnalise,aHAnalise,cDtPrDe,cDtPrAt)
	
	oTela:End()

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �carrMoteObs      �Autor  �Everson       �Data �  09/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Obt�m motivo e observa��es do cliente selecionado.          ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function carrMoteObs(oAnalise,aHAnalise)
	
	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//����������������������������������������������������������������
	Local aArea		:= GetArea()
	Local aRetorno	:= {}
	Local nLinha		:= Val(cValToChar(oAnalise:aCols[oAnalise:nat][Ascan(aHAnalise,{|x| AllTrim(x[2]) == "REGIS"})]))
	
	DbSelectArea("ZBI")
	ZBI->(DbGoTop())
	ZBI->(DbGoto(nLinha))
	
	Aadd(aRetorno,{ZBI->ZBI_MOTIVO,ZBI->ZBI_OBS})
	
	RestArea(aArea)
	
Return aRetorno
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �scriptSql        �Autor  �Everson       �Data �  09/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Obt�m dados para an�lise.                                   ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function scriptSql(cDtPrDe, cDtPrAt)

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//����������������������������������������������������������������
	Local cQuery	:= ""
	Local cUsuario := Alltrim(cValToChar(__CUSERID))

	cQuery := ""
	cQuery += " SELECT " 
		cQuery += " A1_COD AS 'PDV',   " 
		cQuery += " A1_LOJA AS 'LOJA',   " 
		cQuery += " A1_REDE AS 'REDE',   " 
		cQuery += " A1_NOME AS 'RSOCIAL',   " 
		cQuery += " A1_VEND AS 'CART',   " 
		cQuery += " A1_END AS 'ENDERECO',   " 
		cQuery += " A1_MUN AS 'MUNICIPIO',   " 
		cQuery += " A1_BAIRRO AS 'BAIRRO',   " 
		cQuery += " A1_DDD AS 'DDD',   " 
		cQuery += " A1_TEL AS 'TELEFONE',   " 
		cQuery += " A1_CONTATO AS 'CONTATO',   " 
		cQuery += " CASE WHEN A1_ULTCOM IS NULL OR A1_ULTCOM = '' THEN '' ELSE CONVERT(VARCHAR(10),CAST(A1_ULTCOM AS DATE),103) END AS 'ULT_COM',   " 
		cQuery += " A1_EMAIL AS 'E_MAIL',   " 
		cQuery += " CASE WHEN A1_DTCAD IS NULL OR A1_DTCAD = '' THEN '' ELSE CONVERT(VARCHAR(10),CAST(A1_DTCAD AS DATETIME),103) END AS 'DATA_CAD',   " 
		cQuery += " CASE WHEN A1_DTREAT IS NULL OR A1_DTREAT = '' THEN '' ELSE CONVERT(VARCHAR(10),CAST(A1_DTREAT AS DATETIME),103) END AS 'DATA_REAT',   " 
		cQuery += " CASE WHEN A1_MSBLQL = '1' THEN 'BLOQ' ELSE 'ATIVO' END AS 'STATUS', ZBI_MOTIVO AS 'MOT', ZBI.R_E_C_N_O_ AS REC " 
	cQuery += " FROM " 
		cQuery += " " + RetSqlName("ZBI") + " AS ZBI INNER JOIN " 
		cQuery += " " + RetSqlName("SA1") + " AS SA1 ON " 
		cQuery += " ZBI_CODCLI = A1_COD " 
		cQuery += " AND ZBI_LOJA = A1_LOJA INNER JOIN  " 
		cQuery += " " + RetSqlName("SA3") + " AS SA3 ON " 
		cQuery += " A3_COD = ZBI_VEND " 
	cQuery += " WHERE " 
		cQuery += " ZBI.D_E_L_E_T_ = '' " 
		cQuery += " AND SA1.D_E_L_E_T_ = '' " 
		cQuery += " AND SA3.D_E_L_E_T_ = '' "
		cQuery += " AND ZBI_DTPRDE = '" + Alltrim(cValToChar(cDtPrDe)) + "' " 
		cQuery += " AND ZBI_DTPRAT = '" + Alltrim(cValToChar(cDtPrAt)) + "' " 
		cQuery += " AND A3_CODUSR = '" + cUsuario + "' ORDER BY A1_COD "

Return cQuery
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �lgdAgenda         � Autor � Everson � Data �  09/11/2016    ���
�������������������������������������������������������������������������͹��
���Descricao �Legenda da tela de an�lise de clientes.                     ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function lgdAgenda()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
     Local cTitulo := "Legenda"
     Local aLegenda:= {}
     
     Aadd(aLegenda, {"BR_VERMELHO" ,"N�o Analisado"})
     Aadd(aLegenda, {"BR_VERDE"    ,"Analisado"})
     
     BrwLegenda("Legenda",cTitulo,aLegenda)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �logAcesso         � Autor � Everson � Data �  16/06/2017    ���
�������������������������������������������������������������������������͹��
���Descricao �Log de acesso de rotina.                                    ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 035397.                                             ���
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
		ZBE->ZBE_FILIAL := xFilial("SE1")
		ZBE->ZBE_DATA	:= Date()
		ZBE->ZBE_HORA	:= cValToChar(Time())
		ZBE->ZBE_USUARI	:= cUserName
		ZBE->ZBE_LOG	:= "ACESSO A ROTINA " + cRotina
		ZBE->ZBE_MODULO	:= "COMERCIAL"
		ZBE->ZBE_ROTINA	:= "ADVEN035P"
	MsUnlock()
	
	RestArea(aArea)
	
Return Nil