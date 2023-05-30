#include "tbiconn.ch"        				                                            		
#include "topconn.ch"         		
#include "protheus.ch"     	
              	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFDIGDARF  บAutor  ณMicrosiga           บ Data ณ  04/23/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function fDigDarf(xFilPsq,lDesv)    		  		

Local aRet			:=	{}
Local xFilAnt		:=	cFilAnt
Local aAreaSM0		:=	SM0->(GetArea())
Local oObj			:= 	GeneralClass():New()

if !Empty(xFilPsq)
	oObj:PosicionaSM0(cEmpAnt,xFilPsq)	
	cFilAnt := xFilPsq
endif

aRet 	:= 	xFuncao(lDesv)
cFilAnt	:=	xFilAnt

RestArea(aAreaSM0)

Return ( aRet )          

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFDIGDARF  บAutor  ณMicrosiga           บ Data ณ  04/23/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xFuncao(lDesv)   		

Local oNum
Local xPgt
Local oPgt
Local oEmp
Local oPer
Local oCGC    
Local oVlr                
Local oRet
Local oTot
Local oVct
Local oMul
Local oEnc
Local oBig1
Local oDlg2
Local oFont
Local oBold
Local oBld2   
Local oTButton1	
Local oTButton2   
Local oTButton3   

Local aAreaSA2		:=	SA2->(GetArea())
Local aAreaSM0		:=	SM0->(GetArea())

Local lOk			:=	.f.     
Local bDs			:=	{ || lOk := Nil , oDlg2:End() }
Local bNo			:=	{ || lOk := .f. , oDlg2:End() }
Local bOk			:=	{ || lOk := .t. , iif( fValidAll(dPer,cCGC,cRet,cNum,dVct,nVlr,nMul,nEnc,nTot,xTot,@xAcr,@xDec) , oDlg2:End() , lOk := .f. )	}

Local xAcr			:=	00
Local xDec			:=	00

Local aRet			:=	{}
Local dPer			:=	SE2->E2_ZZDTAP	
Local cRet			:=	SE2->E2_CODRET 
Local cNum			:=	SE2->E2_IDDARF			
Local dVct			:=	SE2->E2_ZZDTVC		
Local nVlr			:=	SE2->E2_ZZVLPR		
Local nMul			:=	SE2->E2_ZZVLMT		
Local nEnc			:=	SE2->E2_ZZVLJR		
Local dPgt			:=	SE2->E2_VENCREA
Local oObj			:= 	GeneralClass():New()
Local cEmp			:=	Capital(SM0->M0_NOMECOM)	    
Local nTot			:=	SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC
Local xTot			:=	SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC
Local cCGC			:=	iif( Empty(SE2->E2_ZZCNPJ) , iif( Empty(SuperGetMv("ZZ_PADDARF",.f.,"")) , SM0->M0_CGC , SuperGetMv("ZZ_PADDARF",.f.,"") ) , SE2->E2_ZZCNPJ )

Default lDesv		:=	.f.

if !Empty(SE2->E2_ZZCNPJ) .or. !Empty(SuperGetMv("ZZ_PADDARF",.f.,""))
	cEmp := ""
	xCGC := iif( Empty(SE2->E2_ZZCNPJ) , SuperGetMv("ZZ_PADDARF",.f.,"") , SE2->E2_ZZCNPJ )     
	if	oObj:PosicionaSM0(cEmpAnt,Alltrim(xCGC))		
       	cEmp := Capital(Alltrim(SM0->M0_NOMECOM)) 
	else
		SA2->(dbsetorder(3))
		if	SA2->(dbseek( xFilial("SA2") + PadR( Upper(Alltrim(xCGC)) , TamSX3("A2_CGC")[1] ) , .f. ))
	    	cEmp := Capital(Alltrim(SA2->A2_NOME))
		else
			RestArea(aAreaSM0)  
			RestArea(aAreaSA2)  
	    	cEmp := Capital(SM0->M0_NOMECOM)	
		endif
	endif	
	RecLock("SE2",.f.)
		SE2->E2_ZZCNPJ	:=	xCGC	
	MsUnlock("SE2")	
endif

