#include "colors.ch" 	        		                            		   				
#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"
#include "fwprintsetup.ch"           		

#define PAD_LEFT				000     	
#define PAD_RIGHT				001
#define PAD_CENTER 				002

#define	IMP_DISCO 				001
#define	IMP_SPOOL 				002
#define	IMP_EMAIL 				003
#define	IMP_EXCEL 				004
#define	IMP_HTML  				005
#define	IMP_PDF   				006 

#define MB_OK                 	000
#define MB_OKCANCEL           	001
#define MB_YESNO              	004
#define MB_ICONHAND           	016
#define MB_ICONQUESTION       	032
#define MB_ICONEXCLAMATION    	048
#define MB_ICONASTERISK       	064

/*/{Protheus.doc} User Function FINCOMP
	Funcao responsavel por imprimir os comprovantes de pagto
	@type  Function
	@author Alexandre Zapponi
	@since 09/02/09
	@history ticket 81491 - Abel Babini - 27/12/2022 - Projeto Nexxera - Retorno de baixas
	/*/
User Function FINCOMP(oDocto,lPDF,lTransf,lFim,cCodCPV)  	  							

Local xCGC		
Local xBco  
Local xTxt
Local nPula
Local nCTmp1
Local oFont07    	
Local oFont08    	
Local oFont09    	
Local oFont10    	
Local oFont11    	
Local oFont12    	
Local oFont13    	
Local oFont14    	
Local oFont15    	
Local oFont16
Local oFont17
Local oFont07N   	
Local oFont08N   	
Local oFont09N   	
Local oFont10N   	
Local oFont11N   	
Local oFont12N   	
Local oFont13N   	
Local oFont14N   	
Local oFont15N   	
Local oFont16N   	
Local oFont17N   	
Local nLinIni 		:=	0050
Local nLinFim		:=	2935
Local nColIni		:=	0005      
Local nColFim		:=	2190      
Local cFilTmp		:=	cFilAnt
Local cEmpTmp		:=	cEmpAnt
Local aArea			:=	GetArea()
Local aAreaSM0		:=	SM0->(GetArea())    
Local cArq  		:= 	CriaTrab(Nil,.f.)     
Local oObj			:= 	GeneralClass():New()

Local cStartPath 	:= 	GetSrvProfString("Startpath","")
Local cLogoTp   	:= 	cStartPath + "LogoCte" + AllTrim(cEmpAnt) + ".bmp"   
Local lSE2Excl		:=	FwModeAccess("SE2") == "E"
Local lSE5Excl		:=	FwModeAccess("SE5") == "E"

Local lSetCentury 	:= 	__SetCentury()

Default lFim		:=	.t.
Default lPDF		:=	.f.              
Default lTransf		:=	.f.                    
Default cCodCPV		:=	""

SM0->(dbgotop())

do while SM0->(!Eof())
	if	AllTrim(SM0->M0_CODIGO) == AllTrim(cEmpAnt) .and. AllTrim(SM0->M0_CODFIL) == iif( lSE2Excl , AllTrim(SE2->E2_FILIAL) , iif( lSE5Excl , AllTrim(SE5->E5_FILIAL) , AllTrim(SE5->E5_FILORIG) ) )  // @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabiliza็ใo pos golive migra็ใo dicionแrio dados
		cFilAnt := AllTrim(SM0->M0_CODFIL) // @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabiliza็ใo pos golive migra็ใo dicionแrio dados
		Exit
	endif
	SM0->(dbskip())
enddo

if	SM0->(Eof())
	RestArea(aAreaSM0)
endif

