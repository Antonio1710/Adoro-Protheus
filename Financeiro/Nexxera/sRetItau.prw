#include 'protheus.ch'                                                         		

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³sRetItau ºAutor  ³Alexandre Zapponi    º Data ³  01/01/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±         // ExecBlock("SRETITAU",.f.,.f.,"VCTBOL")		 		
±±ºDesc.     ³Retorna os dados para os CNABs do ITAU                      º±±		
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function sRetItau( cTipo )    						   			 		     			

Local dDat		
Local xEnd
Local xNum     
Local xTel       
Local xLin
Local cCta			:=	""  
Local cDig			:=	""  
Local cRet			:=	""  
Local xRet			:=	""   
Local cNome			:=	""            
Local lSM0			:=	.f.
Local aArea			:=	GetArea()
Local aAreaSA2		:=	SA2->(GetArea())
Local aAreaSE2		:=	SE2->(GetArea())
Local aAreaSM0		:=	SM0->(GetArea())
Local cDigCta		:=	SuperGetMv("ZZ_CPDGCT",.f.,"")
Local oObj			:= 	GeneralClass():New()

Default cTipo 		:= 	ParamIxb

if	Empty(cTipo) .or. cTipo == "22EXT" 
	if !Empty(SE2->E2_ZZCNPJ)
		if	oObj:PosicionaSM0(cEmpAnt,Nil,Alltrim(SE2->E2_ZZCNPJ))		
		   	cNome := Upper(Alltrim(SM0->M0_NOMECOM)) 
		   	lSM0  := .t.
		else
			SA2->(dbsetorder(3))
			if	SA2->(dbseek( xFilial("SA2") + PadR( Upper(Alltrim(SE2->E2_ZZCNPJ)) , TamSX3("A2_CGC")[1] ) , .f. ))
		    	cNome := Upper(Alltrim(SA2->A2_NOME)) 
			else
				RestArea(aAreaSA2)  
				RestArea(aAreaSM0)  
		    	cNome := Upper(Alltrim(SA2->A2_NOME))
			endif
		endif	
	endif	
endif	
	
if	cTipo == "NOM"
	if	SA2->(FieldPos('A2_ZZBENEF')) <> 0 .and. !Empty(SA2->A2_ZZBENEF)
		cRet	:=	Substr(SA2->A2_ZZBENEF,01,30)
	else
		cRet	:=	Substr(SA2->A2_NOME,01,30)
	endif
elseif	cTipo == "NOMTRIB"
	if !Empty(SA2->A2_CGC) .and. oObj:PosicionaSM0(cEmpAnt,Nil,Alltrim(SA2->A2_CGC))		
	   	cRet 	:= 	Upper(Alltrim(SM0->M0_NOMECOM)) 
	else
    	cRet 	:= 	Upper(Alltrim(SA2->A2_NOME))
	endif	
elseif	cTipo == "TIP"
	if	SA2->(FieldPos('A2_ZZCGC')) <> 0 .and. !Empty(SA2->A2_ZZCGC)
		cRet	:=	iif( Len(Alltrim(SA2->A2_ZZCGC)) == 11 , "1" , "2" )
	else
		cRet	:=	iif( Len(Alltrim(SA2->A2_CGC)) == 11 , "1" , "2" )
	endif
elseif	cTipo == "CGC"
	if	SA2->(FieldPos('A2_ZZCGC')) <> 0 .and. !Empty(SA2->A2_ZZCGC)
		cRet	:=	Substr(SA2->A2_ZZCGC,01,14)
	else
		cRet	:=	Substr(SA2->A2_CGC,01,14)
	endif
elseif	cTipo == "CGC2"
	if	SA2->(FieldPos('A2_ZZCGC')) <> 0 .and. !Empty(SA2->A2_ZZCGC)
		cRet	:=	StrZero(Val(SA2->A2_ZZCGC),14)
	else
		cRet	:=	StrZero(Val(SA2->A2_CGC),14)
	endif