Define Font oFont 	Name "Tahoma" Size 0, -11 
Define Font oBold 	Name "Tahoma" Size 0, -11 Bold
Define Font oBld2 	Name "Tahoma" Size 0, -13 Bold
Define Font oBig1 	Name "Tahoma" Size 0, -15 Bold    

Setapilha()  		
Define MsDialog oDlg2 Title "Digita็ใo de DARFs" From 000,000 To 0440,785 Of oMainWnd Pixel Style 128

oDlg2:lEscClose :=	.f.

@ 000,000 BitMap 			ResName "xDARF" 										Of oDlg2 	Size 804,458 	NoBorder 	When .f. 			Pixel

@ 085,012 Say    oEmp    	Prompt cEmp				       							Of oDlg2 	Size 200,009 	Font oBig1 						Pixel	Color CLR_BLUE 
 
@ 015,291 MsGet  oPer 		Var dPer 		Picture "@!"							Of oDlg2	Size 094,010 	Font oFont						Pixel	Colors 0,16777215	
@ 032,291 MsGet  oCGC 		Var cCGC 		Picture "@r 99.999.999/9999-99"			Of oDlg2	Size 094,010 	Font oFont	When .t.			Pixel	Colors 0,16777215	Valid Empty(cCGC) .or. ( CGC(cCGC) .and. xNome(@oEmp,@cEmp,@cCGC) ) 
@ 050,291 MsGet  oRet 		Var cRet		Picture "@r 9999"						Of oDlg2	Size 094,010 	Font oFont						Pixel	Colors 0,16777215	
@ 067,291 MsGet  oNum 		Var cNum 		Picture "@!"							Of oDlg2	Size 094,010 	Font oFont						Pixel	Colors 0,16777215	 	
@ 085,291 MsGet  oVct 		Var dVct 		Picture "@!"							Of oDlg2	Size 094,010 	Font oFont						Pixel	Colors 0,16777215	
@ 103,291 MsGet  oVlr 		Var nVlr 		Picture "@e 999,999,999.99"				Of oDlg2	Size 094,010 	Font oFont						Pixel	Colors 0,16777215	Valid nVlr >= 0 .and. xAtuVlr(@oVlr,@nVlr,@oMul,@nMul,@oEnc,@nEnc,@oTot,@nTot) 
@ 120,291 MsGet  oMul 		Var nMul 		Picture "@e 999,999,999.99"				Of oDlg2	Size 094,010 	Font oFont						Pixel	Colors 0,16777215	Valid nMul >= 0 .and. xAtuVlr(@oVlr,@nVlr,@oMul,@nMul,@oEnc,@nEnc,@oTot,@nTot) 
@ 138,291 MsGet  oEnc 		Var nEnc 		Picture "@e 999,999,999.99"				Of oDlg2	Size 094,010 	Font oFont						Pixel	Colors 0,16777215	Valid nEnc >= 0 .and. xAtuVlr(@oVlr,@nVlr,@oMul,@nMul,@oEnc,@nEnc,@oTot,@nTot) 
@ 155,291 MsGet  oTot 		Var nTot 		Picture "@e 999,999,999.99"				Of oDlg2	Size 094,010 	Font oFont	When .f.			Pixel	Colors 0,16777215	ReadOnly	 	

@ 184,202 Say    xPgt    	Prompt "Data de Pagamento"     							Of oDlg2 	Size 200,009 	Font oBld2 						Pixel	Color CLR_BLUE 
@ 182,291 MsGet  oPgt 		Var dPgt 		Picture "@!"							Of oDlg2	Size 094,010 	Font oFont	When .f.			Pixel	Colors 0,16777215	ReadOnly

oTButton1	:= 	tButton():New(198,327,"Sair"	   ,oDlg2,{ || Eval(bNo) },58,15,,,.f.,.t.,.f.,,.f.,,,.f.)
oTButton2	:= 	tButton():New(198,265,"Confirma"   ,oDlg2,{ || Eval(bOk) },57,15,,,.f.,.t.,.f.,,.f.,,,.f.)
oTButton3	:= 	tButton():New(198,202,"Desvincular",oDlg2,{ || Eval(bDs) },58,15,,,.f.,.t.,.f.,,.f.,,,.f.)

if !lDesv
	oTButton3:Disable()