if	oDocto	== Nil            
	if	lPDF
		oDocto := FwMsPrinter():New(cArq,IMP_PDF,.t.,,.t.)
 		oDocto:cPathPDF := "\spool\"       
  		oDocto:SetViewPDF(.t.) 
		oDocto:lInJob 	:= 	.t.
		oDocto:lServer 	:= 	.t.   
		oDocto:lViewPDF	:=	.t.
	else
		oDocto := FwMsPrinter():New(cArq,IMP_SPOOL) 
		oDocto:lServer 	:= 	.f.
	endif	
	oDocto:SetResolution(78) 
	oDocto:SetPortrait()
	oDocto:SetPaperSize(9) 
	oDocto:SetMargin(60,60,60,60)        
endif
	
oFont07    	:= 	tFontEx():New(oDocto,"Arial",07,07,.f.,.t.,.f.)	
oFont08    	:= 	tFontEx():New(oDocto,"Arial",08,08,.f.,.t.,.f.)	
oFont09    	:= 	tFontEx():New(oDocto,"Arial",09,09,.f.,.t.,.f.)	
oFont10    	:= 	tFontEx():New(oDocto,"Arial",10,10,.f.,.t.,.f.)	
oFont11    	:= 	tFontEx():New(oDocto,"Arial",11,11,.f.,.t.,.f.)	
oFont12    	:= 	tFontEx():New(oDocto,"Arial",12,12,.f.,.t.,.f.)	
oFont13    	:= 	tFontEx():New(oDocto,"Arial",13,13,.f.,.t.,.f.)	
oFont14    	:= 	tFontEx():New(oDocto,"Arial",14,14,.f.,.t.,.f.)	
oFont15    	:= 	tFontEx():New(oDocto,"Arial",15,15,.f.,.t.,.f.)	
oFont16    	:= 	tFontEx():New(oDocto,"Arial",16,16,.f.,.t.,.f.)	
oFont17    	:= 	tFontEx():New(oDocto,"Arial",17,17,.f.,.t.,.f.)	
oFont07N   	:= 	tFontEx():New(oDocto,"Arial",07,07,.t.,.t.,.f.)
oFont08N   	:= 	tFontEx():New(oDocto,"Arial",08,08,.t.,.t.,.f.)
oFont09N   	:= 	tFontEx():New(oDocto,"Arial",09,09,.t.,.t.,.f.)
oFont10N   	:= 	tFontEx():New(oDocto,"Arial",10,10,.t.,.t.,.f.)
oFont11N   	:= 	tFontEx():New(oDocto,"Arial",11,11,.t.,.t.,.f.)
oFont12N   	:= 	tFontEx():New(oDocto,"Arial",12,12,.t.,.t.,.f.)
oFont13N   	:= 	tFontEx():New(oDocto,"Arial",13,13,.t.,.t.,.f.)
oFont14N   	:= 	tFontEx():New(oDocto,"Arial",14,14,.t.,.t.,.f.)
oFont15N   	:= 	tFontEx():New(oDocto,"Arial",15,15,.t.,.t.,.f.)	
oFont16N   	:= 	tFontEx():New(oDocto,"Arial",16,16,.t.,.t.,.f.)	
oFont17N   	:= 	tFontEx():New(oDocto,"Arial",17,17,.t.,.t.,.f.)	

nLinIni		:=	0050	
nLinFim		:=	2935
nPula		:=	0040   
nCTmp1		:=	Int( ( nColFim - nColIni ) / 3 )

if !lSetCentury
	SET CENTURY ON
endif

oDocto:StartPage()

if	SE5->E5_BANCO == "001"
	cLogoTp := cStartPath + "001.bmp"   
	oDocto:SayBitmap( nLinIni - 0040 , nCTmp1 - 0300 , cLogoTp , 0250 , 0172 ) 		// 422 - 292 
elseif	SE5->E5_BANCO == "033"
	cLogoTp := cStartPath + "033.bmp"   
	oDocto:SayBitmap( nLinIni - 0040 , nCTmp1 - 0480 , cLogoTp , 0430 , 0160 )		// 537 - 200
