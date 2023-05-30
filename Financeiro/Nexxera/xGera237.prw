#include 'topconn.ch'                    		  		                    		
#include 'protheus.ch'    	 			                		  		                    		
     	
#define MB_OK                 00      		   		
#define MB_OKCANCEL           01
#define MB_YESNO              04           		
#define MB_ICONHAND           16
#define MB_ICONQUESTION       32
#define MB_ICONEXCLAMATION    48
#define MB_ICONASTERISK       64

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xGera237 BºAutor  ³Alexandre Zapponi   º Data ³  01/01/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o arquivo CNAB do Bradesco para a rotina xPrepPag      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/
           	
User Function xGera237(aPar,cDir,lAlert,xDir,cSub,lOnly,xSeg,lExcluir,nRecnoSEA)  	  	   						 	

Local lRet          
Local xFin     
Local xLot
Local xTot
Local nQtd			:=	0
Local nTot			:=	0
Local nSeq			:=	0
Local nValPri		:=	0
Local nValMul		:=	0
Local nValJur		:=	0    
Local cBco			:=	aPar[01]
Local cAge			:=	aPar[02]
Local cCon			:=	aPar[03]
Local cBor			:=	aPar[05]    
Local xBor			:=	aPar[05]    
Local xPesq			:=	""
Local xCNPJ			:=	""
Local cQuery		:=	""	 
Local cTexto		:=	""	 
Local cValor		:=	""
Local cConta		:=	""
Local cAgencia		:=	""
Local cDigAge		:=	""
Local cDigCta		:=	""
Local cSeqArq		:=	""
Local cVctBol		:=	""
Local xArquivo		:=	""

Local lFilCen 		:=	SuperGetMv("ZZ_AGTFILC",.f.,.f.)
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U"

Local lSE2Excl		:=	FwModeAccess("SE2") == "E"
Local lSA2Excl		:=	FwModeAccess("SA2") == "E"

Default xSeg		:=	""
Default cSub		:=	""
Default xDir		:=	""                             
Default lOnly		:=	.f.
Default lAlert		:=	.t.
Default lExcluir	:=	.f.   
Default nRecnoSEA	:=	000

Private xValPri		:=	0
Private xValMul		:=	0
Private xValJur		:=	0

if	lIsBlind
	ConOut("")
	ConOut("Banco           : " + cBco )
	ConOut("Agencia         : " + cAge )
	ConOut("Conta           : " + cCon )
	ConOut("Sub-Conta       : " + cSub )
	ConOut("Bordero         : " + cBor )
	ConOut("Diretorio       : " + cDir )
	ConOut("")
endif

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
//	lFilCen 		:=	.t.
endif

if	lFilCen 		
	xPesq	:=	SuperGetMv("ZZ_FILAGTB",.f.,cFilAnt) 
	xPesq	:=	iif( "ZAPPONI" $ Upper(Alltrim(GetEnvServer())) , "01" , xPesq )
else
	xPesq	:=	Nil
endif

if	lOnly	  
	//---------------------------------------------------------------------------
	// Analisa o tipo de bordero e define quais headers, traillers e detalhes
	// de lote que ser„o utilizados.
	//---------------------------------------------------------------------------
	/* Identificadores
		A - Header Arquivo
		B - Header Lote 1   ÄÄ´ Header Lote Cheque/OP/DOC/Cred.CC
		C - Header Lote 2   ÄÄ´ Header Lote Cob Ita£/Outros Bancos
		D - Trailer Lote 1  ÄÄ´ Trailler Lote Cheque/OP/DOC/Cred.CC
		E - Trailer Lote 2  ÄÄ´ Trailler Lote Cob Ita£/Outros Bancos
		F - Trailer Arquivo
		G - Segmento A  Cheque/OP/DOC/Cred.CC
		H - Segmento B  ""          ""
		I - Segmento L  ÄÄÄÄÄÄ´ Cob Ita£/Outros Bancos
	------------------------------------------------------------------------- */
	/* Identificadores no CNAB
		5Tipo 5         0012400ExecBlock("FGERA237",.f.,.f.,"5")                           
		ATipo A         0012400ExecBlock("FGERA237",.f.,.f.,"A")                           
		BTipo B         0012400ExecBlock("FGERA237",.f.,.f.,"B")                           
		CTipo C         0012400ExecBlock("FGERA237",.f.,.f.,"C")                           
		DTipo D         0012400ExecBlock("FGERA237",.f.,.f.,"D")                           
		ETipo E         0012400ExecBlock("FGERA237",.f.,.f.,"E")                           
		FTipo F         0012400ExecBlock("FGERA237",.f.,.f.,"F")                           
		GTipo G         0012400ExecBlock("FGERA237",.f.,.f.,"G")                           
		HTipo H         0012400ExecBlock("FGERA237",.f.,.f.,"H")                           
		ITipo I         0012400ExecBlock("FGERA237",.f.,.f.,"I")                           
		JTipo J         0012400ExecBlock("FGERA237",.f.,.f.,"J")                           
		KTipo K         0012400ExecBlock("FGERA237",.f.,.f.,"K")                           
		NTipo N         0012400ExecBlock("FGERA237",.f.,.f.,"N")                           
		OTipo O         0012400ExecBlock("FGERA237",.f.,.f.,"O")                           
	------------------------------------------------------------------------- */
	if	xSeg == "A"	             
		Public xValTot	:=	0
		Public xNumLot	:=	0
		Public xNumSeq	:=	0
		Public xQtdArq	:=	0
		Public xRecArq	:=	0
	endif    
