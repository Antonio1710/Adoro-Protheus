#include 'topconn.ch'      			         		                              		
#include 'protheus.ch'  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³XRETTRIB  ºAutor  ³Microsiga           º Data ³  11/09/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna os dados do CNAB Tributos Itau                      º±±
±±º          ³Posicoes de 018 a 195                                       º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function xRetTrib()  	   		 		 				  			     		

Local cRet			:=	"" 
Local cNome			:=	""
Local dDat			:=	Nil
Local cTipo			:=	ParamIxb
Local aArea			:=	GetArea()
Local aAreaSA2		:=	SA2->(GetArea())
Local aAreaSE2		:=	SE2->(GetArea())
Local aAreaSM0		:=	SM0->(GetArea())   
Local oObj			:= 	GeneralClass():New()

if	Empty(cTipo)
	if !Empty(SE2->E2_ZZCNPJ)
		if	oObj:PosicionaSM0(cEmpAnt,Nil,Alltrim(SE2->E2_ZZCNPJ))		
		   	cNome := Upper(Alltrim(SM0->M0_NOMECOM)) 
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

if	Upper(Alltrim(cTipo)) == "TIPO"                      

	SA2->(dbsetorder(1),dbseek(xFilial("SA2") + SEA->(EA_FORNECE + EA_LOJA) , .f. ))
	SE2->(dbsetorder(1),dbseek(xFilial("SE2") + SEA->(EA_PREFIXO + EA_NUM + EA_PARCELA + EA_TIPO + EA_FORNECE + EA_LOJA) , .f. ))

	if	Upper(Alltrim(SE2->E2_ORIGEM)) == "XDIGDARF"
		cRet	:=	"22"
	elseif	Upper(Alltrim(SE2->E2_ORIGEM)) == "XDIGGPS"
		cRet	:=	"22"
	else		
		cRet	:=	SEA->EA_TIPOPAG     	
	endif
	
elseif	Upper(Alltrim(cTipo)) == "MOD"        			

	SA2->(dbsetorder(1),dbseek(xFilial("SA2") + SEA->(EA_FORNECE + EA_LOJA) , .f. ))
	SE2->(dbsetorder(1),dbseek(xFilial("SE2") + SEA->(EA_PREFIXO + EA_NUM + EA_PARCELA + EA_TIPO + EA_FORNECE + EA_LOJA) , .f. ))
    
	if	Alltrim(SEA->EA_MODELO) == "13" .and. !Empty(SE2->E2_ZZMODBD)
		cRet	:=	iif( SE2->E2_ZZMODBD $ "OT/MT/TC" , "91" , SE2->E2_ZZMODBD )
	elseif	Alltrim(SEA->EA_MODELO) == "13" .and. Alltrim(SEA->EA_PORTADO) == "001" 
		cRet	:=	"11" 
	else		
		cRet	:=	Substr(SEA->EA_MODELO,1,2)
	endif
	
elseif	Upper(Alltrim(cTipo)) == "VENCTO"    

	if	SE2->(FieldPos('E2_ZZDTVC')) <> 0 .and. !Empty(SE2->E2_ZZDTVC)
		cRet	:=	GravaData(SE2->E2_ZZDTVC,.F.,5)
	else
		cRet	:=	GravaData(SE2->E2_VENCREA,.F.,5)
	endif

//	DARF

