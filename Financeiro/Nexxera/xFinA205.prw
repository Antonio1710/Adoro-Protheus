#include "ap5mail.ch"
#include "protheus.ch"

#define STR0004		FWI18NLang("FINA205","STR0004",01)
#define STR0016		FWI18NLang("FINA205","STR0016",01)
#define STR0017		FWI18NLang("FINA205","STR0017",01)
#define STR0021		FWI18NLang("FINA205","STR0021",01)
#define STR0022		FWI18NLang("FINA205","STR0022",01)
#define STR0023		FWI18NLang("FINA205","STR0023",01)
#define STR0024		FWI18NLang("FINA205","STR0024",01)
#define STR0025		FWI18NLang("FINA205","STR0025",01)
#define STR0027		FWI18NLang("FINA205","STR0027",01)
#define STR0028		FWI18NLang("FINA205","STR0028",01)
#define STR0029		FWI18NLang("FINA205","STR0029",01)

Static lAdoro 		:=	Nil
Static lCeres 		:=	Nil
Static lCLML 		:=	Nil
Static lGMSBS 		:=	Nil
Static lRNX2 		:=	Nil
Static lSafegg 		:=	Nil
Static lSymplify 		:=	Nil

/*/{Protheus.doc} User Function XFinA205
	Retorno das baixas do Contas a Receber
	@type  Function
	@author Alexandre Zapponi
	@since 24/02/20
	@history ticket 81491 - Abel Babini - 19/05/2023 - Projeto Nexxera - Atualização do fonte para baixas Contas a Receber via Menu
	/*/
User Function xFinA205(aParam)       

Local nCntFor  
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U"
Local xDataBase		:=	nil
Local aXEmps := {{"01","01"}}//,{"02","01"},{"07","01"},{"09","01"}}
Local i := 0

Private aMsgSch		:= 	{}
Private aFA205R		:= 	{}	
Private cCadastro  	:= 	"Retorno Bancario Automatico (Receber)"


Default aParam    := Array(2)
Default aParam[1] := "01"
Default aParam[2] := "01"

if lIsBlind
	FOR i:=1 to len(aXEmps) 
		aParam[1] := aXEmps[i,1] 
		aParam[2] := aXEmps[i,2]
		
		ConOut("*** INICIO >> " + cCadastro + DtoC(Date()) + " " + Time() + " - Emp:"+aParam[1]+" | Fil:"+aParam[2])

		RpcSetEnv( aParam[1] , aParam[2] )

		xDataBase		:=	dDataBase

		lAdoro  :=	ChecaEmp("ADORO") 	
		// lCeres    :=	ChecaEmp("CERES")    	
		// lCLML  :=	ChecaEmp("CLML")  	
		// lGMSBS  :=	ChecaEmp("GMSBS") 	
		// lRNX2 :=	ChecaEmp("RNX2") 	
		// lSafegg :=	ChecaEmp("SAFEGG") 	
		// lSymplify :=	ChecaEmp("SIMPLIFY") 	


		BatchProcess( cCadastro , cCadastro , "FA205JOB" , { || Fa205Job() } , { || .f. } )


		if 	Empty(GetMv("MV_RETMAIL",,"")) .and. Len(aMsgSch) > 0
			For nCntFor := 1 to Len(aMsgSch)
				ConOut(aMsgSch[nCntFor])
			Next nCntFor
		endif

		ConOut("*** FIM >> " + cCadastro + DtoC(Date()) + " " + Time() + " - Emp:"+aParam[1]+" | Fil:"+aParam[2]) 

		dDataBase := xDataBase


		RpcClearEnv()
	NEXT i