else	 
	Public xValTot	:=	0
	Public xNumLot	:=	Nil
	Public xNumSeq	:=	Nil
	Public xQtdArq	:=	Nil
	Public xRecArq	:=	Nil

	SEA->(dbsetorder(2))
	SEA->(dbgotop())  
	if	SEA->(dbseek( xFilial("SEA",xPesq) + cBor + "P" , .f. )) .or. SEA->(dbseek( xFilial("SEA") + cBor + "P" , .f. ))
		if	lIsBlind
			ConOut("Bordero encontrado para geracao de CNAB") 	
		endif
	else
		if	lIsBlind
			ConOut("Bordero não encontrado para geracao de CNAB") 	
		else
			MessageBox("Borderô não encontrado para geração de CNAB","Atenção",MB_ICONHAND) 	
		endif
		Return 	
	endif	   
	
	SA6->(dbsetorder(1))
	SA6->(dbgotop())  
	if	SA6->(dbseek( xFilial("SA6",xPesq) + cBco + cAge + cCon , .f. )) .or. SA6->(dbseek( xFilial("SA6") + cBco + cAge + cCon , .f. ))
		if	lIsBlind
			ConOut("Banco referente ao bordero encontrado para geracao de CNAB") 	
		endif
	else
		if	lIsBlind
			ConOut("Banco referente ao bordero nao encontrado para geracao de CNAB") 	
		else
			MessageBox("Banco referente ao borderô não encontrado para geração de CNAB","Atenção",MB_ICONHAND) 	
		endif
		Return 	
	endif	   
	
	cSub := iif( Empty(cSub) , iif( SA6->(FieldPos('A6_ZZSUBP')) <> 0 .and. !Empty(SA6->A6_ZZSUBP) , SA6->A6_ZZSUBP , '000' ) , cSub )
	
	SEE->(dbsetorder(1))
	SEE->(dbgotop())  
	if	SEE->(dbseek( xFilial("SEE",xPesq) + cBco + cAge + cCon + cSub , .f. )) .or. SEE->(dbseek( xFilial("SEE") + cBco + cAge + cCon + cSub , .f. ))
		if	lIsBlind
			ConOut("Subconta do Banco referente ao bordero encontrado para geracao de CNAB") 	
		endif
	else
		if	lIsBlind
			ConOut("Subconta do Banco referente ao bordero nao encontrado para geracao de CNAB") 	
		else
			MessageBox("Subconta do Banco referente ao borderô não encontrado para geração de CNAB","Atenção",MB_ICONHAND) 	
		endif
		Return 	
	endif	   
endif	   
	
cSeqArq		:=	StrZero(Val(SEE->EE_FAXATU) + 1,06) 
xArquivo	:=	iif( Empty(xDir) , cDir + iif( lFilCen , xPesq , cFilAnt ) + cBor + "." + SEE->EE_EXTEN , xDir )

if	"-" $ SA6->A6_AGENCIA	
	cAgencia	:=	Alltrim(StrTran(Alltrim(SA6->A6_AGENCIA),"-",""))
	cDigAge		:=	Substr(cAgencia,Len(cAgencia),01)
	cAgencia	:=	Substr(cAgencia,01,Len(cAgencia) - 1)
else
	cAgencia	:=	SA6->A6_AGENCIA
	cDigAge		:=	SA6->A6_DVAGE
endif

if	"-" $ SA6->A6_NUMCON	
	cConta		:=	Alltrim(StrTran(Alltrim(SA6->A6_NUMCON),"-",""))
	cDigCta		:=	Substr(cConta,Len(cConta),01)
	cConta		:=	Substr(cConta,01,Len(cConta) - 1)
else
	cConta		:=	Alltrim(StrTran(SA6->A6_NUMCON + SA6->A6_DVCTA," ",""))
	cDigCta		:=	Substr(cConta,Len(cConta),01)
	cConta		:=	Substr(cConta,01,Len(cConta) - 1)
endif       

///////////////////////
// Header do Arquivo //  
///////////////////////

if	lOnly .and. xSeg == "A"			             
	cTexto 	:= 	""   
	xQtdArq	+=	01	
endif

nQtd 	+=	1
cTexto	+=	"237"																						//	001 a 003 - Codigo do banco           
cTexto	+=	"0000"																						//	004 a 007 - Lote de Servico           
cTexto	+=	"0"    																						//	008 a 008 - Tipo de Registro          
cTexto	+=	Space(09)																					//	009 a 017 - Brancos                   
cTexto	+=	"2"       																					//	018 a 018 - Tipo de inscricao da empresa ( 1 = CPF / 2 = CNPJ )
cTexto	+=	ExecBlock("SRETINFO",.f.,.f.,"CGC")															//	019 a 032 - CNPJ da empresa
cTexto	+=	StrZero(Val(Alltrim(SEE->EE_CODEMP)),06)													//	033 a 038 - Convenio       
cTexto	+=	Space(14)       																			//	039 a 052 - Brancos        
cTexto	+=	StrZero(Val(cAgencia),05)			 														//	053 a 057 - Agencia mantenedora da conta
cTexto	+=	PadR(cDigAge,01)              																//	058 a 058 - Digito da agencia mantenedora da conta
cTexto	+=	StrZero(Val(cConta),12)					  													//	059 a 070 - Conta corrente              
cTexto	+=	StrZero(Val(cDigCta),01)						  											//	071 a 071 - Digito da conta                      
cTexto	+=	Space(01)										  						 					//	072 a 072 - Brancos                    
cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"NOME"),30))								   		// 	073 a 102 - Nome da Empresa
cTexto	+=	PadR("BANCO BRADESCO",30)    					       										// 	103 a 132 - Nome do Banco    
cTexto	+=	Space(10)                    					       										// 	133 a 142 - Brancos          
cTexto	+=	"1"                          					       										// 	143 a 143 - 1 = Remessa      
cTexto	+=	GravaData(Date(),.f.,5)							       										// 	144 a 151 - Data da Geracao  
cTexto	+=	StrTran(Time(),':','')							       										// 	152 a 157 - Hora da Geracao  
cTexto	+=	StrZero(Val(Alltrim(SEA->EA_NUMBOR)),06)			   										// 	158 a 163 - NSA
cTexto	+=	'089'                       					       										// 	164 a 166 - Versão           
cTexto	+=	"01600"                     					       										// 	167 a 171 - Densidade de Gravacao
cTexto	+=	Space(69)                   					       										// 	172 a 240 - Brancos              
cTexto	+=	CRLF

if	lOnly .and. xSeg == "A"	   
	Return ( cTexto )
endif

////////////////////
// Header do Lote //
////////////////////

if	lOnly .and. xSeg $ "B/C"			             
	cTexto 	:= 	""
	xQtdArq	+=	01	
	xNumLot	+=	01	
	xLot	:=	xNumLot
