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
                        	
Static lW40   		:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )     	 		 	
Static lCCL  		:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )
Static lCheck		:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )
Static lFadel		:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )
Static lMando		:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )
Static lMastra		:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )
Static lAlphenz		:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )

/*/{Protheus.doc} User Function xImpExtrato
	Importa as tarifas dos extratos bancarios
	@type  Function
	@author Alexandre Zapponi
	@since 24/02/20
	@history ticket 81491 - Abel Babini - 19/05/2023 - Projeto Nexxera - Importa Extrato bancแrio
	/*/
User Function xImpExtrato(xDirectory,xDirAut,xObj)  		

Local nA
Local cMoedaTx 		
Local cGetMoeda 	

Local aRet			:=	{}
Local xFilAnt		:=	cFilAnt
Local xDataBase		:=	dDataBase   
Local xFunName		:=	FunName()  

Local lCanSave		:=	.t.
Local lUserSave		:=	.t.
Local lCentered		:= 	.t.
Local aPergs		:=	{}  
Local aRetParam		:=	{}        

Local oObj			:= 	GeneralClass():New()

Local vObj			:= 	RetornaLicensa():New()
Local lCont			:=	vObj:ChecaEmpEXT()	
Local dMaxDate		:=	Max(Max(Date(),GetRmtDate()),dDataBase)    

Default xDirAut  	:=	.f.
Default xDirectory	:=	""

Private nValFin  	:=	0
Private lValFin  	:=	.f.
Private lDirAut  	:=	xDirAut
Private cDirectory	:=	xDirectory

Private aTxMoedas 	:= 	{} 	

aAdd( aTxMoedas , { "" , 01 , PesqPict("SM2","M2_MOEDA1") } )

For nA := 2 To MoedFin()
	cMoedaTx 	:= 	Str(nA,iif(nA <= 9,1,2))
	cGetMoeda 	:= 	GetMv("MV_MOEDA" + cMoedaTx)
	if !Empty(cGetMoeda)
		aAdd( aTxMoedas , { cGetMoeda , RecMoeda(dDataBase,nA) , PesqPict("SM2","M2_MOEDA" + cMoedaTx) } )
	else
		Exit
	endif
Next nA

FwMsgRun( Nil , { || xChecaVar() } , 'Processando' , "Buscando dados ..." )

oObj:ChecaPar( "ZZ_XNATTAR" , "Natureza de Tarifa                              " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_XCTDTAR" , "Conta a Debito para Tarifas                     " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_XCTCTAR" , "Conta a Credito para Tarifas                    " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_CENCUSD" , "Centro de Custo a Debito para Tarifas           " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_CENCUSC" , "Centro de Custo a Credito para Tarifas          " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_ITMCOND" , "Item Contabil a Debito para Tarifas             " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_ITMCONC" , "Item Contabil a Credito para Tarifas            " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_CLVLD"   , "Classe de Valor a Debito para Tarifas           " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_CLVLC"   , "Classe de Valor a Credito para Tarifas          " 	, "        " 			, "C" )	    

oObj:ChecaPar( "ZZ_XNATREN" , "Natureza de Rendimento                          " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_XCTDREN" , "Conta a Debito para Rendimento                  " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_XCTCREN" , "Conta a Credito para Rendimento                 " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_CCRENDD" , "Centro de Custo a Debito para Rendimento        " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_CCRENDC" , "Centro de Custo a Credito para Rendimento       " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_ITMCRDD" , "Item Contabil a Debito para Rendimento          " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_ITMCRDC" , "Item Contabil a Credito para Rendimento         " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_CLVLRDD" , "Classe de Valor a Debito para Rendimento        " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_CLVLRDC" , "Classe de Valor a Credito para Rendimento       " 	, "        " 			, "C" )	    

oObj:ChecaPar( "ZZ_XNATAPL" , "Natureza de Aplicacao Origem                    " 	, "        " 			, "C" )	 
oObj:ChecaPar( "ZZ_XNATAPD" , "Natureza de Aplicacao Destino                   " 	, GetMv("ZZ_XNATAPL")	, "C" )	 
  
