#include 'topconn.ch'	                                                                		
#include 'fwbrowse.ch'        	   			  			  		
#include 'protheus.ch' 	 				
  		     	    			
#define CSSBOTDS	"QPushButton { color: #000000                  ; " +;      	
					"    border-radius: 3px                        ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #C0C0C0                 } " +;
					"QPushButton:pressed { color: #000000          ; " +;
					"    border-radius: 3px                        ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #C0C0C0                 } " +;
					"QPushButton:Focus{ color: #000000             ; " +; 
					"	 background-color: #C0C0C0                 } " +;
					"QPushButton:Hover{ color: #000000             ; " +;                          
					"    background-color: #C0C0C0                 } "

#define CSSBOTAZ	"QPushButton { color: #FFFFFF                  ; " +;
					"    border-radius: 3px                        ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #1F739E                 } " +;
					"QPushButton:pressed { color: #FFFFFF          ; " +;
					"    border-radius: 3px                        ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #191970                 } " +;
					"QPushButton:Focus{ color: #FFFFFF             ; " +; 
					"	 background-color: #191970                 } " +;
					"QPushButton:Hover{ color: #FFFFFF             ; " +;
					"    background-color: #191970                 } "

#define CSSBOTVM	"QPushButton { color: #FFFFFF                  ; " +;
					"    border-radius: 3px                        ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #FF0000                 } " +;
					"QPushButton:pressed { color: #FFFFFF          ; " +;
					"    border-radius: 3px                        ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #8B0000                 } " +;
					"QPushButton:Focus{ color: #FFFFFF             ; " +; 
					"	 background-color: #8B0000                 } " +;
					"QPushButton:Hover{ color: #FFFFFF             ; " +;
					"    background-color: #8B0000                 } "

#define CSSBOTVD	"QPushButton { color: #FFFFFF                  ; " +;
					"    border-radius: 3px                        ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #228B22                 } " +;
					"QPushButton:pressed { color: #FFFFFF          ; " +;
					"    border-radius: 3px                        ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #006400                 } " +;
					"QPushButton:Focus{ color: #FFFFFF             ; " +; 
					"	 background-color: #006400                 } " +;
					"QPushButton:Hover{ color: #FFFFFF             ; " +;
					"    background-color: #006400                 } "

#define CSSBOTCZ	"QPushButton { color: #FFFFFF                  ; " +;
					"    border-radius: 3px                        ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #6E7D81                 } " +;
					"QPushButton:pressed { color: #FFFFFF          ; " +;
					"    border-radius: 3px                        ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #C0C0C0                 } " +;
					"QPushButton:Focus{ color: #FFFFFF             ; " +; 
					"	 background-color: #C0C0C0                 } " +;
					"QPushButton:Hover{ color: #FFFFFF             ; " +;
					"    background-color: #C0C0C0                 } "

#define MB_OK                 	00      		   		
#define MB_OKCANCEL           	01
#define MB_YESNO              	04           		
#define MB_ICONHAND           	16
#define MB_ICONQUESTION       	32
#define MB_ICONEXCLAMATION    	48
#define MB_ICONASTERISK       	64

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	XPRORPAG
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
//@history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
//@history ticket TI - Antonio Domingos - 31/05/2023 - Ajuste Nova Empresa
User Function xProrPag()    

Local lAdmin		:=	FwIsAdmin(RetCodUsr())      
Local xFilAnt		:=	cFilAnt          
Local xAreaEmp		:=	SM0->(GetArea())
Local lChecaUsr		:=	SuperGetMv("ZZ_RVALUSR",.f.,.f.) 

Private lFiltrar	:=	.f.
Private aFiliais 	:=	FinRetFil()     

if	lChecaUsr
	if	lAdmin .or. ( RetCodUsr() $ SuperGetMv( "ZZ_RUSERS" , .f. , "" ) )
		if 	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
			Begin Transaction 
			fGestao()
			if	MsgYesNo("DisarmTransaction ?")
				DisarmTransaction()
			endif
			End Transaction 
		else 
			fGestao()
		endif 
	else
		MessageBox("Usuแrio nใo autorizado a usar a rotina.","Aten็ใo",MB_ICONHAND) 
	endif
else
	if 	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
		Begin Transaction 
		fGestao()
		if	MsgYesNo("DisarmTransaction ?")
			DisarmTransaction()
		endif
		End Transaction 
	else 
		fGestao()
	endif 
endif

RestArea(xAreaEmp)

cFilAnt := xFilAnt          

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fGestao()

Private aStruct		:=	SE2->(dbstruct())
Private nPosRec		:=	Len(aStruct) + 01
Private nPosFlg		:=	Len(aStruct) + 02
Private nPosNom		:=	Len(aStruct) + 03
Private nPosNew		:=	Len(aStruct) + 04
Private nPosEml		:=	Len(aStruct) + 05
Private nPosSA2		:=	Len(aStruct) + 06           
Private nSeqArr		:=	Len(aStruct) + 07           
Private nPosBor		:=	Len(aStruct) + 08
Private nTamTot		:=	Len(aStruct) + 09           

Private cPerg		:= 	"PRGPGTO"    

dbselectarea("SE2")
dbsetorder(1)

ValidPerg()   

if	Pergunte(cPerg,.t.)

	if !Empty(mv_par07) .and. !(";" $ mv_par07) .and. Len(AllTrim(mv_par07)) >= 2
		MessageBox("Separe os tipos que nใo deseja carregar por um ; (ponto e virgula)","Aten็ใo",MB_ICONHAND) 
		Return
	endif	
	
	if !Empty(mv_par08) .and. !(";" $ mv_par08) .and. Len(AllTrim(mv_par08)) >= 2
		MessageBox("Separe os tipos deseja carregar por um ; (ponto e virgula)","Aten็ใo",MB_ICONHAND) 
		Return
	endif	
	
	fPainel()            

endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ValidPerg()  		  	         

