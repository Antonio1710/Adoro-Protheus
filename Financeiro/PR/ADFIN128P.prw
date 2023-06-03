#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'
#INCLUDE 'FWCOMMAND.CH'
#INCLUDE 'TBICONN.CH'
#INCLUDE 'RPTDEF.CH'

/*/{Protheus.doc} u_ADFIN128P
	ADFIN128P
	Funcao de processamento via schedule para verificacao dos pagamentos recebidos via PIX - Banco Bradesco.
	@type function
	@version 12.1.25
	@author Rodrigo Mello - Flek Solutions
	@since 11/01/2022
    @history ticket SISTEMAS - Fernando Macieira - 15/09/2022 - Adaptação filial 0B
    @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabilização pos golive migração dicionário dados
    @history ticket TI - Antonio Domingos - 03/06/2023 - Validação Ajuste Nova Empresa
/*/
function u_ADFIN128P( aParms, nE1Id, lRpc )

    local cEmp := ""
    local cFil := ""
    Local _cEmpFL3 := " " //ticket TI - Antonio Domingos - 03/06/2023 

    // @history ticket SISTEMAS - Fernando Macieira - 15/09/2022 - Adaptação filial 0B
    Local i
    Local aEmpresas  := {}
    //

    private nIdE1 := 0

    default aParms := {"","","01","02","",""}
    default nE1Id  := 0
    default lRpc := .T.

    nIdE1 := nE1Id
    
    cEmp := aParms[len(aParms)-3]
    cFil := aParms[len(aParms)-2]
    
    if lRpc

        PREPARE ENVIRONMENT EMPRESA cEmp FILIAL cFil MODULO 'FIN'

        // ticket TI - Fernando Macieira - 15/09/2022 - Adaptação filial 0B
        cEmp     := GetMV("MV_#WSBEMP",,"01")
        cFil     := GetMV("MV_#WSBFIL",,"02#0B")
        _cEmpFL3 := SuperGetMv("MV_#EMPFL3",.F.,"0102/010B/1301") //Codigos de Empresas+Filiais Ativas Grupo 3 //ticket TI - Antonio Domingos - 03/06/2023

        // Carrega Empresas para processamentos
        dbSelectArea("SM0")
        dbSetOrder(1)
        SM0->(dbGoTop())
        Do While SM0->(!EOF())
            //If (AllTrim(SM0->M0_CODIGO) $ cEmp) .and. (AllTrim(SM0->M0_CODFIL) $ cFil)
            If (AllTrim(SM0->M0_CODIGO)+AllTrim(SM0->M0_CODFIL) $ _cEmpFL3) //ticket TI - Antonio Domingos - 03/06/2023 
                aAdd(aEmpresas, { AllTrim(SM0->M0_CODIGO), AllTrim(SM0->M0_CODFIL) } ) // @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabilização pos golive migração dicionário dados
            EndIf
            SM0->( dbSkip() )
        EndDo

        // Processa empresas
        For i:=1 to Len(aEmpresas)
        
            RpcClearEnv()
            RpcSetType(3)
            RpcSetEnv( aEmpresas[ i,1 ] , aEmpresas[ i,2 ] )

            Execute()

        Next i

    endif

    //Execute() // ticket TI - Fernando Macieira - 15/09/2022 - Adaptação filial 0B

    if lRpc
        RESET ENVIRONMENT
    endif

    aParms := Nil
    cEmp := Nil
    cFil := Nil

return

