#include "topconn.ch"
#include "protheus.ch"   	   	 	 				
 	                  	
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XFINA260  �Autor  �Alexandre Zapponi   � Data �  06/03/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Reprocessamento de registros de DDA                         ���  	XPROCDDA
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

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
		Alert("N�o h� registros a processar para os par�metros informados")
	endif
endif

RestArea(aAreaFIG)
RestArea(aAreaSM0)

cFilAnt		:=	xFilAnt
dDataBase 	:= 	xDataBase

Return

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XFINA430  �Autor  �Alexandre Zapponi   � Data �  01/17/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �Leitura de arquivo DDA Itau                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function fa430procs(aFIG,xFIG,aBXA)         

Local cQuery          
Local lSql   	:=	"MSSQL" $ Upper(Alltrim(TcGetDB()))
                                       
dbSelectArea("FIG")
dbSetOrder(2)

//��������������������������������������������������������������Ŀ
//�                    P A R A M E T R O S                       �
//�--------------------------------------------------------------�
//�MV_PAR01: Considera Filiais Abaixo                            �
//�MV_PAR02: Filial De                                           �
//�MV_PAR03: Filial Ate                                          �
//�MV_PAR04: Fornecedor De                                       �
//�MV_PAR05: Fornecedor Ate                                      �
//�MV_PAR06: Loja De			                                 �
//�MV_PAR07: Loja Ate		                                     �
//�MV_PAR08: Considera Vencto ou Vencto Real                     �
//�MV_PAR09: Vencto De                                           �
//�MV_PAR10: Vencto Ate                                          �
//�MV_PAR11: Dt. de Processamento do Arquivo DDA De              �
//�MV_PAR12: Dt. de Processamento do Arquivo DDA Ate             �
//�MV_PAR13: Avancar Dias (Vencto + nDias)                       �
//�MV_PAR14: Retroceder Dias (Vencto - nDias)                    �
//�MV_PAR15: Diferenca a Menor                                   �
//�MV_PAR16: Diferenca a Maior                                   �
//����������������������������������������������������������������

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

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �XFINA430  �Autor  �Microsiga           � Data �  01/17/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/

Static Function fProcFIG(aFIG,xFIG,aBXA)

U_xProcFIG(aFIG,xFIG,aBXA)

Return              