else	
	xLot	:=	01
endif

// 01 - Credito em conta corrente
// 02 - Cheque pagamento / administrativo
// 03 - Doc C 
// 04 - Op a disposicao Com aviso
// 05 - Credito em conta poupanca
// 06 - Credito em conta corrente mesma titularidade
// 07 - Doc D
// 10 - Op a disposicao Sem aviso
// 41 - TED - Outro Titular
// 43 - TED - Mesmo Titular

if	SEA->EA_MODELO $ "01/02/03/04/05/06/07/10/41/43"  
	
	nQtd 	+=	1
	cTexto	+=	"237"																					//	001 a 003 - Codigo do banco
	cTexto	+=	StrZero(xLot,04)																		//	004 a 007 - Lote de Servico
	cTexto	+=	"1"    																					//	008 a 008 - Tipo de Registro
	cTexto	+=	"C"    																					//	009 a 009 - C = Credito
	cTexto	+=	SEA->EA_TIPOPAG																			//	010 a 011 - 20 = Pagamento a fornecedores
	cTexto	+=	PadR(SEA->EA_MODELO,02)																	//	012 a 013 - Forma de lancamento
	cTexto	+=	"045"																					//	014 a 016 - Versao do lote
	cTexto	+=	Space(01)																				//	017 a 017 - Brancos
	cTexto	+=	"2"      																				//	018 a 018 - 2 = CNPJ
	cTexto	+=	ExecBlock("SRETINFO",.f.,.f.,"CGC")								      					//	019 a 032 - CNPJ
	cTexto	+=	StrZero(Val(Alltrim(SEE->EE_CODEMP)),06)												//	033 a 038 - Convenio
	cTexto	+=	Space(14)        																		//	039 a 052 - Brancos
	cTexto	+=	StrZero(Val(cAgencia),05)		 														//	053 a 057 - Agencia mantenedora da conta
	cTexto	+=	PadR(cDigAge,01)            															//	058 a 058 - Digito da agencia mantenedora da conta
	cTexto	+=	StrZero(Val(cConta),12)																	//	059 a 070 - Conta corrente              	
	cTexto	+=	StrZero(Val(cDigCta),01)					  											//	071 a 071 - Digito da conta                 	     
	cTexto	+=	Space(01)									  						 					//	072 a 072 - Brancos                    
	cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"NOME"),30))   									// 	073 a 102 - Nome da Empresa
	cTexto	+=	Space(30)                                           									// 	103 a 132 - Finalidade do Lote
	cTexto	+=	Space(10)                                           									// 	133 a 142 - Complemento de Historico
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"END"),30)											// 	143 a 172 - Endereco da Empresa
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"NUM"),05)       										// 	173 a 177 - Numero da Empresa
	cTexto	+=	Space(15)                                           									// 	178 a 192 - Complemento
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"CID"),20)	   										// 	193 a 212 - Cidade
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"CEP"),08)   	   										// 	213 a 220 - CEP
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"EST"),02)       										// 	221 a 222 - Estado
	cTexto	+=	'01'                                                									// 	223 a 224 - Forma Pagamento
	cTexto	+=	Space(06)                                           									// 	225 a 230 - Febraban
	cTexto	+=	Space(10)                                           									// 	231 a 240 - Ocorrencias
	cTexto	+=	CRLF

// 11 - Pagamento a Impostos com Código de Barras
// 12 - Pagamento a FGTS com código de Barras 
// 13 - Pagamento a Concessionarias
// 16 - Pagamento de Tributos DARF
// 17 - Pagamento de Tributos GPS
// 18 - Pagamento de Tributos DARF SIMPLES
// 19 - Pagamento de IPTU 
// 21 - Pagamento de Tributos DARJ
// 22 - Pagamento de Tributos GARE ICMS SP
// 25 - Pagamento de Tributos IPVA (SP e MG)
// 27 - Pagamento de Tributos DPVAT
// 28 - GR-PR com Codigo de Barras
// 29 - GR-PR sem Codigo de Barras
// 30 - Liquidacao de titulos em cobranca no Bradesco
// 31 - Pagamento de titulos em outros bancos
// 35 - Pagamento de Tributos FGTS - GFIP 

elseif	SEA->EA_MODELO $ "11/12/13/16/17/18/19/21/22/25/27/28/29/30/31/35"
	
	nQtd 	+=	1
	cTexto	+=	"237"																					//	001 a 003 - Codigo do banco
	cTexto	+=	StrZero(xLot,04)																		//	004 a 007 - Lote de Servico
	cTexto	+=	"1"    																					//	008 a 008 - Tipo de Registro
	cTexto	+=	"C"    																					//	009 a 009 - C = Credito
	cTexto	+=	ExecBlock("SRETBRAD",.f.,.f.,"TIPO")													//	010 a 011 - Tipo do Pagamento
	cTexto	+=	ExecBlock("SRETBRAD",.f.,.f.,"FORMA")													//	012 a 013 - Forma de lancamento
	cTexto	+=	iif( SEA->EA_MODELO $ "30/31" , "040" , "012" )											//	014 a 016 - Versao do lote
	cTexto	+=	Space(01)																				//	017 a 017 - Brancos
	cTexto	+=	"2"      																				//	018 a 018 - 2 = CNPJ
	cTexto	+=	ExecBlock("SRETINFO",.f.,.f.,"CGC") 													//	019 a 032 - CNPJ
	cTexto	+=	StrZero(Val(Alltrim(SEE->EE_CODEMP)),06)												//	033 a 038 - Convenio
	cTexto	+=	Space(14)        																		//	039 a 052 - Brancos
	cTexto	+=	StrZero(Val(cAgencia),05)		 														//	053 a 057 - Agencia mantenedora da conta
	cTexto	+=	PadR(cDigAge,01)            															//	058 a 058 - Digito da agencia mantenedora da conta
	cTexto	+=	StrZero(Val(cConta),12)																	//	059 a 070 - Conta corrente              	
	cTexto	+=	StrZero(Val(cDigCta),01)					  											//	071 a 071 - Digito da conta                 	     
	cTexto	+=	Space(01)									  						 					//	072 a 072 - Brancos                    
	cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"NOME"),30)) 									// 	073 a 102 - Nome da Empresa
	cTexto	+=	Space(30)                                           									// 	103 a 132 - Finalidade do Lote
	cTexto	+=	Space(10)                                           									// 	133 a 142 - Complemento de Historico
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"END"),30)											// 	143 a 172 - Endereco da Empresa
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"NUM"),05)       										// 	173 a 177 - Numero da Empresa
	cTexto	+=	Space(15)                                           									// 	178 a 192 - Complemento
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"CID"),20)       										// 	193 a 212 - Cidade
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"CEP"),08)       										// 	213 a 220 - CEP
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"EST"),02)      	 									// 	221 a 222 - Estado
	cTexto	+=	'01'                                                									// 	223 a 224 - Forma Pagamento
	cTexto	+=	Space(06)                                           									// 	225 a 230 - Febraban
	cTexto	+=	Space(10)                                           									// 	231 a 240 - Ocorrencias
	cTexto	+=	CRLF

