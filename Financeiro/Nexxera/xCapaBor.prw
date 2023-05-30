#include "topconn.ch"         	      		   		               		                                               			
#include "protheus.ch"     			
        	
#define EX_LEFT    				001
#define EX_CENTER  				002                            		
#define EX_RIGHT   				003         	

#define EX_GENERAL				001
#define EX_NUMBER				002
#define EX_MONETARIO			003
#define EX_DATETIME				004

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxCapaBor  บAutor  ณMicrosiga           บ Data ณ  07/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xCapaBor(cBordero,cTipo)    	  	 	

Local oReport

Default cTipo		:=	"E"
Default cBordero	:=	fGetNumBor()

if	Empty(cBordero)
	Return 
elseif	cTipo == "E"
	ReportPrint(Nil,cBordero,cTipo)
elseif	cTipo == "T"
	oReport := ReportDef(cBordero,cTipo)
	oReport:PrintDialog()
endif	

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxCapaBor  บAutor  ณMicrosiga           บ Data ณ  07/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function ReportDef(cBordero,cTipo)

Local oNF		:=	Nil
Local oReport 	:=	Nil
Local cTitulo	:= 	"Border๔ " + cBordero

oReport	:= 	tReport():New( 'XCAPABOR' , cTitulo , Nil , { |oReport| ReportPrint(@oReport,cBordero,cTipo) } , cTitulo )

//oReport:SetLandscape(.t.) 

oReport:SetPortrait(.t.) 

oNF		:=	TrSection():New(oReport,"Border๔",,{OemToAnsi("Border๔")})

oNF:SetHeaderSection(.t.)
oNF:AutoSize()

TrCell():New(oNF,'E2_FILIAL'   		,	, "Filial" 			, PesqPict("SE2",'E2_FILIAL')   , TamSx3('E2_FILIAL')[1]                    	,,,"CENTER"	,,"CENTER" 	)     
TrCell():New(oNF,'E2_NUM'     		,	, "Numero"			, PesqPict("SE2",'E2_NUM')      , TamSx3('E2_NUM')[1] * 1.25    	       		,,,"CENTER"	,,"CENTER" 	)     
TrCell():New(oNF,'E2_PARCELA'      	,	, "Parcela"  		, PesqPict("SE2",'E2_PARCELA')  , TamSx3('E2_PARCELA')[1]                 		,,,"CENTER"	,,"CENTER" 	)     
TrCell():New(oNF,'E2_FORNECE' 		,	, "Fornecedor"		, PesqPict("SE2",'E2_FORNECE')  , TamSx3('E2_FORNECE')[1]                  		,,,"CENTER"	,,"CENTER" 	)     
TrCell():New(oNF,'E2_LOJA'			,	, "Loja"     		, PesqPict("SE2",'E2_LOJA')     , TamSx3('E2_LOJA')[1]        	             	,,,"CENTER"	,,"CENTER" 	)          
TrCell():New(oNF,'E2_NOMFOR'		,	, "Nome"     		, PesqPict("SE2",'E2_NOMFOR')  	, TamSx3('E2_NOMFOR')[1] * 1.5               							)     
TrCell():New(oNF,'E2_VENCREA'		,	, "Vencimento" 		, "@!"                        	, TamSx3('E2_VENCREA')[1]                     	,,,"CENTER"	,,"CENTER" 	)               
TrCell():New(oNF,'E2_VALOR'			,	, "Valor"    		, "@!"                         	, TamSx3('E2_VALOR')[1]                     	,,,"RIGHT" 	,,"RIGHT" 	)          
TrCell():New(oNF,'E2_SALDO'			,	, "Saldo"    		, "@!"                         	, TamSx3('E2_VALOR')[1]                     	,,,"RIGHT" 	,,"RIGHT" 	)          

Return ( oReport )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxCapaBor  บAutor  ณMicrosiga           บ Data ณ  07/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
                                                        		
Static Function ReportPrint(oReport,cBordero,cTipo)

Local nCount		:=	000
Local nSaldo		:=	000
Local nTotal		:=	000
Local oNF			:= 	Nil   
Local aArea			:=	Nil
Local cQuery		:=	Nil
Local oExcel		:=	Nil      
Local cArq  		:= 	Nil
Local oObj			:= 	GeneralClass():New()     
Local lSE2Excl		:=	FwModeAccess("SE2") == "E"

aArea := GetArea()

cQuery	:=	"SELECT SE2.R_E_C_N_O_ RECNOSE2   ,"
cQuery	+=		"   SEA.R_E_C_N_O_ RECNOSEA   ,"
cQuery	+=		"   SE2.D_E_L_E_T_ SE2DELETED ,"
cQuery	+=		"   SEA.D_E_L_E_T_ SEADELETED  "
cQuery	+=	"FROM " + RetSqlName("SEA") + " SEA ," + RetSqlName("SE2") + " SE2 " 
cQuery	+=	"WHERE " 
if	( FwModeAccess("SE2") == "E" .and. FwModeAccess("SEA") == "E" ) .or. ( FwModeAccess("SE2") == "C" .and. FwModeAccess("SEA") == "C" )
	cQuery	+=	"( SE2.E2_FILIAL  = SEA.EA_FILIAL                            OR  "
	cQuery	+=	"  SE2.E2_FILIAL  = SEA.EA_FILORIG                         ) AND "