elseif	cTipo == "AGC"
	if !Empty(cDigCta) .and. SA2->(FieldPos(cDigCta)) <> 0 
		xRet	:=	Alltrim(&("SA2->" + cDigCta))
	elseif	SA2->(FieldPos("A2_DVCTA")) <> 0 .and. !Empty(SA2->A2_DVCTA) 
		xRet	:=	Alltrim(SA2->A2_DVCTA)
	else	
		xRet	:=	Alltrim(SA2->A2_ZZDGCT)
	endif
	cRet 		:= 	StrZero(Val(SA2->A2_AGENCIA),05)
	cRet 		+= 	Space(01)
	if	"-" $ Alltrim(SA2->A2_NUMCON) .or. Empty(xRet)
		cCta 	:= 	StrZero(Val(StrTran(SA2->A2_NUMCON,"-","")),13)  
		cDig	:=	Substr(cCta,13,01)
		cCta	:=	Substr(cCta,01,12)
		cRet 	+= 	cCta + Space(01) + cDig
	else
		cRet 	+=	StrZero(Val(SA2->A2_NUMCON),12) + Space(01) + xRet
	endif
elseif	cTipo == "VCTBOL"
	dDat		:=	iif( Substr(SE2->E2_CODBAR,06,04) == "0000" , SE2->E2_VENCREA , StoD("19971007") + Val(Substr(SE2->E2_CODBAR,06,04)) )
	cRet		:=	GravaData(dDat,.f.,5)
elseif	cTipo == "END"	
	if	"," $ SA2->A2_END 
		cRet	:=	Substr(SA2->A2_END,01,At(",",SA2->A2_END) - 1)
	else
		cRet	:=	SA2->A2_END
	endif
elseif	cTipo == "NUM"	
	if	"," $ SA2->A2_END 
		cRet	:=	Substr(SA2->A2_END,At(",",SA2->A2_END) + 1,05)
	else
		cRet	:=	"0"
	endif	
elseif cTipo == "22EXT"

	xValAcF	+=	SE2->E2_ZZVLAF
	xValHoA	+=	SE2->E2_ZZVLHA

	xEnd	:=	Upper( iif( lSM0 , SM0->M0_ENDENT , SA2->A2_END ) )

	if	"," $ xEnd
		xNum	:=	Substr(xEnd,At(",",xEnd) + 1,05)
		xEnd	:=	Substr(xEnd,01,At(",",xEnd) - 1)
	else
		xNum	:=	"0"
	endif

	if	lSM0
		xTel	:=	StrZero(Val(Right(Upper(Alltrim(StrTran(SM0->M0_TEL,"-",""))),10)),13)
	else
		xTel	:=	StrZero(Val(SA2->A2_DDD),03) + StrZero(Val(Substr(SA2->A2_TEL,01,08)),08)
	endif

	cRet	+=	PadR(Alltrim(xEnd),30)																					// 033 a 062 - Endereço                      
	cRet	+=	StrZero(Val(xNum),005)																					// 063 a 067 - Numero do Endereço           
	cRet	+=	Space(15)                                       														// 068 a 082 - Espaços                 
	cRet	+=	PadR(Upper( iif( lSM0 , SM0->M0_BAIRENT , SA2->A2_BAIRRO ) ),15)					  					// 083 a 097 - Bairro 
	cRet	+=	PadR(Upper( iif( lSM0 , SM0->M0_CIDENT  , SA2->A2_MUN    ) ),20)					  					// 098 a 117 - Municipio
	cRet	+=	PadR(Upper( iif( lSM0 , SM0->M0_CEPENT  , SA2->A2_CEP    ) ),08)					  					// 118 a 125 - CEP     
	cRet	+=	PadR(Upper( iif( lSM0 , SM0->M0_ESTENT  , SA2->A2_EST    ) ),02)					  					// 126 a 127 - Estado  
	cRet	+=	xTel																									// 128 a 138 - Telefone
	cRet	+=	StrZero( SE2->E2_ZZVLAF * 100 , 14 )																	// 139 a 152 - Valor do Acréscimo Financeiro
	cRet	+=	StrZero( SE2->E2_ZZVLHA * 100 , 14 )																	// 153 a 166 - Valor do Honorário Advocatício