elseif	SE5->E5_BANCO == "104"
	cLogoTp := cStartPath + "104.bmp"   
	oDocto:SayBitmap( nLinIni - 0025 , nCTmp1 - 0500 , cLogoTp , 0450 , 0112 )		// 700 - 173
elseif	SE5->E5_BANCO == "237"
	cLogoTp := cStartPath + "237.bmp"   
	oDocto:SayBitmap( nLinIni - 0040 , nCTmp1 - 0400 , cLogoTp , 0350 , 0162 )		// 640 - 298
elseif	SE5->E5_BANCO == "341"
	cLogoTp := cStartPath + "341.bmp"   
	oDocto:SayBitmap( nLinIni - 0045 , nCTmp1 - 0230 , cLogoTp , 0180 , 0180 )		// 300 - 300 
elseif	SE5->E5_BANCO == "399"
	cLogoTp := cStartPath + "399.bmp"   
	oDocto:SayBitmap( nLinIni + 0000 , nCTmp1 - 0325 , cLogoTp , 0275 , 0055 )		// 500 - 100
endif

nLinIni		:=	0050	

oDocto:Say( nLinIni 				, nCTmp1 	, "COMPROVANTE DE TRANSAวรO BANCมRIA" 					, oFont15N:oFont 	)

if	lTransf
	oDocto:Say( nLinIni + nPula	, nCTmp1 		, "Transfer๊ncia Entre Contas"		 					, oFont13:oFont 	)
elseif	SEA->(!Eof()) 
	if	SEA->EA_MODELO == "13" .and. Substr(Alltrim(SE2->E2_CODBAR),02,01) $ "2/3/4" 
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Concessionแria"					 					, oFont13:oFont 	)
	elseif	SEA->EA_MODELO == "13" 
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Imposto com C๓digo de Barras" 						, oFont13:oFont 	)
	elseif	SEA->EA_MODELO == "30"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Tํtulo do Mesmo Banco"			 					, oFont13:oFont 	)
	elseif	SEA->EA_MODELO == "31"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Tํtulo de Outro Banco"			 					, oFont13:oFont 	)
	elseif	SEA->EA_MODELO == "01"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Transfer๊ncia Entre Contas"		 					, oFont13:oFont 	)
	elseif	SEA->EA_MODELO == "03"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Emissใo de DOC"					 					, oFont13:oFont 	)
	elseif	SEA->EA_MODELO == "41"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Emissใo de TED"					 					, oFont13:oFont 	)
	elseif	SEA->EA_MODELO == "16"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Pagamento de DARF"				 					, oFont13:oFont 	)
	elseif	SEA->EA_MODELO == "17"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Pagamento de GPS"				 					, oFont13:oFont 	)
	else
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Pagamento de Tํtulo"				 					, oFont13:oFont 	)
	endif
elseif	( SE2->(FieldPos("E2_ZZMODPG")) <> 0 .and. !Empty(SE2->E2_ZZMODPG) )
	if	SEA->EA_MODELO == "13" .and. Substr(Alltrim(SE2->E2_CODBAR),02,01) $ "2/3/4" 
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Concessionแria"					 					, oFont13:oFont 	)
	elseif	SEA->EA_MODELO == "13" 
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Imposto com C๓digo de Barras" 						, oFont13:oFont 	)
	elseif	SE2->E2_ZZMODPG == "30"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Tํtulo do Mesmo Banco"			 					, oFont13:oFont 	)
	elseif	SE2->E2_ZZMODPG == "31"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Tํtulo de Outro Banco"			 					, oFont13:oFont 	)
	elseif	SE2->E2_ZZMODPG == "01"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Transfer๊ncia Entre Contas"		 					, oFont13:oFont 	)
	elseif	SE2->E2_ZZMODPG == "03"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Emissใo de DOC"					 					, oFont13:oFont 	)
	elseif	SE2->E2_ZZMODPG == "41"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Emissใo de TED"					 					, oFont13:oFont 	)
	elseif	SE2->E2_ZZMODPG == "16"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Pagamento de DARF"				 					, oFont13:oFont 	)
	elseif	SE2->E2_ZZMODPG == "17"
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Pagamento de GPS"				 					, oFont13:oFont 	)
	else
		oDocto:Say( nLinIni + nPula	, nCTmp1 	, "Pagamento de Tํtulo"				 					, oFont13:oFont 	)
	endif
