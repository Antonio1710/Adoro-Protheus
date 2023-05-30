#include 'topconn.ch'     	 	            		         		         		
#include 'protheus.ch'     	 	            		         		         		
     	
#define MB_OK                 00      			   		
#define MB_OKCANCEL           01
#define MB_YESNO              04           		
#define MB_ICONHAND           16
#define MB_ICONQUESTION       32
#define MB_ICONEXCLAMATION    48
#define MB_ICONASTERISK       64

/*/{Protheus.doc} User Function xGera341
	Gera o CNAB do Itau para a rotina xPrepPag
	@type  Function
	@author Alexandre Zapponi
	@since 01/01/18
	@history Ticket TI      - Abel Babini - 12/04/2023 - Ajustes para trazer o CNPJ do beneficiário no pagamento de títulos
	/*/

User Function xGera341(aPar,cDir,lAlert,xDir,cSub,lBxa)   	    		
              	                                       	
Local lRet           
Local xBco
Local xAgC
Local nQtd			:=	0
Local nTot			:=	0
Local nSeq			:=	0
Local cBco			:=	aPar[01]
Local cAge			:=	aPar[02]
Local cCon			:=	aPar[03]
Local cBor			:=	aPar[05]  
Local xCNPJ			:=	""
Local xAlias		:=	""	 
Local cQuery		:=	""	 
Local cTexto		:=	""	 
Local cValor		:=	""
Local cConta		:=	""
Local cDigCta		:=	""
Local cSeqArq		:=	""    
Local cVctBol		:=	""
Local xArquivo		:=	""

Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U"

Default cSub		:=	""
Default xDir		:=	""
Default lBxa		:=	.f.
Default lAlert		:=	.t.

Private xValPri		:=	0
Private xValMul		:=	0
Private xValJur		:=	0
Private xValAcF		:=	0
Private xValHoA		:=	0
Private xValEnt		:=	0

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

SEA->(dbsetorder(2))
SEA->(dbgotop())  
if	SEA->(dbseek( xFilial("SEA") + cBor + "P" , .f. ))
	if	lIsBlind
		ConOut("Bordero encontrado para geracao de CNAB") 	
	endif
else
	if	lIsBlind
		ConOut("Bordero NÃO encontrado para geracao de CNAB") 	
	else
		MessageBox("Borderô NÃO encontrado para geração de CNAB","Atenção",MB_ICONHAND) 	
	endif
	Return 	
endif	   

SA6->(dbsetorder(1))
SA6->(dbgotop())  
if	SA6->(dbseek( xFilial("SA6") + cBco + cAge + cCon , .f. ))
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
if	SEE->(dbseek( xFilial("SEE") + cBco + cAge + cCon + cSub , .f. ))
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

cSeqArq		:=	StrZero(Val(SEE->EE_FAXATU) + 1,06) 
xArquivo	:=	iif( Empty(xDir) , cDir + Right(cFilAnt,02) + cBor + "." + SEE->EE_EXTEN , xDir )

// GravaData Formato 	1 := ddmmaa 												  
//         				2 := mmddaa 												  
//         				3 := aaddmm 												  
//         				4 := aammdd 												  
//         				5 := ddmmaaaa												  
//         				6 := mmddaaaa												  
//         				7 := aaaaddmm												  
//         				8 := aaaammdd		

/*ÀÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ
³ A - Header Arquivo                                                      ³
³ B - Header Lote 1   ÄÄ´ Header Lote Cheque/OP/DOC/Cred.CC               ³
³ C - Header Lote 2   ÄÄ´ Header Lote Cob Ita£/Outros Bancos              ³
³ D - Trailer Lote 1  ÄÄ´ Trailler Lote Cheque/OP/DOC/Cred.CC             ³
³ E - Trailer Lote 2  ÄÄ´ Trailler Lote Cob Ita£/Outros Bancos            ³
³ F - Trailer Arquivo   ³                                                 ³
³ G - Segmento A  ÄÄÄÄÄÄ´ Cheque/OP/DOC/Cred.CC                           ³
³ H - Segmento B        ³  ""          ""                                 ³
³ I - Segmento L  ÄÄÄÄÄÄ´ Cob Ita£/Outros Bancos                          ³
ÀÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ*/

///////////////////////
// Header do Arquivo //  
///////////////////////

if	"-" $ SA6->A6_NUMCON	
	cConta	:=	Alltrim(StrTran(Alltrim(SA6->A6_NUMCON),"-",""))
	cDigCta	:=	Substr(cConta,Len(cConta),01)
	cConta	:=	Substr(cConta,01,Len(cConta) - 1)