endif

oTot:Disable()
oPgt:Disable()

Activate MsDialog oDlg2 Centered
Setapilha()		

if	lOk == Nil
	aRet	:=	{ 2 }
elseif	lOk
	aRet	:=	{ 1 , dPer , cCGC , cRet , cNum , dVct , nVlr , nMul , nEnc , xAcr , xDec }
else
	aRet	:=	{ 0 }
endif     

RestArea(aAreaSA2)
RestArea(aAreaSM0)

Return ( aRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFDIGDARF  บAutor  ณMicrosiga           บ Data ณ  04/23/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fValidAll(dPer,cCGC,cRet,cNum,dVct,nVlr,nMul,nEnc,nTot,xTot,xAcr,xDec)

Local lRet		:=	.f.

xAcr := 0
xDec := 0

if	Empty(dPer)
	Alert("Preencha o perํodo de apura็ใo.")
elseif	Empty(Alltrim(cCGC))
	Alert("Preencha o CNPJ.")
elseif	Empty(Alltrim(cRet))
	Alert("Preencha o c๓digo da receita.")
elseif	Empty(dVct)	
	Alert("Preencha a data de vencimento.")
elseif	nTot <> nVlr + nMul + nEnc 
	Alert("Preencha o valor corretamente.")
elseif	nTot <> xTot .and. nTot > xTot .and. ( SE2->E2_ACRESC <> SE2->E2_SDACRES .or. SE2->E2_DECRESC <> SE2->E2_SDDECRE )
	Alert("Nใo pode ser alterado o acr้scimo/decr้scimo do tํtulo, pois jแ sofreu altera็ใo.")
elseif	nTot <> xTot .and. nTot > xTot
	lRet := MsgYesNo("Serแ adicionado o valor de R$ " + Alltrim(Transform( nTot - xTot , "@e 999,999,999.99" )) + " ao saldo do tํtulo. Confirma ?")   
elseif	nTot <> xTot .and. nTot < xTot .and. ( SE2->E2_ACRESC <> SE2->E2_SDACRES .or. SE2->E2_DECRESC <> SE2->E2_SDDECRE )
	Alert("Nใo pode ser alterado o acr้scimo/decr้scimo do tํtulo, pois jแ sofreu altera็ใo.")
elseif	nTot <> xTot .and. nTot < xTot
	lRet := MsgYesNo("Serแ retirado o valor de R$ " + Alltrim(Transform( xTot - nTot , "@e 999,999,999.99" )) + " do saldo do tํtulo. Confirma ?")
else
	lRet := .t.
endif     

if	lRet
	xAcr := iif( nTot - SE2->E2_SALDO > 0 , nTot - SE2->E2_SALDO , 0 )
	xDec := iif( SE2->E2_SALDO - nTot > 0 , SE2->E2_SALDO - nTot , 0 )
endif

Return ( lRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFDIGDARF  บAutor  ณMicrosiga           บ Data ณ  04/23/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xNome(oEmp,cEmp,cCGC)

Local lRet			:=	.t.
Local aAreaSA2		:=	SA2->(GetArea())
Local aAreaSM0		:=	SM0->(GetArea())
Local oObj			:= 	GeneralClass():New()

cEmp := ""

if	oObj:PosicionaSM0(cEmpAnt,Alltrim(cCGC))		
   	cEmp := Capital(Alltrim(SM0->M0_NOMECOM)) 
else
	SA2->(dbsetorder(3))
	if	SA2->(dbseek( xFilial("SA2") + PadR( Upper(Alltrim(cCGC)) , TamSX3("A2_CGC")[1] ) , .f. ))
    	cEmp := Capital(Alltrim(SA2->A2_NOME))
	else
    	lRet := .f.
    	Alert("Nใo foi encontrado o fornecedor digitado")
	endif
endif	

RestArea(aAreaSA2)
RestArea(aAreaSM0)

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFDIGDARF  บAutor  ณMicrosiga           บ Data ณ  04/23/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xAtuVlr(oVlr,nVlr,oMul,nMul,oEnc,nEnc,oTot,nTot)

nTot := nVlr + nMul + nEnc   

oTot:SetText(nTot)
oTot:Refresh()

Return ( .t. )