else

	xDataBase		:=	dDataBase
	if	lIsBlind
		lAdoro  :=	ChecaEmp("ADORO") 	
		// lCeres    :=	ChecaEmp("CERES")    	
		// lCLML  :=	ChecaEmp("CLML")  	
		// lGMSBS  :=	ChecaEmp("GMSBS") 	
		// lRNX2 :=	ChecaEmp("RNX2") 	
		// lSafegg :=	ChecaEmp("SAFEGG") 	
		// lSymplify :=	ChecaEmp("SIMPLIFY") 	
	else
		FwMsgRun( Nil , { || lAdoro  :=	ChecaEmp("ADORO") 	} , 'Processando' , "Buscando dados ..." )
		// FwMsgRun( Nil , { || lCeres  :=	ChecaEmp("CERES") 	} , 'Processando' , "Buscando dados ..." )
		// FwMsgRun( Nil , { || lCLML  :=	ChecaEmp("CLML") 	} 	, 'Processando' , "Buscando dados ..." )
		// FwMsgRun( Nil , { || lGMSBS  :=	ChecaEmp("GMSBS") 	} , 'Processando' , "Buscando dados ..." )
		// FwMsgRun( Nil , { || lRNX2  :=	ChecaEmp("RNX2") 	} 	, 'Processando' , "Buscando dados ..." )
		// FwMsgRun( Nil , { || lSafegg  :=	ChecaEmp("SAFEGG") 	} , 'Processando' , "Buscando dados ..." )
		// FwMsgRun( Nil , { || lSymplify  :=	ChecaEmp("SIMPLIFY")} , 'Processando' , "Buscando dados ..." )

	endif

	if	lIsBlind	
		BatchProcess( cCadastro , cCadastro , "FA205JOB" , { || Fa205Job() } , { || .f. } )
	else
		Fa205Job()
	endif

	if 	Empty(GetMv("MV_RETMAIL",,"")) .and. Len(aMsgSch) > 0
		For nCntFor := 1 to Len(aMsgSch)
			ConOut(aMsgSch[nCntFor])
		Next nCntFor
	endif

	ConOut("*** FIM >> " + cCadastro + DtoC(Date()) + " " + Time()) 

	dDataBase := xDataBase
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³ FA205JOB ³ Autor ³ Aldo Barbosa dos Santos³ Data ³ 15/05/11 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorno da comunica‡„o banc ria via Job                     ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Fa205Job()

Local nA
Local nB
Local nC
Local cQuery  
Local aVetPar 

Local cDirInc 		:= 	""   
Local xFilAnt		:=	cFilAnt

Local aArq			:= 	{}
Local aVetArqs 		:= 	{}

Local cPerg				:= 	PadR("AFI200",Len(SX1->X1_GRUPO))
Local lBarra    	:= 	IsSrvUnix()
Local lDirInc 		:= 	SEE->(ColumnPos("EE_INCREC")) > 0
Local cLocRec 		:= 	SuperGetMv( "MV_LOCREC" , .f. , " " )
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U"
Local cAliasSEE  	:= 	GetNextAlias()

SA6->(dbsetorder(1))
SEE->(dbsetorder(1))

Pergunte(cPerg,.f.,Nil,Nil,Nil,.f.)

cQuery	:= 	" SELECT R_E_C_N_O_ REGSEE "
cQuery 	+= 	" FROM " + RetSqlName("SEE") 
cQuery 	+= 	" WHERE EE_RETAUT IN ('1','3')                   AND " 
cQuery 	+= 		"   D_E_L_E_T_ = ' '                             "
cQuery 	+= 	" ORDER BY EE_DIRREC                                 "

dbusearea(.t.,'TOPCONN',TcGenQry(Nil,Nil,ChangeQuery(@cQuery)),cAliasSEE,.t.,.t.)

do while (cAliasSEE)->(!Eof())
	 aAdd( aVetArqs , (cAliasSEE)->REGSEE )
	(cAliasSEE)->(dbskip())
enddo

(cAliasSEE)->(dbclosearea())

