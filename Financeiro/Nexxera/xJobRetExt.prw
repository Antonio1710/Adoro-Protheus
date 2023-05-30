#include "tbiconn.ch"
#include "topconn.ch"
#include "protheus.ch"

/*/{Protheus.doc} User Function xJobRetExt
	Job que verifica se tem extratos a processar na VAN
	@type  Function
	@author Alexandre Zapponi
	@since 24/02/20
	@history ticket 81491 - Abel Babini - 27/12/2022 - Projeto Nexxera - Retorno de baixas
	/*/
User Function xJobRetExt(xEmp,xFil,lIsBlind)

Local cQuery		:=	""
Local xFilAnt		:=	""

Default lIsBlind	:=	IsBlind() .or. Type("__LocalDriver") == "U"    
Default xEmp 		:=	iif( lIsBlind , "01" , cEmpAnt )
Default xFil		:=	iif( lIsBlind , "01" , cFilAnt )

if	ValType(xEmp) == "A"
	xFil			:=	xEmp[02]
	xEmp 			:=	xEmp[01]
endif

if	lIsBlind          
	ConOut("Empresa : " + xEmp)
	ConOut("Filial  : " + xFil)
	Prepare Environment Empresa xEmp Filial xFil
	SetModulo("SIGAFIN","FIN")
	ConOut(cEmpAnt)
	ConOut(cFilAnt)
endif

xFilAnt := cFilAnt

if	SA6->(FieldPos("A6_ZZDIREX")) == 0
	if	lIsBlind          
		ConOut("Campo 'A6_ZZDIREX' não criado")
	else
		Alert("Campo 'A6_ZZDIREX' não criado")
	endif
else
	cQuery	:=	" Select * " 
	cQuery	+=	" From " + RetSqlName("SA6")
	cQuery	+=	" Where D_E_L_E_T_ = ' ' and  A6_ZZDIREX <> '" + CriaVar("A6_ZZDIREX",.f.) + "'"	
	
	TcQuery ChangeQuery(@cQuery) New Alias "TQRY" 
	
	if	lIsBlind	
		ConOut(cQuery)
	endif
	
	do while TQRY->(!Eof())  
		if	SA6->(FieldPos("A6_ZZFLPR")) <> 0 .and. !Empty(TQRY->A6_ZZFLPR)
			cFilAnt := TQRY->A6_ZZFLPR
		elseif !Empty(TQRY->A6_FILIAL)
			cFilAnt := TQRY->A6_FILIAL
		endif
		if	lIsBlind
			ConOut(TQRY->A6_ZZDIREX)
			U_xImpExtrato(Alltrim(TQRY->A6_ZZDIREX))
		else
			FwMsgRun( Nil , { |xObj| U_xImpExtrato(Alltrim(TQRY->A6_ZZDIREX),.t.,xObj) } , "Processando" , "Lendo Arquivos de Extrato ..." )	
		endif
		dbSelectArea("TQRY")
		TQRY->(dbskip())
	enddo
	
	TQRY->(dbclosearea())
endif

if	lIsBlind          
	Reset Environment
else
	cFilAnt := xFilAnt
endif

Return            
