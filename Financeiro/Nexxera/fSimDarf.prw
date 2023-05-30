#include "tbiconn.ch"        				                                          		
#include "topconn.ch"              		
#include "protheus.ch"   				
          	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSimDarf  บAutor  ณMicrosiga           บ Data ณ  10/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDigita็ใo do DARF SIMPLES                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function fSimDarf(xFilPsq,lDesv)    				
                        	
Local aRet			:=	{}
Local xFilAnt		:=	cFilAnt
Local aAreaSM0		:=	SM0->(GetArea())
Local oObj			:= 	GeneralClass():New()

if	!Empty(xFilPsq)
	oObj:PosicionaSM0(cEmpAnt,xFilPsq)	
	cFilAnt	:=	xFilPsq
endif

aRet 	:= 	xFuncao(lDesv)
cFilAnt	:= 	xFilAnt

RestArea(aAreaSM0)

Return ( aRet )          

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSimDarf  บAutor  ณMicrosiga           บ Data ณ  10/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDigita็ใo do DARF SIMPLES                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xFuncao(lDesv)   		

Local xPgt
Local oPgt
Local oEmp
Local oPri
Local oPer
Local oPrc
Local oCGC    
Local oVlr                
Local oRet
Local oTot
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

Local lOk			:=	.f.     
Local bDs			:=	{ || lOk := Nil , oDlg2:End() }
Local bNo			:=	{ || lOk := .f. , oDlg2:End() }
Local bOk			:=	{ || lOk := .t. , iif( fValidAll(dPer,cCGC,cRet,nVlr,nPrc,nPri,nMul,nEnc,nTot) , oDlg2:End() , lOk := .f. )	}

Local aRet			:=	{}
Local dPer			:=	SE2->E2_ZZDTAP	
Local cCGC			:=	iif( Empty(SE2->E2_ZZCNPJ) , SM0->M0_CGC , SE2->E2_ZZCNPJ )
Local cRet			:=	SE2->E2_CODRET 
Local nVlr			:=	iif( SE2->(FieldPos("E2_ZZPRIS")) <> 0 , SE2->E2_ZZPRIS , 0 )
Local nPrc			:=	iif( SE2->(FieldPos("E2_ZZPRCS")) <> 0 , SE2->E2_ZZPRCS , 0 )
Local nPri			:=	SE2->E2_ZZVLPR		
Local nMul			:=	SE2->E2_ZZVLMT		
Local nEnc			:=	SE2->E2_ZZVLJR		
Local nTot			:=	SE2->E2_SALDO + SE2->E2_ACRESC - SE2->E2_DECRESC
Local dPgt			:=	SE2->E2_VENCREA
Local cEmp			:=	Capital(SM0->M0_NOMECOM)	
Local oObj			:= 	GeneralClass():New()

Local aAreaSA2		:=	SA2->(GetArea())
Local aAreaSM0		:=	SM0->(GetArea())

Default lDesv		:=	.f.       

if !Empty(SE2->E2_ZZCNPJ)  
	cEmp := ""    
	if	oObj:PosicionaSM0(cEmpAnt,Alltrim(SE2->E2_ZZCNPJ))		
       	cEmp := Capital(Alltrim(SM0->M0_NOMECOM)) 
	else
		SA2->(dbsetorder(3))
		if	SA2->(dbseek( xFilial("SA2") + PadR( Upper(Alltrim(SE2->E2_ZZCNPJ)) , TamSX3("A2_CGC")[1] ) , .f. ))
	    	cEmp := Capital(Alltrim(SA2->A2_NOME))
		else
			RestArea(aAreaSM0)  
			RestArea(aAreaSA2)  
	    	cEmp := Capital(SM0->M0_NOMECOM)	
		endif
	endif	
endif

Define Font oFont 	Name "Tahoma" Size 0, -11 
Define Font oBold 	Name "Tahoma" Size 0, -11 Bold
Define Font oBld2 	Name "Tahoma" Size 0, -13 Bold
Define Font oBig1 	Name "Tahoma" Size 0, -15 Bold    

Setapilha()  		
Define MsDialog oDlg2 Title "Digita็ใo de DARF Simples" From 000,000 To 0440,785 Of oMainWnd Pixel Style 128

oDlg2:lEscClose :=	.f.

@ 000,000 BitMap 			ResName "xDARFS" 										Of oDlg2 	Size 804,458 	NoBorder 	When .f. 			Pixel

@ 102,015 Say    oEmp    	Prompt cEmp				       							Of oDlg2 	Size 200,009 	Font oBig1 						Pixel	Color CLR_BLUE 
 
