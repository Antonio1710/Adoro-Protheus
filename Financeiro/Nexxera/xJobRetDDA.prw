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
User Function xJobRetDDA(xEmp,xFil,lIsBlind)

Local t
Local cArq
Local aArq

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

if	SA6->(FieldPos("A6_ZZDIRDD")) == 0
	if	lIsBlind          
		ConOut("Campo 'A6_ZZDIRDD' não criado")
	else
		Alert("Campo 'A6_ZZDIRDD' não criado")
	endif
else
	cQuery	:=	" Select * " 
	cQuery	+=	" From " + RetSqlName("SA6")
	cQuery	+=	" Where D_E_L_E_T_ = ' ' and  A6_ZZDIRDD <> '" + CriaVar("A6_ZZDIRDD",.f.) + "'"	
	
	TcQuery ChangeQuery(@cQuery) New Alias "TQRY" 
	
	if	lIsBlind	
		ConOut(cQuery)
	endif
	
	do while TQRY->(!Eof())  
		cArq := Alltrim(TQRY->A6_ZZDIRDD)
		if	"ZAPPONI" $ Upper(Alltrim(GetEnvServer()))
			cArq := "c:\TempB\"
		endif
		cArq += iif( Right(cArq,01) <> "\" , "\" , "" )
		aArq := Directory( Alltrim(cArq) + '*.*' , "" )    
		For t := 1 to Len(aArq)		                                    			
			if	lIsBlind
				ConOut(TQRY->A6_ZZDIRDD)
				U_xFina430(Alltrim(cArq) + Alltrim(aArq[t,01]))
			else
				FwMsgRun( Nil , { |xObj| U_xFina430(Alltrim(cArq) + Alltrim(aArq[t,01])) } , "Processando" , "Lendo Arquivos de DDA ..." )	
			endif
		Next t 	
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
