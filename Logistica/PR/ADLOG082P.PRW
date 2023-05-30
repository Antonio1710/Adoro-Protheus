#Include "Topconn.ch"

/*/{Protheus.doc} User Function ADLOG082P
    Função retorna quantidade de viagens e data da última 
    viagem feita pela transportadora.
    Chamado 78982.
    @type  Function
    @author Everson
    @since 30/08/2022
    @version 01
/*/
User Function ADLOG082P(cCampo, cTransp, cLoja)

    //Variáveis.
    Local aArea     := GetArea()
    Local cQuery    := ""
    Local xRet   := 0
    Local cOcorr    := Alltrim(cValToChar(GetMv("MV_ADOG811",,"011")))
    Local cNewAlias := GetNextAlias()

    cQuery := ""
    cQuery += " SELECT  " 
        cQuery += " MAX(ZFA_DTENTR) AS ZFA_DTENTR, "    
        cQuery += " COUNT(DISTINCT ZFA_CARGA) AS QTD_CARGA " 
    cQuery += " FROM "
        cQuery += " " + RetSqlName("ZFA") + " (NOLOCK) AS ZFA  " 
    cQuery += " WHERE  " 
        cQuery += " ZFA_FILIAL = '" + FWxFilial("ZFA") + "'  " 
        cQuery += " AND ZFA_TRANSP = '" + cTransp + "'  " 
        cQuery += " AND ZFA_LOJTRA = '" + cLoja + "'  " 
        cQuery += " AND ZFA_CARGA <> ''  " 
        cQuery += " AND ZFA_OCORRE IN " + FormatIn(cOcorr, "/") + " " 
    cQuery += " AND D_E_L_E_T_ = '' "

    DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery), cNewAlias, .F., .T. ) 

    (cNewAlias)->(DbGoTop())

        If cCampo == "A4_XQTDVIA"
             xRet := Val(CValToChar((cNewAlias)->QTD_CARGA))

        ElseIf cCampo == "A4_XDTUCAR"
            xRet := SToD(Alltrim(cValToChar((cNewAlias)->ZFA_DTENTR)))

        EndIf

    (cNewAlias)->(DbCloseArea())

    RestArea(aArea)

Return xRet