else
	cQuery	+=	"  SE2.E2_FILIAL  = '" + xFilial("SE2")					+ "' AND "
endif
cQuery	+=		"  SE2.E2_PREFIXO = SEA.EA_PREFIXO                           AND "
cQuery	+=		"  SE2.E2_NUM     = SEA.EA_NUM                               AND "
cQuery	+=		"  SE2.E2_PARCELA = SEA.EA_PARCELA                           AND "
cQuery	+=		"  SE2.E2_TIPO    = SEA.EA_TIPO                              AND " 
cQuery	+=		"  SE2.E2_FORNECE = SEA.EA_FORNECE                           AND "
cQuery	+=		"  SE2.E2_LOJA    = SEA.EA_LOJA                              AND "
cQuery	+=		"  SE2.E2_NUMBOR  = SEA.EA_NUMBOR                            AND "
cQuery	+=		"  SE2.D_E_L_E_T_ = ' '                                      AND " 
cQuery	+=		"  SEA.EA_FILIAL >= '" + Replicate(" ",FwSizeFilial())	+ "' AND " 
cQuery	+=		"  SEA.EA_FILIAL <= '" + Replicate("Z",FwSizeFilial())	+ "' AND " 
cQuery	+=		"  SEA.EA_NUMBOR  = '" + cBordero 						+ "' AND " 
cQuery	+=		"  SEA.EA_CART    = 'P'                                          "
cQuery	+=	"ORDER BY EA_NUMBOR "                

oObj:FinaMsg( "Buscando registros, aguarde..." ,, { || CursorWait() , dbUseArea(.t.,"TOPCONN",TcGenQry(Nil,Nil,ChangeQuery(@cQuery)),"TSE2",.f.,.t.) , CursorArrow() } , 128 )

dbselectarea("TSE2")

if	TSE2->(!Bof()) .and. TSE2->(!Eof())

	if	cTipo == "T"	   
		Count to nCount
		TSE2->(dbgotop())
	endif          

	SE2->(dbgoto(TSE2->RECNOSE2))		
	SEA->(dbgoto(TSE2->RECNOSEA))		

	if	cTipo == "E"	             
		if	ValType(oExcel) <> "O"   

			cArq	:= 	CriaTrab(Nil,.f.)      
		
			oExcel 	:= 	FwMsExcel():New()
	
			cWrk 	:= 	"Border๔ " + cBordero 
				
			oExcel:AddworkSheet("Titulos")
		
			oExcel:AddTable( "Titulos" , cWrk )
		
			oExcel:AddColumn( "Titulos" , cWrk ,  "Filial" 			, EX_CENTER	, EX_GENERAL  	)
			oExcel:AddColumn( "Titulos" , cWrk ,  "Numero"			, EX_LEFT 	, EX_GENERAL  	)
			oExcel:AddColumn( "Titulos" , cWrk ,  "Parcela"			, EX_LEFT 	, EX_GENERAL  	)
			oExcel:AddColumn( "Titulos" , cWrk ,  "Fornecedor"		, EX_LEFT 	, EX_GENERAL  	)
			oExcel:AddColumn( "Titulos" , cWrk ,  "Loja"			, EX_LEFT 	, EX_GENERAL  	)
			oExcel:AddColumn( "Titulos" , cWrk ,  "Nome"			, EX_LEFT 	, EX_GENERAL  	)
			oExcel:AddColumn( "Titulos" , cWrk ,  "Venc. Real"		, EX_CENTER	, EX_DATETIME  	)
			oExcel:AddColumn( "Titulos" , cWrk ,  "Valor Titulo"	, EX_RIGHT	, EX_NUMBER  	)
			oExcel:AddColumn( "Titulos" , cWrk ,  "Saldo Titulo"	, EX_RIGHT	, EX_NUMBER  	)
	
		endif
	elseif	cTipo == "T"	             
		if	ValType(oExcel) <> "O"   
			oReport:SetTitle(OemToAnsi("Relat๓rio de Titulos em Border๔"))
			oReport:SetMeter(nCount)
			oNF		:= 	oReport:Section(1)      
			oNF:Init()
		endif
	endif
		
	do while TSE2->(!Eof())           
	
		SE2->(dbgoto(TSE2->RECNOSE2))		
		SEA->(dbgoto(TSE2->RECNOSEA))		
		
		SA2->(dbsetorder(1))
		SA2->(dbseek( xFilial("SA2",iif(!Empty(SE2->E2_FILIAL),SE2->E2_FILIAL,Nil)) + SE2->E2_FORNECE + SE2->E2_LOJA, .f. )) 

		nSaldo	:=	Round(NoRound(xMoeda(SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE,SE2->E2_MOEDA,1,Date()),3),2)

