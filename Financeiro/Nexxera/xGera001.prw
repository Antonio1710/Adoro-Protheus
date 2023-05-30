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
±±ºPrograma  ³xGera001  ºAutor  ³Alexandre Zapponi   º Data ³  01/01/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Gera o CNAB do Banco do Brasil para a rotina xPrepPag       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function xGera001(aPar,cDir,lAlert)        	

Local lRet
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
Local cSub			:=	""
Local cTexto		:=	""	
Local cConta		:=	""
Local cAgencia		:=	""
Local cDigAge		:=	""
Local cDigCta		:=	""
Local cSeqArq		:=	""
Local cModelo		:=	""
Local xArquivo		:=	""   

Default lAlert		:=	.t.

Private xValPri		:=	0
Private xValMul		:=	0
Private xValJur		:=	0

SEA->(dbsetorder(2))
SEA->(dbgotop())  
if !SEA->(dbseek( xFilial("SEA") + cBor + "P" , .f. ))
	MessageBox("Borderô não encontrado para geração de CNAB","Atenção",MB_ICONHAND) 	
	Return 	
endif	   

SA6->(dbsetorder(1))
SA6->(dbgotop())  
if !SA6->(dbseek( xFilial("SA6") + cBco + cAge + cCon , .f. ))
	MessageBox("Banco referente ao borderô não encontrado para geração de CNAB","Atenção",MB_ICONHAND) 	
	Return 	
endif	   

cSub := iif( SA6->(FieldPos('A6_ZZSUBP')) <> 0 .and. !Empty(SA6->A6_ZZSUBP) , SA6->A6_ZZSUBP , '000' )

SEE->(dbsetorder(1))
SEE->(dbgotop())  
if !SEE->(dbseek( xFilial("SEE") + cBco + cAge + cCon + cSub , .f. ))
	MessageBox("Subconta do Banco referente ao borderô não encontrado para geração de CNAB","Atenção",MB_ICONHAND) 	
	Return 	
endif	   

cSeqArq		:=	StrZero(Val(SEE->EE_FAXATU) + 1,06) 
xArquivo	:=	cDir + cFilAnt + cBor + "." + SEE->EE_EXTEN      

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

// MOVIMENTOS TRATADOS PELO BB
// 01 - Credito em conta corrente
// 02 - Cheque pagamento / administrativo
// 03 - Doc C 
// 04 - Op a disposicao Com aviso
// 05 - Credito em conta poupanca
// 06 - Credito em conta corrente mesma titularidade
// 07 - Doc D
// 10 - Op a disposicao Sem aviso
// 11 - Pagamento a Concessionarias (Fora Itaú)
// 13 - Pagamento a Concessionarias (Banco Itaú)
// 16 - Pagamento de Tributos DARF
// 17 - Pagamento de Tributos GPS
// 18 - Pagamento de Tributos DARF SIMPLES
// 21 - Pagamento de Tributos DARJ
// 22 - Pagamento de Tributos GARE ICMS SP
// 23 - Pagamento de Tributos GARE ICMS DR						///////////////////////////////////// FALTANDO 001
// 24 - Pagamento de Tributos GARE ICMS ITCMD					///////////////////////////////////// FALTANDO 001 
// 25 - Pagamento de Tributos IPVA (SP e MG)
// 26 - Pagamento de Tributos Licenciamento
// 27 - Pagamento de Tributos DPVAT
// 30 - Liquidacao de titulos em cobranca no BB
// 31 - Pagamento de titulos em outros bancos
// 41 - TED - Outro Titular
// 43 - TED - Mesmo Titular

///////////////////////
// Header do Arquivo //  
///////////////////////