else
	oDocto:Say( nLinIni + nPula	, nCTmp1 		, "Pagamento de Tํtulo"				 					, oFont13:oFont 	)
endif

nPula		+=	0040

oDocto:Say( nLinIni + nPula	, nCTmp1 			, "Data da Opera็ใo : "	+ DtoC(SE5->E5_DATA)			, oFont13:oFont 	)

nPula		+=	0040
nPula		+=	0060

nLinIni		+=	nPula	
nPula		:=	0040   
nCTmp1		:=	Int( ( nColFim - nColIni ) / 4 )

if	lTransf

	oDocto:Box( nLinIni + 0010 , nColIni , nLinIni	+ ( nPula * 3 ) , nColFim , "-6" )
	
	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Empresa : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, SM0->M0_NOMECOM     															, oFont09N:oFont )
	
	nLinIni		+=	nPula	
	
	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "CNPJ : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula + 0015		, nCTmp1 				, Alltrim(Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))						, oFont09N:oFont )

	nLinIni		+=	nPula	
	nLinIni		+=	nPula	

	oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 8 ) , nColFim , "-6" )

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Banco de Origem : " 															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, SE5->E5_BANCO      															, oFont09N:oFont )

	nLinIni		+=	nPula	

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Ag๊ncia de Origem : "	 													, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, SE5->E5_AGENCIA    															, oFont09N:oFont )

	nLinIni		+=	nPula	

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Conta de Origem : " 															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, SE5->E5_CONTA      															, oFont09N:oFont )

	nLinIni		+=	nPula	

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Valor : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, Alltrim(Transform(SE5->E5_VALOR,"@E 999,999,999.99"))    						, oFont09N:oFont )

	nLinIni		+=	nPula	

	cQuery	:=	" Select * "
	cQuery	+=	" From " + RetSqlName("SE5")
	cQuery	+=	" Where E5_FILIAL    = '" + SE5->E5_FILIAL									+ "' and "
	cQuery	+=		"   E5_DATA      = '" + DtoS(SE5->E5_DATA)								+ "' and "
	cQuery	+=		"   E5_DOCUMEN   = '" + PadR(SE5->E5_NUMCHEQ,TamSX3("E5_DOCUMEN")[1])	+ "' and "
	cQuery	+=		"   D_E_L_E_T_   = ' '                                                           "	

	TcQuery ChangeQuery(@cQuery) New Alias "TSE5"

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Banco de Destino : " 														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, TSE5->E5_BANCO      															, oFont09N:oFont )

	nLinIni		+=	nPula	

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Ag๊ncia de Destino : "	 													, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, TSE5->E5_AGENCIA    															, oFont09N:oFont )

	nLinIni		+=	nPula	

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Conta de Destino : " 														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, TSE5->E5_CONTA      															, oFont09N:oFont )

	nLinIni		+=	nPula	
	nLinIni		+=	nPula	

	oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 2 ) , nColFim , "-6" )

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Autentica็ใo : " 															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
//	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, iif( !Empty(SE5->E5_ZZCDAUT) , SE5->E5_ZZCDAUT , SE2->E2_ZZCDAUT )			, oFont09N:oFont )
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, SE5->E5_ZZCDAUT 																, oFont09N:oFont )

	TSE5->(dbclosearea())