endif

if	lOnly .and. xSeg $ "B/C"	
	Return ( cTexto )
endif

/////////////////////
// Detalhe do Lote //
/////////////////////

if	lOnly .and. xSeg $ "A/B/C/D/E/F" 
	cBor	:=	Replicate("Z",TamSx3("EA_NUMBOR")[1])
elseif	lOnly 
	cTexto 	:= 	""
	xQtdArq	+=	01	
	xNumSeq	+=	01
	xLot	:=	xNumLot     
else	  
	xLot	:=	01
endif

do while SEA->(!Eof()) .and. ( SEA->EA_FILIAL + SEA->EA_NUMBOR +SEA->EA_CART ) == ( xFilial("SEA",xPesq) + cBor + "P" ) 

	if	lOnly 
		nSeq 	:= 	xNumSeq
	else        
		nSeq 	+= 	1
		if	SE2->(dbsetorder(1),dbseek( xFilial("SE2") + SEA->EA_PREFIXO + SEA->EA_NUM + SEA->EA_PARCELA + SEA->EA_TIPO + SEA->EA_FORNECE + SEA->EA_LOJA , .f. ))
			SA2->(dbsetorder(1),dbseek( xFilial("SA2") + SEA->EA_FORNECE + SEA->EA_LOJA , .f. ))
		else
			SE2->(dbsetorder(1),dbseek( xFilial("SE2",SEA->EA_FILORIG) + SEA->EA_PREFIXO + SEA->EA_NUM + SEA->EA_PARCELA + SEA->EA_TIPO + SEA->EA_FORNECE + SEA->EA_LOJA , .f. ))
			if !SA2->(dbsetorder(1),dbseek( xFilial("SA2",SEA->EA_FILORIG) + SEA->EA_FORNECE + SEA->EA_LOJA , .f. ))
				SA2->(dbsetorder(1),dbseek( xFilial("SA2") + SEA->EA_FORNECE + SEA->EA_LOJA , .f. ))
			endif		
		endif		
		if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
			PutFileInEof("SA2")							
			PutFileInEof("SE2")							
		endif		
		if	SE2->(Eof())

			PutFileInEof("SA2")							
			PutFileInEof("SE2")							

			cQuery 	:= 	" SELECT SE2.R_E_C_N_O_ AS RECNOSE2 , SA2.R_E_C_N_O_ AS RECNOSA2 "        
			cQuery 	+= 	" FROM " + RetSqlName("SE2") + " SE2 , " 
			cQuery 	+= 	           RetSqlName("SA2") + " SA2   "
			cQuery 	+= 	" WHERE "
			if	( lSA2Excl .and. lSE2Excl ) .or. ( !lSA2Excl .and. !lSE2Excl )
				cQuery	+=	"   SA2.A2_FILIAL   = SE2.E2_FILIAL                              AND "
			else
				cQuery	+=	"   SA2.A2_FILIAL   = '" + xFilial("SA2") 					+ "' AND "
			endif
			cQuery	+=		"   SA2.A2_COD      = SE2.E2_FORNECE                             AND "
			cQuery	+=		"   SA2.A2_LOJA     = SE2.E2_LOJA                                AND "
			cQuery 	+= 		"   SA2.D_E_L_E_T_  = ' '                                        AND "
			if	lSE2Excl
				cQuery	+=	"   SE2.E2_FILIAL  >= '" + Replicate(" ",FwSizeFilial())	+ "' AND "
				cQuery	+=	"   SE2.E2_FILIAL  <= '" + Replicate("Z",FwSizeFilial())	+ "' AND "
			else                                                	
				cQuery	+=	"   SE2.E2_FILIAL   = '" + xFilial("SE2") 					+ "' AND "
			endif	
			cQuery 	+= 		"   SE2.E2_PREFIXO  = '" + SEA->EA_PREFIXO	 				+ "' AND "
			cQuery 	+= 		"   SE2.E2_NUM      = '" + SEA->EA_NUM	 					+ "' AND "
			cQuery 	+= 		"   SE2.E2_PARCELA  = '" + SEA->EA_PARCELA	 				+ "' AND "
			cQuery 	+= 		"   SE2.E2_TIPO     = '" + SEA->EA_TIPO	 					+ "' AND "
			cQuery 	+= 		"   SE2.E2_FORNECE  = '" + SEA->EA_FORNECE	 				+ "' AND "
			cQuery 	+= 		"   SE2.E2_LOJA     = '" + SEA->EA_LOJA	 					+ "' AND "
			cQuery 	+= 		"   SE2.D_E_L_E_T_  = ' '                                            "
		
			TcQuery ChangeQuery(@cQuery) New Alias "QRYFOR"

			do while QRYFOR->(!Eof())
				SA2->(dbgoto(QRYFOR->RECNOSA2))			
				SE2->(dbgoto(QRYFOR->RECNOSE2))			
				QRYFOR->(dbskip())
			enddo
			QRYFOR->(dbclosearea())
		endif
		if	SE2->(Eof())
			SEA->(dbskip())
    		Loop
   		endif
	endif

	if	SE2->(FieldPos("E2_ZZVLTED")) <> 0 .and. SE2->(FieldPos("E2_ZZSQTED")) <> 0 .and. !Empty(SE2->E2_ZZSQTED) .and. SE2->E2_ZZVLTED <= 0
		SEA->(dbskip())
		Loop
	endif

	// 01 - Credito em conta corrente
	// 02 - Cheque pagamento / administrativo
	// 03 - Doc C 
	// 04 - Op a disposicao Com aviso
	// 05 - Credito em conta poupanca
	// 06 - Credito em conta corrente mesma titularidade
	// 07 - Doc D
	// 10 - Op a disposicao Sem aviso
	// 41 - TED - Outro Titular
	// 43 - TED - Mesmo Titular

	if	SEA->EA_MODELO $ "01/02/03/04/05/06/07/10/41/43" .and. !( lOnly .and. xSeg $ "5/H" )

		if	SE2->(FieldPos("E2_ZZVLTED")) <> 0 .and. SE2->(FieldPos("E2_ZZSQTED")) <> 0 .and. !Empty(SE2->E2_ZZSQTED) .and. SE2->E2_ZZVLTED > 0
    		cValor := StrZero( SE2->E2_ZZVLTED * 100 , 15 )     
		else
    		cValor := StrZero( ( SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE ) * 100 , 15 )			
		endif	

		if	SEA->EA_MODELO == "03"
			xFin	:=	"01"
		elseif	SEA->EA_MODELO == "07"
			xFin	:=	"11"
		elseif	SEA->EA_MODELO $ "41/43" .and. SA2->A2_TIPCTA == "2"
			xFin	:=	"PP"
		elseif	SEA->EA_MODELO $ "41/43"
			xFin	:=	"CC"
		else
			xFin	:=	Space(02)
		endif
		
		nQtd 	+=	1
		cTexto	+=	"237"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(xLot,04)																	// 004 a 007 - Lote de Lote     
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"A"             																	// 014 a 014 - Segmento
		cTexto	+=	iif( lExcluir , "9"  , "0"  )														// 015 a 015 - Tipo do Movimento
