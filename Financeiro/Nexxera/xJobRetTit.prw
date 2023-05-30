#include "tbiconn.ch"
#include "topconn.ch"      		
#include "protheus.ch"     	 	
               		  	 	                          
User Function xJobProcBD(xEmp,xFil,lIsBlind,xOBD) ; U_xJobRetTit(xEmp,xFil,lIsBlind,.t.) ; Return     			

/*/{Protheus.doc} User Function xJobRetTit
	Job que verifica se tem titulos a baixar na VAN
	@type  Function
	@author Alexandre Zapponi
	@since 01/09/19
	@history ticket 81491 - Abel Babini - 27/12/2022 - Projeto Nexxera - Retorno de baixas
	/*/
User Function xJobRetTit(xEmp,xFil,lIsBlind,xOBD)   	

Local xPar01
Local xPar02
Local xPar03
Local xPar04
Local xPar05

Local cQuery		:=	""      
Local xFilAnt		:=	""

Local aSay      	:= 	{}
Local aButton  		:= 	{}

Local lOk			:=	.f.

Local cTitulo   	:= 	"BAIXA AUTOMมTICA DOS ARQUIVOS DE RETORNO" 
Local cDesc1    	:= 	"Esta rotina tem como fun็ใo fazer a baixa dos arquivos de retorno de acordo com o "
Local cDesc2    	:= 	"informado no cadastro de bancos no campo DIRETORIO RETORNO CNAB"                   

Default lIsBlind	:=	IsBlind() .or. Type("__LocalDriver") == "U"    
Default xEmp 		:=	iif( lIsBlind , "01" , cEmpAnt )
Default xFil		:=	iif( lIsBlind , "01" , cFilAnt )
Default xOBD		:=	.f.

if	ValType(xEmp) == "A"
	xFil			:=	xEmp[02]
	xEmp 			:=	xEmp[01]
endif

if	lIsBlind          
	ConOut("")
	ConOut("")
	ConOut("****************")
	ConOut("* XJOBPROCBD   *")
	ConOut("* Empresa : " + xEmp)
	ConOut("* Filial  : " + xFil)
	ConOut("****************")
	ConOut("")
	ConOut("")
	RpcSetType(3)
	Prepare Environment Empresa xEmp Filial xFil
	SetModulo("SIGAFIN","FIN")
	ConOut(cEmpAnt)
	ConOut(cFilAnt)
endif

if	lIsBlind .or. IsInCallStack("U_XCPCALLGENERAL") 
	mv_par01	:=	1
	mv_par02	:=	1
	mv_par03	:=	2
	mv_par04	:=	1
	mv_par05	:=	2
else   
	ValidPerg("XJOBRETTIT")   		
                                                                
	Pergunte("XJOBRETTIT",.f.)

	aAdd( aSay , cDesc1 )
	aAdd( aSay , cDesc2 )
	
	aAdd(  aButton , {  5 , .t. , { || Pergunte("XJOBRETTIT",.t.) } } )
	aAdd(  aButton , {  1 , .t. , { || lOk := .t. , FechaBatch()  } } )
	aAdd(  aButton , {  2 , .t. , { || lOk := .f. , FechaBatch()  } } )
	
	FormBatch(  cTitulo ,  aSay ,  aButton )

	if !lOk
		Return
	endif
endif

xPar01	:=	mv_par01
xPar02	:=	mv_par02
xPar03	:=	mv_par03
xPar04	:=	mv_par04
xPar05	:=	mv_par05

xFilAnt	:=	cFilAnt

cQuery	:=	" Select * " 
cQuery	+=	" From " + RetSqlName("SA6")
cQuery	+=	" Where D_E_L_E_T_ = ' ' and  A6_ZZPATH <> '" + CriaVar("A6_ZZPATH",.f.) + "' and A6_ZZSUBC <> '" + CriaVar("A6_ZZSUBC",.f.) + "'"	

TcQuery ChangeQuery(@cQuery) New Alias "TQRY" 

if	lIsBlind	
	ConOut(cQuery)
endif

do while TQRY->(!Eof())  
	mv_par01 := xPar01
	mv_par02 := xPar02
	mv_par03 := xPar03
	mv_par04 := xPar04
	mv_par05 := xPar05
	if	SA6->(FieldPos("A6_ZZFLPR")) <> 0 .and. !Empty(TQRY->A6_ZZFLPR)
		cFilAnt := TQRY->A6_ZZFLPR
	elseif !Empty(TQRY->A6_FILIAL)
		cFilAnt := TQRY->A6_FILIAL
	endif
	SEE->(dbseek( xFilial("SEE") + TQRY->A6_COD + TQRY->A6_AGENCIA + TQRY->A6_NUMCON + TQRY->A6_ZZSUBC , .f. ))
	if	lIsBlind
		ConOut(TQRY->A6_ZZCNFR)
		if	Upper(Alltrim(TQRY->A6_ZZCNFR)) == "XIMPRETSIS" .or. "XIMPRETSIS" $ TQRY->A6_ZZCNFR
			U_xImpRetSis(Alltrim(TQRY->A6_ZZPATH),.t.,Nil,Nil,xOBD)
		endif
	else
		FwMsgRun( Nil , { |xObj| U_xImpRetSis(Alltrim(TQRY->A6_ZZPATH),.t.,.t.,xObj) } , "Processando" , "Carregando Dados ..." )	
	endif
	dbSelectArea("TQRY")
	TQRY->(dbskip())
enddo

TQRY->(dbclosearea())

if	lIsBlind          
	Reset Environment
else
	cFilAnt	:= xFilAnt
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

Static Function ValidPerg(cPerg)  		  	         

Local oObj	:= 	GeneralClass():New()

oObj:PutSx1(cPerg,"01","Baixa por             ","","","mv_ch1","N",01,0,3,"C","","      ","","","mv_par01","Titulo","","","","Tipo de Pagamento","","","Total","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"02","Contabiliza on-line   ","","","mv_ch2","N",01,0,1,"C","","      ","","","mv_par02","Sim   ","","","","Nao              ","","","     ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"03","Considera Multipla Nat","","","mv_ch3","N",01,0,2,"C","","      ","","","mv_par03","Sim   ","","","","Nao              ","","","     ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"04","Mostra Lan็. Contabeis","","","mv_ch4","N",01,0,1,"C","","      ","","","mv_par04","Sim   ","","","","Nao              ","","","     ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")
oObj:PutSx1(cPerg,"05","Aglutina lan็amentos  ","","","mv_ch5","N",01,0,2,"C","","      ","","","mv_par05","Sim   ","","","","Nao              ","","","     ","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","","")

Return