//	DARF

elseif	Upper(Alltrim(SEA->EA_MODELO)) == "16"

	xValPri	+=	SE2->E2_ZZVLPR
	xValMul	+=	SE2->E2_ZZVLMT
	xValJur	+=	SE2->E2_ZZVLJR

	dDat	:=	SE2->E2_ZZDTAP

	cRet	+=	"02"																									// 018 a 019 - Identificacao do Tributo - 02 - DARF
	cRet	+=	StrZero(Val(SE2->E2_CODRET),04)																			// 020 a 023 - Codigo do Pagamento
	cRet	+=	"2"																										// 024 a 024 - 2 = CNPJ
	cRet	+=	PadR(Alltrim(SE2->E2_ZZCNPJ),14)																		// 025 a 038 - CNPJ do Contribuinte
	cRet	+=	GravaData(dDat,.f.,5)																					// 039 a 046 - Periodo de Apuracao 
	cRet	+=	Strzero(Val(SE2->E2_IDDARF),17)	 																		// 047 a 063 - Numero de referencia
	cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,14)																		// 064 a 077 - Valor do principal        					
	cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,14)																		// 078 a 091 - Valor da multa            					
	cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,14)																		// 092 a 105 - Valor do juros / encargos 					
	cRet	+=	StrZero(SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) * 100,14)													// 106 a 119 - Valor pago
	cRet	+=	GravaData(SE2->E2_ZZDTVC,.f.,5)							   												// 120 a 127 - Data de Vencimento  
	cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																		// 128 a 135 - Data de Pagamento   
	cRet	+=	Space(30)                        																		// 136 a 165 - Brancos             
	cRet	+=	PadR(cNome,30)               																			// 166 a 195 - Nome do Contribuinte     

//	GPS