//		cTexto	+=	"09" 	          																	// 016 a 017 - Instrução do Movimento     
		cTexto	+=	iif( lExcluir , "99" , "00" ) 														// 016 a 017 - Instrução do Movimento     
		cTexto	+=	ExecBlock("SRETBRAD",.f.,.f.,"CAM")													// 018 a 020 - Zeros                         
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"BANCO"),03)										// 021 a 023 - Banco Favorecido              
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"AGENCIA"),05) 									// 024 a 028 - Agencia 
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"DVA"),01) 										// 029 a 029 - DV Agencia 
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"CONTA"),12) 										// 030 a 041 - Conta
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"DIG"),02) 										// 042 a 043 - DV Conta
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"NOM"),30)								   		// 044 a 073 - Nome do Favorecido      
		cTexto	+=	PadR(SE2->E2_IDCNAB,20)					  											// 074 a 093 - Numero do Documento     
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,5)							                        // 094 a 101 - Data do Pagamento       
		cTexto	+=	"BRL"                                                    							// 102 a 104 - Moeda do Pagamento       
		cTexto	+=	Replicate("0",15)                                        							// 105 a 119 - Zeros                    
		cTexto	+=	cValor																				// 120 a 134 - Valor do Pagamento 
		cTexto	+=	Space(20)        										         					// 135 a 154 - Brancos     
		cTexto	+=	Replicate("0",08)					                       							// 155 a 162 - Data Efetivacao         
		cTexto	+=	Replicate("0",15)																	// 163 a 177 - Valor Efetivado    
		cTexto	+=	Space(40) 																			// 178 a 217 - Brancos
		cTexto	+=	iif(SEA->EA_MODELO $ "03/07","07","  ")												// 218 a 219 - Finalidade DOC   
		cTexto	+=	iif(SEA->EA_MODELO $ "41/43","00005","     ")										// 220 a 224 - Finalidade TED   
		cTexto	+=	xFin																				// 225 a 226 - Finalidade Complementar
		cTexto	+=	Space(03)																			// 227 a 229 - Brancos 
		cTexto	+=	"0"      																			// 230 a 230 - Aviso ao Favorecido = 0 - Nao emite
		cTexto	+=	Space(10)																			// 231 a 240 - Ocorrencias                         
		cTexto	+=	CRLF                                                                            	

		if	SE2->(FieldPos("E2_ZZVLTED")) <> 0 .and. SE2->(FieldPos("E2_ZZSQTED")) <> 0 .and. !Empty(SE2->E2_ZZSQTED) .and. SE2->E2_ZZVLTED > 0
    		nTot 	+= SE2->E2_ZZVLTED 
    		xValTot	+= SE2->E2_ZZVLTED 
		else
    		nTot 	+= SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
    		xValTot	+= SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
		endif	

	// 11 - Pagamento a Impostos com Código de Barras
	// 12 - Pagamento a FGTS com código de Barras 
	// 13 - Pagamento a Concessionarias
	// 19 - Pagamento de IPTU 
	// 28 - GR-PR com Codigo de Barras

	elseif	SEA->EA_MODELO $ "11/12/13/19/28" .and. !( lOnly .and. xSeg $ "5/H" )

		nQtd 	+=	1
		cTexto	+=	"237"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(xLot,04)																	// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(nSeq,05)				  													// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"O"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	iif( lExcluir , "9"  , "0"  )														// 015 a 015 - Tipo do Movimento
