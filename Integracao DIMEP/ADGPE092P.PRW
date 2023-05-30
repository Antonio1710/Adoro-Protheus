#INCLUDE "PROTHEUS.CH"  
#INCLUDE "TOPCONN.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} User Function ADGPE092P
	Integracao com o sistema DIMEP de Centro de Custos Adoro e Ceres
	@type  Function
	@author Adriano Savoine 
	@since 13/02/2023
	@version 01
	@history Ticket: TI - 13/02/2023 - Adriano Savoine - Ativa Centro de custo nos usuarios DIMEP.
/*/

User Function ADGPE092P(aParam) // U_ADGPE092P()

	
    Default aParam    	:= Array(2)
	Default aParam[1] 	:= "01"
	Default aParam[2] 	:= "02"
	//
	
	RPCClearEnv()
	RPCSetType(3)  //Nao consome licensas
    RpcSetEnv(aParam[1],aParam[2],,,,GetEnvServer(),{ }) //Abertura do ambiente em rotinas automáticas	
		
        BuscaUsu()

	RpcClearEnv() 

Return Nil

/*/{Protheus.doc} Static Function BuscaUsu
	(Essa Static function pega os perfis de acesso com referencia a tabela DIMEP PERFIL_SISTEMA onde, 
	Portaria é utilizado o 15 "Usuario Principal"
	RH é mais utilizado 18 "RH+Cad.Vis+Relogios de Pontos"
	Recrutamento é utilizado 4 "Recrutamento e Seleção")
	@type  Static Function
	@author Adriano Savoine
	@since 13/02/2023
	@version 01
	/*/

Static Function BuscaUsu()

    Local cCod  := ''
    Local nTotR := 0

    BeginSQL Alias "B_USU"
		%NoPARSER%  
        SELECT CD_USUARIO
            FROM [DMPACESSO].[DMPACESSOII].[dbo].USUARIO_SISTEMA
            WHERE CD_PERFIL_SISTEMA IN ('15','18','4')
        AND TP_STATUS = '0'
    EndSQl 

    DbSelectArea("B_USU")
	B_USU->(DbGoTop())

	While ! B_USU->(Eof())

        cCod:= B_USU->CD_USUARIO 

        USUVP(cCod)
        nTotR := Contar("TRV","!Eof()")

        IF nTotR > 0

            IntCcVp(cCod)

        ENDIF

        USUCR(cCod)
        nTotR := Contar("TRC","!Eof()")

        IF nTotR > 0

            IntCcCr(cCod) 

        ENDIF

	    B_USU->(DbSkip())

	End

	//
	B_USU->(DbCloseArea())
Return Nil

/*/{Protheus.doc} Static Function IntCcVp
	(Ativa Centro de Custo na Estrutura Varzea Paulista Adoro)
	@type  Function
	@author Adriano Savoine
	@since 13/02/2023
	@version 01
	/*/

Static Function IntCcVp(cCod)   

    
    cQuery := "INSERT INTO [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORG_USUARIO_SISTEMA (CD_ESTRUTURA_ORGANIZACIONAL, CD_USUARIO) " 
	cQuery += "(SELECT CD_ESTRUTURA_ORGANIZACIONAL, " 
	cQuery += "'"+cValToChar(cCod)+"'"
	cQuery += "FROM [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORGANIZACIONAL "
	cQuery += "WHERE CD_ESTRUTURA_RELACIONADA = '9' " 
	cQuery += "AND TP_ESTRUTURA = '1' " 
	cQuery += "AND NU_ESTRUTURA NOT IN (SELECT EO.NU_ESTRUTURA FROM [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORG_USUARIO_SISTEMA AS US " 
	cQuery += "INNER JOIN [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORGANIZACIONAL AS EO  " 
	cQuery += "ON EO.CD_ESTRUTURA_ORGANIZACIONAL = US.CD_ESTRUTURA_ORGANIZACIONAL   " 
    cQuery += "AND EO.CD_ESTRUTURA_RELACIONADA = '9'
    cQuery += "AND EO.TP_ESTRUTURA = '1'
    cQuery += " WHERE US.CD_USUARIO = '"+cValToChar(cCod)+"'))
	
	If (TCSqlExec(cQuery) < 0)
    	cIntregou += " TCSQLError() IntCredencial:"
	EndIf        
	
Return Nil 

/*/{Protheus.doc} Static Function IntCcCr
	(Ativa Centro de Custo na Estrutura Varzea Paulista Ceres)
	@type  Function
	@author Adriano Savoine
	@since 13/02/2023
	@version 01
	/*/

Static Function IntCcCr(cCod)   

    
    cQuery := "INSERT INTO [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORG_USUARIO_SISTEMA (CD_ESTRUTURA_ORGANIZACIONAL, CD_USUARIO) " 
	cQuery += "(SELECT CD_ESTRUTURA_ORGANIZACIONAL, " 
	cQuery += "'"+cValToChar(cCod)+"'"
	cQuery += "FROM [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORGANIZACIONAL "
	cQuery += "WHERE CD_ESTRUTURA_RELACIONADA = '17' " 
	cQuery += "AND TP_ESTRUTURA = '1' " 
	cQuery += "AND NU_ESTRUTURA NOT IN (SELECT EO.NU_ESTRUTURA FROM [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORG_USUARIO_SISTEMA AS US " 
	cQuery += "INNER JOIN [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORGANIZACIONAL AS EO   " 
	cQuery += "ON EO.CD_ESTRUTURA_ORGANIZACIONAL = US.CD_ESTRUTURA_ORGANIZACIONAL   " 
    cQuery += "AND EO.CD_ESTRUTURA_RELACIONADA = '17'
    cQuery += "AND EO.TP_ESTRUTURA = '1'
    cQuery += " WHERE US.CD_USUARIO = '"+cValToChar(cCod)+"'))
	
	If (TCSqlExec(cQuery) < 0)
    	cIntregou += " TCSQLError() IntCredencial:"
	EndIf        
	
Return Nil 

/*/{Protheus.doc} Static Function USUVP
	(Verifica usuarios de sistema em Varzea Paulista Adoro)
	@type  Function
	@author Adriano Savoine
	@since 13/02/2023
	@version 01
	/*/

Static Function USUVP(cCod)
	
	Local cQuery  := ""

    If Select("TRV") > 0
		TRV->(DbCloseArea())

	EndIf


	//
	cQuery := " SELECT CD_ESTRUTURA_ORGANIZACIONAL "
	cQuery += " FROM [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORGANIZACIONAL "
	cQuery += " WHERE CD_ESTRUTURA_RELACIONADA = '9' "
	cQuery += " AND TP_ESTRUTURA = '1' "
	cQuery += " AND NU_ESTRUTURA NOT IN (SELECT EO.NU_ESTRUTURA FROM [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORG_USUARIO_SISTEMA AS US "
	cQuery += " INNER JOIN [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORGANIZACIONAL AS EO ON "
	cQuery += " EO.CD_ESTRUTURA_ORGANIZACIONAL = US.CD_ESTRUTURA_ORGANIZACIONAL "
	cQuery += " AND EO.CD_ESTRUTURA_RELACIONADA = '9'"
	cQuery += " AND EO.TP_ESTRUTURA = '1'"
	cQuery += " WHERE US.CD_USUARIO = '"+cValToChar(cCod)+"')"
	
	TcQuery cQuery New Alias "TRV"
	

Return Nil


/*/{Protheus.doc} Static Function USUCR
	(Verifica usuarios de sistema em Varzea Paulista Ceres)
	@type  Function
	@author Adriano Savoine
	@since 13/02/2023
	@version 01
	/*/

Static Function USUCR(cCod)
	
	Local cQuery  := ""

    If Select("TRC") > 0
		TRC->(DbCloseArea())

	EndIf

	
	cQuery := " SELECT CD_ESTRUTURA_ORGANIZACIONAL "
	cQuery += " FROM [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORGANIZACIONAL "
	cQuery += " WHERE CD_ESTRUTURA_RELACIONADA = '17' "
	cQuery += " AND TP_ESTRUTURA = '1' "
	cQuery += " AND NU_ESTRUTURA NOT IN (SELECT EO.NU_ESTRUTURA FROM [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORG_USUARIO_SISTEMA AS US "
	cQuery += " INNER JOIN [DMPACESSO].[DMPACESSOII].[dbo].ESTRUTURA_ORGANIZACIONAL AS EO ON "
	cQuery += " EO.CD_ESTRUTURA_ORGANIZACIONAL = US.CD_ESTRUTURA_ORGANIZACIONAL "
	cQuery += " AND EO.CD_ESTRUTURA_RELACIONADA = '17'"
	cQuery += " AND EO.TP_ESTRUTURA = '1'"
	cQuery += " WHERE US.CD_USUARIO = '"+cValToChar(cCod)+"')"
	
	TcQuery cQuery New Alias "TRC"
	

Return Nil
