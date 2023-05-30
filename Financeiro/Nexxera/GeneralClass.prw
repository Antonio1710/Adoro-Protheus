#include "topconn.ch"    	    		 		  						
#include "protheus.ch"   	
#include "msobject.ch"    		        		   			
   			  	  	
#define CSSBOTAO	"QPushButton { color: #024670 ; " +;
					"    border-image: url(rpo:fwstd_btn_nml.png) 3 3 3 3 stretch; "+;            	
					"    border-top-width: 3px    ; " +;
					"    border-left-width: 3px   ; " +;
					"    border-right-width: 3px  ; " +;
					"    border-bottom-width: 3px } " +;
					"QPushButton:pressed {	color: #FFFFFF; "+;
					"    border-image: url(rpo:fwstd_btn_prd.png) 3 3 3 3 stretch; "+;
					"    border-top-width: 3px    ; " +;
					"    border-left-width: 3px   ; " +;
					"    border-right-width: 3px  ; " +;
					"    border-bottom-width: 3px }"
                                  	
User Function xGeneralClass() ; Return     			 		

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบClasse    ClasseGeral  บAutor  ณAlexandre Zapponi  oบ Data ณ  16/11/16   บฑฑ
ฑฑฬออออออออออุออออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDescri็ใo ณClasse para retornar dados gerais                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Class GeneralClass      		

	Method New() Constructor      

	Method TipoRel()   
	Method CodBanco() 
	Method NoAccent(cTexto)   		
	Method NomeBanco(cBanco)	
	Method MyOpenSM0(lShared) 
	Method SemanasDoAno(nAno) 
	Method SemanasDoMes(dData) 
	Method ConvertUnicode(cTexto)   		
	Method LeArqRat(cArqRat,nTamCV4)
	Method PosicionaSM0(xEmp,xFil,xCNPJ)        
	Method ReadArq(cFile,lArq,lAlltrim,lString)
	Method TotHora(dDtIni,cHrIni,dDtFim,cHrFim)   
	Method FinaMsg(cCaption,cTitle,bAction,nCor)
	Method ChecaPar(cPar,cDescric,cConteud,cTipo)         
	Method EscEmpresa(aRet,lTodas,lSoPerm,lSoEmp)
	Method RetNomeTabela(lShared,xEmp,xRet,xTab,lSeek)                     
	Method RetTipoTabela(lShared,xEmp,xRet,xTab,lSeek)    
	Method DispMail(cPara,cHtml,cAssunto,cDe,aAnexos,cCc,cBcc)                 
	Method PutParOutEmp(lShared,xEmp,xFil,xRet,xPar,lSeek,xTipo)
	Method TelaMail(cPara,cCC,cCCO,cTexto,lTexto,lSubject,cSubject,lEdit) 	
	Method ChkParOutEmp(lShared,xEmp,xFil,xRet,xPar,lSeek,xTipo,lAlert,lFull)     
	Method Coalesce(xPar01,xPar02,xPar03,xPar04,xPar05,xPar06,xPar07,xPar08,xPar09,xPar10)
	Method EnviaMail(cPara,cCC,cCCO,cHtml,cSubject,cFrom,cUser,cSMTP,nSMTPPort,cPass,nTime,lSSL,cReplyTo,aAnexos,lAlert,lAut,lTLS)
	Method PutSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3,cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)
	Method NewSx1(cGrupo,cOrdem,cPergunt,cPerSpa,cPerEng,cVar,cTipo,nTamanho,nDecimal,nPresel,cGSC,cValid,cF3,cGrpSxg,cPyme,cVar01,cDef01,cDefSpa1,cDefEng1,cCnt01,cDef02,cDefSpa2,cDefEng2,cDef03,cDefSpa3,cDefEng3,cDef04,cDefSpa4,cDefEng4,cDef05,cDefSpa5,cDefEng5,aHelpPor,aHelpEng,aHelpSpa,cHelp)

EndClass

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณM้todo Construtor                                             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method New() Class GeneralClass

Return Self

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os rateios por centro de custo                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method FinaMsg(cCaption,cTitle,bAction,nCor) Class GeneralClass

Local oSay
Local oDlg
Local oFont
Local nWidth        
Local nTamanho		:=	iif( cTitle == Nil , Len( cCaption ) , Max( Len( cCaption ) , Len( cTitle ) ) ) + 18

Default cCaption	:=	"Aguarde por favor..."
Default bAction		:= 	{ || Inkey( 1 ) }     
Default cTitle		:=	"Mensagem"
Default nCor		:=	0

Define Font oFont Name "Tahoma" Size 07,14 Bold

Define MsDialog oDlg Title cTitle From 000,000 To 004,nTamanho 
oDlg:SetFont(oFont)
nWidth := oDlg:nRight - oDlg:nLeft              
@ 008 , 006 Bitmap Resource "BI_TOTVS_LOGO_61X27.PNG" /*Read*/ Of oDlg Pixel Size 30,14 Adjust When .f. NoBorder 
@ 011 , 055 Say oSay Var cCaption of oDlg Font oFont Pixel Color nCor
oDlg:bStart	:= 	{ || Eval( bAction, oDlg ) , oDlg:End() , ProcessMessages() }
oDlg:cMsg	:=	cCaption
Activate MsDialog oDlg Centered

oFont:End()

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os rateios por centro de custo                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method LeArqRat(cArqRat,nTamCV4) Class GeneralClass

Local aRet		:=	{}
Local aArea		:=	GetArea()
Local cChave	:=	PadR( Alltrim(cArqRat) , iif( ValType(nTamCV4) == "N" , nTamCV4 , Len(CriaVar("E5_ARQRAT",.f.)) ) )

dbSelectArea("CV4")
dbSetOrder(1)
dbSeek(cChave)   
do while CV4->(!Eof()) .and. Alltrim(CV4->CV4_FILIAL + DtoS(CV4->CV4_DTSEQ) + CV4->CV4_SEQUEN) == Alltrim(cChave)
	aAdd( aRet , { 	CV4->CV4_DEBITO 	, ;
					CV4->CV4_CREDIT 	, ;
					CV4->CV4_CCD 		, ;
					CV4->CV4_CCC 		, ;
					CV4->CV4_ITEMD 		, ;
					CV4->CV4_ITEMC 		, ;
					CV4->CV4_CLVLDB 	, ;
					CV4->CV4_CLVLCR 	, ;
					CV4->CV4_CCC 		, ;
					CV4->CV4_CCC 		, ;
					CV4->CV4_VALOR 		, ;
					CV4->CV4_PERCEN 	} )
	dbSelectArea("CV4")
	dbSkip()
enddo	

RestArea(aArea) 