elseif	Upper(Alltrim(SEA->EA_MODELO)) == "17"

	xValPri	+=	SE2->E2_ZZVLPR
	xValEnt	+=	SE2->E2_ZZVLMT
	xValJur	+=	SE2->E2_ZZVLJR

	dDat	:=	SE2->E2_ZZDTAP

	if !Empty(SE2->E2_ZZNRCEI) .and. !Empty(SE2->E2_ZZCNPJ) .and. SA2->(dbsetorder(3),dbseek(xFilial("SA2") + PadR(Alltrim(SE2->E2_ZZCNPJ),Len(SA2->A2_CGC)) , .f. ))

		cRet	+=	"01"																								// 018 a 019 - Identificacao do Tributo - 01 - GPS
		cRet	+=	StrZero(Val(SE2->E2_CODINS),04)																		// 020 a 023 - Codigo do Pagamento
		cRet	+=	PadR(StrTran(SE2->E2_ZZREFMA,"/",""),06)		  													// 024 a 029 - Mes e Ano de Competencia        
		cRet	+=	StrZero(Val(SE2->E2_ZZNRCEI),14)																	// 030 a 043 - CEI do Contribuinte
		cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,14)																	// 044 a 057 - Valor do Pagamento  
		cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,14)																	// 058 a 071 - Valor de Outras Entidades 						
		cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,14)																	// 072 a 085 - Valor de Atualizacao Monetaria , Multa e Juros	
		cRet	+=	StrZero(SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) * 100,14)				  								// 086 a 099 - Valor Arrecadado    
		cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																	// 100 a 107 - Data de Pagamento   
		cRet	+=	Space(08)                        																	// 108 a 115 - Brancos             
		cRet	+=	PadR("GPS",50)                     																	// 116 a 165 - Informacoes Coplementares
		cRet	+=	PadR(SA2->A2_NOME,30)              																	// 166 a 195 - Nome do Contribuinte     

	elseif !Empty(SE2->E2_ZZCNPJ) .and. SA2->(dbsetorder(3),dbseek(xFilial("SA2") + PadR(Alltrim(SE2->E2_ZZCNPJ),Len(SA2->A2_CGC)) , .f. ))

		cRet	+=	"01"																								// 018 a 019 - Identificacao do Tributo - 01 - GPS
		cRet	+=	StrZero(Val(SE2->E2_CODINS),04)																		// 020 a 023 - Codigo do Pagamento
		cRet	+=	PadR(StrTran(SE2->E2_ZZREFMA,"/",""),06)					  										// 024 a 029 - Mes e Ano de Competencia        
		cRet	+=	StrZero(Val(SE2->E2_ZZCNPJ),14)																		// 030 a 043 - CNPJ do Contribuinte
		cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,14)																	// 044 a 057 - Valor do Pagamento  
		cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,14)																	// 058 a 071 - Valor de Outras Entidades 						
		cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,14)																	// 072 a 085 - Valor de Atualizacao Monetaria , Multa e Juros	
		cRet	+=	StrZero(SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) * 100,14)			  									// 086 a 099 - Valor Arrecadado    
		cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																	// 100 a 107 - Data de Pagamento   
		cRet	+=	Space(08)                        																	// 108 a 115 - Brancos             
		cRet	+=	PadR("GPS",50)                     																	// 116 a 165 - Informacoes Coplementares
		cRet	+=	PadR(SA2->A2_NOME,30)              																	// 166 a 195 - Nome do Contribuinte     
	
	else

		if	Upper(Alltrim(SE2->E2_ZZCNPJ)) <> Upper(Alltrim(SM0->M0_CGC))
			SM0->(dbgotop())
			do while SM0->(!Eof())
				if	Upper(Alltrim(SE2->E2_ZZCNPJ)) == Upper(Alltrim(SM0->M0_CGC))
					Exit
				endif
				SM0->(dbskip())
			enddo
		endif
		
		cRet	+=	"01"																								// 018 a 019 - Identificacao do Tributo - 01 - GPS
		cRet	+=	StrZero(Val(SE2->E2_CODINS),04)																		// 020 a 023 - Codigo do Pagamento
		cRet	+=	PadR(StrTran(SE2->E2_ZZREFMA,"/",""),06)			   												// 024 a 029 - Mes e Ano de Competencia        
		cRet	+=	iif( !Empty(SE2->E2_ZZNRCEI) , StrZero(Val(SE2->E2_ZZNRCEI),14) , StrZero(Val(SM0->M0_CGC),14) ) 	// 030 a 043 - CNPJ do Contribuinte
		cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,14)																	// 044 a 057 - Valor do Pagamento  
		cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,14)																	// 058 a 071 - Valor de Outras Entidades 						
		cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,14)																	// 072 a 085 - Valor de Atualizacao Monetaria , Multa e Juros	
		cRet	+=	StrZero(SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) * 100,14)				   								// 086 a 099 - Valor Arrecadado    
		cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																	// 100 a 107 - Data de Pagamento   
		cRet	+=	Space(08)                        																	// 108 a 115 - Brancos             
		cRet	+=	PadR("GPS",50)                     																	// 116 a 165 - Informacoes Coplementares
		cRet	+=	Upper(PadR(SM0->MO_NOMECOM,30))    																	// 166 a 195 - Nome do Contribuinte     

	 endif 	    

// DARF SIMPLES

