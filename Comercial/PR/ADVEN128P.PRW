#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} ADVE1280
    Job para atualiza��o de mensagem no pedido de venda MVC - ADVEN118P.
    @type  Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
User Function ADVE1280(aXEmpFil) // U_ADVE1280()
	
	//Declara��o de vari�vies
	Default aXEmpFil := {"01", "02"}
	
	RPCClearEnv()
	RPCSetType(3)
	RpcSetEnv(aXEmpFil[1],aXEmpFil[2],,,,GetEnvServer(),{ })

        envMsgB()

	RpcClearEnv()

Return Nil
/*/{Protheus.doc} envMsgB
    Processa altera��o de mensagem de pagamento de pedido com condi��o de pagametno antecipada.
    @type  Static Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
Static Function envMsgB()

    //Vari�veis.
    Local aArea     := GetArea()
    Local cQuery    := scptMsPag()
    Local cAlias    := GetNextAlias()
    Local cPedido   := ""

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    While ! (cAlias)->(Eof())

        cPedido := (cAlias)->ZJA_NUM

        U_ADV1180I(cPedido) //Atualiza��o da mensagem de pedido com pagamento antecipado.

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} scriptMsBol
    Script sql.
    @type  Static Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
Static Function scptMsPag()

    //Vari�veis.
    Local cQuery := ""

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " ZJA_NUM, R_E_C_N_O_ AS REC  " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA " 
    cQuery += " WHERE " 
        cQuery += " ZJA_FILIAL = '" + FWxFilial("ZJA") + "' " 
        cQuery += " AND ZJA_MSPANT = '1' " 
        cQuery += " AND ZJA_INTSC5 = '1' " 
        cQuery += " AND ZJA_LOCEXP = '" + cEmpAnt + cFilAnt + "' " 
        cQuery += " AND ZJA_STATUS IN ('1','2','3') " 
        cQuery += " AND ZJA.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY " 
        cQuery += " ZJA_NUM " 

Return cQuery
/*/{Protheus.doc} ADVE1281
    Job para atualiza��o de status de pedidos exclu�dos.
    @type  Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
User Function ADVE1281(aXEmpFil) // U_ADVE1281()
	
	//Declara��o de vari�vies
	Default aXEmpFil := {"01", "02"}
	
	RPCClearEnv()
	RPCSetType(3)
	RpcSetEnv(aXEmpFil[1],aXEmpFil[2],,,,GetEnvServer(),{ })

        pedExcl()

	RpcClearEnv()

Return Nil
/*/{Protheus.doc} pedExcl
    Processa altera��o de status de pedidos exclu�dos.
    @type  Static Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
Static Function pedExcl()

    //Vari�veis.
    Local aArea     := GetArea()
    Local cQuery    := scptPedEx()
    Local cAlias    := GetNextAlias()
    Local cPedido   := ""

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    While ! (cAlias)->(Eof())

        cPedido := (cAlias)->ZJA_NUM

        U_ADV1180G(cPedido) //Reprova��o financeira pedido de venda.

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} scptPedEx
    Script sql.
    @type  Static Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
Static Function scptPedEx()

    //Vari�veis.
    Local cQuery := ""

    cQuery := ""
    cQuery += " SELECT " 
        cQuery += " ZJA_NUM, ZJA.R_E_C_N_O_ AS REC " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA " 
        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("SC5") + " (NOLOCK) AS SC5 ON " 
        cQuery += " ZJA_NUM = C5_NUM " 
        cQuery += " AND SC5.D_E_L_E_T_ <> '' " 
    cQuery += " WHERE " 
    cQuery += " ZJA_LOCEXP = '" + cEmpAnt + cFilAnt + "' " 
        cQuery += " AND CAST(ZJA_DTINC AS DATE) >= CAST(GETDATE() -1 AS DATE) " 
        cQuery += " AND ZJA_INTSC5 = '1' " 
        cQuery += " AND ZJA_STATUS NOT IN ('8','7','5') " //Cancelado, reprovado comercial e reprovado financeiro.
        cQuery += " AND ZJA.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY " 
        cQuery += " ZJA_NUM " 

Return cQuery
/*/{Protheus.doc} ADVE1282
    Job para atualiza��o de status de pedidos faturados e aprovados pelo financeiro.
    @type  Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
User Function ADVE1282(aXEmpFil) // U_ADVE1282()
	
	//Declara��o de vari�vies
	Default aXEmpFil := {"01", "02"}
	
	RPCClearEnv()
	RPCSetType(3)
	RpcSetEnv(aXEmpFil[1],aXEmpFil[2],,,,GetEnvServer(),{ })

        pedFat()

	RpcClearEnv()

Return Nil
/*/{Protheus.doc} pedFat
    Processa altera��o de status de pedidos faturados e aprovados pelo financeiro.
    @type  Static Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
Static Function pedFat()

    //Vari�veis.
    Local aArea   := GetArea()
    Local cQuery  := scptPedAprov()
    Local cAlias  := GetNextAlias()
    Local cPedido := ""
    Local cNota   := ""
    Local cSerie  := ""
    Local lLib    := .F.

    DbUseArea(.T., "TOPCONN", TcGenQry(,,cQuery), cAlias, .T., .T.)
    (cAlias)->(DbGoTop())

    While ! (cAlias)->(Eof())

        cPedido := (cAlias)->ZJA_NUM
        cNota   := (cAlias)->C5_NOTA
        cSerie  := (cAlias)->C5_SERIE
        lLib    := (cAlias)->C5_XPREAPR == "L" .And. (cAlias)->C5_FLAGFIN == "L"

        If ! Empty(cNota)
        
            If cNota <> "XXXXXXXXX" 
                U_ADV1180A(cPedido, cNota, cSerie, .T.) //Altera status no pedido de venda - faturamento.

            Else
                U_ADV1180J(cPedido) //Elimina��o de res�duo do pedido de venda.

            EndIf

        ElseIf lLib
            U_ADV1180H(cPedido) //Aprova��o financeira do pedido de venda.

        EndIf

        (cAlias)->(DbSkip())

    End

    (cAlias)->(DbCloseArea())

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} scptPedAprov
    Script sql.
    @type  Static Function
    @author Everson
    @since 23/05/2023
    @version 01
/*/
Static Function scptPedAprov()

    //Vari�veis.
    Local cQuery := ""

    cQuery := ""
    cQuery += " SELECT " 
        cQuery += " ZJA_NUM, ZJA.R_E_C_N_O_ AS REC, C5_NOTA, C5_SERIE, C5_XPREAPR, C5_FLAGFIN " 
    cQuery += " FROM " 
        cQuery += " " + RetSqlName("ZJA") + " (NOLOCK) AS ZJA " 
        cQuery += " INNER JOIN " 
        cQuery += " " + RetSqlName("SC5") + " (NOLOCK) AS SC5 ON " 
        cQuery += " ZJA_NUM = C5_NUM "
        cQuery += " AND SC5.D_E_L_E_T_ = '' " 
    cQuery += " WHERE " 
    cQuery += " ZJA_LOCEXP = '" + cEmpAnt + cFilAnt + "' " 
        cQuery += " AND CAST(ZJA_DTINC AS DATE) >= CAST(GETDATE() -1 AS DATE) " 
        cQuery += " AND ZJA_INTSC5 = '1' " 
        cQuery += " AND ZJA_STATUS NOT IN ('8','7','5','6') "  //Cancelado, reprovado comercial, reprovado financeiro e faturado.
        cQuery += " AND ZJA.D_E_L_E_T_ = '' " 
    cQuery += " ORDER BY " 
        cQuery += " ZJA_NUM " 

Return cQuery
