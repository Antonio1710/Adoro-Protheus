#include 'protheus.ch'

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³SRETINFO  ºAutor  ³Alexandre Zapponi   º Data ³  24/04/15   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±         		
±±ºDesc.     ³Retorna os dados para os CNABs                              º±±		ExecBlock("SRETINFO",.f.,.f.,"EST")      		
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

User Function sRetInfo(cTipo)   		 		  				 			  		 			   			 		     			

Local cRet		:=	""  
Local xEmp		:=	""
Local xFil		:=	""
Local aArea		:=	GetArea()
Local aAreaSM0	:=	SM0->(GetArea())     

Default cTipo 	:= 	ParamIxb

if	cTipo == "CGC"	
	cRet	:=	Substr(SM0->M0_CGC,01,14)	
elseif	cTipo == "NOME"	
	cRet	:=	SM0->M0_NOMECOM	
elseif	cTipo == "CID"	
	cRet	:=	SM0->M0_CIDENT	
elseif	cTipo == "END"	
	cRet	:=	SM0->M0_ENDENT	
elseif	cTipo == "CEP"	
	cRet	:=	SM0->M0_CEPENT	
elseif	cTipo == "EST"	
	cRet	:=	SM0->M0_ESTENT	
endif

if	SA6->(FieldPos('A6_ZZEMPR')) <> 0 .and. !Empty(Alltrim(SA6->A6_ZZEMPR))
   	xEmp := SA6->A6_ZZEMPR
else
   	xEmp := cEmpAnt
endif

if	SA6->(FieldPos('A6_ZZFLPR')) <> 0 .and. !Empty(Alltrim(SA6->A6_ZZFLPR))
   	xFil := SA6->A6_ZZFLPR
elseif	SA6->(FieldPos('A6_X_FILIA')) <> 0 .and. !Empty(Alltrim(SA6->A6_X_FILIA))
   	xFil := SA6->A6_X_FILIA
endif
	
if	!Empty(Alltrim(xFil)) .and. ( AllTrim(xEmp) + AllTrim(xFil) ) <> ( AllTrim(SM0->M0_CODIGO) + AllTrim(SM0->M0_CODFIL) )
	SM0->(dbsetorder(1))
	if	SM0->(dbseek( xEmp + xFil , .f. )) 
		if	cTipo == "CGC"	
			cRet	:=	Substr(SM0->M0_CGC,01,14)	
		elseif	cTipo == "NOME"	
			cRet	:=	SM0->M0_NOMECOM	
		elseif	cTipo == "CID"	
			cRet	:=	SM0->M0_CIDENT	
		elseif	cTipo == "END"	
			cRet	:=	SM0->M0_ENDENT	
		elseif	cTipo == "CEP"	
			cRet	:=	SM0->M0_CEPENT	
		elseif	cTipo == "EST"	
			cRet	:=	SM0->M0_ESTENT	
		endif    
	else
		SM0->(dbgotop())
		do while SM0->(!Eof())   
			if	SM0->(deleted())
				SM0->(dbskip())
				Loop
			endif
			if	AllTrim(SM0->M0_CODIGO) == AllTrim(xEmp) .and. AllTrim(SM0->M0_CODFIL) == AllTrim(xFil) // @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabilização pos golive migração dicionário dados
				if	cTipo == "CGC"	
					cRet	:=	Substr(SM0->M0_CGC,01,14)	
				elseif	cTipo == "NOME"	
					cRet	:=	SM0->M0_NOMECOM	
				elseif	cTipo == "CID"	
					cRet	:=	SM0->M0_CIDENT	
				elseif	cTipo == "END"	
					cRet	:=	SM0->M0_ENDENT	
				elseif	cTipo == "CEP"	
					cRet	:=	SM0->M0_CEPENT	
				elseif	cTipo == "EST"	
					cRet	:=	SM0->M0_ESTENT	
				endif    
				Exit
	       	endif
			SM0->(dbskip())
		enddo
	endif    
endif    

RestArea(aAreaSM0)
RestArea(aArea)

Return ( cRet )
