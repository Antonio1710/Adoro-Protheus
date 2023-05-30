#include "topconn.ch"     	  			
#include "protheus.ch"         						
#include "fwmvcdef.ch"  		      	 				
         	  		  		
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

Static lCCL   		:=	Nil    
Static lAdoro		:=	Nil      	
Static lFadel 		:=	Nil
Static lCheck 		:=	Nil
Static lMando 		:=	Nil
Static lMastra		:=	Nil

Static xEmpAtu 		:=	""
Static aFiliais 	:=	{}

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxImpRetSis บAutor  ณMicrosiga          บ Data ณ  07/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ	XIMPRETSIS    		
ฑฑบDesc.     ณImporta o arquivo de retorno SISPAG ou MODELO 2             บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xImpRetSis(xDir,lDir,lAut,xObj,xOBD)     				

Local aRet			:=	{}
Local xFilAnt		:=	cFilAnt
Local xDataBase		:=	dDataBase   
Local xFunName		:=	FunName()  

Local lCont			:=	.f.
Local lCanSave		:=	.t.
Local lUserSave		:=	.t.
Local lCentered		:= 	.t.
Local aCont 		:= 	{ "1=Sim" 	 , "2=Nao"                           }
Local aForma		:= 	{ "1=Titulo" , "2=Tipo de pagamento" , "3=Total" }
Local aPergs		:=	{}  
Local aRetParam		:=	{}        
Local xDiretorio	:=	GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY

Local oObj			:= 	RetornaLicensa():New()
Local dMaxDate		:=	Max(Max(Date(),GetRmtDate()),dDataBase) 
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U"	   

Default xDir		:=	""             
Default lAut		:=	.f.
Default xOBD		:=	.f.													// Apenas o segmento BD
Default lDir		:=	!Empty(xDir)

Private lContPA		:=	Nil

Private cDiretory	:=	"" 
Private lAtivo		:=	SuperGetMv( "ZZ_ATVBOR" , .f. , 'N' ) == "S" .and. AliasInDic("ZAT") .and. AliasInDic("ZAV")

if	lIsBlind .or. lAut 
	lCCL    :=	ChecaEmp("CCL")    	
	lAdoro	:=	ChecaEmp("ADORO")
	lFadel  :=	ChecaEmp("FADEL")  	
	lCheck  :=	ChecaEmp("CHECK")  	
	lMando  :=	ChecaEmp("MANDO") 	
	lMastra :=	ChecaEmp("MASTRA") 			
else
	FwMsgRun( Nil , { || lCCL    :=	ChecaEmp("CCL")    	} , 'Processando' , "Buscando dados ..." )
	FwMsgRun( Nil , { || lAdoro	:=	ChecaEmp("ADORO")  	} , 'Processando' , "Buscando dados ..." )
	FwMsgRun( Nil , { || lFadel  :=	ChecaEmp("FADEL")  	} , 'Processando' , "Buscando dados ..." )
	FwMsgRun( Nil , { || lCheck  :=	ChecaEmp("CHECK")  	} , 'Processando' , "Buscando dados ..." )
	FwMsgRun( Nil , { || lMando  :=	ChecaEmp("MANDO") 	} , 'Processando' , "Buscando dados ..." )
	FwMsgRun( Nil , { || lMastra :=	ChecaEmp("MASTRA") 	} , 'Processando' , "Buscando dados ..." )
endif

if	xEmpAtu <> cEmpAnt 
	xEmpAtu 	:= 	cEmpAnt 
	aFiliais 	:=	FinRetFil()     	    
endif 

if	lCCL .or. lCheck .or. lMastra 
	lAtivo		:=	SuperGetMv( "ZZ_ATVBOR" , .f. , 'N' ) == "S" .and. AliasInDic("Z43") .and. AliasInDic("Z44")
endif

if	lCCL .or. lCheck
	lCont		:=	.t.
else
	lCont		:=	oObj:ChecaEmpSIS()	
endif

if !lCont
	if	dMaxDate >= StoD("20230531")
		Alert("Perํodo de avalia็ใo encerrado") 
		Return
	endif
endif

fChecaPar( "ZZ_BXMVCNC" , "Baixa Movimento ja conciliado                    " 	, "S" 									, "C" )
fChecaPar( "ZZ_FORBXAU" , "Forma de baixa automatica via JOB                " 	, "1" 									, "N" )
fChecaPar( "ZZ_BXACNAB" , "Numero sequencial do lote de pagamento           " 	, "0" 									, "C" )
fChecaPar( "ZZ_GRVOCOR" , "Grava a ocorrencia de retorno no titulo          " 	, "S" 						 			, "C" )
fChecaPar( "ZZ_BXCOLBD" , "Mostra a coluna do bordero                       " 	, iif( lFadel           , "S" , "N" ) 	, "C" )
fChecaPar( "ZZ_MSGERRO" , "Exibe mensagem de erro de leitura do arquivo     " 	, "S" 									, "C" )

fChecaPar( "ZZ_SISPBXA" , "Tipo da Baixa no Retorno do SISPAG               " 	, iif( lAdoro           , "3" , "1" )	, "N" )
fChecaPar( "ZZ_SISPCON" , "Contabilizacao On-Line no Retorno do SISPAG      " 	, iif( lCCL .or. lCheck , "1" , "2" )	, "N" )
fChecaPar( "ZZ_SISPMUL" , "Multipla Natureza no Retorno do SISPAG           " 	, "2"									, "N" )
fChecaPar( "ZZ_SISPMOS" , "Mostra Lancamento Contabil no Retorno do SISPAG  " 	, iif( lCCL .or. lCheck , "1" , "2" )	, "N" )
fChecaPar( "ZZ_SISPAGL" , "Aglutina Lancamento Contabil no Retorno do SISPAG" 	, "2"									, "N" )

dbselectarea("SA6")                  		
dbselectarea("SEE")
dbselectarea("SEA")
dbselectarea("SE2")		

SetFunName("FINA300")	

aAdd( aPergs , { 06 , "Diret๓rio dos Arquivos" 	, ""					, "" 		, "" 	, "" 	, 80 	, .t.	, ""	, Nil	, xDiretorio 	} )
aAdd( aPergs , { 02 , "Baixa por"  				, GetMv("ZZ_SISPBXA")	, aForma	, 90	, '.t.'			, .t.									} )
aAdd( aPergs , { 02 , "Contabiliza On-line"		, GetMv("ZZ_SISPCON") 	, aCont		, 90	, '.t.'			, .t.									} )
aAdd( aPergs , { 02 , "Considera Multipla Nat."	, GetMv("ZZ_SISPMUL") 	, aCont		, 90	, '.t.'			, .t.									} )
aAdd( aPergs , { 02 , "Mostra Lan็. Contabeis"	, GetMv("ZZ_SISPMOS") 	, aCont		, 90	, '.t.'			, .t.									} )
aAdd( aPergs , { 02 , "Aglutina lan็amentos"	, GetMv("ZZ_SISPAGL") 	, aCont		, 90	, '.t.'			, .t.									} )

