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

Static lCCL  					:=	Nil 
Static lAdoro					:=	Nil 
Static lFadel					:=	Nil 
Static lMando					:=	Nil 
Static lCheck					:=	Nil 
Static lMastra					:=	Nil 

Static lIsBlind					:=	IsBlind() .or. Type("__LocalDriver") == "U"      
Static lBlqTit					:=	iif( lIsBlind , .f. , SuperGetMv("ZZ_BLQTITP",.f.,.t.) )

Static lF050Alt	 				:= 	ExistBlock("F050ALT")
Static lFa050Upd				:= 	ExistBlock("FA050UPD")

Static lGera001					:=	ExistBlock("XGERA001")
Static lGera033					:=	ExistBlock("XGERA033")
Static lGera104					:=	ExistBlock("XGERA104")
Static lGera237					:=	ExistBlock("XGERA237")
Static lGera341					:=	ExistBlock("XGERA341")
Static lGera422					:=	ExistBlock("XGERA422")

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	XPREPPAG
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/
//@history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
//@history ticket TI - Antonio Domingos - 31/05/2023 - Ajuste Nova Empresa
User Function xPrepPag(lJob,lCarga,aPar,xPosFlg,xPosStt,xLogRet,lBorder,xArr,xDia,lDesmarca,xButAban)    

Local aArr			:=	{}
Local oObj			:= 	RetornaLicensa():New()
Local lCont			:=	oObj:ChecaEmp()	
Local aArea			:=	SM0->(GetArea())
Local lAdmin		:=	FwIsAdmin(RetCodUsr())      
Local xFilAnt		:=	cFilAnt          
Local dMaxDate		:=	Max(Max(Date(),GetRmtDate()),dDataBase)    
Local lChecaUsr		:=	SuperGetMv("ZZ_PVALUSR",.f.,.f.) 

Local cTag			:=	'<img height="070" width="160" align="left" src="http://www.xxxxx.com.br/wp-content/uploads/2015/06/logo.png" border="0">'

Default lJob		:=	.f.
Default xButAban	:=	.f.

Private lButAban	:=	xButAban														//( GetMv("ZZ_USBUTAB") == "S" )   
Private aFiliais 	:=	FinRetFil()         

if	lJob
	lCont			:=	.t.
	lChecaUsr		:=	.f.     
	xChecaVar()
	xChecaPar()                     
	F241DtBor()
else
	FwMsgRun( Nil , { || xChecaVar() } , 'Processando' , "Buscando dados ..." )
	FwMsgRun( Nil , { || xChecaPar() } , 'Processando' , "Buscando dados ..." )
	FwMsgRun( Nil , { || F241DtBor() } , 'Processando' , "Buscando dados ..." )
endif	

fChecaPar( "ZZ_AGLTSEQ" , "Sequencial de aglutinacao das TEDs. NAO PODE SER EXCLUSIVO"	, "000" 										, "C" )
fChecaPar( "ZZ_PUSERS" 	, "Usuarios que podem usar a rotina de preparacao de pagamento" , " " 											, "C" )
fChecaPar( "ZZ_AJUBOR" 	, "Indica se ajustara o sequencial do Bordero" 					, "S"     										, "C" )
fChecaPar( "ZZ_TAGLOG" 	, "Tag do Logo da Empresa"										, cTag  										, "C" )
fChecaPar( "ZZ_NUMBOR" 	, "Numero do Bordero Personalizado" 							, StrZero(0,Len(SE2->E2_NUMBOR))				, "C" )     
fChecaPar( "ZZ_CPDGAG" 	, "Campo do Digito da Agencia"									, 'A2_DVAGE'               						, "C" )
fChecaPar( "ZZ_CPDGCT" 	, "Campo do Digito da Conta"  									, 'A2_DVCTA'                        			, "C" )
fChecaPar( "ZZ_ATVBOR"  , "Liberacao de Bordero Ativo"                 					, "N"   										, "C" )
fChecaPar( "ZZ_SHOWNF"  , "Mostra o documento digitalizado"            					, "N"   										, "C" )
fChecaPar( "ZZ_USBUTAB" , "Usar o botao de abandonar"                  					, "S  "   										, "C" )
fChecaPar( "ZZ_BCOPADP" , "Informa o banco padrใo para pagamento"						, "   " 										, "C" )
fChecaPar( "ZZ_PADDARF" , "Informa o CNPJ padrใo para pagamento de DARF"				, "   " 										, "C" )
fChecaPar( "ZZ_USRVIEW"	, "Usuarios que serao somente leitura no painel"				, '      '             							, "C" )
fChecaPar( "ZZ_CNTERRB"	, "Contador do Estorno do Bordero com Impostos"					, '000000'             							, "C" )

fChecaPar( "ZZ_DDBRDA" 	, "Dias para o bordero automatico" 								, "002" 										, "N" )
fChecaPar( "ZZ_MINTED" 	, "Valor Minimo para Envio de TED" 								, "000" 										, "N" )
fChecaPar( "ZZ_MAXDOC" 	, "Valor Maximo para Envio de DOC" 								, "4999.99" 									, "N" )

fChecaPar( "ZZ_PEF050"  , "Executa PE da FINA050 na altera็ใo de dados do tํtulo"		, ".f." 										, "L" )
fChecaPar( "ZZ_AGLTTED" , "Aglutina as TEDs do mesmo fornecedor em um titulo"			, ".f." 										, "L" )
fChecaPar( "ZZ_PVALUSR" , "Valida ou nao o usuario na preparacao de pagamento"			, ".f." 										, "L" )
fChecaPar( "ZZ_XGERAUT" , "Gera Automaticmente o arquivo na pasta especificada"   		, ".f." 										, "L" )
fChecaPar( "ZZ_BINCFIL" , "Considera filial para a gera็ใo do bordero pagamento"   		, ".t."          								, "L" )
fChecaPar( "ZZ_MARKBOL" , "Marca como boleto automaticamente caso preenchido o CB"		, ".t." 										, "L" )
fChecaPar( "ZZ_BLQTITP" , "Bloqueia os titulos para evitar acesso em mais de um acesso"	, ".t." 										, "L" )
fChecaPar( "ZZ_MARKDEP" , "Marca como deposito automaticamente caso nao preenchido CB"	, iif( lFadel            , ".t."     , ".f." )	, "L" )
fChecaPar( "ZZ_XALTVCP" , "Altera ambos os vencimentos na alteracao de vencimento"   	, iif( lFadel            , ".t."     , ".f." )	, "L" )
fChecaPar( "ZZ_AGTFILC" , "Aglutina os tํtulos na Filial Centralizadora"             	, iif( lFadel            , ".t."     , ".f." )	, "L" )
fChecaPar( "ZZ_AGTBDIS" , "Aglutina Titulos com e sem impostos"                       	, iif( lFadel            , ".t."     , ".f." )	, "L" )
fChecaPar( "ZZ_LIMDTBX" , "Limpa o campo de Data de Baixa"                           	, iif( lFadel            , ".t."     , ".f." )	, "L" )
fChecaPar( "ZZ_TIPOADI"	, "Tipos de Titulo a Ser Considerado com Adiantamento"			, iif( lCheck .or. lCCL  , "NDF/CCA" , ""    )	, "C" )

if	lButAban
	Begin Transaction 
	if	lCont
		if	lChecaUsr
			if	lAdmin .or. ( RetCodUsr() $ SuperGetMv( "ZZ_PUSERS" , .f. , "" ) )
				aArr := fGestao(lJob,lCarga,aPar,xPosFlg,xPosStt,xLogRet,lBorder,xArr,xDia,lDesmarca)
			else
				MessageBox("Usuแrio nใo autorizado a usar a rotina.","Aten็ใo",MB_ICONHAND) 
			endif
		else
			aArr := fGestao(lJob,lCarga,aPar,xPosFlg,xPosStt,xLogRet,lBorder,xArr,xDia,lDesmarca)
		endif
	else
		if	dMaxDate >= StoD("20230531")		
			MessageBox("Perํodo de avalia็ใo encerrado.","Aten็ใo",MB_ICONHAND) 
		else      
			if	lChecaUsr
				if	lAdmin .or. ( RetCodUsr() $ SuperGetMv( "ZZ_PUSERS" , .f. , "" ) )
					aArr := fGestao(lJob,lCarga,aPar,xPosFlg,xPosStt,xLogRet,lBorder,xArr,xDia,lDesmarca)
				else
					MessageBox("Usuแrio nใo autorizado a usar a rotina.","Aten็ใo",MB_ICONHAND) 
				endif
			else
				aArr := fGestao(lJob,lCarga,aPar,xPosFlg,xPosStt,xLogRet,lBorder,xArr,xDia,lDesmarca)
			endif
		endif
	endif
	End Transaction 
else		
	if	lCont
		if	lChecaUsr
			if	lAdmin .or. ( RetCodUsr() $ SuperGetMv( "ZZ_PUSERS" , .f. , "" ) )
				aArr := fGestao(lJob,lCarga,aPar,xPosFlg,xPosStt,xLogRet,lBorder,xArr,xDia,lDesmarca)
			else
				MessageBox("Usuแrio nใo autorizado a usar a rotina.","Aten็ใo",MB_ICONHAND) 
			endif
		else
			aArr := fGestao(lJob,lCarga,aPar,xPosFlg,xPosStt,xLogRet,lBorder,xArr,xDia,lDesmarca)
		endif
	else
		if	dMaxDate >= StoD("20230531")
			MessageBox("Perํodo de avalia็ใo encerrado.","Aten็ใo",MB_ICONHAND) 
		else      
			if	lChecaUsr
				if	lAdmin .or. ( RetCodUsr() $ SuperGetMv( "ZZ_PUSERS" , .f. , "" ) )
					aArr := fGestao(lJob,lCarga,aPar,xPosFlg,xPosStt,xLogRet,lBorder,xArr,xDia,lDesmarca)
				else
					MessageBox("Usuแrio nใo autorizado a usar a rotina.","Aten็ใo",MB_ICONHAND) 
				endif
			else
				aArr := fGestao(lJob,lCarga,aPar,xPosFlg,xPosStt,xLogRet,lBorder,xArr,xDia,lDesmarca)
			endif
		endif
	endif
endif

cFilAnt := xFilAnt          

RestArea(aArea)

Return iif( lCarga , aArr , Nil )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fGestao(lJob,lCarga,aPar,xPosFlg,xPosStt,xLogRet,lBorder,xArr,xDia,lDesmarca)

Local aArray		:=	Nil      

Private xPar01 		:=	Nil
Private xPar02 		:=	Nil
Private xPar03 		:=	Nil
Private xPar04 		:=	Nil
Private xPar05 		:=	Nil
Private xPar06 		:=	Nil
Private xPar07 		:=	Nil
Private xPar08 		:=	Nil
Private xPar09 		:=	Nil
Private xPar10 		:=	Nil
Private xPar11 		:=	Nil
Private xPar12 		:=	Nil
Private xPriVez		:=	.t.
Private lAglFor		:=	.t.

Private aStruct		:=	SE2->(dbstruct())
Private nPosRec		:=	Len(aStruct) + 01
Private nPosFlg		:=	Len(aStruct) + 02
Private nPosNom		:=	Len(aStruct) + 03
Private nTipoPg		:=	Len(aStruct) + 04
Private nPosStt		:=	Len(aStruct) + 05
Private nPosPed		:=	Len(aStruct) + 06
Private nPosBco		:=	Len(aStruct) + 07
Private nPosAge		:=	Len(aStruct) + 08
Private nPosCon		:=	Len(aStruct) + 09
Private nAtuTpP		:=	Len(aStruct) + 10
Private nBcoDep		:=	Len(aStruct) + 11
Private nAgeDep		:=	Len(aStruct) + 12
Private nCtaDep		:=	Len(aStruct) + 13
Private nAltBcP		:=	Len(aStruct) + 14
Private nPosCdB		:=	Len(aStruct) + 15
Private nPosLnD		:=	Len(aStruct) + 16
Private nModCrd		:=	Len(aStruct) + 17
Private nCodCrd		:=	Len(aStruct) + 18
Private nVincPa		:=	Len(aStruct) + 19
Private nExcTit		:=	Len(aStruct) + 20
Private nLogRet		:=	Len(aStruct) + 21
Private nTipTit		:=	Len(aStruct) + 22
Private nModImp		:=	Len(aStruct) + 23
Private nModBor		:=	Len(aStruct) + 24
Private xModBor		:=	Len(aStruct) + 25
Private nBcoPag		:=	Len(aStruct) + 26
Private nBorUsu		:=	Len(aStruct) + 27
Private nBorDat		:=	Len(aStruct) + 28
Private nBorHor		:=	Len(aStruct) + 29
Private nColApv		:=	Len(aStruct) + 30
Private nPosMsg		:=	Len(aStruct) + 31
Private nSldPis		:=	Len(aStruct) + 32
Private nSldCof		:=	Len(aStruct) + 33
Private nSldCsl		:=	Len(aStruct) + 34
Private nSldLiq		:=	Len(aStruct) + 35
Private nDigAge		:=	Len(aStruct) + 36
Private nDigCta		:=	Len(aStruct) + 37
Private nTipCta		:=	Len(aStruct) + 38
Private nPosBen		:=	Len(aStruct) + 39
Private nCgcBen		:=	Len(aStruct) + 40
Private nCgcFor		:=	Len(aStruct) + 41
Private nPrfPag		:=	Len(aStruct) + 42
Private nPosOrd		:=	Len(aStruct) + 43
Private nFormPg		:=	Len(aStruct) + 44
Private nAltTrb		:=	Len(aStruct) + 45
Private nRecSA2		:=	Len(aStruct) + 46           
Private xCodCrd		:=	Len(aStruct) + 47
Private nNfePDF		:=	Len(aStruct) + 48
Private nDirPDF		:=	Len(aStruct) + 49
Private nRecPDF		:=	Len(aStruct) + 50
Private nFinPDF		:=	Len(aStruct) + 51
Private nSeqArr		:=	Len(aStruct) + 52           
Private nGerAut		:=	Len(aStruct) + 53           
Private nDirAut		:=	Len(aStruct) + 54           
Private nEmlFor		:=	Len(aStruct) + 55           
Private nChkDoc		:=	Len(aStruct) + 56           
Private nRecSEA		:=	Len(aStruct) + 57           
Private nFilCen		:=	Len(aStruct) + 58           
Private nCndPed		:=	Len(aStruct) + 59           
Private nTemPix		:=	Len(aStruct) + 60           
Private nTipPix		:=	Len(aStruct) + 61           
Private nChvPix		:=	Len(aStruct) + 62           
Private nDirImg		:=	Len(aStruct) + 63           
Private nAglFor		:=	Len(aStruct) + 64           
Private nMsgErr		:=	Len(aStruct) + 65           
Private nTamTot		:=	Len(aStruct) + 66           

Private lShowImp	:=	.t.
Private lShowPed	:=	.t.
Private lShowBxa	:=	.t.      

Private xGestao 	:=	FwSizeFilial() > 2 
Private xTamEmp 	:= 	Len(FwSm0LayOut(Nil,1))
Private xTamUnNeg 	:= 	Len(FwSm0LayOut(Nil,2))

Private lShowNf		:=	GetMv("ZZ_SHOWNF") == "S"       
Private cTipAdi		:=	GetMv("ZZ_TIPOADI") 

Private lPix		:=	AliasInDic("F72")
Private lFin050		:=	GetMv("ZZ_PEF050") 
Private lIncFil		:=	GetMv("ZZ_BINCFIL")
Private lFilCen 	:=	GetMv("ZZ_AGTFILC")
Private lAgtAll 	:=	GetMv("ZZ_AGTBDIS")
Private lAglTED		:=	GetMv("ZZ_AGLTTED") 
Private lLibPag		:=	GetMv("MV_CTLIPAG")    
Private nTamCrg		:=	TamSx3("E2_ZZCRGRT")[1]  	  
Private lOracle		:=	"ORACLE" $ Upper(Alltrim(TcGetDB())) 
Private xGerAut		:=	GetMv("ZZ_XGERAUT") .and. SEA->(FieldPos("EA_ZZARQGR")) <> 0 .and. SA6->(FieldPos("A6_ZZDRGVP")) <> 0

Private cPerg		:= 	"PRPPGTO"    
Private lAtivo		:=	SuperGetMv("ZZ_ATVBOR",.f.,'N') == "S" .and. AliasInDic("ZAT") .and. AliasInDic("ZAV") 
Private nMaxDoc		:=	SuperGetMv("ZZ_MAXDOC",.f.,4999.99)	   
Private nMinTed		:=	SuperGetMv("ZZ_MINTED",.f.,000)	   
Private nQtdApr		:=	SuperGetMv("ZZ_QTDBOR",.f.,002) 
Private lNewIndice	:=	FaVerInd()  

Private cDigAge		:=	GetMv("ZZ_CPDGAG")
Private cDigCta		:=	GetMv("ZZ_CPDGCT")
Private lUsrView	:=	RetCodUsr() $ GetMv("ZZ_USRVIEW")

Default xArr		:=	{}
Default aPar		:=	{}
Default lJob		:=	.f.
Default lCarga		:=	.f.   
Default lBorder		:=	.f.
Default xPosFlg		:=	nPosFlg	
Default xPosStt		:=	nPosStt	
Default xLogRet		:=	nLogRet	      
Default lDesmarca	:=	.f.

if !lIncFil .and. !xGestao .and. FwModeAccess("SEA") == "E"
	if	lJob
		ConOut("Para usar a gera็ใo de border๔ multifilial, a tabela SEA deve estar compartilhada","Aten็ใo",MB_ICONHAND) 
	else
		MessageBox("Para usar a gera็ใo de border๔ multifilial, a tabela SEA deve estar compartilhada","Aten็ใo",MB_ICONHAND) 
	endif  
	lIncFil	:=	.t.
endif

if !lJob
	if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
	//	lAdoro 		:=	.t.
	//	lFilCen		:=	.f.
	//	lAglTED		:=	.t. 
		xGerAut		:=	.f.	
		lUsrView	:=	MessageBox('Abrir como somente leitura ?',"Aten็ใo",MB_YESNO) == 6      
	endif
endif

if	lCCL .or. lCheck .or. lMastra 
	lAtivo			:=	SuperGetMv("ZZ_ATVBOR",.f.,'N') == "S" .and. AliasInDic("Z43") .and. AliasInDic("Z44") 
endif
	
if	lShowNf
	lShowNf			:=	SF1->(FieldPos("F1_ZZPDF")) <> 0 .and. SE2->(FieldPos("E2_ZZPDF")) <> 0
endif

if	lShowNf
	lShowNf			:=	lCCL .or. lCheck
endif

if	lAglTED
	lAglTED			:=	SE2->(FieldPos("E2_ZZVLTED")) <> 0 .and. SE2->(FieldPos("E2_ZZSQTED")) <> 0	
endif 

dbselectarea("SE2")
dbsetorder(1)

if	lAtivo
	if	lCCL .or. lCheck .or. lMastra 
		if	AliasInDic("Z43") 
			dbselectarea("Z43")
			dbsetorder(1)     
		endif
		if	AliasInDic("Z44") 
			dbselectarea("Z44")
			dbsetorder(1)
		endif
	else
		if	AliasInDic("ZAT") 
			dbselectarea("ZAT")
			dbsetorder(1)     
		endif
		if	AliasInDic("ZAV") 
			dbselectarea("ZAV")
			dbsetorder(1)
		endif
	endif
endif
		
dbselectarea("SEA")
dbsetorder(1)

ValidPerg()   

if	lCarga .or. lBorder .or. lDesmarca
	if	lDesmarca
		fCleanTit(Nil,Nil,@xArr)
    else
		aArray 		:= 	{}
		xPar01 		:= 	aPar[01]
		xPar02 		:= 	aPar[02]
		xPar03 		:= 	aPar[03]
		xPar04 		:= 	Alltrim(aPar[04])
		xPar05 		:= 	Alltrim(aPar[05])
		xPar06 		:= 	aPar[06]
		xPar07 		:= 	aPar[07]
		xPar08 		:= 	aPar[08]
		xPar09 		:= 	aPar[09]
		xPar10 		:= 	aPar[10]
		xPar11 		:= 	aPar[11]
		xPar12 		:= 	aPar[12]
		lShowImp	:=	aPar[10] == 1
		lShowPed	:=	aPar[11] == 1
		lShowBxa	:=	aPar[12] == 1
		if	lCarga
			fCarga(@aArray,Nil,Nil,lJob) 
		elseif	lBorder
			fGeraBor(Nil,Nil,@xArr,lJob,xDia)
	    endif
    endif
else
	mv_par01	:=	Nil
	mv_par02	:=	Nil
	mv_par03	:=	Nil
	mv_par04	:=	Nil
	mv_par05	:=	Nil
	mv_par06	:=	Nil
	mv_par07	:=	Nil
	mv_par08	:=	Nil
	mv_par09	:=	Nil
	mv_par10	:=	Nil
	mv_par11	:=	Nil
	mv_par12	:=	Nil
	if	Pergunte(cPerg,.t.)
		xPar01 		:= 	mv_par01
		xPar02 		:= 	mv_par02
		xPar03 		:= 	mv_par03
		xPar04 		:= 	Alltrim(mv_par04)
		xPar05 		:= 	Alltrim(mv_par05)
		xPar06 		:= 	mv_par06
		xPar07 		:= 	mv_par07
		xPar08 		:= 	mv_par08
		xPar09 		:= 	mv_par09
		xPar10 		:= 	mv_par10
		xPar11 		:= 	mv_par11
		xPar12 		:= 	mv_par12
		lShowImp	:=	mv_par10 == 1
		lShowPed	:=	mv_par11 == 1
		lShowBxa	:=	mv_par12 == 1       
		aStruct		:=	SE2->(dbstruct())
		if	xPar03 <= 3
			if !Empty(xPar04) .and. !(";" $ xPar04) .and. Len(AllTrim(xPar04)) > 3
				MessageBox("Separe os tipos que nใo deseja carregar por um ; (ponto e virgula) a cada 3 caracteres","Aten็ใo",MB_ICONHAND) 
				Return
			endif	
			if !Empty(xPar05) .and. !(";" $ xPar05) .and. Len(AllTrim(xPar05)) > 3
				MessageBox("Separe os tipos deseja carregar por um ; (ponto e virgula) a cada 3 caracteres","Aten็ใo",MB_ICONHAND) 
				Return
			endif	
		endif	
		fPainel()            
	endif
endif

Return iif( lCarga , aArray , Nil )

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

Local nT 		:= 	FwSizeFilial()      
Local oObj		:= 	GeneralClass():New()

oObj:PutSx1(cPerg,"01","Vencimento de        ","","","mv_ch1","D",08,0,0,"G","","      ","","","mv_par01","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"02","Vencimento ate       ","","","mv_ch2","D",08,0,0,"G","","      ","","","mv_par02","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"03","Trazer Tit Bordero   ","","","mv_ch3","N",01,0,0,"C","","      ","","","mv_par03","Sim","","","","Nao","","","Ambos","","","Desbloquear","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"04","Nใo Trazer Tipos     ","","","mv_ch4","C",21,0,0,"G","","      ","","","mv_par04","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"05","Trazer Apenas Tipos  ","","","mv_ch5","C",21,0,0,"G","","      ","","","mv_par05","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"06","Filial de            ","","","mv_ch6","C",nT,0,0,"G","","SM0EMP","","","mv_par06","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"07","Filial ate           ","","","mv_ch7","C",nT,0,0,"G","","SM0EMP","","","mv_par07","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"08","Emissao de           ","","","mv_ch8","D",08,0,0,"G","","      ","","","mv_par08","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"09","Emissao ate          ","","","mv_ch9","D",08,0,0,"G","","      ","","","mv_par09","   ","","","","   ","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"10","Mostrar Col. Impostos","","","mv_cha","N",01,0,0,"C","","      ","","","mv_par10","Sim","","","","Nao","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"11","Mostrar Col. Pedidos ","","","mv_chb","N",01,0,0,"C","","      ","","","mv_par11","Sim","","","","Nao","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"12","Trazer Tit. Baixados ","","","mv_chc","N",01,0,0,"C","","      ","","","mv_par12","Sim","","","","Nao","","","     ","","","           ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fPainel()

Local oDlg			
Local oQtd			
Local oSay1			
Local oSay2			
Local oSay3			
Local oGrid     
Local oMenu
Local xMenu		
Local oTotal                     
Local oCombo  
Local cCabec       
Local aArray
Local aArrOri	
Local oTButton1
Local oTButton2
Local oTButton3
Local oTButton4
Local oTButton5
Local oTButton6

Local nQtd			:=  000
Local nOpc			:= 	000
Local nTotal		:=  000       

Local xOk			:=	.f.     
Local bBlocoAb		:=	{ || xOk := MsgYesNo("Confirma a็ใo de abandonar e reverter todas as movimenta็๕es ?") , Eval(bBlkAbEx) } 
//Local bBlkAbEx	:=	{ || iif( xOk , DisarmTransaction() , Nil ) , iif( xOk , oDlg:End() , Nil ) } 

Local aItens 		:=	{ "Sim" , "Nใo" }
Local cCombo 		:=	aItens[02]

Local aSize   		:= 	MsAdvSize(Nil,.f.,430)
Local aInfo   		:= 	{ aSize[1] , aSize[2] , aSize[3] , aSize[4] , 0 , 0 }
Local aObjects		:= 	{{040,040,.t.,.t.},{100,100,.t.,.t.},{020,020,.t.,.t.}}
Local aPosObj 		:= 	MsObjSize(aInfo,aObjects,.f.)
Local nAltu			:=	aPosObj[3,3] - 18 
Local nLarg			:=	aPosObj[3,4]

Local oCn      		:=	LoadBitmap( GetResources() , "BR_CANCEL.PNG"		)
Local oEr      		:=	LoadBitmap( GetResources() , "METAS_BAIXO_16.PNG"	)

Local oTV      		:=	LoadBitmap( GetResources() , "PMSEDT1.BMP"	 		)
Local oTA      		:=	LoadBitmap( GetResources() , "PMSEDT2.BMP"	 		)
Local oTD      		:=	LoadBitmap( GetResources() , "PMSEDT3.PNG"	 		)
Local oTC      		:=	LoadBitmap( GetResources() , "PMSEDT4.PNG"	 		)
Local oImp     		:=	LoadBitmap( GetResources() , "CSAIMG16.PNG"	 		)

Local oNo			:=	LoadBitmap( GetResources() , "LBNO"			 		)
Local oOk	    	:= 	LoadBitmap( GetResources() , "LBOK"			 		)
Local oMk	    	:= 	LoadBitmap( GetResources() , "LBTIK"		 		)
Local oVerd    		:=	LoadBitmap( GetResources() , "ENABLE"		 		)
Local oVerm    		:=	LoadBitmap( GetResources() , "DISABLE"		 		)
Local oAzul    		:=	LoadBitmap( GetResources() , "BR_AZUL"		 		)
Local oCinz    		:=	LoadBitmap( GetResources() , "BR_CINZA"		 		)
Local oBran    		:=	LoadBitmap( GetResources() , "BR_BRANCO"	 		)
Local oMarr    		:=	LoadBitmap( GetResources() , "BR_MARROM"	 		)
Local oAmar    		:=	LoadBitmap( GetResources() , "BR_AMARELO"	 		)
Local oLara    		:=	LoadBitmap( GetResources() , "BR_LARANJA"	 		)
Local oViol    		:=	LoadBitmap( GetResources() , "BR_VIOLETA"	 		)      

Private lFiltrar	:=	.f.

Processa( { || CursorWait() , aArray := {} , fCarga(@aArray) , CursorArrow() } , "Buscando Dados...")     

if 	Len(aArray) <= 0
	MessageBox('Nenhum tํtulo foi encontrado para os parโmetros informados.',"Aten็ใo",MB_ICONHAND) 
	Return
endif

cCabec := iif( xPar03 == 4 , "Liberar Itens Bloqueados" , "Painel de Prepara็ใo para Pagamento" )

Setapilha()
Define MsDialog oDlg Title cCabec From aSize[7],0 To aSize[6],aSize[5] Of oMainWnd Pixel

oDlg:lEscClose 	:= 	.f.                   
oDlg:lMaximized := 	.t.   

Menu oMenu PopUp
	MenuItem "Marca Todos" 								Action Eval( { || aEval( aArray , { |x| x[nPosFlg] := ( ! x[nPosStt] $  "8/9" )	} ) , xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	MenuItem "Desmarca Todos"  							Action Eval( { || aEval( aArray , { |x| x[nPosFlg] := .f. 						} ) , xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	MenuItem "Marcar Tํtulos Liberados"  				Action Eval( { || aEval( aArray , { |x| x[nPosFlg] := (   x[nPosStt] $  "1/5" ) } ) , xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	MenuItem "Marcar Tํtulos de um Banco"  				Action Eval( { || fMarkBank(@oDlg,@oGrid,@aArray) 									, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	MenuItem "Marcar Tํtulos de uma Filial"    			Action Eval( { || fMarkFili(@oDlg,@oGrid,@aArray) 									, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	MenuItem "Marcar Tํtulos de uma Natureza"  			Action Eval( { || fMarkNatu(@oDlg,@oGrid,@aArray) 									, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	MenuItem "Marcar Tํtulos de um Fornecedor"  		Action Eval( { || fMarkForn(@oDlg,@oGrid,@aArray) 									, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	MenuItem "Marcar Tํtulos de um Tipo de Pagto"		Action Eval( { || fMarkTipo(@oDlg,@oGrid,@aArray) 									, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	MenuItem "Marcar Tํtulos Vinculados a PA"  			Action Eval( { || aEval( aArray , { |x| x[nPosFlg] := (   x[nPosStt] == "3"   )	} ) , xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	MenuItem "Marcar Tํtulos Aguardando Libera็ใo"  	Action Eval( { || aEval( aArray , { |x| x[nPosFlg] := (   x[nPosStt] == "2"   )	} ) , xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	MenuItem "Marcar Tํtulos Vinculados a Border๔"  	Action Eval( { || aEval( aArray , { |x| x[nPosFlg] := (   x[nPosStt] == "4"   )	} ) , xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	if	SE2->(FieldPos("E2_ZZMSGER")) <> 0 
		MenuItem "Marcar Tํtulos com Mensagem de Erro"	Action Eval( { || aEval( aArray , { |x| x[nPosFlg] := !Empty(x[nMsgErr])		} ) , xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	endif 
	if	xPar03 <= 3	.and. lShowNf 
		MenuItem "Marcar Tํtulos sem Documento Anexado"	Action Eval( { || aEval( aArray , { |x| x[nPosFlg] := !x[nNfePDF]				} ) , xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
	endif
	MenuItem "Desmarcar Tํtulos com Dados Faltantes"	Action Eval( { || fCleanTit(@oDlg,@oGrid,@aArray) 									, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) , oGrid:Refresh() })
EndMenu

oGrid := TcBrowse():New(003,003,nLarg - 005,nAltu - 010,,,,oDlg,,,,,,,,,,,,.f.,,.t.,,.f.,,,,)

if	lMando
	if	lUsrView .and. xPar03 <= 3
		oGrid:AddColumn( TcColumn():New( " "   				,{ || xRetCores(oGrid,aArray,oVerd,oVerm,oBran,oAmar,oCinz,oAzul,oLara,oViol,oTV,oTA,oTD,oTC,oMarr)	}	, "@!"								,,,"CENTER"	 	,015,.t.,.f.,,,,.f.,) )		
	elseif	xPar03 <= 3	
		oGrid:AddColumn( TcColumn():New( " "    			,{ || iif(aArray[oGrid:nAt,nPosFlg],oOk,oNo)														}	, "@!"								,,,"CENTER"	 	,015,.t.,.f.,,,,.f.,) ) 	
		oGrid:AddColumn( TcColumn():New( " "   				,{ || xRetCores(oGrid,aArray,oVerd,oVerm,oBran,oAmar,oCinz,oAzul,oLara,oViol,oTV,oTA,oTD,oTC,oMarr)	}	, "@!"								,,,"CENTER"	 	,015,.t.,.f.,,,,.f.,) )		
	endif
	if	xPar03 <= 3	.and. lShowNf
		oGrid:AddColumn( TcColumn():New( "Nfe"    			,{ || iif(aArray[oGrid:nAt,nChkDoc] == Nil,Nil,iif(aArray[oGrid:nAt,nChkDoc],oMk,oEr))				}	, "@!"								,,,"CENTER"	 	,022,.t.,.f.,,,,.f.,) ) 	
	endif
	if	xPar03 <= 3	.and. SE2->(FieldPos('E2_ZZMSGFN')) <> 0 	
		oGrid:AddColumn( TcColumn():New( "Msg"    			,{ || iif(aArray[oGrid:nAt,nPosMsg],oMk,oCn)														}	, "@!"								,,,"CENTER"	 	,022,.t.,.f.,,,,.f.,) ) 	
	endif
	oGrid:AddColumn( TcColumn():New( "Prefixo"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_PREFIXO"))]												}	, PesqPict("SE2","E2_PREFIXO")		,,,"CENTER"	 	,033,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Numero"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NUM"))]  													}	, PesqPict("SE2","E2_NUM")			,,,"CENTER"	 	,040,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Tipo"    				,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_TIPO"))]  												}	, PesqPict("SE2","E2_TIPO")			,,,"CENTER"	 	,025,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Fornecedor"		   	,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_FORNECE"))]												}	, PesqPict("SE2","E2_FORNECE")  	,,,"CENTER" 	,047,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Nome Fornecedor"		,{ || aArray[oGrid:nAt,nPosNom]																		}	, PesqPict("SA2","A2_NOME")  		,,,"LEFT" 	 	,150,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Venc Real"			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_VENCREA"))]												}	, PesqPict("SE2","E2_VENCREA")  	,,,"CENTER"    	,043,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Saldo"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_SALDO"))]  												}	, PesqPict("SE2","E2_SALDO")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Saldo Liq."    		,{ || aArray[oGrid:nAt,nSldLiq]  																	}	, PesqPict("SE2","E2_SALDO")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Tipo Pag"       		,{ || aArray[oGrid:nAt,nTipoPg]																		}	,                            		,,,"LEFT" 	 	,040,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Codigo de Barras"		,{ || aArray[oGrid:nAt,nPosCdB]  																	}	, "@!"								,,,"CENTER"	 	,150,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Parcela"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_PARCELA"))]  												}	, PesqPict("SE2","E2_PARCELA")		,,,"CENTER"	 	,030,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Banco Pg" 	    	,{ || aArray[oGrid:nAt,nPosBco]																		}	, "@!"                       		,,,"CENTER"	 	,038,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Agencia Pg"      		,{ || aArray[oGrid:nAt,nPosAge]																		}	, "@!"                         		,,,"CENTER" 	,040,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Conta Pg"  			,{ || aArray[oGrid:nAt,nPosCon]																		}	, "@!"                         		,,,"CENTER" 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Bordero"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NUMBOR"))]  												}	, PesqPict("SE2","E2_NUMBOR")		,,,"CENTER"	 	,038,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Modelo"       		,{ || aArray[oGrid:nAt,nModCrd]																		}	,                            		,,,"LEFT" 	 	,050,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Banco Dp" 	    	,{ || aArray[oGrid:nAt,nBcoDep]																		}	, "@!"                         		,,,"CENTER"	 	,038,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Agencia Dp"      		,{ || aArray[oGrid:nAt,nAgeDep]																		}	, "@!"                         		,,,"CENTER" 	,040,.f.,.f.,,,,.f.,) )		
	if	SA2->(FieldPos(cDigAge)) <> 0
		oGrid:AddColumn( TcColumn():New( "Dig Ag Dp"      	,{ || aArray[oGrid:nAt,nDigAge]																		}	, "@!"                         		,,,"CENTER" 	,030,.f.,.f.,,,,.f.,) )		
	endif
	oGrid:AddColumn( TcColumn():New( "Conta Dp"  			,{ || aArray[oGrid:nAt,nCtaDep]																		}	, "@!"                         		,,,"CENTER" 	,045,.f.,.f.,,,,.f.,) )		
	if	SA2->(FieldPos(cDigCta)) <> 0
		oGrid:AddColumn( TcColumn():New( "Dig Ct Dp"      	,{ || aArray[oGrid:nAt,nDigCta]																		}	, "@!"                         		,,,"CENTER" 	,030,.f.,.f.,,,,.f.,) )		
	endif
	oGrid:AddColumn( TcColumn():New( "Vencimento"			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_VENCTO"))]												}	, PesqPict("SE2","E2_VENCTO")  		,,,"CENTER"  	,043,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Valor"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_VALOR"))]  												}	, PesqPict("SE2","E2_VALOR")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Acrescimo"    		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_ACRESC"))]  												}	, PesqPict("SE2","E2_ACRESC")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Decrescimo"    		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_DECRESC"))]  												}	, PesqPict("SE2","E2_DECRESC")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Hist๓rico"    		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_HIST"))]  												}	, PesqPict("SE2","E2_HIST")			,,,"LEFT"	 	,150,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Emissใo"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_EMISSAO"))]  												}	, PesqPict("SE2","E2_EMISSAO")		,,,"CENTER"	 	,043,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Sld Acres"    		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_SDACRES"))]  												}	, PesqPict("SE2","E2_SDACRES")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Sld Decres"    		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_SDDECRE"))]  												}	, PesqPict("SE2","E2_SDDECRE")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	if	lPix
		oGrid:AddColumn( TcColumn():New( "Tipo Chave"  		,{ || aArray[oGrid:nAt,nTipPix]																		}	, "@!"                         		,,,"LEFT"	 	,055,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Chave PIX"     	,{ || aArray[oGrid:nAt,nChvPix]																		}	, "@!"                         		,,,"LEFT"	 	,120,.f.,.f.,,,,.f.,) )		
	endif
	if	lShowImp
		oGrid:AddColumn( TcColumn():New( "Pis"         		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_PIS"))] 	 												}	, PesqPict("SE2","E2_PIS")			,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Cofins"      		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_COFINS"))]  												}	, PesqPict("SE2","E2_COFINS")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Csll"        		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_CSLL"))] 	 												}	, PesqPict("SE2","E2_CSLL")			,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Sest"        		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_SEST"))] 	 												}	, PesqPict("SE2","E2_SEST")			,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	endif
	if	lAtivo
		oGrid:AddColumn( TcColumn():New( "Us Bord"     		,{ || aArray[oGrid:nAt,nBorUsu]																		}	, "@!"                         		,,,"CENTER"	 	,070,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Dt Bord" 	    	,{ || aArray[oGrid:nAt,nBorDat]																		}	, "@!"                         		,,,"CENTER"	 	,040,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Hr Bord"     		,{ || aArray[oGrid:nAt,nBorHor]																		}	, "@!"                         		,,,"CENTER" 	,040,.f.,.f.,,,,.f.,) )		
	endif
	if	lShowPed
		oGrid:AddColumn( TcColumn():New( "Pedido"      		,{ || aArray[oGrid:nAt,nPosPed]																		}	, PesqPict("SC7","C7_NUM") 			,,,"CENTER"	 	,035,.f.,.f.,,,,.f.,) )		
	endif
	if	lShowPed .and. lFadel
		oGrid:AddColumn( TcColumn():New( "Cond. Pag."		,{ || aArray[oGrid:nAt,nCndPed]																		}	, PesqPict("SC7","C7_COND") 		,,,"LEFT"	 	,050,.f.,.f.,,,,.f.,) )		
	endif
	oGrid:AddColumn( TcColumn():New( "Filial"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_FILIAL"))]												}	, PesqPict("SE2","E2_FILIAL")		,,,"CENTER"	 	,027,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Loja"		   			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_LOJA"))]													}	, PesqPict("SE2","E2_LOJA")  		,,,"CENTER"    	,025,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Natureza"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NATUREZ"))]  												}	, PesqPict("SE2","E2_NATUREZ")		,,,"LEFT"	 	,040,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Linha Digitavel"		,{ || aArray[oGrid:nAt,nPosLnD]  																	}	, "@!"								,,,"CENTER"	 	,170,.f.,.f.,,,,.f.,) )		
else
	if	lUsrView .and. xPar03 <= 3	
		oGrid:AddColumn( TcColumn():New( " "   				,{ || xRetCores(oGrid,aArray,oVerd,oVerm,oBran,oAmar,oCinz,oAzul,oLara,oViol,oTV,oTA,oTD,oTC,oMarr)	}	, "@!"								,,,"CENTER"	 	,015,.t.,.f.,,,,.f.,) )		
	elseif	xPar03 <= 3	
		oGrid:AddColumn( TcColumn():New( " "    			,{ || iif(aArray[oGrid:nAt,nPosFlg],oOk,oNo)														}	, "@!"								,,,"CENTER"	 	,015,.t.,.f.,,,,.f.,) ) 	
		oGrid:AddColumn( TcColumn():New( " "   				,{ || xRetCores(oGrid,aArray,oVerd,oVerm,oBran,oAmar,oCinz,oAzul,oLara,oViol,oTV,oTA,oTD,oTC,oMarr)	}	, "@!"								,,,"CENTER"	 	,015,.t.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Imp"    			,{ || oImp																							}	, "@!"								,,,"CENTER"	 	,022,.t.,.f.,,,,.f.,) ) 	
	endif
	if	xPar03 <= 3	.and. lShowNf 
		oGrid:AddColumn( TcColumn():New( "Nfe"    			,{ || iif(aArray[oGrid:nAt,nChkDoc] == Nil,Nil,iif(aArray[oGrid:nAt,nChkDoc],oMk,oEr))				}	, "@!"								,,,"CENTER"	 	,022,.t.,.f.,,,,.f.,) ) 	
	endif
	if	xPar03 <= 3 .and. SE2->(FieldPos('E2_ZZMSGFN')) <> 0 
		oGrid:AddColumn( TcColumn():New( "Msg"    			,{ || iif(aArray[oGrid:nAt,nPosMsg],oMk,oCn)														}	, "@!"								,,,"CENTER"	 	,022,.t.,.f.,,,,.f.,) ) 	
	endif
	oGrid:AddColumn( TcColumn():New( "Filial"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_FILIAL"))]												}	, PesqPict("SE2","E2_FILIAL")		,,,"CENTER"	 	,027,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Prefixo"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_PREFIXO"))]												}	, PesqPict("SE2","E2_PREFIXO")		,,,"CENTER"	 	,033,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Numero"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NUM"))]  													}	, PesqPict("SE2","E2_NUM")			,,,"CENTER"	 	,040,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Parcela"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_PARCELA"))]  												}	, PesqPict("SE2","E2_PARCELA")		,,,"CENTER"	 	,030,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Tipo"    				,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_TIPO"))]  												}	, PesqPict("SE2","E2_TIPO")			,,,"CENTER"	 	,025,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Fornecedor"		   	,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_FORNECE"))]												}	, PesqPict("SE2","E2_FORNECE")  	,,,"CENTER" 	,047,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Loja"		   			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_LOJA"))]													}	, PesqPict("SE2","E2_LOJA")  		,,,"CENTER"    	,025,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Razใo Social"			,{ || aArray[oGrid:nAt,nPosNom]																		}	, PesqPict("SA2","A2_NOME")  		,,,"LEFT" 	 	,150,.f.,.f.,,,,.f.,) )		
	if	lAdoro 
		oGrid:AddColumn( TcColumn():New( "Nome Fantasia"	,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NOMFOR"))]												}	, PesqPict("SE2","E2_FORNECE")  	,,,"LEFT" 		,090,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "CPF/CNPJ"			,{ || aArray[oGrid:nAt,nCgcFor]																		}	, "@!"  							,,,"LEFT" 	 	,055,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "CPF/CNPJ Ben"		,{ || aArray[oGrid:nAt,nCgcBen]																		}	, "@!"  							,,,"LEFT" 	 	,055,.f.,.f.,,,,.f.,) )		
	endif 
	oGrid:AddColumn( TcColumn():New( "Venc Real"			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_VENCREA"))]												}	, PesqPict("SE2","E2_VENCREA")  	,,,"CENTER"    	,043,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Saldo"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_SALDO"))]  												}	, PesqPict("SE2","E2_SALDO")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Saldo Liq."    		,{ || aArray[oGrid:nAt,nSldLiq]  																	}	, PesqPict("SE2","E2_SALDO")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Codigo de Barras"		,{ || aArray[oGrid:nAt,nPosCdB]  																	}	, "@!"								,,,"CENTER"	 	,150,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Tipo Pag"       		,{ || aArray[oGrid:nAt,nTipoPg]																		}	,                            		,,,"LEFT" 	 	,040,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Banco Pg" 	    	,{ || aArray[oGrid:nAt,nPosBco]																		}	, "@!"                       		,,,"CENTER"	 	,038,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Agencia Pg"      		,{ || aArray[oGrid:nAt,nPosAge]																		}	, "@!"                         		,,,"CENTER" 	,040,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Conta Pg"  			,{ || aArray[oGrid:nAt,nPosCon]																		}	, "@!"                         		,,,"CENTER" 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Bordero"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NUMBOR"))]  												}	, PesqPict("SE2","E2_NUMBOR")		,,,"CENTER"	 	,038,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Modelo"       		,{ || aArray[oGrid:nAt,nModCrd]																		}	,                            		,,,"LEFT" 	 	,050,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Banco Dp" 	    	,{ || aArray[oGrid:nAt,nBcoDep]																		}	, "@!"                         		,,,"CENTER"	 	,038,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Agencia Dp"      		,{ || aArray[oGrid:nAt,nAgeDep]																		}	, "@!"                         		,,,"CENTER" 	,040,.f.,.f.,,,,.f.,) )		
	if	SA2->(FieldPos(cDigAge)) <> 0                                                                                                                       	
		oGrid:AddColumn( TcColumn():New( "Dig Ag Dp"      	,{ || aArray[oGrid:nAt,nDigAge]																		}	, "@!"                         		,,,"CENTER" 	,030,.f.,.f.,,,,.f.,) )		
	endif	
	oGrid:AddColumn( TcColumn():New( "Conta Dp"      		,{ || aArray[oGrid:nAt,nCtaDep]																		}	, "@!"                         		,,,"CENTER" 	,050,.f.,.f.,,,,.f.,) )		
	if	SA2->(FieldPos(cDigCta)) <> 0
		oGrid:AddColumn( TcColumn():New( "Dig Ct Dp"      	,{ || aArray[oGrid:nAt,nDigCta]																		}	, "@!"                         		,,,"CENTER" 	,030,.f.,.f.,,,,.f.,) )		
	endif
	oGrid:AddColumn( TcColumn():New( "Natureza"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_NATUREZ"))]  												}	, PesqPict("SE2","E2_NATUREZ")		,,,"CENTER"	 	,040,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Vencimento"			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_VENCTO"))]												}	, PesqPict("SE2","E2_VENCTO")  		,,,"CENTER"  	,043,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Valor"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_VALOR"))]  												}	, PesqPict("SE2","E2_VALOR")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Acrescimo"    		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_ACRESC"))]  												}	, PesqPict("SE2","E2_ACRESC")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Decrescimo"    		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_DECRESC"))]  												}	, PesqPict("SE2","E2_DECRESC")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Hist๓rico"    		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_HIST"))]  												}	, PesqPict("SE2","E2_HIST")			,,,"LEFT"	 	,150,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Emissใo"    			,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_EMISSAO"))]  												}	, PesqPict("SE2","E2_EMISSAO")		,,,"CENTER"	 	,043,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Sld Acres"    		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_SDACRES"))]  												}	, PesqPict("SE2","E2_SDACRES")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	oGrid:AddColumn( TcColumn():New( "Sld Decres"    		,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_SDDECRE"))]  												}	, PesqPict("SE2","E2_SDDECRE")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	if	lPix
		oGrid:AddColumn( TcColumn():New( "Tipo Chave"  		,{ || aArray[oGrid:nAt,nTipPix]																		}	, "@!"                         		,,,"LEFT"	 	,055,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Chave PIX"     	,{ || aArray[oGrid:nAt,nChvPix]																		}	, "@!"                         		,,,"LEFT"	 	,120,.f.,.f.,,,,.f.,) )		
	endif
	if	lShowImp
		oGrid:AddColumn( TcColumn():New( "Pis"           	,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_PIS"))] 	 												}	, PesqPict("SE2","E2_PIS")			,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Cofins"          	,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_COFINS"))]  												}	, PesqPict("SE2","E2_COFINS")		,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Csll"           	,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_CSLL"))] 	 												}	, PesqPict("SE2","E2_CSLL")			,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Sest"           	,{ || aArray[oGrid:nAt,SE2->(FieldPos("E2_SEST"))] 	 												}	, PesqPict("SE2","E2_SEST")			,,,"RIGHT"	 	,045,.f.,.f.,,,,.f.,) )		
	endif
	if	lAtivo
		oGrid:AddColumn( TcColumn():New( "Us Bord"      	,{ || aArray[oGrid:nAt,nBorUsu]																		}	, "@!"                         		,,,"CENTER"	 	,070,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Dt Bord" 		    ,{ || aArray[oGrid:nAt,nBorDat]																		}	, "@!"                         		,,,"CENTER"	 	,040,.f.,.f.,,,,.f.,) )		
		oGrid:AddColumn( TcColumn():New( "Hr Bord"      	,{ || aArray[oGrid:nAt,nBorHor]																		}	, "@!"                         		,,,"CENTER" 	,040,.f.,.f.,,,,.f.,) )		
	endif
	if	lShowPed
		oGrid:AddColumn( TcColumn():New( "Pedido"       	,{ || aArray[oGrid:nAt,nPosPed]																		}	, PesqPict("SC7","C7_NUM") 			,,,"CENTER"	 	,035,.f.,.f.,,,,.f.,) )		
	endif
	if	lShowPed .and. lFadel
		oGrid:AddColumn( TcColumn():New( "Cond. Pag. Ped."	,{ || aArray[oGrid:nAt,nCndPed]																		}	, PesqPict("SC7","C7_NUM") 			,,,"LEFT"	 	,050,.f.,.f.,,,,.f.,) )		
	endif
	oGrid:AddColumn( TcColumn():New( "Linha Digitavel"		,{ || aArray[oGrid:nAt,nPosLnD]  																	}	, "@!"								,,,"CENTER"	 	,170,.f.,.f.,,,,.f.,) )		
endif	
	
if	lUsrView .and. xPar03 <= 3
	oGrid:bHeaderClick	:= 	{ |o,x,y|  fMudaOr(@oDlg,@oGrid,@aArray,x) }
	oGrid:bLDblClick	:=	{ || SE2->(dbgoto(aArray[oGrid:nAt,nPosRec])) , fSelect(@oDlg,@oGrid,@aArray) } 
elseif	xPar03 <= 3	
	oGrid:bHeaderClick	:= 	{ |o,x,y|  iif( x == 1 , oMenu:Activate(x,y,oGrid) , fMudaOr(@oDlg,@oGrid,@aArray,x) ) }
	oGrid:bLDblClick	:=	{ || SE2->(dbgoto(aArray[oGrid:nAt,nPosRec])) , fSelect(@oDlg,@oGrid,@aArray) , xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray) } 
endif

fCabecO(@oGrid,.t.,0)

oGrid:SetArray(aArray)

if	xPar03 <= 3	
	@ nAltu      	, 003	Say oSay1 			Prompt "Total:" 												Size 040,007 Of oDlg Colors 0,16777215 	Pixel
	@ nAltu - 003	, 023	MsGet oTotal 		Var nTotal 				Picture PesqPict("SE2","E2_VALOR")		Size 070,010 Of oDlg Colors 0,16777215 	Pixel 	ReadOnly
	
	@ nAltu      	, 103	Say oSay2 			Prompt "Qtde:" 			 										Size 040,007 Of oDlg Colors 0,16777215 	Pixel
	@ nAltu - 003	, 128	MsGet oQtd 			Var nQtd 				Picture "@e 999"						Size 020,010 Of oDlg Colors 0,16777215 	Pixel 	ReadOnly
	
	@ nAltu      	, 158	Say oSay3 			Prompt "Desmarcar" 												Size 040,007 Of oDlg Colors 0,16777215 	Pixel
	@ nAltu - 004	, 195 	ComboBox oCombo		Var cCombo				Items aItens 							Size 035,050 							Pixel
	
	oCombo:nAt := 2
else
	nQtd := Len(aArray)	

	@ nAltu      	, 003	Say oSay2 			Prompt "Qtde:" 			 										Size 040,007 Of oDlg Colors 0,16777215 	Pixel
	@ nAltu - 003	, 023	MsGet oQtd 			Var nQtd 				Picture "@e 999"						Size 020,010 Of oDlg Colors 0,16777215 	Pixel 	ReadOnly
endif
	
Menu xMenu PopUp
   	MenuItem "Gera Border๔"								Action Eval( { || fGeraBor(@oDlg,@oGrid,@aArray)            	, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray)	} )
	MenuItem "Alt. Status da PA"  						Action Eval( { || fAltStPa(@oDlg,@oGrid,@aArray,,,,@oCombo) 	, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray)	} )
	MenuItem "Alt. Vcto em Lote" 						Action Eval( { || fAltVcLt(@oDlg,@oGrid,@aArray,,,,@oCombo)		, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray)	} )  
	MenuItem "Alt. Tipo Pagamento" 						Action Eval( { || fAltTpPg(@oDlg,@oGrid,@aArray,,,,@oCombo) 	, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray)	} )
	MenuItem "Alt. Banco Pagamento" 					Action Eval( { || fAltBcPg(@oDlg,@oGrid,@aArray,,,,@oCombo) 	, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray)	} )
	MenuItem "Limpar Dados de Pagamento" 				Action Eval( { || xCleanPg(@oDlg,@oGrid,@aArray,,,,@oCombo) 	, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray)	} )
	MenuItem "Exclui Bordero"		 					Action Eval( { || fExcBord(@oDlg,@oGrid,@aArray,,,,@oCombo) 	, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray)	} )
	MenuItem "Imprime Capa Bordero "					Action Eval( { || U_xCapaBor(Nil,"T")                                                                          		} )
	MenuItem "Gerar Capa Bordero Excel"					Action Eval( { || U_xCapaBor(Nil,"E")                                                                          		} )
	if	lShowNf .and. ( lCCL .or. lCheck )
		MenuItem "Enviar Pend๊ncia Doc"					Action Eval( { || fMailPen(@oDlg,@oGrid,@aArray)  				, xRetValues(@oTotal,@nTotal,@oQtd,@nQtd,aArray)	} )
	endif
	if	lCCL .or. lCheck 
		MenuItem "Cobrar Dados Fornecedor"				Action Eval( { || xDadosFor(@oDlg,@oGrid,@aArray) 				                                               		} )
	endif
	if	SE2->(FieldPos("E2_ZZMSGER")) <> 0 
		MenuItem "Enviar E-mail de Tํtulos com Erro"	Action Eval( { || xMailErro(@oDlg,@oGrid,@aArray) 				                                               		} )
	endif 
	if !lAtivo .and. !lFadel 
		MenuItem "Gerar CNAB"							Action Eval( { || GeraCNAB(@aArray,@oGrid)                      	                                               	} )
	endif    
	if	lFadel 
		MenuItem "Reenviar Workflow"					Action Eval( { || GeraWork(@aArray,@oGrid)                      	                                               	} )
	endif    
EndMenu

if	lUsrView .and. xPar03 <= 3
	oTButton1		:=	tButton():New(nAltu - 2.5,nLarg - 042,"Sair"			,oDlg,{ || nOpc := 1 , oDlg:End() 										},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)  
	oTButton2		:=	tButton():New(nAltu - 2.5,nLarg - 087,"Legenda"			,oDlg,{ || xLegenda()              										},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)
	oTButton5		:=	tButton():New(nAltu - 2.5,nLarg - 132,"Filtrar"  		,oDlg,{ || xFiltrar(@aArray,@oTButton5,@aArrOri,@oTButton6,@oGrid,1)	},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)
	oTButton6		:=	tButton():New(nAltu - 2.5,nLarg - 177,"Canc. Filtro"	,oDlg,{ || xFiltrar(@aArray,@oTButton5,@aArrOri,@oTButton6,@oGrid,2)	},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)
	oTButton1:SetCss( CSSBOTVM )
	oTButton2:SetCss( CSSBOTVD )
	oTButton5:SetCss( CSSBOTAZ )
	oTButton6:SetCss( CSSBOTDS )
elseif	xPar03 <= 3	
	oTButton1		:=	tButton():New(nAltu - 2.5,nLarg - 042,"Sair"			,oDlg,{ || nOpc := 1 , oDlg:End() 										},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)  
	oTButton2		:=	tButton():New(nAltu - 2.5,nLarg - 087,"Opcoes"			,oDlg,{ || .t.                                  						},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)
	oTButton2:SetPopUpMenu(xMenu)
	oTButton3		:=	tButton():New(nAltu - 2.5,nLarg - 132,"Legenda"			,oDlg,{ || xLegenda()              										},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)
	if !lOracle .and. lButAban
		oTButton4	:=	tButton():New(nAltu - 2.5,nLarg - 177,"Abandonar"		,oDlg,{ || Eval(bBlocoAb)					 							},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)
		oTButton5	:=	tButton():New(nAltu - 2.5,nLarg - 222,"Filtrar"  		,oDlg,{ || xFiltrar(@aArray,@oTButton5,@aArrOri,@oTButton6,@oGrid,1)	},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)
		oTButton6	:=	tButton():New(nAltu - 2.5,nLarg - 267,"Canc. Filtro"	,oDlg,{ || xFiltrar(@aArray,@oTButton5,@aArrOri,@oTButton6,@oGrid,2)	},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)
		oTButton4:SetCss( CSSBOTDS )
	else
		oTButton5	:=	tButton():New(nAltu - 2.5,nLarg - 177,"Filtrar"  		,oDlg,{ || xFiltrar(@aArray,@oTButton5,@aArrOri,@oTButton6,@oGrid,1)	},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)
		oTButton6	:=	tButton():New(nAltu - 2.5,nLarg - 222,"Canc. Filtro"	,oDlg,{ || xFiltrar(@aArray,@oTButton5,@aArrOri,@oTButton6,@oGrid,2)	},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)
	endif
	oTButton1:SetCss( CSSBOTVM )
	oTButton2:SetCss( CSSBOTCZ )
	oTButton3:SetCss( CSSBOTVD )
	oTButton5:SetCss( CSSBOTAZ )
	oTButton6:SetCss( CSSBOTDS )
	oTButton5:Enable()
	oTButton6:Disable()
else
	oTButton1		:=	tButton():New(nAltu - 2.5,nLarg - 042,"Sair"			,oDlg,{ || nOpc := 0 , oDlg:End() 										},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)  
	oTButton2		:=	tButton():New(nAltu - 2.5,nLarg - 087,"Desbloquear"		,oDlg,{ || nOpc := 1 , oDlg:End() 										},040,010,,,.f.,.t.,.f.,,.f.,,,.f.)  
endif

Activate MsDialog oDlg Centered 
Setapilha()

if 	lBlqTit .and. !lUsrView .and. ( xPar03 == 2 .or. xPar03 == 3 .or. ( xPar03 == 4 .and. nOpc == 1 ) )
	FwMsgRun( Nil , { || xUnblock(aArray,aArrOri) } , 'Processando' , "Desbloqueando Registros ..." )
endif

Return     

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xUnblock(aArray,aArrOri)       

Local w

Default aArray	:=	{}
Default aArrOri	:=	{}

For w := 1 to Len(aArray)       
	SE2->(dbgoto(aArray[w,nPosRec]))
	RecLock("SE2",.f.)
		SE2->E2_ZZCRGRT	:= ''
   	MsUnlock("SE2")
Next w 

For w := 1 to Len(aArrOri)       
	SE2->(dbgoto(aArrOri[w,nPosRec]))
	RecLock("SE2",.f.)
		SE2->E2_ZZCRGRT	:= ''
   	MsUnlock("SE2")
Next w 

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fCabecO(oGrid,lFirst,nColPos) 

Local w
Local nColVal	:=	0
Local nColNum	:=	0
Local nColNom	:=	0
Local nColDat	:=	0
Local nColFil	:=	0
Local nColFor	:=	0
Local nColVen	:=	0
Local nColCta	:=	0
Local nColTip	:=	0
Local nColPre	:=	0
Local nColBor	:=	0
Local nColSld	:=	0
Local nColCon	:=	0
Local nColNat	:=	0
Local nColMod	:=	0
Local aColunas	:=	aClone(oGrid:aColumns)
Local cCol		:=	"02"

Default lFirst	:=	.f.                     
Default nColPos	:=	oGrid:nColPos

if	lFirst 

	For w := 1 to Len(aColunas)
		oObj := aColunas[w]
		if	Upper(Alltrim(oObj:cHeading)) == "FILIAL"
			nColFil	:=	w       
		elseif	Upper(Alltrim(oObj:cHeading)) == "FORNECEDOR"
			nColFor	:=	w       
		elseif	Upper(Alltrim(oObj:cHeading)) == "NOME FORNECEDOR"
			nColNom	:=	w       
		elseif	Upper(Alltrim(oObj:cHeading)) == "NUMERO"     
			nColNum	:=	w       
		elseif	Upper(Alltrim(oObj:cHeading)) == "VENC REAL"
			nColVen	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "CONTA PG"	
			nColCta	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "TIPO PAG"	
			nColTip	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "PREFIXO"	
			nColPre	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "BORDERO"	
			nColBor	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "SALDO"	
			nColSld	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "VALOR"	
			nColVal	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "CONTA CTB"	
			nColCon	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "NATUREZA"	
			nColNat	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "MODELO"	
			nColMod	:=	w
		elseif	Upper(Alltrim(oObj:cHeading)) == "DT CONTAB"
			nColDat	:=	w
	    endif
	Next w 

	oGrid:SetHeaderImage( 02 		, "COLRIGHT" )
	oGrid:SetHeaderImage( nColFil 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColFor 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColVen 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColCta 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColTip 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColBor 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColSld 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColCon 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColNat 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColMod 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColDat 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColNom 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColNum 	, "COLRIGHT" )
	oGrid:SetHeaderImage( nColVal 	, "COLRIGHT" )

	oGrid:SetHeaderImage( nColPre 	, "COLDOWN"  )

else

	For w := 1 to Len(aColunas)
		oObj := aColunas[w]
		if	Upper(Alltrim(oObj:cHeading)) == "FILIAL"
			nColFil	:=	w                                
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "FORNECEDOR"
			nColFor	:=	w                                
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "NOME FORNECEDOR"
			nColNom	:=	w                                
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "NUMERO"     
			nColNum	:=	w       
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "VENC REAL"
			nColVen	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "CONTA PG"	
			nColCta	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "TIPO PAG"	
			nColTip	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "PREFIXO"	
			nColPre	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "BORDERO"	
			nColBor	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "SALDO"	
			nColSld	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "VALOR"	
			nColVal	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "CONTA CTB"	
			nColCon	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "NATUREZA"	
			nColNat	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "MODELO"	
			nColMod	:=	w
			cCol	+=	"/" + StrZero(w,02)
		elseif	Upper(Alltrim(oObj:cHeading)) == "DT CONTAB"
			nColDat	:=	w
			cCol	+=	"/" + StrZero(w,02)
	    endif
	Next w 

	if	StrZero(nColPos,02) $ cCol 

		oGrid:SetHeaderImage( 02 		, "COLRIGHT" )
		oGrid:SetHeaderImage( nColFil 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColFor 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColVen 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColCta 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColTip 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColPre 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColBor 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColSld 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColCon 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColNat 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColMod 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColDat 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColNom 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColNum 	, "COLRIGHT" )
		oGrid:SetHeaderImage( nColVal 	, "COLRIGHT" )

		oGrid:SetHeaderImage( nColPos 	, "COLDOWN"  )

		oGrid:Refresh()
	endif   
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMudaOr(oDlg,oGrid,aArray,nColPos,lAtualiza) 

Local w
Local nColVal		:=	0
Local nColNum		:=	0
Local nColNom		:=	0
Local nColDat		:=	0
Local nColFil		:=	0
Local nColFor		:=	0
Local nColVen		:=	0
Local nColCta		:=	0
Local nColTip		:=	0
Local nColPre		:=	0
Local nColBor		:=	0
Local nColSld		:=	0
Local nColCon		:=	0
Local nColNat		:=	0
Local nColMod		:=	0
Local aColunas		:=	aClone(oGrid:aColumns)

Local cCol			:=	"02"
Local nNum			:=	SE2->(FieldPos("E2_NUM"))	
Local nTip			:=	SE2->(FieldPos("E2_TIPO"))	
Local nLoj			:=	SE2->(FieldPos("E2_LOJA"))	
Local nDat			:=	SE2->(FieldPos("E2_EMIS1"))	
Local nSal			:=	SE2->(FieldPos("E2_SALDO"))	
Local nVal			:=	SE2->(FieldPos("E2_VALOR"))	
Local nCon			:=	SE2->(FieldPos("E2_CONTA"))	
Local nFil			:=	SE2->(FieldPos("E2_FILIAL"))	
Local nBor			:=	SE2->(FieldPos("E2_NUMBOR"))	
Local nVen			:=	SE2->(FieldPos("E2_VENCREA"))	
Local nPre			:=	SE2->(FieldPos("E2_PREFIXO"))	
Local nPar			:=	SE2->(FieldPos("E2_PARCELA"))	
Local nFor			:=	SE2->(FieldPos("E2_FORNECE"))	
Local nNat			:=	SE2->(FieldPos("E2_NATUREZ"))	

Default lAtualiza	:=	.t.

For w := 1 to Len(aColunas)        

	oObj := aColunas[w]

	if	Upper(Alltrim(oObj:cHeading)) == "FILIAL"
		nColFil	:=	w                                
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "FORNECEDOR"
		nColFor	:=	w                                
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "NOME FORNECEDOR"
		nColNom	:=	w                                
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "NUMERO"     
		nColNum	:=	w       
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "VENC REAL"
		nColVen	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "CONTA PG"	
		nColCta	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "TIPO PAG"	
		nColTip	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "PREFIXO"	
		nColPre	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "BORDERO"	
		nColBor	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "SALDO"	
		nColSld	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "VALOR"	
		nColVal	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "CONTA CTB"	
		nColCon	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "NATUREZA"	
		nColNat	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "MODELO"	
		nColMod	:=	w
		cCol	+=	"/" + StrZero(w,02)
	elseif	Upper(Alltrim(oObj:cHeading)) == "DT CONTAB"
		nColDat	:=	w
		cCol	+=	"/" + StrZero(w,02)
    endif

Next w 

if	StrZero(nColPos,02) $ cCol 
	
	if	nColPos == 2
		aArray	:=	aSort( aArray ,,, { |x,y| x[nPosStt] + DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nPosStt] + DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColNum
		aArray	:=	aSort( aArray ,,, { |x,y| x[nNum] + x[nFil] + x[nPre] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nNum] + y[nFil] + y[nPre] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColNom
		aArray	:=	aSort( aArray ,,, { |x,y| x[nPosNom] + x[nNum] + x[nFil] + x[nPre] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nPosNom] + y[nNum] + y[nFil] + y[nPre] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColFil
		aArray	:=	aSort( aArray ,,, { |x,y| x[nFil] + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nFil] + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColFor
		aArray	:=	aSort( aArray ,,, { |x,y| x[nFor] + x[nLoj] + DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] < y[nFor] + y[nLoj] + DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] } )
	elseif	nColPos == nColVen
		aArray	:=	aSort( aArray ,,, { |x,y| DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColCta
		aArray	:=	aSort( aArray ,,, { |x,y| x[nPosBco] + x[nPosAge] + x[nPosCon] + DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nPosBco] + y[nPosAge] + y[nPosCon] + DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColTip
		aArray	:=	aSort( aArray ,,, { |x,y| x[nTipoPg] + x[nPosBco] + x[nPosAge] + x[nPosCon] + DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nTipoPg] + y[nPosBco] + y[nPosAge] + y[nPosCon] + DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColPre
		aArray	:=	aSort( aArray ,,, { |x,y| x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColBor
		aArray	:=	aSort( aArray ,,, { |x,y| x[nBor] + x[nTipoPg] + x[nPosBco] + x[nPosAge] + x[nPosCon] + DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nBor] + y[nTipoPg] + y[nPosBco] + y[nPosAge] + y[nPosCon] + DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColSld
		aArray	:=	aSort( aArray ,,, { |x,y| StrZero( x[nSal] * 100 , 20 ) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < StrZero( y[nSal] * 100 , 20 ) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColVal
		aArray	:=	aSort( aArray ,,, { |x,y| StrZero( x[nVal] * 100 , 20 ) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < StrZero( y[nVal] * 100 , 20 ) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColCon
		aArray	:=	aSort( aArray ,,, { |x,y| x[nCon] + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nCon] + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColNat
		aArray	:=	aSort( aArray ,,, { |x,y| x[nNat] + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nNat] + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColMod
		aArray	:=	aSort( aArray ,,, { |x,y| x[nModCrd] + x[nPosBco] + x[nPosAge] + x[nPosCon] + DtoS(x[nVen]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < y[nModCrd] + y[nPosBco] + y[nPosAge] + y[nPosCon] + DtoS(y[nVen]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	elseif	nColPos == nColDat
		aArray	:=	aSort( aArray ,,, { |x,y| DtoS(x[nDat]) + x[nPre] + x[nNum] + x[nPar] + x[nTip] + x[nFor] + x[nLoj] < DtoS(y[nDat]) + y[nPre] + y[nNum] + y[nPar] + y[nTip] + y[nFor] + y[nLoj] } )
	endif
	
	if	lAtualiza
		fCabecO(@oGrid,.f.,nColPos)	
		oGrid:SetArray(aArray)
		oGrid:Refresh()
	endif
		
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fAltTpPg(oDlg,oGrid,aArray,nPosIni,nPosFim,lPass,oCombo)

Local w 
Local lCont			:=	.t.

Local nLin			:=	000
Local nOpc			:=	000
Local nSaldo		:=	000
Local nRadio		:=	001
Local oRadio  		:=	Nil
Local oDlgAlt		:=	Nil

Default lPass		:=	.f.
Default nPosIni		:=	001
Default nPosFim		:=	Len(aArray)

For w := nPosIni to nPosFim
	if	lPass .or. aArray[w,nPosFlg]
		if	!( aArray[w,nPosStt] $ "1/5" )
			lCont := .f. 
		endif
	endif
Next w 

if	lCont             
	
	Define MsDialog oDlgAlt From  000,000 To 107,292 Title "Informe" Pixel Style 128
	@ 005,007 To 035,140 Of oDlgAlt  Pixel	
	@ 011,010 Radio oRadio Var nRadio Items "Boleto" , "Deposito" 3D Size 100,010 Of oDlgAlt Pixel
	Define sButton From 038,115 Type 1 Enable Of oDlgAlt Action ( nOpc := 1 , oDlgAlt:End() )
	Activate MsDialog oDlgAlt Centered
	
	if	nOpc == 1
		For nLin := nPosIni to nPosFim
			if	lPass .or. aArray[nLin,nPosFlg]	
				if	Upper(Alltrim(aArray[nLin,nTipoPg])) == "TRIBUTO" 
					if	oCombo:nAt == 1 
						aArray[nLin,nPosFlg] 	:= 	.f.
					endif		
				else
					aArray[nLin,nTipoPg] 		:= 	iif( nRadio == 1 , "Boleto" , iif( nRadio == 2 , "Deposito" , "Tributo" ) )
					aArray[nLin,nAtuTpP] 		:= 	.t.
					if	oCombo:nAt == 1 
						aArray[nLin,nPosFlg] 	:= 	.f.
					endif		
					SE2->(dbgoto(aArray[nLin,nPosRec]))
					RecLock("SE2",.f.)
						SE2->E2_ZZTPPG			:=	iif( nRadio == 1 , "B" , iif( nRadio == 2 , "D" , "T" ) )
					MsUnlock("SE2")
					nSaldo := Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)
					xModPg(@aArray,nLin,nSaldo,!( aArray[nLin,nPosStt] $ "1/5/9" ))
				endif
			endif
		Next w 
	endif	

	oGrid:Refresh()
else	
	MessageBox("Apenas tํtulos liberados podem ter alteradas as formas de pagamento.","Aten็ใo",MB_ICONHAND) 
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fAltStPa(oDlg,oGrid,aArray,nPosIni,nPosFim,lPass,oCombo)

Local w 
Local lCont			:=	.t.
Local nSaldo		:=	000

Default lPass		:=	.f.
Default nPosIni		:=	001
Default nPosFim		:=	Len(aArray)

For w := nPosIni to nPosFim
	if	lPass .or. aArray[w,nPosFlg]
		if	aArray[w,nPosStt] <> "3"
			lCont := .f. 
		endif
	endif
Next w 

if	lCont             
	For w := nPosIni to nPosFim
		if	lPass .or. aArray[w,nPosFlg]	
			if	oCombo:nAt == 1 	
				aArray[w,nPosFlg] 	:= 	.f.	
			endif			
			aArray[w,nVincPa] 		:= 	.t.
			if	Empty(aArray[w,SE2->(FieldPos("E2_DATALIB"))]) .and. lLibPag    		
				aArray[w,nPosStt] 		:= 	"2"				// Nao Liberado
			else                	
				if	aArray[w,SE2->(FieldPos("E2_SALDO"))] == aArray[w,SE2->(FieldPos("E2_VALOR"))]
					aArray[w,nPosStt] 	:= 	"1"				// Liberado
				else
					aArray[w,nPosStt] 	:= 	"5"				// Liberado
				endif	
			endif	
			SE2->(dbgoto(aArray[w,nPosRec]))
			nSaldo := Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)
			xModPg(@aArray,w,nSaldo,!( aArray[w,nPosStt] $ "1/5/9" ))
		endif
	Next w 

	oGrid:Refresh()
else	
	MessageBox("Apenas tํtulos marcados como vinculados a PA podem ser alterados.","Aten็ใo",MB_ICONHAND) 
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fAltBcPg(oDlg,oGrid,aArray,nPosIni,nPosFim,lPass,oCombo)

Local w 
Local aRet			:=	{}     
Local aFil			:=	{}
Local lCont			:=	.t.
Local xFilAnt		:=	cFilAnt
Local lSA6Excl		:=	FwModeAccess("SA6") == "E"

Default lPass		:=	.f.
Default nPosIni		:=	001
Default nPosFim		:=	Len(aArray)

For w := nPosIni to nPosFim
	if	lPass .or. aArray[w,nPosFlg]
		if	!( aArray[w,nPosStt] $ "1/5" )
			lCont := .f. 
		endif
		if	aScan( aFil , aArray[w,SE2->(FieldPos("E2_FILIAL"))] ) == 0
    		aAdd( aFil , aArray[w,SE2->(FieldPos("E2_FILIAL"))] )
		endif
	endif
Next w 

if	lCont             
	if	lSA6Excl	
    	if	Len(aFil) > 1
			MessageBox("Quando o cadastro de banco for EXCLUSIVO, s๓ devem ser marcados os tํtulos de uma filial apenas","Aten็ใo",MB_ICONEXCLAMATION) 			
			Return 
		endif
	endif
endif

if	lCont             
	if	lSA6Excl	
    	cFilAnt := aFil[01]
	endif
	aRet := RetBancos() 
	if	Empty(aRet[1]) 
		MessageBox("Processo abortado","Aten็ใo",MB_ICONEXCLAMATION) 
	else
		if	( MessageBox('Confirma altera็ใo do banco pagador ?',"Aten็ใo",MB_YESNO) == 6 )
			For w := nPosIni to nPosFim
				if	lPass .or. aArray[w,nPosFlg]
					if	oCombo:nAt == 1 
						aArray[w,nPosFlg] 	:= 	.f.	
					endif					
					if	Upper(Alltrim(aArray[w,nTipoPg])) == "TRIBUTO" .and. !Empty(aArray[w,nBcoPag]) .and. !( aRet[1] $ aArray[w,nBcoPag] )
						MessageBox("O tributo da linha " + Alltrim(Str(w)) + " nใo pode ser pago pelo banco escolhido.","Aten็ใo",MB_ICONHAND) 
						Loop
					endif
					aArray[w,nAltBcP] 		:= 	.t.							
					aArray[w,nPosBco]		:=	aRet[1]	
					aArray[w,nPosAge]		:=	aRet[2]
					aArray[w,nPosCon]		:=	aRet[3]
					if	!Empty(aArray[w,nPosCdB]) .and. Upper(Alltrim(aArray[w,nTipoPg])) <> "TRIBUTO" 
						aArray[w,nTipoPg]	:=	"Boleto" 
					endif
					SE2->(dbgoto(aArray[w,nPosRec]))
					RecLock("SE2",.f.)
						SE2->E2_ZZBCO		:=	aRet[1]	
						SE2->E2_ZZAGE		:=	aRet[2]	
						SE2->E2_ZZCTA		:=	aRet[3]	
					MsUnlock("SE2")
					nSaldo := Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)
					xModPg(@aArray,w,nSaldo,!( aArray[w,nPosStt] $ "1/5/9" ))
				endif
			Next w 
		endif
	endif
	oGrid:Refresh()
else	
	MessageBox("S๓ tํtulos liberados podem ter alterados os bancos de pagamento.","Aten็ใo",MB_ICONHAND) 
endif

cFilAnt := xFilAnt 

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xLegenda()

if	lAtivo
	if	nQtdApr	== 2
		BrwLegenda(		"Legenda"	,	"Legenda"	,	{	{"ENABLE"			,"Titulo Liberado"								}	,;
															{"BR_AZUL"   		,"Titulo com Baixa Parcial"						}	,;
															{"BR_AMARELO"		,"Titulo nใo Liberado"							}	,;
															{"BR_BRANCO"		,"Titulo com PA Vinculado"						}	,;
															{"BR_CINZA"			,"Titulo em Border๔"							}	,;
															{"BR_LARANJA"		,"Pagamento Antecipado"							}	,;
															{"BR_VIOLETA"		,"Tํtulo de imposto sem C๓digo de Barras"		}	,;
															{"BR_MARROM"		,"Tํtulo de imposto com C๓digo de Barras"		}	,;
															{"DISABLE"			,"Titulo sem Saldo"								}	,;
															{"BR_CANCEL.PNG"	,"Tํtulo sem Inf. Adicional"					}	,;
															{"CHECKED_15.PNG"	,"Tํtulo com Inf. Adicional"					}	,;
															{"PMSEDT2.BMP"		,"Border๔ com 1 Aprova็ใo"						}	,;
															{"PMSEDT1.BMP"		,"Border๔ com 2 Aprova็๔es"						}	})
	else	
		BrwLegenda(		"Legenda"	,	"Legenda"	,	{	{"ENABLE"			,"Titulo Liberado"								}	,;
															{"BR_AZUL"   		,"Titulo com Baixa Parcial"						}	,;
															{"BR_AMARELO"		,"Titulo nใo Liberado"							}	,;
															{"BR_BRANCO"		,"Titulo com PA Vinculado"						}	,;
															{"BR_CINZA"			,"Titulo em Border๔"							}	,;
															{"BR_LARANJA"		,"Pagamento Antecipado"							}	,;
															{"BR_VIOLETA"		,"Tํtulo de imposto sem C๓digo de Barras"		}	,;
															{"BR_MARROM"		,"Tํtulo de imposto com C๓digo de Barras"		}	,;
															{"DISABLE"			,"Titulo sem Saldo"								}	,;
															{"BR_CANCEL.PNG"	,"Tํtulo sem Inf. Adicional"					}	,;
															{"CHECKED_15.PNG"	,"Tํtulo com Inf. Adicional"					}	,;
															{"PMSEDT1.BMP"		,"Border๔ Aprovado"								}	})
	endif
else
	if	xGerAut
		BrwLegenda(		"Legenda"	,	"Legenda"	,	{	{"ENABLE"			,"Titulo Liberado"								}	,;
															{"BR_AZUL"   		,"Titulo com Baixa Parcial"						}	,;
															{"BR_AMARELO"		,"Titulo nใo Liberado"							}	,;
															{"BR_BRANCO"		,"Titulo com PA Vinculado"						}	,;
															{"BR_CINZA"			,"Titulo em Border๔"							}	,;
															{"PMSEDT4.PNG"		,"Titulo em Border๔ com Arq. Gerado Aut."		}	,;
															{"BR_LARANJA"		,"Pagamento Antecipado"							}	,;
															{"BR_VIOLETA"		,"Tํtulo de imposto sem C๓digo de Barras"		}	,;
															{"BR_MARROM"		,"Tํtulo de imposto com C๓digo de Barras"		}	,;
															{"DISABLE"			,"Titulo sem Saldo"								}	})
	else
		BrwLegenda(		"Legenda"	,	"Legenda"	,	{	{"ENABLE"			,"Titulo Liberado"								}	,;
															{"BR_AZUL"   		,"Titulo com Baixa Parcial"						}	,;
															{"BR_AMARELO"		,"Titulo nใo Liberado"							}	,;
															{"BR_BRANCO"		,"Titulo com PA Vinculado"						}	,;
															{"BR_CINZA"			,"Titulo em Border๔"							}	,;
															{"BR_LARANJA"		,"Pagamento Antecipado"							}	,;
															{"BR_VIOLETA"		,"Tํtulo de imposto sem C๓digo de Barras"		}	,;
															{"BR_MARROM"		,"Tํtulo de imposto com C๓digo de Barras"		}	,;
															{"DISABLE"			,"Titulo sem Saldo"								}	})
													//		{"BR_CANCEL.PNG"	,"Tํtulo sem Inf. Adicional"					}	,;
													//		{"CHECKED_15.PNG"	,"Tํtulo com Inf. Adicional"					}	})
	
	endif
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetCores(oGrid,aArray,oVerd,oVerm,oBran,oAmar,oCinz,oAzul,oLara,oViol,oTV,oTA,oTD,oTC,oMarr)

if	aArray[oGrid:nAt,nPosStt]	==	"1"
	if	Upper(Alltrim(aArray[oGrid:nAt,nTipoPg])) == "TRIBUTO" .and. !Empty(aArray[oGrid:nAt,nPosCdB])
		Return ( oMarr )
	elseif	Upper(Alltrim(aArray[oGrid:nAt,nTipoPg])) == "TRIBUTO" 
		Return ( oViol )
	elseif	Upper(Alltrim(aArray[oGrid:nAt,SE2->(FieldPos("E2_TIPO"))])) == "PA" 
		Return ( oLara )
	else
		Return ( oVerd )
	endif
elseif	aArray[oGrid:nAt,nPosStt] == "2"
	Return ( oAmar )
elseif	aArray[oGrid:nAt,nPosStt] == "3"
	Return ( oBran )
elseif	aArray[oGrid:nAt,nPosStt] == "4" .and. aArray[oGrid:nAt,nGerAut] 
	Return ( oTC )
elseif	aArray[oGrid:nAt,nPosStt] == "4"        
	Return ( oCinz )
elseif	aArray[oGrid:nAt,nPosStt] == "5"
	Return ( oAzul )
elseif	aArray[oGrid:nAt,nPosStt] == "8" .and. !Empty(aArray[oGrid:nAt,nColApv]) .and. aArray[oGrid:nAt,nColApv] == "1"
	Return ( oTA )
elseif	aArray[oGrid:nAt,nPosStt] == "8" .and. !Empty(aArray[oGrid:nAt,nColApv]) .and. aArray[oGrid:nAt,nColApv] == "2"
	Return ( oTV )
elseif	aArray[oGrid:nAt,nPosStt] == "8"
	Return ( oTC )
elseif	aArray[oGrid:nAt,nPosStt] == "9"
	Return ( oVerm )
endif

Return      

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetValues(oTotal,nTotal,oQtd,nQtd,aArray)

Local w   
Local nSaldo

nQtd	:=	0
nTotal	:=	0

For w := 1 to Len(aArray)
	if	aArray[w,nPosFlg]	
		SE2->(dbgoto(aArray[w,nPosRec]))
        nSaldo	:=	Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)		
        nTotal	+=	iif( nSaldo > 0 , nSaldo , 0 )
		nQtd 	+=	iif( nSaldo > 0 , 1      , 0 )
	endif
Next w 

oQtd:SetText(nQtd)
oQtd:Refresh()

oTotal:SetText(nTotal)
oTotal:Refresh()

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fCarga(aArray,lFat,aFatPag,lJob) 		

Local w      
Local t  
Local s
Local aRet
Local nSaldo
Local cQuery	  
Local lFound
Local nCount	:=	0
Local nRegCnt	:=	0     
Local nValRet	:=	0   
Local xFilTmp	:=	""
Local xFilCen	:=	""
Local cDirImg	:=	""
Local xDirImg	:=	""
Local aDirImg	:=	{}
Local cFilTmp	:=	cFilAnt       
Local cUserRot	:=	RetCodUsr()
Local lBolAut	:=	GetMv("ZZ_MARKBOL") 
Local lDepAut	:=	GetMv("ZZ_MARKDEP") 
Local xBcoPad	:=	GetMv("ZZ_BCOPADP") 
Local nTamBco	:=	TamSx3("A6_COD")[1]
Local nTamCta	:=	TamSx3("A6_NUMCON")[1]
Local nTamAge	:=	TamSx3("A6_AGENCIA")[1]
Local lSE2Excl	:=	FwModeAccess("SE2") == "E"
Local lSA2Excl	:=	FwModeAccess("SA2") == "E"
Local lSA6Excl	:=	FwModeAccess("SA6") == "E"
Local cFilFwSE2	:= 	FwFilial("SE2")            

Local lAdmin	:=	FwIsAdmin(RetCodUsr())            
Local nTamCpo	:=	TamSx3("E2_ZZCRGRT")[1]     

Local cNewFile	:=	""

Default lFat  	:=	.f.
Default lJob  	:=	.f.
                  
if	lPix
	dbselectarea("F72")
	F72->(dbsetorder(1))
endif

if	lShowNf .or. lShowPed    
	SD1->(dbsetorder(1))
	SF1->(dbsetorder(2))
endif

if	xPar03 == 4

	cQuery 	:= 	" SELECT SE2.R_E_C_N_O_ AS RECNOSE2 , SA2.R_E_C_N_O_ AS RECNOSA2 "        
	cQuery 	+= 	" FROM " + RetSqlName("SE2") + " SE2 , " + RetSqlName("SA2") + " SA2 "
	cQuery 	+= 	" WHERE "
	if	( lSA2Excl .and. lSE2Excl ) .or. ( !lSA2Excl .and. !lSE2Excl )
		cQuery	+=	"   SA2.A2_FILIAL   = SE2.E2_FILIAL                            AND "
	else
		cQuery	+=	"   SA2.A2_FILIAL   = '" + xFilial("SA2") 				+ "'   AND "
	endif
	cQuery	+=		"   SA2.A2_COD      = SE2.E2_FORNECE                           AND "
	cQuery	+=		"   SA2.A2_LOJA     = SE2.E2_LOJA                              AND "
	if	Empty( cFilFwSE2 )
		cQuery	+= 	"   SE2.E2_FILORIG >= '" + xPar06 						+ "'   AND "
		cQuery 	+= 	"   SE2.E2_FILORIG <= '" + xPar07 						+ "'   AND "
	else                                                	
		cQuery 	+= 	"   SE2.E2_FILIAL  >= '" + xPar06 						+ "'   AND "
		cQuery 	+= 	"   SE2.E2_FILIAL  <= '" + xPar07 						+ "'   AND "
	endif	
	cQuery 	+= 		"   SE2.E2_VENCREA >= '" + DtoS(xPar01) 				+ "'   AND "
	cQuery 	+= 		"   SE2.E2_VENCREA <= '" + DtoS(xPar02) 				+ "'   AND "   
	if	lBlqTit .and. ( lAdmin .or. nTamCrg >= 1 )
		cQuery 	+= 	"   SE2.E2_ZZCRGRT <> '" + Space(nTamCpo)				+ "'   AND "   
	elseif	lBlqTit		
		cQuery 	+= 	"   SE2.E2_ZZCRGRT  = '" + cUserRot						+ "'   AND "   
	endif
	cQuery 	+= 		"   SE2.D_E_L_E_T_  = ' '                                      AND "
	cQuery	+=		"   SA2.D_E_L_E_T_  = ' '                                          "
	cQuery	+=	" ORDER BY E2_VENCREA , E2_FILIAL , E2_PREFIXO , E2_NUM , E2_PARCELA , E2_TIPO , E2_FORNECE , E2_LOJA "

elseif	lOracle

	cQuery 	:= 	" SELECT SE2.R_E_C_N_O_ AS RECNOSE2 , SA2.R_E_C_N_O_ AS RECNOSA2 "        
	cQuery 	+= 	" FROM " + RetSqlName("SE2") + " SE2 , " + RetSqlName("SA2") + " SA2 "
	cQuery 	+= 	" WHERE "
	if	( lSA2Excl .and. lSE2Excl ) .or. ( !lSA2Excl .and. !lSE2Excl )
		cQuery	+=	"   SA2.A2_FILIAL   = SE2.E2_FILIAL                            AND "
	else
		cQuery	+=	"   SA2.A2_FILIAL   = '" + xFilial("SA2") 				+ "'   AND "
	endif
	cQuery	+=		"   SA2.A2_COD      = SE2.E2_FORNECE                           AND "
	cQuery	+=		"   SA2.A2_LOJA     = SE2.E2_LOJA                              AND "
	if	SA2->(FieldPos("A2_ZZDEBAU")) <> 0
		cQuery 	+= 	"   SA2.A2_ZZDEBAU <> 'S'                                      AND "
	endif	                                                        	
	if	Empty( cFilFwSE2 )
		cQuery	+= 	"   SE2.E2_FILORIG >= '" + xPar06 						+ "'   AND "
		cQuery 	+= 	"   SE2.E2_FILORIG <= '" + xPar07 						+ "'   AND "
	else                                                	
		cQuery 	+= 	"   SE2.E2_FILIAL  >= '" + xPar06 						+ "'   AND "
		cQuery 	+= 	"   SE2.E2_FILIAL  <= '" + xPar07 						+ "'   AND "
	endif	
	cQuery 	+= 		"   SE2.E2_VENCREA >= '" + DtoS(xPar01) 				+ "'   AND "
	cQuery 	+= 		"   SE2.E2_VENCREA <= '" + DtoS(xPar02) 				+ "'   AND "   
	if	lFat
		cQuery 	+= 	"   SE2.E2_PREFIXO  = '" + aFatPag[01]	         		+ "'   AND "   
		cQuery 	+= 	"   SE2.E2_NUM      = '" + aFatPag[03]             		+ "'   AND "   
		cQuery 	+= 	"   SE2.E2_TIPO     = '" + aFatPag[02]            		+ "'   AND "   
		cQuery 	+= 	"   SE2.E2_FORNECE  = '" + aFatPag[09]    	     		+ "'   AND "   
		cQuery 	+= 	"   SE2.E2_LOJA     = '" + aFatPag[10]            		+ "'   AND "   
	else
		cQuery 	+= 	"   SE2.E2_EMISSAO >= '" + DtoS(xPar08) 				+ "'   AND "
		cQuery 	+= 	"   SE2.E2_EMISSAO <= '" + DtoS(xPar09) 				+ "'   AND "   
	endif      
	if	xPar03 == 1
		cQuery 	+= 	"   SE2.E2_NUMBOR  <> '" + CriaVar("E2_NUMBOR",.f.)		+ "'   AND "   
	elseif	xPar03 == 2
		cQuery 	+= 	"   SE2.E2_NUMBOR   = '" + CriaVar("E2_NUMBOR",.f.)		+ "'   AND "   
	endif
	if !lJob .and. !lUsrView .and. lBlqTit
		cQuery 	+= 	"   SE2.E2_ZZCRGRT  = '" + CriaVar("E2_ZZCRGRT",.f.)	+ "'   AND "   
	endif
	if !Empty(xPar05) 
		cQuery 	+= 	"   SE2.E2_TIPO     IN " + FormatIn(xPar05,";")			+ "    AND "             	
	elseif 	!Empty(xPar04) 
		cQuery 	+= 	"   SE2.E2_TIPO NOT IN " + FormatIn(xPar04,";")			+ "    AND "             	
	endif       
	cQuery 	+= 		"   SE2.E2_TIPO NOT IN " + FormatIn(MVABATIM,";")		+ "    AND "
	cQuery 	+= 		"   SE2.E2_TIPO NOT IN " + FormatIn(MVPROVIS,";")		+ "    AND "
	cQuery 	+= 		"   SE2.E2_TIPO NOT IN " + FormatIn(MV_CPNEG,";")		+ "    AND "
	cQuery	+=		" ( SE2.E2_TIPO    <> '" + MVPAGANT						+ "'   OR  "
	cQuery	+= 		"   SE2.E2_NUMBCO   = '" + CriaVar("E2_NUMBCO",.f.)		+ "')  AND "
	cQuery 	+= 		"   SE2.E2_SALDO   <=  SE2.E2_VALOR                            AND "   
	cQuery 	+= 		"   SE2.E2_ORIGEM  <> 'SIGAEFF'                                AND "
	cQuery 	+= 		"   SE2.E2_ORIGEM  <> 'PANELGPS'                               AND "  				
	cQuery 	+= 		"   SE2.E2_ORIGEM  <> 'PERDCOMP'                               AND "  				
	cQuery 	+= 		"   SE2.E2_IMPCHEQ <> 'S'                                      AND "                 
	if !lShowBxa 
		cQuery 	+= 	"   SE2.E2_SALDO    >  0                                       AND "     
	endif
	cQuery 	+= 		"   SE2.D_E_L_E_T_  = ' '                                      AND "
	cQuery	+=		"   SA2.D_E_L_E_T_  = ' '                                          "
	cQuery	+=	" ORDER BY E2_VENCREA , E2_FILIAL , E2_PREFIXO , E2_NUM , E2_PARCELA , E2_TIPO , E2_FORNECE , E2_LOJA "

else

	cQuery 	:= 	" SELECT SE2.R_E_C_N_O_ AS RECNOSE2 , SA2.R_E_C_N_O_ AS RECNOSA2 "        
	cQuery 	+= 	" FROM " + RetSqlName("SE2") + " AS SE2 "
	cQuery 	+= 	" INNER JOIN " + RetSqlName("SA2") + " AS SA2 ON "
	if	( lSA2Excl .and. lSE2Excl ) .or. ( !lSA2Excl .and. !lSE2Excl )
		cQuery	+=	"   SA2.A2_FILIAL   = SE2.E2_FILIAL                            AND "
	else
		cQuery	+=	"   SA2.A2_FILIAL   = '" + xFilial("SA2") 				+ "'   AND "
	endif
	cQuery	+=		"   SA2.A2_COD      = SE2.E2_FORNECE                           AND "
	cQuery	+=		"   SA2.A2_LOJA     = SE2.E2_LOJA                              AND "
	cQuery	+=		"   SA2.D_E_L_E_T_  = ' '                                          "
	cQuery 	+= 	" WHERE "
	if	Empty( cFilFwSE2 )
		cQuery	+= 	"   SE2.E2_FILORIG >= '" + xPar06 						+ "'   AND "
		cQuery 	+= 	"   SE2.E2_FILORIG <= '" + xPar07 						+ "'   AND "
	else                                                	
		cQuery 	+= 	"   SE2.E2_FILIAL  >= '" + xPar06 						+ "'   AND "
		cQuery 	+= 	"   SE2.E2_FILIAL  <= '" + xPar07 						+ "'   AND "
	endif	
	cQuery 	+= 		"   SE2.E2_VENCREA >= '" + DtoS(xPar01) 				+ "'   AND "
	cQuery 	+= 		"   SE2.E2_VENCREA <= '" + DtoS(xPar02) 				+ "'   AND "   
	if	lFat
		cQuery 	+= 	"   SE2.E2_PREFIXO  = '" + aFatPag[01]	         		+ "'   AND "   
		cQuery 	+= 	"   SE2.E2_NUM      = '" + aFatPag[03]             		+ "'   AND "   
		cQuery 	+= 	"   SE2.E2_TIPO     = '" + aFatPag[02]            		+ "'   AND "   
		cQuery 	+= 	"   SE2.E2_FORNECE  = '" + aFatPag[09]    	     		+ "'   AND "   
		cQuery 	+= 	"   SE2.E2_LOJA     = '" + aFatPag[10]            		+ "'   AND "   
	else
		cQuery 	+= 	"   SE2.E2_EMISSAO >= '" + DtoS(xPar08) 				+ "'   AND "
		cQuery 	+= 	"   SE2.E2_EMISSAO <= '" + DtoS(xPar09) 				+ "'   AND "   
	endif      
	if	xPar03 == 1
		cQuery 	+= 	"   SE2.E2_NUMBOR  <> '" + CriaVar("E2_NUMBOR",.f.)		+ "'   AND "   
	elseif	xPar03 == 2
		cQuery 	+= 	"   SE2.E2_NUMBOR   = '" + CriaVar("E2_NUMBOR",.f.)		+ "'   AND "   
	endif
	if !lJob .and. !lUsrView .and. lBlqTit
		cQuery 	+= 	"   SE2.E2_ZZCRGRT  = '" + CriaVar("E2_ZZCRGRT",.f.)	+ "'   AND "   
	endif
	if !Empty(xPar05) 
		cQuery 	+= 	"   SE2.E2_TIPO     IN " + FormatIn(xPar05,";")			+ "    AND "             	
	elseif 	!Empty(xPar04) 
		cQuery 	+= 	"   SE2.E2_TIPO NOT IN " + FormatIn(xPar04,";")			+ "    AND "             	
	endif        
	if	SE2->(FieldPos("E2_ZZDEBAU")) <> 0
		cQuery 	+= 	"   SE2.E2_ZZDEBAU <> 'S'                                      AND "
	endif	                                                        	
	cQuery 	+= 		"   SE2.E2_TIPO NOT IN " + FormatIn(MVABATIM,";")		+ "    AND "
	cQuery 	+= 		"   SE2.E2_TIPO NOT IN " + FormatIn(MVPROVIS,";")		+ "    AND "
	cQuery 	+= 		"   SE2.E2_TIPO NOT IN " + FormatIn(MV_CPNEG,";")		+ "    AND "
	cQuery	+=		" ( SE2.E2_TIPO    <> '" + MVPAGANT						+ "'   OR  "
	cQuery	+= 		"   SE2.E2_NUMBCO   = '" + CriaVar("E2_NUMBCO",.f.)		+ "')  AND "
	cQuery 	+= 		"   SE2.E2_SALDO   <=  SE2.E2_VALOR                            AND "   
	cQuery 	+= 		"   SE2.E2_ORIGEM  <> 'SIGAEFF'                                AND "
	cQuery 	+= 		"   SE2.E2_ORIGEM  <> 'PERDCOMP'                               AND "  				
	cQuery 	+= 		"   SE2.E2_IMPCHEQ <> 'S'                                      AND "                 
	if !lShowBxa 
		cQuery 	+= 	"   SE2.E2_SALDO    >  0                                       AND "     
	endif
	cQuery 	+= 		"   SE2.D_E_L_E_T_  = ' '                                          "
	cQuery	+=	" ORDER BY E2_VENCREA , E2_FILIAL , E2_PREFIXO , E2_NUM , E2_PARCELA , E2_TIPO , E2_FORNECE , E2_LOJA "

endif

if	lJob
	xExecQry(ChangeQuery(@cQuery)) 
else
	FwMsgRun( Nil , { || xExecQry(ChangeQuery(@cQuery)) } , 'Processando' , "Consultando o Banco de Dados ..." )
endif

aEval( SE2->(dbstruct()) , { |x| iif( x[02] <> "C" , TcSetField( "XSE2" , x[01] , x[02] , x[03] , x[04] ) , Nil ) } )

if !lJob
	Count to nCount 
	XSE2->(dbgotop())
	ProcRegua(nCount)
endif

do while XSE2->(!Eof())

	SA2->(dbgoto(XSE2->RECNOSA2))
	SE2->(dbgoto(XSE2->RECNOSE2))     
	
	if !lJob 
		IncProc("Registro " + StrZero( ++ nRegCnt,06) + " de " + StrZero(nCount,06))
	endif

	if !lJob .and. !lUsrView .and. lBlqTit	
		if	xPar03 == 2 .or. xPar03 == 3
			RecLock("SE2",.f.)
				SE2->E2_ZZCRGRT	:= iif( nTamCrg <= 1 , "S" , cUserRot )
	    	MsUnlock("SE2")
		endif     
	endif     

	if	lSE2Excl .or. !Empty(SE2->E2_FILIAL)
		cFilAnt	:= SE2->E2_FILIAL
	elseif	lSA2Excl .or. lSA6Excl	
		cFilAnt	:= SE2->E2_FILORIG
	endif	

	if	xFilTmp	<> cFilAnt 
		xFilTmp	:= cFilAnt 
		xBcoPad	:= GetMv("ZZ_BCOPADP") 
		xFilCen	:= GetMv("ZZ_FILAGTB") 
		cDirImg	:= iif( lCCL .or. lCheck , Alltrim(GetMv("MV_DIRIMGS")) , "" )
	endif

	if	Empty(SE2->E2_ZZBCO) .and. !Empty(xBcoPad)
		aRet := xRetBcoPad(xBcoPad,nTamBco,nTamAge,nTamCta)
		if	Len(aRet) <> 0 .and. Len(aRet) >= 3 	 	
			RecLock("SE2",.f.)
				SE2->E2_ZZBCO		:=	aRet[1]	
				SE2->E2_ZZAGE		:=	aRet[2]	
				SE2->E2_ZZCTA		:=	aRet[3]	
			MsUnlock("SE2")
		endif
	endif	

	if	lBolAut .and. Empty(SE2->E2_ZZTPPG) .and. !Empty(SE2->E2_CODBAR)
		RecLock("SE2",.f.)
			SE2->E2_ZZTPPG			:=	"B"
		MsUnlock("SE2")
	endif
	
	if	lDepAut .and. Empty(SE2->E2_ZZTPPG) .and. Empty(SE2->E2_CODBAR)
		RecLock("SE2",.f.)
			SE2->E2_ZZTPPG			:=	"D"
		MsUnlock("SE2")
	endif
	
	aAdd(aArray,Array(nTamTot))
	
	aArray[Len(aArray),nSeqArr] 	:= 	Len(aArray) 
	aArray[Len(aArray),nPosRec] 	:= 	XSE2->RECNOSE2
	aArray[Len(aArray),nRecSA2] 	:= 	XSE2->RECNOSA2

	aArray[Len(aArray),nRecPDF] 	:=	00
	aArray[Len(aArray),nRecSEA] 	:=	00

	aArray[Len(aArray),nTipoPg] 	:= 	""
	aArray[Len(aArray),nPosStt] 	:= 	""
	aArray[Len(aArray),nPosPed] 	:= 	""
	aArray[Len(aArray),nPosBco] 	:= 	""
	aArray[Len(aArray),nPosAge] 	:= 	""
	aArray[Len(aArray),nPosCon] 	:= 	""
	aArray[Len(aArray),nModCrd] 	:= 	""
	aArray[Len(aArray),nCodCrd] 	:= 	""
	aArray[Len(aArray),nBorUsu] 	:= 	""
	aArray[Len(aArray),nBorDat] 	:= 	""
	aArray[Len(aArray),nBorHor] 	:= 	""
	aArray[Len(aArray),nColApv] 	:= 	""
	aArray[Len(aArray),nPosOrd] 	:= 	""
	aArray[Len(aArray),nDirPDF] 	:=	""
	aArray[Len(aArray),nDirAut] 	:=	""
	aArray[Len(aArray),nCndPed] 	:=	""
	aArray[Len(aArray),nTipPix]		:=	""
	aArray[Len(aArray),nChvPix]		:=	""
	
	aArray[Len(aArray),nAtuTpP] 	:= 	.f.
	aArray[Len(aArray),nPosFlg] 	:= 	.f.
	aArray[Len(aArray),nAltBcP] 	:= 	.f.
	aArray[Len(aArray),nVincPa] 	:= 	.f.
	aArray[Len(aArray),nExcTit] 	:= 	.f.
	aArray[Len(aArray),nPosMsg] 	:= 	.f.
	aArray[Len(aArray),nAltTrb] 	:=	.f.
	aArray[Len(aArray),nFinPDF] 	:=	.f.
	aArray[Len(aArray),nNfePDF] 	:=	.f.    
	aArray[Len(aArray),nGerAut]		:=	.f.    
	aArray[Len(aArray),nTemPix]		:=	.f.    

	aArray[Len(aArray),nTamTot] 	:=	nTamTot
	aArray[Len(aArray),nFilCen] 	:=	xFilCen
	aArray[Len(aArray),nDirImg] 	:=	cDirImg
	aArray[Len(aArray),nCgcFor] 	:= 	SA2->A2_CGC    
	aArray[Len(aArray),nPosNom] 	:= 	SA2->A2_NOME
	aArray[Len(aArray),nEmlFor] 	:= 	SA2->A2_EMAIL
	aArray[Len(aArray),nBcoDep] 	:= 	SA2->A2_BANCO
	aArray[Len(aArray),nCtaDep] 	:= 	SA2->A2_NUMCON
	aArray[Len(aArray),nTipCta] 	:= 	SA2->A2_TIPCTA 
	aArray[Len(aArray),nPosCdB] 	:= 	SE2->E2_CODBAR	
	aArray[Len(aArray),nBcoPag] 	:= 	SA2->A2_ZZBCPAG 	
	aArray[Len(aArray),nAgeDep] 	:= 	SA2->A2_AGENCIA
	aArray[Len(aArray),nModImp] 	:= 	SE2->E2_ZZMODBD	
	aArray[Len(aArray),nModBor] 	:= 	Empty(SE2->E2_ZZMODBD)	

	aArray[Len(aArray),nDigAge] 	:= 	iif( SA2->(FieldPos(cDigAge))      <> 0 										, &("SA2->" + cDigAge) 		, "" 			) 
	aArray[Len(aArray),nDigCta] 	:= 	iif( SA2->(FieldPos(cDigCta))      <> 0 										, &("SA2->" + cDigCta) 		, "" 			) 
	aArray[Len(aArray),nCgcBen] 	:= 	iif( SA2->(FieldPos("A2_ZZCGC"))   <> 0 										, SA2->A2_ZZCGC  			, ""       		)
	aArray[Len(aArray),nFormPg] 	:= 	iif( SA2->(FieldPos("A2_FORMPAG")) <> 0											, SA2->A2_FORMPAG			, "" 			) 
	aArray[Len(aArray),nPosBen] 	:= 	iif( SA2->(FieldPos("A2_ZZBENEF")) <> 0 										, SA2->A2_ZZBENEF			, ""       		)
	aArray[Len(aArray),nMsgErr]		:=	iif( SE2->(FieldPos("E2_ZZMSGER")) <> 0 										, SE2->E2_ZZMSGER  			, ""       		)
	aArray[Len(aArray),nAglFor] 	:= 	iif( SA2->(FieldPos('A2_ZZAGTED')) <> 0 .and. SA2->A2_ZZAGTED == "N"			, .f. 						, .t.       	)
	aArray[Len(aArray),nPrfPag] 	:= 	iif( SA2->(FieldPos('A2_ZZPFPG'))  <> 0 .and. !Empty(SA2->A2_ZZPFPG)			, Alltrim(SA2->A2_ZZPFPG)	, "O"      		)
	aArray[Len(aArray),nTipTit] 	:= 	iif( Upper(Alltrim(SE2->E2_TIPO))  <> "PA"               						, "1" 						, "2" 			)
	aArray[Len(aArray),xModBor] 	:= 	iif( Empty(SE2->E2_ZZMODBD)														, "1" 						, "2" 			)

	if	SE2->(FieldPos("E2_ZZLINDG")) <> 0
		aArray[Len(aArray),nPosLnD]	:=	SE2->E2_ZZLINDG 
	elseif	SE2->(FieldPos("E2_LINDIGT")) <> 0
		aArray[Len(aArray),nPosLnD]	:=	SE2->E2_LINDIGT
	elseif	SE2->(FieldPos("E2_LINDIG")) <> 0
		aArray[Len(aArray),nPosLnD]	:=	SE2->E2_LINDIG
	else	 
		aArray[Len(aArray),nPosLnD]	:=	""
	endif	

	For w := 1 to Len(aStruct)
		if	aStruct[w,02] == "M"
			aArray[Len(aArray),w] 	:=	""
		else
			aArray[Len(aArray),w] 	:=	&("SE2->" + AllTrim(aStruct[w,01]))
		endif
	Next w

	if	aArray[Len(aArray),nPrfPag] $ "B/D/T" .and. Empty(aArray[Len(aArray),nTipoPg])
		aArray[Len(aArray),nTipoPg] := 	iif( aArray[Len(aArray),nPrfPag] == "D" , "Deposito" , "Boleto" )
	endif
	
	nSaldo	:=	Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)

	aArray[Len(aArray),SE2->(FieldPos("E2_SALDO"))]		:=	nSaldo	      
	
	if	nSaldo <= 0
		nLin := 0
	endif

	aArray[Len(aArray),nSldPis] 						:= 	SE2->E2_PIS 	- SE2->E2_VRETPIS
	aArray[Len(aArray),nSldCof] 						:= 	SE2->E2_COFINS	- SE2->E2_VRETCOF
	aArray[Len(aArray),nSldCsl] 						:= 	SE2->E2_CSLL	- SE2->E2_VRETCSL

	aArray[Len(aArray),SE2->(FieldPos("E2_PIS"))]		:= 	aArray[Len(aArray),nSldPis]
	aArray[Len(aArray),SE2->(FieldPos("E2_COFINS"))]	:= 	aArray[Len(aArray),nSldCof]
	aArray[Len(aArray),SE2->(FieldPos("E2_CSLL"))]		:= 	aArray[Len(aArray),nSldCsl]    
	
	nValRet												:=	aArray[Len(aArray),nSldPis] + aArray[Len(aArray),nSldCof] + aArray[Len(aArray),nSldCsl]

	aArray[Len(aArray),nLogRet] 						:= 	iif( nValRet <> 0 , "1" , "2" )

	if	lAgtAll
		aArray[Len(aArray),nLogRet] 					:= 	"1"
	endif

	aArray[Len(aArray),nSldLiq] 						:= 	nSaldo	
	aArray[Len(aArray),nSldLiq] 						-= 	aArray[Len(aArray),nSldPis]
	aArray[Len(aArray),nSldLiq] 						-= 	aArray[Len(aArray),nSldCof]
	aArray[Len(aArray),nSldLiq] 						-= 	aArray[Len(aArray),nSldCsl]

	aArray[Len(aArray),nChkDoc]							:=	Nil

	if	SE2->(FieldPos("E2_ZZPDF")) <> 0 .and. !Empty(SE2->E2_ZZPDF)
		aArray[Len(aArray),nFinPDF]						:=	.t.
		aArray[Len(aArray),nRecPDF] 					:= 	SE2->(Recno())
		aArray[Len(aArray),nDirPDF] 					:= 	Alltrim(SE2->E2_ZZPDF)
		aArray[Len(aArray),nChkDoc] 					:= 	File(Alltrim(SE2->E2_ZZPDF))
		aArray[Len(aArray),nNfePDF] 					:= 	!Empty(Alltrim(SE2->E2_ZZPDF))
	endif

	SA2->(dbgoto(XSE2->RECNOSA2))
	SE2->(dbgoto(XSE2->RECNOSE2))     

	if	lPix

		cQuery	:=	" Select * "
		cQuery	+=	" From " + RetSqlName("F72")
		cQuery	+=	" Where F72_FILIAL  = '" + SA2->A2_FILIAL				+ "' and " 
		cQuery	+=		"   F72_COD     = '" + SA2->A2_COD					+ "' and " 
		cQuery	+=		"   F72_LOJA    = '" + SA2->A2_LOJA					+ "' and " 
		cQuery	+=		"   F72_TPCHV  <> '" + CriaVar("F72_TPCHV",.f.)		+ "' and " 
		cQuery	+=		"   F72_CHVPIX <> '" + CriaVar("F72_CHVPIX",.f.)	+ "' and " 
		cQuery	+=		"   D_E_L_E_T_  = ' '                                        "
		cQuery	+=	" Order By F72_ACTIVE                                            " 
		
		TcQuery ChangeQuery(@cQuery) New Alias "XF72"

		if	XF72->(!Bof()) .and. XF72->(!Eof())					
			aArray[Len(aArray),nTemPix]		:=	.t.    
			if	Upper(Alltrim(XF72->F72_TPCHV)) == "01"
				aArray[Len(aArray),nTipPix]	:=	"Telefone"
			elseif	Upper(Alltrim(XF72->F72_TPCHV)) == "02"
				aArray[Len(aArray),nTipPix]	:=	"E-mail"
			elseif	Upper(Alltrim(XF72->F72_TPCHV)) == "03"
				aArray[Len(aArray),nTipPix]	:=	"CPF/CNPJ"
			else
				aArray[Len(aArray),nTipPix]	:=	"Aleat๓ria"
			endif
			aArray[Len(aArray),nChvPix]		:=	XF72->F72_CHVPIX
		endif

		XF72->(dbclosearea())

	endif
	
	SA2->(dbgoto(XSE2->RECNOSA2))
	SE2->(dbgoto(XSE2->RECNOSE2))     

	xStatusArr(@aArray,nSaldo,Len(aArray))

	if	lShowPed .or. ( lShowNf .and. ( !aArray[Len(aArray),nFinPDF] .or. ( aArray[Len(aArray),nNfePDF] .and. !aArray[Len(aArray),nChkDoc] ) ) )  
		if	SF1->(MsSeek( xFilial("SF1") + SE2->(E2_FORNECE + E2_LOJA + E2_NUM) , .f. ))
			do while SF1->(!Eof()) .and. SF1->(F1_FILIAL + F1_FORNECE + F1_LOJA + F1_DOC) == ( xFilial("SF1") + SE2->(E2_FORNECE + E2_LOJA + E2_NUM) )
				if	SF1->F1_PREFIXO == SE2->E2_PREFIXO
					if	lCCL
						if	lShowNf .and. ( !aArray[Len(aArray),nFinPDF] .or. ( aArray[Len(aArray),nNfePDF] .and. !aArray[Len(aArray),nChkDoc] ) )
							if 	Empty(Alltrim(SF1->F1_ZZPDF))
								aDirImg	:=	U_fSalvaIMG(Nil,.f.,.t.)
								xDirImg	:=	U_fSalvaIMG(Nil,.f.,.f.,.t.)
								if	ValType(aDirImg) == "A" .and. Len(aDirImg) <> 0
									RecLock("SF1",.f.)
										SF1->F1_ZZPDF	:=	Alltrim(xDirImg + aDirImg[01,01])
									MsUnlock("SF1")	
								endif
							endif
							aArray[Len(aArray),nFinPDF]	:=	.f.
							aArray[Len(aArray),nRecPDF]	:=	SF1->(Recno())
							aArray[Len(aArray),nDirPDF] :=	Alltrim(SF1->F1_ZZPDF)
							aArray[Len(aArray),nChkDoc] := 	File(aArray[Len(aArray),nDirPDF])
							aArray[Len(aArray),nNfePDF]	:=	!Empty(aArray[Len(aArray),nDirPDF])
						endif
					elseif	lCheck
						if	lShowNf .and. !aArray[Len(aArray),nFinPDF] 
							cNewFile := ""									
							if	Empty(Alltrim(SF1->F1_ZZPDF))
								cNewFile := U_xGetPathImg(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"jpg")
								if !File(cNewFile)
									cNewFile := U_xGetPathImg(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"pdf")
									if !File(cNewFile)
										cNewFile := U_xGetPathImg(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"bmp")
										if !File(cNewFile)
											cNewFile := U_xGetPathImg(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"jpeg")
											if !File(cNewFile)
												cNewFile := U_xGetPathImg(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"doc")
												if !File(cNewFile)
													cNewFile := U_xGetPathImg(SF1->F1_DOC,SF1->F1_SERIE,SF1->F1_FORNECE,SF1->F1_LOJA,"docx")
													if !File(cNewFile)
														cNewFile := ""									
													endif
												endif
											endif
										endif
									endif
								endif
							endif
							aArray[Len(aArray),nRecPDF]	:=	SF1->(Recno())
							aArray[Len(aArray),nDirPDF] :=	iif( Empty(Alltrim(SF1->F1_ZZPDF)) , cNewFile , Alltrim(SF1->F1_ZZPDF) )
							aArray[Len(aArray),nChkDoc] := 	File(aArray[Len(aArray),nDirPDF])
							aArray[Len(aArray),nNfePDF]	:=	!Empty(aArray[Len(aArray),nDirPDF])
						endif
					endif
					if	lShowPed
						if	SD1->(MsSeek( xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) , .f. ))
							do while SD1->(!Eof()) .and. SD1->(D1_FILIAL + D1_DOC + D1_SERIE + D1_FORNECE + D1_LOJA) == ( xFilial("SD1") + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) )
								if	!Empty(SD1->D1_PEDIDO) .and. !Empty(SD1->D1_ITEMPC)
									if	Empty(aArray[Len(aArray),nPosPed])
										aArray[Len(aArray),nPosPed]	:= 	SD1->D1_PEDIDO
										aArray[Len(aArray),nCndPed]	:=	iif( lFadel , Posicione("SC7",01,xFilial("SC7") + SD1->D1_PEDIDO,"C7_COND") , "" )
										if !Empty(aArray[Len(aArray),nCndPed]) 
											aArray[Len(aArray),nCndPed]	:=	Alltrim(Posicione("SE4",01,xFilial("SE4") + aArray[Len(aArray),nCndPed],"E4_DESCRI"))
										endif
										Exit
									endif
								endif
								SD1->(dbskip())
							enddo
						endif
					endif
					Exit
				endif
				SF1->(dbskip())
			enddo
		endif
	endif

	SA2->(dbgoto(XSE2->RECNOSA2))
	SE2->(dbgoto(XSE2->RECNOSE2))     

	if	lShowNf
		if !aArray[Len(aArray),nFinPDF] 
			if	aArray[Len(aArray),nChkDoc]
				if	SE2->(FieldPos("E2_ZZPDF")) <> 0
					if !Empty(SE2->E2_ZZPDF) 
						if !File(Alltrim(SE2->E2_ZZPDF))
							RecLock("SE2",.f.)
								SE2->E2_ZZPDF	:=	aArray[Len(aArray),nDirPDF]
							MsUnlock("SE2")	
						endif
					endif
				endif
			endif
		endif
	endif

	if	lShowNf
		if !aArray[Len(aArray),nFinPDF]
			if	SE2->(FieldPos("E2_ZZPDF")) <> 0
				if	Empty(SE2->E2_ZZPDF) 
					aDirImg	:=	U_fSalvaIMG(Nil,.t.,.t.)
					xDirImg	:=	U_fSalvaIMG(Nil,.t.,.f.,.t.)
					if	ValType(aDirImg) == "A" .and. Len(aDirImg) <> 0
						aArray[Len(aArray),nFinPDF]		:=	.t.
						aArray[Len(aArray),nRecPDF] 	:= 	SE2->(Recno())
						aArray[Len(aArray),nDirPDF] 	:= 	Alltrim(xDirImg + aDirImg[01,01])
						aArray[Len(aArray),nChkDoc] 	:= 	File(aArray[Len(aArray),nDirPDF])
						aArray[Len(aArray),nNfePDF] 	:= 	!Empty(aArray[Len(aArray),nDirPDF])
						if	aArray[Len(aArray),nChkDoc]
							RecLock("SE2",.f.)
								SE2->E2_ZZPDF			:=	aArray[Len(aArray),nDirPDF]
							MsUnlock("SE2")	
						endif
					endif
				endif
			endif
		endif
	endif

	SA2->(dbgoto(XSE2->RECNOSA2))
	SE2->(dbgoto(XSE2->RECNOSE2))     

	SEA->(dbsetorder(2))       

	lFound	:=	.f.
	
	if	lFilCen
		if	SEA->( MsSeek( xFilial("SEA") + SE2->(E2_NUMBOR + "P" + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. )) 	
			lFound	:=	.t.
		else
			For s := 1 to Len(aFiliais)
				if	SEA->( MsSeek( xFilial("SEA",aFiliais[s]) + SE2->E2_NUMBOR + "P" + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. ))
					lFound	:=	.t.
		    		Exit
		       	endif
			Next s    
		endif	
	else
		lFound	:=	SEA->( MsSeek( xFilial("SEA") + SE2->(E2_NUMBOR + "P" + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. )) 	
	endif

	if	Empty(SE2->E2_NUMBOR) .or. !lFound
		if !Empty(SE2->E2_ZZBCO)
			aArray[Len(aArray),nPosBco] := 	SE2->E2_ZZBCO
			aArray[Len(aArray),nPosAge] := 	SE2->E2_ZZAGE
			aArray[Len(aArray),nPosCon]	:= 	SE2->E2_ZZCTA
		endif     
		if !Empty(SE2->E2_ZZTPPG)
			aArray[Len(aArray),nTipoPg]	:=	iif( SE2->E2_ZZTPPG == "B" , "Boleto" , iif( SE2->E2_ZZTPPG == "D" , "Deposito" , "Tributo" ) )
		endif
	else		
		if	lFound
			aArray[Len(aArray),nModCrd]	:=	""    
			aArray[Len(aArray),nPosBco] := 	SEA->EA_PORTADO
			aArray[Len(aArray),nPosAge] := 	SEA->EA_AGEDEP
			aArray[Len(aArray),nPosCon] := 	SEA->EA_NUMCON
			aArray[Len(aArray),nCodCrd]	:=	SEA->EA_MODELO  
			aArray[Len(aArray),nGerAut]	:=	SEA->(FieldPos("EA_ZZARQGR")) <> 0 .and. !Empty(SEA->EA_ZZARQGR)
			aArray[Len(aArray),nDirAut]	:=	iif( SEA->(FieldPos("EA_ZZARQGR")) <> 0 , SEA->EA_ZZARQGR , "" )
			aArray[Len(aArray),nTipoPg]	:=	iif( SEA->EA_MODELO $ "01/03/05/41/43/45" , "Deposito" , iif( SEA->EA_MODELO $ "13/30/31" , "Boleto" , "Tributo" ) )
		endif
	endif

	if !Empty(aArray[Len(aArray),nCodCrd])
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
		elseif	aArray[Len(aArray),nCodCrd]	==	"45"
			aArray[Len(aArray),nModCrd] := 	"PIX"
		elseif	aArray[Len(aArray),nCodCrd]	==	"47"
			aArray[Len(aArray),nModCrd] := 	"PIX - QR Code"
		endif
	endif

	// GPS sem c๓digo de Barras

	if !Empty(aArray[Len(aArray),SE2->(FieldPos('E2_CODINS'))])		.and. 	;
	   !Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZCNPJ'))])		.and. 	;
	   !Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZREFMA'))])	.and. 	;
		Empty(aArray[Len(aArray),SE2->(FieldPos('E2_CODBAR'))])    	.and.	;
		Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZMODBD'))])   	.and. 	;
		aArray[Len(aArray),SE2->(FieldPos('E2_ZZVLPR'))] + aArray[Len(aArray),SE2->(FieldPos('E2_ZZVLJR'))] + aArray[Len(aArray),SE2->(FieldPos('E2_ZZVLMT'))] > 0	
		aArray[Len(aArray),nCodCrd] :=	"17" 
		aArray[Len(aArray),nModCrd] := 	"Gps"
		aArray[Len(aArray),nTipoPg]	:= 	"Tributo" 
	endif

	// Darf sem c๓digo de Barras

	if !Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZDTAP'))])		.and. 	;
	   !Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZCNPJ'))])		.and. 	;
	   !Empty(aArray[Len(aArray),SE2->(FieldPos('E2_CODRET'))])		.and. 	;
	   !Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZDTVC'))])		.and. 	;
		Empty(aArray[Len(aArray),SE2->(FieldPos('E2_CODBAR'))])    	.and.	;
		Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZMODBD'))])   	.and. 	;
		aArray[Len(aArray),SE2->(FieldPos('E2_ZZVLPR'))] + aArray[Len(aArray),SE2->(FieldPos('E2_ZZVLJR'))] + aArray[Len(aArray),SE2->(FieldPos('E2_ZZVLMT'))] > 0	
		aArray[Len(aArray),nCodCrd] :=	"16" 
		aArray[Len(aArray),nModCrd] := 	"Darf"
		aArray[Len(aArray),nTipoPg]	:= 	"Tributo" 
	endif

	// Darf Simples sem c๓digo de Barras

	if !Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZDTAP'))])													.and. 	;
	   !Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZCNPJ'))])													.and. 	;
	   !Empty(aArray[Len(aArray),SE2->(FieldPos('E2_CODRET'))])													.and. 	;
		Empty(aArray[Len(aArray),SE2->(FieldPos('E2_CODBAR'))])    												.and.	;
		Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZMODBD'))])   												.and. 	;
		aArray[Len(aArray),SE2->(FieldPos('E2_ZZVLPR'))] > 0 													.and.	;
		iif( SE2->(FieldPos("E2_ZZPRCS")) <> 0 , aArray[Len(aArray),SE2->(FieldPos("E2_ZZPRCS"))] > 0 , .f. ) 	.and.	; 
		iif( SE2->(FieldPos("E2_ZZPRIS")) <> 0 , aArray[Len(aArray),SE2->(FieldPos("E2_ZZPRIS"))] > 0 , .f. ) 	
		if	SE2->(FieldPos("E2_ZZPRIS")) <> 0 
			if	aArray[Len(aArray),SE2->(FieldPos("E2_ZZPRIS"))] + ;
				aArray[Len(aArray),SE2->(FieldPos('E2_ZZVLJR'))] + ;
				aArray[Len(aArray),SE2->(FieldPos('E2_ZZVLMT'))] > 0	
				aArray[Len(aArray),nCodCrd] :=	"18" 
				aArray[Len(aArray),nModCrd] := 	"Darf Simples"
				aArray[Len(aArray),nTipoPg]	:= 	"Tributo" 
			endif
		endif
	endif

	// Ipva ou Dpvat sem c๓digo de Barras

	if	!Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZRENAV'))])	.and. 	;
		!Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZPLACA'))])	.and. 	;
		!Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZESTVC'))])	.and. 	;
		!Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZCODMN'))])	.and. 	;
		!Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ANOBASE'))])	.and. 	;
		!Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZOPPGT'))])   .and.	;
		 Empty(aArray[Len(aArray),SE2->(FieldPos('E2_CODBAR'))])    .and.	;
		 Empty(aArray[Len(aArray),SE2->(FieldPos('E2_ZZMODBD'))])
		if	Upper(Alltrim(aArray[Len(aArray),SE2->(FieldPos('E2_ZZOPPGT'))])) == "0"	
			aArray[Len(aArray),nCodCrd]	:=	"27"                                     		
			aArray[Len(aArray),nModCrd] := 	"Dpvat (SP/MG/RJ)"
			aArray[Len(aArray),nTipoPg]	:=	"Tributo"   
		else
			aArray[Len(aArray),nCodCrd]	:=	"25"                                     		
			aArray[Len(aArray),nModCrd] := 	"Ipva (SP/MG/RJ)"
			aArray[Len(aArray),nTipoPg]	:=	"Tributo"   
		endif	
	else
		aArray[Len(aArray),SE2->(FieldPos('E2_ZZRENAV'))]	:=	""
		aArray[Len(aArray),SE2->(FieldPos('E2_ZZPLACA'))]	:=	""
		aArray[Len(aArray),SE2->(FieldPos('E2_ZZESTVC'))]	:=	""
		aArray[Len(aArray),SE2->(FieldPos('E2_ZZCODMN'))]	:=	""
		aArray[Len(aArray),SE2->(FieldPos('E2_ANOBASE'))]	:=	""
		aArray[Len(aArray),SE2->(FieldPos('E2_ZZOPPGT'))]	:=	""
	endif

	// Impostos com c๓digo de barras 

	if !Empty(aArray[Len(aArray),nModImp]) 
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
		elseif	aArray[Len(aArray),nCodCrd]	==	"21"                                     		
			aArray[Len(aArray),nModCrd] := 	"DARJ"
		elseif	aArray[Len(aArray),nCodCrd]	==	"22"                                     		
			aArray[Len(aArray),nModCrd] := 	"Gare - SP"
		elseif	aArray[Len(aArray),nCodCrd]	==	"25"                                     		
			aArray[Len(aArray),nModCrd] := 	"Ipva (SP/MG/RJ)"
		elseif	aArray[Len(aArray),nCodCrd]	==	"27"                                     		
			aArray[Len(aArray),nModCrd] := 	"Dpvat (SP/MG/RJ)"
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

	SE2->(dbgoto(XSE2->RECNOSE2))

	if	SE2->(FieldPos('E2_ZZMSGFN')) <> 0 
		if !Empty(Alltrim(SE2->E2_ZZMSGFN))
			aArray[Len(aArray),nPosMsg] := .t.
		endif
	endif
	
	if	SE2->(FieldPos('E2_ZZMSGER')) <> 0 
		if !Empty(Alltrim(SE2->E2_ZZMSGER))
			aArray[Len(aArray),nPosMsg] := .t.
		endif
	endif

	if	lAtivo
		if !Empty(SE2->E2_NUMBOR) 
		
			SEA->(dbsetorder(2))  
			
			if !SEA->(dbseek( SE2->(E2_FILIAL + E2_NUMBOR + "P" + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. )) 
			 	SEA->(dbseek( xFilial("SEA",SE2->E2_FILIAL) + SE2->(E2_NUMBOR + "P" + E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. )) 
	      	endif
	
			if	SEA->(!Eof())
	
				if	lCCL .or. lCheck .or. lMastra 
				
					cQuery	:=	" Select * " 
					cQuery	+=	" From " + RetSqlName("Z43")
					cQuery	+=	" Where Z43_FILIAL  >= '" + Replicate(" ",FwSizeFilial())	+ "' and "
					cQuery	+=		"   Z43_FILIAL  <= '" + Replicate("Z",FwSizeFilial())	+ "' and "
					cQuery	+=		"   Z43_NUMBOR   = '" + SE2->E2_NUMBOR               	+ "' and "
					cQuery	+=		"   Z43_BANCO    = '" + SEA->EA_PORTADO              	+ "' and "
					cQuery	+=		"   Z43_AGENC    = '" + SEA->EA_AGEDEP               	+ "' and "
					cQuery	+=		"   Z43_CONTA    = '" + SEA->EA_NUMCON               	+ "' and "
					cQuery	+=		"   D_E_L_E_T_   = ' '                                           " 
		
					TcQuery ChangeQuery(@cQuery) New Alias "XQRY"
		
					if	XQRY->(!Bof()) .and. XQRY->(!Eof())
						aArray[Len(aArray),nBorUsu] 	:=	XQRY->Z43_USDBOR
						if	nQtdApr == 1 .and. !Empty(XQRY->Z43_DTAPV1)
							aArray[Len(aArray),nColApv]	:=	"2"
						elseif	nQtdApr == 2 .and. !Empty(XQRY->Z43_DTAPV2)
							aArray[Len(aArray),nColApv]	:=	"2"
						elseif	nQtdApr == 2 .and. !Empty(XQRY->Z43_DTAPV1)
							aArray[Len(aArray),nColApv]	:=	"1"
						endif				
						if	!Empty(aArray[Len(aArray),nColApv])
							aArray[Len(aArray),nPosStt]	:= 	"8"								
							aArray[Len(aArray),nPosFlg]	:= 	.f.								
						endif
					endif
		
					XQRY->(dbclosearea())
		
					cQuery	:=	" Select * " 
					cQuery	+=	" From " + RetSqlName("Z44")
					cQuery	+=	" Where Z44_FILIAL   = '" + xFilial("Z44")               	+ "' and "
					cQuery	+=		"   Z44_NUMBOR   = '" + SE2->E2_NUMBOR               	+ "' and "
					cQuery	+=		"   Z44_BANCO    = '" + SEA->EA_PORTADO              	+ "' and "
					cQuery	+=		"   Z44_AGENC    = '" + SEA->EA_AGEDEP               	+ "' and "
					cQuery	+=		"   Z44_CONTA    = '" + SEA->EA_NUMCON               	+ "' and "
					cQuery	+=		"   Z44_EMPBOR   = '" + cEmpAnt                      	+ "' and "
					cQuery	+=		"   D_E_L_E_T_   = ' '                                           " 
		
					TcQuery ChangeQuery(@cQuery) New Alias "XQRY"
		
					if	XQRY->(!Bof()) .and. XQRY->(!Eof())
						aArray[Len(aArray),nBorDat] := 	DtoC(StoD(XQRY->Z44_DATGER))
						aArray[Len(aArray),nBorHor] := 	XQRY->Z44_HORGER
					endif
		
					XQRY->(dbclosearea())
					
				else
				
					cQuery	:=	" Select * " 
					cQuery	+=	" From " + RetSqlName("ZAT")
					cQuery	+=	" Where ZAT_FILIAL  >= '" + Replicate(" ",FwSizeFilial())	+ "' and "
					cQuery	+=		"   ZAT_FILIAL  <= '" + Replicate("Z",FwSizeFilial())	+ "' and "
					cQuery	+=		"   ZAT_NUMBOR   = '" + SE2->E2_NUMBOR               	+ "' and "
					cQuery	+=		"   ZAT_BANCO    = '" + SEA->EA_PORTADO              	+ "' and "
					cQuery	+=		"   ZAT_AGENC    = '" + SEA->EA_AGEDEP               	+ "' and "
					cQuery	+=		"   ZAT_CONTA    = '" + SEA->EA_NUMCON               	+ "' and "
					cQuery	+=		"   D_E_L_E_T_   = ' '                                           " 
		
					TcQuery ChangeQuery(@cQuery) New Alias "XQRY"
		
					if	XQRY->(!Bof()) .and. XQRY->(!Eof())
						aArray[Len(aArray),nBorUsu] 	:=	XQRY->ZAT_USDBOR
						if	nQtdApr == 1 .and. !Empty(XQRY->ZAT_DTAPV1)
							aArray[Len(aArray),nColApv]	:=	"2"
						elseif	nQtdApr == 2 .and. !Empty(XQRY->ZAT_DTAPV2)
							aArray[Len(aArray),nColApv]	:=	"2"
						elseif	nQtdApr == 2 .and. !Empty(XQRY->ZAT_DTAPV1)
							aArray[Len(aArray),nColApv]	:=	"1"
						endif				
						if	!Empty(aArray[Len(aArray),nColApv])
							aArray[Len(aArray),nPosStt]	:= 	"8"								
							aArray[Len(aArray),nPosFlg]	:= 	.f.								
						endif
					endif
		
					XQRY->(dbclosearea())
		
					cQuery	:=	" Select * " 
					cQuery	+=	" From " + RetSqlName("ZAV")
					cQuery	+=	" Where ZAV_FILIAL   = '" + xFilial("ZAV")               	+ "' and "
					cQuery	+=		"   ZAV_NUMBOR   = '" + SE2->E2_NUMBOR               	+ "' and "
					cQuery	+=		"   ZAV_BANCO    = '" + SEA->EA_PORTADO              	+ "' and "
					cQuery	+=		"   ZAV_AGENC    = '" + SEA->EA_AGEDEP               	+ "' and "
					cQuery	+=		"   ZAV_CONTA    = '" + SEA->EA_NUMCON               	+ "' and "
					cQuery	+=		"   ZAV_EMPBOR   = '" + cEmpAnt                      	+ "' and "
					cQuery	+=		"   D_E_L_E_T_   = ' '                                           " 
		
					TcQuery ChangeQuery(@cQuery) New Alias "XQRY"
		
					if	XQRY->(!Bof()) .and. XQRY->(!Eof())
						aArray[Len(aArray),nBorDat] := 	DtoC(StoD(XQRY->ZAV_DATGER))
						aArray[Len(aArray),nBorHor] := 	XQRY->ZAV_HORGER
					endif
		
					XQRY->(dbclosearea())
	
				endif
			endif
		endif
	endif

	SE2->(dbgoto(XSE2->RECNOSE2))

	if !Empty(SE2->E2_NUMBOR)
		SEA->(dbsetorder(2))
  		if	SEA->(dbseek( xFilial("SEA") + SE2->E2_NUMBOR + "P" + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. ))
  			aArray[Len(aArray),nRecSEA]	:=	SEA->(Recno())
  		else
			For t := 1 to Len(aFiliais)
				SE2->(dbgoto(XSE2->RECNOSE2))   
				if !Empty(aFiliais[t])
					cFilAnt := aFiliais[t]
				endif
				if	SEA->(dbseek( xFilial("SEA") + SE2->E2_NUMBOR + "P" + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. ))
					aArray[Len(aArray),nRecSEA]	:=	SEA->(Recno())
		    		Exit
		       	endif
			Next t    
  	    endif
    endif

	SE2->(dbgoto(XSE2->RECNOSE2))

	if	lSE2Excl .or. !Empty(SE2->E2_FILIAL)
		cFilAnt	:= SE2->E2_FILIAL
	elseif	lSA2Excl .or. lSA6Excl	
		cFilAnt	:= SE2->E2_FILORIG
	endif	

	if !lJob .and. !lUsrView .and. lBlqTit	
		if	xPar03 == 2 .or. xPar03 == 3
			RecLock("SE2",.f.)
				SE2->E2_ZZCRGRT	:= iif( nTamCrg <= 1 , "S" , cUserRot )
	    	MsUnlock("SE2")
		endif
	endif

	dbselectarea("XSE2")
	XSE2->(dbskip())
enddo

XSE2->(dbclosearea())

For w := 1 to Len(aArray)       
	if	aArray[w,nPosStt] <> "4"
		SE2->(dbgoto(aArray[w,nPosRec]))
		nSaldo := Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)
		xModPg(@aArray,w,nSaldo,!( aArray[w,nPosStt] $ "1/5/9" ))
	endif
Next w 

cFilAnt	:=	cFilTmp

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xExecQry(cQuery)

TcQuery cQuery New Alias "XSE2"

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetExPA()

Local lRet		:=	.f.
Local cQuery 	:=	Nil	 
Local cFilTmp	:=	cFilAnt
Local aAreaSE2	:=	SE2->(GetArea())

cQuery 	:= 	" SELECT * "
cQuery 	+= 	" FROM " + RetSqlName("SE2") + " SE2 "
cQuery 	+= 	" WHERE SE2.E2_FILIAL  >= '" + aFiliais[01]	 			+ "'  AND "
cQuery 	+= 		"   SE2.E2_FILIAL  <= '" + aFiliais[Len(aFiliais)] 	+ "'  AND "
cQuery 	+= 		"   SE2.E2_FORNECE  = '" + SE2->E2_FORNECE			+ "'  AND "
cQuery 	+= 		"   SE2.E2_LOJA     = '" + SE2->E2_LOJA   			+ "'  AND "
cQuery 	+= 		" ( SE2.E2_TIPO    IN  " + FormatIn(MVPAGANT,";")	+ "   OR  "
cQuery 	+= 		"   SE2.E2_TIPO    IN  " + FormatIn(MV_CPNEG,";")	+ " ) AND "
if	lLibPag
	cQuery += 	"   SE2.E2_DATALIB <> ' '                                 AND "
endif
cQuery 	+= 		"   SE2.E2_SALDO   >  0                                   AND "
cQuery 	+= 		"   SE2.D_E_L_E_T_ = ' '                                      "
	
TcQuery ChangeQuery(@cQuery) New Alias "TSE2"
	
do while TSE2->(!Eof())       	
	lRet := .t. 	
	if	lRet 
		Exit 
	endif
	TSE2->(dbskip())
enddo
	
TSE2->(dbclosearea())
	
if !lRet 
	if !Empty(cTipAdi)
		if	Upper(Alltrim(SE2->E2_TIPO)) $ Upper(Alltrim(cTipAdi))
			lRet := .t. 
		endif 
	endif 
endif 

RestArea(aAreaSE2)

cFilAnt := cFilTmp 

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fSelect(oDlg,oGrid,aArray)  

Local w     
Local oObj     
Local nVal     
Local dDat  
Local xMem
Local lRet
Local xSub    
Local xNom
Local xTxt
Local xRep
Local xTrb
Local xCod
Local xArq
Local xNew
Local xEml		:=	""
Local xCop		:=	""
Local xBcc		:=	""
Local cCod		:=	""
Local cLin		:=	""  
Local cTmp		:=	""    
Local xDrt		:=	""
Local aRet		:=	{}         
Local lAtu		:=	.f.
Local lMsg 		:=	.t.
Local lRep		:=	.f.
Local lGoF		:=	.t.   
Local lDsv		:=	.f.
Local lColLin	:=	.f.  
Local lColCod  	:=	.f.

Local nLin		:=	oGrid:nAt
Local nCol		:=	oGrid:nColPos     
Local xFilAnt	:=	cFilAnt
Local xFunName	:=	FunName()

Local lSA2Excl	:=	FwModeAccess("SA2") == "E"
Local lSA6Excl	:=	FwModeAccess("SA6") == "E"
Local lSE2Excl	:=	FwModeAccess("SE2") == "E"     

Local xObj		:= 	GeneralClass():New()

Local nOpc		:=	000   
Local nRecno	:=	000  
Local nIndex	:=	000
Local nSaldo	:=	000
Local xSaldo	:=	000
Local nRadio	:=	001

Local oRadio  	:=	Nil
Local oDlgAlt	:=	Nil

Local nColBco	:=	0
Local nColAge	:=	0
Local nColCta	:=	0
Local nColTip	:=	0
Local nColMod	:=	0
Local nColCod	:=	0
Local nColLin	:=	0
Local nColAcr	:=	0
Local nColDec	:=	0
Local nColVct	:=	0
Local nColTit	:=	0
Local nColImp	:=	0
Local nColFor	:=	0
Local nColLoj	:=	0
Local nColMsg	:=	0
Local nColPDF	:=	0
Local aColunas	:=	aClone(oGrid:aColumns)

Local cSMTP		:=	Alltrim(GetMv("MV_RELSERV"))                                               
Local nSMTPPort	:= 	GetMv("MV_GCPPORT")

if	":" $ cSMTP		
	cSMTP		:=	Substr( cSMTP , 01 , At(":",cSMTP) - 1 )
	nSMTPPort	:= 	Val(Substr( cSMTP , At(":",cSMTP) + 1 ))
endif

For w := 1 to Len(aColunas)
	oObj := aColunas[w]
	if	Upper(Alltrim(oObj:cHeading)) == "IMP"
		nColImp	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "NFE"
		nColPDF	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "MSG"
		nColMsg	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "BANCO PG"	
		nColBco	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "AGENCIA PG"	
		nColAge	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "CONTA PG"	
		nColCta	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "TIPO PAG"	
		nColTip	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "NUMERO"	
		nColTit	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "FORNECEDOR"
		nColFor	:=	w                                
	elseif	Upper(Alltrim(oObj:cHeading)) == "LOJA"
		nColLoj	:=	w                                
	elseif	Upper(Alltrim(oObj:cHeading)) == "MODELO"	
		nColMod	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "CODIGO DE BARRAS"
		nColCod	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "LINHA DIGITAVEL"
		nColLin	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "ACRESCIMO"
		nColAcr	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "VENC REAL"
		nColVct	:=	w
	elseif	Upper(Alltrim(oObj:cHeading)) == "DECRESCIMO"
		nColDec	:=	w
    endif
Next w 

if	nCol <> nColPDF .and. nCol <> nColMsg .and. nCol <> nColTit .and. nCol <> nColFor .and. nCol <> nColLoj 
	if	lUsrView 
		Return 
	else
		if !Empty(aArray[nLin,SE2->(FieldPos("E2_NUMBOR"))])
			MessageBox("Tํtulo com Border๔ Gerado. Nใo pode ser marcado/alterado.","Aten็ใo",MB_ICONHAND) 
			Return
		elseif 	aArray[nLin,nPosStt] == "8"								
			if !Empty(aArray[nLin,nColApv]) 
				MessageBox("Tํtulo com Border๔ Aprovado. Nใo pode ser marcado/alterado.","Aten็ใo",MB_ICONHAND) 
			else
				MessageBox("Tํtulo com Pedido de Alteracao de Vencimento Pendente.","Aten็ใo",MB_ICONHAND) 
			endif
			Return
		elseif 	aArray[nLin,nPosStt] == "9"								
			MessageBox("Tํtulo jแ baixado. Nใo pode ser marcado/alterado.","Aten็ใo",MB_ICONHAND) 
			Return 
		endif
	endif
endif
	
SE2->(dbgoto(aArray[nLin,nPosRec]))     

if	nCol == nColPDF	
	cFilAnt := aArray[nLin,SE2->(FieldPos("E2_FILIAL"))]
	if	lCCL 
		if	aArray[nLin,nNfePDF] <> Nil .and. aArray[nLin,nNfePDF]
			xDrt := Alltrim(aArray[nLin,nDirImg])
			xDrt += iif( Right(xDrt,01) == "\" , "" , "\" )
			if	aArray[nLin,nFinPDF] 
				SE2->(dbgoto(aArray[nLin,nRecPDF]))
				SA2->(dbgoto(aArray[nLin,nRecSA2]))
				xArq := U_fSalvaIMG(Nil,.t.,.t.)	
				xNew := U_fSalvaIMG(Nil,.t.,.f.,.t.)	 	
				if 	Len(xArq) <= 0 
					MessageBox("Documento vinculado nใo encontrado","Aten็ใo",MB_ICONHAND)             	
				elseif 	Len(xArq) == 1 
					U_fSavOpeDoc(Alltrim(xArq[1,1]),xNew)
				else
					U_fSalvaIMG(Nil,.t.)
				endif
			else
				SF1->(dbgoto(aArray[nLin,nRecPDF]))
				SA2->(dbgoto(aArray[nLin,nRecSA2]))
				xArq := U_fSalvaIMG(Nil,.f.,.t.)
				xNew := U_fSalvaIMG(Nil,.f.,.f.,.t.)
				if 	Len(xArq) <= 0 
					MessageBox("Documento vinculado nใo encontrado","Aten็ใo",MB_ICONHAND)             	
				elseif 	Len(xArq) == 1 
					U_fSavOpeDoc(Alltrim(xArq[1,1]),xNew)
				else
					U_fSalvaIMG(Nil,.f.)
				endif
			endif
		endif
	elseif	lCheck
		if	aArray[nLin,nNfePDF] <> Nil .and. aArray[nLin,nNfePDF]
			if	aArray[nLin,nRecPDF] == 0 
				MessageBox("Documento vinculado nใo encontrado","Aten็ใo",MB_ICONHAND)             	
			else
				if	aArray[nLin,nFinPDF] 
					SE2->(dbgoto(aArray[nLin,nRecPDF]))
					FwMsgRun( Nil , { || U_AbrirImg(Nil,.t.,Alltrim(SE2->E2_ZZPDF)) } , 'Processando' , "Buscando documento ..." )
				else
					SF1->(dbgoto(aArray[nLin,nRecPDF]))
					if	Empty(Alltrim(SF1->F1_ZZPDF)) .and. !Empty(aArray[nLin,nDirPDF])
						FwMsgRun( Nil , { || U_AbrirImg(Nil,.f.,aArray[nLin,nDirPDF]) 	} , 'Processando' , "Buscando documento ..." )     		
					else
						FwMsgRun( Nil , { || U_AbrirImg(Nil,.f.,Alltrim(SF1->F1_ZZPDF)) } , 'Processando' , "Buscando documento ..." )
					endif
				endif
			endif
		endif
	endif
	cFilAnt := xFilAnt
	Return 
elseif	nCol == nColMsg .and. SE2->(FieldPos('E2_ZZMSGFN')) <> 0       
	aArray[nLin,nPosMsg] :=	fVisMsg()
	aArray[nLin,nMsgErr] :=	iif( SE2->(FieldPos('E2_ZZMSGER')) <> 0 , SE2->E2_ZZMSGER , "" )
	if	aArray[nLin,nPosMsg] .and. !Empty(Alltrim(SE2->E2_ZZMSGFN)) 
		if	MessageBox("Deseja enviar por E-mail ?","Aten็ใo",MB_YESNO) == 6 
			xEml :=	Nil
			xTxt := Alltrim(SE2->E2_ZZMSGFN)	   
			xSub := "Titulo " + aArray[nLin,SE2->(FieldPos("E2_NUM"))] + " - " 
			xSub += Alltrim(Posicione("SA2",01,xFilial("SE2",aArray[nLin,SE2->(FieldPos("E2_FILIAL"))]) + aArray[nLin,SE2->(FieldPos("E2_FORNECE"))] + aArray[nLin,SE2->(FieldPos("E2_LOJA"))],"A2_NOME"))
			xNom := Alltrim(Posicione("SA2",01,xFilial("SE2",aArray[nLin,SE2->(FieldPos("E2_FILIAL"))]) + aArray[nLin,SE2->(FieldPos("E2_FORNECE"))] + aArray[nLin,SE2->(FieldPos("E2_LOJA"))],"A2_NOME"))
			if	Empty(UsrRetMail(RetCodUsr()))	
				xRep := Nil
			else
				xRep :=	Alltrim(Capital(UsrFullName(Alltrim(RetCodUsr())))) + " <" + Alltrim(UsrRetMail(RetCodUsr())) + ">" 
			endif
			if	xObj:TelaMail(@xEml,@xCop,@xBcc,@xTxt,.t.,.t.,@xSub,.f.)  
				xSub := Upper(AllTrim(SM0->M0_NOMECOM)) + " - " + xSub
				if	Empty(Alltrim(xCop))
					xCop := Alltrim(Capital(UsrFullName(Alltrim(RetCodUsr())))) + " <" + Alltrim(UsrRetMail(RetCodUsr())) + ">" 
				else
					xCop := Alltrim(xCop) + " ; " + Alltrim(Capital(UsrFullName(Alltrim(RetCodUsr())))) + " <" + Alltrim(UsrRetMail(RetCodUsr())) + ">" 
				endif   
				if	lRet == Nil .or. !lRet
					FwMsgRun( Nil , { || lRet := xDispMail(xEml,GetHtml(xTxt,xNom),xSub,Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">",Nil,xCop,xBcc) } , 'Processando' , "Enviando Email ..." )
				endif  	
				if	!lRet
					FwMsgRun( Nil , { || lRet := xObj:EnviaMail(xEml,xCop,xBcc,GetHtml(xTxt,xNom),xSub,'SM0->M0_NOMECOM',Nil,cSMTP,nSMTPPort,Nil,Nil,.f.,xRep,Nil,.f.) } , 'Processando' , "Enviando Email ..." )
				endif	
				if	!lRet
					FwMsgRun( Nil , { || lRet := xObj:EnviaMail(xEml,xCop,xBcc,GetHtml(xTxt,xNom),xSub,'SM0->M0_NOMECOM',Nil,cSMTP,nSMTPPort,Nil,Nil,.t.,xRep,Nil,.f.) } , 'Processando' , "Enviando Email ..." )
				endif
				if	!lRet
					FwMsgRun( Nil , { || lRet := xObj:EnviaMail(xEml,xCop,xBcc,GetHtml(xTxt,xNom),xSub,'SM0->M0_NOMECOM',Nil,cSMTP,nSMTPPort,Nil,Nil,Nil,xRep,Nil,.f.) } , 'Processando' , "Enviando Email ..." )
				endif			
			endif
		endif
	endif
	Return 
endif

nSaldo 	:= 	Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)
xSaldo 	:= 	nSaldo

if	nCol == nColCod .or. nCol == nColLin 

	nRecno 	:=	SE2->(Recno())	
	nIndex	:=	SE2->(IndexOrd())

	if	SE2->E2_ISS <> 0 .and. Empty(SE2->E2_PARCISS)
		xSaldo -= SE2->E2_ISS 
	endif

	if	SE2->E2_INSS <> 0 .and. Empty(SE2->E2_PARCINS)
		xSaldo -= SE2->E2_INSS 
	endif

	if	SE2->E2_IRRF <> 0 .and. Empty(SE2->E2_PARCIR)
		xSaldo -= SE2->E2_IRRF 
	endif

	if	SE2->E2_SEST <> 0 .and. Empty(SE2->E2_PARCSES)
		xSaldo -= SE2->E2_SEST 
	endif

	if	( SE2->E2_PIS <> 0 .or. SE2->E2_CSLL <> 0 .or. SE2->E2_COFINS <> 0 ) .and. Empty(SE2->E2_PARCPIS) .and. Empty(SE2->E2_PARCSLL) .and. Empty(SE2->E2_PARCCOF)
		xSaldo -= SE2->E2_PIS 
		xSaldo -= SE2->E2_CSLL 
		xSaldo -= SE2->E2_COFINS 
	else	
		if	SE2->E2_PIS <> 0 .and. Empty(SE2->E2_PARCPIS) 
			xSaldo -= SE2->E2_PIS 
		endif
		
		if	SE2->E2_CSLL <> 0 .and. Empty(SE2->E2_PARCSLL)
			xSaldo -= SE2->E2_CSLL 
		endif
		
		if	SE2->E2_COFINS <> 0 .and. Empty(SE2->E2_PARCCOF)
			xSaldo -= SE2->E2_COFINS 
		endif
	endif

	SE2->(dbsetorder(nIndex))
	SE2->(dbgoto(nRecno))  
endif

if !lUsrView .and. nCol == 1
	aArray[nLin,nPosFlg] :=	!aArray[nLin,nPosFlg]
elseif	( nCol == nColBco .and. Empty(aArray[nLin,nPosBco]) ) .or. ( nCol == nColAge .and. Empty(aArray[nLin,nPosAge]) ) .or. ( nCol == nColCta .and. Empty(aArray[nLin,nPosCon]) )
	if	lSA6Excl	
		cFilAnt := iif( lSE2Excl , SE2->E2_FILIAL , SE2->E2_FILORIG )
	endif
	aRet := RetBancos() 
	if	!Empty(aRet[1])   
		if	Upper(Alltrim(aArray[nLin,nTipoPg])) == "TRIBUTO" .and. !Empty(aArray[nLin,nBcoPag]) .and. !( aRet[1] $ aArray[nLin,nBcoPag] )
			MessageBox("Este tributo nใo pode ser pago pelo banco escolhido.","Aten็ใo",MB_ICONHAND) 
		else	
			lAtu						:=	.t.
			aArray[nLin,nPosBco]		:=	aRet[1]	
			aArray[nLin,nPosAge]		:=	aRet[2]
			aArray[nLin,nPosCon]		:=	aRet[3]    
			if	!Empty(aArray[nLin,nPosCdB]) .and. Upper(Alltrim(aArray[nLin,nTipoPg])) <> "TRIBUTO"
				aArray[nLin,nTipoPg]	:=	"Boleto" 
			endif    
			SE2->(dbgoto(aArray[nLin,nPosRec]))
			RecLock("SE2",.f.)
				SE2->E2_ZZBCO		:=	aRet[1]	
				SE2->E2_ZZAGE		:=	aRet[2]	
				SE2->E2_ZZCTA		:=	aRet[3]	
			MsUnlock("SE2")
			if	Upper(Alltrim(aArray[nLin,nTipoPg])) <> "TRIBUTO"
				RecLock("SE2",.f.)
					SE2->E2_ZZTPPG		:=	iif( !Empty(aArray[nLin,nPosCdB]) , "B" , "D" )
				MsUnlock("SE2")
			endif
		endif
	endif
	cFilAnt := xFilAnt
elseif	nCol == nColTit 
	SE2->(dbgoto(aArray[nLin,nPosRec]))		
	if	lSE2Excl	
		cFilAnt	:= SE2->E2_FILIAL
	elseif	lSA2Excl .or. lSA6Excl	
		cFilAnt	:= SE2->E2_FILORIG
	endif	
	SetFunName("FINC050")
	FinC050(2)
	SetFunName(xFunName)     
	cFilAnt := xFilAnt
elseif	nCol == nColFor .or. nCol == nColLoj
	SA2->(dbgoto(aArray[nLin,nRecSA2]))		
	SE2->(dbgoto(aArray[nLin,nPosRec]))		
	if	lSE2Excl	
		cFilAnt	:= SE2->E2_FILIAL
	elseif	lSA2Excl .or. lSA6Excl	
		cFilAnt	:= SE2->E2_FILORIG
	endif	
	SetFunName("FINC030")
	FinC030( Nil , 03 )
	SetFunName(xFunName)     
	cFilAnt := xFilAnt
elseif	nCol == nColImp 
	SE2->(dbgoto(aArray[nLin,nPosRec]))		

	if	Upper(Alltrim(aArray[nLin,SE2->(FieldPos("E2_ORIGEM"))])) == "XDIGDARF" 
		MessageBox("O pagamento s๓ pode ser alterado pela rotina de DARF.","Aten็ใo",MB_ICONHAND)
		Return 		
	elseif	Upper(Alltrim(aArray[nLin,SE2->(FieldPos("E2_ORIGEM"))])) == "XDIGGPS" 
		MessageBox("O pagamento s๓ pode ser alterado pela rotina de GPS.","Aten็ใo",MB_ICONHAND)
		Return
	endif

	if	aArray[nLin,nCodCrd] == "17" .and. Empty(aArray[nLin,nModImp])
		xTrb := 001     
		lDsv :=	.t.
	elseif	aArray[nLin,nCodCrd] == "16" .and. Empty(aArray[nLin,nModImp])
		xTrb := 002     
		lDsv :=	.t.
	elseif	aArray[nLin,nCodCrd] == "18" .and. Empty(aArray[nLin,nModImp])
		xTrb := 003     
		lDsv :=	.t.
	elseif	aArray[nLin,nCodCrd] == "21" .and. Empty(aArray[nLin,nModImp])
		xTrb := 004     
		lDsv :=	.t.
	elseif	aArray[nLin,nCodCrd] == "22" .and. Empty(aArray[nLin,nModImp])
		xTrb := 005     
		lDsv :=	.t.
	elseif	aArray[nLin,nCodCrd] == "25" .and. Empty(aArray[nLin,nModImp])
		xTrb := 006     
		lDsv :=	.t.
	elseif	aArray[nLin,nCodCrd] == "27" .and. Empty(aArray[nLin,nModImp])
		xTrb := 007
		lDsv :=	.t.
	elseif	aArray[nLin,nCodCrd] == "35" .and. Empty(aArray[nLin,nModImp])
		xTrb := 008
		lDsv :=	.t.
	else
		xTrb := xChkTrib(1)  
		lDsv :=	.f.
	endif
	
	// Gps
	if	xTrb == 1
		if	lSE2Excl
    		xTrb := U_fDigGPS(aArray[nLin,SE2->(FieldPos("E2_FILIAL"))],lDsv)
    	else
	    	xTrb := U_fDigGPS(aArray[nLin,SE2->(FieldPos("E2_FILORIG"))],lDsv)
		endif    
		if	xTrb[1] == 1
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD		:=	Space(02)
				SE2->E2_CODINS		:=	xTrb[2]		
				SE2->E2_ZZREFMA		:=	StrTran(xTrb[3],"/","")
				SE2->E2_ZZCNPJ		:=	xTrb[4]		
				SE2->E2_ZZVLPR		:=	xTrb[5]		
				SE2->E2_ZZVLMT		:=	xTrb[6]		
				SE2->E2_ZZVLJR		:=	xTrb[7]		
				SE2->E2_ZZNRCEI		:=	xTrb[8]		
				SE2->E2_CODBAR		:=	""
				if	SE2->(FieldPos("E2_CBARRA")) <> 0 
					SE2->E2_CBARRA	:=	""
				endif
			MsUnlock("SE2")
			aArray[nLin,nCodCrd] 							:=	"17" 
			aArray[nLin,nModCrd] 							:= 	"Gps"
			aArray[nLin,nTipoPg]							:= 	"Tributo" 
			aArray[nLin,nPosCdB] 							:=	""     
			aArray[nLin,nPosLnD] 							:=	""
			aArray[nLin,xModBor] 							:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 							:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 							:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZMODBD'))]		:=	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_CODINS'))]		:=	SE2->E2_CODINS		
			aArray[nLin,SE2->(FieldPos('E2_ZZREFMA'))]		:=	SE2->E2_ZZREFMA		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLPR'))]		:=	SE2->E2_ZZVLPR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLJR'))]		:=	SE2->E2_ZZVLJR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLMT'))]		:=	SE2->E2_ZZVLMT		
			aArray[nLin,SE2->(FieldPos("E2_ZZCNPJ"))]		:=	SE2->E2_ZZCNPJ		
			aArray[nLin,SE2->(FieldPos("E2_ZZNRCEI"))]		:=	SE2->E2_ZZNRCEI		
		elseif	xTrb[1] == 2 .and. ( MessageBox('Confirma a desvincula็ใo do imposto ?',"Aten็ใo",MB_YESNO) == 6 )
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD		:=	Space(02)
				SE2->E2_CODINS		:=	""
				SE2->E2_ZZREFMA		:=	""
				SE2->E2_CODBAR		:=	""
				if	SE2->(FieldPos("E2_CBARRA")) <> 0 
					SE2->E2_CBARRA	:=	""
				endif
				SE2->E2_ZZCNPJ		:=	""    
				SE2->E2_ZZNRCEI		:=	""
				SE2->E2_ZZVLPR		:=	0.00
				SE2->E2_ZZVLJR		:=	0.00
				SE2->E2_ZZVLMT		:=	0.00
			MsUnlock("SE2")
			aArray[nLin,nCodCrd] 							:=	""
			aArray[nLin,nModCrd] 							:= 	""
			aArray[nLin,nTipoPg]							:= 	""
			aArray[nLin,nPosCdB] 							:=	""     
			aArray[nLin,nPosLnD] 							:=	""
			aArray[nLin,xModBor] 							:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 							:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 							:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZMODBD'))]		:=	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_CODINS'))]		:=	SE2->E2_CODINS		
			aArray[nLin,SE2->(FieldPos('E2_ZZREFMA'))]		:=	SE2->E2_ZZREFMA		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLPR'))]		:=	SE2->E2_ZZVLPR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLJR'))]		:=	SE2->E2_ZZVLJR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLMT'))]		:=	SE2->E2_ZZVLMT		
			aArray[nLin,SE2->(FieldPos("E2_ZZCNPJ"))]		:=	SE2->E2_ZZCNPJ		
			aArray[nLin,SE2->(FieldPos("E2_ZZNRCEI"))]		:=	SE2->E2_ZZNRCEI		
		endif
	// Darf
	elseif	xTrb == 2     
		if	lSE2Excl
    		xTrb := U_fDigDarf(aArray[nLin,SE2->(FieldPos("E2_FILIAL"))],lDsv)
    	else
	    	xTrb := U_fDigDarf(aArray[nLin,SE2->(FieldPos("E2_FILORIG"))],lDsv)
		endif    
		if	xTrb[1] == 1      
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD		:=	Space(02)
				SE2->E2_ZZDTAP		:=	xTrb[02]		
				SE2->E2_ZZCNPJ		:=	xTrb[03]
				SE2->E2_CODRET		:=	xTrb[04]		
				SE2->E2_IDDARF		:=	xTrb[05]		
				SE2->E2_ZZDTVC		:=	xTrb[06]		
				SE2->E2_ZZVLPR		:=	xTrb[07]		
				SE2->E2_ZZVLMT		:=	xTrb[08]		
				SE2->E2_ZZVLJR		:=	xTrb[09]		
				SE2->E2_ACRESC		:=	xTrb[10]		
				SE2->E2_SDACRES		:=	xTrb[10]		
				SE2->E2_DECRESC		:=	xTrb[11]		
				SE2->E2_SDDECRE		:=	xTrb[11]		
				SE2->E2_CODBAR		:=	""
				if	SE2->(FieldPos("E2_CBARRA")) <> 0 
					SE2->E2_CBARRA	:=	""
				endif
			MsUnlock("SE2")

			nSaldo	:=	Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)

			aArray[nLin,nCodCrd] 							:=	"16" 
			aArray[nLin,nModCrd] 							:= 	"Darf"
			aArray[nLin,nTipoPg]							:= 	"Tributo" 
			aArray[nLin,nPosCdB] 							:=	""     
			aArray[nLin,nPosLnD] 							:=	""
			aArray[nLin,xModBor] 							:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 							:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 							:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZMODBD'))]		:=	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZDTAP'))]		:=	SE2->E2_ZZDTAP		
			aArray[nLin,SE2->(FieldPos('E2_ZZCNPJ'))]		:=	SE2->E2_ZZCNPJ		
			aArray[nLin,SE2->(FieldPos('E2_CODRET'))]		:=	SE2->E2_CODRET		
			aArray[nLin,SE2->(FieldPos('E2_IDDARF'))]		:=	SE2->E2_IDDARF		
			aArray[nLin,SE2->(FieldPos('E2_ZZDTVC'))]		:=	SE2->E2_ZZDTVC		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLPR'))]		:=	SE2->E2_ZZVLPR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLMT'))]		:=	SE2->E2_ZZVLMT		
			aArray[nLin,SE2->(FieldPos("E2_ZZVLJR"))]		:=	SE2->E2_ZZVLJR		
			aArray[nLin,SE2->(FieldPos("E2_ACRESC"))]		:=	SE2->E2_ACRESC		
			aArray[nLin,SE2->(FieldPos("E2_SDACRES"))]		:=	SE2->E2_SDACRES		
			aArray[nLin,SE2->(FieldPos("E2_DECRESC"))]		:=	SE2->E2_DECRESC		
			aArray[nLin,SE2->(FieldPos("E2_SDDECRE"))]		:=	SE2->E2_SDDECRE		
			aArray[nLin,SE2->(FieldPos("E2_SALDO"))] 		:=	nSaldo	
		elseif	xTrb[1] == 2 .and. ( MessageBox('Confirma a desvincula็ใo do imposto ?',"Aten็ใo",MB_YESNO) == 6 )
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD		:=	Space(02)
				SE2->E2_ZZDTAP		:=	CtoD("")
				SE2->E2_ZZCNPJ		:=	""
				SE2->E2_CODRET		:=	""
				SE2->E2_IDDARF		:=	""
				SE2->E2_ZZDTVC		:=	CtoD("")
				SE2->E2_ZZVLPR		:=	0.00
				SE2->E2_ZZVLMT		:=	0.00
				SE2->E2_ZZVLJR		:=	0.00
				SE2->E2_ACRESC		:=	0.00
				SE2->E2_SDACRES		:=	0.00
				SE2->E2_DECRESC		:=	0.00
				SE2->E2_SDDECRE		:=	0.00
				SE2->E2_CODBAR		:=	""
				if	SE2->(FieldPos("E2_CBARRA")) <> 0 
					SE2->E2_CBARRA	:=	""
				endif
			MsUnlock("SE2")

			nSaldo	:=	Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)

			aArray[nLin,nCodCrd] 							:=	"" 
			aArray[nLin,nModCrd] 							:= 	""
			aArray[nLin,nTipoPg]							:= 	"" 
			aArray[nLin,nPosCdB] 							:=	""     
			aArray[nLin,nPosLnD] 							:=	""
			aArray[nLin,xModBor] 							:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 							:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 							:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZMODBD'))]		:=	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZDTAP'))]		:=	SE2->E2_ZZDTAP		
			aArray[nLin,SE2->(FieldPos('E2_ZZCNPJ'))]		:=	SE2->E2_ZZCNPJ		
			aArray[nLin,SE2->(FieldPos('E2_CODRET'))]		:=	SE2->E2_CODRET		
			aArray[nLin,SE2->(FieldPos('E2_IDDARF'))]		:=	SE2->E2_IDDARF		
			aArray[nLin,SE2->(FieldPos('E2_ZZDTVC'))]		:=	SE2->E2_ZZDTVC		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLPR'))]		:=	SE2->E2_ZZVLPR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLMT'))]		:=	SE2->E2_ZZVLMT		
			aArray[nLin,SE2->(FieldPos("E2_ZZVLJR"))]		:=	SE2->E2_ZZVLJR		
			aArray[nLin,SE2->(FieldPos("E2_ACRESC"))]		:=	SE2->E2_ACRESC		
			aArray[nLin,SE2->(FieldPos("E2_SDACRES"))]		:=	SE2->E2_SDACRES		
			aArray[nLin,SE2->(FieldPos("E2_DECRESC"))]		:=	SE2->E2_DECRESC		
			aArray[nLin,SE2->(FieldPos("E2_SDDECRE"))]		:=	SE2->E2_SDDECRE		
			aArray[nLin,SE2->(FieldPos("E2_SALDO"))] 		:=	nSaldo	
		endif
	// Darf Simples
	elseif	xTrb == 3
		if	lSE2Excl
    		xTrb := U_fSimDarf(aArray[nLin,SE2->(FieldPos("E2_FILIAL"))],lDsv)
    	else
	    	xTrb := U_fSimDarf(aArray[nLin,SE2->(FieldPos("E2_FILORIG"))],lDsv)
		endif   
		if	xTrb[1] == 1      
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD		:=	Space(02)
				SE2->E2_ZZDTAP		:=	xTrb[2]		
				SE2->E2_ZZCNPJ		:=	xTrb[3]
				SE2->E2_CODRET		:=	xTrb[4]		
				if	SE2->(FieldPos("E2_ZZPRIS")) <> 0 
					SE2->E2_ZZPRIS	:=	xTrb[5]		
    			endif
				if	SE2->(FieldPos("E2_ZZPRCS")) <> 0 
					SE2->E2_ZZPRCS	:=	xTrb[6]		
    			endif
				SE2->E2_ZZVLPR		:=	xTrb[7]		
				SE2->E2_ZZVLMT		:=	xTrb[8]		
				SE2->E2_ZZVLJR		:=	xTrb[9]		
				SE2->E2_CODBAR		:=	""
				if	SE2->(FieldPos("E2_CBARRA")) <> 0 
					SE2->E2_CBARRA	:=	""
				endif
			MsUnlock("SE2")   
			aArray[nLin,nCodCrd] 							:=	"18" 
			aArray[nLin,nModCrd] 							:= 	"Darf Simples"
			aArray[nLin,nTipoPg]							:= 	"Tributo" 
			aArray[nLin,nPosCdB] 							:=	""     
			aArray[nLin,nPosLnD] 							:=	""
			aArray[nLin,xModBor] 							:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 							:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 							:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZMODBD'))]		:=	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZDTAP'))]		:=	SE2->E2_ZZDTAP		
			aArray[nLin,SE2->(FieldPos('E2_ZZCNPJ'))]		:=	SE2->E2_ZZCNPJ		
			aArray[nLin,SE2->(FieldPos('E2_CODRET'))]		:=	SE2->E2_CODRET		
			if	SE2->(FieldPos("E2_ZZPRIS")) <> 0 
				aArray[nLin,SE2->(FieldPos("E2_ZZPRIS"))]	:=	SE2->E2_ZZPRIS		
   			endif
			if	SE2->(FieldPos("E2_ZZPRCS")) <> 0 
				aArray[nLin,SE2->(FieldPos("E2_ZZPRCS"))]	:=	SE2->E2_ZZPRCS		
   			endif
			aArray[nLin,SE2->(FieldPos('E2_ZZVLPR'))]		:=	SE2->E2_ZZVLPR
			aArray[nLin,SE2->(FieldPos('E2_ZZVLMT'))]		:=	SE2->E2_ZZVLMT		
			aArray[nLin,SE2->(FieldPos("E2_ZZVLJR"))]		:=	SE2->E2_ZZVLJR		
		elseif	xTrb[1] == 2 .and. ( MessageBox('Confirma a desvincula็ใo do imposto ?',"Aten็ใo",MB_YESNO) == 6 )
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD		:=	Space(02)
				SE2->E2_ZZDTAP		:=	CtoD("")
				SE2->E2_ZZCNPJ		:=	""
				SE2->E2_CODRET		:=	""
				if	SE2->(FieldPos("E2_ZZPRIS")) <> 0 
					SE2->E2_ZZPRIS	:=	0.00
    			endif
				if	SE2->(FieldPos("E2_ZZPRCS")) <> 0 
					SE2->E2_ZZPRCS	:=	0.00
    			endif
				SE2->E2_ZZVLPR		:=	0.00
				SE2->E2_ZZVLMT		:=	0.00
				SE2->E2_ZZVLJR		:=	0.00   		
				SE2->E2_CODBAR		:=	""
				if	SE2->(FieldPos("E2_CBARRA")) <> 0 
					SE2->E2_CBARRA	:=	""
				endif
			MsUnlock("SE2")
			aArray[nLin,nCodCrd] 							:=	"" 
			aArray[nLin,nModCrd] 							:= 	""
			aArray[nLin,nTipoPg]							:= 	"" 
			aArray[nLin,nPosCdB] 							:=	""     
			aArray[nLin,nPosLnD] 							:=	""
			aArray[nLin,xModBor] 							:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 							:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 							:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZMODBD'))]		:=	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZDTAP'))]		:=	SE2->E2_ZZDTAP		
			aArray[nLin,SE2->(FieldPos('E2_ZZCNPJ'))]		:=	SE2->E2_ZZCNPJ		
			aArray[nLin,SE2->(FieldPos('E2_CODRET'))]		:=	SE2->E2_CODRET		
			if	SE2->(FieldPos("E2_ZZPRIS")) <> 0 
				aArray[nLin,SE2->(FieldPos("E2_ZZPRIS"))]	:=	SE2->E2_ZZPRIS		
   			endif
			if	SE2->(FieldPos("E2_ZZPRCS")) <> 0 
				aArray[nLin,SE2->(FieldPos("E2_ZZPRCS"))]	:=	SE2->E2_ZZPRCS		
   			endif
			aArray[nLin,SE2->(FieldPos('E2_ZZVLPR'))]		:=	SE2->E2_ZZVLPR
			aArray[nLin,SE2->(FieldPos('E2_ZZVLMT'))]		:=	SE2->E2_ZZVLMT		
			aArray[nLin,SE2->(FieldPos("E2_ZZVLJR"))]		:=	SE2->E2_ZZVLJR		
		endif
	// DARJ
	elseif	xTrb == 4
		xTrb := xDARJ(lDsv)
		if	xTrb[1] == 1      
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD		:=	Space(02)     
				SE2->E2_ZZCGARE		:=	xTrb[02]		
				SE2->E2_ZZINEST		:=	xTrb[03]
				SE2->E2_ZZCNPJ		:=	xTrb[04]		
				SE2->E2_ZZDORRJ		:=	xTrb[05]		
				SE2->E2_ZZREFMA		:=	xTrb[06]		
				SE2->E2_ZZVLPR		:=	xTrb[07]		
				SE2->E2_ZZVLJR		:=	xTrb[08]		
				SE2->E2_ZZVLMT		:=	xTrb[09]		
				SE2->E2_ZZVLAF		:=	xTrb[10]		
				SE2->E2_CODBAR		:=	""
				if	SE2->(FieldPos("E2_CBARRA")) <> 0 
					SE2->E2_CBARRA	:=	""
				endif
			MsUnlock("SE2")     
			aArray[nLin,nCodCrd] 							:=	"21" 
			aArray[nLin,nModCrd] 							:= 	"DARJ"
			aArray[nLin,nTipoPg]							:= 	"Tributo" 
			aArray[nLin,nPosCdB] 							:=	""     
			aArray[nLin,nPosLnD] 							:=	""
			aArray[nLin,xModBor] 							:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 							:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 							:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZMODBD'))]		:=	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZCGARE'))]		:=	SE2->E2_ZZCGARE		
			aArray[nLin,SE2->(FieldPos('E2_ZZINEST'))]		:=	SE2->E2_ZZINEST		
			aArray[nLin,SE2->(FieldPos('E2_ZZCNPJ'))]		:=	SE2->E2_ZZCNPJ		
			aArray[nLin,SE2->(FieldPos('E2_ZZDORRJ'))]		:=	SE2->E2_ZZDORRJ		
			aArray[nLin,SE2->(FieldPos('E2_ZZREFMA'))]		:=	SE2->E2_ZZREFMA		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLPR'))]		:=	SE2->E2_ZZVLPR		
			aArray[nLin,SE2->(FieldPos("E2_ZZVLJR"))]		:=	SE2->E2_ZZVLJR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLMT'))]		:=	SE2->E2_ZZVLMT		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLAF'))]		:=	SE2->E2_ZZVLAF		
		elseif	xTrb[1] == 2 .and. ( MessageBox('Confirma a desvincula็ใo do imposto ?',"Aten็ใo",MB_YESNO) == 6 )
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD		:=	Space(02)
				SE2->E2_ZZCGARE		:=	""
				SE2->E2_ZZINEST		:=	""
				SE2->E2_ZZCNPJ		:=	""
				SE2->E2_ZZDORRJ		:=	""
				SE2->E2_ZZREFMA		:=	""
				SE2->E2_ZZVLPR		:=	0.00
				SE2->E2_ZZVLJR		:=	0.00
				SE2->E2_ZZVLMT		:=	0.00
				SE2->E2_ZZVLAF		:=	0.00
				SE2->E2_CODBAR		:=	""
				if	SE2->(FieldPos("E2_CBARRA")) <> 0 
					SE2->E2_CBARRA	:=	""
				endif
			MsUnlock("SE2")          
			aArray[nLin,nCodCrd] 							:=	"" 
			aArray[nLin,nModCrd] 							:= 	""
			aArray[nLin,nTipoPg]							:= 	"" 
			aArray[nLin,nPosCdB] 							:=	""     
			aArray[nLin,nPosLnD] 							:=	""
			aArray[nLin,xModBor] 							:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 							:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 							:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZMODBD'))]		:=	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZCGARE'))]		:=	SE2->E2_ZZCGARE		
			aArray[nLin,SE2->(FieldPos('E2_ZZINEST'))]		:=	SE2->E2_ZZINEST		
			aArray[nLin,SE2->(FieldPos('E2_ZZCNPJ'))]		:=	SE2->E2_ZZCNPJ		
			aArray[nLin,SE2->(FieldPos('E2_ZZDORRJ'))]		:=	SE2->E2_ZZDORRJ		
			aArray[nLin,SE2->(FieldPos('E2_ZZREFMA'))]		:=	SE2->E2_ZZREFMA		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLPR'))]		:=	SE2->E2_ZZVLPR		
			aArray[nLin,SE2->(FieldPos("E2_ZZVLJR"))]		:=	SE2->E2_ZZVLJR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLMT'))]		:=	SE2->E2_ZZVLMT		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLAF'))]		:=	SE2->E2_ZZVLAF		
		endif
	// Gare - SP
	elseif	xTrb == 5      
		xTrb := xGareSP(lDsv)
		if	xTrb[1] == 1      
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD		:=	Space(02)
				SE2->E2_ZZCGARE		:=	xTrb[02]		
				SE2->E2_ZZINEST		:=	xTrb[03]
				SE2->E2_ZZCNPJ		:=	xTrb[04]		
				SE2->E2_ZZDVATV		:=	xTrb[05]		
				SE2->E2_ZZREFMA		:=	xTrb[06]		
				SE2->E2_ZZAIMPR		:=	xTrb[07]		
				SE2->E2_ZZVLPR		:=	xTrb[08]		
				SE2->E2_ZZVLJR		:=	xTrb[09]		
				SE2->E2_ZZVLMT		:=	xTrb[10]		
				SE2->E2_ZZVLAF		:=	xTrb[11]		
				SE2->E2_ZZVLHA		:=	xTrb[12]		
				SE2->E2_CODBAR		:=	""
				if	SE2->(FieldPos("E2_CBARRA")) <> 0 
					SE2->E2_CBARRA	:=	""
				endif
			MsUnlock("SE2")     
			aArray[nLin,nCodCrd] 							:=	"22" 
			aArray[nLin,nModCrd] 							:= 	"Gare - SP"
			aArray[nLin,nTipoPg]							:= 	"Tributo" 
			aArray[nLin,nPosCdB] 							:=	""     
			aArray[nLin,nPosLnD] 							:=	""
			aArray[nLin,xModBor] 							:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 							:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 							:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZMODBD'))]		:=	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZCGARE'))]		:=	SE2->E2_ZZCGARE		
			aArray[nLin,SE2->(FieldPos('E2_ZZINEST'))]		:=	SE2->E2_ZZINEST		
			aArray[nLin,SE2->(FieldPos('E2_ZZCNPJ'))]		:=	SE2->E2_ZZCNPJ		
			aArray[nLin,SE2->(FieldPos('E2_ZZDVATV'))]		:=	SE2->E2_ZZDVATV		
			aArray[nLin,SE2->(FieldPos('E2_ZZREFMA'))]		:=	SE2->E2_ZZREFMA		
			aArray[nLin,SE2->(FieldPos('E2_ZZAIMPR'))]		:=	SE2->E2_ZZAIMPR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLPR'))]		:=	SE2->E2_ZZVLPR		
			aArray[nLin,SE2->(FieldPos("E2_ZZVLJR"))]		:=	SE2->E2_ZZVLJR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLMT'))]		:=	SE2->E2_ZZVLMT		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLAF'))]		:=	SE2->E2_ZZVLAF		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLHA'))]		:=	SE2->E2_ZZVLHA		
		elseif	xTrb[1] == 2 .and. ( MessageBox('Confirma a desvincula็ใo do imposto ?',"Aten็ใo",MB_YESNO) == 6 )
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD		:=	Space(02)
				SE2->E2_ZZCGARE		:=	""
				SE2->E2_ZZINEST		:=	""
				SE2->E2_ZZCNPJ		:=	""
				SE2->E2_ZZDVATV		:=	""
				SE2->E2_ZZREFMA		:=	""
				SE2->E2_ZZAIMPR		:=	""
				SE2->E2_ZZVLPR		:=	0.00
				SE2->E2_ZZVLJR		:=	0.00
				SE2->E2_ZZVLMT		:=	0.00
				SE2->E2_ZZVLAF		:=	0.00
				SE2->E2_ZZVLHA		:=	0.00
				SE2->E2_CODBAR		:=	""
				if	SE2->(FieldPos("E2_CBARRA")) <> 0 
					SE2->E2_CBARRA	:=	""
				endif
			MsUnlock("SE2")          
			aArray[nLin,nCodCrd] 							:=	"" 
			aArray[nLin,nModCrd] 							:= 	""
			aArray[nLin,nTipoPg]							:= 	"" 
			aArray[nLin,nPosCdB] 							:=	""     
			aArray[nLin,nPosLnD] 							:=	""
			aArray[nLin,xModBor] 							:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 							:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 							:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZMODBD'))]		:=	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZCGARE'))]		:=	SE2->E2_ZZCGARE		
			aArray[nLin,SE2->(FieldPos('E2_ZZINEST'))]		:=	SE2->E2_ZZINEST		
			aArray[nLin,SE2->(FieldPos('E2_ZZCNPJ'))]		:=	SE2->E2_ZZCNPJ		
			aArray[nLin,SE2->(FieldPos('E2_ZZDVATV'))]		:=	SE2->E2_ZZDVATV		
			aArray[nLin,SE2->(FieldPos('E2_ZZREFMA'))]		:=	SE2->E2_ZZREFMA		
			aArray[nLin,SE2->(FieldPos('E2_ZZAIMPR'))]		:=	SE2->E2_ZZAIMPR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLPR'))]		:=	SE2->E2_ZZVLPR		
			aArray[nLin,SE2->(FieldPos("E2_ZZVLJR"))]		:=	SE2->E2_ZZVLJR		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLMT'))]		:=	SE2->E2_ZZVLMT		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLAF'))]		:=	SE2->E2_ZZVLAF		
			aArray[nLin,SE2->(FieldPos('E2_ZZVLHA'))]		:=	SE2->E2_ZZVLHA		
		endif
	// Ipva (SP/MG/RJ)
	elseif	xTrb == 6
		xTrb := xIpvaDpVat(2,lDsv)
		if	xTrb[1] == 1
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD	:=	Space(02)
				SE2->E2_ZZRENAV	:=	xTrb[2]		
				SE2->E2_ZZPLACA	:=	xTrb[3]		
				SE2->E2_ZZESTVC	:=	xTrb[4]		
				SE2->E2_ZZCODMN	:=	xTrb[5]		
				SE2->E2_ANOBASE	:=	xTrb[6]		
				SE2->E2_ZZOPPGT	:=	xTrb[7]		
			MsUnlock("SE2")
			aArray[nLin,nCodCrd] 						:=	"25" 
			aArray[nLin,nModCrd] 						:= 	"Ipva (SP/MG/RJ)"
			aArray[nLin,nTipoPg]						:= 	"Tributo" 
			aArray[nLin,nPosCdB] 						:=	""     
			aArray[nLin,nPosLnD] 						:=	""
			aArray[nLin,xModBor] 						:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 						:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 						:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZRENAV'))]	:=	xTrb[2]		
			aArray[nLin,SE2->(FieldPos('E2_ZZPLACA'))]	:=	xTrb[3]		
			aArray[nLin,SE2->(FieldPos('E2_ZZESTVC'))]	:=	xTrb[4]		
			aArray[nLin,SE2->(FieldPos('E2_ZZCODMN'))]	:=	xTrb[5]		
			aArray[nLin,SE2->(FieldPos('E2_ANOBASE'))]	:=	xTrb[6]		
			aArray[nLin,SE2->(FieldPos('E2_ZZOPPGT'))]	:=	xTrb[7]		
		elseif	xTrb[1] == 2 .and. ( MessageBox('Confirma a desvincula็ใo do imposto ?',"Aten็ใo",MB_YESNO) == 6 )
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD	:=	Space(02)
				SE2->E2_ZZRENAV	:=	""
				SE2->E2_ZZPLACA	:=	""
				SE2->E2_ZZESTVC	:=	""
				SE2->E2_ZZCODMN	:=	""
				SE2->E2_ANOBASE	:=	""
				SE2->E2_ZZOPPGT	:=	""
			MsUnlock("SE2")
			aArray[nLin,nPosFlg] 						:=	.f.
			aArray[nLin,nCodCrd] 						:=	"" 
			aArray[nLin,nModCrd] 						:= 	""
			aArray[nLin,nTipoPg]						:= 	""
			aArray[nLin,nPosCdB] 						:=	""     
			aArray[nLin,nPosLnD] 						:=	""
			aArray[nLin,xModBor] 						:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 						:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 						:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZRENAV'))]	:=	""
			aArray[nLin,SE2->(FieldPos('E2_ZZPLACA'))]	:=	""
			aArray[nLin,SE2->(FieldPos('E2_ZZESTVC'))]	:=	""
			aArray[nLin,SE2->(FieldPos('E2_ZZCODMN'))]	:=	""
			aArray[nLin,SE2->(FieldPos('E2_ANOBASE'))]	:=	""
			aArray[nLin,SE2->(FieldPos('E2_ZZOPPGT'))]	:=	""
		endif
	// Dpvat (SP/MG/RJ)
	elseif	xTrb == 7
		xTrb := xIpvaDpVat(1,lDsv)
		if	xTrb[1] == 1
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD	:=	Space(02)
				SE2->E2_ZZRENAV	:=	xTrb[2]		
				SE2->E2_ZZPLACA	:=	xTrb[3]		
				SE2->E2_ZZESTVC	:=	xTrb[4]		
				SE2->E2_ZZCODMN	:=	xTrb[5]		
				SE2->E2_ANOBASE	:=	xTrb[6]		
				SE2->E2_ZZOPPGT	:=	xTrb[7]		
			MsUnlock("SE2")
			aArray[nLin,nCodCrd] 						:=	"27" 
			aArray[nLin,nModCrd] 						:= 	"Dpvat (SP/MG/RJ)"
			aArray[nLin,nTipoPg]						:= 	"Tributo" 
			aArray[nLin,nPosCdB] 						:=	""     
			aArray[nLin,nPosLnD] 						:=	""
			aArray[nLin,xModBor] 						:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 						:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 						:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZRENAV'))]	:=	xTrb[2]		
			aArray[nLin,SE2->(FieldPos('E2_ZZPLACA'))]	:=	xTrb[3]		
			aArray[nLin,SE2->(FieldPos('E2_ZZESTVC'))]	:=	xTrb[4]		
			aArray[nLin,SE2->(FieldPos('E2_ZZCODMN'))]	:=	xTrb[5]		
			aArray[nLin,SE2->(FieldPos('E2_ANOBASE'))]	:=	xTrb[6]		
			aArray[nLin,SE2->(FieldPos('E2_ZZOPPGT'))]	:=	xTrb[7]		
		elseif	xTrb[1] == 2 .and. ( MessageBox('Confirma a desvincula็ใo do imposto ?',"Aten็ใo",MB_YESNO) == 6 )
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD	:=	Space(02)
				SE2->E2_ZZRENAV	:=	""
				SE2->E2_ZZPLACA	:=	""
				SE2->E2_ZZESTVC	:=	""
				SE2->E2_ZZCODMN	:=	""
				SE2->E2_ANOBASE	:=	""
				SE2->E2_ZZOPPGT	:=	""
			MsUnlock("SE2")
			aArray[nLin,nPosFlg] 						:=	.f.
			aArray[nLin,nCodCrd] 						:=	"" 
			aArray[nLin,nModCrd] 						:= 	""
			aArray[nLin,nTipoPg]						:= 	""
			aArray[nLin,nPosCdB] 						:=	""     
			aArray[nLin,nPosLnD] 						:=	""
			aArray[nLin,xModBor] 						:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
			aArray[nLin,nModBor] 						:= 	Empty(SE2->E2_ZZMODBD)	
			aArray[nLin,nModImp] 						:= 	SE2->E2_ZZMODBD		
			aArray[nLin,SE2->(FieldPos('E2_ZZRENAV'))]	:=	""
			aArray[nLin,SE2->(FieldPos('E2_ZZPLACA'))]	:=	""
			aArray[nLin,SE2->(FieldPos('E2_ZZESTVC'))]	:=	""
			aArray[nLin,SE2->(FieldPos('E2_ZZCODMN'))]	:=	""
			aArray[nLin,SE2->(FieldPos('E2_ANOBASE'))]	:=	""
			aArray[nLin,SE2->(FieldPos('E2_ZZOPPGT'))]	:=	""
		endif
	// Fgts
	elseif	xTrb == 8         
		MessageBox('Nใo ้ possํvel pagar FGTS sem c๓digo de barras por CNAB',"Aten็ใo",MB_ICONHAND) 				
		/*
		if	Upper(Alltrim(aArray[nLin,nPosBco])) == "341"
			MessageBox('Nใo ้ possํvel pagar FGTS sem c๓digo de barras por CNAB pelo Ita๚',"Aten็ใo",MB_ICONHAND) 				
		else
			RecLock("SE2",.f.)
				SE2->E2_ZZMODBD	:=	"35"
			MsUnlock("SE2")
			aArray[nLin,nCodCrd] :=	"35" 
			aArray[nLin,nModCrd] := "Fgts"  
		endif
		*/
	endif
elseif	nCol == nColTip 
	SE2->(dbgoto(aArray[nLin,nPosRec]))		
	if	Upper(Alltrim(aArray[nLin,nTipoPg])) == "TRIBUTO" 
		MessageBox('O tipo TRIBUTO nใo pode ser alterado',"Aten็ใo",MB_ICONHAND) 		
	else	
		Define MsDialog oDlgAlt From  000,000 To 107,292 Title "Informe" Pixel Style 128
		@ 005,007 To 035,140 Of oDlgAlt  Pixel	
		@ 011,010 Radio oRadio Var nRadio Items "Boleto" , "Deposito" 3D Size 100,010 Of oDlgAlt Pixel
		Define sButton From 038,115 Type 1 Enable Of oDlgAlt Action ( nOpc := 1 , oDlgAlt:End() )
		Activate MsDialog oDlgAlt Centered
	
		if	nOpc == 1
			lAtu					:=	.t.
			aArray[nLin,nAtuTpP] 	:= 	.t.
			aArray[nLin,nTipoPg] 	:= 	iif( nRadio == 1 , "Boleto" , iif( nRadio == 2 , "Deposito" , "Tributo" ) )    
			RecLock("SE2",.f.)
				SE2->E2_ZZTPPG		:=	iif( nRadio == 1 , "B" , iif( nRadio == 2 , "D" , "T" ) )
			MsUnlock("SE2")
		endif	
	endif	
elseif	nCol == nColMod 
	if	Upper(Alltrim(aArray[nLin,nModCrd])) == "TRANSFERENCIA" 
		if	lPix .and. !Empty(aArray[nLin,nChvPix]) .and. Alltrim(aArray[nLin,nPosBco]) == Alltrim(aArray[nLin,nBcoDep])
			if	( MessageBox("Alterar para PIX ?","Aten็ใo",MB_YESNO) == 6 )
				aArray[nLin,nModCrd] :=	"PIX"
				aArray[nLin,nCodCrd] :=	"45"
			endif	
		endif	
	elseif	Upper(Alltrim(aArray[nLin,nModCrd])) == "DOC" 
		if	lPix .and. !Empty(aArray[nLin,nChvPix])
			Define MsDialog oDlgAlt From  000,000 To 107,292 Title "Informe" Pixel Style 128
			@ 005,007 To 035,140 Of oDlgAlt  Pixel	
			@ 011,010 Radio oRadio Var nRadio Items "TED" , "PIX" 3D Size 100,010 Of oDlgAlt Pixel
			Define sButton From 038,115 Type 1 Enable Of oDlgAlt Action ( nOpc := 1 , oDlgAlt:End() )
			Activate MsDialog oDlgAlt Centered
			if	nOpc == 1
				if	nRadio == 1 .and. Max(0,nSaldo) < nMinTed
					MessageBox("Saldo menor que o permitido para envio de TED.","Aten็ใo",MB_ICONHAND) 		
				elseif	nRadio == 1 
					if	( MessageBox("Alterar para TED ?","Aten็ใo",MB_YESNO) == 6 )
						aArray[nLin,nModCrd] := "TED"
						aArray[nLin,nCodCrd] := "41"
					endif	
				elseif	nRadio == 2
					if	( MessageBox("Alterar para PIX ?","Aten็ใo",MB_YESNO) == 6 )
						aArray[nLin,nModCrd] := "PIX"
						aArray[nLin,nCodCrd] := "45"
					endif	
				endif	
			endif	
		else
			if	( MessageBox("Alterar para TED ?","Aten็ใo",MB_YESNO) == 6 )
				aArray[nLin,nModCrd] := "TED"
				aArray[nLin,nCodCrd] := "41"
			endif	
		endif	
	elseif	Upper(Alltrim(aArray[nLin,nModCrd])) == "TED"
		if	lPix .and. !Empty(aArray[nLin,nChvPix])
			Define MsDialog oDlgAlt From  000,000 To 107,292 Title "Informe" Pixel Style 128
			@ 005,007 To 035,140 Of oDlgAlt  Pixel	
			@ 011,010 Radio oRadio Var nRadio Items "DOC" , "PIX" 3D Size 100,010 Of oDlgAlt Pixel
			Define sButton From 038,115 Type 1 Enable Of oDlgAlt Action ( nOpc := 1 , oDlgAlt:End() )
			Activate MsDialog oDlgAlt Centered
			if	nOpc == 1
				if	nRadio == 1 .and. Max(0,nSaldo) > nMaxDoc
					MessageBox("Saldo maior que o permitido para envio de DOC.","Aten็ใo",MB_ICONHAND) 					
				elseif	nRadio == 1 
					if	( MessageBox("Alterar para DOC ?","Aten็ใo",MB_YESNO) == 6 )
						aArray[nLin,nModCrd] := "DOC"
						aArray[nLin,nCodCrd] := "03"
					endif	
				elseif	nRadio == 2
					if	( MessageBox("Alterar para PIX ?","Aten็ใo",MB_YESNO) == 6 )
						aArray[nLin,nModCrd] :=	"PIX"
						aArray[nLin,nCodCrd] :=	"45"
					endif	
				endif	
			endif	
		else
			if	( MessageBox("Alterar para DOC ?","Aten็ใo",MB_YESNO) == 6 )
				aArray[nLin,nModCrd] := "DOC"
				aArray[nLin,nCodCrd] := "03"
			endif	
		endif	
	elseif	Upper(Alltrim(aArray[nLin,nModCrd])) == "PIX"
		if	lPix .and. !Empty(aArray[nLin,nChvPix]) .and. Alltrim(aArray[nLin,nPosBco]) == Alltrim(aArray[nLin,nBcoDep])
			if	( MessageBox("Alterar para TRANSFERENCIA ?","Aten็ใo",MB_YESNO) == 6 )
				aArray[nLin,nModCrd] := "Transferencia"
				aArray[nLin,nCodCrd] := "01"
			endif	
		elseif	lPix .and. !Empty(aArray[nLin,nChvPix])
			Define MsDialog oDlgAlt From  000,000 To 107,292 Title "Informe" Pixel Style 128
			@ 005,007 To 035,140 Of oDlgAlt  Pixel	
			@ 011,010 Radio oRadio Var nRadio Items "DOC" , "TED" 3D Size 100,010 Of oDlgAlt Pixel
			Define sButton From 038,115 Type 1 Enable Of oDlgAlt Action ( nOpc := 1 , oDlgAlt:End() )
			Activate MsDialog oDlgAlt Centered
			if	nOpc == 1
				if	nRadio == 1 .and. Max(0,nSaldo) > nMaxDoc
					MessageBox("Saldo maior que o permitido para envio de DOC.","Aten็ใo",MB_ICONHAND) 					
				elseif	nRadio == 1 
					if	( MessageBox("Alterar para DOC ?","Aten็ใo",MB_YESNO) == 6 )
						aArray[nLin,nModCrd] := "DOC"
						aArray[nLin,nCodCrd] := "03"
					endif	
				elseif	nRadio == 2 .and. Max(0,nSaldo) < nMinTed
					MessageBox("Saldo menor que o permitido para envio de TED.","Aten็ใo",MB_ICONHAND) 		
				elseif	nRadio == 2 
					if	( MessageBox("Alterar para TED ?","Aten็ใo",MB_YESNO) == 6 )
						aArray[nLin,nModCrd] := "TED"
						aArray[nLin,nCodCrd] := "41"
					endif	
				endif	
			endif	
		endif	
	endif
elseif	nCol == nColLin  
	if	.t.
		Return 
	else
		fLinDigt(oDlg,oGrid,aArray)	
	endif
elseif	nCol == nColCod 

	if	Upper(Alltrim(aArray[nLin,SE2->(FieldPos("E2_ORIGEM"))])) == "XDIGDARF" 
		MessageBox("O pagamento s๓ pode ser alterado pela rotina de DARF.","Aten็ใo",MB_ICONHAND)
		lGoF := .f.			
	elseif	Upper(Alltrim(aArray[nLin,SE2->(FieldPos("E2_ORIGEM"))])) == "XDIGGPS" 
		MessageBox("O pagamento s๓ pode ser alterado pela rotina de GPS.","Aten็ใo",MB_ICONHAND)
		lGoF := .f.			
	elseif	Upper(Alltrim(aArray[nLin,nTipoPg])) == "TRIBUTO" .and. !Empty(aArray[nLin,nPosCdB]) 
		lGoF := .t.		
	elseif	Upper(Alltrim(aArray[nLin,nTipoPg])) == "TRIBUTO" .and. !Empty(aArray[nLin,nPosLnD]) 
		lGoF := .t.		
	elseif	Upper(Alltrim(aArray[nLin,nTipoPg])) == "TRIBUTO" .and. !Empty(aArray[nLin,nPosCdB]) .and. Empty(aArray[nLin,nPosLnD]) 
		lGoF := .t.		
	elseif	Upper(Alltrim(aArray[nLin,nTipoPg])) <>	"BOLETO" 
		MessageBox("O tipo de pagamento desse titulo nใo ้ BOLETO.","Aten็ใo",MB_ICONHAND)
		lGoF := .f.		
	endif

	if	lGoF         
		xCod := fCodBarr(@oDlg,@oGrid,@aArray)
		if	ValType(xCod) <> "A"
			xCod := {"","",""}
		endif
   		if !Empty(xCod[3])	
			lColLin	:=	.t.
			cCod	:=	Alltrim(xCod[3])		
   		elseif !Empty(xCod[2])	
			lColLin	:=	.t.
			cCod	:=	Alltrim(xCod[2])		
		else
			lColCod	:=	.t.
			cCod	:=	AllTrim(xCod[1])		
		endif			
	endif			

	if	lGoF 

		if	lColCod 
	
			if	Empty(cCod) 
				nVal	:=	0
			elseif	Substr(cCod,01,01) == "8" 
				nVal	:=	( Val(Substr(cCod,05,11)) / 100 )
			elseif	Substr(cCod,01,01) <> "8"     
				nVal	:=	iif( Substr(cCod,10,10) == Replicate("0",10) , Min(nSaldo,xSaldo) , ( Val(Substr(cCod,10,10)) / 100 ) )
			endif
	
			if	Len(cCod) == 44 .and. Substr(cCod,01,01) <> "8" .and. Substr(cCod,06,04) <> "0000" .and. Date() > DataValida( Val(Substr(cCod,06,04)) + StoD("19971007") ) 
				lGoF := ( MessageBox("Boleto vencido. Confirma ?","Aten็ใo",MB_YESNO) == 6 )
			endif
			
			if	lGoF
				if	Empty(cCod) 
					if	Empty(aArray[nLin,nPosCdB]) .or. ( MessageBox("Sobrepor o c๓digo existente ?","Aten็ใo",MB_YESNO) == 6 )
						lAtu					:=	.t.
						aArray[nLin,nPosCdB] 	:=	""     
						aArray[nLin,nPosLnD] 	:=	""
						SE2->(dbgoto(aArray[nLin,nPosRec]))
						if	Substr(SE2->E2_CODBAR,01,01) == "8" 
							RecLock("SE2",.f.)
								SE2->E2_ZZMODBD	:=	Space(02)
							MsUnlock("SE2")
						endif
						if	Substr(SE2->E2_CODBAR,01,01) == "8" 
							aArray[nLin,nTipoPg] :=	"Boleto"   
						endif
						aArray[nLin,xModBor] 	:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
						aArray[nLin,nModBor] 	:= 	Empty(SE2->E2_ZZMODBD)	
						aArray[nLin,nModImp] 	:= 	SE2->E2_ZZMODBD		
						RecLock("SE2",.f.)
							SE2->E2_CODBAR		:=	""
							if	SE2->(FieldPos("E2_CBARRA")) <> 0 
								SE2->E2_CBARRA	:=	""
							endif
						MsUnlock("SE2")
						if	SE2->(FieldPos("E2_ZZLINDG")) <> 0 
							RecLock("SE2",.f.)
								SE2->E2_ZZLINDG  :=	""
							MsUnlock("SE2")
						endif
						if	SE2->(FieldPos("E2_LINDIGT")) <> 0 
							RecLock("SE2",.f.)
								SE2->E2_LINDIGT  :=	""
							MsUnlock("SE2")
						endif
						if	SE2->(FieldPos("E2_LINDIG")) <> 0 
							RecLock("SE2",.f.)
								SE2->E2_LINDIG 	:=	""
							MsUnlock("SE2")
						endif
					endif
				elseif	Len(cCod) <> 44 
					MessageBox("C๓digo de barras informado nใo ้ vแlido","Aten็ใo",MB_ICONHAND)
				elseif	nVal <> nSaldo .and. nVal <> xSaldo
					MessageBox("O valor do boleto nใo confere com o valor a pagar","Aten็ใo",MB_ICONHAND)
				elseif	VldCodBar(cCod)
					For w := 1 to Len(aArray)
						if	w <> nLin
							if	cCod == aArray[w,nPosCdB] 	
							 	lRep := .t.
							endif			
						endif
		            Next w 
					if	lRep
						if	Substr(cCod,01,01) == "8"
							if	MessageBox("Codigo de Barras jแ digitado. Confirma ?","Aten็ใo",MB_YESNO) == 6
								lRep := .f. 
								lMsg :=	.t.
							else 
								lRep := .t. 
								lMsg :=	.f.
							endif 
						else 
							lRep := .t. 
							lMsg :=	.t.
						endif 
					else 
						lRep := .f. 
						lMsg :=	.t.
					endif 
					if	lRep
						if	lMsg 		
							MessageBox("Codigo de Barras jแ digitado.","Aten็ใo",MB_ICONHAND)
						endif 
					else
						if	Empty(aArray[nLin,nPosCdB]) .or. ( MessageBox("Sobrepor o c๓digo existente ?","Aten็ใo",MB_YESNO) == 6 )
							lAtu					:=	.t.
							aArray[nLin,nPosCdB] 	:=	cCod
							aArray[nLin,nPosLnD] 	:=	""   
							SE2->(dbgoto(aArray[nLin,nPosRec]))
							RecLock("SE2",.f.)
								SE2->E2_CODBAR		:=	cCod
								if	SE2->(FieldPos("E2_CBARRA")) <> 0 
									SE2->E2_CBARRA	:=	cCod
								endif
							MsUnlock("SE2")
							if	SE2->(FieldPos("E2_ZZLINDG")) <> 0 
								RecLock("SE2",.f.)
									SE2->E2_ZZLINDG	:=	""
								MsUnlock("SE2")
							endif   
							if	SE2->(FieldPos("E2_LINDIGT")) <> 0 
								RecLock("SE2",.f.)
									SE2->E2_LINDIGT	:=	""
								MsUnlock("SE2")
							endif   
							if	SE2->(FieldPos("E2_LINDIG")) <> 0 
								RecLock("SE2",.f.)
									SE2->E2_LINDIG	:=	""
								MsUnlock("SE2")
							endif   
							if	Substr(cCod,01,01) <> "8" 
								RecLock("SE2",.f.)
									SE2->E2_ZZMODBD	:=	Space(02)
								MsUnlock("SE2")
								aArray[nLin,nTipoPg] :=	"Boleto"   
							elseif	Substr(cCod,01,01) == "8" .and. Substr(cCod,02,01) $ "1"
								RecLock("SE2",.f.)
									SE2->E2_ZZMODBD	:=	"19"
								MsUnlock("SE2")
								aArray[nLin,nTipoPg] :=	"Tributo"   
								aArray[nLin,nCodCrd] :=	"19" 
								aArray[nLin,nModCrd] := "Trib. Municipais"
							elseif	Substr(cCod,01,01) == "8" .and. Substr(cCod,02,01) $ "2/3/4"
								RecLock("SE2",.f.)
									SE2->E2_ZZMODBD	:=	Space(02)
								MsUnlock("SE2")
								aArray[nLin,nTipoPg] :=	"Boleto"   
								aArray[nLin,nCodCrd] :=	"13" 
								aArray[nLin,nModCrd] := "Concessionaria"
							elseif	Substr(cCod,01,01) == "8" .and. Substr(cCod,02,01) $ "5"
	
								/*
								ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
								ณ Identificacao dos Tributos  ณ
								ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
						
								13 - Pagamento a Concessionarias
								16 - Pagamento de Tributos DARF
								17 - Pagamento de Tributos GPS
								18 - Pagamento de Tributos DARF SIMPLES   
								19 - Pagamento de IPTU / Tributos Municipais
								21 - Pagamento de Tributos DARJ
								22 - Pagamento de Tributos GARE ICMS SP
								25 - Pagamento de Tributos IPVA (SP e MG)
								27 - Pagamento de Tributos DPVAT     
								28 - GR-PR com Codigo de Barras
								29 - GR-PR sem Codigo de Barras
								35 - Pagamento de Tributos FGTS - GFIP 
								*/
	
								xTrb := xChkTrib(2) 
	
								aArray[nLin,nTipoPg] :=	"Tributo"  
	
								// Gps
								if	xTrb == 1
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	 :=	"17"
									MsUnlock("SE2")
									aArray[nLin,nCodCrd] :=	"17" 
									aArray[nLin,nModCrd] := "Gps"
								// Darf
								elseif	xTrb == 2
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	 :=	"16"
									MsUnlock("SE2")
									aArray[nLin,nCodCrd] :=	"16" 
									aArray[nLin,nModCrd] := "Darf"
								// Darf Simples
								elseif	xTrb == 3
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	 :=	"18"
									MsUnlock("SE2")
									aArray[nLin,nCodCrd] :=	"18" 
									aArray[nLin,nModCrd] := "Darf Simples"
								// DARJ
								elseif	xTrb == 4
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	 :=	"21"
									MsUnlock("SE2")
									aArray[nLin,nCodCrd] :=	"21" 
									aArray[nLin,nModCrd] := "DARJ"
								// Gare - SP
								elseif	xTrb == 5
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	 :=	"22"
									MsUnlock("SE2")
									aArray[nLin,nCodCrd] :=	"22" 
									aArray[nLin,nModCrd] := "Gare - SP"
								// Ipva (SP/MG)
								elseif	xTrb == 6
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	 :=	"25"
									MsUnlock("SE2")
									aArray[nLin,nCodCrd] :=	"25" 
									aArray[nLin,nModCrd] := "Ipva (SP/MG)"
								// Dpvat (SP/MG)
								elseif	xTrb == 7
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	 :=	"27"
									MsUnlock("SE2")
									aArray[nLin,nCodCrd] :=	"27" 
									aArray[nLin,nModCrd] := "Dpvat (SP/MG)"
								// Fgts
								elseif	xTrb == 8   
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	 :=	"35"
									MsUnlock("SE2")
									aArray[nLin,nCodCrd] :=	"35" 
									aArray[nLin,nModCrd] := "Fgts"  
								// Outros
								elseif	xTrb == 9
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	:=	"OT"
									MsUnlock("SE2")
									aArray[nLin,nCodCrd] :=	"OT" 
									aArray[nLin,nModCrd] := "Imp Cod Barras"  
								endif
							elseif	Substr(cCod,01,01) == "8" .and. Substr(cCod,02,01) $ "7"
								RecLock("SE2",.f.)
									SE2->E2_ZZMODBD	:=	"MT"
								MsUnlock("SE2")
								aArray[nLin,nTipoPg] :=	"Tributo"   
								aArray[nLin,nCodCrd] :=	"MT" 
								aArray[nLin,nModCrd] := "Multas Transito"
							elseif	Substr(cCod,01,01) == "8" 
								RecLock("SE2",.f.)
									SE2->E2_ZZMODBD	:=	"TC"
								MsUnlock("SE2")
								aArray[nLin,nTipoPg] :=	"Tributo"   
								aArray[nLin,nCodCrd] :=	"TC" 
								aArray[nLin,nModCrd] := "Imp Cod Barras"
							endif
							aArray[nLin,xModBor] := iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
							aArray[nLin,nModBor] := Empty(SE2->E2_ZZMODBD)	
							aArray[nLin,nModImp] := SE2->E2_ZZMODBD		
						endif
					endif
				endif
			endif
		
		elseif	lColLin
	
			cTmp :=	cCod
			cLin :=	StrTran(StrTran(cTmp," ",""),".","")
	
			if	Empty(Alltrim(cLin))
				if	Empty(aArray[nLin,nPosCdB]) 
					Return
				elseif	( MessageBox("Sobrepor a linha digitแvel jแ existente ?","Aten็ใo",MB_YESNO) == 6 )
					lAtu					:=	.t.
					aArray[nLin,nPosCdB] 	:=	""     
					aArray[nLin,nPosLnD] 	:=	""
					SE2->(dbgoto(aArray[nLin,nPosRec]))
					if	Substr(SE2->E2_CODBAR,01,01) == "8" 
						RecLock("SE2",.f.)
							SE2->E2_ZZMODBD	:=	Space(02)
						MsUnlock("SE2")
					endif
					if	Substr(SE2->E2_CODBAR,01,01) == "8" 
						aArray[nLin,nTipoPg] :=	"Boleto"   
					endif
					aArray[nLin,xModBor] 	:= 	iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
					aArray[nLin,nModBor] 	:= 	Empty(SE2->E2_ZZMODBD)	
					aArray[nLin,nModImp] 	:= 	SE2->E2_ZZMODBD		
					RecLock("SE2",.f.)
						SE2->E2_CODBAR		:=	""
						if	SE2->(FieldPos("E2_CBARRA")) <> 0 
							SE2->E2_CBARRA	:=	""
						endif
					MsUnlock("SE2")
					if	SE2->(FieldPos("E2_ZZLINDG")) <> 0 
						RecLock("SE2",.f.)
							SE2->E2_ZZLINDG	:=	""
						MsUnlock("SE2")
					endif
					if	SE2->(FieldPos("E2_LINDIGT")) <> 0 
						RecLock("SE2",.f.)
							SE2->E2_LINDIGT	:=	""
						MsUnlock("SE2")
					endif
					if	SE2->(FieldPos("E2_LINDIG")) <> 0 
						RecLock("SE2",.f.)
							SE2->E2_LINDIG	:=	""
						MsUnlock("SE2")
					endif
					Return
				endif
			endif
			
			if	Len(Alltrim(cLin)) <> 47 .and. Len(Alltrim(cLin)) <> 48
				MessageBox("Linha Digitแvel informada nใo ้ vแlida","Aten็ใo",MB_ICONHAND)
			else
				if	Len(Alltrim(cLin)) == 47 
					cCod		:=	Substr(cLin,01,04) + Substr(cLin,33,01) + Substr(cLin,34,04) + Strzero(Val(Substr(Alltrim(cLin),38,10)),10) + Substr(cLin,05,05) + Substr(cLin,11,10) + Substr(cLin,22,10)
					if	Substr(cLin,38,10) == Replicate("0",10)
						nVal	:=	Min(nSaldo,xSaldo)
					else
						nVal	:=	( Val(Substr(cLin,38,10)) / 100 )
					endif
				elseif	Len(Alltrim(cLin)) == 48 
					cCod		:=	Substr(cLin,01,11) + Substr(cLin,13,11) + Substr(cLin,25,11) + Substr(cLin,37,11)  
					nVal		:=	( Val(Substr(cCod,05,11)) / 100 )
				endif
				if	Len(cLin) == 47 .and. Substr(cLin,34,04) <> "0000" .and. Date() > DataValida( Val(Substr(cLin,34,04)) + StoD("19971007") ) 
					lGoF := ( MessageBox("Boleto vencido. Confirma ?","Aten็ใo",MB_YESNO) == 6 )
				endif
				if	lGoF
					if	Len(cLin) == 47 .and. Substr(cLin,01,01) == "8"
						MessageBox("Linha Digitแvel informada nใo ้ vแlida","Aten็ใo",MB_ICONHAND)
					elseif	Len(cLin) == 48 .and. Substr(cLin,01,01) <> "8"
						MessageBox("Linha Digitแvel informada nใo ้ vแlida","Aten็ใo",MB_ICONHAND)
					elseif	Len(cCod) <> 44 
						MessageBox("Linha Digitแvel informada nใo ้ vแlida","Aten็ใo",MB_ICONHAND)
					elseif	nVal <> nSaldo .and. nVal <> xSaldo 
						MessageBox("O valor do boleto nใo confere com o valor a pagar","Aten็ใo",MB_ICONHAND)
					elseif	VldCodBar(cLin)
						For w := 1 to Len(aArray)
							if	w <> nLin
								if	cTmp == aArray[w,nPosLnD] 	
								 	lRep := .t.
								endif			
							endif
			            Next w 
						if	lRep
							MessageBox("Linha Digitแvel jแ digitada","Aten็ใo",MB_ICONHAND)
						else
							if	Empty(aArray[nLin,nPosCdB]) .or. ( MessageBox("Sobrepor a linha digitแvel jแ existente ?","Aten็ใo",MB_YESNO) == 6 )
								lAtu					:=	.t.
								aArray[nLin,nPosCdB] 	:=	cCod
								aArray[nLin,nPosLnD] 	:=	cTmp
								SE2->(dbgoto(aArray[nLin,nPosRec]))
								if	SE2->E2_CODBAR <> cCod
									RecLock("SE2",.f.)
										SE2->E2_CODBAR		:=	cCod
										if	SE2->(FieldPos("E2_CBARRA")) <> 0 
											SE2->E2_CBARRA	:=	cCod
										endif
									MsUnlock("SE2")
								endif
								if	SE2->(FieldPos("E2_ZZLINDG")) <> 0 
									RecLock("SE2",.f.)
										SE2->E2_ZZLINDG	:=	cLin
									MsUnlock("SE2")
								endif    
								if	SE2->(FieldPos("E2_LINDIGT")) <> 0 
									RecLock("SE2",.f.)
										SE2->E2_LINDIGT	:=	cLin
									MsUnlock("SE2")
								endif    
								if	SE2->(FieldPos("E2_LINDIG")) <> 0 
									RecLock("SE2",.f.)
										SE2->E2_LINDIG	:=	cLin
									MsUnlock("SE2")
								endif    
								if	Substr(cCod,01,01) <> "8" 
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	:=	Space(02)
									MsUnlock("SE2")
									aArray[nLin,nTipoPg] :=	"Boleto"   
								elseif	Substr(cCod,01,01) == "8" .and. Substr(cCod,02,01) $ "1"
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	:=	"19"
									MsUnlock("SE2")
									aArray[nLin,nTipoPg] :=	"Tributo"   
									aArray[nLin,nCodCrd] :=	"19" 
									aArray[nLin,nModCrd] := "Trib. Municipais"
								elseif	Substr(cCod,01,01) == "8" .and. Substr(cCod,02,01) $ "2/3/4"
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	:=	Space(02)
									MsUnlock("SE2")
									aArray[nLin,nTipoPg] :=	"Boleto"   
									aArray[nLin,nCodCrd] :=	"13" 
									aArray[nLin,nModCrd] := "Concessionaria"
								elseif	Substr(cCod,01,01) == "8" .and. Substr(cCod,02,01) $ "5"
		
									/*
									ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
									ณ Identificacao dos Tributos  ณ
									ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู   
							
									13 - Pagamento a Concessionarias
									16 - Pagamento de Tributos DARF
									17 - Pagamento de Tributos GPS
									18 - Pagamento de Tributos DARF SIMPLES   
									19 - Pagamento de IPTU / Tributos Municipais
									21 - Pagamento de Tributos DARJ
									22 - Pagamento de Tributos GARE ICMS SP
									25 - Pagamento de Tributos IPVA (SP e MG)
									27 - Pagamento de Tributos DPVAT     
									28 - GR-PR com Codigo de Barras
									29 - GR-PR sem Codigo de Barras
									35 - Pagamento de Tributos FGTS - GFIP 
									*/
		
									xTrb := xChkTrib(2) 
		
									aArray[nLin,nTipoPg] :=	"Tributo"  
		
									// Gps
									if	xTrb == 1
										RecLock("SE2",.f.)
											SE2->E2_ZZMODBD	 :=	"17"
										MsUnlock("SE2")
										aArray[nLin,nCodCrd] :=	"17" 
										aArray[nLin,nModCrd] := "Gps"
									// Darf
									elseif	xTrb == 2
										RecLock("SE2",.f.)
											SE2->E2_ZZMODBD	 :=	"16"
										MsUnlock("SE2")
										aArray[nLin,nCodCrd] :=	"16" 
										aArray[nLin,nModCrd] := "Darf"
									// Darf Simples
									elseif	xTrb == 3
										RecLock("SE2",.f.)
											SE2->E2_ZZMODBD	 :=	"18"
										MsUnlock("SE2")
										aArray[nLin,nCodCrd] :=	"18" 
										aArray[nLin,nModCrd] := "Darf Simples"
									// DARJ
									elseif	xTrb == 4
										RecLock("SE2",.f.)
											SE2->E2_ZZMODBD	 :=	"21"
										MsUnlock("SE2")
										aArray[nLin,nCodCrd] :=	"21" 
										aArray[nLin,nModCrd] := "DARJ"     
									// Gare - SP
									elseif	xTrb == 5
										RecLock("SE2",.f.)
											SE2->E2_ZZMODBD	 :=	"22"
										MsUnlock("SE2")
										aArray[nLin,nCodCrd] :=	"22" 
										aArray[nLin,nModCrd] := "Gare - SP"
									// Ipva (SP/MG)
									elseif	xTrb == 6
										RecLock("SE2",.f.)
											SE2->E2_ZZMODBD	 :=	"25"
										MsUnlock("SE2")
										aArray[nLin,nCodCrd] :=	"25" 
										aArray[nLin,nModCrd] := "Ipva (SP/MG)"
									// Dpvat (SP/MG)
									elseif	xTrb == 7
										RecLock("SE2",.f.)
											SE2->E2_ZZMODBD	 :=	"27"
										MsUnlock("SE2")
										aArray[nLin,nCodCrd] :=	"27" 
										aArray[nLin,nModCrd] := "Dpvat (SP/MG)"
									// Fgts
									elseif	xTrb == 8
										RecLock("SE2",.f.)
											SE2->E2_ZZMODBD	 :=	"35"
										MsUnlock("SE2")
										aArray[nLin,nCodCrd] :=	"35" 
										aArray[nLin,nModCrd] := "Fgts"  
									// Outros
									elseif	xTrb == 9
										RecLock("SE2",.f.)
											SE2->E2_ZZMODBD	 :=	"OT"
										MsUnlock("SE2")
										aArray[nLin,nCodCrd] :=	"OT" 
										aArray[nLin,nModCrd] := "Imp Cod Barras"  
									endif
								elseif	Substr(cCod,01,01) == "8" .and. Substr(cCod,02,01) $ "7"
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	 :=	"MT"
									MsUnlock("SE2")
									aArray[nLin,nTipoPg] :=	"Tributo"   
									aArray[nLin,nCodCrd] :=	"MT" 
									aArray[nLin,nModCrd] := "Multas Transito"
								elseif	Substr(cCod,01,01) == "8" 
									RecLock("SE2",.f.)
										SE2->E2_ZZMODBD	 :=	"TC"
									MsUnlock("SE2")
									aArray[nLin,nTipoPg] :=	"Tributo"   
									aArray[nLin,nCodCrd] :=	"TC" 
									aArray[nLin,nModCrd] := "Imp Cod Barras"
								endif
								aArray[nLin,xModBor] := iif( Empty(SE2->E2_ZZMODBD)	, "1" , "2" )
								aArray[nLin,nModBor] := Empty(SE2->E2_ZZMODBD)	
								aArray[nLin,nModImp] := SE2->E2_ZZMODBD		
							endif
						endif
					endif
				endif
			endif
		endif	   
	endif	   

elseif	nCol == nColVct	

	lAtu	:=	.t.
	lAltera := 	.t.

	SE2->(dbgoto(aArray[nLin,nPosRec]))		
	
	if	lSE2Excl	
		cFilAnt	:= SE2->E2_FILIAL
	elseif	lSA2Excl .or. lSA6Excl	
		cFilAnt	:= SE2->E2_FILORIG
	endif	
	
	if	!Empty(aArray[nLin,SE2->(FieldPos("E2_NUMBOR"))])
		MessageBox("Tํtulo jแ estแ em border๔. Nใo pode ser alterada a data","Aten็ใo",MB_ICONHAND)
	elseif	aArray[nLin,nPosStt] ==	"8"
		MessageBox("Tํtulo com pedido de altera็ใo de vencimento. Nใo pode ser alterada a data.","Aten็ใo",MB_ICONHAND)
	else
		if	lFin050
			if 	lFa050Upd
				if !ExecBlock("FA050UPD",.f.,.f.)
					lAtu := .f.
					MessageBox("Titulo bloquaeado para altera็ใo pela regra do FA050UPD","Aten็ใo",MB_ICONHAND)
				endif
			endif
		endif
		if	lAtu
			cCod := aArray[nLin,nPosCdB]
			dDat := fQuadro(aArray[nLin,SE2->(FieldPos("E2_VENCREA"))],aArray[nLin,SE2->(FieldPos("E2_VENCTO"))]) 
			if	!Empty(cCod) .and. Len(cCod) == 44 .and. Substr(cCod,01,01) <> "8" .and. Substr(cCod,06,04) <> "0000" .and. dDat > DataValida( Val(Substr(cCod,06,04)) + StoD("19971007") )  
				MessageBox("A data digitada ้ maior que a data do boleto informado.","Aten็ใo",MB_ICONHAND)
			else
				if	dDat <> aArray[nLin,SE2->(FieldPos("E2_VENCREA"))]
					if	( MessageBox("Confirma altera็ใo ?","Aten็ใo",MB_YESNO) == 6 )	 
						if	SE2->(Fieldpos("E2_ZZAUDIT")) <> 0	
							xMem := "Vencimento alterado por " + Upper(Alltrim(cUserName)) + " em " + DtoC(Date()) + " as " + Substr(Time(),01,05) + CRLF
							xMem += "De " + DtoC(aArray[nLin,SE2->(FieldPos("E2_VENCREA"))]) + " para " + DtoC(dDat) + CRLF 
							xMem += "Pela rotina de Prepara็ใo de Pagamentos" + CRLF 
							xMem += SE2->E2_ZZAUDIT
							if	GetMv("ZZ_XALTVCP")
								RecLock("SE2",.f.)
									SE2->E2_ZZAUDIT	:= 	xMem
									SE2->E2_VENCTO	:=	dDat 
									SE2->E2_VENCREA	:=	DataValida(dDat)        		
								MsUnlock("SE2")
							else
								RecLock("SE2",.f.)
									SE2->E2_ZZAUDIT	:= 	xMem
									SE2->E2_VENCREA	:=	DataValida(dDat)        		
								MsUnlock("SE2")
							endif
						else
							if	GetMv("ZZ_XALTVCP")
								RecLock("SE2",.f.)
									SE2->E2_VENCTO	:=	dDat        		
									SE2->E2_VENCREA	:=	DataValida(dDat)        		
								MsUnlock("SE2")
							else	
								RecLock("SE2",.f.)
									SE2->E2_VENCREA	:=	DataValida(dDat)        		
								MsUnlock("SE2")
							endif	
						endif		
						if	lFin050
							if	lF050Alt						
								ExecBlock("F050ALT",.f.,.f.,{1})
							endif												
						endif												
						if	GetMv("ZZ_XALTVCP")
							aArray[nLin,SE2->(FieldPos("E2_VENCTO"))] 	:= 	dDat			
							aArray[nLin,SE2->(FieldPos("E2_VENCREA"))] 	:= 	DataValida(dDat)        		
    					else                                               	
							aArray[nLin,SE2->(FieldPos("E2_VENCREA"))] 	:= 	dDat			
						endif
					endif
				endif
			endif
		endif
	endif

	cFilAnt := xFilAnt
		
elseif	nCol == nColAcr .or. nCol == nColDec  

	SE2->(dbgoto(aArray[nLin,nPosRec]))   

	nSaldo	:=	Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)

	if	!Empty(aArray[nLin,SE2->(FieldPos("E2_NUMBOR"))])
		MessageBox("Tํtulo em border๔. Nใo pode ser alterado.","Aten็ใo",MB_ICONHAND)
	elseif	SE2->E2_ACRESC <> SE2->E2_SDACRES .or. SE2->E2_DECRESC <> SE2->E2_SDDECRE    
		if	nCol == nColAcr 
			MessageBox("Nใo pode ser alterado o acr้scimo do tํtulo, pois jแ sofreu altera็ใo.","Aten็ใo",MB_ICONHAND)
		else
			MessageBox("Nใo pode ser alterado o decr้scimo do tํtulo, pois jแ sofreu altera็ใo.","Aten็ใo",MB_ICONHAND)
		endif
	elseif	nCol == nColAcr .and. SE2->(E2_DECRESC + E2_SDDECRE) <> 0 
		MessageBox("Nใo pode ser incluํdo um acr้scimo, pois o tํtulo jแ tem um decr้scimo informado.","Aten็ใo",MB_ICONHAND)
	elseif	nCol == nColDec .and. SE2->(E2_ACRESC + E2_SDACRES) <> 0 
		MessageBox("Nใo pode ser incluํdo um decr้scimo, pois o tํtulo jแ tem um acr้scimo informado.","Aten็ใo",MB_ICONHAND)
	else
		nVal := fGetVal(nSaldo,nCol == nColAcr)
		if	nVal >= 0 

			RecLock("SE2",.f.)
				SE2->E2_ACRESC	:=	iif( nCol == nColAcr , nVal , 0 )
				SE2->E2_SDACRES	:=	iif( nCol == nColAcr , nVal , 0 )
				SE2->E2_DECRESC	:=	iif( nCol == nColDec , nVal , 0 )
				SE2->E2_SDDECRE	:=	iif( nCol == nColDec , nVal , 0 )
			MsUnlock("SE2")

			nSaldo	:=	Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)

			aArray[nLin,SE2->(FieldPos("E2_ACRESC"))] 	:=	iif( nCol == nColAcr , nVal , 0 )
			aArray[nLin,SE2->(FieldPos("E2_SDACRES"))]	:=	iif( nCol == nColAcr , nVal , 0 )
			aArray[nLin,SE2->(FieldPos("E2_DECRESC"))]	:=	iif( nCol == nColDec , nVal , 0 )
			aArray[nLin,SE2->(FieldPos("E2_SDDECRE"))]	:=	iif( nCol == nColDec , nVal , 0 )
			aArray[nLin,SE2->(FieldPos("E2_SALDO"))] 	:=	nSaldo	
			
			xStatusArr(@aArray,nSaldo,nLin)
		endif		
	endif		
endif

if	lAtu	
	SE2->(dbgoto(aArray[nLin,nPosRec]))
	nSaldo := Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)
	xModPg(@aArray,nLin,nSaldo,!( aArray[nLin,nPosStt] $ "1/5/9" ))
endif
	
oGrid:Refresh()         		

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fGetVal(nSaldo,lAcr)

Local oFont
Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1  
Local lOk			:=	.f.
Local nTGet1		:=	0.00

do while .t.

	lOk		:=	.f.
	nTGet1	:= 	0.00

	Define Font oFont Name "Tahoma" Size 0,-11 Bold
	
	Define Dialog oDlgAlt Title "Informe" From 000,000 To 080,200 Pixel
	oSay1		:= 	tSay():Create(oDlgAlt,{|| "Valor :" },08,05,,oFont,,,,.t.,Nil,)
	oTGet1 		:= 	tGet():New(05,50,bSetGet(nTGet1),oDlgAlt,047,009,PesqPict("SE2","E2_ACRESC"),,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
	oTButton1	:= 	tButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
	Activate Dialog oDlgAlt Centered
	
	if	lOk
		if	nTGet1 < 0
			nTGet1 := 0.00
			Loop
		else  
			if	lAcr
				if	nTGet1 > 0 .or. ( MessageBox("Confirma valor zerado ?","Aten็ใo",MB_YESNO) == 6 )	
					Exit			
    			endif
			else	
				if	nTGet1 > nSaldo
					MessageBox("O valor do decrescimo nใo pode ser maior que o saldo a pagar.","Aten็ใo",MB_ICONHAND)
					nTGet1 := 0.00
					Loop
				else						
					if	nTGet1 > 0 .or. ( MessageBox("Confirma valor zerado ?","Aten็ใo",MB_YESNO) == 6 )	
						Exit			
	    			endif
				endif					
			endif					
		endif					
	else 
		nTGet1 := -1
		Exit
	endif
enddo

Return ( nTGet1 )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fQuadro(dTGet1,dVencto)

Local oFont
Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1  
Local lOk			:=	.f.
Local dOld			:=	dTGet1	

do while .t.

	lOk	:=	.f.

	Define Font oFont Name "Tahoma" Size 0,-11 Bold
	
	Define Dialog oDlgAlt Title "Informe" From 000,000 To 080,200 Pixel
	oSay1		:= 	tSay():Create(oDlgAlt,{|| "Vencimento :" },08,05,,oFont,,,,.t.,Nil,)
	oTGet1 		:= 	tGet():New(05,50,bSetGet(dTGet1),oDlgAlt,047,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
	oTButton1	:= 	tButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
	Activate Dialog oDlgAlt Centered
	
	if	lOk
		if	Empty(dTGet1)   
			dTGet1 := dOld
			Loop
		else  
			if	dTGet1 < Date()
				MessageBox("O vencimento nใo pode ser menor que a data do dia.","Aten็ใo",MB_ICONHAND)
				dTGet1 := dOld
				Loop
			elseif	dTGet1 < dVencto 
				if	( MessageBox("O vencimento digitado ้ menor que o vencimento do tํtulo. Confirma ?","Aten็ใo",MB_YESNO) == 6 )	
	    			Exit
	    		else
					dTGet1 := dOld
					Loop
				endif		
			elseif dTGet1 <> DataValida(dTGet1) .and. !GetMv("ZZ_XALTVCP")	
				MessageBox("O vencimento real deve ser um dia ๚til.","Aten็ใo",MB_ICONHAND)
				dTGet1 := dOld
				Loop
			else						
				Exit
			endif					
		endif					
	else
		dTGet1 := dOld
		Exit
	endif

enddo

Return ( dTGet1 )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
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
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
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
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
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
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xChecaPar()

Local xFilAnt	:=	cFilAnt
Local aAreaSM0	:=	SM0->(GetArea())

Local cPar 		:= 	PadR("ZZ_FILAGTB",Len(SX6->X6_VAR))
	
SX6->(dbsetorder(1))

SM0->(dbsetorder(1))
SM0->(dbgotop())

do while SM0->(!Eof())
	if	SM0->(deleted())
		SM0->(dbskip())
		Loop
	endif
	if	Upper(Alltrim(SM0->M0_CODIGO)) == Upper(Alltrim(cEmpAnt))
		cFilAnt := Alltrim(SM0->M0_CODFIL)
		if !SX6->(dbseek( cFilAnt + cPar , .f. ))
			Reclock("SX6",.t.)
				SX6->X6_FIL		:=	cFilAnt
				SX6->X6_VAR		:=	cPar
				SX6->X6_TIPO	:=	"C"
				SX6->X6_DESCRIC	:=	"Filial Centralizadora para Geracao do Bordero"
				SX6->X6_CONTEUD	:=	iif( lFadel , Substr(cFilAnt,01,04) + "0001" , cFilAnt )
				SX6->X6_CONTSPA	:=	SX6->X6_CONTEUD
				SX6->X6_CONTENG	:=	SX6->X6_CONTEUD
				SX6->X6_PROPRI	:=	"U"
			MsUnlock("SX6")
		endif			
	endif			
	SM0->(dbskip())
enddo

RestArea(aAreaSM0)

cFilAnt := xFilAnt

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function F241DTBOR()

Local t
Local cSeekXK	:= 	"U" + RetCodUsr() 	

PswOrder(1)    

if 	PswSeek(RetCodUsr())
	if 	PswRet()[02][11] .and. Len(PswRet()[01][10]) > 0
		cSeekXK	:= 	"G" + PswRet()[01][10][01]
	endif
endif

For t := 01 to 10       	
	SX1->(dbsetorder(1))
	if	SX1->(dbseek( PadR( "F240BR" , Len(SX1->X1_GRUPO) )  + StrZero(t,02) , .f. ))
		SXK->(dbsetorder(2))
		if	SXK->(dbseek( cSeekXK + SX1->X1_GRUPO + SX1->X1_ORDEM , .f. ))
			RecLock("SXK",.f.,.t.)
				SXK->(dbdelete())
			MsUnlock("SXK")
		endif 
	endif 
Next t 

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xModPg(aArray,nLin,nSaldo,lZerar)

if	Upper(Alltrim(aArray[nLin,nTipoPg])) <> "TRIBUTO"
	if	lZerar
		aArray[nLin,nModCrd] := 	""
		aArray[nLin,nCodCrd] := 	""
	elseif	Upper(Alltrim(aArray[nLin,nTipoPg])) == "BOLETO" 
		if	Empty(Alltrim(aArray[nLin,nPosCdB])) 
			aArray[nLin,nModCrd] 	:= 	""
			aArray[nLin,nCodCrd] 	:= 	""
		elseif	Substr(Alltrim(aArray[nLin,nPosCdB]),01,01) == "8"
			aArray[nLin,nModCrd] 	:= 	"Concessionaria"
			aArray[nLin,nCodCrd] 	:= 	"13"
		elseif	Substr(Alltrim(aArray[nLin,nPosCdB]),01,03) == Alltrim(aArray[nLin,nPosBco])
			aArray[nLin,nModCrd] 	:= 	"Mesmo Banco"
			aArray[nLin,nCodCrd] 	:= 	"30"
		elseif	Substr(Alltrim(aArray[nLin,nPosCdB]),01,03) <> Alltrim(aArray[nLin,nPosBco])
			aArray[nLin,nModCrd]	:= 	"Outro Banco"
			aArray[nLin,nCodCrd] 	:= 	"31"
		endif
	elseif	Upper(Alltrim(aArray[nLin,nTipoPg])) == "DEPOSITO" 
		if	Empty(Alltrim(aArray[nLin,nPosBco]))
			aArray[nLin,nModCrd] 	:= 	""
			aArray[nLin,nCodCrd] 	:= 	""
		elseif	Alltrim(aArray[nLin,nPosBco]) == Alltrim(aArray[nLin,nBcoDep]) .and. !Empty(aArray[nLin,nAgeDep]) .and. !Empty(aArray[nLin,nCtaDep])
			aArray[nLin,nModCrd] 	:= 	"Transferencia"
			aArray[nLin,nCodCrd] 	:= 	"01"
		elseif	lPix .and. !Empty(aArray[nLin,nChvPix]) 
			aArray[nLin,nModCrd] 	:= 	"PIX"
			aArray[nLin,nCodCrd] 	:= 	"45"
		elseif	Alltrim(aArray[nLin,nPosBco]) <> Alltrim(aArray[nLin,nBcoDep]) .and. !Empty(aArray[nLin,nAgeDep]) .and. !Empty(aArray[nLin,nCtaDep]) .and. nSaldo < nMinTed
			aArray[nLin,nModCrd] 	:= 	"DOC"
			aArray[nLin,nCodCrd] 	:= 	"03"
		elseif	Alltrim(aArray[nLin,nPosBco]) <> Alltrim(aArray[nLin,nBcoDep]) .and. !Empty(aArray[nLin,nAgeDep]) .and. !Empty(aArray[nLin,nCtaDep]) .and. nSaldo >= nMinTed
			aArray[nLin,nModCrd] 	:= 	"TED"
			aArray[nLin,nCodCrd] 	:= 	"41"
		endif
		if	aArray[nLin,nCodCrd] 	== 	"01"
			if	!Empty(Alltrim(aArray[nLin,nCgcBen])) .and. Len(Alltrim(aArray[nLin,nCgcBen])) == 11 .and. Alltrim(aArray[nLin,nTipCta]) == "2"
				aArray[nLin,nModCrd] 	:= 	"Transf. Poup."
				aArray[nLin,nCodCrd]	:= 	"05"
			elseif	Empty(Alltrim(aArray[nLin,nCgcBen])) .and. Len(Alltrim(aArray[nLin,nCgcFor])) <> 14 .and. Alltrim(aArray[nLin,nTipCta]) == "2"
				aArray[nLin,nModCrd] 	:= 	"Transf. Poup."
				aArray[nLin,nCodCrd]	:= 	"05"
			endif
		endif
	else
		aArray[nLin,nModCrd] := 	""
		aArray[nLin,nCodCrd] := 	""
	endif
endif
	
Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xCodBarr(oDlg,oGrid,aArray) ; Return( fCodBarr(@oDlg,@oGrid,@aArray) )

Static Function fCodBarr(oDlg,oGrid,aArray)

Local nOpc      
Local aRet
Local oSay1
Local oSay2
Local oSay3
Local cTGet1   
Local oTGet1   
Local cTGet2   
Local oTGet2   
Local cTGet3   
Local oTGet3   
Local oDlgAlt
Local oTButton1           

Local oFont 		:= 	tFont():New("Verdana",,14,.t.,.f.)
Local oFontB		:= 	tFont():New("Verdana",,14,.t.,.t.)

do while .t. 

	nOpc 	:= 	0
	aRet 	:= 	{"","",""}

	cTGet3	:=	Space(54)	    
	cTGet2	:=	Space(62)	
	cTGet1	:=	iif( lIsBlind , Space(48) , CriaVar("E2_CODBAR",.f.) )

	Define Dialog oDlgAlt Title "Digite o C๓digo Correspondente" From 000,000 To 136,562 Pixel
	
	oSay1			:= 	TSay():Create(oDlgAlt,{|| "C๓digo de Barras" },08,05,,oFontB,,,,.t.,CLR_BLUE,)
	oTGet1 			:= 	TGet():New(05,073,bSetGet(cTGet1),oDlgAlt,203,009,"@!"                                                    			,,0,,oFont,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
	oTGet1:bValid	:=	{ || xValCodBar(@oTGet1,@cTGet1,01)	}
	oTGet1:bChange	:=	{ || fValCodBar(@oTGet1,@cTGet1,01)	}

	oSay2			:= 	TSay():Create(oDlgAlt,{|| "Linha Digitแvel " },23,05,,oFontB,,,,.t.,CLR_BLUE,)
	oTGet2 			:= 	tGet():New(20,073,bSetGet(cTGet2),oDlgAlt,203,009,"99999.99999 99999.999999 99999.999999 9 999999999999999999999"	,,0,,oFont,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
	oTGet2:bValid	:=	{ || xValCodBar(@oTGet2,@cTGet2,02)	}
	oTGet2:bChange	:=	{ || fValCodBar(@oTGet2,@cTGet2,02)	}
	
	oSay3			:= 	TSay():Create(oDlgAlt,{|| "Concessionแria  " },38,05,,oFontB,,,,.t.,CLR_BLUE,)
	oTGet3 			:= 	tGet():New(35,073,bSetGet(cTGet3),oDlgAlt,203,009,"999999999999 999999999999 999999999999 999999999999999"   		,,0,,oFont,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
	oTGet3:bValid	:=	{ || xValCodBar(@oTGet3,@cTGet3,03)	}
	oTGet3:bChange	:=	{ || fValCodBar(@oTGet3,@cTGet3,03)	}
	
	oTButton1	:= 	TButton():New(052,236,"Ok",oDlgAlt,{ || nOpc := 1 , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)     
	
	Activate Dialog oDlgAlt Centered   
	
	if	nOpc == 0 
		Exit
	elseif	Empty(cTGet1) .and. !Empty(cTGet2) .and. !Empty(cTGet3)
		Alert("Preencha apenas um campo")
	elseif	Empty(cTGet2) .and. !Empty(cTGet1) .and. !Empty(cTGet3)
		Alert("Preencha apenas um campo")
	elseif	Empty(cTGet3) .and. !Empty(cTGet1) .and. !Empty(cTGet2)
		Alert("Preencha apenas um campo")
	else
		aRet := {cTGet1,cTGet2,cTGet3}
		Exit
	endif

enddo

Return ( aRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xValCodBar(oGet,cGet,nGet)	

Local t
Local lRet	:=	.t.
Local xGet	:=	Alltrim(StrTran(StrTran(StrTran(cGet,"-",""),".","")," ",""))

For t := 1 to Len(xGet)
	if !Substr(xGet,t,01) $ "0123456789"
		Alert("Preencha somente com n๚meros")
		lRet := .f.
		Exit
	endif
Next t 

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fValCodBar(oGet,cGet,nGet)	

Local lRet	:=	.t.
Local xGet	:=	Alltrim(StrTran(StrTran(StrTran(cGet,"-",""),".","")," ",""))

if	nGet == 1 
	cGet	:=	PadR(Alltrim(xGet),48)
elseif	nGet == 2 
	cGet	:=	Substr(xGet,01,05) + "."
	xGet	:=	Substr(xGet,06)
	cGet	+=	Substr(xGet,01,05) + " "
	xGet	:=	Substr(xGet,06)
	cGet	+=	Substr(xGet,01,05) + "."
	xGet	:=	Substr(xGet,06)
	cGet	+=	Substr(xGet,01,06) + " "
	xGet	:=	Substr(xGet,07)
	cGet	+=	Substr(xGet,01,05) + "."
	xGet	:=	Substr(xGet,06)
	cGet	+=	Substr(xGet,01,06) + " "
	xGet	:=	Substr(xGet,07)
	cGet	+=	Substr(xGet,01,01) + " "
	xGet	:=	Substr(xGet,02)
	cGet	+=	Substr(xGet,01) 
	cGet	:=	PadR(Alltrim(cGet),62)
elseif	nGet == 3
	cGet	:=	Substr(xGet,01,12) + " "
	xGet	:=	Substr(xGet,13)
	cGet	+=	Substr(xGet,01,12) + " "
	xGet	:=	Substr(xGet,13)
	cGet	+=	Substr(xGet,01,12) + " "
	xGet	:=	Substr(xGet,13)
	cGet	+=	Substr(xGet,01,12) + " "
	cGet	:=	PadR(Alltrim(cGet),54)
endif

oGet:SetText(cGet)

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fLinDigt(oDlg,oGrid,aArray)	

Local oSay1
Local oCombo
Local oTGet1   
Local oTGet2   
Local oDlgAlt
Local oTButton1    
    
Local cTGet1		:=	Space(55) 
Local cTGet2		:=	Space(51) 
Local oFont 		:= 	tFont():New("Verdana",,14,.t.,.f.)
Local oFontB		:= 	tFont():New("Verdana",,14,.t.,.t.)    
Local bTGet1		:=	{ || oTGet2:Hide() , oTGet1:Show() }
Local bTGet2		:=	{ || oTGet1:Hide() , oTGet2:Show() }
Local bChange		:=	{ || nOpcC := oCombo:nAt , iif( nOpcC == 1 , Eval(bTGet1) , Eval(bTGet2) ) } 

Local nOpcC			:=	0
Local aItens 		:=	{ "Codigo de Barras" , "Concessionแria" }
Local cCombo 		:=	aItens[01]

Define Dialog oDlgAlt Title "Linha Digitแvel" From 000,000 To 080,600 Pixel
oSay1		:= 	tSay():Create(oDlgAlt,{|| "Digite :" },08,05,,oFontB,,,,.t.,CLR_BLUE,)
oCombo		:=	tComboBox():New(05,035,bSetGet(cCombo),aItens,067,050,oDlgAlt,,{ || Eval(bChange) },,,,.t.,oFont,,,,,,)
oTGet1 		:= 	tGet():New(05,107,bSetGet(cTGet1),oDlgAlt,190,009,"99999.99999 99999.999999 99999.999999 9 99999999999999",,0,,oFont,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
oTGet2 		:= 	tGet():New(05,107,bSetGet(cTGet2),oDlgAlt,190,009,"999999999999 999999999999 999999999999 999999999999",,0,,oFont,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
oTGet2:Hide()
oTButton1	:= 	tButton():New(025,256,"Ok",oDlgAlt,{ || nOpcC := oCombo:nAt , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered   

Return ( iif( nOpcC == 0 , "" , iif( nOpcC == 1 , cTGet1 , cTGet2 ) ) )
	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xStatusArr(aArray,nSaldo,nLin)

Default nLin	:= 	Len(aArray) 

if	nSaldo <= 0
	aArray[nLin,nPosStt] := 	"9"    									// Sem saldo
elseif	SE2->E2_SALDO <> SE2->E2_VALOR
	if 	!Empty(SE2->E2_NUMBOR)
		aArray[nLin,nPosStt] := 	"4"    								// Titulo em Bordero
	elseif	xRetExPA()
		aArray[nLin,nPosStt] := 	"3"									// Tem PA
	elseif	Empty(aArray[nLin,SE2->(FieldPos("E2_DATALIB"))]) .and. lLibPag
		aArray[nLin,nPosStt] := 	"2"									// Nao Liberado
	else
		aArray[nLin,nPosStt] := 	"5"									// Liberado
	endif
else
	if 	!Empty(SE2->E2_NUMBOR)
		aArray[nLin,nPosStt] := 	"4"    								// Titulo em Bordero
	elseif 	!(SE2->E2_TIPO $ MVPAGANT + "/" + MV_CPNEG)
		if	Empty(aArray[nLin,SE2->(FieldPos("E2_DATALIB"))]) .and. lLibPag
			aArray[nLin,nPosStt] := 	"2"								// Nao Liberado
		else
			if	xRetExPA()
				aArray[nLin,nPosStt] := 	"3"							// Tem PA
			else
				aArray[nLin,nPosStt] := 	"1"							// Liberado
			endif
		endif
	else
		if	Empty(aArray[nLin,SE2->(FieldPos("E2_DATALIB"))]) .and. lLibPag
			aArray[nLin,nPosStt] := 	"2"								// Nao Liberado
		else
			aArray[nLin,nPosStt] := 	"1"								// Liberado
		endif
	endif
endif

Return     

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fCleanTit(oDlg,oGrid,aArray,lDesmarca)

Local nI 		
Local lFlag

Default oDlg		:=	Nil
Default oGrid		:=	Nil
Default aArray		:=	{}                  
Default lDesmarca	:=	.t.

For nI := 1 To Len(aArray)
	if	aArray[nI,nPosFlg]
		lFlag := .f.
		if	aArray[nI,nPosStt] == "8" 
			lFlag	:=	.t. 
		elseif	aArray[nI,nPosStt] <> "1" .and. aArray[nI,nPosStt] <> "5"
			lFlag	:=	.t. 
		elseif	Empty(aArray[nI,nPosBco])
			lFlag	:=	.t. 
		elseif	Empty(aArray[nI,nTipoPg])
			lFlag	:=	.t. 
		elseif	Upper(Alltrim(aArray[nI,nTipoPg])) == "TRIBUTO"
			if	Alltrim(aArray[nI,nModImp]) == "13" .and. Empty(aArray[nI,nPosCdB])
				lFlag	:=	.t. 
			elseif	Alltrim(aArray[nI,nModImp]) == "16" .and. Empty(aArray[nI,nPosCdB]) .and. ( Empty(aArray[nI,SE2->(FieldPos("E2_CODRET"))]) .or. aArray[nI,SE2->(FieldPos('E2_ZZVLPR'))] <= 0 )
				lFlag	:=	.t. 
			elseif	Alltrim(aArray[nI,nModImp]) == "17" .and. Empty(aArray[nI,nPosCdB]) .and. ( Empty(aArray[nI,SE2->(FieldPos("E2_CODINS"))]) .or. aArray[nI,SE2->(FieldPos('E2_ZZVLPR'))] <= 0 )
				lFlag	:=	.t. 
			elseif	Alltrim(aArray[nI,nModImp]) == "19" .and. Empty(aArray[nI,nPosCdB])
				lFlag	:=	.t. 
			elseif	Alltrim(aArray[nI,nModImp]) == "22" .and. Empty(aArray[nI,nPosCdB])
				lFlag	:=	.t.    
			elseif	Alltrim(aArray[nI,nModImp]) == "25" .and. Empty(aArray[nI,nPosCdB])
				lFlag	:=	.t.    
			elseif	Alltrim(aArray[nI,nModImp]) == "27" .and. Empty(aArray[nI,nPosCdB])
				lFlag	:=	.t.    
			elseif	Alltrim(aArray[nI,nModImp]) == "35" .and. Empty(aArray[nI,nPosCdB])
				lFlag	:=	.t.    
			elseif	Alltrim(aArray[nI,nModImp]) == "OT" .and. Empty(aArray[nI,nPosCdB])
				lFlag	:=	.t.    
			elseif	Alltrim(aArray[nI,nModImp]) == "MT" .and. Empty(aArray[nI,nPosCdB])
				lFlag	:=	.t.    
			elseif	Alltrim(aArray[nI,nModImp]) == "TC" .and. Empty(aArray[nI,nPosCdB])
				lFlag	:=	.t.    
			elseif	!Empty(aArray[nI,nBcoPag]) .and. !( aArray[nI,nPosBco] $ aArray[nI,nBcoPag] )
				lFlag	:=	.t. 
			endif
		elseif	Upper(Alltrim(aArray[nI,nTipoPg])) == "BOLETO"
			if	Empty(aArray[nI,nPosCdB])
				lFlag	:=	.t. 
			endif
		elseif	Upper(Alltrim(aArray[nI,nTipoPg])) == "DEPOSITO" 
			if	Upper(Alltrim(aArray[nI,nModCrd])) == "PIX" .and. Empty(aArray[nI,nChvPix]) 
				lFlag	:=	.t. 
			elseif	Upper(Alltrim(aArray[nI,nModCrd])) <> "PIX" .and. ( Empty(aArray[nI,nBcoDep]) .or. Empty(aArray[nI,nAgeDep]) .or. Empty(aArray[nI,nCtaDep]) )
				lFlag	:=	.t. 
			endif    
		endif    
		if	lDesmarca .and. lFlag
			aArray[nI,nPosFlg]	:=	.f. 
		elseif	lFlag
			Exit
		endif		
	endif
Next nI

if	ValType(oGrid) == "O"
	oGrid:Refresh()
endif

Return ( lFlag )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fAltVcLt(oDlg,oGrid,aArray,nPosIni,nPosFim,lPass,oCombo) 

Local w   
Local xMem
Local oFont
Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1  

Local lOk			:=	.f.
Local lCont			:=	.t.
Local dTGet1		:=	CtoD("")

Private lAltera 	:= 	.t.
 
Default lPass		:=	.f.
Default nPosIni		:=	001
Default nPosFim		:=	Len(aArray)

For w := nPosIni to nPosFim
	if	lPass .or. aArray[w,nPosFlg]
		if	!( aArray[w,nPosStt] $ "1/5" )
			lCont := .f. 
		endif
	endif
Next w 

if	lCont             
	
	Define Font oFont Name "Tahoma" Size 0,-11 Bold
		
	Define Dialog oDlgAlt Title "Informe" From 000,000 To 080,200 Pixel
	oSay1		:= 	tSay():Create(oDlgAlt,{|| "Vencimento :" },08,05,,oFont,,,,.t.,Nil,)
	oTGet1 		:= 	tGet():New(05,50,bSetGet(dTGet1),oDlgAlt,047,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
	oTButton1	:= 	tButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
	Activate Dialog oDlgAlt Centered
		
	if	lOk
		if	Empty(dTGet1)   
			MessageBox("Data nใo preenchida.","Aten็ใo",MB_ICONHAND)
		else
			if	dTGet1 < Date()
				MessageBox("O vencimento nใo pode ser menor que a data do dia.","Aten็ใo",MB_ICONHAND)
			elseif dTGet1 <> DataValida(dTGet1) .and. !GetMv("ZZ_XALTVCP")
				MessageBox("O vencimento real deve ser um dia ๚til.","Aten็ใo",MB_ICONHAND)
			else						
				if	( MessageBox("Confirma altera็ใo ?","Aten็ใo",MB_YESNO) == 6 )	
					For w := nPosIni to nPosFim
						if	lPass .or. aArray[w,nPosFlg]
							SE2->(dbgoto(aArray[w,nPosRec]))
							if	SE2->(FieldPos("E2_ZZAUDIT")) <> 0							      
								xMem := "Vencimento alterado por " + Upper(Alltrim(cUserName)) + " em " + DtoC(Date()) + " as " + Substr(Time(),01,05) + CRLF
								xMem += "De " + DtoC(SE2->E2_VENCREA) + " para " + DtoC(dTGet1) + CRLF 
								xMem += "Pela rotina de Prepara็ใo de Pagamentos" + CRLF 
								xMem += SE2->E2_ZZAUDIT
								if	GetMv("ZZ_XALTVCP")
									RecLock("SE2",.f.)
										SE2->E2_VENCTO	:=	dTGet1 
										SE2->E2_VENCREA	:=	DataValida(dTGet1)        		
										SE2->E2_ZZAUDIT	:= 	xMem
									MsUnlock("SE2")     
								else
									RecLock("SE2",.f.)
										SE2->E2_ZZAUDIT	:= 	xMem
										SE2->E2_VENCREA	:=	dTGet1        		
									MsUnlock("SE2")     
								endif
							else
								if	GetMv("ZZ_XALTVCP")
									RecLock("SE2",.f.)
										SE2->E2_VENCTO	:=	dTGet1 
										SE2->E2_VENCREA	:=	DataValida(dTGet1)        		
									MsUnlock("SE2")     
								else
									RecLock("SE2",.f.)
										SE2->E2_VENCREA	:=	dTGet1        		
									MsUnlock("SE2")     
								endif
							endif
							aArray[w,nPosFlg]						:=	.f.				
							aArray[w,SE2->(FieldPos("E2_VENCREA"))] := 	SE2->E2_VENCREA
						endif
					Next w 
				endif					
			endif					
		endif					
	endif
	oGrid:Refresh()
else	
	MessageBox("Apenas tํtulos liberados podem ter alteradas as datas de vencimento.","Aten็ใo",MB_ICONHAND)
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fGeraBor(oDlg,oGrid,aArray,lJob,xDia)

Local xFunName	:=	FunName()   
Local xDataBase	:=	dDataBase
Local xAtivo	:=	lAtivo

Default lJob	:=	.f.

SetFunName("FINA241")

if	lOracle
	if	lJob
		wGeraBor(Nil,Nil,@aArray,lJob,xDia)
	else
		Processa( { || CursorWait() , wGeraBor(@oDlg,@oGrid,@aArray,lJob,xDia) , CursorArrow() } , "Gerando border๔s ..." )
	endif
else
	if	lJob
		wGeraBor(Nil,Nil,@aArray,lJob,xDia)
	else
		Processa( { || CursorWait() , wGeraBor(@oDlg,@oGrid,@aArray,lJob,xDia) , CursorArrow() } , "Gerando border๔s ..." )
	endif
endif

SetFunName(xFunName)

lAtivo		:=	xAtivo
dDataBase	:=	xDataBase

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function wGeraBor(oDlg,oGrid,aArray,lJob,xDia)

Local s
Local w    
Local t   
Local z
Local nI    
Local xCgc  
Local aRet
Local cDir  
Local nPos
Local xPos
Local xCnt
Local nSld		
Local xDir			:=	""    
Local xCod			:=	""    
Local cCod			:=	""    
Local lOne 			:=	.f.
Local xPix			:=	.t.
Local lBco 			:=	.t.
Local lCod 			:=	.t.
Local lCta 			:=	.t.
Local lStt 			:=	.t.  
Local lDSC			:=	.t.
Local lDSD			:=	.t.
Local lDGP			:=	.t.
Local lBIE			:=	.t.
Local lCont			:=	.t.
Local lTipo			:=	.t.   

Local xArea  		:=	{}    
Local xArray		:=	{}  
Local aNumBor		:=	{}
Local aAglTED		:=	{}
Local xAglTED		:=	{}
Local aBordero		:=	{}
Local cNumBor 		:= 	""
Local cModImp  		:=	""
Local cModPgto 		:=	""
Local cTipoPag		:=	""     

Local sAglTED		:=	Nil
Local xVencRea		:=	Nil

Local aArea			:=	GetArea()   
Local xFilAnt		:=	cFilAnt      
Local cContrato		:= 	CriaVar("E9_NUMERO")
Local aMoedas 		:= 	GetMoedas()
Local lFinVDoc		:=	GetNewPar("MV_FINVDOC","2") == "1"    

Private uDados		:=	{}
Private xRecBor		:=	{}     

Default lJob		:=	.f.

For nI := 1 To Len(aArray)
	if	aArray[nI,nPosFlg] 
		lOne :=	.t.
		if	!( aArray[nI,nPosStt] $ "1/5" )
			lStt 	:= 	.f. 
		elseif	Empty(aArray[nI,nPosBco])
			lBco 	:= 	.f. 
		elseif	Empty(aArray[nI,nTipoPg])
			lTipo 	:= 	.f. 
		elseif	Upper(Alltrim(aArray[nI,nTipoPg])) == "BOLETO"
			if	Empty(aArray[nI,nPosCdB])
				lCod 	:= 	.f. 
			endif
		elseif	Upper(Alltrim(aArray[nI,nTipoPg])) == "TRIBUTO"
			if	Alltrim(aArray[nI,nModImp]) == "13" .and. Empty(aArray[nI,nPosCdB])
				lDSC	:=	.f.
			elseif	Alltrim(aArray[nI,nModImp]) == "16" .and. Empty(aArray[nI,nPosCdB]) .and. ( Empty(aArray[nI,SE2->(FieldPos("E2_CODRET"))]) .or. aArray[nI,SE2->(FieldPos('E2_ZZVLPR'))] <= 0 )
				lDSD	:=	.f.
			elseif	Alltrim(aArray[nI,nModImp]) == "17" .and. Empty(aArray[nI,nPosCdB]) .and. ( Empty(aArray[nI,SE2->(FieldPos("E2_CODINS"))]) .or. aArray[nI,SE2->(FieldPos('E2_ZZVLPR'))] <= 0 )		
				lDGP	:=	.f.
			elseif	Alltrim(aArray[nI,nModImp]) == "18" .and. Empty(aArray[nI,nPosCdB])
				lDSC	:=	.f.
			elseif	Alltrim(aArray[nI,nModImp]) == "19" .and. Empty(aArray[nI,nPosCdB])
				lDSC	:=	.f.
			elseif	Alltrim(aArray[nI,nModImp]) == "22" .and. Empty(aArray[nI,nPosCdB])
				lDSC	:=	.f.
			elseif	Alltrim(aArray[nI,nModImp]) == "25" .and. Empty(aArray[nI,nPosCdB])
				lDSC	:=	.f.
			elseif	Alltrim(aArray[nI,nModImp]) == "27" .and. Empty(aArray[nI,nPosCdB])
				lDSC	:=	.f.
			elseif	Alltrim(aArray[nI,nModImp]) == "35" .and. Empty(aArray[nI,nPosCdB])
				lDSC	:=	.f.    
			elseif	Alltrim(aArray[nI,nModImp]) == "OT" .and. Empty(aArray[nI,nPosCdB])
				lDSC	:=	.f.    
			elseif	Alltrim(aArray[nI,nModImp]) == "MT" .and. Empty(aArray[nI,nPosCdB])
				lDSC	:=	.f.    
			elseif	Alltrim(aArray[nI,nModImp]) == "TC" .and. Empty(aArray[nI,nPosCdB])
				lDSC	:=	.f.    
			elseif	!Empty(aArray[nI,nBcoPag]) .and. !( aArray[nI,nPosBco] $ aArray[nI,nBcoPag] )
				lBIE	:=	.f.
			endif
		elseif	Upper(Alltrim(aArray[nI,nTipoPg])) == "DEPOSITO"
			if	Upper(Alltrim(aArray[nI,nModCrd])) == "PIX" .and. Empty(aArray[nI,nChvPix]) 
				xPix 	:=	.f. 
			elseif	Upper(Alltrim(aArray[nI,nModCrd])) <> "PIX" .and. ( Empty(aArray[nI,nBcoDep]) .or. Empty(aArray[nI,nAgeDep]) .or. Empty(aArray[nI,nCtaDep]) )
				lCta 	:= 	.f. 
			endif    
		endif
	endif
Next nI

if !lOne
	if	lJob
		ConOut("Selecione os tํtulos para gera็ใo do border๔.")
	else
		MessageBox("Selecione os tํtulos para gera็ใo do border๔.","Aten็ใo",MB_ICONHAND)
	endif
elseif !lStt
	if	lJob
		ConOut("Somente tํtulos liberados podem ser marcados para border๔.")
	else
		MessageBox("Somente tํtulos liberados podem ser marcados para border๔.","Aten็ใo",MB_ICONHAND)
	endif
elseif !lBco
	if	lJob
		ConOut("Existem tํtulos com dados faltantes do banco pagador.")
	else
		MessageBox("Existem tํtulos com dados faltantes do banco pagador.","Aten็ใo",MB_ICONHAND)
	endif
elseif !lTipo
	if	lJob
		ConOut("Existem tํtulos com dados faltantes do tipo de pagamento.")
	else
		MessageBox("Existem tํtulos com dados faltantes do tipo de pagamento.","Aten็ใo",MB_ICONHAND)
	endif
elseif !lCod
	if	lJob
		ConOut("Existem tํtulos com tipo de pagamento BOLETO com dados faltantes do C๓digo de Barras.")
	else
		MessageBox("Existem tํtulos com tipo de pagamento BOLETO com dados faltantes do C๓digo de Barras.","Aten็ใo",MB_ICONHAND)
	endif
elseif !lCta
	if	lJob
		ConOut("Existem tํtulos com tipo de pagamento DEPำSITO com dados faltantes da Conta de Dep๓sito.")
	else
		MessageBox("Existem tํtulos com tipo de pagamento DEPำSITO com dados faltantes da Conta de Dep๓sito.","Aten็ใo",MB_ICONHAND)
	endif
elseif !xPix
	if	lJob
		ConOut("Existem tํtulos com tipo de pagamento DEPำSITO via PIX com dados faltantes da Chave PIX.")
	else
		MessageBox("Existem tํtulos com tipo de pagamento DEPำSITO via PIX com dados faltantes da Chave PIX.","Aten็ใo",MB_ICONHAND)
	endif
elseif !lDSC
	if	lJob
		ConOut("Existem impostos sem c๓digo de barras incluํdo.")
	else
		MessageBox("Existem impostos sem c๓digo de barras incluํdo.","Aten็ใo",MB_ICONHAND)
	endif
elseif !lDSD
	if	lJob	
		ConOut("Existem DARFs com dados faltantes para pagamento.")
	else
		MessageBox("Existem DARFs com dados faltantes para pagamento.","Aten็ใo",MB_ICONHAND)
	endif
elseif !lDGP
	if	lJob
		ConOut("Existem GPSs com dados faltantes para pagamento.")
	else
		MessageBox("Existem GPSs com dados faltantes para pagamento.","Aten็ใo",MB_ICONHAND)
	endif
elseif !lBIE
	if	lJob
		ConOut("O banco escolhido para o imposto nใo permite o pagamento.")
	else
		MessageBox("O banco escolhido para o imposto nใo permite o pagamento.","Aten็ใo",MB_ICONHAND)
	endif
else
	if	lJob
		lCont := .t.
	else
		lCont := ( MessageBox("Confirma gera็ใo dos border๔s de pagamento ?","Aten็ใo",MB_YESNO) == 6 )
	endif
endif	
        
if !lOne .or. !lStt .or. !lBco .or. !lTipo .or. !lCod .or. !xPix .or. !lCta .or. !lDSC .or. !lDSD .or. !lDGP .or. !lBIE .or. !lCont
	Return
endif	

For w := 1 to Len(aArray)
	if 	aArray[w,nPosFlg]
	
		aAdd( xArray , aArray[w] )

		xArray[Len(xArray),nTamTot] 	:= 	w
		xArray[Len(xArray),xCodCrd] 	:= 	xArray[Len(xArray),nCodCrd]

		/*
		16 - Pagamento de Tributos DARF
		17 - Pagamento de Tributos GPS
		18 - Pagamento de Tributos DARF SIMPLES   
		19 - Pagamento de IPTU
		21 - Pagamento de Tributos DARJ
		22 - Pagamento de Tributos GARE ICMS SP
		25 - Pagamento de Tributos IPVA (SP e MG)
		27 - Pagamento de Tributos DPVAT     
		28 - GR-PR com Codigo de Barras
		35 - Pagamento de Tributos FGTS - GFIP 
		OT - Outros Tributos Federais com C๓digo de Barras 
		MT - Multas de Transito 
		TC - Outros Tributos com C๓digo de Barras 
		*/

		if !Empty(xArray[Len(xArray),nPosCdB]) 
			if	ExistBlock("XRETMODBOR") .and. !( Alltrim(xArray[Len(xArray),nPosBco]) $ "341" ) 
				xArray[Len(xArray),nCodCrd]	:=	ExecBlock("XRETMODBOR",.f.,.f.,{xArray[Len(xArray),nCodCrd],xArray[Len(xArray),nPosBco]})
			elseif	xArray[Len(xArray),nCodCrd] $ "35" .and. !( Alltrim(xArray[Len(xArray),nPosBco]) $ "341" ) 
				xArray[Len(xArray),nCodCrd]	:=	"13" 
			elseif xArray[Len(xArray),nCodCrd] $ "16/17/18/19/21/22/25/27/28/OT/MT/TC"
				xArray[Len(xArray),nCodCrd]	:=	"13" 
			endif	
		endif	
	endif	
Next w 

if	lFilCen
	xArray := aSort( xArray ,,, { |x,y|	x[nFilCen] + x[nPosBco] + x[nPosAge] + x[nPosCon] + x[nCodCrd] + x[nLogRet] + x[nTipTit] + x[xModBor] + x[nModImp] < ;
										y[nFilCen] + y[nPosBco] + y[nPosAge] + y[nPosCon] + y[nCodCrd] + y[nLogRet] + y[nTipTit] + y[xModBor] + y[nModImp] } )
elseif	lIncFil
	xArray := aSort( xArray ,,, { |x,y|	x[SE2->(FieldPos("E2_FILIAL"))] + x[nPosBco] + x[nPosAge] + x[nPosCon] + x[nCodCrd] + x[nLogRet] + x[nTipTit] + x[xModBor] + x[nModImp] < ;
										y[SE2->(FieldPos("E2_FILIAL"))] + y[nPosBco] + y[nPosAge] + y[nPosCon] + y[nCodCrd] + y[nLogRet] + y[nTipTit] + y[xModBor] + y[nModImp] } )
else	
	xArray := aSort( xArray ,,, { |x,y|	x[nPosBco] + x[nPosAge] + x[nPosCon] + x[nCodCrd] + x[nLogRet] + x[nTipTit] + x[xModBor] + x[nModImp] < ;
										y[nPosBco] + y[nPosAge] + y[nPosCon] + y[nCodCrd] + y[nLogRet] + y[nTipTit] + y[xModBor] + y[nModImp] } )
endif

if !lJob									
	ProcRegua(Len(xArray))
endif

For nI := 1 To Len(xArray)     

	SE2->(dbgoto(xArray[nI,nPosRec]))   

	if	lJob									
		fChecaId()	 
	else
		FwMsgRun( Nil , { || fChecaId() } , 'Processando' , "Buscando Identificador do tํtulo ..." )
	endif
	
	if	lFilCen
		xCod 	:=	xArray[nI,nFilCen] 							+ ;
					xArray[nI,nPosBco] 							+ ;
					xArray[nI,nPosAge] 							+ ;
					xArray[nI,nPosCon] 							+ ;
					xArray[nI,nCodCrd] 							+ ;
					xArray[nI,nLogRet] 							+ ;
					xArray[nI,nTipTit] 							+ ;
					xArray[nI,xModBor] 							+ ;
					xArray[nI,nModImp]
	elseif	lIncFil
		xCod 	:=	xArray[nI,SE2->(FieldPos("E2_FILIAL"))] 	+ ;
					xArray[nI,nPosBco] 							+ ;
					xArray[nI,nPosAge] 							+ ;
					xArray[nI,nPosCon] 							+ ;
					xArray[nI,nCodCrd] 							+ ;
					xArray[nI,nLogRet] 							+ ;
					xArray[nI,nTipTit] 							+ ;
					xArray[nI,xModBor] 							+ ;
					xArray[nI,nModImp]
	else	
		xCod 	:=	xArray[nI,nPosBco] 							+ ;
					xArray[nI,nPosAge] 							+ ;
					xArray[nI,nPosCon] 							+ ;
					xArray[nI,nCodCrd] 							+ ;
					xArray[nI,nLogRet] 							+ ;
					xArray[nI,nTipTit] 							+ ;
					xArray[nI,xModBor] 							+ ;
					xArray[nI,nModImp]
	endif
	
	if	xCod <> cCod

		if	Len(xRecBor) <> 0

			For s := 1 to Len(xRecBor)		
				SE2->(dbgoto(xRecBor[s,02]))    
				For t := 1 to Len(aFiliais)

					if !Empty(aFiliais[t])
						cFilAnt := aFiliais[t]
					endif
			
					cQuery	:=	" Select R_E_C_N_O_ as RECNOSEA "
					cQuery	+=	" From " + RetSqlName("SEA")
					cQuery	+=	" Where EA_FILIAL   = '" + xFilial("SEA",aFiliais[t])	+ "' and "
					cQuery	+=		"   EA_PREFIXO  = '" + SE2->E2_PREFIXO				+ "' and "
					cQuery	+=		"   EA_NUM      = '" + SE2->E2_NUM					+ "' and "
					cQuery	+=		"   EA_PARCELA  = '" + SE2->E2_PARCELA				+ "' and "
					cQuery	+=		"   EA_TIPO     = '" + SE2->E2_TIPO					+ "' and "
					cQuery	+=		"   EA_FORNECE  = '" + SE2->E2_FORNECE				+ "' and "
					cQuery	+=		"   EA_LOJA	    = '" + SE2->E2_LOJA					+ "' and "
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
			Next s

			if 	FwModeAccess("SE2") == "E" .or. !Empty(xRecBor[01,01]) 
				cFilAnt := xRecBor[01,01]
			elseif	FwModeAccess("SA2") == "E" .or. FwModeAccess("SA6") == "E"
				cFilAnt := xRecBor[01,10]
			endif

			if	xPriVez                          
				/*
				do while xPriVez
					xPriVez := !Pergunte("F240BR",.t.)
				enddo
				*/
			endif

			if 	GetVersao(.f.) >= "12"
				if	lFadel .and. ExistBlock("XFINA241",.f.,.f.)     
					Pergunte("F240BR",.f.)
					U_xFinA241(2,Nil,.t.) 
				else
					FinA241(2,Nil,.t.) 
				endif
			else
				FinA241(2,.t.) 
			endif
			
			if 	FwModeAccess("SE2") == "E" .or. !Empty(xRecBor[01,01]) 
				cFilAnt := xRecBor[01,01]
			elseif	FwModeAccess("SA2") == "E" .or. FwModeAccess("SA6") == "E"
				cFilAnt := xRecBor[01,10]
			endif

			For t := 1 to Len(xRecBor)		
			
				SE2->(dbgoto(xRecBor[t,02]))     
				
				if	Upper(Alltrim(SE2->E2_NUMBOR)) == Upper(Alltrim(xRecBor[t,04]))   
				
					aArray[xRecBor[t,03],nPosFlg]						:=	.f.
					aArray[xRecBor[t,03],nPosStt]						:=	"4"  
					aArray[xRecBor[t,03],nRecSEA] 						:=	000
					aArray[xRecBor[t,03],SE2->(FieldPos("E2_NUMBOR"))]	:=	xRecBor[t,04]    
					
					For z := 1 to Len(aFiliais)
			
						SE2->(dbgoto(xRecBor[t,02]))    

						cQuery	:=	" Select R_E_C_N_O_ as RECNOSEA "
						cQuery	+=	" From " + RetSqlName("SEA")
						cQuery	+=	" Where EA_FILIAL   = '" + xFilial("SEA",aFiliais[z])	+ "' and "
						cQuery	+=		"   EA_PREFIXO  = '" + SE2->E2_PREFIXO				+ "' and "
						cQuery	+=		"   EA_NUM      = '" + SE2->E2_NUM					+ "' and "
						cQuery	+=		"   EA_PARCELA  = '" + SE2->E2_PARCELA				+ "' and "
						cQuery	+=		"   EA_TIPO     = '" + SE2->E2_TIPO					+ "' and "
						cQuery	+=		"   EA_FORNECE  = '" + SE2->E2_FORNECE				+ "' and "
						cQuery	+=		"   EA_LOJA	    = '" + SE2->E2_LOJA					+ "' and "
						cQuery 	+=		"   D_E_L_E_T_  = ' '                                        "
						
						TcQuery ChangeQuery(@cQuery) New Alias "XQRY"        	
						
						do while XQRY->(!Eof())
							SEA->(dbgoto(XQRY->RECNOSEA))
							aArray[xRecBor[t,03],nRecSEA] := SEA->(Recno())
							XQRY->(dbskip())	
						enddo
					
						XQRY->(dbclosearea())     

						if	aArray[xRecBor[t,03],nRecSEA] <> 0
							Exit
						endif
					
					Next z 	 	 
	
					SE2->(dbgoto(xRecBor[t,02]))     

					nSld := Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)

					if	lAtivo  
						if	lCCL .or. lCheck .or. lMastra 
							Z43->(dbsetorder(1))        
							if	Z43->(MsSeek( xFilial("Z43") + xRecBor[t,06] + xRecBor[t,07] + xRecBor[t,08] + xRecBor[t,04] , .f. ))
						    	RecLock("Z43",.f.)
									Z43->Z43_QTDE	+=	1
									Z43->Z43_VALOR	+=	nSld
								MsUnlock("Z43")
							else
						    	RecLock("Z43",.t.)
									Z43->Z43_FILIAL	:=	xFilial("Z43")
									Z43->Z43_NUMBOR	:=	xRecBor[t,04]
									Z43->Z43_BANCO	:=	xRecBor[t,06]
									Z43->Z43_AGENC	:=	xRecBor[t,07]
									Z43->Z43_CONTA	:=	xRecBor[t,08]
									Z43->Z43_MODELO	:=	xRecBor[t,09]
									Z43->Z43_USCBOR	:=	iif( lJob , "JOB" 	, RetCodUsr() 						)
									Z43->Z43_USDBOR	:=	iif( lJob , "JOB" 	, cUserName 						)
									Z43->Z43_EMLBOR	:=	iif( lJob , "" 		, Alltrim(UsrRetMail(RetCodUsr())) 	)
									Z43->Z43_GERAAR	:=	"S"
									Z43->Z43_QTDE	:=	1
									Z43->Z43_VALOR	:=	nSld
								MsUnlock("Z43")
						    	RecLock("Z44",.t.)
									Z44->Z44_FILIAL	:=	xFilial("Z44")
									Z44->Z44_NUMBOR	:=	xRecBor[t,04]
									Z44->Z44_DATBOR	:=	iif( lJob , xDia , dDataBase )
									Z44->Z44_DATGER	:=	Date()
									Z44->Z44_HORGER	:=	Substr(Time(),01,05)
									Z44->Z44_BANCO	:=	xRecBor[t,06]
									Z44->Z44_AGENC	:=	xRecBor[t,07]
									Z44->Z44_CONTA	:=	xRecBor[t,08]
									Z44->Z44_EMPBOR	:=	cEmpAnt
									Z44->Z44_FILBOR	:=	cFilAnt
									Z44->Z44_TABSE2	:=	RetSqlName("SE2")
									Z44->Z44_FILSE2	:=	xFilial("SE2")
									Z44->Z44_TABSEA	:=	RetSqlName("SEA")
									Z44->Z44_FILSEA	:=	xFilial("SEA")
									Z44->Z44_TABSA6	:=	RetSqlName("SA6")
									Z44->Z44_FILSA6	:=	xFilial("SA6")
									Z44->Z44_TABZ43	:=	RetSqlName("Z43")
									Z44->Z44_FILZ43	:=	xFilial("Z43")
									Z44->Z44_TABSE8	:=	RetSqlName("SE8")
									Z44->Z44_FILSE8	:=	xFilial("SE8")
									Z44->Z44_TABSA2	:=	RetSqlName("SA2")
									Z44->Z44_FILSA2	:=	xFilial("SA2")
								MsUnlock("Z44")
							endif
						else
							ZAT->(dbsetorder(1))        
							if	ZAT->(MsSeek( xFilial("ZAT") + xRecBor[t,06] + xRecBor[t,07] + xRecBor[t,08] + xRecBor[t,04] , .f. ))
						    	RecLock("ZAT",.f.)
									ZAT->ZAT_QTDE	+=	1
									ZAT->ZAT_VALOR	+=	nSld
								MsUnlock("ZAT")
							else
						    	RecLock("ZAT",.t.)
									ZAT->ZAT_FILIAL	:=	xFilial("ZAT")
									ZAT->ZAT_NUMBOR	:=	xRecBor[t,04]
									ZAT->ZAT_BANCO	:=	xRecBor[t,06]
									ZAT->ZAT_AGENC	:=	xRecBor[t,07]
									ZAT->ZAT_CONTA	:=	xRecBor[t,08]
									ZAT->ZAT_MODELO	:=	xRecBor[t,09]
									ZAT->ZAT_USCBOR	:=	iif( lJob , "JOB" 	, RetCodUsr() 						)
									ZAT->ZAT_USDBOR	:=	iif( lJob , "JOB" 	, cUserName 						)
									ZAT->ZAT_EMLBOR	:=	iif( lJob , "" 		, Alltrim(UsrRetMail(RetCodUsr())) 	)
									ZAT->ZAT_GERAAR	:=	"S"
									ZAT->ZAT_QTDE	:=	1
									ZAT->ZAT_VALOR	:=	nSld
								MsUnlock("ZAT")
						    	RecLock("ZAV",.t.)
									ZAV->ZAV_FILIAL	:=	xFilial("ZAV")
									ZAV->ZAV_NUMBOR	:=	xRecBor[t,04]
									ZAV->ZAV_DATBOR	:=	iif( lJob , xDia , dDataBase )
									ZAV->ZAV_DATGER	:=	Date()
									ZAV->ZAV_HORGER	:=	Substr(Time(),01,05)
									ZAV->ZAV_BANCO	:=	xRecBor[t,06]
									ZAV->ZAV_AGENC	:=	xRecBor[t,07]
									ZAV->ZAV_CONTA	:=	xRecBor[t,08]
									ZAV->ZAV_EMPBOR	:=	cEmpAnt
									ZAV->ZAV_FILBOR	:=	cFilAnt
									ZAV->ZAV_TABSE2	:=	RetSqlName("SE2")
									ZAV->ZAV_FILSE2	:=	xFilial("SE2")
									ZAV->ZAV_TABSEA	:=	RetSqlName("SEA")
									ZAV->ZAV_FILSEA	:=	xFilial("SEA")
									ZAV->ZAV_TABSA6	:=	RetSqlName("SA6")
									ZAV->ZAV_FILSA6	:=	xFilial("SA6")
									ZAV->ZAV_TABZAT	:=	RetSqlName("ZAT")
									ZAV->ZAV_FILZAT	:=	xFilial("ZAT")
									ZAV->ZAV_TABSE8	:=	RetSqlName("SE8")
									ZAV->ZAV_FILSE8	:=	xFilial("SE8")
									ZAV->ZAV_TABSA2	:=	RetSqlName("SA2")
									ZAV->ZAV_FILSA2	:=	xFilial("SA2")
								MsUnlock("ZAV")
							endif
						endif
					endif 
					
				endif
			Next t
		endif
	
		uDados	:=	{}
		xRecBor	:=	{}

		if	lFilCen
			cCod 	:=	xArray[nI,nFilCen] 							+ ;		// Filial Centralizadora
		  				xArray[nI,nPosBco] 							+ ;		// Banco
		  				xArray[nI,nPosAge] 							+ ;		// Agencia
		  				xArray[nI,nPosCon] 							+ ;		// Conta 
		  				xArray[nI,nCodCrd] 							+ ; 	// Tipo do Bordero
		  				xArray[nI,nLogRet] 							+ ;		// Se tem Reten็ใo de PCC
		  				xArray[nI,nTipTit] 							+ ;		// Se ้ PA ou nใo
		  				xArray[nI,xModBor] 							+ ;		// Se ้ de imposto ou nใo
		  				xArray[nI,nModImp]									// Tipo do imposto
		elseif	lIncFil
		  	cCod 	:=	xArray[nI,SE2->(FieldPos("E2_FILIAL"))] 	+ ;		// Filial
		  				xArray[nI,nPosBco] 							+ ;		// Banco
		  				xArray[nI,nPosAge] 							+ ;		// Agencia
		  				xArray[nI,nPosCon] 							+ ;		// Conta 
		  				xArray[nI,nCodCrd] 							+ ; 	// Tipo do Bordero
		  				xArray[nI,nLogRet] 							+ ;		// Se tem Reten็ใo de PCC
		  				xArray[nI,nTipTit] 							+ ;		// Se ้ PA ou nใo
		  				xArray[nI,xModBor] 							+ ;		// Se ้ de imposto ou nใo
		  				xArray[nI,nModImp]									// Tipo do imposto
		else	
		  	cCod 	:= 	xArray[nI,nPosBco] 							+ ;		// Banco
		  				xArray[nI,nPosAge] 							+ ;		// Agencia
		  				xArray[nI,nPosCon] 							+ ;		// Conta 
		  				xArray[nI,nCodCrd] 							+ ; 	// Tipo do Bordero
		  				xArray[nI,nLogRet] 							+ ;		// Se tem Reten็ใo de PCC
		  				xArray[nI,nTipTit] 							+ ;		// Se ้ PA ou nใo
		  				xArray[nI,xModBor] 							+ ;		// Se ้ de imposto ou nใo
		  				xArray[nI,nModImp]									// Tipo do imposto
		endif 
			
		if	GetMv("ZZ_AJUBOR") == "S"
			cNumBor	:=	StrZero(1,Len(SE2->E2_NUMBOR))
		else
        	cNumBor	:=	StrZero(Val(GetMv("ZZ_NUMBOR")) + 1,Len(SE2->E2_NUMBOR))
		endif

		SEA->(dbsetorder(2))    
		
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
		PutMv("ZZ_AJUBOR","N")

		if	lFadel
			if	lFilCen
				if	aScan( aBordero , { |x| x[01] == xArray[nI,nFilCen] .and. x[02] == cNumBor } ) == 0
					aAdd( aBordero , { xArray[nI,nFilCen] , cNumBor } )
				endif                                                        
			else
				if	aScan( aBordero , { |x| x[01] == cFilAnt .and. x[02] == cNumBor } ) == 0
					aAdd( aBordero , { cFilAnt , cNumBor } )
				endif                                                        
			endif                                                        
		endif

		cModImp 	:=	xArray[nI,nModImp] 
		cModPgto	:=	xArray[nI,nCodCrd] 
		cTipoPag	:=	"20"

		/*
		13 - Pagamento a Concessionarias
		16 - Pagamento de Tributos DARF
		17 - Pagamento de Tributos GPS
		18 - Pagamento de Tributos DARF SIMPLES   
		19 - Pagamento de IPTU
		21 - Pagamento de Tributos DARJ
		22 - Pagamento de Tributos GARE ICMS SP
		25 - Pagamento de Tributos IPVA (SP e MG)
		27 - Pagamento de Tributos DPVAT     
		28 - GR-PR com Codigo de Barras
		29 - GR-PR sem Codigo de Barras
		35 - Pagamento de Tributos FGTS - GFIP 
		OT - Outros Tributos Federais com C๓digo de Barras
		TC - Outros Tributos com C๓digo de Barras
		MT - Multas de Transito
		*/

		if	cModPgto $ "16/17/18/19/21/22/25/27/28/29/35/OT/TC/MT"
			cTipoPag :=	"22"
		endif

		if	xArray[nI,nPosBco] == "001"
			if	cModImp $ "13/16/17/18/19/21/22/25/27/28/29/35/OT/TC/MT"
				cTipoPag 	:=	"98"
			endif
		endif

	endif		

	if	Len(uDados) == 0 
		aAdd( uDados , cNumBor				)		// cNumBor
		aAdd( uDados , StoD('20000101')		)		// dVenIni240
		aAdd( uDados , StoD('20451231')		)		// dVenFim240
		aAdd( uDados , 0      				)		// nLimite
		aAdd( uDados , xArray[nI,nPosBco]	)		// cPort240
		aAdd( uDados , xArray[nI,nPosAge]	)		// cAgen240
		aAdd( uDados , xArray[nI,nPosCon]	)		// cConta240
		aAdd( uDados , cContrato			)		// cContrato
		aAdd( uDados , aMoedas[1]			)		// cMoeda240
		aAdd( uDados , aMoedas				)		// aMoedas
		aAdd( uDados , cModPgto				)		// cModPgto
		aAdd( uDados , cTipoPag				)		// cTipoPag
		aAdd( uDados , 1    				)		// nOpc
		aAdd( uDados , dDataBase			)		// dDataBord
	endif

	if !lJob
		IncProc("Border๔ " + cNumBor)
	endif
	
	SA2->(dbgoto(xArray[nI,nRecSA2]))    
	SE2->(dbgoto(xArray[nI,nPosRec]))    

	if 	FwModeAccess("SE2") == "E" .or. !Empty(SE2->E2_FILIAL)
		cFilAnt := SE2->E2_FILIAL
	else
		cFilAnt := SE2->E2_FILORIG
	endif

	RecLock("SE2",.f.)  
	iif( SE2->(FieldPos("E2_FORBCO"))  <> 0 , SE2->E2_FORBCO	:=	xArray[nI,nBcoDep] , Nil )
	iif( SE2->(FieldPos("E2_FORAGE"))  <> 0 , SE2->E2_FORAGE	:=	xArray[nI,nAgeDep] , Nil )
	iif( SE2->(FieldPos("E2_FAGEDV"))  <> 0 , SE2->E2_FAGEDV	:=	xArray[nI,nDigAge] , Nil )
	iif( SE2->(FieldPos("E2_FORCTA"))  <> 0 , SE2->E2_FORCTA	:=	xArray[nI,nCtaDep] , Nil )
	iif( SE2->(FieldPos("E2_FCTADV"))  <> 0 , SE2->E2_FCTADV	:=	xArray[nI,nDigCta] , Nil )
	iif( SE2->(FieldPos("E2_FORMPAG")) <> 0 , SE2->E2_FORMPAG	:=	xArray[nI,nFormPg] , Nil )
	MsUnlock("SE2")

	// 01 - Credito em conta corrente
	// 03 - Doc C 
	// 05 - Credito em conta poupanca
	// 06 - Credito em conta corrente mesma titularidade
	// 07 - Doc D
	// 41 - TED - Outro Titular
	// 43 - TED - Mesmo Titular
	// 45 - PIX

	lAglFor		:=	xArray[nI,nAglFor]    
	xVencRea	:= 	xArray[nI,SE2->(FieldPos("E2_VENCREA"))]

	if	lAglTED	
		if	lAglFor	
			if	cModPgto $ "01/03/05/06/07/41/43/45" 
				xCgc := iif( Len(Alltrim(SA2->A2_CGC)) == 14 , Substr(SA2->A2_CGC,01,08) , Alltrim(SA2->A2_CGC) )
				xPos := aScan( aAglTED , { 	|x| x[01] == cFilAnt				.and.	;
												x[02] == cModPgto 				.and.	;
												x[03] == xArray[nI,nBcoDep] 	.and. 	;  
												x[04] == xArray[nI,nAgeDep] 	.and. 	;	
												x[05] == xArray[nI,nCtaDep] 	.and. 	;
												x[09] == xCgc					.and. 	;
												x[10] == xVencRea					  	} )
				if	xPos == 0
					aAdd( aAglTED , { cFilAnt 		, cModPgto 		 , xArray[nI,nBcoDep] , xArray[nI,nAgeDep] , xArray[nI,nCtaDep] , 1 , 0 , SE2->(Recno()) , xCgc , xVencRea } )
					aAdd( xAglTED , { Len(aAglTED)	, SE2->(Recno()) } )
				else	
					aAdd( xAglTED , { xPos 			, SE2->(Recno()) } )
					aAglTED[xPos,06] +=	1 
				endif
			endif
		endif
	endif
	
	if	lFilCen
		nPos := aScan( aNumBor , { |x| 	x[01] == xArray[nI,nPosBco] .and. ;  
										x[02] == xArray[nI,nPosAge] .and. ;
										x[03] == xArray[nI,nPosCon] .and. ; 
										x[04] == xArray[nI,nFilCen]	.and. ;
										x[05] == cNumBor 			} )
		
		if	nPos == 0
			aAdd( aNumBor , { xArray[nI,nPosBco] , xArray[nI,nPosAge] , xArray[nI,nPosCon] , xArray[nI,nFilCen] , cNumBor , cFilAnt , "" , .f. } )		  
		endif
	else
		nPos := aScan( aNumBor , { |x| 	x[01] == xArray[nI,nPosBco] .and. ;  
										x[02] == xArray[nI,nPosAge] .and. ;
										x[03] == xArray[nI,nPosCon] .and. ; 
										x[04] == xFilial("SEA") 	.and. ;
										x[05] == cNumBor 			} )
		
		if	nPos == 0
			aAdd( aNumBor , { xArray[nI,nPosBco] , xArray[nI,nPosAge] , xArray[nI,nPosCon] , xFilial("SEA") , cNumBor , cFilAnt , "" , .f. } )		  
		endif
	endif

	if	xArray[nI,nLogRet] == "1"
		aAdd( xRecBor , {	xArray[nI,SE2->(FieldPos("E2_FILIAL"))] 	, ;		// 01
							xArray[nI,nPosRec] 							, ;		// 02
							xArray[nI,nTamTot] 							, ;		// 03
							cNumBor 									, ;		// 04
							xArray[nI,nTipTit] 							, ;		// 05
							xArray[nI,nPosBco] 							, ;		// 06
							xArray[nI,nPosAge] 							, ;		// 07
							xArray[nI,nPosCon] 							, ;		// 08
							xArray[nI,nCodCrd] 							, ; 	// 09
							xArray[nI,SE2->(FieldPos("E2_FILORIG"))]	} ) 	// 10 
	else
	
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

		RecLock("SEA",.t.)
			SEA->EA_FILIAL 		:= 	iif( lFilCen , xArray[nI,nFilCen] , xFilial("SEA") )
			SEA->EA_PORTADO 	:= 	xArray[nI,nPosBco]
			SEA->EA_AGEDEP  	:= 	xArray[nI,nPosAge]
			SEA->EA_NUMCON  	:= 	xArray[nI,nPosCon]
			SEA->EA_NUMBOR  	:= 	cNumBor
			SEA->EA_DATABOR 	:=	Date()			
			SEA->EA_PREFIXO 	:= 	SE2->E2_PREFIXO
			SEA->EA_NUM     	:= 	SE2->E2_NUM
			SEA->EA_PARCELA 	:= 	SE2->E2_PARCELA
			SEA->EA_TIPO    	:= 	SE2->E2_TIPO
			SEA->EA_FORNECE 	:= 	SE2->E2_FORNECE
			SEA->EA_LOJA		:= 	SE2->E2_LOJA
			SEA->EA_CART    	:= 	"P"
			SEA->EA_TIPOPAG 	:= 	cTipoPag
			SEA->EA_MODELO  	:= 	cModPgto
			SEA->EA_FILORIG 	:= 	SE2->E2_FILORIG   
			SEA->EA_ORIGEM		:=	"FINA240"
			if	SEA->(FieldPos("EA_VERSAO")) <> 0
				SEA->EA_VERSAO	:= 	"0001"
			endif
		MsUnlock("SEA")     
		
		if 	GetVersao(.f.) >= "12"
			FkCommit()	
		endif
						
		RecLock("SE2",.f.)
			SE2->E2_NUMBOR		:= 	cNumBor
			SE2->E2_PORTADO		:= 	xArray[nI,nPosBco]   
			SE2->E2_CODBAR 		:= 	xArray[nI,nPosCdB]              
			if	SE2->(FieldPos("E2_CBARRA")) <> 0 
				SE2->E2_CBARRA	:=	xArray[nI,nPosCdB]              
			endif               
			if	SE2->(FieldPos("E2_ZZLINDG")) <> 0 
				SE2->E2_ZZLINDG	:=	StrTran(StrTran(xArray[nI,nPosLnD],".","")," ","")
			endif
			if	SE2->(FieldPos("E2_LINDIGT")) <> 0 
				SE2->E2_LINDIGT	:= 	StrTran(StrTran(xArray[nI,nPosLnD],".","")," ","")
			endif
			if	SE2->(FieldPos("E2_LINDIG")) <> 0 
				SE2->E2_LINDIG	:= 	StrTran(StrTran(xArray[nI,nPosLnD],".","")," ","")
			endif
			if	SE2->(FieldPos("E2_DTBORDE")) <> 0 
				SE2->E2_DTBORDE	:=	Date()
			endif			
		MsUnlock("SE2")

		if 	GetVersao(.f.) >= "12"

			FkCommit()	
			
			xArea := SaveArea1({"SEA","SE2"})
	
			if 	lFinVDoc
				CN062ValDocs("06",.f.,.t.)
			endif
	
			if 	Select("__SE2") <= 0
			   	ChkFile("SE2",.f.,"__SE2")
			endif
		 	
		 	dbselectarea("__SE2")
	
			__SE2->(dbSetOrder(1))
			__SE2->(MsSeek( xFilial("SE2") + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA) , .f. ))   
			
			do while !Eof() .and. 	__SE2->E2_FILIAL  == xFilial("SE2") 	.and. ;
									__SE2->E2_PREFIXO == SE2->E2_PREFIXO 	.and. ;
									__SE2->E2_NUM     == SE2->E2_NUM 		.and. ;
									__SE2->E2_PARCELA == SE2->E2_PARCELA
				if 	__SE2->E2_TIPO $ MVABATIM .and. __SE2->E2_FORNECE == SE2->E2_FORNECE
					RecLock("__SE2")
						Replace E2_NUMBOR  With cNumBor
						Replace E2_PORTADO With xArray[nI,nPosBco]
					MsUnlock("__SE2")
					FkCommit()
				endif
				dbSkip()
			enddo
	
			RestArea1(xArea)
		endif
	
		nSld := Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)
	
		if	lAtivo  
			if	lCCL .or. lCheck .or. lMastra 
				Z43->(dbsetorder(1))
				if	Z43->(MsSeek( xFilial("Z43") + SEA->(EA_PORTADO + EA_AGEDEP + EA_NUMCON + EA_NUMBOR) , .f. ))
			    	RecLock("Z43",.f.)
						Z43->Z43_QTDE	+=	1
						Z43->Z43_VALOR	+=	nSld
					MsUnlock("Z43")
				else
			    	RecLock("Z43",.t.)
						Z43->Z43_FILIAL	:=	xFilial("Z43")
						Z43->Z43_NUMBOR	:=	SEA->EA_NUMBOR
						Z43->Z43_BANCO	:=	SEA->EA_PORTADO
						Z43->Z43_AGENC	:=	SEA->EA_AGEDEP
						Z43->Z43_CONTA	:=	SEA->EA_NUMCON
						Z43->Z43_MODELO	:=	SEA->EA_MODELO
						Z43->Z43_USCBOR	:=	iif( lJob , "JOB" 	, RetCodUsr() 						)
						Z43->Z43_USDBOR	:=	iif( lJob , "JOB" 	, cUserName 						)
						Z43->Z43_EMLBOR	:=	iif( lJob , "" 		, Alltrim(UsrRetMail(RetCodUsr())) 	)
						Z43->Z43_GERAAR	:=	"S"
						Z43->Z43_QTDE	:=	1
						Z43->Z43_VALOR	:=	nSld
					MsUnlock("Z43")
			    	RecLock("Z44",.t.)
						Z44->Z44_FILIAL	:=	xFilial("Z44")
						Z44->Z44_NUMBOR	:=	SEA->EA_NUMBOR
						Z44->Z44_DATBOR	:=	iif( lJob , xDia , dDataBase )
						Z44->Z44_DATGER	:=	Date()
						Z44->Z44_HORGER	:=	Substr(Time(),01,05)
						Z44->Z44_BANCO	:=	SEA->EA_PORTADO
						Z44->Z44_AGENC	:=	SEA->EA_AGEDEP
						Z44->Z44_CONTA	:=	SEA->EA_NUMCON
						Z44->Z44_EMPBOR	:=	cEmpAnt
						Z44->Z44_FILBOR	:=	cFilAnt
						Z44->Z44_TABSE2	:=	RetSqlName("SE2")
						Z44->Z44_FILSE2	:=	xFilial("SE2")
						Z44->Z44_TABSEA	:=	RetSqlName("SEA")
						Z44->Z44_FILSEA	:=	xFilial("SEA")
						Z44->Z44_TABSA6	:=	RetSqlName("SA6")
						Z44->Z44_FILSA6	:=	xFilial("SA6")
						Z44->Z44_TABZ43	:=	RetSqlName("Z43")
						Z44->Z44_FILZ43	:=	xFilial("Z43")
						Z44->Z44_TABSE8	:=	RetSqlName("SE8")
						Z44->Z44_FILSE8	:=	xFilial("SE8")
						Z44->Z44_TABSA2	:=	RetSqlName("SA2")
						Z44->Z44_FILSA2	:=	xFilial("SA2")
					MsUnlock("Z44")
				endif
			else
				ZAT->(dbsetorder(1))
				if	ZAT->(MsSeek( xFilial("ZAT") + SEA->(EA_PORTADO + EA_AGEDEP + EA_NUMCON + EA_NUMBOR) , .f. ))
			    	RecLock("ZAT",.f.)
						ZAT->ZAT_QTDE	+=	1
						ZAT->ZAT_VALOR	+=	nSld
					MsUnlock("ZAT")
				else
			    	RecLock("ZAT",.t.)
						ZAT->ZAT_FILIAL	:=	xFilial("ZAT")
						ZAT->ZAT_NUMBOR	:=	SEA->EA_NUMBOR
						ZAT->ZAT_BANCO	:=	SEA->EA_PORTADO
						ZAT->ZAT_AGENC	:=	SEA->EA_AGEDEP
						ZAT->ZAT_CONTA	:=	SEA->EA_NUMCON
						ZAT->ZAT_MODELO	:=	SEA->EA_MODELO
						ZAT->ZAT_USCBOR	:=	iif( lJob , "JOB" 	, RetCodUsr() 						)
						ZAT->ZAT_USDBOR	:=	iif( lJob , "JOB" 	, cUserName 						)
						ZAT->ZAT_EMLBOR	:=	iif( lJob , "" 		, Alltrim(UsrRetMail(RetCodUsr())) 	)
						ZAT->ZAT_GERAAR	:=	"S"
						ZAT->ZAT_QTDE	:=	1
						ZAT->ZAT_VALOR	:=	nSld
					MsUnlock("ZAT")
			    	RecLock("ZAV",.t.)
						ZAV->ZAV_FILIAL	:=	xFilial("ZAV")
						ZAV->ZAV_NUMBOR	:=	SEA->EA_NUMBOR
						ZAV->ZAV_DATBOR	:=	iif( lJob , xDia , dDataBase )
						ZAV->ZAV_DATGER	:=	Date()
						ZAV->ZAV_HORGER	:=	Substr(Time(),01,05)
						ZAV->ZAV_BANCO	:=	SEA->EA_PORTADO
						ZAV->ZAV_AGENC	:=	SEA->EA_AGEDEP
						ZAV->ZAV_CONTA	:=	SEA->EA_NUMCON
						ZAV->ZAV_EMPBOR	:=	cEmpAnt
						ZAV->ZAV_FILBOR	:=	cFilAnt
						ZAV->ZAV_TABSE2	:=	RetSqlName("SE2")
						ZAV->ZAV_FILSE2	:=	xFilial("SE2")
						ZAV->ZAV_TABSEA	:=	RetSqlName("SEA")
						ZAV->ZAV_FILSEA	:=	xFilial("SEA")
						ZAV->ZAV_TABSA6	:=	RetSqlName("SA6")
						ZAV->ZAV_FILSA6	:=	xFilial("SA6")
						ZAV->ZAV_TABZAT	:=	RetSqlName("ZAT")
						ZAV->ZAV_FILZAT	:=	xFilial("ZAT")
						ZAV->ZAV_TABSE8	:=	RetSqlName("SE8")
						ZAV->ZAV_FILSE8	:=	xFilial("SE8")
						ZAV->ZAV_TABSA2	:=	RetSqlName("SA2")
						ZAV->ZAV_FILSA2	:=	xFilial("SA2")
					MsUnlock("ZAV")
				endif
			endif
		endif

		aArray[xArray[nI,nTamTot],nPosFlg]						:=	.f.
		aArray[xArray[nI,nTamTot],nPosStt]						:=	"4"
		aArray[xArray[nI,nTamTot],nRecSEA]						:=	SEA->(Recno())
		aArray[xArray[nI,nTamTot],SE2->(FieldPos("E2_NUMBOR"))]	:=	cNumBor    
	
	endif
	
	cFilAnt	:= 	xFilAnt

Next nI        

cFilAnt	:= 	xFilAnt

if	Len(xRecBor) <> 0

	For s := 1 to Len(xRecBor)		
		SE2->(dbgoto(xRecBor[s,02]))    
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
	Next s

	if 	FwModeAccess("SE2") == "E" .or. !Empty(xRecBor[01,01]) 
		cFilAnt := xRecBor[01,01]
	elseif	FwModeAccess("SA2") == "E" .or. FwModeAccess("SA6") == "E"
		cFilAnt := xRecBor[01,10]
	endif

	if	xPriVez
		/*
		do while xPriVez
			xPriVez := !Pergunte("F240BR",.t.)
		enddo
		*/
	endif

	if 	Substr(GetVersao(.f.),01,02) >= "12"
		if	lFadel .and. ExistBlock("XFINA241",.f.,.f.)  
			Pergunte("F240BR",.f.)
			U_xFinA241(2,Nil,.t.) 
		else
			FinA241(2,Nil,.t.) 
		endif
	else
		FinA241(2,.t.) 
	endif

	if 	FwModeAccess("SE2") == "E" .or. !Empty(xRecBor[01,01]) 
		cFilAnt := xRecBor[01,01]
	elseif	FwModeAccess("SA2") == "E" .or. FwModeAccess("SA6") == "E"
		cFilAnt := xRecBor[01,10]
	endif

	For t := 1 to Len(xRecBor)		

		SE2->(dbgoto(xRecBor[t,02]))    

		if	Upper(Alltrim(SE2->E2_NUMBOR)) == Upper(Alltrim(xRecBor[t,04]))   
		
			aArray[xRecBor[t,03],nPosFlg]						:=	.f.
			aArray[xRecBor[t,03],nPosStt]						:=	"4"
			aArray[xRecBor[t,03],nRecSEA] 						:=	000
			aArray[xRecBor[t,03],SE2->(FieldPos("E2_NUMBOR"))]	:=	xRecBor[t,04]

			For z := 1 to Len(aFiliais)
	
				SE2->(dbgoto(xRecBor[t,02]))    

				cQuery	:=	" Select R_E_C_N_O_ as RECNOSEA "
				cQuery	+=	" From " + RetSqlName("SEA")
				cQuery	+=	" Where EA_FILIAL   = '" + xFilial("SEA",aFiliais[z])	+ "' and "
				cQuery	+=		"   EA_PREFIXO  = '" + SE2->E2_PREFIXO				+ "' and "
				cQuery	+=		"   EA_NUM      = '" + SE2->E2_NUM					+ "' and "
				cQuery	+=		"   EA_PARCELA  = '" + SE2->E2_PARCELA				+ "' and "
				cQuery	+=		"   EA_TIPO     = '" + SE2->E2_TIPO					+ "' and "
				cQuery	+=		"   EA_FORNECE  = '" + SE2->E2_FORNECE				+ "' and "
				cQuery	+=		"   EA_LOJA	    = '" + SE2->E2_LOJA					+ "' and "
				cQuery 	+=		"   D_E_L_E_T_  = ' '                                        "
				
				TcQuery ChangeQuery(@cQuery) New Alias "XQRY"        	
				
				do while XQRY->(!Eof())
					SEA->(dbgoto(XQRY->RECNOSEA))
					aArray[xRecBor[t,03],nRecSEA] := SEA->(Recno())
					XQRY->(dbskip())	
				enddo
			
				XQRY->(dbclosearea())     

				if	aArray[xRecBor[t,03],nRecSEA] <> 0
					Exit
				endif
			
			Next z 	 	 

			SE2->(dbgoto(xRecBor[t,02]))     

			nSld := Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)

			if	lAtivo  
				if	lCCL .or. lCheck .or. lMastra 
					Z43->(dbsetorder(1))        
					if	Z43->(MsSeek( xFilial("Z43") + xRecBor[t,06] + xRecBor[t,07] + xRecBor[t,08] + xRecBor[t,04] , .f. ))
				    	RecLock("Z43",.f.)
							Z43->Z43_QTDE	+=	1
							Z43->Z43_VALOR	+=	nSld
						MsUnlock("Z43")
					else
				    	RecLock("Z43",.t.)
							Z43->Z43_FILIAL	:=	xFilial("Z43")
							Z43->Z43_NUMBOR	:=	xRecBor[t,04]
							Z43->Z43_BANCO	:=	xRecBor[t,06]
							Z43->Z43_AGENC	:=	xRecBor[t,07]
							Z43->Z43_CONTA	:=	xRecBor[t,08]
							Z43->Z43_MODELO	:=	xRecBor[t,09]
							Z43->Z43_USCBOR	:=	iif( lJob , "JOB" 	, RetCodUsr()						)
							Z43->Z43_USDBOR	:=	iif( lJob , "JOB" 	, cUserName 						)
							Z43->Z43_EMLBOR	:=	iif( lJob , "" 		, Alltrim(UsrRetMail(RetCodUsr())) 	)
							Z43->Z43_GERAAR	:=	"S"
							Z43->Z43_QTDE	:=	1
							Z43->Z43_VALOR	:=	nSld
						MsUnlock("Z43")
				    	RecLock("Z44",.t.)
							Z44->Z44_FILIAL	:=	xFilial("Z44")
							Z44->Z44_NUMBOR	:=	xRecBor[t,04]
							Z44->Z44_DATBOR	:=	iif( lJob , xDia , dDataBase )
							Z44->Z44_DATGER	:=	Date()
							Z44->Z44_HORGER	:=	Substr(Time(),01,05)
							Z44->Z44_BANCO	:=	xRecBor[t,06]
							Z44->Z44_AGENC	:=	xRecBor[t,07]
							Z44->Z44_CONTA	:=	xRecBor[t,08]
							Z44->Z44_EMPBOR	:=	cEmpAnt
							Z44->Z44_FILBOR	:=	cFilAnt
							Z44->Z44_TABSE2	:=	RetSqlName("SE2")
							Z44->Z44_FILSE2	:=	xFilial("SE2")
							Z44->Z44_TABSEA	:=	RetSqlName("SEA")
							Z44->Z44_FILSEA	:=	xFilial("SEA")
							Z44->Z44_TABSA6	:=	RetSqlName("SA6")
							Z44->Z44_FILSA6	:=	xFilial("SA6")
							Z44->Z44_TABZ43	:=	RetSqlName("Z43")
							Z44->Z44_FILZ43	:=	xFilial("Z43")
							Z44->Z44_TABSE8	:=	RetSqlName("SE8")
							Z44->Z44_FILSE8	:=	xFilial("SE8")
							Z44->Z44_TABSA2	:=	RetSqlName("SA2")
							Z44->Z44_FILSA2	:=	xFilial("SA2")
						MsUnlock("Z44")
					endif
				else
					ZAT->(dbsetorder(1))        
					if	ZAT->(MsSeek( xFilial("ZAT") + xRecBor[t,06] + xRecBor[t,07] + xRecBor[t,08] + xRecBor[t,04] , .f. ))
				    	RecLock("ZAT",.f.)
							ZAT->ZAT_QTDE	+=	1
							ZAT->ZAT_VALOR	+=	nSld
						MsUnlock("ZAT")
					else
				    	RecLock("ZAT",.t.)
							ZAT->ZAT_FILIAL	:=	xFilial("ZAT")
							ZAT->ZAT_NUMBOR	:=	xRecBor[t,04]
							ZAT->ZAT_BANCO	:=	xRecBor[t,06]
							ZAT->ZAT_AGENC	:=	xRecBor[t,07]
							ZAT->ZAT_CONTA	:=	xRecBor[t,08]
							ZAT->ZAT_MODELO	:=	xRecBor[t,09]
							ZAT->ZAT_USCBOR	:=	iif( lJob , "JOB" 	, RetCodUsr() 						)
							ZAT->ZAT_USDBOR	:=	iif( lJob , "JOB" 	, cUserName 						)
							ZAT->ZAT_EMLBOR	:=	iif( lJob , "" 		, Alltrim(UsrRetMail(RetCodUsr())) 	)
							ZAT->ZAT_GERAAR	:=	"S"
							ZAT->ZAT_QTDE	:=	1
							ZAT->ZAT_VALOR	:=	nSld
						MsUnlock("ZAT")
				    	RecLock("ZAV",.t.)
							ZAV->ZAV_FILIAL	:=	xFilial("ZAV")
							ZAV->ZAV_NUMBOR	:=	xRecBor[t,04]
							ZAV->ZAV_DATBOR	:=	iif( lJob , xDia , dDataBase )
							ZAV->ZAV_DATGER	:=	Date()
							ZAV->ZAV_HORGER	:=	Substr(Time(),01,05)
							ZAV->ZAV_BANCO	:=	xRecBor[t,06]
							ZAV->ZAV_AGENC	:=	xRecBor[t,07]
							ZAV->ZAV_CONTA	:=	xRecBor[t,08]
							ZAV->ZAV_EMPBOR	:=	cEmpAnt
							ZAV->ZAV_FILBOR	:=	cFilAnt
							ZAV->ZAV_TABSE2	:=	RetSqlName("SE2")
							ZAV->ZAV_FILSE2	:=	xFilial("SE2")
							ZAV->ZAV_TABSEA	:=	RetSqlName("SEA")
							ZAV->ZAV_FILSEA	:=	xFilial("SEA")
							ZAV->ZAV_TABSA6	:=	RetSqlName("SA6")
							ZAV->ZAV_FILSA6	:=	xFilial("SA6")
							ZAV->ZAV_TABZAT	:=	RetSqlName("ZAT")
							ZAV->ZAV_FILZAT	:=	xFilial("ZAT")
							ZAV->ZAV_TABSE8	:=	RetSqlName("SE8")
							ZAV->ZAV_FILSE8	:=	xFilial("SE8")
							ZAV->ZAV_TABSA2	:=	RetSqlName("SA2")
							ZAV->ZAV_FILSA2	:=	xFilial("SA2")
						MsUnlock("ZAV")
					endif
				endif
			endif			
		endif
	Next t
endif   

cFilAnt	:= 	xFilAnt

if	lAglTED
	For nI := 1 to Len(aAglTED)
		if	aAglTED[nI,06] > 1	  
			For s := 1 to Len(xAglTED)
				if	xAglTED[s,01] == nI
					SE2->(dbgoto(xAglTED[s,02]))
					nSld := SE2->E2_SALDO + SE2->E2_SDACRES - SE2->E2_SDDECRE
					aAglTED[nI,07] += nSld
				endif
			Next s 	
			cFilAnt	:= 	iif( Empty(aAglTED[nI,01]) , xFilAnt , aAglTED[nI,01] )
			sAglTED	:=	SuperGetMv("ZZ_AGLTTED",.f.,lMando)
			if	sAglTED
				xCnt := StrZero( Val(GetMv("ZZ_AGLTSEQ")) + 1 , 06 )
				PutMv( "ZZ_AGLTSEQ" , xCnt )
				For s := 1 to Len(xAglTED)
					if	xAglTED[s,01] == nI
						SE2->(dbgoto(xAglTED[s,02]))
						RecLock("SE2",.f.)
						if	SE2->(FieldPos("E2_ZZVLTED")) <> 0	
							SE2->E2_ZZVLTED	:=	iif( xAglTED[s,02] == aAglTED[nI,08] , aAglTED[nI,07] , 0 )
						endif				
						if	SE2->(FieldPos("E2_ZZSQTED")) <> 0	
							SE2->E2_ZZSQTED	:=	xCnt
						endif				
						MsUnlock("SE2")	
					endif
				Next s 	
			endif
		endif
	Next nI 
endif
	
if !lJob

	oGrid:Refresh()

	if	lFadel

		/*
		Retirado o envio pois o PE F240BORD envia o workflow
		For t := 1 to Len(aBordero)
			if 	FwModeAccess("SE2") == "E" 
				cFilAnt := aBordero[t,01]
			endif
			if	lFadel .and. RetCodUsr() == '000769'
				FwMsgRun( Nil , { || CursorWait() , Inkey(05)                              , CursorArrow() } , "TOTVS" , "Testes ..." )
			else
				FwMsgRun( Nil , { || CursorWait() , U_FDFINW01( 1 , Nil , aBordero[t,02] ) , CursorArrow() } , "TOTVS" , "Enviando Workflow ..." )
			endif
		Next t
		*/      

	elseif	Len(aNumBor) > 0    
			
		if !lAtivo 
		
			if	MessageBox("Gerar os arquivos CNAB dos border๔s ?","Aten็ใo",MB_YESNO) == 6 
				if	xGerAut			
					For t := 1 to Len(aNumBor)
						if 	FwModeAccess("SE2") == "E" .or. FwModeAccess("SA2") == "E" .or. FwModeAccess("SA6") == "E"
							cFilAnt		:= 	aNumBor[t,6]	
						endif
						SA6->(MsSeek( xFilial("SA6") + aNumBor[t,01] + aNumBor[t,02] + aNumBor[t,03] , .f. ))
						aNumBor[t,7] 	:=	SA6->A6_ZZDRGVP 
						aNumBor[t,8] 	:= 	!Empty(SA6->A6_ZZDRGVP)     
						if	aNumBor[t,8] .and. "ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
							aNumBor[t,7] := "c:\temp7"
						endif
					Next t
				endif
				xDir := .f.
				For t := 1 to Len(aNumBor)
					if 	Empty(aNumBor[t,7])
						xDir := .t.
						Exit
					endif
				Next t
				if	xDir
					cDir := xRetDir()
				endif
				For t := 1 to Len(aNumBor)
					if 	Empty(aNumBor[t,7])
						aNumBor[t,7] 	:=	cDir
					endif
					aNumBor[t,7] 		:=	Alltrim(aNumBor[t,7])
					if 	Empty(aNumBor[t,7])  
						cDir			:=	""
						Exit
					else
						aNumBor[t,7] 	+=	iif( Right(aNumBor[t,7],01) <> "\" , "\" , "" )
						cDir			:=	aNumBor[t,7]
					endif
				Next t    
				xDir := .f.
				For t := 1 to Len(aNumBor)
					if	aNumBor[t,8]
						xDir 			:= 	.t.
					endif
				Next t    
				if	Empty(cDir)		
		    		MessageBox("Diret๓rio nใo informado. Nใo serใo gerados os arquivos de CNAB.","Aten็ใo",MB_ICONHAND)
				elseif !xDir .or. MessageBox("Serใo gerados arquivos diretamente no diret๓rio do cadastro do banco." + CRLF + "Confirma ?","Aten็ใo",MB_YESNO) == 6   
					For t := 1 to Len(aNumBor)
		
						if 	FwModeAccess("SE2") == "E" .or. FwModeAccess("SA2") == "E" .or. FwModeAccess("SA6") == "E"
							cFilAnt	:= 	iif( lFilCen , aNumBor[t,4] , aNumBor[t,6] )
						endif
					
						if	lFilCen .and. !SA6->(dbseek( xFilial("SA6",aNumBor[t,4]) + aNumBor[t,01] + aNumBor[t,02] + aNumBor[t,03] , .f. ))   
							if !SA6->(dbseek( xFilial("SA6",aNumBor[t,6]) + aNumBor[t,01] + aNumBor[t,02] + aNumBor[t,03] , .f. ))   				  
							   	SA6->(dbseek( xFilial("SA6",Nil         ) + aNumBor[t,01] + aNumBor[t,02] + aNumBor[t,03] , .f. ))   
							endif
						else
						   	SA6->(dbseek( xFilial("SA6") + aNumBor[t,01] + aNumBor[t,02] + aNumBor[t,03] , .f. ))   
						endif
												
						aRet   	:=	{}	
						cDir	:=	aNumBor[t,7]	
		
						if	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) 	  .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA001" .and. lGera001
							FwMsgRun( Nil , { || aRet	:=	U_xGera001(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (001)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA001"
							FwMsgRun( Nil , { || aRet	:=	  xGera001(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (001)" )	
		
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA033" .and. lGera033
							FwMsgRun( Nil , { || aRet	:=	U_xGera033(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP)	 			} , 'Processando' , "Gerando arquivo CNAB (033)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA033"
							FwMsgRun( Nil , { || aRet	:=	  xGera033(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (033)" )	
		
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA104" .and. lGera104
							FwMsgRun( Nil , { || aRet	:=	U_xGera104(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP)	 			} , 'Processando' , "Gerando arquivo CNAB (104)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA104"
							FwMsgRun( Nil , { || aRet	:=	  xGera104(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (104)" )	
		
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA237" .and. lGera237
							FwMsgRun( Nil , { || aRet	:=	U_xGera237(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP)	 			} , 'Processando' , "Gerando arquivo CNAB (237)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA237"
							FwMsgRun( Nil , { || aRet	:=	  xGera237(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (237)" )	
		
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA341" .and. lGera341
							FwMsgRun( Nil , { || aRet	:=	U_xGera341(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (341)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA341"
							FwMsgRun( Nil , { || aRet	:=	  xGera341(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (341)" )	
		
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA422" .and. lGera422
							FwMsgRun( Nil , { || aRet	:=	U_xGera422(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (422)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA422"
							FwMsgRun( Nil , { || aRet	:=	  xGera422(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (422)" )	
		
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. ;
								SA6->(FieldPos('A6_ZZSUBP'))  <> 0 	.and. ;
								!Empty(SA6->A6_ZZAQCNF) 			.and. ;
								!Empty(SA6->A6_ZZSUBP)
							FwMsgRun( Nil , { || aRet	:=	xGeraSis(aNumBor[t],cDir) 					} , 'Processando' , "Gerando arquivo CNAB" )	
						else
							FwMsgRun( Nil , { || aRet	:=	xGeraSis(aNumBor[t],cDir) 					} , 'Processando' , "Gerando arquivo CNAB" )	
						endif
		
						if	aRet == Nil
							aRet := {2,''}
						endif
						
						if	aRet[01] == 0
		                   	aNumBor[t,7] := aRet[02]
						elseif	aRet[01] == 2
							MessageBox("Nใo foi possํvel a cria็ใo do arquivo de CNAB referente ao border๔ " + aNumBor[t,05],"Aten็ใo",MB_ICONHAND) 
							aNumBor[t,8] := .f.	
						endif
						
					Next t 	 
					
					For t := 1 to Len(aNumBor)
						if	aNumBor[t,8]   
							if 	FwModeAccess("SE2") == "E" .or. FwModeAccess("SA2") == "E" .or. FwModeAccess("SA6") == "E"
								cFilAnt	:= 	aNumBor[t,6]	
							endif
							For s := 1 to Len(aArray)					
								if	aArray[s,SE2->(FieldPos("E2_NUMBOR"))] == aNumBor[t,05]
									aArray[s,nGerAut] 	:=	.t.
									aArray[s,nDirAut] 	:= 	aNumBor[t,07]   
								endif
							Next s 					
							cQuery	:=	" UPDATE " + RetSqlName("SEA")
							cQuery	+=	" SET   EA_ZZARQGR = '" + aNumBor[t,07] 	+ "' ,   " 
							cQuery	+=		"   EA_ZZUSR   = '" + RetCodUsr()   	+ "'     " 
							cQuery	+=	" WHERE EA_FILIAL  = '" + xFilial("SEA") 	+ "' AND "
							cQuery	+=		"   EA_NUMBOR  = '" + aNumBor[t,05] 	+ "' AND "
							cQuery	+=		"   EA_CART    = 'P'                         AND "
							cQuery	+=		"   D_E_L_E_T_ = ' '                             "
							TcSqlExec(cQuery)
						endif    
					Next t 	 
					
				endif
			endif
		endif
		
		oGrid:Refresh()

		if	MessageBox("Imprimir as capas dos border๔s gerados ?","Aten็ใo",MB_YESNO) == 6 
			For t := 1 to Len(aNumBor)
				cFilAnt	:= 	aNumBor[t,6]	
				U_xCapaBor(aNumBor[t,5])
			Next t 	
		endif	

	endif

	oGrid:Refresh()

endif
	
cFilAnt	:= 	xFilAnt

RestArea(aArea)

Return

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fExcBord(oDlg,oGrid,aArray,nPosIni,nPosFim,lPass,oCombo)

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
//	Begin Transaction 
	xExcBord(@oDlg,@oGrid,@aArray,@nPosIni,@nPosFim,@lPass,@oCombo)	
//	DisarmTransaction()
//	End Transaction 
else
	xExcBord(@oDlg,@oGrid,@aArray,@nPosIni,@nPosFim,@lPass,@oCombo)	
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xExcBord(oDlg,oGrid,aArray,nPosIni,nPosFim,lPass,oCombo)

Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1  

Local nOpc				:=	0
Local xTGet1 			:=	CriaVar("E2_NUMBOR",.f.)
Local oFont 			:= 	tFont():New("Verdana",,14,.t.,.f.)
Local oFontB			:= 	tFont():New("Verdana",,14,.t.,.t.)

Local w                    
Local s
Local t         
Local xBco
Local xAge
Local xCon  
Local xDir				:=	""
Local xRec				:=	""
Local cArq				:=	""

Local aExc				:=	{}
Local xPos				:=	{}    
Local aBaixa 			:=	{}

Local lAut				:=	.f.
Local lArq				:=	.t.
Local lCont				:=	.f.    
Local lEntra			:=	.f.
Local lBaixa			:=	.f.
Local xBaixa			:=	.f.

Local nSaldo			:=	0      

Local cFilTmp			:=	cFilAnt
Local xFunName			:=	FunName()      
Local lPCCBaixa			:= 	SuperGetMv("MV_BX10925",.t.,"2") == "1"     

Default lPass			:=	.f.
Default nPosIni			:=	001
Default nPosFim			:=	Len(aArray)

Define Dialog oDlgAlt Title "Border๔" From 000,000 To 080,200 Pixel
oSay1		:= 	tSay():Create(oDlgAlt,{|| "Digite :" },08,05,,oFontB,,,,.t.,CLR_BLUE,Nil)
oTGet1 		:= 	tGet():New(05,42,bSetGet(xTGet1),oDlgAlt,055,009,"@!",,0,,oFont,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
oTButton1	:= 	tButton():New(025,057,"Ok",oDlgAlt,{ || nOpc := 1 , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered   

if	nOpc <> 1
	Return 
endif

For w := nPosIni to nPosFim
	if	Upper(Alltrim(aArray[w,SE2->(FieldPos("E2_NUMBOR"))])) == Upper(Alltrim(xTGet1))
		lCont := .t. 
		Exit
	endif
Next w 

if !lCont   
	MessageBox("Border๔ digitado nใo foi encontrado em tela.","Aten็ใo",MB_ICONHAND)
	Return 
endif

if	lAtivo
	if	lCCL .or. lCheck .or. lMastra 
		For w := nPosIni to nPosFim
			if	Upper(Alltrim(aArray[w,SE2->(FieldPos("E2_NUMBOR"))])) == Upper(Alltrim(xTGet1))
				if	aArray[w,nPosStt] == "4"
					if	Len(aExc) == 0 
						For t := 1 to Len(aFiliais)
							Z43->(dbsetorder(1))
							if	Z43->(dbseek( xFilial("Z43",aFiliais[t]) + aArray[w,nPosBco] + aArray[w,nPosAge] + aArray[w,nPosCon] + aArray[w,SE2->(FieldPos("E2_NUMBOR"))] , .f. ))
								if !Empty(Z43->Z43_DTAPV1)
									aAdd( aExc , w )
								endif
							endif
						Next t 
				  	endif
				endif
			endif
		Next w 
	else
		For w := nPosIni to nPosFim
			if	Upper(Alltrim(aArray[w,SE2->(FieldPos("E2_NUMBOR"))])) == Upper(Alltrim(xTGet1))
				if	aArray[w,nPosStt] == "4"
					if	Len(aExc) == 0 
						For t := 1 to Len(aFiliais)
							ZAT->(dbsetorder(1))
							if	ZAT->(dbseek( xFilial("ZAT",aFiliais[t]) + aArray[w,nPosBco] + aArray[w,nPosAge] + aArray[w,nPosCon] + aArray[w,SE2->(FieldPos("E2_NUMBOR"))] , .f. ))
								if !Empty(ZAT->ZAT_DTAPV1)
									aAdd( aExc , w )
								endif
							endif
						Next t 
				  	endif
				endif
			endif
		Next w
	endif			
endif

if	Len(aExc) <> 0 
	MessageBox("O border๔ " + Alltrim(xTGet1) + " jแ foi aprovado, portanto nใo pode ser cancelado","Aten็ใo",MB_ICONHAND)
	Return
endif	

For w := nPosIni to nPosFim
	if	Upper(Alltrim(aArray[w,SE2->(FieldPos("E2_NUMBOR"))])) == Upper(Alltrim(xTGet1))
		if	aArray[w,nPosStt] == "4" .or. ( !lPCCBaixa .and. aArray[w,nPosStt] == "9" )
			xBco	:=	aArray[w,nPosBco]
			xAge	:=	aArray[w,nPosAge]
			xCon	:=	aArray[w,nPosCon]
			xRec	+=	iif( Empty(xRec) , "" , "|" ) + StrZero(aArray[w,nPosRec],10)
			lBaixa	:=	iif( aArray[w,nPosStt] == "9" , .t. , lBaixa )
			xBaixa	:=	iif( aArray[w,nPosStt] == "9" , .t. , .f.    )
		  	aAdd( xPos   , w      )	
			aAdd( aBaixa , xBaixa )		
		endif
	endif
Next w

if	lBaixa .and. lPCCBaixa 
	MessageBox("Nใo ้ possํvel o cancelamento de border๔ de tํtulos jแ baixados quando a configura็ใo de PCC ้ na baixa." + CRLF + "Usar a rotina padrใo","Aten็ใo",MB_ICONHAND)
	Return
endif	

For w := nPosIni to nPosFim
	if	Upper(Alltrim(aArray[w,SE2->(FieldPos("E2_NUMBOR"))])) == Upper(Alltrim(xTGet1))
		if	aArray[w,nGerAut] 
			lAut		:=	.t.
	    	if !File(aArray[w,nDirAut])
				lArq	:=	.f.
				Exit
			endif
		endif
	endif
Next w

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
//	lAut := .f. 
endif

if	Len(xPos) <= 0 
	MessageBox("Nใo foram encontrados tํtulos para cancelamento para o border๔ informado","Aten็ใo",MB_ICONHAND)
	Return
endif	

if 	lAut .and. !lArq 
	if	!( MessageBox("O arquivo gerado na pasta padrใo do banco nใo foi encontrado." + CRLF + "Confirma a exclusใo do border๔ " + Alltrim(xTGet1) + " ?","Aten็ใo",MB_YESNO) == 6 ) 
		Return
	endif
elseif	!( MessageBox("Confirma exclusใo do border๔ " + Alltrim(xTGet1) + " ?","Aten็ใo",MB_YESNO) == 6 ) 
	Return
endif

lEntra := lFadel 									// .or. "ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
	
if	lEntra .and. MessageBox("Deseja gerar o arquivo para a baixa dos tํtulos do border๔ " + Alltrim(xTGet1) + " ?","Aten็ใo",MB_YESNO) == 6
	do while Empty(xDir)
		xDir := xRetDir()
		xDir := iif( Upper(Alltrim(xDir)) == "\" , "" , xDir )
		if	Empty(xDir)
			if	MessageBox("Abandona a gera็ใo do arquivo ?","Aten็ใo",MB_YESNO) == 6
				Exit
			endif
		else		
			if	MessageBox("Confirma o diret๓rio de gera็ใo do arquivo ?","Aten็ใo",MB_YESNO) == 6
				xDir := Alltrim(xDir)
				xDir += iif( Right(xDir,01) <> "\" , "\" , "" )
				xDir += "E" + Upper(Alltrim(xTGet1)) + ".REM"  
				Exit	
			endif
		endif
	enddo
	if !Empty(xDir)
		U_xGerCnabEx(xTGet1,xBco,xAge,xCon,xDir,xRec)
	endif
	if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
		//Return
	endif
endif

SetFunName("FINA241")

For s := 1 to Len(xPos)
	xBaixa := aBaixa[s] 
	For w := 1 to Len(aArray)	
		if	w <> xPos[s]
			Loop
		endif			
		SE2->(dbgoto(aArray[w,nPosRec]))   
		if	SE2->(FieldPos("E2_ZZVLTED")) <> 0 .or. SE2->(FieldPos("E2_ZZSQTED")) <> 0	 
			RecLock("SE2",.f.)
			if	SE2->(FieldPos("E2_ZZVLTED")) <> 0	
				SE2->E2_ZZVLTED	:=	0
			endif				
			if	SE2->(FieldPos("E2_ZZSQTED")) <> 0	
				SE2->E2_ZZSQTED	:=	""
			endif				
			MsUnlock("SE2")    
		endif
		if 	FwModeAccess("SE2") == "E" .or. !Empty(SE2->E2_FILIAL)
			cFilAnt := SE2->E2_FILIAL
		else
			cFilAnt := SE2->E2_FILORIG
		endif
		if	aArray[w,nRecSEA] <> 0
			SEA->(dbgoto(aArray[w,nRecSEA]))
			xExcSEA(xTGet1,SEA->(Recno()),xBaixa)
		else
			SEA->(dbsetorder(2))	
			if	SEA->(dbseek( xFilial("SEA") + aArray[w,SE2->(FieldPos("E2_NUMBOR"))] + "P" + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. ))
				xExcSEA(xTGet1,SEA->(Recno()),xBaixa)
	       	endif    		
			For t := 1 to Len(aFiliais)	
				SE2->(dbgoto(aArray[w,nPosRec]))  	
				if !Empty(aFiliais[t])
					cFilAnt := aFiliais[t]
				endif		
				if	SEA->(dbseek( xFilial("SEA") + aArray[w,SE2->(FieldPos("E2_NUMBOR"))] + "P" + SE2->(E2_PREFIXO + E2_NUM + E2_PARCELA + E2_TIPO + E2_FORNECE + E2_LOJA) , .f. ))
					xExcSEA(xTGet1,SEA->(Recno()),xBaixa)
		       	endif		       	
			Next t    
		endif		
	Next w
Next s 

SetFunName(xFunName)

For s := 1 to Len(xPos)
	For w := 1 to Len(aArray)
	
		if	w <> xPos[s]
			Loop
		endif			

		SE2->(dbgoto(aArray[w,nPosRec]))

		if 	FwModeAccess("SE2") == "E" .or. !Empty(SE2->E2_FILIAL)
			cFilAnt := SE2->E2_FILIAL
		else
			cFilAnt := SE2->E2_FILORIG
		endif
	
		nSaldo 				:= 	Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)
		aArray[w,nDirAut]	:=	Alltrim(aArray[w,nDirAut])
		
		xStatusArr(@aArray,nSaldo,w)

		if !Empty(aArray[w,nDirAut])    
			For t := Len(aArray[w,nDirAut]) to 1 Step -1 
				if	Substr(aArray[w,nDirAut],t,1) == "\"
					Exit
				else
					cArq := Right(aArray[w,nDirAut],t) 
				endif
			Next t 	
	    	if	File(aArray[w,nDirAut])
				fErase(aArray[w,nDirAut])
			endif
	    	if	File(aArray[w,nDirAut])
				MessageBox("O arquivo " + Alltrim(cArq) + " nใo foi excluํdo. Avise ao TI","Aten็ใo",MB_ICONEXCLAMATION)
			endif
		endif
	
		aArray[w,nDirAut]						:=	""
		aArray[w,nPosFlg]						:=	.f.
		aArray[w,nGerAut]						:=	.f.
		aArray[w,nRecSEA]						:=	000
		aArray[w,SE2->(FieldPos("E2_NUMBOR"))]	:=	CriaVar("E2_NUMBOR",.f.)   

		xModPg(@aArray,w,nSaldo,!( aArray[w,nPosStt] $ "1/5/9" ))
	
	Next w
Next s 

Pergunte("F240BR",.f.)
	
oGrid:Refresh()

cFilAnt := cFilTmp

Return                                                                        

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xExcSEA(xTGet1,xRecSEA,lBaixa)

Local lPCCBaixa		:= 	SuperGetMv("MV_BX10925",.t.,"2") == "1"     

Private cLote

LoteCont( "FIN" )

RecLock("SE2",.f.)
	SE2->E2_NUMBOR		:=	""
	SE2->E2_PORTADO		:=	""
	SE2->E2_NUMBCO		:=	""
	SE2->E2_BAIXA		:=	iif( lBaixa , SE2->E2_BAIXA , CtoD("") )
	if	SE2->(FieldPos("E2_ZZSQTED")) <> 0	
		SE2->E2_ZZSQTED	:=	""
	endif
	if	SE2->(FieldPos("E2_ZZVLTED")) <> 0
		SE2->E2_ZZVLTED	:=	0
	endif 
MsUnlock("SE2")    

if	Upper(Alltrim(SEA->EA_ORIGEM)) == "FINA241"
	if 	lPCCBaixa 
		F241CanImp(Nil,Nil,Nil,Nil,Nil,Nil,xTGet1)
	endif
endif

SEA->(dbgoto(xRecSEA))

if 	ExistBlock("FA300REJ")
	ExecBlock("FA300REJ",.f.,.f.,{ "00" })
endif

SEA->(dbgoto(xRecSEA))

RecLock("SEA",.f.,.t.)
	SEA->(dbdelete())
MsUnlock("SEA")

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkBank(oDlg,oGrid,aArray)

Local w 			:=	Nil
Local aRet 			:= 	RetBancos() 

if	Empty(aRet[1]) 
	Return
endif

For w := 1 to Len(aArray)
	if	aArray[w,nPosBco] == aRet[1] .and. aArray[w,nPosAge] == aRet[2] .and. aArray[w,nPosCon] == aRet[3]
		aArray[w,nPosFlg] := .t.	
	endif	
Next w    

oGrid:SetArray(aArray)
oGrid:Refresh()

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkFili(oDlg,oGrid,aArray)

Local w
Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1       
Local lOk			:=	.f.     
Local lSE2Excl		:=	FwModeAccess("SE2") == "E"
Local cTGet1		:=	CriaVar("E2_FILIAL",.f.)   
Local oFont 		:= 	tFont():New("Tahoma",,-11,.t.)
Local aArea			:=	SM0->(GetArea())

Define Dialog oDlgAlt Title "Digite" From 000,000 To 080,200 Pixel
oSay1		:= 	TSay():Create(oDlgAlt,{ || "Filial :" },08,05,,oFont,,,,.t.,Nil,)
oTGet1 		:= 	TGet():New(05,42,bSetGet(cTGet1),oDlgAlt,055,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,'SM0EMP')
oTButton1	:= 	TButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered

if	lOk
	if	ExistCpo("SM0",cEmpAnt + cTGet1)
		For w := 1 to Len(aArray)
	 		if	iif( lSE2Excl , aArray[w,SE2->(FieldPos("E2_FILIAL"))] == cTGet1 , aArray[w,SE2->(FieldPos("E2_FILORIG"))] == cTGet1 )
	 			aArray[w,nPosFlg] := .t.	
			endif	
		Next w 
	endif
endif

RestArea(aArea)

oGrid:SetArray(aArray)
oGrid:Refresh()

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkNatu(oDlg,oGrid,aArray)

Local w
Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1       
Local lOk			:=	.f.     
Local cTGet1		:=	CriaVar("E2_NATUREZ",.f.)   
Local oFont 		:= 	tFont():New("Tahoma",,-11,.t.)

Define Dialog oDlgAlt Title "Digite" From 000,000 To 080,200 Pixel
oSay1		:= 	TSay():Create(oDlgAlt,{ || "Natureza :" },08,05,,oFont,,,,.t.,Nil,)
oTGet1 		:= 	TGet():New(05,42,bSetGet(cTGet1),oDlgAlt,055,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,"SED")
oTButton1	:= 	TButton():New(25,57,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },40,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered

if	lOk
	if	ExistCpo("SED",cTGet1,1)
		For w := 1 to Len(aArray)
	 		if	aArray[w,SE2->(FieldPos("E2_NATUREZ"))] == cTGet1 
	 			aArray[w,nPosFlg] := .t.	
			endif	
		Next w 
	endif
endif

oGrid:SetArray(aArray)
oGrid:Refresh()

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkForn(oDlg,oGrid,aArray)

Local w
Local oSay1
Local oTGet1
Local oDlgAlt
Local oTButton1       
Local lOk			:=	.f.     
Local cTGet1		:=	CriaVar("A2_COD",.f.)   
Local cTGet2		:=	CriaVar("A2_LOJA",.f.)   
Local oFont 		:= 	tFont():New("Verdana",,14,.t.)

Define Dialog oDlgAlt Title "Digite" From 000,000 to 080,290 Pixel
oSay1		:= 	tSay():Create(oDlgAlt,{ || "Fornecedor :" },08,03,,oFont,,,,.t.,Nil,)
oTGet1 		:= 	tGet():New(005,046,bSetGet(cTGet1),oDlgAlt,060,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,"FOR",,,,,)
oTGet2 		:= 	tGet():New(005,111,bSetGet(cTGet2),oDlgAlt,030,009,"@!",,0,,,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,     ,,,,,)
oTButton1	:= 	tButton():New(025,111,"Ok",oDlgAlt,{ || lOk := .t. , oDlgAlt:End() },30,10,,,.f.,.t.,.f.,,.f.,,,.f.)
Activate Dialog oDlgAlt Centered

if	lOk
	if	!Empty(cTGet1)
		For w := 1 to Len(aArray)
	 		if	aArray[w,SE2->(FieldPos("E2_FORNECE"))] == cTGet1 .and. iif( Empty(cTGet2) , .t. , aArray[w,SE2->(FieldPos("E2_LOJA"))] == cTGet2 )  
	 			aArray[w,nPosFlg] := .t.	
			endif	
		Next w 
	endif
endif

oGrid:SetArray(aArray)
oGrid:Refresh()

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fMarkTipo(oDlg,oGrid,aArray)

Local w
Local oDlgAlt
Local lOk			:=	.f.     
Local nRadio		:=	000
Local oRadio		:=	Nil

Define MsDialog oDlgAlt From  000,000 To 127,292 Title "Informe" Pixel 
@ 005,007 To 045,140 Of oDlgAlt  Pixel	
@ 011,010 Radio oRadio Var nRadio Items "Boleto" , "Deposito" , "Tributo" 3D Size 100,010 Of oDlgAlt Pixel
Define sButton From 048,115 Type 1 Enable Of oDlgAlt Action ( lOk := .t. , oDlgAlt:End() )
Activate MsDialog oDlgAlt Centered 

if	lOk
	For w := 1 to Len(aArray)
 		if	nRadio == 1 .and. Upper(Alltrim(aArray[w,nTipoPg])) == "BOLETO"
 			aArray[w,nPosFlg] := .t.	
 		elseif	nRadio == 2 .and. Upper(Alltrim(aArray[w,nTipoPg])) == "DEPOSITO"
 			aArray[w,nPosFlg] := .t.	
 		elseif	nRadio == 3 .and. Upper(Alltrim(aArray[w,nTipoPg])) == "TRIBUTO"
 			aArray[w,nPosFlg] := .t.	
		endif	
	Next w 
endif

oGrid:SetArray(aArray)
oGrid:Refresh()

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fChecaId()	 

Local xAtivo 	:= 	Nil
Local cIdCnab 	:= 	Nil
Local cChaveID	:= 	Nil

Local aArea		:=	GetArea()
Local aAreaSE2	:=	SE2->(GetArea())

do while .t.    

	xAtivo		:=	AliasInDic("Z49") .and. ( lCCL .or. lCheck )
	cIdCnab 	:= 	GetSxENum("SE2","E2_IDCNAB","E2_IDCNAB" + cEmpAnt,iif(lNewIndice,13,11))
	cChaveID	:= 	iif(lNewIndice,cIdCnab,xFilial("SE2") + cIdCnab)

	dbSelectArea("SE2")
	dbSetOrder(iif(lNewIndice,13,11))

	do while SE2->(MsSeek(cChaveID))
		ConfirmSX8()
		cIdCnab 	:= 	GetSxENum("SE2","E2_IDCNAB","E2_IDCNAB" + cEmpAnt,iif(lNewIndice,13,11))
		cChaveID 	:= 	iif(lNewIndice,cIdCnab,xFilial("SE2") + cIdCnab)
	enddo
	
	RestArea(aAreaSE2)
	
	Reclock("SE2",.f.)
		SE2->E2_IDCNAB	:= 	cIdCnab
	MsUnlock("SE2")

	if !Empty(SE2->E2_IDCNAB) .and. xAtivo
		dbselectarea("Z49")
		Reclock("Z49",.t.)
			Z49->Z49_FILIAL	:=	SE2->E2_FILIAL		
			Z49->Z49_PREFIX	:=	SE2->E2_PREFIXO	
			Z49->Z49_NUM   	:=	SE2->E2_NUM    	
			Z49->Z49_PARCEL	:=	SE2->E2_PARCELA	
			Z49->Z49_TIPO  	:=	SE2->E2_TIPO   	
			Z49->Z49_FORNEC	:=	SE2->E2_FORNECE
			Z49->Z49_LOJA 	:=	SE2->E2_LOJA   
			Z49->Z49_NOMFOR	:=	SE2->E2_NOMFOR 
			Z49->Z49_IDCNAB	:=	SE2->E2_IDCNAB 
			Z49->Z49_EMISSA	:=	Date()
		MsUnlock("Z49")
	endif

	ConfirmSx8()

	if !Empty(SE2->E2_IDCNAB) 
		Exit
	endif	
	
	RestArea(aAreaSE2)
	RestArea(aArea)

enddo

RestArea(aAreaSE2)
RestArea(aArea)

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xPrpVisMsg() ; Return ( fVisMsg() )

Static Function fVisMsg()

Local oMemo	
Local xMemo
Local oFont
Local oSay1	
Local oTGet1
Local oDlgMsg

Local nOpc		:=	0
Local oFontB	:= 	tFont():New("Verdana",,14,.t.,.t.)

Local aItens 	:=	{ " " , "Sem Assinatura" , "Valor Divergente" , "Faltando Carimbo" , "Sem Aprova็ใo" }
Local bChange	:=	{ || xTGet1 := PadR( aItens[oCombo:nAt] , 40 ) , oTGet1:SetText(xTGet1) , oTGet1:Refresh() } 
Local cCombo 	:=	aItens[01]

Local cTexto	:=	"" 
Local xTexto	:=	iif( lIsBlind , Space(2000) , SE2->E2_ZZMSGFN 								) 
Local lMsgErr	:=	iif( lIsBlind , .f.			, SE2->(FieldPos("E2_ZZMSGER")) <> 0 			)
Local xTGet1	:=	iif( lIsBlind , Space(0040)	, iif( lMsgErr , SE2->E2_ZZMSGER , 	Space(40) )	)
Local xTGet2	:=	iif( lIsBlind , Space(0040)	, iif( lMsgErr , SE2->E2_ZZMSGER , 	Space(40) )	)

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
//	lMsgErr		:=	.t. 
endif 

Define Font oFont Name 'Mono AS' Size 008,014          

if	lMsgErr
	Define MsDialog oDlgMsg Title 'Observa็ใo do Tํtulo' From 003,000 to 440,839 Pixel
	@ 005,005 To 050,205 Label "Mensagem de Erro" Of oDlgMsg  Pixel	
	oSay1		:= 	tSay():Create(oDlgMsg,{|| "Msg Padrใo :" },18,10,,oFontB,,,,.t.,CLR_BLUE,Nil)
	oCombo		:=	tComboBox():New(12,060,bSetGet(cCombo),aItens,140,045,oDlgMsg,,{ || Eval(bChange) },,,,.t.,oFont,,,,,,)
	oTGet1 		:= 	tGet():New(33,10,bSetGet(xTGet1),oDlgMsg,190,009,"@!",,0,,oFont,.f.,,.t.,,.f.,,.f.,.f.,,.f.,.f.,,,,,,)
	@ 055,005 To 200,205 Label "Cadastrar" Of oDlgMsg  Pixel	
	@ 065,010 Get oMemo Var cTexto Memo Size 190,130 Of oDlgMsg Pixel
		oMemo:bRClicked :=	{ || AllwaysTrue() }
		oMemo:oFont     := 	oFont
	@ 005,210 To 200,410 Label "Anteriores" Of oDlgMsg  Pixel	
	@ 015,215 Get xMemo Var xTexto Memo Size 190,180 Of oDlgMsg Pixel
		xMemo:bRClicked :=	{ || AllwaysTrue() }
		xMemo:oFont     := 	oFont
		xMemo:Disable()
	Define SButton From 205,150 Type 01 Action ( nOpc := 1 , oDlgMsg:End() ) Enable Of oDlgMsg Pixel 
	Define SButton From 205,180 Type 02 Action ( nOpc := 0 , oDlgMsg:End() ) Enable Of oDlgMsg Pixel 
	Activate MsDialog oDlgMsg Centered
else
	Define MsDialog oDlgMsg Title 'Observa็ใo do Tํtulo' From 003,000 to 340,839 Pixel
	@ 005,005 To 150,205 Label "Cadastrar" Of oDlgMsg  Pixel	
	@ 015,010 Get oMemo Var cTexto Memo Size 190,130 Of oDlgMsg Pixel
		oMemo:bRClicked :=	{ || AllwaysTrue() }
		oMemo:oFont     := 	oFont
	@ 005,210 To 150,410 Label "Anteriores" Of oDlgMsg  Pixel	
	@ 015,215 Get xMemo Var xTexto Memo Size 190,130 Of oDlgMsg Pixel
		xMemo:bRClicked :=	{ || AllwaysTrue() }
		xMemo:oFont     := 	oFont
		xMemo:Disable()
	Define SButton From 153,150 Type 01 Action ( nOpc := 1 , oDlgMsg:End() ) Enable Of oDlgMsg Pixel 
	Define SButton From 153,180 Type 02 Action ( nOpc := 0 , oDlgMsg:End() ) Enable Of oDlgMsg Pixel 
	Activate MsDialog oDlgMsg Centered
endif 

if	nOpc == 1 
	if !Empty(cTexto)
		cTexto	:= 	"Observacao incluida por " + Upper(Alltrim(cUserName)) + " em " + DtoC(Date()) + " as " + Substr(Time(),01,05) + CRLF + CRLF + cTexto
		cTexto 	+=	iif( !Empty(SE2->E2_ZZMSGFN) , CRLF + CRLF + SE2->E2_ZZMSGFN , "" )
		RecLock("SE2",.f.)
			SE2->E2_ZZMSGFN	:= cTexto
		MsUnlock("SE2")
	endif 
	if	SE2->(FieldPos("E2_ZZMSGER")) <> 0
		if !Empty(xTGet1) .or. xTGet1 <> xTGet2 
			RecLock("SE2",.f.)
				SE2->E2_ZZMSGER	:= xTGet1
			MsUnlock("SE2")
		endif 
	endif 
endif

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
//	Return 
endif 

Return ( !Empty(Alltrim(SE2->E2_ZZMSGFN)) .or. ( lMsgErr .and. !Empty(SE2->E2_ZZMSGER) ) )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function GetHtml(cTexto,cForn)	   		

Local w
Local cHtml			:=	""
Local aHtml			:=	StrToKarr(StrTran(StrTran(cTexto,Chr(13),""),Chr(10),"|"),"|")
Local nSalTt		:=	Transform( SE2->E2_SALDO , PesqPict("SE2","E2_VALOR") )
Local nValNf		:=	0

SF1->(dbsetorder(2))
if	SF1->(MsSeek( xFilial("SF1",iif(Empty(SE2->E2_FILIAL),Nil,SE2->E2_FILIAL)) + SE2->(E2_FORNECE + E2_LOJA + E2_NUM) , .f. ))
	do while SF1->(!Eof()) .and. SF1->(F1_FILIAL + F1_FORNECE + F1_LOJA + F1_DOC) == ( xFilial("SF1",iif(Empty(SE2->E2_FILIAL),Nil,SE2->E2_FILIAL)) + SE2->(E2_FORNECE + E2_LOJA + E2_NUM) )
		if	SF1->F1_PREFIXO == SE2->E2_PREFIXO
			SD1->(dbsetorder(1))
			if	SD1->(MsSeek( xFilial("SD1",SF1->F1_FILIAL) + SF1->(F1_DOC + F1_SERIE + F1_FORNECE + F1_LOJA) , .f. ))
				do while SD1->(!Eof()) .and. SD1->D1_FILIAL + SD1->D1_DOC + SD1->D1_SERIE + SD1->D1_FORNECE + SD1->D1_LOJA == ;
			                ( xFilial("SD1",SF1->F1_FILIAL) + SF1->F1_DOC + SF1->F1_SERIE + SF1->F1_FORNECE + SF1->F1_LOJA) 
					nValNf += SD1->D1_TOTAL
					SD1->(dbskip())
				enddo
			endif
			Exit
		endif
		SF1->(dbskip())
	enddo
endif

nValNf	:=	Transform( nValNf , PesqPict("SE2","E2_VALOR") )	
   
cHtml	+=	'<html>' 																																															+ CRLF
cHtml	+=	'<title>.:: Totvs Protheus 11 - Informa็๕es Adicionais ::.</title>'																																	+ CRLF
cHtml	+=	'<style>' 																																															+ CRLF
cHtml	+=	'Body {' 																																															+ CRLF
cHtml	+=	'	font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt' 																															+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TableRowBlueDarkMini {' 																																											+ CRLF
cHtml	+=	'	background-color: #E4E4E4; color: #FFCC00; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; vertical-align: center' 														+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TableRowWhiteMini2 {' 																																											+ CRLF
cHtml	+=	'	color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; vertical-align: center' 																					+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.style5 {' 																																														+ CRLF
cHtml	+=	'	color: #19167D; font-weight: bold;' 																																							+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TarjaTopoCor {' 																																													+ CRLF
cHtml	+=	'	text-decoration: none;height: 6px; background-color: #6699CC' 																																	+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.texto-layer {' 																																													+ CRLF
cHtml	+=	'	font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000000; text-decoration: none' 																						+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.titulo {' 																																														+ CRLF
cHtml	+=	'	font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #19167D; text-decoration: none; font-weight: bold;' 																			+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.texto {' 																																															+ CRLF
cHtml	+=	'	font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; text-decoration: none; font-weight: normal;' 																		+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'</style>' 																																															+ CRLF
cHtml	+=	'<head>' 																																															+ CRLF
cHtml	+=	'  <title>Informa็๕es Adicionais</title>' 																																							+ CRLF
cHtml	+=	'  <meta http-equiv="Content-Type" content="text/html; charset=utf-8">' 																															+ CRLF
cHtml	+=	'</head>' 																																															+ CRLF
cHtml	+=	'<body>' 																																															+ CRLF
cHtml	+=	'<table border="0" cellpadding="0" cellspacing="0" height="58" width="50%" align="center">' 																										+ CRLF
cHtml	+=	'  <tbody>' 																																														+ CRLF
cHtml	+=	'    <tr>' 																																															+ CRLF
cHtml	+=	'      <td>'																																														+ CRLF
cHtml	+=	GetMv("ZZ_TAGLOG")                                                                                                                                                        							+ CRLF
cHtml	+=	'      </td>'																																														+ CRLF
cHtml	+=	'    </tr>' 																																														+ CRLF
cHtml	+=	'  </tbody>' 																																														+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF
cHtml	+=	'<table width="50%" border="0" cellpadding="0" cellspacing="0" height="58" align="center">' 																										+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td height="72" width="100%">' 																																								+ CRLF
cHtml	+=	'      <p align="center"><font face="Tahoma" size="5">Informa็๕es Adicionais do Tํtulo</font>' 																										+ CRLF
cHtml	+=	'    </td>' 																																														+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td height="1" class="TarjaTopoCor" colspan="3">' 																																				+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF

cHtml	+=	'<br>' 																																																+ CRLF
cHtml	+=	'<br>' 																																																+ CRLF

cHtml	+=	'<table border="1" width="50%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 												+ CRLF 
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="40%" align="left" ><b><span class="style5"><span style="font-size: 8pt">&nbsp Vencimento     </span></span></b></td>' 						+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="60%" align="right"><b><span class="style5"><span style="font-size: 8pt">' + DtoC(SE2->E2_VENCREA) 	+  ' &nbsp</span></span></b></td>'		+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF 

cHtml	+=	'<table border="1" width="50%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 												+ CRLF 
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="40%" align="left" ><b><span class="style5"><span style="font-size: 8pt">&nbsp Valor da NF    </span></span></b></td>' 						+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="60%" align="right"><b><span class="style5"><span style="font-size: 8pt">' + nValNf +  ' &nbsp</span></span></b></td>'						+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF 

cHtml	+=	'<table border="1" width="50%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 												+ CRLF 
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="40%" align="left" ><b><span class="style5"><span style="font-size: 8pt">&nbsp Saldo do Tํtulo </span></span></b></td>' 					+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="60%" align="right"><b><span class="style5"><span style="font-size: 8pt">' + nSalTt +  ' &nbsp</span></span></b></td>'						+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF 

cHtml	+=	'<br>' 																																																+ CRLF

cHtml	+=	'<table border="1" width="50%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 												+ CRLF 
cHtml	+=	'  <tbody>' 																									   																					+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'  <td class="TableRowBlueDarkMini" height="21" width="100%" align="left" ><b><span class="style5"><span style="font-size: 8pt">'                                         							+ CRLF
cHtml	+=	'<br>' 																																																+ CRLF		
For w := 1 to Len(aHtml)
	cHtml	+=	' &nbsp ' 																																														+ CRLF		
	if	w <> 1 .and. "OBSERVACAO INCLUIDA" $ Upper(aHtml[w])
		cHtml	+=	'<br>' 																																														+ CRLF		
	endif
	cHtml	+=	aHtml[w]                               																																							+ CRLF
	cHtml	+=	'<br>' 																																															+ CRLF		
Next w 
cHtml	+=	'<br>' 																																																+ CRLF		
cHtml	+=	'  </span></span></b></td>' 																																										+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'  </tbody>' 																																														+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF 

cHtml	+=	'<br>' 																																																+ CRLF		

cHtml	+=	'<table width="50%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#E5E5E5" bgcolor="#F7F7F7" >' 																			+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td width="100%" bordercolor="#FFFFFF"><div align="right" class="texto-layer">WorkFlow @ Totvs</div></td>' 																					+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF
cHtml	+=	'</body>' 																																															+ CRLF
cHtml	+=	'</html>' 																																															+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGeraSis(aPar,cDir)

Local w
Local cArq
Local xArq
Local cSub		:=	""
Local cCfg		:=	""
Local aRet		:=	{0,""}
Local cBco		:=	aPar[01]
Local cAge		:=	aPar[02]
Local cCon		:=	aPar[03]
Local xFil		:=	aPar[04]
Local cBor		:=	aPar[05]  
Local xEmp		:=	SM0->M0_CODIGO        
Local xFilAnt	:=	cFilAnt    

SEA->(dbsetorder(2))
if	!Empty(xFil) .and. SEA->(dbseek( xFil + cBor + "P" , .f. ))
	cFilAnt := xFil
else
	For w := 1 to Len(aFiliais)
		cFilAnt := aFiliais[w]
		if	SEA->(dbseek( xFilial("SEA") + cBor + "P" , .f. ))
			Exit
		else
			cFilAnt := xFil
		endif	
	Next w 
endif

SA6->(dbsetorder(1))
SA6->(dbseek( xFilial("SA6") + cBco + cAge + cCon , .f. ))

cSub := iif( SA6->(FieldPos('A6_ZZSUBP')) <> 0 .and. !Empty(SA6->A6_ZZSUBP) , SA6->A6_ZZSUBP , '000' )

SEE->(dbsetorder(1))
SEE->(dbgotop())  

if	SEE->(dbseek( xFilial("SEE") + cBco + cAge + cCon + cSub , .f. ))
	
	Pergunte("FIN240",.f.)

	cDir		:=	Alltrim(cDir) + iif( Right(Alltrim(cDir),01) == "\" , "" , "\" )
	cArq		:=	cDir + xEmp + cBor   
	cCfg		:=	iif( SA6->(FieldPos('A6_ZZAQCNF')) <> 0 , Upper(Alltrim(SA6->A6_ZZAQCNF)) , "" )
	
	if	Empty(cCfg) .and. SA6->A6_COD == "001"
		cCfg	:=	"BB.PAG"
	elseif	Empty(cCfg) .and. SA6->A6_COD == "033"
		cCfg	:=	"SANTANDER.PAG"
	elseif	Empty(cCfg) .and. SA6->A6_COD == "104"
		cCfg	:=	"CEF.PAG"
	elseif	Empty(cCfg) .and. SA6->A6_COD == "237"
		cCfg	:=	"BRADESCO.PAG"
	elseif	Empty(cCfg) .and. SA6->A6_COD == "341"
		cCfg	:=	"ITAU.PAG"
	elseif	Empty(cCfg) .and. SA6->A6_COD == "422"
		cCfg	:=	"SAFRA.PAG"
	endif       
	
	mv_par01 			:=	cBor
	mv_par02			:=	mv_par01
	mv_par03			:=	cCfg
	mv_par04			:=	cArq + "." + iif( Empty(SEE->EE_EXTEN) , "txt" , SEE->EE_EXTEN )
	
	Private cLote		:=	Nil
	Private cPadrao 	:=	Nil
	Private cMarca   	:=	Nil
	Private cBenef		:=	Nil
	Private cBanco   	:=	Nil
	Private cConta 		:=	Nil
	Private cFil240		:=	Nil
	Private aRotina 	:=	Nil
	Private nTotAGer 	:=	Nil
	Private nTotAMul 	:=	Nil
	Private nTotAJur 	:=	Nil
	Private aGetMark 	:=	Nil
	Private cAgencia 	:=	Nil
	Private cCtBaixa 	:=	Nil
	Private cAgen240 	:=	Nil
	Private cModPgto  	:=	Nil
	Private cTipoPag 	:=	Nil
	Private cLoteFin	:=	Nil
	Private c240FilBt 	:=	Nil
	Private cConta240	:=	Nil
	Private nTotADesp	:=	Nil
	Private nTotADesc	:=	Nil
	Private xConteudo	:=	Nil
	Private cCadastro	:=	Nil
	Private nValPadrao	:=	Nil
	Private nValEstrang	:=	Nil
	
	cLote				:=	Nil
	cFil240				:=	Nil
	xConteudo			:=	Nil	
	cCadastro			:=	Nil
	
	nTotAGer 			:= 	000
	nTotAMul 			:= 	000
	nTotAJur 			:= 	000
	nTotADesp			:= 	000
	nTotADesc			:= 	000
	nValPadrao			:= 	000
	nValEstrang			:= 	000          
	
	cPadrao 			:= 	""
	aGetMark 			:= 	{}
	
	cMarca   			:= 	GetMark()
	cLoteFin			:= 	Space(04)
	c240FilBt 			:= 	Space(60)
	cCtBaixa 			:= 	GetMv("MV_CTBAIXA")

	cBenef				:= 	CriaVar("E5_BENEF")
	cBanco   			:= 	CriaVar("E1_PORTADO")
	cConta 				:= 	CriaVar("E1_CONTA")
	cAgencia 			:= 	CriaVar("E1_AGEDEP")
	cAgen240 			:= 	CriaVar("A6_AGENCIA")
	cModPgto  			:= 	CriaVar("EA_MODELO")
	cTipoPag 			:= 	CriaVar("EA_TIPOPAG")
	cConta240			:= 	CriaVar("A6_NUMCON")
	aRotina 			:= 	MenuDef()

	Processa( { || SisPagGer("SE2") } )
	
	SEE->(dbsetorder(1))
	SEE->(dbgotop())
	SEE->(dbseek( xFilial("SEE") + cBco + cAge + cCon , .f. ))
	
	xArq :=	cArq + "." + Trim(SEE->EE_EXTEN)
	
	if	File(mv_par04)
		aRet[2] :=	mv_par04
	elseif	File(xArq)
		aRet[2] :=	xArq
	else
		Inkey(3)
		if	File(mv_par04)
			aRet[2] :=	mv_par04
		elseif	File(xArq)
			aRet[2] :=	xArq
		else
			Inkey(3)
			if	File(mv_par04)
				aRet[2] :=	mv_par04
			elseif	File(xArq)
				aRet[2] :=	xArq
			else
				aRet[1] :=	2
			endif
		endif
	endif
else
	aRet[1] :=	1
endif

cFilAnt := xFilAnt

Return ( aRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetDir()

Local xTGet0 	:= 	cGetFile( "Todos (*.*)|*.*|" , "Pesquisa arquivos" , 0 , Nil , .t. , GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE + GETF_RETDIRECTORY ) 
Local xTGet1 	:= 	Alltrim(xTGet0)

if	Substr(xTGet1,Len(xTGet1),01) <> "\"
	xTGet1 += "\"
endif

Return ( xTGet1 )    

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xChkTrib(nTipo)

Local lOk			:=	.f.   
Local nRet			:=	000  
Local nRadio		:=	000
Local oRadio		:=	Nil
Local oDlgAlt		:=	Nil

Default nTipo		:=	002

do while .t.
	lOk := .f.
	if	nTipo == 1
		Define MsDialog oDlgAlt From  000,000 To 225,292 Title ( "Informe o Imposto Sem C๓digo de Barras" ) Pixel 
		@ 005,007 To 095,140 Of oDlgAlt  Pixel	
//		@ 011,010 Radio oRadio Var nRadio Items "Gps","Darf","Darf Simples","DARJ","Gare - SP","Ipva","Dpvat","Fgts"					3D Size 100,010 Of oDlgAlt Pixel
		@ 011,010 Radio oRadio Var nRadio Items "Gps","Darf","Darf Simples","DARJ","Gare - SP","Ipva","Dpvat"        					3D Size 100,010 Of oDlgAlt Pixel
		Define sButton From 098,115 Type 1 Enable Of oDlgAlt Action ( lOk := .t. , oDlgAlt:End() )
		Activate MsDialog oDlgAlt Centered 
	else
		Define MsDialog oDlgAlt From  000,000 To 245,292 Title ( "Informe o Imposto" ) Pixel 
		@ 005,007 To 105,140 Of oDlgAlt  Pixel	
		@ 011,010 Radio oRadio Var nRadio Items "Gps","Darf","Darf Simples","DARJ","Gare - SP","Ipva","Dpvat","Fgts","Outros Tributos"	3D Size 100,010 Of oDlgAlt Pixel
		Define sButton From 108,115 Type 1 Enable Of oDlgAlt Action ( lOk := .t. , oDlgAlt:End() )
		Activate MsDialog oDlgAlt Centered 
	endif
	if	lOk
		nRet := nRadio
		Exit
	endif
enddo
	
Return ( nRet ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function GeraCNAB(aArray,oGrid)

Local s
Local t
Local cQuery	

Local nPos    	:=	00 
Local aRet		:=	{}
Local aNumBor	:=	{}    
Local lContin	:=	.f.
Local xFilAnt	:=	cFilAnt
Local cBordero	:=	fGetNumBor()          		

if !Empty(cBordero)

	nPos := aScan( aArray , { |x| x[SE2->(FieldPos("E2_NUMBOR"))] == cBordero } )

	if	nPos == 0 
		MessageBox("Border๔ informado nใo encontrado nos itens listados","Aten็ใo",MB_ICONHAND) 
	else 
		if 	FwModeAccess("SE2") == "E" .or. !Empty(aArray[nPos,SE2->(FieldPos("E2_FILIAL"))])
			cFilAnt := aArray[nPos,SE2->(FieldPos("E2_FILIAL"))]
		else
			cFilAnt := aArray[nPos,SE2->(FieldPos("E2_FILORIG"))]
		endif

		SA6->(dbseek( xFilial("SA6") + aArray[nPos,nPosBco] + aArray[nPos,nPosAge] + aArray[nPos,nPosCon] , .f. ))

		aAdd( aNumBor , { aArray[nPos,nPosBco] , aArray[nPos,nPosAge] , aArray[nPos,nPosCon] , xFilial("SEA") , cBordero , cFilAnt , "" , .f. } )		  

		if	xGerAut			
			aNumBor[Len(aNumBor),7]	:=	Alltrim(SA6->A6_ZZDRGVP)
			aNumBor[Len(aNumBor),8]	:= 	!Empty(Alltrim(SA6->A6_ZZDRGVP))
		endif

		if	aArray[nPos,nGerAut]
			if	File(aArray[nPos,nDirAut])   
				if 	MessageBox("O arquivo de CNAB jแ foi gerado no diret๓rio cadastrado no banco." + CRLF + "Gerar novamente ?","Aten็ใo",MB_YESNO) == 6    	   
					lContin	:=	.t.
				else
					Return
				endif										   
        	else
				if	MessageBox("O arquivo de CNAB jแ foi gerado e nใo foi localizado no diret๓rio cadastrado no banco." + CRLF + "Gerar novamente ?","Aten็ใo",MB_YESNO) == 6    	   
					lContin	:=	.t.
				else
					Return
				endif										   
			endif
		endif
		
		if	lContin .or. MessageBox("Gerar o arquivo do border๔ " + Alltrim(cBordero) + " ?","Aten็ใo",MB_YESNO) == 6 
			if	aNumBor[Len(aNumBor),8] .and. !Empty(aNumBor[Len(aNumBor),7])
				cDir := aNumBor[Len(aNumBor),7]
			else
				cDir := xRetDir()    
			endif			
			if	Empty(cDir)		
	    		MessageBox("Diret๓rio nใo informado. Nใo serใo gerados os arquivos de CNAB.","Aten็ใo",MB_ICONHAND)
			elseif	lContin .or. !aNumBor[Len(aNumBor),8] .or. MessageBox("Serแ gerado o arquivo diretamente no diret๓rio cadastrado no banco." + CRLF + "Confirma ?","Aten็ใo",MB_YESNO) == 6    	   
				if	ExistDir(cDir)						
					For t := 1 to Len(aNumBor)

						if	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF)     .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA001" .and. lGera001
							FwMsgRun( Nil , { || aRet	:=	U_xGera001(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP)	 			} , 'Processando' , "Gerando arquivo CNAB (001)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA001"
							FwMsgRun( Nil , { || aRet	:=	  xGera001(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (001)" )	

						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA033" .and. lGera033
							FwMsgRun( Nil , { || aRet	:=	U_xGera033(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP)	 			} , 'Processando' , "Gerando arquivo CNAB (033)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA033"
							FwMsgRun( Nil , { || aRet	:=	  xGera033(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (033)" )	

						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA104" .and. lGera104
							FwMsgRun( Nil , { || aRet	:=	U_xGera104(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (104)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA104"
							FwMsgRun( Nil , { || aRet	:=	  xGera104(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (104)" )	

						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA237" .and. lGera237
							FwMsgRun( Nil , { || aRet	:=	U_xGera237(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP)	 			} , 'Processando' , "Gerando arquivo CNAB (237)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA237"
							FwMsgRun( Nil , { || aRet	:=	  xGera237(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (237)" )	

						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA341" .and. lGera341
							FwMsgRun( Nil , { || aRet	:=	U_xGera341(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP)	 			} , 'Processando' , "Gerando arquivo CNAB (341)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA341"
							FwMsgRun( Nil , { || aRet	:=	  xGera341(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (341)" )	

						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA422" .and. lGera422
							FwMsgRun( Nil , { || aRet	:=	U_xGera422(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (422)" )	
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. !Empty(SA6->A6_ZZAQCNF) .and. Upper(Alltrim(SA6->A6_ZZAQCNF)) == "XGERA422"
							FwMsgRun( Nil , { || aRet	:=	  xGera422(aNumBor[t],cDir,.f.,Nil,SA6->A6_ZZSUBP) 				} , 'Processando' , "Gerando arquivo CNAB (422)" )	
		
						elseif	SA6->(FieldPos('A6_ZZAQCNF')) <> 0 	.and. ;
								SA6->(FieldPos('A6_ZZSUBP'))  <> 0 	.and. ;
								!Empty(SA6->A6_ZZAQCNF) 			.and. ;
								!Empty(SA6->A6_ZZSUBP)
							FwMsgRun( Nil , { || aRet	:=	xGeraSis(aNumBor[t],cDir) 					} , 'Processando' , "Gerando arquivo CNAB" )	
						else
							FwMsgRun( Nil , { || aRet	:=	xGeraSis(aNumBor[t],cDir) 					} , 'Processando' , "Gerando arquivo CNAB" )	
						endif                           
										
						if	aRet == Nil
							aRet := {2,''}
						endif      
						
						if	aRet[01] == 0
							aNumBor[t,7] := aRet[02]
						elseif	aRet[01] == 2
							MessageBox("Nใo foi possํvel a cria็ใo do arquivo de CNAB referente ao border๔ " + aNumBor[t,5],"Aten็ใo",MB_ICONHAND)
						endif      
						
						if	aNumBor[t,8]   
							if 	FwModeAccess("SE2") == "E" .or. FwModeAccess("SA2") == "E" .or. FwModeAccess("SA6") == "E"
								cFilAnt	:= 	aNumBor[t,6]	
							endif
							For s := 1 to Len(aArray)					
								if	aArray[s,SE2->(FieldPos("E2_NUMBOR"))] == aNumBor[t,05]
									aArray[s,nGerAut] 	:=	.t.
									aArray[s,nDirAut] 	:= 	aNumBor[t,07]   
								endif
							Next s 					
							cQuery	:=	" UPDATE " + RetSqlName("SEA")
							cQuery	+=	" SET   EA_ZZARQGR = '" + aNumBor[t,07] 	+ "' ,   " 
							cQuery	+=		"   EA_ZZUSR   = '" + RetCodUsr()   	+ "'     " 
							cQuery	+=	" WHERE EA_FILIAL  = '" + xFilial("SEA") 	+ "' AND "
							cQuery	+=		"   EA_NUMBOR  = '" + aNumBor[t,05] 	+ "' AND "
							cQuery	+=		"   EA_CART    = 'P'                         AND "
							cQuery	+=		"   D_E_L_E_T_ = ' '                             "
							TcSqlExec(cQuery)   
							oGrid:Refresh()
						endif   					
						
					Next t 	
				else
		    		MessageBox("Diret๓rio nใo existe. Nใo serใo gerados os arquivos de CNAB.","Aten็ใo",MB_ICONHAND)
				endif
			endif
		endif	
	endif
endif

cFilAnt := xFilAnt 

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
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
	xTGet1	:=	CriaVar("E2_NUMBOR",.f.)
endif

Return ( xTGet1 )                                                                        

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
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
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xIpvaDpVat(nOpcao,lDsv)

Local lOk			:=	.f.
Local aRet			:=	{}

Local oUF         	:= 	Nil
Local oAno        	:= 	Nil
Local oMun        	:= 	Nil
Local oPlaca      	:= 	Nil
Local oCombo      	:= 	Nil
Local oRenavan		:= 	Nil
Local oDlgIpva		:=	Nil						

Local oTButton1		:=	Nil						
Local oTButton2		:=	Nil						
Local oTButton3		:=	Nil						

Local xUF         	:= 	SE2->E2_ZZESTVC
Local xAno        	:= 	SE2->E2_ANOBASE
Local xMun        	:= 	SE2->E2_ZZCODMN
Local xPlaca      	:= 	SE2->E2_ZZPLACA
Local xRenavan		:= 	SE2->E2_ZZRENAV

Local cStats		:=	''   
Local aStats		:=	{}  

Local bOk			:=	{ || lOk := .t. , oDlgIpva:End() }
Local bNo			:=	{ || lOk := .f. , oDlgIpva:End() }
Local bDv			:=	{ || lOk := Nil , oDlgIpva:End() }
Local oFont 		:= 	tFont():New("Verdana",,14,.t.)

Default lDsv		:=	.f.
Default nOpcao		:=	002

Private xEstPlc		:=	""

if	nOpcao == 1
	aAdd( aStats , '0 - DPVAT' )
else
	aAdd( aStats , '1 - Parc. Unica c/ Desc.' )
	aAdd( aStats , '2 - Parc. Unica s/ Desc.' )
	aAdd( aStats , '3 - Parc. 01            ' )
	aAdd( aStats , '4 - Parc. 02            ' )
	aAdd( aStats , '5 - Parc. 03            ' )
	aAdd( aStats , '6 - Parc. 04            ' )
	aAdd( aStats , '7 - Parc. 05            ' )
	aAdd( aStats , '8 - Parc. 06            ' )
endif

////////////////////////////////////////////  SE2->E2_ZZOPPGT

fChecaSXB()

Define Dialog oDlgIpva Title "Dados do Veํculo - " + iif( nOpcao == 1 , "DPVAT" , "IPVA" ) From 000,000 To 218,290 Pixel 

@ 007,005 Say "Renavan :"	  	Font oFont						Pixel					Color CLR_BLUE        
@ 022,005 Say "Placa  :" 		Font oFont						Pixel					Color CLR_BLUE		               
@ 037,005 Say "UF :" 			Font oFont						Pixel 					Color CLR_BLUE
@ 052,005 Say "Municํpio :"		Font oFont 						Pixel					Color CLR_BLUE
@ 067,005 Say "Ano :"			Font oFont 						Pixel					Color CLR_BLUE
@ 082,005 Say "Op็ใo :"			Font oFont 						Pixel					Color CLR_BLUE

@ 005,055 MsGet oRenavan 		Var xRenavan					Pixel					Picture	"@R 999999999999"	When .t. 	Size 86,08	 
@ 020,055 MsGet oPlaca  		Var xPlaca   		   			Pixel					Picture "@!R AAA-9999"		When .t. 	Size 86,08
@ 035,055 MsGet oUF       		Var xUF     	         		Pixel 	F3 '12'			Picture	"@!"				When .t.	Size 40,08	Valid xValCpos(01,xUF,Nil)
@ 050,055 MsGet oMun      		Var xMun    	         		Pixel 	F3 'CC2PPG'		Picture "@!"				When .t.	Size 50,08	Valid xValCpos(02,xUF,xMun)
@ 065,055 MsGet oAno      		Var xAno    	         		Pixel 	           		Picture "@R 9999"			When .t.	Size 40,08	Valid Val(xAno) >= 2000
@ 080,055 ComboBox oCombo     	Var cStats		Items aStats	Pixel					             				When .t. 	Size 86,10	

oTButton1		:=	tButton():New(095,052,"Ok"				,oDlgIpva,{ || Eval(bOk) 	},042,010,,,.f.,.t.,.f.,,.f.,,,.f.)  
oTButton2		:=	tButton():New(095,099,"Sair"			,oDlgIpva,{ || Eval(bNo) 	},042,010,,,.f.,.t.,.f.,,.f.,,,.f.)  
oTButton3		:=	tButton():New(095,005,"Desvincular"		,oDlgIpva,{ || Eval(bDv) 	},042,010,,,.f.,.t.,.f.,,.f.,,,.f.)  

if	!lDsv	
	oTButton3:Disable()
endif

Activate MsDialog oDlgIpva Centered 

if	lOk == Nil
	aRet	:=	{ 2 }
elseif	lOk
	aRet	:=	{ 1 , xRenavan , xPlaca , xUF , xMun , xAno , cStats }
else
	aRet	:=	{ 0 }
endif

Return ( aRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xValCpos(nOpcao,xCont1,xCont2)

Local lRet	:=	.f.

if	nOpcao == 1
	lRet 	:= 	ExistCpo("SX5","12" + xCont1)
	xEstPlc	:=	xCont1     
	if	lRet
		if	xCont1	$ "SP/MG/RJ"
			lRet := .t. 
		else
			lRet := .f.
			MessageBox("S๓ podem ser pago por CNAB os IPVA/DPVAT dos estados de SP/MG/RJ","Aten็ใo",MB_ICONHAND) 
		endif
	endif
else
	lRet 	:= 	ExistCpo("CC2",xCont1 + xCont2)
endif

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function fChecaSXB()

Local w  
Local s
Local aRec		:=	{}
Local aStruct	:=	SXB->(dbstruct())

if	!SXB->(dbsetorder(1),dbseek( PadR('CC2PPG',Len(SXB->XB_ALIAS)) , .f. ))
	if	SXB->(dbsetorder(1),dbseek( PadR('CC2SA2',Len(SXB->XB_ALIAS)) , .f. ))
		do while SXB->(!Eof()) .and. SXB->XB_ALIAS == PadR('CC2SA2',Len(SXB->XB_ALIAS))  
			if	Upper(Alltrim(SXB->XB_TIPO)) == "5" .and. Upper(Alltrim(SXB->XB_TIPO)) == "02"
				SXB->(dbskip())
				Loop
			endif		
			if	Upper(Alltrim(SXB->XB_TIPO)) == "6" .and. Upper(Alltrim(SXB->XB_TIPO)) <> "01"
				SXB->(dbskip())
				Loop
			endif		
			aAdd( aRec , Array(Len(aStruct)) )
			For w := 1 to Len(aStruct)
				aRec[Len(aRec),w] := &("SXB->" + Alltrim(aStruct[w,01]))
			Next w
			SXB->(dbskip())
		enddo
	endif
endif

if	Len(aRec) <> 0 
	For s := 1 to Len(aRec)	
		RecLock("SXB",.t.)
		For w := 1 to Len(aStruct)
			&("SXB->" + Alltrim(aStruct[w,01]))	:=	aRec[s,w] 
		Next w
    	SXB->XB_ALIAS := 'CC2PPG'	
		if	Val(SXB->XB_TIPO) == 6	
			SXB->XB_CONTEM	:=	"CC2->CC2_EST == xEstPlc"
		endif                                                 
		MsUnlock("SXB")
	Next s
endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetBcoPad(xCod,nTamBco,nTamAge,nTamCta)

Local aRet	:=	{}
Local xBco	:=	""
Local xAge	:=	""
Local xCta	:=	""

xBco		:=	Substr(xCod,01,nTamBco)
xCod		:=	Substr(xCod,nTamBco + 2)
xAge		:=	Substr(xCod,01,nTamAge)
xCod		:=	Substr(xCod,nTamAge + 2)
xCta		:=	PadR(xCod,nTamCta)

if	xValidBco(xBco,xAge,xCta,.f.)
	aAdd( aRet , xBco ) 
	aAdd( aRet , xAge ) 
	aAdd( aRet , xCta ) 
endif

Return ( aRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGareSP(lDsv)

Local lOk			:=	.f.
Local aRet			:=	{}

Local oCNPJ       	:= 	Nil						
Local oCodRec     	:= 	Nil						
Local oInsEst     	:= 	Nil						
Local oDivAtv     	:= 	Nil						
Local oMesAno 		:= 	Nil						
Local oAimPar 		:= 	Nil						
Local oVlrPri 		:= 	Nil						
Local oVlrJur 		:= 	Nil						
Local oVlrMul 		:= 	Nil						
Local oVlrAcF 		:= 	Nil						
Local oVlrHAd 		:= 	Nil						
Local oVlrTot 		:= 	Nil						
Local oDlgGare     	:= 	Nil						

Local oTButton1		:=	Nil						
Local oTButton2		:=	Nil						
Local oTButton3		:=	Nil						

Local xCNPJ       	:= 	SE2->E2_ZZCNPJ
Local xVlrPri 		:= 	SE2->E2_ZZVLPR 
Local xVlrJur 		:= 	SE2->E2_ZZVLJR 
Local xVlrMul 		:= 	SE2->E2_ZZVLMT 
Local xVlrAcF 		:= 	SE2->E2_ZZVLAF 
Local xVlrHAd 		:= 	SE2->E2_ZZVLHA 
Local xCodRec     	:= 	SE2->E2_ZZCGARE
Local xInsEst     	:= 	SE2->E2_ZZINEST
Local xDivAtv     	:= 	SE2->E2_ZZDVATV
Local xMesAno 		:= 	SE2->E2_ZZREFMA
Local xAimPar 		:= 	SE2->E2_ZZAIMPR
Local xVlrTot 		:= 	SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC)

Local bOk			:=	{ || lOk := .t. , iif( xValGare(xCodRec,xInsEst,xCNPJ,xMesAno,xVlrPri,xVlrJur,xVlrMul,xVlrAcF,xVlrHAd,xVlrTot) , oDlgGare:End() , lOk := .f. )	}
Local bNo			:=	{ || lOk := .f. , oDlgGare:End() 																					}
Local bDv			:=	{ || lOk := Nil , oDlgGare:End() 																					}
Local oFont 		:= 	tFont():New("Verdana",,14,.t.)

Default lDsv		:=	.f.

Define Dialog oDlgGare Title "Gare - SP" From 000,000 To 398,290 Pixel 

@ 007,005 Say "Cod. Receita :"		Font oFont						Pixel	Color CLR_BLUE        
@ 022,005 Say "Ins. Estadual :"		Font oFont						Pixel	Color CLR_BLUE		               
@ 037,005 Say "CNPJ :" 				Font oFont						Pixel 	Color CLR_BLUE
@ 052,005 Say "Ins. Div. Ativa :"	Font oFont 						Pixel	
@ 067,005 Say "Refer๊ncia :"		Font oFont 						Pixel	Color CLR_BLUE
@ 082,005 Say "AIM ou Parc. :"		Font oFont 						Pixel	
@ 097,005 Say "Valor :"     		Font oFont 						Pixel	Color CLR_BLUE
@ 112,005 Say "Juros :"     		Font oFont 						Pixel	
@ 127,005 Say "Multa :"     		Font oFont 						Pixel	
@ 142,005 Say "Acr. Financeiro :"  	Font oFont 						Pixel	
@ 157,005 Say "Honorแrios :"  		Font oFont 						Pixel	
@ 172,005 Say "Total :"     		Font oFont 						Pixel	Color CLR_BLUE

@ 005,055 MsGet oCodRec 			Var xCodRec						Pixel	Picture	"@r 999-9"       			When .t. 	Size 86,08	Valid Empty(xCodRec)	.or. Len(Alltrim(xCodRec)) == 4	 
@ 020,055 MsGet oInsEst  			Var xInsEst   		   			Pixel	Picture "@r 999.999.999.999"		When .t. 	Size 86,08	//Valid Empty(xInsEst) 	.or. IE(xInsEst,"SP") 
@ 035,055 MsGet oCNPJ      			Var xCNPJ     	         		Pixel 	Picture	"@r 99.999.999/9999-99"		When .t.	Size 86,08	Valid Empty(xCNPJ) 		.or. CGC(xCNPJ)
@ 050,055 MsGet oDivAtv    			Var xDivAtv    	         		Pixel 	Picture "@!"						When .t.	Size 86,08	
@ 065,055 MsGet oMesAno    			Var xMesAno    	         		Pixel 	Picture "@r 99/9999"				When .t.	Size 86,08	Valid Empty(xMesAno)	.or. ( Len(Alltrim(xMesAno)) == 6 .and. Val(Substr(xMesAno,01,02)) >= 01 .and. Val(Substr(xMesAno,01,02)) <= 12 .and. Val(Substr(xMesAno,03)) >= 2000 )
@ 080,055 MsGet oAimPar    			Var xAimPar    	         		Pixel 	Picture "@!"						When .t.	Size 86,08	
@ 095,055 MsGet oVlrPri 			Var xVlrPri						Pixel	Picture	PesqPict("SE2","E2_VALOR")	When .t. 	Size 86,08	Valid xVlrPri >= 0		 
@ 110,055 MsGet oVlrJur  			Var xVlrJur   		   			Pixel	Picture PesqPict("SE2","E2_VALOR")	When .t. 	Size 86,08	Valid xVlrJur >= 0		 
@ 125,055 MsGet oVlrMul      		Var xVlrMul     	         	Pixel 	Picture	PesqPict("SE2","E2_VALOR")	When .t.	Size 86,08	Valid xVlrMul >= 0		 
@ 140,055 MsGet oVlrAcF    			Var xVlrAcF    	         		Pixel 	Picture PesqPict("SE2","E2_VALOR")	When .t.	Size 86,08	Valid xVlrAcF >= 0		 
@ 155,055 MsGet oVlrHAd    			Var xVlrHAd    	         		Pixel 	Picture PesqPict("SE2","E2_VALOR")	When .t.	Size 86,08	Valid xVlrHAd >= 0		 
@ 170,055 MsGet oVlrTot    			Var xVlrTot    	         		Pixel 	Picture PesqPict("SE2","E2_VALOR")	When .f.	Size 86,08	

oTButton1	:=	tButton():New( 185 , 052 , "Ok"				, oDlgGare , { || Eval(bOk) 	} , 042 , 010 , , , .f. , .t. , .f. , , .f. , , , .f. )  
oTButton2	:=	tButton():New( 185 , 099 , "Sair"			, oDlgGare , { || Eval(bNo) 	} , 042 , 010 , , , .f. , .t. , .f. , , .f. , , , .f. )  
oTButton3	:=	tButton():New( 185 , 005 , "Desvincular"	, oDlgGare , { || Eval(bDv) 	} , 042 , 010 , , , .f. , .t. , .f. , , .f. , , , .f. )  

if !lDsv	
	oTButton3:Disable()
endif

Activate MsDialog oDlgGare Centered 

if	lOk == Nil
	aRet	:=	{ 2 }
elseif	lOk
	aRet	:=	{ 1 , xCodRec , xInsEst , xCNPJ , xDivAtv , xMesAno , xAimPar , xVlrPri , xVlrJur , xVlrMul , xVlrAcF , xVlrHAd }
else
	aRet	:=	{ 0 }
endif

Return ( aRet )           

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xValGare(xCodRec,xInsEst,xCNPJ,xMesAno,xVlrPri,xVlrJur,xVlrMul,xVlrAcF,xVlrHAd,xVlrTot)

Local lRet	:=	.f.

if	Empty(xCodRec)
	MessageBox("Preencha o C๓digo da Receita","Aten็ใo",MB_ICONHAND) 	
elseif	Empty(xInsEst)
	MessageBox("Preencha a Inscri็ใo Estadual","Aten็ใo",MB_ICONHAND) 	
elseif	Empty(xCNPJ)
	MessageBox("Preencha o CNPJ","Aten็ใo",MB_ICONHAND) 	
elseif	Empty(xMesAno)
	MessageBox("Preencha a Refer๊ncia","Aten็ใo",MB_ICONHAND) 	
elseif	( xVlrPri + xVlrJur + xVlrMul + xVlrAcF + xVlrHAd ) <> xVlrTot
	MessageBox("A somat๓ria dos valores informados nใo ้ igual ao valor total","Aten็ใo",MB_ICONHAND) 	
else
	lRet	:=	.t.
endif

Return ( lRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xDARJ(lDsv)

Local lOk			:=	.f.
Local aRet			:=	{}

Local oCNPJ       	:= 	Nil						
Local oCodRec     	:= 	Nil						
Local oInsEst     	:= 	Nil						
Local oDocOri     	:= 	Nil						
Local oMesAno 		:= 	Nil						
Local oVlrPri 		:= 	Nil						
Local oVlrJur 		:= 	Nil						
Local oVlrMul 		:= 	Nil						
Local oVlrAcF 		:= 	Nil						
Local oVlrTot 		:= 	Nil						
Local oDlgGare     	:= 	Nil						

Local oTButton1		:=	Nil						
Local oTButton2		:=	Nil						
Local oTButton3		:=	Nil						

Local xCNPJ       	:= 	SE2->E2_ZZCNPJ
Local xVlrPri 		:= 	SE2->E2_ZZVLPR 
Local xVlrJur 		:= 	SE2->E2_ZZVLJR 
Local xVlrMul 		:= 	SE2->E2_ZZVLMT 
Local xVlrAcF 		:= 	SE2->E2_ZZVLAF 
Local xInsEst     	:= 	SE2->E2_ZZINEST
Local xCodRec     	:= 	SE2->E2_ZZCGARE
Local xDocOri     	:= 	SE2->E2_ZZDORRJ
Local xMesAno 		:= 	SE2->E2_ZZREFMA
Local xVlrTot 		:= 	SE2->(E2_SALDO+E2_ACRESC-E2_DECRESC)

Local bOk			:=	{ || lOk := .t. , iif( xValGare(xCodRec,xInsEst,xCNPJ,xMesAno,xVlrPri,xVlrJur,xVlrMul,xVlrAcF,0,xVlrTot) , oDlgGare:End() , lOk := .f. )	}
Local bNo			:=	{ || lOk := .f. , oDlgGare:End() 																					}
Local bDv			:=	{ || lOk := Nil , oDlgGare:End() 																					}
Local oFont 		:= 	tFont():New("Verdana",,14,.t.)

Default lDsv		:=	.f.

Define Dialog oDlgGare Title "DARJ" From 000,000 To 338,290 Pixel 

@ 007,005 Say "Ins. Estadual :"		Font oFont						Pixel	Color CLR_BLUE		               
@ 022,005 Say "Cod. Receita :"		Font oFont						Pixel	Color CLR_BLUE        
@ 037,005 Say "CNPJ :" 				Font oFont						Pixel 	Color CLR_BLUE
@ 052,005 Say "Doc. Origem :"    	Font oFont 						Pixel	
@ 067,005 Say "Per. Refer๊ncia :"	Font oFont 						Pixel	Color CLR_BLUE
@ 082,005 Say "Valor :"     		Font oFont 						Pixel	Color CLR_BLUE
@ 097,005 Say "Atu. Monetแria :"   	Font oFont 						Pixel	
@ 112,005 Say "Mora :"     			Font oFont 						Pixel	
@ 127,005 Say "Multa :"     		Font oFont 						Pixel	
@ 142,005 Say "Total :"     		Font oFont 						Pixel	Color CLR_BLUE

@ 005,055 MsGet oInsEst  			Var xInsEst   		   			Pixel	Picture "@r 99.999.99-9"    		When .t. 	Size 86,08	//Valid Empty(xInsEst) 	.or. IE(xInsEst,"RJ") 
@ 020,055 MsGet oCodRec 			Var xCodRec						Pixel	Picture	"@r 999-9"       			When .t. 	Size 86,08	Valid Empty(xCodRec)	.or. Len(Alltrim(xCodRec)) == 4	 
@ 035,055 MsGet oCNPJ      			Var xCNPJ     	         		Pixel 	Picture	"@r 99.999.999/9999-99"		When .t.	Size 86,08	Valid Empty(xCNPJ) 		.or. CGC(xCNPJ)
@ 050,055 MsGet oDocOri    			Var xDocOri    	         		Pixel 	Picture "@!"						When .t.	Size 86,08	
@ 065,055 MsGet oMesAno    			Var xMesAno    	         		Pixel 	Picture "@r 99/9999"				When .t.	Size 86,08	Valid Empty(xMesAno)	.or. ( Len(Alltrim(xMesAno)) == 6 .and. Val(Substr(xMesAno,01,02)) >= 01 .and. Val(Substr(xMesAno,01,02)) <= 12 .and. Val(Substr(xMesAno,03)) >= 2000 )
@ 080,055 MsGet oVlrPri 			Var xVlrPri						Pixel	Picture	PesqPict("SE2","E2_VALOR")	When .t. 	Size 86,08	Valid xVlrPri >= 0		 
@ 095,055 MsGet oVlrAcF    			Var xVlrAcF    	         		Pixel 	Picture PesqPict("SE2","E2_VALOR")	When .t.	Size 86,08	Valid xVlrAcF >= 0		 
@ 110,055 MsGet oVlrJur  			Var xVlrJur   		   			Pixel	Picture PesqPict("SE2","E2_VALOR")	When .t. 	Size 86,08	Valid xVlrJur >= 0		 
@ 125,055 MsGet oVlrMul      		Var xVlrMul     	         	Pixel 	Picture	PesqPict("SE2","E2_VALOR")	When .t.	Size 86,08	Valid xVlrMul >= 0		 
@ 140,055 MsGet oVlrTot    			Var xVlrTot    	         		Pixel 	Picture PesqPict("SE2","E2_VALOR")	When .f.	Size 86,08	

oTButton1	:=	tButton():New( 155 , 052 , "Ok"				, oDlgGare , { || Eval(bOk) 	} , 042 , 010 , , , .f. , .t. , .f. , , .f. , , , .f. )  
oTButton2	:=	tButton():New( 155 , 099 , "Sair"			, oDlgGare , { || Eval(bNo) 	} , 042 , 010 , , , .f. , .t. , .f. , , .f. , , , .f. )  
oTButton3	:=	tButton():New( 155 , 005 , "Desvincular"	, oDlgGare , { || Eval(bDv) 	} , 042 , 010 , , , .f. , .t. , .f. , , .f. , , , .f. )  

if !lDsv	
	oTButton3:Disable()
endif

Activate MsDialog oDlgGare Centered 

if	lOk == Nil
	aRet	:=	{ 2 }
elseif	lOk
	aRet	:=	{ 1 , xCodRec , xInsEst , xCNPJ , xDocOri , xMesAno , xVlrPri , xVlrJur , xVlrMul , xVlrAcF }
else
	aRet	:=	{ 0 }
endif

Return ( aRet )           

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGera001(aPar,cDir,lAlert,xDir,cSub) 

Return ( U_xGera001(@aPar,@cDir,@lAlert) ) 
                                                                 
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGera033(aPar,cDir,lAlert,xDir,cSub) 

Return ( U_xGera033(aPar,cDir,lAlert) ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGera104(aPar,cDir,lAlert,xDir,cSub) 

Return ( U_xGera104(aPar,cDir,lAlert) ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGera237(aPar,cDir,lAlert,xDir,cSub) 

Return ( U_xGera237(aPar,cDir,lAlert) ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGera341(aPar,cDir,lAlert,xDir,cSub) 

Return ( U_xGera341(@aPar,@cDir,@lAlert) ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xGera422(aPar,cDir,lAlert,xDir,cSub) 

Return ( U_xGera422(@aPar,@cDir,@lAlert) ) 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xChecaVar()

if	lCCL == Nil	
	lCCL  		:=	ChecaEmp("CCL") 
	lAdoro		:=	ChecaEmp("ADORO") 
	lFadel		:=	ChecaEmp("FADEL") 
	lMando		:=	ChecaEmp("MANDO") 
	lCheck		:=	ChecaEmp("CHECKP") 
	lMastra		:=	ChecaEmp("MASTRA") 
endif
	
Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xDispMail(cPara,cHtml,cAssunto,cDe,aAnexos,cCc,cBcc)

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
		nA			:= 	At("@",cEmail)
		cUser 		:= 	iif( nA > 0 , Substr(cEmail,01,nA-1) , cEmail )
		lResult		:= 	MailAuth(Alltrim(cUser), Alltrim(cPass))
		lResulSend	:=	lResult
	endif
endif

if 	lResult
	lResulSend	:= 	MailSend(cDe,{cPara},{cCc},{cBcc},cAssunto,cMsg,aAnexos,.t.)
	if 	!lResulSend
		cError	:= 	MailGetErr()
	endif
endif

MailSmtpOff()

Return ( lResulSend )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
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
	if	Empty(cFiltro)	
		lFiltrar	:=	.f.	
	else
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
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
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
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xMailPenDC(aArray,cPara,cCCO,cCC) ; fMailPen(Nil,Nil,aArray,cPara,cCCO,cCC) ; Return 

Static Function fMailPen(oDlg,oGrid,aArray,cPara,cCCO,cCC)

Local t

Local lOk		:=	.f.
Local lPriVez	:=	.t.

Local aTmp		:=	aClone(aArray)
Local oObj		:= 	GeneralClass():New()      
Local aArea		:=	SM0->(GetArea())  		

Local nVal		:=	0
Local cNome		:=	""
Local cHtml		:=	""   
Local dData		:=	CtoD("")

Local cSMTP		:=	Alltrim(GetMv("MV_RELSERV"))                                               
Local nSMTPPort	:= 	GetMv("MV_GCPPORT")

Local xPsqSF1	:=	""
Local xFilAnt	:=	cFilAnt
Local lSE2Excl	:=	FwModeAccess("SE2") == "E"     
Local cSubject	:=	"Titulos sem Documentacao Anexada" 
Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 26/05/2023
Default cPara	:=	Space(250)            
Default cCCO	:=	Space(250)
Default cCC		:=	PadR( Alltrim(UsrRetMail(RetCodUsr())) , 250 )

For t := 1 to Len(aTmp) 
	if	aTmp[t,nPosFlg] .and. !aTmp[t,nNfePDF]
		lOk		:=	.t.    
		Exit
	endif
Next t 

if !lOk
	if	lIsBlind
		ConOut("Nao ha documentos sem anexo marcados para envio")
	else
		Alert("Nใo hแ documentos sem anexo marcados para envio")
	endif
	Return
endif
	
if !lIsBlind .and. !oObj:TelaMail(@cPara,@cCC,@cCCO)    
	Return
endif

if	":" $ cSMTP		
	nSMTPPort	:= 	Val(Substr( cSMTP , At(":",cSMTP) + 1 ))
	cSMTP		:=	Substr( cSMTP , 01 , At(":",cSMTP) - 1 )
endif

cHtml	+=	'<html>' 																																															+ CRLF
cHtml	+=	'<title>.:: Totvs Protheus 12 - Tํtulos Sem Documento Anexado ::.</title>'																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<head>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<style>' 																																															+ CRLF
cHtml	+=	'Body {' 																																															+ CRLF
cHtml	+=	'	font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt' 																															+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TableRowBlueDarkMini {' 																																											+ CRLF
cHtml	+=	'	background-color: #E4E4E4; color: #FFCC00; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; vertical-align: center' 														+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TableRowWhiteMini2 {' 																																											+ CRLF
cHtml	+=	'	color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; vertical-align: center' 																					+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.style5 {' 																																														+ CRLF
cHtml	+=	'	color: #19167D; font-weight: bold;' 																																							+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TarjaTopoCor {' 																																													+ CRLF
cHtml	+=	'	text-decoration: none;height: 6px; background-color: #6699CC' 																																	+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.texto-layer {' 																																													+ CRLF
cHtml	+=	'	font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000000; text-decoration: none' 																						+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.titulo {' 																																														+ CRLF
cHtml	+=	'	font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #19167D; text-decoration: none; font-weight: bold;' 																			+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.texto {' 																																															+ CRLF
cHtml	+=	'	font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; text-decoration: none; font-weight: normal;' 																		+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'</style>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<title>Tํtulos sem Documentos Anexados</title>' 																																					+ CRLF
cHtml	+=	'<meta http-equiv="Content-Type" content="text/html; charset=utf-8">' 																																+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'</head>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<body>' 																																															+ CRLF
cHtml	+=	'<table border="0" cellpadding="0" cellspacing="0" height="58" width="90%" align="center">' 																										+ CRLF
cHtml	+=	'  <tbody>' 																																														+ CRLF
cHtml	+=	'    <tr>' 																																															+ CRLF
cHtml	+=	'      <td>'																																														+ CRLF
if	alltrim(cEmpAnt) $ _cEmpAt1 //ticket TI - Antonio Domingos - 31/05/2023 
	cHtml	+=	'        <img style="width: 150px; height: 72px;" src="http://intra.cclind.com.br/Content/images/Logo_CCL_Assinatura.gif" border="0"> '															+ CRLF
elseif	cEmpAnt == "02"
	cHtml	+=	'        <img style="width: 180px; height: 44px;" src="http://intra.cclind.com.br/Content/images/checkpt.png" border="0">'																		+ CRLF
endif
cHtml	+=	'      </td>'																																														+ CRLF
cHtml	+=	'    </tr>' 																																														+ CRLF
cHtml	+=	'  </tbody>' 																																														+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<table width="90%" border="0" cellpadding="0" cellspacing="0" height="58" align="center">' 																										+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td height="72" width="100%">' 																																								+ CRLF
cHtml	+=	'      <p align="center"><font face="Tahoma" size="5">Tํtulos sem Documentos Anexados</font>' 																										+ CRLF
cHtml	+=	'    </td>' 																																														+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td height="1" class="TarjaTopoCor" colspan="3">' 																																				+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF

SM0->(dbgotop())		
do while SM0->(!Eof())
	if	Upper(Alltrim(SM0->M0_CODIGO)) == Upper(Alltrim(cEmpAnt))

		lOk		:=	.f.
		lPriVez	:=	.t.

	    For t := 1 to Len(aTmp)
			if	aTmp[t,nPosFlg] .and. !aTmp[t,nNfePDF]
				if	Upper(Alltrim( iif( lSE2Excl , aTmp[t,SE2->(FieldPos("E2_FILIAL"))] , aTmp[t,SE2->(FieldPos("E2_FILORIG"))] ) )) == Upper(Alltrim(SM0->M0_CODFIL))
					lOk := .t.
					Exit 
				endif
			endif
		Next t 

		if !lOk
			SM0->(dbskip())
			Loop		
		endif

	    For t := 1 to Len(aTmp)

			if	aTmp[t,nPosFlg] .and. !aTmp[t,nNfePDF]
				if	Upper(Alltrim( iif( lSE2Excl , aTmp[t,SE2->(FieldPos("E2_FILIAL"))] , aTmp[t,SE2->(FieldPos("E2_FILORIG"))] ) )) <> Upper(Alltrim(SM0->M0_CODFIL))
					Loop
				endif
		    else
		    	Loop
		    endif
		
			if	lPriVez    
			
				cHtml	+=	'<br>' 																																														+ CRLF
				cHtml	+=	'<br>' 																																														+ CRLF
				cHtml	+=	'<table border="1" width="90%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 										+ CRLF
				cHtml	+=	'  <tr>' 																																													+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="100%" align="center" ><b><span class="style5"><span style="font-size: 9pt">' + SM0->M0_FILIAL + '</span></span></b></td>' 			+ CRLF
				cHtml	+=	'  </tr>' 																																													+ CRLF
				cHtml	+=	'</table>' 																																													+ CRLF
				
				cHtml	+=	'<br>' 																																														+ CRLF
				
				cHtml	+=	'<table border="1" width="90%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 										+ CRLF
				cHtml	+=	'  <tr>' 																																													+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="07%" align="center"><b><span class="style5"><span style="font-size: 8pt">Prefixo        </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="13%" align="center"><b><span class="style5"><span style="font-size: 8pt">N๚mero         </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="07%" align="center"><b><span class="style5"><span style="font-size: 8pt">Tipo           </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="36%" align="center"><b><span class="style5"><span style="font-size: 8pt">Fornecedor     </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="08%" align="center"><b><span class="style5"><span style="font-size: 8pt">Lan็amento     </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="08%" align="center"><b><span class="style5"><span style="font-size: 8pt">Emissใo        </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="08%" align="center"><b><span class="style5"><span style="font-size: 8pt">Vencimento     </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="13%" align="center"><b><span class="style5"><span style="font-size: 8pt">Valor          </span></span></b></td>' 					+ CRLF
				cHtml	+=	'  </tr>' 																																													+ CRLF

				lPriVez	:=	.f.	 
								
			endif				

			dData	:=	aTmp[t,SE2->(FieldPos("E2_EMIS1"))]
			cFilAnt	:=	iif( lSE2Excl , aTmp[t,SE2->(FieldPos("E2_FILIAL"))] , aTmp[t,SE2->(FieldPos("E2_FILORIG"))] )
			xPsqSF1	:=	aTmp[t,SE2->(FieldPos("E2_FORNECE"))] + aTmp[t,SE2->(FieldPos("E2_LOJA"))] + aTmp[t,SE2->(FieldPos("E2_NUM"))]
			
			SF1->(dbsetorder(2))
			SF1->(MsSeek( xFilial("SF1") +  xPsqSF1 , .f. ))    

			do while SF1->(!Eof()) .and. SF1->(F1_FILIAL + F1_FORNECE + F1_LOJA + F1_DOC) == ( xFilial("SF1") + xPsqSF1 )
				if	SF1->F1_PREFIXO == aTmp[t,SE2->(FieldPos("E2_PREFIXO"))]   
					dData	:=	iif( SF1->(FieldPos("F1_ZZDTINC")) <> 0 .and. !Empty(SF1->F1_ZZDTINC) , SF1->F1_ZZDTINC , SF1->F1_DTDIGIT )
					Exit
				endif
				SF1->(dbskip())
			enddo
			
			nVal	:=	aTmp[t,SE2->(FieldPos("E2_VALOR"))] 
			cNome	:=	aTmp[t,SE2->(FieldPos("E2_FORNECE"))] + "/" + aTmp[t,SE2->(FieldPos("E2_LOJA"))] + " - " + aTmp[t,nPosNom]

			cHtml	+=	'  <tbody>' 																								   																					+ CRLF
			cHtml	+=	'    <tr>' 																									   																					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="07%" align="center">      ' + aTmp[t,SE2->(FieldPos("E2_PREFIXO"))]					+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="13%" align="center">      ' + aTmp[t,SE2->(FieldPos("E2_NUM"))]						+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="07%" align="center">      ' + aTmp[t,SE2->(FieldPos("E2_TIPO"))]						+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="36%" align="left"  >&nbsp ' + cNome													+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="08%" align="center">      ' + DtoC(dData)		   									+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="08%" align="center">      ' + DtoC(aTmp[t,SE2->(FieldPos("E2_EMISSAO"))])			+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="08%" align="center">      ' + DtoC(aTmp[t,SE2->(FieldPos("E2_VENCREA"))])			+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="13%" align="right" >      ' + Transform( nVal , "@e 999,999,999.99" )				+ ' &nbsp</td>'					+ CRLF
			cHtml	+=	'    </tr>' 																																													+ CRLF
			cHtml	+=	'  </tbody>' 																																													+ CRLF
		
		Next t

		cHtml	+=	'</table>' 																																															+ CRLF

	endif
	SM0->(dbskip())
enddo

cHtml	+=	'<br>' 																																																		+ CRLF

cHtml	+=	'<table width="90%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#E5E5E5" bgcolor="#F7F7F7" >' 																					+ CRLF
cHtml	+=	'  <tr>' 																																																	+ CRLF
cHtml	+=	'    <td width="100%" bordercolor="#FFFFFF"><div align="right" class="texto-layer">WorkFlow @ Totvs</div></td>' 																							+ CRLF
cHtml	+=	'  </tr>' 																																																	+ CRLF
cHtml	+=	'</table>' 																																																	+ CRLF
cHtml	+=	'</body>' 																																																	+ CRLF
cHtml	+=	'</html>' 		

if	lIsBlind
	xDispMail(cPara,cHtml,cSubject,Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">",Nil,cCC,cCCO) 
else
	MemoWrit("c:\temp7\html.htm",cHtml)																																													
	FwMsgRun( Nil , { || xDispMail(cPara,cHtml,cSubject,Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">",Nil,cCC,cCCO) } , 'Processando' , "Enviando Email ..." )
	aEval( aArray , { |x| x[nPosFlg] := .f. } )
	if	ValType(oGrid) <> "U"
		oGrid:Refresh()
	endif
endif
	
cFilAnt := xFilAnt

RestArea(aArea)

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xDadosFor(oDlg,oGrid,aArray)

Local w
Local cTmp
Local nVal
Local oObj 			:=	GeneralClass():New()
Local nNum			:=	SE2->(FieldPos("E2_NUM"))	
Local nLoj			:=	SE2->(FieldPos("E2_LOJA"))	
Local nFil			:=	SE2->(FieldPos("E2_FILIAL"))	
Local nFor			:=	SE2->(FieldPos("E2_FORNECE"))	

Local cHtml			:=	""
Local xArray		:=	{}                 

Local cCC			:=	Space(250)
Local cCCO			:=	Space(250)
Local cPara			:=	Space(250)

Local xFilAnt		:=	""

if	xCleanTit(oDlg,oGrid,aArray)	

	For w := 1 to Len(aArray)
		if	aArray[w,nPosFlg]
			aAdd( xArray , aArray[w] )
		endif
	Next w 	

	xArray	:=	aSort( xArray ,,, { |x,y| x[nFil] + x[nFor] + x[nLoj] + x[nNum] < y[nFil] + y[nFor] + y[nLoj] + y[nNum] } )

	cTmp	:=	xArray[01,nFil] + xArray[01,nFor] + xArray[01,nLoj]	
	cPara 	:= 	xArray[01,nEmlFor]
	xFilAnt	:=	xArray[01,nFil]
	
	For w := 1 to Len(xArray)

		if	cTmp <> xArray[w,nFil] + xArray[w,nFor] + xArray[w,nLoj]
			cTmp :=	xArray[w,nFil] + xArray[w,nFor] + xArray[w,nLoj]  
			if	oObj:TelaMail(@cPara,@cCC,@cCCO)    
				fPendFor(@oDlg,@oGrid,xArray,cPara,cCCO,cCC,cHtml,xFilAnt)			
			endif
			cHtml 	:= 	""
			cPara 	:= 	xArray[w,nEmlFor]
			xFilAnt	:=	xArray[w,nFil]
		endif

		nVal	:=	xArray[w,SE2->(FieldPos("E2_VALOR"))]

		cHtml	+=	'  <tbody>' 																								   																					+ CRLF
		cHtml	+=	'    <tr>' 																									   																					+ CRLF
		cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="25%" align="center">      ' + xArray[w,SE2->(FieldPos("E2_NUM"))]					+ '      </td>'					+ CRLF
		cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="25%" align="center">      ' + xArray[w,SE2->(FieldPos("E2_PARCELA"))]				+ '      </td>'					+ CRLF
		cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="25%" align="center">      ' + DtoC(xArray[w,SE2->(FieldPos("E2_VENCTO"))])			+ '      </td>'					+ CRLF
		cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="25%" align="right" >      ' + Transform( nVal , "@e 999,999,999.99" )				+ ' &nbsp</td>'					+ CRLF
		cHtml	+=	'    </tr>' 																																													+ CRLF
		cHtml	+=	'  </tbody>' 																																													+ CRLF

		if	w == Len(xArray)
			if	oObj:TelaMail(@cPara,@cCC,@cCCO)    
				fPendFor(@oDlg,@oGrid,xArray,cPara,cCCO,cCC,cHtml,xFilAnt)			
			endif
		endif

	Next w 
               
	aEval( aArray , { |x| x[nPosFlg] := .f. } )
	
	oGrid:SetArray(aArray)
	oGrid:Refresh()

endif

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xCleanTit(oDlg,oGrid,aArray)

Local nI 		         
Local lUm			:=	.f.
Local lFlag    		:=	.t. 

Default oDlg		:=	Nil
Default oGrid		:=	Nil
Default aArray		:=	{}                  

For nI := 1 To Len(aArray)
	if	aArray[nI,nPosFlg]
		if	aArray[nI,nPosStt] == "8" 
			MessageBox("Titulos em border๔ nใo podem ser enviados.","Aten็ใo",MB_ICONHAND) 
			lFlag	:=	.f. 
		elseif	Upper(Alltrim(aArray[nI,nTipoPg])) == "TRIBUTO" 
			MessageBox("Titulos de tributo nใo podem ser enviados.","Aten็ใo",MB_ICONHAND) 
			lFlag	:=	.f. 
		elseif	Upper(Alltrim(aArray[nI,nTipoPg])) == "BOLETO" .and. !Empty(aArray[nI,nPosCdB]) 
			MessageBox("Existem titulos para pagamento por BOLETO com c๓digo de barras informado.","Aten็ใo",MB_ICONHAND) 
			lFlag	:=	.f.
		elseif	Upper(Alltrim(aArray[nI,nTipoPg])) == "DEPOSITO" .and. !Empty(aArray[nI,nBcoDep]) .and. !Empty(aArray[nI,nAgeDep]) .and. !Empty(aArray[nI,nCtaDep]) 
			MessageBox("Existem titulos para pagamento por DEPOSITO com dados bancแrios informados.","Aten็ใo",MB_ICONHAND) 
			lFlag	:=	.f.
		elseif	aArray[nI,nPosStt] <> "1" .and. aArray[nI,nPosStt] <> "5"
			MessageBox("Apenas titulos liberados podem ser enviados.","Aten็ใo",MB_ICONHAND) 
			lFlag	:=	.f. 
		endif    
		if 	lFlag
			lUm 	:=	.t.		
		else
			Exit
		endif		
	endif
Next nI

if !lUm
	MessageBox("Marque os fornecedores dos titulos que deseja enviar.","Aten็ใo",MB_ICONHAND) 
	lFlag	:=	.f. 
endif

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
//	lFlag	:=	.t. 
endif

Return ( lFlag )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xPendFor(aArray,cPara,cCCO,cCC,xHtml,xFilAnt) ; fPendFor(Nil,Nil,aArray,cPara,cCCO,cCC,xHtml,xFilAnt) ; Return 

Static Function fPendFor(oDlg,oGrid,aArray,cPara,cCCO,cCC,xHtml,xFilAnt)

Local cHtml		:=	""
Local tHtml		:=	""
Local aArea		:=	SM0->(GetArea())  		

Local cSMTP		:=	Alltrim(GetMv("MV_RELSERV"))                                               
Local nSMTPPort	:= 	GetMv("MV_GCPPORT")

Local aAnexos	:=	{ "\workflow\anexos\ficha cadastral.xls" }

Local cSubject	:=	"Pend๊ncias para Pagamento"         

Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 26/05/2023

Default cPara	:=	Space(250)            
Default cCCO	:=	Space(250)
Default cCC		:=	PadR( Alltrim(UsrRetMail(RetCodUsr())) , 250 )

if	":" $ cSMTP		
	cSMTP		:=	Substr( cSMTP , 01 , At(":",cSMTP) - 1 )
	nSMTPPort	:= 	Val(Substr( cSMTP , At(":",cSMTP) + 1 ))
endif

SM0->(dbgotop())
do while SM0->(!Eof())
	if	Upper(Alltrim(SM0->M0_CODIGO)) == Upper(Alltrim(cEmpAnt))
		if	Upper(Alltrim(SM0->M0_CODFIL)) == Upper(Alltrim(xFilAnt))
			Exit
		endif
	endif
	SM0->(dbskip())
enddo

cHtml	+=	'<html>' 																																															+ CRLF
cHtml	+=	'<title>.:: Totvs Protheus 12 - Pendencias do Fornecedor ::.</title>'																																+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<head>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<style>' 																																															+ CRLF
cHtml	+=	'Body {' 																																															+ CRLF
cHtml	+=	'	font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt' 																															+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TableRowBlueDarkMini {' 																																											+ CRLF
cHtml	+=	'	background-color: #E4E4E4; color: #FFCC00; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; vertical-align: center' 														+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TableRowWhiteMini2 {' 																																											+ CRLF
cHtml	+=	'	color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; vertical-align: center' 																					+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.style5 {' 																																														+ CRLF
cHtml	+=	'	color: #19167D; font-weight: bold;' 																																							+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TarjaTopoCor {' 																																													+ CRLF
cHtml	+=	'	text-decoration: none;height: 6px; background-color: #6699CC' 																																	+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.texto-layer {' 																																													+ CRLF
cHtml	+=	'	font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000000; text-decoration: none' 																						+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.titulo {' 																																														+ CRLF
cHtml	+=	'	font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #19167D; text-decoration: none; font-weight: bold;' 																			+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.texto {' 																																															+ CRLF
cHtml	+=	'	font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; text-decoration: none; font-weight: normal;' 																		+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'</style>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<title>Tํtulos sem Documentos Anexados</title>' 																																					+ CRLF
cHtml	+=	'<meta http-equiv="Content-Type" content="text/html; charset=utf-8">' 																																+ CRLF
cHtml	+=	''  																																																+ CRLF       	
cHtml	+=	'</head>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<body>' 																																															+ CRLF
cHtml	+=	''  																																																+ CRLF       	
cHtml	+=	'<table border="0" cellpadding="0" cellspacing="0" height="58" width="100%" align="center">' 																										+ CRLF
cHtml	+=	'  <tbody>' 																																														+ CRLF
cHtml	+=	'    <tr>' 																																															+ CRLF
cHtml	+=	'      <td>'																																														+ CRLF
if	alltrim(cEmpAnt) $ _cEmpAt1 //ticket TI - Antonio Domingos - 31/05/2023 
	cHtml	+=	'        <img style="width: 150px; height: 72px;" src="http://intra.cclind.com.br/Content/images/Logo_CCL_Assinatura.gif" border="0"> '															+ CRLF
elseif	cEmpAnt == "02"
	cHtml	+=	'        <img style="width: 180px; height: 44px;" src="http://intra.cclind.com.br/Content/images/checkpt.png" border="0">'																		+ CRLF
endif
cHtml	+=	'      </td>'																																														+ CRLF
cHtml	+=	'    </tr>' 																																														+ CRLF
cHtml	+=	'  </tbody>' 																																														+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<table width="100%" border="0" cellpadding="0" cellspacing="0" height="58" align="center">' 																										+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td height="72" width="100%">' 																																								+ CRLF
cHtml	+=	'      <p align="center"><font face="Tahoma" size="5">Pend๊ncias para Pagamento</font>' 																											+ CRLF
cHtml	+=	'    </td>' 																																														+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td height="1" class="TarjaTopoCor" colspan="3">' 																																				+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF

tHtml	:=	"&nbsp Prezado Fornecedor, " 																																										+ CRLF
tHtml	+=	'</br>' 																																															+ CRLF
tHtml	+=	'</br>' 																																															+ CRLF
tHtml	+=	"&nbsp Consta(m) em nosso sistema tํtulo(s) o(s) qual(is) nใo identificamos o(s) boleto(s) registrado(s) no DDA"															   						+ CRLF

cHtml	+=	'</br>' 																																															+ CRLF
cHtml	+=	'</br>' 																																															+ CRLF
cHtml	+=	''  																																																+ CRLF       	
cHtml	+=	'<table border="1" width="100%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 												+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="100%" align="left" ><b><span class="style5"><span style="font-size: 8pt"></br>' + tHtml + '</br></br></span></span></b></td>' 				+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF

cHtml	+=	''  																																																+ CRLF       	
cHtml	+=	'</br>' 																																															+ CRLF
cHtml	+=	''  																																																+ CRLF       	

cHtml	+=	'<table border="1" width="100%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 												+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="25%" align="center"><b><span class="style5"><span style="font-size: 8pt">N๚mero         </span></span></b></td>' 							+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="25%" align="center"><b><span class="style5"><span style="font-size: 8pt">Parcela        </span></span></b></td>' 							+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="25%" align="center"><b><span class="style5"><span style="font-size: 8pt">Vencimento     </span></span></b></td>' 							+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="25%" align="center"><b><span class="style5"><span style="font-size: 8pt">Valor          </span></span></b></td>' 							+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF

cHtml	+=	xHtml  																																																

cHtml	+=	'</table>' 																																															+ CRLF

cHtml	+=	''       																																															+ CRLF
cHtml	+=	'</br>' 																																															+ CRLF
cHtml	+=	''  																																																+ CRLF       	

tHtml	:=	"&nbsp <b> Nosso CNPJ : " + Transform(SM0->M0_CGC,"@r 99.999.999/9999-99") + "</b>"																													+ CRLF
tHtml	+=	'</br>' 																																															+ CRLF
tHtml	+=	'</br>' 																																															+ CRLF
tHtml	+=	"&nbsp Pedimos a gentileza de tomarem as devidas provid๊ncias." 																																	+ CRLF
tHtml	+=	'</br>' 																																															+ CRLF
tHtml	+=	'</br>' 																																															+ CRLF
tHtml	+=	"&nbsp Favor registrar e enviar o(s) boleto(s) em questใo ou preencher e assinar a ficha cadastral em anexo, para que possamos seguir com o pagamento via dep๓sito."											+ CRLF
tHtml	+=	'</br>' 																																															+ CRLF
tHtml	+=	'</br>' 																																															+ CRLF
tHtml	+=	"&nbsp Este e-mail ้ automแtico. Em caso de d๚vidas ou envio de anexos, pedimos a gentileza de entrar em contato com o nosso departamento "															+ CRLF
tHtml	+=	'de Contas a Pagar pelo endere็o <b><a href="mailto:contasapagar@cclindsa.com">contasapagar@cclindsa.com</a></b>'																					+ CRLF

cHtml	+=	'<table border="1" width="100%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 												+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="100%" align="left" ><b><span class="style5"><span style="font-size: 8pt"></br>' + tHtml + '</br></br></span></span></b></td>' 				+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF

cHtml	+=	''  																																																+ CRLF       	
cHtml	+=	'</br>' 																																															+ CRLF
cHtml	+=	''  																																																+ CRLF       	

cHtml	+=	'<table border="0" cellpadding="0" cellspacing="0" height="58" width="100%">' 																														+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td height="50">' 																																												+ CRLF
cHtml	+=	'      <p align="left" class="MsoNormal">' 																																							+ CRLF
cHtml	+=	'        <span style="font-size: 11.0pt; font-family: &quot;Calibri &quot;,sans-serif; color: black;">Atenciosamente, ' 																			+ CRLF
cHtml	+=	'        </span>' 																																													+ CRLF
cHtml	+=	'      </p>' 																																														+ CRLF
cHtml	+=	'    </td>' 																																														+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF

cHtml	+=	''  																																																+ CRLF       	

cHtml	+=	xRetAss()

cHtml	+=	''  																																																+ CRLF       	
cHtml	+=	'</div>' 																																															+ CRLF
cHtml	+=	'</body>' 																																															+ CRLF
cHtml	+=	'</html>' 																																															+ CRLF

if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
//	cPara	:=	"alexandre@zapponi.com.br"
endif

if	lIsBlind
	xDispMail(cPara,cHtml,cSubject,Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">",aAnexos,cCC,cCCO) 
else
	if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
		MemoWrit("c:\temp7\html.htm",cHtml)																																													
	endif
	FwMsgRun( Nil , { || xDispMail(cPara,cHtml,cSubject,Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">",aAnexos,cCC,cCCO) } , 'Processando' , "Enviando Email ..." )
	aEval( aArray , { |x| x[nPosFlg] := .f. } )
	oGrid:Refresh()
endif

RestArea(aArea)
	
Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xRetAss()

Local cHtml	:=	""

cHtml	+=	'<table class="MsoNormalTable" style="width: 450pt;" border="0" cellpadding="0" width="100%">' 																																						+ CRLF
cHtml	+=	'  <tbody>' 																																																										+ CRLF
cHtml	+=	'    <tr>          ' 																																																								+ CRLF
cHtml	+=	'      <td style="padding: 0cm;">' 																																																					+ CRLF
cHtml	+=	'        <p class="MsoNormal">' 																																																					+ CRLF
cHtml	+=	'          <span style="font-size: 8pt; font-family: &quot;Verdana&quot;,sans-serif; color: windowtext;">' 																																			+ CRLF
cHtml	+=	'            <a href="http://www.cclind.com/">' 																																																	+ CRLF
cHtml	+=	'              <span style="border: 1pt none windowtext; padding: 0cm; color: blue; text-decoration: none;">' 																																		+ CRLF
cHtml	+=	'                <img style="width: 1.2083in; height: 0.5208in;" id="Imagem_x0020_1" src="http://intra.cclind.com.br/Content/images/Logo_CCL_Assinatura.gif" alt="http://www.cclind.com" shrinktofit="true" border="0" height="50" width="116">' 	+ CRLF
cHtml	+=	'              </span>' 																																																							+ CRLF
cHtml	+=	'            </a>' 																																																									+ CRLF
cHtml	+=	'          </span>' 																																																								+ CRLF
cHtml	+=	'        </p>' 																																																										+ CRLF
cHtml	+=	'      </td>' 																																																										+ CRLF
cHtml	+=	'      <td style="padding: 0cm;">' 																																																					+ CRLF
cHtml	+=	'      <table class="MsoNormalTable" style="width: 230.25pt;" border="0" cellpadding="0" width="307">' 																																				+ CRLF
cHtml	+=	'        <tbody>' 																																																									+ CRLF
cHtml	+=	'          <tr>' 																																																									+ CRLF
cHtml	+=	'            <td style="padding: 0cm; width: 146.75pt;" width="196">' 																																												+ CRLF
cHtml	+=	'              <p class="MsoNormal">' 																																																				+ CRLF
cHtml	+=	'                <b>' 																																																								+ CRLF
cHtml	+=	'                  <span style="font-size: 7pt; font-family: &quot;Verdana&quot;,sans-serif; color: windowtext;"> ' 																																+ CRLF
cHtml	+=	'                  CCL Brasil ' 																																																					+ CRLF
cHtml	+=	'                  </span>' 																																																						+ CRLF
cHtml	+=	'                </b>' 																																																								+ CRLF
cHtml	+=	'              </p>' 																																																								+ CRLF
cHtml	+=	'            </td>' 																																																								+ CRLF
cHtml	+=	'          </tr>' 																																																									+ CRLF
cHtml	+=	'          <tr>' 																																																									+ CRLF
cHtml	+=	'            <td colspan="3" style="padding: 0cm;">' 																																																+ CRLF
cHtml	+=	'              <p class="MsoNormal">' 																																																				+ CRLF
cHtml	+=	'                <span style="font-size: 7pt; font-family: &quot;Verdana&quot;,sans-serif; color: windowtext;">' 																																	+ CRLF
cHtml	+=	'                Rod. Vinhedo-Viracopos, Km 79, Vinhedo-SP Brasil' 																																													+ CRLF
cHtml	+=	'                </span>' 																																																							+ CRLF
cHtml	+=	'              </p>' 																																																								+ CRLF
cHtml	+=	'            </td>' 																																																								+ CRLF
cHtml	+=	'          </tr>' 																																																									+ CRLF
cHtml	+=	'          <tr>' 																																																									+ CRLF
cHtml	+=	'            <td colspan="3" style="padding: 0cm;">' 																																																+ CRLF
cHtml	+=	'              <p class="MsoNormal">' 																																																				+ CRLF
cHtml	+=	'                <span style="font-size: 7pt; font-family: &quot;Verdana&quot;,sans-serif; color: windowtext;">' 																																	+ CRLF
cHtml	+=	'                Tel: +55&nbsp;19 3876-9300&nbsp;' 																																																	+ CRLF
cHtml	+=	'                </span>' 																																																							+ CRLF
cHtml	+=	'              </p>' 																																																								+ CRLF
cHtml	+=	'            </td>' 																																																								+ CRLF
cHtml	+=	'          </tr>' 																																																									+ CRLF
cHtml	+=	'          <tr>' 																																																									+ CRLF
cHtml	+=	'            <td style="padding: 0cm; width: 146.75pt;" width="196">' 																																												+ CRLF
cHtml	+=	'              <p class="MsoNormal">' 																																																				+ CRLF
cHtml	+=	'                <u>' 																																																								+ CRLF
cHtml	+=	'                  <span style="border: 1pt none windowtext; padding: 0cm; font-size: 7pt; font-family: &quot;Verdana&quot;,sans-serif; color: rgb(0, 0, 26);">' 																					+ CRLF
cHtml	+=	'                    <a href="mailto:contasapagar@cclindsa.com">' 																																											   		+ CRLF
cHtml	+=	'                      <span style="color: rgb(0, 0, 26);">contasapagar@cclindsa.com</span>' 																																						+ CRLF
cHtml	+=	'                    </a>' 																																																							+ CRLF
cHtml	+=	'                  </span>' 																																																						+ CRLF
cHtml	+=	'                </u>' 																																																								+ CRLF
cHtml	+=	'              </p>' 																																																								+ CRLF
cHtml	+=	'            </td>' 																																																								+ CRLF
cHtml	+=	'            <td style="padding: 0cm; width: 1pt;" width="1">' 																																														+ CRLF
cHtml	+=	'              <p class="MsoNormal">' 																																																				+ CRLF
cHtml	+=	'                <span style="font-size: 7pt; font-family: &quot;Verdana&quot;,sans-serif; color: windowtext;">' 																																	+ CRLF
cHtml	+=	'                  <a href="http://intra.cclind.com.br/www.cclindsa.com">' 																																											+ CRLF
cHtml	+=	'                    <span style="border: 1pt none windowtext; padding: 0cm; color: rgb(0, 0, 26);">www.cclindsa.com</span>' 																														+ CRLF
cHtml	+=	'                  </a>' 																																																							+ CRLF
cHtml	+=	'                </span>' 																																																							+ CRLF
cHtml	+=	'              </p>' 																																																								+ CRLF
cHtml	+=	'            </td>' 																																																								+ CRLF
cHtml	+=	'          </tr>' 																																																									+ CRLF
cHtml	+=	'          <tr style="height: 22.5pt;">' 																																																			+ CRLF
cHtml	+=	'            <td style="padding: 0cm; width: 146.75pt; height: 22.5pt;" width="196">' 																																								+ CRLF
cHtml	+=	'              <p class="MsoNormal">' 																																																				+ CRLF
cHtml	+=	'                <span style="font-size: 8pt; font-family: &quot;Verdana&quot;,sans-serif; color: windowtext;">' 																																	+ CRLF
cHtml	+=	'                  <a href="https://www.facebook.com/ccllabelbrasil">' 																																												+ CRLF
cHtml	+=	'                    <span style="border: 1pt none windowtext; padding: 0cm; color: blue; text-decoration: none;">' 																																+ CRLF
cHtml	+=	'                      <img style="width: 0.2083in; height: 0.2083in;" id="_x0000_i1026" src="http://intra.cclind.com.br/Content/images/assinatura/Facebook.png" alt="" shrinktofit="true" border="0" height="20" width="20">' 						+ CRLF
cHtml	+=	'                    </span>' 																																																						+ CRLF
cHtml	+=	'                  </a>' 																																																							+ CRLF
cHtml	+=	'                  <a href="https://pt.linkedin.com/company/ccllabelbrasil">' 																																										+ CRLF
cHtml	+=	'                    <span style="border: 1pt none windowtext; padding: 0cm; color: blue; text-decoration: none;">' 																																+ CRLF
cHtml	+=	'                      <img style="width: 0.2083in; height: 0.2083in;" id="_x0000_i1027" src="http://intra.cclind.com.br/Content/images/assinatura/Linkedin.png" alt="" shrinktofit="true" border="0" height="20" width="20">' 						+ CRLF
cHtml	+=	'                    </span>' 																																																						+ CRLF
cHtml	+=	'                  </a>' 																																																							+ CRLF
cHtml	+=	'                  <a href="https://www.instagram.com/cclbrasil/">' 																																												+ CRLF
cHtml	+=	'                    <span style="border: 1pt none windowtext; padding: 0cm; color: blue; text-decoration: none;">' 																																+ CRLF
cHtml	+=	'                      <img style="width: 0.2083in; height: 0.2083in;" id="_x0000_i1028" src="http://intra.cclind.com.br/Content/images/assinatura/Instagram.png" alt="" shrinktofit="true" border="0" height="20" width="20">' 					+ CRLF
cHtml	+=	'                    </span>' 																																																						+ CRLF
cHtml	+=	'                  </a>' 																																																							+ CRLF
cHtml	+=	'                  <a href="https://br.pinterest.com/cclbrasil/">' 																																													+ CRLF
cHtml	+=	'                    <span style="border: 1pt none windowtext; padding: 0cm; color: blue; text-decoration: none;">' 																																+ CRLF
cHtml	+=	'                      <img style="width: 0.2083in; height: 0.2083in;" id="_x0000_i1029" src="http://intra.cclind.com.br/Content/images/assinatura/Pinterest.png" alt="" shrinktofit="true" border="0" height="20" width="20">' 					+ CRLF
cHtml	+=	'                    </span>' 																																																						+ CRLF
cHtml	+=	'                  </a>' 																																																							+ CRLF
cHtml	+=	'                  <a href="https://www.youtube.com/channel/UCSP5TYg79a-j8FEEgolg2Ag">' 																																							+ CRLF
cHtml	+=	'                    <span style="border: 1pt none windowtext; padding: 0cm; color: blue; text-decoration: none;">' 																																+ CRLF
cHtml	+=	'                      <img style="width: 0.2083in; height: 0.2083in;" id="_x0000_i1030" src="http://intra.cclind.com.br/Content/images/assinatura/Youtube.png" alt="" shrinktofit="true" border="0" height="20" width="20">' 						+ CRLF
cHtml	+=	'                    </span>' 																																																						+ CRLF
cHtml	+=	'                  </a>' 																																																							+ CRLF
cHtml	+=	'                </span>' 																																																							+ CRLF
cHtml	+=	'              </p>' 																																																								+ CRLF
cHtml	+=	'            </td>' 																																																								+ CRLF
cHtml	+=	'          </tr>' 																																																									+ CRLF
cHtml	+=	'        </tbody>' 																																																									+ CRLF
cHtml	+=	'      </table>' 																																																									+ CRLF
cHtml	+=	'      </td>' 																																																										+ CRLF
cHtml	+=	'      <td style="padding: 0cm;">' 																																																					+ CRLF
cHtml	+=	'        <p class="MsoNormal" style="margin-left: 3.75pt;">' 																																														+ CRLF
cHtml	+=	'          <span style="font-size: 8pt; font-family: &quot;Verdana&quot;,sans-serif; color: windowtext;">' 																																			+ CRLF
cHtml	+=	'            <a href="http://www.checkpt.com.br/">' 																																																+ CRLF
cHtml	+=	'              <span style="border: 1pt none windowtext; padding: 0cm; color: blue; text-decoration: none;">' 																																		+ CRLF
cHtml	+=	'                <img style="width: 1.2083in; height: 0.302in;" id="Imagem_x0020_7" src="http://intra.cclind.com.br/Content/images/checkpt.png" alt="" shrinktofit="true" border="0" height="29" width="116">' 										+ CRLF
cHtml	+=	'              </span>' 																																																							+ CRLF
cHtml	+=	'            </a>' 																																																									+ CRLF
cHtml	+=	'          </span>' 																																																								+ CRLF
cHtml	+=	'        </p>' 																																																										+ CRLF
cHtml	+=	'      </td>' 																																																										+ CRLF
cHtml	+=	'    </tr>' 																																																										+ CRLF
cHtml	+=	'  </tbody>' 																																																										+ CRLF
cHtml	+=	'</table>' 																																																											+ CRLF

Return ( cHtml )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function GeraWork(aArray,oGrid)

Local nPos    	:=	00 
Local xFilAnt	:=	cFilAnt
Local cBordero	:=	fGetNumBor()          		

if !Empty(cBordero)

	nPos := aScan( aArray , { |x| x[SE2->(FieldPos("E2_NUMBOR"))] == cBordero } )

	if	nPos == 0 
		MessageBox("Border๔ informado nใo encontrado nos itens listados","Aten็ใo",MB_ICONHAND) 
	else 
		if	lFilCen
			cFilAnt := aArray[nPos,nFilCen]
		else
			if 	FwModeAccess("SE2") == "E" .or. !Empty(aArray[nPos,SE2->(FieldPos("E2_FILIAL"))])
				cFilAnt := aArray[nPos,SE2->(FieldPos("E2_FILIAL"))]
			else
				cFilAnt := aArray[nPos,SE2->(FieldPos("E2_FILORIG"))]
			endif
		endif
	
		FwMsgRun( Nil , { || CursorWait() , U_FDFINW01( 1 , Nil , cBordero ) , CursorArrow() } , "TOTVS" , "Enviando Workflow ..." )

	endif
endif

cFilAnt := xFilAnt 

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function MenuDef()

Local aRotina 	:= 	{ 	{ "Pesquisar"	, "AxPesqui"      , 0 , 1,,.F.} ,;  
						{ "Bordero"		, "FA240Borde"    , 0 , 3} ,;  
						{ "Cancelar"	, "FA240Canc"     , 0 , 3} ,;  
						{ "Legenda"		, "FA040Legenda"  , 0 ,7, ,.F.  }}  	

Return ( aRotina )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function GetMoedas()

Local aRet     := {}
Local aArea    := GetArea()
Local aAreaSx6 := Sx6->(GetArea())
Local cFilSx6

GetMv("MV_MOEDA1")

cFilSx6			:= 	SX6->X6_FIL

do while Substr(SX6->X6_VAR,1,8) == "MV_MOEDA" .and. SX6->(!Eof()) .and. SX6->X6_FIL == cFilSx6
	if 	Substr(SX6->X6_VAR,9,1) != "P" .and. Substr(SX6->X6_VAR,9,2) != "CM" 
		aAdd( aRet , StrZero(Val(Substr(SX6->X6_VAR,9,2)),2) + " " + GetMv(SX6->X6_VAR) )
	Endif
	SX6->(dbskip())
enddo

aSort(aRet)

RestArea(aAreaSx6)
RestArea(aArea)

Return ( aRet )

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xMailErro(oDlg,oGrid,aArray,cPara,cCCO,cCC)

Local t

Local lOk		:=	.f.
Local lPriVez	:=	.t.

Local aTmp		:=	aClone(aArray)
Local oObj		:= 	GeneralClass():New()      
Local aArea		:=	SM0->(GetArea())  		

Local nVal		:=	0
Local cUser 	:=	""
Local cNome		:=	""
Local cHtml		:=	""   
Local dData		:=	CtoD("")

Local cSMTP		:=	Alltrim(GetMv("MV_RELSERV"))                                               
Local nSMTPPort	:= 	GetMv("MV_GCPPORT")

Local xPsqSF1	:=	""
Local xFilAnt	:=	cFilAnt
Local lSE2Excl	:=	FwModeAccess("SE2") == "E"     
Local cSubject	:=	"Titulos com Erro de Lancamento" 
Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 26/05/2023

Default cPara	:=	Space(250)            
Default cCCO	:=	Space(250)
Default cCC		:=	PadR( Alltrim(UsrRetMail(RetCodUsr())) , 250 )

For t := 1 to Len(aTmp) 
	if	aTmp[t,nPosFlg] .and. !Empty(aTmp[t,nMsgErr])
		lOk		:=	.t.    
		Exit
	endif
Next t 

if !lOk
	if	lIsBlind
		ConOut("Nao ha documentos com erro de lan็amento marcados para envio")
	else
		Alert("Nใo hแ documentos com erro de lan็amento marcados para envio")
	endif
	Return
endif
	
if !lIsBlind .and. !oObj:TelaMail(@cPara,@cCC,@cCCO)    
	Return
endif

if	":" $ cSMTP		
	nSMTPPort	:= 	Val(Substr( cSMTP , At(":",cSMTP) + 1 ))
	cSMTP		:=	Substr( cSMTP , 01 , At(":",cSMTP) - 1 )
endif

cHtml	+=	'<html>' 																																															+ CRLF
cHtml	+=	'<title>.:: Totvs Protheus 12 - Tํtulos com Erro de Lan็amento ::.</title>'																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<head>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<style>' 																																															+ CRLF
cHtml	+=	'Body {' 																																															+ CRLF
cHtml	+=	'	font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10pt' 																															+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TableRowBlueDarkMini {' 																																											+ CRLF
cHtml	+=	'	background-color: #E4E4E4; color: #FFCC00; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; vertical-align: center' 														+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TableRowWhiteMini2 {' 																																											+ CRLF
cHtml	+=	'	color: #000000; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 10px; vertical-align: center' 																					+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.style5 {' 																																														+ CRLF
cHtml	+=	'	color: #19167D; font-weight: bold;' 																																							+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.TarjaTopoCor {' 																																													+ CRLF
cHtml	+=	'	text-decoration: none;height: 6px; background-color: #6699CC' 																																	+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.texto-layer {' 																																													+ CRLF
cHtml	+=	'	font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 9px; color: #000000; text-decoration: none' 																						+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.titulo {' 																																														+ CRLF
cHtml	+=	'	font-family: Arial, Helvetica, sans-serif; font-size: 16px; color: #19167D; text-decoration: none; font-weight: bold;' 																			+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'.texto {' 																																															+ CRLF
cHtml	+=	'	font-family: Arial, Helvetica, sans-serif; font-size: 12px; color: #333333; text-decoration: none; font-weight: normal;' 																		+ CRLF
cHtml	+=	'}' 																																																+ CRLF
cHtml	+=	'</style>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<title>Tํtulos sem Documentos Anexados</title>' 																																					+ CRLF
cHtml	+=	'<meta http-equiv="Content-Type" content="text/html; charset=utf-8">' 																																+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'</head>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<body>' 																																															+ CRLF
cHtml	+=	'<table border="0" cellpadding="0" cellspacing="0" height="58" width="100%" align="center">' 																										+ CRLF
cHtml	+=	'  <tbody>' 																																														+ CRLF
cHtml	+=	'    <tr>' 																																															+ CRLF
cHtml	+=	'      <td>'																																														+ CRLF
if	alltrim(cEmpAnt) $ _cEmpAt1 //ticket TI - Antonio Domingos - 31/05/2023 
	cHtml	+=	'        <img style="width: 150px; height: 72px;" src="http://intra.cclind.com.br/Content/images/Logo_CCL_Assinatura.gif" border="0"> '															+ CRLF
elseif	cEmpAnt == "02"
	cHtml	+=	'        <img style="width: 180px; height: 44px;" src="http://intra.cclind.com.br/Content/images/checkpt.png" border="0">'																		+ CRLF
endif
cHtml	+=	'      </td>'																																														+ CRLF
cHtml	+=	'    </tr>' 																																														+ CRLF
cHtml	+=	'  </tbody>' 																																														+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF
cHtml	+=	'<table width="100%" border="0" cellpadding="0" cellspacing="0" height="58" align="center">' 																										+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td height="72" width="100%">' 																																								+ CRLF
cHtml	+=	'      <p align="center"><font face="Tahoma" size="5">Tํtulos com Erro de Lan็amento</font>' 																										+ CRLF
cHtml	+=	'    </td>' 																																														+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'  <tr>' 																																															+ CRLF
cHtml	+=	'    <td height="1" class="TarjaTopoCor" colspan="3">' 																																				+ CRLF
cHtml	+=	'  </tr>' 																																															+ CRLF
cHtml	+=	'</table>' 																																															+ CRLF
cHtml	+=	''         																																															+ CRLF

SM0->(dbgotop())		
do while SM0->(!Eof())
	if	Upper(Alltrim(SM0->M0_CODIGO)) == Upper(Alltrim(cEmpAnt))

		lOk		:=	.f.
		lPriVez	:=	.t.

	    For t := 1 to Len(aTmp)
			if	aTmp[t,nPosFlg] .and. !Empty(aTmp[t,nMsgErr])
				if	Upper(Alltrim( iif( lSE2Excl , aTmp[t,SE2->(FieldPos("E2_FILIAL"))] , aTmp[t,SE2->(FieldPos("E2_FILORIG"))] ) )) == Upper(Alltrim(SM0->M0_CODFIL))
					lOk := .t.
					Exit 
				endif
			endif
		Next t 

		if !lOk
			SM0->(dbskip())
			Loop		
		endif

	    For t := 1 to Len(aTmp)

			if	aTmp[t,nPosFlg] .and. !Empty(aTmp[t,nMsgErr])
				if	Upper(Alltrim( iif( lSE2Excl , aTmp[t,SE2->(FieldPos("E2_FILIAL"))] , aTmp[t,SE2->(FieldPos("E2_FILORIG"))] ) )) <> Upper(Alltrim(SM0->M0_CODFIL))
					Loop
				endif
		    else
		    	Loop
		    endif
		
			SE2->(dbgoto(aTmp[t,nPosRec]))

			if	lPriVez    
			
				cHtml	+=	'<br>' 																																														+ CRLF
				cHtml	+=	'<br>' 																																														+ CRLF
				cHtml	+=	'<table border="1" width="100%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 										+ CRLF
				cHtml	+=	'  <tr>' 																																													+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="100%" align="center" ><b><span class="style5"><span style="font-size: 9pt">' + SM0->M0_FILIAL + '</span></span></b></td>' 			+ CRLF
				cHtml	+=	'  </tr>' 																																													+ CRLF
				cHtml	+=	'</table>' 																																													+ CRLF
				
				cHtml	+=	'<br>' 																																														+ CRLF
				
				cHtml	+=	'<table border="1" width="100%" cellspacing="3" style="border-collapse: collapse" bordercolor="#111111" cellpadding="0" height="46" align="center">' 										+ CRLF
				cHtml	+=	'  <tr>' 																																													+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="05%" align="center"><b><span class="style5"><span style="font-size: 8pt">Prefixo        </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="11%" align="center"><b><span class="style5"><span style="font-size: 8pt">N๚mero         </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="05%" align="center"><b><span class="style5"><span style="font-size: 8pt">Tipo           </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="30%" align="center"><b><span class="style5"><span style="font-size: 8pt">Fornecedor     </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="07%" align="center"><b><span class="style5"><span style="font-size: 8pt">Lan็amento     </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="07%" align="center"><b><span class="style5"><span style="font-size: 8pt">Emissใo        </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="07%" align="center"><b><span class="style5"><span style="font-size: 8pt">Vencimento     </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="08%" align="center"><b><span class="style5"><span style="font-size: 8pt">Valor          </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="05%" align="center"><b><span class="style5"><span style="font-size: 8pt">Usuแrio        </span></span></b></td>' 					+ CRLF
				cHtml	+=	'    <td class="TableRowBlueDarkMini" height="21" width="15%" align="center"><b><span class="style5"><span style="font-size: 8pt">Motivo         </span></span></b></td>' 					+ CRLF
				cHtml	+=	'  </tr>' 																																													+ CRLF

				lPriVez	:=	.f.	 
								
			endif				

			cUser	:=	""
			dData	:=	aTmp[t,SE2->(FieldPos("E2_EMIS1"))]
			cFilAnt	:=	iif( lSE2Excl , aTmp[t,SE2->(FieldPos("E2_FILIAL"))] , aTmp[t,SE2->(FieldPos("E2_FILORIG"))] )
			xPsqSF1	:=	aTmp[t,SE2->(FieldPos("E2_FORNECE"))] + aTmp[t,SE2->(FieldPos("E2_LOJA"))] + aTmp[t,SE2->(FieldPos("E2_NUM"))]
			
			SF1->(dbsetorder(2))
			SF1->(MsSeek( xFilial("SF1") +  xPsqSF1 , .f. ))    

			do while SF1->(!Eof()) .and. SF1->(F1_FILIAL + F1_FORNECE + F1_LOJA + F1_DOC) == ( xFilial("SF1") + xPsqSF1 )
				if	SF1->F1_PREFIXO == aTmp[t,SE2->(FieldPos("E2_PREFIXO"))]   
					cUser	:=	SF1->F1_USUARIO
					dData	:=	iif( SF1->(FieldPos("F1_ZZDTINC")) <> 0 .and. !Empty(SF1->F1_ZZDTINC) , SF1->F1_ZZDTINC , SF1->F1_DTDIGIT )
					Exit
				endif
				SF1->(dbskip())
			enddo

			if	Empty(cUser) .and. SE2->(FieldPos("E2_USERLGI")) <> 0 .and. !Empty(SE2->E2_USERLGI)
				cUser	:=	FwLeUserLg("E2_USERLGI",01)
			endif 

			nVal	:=	aTmp[t,SE2->(FieldPos("E2_VALOR"))] 
			cNome	:=	aTmp[t,SE2->(FieldPos("E2_FORNECE"))] + "/" + aTmp[t,SE2->(FieldPos("E2_LOJA"))] + " - " + aTmp[t,nPosNom]

			cHtml	+=	'  <tbody>' 																								   																					+ CRLF
			cHtml	+=	'    <tr>' 																									   																					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="05%" align="center">      ' + aTmp[t,SE2->(FieldPos("E2_PREFIXO"))]					+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="11%" align="center">      ' + aTmp[t,SE2->(FieldPos("E2_NUM"))]						+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="05%" align="center">      ' + aTmp[t,SE2->(FieldPos("E2_TIPO"))]						+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="30%" align="left"  >&nbsp ' + cNome													+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="07%" align="center">      ' + DtoC(dData)		   									+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="07%" align="center">      ' + DtoC(aTmp[t,SE2->(FieldPos("E2_EMISSAO"))])			+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="07%" align="center">      ' + DtoC(aTmp[t,SE2->(FieldPos("E2_VENCREA"))])			+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="08%" align="right" >      ' + Transform( nVal , "@e 999,999,999.99" )				+ ' &nbsp</td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="05%" align="left"  >&nbsp ' + cUser													+ '      </td>'					+ CRLF
			cHtml	+=	'      <td class="TableRowWhiteMini2" bgcolor="#FFFFFF" height="19" width="15%" align="left"  >&nbsp ' + Upper(Alltrim(aTmp[t,nMsgErr]))						+ '      </td>'					+ CRLF
			cHtml	+=	'    </tr>' 																																													+ CRLF
			cHtml	+=	'  </tbody>' 																																													+ CRLF
		
		Next t

		cHtml	+=	'</table>' 																																															+ CRLF

	endif
	SM0->(dbskip())
enddo

cHtml	+=	'<br>' 																																																		+ CRLF

cHtml	+=	'<table width="100%" border="1" align="center" cellpadding="0" cellspacing="0" bordercolor="#E5E5E5" bgcolor="#F7F7F7" >' 																					+ CRLF
cHtml	+=	'  <tr>' 																																																	+ CRLF
cHtml	+=	'    <td width="100%" bordercolor="#FFFFFF"><div align="right" class="texto-layer">WorkFlow @ Totvs</div></td>' 																							+ CRLF
cHtml	+=	'  </tr>' 																																																	+ CRLF
cHtml	+=	'</table>' 																																																	+ CRLF
cHtml	+=	'</body>' 																																																	+ CRLF
cHtml	+=	'</html>' 		

if	lIsBlind
	xDispMail(cPara,cHtml,cSubject,Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">",Nil,cCC,cCCO) 
else
	MemoWrit("c:\temp7\htmlmsgerr.htm",cHtml)																																													
	FwMsgRun( Nil , { || xDispMail(cPara,cHtml,cSubject,Alltrim(SM0->M0_NOMECOM) + " <" + Alltrim(GetMv("MV_RELACNT")) + ">",Nil,cCC,cCCO) } , 'Processando' , "Enviando Email ..." )
	aEval( aArray , { |x| x[nPosFlg] := .f. } )
	if	ValType(oGrid) <> "U"
		oGrid:Refresh()
	endif
endif

cFilAnt := xFilAnt

RestArea(aArea)

Return 

/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ                          		
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณxPrepPag  บAutor  ณMicrosiga           บ Data ณ  04/24/15   บฑฑ	
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณPainel de prepracao de pagamento                            บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

Static Function xCleanPg(oDlg,oGrid,aArray,nPosIni,nPosFim,lPass,oCombo)

Local w 
Local lUm 			:=	.f.
Local lCont			:=	.t.

Local nLin			:=	000
Local nSaldo		:=	000
Local xPosBor 		:=	SE2->(FieldPos("E2_NUMBOR"))

Default lPass		:=	.f.
Default nPosIni		:=	001
Default nPosFim		:=	Len(aArray)

For w := nPosIni to nPosFim
	if	lPass .or. aArray[w,nPosFlg]
		if	aArray[w,nPosStt] $ "1/5"
			lUm 	:=	.t. 
		else 	
			lCont 	:= 	.f. 
		endif
	endif
Next w 

if !lUm
	MessageBox("Nใo hแ tํtulos marcados para a execu็ใo da rotina.","Aten็ใo",MB_ICONHAND) 
	Return 
elseif !lCont             
	MessageBox("Apenas tํtulos liberados podem ter alteradas as formas de pagamento.","Aten็ใo",MB_ICONHAND) 
	Return 
endif 

For w := nPosIni to nPosFim
	if	lPass .or. aArray[w,nPosFlg]
		if !Empty(aArray[w,xPosBor])
			lCont := .f. 
		endif
	endif
Next w 

if !lCont             
	MessageBox("Tํtulos em border๔ nใo podem ser alterados.","Aten็ใo",MB_ICONHAND) 
	Return 
endif 

if	MessageBox('Confirma a limpeza dos dados de pagamentos dos tํtulos marcados ?',"Aten็ใo",MB_YESNO) == 6      	
	For w := nPosIni to nPosFim
		if	lPass .or. aArray[w,nPosFlg]
			nLin					:=	w
			aArray[nLin,nTipoPg] 	:= 	""
			aArray[nLin,nCodCrd] 	:=	"" 
			aArray[nLin,nModCrd] 	:= 	""  
			aArray[nLin,nAtuTpP] 	:= 	.f.
			aArray[nLin,nPosFlg] 	:= 	.f.
			SE2->(dbgoto(aArray[nLin,nPosRec]))
			RecLock("SE2",.f.)
				SE2->E2_ZZTPPG		:=	""
				SE2->E2_ZZMODBD		:=	""
			MsUnlock("SE2")
			nSaldo := Round(NoRound(xMoeda(SE2->(E2_SALDO + E2_SDACRES - E2_SDDECRE),SE2->E2_MOEDA,1,dDataBase),3),2)
			xModPg(@aArray,nLin,nSaldo,!(aArray[nLin,nPosStt] $ "1/5/9"))
		endif
	Next w 
	oGrid:Refresh()		
endif

Return 
