#include 'protheus.ch'        	     	
#include 'protheus.ch'        	     	
                        	          	      	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXRETMODBORบAutor  ณMicrosiga           บ Data ณ  10/05/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xRetModBor(cRet)   	   	
   	         	
Default cRet	:=	ParamIxb[01]		
		
/*
11 - Pagamento de Concessionแrias (Fora Ita๚)
13 - Pagamento de Concessionแrias (Banco Ita๚)
16 - Pagamento de Tributos DARF
17 - Pagamento de Tributos GPS
18 - Pagamento de Tributos DARF SIMPLES   
19 - Pagamento de IPTU
21 - Pagamento de Tributos DARJ
22 - Pagamento de Tributos GARE ICMS SP
25 - Pagamento de Tributos IPVA (SP e MG)
27 - Pagamento de Tributos DPVAT     
28 - GR-PR com Codigo de Barras
35 - Pagamento de Tributos FGTS - GFIP 
OT - Outros Tributos Federais com C๓digo de Barras 
MT - Multas de Transito 
TC - Outros Tributos com C๓digo de Barras 
*/

if	cRet $ "11/13/16/17/18/19/21/22/25/27/28/35/OT/MT/TC"
	cRet :=	"11" 
endif

Return ( cRet )
