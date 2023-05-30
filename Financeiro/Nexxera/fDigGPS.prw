#include "tbiconn.ch"     	   		    	                                       		
#include "topconn.ch"    
#include "protheus.ch"

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxDigGPS   บAutor  ณMicrosiga           บ Data ณ  10/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณManutencao dos GPS digitados                                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function fDigGPS(xFilPsq,lDesv)     				 	 								 		

Local aRet			:=	{}
Local xFilAnt		:=	cFilAnt
Local aAreaSM0		:=	SM0->(GetArea())
Local oObj			:= 	GeneralClass():New()

if !Empty(xFilPsq)
	oObj:PosicionaSM0(cEmpAnt,xFilPsq)	
	cFilAnt	:=	xFilPsq
endif

aRet 	:= 	xFuncao(lDesv)
cFilAnt	:=	xFilAnt

RestArea(aAreaSM0)

Return ( aRet )          

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณMATAZ001  บAutor  ณMicrosiga           บ Data ณ  10/17/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณValida o ativo vinculado ao produto na baixa                บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xFuncao(lDesv)   		

Local aRet
Local oCep
Local oCid
Local oCei
Local xCei
Local oEnd
Local oEmp
Local oVct
Local oRet
Local oPer
Local oCGC    
Local oVlr                
Local oEnc
Local oMul
Local oTot
Local oBig1
Local oDlg2
Local oFont
Local oBold
Local oBld2   
Local oTButton1	
Local oTButton2   
Local oTButton3   

Local lOk			:=	.f.     

Local bDs			:=	{ || lOk := Nil , oDlg2:End() }
Local bNo			:=	{ || lOk := .f. , oDlg2:End() }
Local bOk			:=	{ || lOk := .t. , iif( fValidAll(dVct,cRet,cPer,cCGC,nTot,nVlr,nEnc,nMul) , oDlg2:End() , lOk := .f. )	}

Local cEmp			:=	Capital(SM0->M0_NOMECOM)	
Local cEnd			:=	Capital(SM0->M0_ENDCOB)         
Local cCid			:=	Capital(Alltrim(SM0->M0_CIDCOB)) + " - " + Upper(Alltrim(SM0->M0_ESTCOB))
Local cCep			:=	"CEP " + Transform(SM0->M0_CEPCOB,"@R 99.999-99")   
Local dVct			:=	SE2->E2_VENCREA 
Local cRet			:=	SE2->E2_CODINS 
Local cPer			:=	SE2->E2_MESBASE + SE2->E2_ANOBASE	
Local cCGC			:=	SM0->M0_CGC  

Local cCei			:=	SE2->E2_ZZNRCEI   
Local nVlr			:=	SE2->E2_ZZVLPR 
Local nEnc			:=	SE2->E2_ZZVLMT
Local nMul			:=	SE2->E2_ZZVLJR
Local nTot			:=	SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC
Local oObj			:= 	GeneralClass():New()

Local aAreaSA2		:=	SA2->(GetArea())
Local aAreaSM0		:=	SM0->(GetArea())

Default lDesv		:=	.f.

if	SE2->(FieldPos("E2_ZZCNPJ")) <> 0 .and. !Empty(SE2->E2_ZZCNPJ)
	cCGC			:=	SE2->E2_ZZCNPJ
endif

if !Empty(SE2->E2_ZZCNPJ)  
	cEmp := ""    
	if	oObj:PosicionaSM0(cEmpAnt,Alltrim(SE2->E2_ZZCNPJ))		
		cEmp	:=	Capital(SM0->M0_NOMECOM)	
		cEnd	:=	Capital(SM0->M0_ENDCOB)         
		cCid	:=	Capital(Alltrim(SM0->M0_CIDCOB)) + " - " + Upper(Alltrim(SM0->M0_ESTCOB))
		cCep	:=	"CEP " + Transform(SM0->M0_CEPCOB,"@R 99.999-99")   
	else
		SA2->(dbsetorder(3))
		if	SA2->(dbseek( xFilial("SA2") + PadR( Upper(Alltrim(SE2->E2_ZZCNPJ)) , TamSX3("A2_CGC")[1] ) , .f. ))
			cEmp	:=	Capital(Alltrim(SA2->A2_NOME))
			cEnd	:=	Capital(SA2->A2_END)         
			cCid	:=	Capital(Alltrim(SA2->A2_MUN)) + " - " + Upper(Alltrim(SA2->A2_EST))
			cCep	:=	"CEP " + Transform(SA2->A2_CEP,"@R 99.999-99")
		else
			RestArea(aAreaSM0)  
			RestArea(aAreaSA2)  
			cEmp	:=	Capital(SM0->M0_NOMECOM)	
			cEnd	:=	Capital(SM0->M0_ENDCOB)         
			cCid	:=	Capital(Alltrim(SM0->M0_CIDCOB)) + " - " + Upper(Alltrim(SM0->M0_ESTCOB))
			cCep	:=	"CEP " + Transform(SM0->M0_CEPCOB,"@R 99.999-99")        
		endif
	endif	