//		nSaldo 	-=	SE2->(E2_SEST + E2_PIS + E2_COFINS + E2_CSLL)     
		
		if	nSaldo <= 0 
			nSaldo := 0
		endif
			
		if	cTipo == "E"	             
			oExcel:AddRow( "Titulos" , cWrk 		,	{ 	iif( lSE2Excl , SE2->E2_FILIAL , SE2->E2_FILORIG )	, ;
															SE2->E2_NUM											, ;
															SE2->E2_PARCELA										, ;
															SE2->E2_FORNECE										, ;
															SE2->E2_LOJA   										, ;
															SA2->A2_NOME   										, ;
															SE2->E2_VENCREA										, ;
															SE2->E2_VALOR										, ;
															nSaldo 		 										} )
		elseif	cTipo == "T"	
			oReport:IncMeter()
		
			oNF:Cell('E2_FILIAL' ):SetValue( iif( lSE2Excl , SE2->E2_FILIAL , SE2->E2_FILORIG )			)
			oNF:Cell('E2_NUM'    ):SetValue( SE2->E2_NUM												)
			oNF:Cell('E2_PARCELA'):SetValue( SE2->E2_PARCELA											)
			oNF:Cell('E2_FORNECE'):SetValue( SE2->E2_FORNECE											)
			oNF:Cell('E2_LOJA'   ):SetValue( SE2->E2_LOJA												)
			oNF:Cell('E2_NOMFOR' ):SetValue( SA2->A2_NOME												)
			oNF:Cell('E2_VENCREA'):SetValue( DtoC(SE2->E2_VENCREA)   									)
			oNF:Cell('E2_VALOR'  ):SetValue( Transform( SE2->E2_VALOR , PesqPict("SE2","E2_VALOR") )	)
			oNF:Cell('E2_SALDO'  ):SetValue( Transform( nSaldo , PesqPict("SE2","E2_VALOR") )			)

			oNF:PrintLine()
		endif

		nTotal += nSaldo

		TSE2->(dbskip())
	enddo

	if	cTipo == "E"	             
		oExcel:AddRow( "Titulos" , cWrk 			,	{ 	""            										, ;
															""         											, ;
															""             										, ;
															""             										, ;
															""             										, ;
															""             										, ;
															""             										, ;
															"Totais"       										, ;
															nTotal		  										} )
	elseif	cTipo == "T"	
		oReport:SkipLine()
	
		oNF:Cell('E2_FILIAL' ):SetValue( ""                                                			)
		oNF:Cell('E2_NUM'    ):SetValue( ""         												)
		oNF:Cell('E2_PARCELA'):SetValue( ""             											)
		oNF:Cell('E2_FORNECE'):SetValue( ""             											)
		oNF:Cell('E2_LOJA'   ):SetValue( ""          												)
		oNF:Cell('E2_NOMFOR' ):SetValue( "Border๔ " + cBordero										)
		oNF:Cell('E2_VENCREA'):SetValue( ""                      									)
		oNF:Cell('E2_VALOR'  ):SetValue( "Totais"                                               	)
		oNF:Cell('E2_SALDO'  ):SetValue( Transform( nTotal , PesqPict("SE2","E2_VALOR") )			)

		oNF:PrintLine()
	endif

else
	Alert("Nใo hแ dados a apresentar para o border๔ informado")
endif
	
TSE2->(dbclosearea())

if	cTipo == "E"	             

	if	ValType(oExcel) == "O"

		oExcel:Activate()

		if !ExistDir("c:\temp")			
			MakeDir("c:\temp")
		endif

		if	File("c:\temp\" + Alltrim(cArq) + ".xml") 
			fErase("c:\temp\" + Alltrim(cArq) + ".xml") 
		endif

		oExcel:GetXmlFile("c:\temp\" + Alltrim(cArq) + ".xml") 

		ShellExecute("open","excel.exe","c:\temp\" + Alltrim(cArq) + ".xml","",5) 

	endif

elseif	cTipo == "T"	             

	oNF:Finish()
	
endif

RestArea(aArea)

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณAEGEAPPP  บAutor  ณMicrosiga           บ Data ณ  07/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fGetNumBor()

Local oSay1
Local oTGet1   
Local oDlgAlt
Local oTButton1  

Local nOpc				:=	0
Local xTGet1 			:=	CriaVar("E2_NUMBOR",.f.)
Local oFont 			:= 	tFont():New("Verdana",,14,.t.,.f.)
Local oFontB			:= 	tFont():New("Verdana",,14,.t.,.t.)

Define Dialog oDlgAlt Title "Border๔" From 000,000 To 080,200 Pixel
oSay1		:= 	tSay():Create(oDlgAlt,{|| "Digite :" },08,05,,oFontB,,,,.t.,CLR_BLUE,Nil)
oTGet1 		:= 	tGet():New(05,42,bSetGet(xTGet1),oDlgAlt,055,009,"@!",,0,,oFont,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
oTButton1	:= 	tButton():New(025,057,"Ok",oDlgAlt,{ || nOpc := 1 , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered   

if	nOpc <> 1
	Return ( CriaVar("E2_NUMBOR",.f.) ) 
endif

Return ( xTGet1 )                                                                        