else

	oDocto:Box( nLinIni + 0010 , nColIni , nLinIni	+ ( nPula * 6 ) , nColFim , "-6" )
	
	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Empresa : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, SM0->M0_NOMECOM     															, oFont09N:oFont )
	
	nLinIni		+=	nPula	
	
	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "CNPJ : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula + 0015		, nCTmp1 				, Alltrim(Transform(SM0->M0_CGC,"@R 99.999.999/9999-99"))						, oFont09N:oFont )

	nLinIni		+=	nPula	

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Banco : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, SE5->E5_BANCO + " - " + Upper(oObj:NomeBanco(SE5->E5_BANCO))  				, oFont09N:oFont )

	nLinIni		+=	nPula	

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Ag๊ncia : "				 													, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, SE5->E5_AGENCIA    															, oFont09N:oFont )

	nLinIni		+=	nPula	

	oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 		, "Conta : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
	oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 				, SE5->E5_CONTA      															, oFont09N:oFont )

	nLinIni		+=	nPula	
	nLinIni		+=	nPula	

	if	SEA->EA_MODELO $ "01/03/41" .or. ( SE2->(FieldPos("E2_ZZMODPG")) <> 0 .and. !Empty(SE2->E2_ZZMODPG) .and. SE2->E2_ZZMODPG $ "01/03/41" )

		if	SE2->(FieldPos("E2_ZZBENEF")) <> 0 .and. !Empty(SE2->E2_ZZBENEF)	
			oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 10 ) , nColFim , "-6" )
		else
			oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 09 ) , nColFim , "-6" )
		endif
		
		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Favorecido : "																, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, SA2->A2_NOME       															, oFont09N:oFont )

		nLinIni		+=	nPula	

		if	SE2->(FieldPos("E2_ZZBENEF")) <> 0 .and. !Empty(SE2->E2_ZZBENEF)	

			oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 , "Depositado a : "																, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
			oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 		, SE2->E2_ZZBENEF      															, oFont09N:oFont )
	
			nLinIni		+=	nPula	

		endif

		if	SE2->(FieldPos("E2_FORBCO")) <> 0 .and. !Empty(SE2->E2_FORBCO)	
			xTxt	:=	SE2->E2_FORBCO + " - " + Upper(oObj:NomeBanco(SE2->E2_FORBCO))	
		else
			xTxt	:=	SA2->A2_BANCO  + " - " + Upper(oObj:NomeBanco(SA2->A2_BANCO))
		endif

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Banco : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, xTxt																			, oFont09N:oFont )

		nLinIni		+=	nPula	

		if	SE2->(FieldPos("E2_FORAGE")) <> 0 .and. !Empty(SE2->E2_FORAGE)	
			xTxt	:=	Alltrim(SE2->E2_FORAGE)  + iif( !Empty(SE2->E2_FAGEDV) , "-" + Alltrim(SE2->E2_FAGEDV) , "" )  
		else
			xTxt	:=	Alltrim(SA2->A2_AGENCIA) + iif( !Empty(SA2->A2_DVAGE)  , "-" + Alltrim(SA2->A2_DVAGE) , "" )  
		endif

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Ag๊ncia : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, xTxt			    															, oFont09N:oFont )

		nLinIni		+=	nPula	

		if	SE2->(FieldPos("E2_FORCTA")) <> 0 .and. !Empty(SE2->E2_FORCTA)	  		
			if	Empty(SE2->E2_FCTADV)	  		
				xTxt	:=	Alltrim(SE2->E2_FORCTA)	
				xTxt	:=	Substr(xTxt,01,Len(xTxt) - 1) + "-" + Substr(xTxt,Len(xTxt))
			else
				xTxt	:=	Alltrim(SE2->E2_FORCTA)	+ "-" + Alltrim(SE2->E2_FCTADV) 
	        endif
		else
			if	Empty(SA2->A2_DVCTA)	  		
				xTxt	:=	Alltrim(SA2->A2_NUMCON) 
				xTxt	:=	Substr(xTxt,01,Len(xTxt) - 1) + "-" + Substr(xTxt,Len(xTxt))
			else
				xTxt	:=	Alltrim(SA2->A2_NUMCON) + "-" + Alltrim(SA2->A2_DVCTA)
			endif
		endif

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Conta : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, xTxt			     															, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Data do D้bito : "															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, DtoC(SE5->E5_DATA)                                     						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Data do Vencimento : "														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, DtoC(SE2->E2_VENCREA)                                    						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Valor do Tํtulo : "															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE2->E2_VALOR,"@E 999,999,999.99"))    						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Valor do Pagamento : "														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE5->E5_VALOR,"@E 999,999,999.99"))    						, oFont09N:oFont )

		nLinIni		+=	nPula	
		nLinIni		+=	nPula	

		oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 2 ) , nColFim , "-6" )

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Autentica็ใo : " 															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
//		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, iif( !Empty(SE5->E5_ZZCDAUT) , SE5->E5_ZZCDAUT , SE2->E2_ZZCDAUT )			, oFont09N:oFont )
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, SE5->E5_ZZCDAUT 																, oFont09N:oFont )

	elseif	SEA->EA_MODELO $ "30/31" .or. ( SE2->(FieldPos("E2_ZZMODPG")) <> 0 .and. !Empty(SE2->E2_ZZMODPG) .and. SE2->E2_ZZMODPG $ "30/31" )

		oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 11 ) , nColFim , "-6" )

		xBco		:=	xRetLinDig(SE2->E2_CODBAR,SEA->EA_MODELO)	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "C๓digo de Barras : " 														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, xBco																			, oFont09N:oFont )

		nLinIni		+=	nPula	

		xBco		:=	Substr(xBco,01,03)

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Banco Emissor : " 															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, xBco + " - " + Upper(oObj:NomeBanco(xBco))			  						, oFont09N:oFont )

		nLinIni		+=	nPula	
		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Favorecido : " 																, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, SA2->A2_NOME       															, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Data do D้bito : "															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, DtoC(SE5->E5_DATA)                                     						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Data do Vencimento : "														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, DtoC(SE2->E2_VENCREA)                                     					, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Valor do Tํtulo : "															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE2->E2_VALOR,"@E 999,999,999.99"))    						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Desconto : "																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE5->E5_VLDESCO,"@E 999,999,999.99")) 						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Juros : "																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE5->(E5_VLJUROS + E5_VLCORRE),"@E 999,999,999.99"))		, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Multa : "																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE5->E5_VLMULTA,"@E 999,999,999.99"))						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Valor do Pagamento : "														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE5->E5_VALOR,"@E 999,999,999.99"))    						, oFont09N:oFont )

		nLinIni		+=	nPula	
		nLinIni		+=	nPula	

		oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 2 ) , nColFim , "-6" )

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Autentica็ใo : " 															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
//		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, iif( !Empty(SE5->E5_ZZCDAUT) , SE5->E5_ZZCDAUT , SE2->E2_ZZCDAUT )			, oFont09N:oFont )
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, SE5->E5_ZZCDAUT																, oFont09N:oFont )

	elseif	SEA->EA_MODELO $ "13" .or. ( SE2->(FieldPos("E2_ZZMODPG")) <> 0 .and. !Empty(SE2->E2_ZZMODPG) .and. SE2->E2_ZZMODPG $ "13" )

		oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 10 ) , nColFim , "-6" )

		xBco		:=	xRetLinDig(SE2->E2_CODBAR,SEA->EA_MODELO)	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "C๓digo de Barras : " 														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, xBco																			, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Favorecido : " 																, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, SA2->A2_NOME       															, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Data do D้bito : "															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, DtoC(SE5->E5_DATA)                                     						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Data do Vencimento : "														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, DtoC(SE2->E2_VENCREA)                                    						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Valor do Tํtulo : "															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE2->E2_VALOR,"@E 999,999,999.99"))    						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Desconto : "																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE5->E5_VLDESCO,"@E 999,999,999.99")) 						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Juros : "																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE5->(E5_VLJUROS + E5_VLCORRE),"@E 999,999,999.99"))		, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Multa : "																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE5->E5_VLMULTA,"@E 999,999,999.99"))						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Valor do Pagamento : "														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE5->E5_VALOR,"@E 999,999,999.99"))    						, oFont09N:oFont )

		nLinIni		+=	nPula	
		nLinIni		+=	nPula	

		oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 2 ) , nColFim , "-6" )

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Autentica็ใo : " 															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
//		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, iif( !Empty(SE5->E5_ZZCDAUT) , SE5->E5_ZZCDAUT , SE2->E2_ZZCDAUT )			, oFont09N:oFont )
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, SE5->E5_ZZCDAUT 																, oFont09N:oFont )

	elseif	SEA->EA_MODELO == "16" .or. ( SE2->(FieldPos("E2_ZZMODPG")) <> 0 .and. !Empty(SE2->E2_ZZMODPG) .and. SE2->E2_ZZMODPG == "16" )

		oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 11 ) , nColFim , "-6" )

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Nome : " 																	, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, SA2->A2_NOME       															, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Perํodo de Apura็ใo : " 														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, DtoC(SE2->E2_ZZDTAP)                                     						, oFont09N:oFont )

		nLinIni		+=	nPula	      
		
		xCGC := iif( Empty(SE2->E2_ZZCNPJ) , SM0->M0_CGC , SE2->E2_ZZCNPJ )

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "CNPJ do Contribuinte : " 													, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula + 0015		, nCTmp1 			, Alltrim(Transform(xCGC,"@R 99.999.999/9999-99"))								, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "C๓digo da Receita : " 														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, SE2->E2_CODRET 	                                    						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "N๚mero de Refer๊ncia : " 													, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, SE2->E2_IDDARF 	                                    						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Data do Vencimento : "														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, DtoC(SE2->E2_ZZDTVC)                                     						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Valor do Principal : "														, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE2->E2_ZZVLPR,"@E 999,999,999.99"))   						, oFont09N:oFont )
                                                                                                                                                	
		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Valor da Multa : "															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE2->E2_ZZVLMT,"@E 999,999,999.99"))   						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Valor dos Juros e/ou Encargos : "											, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE2->E2_ZZVLJR,"@E 999,999,999.99"))   						, oFont09N:oFont )

		nLinIni		+=	nPula	

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Valor Total : "																, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, Alltrim(Transform(SE5->E5_VALOR,"@E 999,999,999.99"))  						, oFont09N:oFont )

		nLinIni		+=	nPula	
		nLinIni		+=	nPula	

		oDocto:Box( nLinIni + 0000 , nColIni , nLinIni	+ ( nPula * 2 ) , nColFim , "-6" )

		oDocto:SayAlign( nLinIni + nPula - 0002	, nCTmp1 - 0530 	, "Autentica็ใo : " 															, oFont09:oFont , nCTmp1 - nColIni - 0015 	, , , PAD_RIGHT	)
