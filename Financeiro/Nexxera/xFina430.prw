#include "topconn.ch"   	    		 		              		
#include "protheus.ch"   	    		 		              		
#include "fwbrowse.ch"  				
	         		
#define CSSBOTAZ	"QPushButton { color: #FFFFFF                  ; " +;         	
					"    border-radius: 5px                        ; " +;
					"    border-style: outset                      ; " +;
					"    border: 1px solid #000000                 ; " +;
					"    border-top-width: 1px                     ; " +;
					"    border-left-width: 1px                    ; " +;
					"    border-right-width: 1px                   ; " +;
					"    border-bottom-width: 1px                  ; " +;
					"    background-color: #1F739E                 } " +;
					"QPushButton:pressed { color: #FFFFFF          ; " +;
					"    border-radius: 5px                        ; " +;
					"    border-style: outset                      ; " +;
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

Static lW40   	:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )     		
Static lCCL  	:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )
Static lFadel	:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )
Static lMando	:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )
Static lCheck	:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )
Static lMastra	:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )
Static lAlphenz	:=	iif( IsBlind() .or. Type("__LocalDriver") == "U" , .f. , Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ   	
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ	FIG_ZZSEQ  C(06)
ฑฑบPrograma  ณXFINA430  บAutor  ณAlexandre Zapponi   บ Data ณ  01/17/19   บฑฑ	FIG_ZZARQ  C(40)
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ	FIG_ZZJUR  N(14,2)
ฑฑบDesc.     ณLeitura de arquivo DDA Itau                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ	XREADDDA
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xReadDDA(xArqAut) ; Return ( U_xFina430(@xArqAut) )

User Function xFina430(xArqAut)    

Local s
Local aArq			:=	{}  
Local aBXA			:=	{} 
Local aFIG			:=	{} 
Local xFIG			:=	{} 
Local lArq			:=	.f.   
Local lProc			:=	.t.
Local xFilAnt		:=	cFilAnt
Local xFunName		:=	FunName()  
Local xDataBase		:=	dDataBase   
Local aAreaSM0		:=	SM0->(GetArea())      
Local lSE2Excl		:=	FwModeAccess("SE2") == "E"
Local lFIGExcl		:=	FwModeAccess("FIG") == "E"   

Local lCanSave		:=	.f.
Local lUserSave		:=	.f.
Local lCentered		:= 	.t.
Local aPergs		:=	{}  
Local aRetParam		:=	{}        

Local xObj			:= 	RetornaLicensa():New()
Local lCont			:=	xObj:ChecaEmpDDA()	
Local dMaxDate		:=	Max(Max(Date(),GetRmtDate()),dDataBase)    

Default xArqAut		:=	""

Private lArqAut 	:=	!Empty(xArqAut)
Private sArquivo 	:=	""
Private xArquivo 	:=	""
Private xSequencia	:=	""
Private cDirectory	:=	""

if	lFadel	
//	lCont			:=	xObj:ChecaEmpDDA()	
endif

if !lCont     		
	if	dMaxDate >= StoD("20230531")     			
		Alert("Perํodo de avalia็ใo encerrado") 
		Return
	endif
endif      

fChecaPar( "ZZ_KEEPVCT" , "Mantem vencimento do titulo                " , "N" 															, "C" )
fChecaPar( "ZZ_BSCRAIZ" , "Busca os titulos pela Raiz do CNPJ         " , "S" 															, "C" )
fChecaPar( "ZZ_DDAPERC" , "Percentual de margem de busca de titulos   " , "10" 															, "N" )
fChecaPar( "ZZ_EMLBXEN" , "Envia Email de estorno de boleto a pagar   " , iif( lCCL .or. lCheck	, "S"                         , "N" ) 	, "C" )
fChecaPar( "ZZ_EMLBXBL" , "Email de envio de estorno de boleto a pagar" , iif( lCCL .or. lCheck	, "contasapagar@cclindsa.com" , " " ) 	, "C" )

dbSelectArea("SA2")
dbSetOrder(3)

dbSelectArea("FIG")     		
dbSetOrder(1)

if	( lSE2Excl .and. !lFIGExcl ) .or. ( !lSE2Excl .and. lFIGExcl )
	Alert("O compartilhamento da tabela FIG ้ diferente da tabela SE2. Fa็a o ajuste.")
	Return
endif

if	FIG->(FieldPos("FIG_ZZSEQ")) == 0 .or. FIG->(FieldPos("FIG_ZZARQ")) == 0 .or. FIG->(FieldPos("FIG_ZZJUR")) == 0
	Alert("Rotina desatualizada. Execute o compatibilizador UPDXFIG.")
	Return
endif

if	lW40 == Nil
	FwMsgRun( Nil , { || xChecaVar() } , 'Processando' , "Buscando dados ..." )
endif

if !Empty(xArqAut)
	aAdd( aRetParam , xArqAut )
endif

SetFunName("FINA430")

aAdd( aPergs , { 06 , "Arquivo de DDA" , "" , "" , "" , "" , 090 , .t. , "" , , GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE } )
    	
if	lArqAut .or. ParamBox( aPergs , "Diretorio de Leitura" , @aRetParam , { || .t. } , , lCentered , 0 , 0 , , 'XLERARQEXT' , lCanSave , lUserSave )
	mv_par01 	:=	Alltrim(aRetParam[01]) 
	sArquivo	:=	Upper(mv_par01)
	For s := Len(sArquivo) to 1 Step -1 
		if	Substr(sArquivo,s,01) $ "\:/"  
			cDirectory := Substr(sArquivo,01,s - 1)
			Exit
		endif
		xArquivo := Substr(sArquivo,s,01) + xArquivo
	Next s 	
	fChkNotConc()	
	if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
		lProc	:=	.t.
	else
		lProc	:=	xChecaArq()
	endif
	if	lProc
		xChecaSeq()
		FwMsgRun( Nil , { || aArq := xReadArq(sArquivo,@lArq) } , "Leitura de Arquivo" , "Lendo o arquivo " + Alltrim(sArquivo) )	
		if	lArq
			Processa( { || fa430procs(aArq,@aFIG,@xFIG,@aBXA) } )  
			if	Len(aFIG) > 0 
				if	fProcFIG(aFIG,xFIG,aBXA)
					xMoveArq()
				endif
				fProcEst(aFIG,xFIG,aBXA)
				fProcArq(aFIG,xFIG,aBXA)
			else
				if	lArqAut			
					Alert("Nใo hแ registros a processar para o arquivo " + xArquivo + " informado")
					xMoveArq()
				else
					Alert("Nใo hแ registros a processar para o arquivo informado")
				endif		
			endif
		else
			if	lArqAut			
				Alert("Nใo foi possํvel ler o arquivo " + xArquivo + " informado")    
				xMoveArq()
			else
				Alert("Nใo foi possํvel ler o arquivo informado")
			endif
		endif
	else
		if	lArqAut			
			Alert("Arquivo " + xArquivo + " jแ foi importado")    
			xMoveArq()
		else
			Alert("Arquivo jแ importado")    
		endif		
	endif
endif

SetFunName(xFunName)

RestArea(aAreaSM0)

cFilAnt		:=	xFilAnt
dDataBase 	:= 	xDataBase

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณAlexandre Zapponi   บ Data ณ  01/17/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLeitura de arquivo DDA Itau                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fa430procs(aArq,aFIG,xFIG,aBXA)         

Local s   
Local t
Local w
Local xLin
Local nLin  
Local aCGC
Local cCGC		
Local xCGC	 
Local lCont	
Local cCGCH	 
Local cNome	
Local cData		
Local dData
Local cValor	
Local cJuros   
Local cQuery
Local cCodBar	
Local xCodBar	
Local cTitulo
Local nFilAnt	
Local xFilAnt	
Local xFilTmp	
Local aTitSE2
Local cTitSE2
Local lTitSE2
Local xTitSE2
Local cEspecie     

Local nCodBar	:=	TamSx3("FIG_CODBAR")[1]

Local nFIGTemp	:=	00
Local aFIGTemp	:=	{}

ProcRegua(Len(aArq))

For s := 1 to Len(aArq)
	IncProc()
	if	Len(aArq[s]) >= 240 .and. Len(aArq[s]) <= 242 
		if	Substr(aArq[s],008,001) == "1"     
			xFilAnt	:=	""
			nFilAnt	:=	SM0->(Recno())		
			For	t := 1 to 2 
				xCGC 	:=	Substr(aArq[s],018 + t,014)
				SM0->(dbgotop())
				do while SM0->(!Eof()) .and. Empty(xFilAnt)
					if	Upper(Alltrim(SM0->M0_CGC)) == Upper(Alltrim(xCGC))
						xFilAnt	:= 	Upper(Alltrim(SM0->M0_CODFIL))
						nFilAnt	:=	SM0->(Recno())		
						Exit
					endif
					SM0->(dbskip())
				enddo
				if !Empty(xFilAnt)
					Exit
				endif
			Next t 
			SM0->(dbgoto(nFilAnt))
			xCGC 	:=	Upper(Alltrim(SM0->M0_CGC))
			cFilAnt	:= 	iif( Empty(xFilAnt) , cFilAnt , xFilAnt )     
			xFilAnt	:=	cFilAnt
		elseif	Substr(aArq[s],008,001) == "3"
			if	Substr(aArq[s],014,001) == "G"
				if	Substr(aArq[s],016,002) == "01"

					nLin		:=	000
					xLin		:=	.f.
	            	cCGC		:=	StrZero(Val(Substr(aArq[s],063,015)),14)  
	            	cNome		:=	Substr(aArq[s],078,030)	
	            	cData		:=	Substr(aArq[s],108,008)
	            	cValor		:=	Substr(aArq[s],116,015)
	        		cJuros		:=	Substr(aArq[s],190,015)
					cCodBar		:=	Substr(aArq[s],018,044)
					cTitulo		:=	Alltrim(Substr(aArq[s],148,015))
					cEspecie	:=	Substr(aArq[s],180,002)

					dData		:=	Stuff( Stuff( cData , 5 , 0 , "/" )  , 3 , 0 , "/" )
					dData		:=	CtoD(dData)	

					if	dData < Date()
						Loop
					endif

					if	( s + 1 ) <= Len(aArq) .and. Substr(aArq[s + 1],014,001) == "Y" .and. Substr(aArq[s + 1],018,002) == "03" 
						xLin	:=	.t.
						nLin	:=	( s + 1 )
					elseif	( s + 2 ) <= Len(aArq) .and. Substr(aArq[s + 2],014,001) == "Y" .and. Substr(aArq[s + 2],018,002) == "03" 
						xLin	:=	.t.
						nLin	:=	( s + 2 )
					elseif	( s + 3 ) <= Len(aArq) .and. Substr(aArq[s + 3],014,001) == "Y" .and. Substr(aArq[s + 3],018,002) == "03" 
						xLin	:=	.t.
						nLin	:=	( s + 3 )
					endif

					if	xLin
						For	t := 1 to 2 
							xCGC 	:=	Substr(aArq[nLin],020 + t,014)
							xFilTmp	:=	""
							SM0->(dbgotop())
							do while SM0->(!Eof()) .and. Empty(xFilTmp)
								if	Upper(Alltrim(SM0->M0_CGC)) == Upper(Alltrim(xCGC))
									xFilTmp	:= 	Upper(Alltrim(SM0->M0_CODFIL))
									Exit
								endif
								SM0->(dbskip())
							enddo           
							if !Empty(xFilTmp)
								cFilAnt := xFilTmp
								Exit
							endif
						Next t
					endif

					if ( s + 1 ) <= Len(aArq) .and. Substr(aArq[s + 1],014,001) == "H" 
                		cCGCH	:=	Substr(aArq[s + 1],020,014)                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
					else
						cCGCH	:=	Space(14)
					endif    
					
					if	" " $ cTitulo
						cTitulo	:=	Alltrim(Substr(cTitulo,At(" ",cTitulo) + 1))
					endif

					if !Empty(cCGCH) .and. Val(cCGCH) <> 0
						if !SA2->(dbseek(xFilial("SA2") + cCGCH,.f.))
							SA2->(dbseek(xFilial("SA2") + cCGC ,.f.))
						endif
					else                                  
						SA2->(dbseek(xFilial("SA2") + cCGC,.f.)) 
					endif

					lCont	:=	.t.
					xCodBar	:=	PadR(Alltrim(cCodBar),nCodBar)

					cQuery	:=	" Select * "
					cQuery	+=	" From " + RetSqlName("FIG") 
					cQuery	+=	" Where FIG_CODBAR	= '" + xCodBar	+ "' and " 
					cQuery	+=		" ( FIG_CONCIL  = '1'                or  " 
					cQuery	+=		"   D_E_L_E_T_  = ' '              )     " 
					
					TcQuery ChangeQuery(@cQuery) New Alias "XFIG" 
					
					do while XFIG->(!Eof())
						lCont := .f. 
						XFIG->(dbskip())
					enddo
					
					XFIG->(dbclosearea())
					 
					if !lCont 
						Loop
					endif

					cQuery	:=	" Select * "
					cQuery	+=	" From " + RetSqlName("SE2") 
					cQuery	+=	" Where E2_CODBAR	= '" + xCodBar	+ "' and " 
					cQuery	+=		"   D_E_L_E_T_  = ' '                    " 

					TcQuery ChangeQuery(@cQuery) New Alias "XSE2" 
					
					do while XSE2->(!Eof())
						lCont := .f. 
						XSE2->(dbskip())
					enddo
					
					XSE2->(dbclosearea())
					 
					if !lCont 
						Loop
					endif

					aCGC := {}

					if	SA2->(Eof())
						if 	!Empty(cCGCH) .and. Val(cCGCH) <> 0
							SA2->(dbseek(xFilial("SA2") + Substr(cCGCH,01,08),.t.))									
							do while SA2->(!Eof()) .and. ( SA2->A2_FILIAL + Substr(SA2->A2_CGC,01,08) ) == ( xFilial("SA2") + Substr(cCGCH,01,08) )
								aAdd( aCGC , { SA2->A2_COD , SA2->A2_LOJA , SA2->(Recno()) } )
								SA2->(dbskip())
							enddo    
							if	Len(aCGC) == 1
								SA2->(dbgoto(aCGC[01,03]))
							else								
								PutFileInEof("SA2")							
							endif							
						endif
                    endif
					
					RecLock("FIG",.t.)
						FIG->FIG_FILIAL	:= 	xFilial("FIG")
						FIG->FIG_DATA	:= 	Date()
						FIG->FIG_FORNEC	:= 	SA2->A2_COD
						FIG->FIG_LOJA	:= 	SA2->A2_LOJA
						FIG->FIG_NOMFOR	:= 	iif( SA2->(Eof()) , cNome , SA2->A2_NREDUZ ) 
						FIG->FIG_TITULO	:= 	cTitulo
						FIG->FIG_TIPO	:= 	cEspecie
						FIG->FIG_VENCTO	:= 	dData
						FIG->FIG_VALOR	:= 	Val(cValor) / 100
						FIG->FIG_CONCIL	:= 	"2"
						FIG->FIG_CNPJ	:= 	cCGC
						FIG->FIG_CODBAR	:= 	cCodBar
						FIG->FIG_ZZARQ 	:= 	xArquivo
						FIG->FIG_ZZSEQ 	:= 	xSequencia
						FIG->FIG_ZZJUR	:= 	Val(cJuros) / 100
					MsUnlock("FIG")

					aAdd( aFIGTemp , {	FIG->FIG_FILIAL 	, ;
										++ nFIGTemp 		, ;
										FIG->(Recno()) 		, ;
										.f. 				, ;
										.f. 				, ;
										0 					, ;
										xFilial("SE2")		, ;
										xFilial("SE2")		} )     
					
					SM0->(dbgoto(nFilAnt))
					xCGC 	:=	Upper(Alltrim(SM0->M0_CGC))
					cFilAnt	:=	xFilAnt 

				elseif	Substr(aArq[s],016,002) == "02"
				
					cCodBar	:=	PadR(Alltrim(Substr(aArq[s],018,044)),nCodBar)
	            	cData	:=	Substr(aArq[s],108,008)

					dData	:=	Stuff( Stuff( cData , 5 , 0 , "/" )  , 3 , 0 , "/" )
					dData	:=	CtoD(dData)	

					cQuery	:=	" Select R_E_C_N_O_ RECNOFIG "
					cQuery	+=	" From " + RetSqlName("FIG") 
					cQuery	+=	" Where FIG_CODBAR	= '" + cCodBar	+ "' " 
					
					TcQuery ChangeQuery(@cQuery) New Alias "XFIG" 
					
					do while XFIG->(!Eof())
						FIG->(dbgoto(XFIG->RECNOFIG))
						// Nใo foi conciliado - Apaga imediatamente
						if	Empty(Alltrim(FIG->FIG_DDASE2))
							if	FIG->(FieldPos("FIG_ZZEST")) <> 0 .and. FIG->(FieldPos("FIG_ZZESTA")) <> 0 .and. FIG->(FieldPos("FIG_ZZESTD")) <> 0 
								Reclock("FIG",.f.)
									FIG->FIG_ZZEST	:=	"S"
									FIG->FIG_ZZESTD	:=	Date()
									FIG->FIG_ZZESTA	:=	xArquivo
								MsUnlock("FIG")
							endif
							Reclock("FIG",.f.,.t.)
								FIG->(dbdelete())
							MsUnlock("FIG")
						// Foi conciliado 
						else
							aTitSE2	:= 	{}
							xTitSE2	:= 	""
							lTitSE2	:= 	.f.
							cTitSE2	:= 	Alltrim(FIG->FIG_DDASE2)

							For w := 1 to Len(cTitSE2)
								if	Substr(cTitSE2,w,1) == "|"
									aAdd(aTitSE2,xTitSE2)
									xTitSE2 := ""
								else
									xTitSE2 +=	Substr(cTitSE2,w,1)
								endif
							Next w 

							cQuery	:=	" Select R_E_C_N_O_ RECNOSE2 "										        		
							cQuery	+=	" From " + RetSqlName("SE2") + " SE2 " 							        		
							cQuery	+=	" Where SE2.E2_FILIAL    = '" + aTitSE2[1]		+ "'   and " 	
							cQuery 	+=		"   SE2.E2_PREFIXO   = '" + aTitSE2[2]		+ "'   and "	
							cQuery 	+=		"   SE2.E2_NUM       = '" + aTitSE2[3]		+ "'   and "	
							cQuery 	+=		"   SE2.E2_PARCELA   = '" + aTitSE2[4]		+ "'   and "	
							cQuery 	+=		"   SE2.E2_TIPO      = '" + aTitSE2[5]		+ "'   and "	
							cQuery 	+=		"   SE2.E2_FORNECE   = '" + aTitSE2[6]		+ "'   and "	
							cQuery 	+=		"   SE2.E2_LOJA      = '" + aTitSE2[7]		+ "'   and "	
							cQuery 	+=		"   SE2.E2_CODBAR    = '" + cCodBar			+ "'   and "	
							cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                             "	

							TcQuery ChangeQuery(@cQuery) New Alias "XQRY" 

							// Foi encontrado o tํtulo do vํnculo
							if	XQRY->(!Bof()) .and. XQRY->(!Eof())
								do while XQRY->(!Eof())

									SE2->(dbgoto(XQRY->RECNOSE2))

									// Nใo estแ em border๔ - Limpo os dados no tํtulo
									if	Empty(SE2->E2_NUMBOR) 

										RecLock("SE2",.f.)
										if	SE2->(FieldPos("E2_CODBAR")) <> 0 
											SE2->E2_CODBAR 	:= 	""
										endif
										if	SE2->(FieldPos("E2_CBARRA")) <> 0 
											SE2->E2_CBARRA	:=	""
										endif               
										if	SE2->(FieldPos("E2_ZZLINDG")) <> 0 
											SE2->E2_ZZLINDG	:=	""
										endif
										if	SE2->(FieldPos("E2_LINDIGT")) <> 0 
											SE2->E2_LINDIGT	:= 	""
										endif
										if	SE2->(FieldPos("E2_LINDIG")) <> 0 
											SE2->E2_LINDIG	:= 	""
										endif
										MsUnlock("SE2")

										aAdd( aFIGTemp , { 	FIG->FIG_FILIAL 		, ;
															++ nFIGTemp 			, ;
															FIG->(Recno()) 			, ;
															.t. 					, ;
															.f.             		, ;
															SE2->(Recno()) 			, ;
															SE2->E2_FILIAL			, ;
															SE2->E2_FILORIG		 	} )     

									// Estแ em border๔ 
									else

										aAdd( aFIGTemp , { 	FIG->FIG_FILIAL 		, ;
															++ nFIGTemp 			, ;
															FIG->(Recno()) 			, ;
															.t. 					, ;
															dData >= Date() 		, ;
															SE2->(Recno()) 			, ;
															SE2->E2_FILIAL			, ;
															SE2->E2_FILORIG		 	} )     

									endif
									
									XQRY->(dbskip())
								enddo
							endif
							XQRY->(dbclosearea())							
							FIG->(dbgoto(XFIG->RECNOFIG))
							if	FIG->(FieldPos("FIG_ZZEST")) <> 0 .and. FIG->(FieldPos("FIG_ZZESTA")) <> 0 .and. FIG->(FieldPos("FIG_ZZESTD")) <> 0 
								Reclock("FIG",.f.)
									FIG->FIG_ZZEST	:=	"S"
									FIG->FIG_ZZESTD	:=	Date()
									FIG->FIG_ZZESTA	:=	xArquivo
								MsUnlock("FIG")
							endif
							Reclock("FIG",.f.,.t.)
								FIG->(dbdelete())
							MsUnlock("FIG")
						endif
						XFIG->(dbskip())
					enddo
					XFIG->(dbclosearea())
				endif
			endif
		endif
	endif
Next s 

aFIGTemp := aSort( aFIGTemp ,,, { |x,y| x[01] + StrZero(x[02],10) < y[01] + StrZero(y[02],10) } )

For s := 1 to Len(aFIGTemp)		
	aAdd( aFIG , 	aFIGTemp[s,03] 																									  )
	aAdd( xFIG , { 	aFIGTemp[s,03] 																									, ;
					aFIGTemp[s,04] 																									} )
	aAdd( aBXA , {	aFIGTemp[s,03] 																									, ;
					aFIGTemp[s,05] 																									, ;
					aFIGTemp[s,06] 																									, ;
					iif( !Empty(aFIGTemp[s,01]) , aFIGTemp[s,01] , iif( !Empty(aFIGTemp[s,07]) , aFIGTemp[s,07] , aFIGTemp[s,08]) ) } )
Next s 

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณAlexandre Zapponi   บ Data ณ  01/17/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณLeitura de arquivo DDA Itau                                 บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xReadArq( cFile , lArq , lAlltrim ) 

Local aTmp			:= 	{}
Local cLinha		:= 	''

Default lAlltrim	:=	.f.
 
if	FT_FUSE(cFile) == -1
	lArq := .f.
else
	lArq := .t.  
	FT_FGOTOP() 
	do while !FT_FEOF() 
		cLinha := iif( lAlltrim , Alltrim(FT_FREADLN()) , FT_FREADLN() )
	 	if 	!Empty( cLinha )
	 	    aAdd( aTmp , cLinha )
		endif		  
		FT_FSKIP()   
	enddo
	FT_FUSE()
endif
 
Return( aTmp )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/17/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xProcFIG(aFIG,xFIG,aBXA,lMail,aBrwFIG,aBrwTit,xBrwTit) ; Return ( fProcFIG(@aFIG,@xFIG,@aBXA,@lMail,@aBrwFIG,@aBrwTit,@xBrwTit) )

Static Function fProcFIG(aFIG,xFIG,aBXA,lMail,aBrwFIG,aBrwTit,xBrwTit)

Local oDlg
Local cEsq
Local cDir
Local oObj1
Local oObj2
Local oObj3
Local oObj4
Local oTela  
Local oPanelD
Local oPanelE    
Local oBrwFIG
Local oBrwTit
Local oBtnEmp
Local oPanelEG    
Local oPanelDG
Local oFWLayerD    
Local oFWLayerE    
                   
Local lOk				:=	.f.

Local alDms 			:=	FwGetDialogSize(oMainWnd)

Local oOk       		:=	LoadBitmap( GetResources() 	, "LBOK" 				)
Local oNo       		:=	LoadBitmap( GetResources() 	, "LBNO" 				)

Local oEM      			:=	LoadBitmap( GetResources()	, "XBDOWN"				)
Local oVD      			:=	LoadBitmap( GetResources()	, "ENABLE"				)
Local oVM      			:=	LoadBitmap( GetResources()	, "DISABLE"				)
Local oAZ      			:=	LoadBitmap( GetResources()	, "BR_AZUL"				)
Local oPT      			:=	LoadBitmap( GetResources()	, "BR_PRETO"			)
Local oAM      			:=	LoadBitmap( GetResources()	, "BR_AMARELO"			)
Local oSD  	    		:=	LoadBitmap( GetResources()	, "XMETAS_BAIXO_15"		)

Default lMail 			:=	.f. 
Default aBrwFIG			:=	{}
Default aBrwTit			:=	{}    
Default xBrwTit			:=	{}    

Private oProcess		:=	Nil

oProcess := MsNewProcess():New( { |oObj| CursorWait() , xExec( @oObj , @aFIG , @aBrwFIG , @xBrwTit , @xFIG , @aBXA , lMail ) , CursorArrow() } , "Processando" , "Buscando dados ..." , .t. )
oProcess:Activate() 

oDlg := MsDialog():New(alDms[1],alDms[2],alDms[3],alDms[4],"Concilia็ใo DDA",,,,nOr(WS_VISIBLE,WS_POPUP),,,,oMainWnd,.t.)

oDlg:lMaximized := 	.t.
oDlg:lEscClose 	:= 	.f.

oTela 	:= 	FwFormContainer():New( oDlg )

cEsq	:= 	oTela:CreateHorilontalBox( 65 )
cDir  	:= 	oTela:CreateHorilontalBox( 35 )

oTela:Activate( oDlg , .f. )

// Painel Esquerdo

oPanelEG  	:= 	oTela:GetPanel( cEsq )

oFWLayerE	:=	FwLayer():New()

oFWLayerE:Init(oPanelEG,.t.)

oFWLayerE:AddCollumn('Col01',100,.f.)
oFWLayerE:AddWindow('Col01','Win01',"Importados",100,.f.,.t.,/*{ || }*/,,/*{ || }*/)

oPanelE 	:= 	oFWLayerE:GetWinPanel('Col01','Win01')

oPanelE:FreeChildren()

oBrwFIG		:= 	TcBrowse():New(015,015,015,015,,,,oPanelE,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)
if	lMail
	oBrwFIG:AddColumn( TcColumn():New( ""     		,{ || iif( aBrwFIG[oBrwFIG:nAt,01] , oOk , oNo )						}	, "@!"          				,,,"CENTER" ,020,.t.,.f.,,,,.f.,) )     						
else 
	oBrwFIG:AddColumn( TcColumn():New( ""     		,{ || RetCores(aBrwFIG,oBrwFIG,oAZ,oVD,oVM,oAM,oPT,xFIG,aBXA,oSD,oEM)	}	, "@!"          				,,,"CENTER" ,020,.t.,.f.,,,,.f.,) )     						
endif 
oBrwFIG:AddColumn( TcColumn():New( "Filial"			,{ || aBrwFIG[oBrwFIG:nAt,02] 											}	, PesqPict("SE2","E2_FILIAL")	,,,"CENTER"	,030,.f.,.f.,,,,.f.,) )
oBrwFIG:AddColumn( TcColumn():New( "Numero"    		,{ || aBrwFIG[oBrwFIG:nAt,03] 											}	, PesqPict("SE2","E2_NUM")		,,,"LEFT"	,040,.f.,.f.,,,,.f.,) )
oBrwFIG:AddColumn( TcColumn():New( "Fornecedor"    	,{ || aBrwFIG[oBrwFIG:nAt,04] 											}	, PesqPict("SE2","E2_FORNECE")	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oBrwFIG:AddColumn( TcColumn():New( "Loja"			,{ || aBrwFIG[oBrwFIG:nAt,05] 											}	, PesqPict("SE2","E2_LOJA")		,,,"CENTER"	,030,.f.,.f.,,,,.f.,) )
oBrwFIG:AddColumn( TcColumn():New( "Nome" 			,{ || aBrwFIG[oBrwFIG:nAt,06] 											}	, PesqPict("SE2","E2_NOMFOR")	,,,"LEFT"	,150,.f.,.f.,,,,.f.,) )
oBrwFIG:AddColumn( TcColumn():New( "Vencto"			,{ || aBrwFIG[oBrwFIG:nAt,07] 											}	, PesqPict("SE2","E2_VENCTO")	,,,"CENTER"	,055,.f.,.f.,,,,.f.,) )
oBrwFIG:AddColumn( TcColumn():New( "Valor"			,{ || aBrwFIG[oBrwFIG:nAt,08] 											}	, PesqPict("SE2","E2_VALOR")	,,,"RIGHT"	,075,.f.,.f.,,,,.f.,) )
oBrwFIG:AddColumn( TcColumn():New( "Cod. de Barras"	,{ || aBrwFIG[oBrwFIG:nAt,09] 											}	, "@!"                        	,,,"CENTER"	,165,.f.,.f.,,,,.f.,) )
oBrwFIG:AddColumn( TcColumn():New( "Banco Emissor"	,{ || aBrwFIG[oBrwFIG:nAt,10] 											}	, "@!"                        	,,,"LEFT"	,100,.f.,.f.,,,,.f.,) )

oBrwFIG:SetArray(aBrwFIG)          

oBrwFIG:Align			:=	CONTROL_ALIGN_ALLCLIENT
oBrwFIG:bChange			:= 	{ || fChange( oBrwFIG , aBrwFIG , @oBrwTit , @aBrwTit , xBrwTit ) 	}
if	lMail
	oBrwFIG:bLDblClick	:=	{ || aBrwFIG[oBrwFIG:nAt,01] := !aBrwFIG[oBrwFIG:nAt,01] 			}
endif 

// Painel Direito

oPanelDG 	:= 	oTela:GetPanel( cDir )

oFWLayerD	:=	FwLayer():New()

oFWLayerD:Init(oPanelDG,.t.)

oFWLayerD:AddCollumn('Col01',100,.f.)
oFWLayerD:AddWindow('Col01','Win01',"Tํtulos",100,.f.,.t.,/*{ || }*/,,/*{ || }*/)

oPanelD 	:= 	oFWLayerD:GetWinPanel('Col01','Win01')

oPanelD:FreeChildren()

oBrwTit		:= 	TcBrowse():New(015,015,015,015,,,,oPanelD,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)

if !lMail
	oBrwTit:AddColumn( TcColumn():New( ""     		,{ || iif( aBrwTit[oBrwTit:nAt,02] , oOk , oNo ) 	}	, "@!"          				,,,"CENTER" ,020,.t.,.f.,,,,.f.,) )     						
endif 
oBrwTit:AddColumn( TcColumn():New( "Filial"			,{ || aBrwTit[oBrwTit:nAt,03] 						}	, PesqPict("SE2","E2_FILIAL")	,,,"CENTER"	,030,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Prefixo"   		,{ || aBrwTit[oBrwTit:nAt,04] 						}	, PesqPict("SE2","E2_PREFIXO")	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Numero"    		,{ || aBrwTit[oBrwTit:nAt,05] 						}	, PesqPict("SE2","E2_NUM")		,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Parcela"   		,{ || aBrwTit[oBrwTit:nAt,06] 						}	, PesqPict("SE2","E2_PARCELA")	,,,"CENTER"	,030,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Tipo"      		,{ || aBrwTit[oBrwTit:nAt,07] 						}	, PesqPict("SE2","E2_TIPO")		,,,"CENTER"	,030,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Fornecedor"    	,{ || aBrwTit[oBrwTit:nAt,08] 						}	, PesqPict("SE2","E2_FORNECE")	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Loja"			,{ || aBrwTit[oBrwTit:nAt,09] 						}	, PesqPict("SE2","E2_LOJA")		,,,"CENTER"	,030,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Nome" 			,{ || aBrwTit[oBrwTit:nAt,10] 						}	, PesqPict("SE2","E2_NOMFOR")	,,,"LEFT"	,135,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Vencto"			,{ || aBrwTit[oBrwTit:nAt,11] 						}	, PesqPict("SE2","E2_VENCTO")	,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Valor"			,{ || aBrwTit[oBrwTit:nAt,12] 						}	, PesqPict("SE2","E2_VALOR")	,,,"RIGHT"	,050,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "PIS"			,{ || aBrwTit[oBrwTit:nAt,15] 						}	, PesqPict("SE2","E2_VALOR")	,,,"RIGHT"	,050,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Cofins"			,{ || aBrwTit[oBrwTit:nAt,16] 						}	, PesqPict("SE2","E2_VALOR")	,,,"RIGHT"	,050,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "CSLL"			,{ || aBrwTit[oBrwTit:nAt,17] 						}	, PesqPict("SE2","E2_VALOR")	,,,"RIGHT"	,050,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Acr/Dec"		,{ || aBrwTit[oBrwTit:nAt,20] 						}	, PesqPict("SE2","E2_VALOR")	,,,"RIGHT"	,050,.f.,.f.,,,,.f.,) )
oBrwTit:AddColumn( TcColumn():New( "Saldo"			,{ || aBrwTit[oBrwTit:nAt,18] 						}	, PesqPict("SE2","E2_VALOR")	,,,"RIGHT"	,050,.f.,.f.,,,,.f.,) )

oBrwTit:SetArray(aBrwTit)          

oBrwTit:Align			:=	CONTROL_ALIGN_ALLCLIENT

if !lMail
	oBrwTit:bChange		:= 	{ || .t. }
	oBrwTit:bLDblClick	:= 	{ || iif( oBrwTit:nColPos == 10 , xMudaVcto(@aBrwTit,@oBrwTit,@aBrwFIG,@oBrwFIG,@xBrwTit) , fMark(@oBrwTit,@aBrwTit,@xBrwTit,@oBrwFIG,@aBrwFIG) ) }
endif 

oBtnEmp	:=	FwButtonBar():New()		

oBtnEmp:Init( oPanelD , 015 , 015 , CONTROL_ALIGN_BOTTOM , .t. )

if	lMail
	oObj1 := oBtnEmp:AddBtnImage( "stop.png" 		, "Sair" 			, { || oDlg:End() 																													}	, { || .t.  } 	, .t. 	, CONTROL_ALIGN_RIGHT  	,		)        
	oObj2 := oBtnEmp:AddBtnImage( "bmppost" 		, "E-mail" 			, { || oDlg:End() , lOk := .t. 																										} 	, { || .t.  } 	, .t. 	, CONTROL_ALIGN_RIGHT	,		) 
else
	oObj1 := oBtnEmp:AddBtnImage( "stop.png" 		, "Sair" 			, { || oDlg:End() 																													}	, { || .t.  } 	, .t. 	, CONTROL_ALIGN_RIGHT  	,		)        
	oObj2 := oBtnEmp:AddBtnImage( "success.png" 	, "Gravar" 			, { || iif( fGravar( oBrwFIG , aBrwFIG , oBrwTit , aBrwTit , xBrwTit ) , lOk := .t. , lOk := .f. ) , iif( lOk , oDlg:End() , Nil )	} 	, { || .t.  } 	, .t. 	, CONTROL_ALIGN_RIGHT	,		) 
	oObj3 := oBtnEmp:AddBtnText(  "Adicionar"  		, "Adicionar"		, { || fAdicio( @oBrwFIG , @aBrwFIG , @oBrwTit , @aBrwTit , @xBrwTit )																} 	,			 	,		, CONTROL_ALIGN_LEFT 	, .t. 	)
	oObj4 := oBtnEmp:AddBtnText(  "Outra Filial"  	, "Outra Filial"	, { || xAdicio( @oBrwFIG , @aBrwFIG , @oBrwTit , @aBrwTit , @xBrwTit )																} 	,			 	,		, CONTROL_ALIGN_LEFT 	, .t. 	)

	oObj3:SetCss( CSSBOTAZ )
	oObj4:SetCss( CSSBOTVD )
endif 

oDlg:Activate(Nil,Nil,Nil,.t.)

Return ( lOk )             

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/17/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xExec( oObj , aFIG , aBrwFIG , xBrwTit , xFIG , aBXA , lMail )

Local s     
Local t
Local lOk	                  
Local nPos   
Local xCod
Local nCGC	
Local xCGC	
Local xData1 
Local xData2 
Local cQuery	 
Local nValIni
Local nValFim

Local aAlt				:=	{}
Local xObj				:= 	GeneralClass():New()
Local aStruct			:=	SE2->(dbstruct())

Local cCPNEG			:=	MV_CPNEG
Local nTamCod   		:= 	TamSx3("A2_COD")[1]
Local nTamLoja  		:= 	TamSx3("A2_LOJA")[1]
Local nTamIdCnab		:= 	TamSx3("E2_IDCNAB")[1]
Local nTamCodBar		:= 	TamSx3("E2_CODBAR")[1]       

Local xPerc				:=	SuperGetMv("ZZ_DDAPERC",.f.,10) / 100 
Local lRaiz				:=	Upper(Alltrim(SuperGetMv("ZZ_BSCRAIZ",.f.,"S"))) == "S"     

Local lSql   			:=	"MSSQL" $ Upper(Alltrim(TcGetDB()))

Default lMail			:=	.f.

if 	"|" $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,"|","")
elseif "," $ cCPNEG
	cCPNEG	:=	StrTran(MV_CPNEG,",","")
endif

if 	Mod(Len(cCPNEG),3) > 0
	cCPNEG	+=	Replicate(" ",3-Mod(Len(cCPNEG),3))
endif

// Campo para tratar cobran็a por empresa centralizadora. Mesmo tamanho do A2_CGC

if	SA2->(FieldPos("A2_XCGCDDA")) <> 0

	cQuery	:=	" Select A2_FILIAL , A2_CGC , A2_XCGCDDA "
	cQuery	+=	" From " + RetSqlName("SA2")
	cQuery	+=	" Where A2_FILIAL   >= '" + Replicate(" ",FwSizeFilial())	+ "' and " 
	cQuery	+=		"   A2_FILIAL   <= '" + Replicate("Z",FwSizeFilial())	+ "' and " 
	cQuery	+=		"   A2_XCGCDDA  <> '" + CriaVar("A2_XCGCDDA",.f.)		+ "' and " 
	cQuery	+=		"   D_E_L_E_T_   = ' '                                           "
	
	TcQuery ChangeQuery(@cQuery) New Alias "XSA2"
	
	do while XSA2->(!Eof())
		aAdd( aAlt , { XSA2->A2_FILIAL , XSA2->A2_CGC , XSA2->A2_XCGCDDA } )
		XSA2->(dbskip())
	enddo
	
	XSA2->(dbclosearea())

endif

oProcess:SetRegua1(Len(aFIG))

For s := 1 to Len(aFIG)     

	oProcess:IncRegua1( "Tํtulo " + StrZero(s,04) + " de " + StrZero(Len(aFIG),04) )

	FIG->(dbgoto(aFIG[s]))   

	if	aScan( aBrwFIG , { |x| x[09] == FIG->FIG_CODBAR } ) <> 0 
		Loop
	endif
	
	nCGC	:=	0
	xCGC	:=	""
	xData1	:=	FIG->FIG_VENCTO
	xData2	:=	DataValida(FIG->FIG_VENCTO)

	cQuery	:=	" Select A2_COD , A2_LOJA "
	cQuery	+=	" From " + RetSqlName("SA2")
	cQuery	+=	" Where A2_FILIAL  = '" + xFilial("SA2") 						+ "'  and " 
	if	lRaiz 
		cQuery	+=	"   A2_CGC LIKE  '" + Alltrim(Substr(FIG->FIG_CNPJ,01,08)) 	+ "%' and "
	else
		cQuery	+=	"   A2_CGC     = '" + Alltrim(FIG->FIG_CNPJ) 				+ "'  and "
	endif
	cQuery	+=		"   D_E_L_E_T_ = ' '                                                  "

	TcQuery ChangeQuery(@cQuery) New Alias "XQRY" 
	
	do while XQRY->(!Eof())
		nCGC ++
		if	lSql
			xCGC += iif( Empty(xCGC) , "" , "or" ) + " E2_FORNECE +  E2_LOJA = '" + XQRY->A2_COD + XQRY->A2_LOJA + "' " 
		else
			xCGC += iif( Empty(xCGC) , "" , "or" ) + " E2_FORNECE || E2_LOJA = '" + XQRY->A2_COD + XQRY->A2_LOJA + "' " 
		endif	
		XQRY->(dbskip())
	enddo
	
	XQRY->(dbclosearea())

	if Empty(xCGC)
		if	lSql
			xCGC += " E2_FORNECE +  E2_LOJA = '" + Replicate("Y",nTamCod + nTamLoja) + "' and " 
		else
			xCGC += " E2_FORNECE || E2_LOJA = '" + Replicate("Y",nTamCod + nTamLoja) + "' and " 
		endif	
	else
		if	nCGC > 1		
			xCGC := " ( " + xCGC + " ) and "
		else
			xCGC += " and "
		endif
	endif	

	cFilAnt	:= 	FIG->FIG_FILIAL

	aAdd( aBrwFIG , { 	.f. 													, ; 	// 01
						FIG->FIG_FILIAL 										, ;		// 02
						FIG->FIG_TITULO 										, ;		// 03
						FIG->FIG_FORNEC 										, ;		// 04
						FIG->FIG_LOJA 											, ;		// 05
						FIG->FIG_NOMFOR 										, ;		// 06
						FIG->FIG_VENCTO 										, ;		// 07
						FIG->FIG_VALOR 											, ; 	// 08
						FIG->FIG_CODBAR 										, ;		// 09
						Upper(xObj:NomeBanco(Substr(FIG->FIG_CODBAR,01,03)))	, ;		// 10
						000                                                 	, ;		// 11
						FIG->(Recno())                                      	} )		// 12

	lOk		:=	.f.     
	nValIni	:=	Round( FIG->FIG_VALOR * ( 1 - xPerc ) , 02 )
	nValFim	:=	Round( FIG->FIG_VALOR * ( 1 + xPerc ) , 02 )

	// Verifico se tem CNPJ alternativo de cobran็a

	xCod	:=	""
	nPos	:=	aScan( aAlt , { |x| x[01] == cFilAnt .and. x[03] == FIG->FIG_CNPJ } )   
	
	if	nPos > 0
		For t := 1 to Len(aAlt)	
			if	aAlt[t,01] == cFilAnt .and. aAlt[t,03] == FIG->FIG_CNPJ	
				xCod += iif( Len(xCod) == 0 , "" , "," ) + "'" + aAlt[t,02] + "'"   	
			endif
		Next t 
	endif	

	//Codigo de Barras Identificado

	oProcess:SetRegua2(5)

	oProcess:IncRegua2()

	cQuery	:=	" Select '0' TIPO , SE2.* "											        		+ CRLF	
	cQuery	+=	" From " + RetSqlName("SE2") + " SE2   " 							        		+ CRLF	
	cQuery	+=	" Where SE2.E2_CODBAR    = '" + PadR(FIG->FIG_CODBAR,nTamCodBar)	+ "'    and "	+ CRLF	
	cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                                                 "	+ CRLF	

	if	xGravaArray(@xBrwTit,@aBrwFIG,@cQuery,@aStruct,0,Nil,Nil,lMail)
		RecLock("FIG",.f.,.t.)
			FIG->(dbdelete())
		MsUnlock("FIG")
		Loop
	endif

	// valor igual e vencimento igual 
                                      
	oProcess:IncRegua2()

	cQuery 	:= 	""
    
	if !Empty(FIG->FIG_FORNEC)

		cQuery	+=	" Select '1' TIPO , SE2.* "												    	+ CRLF	
		cQuery	+=	" From " + RetSqlName("SE2") + " SE2 "								     		+ CRLF	
		cQuery	+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
		cQuery 	+=		"   SE2.E2_FORNECE   = '" + FIG->FIG_FORNEC					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_LOJA      = '" + FIG->FIG_LOJA  					+ "'   and "	+ CRLF	
		cQuery 	+=		" ( SE2.E2_VENCTO    = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA   = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO    = '" + DtoS(xData2) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA   = '" + DtoS(xData2) 					+ "' ) and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     =  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
		cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

		cQuery	+=	" Union All " 																	+ CRLF	

	endif

	cQuery		+=	" Select '1' TIPO , SE2.* "														+ CRLF	
	cQuery		+=	" From " + RetSqlName("SE2") + " SE2 "											+ CRLF	
	cQuery		+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
	cQuery		+=		xCGC	 																	+ CRLF	
	cQuery 		+=		" ( SE2.E2_VENCTO    = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCREA   = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCTO    = '" + DtoS(xData2) 					+ "'   or  "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCREA   = '" + DtoS(xData2) 					+ "' ) and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VALOR     =  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
	cQuery 		+=		"   SE2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

	if !Empty(xCod)

		cQuery	+=	" Union All " 																	+ CRLF	

		cQuery	+=	" Select '1' TIPO , SE2.* "														+ CRLF	
		cQuery	+=	" From " + RetSqlName("SA2") + " SA2 , " 										+ CRLF	
		cQuery	+=	"      " + RetSqlName("SE2") + " SE2   "										+ CRLF	
		cQuery	+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
		cQuery 	+=		"   SE2.E2_FORNECE   = SA2.A2_COD                                  and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_LOJA      = SA2.A2_LOJA                                 and "	+ CRLF	
		cQuery 	+=		" ( SE2.E2_VENCTO    = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA   = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO    = '" + DtoS(xData2) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA   = '" + DtoS(xData2) 					+ "' ) and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     =  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
		cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                                         and "	+ CRLF	
		cQuery	+=		"   SA2.A2_FILIAL    = '" + xFilial("SA2")					+ "'   and " 	+ CRLF	
		cQuery	+=		"   SA2.A2_CGC IN    (  " + xCod	 						+ " )  and " 	+ CRLF	
		cQuery	+=		"   SA2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

	endif

	if	xGravaArray(@xBrwTit,@aBrwFIG,@cQuery,@aStruct,1,Nil,Nil,lMail)
		Loop
	endif
	
	// valor igual e vencimento diferente

	oProcess:IncRegua2()

	cQuery 	:= 	""

	if !Empty(FIG->FIG_FORNEC)    
	
		cQuery	+=	" Select '2' TIPO , SE2.* "												    	+ CRLF	
		cQuery	+=	" From " + RetSqlName("SE2") + " SE2 " 									    	+ CRLF	
		cQuery	+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
		cQuery 	+=		"   SE2.E2_FORNECE   = '" + FIG->FIG_FORNEC					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_LOJA      = '" + FIG->FIG_LOJA  					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     =  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
		cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

		cQuery	+=	" Union All " 																	+ CRLF	

	endif

	cQuery		+=	" Select '2' TIPO , SE2.* "														+ CRLF	
	cQuery		+=	" From " + RetSqlName("SE2") + " SE2 "											+ CRLF	
	cQuery		+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
	cQuery		+=		xCGC	 																	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VALOR     =  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
	cQuery 		+=		"   SE2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

	if !Empty(xCod)

		cQuery	+=	" Union All " 																	+ CRLF	

		cQuery	+=	" Select '2' TIPO , SE2.* "														+ CRLF	
		cQuery	+=	" From " + RetSqlName("SA2") + " SA2 , " 										+ CRLF	
		cQuery	+=	"      " + RetSqlName("SE2") + " SE2   "										+ CRLF	
		cQuery	+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
		cQuery 	+=		"   SE2.E2_FORNECE   = SA2.A2_COD                                  and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_LOJA      = SA2.A2_LOJA                                 and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     =  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
		cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                                         and "	+ CRLF	
		cQuery	+=		"   SA2.A2_FILIAL    = '" + xFilial("SA2")					+ "'   and " 	+ CRLF	
		cQuery	+=		"   SA2.A2_CGC IN    (  " + xCod	 						+ " )  and " 	+ CRLF	
		cQuery	+=		"   SA2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

	endif

	xGravaArray(@xBrwTit,@aBrwFIG,@cQuery,@aStruct,2,Nil,Nil,lMail)

	// vencimento igual e valor diferente

	oProcess:IncRegua2()

	cQuery 	:= 	""

	if !Empty(FIG->FIG_FORNEC)

		cQuery	+=	" Select '3' TIPO , SE2.* "						  						    	+ CRLF	
		cQuery	+=	" From " + RetSqlName("SE2") + " SE2 "								     		+ CRLF	
		cQuery	+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
		cQuery 	+=		"   SE2.E2_FORNECE   = '" + FIG->FIG_FORNEC					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_LOJA      = '" + FIG->FIG_LOJA  					+ "'   and "	+ CRLF	
		cQuery 	+=		" ( SE2.E2_VENCTO    = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA   = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO    = '" + DtoS(xData2) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA   = '" + DtoS(xData2) 					+ "' ) and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR    <>  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     >  " + Alltrim(Str(nValIni))			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     <  " + Alltrim(Str(nValFim))			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
		cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

		cQuery	+=	" Union All " 																	+ CRLF	

	endif

	cQuery		+=	" Select '3' TIPO , SE2.* "														+ CRLF	
	cQuery		+=	" From " + RetSqlName("SE2") + " SE2 "											+ CRLF	
	cQuery		+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
	cQuery		+=		xCGC	 																	+ CRLF	
	cQuery 		+=		" ( SE2.E2_VENCTO    = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCREA   = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCTO    = '" + DtoS(xData2) 					+ "'   or  "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCREA   = '" + DtoS(xData2) 					+ "' ) and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VALOR    <>  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VALOR     >  " + Alltrim(Str(nValIni))			+ "    and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VALOR     <  " + Alltrim(Str(nValFim))			+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
	cQuery 		+=		"   SE2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

	if !Empty(xCod)

		cQuery	+=	" Union All " 																	+ CRLF	

		cQuery	+=	" Select '3' TIPO , SE2.* "														+ CRLF	
		cQuery	+=	" From " + RetSqlName("SA2") + " SA2 , " 										+ CRLF	
		cQuery	+=	"      " + RetSqlName("SE2") + " SE2   "										+ CRLF	
		cQuery	+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
		cQuery 	+=		"   SE2.E2_FORNECE   = SA2.A2_COD                                  and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_LOJA      = SA2.A2_LOJA                                 and "	+ CRLF	
		cQuery 	+=		" ( SE2.E2_VENCTO    = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA   = '" + DtoS(xData1) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO    = '" + DtoS(xData2) 					+ "'   or  "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA   = '" + DtoS(xData2) 					+ "' ) and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR    <>  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     >  " + Alltrim(Str(nValIni))			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     <  " + Alltrim(Str(nValFim))			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
		cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                                         and "	+ CRLF	
		cQuery	+=		"   SA2.A2_FILIAL    = '" + xFilial("SA2")					+ "'   and " 	+ CRLF	
		cQuery	+=		"   SA2.A2_CGC IN    (  " + xCod	 						+ " )  and " 	+ CRLF	
		cQuery	+=		"   SA2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

	endif

	xGravaArray(@xBrwTit,@aBrwFIG,@cQuery,@aStruct,3,Nil,Nil,lMail)
	
	// vencimento diferente e valor diferente

	oProcess:IncRegua2()

	cQuery 	:= 	""

	if !Empty(FIG->FIG_FORNEC)

		cQuery	+=	" Select '4' TIPO , SE2.* "												    	+ CRLF	
		cQuery	+=	" From " + RetSqlName("SE2") + " SE2 "								     		+ CRLF	
		cQuery	+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
		cQuery 	+=		"   SE2.E2_FORNECE   = '" + FIG->FIG_FORNEC					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_LOJA      = '" + FIG->FIG_LOJA  					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR    <>  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     >  " + Alltrim(Str(nValIni))			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     <  " + Alltrim(Str(nValFim))			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
		cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

		cQuery	+=	" Union All " 																	+ CRLF	

	endif

	cQuery		+=	" Select '4' TIPO , SE2.* "														+ CRLF	
	cQuery		+=	" From " + RetSqlName("SE2") + " SE2 "											+ CRLF	
	cQuery		+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
	cQuery		+=		xCGC	 																	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VALOR    <>  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VALOR     >  " + Alltrim(Str(nValIni))			+ "    and "	+ CRLF	
	cQuery 		+=		"   SE2.E2_VALOR     <  " + Alltrim(Str(nValFim))			+ "    and "	+ CRLF	
	cQuery 		+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
	cQuery 		+=		"   SE2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

	if !Empty(xCod)

		cQuery	+=	" Union All " 																	+ CRLF	

		cQuery	+=	" Select '4' TIPO , SE2.* "														+ CRLF	
		cQuery	+=	" From " + RetSqlName("SA2") + " SA2 , " 										+ CRLF	
		cQuery	+=	"      " + RetSqlName("SE2") + " SE2   "										+ CRLF	
		cQuery	+=	" Where SE2.E2_FILIAL    = '" + xFilial("SE2")					+ "'   and " 	+ CRLF	
		cQuery 	+=		"   SE2.E2_FORNECE   = SA2.A2_COD                                  and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_LOJA      = SA2.A2_LOJA                                 and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData1) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCTO   <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VENCREA  <> '" + DtoS(xData2) 					+ "'   and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVABATIM,'|') 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVTAXA,,3) 			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_TIPO NOT IN  " + FormatIn(MVPROVIS,,3) 			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_CODBAR    = '" + Space(nTamCodbar) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_IDCNAB    = '" + Space(nTamIdCnab) 				+ "'   and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR    <>  " + Alltrim(Str(FIG->FIG_VALOR))	+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     >  " + Alltrim(Str(nValIni))			+ "    and "	+ CRLF	
		cQuery 	+=		"   SE2.E2_VALOR     <  " + Alltrim(Str(nValFim))			+ "    and "	+ CRLF	
		cQuery 	+= 		"   SE2.E2_SALDO     > 0                                           and "	+ CRLF	
		cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                                         and "	+ CRLF	
		cQuery	+=		"   SA2.A2_FILIAL    = '" + xFilial("SA2")					+ "'   and " 	+ CRLF	
		cQuery	+=		"   SA2.A2_CGC IN    (  " + xCod	 						+ " )  and " 	+ CRLF	
		cQuery	+=		"   SA2.D_E_L_E_T_   = ' '                                             "	+ CRLF	

	endif

	xGravaArray(@xBrwTit,@aBrwFIG,@cQuery,@aStruct,4,Nil,Nil,lMail)
	
