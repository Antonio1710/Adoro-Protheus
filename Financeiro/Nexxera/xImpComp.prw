#include 'topconn.ch'	   			  							 			       												
#include 'protheus.ch'
#include 'fwbrowse.ch'        		  		

#define MB_OK                 00      		   		
#define MB_OKCANCEL           01 	
#define MB_YESNO              04
#define MB_ICONHAND           16
#define MB_ICONQUESTION       32
#define MB_ICONEXCLAMATION    48
#define MB_ICONASTERISK       64

Static lMastra		:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )      			

/*/{Protheus.doc} User Function xImpComp
	Imprime os comprovantes de pagamentos por lote
	@type  Function
	@author Alexandre Zapponi
	@since 19/10/17
	@history ticket 81491 - Abel Babini - 27/12/2022 - Projeto Nexxera - Retorno de baixas
	/*/
User Function xImpComp()   	 

Private cPerg		:= 	"IMPCOMP"    
Private aStruct		:=	SE2->(dbstruct())
Private nRecSA2		:=	Len(aStruct) + 01
Private nRecSE2		:=	Len(aStruct) + 02
Private nRecSE5		:=	Len(aStruct) + 03
Private nRecSEA		:=	Len(aStruct) + 04
Private nPosFlg		:=	Len(aStruct) + 05
Private nPosNom		:=	Len(aStruct) + 06
Private nPosBco		:=	Len(aStruct) + 07
Private nPosAge		:=	Len(aStruct) + 08
Private nPosCon		:=	Len(aStruct) + 09
Private nTipoPg		:=	Len(aStruct) + 10
Private nCodCrd		:=	Len(aStruct) + 11
Private nModImp		:=	Len(aStruct) + 12
Private nModCrd		:=	Len(aStruct) + 13
Private nDatPgt		:=	Len(aStruct) + 14
Private nVlrPgt		:=	Len(aStruct) + 15
Private nCodAut		:=	Len(aStruct) + 16
Private nTamTot		:=	Len(aStruct) + 17      

Private lSql   		:=	"MSSQL"    $ Upper(Alltrim(TcGetDB()))     

if	lMastra == Nil	
	FwMsgRun( Nil , { || lMastra :=	ChecaEmp("MASTRA") } , 'Processando' , "Buscando dados ..." )
endif

if	lMastra
	Return
endif	

ValidPerg()   

if	Pergunte(cPerg,.t.)
	fPainel()            
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณValidPerg บAutor  ณMicrosiga           บ Data ณ  05/28/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณCria as perguntas no SX1                                    บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ValidPerg()  		           

Local oObj		:= 	GeneralClass():New()