//		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, iif( !Empty(SE5->E5_ZZCDAUT) , SE5->E5_ZZCDAUT , SE2->E2_ZZCDAUT )			, oFont09N:oFont )
		oDocto:Say( nLinIni + nPula	+ 0015 		, nCTmp1 			, SE5->E5_ZZCDAUT 																, oFont09N:oFont )

	elseif	SEA->EA_MODELO == "17" .or. ( SE2->(FieldPos("E2_ZZMODPG")) <> 0 .and. !Empty(SE2->E2_ZZMODPG) .and. SE2->E2_ZZMODPG == "17" )

		// Em Desenvolvimento

	endif
endif

if	!Empty(cCodCPV)
	oDocto:Say( 3000 , 1000 , "COMPROVANTE " + cCodCPV , oFont12N:oFont )    		
endif

oDocto:EndPage()

if	lFim
	oDocto:Preview()
endif

if !lSetCentury
	SET CENTURY OFF
endif

cFilAnt := cFilTmp
cEmpAnt := cEmpTmp

RestArea(aAreaSM0)
RestArea(aArea)

Return ( .t. )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINCOMP   บAutor  ณMicrosiga           บ Data ณ  06/12/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetLinDig(cCodBar,cModelo)

Local cDig1    		
Local cDig2    		
Local cDig3    		
Local cDig4    		
Local cParte1  		
Local cParte2  		
Local cParte3  		
Local cParte4  		
Local cParte5  		
Local cLinhaDig		

