#INCLUDE 'PROTHEUS.CH'

/*/{Protheus.doc} User Function MNT40011
	Ponto de entrada chamado para fazer alguma valida��o na finaliza��o de uma Ordem de Servi�o, antes de montar a tela.
	@type  Function
	@author William Costa
	@since 30/11/2020
	@version 01	
    @history Ticket  4928 - William Costa - 01/12/2020 - Identificado que o campo Tipo da Solicita��o de OP, n�o � utilizado, o que � utilizado mesmo � o numero da Ordem de Solicita��o + Fixo 'OS001', ent�o foi alterado o ponto de entrada e o erro solucionado.
	@history Ticket 15804 - Rodrigo Rom�o - 27/08/2021 - tratamento neste fonte para atender a demana do p.e - NGTERMOT
	@history TI           - Tiago Stoco   - 04/10/2022 - apenas adicionei na query da SC7 para ele desprezar os pedidos rejeitados pelo aprovador, com isso a D�bora consegue encerrar a OS mesmo que o pedido n�o tenha sido aprovado.
	@history Everson, 13/02/2023, ticket 87842 - Valida��o de encerramento de OS.
	@history Everson, 20/02/2023, ticket 88099 - Adicionado log.
/*/

USER FUNCTION MNT40011(cNomeJanela)

	Local lRet     			:= .T.
	Local aArea    			:= GetArea()
	Local aAreaSTJ 			:= STJ->(GetArea())
	local cOpcRotina 		:= Alltrim(iif(cNomeJanela <> nil, 'Cancelar', 'Finalizar'))
	Local cTpBlq    		:= Alltrim(cValToChar(GetMv("MV_#DMT221",,"SC0001,SC0002"))) //Everson - 13/02/2023 - ticket 88099.
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'P.E finaliza��o de uma Ordem de Servi�o, antes de montar a tela')
	
	
	default cNomeJanela := "MNT40011"

	// *** INICIO VERIFICA SE A SOLICITACAO DE ARMAZEM FOI BAIXADA OU ENCERRADA
	SqlSCP(STJ->TJ_FILIAL,STJ->TJ_ORDEM + 'OS' + "001")

	TRC->(DbGoTop())
	While !TRC->(EOF())

		IF lRet == .T.

			MsgStop("OL� " + Alltrim(cUserName) + ", S.A da Ordem de Servi�o, ainda n�o foi baixada ou Encerrada, Numero da S.A: " + TRC->CP_NUM + "/" + TRC->CP_ITEM + " por favor, verifique.", Alltrim(cNomeJanela) + "-02 - " + cOpcRotina + " Ordem de Servi�o ")
			lRet := .F.

		ELSE

			EXIT

		ENDIF

		TRC->(DBSKIP())

	ENDDO
	TRC->(DbCloseArea())

	// *** FINAL VERIFICA SE A SOLICITACAO DE ARMAZEM FOI BAIXADA OU ENCERRADA

	// *** INICIO VERIFICA SE A NOTA FISCAL DE ENTRADA FOI DADA ENTRADA CORRETAMENTE
	IF lRet == .T.

		SqlSD1(STJ->TJ_FILIAL,STJ->TJ_ORDEM + 'OS' + "001")

		TRD->(DbGoTop())
		While !TRD->(EOF())

			IF lRet == .T.

				MsgStop("OL� " + Alltrim(cUserName) + ", Nota Fiscal de Compra da Ordem de Servi�o, ainda n�o dada Entrada, Numero do P.C: " + TRD->D1_DOC + " por favor, verifique.", Alltrim(cNomeJanela) + "-09 - " + cOpcRotina + " Ordem de Servi�o ")
				lRet := .F.

			ELSE

				EXIT

			ENDIF

			TRD->(DBSKIP())

		ENDDO
		TRD->(DbCloseArea())

	ENDIF
	// *** FINAL VERIFICA SE A NOTA FISCAL DE ENTRADA FOI DADA ENTRADA CORRETAMENTE

	// *** INICIO VERIFICA SE A SOLICITACAO DE COMPRA FOI ENCERRADA OU ELIMINADA RESIDUO
	IF lRet == .T.

		SqlSC1(STJ->TJ_FILIAL,STJ->TJ_ORDEM + 'OS' + "001")

		TRE->(DbGoTop())
		While !TRE->(EOF())

			IF lRet == .T.

				MsgStop("OL� " + Alltrim(cUserName) + ", S.C da Ordem de Servi�o, ainda n�o foi baixada ou Eliminada Residuo, Numero da S.C: " + TRE->C1_NUM + "/" + TRE->C1_ITEM + " por favor, verifique.", Alltrim(cNomeJanela) + "-05  - " + cOpcRotina + " Ordem de Servi�o ")
				lRet := .F.

			ELSE

				EXIT

			ENDIF

			TRE->(DBSKIP())

		ENDDO
		TRE->(DbCloseArea())
	ENDIF
	// *** FINAL VERIFICA SE A SOLICITACAO DE COMPRA FOI ENCERRADA OU ELIMINADA RESIDUO

	// *** INICIO VERIFICA SE O PEDIDO DE COMPRA FOI ENCERRADA OU ELIMINADA RESIDUO
	IF lRet == .T.

		SqlSC7(STJ->TJ_FILIAL,STJ->TJ_ORDEM + 'OS' + "001")

		TRF->(DbGoTop())
		While !TRF->(EOF())

			IF lRet == .T.

				MsgStop("OL� " + Alltrim(cUserName) + ", Pedido de Compra da Ordem de Servi�o, ainda n�o foi baixada ou Eliminada Residuo, Numero do P.C: " + TRF->C7_NUM + "/" + TRF->C7_ITEM + " por favor, verifique.", Alltrim(cNomeJanela) + "-07  - " + cOpcRotina + " Ordem de Servi�o ")
				lRet := .F.

			ELSE

				EXIT

			ENDIF

			TRF->(DBSKIP())

		ENDDO
		TRF->(DbCloseArea())
	ENDIF
	// *** FINAL VERIFICA SE O PEDIDO DE COMPRA FOI ENCERRADA OU ELIMINADA RESIDUO

	//Everson - 13/02/2023 - ticket 87842.
	lRet := lRet .And. U_ADMNT022P("", STJ->TJ_ORDEM)
	
	/******* Deixar o log sempre por �ltimo *******/
	//Everson - 13/02/2023 - ticket 88099.
	If lRet
		U_ADMNT220("", STJ->TJ_ORDEM, "FINALIZA��O OS", "")

	EndIf
	//

	RestArea(aArea)
	RestArea(aAreaSTJ)