//		cTexto	+=	"09" 	          																	// 016 a 017 - Instrução do Movimento     
		cTexto	+=	iif( lExcluir , "99" , "00" ) 														// 016 a 017 - Instrução do Movimento     
		cTexto	+=	PadR(Substr(SE2->E2_CODBAR,01,44),44)												// 018 a 061 - Codigo de Barras
		cTexto	+=	PadR(SA2->A2_NOME,30)																// 062 a 091 - Nome do Cedente                       
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,05)	             									// 092 a 099 - Vencimento        
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,05)	             									// 100 a 107 - Pagmento          
		cTexto	+=	StrZero( ( SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE ) * 100 , 15 )			// 108 a 122 - Valor             
		cTexto	+=	PadR(SE2->E2_IDCNAB,20)                            									// 123 a 142 - Identificador 
		cTexto	+=	Space(20)                                          									// 143 a 162 - Brancos             
		cTexto	+=	Space(68)                                          									// 163 a 230 - Brancos             
		cTexto	+=	Space(10)                                          									// 231 a 240 - Ocorrencias
		cTexto	+=	CRLF	                                                                        	

		nTot 	+= 	SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
		xValTot	+= 	SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE

	// 30 - Liquidacao de titulos em cobranca no Bradesco
	// 31 - Pagamento de titulos em outros bancos

	elseif	SEA->EA_MODELO $ "30/31" .and. !( lOnly .and. xSeg $ "5/H" )

		cVctBol	:=	ExecBlock("SRETBRAD",.f.,.f.,"VCTBOL") 
		cVctBol	:=	StoD(Substr(cVctBol,05,04) + Substr(cVctBol,03,02) + Substr(cVctBol,01,02))
//		cVctBol	:=	Max(cVctBol,SE2->E2_VENCREA)
		cVctBol	:=	GravaData(cVctBol,.f.,5)

		nQtd 	+=	1
		cTexto	+=	"237"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(xLot,04)																	// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"J"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	iif( lExcluir , "9"  , "0"  )														// 015 a 015 - Tipo do Movimento
//		cTexto	+=	"09" 	          																	// 016 a 017 - Instrução do Movimento     
		cTexto	+=	iif( lExcluir , "99" , "00" ) 														// 016 a 017 - Instrução do Movimento     
		cTexto	+=	PadR( Substr( SE2->E2_CODBAR , 01 , 44 ) , 44 )										// 018 a 061 - Codigo de Barras
		cTexto	+=	PadR( SA2->A2_NOME , 30 )															// 062 a 091 - Nome do Cedente                       
		cTexto	+=	cVctBol								             									// 092 a 099 - Vencimento        

		cTexto	+=	U_xValCNAB(SE2->E2_CODBAR,1)														// 100 a 114 - Valor             
		cTexto	+=	U_xValCNAB(SE2->E2_CODBAR,2)														// 115 a 129 - Desconto          
		cTexto	+=	U_xValCNAB(SE2->E2_CODBAR,3)														// 130 a 144 - Multa e Mora      
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,5)                   									// 145 a 152 - Data de Pagamento 
		cTexto	+=	U_xValCNAB(SE2->E2_CODBAR,4)														// 153 a 167 - Valor do Pagamento

		/*
		cTexto	+=	StrZero( ( SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE ) * 100 , 15 )			// 100 a 114 - Valor             
		cTexto	+=	StrZero( 0 , 15 )																	// 115 a 129 - Desconto          
		cTexto	+=	StrZero( 0 , 15 )																	// 130 a 144 - Multa e Mora      
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,5)                   									// 145 a 152 - Data de Pagamento 
		cTexto	+=	StrZero( ( SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE ) * 100 , 15 )			// 153 a 167 - Valor do Pagamento
		*/
		
		cTexto	+=	Replicate("0",15)                                  									// 168 a 182 - Quantidade da Moeda
		cTexto	+=	PadR(SE2->E2_IDCNAB,20)                            									// 183 a 202 - Identificador       
		cTexto	+=	Space(20)                                          									// 203 a 222 - Brancos
		cTexto	+=	'09'                                               									// 223 a 224 - Moeda
		cTexto	+=	Space(06)                                          									// 225 a 230 - Exclusivo FEBRABAN  
		cTexto	+=	Space(10)                                          									// 231 a 240 - Ocorrencias
		cTexto	+=	CRLF	                                                                        	

		nTot 	+= 	SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
		xValTot	+= 	SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE

	// 16 - Pagamento de Tributos DARF
	// 17 - Pagamento de Tributos GPS   
	// 18 - Pagamento de Tributos DARF SIMPLES
	// 21 - Pagamento de Tributos DARJ
	// 22 - Pagamento de Tributos GARE ICMS SP
	// 25 - Pagamento de Tributos IPVA (SP e MG)
	// 27 - Pagamento de Tributos DPVAT
	// 29 - GR-PR sem Codigo de Barras
	// 35 - Pagamento de Tributos FGTS - GFIP 
	
	elseif	SEA->EA_MODELO $ "16/17/18/21/22/25/27/29/35" .and. !( lOnly .and. xSeg $ "5/H" )

		nValPri	:=	xValPri
		nValMul	:=	xValMul
		nValJur	:=	xValJur

		nQtd 	+=	1
		cTexto	+=	"237"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(xLot,04)																	// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"N"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	iif( lExcluir , "9"  , "0"  )														// 015 a 015 - Tipo do Movimento