oObj:PutSx1(cPerg,"01","Filial de          ","","","mv_ch1","C",TamSx3("E2_FILIAL")[1]	,0,0,"G","","SM0EMP","","","MV_PAR01","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"02","Filial ate         ","","","mv_ch2","C",TamSx3("E2_FILIAL")[1]	,0,0,"G","","SM0EMP","","","MV_PAR02","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"03","Pagamento de       ","","","mv_ch3","D",TamSx3("E2_BAIXA")[1]	,0,0,"G","","      ","","","MV_PAR03","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"04","Pagamento ate      ","","","mv_ch4","D",TamSx3("E2_BAIXA")[1]	,0,0,"G","","      ","","","MV_PAR04","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"05","Banco de           ","","","mv_ch5","C",TamSx3("A6_COD")[1]		,0,0,"G","","SA6   ","","","MV_PAR05","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"06","Agencia de         ","","","mv_ch6","C",TamSx3("A6_AGENCIA")[1]	,0,0,"G","","      ","","","MV_PAR06","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"07","Conta de           ","","","mv_ch7","C",TamSx3("A6_NUMCON")[1]	,0,0,"G","","      ","","","MV_PAR07","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"08","Banco ate          ","","","mv_ch8","C",TamSx3("A6_COD")[1]		,0,0,"G","","SA6   ","","","MV_PAR08","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"09","Agencia ate        ","","","mv_ch9","C",TamSx3("A6_AGENCIA")[1]	,0,0,"G","","      ","","","MV_PAR09","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"10","Conta ate          ","","","mv_cha","C",TamSx3("A6_NUMCON")[1]	,0,0,"G","","      ","","","MV_PAR10","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"11","Bordero de         ","","","mv_chb","C",TamSx3("EA_NUMBOR")[1]	,0,0,"G","","      ","","","MV_PAR11","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"12","Bordero ate        ","","","mv_chc","C",TamSx3("EA_NUMBOR")[1]	,0,0,"G","","      ","","","MV_PAR12","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"13","Fornecedor de      ","","","mv_chd","C",TamSx3("E2_FORNECE")[1]	,0,0,"G","","SA2   ","","","MV_PAR13","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"14","Loja de            ","","","mv_che","C",TamSx3("E2_LOJA")[1]	,0,0,"G","","      ","","","MV_PAR14","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"15","Fornecedor ate     ","","","mv_chf","C",TamSx3("E2_FORNECE")[1]	,0,0,"G","","SA2   ","","","MV_PAR15","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"16","Loja ate           ","","","mv_chg","C",TamSx3("E2_LOJA")[1]	,0,0,"G","","      ","","","MV_PAR16","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAEGEAPPP  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณTela de processamento                                       บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fPainel()

Local oDlg			
Local oQtd			
Local oSay2			
Local oGrid     
Local oMenu
Local aArray
Local cCabec
Local bImprime
Local oTButton1
Local oTButton2

Local aSize   		:= 	MsAdvSize(Nil,.f.,430)
Local aInfo   		:= 	{ aSize[1] , aSize[2] , aSize[3] , aSize[4] , 0 , 0 }
Local aObjects		:= 	{{040,040,.t.,.t.},{100,100,.t.,.t.},{020,020,.t.,.t.}}
Local aPosObj 		:= 	MsObjSize(aInfo,aObjects,.f.)
Local nAltu			:=	aPosObj[3,3] - iif( Upper(Alltrim(cVersao)) = "12" , 18 , 0 ) 
Local nLarg			:=	aPosObj[3,4]

Local oNo			:=	LoadBitmap( GetResources() , "LBNO"	)
Local oOk	    	:= 	LoadBitmap( GetResources() , "LBOK"	)

Processa( { || CursorWait() , aArray := {} , fCarga(@aArray) , CursorArrow() } , "Buscando Dados...")     

if 	Len(aArray) == 0
	MessageBox('Nenhum tํtulo foi encontrado para os parโmetros informados.',"Aten็ใo",MB_ICONHAND) 
	Return
endif

Setapilha()
Define MsDialog oDlg Title cCabec From aSize[7],0 To aSize[6],aSize[5] Of oMainWnd Pixel

oDlg:lEscClose 	:= 	.f.                   
oDlg:lMaximized := 	.t.   

Menu oMenu PopUp
	MenuItem "Marca Todos" 			Action Eval( { || aEval( aArray , { |x| x[nPosFlg] := .t.	} ) , oGrid:Refresh() , fAjustaQtd(@nQtd,@oQtd,aArray) 	})
	MenuItem "Desmarca Todos"  		Action Eval( { || aEval( aArray , { |x| x[nPosFlg] := .f. 	} ) , oGrid:Refresh() , fAjustaQtd(@nQtd,@oQtd,aArray)	})
EndMenu

oGrid := TcBrowse():New(003,003,nLarg - 005, nAltu - 010 ,,,,oDlg,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)

oGrid:AddColumn( TcColumn():New( " "    				,{ || iif(aArray[oGrid:nAt,nPosFlg],oOk,oNo)													}	, "@!"								,,,"CENTER"	 	,015,.t.,.f.,,,,.f.,) ) 	// 01
oGrid:AddColumn( TcColumn():New( "Filial"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_FILIAL"))]											}	, PesqPict("SE2","E2_FILIAL")		,,,"CENTER"	 	,027,.f.,.f.,,,,.f.,) )		// 03
oGrid:AddColumn( TcColumn():New( "Prefixo"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_PREFIXO"))]											}	, PesqPict("SE2","E2_PREFIXO")		,,,"CENTER"	 	,033,.f.,.f.,,,,.f.,) )		// 04
oGrid:AddColumn( TcColumn():New( "Numero"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NUM"))]  												}	, PesqPict("SE2","E2_NUM")			,,,"CENTER"	 	,040,.f.,.f.,,,,.f.,) )		// 05
oGrid:AddColumn( TcColumn():New( "Parcela"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_PARCELA"))]  											}	, PesqPict("SE2","E2_PARCELA")		,,,"CENTER"	 	,030,.f.,.f.,,,,.f.,) )		// 06
oGrid:AddColumn( TcColumn():New( "Tipo"    				,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_TIPO"))]  											}	, PesqPict("SE2","E2_TIPO")			,,,"CENTER"	 	,025,.f.,.f.,,,,.f.,) )		// 07
oGrid:AddColumn( TcColumn():New( "Fornecedor"		   	,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_FORNECE"))]											}	, PesqPict("SE2","E2_FORNECE")  	,,,"CENTER" 	,047,.f.,.f.,,,,.f.,) )		// 08
oGrid:AddColumn( TcColumn():New( "Loja"		   			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_LOJA"))]												}	, PesqPict("SE2","E2_LOJA")  		,,,"CENTER"    	,025,.f.,.f.,,,,.f.,) )		// 09
oGrid:AddColumn( TcColumn():New( "Nome Fornecedor"		,{ || aArray[oGrid:nAt,nPosNom]																	}	, PesqPict("SA2","A2_NOME")  		,,,"LEFT" 	 	,150,.f.,.f.,,,,.f.,) )		// 10
oGrid:AddColumn( TcColumn():New( "Dt Pagto"				,{ || aArray[oGrid:nAt,nDatPgt]																	}	, PesqPict("SE2","E2_VENCREA")  	,,,"CENTER"    	,043,.f.,.f.,,,,.f.,) )		// 11
oGrid:AddColumn( TcColumn():New( "Valor Pago"			,{ || aArray[oGrid:nAt,nVlrPgt]						  											}	, PesqPict("SE2","E2_SALDO")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		// 12
oGrid:AddColumn( TcColumn():New( "Banco Pg" 	    	,{ || aArray[oGrid:nAt,nPosBco]																	}	, "@!"                       		,,,"CENTER"	 	,038,.f.,.f.,,,,.f.,) )		// 18
oGrid:AddColumn( TcColumn():New( "Agencia Pg"      		,{ || aArray[oGrid:nAt,nPosAge]																	}	, "@!"                         		,,,"CENTER" 	,040,.f.,.f.,,,,.f.,) )		// 19
oGrid:AddColumn( TcColumn():New( "Conta Pg"  			,{ || aArray[oGrid:nAt,nPosCon]																	}	, "@!"                         		,,,"CENTER" 	,045,.f.,.f.,,,,.f.,) )		// 20
oGrid:AddColumn( TcColumn():New( "Bordero"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NUMBOR"))]  											}	, PesqPict("SE2","E2_NUMBOR")		,,,"CENTER"	 	,038,.f.,.f.,,,,.f.,) )		// 21
oGrid:AddColumn( TcColumn():New( "Modelo"       		,{ || aArray[oGrid:nAt,nModCrd]																	}	,                            		,,,"LEFT" 	 	,050,.f.,.f.,,,,.f.,) )		// 22
oGrid:AddColumn( TcColumn():New( "Vencimento"			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_VENCREA"))]											}	, PesqPict("SE2","E2_VENCTO")  		,,,"CENTER"  	,043,.f.,.f.,,,,.f.,) )		// 28
oGrid:AddColumn( TcColumn():New( "Valor"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_VALOR"))]  											}	, PesqPict("SE2","E2_VALOR")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		// 29
oGrid:AddColumn( TcColumn():New( "Autentica็ใo"			,{ || aArray[oGrid:nAt,nCodAut]																	}	, PesqPict("SA2","A2_NOME")  		,,,"LEFT" 	 	,150,.f.,.f.,,,,.f.,) )		// 10

oGrid:bHeaderClick	:= 	{ |o,x,y|  iif( x == 1 , oMenu:Activate(x,y,oGrid) , fMudaOr(@oDlg,@oGrid,@aArray,x) ) 			}
oGrid:bLDblClick	:=	{ || aArray[oGrid:nAt,nPosFlg] := !aArray[oGrid:nAt,nPosFlg] , fAjustaQtd(@nQtd,@oQtd,aArray)	} 

fCabecO(@oGrid,.t.,0)

oGrid:SetArray(aArray)

nQtd := Len(aArray)	

@ nAltu      	, 003	Say oSay2 			Prompt "Qtde:" 			 							Size 040,007 Of oDlg Colors 0,16777215 	Pixel
@ nAltu - 003	, 023	MsGet oQtd 			Var nQtd 				Picture "@e 999"			Size 020,010 Of oDlg Colors 0,16777215 	Pixel 	ReadOnly

bImprime		:=	{ || FwMsgRun( Nil , { |oObj| fImpCompv( @oObj , @aArray , @oGrid ) } , "Imprimindo" , "Aguarde ..." ) } 
	
oTButton1		:=	tButton():New(nAltu - 2.5,nLarg - 042,"Sair"		,oDlg,{ || oDlg:End() 											},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)  
oTButton2		:=	tButton():New(nAltu - 2.5,nLarg - 087,"Imprimir"	,oDlg,{ || Eval(bImprime)	 , fAjustaQtd(@nQtd,@oQtd,aArray)	},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)  

Activate MsDialog oDlg Centered 
Setapilha()

Return     

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAEGEAPPP  บAutor  ณMicrosiga           บ Data ณ  04/28/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fCabecO(oGrid,lFirst,nColPos) 

Local w
Local cCol		:=	""
Local nColFil	:=	0
Local nColPre	:=	0
Local nColNum	:=	0
Local nColFor	:=	0
Local nColNom	:=	0
Local nColPgt	:=	0
Local nColPag	:=	0
Local nColCta	:=	0
Local nColBor	:=	0
Local nColMod	:=	0
Local aColunas	:=	aClone(oGrid:aColumns)

Default lFirst	:=	.f.                     
Default nColPos	:=	oGrid:nColPos

if	lFirst 

	For w := 1 to Len(aColunas)
		oObj := aColunas[w]
		if	Upper(Alltrim(oObj:cHeading)) == "FILIAL"
			nColFil	:=	w       
		elseif	Upper(Alltrim(oObj:cHeading)) == "PREFIXO"	
			nColPre	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "NUMERO"     
			nColNum	:=	w       
		elseif	Upper(Alltrim(oObj:cHeading)) == "FORNECEDOR"
			nColFor	:=	w       
		elseif	Upper(Alltrim(oObj:cHeading)) == "NOME FORNECEDOR"
			nColNom	:=	w       
		elseif	Upper(Alltrim(oObj:cHeading)) == "DT PAGTO"
			nColPgt	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "VALOR PAGO"
			nColPag	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "CONTA PG"	
			nColCta	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "BORDERO"	
			nColBor	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "MODELO"	
			nColMod	:=	w
	    endif
	Next w 

	oGrid:SetHeaderImage( nColPre 	, "COLDOWN"  )

	oGrid:SetHeaderImage( nColFil 	, "COLRIGHT" )  
	oGrid:SetHeaderImage( nColNum 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColFor 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColNom 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColPgt 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColPag 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColCta 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColBor 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColMod 	, "COLRIGHT" )

else

	For w := 1 to Len(aColunas)
		oObj := aColunas[w]
		if	Upper(Alltrim(oObj:cHeading)) == "FILIAL"
			nColFil	:=	w       
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "PREFIXO"	
			nColPre	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "NUMERO"     
			nColNum	:=	w       
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "FORNECEDOR"
			nColFor	:=	w       
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "NOME FORNECEDOR"
			nColNom	:=	w       
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "DT PAGTO"
			nColPgt	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "VALOR PAGO"
			nColPag	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "CONTA PG"	
			nColCta	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "BORDERO"	
			nColBor	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "MODELO"	
			nColMod	:=	w
			cCol	+=	"/" + StrZero(w,02)
	    endif
	Next w 

	if	StrZero(nColPos,02) $ cCol 

		oGrid:SetHeaderImage( nColFil 	, "COLRIGHT" )  
		oGrid:SetHeaderImage( nColPre 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColNum 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColFor 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColNom 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColPgt 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColPag 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColCta 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColBor 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColMod 	, "COLRIGHT" )
	
		oGrid:SetHeaderImage( nColPos 	, "COLDOWN"  )
	endif   
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAEGEAPPP  บAutor  ณMicrosiga           บ Data ณ  04/28/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMudaOr(oDlg,oGrid,aArray,nColPos) 

Local w
Local nColFil	:=	0
Local nColPre	:=	0
Local nColNum	:=	0
Local nColFor	:=	0
Local nColNom	:=	0
Local nColPgt	:=	0
Local nColPag	:=	0
Local nColCta	:=	0
Local nColBor	:=	0
Local nColMod	:=	0
Local aColunas	:=	aClone(oGrid:aColumns)

Local cCol		:=	""
Local nNum		:=	SE2->(FieldPos("E2_NUM"))	
Local nTip		:=	SE2->(FieldPos("E2_TIPO"))	
Local nLoj		:=	SE2->(FieldPos("E2_LOJA"))	
Local nFil		:=	SE2->(FieldPos("E2_FILIAL"))	
Local nBor		:=	SE2->(FieldPos("E2_NUMBOR"))	
Local nVen		:=	SE2->(FieldPos("E2_VENCREA"))	
Local nPre		:=	SE2->(FieldPos("E2_PREFIXO"))	
Local nPar		:=	SE2->(FieldPos("E2_PARCELA"))	
Local nFor		:=	SE2->(FieldPos("E2_FORNECE"))	

For w := 1 to Len(aColunas)        

	oObj := aColunas[w]

	if	Upper(Alltrim(oObj:cHeading)) == "FILIAL"
		nColFil	:=	w       
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "PREFIXO"	
		nColPre	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "NUMERO"     
		nColNum	:=	w       
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "FORNECEDOR"
		nColFor	:=	w       
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "NOME FORNECEDOR"
		nColNom	:=	w       
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "DT PAGTO"
		nColPgt	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "VALOR PAGO"
		nColPag	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "CONTA PG"	
		nColCta	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "BORDERO"	
		nColBor	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "MODELO"	
		nColMod	:=	w
		cCol	+=	"/" + StrZero(w,02)
    endif

Next w 

if	StrZero(nColPos,02) $ cCol 
	
	if	nColPos == nColFil
		aArray	:=	aSort( aArray ,,, { |x,y| x[nFil] + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nFil] + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColPre
		aArray	:=	aSort( aArray ,,, { |x,y| x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColNum
		aArray	:=	aSort( aArray ,,, { |x,y| x[nNum] + x[nFil] + x[nPre] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nNum] + y[nFil] + y[nPre] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColFor
		aArray	:=	aSort( aArray ,,, { |x,y| x[nFor] + x[nLoj] + DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] < y[nFor] + y[nLoj] + DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] } )
	elseif	nColPos == nColNom
		aArray	:=	aSort( aArray ,,, { |x,y| x[nPosNom] + x[nNum] + x[nFil] + x[nPre] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nPosNom] + y[nNum] + y[nFil] + y[nPre] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColPgt
		aArray	:=	aSort( aArray ,,, { |x,y| DtoS(x[nDatPgt]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < DtoS(y[nDatPgt]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColPag
		aArray	:=	aSort( aArray ,,, { |x,y| StrZero( x[nVlrPgt] * 100 , 20 ) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < StrZero( y[nVlrPgt] * 100 , 20 ) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColCta
		aArray	:=	aSort( aArray ,,, { |x,y| x[nPosBco] + x[nPosAge] + x[nPosCon] + DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nPosBco] + y[nPosAge] + y[nPosCon] + DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColBor
		aArray	:=	aSort( aArray ,,, { |x,y| x[nBor] + x[nTipoPg] + x[nPosBco] + x[nPosAge] + x[nPosCon] + DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nBor] + y[nTipoPg] + y[nPosBco] + y[nPosAge] + y[nPosCon] + DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColMod
		aArray	:=	aSort( aArray ,,, { |x,y| x[nModCrd] + x[nPosBco] + x[nPosAge] + x[nPosCon] + DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nModCrd] + y[nPosBco] + y[nPosAge] + y[nPosCon] + DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	endif
	
	fCabecO(@oGrid,.f.,nColPos)
	
	oGrid:SetArray(aArray)
	oGrid:Refresh()
	
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAEGEAPPP  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณSelecao dos dados                                           บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fCarga(aArray) 		

Local w
Local cQuery	
Local nCount	:=	0
Local nRegCnt	:=	0        
Local cFilTmp	:=	cFilAnt       
Local lSE5Excl	:=	FwModeAccess("SE5") == "E"
Local lSE2Excl	:=	FwModeAccess("SE2") == "E"
Local lSA2Excl	:=	FwModeAccess("SA2") == "E"
Local cFilFwSE5	:= 	FwFilial("SE5")        

cQuery 	:= 	" SELECT SE2.R_E_C_N_O_ AS RECNOSE2 , SE5.R_E_C_N_O_ AS RECNOSE5 , SEA.R_E_C_N_O_ AS RECNOSEA , SA2.R_E_C_N_O_ AS RECNOSA2 "        

cQuery 	+= 	" FROM " + RetSqlName("SE5") + " AS SE5 "

cQuery	+=	" INNER JOIN " + RetSqlName("SE2") + " AS SE2 ON "
cQuery 	+= 		"   SE2.E2_FILIAL                                  >= '" + Replicate(" ",FwSizeFilial())	+ "'   AND "
cQuery 	+= 		"   SE2.E2_FILIAL                                  <= '" + Replicate("Z",FwSizeFilial())	+ "'   AND "
cQuery	+=		"   SE2.E2_PREFIXO                                  = SE5.E5_PREFIXO                               AND "
cQuery	+=		"   SE2.E2_NUM                                      = SE5.E5_NUMERO                                AND "
cQuery	+=		"   SE2.E2_PARCELA                                  = SE5.E5_PARCELA                               AND "
cQuery	+=		"   SE2.E2_TIPO                                     = SE5.E5_TIPO                                  AND " 
cQuery	+=		"   SE2.E2_FORNECE                                  = SE5.E5_CLIFOR                                AND " 
cQuery	+=		"   SE2.E2_LOJA                                     = SE5.E5_LOJA                                  AND " 
cQuery	+=		"   SE2.D_E_L_E_T_                                  = ' '                                              " 

cQuery	+=	" INNER JOIN " + RetSqlName("SEA") + " AS SEA ON "
cQuery 	+= 		"   SEA.EA_FILIAL                                  >= '" + Replicate(" ",FwSizeFilial())	+ "'   AND "
cQuery 	+= 		"   SEA.EA_FILIAL                                  <= '" + Replicate("Z",FwSizeFilial())	+ "'   AND "
cQuery 	+= 		"   SEA.EA_NUMBOR                                  >= '" + mv_par11                      	+ "'   AND "
cQuery 	+= 		"   SEA.EA_NUMBOR                                  <= '" + mv_par12                      	+ "'   AND "
cQuery	+=		"   SEA.EA_PREFIXO                                  = SE2.E2_PREFIXO                               AND "
cQuery	+=		"   SEA.EA_NUM                                      = SE2.E2_NUM                                   AND "
cQuery	+=		"   SEA.EA_PARCELA                                  = SE2.E2_PARCELA                               AND "
cQuery	+=		"   SEA.EA_TIPO                                     = SE2.E2_TIPO                                  AND " 
cQuery	+=		"   SEA.EA_FORNECE                                  = SE2.E2_FORNECE                               AND " 
cQuery	+=		"   SEA.EA_LOJA                                     = SE2.E2_LOJA                                  AND " 
cQuery	+=		"   SEA.EA_CART                                     = 'P'                                          AND " 
cQuery	+=		"   SEA.D_E_L_E_T_                                  = ' '                                              " 

cQuery 	+= 	" INNER JOIN " + RetSqlName("SA2") + " AS SA2 ON "
if	( lSA2Excl .and. lSE2Excl ) .or. ( !lSA2Excl .and. !lSE2Excl )
	cQuery	+=	"   SA2.A2_FILIAL                                   = SE2.E2_FILIAL                                AND "
else
	cQuery	+=	"   SA2.A2_FILIAL                                   = '" + xFilial("SA2") 					+ "'   AND "
endif
if	lSql
	cQuery	+=	"   SA2.A2_COD + SA2.A2_LOJA                       >= '" + mv_par13 + mv_par14				+ "'   AND "		 
	cQuery	+=	"   SA2.A2_COD + SA2.A2_LOJA                       <= '" + mv_par15 + mv_par16 				+ "'   AND "		 
else                                                                                                    	
	cQuery	+=	"   SA2.A2_COD || SA2.A2_LOJA                      >= '" + mv_par13 + mv_par14				+ "'   AND "		 
	cQuery	+=	"   SA2.A2_COD || SA2.A2_LOJA                      <= '" + mv_par15 + mv_par16 				+ "'   AND "		 
endif
cQuery	+=		"   SA2.A2_COD                                      = SE2.E2_FORNECE                               AND "
cQuery	+=		"   SA2.A2_LOJA                                     = SE2.E2_LOJA                                  AND "
cQuery	+=		"   SA2.D_E_L_E_T_                                  = ' '                                              "

cQuery 	+= 	" WHERE "
if	Empty( cFilFwSE5 )
	cQuery	+= 	"   SE5.E5_FILORIG                                 >= '" + mv_par01							+ "'   AND "
	cQuery 	+= 	"   SE5.E5_FILORIG                                 <= '" + mv_par02							+ "'   AND "
else                                                	
	cQuery 	+= 	"   SE5.E5_FILIAL                                  >= '" + mv_par01							+ "'   AND "
	cQuery 	+= 	"   SE5.E5_FILIAL                                  <= '" + mv_par02							+ "'   AND "
endif	
cQuery 	+= 		"   SE5.E5_DATA                                    >= '" + DtoS(mv_par03)					+ "'   AND "
cQuery 	+= 		"   SE5.E5_DATA                                    <= '" + DtoS(mv_par04)					+ "'   AND "    
if	lSql
	cQuery	+=	"   SE5.E5_BANCO + SE5.E5_AGENCIA + SE5.E5_CONTA   >= '" + mv_par05 + mv_par06 + mv_par07	+ "'   AND "    
	cQuery	+=	"   SE5.E5_BANCO + SE5.E5_AGENCIA + SE5.E5_CONTA   <= '" + mv_par08 + mv_par09 + mv_par10	+ "'   AND "    
else
	cQuery	+=	"   SE5.E5_BANCO || SE5.E5_AGENCIA || SE5.E5_CONTA >= '" + mv_par05 + mv_par06 + mv_par07	+ "'   AND "    
	cQuery	+=	"   SE5.E5_BANCO || SE5.E5_AGENCIA || SE5.E5_CONTA <= '" + mv_par08 + mv_par09 + mv_par10	+ "'   AND "    
endif
cQuery	+=		"   SE5.E5_ZZCDAUT                                 <> '" + CriaVar("E5_ZZCDAUT",.f.)		+ "'   AND "    
cQuery	+=		"   SE5.D_E_L_E_T_                                  = ' '                                              " 
cQuery	:=	ChangeQuery(cQuery)

//MemoWrite("e:\temp\xqry.qry",cQuery)

TcQuery cQuery New Alias "XSE2"

Count to nCount   

XSE2->(dbgotop())

ProcRegua(nCount)

do while XSE2->(!Eof())

	IncProc("Registro " + StrZero( ++ nRegCnt,06) + " de " + StrZero(nCount,06))
	
	SA2->(dbgoto(XSE2->RECNOSA2))
	SE2->(dbgoto(XSE2->RECNOSE2))     
	SE5->(dbgoto(XSE2->RECNOSE5))     
	SEA->(dbgoto(XSE2->RECNOSEA))    
	
	if	lSE2Excl
		cFilAnt := SE2->E2_FILIAL   
	elseif	lSE5Excl
		cFilAnt := SE5->E5_FILIAL   
	endif

	if 	TemBxCanc(SE5->(E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA + E5_SEQ))
		dbselectarea("XSE2")
		XSE2->(dbskip())
		Loop
	endif             

	aAdd(aArray,Array(nTamTot))
	
	aArray[Len(aArray),nPosFlg] 	:= 	.t.
	aArray[Len(aArray),nRecSA2] 	:= 	XSE2->RECNOSA2
	aArray[Len(aArray),nRecSE2] 	:= 	XSE2->RECNOSE2
	aArray[Len(aArray),nRecSE5] 	:= 	XSE2->RECNOSE5
	aArray[Len(aArray),nRecSEA] 	:= 	XSE2->RECNOSEA
	aArray[Len(aArray),nPosNom] 	:= 	SA2->A2_NOME
	aArray[Len(aArray),nPosBco] 	:= 	SE5->E5_BANCO
	aArray[Len(aArray),nPosAge] 	:= 	SE5->E5_AGENCIA
	aArray[Len(aArray),nPosCon]		:= 	SE5->E5_CONTA
	aArray[Len(aArray),nTipoPg]		:=	iif( SEA->EA_MODELO $ "01/03/05/41/43" , "Deposito" , iif( SEA->EA_MODELO $ "13/30/31" , "Boleto" , "Tributo" ) )
	aArray[Len(aArray),nCodCrd]		:=	SEA->EA_MODELO  
	aArray[Len(aArray),nModImp] 	:= 	SE2->E2_ZZMODBD			
	aArray[Len(aArray),nModCrd]		:=	""
	aArray[Len(aArray),nDatPgt]		:=	SE5->E5_DATA
	aArray[Len(aArray),nVlrPgt]		:=	SE5->E5_VALOR
	aArray[Len(aArray),nCodAut]		:=	SE5->E5_ZZCDAUT

	For w := 1 to Len(aStruct)
		if	aStruct[w,02] == "M"
			aArray[Len(aArray),w] 	:=	""
		else
			aArray[Len(aArray),w] 	:=	&("SE2->" + AllTrim(aStruct[w,01]))
		endif
	Next w

	if	!Empty(aArray[Len(aArray),nCodCrd])
		if	aArray[Len(aArray),nCodCrd]	==	"01"
			aArray[Len(aArray),nModCrd] := 	"Transferencia"
		elseif	aArray[Len(aArray),nCodCrd]	==	"03"
			aArray[Len(aArray),nModCrd] := 	"DOC"
		elseif	aArray[Len(aArray),nCodCrd]	==	"05"
			aArray[Len(aArray),nModCrd] := 	"Transf. Poup."
		elseif	aArray[Len(aArray),nCodCrd]	==	"13"                                     		
			aArray[Len(aArray),nModCrd] := 	"Concessionaria"
		elseif	aArray[Len(aArray),nCodCrd]	==	"30"
			aArray[Len(aArray),nModCrd] := 	"Mesmo Banco"
		elseif	aArray[Len(aArray),nCodCrd]	==	"31"
			aArray[Len(aArray),nModCrd] := 	"Outro Banco"
		elseif	aArray[Len(aArray),nCodCrd]	==	"41"
			aArray[Len(aArray),nModCrd] := 	"TED"
		elseif	aArray[Len(aArray),nCodCrd]	==	"43"
			aArray[Len(aArray),nModCrd] := 	"TED"
		endif
	endif

	if	!Empty(aArray[Len(aArray),nModImp]) 
		aArray[Len(aArray),nCodCrd]	:=	aArray[Len(aArray),nModImp]
		aArray[Len(aArray),nTipoPg]	:=	"Tributo"   
		if	aArray[Len(aArray),nCodCrd]	==	"16"                                     		
			aArray[Len(aArray),nModCrd] := 	"Darf"
		elseif	aArray[Len(aArray),nCodCrd]	==	"17"                                     		
			aArray[Len(aArray),nModCrd] := 	"Gps"
		elseif	aArray[Len(aArray),nCodCrd]	==	"18"                                     		
			aArray[Len(aArray),nModCrd] := 	"Darf Simples"
		elseif	aArray[Len(aArray),nCodCrd]	==	"19"                                     		
			aArray[Len(aArray),nModCrd] := 	"Trib. Municipais"
		elseif	aArray[Len(aArray),nCodCrd]	==	"22"                                     		
			aArray[Len(aArray),nModCrd] := 	"Gare - SP"
		elseif	aArray[Len(aArray),nCodCrd]	==	"25"                                     		
			aArray[Len(aArray),nModCrd] := 	"Ipva (SP/MG)"
		elseif	aArray[Len(aArray),nCodCrd]	==	"27"                                     		
			aArray[Len(aArray),nModCrd] := 	"Dpvat (SP/MG)"
		elseif	aArray[Len(aArray),nCodCrd]	==	"35"                                     		
			aArray[Len(aArray),nModCrd] := 	"Fgts"
		elseif	aArray[Len(aArray),nCodCrd]	==	"OT" 
			aArray[Len(aArray),nModCrd] := 	"Imp Cod Barras"
		elseif	aArray[Len(aArray),nCodCrd]	==	"TC" 
			aArray[Len(aArray),nModCrd] := 	"Imp Cod Barras"
		elseif	aArray[Len(aArray),nCodCrd]	==	"MT" 
			aArray[Len(aArray),nModCrd] := 	"Multas Transito"
		endif
	endif

	dbselectarea("XSE2")
	XSE2->(dbskip())
enddo

XSE2->(dbclosearea())

cFilAnt	:=	cFilTmp

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPCOMP  บAutor  ณMicrosiga           บ Data ณ  10/26/17   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fAjustaQtd(nQtd,oQtd,aArray)

nQtd := 0 

aEval( aArray , { |x| iif( x[nPosFlg] , nQtd += 1 , Nil ) } )

oQtd:SetText(nQtd)
oQtd:Refresh()

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXCPVMOVBC บAutor  ณMicrosiga           บ Data ณ  06/08/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fImpCompv( oObj , aArray , oGrid )
				
Local w      
Local oDoc
Local nQtd		:=	0
Local nTmp		:=	0
Local xFilAnt	:=	cFilAnt
Local lSE2Excl	:=	FwModeAccess("SE2") == "E"

For w := 1 to Len(aArray)
	if	aArray[w,nPosFlg]
		nQtd ++ 
	endif
Next w 

if	nQtd <= 0 
	Alert("Nใo hแ movimentos marcados para impressใo")
	Return
endif	

For w := 1 to Len(aArray)     

	SA2->(dbgoto(aArray[w,nRecSA2]))
	SE2->(dbgoto(aArray[w,nRecSE2]))
	SE5->(dbgoto(aArray[w,nRecSE5]))
	SEA->(dbgoto(aArray[w,nRecSEA]))

	oObj:cCaption 	:=	SE2->E2_NUM + " - " + SE2->E2_NOMFOR
	ProcessMessages()    		

	if	aArray[w,nPosFlg]  

		nTmp ++

		if	lSE2Excl	
			cFilAnt	:=	SE2->E2_FILIAL
		else
			cFilAnt	:=	SE5->E5_FILORIG
		endif

		U_FINCOMP(@oDoc,.f.,.f.,nQtd == nTmp)

		aArray[w,nPosFlg] := .f.
	endif
Next w 

cFilAnt := xFilAnt

oGrid:Refresh()							    	

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXCADZPC   บAutor  ณMicrosiga           บ Data ณ  08/30/16   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ChecaEmp(cPesq) 

Local lRet	:=	.f.
Local aArea	:=	SM0->(GetArea())

SM0->(dbgotop())
do while SM0->(!Eof())     
	if	SM0->(deleted())
		SM0->(dbskip())
		Loop
	endif
	if	Upper(Alltrim(cPesq)) $ Upper(Alltrim(SM0->M0_NOMECOM))
		lRet := .t. 
	endif
	if	lRet
		Exit
	endif
	SM0->(dbskip())
enddo

RestArea(aArea)

Return ( lRet )