Local nT 		:= 	FwSizeFilial()      
Local nF 		:= 	TamSx3("A2_COD")[1]
Local nL 		:= 	TamSx3("A2_LOJA")[1]
Local oObj		:= 	GeneralClass():New()

oObj:PutSx1(cPerg,"01","Filial de            ","","","mv_ch1","C",nT,0,0,"G","","SM0EMP","","","mv_par01","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"02","Filial ate           ","","","mv_ch2","C",nT,0,0,"G","","SM0EMP","","","mv_par02","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"03","Emissao de           ","","","mv_ch3","D",08,0,0,"G","","      ","","","mv_par03","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"04","Emissao ate          ","","","mv_ch4","D",08,0,0,"G","","      ","","","mv_par04","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"05","Vencimento de        ","","","mv_ch5","D",08,0,0,"G","","      ","","","mv_par05","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"06","Vencimento ate       ","","","mv_ch6","D",08,0,0,"G","","      ","","","mv_par06","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"07","Nใo Trazer Tipos     ","","","mv_ch7","C",21,0,0,"G","","      ","","","mv_par07","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"08","Trazer Apenas Tipos  ","","","mv_ch8","C",21,0,0,"G","","      ","","","mv_par08","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"09","Fornecedor de        ","","","mv_ch9","C",nF,0,0,"G","","SA2   ","","","mv_par09","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"10","Loja de              ","","","mv_cha","C",nL,0,0,"G","","      ","","","mv_par10","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"11","Fornecedor ate       ","","","mv_chb","C",nF,0,0,"G","","SA2   ","","","mv_par11","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"12","Loja ate             ","","","mv_chc","C",nL,0,0,"G","","      ","","","mv_par12","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fPainel()

Local oDlg			
Local oGrid     
Local aArray
Local xArray
Local oTButton1
Local oTButton2
Local oTButton3
Local oTButton4
Local oTButton5
Local oTButton6

Local nOpc			:= 	000
Local oObj			:= 	GeneralClass():New()

Local cCabec       	:=	"Painel de Prorroga็ใo de Vencimentos"

Local aSize   		:= 	MsAdvSize(Nil,.f.,430)
Local aInfo   		:= 	{ aSize[1] , aSize[2] , aSize[3] , aSize[4] , 0 , 0 }
Local aObjects		:= 	{{040,040,.t.,.t.},{100,100,.t.,.t.},{020,020,.t.,.t.}}
Local aPosObj 		:= 	MsObjSize(aInfo,aObjects,.f.)
Local nAltu			:=	aPosObj[3,3] - 18 
Local nLarg			:=	aPosObj[3,4]

Local oVerd    		:=	LoadBitmap( GetResources() , "ENABLE"	)
Local oVerm    		:=	LoadBitmap( GetResources() , "DISABLE"	)
Local oAzul    		:=	LoadBitmap( GetResources() , "BR_AZUL"	)

Processa( { || CursorWait() , aArray := {} , fCarga(@aArray) , xArray := aClone(aArray) , CursorArrow() } , "Buscando Dados...")     

if 	Len(aArray) <= 0
	MessageBox('Nenhum tํtulo foi encontrado para os parโmetros informados.',"Aten็ใo",MB_ICONHAND) 
	Return
endif

Setapilha()
Define MsDialog oDlg Title cCabec From aSize[7],0 To aSize[6],aSize[5] Of oMainWnd Pixel

oDlg:lEscClose 	:= 	.f.                   
oDlg:lMaximized := 	.t.   	

oGrid := TcBrowse():New(003,003,nLarg - 005,nAltu - 010,,,,oDlg,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)

oGrid:AddColumn( TcColumn():New( " "   					,{ || xRetCores(oGrid,aArray,oVerd,oVerm,oAzul)				}	, "@!"								,,,"CENTER"	 	,015,.t.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Filial"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_FILIAL"))]		}	, PesqPict("SE2","E2_FILIAL")		,,,"CENTER"	 	,027,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Prefixo"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_PREFIXO"))]		}	, PesqPict("SE2","E2_PREFIXO")		,,,"CENTER"	 	,033,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Numero"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NUM"))]  			}	, PesqPict("SE2","E2_NUM")			,,,"CENTER"	 	,040,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Parcela"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_PARCELA"))]  		}	, PesqPict("SE2","E2_PARCELA")		,,,"CENTER"	 	,030,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Tipo"    				,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_TIPO"))]  		}	, PesqPict("SE2","E2_TIPO")			,,,"CENTER"	 	,025,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Fornecedor"		   	,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_FORNECE"))]		}	, PesqPict("SE2","E2_FORNECE")  	,,,"CENTER" 	,047,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Loja"		   			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_LOJA"))]			}	, PesqPict("SE2","E2_LOJA")  		,,,"CENTER"    	,025,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Nome Fornecedor"		,{ || aArray[oGrid:nAt,nPosNom]								}	, PesqPict("SA2","A2_NOME")  		,,,"LEFT" 	 	,150,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Vencimento"			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_VENCTO"))]		}	, PesqPict("SE2","E2_VENCTO")  		,,,"CENTER"    	,043,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Valor"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_VALOR"))]  		}	, PesqPict("SE2","E2_VALOR")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Novo Vcto"			,{ || aArray[oGrid:nAt,nPosNew]								}	, PesqPict("SE2","E2_VENCTO")  		,,,"CENTER"    	,043,.f.,.f.,,,,.f.,) )		
oGrid:AddColumn( TcColumn():New( "Bordero"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NUMBOR"))]  		}	, PesqPict("SE2","E2_NUMBOR")		,,,"CENTER"	 	,038,.f.,.f.,,,,.f.,) )	
oGrid:AddColumn( TcColumn():New( "Email"				,{ || Lower(aArray[oGrid:nAt,nPosEml])						}	,   								,,,"LEFT" 	 	,150,.f.,.f.,,,,.f.,) )		

oGrid:bLDblClick	:=	{ || fSelect(@oDlg,@oGrid,@aArray) } 

oGrid:SetArray(aArray)

oTButton1	:=	tButton():New(nAltu - 2.5,nLarg - 042,"Sair"			,oDlg,{ || nOpc := 0 , oDlg:End() 									},040,015,,,.f.,.t.,.f.,,.f.,,,.f.)  
oTButton2	:=	tButton():New(nAltu - 2.5,nLarg - 087,"E-mail"			,oDlg,{ || nOpc := 1 , iif( xValid() , oDlg:End() , nOpc := 0 )		},040,015,,,.f.,.t.,.f.,,.f.,,,.f.)  
oTButton3	:=	tButton():New(nAltu - 2.5,nLarg - 132,"Efetivar"		,oDlg,{ || nOpc := 2 , iif( xValid() , oDlg:End() , nOpc := 0 )		},040,015,,,.f.,.t.,.f.,,.f.,,,.f.)  
oTButton4	:=	tButton():New(nAltu - 2.5,nLarg - 177,"Lote"			,oDlg,{ || xLote(@oDlg,@oGrid,@aArray) 								},040,015,,,.f.,.t.,.f.,,.f.,,,.f.)
oTButton5	:=	tButton():New(nAltu - 2.5,nLarg - 222,"Filtrar"  		,oDlg,{ || xFiltrar(@aArray,@oTButton5,@xArray,@oTButton6,@oGrid,1)	},040,015,,,.f.,.t.,.f.,,.f.,,,.f.)
oTButton6	:=	tButton():New(nAltu - 2.5,nLarg - 267,"Canc. Filtro"	,oDlg,{ || xFiltrar(@aArray,@oTButton5,@xArray,@oTButton6,@oGrid,2)	},040,015,,,.f.,.t.,.f.,,.f.,,,.f.)

oTButton1:SetCss( CSSBOTVM )		
oTButton2:SetCss( CSSBOTAZ )
oTButton3:SetCss( CSSBOTVD )
oTButton4:SetCss( CSSBOTCZ )
oTButton5:SetCss( CSSBOTAZ )
oTButton6:SetCss( CSSBOTDS )

oTButton5:Enable()
oTButton6:Disable()

Activate MsDialog oDlg Centered 
Setapilha()

if 	nOpc == 1
	if	MessageBox("Confirma o envio dos e-mails das altera็๕es dos vencimentos ?","Aten็ใo",MB_YESNO) == 6 
		oObj:FinaMsg( "Enviando e-mails" , "Aguarde" , { || CursorWait() , xEmail(oDlg,oGrid,aArray) , Inkey(01) , CursorArrow() } , 128 )
	endif 
elseif 	nOpc == 2
	if	MessageBox("Confirma a altera็ใo dos vencimentos ?","Aten็ใo",MB_YESNO) == 6 
		oObj:FinaMsg( "Alterando os vencimentos" , "Aguarde" , { || CursorWait() , xExec(oDlg,oGrid,aArray) , Inkey(01) , CursorArrow() } , 128 )
	endif 
endif 

Return     

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xValid() 

Local lRet 	:=	.t.

if	lFiltrar
	MessageBox("Cancele o filtro antes de confirmar a rotina","Aten็ใo",MB_ICONHAND)
	lRet	:=	.f.
endif 

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xFiltrar(aArray,oTButton5,aArrOri,oTButton6,oGrid,nOpc)

Local s         
Local t       
Local w
Local aFiltro	:=	{}
Local cFiltro	:=	""

if	nOpc == 1
	cFiltro		:=	xRetFiltro()
	lFiltrar	:=	.f.	
	if !Empty(cFiltro)	
		For s := 1 to Len(aArray)			
			if	Upper(Alltrim(cFiltro)) $ Upper(Alltrim(aArray[s,nPosNom])) 	
				aAdd( aFiltro , aArray[s] ) 	
			endif	
		Next s 	
		if	Len(aFiltro) == 0 
			MessageBox("Nenhum tํtulo encontrado para o parโmetro informado.","Aten็ใo",MB_ICONHAND)         	
			Return
		else
			aArrOri		:=	aClone(aArray)	
			aArray		:=	aClone(aFiltro)
			lFiltrar	:=	.t.	    
			oGrid:SetArray(aArray)
			oGrid:Refresh()
		endif	
	endif	
	oTButton5:Disable()  
	oTButton5:SetCss( CSSBOTDS )
	oTButton6:Enable()
	oTButton6:SetCss( CSSBOTVM )
elseif	nOpc == 2
	For s := 1 to Len(aArray)	
		For t := 1 to Len(aArrOri)	
			if	aArrOri[t,nSeqArr] == aArray[s,nSeqArr]
				For w := 1 to Len(aArray[s])
					aArrOri[t,w] := aArray[s,w]
				Next w 
			endif
		Next t
	Next s 
	aArray			:=	aClone(aArrOri)
	aArrOri 		:=	{}
	lFiltrar 		:=	.f.    
	oGrid:SetArray(aArray)
	oGrid:Refresh()
	oTButton6:Disable()  
	oTButton6:SetCss( CSSBOTDS )
	oTButton5:Enable()
	oTButton5:SetCss( CSSBOTAZ )
endif

oTButton5:Refresh()  
oTButton6:Refresh()  

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetFiltro()          	

Local oTGet1   
Local oDlgAlt
Local oTButton1           
Local cTGet1		:=	CriaVar("A2_NOME",.f.)
Local oFont 		:= 	tFont():New("Verdana",,14,.t.,.f.)

Define Dialog oDlgAlt Title "Razใo Social" From 000,000 To 070,370 Pixel
oTGet1 		:= 	TGet():New(05,05,bSetGet(cTGet1),oDlgAlt,179,009,"@!",,0,,oFont,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
oTButton1	:= 	TButton():New(020,143,"Ok",oDlgAlt,{ || oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered   

Return ( cTGet1 )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fCarga(aArray) 		

Local w      
Local cQuery	  
Local nCount	:=	0
Local nRegCnt	:=	0     
Local lSE2Excl	:=	FwModeAccess("SE2") == "E"
Local lSA2Excl	:=	FwModeAccess("SA2") == "E"
Local cFilFwSE2	:= 	FwFilial("SE2")            

cQuery 	:= 	" SELECT SE2.R_E_C_N_O_ AS RECNOSE2 , SA2.R_E_C_N_O_ AS RECNOSA2 "        
cQuery 	+= 	" FROM " + RetSqlName("SE2") + " SE2 , " + RetSqlName("SA2") + " SA2 "
cQuery 	+= 	" WHERE "
if	( lSA2Excl .and. lSE2Excl ) .or. ( !lSA2Excl .and. !lSE2Excl )
	cQuery	+=	"   SA2.A2_FILIAL                = SE2.E2_FILIAL                           AND "
else
	cQuery	+=	"   SA2.A2_FILIAL                = '" + xFilial("SA2") 				+ "'   AND "
endif
cQuery	+=		"   SA2.A2_COD                   = SE2.E2_FORNECE                          AND "
cQuery	+=		"   SA2.A2_LOJA                  = SE2.E2_LOJA                             AND "
cQuery	+=		"   SA2.D_E_L_E_T_               = ' '                                     AND "
if	Empty( cFilFwSE2 )
	cQuery 	+= 	"   SE2.E2_FILIAL                = '" + xFilial("SE2")				+ "'   AND "
	cQuery	+= 	"   SE2.E2_FILORIG              >= '" + mv_par01					+ "'   AND "
	cQuery 	+= 	"   SE2.E2_FILORIG              <= '" + mv_par02					+ "'   AND "
else                                                	
	cQuery 	+= 	"   SE2.E2_FILIAL               >= '" + mv_par01					+ "'   AND "
	cQuery 	+= 	"   SE2.E2_FILIAL               <= '" + mv_par02					+ "'   AND "
endif	
cQuery 	+= 		"   SE2.E2_EMISSAO              >= '" + DtoS(mv_par03) 				+ "'   AND "
cQuery 	+= 		"   SE2.E2_EMISSAO              <= '" + DtoS(mv_par04) 				+ "'   AND "   
cQuery 	+= 		"   SE2.E2_VENCREA              >= '" + DtoS(mv_par05) 				+ "'   AND "
cQuery 	+= 		"   SE2.E2_VENCREA              <= '" + DtoS(mv_par06) 				+ "'   AND "   
if !Empty(mv_par08) 
	cQuery 	+= 	"   SE2.E2_TIPO                 IN " + FormatIn(mv_par08,";")		+ "    AND "             	
elseif 	!Empty(mv_par07) 
	cQuery 	+= 	"   SE2.E2_TIPO             NOT IN " + FormatIn(mv_par07,";")		+ "    AND "             	
endif       
cQuery	+=		"   SE2.E2_FORNECE + SE2.E2_LOJA >= '" + mv_par09 + mv_par10		+ "'   AND " 
cQuery	+=		"   SE2.E2_FORNECE + SE2.E2_LOJA <= '" + mv_par11 + mv_par12		+ "'   AND " 
cQuery 	+= 		"   SE2.E2_TIPO              NOT IN  " + FormatIn(MVABATIM,";")		+ "    AND "
cQuery 	+= 		"   SE2.E2_TIPO              NOT IN  " + FormatIn(MVPROVIS,";")		+ "    AND "
cQuery 	+= 		"   SE2.E2_TIPO              NOT IN  " + FormatIn(MV_CPNEG,";")		+ "    AND "
cQuery	+=		"   SE2.E2_TIPO                  <> '" + MVPAGANT					+ "'   AND "
//cQuery	+=	" ( SE2.E2_TIPO                  <> '" + MVPAGANT					+ "'   OR  "
//cQuery	+=	"   SE2.E2_NUMBCO                 = '" + CriaVar("E2_NUMBCO",.f.)	+ "')  AND "
//cQuery 	+= 	"   SE2.E2_NUMBOR                 = '" + CriaVar("E2_NUMBOR",.f.)	+ "'   AND "   
//cQuery 	+= 	"   SE2.E2_PORTADO                = '" + CriaVar("E2_PORTADO",.f.)	+ "'   AND "   
cQuery 	+= 		"   SE2.E2_SALDO                 <=  SE2.E2_VALOR                          AND "   
cQuery 	+= 		"   SE2.E2_ORIGEM                <> 'SIGAEFF'                              AND "
cQuery 	+= 		"   SE2.E2_ORIGEM                <> 'PANELGPS'                             AND "  				
cQuery 	+= 		"   SE2.E2_ORIGEM                <> 'PERDCOMP'                             AND "  				
cQuery 	+= 		"   SE2.E2_IMPCHEQ               <> 'S'                                    AND "                 
cQuery 	+= 		"   SE2.E2_SALDO                  >  0                                     AND "     
cQuery 	+= 		"   SE2.D_E_L_E_T_                = ' '                                        "
if	lSE2Excl .or. !Empty(SE2->E2_FILIAL)
	cQuery	+=	" ORDER BY E2_FILIAL  , E2_FORNECE , E2_LOJA , E2_VENCTO , E2_PREFIXO , E2_NUM , E2_PARCELA , E2_TIPO "
else 
	cQuery	+=	" ORDER BY E2_FILORIG , E2_FORNECE , E2_LOJA , E2_VENCTO , E2_PREFIXO , E2_NUM , E2_PARCELA , E2_TIPO "
endif 

FwMsgRun( Nil , { || CursorWait() , xExecQry(ChangeQuery(@cQuery)) , Inkey(01) , CursorArrow() } , 'Processando' , "Consultando o Banco de Dados ..." )

aEval( SE2->(dbstruct()) , { |x| iif( x[02] <> "C" , TcSetField( "XSE2" , x[01] , x[02] , x[03] , x[04] ) , Nil ) } )

Count to nCount 

XSE2->(dbgotop())

ProcRegua(nCount)

do while XSE2->(!Eof())

	SA2->(dbgoto(XSE2->RECNOSA2))
	SE2->(dbgoto(XSE2->RECNOSE2))     
	
	IncProc("Registro " + StrZero(++ nRegCnt,06) + " de " + StrZero(nCount,06))

	if	lSE2Excl .or. !Empty(SE2->E2_FILIAL)
		cFilAnt	:= 	SE2->E2_FILIAL
	elseif	lSA2Excl 
		cFilAnt	:= 	SE2->E2_FILORIG
	endif	

	aAdd(aArray,Array(nTamTot))
	
	aArray[Len(aArray),nPosFlg] 	:= 	.f.
	aArray[Len(aArray),nTamTot] 	:=	nTamTot
	aArray[Len(aArray),nPosNew] 	:=	CtoD("")
	aArray[Len(aArray),nSeqArr] 	:= 	Len(aArray)
	aArray[Len(aArray),nPosNom] 	:= 	SA2->A2_NOME
	aArray[Len(aArray),nPosEml] 	:= 	SA2->A2_ZZEMLFI
	aArray[Len(aArray),nPosRec] 	:= 	XSE2->RECNOSE2
	aArray[Len(aArray),nPosSA2] 	:= 	XSE2->RECNOSA2
	aArray[Len(aArray),nPosBor] 	:= 	!Empty(SE2->E2_NUMBOR)

	For w := 1 to Len(aStruct)
		if	aStruct[w,02] == "M"
			aArray[Len(aArray),w] 	:=	""
		else
			aArray[Len(aArray),w] 	:=	&("SE2->" + AllTrim(aStruct[w,01]))
		endif
	Next w

	dbselectarea("XSE2")
	XSE2->(dbskip())
enddo

XSE2->(dbclosearea())

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xExecQry(cQuery)

TcQuery cQuery New Alias "XSE2"

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetCores(oGrid,aArray,oVerd,oVerm,oAzul)

Local oRet 	:=	oAzul 

if	aArray[oGrid:nAt,nPosBor]
	oRet	:=	oVerm 
elseif	Empty(aArray[oGrid:nAt,nPosNew])
	oRet	:=	oVerd 
endif

Return ( oRet )      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fSelect(oDlg,oGrid,aArray)  

Local w     
Local dDat
Local oObj     

Local nCol		:=	oGrid:nColPos     

Local nColNew 	:=	0
Local nColEml 	:=	0
Local aColunas	:=	aClone(oGrid:aColumns)

For w := 1 to Len(aColunas)
	oObj := aColunas[w]
	if	Upper(Alltrim(oObj:cHeading)) == "NOVO VCTO"    
		nColNew	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "EMAIL"    
		nColEml	:=	w
    endif
Next w 

if	nCol == nColNew	
	if !aArray[oGrid:nAt,nPosBor] .or. MessageBox("O tํtulo posicionado estแ em border๔. Confirma altera็ใo do vencimento ?","Aten็ใo",MB_YESNO) == 6 
		dDat 						:= 	xNewDate()
		aArray[oGrid:nAt,nPosNew]	:=	dDat	
		oGrid:Refresh()         		
	endif
elseif	nCol == nColEml	
	xNewEml(@oDlg,@oGrid,@aArray)  
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xNewEml(oDlg,oGrid,aArray)  

Local s
Local nLin 		:=	oGrid:nAt	
Local nLoj		:=	SE2->(FieldPos("E2_LOJA"))
Local nFil		:=	SE2->(FieldPos("E2_FILIAL"))
Local nFor		:=	SE2->(FieldPos("E2_FORNECE"))
Local nEml		:=	nPosEml

Local cFil 		:=	aArray[nLin,nFil]
Local cFor 		:=	aArray[nLin,nFor]
Local cLoj 		:=	aArray[nLin,nLoj]		
Local cEml 		:=	Lower(aArray[nLin,nEml])		

Local lPriVez 	:=	.t.
Local lNewEml	:=	.t.
Local cNewEml	:=	xRetMail(cEml,@lNewEml) 	

if	lNewEml 
	if	MsgYesNo("Confirma a altera็ใo do e-mail ?")
		For s := 1 to Len(aArray)
			if	aArray[s,nFil] == cFil
				if	aArray[s,nFor] == cFor
					if	aArray[s,nLoj] == cLoj
						if	lPriVez 
							lPriVez	:=	.f.
							SA2->(dbgoto(aArray[s,nPosSA2]))
							RecLock("SA2",.f.)
								SA2->A2_ZZEMLFI	:=	Lower(cNewEml)
							MsUnlock("SA2")
						endif 
						aArray[s,nEml]	:=	Lower(cNewEml)
					endif 
				endif 
			endif 
		Next s 
		oGrid:SetArray(aArray)
		oGrid:Refresh()
	endif 
endif 

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetMail(cMail,lOk)          	

Local oTGet1   
Local oDlgAlt
Local oTButton1           
Local oFont 		:= 	tFont():New("Verdana",,14,.t.,.f.)
Local cTGet1		:=	PadR(Alltrim(cMail),TamSx3("A2_ZZEMLFI")[1])

do while .t. 

	lOk := .f. 

	Define Dialog oDlgAlt Title "E-mail" From 000,000 To 070,850 Pixel
	oTGet1 		:= 	TGet():New(05,05,bSetGet(cTGet1),oDlgAlt,415,009,"@S200",,0,,oFont,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
	oTButton1	:= 	TButton():New(020,380,"Ok",oDlgAlt,{ || lOK := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
	Activate Dialog oDlgAlt Centered   

	if	lOk 
		if !Empty(cTGet1)
			if	MsgYesNo("Confirma o email digitado ?")
				Exit
			endif 
		endif 
	else 
		Exit 
	endif 

enddo 

Return ( cTGet1 )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xLote(oDlg,oGrid,aArray) 

Local s
Local lBor 	:=	.f.
Local dDat	:=	Nil 

For s := 1 to Len(aArray)		 
	if	aArray[s,nPosBor]	
		lBor 	:=	.t.
		Exit 
	endif 
Next s 

if !lBor .or. MessageBox("Existem tํtulos em border๔. Confirma altera็ใo do vencimento ?","Aten็ใo",MB_YESNO) == 6 
	dDat := xNewDate()
	if !Empty(dDat)
		if	MessageBox("Confirma a atualiza็ใo dos vencimentos com a data " + iif( Empty(dDat) , "em branco" , DtoC(dDat) ) + " ?","Aten็ใo",MB_YESNO) == 6 
			For s := 1 to Len(aArray)		 
				aArray[s,nPosNew]	:=	dDat	
			Next s 
			oGrid:Refresh()         		
		endif
	endif 
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xNewDate()

Local oFont
Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1  

Local lOk			:=	.f.
Local dTGet1		:=	CtoD("")

do while .t.

	lOk		:=	.f.
	dTGet1	:=	CtoD("")

	Define Font oFont Name "Tahoma" Size 0,-11 Bold
	
	Define Dialog oDlgAlt Title "Informe" From 000,000 To 080,200 Pixel
	oSay1		:= 	tSay():Create(oDlgAlt,{|| "Vencimento :" },08,05,,oFont,,,,.t.,Nil,)
	oTGet1 		:= 	tGet():New(05,50,bSetGet(dTGet1),oDlgAlt,047,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
	oTButton1	:= 	tButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
	Activate Dialog oDlgAlt Centered
	
	if	lOk
		if	Empty(dTGet1)   
			if	MessageBox("Confirma o vencimento em branco ?","Aten็ใo",MB_YESNO) == 6 
				Exit
			else
				Loop
			endif		
		else  
			if	dTGet1 < Date()
				MessageBox("O novo vencimento nใo pode ser menor que a data do dia.","Aten็ใo",MB_ICONHAND)
				Loop
			elseif	dTGet1 < mv_par06 
				if	MessageBox("O vencimento digitado ้ menor que o vencimento limite dos tํtulos. Confirma ?","Aten็ใo",MB_YESNO) == 6 
	    			Exit
	    		else
					Loop
				endif		
			elseif dTGet1 <> DataValida(dTGet1) 
				MessageBox("O vencimento deve ser um dia ๚til.","Aten็ใo",MB_ICONHAND)
				Loop
			else						
				Exit
			endif					
		endif					
	else
		dTGet1	:= 	CtoD("")
		Exit
	endif

enddo

Return ( dTGet1 )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xEmail(oDlg,oGrid,aArray) 	

Local s
Local t
Local nPos 
Local lRet 
Local cHtml		:=	""
Local cForn		:=	""
Local cCNPJ		:=	""
Local xNome		:=	""

Local cCC		:=	Space(250)
Local cCCO		:=	Space(250)
Local cPara		:=	Space(250)            

Local aTmp		:=	{}
Local aAnexos	:=	{}

Local oObj		:= 	GeneralClass():New()
Local nLoj		:=	SE2->(FieldPos("E2_LOJA"))	
Local nFil		:=	SE2->(FieldPos("E2_FILIAL"))
Local nFor		:=	SE2->(FieldPos("E2_FORNECE"))

For s := 1 to Len(aArray)
	if !Empty(aArray[s,nPosNew])
		nPos := aScan( aTmp , { |x| x[01] == aArray[s,nFil] .and. x[02] == aArray[s,nFor] .and. x[03] == aArray[s,nLoj] .and. x[04] == aArray[s,nPosNew] } )
		if	nPos <= 0 
			aAdd( aTmp , { aArray[s,nFil] , aArray[s,nFor] , aArray[s,nLoj] , aArray[s,nPosNew] , aArray[s,nPosEml] } )
		endif 
	endif 
Next s 

For t := 1 to Len(aTmp)
	cHtml 	:= 	""
	cForn	:=	""
	cCNPJ	:=	""
	xNome	:=	""
	For s := 1 to Len(aArray)
		if	aArray[s,nFil] == aTmp[t,01]
			if	aArray[s,nFor] == aTmp[t,02] 
				if	aArray[s,nLoj] == aTmp[t,03] 
					if	aArray[s,nPosNew] == aTmp[t,04]
						if !Empty(aArray[s,nPosNew])
							SA2->(dbgoto(aArray[s,nPosSA2]))
							SE2->(dbgoto(aArray[s,nPosRec]))
 							if	Empty(cForn)
								cForn	:=	Alltrim(SA2->A2_NOME)
							endif
 							if	Empty(cCNPJ)
								xRetNomCNPJ(@cCNPJ,@xNome)
							endif
 							if	Empty(cHtml)
								cHtml	+=	fRetCab(aTmp[t,04]) + fCabIte()
							endif
							cHtml		+=	fDetIte() 
						endif 
					endif 
				endif 
			endif 
		endif 
	Next s 	
	if !Empty(cHtml)
		cHtml	+=	'</table>' + CRLF + CRLF + '</br>' + CRLF + CRLF + fRodIte(cCNPJ,xNome)
		cCC		:=	Space(250)
		cCCO	:=	Space(250)
		cPara	:=	PadR( aTmp[t,05] , 250 )
		if 	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
			cPara	:=	"alexandre@zapponi.com.br"
			MemoWrite("c:\temp7\ProrPag.htm",cHtml)
		endif 
		if	oObj:TelaMail(@cPara,@cCC,@cCCO,Nil,.f.,.f.,Nil,Nil,cForn)    
			lRet := oObj:DispMail(	cPara																	,;
									cHtml																	,;
									"Solicitacao de Alteracao de Vencimento"								,;
									Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">"	,;
									aAnexos																	,;
									cCC																		,;
									cCCO																	)
			if !lRet 
				MessageBox("Nใo foi possํvel o envio do email","Aten็ใo",MB_ICONHAND) 
			endif 
		endif 
	endif 
Next t

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xExec(oDlg,oGrid,aArray) 	

Local s

For s := 1 to Len(aArray)
	if !Empty(aArray[s,nPosNew])
		SE2->(dbgoto(aArray[s,nPosRec]))
		RecLock("SE2",.f.)
			SE2->E2_VENCTO	:=	aArray[s,nPosNew]	
			SE2->E2_VENCREA	:=	aArray[s,nPosNew]	
		MsUnlock("SE2")
	endif 
Next s 

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetNomCNPJ(cCNPJ,xNome)

Local aAreaSM0	:=	SM0->(GetArea())
Local cFilSE2	:=	iif( Empty(SE2->E2_FILIAL) , SE2->E2_FILORIG , SE2->E2_FILIAL )

SM0->(dbgotop())

do while SM0->(!Eof())
	if	Upper(Alltrim(SM0->M0_CODIGO)) == Upper(Alltrim(cEmpAnt)) .and. Upper(Alltrim(SM0->M0_CODFIL)) == Upper(Alltrim(cFilSE2))
		xNome	:=	Upper(Alltrim(SM0->M0_NOMECOM))
		cCNPJ	:=	Transform(Alltrim(SM0->M0_CGC),"@r 99.999.999/9999-99")	
	endif 
	SM0->(dbskip())
enddo

RestArea(aAreaSM0)			

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fRetCab(dData)

Local cHtml		:=	""
Local cTexto	:=	"Devido a suspensใo das nossas atividades no final do ano, solicitamos que o vencimento dos tํtulos abaixo sejam prorrogados para o dia " + DtoC(dData) + " , sem acr้scimo de juros."
Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 26/05/2023

cHtml	+=	'<html>' 																																		+ CRLF
cHtml	+=	'<head>' 																																		+ CRLF
cHtml	+=	'<style type="text/css">'																														+ CRLF
cHtml	+=	'Body {' 																																		+ CRLF
cHtml	+=	'	font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt' 																		+ CRLF
cHtml	+=	'}' 																																			+ CRLF
cHtml	+=	'.TableRowBlueDarkMini {' 																														+ CRLF
cHtml	+=	'	background-color: #E4E4E4; color: #FFCC00; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; vertical-align: center' 	+ CRLF
cHtml	+=	'}' 																																			+ CRLF
cHtml	+=	'.TableRowWhiteMini2 {' 																														+ CRLF
cHtml	+=	'	color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; vertical-align: center' 								+ CRLF
cHtml	+=	'}' 																																			+ CRLF
cHtml	+=	'.TableRowWhiteMini3 {' 																														+ CRLF
cHtml	+=	'	color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; vertical-align: center' 								+ CRLF
cHtml	+=	'}' 																																			+ CRLF
cHtml	+=	'.TableRowWhiteMini4 {' 																														+ CRLF
cHtml	+=	'   color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 11px; vertical-align: center; margin: 2px' 					+ CRLF
cHtml	+=	'}' 																																			+ CRLF
cHtml	+=	'.style5 {' 																																	+ CRLF
cHtml	+=	'	color: #19167D; font-weight: bold;' 																										+ CRLF
cHtml	+=	'}' 																																			+ CRLF
cHtml	+=	'.TarjaTopoCor {' 																																+ CRLF
cHtml	+=	'	text-decoration: none;height: 6px; background-color: #6699CC' 																				+ CRLF
cHtml	+=	'}' 																																			+ CRLF
cHtml	+=	'.texto-layer {' 																																+ CRLF
cHtml	+=	'	font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000000; text-decoration: none' 									+ CRLF
cHtml	+=	'}' 																																			+ CRLF
cHtml	+=	'.titulo {' 																																	+ CRLF
cHtml	+=	'	font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #19167D; text-decoration: none; font-weight: bold;' 						+ CRLF
cHtml	+=	'}' 																																			+ CRLF
cHtml	+=	'.texto {' 																																		+ CRLF
cHtml	+=	'	font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; text-decoration: none; font-weight: normal;' 					+ CRLF
cHtml	+=	'}' 																																			+ CRLF
cHtml	+=	'</style>' 																																		+ CRLF
cHtml	+=	'<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">' 																		+ CRLF
cHtml	+=	'<title>.:: Totvs Protheus 12 - Altera็ใo de Vencimento :.</title>'																				+ CRLF
cHtml	+=	'</head>' 																																		+ CRLF
cHtml	+=	'<body>' 																																		+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<div style="padding: 50px;">' 																													+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<table border="0" cellpadding="0" cellspacing="0" height="58" width="100%" align="center">' 													+ CRLF
cHtml	+=	'  <tbody>' 																																	+ CRLF
cHtml	+=	'    <tr>' 																																		+ CRLF
cHtml	+=	'      <td>'																																	+ CRLF
if	alltrim(cEmpAnt) $ _cEmpAt1 //ticket TI - Antonio Domingos - 31/05/2023 
	cHtml	+=	'        <img style="width: 150px; height: 72px;" src="http://intra.cclind.com.br/Content/images/Logo_CCL_Assinatura.gif" border="0"> '		+ CRLF
elseif	cEmpAnt == "02"
	cHtml	+=	'        <img style="width: 180px; height: 44px;" src="http://intra.cclind.com.br/Content/images/checkpt.png" border="0">'					+ CRLF
endif
cHtml	+=	'      </td>'																																	+ CRLF
cHtml	+=	'    </tr>' 																																	+ CRLF
cHtml	+=	'  </tbody>' 																																	+ CRLF
cHtml	+=	'</table>' 																																		+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<table border="0" cellpadding="0" cellspacing="0" height="58" width="100%">'				 													+ CRLF
cHtml	+=	'  <tr>' 																																		+ CRLF
cHtml	+=	'    <td height="72" width="100%">' 																											+ CRLF
cHtml	+=	'      <p align="center"><font face="Tahoma" size="5">Altera็ใo de Vencimento</font>'	 														+ CRLF
cHtml	+=	'    </td>' 																																	+ CRLF
cHtml	+=	'  </tr>' 																																		+ CRLF
cHtml	+=	'  <tr>' 																																		+ CRLF
cHtml	+=	'    <td height="1" class="TarjaTopoCor" colspan="3" width="100%">' 																			+ CRLF
cHtml	+=	'  </tr>' 																																		+ CRLF
cHtml	+=	'</table>' 																																		+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<br>' 																																			+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<p class="TableRowWhiteMini3"><strong>'       																									+ CRLF
cHtml	+=	'Prezado fornecedor,'   																														+ CRLF
cHtml	+=	'</strong></p>'   																																+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<p class="TableRowWhiteMini3"><strong>'       																									+ CRLF
cHtml	+=	cTexto					   																														+ CRLF
cHtml	+=	'</strong></p>'   																																+ CRLF
cHtml	+=	''       																																		+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fCabIte() 

Local cHtml		:= 	""   

cHtml	+=	'<table border="1" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" width="100%">' 									+ CRLF 
cHtml	+=	'  <tr>' 																																								+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="40%" align="center"><b><span class="style5"><span style="font-size: 8pt">Fornecedor </span></span></b></td>' 	+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="08%" align="center"><b><span class="style5"><span style="font-size: 8pt">Prefixo    </span></span></b></td>' 	+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="12%" align="center"><b><span class="style5"><span style="font-size: 8pt">Numero     </span></span></b></td>' 	+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="08%" align="center"><b><span class="style5"><span style="font-size: 8pt">Parcela    </span></span></b></td>' 	+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="10%" align="center"><b><span class="style5"><span style="font-size: 8pt">Emissใo    </span></span></b></td>' 	+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="10%" align="center"><b><span class="style5"><span style="font-size: 8pt">Vencimento </span></span></b></td>' 	+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="12%" align="center"><b><span class="style5"><span style="font-size: 8pt">Valor      </span></span></b></td>' 	+ CRLF
cHtml	+=	'  </tr>' 																																								+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fDetIte()

Local cHtml		:= 	""
Local cValT 	:=	Transform(SE2->E2_VALOR,'@e 999,999,999.99')
Local cForn		:=	Alltrim(SA2->A2_COD) + "/" + Alltrim(SA2->A2_LOJA) + " - " + Alltrim(SA2->A2_NOME)

cHtml	+=	'  <tbody>' 																								   												+ CRLF
cHtml	+=	'    <tr>' 																										   											+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="40%" align="left"  >&nbsp; ' 	+ cForn			 		+ '       </td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="08%" align="center">&nbsp; ' 	+ SE2->E2_PREFIXO		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="12%" align="center">&nbsp; ' 	+ SE2->E2_NUM    		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="08%" align="center">&nbsp; ' 	+ SE2->E2_PARCELA 		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="12%" align="center">&nbsp; ' 	+ DtoC(SE2->E2_EMISSAO)	+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="12%" align="center">&nbsp; ' 	+ DtoC(SE2->E2_VENCTO)	+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="10%" align="right" >       ' 	+ cValT					+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'    </tr>' 																																				+ CRLF
cHtml	+=	'  </tbody>' 																																				+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxProrPag  บAutor  ณMicrosiga           บ Data ณ  29/08/22   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prorroga็ใo de vencimento de pagamento            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fRodIte(cCNPJ,xNome)

Local cHtml	:= 	""
Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 26/05/2023

cHtml	+=	'<p class="TableRowWhiteMini3"><strong>'       																							+ CRLF
cHtml	+=	'Agradecemos pela compreensใo.'       																									+ CRLF
cHtml	+=	'</strong></p>'       																													+ CRLF
cHtml	+=	''       																																+ CRLF
cHtml	+=	'<p class="TableRowWhiteMini4"> <strong>'       																						+ CRLF 
cHtml	+=	xNome								   																									+ CRLF 
cHtml	+=	'</strong></p>'       																													+ CRLF 
cHtml	+=	''       																																+ CRLF
cHtml	+=	'<p class="TableRowWhiteMini4"> <strong>'       																						+ CRLF 
cHtml	+=	cCNPJ						      																										+ CRLF 
cHtml	+=	'</strong></p>'       																													+ CRLF 
cHtml	+=	''       																																+ CRLF
cHtml	+=	'<br>'       																															+ CRLF 
cHtml	+=	''       																																+ CRLF
cHtml	+=	'<table border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#E5E5E5" bgcolor="#F7F7F7" width="100%">' 				+ CRLF
cHtml	+=	'  <tr>' 																																+ CRLF
if	alltrim(cEmpAnt) $ _cEmpAt1 //ticket TI - Antonio Domingos - 31/05/2023 
	cHtml	+=	' <td width="100%" bordercolor="#FFFFFF"><div align="right" class="texto-layer">WorkFlow @ CCL Industries </div></td>' 				+ CRLF
else
	cHtml	+=	' <td width="100%" bordercolor="#FFFFFF"><div align="right" class="texto-layer">WorkFlow @ Checkpoint     </div></td>' 				+ CRLF
endif
cHtml	+=	'  </tr>' 																																+ CRLF
cHtml	+=	'</table>' 																																+ CRLF
cHtml	+=	''       																																+ CRLF
cHtml	+=	'</div>' 																																+ CRLF
cHtml	+=	''       																																+ CRLF
cHtml	+=	'</body>' 																																+ CRLF
cHtml	+=	''       																																+ CRLF
cHtml	+=	'</html>' 																																+ CRLF

Return ( cHtml )
