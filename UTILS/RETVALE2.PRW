#include "rwmake.ch"
#Include "TopConn.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Fun‡…o    ³RETVALE2  ³ HCCONSYS		      ³ Data ³ 02/03/07 ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descri‡…o ³ Retorna valor total de duplicata da nf de entrada³±±
±±³          |  para LP 660                                     ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³ Uso      ³ SIGACTB E SIGACOM                                ³±±
±±ÀÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
@history ticket 83894 - Antonio Domingos - 28/11/2022 - Ajuste de Query - LP 660-000 FORNECEDOR
@history ticket 84293 - Antonio Domingos - 01/12/2022 - LP 660-000 Ceres. Se a Empresa é diferente de 01-Varzea Paulista
@history ticket 91009 - Antonio Domingos - 31/03/2023 - LP 660-000 ABRIR REGRA (VALOR) - recompilar 1801
@history ticket 91009 - Antonio Domingos - 03/04/2023 - LP 660-000 ABRIR REGRA (VALOR) - inclusão de parcela e distinct mantido
@history ticket T.I   - WILLIAM COSTA    - 17/05/2023 - INCLUSAO DA EMPRESA 13
@history ticket TI - Antonio Domingos - 26/05/2023 - Revisão Ajuste Nova Empresa
@history ticket TI - Antonio Domingos - 30/05/2023 - Revisão Ajuste Nova Empresa
/*/

User Function RETVALE2()

//F1_FILIAL+F1_DOC+F1_SERIE+F1_FORNECE+F1_LOJA+F1_TIPO

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Define Variaveis                                                 ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

Local _nValorSE2 :=0

Local _aArea := GetArea()
Local _aAreaSE2    := SE2->(GetArea())
Local _aAreaSF1    := SF1->(GetArea())
//Local _cEspecie    := IF(EMPTY(SF1->F1_ESPECIE),"NF",SF1->F1_ESPECIE) 
Private cProduto   := GETMV("MV_#PRDCON") //chamado 036846 - fernando sigoli //24/08/2017
//ticket 83894 - Antonio Domingos - 28/11/2022
Private _cF4_XCTB  := "S"       
Private _cF4_XTM   := "E01/E04" 
Private _cD1_TIPO  := "D"       
Private _cD1_CF    :=  "1551"
Private _cD1_SERIE := "ST/ICM/PAR"
 
U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Retorna valor total de duplicata da nf de entrada')

//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
//³ Posiciona Todos os Indices Necessarios                       ³
//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	// ***************** INICIO ALTERACAO CHAMADO 024322 ********************************************** //
    SqlTitPag(Xfilial("SE2"),SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_SERIE,SF1->F1_DOC)
        
	/*BEGINDOC
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³apos a atualizacao do sistema protheus no dia 03/08/2015, passou-se no momento do estorno da classificacao³
	//³da nota de entrada foi alterado pela totvs, anteriormente fazia o seguinte processo:                      ³
	//³ESTORNO NF COMPRAS -> LANCAMENTOS PADROES -> EXCLUSAO DO TITULO                                           ³
	//³agora com a alteracao ficou assim                                                                         ³
	//³ESTORNO NF COMPRAS -> EXCLUSAO DO TITULO -> LANCAMENTOS PADROES                                           ³
	//³portanto foi refeito esse select para ler arquivos do SE2 deletados mais ordenado por R_E_C_N_O_          ³
	//³para garantir que pegue o ultimo excluido.                                                                ³
	//³EXPLICACAO POR WILLIAM COSTA                                                                              ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	ENDDOC*/
    
    While TRB->(!EOF())
         
        // *** INICIO ALTERACAO CHAMADO 024870 *** //
    	IF TRB->E2_VALOR <= TRB->F1_VALBRUT 
    	// *** FINAL ALTERACAO CHAMADO 024870 *** //
    				
    		_nValorSE2:= _nValorSE2 + TRB->E2_VALOR 
		
		ELSE
		
			_nValorSE2:= _nValorSE2 + TRB->F1_VALBRUT
			
		ENDIF
	     	
        TRB->(dbSkip())
	ENDDO
	TRB->(dbCloseArea()) 
	// ***************** FINAL ALTERACAO CHAMADO 024322 ********************************************** //

RestArea(_aAreaSE2)
RestArea(_aAreaSF1)
RestArea(_aArea)

Return(_nValorSE2)

