#include 'topconn.ch'    		     	  		
#include 'protheus.ch'         	

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³fRetITAU  ºAutor  ³Microsiga           º Data ³  24/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±         // ExecBlock("FRETITAU",.F.,.F.,"VCTBOL")		
±±ºDesc.     ³Retorna os dados para os CNABs do ITAU                      º±±		
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function fRetITAU( cTipo )    	  					   			 		     			

Local dDat		
Local cRet		:=	""  
Local xRet		:=	""  
Local aArea		:=	GetArea()
Local aAreaSM0	:=	SM0->(GetArea())     
Local cDigCta	:=	SuperGetMv("ZZ_CPDGCT",.f.,"")

Default cTipo 	:= 	ParamIxb

if	cTipo == "NOM"
	if	SA2->(FieldPos('A2_ZZBENEF')) <> 0 .and. !Empty(SA2->A2_ZZBENEF)
		cRet	:=	Substr(SA2->A2_ZZBENEF,01,30)
	else
		cRet	:=	Substr(SA2->A2_NOME,01,30)
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
	cRet 		:= 	StrZero(Val(SA2->A2_AGENCIA),05)
	cRet 		+= 	Space(01)
	cRet 		+= 	StrZero(Val(SA2->A2_NUMCON),12)  
	cRet 		+= 	Space(01)
	if	!Empty(cDigCta) .and. SA2->(FieldPos(cDigCta)) <> 0 
		xRet	:=	Alltrim(&("SA2->" + cDigCta))
	elseif	SA2->(FieldPos("A2_DVCTA")) <> 0 .and. !Empty(SA2->A2_DVCTA) 
		xRet	:=	Alltrim(SA2->A2_DVCTA)
	else	
		xRet	:=	Alltrim(SA2->A2_ZZDGCT)
	endif
	cRet 		+=	iif( Empty(xRet) , Space(01) , xRet )
elseif	cTipo == "VCTBOL"
	dDat		:=	iif( Substr(SE2->E2_CODBAR,06,04) == "0000" , SE2->E2_VENCREA , StoD("19971007") + Val(Substr(SE2->E2_CODBAR,06,04)) )
	cRet		:=	GravaData(dDat,.f.,5)
endif

RestArea(aAreaSM0)
RestArea(aArea)

Return ( cRet )