elseif	Upper(Alltrim(SEA->EA_MODELO)) == "18"

	xValPri	+=	SE2->E2_ZZVLPR
	xValMul	+=	SE2->E2_ZZVLMT
	xValJur	+=	SE2->E2_ZZVLJR

	dDat	:=	SE2->E2_ZZDTAP

	cRet	+=	"03"																									// 018 a 019 - Identificacao do Tributo - 03 - DARF SIMPLES
	cRet	+=	StrZero(Val(SE2->E2_CODRET),04)																			// 020 a 023 - Codigo do Pagamento
	cRet	+=	"2"																										// 024 a 024 - 2 = CNPJ
	cRet	+=	PadR(Alltrim(SE2->E2_ZZCNPJ),14)																		// 025 a 038 - CNPJ do Contribuinte
	cRet	+=	GravaData(dDat,.f.,5)																					// 039 a 046 - Periodo de Apuracao 
	cRet	+=	Strzero(SE2->E2_ZZPRIS * 100,09)																		// 047 a 055 - Receita Bruta       
	cRet	+=	Strzero(SE2->E2_ZZPRCS * 100,04)																		// 056 a 059 - Percentual da Receita Bruta       
	cRet	+=	Space(04)                        																		// 060 a 063 - Brancos             
	cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,14)																		// 064 a 077 - Valor do principal        					
	cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,14)																		// 078 a 091 - Valor da multa            					
	cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,14)																		// 092 a 105 - Valor do juros / encargos 					
	cRet	+=	StrZero(SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) * 100,14)			 										// 106 a 119 - Valor pago
	cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)						   												// 120 a 127 - Data de Vencimento  
	cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																		// 128 a 135 - Data de Pagamento   
	cRet	+=	Space(30)                        																		// 136 a 165 - Brancos             
	cRet	+=	PadR(cNome,30)               																			// 166 a 195 - Nome do Contribuinte     

// DARJ

elseif	Upper(Alltrim(SEA->EA_MODELO)) == "21"

	xValPri	+=	SE2->E2_ZZVLPR
	xValMul	+=	SE2->E2_ZZVLMT
	xValJur	+=	SE2->E2_ZZVLJR
	xValAcF	+=	SE2->E2_ZZVLAF

	cRet	+=	"04"																									// 018 a 019 - Identificacao do Tributo - 04 - DARJ
	cRet	+=	StrZero(Val(SE2->E2_ZZCGARE),04)																		// 020 a 023 - Codigo do Pagamento
	cRet	+=	"2"																										// 024 a 024 - 2 = CNPJ
	cRet	+=	PadR(Alltrim(SE2->E2_ZZCNPJ),14)																		// 025 a 038 - CNPJ do Contribuinte
	cRet	+=	PadR(Alltrim(SE2->E2_ZZINEST),08)																		// 039 a 046 - Inscrição Estadual  
	cRet	+=	PadR(Alltrim(SE2->E2_ZZDORRJ),16)																		// 047 a 062 - Documento de Origem 
 	cRet	+=	Space(01)                        																		// 063 a 063 - Brancos             
	cRet	+=	Strzero(SE2->E2_ZZVLPR * 100,14)																		// 064 a 077 - Receita             
	cRet	+=	Strzero(SE2->E2_ZZVLAF * 100,14)																		// 078 a 091 - Acréscimo Financeiro
	cRet	+=	Strzero(SE2->E2_ZZVLJR * 100,14)																		// 092 a 105 - Juros               
	cRet	+=	Strzero(SE2->E2_ZZVLMT * 100,14)																		// 106 a 119 - Multa           
	cRet	+=	StrZero(SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) * 100,14)			 										// 120 a 133 - Valor pago
	cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)						   												// 134 a 141 - Data de Vencimento  
	cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																		// 142 a 149 - Data de Pagamento   
	cRet	+=	PadR(Alltrim(SE2->E2_ZZREFMA),06)																		// 150 a 155 - Mês/Ano             
 	cRet	+=	Space(10)                        																		// 156 a 165 - Brancos             
	cRet	+=	PadR(cNome,30)               																			// 166 a 195 - Nome do Contribuinte     

// GARE ICMS SP