Next s        

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function RetCores(aBrwFIG,oBrwFIG,oAZ,oVD,oVM,oAM,oPT,xFIG,aBXA,oSD,oEM)

Local nRec 		:=	aBrwFIG[oBrwFIG:nAt,12]	
Local nPos		:=	aScan( xFIG , { |x| x[01] == nRec })
Local xPos		:=	aScan( aBXA , { |x| x[01] == nRec })

if	nPos <> 0 .and. xFIG[nPos,02] .and. xPos <> 0 .and. aBXA[xPos,02]
	Return ( oEM )
elseif	nPos <> 0 .and. xFIG[nPos,02] 
	Return ( oSD )
elseif	aBrwFIG[oBrwFIG:nAt,11] == -1 
	Return ( oPT ) 
elseif	aBrwFIG[oBrwFIG:nAt,11] == 0 
	Return ( oVM ) 
elseif	aBrwFIG[oBrwFIG:nAt,11] == 1 .and. aBrwFIG[oBrwFIG:nAt,01] 
	Return ( oVD ) 
elseif	aBrwFIG[oBrwFIG:nAt,11] == 1 
	Return ( oAM ) 
elseif	aBrwFIG[oBrwFIG:nAt,11] >= 2 .and. aBrwFIG[oBrwFIG:nAt,01]
	Return ( oAZ ) 