nQtd 	+=	1
cTexto	+=	"001"																						//	001 a 003 - Codigo do banco           
cTexto	+=	"0000"																						//	004 a 007 - Lote de Servico           
cTexto	+=	"0"    																						//	008 a 008 - Tipo de Registro          
cTexto	+=	Space(09)																					//	009 a 017 - Brancos                   
cTexto	+=	"2"       																					//	018 a 018 - Tipo de inscricao da empresa ( 1 = CPF / 2 = CNPJ )
cTexto	+=	ExecBlock("SRETINFO",.f.,.f.,"CGC")															//	019 a 032 - CNPJ da empresa
cTexto	+=	StrZero(Val(Alltrim(SEE->EE_CODEMP)),09)													//	033 a 041 - Convenio       
cTexto	+=	"0126"          																			//	042 a 045 - Fixo           
cTexto	+=	Space(07)       																			//	046 a 052 - Brancos        
cTexto	+=	StrZero(Val(cAgencia),05)			 														//	053 a 057 - Agencia mantenedora da conta
cTexto	+=	PadR(cDigAge,01)              																//	058 a 058 - Digito da agencia mantenedora da conta
cTexto	+=	StrZero(Val(cConta),12)					  													//	059 a 070 - Conta corrente              
cTexto	+=	StrZero(Val(cDigCta),01)						  											//	071 a 071 - Digito da conta                      
cTexto	+=	Space(01)										  						 					//	072 a 072 - Brancos                    
cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"NOME"),30))								   		// 	073 a 102 - Nome da Empresa
cTexto	+=	PadR("BANCO DO BRASIL",30)    					       										// 	103 a 132 - Nome do Banco    
cTexto	+=	Space(10)                    					       										// 	133 a 142 - Brancos          
cTexto	+=	"1"                          					       										// 	143 a 143 - 1 = Remessa      
cTexto	+=	GravaData(Date(),.f.,5)							       										// 	144 a 151 - Data da Geracao  
cTexto	+=	StrTran(Time(),':','')							       										// 	152 a 157 - Hora da Geracao  
cTexto	+=	StrZero(Val(Alltrim(SEA->EA_NUMBOR)),06)			   										// 	158 a 163 - NSA
cTexto	+=	'084'                       					       										// 	164 a 166 - Versão           
cTexto	+=	"01600"                     					       										// 	167 a 171 - Densidade de Gravacao
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

if	SEA->EA_MODELO $ "01/02/03/04/05/06/07/10/41/43"  
	
	nQtd 	+=	1
	cTexto	+=	"001"																					//	001 a 003 - Codigo do banco
	cTexto	+=	StrZero(01,04)																			//	004 a 007 - Lote de Servico
	cTexto	+=	"1"    																					//	008 a 008 - Tipo de Registro
	cTexto	+=	"C"    																					//	009 a 009 - C = Credito
	cTexto	+=	"20"           																			//	010 a 011 - 20 = Pagamento a fornecedores
	cTexto	+=	iif( SEA->EA_MODELO == "13" , "11" , SEA->EA_MODELO )									//	012 a 013 - Forma de lancamento
	cTexto	+=	"045"																					//	014 a 016 - Versao do lote
	cTexto	+=	Space(01)																				//	017 a 017 - Brancos
	cTexto	+=	"2"      																				//	018 a 018 - 2 = CNPJ
	cTexto	+=	ExecBlock("SRETINFO",.f.,.f.,"CGC")								      					//	019 a 032 - CNPJ
	cTexto	+=	StrZero(Val(Alltrim(SEE->EE_CODEMP)),09)												//	033 a 041 - Convenio
	cTexto	+=	"0126"           																		//	042 a 045 - Fixo    
	cTexto	+=	Space(07)        																		//	046 a 052 - Brancos
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
	cTexto	+=	"00"                                                									// 	223 a 224 - Febraban
	cTexto	+=	Space(06)                                           									// 	225 a 230 - Febraban
	cTexto	+=	Space(10)                                           									// 	231 a 240 - Ocorrencias
	cTexto	+=	CRLF  
	
// 11 - Pagamento a Concessionarias (Fora Itaú)
// 13 - Pagamento a Concessionarias (Banco Itaú)
// 16 - Pagamento de Tributos DARF
// 17 - Pagamento de Tributos GPS
// 18 - Pagamento de Tributos DARF SIMPLES
// 21 - Pagamento de Tributos DARJ
// 22 - Pagamento de Tributos GARE ICMS SP
// 23 - Pagamento de Tributos GARE ICMS DR						///////////////////////////////////// FALTANDO 001
// 24 - Pagamento de Tributos GARE ICMS ITCMD					///////////////////////////////////// FALTANDO 001 
// 25 - Pagamento de Tributos IPVA (SP e MG)
// 26 - Pagamento de Tributos Licenciamento
// 27 - Pagamento de Tributos DPVAT
// 30 - Liquidacao de titulos em cobranca no BB
// 31 - Pagamento de titulos em outros bancos

