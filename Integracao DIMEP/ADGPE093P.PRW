#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'RESTFUL.CH'
#Include 'TOTVS.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} User Function ADGPE093P
    (long_description)
    @type  Function
    @author Adriano Savoine
    @since 22/02/2023
    @version 01
    @history
    /*/

User Function ADGPE093P()


	
	RPCClearEnv()
	RPCSetType(3)  //Nao consome licensas
    RpcSetEnv("01","02",,,,GetEnvServer(),{ }) //Abertura do ambiente em rotinas automáticas	
		
        RestUsuario()

	RpcClearEnv() 

    
Return Nil


/*/{Protheus.doc} RestUsuario
    (Função para bloqueio via REST dos usuarios do Protheus sem uso por 45 dias.)
    @type  Static Function
    @author Adriano Savoine
    @since 24/02/2023
    @version 01
/*/
Static Function RestUsuario()

    //Variáveis.
	Local aArea 	:= GetArea()
    Local cUrl      := Alltrim(cValToChar(GetMV("MV_#RESTPRO",,"http://adoro120215.protheus.cloudtotvs.com.br:8400/USERS/")))


    UsrSql()

    USR->( DbGoTop() )
	While USR->(!EOF())

        cUrl+= USR->USR_ID

        envJson(cUrl)

    
        USR->(dbSkip())
		cUrl:= Alltrim(cValToChar(GetMV("MV_#RESTPRO",,"http://adoro120215.protheus.cloudtotvs.com.br:8400/USERS/")))
	End
	
	USR->(DbCloseArea())  

    RestArea(aArea)
    
Return 


/*/{Protheus.doc} Static Function UsrSql
    Retorna o script Sql.
    @type  Static Function
    @author Adriano Savoine
    @since 24/02/2023
    @version 01
/*/
Static Function UsrSql()
    
    //Variáveis.
    Local cDiret := SuperGetMV("MV_#USRDIR", ,"'000000','000559','000224','000033','001047','001103','000605','001657','000071'")
    Local cQuery := ""
    

    cQuery := " SELECT USR_ID "
    cQuery += " FROM SYS_USR "
    cQuery += " WHERE (USR_DTLOGON <= CONVERT(date, GETDATE()-45) OR USR_DTLOGON IS NULL )"
    cQuery += " AND USR_MSBLQL <> '1'"
    cQuery += " AND USR_ID NOT IN ("+Alltrim(cDiret)+")"

    TCQUERY cQuery new alias "USR"

RETURN()     

/*/{Protheus.doc} envReq
    Envia requisição.
    @type  Static Function
    @author Adriano Savoine
    @since 24/06/2022
    @version 01
/*/
Static Function envJson(cUrl)

    //Variáveis.
	Local aArea 		:= GetArea()
	Local lRet			:= .T.
	Local oRestClient 	:= Nil
	Local lRest			:= .F.
    Local cChave        := Encode64("ADRIANO_SAVOINE:CRIS1004")

    Private aHeader	:= {}
    Private cBody       := SJSON()

	Default cServico	:= "/users/"
	Default cMsg		:= ""
	Default aResponse	:= {}

    Aadd(aHeader, "Content-Type: application/json")
	Aadd(aHeader, "Authorization:Basic " + cChave)

	oRestClient := FWRest():New(cUrl)
	oRestClient:setPath(cServico)

    //cMetodo == "Put"
    lRest := oRestClient:Put(aHeader, cBody)

   

	cMsg := ""

	If ! lRest

		If Substr(Alltrim(cValToChar(oRestClient:GetLastError())),1,1) <> "2" 

			cMsg := Alltrim(cValToChar(oRestClient:GetLastError())) + Chr(13) + Chr(10)
			cMsg += "URL: "      + cUrl + Chr(13) + Chr(10)
			cMsg += "EndPoint: " + cServico + Chr(13) + Chr(10)
			cMsg += "Body: "     + Chr(13) + Chr(10) + cValToChar(cBody) + Chr(13) + Chr(10)
			cMsg += "Resp: "     + Chr(13) + Chr(10) + Alltrim(cValToChar(oRestClient:GetResult())) + Chr(13) + Chr(10)
			lRet := .F.

		EndIf

	EndIf
	
	If lRet 
        cMsg := Alltrim(cValToChar(oRestClient:GetResult()))

	EndIf

	FreeObj(oRestClient)
	oRestClient := Nil
	RestArea(aArea)

Return lRet

/*/{Protheus.doc} Static Function SJSON
Função Pegando uma string (json) e transformando em objeto
@type  Function
@author Adriano Savoine
/*/
 
Static Function SJSON()
    Local aArea   := FWGetArea()
    Local cTexto  := '{"emails":[{"value":"@adoro.com.br","type":"work","primary":true}],"active":false}'
    Local oJson
    Local cJson   := ''
 
    //Pega o texto e transforma em objeto
    oJson := JsonObject():New()
    cJson := oJson:FromJson(cTexto)
 
    cJson := oJson:toJSON()

    FWRestArea(aArea)
Return cJson