elseif	aBrwFIG[oBrwFIG:nAt,11] >= 2 
	Return ( oAM ) 
endif	
		
Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/17/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fChange( oBrwFIG , aBrwFIG , oBrwTit , aBrwTit , xBrwTit )

Local s
Local t

aBrwTit := {}

For s := 1 to Len(xBrwTit)
	if	xBrwTit[s,01] == oBrwFIG:nAt	
		aAdd( aBrwTit , Array(Len(xBrwTit[s])) )
		For t := 1 to Len(xBrwTit[s])
			aBrwTit[Len(aBrwTit),t] := xBrwTit[s,t]
		Next t
	endif
Next s 

oBrwTit:SetArray(aBrwTit)          
oBrwTit:Refresh()          

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMark(oBrwTit,aBrwTit,xBrwTit,oBrwFIG,aBrwFIG)

Local s
Local t           
Local lOne			:=	.f.
Local lMark			:=	aBrwTit[oBrwTit:nAt,02]    
Local lKeepVct		:=	SuperGetMv("ZZ_KEEPVCT",.f.,"S") == "S"

if	aBrwTit[oBrwTit:nAt,13] == 0
	Alert("O c๓digo de barras jแ estแ informado")
	Return
endif

For t := 1 to Len(aBrwTit)                
	aBrwTit[t,02] := .f.
	For s := 1 to Len(xBrwTit)
		if	xBrwTit[s,14] == aBrwTit[t,14] 
			xBrwTit[s,02] := aBrwTit[t,02] 
		endif
	Next s 
