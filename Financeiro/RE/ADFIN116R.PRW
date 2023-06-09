#INCLUDE "Protheus.ch"     
#INCLUDE "Topconn.ch"
#Define CRLF Chr(13) + Chr(10) //Ticket  90997 - Antonio Domingos    - 20/04/2023

/*/{Protheus.doc} User Function HCRFIBLT
	Relatorio de concilia��o de fornecedores. Entre SE5 e CT2
	
	@type  Function
	@author Ana Helena
	@since 11/07/2013
	@version 01
	@history chamado TI - Abel Babino - 02/07/2019 - Ch.atorio de concilia��o de fornecedores. Entre SE5 e CT2. Ch.Interno TI - Abel Babini - Considerar Var.Cambial no Contas � Pagar.
	@history chamado 8797  - Leonardo P. Monteiro - 02/07/2019 - Inclus�o de par�metro de exce��o para exclus�o de fornecedores (Governos, Prefeiuras e etc...) e criado para os tipos de t�tulos.
	@history chamado 63633 - Leonardo P. Monteiro - 12/11/2021 - Corre��o dos valores em segunda moeda.
	@history chamado 63633 - Leonardo P. Monteiro - 12/11/2021 - Melhoria e corre��es ap�s valida��o.
	@history chamado 72972 - Jonathan Carvalho    - 17/05/2022 - Adicionado With lock
	@history Ticket  72972 - Jonathan Carvalho    - 14/06/2022 - Alterado consulta para BeginSql para corre��o de erro.
	@history Ticket  75036 - Jonathan Carvalho    - 20/06/2022 - Incluido na linha 773 a fun��o %noparse% e na consulta with(nolock)
	@history Ticket  90181 - Antonio Domingos    - 16/03/2022 - RELATORIO DE CONC AUTOMATICA FORNECEDOR TRAVADO
	@history Ticket  90867 - Antonio Domingos    - 28/03/2022 - RELATORIO DE CONC AUTOMATICA FORNECEDOR - travado
	@history Ticket  90997 - Antonio Domingos    - 31/03/2023 - TITULOS NF'S 008551870 E 008564249
	@history Ticket  90997 - Antonio Domingos    - 08/05/2023 - TITULOS NF'S 008551870 E 008564249
/*/

User Function ADFIN116R()
	Local lEnd		 := .T.
	Private cAliSA2		:= Replace(GetNextAlias()+cValtochar(seconds()),".","")
	Private cAliSE2 	:= Replace(GetNextAlias()+cValtochar(seconds()),".","")
	Private cAliSE5 	:= Replace(GetNextAlias()+cValtochar(seconds()),".","")
	Private cAliCT2 	:= Replace(GetNextAlias()+cValtochar(seconds()),".","")

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio de concilia��o de fornecedores')

	cPerg   := PADR('RFORCON',10," ")
	PutSx1(cPerg,"01","Do Fornecedor          ?","Do Fornecedor          ?","Do Fornecedor          ?","mv_ch1","C",6 ,0,0,"G",""         ,"SA2","","","mv_par01",""      ,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"02","Ate Fornecedor         ?","Ate Fornecedor         ?","Ate Fornecedor         ?","mv_ch2","C",6 ,0,0,"G",""         ,"SA2","","","mv_par02",""      ,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"03","Loja de                ?","Loja de                ?","Loja de                ?","mv_ch3","C",2 ,0,0,"G",""         ,"","","","mv_par03",""      ,"","","","","","","","","","","","","","","")
	PutSx1(cPerg,"04","Loja Ate               ?","Loja Ate               ?","Loja Ate               ?","mv_ch4","C",2 ,0,0,"G",""         ,"","","","mv_par04",""      ,"","","","","","","","","","","","","","","")
	PutSX1(cPerg,"05","Data Contabil De "       ,"Data Contabil De "        ,"Data Contabil De "        ,"mv_ch5","D",08,0,0,"G","",""   ,"","","mv_par05" ,"","","","","","","","","","","","","","",""," ")
	PutSX1(cPerg,"06","Data Contabil Ate "      ,"Data Contabil Ate "       ,"Data Contabil Ate "       ,"mv_ch6","D",08,0,0,"G","",""   ,"","","mv_par06" ,"","","","","","","","","","","","","","",""," ")
	PutSX1(cPerg,"07","Data Base "      ,"Data Base "       ,"Data Base "       ,"mv_ch7","D",08,0,0,"G","",""   ,"","","mv_par07" ,"","","","","","","","","","","","","","",""," ")
	PutSX1(cPerg,"08","Tipo Relatorio","Tipo Relatorio"	,"Tipo Relatorio"            ,"mv_ch8","N",01,0,01,"C","","","","","mv_par08" ,"Analitico","Analitico","Analitico","","Sintetico","Sintetico","Sintetico","","","","","","","",""," ")
	PutSx1(cPerg,"09","Conta Contabil         ?","Conta Contabil         ?","Conta Contabil         ?","mv_ch9","C",20 ,0,0,"G",""         ,"CT1","","","mv_par09",""      ,"","","","","","","","","","","","","","","")
	
	Pergunte(cPerg,.F.)
	
	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	
	cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	cDesc2       := "de conciliacao de fornecedores."
	cDesc3       := "Conciliacao de Fornecedores"
	cPict        := ""
	titulo       := "Conciliacao de Fornecedores"
	Cabec1       := ""
	Cabec2       := ""
	imprime      := .T.
	aOrd := {}
	Private lAbortPrint  := .F.
	Private CbTxt        := ""
	Private limite       := 220
	Private tamanho      := "G"
	Private nomeprog     := "ADFIN116R"
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01
	Private wnrel        := "ADFIN116R"
	Private nLin         := 80
	Private nSA2TMP	 	 := 0
	Private nSE2TMP	 	 := 0
	Private nSE5MOV	 	 := 0
	Private nCT2TMP	 	 := 0
	Private nTotal		 := 0
	
	//Ticket 8797 - Leonardo P. Monteiro - 02/07/2019 - Inclus�o de par�metro de exce��o para exclus�o de fornecedores (Governos, Prefeiuras e etc...) e tipos de t�tulos.
	Private cTpExc		 := Formatin(SupergetMv("MV_XTIEXCC",,'NDF'),";")
	Private cFoExc		 := Formatin(SupergetMv("MV_XFOEXCC",,'014000'),";")
	Private cMVXFOEXCC	 := SupergetMv("MV_XFOEXCC",,'014000') //Ticket  90997 - Antonio Domingos - 31/03/2023
	Private cString 	 := "SE5"
	Private cDtIni		 := Dtoc(Date()) + "-"+Alltrim(Time())
	Private cDtFim		 := ""
	
	PRivate cTabTMP		 := ""
	Private oTMPSE5
	Private oTMPCT2
	Private oTMPANL
	Private oTMPSE2
	Private oProcess
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return
	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	
	//RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
	oProcess := MsNewProcess():New( {|lEnd| RunReport(@lEnd, Cabec1,Cabec2,Titulo,nLin) }, "Processando Relat�rio", "Importa��o dados, Aguarde...", .F. )
    oProcess:ACTIVATE()

	oTMPANL:DELETE()