//		cTexto	+=	"09" 	          																	// 016 a 017 - Instrução do Movimento     
		cTexto	+=	iif( lExcluir , "99" , "00" ) 														// 016 a 017 - Instrução do Movimento     
		cTexto	+=	PadR(SE2->E2_IDCNAB,20)                            									// 018 a 037 - Identificador       
		cTexto	+=	Space(20)                                          									// 038 a 057 - Brancos
		cTexto	+=	Upper(Substr(ExecBlock("SRETINFO",.f.,.f.,"NOME"),1,30))					   		// 058 a 087 - Contribuinte    
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,05)	             									// 088 a 095 - Pagamento 
		cTexto	+=	StrZero((SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE)*100),15)							// 096 a 110 - Valor 
		cTexto	+=	ExecBlock("SRETBRAD",.f.,.f.,"TRIB")               									// 111 a 230 - Dados do Tributo
		cTexto	+=	Space(10)                                          									// 231 a 240 - Ocorrencias
		cTexto	+=	CRLF	                                                                        	

		nValPri	:=	xValPri - nValPri
		nValMul	:=	xValMul - nValMul
		nValJur	:=	xValJur - nValJur

		nTot 	+= 	nValPri + nValMul + nValJur
		xValTot	+= 	nValPri + nValMul + nValJur

	endif

	if	lOnly .and. xSeg $ "5/H" 
		cTexto	:=	""
		nSeq 	-= 	01
	elseif	lOnly 
		Exit
	endif

	// 01 - Credito em conta corrente
	// 02 - Cheque pagamento / administrativo
	// 03 - Doc C 
	// 04 - Op a disposicao Com aviso
	// 05 - Credito em conta poupanca
	// 06 - Credito em conta corrente mesma titularidade
	// 07 - Doc D
	// 10 - Op a disposicao Sem aviso
	// 41 - TED - Outro Titular
	// 43 - TED - Mesmo Titular

	if	SEA->EA_MODELO $ "01/02/03/04/05/06/07/10/41/43"  

		nSeq 	+= 	1
		nQtd 	+=	1
		cTexto	+=	"237"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(xLot,04)																	// 004 a 007 - Lote de Lote     
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"B"             																	// 014 a 014 - Segmento
		cTexto	+=	Space(03)       																	// 015 a 017 - Brancos
		cTexto	+=	ExecBlock("SRETBRAD",.f.,.f.,"TIP")													// 018 a 018 - Tipo da Inscrição
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"CGC"),14)										// 019 a 032 - Inscrição
		cTexto	+=	PadR(Substr(ExecBlock("SRETBRAD",.f.,.f.,"END"),01,30),30)							// 033 a 062 - Endereço
		cTexto	+=	StrZero(Val(ExecBlock("SRETINFO",.f.,.f.,"NUM")),05) 								// 063 a 067 - Numero da Empresa
		cTexto	+=	Space(15)                                    										// 068 a 082 - Brancos
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"BAIRRO"),15)       								// 083 a 097 - Bairro
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"CIDADE"),20)       								// 098 a 117 - Cidade
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"CEP"),08) 	      								// 118 a 125 - CEP   
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"ESTADO"),02) 	      							// 126 a 127 - Estado
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,5)							                        // 128 a 135 - Vencimento              
		cTexto	+=	Replicate("0",15)																	// 136 a 150 - Valor              
		cTexto	+=	Replicate("0",15)																	// 151 a 165 - Abatimento         
		cTexto	+=	Replicate("0",15)																	// 166 a 180 - Desconto           
		cTexto	+=	Replicate("0",15)																	// 181 a 195 - Mora               
		cTexto	+=	Replicate("0",15)																	// 196 a 210 - Multa              
		cTexto	+=	Space(15)                                    										// 211 a 225 - Brancos
		cTexto	+=	"0"      																			// 226 a 226 - Aviso ao Favorecido = 0 - Nao emite
		cTexto	+=	Space(06)                                    										// 227 a 232 - Brancos
		cTexto	+=	Space(08)                                    										// 233 a 240 - Brancos
		cTexto	+=	CRLF                                                                            	

	// 30 - Liquidacao de titulos em cobranca no Bradesco
	// 31 - Pagamento de titulos em outros bancos

	elseif	SEA->EA_MODELO $ "30/31"  

		xCNPJ	:=	iif( SE2->(FieldPos("E2_ZZCNPJ")) <> 0 .and. !Empty(SE2->E2_ZZCNPJ) , SE2->E2_ZZCNPJ , SA2->A2_CGC )
		
		nSeq 	+= 	1
		nQtd 	+=	1
		cTexto	+=	"237"							 													// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(xLot,04)																	// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"J"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	" "             																	// 015 a 015 - Exclusivo Febraban
		cTexto	+=	"00"            																	// 016 a 017 - Codigo do Movimento                   
   		cTexto	+=	"52"            															   		// 018 a 019 - Identificacao do Registro Opcional
		cTexto	+=	"2" 																				// 020 a 020 - Tipo de Inscricao do Sacado
		cTexto	+=	StrZero(Val(ExecBlock("SRETINFO",.f.,.f.,"CGC")),15)								// 021 a 035 - CNPJ do Sacado
		cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"NOME"),40)) 								// 036 a 075 - Nome do Sacado 
		cTexto	+=	ExecBlock("SRETBRAD",.f.,.f.,"TIP")													// 076 a 076 - Tipo de Inscricao do Cedente
		cTexto	+=	StrZero(Val(xCNPJ),15)						  										// 077 a 091 - CNPJ do Cedente
		cTexto	+=	PadR(Substr(ExecBlock("SRETBRAD",.f.,.f.,"NOM2"),01,40),40)							// 092 a 131 - Nome do Cedente
		cTexto	+=	'0'                                               									// 132 a 132 - Tipo de Inscricao do Sacador
		cTexto	+=	Replicate("0",15)      																// 133 a 147 - CNPJ do Sacador
		cTexto	+=	Space(40)                                   										// 148 a 187 - Nome do Sacador
		cTexto	+=	Space(53)                                          									// 188 a 240 - Exclusivo FEBRABAN  
		cTexto	+=	CRLF	                                                                       	

	endif
	
	if	lOnly 
		Exit
	endif

	SEA->(dbskip())
enddo

SEA->(dbgotop())
if !SEA->(dbseek( xFilial("SEA",xPesq) + cBor + "P" , .f. ))
	SEA->(dbseek( xFilial("SEA") + cBor + "P" , .f. ))
endif

if	lOnly .and. !( xSeg $ "A/B/C/D/E/F" )
	Return ( cTexto )
else
	cBor	:=	xBor
endif

//////////////////////
// Trailler do Lote //
//////////////////////

if	nRecnoSEA <> 0
	SEA->(dbgoto(nRecnoSEA))
endif

if	lOnly .and. xSeg $ "D/E" 
	cTexto 	:= 	""
	xQtdArq	+=	01	
	xLot	:=	xNumLot     
	nSeq 	:= 	xNumSeq     
	nTot	:=	xValTot	
	xTot	:=	xValTot	
else	  
	xLot	:=	01
	xTot	:=	( xValPri + xValMul + xValJur )	
endif