elseif	Upper(Alltrim(SEA->EA_MODELO)) == "16"

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
	xValMul	+=	SE2->E2_ZZVLMT
	xValJur	+=	SE2->E2_ZZVLJR

	dDat	:=	SE2->E2_ZZDTAP

	if	!Empty(SE2->E2_ZZNRCEI) .and. !Empty(SE2->E2_ZZCNPJ) .and. SA2->(dbsetorder(3),dbseek(xFilial("SA2") + PadR(Alltrim(SE2->E2_ZZCNPJ),Len(SA2->A2_CGC)) , .f. ))

		cRet	+=	"01"																								// 018 a 019 - Identificacao do Tributo - 01 - GPS
		cRet	+=	StrZero(Val(SE2->E2_CODINS),04)																		// 020 a 023 - Codigo do Pagamento
		cRet	+=	PadR(StrTran(SE2->(E2_MESBASE + E2_ANOBASE),"/",""),06)												// 024 a 029 - Mes e Ano de Competencia        
		cRet	+=	StrZero(Val(SE2->E2_ZZNRCEI),14)																	// 030 a 043 - CEI do Contribuinte
		cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,14)																	// 044 a 057 - Valor do Pagamento  
		cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,14)																	// 058 a 071 - Valor de Outras Entidades 						
		cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,14)																	// 072 a 085 - Valor de Atualizacao Monetaria , Multa e Juros	
		cRet	+=	StrZero(SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC) * 100,14)				  								// 086 a 099 - Valor Arrecadado    
		cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																	// 100 a 107 - Data de Pagamento   
		cRet	+=	Space(08)                        																	// 108 a 115 - Brancos             
		cRet	+=	PadR("GPS",50)                     																	// 116 a 165 - Informacoes Coplementares
		cRet	+=	PadR(SA2->A2_NOME,30)              																	// 166 a 195 - Nome do Contribuinte     

	elseif	!Empty(SE2->E2_ZZCNPJ) .and. SA2->(dbsetorder(3),dbseek(xFilial("SA2") + PadR(Alltrim(SE2->E2_ZZCNPJ),Len(SA2->A2_CGC)) , .f. ))

		cRet	+=	"01"																								// 018 a 019 - Identificacao do Tributo - 01 - GPS
		cRet	+=	StrZero(Val(SE2->E2_CODINS),04)																		// 020 a 023 - Codigo do Pagamento
		cRet	+=	PadR(StrTran(SE2->(E2_MESBASE + E2_ANOBASE),"/",""),06)												// 024 a 029 - Mes e Ano de Competencia        
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
		cRet	+=	PadR(StrTran(SE2->(E2_MESBASE + E2_ANOBASE),"/",""),06)												// 024 a 029 - Mes e Ano de Competencia        
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

	xValPri	+=	SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC)
	xValMul	+=	0
	xValJur	+=	0

	cRet	+=	iif( Upper(Alltrim(SEA->EA_MODELO)) == "25" , "07" , "08" ) 											// 018 a 019 - Identificacao do Tributo - 01 - GPS
	cRet	+=	Space(04)                        																		// 020 a 023 - Brancos             
	cRet	+=	"2"																										// 024 a 024 - 2 = CNPJ
	cRet	+=	PadR(Alltrim(ExecBlock("XRETINFO",.f.,.f.,"CGC")),14)													// 025 a 038 - CNPJ do Contribuinte
	cRet	+=	StrZero(Val(SE2->E2_ANOBASE),04)																		// 039 a 042 - Ano Base           
	cRet	+=	iif( Len(Alltrim(SE2->E2_ZZRENAV)) == 09 , SE2->E2_ZZRENAV , "" )										// 043 a 051 - Renavan de 9 Digitos
	cRet	+=	SE2->E2_ZZESTVC																							// 052 a 053 - U.F.
	cRet	+=	SE2->E2_ZZCODMN																							// 054 a 058 - Codigo Municipio
	cRet	+=	SE2->E2_ZZPLACA																							// 059 a 065 - Placa           
	cRet	+=	SE2->E2_ZZOPPGT																							// 066 a 066 - Opcao de Pagamento
	cRet	+=	StrZero((SE2->(E2_SALDO+E2_ACRESC)*100),14)																// 067 a 080 - Valor             
	cRet	+=	StrZero(SE2->E2_DECRESC*100,14)		  																	// 081 a 094 - Desconto          
	cRet	+=	StrZero((SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC)*100),14)													// 095 a 108 - Valor             
	cRet	+=	GravaData(SE2->E2_VENCTO,.f.,5)																			// 109 a 116 - Data de Vencimento  
	cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																		// 117 a 124 - Data de Pagamento   
	cRet	+=	Space(29)                        																		// 125 a 153 - Brancos             
	cRet	+=	iif( Len(Alltrim(SE2->E2_ZZRENAV)) == 09 , "" , StrZero(Val(SE2->E2_ZZRENAV),12)  )						// 154 a 165 - Renavan de 12 Digitos
	cRet	+=	Upper(Substr(ExecBlock("XRETINFO",.f.,.f.,"NOME"),1,30))												// 166 a 195 - Nome do Contribuinte

endif

RestArea(aAreaSM0)   
RestArea(aAreaSE2)   
RestArea(aAreaSA2)   
RestArea(aArea)

Return ( cRet ) 