For nC := 1 to Len(aVetArqs)

	SEE->(dbgoto(aVetArqs[nC]))

	// cFilAnt	:= SEE->EE_FILIAL

	/*__________________________________
	| Perguntas:						|
	| __________________________________|
	|									            |
	| 01	Mostra Lanc Contab ?		|
	| 02	Aglut Lancamentos ?			|
	| 03	Atualiza Moedas por ?		|
	| 04	Arquivo de Entrada ?		|
	| 05	Arquivo de Config ?			|
	| 06	Codigo do Banco ?			  |
	| 07	Codigo da Agencia ?			|
	| 08	Codigo da Conta ?			  |
	| 09	Codigo da Sub-Conta ?		|
	| 10	Abate Desc Comissao ?		|
	| 11	Contabiliza On Line ?		|
	| 12	Configuracao CNAB ?			|
	| 13	Processa Filial?			  |
	| 14	Contabiliza Transferencia ?	|
	| 15	Considera Dias de Retencao ?|
	|__________________________________*/

	if !SEE->EE_RETAUT $ "123" .or. Fa205Erro()
		Loop
	endif    
	
	Pergunte(cPerg,.f.,Nil,Nil,Nil,.f.)

	aVetPar	:= 	{	{ mv_par01	, '2'											}	,; // 01	Mostra Lanc Contab ?
					{ mv_par02	, SEE->EE_AGLCTB 								}	,; // 02	Aglut Lancamentos ?
					{ mv_par03	, SEE->EE_ATUMOE 								}	,; // 03	Atualiza Moedas por ?
					{ mv_par04	, mv_par04        								}	,; // 04	Arquivo de Entrada ?
					{ mv_par05	, SEE->EE_CFGREC								}	,; // 05	Arquivo de Config ?
					{ mv_par06	, SEE->EE_CODIGO								}	,; // 06	Codigo do Banco ?
					{ mv_par07	, SEE->EE_AGENCIA								}	,; // 07	Codigo da Agencia ?
					{ mv_par08	, SEE->EE_CONTA									}	,; // 08	Codigo da Conta ?
					{ mv_par09	, SEE->EE_SUBCTA								}	,; // 09	Codigo da Sub-Conta ?
					{ mv_par10	, SEE->EE_DESCOM								}	,; // 10	Abate Desc Comissao ?
					{ mv_par11	, iif( lIsBlind , '2' , StrZero(mv_par11,01) )	}	,; // 11	Contabiliza On Line ?
					{ mv_par12	, SEE->EE_CNABRC 								}	,; // 12	Configuracao CNAB ?
					{ mv_par13	, SEE->EE_PROCFL 								}	,; // 13	Processa Filial?
					{ mv_par14	, SEE->EE_CTBTRF								}	,; // 14	Contabiliza Transferencia ?
					{ mv_par15	, SEE->EE_RETBCO								}	}  // 15	Considera Dias de Retencao ?

	if !lIsBlind	
		if 	SX1->(dbseek( PadR(cPerg,Len(SX1->X1_GRUPO)) + "01" , .f. ))
    		aVetPar[01,02] := SX1->X1_CNT01
		endif
	endif

	// if	lCCL .or. lCheck  
  //  		aVetPar[01,02] := '1'
  //  		aVetPar[02,02] := '2'
  //  		aVetPar[03,02] := '3'
  //  		aVetPar[11,02] := iif( lIsBlind , '2' , '1' )
	// endif

	if 	lBarra
		cDirArq		:= 	StrTran(Alltrim(SEE->EE_DIRREC),"\","/")
		cDirBk 		:= 	cDirArq + "PROCESSADOS\"
		cLocRec		:= 	StrTran(cLocRec,"\","/")
	else
		cDirArq		:= 	StrTran(Alltrim(SEE->EE_DIRREC),"/","\")
		cDirBk 		:= 	cDirArq + "PROCESSADOS\"
		cLocRec		:= 	StrTran(cLocRec,"/","\")
	endif
	
	if 	lDirInc
		cDirInc		:= 	Alltrim(SEE->EE_INCREC)			
	endif
	
	if 	Empty(cLocRec)
		if 	Empty(cDirArq)
			aArq	:= 	Directory("*.RET","S")
		else
			aArq    := 	Directory(cDirArq + "*.RET")
		endif
	else
		if 	Empty(cDirArq)
			aArq	:= 	Directory(cLocRec + "*.RET","S")
		else
			aArq    := 	Directory(cDirArq + "*.RET")
		endif
	endif
	
	For nA := 1 to Len(aArq)

		aVetPar[04,02] := aArq[nA,01]				

		SX1->(dbsetorder(1))   
		
		For nB := 1 to Len(aVetPar)
			if 	SX1->(dbseek( PadR(cPerg,Len(SX1->X1_GRUPO)) + Strzero(nB,2) , .f. ))
				Reclock("SX1",.f.)
				SX1->X1_CNT01 		:= 	aVetPar[nB,2]
				if 	SX1->X1_GSC == "C"
					SX1->X1_PRESEL	:= 	Val(aVetPar[nB,2])
				endif
				MsUnlock("SX1")
		    endif
		Next nB

		aVet650	:= 	{	{ mv_par01	, aVetPar[04,2]		} ,; 	// 01 Arquivo de Entrada ?
						{ mv_par02	, SEE->EE_CFGREC	} ,; 	// 02 Arquivo de Config ?
						{ mv_par03	, SEE->EE_CODIGO	} ,; 	// 03 Codigo do Banco ?
						{ mv_par04	, SEE->EE_AGENCIA	} ,; 	// 04 Codigo da Agencia ?
						{ mv_par05	, SEE->EE_CONTA		} ,; 	// 05 Codigo da Conta ?
						{ mv_par06	, SEE->EE_SUBCTA	} ,; 	// 06 Codigo da SubConta ?
						{ mv_par07	, "1"				} ,; 	// 07 Carteira ?  1 = Receber ; 2 = Pagar
						{ mv_par08	, SEE->EE_CNABRC	} }  	// 08 Configuracao CNAB ?

		SX1->(dbsetorder(1))

		For nB := 1 to Len(aVet650)
			if 	SX1->(dbseek( PadR("FIN650",Len(SX1->X1_GRUPO)) + Strzero(nB,2) , .f. ))
				Reclock("SX1",.f.)
				SX1->X1_CNT01 		:= 	aVet650[nB,2]
				if 	SX1->X1_GSC == "C"
					SX1->X1_PRESEL	:= 	Val(aVet650[nB,2])
				endif
				MsUnlock("SX1")
		    endif
		Next nB

  		aMsgSch	:= 	{}
  		aFA205R	:= 	{}

		ProcLogAtu("INICIO","Retorno Bancario Automatico (Receber) - Arquivo : " + aVetPar[04,2]) 

		SaveInter()

//		FINR650()

		INCLUI := .f.
		ALTERA := .f.

		SetFunName("FINA200")

		FINA200()

		Pergunte(cPerg,.f.,Nil,Nil,Nil,.f.)  

		FA205Mail("Retorno Bancario Automatico (Receber)",aVetPar[04,2],aMsgSch) 

		RestInter()

		cArq := aArq[nA,01]

		if !_CopyFile(cDirArq + cArq,cDirBk + cArq)
			aAdd(aMsgSch,STR0021 + cArq + STR0022 + cDirBk + STR0023)
		else
			fErase(cDirArq + cArq)
			if 	File(cDirArq + cArq)
				aAdd(aMsgSch,STR0024 + cArq + STR0025 + cDirBk)
			endif
		endif

		ProcLogAtu("FIM","Retorno Bancario Automatico (Receber) - Arquivo : " + cArq)    
		
		cPerg := PadR("AFI200",Len(SX1->X1_GRUPO))

		Sleep(3000)

	Next nA

Next nC

cFilAnt	:= xFilAnt

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA205Mail ³ Autor ³ Aldo Barbosa dos Santos        ³08/06/11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³Prepara os dados para envio de email 						  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Fa205Mail(cTitulo,cArq,aMsgSch,lEnvAtch)

Local nAux			:= 	0

Local cBody			:= 	""
Local cMsgErr     	:= 	""
Local cAttach     	:= 	""
Local cSubject		:= 	""

Local aDestE		:= 	{}
Local aFa205Mail  	:= 	{}

Local lSendMail		:= 	.f.

Local aArea			:= 	GetArea()
Local cDestE      	:= 	SuperGetMv("MV_RETMAIL",.f.,"") 
Local lFa205Mail  	:= 	ExistBlock('Fa205Mail')  

Default cTitulo 	:= 	"Retorno Bancario Automatico"
Default cArq    	:= 	"ARQ.NAO.INFORMADO"
Default lEnvAtch	:= 	.t.  

if	"ABEL_FILHO" $ Upper(Alltrim(cusername))
	cDestE			:=	"abel.filho@babini.com.br"
endif

if 	ValType(cDestE) <> "C" .or. Empty(cDestE)
	Return 
endif

aDestE := StrTokArr(cDestE,";")

if 	Len(aDestE) == 0
	Return 
endif

if 	Len(aMsgSch) == 0
	Return 
endif

cSubject := cTitulo + ' - Arquivo : ' + cArq + ' Processamento : ' + DtoC(dDataBase) + ' - ' + Time()

cBody	:= 	'<HTML>'
cBody	+= 	' <HEAD>'
cBody	+= 	'  <TITLE>' + cTitulo + ' - Arquivo : ' + cArq + '</TITLE>'
cBody	+= 	' </HEAD>'
cBody	+= 	' <BODY>'
cBody	+= 	'  <H1>'
cBody	+= 	'   <FONT SIZE="4" COLOR="#000099">'
cBody	+= 	'    <B>' + cTitulo + '</B>'
cBody	+= 	'   </FONT>'
cBody	+= 	'  </H1>'
cBody 	+= 	'  <BR>
cBody	+= 	'   <FONT SIZE="3" COLOR="#000099">'
cBody	+= 	'    <B>Arquivo: ' + cArq + '</B>'
cBody	+= 	'   </FONT>'
cBody	+= 	'  <H1><HR></H1>'

if 	Len(aMsgSch) >= 0
	cBody	+= 	'  <H1>'
	cBody	+= 	'   <FONT SIZE="3" COLOR="#000000">'
	cBody	+= 	'    Mensagens do Processamento : '
	cBody	+= 	'   </FONT>'
	cBody	+= 	'  </H1>'
	if 	Len(aMsgSch) == 0
		cBody += '<BR>&nbsp;&nbsp;-&nbsp;Processamento sem inconsistencias'
	else
		For nAux := 1 To Len(aMsgSch)
			cBody += '<BR>&nbsp;&nbsp;-&nbsp;' + aMsgSch[nAux]
		Next nAux
	endif	
	cBody	+= 	'  <H1><HR></H1>'
endif

cBody	+= 	'  <H1>'
cBody	+= 	'   <FONT SIZE="2" COLOR="#FF0000">'
cBody	+= 	'    ' + cSubject
cBody	+= 	'   </FONT>'
cBody	+= 	'  </H1>'
cBody	+= 	' </BODY>'
cBody	+= 	'</HTML>'

if 	lFa205Mail
	aFa205Mail := ExecBlock('Fa205Mail',.f.,.f.,{cSubject,cBody,aDestE,aMsgSch})
	if 	ValType(aFa205Mail ) == 'A'
		if 	ValType(aFa205Mail[1]) == 'C'
			cSubject := aFa205Mail[1]  				// assunto
		endif
		if 	ValType(aFa205Mail[2]) == 'C'
			cBody  	:= aFa205Mail[2]  				// corpo do email
		endif
		if 	ValType(aFa205Mail[3]) == 'A'
			aDestE	:= aClone(aFa205Mail[3])  		// destinatarios
		endif
		if 	ValType(aFa205Mail[4]) == 'A'
			aMsgSch := aClone(aFa205Mail[4])		// mensagens de erro
		endif
	endif
endif

if 	lEnvAtch
	cAttach := Upper(cDirArq + mv_par04)
endif

if !Empty(cSubject) .and. !Empty(cBody) .and. !Empty(aDestE)
	lSendMail := Fa205SendMail( aDestE , cSubject , cBody , cAttach )
  	if !lSendMail .and. !Empty(cMsgErr)
  		ConOut(cMsgErr)  
  	endif
endif

RestArea(aArea)

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡„o    ³FA205Erro ³ Autor ³ Aldo Barbosa dos Santos        ³09/06/11³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³le os dados do pergunte									  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function Fa205Erro()

Local nA
Local aCpoVld 	:= 	{}		
Local lErrVld	:= 	.f.	

if 	SEE->EE_RETAUT $ '1/3' 		// receber ou ambos
	aAdd(aCpoVld,{'EE_ATUMOE',	{|| Alltrim(SEE->EE_ATUMOE) <> '' }	,.f.})	// Atualiza Moeda
	aAdd(aCpoVld,{'EE_DIRREC',	{|| Alltrim(SEE->EE_DIRREC) <> '' }	,.f.})	// Diretorio de Importacao Recebimento
	aAdd(aCpoVld,{'EE_CFGREC',	{|| Alltrim(SEE->EE_CFGREC) <> '' }	,.f.})	// Diretorio de Configuracao Recebimento
	aAdd(aCpoVld,{'EE_BKPREC',	{|| Alltrim(SEE->EE_BKPREC) <> '' }	,.f.})	// Diretorio de Backup Recebimento
	aAdd(aCpoVld,{'EE_DESCOM',	{|| Alltrim(SEE->EE_DESCOM) <> '' }	,.f.})	// Abate desconto da Comissao
	aAdd(aCpoVld,{'EE_CNABRC',	{|| Alltrim(SEE->EE_CNABRC) <> '' }	,.f.})	// Configuracao CNAB Recebimento
	aAdd(aCpoVld,{'EE_PROCFL',	{|| Alltrim(SEE->EE_PROCFL) <> '' }	,.f.})	// Processa Filial
endif	                        

if 	SEE->EE_RETAUT == '23'  	// pagar ou ambos
	aAdd(aCpoVld,{'EE_DIRPAG',	{|| Alltrim(SEE->EE_DIRPAG) <> '' }	,.f.})	// Diretorio de Importacao Recebimento
	aAdd(aCpoVld,{'EE_CFGPAG',	{|| Alltrim(SEE->EE_CFGPAG) <> '' }	,.f.})	// Diretorio de Configuracao Recebimento
	aAdd(aCpoVld,{'EE_BKPPAG',	{|| Alltrim(SEE->EE_BKPPAG) <> '' }	,.f.})	// Diretorio de Backup Recebimento
	aAdd(aCpoVld,{'EE_CNABPG',	{|| Alltrim(SEE->EE_CNABPG) <> '' }	,.f.})	// Configuracao CNAB Recebimento
endif

if 	SEE->EE_RETAUT == '3'  		// ambos
	aAdd(aCpoVld,{'EE_AGLCTB',	{|| Alltrim(SEE->EE_AGLCTB) <> ' ' }	,.f.})	// Aglutina lancamento contabil
	aAdd(aCpoVld,{'EE_MULTNT',	{|| Alltrim(SEE->EE_MULTNT) <> ' ' }	,.f.})	// Considera Multiplas naturezas
endif

For nA := 1 to Len(aCpoVld)
	if !Eval(aCpoVld[nA,2])
		aCpoVld[nA,3]	:= 	.t.  
		lErrVld 		:= 	.t.
	endif
Next nA

if 	lErrVld
	ProcLogAtu("INICIO","Retorno Bancario Automatico (Receber) - Parametros de Bancos - Banco : " + SEE->EE_CODIGO + " " + SEE->EE_AGENCIA + " " + SEE->EE_CONTA + " " + SEE->EE_SUBCTA) 
	For nA := 1 to Len(aCpoVld)
		if 	aCpoVld[nA,3]
			ProcLogAtu("ALERTA","Campo :" + aCpoVld[nA,1] + " com conteudo invalido ou nao informado.") 
		endif
	Next
	ProcLogAtu("FIM","Retorno Bancario Automatico (Receber) - Parametros de Bancos - Banco : " + SEE->EE_CODIGO + " " + SEE->EE_AGENCIA + " " + SEE->EE_CONTA + " " + SEE->EE_SUBCTA) 
endif		

Return ( lErrVld )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³FA205SENDMAIL ºAutor  ³ Aldo Barbosa dos Santos  º Data ³ 10/06/2011  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Rotina de envio de e-mail                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FA205SendMail( aDest, cAssunto, cMensagem, cAttach )

Local lRet	    := 	.f.								// Se tem autorizacao para o envio de e-mail
Local lResult   := 	.f.								// Se a conexao com o SMPT esta ok
Local nCntFor	:=	Nil

Local cError    := 	""								// String de erro
Local cEmailTo  := 	""								// E-mail de destino
Local cEmailBcc := 	""								// E-mail de copia

Local cPsw      := 	Trim(GetMV('MV_RELAPSW')) 		// Senha de acesso Ex.: 123abc
Local cFrom	    := 	Trim(GetMV('MV_RELFROM')) 		// e-mail utilizado no campo From'MV_RELACNT' ou 'MV_RELFROM' e 'MV_RELPSW'
Local cConta    := 	Trim(GetMV('MV_RELACNT')) 		// Conta Autenticacao Ex.: fuladetal@fulano.com.br
Local cCtaAut   := 	Trim(GetMV('MV_RELAUSR')) 		// usuario para Autenticacao Ex.: fuladetal
Local cServer   := 	Trim(GetMV('MV_RELSERV')) 		// Ex.: smtp.ig.com.br ou 200.181.100.51
Local lRelauth  := 	SuperGetMv("MV_RELAUTH",,.f.)	// Parametro que indica se existe autenticacao no e-mail

Local aArea     := 	GetArea()

Default cAttach := 	""  

cEmail 			:= 	""

For nCntFor := 1 To Len(aDest)
	cEmail += iif( !Empty(cEmail) , ';' , "" ) + aDest[nCntFor]
Next nCntFor

cEmailTo 		:= 	cEmail

CONNECT SMTP SERVER cServer ACCOUNT cConta PASSWORD cPsw RESULT lResult

if 	lResult
	
	if 	lRelauth
		lRet 	:= 	Mailauth( cCtaAut, cPsw )
	else
		lRet 	:= 	.t.
	endif
	
	if 	lRet                    
	
		SEND MAIL				; 
		FROM 		cFrom		;
		TO      	cEmailTo	;
		BCC     	cEmailBcc	;
		SUBJECT 	cAssunto	;
		BODY    	cMensagem	;
		ATTACHMENT  cAttach  	;
		RESULT 		lResult
		
		if !lResult
			GET MAIL ERROR cError
			if !IsBlind()
				Help(" ",1,"01 - ATENCAO",,cError + " " + cEmailTo,04,05)
			else
				ApMsgInfo("01 - ATENCAO " + cError + " " + cEmailTo )
			endif
		endif
	else
		GET MAIL ERROR cError
		if !IsBlind()
			Help(" ",1,"02 - AUTENTICACAO", ,cError,04,05) 
		else
			ApMsgInfo("02 - " + STR0016 +" " + STR0017 )
		endif
	endif
	
	DISCONNECT SMTP SERVER
else
	GET MAIL ERROR cError
	if !IsBlind()
		Help(" ",1,"03 - ATENCAO",,cError,04,05)
	else
		ApMsgInfo("03 - ATENCAO " + cError)
	endif
endif
 
RestArea( aArea )

Return( lResult )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XFINA205  ºAutor  ³Microsiga           º Data ³  03/03/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±³Descri‡…o ³ Retorno da comunica‡„o banc ria - Receber                  ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function FinA200(nPosArotina)

Private aTit  
Private cStProc 	:= 	""
Private	cTipoBx  	:= 	""
Private cArqCfg  	:= 	""
Private nVlrcnab 	:= 	00
Private lExecJob 	:= 	.t.

Private cPerg		:= 	"AFI200"
Private lF200Cus  	:= 	ExistBlock("F200CUS") 
Private lMVGlosa   	:= 	GetNewPar("MV_GLOSA",.F.) 
Private __lTemFK0 	:=	iif( FindFunction("FTEMMOTOR") , FTemMotor() , .f. )
Private lMVCNABImp	:= 	GetNewPar("MV_CNABIMP",.F.)

if 	lExecJob
	nPosArotina 	:= 	3  
//	lExecJob 		:=	iif( IsInCallStack("U_XCALLGENERAL") , .f. , .t. )
endif

/*__________________________________
| Perguntas:						|
| __________________________________|
|									|
| 01	Mostra Lanc Contab ?		|
| 02	Aglut Lancamentos ?			|
| 03	Atualiza Moedas por ?		|
| 04	Arquivo de Entrada ?		|
| 05	Arquivo de Config ?			|
| 06	Codigo do Banco ?			|
| 07	Codigo da Agencia ?			|
| 08	Codigo da Conta ?			|
| 09	Codigo da Sub-Conta ?		|
| 10	Abate Desc Comissao ?		|
| 11	Contabiliza On Line ?		|
| 12	Configuracao CNAB ?			|
| 13	Processa Filial?			|
| 14	Contabiliza Transferencia ?	|
| 15	Retencao Banc.Transferencia?|
| 16	Cons.Juros Comissão ?       |
| 17	Retenção Bancária Despesa?  |
|__________________________________*/

SX1->(dbsetorder(1)) 

if 	SX1->(dbseek( PadR(cPerg,Len(SX1->X1_GRUPO),' ') + '17')) 
	__lPar17		:= 	.t.
endif

Pergunte(cPerg,.f.,Nil,Nil,Nil,.f.)  

Private nSeq 		:= 	0 
Private Valor  		:= 	0
Private nOtrGa		:= 	0     
Private nTamNat		:= 	0
Private nHdlPrv 	:= 	0
Private nHdlBco		:= 	0
Private nTotAbat 	:= 	0
Private nHdlConf 	:= 	0
Private nTotAGer	:= 	0
Private Abatimento 	:= 	0
Private nValEstrang := 	0

Private cConta 		:= 	" "
Private cMotBx 		:= 	"NOR"
Private cMarca 		:= 	GetMark()
Private aRotina 	:= 	&('StaticCall(FINA200,MENUDEF)')
Private lOracle		:= 	"ORACLE" $ Upper(TcGetDB())
Private cLotefin 	:= 	Space(TamSx3("EE_LOTE")[1])
Private cCadastro 	:= 	"Comunicação Bancária - Retorno"

Default nPosArotina	:=	0

mv_par04 			:= 	Upper(cDirArq + mv_par04)

if 	nTamNat == 0
	F200VerNat()
endif

dbSelectArea('SE1')

fa200Gera(Alias())  

fClose(nHdlBco)
fClose(nHdlConf)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XCADZPC   ºAutor  ³Microsiga           º Data ³  08/30/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Static Function ChecaEmp(cPesq) 

Local lRet	:=	.f.
Local aArea	:=	SM0->(GetArea())

SM0->(dbgotop())
do while SM0->(!Eof())     
	if	SM0->(deleted())
		SM0->(dbskip())
		Loop
	endif
	if	Upper(Alltrim(cPesq)) $ Upper(Alltrim(SM0->M0_NOMECOM))
		lRet := .t. 
	endif
	if	lRet
		Exit
	endif
	SM0->(dbskip())
enddo

RestArea(aArea)

Return ( lRet )     

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XFINA205  ºAutor  ³Microsiga           º Data ³  03/04/20   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

// User Function 200GEMBX()

// dDataBase := iif( Len(ParamIxb) >= 1 .and. Len(ParamIxb[1]) >= 2 , ParamIxb[01,02] , ParamIxb[02] )

/*
UPDATE CT2010 
SET CT2_HIST = 'BX. TIT. ' + CT2_NUM + ' ' + SE1010.E1_NOMCLI 
--SELECT	SE1010.E1_NOMCLI , CT2010.*
FROM	CT2010 , SE1010 
WHERE	CT2010.CT2_FILIAL	= SE1010.E1_FILIAL		AND 
		CT2010.CT2_PREFIX	= SE1010.E1_PREFIXO		AND 
		CT2010.CT2_NUM		= SE1010.E1_NUM    		AND 
		CT2010.CT2_PARCEL	= SE1010.E1_PARCELA		AND 
		CT2010.CT2_TIPO  	= SE1010.E1_TIPO   		AND 
		CT2010.CT2_CLIFOR 	= SE1010.E1_CLIENTE		AND 
		CT2010.CT2_FILIAL	= '05'					AND 
		CT2010.CT2_DATA		= '20200309'			AND 
		CT2010.CT2_HIST		IN ('BAIXA DE TITULOS NESTA DATA','BAIXA DE TITS A RECEBER NESTA DATA')
--ORDER BY 3,4,5	--CT2_DATA DESC , R_E_C_N_O_ DESC 
*/

// Return 