elseif	SEA->EA_MODELO $ "11/13/16/17/18/21/22/23/24/25/26/27/30/31"
	
	nQtd 	+=	1
	cTexto	+=	"001"																					//	001 a 003 - Codigo do banco
	cTexto	+=	StrZero(01,04)																			//	004 a 007 - Lote de Servico
	cTexto	+=	"1"    																					//	008 a 008 - Tipo de Registro
	cTexto	+=	"C"    																					//	009 a 009 - C = Credito
	cTexto	+=	"98"                                													//	010 a 011 - Tipo do Pagamento		98 - Pagamentos Diversos
	cTexto	+=	iif( SEA->EA_MODELO == "13" , "11" , SEA->EA_MODELO )									//	012 a 013 - Forma de lancamento
	cTexto	+=	iif( SEA->EA_MODELO $ "30/31" , "040" , "012" )											//	014 a 016 - Versao do lote
	cTexto	+=	Space(01)																				//	017 a 017 - Brancos
	cTexto	+=	"2"      																				//	018 a 018 - 2 = CNPJ
	cTexto	+=	ExecBlock("SRETINFO",.f.,.f.,"CGC") 													//	019 a 032 - CNPJ
	cTexto	+=	StrZero(Val(Alltrim(SEE->EE_CODEMP)),09)												//	033 a 041 - Convenio
	cTexto	+=	"0126"           																		//	042 a 045 - Fixo    
	cTexto	+=	Space(07)        																		//	046 a 052 - Brancos
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
	cTexto	+=	Space(08)                                           									// 	223 a 230 - Febraban
	cTexto	+=	Space(10)                                           									// 	231 a 240 - Ocorrencias
	cTexto	+=	CRLF

endif

/////////////////////
// Detalhe do Lote //
/////////////////////