if	cModelo == "13"
	cParte1  		:= 	SubStr(cCodBar,01,11) 
	cDig1    		:= 	Mod10(cParte1)
	cParte2  		:= 	SubStr(cCodBar,12,11) 
	cDig2    		:= 	Mod10(cParte2)
	cParte3  		:= 	SubStr(cCodBar,23,11) 
	cDig3    		:= 	Mod10(cParte3)
	cParte4  		:= 	SubStr(cCodBar,34,11)
	cDig4    		:= 	Mod10(cParte4)
	cLinhaDig		:= 	cParte1 + cDig1 + " " + cParte2 + cDig2 + " " + cParte3 + cDig3 + " " + cParte4 + cDig4
else
	cParte1  		:= 	SubStr(cCodBar,01,04) + SubStr(cCodBar,20,05)
	cDig1    		:= 	Mod10(cParte1)
	cParte2  		:= 	SubStr(cCodBar,25,10) 
	cDig2    		:= 	Mod10(cParte2)
	cParte3  		:= 	SubStr(cCodBar,35,10) 
	cDig3    		:= 	Mod10(cParte3)
	cParte4  		:= 	SubStr(cCodBar,05,01)
	cParte5  		:= 	StrZero(Val(SubStr(cCodBar,06,04)),04) + StrZero(Val(SubStr(cCodBar,10,10)),10)
	cLinhaDig		:= 	SubStr(cParte1,01,05) + "." + SubStr(cParte1,06) + cDig1 + " " + ;
						SubStr(cParte2,01,05) + "." + SubStr(cParte2,06) + cDig2 + " " + ;
						SubStr(cParte3,01,05) + "." + SubStr(cParte3,06) + cDig3 + " " + ;
						cParte4 + " " + cParte5                                                        