if	lDir .and. lAut
	if !IsInCallStack("U_XCPCALLGENERAL") 
		Pergunte("XJOBRETTIT",.f.)    		
	endif
	mv_par06 	:= 	mv_par05
	mv_par05 	:= 	mv_par04
	mv_par04 	:= 	mv_par03
	mv_par03 	:= 	mv_par02
	mv_par02 	:= 	mv_par01
	mv_par01 	:= 	Alltrim(xDir)
	mv_par01 	:= 	iif( Substr(mv_par01,Len(mv_par01),01) == "\" , Substr(mv_par01,01,Len(mv_par01) - 1) , mv_par01 )
	cDiretory	:=	mv_par01 
	if	xRead(@aRet,lDir)      		
		fProc(@aRet,lDir,@xObj,lAut,xOBD)
	endif
elseif	lDir
	mv_par01 	:= 	Alltrim(xDir)
	mv_par01 	:= 	iif( Substr(mv_par01,Len(mv_par01),01) == "\" , Substr(mv_par01,01,Len(mv_par01) - 1) , mv_par01 )
	cDiretory	:=	mv_par01 
	mv_par02 	:= 	GetMv("ZZ_FORBXAU")
	mv_par03 	:= 	2
	mv_par04 	:= 	2
	mv_par05 	:= 	2
	mv_par06 	:= 	2
	if	xRead(@aRet,lDir)      		
		fProc(@aRet,lDir,@xObj,lAut,xOBD)
	endif
elseif 	ParamBox( aPergs , "Diretorio dos Arquivos" , @aRetParam , { || .t. } , , lCentered , 0 , 0 , , 'LERARQSIS' , lCanSave , lUserSave )
	mv_par01 	:= 	Alltrim(aRetParam[01])
	mv_par01 	:= 	iif( Substr(mv_par01,Len(mv_par01),01) == "\" , Substr(mv_par01,01,Len(mv_par01) - 1) , mv_par01 )
	cDiretory	:=	mv_par01 
	mv_par02 	:= 	iif( ValType(aRetParam[02]) == "N" , aRetParam[02] , Val(Alltrim(aRetParam[02])) ) 
	mv_par03 	:= 	iif( ValType(aRetParam[03]) == "N" , aRetParam[03] , Val(Alltrim(aRetParam[03])) )
	mv_par04 	:= 	iif( ValType(aRetParam[04]) == "N" , aRetParam[04] , Val(Alltrim(aRetParam[04])) )
	mv_par05 	:= 	iif( ValType(aRetParam[05]) == "N" , aRetParam[05] , Val(Alltrim(aRetParam[05])) )
	mv_par06 	:= 	iif( ValType(aRetParam[06]) == "N" , aRetParam[06] , Val(Alltrim(aRetParam[06])) )
	if	xRead(@aRet,lDir)  
		fProc(@aRet,lDir,@xObj,lAut,xOBD)
	endif
endif

SetFunName(xFunName)

dDataBase 	:= 	xDataBase
cFilAnt		:=	xFilAnt

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxImpRetSis บAutor  ณMicrosiga          บ Data ณ  07/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta as tarifas dos extratos bancarios                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRead(aRet,lDir)

Local t
Local oDlg
Local oRep
Local oButAll
Local oButDes
Local oButInv
Local oButPrc
Local oButCan

Local aArq		:= 	Directory( Alltrim(mv_par01) + '\*.*' , "" )                                        			

Local lOk       := 	.f.
Local oNo       := 	LoadBitmap( GetResources(), "LBNO" )
Local oOk       := 	LoadBitmap( GetResources(), "LBOK" )   

For t := 1 to Len(aArq)
	aAdd( aRet , { .t. , Alltrim(aArq[t,01]) , Alltrim(mv_par01) + '\' + Alltrim(aArq[t,01]) } )
Next t    

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
	For t := 1 to Len(aRet)
	//	aRet[t,02]	:=	StrTran(aRet[t,02],"341","320")
	//	aRet[t,03]	:=	StrTran(aRet[t,03],"341","320")
	Next t    
endif

if	lDir
	lOk       	:=	Len(aRet) <> 0
elseif	Len(aRet) <= 0
	Alert("Nใo hแ arquivos a processar no diret๓rio informado")
else
	Define MsDialog oDlg Title "Arquivos" From 000,000 To 450,550 Pixel
	
	oDlg:cTitle := "Selecione o(s) Arquivo(s) a Processar"
	
	oRep := TcBrowse():New(010,010,258,195,,,,oDlg,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)
	
	oRep:AddColumn( TcColumn():New( "  "    	   	,{ || iif(aRet[oRep:nAt,01],oOk,oNo) 	}	, "@!"  		,,,"CENTER"	,020,.t.,.f.,,,,.f.,) )
	oRep:AddColumn( TcColumn():New( "Arquivo"		,{ || aRet[oRep:nAt,02]  				}	, "@!"			,,,"LEFT"	,075,.f.,.f.,,,,.f.,) )     					
	oRep:AddColumn( TcColumn():New( "Caminho"		,{ || aRet[oRep:nAt,03]  				}	, "@!"			,,,"LEFT"  	,200,.f.,.f.,,,,.f.,) )     					
	
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
	
	Activate MsDialog oDlg Centered
endif
	
Return ( lOk )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxImpRetSis บAutor  ณMicrosiga          บ Data ณ  07/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta as tarifas dos extratos bancarios                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fProc(aRet,lDir,xObj,lAut,xOBD)

Local t      
Local s  
Local cSgA
Local lAgt  
Local xAtu
Local xSA6 
Local cArq  
Local xLot
Local nLot
Local xRec
Local xDsc 
Local xJur 
Local xMul 
Local xDat 
Local xPag 
Local xOco  
Local xTot
Local cTip     
Local cSeg                
Local cBco
Local cAge
Local cDAg  
Local cCnv
Local cCon     
Local lFnd    
Local aArq		:=	{}
Local aMov		:=	{}       
Local nSal		:=	000
Local nPss		:=	000
Local xPss		:=	.f.     
Local lSal		:=	.f.
Local xSal		:=	.f.
Local lSgZ		:=	.f.
Local lArq		:=	.f.
Local lCon		:=	.f.
Local lPri		:=	.t.
Local oObj		:= 	GeneralClass():New()
Local lCallGen	:=	FwIsInCallStack("U_XCPCALLGENERAL") 
Local lMsgErro	:=	Upper(Alltrim(GetMv("ZZ_MSGERRO"))) == "S"
Local lIsBlind	:=	IsBlind() .or. Type("__LocalDriver") == "U"	 

Default lDir	:=	.f.                  
Default lAut	:=	.f.                  

Private xArq	:=	""
Private xAgl	:=	.f.
Private xFilBco	:=	cFilAnt 

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
//	lMsgErro	:= 	.t.
endif 

For t := 1 to Len(aRet)
	cBco := ""
	cAge := ""
	cDAg := ""
	cCon := ""
	cCnv := ""
	cSgA := ""
	aArq := {}  
	aMov := {}  
	xLot := 000
	xTot := 000   
	nPss :=	000
	nSal :=	000
	lSal := .f.
	xSal := .f.
	lArq := .f.
	lCon := .f.  
	lPri := .t.        
	xAgl := .f.
	xPss :=	.f.
	xArq :=	aRet[t,02]
	if	aRet[t,01]                  
		if	ValType(xObj) == "O"
			xObj:cCaption := "Arquivo " + Upper(Alltrim(xArq))
			ProcessMessages()    		      
		endif
		if	lDir
			aArq := oObj:ReadArq(aRet[t,03],@lArq) 
		else
			FwMsgRun( Nil , { || aArq := oObj:ReadArq(aRet[t,03],@lArq) } , "Leitura de Arquivo" , "Lendo o arquivo " + Alltrim(aRet[t,02]) )
		endif	
		if	lArq
			if	Len(aArq) <> 0 
				For s := 1 to Len(aArq)  
					xPss :=	.t.
					if	s == 1     
						if	Len(aArq[s]) == 240 .or. Len(aArq[s]) == 242      
							if	Substr(aArq[s],8,1) == "0"
		     					cBco := Substr(aArq[s],001,003)
		     					cCnv := Substr(aArq[s],033,020) 
		     					cAge := Substr(aArq[s],053,005) 
		     					cDAg := Substr(aArq[s],058,001) 
		     					cCon := Substr(aArq[s],059,014)     
		     					xSA6 := 0    
		     					/*
		     					001 - Banco do Brasil
		     					033 - Santander 
		     					104 - Caixa Econ๔mica
		     					237 - Bradesco 
		     					341 - Ita๚
		     					422 - Safra
		     					748 - Sicredi
		     					756 - Sicoob
								*/
		     					if !( cBco $ "001/033/104/237/341/422/748/756" )
									if	lDir .and. !lAut
			     						ConOut("Rotina nใo preparada para o banco " + cBco)
									else
			     						Alert("Rotina nใo preparada para o banco " + cBco)
									endif
		     						Exit
		     					endif
								if	lDir
									lCon := xFindAcc(@cBco,@cAge,cDAg,@cCon,@xSA6,cCnv) 
								else
									FwMsgRun( Nil , { || lCon := xFindAcc(@cBco,@cAge,cDAg,@cCon,@xSA6,cCnv) } , "Cadastro de Bancos" , "Buscando o Banco Pagador" )
        						endif
								if	lCon
									if	SA6->(FieldPos("A6_ZZFLPR")) <> 0 
										if	Empty(SA6->A6_ZZFLPR)
											if	lDir .and. !lAut
												ConOut("Filial do banco nใo informada - Arquivo " + Alltrim(aRet[t,02])) 			
											else
												Alert("Filial do banco nใo informada - Arquivo " + Alltrim(aRet[t,02])) 			
											endif		
											Exit
										else
											cFilAnt := SA6->A6_ZZFLPR
											xFilBco := SA6->A6_ZZFLPR
										endif
									endif                 
								else
									if	lDir .and. !lAut
										ConOut("Banco nใo encontrado - Arquivo " + Alltrim(aRet[t,02])) 			
									else
										Alert("Banco nใo encontrado - Arquivo " + Alltrim(aRet[t,02])) 			
									endif
									Exit
								endif	   
							else
								if	lDir .and. !lAut
									ConOut("O conte๚do do arquivo estแ incorreto - Arquivo " + Alltrim(aRet[t,02])) 			
								else
									Alert("O conte๚do do arquivo estแ incorreto - Arquivo " + Alltrim(aRet[t,02])) 			
								endif
								Exit
							endif	   
						else
							if	lDir .and. !lAut
								ConOut("A estrutura do arquivo estแ incorreta - Arquivo " + Alltrim(aRet[t,02])) 			
							else
								Alert("A estrutura do arquivo estแ incorreta - Arquivo " + Alltrim(aRet[t,02])) 			
							endif
							Exit
						endif        

					elseif	Len(aArq[s]) == 240 .or. Len(aArq[s]) == 242      

						if	Substr(aArq[s],14,01) == "H"
							if	lDir .and. !lAut
								ConOut("O arquivo " + Alltrim(aRet[t,02]) + " estแ com erro de estrutura.") 			
							else
								Alert("O arquivo " + Alltrim(aRet[t,02]) + " estแ com erro de estrutura.") 			
							endif                                                                         
							Exit
						elseif	Substr(aArq[s],14,01) == "G"
							aMov := {}
							nPss := 00		
							if	lDir .and. !lAut
								ConOut("O arquivo " + Alltrim(aRet[t,02]) + " ้ de DDA.") 	     	
							else
								if	ExistBlock("XFINA430")
									if	MsgYesNo("O arquivo " + Alltrim(aRet[t,02]) + " ้ de DDA. Deseja processar ?") 	     	
										U_xFina430(aRet[t,03])
										nPss := 01		
									endif                 
								else
									Alert("O arquivo " + Alltrim(aRet[t,02]) + " ้ de DDA.") 	     	
									nPss := 01		
									Exit
								endif
							endif
							Exit
						endif        

						// BOLETO - SEGMENTO J52

                    	if	Substr(aArq[s],8,1) == "3" .and. Substr(aArq[s],14,01) == "J" .and. Substr(aArq[s],18,02) == "52"
							Loop       
						endif 
						
						if	lSgZ  
							lSgZ :=	.f.
    						if	Substr(aArq[s],014,001) == "Z"
								Loop                          
							endif
						endif
						
						xPag := 0.00
						xDsc := 0.00
						xJur := 0.00
						xMul := 0.00
						lSgZ :=	.f.

						// HEADER DE LOTE 

                    	if	Substr(aArq[s],8,1) == "1"    

                    		nLot := 0
                    		xLot += 1
							lFnd := .f.
                    		cTip := Substr(aArq[s],012,002)
							lSal := Substr(aArq[s],010,002) == "30"             

							if	mv_par02 == 2 .and. !lPri
								xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,'0',nLot,cBco,xSA6,cSeg,.f.,lAut)  
								nPss ++
							endif

							if	mv_par02 == 2
								xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut)
								nPss ++
							endif

							lPri := .f.

						// DOC , TED , TRANSFERENCIA P/ SALARIOS 
						
                    	elseif	Substr(aArq[s],8,1) == "3" .and. Substr(aArq[s],14,01) == "A" .and. lSal

							xOco := Substr(aArq[s],231,010)                               	
							xPag := Substr(aArq[s],163,015)                               	
							xPag := Val(xPag) / 100 
							lFnd := .f.
							
                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"    
								aMov := {} 
								nSal := 00 
								xSal := .f.
								xPss := .f.                    		
								Exit                	
							endif               	
                    	
                    		nSal += iif( Upper(Alltrim(xOco)) == "00" , xPag , 0    )
                    		xSal := iif( Upper(Alltrim(xOco)) == "BD" , .t.  , xSal )

						// DOC , TED , TRANSFERENCIA , PIX
						
                    	elseif	Substr(aArq[s],8,1) == "3" .and. Substr(aArq[s],14,01) == "A"

                            cSeg := Substr(aArq[s],014,001)   
                            xRec := Substr(aArq[s],074,020)  
							xDat := Substr(aArq[s],155,008)                               	
							xPag := Substr(aArq[s],163,015)                               	
							xOco := Substr(aArq[s],231,010)      
							lFnd := .f.                         	

							if	cBco $ "104"	
	                            xRec := Substr(aArq[s],074,006)  
    						endif
    						
							xPag := ( Val(xPag) / 100 )
							xDat := StoD(Substr(xDat,05,04) + Substr(xDat,03,02) + Substr(xDat,01,02))
							
                    		nLot += xPag
                    		xTot += xPag

                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"
								aMov := {} 
								nSal := 00 
								xSal := .f.
								xPss := .f.
								Exit                	
							endif               	

							if	xBuscaTit(xRec)    
								lAgt := SE2->(FieldPos("E2_ZZVLTED")) <> 0 .and. SE2->(FieldPos("E2_ZZSQTED")) <> 0 .and. !Empty(SE2->E2_ZZSQTED) .and. SE2->E2_ZZVLTED > 0                         	
								xAgl := iif( lAgt , .t. , xAgl )
								lFnd := .t.
								xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,lAgt,lAut)      
								nPss ++
        					else    				   	
								if	lDir .and. !lAut
									ConOut("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))
								else
									Alert("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))
								endif
								lSgZ :=	.t.
							endif	

						// BOLETOS
							
                    	elseif	Substr(aArq[s],8,1) == "3" .and. Substr(aArq[s],14,01) == "J"

							cSeg := Substr(aArq[s],014,001)   
							xDsc := Substr(aArq[s],115,015)                               	
							xJur := Substr(aArq[s],130,015)                               	
							xDat := Substr(aArq[s],145,008)                               	
							xPag := Substr(aArq[s],153,015)                               	
                            xRec := Substr(aArq[s],183,020)  
							xOco := Substr(aArq[s],231,010)    
							lFnd := .f.                           	

							if	cBco $ "104"	
	                            xRec := Substr(aArq[s],183,006)  
    						endif

							xDsc := ( Val(xDsc) / 100 ) 
							xJur := ( Val(xJur) / 100 )
							xPag := ( Val(xPag) / 100 )
							xDat := StoD(Substr(xDat,05,04) + Substr(xDat,03,02) + Substr(xDat,01,02))

                    		nLot += xPag
                    		xTot += xPag
                    		
                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"
								aMov := {} 
								nSal := 00 
								xSal := .f.
								xPss := .f.								
								Exit                	
							endif               	

                    		if	xBuscaTit(xRec)                             	
								xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut)
								lFnd := .t.
								nPss ++								
        					else    				   	
								if	lDir .and. !lAut
									ConOut("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))
								else
									Alert("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))
								endif
								lSgZ :=	.t.
							endif	

                  		// IMPOSTOS SEM CODIGO DE BARRAS
                  
                    	elseif	Substr(aArq[s],8,1) == "3" .and. Substr(aArq[s],14,01) == "N" 
                    	
							/* FALTANDO BB
							Tributo GARE SP ICMS  = '22'
							Tributo GARE SP DR    = '23'
							Tributo GARE SP ITCMD = '24
							*/							

							/* FALTANDO SANTANDER
							‘23’ = Tributo - GARE-SP DR
							‘24’ = Tributo - GARE-SP ITCMD
                            */
							
	     					/*
	     					001 - Banco do Brasil
	     					033 - Santander 
	     					104 - Caixa Econ๔mica
	     					237 - Bradesco 
	     					341 - Ita๚
	     					422 - Safra
	     					748 - Sicredi
	     					756 - Sicoob 
							*/

                			// GPS

	                    	if	( cBco == "001" .and. Substr(aArq[s],133,002) == "17" )	.or.  ; 		
	                    		( cBco == "033" .and. Substr(aArq[s],133,002) == "17" )	.or.  ; 		
	                    	  	( cBco == "104" .and. Substr(aArq[s],133,002) == "17" )	.or.  ; 		
	                    	  	( cBco == "237" .and. Substr(aArq[s],133,002) == "17" )	.or.  ; 		
	                    		( cBco == "341" .and. Substr(aArq[s],018,002) == "01" )	.or.  ; 		
								( cBco == "422" .and. Substr(aArq[s],133,002) == "17" )	.or.  ; 			                    		 
								( cBco == "748" .and. Substr(aArq[s],133,002) == "17" )	.or.  ; 			                    		 
	                    		( cBco == "756" .and. Substr(aArq[s],133,002) == "17" ) 
	                            	
	                           	cSeg := Substr(aArq[s],014,001)   
								xMul := Substr(aArq[s],058,014)                               	
								xJur := Substr(aArq[s],072,014)                               	
								xPag := Substr(aArq[s],086,014)                               	
								xDat := Substr(aArq[s],100,008)                               	
	                           	xRec := Substr(aArq[s],196,020)  
								xOco := Substr(aArq[s],231,010)   
								lFnd := .f.                            	

								if	cBco $ "001/033/104/237/422/748/756" 
		                           	xRec := Substr(aArq[s],018,020)  
									xDat := Substr(aArq[s],088,008)                               	
									xPag := Substr(aArq[s],096,015)                               									
									xMul := Substr(aArq[s],156,015)                               	
									xJur := Substr(aArq[s],171,015)                               	
								endif

								xMul := ( Val(xMul) / 100 ) 
								xJur := ( Val(xJur) / 100 )
								xPag := ( Val(xPag) / 100 )
								xDat := StoD(Substr(xDat,05,04) + Substr(xDat,03,02) + Substr(xDat,01,02))
	
	                    		nLot += xPag
	                    		xTot += xPag
	                    		
	                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"
									aMov := {} 
									nSal := 00 
									xSal := .f.
									xPss := .f.									
									Exit                	
								endif               	
	
								if	xBuscaTit(xRec)                             	
									xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut)
									lFnd := .t.
									nPss ++									
	        					else    				   	
									if	lDir .and. !lAut
										ConOut("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))
									else
										Alert("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))
									endif
									lSgZ :=	.t.
								endif	
	
							// DARF
	
	                    	elseif	( cBco == "001" .and. Substr(aArq[s],133,002) == "16" )	.or.  ; 		
	                    	      	( cBco == "033" .and. Substr(aArq[s],133,002) == "16" )	.or.  ; 		
	                    	      	( cBco == "104" .and. Substr(aArq[s],133,002) == "16" )	.or.  ; 		
	                    	      	( cBco == "237" .and. Substr(aArq[s],133,002) == "16" )	.or.  ; 		
	                    			( cBco == "341" .and. Substr(aArq[s],018,002) == "02" )	.or.  ; 		 
	                    	      	( cBco == "422" .and. Substr(aArq[s],133,002) == "16" )	.or.  ; 		
	                    	      	( cBco == "748" .and. Substr(aArq[s],133,002) == "16" )	.or.  ; 		
	                    			( cBco == "756" .and. Substr(aArq[s],133,002) == "16" ) 

								cSeg := Substr(aArq[s],014,001)   
								xMul := Substr(aArq[s],078,014)                               	
								xJur := Substr(aArq[s],092,014)                               	
								xPag := Substr(aArq[s],106,014)                               	
								xDat := Substr(aArq[s],128,008)                               	
	                            xRec := Substr(aArq[s],196,020)  
								xOco := Substr(aArq[s],231,010) 
								lFnd := .f.                              	

								if	cBco $ "001/033/104/237/422/748/756" 
		                           	xRec := Substr(aArq[s],018,020)  
									xDat := Substr(aArq[s],088,008)                               	
									xPag := Substr(aArq[s],096,015)                               									
									xMul := Substr(aArq[s],175,015)                               	
									xJur := Substr(aArq[s],190,015)                               	
								endif

								xMul := ( Val(xMul) / 100 ) 
								xJur := ( Val(xJur) / 100 )
								xPag := ( Val(xPag) / 100 )
								xDat := StoD(Substr(xDat,05,04) + Substr(xDat,03,02) + Substr(xDat,01,02))
	
	                    		nLot += xPag
	                    		xTot += xPag
	                    		
	                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"
									aMov := {} 
									nSal := 00 
									xSal := .f.
									xPss := .f.									
									Exit                	
								endif               	
	
								if	xBuscaTit(xRec)                             	
									xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut)
									lFnd := .t.
									nPss ++
	        					else    	   
									if	lDir .and. !lAut
										ConOut("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))  
									else
										Alert("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))  
									endif
									lSgZ :=	.t.
								endif	
	
							// DARF SIMPLES

	                    	elseif	( cBco == "001" .and. Substr(aArq[s],133,002) == "18" )	.or.  ; 		
	                    	      	( cBco == "033" .and. Substr(aArq[s],133,002) == "18" )	.or.  ; 		
	                    	 		( cBco == "237" .and. Substr(aArq[s],133,002) == "18" )	.or.  ; 		
	                    			( cBco == "341" .and. Substr(aArq[s],018,002) == "03" )	.or.  ; 		
	                    	 		( cBco == "422" .and. Substr(aArq[s],133,002) == "18" )	.or.  ; 		
	                    	 		( cBco == "748" .and. Substr(aArq[s],133,002) == "18" )	.or.  ; 		
	                    			( cBco == "756" .and. Substr(aArq[s],133,002) == "18" ) 
	                            	
	                            cSeg := Substr(aArq[s],014,001)   
								xMul := Substr(aArq[s],078,014)                               	
								xJur := Substr(aArq[s],092,014)                               	
								xPag := Substr(aArq[s],106,014)                               	
								xDat := Substr(aArq[s],128,008)                               	
	                            xRec := Substr(aArq[s],196,020)  
								xOco := Substr(aArq[s],231,010)       
								lFnd := .f.                        	
	
								if	cBco $ "001/033/237/422/748/756" 
		                           	xRec := Substr(aArq[s],018,020)  
									xDat := Substr(aArq[s],088,008)                               	
									xPag := Substr(aArq[s],096,015)                               									
									xMul := Substr(aArq[s],180,015)                               	
									xJur := Substr(aArq[s],195,015)                               	
								endif

								xMul := ( Val(xMul) / 100 ) 
								xJur := ( Val(xJur) / 100 )
								xPag := ( Val(xPag) / 100 )
								xDat := StoD(Substr(xDat,05,04) + Substr(xDat,03,02) + Substr(xDat,01,02))
	
	                    		nLot += xPag
	                    		xTot += xPag
	                    		
	                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"
									aMov := {} 
									nSal := 00 
									xSal := .f.
									xPss := .f.									
									Exit                	
								endif               	
	
								if	xBuscaTit(xRec)                             	
									xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut) 
									lFnd := .t.
									nPss ++
	        					else    				   	
									if	lDir .and. !lAut
										ConOut("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec)) 
									else
										Alert("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec)) 
									endif
									lSgZ :=	.t.
								endif	
	
							// DARJ

	                    	elseif	( cBco == "001" .and. Substr(aArq[s],133,002) == "21" )	.or.  ; 		
	                    			( cBco == "341" .and. Substr(aArq[s],018,002) == "04" )	

								xAtu := 0
	                     		cSeg := Substr(aArq[s],014,001)   
								xJur := Substr(aArq[s],092,014)    		/////////////////////////////////////////////////////////////////////                           	
								xMul := Substr(aArq[s],106,014)                               	
								xPag := Substr(aArq[s],120,014)                               	
								xDat := Substr(aArq[s],142,008)                               	
	                            xRec := Substr(aArq[s],196,020)  
								xOco := Substr(aArq[s],231,010)     
								lFnd := .f.                          	
	
								if	cBco $ "001" 
		                           	xRec := Substr(aArq[s],018,020)  
									xDat := Substr(aArq[s],088,008)                               	
									xPag := Substr(aArq[s],096,015)                               									
									xAtu := Substr(aArq[s],172,015)                               	
									xJur := Substr(aArq[s],187,015)                               	
									xMul := Substr(aArq[s],202,015)                               	
								endif

								xJur := ( Val(xJur) / 100 ) + ( Val(xAtu) / 100 )
								xMul := ( Val(xMul) / 100 ) 
								xPag := ( Val(xPag) / 100 )
								xDat := StoD(Substr(xDat,05,04) + Substr(xDat,03,02) + Substr(xDat,01,02))
	
	                    		nLot += xPag
	                    		xTot += xPag
	                    		
	                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"
									aMov := {} 
									nSal := 00 
									xSal := .f.
									xPss := .f.									
									Exit                	
								endif               	
	
								if	xBuscaTit(xRec)                             	
									xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut)   
									lFnd := .t.
									nPss ++
	        					else    				   	
									if	lDir .and. !lAut
										ConOut("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))   
									else
										Alert("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))   
									endif
									lSgZ :=	.t.
								endif	
	
							// GARE ICMS SP

	                    	elseif	( cBco == "001" .and. Substr(aArq[s],133,002) == "22" )	.or.  ; 		
	                    	 		( cBco == "001" .and. Substr(aArq[s],133,002) == "23" )	.or.  ; 		
	                    	 		( cBco == "001" .and. Substr(aArq[s],133,002) == "24" )	.or.  ; 		
	                    	 		( cBco == "033" .and. Substr(aArq[s],133,002) == "22" )	.or.  ; 		
	                    	 		( cBco == "033" .and. Substr(aArq[s],133,002) == "23" )	.or.  ; 		
	                    	 		( cBco == "033" .and. Substr(aArq[s],133,002) == "24" )	.or.  ; 		
	                    	 		( cBco == "237" .and. Substr(aArq[s],133,002) == "22" )	.or.  ; 		
	                    	 		( cBco == "237" .and. Substr(aArq[s],133,002) == "23" )	.or.  ; 		
	                    	 		( cBco == "237" .and. Substr(aArq[s],133,002) == "24" )	.or.  ; 		
	                    			( cBco == "341" .and. Substr(aArq[s],018,002) == "05" ) .or.  ; 		
	                    	 		( cBco == "422" .and. Substr(aArq[s],133,002) == "22" )	.or.  ; 		
	                    	 		( cBco == "422" .and. Substr(aArq[s],133,002) == "23" )	.or.  ; 		
	                    	 		( cBco == "422" .and. Substr(aArq[s],133,002) == "24" )	
	                            	
	                       		cSeg := Substr(aArq[s],014,001)   
								xJur := Substr(aArq[s],097,014)                               	
								xMul := Substr(aArq[s],111,014)                               	
								xPag := Substr(aArq[s],125,014)                               	
								xDat := Substr(aArq[s],147,008)                               	
	       						xRec := Substr(aArq[s],196,020)  
								xOco := Substr(aArq[s],231,010) 
								lFnd := .f.                              	
	
								if	cBco $ "001/033/237/422" 
		                           	xRec := Substr(aArq[s],018,020)  
									xDat := Substr(aArq[s],088,008)                               	
									xPag := Substr(aArq[s],096,015)                               									
									xJur := Substr(aArq[s],202,014)                               	
									xMul := Substr(aArq[s],216,014)                               	
								endif

								xJur := ( Val(xJur) / 100 )
								xMul := ( Val(xMul) / 100 ) 
								xPag := ( Val(xPag) / 100 )
								xDat := StoD(Substr(xDat,05,04) + Substr(xDat,03,02) + Substr(xDat,01,02))
	
	                    		nLot += xPag
	                    		xTot += xPag
	
	                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"
									aMov := {} 
									nSal := 00 
									xSal := .f.
									xPss := .f.									
									Exit                	
								endif               	
	
								if	xBuscaTit(xRec)                             	
									xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut)
									lFnd := .t.
									nPss ++
	        					else    				   	
									if	lDir .and. !lAut
										ConOut("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))  
									else
										Alert("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))  
									endif
									lSgZ :=	.t.
								endif	
	
							// IPVA (25) , Licenciamento (26) e DPVAT (27)	 
	 
	                    	elseif	( cBco == "001" .and. Substr(aArq[s],133,002) $ "25/26/27"  )	.or.  ; 		
	                    	 		( cBco == "033" .and. Substr(aArq[s],133,002) $ "25/26/27"  )	.or.  ; 		
	                    			( cBco == "341" .and. Substr(aArq[s],018,002) $ "07/08" 	)   .or.  ;             	/////////////////////////////////////////////
	                    	 		( cBco == "422" .and. Substr(aArq[s],133,002) $ "25/26/27"  )	 		
	
	                            cSeg := Substr(aArq[s],014,001)   
								xDat := Substr(aArq[s],117,008)                               	
	                            xRec := Substr(aArq[s],196,020)  
								xOco := Substr(aArq[s],231,010)           
								lFnd := .f.                    	
	
								if	cBco $ "001/033/422" 
		                           	xRec := Substr(aArq[s],018,020)  
									xDat := Substr(aArq[s],088,008)                               	
								endif

								xDat := StoD(Substr(xDat,05,04) + Substr(xDat,03,02) + Substr(xDat,01,02))
	
	                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"
									aMov := {} 
									nSal := 00 
									xSal := .f.
									xPss := .f.									
									Exit                	
								endif               	
	
								if	xBuscaTit(xRec)                             	
									xDsc := SE2->E2_DECRESC
									xJur := SE2->E2_ACRESC
									xPag := SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC)
									xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut) 
									lFnd := .t.
									nPss ++
	        					else    				   	
									if	lDir .and. !lAut
										ConOut("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))   
									else
										Alert("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))   
									endif
									lSgZ :=	.t.
								endif	
	
	                    		nLot += xPag
	                    		xTot += xPag
	                    		
							// FGTS (35) 
	 
	                    	elseif	( cBco == "341" .and. Substr(aArq[s],018,002) $ "11" )   
 		
	                            cSeg := Substr(aArq[s],014,001)   
								xDat := Substr(aArq[s],144,008)                               	
	                            xRec := Substr(aArq[s],196,020)  
								xOco := Substr(aArq[s],231,010)            
								lFnd := .f.                   	

								xDat := StoD(Substr(xDat,05,04) + Substr(xDat,03,02) + Substr(xDat,01,02))
	
	                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"
									aMov := {} 
									nSal := 00 
									xSal := .f.
									xPss := .f.									
									Exit                	
								endif               	
	
								if	xBuscaTit(xRec)                             	
									xDsc := SE2->E2_DECRESC
									xJur := SE2->E2_ACRESC
									xPag := SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC)
									xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut) 
									lFnd := .t.
									nPss ++
	        					else    				   	
									if	lDir .and. !lAut
										ConOut("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))   
									else
										Alert("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))   
									endif
									lSgZ :=	.t.
								endif	
	
	                    		nLot += xPag
	                    		xTot += xPag

                            endif
                            
						// CONCESSIONARIAS E IMPOSTOS COM CODIGO DE BARRAS

                    	elseif	Substr(aArq[s],8,1) == "3" .and. Substr(aArq[s],14,01) == "O"

							cSeg := Substr(aArq[s],014,001)   
							xPag := Substr(aArq[s],122,015)                               	
							xDat := Substr(aArq[s],137,008)                               	
                            xRec := Substr(aArq[s],175,020)  
							xOco := Substr(aArq[s],231,010)        
							lFnd := .f.                       	

							if	cBco $ "001/033/104/237/422/748/756"
								xDat := Substr(aArq[s],100,008)                               	
								xPag := Substr(aArq[s],108,015)                               	
                            	xRec := Substr(aArq[s],123,020)  
    						endif

							xPag := ( Val(xPag) / 100 )
							xDat := StoD(Substr(xDat,05,04) + Substr(xDat,03,02) + Substr(xDat,01,02))

                    		nLot += xPag
                    		xTot += xPag
                    		
                    		if	xOBD .and. Upper(Alltrim(xOco)) == "00"
								aMov := {} 
								nSal := 00 
								xSal := .f.
								xPss := .f.									
								Exit                	
							endif               	

							if	xBuscaTit(xRec)                             	
								xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut)  
								lFnd := .t.
								nPss ++
        					else    				   	
								if	lDir .and. !lAut
									ConOut("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))  
								else
									Alert("Nใo foi possํvel encontrar o tํtulo com ID " + Alltrim(xRec))  
								endif
								lSgZ :=	.t.
							endif	
							
						// CODIGO DE AUTENTICACAO	
							
                    	elseif	Substr(aArq[s],8,1) == "3" .and. Substr(aArq[s],14,01) == "Z"

							if	lFnd	
								aMov[Len(aMov),19] := iif( cBco $ "033/341" , Substr(aArq[s],015,064) , Substr(aArq[s],079,025) )
							endif 

						// FIM DE LOTE

                    	elseif	Substr(aArq[s],8,1) == "5" 

							if	mv_par02 == 2
								xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),nLot,cBco,xSA6,cSeg,.f.,lAut)  
								lFnd := .f.
								nPss ++
							endif

						// FIM DE ARQUIVO
						
                    	elseif	Substr(aArq[s],8,1) == "9" 

							if	mv_par02 == 3
								xGravaTit(@aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,Substr(aArq[s],8,1),xTot,cBco,xSA6,cSeg,.f.,lAut)  
								lFnd := .f.
								nPss ++
							endif

							xTot := 0

						endif  
					endif  
				Next s 
			else
				if	lDir .and. !lAut
					ConOut("Erro na leitura do conte๚do - Arquivo " + Alltrim(aRet[t,02])) 			
				else
					Alert("Erro na leitura do conte๚do - Arquivo " + Alltrim(aRet[t,02])) 			
				endif
			endif
		else
			if	lDir .and. !lAut
				ConOut("Nใo foi possํvel a leitura - Arquivo " + Alltrim(aRet[t,02]))
			else
				Alert("Nใo foi possํvel a leitura - Arquivo " + Alltrim(aRet[t,02]))
			endif
		endif
		if	Len(aMov) <> 0 .or. nSal <> 0 .or. xSal
			if	xSal .or. fQuadro( @aMov , Alltrim(aRet[t,02]) , "Banco : " + Alltrim(cBco) + "/" + Alltrim(cAge) + "/" + Alltrim(cCon) , lDir , nSal )		
				if !ExistDir(Alltrim(cDiretory) + "\Processados")			
					MakeDir(Alltrim(cDiretory) + "\Processados")			
				endif				
				cArq := Alltrim(aRet[t,02]) 
				if	__CopyFile( Alltrim(cDiretory) + "\" + Alltrim(cArq) , Alltrim(cDiretory) + "\Processados\" + Alltrim(cArq) )   
					fErase(Alltrim(cDiretory) + "\" + Alltrim(cArq))
				endif
			endif
		endif
	endif
	if	xPss .and. nPss <= 0
		if	( lCallGen .or. lIsBlind ) 
			if !ExistDir(Alltrim(cDiretory) + "\Processados")			
				MakeDir(Alltrim(cDiretory) + "\Processados")			
			endif				
			cArq := Alltrim(aRet[t,02]) 
			if	__CopyFile( Alltrim(cDiretory) + "\" + Alltrim(cArq) , Alltrim(cDiretory) + "\Processados\" + Alltrim(cArq) )   
				fErase(Alltrim(cDiretory) + "\" + Alltrim(cArq))
			endif
		elseif	lMsgErro	
			if	MsgYesNo("Nใo hแ registros a importar." + CRLF + "Arquivo " + Alltrim(aRet[t,02]) + "." + CRLF + "Mover o arquivo ?")
				if !ExistDir(Alltrim(cDiretory) + "\Processados")			
					MakeDir(Alltrim(cDiretory) + "\Processados")			
				endif				
				cArq := Alltrim(aRet[t,02]) 
				if	__CopyFile( Alltrim(cDiretory) + "\" + Alltrim(cArq) , Alltrim(cDiretory) + "\Processados\" + Alltrim(cArq) )   
					fErase(Alltrim(cDiretory) + "\" + Alltrim(cArq))
				endif
			endif
		endif
	endif	
Next t 

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxImpRetSis บAutor  ณMicrosiga          บ Data ณ  07/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta as tarifas dos extratos bancarios                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xFindAcc(cBco,cAge,cDAg,cCon,xSA6,cCnv) 

Local uRet		:=	Nil
Local lFind		:=	.f.      
Local aArea		:=	GetArea()     

dbselectarea("SA6")
SA6->(dbsetorder(1))
SA6->(dbgotop())

do while SA6->(!Eof())   
	if	Val(cBco) == Val(SA6->A6_COD)
		if	Val(cAge) 							== 	Val(StrTran(SA6->A6_AGENCIA,"-","")) 									.or. ;
			Val(cAge) 							== 	Val(StrTran(StrTran(SA6->A6_AGENCIA + SA6->A6_DVAGE," ",""),"-",""))	.or. ;
			Val(StrTran(cAge + cDAg," ",""))	==	Val(StrTran(StrTran(SA6->A6_AGENCIA + SA6->A6_DVAGE," ",""),"-","")) 
			if	Val(StrTran(cCon," ","")) 		== 	Val(StrTran(SA6->A6_NUMCON,"-","")) 									.or. ;
				Val(StrTran(cCon," ","")) 		== 	Val(StrTran(StrTran(SA6->A6_NUMCON + SA6->A6_DVCTA," ",""),"-","")) 
				if	SA6->(FieldPos("A6_BLOCKED")) <> 0 .and. SA6->A6_BLOCKED == '1'
					SA6->(dbskip())
                    Loop
				elseif	SA6->(FieldPos("A6_MSBLQL")) <> 0 .and. SA6->A6_MSBLQL == '1'
					SA6->(dbskip())
                    Loop
     			else
					cBco	:=	SA6->A6_COD
					cAge	:=	SA6->A6_AGENCIA
					cCon	:=	SA6->A6_NUMCON  
					xSA6	:=	SA6->(Recno())
					lFind	:= 	.t.      
					Exit
				endif
			endif
		endif
	endif
	SA6->(dbskip())
enddo 

if	.f.		//ExistBlock("FFINDACC")
	uRet := ExecBlock("FFINDACC",.f., .f.,{cBco,cAge,cCon,xSA6,lFind})
	if 	ValType(uRet) == 'A'
		cBco	:=	uRet[1]
		cAge	:=	uRet[2]
		cCon	:=	uRet[3]
		xSA6	:=	uRet[4]
		lFind	:= 	uRet[5]
	endif
endif

RestArea(aArea)

Return ( lFind )       

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxImpRetSis บAutor  ณMicrosiga          บ Data ณ  07/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xBuscaTit(cNumTit)   		

Local w          
Local lRet			:=	.f.
Local nNumTit		:=	Val(Alltrim(cNumTit))     
Local nIdCnab		:=	Len(Alltrim(Str(nNumTit)))
Local nTotPsq		:=	Len(CriaVar("E2_IDCNAB",.f.))   

For w := nIdCnab to nTotPsq
	xIdCnab	:=	PadR(StrZero(Val(Alltrim(cNumTit)),w),nTotPsq)
	SE2->(dbSetOrder(13)) 											
	if 	SE2->(dbseek(xIdCnab,.f.)) 
		if 	Empty(Alltrim(SE2->E2_FILIAL))
			cFilAnt		:= 	SE2->E2_FILORIG
		else
			cFilAnt		:= 	SE2->E2_FILIAL
		endif
		lRet			:=	.t.
		Exit
	endif	
Next w

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxImpRetSis บAutor  ณMicrosiga          บ Data ณ  07/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGravaTit(aMov,xDat,xPag,xDsc,xJur,xMul,xOco,xLot,cTip,xSeg,nLot,cBco,xSA6,cSeg,lAgl,lAut)

Local s        
Local cAglt		:=	""
Local xNome		:=	""
Local cDesc		:=	""
Local xOcor		:=	""
Local cOcor		:=	xOco
Local lPaMov	:=	Nil
Local cKeySE5	:=	Nil

Default lAgl	:=	.f.
Default lAut	:=	.f.

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
//	xPag 		:= 	SE2->E2_SALDO
//	xDat 		:= 	Date()
endif 

if	xSeg == "0"

	aAdd( aMov	,	{	.f.                     ,;		// 01
						""     					,;		// 02
						""             			,;		// 03
						""         				,;		// 04
						""             			,;		// 05
						""          			,;		// 06
						""             			,;		// 07
						""          			,;		// 08
						""               		,;		// 09
						""           			,;		// 10
						""             			,;		// 11
						""           			,;		// 12
						""  					,; 		// 13
						""    					,;   	// 14
						""  					,;  	// 15
						""  					,;		// 16
						""  					,;		// 17
						""  					,;		// 18
						""						,;		// 19
						""              		,;		// 20
						""  					,;		// 21
						""  					,;		// 22
						""  					,;		// 23
						.f. 					,;		// 24
						.f. 					,;		// 25
						""  					,;		// 26
						0             			})		// 27

elseif	xSeg == "1"

	if	cTip == "01"
		cDesc		:=	"Credito em conta corrente"
	elseif	cTip == "02"
		cDesc		:=	"Cheque pagamento / administrativo"
	elseif	cTip == "03"
		cDesc		:=	"Doc C"
	elseif	cTip == "04"      
		cDesc		:=	"Op a disposicao COM aviso"
	elseif	cTip == "05"
		cDesc		:=	"Credito em conta poupanca"
	elseif	cTip == "06"
		cDesc		:=	"Credito em conta corrente mesma titularidade"
	elseif	cTip == "07"
		cDesc		:=	"Doc D"
	elseif	cTip == "10"
		cDesc		:=	"Op a disposicao Sem aviso"
	elseif	cTip == "13"
		cDesc		:=	"Concessionarias e Imp. C๓digo de Barras"
	elseif	cTip == "16"
		cDesc		:=	"Tributos - DARF"
	elseif	cTip == "17"
		cDesc		:=	"Tributos - GPS"
	elseif	cTip == "18"
		cDesc		:=	"Tributos - DARF SIMPLES"
	elseif	cTip == "19"
		cDesc		:=	"IPTU/ISS/Tributos Municipais"
	elseif	cTip == "21"
		cDesc		:=	"Tributos - DARJ"
	elseif	cTip == "22"
		cDesc		:=	"Tributos - GARE ICMS SP"
	elseif	cTip == "25"
		cDesc		:=	"Tributos - IPVA"
	elseif	cTip == "27"
		cDesc		:=	"Tributos - DPVAT"
	elseif	cTip == "28"
		cDesc		:=	"GR-PR com Codigo de Barras"
	elseif	cTip == "29"
		cDesc		:=	"GR-PR sem Codigo de Barras"
	elseif	cTip == "30"
		cDesc		:=	"Titulos mesmo banco"
	elseif	cTip == "31"
		cDesc		:=	"Titulos em outros bancos"
	elseif	cTip == "35"
		cDesc		:=	"FGTS - GFIP"
	elseif	cTip == "41"
		cDesc		:=	"TED - Outro Titular"
	elseif	cTip == "43"
		cDesc		:=	"TED - Mesmo Titular"
	elseif	cTip == "45"
		cDesc		:=	"PIX - Transfer๊mcia"
	endif
	
	aAdd( aMov	,	{	.f.                     ,;		// 01
						""     					,;		// 02
						""             			,;		// 03
						""         				,;		// 04
						""             			,;		// 05
						""          			,;		// 06
						""             			,;		// 07
						""          			,;		// 08
						cDesc         			,;		// 09
						""           			,;		// 10
						""             			,;		// 11
						""           			,;		// 12
						""  					,; 		// 13
						""  					,;   	// 14
						""  					,;  	// 15
						""  					,;		// 16
						""  					,;		// 17
						""  					,;		// 18
						""						,;		// 19
						""                		,;		// 20
						""  					,;		// 21
						""  					,;		// 22
						""  					,;		// 23
						.f. 					,;		// 24
						.f. 					,;		// 25
						""  					,;		// 26
						0             			})		// 27

elseif	xSeg == "3" 

	lPaMov 	:= 	.f.
	cKeySE5 := 	xFilial("SE5") + "PA" + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + "PA "

	if 	SE2->E2_TIPO $ MVPAGANT 
		dbSelectArea("SE5")
		SE5->(dbsetorder(2))  																		
		if 	SE5->(dbseek(cKeySE5))
			do while SE5->(!Eof()) .and. SE5->(E5_FILIAL + E5_TIPODOC + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO) == cKeySE5
				if 	SE2->(E2_FORNECE + E2_LOJA) == SE5->(E5_CLIFOR + E5_LOJA)
					lPaMov = .t. 
					Exit
				endif
				SE5->(dbSkip())
			enddo
		endif
	endif

	dbSelectArea("SE2")

	For s := 1 to Len(xOco) Step 2 

		xNome	:= 	SE2->E2_NOMFOR
		xOcor 	:= 	Substr( cOcor , 01 , 02 ) 

		if !Empty(xOcor)	
			if	xOcor $ cAglt
				cOcor := Substr( cOcor , 3 )
				Loop
			else
				cAglt += xOcor + "/"
			endif
		endif

		if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
		//	xNome := "Fornecedor " + StrZero(Len(aMov),06)
		endif
	
		if !Empty(xOcor)	
			if	s == 1 
				aAdd( aMov	,	{	.f.                     						,;		// 01
									cFilAnt											,;		// 02
									SE2->E2_PREFIXO									,;		// 03
									SE2->E2_NUM										,;		// 04
									SE2->E2_PARCELA									,;		// 05
									SE2->E2_TIPO									,;		// 06
									SE2->E2_FORNECE									,;		// 07
									SE2->E2_LOJA									,;		// 08
									xNome											,;		// 09
									iif( lAgl , SE2->E2_ZZVLTED , SE2->E2_VALOR )	,;		// 10
									SE2->E2_VENCREA									,;		// 11
									iif( lAgl , SE2->E2_ZZVLTED , SE2->E2_SALDO )	,;		// 12
									xDat											,; 		// 13
									xPag											,;   	// 14
									xDsc											,;  	// 15
									xJur											,;		// 16
									xMul											,;		// 17
									xOcor											,;		// 18
									""												,;		// 19
									StrZero(xLot,03)								,;		// 20
									xSeg											,;		// 21
									xSA6											,;		// 22
									cSeg											,;		// 23
									lPaMov 											,;		// 24
									lAgl 											,;		// 25
									SE2->E2_NUMBOR									,;		// 26
									SE2->(Recno())									})		// 27    
									
				if	Substr(xOcor,01,02) == "00"
					aMov[Len(aMov),01] := ( SE2->E2_SALDO > 0 .and. xPag > 0 .and. !lPaMov )
					aMov[Len(aMov),18] += " - PAGAMENTO EFETUADO"     
					if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
					//	aMov[Len(aMov),01] := ( xPag > 0 .and. !lPaMov )
					endif
				elseif	Substr(xOcor,01,02) == "BD"
					aMov[Len(aMov),18] += " - PAGAMENTO AGENDADO" 
				elseif	Substr(xOcor,01,02) == "BE"
					aMov[Len(aMov),18] += " - PAGAMENTO AGENDADO COMO OP" 
				elseif	Substr(xOcor,01,02) == "PD"
					aMov[Len(aMov),18] += " - TITULO ANTECIPADO PELO FORNECEDOR" 
				elseif	Substr(xOcor,01,02) == "RS"
					aMov[Len(aMov),18] += " - DISPONํVEL PARA ANTECIPA็ใO NO RISCO SACADO" 
				else
					if	Empty(xRetMotivo(Substr(xOcor,01,02)))
						if	SEB->(dbsetorder(1),dbseek( xFilial("SEB") + cBco + PadR( Alltrim(Substr(xOcor,01,02)) , TamSx3("EB_REFBAN")[1] ),.f.))  
							aMov[Len(aMov),18] += " - " + Upper(Alltrim(SEB->EB_DESCRI))
						endif
					else
                    	aMov[Len(aMov),18] += " - " + Upper(Alltrim(xRetMotivo(Substr(xOcor,01,02))))
     				endif
					xEstornaBord(Substr(xOcor,01,02),cOcor,cBco,lAut)
				endif 							
			else
				aAdd( aMov	,	{	.f.                     ,;		// 01
									""     					,;		// 02
									""             			,;		// 03
									""         				,;		// 04
									""             			,;		// 05
									""          			,;		// 06
									""             			,;		// 07
									""          			,;		// 08
									""             			,;		// 09
									""           			,;		// 10
									""             			,;		// 11
									""           			,;		// 12
									""  					,; 		// 13
									""    					,;   	// 14
									""  					,;  	// 15
									""  					,;		// 16
									""  					,;		// 17
									xOcor  					,;		// 18
									""						,;		// 19
									""              		,;		// 20
									""  					,;		// 21
									""  					,;		// 22
									""  					,;		// 23
									.f. 					,;		// 24
									.f. 					,;		// 25
									""  					,;		// 26
									0             			})		// 27

				if	SEB->(dbsetorder(1),dbseek( xFilial("SEB") + cBco + PadR( Alltrim(Substr(xOcor,01,02)) , TamSx3("EB_REFBAN")[1] ),.f.))  
					aMov[Len(aMov),18] += " - " + Upper(Alltrim(SEB->EB_DESCRI))
				endif 							
			endif
		endif
		
		cOcor := Substr( cOcor , 3 )

	Next s 

elseif	xSeg == "5"

	aAdd( aMov	,	{	.f.                     ,;		// 01
						""     					,;		// 02
						""             			,;		// 03
						""         				,;		// 04
						""             			,;		// 05
						""          			,;		// 06
						""             			,;		// 07
						""          			,;		// 08
						"Total do Lote"			,;		// 09
						""           			,;		// 10
						""             			,;		// 11
						""           			,;		// 12
						""  					,; 		// 13
						nLot  					,;   	// 14
						""  					,;  	// 15
						""  					,;		// 16
						""  					,;		// 17
						""  					,;		// 18
						""						,;		// 19
						""              		,;		// 20
						""  					,;		// 21
						""  					,;		// 22
						""  					,;		// 23
						.f. 					,;		// 24
						.f. 					,;		// 25
						""  					,;		// 26
						0             			})		// 27

elseif	xSeg == "9"

	aAdd( aMov	,	{	.f.                     ,;		// 01
						""     					,;		// 02
						""             			,;		// 03
						""         				,;		// 04
						""             			,;		// 05
						""          			,;		// 06
						""             			,;		// 07
						""          			,;		// 08
						"Total da Filial"		,;		// 09
						""           			,;		// 10
						""             			,;		// 11
						""           			,;		// 12
						""  					,; 		// 13
						nLot  					,;   	// 14
						""  					,;  	// 15
						""  					,;		// 16
						""  					,;		// 17
						""  					,;		// 18
						""						,;		// 19
						""              		,;		// 20
						""  					,;		// 21
						""  					,;		// 22
						""  					,;		// 23
						.f. 					,;		// 24
						.f. 					,;		// 25
						""  					,;		// 26
						0             			})		// 27

endif
						
Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxImpRetSis บAutor  ณMicrosiga          บ Data ณ  07/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta as tarifas dos extratos bancarios                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static oVerd    		:=	LoadBitmap( GetResources() , "ENABLE"		 )
Static oVerm    		:=	LoadBitmap( GetResources() , "DISABLE"		 )
Static oAzul    		:=	LoadBitmap( GetResources() , "BR_AZUL"		 )
Static oPret    		:=	LoadBitmap( GetResources() , "BR_PRETO"		 )
Static oBran    		:=	LoadBitmap( GetResources() , "BR_BRANCO"	 )
Static oLara    		:=	LoadBitmap( GetResources() , "BR_LARANJA" 	 )
Static oViol    		:=	LoadBitmap( GetResources() , "BR_VIOLETA" 	 )

Static Function xRetCores(aArray,nLin)

if	.f.		//"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
	if	aArray[nLin,02] == ""
		Return ( "" ) 
	elseif	aArray[nLin,24] 
		Return ( oAzul )  	
	elseif	aArray[nLin,01] .and. aArray[nLin,25]
		Return ( oLara )  	
	elseif	aArray[nLin,01] 
		Return ( oVerd )  	
	elseif	aArray[nLin,12] > 0 .and. aArray[nLin,14] > 0 .and. Substr(aArray[nLin,18],01,02) $ "BD/BE" 
		Return ( oBran )  	
	elseif	aArray[nLin,12] > 0 .and. Substr(aArray[nLin,18],01,02) $ "PD/RS" 
		Return ( oViol )  	
	endif 
else
	if	aArray[nLin,02] == ""
		Return ( "" ) 
	elseif	aArray[nLin,12] <= 0 
		Return ( oPret )  	
	elseif	aArray[nLin,24] 
		Return ( oAzul )  	
	elseif	aArray[nLin,01] .and. aArray[nLin,25]
		Return ( oLara )  	
	elseif	aArray[nLin,01] 
		Return ( oVerd )  	
	elseif	aArray[nLin,12] > 0 .and. aArray[nLin,14] > 0 .and. Substr(aArray[nLin,18],01,02) $ "BD/BE" 
		Return ( oBran )  	
	elseif	aArray[nLin,12] > 0 .and. Substr(aArray[nLin,18],01,02) $ "PD/RS" 
		Return ( oViol )  	
	endif 
endif 
	
Return ( oVerm )  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxImpRetSis บAutor  ณMicrosiga          บ Data ณ  07/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta as tarifas dos extratos bancarios                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fQuadro( aArray , cArquivo , cBanco , lDir , nSal ) 

Local w	   
Local oSal
Local cMsg
Local oDlg			
Local oQtd			
Local oSay1			
Local oSay2			
Local oSay3			
Local oGrid     
Local oTotal    
Local xArray                 
Local oTButton1
Local oTButton2
Local oTButton3

Local lOne			:=	.f.
Local lRet			:=	.f.
Local nQtd			:=  000
Local nOpc			:= 	000
Local nTotal		:=  000    
Local nValPD		:=	000   

Local aSize   		:= 	iif( lDir , Nil , MsAdvSize(Nil,.f.,430) )
Local aInfo   		:= 	iif( lDir , Nil , { aSize[1] , aSize[2] , aSize[3] , aSize[4] , 0 , 0 } )
Local aObjects		:= 	iif( lDir , Nil , {{040,040,.t.,.t.},{100,100,.t.,.t.},{020,020,.t.,.t.}} )
Local aPosObj 		:= 	iif( lDir , Nil , MsObjSize(aInfo,aObjects,.f.) )
Local nAltu			:=	iif( lDir , Nil , aPosObj[3,3] - 18 )
Local nLarg			:=	iif( lDir , Nil , aPosObj[3,4] )

Local cCabec		:=	"Arquivo " + Alltrim(Upper(cArquivo)) + " | " + cBanco          
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U" 

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
//	cCabec			:=	"Arquivo XXXXXXXXX.TXT | 000/0000/000000"
endif

For w := 1 to Len(aArray)
	if	aArray[w,21] == "3"
		nQtd	+=  001
		nTotal	+=  aArray[w,14]
	//	nTotal	-=  aArray[w,15]
	//	nTotal	+=  aArray[w,16]
	//	nTotal	+=  aArray[w,17]
	endif       
	if	aArray[w,01]
		lOne	:=	.t.
	endif
Next w 

if	lDir
	nOpc := 1	
else     
	if	nSal <> 0 
		Alert("Esse arquivo cont้m valores referentes a salแrio")
	endif		

	Setapilha()
	Define MsDialog oDlg Title cCabec From aSize[7],0 To aSize[6],aSize[5] Of oMainWnd Pixel
	
	oDlg:lEscClose 	:= 	.f.                   
	oDlg:lMaximized := 	.t.   
	
	oGrid := TcBrowse():New(003,003,nLarg - 005, nAltu - 010 ,,,,oDlg,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)
	
	oGrid:AddColumn( TcColumn():New( " "   					,{ || xRetCores(aArray,oGrid:nAt)																					}	, "@!"								,,,"CENTER"	 	,015,.t.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Filial"    			,{ || aArray[oGrid:nAt,02]      																					}	, PesqPict("SE2","E2_FILIAL")		,,,"CENTER"	 	,027,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Prefixo"    			,{ || aArray[oGrid:nAt,03]      																					}	, PesqPict("SE2","E2_PREFIXO")		,,,"CENTER"	 	,033,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Numero"    			,{ || aArray[oGrid:nAt,04]      																					}	, PesqPict("SE2","E2_NUM")			,,,"CENTER"	 	,040,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Parcela"    			,{ || aArray[oGrid:nAt,05]      																					}	, PesqPict("SE2","E2_PARCELA")		,,,"CENTER"	 	,030,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Tipo"    				,{ || aArray[oGrid:nAt,06]      																					}	, PesqPict("SE2","E2_TIPO")			,,,"CENTER"	 	,025,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Fornecedor"		   	,{ || aArray[oGrid:nAt,07]      																					}	, PesqPict("SE2","E2_FORNECE")  	,,,"CENTER" 	,047,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Loja"		   			,{ || aArray[oGrid:nAt,08]      																					}	, PesqPict("SE2","E2_LOJA")  		,,,"CENTER"    	,025,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Nome Fornecedor"		,{ || aArray[oGrid:nAt,09]     																						}	, PesqPict("SA2","A2_NOME")  		,,,"LEFT" 	 	,150,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Valor"    			,{ || iif( ValType(aArray[oGrid:nAt,10]) <> "N" , "" , Transform(aArray[oGrid:nAt,10],PesqPict("SE2","E2_SALDO")))	}	, "@!" 								,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Venc Real"			,{ || aArray[oGrid:nAt,11]      																					}	, PesqPict("SE2","E2_VENCREA")  	,,,"CENTER"    	,043,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Saldo"    			,{ || iif( ValType(aArray[oGrid:nAt,12]) <> "N" , "" , Transform(aArray[oGrid:nAt,12],PesqPict("SE2","E2_SALDO")))	}	, "@!" 								,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Dt Pagto"				,{ || aArray[oGrid:nAt,13]      																					}	, PesqPict("SE2","E2_VENCREA")  	,,,"CENTER"    	,043,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Vlr Pg"   			,{ || iif( ValType(aArray[oGrid:nAt,14]) <> "N" , "" , Transform(aArray[oGrid:nAt,14],PesqPict("SE2","E2_SALDO")))	}	, "@!" 								,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Desconto" 			,{ || iif( ValType(aArray[oGrid:nAt,15]) <> "N" , "" , Transform(aArray[oGrid:nAt,15],PesqPict("SE2","E2_SALDO")))	}	, "@!" 								,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Juros"    			,{ || iif( ValType(aArray[oGrid:nAt,16]) <> "N" , "" , Transform(aArray[oGrid:nAt,16],PesqPict("SE2","E2_SALDO")))	}	, "@!" 								,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Multa"    			,{ || iif( ValType(aArray[oGrid:nAt,17]) <> "N" , "" , Transform(aArray[oGrid:nAt,17],PesqPict("SE2","E2_SALDO")))	}	, "@!" 								,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )	
	if	SuperGetMv("ZZ_BXCOLBD",.f.,"N") == "S"
		oGrid:AddColumn( TcColumn():New( "Border๔"   		,{ || aArray[oGrid:nAt,26]      																					}	, PesqPict("SE2","E2_FORNECE")  	,,,"CENTER" 	,040,.f.,.f.,,,,.f.,) )	
	endif	
	oGrid:AddColumn( TcColumn():New( "Ocorr๊ncia"			,{ || aArray[oGrid:nAt,18]      																					}	, "@!"                      		,,,"LEFT"	 	,120,.f.,.f.,,,,.f.,) )	
	oGrid:AddColumn( TcColumn():New( "Autentica็ใo"			,{ || aArray[oGrid:nAt,19]																							}	, "@!"                      		,,,"LEFT"	 	,200,.f.,.f.,,,,.f.,) )	
	
	oGrid:SetArray(aArray)
	
	@ nAltu      		, 003	Say oSay1 			Prompt "Total:" 												Size 040,007 Of oDlg Colors 000,16777215 	Pixel
	@ nAltu - 003		, 023	MsGet oTotal 		Var nTotal 				Picture PesqPict("SE2","E2_VALOR")		Size 070,010 Of oDlg Colors 000,16777215 	Pixel 	ReadOnly
	
	@ nAltu      		, 103	Say oSay2 			Prompt "Qtde:" 			 										Size 040,007 Of oDlg Colors 000,16777215 	Pixel
	@ nAltu - 003		, 128	MsGet oQtd 			Var nQtd 				Picture "@e 999"						Size 020,010 Of oDlg Colors 000,16777215 	Pixel 	ReadOnly
	
	if	nSal <> 0
		@ nAltu      	, 158	Say oSay3 			Prompt "Salแrio:"		 										Size 040,007 Of oDlg Colors 128,16777215 	Pixel
		@ nAltu - 003	, 178	MsGet oSal 			Var nSal 				Picture PesqPict("SE2","E2_VALOR")		Size 070,010 Of oDlg Colors 128,16777215 	Pixel 	ReadOnly
	endif
		
	oTButton1		:=	tButton():New(nAltu - 2.5,nLarg - 042,"Sair"		,oDlg,{ || nOpc := 0 , oDlg:End() 	},040,015,,,.f.,.t.,.f.,,.f.,,,.f.)  
	oTButton2		:=	tButton():New(nAltu - 2.5,nLarg - 087,"Processar"	,oDlg,{ || nOpc := 1 , oDlg:End()	},040,015,,,.f.,.t.,.f.,,.f.,,,.f.)
	oTButton3		:=	tButton():New(nAltu - 2.5,nLarg - 132,"Legenda"		,oDlg,{ || xLegenda()              	},040,015,,,.f.,.t.,.f.,,.f.,,,.f.)
	
	Activate MsDialog oDlg Centered 
	Setapilha() 
endif
	
if	nOpc == 1	

	cMsg 		:= 	"A rotina farแ a baixa dos titulos do arquivo de retorno de CNAB" 	+ CRLF + CRLF

	if	mv_par02 == 1 
		cMsg	+= 	"A rotina farแ a baixa POR TอTULO" 									+ CRLF + CRLF
	elseif	mv_par02 == 2 
		cMsg	+= 	"A rotina farแ a baixa POR TIPO DE PAGAMENTO" 						+ CRLF + CRLF
	elseif	mv_par02 == 3 
		cMsg	+= 	"A rotina farแ a baixa PELO TOTAL DAS BAIXAS" 						+ CRLF + CRLF
	endif		

	if	mv_par03 == 1
		cMsg	+= 	"A rotina farแ a CONTABILIZAวรO ON-LINE" 							+ CRLF + CRLF
	elseif	mv_par03 == 2
		cMsg	+= 	"A rotina NรO farแ a CONTABILIZAวรO" 	 							+ CRLF + CRLF
	endif

	cMsg		+= 	"Confirma ?" 
	
	if	iif( lOne , lDir .or. MsgYesNo(cMsg) , .t. )
		xArray	:=	aClone(aArray)
		if	InTransact()
			if	lIsBlind
		 		xBaixaTit(aArray,lDir) 
				xContPD(xArray)
			else
		 		Processa( { || CursorWait() , xBaixaTit(aArray,lDir,@nValPD) , CursorArrow() } , "Baixando os Tํtulos" )     
				if	nValPD <> 0 
					FwMsgRun( Nil , { || CursorWait() , xContPD(xArray) , CursorArrow() } , "TOTVS" , "Contabilizando a Cessใo de Cr้dito ..." )
				endif
			endif
		else
			Begin Transaction 
			if	lIsBlind
		 		xBaixaTit(aArray,lDir) 
				xContPD(xArray)
			else
		 		Processa( { || CursorWait() , xBaixaTit(aArray,lDir,@nValPD) , CursorArrow() } , "Baixando os Tํtulos" )     
				if	nValPD <> 0 
					FwMsgRun( Nil , { || CursorWait() , xContPD(xArray) , CursorArrow() } , "TOTVS" , "Contabilizando a Cessใo de Cr้dito ..." )
				endif
			endif
			if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
				if	MsgYesNo("Encerrar Transa็ใo ?")
					DisarmTransaction()
				endif
			endif
			End Transaction 
		endif
		lRet	:=	.t.
	endif

endif

Return ( lRet )
        
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxImpRetSis บAutor  ณMicrosiga          บ Data ณ  07/03/18   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณImporta as tarifas dos extratos bancarios                   บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xBaixaTit( aArray , lDir , nValPD ) 

Local s
Local xLotePg		:=	""
Local xFilAnt		:=	""

Local aTemp        	:=	{}
Local aDtMvFinOk 	:= 	{} 																		// Array para as datas de baixa vแlidas
Local aDtMvFinNt 	:= 	{} 																		// Array para as datas de baixa inconsistentes com o parโmetro MV_DATAFIN

Local xBaixa     	:=	CtoD("")
Local dBaixa     	:=	CtoD("")
Local lBxDtFin		:= 	GetNewPar("MV_BXDTFIN","1") == "1" 										// Permite data de baixa menor que MV_DATAFIN 1=SIM / 2=NAO

Local lCabec 		:=	.f.    
Local lPrivez		:=	.t.
Local lContab 		:=	( mv_par03 == 1 )

Local nTotal 		:= 	000
Local nHdlPrv 		:= 	000
Local cPadrao 		:= 	"532" 
Local lPadrao 		:= 	VerPadrao(cPadrao)        
Local lUsaFlag		:= 	SuperGetMv("MV_CTBFLAG",.t.,.f.)
Local lGrvOcor		:=	Upper(Alltrim(GetMv("ZZ_GRVOCOR"))) == "S"
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U" 

Private cLote		:=	Nil
Private cBanco		:=	Nil
Private cConta		:=	Nil
Private cAgencia	:=	Nil
Private cArquivo	:=	Nil

Private VALOR 		:= 	000
Private nValTot  	:= 	000																		// Utilizado para compatibilizar com a rotina de rateio multinatureza 
Private nValPgto 	:= 	000																		// Utilizado para compatibilizar com a rotina de rateio multinatureza 
Private nTotAbat 	:= 	000

Private cTpDesc		:= 	"I"
Private lBxCnab		:= 	mv_par02 <> 1 															// Baixar arquivo recebidos pelo CNAB aglutinando os valores
Private cLotefin  	:= 	iif( lBxCnab , GetNewLote() , "" )

LoteCont("FIN")

SEA->(dbsetorder(1))		

For s := 1 to Len(aArray)
	if	lGrvOcor                             
		if !Empty(Alltrim(aArray[s,04]))
			if	aArray[s,Len(aArray[s])] <> Nil 
				if	aArray[s,Len(aArray[s])] <> 0 
					SE2->(dbgoto(aArray[s,Len(aArray[s])]))
            		RecLock("SE2",.f.)
            			SE2->E2_OCORREN	:=	iif( Upper(Alltrim(SE2->E2_OCORREN)) == 'PD' , SE2->E2_OCORREN , Substr(Alltrim(aArray[s,18]),01,02) )
					MsUnlock("SE2")
				endif
			endif
		endif
	endif
	if	lCCL .or. lCheck
		if	aArray[s,Len(aArray[s])] <> 0 
			if	Substr(Alltrim(aArray[s,18]),01,02) == "PD"
				SE2->(dbgoto(aArray[s,Len(aArray[s])]))
				RecLock("SE2",.f.)
					SE2->E2_OCORREN	:=	Substr(Alltrim(aArray[s,18]),01,02)
				MsUnlock("SE2")
				if	SEA->(dbseek( xFilial("SEA") + SE2->E2_NUMBOR  + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA ) )		
					if	Empty(SEA->EA_ZZCONT)
						nValPD += iif( SE2->E2_SALDO > 0 , SE2->E2_SALDO , aArray[s,10] )
					endif
				endif
			endif
		endif
	endif
	if	aArray[s,01] .or. !Empty(aArray[s,19])
    	aAdd( aTemp , aArray[s] )
 	endif
Next s 
    	
aArray := aSort( aTemp ,,, { |x,y| DtoS(x[13]) + x[02] + x[20] < DtoS(y[13]) + y[02] + y[20] } ) 

if !lIsBlind
	ProcRegua(Len(aArray) + 1)
endif

For s := 1 to Len(aArray)

	if !lIsBlind
		Incproc()
	endif
	
	if	aArray[s,01]	

		if	Empty(xBaixa)
			xBaixa	:=	aArray[s,13]
		endif

		if	Empty(xFilAnt)
			xFilAnt	:=	aArray[s,02]
		endif

		if	Empty(xLotePg)
			xLotePg	:=	aArray[s,20]
		endif

		dBaixa     	:= 	aArray[s,13]   

		if !lDir
			if !lBxDtFin	
				if 	aScan( aDtMvFinOk , dBaixa ) == 0 			// data ok 
					if 	aScan( aDtMvFinNt , dBaixa ) == 0  		// data nใo ok 
						if !DtMovFin( dBaixa , .f. )
							aAdd( aDtMvFinNt , dBaixa )		
							ProcLogAtu( "ERRO" , "DTMOVFIN" , Ap5GetHelp( "DTMOVFIN" ) + " " + DtoC( dBaixa ) )
							Loop 
						else
							aAdd( aDtMvFinOk , dBaixa )
						endif
					else	
						Loop 
					endif
				endif	
			endif  	
		endif  	
	
		if	xFilAnt	<> aArray[s,02] .or. xBaixa	<> aArray[s,13] .or. ( xLotePg <> aArray[s,20] .and. mv_par02 == 2 )

			cFilAnt 		:=	xFilBco	

			fBaixaTit(aArray[s - 1],lContab,cPadrao,lPadrao,@lCabec,lUsaFlag,@nHdlPrv,@nTotal,aArray[s - 1,23],.t.) 

			lCabec 			:=	.f.
			lPrivez 		:= 	.t.				
			nTotal 			:= 	000
			nValTot			:= 	000
			nHdlPrv 		:= 	000
			cArquivo   		:=	Nil    
			xBaixa			:=	aArray[s,13]
			xFilAnt			:=	aArray[s,02]     
			xLotePg			:=	aArray[s,20]
			cLotefin 		:= 	iif( lBxCnab , GetNewLote() , "" )
		endif

		SA6->(dbgoto(aArray[s,22]))
		SE2->(dbgoto(aArray[s,Len(aArray[s])]))

		cBanco  	:= 	SA6->A6_COD
		cAgencia	:= 	SA6->A6_AGENCIA
		cConta  	:= 	SA6->A6_NUMCON
		dDataBase	:=	dBaixa	

		cFilAnt		:=	aArray[s,02]

		SA2->(dbsetorder(1),dbSeek( xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA    ) )
		SA6->(dbsetorder(1),dbSeek( xFilial("SA6") + cBanco          + cAgencia        + cConta ) )    
		SEA->(dbsetorder(1),dbseek( xFilial("SEA") + SE2->E2_NUMBOR  + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA ) )		

		/*
		SEE->(dbSeek(xFilial("SEE") + cBanco + cAgencia + cConta + cSubCta ) )

		If !Empty(SEE->EE_CTAOFI)
			cBanco		:= SEE->EE_CODOFI
			cAgencia	:= SEE->EE_AGEOFI 
			cConta		:= SEE->EE_CTAOFI
		Endif
		*/
		
		if	lPrivez
			PcoIniLan("000022")	  				
		endif

		if	SE2->(FieldPos("E2_ZZVLTED")) <> 0 .and. SE2->(FieldPos("E2_ZZSQTED")) <> 0 .and. !Empty(SE2->E2_ZZSQTED) .and. SE2->E2_ZZVLTED > 0
        	xBxLotTED(aArray[s],lContab,cPadrao,lPadrao,@lCabec,lUsaFlag,@nHdlPrv,@nTotal,aArray[s,23])
		else
			fBaixaTit(aArray[s],lContab,cPadrao,lPadrao,@lCabec,lUsaFlag,@nHdlPrv,@nTotal,aArray[s,23])
		endif
		
		lPrivez := .f.		
	else
		if	SE5->(FieldPos("E5_ZZCDAUT")) <> 0 .and. !Empty(aArray[s,19])
			cFilAnt := aArray[s,02]
			SA6->(dbgoto(aArray[s,22]))
			SE2->(dbgoto(aArray[s,Len(aArray[s])]))
			fGravaSE5(aArray[s,19])
		endif
	endif    
	
	if !lPrivez
		if	s == Len(aArray) 
			cFilAnt := 	xFilBco
			fBaixaTit(aArray[s],lContab,cPadrao,lPadrao,@lCabec,lUsaFlag,@nHdlPrv,@nTotal,aArray[s,23],.t.) 
			lPrivez	:= 	.t.
		endif
	endif
	
Next s 

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPRETSISบAutor  ณMicrosiga           บ Data ณ  03/12/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static lBxTxa 		:= 	iif( IsBlind() .or. Type("__LocalDriver") == "U" , Nil , SuperGetMv("MV_BXTXA",.f.,"1") == "1"                                        	)
Static cMCusto 		:= 	iif( IsBlind() .or. Type("__LocalDriver") == "U" , Nil , SuperGetMv("MV_MCUSTO",.f.,"")                                              	)
Static nTamSeq		:= 	iif( IsBlind() .or. Type("__LocalDriver") == "U" , Nil , TamSx3("E5_SEQ")[1]                                                          	)
Static nTamHist		:= 	iif( IsBlind() .or. Type("__LocalDriver") == "U" , Nil , iif( AliasInDic("FK5") , TamSx3("FK5_HISTOR")[1] , TamSx3("E5_HISTOR")[1] )	)
Static lFA300PA 	:= 	iif( IsBlind() .or. Type("__LocalDriver") == "U" , Nil , ExistBlock("FA300PA")                                                        	)
Static lF300SE5 	:= 	iif( IsBlind() .or. Type("__LocalDriver") == "U" , Nil , ExistBlock("F300SE5")                                                        	)
Static lSigaMNT 	:= 	iif( IsBlind() .or. Type("__LocalDriver") == "U" , Nil , SuperGetMv("MV_NGMNTFI",.f.,"N") == 'S' 										) 
Static cSequencia	:= 	iif( IsBlind() .or. Type("__LocalDriver") == "U" , Nil , Replicate("0",nTamSeq)                                                        	)

Static Function fBaixaTit(xArray,lContab,cPadrao,lPadrao,lCabec,lUsaFlag,nHdlPrv,nTotal,cSegmento,lFim)

Local nI 			:= 	0 
Local nLaco 		:= 	0
Local nMulta 		:= 	0
Local nCpoTp 		:= 	0
Local nAcresc 		:= 	0
Local nDecresc 		:= 	0
Local nJurAux  		:= 	0
Local nValPag 		:= 	0
Local nDescAux 		:= 	0
Local nTotLtEZ 		:= 	0	
Local nRegistro 	:= 	0
Local nValPadrao 	:= 	0

Local cLog			:= 	""
Local xTemp			:=	""
Local cMoeda		:=	""
Local cTpDoc 		:= 	""
Local cIdDoc		:= 	""
Local cIdFK2		:= 	""
Local cKeySE5 		:= 	""
Local cHistMov 		:= 	""
Local cCamposE5		:= 	""
Local cChaveTit		:= 	""

Local oSubFK2		:= 	Nil
Local oSubFK5		:= 	Nil
Local oSubFK6		:= 	Nil
Local oSubFKA		:= 	Nil
Local oModelMov		:= 	Nil

Local xv_par05 		:=	Nil
Local xv_par09 		:=	Nil

Local lOk 			:= 	.f. 
Local lRet			:= 	.t.
Local lPaMov 		:= 	.f.

Local aTipoSeq 		:= 	{}
Local aColsSEV 		:= 	{}
Local aFlagCTB		:= 	{}

Local lMultNat 		:=	( mv_par04 == 1 )
Local lReconc		:=	Upper(Alltrim(GetMv("ZZ_BXMVCNC"))) == "S"	

Default lFim		:=	.f.

if	lBxTxa == Nil
	lBxTxa 		:= 	SuperGetMv("MV_BXTXA",.f.,"1") == "1"                                        	
	cMCusto 	:= 	SuperGetMv("MV_MCUSTO",.f.,"")                                              	
	nTamSeq		:= 	TamSx3("E5_SEQ")[1]                                                          	
	nTamHist	:= 	iif( AliasInDic("FK5") , TamSx3("FK5_HISTOR")[1] , TamSx3("E5_HISTOR")[1] )
	lFA300PA 	:= 	ExistBlock("FA300PA")                                                        	
	lF300SE5 	:= 	ExistBlock("F300SE5")                                                        	
	lSigaMNT 	:= 	SuperGetMv("MV_NGMNTFI",.f.,"N") == 'S' 										 
	cSequencia	:= 	Replicate("0",nTamSeq)                                                        	
endif

nJuros 			:=	xArray[16]
nMulta			:= 	xArray[17]
nValPag			:= 	xArray[14] 																		// + xArray[16] + xArray[17] + xArray[15]
nDescont		:= 	xArray[15]
xCdAut			:= 	xArray[19]
nValPgto 		:= 	nValPag 																		// Utilizado para compatibilizar com a rotina de rateio multinatureza  
nCorrecao		:=	0		

cMoeda			:=	StrZero(SE2->E2_MOEDA,2)

dbSelectArea("SE2")

if !lFim
             
	if 	SE2->E2_SALDO <= 0 
	    Return
	endif 
		
	if 	Empty(dDataBase) .or. dDataBase < SE2->E2_EMISSAO
		if 	!IsBlind()
			Help( " ", 1, "DATAERRP" )
		endif
		Return
	endif
	
	if 	SE2->E2_TIPO $ MVPAGANT .or. ( SE2->E2_TIPO $ MVTXA .and. !lBxTxa )
	
		dbSelectArea("SE5")
		SE5->(dbsetorder(2))  																// E5_FILIAL + E5_TIPODOC + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO                   
	
		lPaMov 	:= 	.f.
		cKeySE5 := 	xFilial("SE5") + iif(SE2->E2_TIPO $ MVPAGANT,"PA","TX") + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + iif(SE2->E2_TIPO $ MVPAGANT,"PA ","TXA")
	
		if 	SE5->(dbseek(cKeySE5))
			do while SE5->(!Eof()) .and. SE5->(E5_FILIAL + E5_TIPODOC + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO) == cKeySE5
				if 	SE2->(E2_FORNECE + E2_LOJA) == SE5->(E5_CLIFOR + E5_LOJA)
					lPaMov = .t. 
					Exit
				else
					SE5->(dbSkip())
				endif
			enddo
		endif
		
		if !lPaMov	 
	
			//Define os campos que nใo existem na FK5 e que serใo gravados apenas na E5, para que a grava็ใo da E5 continue igual
			//Estrutura para o E5_CAMPOS: "{{'SE5->CAMPO', Valor}, {'SE5->CAMPO', Valor}}"
            
			if	FindFunction("REMOVEASP")	
				xTemp	:=	RemoveAsp(Posicione('SA2',01,xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,'A2_NOME'))
			else
				xTemp	:= xRemoveAsp(Posicione('SA2',01,xFilial('SA2') + SE2->E2_FORNECE + SE2->E2_LOJA,'A2_NOME'))			
			endif	  		
			
			cCamposE5	:= 	" { "
			cCamposE5 	+= 	" { 'E5_DTDIGIT' , dDataBase                                                                                             } , "
			cCamposE5 	+= 	" { 'E5_LOTE'	 , '" + cLoteFin	 																				+ "' } , "
			cCamposE5 	+= 	" { 'E5_TIPO'	 , '" + iif( SE2->E2_TIPO $ MVPAGANT , MVPAGANT , MVTXA )	 										+ "' } , "
			cCamposE5 	+= 	" { 'E5_BENEF'	 , '" + xTemp																						+ "' } , "
			cCamposE5 	+= 	" { 'E5_PREFIXO' , '" + SE2->E2_PREFIXO																				+ "' } , "
			cCamposE5 	+= 	" { 'E5_NUMERO'  , '" + SE2->E2_NUM																					+ "' } , "
			cCamposE5 	+= 	" { 'E5_PARCELA' , '" + SE2->E2_PARCELA																				+ "' } , "
			cCamposE5 	+= 	" { 'E5_CLIFOR'  , '" + SE2->E2_FORNECE																				+ "' } , "
			cCamposE5 	+= 	" { 'E5_FORNECE' , '" + SE2->E2_FORNECE																				+ "' } , "					
			cCamposE5 	+= 	" { 'E5_LOJA'	 , '" + SE2->E2_LOJA																				+ "' } , "
			cCamposE5 	+= 	" { 'E5_ARQCNAB' , '" + xArq																						+ "' } , "
			cCamposE5 	+= 	" { 'E5_MOTBX'	 , 'NOR'                                                                                                 }   "
			cCamposE5 	+= 	" } "

			oModelMov := FwLoadModel("FINM030")													// Model de Movimento a Receber
			oModelMov:SetOperation( MODEL_OPERATION_INSERT )									// Inclusao
	
			oModelMov:Activate()
	
			oModelMov:SetValue( "MASTER" , "E5_GRV"		, .t.		)							// Informa se vai gravar SE5 ou nใo
			oModelMov:SetValue( "MASTER" , "NOVOPROC"	, .t.		)							// Informa que a inclusใo serแ feita com um novo n๚mero de processo
			oModelMov:SetValue( "MASTER" , "E5_CAMPOS"	, cCamposE5 )							// Informa os campos da SE5 que serใo gravados indepentes de FK5
	
			oSubFK5 	:= 	oModelMov:GetModel("FK5DETAIL")
			oSubFKA 	:= 	oModelMov:GetModel("FKADETAIL")
	
			oSubFKA:SetValue( "FKA_IDORIG" , FWUUIDV4()	)
			oSubFKA:SetValue( "FKA_TABORI" , "FK5" 		)
	
			cChaveTit	:= 	xFilial("SE2") + "|" + 	SE2->E2_PREFIXO 	+ "|" + ;
													SE2->E2_NUM 		+ "|" + ;
													SE2->E2_PARCELA 	+ "|" + ;
													SE2->E2_TIPO 		+ "|" + ;
													SE2->E2_FORNECE 	+ "|" + ;
													SE2->E2_LOJA
	
			cIdDoc 		:= 	FinGrvFK7( "SE2" , cChaveTit )
	
			//Informacoes do movimento
	
			oSubFK5:SetValue( "FK5_ORIGEM"		, FunName() 									)
			oSubFK5:SetValue( "FK5_DATA"		, dDataBase										)
			oSubFK5:SetValue( "FK5_VALOR"		, SE2->E2_VLCRUZ 								)
			oSubFK5:SetValue( "FK5_VLMOE2"		, SE2->E2_VALOR 								)
			oSubFK5:SetValue( "FK5_MOEDA"		, StrZero(SE2->E2_MOEDA,2)						)
			oSubFK5:SetValue( "FK5_NATURE"		, SE2->E2_NATUREZ								)
			oSubFK5:SetValue( "FK5_RECPAG"		, "P" 											)
			oSubFK5:SetValue( "FK5_TPDOC"		, iif(SE2->E2_TIPO $ MVPAGANT,"PA","VL")		)
			oSubFK5:SetValue( "FK5_HISTOR"		, SubStr(SE2->E2_HIST,1,nTamHist) 				)
			oSubFK5:SetValue( "FK5_BANCO"		, cBanco 										)
			oSubFK5:SetValue( "FK5_AGENCI"		, cAgencia 										)
			oSubFK5:SetValue( "FK5_CONTA"		, cConta 										)
			oSubFK5:SetValue( "FK5_DTDISP"		, dDataBase										)
			oSubFK5:SetValue( "FK5_FILORI"		, SE2->E2_FILORIG 								)
			oSubFK5:SetValue( "FK5_IDDOC"   	, cIdDoc 										)
			oSubFK5:SetValue( "FK5_CCUSTO"  	, SE2->E2_CCUSTO								)
			oSubFK5:SetValue( "FK5_RATEIO" 		, iif( SE2->E2_RATEIO == "S" , "1" , "2" ) 		)
			if 	SpbInUse()
				oSubFK5:SetValue( "FK5_MODSPB"	, SE2->E2_MODSPB 								)
			endif
			
			if 	oModelMov:VldData()
				oModelMov:CommitData()
				SE5->(dbGoto(oModelMov:GetValue("MASTER","E5_RECNO")))
				if	SE5->(FieldPos("E5_ZZCDAUT")) <> 0 .and. !Empty(xCdAut)
					fGravaSE5(xCdAut)
				endif
			else
				lRet := .f.
				cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
				cLog += cValToChar(oModelMov:GetErrorMessage()[6])
				Help(Nil,Nil,"M030_FA300Processa",Nil,cLog,01,00)
			endif
			
			oModelMov:DeActivate()
			oModelMov:Destroy()
	
			oModelMov	:=	Nil
			oSubFKA  	:= 	Nil
			oSubFK5  	:= 	Nil	
	
			if 	lUsaFlag 															
				aAdd( aFlagCTB, { "E5_LA" , "S" , "SE5" , SE5->(RecNo()) , 0 , 0 , 0 } )
			endif
		
			if 	lFA300PA
				ExecBlock("FA300PA", .f., .f.)
			endif
		
			if	lCCL .or. lCheck 

				xv_par05	:=	mv_par05		
				xv_par09	:=	mv_par09

				mv_par05	:=	0
				mv_par09	:=	0

				lContPA		:=	.t.

				if !lCabec .and. VerPadrao('513') .and. lContab
					nHdlPrv	:= 	HeadProva( cLote , "FINA300" , Substr( cUsuario , 7 , 6 ) , @cArquivo )
					lCabec	:= 	.t.
				endif
				
			  	if 	VerPadrao('513') .and. lContab .and. lCabec
					nTotal 	+= 	DetProva( nHdlPrv , '513' , "FINA300" , cLote , Nil , Nil , Nil , Nil , Nil , Nil , Nil , @aFlagCTB )
				endif

				mv_par05	:=	xv_par05
				mv_par09	:=	xv_par09

				lContPA		:=	Nil

			endif
		
			if	lReconc
				RecLock("SE5",.f.)
					SE5->E5_RECONC	:= 	'x'
				MsUnlock("SE5")
			endif

			AtuSalBco(	cBanco 				, ;
						cAgencia 			, ;
						cConta 				, ;
						SE5->E5_DTDISPO 	, ;
						SE5->E5_VALOR 		, ;
						"-" 				, ;
						lReconc 			)
			
			if 	SE2->E2_FLUXO == 'S'
				AtuSldNat(	SE2->E2_NATUREZ							,;
							SE2->E2_VENCREA							,;
							SE2->E2_MOEDA							,;
							"3"										,;
							"P"										,;
							SE2->E2_VALOR							,;
							SE2->E2_VLCRUZ							,;
							iif(SE2->E2_TIPO $ MVABATIM,"-","+")	,;
							Nil										,;
							FunName()								,;
							"SE2"									,;
							SE2->(Recno())							,;
							0										)
			endif
	   	endif
	
	   	if	SE2->E2_TIPO $ MVTXA
			RecLock("SE2")
				SE2->E2_OK := 'TA'
			MsUnlock("SE2")
	   	endif
	
		Return 
	
	endif
	
	dbSelectArea("SE2")
	
	nSaldo      := 	SE2->E2_SALDO
	cNumero     := 	SE2->E2_NUM
	cPrefixo    := 	SE2->E2_PREFIXO
	cParcela    := 	SE2->E2_PARCELA
	cFornece    := 	SE2->E2_FORNECE
	nSaldoCru   := 	Moeda(SE2->E2_SALDO,1,"P")
	nTotAbat    := 	0
	nRegistro 	:= 	SE2->(Recno())
	
	dbselectarea("SE2")
	dbsetorder(1)
	dbseek( xFilial("SE2") + cPrefixo + cNumero + cParcela )
	
	do while !Eof() .and. 	SE2->E2_FILIAL   == xFilial("SE2")  .and. ;
							SE2->E2_PREFIXO  == cPrefixo 		.and. ;
							SE2->E2_NUM      == cNumero  		.and. ;
							SE2->E2_PARCELA  == cParcela
		if 	SE2->E2_TIPO $ MVABATIM .and. SE2->E2_SALDO > 0 .and. SE2->E2_FORNECE == cFornece
			nTotAbat += Moeda(SE2->E2_SALDO,1,"P")
			RecLock("SE2",.f.)
				SE2->E2_BAIXA   :=	dDataBase
				SE2->E2_SALDO   :=	0
				SE2->E2_MOVIMEN	:=	dDataBase
				SE2->E2_BCOPAG  :=	SE2->E2_PORTADO
			Msunlock("SE2")
			PcoDetLan("000022","02","FINA300")
		endif
		dbskip()
	enddo
	
	dbselectarea("SE2")
	dbgoto(nRegistro)
	 
	nAcresc  := Round(NoRound(xMoeda(SE2->E2_SDACRES,SE2->E2_MOEDA,1,dDataBase,3),3),2)
	nDecresc := Round(NoRound(xMoeda(SE2->E2_SDDECRE,SE2->E2_MOEDA,1,dDataBase,3),3),2)
	
	// Caso seja do Segmento 'N' (Impostos) ou 'J' (Pagamentos) , ajusta acrescimos e decrescimos, pois o banco trata os valores atraves dos campos de Juros e Desconto
	
	if 	cSegmento $ "N|J" .and. ( nJuros + nDescont ) > 0 
		// Valida se o banco retornou o juros no arquivo.
		if 	nJuros > 0 
			nJuros		-=	nAcresc
		endif
		// Valida se o banco retornou desconto no arquivo.
		if 	nDescont > 0 
			nDescont	-=	nDecresc
		endif
	endif

	/*	OLD
	if	cSegmento == "N"
		nJuros 		:= 	nJuros   - nAcresc
		nDescont	:= 	nDescont + nDecresc      		
	elseif	cSegmento == "J"
		nJuros 		+= 	nAcresc
		nAcresc		:=	0
		nDescont	+= 	nDecresc
		nDecresc	:=	0
	endif
	*/

	nValPadrao 		:=	( nValPag - ( nJuros + nMulta + nAcresc ) ) + ( nDescont + nDecresc + nTotAbat )

	/*
	if 	cSegmento $ "N|J"								 
		nValPadrao 	:= 	nValPag - ( nJuros + nMulta - nDescont + nAcresc - nTotAbat )
	else
		nValPadrao 	:= 	nValPag - ( nJuros + nMulta - nDescont + nAcresc - nDecresc - nTotAbat )
	endif
	*/

	nSaldo	:=	Round( nSaldo - nValPadrao , 02 )
	
	if 	nSaldo <= 0
		nSaldo := 0	
		/*
		if	lPAG2TIT
			nVlrPA	:= 	Abs(nSaldo)
		endif
		*/ 
	endif 	

	/*
	nSaldo := Round( nSaldo - nValPadrao , 02 )
	   
	if 	nSaldo < 0
		nSaldo := 0
	endif
	*/

	cTpDesc	:= iif( SE2->E2_TPDESC == "C" , SE2->E2_TPDESC , "I" )
	
	RecLock("SE2")
		SE2->E2_BAIXA   := 	dDataBase 
		SE2->E2_VALLIQ  := 	nValPag 
		SE2->E2_SALDO   := 	nSaldo
		SE2->E2_MOVIMEN := 	dDataBase 
		SE2->E2_BCOPAG  := 	SE2->E2_PORTADO 
		SE2->E2_JUROS   := 	nJuros 
		SE2->E2_DESCONT	:= 	nDescont 
		SE2->E2_CORREC  := 	nCorrecao 
		SE2->E2_MULTA	:= 	nMulta 
		SE2->E2_SDACRES := 	0 
		SE2->E2_SDDECRE := 	0
	MsUnlock("SE2")
	
	if 	SE2->E2_SALDO <= 0
		// Procura por tํtulos de DARF emitidos para baixa-los tamb้m caso existam
		if !Empty( SE2->E2_IDDARF )
			FI9->(dbsetorder(1))
			if 	FI9->(dbseek( xFilial("FI9") + SE2->E2_IDDARF + "A" ) )
				RecLock("FI9")
					FI9->FI9_STATUS := "B"
				MsUnlock("FI9")
			endif
		//For็a a baixa dos tํtulos aglutinados na FI9 caso eles jแ tenham sido baixados na SE2
		elseif SE2->E2_PREFIXO $ "AGP|AGL"
			FI9->(dbsetorder(3))
			if 	FI9->(dbseek( xFilial("FI9") + SE2->E2_FORNECE + SE2->E2_LOJA + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO , .f. )) .and. FI9->FI9_STATUS <> "B"
				RecLock("FI9")
					FI9->FI9_STATUS := "B"
				MsUnlock("FI9")
			endif
		endif
	endif
	
	dbSelectArea( "SE2" )
	
	PcoDetLan("000022","02","FINA300")
	
	aTipoSeq 	:= 	{ "VL" , "BA" , "CP" }
	cSequencia	:= 	Replicate("0",nTamSeq)                                                        	
	
	dbSelectArea("SE5")
	dbsetorder(2)
	For nLaco := 1 to Len(aTipoSeq)
		SE5->(dbSeek(xFilial("SE5") + aTipoSeq[nLaco] + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO , .f. ))
		do while !SE5->(Eof()) .and.	SE5->E5_FILIAL  == xFilial("SE5") 	.and. ;
										SE5->E5_TIPODOC == aTipoSeq[nLaco] 	.and. ;
										SE5->E5_PREFIXO == SE2->E2_PREFIXO 	.and. ;
										SE5->E5_PARCELA == SE2->E2_PARCELA 	.and. ;
										SE5->E5_NUMERO  == SE2->E2_NUM 		.and. ;
										SE5->E5_TIPO    == SE2->E2_TIPO
			if 	SE5->(E5_CLIFOR + E5_LOJA) == SE2->(E2_FORNECE + SE2->E2_LOJA)
				if 	PadL(Alltrim(cSequencia),nTamSeq,"0") < PadL(Alltrim(SE5->E5_SEQ),nTamSeq,"0")
					cSequencia := SE5->E5_SEQ
				endif
			endif
			SE5->(dbskip())
		enddo
	Next nLaco
	
	if 	Len(AllTrim(cSequencia)) < nTamSeq
		cSequencia := PadL(AllTrim(cSequencia),nTamSeq,"0")
	endif
	
	nJurAux 	:= 	nJuros   + nAcresc
	nDescAux 	:= 	nDescont + nDecresc
	cSequencia 	:= 	Soma1(cSequencia,nTamSeq)
	
	/*
	if 	cSegmento $ "N|J"
		nDescAux	:= 	nDescont 
	else
		nDescAux 	:= 	nDescont + nDecresc
	endif
	*/

	oModelMov := FwLoadModel("FINM020")														// Model de Movimento a Pagar
	
	oModelMov:SetOperation( MODEL_OPERATION_INSERT )										// Inclusao
	oModelMov:Activate()
			
	oModelMov:SetValue( "MASTER" , "E5_GRV"		, .t. )										// Informa se vai gravar SE5 ou nใo
	oModelMov:SetValue( "MASTER" , "NOVOPROC"	, .t. )										// Informa que a inclusใo serแ feita com um novo n๚mero de processo
	
	oSubFK2 	:= 	oModelMov:GetModel("FK2DETAIL")
	oSubFK5 	:= 	oModelMov:GetModel("FK5DETAIL")
	oSubFKA 	:= 	oModelMov:GetModel("FKADETAIL")
	oSubFK6 	:= 	oModelMov:GetModel("FK6DETAIL")
	
	cChaveTit	:= 	xFilial("SE2") + "|" + 	SE2->E2_PREFIXO + "|" + ;
											SE2->E2_NUM		+ "|" + ;
											SE2->E2_PARCELA + "|" + ;
											SE2->E2_TIPO 	+ "|" + ;
											SE2->E2_FORNECE + "|" + ;
											SE2->E2_LOJA
	
	cIdFK2 		:= 	FwUUiDV4()
	cIdDoc		:= 	FinGrvFK7("SE2",cChaveTit)
	cCamposE5 	:= 	""
	
	For nI := 1 to 4
	
		if 	nI == 1
			nCpoTp 		:= 	nValPag
			cTpDoc 		:= 	iif( Empty(cLoteFin) , "VL" , "BA" )
			cHistMov	:= 	OemToAnsi( "Valor pago s/ Titulo" ) 
		elseif nI == 2
			nCpoTp 		:= 	nJurAux
			cTpDoc 		:= 	"JR"
			cHistMov 	:= 	OemToAnsi( "Juros s/ Pgto de Titulo" ) 
		elseif nI == 3
			nCpoTp 		:= 	nMulta
			cTpDoc 		:= 	"MT"
			cHistMov 	:= 	OemToAnsi( "Multa s/ Pgto de Titulo" ) 
		elseif nI == 4
			nCpoTp 		:= 	nDescAux
			cTpDoc 		:= 	"DC"
			cHistMov 	:= 	OemToAnsi( "Desconto s/ Pgto de Titulo" ) 
		endif
	
		if	nCpoTp <> 0 .or. nI == 1
	
			//Define os campos que nใo existem nas FKs e que serใo gravados apenas na E5, para que a grava็ใo da E5 continue igual
			
			If !Empty(cCamposE5)
			    cCamposE5	+= 	" | "
			endif
			
			cCamposE5		+= 	" { "
	
			//Define os campos que nใo existem na FK5 e que serใo gravados apenas na E5, para que a grava็ใo da E5 continue igual
			//Estrutura para o E5_CAMPOS: "{{'SE5->CAMPO', Valor}, {'SE5->CAMPO', Valor}}"   

			if	FindFunction("REMOVEASP")	
				xTemp	:=	RemoveAsp(SE2->E2_NOMFOR)
			else
				xTemp	:= xRemoveAsp(SE2->E2_NOMFOR)			
			endif	  		
			
			cCamposE5 	+= 	" { 'E5_DTDIGIT'	, dDatabase                              } , "	
			cCamposE5	+= 	" { 'E5_LOTE'		, '" + cLoteFin						+ "' } , "
			cCamposE5 	+= 	" { 'E5_MOTBX'		, 'DEB'							         } , "
			cCamposE5 	+= 	" { 'E5_TIPO'		, '" + SE2->E2_TIPO					+ "' } , "
			cCamposE5 	+= 	" { 'E5_PREFIXO'	, '" + SE2->E2_PREFIXO				+ "' } , "
			cCamposE5 	+= 	" { 'E5_NUMERO'		, '" + SE2->E2_NUM					+ "' } , "
			cCamposE5 	+= 	" { 'E5_PARCELA'	, '" + SE2->E2_PARCELA				+ "' } , "
			cCamposE5 	+= 	" { 'E5_FORNECE'	, '" + SE2->E2_FORNECE				+ "' } , "
			cCamposE5 	+= 	" { 'E5_CLIFOR'		, '" + SE2->E2_FORNECE				+ "' } , "
			cCamposE5 	+= 	" { 'E5_LOJA'		, '" + SE2->E2_LOJA					+ "' } , "
			cCamposE5 	+= 	" { 'E5_BENEF'		, '" + xTemp						+ "' } , "
			cCamposE5 	+= 	" { 'E5_ARQCNAB'	, '" + xArq							+ "' } , "
			cCamposE5 	+= 	" { 'E5_TPDESC'		, '" + cTpDesc						+ "' }   "
	
			//MOVIMENTO DE BAIXA (PRINCIPAL)  
			
	 		if 	nI == 1
	
				cCamposE5 += ","                  
				cCamposE5 += " { 'E5_VLMULTA' 	,  " + cValToChar(nMulta)			+ "  } , "
				cCamposE5 += " { 'E5_VLDESCO' 	,  " + cValToChar(nDescAux)			+ "  } , "
				cCamposE5 += " { 'E5_VLJUROS' 	,  " + cValToChar(nJurAux)			+ "  } , "
				cCamposE5 += " { 'E5_VLACRES' 	,  " + cValToChar(nAcresc)			+ "  } , "
				cCamposE5 += " { 'E5_VLDECRE' 	,  " + cValToChar(nDecresc)			+ "  } , "
				cCamposE5 += " { 'E5_BANCO'   	, '" + cBanco   					+ "' } , "
				cCamposE5 += " { 'E5_AGENCIA' 	, '" + cAgencia 					+ "' } , "
				cCamposE5 += " { 'E5_CONTA'   	, '" + cConta   					+ "' } , "
				cCamposE5 += " { 'E5_DTDISPO' 	, dDataBase                              }   " 
	
				if !oSubFKA:IsEmpty()																										// Relacionamento FKA X FK2
					oSubFKA:AddLine()																										// Inclui a quantidade de linhas necessแrias
					oSubFKA:GoLine( oSubFKA:Length() )																						// Vai para linha criada
				endif	
	
				oSubFKA:SetValue( 'FKA_IDORIG'	, cIdFK2 													)			
				oSubFKA:SetValue( 'FKA_TABORI'	, "FK2" 													)				
	
				//Dados da baixa a pagar
	
				oSubFK2:SetValue( "FK2_IDDOC"	, cIdDoc 													)
				oSubFK2:SetValue( "FK2_ORIGEM"	, FunName() 												)
				oSubFK2:SetValue( "FK2_FILORI"	, SE2->E2_FILORIG 											)	
				oSubFK2:SetValue( "FK2_DATA"	, SE2->E2_BAIXA 											)
				oSubFK2:SetValue( "FK2_VALOR"	, nCpoTp 													)
				oSubFK2:SetValue( "FK2_VLMOE2"	, xMoeda(SE2->E2_VALLIQ,1,SE2->E2_MOEDA,SE2->E2_BAIXA) 		)
				oSubFK2:SetValue( "FK2_MOEDA"	, StrZero(SE2->E2_MOEDA,2) 									)
				oSubFK2:SetValue( "FK2_NATURE"	, SE2->E2_NATUREZ 											)
				oSubFK2:SetValue( "FK2_RECPAG"	, "P" 														)
				oSubFK2:SetValue( "FK2_TPDOC"	, cTpDoc 													)
				oSubFK2:SetValue( "FK2_HISTOR"	, cHistMov 													)
				oSubFK2:SetValue( "FK2_DOC"		, SE2->E2_NUMBOR 											)
				oSubFK2:SetValue( "FK2_MOTBX"	, "DEB" 													)
				oSubFK2:SetValue( "FK2_SEQ"		, cSequencia 												)
				oSubFK2:SetValue( "FK2_LOTE"	, cLoteFin 													)
				oSubFK2:SetValue( "FK2_ARCNAB"	, xArq	 													)
				if !lUsaFlag
					oSubFK2:SetValue( "FK2_LA"	, iif( lPadrao .and. lContab .and. lCabec , "S" , "N" )		)
				endif
	
				nValTot += nCpoTp   

				// Verifica se o TIPODOC movimenta banco
	
				if	FinVerMov(cTpDoc) 				
	
					if !oSubFKA:IsEmpty()																								// Relacionamento FKA X FK2
						oSubFKA:AddLine()																								// Inclui a quantidade de linhas necessแrias
						oSubFKA:GoLine( oSubFKA:Length() )																				// Vai para linha criada
					endif	
					
					oSubFKA:SetValue( 'FKA_IDORIG'	, FWUUIDV4() 											)
					oSubFKA:SetValue( 'FKA_TABORI'	, 'FK2' 												)
	
					//Dados do Movimento
	
					oSubFK5:SetValue( "FK5_ORIGEM"	, FunName() 											)
					oSubFK5:SetValue( "FK5_FILORI"	, SE2->E2_FILORIG 										)
					oSubFK5:SetValue( "FK5_DATA"	, SE2->E2_BAIXA 										)
					oSubFK5:SetValue( "FK5_VALOR"	, nCpoTp 												)
					oSubFK5:SetValue( "FK5_VLMOE2"	, xMoeda(SE2->E2_VALLIQ,1,SE2->E2_MOEDA,SE2->E2_BAIXA) 	)
					oSubFK5:SetValue( "FK5_MOEDA"	, StrZero(SE2->E2_MOEDA,2) 								)
					oSubFK5:SetValue( "FK5_NATURE"	, SE2->E2_NATUREZ										)
					oSubFK5:SetValue( "FK5_RECPAG"	, "P" 													)
					oSubFK5:SetValue( "FK5_TPDOC"	, cTpDoc												)
					oSubFK5:SetValue( "FK5_HISTOR"	, cHistMov 												)
					oSubFK5:SetValue( "FK5_DOC"		, SE2->E2_NUMBOR 										)
					oSubFK5:SetValue( "FK5_SEQ"		, cSequencia											)			
					oSubFK5:SetValue( "FK5_BANCO"	, cBanco 												)
					oSubFK5:SetValue( "FK5_AGENCI"	, cAgencia 												)
					oSubFK5:SetValue( "FK5_CONTA"	, cConta 												)
					oSubFK5:SetValue( "FK5_DTDISP"	, dDataBase												)
					if 	!lUsaFlag
						oSubFK5:SetValue( "FK5_LA"	, iif( lPadrao .and. lContab .and. lCabec , "S" , "N" )	)
					endif	
				endif
			
			//VALORES ACESSORIOS (MULTA, JUROS, DESCONTO)    
			
			elseif cTpDoc $ "DC|JR|MT"
	
				if	oSubFKA:SeekLine({{'FKA_TABORI',"FK2"}})
	
					if !oSubFK6:IsEmpty()
						oSubFK6:AddLine()																								// Inclui a quantidade de linhas necessแrias
						oSubFK6:GoLine( oSubFK6:Length() )																				// Vai para linha criada
					endif	
	
					oSubFK6:SetValue( "FK6_VALCAL"	, nCpoTp							)
					oSubFK6:SetValue( "FK6_VALMOV"	, nCpoTp							)
					oSubFK6:SetValue( "FK6_TPDESC"	, iif( cTpDesc == "C" , "2" , "1" )	)
					oSubFK6:SetValue( "FK6_TPDOC"	, cTpDoc 							)
					oSubFK6:SetValue( "FK6_RECPAG"	, "P" 								)
					oSubFK6:SetValue( "FK6_TABORI"	, "FK2" 							)
					oSubFK6:SetValue( "FK6_IDORIG"  , cIdFK2 							)					
					oSubFK6:SetValue( "FK6_HISTOR"	, cHistMov 							)
				endif
	
			endif
	
			If 	!Empty(cCamposE5)
				cCamposE5 += " } "
			endif
	
		endif
	Next nI
	
	// Informa os campos da SE5 que serใo gravados indepentes de FK5
	
	oModelMov:SetValue( "MASTER" , "E5_CAMPOS" , cCamposE5 )	
	
	if 	oModelMov:VldData()
		oModelMov:CommitData()
		SE5->(dbGoto(oModelMov:GetValue("MASTER","E5_RECNO")))    
		if	SE5->(FieldPos("E5_ZZCDAUT")) <> 0 .and. !Empty(xCdAut)
			fGravaSE5(xCdAut)
		endif
		if	Empty(SE5->E5_DOCUMEN)
			RecLock("SE5",.f.)
				SE5->E5_DOCUMEN	:=	iif( Empty(SE2->E2_NUMBOR) , iif( SEA->(!Eof()) , SEA->EA_NUMBOR , "" ) , SE2->E2_NUMBOR ) 
            MsUnlock("SE5")
    	endif
		if	lReconc
			RecLock("SE5",.f.)
				SE5->E5_RECONC	:= 	'x'
			MsUnlock("SE5")
		endif
	else
		lRet :=	.f.
		cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
		cLog +=	cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
		cLog +=	cValToChar(oModelMov:GetErrorMessage()[6])
		Help(Nil,Nil,"M030_FA300ProcBX",Nil,cLog,1,0)
	endif
	
	oModelMov:DeActivate()
	oModelMov:Destroy()
	
	oModelMov := Nil
	oSubFKA   := Nil
	oSubFK2   := Nil		
	oSubFK5   := Nil	
	oSubFK6   := Nil		
	
	if 	lUsaFlag .and. lPadrao .and. lContab .and. lCabec 
		aAdd( aFlagCTB, { "E5_LA" , "S" , "SE5" , SE5->(RecNo()) , 0 , 0 , 0 } )
	endif
	
	if 	SE2->E2_FLUXO == 'S'
		AtuSldNat(	SE2->E2_NATUREZ							,;
					SE2->E2_VENCREA							,;
					SE2->E2_MOEDA							,;
					"3"										,;
					"P"										,;
					FK2->FK2_VLMOE2							,;
					FK2->FK2_VALOR							,;
					iif(SE2->E2_TIPO $ MVABATIM,"-", "+")	,;
					Nil										,;
					FunName()								,;
					"SE2"									,;
					SE2->(Recno())							,;
					0										)
	endif
	
	if 	Empty(cLoteFin)
		AtuSalBco(	cBanco			, ;
					cAgencia		, ;
					cConta			, ;
					SE5->E5_DATA	, ;
					SE5->E5_VALOR	, ;
					"-"				, ;
					lReconc			)
	endif	
	
	PcoDetLan("000022","01","FINA300")
	
	if	lF300SE5
		ExecBlock("F300SE5",.f.,.f.)
	endif
	
	if 	lSigaMNT .and. FindFunction("NGBAIXASE2")
		NgBaixaSE2(1)
		if 	FindFunction("MNT765CONF") 														// Fun็ใo que gera uma apropria็ใo de d้bito da multa, (Integra็ใo SIGAFIN - SIGAMNT).
			Private lPagAutFin := Nil
			lPagAutFin := .f. 
			MNT765Conf(3) 
		endif
	endif
	
	dbSelectArea("SA2")      
	dbsetorder(1)
	
	if 	dbSeek(xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA )
		if 	nSaldoCru >= SA2->A2_SALDUP
			nSalDup := 0
		else
			nSalDup := SA2->A2_SALDUP - nSaldoCru
		endif
		RecLock("SA2")
			SA2->A2_SALDUP 	:=	nSalDup
			SA2->A2_SALDUPM	:=	SA2->A2_SALDUPM - xMoeda(nSaldoCru,SE2->E2_MOEDA,Val(cMCusto),SE2->E2_VENCREA)
		MsUnlock("SA2")
	endif
		
	dbSelectArea("SE2")
	
	if !lCabec .and. lPadrao .and. lContab
		nHdlPrv	:= 	HeadProva( cLote , "FINA300" , Substr( cUsuario , 7 , 6 ) , @cArquivo )
		lCabec	:= 	.t.
	endif
	
	if 	lMultNat .and. ( SE2->E2_MULTNAT == "1" )
		MultNatB("SE2",.f.,"1",@lOk,@aColsSEV,@lMultNat,.t.)
		if 	lOk
			MultNatC("SE2",@nHdlPrv,@nTotal,@cArquivo,( mv_par03 == 1 ),.t.,"1",@nTotLtEZ,lOk,aColsSEV,.t.)
		endif
	else
	  	if 	lPadrao .and. lContab .and. lCabec
			nTotal += DetProva( nHdlPrv , cPadrao , "FINA300" , cLote , Nil , Nil , Nil , Nil , Nil , Nil , Nil , @aFlagCTB )
		endif
	endif
	
endif

if	lFim

	if !Empty(cLoteFin) .and. lBxCnab .and. nValTot > 0
	
		//Define os campos que nใo existem na FK5 e que serใo gravados apenas na E5, para que a grava็ใo da E5 continue igual
		//Estrutura para o E5_CAMPOS: "{{'SE5->CAMPO', Valor}, {'SE5->CAMPO', Valor}}"

		cCamposE5	:= 	" { "		
		cCamposE5 	+= 	" {'E5_DTDIGIT' , dDataBase          } , "
		cCamposE5 	+= 	",{'E5_LOTE'	, '" + cLoteFin + "' }   "
		cCamposE5 	+=	" } "

		oModelMov 	:= 	FwLoadModel("FINM030")														// Model de Movimento Bancแrio

		oModelMov:SetOperation( MODEL_OPERATION_INSERT )											// Inclusao
		oModelMov:Activate()																		// Ativa o modelo de dados

		oModelMov:SetValue( "MASTER" 	, "E5_GRV"		, .t.		)								// Informa se vai gravar SE5 ou nใo
		oModelMov:SetValue( "MASTER" 	, "NOVOPROC"	, .t.		)								// Informa que a inclusใo serแ feita com um novo n๚mero de processo
		oModelMov:SetValue( "MASTER" 	, "E5_CAMPOS"	, cCamposE5	)								// Informa os campos da SE5 que serใo gravados indepentes de FK5 

		oSubFK5 	:= 	oModelMov:GetModel( "FK5DETAIL" )
		oSubFKA 	:= 	oModelMov:GetModel( "FKADETAIL" )

		oSubFKA:SetValue( 'FKA_IDORIG'	, FWUUIDV4() 	)
		oSubFKA:SetValue( 'FKA_TABORI'	, 'FK5' 		)

		oSubFK5:SetValue( "FK5_ORIGEM"	, FunName() 									)
		oSubFK5:SetValue( "FK5_DATA"	, dDataBase	 									)
		oSubFK5:SetValue( "FK5_VALOR"	, nValTot	 									)
		oSubFK5:SetValue( "FK5_RECPAG"	, "P" 											)
		oSubFK5:SetValue( "FK5_BANCO"	, cBanco 										)
		oSubFK5:SetValue( "FK5_AGENCI"	, cAgencia 										)
		oSubFK5:SetValue( "FK5_CONTA"	, cConta 										)
		oSubFK5:SetValue( "FK5_DTDISP"	, dDataBase	 									)
		oSubFK5:SetValue( "FK5_HISTOR"	, "Bx p/ Retorno SISPAG | Lote: " + cLoteFin	) 
		oSubFK5:SetValue( "FK5_TPDOC"	, "VL"											)
		oSubFK5:SetValue( "FK5_NATURE"	, FinNatMov("P")								)
		oSubFK5:SetValue( "FK5_MOEDA"	, cMoeda										)
		oSubFK5:SetValue( "FK5_FILORI"	, cFilAnt 										)		
		oSubFK5:SetValue( "FK5_LOTE"	, cLoteFin 										) 	
		if 	SpbInUse()
			oSubFK5:SetValue( "FK5_MODSPB" , "1" )
		endif                             	

		if 	oModelMov:VldData()
			oModelMov:CommitData()
			SE5->(dbGoto(oModelMov:GetValue( "MASTER" , "E5_RECNO" )))
			if	lReconc
				RecLock("SE5",.f.)
					SE5->E5_RECONC	:= 	'x'
				MsUnlock("SE5")
			endif
		else
			lRet := .f.
			cLog :=	cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[6])
			Help(Nil,Nil,"M030_FA300ProcMV",Nil,cLog,1,0)
		endif
		
		oModelMov:DeActivate()
		oModelMov:Destroy()

		oModelMov	:=	Nil
		oSubFKA  	:= 	Nil
		oSubFK5  	:= 	Nil	
		
		PcoDetLan("000022","01","FINA300")
		
		AtuSalBco(	cBanco			, ;
					cAgencia		, ;
					cConta			, ;
					SE5->E5_DATA	, ;
					SE5->E5_VALOR	, ;
					"-"				, ; 
					lReconc			)

	endif
	
	PcoFinLan("000022")
	                     
	PutFileInEof("SE2")
	PutFileInEof("SE5")

	// Contabiliza pela variavel VALOR. Nao necessita de controle de flag.	  
	
	VALOR := nValTot

	if	lPadrao .and. lContab .and. lCabec
		nTotal += DetProva( nHdlPrv , cPadrao , "FINA300" , cLote , , , , , , , , @aFlagCTB )
	endif
	
	if 	lPadrao .and. lContab .and. lCabec .and. nTotal <> 0
		RodaProva( nHdlPrv , nTotal )
		lDigita	:=	( mv_par05 == 1 )
		lAglut 	:=	( mv_par06 == 1 )
		cA100Incl( cArquivo , nHdlPrv , 2 , cLote , lDigita , lAglut , , , , @aFlagCTB )
	endif     
	
endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPRETSISบAutor  ณMicrosiga           บ Data ณ  03/12/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function GetNewLote()

Local cQuery	:= 	""
Local cLoteBx	:=	""
Local lExit		:=	.f.

do while !lExit

	cLoteBx	:=	StrZero( Val(GetMv("ZZ_BXACNAB")) + 1 , TamSx3("E5_LOTE")[1] )

	cQuery	:= 	" Select E5_LOTE "
	cQuery 	+= 	" From " + RetSqlName("SE5") 
	cQuery 	+= 	" Where E5_FILIAL >= '" + Replicate(" ",FwSizeFilial())	+ "' and " 
	cQuery	+=		"   E5_FILIAL <= '" + Replicate("Z",FwSizeFilial())	+ "' and " 
	cQuery	+=		"   E5_LOTE    = '" + cLoteBx						+ "' and " 
	cQuery 	+= 		"   D_E_L_E_T_ = ' '                                         "

	TcQuery ChangeQuery(@cQuery) New Alias "XQRY"

	PutMv("ZZ_BXACNAB",cLoteBx)

	if 	XQRY->(Bof()) .and. XQRY->(Eof())
		lExit := .t.
	endif

	XQRY->(dbclosearea())

enddo
	
Return ( cLoteBx )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPRETSISบAutor  ณMicrosiga           บ Data ณ  03/12/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fChecaPar(cPar,cDescric,cConteud,cTipo)

cPar := PadR(cPar,Len(SX6->X6_VAR))
	
SX6->(dbsetorder(1))

if !SX6->(dbseek( Space(Len(SX6->X6_FIL)) + cPar , .f. ))
	Reclock("SX6",.t.)
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
ฑฑบPrograma  ณXIMPRETSISบAutor  ณMicrosiga           บ Data ณ  03/12/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fGravaSE5(xCdAut)       		

Local cChave	:=	xFilial("SE5",SE2->E2_FILIAL) + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA
Local aAreaSE2	:=	SE2->(GetArea())
Local aAreaSE5	:=	SE5->(GetArea())
Local aArea		:=	GetArea()

Default xCdAut	:=	""

SE5->(dbsetorder(7)) 
if	SE5->(dbseek(cChave))
	do while cChave == SE5->(E5_FILIAL + E5_PREFIXO + E5_NUMERO + E5_PARCELA + E5_TIPO + E5_CLIFOR + E5_LOJA)
		if 	SE5->E5_RECPAG = 'P'
			if 	( ( Alltrim(SE5->E5_TIPODOC) $ "PA/TXA" .and. SE5->E5_MOTBX == "NOR" ) .or. ( Alltrim(SE5->E5_TIPODOC) $ "VL/BA" .and. SE5->E5_MOTBX == "DEB" ) ) 
				if	SE5->(FieldPos("E5_ZZCDAUT")) <> 0 .and. Empty(SE5->E5_ZZCDAUT)
					RecLock("SE5",.f.)
						SE5->E5_ZZCDAUT	:=	xCdAut	
					MsUnlock("SE5")
				endif
			endif
		endif
		SE5->(dbskip())
	enddo
endif

RestArea(aAreaSE5)           		
RestArea(aAreaSE2)
RestArea(aArea)

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPRETSISบAutor  ณMicrosiga           บ Data ณ  03/12/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRemoveAsp(cConteudo) 

Default cConteudo	:=	""

if !Empty(AllTrim(cConteudo))
	cConteudo 		:= 	StrTran(StrTran(cConteudo,"'",""),'"',"")
endif

Return ( cConteudo )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPRETSISบAutor  ณMicrosiga           บ Data ณ  03/12/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xLegenda()

if	xAgl
	BrwLegenda(	"Legenda"	,	"Legenda"	,	{	{"ENABLE"			,"Pagamento Efetuado"					}	,;
													{"BR_LARANJA"		,"Pagamento Efetuado - TED Aglutinada"	}	,;
													{"BR_BRANCO"		,"Pagamento Agendado"					}	,;
													{"DISABLE"			,"Pagamento Nใo Agendado"				}	,;    
													{"BR_AZUL"   		,"PA jแ Gerada"            				}	,;
													{"BR_PRETO"			,"Titulo Jแ Baixado"					}	})
else                                                                                                        	
	BrwLegenda(	"Legenda"	,	"Legenda"	,	{	{"ENABLE"			,"Pagamento Efetuado"					}	,;
													{"BR_BRANCO"		,"Pagamento Agendado"					}	,;
													{"DISABLE"			,"Pagamento Nใo Agendado"				}	,;    
													{"BR_AZUL"   		,"PA jแ Gerada"            				}	,;
													{"BR_PRETO"			,"Titulo Jแ Baixado"					}	})
endif
	
Return 	

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPRETSISบAutor  ณMicrosiga           บ Data ณ  03/12/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xBxLotTED(xArray,lContab,cPadrao,lPadrao,lCabec,lUsaFlag,nHdlPrv,nTotal,cSegmento)

Local aTmp		:=	{}
Local cQuery	:=	""

cQuery	:=	" Select R_E_C_N_O_ RECNOSE2 "
cQuery	+=	" From " + RetSqlName("SE2") 
cQuery	+=	" Where E2_FILIAL  = '" + SE2->E2_FILIAL	+ "' and " 
cQuery	+=		"   E2_ZZSQTED = '" + SE2->E2_ZZSQTED	+ "' and "    
cQuery	+=		"   D_E_L_E_T_ = ' '                             " 

TcQuery ChangeQuery(@cQuery) New Alias "XSE2" 

do while XSE2->(!Eof())

	SE2->(dbgoto(XSE2->RECNOSE2))

	aTmp		:=	{	.t.                     							,;		// 01
						xArray[02]											,;		// 02
						SE2->E2_PREFIXO										,;		// 03
						SE2->E2_NUM											,;		// 04
						SE2->E2_PARCELA										,;		// 05
						SE2->E2_TIPO										,;		// 06
						SE2->E2_FORNECE										,;		// 07
						SE2->E2_LOJA										,;		// 08
						SE2->E2_NOMFOR										,;		// 09
						SE2->E2_VALOR										,;		// 10
						SE2->E2_VENCREA										,;		// 11
						SE2->E2_SALDO										,;		// 12
						xArray[13]											,; 		// 13
						SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE	,;   	// 14
						0													,;  	// 15
						0													,;		// 16
						0													,;		// 17
						xArray[18]											,;		// 18
						xArray[19]											,;		// 19
						xArray[20]											,;		// 20
						xArray[21]											,;		// 21
						xArray[22]											,;		// 22
						xArray[23]											,;		// 23
						xArray[24] 											,;		// 24
						.f.        											,;		// 25
						SE2->E2_NUMBOR										,;		// 26
						SE2->(Recno())										} 		// 27    

	fBaixaTit(aTmp,lContab,cPadrao,lPadrao,@lCabec,lUsaFlag,@nHdlPrv,@nTotal,cSegmento)

	XSE2->(dbskip())
enddo

XSE2->(dbclosearea())

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPRETSISบAutor  ณMicrosiga           บ Data ณ  03/12/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetMotivo(cCod)

Local cRet	:=	""

if	cCod == '00' 
	cRet := "Este c๓digo indica que o pagamento foi confirmado"
elseif	cCod == '01' 
	cRet := "Insufici๊ncia de Fundos - D้bito Nใo Efetuado"
elseif	cCod == '02' 
	cRet := "Cr้dito ou D้bito Cancelado pelo Pagador/Credor"
elseif	cCod == '03' 
	cRet := "D้bito Autorizado pela Ag๊ncia - Efetuado"
elseif	cCod == 'AA' 
	cRet := "Controle Invแlido"
elseif	cCod == 'AB' 
	cRet := "Tipo de Opera็ใo Invแlido"
elseif	cCod == 'AC' 
	cRet := "Tipo de Servi็o Invแlido"
elseif	cCod == 'AD' 
	cRet := "Forma de Lan็amento Invแlida"
elseif	cCod == 'AE' 
	cRet := "Tipo/N๚mero de Inscri็ใo Invแlido"
elseif	cCod == 'AF' 
	cRet := "C๓digo de Conv๊nio Invแlido"
elseif	cCod == 'AG' 
	cRet := "Ag๊ncia/Conta Corrente/DV Invแlido"
elseif	cCod == 'AH' 
	cRet := "Nบ Seqüencial do Registro no Lote Invแlido"
elseif	cCod == 'AI' 
	cRet := "C๓digo de Segmento de Detalhe Invแlido"
elseif	cCod == 'AJ' 
	cRet := "Tipo de Movimento Invแlido"
elseif	cCod == 'AK' 
	cRet := "C๓digo da Cโmara de Compensa็ใo do Banco Favorecido/Depositแrio Invแlido"
elseif	cCod == 'AL' 
	cRet := "C๓digo do Banco Favorecido ou Depositแrio Invแlido"
elseif	cCod == 'AM' 
	cRet := "Ag๊ncia Mantenedora da Conta Corrente do Favorecido Invแlida"
elseif	cCod == 'AN' 
	cRet := "Conta Corrente/DV do Favorecido Invแlido"
elseif	cCod == 'AO' 
	cRet := "Nome do Favorecido Nใo Informado"
elseif	cCod == 'AP' 
	cRet := "Data Lan็amento Invแlido"
elseif	cCod == 'AQ' 
	cRet := "Tipo/Quantidade da Moeda Invแlido"
elseif	cCod == 'AR' 
	cRet := "Valor do Lan็amento Invแlido"
elseif	cCod == 'AS' 
	cRet := "Aviso ao Favorecido - Identifica็ใo Invแlida"
elseif	cCod == 'AT' 
	cRet := "Tipo/N๚mero de Inscri็ใo do Favorecido Invแlido"
elseif	cCod == 'AU' 
	cRet := "Logradouro do Favorecido Nใo Informado"
elseif	cCod == 'AV' 
	cRet := "Nบ do Local do Favorecido Nใo Informado"
elseif	cCod == 'AW' 
	cRet := "Cidade do Favorecido Nใo Informada"
elseif	cCod == 'AX' 
	cRet := "CEP/Complemento do Favorecido Invแlido"
elseif	cCod == 'AY' 
	cRet := "Sigla do Estado do Favorecido Invแlida"
elseif	cCod == 'AZ' 
	cRet := "C๓digo/Nome do Banco Depositแrio Invแlido"
elseif	cCod == 'BA' 
	cRet := "C๓digo/Nome da Ag๊ncia Depositแria Nใo Informado"
elseif	cCod == 'BB' 
	cRet := "Seu N๚mero Invแlido"
elseif	cCod == 'BC' 
	cRet := "Nosso N๚mero Invแlido"
elseif	cCod == 'BD' 
	cRet := "Inclusใo Efetuada com Sucesso"
elseif	cCod == 'BE' 
	cRet := "Altera็ใo Efetuada com Sucesso"
elseif	cCod == 'BF' 
	cRet := "Exclusใo Efetuada com Sucesso"
elseif	cCod == 'BG' 
	cRet := "Ag๊ncia/Conta Impedida Legalmente"
elseif	cCod == 'BH' 
	cRet := "Empresa nใo pagou salแrio"
elseif	cCod == 'BI' 
	cRet := "Falecimento do mutuแrio"
elseif	cCod == 'BJ' 
	cRet := "Empresa nใo enviou remessa do mutuแrio"
elseif	cCod == 'BK' 
	cRet := "Empresa nใo enviou remessa no vencimento"
elseif	cCod == 'BL' 
	cRet := "Valor da parcela invแlida"
elseif	cCod == 'BM' 
	cRet := "Identifica็ใo do contrato invแlida"
elseif	cCod == 'BN' 
	cRet := "Opera็ใo de Consigna็ใo Incluํda com Sucesso"
elseif	cCod == 'BO' 
	cRet := "Opera็ใo de Consigna็ใo Alterada com Sucesso"
elseif	cCod == 'BP' 
	cRet := "Opera็ใo de Consigna็ใo Excluํda com Sucesso"
elseif	cCod == 'BQ' 
	cRet := "Opera็ใo de Consigna็ใo Liquidada com Sucesso"
elseif	cCod == 'BR'                                       
	cRet := "Reativa็ใo Efetuada com Sucesso"
elseif	cCod == 'BS' 
	cRet := "Suspensใo Efetuada com Sucesso"
elseif	cCod == 'CA' 
	cRet := "C๓digo de Barras - C๓digo do Banco Invแlido"
elseif	cCod == 'CB' 
	cRet := "C๓digo de Barras - C๓digo da Moeda Invแlido"
elseif	cCod == 'CC' 
	cRet := "C๓digo de Barras - Dํgito Verificador Geral Invแlido"
elseif	cCod == 'CD' 
	cRet := "C๓digo de Barras - Valor do Tํtulo Invแlido"
elseif	cCod == 'CE' 
	cRet := "C๓digo de Barras - Campo Livre Invแlido"
elseif	cCod == 'CF' 
	cRet := "Valor do Documento Invแlido"
elseif	cCod == 'CG' 
	cRet := "Valor do Abatimento Invแlido"
elseif	cCod == 'CH' 
	cRet := "Valor do Desconto Invแlido"
elseif	cCod == 'CI' 
	cRet := "Valor de Mora Invแlido"
elseif	cCod == 'CJ' 
	cRet := "Valor da Multa Invแlido"
elseif	cCod == 'CK' 
	cRet := "Valor do IR Invแlido"
elseif	cCod == 'CL' 
	cRet := "Valor do ISS Invแlido"
elseif	cCod == 'CM' 
	cRet := "Valor do IOF Invแlido"
elseif	cCod == 'CN' 
	cRet := "Valor de Outras Dedu็๕es Invแlido"
elseif	cCod == 'CO' 
	cRet := "Valor de Outros Acr้scimos Invแlido"
elseif	cCod == 'CP' 
	cRet := "Valor do INSS Invแlido"
elseif	cCod == 'HA' 
	cRet := "Lote Nใo Aceito"
elseif	cCod == 'HB' 
	cRet := "Inscri็ใo da Empresa Invแlida para o Contrato"
elseif	cCod == 'HC' 
	cRet := "Conv๊nio com a Empresa Inexistente/Invแlido para o Contrato"
elseif	cCod == 'HD' 
	cRet := "Ag๊ncia/Conta Corrente da Empresa Inexistente/Invแlido para o Contrato"
elseif	cCod == 'HE' 
	cRet := "Tipo de Servi็o Invแlido para o Contrato"
elseif	cCod == 'HF' 
	cRet := "Conta Corrente da Empresa com Saldo Insuficiente"
elseif	cCod == 'HG' 
	cRet := "Lote de Servi็o Fora de Seqü๊ncia"
elseif	cCod == 'HH' 
	cRet := "Lote de Servi็o Invแlido"
elseif	cCod == 'HI' 
	cRet := "Arquivo nใo aceito"
elseif	cCod == 'HJ' 
	cRet := "Tipo de Registro Invแlido"
elseif	cCod == 'HK' 
	cRet := "C๓digo Remessa / Retorno Invแlido"
elseif	cCod == 'HL' 
	cRet := "Versใo de layout invแlida"
elseif	cCod == 'HM' 
	cRet := "Mutuแrio nใo identificado"
elseif	cCod == 'HN' 
	cRet := "Tipo do beneficio nใo permite empr้stimo"
elseif	cCod == 'HO' 
	cRet := "Beneficio cessado/suspenso"
elseif	cCod == 'HP' 
	cRet := "Beneficio possui representante legal"
elseif	cCod == 'HQ' 
	cRet := "Beneficio ้ do tipo PA (Pensใo alimentํcia)"
elseif	cCod == 'HR' 
	cRet := "Quantidade de contratos permitida excedida"
elseif	cCod == 'HS' 
	cRet := "Beneficio nใo pertence ao Banco informado"
elseif	cCod == 'HT' 
	cRet := "Inํcio do desconto informado jแ ultrapassado"
elseif	cCod == 'HU' 
	cRet := "N๚mero da parcela invแlida"
elseif	cCod == 'HV' 
	cRet := "Quantidade de parcela invแlida"
elseif	cCod == 'HW' 
	cRet := "Margem consignแvel excedida para o mutuแrio dentro do prazo do contrato"
elseif	cCod == 'HX' 
	cRet := "Empr้stimo jแ cadastrado"
elseif	cCod == 'HY' 
	cRet := "Empr้stimo inexistente"
elseif	cCod == 'HZ' 
	cRet := "Empr้stimo jแ encerrado"
elseif	cCod == 'H1' 
	cRet := "Arquivo sem trailer"
elseif	cCod == 'H2' 
	cRet := "Mutuแrio sem cr้dito na compet๊ncia"
elseif	cCod == 'H3' 
	cRet := "Nใo descontado – outros motivos"
elseif	cCod == 'H4' 
	cRet := "Retorno de Cr้dito nใo pago"
elseif	cCod == 'H5' 
	cRet := "Cancelamento de empr้stimo retroativo"
elseif	cCod == 'H6' 
	cRet := "Outros Motivos de Glosa"
elseif	cCod == 'H7' 
	cRet := "Margem consignแvel excedida para o mutuแrio acima do prazo do contrato"
elseif	cCod == 'H8' 
	cRet := "Mutuแrio desligado do empregador"
elseif	cCod == 'H9' 
	cRet := "Mutuแrio afastado por licen็a"
elseif	cCod == 'IA' 
	cRet := "Primeiro nome do mutuแrio diferente do primeiro nome do movimento do censo ou diferente da base de Titular do Benefํcio"
elseif	cCod == 'IB' 
	cRet := "Benefํcio suspenso/cessado pela APS ou Sisobi"
elseif	cCod == 'IC' 
	cRet := "Benefํcio suspenso por depend๊ncia de cแlculo"
elseif	cCod == 'ID' 
	cRet := "Benefํcio suspenso/cessado pela inspetoria/auditoria"
elseif	cCod == 'IE' 
	cRet := "Benefํcio bloqueado para empr้stimo pelo beneficiแrio"
elseif	cCod == 'IF' 
	cRet := "Benefํcio bloqueado para empr้stimo por TBM"
elseif	cCod == 'IG' 
	cRet := "Benefํcio estแ em fase de concessใo de PA ou desdobramento"
elseif	cCod == 'IH' 
	cRet := "Benefํcio cessado por ๓bito"
elseif	cCod == 'II' 
	cRet := "Benefํcio cessado por fraude"
elseif	cCod == 'IJ' 
	cRet := "Benefํcio cessado por concessใo de outro benefํcio"
elseif	cCod == 'IK' 
	cRet := "Benefํcio cessado: estatutแrio transferido para ๓rgใo de origem"
elseif	cCod == 'IL' 
	cRet := "Empr้stimo suspenso pela APS"
elseif	cCod == 'IM' 
	cRet := "Empr้stimo cancelado pelo banco"
elseif	cCod == 'IN' 
	cRet := "Cr้dito transformado em PAB"
elseif	cCod == 'IO' 
	cRet := "T้rmino da consigna็ใo foi alterado"
elseif	cCod == 'IP' 
	cRet := "Fim do empr้stimo ocorreu durante perํodo de suspensใo ou concessใo"
elseif	cCod == 'IQ' 
	cRet := "Empr้stimo suspenso pelo banco"
elseif	cCod == 'IR' 
	cRet := "Nใo averba็ใo de contrato – quantidade de parcelas/compet๊ncias informadas ultrapassou a data limite da extin็ใo de cota do dependente titular de benefํcios"
elseif	cCod == 'TA' 
	cRet := "Lote Nใo Aceito - Totais do Lote com Diferen็a"
elseif	cCod == 'YA' 
	cRet := "Tํtulo Nใo Encontrado"
elseif	cCod == 'YB' 
	cRet := "Identificador Registro Opcional Invแlido"
elseif	cCod == 'YC' 
	cRet := "C๓digo Padrใo Invแlido"
elseif	cCod == 'YD' 
	cRet := "C๓digo de Ocorr๊ncia Invแlido"
elseif	cCod == 'YE' 
	cRet := "Complemento de Ocorr๊ncia Invแlido"
elseif	cCod == 'YF' 
	cRet := "Alega็ใo jแ Informada"
elseif	cCod == 'ZA' 
	cRet := "Ag๊ncia / Conta do Favorecido Substituํda Observa็ใo: As ocorr๊ncias iniciadas com 'ZA' tem carแter informativo para o cliente"
elseif	cCod == 'ZB' 
	cRet := "Diverg๊ncia entre o primeiro e ๚ltimo nome do beneficiแrio versus primeiro e ๚ltimo nome na Receita Federal"
elseif	cCod == 'ZC' 
	cRet := "Confirma็ใo de Antecipa็ใo de Valor"
elseif	cCod == 'ZD' 
	cRet := "Antecipa็ใo parcial de valor"
elseif	cCod == 'ZE' 
	cRet := "Tํtulo bloqueado na base"
elseif	cCod == 'ZF' 
	cRet := "Sistema em conting๊ncia – tํtulo valor maior que refer๊ncia"
elseif	cCod == 'ZG' 
	cRet := "Sistema em conting๊ncia – tํtulo vencido"
elseif	cCod == 'ZH' 
	cRet := "Sistema em conting๊ncia – tํtulo indexado"
elseif	cCod == 'ZI' 
	cRet := "Beneficiแrio divergente"
elseif	cCod == 'ZJ' 
	cRet := "Limite de pagamentos parciais excedido"
elseif	cCod == 'ZK' 
	cRet := "Boleto jแ liquidado"        		
endif

Return ( cRet )                     

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

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPRETSISบAutor  ณMicrosiga           บ Data ณ  03/12/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xEstornaBord(cRetorno,cOcor,cBco,lAut)

Local s
Local xFilAtu	:=	cFilAnt
Local cNumBor 	:= 	SE2->E2_NUMBOR
Local lFA300Rej	:= 	ExistBlock("FA300REJ")
Local lPCCBaixa	:= 	SuperGetMv("MV_BX10925",.t.,"2") == "1"  

Local aArea		:=	GetArea()
Local aAreaSM0	:=	SM0->(GetArea())

Local cCC		:=	SuperGetMv("ZZ_EMLRJBX",.f.,"")
Local oObj		:= 	GeneralClass():New()
Local cCCO		:=	""
Local cPara		:=	Alltrim(UsrRetMail(RetCodUsr()))
Local cHtml		:=	""
Local cQuery	:=	""

Local aAnexos	:=	{}     

Private cLote

LoteCont( "FIN" )

dbSelectArea("SEA")
dbSetOrder(2)

if	IsBlind() .or. Type("__LocalDriver") == "U" .or. lAut
	cHtml := fRetCab() 
	cHtml += fCabIte() 
	cHtml += fDetIte() 
	cHtml += '</table>' + CRLF + CRLF + '</br>' + CRLF + CRLF 
	cHtml += xCabIte() 
	cHtml += xDetIte(cOcor,cBco) 
	cHtml += '</table>' + CRLF + CRLF + '</br>' + CRLF + CRLF 
	cHtml += fRodIte()      
	if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
	//	MemoWrit("C:\TEMP7\HTML.HTM",cHtml)
	endif
endif

if !SEA->(dbseek( xFilial("SEA") + SE2->E2_NUMBOR + "P" + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. ))
	For s := 1 to Len(aFiliais)
		if	SEA->(dbseek( xFilial("SEA",aFiliais[s]) + SE2->E2_NUMBOR + "P" + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. ))
    		Exit
       	endif
	Next s    
endif

if !Empty(SE2->E2_FILIAL)
	cFilAnt := SE2->E2_FILIAL
else
	cFilAnt := SE2->E2_FILORIG
endif

if 	SEA->(!Eof())
	if	IsBlind() .or. Type("__LocalDriver") == "U" .or. lAut
		if	SEA->(FieldPos("EA_ZZUSR")) <> 0 .and. !Empty(SEA->EA_ZZUSR)
			cPara	:=	UsrRetMail(SEA->EA_ZZUSR)
		elseif	lAtivo  
			if	lCCL .or. lCheck .or. lMastra
				cQuery	:=	" Select Z43_EMLBOR "
				cQuery	+=	" From " + RetSqlName("Z43")
				cQuery	+=	" Where Z43_FILIAL = '" + xFilial("Z43")	+ " and "
				cQuery	+=		"   Z43_NUMBOR = '" + cNumBor			+ " and "
				cQuery	+=		"   D_E_L_E_T_ = ' '                            "			
				TcQuery ChangeQuery(@cQuery) New Alias "XMAIL"
				cPara	:=	XMAIL->Z43_EMLBOR
				XMAIL->(dbclosearea())
			else
				cQuery	:=	" Select ZAT_EMLBOR "
				cQuery	+=	" From " + RetSqlName("ZAT")
				cQuery	+=	" Where ZAT_FILIAL = '" + xFilial("ZAT")	+ " and "
				cQuery	+=		"   ZAT_NUMBOR = '" + cNumBor			+ " and "
				cQuery	+=		"   D_E_L_E_T_ = ' '                            "			
				TcQuery ChangeQuery(@cQuery) New Alias "XMAIL"
				cPara	:=	XMAIL->ZAT_EMLBOR
				XMAIL->(dbclosearea())
			endif
		endif             
		if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
		//	cCCO := "alexandre@zapponi.com.br"
		endif
	endif             
	if !Empty(cHtml) .and. ( !Empty(cPara) .or. !Empty(cCC) .or. !Empty(cCCO) )
		oObj:DispMail(cPara,cHtml,"Titulos Rejeitados",Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">",aAnexos,cCC,cCCO)
	endif	
	dbSelectArea("SE2")    	
	Reclock("SE2",.f.)
		SE2->E2_NUMBOR 	:= 	""
		SE2->E2_IDCNAB 	:= 	""
		SE2->E2_PORTADO	:= 	""
		SE2->E2_OCORREN	:=	cRetorno
	MsUnlock("SE2")
	if	Upper(Alltrim(SEA->EA_ORIGEM)) == "FINA241"
		if 	lPCCBaixa 
			F241CanImp(Nil,Nil,Nil,Nil,Nil,Nil,cNumBor)
		else
			F241CanImp(Nil,Nil,Nil,Nil,Nil,Nil,cNumBor)
		endif
	endif
	if 	lFA300Rej
		ExecBlock("FA300REJ",.f.,.f.,{ cRetorno })
	endif
	dbSelectArea("SEA")
	RecLock("SEA",.f.,.t.)
		SEA->(dbdelete())
	MsUnlock("SEA")
endif

RestArea(aAreaSM0)
RestArea(aArea)

cFilAnt := xFilAtu	

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINRZ003  บAutor  ณMicrosiga           บ Data ณ  12/27/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fRetCab()

Local cHtml	:= 	""

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
cHtml	+=	'<title>.:: Totvs Protheus 12 - Tํtulos Rejeitados ::.</title>'		 																			+ CRLF
cHtml	+=	'</head>' 																																		+ CRLF
cHtml	+=	'<body>' 																																		+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<div style="padding: 50px;">' 																													+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<table border="0" cellpadding="0" cellspacing="0" height="58" width="100%">'				 													+ CRLF
cHtml	+=	'  <tr>' 																																		+ CRLF
cHtml	+=	'    <td height="72" width="100%">' 																											+ CRLF
cHtml	+=	'      <p align="center"><font face="Tahoma" size="5">Tํtulos Rejeitados</font>'	 															+ CRLF
cHtml	+=	'    </td>' 																																	+ CRLF
cHtml	+=	'  </tr>' 																																		+ CRLF
cHtml	+=	'  <tr>' 																																		+ CRLF
cHtml	+=	'    <td height="1" class="TarjaTopoCor" colspan="3" width="100%">' 																			+ CRLF
cHtml	+=	'  </tr>' 																																		+ CRLF
cHtml	+=	'</table>' 																																		+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<br>' 																																			+ CRLF
cHtml	+=	''       																																		+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINRZ003  บAutor  ณMicrosiga           บ Data ณ  12/27/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ		
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fCabIte() 

Local cHtml		:= 	""   

cHtml	+=	'<table border="1" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" width="100%">' 													+ CRLF 
cHtml	+=	'  <tr>' 																																												+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="14%" align="center"><b><span class="style5"><span style="font-size: 8pt">Numero            </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="08%" align="center"><b><span class="style5"><span style="font-size: 8pt">Parcela           </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="08%" align="center"><b><span class="style5"><span style="font-size: 8pt">Tipo              </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="40%" align="center"><b><span class="style5"><span style="font-size: 8pt">Razใo Social      </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="08%" align="center"><b><span class="style5"><span style="font-size: 8pt">Vencimento        </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="12%" align="center"><b><span class="style5"><span style="font-size: 8pt">Valor             </span></span></b></td>' 			+ CRLF
cHtml	+=	'  </tr>' 																																												+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINRZ003  บAutor  ณMicrosiga           บ Data ณ  12/27/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fDetIte(cOcor)

Local cHtml		:= 	""
Local cValor	:=	Alltrim( Transform( SE2->E2_SALDO , PesqPict("SE2","E2_VALOR") ) )
Local cFornece	:=	Posicione("SA2",01,xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA,"A2_NOME")

cHtml	+=	'  <tbody>' 																								   												+ CRLF
cHtml	+=	'    <tr>' 																										   											+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="14%" align="center">&nbsp; ' 	+ SE2->E2_NUM    		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="08%" align="center">&nbsp; ' 	+ SE2->E2_PARCELA		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="08%" align="center">&nbsp; ' 	+ SE2->E2_TIPO    		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="40%" align="left"  >&nbsp; ' 	+ cFornece				+ '       </td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="08%" align="center">&nbsp; ' 	+ DtoC(SE2->E2_VENCREA)	+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="12%" align="right" >'			+ cValor      			+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'    </tr>' 																																				+ CRLF
cHtml	+=	'  </tbody>' 																																				+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINRZ003  บAutor  ณMicrosiga           บ Data ณ  12/27/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ		
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xCabIte() 

Local cHtml		:= 	""   

cHtml	+=	'<table border="1" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" width="100%">' 													+ CRLF 
cHtml	+=	'  <tr>' 																																												+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="14%" align="center"><b><span class="style5"><span style="font-size: 8pt">Motivo            </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="86%" align="center"><b><span class="style5"><span style="font-size: 8pt">Descri็ใo         </span></span></b></td>' 			+ CRLF
cHtml	+=	'  </tr>' 																																												+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINRZ003  บAutor  ณMicrosiga           บ Data ณ  12/27/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xDetIte(cOcor,cBco)

Local s
Local cDesc		:=	""
Local cTemp		:= 	""
Local cHtml		:= 	""

For s := 1 to Len(cOcor) Step 2

	if	Empty(Substr(cOcor,s,02))
		Loop
	elseif Substr(cOcor,s,02) $ cTemp
		Loop
	endif

	cDesc := xRetMotivo(Substr(cOcor,s,02))

	if	Empty(cDesc)
		if	SEB->(dbsetorder(1),dbseek( xFilial("SEB") + cBco + PadR( Alltrim(Substr(cOcor,s,02)) , TamSx3("EB_REFBAN")[1] ),.f.))  
			cDesc := Upper(Alltrim(SEB->EB_DESCRI))
		endif
	endif

	cHtml	+=	'  <tbody>' 																								   												+ CRLF
	cHtml	+=	'    <tr>' 																										   											+ CRLF
	cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="14%" align="center">&nbsp; ' 	+ Substr(cOcor,s,02)	+ ' &nbsp;</td>'		+ CRLF
	cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="86%" align="left"  >&nbsp; ' 	+ cDesc					+ '       </td>'		+ CRLF
	cHtml	+=	'    </tr>' 																																				+ CRLF
	cHtml	+=	'  </tbody>' 																																				+ CRLF

	cTemp	+=	Substr(cOcor,s,02)

Next s 
	
Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณFINRZ003  บAutor  ณMicrosiga           บ Data ณ  12/27/12   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fRodIte()

Local cHtml	:= 	""

cHtml	+=	'<table border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#E5E5E5" bgcolor="#F7F7F7" width="100%">' 																															+ CRLF
cHtml	+=	'  <tr>' 																																																											+ CRLF
if	lCheck
	cHtml	+=	' <td width="100%" bordercolor="#FFFFFF"><div align="right" class="texto-layer">WorkFlow @ Checkpoint     </div></td>' 																															+ CRLF
elseif	lCCL
	cHtml	+=	' <td width="100%" bordercolor="#FFFFFF"><div align="right" class="texto-layer">WorkFlow @ CCL Industries </div></td>' 																															+ CRLF
else
	cHtml	+=	' <td width="100%" bordercolor="#FFFFFF"><div align="right" class="texto-layer">WorkFlow @ Protheus       </div></td>' 																															+ CRLF
endif
cHtml	+=	'  </tr>' 																																																											+ CRLF
cHtml	+=	'</table>' 																																																											+ CRLF

cHtml	+=	''       																																	   																										+ CRLF

cHtml	+=	'</div>' 																																																											+ CRLF
cHtml	+=	'</body>' 																																																											+ CRLF
cHtml	+=	'</html>' 																																																											+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXENVBOLEMLบAutor  ณMicrosiga           บ Data ณ  04/18/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xContPD(aArray)

Local s

Local lCabec 		:=	.f.    
Local lContab 		:=	.t.

Local nTotal 		:= 	000
Local nHdlPrv 		:= 	000
Local cPadrao 		:= 	"5C2" 
Local lPadrao 		:= 	VerPadrao(cPadrao)        

Local lDigita		:=	( mv_par05 == 1 )
Local lAglut 		:=	.f.

Local aFlagCTB		:= 	{}

Private cLote		:=	Nil
Private xValPD 		:= 	Nil
Private cArquivo	:=	Nil
Private cLotefin  	:= 	GetNewLote() 

LoteCont("FIN")

SEA->(dbsetorder(1))		

For s := 1 to Len(aArray)
	if	aArray[s,Len(aArray[s])] <> 0 
		if	Substr(Alltrim(aArray[s,18]),01,02) == "PD"
			SE2->(dbgoto(aArray[s,Len(aArray[s])]))
			if	SEA->(dbseek( xFilial("SEA") + SE2->E2_NUMBOR  + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA ) )		
				if	Empty(SEA->EA_ZZCONT)
					xValPD	:=	iif( SE2->E2_SALDO > 0 , SE2->E2_SALDO , aArray[s,10] )
					Reclock("SEA",.f.)
						SEA->EA_ZZCONT	:=	"S"
					MsUnlock("SEA")
				else
					xValPD	:=	0	
				endif
			else
				xValPD	:=	0	
			endif
			if	xValPD > 0 
				if !lCabec .and. lPadrao .and. lContab
					nHdlPrv	:=	HeadProva( cLote , "FINA300" , Substr( cUsuario , 7 , 6 ) , @cArquivo )
					lCabec	:= 	.t.
				endif
				if 	lPadrao .and. lContab .and. lCabec
					nTotal 	+= 	DetProva( nHdlPrv , cPadrao , "FINA300" , cLote , Nil , Nil , Nil , Nil , Nil , Nil , Nil , @aFlagCTB )
				endif
			endif
		endif
	endif
Next s 
    	
if 	lPadrao .and. lContab .and. lCabec .and. nTotal <> 0
	RodaProva( nHdlPrv , nTotal )
	cA100Incl( cArquivo , nHdlPrv , 2 , cLote , lDigita , lAglut , , , , @aFlagCTB )
endif     

Return 