else
	cConta	:=	Alltrim(StrTran(SA6->A6_NUMCON + SA6->A6_DVCTA," ",""))
	cDigCta	:=	Substr(cConta,Len(cConta),01)
	cConta	:=	Substr(cConta,01,Len(cConta) - 1)
endif

nQtd 	+=	1
cTexto	+=	"341"																						//	001 a 003 - Codigo do banco           
cTexto	+=	"0000"																						//	004 a 007 - Lote de Servico           
cTexto	+=	"0"    																						//	008 a 008 - Tipo de Registro          
cTexto	+=	Space(06)																					//	009 a 014 - Brancos                   
cTexto	+=	"080"     																					//	015 a 017 - Layout de Arquivos        
cTexto	+=	"2"       																					//	018 a 018 - Tipo de inscricao da empresa ( 1 = CPF / 2 = CNPJ )
cTexto	+=	ExecBlock("SRETINFO",.f.,.f.,"CGC")															//	019 a 032 - CNPJ da empresa
cTexto	+=	Space(20)       																			//	033 a 052 - Brancos        
cTexto	+=	StrZero(Val(SA6->A6_AGENCIA),05)															//	053 a 057 - Agencia mantenedora da conta
cTexto	+=	Space(01)                																	//	058 a 058 - Digito da agencia mantenedora da conta
cTexto	+=	StrZero(Val(cConta),12)					  													//	059 a 070 - Conta corrente              
cTexto	+=	Space(01)	          							  											//	071 a 071 - Brancos                    
cTexto	+=	StrZero(Val(cDigCta),01)						  						 					//	072 a 072 - Digito da conta                      
cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"NOME"),30))								   		// 	073 a 102 - Nome da Empresa
cTexto	+=	PadR("BANCO ITAU SA",030)    					       										// 	103 a 132 - Nome do Banco    
cTexto	+=	Space(10)                    					       										// 	133 a 142 - Brancos          
cTexto	+=	"1"                          					       										// 	143 a 143 - 1 = Remessa      
cTexto	+=	GravaData(Date(),.f.,5)							       										// 	144 a 151 - Data da Geracao  
cTexto	+=	StrTran(Time(),':','')							       										// 	152 a 157 - Hora da Geracao  
cTexto	+=	Replicate("0",09)           					       										// 	158 a 166 - Zeros            
cTexto	+=	Replicate("0",05)           					       										// 	167 a 171 - Densidade de Gravacao
cTexto	+=	Space(69)                   					       										// 	172 a 240 - Brancos              
cTexto	+=	CRLF

////////////////////
// Header do Lote //
////////////////////

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
// 45 - PIX - Transferência

if	SEA->EA_MODELO $ "01/02/03/04/05/06/07/10/41/43/45"  
	
	nQtd 	+=	1
	cTexto	+=	"341"																					//	001 a 003 - Codigo do banco
	cTexto	+=	StrZero(01,04)																			//	004 a 007 - Lote de Servico
	cTexto	+=	"1"    																					//	008 a 008 - Tipo de Registro
	cTexto	+=	"C"    																					//	009 a 009 - C = Credito
	cTexto	+=	SEA->EA_TIPOPAG																			//	010 a 011 - 20 = Pagamento a fornecedores
	cTexto	+=	SEA->EA_MODELO																			//	012 a 013 - Forma de lancamento
	cTexto	+=	'040'  																					//	014 a 016 - Versao do lote
	cTexto	+=	Space(01)																				//	017 a 017 - Brancos
	cTexto	+=	"2"      																				//	018 a 018 - 2 = CNPJ
	cTexto	+=	ExecBlock("SRETINFO",.f.,.f.,"CGC")								      					//	019 a 032 - CNPJ
	cTexto	+=	Space(04)        																		//	033 a 036 - Identificacao do Lancamento
	cTexto	+=	Space(16)        																		//	037 a 052 - Brancos
	cTexto	+=	StrZero(Val(SA6->A6_AGENCIA),05)														//	053 a 057 - Agencia mantenedora da conta
	cTexto	+=	Space(01)                																//	058 a 058 - Digito da agencia mantenedora da conta
	cTexto	+=	StrZero(Val(cConta),12)			   				  										//	059 a 070 - Conta corrente
	cTexto	+=	Space(01)              							  										//	071 a 071 - Complemento de Registro
	cTexto	+=	StrZero(Val(cDigCta),01)						  										//	072 a 072 - Digito da conta
	cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"NOME"),30))   									// 	073 a 102 - Nome da Empresa
	cTexto	+=	Space(30)                                           									// 	103 a 132 - Finalidade do Lote
	cTexto	+=	Space(10)                                           									// 	133 a 142 - Complemento de Historico
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"END"),30)											// 	143 a 172 - Endereco da Empresa
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"NUM"),05)       										// 	173 a 177 - Numero da Empresa
	cTexto	+=	Space(15)                                           									// 	178 a 192 - Complemento
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"CID"),20)	   										// 	193 a 212 - Cidade
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"CEP"),08)   	   										// 	213 a 220 - CEP
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"EST"),02)       										// 	221 a 222 - Estado
	cTexto	+=	Space(08)                                           									// 	223 a 230 - Brancos
	cTexto	+=	Space(10)                                           									// 	231 a 240 - Ocorrencias
	cTexto	+=	CRLF

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
// 30 - Liquidacao de titulos em cobranca no Itau
// 31 - Pagamento de titulos em outros bancos
// 35 - Pagamento de Tributos FGTS - GFIP 