elseif	Upper(Alltrim(SEA->EA_MODELO)) == "22"

	xValPri	+=	SE2->E2_ZZVLPR
	xValMul	+=	SE2->E2_ZZVLMT
	xValJur	+=	SE2->E2_ZZVLJR

	cRet	+=	"05"																									// 018 a 019 - Identificacao do Tributo - 05 - GARE
	cRet	+=	StrZero(Val(SE2->E2_ZZCGARE),04)																		// 020 a 023 - Codigo do Pagamento
	cRet	+=	"1"																										// 024 a 024 - 1 = CNPJ
	cRet	+=	PadR(Alltrim(SE2->E2_ZZCNPJ),14)																		// 025 a 038 - CNPJ do Contribuinte
	cRet	+=	PadR(Alltrim(SE2->E2_ZZINEST),12)																		// 039 a 050 - Inscrição Estadual  
	cRet	+=	PadR(Alltrim(SE2->E2_ZZDVATV),13)																		// 051 a 063 - Divida Ativa        
	cRet	+=	PadR(Alltrim(SE2->E2_ZZREFMA),06)																		// 064 a 069 - Mês/Ano             
	cRet	+=	PadR(Alltrim(SE2->E2_ZZAIMPR),13)																		// 070 a 082 - Parcela / Notificação
	cRet	+=	Strzero(SE2->E2_ZZVLPR * 100,14)																		// 083 a 096 - Receita             
	cRet	+=	Strzero(SE2->E2_ZZVLJR * 100,14)																		// 097 a 110 - Juros               
	cRet	+=	Strzero(SE2->E2_ZZVLMT * 100,14)																		// 111 a 124 - Multa           
	cRet	+=	StrZero(SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) * 100,14)			 										// 125 a 138 - Valor pago
	cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)						   												// 139 a 146 - Data de Vencimento  
	cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																		// 147 a 154 - Data de Pagamento   
	cRet	+=	Space(11)                        																		// 155 a 165 - Brancos             
	cRet	+=	PadR(cNome,30)               																			// 166 a 195 - Nome do Contribuinte     

// IPVA (25) e DPVAT (27)	 
	 
elseif	Upper(Alltrim(SEA->EA_MODELO)) $ "25/27"

	SM0->(dbgotop())

	do while SM0->(!Eof())   
		if	SM0->(deleted())
			SM0->(dbskip())
			Loop
		endif
		if	Upper(Alltrim(SM0->M0_CODIGO)) == Upper(Alltrim(cEmpAnt)) 
			if	Upper(Alltrim(SM0->M0_CODFIL)) == Upper(Alltrim(SE2->E2_FILORIG))
				Exit
			endif
		endif
		SM0->(dbskip())
	enddo

	xValPri	+=	SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
	xValMul	+=	0
	xValJur	+=	0

	cRet	+=	iif( Upper(Alltrim(SEA->EA_MODELO)) == "25" , "07" , "08" ) 											// 018 a 019 - Identificacao do Tributo - IPVA (25) e DPVAT (27)
	cRet	+=	Space(04)                        																		// 020 a 023 - Brancos             
	cRet	+=	"2"																										// 024 a 024 - 2 = CNPJ
	cRet	+=	PadR(Alltrim(Substr(SM0->M0_CGC,01,14)),14)																// 025 a 038 - CNPJ do Contribuinte
	cRet	+=	StrZero(Val(SE2->E2_ANOBASE),04)																		// 039 a 042 - Ano Base           
	cRet	+=	iif( Len(Alltrim(SE2->E2_ZZRENAV)) == 09 , SE2->E2_ZZRENAV , Space(09) )								// 043 a 051 - Renavan de 9 Digitos
	cRet	+=	SE2->E2_ZZESTVC																							// 052 a 053 - U.f.
	cRet	+=	SE2->E2_ZZCODMN																							// 054 a 058 - Codigo Municipio
	cRet	+=	SE2->E2_ZZPLACA																							// 059 a 065 - Placa           
	cRet	+=	SE2->E2_ZZOPPGT																							// 066 a 066 - Opcao de Pagamento
	cRet	+=	StrZero((SE2->(E2_SALDO+E2_SDACRES)*100),14)															// 067 a 080 - Valor             
	cRet	+=	StrZero(SE2->E2_SDDECRE*100,14)		  																	// 081 a 094 - Desconto          
	cRet	+=	StrZero((SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE)*100),14)													// 095 a 108 - Valor             
	cRet	+=	GravaData(SE2->E2_VENCTO,.f.,5)																			// 109 a 116 - Data de Vencimento  
	cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																		// 117 a 124 - Data de Pagamento   
	cRet	+=	Space(29)                        																		// 125 a 153 - Brancos             
	cRet	+=	iif( Len(Alltrim(SE2->E2_ZZRENAV)) == 09 , Space(12) , StrZero(Val(SE2->E2_ZZRENAV),12)  )				// 154 a 165 - Renavan de 12 Digitos
	cRet	+=	Upper(Substr(SM0->M0_NOMECOM,01,30))																	// 166 a 195 - Nome do Contribuinte