do while SEA->(!Eof()) .and. ( SEA->EA_FILIAL + SEA->EA_NUMBOR +SEA->EA_CART ) == ( xFilial("SEA") + cBor + "P" ) 

	SA2->(dbsetorder(1),dbseek( xFilial("SA2") + SEA->EA_FORNECE + SEA->EA_LOJA , .f. ))
	SE2->(dbsetorder(1),dbseek( xFilial("SE2") + SEA->EA_PREFIXO + SEA->EA_NUM + SEA->EA_PARCELA + SEA->EA_TIPO + SEA->EA_FORNECE + SEA->EA_LOJA , .f. ))

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

	if	SEA->EA_MODELO $ "01*06" 		// Transferencia entre contas BB
		cModelo	:=	"000"
	elseif	SEA->EA_MODELO $ "03*07" 	// Transferencia por DOC        
		cModelo	:=	"700"
	else
		cModelo	:=	"018"
	endif
	
	if	SEA->EA_MODELO $ "01/02/03/04/05/06/07/10/41/43"  

		nQtd 	+=	1
		cTexto	+=	"001"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Lote     
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"A"             																	// 014 a 014 - Segmento
		cTexto	+=	"0"             																	// 015 a 015 - Tipo do Movimento
		cTexto	+=	"09" 	          																	// 016 a 017 - Instrução do Movimento  00 - Liberado / 09 - Bloqueado    
		cTexto	+=	cModelo																				// 018 a 020 - Zeros                         
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"BANCO"),03)										// 021 a 023 - Banco Favorecido              
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"AGENCIA"),05) 									// 024 a 028 - Agencia 
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"DVA"),01) 										// 029 a 029 - DV Agencia 
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"CONTA"),12) 										// 030 a 041 - Conta
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"DIG"),02) 										// 042 a 043 - DV Conta
		cTexto	+=	PadR(ExecBlock("SRETBRAD",.f.,.f.,"NOM"),30)								   		// 044 a 073 - Nome do Favorecido      
		cTexto	+=	PadR(SE2->E2_IDCNAB,20)					  											// 074 a 093 - Numero do Documento     
		cTexto	+=	GravaData(Max(SE2->E2_VENCREA,Date()),.f.,5)				                        // 094 a 101 - Data do Pagamento       
		cTexto	+=	"BRL"                                                    							// 102 a 104 - Moeda do Pagamento       
		cTexto	+=	Replicate("0",15)                                        							// 105 a 119 - Zeros                    
		cTexto	+=	StrZero( ( SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE ) * 100 , 15 )			// 120 a 134 - Valor do Pagamento 
		cTexto	+=	Space(20)        										         					// 135 a 154 - Brancos     
		cTexto	+=	Replicate("0",08)					                       							// 155 a 162 - Data Efetivacao         
		cTexto	+=	Replicate("0",15)																	// 163 a 177 - Valor Efetivado    
		cTexto	+=	Space(40) 																			// 178 a 217 - Brancos
		cTexto	+=	iif(SEA->EA_MODELO $ "03/07","07","00")												// 218 a 219 - Finalidade DOC   
		cTexto	+=	iif(SEA->EA_MODELO $ "41/43","00000","00000")										// 220 a 224 - Finalidade TED   
		cTexto	+=	Space(05)																			// 225 a 229 - Brancos 
		cTexto	+=	"0"      																			// 230 a 230 - Aviso ao Favorecido = 0 - Nao emite
		cTexto	+=	Space(10)																			// 231 a 240 - Ocorrencias                         
		cTexto	+=	CRLF                                                                            	

		nTot 	+= 	SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE

	// 11 - Pagamento a Concessionarias (Fora Itaú)
	// 13 - Pagamento a Concessionarias (Banco Itaú)

	elseif	SEA->EA_MODELO $ "11/13"  

		nQtd 	+=	1
		cTexto	+=	"001"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)				  													// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"O"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	"0"		           																	// 015 a 015 - Tipo do Movimento                     
		cTexto	+=	"09"    		   																	// 016 a 017 - Codigo do Movimento                     
		cTexto	+=	PadR(Substr(E2->E2_CODBAR,01,44),44)												// 018 a 061 - Codigo de Barras
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

	// 30 - Liquidacao de titulos em cobranca no Itau
	// 31 - Pagamento de titulos em outros bancos

	elseif	SEA->EA_MODELO $ "30/31"  

		nQtd 	+=	1
		cTexto	+=	"001"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"J"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	"0"               																	// 015 a 015 - Tipo do Movimento                     
		cTexto	+=	"09"             																	// 016 a 017 - Codigo da Instrução 00 - Liberado / 09 - Bloqueado
		cTexto	+=	PadR( Substr( SE2->E2_CODBAR , 01 , 44 ) , 44 )										// 018 a 061 - Codigo de Barras
		cTexto	+=	PadR( SA2->A2_NOME , 30 )															// 062 a 091 - Nome do Cedente                       
		cTexto	+=	ExecBlock("SRETBRAD",.f.,.f.,"VCTBOL")             									// 092 a 099 - Vencimento        
		cTexto	+=	StrZero( SE2->E2_SALDO   * 100 , 15 )												// 100 a 114 - Valor             
		cTexto	+=	StrZero( SE2->E2_SDDECRE * 100 , 15 )												// 115 a 129 - Desconto          
		cTexto	+=	StrZero( SE2->E2_SDDECRE * 100 , 15 )												// 130 a 144 - Multa e Mora      
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,5)                   									// 145 a 152 - Data de Pagamento 
		cTexto	+=	StrZero( ( SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE ) * 100 , 15 )			// 153 a 167 - Valor do Pagamento
		cTexto	+=	Replicate("0",15)                                  									// 168 a 182 - Quantidade da Moeda
		cTexto	+=	PadR(SE2->E2_IDCNAB,20)                            									// 183 a 202 - Identificador       
		cTexto	+=	Space(20)                                          									// 203 a 222 - Brancos
		cTexto	+=	'09'                                               									// 223 a 224 - Moeda
		cTexto	+=	Space(06)                                          									// 225 a 230 - Exclusivo FEBRABAN  
		cTexto	+=	Space(10)                                          									// 231 a 240 - Ocorrencias
		cTexto	+=	CRLF	                                                                        	

		nTot 	+= 	SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE

		nQtd 	+=	1
		cTexto	+=	"001"							 													// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"J"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	" "             																	// 015 a 015 - Codigo do Movimento                   
		cTexto	+=	"01"            																	// 016 a 017 - Codigo do Movimento                   
   		cTexto	+=	"52"            															   		// 018 a 019 - Identificacao do Registro Opcional
		cTexto	+=	"2" 																				// 020 a 020 - Tipo de Inscricao do Sacado
		cTexto	+=	StrZero(Val(ExecBlock("SRETINFO",.f.,.f.,"CGC")),15)								// 021 a 035 - CNPJ do Sacado
		cTexto	+=	Upper(PadR(ExecBlock("SRETINFO",.f.,.f.,"NOME"),40)) 								// 036 a 075 - Nome do Sacado 
		cTexto	+=	ExecBlock("SRETBRAD",.f.,.f.,"TIP")													// 076 a 076 - Tipo de Inscricao do Cedente
		cTexto	+=	StrZero(Val(ExecBlock("SRETBRAD",.f.,.f.,"CGC")),15)								// 077 a 091 - CNPJ do Cedente
		cTexto	+=	PadR(Substr(ExecBlock("SRETBRAD",.f.,.f.,"NOM2"),01,40),40)							// 092 a 131 - Nome do Cedente
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
	// 23 - Pagamento de Tributos GARE ICMS DR						///////////////////////////////////// FALTANDO 001
	// 24 - Pagamento de Tributos GARE ICMS ITCMD					///////////////////////////////////// FALTANDO 001 
	// 25 - Pagamento de Tributos IPVA (SP e MG)
	// 26 - Pagamento de Licenciamento
	// 27 - Pagamento de Tributos DPVAT  
	
	elseif	SEA->EA_MODELO $ "16/17/18/21/22/23/24/25/26/27"

		nValPri	:=	xValPri
		nValMul	:=	xValMul
		nValJur	:=	xValJur

		nQtd 	+=	1
		cTexto	+=	"001"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Servico  
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
		cTexto	+=	"N"             																	// 014 a 014 - Codigo Segmento do Registro Detalhe   
		cTexto	+=	"0"               																	// 015 a 015 - Tipo do Movimento                     
		cTexto	+=	"09"             																	// 016 a 017 - Codigo da Instrução 00 - Liberado / 09 - Bloqueado
		cTexto	+=	PadR(SE2->E2_IDCNAB,20)                            									// 018 a 037 - Identificador       
		cTexto	+=	Space(20)                                          									// 038 a 057 - Brancos
		cTexto	+=	Upper(Substr(ExecBlock("SRETINFO",.f.,.f.,"NOME"),1,30))					   		// 058 a 087 - Contribuinte    
		cTexto	+=	GravaData(SE2->E2_VENCREA,.f.,05)	             									// 088 a 095 - Pagamento 
		cTexto	+=	StrZero((SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE)*100),15)								// 096 a 110 - Valor 
		cTexto	+=	ExecBlock("SRETBRAD",.f.,.f.,"TRIB")               									// 111 a 230 - Dados do Tributo
		cTexto	+=	Space(10)                                          									// 231 a 240 - Ocorrencias
		cTexto	+=	CRLF	                                                                        	

		nValPri	:=	xValPri - nValPri
		nValMul	:=	xValMul - nValMul
		nValJur	:=	xValJur - nValJur

		nTot 	+= 	nValPri + nValMul + nValJur

	endif

	// 03 - Doc C 
	// 04 - Op a disposicao Com aviso
	// 07 - Doc D
	// 41 - TED - Outro Titular
	// 43 - TED - Mesmo Titular

	if	SEA->EA_MODELO $ "03/04/07/41/43"  

		nQtd 	+=	1
		cTexto	+=	"001"																				// 001 a 003 - Codigo do Banco
		cTexto	+=	StrZero(01,04)																		// 004 a 007 - Lote de Lote     
		cTexto	+=	"3"                																	// 008 a 008 - Tipo de Registro 
		cTexto	+=	StrZero(++ nSeq,05)																	// 009 a 013 - Numero sequencial do registro no lote
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
// 11 - Pagamento a Concessionarias (Fora Itaú)
// 13 - Pagamento a Concessionarias (Banco Itaú)
// 30 - Liquidacao de titulos em cobranca no mesmo banco
// 31 - Pagamento de titulos em outros bancos
// 41 - TED - Outro Titular
// 43 - TED - Mesmo Titular