endif

Define Font oFont 	Name "Tahoma" Size 0, -11 
Define Font oBold 	Name "Tahoma" Size 0, -11 Bold
Define Font oBld2 	Name "Tahoma" Size 0, -13 Bold
Define Font oBig1 	Name "Tahoma" Size 0, -15 Bold    

Setapilha()  		
Define MsDialog oDlg2 Title "Digita็ใo de GPSs" From 000,000 To 0548,0915 Of oMainWnd Pixel Style 128

oDlg2:lEscClose := .f.

@ 000,000 BitMap 			ResName "xGPS" 														Of oDlg2 	Size 804,458 	NoBorder 	When .f. 			Pixel

@ 085,008 Say    oEmp    	Prompt cEmp				       										Of oDlg2 	Size 200,009 	Font oBig1 						Pixel	Color CLR_BLUE 
@ 097,008 Say    oEnd    	Prompt cEnd				       										Of oDlg2 	Size 200,009 	Font oBig1 						Pixel	Color CLR_BLUE 
@ 109,008 Say    oCid    	Prompt cCid				       										Of oDlg2 	Size 200,009 	Font oBig1 						Pixel	Color CLR_BLUE 
@ 121,008 Say    oCep    	Prompt cCep															Of oDlg2 	Size 200,009 	Font oBig1 						Pixel	Color CLR_BLUE 

@ 166,125 MsGet  oVct 		Var dVct 					Picture "@!"							Of oDlg2	Size 072,015 	Font oFont	When .f.  			Pixel	Colors 0,16777215	

@ 006,377 MsGet  oRet 		Var cRet 	       			Picture "@r 9999"						Of oDlg2	Size 072,013 	Font oFont	When .t.  			Pixel	Colors 0,16777215	Valid Empty(cRet) .or. Len(Alltrim(cRet)) == 4
@ 028,377 MsGet  oPer 		Var cPer 					Picture "@r 99/9999"					Of oDlg2	Size 072,014 	Font oFont	When .t.   			Pixel	Colors 0,16777215	Valid Empty(cPer) .or. xValid(@cPer)

@ 050,377 MsGet  oCGC 		Var cCGC 					Picture "@r 99.999.999/9999-99"			Of oDlg2	Size 072,015 	Font oFont	When .t.			Pixel	Colors 0,16777215	Valid Empty(cCGC) .or. ( CGC(cCGC) .and. xNome(@oEmp,@cEmp,@cCGC,@oEnd,@cEnd,@oCid,@cCid,@oCep,@cCep) ) 	 	
@ 073,377 MsGet  oVlr 		Var nVlr 					Picture "@e 999,999,999.99"				Of oDlg2	Size 072,014 	Font oFont	When .t.  			Pixel	Colors 0,16777215	Valid nVlr >= 0 

@ 102,280 Say    xCei    	Prompt "Numero CEI"													Of oDlg2 	Size 080,009 	Font oBld2 						Pixel	Color CLR_BLUE 
@ 096,377 MsGet  oCei 		Var cCei  	           		Picture "@r 99.999.99999/99" 	      	Of oDlg2	Size 072,015 	Font oFont	When .t. 			Pixel	Colors 0,16777215	Valid Empty(cCei) .or. fValidCEI(cCei) 

@ 143,377 MsGet  oEnc 		Var nEnc 					Picture "@e 999,999,999.99"				Of oDlg2	Size 072,014 	Font oFont	When .t.  			Pixel	Colors 0,16777215	Valid nEnc >= 0 
@ 166,377 MsGet  oMul 		Var nMul 					Picture "@e 999,999,999.99"				Of oDlg2	Size 072,015 	Font oFont	When .t.  			Pixel	Colors 0,16777215	Valid nMul >= 0 
@ 196,377 MsGet  oTot 		Var nTot 					Picture "@e 999,999,999.99"				Of oDlg2	Size 072,015 	Font oFont	When .f.			Pixel	Colors 0,16777215	ReadOnly	 	

oTButton1	:= 	tButton():New(240,369,"Sair"	   ,oDlg2,{ || Eval(bNo) },77,25,,,.f.,.t.,.f.,,.f.,,,.f.)
oTButton2	:= 	tButton():New(240,287,"Confirma"   ,oDlg2,{ || Eval(bOk) },77,25,,,.f.,.t.,.f.,,.f.,,,.f.)
oTButton3	:= 	tButton():New(240,205,"Desvincular",oDlg2,{ || Eval(bDs) },77,25,,,.f.,.t.,.f.,,.f.,,,.f.)

if	!lDesv
	oTButton3:Disable()
endif

oTot:Disable()