// FGTS (35)
	 
elseif	Upper(Alltrim(SEA->EA_MODELO)) $ "35"       		

	SM0->(dbgotop())

	do while SM0->(!Eof())   
		if	SM0->(deleted())
			SM0->(dbskip())
			Loop
		endif
		if	Upper(Alltrim(SM0->M0_CODIGO)) == Upper(Alltrim(cEmpAnt)) 
			if	Upper(Alltrim(SM0->M0_CODFIL)) == Upper(Alltrim(SE2->E2_FILORIG))
				Exit
			endif
		endif
		SM0->(dbskip())
	enddo

	xValPri	+=	SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
	xValMul	+=	0
	xValJur	+=	0

	if	SE2->(FieldPos("E2_LINDIG")) <> 0 .and. !Empty(SE2->E2_LINDIG) 
		xLin := SE2->E2_LINDIG	
	elseif	SE2->(FieldPos("E2_LINDIGT")) <> 0 .and. !Empty(SE2->E2_LINDIGT) 
		xLin := SE2->E2_LINDIGT	
	elseif	SE2->(FieldPos("E2_ZZLINDG")) <> 0 .and. !Empty(SE2->cE2_ZZLINDG) 
		xLin := SE2->E2_ZZLINDG	
	elseif	SE2->(FieldPos("E2_CODBAR"))  <> 0 .and. !Empty(SE2->E2_CODBAR) 
		xLin :=	SE2->E2_CODBAR
	elseif	SE2->(FieldPos("E2_CBARRA"))  <> 0 .and. !Empty(SE2->E2_CBARRA) 
		xLin :=	SE2->E2_CBARRA
	endif

	cRet	+=	"11"                                                        											// 018 a 019 - Identificacao do Tributo 
	cRet	+=	Space(04)                        																		// 020 a 023 - Brancos             
	cRet	+=	"1"																										// 024 a 024 - 1 = CNPJ
	cRet	+=	PadR(Alltrim(Substr(SM0->M0_CGC,01,14)),14)																// 025 a 038 - CNPJ do Contribuinte
	cRet	+=	PadR( Substr( xLin , 01 , 48 ) , 48 )																	// 039 a 086 - Codigo de Barras
	cRet	+=	Space(16)                        																		// 087 a 102 - Identificador do FGTS
	cRet	+=	Space(09)                        																		// 103 a 111 - Lacre de Conectividade
	cRet	+=	Space(02)                        																		// 112 a 113 - Digito do Lacre de Conectividade
	cRet	+=	Upper(Substr(SM0->M0_NOMECOM,01,30))																	// 114 a 143 - Nome do Contribuinte
	cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																		// 144 a 151 - Data de Pagamento   
	cRet	+=	StrZero((SE2->(E2_SALDO+E2_SDACRES-E2_SDDECRE)*100),14)													// 152 a 165 - Valor             
	cRet	+=	Space(30)                        																		// 166 a 195 - Brancos

endif

RestArea(aAreaSM0)   
RestArea(aAreaSE2)   
RestArea(aAreaSA2)   
RestArea(aArea)

Return ( cRet )
