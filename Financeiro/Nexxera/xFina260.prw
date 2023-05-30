#include "topconn.ch"
#include "protheus.ch"   	   	 	 				
 	                  	
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณXFINA260  บAutor  ณAlexandre Zapponi   บ Data ณ  06/03/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณReprocessamento de registros de DDA                         บฑฑ  	XPROCDDA
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿*/

User Function xProcDDA() ; Return ( U_xFina260() )     				 		

User Function xFina260()    					 			

Local aBXA			:=	{} 
Local aFIG			:=	{} 
Local xFIG			:=	{} 
Local xFilAnt		:=	cFilAnt
Local xDataBase		:=	dDataBase   
Local aAreaFIG		:=	FIG->(GetArea())
Local aAreaSM0		:=	SM0->(GetArea())

dbSelectArea("FIG")     		
dbSetOrder(1)

if	FIG->(FieldPos("FIG_ZZSEQ")) == 0 .or. FIG->(FieldPos("FIG_ZZARQ")) == 0 .or. FIG->(FieldPos("FIG_ZZJUR")) == 0
	Alert("Rotina desatualizada. Execute o compatibilizador UPDXFIG.")
	Return
endif

if	Pergunte("FIN260",.t.)         		
	U_xChkNotConc()
	FwMsgRun( Nil , { || fa430procs(@aFIG,@xFIG,@aBXA) } , "Processando" , "Leitura de Registros" )	
	if	Len(aFIG) > 0 
		fProcFIG(aFIG,xFIG,aBXA)
	else
		Alert("Nใo hแ registros a processar para os parโmetros informados")
	endif
endif

RestArea(aAreaFIG)
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

Static Function fa430procs(aFIG,xFIG,aBXA)         

Local cQuery          
Local lSql   	:=	"MSSQL" $ Upper(Alltrim(TcGetDB()))
                                       
dbSelectArea("FIG")
dbSetOrder(2)

//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
//ณ                    P A R A M E T R O S                       ณ
//ณ--------------------------------------------------------------ณ
//ณMV_PAR01: Considera Filiais Abaixo                            ณ
//ณMV_PAR02: Filial De                                           ณ
//ณMV_PAR03: Filial Ate                                          ณ
//ณMV_PAR04: Fornecedor De                                       ณ
//ณMV_PAR05: Fornecedor Ate                                      ณ
//ณMV_PAR06: Loja De			                                 ณ
//ณMV_PAR07: Loja Ate		                                     ณ
//ณMV_PAR08: Considera Vencto ou Vencto Real                     ณ
//ณMV_PAR09: Vencto De                                           ณ
//ณMV_PAR10: Vencto Ate                                          ณ
//ณMV_PAR11: Dt. de Processamento do Arquivo DDA De              ณ
//ณMV_PAR12: Dt. de Processamento do Arquivo DDA Ate             ณ
//ณMV_PAR13: Avancar Dias (Vencto + nDias)                       ณ
//ณMV_PAR14: Retroceder Dias (Vencto - nDias)                    ณ
//ณMV_PAR15: Diferenca a Menor                                   ณ
//ณMV_PAR16: Diferenca a Maior                                   ณ
//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

cQuery	:=	" Select * "
cQuery	+=	" From " + RetSqlName("FIG") 
cQuery	+=	" Where " 
if	mv_par01 == 1
	cQuery	+=	"   FIG_FILIAL             >= '" + mv_par02						+ "' and " 
	cQuery	+=	"   FIG_FILIAL             <= '" + mv_par03						+ "' and " 
else	
	cQuery	+=	"   FIG_FILIAL              = '" + xFilial("FIG")				+ "' and " 
endif
if	lSql
	cQuery	+=	"   FIG_FORNEC + FIG_LOJA  >= '" + mv_par04 + mv_par06			+ "' and " 
	cQuery	+=	"   FIG_FORNEC + FIG_LOJA  <= '" + mv_par05 + mv_par07			+ "' and " 
else
	cQuery	+=	"   FIG_FORNEC || FIG_LOJA >= '" + mv_par04 + mv_par06			+ "' and " 
	cQuery	+=	"   FIG_FORNEC || FIG_LOJA <= '" + mv_par05 + mv_par07			+ "' and " 
endif	
cQuery	+=		"   FIG_VENCTO             >= '" + DtoS(mv_par09)     			+ "' and " 
cQuery	+=		"   FIG_VENCTO             <= '" + DtoS(mv_par10)     			+ "' and "   
cQuery	+=		"   FIG_DATA               >= '" + DtoS(mv_par11)     			+ "' and " 
cQuery	+=		"   FIG_DATA               <= '" + DtoS(mv_par12)     			+ "' and "   
cQuery 	+=		"   FIG_CODBAR             <> '" + CriaVar("FIG_CODBAR",.f.)	+ "' and "
cQuery 	+=		"   FIG_CONCIL              = '2'                                    and "
cQuery 	+= 		"   FIG_VALOR               > 0                                      and "
cQuery	+=		"   D_E_L_E_T_              = ' '                                        " 
cQuery	+=	" Order By " + SqlOrder(FIG->(IndexKey()))

TcQuery ChangeQuery(@cQuery) New Alias "XQRY"

do while XQRY->(!Eof())
	aAdd( aFIG , XQRY->R_E_C_N_O_ )
	aAdd( xFIG , { XQRY->R_E_C_N_O_ , .f. } )
	aAdd( aBXA , { XQRY->R_E_C_N_O_ , .f. , 0 } )
	XQRY->(dbskip())
enddo

XQRY->(dbclosearea())

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

Static Function fProcFIG(aFIG,xFIG,aBXA)

U_xProcFIG(aFIG,xFIG,aBXA)

Return              