static function Execute()
    local cAlias    := GetNextAlias()
	local cCondPix  := GetNewPar("MV_#CONPIX", "PIX")
    local dDataPrc  := dDataBase
    local cFilE1    := iif( nIdE1 > 0, '% and SE1.R_E_C_N_O_ = '+str(nIdE1)+' %', '%%')    

    private oReq    := JsonObject():new()
    private oRes
    private oPix    := ADFIN123P():New()

    dbSelectArea("SE1")
    dbSelectArea("SC5")
    dbSelectArea("SC9")

    beginSQL Alias cAlias
        SELECT
                FIE.R_E_C_N_O_ AS [FIE_RECNO], 
                SE1.R_E_C_N_O_ AS [E1_RECNO], 
                SC5.R_E_C_N_O_ AS [C5_RECNO],
                SA1.R_E_C_N_O_ AS [A1_RECNO]
        FROM 
            %table:FIE% FIE
            INNER JOIN %table:SC5% SC5  (NOLOCK)
                ON SC5.%notdel%
                AND FIE_FILIAL  = C5_FILIAL
                AND FIE_CART 	= 'R'
                AND FIE_PEDIDO  = C5_NUM
                AND FIE_CLIENT  = C5_CLIENTE
                AND FIE_LOJA    = C5_LOJACLI
                AND C5_EST		<> 'EX'
                AND C5_TIPO 	= 'N'
                AND C5_CONDPAG  = %exp:cCondPix%
                AND C5_EMISSAO  = %exp:dDataPrc%
            INNER JOIN %table:SE1% SE1  (NOLOCK)
                ON SE1.%notdel%
                AND FIE_FILIAL  = E1_FILIAL
                AND FIE_PREFIX  = E1_PREFIXO
                AND FIE_NUM		= E1_NUM
                AND FIE_PARCEL  = E1_PARCELA
                AND FIE_TIPO 	= E1_TIPO
                AND FIE_CLIENT  = E1_CLIENTE
                AND FIE_LOJA    = E1_LOJA
                AND E1_XLOGPIX  IN ('GER', 'EML')
                AND E1_TIPO     = 'PR '
                AND E1_SALDO    > 0
                %exp:cFilE1%
            INNER JOIN %table:SA1% SA1  (NOLOCK)
                ON SA1.%notdel%
                AND A1_FILIAL   = %xFilial:SA1%
                AND FIE_CLIENT  = A1_COD
                AND FIE_LOJA    = A1_LOJA
        WHERE 
                FIE.%notdel%
            AND FIE.FIE_FILIAL  = %xFilial:FIE%
    endSQL

    while (cAlias)->(!eof())
        SE1->(dbGoTo( (cAlias)->E1_RECNO ))
        SC5->(dbGoTo( (cAlias)->C5_RECNO ))
        if oReq:fromJson( SE1->E1_XMEMPIX ) == Nil .and. ;
            oPix:getPix( oReq, @oRes ) .and. ;
            upper(alltrim(oRes['status'])) == "CONCLUIDA" 
            fProcessa(oRes)
        endif
        (cAlias)->(dbSkip())
    enddo

    (cAlias)->(dbCloseArea())

    FreeObj(oReq)
    FreeObj(oRes)
    FreeObj(oPix)

return

//----------------------------------------------------------
Static Function fProcessa(oRes)
//----------------------------------------------------------
    local lBxPROk
    Private dDataCred := dDataBase

    lBxPROk := u_BxWSPR(.F., SE1->E1_FILIAL, SE1->E1_PREFIXO, SE1->E1_NUM, SE1->E1_PARCELA, SE1->E1_TIPO, SE1->E1_CLIENTE, SE1->E1_LOJA)

    If lBxPROk

        recLock("SC5", .f.)
            SC5->C5_XWSPAGO := "S"
            SC5->C5_XPREAPR := "L"
        SC5->( msUnLock() )

        SC9->( dbSetOrder(1) ) // C9_FILIAL, C9_PEDIDO, C9_ITEM, C9_SEQUEN, C9_PRODUTO, C9_BLEST, C9_BLCRED, R_E_C_N_O_, D_E_L_E_T_
        If SC9->( dbSeek(SC5->(C5_FILIAL+C5_NUM)) )
            Do While SC9->( !EOF() ) .and. SC9->C9_FILIAL==SC5->C5_FILIAL .and. SC9->C9_PEDIDO==SC5->C5_NUM 
                a450Grava(1,.T.,.T.)
                SC9->( dbSkip() )
            EndDo
        EndIf

    Else
        
        //logZBE( SC5->C5_NUM + " NAO GEROU RA! FATURAMENTO NAO LIBERADO PELO RETORNO API PIX BRADESCO" )
        //MessageBox( "Boleto n. " + SC5->C5_NUM + " não gerou RA! Faturamento não liberado...","WS Bradesco - Substituição Retorno CNAB PR -> RA", MB_ICONHAND )
    
    EndIf

return
