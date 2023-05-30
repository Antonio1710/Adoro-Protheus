#include "topconn.ch"    	
#include "protheus.ch"   	       		
 	    	 	  	
User Function xRetornaLicensa() ; Return      		   			
	                         	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºClasse    ClasseGeral  ºAutor  ³Alexandre Zapponi  oº Data ³  16/11/16   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescrição ³Classe para retornar dados gerais                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Class RetornaLicensa     	 			

	Method New() Constructor    		  

	Method ChecaEmp() 
	Method ChecaEmpDDA() 
	Method ChecaEmpEXT() 
	Method ChecaEmpSIS() 

EndClass

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºDescrição ³Método Construtor                                             º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Method New() Class RetornaLicensa

Return Self

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºDescrição ³Retorna os códigos dos bancos                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Method ChecaEmp() Class RetornaLicensa      

Local lRet	:=	.f.
Local aArea	:=	SM0->(GetArea())

SM0->(dbgotop())     

do while SM0->(!Eof())      

	if	SM0->(deleted())
		SM0->(dbskip())
		Loop
	endif

	Do Case
		Case "ADORO"   	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "CERES" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "RNX2" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "SAFEGG" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "CLML" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "GMSBS" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "SYMPLIFY" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Otherwise
			lRet := .t.
	EndCase
	
	if	lRet
		Exit
	endif

	SM0->(dbskip())
enddo

RestArea(aArea)

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºDescrição ³Retorna os códigos dos bancos                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Method ChecaEmpDDA() Class RetornaLicensa      

Local lRet	:=	.f.
Local aArea	:=	SM0->(GetArea())

SM0->(dbgotop())     

do while SM0->(!Eof())      

	if	SM0->(deleted())
		SM0->(dbskip())
		Loop
	endif

	Do Case
		Case "ADORO"   	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "CERES" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "RNX2" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "SAFEGG" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "CLML" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "GMSBS" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "SYMPLIFY" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Otherwise
			lRet := .t.
	EndCase
	
	if	lRet
		Exit
	endif

	SM0->(dbskip())
enddo

RestArea(aArea)

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºDescrição ³Retorna os códigos dos bancos                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Method ChecaEmpEXT() Class RetornaLicensa      

Local lRet	:=	.f.
Local aArea	:=	SM0->(GetArea())

SM0->(dbgotop())     

do while SM0->(!Eof())      

	if	SM0->(deleted())
		SM0->(dbskip())
		Loop
	endif

	Do Case
		Case "ADORO"   	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "CERES" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "RNX2" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "SAFEGG" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "CLML" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "GMSBS" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "SYMPLIFY" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Otherwise
			lRet := .t.
	EndCase   
	
	if	lRet
		Exit
	endif

	SM0->(dbskip())
enddo

RestArea(aArea)

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºDescrição ³Retorna os códigos dos bancos                                 º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß*/

Method ChecaEmpSIS() Class RetornaLicensa    		  

Local lRet	:=	.f.
Local aArea	:=	SM0->(GetArea())

SM0->(dbgotop())     		

do while SM0->(!Eof())      

	if	SM0->(deleted())
		SM0->(dbskip())
		Loop
	endif

	Do Case
		Case "ADORO"   	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "CERES" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "RNX2" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "SAFEGG" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "CLML" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "GMSBS" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Case "SYMPLIFY" 	$ Upper(SM0->M0_NOMECOM)
			lRet := .t. 
		Otherwise
			lRet := .t.
	EndCase   
	
	if	lRet
		Exit
	endif

	SM0->(dbskip())
enddo

RestArea(aArea)

Return ( lRet )
