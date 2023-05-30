#include 'protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³sRetTrib  ºAutor  ³Alexandre Zapponi   º Data ³  01/01/18   º±±          		
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Retorna os dados do CNAB                                    º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function sRetTrib()  	 	 			 				  			     		

Local cRet			:=	""      
Local cTipo			:=	ParamIxb
Local aArea			:=	GetArea()
Local aAreaSA2		:=	SA2->(GetArea())
Local aAreaSE2		:=	SE2->(GetArea())
Local aAreaSM0		:=	SM0->(GetArea())      
Local xTipoTrb		:=	"16/17/18/19/21/22/25/27/28/29/35/OT/TC/MT"
//Local xTipoMod	:=	"13/16/17/18/19/21/22/25/27/28/29/30/31/35/OT/TC/MT"

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

	if	Alltrim(SEA->EA_PORTADO) == "341" .and. ( SEA->EA_MODELO $ xTipoTrb .or. SE2->E2_ZZMODBD $ xTipoTrb )
		cRet	:=	"22"
	endif

elseif	Upper(Alltrim(cTipo)) == "MOD"        			

	SA2->(dbsetorder(1),dbseek(xFilial("SA2") + SEA->(EA_FORNECE + EA_LOJA) , .f. ))
	SE2->(dbsetorder(1),dbseek(xFilial("SE2") + SEA->(EA_PREFIXO + EA_NUM + EA_PARCELA + EA_TIPO + EA_FORNECE + EA_LOJA) , .f. ))

	cRet := Substr(SEA->EA_MODELO,1,2)    

	if	Alltrim(SEA->EA_MODELO) == "13"
		if	Alltrim(SEA->EA_PORTADO) == "001" 
			cRet := "11" 
		elseif	Alltrim(SEA->EA_PORTADO) == "341" 
			if	Alltrim(SE2->E2_ZZMODBD) $ xTipoTrb 
				cRet := "91" 
			endif 
		elseif !Empty(SE2->E2_ZZMODBD)
			cRet := iif( SE2->E2_ZZMODBD $ "OT/TC" , "91" , iif( SE2->E2_ZZMODBD $ "MT" , "19" , SE2->E2_ZZMODBD ) )
		endif
	endif

elseif	Upper(Alltrim(cTipo)) == "VENCTO"    

	if	SE2->(FieldPos('E2_ZZDTVC')) <> 0 .and. !Empty(SE2->E2_ZZDTVC)
		cRet	:=	GravaData(SE2->E2_ZZDTVC,.f.,5)
	else
		cRet	:=	GravaData(SE2->E2_VENCREA,.f.,5)
	endif

endif

RestArea(aAreaSM0)   
RestArea(aAreaSE2)   
RestArea(aAreaSA2)   
RestArea(aArea)

Return ( cRet ) 