Next t 
	
aBrwTit[oBrwTit:nAt,02]	:=	!lMark

if	aBrwTit[oBrwTit:nAt,02]	
	if	aBrwFIG[oBrwFIG:nAt,08] <> aBrwTit[oBrwTit:nAt,18]  
		if	MsgYesNo("Diferen็as entre valores serใo lan็adas em acr้scimo/decr้scimo." + CRLF + "Confirma ?")
			aBrwTit[oBrwTit:nAt,20]	:=	aBrwFIG[oBrwFIG:nAt,08] - aBrwTit[oBrwTit:nAt,18]  	
			aBrwTit[oBrwTit:nAt,18]	+=	aBrwTit[oBrwTit:nAt,20]
		else
			aBrwTit[oBrwTit:nAt,02]	:=	.f.
		endif
	endif  
	if	DataValida(aBrwFIG[oBrwFIG:nAt,07]) < DataValida(aBrwTit[oBrwTit:nAt,11]) .or. ( DataValida(aBrwFIG[oBrwFIG:nAt,07]) > DataValida(aBrwTit[oBrwTit:nAt,11]) .and. !lKeepVct )
		if 	MsgYesNo("Diferen็as entre vencimentos serใo lan็adas no tํtulo." + CRLF + "Confirma ?")
			aBrwTit[oBrwTit:nAt,21]	:=	aBrwFIG[oBrwFIG:nAt,07]
		else
			aBrwTit[oBrwTit:nAt,02]	:=	.f.
		endif
	endif  