Return


Static Function RunReport(lEnd, Cabec1,Cabec2,Titulo,nLin)
	Local _aStr4   	:= {}
	 
	
	dbSelectArea(cString)
	dbSetOrder(1)
	
	//SetRegua(nTotalReg)
	oProcess:setRegua1(7)

	If mv_par08 == 1 //Analitico
		Cabec1  := "FORNECEDOR                                FILIAL PREFIXO NUMERO  PARCELA TIPO   DT EMISSAO    DT MOVIMENTO    DT CONTABIL    SLD FINANC       SLD CONTABIL         DIFERENCA     "
	Else
		Cabec1  := "FORNECEDOR     RAZAO SOCIAL                         SLD FINANCEIRO        SLD CONTABIL         DIFERENCA     "
	Endif	
	Cabec2  := " "
	
	//���������������������������������������������������Ŀ                               	
	//� Tabelas Temporarias                               �
	//����������������������������������������������������� 
	
	//Tabela Temporaria para relatorio Analitico
	AADD(_aStr4,{'FILIAL'   ,"C",02,0})
	AADD(_aStr4,{'FORNECE'  ,"C",06,0})
	AADD(_aStr4,{'LOJA'     ,"C",02,0})
	AADD(_aStr4,{'PREFIXO'  ,"C",03,0})
	AADD(_aStr4,{'NUMERO'   ,"C",09,0})
	AADD(_aStr4,{'PARCELA'  ,"C",03,0})
	AADD(_aStr4,{'TIPO'     ,"C",03,0})	
	AADD(_aStr4,{'DATASE2'  ,"D",08,0})	
	AADD(_aStr4,{'DATASE5'  ,"D",08,0})
	AADD(_aStr4,{'DATACT2'  ,"D",08,0})
	AADD(_aStr4,{'VALORSE2' ,"N",15,4})
	AADD(_aStr4,{'VALORCT2' ,"N",15,4})
	AADD(_aStr4,{'DEBITO'   ,"C",20,0})
	AADD(_aStr4,{'CREDIT'   ,"C",20,0})
	AADD(_aStr4,{'TIPODOC'  ,"C",02,0})
	AADD(_aStr4,{'RECPAG'   ,"C",01,0})
	AADD(_aStr4,{'VLACRES'  ,"C",01,0})			
	
	/*
	_cArqTmp :=CriaTrab(_aStr4,.T.)
	DbUseArea(.T.,,_cArqTmp,"TMPANL",.F.,.F.)
	*/
	//_cIndex:="FORNECE+LOJA+FILIAL+PREFIXO+NUMERO+PARCELA+TIPO"
	/*
	_cIndex:="FORNECE+LOJA+FILIAL+NUMERO+PREFIXO+PARCELA+TIPO"
	IndRegua("TMPANL",_cArqTmp,_cIndex,,,"Criando Indices...")	
	*/
	oTMPANL := FWTemporaryTable():New("TMPANL")
	oTMPANL:SetFields(_aStr4)
	oTMPANL:AddIndex("01", {"FORNECE","LOJA","FILIAL","NUMERO","PREFIXO","PARCELA","TIPO"} )
	oTMPANL:Create()
	cTabTMP := oTMPANL:GetRealName()

	
	//���������������������������������������������������Ŀ                               	
	//� Monta Querys                                      �
	//�����������������������������������������������������
	oProcess:incRegua1("Consultado os dados (1/8)")
	fDados() 
	
	nSldFin  := 0          
	nSldCon  := 0
	nTotFSE2 := 0 //Para o relatorio analitico - total por fornecedor
	nTotFCT2 := 0 //Para o relatorio analitico - total por fornecedor
	nTotSE2  := 0 //Total Geral
	nTotCT2  := 0 //Total Geral

	fDadosAnl(Cabec1,Cabec2,Titulo,nLin)
	cDtFim	:= Dtoc(Date())+"-"+Alltrim(Time())
	MsgInfo("Tempo de processamento:"+Chr(13)+chr(10)+" - In�cio:"+cDtIni+Chr(13)+chr(10)+" - Final:"+cDtFim, "Mensagem de t�rmino")
	/*
	dbselectArea(cAliCT2)
	(cAliCT2)->(dbCloseArea())
	dbselectArea(cAliSE5)
	(cAliSE5)->(dbCloseArea())
	dbselectArea(cAliSE2)
	(cAliSE2)->(dbCloseArea())
	*/
	IF SELECT(cAliSA2) > 0
		dbselectArea(cAliSA2)
		(cAliSA2)->(dbCloseArea())
	endif

	If Select("TMPANL") > 0
		dbselectArea("TMPANL")
		TMPANL->(dbCloseArea())
	endif
	
	SET DEVICE TO SCREEN
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return