elseif	SEA->EA_MODELO $ "13/16/17/18/19/21/22/25/27/28/29/30/31/35"
	
	nQtd 	+=	1
	cTexto	+=	"341"																					//	001 a 003 - Codigo do banco
	cTexto	+=	StrZero(01,04)																			//	004 a 007 - Lote de Servico
	cTexto	+=	"1"    																					//	008 a 008 - Tipo de Registro
	cTexto	+=	"C"    																					//	009 a 009 - C = Credito
	cTexto	+=	ExecBlock("SRETTRIB",.f.,.f.,"TIPO")													//	010 a 011 - Tipo do Pagamento
	cTexto	+=	ExecBlock("SRETTRIB",.f.,.f.,"MOD")														//	012 a 013 - Forma de lancamento
	cTexto	+=	'030'  																					//	014 a 016 - Versao do lote
	cTexto	+=	Space(01)																				//	017 a 017 - Brancos
	cTexto	+=	"2"      																				//	018 a 018 - 2 = CNPJ
	cTexto	+=	ExecBlock("SRETINFO",.f.,.f.,"CGC") 													//	019 a 032 - CNPJ
	cTexto	+=	Space(20)        																		//	033 a 052 - Brancos
	cTexto	+=	StrZero(Val(SA6->A6_AGENCIA),05)														//	053 a 057 - Agencia mantenedora da conta
	cTexto	+=	Space(01)                																//	058 a 058 - Digito da agencia mantenedora da conta
	cTexto	+=	StrZero(Val(cConta),12)					  												//	059 a 070 - Conta corrente
	cTexto	+=	Space(01)              							  										//	071 a 071 - Complemento de Registro
	cTexto	+=	StrZero(Val(cDigCta),01)				  			  									//	072 a 072 - Digito da conta
	cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"NOME"),30)) 									// 	073 a 102 - Nome da Empresa
	cTexto	+=	Space(30)                                           									// 	103 a 132 - Finalidade do Lote
	cTexto	+=	Space(10)                                           									// 	133 a 142 - Complemento de Historico
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"END"),30)											// 	143 a 172 - Endereco da Empresa
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"NUM"),05)       										// 	173 a 177 - Numero da Empresa
	cTexto	+=	Space(15)                                           									// 	178 a 192 - Complemento
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"CID"),20)       										// 	193 a 212 - Cidade
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"CEP"),08)       										// 	213 a 220 - CEP
	cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"EST"),02)      	 									// 	221 a 222 - Estado
	cTexto	+=	Space(08)                                           									// 	223 a 230 - Brancos
	cTexto	+=	Space(10)                                           									// 	231 a 240 - Ocorrencias
	cTexto	+=	CRLF

endif

/////////////////////
// Detalhe do Lote //
/////////////////////