Static Function SqlTitPag(_cFilial,_cFornece,_cLoja,_cPrefixo,_cDoc)
	Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 30/05/2023
	//ticket 84293 - Antonio Domingos - 01/12/2022 (Se a Empresa é diferente de 01-Varzea Paulista usar query antiga)
	If !(alltrim(SM0->M0_CODIGO) $ _cEmpAt1) //ticket TI - Antonio Domingos - 30/05/2023 
		BeginSQL Alias "TRB"
			%NoPARSER%
			SELECT SE2.E2_VALOR,SF1.F1_VALBRUT
				FROM %Table:SE2% SE2 WITH(NOLOCK) ,%Table:SF1% SF1 WITH(NOLOCK) 
					WHERE SE2.E2_FILIAL  = %EXP:_cFilial%
						AND SE2.E2_FORNECE = %EXP:_cFornece%
						AND SE2.E2_LOJA    = %EXP:_cLoja%
						AND SE2.E2_PREFIXO = %EXP:_cPrefixo%
						AND SE2.E2_NUM     = %EXP:_cDoc%
						AND SE2.E2_FILIAL  = SF1.F1_FILIAL
						AND SE2.E2_NUM     = SF1.F1_DOC
						AND SE2.E2_PREFIXO = SF1.F1_SERIE
						AND SE2.E2_FORNECE = SF1.F1_FORNECE
						AND SE2.E2_LOJA    = SF1.F1_LOJA 
						AND SE2.%NotDel% 
						AND SF1.%NotDel% 
			ORDER BY SE2.R_E_C_N_O_ DESC
		EndSQl  
	Else //ticket 84293 - Antonio Domingos - 01/12/2022 (Se a Empresa é 01 usar a nova query)
		BeginSQL Alias "TRB"
			%NoPARSER%
			//ticket 83894 - Antonio Domingos - 28/11/2022
			SELECT DISTINCT E2_PARCELA,SE2.E2_VALOR,SF1.F1_VALBRUT //ticket 91009 - Antonio Domingos - 31/03/2023/03/04/2023
				FROM %Table:SE2% SE2 WITH(NOLOCK)
				INNER JOIN SF1010 SF1 WITH(NOLOCK)
					ON SF1.F1_FILIAL   = SE2.E2_FILIAL
					AND SF1.F1_DOC     = SE2.E2_NUM
					AND SF1.F1_SERIE   = SE2.E2_PREFIXO
					AND SF1.F1_FORNECE = SE2.E2_FORNECE
					AND SF1.F1_LOJA    = SE2.E2_LOJA 
					AND SF1.%NotDel%
				INNER JOIN %Table:SD1% SD1 WITH(NOLOCK) 
					ON SD1.D1_FILIAL   = SF1.F1_FILIAL
					AND SD1.D1_DOC     = SF1.F1_DOC
					AND SD1.D1_SERIE   = SF1.F1_SERIE
					AND SD1.D1_FORNECE = SF1.F1_FORNECE
					AND SD1.D1_LOJA    = SF1.F1_LOJA 
					AND SD1.D1_TIPO    = SF1.F1_TIPO
					AND SD1.D1_TIPO    <> 'D'
					AND TRIM(SD1.D1_COD) NOT IN('833424','836536')
					AND TRIM(SD1.D1_CF)  NOT IN('1551')
					AND TRIM(SD1.D1_SERIE) NOT IN('ST','ICM','PAR')
					AND SD1.%NotDel%
				INNER JOIN %Table:SF4% SF4 WITH(NOLOCK) 
					ON SF4.F4_CODIGO  = SD1.D1_TES
					AND SF4.F4_XCTB = 'S' 
					AND SF4.F4_XTM  IN('E01','E04')
					AND SF4.%NotDel%
				WHERE SE2.E2_FILIAL  = %Exp:_cFilial%
					AND SE2.E2_FORNECE = %Exp:_cFornece%
					AND SE2.E2_LOJA    = %Exp:_cLoja%
					AND SE2.E2_PREFIXO = %Exp:_cPrefixo%
					AND SE2.E2_NUM     = %Exp:_cDoc%
					AND SE2.%NotDel%
		EndSQl  
	EndIf

	//* habilitar qdo precisar verificar query - não apagar. //ticket 83894 - Antonio Domingos - 28/11/2022
	//aQuery := GetLastQuery()
	/*
	[1] cAlias - Alias usado para abrir o Cursor.
	[2] cQuery - Query executada.
	[3] aCampos - Array de campos com critério de conversão especificados.
	[4] lNoParser - Caso .T., não foi utilizada ChangeQuery() na String original.
	[5] nTimeSpend - Tempo, em segundos, utilizado para a abertura do Cursor.
	*/
	//If Len(aQuery) > 0
		//cQuery := aQuery[2]
		//Memowrite("C:\TEMP\RETVALE2.SQL",cQuery)
	//EndIf
	
RETURN(NIL) 