oObj:ChecaPar( "ZZ_XNATRES" , "Natureza de Resgate Origem                      " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_XNATRED" , "Natureza de Resgate Destino                     " 	, GetMv("ZZ_XNATRES")	, "C" )	    

oObj:ChecaPar( "MV_FOOLASS" , "                                                " 	, "S       " 			, "C" )	    

oObj:ChecaPar( "ZZ_PROCAPL" , "Processa movimento de aplicacao                 " 	, "S       " 			, "C" )	    
oObj:ChecaPar( "ZZ_PROCRES" , "Processa movimento de resgate                   " 	, "S       " 			, "C" )	    
oObj:ChecaPar( "ZZ_PROCREN" , "Processa movimento de rendimento                " 	, "S       " 			, "C" )	    
oObj:ChecaPar( "ZZ_PROCTAR" , "Processa movimento de tarifas                   " 	, "S       " 			, "C" )	    
oObj:ChecaPar( "ZZ_PROCCPO" , "Campo de atualizacao do saldo bancario          " 	, "        " 			, "C" )	    
oObj:ChecaPar( "ZZ_PROCSAL" , "Campo de atualizacao da tabela do saldo bancario" 	, "        " 			, "C" )	    

if	lFadel	
	lCont			:=	vObj:ChecaEmpEXT()			
endif		

if !lCont
	if	dMaxDate >= StoD("20230701")      	
		Alert("Perํodo de avalia็ใo encerrado") 
		Return
	endif
endif

if	lFadel	
	if	"TV5GFE_PRD_COMP" $ Upper(Alltrim(GetEnvServer()))
		Alert("Versใo Atual")
	endif
endif

SetFunName("FINA100")

aAdd( aPergs , { 06 , "Diret๓rio de Leitura" , "" , "" , "" , "" , 110 , .t. , "" , , GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY } )
    	
if !Empty(xDirectory)
	mv_par01 	:= 	Alltrim(xDirectory)
	mv_par01 	:= 	iif( Substr(mv_par01,Len(mv_par01),01) == "\" , Substr(mv_par01,01,Len(mv_par01) - 1) , mv_par01 )
	cDirectory	:=	mv_par01 
	if	fGera(@aRet)  
		fProc(@aRet,@xObj)
	endif
elseif 	ParamBox( aPergs , "Diretorio de Leitura" , @aRetParam , { || .t. } , , lCentered , 0 , 0 , , 'LERARQEXT' , lCanSave , lUserSave )
	mv_par01 	:= 	Alltrim(aRetParam[01])
	mv_par01 	:= 	iif( Substr(mv_par01,Len(mv_par01),01) == "\" , Substr(mv_par01,01,Len(mv_par01) - 1) , mv_par01 )
	cDirectory	:=	mv_par01 
	if	fGera(@aRet)  
		fProc(@aRet,@xObj)
	endif
endif

SetFunName(xFunName)

cFilAnt		:=	xFilAnt
dDataBase 	:= 	xDataBase

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fGera(aRet)

Local t
Local oDlg
Local oRep
Local oButAll
Local oButDes
Local oButInv
Local oButPrc
Local oButCan
 //ticket 81491 - Abel Babini - 19/05/2023 - Projeto Nexxera - Importa Extrato bancแrio
Local aArq			:= 	Directory( Alltrim(mv_par01) + '\*.RET' , "" )                                        			

Local lOk       	:= 	.f.
Local oNo       	:= 	LoadBitmap( GetResources(), "LBNO" )
Local oOk       	:= 	LoadBitmap( GetResources(), "LBOK" )   

For t := 1 to Len(aArq)
	aAdd( aRet , { .t. , Alltrim(aArq[t,01]) , Alltrim(mv_par01) + '\' + Alltrim(aArq[t,01]) } )
Next t 

if	lDirAut
	lOk := Len(aRet) <> 0
else
	Define MsDialog oDlg Title "Arquivos" From 000,000 To 450,550 Pixel
	
	oDlg:cTitle   	:= 	"Selecione o(s) Arquivo(s) a Importar"
	
	oRep := TcBrowse():New(010,010,258,195,,,,oDlg,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)
	
	oRep:AddColumn( TcColumn():New( "  "    	   	,{ || iif(aRet[oRep:nAt,01],oOk,oNo) 	}	, "@!"  		,,,"CENTER"	,020,.t.,.f.,,,,.f.,) )
	oRep:AddColumn( TcColumn():New( "Arquivo"		,{ || aRet[oRep:nAt,02]  				}	, "@!"			,,,"CENTER"	,060,.f.,.f.,,,,.f.,) )     					
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
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fProc(aRet,xObj)

Local t      
Local s    
Local lPrc
Local cTip                     
Local cIde
Local dIni    
Local nIni
Local cBco
Local cAge
Local cDAg
Local cCon         
Local dArq
Local nVal          
Local xSeg
Local aArq		:=	{}
Local aMov		:=	{}
Local lArq		:=	.f.
Local lCon		:=	.f.
Local oObj		:= 	GeneralClass():New()

Local lApl 		:=	Upper(Alltrim(GetMv("ZZ_PROCAPL"))) == "S" 
Local lRes		:=	Upper(Alltrim(GetMv("ZZ_PROCRES"))) == "S"
Local lRen		:=	Upper(Alltrim(GetMv("ZZ_PROCREN"))) == "S"
Local lTar		:=	Upper(Alltrim(GetMv("ZZ_PROCTAR"))) == "S"

For t := 1 to Len(aRet)
	aArq 	:= 	{}  
	aMov 	:= 	{}  
	cBco 	:= 	""
	cAge 	:= 	""
	cDAg 	:= 	""
	cCon 	:= 	""
	lArq 	:= 	.f.
	lCon 	:= 	.f. 
	xSeg 	:= 	.f. 
	nIni 	:= 	000
	nValFin	:=	000
	if	aRet[t,01]
		FwMsgRun( Nil , { || aArq := oObj:ReadArq(aRet[t,03],@lArq) } , "Leitura de Arquivo" , "Lendo o arquivo " + Alltrim(aRet[t,02]) )
		if	lArq
			if	Len(aArq) <> 0 
				For s := 1 to Len(aArq) 
					if	s == 1 
						if	Len(aArq[s]) == 200 .or. Len(aArq[s]) == 202      
							if	Substr(aArq[s],1,1) == "0"
		     					cBco := Substr(aArq[s],077,003)
								dArq :=	Substr(aArq[s],165,008)
								dArq := DataValida( StoD(Substr(dArq,5,4) + Substr(dArq,3,2) + Substr(dArq,1,2)) - 1 , .f. )
							else
								Alert("O conte๚do do arquivo estแ incorreto - Arquivo " + Alltrim(aRet[t,02])) 			
								Exit
							endif	   
						elseif	Len(aArq[s]) == 240 .or. Len(aArq[s]) == 242      
							if	Substr(aArq[s],8,1) == "0"
								//ticket 81491 - Abel Babini - 19/05/2023 - Projeto Nexxera - Importa Extrato bancแrio
		     					cBco := Substr(aArq[s],001,003)
		     					cAge := iif( cBco == "341" , Substr(aArq[s],054,004) , Substr(aArq[s],053,005) )
									cDAg := iif( cBco == "341" ,Substr(aArq[s],058,001) , iif( cBco == "237" ,Substr(aArq[s],071,001) , Substr(aArq[s],059,012) )  )
		     					cCon := iif( cBco == "341" , Substr(aArq[s],066,007) , Substr(aArq[s],059,012) )  
								if	cBco $ "001"
									dArq :=	Substr(aArq[s],144,008)
									dArq :=	StoD(Substr(dArq,5,4) + Substr(dArq,3,2) + Substr(dArq,1,2))
								elseif	cBco $ "033/104/237/341/399"
									dArq :=	Substr(aArq[s],144,008)
									dArq := DataValida( StoD(Substr(dArq,5,4) + Substr(dArq,3,2) + Substr(dArq,1,2)) - 1 , .f. )
								endif
								FwMsgRun( Nil , { || lCon := xFindAcc(@cBco,@cAge,@cCon,cDAg) } , "Leitura de Tabela" , "Buscando o Banco" )
								if	lCon
									if	SA6->(FieldPos("A6_X_FILIA")) <> 0 
										if	Empty(SA6->A6_X_FILIA)
											Alert("Filial do banco nใo informada - Arquivo " + Alltrim(aRet[t,02])) 			
											Exit
										else
											cFilAnt := SA6->A6_X_FILIA
										endif
									elseif	SA6->(FieldPos("A6_ZZFLPR")) <> 0 
										if	Empty(SA6->A6_ZZFLPR)
											Alert("Filial do banco nใo informada - Arquivo " + Alltrim(aRet[t,02])) 			
											Exit
										else
											cFilAnt := SA6->A6_ZZFLPR
										endif
									endif                 
								else
									Alert("Banco nใo encontrado - Arquivo " + Alltrim(aRet[t,02])) 			
									Exit
								endif	   
							else
								Alert("O conte๚do do arquivo estแ incorreto - Arquivo " + Alltrim(aRet[t,02])) 			
								Exit
							endif	   
						else
							Alert("A estrutura do arquivo estแ incorreta - Arquivo " + Alltrim(aRet[t,02])) 			
							Exit
						endif
					elseif	s == 2 
						if	Len(aArq[s]) == 200 .or. Len(aArq[s]) == 202      
							if	Substr(aArq[s],01,01) == "1" .and. Substr(aArq[s],42,01) == "0" 
		     					cAge := Substr(aArq[s],018,004) 
								cDAg := "" 
		     					cCon := Substr(aArq[s],031,011)  
		     					cIde := Substr(aArq[s],105,001)  
		     					nIni := Val(Substr(aArq[s],087,018)) / 100
		     					dIni := CtoD(Substr(aArq[s],081,002) + "/" + Substr(aArq[s],083,002) + "/" + Substr(aArq[s],085,002))
								FwMsgRun( Nil , { || lCon := xFindAcc(@cBco,@cAge,@cCon,cDAg) } , "Leitura de Tabela" , "Buscando o Banco" )
								if	lCon
									if	SA6->(FieldPos("A6_X_FILIA")) <> 0 
										if	Empty(SA6->A6_X_FILIA)
											Alert("Filial do banco nใo informada - Arquivo " + Alltrim(aRet[t,02])) 			
											Exit
										else
											cFilAnt := SA6->A6_X_FILIA										
										endif
									elseif	SA6->(FieldPos("A6_ZZFLPR")) <> 0 
										if	Empty(SA6->A6_ZZFLPR)
											Alert("Filial do banco nใo informada - Arquivo " + Alltrim(aRet[t,02])) 			
											Exit
										else
											cFilAnt := SA6->A6_ZZFLPR										
										endif
									endif                 
								else
									Alert("Banco nใo encontrado - Arquivo " + Alltrim(aRet[t,02])) 			
									Exit
								endif	   
							else
								Alert("O conte๚do do arquivo estแ incorreto - Arquivo " + Alltrim(aRet[t,02])) 			
								Exit
							endif	   
						elseif	Len(aArq[s]) == 240 .or. Len(aArq[s]) == 242      
							if	Substr(aArq[s],8,1) == "1"
		     					nIni := Val(Substr(aArq[s],151,018)) / 100
		     					dIni := CtoD(Substr(aArq[s],143,002) + "/" + Substr(aArq[s],145,002) + "/" + Substr(aArq[s],149,002))
								cIde := Substr(aArq[s],169,001)  
							else
								Alert("O conte๚do do arquivo estแ incorreto - Arquivo " + Alltrim(aRet[t,02])) 			
								Exit
							endif	   
						else
							Alert("A estrutura do arquivo estแ incorreta - Arquivo " + Alltrim(aRet[t,02])) 			
							Exit
						endif
					else
						if	Len(aArq[s]) == 200 .or. Len(aArq[s]) == 202      
	                    	if	Substr(aArq[s],01,01) == "1" .and. Substr(aArq[s],42,01) == "1" 
								xSeg := .t.
								if	cBco $ "001/237"  
									if	Len(aMov) == 0
										aAdd( aMov	,	{	.f.                                 													,;	// 01
															DataValida( dIni - 1 , .f. ) 															,;	// 02
															"Saldo anterior"       																	,;	// 03
															cIde																					,;	// 04
															iif( cIde == "C" , Transform( nIni , "@e 999,999,999.99" ) , "" )  						,;	// 05
															iif( cIde == "D" , Transform( nIni , "@e 999,999,999.99" ) , "" )  						,;	// 06
															iif( cIde == "C" , nIni , nIni * -1 )                     								,;	// 07 
															nIni																					,;	// 08
															.f.																						,;	// 09
															""																				   		,;	// 10
															cBco																					,;	// 11
															cAge																					,;	// 12
															cCon																					,;	// 13
															iif( SA6->(FieldPos("A6_ZZCC")) <> 0 , SA6->A6_ZZCC , "" )								,;	// 14
															""                                                        								,;	// 15
															""                                                        								,;	// 16
															""                                                        								,;	// 17
															""                                                        								,;	// 18
															""                                                        								,;	// 19
															""                                                        								,;	// 20
															""                                                        								,;	// 21
															""                                                        								,;	// 22
															""                                                        								,;	// 23
															""                                                        								,;	// 24
															""                                                        								,;	// 25
															""                                                        								,;	// 26
															.f.                                                       								,;	// 27
															.f.                                                       								,; 	// 28
															""                                                        								}) 	// 29
									endif
									nVal := Val(Substr(aArq[s],087,018)) / 100 
									cTip := iif( cBco == "237" , Substr(aArq[s],105,001) , Substr(aArq[s],043,001) )
									if	cBco == "001"
										cTip := iif( cTip == "1" , "D" , "C" )
									endif									
									aAdd( aMov	,	{	Substr(aArq[s],043,003) $ '102/105/106/206'													,;	// 01
														CtoD( Substr(aArq[s],81,02) + "/" + Substr(aArq[s],83,002) + "/" + Substr(aArq[s],85,02) )	,;	// 02
														Substr(aArq[s],050,025)																		,;	// 03
														cTip																						,;	// 04
														iif( cTip == "C" , Transform( nVal , "@e 999,999,999.99" ) , "" )  							,;	// 05
														iif( cTip == "D" , Transform( nVal , "@e 999,999,999.99" ) , "" )  							,;	// 06
														iif( cTip == "C" , nVal , nVal * -1 ) + aMov[Len(aMov),07]									,;	// 07
														nVal																						,;	// 08
														.t.																							,;	// 09
														Substr(aArq[s],043,003)																		,;	// 10
														cBco																						,;	// 11
														cAge																						,;	// 12
														cCon																						,;	// 13
														iif( SA6->(FieldPos("A6_ZZCC")) <> 0 , SA6->A6_ZZCC , "" )									,;	// 14
														""                                                        									,;	// 15
														""                                                        									,;	// 16
														""                                                        									,;	// 17
														""                                                        									,;	// 18
														""                                                        									,;	// 19
														""                                                        									,;	// 20
														""                                                        									,;	// 21
														""                                                        									,;	// 22
														""                                                        									,;	// 23
														""                                                        									,;	// 24
														""                                                        									,;	// 25
														""                                                        									,;	// 26
														.f.                                                       									,;	// 27
														.f.                                                       									,; 	// 28
														""                                                        									}) 	// 29
                                    xRetEntidades(@aMov,Len(aMov),cBco,cAge,cCon)
								endif	
							endif  
						elseif	Len(aArq[s]) == 240 .or. Len(aArq[s]) == 242      
	                    	if	Substr(aArq[s],8,1) == "3"
								xSeg := .t.
								if	cBco $ "001/237/341"  	
									if	Len(aMov) == 0
										aAdd( aMov	,	{	.f.                                 													,;	// 01
															DataValida( dIni , .f. ) 																,;	// 02
															"Saldo anterior"       																	,;	// 03
															cIde																					,;	// 04
															iif( cIde == "C" , Transform( nIni , "@e 999,999,999.99" ) , "" )  						,;	// 05
															iif( cIde == "D" , Transform( nIni , "@e 999,999,999.99" ) , "" )  						,;	// 06
															iif( cIde == "C" , nIni , nIni * -1 )                     								,;	// 07
															nIni																					,;	// 08
															.f.																						,;	// 09
															""  																					,;	// 10
															cBco  																					,;	// 11
															cAge  																					,;	// 12
															cCon																					,;	// 13
															iif( SA6->(FieldPos("A6_ZZCC")) <> 0 , SA6->A6_ZZCC , "" )								,;	// 14
															""                                                        								,;	// 15
															""                                                        								,;	// 16
															""                                                        								,;	// 17
															""                                                        								,;	// 18
															""                                                        								,;	// 19
															""                                                        								,;	// 20
															""                                                        								,;	// 21
															""                                                        								,;	// 22
															""                                                        								,;	// 23
															""                                                        								,;	// 24
															""                                                        								,;	// 25
															""                                                        								,;	// 26
															.f.                                                       								,;	// 27
															.f.                                                       								,; 	// 28
															""                                                        								}) 	// 29
									endif
									nVal := Val(Substr(aArq[s],151,018)) / 100 
									lPrc := Substr(aArq[s],170,003) $ '102/105/106/206'
									lPrc := iif( Substr(aArq[s],170,003) == '102' .and. !lTar , .f. , lPrc )
									lPrc := iif( Substr(aArq[s],170,003) == '105' .and. !lTar , .f. , lPrc )
									lPrc := iif( Substr(aArq[s],170,003) == '106' .and. !lApl , .f. , lPrc )
									lPrc := iif( Substr(aArq[s],170,003) == '206' .and. !lRes , .f. , lPrc )
									lPrc := iif( Substr(aArq[s],170,003) == '206' .and. !lRen , .f. , lPrc )
									aAdd( aMov	,	{	lPrc																						,;	// 01
														StoD( Substr(aArq[s],147,004) + Substr(aArq[s],145,002) + Substr(aArq[s],143,002) )			,;	// 02
														Upper(Substr(aArq[s],177,025))																,;	// 03
														Substr(aArq[s],169,001)																		,;	// 04
														iif( Substr(aArq[s],169,001) == "C" , Transform( nVal , "@e 999,999,999.99" ) , "" )  		,;	// 05
														iif( Substr(aArq[s],169,001) == "D" , Transform( nVal , "@e 999,999,999.99" ) , "" )  		,;	// 06
														iif( Substr(aArq[s],169,001) == "C" , nVal , nVal * -1 ) + aMov[Len(aMov),07]				,;	// 07
														nVal																						,;	// 08
														.t.																							,;	// 09
														Substr(aArq[s],170,003)																		,;	// 10
														cBco																						,;	// 11
														cAge																						,;	// 12
														cCon																						,;	// 13
														iif( SA6->(FieldPos("A6_ZZCC")) <> 0 , SA6->A6_ZZCC , "" )									,;	// 14
														""                                                        									,;	// 15
														""                                                        									,;	// 16
														""                                                        									,;	// 17
														""                                                        									,;	// 18
														""                                                        									,;	// 19
														""                                                        									,;	// 20
														""                                                        									,;	// 21
														""                                                        									,;	// 22
														""                                                        									,;	// 23
														""                                                        									,;	// 24
														""                                                        									,;	// 25
														""                                                        									,;	// 26
														.f.                                                       									,;	// 27
														.f.                                                       									,; 	// 28
														""                                                        									}) 	// 29
                            		if	"DEB" $ aMov[Len(aMov),03] .and. "AUT" $ aMov[Len(aMov),03] 		
										aMov[Len(aMov),01] := .f.    						
										aMov[Len(aMov),10] := "000"  						
									endif	
                                    xRetEntidades(@aMov,Len(aMov),cBco,cAge,cCon)
								endif	
							elseif	Substr(aArq[s],8,1) == "5"
								if	cBco $ "001/237/341"  	
									lValFin	:=	Substr(aArq[s],169,001) == "C"
									nValFin	:=	Val(Substr(aArq[s],151,018)) / 100
									nValFin	:=	nValFin * iif( lValFin , 1 , -1 )
								endif  
							endif  
						endif  
					endif  
				Next s 
			else
				Alert("Erro na leitura do conte๚do - Arquivo " + Alltrim(aRet[t,02])) 			
			endif
		else
			Alert("Nใo foi possํvel a leitura - Arquivo " + Alltrim(aRet[t,02]))
		endif
		if	Len(aMov) <> 0
			fQuadro( @aMov , Alltrim(aRet[t,02]) , "Banco : " + Alltrim(cBco) + "/" + Alltrim(cAge) + "/" + Alltrim(cCon) )		
		else
			if !ExistDir(Alltrim(cDirectory) + "\Vazios")			
				MakeDir(Alltrim(cDirectory) + "\Vazios")			
			endif				
		    if	__CopyFile( Alltrim(cDirectory) + "\" + Alltrim(aRet[t,02]) , Alltrim(cDirectory) + "\Vazios\" + Alltrim(aRet[t,02]) )   
				fErase(Alltrim(cDirectory) + "\" + Alltrim(aRet[t,02]))
			endif
		endif
	endif
Next t 

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xFindAcc(cBco,cAge,cCon,cDAg)

Local lFind		:=	.f.      

SA6->(dbsetorder(1))
SA6->(dbgotop())

do while SA6->(!Eof())   
	if	Val(cBco) == Val(SA6->A6_COD)
		if	Val(cAge) 							== 	Val(StrTran(SA6->A6_AGENCIA,"-","")) 									.or. ;
			Val(cAge) 							== 	Val(StrTran(StrTran(SA6->A6_AGENCIA + SA6->A6_DVAGE," ",""),"-",""))	.or. ;
			Val(StrTran(cAge + cDAg," ",""))	==	Val(StrTran(StrTran(SA6->A6_AGENCIA + SA6->A6_DVAGE," ",""),"-","")) 
			if	Val(StrTran(cCon," ","")) 		== 	Val(StrTran(SA6->A6_NUMCON,"-","")) 									.or. ;
				Val(StrTran(cCon," ","")) 		== 	Val(Substr(StrTran(SA6->A6_NUMCON,"-",""),1,Len(Alltrim(StrTran(SA6->A6_NUMCON,"-","")))-1)) 									.or. ;
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
					lFind	:= 	.t.      
					Exit
				endif
			endif
		endif
	endif
	SA6->(dbskip())
enddo 

Return ( lFind )       

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetCores(aCTF,oCTF,oAzul,oVerd,oVerm)

if	!aCTF[oCTF:nAt,09]
	Return ( oAzul )  	
elseif	aCTF[oCTF:nAt,01]
	Return ( oVerd )  	
else
	Return ( oVerm )  	
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fQuadro( aCTF , cArq , xTxtBco ) 

Local oDlg
Local oCTF
Local oFont
Local xLabel
Local oLabel
Local oTotal
Local oTotExt
Local oLabExt

Local nTotal		:= 	aCTF[Len(aCTF),07]  
Local cCpSaldo		:=	GetMv("ZZ_PROCCPO")
Local xCpSaldo		:=	GetMv("ZZ_PROCSAL")

Local aSize   		:= 	MsAdvSize(Nil,.f.,430)
Local aInfo   		:= 	{ aSize[1] , aSize[2] , aSize[3] , aSize[4] , 0 , 0 }
Local aObjects		:= 	{{040,040,.t.,.t.},{100,100,.t.,.t.},{020,020,.t.,.t.}}
Local aPosObj 		:= 	MsObjSize(aInfo,aObjects,.f.)
Local nAltu			:=	aPosObj[3,3] - 13 
Local nLarg			:=	aPosObj[3,4]

Local lOk			:=	.f.
Local bOk			:=	{ || lOk := .t. , iif( MsgYesNo("Confirma lan็amentos ?") , oDlg:End() , lOk := .f. ) }
Local bNo			:=	{ || lOk := .f. , oDlg:End() }      
Local oVerd    		:=	LoadBitmap( GetResources() , "ENABLE"	)
Local oVerm    		:=	LoadBitmap( GetResources() , "DISABLE"	)
Local oAzul    		:=	LoadBitmap( GetResources() , "BR_AZUL"	)

if	lFadel	
	if	"TV5GFE_PRD_COMP" $ Upper(Alltrim(GetEnvServer()))
		Alert( cCpSaldo ) 
		Alert( SA6->(FieldPos(Upper(Alltrim(cCpSaldo)))) ) 
		Alert( xCpSaldo ) 
		Alert( SE8->(FieldPos(Upper(Alltrim(xCpSaldo)))) ) 
	endif
endif

Setapilha()
Define Font oFont Name "Tahoma" Size 0,-11 Bold
Define MsDialog oDlg Title ( "Extrato " + cArq ) From aSize[7],0 To aSize[6],aSize[5] Of oMainWnd Pixel

oDlg:lEscClose 	:= 	.t.                   
oDlg:lMaximized := 	.t.   

oCTF := TcBrowse():New(035,003,nLarg - 005,nAltu - 042,,,,oDlg,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)

oCTF:AddColumn( TcColumn():New( ""     			,{ || xRetCores(aCTF,oCTF,oAzul,oVerd,oVerm)	}	, "@!"          			,,,"CENTER" ,020,.t.,.f.,,,,.f.,) )     						
oCTF:AddColumn( TcColumn():New( "Data"			,{ || aCTF[oCTF:nAt,02] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Hist๓rico"		,{ || aCTF[oCTF:nAt,03] 						}	, "@!"                     	,,,"LEFT"	,125,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Tipo"    		,{ || aCTF[oCTF:nAt,04] 						}	, "@!"                     	,,,"CENTER"	,025,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Vlr Crd"		,{ || aCTF[oCTF:nAt,05] 						}	, "@!"                     	,,,"RIGHT"	,045,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Vlr Deb"		,{ || aCTF[oCTF:nAt,06] 						}	, "@!"                     	,,,"RIGHT"	,045,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Saldo"			,{ || aCTF[oCTF:nAt,07] 						}	, "@e 999,999,999.99"		,,,"RIGHT"	,050,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Natureza"		,{ || aCTF[oCTF:nAt,15] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Cta Deb"		,{ || aCTF[oCTF:nAt,16] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Cta Crd"		,{ || aCTF[oCTF:nAt,17] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "CC Deb"		,{ || aCTF[oCTF:nAt,18] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "CC Crd"		,{ || aCTF[oCTF:nAt,19] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Item Deb"		,{ || aCTF[oCTF:nAt,20] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Item Crd"		,{ || aCTF[oCTF:nAt,21] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "CLVL Deb"		,{ || aCTF[oCTF:nAt,22] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "CLVL Crd"		,{ || aCTF[oCTF:nAt,23] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Bco Aplc"		,{ || aCTF[oCTF:nAt,24] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Age Aplc"		,{ || aCTF[oCTF:nAt,25] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Cta Aplc"		,{ || aCTF[oCTF:nAt,26] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Nat. Destino"	,{ || aCTF[oCTF:nAt,29] 						}	, "@!"                     	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )

oCTF:bLDblClick	:=	{ || fSelect(@oDlg,@oCTF,@aCTF) , oCTF:SetArray(aCTF) , oCTF:Refresh() , oDlg:Refresh() }      

oCTF:SetArray(aCTF)      

@ nAltu      	, 003				Say xLabel 			Prompt xTxtBco 											Size 150,008 Of oDlg Colors CLR_BLUE	Pixel
@ nAltu      	, nLarg - 115		Say oLabel 			Prompt "Total" 											Size 060,008 Of oDlg Colors CLR_BLUE	Pixel
@ nAltu - 003	, nLarg - 080		MsGet oTotal 		Var nTotal 				Picture "@e 999,999,999.99"		Size 080,008 Of oDlg Colors CLR_BLUE 	Pixel 	ReadOnly	Font oFont

if  ( !Empty(cCpSaldo) .and. SA6->(FieldPos(Upper(Alltrim(cCpSaldo)))) <> 0 ) .or. ( !Empty(xCpSaldo) .and. SE8->(FieldPos(Upper(Alltrim(xCpSaldo)))) <> 0 ) 
	@ nAltu - 003	, nLarg - 215	MsGet oTotExt 		Var nValFin				Picture "@e 999,999,999.99"		Size 080,008 Of oDlg Colors CLR_BLUE 	Pixel 	ReadOnly	Font oFont
	@ nAltu      	, nLarg - 260	Say oLabExt			Prompt "Saldo Extrato" 									Size 060,008 Of oDlg Colors CLR_BLUE	Pixel
endif

Activate MsDialog oDlg On Init EnchoiceBar(oDlg,bOk,bNo) Centered
Setapilha()

if	lOk    
	xCriaMov( aCTF , cArq )
endif
                   
Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetEntidades( aCTF , nLin , cBco , cAge , cCon )

Local cBcoD		:=	""
Local cAgeD		:=	""
Local cConD 	:=	""
Local lResg		:=	.f.
Local lRend		:=	.f.

if	aCTF[nLin,10] $ "206"         		

	// Resgate		

	if	cBco == "001" .and. Substr(Upper(Alltrim(aCTF[nLin,03])),01,05) == "RF CP"
		lResg	:=	.t.
	elseif	cBco == "001" .and. Substr(Upper(Alltrim(aCTF[nLin,03])),01,06) == "BB AUT"
		lResg	:=	.t.
	elseif	cBco == "237" .and. Substr(Upper(Alltrim(aCTF[nLin,03])),01,03) == "BX "
		lResg	:=	.t.
	elseif	cBco == "237" .and. Substr(Upper(Alltrim(aCTF[nLin,03])),01,07) == "RESGATE"
		lResg	:=	.t.
	elseif	cBco == "341" .and. Substr(Upper(Alltrim(aCTF[nLin,03])),01,03) == "RES"
		lResg	:=	.t.
	endif
		
	// Rendimento

	if	cBco == "341" .and. Substr(Upper(Alltrim(aCTF[nLin,03])),01,03) == "REN"    
		lRend	:=	.t.
	endif

endif			    

SA6->(dbsetorder(1))
SA6->(dbgotop())     
SA6->(MsSeek( xFilial("SA6") + cBco + cAge + cCon , .f. ))    		

// Tarifa

if	aCTF[nLin,10] $ "102/105" 

	aCTF[nLin,15] 	:=	GetMv("ZZ_XNATTAR")   
	aCTF[nLin,16] 	:= 	GetMv("ZZ_XCTDTAR")   
	aCTF[nLin,17] 	:= 	GetMv("ZZ_XCTCTAR")
	aCTF[nLin,18] 	:= 	GetMv("ZZ_CENCUSD") 
	aCTF[nLin,19] 	:= 	GetMv("ZZ_CENCUSC") 
	aCTF[nLin,20] 	:= 	GetMv("ZZ_ITMCOND") 
	aCTF[nLin,21] 	:= 	GetMv("ZZ_ITMCONC") 
	aCTF[nLin,22] 	:= 	GetMv("ZZ_CLVLD") 
	aCTF[nLin,23] 	:= 	GetMv("ZZ_CLVLC") 

	if	ExistBlock("XRETENTCON")
		xRet := ExecBlock("XRETENTCON",.f.,.f.,{cBco,cAge,cCon,aCTF[nLin,03]})
		if	ValType(xRet) == "A" .and. Len(xRet) <> 0 
			aCTF[nLin,15] 	:=	xRet[01]		// Natureza
			aCTF[nLin,16] 	:=	xRet[02]   		// D้bito
			aCTF[nLin,17] 	:=	xRet[03]  		// Cr้dito
			aCTF[nLin,18] 	:=	xRet[04] 		// CC Deb
			aCTF[nLin,19] 	:=	xRet[05]  		// CC Crd
			aCTF[nLin,20] 	:=	xRet[06]  		// Item Deb
			aCTF[nLin,21] 	:=	xRet[07]   		// Item Crd 	
			aCTF[nLin,22] 	:=	xRet[08]  		// CLVL Deb
			aCTF[nLin,23] 	:=	xRet[09] 		// CLVL Crd
		endif
	endif

// Aplica็ใo

elseif	aCTF[nLin,10] $ "106"   

	cBcoD := Nil
	cAgeD := Nil
	cConD := Nil

	xAccTrf(cBco,cAge,cCon,@cBcoD,@cAgeD,@cConD)

	aCTF[nLin,15]	:=	GetMv("ZZ_XNATAPL")
	aCTF[nLin,24]	:=	cBcoD
	aCTF[nLin,25]	:=	cAgeD
	aCTF[nLin,26]	:=	cConD
	aCTF[nLin,29]	:=	GetMv("ZZ_XNATAPD")

	if	ExistBlock("XRETNATAPL")
		xRet := ExecBlock("XRETNATAPL",.f.,.f.,{cBco,cAge,cCon,GetMv("ZZ_XNATAPL"),cBcoD,cAgeD,cConD,GetMv("ZZ_XNATAPD")})
		if	ValType(xRet) == "A" .and. Len(xRet) <> 0 
		 	aCTF[nLin,15]	:=	xRet[01]		// Natureza de Origem
		 	aCTF[nLin,24]	:=	xRet[02]  		// Banco Aplica็ใo
		 	aCTF[nLin,25]	:=	xRet[03]		// Agencia Aplica็ใo
		 	aCTF[nLin,26]	:=	xRet[04]		// Conta Aplica็ใo
		 	aCTF[nLin,29]	:=	xRet[05]		// Natureza de Destino
		endif
	endif

// Resgate

elseif	aCTF[nLin,10] $ "206" .and. lResg

	cBcoD := Nil
	cAgeD := Nil
	cConD := Nil

	xAccTrf(cBco,cAge,cCon,@cBcoD,@cAgeD,@cConD)

	aCTF[nLin,15]	:=	GetMv("ZZ_XNATRES")
	aCTF[nLin,24]	:=	cBcoD
	aCTF[nLin,25]	:=	cAgeD
	aCTF[nLin,26]	:=	cConD
	aCTF[nLin,27] 	:= 	lResg
	aCTF[nLin,29]	:=	GetMv("ZZ_XNATRED")

	if	ExistBlock("XRETNATRES")
		xRet := ExecBlock("XRETNATRES",.f.,.f.,{cBco,cAge,cCon,GetMv("ZZ_XNATRES"),cBcoD,cAgeD,cConD,GetMv("ZZ_XNATRED")})
		if	ValType(xRet) == "A" .and. Len(xRet) <> 0 
		 	aCTF[nLin,15]	:=	xRet[01]		// Natureza
		 	aCTF[nLin,24]	:=	xRet[02]  		// Banco Aplica็ใo
		 	aCTF[nLin,25]	:=	xRet[03]		// Agencia Aplica็ใo
		 	aCTF[nLin,26]	:=	xRet[04]		// Conta Aplica็ใo
		 	aCTF[nLin,29]	:=	xRet[05]		// Natureza de Destino
		endif
	endif

// Rendimento

elseif	aCTF[nLin,10] $ "206" .and. lRend    

	aCTF[nLin,15] 	:=	GetMv("ZZ_XNATREN")		// Natureza
	aCTF[nLin,16] 	:=	GetMv("ZZ_XCTDREN")		// D้bito
	aCTF[nLin,17] 	:=	GetMv("ZZ_XCTCREN")  	// Cr้dito
	aCTF[nLin,18] 	:=	GetMv("ZZ_CCRENDD") 	// CC Deb
	aCTF[nLin,19] 	:=	GetMv("ZZ_CCRENDC")  	// CC Crd
	aCTF[nLin,20] 	:=	GetMv("ZZ_ITMCRDD")  	// Item Deb
	aCTF[nLin,21] 	:=	GetMv("ZZ_ITMCRDC")   	// Item Crd 	
	aCTF[nLin,22] 	:=	GetMv("ZZ_CLVLRDD")  	// CLVL Deb
	aCTF[nLin,23] 	:=	GetMv("ZZ_CLVLRDC") 	// CLVL Crd
	aCTF[nLin,28] 	:= 	lRend

	if	ExistBlock("XRETRENCON")
		xRet := ExecBlock("XRETRENCON",.f.,.f.,{cBco,cAge,cCon})
		if	ValType(xRet) == "A" .and. Len(xRet) <> 0 
			aCTF[nLin,15] 	:=	xRet[01]		// Natureza
			aCTF[nLin,16] 	:=	xRet[02]   		// D้bito
			aCTF[nLin,17] 	:=	xRet[03]  		// Cr้dito
			aCTF[nLin,18] 	:=	xRet[04] 		// CC Deb
			aCTF[nLin,19] 	:=	xRet[05]  		// CC Crd
			aCTF[nLin,20] 	:=	xRet[06]  		// Item Deb
			aCTF[nLin,21] 	:=	xRet[07]   		// Item Crd 	
			aCTF[nLin,22] 	:=	xRet[08]  		// CLVL Deb
			aCTF[nLin,23] 	:=	xRet[09] 		// CLVL Crd
		endif
	endif

endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xCriaMov( aCTF , cArq ) 

Local s     
Local xCon
Local cNat           
Local cBco
Local cAge
Local cCon 
Local cTxt
Local nNum  

Local xRat
Local xNat 
Local xCre 
Local xDeb 
Local xCCD 
Local xCCC 
Local xItD 
Local xItC 
Local xClD 
Local xClC 
Local xHis
Local xMod

Local cBcoD
Local cAgeD
Local cConD 
Local cNatD 
Local lResg
Local lRend
Local aFina100
Local cCpSaldo			:=	GetMv("ZZ_PROCCPO")
Local xCpSaldo			:=	GetMv("ZZ_PROCSAL")
Local lIsBlind			:=	IsBlind() .or. Type("__LocalDriver") == "U"
Local xDataBase			:=	dDataBase     
Local lProcessado   	:=	.f.

Private lMsErroAuto		:=	.f.       

Pergunte("AFI100",.f.)

Begin Transaction 

Inclui := .f.

For s := 1 to Len(aCTF)             

	cBcoD		:= 	Nil
	cAgeD		:= 	Nil
	cConD 		:= 	Nil
	Inclui		:=	.t.

	cBco		:= 	aCTF[s,11] 	
	cAge		:= 	aCTF[s,12] 	
	cCon 		:= 	aCTF[s,13] 	
	lResg		:=	aCTF[s,27]
	lRend		:=	aCTF[s,28]
	dDataBase	:= 	aCTF[s,02] 	 
	lMsErroAuto	:= 	.f.
	
	if	s == 1
		SA6->(dbsetorder(1))
		SA6->(dbseek( xFilial("SA6") + cBco + cAge + cCon , .f. ))
		xCon	:=	SA6->A6_CONTA
		if	SA6->(!Eof()) .and. !Empty(cCpSaldo) .and. SA6->(FieldPos(Upper(Alltrim(cCpSaldo)))) <> 0
			RecLock("SA6",.f.)
				&("SA6->" + Upper(Alltrim(cCpSaldo))) := nValFin
			MsUnlock("SA6")
		endif
		if 	SA6->(!Eof()) .and. !Empty(xCpSaldo) .and. SE8->(FieldPos(Upper(Alltrim(xCpSaldo)))) <> 0
			SE8->(dbsetorder(1))
			if !SE8->(dbseek( xFilial("SE8") + SA6->A6_COD + SA6->A6_AGENCIA + SA6->A6_NUMCON + DtoS(dDataBase) , .f. ))
				RecLock("SE8",.t.)
					SE8->E8_FILIAL	:=	xFilial("SE8")	
					SE8->E8_BANCO	:=	SA6->A6_COD			
					SE8->E8_AGENCIA	:=	SA6->A6_AGENCIA	
					SE8->E8_CONTA	:=	SA6->A6_NUMCON	
					SE8->E8_DTSALAT	:=	dDataBase	
					SE8->E8_MOEDA	:=	"1"	
				MsUnlock("SE8")
			endif
			RecLock("SE8",.f.)
				&("SE8->" + Upper(Alltrim(xCpSaldo))) := nValFin
			MsUnlock("SE8")
		endif
	endif

	if	aCTF[s,11] == "001" 
		cTxt := "BANCO DO BRASIL" 
	elseif	aCTF[s,11] == "033" 
		cTxt := "BANCO SANTANDER" 
	elseif	aCTF[s,11] == "104" 
		cTxt := "CAIXA ECONOMICA FEDERAL" 
	elseif	aCTF[s,11] == "237" 
		cTxt := "BANCO BRADESCO" 
	elseif	aCTF[s,11] == "341" 
		cTxt := "BANCO ITAU" 
	elseif	aCTF[s,11] == "422" 
		cTxt := "BANCO SAFRA"
	endif				

	if	aCTF[s,01]

		// Tarifas

		if	aCTF[s,10] $ "102/105" 
		
			xRat := {}
			xMod := "M1"
			xHis := aCTF[s,03]
			xNat :=	aCTF[s,15]
			xDeb := aCTF[s,16]
			xCre := aCTF[s,17]  
			xCCD := aCTF[s,18]
			xCCC := aCTF[s,19]
			xItD := aCTF[s,20]
			xItC := aCTF[s,21]
			xClD := aCTF[s,22]
			xClC := aCTF[s,23]

			aFina100 := {	{ "E5_DATA"        	, dDataBase                    	, Nil } ,;
							{ "E5_MOEDA"        , xMod                         	, Nil } ,;
							{ "E5_VALOR"        , aCTF[s,08]                  	, Nil } ,;
							{ "E5_NATUREZ"    	, xNat				      		, Nil } ,;
							{ "E5_BANCO"        , cBco		                   	, Nil } ,;
							{ "E5_AGENCIA"    	, cAge		                  	, Nil } ,;
							{ "E5_CONTA"        , cCon		                   	, Nil } ,;
							{ "E5_BENEF"        , cTxt				    		, Nil } ,;
							{ "E5_HISTOR"    	, xHis				        	, Nil } }

			if	Empty(xNat) 
				Alert("A Natureza de Tarifas estแ em branco")
				Loop
			endif

			if	lCCL
				aAdd( aFina100 , { "E5_DEBITO" 	, xDeb	, Nil } )
			elseif	x3Obrigat(PadR("E5_DEBITO",Len(SX3->X3_CAMPO))) .and. Empty(xDeb)   
				if	lIsBlind
					ConOut("O campo da Conta Contแbil a D้bito estแ como obrigat๓rio mas o parโmetro ZZ_XCTDTAR estแ vazio. Verifique !!")
				else
					Alert("O campo da Conta Contแbil a D้bito estแ como obrigat๓rio mas o parโmetro ZZ_XCTDTAR estแ vazio. Verifique !!")
				endif
				Loop
			elseif	x3Obrigat(PadR("E5_DEBITO",Len(SX3->X3_CAMPO))) .or. !Empty(xDeb)
				aAdd( aFina100 , { "E5_DEBITO" 	, xDeb	, Nil } )
			endif			

			if	lCCL
				aAdd( aFina100 , { "E5_CREDITO"	, xCon	, Nil } )
			elseif	x3Obrigat(PadR("E5_CREDITO",Len(SX3->X3_CAMPO))) .and. Empty(xCon) .and. Empty(xCre)
				if	lIsBlind
					ConOut("O campo da Conta Contแbil a Cr้dito estแ como obrigat๓rio mas a Conta Contแbil no cadastro de bancos estแ vazia. Verifique !!")
				else
					Alert("O campo da Conta Contแbil a Cr้dito estแ como obrigat๓rio mas a Conta Contแbil no cadastro de bancos estแ vazia. Verifique !!")
				endif
				Loop
			elseif	x3Obrigat(PadR("E5_CREDITO",Len(SX3->X3_CAMPO))) .or. !Empty(xCon) .or. !Empty(xCre)
				aAdd( aFina100 , { "E5_CREDITO"	, iif( !Empty(xCon) , xCon , xCre ) , Nil } )
			endif			

			if	x3Obrigat(PadR("E5_CCD",Len(SX3->X3_CAMPO))) .and. Empty(xCCD)
        		if	lIsBlind
					ConOut("O campo do Centro de Custo a D้bito estแ como obrigat๓rio mas o parโmetro ZZ_CENCUSD estแ vazio. Verifique !!")
				else
					Alert("O campo do Centro de Custo a D้bito estแ como obrigat๓rio mas o parโmetro ZZ_CENCUSD estแ vazio. Verifique !!")
				endif
				Loop
			elseif	x3Obrigat(PadR("E5_CCD",Len(SX3->X3_CAMPO))) .or. !Empty(xCCD)
				aAdd( aFina100 , { "E5_CCD" 	, xCCD	, Nil } )
			endif			

			if	x3Obrigat(PadR("E5_CCC",Len(SX3->X3_CAMPO))) .and. Empty(xCCC)
				if	lIsBlind
					ConOut("O campo do Centro de Custo a Cr้dito estแ como obrigat๓rio mas o parโmetro ZZ_CENCUSC estแ vazio. Verifique !!")
				else
					Alert("O campo do Centro de Custo a Cr้dito estแ como obrigat๓rio mas o parโmetro ZZ_CENCUSC estแ vazio. Verifique !!")
        		endif
				Loop
			elseif	x3Obrigat(PadR("E5_CCC",Len(SX3->X3_CAMPO))) .or. !Empty(xCCC)
				aAdd( aFina100 , { "E5_CCC" 	, xCCC	, Nil } )
			endif			

			if	x3Obrigat(PadR("E5_ITEMD",Len(SX3->X3_CAMPO))) .and. Empty(xItD)
				if	lIsBlind
					ConOut("O campo do Item Contแbil a D้bito estแ como obrigat๓rio mas o parโmetro ZZ_ITMCOND estแ vazio. Verifique !!")
				else
					Alert("O campo do Item Contแbil a D้bito estแ como obrigat๓rio mas o parโmetro ZZ_ITMCOND estแ vazio. Verifique !!")
				endif
				Loop
			elseif	x3Obrigat(PadR("E5_ITEMD",Len(SX3->X3_CAMPO))) .or. !Empty(xItD)
				aAdd( aFina100 , { "E5_ITEMD" 	, xItD	, Nil } )
			endif			

			if	lAlphenz
				aAdd( aFina100 , { "E5_ITEMC"	, "999999"	, Nil } )
			elseif	x3Obrigat(PadR("E5_ITEMC",Len(SX3->X3_CAMPO))) .and. Empty(xItC)
				if	lIsBlind
					ConOut("O campo do Item Contแbil a Cr้dito estแ como obrigat๓rio mas o parโmetro ZZ_ITMCONC estแ vazio. Verifique !!")
				else
					Alert("O campo do Item Contแbil a Cr้dito estแ como obrigat๓rio mas o parโmetro ZZ_ITMCONC estแ vazio. Verifique !!")
				endif
				Loop
			elseif	x3Obrigat(PadR("E5_ITEMC",Len(SX3->X3_CAMPO))) .or. !Empty(xItC)
				aAdd( aFina100 , { "E5_ITEMC" 	, xItC	, Nil } )
			endif			

			if	x3Obrigat(PadR("E5_CLVLDB",Len(SX3->X3_CAMPO))) .and. Empty(xClD)
				if	lIsBlind
					ConOut("A Classe de Valor a D้bito estแ como obrigat๓rio mas o parโmetro ZZ_CLVLD estแ vazio. Verifique !!")
				else
					Alert("A Classe de Valor a D้bito estแ como obrigat๓rio mas o parโmetro ZZ_CLVLD estแ vazio. Verifique !!")
				endif
				Loop
			elseif	x3Obrigat(PadR("E5_CLVLDB",Len(SX3->X3_CAMPO))) .or. !Empty(xClD)
				aAdd( aFina100 , { "E5_CLVLDB" 	, xClD	, Nil } )
			endif			

			if	x3Obrigat(PadR("E5_CLVLCR",Len(SX3->X3_CAMPO))) .and. Empty(xClC)
				if	lIsBlind
					ConOut("A Classe de Valor a Cr้dito estแ como obrigat๓rio mas o parโmetro ZZ_CLVLC estแ vazio. Verifique !!")
				else
					Alert("A Classe de Valor a Cr้dito estแ como obrigat๓rio mas o parโmetro ZZ_CLVLC estแ vazio. Verifique !!")
				endif
				Loop
			elseif	x3Obrigat(PadR("E5_CLVLCR",Len(SX3->X3_CAMPO))) .or. !Empty(xClC)
				aAdd( aFina100 , { "E5_CLVLCR" 	, xClC	, Nil } )
			endif			

			FwMsgRun( Nil , { || CursorWait() , MsExecAuto( { |x,y,z| FinA100(x,y,z) } , 0 , aFina100 , 3 ) , CursorArrow() } , "TOTVS" , "Criando Tarifa ..." )

		// Aplicacao

		elseif	aCTF[s,10] $ "106"   

			cNat 	:= 	aCTF[s,15]
			cBcoD	:= 	aCTF[s,24]
			cAgeD	:= 	aCTF[s,25]
			cConD 	:= 	aCTF[s,26]
			cNatD 	:= 	iif( Empty(aCTF[s,29]) , cNat , aCTF[s,29] )
		
			if !xAccTrf(cBco,cAge,cCon,@cBcoD,@cAgeD,@cConD)
				Alert("Nใo encontrada a conta de aplica็ใo")
				Loop
			endif		

			nNum 		:= 	Randomize(00001,32766) + Randomize(00001,32766) + Randomize(00001,32766)   
            
			xBcoOrig	:=	cBco
			xAgenOrig	:=	cAge	
			xCtaOrig	:=	cCon
			xNaturOri	:=	cNat
			xBcoDest	:=	cBcoD
			xAgenDest	:=	cAgeD
			xCtaDest	:=	cConD
			xNaturDes	:=	cNatD
			xTipoTran	:=	"TB"
			xDocTran	:=	StrZero(nNum,08)
			xValorTran	:= 	aCTF[s,08]
			xHist100	:=	aCTF[s,03]
			xBenef100	:= 	SM0->M0_NOMECOM
			
			FwMsgRun( Nil , { || CursorWait() ,	lMsErroAuto := !fa100grava(	xBcoOrig	,;
																			xAgenOrig	,;
																			xCtaOrig	,;
																			xNaturOri	,;
																			xBcoDest	,;
																			xAgenDest	,;
																			xCtaDest	,;
																			xNaturDes	,;
																			xTipoTran	,;
																			xDocTran	,;
																			xValorTran	,;
																			xHist100	,;
																			xBenef100	) , CursorArrow() , InKey(02) } , "TOTVS" , "Criando Aplica็ใo ..." )
				
		// Resgate

		elseif	aCTF[s,10] $ "206" .and. lResg

			cNat 	:= 	aCTF[s,15]
			cBcoD	:= 	aCTF[s,24]
			cAgeD	:= 	aCTF[s,25]
			cConD 	:= 	aCTF[s,26]
			cNatD 	:= 	iif( Empty(aCTF[s,29]) , cNat , aCTF[s,29] )

			if !xAccTrf(cBco,cAge,cCon,@cBcoD,@cAgeD,@cConD)
				Alert("Nใo encontrada a conta de aplica็ใo")
				Loop
			endif		

			nNum 		:= 	Randomize(00001,32766) + Randomize(00001,32766) + Randomize(00001,32766)   

			xBcoOrig	:=	cBcoD
			xAgenOrig	:=	cAgeD
			xCtaOrig	:=	cConD
			xNaturOri	:=	cNat
			xBcoDest	:=	cBco 
			xAgenDest	:=	cAge 
			xCtaDest	:=	cCon 
			xNaturDes	:=	cNatD
			xTipoTran	:=	"TB"
			xDocTran	:=	StrZero(nNum,08)
			xValorTran	:= 	aCTF[s,08]
			xHist100	:=	aCTF[s,03]
			xBenef100	:= 	SM0->M0_NOMECOM
			
			FwMsgRun( Nil , { || CursorWait() ,	lMsErroAuto := !fa100grava(	xBcoOrig	,;
																			xAgenOrig	,;
																			xCtaOrig	,;
																			xNaturOri	,;
																			xBcoDest	,;
																			xAgenDest	,;
																			xCtaDest	,;
																			xNaturDes	,;
																			xTipoTran	,;
																			xDocTran	,;
																			xValorTran	,;
																			xHist100	,;
																			xBenef100	) , CursorArrow() , InKey(02) } , "TOTVS" , "Criando Resgate ..." )

		// Rendimento

		elseif	aCTF[s,10] $ "206" .and. lRend    

			xRat := {}
			xMod := "M1"
			xHis := aCTF[s,03]
			xNat :=	aCTF[s,15]
			xDeb := aCTF[s,16]
			xCre := aCTF[s,17]  
			xCCD := aCTF[s,18]
			xCCC := aCTF[s,19]
			xItD := aCTF[s,20]
			xItC := aCTF[s,21]
			xClD := aCTF[s,22]
			xClC := aCTF[s,23]

			aFina100 := {	{ "E5_DATA"        	, dDataBase                    	,Nil},;
							{ "E5_MOEDA"        , xMod                         	,Nil},;
							{ "E5_VALOR"        , aCTF[s,08]                  	,Nil},;
							{ "E5_NATUREZ"    	, xNat				      		,Nil},;
							{ "E5_BANCO"        , cBco		                   	,Nil},;
							{ "E5_AGENCIA"    	, cAge		                  	,Nil},;
							{ "E5_CONTA"        , cCon		                   	,Nil},;
							{ "E5_BENEF"        , cTxt				    		,Nil},;
							{ "E5_HISTOR"    	, xHis				        	,Nil}}
							
			if	Empty(xNat)
				Alert("A Natureza de Rendimento estแ em branco")
				Loop
			endif

			if	lCCL
				aAdd( aFina100 , { "E5_DEBITO" 	, xCon					   		, Nil } )
			elseif	x3Obrigat(PadR("E5_DEBITO",Len(SX3->X3_CAMPO))) .and. Empty(xCon) .and. Empty(xDeb)
				Alert("O campo da Conta Contแbil a D้bito estแ como obrigat๓rio mas a Conta Contแbil no cadastro de bancos estแ vazia. Verifique !!")
				Loop
			elseif	x3Obrigat(PadR("E5_DEBITO",Len(SX3->X3_CAMPO))) .or. !Empty(xCon) .or. !Empty(xDeb)  
				aAdd( aFina100 , { "E5_DEBITO" 	, iif( !Empty(xDeb) , xDeb , xCon ) , Nil } )
			endif			

			if	lCCL
				aAdd( aFina100 , { "E5_CREDITO"	, xCre					   		, Nil } )
			elseif	x3Obrigat(PadR("E5_CREDITO",Len(SX3->X3_CAMPO))) .and. Empty(xCre)
				Alert("O campo da Conta Contแbil a Cr้dito estแ como obrigat๓rio mas o parโmetro ZZ_XCTCREN estแ vazio. Verifique !!")
				Loop
			elseif	x3Obrigat(PadR("E5_CREDITO",Len(SX3->X3_CAMPO))) .or. !Empty(xCre)
				aAdd( aFina100 , { "E5_CREDITO"	, xCre					   		, Nil } )
			endif			

			if	x3Obrigat(PadR("E5_CCD",Len(SX3->X3_CAMPO))) .and. Empty(xCCD)
				Alert("O campo do Centro de Custo a D้bito para Rendimento estแ como obrigat๓rio mas o parโmetro ZZ_CCRENDD estแ vazio. Verifique !!")
				Loop
			elseif	x3Obrigat(PadR("E5_CCD",Len(SX3->X3_CAMPO))) .or. !Empty(xCCD)
				aAdd( aFina100 , { "E5_CCD" 	, xCCD					   		, Nil } )
			endif			

			if	x3Obrigat(PadR("E5_CCC",Len(SX3->X3_CAMPO))) .and. Empty(xCCC)
				Alert("O campo do Centro de Custo a Cr้dito para Rendimento estแ como obrigat๓rio mas o parโmetro ZZ_CCRENDC estแ vazio. Verifique !!")
				Loop
			elseif	x3Obrigat(PadR("E5_CCC",Len(SX3->X3_CAMPO))) .or. !Empty(xCCC)
				aAdd( aFina100 , { "E5_CCC" 	, xCCC					   		, Nil } )
			endif			

			if	lAlphenz
				aAdd( aFina100 , { "E5_ITEMD"	, "999999"				   		, Nil } )
			elseif	x3Obrigat(PadR("E5_ITEMD",Len(SX3->X3_CAMPO))) .and. Empty(xItD)
				Alert("O campo do Item Contแbil a D้bito para Rendimento estแ como obrigat๓rio mas o parโmetro ZZ_ITMCRDD estแ vazio. Verifique !!")
				Loop
			elseif	x3Obrigat(PadR("E5_ITEMD",Len(SX3->X3_CAMPO))) .or. !Empty(xItD)
				aAdd( aFina100 , { "E5_ITEMD" 	, xItD					   		, Nil } )
			endif			

			if	x3Obrigat(PadR("E5_ITEMC",Len(SX3->X3_CAMPO))) .and. Empty(xItC)
				Alert("O campo do Item Contแbil a Cr้dito para Rendimento estแ como obrigat๓rio mas o parโmetro ZZ_ITMCRDC estแ vazio. Verifique !!")
				Loop
			elseif	x3Obrigat(PadR("E5_ITEMC",Len(SX3->X3_CAMPO))) .or. !Empty(xItC)
				aAdd( aFina100 , { "E5_ITEMC" 	, xItC					   		, Nil } )
			endif			

			if	x3Obrigat(PadR("E5_CLVLDB",Len(SX3->X3_CAMPO))) .and. Empty(xClD)
				Alert("A Classe de Valor a D้bito para Rendimento estแ como obrigat๓rio mas o parโmetro ZZ_CLVLRDD estแ vazio. Verifique !!")
				Loop
			elseif	x3Obrigat(PadR("E5_CLVLDB",Len(SX3->X3_CAMPO))) .or. !Empty(xClD)
				aAdd( aFina100 , { "E5_CLVLDB" 	, xClD						   	, Nil } )
			endif			

			if	x3Obrigat(PadR("E5_CLVLCR",Len(SX3->X3_CAMPO))) .and. Empty(xClC)
				Alert("A Classe de Valor a Cr้dito para Rendimento estแ como obrigat๓rio mas o parโmetro ZZ_CLVLRDC estแ vazio. Verifique !!")
				Loop
			elseif	x3Obrigat(PadR("E5_CLVLCR",Len(SX3->X3_CAMPO))) .or. !Empty(xClC)
				aAdd( aFina100 , { "E5_CLVLCR" 	, xClC					   		, Nil } )
			endif			

			FwMsgRun( Nil , { || CursorWait() , MsExecAuto( { |x,y,z| FinA100(x,y,z) } , 0 , aFina100 , 4 ) , CursorArrow() } , "TOTVS" , "Criando Rendimento ..." )

		endif

		if 	lMsErroAuto
			MostraErro()  
		//	DisarmTransaction()  
		else
			lProcessado := .t.
		endif
	endif 
	
Next s       

if	lProcessado
	if !ExistDir(Alltrim(cDirectory) + "\Processados")			
		MakeDir(Alltrim(cDirectory) + "\Processados")			
	endif				
    if	__CopyFile( Alltrim(cDirectory) + "\" + Alltrim(cArq) , Alltrim(cDirectory) + "\Processados\" + Alltrim(cArq) )   
		fErase(Alltrim(cDirectory) + "\" + Alltrim(cArq))
	endif
endif

if	.f.		//"ZAPPONI" $ Upper(Alltrim(GetEnvServer())) .or. "TV5GFE_PRD_COMP" $ Upper(Alltrim(GetEnvServer()))
	if	MsgYesNo("Desarma Transa็ใo ?")
		DisarmTransaction()
	endif
endif

End Transaction 

dDataBase := xDataBase            

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xAccTrf(cBco,cAge,cCon,xBco,xAge,xCon)

Local lFind		:=	.f.    

Default xBco	:= 	PadR( cBco 					, TamSx3("A6_COD")[1]		)
Default xAge	:= 	PadR( Alltrim(cAge) + "A" 	, TamSx3("A6_AGENCIA")[1]	)
Default xCon	:= 	PadR( cCon 					, TamSx3("A6_NUMCON")[1]	)    	

SA6->(dbsetorder(1))
SA6->(dbgotop())     
if	SA6->(dbseek( xFilial("SA6") + xBco + xAge + xCon , .f. ))    		
	lFind	:= 	.t.      
endif

if !lFind
	SA6->(dbgotop())     
	if	SA6->(dbseek( xFilial("SA6") + cBco + cAge + cCon , .f. ))    		
		if	SA6->(FieldPos('A6_ZZBCOAP')) <> 0 .and. !Empty(SA6->A6_ZZBCOAP)
			if	SA6->(FieldPos('A6_ZZAGEAP')) <> 0 .and. !Empty(SA6->A6_ZZAGEAP)
				if	SA6->(FieldPos('A6_ZZCTAAP')) <> 0 .and. !Empty(SA6->A6_ZZCTAAP)
					if	SA6->(dbseek( xFilial("SA6") + SA6->A6_ZZBCOAP + SA6->A6_ZZAGEAP + SA6->A6_ZZCTAAP 	, .f. ))    		
						SA6->(dbseek( xFilial("SA6") + cBco            + cAge            + cCon 			, .f. ))    								
						xBco	:=	SA6->A6_ZZBCOAP	
						xAge 	:=	SA6->A6_ZZAGEAP
						xCon 	:=	SA6->A6_ZZCTAAP			
						lFind	:= 	.t.      
                    else
						xBco	:= 	Space( TamSx3("A6_COD")[1]		)
						xAge	:= 	Space( TamSx3("A6_AGENCIA")[1]	)
						xCon	:= 	Space( TamSx3("A6_NUMCON")[1]	)    	
						lFind	:= 	.f.      
					endif
				endif
			endif
		endif
	else	
		xBco	:= 	Space( TamSx3("A6_COD")[1]		)
		xAge	:= 	Space( TamSx3("A6_AGENCIA")[1]	)
		xCon	:= 	Space( TamSx3("A6_NUMCON")[1]	)    	
		lFind	:= 	.f.      
	endif
endif

Return ( lFind )       

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xChecaVar()

if	lW40 == Nil	
	lW40  		:=	ChecaEmp("W40") 
	lCCL  		:=	ChecaEmp("CCL") 
	lFadel		:=	ChecaEmp("FADEL") 
	lMando		:=	ChecaEmp("MANDO") 
	lCheck		:=	ChecaEmp("CHECKP") 
	lMastra		:=	ChecaEmp("MASTRA") 
	lAlphenz	:=	ChecaEmp("ALPHENZ") 
endif
	
Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
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
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  24/02/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
/*
User Function FA100GET()

Local aRet	:=	Nil

if	IsInCallStack("U_XIMPEXTRATO") .or. IsInCallStack("U_XIMPEXTRAT") .or. IsInCallStack("U_XIMPEXTRA") .or. IsInCallStack("U_XIMPEXTR")  

	aRet :=	{} 
	
	aAdd( aRet , { xBcoOrig		, "" } )
	aAdd( aRet , { xAgenOrig	, "" } )
	aAdd( aRet , { xCtaOrig		, "" } )
	aAdd( aRet , { xNaturOri	, "" } )
	aAdd( aRet , { xBcoDest		, "" } )
	aAdd( aRet , { xAgenDest	, "" } )
	aAdd( aRet , { xCtaDest		, "" } )
	aAdd( aRet , { xNaturDes	, "" } )
	aAdd( aRet , { xTipoTran	, "" } )
	aAdd( aRet , { xDocTran		, "" } )
	aAdd( aRet , { xValorTran	, "" } )
	aAdd( aRet , { xHist100		, "" } )
	aAdd( aRet , { xBenef100	, "" } )

endif

Return ( aRet )                

User Function FA100TRF()

Local xRet := .t.

Return ( xRet )
*/

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  02/26/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fa100grava(	cBcoOrig	,;
							cAgenOrig	,;
							cCtaOrig	,;
							cNaturOri	,;
							cBcoDest	,;
							cAgenDest	,;
							cCtaDest	,;
							cNaturDes	,;
							cTipoTran	,;
							cDocTran	,;
							nValorTran	,;
							cHist100	,;
							cBenef100	,;
							lEstorno	,;
							cModSpb		,;
							aTrfPms		,;
							nTxMoeda	,;
							nRegOrigem	,;
							nRegDestino	,;
							dDataCred	,;
							lExterno	)

Local nRegSEF 		:= 	0
Local nMBcoOri		:= 	0										
Local nMBcoDst		:= 	0										
Local nValorConv 	:= 	0

Local aGetSED    	:= 	{}
Local aFlagCTB 		:= 	{}

Local cLog       	:= 	""
Local cIdMovim   	:= 	""
Local cMoedaBnc  	:= 	""
Local cProcesso 	:= 	""
Local cCamposE5  	:=	""

Local lRet       	:= 	.t.
Local lPadrao1		:=	.f.
Local lPadrao2		:= 	.f.
Local lAtuSldNat	:= 	.t.

Local lMostra		:= 	Nil	
Local oSubFK5		:= 	Nil	
Local oSubFKA		:= 	Nil	
Local lAglutina		:= 	Nil	
Local oModelMov 	:= 	Nil	

Local lA100TRA		:= 	ExistBlock("A100TRA")
Local lA100TRB		:= 	ExistBlock("A100TRB")
Local lA100TRC		:= 	ExistBlock("A100TRC")
Local lA100TR01		:= 	ExistBlock("A100TR01")
Local lA100TR02		:= 	ExistBlock("A100TR02")
Local lA100TR03		:= 	ExistBlock("A100TR03")

Local cPadrao		:= 	"560"
Local dDtdisp    	:= 	dDatabase
Local lUsaFlag		:= 	SuperGetMv( "MV_CTBFLAG" , .t. , .f. )
Local lSpbInUse		:= 	SpbInUse()

Default cModSpb     := 	""
Default aTrfPms     := 	{}
Default lEstorno    :=	.f.
Default lExterno    :=	.f.
Default nTxMoeda    :=	000
Default nRegOrigem  := 	000
Default nRegDestino := 	000

Default dDataCred  	:= 	dDataBase

Private cLote
Private nTotal		:=	00
Private cArquivo 	:=	""

LoteCont("FIN")

dbSelectarea("SE5")

cProcesso := GetSx8Num("SE5","E5_PROCTRA","E5_PROCTRA" + cEmpAnt)

ConfirmSx8()

dbSelectarea("SEF")

STRLCTPAD := " "

if !Empty(cBcoOrig + cAgenOrig + cCtaOrig) .and. !Empty(cBcoDest + cAgenDest + cCtaDest)

	dbSelectArea("SA6")
	dbSetOrder(1)  
	dbseek( xFilial("SA6") + cBcoDest + cAgenDest + cCtaDest )

	dbSelectArea("SA6")
	dbSetOrder(1)  
	dbseek( xFilial("SA6") + cBcoOrig + cAgenOrig + cCtaOrig )

	nMBcoOri := SA6->A6_MOEDA
	cIdMovim := CriaVar("E5_IDMOVI",.t.)

	if 	lRet
		cCamposE5 := "{"
		cCamposE5 += " { 'E5_DTDIGIT' , dDataBase           },"
		cCamposE5 += " { 'E5_BENEF'   , '" + cBenef100	+ "'},"
		cCamposE5 += " { 'E5_IDMOVI'  , '" + cIdMovim 	+ "'},"
		cCamposE5 += " { 'E5_MOVFKS'  , 'S'                 } "
		cCamposE5 += "}"

		oModelMov := FwLoadModel("FINM030")
		oModelMov:SetOperation( MODEL_OPERATION_INSERT ) 
		oModelMov:Activate()
		oModelMov:SetValue( "MASTER" , "E5_GRV"		, .t. 		) //Informa se vai gravar SE5 ou nใo
		oModelMov:SetValue( "MASTER" , "E5_CAMPOS"	, cCamposE5 ) //Informa os campos da SE5 que serใo gravados indepentes de FK5
		oModelMov:SetValue( "MASTER" , "NOVOPROC"	, .t. 		) //Informa que a inclusใo serแ feita com um novo n๚mero de processo

		//Dados do Processo
		oSubFKA	:= 	oModelMov:GetModel("FKADETAIL")

		oSubFKA:SetValue( "FKA_IDORIG" 	, FWUUIDV4() )
		oSubFKA:SetValue( "FKA_TABORI" 	, "FK5" 	 )

		oSubFK5	:= 	oModelMov:GetModel( "FK5DETAIL"  )

		oSubFK5:SetValue( "FK5_DATA"	, dDataBase  )
		oSubFK5:SetValue( "FK5_BANCO"	, cBcoOrig   )
		oSubFK5:SetValue( "FK5_AGENCI"	, cAgenOrig  )
		oSubFK5:SetValue( "FK5_CONTA"	, cCtaOrig   )
		oSubFK5:SetValue( "FK5_RECPAG"	, "P"        )
		oSubFK5:SetValue( "FK5_NUMCH"	, cDocTran   )
		oSubFK5:SetValue( "FK5_HISTOR"	, cHist100   )
		oSubFK5:SetValue( "FK5_TPDOC"	, "TR"       )
		oSubFK5:SetValue( "FK5_MOEDA"	, cTipoTran  )
		oSubFK5:SetValue( "FK5_ORIGEM"	, FunName()  )
		oSubFK5:SetValue( "FK5_VALOR"	, nValorTran )
		oSubFK5:SetValue( "FK5_DTDISP"	, dDtdisp 	 )
		oSubFK5:SetValue( "FK5_NATURE"	, cNaturOri  )
		oSubFK5:SetValue( "FK5_FILORI"	, cFilAnt 	 )
		if 	lSpbInUse
			oSubFK5:SetValue("FK5_MODSPB",cModSpb)
		endif
		oSubFK5:SetValue( "FK5_PROTRA"	, cProcesso  )

		if 	oModelMov:VldData()
			oModelMov:CommitData()
		else
			lRet := .f.
			cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[6])
			Help(Nil,Nil,"MF100GRV1",Nil,cLog,1,0)
		endif

		oModelMov:DeActivate()
		oModelMov:Destroy()
		oModelMov := Nil
	endif

	if 	lRet
		if 	lAtuSldNat .and. cNaturOri <> cNaturDes
			SA6->(dbsetorder(1))
			SA6->(dbSeek( xFilial("SA6") + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA ) )

			cMoedaBnc 	:= 	StrZero(Max(SA6->A6_MOEDA,1),2)
			nValorConv 	:= 	iif( Empty(SE5->E5_TXMOEDA) , SE5->E5_VALOR , SE5->E5_VALOR * SE5->E5_TXMOEDA )

			AtuSldNat(SE5->E5_NATUREZ,SE5->E5_DATA,cMoedaBnc,"3","P",SE5->E5_VALOR,nValorConv,iif(lEstorno,"-","+"),Nil,FunName(),"SE5",SE5->(Recno()),0)
		endif

		if 	UsaSeqCor()
			aAdd(aDiario,{"SE5",SE5->(Recno()),cCodDiario,"E5_NODIA","E5_DIACTB"})
		else
			aDiario := {}
		endif
	endif

	if 	lRet       
	
		if	( Alltrim(cTipoTran) == "TB" .or. ( Alltrim(cTipoTran) == "CH" .and. !IsCaixaLoja(cBcoOrig) ) ) .and. !lEstorno
			nRegSEF := Fa100Cheq("FINA100TRF")
		endif

		if 	lA100TR01
			ExecBlock("A100TR01",.f.,.f.,lEstorno)
		endif

		if 	lA100TRA
			ExecBlock("A100TRA",.f.,.f.,{ lEstorno , cBcoOrig ,  cBcoDest , cAgenOrig , cAgenDest , cCtaOrig , cCtaDest , cNaturOri , cNaturDes , cDocTran , cHist100 })
		endif

		if 	( ( Alltrim(SE5->E5_MOEDA) $ "R$/DO/TB/TC" ) .or. ( SE5->E5_MOEDA == "CH" .and. !IsCaixaLoja(cBcoOrig) ) ) .and. Substr(SE5->E5_NUMCHEQ,1,1) <> "*" 
			AtuSalBco(cBcoOrig,cAgenOrig,cCtaOrig,dDataBase,SE5->E5_VALOR,"-")
		endif

		PcoDetLan("000007","01","FINA100")

		if !lExterno

			lPadrao1 	:= 	VerPadrao( cPadrao )
			STRLCTPAD 	:= 	cBcoDest + "/" + cAgenDest + "/" + cCtaDest

			if 	lPadrao1 .and. mv_par04 == 1  

				aGetSED	:= 	SED->(GetArea())

				SED->(dbsetorder(1))
				SED->(dbseek(xFilial("SED") + SE5->E5_NATUREZ))

				nHdlPrv	:= 	HeadProva( cLote , "FINA100" , Substr(cUsuario,7,6) , @cArquivo )

				if 	lUsaFlag  
					aAdd( aFlagCTB, {"E5_LA", "S", "SE5", SE5->( Recno() ), 0, 0, 0} )
				endif

				nTotal	+= 	DetProva( nHdlPrv , cPadrao , "FINA100" , cLote , Nil , Nil , Nil , Nil , Nil , Nil , Nil , @aFlagCTB , Nil , Nil )

				if !lUsaFlag

					oModelMov	:= 	FwLoadModel("FINM030") 
					oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) 
					oModelMov:Activate()
					oModelMov:SetValue( "MASTER", "E5_GRV", .t. ) 

					oSubFKA 	:= 	oModelMov:GetModel( "FKADETAIL" )

					if 	oSubFKA:SeekLine( { { "FKA_FILIAL" , SE5->E5_FILIAL } , { "FKA_IDORIG" , SE5->E5_IDORIG } } )

						oSubFK5	:= 	oModelMov:GetModel("FK5DETAIL")
						oSubFK5:SetValue( "FK5_LA" , "S" )

						if 	oModelMov:VldData()
							oModelMov:CommitData()
						else
							lRet := .f.
							cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
							cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
							cLog += cValToChar(oModelMov:GetErrorMessage()[6])
							Help(Nil,Nil,"MF100GRV3",Nil,cLog,1,0)
						endif
					endif
					oModelMov:DeActivate()
					oModelMov:Destroy()
					oModelMov := Nil
				endif

				RestArea(aGetSED)
			endif
		endif
	endif

	if 	lRet
		
		dbSelectArea("SA6")
		dbSeek( xFilial("SA6") + cBcoDest + cAgenDest + cCtaDest )

		nMBcoDst	:= 	SA6->A6_MOEDA

		cCamposE5 	:= 	"{"
		cCamposE5 	+= 	" { 'E5_DTDIGIT' , dDataBase           },"
		cCamposE5 	+= 	" { 'E5_BENEF'   , '" + cBenef100 + "' },"
		cCamposE5 	+= 	" { 'E5_IDMOVI'  , '" + cIdMovim  + "' },"
		cCamposE5 	+= 	" { 'E5_MOVFKS'  , 'S'                 } "
		cCamposE5 	+= 	"}"

		oModelMov 	:= 	FwLoadModel("FINM030")
		oModelMov:SetOperation( MODEL_OPERATION_INSERT ) 
		oModelMov:Activate()
		oModelMov:SetValue( "MASTER" 	, "E5_GRV"		, .t. 			) 	//Informa se vai gravar SE5 ou nใo
		oModelMov:SetValue( "MASTER" 	, "E5_CAMPOS"	, cCamposE5		) 	//Informa os campos da SE5 que serใo gravados indepentes de FK5
		oModelMov:SetValue( "MASTER" 	, "NOVOPROC"	, .f. 			) 	//Informa que a inclusใo serแ feita com um n๚mero de processo jแ existente

		oSubFKA 	:= 	oModelMov:GetModel("FKADETAIL")
		oSubFKA:SetValue( "FKA_IDORIG"	, FWUUIDV4()	)
		oSubFKA:SetValue( "FKA_TABORI"	, "FK5" 		)

		//Informacoes do movimento
		oSubFK5 	:= 	oModelMov:GetModel( "FK5DETAIL"	)

		oSubFK5:SetValue( "FK5_DATA"	, dDataBase		)
		oSubFK5:SetValue( "FK5_BANCO"	, cBcoDest 		)
		oSubFK5:SetValue( "FK5_AGENCI"	, cAgenDest		)
		oSubFK5:SetValue( "FK5_CONTA"	, cCtaDest 		)
		oSubFK5:SetValue( "FK5_RECPAG"	, "R" 			)
		oSubFK5:SetValue( "FK5_DOC"		, cDocTran 		)
		oSubFK5:SetValue( "FK5_HISTOR"	, cHist100 		)
		oSubFK5:SetValue( "FK5_TPDOC"	, "TR" 			)
		oSubFK5:SetValue( "FK5_MOEDA"	, cTipoTran		)
		oSubFK5:SetValue( "FK5_ORIGEM"	, FunName() 	)

		if 	nMBcoOri > nMBcoDst
			oSubFK5:SetValue( "FK5_VALOR"  , Round(xMoeda(nValorTran,nMBcoOri,1,dDataBase,MsDecimais(Max(SA6->A6_MOEDA,1)) + 1,aTxMoedas[nMBcoOri][2],aTxMoedas[1][2]),MsDecimais(Max(SA6->A6_MOEDA,1))) )
			oSubFK5:SetValue( "FK5_VLMOE2" , nValorTran 			)
			oSubFK5:SetValue( "FK5_TXMOED" , aTxMoedas[nMBcoOri][2] )
		else
			oSubFK5:SetValue( "FK5_VALOR"  , nValorTran 			)
		endif

		oSubFK5:SetValue( "FK5_DTDISP"	, dDataCred 	)
		oSubFK5:SetValue( "FK5_NATURE"	, cNaturDes 	)
		oSubFK5:SetValue( "FK5_FILORI"	, cFilAnt 		)
		if 	lSpbInUse
			oSubFK5:SetValue("FK5_MODSPB",cModSpb)
		endif
		oSubFK5:SetValue( "FK5_PROTRA"	, cProcesso 	)

		if 	oModelMov:VldData()
			oModelMov:CommitData()
		else
			lRet := .f.
			cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[6])
			Help(,,"MF100GRV4",,cLog, 1, 0 )
		endif
		oModelMov:DeActivate()
		oModelMov:Destroy()
		oModelMov := Nil

		if 	lRet
			if 	UsaSeqCor()
				aAdd(aDiario,{"SE5",SE5->(Recno()),cCodDiario,"E5_NODIA","E5_DIACTB"})
			else
				aDiario := {}
			endif
		endif

		if 	lRet
			If 	lAtuSldNat .And. cNaturOri <> cNaturDes
				SA6->(dbsetorder(1))
				SA6->(dbSeek( xFilial("SA6") + SE5->E5_BANCO + SE5->E5_AGENCIA + SE5->E5_CONTA ) )

				cMoedaBnc  	:= 	StrZero(Max(SA6->A6_MOEDA,1),2)
				nValorConv	:= 	iif(Empty(SE5->E5_TXMOEDA),SE5->E5_VALOR,SE5->E5_VALOR * SE5->E5_TXMOEDA)

				AtuSldNat(SE5->E5_NATUREZ,SE5->E5_DATA,"01","3","R",SE5->E5_VALOR,,iif(lEstorno,"-","+"),,FunName(),"SE5",SE5->(Recno()),0)
			endif

			if 	lA100TR02
				ExecBlock("A100TR02",.f.,.f.,lEstorno)
			endif

			if 	lA100TRB
				ExecBlock("A100TRB",.f.,.f.,{lEstorno,cBcoOrig, cBcoDest,cAgenOrig,cAgenDest,cCtaOrig,cCtaDest,cNaturOri,cNaturDes,cDocTran,cHist100})
			endif

			if 	( ( Alltrim(SE5->E5_MOEDA) $ "R$/DO/TB/TC" ) .or. ( SE5->E5_MOEDA == "CH" .and. !IsCaixaLoja(cBcoOrig) ) ) .and. Substr(SE5->E5_NUMCHEQ,1,1) <> "*"
				AtuSalBco(cBcoDest,cAgenDest,cCtaDest,dDataBase,SE5->E5_VALOR,"+")
			endif

			PcoDetLan("000007","02","FINA100")

			if !lExterno

				cPadrao   	:= 	"561"
				lPadrao2  	:= 	VerPadrao(cPadrao)
				STRLCTPAD	:= 	cBcoOrig + "/" + cAgenOrig + "/" + cCtaOrig

				if 	lPadrao2 .and. !lPadrao1 .and. mv_par04 == 1
					nHdlPrv	:= 	HeadProva(cLote,"FINA100",Substr(cUsuario,7,6),@cArquivo)
				endif

				if 	lPadrao2 .and. mv_par04 == 1
					nTotal	+= 	DetProva( nHdlPrv , cPadrao , "FINA100" , cLote )
				endif

				if 	( lPadrao1 .or. lPadrao2 ) .and. mv_par04 == 1

					lMostra	 	:= 	mv_par02 == 1 
					lAglutina	:= 	mv_par01 == 1 

					RodaProva( nHdlPrv, nTotal )

					cA100Incl( cArquivo , nHdlPrv , 3 , cLote , lMostra , lAglutina , , , , @aFlagCTB , , aDiario )
					aFlagCTB 	:= 	{}  

					if 	lPadrao1 .and. nRegSEF > 0
						DbSelectArea("SEF")
						dbgoto(nRegSEF)
						Reclock("SEF")
							SEF->EF_LA := "S"
						MsUnlock("SEF")
					endif
				endif
			endif
		endif
	endif
endif

if 	lRet
	if 	lA100TR03
		ExecBlock("A100TR03",.f.,.f.,lEstorno)
	endif
	if 	lA100TRC
		ExecBlock("A100TRC",.f.,.f.,{ lEstorno , cBcoOrig , cBcoDest , cAgenOrig , cAgenDest , cCtaOrig , cCtaDest , cNaturOri , cNaturDes , cDocTran , cHist100 } )
	endif
endif

if 	lRet .and. !lExterno .and. lPadrao2 .and. mv_par04 == 1  // On Line

	oModelMov	:= 	FwLoadModel("FINM030") 
	oModelMov:SetOperation( MODEL_OPERATION_UPDATE ) 
	oModelMov:Activate()
	oModelMov:SetValue( "MASTER" , "E5_GRV" , .t. ) 

	oSubFKA 	:= 	oModelMov:GetModel( "FKADETAIL" )
	if 	oSubFKA:SeekLine( { { "FKA_FILIAL" , SE5->E5_FILIAL } , { "FKA_IDORIG" , SE5->E5_IDORIG } } )

		oSubFK5	:= 	oModelMov:GetModel("FK5DETAIL")
		oSubFK5:SetValue( "FK5_LA" , "S" )

		if 	oModelMov:VldData()
			oModelMov:CommitData()
		else
			lRet := .f.
			cLog := cValToChar(oModelMov:GetErrorMessage()[4]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[5]) + ' - '
			cLog += cValToChar(oModelMov:GetErrorMessage()[6])
			Help(Nil,Nil,"MF100GRV6",Nil,cLog,1,0)
		endif
	endif
	oModelMov:DeActivate()
	oModelMov:Destroy()
	oModelMov := Nil
endif

if 	lRet
	if 	Len(Alltrim(SE5->E5_PROCTRA)) > 0
		PutMv("MV_NPROC",SE5->E5_PROCTRA)
	endif
else
	DisarmTransaction()
endif

Return ( lRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  12/18/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fSelect(oDlg,oCTF,aCTF)    	

Local nColPos	:=	oCTF:nColPos

if	nColPos == 01 .and. aCTF[oCTF:nAt,09] .and. aCTF[oCTF:nAt,10] $ '102/105/106/206' 
	aCTF[oCTF:nAt,01] := !aCTF[oCTF:nAt,01] 
elseif	nColPos == 08 
	fMarkNatu(@oDlg,@oCTF,@aCTF)
elseif	nColPos == 09 .or. nColPos == 10
	fMarkCtas(@oDlg,@oCTF,@aCTF)
elseif	nColPos == 11 .or. nColPos == 12
	fMarkCenC(@oDlg,@oCTF,@aCTF)
elseif	nColPos == 13 .or. nColPos == 14
	fMarkItem(@oDlg,@oCTF,@aCTF)
elseif	nColPos == 15 .or. nColPos == 16
	fMarkClVl(@oDlg,@oCTF,@aCTF)
elseif	nColPos >= 17 .and. nColPos <= 19 .and. aCTF[oCTF:nAt,09] .and. aCTF[oCTF:nAt,10] $ '106/206' 
	fMarkBank(@oDlg,@oCTF,@aCTF)
endif

Return 
                    
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  12/18/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkBank(oDlg,oGrid,aArray)

Local aRet 	:= 	RetBancos(	PadR(aArray[oGrid:nAt,24],TamSx3("A6_COD")[01])		,;
							PadR(aArray[oGrid:nAt,25],TamSx3("A6_AGENCIA")[01])	,;
							PadR(aArray[oGrid:nAt,26],TamSx3("A6_NUMCON")[01])	) 

if	Empty(aRet[1]) 
	Return
else
	aArray[oGrid:nAt,24] := aRet[1]
	aArray[oGrid:nAt,25] := aRet[2]
	aArray[oGrid:nAt,26] := aRet[3]
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  12/18/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function RetBancos(cBancoAdt,cAgenciaAdt,cNumCon)

Local xDlg                      
Local nOpc				:=	00
Local xBancoAdt     	:=	CriaVar("A6_COD",.f.)		
Local xAgenciaAdt		:=	CriaVar("A6_AGENCIA",.f.)
Local xNumCon     		:=	CriaVar("A6_NUMCON",.f.)

Default	cBancoAdt     	:=	xBancoAdt
Default cAgenciaAdt		:=	xAgenciaAdt
Default cNumCon     	:=	xNumCon

Define MsDialog xDlg From 15,05 To 25,38 Title "Informe" Style 128
@ 0.3,1.0 To 04.1,15.5 																															Of xDlg
@ 1.0,2.0 Say "Banco : " 																														Of xDlg
@ 2.0,2.0 Say "Ag๊ncia : " 																														Of xDlg
@ 3.0,2.0 Say "Conta : "  																														Of xDlg
@ 1.0,7.5 MsGet cBancoAdt 	F3 "SA6"	                                              															Of xDlg 	HasButton
@ 2.0,7.5 MsGet cAgenciaAdt 			                                          																Of xDlg
@ 3.0,7.5 MsGet cNumCon 				                                                         												Of xDlg
Define sButton From 061,097.1 Type 1 Action ( nOpc := 1 , iif( xValidBco(cBancoAdt,cAgenciaAdt,cNumCon) , xDlg:End() , nOpc := 0 ) )		 	Of xDlg		Enable
Activate MsDialog xDlg Centered 

Return iif( nOpc == 1 , { cBancoAdt , cAgenciaAdt , cNumCon } , { xBancoAdt , xAgenciaAdt , xNumCon } ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  12/18/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xValidBco(xBanco,xAgencia,xConta,lAlert)

Local lRet			:=	.f.

Default lAlert		:=	.t.

if	SA6->(dbsetorder(1),dbseek( xFilial("SA6") + xBanco + xAgencia + xConta , .f. ))
	lRet			:=	.t.
elseif	lAlert
	MessageBox("Banco digitado nใo foi encontrado","Aten็ใo",MB_ICONHAND) 
endif

Return ( lRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  12/18/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkNatu(oDlg,oGrid,aArray)

Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1       
Local lOk			:=	.f.     
Local cTGet1		:=	CriaVar("ED_CODIGO",.f.)   
Local oFont 		:= 	tFont():New("Tahoma",Nil,-11,.t.)

Define Dialog oDlgAlt Title "Digite" From 000,000 To 080,200 Pixel
oSay1		:= 	TSay():Create(oDlgAlt,{ || "Natureza :" },08,05,,oFont,,,,.t.,Nil,)
oTGet1 		:= 	TGet():New(05,42,bSetGet(cTGet1),oDlgAlt,055,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,"SED")
oTButton1	:= 	TButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered

if	lOk
	if	ExistCpo("SED",cTGet1,1)
		aArray[oGrid:nAt,oGrid:nColPos + 7] := cTGet1
	endif
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  12/18/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkCtas(oDlg,oGrid,aArray)

Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1       
Local lOk			:=	.f.     
Local cTGet1		:=	CriaVar("CT1_CONTA",.f.)   
Local oFont 		:= 	tFont():New("Tahoma",Nil,-11,.t.)

Define Dialog oDlgAlt Title "Digite" From 000,000 To 080,200 Pixel
oSay1		:= 	TSay():Create(oDlgAlt,{ || "Conta :" },08,05,,oFont,,,,.t.,Nil,)
oTGet1 		:= 	TGet():New(05,37,bSetGet(cTGet1),oDlgAlt,060,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,"CT1")
oTButton1	:= 	TButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered

if	lOk
	if	ExistCpo("CT1",cTGet1,1)
		aArray[oGrid:nAt,oGrid:nColPos + 7] := cTGet1
	endif
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  12/18/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkCenC(oDlg,oGrid,aArray)

Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1       
Local lOk			:=	.f.     
Local cTGet1		:=	CriaVar("CTT_CUSTO",.f.)   
Local oFont 		:= 	tFont():New("Tahoma",Nil,-11,.t.)

Define Dialog oDlgAlt Title "Digite" From 000,000 To 080,200 Pixel
oSay1		:= 	TSay():Create(oDlgAlt,{ || "C. Custo :" },08,05,,oFont,,,,.t.,Nil,)
oTGet1 		:= 	TGet():New(05,42,bSetGet(cTGet1),oDlgAlt,055,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,"CTT")
oTButton1	:= 	TButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered

if	lOk
	if	ExistCpo("CTT",cTGet1,1)
		aArray[oGrid:nAt,oGrid:nColPos + 7] := cTGet1
	endif
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  12/18/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkItem(oDlg,oGrid,aArray)

Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1       
Local lOk			:=	.f.     
Local cTGet1		:=	CriaVar("CTD_ITEM",.f.)   
Local oFont 		:= 	tFont():New("Tahoma",Nil,-11,.t.)

Define Dialog oDlgAlt Title "Digite" From 000,000 To 080,200 Pixel
oSay1		:= 	TSay():Create(oDlgAlt,{ || "Item :" },08,05,,oFont,,,,.t.,Nil,)
oTGet1 		:= 	TGet():New(05,37,bSetGet(cTGet1),oDlgAlt,060,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,"CTD")
oTButton1	:= 	TButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered

if	lOk
	if	ExistCpo("CTD",cTGet1,1)
		aArray[oGrid:nAt,oGrid:nColPos + 7] := cTGet1
	endif
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXIMPEXTRATOบAutor  ณMicrosiga          บ Data ณ  12/18/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkClVl(oDlg,oGrid,aArray)

Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1       
Local lOk			:=	.f.     
Local cTGet1		:=	CriaVar("CTH_CLVL",.f.)   
Local oFont 		:= 	tFont():New("Tahoma",Nil,-11,.t.)

Define Dialog oDlgAlt Title "Digite" From 000,000 To 080,200 Pixel
oSay1		:= 	TSay():Create(oDlgAlt,{ || "Classe :" },08,05,,oFont,,,,.t.,Nil,)
oTGet1 		:= 	TGet():New(05,37,bSetGet(cTGet1),oDlgAlt,060,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,"CTH")
oTButton1	:= 	TButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered

if	lOk
	if	ExistCpo("CTH",cTGet1,1)
		aArray[oGrid:nAt,oGrid:nColPos + 7] := cTGet1
	endif
endif

Return 