RETURN(lRet)

Static Function SqlSCP(cFilAtu,cOp)

	BeginSQL Alias "TRC"
		     %NoPARSER%
		        SELECT CP_NUM,
                       CP_ITEM,
                       CP_QUANT,
                       CP_QUJE,
                       CP_STATUS 
				  FROM %TABLE:SCP% SCP WITH(NOLOCK)
                   WHERE CP_FILIAL    = %EXP:cFilAtu%
                     AND CP_OP        = %EXP:cOp%
                     AND CP_QUANT    <> CP_QUJE
                     AND CP_STATUS   <> 'E'
                     AND D_E_L_E_T_  <> '*'   
				 
	EndSQl

Return (NIL)

Static Function SqlSD1(cFilAtu,cOp)

	BeginSQL Alias "TRD"
		     %NoPARSER%
             SELECT D1_FILIAL,
                    D1_DOC,
                    D1_SERIE,
                    D1_FORNECE,
                    D1_LOJA,
                    F1_STATUS 
               FROM %TABLE:SD1% SD1 WITH(NOLOCK)
         INNER JOIN %TABLE:SF1% SF1 WITH(NOLOCK)
                 ON F1_FILIAL       = D1_FILIAL
                AND F1_DOC          = D1_DOC
                AND F1_SERIE        = D1_SERIE
                AND F1_FORNECE      = D1_FORNECE
                AND F1_LOJA         = D1_LOJA 
                AND F1_STATUS       = ''
                AND SF1.D_E_L_E_T_ <> '*'
              WHERE D1_FILIAL       = %EXP:cFilAtu%
                AND D1_OP           = %EXP:cOp%
                AND SD1.D_E_L_E_T_ <> '*'

             GROUP BY D1_FILIAL,D1_DOC,D1_SERIE,D1_FORNECE,D1_LOJA,F1_STATUS  
                 
	EndSQl

Return (NIL)

Static Function SqlSC1(cFilAtu,cOp)

	BeginSQL Alias "TRE"
		     %NoPARSER%
             SELECT C1_FILIAL,
                    C1_NUM,
                    C1_ITEM,
                    C1_PRODUTO,
                    C1_QUANT,
                    C1_QUJE,
                    C1_OP,
                    C1_RESIDUO 
               FROM %TABLE:SC1% SC1 WITH(NOLOCK)
              WHERE C1_FILIAL   = %EXP:cFilAtu%
                AND C1_OP       = %EXP:cOp%
                AND C1_QUANT   <> C1_QUJE
                AND C1_RESIDUO <> 'S'
                AND D_E_L_E_T_ <> '*'

	EndSQl

Return (NIL)

Static Function SqlSC7(cFilAtu,cOp)

	BeginSQL Alias "TRF"
		     %NoPARSER%
             SELECT C7_FILIAL,
                    C7_NUM,
                    C7_ITEM,
                    C7_PRODUTO,
                    C7_QUANT,
                    C7_QUJE,
                    C7_OP,
                    C7_RESIDUO 
               FROM %TABLE:SC7% SC7 WITH(NOLOCK)
              WHERE C7_FILIAL   = %EXP:cFilAtu%
                AND C7_OP       = %EXP:cOp%
                AND C7_QUANT   <> C7_QUJE
                AND C7_RESIDUO <> 'S'
                AND D_E_L_E_T_ <> '*'
				AND C7_CONAPRO <> 'R'

	EndSQl

Return (NIL)