else	
	aBrwTit[oBrwTit:nAt,18]	-=	aBrwTit[oBrwTit:nAt,20]
	aBrwTit[oBrwTit:nAt,20]	:=	0
	aBrwTit[oBrwTit:nAt,21]	:=	CtoD("")
endif

For s := 1 to Len(xBrwTit)
	if	xBrwTit[s,14] == aBrwTit[oBrwTit:nAt,14] 
		xBrwTit[s,02] := aBrwTit[oBrwTit:nAt,02] 
		xBrwTit[s,18] := aBrwTit[oBrwTit:nAt,18] 
		xBrwTit[s,20] := aBrwTit[oBrwTit:nAt,20] 
		xBrwTit[s,21] := aBrwTit[oBrwTit:nAt,21] 
	endif
Next s 

For t := 1 to Len(aBrwTit)                
	if	aBrwTit[t,02]
		lOne := .t.
	endif
Next t 

if	aBrwFIG[oBrwFIG:nAt,11] >= 1 
	aBrwFIG[oBrwFIG:nAt,01] := aBrwTit[oBrwTit:nAt,02]
endif

oBrwFIG:SetArray(aBrwFIG)  
oBrwFIG:Refresh()  

oBrwTit:SetArray(aBrwTit)  
oBrwTit:Refresh()  

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xChecaArq()

Local lRet		:=	.t.
Local cQuery	:=	""

cQuery	:=	" Select * "
cQuery	+=	" From " + RetSqlName("FIG") 
cQuery	+=	" Where FIG_ZZARQ  = '" + PadR(xArquivo,TamSX3("FIG_ZZARQ")[1])	+ "' and " 
cQuery	+=		"   D_E_L_E_T_ = ' '                                                 "

TcQuery ChangeQuery(@cQuery) New Alias "XTMP" 

if	XTMP->(!Bof()) .and. XTMP->(!Eof())
	lRet := .f.
endif

XTMP->(dbclosearea())
	                              
Return ( lRet )	

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xChecaSeq()

Local cQuery	:=	""

cQuery	:=	" Select Max(FIG_ZZSEQ) FIG_ZZSEQ "
cQuery	+=	" From " + RetSqlName("FIG") 
cQuery	+=	" Where D_E_L_E_T_ = ' '             "

TcQuery ChangeQuery(@cQuery) New Alias "XTMP" 

if	XTMP->(!Bof()) .and. XTMP->(!Eof())
	xSequencia	:=	StrZero(Val(XTMP->FIG_ZZSEQ) + 1,06)
else
	xSequencia	:=	StrZero(01,06)
endif

XTMP->(dbclosearea())
	                              
Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fGravar( oBrwFIG , aBrwFIG , oBrwTit , aBrwTit , xBrwTit )

Local lRet	:=	.t.

if	MsgYesNo("Confirma grava็ใo dos itens identificados ?")
	FwMsgRun( Nil , { |oObj| CursorWait() , xGravar( oBrwFIG , aBrwFIG , oBrwTit , aBrwTit , xBrwTit ) , CursorArrow() } , "Processando" , "Gravando os dados nos tํtulos ..." )	
else
	lRet := .f.
endif

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGravar( oBrwFIG , aBrwFIG , oBrwTit , aBrwTit , xBrwTit )

Local s
Local t
Local cTitSE2        
Local lKeepVct		:=	SuperGetMv("ZZ_KEEPVCT",.f.,"S") == "S"

Begin Transaction

For s := 1 to Len(aBrwFIG)
	if	aBrwFIG[s,01]
		For t := 1 to Len(xBrwTit)	
			if	xBrwTit[t,01] == s	
				if	xBrwTit[t,02] 
	
					FIG->(dbgoto(aBrwFIG[s,12]))
					SE2->(dbgoto(xBrwTit[t,19]))

					cTitSE2				:= 	SE2->E2_FILIAL		+ "|" + ;
											SE2->E2_PREFIXO		+ "|" + ;
											SE2->E2_NUM			+ "|" + ;
											SE2->E2_PARCELA		+ "|" + ;
											SE2->E2_TIPO		+ "|" + ;
											SE2->E2_FORNECE		+ "|" + ;
											SE2->E2_LOJA		+ "|"

					TcSqlExec("UPDATE " + RetSqlName("FIG") + " SET FIG_DDASE2 = '" + cTitSE2 									+ "' WHERE R_E_C_N_O_ = " + Alltrim(Str(FIG->(Recno()))))
					TcSqlExec("UPDATE " + RetSqlName("FIG") + " SET FIG_CONCIL = '" + "1" 										+ "' WHERE R_E_C_N_O_ = " + Alltrim(Str(FIG->(Recno()))))
					TcSqlExec("UPDATE " + RetSqlName("FIG") + " SET FIG_DTCONC = '" + DtoS(Date()) 								+ "' WHERE R_E_C_N_O_ = " + Alltrim(Str(FIG->(Recno()))))
					TcSqlExec("UPDATE " + RetSqlName("FIG") + " SET FIG_USCONC = '" + cUsername 								+ "' WHERE R_E_C_N_O_ = " + Alltrim(Str(FIG->(Recno()))))

					if	Empty(FIG->FIG_FORNEC)
						TcSqlExec("UPDATE " + RetSqlName("FIG") + " SET E2_FORNECE = '" + SE2->E2_FORNECE 						+ "' WHERE R_E_C_N_O_ = " + Alltrim(Str(FIG->(Recno()))))
						TcSqlExec("UPDATE " + RetSqlName("FIG") + " SET FIG_LOJA   = '" + SE2->E2_LOJA	 						+ "' WHERE R_E_C_N_O_ = " + Alltrim(Str(FIG->(Recno()))))
					endif

					TcSqlExec("UPDATE " + RetSqlName("SE2") 	+ " SET E2_CODBAR  = '" + FIG->FIG_CODBAR 						+ "' WHERE R_E_C_N_O_ = " + Alltrim(Str(SE2->(Recno()))))
                                                                                                                            	
					if	SE2->(FieldPos("E2_CBARRA")) <> 0 
						TcSqlExec("UPDATE " + RetSqlName("SE2") + " SET E2_CBARRA  = '" + FIG->FIG_CODBAR 						+ "' WHERE R_E_C_N_O_ = " + Alltrim(Str(SE2->(Recno()))))
					endif                                                                                               	
	
					if	SE2->(FieldPos("E2_ZZCNPJ")) <> 0 
						TcSqlExec("UPDATE " + RetSqlName("SE2") + " SET E2_ZZCNPJ  = '" + FIG->FIG_CNPJ	 						+ "' WHERE R_E_C_N_O_ = " + Alltrim(Str(SE2->(Recno()))))
					endif

					if !lKeepVct .and. !Empty(xBrwTit[t,21])
						TcSqlExec("UPDATE " + RetSqlName("SE2") + " SET E2_VENCREA = '" + DtoS(DataValida(xBrwTit[t,21],.t.))	+ "' WHERE R_E_C_N_O_ = " + Alltrim(Str(SE2->(Recno()))))
					endif	

					if	xBrwTit[t,20] > 0
						TcSqlExec("UPDATE " + RetSqlName("SE2") + " SET E2_ACRESC  =  " + Alltrim(Str(Abs(xBrwTit[t,20])))		+ "  WHERE R_E_C_N_O_ = " + Alltrim(Str(SE2->(Recno()))))
						TcSqlExec("UPDATE " + RetSqlName("SE2") + " SET E2_SDACRES =  " + Alltrim(Str(Abs(xBrwTit[t,20])))		+ "  WHERE R_E_C_N_O_ = " + Alltrim(Str(SE2->(Recno()))))
					endif	

					if	xBrwTit[t,20] < 0
						TcSqlExec("UPDATE " + RetSqlName("SE2") + " SET E2_DECRESC =  " + Alltrim(Str(Abs(xBrwTit[t,20])))		+ "  WHERE R_E_C_N_O_ = " + Alltrim(Str(SE2->(Recno()))))
						TcSqlExec("UPDATE " + RetSqlName("SE2") + " SET E2_SDDECRE =  " + Alltrim(Str(Abs(xBrwTit[t,20])))		+ "  WHERE R_E_C_N_O_ = " + Alltrim(Str(SE2->(Recno()))))
					endif	

					RecLock("FIG",.f.,.t.)  
						FIG->(dbdelete())
					MsUnlock("FIG")		 

				endif
			endif
		Next t 	
	endif
Next s 

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
	if	MsgYesNo("Encerra a transa็ใo ?")
		DisarmTransaction()
	endif
endif				

End Transaction

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xChkNotConc() ; fChkNotConc() ; Return  

Static Function fChkNotConc()

Local cQuery	

cQuery	:=	" Update " + RetSqlName("FIG")
cQuery	+=	" Set   D_E_L_E_T_   = '*'                                        ,  "
cQuery	+=		"   FIG_ZZARQ    = '*' + FIG_ZZARQ                               " 
cQuery	+=	" Where FIG_FILIAL  >= '" + Replicate(" ",FwSizeFilial())	+ "' and " 
cQuery	+=		"   FIG_FILIAL  <= '" + Replicate("Z",FwSizeFilial())	+ "' and " 
cQuery	+=		"   FIG_VENCTO  <= '" + DtoS(Date() - 07)     			+ "' and "   
cQuery 	+=		"   FIG_CONCIL   = '2'                                       and "
cQuery	+=		"   D_E_L_E_T_   = ' '                                           "

TcSqlExec(cQuery)

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fAdicio( oBrwFIG , aBrwFIG , oBrwTit , aBrwTit , xBrwTit )

Local xOpc			:=	00
Local aCTF 			:= 	{}   
Local cCodFil		:=	aBrwFIG[oBrwFIG:nAt,02]              
Local dVctTit		:=	aBrwFIG[oBrwFIG:nAt,07] 
Local dVctIni		:=	aBrwFIG[oBrwFIG:nAt,07] - 60
Local dVctFim		:=	aBrwFIG[oBrwFIG:nAt,07] + 60
Local nValTit		:=	aBrwFIG[oBrwFIG:nAt,08] 
Local nValIni		:=	Round( aBrwFIG[oBrwFIG:nAt,08] * 0.85 , 02 )
Local nValFim		:=	Round( aBrwFIG[oBrwFIG:nAt,08] * 1.15 , 02 )	