Activate MsDialog oDlg2 Centered
Setapilha()		

if	lOk == Nil
	aRet	:=	{ 2 }
elseif	lOk
	aRet	:=	{ 1 , cRet , cPer , cCGC , nVlr , nEnc , nMul , cCei }
else
	aRet	:=	{ 0 }
endif

RestArea(aAreaSA2)
RestArea(aAreaSM0)

Return ( aRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXDIGDARF  บAutor  ณMicrosiga           บ Data ณ  11/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fValidAll(dVct,cRet,cPer,cCGC,nTot,nVlr,nEnc,nMul)  

Local lRet		:=	.f.

if	Empty(dVct)	
	Alert("Preencha a data de vencimento.")
elseif	dVct <> DataValida(dVct,.f.)
	Alert("A data de vencimento nใo ้ dia ๚til.")
elseif	Empty(Alltrim(cRet))
	Alert("Preencha o c๓digo da receita.")
elseif	Empty(Alltrim(cPer))
	Alert("Preencha o perํodo de apura็ใo.")
elseif	Empty(Alltrim(cCGC))
	Alert("Preencha o CNPJ")
elseif	nTot <> nVlr + nEnc + nMul  
	Alert("Preencha os valores corretamente.")
else
	lRet :=	.t.
endif     

Return ( lRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXDIGDARF  บAutor  ณMicrosiga           บ Data ณ  11/09/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xValid(cPer)  

Local lRet := .f.

if	Empty(Alltrim(cPer))
	lRet := .t.
elseif	Len(Alltrim(StrTran(cPer,"/",""))) < 6 
	Return ( .f. )
elseif	Substr(StrTran(cPer,"/",""),01,02) < '01' .or. Substr(StrTran(cPer,"/",""),01,02) > '12' 
	Alert("Preencha o m๊s do perํodo de apura็ใo corretamente.")
elseif Val(Substr(StrTran(cPer,"/",""),03,04)) < 2000 .or. Val(Substr(StrTran(cPer,"/",""),03,04)) > 2050
	Alert("Preencha o ano do perํodo de apura็ใo corretamente.")
else
	lRet := .t.
endif

Return ( lRet )
                
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXDIGGPS   บAutor  ณMicrosiga           บ Data ณ  02/03/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fValidCEI(cCei)

Local w
Local cTot
Local nTot		:=	0
Local lRet		:=	.t.    
Local aPesos	:=	{7,4,1,8,5,2,1,6,3,7,4}

if	Len(Alltrim(cCei)) == 12
	For w := 1 to 11	
		nTot += Val(Substr(cCei,w,01)) * aPesos[w]
	Next w 
	cTot := Alltrim(Str(nTot))	
	nTot := 0
	For w := 1 to Len(cTot)
		nTot += Val(Substr(cTot,w,01)) 
	Next w 
	nTot := 10 - nTot                
	cTot := Alltrim(Str(nTot))
	if	nTot <> Val(Substr(cCei,12,01))
		lRet := MsgYesNo("O digito verificar nใo confere. Confirma ?")
	endif
else
	lRet := .f.
endif

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSimDarf  บAutor  ณMicrosiga           บ Data ณ  10/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDigita็ใo do DARF SIMPLES                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xNome(oEmp,cEmp,cCGC,oEnd,cEnd,oCid,cCid,oCep,cCep)

Local lRet			:=	.t.
Local aAreaSA2		:=	SA2->(GetArea())
Local aAreaSM0		:=	SM0->(GetArea())
Local oObj			:= 	GeneralClass():New()

cEmp := ""

if	oObj:PosicionaSM0(cEmpAnt,Alltrim(cCGC))		
	cEmp	:=	Capital(SM0->M0_NOMECOM)	
	cEnd	:=	Capital(SM0->M0_ENDCOB)         
	cCid	:=	Capital(Alltrim(SM0->M0_CIDCOB)) + " - " + Upper(Alltrim(SM0->M0_ESTCOB))
	cCep	:=	"CEP " + Transform(SM0->M0_CEPCOB,"@R 99.999-99")   
else
	SA2->(dbsetorder(3))
	if	SA2->(dbseek( xFilial("SA2") + PadR( Upper(Alltrim(cCGC)) , TamSX3("A2_CGC")[1] ) , .f. ))
		cEmp	:=	Capital(Alltrim(SA2->A2_NOME))
		cEnd	:=	Capital(SA2->A2_END)         
		cCid	:=	Capital(Alltrim(SA2->A2_MUN)) + " - " + Upper(Alltrim(SA2->A2_EST))
		cCep	:=	"CEP " + Transform(SA2->A2_CEP,"@R 99.999-99")
	else
    	lRet := .f.
    	Alert("Nใo foi encontrado o fornecedor digitado")
	endif
endif	

RestArea(aAreaSA2)
RestArea(aAreaSM0)

Return ( lRet )