do while SEA->(!Eof()) .and. ( SEA->EA_FILIAL + SEA->EA_NUMBOR +SEA->EA_CART ) == ( xFilial("SEA") + cBor + "P" ) 

	SA2->(dbsetorder(1),dbseek( xFilial("SA2") + SEA->EA_FORNECE + SEA->EA_LOJA , .f. ))
	SE2->(dbsetorder(1),dbseek( xFilial("SE2") + SEA->EA_PREFIXO + SEA->EA_NUM + SEA->EA_PARCELA + SEA->EA_TIPO + SEA->EA_FORNECE + SEA->EA_LOJA , .f. ))

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
	// 45 - PIX - Transferência

	if	SEA->EA_MODELO $ "01/02/03/04/05/06/07/10/41/43/45"        
	
		if	SE2->(FieldPos("E2_ZZVLTED")) <> 0 .and. SE2->(FieldPos("E2_ZZSQTED")) <> 0 .and. !Empty(SE2->E2_ZZSQTED) .and. SE2->E2_ZZVLTED > 0
    		cValor := StrZero( SE2->E2_ZZVLTED * 100 , 15 )     
		else
    		cValor := StrZero( ( SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE ) * 100 , 15 )			
		endif	
	
		xBco	:=	iif( SEA->EA_MODELO == "45" , Space(03) , PadR(Alltrim(SA2->A2_BANCO),03) 					)
		xAgC	:=	iif( SEA->EA_MODELO == "45" , Space(20) , Padr( ExecBlock("SRETITAU",.f.,.f.,"AGC") , 20 ) 	)

		nQtd 	+=	1
		cTexto	+=	"341"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Lote     
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"A"             																	// 014 a 014 - Segmento
		cTexto	+=	iif( lBxa , "999" , "000" )															// 015 a 017 - 000 - Inclusao de Pagamento - 999 - Baixa
		cTexto	+=	iif( SEA->EA_MODELO == "45" , "009" , "000" )										// 018 a 020 - Zeros                         
		cTexto	+=	xBco							 													// 021 a 023 - Banco Favorecido              
		cTexto	+=	xAgC											 									// 024 a 043 - Agencia e Conta do Favorecido
		cTexto	+=	PadR( ExecBlock("SRETITAU",.f.,.f.,"NOM") , 30 )							   		// 044 a 073 - Nome do Favorecido      
		cTexto	+=	PadR( SE2->E2_IDCNAB , 20 )				  											// 074 a 093 - Numero do Documento     
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,5)							                        // 094 a 101 - Data do Pagamento       
		cTexto	+=	"REA"                                                    							// 102 a 104 - Moeda do Pagamento       
		cTexto	+=	Replicate("0",08)                                        							// 105 a 112 - Código ISPB
		cTexto	+=	iif( SEA->EA_MODELO == "45" , "04" , "00" )                							// 113 a 114 - Identificação da Transferência    
		cTexto	+=	Replicate("0",05)                                        							// 115 a 119 - Zeros    
		cTexto	+=	cValor																				// 120 a 134 - Valor do Pagamento 
		cTexto	+=	Space(15)        										         					// 135 a 149 - Nosso Numero
		cTexto	+=	Space(05)          										         					// 150 a 154 - Brancos     
		cTexto	+=	Replicate("0",08)					                       							// 155 a 162 - Data Efetivacao         
		cTexto	+=	Replicate("0",15)																	// 163 a 177 - Valor Efetivado    
		cTexto	+=	Space(18) 																			// 178 a 195 - Historico do Lancamento
		cTexto	+=	Space(02)                              												// 196 a 197 - Brancos                 
		cTexto	+=	Replicate("0",06)       							     							// 198 a 203 - Numero do movimento
		cTexto	+=	StrZero( Val(Alltrim(ExecBlock("SRETITAU",.f.,.f.,"CGC2"))) , 14 )					// 204 a 217 - CPF / CNPJ
		cTexto	+=	iif( SEA->EA_MODELO == "03" , "01"    , Space(02) )									// 218 a 219 - Finalidade DOC   
		cTexto	+=	iif( SEA->EA_MODELO == "41" , "00010" , Space(05) )									// 220 a 224 - Finalidade TED   
		cTexto	+=	Space(05)																			// 225 a 229 - Brancos          
		cTexto	+=	"0"      																			// 230 a 230 - Aviso ao Favorecido = 0 - Nao emite
		cTexto	+=	Space(10)																			// 231 a 240 - Ocorrencias                         
		cTexto	+=	CRLF                                                                            	

		if	SE2->(FieldPos("E2_ZZVLTED")) <> 0 .and. SE2->(FieldPos("E2_ZZSQTED")) <> 0 .and. !Empty(SE2->E2_ZZSQTED) .and. SE2->E2_ZZVLTED > 0
    		nTot += iif( lBxa , 0 , SE2->E2_ZZVLTED )
		else
    		nTot += iif( lBxa , 0 , SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE )
		endif	

	// 13 - Pagamento a Concessionarias
	// 19 - Pagamento de IPTU 
	// 28 - GR-PR com Codigo de Barras

	elseif	SEA->EA_MODELO $ "13/19/28"  

		nQtd 	+=	1
		cTexto	+=	"341"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)				  													// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"O"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	iif( lBxa , "999" , "000" )															// 015 a 017 - 000 - Inclusao de Pagamento - 999 - Baixa
		cTexto	+=	PadR( SE2->E2_CODBAR , 48 )															// 018 a 065 - Codigo de Barras
		cTexto	+=	PadR( ExecBlock("SRETITAU",.f.,.f.,"NOMTRIB") , 30 )								// 066 a 095 - Nome do Cedente                       
		cTexto	+=	ExecBlock("SRETTRIB",.f.,.f.,"VENCTO")             									// 096 a 103 - Vencimento        
		cTexto	+=	"REA"                                           									// 104 a 106 - Moeda             
		cTexto	+=	Replicate("0",15)                               									// 107 a 121 - Quantidade de Moeda             
		cTexto	+=	StrZero( ( SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE ) * 100 , 15 )			// 122 a 136 - Valor             
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,5)                   									// 137 a 144 - Data de Pagamento 
		cTexto	+=	Replicate("0",15)                               									// 145 a 159 - Valor Pago
		cTexto	+=	Space(15)                                          									// 160 a 174 - Brancos
		cTexto	+=	PadR(SE2->E2_IDCNAB,20)                            									// 175 a 194 - Identificador 
		cTexto	+=	Space(21)                                          									// 195 a 215 - Brancos             
		cTexto	+=	Space(15)                                          									// 216 a 230 - Brancos             
		cTexto	+=	Space(10)                                          									// 231 a 240 - Ocorrencias
		cTexto	+=	CRLF	                                                                        	

		nTot 	+= 	iif( lBxa , 0 , SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE )

	// 30 - Liquidacao de titulos em cobranca no Itau
	// 31 - Pagamento de titulos em outros bancos

	elseif	SEA->EA_MODELO $ "30/31"  

		cVctBol	:=	ExecBlock("SRETITAU",.f.,.f.,"VCTBOL") 
		cVctBol	:=	StoD(Substr(cVctBol,05,04) + Substr(cVctBol,03,02) + Substr(cVctBol,01,02))
		cVctBol	:=	Max(cVctBol,SE2->E2_VENCREA)
		cVctBol	:=	GravaData(cVctBol,.f.,5)
						
		nQtd 	+=	1
		cTexto	+=	"341"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"J"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	iif( lBxa , "999" , "000" )															// 015 a 017 - 000 - Inclusao de Pagamento - 999 - Baixa
		cTexto	+=	PadR( Substr( SE2->E2_CODBAR , 01 , 44 ) , 44 )										// 018 a 061 - Codigo de Barras
		cTexto	+=	PadR( SA2->A2_NOME , 30 )															// 062 a 091 - Nome do Cedente                       
		cTexto	+=	cVctBol								             									// 092 a 099 - Vencimento        
		cTexto	+=	StrZero((SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE) * 100,15)				// 100 a 114 - Valor             
		cTexto	+=	StrZero( 0 , 15 )																	// 115 a 129 - Desconto          
		cTexto	+=	StrZero( 0 , 15 )																	// 130 a 144 - Multa e Mora      
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,5)                   									// 145 a 152 - Data de Pagamento 
		cTexto	+=	StrZero((SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE) * 100,15)				// 153 a 167 - Valor do Pagamento
		cTexto	+=	Replicate("0",15)                                  									// 168 a 182 - Quantidade da Moeda
		cTexto	+=	PadR(SE2->E2_IDCNAB,20)                            									// 183 a 202 - Identificador       
		cTexto	+=	Space(13)                                          									// 203 a 215 - Numero do Banco     
		cTexto	+=	Space(15)                                          									// 216 a 230 - Exclusivo FEBRABAN  
		cTexto	+=	Space(10)                                          									// 231 a 240 - Ocorrencias
		cTexto	+=	CRLF	                                                                        	

		nTot 	+= 	iif( lBxa , 0 , SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE )
		//Ticket TI      - Abel Babini - 12/04/2023 - Ajustes para trazer o CNPJ do beneficiário no pagamento de títulos
		// xCNPJ	:=	iif( SE2->(FieldPos("E2_ZZCNPJ")) <> 0 .and. !Empty(SE2->E2_ZZCNPJ) , SE2->E2_ZZCNPJ , SA2->A2_CGC )
		xCNPJ	:=	iif( SA2->(FieldPos("A2_ZZCGC")) <> 0 .and. !Empty(SA2->A2_ZZCGC) , SA2->A2_ZZCGC , SA2->A2_CGC )

		nQtd 	+=	1
		cTexto	+=	"341"							 													// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"J"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	iif( lBxa , "999" , "000" )															// 015 a 017 - 000 - Inclusao de Pagamento - 999 - Baixa
   		cTexto	+=	"52"            															   		// 018 a 019 - Identificacao do Registro Opcional
		cTexto	+=	"2" 																				// 020 a 020 - Tipo de Inscricao do Sacado
		cTexto	+=	StrZero(Val(ExecBlock("SRETINFO",.f.,.f.,"CGC")),15)								// 021 a 035 - CNPJ do Sacado
		cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"NOME"),40)) 								// 036 a 075 - Nome do Sacado 
		cTexto	+=	iif(Alltrim(SA2->A2_TIPO)=="J",'2','1')												// 076 a 076 - Tipo de Inscricao do Cedente
		cTexto	+=	StrZero(Val(xCNPJ),15) 						 										// 077 a 091 - CNPJ do Cedente
		cTexto	+=	PadR(Substr(SA2->A2_NOME,1,40),40)		  											// 092 a 131 - Nome do Cedente
		cTexto	+=	'0'                                               									// 132 a 132 - Tipo de Inscricao do Sacador
		cTexto	+=	Replicate("0",15)      																// 133 a 147 - CNPJ do Sacador
		cTexto	+=	Space(40)                                   										// 148 a 187 - Nome do Sacador
		cTexto	+=	Space(53)                                          									// 188 a 240 - Exclusivo FEBRABAN  
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
		cTexto	+=	"341"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"N"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	iif( lBxa , "999" , "000" )															// 015 a 017 - 000 - Inclusao de Pagamento - 999 - Baixa
		cTexto	+=	ExecBlock("SRETITAU",.f.,.f.,"")											   		// 018 a 195 - Dados do Imposto
		cTexto	+=	PadR(SE2->E2_IDCNAB,20)                            									// 196 a 215 - Identificador       
		cTexto	+=	Space(15)                                          									// 216 a 230 - Exclusivo FEBRABAN  
		cTexto	+=	Space(10)                                          									// 231 a 240 - Ocorrencias
		cTexto	+=	CRLF	                                                                        	

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
		cTexto	+=	"341"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Lote     
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"B"             																	// 014 a 014 - Segmento
		cTexto	+=	Space(3)           																	// 015 a 017 - Espaços
		cTexto	+=	ExecBlock("SRETITAU",.f.,.f.,"TIP")													// 018 a 018 - Tipo de Inscrição             
		cTexto	+=	ExecBlock("SRETITAU",.f.,.f.,"CGC")													// 019 a 032 - Numero da Inscrição           
		cTexto	+=	PadR(Alltrim(ExecBlock("SRETITAU",.f.,.f.,"END")),30)								// 033 a 062 - Endereço                      
		cTexto	+=	StrZero(Val(ExecBlock("SRETITAU",.f.,.f.,"NUM")),05)								// 063 a 067 - Numero do Endereço           
		cTexto	+=	Space(15)                                       									// 068 a 082 - Espaços                 
		cTexto	+=	PadR(SA2->A2_BAIRRO,15)					  											// 083 a 097 - Bairro 
		cTexto	+=	PadR(SA2->A2_MUN,20)					  											// 098 a 117 - Municipio
		cTexto	+=	PadR(SA2->A2_MUN,08)					  											// 118 a 125 - CEP     
		cTexto	+=	PadR(SA2->A2_EST,02)					  											// 126 a 127 - Estado  
		cTexto	+=	Space(08)																			// 128 a 135 - Vencimento                          
		cTexto	+=	Space(15)																			// 136 a 150 - Valor do Documento                  
		cTexto	+=	Space(15)																			// 151 a 165 - Abatimento                          
		cTexto	+=	Space(15)																			// 166 a 180 - Desconto                            
		cTexto	+=	Space(15)																			// 181 a 195 - Mora                                
		cTexto	+=	Space(15)																			// 196 a 210 - Multa                               
		cTexto	+=	Space(15)																			// 211 a 225 - Doc Favorecido                      
		cTexto	+=	Space(01)																			// 226 a 226 - Aviso ao Favorecido                 
		cTexto	+=	Space(06)																			// 227 a 232 - Exclusivo SIAPE
		cTexto	+=	Space(08)																			// 233 a 240 - Codigo ISPB
		cTexto	+=	CRLF                                                                            	

	// 45 - PIX - Transferência

	elseif	SEA->EA_MODELO $ "45"  

		xAlias	:=	Alias()

		cQuery	:=	" Select * "
		cQuery	+=	" From " + RetSqlName("F72")
		cQuery	+=	" Where F72_FILIAL  = '" + SA2->A2_FILIAL				+ "' and " 
		cQuery	+=		"   F72_COD     = '" + SA2->A2_COD					+ "' and " 
		cQuery	+=		"   F72_LOJA    = '" + SA2->A2_LOJA					+ "' and " 
		cQuery	+=		"   F72_TPCHV  <> '" + CriaVar("F72_TPCHV",.f.)		+ "' and " 
		cQuery	+=		"   F72_CHVPIX <> '" + CriaVar("F72_CHVPIX",.f.)	+ "' and " 
		cQuery	+=		"   D_E_L_E_T_  = ' '                                        "
		cQuery	+=	" Order By F72_ACTIVE                                            " 
		
		TcQuery ChangeQuery(@cQuery) New Alias "XF72"

		nQtd 	+=	1
		cTexto	+=	"341"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Lote     
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"B"             																	// 014 a 014 - Segmento
		cTexto	+=	PadR(XF72->F72_TPCHV,02)															// 015 a 016 - Tipo Chave
		cTexto	+=	Space(01)          																	// 017 a 017 - Espaços
		cTexto	+=	ExecBlock("SRETITAU",.f.,.f.,"TIP")													// 018 a 018 - Tipo de Inscrição             
		cTexto	+=	ExecBlock("SRETITAU",.f.,.f.,"CGC")													// 019 a 032 - Numero da Inscrição           
		cTexto	+=	Space(30)                                              								// 033 a 062 - TXID                      
		cTexto	+=	PadR("PAGAMENTO NF " + Alltrim(SE2->E2_NUM),65)        								// 063 a 127 - Informações Entre Usuários                      
		cTexto	+= 	PadR(Alltrim(XF72->F72_CHVPIX),100)                    								// 128 a 227 - Chave Pix
		cTexto	+=	Space(03)																			// 228 a 230 - Brancos
		cTexto	+=	Space(10)																			// 231 a 240 - Ocorrências
		cTexto	+=	CRLF                                                                            	

		XF72->(dbclosearea())

		dbselectarea(xAlias)

	// 35 - Pagamento de Tributos FGTS - GFIP 

	elseif	SEA->EA_MODELO $ "35" 

		nQtd 	+=	1
		cTexto	+=	"341"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Lote     
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"B"             																	// 014 a 014 - Segmento
		cTexto	+=	Space(18)          																	// 015 a 032 - Brancos
		cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"END"),30)) 								// 033 a 062 - Endereço da Empresa
		cTexto	+=	StrZero(Val(ExecBlock("SRETINFO",.f.,.f.,"NUM")),05) 								// 063 a 067 - Numero da Empresa
		cTexto	+=	Space(15)																			// 068 a 082 - Complemento
		cTexto	+=	Space(15)																			// 083 a 097 - Bairro     
		cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"CID"),20)       									// 098 a 117 - Cidade
		cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"CEP"),08)       									// 118 a 125 - CEP
		cTexto	+=	PadR(ExecBlock("SRETINFO",.f.,.f.,"EST"),02)      	 								// 126 a 127 - Estado
		cTexto	+=	Space(11)																			// 128 a 138 - Telefone
		cTexto	+=	Replicate("0",14)      					       										// 139 a 152 - Acrescimos       
		cTexto	+=	Replicate("0",14)      					       										// 153 a 166 - Honorarios       
		cTexto	+=	Space(74)																			// 167 a 240 - Brancos  
		cTexto	+=	CRLF                                                                            	

	// 22 - Pagamento de Tributos GARE ICMS SP

	elseif	SEA->EA_MODELO == "22" .and. ( SE2->E2_ZZVLAF + SE2->E2_ZZVLHA ) <> 0 

		nQtd 	+=	1
		cTexto	+=	"341"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Lote     
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"B"             																	// 014 a 014 - Segmento
		cTexto	+=	Space(18)          																	// 015 a 032 - Brancos
		cTexto	+=	ExecBlock("SRETITAU",.f.,.f.,"22EXT")										   		// 033 a 166 - Dados do Imposto
		cTexto	+=	Space(74)																			// 167 a 240 - Codigo ISPB
		cTexto	+=	CRLF                                                                            	

	endif

	SEA->(dbskip())
