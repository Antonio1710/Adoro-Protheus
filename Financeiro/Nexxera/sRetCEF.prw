#include 'protheus.ch'                                               		
                        		
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³sRetBrad  ºAutor  ³Microsiga           º Data ³  24/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±         // ExecBlock("SRETBRAD",.f.,.f.,"FORMA")		
±±ºDesc.     ³Retorna os dados para os CNABs da Caixa Economica           º±±		
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function sRetCEF( cTipo )    	 					   			 		     			

Local cOpc		:=	""  
Local cRec		:=	""  
Local cRet		:=	""  
Local xCGC		:=	Nil
Local dDat		:=	Nil
Local xArea		:=	Nil
Local aArea		:=	GetArea()      
Local aAreaSA2	:=	SA2->(GetArea())
Local aAreaSM0	:=	SM0->(GetArea())

Default cTipo 	:= 	ParamIxb

if	cTipo == "TIPO"
	if	StrZero(Val(Substr(SEA->EA_MODELO,1,2)),02) $ "30/31"
		cRet	:=	"20"
	else
		cRet	:=	"22"
	endif
elseif	cTipo == "FORMA"	
	if	StrZero(Val(Substr(SEA->EA_MODELO,1,2)),02) == "13"
		cRet	:=	"11"
	elseif	StrZero(Val(Substr(SEA->EA_MODELO,1,2)),02) $ "03/07/41/43"
		cRet	:=	"03"
	else
		cRet	:=	StrZero(Val(Substr(SEA->EA_MODELO,1,2)),02)
	endif         

	/*
	ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	³ Identificacao dos Tributos  ³
	ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ   

	16 - Pagamento de Tributos DARF
	17 - Pagamento de Tributos GPS
	18 - Pagamento de Tributos DARF SIMPLES   
	19 - Pagamento de IPTU
	21 - Pagamento de Tributos DARJ
	22 - Pagamento de Tributos GARE ICMS SP
	25 - Pagamento de Tributos IPVA (SP e MG)
	27 - Pagamento de Tributos DPVAT     
	28 - GR-PR com Codigo de Barras
	29 - GR-PR sem Codigo de Barras
	35 - Pagamento de Tributos FGTS - GFIP 
	*/

	if	SEA->EA_MODELO $ "16/17/18/19/21/22/25/27/28/29/35" 	
		xArea := SE2->(GetArea())
		if !Empty(SE2->E2_CODBAR)
			cRet 	:=	"11"
		endif		
		RestArea(xArea)
	endif         
elseif	cTipo == "CAM"
	if	StrZero(Val(Substr(SEA->EA_MODELO,1,2)),02) $ "41/43"
		cRet	:=	"018"
	elseif	StrZero(Val(Substr(SEA->EA_MODELO,1,2)),02) $ "03/07"
		cRet	:=	"700"
	else
		cRet	:=	"000"
	endif
elseif	cTipo == "BANCO"	
	cRet		:=	StrZero(Val(SA2->A2_BANCO),03)
elseif	cTipo == "AGENCIA"	
	if	"-" $ SA2->A2_AGENCIA 
		cRet	:=	StrZero(Val(Substr(SA2->A2_AGENCIA,At("-",SA2->A2_AGENCIA) - 1)),05)
	else
		cRet	:=	StrZero(Val(SA2->A2_AGENCIA),05)
	endif
elseif	cTipo == "DVA"	  
	if	"-" $ SA2->A2_AGENCIA 
		cRet	:=	Alltrim(Substr(SA2->A2_AGENCIA,At("-",SA2->A2_AGENCIA) + 1))
		cRet	:=	iif( Empty(cRet) , Space(01) , StrZero(Val(cRet),01) )
	elseif	SA2->(FieldPos('A2_DVAGE')) <> 0 .and. !Empty(SA2->A2_DVAGE)
		cRet	:=	StrZero(Val(SA2->A2_DVAGE),01)
	elseif	SA2->(FieldPos('A2_ZZDGAG')) <> 0 .and. !Empty(SA2->A2_ZZDGAG)
		cRet	:=	StrZero(Val(SA2->A2_ZZDGAG),01)
	else
		cRet	:=	Space(01)
	endif