FwMsgRun( Nil , { || CursorWait() , fGetDebt(@aCTF,cCodFil,dVctTit,dVctIni,dVctFim,nValTit,nValIni,nValFim,@xOpc) , CursorArrow() } , "Processando" , "Buscando tํtulos do fornecedor ..." )	

xPainel( @oBrwFIG , @aBrwFIG , @oBrwTit , @aBrwTit , @xBrwTit , @aCTF , xOpc )

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

Static Function xPainel( oBrwFIG , aBrwFIG , oBrwTit , aBrwTit , xBrwTit , aCTF , xOpc , lOut )

Local oCTF
Local xDlg
Local lLin 
Local nMkd
Local lMkd
Local oFont     
Local nOpca			:=	00
Local cQuery		:=	""
Local bOk			:=	{ || nOpca := 1 , xDlg:End() }
Local bNo			:=	{ || nOpca := 0 , xDlg:End() }      
Local alDms  		:= 	FwGetDialogSize(oMainWnd)
Local aStruct		:=	SE2->(dbstruct())

Local oOk       	:=	LoadBitmap( GetResources() 	, "LBOK" )
Local oNo       	:=	LoadBitmap( GetResources() 	, "LBNO" )

Local xFilAnt		:=	cFilAnt
Local cCodFil		:=	aBrwFIG[oBrwFIG:nAt,02]              

Default aCTF 		:= 	{}                 
Default lOut		:=	.f.

cFilAnt				:=	cCodFil       

if	Len(aCTF) <= 0
	bOk				:=	{ || nOpca := 0 , xDlg:End() }      
endif

Setapilha()
Define Font oFont 	Name "Tahoma" 	Size 0,-11 Bold

alDms[4] := 1400 

if	alDms[4] > 1402
	Define MsDialog xDlg Title "Tํtulos" From 000,000 To 0562,1402 Of oMainWnd Pixel
	@ 035,005 To 275,697 Label "Tํtulos a Pagar" Of xDlg Pixel Color CLR_RED
	oCTF := TcBrowse():New(045,010,682,225,,,,xDlg,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)
else
	Define MsDialog xDlg Title "Tํtulos" From 000,000 To 562,918 Of oMainWnd Pixel
	@ 035,005 To 275,457 Label "Tํtulos a Pagar" Of xDlg Pixel Color CLR_RED
	oCTF := TcBrowse():New(045,010,442,225,,,,xDlg,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)
endif