// 01 - Credito em conta corrente
// 02 - Cheque pagamento / administrativo
// 03 - Doc C 
// 04 - Op a disposicao Com aviso
// 05 - Credito em conta poupanca
// 06 - Credito em conta corrente mesma titularidade
// 07 - Doc D
// 10 - Op a disposicao Sem aviso
// 11 - Pagamento a Impostos com Código de Barras
// 12 - Pagamento a FGTS com código de Barras 
// 13 - Pagamento a Concessionarias
// 19 - Pagamento de IPTU 
// 28 - GR-PR com Codigo de Barras
// 30 - Liquidacao de titulos em cobranca no Bradesco
// 31 - Pagamento de titulos em outros bancos
// 41 - TED - Outro Titular
// 43 - TED - Mesmo Titular

if	SEA->EA_MODELO $ "01/02/03/04/05/06/07/10/11/12/13/19/28/30/31/41/43"  

	nQtd 	+=	1     
	cTexto	+=	"237"																					// 001 a 003 - Codigo do Banco
	cTexto	+=	StrZero(xLot,04)																		// 004 a 007 - Lote de Servico
	cTexto	+=	"5"                																		// 008 a 008 - Tipo de Registro
	cTexto	+=	Space(09)       																		// 009 a 017 - Brancos
	cTexto	+=	StrZero(nSeq + 002,06)																	// 018 a 023 - Quantidade de registros
	cTexto	+=	StrZero(nTot * 100,18)																	// 024 a 041 - Valor Total do Lote
	cTexto	+=	StrZero(0,18)																			// 042 a 059 - Somatorio Quantidade Moeda
	cTexto	+=	StrZero(0,06)																			// 060 a 065 - Aviso de Debito           
	cTexto	+=	Space(165)																				// 066 a 230 - Brancos
	cTexto	+=	Space(010)                 																// 231 a 240 - Ocorrencias para Retorno
	cTexto	+=	CRLF             

// 16 - Pagamento de Tributos DARF
// 17 - Pagamento de Tributos GPS
// 18 - Pagamento de Tributos DARF SIMPLES
// 21 - Pagamento de Tributos DARJ
// 22 - Pagamento de Tributos GARE ICMS SP
// 25 - Pagamento de Tributos IPVA (SP e MG)
// 27 - Pagamento de Tributos DPVAT
// 29 - GR-PR sem Codigo de Barras
// 35 - Pagamento de Tributos FGTS - GFIP 

elseif	SEA->EA_MODELO $ "16/17/18/21/22/25/27/29/35"

	nQtd 	+=	1     
	cTexto	+=	"237"																					// 001 a 003 - Codigo do Banco
	cTexto	+=	StrZero(xLot,04)																		// 004 a 007 - Lote de Servico
	cTexto	+=	"5"                																		// 008 a 008 - Tipo de Registro
	cTexto	+=	Space(09)       																		// 009 a 017 - Brancos
	cTexto	+=	StrZero(nSeq + 002,06)																	// 018 a 023 - Quantidade de registros
	cTexto	+=	StrZero(xTot * 100,18)																	// 024 a 041 - Valor Total do Lote
	cTexto	+=	StrZero(0,18)																			// 042 a 059 - Zeros                     
	cTexto	+=	StrZero(0,06)																			// 060 a 065 - Zeros                     
	cTexto	+=	Space(165)																				// 066 a 230 - Brancos
	cTexto	+=	Space(010)                 																// 231 a 240 - Ocorrencias para Retorno
	cTexto	+=	CRLF

endif

if	lOnly .and. xSeg $ "D/E" 
	xNumSeq	:=	0     
	Return ( cTexto )
endif

/////////////////////////
// Trailler do Arquivo //
/////////////////////////

if	lOnly .and. xSeg == "F"
	cTexto 	:= 	""
	nQtd	:=	xQtdArq	
	xLot	:=	xNumLot     
endif

nQtd 	+=	1
cTexto	+=	"237"																						//	001 a 003 - Codigo do Banco
cTexto	+=	"9999"             																			//  004 a 007 - Lote de Servico
cTexto	+=	"9"                   																		//	008 a 008 - Tipo de Registro
cTexto	+=	Space(09)          																			//	009 a 017 - Brancos
cTexto	+=	StrZero(xLot,06)																			//  018 a 023 - Quantidade de lotes do arquivo
cTexto	+=	StrZero(nQtd,06)																			//  024 a 029 - Quantidade de registros do arquivo
cTexto	+=	StrZero(0,6)      																			//  030 a 035 - Zeros
cTexto	+=	Space(205)      																			//  036 a 240 - Brancos
cTexto	+=	CRLF

if	lOnly .and. xSeg == "F"
	Return ( cTexto )
endif

/////////////////////////
// Gravação do Arquivo //
/////////////////////////

if	MemoWrit( xArquivo , cTexto ) 
	if	lAlert
		if	lIsBlind
			ConOut("Arquivo gerado com sucesso !!!")   
		else
			Alert("Arquivo gerado com sucesso !!!")   
		endif
	else
		if	lIsBlind
			ConOut("Arquivo gerado com sucesso !!!")   
		endif
	endif
	RecLock("SEE",.f.)
		SEE->EE_FAXATU	:=	cSeqArq
	MsUnlock("SEE")   
	lRet	:=	.t.
else               
	lRet	:=	.f.
	if	lAlert
		if	lIsBlind
			ConOut("Arquivo NAO gerado. Verifique !!!")
		else
			Alert("Arquivo NÃO gerado. Verifique !!!")
		endif
	else
		if	lIsBlind
			ConOut("Arquivo NAO gerado. Verifique !!!")
		endif
	endif
endif

if	lIsBlind
	ConOut("")
endif

Return ( iif( lRet , {0,xArquivo} , {2,""} ) ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³xGera237 BºAutor  ³Alexandre Zapponi   º Data ³  01/01/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o arquivo CNAB do Bradesco para a rotina xPrepPag      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function fGera237()     				 	

Local xArea := 	SaveArea1({"SA2","SE2","SEA","SEE"})

Local xSeg	:=	ParamIxb   
Local aPar	:=	{ SEA->EA_PORTADO , SEA->EA_AGEDEP , SEA->EA_NUMCON , "" , SEA->EA_NUMBOR }
Local cRet	:=	U_xGera237( aPar , "" , .f. , "" , SEE->EE_SUBCTA , .t. , xSeg )     				 	
                                                            
RestArea1(xArea)		             

Return ( cRet )