elseif	cTipo == "CONTA"	
	if	"-" $ SA2->A2_NUMCON 
		cRet	:=	StrZero(Val(Substr(SA2->A2_NUMCON,At("-",SA2->A2_NUMCON) - 1)),12)
	else
		cRet	:=	StrZero(Val(SA2->A2_NUMCON),12)
	endif
elseif	cTipo == "DIG"	 
	if	"-" $ SA2->A2_NUMCON 
		cRet	:=	Alltrim(Substr(SA2->A2_NUMCON,At("-",SA2->A2_NUMCON) + 1))
	elseif	SA2->(FieldPos('A2_DVCTA')) <> 0 .and. !Empty(SA2->A2_DVCTA)
		cRet	:=	Alltrim(SA2->A2_DVCTA)
	elseif	SA2->(FieldPos('A2_ZZDGCT')) <> 0 .and. !Empty(SA2->A2_ZZDGCT)
		cRet	:=	Alltrim(SA2->A2_ZZDGCT)
	else
		cRet	:=	Space(01)
	endif
elseif	cTipo == "NOM"
	if	SA2->(FieldPos('A2_ZZBENEF')) <> 0 .and. !Empty(SA2->A2_ZZBENEF)
		cRet	:=	Substr(SA2->A2_ZZBENEF,01,30)
	else
		cRet	:=	Substr(SA2->A2_NOME,01,30)
	endif           
elseif	cTipo == "VCTBOL"
	dDat		:=	iif( Substr(SE2->E2_CODBAR,06,04) == "0000" , SE2->E2_VENCREA , StoD("19971007") + Val(Substr(SE2->E2_CODBAR,06,04)) )
	cRet		:=	GravaData(dDat,.f.,5)
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
elseif	cTipo == "NOM2"
	if	SA2->(FieldPos('A2_ZZBENEF')) <> 0 .and. !Empty(SA2->A2_ZZBENEF)
		cRet	:=	Substr(SA2->A2_ZZBENEF,01,40)
	else
		cRet	:=	Substr(SA2->A2_NOME,01,40)
	endif
elseif	cTipo == "END"	
	if	"," $ SA2->A2_END 
		cRet	:=	Substr(SA2->A2_END,01,At(",",SA2->A2_END) - 1)
	else
		cRet	:=	SA2->A2_END
	endif
elseif	cTipo == "NUM"	
	if	"," $ SA2->A2_END 
		cRet	:=	Substr(SA2->A2_END,At(",",SA2->A2_END) + 1)
	else
		cRet	:=	"0"
	endif
elseif	cTipo == "BAIRRO"	
	cRet		:=	Substr(SA2->A2_BAIRRO,01,15)
elseif	cTipo == "CIDADE"
	cRet		:=	Substr(SA2->A2_MUN,01,20)
elseif	cTipo == "CEP"
	cRet		:=	StrZero(Val(StrTran(SA2->A2_CEP,"-","")),8)
elseif	cTipo == "ESTADO"
	cRet		:=	Substr(SA2->A2_EST,01,02)