oCTF:AddColumn( TcColumn():New( ""     				,{ || iif( aCTF[oCTF:nAt,01] , oOk , oNo ) 	}	, "@!"          				,,,"CENTER" ,020,.t.,.f.,,,,.f.,) )     						
oCTF:AddColumn( TcColumn():New( "Filial"			,{ || aCTF[oCTF:nAt,02] 					}	, "@!"							,,,"CENTER"	,025,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Prefixo"			,{ || aCTF[oCTF:nAt,03] 					}	, "@!"							,,,"CENTER"	,030,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Numero"    		,{ || aCTF[oCTF:nAt,04] 					}	, "@!"							,,,"CENTER"	,045,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Parcela"			,{ || aCTF[oCTF:nAt,05] 					}	, "@!"							,,,"CENTER"	,025,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Tipo"				,{ || aCTF[oCTF:nAt,06] 					}	, "@!"							,,,"CENTER"	,025,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Fornecedor"		,{ || aCTF[oCTF:nAt,07]						}	, "@!"							,,,"CENTER"	,040,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Loja"				,{ || aCTF[oCTF:nAt,08] 					}	, "@!"							,,,"CENTER"	,025,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Nome" 				,{ || aCTF[oCTF:nAt,09] 					}	, "@!"							,,,"LEFT"	,090,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Vencto"			,{ || aCTF[oCTF:nAt,10] 					}	, "@!"							,,,"CENTER"	,050,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Valor"				,{ || aCTF[oCTF:nAt,11] 					}	, "@e 999,999,999.99"			,,,"RIGHT"	,050,.f.,.f.,,,,.f.,) )
oCTF:AddColumn( TcColumn():New( "Saldo"				,{ || aCTF[oCTF:nAt,12] 					}	, "@e 999,999,999.99"			,,,"RIGHT"	,050,.f.,.f.,,,,.f.,) )

oCTF:SetArray(aCTF)      
oCTF:bLDblClick		:= 	{ || nMkd := 000                       		, ;
   							 lMkd := .f. 							, ;
							 lLin := aCTF[oCTF:nAt,01] 				, ;
							 aEval( aCTF , { |x| x[01] := .f. } ) 	, ;
							 aCTF[oCTF:nAt,01] := !lLin 			, ;
							 lMkd := aCTF[oCTF:nAt,01] 				, ;
							 nMkd := iif( lMkd , oCTF:nAt , 0 ) 	, ;    
 							 oCTF:SetArray(aCTF)      				, ;
							 oCTF:Refresh()							}

if	Len(aCTF) <= 0
	oCTF:Disable()
endif

Activate MsDialog xDlg On Init EnchoiceBar(xDlg,bOk,bNo) Centered
Setapilha()

if	lMkd .and. nMkd <> 0 .and. nOpca == 1 .and. MsgYesNo("Confirma a inclusใo do tํtulo ?")        

	if	lOut
		cFilAnt := 	aCTF[nMkd,02]
	endif
 
	cQuery	:=	" Select '9' TIPO , SE2.* "									        		+ CRLF	
	cQuery	+=	" From " + RetSqlName("SE2") + " SE2 , " 					        		+ CRLF	
	cQuery	+=	"      " + RetSqlName("SA2") + " SA2   "					       			+ CRLF	
	cQuery	+=	" Where SA2.A2_FILIAL    = '" + xFilial("SA2")				+ "'   and " 	+ CRLF	
	cQuery	+=		"   SA2.A2_COD       = SE2.E2_FORNECE                          and " 	+ CRLF	
	cQuery	+=		"   SA2.A2_LOJA      = SE2.E2_LOJA                             and " 	+ CRLF	
	cQuery	+=		"   SA2.D_E_L_E_T_   = ' '                                     and " 	+ CRLF	
	cQuery	+=		"   SE2.E2_FILIAL    = '" + xFilial("SE2")				+ "'   and " 	+ CRLF	
	cQuery 	+=		"   SE2.R_E_C_N_O_   =  " + Alltrim(Str(aCTF[nMkd,13]))	+ "    and "	+ CRLF	
	cQuery 	+=		"   SE2.D_E_L_E_T_   = ' '                                         "	+ CRLF	

	xGravaArray(@xBrwTit,@aBrwFIG,@cQuery,@aStruct,xOpc,Nil,oBrwFIG:nAt)

	fChange( @oBrwFIG , @aBrwFIG , @oBrwTit , @aBrwTit , @xBrwTit )

	oBrwTit:SetArray(aBrwTit)
	oBrwTit:Refresh()

endif

cFilAnt	:= xFilAnt

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  09/18/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fGetDebt(aCTF,cCodFil,dVctTit,dVctIni,dVctFim,nValTit,nValIni,nValFim,xOpc)

Local t
Local cQuery			:=	""
Local cCPNEG			:=	MV_CPNEG
Local nTamIdCnab		:= 	TamSx3("E2_IDCNAB")[1]
Local nTamCodBar		:= 	TamSx3("E2_CODBAR")[1]                                               

For t := 1 to 4 

	xOpc	:=	t
	
	cQuery	:=	" Select R_E_C_N_O_ "
	cQuery	+=	" From " + RetSqlName("SE2")
	cQuery	+=	" Where E2_FILIAL      = '" + cCodFil						+ "' and "
	cQuery 	+= 		"   E2_TIPO   NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "  and "	
	cQuery 	+= 		"   E2_TIPO   NOT IN  " + FormatIn(MVABATIM,'|') 		+ "  and "	
	cQuery 	+= 		"   E2_TIPO   NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "  and "	
	cQuery 	+= 		"   E2_TIPO   NOT IN  " + FormatIn(MVTAXA,,3) 			+ "  and "	
	cQuery 	+= 		"   E2_TIPO   NOT IN  " + FormatIn(MVPROVIS,,3) 		+ "  and "	
	if	lCCL .or. lCheck	
		cQuery 	+= 	"   E2_TIPO   NOT IN ('INV','PRE')                           and "	
	endif	
	cQuery 	+=		"   E2_TITPAI      = '" + CriaVar("E2_TITPAI",.f.) 		+ "' and "	
	cQuery 	+=		"   E2_CODBAR      = '" + Space(nTamCodbar) 			+ "' and "	
	cQuery 	+=		"   E2_IDCNAB      = '" + Space(nTamIdCnab) 			+ "' and "	
	if	t == 1 	
		cQuery 	+=	"   E2_VENCREA     = '" + DtoS(dVctTit)		   			+ "' and "	
		cQuery 	+=	"   E2_VALOR       =  " + Alltrim(Str(nValTit))			+ "  and "	
	elseif	t == 2 	
		cQuery 	+=	"   E2_VENCREA    >= '" + DtoS(dVctIni)		   			+ "' and "	
		cQuery 	+=	"   E2_VENCREA    <= '" + DtoS(dVctFim)		   			+ "' and "	
		cQuery 	+=	"   E2_VALOR       =  " + Alltrim(Str(nValTit))			+ "  and "	
	elseif	t == 3 	
		cQuery 	+=	"   E2_VENCREA     = '" + DtoS(dVctTit)		   			+ "' and "	
		cQuery 	+=	"   E2_VALOR       >  " + Alltrim(Str(nValIni))			+ "  and "	
		cQuery 	+=	"   E2_VALOR       <  " + Alltrim(Str(nValFim))			+ "  and "	
	elseif	t == 4 	
		cQuery 	+=	"   E2_VENCREA    >= '" + DtoS(dVctIni)		   			+ "' and "	
		cQuery 	+=	"   E2_VENCREA    <= '" + DtoS(dVctFim)		   			+ "' and "	
		cQuery 	+=	"   E2_VALOR       >  " + Alltrim(Str(nValIni))			+ "  and "	
		cQuery 	+=	"   E2_VALOR       <  " + Alltrim(Str(nValFim))			+ "  and "	
	endif
	cQuery 	+= 		"   E2_SALDO       > 0                                       and "	
	cQuery	+=		"   D_E_L_E_T_     = ' '                                         "   
	cQuery	+=	" Order By E2_VALOR , E2_FORNECE                                     "
	
	TcQuery ChangeQuery(@cQuery) New Alias "XSE2"
	
	do while XSE2->(!Eof())
	
		SE2->(dbgoto(XSE2->R_E_C_N_O_))
		
		aAdd( aCTF	, {	.f.					,;
						SE2->E2_FILIAL		,;
						SE2->E2_PREFIXO		,;
						SE2->E2_NUM			,;
						SE2->E2_PARCELA		,;
						SE2->E2_TIPO		,;
						SE2->E2_FORNECE		,;
						SE2->E2_LOJA		,;	
						SE2->E2_NOMFOR		,;
						SE2->E2_VENCREA		,;
						SE2->E2_VALOR		,;
						SE2->E2_SALDO		,;
						SE2->(Recno())		})				
	
		XSE2->(dbskip())
	enddo
	
	XSE2->(dbclosearea())     
	
	if	Len(aCTF) <> 0
		Exit
	endif

Next t 	
	
Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXPREPPAG  บAutor  ณMicrosiga           บ Data ณ  02/08/19   บฑฑ
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
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGravaArray(xBrwTit,aBrwFIG,cQuery,aStruct,nTipo,lNoLock,xBrwFIG,lMail)

Local s 
Local lFind		:=	.f.	  
Local lPass		:=	.t.
Local nCount 	:= 	000                                          

Default lMail	:=	.f.
Default lNoLock	:=	.f.
Default xBrwFIG	:=	Len(aBrwFIG)	

TcQuery ChangeQuery(@cQuery) New Alias "XSE2"

do while XSE2->(!Eof())

	if	lPass
		lPass := .f.
		TcSetField( "XSE2" , "E2_PIS" 		, "N" , 17 , 02 )	
		TcSetField( "XSE2" , "E2_CSLL" 		, "N" , 17 , 02 )	
		TcSetField( "XSE2" , "E2_SALDO"		, "N" , 17 , 02 )	
		TcSetField( "XSE2" , "E2_VALOR" 	, "N" , 17 , 02 )	
		TcSetField( "XSE2" , "E2_COFINS"	, "N" , 17 , 02 )	
		TcSetField( "XSE2" , "E2_VRETPIS"	, "N" , 17 , 02 )	
		TcSetField( "XSE2" , "E2_VRETCSL"	, "N" , 17 , 02 )	
		TcSetField( "XSE2" , "E2_VRETCOF"	, "N" , 17 , 02 )	
		TcSetField( "XSE2" , "E2_VENCREA" 	, "D" , 08 , 00 )	
	endif
		
	if	aScan( xBrwTit , { |x| x[01] == xBrwFIG .and. x[19] == XSE2->R_E_C_N_O_ } ) == 0 

		lFind 	:= 	.t.
		nCount 	+=	001 

		aAdd( xBrwTit	,	{	xBrwFIG																				,;  	// 01
								nTipo == 1 .and. nCount == 1                                                 		,;		// 02
								XSE2->E2_FILIAL																		,;		// 03
								XSE2->E2_PREFIXO																	,;		// 04
								XSE2->E2_NUM    																	,;		// 05
								XSE2->E2_PARCELA																	,;		// 06
								XSE2->E2_TIPO   																	,;		// 07
								XSE2->E2_FORNECE																	,;		// 08
								XSE2->E2_LOJA   																	,;		// 09
								XSE2->E2_NOMFOR 																	,;		// 10
								XSE2->E2_VENCREA																	,;		// 11
								XSE2->E2_VALOR  																	,;		// 12
								nTipo		      																	,;		// 13
								Len(xBrwTit)       																	,;		// 14
								XSE2->E2_PIS     - XSE2->E2_VRETPIS        											,;      // 15
								XSE2->E2_CSLL    - XSE2->E2_VRETCSL													,;		// 16
								XSE2->E2_COFINS  - XSE2->E2_VRETCOF													,;		// 17
								0                              														,;		// 18
								XSE2->R_E_C_N_O_																	,;		// 19
								0                              														,;		// 20
								CtoD("")                       														})		// 21
								
		xBrwTit[Len(xBrwTit),18] 	:= 	XSE2->E2_SALDO - xBrwTit[Len(xBrwTit),15] - xBrwTit[Len(xBrwTit),16] - xBrwTit[Len(xBrwTit),17]  

		aBrwFIG[xBrwFIG,11] 		+= 	001

		if	nTipo == 0
			aBrwFIG[xBrwFIG,11] 	:= 	-1
		endif
		
	endif

	XSE2->(dbskip()) 
	
enddo

XSE2->(dbclosearea())

if	lMail	
	aBrwFIG[xBrwFIG,01]	:= 	.f.
elseif	nTipo == 1 .and. nCount == 1 
	aBrwFIG[xBrwFIG,01]	:= 	.t.
elseif	nTipo == 1 .and. nCount > 1 
	For s := 1 to Len(xBrwTit)
		if	xBrwTit[s,01] == xBrwFIG 
			xBrwTit[s,02] := .f.
		endif
	Next s 
endif	

Return ( ( nTipo == 0 .or. nTipo == 1 ) .and. lFind )  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  02/25/20   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xMoveArq()

if !ExistDir(Alltrim(cDirectory) + "\Processados")			
	MakeDir(Alltrim(cDirectory) + "\Processados")			
endif				

if	__CopyFile( Alltrim(cDirectory) + "\" + Alltrim(xArquivo) , Alltrim(cDirectory) + "\Processados\" + Alltrim(xArquivo) )   
	fErase(Alltrim(cDirectory) + "\" + Alltrim(xArquivo))
endif

Return  

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณF300VAR   บAutor  ณMicrosiga           บ Data ณ  09/26/14   บฑฑ
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
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  01/22/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xAdicio( oBrwFIG , aBrwFIG , oBrwTit , aBrwTit , xBrwTit )

Local xOpc			:=	00
Local aCTF 			:= 	{}   
Local cCodFil		:=	aBrwFIG[oBrwFIG:nAt,02]              
Local dVctTit		:=	aBrwFIG[oBrwFIG:nAt,07] 
Local dVctIni		:=	aBrwFIG[oBrwFIG:nAt,07] - 60
Local dVctFim		:=	aBrwFIG[oBrwFIG:nAt,07] + 60
Local nValTit		:=	aBrwFIG[oBrwFIG:nAt,08] 
Local nValIni		:=	Round( aBrwFIG[oBrwFIG:nAt,08] * 0.85 , 02 )
Local nValFim		:=	Round( aBrwFIG[oBrwFIG:nAt,08] * 1.15 , 02 )	

FIG->( dbgoto( aBrwFIG[oBrwFIG:nAt,Len(aBrwFIG[oBrwFIG:nAt])] ) )

FwMsgRun( Nil , { || CursorWait() , xGetDebt(@aCTF,cCodFil,dVctTit,dVctIni,dVctFim,nValTit,nValIni,nValFim,@xOpc) , CursorArrow() } , "Processando" , "Buscando tํtulos do fornecedor ..." )	

xPainel( @oBrwFIG , @aBrwFIG , @oBrwTit , @aBrwTit , @xBrwTit , @aCTF , xOpc , .t. )

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  09/18/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGetDebt(aCTF,cCodFil,dVctTit,dVctIni,dVctFim,nValTit,nValIni,nValFim,xOpc)

Local s         
Local t     
Local nPos
Local cCTF
Local xCTF
Local cQuery			:=	""
Local cFiltro          	:=	""
Local cCPNEG			:=	MV_CPNEG        
Local lSE2Excl			:=	FwModeAccess("SE2") == "E"
Local lSA2Excl			:=	FwModeAccess("SA2") == "E"
Local nTamIdCnab		:= 	TamSx3("E2_IDCNAB")[1]
Local nTamCodBar		:= 	TamSx3("E2_CODBAR")[1]

For t := 01 to 12

	xOpc	:=	iif( t > 4 , t - 4 , t )
	
	if	t <= 4
		cFiltro	:=	" SA2.A2_CGC                   = '" + FIG->FIG_CNPJ  			 	+ "' AND "
	elseif	t <= 8
		cFiltro	:=	" SUBSTRING(SA2.A2_CGC,01,08)  = '" + Substr(FIG->FIG_CNPJ,01,08)	+ "' AND "
	else
		cFiltro	:=	" SUBSTRING(SA2.A2_CGC,01,08) <> '" + Substr(FIG->FIG_CNPJ,01,08)	+ "' AND "
	endif
	
	cQuery 	:= 	" SELECT SE2.R_E_C_N_O_                "        
	cQuery 	+= 	" FROM " + RetSqlName("SE2") + " SE2 , "                              
	cQuery 	+= 	           RetSqlName("SA2") + " SA2   "
	
	cQuery 	+= 	" WHERE "         
	
	if	( lSA2Excl .and. lSE2Excl ) .or. ( !lSA2Excl .and. !lSE2Excl )
		cQuery	+=	"   SA2.A2_FILIAL      = SE2.E2_FILIAL                           AND "
	else
		cQuery	+=	"   SA2.A2_FILIAL      = '" + xFilial("SA2") 			 	+ "' AND "
	endif
	cQuery	+=		"   SA2.A2_COD         = SE2.E2_FORNECE                          AND "
	cQuery	+=		"   SA2.A2_LOJA        = SE2.E2_LOJA                             AND "
	cQuery	+=		cFiltro
	cQuery	+=		"   SA2.D_E_L_E_T_     = ' '                                     AND "
	
	if	lSE2Excl
		cQuery	+=	"   SE2.E2_FILIAL     >= '" + Replicate(" ",FwSizeFilial())	+ "' AND "
		cQuery	+=	"   SE2.E2_FILIAL     <= '" + Replicate("Z",FwSizeFilial())	+ "' AND "
	else                                                	
		cQuery	+=	"   SE2.E2_FILIAL      = '" + xFilial("SE2") 				+ "' AND "
	endif	
	cQuery 	+= 		"   SE2.E2_TIPO   NOT IN  " + FormatIn(cCPNEG+MVPAGANT,,3)	+ "  AND "	
	cQuery 	+= 		"   SE2.E2_TIPO   NOT IN  " + FormatIn(MVABATIM,'|') 		+ "  AND "	
	cQuery 	+= 		"   SE2.E2_TIPO   NOT IN  " + FormatIn(MVTXA+"INA",,3) 		+ "  AND "	
	cQuery 	+= 		"   SE2.E2_TIPO   NOT IN  " + FormatIn(MVTAXA,,3) 			+ "  AND "	
	cQuery 	+= 		"   SE2.E2_TIPO   NOT IN  " + FormatIn(MVPROVIS,,3) 		+ "  AND "	
	if	lCCL .or. lCheck	
		cQuery 	+= 	"   SE2.E2_TIPO   NOT IN ('INV','PRE')                           AND "	
	endif	
	cQuery 	+=		"   SE2.E2_TITPAI      = '" + CriaVar("E2_TITPAI",.f.) 		+ "' AND "	
	cQuery 	+=		"   SE2.E2_CODBAR      = '" + Space(nTamCodbar) 			+ "' AND "	
	cQuery 	+=		"   SE2.E2_IDCNAB      = '" + Space(nTamIdCnab) 			+ "' AND "	
	if	t == 01 .or. t == 05 .or. t == 09 
		cQuery 	+=	"   SE2.E2_VENCREA     = '" + DtoS(dVctTit)		   			+ "' AND "	
		cQuery 	+=	"   SE2.E2_VALOR       =  " + Alltrim(Str(nValTit))			+ "  AND "	
	elseif	t == 02 .or. t == 06 .or. t == 10	
		cQuery 	+=	"   SE2.E2_VENCREA    >= '" + DtoS(dVctIni)		   			+ "' AND "	
		cQuery 	+=	"   SE2.E2_VENCREA    <= '" + DtoS(dVctFim)		   			+ "' AND "	
		cQuery 	+=	"   SE2.E2_VALOR       =  " + Alltrim(Str(nValTit))			+ "  AND "	
	elseif	t == 03 .or. t == 07 .or. t == 11
		cQuery 	+=	"   SE2.E2_VENCREA     = '" + DtoS(dVctTit)		   			+ "' AND "	
		cQuery 	+=	"   SE2.E2_VALOR       >  " + Alltrim(Str(nValIni))			+ "  AND "	
		cQuery 	+=	"   SE2.E2_VALOR       <  " + Alltrim(Str(nValFim))			+ "  AND "	
	elseif	t == 04 .or. t == 08 .or. t == 12 	
		cQuery 	+=	"   SE2.E2_VENCREA    >= '" + DtoS(dVctIni)		   			+ "' AND "	
		cQuery 	+=	"   SE2.E2_VENCREA    <= '" + DtoS(dVctFim)		   			+ "' AND "	
		cQuery 	+=	"   SE2.E2_VALOR       >  " + Alltrim(Str(nValIni))			+ "  AND "	
		cQuery 	+=	"   SE2.E2_VALOR       <  " + Alltrim(Str(nValFim))			+ "  AND "	
	endif
	cQuery 	+= 		"   SE2.E2_SALDO       > 0                                       AND "	
	cQuery	+=		"   SE2.D_E_L_E_T_     = ' '                                         "   
	cQuery	+=	" Order By SE2.E2_VALOR , SE2.E2_FORNECE                                 "
	
	TcQuery ChangeQuery(@cQuery) New Alias "XSE2"
	
	do while XSE2->(!Eof())
	
		if	t == 01 .or. t == 05 .or. t == 09 
			cCTF	:=	"A"
		elseif	t == 02 .or. t == 06 .or. t == 10	
			cCTF	:=	"B"
		elseif	t == 03 .or. t == 07 .or. t == 11
			cCTF	:=	"C"
		elseif	t == 04 .or. t == 08 .or. t == 12 	
			cCTF	:=	"D"
		endif

		SE2->(dbgoto(XSE2->R_E_C_N_O_))      
		
		nPos := aScan( aCTF , { |x| x[02] + x[03] + x[04] + x[05] + x[06] + x[07] + x[08] == SE2->(E2_FILIAL + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) } )

		if	nPos == 0		
			aAdd( aCTF	, {	.f.					,;
							SE2->E2_FILIAL		,;
							SE2->E2_PREFIXO		,;
							SE2->E2_NUM			,;
							SE2->E2_PARCELA		,;
							SE2->E2_TIPO		,;
							SE2->E2_FORNECE		,;
							SE2->E2_LOJA		,;	
							SE2->E2_NOMFOR		,;
							SE2->E2_VENCREA		,;
							SE2->E2_VALOR		,;
							SE2->E2_SALDO		,;
							SE2->(Recno())		,;				
							cCTF				})				
		endif	

		XSE2->(dbskip())
	enddo
	
	XSE2->(dbclosearea())     
	
	if	Len(aCTF) <> 0
	//	Exit
	endif

Next t 	
	
xCTF := aSort( aCTF ,,, { |x,y| x[14] + x[02] + x[03] + x[04] + x[05] + x[06] + x[07] + x[08] < y[14] + y[02] + y[03] + y[04] + y[05] + y[06] + y[07] + y[08] } )
aCTF := {}

For s := 1 to Len(xCTF)
	aAdd( aCTF , Array(Len(xCTF[s]) - 1) )
	For t := 1 to ( Len(xCTF[s]) - 1 ) 
    	aCTF[Len(aCTF),t] := xCTF[s,t]
	Next t 
Next s	
	
Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  09/18/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fProcEst(aFIG,xFIG,aBXA)

Local lIsBlind	:=	IsBlind() .or. Type("__LocalDriver") == "U" 

if	lIsBlind
	xProcEst(aFIG,xFIG,aBXA)
else
	FwMsgRun( Nil , { || xProcEst(aFIG,xFIG,aBXA) } , 'Processando' , "Enviando e-mail de baixa de tํtulos ..." )
endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  09/18/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xProcEst(aFIG,xFIG,aBXA)

Local s
Local bBlk
Local aAnexos		

Local cCC			:=	""
Local cCCO			:=	""
Local cHtml			:=	""
Local xFilAnt 		:=	cFilAnt 

Local lRet			:=	.f. 

Local cPara			:=	GetMv("ZZ_EMLBXBL")
Local oObj			:= 	GeneralClass():New()
Local cSubject		:=	"Pedido de Baixa de Boletos no DDA"
Local lIsBlind		:=	IsBlind() .or. Type("__LocalDriver") == "U" 

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
 	cPara			:=	"alexandre@zapponi.com.br"
endif

if	Upper(Alltrim(GetMv("ZZ_EMLBXEN"))) == "S"
	For s := 1 to Len(aBXA)
		if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
		//	aBXA[s,02]	:=	.t.
		endif
		if	aBXA[s,02]
			SE2->(dbgoto(aBXA[s,03]))
			cFilAnt := aBXA[s,04]
			if	Empty(cHtml)
				cHtml := fRetCab() + fCabIte()
			endif
			cHtml 	+= 	fDetIte()
		endif
		if	s == Len(aBXA) .and. !Empty(cHtml)
			cHtml 	+=	'</table>' + CRLF + CRLF + '</br>' + CRLF + CRLF + fRodIte()
			if !Empty(cHtml)
				if !Empty(cPara) .or. !Empty(cCC) .or. !Empty(cCCO) 
					if	lIsBlind	
						if !lRet
							lRet := oObj:DispMail(cPara,cHtml,cSubject,Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">",aAnexos,cCC,cCCO)
						endif  				
						if !lRet
							lRet := oObj:EnviaMail(cPara,cCC,cCCO,cHtml,cSubject,SM0->M0_NOMECOM,,,,,,Nil,,aAnexos,.f.)    
						endif			
						if !lRet
							lRet := oObj:EnviaMail(cPara,cCC,cCCO,cHtml,cSubject,SM0->M0_NOMECOM,,,,,,.f.,,aAnexos,.f.) 
						endif
						if !lRet
							lRet := oObj:EnviaMail(cPara,cCC,cCCO,cHtml,cSubject,SM0->M0_NOMECOM,,,,,,.t.,,aAnexos,.f.) 
						endif
					else	
						if !lRet
							bBlk := { || lRet := oObj:DispMail(cPara,cHtml,cSubject,Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">",aAnexos,cCC,cCCO) }
							FwMsgRun( Nil , { || CursorWait() , Eval(bBlk) , CursorArrow() } , "TOTVS" , "Enviando Email ..." )
						endif  				
						if !lRet
							bBlk := { || lRet := oObj:EnviaMail(cPara,cCC,cCCO,cHtml,cSubject,SM0->M0_NOMECOM,,,,,,Nil,,aAnexos,.f.) }
							FwMsgRun( Nil , { || CursorWait() , Eval(bBlk) , CursorArrow() } , "TOTVS" , "Enviando Email ..." )
						endif			
						if !lRet
							bBlk := { || lRet := oObj:EnviaMail(cPara,cCC,cCCO,cHtml,cSubject,SM0->M0_NOMECOM,,,,,,.f.,,aAnexos,.f.) }
							FwMsgRun( Nil , { || CursorWait() , Eval(bBlk) , CursorArrow() } , "TOTVS" , "Enviando Email ..." )
						endif
						if !lRet
							bBlk := { || lRet := oObj:EnviaMail(cPara,cCC,cCCO,cHtml,cSubject,SM0->M0_NOMECOM,,,,,,.t.,,aAnexos,.f.) } 
							FwMsgRun( Nil , { || CursorWait() , Eval(bBlk) , CursorArrow() } , "TOTVS" , "Enviando Email ..." )
						endif
					endif 
				endif 
			endif
		endif
	Next s 
endif

cFilAnt := xFilAnt

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
cHtml	+=	'<title>.:: Totvs Protheus 12 - Pedido de Baixa de Boletos de Pagamento :.</title>'																+ CRLF
cHtml	+=	'</head>' 																																		+ CRLF
cHtml	+=	'<body>' 																																		+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<div style="padding: 50px;">' 																													+ CRLF
cHtml	+=	''       																																		+ CRLF
cHtml	+=	'<table border="0" cellpadding="0" cellspacing="0" height="58" width="100%">'				 													+ CRLF
cHtml	+=	'  <tr>' 																																		+ CRLF
cHtml	+=	'    <td height="72" width="100%">' 																											+ CRLF
cHtml	+=	'      <p align="center"><font face="Tahoma" size="5">Pedido de Baixa de Boletos de Pagamento</font>'	 										+ CRLF
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
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="06%" align="center"><b><span class="style5"><span style="font-size: 8pt">Filial            </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="07%" align="center"><b><span class="style5"><span style="font-size: 8pt">Prefixo           </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="09%" align="center"><b><span class="style5"><span style="font-size: 8pt">Numero            </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="07%" align="center"><b><span class="style5"><span style="font-size: 8pt">Parcela           </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="09%" align="center"><b><span class="style5"><span style="font-size: 8pt">Fornecedor        </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="07%" align="center"><b><span class="style5"><span style="font-size: 8pt">Loja		        </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="37%" align="center"><b><span class="style5"><span style="font-size: 8pt">Nome		        </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="09%" align="center"><b><span class="style5"><span style="font-size: 8pt">Vencimento        </span></span></b></td>' 			+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="09%" align="center"><b><span class="style5"><span style="font-size: 8pt">Valor             </span></span></b></td>' 			+ CRLF
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

Static Function fDetIte()

Local cHtml		:= 	""
Local cNome		:=	Posicione("SA2",01,xFilial("SA2") + SE2->E2_FORNECE + SE2->E2_LOJA,"A2_NOME")
Local cValor 	:=	Transform( SE2->E2_VALOR , PesqPict("SE2","E2_VALOR") )

cHtml	+=	'  <tbody>' 																								   												+ CRLF
cHtml	+=	'    <tr>' 																										   											+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="06%" align="center">&nbsp; ' 	+ SE2->E2_FILIAL 		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="07%" align="center">&nbsp; ' 	+ SE2->E2_PREFIXO		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="09%" align="center">&nbsp; ' 	+ SE2->E2_NUM    		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="07%" align="center">&nbsp; ' 	+ SE2->E2_PARCELA 		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="09%" align="center">&nbsp; ' 	+ SE2->E2_FORNECE 		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="07%" align="center">&nbsp; ' 	+ SE2->E2_LOJA  		+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="37%" align="left"  >&nbsp; ' 	+ cNome					+ '       </td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="09%" align="center">&nbsp; ' 	+ DtoC(SE2->E2_VENCREA)	+ ' &nbsp;</td>'		+ CRLF
cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="09%" align="right" >       ' 	+ cValor				+ ' &nbsp;</td>'		+ CRLF
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

Static Function fRodIte()

Local cHtml	:= 	""

cHtml	+=	'<table border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#E5E5E5" bgcolor="#F7F7F7" width="100%">' 																															+ CRLF
cHtml	+=	'  <tr>' 																																																											+ CRLF
if	cEmpAnt == "02"
	cHtml	+=	' <td width="100%" bordercolor="#FFFFFF"><div align="right" class="texto-layer">WorkFlow @ Checkpoint     </div></td>' 																															+ CRLF
else
	cHtml	+=	' <td width="100%" bordercolor="#FFFFFF"><div align="right" class="texto-layer">WorkFlow @ CCL Industries </div></td>' 																															+ CRLF
endif
cHtml	+=	'  </tr>' 																																																											+ CRLF
cHtml	+=	'</table>' 																																																											+ CRLF
cHtml	+=	'</div>' 																																																											+ CRLF
cHtml	+=	'</body>' 																																																											+ CRLF
cHtml	+=	'</html>' 																																																											+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  09/18/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fProcArq(aFIG,xFIG,aBXA)

Local lIsBlind	:=	IsBlind() .or. Type("__LocalDriver") == "U" 

if	lIsBlind
	xProcArq(aFIG,xFIG,aBXA)
else
	FwMsgRun( Nil , { || xProcArq(aFIG,xFIG,aBXA) } , 'Processando' , "Gerando o arquivo de baixa ..." )
endif

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  09/18/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xProcArq(aFIG,xFIG,aBXA)

Local s 
Local t 
Local xDir
Local nRecno
Local cQuery	:=	""
Local cNumBor	:=	""
Local xNumBor	:=	""
Local xFilAnt	:=	cFilAnt
Local aFiliais 	:=	FinRetFil()    
Local lSE2Excl	:=	FwModeAccess("SE2") == "E"

if	lCCL .or. lCheck	
	For s := 1 to Len(aBXA)
		if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
		//	aBXA[s,02]	:=	.t.
		endif
		if	aBXA[s,02]
			SE2->(dbgoto(aBXA[s,03]))
			SEA->(dbsetorder(2))    
			if !Empty(SE2->E2_NUMBOR) .and. SEA->(dbseek( xFilial("SEA") + SE2->(E2_NUMBOR + "P" + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. )) 

				nRecno	:=	SEA->(Recno())
				xNumBor	:=	SE2->E2_NUMBOR	
				cFilAnt := 	iif( lSE2Excl , SE2->E2_FILIAL , SE2->E2_FILORIG )

				For t := 1 to Len(aFiliais)

					cQuery	:=	" Select R_E_C_N_O_ as RECNOSEA "
					cQuery	+=	" From " + RetSqlName("SEA")
					cQuery	+=	" Where EA_FILIAL   = '" + xFilial("SEA",aFiliais[t])	+ "' and "
					cQuery	+=		"   EA_PREFIXO  = '" + SE2->E2_PREFIXO				+ "' and "
					cQuery	+=		"   EA_NUM      = '" + SE2->E2_NUM					+ "' and "
					cQuery	+=		"   EA_PARCELA  = '" + SE2->E2_PARCELA				+ "' and "
					cQuery	+=		"   EA_TIPO     = '" + SE2->E2_TIPO					+ "' and "
					cQuery	+=		"   EA_FORNECE  = '" + SE2->E2_FORNECE				+ "' and "
					cQuery	+=		"   EA_LOJA	    = '" + SE2->E2_LOJA					+ "' and "
					cQuery	+=		"   R_E_C_N_O_ <>  " + Alltrim(Str(nRecno)) 		+ "  and "
					cQuery 	+=		"   D_E_L_E_T_  = ' '                                        "
					
					TcQuery ChangeQuery(@cQuery) New Alias "XQRY"        	
					
					do while XQRY->(!Eof())
						SEA->(dbgoto(XQRY->RECNOSEA))
						RecLock("SEA",.f.,.t.)
							SEA->(dbdelete())
						MsUnlock("SEA")
						XQRY->(dbskip())	
					enddo
				
					XQRY->(dbclosearea())     
				
				Next t 	 	 

				cNumBor	:=	StrZero(Val(GetMv("ZZ_NUMBOR")) + 1,Len(SE2->E2_NUMBOR))

				do while .t.  
					For t := 1 to Len(aFiliais)
						lCont := SEA->(dbseek( xFilial("SEA",aFiliais[t]) + cNumBor + "P" , .f. )) 
						if	lCont
							Exit			
						endif			
					Next t 	 	 
					if !lCont .and. MayIUseCode("E2_NUMBOR" + xFilial("SE2") + cNumBor)
						Exit
					else
						cNumBor	:=	StrZero(Val(cNumBor) + 1,Len(SE2->E2_NUMBOR))
					endif
				enddo

				if	cNumBor > GetMv("MV_NUMBORP")
					PutMv("MV_NUMBORP",cNumBor)
				endif
				
				PutMv("ZZ_NUMBOR",cNumBor)
				
				SEA->(dbgoto(nRecno))

				RecLock("SEA",.f.)
					SEA->EA_NUMBOR	:=	cNumBor
				MsUnlock("SEA")     

				SE2->(dbgoto(aBXA[s,03]))

				RecLock("SE2",.f.)
					SE2->E2_NUMBOR	:= 	cNumBor
				MsUnlock("SE2")

				SE2->(dbgoto(aBXA[s,03]))

				if	SA6->(dbseek( xFilial("SA6") + SEA->EA_PORTADO + SEA->EA_AGEDEP + SEA->EA_NUMCON , .f. ))

					xDir := Alltrim(SA6->A6_ZZDRGVP) 
					
					if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
						xDir := "c:\temp7"
					endif

					xDir += iif( Right(xDir,01) <> "\" , "\" , "" )

					U_xGera341( { SEA->EA_PORTADO , SEA->EA_AGEDEP , SEA->EA_NUMCON , Nil , SEA->EA_NUMBOR } , xDir , .f. , Nil , SA6->A6_ZZSUBP , .t. )

				endif

				/*
				SEA->(dbgoto(nRecno))

				Private cLote

				LoteCont( "FIN" )

				F241CanImp(Nil,Nil,Nil,Nil,Nil,Nil,cNumBor)

				SEA->(dbgoto(nRecno))

				RecLock("SEA",.f.,.t.)
					SEA->(dbdelete())
				MsUnlock("SEA")

				RecLock("SE2",.f.)
					SE2->E2_CODBAR 	:= 	""
				MsUnlock("SE2")
				*/
				
			endif
		endif
	Next s 
endif

cFilAnt := xFilAnt

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA430  บAutor  ณMicrosiga           บ Data ณ  09/18/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xMudaVcto(aBrwTit,oBrwTit,aBrwFIG,oBrwFIG,xBrwTit)

Local t
Local oFont
Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1  
Local lOk			:=	.f.
Local dTGet1		:=	aBrwTit[oBrwTit:nAt,11]     

Define Font oFont Name "Tahoma" Size 0,-11 Bold

Define Dialog oDlgAlt Title "Informe" From 000,000 To 080,200 Pixel
oSay1		:= 	tSay():Create(oDlgAlt,{|| "Vencimento :" },08,05,,oFont,,,,.t.,Nil,)
oTGet1 		:= 	tGet():New(05,50,bSetGet(dTGet1),oDlgAlt,047,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
oTButton1	:= 	tButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered

if	lOk
	if !Empty(dTGet1)   
		if	dTGet1 == DataValida(dTGet1)
			if	dTGet1 <= aBrwFIG[oBrwFIG:nAt,07]
				if	MsgYesNo("Confirma a altera็ใo do vencimento do tํtulo ?","ATENวรO")
					SE2->(dbgoto(aBrwTit[oBrwTit:nAt,19]))
					RecLock("SE2",.f.)
						SE2->E2_VENCTO 			:=	dTGet1	
						SE2->E2_VENCREA			:=	dTGet1	
					MsUnlock("SE2")
					aBrwTit[oBrwTit:nAt,11] 	:=	dTGet1	
					oBrwTit:SetArray(aBrwTit) 
					oBrwTit:Refresh()
					For t := 1 to Len(xBrwTit)
						if	xBrwTit[t,03] == aBrwTit[oBrwTit:nAt,03]
							if	xBrwTit[t,04] == aBrwTit[oBrwTit:nAt,04]
								if	xBrwTit[t,05] == aBrwTit[oBrwTit:nAt,05]
									if	xBrwTit[t,06] == aBrwTit[oBrwTit:nAt,06]
										if	xBrwTit[t,07] == aBrwTit[oBrwTit:nAt,07]
											if	xBrwTit[t,08] == aBrwTit[oBrwTit:nAt,08]
												if	xBrwTit[t,09] == aBrwTit[oBrwTit:nAt,09]
													xBrwTit[t,11] := dTGet1	
												endif
											endif
										endif
									endif
								endif
							endif
						endif
					Next t 
				endif
			else
				Alert("A data informada nใo pode ser maior que o vencimento do boleto")	
			endif 
		else
			Alert("Preencha uma data vแlida")
		endif					
	endif					
endif

Return 