if	SEA->EA_MODELO $ "01/02/03/04/05/06/07/10/11/13/30/31/41/43"  

	nQtd 	+=	1     
	cTexto	+=	"001"																					// 001 a 003 - Codigo do Banco
	cTexto	+=	StrZero(01,04)																			// 004 a 007 - Lote de Servico
	cTexto	+=	"5"                																		// 008 a 008 - Tipo de Registro
	cTexto	+=	Space(09)       																		// 009 a 017 - Brancos
	cTexto	+=	StrZero(nSeq + 2,06)																	// 018 a 023 - Quantidade de registros
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
// 23 - Pagamento de Tributos GARE ICMS DR						///////////////////////////////////// FALTANDO 001
// 24 - Pagamento de Tributos GARE ICMS ITCMD					///////////////////////////////////// FALTANDO 001 
// 25 - Pagamento de Tributos IPVA (SP e MG)
// 26 - Pagamento de Licenciamento
// 27 - Pagamento de Tributos DPVAT

elseif	SEA->EA_MODELO $ "16/17/18/21/22/23/24/25/26/27"

	nQtd 	+=	1     
	cTexto	+=	"001"																					// 001 a 003 - Codigo do Banco
	cTexto	+=	StrZero(01,04)																			// 004 a 007 - Lote de Servico
	cTexto	+=	"5"                																		// 008 a 008 - Tipo de Registro
	cTexto	+=	Space(09)       																		// 009 a 017 - Brancos
	cTexto	+=	StrZero(nSeq + 2,06)																	// 018 a 023 - Quantidade de registros
	cTexto	+=	StrZero((xValPri + xValMul + xValJur) * 100,18)											// 024 a 041 - Valor Total do Lote
	cTexto	+=	StrZero(0,18)																			// 042 a 059 - Zeros                     
	cTexto	+=	StrZero(0,06)																			// 060 a 065 - Zeros                     
	cTexto	+=	Space(165)																				// 066 a 230 - Brancos
	cTexto	+=	Space(010)                 																// 231 a 240 - Ocorrencias para Retorno
	cTexto	+=	CRLF