@ 005,298 MsGet  oPer 		Var dPer 		Picture "@!"							Of oDlg2	Size 094,012 	Font oFont						Pixel	Colors 0,16777215	
@ 024,298 MsGet  oCGC 		Var cCGC 		Picture "@r 99.999.999/9999-99"			Of oDlg2	Size 094,012 	Font oFont						Pixel	Colors 0,16777215	Valid Empty(cCGC) .or. ( CGC(cCGC) .and. xNome(@oEmp,@cEmp,@cCGC) )
@ 044,298 MsGet  oRet 		Var cRet		Picture "@r 9999"						Of oDlg2	Size 094,012 	Font oFont						Pixel	Colors 0,16777215	
@ 063,298 MsGet  oVlr 		Var nVlr 		Picture "@e 999,999,999.99"				Of oDlg2	Size 094,012 	Font oFont						Pixel	Colors 0,16777215	Valid nVlr >= 0 
@ 083,298 MsGet  oPrc 		Var nPrc 		Picture "@e 999.99"						Of oDlg2	Size 094,012 	Font oFont						Pixel	Colors 0,16777215	Valid nPrc >= 0 
@ 102,298 MsGet  oPri 		Var nPri 		Picture "@e 999,999,999.99"				Of oDlg2	Size 094,012 	Font oFont						Pixel	Colors 0,16777215	Valid nPri >= 0 
@ 122,298 MsGet  oMul 		Var nMul 		Picture "@e 999,999,999.99"				Of oDlg2	Size 094,012 	Font oFont						Pixel	Colors 0,16777215	Valid nMul >= 0 
@ 141,298 MsGet  oEnc 		Var nEnc 		Picture "@e 999,999,999.99"				Of oDlg2	Size 094,012 	Font oFont						Pixel	Colors 0,16777215	Valid nEnc >= 0 
@ 161,298 MsGet  oTot 		Var nTot 		Picture "@e 999,999,999.99"				Of oDlg2	Size 094,012 	Font oFont	When .f.			Pixel	Colors 0,16777215	ReadOnly	 	

@ 185,204 Say    xPgt    	Prompt "Data de Pagamento"     							Of oDlg2 	Size 200,009 	Font oBld2 						Pixel	Color CLR_BLUE 
@ 182,298 MsGet  oPgt 		Var dPgt 		Picture "@!"							Of oDlg2	Size 094,012 	Font oFont	When .f.			Pixel	Colors 0,16777215	ReadOnly

oTButton1	:= 	tButton():New(201,332,"Sair"	   ,oDlg2,{ || Eval(bNo) },59,15,,,.f.,.t.,.f.,,.f.,,,.f.)
oTButton2	:= 	tButton():New(201,268,"Confirma"   ,oDlg2,{ || Eval(bOk) },60,15,,,.f.,.t.,.f.,,.f.,,,.f.)
oTButton3	:= 	tButton():New(201,205,"Desvincular",oDlg2,{ || Eval(bDs) },59,15,,,.f.,.t.,.f.,,.f.,,,.f.)

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
	aRet	:=	{ 1 , dPer , cCGC , cRet , nVlr , nPrc , nPri , nMul , nEnc }
else
	aRet	:=	{ 0 }
endif

RestArea(aAreaSA2)
RestArea(aAreaSM0)

Return ( aRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณfSimDarf  บAutor  ณMicrosiga           บ Data ณ  10/12/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณDigita็ใo do DARF SIMPLES                                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fValidAll(dPer,cCGC,cRet,nVlr,nPrc,nPri,nMul,nEnc,nTot)

Local lRet		:=	.f.

if	Empty(dPer)
	Alert("Preencha o perํodo de apura็ใo")
elseif	Empty(Alltrim(cCGC))
	Alert("Preencha o CNPJ")
elseif	Empty(Alltrim(cRet))
	Alert("Preencha o c๓digo da receita")
elseif	nVlr <= 0
	Alert("Preencha o valor da receita")
elseif	nPrc <= 0
	Alert("Preencha o percentual")
elseif	nPri <= 0
	Alert("Preencha o valor principal")
elseif ( nPri + nMul + nEnc ) <> nTot 
	Alert("O somat๓rio nใo confere com o valor a pagar")
elseif	Round( ( nVlr * ( nPrc / 100 ) ) , 02 ) <> nPri
	lRet := MsgYesNo("O valor principal nใo confere com o valor da receita multiplicado pelo percentual. Confirma ?")
else
	lRet := .t.
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
