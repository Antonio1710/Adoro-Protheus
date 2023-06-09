#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} ADFIN092P
    Job para envio de mensagem de boleto pago ao Salesforce.
    @type  Function
    @author Everson
    @since 12/08/2020
    @version 01
    @history, Everson, 09/11/2020, Chamado 4597. Tratamento para a rotina considerar a data de entrega.
    @history, Everson, 10/11/2020, Chamado 4597. Adicionado o status "M" libera��o manual.
    @history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
    @history, Everson, 18/04/2022, Chamado 71231 - ajuste para atender a nova filial 0B.
    @history 19/04/2022, Everson, Chamado 71231, ajuste para atender a nova filial 0B.
    /*/
User Function ADFIN092P(aXEmpFil) //18/04/2022, Everson, Chamado 71231. // U_ADFIN092P()
	
	//Declara��o de vari�vies
	//18/04/2022, Everson, Chamado 71231.
	Default aXEmpFil :={ "01", "02" }
	
	//Inicia o ambiente.
	RPCClearEnv()
	RPCSetType(3)
	RpcSetEnv(aXEmpFil[1],aXEmpFil[2],,,,GetEnvServer(),{ })

        //
        U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Job para envio de mensagem de boleto pago ao Salesforce')


        //
        envMsgB()

	//Fecha o ambiente.
	RpcClearEnv()

Return Nil
/*/{Protheus.doc} envMsgB
    Processa o envio de mensagem de boleto ao Salesforce.
    @type  Static Function
    @author Everson
    @since 12/08/2020
    @version 01
    /*/
Static Function envMsgB()

    //Vari�veis.
    Local aArea  := GetArea()
    Local cQuery := script()
    Local cMsgBol:= Alltrim(cValToChar(GetMv("MV_#SFBOLA")))

    //
    If Select("D_ENVSTAT") > 0
        D_ENVSTAT->(DbCloseArea())

    EndIf
    
    //
    TcQuery cQuery New Alias "D_ENVSTAT"
    DbSelectArea("D_ENVSTAT")
    D_ENVSTAT->(DbGoTop())
    While ! D_ENVSTAT->(Eof())

        //
        If consulSF(D_ENVSTAT->C5_XSFPED,cMsgBol)

            //
            U_ADVEN050P(D_ENVSTAT->C5_NUM,.T.,.F.,"",.F.,.F.,.F.,.F.,.F.,.F.,0,3)

        EndIf

        //
        D_ENVSTAT->(DbSkip())

    End

    //
    D_ENVSTAT->(DbCloseArea())

    //
    RestArea(aArea)

Return Nil
/*/{Protheus.doc} script
    Script sql.
    @type  Static Function
    @author Everson
    @since 12/08/2020
    @version 01
    /*/
Static Function script()

    //Vari�veis.
    Local cQuery := ""

    //
    cQuery += " SELECT  " 
    cQuery += " C5_NUM, C5_XSFPED " 
    cQuery += " FROM " 
    cQuery += " " + RetSqlName("SC5") + " (NOLOCK) AS SC5 " 
    cQuery += " WHERE " 
    cQuery += " C5_FILIAL = '" + FWxFilial("SC5") + "' " 
    cQuery += " AND C5_XWSPAGO IN ('S','M') " //Everson - 10/11/2020. Chamado 4597.
    cQuery += " AND CAST(C5_DTENTR AS DATE) >= CAST(GETDATE() - 1 AS DATE) " //Everson - 09/11/2020. Chamado 4597.
    cQuery += " AND SC5.D_E_L_E_T_ = '' " 
    cQuery += " AND C5_XSFPED <> '' " 
    cQuery += " ORDER BY C5_NUM " 

Return cQuery
/*/{Protheus.doc} consulSF
    Consulta Salesforce para 
    @type  Static Function
    @author Everson
    @since 12/08/2020
    @version 01
    /*/
Static Function consulSF(cPdSF,cMsgBol)

	//Vari�veis.
	Local aArea		    := GetArea()
    Local lRetSF        := .F.
	Local aResponse	    := {}
	Local cMsg		    := ""
	Local lLogin	    := .F.
	Local cqueryPVSF	:= ""
	Local cServTab	    := "/services/data/v45.0/query?q="
    Local oParseJSON    := Nil
    Local nAux          := 1

	//
	//lLogin := Static Call(ADVEN075P,loginSF,@aResponse,@cMsg,.T.)
    //@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
    lLogin := u_VEN075A1(@aResponse,@cMsg,.T.)

	//
	If ! lLogin

        //
		Conout( DToC(Date()) + " " + Time() + " ADFIN092P - consulSF - N�o foi poss�vel efetuar login no SalesForce.")
		RestArea(aArea)
		Return lRetSF

	EndIf
	
	//
    cqueryPVSF := queryPVSF(cPdSF)
	
	//
	If ! U_ADVEN075P(cServTab + cqueryPVSF,"GET","",@cMsg,aResponse)

        //
		cMsg :=  Alltrim(cValToChar(cMsg))
		Conout( DToC(Date()) + " " + Time() + " ADFIN092P - Ocorreu erro na consulta no SalesForce:" + Chr(13) + Chr(10) + cMsg)
		RestArea(aArea)
		Return lRetSF
	
	EndIf
	
	//
	If ! FWJsonDeserialize(cMsg, @oParseJSON)

        //
        Conout( DToC(Date()) + " " + Time() + " ADFIN092P - Ocorreu erro na desserializa��o do json com os dados de login (Fun��o consulSF - ADFIN092P)." + Chr(13) + Chr(10) + "Json: " + Chr(13) + Chr(10) + cMsg)
		RestArea(aArea)
		Return lRetSF
			
	EndIf

    //
    For nAux := 1 To Len(oParseJSON:records)
        
        //
        If Alltrim(cValToChar(oParseJSON:records[nAux]:Texto_boleto__c)) <> cMsgBol
            lRetSF := .T.

        EndIf

    Next nAux

    //
    Conout( DToC(Date()) + " " + Time() + " ADFIN092P - consulSF - lRetSF " + cValToChar(lRetSF) )

    //
	RestArea(aArea)
		
Return lRetSF
/*/{Protheus.doc} queryPVSF
	Query de consulta de pedidos no SalesForce. 
	@type  Static Function
	@author Everson 
	@since 12/08/2020
	@version 01
	/*/
Static Function queryPVSF(cPdSF)
	
	//Vari�veis.
	Local aArea	 := GetArea()	
	Local cQuery := ""
	
	//
	cQuery := "Select+Texto_boleto__c+From+Order+WHERE+OrderNumber+=+'" + cPdSF + "'"

	//
	RestArea(aArea)
	
Return cQuery