Return ( aRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณBusca as empresas do relatorio                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method EscEmpresa(aRet,lTodas,lSoPerm,lSoEmp,lAdm,lFilEmp) Class GeneralClass

Local aSalvAmb		:= 	GetArea()
Local aSalvSM0  	:= 	SM0->(GetArea())
Local aEmp			:=	FwEmpLoad(.f.)  		// .t. - Todas  .f. - so o acesso do usuario 	// Array com: [1] = C๓digo da empresa[2] = Nome da empresa[3] = C๓digo da filial[4] = Nome da filial
Local lOk       	:= 	.f.
Local oNo       	:= 	LoadBitmap( GetResources(), "LBNO" )
Local oOk       	:= 	LoadBitmap( GetResources(), "LBOK" )   
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U"

Local oDlg, oRep, oButAll, oButDes, oButInv, oButPrc, oButCan

Default aRet      	:= 	{}
Default lTodas      := 	.t.
Default lSoEmp      := 	.f.
Default lSoPerm     := 	.f.
Default lFilEmp		:=	.t.
Default lAdm		:=	iif( lIsBlind , .t. , FwIsAdmin(RetCodUsr()) )

SM0->(dbsetorder(1))
SM0->(dbgotop())       

if	lTodas .or. lAdm
	if	lIsBlind			
		SM0->(dbEval( { || aAdd( aRet , { .t. , AllTrim(SM0->M0_CODIGO) , AllTrim(SM0->M0_CODFIL) , SM0->M0_NOME , AllTrim(SM0->M0_FILIAL) , SM0->(Recno()) } ) } ,, { || SM0->(!Eof()) } ) )  
	else
		FwMsgRun( Nil , { || SM0->(dbEval( { || aAdd( aRet , { .f. , AllTrim(SM0->M0_CODIGO) , AllTrim(SM0->M0_CODFIL) , SM0->M0_NOME , AllTrim(SM0->M0_FILIAL) , SM0->(Recno()) } ) } ,, { || SM0->(!Eof()) } ) ) } , 'Processando' , "Carregando dados ..." )
	endif
else
	SM0->(dbgotop())
	SM0->(dbsetorder(1))
	do while SM0->(!Eof())
		if	SM0->(deleted())
			SM0->(dbskip())
			Loop
		endif
		if !Empty(Alltrim(SM0->M0_CODIGO))
			if	lSoPerm	  
				if	aScan( aEmp , { |x| AllTrim(x[2]) == AllTrim(SM0->M0_CODIGO) } ) == 0 
					SM0->(dbSkip())					  
					Loop
				else
					if	aScan( aEmp , { |x| AllTrim(x[2]) == AllTrim(SM0->M0_CODIGO) .and. AllTrim(x[3]) == AllTrim(SM0->M0_CODFIL) } ) == 0 
						SM0->(dbSkip())					  
						Loop
        			endif
      			endif
      		endif     
      		if	lFilEmp
      			if AllTrim(cEmpAnt) <> AllTrim(SM0->M0_CODIGO)
					SM0->(dbSkip())					  
					Loop
				endif      		
			endif      		
			if	lSoEmp	
				nPos := aScan( aRet, { |x| AllTrim(x[2]) == AllTrim(SM0->M0_CODIGO) } )  
      		elseif	lFilEmp
				nPos := aScan( aRet, { |x| AllTrim(x[2]) == AllTrim(SM0->M0_CODIGO) .and. AllTrim(x[3]) == AllTrim(SM0->M0_CODFIL) } )  
			else
				nPos := 0
		    endif
			if	nPos == 0 
				aAdd( aRet , { .f. , AllTrim(SM0->M0_CODIGO) , AllTrim(SM0->M0_CODFIL) , SM0->M0_NOME , AllTrim(SM0->M0_FILIAL) , SM0->(Recno()) } )
			endif			
		endif
		SM0->(dbSkip())     
	enddo
endif
	
RestArea( aSalvSM0 )

if	!lIsBlind
	Define MsDialog oDlg Title "Empresas / Filiais" From 000,000 To 450,550 Pixel
	
//	oDlg:cToolTip	:= 	"Tela para M๚ltiplas Sele็๕es de Empresas/Filiais"
	oDlg:cTitle   	:= 	"Selecione a(s) Empresa(s) e Filial(ais)"
	
	oRep := TcBrowse():New(010,010,258,195,,,,oDlg,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)
	
	oRep:AddColumn( TcColumn():New( "  "    	   	,{ || iif(aRet[oRep:nAt,01],oOk,oNo) 	}	, "@!"  		,,,"CENTER"	,015,.t.,.f.,,,,.f.,) )
	
	oRep:AddColumn( TcColumn():New( "Empresa"		,{ || aRet[oRep:nAt,02]  				}	, "@!"			,,,"CENTER"	,030,.f.,.f.,,,,.f.,) )     					
	oRep:AddColumn( TcColumn():New( "Filial"		,{ || aRet[oRep:nAt,03]  				}	, "@!"			,,,"CENTER"	,030,.f.,.f.,,,,.f.,) )     					
	oRep:AddColumn( TcColumn():New( "Nome Empresa" 	,{ || aRet[oRep:nAt,04]  				}	, "@!"			,,,"LEFT"	,070,.f.,.f.,,,,.f.,) )     					
	oRep:AddColumn( TcColumn():New( "Nome Filial"  	,{ || aRet[oRep:nAt,05]  				}	, "@!"			,,,"LEFT"	,070,.f.,.f.,,,,.f.,) )     					
	
	oRep:SetArray(aRet)              			
	oRep:bLDblClick	:= { || aRet[oRep:nAt,01] := !aRet[oRep:nAt,01] }        
	
	@ 210,010 Button oButAll   	Prompt "Marcar Todos"  		Size 047,012 Pixel Action Eval({ || aEval( aRet , { |x| x[01] := .t. 		} )	})				Of oDlg
	oButAll:SetCss( CSSBOTAO )
	@ 210,062 Button oButDes   	Prompt "Desmarcar Todos" 	Size 048,012 Pixel Action Eval({ || aEval( aRet , { |x| x[01] := .f. 		} )	})				Of oDlg
	oButDes:SetCss( CSSBOTAO )
	@ 210,115 Button oButInv   	Prompt "Inverter" 			Size 047,012 Pixel Action Eval({ || aEval( aRet , { |x| x[01] := !x[01] 	} )	})				Of oDlg
	oButInv:SetCss( CSSBOTAO )
	@ 210,167 Button oButPrc   	Prompt "Processar" 			Size 048,012 Pixel Action Eval({ || lOk := .t. , oDlg:End()						})				Of oDlg
	oButPrc:SetCss( CSSBOTAO )
	@ 210,220 Button oButCan   	Prompt "Cancelar" 			Size 048,012 Pixel Action Eval({ || lOk := .f. , oDlg:End()						})				Of oDlg
	oButCan:SetCss( CSSBOTAO )
	
	Activate MsDialog  oDlg Centered
endif
	
RestArea( aSalvAmb )

Return ( lOk )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณInforma o tipo do relat๓rio                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method TipoRel() Class GeneralClass

Local nRadio	:=	001
Local oRadio  	:=	Nil
Local oDlgAlt	:=	Nil

Define MsDialog oDlgAlt From  000,000 To 107,292 Title "Informe" Pixel Style 128
@ 005,007 To 035,140 Of oDlgAlt  Pixel	
@ 011,010 Radio oRadio Var nRadio Items "Relat๓rio por Abas" , "Relat๓rio por Lista" 3D Size 100,010 Of oDlgAlt Pixel
Define sButton From 038,115 Type 1 Enable Of oDlgAlt Action ( oDlgAlt:End() )
Activate MsDialog oDlgAlt Centered

Return ( nRadio )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณLeitura de arquivo texto                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method ReadArq( cFile , lArq , lAlltrim , lString ) Class GeneralClass

Local aTmp			:= 	{}
Local cLinha		:= 	''

Default lString		:=	.f.
Default lAlltrim	:=	.f.
 
if	FT_FUSE(cFile) == -1
	lArq := .f.
else
	lArq := .t.  
	FT_FGOTOP() 
	do while !FT_FEOF() 
		if	lString
			cLinha += iif( lAlltrim , Alltrim(FT_FREADLN()) , FT_FREADLN() )
		else
			cLinha := iif( lAlltrim , Alltrim(FT_FREADLN()) , FT_FREADLN() )
	 		if !Empty( cLinha )
		 	    aAdd( aTmp , cLinha )
			endif		  
		endif	
		FT_FSKIP()   
	enddo
	FT_FUSE()
endif
 
Return( iif( lString , cLinha , aTmp ) )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณCria os parametros da rotina                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method ChecaPar(cPar,cDescric,cConteud,cTipo) Class GeneralClass

cPar := PadR(cPar,Len(SX6->X6_VAR))
	
SX6->(dbsetorder(1))

if !SX6->(dbseek( Space(Len(SX6->X6_FIL)) + cPar , .f. ))
	RecLock("SX6",.t.)
		SX6->X6_FIL		:=	Space(Len(SX6->X6_FIL))
		SX6->X6_VAR		:=	cPar
		SX6->X6_TIPO	:=	cTipo
		SX6->X6_DESCRIC	:=	cDescric
		SX6->X6_CONTEUD	:=	cConteud
		SX6->X6_CONTSPA	:=	cConteud
		SX6->X6_CONTENG	:=	cConteud
		SX6->X6_PROPRI	:=	"U"
	MsUnlock("SX6")
endif			

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบ Programa ณ MyOpenSM0บ Autor ณ                    บ Data ณ  30/07/2013 บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบ Descricaoณ Funcao de processamento abertura do SM0 modo exclusivo     ณฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method MyOpenSM0(lShared) Class GeneralClass

Local nLoop 	:= 	0
Local lOpen 	:= 	.f.
Local lIsBlind	:=	IsBlind() .or. Type("__LocalDriver") == "U"

For nLoop := 01 To 20
	dbUseArea( .t. , Nil , "SIGAMAT.EMP" , "SM0" , lShared , .f. )
	if !Empty( Select( "SM0" ) )
		lOpen := .t.
		dbSetIndex( "SIGAMAT.IND" )
		Exit
	endif
	Sleep( 500 )
Next nLoop

if !lOpen
	if	lIsBlind		
		ConOut( "Nใo foi possํvel a abertura da tabela " + iif( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ) )
	else
		MsgStop( "Nใo foi possํvel a abertura da tabela " + iif( lShared, "de empresas (SM0).", "de empresas (SM0) de forma exclusiva." ) , "ATENวรO" )
	endif
endif

Return ( lOpen ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณMatodo para posicionar o SM0                                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method PosicionaSM0(xEmp,xFil,xCNPJ) Class GeneralClass

Local lRet		:=	.f.

Default xEmp	:=	""
Default xFil	:=	""
Default xCNPJ	:=	""

SM0->(dbgotop())
do while SM0->(!Eof())
	if	Alltrim(SM0->M0_CODIGO) == Alltrim(xEmp) 
		if	Empty(xFil) .and. Empty(xCNPJ) 
			lRet := .t.
			Exit	
		elseif	!Empty(xFil) .and. Upper(Alltrim(SM0->M0_CODFIL)) == Upper(Alltrim(xFil)) 
			lRet := .t.
			Exit	
		elseif	!Empty(xCNPJ) .and. Upper(Alltrim(SM0->M0_CGC)) == Upper(Alltrim(xCNPJ)) 
			lRet := .t.
			Exit	
		endif
	endif
	SM0->(dbskip())
enddo

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna o nome da tabela lendo diretamente o SX2              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method RetNomeTabela(lShared,xEmp,xRet,xTab,lSeek) Class GeneralClass

Local nLoop			:= 	0
Local lOpen			:= 	.f.
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U"      

Default xRet		:=	""
Default xTab 		:=	""
Default lSeek  		:=	.f. 
Default lShared		:=	.t. 

if 	Select("XSX2") > 0
	XSX2->(dbclosearea())
endif

For nLoop := 1 To 20
	dbUseArea( .t. , Nil , "SX2" + xEmp + "0" , "XSX2" , lShared , .f. )
	If !Empty( Select( "XSX2" ) )
		lOpen := .t.
		Exit
	endif
	Sleep( 500 )
Next nLoop

if	lOpen
	if	lSeek
		XSX2->(dbsetorder(1))
		if	XSX2->(dbseek( xTab , .f. ))
			xRet := Alltrim(XSX2->X2_ARQUIVO)
		endif
	endif	
	if	Empty(xRet)
		XSX2->(dbgotop())
		do while XSX2->(!Eof())
			if	Upper(Alltrim(XSX2->X2_CHAVE)) == xTab
				xRet := Alltrim(XSX2->X2_ARQUIVO)
				Exit
			endif
	    	XSX2->(dbskip())
		enddo
		XSX2->(dbclosearea())
	endif
	if	Empty(xRet)
		MsgStop( "Nใo foi possํvel encontrar a tabela selecionada" , "ATENวรO" )
		lOpen := .f.		
	endif
else
	if	lIsBlind
		ConOut( "Nใo foi possํvel a abertura da tabela SX2" )
	else
		MsgStop( "Nใo foi possํvel a abertura da tabela SX2" , "ATENวรO" )
	endif
endif

if 	Select("XSX2") > 0
	XSX2->(dbclosearea())
endif

Return ( lOpen )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna o nome da tabela lendo diretamente o SX2              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method RetTipoTabela(lShared,xEmp,xRet,xTab,lSeek) Class GeneralClass

Local nLoop			:= 	0
Local lOpen			:= 	.f.
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U"      

Default xRet		:=	""
Default xTab 		:=	""
Default lSeek  		:=	.f. 
Default lShared		:=	.t. 

if 	Select("XSX2") > 0
	XSX2->(dbclosearea())
endif

For nLoop := 1 To 20
	dbUseArea( .t. , , "SX2" + xEmp + "0" , "XSX2" , lShared , .f. )
	If !Empty( Select( "XSX2" ) )
		lOpen := .t.
		Exit
	endif
	Sleep( 500 )
Next nLoop

if	lOpen
	if	lSeek
		XSX2->(dbsetorder(1))
		if	XSX2->(dbseek( xTab , .f. ))
			xRet := XSX2->X2_MODO
		endif
	endif	
	if	Empty(xRet)
		XSX2->(dbgotop())
		do while XSX2->(!Eof())
			if	Upper(Alltrim(XSX2->X2_CHAVE)) == xTab
				xRet := XSX2->X2_MODO
				Exit
			endif
	    	XSX2->(dbskip())
		enddo
		XSX2->(dbclosearea())
	endif
	if	Empty(xRet)
		MsgStop( "Nใo foi possํvel encontrar a tabela selecionada" , "ATENวรO" )
		lOpen := .f.		
	endif
else
	if	lIsBlind
		ConOut( "Nใo foi possํvel a abertura da tabela SX2" )
	else
		MsgStop( "Nใo foi possํvel a abertura da tabela SX2" , "ATENวรO" )
	endif
endif

if 	Select("XSX2") > 0
	XSX2->(dbclosearea())
endif

Return ( lOpen )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณTira os acentos da string                                     บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method NoAccent(cTexto) Class GeneralClass      

Default cTexto	:=	""

cTexto 	:= 	StrTran(cTexto,"แ","a")
cTexto 	:= 	StrTran(cTexto,"โ","a") 
cTexto 	:= 	StrTran(cTexto,"ใ","a") 
cTexto 	:= 	StrTran(cTexto,"เ","a") 
cTexto 	:= 	StrTran(cTexto,"ไ","a") 
cTexto 	:= 	StrTran(cTexto,"้","e")
cTexto 	:= 	StrTran(cTexto,"๊","e") 
cTexto 	:= 	StrTran(cTexto,"๋","e") 
cTexto 	:= 	StrTran(cTexto,"ํ","i")
cTexto 	:= 	StrTran(cTexto,"๏","i")
cTexto 	:= 	StrTran(cTexto,"๓","o")
cTexto 	:= 	StrTran(cTexto,"๔","o") 
cTexto 	:= 	StrTran(cTexto,"๕","o") 
cTexto 	:= 	StrTran(cTexto,"๖","o") 
cTexto 	:= 	StrTran(cTexto,"๚","u")
cTexto 	:= 	StrTran(cTexto,"ü","u") 

cTexto 	:= 	StrTran(cTexto,"ม","A")
cTexto 	:= 	StrTran(cTexto,"ย","A")
cTexto 	:= 	StrTran(cTexto,"ร","A")
cTexto 	:= 	StrTran(cTexto,"ภ","A")
cTexto 	:= 	StrTran(cTexto,"ฤ","A")
cTexto 	:= 	StrTran(cTexto,"ษ","E")
cTexto 	:= 	StrTran(cTexto,"ส","E")
cTexto 	:= 	StrTran(cTexto,"ห","E")
cTexto 	:= 	StrTran(cTexto,"อ","I")
cTexto 	:= 	StrTran(cTexto,"ฯ","I")
cTexto 	:= 	StrTran(cTexto,"ำ","O")
cTexto 	:= 	StrTran(cTexto,"ิ","O")
cTexto 	:= 	StrTran(cTexto,"ี","O")
cTexto 	:= 	StrTran(cTexto,"ึ","O")
cTexto 	:= 	StrTran(cTexto,"ฺ","U")
cTexto 	:= 	StrTran(cTexto,"Ü","U")

cTexto 	:= 	StrTran(cTexto,"ว","C")
cTexto 	:= 	StrTran(cTexto,"็","c")            
cTexto 	:= 	StrTran(cTexto,"ด"," ")    
cTexto 	:= 	StrTran(cTexto,"ฐ","o")    
cTexto 	:= 	StrTran(cTexto,"บ","o")    
cTexto 	:= 	StrTran(cTexto,"ช","a")    
        
Return ( cTexto )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณConverte os c๓digos em Unicode para acentuados                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method ConvertUnicode(cTexto) Class GeneralClass      

Default cTexto	:=	""

cTexto	:= 	StrTran(cTexto,"\u00e1","แ")
cTexto 	:= 	StrTran(cTexto,"\u00e0","เ")
cTexto 	:= 	StrTran(cTexto,"\u00e2","โ")
cTexto 	:= 	StrTran(cTexto,"\u00e3","ใ")
cTexto 	:= 	StrTran(cTexto,"\u00e4","ไ")
cTexto 	:= 	StrTran(cTexto,"\u00c1","ม")
cTexto 	:= 	StrTran(cTexto,"\u00c0","ภ")
cTexto 	:= 	StrTran(cTexto,"\u00c2","ย")
cTexto 	:= 	StrTran(cTexto,"\u00c3","ร")
cTexto 	:= 	StrTran(cTexto,"\u00c4","ฤ")
cTexto 	:= 	StrTran(cTexto,"\u00e9","้")
cTexto 	:= 	StrTran(cTexto,"\u00e8","่")
cTexto 	:= 	StrTran(cTexto,"\u00ea","๊")
cTexto 	:= 	StrTran(cTexto,"\u00ea","๊")
cTexto 	:= 	StrTran(cTexto,"\u00c9","ษ")
cTexto 	:= 	StrTran(cTexto,"\u00c8","ศ")
cTexto 	:= 	StrTran(cTexto,"\u00ca","ส")
cTexto 	:= 	StrTran(cTexto,"\u00cb","ห")
cTexto 	:= 	StrTran(cTexto,"\u00ed","ํ")
cTexto 	:= 	StrTran(cTexto,"\u00ec","์")
cTexto 	:= 	StrTran(cTexto,"\u00ee","๎")
cTexto 	:= 	StrTran(cTexto,"\u00ef","๏")
cTexto 	:= 	StrTran(cTexto,"\u00cd","อ")
cTexto 	:= 	StrTran(cTexto,"\u00cc","ฬ")
cTexto 	:= 	StrTran(cTexto,"\u00ce","ฮ")
cTexto 	:= 	StrTran(cTexto,"\u00cf","ฯ")
cTexto 	:= 	StrTran(cTexto,"\u00f3","๓")
cTexto 	:= 	StrTran(cTexto,"\u00f2","๒")
cTexto 	:= 	StrTran(cTexto,"\u00f4","๔")
cTexto 	:= 	StrTran(cTexto,"\u00f5","๕")
cTexto 	:= 	StrTran(cTexto,"\u00f6","๖")
cTexto 	:= 	StrTran(cTexto,"\u00d3","ำ")
cTexto 	:= 	StrTran(cTexto,"\u00d2","า")
cTexto 	:= 	StrTran(cTexto,"\u00d4","ิ")
cTexto 	:= 	StrTran(cTexto,"\u00d5","ี")
cTexto 	:= 	StrTran(cTexto,"\u00d6","ึ")
cTexto 	:= 	StrTran(cTexto,"\u00fa","๚")
cTexto 	:= 	StrTran(cTexto,"\u00f9","๙")
cTexto 	:= 	StrTran(cTexto,"\u00fb","๛")
cTexto 	:= 	StrTran(cTexto,"\u00fc","ü")
cTexto 	:= 	StrTran(cTexto,"\u00da","ฺ")
cTexto 	:= 	StrTran(cTexto,"\u00d9","ู")
cTexto 	:= 	StrTran(cTexto,"\u00db","Û")
cTexto 	:= 	StrTran(cTexto,"\u00e7","็")
cTexto 	:= 	StrTran(cTexto,"\u00c7","ว")
cTexto 	:= 	StrTran(cTexto,"\u00f1","๑")
cTexto 	:= 	StrTran(cTexto,"\u00d1","ั")
cTexto 	:= 	StrTran(cTexto,"\u0026","&")
cTexto 	:= 	StrTran(cTexto,"\u0027","'")

Return ( cTexto )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna o total de horas                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method TotHora( dDtIni, cHrIni, dDtFim, cHrFim ) Class GeneralClass

Local nMult		:=	0
Local nHoras   	:= 	Val(SubStr(StrTran(cHrFim,":",""),01,02)) - Val(SubStr(StrTran(cHrIni,":",""),01,02))
Local nMinutos 	:= 	Val(SubStr(StrTran(cHrFim,":",""),03,02)) - Val(SubStr(StrTran(cHrIni,":",""),03,02))
Local nDias    	:= 	dDtFim - dDtIni
Local cTotHora	:= 	"00:00"

if	nMinutos < 0 
	nHoras 		-=	01
	nMinutos 	+= 	60
endif

if	nHoras < 0 
	nDias 		-=	01
	nHoras 		+= 	24
endif

if 	nDias >= 0
	nMult 		:=	( ( 24 * nDias ) + nHoras ) 
	nMult		:=	Len(Alltrim(Str(nMult)))
	nMult		:=	Max(2,nMult)
	cTotHora	:= 	StrZero( ( ( 24 * nDias ) + nHoras ) , nMult )
	cTotHora 	+= 	":"
	cTotHora 	+= 	StrZero( nMinutos, 2 )
endif

Return ( cTotHora )   

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna para envio de email                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method EnviaMail(	cPara			, ;
					cCC				, ;
					cCCO			, ;
					cHtml			, ;
					cSubject		, ;
					cFrom			, ;
					cUser			, ;
					cSMTP			, ;
					nSMTPPort		, ;
					cPass			, ;
					nTime			, ;
					lSSL			, ;
					cReplyTo		, ;
					aAnexos			, ;
					lAlert			, ;
					lAut			, ;
					lTLS			) Class GeneralClass

Local t
Local lRet			:=	.f.
Local cPop   		:= 	""                  						// Endereco do servidor POP3
Local nPOPPort   	:= 	000                                 		// Porta do servidor POP
Local oMail			:=	tMailManager():New()
Local oMessage 		:= 	tMailMessage():New()              

Default lSSL		:=	GetMv("MV_RELSSL")                        	// Conexใo SSL
Default lTLS		:=	GetMv("MV_RELTLS")                        	// Conexใo TLS
Default lAut		:=	GetMv("MV_RELAUTH")                        	// Servidor Autenticado

Default cFrom		:=	GetMv("MV_RELFROM")                         // Conta de envio
Default nTime 		:= 	GetMv("MV_RELTIME")    						// Timeout SMTP
Default nSMTPPort	:= 	GetMv("MV_PORSMTP")             		    // Porta do servidor SMTP		GetMv("MV_GCPPORT")

Default cPass     	:= 	Alltrim(GetMv("MV_RELPSW"))					// Senha do usuario
Default cSMTP  		:= 	Alltrim(GetMv("MV_RELSERV"))				// Endereco do servidor SMTP
Default cUser      	:= 	Alltrim(GetMv("MV_RELACNT"))        		// Usuario que ira realizar a autenticacao

Default lAlert		:=	.t.
Default aAnexos		:=	{}
Default cReplyTo	:=	""                                                  
Default cSubject	:=	""

if	":" $ cSMTP
	nSMTPPort		:=	Val( Substr( cSMTP, At( ":" , cSMTP ) + 1 ) )
	cSMTP 			:= 	Substr( cSMTP , 1 , At( ":" , cSMTP ) - 1 )
endif

if	Upper(Alltrim(cFrom)) == 'SM0->M0_NOMECOM'        	
	cFrom := Alltrim(&(cFrom)) + " <" + Alltrim(cUser) + ">"
elseif	!( "<" $ Upper(Alltrim(cFrom)) )
	cFrom := Alltrim(cFrom) + " <" + Alltrim(cUser) + ">"
endif

oMail:SetUseSSL(lSSL)
oMail:SetUseTLS(lTLS)

oMail:Init( cPop , cSMTP , cUser , cPass , nPOPPort , nSMTPPort )

if 	oMail:SetSMTPTimeOut( nTime ) != 0
	if	lAlert
		Alert('Falha ao definir timeout')
	endif
else
	nErr := oMail:SmtpConnect()
	if 	nErr <> 0
		if	lAlert
			Alert('Falha ao conectar: ' + oMail:GetErrorString(nErr))
		endif		
		if 	oMail:SmtpDisconnect() <> 0
			if	lAlert		
				Alert("Erro ao desconectar do servidor SMTP")
			endif
		endif
	else	
		nErr := oMail:SmtpAuth( cUser , cPass )

		if 	nErr <> 0
			if	lAlert
				Alert('Falha ao autenticar: ' + oMail:GetErrorString(nErr))
			endif			
			nErr := oMail:SmtpDisconnect() 
			if 	nErr <> 0
				if	lAlert
					Alert('Falha ao desconectar : ' + Upper(oMail:GetErrorString(nErr)))
				endif
			endif
		else   
			oMessage:Clear()
			oMessage:cFrom    		:= 	cFrom
			oMessage:cTo      		:= 	Alltrim(cPara)
			oMessage:cCC      		:= 	Alltrim(cCC)
			oMessage:cBCC     		:= 	Alltrim(cCCO)
			oMessage:cSubject		:= 	cSubject
			oMessage:cBody    		:= 	cHtml

			if !Empty(cReplyTo)
				oMessage:cReplyTo	:=	cReplyTo
			endif

			if	Len(aAnexos) <> 0 
				For t := 1 to Len(aAnexos)
					nErr := oMessage:AttachFile( aAnexos[t] ) 
				Next t
			endif

			For t := 1 to 5
				nErr := oMessage:Send( oMail ) 
				if	nErr == 0
					Exit
				endif
			Next t     

			if 	nErr <> 0
				if	lAlert
					Alert('Falha ao enviar : ' + Upper(oMail:GetErrorString(nErr)))
				endif
			else
				lRet := .t.
				nErr := oMail:SmtpDisconnect() 
				if 	nErr <> 0
					if	lAlert
						Alert('Falha ao desconectar : ' + Upper(oMail:GetErrorString(nErr)))
					endif
				endif
			endif
			
		endif
	endif
endif
	
Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณTela para montagem de email                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method TelaMail(cPara,cCC,cCCO,cTexto,lTexto,lSubject,cSubject,lEdit,cCabec) Class GeneralClass

Local oCC
Local oCCO
Local oDlg3
Local oPara
Local oFont
Local oIcon1
Local oIcon2
Local oTexto
Local oSubject
Local nOpc			:=	0
Local bOk			:=	{ || nOpc := 1 , oDlg3:End() }
Local bCancel 		:=	{ || nOpc := 0 , oDlg3:End() }
Local nTamTela		:=	0

Default cCC			:=	Space(250)
Default cCCO		:=	Space(250)
Default cPara		:=	Space(250)
Default cTexto		:=	Space(250)
Default cSubject	:=	Space(250)
Default cCabec		:=	""
Default lEdit		:=	.t.
Default lTexto		:=	.f.
Default lSubject	:=	.f.

cCC			:=	iif( Len(cCC)   <> 250 		, Substr( cCC      + Space(250) , 001 , 250 ) , cCC   		)
cCCO		:=	iif( Len(cCCO)  <> 250 		, Substr( cCCO     + Space(250) , 001 , 250 ) , cCCO  		)
cPara		:=	iif( Len(cPara) <> 250 		, Substr( cPara    + Space(250) , 001 , 250 ) , cPara 		)
cSubject	:=	iif( Len(cSubject) <> 250 	, Substr( cSubject + Space(250) , 001 , 250 ) , cSubject 	)

if 	lSubject
	if 	lTexto
		nTamTela := 550
	else
		nTamTela := 210 
	endif
else
	if 	lTexto
		nTamTela := 550
	else
		nTamTela := 150
	endif
endif

Define Font oFont  Name "Tahoma" Size 0,-11 Bold

if !lTexto .and. !lSubject .and. Empty(cCabec)	
	Define MsDialog oDlg3 Title "Envio de E-Mails" 	From 000,000 To nTamTela,450 Style nOR(WS_VISIBLE,WS_POPUP)	Of oMainWnd Pixel
elseif !lTexto .and. !lSubject .and. !Empty(cCabec)	
	Define MsDialog oDlg3 Title cCabec             	From 000,000 To nTamTela,450 								Of oMainWnd Pixel
else
	Define MsDialog oDlg3 Title "Envio de E-Mails" 	From 000,000 To nTamTela,450 								Of oMainWnd Pixel
endif

oDlg3:lEscClose := 	.f.
oDlg3:nClrPane	:=	RGB(160,181,199)

@ 024,210 Icon oIcon1 Resource "BMPPOST" On Click Eval(bOk) 		Of oDlg3 Pixel

oIcon1:lTransparent := .t.

@ 038,210 Icon oIcon2 Resource "FINAL"   On Click Eval(bCancel) 	Of oDlg3 Pixel

oIcon2:lTransparent := .t.

@ 015,005 To 070,205 Label " E-Mails de Destino " 					Of oDlg3 					Pixel 	Color CLR_RED

@ 025,010 Say "Para "  			Font oFont 		Color CLR_BLUE 		Of oDlg3 					Pixel
@ 040,010 Say "CC   "   		Font oFont 							Of oDlg3 					Pixel
@ 055,010 Say "CCO  "     		Font oFont 							Of oDlg3 					Pixel
@ 023,030 MsGet oPara  			Var cPara 		Size 170,09 		Of oDlg3 Picture "@S100" 	Pixel
@ 038,030 MsGet oCC    			Var cCC   		Size 170,09 		Of oDlg3 Picture "@S100" 	Pixel
@ 053,030 MsGet oCCO   			Var cCCO  		Size 170,09 		Of oDlg3 Picture "@S100" 	Pixel

if 	lSubject
	@ 075,005 To 105,205 Label " Assunto " 							Of oDlg3 					Pixel 	Color CLR_RED
	@ 085,010 MsGet oSubject	Var cSubject	Size 190,09 		Of oDlg3 Picture "@S100" 	Pixel
	if 	lTexto
		@ 110,005 To 272,205 Label " Mensagem " 					Of oDlg3 					Pixel 	Color CLR_RED
		@ 120,010 Get oTexto  		Var cTexto	Of oDlg3 MULTILINE Size 190,145 COLORS 0, 16777215 HSCROLL Pixel 	When lEdit
	endif
else
	if 	lTexto
		@ 075,005 To 272,205 Label " Mensagem " 					Of oDlg3 					Pixel 	Color CLR_RED
		@ 085,010 Get oTexto  		Var cTexto	Of oDlg3 MULTILINE Size 190,180 COLORS 0, 16777215 HSCROLL Pixel	When lEdit
	endif
endif

Activate MsDialog oDlg3 Centered

Return ( nOpc == 1 )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os c๓digos dos bancos                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method CodBanco() Class GeneralClass      

Local aRet	:=	{}

aAdd( aRet , { "001" , "BANCO DO BRASIL S/A"									 									} )
aAdd( aRet , { "003" , "BANCO DA AMAZิNIA S/A"									 									} )
aAdd( aRet , { "004" , "BANCO DO NORDESTE DO BRASIL S/A" 															} )
aAdd( aRet , { "007" , "BANCO NACIONAL DE DESENVOLVIMENTO ECONOMICO E SOCIAL"										} )
aAdd( aRet , { "010" , "CREDICOAMO CREDITO RURAL COOPERATIVA S/A"													} )
aAdd( aRet , { "011" , "SC CREDIT SUISSE HG"																		} )
aAdd( aRet , { "012" , "BANCO INBURSA S/A"																			} )
aAdd( aRet , { "014" , "NATIXIS BRASIL S/A BANCO MฺLTIPLO"		 													} )
aAdd( aRet , { "015" , "UBS BRASIL CCTVM S/A"					 													} )
aAdd( aRet , { "016" , "CREDITRAN COOPERATIVA DE CRษDITO DE TRANSITO DE SANTA CATARINA"								} )
aAdd( aRet , { "017" , "BNY MELLON BANK S/A" 																		} )
aAdd( aRet , { "018" , "BM TRICURY S/A" 																			} )
aAdd( aRet , { "021" , "BANCO DO ESTADO DO ESPอRITO SANTO S/A - BANESTES"						 					} )
aAdd( aRet , { "024" , "BANCO DO ESTADO DE PERNAMBUCO S/A - BANDEPE" 												} )
aAdd( aRet , { "025" , "BANCO ALFA S/A" 																			} )
aAdd( aRet , { "029" , "BANCO ITAฺ CONSIGNADO S/A"																	} )
aAdd( aRet , { "033" , "BANCO SANTANDER S/A" 																		} )
aAdd( aRet , { "036" , "BANCO BRADESCO BBI S/A" 																	} )
aAdd( aRet , { "037" , "BANCO DO ESTADO DO PARม S/A"									 							} )
aAdd( aRet , { "040" , "BANCO CARGILL S/A"									 										} )
aAdd( aRet , { "041" , "BANCO DO ESTADO DO RIO GRANDE DO SUL S/A" 													} )
aAdd( aRet , { "047" , "BANCO DO ESTADO DE SERGIPE S/A"									 					 		} )
aAdd( aRet , { "060" , "CONFIDENCE CORRETORA DE CAMBIO S/A"            												} )
aAdd( aRet , { "062" , "HIPERCARD BANCO MฺLTIPLO S/A"                  												} )
aAdd( aRet , { "063" , "BANCO BRADESCARD S/A" 																		} )
aAdd( aRet , { "064" , "GOLDMAN SACHS DO BRASIL BANCO MฺLTIPLO S/A"                  								} )
aAdd( aRet , { "065" , "BANCO ANDBANK S/A" 		   																	} )
aAdd( aRet , { "066" , "BANCO MORGAN STANLEY DEAN WITTER S/A"														} )
aAdd( aRet , { "069" , "BANCO CREFISA S/A"									 										} )
aAdd( aRet , { "070" , "BANCO DE BRASอLIA S/A"									 									} )
aAdd( aRet , { "074" , "BANCO J. SAFRA S/A"									 						   				} )
aAdd( aRet , { "075" , "BANCO ABN AMRO S/A"																			} )
aAdd( aRet , { "076" , "BANCO KDB DO BRASIL S/A"						 											} )
aAdd( aRet , { "077" , "BANCO INTER S/A"																			} )
aAdd( aRet , { "078" , "BANCO DE INVESTIMENTO DO BRASIL S/A"									 					} )
aAdd( aRet , { "079" , "BANCO ORIGINAL DO AGRONEGำCIO S/A" 															} )
aAdd( aRet , { "080" , "BT ASSOCIADOS CORRETORA DE CAMBIO LTDA" 													} )
aAdd( aRet , { "081" , "BANCO SEGURO S/A"																			} )
aAdd( aRet , { "082" , "BANCO TOPมZIO S/A" 																			} )
aAdd( aRet , { "083" , "BANCO DA CHINA BRASIL S/A" 																	} )
aAdd( aRet , { "084" , "UNIPRIME NORTE DO PARANA" 			  														} )     		
aAdd( aRet , { "085" , "COOPERATIVA CENTRAL DE CRษDITO - AILOS"														} )
aAdd( aRet , { "088" , "BANCO RANDON S.A."																			} )
aAdd( aRet , { "089" , "CREDISAN - COOPERATIVA DE CRษDITO RURAL DA REGIรO DA MOGIANA"								} )
aAdd( aRet , { "091" , "UNICRED CENTRAL DO RIO GRANDE DO SUL" 														} )     		
aAdd( aRet , { "092" , "BRICKELL S/A CRษDITO, FINANCIAMENTO E INVESTIMENTO"											} )
aAdd( aRet , { "093" , "SCM POLOCRED S/A"									 										} )
aAdd( aRet , { "094" , "BANCO PETRA S/A"									 										} )
aAdd( aRet , { "095" , "TRAVELEX BANCO DE CยMBIO S/A" 																} )
aAdd( aRet , { "096" , "BANCO B3 S/A" 																				} )
aAdd( aRet , { "097" , "COOPERATIVA CENTRAL DE CRษDITO NOROESTE BRASILEIRO LTDA"									} )
aAdd( aRet , { "098" , "CREDIALIANวA COOPERATIVA DE CRษDITO RURAL"													} )
aAdd( aRet , { "099" , "UNIPRIME COOPERATIVA CENTRAL INTERESTADUAL"													} )

aAdd( aRet , { "100" , "SC PLANNER"																					} )
aAdd( aRet , { "101" , "DTVM RENASCENวA"																			} )
aAdd( aRet , { "102" , "SC XP INVESTIMENTOS"																		} )
aAdd( aRet , { "104" , "CAIXA ECONิMICA FEDERAL" 																	} )
aAdd( aRet , { "105" , "SCFI LECCA CREDITO FINANCIAMENTO E INVESTIMENTO S/A"										} )
aAdd( aRet , { "107" , "BANCO BOCOM BBM S/A" 																		} )
aAdd( aRet , { "108" , "PORTOCRED S/A CRษDITO, FINANCIAMENTO E INVESTIMENTO"										} )
aAdd( aRet , { "111" , "OLIVEIRA TRUST DISTRIBUIDORA DE  TอTULOS E VALORES MOBILIARIOS"								} )
aAdd( aRet , { "113" , "SC MAGLIANO"																				} )
aAdd( aRet , { "114" , "CENTRAL DAS COOPERATIVAS DE ECONOMIA E CRษDITO MฺTUO DO ESTADO DO ESPอRITO SANTO"			} )
aAdd( aRet , { "115" , "RำTULA S.A. CRษDITO, FINANCIAMENTO E INVESTIMENTO"											} )
aAdd( aRet , { "116" , "BANCO ฺNICO S/A"																			} )
aAdd( aRet , { "117" , "ADVANCED CORRETORA DE CยMBIO LTDA"															} )
aAdd( aRet , { "118" , "STANDARD CHARTERED BANK S/A" 																} )
aAdd( aRet , { "119" , "BANCO WESTERN UNION DO BRASIL S/A" 															} )
aAdd( aRet , { "120" , "BANCO RODOBENS S/A"									 										} )
aAdd( aRet , { "121" , "BANCO AGIBANK S/A"																			} )
aAdd( aRet , { "122" , "BANCO BERJ S/A"																				} )
aAdd( aRet , { "123" , "SCFI AGIPLAN"																				} )
aAdd( aRet , { "124" , "BANCO WOORI BANK DO BRASIL S/A" 															} )
aAdd( aRet , { "125" , "BRASIL PLURAL S/A - BANCO MฺLTIPLO" 														} )
aAdd( aRet , { "126" , "BR PARTNERS BANCO DE INVESTIMENTO S/A" 														} )
aAdd( aRet , { "127" , "CODEPE CVC S/A"																				} )
aAdd( aRet , { "128" , "MS BANK S/A - BANCO DE CยMBIO" 																} )
aAdd( aRet , { "129" , "UBS BRASIL BANCO DE INVESTIMENTO S/A" 														} )
aAdd( aRet , { "130" , "CARUANA S/A"																				} )
aAdd( aRet , { "131" , "SC TULLETT PREBON"																			} )
aAdd( aRet , { "132" , "ICBC DO BRASIL BANCO MฺLTIPLO S/A" 															} )
aAdd( aRet , { "133" , "CONFEDERAวรO NACIONAL COOPERATIVA DE CREDITO CRESOL"										} )
aAdd( aRet , { "134" , "DTVM BGC LIQUIDEZ"																			} )
aAdd( aRet , { "135" , "SC GRADUAL"																					} )
aAdd( aRet , { "136" , "BANCO UNICRED S/A" 																			} )
aAdd( aRet , { "137" , "SC MULTIMONEY"																				} )
aAdd( aRet , { "138" , "SC GET MONEY"																				} )
aAdd( aRet , { "139" , "INTESA SANPAOLO BRASIL S/A - BANCO MฺLTIPLO" 												} )
aAdd( aRet , { "140" , "EASYNVEST - TITULO CORRETORA DE VALORES"													} )
aAdd( aRet , { "142" , "BROKER BRASIL CORRETORA DE CAMBIO LTDA"														} )
aAdd( aRet , { "143" , "SC TREVISO"																					} )
aAdd( aRet , { "144" , "BANCO DE CยMBIO S/A - BEXS"																	} )
aAdd( aRet , { "145" , "SC LEVYCAM"																					} )
aAdd( aRet , { "146" , "GUITTA CORRETORA DE CAMBIO LTDA"															} )
aAdd( aRet , { "147" , "RICO CORRETORA DE TอTULOS E VALORES MOBILIARIOS"											} )
aAdd( aRet , { "149" , "SCFI FACTA FINANCEIRA"																		} )
aAdd( aRet , { "151" , "BANCO NOSSA CAIXA S/A" 																		} )
aAdd( aRet , { "157" , "ICAP DO BRASIL CORRETORA DE TอTITULOS E VALORES MOBILIARIOS"								} )
aAdd( aRet , { "159" , "CASA DO CREDITO S/A"																		} )
aAdd( aRet , { "163" , "COMMERZBANK BRASIL S/A - BANCO MฺLTIPLO" 													} )
aAdd( aRet , { "167" , "S HAYATA CORRETORA DE CAMBIO S/A"															} )
aAdd( aRet , { "169" , "BANCO OLษ BONSUCESSO CONSIGNADO S/A"														} )
aAdd( aRet , { "172" , "ALBATROSS CORRETORA DE CAMBIO E VALORES MOBILIARIOS"										} )
aAdd( aRet , { "173" , "BRL TRUST DISTRIBUIDORA DE TITULOS E VALORES MOBILIARIOS"									} )
aAdd( aRet , { "174" , "PERNAMBUCANAS FINANCIADORA S/A"																} )
aAdd( aRet , { "177" , "GUIDE INVEST.S.A. CORRETORA DE VALORES"														} )
aAdd( aRet , { "180" , "SC CM CAPITAL MARKETS"																		} )
aAdd( aRet , { "183" , "SOCRED S/A"																					} )
aAdd( aRet , { "184" , "BANCO ITAฺ BBA S/A"									 										} )
aAdd( aRet , { "188" , "ATIVA INVESTIMENTOS S/A"																	} )
aAdd( aRet , { "189" , "HS FINANCEIRA S/A"																			} )
aAdd( aRet , { "190" , "SERVICOOP COOPERATIVA DOS SERVIDORES PUBLICOS DE RS"										} )
aAdd( aRet , { "191" , "NOVA FUTURA CORRETORA DE TอTULOS E VALORES"													} )
aAdd( aRet , { "194" , "PARMETAL DISTRIBUIDORA DE TITULOS E VALORES"												} )
aAdd( aRet , { "196" , "FAIR CORRETORA DE CAMBIO S/A"																} )
aAdd( aRet , { "197" , "STONE PAGAMENTOS S/A"																		} )

aAdd( aRet , { "204" , "BANCO BRADESCO CARTีES S/A" 																} )
aAdd( aRet , { "208" , "BANCO BTG PAGTUAL S/A"																		} )
aAdd( aRet , { "212" , "BANCO ORIGINAL S/A"									 										} )
aAdd( aRet , { "213" , "BANCO ARBI S/A" 		   																	} )
aAdd( aRet , { "217" , "BANCO JOHN DEERE S/A"									 									} )
aAdd( aRet , { "218" , "BANCO BS2 S/A" 																				} )
aAdd( aRet , { "222" , "BANCO CREDIT AGRICOLE BRASIL S/A"									 						} )
aAdd( aRet , { "224" , "BANCO FIBRA S/A"									 										} )
aAdd( aRet , { "230" , "UNICARD BANCO MฺLTIPLO S/A" 																} )
aAdd( aRet , { "233" , "BANCO CIFRA S/A"									 										} )
aAdd( aRet , { "237" , "BANCO BRADESCO S/A" 																		} )
aAdd( aRet , { "241" , "BANCO CLมSSICO S/A"									 								  		} )
aAdd( aRet , { "243" , "BANCO MAXIMA S/A"									 								  		} )
aAdd( aRet , { "246" , "BANCO ABC BRASIL S/A" 																		} )
aAdd( aRet , { "249" , "BANCO INVESTCRED UNIBANCO S/A" 																} )
aAdd( aRet , { "250" , "BCV - BANCO DE CRษDITO E VAREJO S/A"														} )
aAdd( aRet , { "253" , "BEXS CORRETORA DE CAMBIO S/A"																} )
aAdd( aRet , { "254" , "PARANม BANCO S/A" 																			} )
aAdd( aRet , { "259" , "MONEYCORP BANCO DE CAMBIO S/A"																} )
aAdd( aRet , { "260" , "NU PAGAMENTOS S/A"																			} )
aAdd( aRet , { "263" , "BANCO CACIQUE S/A"									 										} )
aAdd( aRet , { "265" , "BANCO FATOR S/A"									 										} )
aAdd( aRet , { "266" , "BANCO CษDULA S/A"									 										} )
aAdd( aRet , { "268" , "BARI COMPANHIA HIPOTECARIA S/A"																} )
aAdd( aRet , { "269" , "HSBC BANK BRASIL S/A – BANCO DE INVESTIMENTO"												} )
aAdd( aRet , { "270" , "SAGITUR CORRETORA DE CAMBIO LTDA"															} )
aAdd( aRet , { "271" , "IB CORRETORA DE CAMBIO TITULOS E VALORES"													} )
aAdd( aRet , { "272" , "AGK CORRETORA DE CAMBIO S/A"																} )
aAdd( aRet , { "273" , "COOPERATIVA DE CREDITO RURAL DE SAO MIGUEL"													} )
aAdd( aRet , { "274" , "MONEY PLUS SOCIEDADE DE CREDITO AO MICROEMPREENDEDOR"										} )
aAdd( aRet , { "275" , "BANCO SANTANDER S/A"									 									} )
aAdd( aRet , { "276" , "BANCO SENFF S/A"																			} )
aAdd( aRet , { "278" , "GENIAL INVESTIMENTOS CVM S/A"																} )
aAdd( aRet , { "279" , "COOPERATIVA DE CREDITO RURAL PRIMAVERA DO LESTE"											} )
aAdd( aRet , { "280" , "BANCO WILLBANK S/A"																			} )
aAdd( aRet , { "281" , "CCR COOPAVEL"																				} )
aAdd( aRet , { "283" , "RB CAPITAL INVESTIMENTO E DISTRIBUIDORA DE TITULOS"											} )
aAdd( aRet , { "285" , "FRENTE CORRETORA DE CAMBIO LTDA"															} )
aAdd( aRet , { "286" , "CCR DE OURO"																				} )
aAdd( aRet , { "288" , "CAROL DTVM"																					} )
aAdd( aRet , { "289" , "DECYSEO CORRETORA DE CAMBIO LTDA"															} )
aAdd( aRet , { "290" , "PAGSEGURO INTERNET S/A"																		} )
aAdd( aRet , { "292" , "BS2 DTVM S/A"																				} )
aAdd( aRet , { "293" , "LASTRO RDV DTVM LTDA"																		} )
aAdd( aRet , { "296" , "VISION S/A. CORRETORA DE CAMBIO"															} )
aAdd( aRet , { "298" , "VIPS CORRETORA DE CAMBIO LTDA"																} )
aAdd( aRet , { "299" , "SOROCRED - CREDITO FINANC INVEST S/A"														} )

aAdd( aRet , { "300" , "BANCO DE LA NACION ARGENTINA S/A"									 						} )
aAdd( aRet , { "301" , "DOCK INSTITUICAO DE PAGAMENTO S/A"															} )
aAdd( aRet , { "306" , "PORTOPAR DISTRIBUIDORA DE TITULOS E VALORES IMOBILIARIOS"									} )
aAdd( aRet , { "307" , "TERRA INVEST DISTRIBUID DE TITULOS"															} )
aAdd( aRet , { "309" , "CAMBIONET CORRETORA DE CAMBIO LTDA"															} )
aAdd( aRet , { "310" , "VORTX DISTRIBUIDORA DE TITULOS E VALORES"													} )
aAdd( aRet , { "312" , "HSCM - SOCIEDADE DE CRษDITO AO MICROEMPRARIO"												} )
aAdd( aRet , { "313" , "AMAZONIA CORRETORA DE CAMBIO LTDA"															} )
aAdd( aRet , { "315" , "PI DTVM S/A"																				} )
aAdd( aRet , { "318" , "BANCO BMG S/A" 																				} )
aAdd( aRet , { "319" , "OM DTVM LTDA"																				} )
aAdd( aRet , { "320" , "CHINA CONSTRUCTION BANK BANCO MฺLTIPLO S/A" 												} )
aAdd( aRet , { "321" , "CREFAZ SOCIEDADE DE CREDITO AO MICROEMPREENDEDOR"											} )
aAdd( aRet , { "322" , "COOPERATIVA DE CREDITO RURAL ABELARDO LUZ S/A"												} )
aAdd( aRet , { "323" , "MERCADOPAGO.COM REPRESENTACOES LTDA"														} )
aAdd( aRet , { "325" , "ORAMA DISTRIBUIDORA DE TITULOS E VALORES"													} )
aAdd( aRet , { "326" , "PARATI CFI S/A"																				} )
aAdd( aRet , { "328" , "COOPERATIVA DE ECONOMIA E CREDITO MUTUO"													} )
aAdd( aRet , { "329" , "QI SOCIEDADE DE CREDITO DIRETO S/A"															} )
aAdd( aRet , { "330" , "BANCO BARI DE INVEST E FINANC S/A"															} )
aAdd( aRet , { "331" , "FRAM CAPITAL DTVM S/A"																		} )
aAdd( aRet , { "332" , "ACESSO SOLUCOES DE PAGAMENTO S/A"															} )
aAdd( aRet , { "335" , "BANCO DIGIO S/A"																			} )
aAdd( aRet , { "336" , "BANCO C6 BANK S/A" 																			} )
aAdd( aRet , { "340" , "SUPER PAG ADMMISTRADORA DE MEIOS ELETRONICOS DE PAGAMENTOS S/A"								} )
aAdd( aRet , { "341" , "BANCO ITAฺ UNIBANCO S/A"																	} )
aAdd( aRet , { "342" , "CREDITAS SOCIEDADE DE CREDITO DIRETO S/A"													} )
aAdd( aRet , { "343" , "FFA SCMPP LTDA"																				} )
aAdd( aRet , { "348" , "BANCO XP S/A"																				} )
aAdd( aRet , { "349" , "AMAGGI S/A - BANCO AL5"																		} )
aAdd( aRet , { "352" , "TORO CORRETORA DE TอTULOS E VALORES MOBILIมRIOS S/A"	 									} )
aAdd( aRet , { "353" , "BANCO SANTANDER S/A"									 									} )
aAdd( aRet , { "354" , "NECTON INVESTIMENTOS S/A. CORRETORA DE VALORES"			 									} )
aAdd( aRet , { "355" , "OTIMO SOCIEDADE DE CREDITO DIRETO S/A"					 									} )
aAdd( aRet , { "356" , "BANCO SANTANDER S/A"									 									} )
aAdd( aRet , { "362" , "CIELO S/A"                  																} )
aAdd( aRet , { "363" , "SOCOPA SOCIEDADE CORRETORA PAULISTA S/A"													} )
aAdd( aRet , { "364" , "GERENCIANET PAGAMENTOS DO BRASIL LTDA" 														} )
aAdd( aRet , { "365" , "SOLIDUS S/A CORRETORA DE CAMBIO E VALORES" 													} )
aAdd( aRet , { "366" , "BANCO SOCIษTษ GษNษRALE BRASIL S/A" 															} )
aAdd( aRet , { "367" , "VITREO DTVM S/A"			 																} )
aAdd( aRet , { "368" , "BANCO CSF S/A"				 																} )
aAdd( aRet , { "370" , "BANCO WESTLB DO BRASIL S/A" 																} )
aAdd( aRet , { "371" , "WARREN CORRETORA DE VALORES MOBILIมRIOS S/A" 												} )
aAdd( aRet , { "373" , "UP.P SEP S/A" 																				} )
aAdd( aRet , { "376" , "BANCO J. P. MORGAN S/A" 																	} )
aAdd( aRet , { "377" , "MS SOCIEDADE DE CREDITO AO MICROEMPREENDEDOR S/A" 											} )
aAdd( aRet , { "379" , "COOPERFORTE - COOPERATIVA DE ECONOMIA S/A" 													} )
aAdd( aRet , { "380" , "PICPAY SERVICOS S/A" 																		} )
aAdd( aRet , { "382" , "FIDUCIA SOCIEDADE DE CRษDITO AO MICROEMPREENDEDOR S/A" 										} )
aAdd( aRet , { "383" , "JUNO S/A"														 							} )
aAdd( aRet , { "384" , "GLOBAL FINANCAS SOCIEDADE DE CREDITO AO MICROEMPRESARIO"									} )
aAdd( aRet , { "387" , "BANCO TOYOTA DO BRASIL S/A"																	} )
aAdd( aRet , { "389" , "BANCO MERCANTIL DO BRASIL S/A"									 							} )
aAdd( aRet , { "394" , "BANCO FINASA BMC S/A" 																		} )
aAdd( aRet , { "396" , "HUB PAGAMENTOS S/A" 																		} )
aAdd( aRet , { "399" , "KIRTON BANK S/A - BANCO MฺLTIPLO" 															} )

aAdd( aRet , { "403" , "CORA SOCIEDADE DE CRษDITO DIRETO S/A"														} )
aAdd( aRet , { "404" , "SUMUP SOCIEDADE DE CRษDITO DIRETO S/A"														} )
aAdd( aRet , { "408" , "BONUSCRED SCD S/A"																			} )
aAdd( aRet , { "409" , "UNIรO DE BANCOS BRASILEIROS S/A" 															} )
aAdd( aRet , { "411" , "VIA CERTA FINANCIADORA S/A" 																} )
aAdd( aRet , { "412" , "BANCO CAPITAL S/A" 																			} )
aAdd( aRet , { "422" , "BANCO SAFRA S/A"									 										} )
aAdd( aRet , { "426" , "BIORC FINANCEIRA"									 										} )
aAdd( aRet , { "445" , "PLANTAE CFI"									 											} )
aAdd( aRet , { "453" , "BANCO RURAL S/A"									 										} )
aAdd( aRet , { "456" , "BANCO DE TOKYO-MITSUBISHI UFJ BRASIL S/A"									 				} )
aAdd( aRet , { "464" , "BANCO SUMITOMO MITSUI BRASILEIRO S/A"									 					} )
aAdd( aRet , { "473" , "BANCO CAIXA GERAL S/A"									 									} )
aAdd( aRet , { "477" , "CITIBANK N.A." 																				} )
aAdd( aRet , { "479" , "BANCO ITAUBANK S/A"									 						   				} )
aAdd( aRet , { "487" , "DEUTSCHE BANK S/A" 																			} )
aAdd( aRet , { "488" , "JPMORGAN CHASE BANK" 																		} )
aAdd( aRet , { "492" , "ING BANK N.V." 																				} )
aAdd( aRet , { "494" , "BANCO DE LA REPUBLICA ORIENTAL DEL URUGUAI"													} )
aAdd( aRet , { "495" , "BANCO DE LA PROVINCIA DE BUENOS AIRES"									 					} )

aAdd( aRet , { "505" , "BANCO CREDIT SUISSE BRASIL S/A"									 					  		} )
aAdd( aRet , { "545" , "SENSO CORRETORA DE CAMBIO S/A"									 					  		} )

aAdd( aRet , { "600" , "BANCO LUSO BRASILEIRO S/A"									 								} )
aAdd( aRet , { "604" , "BANCO INDUSTRIAL DO BRASIL S/A" 															} )
aAdd( aRet , { "610" , "BANCO VR S/A" 																				} )
aAdd( aRet , { "611" , "BANCO PAULISTA S/A"									 							   			} )
aAdd( aRet , { "612" , "BANCO GUANABARA S/A"									 									} )
aAdd( aRet , { "613" , "BANCO PECUNIA S/A" 																			} )
aAdd( aRet , { "623" , "BANCO PAN S/A"									 											} )
aAdd( aRet , { "626" , "BANCO FICSA S/A"									 										} )
aAdd( aRet , { "630" , "BANCO SMARTBANK S/A"									 									} )
aAdd( aRet , { "633" , "BANCO RENDIMENTO S/A"									 									} )
aAdd( aRet , { "634" , "BANCO TRIยNGULO S/A" 																		} )
aAdd( aRet , { "637" , "BANCO SOFISA S/A"									 										} )
aAdd( aRet , { "641" , "BANCO ALVORADA S/A" 																		} )
aAdd( aRet , { "643" , "BANCO PINE S/A"									 								   			} )
aAdd( aRet , { "652" , "ITAฺ UNIBANCO HOLDING S/A" 																	} )
aAdd( aRet , { "653" , "BANCO INDUSVAL S/A" 																		} )
aAdd( aRet , { "654" , "BANCO DIGIMAIS S/A"																			} )
aAdd( aRet , { "655" , "BANCO VOTORANTIM S/A" 																		} )

aAdd( aRet , { "707" , "BANCO DAYCOVAL S/A"									 								  		} )
aAdd( aRet , { "712" , "BANCO OURINVEST S/A"									 									} )
aAdd( aRet , { "720" , "BANCO RNX S/A"									 											} )
aAdd( aRet , { "735" , "BANCO NEON S/A"										 										} )
aAdd( aRet , { "739" , "BANCO CETELEM S/A"										 									} )
aAdd( aRet , { "741" , "BANCO RIBEIRรO PRETO S/A"																	} )
aAdd( aRet , { "743" , "BANCO SEMEAR S/A"									 										} )
aAdd( aRet , { "745" , "BANCO CITIBANK S/A"									 								   		} )
aAdd( aRet , { "746" , "BANCO MODAL S/A" 																			} )
aAdd( aRet , { "747" , "BANCO RABOBANK INTERNATIONAL BRASIL S/A"									 				} )
aAdd( aRet , { "748" , "BANCO COOPERATIVO SICREDI S/A"									 							} )
aAdd( aRet , { "751" , "SCOTIABANK BRASIL S/A - BANCO MฺLTIPLO" 													} )
aAdd( aRet , { "752" , "BANCO BNP PARIBAS BRASIL S/A" 																} )
aAdd( aRet , { "753" , "NOVO BANCO CONTINENTAL S/A - BANCO MฺLTIPLO" 												} )
aAdd( aRet , { "754" , "BANCO SISTEMA S/A"									 										} )
aAdd( aRet , { "755" , "BANK OF AMERICA MERRILL LYNCH BANCO MฺLTIPLO S/A" 											} )
aAdd( aRet , { "756" , "BANCO COOPERATIVO DO BRASIL S/A - SICOOB" 													} )
aAdd( aRet , { "757" , "BANCO KEB HANA DO BRASIL S/A"									 							} )

aAdd( aRet , { "901" , "SOCIEDADE DE CRษDITO SOUZA BARROS"															} )
aAdd( aRet , { "912" , "COOPERATIVA DE CRษDITO RURAL DE PRIMAVERA DO LESTE"											} )
aAdd( aRet , { "934" , "AGIPLAN FINANCEIRA S/A"																		} )


Return ( aRet )    	

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os c๓digos dos bancos                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method NomeBanco(cBanco) Class GeneralClass      
           
Local aRet	:=	::CodBanco()
Local nLin	:=	aScan( aRet , { |x| x[01] == cBanco } )
Local cRet 	:=	iif( nLin <> 0 , aRet[nLin,02] , "" )

Return ( cRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os c๓digos dos bancos                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method ChkParOutEmp(lShared,xEmp,xFil,xRet,xPar,lSeek,xTipo,lAlert,lFull) Class GeneralClass      

Local s
Local nLoop 		:= 	000
Local lOpen 		:= 	.f.    
Local nSize 		:= 	FwSizeFilial()       
Local cSize			:=	Space(nSize)
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U"

Default xEmp		:=	""
Default xFil		:=	""
Default xRet		:=	""
Default xPar 		:=	""
Default xTipo		:=	""
Default lSeek  		:=	.f. 
Default lFull		:=	.t.
Default lAlert		:=	.f.
Default lShared		:=	.t. 

if 	Select("XSX6") > 0
	XSX6->(dbclosearea())
endif

For nLoop := 01 To 20
	dbUseArea( .t. , , "SX6" + xEmp + "0" , "XSX6" , lShared , .f. )
	if	Select("XSX6") <> 0
		lOpen := .t.
		Exit
	endif
	Sleep( 500 )
Next nLoop

if	lOpen   
	xPar := PadR( Upper(Alltrim(xPar)) , Len(SX6->X6_VAR) ) 
	if	lSeek
		XSX6->(dbsetorder(1))
		For s := 02 to 15 
			cSize := Space(s)
			if	XSX6->(dbseek( cSize + xPar , .f. ))
				xRet 	:= 	Alltrim(XSX6->X6_CONTEUD)
				xTipo 	:= 	Alltrim(XSX6->X6_TIPO)
				Exit
			endif         
		Next s 
		if	Empty(xRet)
			if	XSX6->(dbseek( xFil + xPar , .f. ))
				xRet 	:= 	Alltrim(XSX6->X6_CONTEUD)
				xTipo 	:= 	Alltrim(XSX6->X6_TIPO)
			endif         
		endif         
	endif	
	if	Empty(xRet) .and. Empty(xTipo) .and. lFull
		XSX6->(dbgotop())
		do while XSX6->(!Eof())
			if	Upper(Alltrim(SX6->X6_VAR)) == Upper(Alltrim(xPar))
				xRet 	:= 	Alltrim(XSX6->X6_CONTEUD)
				xTipo 	:= 	Alltrim(XSX6->X6_TIPO)
				Exit
			endif
	    	XSX6->(dbskip())
		enddo
		XSX6->(dbclosearea())
	endif
	if	Empty(xRet)
		if	lAlert
			MsgStop( "Nใo foi possํvel encontrar o parโmetro pesquisado" , "ATENวรO" )
		endif
		lOpen := .f.		
	endif
else
	if	lIsBlind
		ConOut( "Nใo foi possํvel a abertura da tabela SX6" )
	elseif	lAlert
		MsgStop( "Nใo foi possํvel a abertura da tabela SX6" , "ATENวรO" )
	endif
endif

if 	Select("XSX6") > 0
	XSX6->(dbclosearea())
endif

Return ( lOpen ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os c๓digos dos bancos                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method PutParOutEmp(lShared,xEmp,xFil,xRet,xPar,lSeek,xTipo) Class GeneralClass      

Local nLoop 		:= 	000
Local lOpen 		:= 	.f.    
Local nSize 		:= 	FwSizeFilial()       
Local cSize			:=	Space(nSize)
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U"

Default xEmp		:=	""
Default xFil		:=	""
Default xRet		:=	""
Default xPar 		:=	""
Default xTipo		:=	""
Default lSeek  		:=	.f. 
Default lShared		:=	.t. 

if 	Select("XSX6") > 0
	XSX6->(dbclosearea())
endif

For nLoop := 01 To 20
	dbUseArea( .t. , , "SX6" + xEmp + "0" , "XSX6" , lShared , .f. )
	if	Select("XSX6") <> 0
		lOpen := .t.
		Exit
	endif
	Sleep( 500 )
Next nLoop

if	lOpen   
	xPar 	:= 	Substr( Upper(Alltrim(xPar)) + Space(Len(SX6->X6_VAR)) , 01 , Len(SX6->X6_VAR) ) 
	lOpen	:=	.f.
	if	lSeek
		XSX6->(dbsetorder(1))
		if	XSX6->(dbseek( cSize + xPar , .f. ))
			lOpen	:=	.t.
		elseif	XSX6->(dbseek( xFil + xPar , .f. ))
			lOpen	:=	.t.
		endif
	endif	
	if !lOpen   
		XSX6->(dbgotop())
		do while XSX6->(!Eof())
			if	Upper(Alltrim(SX6->X6_VAR)) == Upper(Alltrim(xPar))
				lOpen	:=	.t.
				Exit
			endif
	    	XSX6->(dbskip())
		enddo
	endif
	if	lOpen   
		RecLock("XSX6",.f.)
			XSX6->X6_CONTEUD := xRet 
		MsUnlock("XSX6")
	else
		MsgStop( "Nใo foi possํvel atualizar o parโmetro pesquisado" , "ATENวรO" )
		lOpen := .f.		
	endif
else
	if	lIsBlind
		ConOut( "Nใo foi possํvel a abertura da tabela SX6" )
	else
		MsgStop( "Nใo foi possํvel a abertura da tabela SX6" , "ATENวรO" )
	endif
endif

if 	Select("XSX6") > 0
	XSX6->(dbclosearea())
endif

Return ( lOpen ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os c๓digos dos bancos                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method NewSx1(	cGrupo		, cOrdem	, cPergunt	, cPerSpa	, cPerEng	, cVar		,;
				cTipo 		, nTamanho	, nDecimal	, nPresel	, cGSC		, cValid	,;
				cF3			, cGrpSxg	, cPyme		, cVar01	, cDef01	, cDefSpa1	,;
				cDefEng1	, cCnt01	, cDef02	, cDefSpa2	, cDefEng2	, cDef03	,;
				cDefSpa3	, cDefEng3	, cDef04	, cDefSpa4	, cDefEng4	, cDef05	,;
				cDefSpa5	, cDefEng5	, aHelpPor	, aHelpEng	, aHelpSpa	, cHelp		)	Class GeneralClass      

     ::PutSx1(	cGrupo		, cOrdem	, cPergunt	, cPerSpa	, cPerEng	, cVar		,;
				cTipo 		, nTamanho	, nDecimal	, nPresel	, cGSC		, cValid	,;
				cF3			, cGrpSxg	, cPyme		, cVar01	, cDef01	, cDefSpa1	,;
				cDefEng1	, cCnt01	, cDef02	, cDefSpa2	, cDefEng2	, cDef03	,;
				cDefSpa3	, cDefEng3	, cDef04	, cDefSpa4	, cDefEng4	, cDef05	,;
				cDefSpa5	, cDefEng5	, aHelpPor	, aHelpEng	, aHelpSpa	, cHelp		)	

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os c๓digos dos bancos                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method PutSx1(	cGrupo		, cOrdem	, cPergunt	, cPerSpa	, cPerEng	, cVar		,;
				cTipo 		, nTamanho	, nDecimal	, nPresel	, cGSC		, cValid	,;
				cF3			, cGrpSxg	, cPyme		, cVar01	, cDef01	, cDefSpa1	,;
				cDefEng1	, cCnt01	, cDef02	, cDefSpa2	, cDefEng2	, cDef03	,;
				cDefSpa3	, cDefEng3	, cDef04	, cDefSpa4	, cDefEng4	, cDef05	,;
				cDefSpa5	, cDefEng5	, aHelpPor	, aHelpEng	, aHelpSpa	, cHelp		)	Class GeneralClass      

Local lSpa 	 	:= 	.f.
Local lIngl 	:= 	.f. 
Local lPort 	:= 	.f.
Local aArea 	:= 	GetArea()
Local cKey		:=	"P." + AllTrim( cGrupo ) + AllTrim( cOrdem ) + "."

Default cHelp	:= 	"" 
Default cCnt01 	:= 	"" 
Default cF3    	:= 	" "
Default cPyme  	:= 	" "
Default cGrpSxg	:= 	" "

dbSelectArea("SX1")
dbSetOrder(1)

cGrupo	:=	PadR( cGrupo , Len( SX1->X1_GRUPO ) , " " )

If !( SX1->(dbseek( cGrupo + cOrdem , .f. )))

    cPergunt	:= 	iif( !( "?" $ cPergunt ) .and. !Empty(cPergunt)	, Alltrim(cPergunt) + " ?"	, cPergunt	)
	cPerSpa		:= 	iif( !( "?" $ cPerSpa  ) .and. !Empty(cPerSpa) 	, Alltrim(cPerSpa)  + " ?"	, cPerSpa	)
	cPerEng		:= 	iif( !( "?" $ cPerEng  ) .and. !Empty(cPerEng) 	, Alltrim(cPerEng)  + " ?"	, cPerEng	)

	Reclock( "SX1" , .t. )

	Replace X1_GRUPO   		With cGrupo
	Replace X1_ORDEM   		With cOrdem
	Replace X1_PERGUNT 		With cPergunt
	Replace X1_PERSPA  		With cPerSpa
	Replace X1_PERENG  		With cPerEng
	Replace X1_VARIAVL 		With cVar
	Replace X1_TIPO    		With cTipo
	Replace X1_TAMANHO 		With nTamanho
	Replace X1_DECIMAL 		With nDecimal
	Replace X1_PRESEL  		With nPresel
	Replace X1_GSC     		With cGSC
	Replace X1_VALID   		With cValid
	Replace X1_VAR01   		With cVar01
	Replace X1_F3      		With cF3
	Replace X1_GRPSXG  		With cGrpSxg

	if 	Fieldpos("X1_PYME") > 0
		if 	cPyme != Nil
			Replace X1_PYME	With cPyme
		endif
	endif

	Replace X1_CNT01   		With cCnt01

	if 	cGSC == "C"			// Multi Escolha
		Replace X1_DEF01   	With cDef01
		Replace X1_DEFSPA1 	With cDefSpa1
		Replace X1_DEFENG1 	With cDefEng1

		Replace X1_DEF02   With cDef02
		Replace X1_DEFSPA2 With cDefSpa2
		Replace X1_DEFENG2 With cDefEng2

		Replace X1_DEF03   With cDef03
		Replace X1_DEFSPA3 With cDefSpa3
		Replace X1_DEFENG3 With cDefEng3

		Replace X1_DEF04   With cDef04
		Replace X1_DEFSPA4 With cDefSpa4
		Replace X1_DEFENG4 With cDefEng4

		Replace X1_DEF05   With cDef05
		Replace X1_DEFSPA5 With cDefSpa5
		Replace X1_DEFENG5 With cDefEng5
	endif

	Replace X1_HELP  		With cHelp

	PutSX1Help(cKey,aHelpPor,aHelpEng,aHelpSpa)

	MsUnlock("SX1")
else
   lSpa  := !( "?" $ X1_PERSPA  ) .and. !Empty(SX1->X1_PERSPA)
   lIngl := !( "?" $ X1_PERENG  ) .and. !Empty(SX1->X1_PERENG)
   lPort := !( "?" $ X1_PERGUNT ) .and. !Empty(SX1->X1_PERGUNT)
   if 	lPort .or. lSpa .or. lIngl
		RecLock("SX1",.f.)
		if 	lPort 
         	SX1->X1_PERGUNT	:= 	Alltrim(SX1->X1_PERGUNT)	+ " ?"
		endif
		if 	lSpa 
			SX1->X1_PERSPA 	:= 	Alltrim(SX1->X1_PERSPA) 	+ " ?"
		endif
		if 	lIngl
			SX1->X1_PERENG 	:= 	Alltrim(SX1->X1_PERENG) 	+ " ?"
		endif
		MsUnLock("SX1")
	endif
endif

RestArea( aArea )

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os c๓digos dos bancos                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method Coalesce(xPar01,xPar02,xPar03,xPar04,xPar05,xPar06,xPar07,xPar08,xPar09,xPar10) Class GeneralClass      

Local xRet		:=	""                       
Local xType		:=	ValType(xPar01)

Default xPar01	:=	iif( xType == "D" , CtoD("") , iif( xType == "N" , 0 , "" ) )
Default xPar02	:=	iif( xType == "D" , CtoD("") , iif( xType == "N" , 0 , "" ) )
Default xPar03	:=	iif( xType == "D" , CtoD("") , iif( xType == "N" , 0 , "" ) )
Default xPar04	:=	iif( xType == "D" , CtoD("") , iif( xType == "N" , 0 , "" ) )
Default xPar05	:=	iif( xType == "D" , CtoD("") , iif( xType == "N" , 0 , "" ) )
Default xPar06	:=	iif( xType == "D" , CtoD("") , iif( xType == "N" , 0 , "" ) )
Default xPar07	:=	iif( xType == "D" , CtoD("") , iif( xType == "N" , 0 , "" ) )
Default xPar08	:=	iif( xType == "D" , CtoD("") , iif( xType == "N" , 0 , "" ) )
Default xPar09	:=	iif( xType == "D" , CtoD("") , iif( xType == "N" , 0 , "" ) )
Default xPar10	:=	iif( xType == "D" , CtoD("") , iif( xType == "N" , 0 , "" ) )

xRet			:=	iif( Empty(xRet) , xPar01 , xRet )
xRet			:=	iif( Empty(xRet) , xPar02 , xRet )
xRet			:=	iif( Empty(xRet) , xPar03 , xRet )
xRet			:=	iif( Empty(xRet) , xPar04 , xRet )
xRet			:=	iif( Empty(xRet) , xPar05 , xRet )
xRet			:=	iif( Empty(xRet) , xPar06 , xRet )
xRet			:=	iif( Empty(xRet) , xPar07 , xRet )
xRet			:=	iif( Empty(xRet) , xPar08 , xRet )
xRet			:=	iif( Empty(xRet) , xPar09 , xRet )
xRet			:=	iif( Empty(xRet) , xPar10 , xRet )

Return ( xRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os c๓digos dos bancos                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method DispMail( cPara , cHtml , cAssunto , cDe , aAnexos , cCc , cBcc ) Class GeneralClass      

Local cError 		:= 	""
Local lResult 		:= 	.t.
Local lResulConn 	:= 	.t.
Local lResulSend 	:= 	.t.

Local cPass 		:= 	AllTrim(GetMV("MV_RELPSW"))
Local cEmail 		:= 	AllTrim(GetMV("MV_RELACNT"))
Local cServer 		:= 	AllTrim(GetMV("MV_RELSERV"))
Local lRelauth 		:= 	GetMv("MV_RELAUTH")

Local cMsg 			:= 	cHtml

Default cCc 		:= 	""
Default cBcc 		:= 	""

lResulConn := MailSmtpOn( cServer , cEmail , cPass )    

if !lResulConn
	cError := MailGetErr()
	Return ( .f. )
endif

if 	lRelauth
	lResult := MailAuth(Alltrim(cEmail),Alltrim(cPass))
	if !lResult
		nA		:= 	At("@",cEmail)
		cUser 	:= 	iif( nA > 0 , Substr(cEmail,01,nA-1) , cEmail )
		lResult	:= 	MailAuth(Alltrim(cUser), Alltrim(cPass))
	endif
endif

if 	lResult	
	lResulSend	:= 	MailSend(cDe,{cPara},{cCc},{cBcc},cAssunto,cMsg,aAnexos,.t.)
	if !lResulSend
		cError	:= 	MailGetErr()
	endif
endif

MailSmtpOff()

Return ( lResulSend )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os c๓digos dos bancos                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method SemanasDoMes(dData) Class GeneralClass      

Local aSemana	:=	{}
Local dDiaIni	:=	FirstDay(dData)
Local dDiaFim	:=	LastDay(dDiaIni)

aAdd( aSemana , { dDiaIni , dDiaIni } )	

dDiaIni ++ 

do while dDiaIni <= dDiaFim  
	if	DoW(dDiaIni) == 1
		aAdd( aSemana , { dDiaIni , dDiaIni } )	
	else 
		aSemana[Len(aSemana),02]	:=	dDiaIni	
	endif 
	dDiaIni ++ 
enddo 

Return ( aSemana )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออปฑฑ
ฑฑบDescri็ใo ณRetorna os c๓digos dos bancos                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Method SemanasDoAno(nAno) Class GeneralClass      

Local aSemana	:=	{}
Local dDiaIni	:=	StoD(StrZero(nAno,04) + "0101")
Local dDiaFim	:=	StoD(StrZero(nAno,04) + "1231")

aAdd( aSemana , { dDiaIni , dDiaIni } )	

dDiaIni ++ 

do while dDiaIni <= dDiaFim  
	if	DoW(dDiaIni) == 1
		aAdd( aSemana , { dDiaIni , dDiaIni } )	
	else 
		aSemana[Len(aSemana),02]	:=	dDiaIni	
	endif 
	dDiaIni ++ 
enddo 

Return ( aSemana )