elseif	cTipo == "TRIB"	

	// Darf        		

	if	Upper(Alltrim(SEA->EA_MODELO)) == "16"	   			

		xValPri	+=	SE2->E2_ZZVLPR
		xValMul	+=	SE2->E2_ZZVLMT
		xValJur	+=	SE2->E2_ZZVLJR
		
		dDat	:=	SE2->E2_ZZDTAP
		xCGC	:=	iif( Empty(SE2->E2_ZZCNPJ) , SM0->M0_CGC , SE2->E2_ZZCNPJ )

		cRet	+=	PadR(StrZero(Val(SE2->E2_CODRET),04),06)														// 111 a 116 - Codigo da Receita  
		cRet	+=	iif( Len(xCGC) == 14 , "01" , "02" )                 											// 117 a 118 - 1 = CNPJ / 2 = CPF
		cRet	+=	StrZero(Val(xCGC),14)																			// 119 a 132 - CNPJ do Contribuinte
		cRet	+=	"16"                                                                                           	// 133 a 134 - Identificacao do Tributo
		cRet	+=	GravaData(dDat,.f.,5)																			// 135 a 142 - Periodo de Apuracao 
		cRet	+=	StrZero(Val(SE2->E2_IDDARF),17) 																// 143 a 159 - Numero de referencia
		cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,15)																// 160 a 174 - Valor do principal        					
		cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,15)																// 175 a 189 - Valor da multa            					
		cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,15)																// 190 a 204 - Valor do juros / encargos 					
		cRet	+=	GravaData(SE2->E2_ZZDTVC,.f.,5)							   										// 205 a 212 - Data de Vencimento  
		cRet	+=	Space(18)                        																// 213 a 230 - Brancos             
	
	// Gps

	elseif	Upper(Alltrim(SEA->EA_MODELO)) == "17"		

		xValPri	+=	SE2->E2_ZZVLPR
		xValMul	+=	SE2->E2_ZZVLMT
		xValJur	+=	SE2->E2_ZZVLJR
		
		dDat	:=	SE2->E2_ZZDTAP

		cRet	+=	PadR(StrZero(Val(SE2->E2_CODINS),04),06)														// 111 a 116 - Codigo da Receita  
		if 	!Empty(SE2->E2_ZZNRCEI) 
			cRet	+=	"04"																						// 117 a 118 - 3 = CEI
			cRet	+=	PadR(Alltrim(SE2->E2_ZZNRCEI),14)															// 119 a 132 - CEI do Contribuinte
		elseif	!Empty(SE2->E2_ZZCNPJ) .and. SA2->(dbsetorder(3),dbseek(xFilial("SA2") + PadR(Alltrim(SE2->E2_ZZCNPJ),Len(SA2->A2_CGC)) , .f. ))
			cRet	+=	iif( Len(Alltrim(SE2->E2_ZZCNPJ)) == 14 , "01" , "02" )										// 117 a 118 - 1 = CNPJ / 2 = CPF
			cRet	+=	PadR(Alltrim(SE2->E2_ZZCNPJ),14)															// 119 a 132 - CNPJ do Contribuinte
		else          
			RestArea(aAreaSA2)
			cRet	+=	iif( Len(Alltrim(SA2->A2_CGC)) == 14 , "01" , "02" )										// 117 a 118 - 1 = CNPJ / 2 = CPF
			cRet	+=	PadR(Alltrim(SA2->A2_CGC),14)																// 119 a 132 - CNPJ do Contribuinte
		endif
		cRet	+=	"17"                                                                                           	// 133 a 134 - Identificacao do Tributo
		cRet	+=	StrTran(SE2->E2_ZZREFMA,"/","")																	// 135 a 140 - Mes e Ano de Competencia
		cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,15) 																// 141 a 155 - Valor previsto de pagamento
		cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,15)																// 156 a 170 - Valor das outras entidades					
		cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,15)																// 171 a 185 - Atualizacao Monetaria     					
		cRet	+=	Space(45)                        																// 186 a 230 - Brancos             

	// Darf Simples

	elseif	Upper(Alltrim(SEA->EA_MODELO)) == "18"			

		xValPri	+=	SE2->E2_ZZVLPR
		xValMul	+=	SE2->E2_ZZVLMT
		xValJur	+=	SE2->E2_ZZVLJR
		
		dDat	:=	SE2->E2_ZZDTAP
		xCGC	:=	iif( Empty(SE2->E2_ZZCNPJ) , SM0->M0_CGC , SE2->E2_ZZCNPJ )

		cRet	+=	PadR(StrZero(Val(SE2->E2_CODRET),04),06)														// 111 a 116 - Codigo da Receita  
		cRet	+=	iif( Len(xCGC) == 14 , "01" , "02" )                 											// 117 a 118 - 1 = CNPJ / 2 = CPF
		cRet	+=	StrZero(Val(xCGC),14)																			// 119 a 132 - CNPJ do Contribuinte
		cRet	+=	"18"                                                                                           	// 133 a 134 - Identificacao do Tributo
		cRet	+=	GravaData(dDat,.f.,5)																			// 135 a 142 - Periodo de Apuracao 
		cRet	+=	StrZero(SE2->E2_ZZPRIS * 100,15)																// 143 a 157 - Valor do principal        					
		cRet	+=	StrZero(SE2->E2_ZZPRCS * 100,07)																// 158 a 164 - Valor do percentual       					
		cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,15)																// 165 a 179 - Valor do principal        					
		cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,15)																// 180 a 194 - Valor da multa            					
		cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,15)																// 195 a 209 - Valor do juros / encargos 					
		cRet	+=	Space(21)                        																// 210 a 230 - Brancos             
	
	// DARJ 
	
	elseif	Upper(Alltrim(SEA->EA_MODELO)) == "21"

		xValPri	+=	SE2->E2_ZZVLPR
		xValMul	+=	SE2->E2_ZZVLMT
		xValJur	+=	SE2->E2_ZZVLJR
		
		dDat	:=	SE2->E2_ZZDTAP
		xCGC	:=	iif( Empty(SE2->E2_ZZCNPJ) , SM0->M0_CGC , SE2->E2_ZZCNPJ )
	
		cRet	+=	PadR(StrZero(Val(SE2->E2_ZZCGARE),04),06)														// 111 a 116 - Codigo da Receita  
		cRet	+=	iif( Len(xCGC) == 14 , "01" , "02" )                 											// 117 a 118 - 1 = CNPJ / 2 = CPF
		cRet	+=	StrZero(Val(xCGC),14)																			// 119 a 132 - CNPJ do Contribuinte
		cRet	+=	PadR(SE2->E2_ZZINEST,08)																		// 133 a 140 - Inscrição Estadual
		cRet	+=	PadR(SE2->E2_ZZDORRJ,16)																		// 141 a 156 - Documento de Origem
		cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,15)																// 157 a 171 - Valor do principal        					
		cRet	+=	StrZero(SE2->E2_ZZVLAF * 100,15)																// 172 a 186 - Valor do principal        					
		cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,15)																// 187 a 201 - Valor do juros / mora     					
		cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,15)																// 202 a 216 - Valor da multa            					
		cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																// 217 a 224 - Vencimento 
		cRet	+=	PadR(SE2->E2_ZZREFMA,06)																		// 225 a 230 - Periodo de Referencia

	/*
	Tributo GARE SP ICMS  = '22'
	Tributo GARE SP DR    = '23'
	Tributo GARE SP ITCMD = '24'
	*/
	
	elseif	Upper(Alltrim(SEA->EA_MODELO)) == "22"

		xValPri	+=	SE2->E2_ZZVLPR
		xValMul	+=	SE2->E2_ZZVLMT
		xValJur	+=	SE2->E2_ZZVLJR
		
		dDat	:=	SE2->E2_ZZDTAP
		xCGC	:=	iif( Empty(SE2->E2_ZZCNPJ) , SM0->M0_CGC , SE2->E2_ZZCNPJ )
	
		cRet	+=	PadR(StrZero(Val(SE2->E2_ZZCGARE),04),06)														// 111 a 116 - Codigo da Receita  
		cRet	+=	iif( Len(xCGC) == 14 , "01" , "02" )                 											// 117 a 118 - 1 = CNPJ / 2 = CPF
		cRet	+=	StrZero(Val(xCGC),14)																			// 119 a 132 - CNPJ do Contribuinte
		cRet	+=	"22"                                                                                           	// 133 a 134 - Identificacao do Tributo
		cRet	+=	GravaData(SE2->E2_VENCREA,.f.,5)																// 135 a 142 - Vencimento 
		cRet	+=	PadR(SE2->E2_ZZINEST,12)																		// 143 a 154 - Inscrição Estadual
		cRet	+=	PadR(SE2->E2_ZZDVATV,13)																		// 155 a 167 - Divida Ativa   
		cRet	+=	PadR(SE2->E2_ZZREFMA,06)																		// 168 a 173 - Periodo de Referencia
		cRet	+=	PadR(SE2->E2_ZZAIMPR,13)																		// 174 a 186 - Referencia
		cRet	+=	StrZero(SE2->E2_ZZVLPR * 100,15)																// 187 a 201 - Valor do principal        					
		cRet	+=	StrZero(SE2->E2_ZZVLMT * 100,14)																// 202 a 215 - Valor da multa            					
		cRet	+=	StrZero(SE2->E2_ZZVLJR * 100,14)																// 216 a 229 - Valor do juros / encargos 					
		cRet	+=	Space(01)                        																// 230 a 230 - Brancos             

	/*
	‘25’ = Tributo – IPVA
	‘27’ = Tributo – DPVAT
	*/		 

	elseif	Upper(Alltrim(SEA->EA_MODELO)) $ "25/27"
	
		xValPri	+=	SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
		xValMul	+=	0
		xValJur	+=	0

		xCGC	:=	SM0->M0_CGC 
		cRec	:=	"0360"	
		cOpc	:=	iif( Upper(Alltrim(SEA->EA_MODELO)) == "27" , "5" , SE2->E2_ZZOPPGT )		

		cRet	+=	PadR(StrZero(Val(cRec),04),06)	  																// 111 a 116 - Codigo da Receita  
		cRet	+=	"01" 								                 											// 117 a 118 - 1 = CNPJ / 2 = CPF
		cRet	+=	StrZero(Val(xCGC),14)																			// 119 a 132 - CNPJ do Contribuinte
		cRet	+=	PadR(SEA->EA_MODELO,02)                                                                        	// 133 a 134 - Identificacao do Tributo
		cRet	+=	PadR(SEA->E2_ANOBASE,04)                                                                        // 135 a 138 - Ano Base
		cRet	+=	iif( Len(Alltrim(SE2->E2_ZZRENAV)) == 09 , SE2->E2_ZZRENAV , Space(09) )						// 139 a 147 - Renavan de 9 Digitos
		cRet	+=	PadR(SEA->E2_ZZESTVC,02)                                                                       	// 148 a 149 - UF
		cRet	+=	StrZero(Val(SEA->E2_ZZCODMN),05)                                                              	// 150 a 154 - Municipio
		cRet	+=	PadR(StrTran(SEA->E2_ZZPLACA,"-",""),07)                                                       	// 155 a 161 - Placa
		cRet	+=	StrZero(Val(cOpc),01) 			                                                             	// 162 a 162 - Opção de Pagamento
		cRet	+=	iif( Len(Alltrim(SE2->E2_ZZRENAV)) == 09 , Space(12) , StrZero(Val(SE2->E2_ZZRENAV),12) )		// 163 a 174 - Renavan de 12 Digitos
		cRet	+=	Space(55)                        																// 175 a 230 - Brancos             

	/*
	‘26’ = Tributo – Licenciamento
	*/		 

	elseif	Upper(Alltrim(SEA->EA_MODELO)) == "26"
	
		xValPri	+=	SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
		xValMul	+=	0
		xValJur	+=	0

		xCGC	:=	SM0->M0_CGC 
		cRec	:=	"4194" 
		cOpc	:=	"5"	

		cRet	+=	PadR(StrZero(Val(cRec),04),06)	  																// 111 a 116 - Codigo da Receita  
		cRet	+=	"01" 								                 											// 117 a 118 - 1 = CNPJ / 2 = CPF
		cRet	+=	StrZero(Val(xCGC),14)																			// 119 a 132 - CNPJ do Contribuinte
		cRet	+=	PadR(SEA->EA_MODELO,02)                                                                        	// 133 a 134 - Identificacao do Tributo
		cRet	+=	PadR(SEA->E2_ANOBASE,04)                                                                        // 135 a 138 - Ano Base
		cRet	+=	iif( Len(Alltrim(SE2->E2_ZZRENAV)) == 09 , SE2->E2_ZZRENAV , Space(09) )						// 139 a 147 - Renavan de 9 Digitos
		cRet	+=	PadR(SEA->E2_ZZESTVC,02)                                                                       	// 148 a 149 - UF
		cRet	+=	StrZero(Val(SEA->E2_ZZCODMN),05)                                                              	// 150 a 154 - Municipio
		cRet	+=	PadR(StrTran(SEA->E2_ZZPLACA,"-",""),07)                                                       	// 155 a 161 - Placa
		cRet	+=	StrZero(Val(cOpc),01) 			                                                             	// 162 a 162 - Opção de Pagamento
		cRet	+=	"1"                   			                                                             	// 163 a 163 - Opção de Retirada - 1 = Correio | 2 = DETRAN / CIRETRAN	 
		cRet	+=	iif( Len(Alltrim(SE2->E2_ZZRENAV)) == 09 , Space(12) , StrZero(Val(SE2->E2_ZZRENAV),12) )		// 164 a 175 - Renavan de 12 Digitos
		cRet	+=	Space(54)                        																// 176 a 230 - Brancos             

	endif
endif

RestArea(aAreaSA2)
RestArea(aAreaSM0)
RestArea(aArea)

Return ( cRet )