endif

Return ( cLinhaDig ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบRotina    ณMod10     บAutor  ณClaudio D. de Souza บ Data ณ  14/12/01   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCalcula o digito verificador de uma sequencia de numeros    บฑฑ
ฑฑบ          ณbaseando-se no modulo 10. Utilizado para verificar o digito บฑฑ
ฑฑบ          ณem linhas digitaveis e codigo de barras de concessionarias  บฑฑ
ฑฑบ          ณde servicos publicos                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function Mod10( cNum )

Local cNumAux
Local nFor    	:= 	0
Local nTot    	:= 	0

If 	Len(cNum) % 2 <> 0
	cNum := "0" + cNum
EndIf

For nFor := 1 To Len(cNum)
	if 	nFor % 2 == 0
		cNumAux := StrZero(2 * Val(SubStr(cNum,nFor,1)), 2)
	else
		cNumAux := StrZero(Val(SubStr(cNum,nFor,1))    , 2)
	endif
	nTot += ( Val(Left(cNumAux,1)) + Val(Right(cNumAux,1)) )
Next

nTot :=	nTot % 10
nTot :=	iif( nTot # 0, 10 - nTot, nTot )

Return ( StrZero(nTot,1) )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINCOMP   บAutor  ณMicrosiga           บ Data ณ  06/15/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function fRetLinDig(cCodBar,cModelo)

Return ( xRetLinDig(cCodBar,cModelo) )