//���������������������������������������������������Ŀ                               	
//� Relatorio Analitico                               �
//�����������������������������������������������������
Static Function fDadosAnl(Cabec1,Cabec2,Titulo,nLin)
	Local nValor	:= 0
	Local nAcumul	:= 0
	Local nCont		:= 0
	Local nAmPerc	:= 0
	Local nPerc		:= 100

	//oProcess:incRegua1("T�tulos Contas a Pagar (2/5)")
	/*
	oProcess:setRegua2(nSE2TMP)

	nAcumul	:= 0
	
	dbselectArea(cAliSE2)
	(cAliSE2)->(DbgoTop())

	While (cAliSE2)->(!EOF())
	   	     
		RecLock("TMPANL",.T.)	
			TMPANL->FILIAL    := (cAliSE2)->FILIAL	
			TMPANL->FORNECE   := (cAliSE2)->FORNECE
			TMPANL->LOJA      := (cAliSE2)->LOJA
			TMPANL->PREFIXO   := (cAliSE2)->PREFIXO
			TMPANL->NUMERO    := (cAliSE2)->NUMERO
			TMPANL->PARCELA   := (cAliSE2)->PARCELA
			TMPANL->TIPO      := (cAliSE2)->TIPO
			TMPANL->DATASE2   := STOD((cAliSE2)->DATASE2)
			TMPANL->VALORSE2  := (cAliSE2)->VALORSE2
		MsUnLock()
		
		nAcumul	+= 1
		oProcess:incRegua2("T�tulos a pagar processados: "+ CValToChar(nAcumul) +" de "+ CValToChar(nSE2TMP) +" ")
		(cAliSE2)->(dbSkip())
	Enddo
	*/
	
	oProcess:incRegua1("Importando mov. baixas (6/8)")
	oProcess:setRegua2(nPerc+1)
	oProcess:incRegua2("Importando...")
	
	nAcumul	:= 0
	nCont	:= 0
	nAmPerc	:= ROUND(nSE5MOV/nPerc,0)

	dbselectArea(cAliSE5)
	(cAliSE5)->(DbgoTop())

	While (cAliSE5)->(!EOF())

	    //@history chamado 8797 - Leonardo P. Monteiro - 02/07/2019 - Inclus�o de par�metro de exce��o para exclus�o de fornecedores (Governos, Prefeiuras e etc...) e criado para os tipos de t�tulos.
		nValor 		:= IIF( (cAliSE5)->E5_TXMOEDA > 1 .and. (cAliSE5)->E5_DATA >='20210901', (cAliSE5)->E5_VLMOED2 , (cAliSE5)->E5_VALOR)
		nVALORSE2	:= 0
		//nValorTMP	:= 0
			
		If Alltrim((cAliSE5)->E5_TIPODOC) == "ES" .And. Alltrim((cAliSE5)->E5_RECPAG) == "R"
		    IF (cAliSE5)->E5_VLACRES <> 0
		       IF (cAliSE5)->E5_VLACRES == (cAliSE5)->E5_VLJUROS
 		          nVALORSE2 += nValor-(cAliSE5)->E5_VLACRES
		       Else
		          nVALORSE2 += nValor-(cAliSE5)->E5_VLACRES - (cAliSE5)->E5_VLJUROS
		       Endif
		    Else   
			   nVALORSE2 += nValor-(cAliSE5)->E5_VLACRES - (cAliSE5)->E5_VLJUROS
			Endif   
			
			// ********* INICIO  WILL chamado 028902  ************ //
			IF nValor <> 0 .AND. ((cAliSE5)->E5_VLDECRE <> 0 .OR. (cAliSE5)->E5_VLDESCO <> 0)
		       IF (cAliSE5)->E5_VLDECRE == (cAliSE5)->E5_VLDESCO
		          nVALORSE2 += (cAliSE5)->E5_VLDECRE
		       Else 
		          IF (cAliSE5)->E5_VLDESCO > (cAliSE5)->E5_VLDECRE
		          
		          	IF (cAliSE5)->E5_VLDESCO == (cAliSE5)->E5_VLJUROS
			       		  	nVALORSE2 += (cAliSE5)->E5_VLDESCO + (cAliSE5)->E5_VLJUROS
			       	ELSE
			          		nVALORSE2 += (cAliSE5)->E5_VLDESCO
			        ENDIF	
		       		
		          ELSEIF (cAliSE5)->E5_VLDESCO == 0 .AND. (cAliSE5)->E5_VLDECRE > 0	
		          
		          	nVALORSE2 := nVALORSE2
		          		
		          ELSE	
		          
		          	nVALORSE2 += (cAliSE5)->E5_VLDECRE + (cAliSE5)->E5_VLDESCO
		          
		          ENDIF	
		       Endif
		    
		    ELSEIF nValor == 0 .AND. (cAliSE5)->E5_VLDESCO > 0
		    	nVALORSE2 += (cAliSE5)->E5_VLDESCO
		    Endif   
			// ********* FINAL  WILL chamado 028902  ************ //
			
		ElseIf Alltrim((cAliSE5)->E5_TIPODOC) == "MT" .And. Alltrim((cAliSE5)->E5_RECPAG) == "P"
			nVALORSE2 += nValor
		//INICIO Chamado Interno TI - Abel Babini - Considerar valor da corre��o monet�ria passiva abatendo do valor do t�tulo - 02/07/2019
		ElseIf Alltrim((cAliSE5)->E5_TIPODOC) == "CM" .And. Alltrim((cAliSE5)->E5_RECPAG) == "P"
			nVALORSE2 -= ABS(nValor)
		ElseIf Alltrim((cAliSE5)->E5_TIPODOC) == "CM" .And. Alltrim((cAliSE5)->E5_RECPAG) == "R"
			nVALORSE2 += ABS(nValor)
		//FIM Chamado Interno TI - Abel Babini - Considerar valor da corre��o monet�ria passiva abatendo do valor do t�tulo - 02/07/2019
		Else
	    	IF (cAliSE5)->E5_VLACRES <> 0
		       IF (cAliSE5)->E5_VLACRES == (cAliSE5)->E5_VLJUROS
		          nVALORSE2 -= nValor-(cAliSE5)->E5_VLACRES
		       Else
		          nVALORSE2 -= nValor-(cAliSE5)->E5_VLACRES - (cAliSE5)->E5_VLJUROS
		       Endif
		    Else   
			   nVALORSE2 -= nValor-(cAliSE5)->E5_VLACRES - (cAliSE5)->E5_VLJUROS
			Endif  
			
			// ********* INICIO  WILL chamado 028902  ************ //
			IF nValor <> 0 .AND. ((cAliSE5)->E5_VLDECRE <> 0 .OR. (cAliSE5)->E5_VLDESCO <> 0)
		       IF (cAliSE5)->E5_VLDECRE == (cAliSE5)->E5_VLDESCO
		          nVALORSE2 -= (cAliSE5)->E5_VLDECRE
		       Else
		       		IF (cAliSE5)->E5_VLDESCO > (cAliSE5)->E5_VLDECRE
		       		
		       			IF (cAliSE5)->E5_VLDESCO == (cAliSE5)->E5_VLJUROS
			       		  	nVALORSE2 -= (cAliSE5)->E5_VLDESCO - (cAliSE5)->E5_VLJUROS
			       		ELSE
			          		nVALORSE2 -= (cAliSE5)->E5_VLDESCO
			          	ENDIF	
		       		
		       		ELSEIF (cAliSE5)->E5_VLDESCO == 0 .AND. (cAliSE5)->E5_VLDECRE > 0	
		          
			          	nVALORSE2 := nVALORSE2	
		          	
		          	ELSE	
		          
		          		nVALORSE2 -= (cAliSE5)->E5_VLDECRE + (cAliSE5)->E5_VLDESCO
		          
		          	ENDIF			
		       Endif
		       
			ELSEIF nValor == 0 .AND. (cAliSE5)->E5_VLDESCO > 0
		    
		    	nVALORSE2 -= (cAliSE5)->E5_VLDESCO
		    			       
		    Endif   
	 
		ENDIF
		
		cQuery := " INSERT INTO "+ cTabTMP +"(FILIAL, FORNECE, LOJA, PREFIXO, NUMERO, PARCELA, TIPO, DATASE2, "
		cQuery += "							  DATASE5, DATACT2, VALORSE2, VALORCT2, DEBITO, CREDIT, TIPODOC," 
		cQuery += "							  RECPAG, VLACRES, D_E_L_E_T_, R_E_C_D_E_L_)"
		cQuery += " SELECT	'"+(cAliSE5)->E5_FILIAL+"' FILIAL,"
		cQuery += "			'"+(cAliSE5)->E5_CLIFOR+"' FORNECE,"
		cQuery += "			'"+(cAliSE5)->E5_LOJA+"' LOJA,"
		cQuery += "			'"+(cAliSE5)->E5_PREFIXO+"' PREFIXO,"
		cQuery += "			'"+(cAliSE5)->E5_NUMERO+"' NUMERO,"
		cQuery += "			'"+(cAliSE5)->E5_PARCELA+"' PARCELA,"
		cQuery += "			'"+(cAliSE5)->E5_TIPO+"' TIPO,"
		cQuery += "			'' DATASE2,"
		cQuery += "			'"+(cAliSE5)->E5_DATA+"' DATASE5,"
		cQuery += "			'' DATACT2,"
		cQuery += "			 "+ replace(cValtochar(nVALORSE2),",",".") +" VALORSE2,"
		cQuery += "			 0 VALORCT2,"
		cQuery += "			 '' DEBITO,"
		cQuery += "			 '' CREDIT,"
		cQuery += "			 '"+(cAliSE5)->E5_TIPODOC+"' TIPODOC,"
		cQuery += "			 '"+(cAliSE5)->E5_RECPAG+"' RECPAG,"
		cQuery += "			 0 VLACRES,"
		cQuery += "			 '' D_E_L_E_T_," 
		cQuery += "			 0 R_E_C_D_E_L_"
		
		/*
		RecLock("TMPANL",.T.)	
			TMPANL->FORNECE   	:= (cAliSE5)->E5_CLIFOR
			TMPANL->LOJA      	:= (cAliSE5)->E5_LOJA
			TMPANL->VALORSE2	:= nVALORSE2
			TMPANL->FILIAL     	:= (cAliSE5)->E5_FILIAL	
			TMPANL->PREFIXO    	:= (cAliSE5)->E5_PREFIXO
			TMPANL->NUMERO     	:= (cAliSE5)->E5_NUMERO
			TMPANL->PARCELA    	:= (cAliSE5)->E5_PARCELA
			TMPANL->TIPO       	:= (cAliSE5)->E5_TIPO
			TMPANL->DATASE5    	:= STOD((cAliSE5)->E5_DATA)
			TMPANL->TIPODOC    	:= (cAliSE5)->E5_TIPODOC
			TMPANL->RECPAG     	:= (cAliSE5)->E5_RECPAG
		TMPANL->(MsUnLock())
		*/
		
		If TcSqlExec(cQuery) < 0
			MsgStop("N�o foi poss�vel inserir os t�tulos do movimentos financeiros.","Erro na inclus�o")
		EndIf 
		
		
		nAcumul	+= 1
		nCont	+= 1
		if nCont > nAmPerc .or. nAcumul ==1
			oProcess:incRegua2("Mov. de baixas ("+cValtochar(Round(nAcumul/nSE5MOV*100,0))+"%) proc.: "+ CValToChar(nAcumul) +" de "+ CValToChar(nSE5MOV) +" ")
			nCont := 1
		endif
		(cAliSE5)->(dbSkip())
	Enddo	
	//oProcess:incRegua2("Movimentos de baixas proc.: "+ CValToChar(nAcumul) +" de "+ CValToChar(nSE5MOV) +" ")
	
	(cAliSE5)->(Dbclosearea())

	oProcess:incRegua1("Movimentos cont�beis (7/8)")
	oProcess:setRegua2(nPerc+1)
	oProcess:incRegua2("Importando...")
	
	nAcumul	:= 0
	nCont	:= 0
	nAmPerc	:= ROUND(nCT2TMP/nPerc,0)

	dbselectArea(cAliCT2)
	(cAliCT2)->(DbgoTop())
	
	While (cAliCT2)->(!EOF())
	
		//dbSelectArea("TMPANL")
		//TMPANL->(dbSetOrder(1))
		//TMPANL->(dbGoTop())
		
	    /* somente para testes e analise Mauricio - 01/06/16
	    _cPf   := "MAN"
	    _cNum  := "203449   "
	    _cPa   := "A  "
	
	    IF (cAliCT2)->(CT2_PREFIX+CT2_NUMDOC+CT2_PARCEL) <> _cPF+_cNum + _cPa
	       (cAliCT2)->(dbSkip())
	       loop
	    Endif  
	    */
		/*
		RecLock("TMPANL",.T.)	
			TMPANL->FILIAL    := (cAliCT2)->CT2_FILKEY
			TMPANL->FORNECE   := (cAliCT2)->CT2_CLIFOR
			TMPANL->LOJA      := (cAliCT2)->CT2_LOJACF
			If Alltrim((cAliCT2)->CT2_DEBITO) == Alltrim(mv_par09)//"211110001"
				TMPANL->VALORCT2  -= (cAliCT2)->CT2_VALOR
			ElseIf Alltrim((cAliCT2)->CT2_CREDIT) == Alltrim(mv_par09)//"211110001"
				TMPANL->VALORCT2  += (cAliCT2)->CT2_VALOR			
			Endif
			TMPANL->PREFIXO   := (cAliCT2)->CT2_PREFIX
			TMPANL->NUMERO    := (cAliCT2)->CT2_NUMDOC
			TMPANL->PARCELA   := (cAliCT2)->CT2_PARCEL
			TMPANL->TIPO      := (cAliCT2)->CT2_TIPODC
			TMPANL->DATACT2   := STOD((cAliCT2)->CT2_DATA)						
		MsUnLock()
		*/
	
		cQuery := " INSERT INTO "+ cTabTMP +"(FILIAL, FORNECE, LOJA, PREFIXO, NUMERO, PARCELA, TIPO, DATASE2, "
		cQuery += "							  DATASE5, DATACT2, VALORSE2, VALORCT2, DEBITO, CREDIT, TIPODOC," 
		cQuery += "							  RECPAG, VLACRES, D_E_L_E_T_, R_E_C_D_E_L_)"
		cQuery += " SELECT	'"+(cAliCT2)->FILIAL+"' FILIAL,"
		cQuery += "			'"+(cAliCT2)->FORNECE+"' FORNECE,"
		cQuery += "			'"+(cAliCT2)->LOJA+"' LOJA,"
		cQuery += "			'"+(cAliCT2)->PREFIXO+"' PREFIXO,"
		cQuery += "			'"+(cAliCT2)->NUMERO+"' NUMERO,"
		cQuery += "			'"+(cAliCT2)->PARCELA+"' PARCELA,"
		cQuery += "			'"+(cAliCT2)->TIPO+"' TIPO,"
		cQuery += "			'' DATASE2,"
		cQuery += "			'' DATASE5,"
		cQuery += "			'"+(cAliCT2)->DATACT2+"' DATACT2,"
		cQuery += "			 0 VALORSE2,"
		cQuery += "			 "+ replace(cValtochar((cAliCT2)->VALORCT2),",",".") +" VALORCT2,"
		cQuery += "			 '' DEBITO,"
		cQuery += "			 '' CREDIT,"
		cQuery += "			 '' TIPODOC,"
		cQuery += "			 '' RECPAG,"
		cQuery += "			 0 VLACRES,"
		cQuery += "			 '' D_E_L_E_T_," 
		cQuery += "			 0 R_E_C_D_E_L_"
		
		If TcSqlExec(cQuery) < 0
			MsgStop("N�o foi poss�vel inserir os t�tulos do movimentos cont�beis.","Erro na inclus�o")
		EndIf

		nAcumul	+= 1
		nCont	+= 1
		if nCont > nAmPerc .or. nAcumul ==1
			oProcess:incRegua2("Movim. cont�beis ("+cValtochar(Round(nAcumul/nCT2TMP*100,0))+"%) proc.: "+ CValToChar(nAcumul) +" de "+ CValToChar(nCT2TMP) +" ")
			nCont := 1
		endif
		
		(cAliCT2)->(dbSkip())
	Enddo		           
	
	(cAliCT2)->(DbcloseArea())

	oProcess:incRegua2("Mov. cont�beis importados...")

	oProcess:incRegua1("Gerando impress�o (7/8)")
	oProcess:setRegua2(nPerc+1)
	oProcess:incRegua2("Imprimindo...")

	nAcumul	:= 0
	nCont	:= 0
	nAmPerc	:= ROUND(nSA2TMP/nPerc,0)        
	//Impressao
	dbSelectArea(cAliSA2)
	(cAliSA2)->(dbGoTop())

	While (cAliSA2)->(!EOF())
		If nLin > 65
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8
		Endif
		
		lEntrou := .F.
		/*
		dbSelectArea("TMPANL")
		TMPANL->(dbSetOrder(1))
		TMPANL->(dbGoTop())
		TMPANL->(dbSeek((cAliSA2)->A2_COD+(cAliSA2)->A2_LOJA))
		*/

		cQuery 	:= " SELECT * "
		cQuery 	+= " FROM "+ cTabTMP +" WITH(NOLOCK)"
		cQuery	+= " WHERE D_E_L_E_T_='' AND FORNECE='"+Alltrim((cAliSA2)->A2_COD)+"' AND LOJA='"+Alltrim((cAliSA2)->A2_LOJA)+"' "
		cQuery	+= " ORDER BY FORNECE, LOJA, FILIAL, NUMERO, PREFIXO, PARCELA, TIPO; "

		TcQuery cQuery ALIAS "QTMPANL" NEW

		//While TMPANL->(!EOF()) .And. (cAliSA2)->A2_COD == TMPANL->FORNECE .And. (cAliSA2)->A2_LOJA == TMPANL->LOJA
		while QTMPANL->(!eof())	
			If nLin > 65
		   		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		   		nLin := 8
		   	Endif		
			
			If !lEntrou
				lEntrou := .T.
				nTotFSE2 := 0
				nTotFCT2 := 0			
				@nLin,000 Psay (cAliSA2)->A2_COD
				@nLin,008 Psay (cAliSA2)->A2_LOJA				
				@nLin,012 Psay Substr((cAliSA2)->A2_NOME,1,30)
			Endif	                                    				
			
			IF MV_PAR08 == 1 &&Analitico                                                                
			@nLin,045 Psay QTMPANL->FILIAL
			@nLin,050 Psay QTMPANL->PREFIXO
			@nLin,055 Psay QTMPANL->NUMERO
			@nLin,067 Psay QTMPANL->PARCELA			
			@nLin,073 Psay QTMPANL->TIPO
			If ALLTRIM(DTOS(stod(QTMPANL->DATASE2))) <> ""
				@nLin,080 Psay DTOC(stod(QTMPANL->DATASE2))
			Endif
			If ALLTRIM(QTMPANL->DATASE5) <> ""			
				@nLin,095 Psay DTOC(stod(QTMPANL->DATASE5))
			Endif
			If ALLTRIM(QTMPANL->DATACT2) <> ""	
				@nLin,110 Psay DTOC(stod(QTMPANL->DATACT2))
			Endif	
			@nLin,120 Psay QTMPANL->VALORSE2 PICTURE "@E 999,999,999.99"//15			
			@nLin,140 Psay QTMPANL->VALORCT2 PICTURE "@E 999,999,999.99"
			Endif
			nTotFSE2 += QTMPANL->VALORSE2
			nTotFCT2 += QTMPANL->VALORCT2
			
			nTotSE2 += QTMPANL->VALORSE2
			nTotCT2 += QTMPANL->VALORCT2
			IF MV_PAR08 == 1					
			nLin += 1
			Endif		
			QTMPANL->(dbSkip())
		Enddo

		QTMPANL->(DBCLOSEAREA())
			
		If lEntrou		
			If nLin > 65
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8
			Endif		
		    
		    IF MV_PAR08 == 1
				nLin += 1		
				@nLin,000 Psay "Total Fornecedor"
				@nLin,120 Psay nTotFSE2 PICTURE "@E 999,999,999.99"
				@nLin,140 Psay nTotFCT2 PICTURE "@E 999,999,999.99"
				If nTotFSE2 > 0 .and. nTotFCT2 > 0
					@nLin,160 Psay nTotFSE2-nTotFCT2 PICTURE "@E 999,999,999.99"		
				Else
					@nLin,160 Psay nTotFSE2+nTotFCT2 PICTURE "@E 999,999,999.99"
				Endif
			else   &&sintetico
			    @nLin,52 Psay nTotFSE2 PICTURE "@E 999,999,999.99"
			    @nLin,72 Psay nTotFCT2 PICTURE "@E 999,999,999.99"
			    If nTotFSE2 > 0 .and. nTotFCT2 > 0
				  @nLin,90 Psay nTotFSE2-nTotFCT2 PICTURE "@E 999,999,999.99"		
			    Else
				  @nLin,90 Psay nTotFSE2+nTotFCT2 PICTURE "@E 999,999,999.99"
			    Endif
			    nLin += 1
			Endif
			IF MV_PAR08 == 1	
			nLin += 2
			ENdif		
		Endif

		nAcumul	+= 1
		nCont	+= 1
		if nCont > nAmPerc .or. nAcumul ==1
			oProcess:incRegua2("Imprimindo ("+cValtochar(Round(nAcumul/nSA2TMP*100,0))+"%) proc.: "+ CValToChar(nAcumul) +" de "+ CValToChar(nSA2TMP) +" ")
			nCont := 1
		endif

		(cAliSA2)->(dbSkip())
	Enddo
	(cAliSA2)->(DbcloseArea())
	
	If MV_PAR08 == 1
		nLin += 1
		@nLin,000 Psay "Total Geral"
		@nLin,120 Psay nTotSE2 PICTURE "@E 999,999,999.99"
		@nLin,140 Psay nTotCT2 PICTURE "@E 999,999,999.99"
		If nTotSE2 > 0 .and. nTotCT2 > 0
			@nLin,160 Psay nTotSE2-nTotCT2 PICTURE "@E 999,999,999.99"	
		Else
			@nLin,160 Psay nTotSE2+nTotCT2 PICTURE "@E 999,999,999.99"	
		Endif
	Else
		nLin += 1
		@nLin,000 Psay "Total Geral"
		@nLin,52 Psay nTotSE2 PICTURE "@E 999,999,999.99"
		@nLin,72 Psay nTotCT2 PICTURE "@E 999,999,999.99"
		If nTotSE2 > 0 .and. nTotCT2 > 0
			@nLin,90 Psay nTotSE2-nTotCT2 PICTURE "@E 999,999,999.99"	
		Else
			@nLin,90 Psay nTotSE2+nTotCT2 PICTURE "@E 999,999,999.99"	
		Endif
	Endif
	
Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �fDados    � Autor � Luana Ferrari      � Data �  06/05/11   ���
�������������������������������������������������������������������������͹��
�S��Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fDados()

	Local cQuery:=""
	oProcess:incRegua1("Consultando clientes (2/8)")
	oProcess:setRegua2(4)
	oProcess:incRegua2("Consultando clientes...")

	If Select(cAliSA2) > 0
		DbSelectArea(cAliSA2)
		(cAliSA2)->(DbCloseArea())
	Endif
	
	cQuery:=" SELECT A2_COD,A2_LOJA,A2_NOME "
	cQuery+=" FROM " + RetSqlName("SA2") + " WITH(NOLOCK) "
	cQuery+=" WHERE D_E_L_E_T_ <> '*' "
	cQuery+=" AND A2_COD BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"	
	cQuery+=" AND A2_LOJA BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'" 
	
	TCQUERY cQuery NEW ALIAS &cAliSA2
	
	dbselectArea(cAliSA2)
	(cAliSA2)->(DbgoTop())
	Count to nSA2TMP
	(cAliSA2)->(DbgoTop())
	
	If Select(cAliSE2) > 0
		DbSelectArea(cAliSE2)
		(cAliSE2)->(DbCloseArea())
	Endif
	
	oProcess:incRegua1("Importando t�tulos a pagar (3/8)")
	oProcess:setRegua2(2)
	oProcess:incRegua2("Importando...")
	

	//If mv_par08 == 1 //Analitico
	//cQuery:=" SELECT E2_FILIAL,E2_PREFIXO,E2_NUM,E2_PARCELA,E2_TIPO,E2_FORNECE,E2_LOJA,E2_VALOR AS E2_VALOR, E2_EMIS1 " //INICIO Chamado Interno TI - Abel Babini - Considerar valor da corre��o monet�ria passiva abatendo do valor do t�tulo - 02/07/2019
	cQuery:=" INSERT INTO "+cTabTMP+"(FILIAL, FORNECE, LOJA, PREFIXO, NUMERO, PARCELA, TIPO, DATASE2, DATASE5, DATACT2, VALORSE2, VALORCT2, DEBITO, CREDIT, TIPODOC, RECPAG, VLACRES, D_E_L_E_T_, R_E_C_D_E_L_) "+CRLF
	cQuery+=" SELECT E2_FILIAL FILIAL, "+CRLF
	cQuery+="  E2_FORNECE FORNECE, "+CRLF
	cQuery+="  E2_LOJA LOJA, "+CRLF
	cQuery+="  E2_PREFIXO PREFIXO, "+CRLF
	cQuery+="  E2_NUM NUMERO, "+CRLF
	cQuery+="  E2_PARCELA PARCELA, "+CRLF
	cQuery+="  E2_TIPO TIPO, "+CRLF
	cQuery+="  E2_EMIS1 DATASE2, "+CRLF
	cQuery+="  '' DATASE5, "+CRLF
	cQuery+="  '' DATACT2, "+CRLF
	cQuery+="  IIF(E2_MOEDA<>'1' AND (E2_EMIS1 >='20210901' OR (E2_EMIS1 >='20190601' AND E2_FORNECE='025960')),E2_VLCRUZ,E2_VALOR) AS VALORSE2, "+CRLF //INICIO Chamado Interno TI - Abel Babini - Considerar valor da corre��o monet�ria passiva abatendo do valor do t�tulo - 02/07/2019
	cQuery+="  0 VALORCT2, "+CRLF
	cQuery+="  '' DEBITO, "+CRLF
	cQuery+="  '' CREDIT, "+CRLF
	cQuery+="  '' TIPODOC, "+CRLF
	cQuery+="  '' RECPAG, "+CRLF
	cQuery+="  '' VLACRES, "+CRLF
	cQuery+="  '' D_E_L_E_T_,"+CRLF
	cQuery+="  0 R_E_C_D_E_L_ "+CRLF
	cQuery+=" FROM " + RetSqlName("SE2") + " WITH(NOLOCK) "+CRLF
	cQuery+=" WHERE E2_EMIS1 BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "'"+CRLF
	cQuery+=" AND D_E_L_E_T_ <> '*' " +CRLF 
	cQuery+=" AND E2_FORNECE BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "'"	+CRLF
	cQuery+=" AND E2_LOJA BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"+CRLF   			
	//Ticket 8797 - Leonardo P. Monteiro - 02/07/2019 - Inclus�o de par�metro de exce��o para exclus�o de fornecedores (Governos, Prefeiuras e etc...) e tipos de t�tulos.
	//cQuery+=" AND E2_TIPO <> 'NDF' "
	//cQuery+=" AND NOT (E2_NUM = '000011751' AND E2_FORNECE ='025960' AND E2_EMIS1='20190618')
	cQuery+=" AND E2_TIPO NOT IN "+ cTpExc +" "+CRLF
	cQuery+=" AND E2_FORNECE NOT IN "+ cFoExc +" "+CRLF
	cQuery+=" AND E2_CREDIT = '" + Alltrim(mv_par09) + "' "	+CRLF
	/*
	If !Alltrim(mv_par10) == "XXX"
		cQuery+=" AND E2_PREFIXO <> 'RJ' "	
	Endif
	*/
	//INICIO Ticket  90997 - Incluinco Exce��o - cFoEcx - Antonio Domingos - 31/03/2023
	
		cQuery+=" UNION ALL "+CRLF
		cQuery+=" SELECT E2_FILIAL FILIAL, "+CRLF
		cQuery+="  E2_FORNECE FORNECE, "+CRLF
		cQuery+="  E2_LOJA LOJA, "+CRLF
		cQuery+="  E2_PREFIXO PREFIXO, "+CRLF
		cQuery+="  E2_NUM NUMERO, "+CRLF
		cQuery+="  E2_PARCELA PARCELA, "+CRLF
		cQuery+="  E2_TIPO TIPO, "+CRLF
		cQuery+="  E2_EMIS1 DATASE2, "+CRLF
		cQuery+="  '' DATASE5, "+CRLF
		cQuery+="  '' DATACT2, "+CRLF
		//Ticket  90997 - Antonio Domingos    - 20/04/2023
		//cQuery+= " CASE WHEN E2_EMIS1 BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "' THEN E2_VALOR ELSE E2_SALDO END AS VALORSE2,"+CRLF
		cQuery += "CASE WHEN E2_FORNECE IN "+ cFoExc +" THEN E2_VALOR ELSE 0 END  AS  VALORSE2,"+CRLF
		cQuery+="  0 VALORCT2, "+CRLF
		cQuery+="  '' DEBITO, "+CRLF
		cQuery+="  '' CREDIT, "+CRLF
		cQuery+="  '' TIPODOC, "+CRLF
		cQuery+="  '' RECPAG, "+CRLF
		cQuery+="  '' VLACRES, "+CRLF
		cQuery+="  '' D_E_L_E_T_,"+CRLF
		cQuery+="  0 R_E_C_D_E_L_ "+CRLF
		cQuery+=" FROM " + RetSqlName("SE2") + " WITH(NOLOCK) "+CRLF
		cQuery+=" WHERE E2_EMIS1 BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "'"+CRLF
		cQuery+=" AND D_E_L_E_T_ <> '*' "+CRLF  
		cQuery+=" AND E2_FORNECE IN "+ cFoExc +" "+CRLF
		cQuery+=" AND E2_LOJA BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "'"+CRLF   			
		cQuery+=" AND E2_TIPO NOT IN('NDF','IS ','ISS') "+CRLF
		cQuery+=" AND E2_CREDIT = '" + Alltrim(mv_par09) + "' "	+CRLF
		cQuery+=" AND E2_SALDO <> 0 "	+CRLF

	//FIM Ticket  90997 - Inclus�o da Exce��o - cFoExc - Antonio Domingos - 31/03/2023

	cQuery+=" ORDER BY FORNECE,LOJA,DATASE2 "+CRLF
	
	MemoWrite("c:\temp\ADFIN116R-3-8.SQL",cQuery)
	
	If TcSqlExec(cQuery) < 0
		MsgStop("N�o foi poss�vel inserir os t�tulos do contas a pagar.","Erro na inclus�o")
	EndIf
	oProcess:incRegua2("T�tulos Contas a Pagar importados...")

	/*
	TCQUERY cQuery NEW ALIAS cAliSE2

	dbselectArea(cAliSE2)
	(cAliSE2)->(DbgoTop())
	Count to nSE2TMP
	(cAliSE2)->(DbgoTop())
	*/

	If Select(cAliSE5) > 0
		DbSelectArea(cAliSE5)
		(cAliSE5)->(DbCloseArea())
	Endif

	oProcess:incRegua1("Consultando movimentos financeiros (4/8)")
	oProcess:setRegua2(2)
	oProcess:incRegua2("Importando...")

	//If mv_par08 == 1 //Analitico
	//Tkt 72972 altera��o da consulta para BeginSql
	//Tratando as variaveis cTpExc e cFoExc
	cTpExc := REPLACE(cTpExc,"('","")
	cTpExc := REPLACE(cTpExc,"')","")

	cFoExc := REPLACE(cFoExc,"('","")
	cFoExc := REPLACE(cFoExc,"')","")	
	