enddo

SEA->(dbgotop())

SEA->(dbseek( xFilial("SEA") + cBor + "P" , .f. ))

//////////////////////
// Trailler do Lote //
//////////////////////

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
// 45 - PIX - Transferência

if	SEA->EA_MODELO $ "01/02/03/04/05/06/07/10/41/43/45"  

	nQtd 	+=	1     
	cTexto	+=	"341"																					// 001 a 003 - Codigo do Banco
	cTexto	+=	StrZero(01,04)																			// 004 a 007 - Lote de Servico
	cTexto	+=	"5"                																		// 008 a 008 - Tipo de Registro
	cTexto	+=	Space(09)       																		// 009 a 017 - Brancos
	cTexto	+=	StrZero(nSeq + 002,06)																	// 018 a 023 - Quantidade de registros
	cTexto	+=	StrZero(nTot * 100,18)																	// 024 a 041 - Valor Total do Lote
	cTexto	+=	StrZero(0,18)																			// 042 a 059 - Somatorio Quantidade Moeda
	cTexto	+=	Space(171)																				// 060 a 230 - Brancos
	cTexto	+=	Space(010)                 																// 231 a 240 - Ocorrencias para Retorno
	cTexto	+=	CRLF

// 13 - Pagamento a Concessionarias
// 19 - Pagamento de IPTU 
// 28 - GR-PR com Codigo de Barras

