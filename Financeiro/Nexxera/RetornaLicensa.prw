#include "topconn.ch"    	
#include "protheus.ch"   	       		
 	    	 	  	
User Function xRetornaLicensa() ; Return      		   			
	                         	
/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Classe    ClasseGeral  �Autor  �Alexandre Zapponi  o� Data �  16/11/16   ���
���������������������������������������������������������������������������͹��
���Descri��o �Classe para retornar dados gerais                             ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

Class RetornaLicensa     	 			

	Method New() Constructor    		  

	Method ChecaEmp() 
	Method ChecaEmpDDA() 
	Method ChecaEmpEXT() 
	Method ChecaEmpSIS() 

EndClass

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Descri��o �M�todo Construtor                                             ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

Method New() Class RetornaLicensa

Return Self

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Descri��o �Retorna os c�digos dos bancos                                 ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

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

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Descri��o �Retorna os c�digos dos bancos                                 ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

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

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Descri��o �Retorna os c�digos dos bancos                                 ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

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

/*�����������������������������������������������������������������������������
�������������������������������������������������������������������������������
���������������������������������������������������������������������������ͻ��
���Descri��o �Retorna os c�digos dos bancos                                 ���
���������������������������������������������������������������������������ͼ��
�������������������������������������������������������������������������������
�����������������������������������������������������������������������������*/

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