endif

/////////////////////////
// Trailler do Arquivo //
/////////////////////////

nQtd 	+=	1
cTexto	+=	"001"																						//	001 a 003 - Codigo do Banco
cTexto	+=	"9999"             																			//  004 a 007 - Lote de Servico
cTexto	+=	"9"                   																		//	008 a 008 - Tipo de Registro
cTexto	+=	Space(09)          																			//	009 a 017 - Brancos
cTexto	+=	StrZero(01,06)																				//  018 a 023 - Quantidade de lotes do arquivo
cTexto	+=	StrZero(nQtd,06)																			//  024 a 029 - Quantidade de registros do arquivo
cTexto	+=	StrZero(0,6)      																			//  030 a 035 - Zeros
cTexto	+=	Space(205)      																			//  036 a 240 - Brancos
cTexto	+=	CRLF

if	MemoWrit( xArquivo , cTexto ) 
	if	lAlert
		Alert("Arquivo gerado com sucesso !!!")   
	endif
	RecLock("SEE",.f.)
		SEE->EE_FAXATU	:=	cSeqArq
	MsUnlock("SEE")   
	lRet	:=	.t.
else               
	lRet	:=	.f.
	if	lAlert
		Alert("Arquivo NÃO gerado. Verifique !!!")
	endif
endif

Return ( iif( lRet , {0,xArquivo} , {2,""} ) ) 