elseif	SEA->EA_MODELO $ "13/19/28"  

	nQtd 	+=	1     
	cTexto	+=	"341"																					// 001 a 003 - Codigo do Banco
	cTexto	+=	StrZero(01,04)																			// 004 a 007 - Lote de Servico
	cTexto	+=	"5"                																		// 008 a 008 - Tipo de Registro
	cTexto	+=	Space(09)       																		// 009 a 017 - Brancos
	cTexto	+=	StrZero(nSeq + 002,06)																	// 018 a 023 - Quantidade de registros
	cTexto	+=	StrZero(nTot * 100,18)																	// 024 a 041 - Valor Total do Lote
	cTexto	+=	StrZero(0,18)																			// 042 a 059 - Somatorio Quantidade Moeda
	cTexto	+=	Space(171)																				// 060 a 230 - Brancos
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
	cTexto	+=	"341"																					// 001 a 003 - Codigo do Banco
	cTexto	+=	StrZero(01,04)																			// 004 a 007 - Lote de Servico
	cTexto	+=	"5"                																		// 008 a 008 - Tipo de Registro
	cTexto	+=	Space(009)       																		// 009 a 017 - Brancos
	cTexto	+=	StrZero( nSeq    + 002 , 06 )															// 018 a 023 - Quantidade de registros
	cTexto	+=	StrZero( xValPri * 100 , 14 )															// 024 a 037 - Valor Total do Lote
	cTexto	+=	StrZero( xValEnt * 100 , 14 )															// 038 a 051 - Outras Entidades da GPS                  
	cTexto	+=	StrZero( ( xValMul + xValJur + xValAcF + xValHoA           ) * 100 , 14 )				// 052 a 065 - Somatorio de Multa e Juros 
	cTexto	+=	StrZero( ( xValMul + xValJur + xValAcF + xValHoA + xValPri + xValEnt ) * 100 , 14 )		// 066 a 079 - Somatorio de Pagamento do Lote
	cTexto	+=	Space(151)																				// 080 a 230 - Brancos
	cTexto	+=	Space(010)                 																// 231 a 240 - Ocorrencias para Retorno
	cTexto	+=	CRLF