BeginSql Alias cAliSE5
		%noparser%
	
		SELECT  E5_FILIAL,
		E5_PREFIXO,
		E5_NUMERO,
		E5_PARCELA,
		E5_MOEDA,
		E5_TXMOEDA,
		E5_VLMOED2,
		E5_TIPO,
		E5_CLIFOR,
		E5_LOJA,
		E5_DATA,
		E5_VALOR,
		E5_TIPODOC,
		E5_RECPAG, 
	  	E5_MOTBX,
		E5_VLACRES, 
		E5_VLDECRE,	
		E5_VLDESCO, 
		E5_VLJUROS 
		FROM %table:SE5% SE5 WITH(NOLOCK) 
		WHERE SE5.D_E_L_E_T_ = ''	 
		AND E5_CLIFOR BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND E5_LOJA BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%			
		AND E5_SITUACA <> 'C' 
		AND E5_DATA <= %Exp:Dtos(mv_par07)%	
		AND E5_DATA BETWEEN %Exp:Dtos(mv_par05)% AND %Exp:Dtos(mv_par06)%
		AND E5_TIPO+E5_TIPODOC+E5_MOTBX <> 'PA BACMP' 
		AND E5_TIPO+E5_TIPODOC+E5_RECPAG <> 'PA VLR' 
		AND E5_TIPO+E5_TIPODOC+E5_RECPAG <> 'PA BAR' 
		AND E5_TIPO+E5_TIPODOC+E5_MOTBX <> 'PA ESCMP' 	
		AND E5_TIPODOC+E5_RECPAG <> 'JRP' 
		//Ticket 8797 - Leonardo P. Monteiro - 02/07/2019 - Inclus�o de par�metro de exce��o para exclus�o de fornecedores (Governos, Prefeiuras e etc...) e tipos de t�tulos.
		//cQuery+=" AND E5_TIPO <> 'NDF' "	
		AND E5_TIPO NOT IN (%Exp:cTpExc%)
		AND E5_CLIFOR NOT IN (%Exp:cFoExc%)
		AND E5_TIPODOC <> 'DC' 	//Chamado 028902
		AND E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA   //retirada filial
		IN (  
		SELECT E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA //retirada filial
		FROM %table:SE2% SE2 WITH(NOLOCK)    
		WHERE E2_EMIS1 BETWEEN %Exp:Dtos(mv_par05)% AND %Exp:Dtos(mv_par06)%
		AND SE2.D_E_L_E_T_ = ''
		AND E2_FORNECE BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND E2_LOJA BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		//Ticket 8797 - Leonardo P. Monteiro - 02/07/2019 - Inclus�o de par�metro de exce��o para exclus�o de fornecedores (Governos, Prefeiuras e etc...) e tipos de t�tulos.
		//cQuery+=" AND E2_TIPO <> 'NDF' "	
		AND E2_TIPO NOT IN (%Exp:cTpExc%)
		AND E2_FORNECE NOT IN (%Exp:cFoExc%)
		AND E2_CREDIT = %Exp:AllTrim(mv_par09)%	)
		
		UNION ALL
		
		SELECT  
		E5_FILIAL,
		E5_PREFIXO,
		E5_NUMERO,
		E5_PARCELA,
		E5_MOEDA,
		E5_TXMOEDA,
		E5_VLMOED2,
		E5_TIPO,
		E5_CLIFOR,
		E5_LOJA,
		E5_DATA,
		CASE WHEN E5_CLIFOR IN (%Exp:cFoExc%) THEN E5_VALOR ELSE 0 END AS E5_VALOR,
		E5_TIPODOC,
		E5_RECPAG, 
	  	E5_MOTBX,
		CASE WHEN E5_CLIFOR IN (%Exp:cFoExc%) THEN E5_VLACRES ELSE 0 END AS E5_VLACRES,
		CASE WHEN E5_CLIFOR IN (%Exp:cFoExc%) THEN E5_VLDECRE ELSE 0 END AS E5_VLDECRE,
		CASE WHEN E5_CLIFOR IN (%Exp:cFoExc%) THEN E5_VLDESCO ELSE 0 END AS E5_VLDESCO,
		CASE WHEN E5_CLIFOR IN (%Exp:cFoExc%) THEN E5_VLJUROS ELSE 0 END AS E5_VLJUROS
		FROM %table:SE5% SE5 WITH(NOLOCK) 
		WHERE SE5.D_E_L_E_T_ = ''	 
		AND E5_CLIFOR BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND E5_LOJA BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%			
		AND E5_SITUACA <> 'C' 
		AND E5_DATA <= %Exp:Dtos(mv_par07)%	
		AND E5_DATA BETWEEN %Exp:Dtos(mv_par05)% AND %Exp:Dtos(mv_par06)%
		AND E5_TIPO+E5_TIPODOC+E5_MOTBX <> 'PA BACMP' 
		AND E5_TIPO+E5_TIPODOC+E5_RECPAG <> 'PA VLR' 
		AND E5_TIPO+E5_TIPODOC+E5_RECPAG <> 'PA BAR' 
		AND E5_TIPO+E5_TIPODOC+E5_MOTBX <> 'PA ESCMP' 	
		AND E5_TIPODOC+E5_RECPAG <> 'JRP' 
		//Ticket 8797 - Leonardo P. Monteiro - 02/07/2019 - Inclus�o de par�metro de exce��o para exclus�o de fornecedores (Governos, Prefeiuras e etc...) e tipos de t�tulos.
		//cQuery+=" AND E5_TIPO <> 'NDF' "	
		AND E5_TIPO NOT IN (%Exp:cTpExc%)
		AND E5_CLIFOR IN (%Exp:cFoExc%)
		AND E5_TIPODOC <> 'DC' 	//Chamado 028902
		AND E5_TIPO NOT IN('NDF','IS ','ISS')
		AND E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA   //retirada filial
		IN (  
		SELECT E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA //retirada filial
		FROM %table:SE2% SE2 WITH(NOLOCK)    
		WHERE E2_EMIS1 BETWEEN %Exp:Dtos(mv_par05)% AND %Exp:Dtos(mv_par06)%
		AND SE2.D_E_L_E_T_ = ''
		AND E2_FORNECE BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
		AND E2_LOJA BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
		//Ticket 8797 - Leonardo P. Monteiro - 02/07/2019 - Inclus�o de par�metro de exce��o para exclus�o de fornecedores (Governos, Prefeiuras e etc...) e tipos de t�tulos.
		//cQuery+=" AND E2_TIPO <> 'NDF' "	
		AND E2_TIPO NOT IN (%Exp:cTpExc%)
		AND E2_TIPO NOT IN('NDF','IS ','ISS')
		AND E2_FORNECE IN (%Exp:cFoExc%)
		AND E2_CREDIT = %Exp:AllTrim(mv_par09)%	
		AND E2_SALDO <> 0 )

		/*
		If !Alltrim(mv_par10) == "XXX"
		cQuery+=" AND E2_PREFIXO <> 'RJ' "	
		Endif
		*/	
		ORDER BY E5_CLIFOR,E5_LOJA,E5_DATA,E5_RECPAG 

	EndSql 
	
	aDados := GetLastQuery()
	cMensagem := ""
	cMensagem += "* cAlias - " + aDados[1] + Chr(13) + Chr(10)
	cMensagem += "* cQuery - " + aDados[2]
	If Len(aDados) > 0
		cQuery := aDados[2]
		Memowrite("C:\TEMP\ADFIN116R-4-8.SQL",cQuery)
	EndIf
	
	dbselectArea(cAliSE5)
	(cAliSE5)->(DbgoTop())
	Count to nSE5MOV
	(cAliSE5)->(DbgoTop())

	oProcess:incRegua2("Mov. financeiros importados...")
	
	If Select(cAliCT2) > 0
		DbSelectArea(cAliCT2)
		(cAliCT2)->(DbCloseArea())
	Endif
	
	oProcess:incRegua1("Importando mov. cont�beis (5/8)")
	oProcess:setRegua2(2)
	oProcess:incRegua2("Importando...")

	//If mv_par08 == 1 //Analitico
	//cQuery:=" INSERT INTO "+cTabTMP+"(FILIAL, FORNECE, LOJA, PREFIXO, NUMERO, PARCELA, TIPO, DATASE2, DATASE5, DATACT2, VALORSE2, VALORCT2, DEBITO, CREDIT, TIPODOC, RECPAG, VLACRES, D_E_L_E_T_, R_E_C_D_E_L_) "
	
	cQuery:=" SELECT CT2_FILKEY FILIAL,CT2_CLIFOR FORNECE,CT2_LOJACF LOJA, CT2_PREFIX PREFIXO,CT2_NUMDOC NUMERO,CT2_PARCEL PARCELA,CT2_TIPODC TIPO, "+CRLF
	cQuery+= "		 '' DATASE2, '' DATASE5,CT2_DATA DATACT2, 0 VALORSE2,"+CRLF
	cQuery+= "		 CASE WHEN rtrim(ltrim(CT2_DEBITO)) = '"+Alltrim(mv_par09)+"' THEN CT2_VALOR*(-1) WHEN rtrim(ltrim(CT2_CREDIT)) = '"+Alltrim(mv_par09)+"' THEN CT2_VALOR END VALORCT2, "+CRLF
	cQuery+= "		 '' DEBITO,'' CREDIT,'' TIPODOC,'' RECPAG,0 VLACRES,'' D_E_L_E_T_,0 R_E_C_D_E_L_ "+CRLF
	
	cQuery+=" FROM " + RetSqlName("CT2") + " WITH(NOLOCK) "+CRLF
	cQuery+=" WHERE D_E_L_E_T_ <> '*' "+CRLF
	cQuery+=" AND CT2_DATA BETWEEN '" + DTOS(mv_par05) + "' AND '" + DTOS(mv_par06) + "' "	+CRLF
	//cQuery+=" AND (CT2_DEBITO = '211110001' OR CT2_CREDIT = '211110001') "+CRLF
	cQuery+=" AND (CT2_DEBITO = '" + Alltrim(mv_par09) + "' OR CT2_CREDIT = '" + Alltrim(mv_par09) + "') "+CRLF
	cQuery+=" AND CT2_CLIFOR BETWEEN '" + mv_par01 + "' AND '" + mv_par02 + "' "+CRLF
	cQuery+=" AND CT2_LOJACF BETWEEN '" + mv_par03 + "' AND '" + mv_par04 + "' "+CRLF
	cQuery+=" AND CT2_CLIFOR <> '' "+CRLF			
	cQuery+=" ORDER BY CT2_CLIFOR,CT2_LOJACF,CT2_DATA "	+CRLF
	/*
	If TcSqlExec(cQuery) < 0
		MsgStop("N�o foi poss�vel inserir os movimentos cont�beis.","Erro na inclus�o")
	EndIf
	*/
	MemoWrite("c:\temp\ADFIN116R-5-8.SQL",cQuery)

	TCQUERY cQuery ALIAS &cAliCT2 NEW
	
	dbselectArea(cAliCT2)
	(cAliCT2)->(DbgoTop())
	Count to nCT2TMP
	(cAliCT2)->(DbgoTop())
	
	oProcess:incRegua2("Mov. cont�beis importados...")

	nTotal := nCT2TMP+nSE5MOV+nSE2TMP+nSA2TMP
Return