// 30 - Liquidacao de titulos em cobranca no Itau
// 31 - Pagamento de titulos em outros bancos

elseif	SEA->EA_MODELO $ "30/31"  

	nQtd 	+=	1     
	cTexto	+=	"341"																					// 001 a 003 - Codigo do Banco
	cTexto	+=	StrZero(01,04)												 							// 004 a 007 - Lote de Servico
	cTexto	+=	"5"                																		// 008 a 008 - Tipo de Registro
	cTexto	+=	Space(09)       																		// 009 a 017 - Brancos
	cTexto	+=	StrZero(nSeq + 002,06)																	// 018 a 023 - Quantidade de registros
	cTexto	+=	StrZero(nTot * 100,18)																	// 024 a 041 - Valor Total do Lote
	cTexto	+=	StrZero(0,18)																			// 042 a 059 - Somatorio Quantidade Moeda
	cTexto	+=	Space(171)																				// 060 a 230 - Brancos
	cTexto	+=	Space(010)                 																// 231 a 240 - Ocorrencias para Retorno
	cTexto	+=	CRLF

endif

/////////////////////////
// Trailler do Arquivo //
/////////////////////////

nQtd 	+=	1
cTexto	+=	"341"																						//	001 a 003 - Codigo do Banco
cTexto	+=	"9999"             																			//  004 a 007 - Lote de Servico
cTexto	+=	"9"                   																		//	008 a 008 - Tipo de Registro
cTexto	+=	Space(09)          																			//	009 a 017 - Brancos
cTexto	+=	StrZero(01,06)																				//  018 a 023 - Quantidade de lotes do arquivo
cTexto	+=	StrZero(nQtd,06)																			//  024 a 029 - Quantidade de registros do arquivo
cTexto	+=	Space(211)      																			//  030 a 240 - Brancos
cTexto	+=	CRLF

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
