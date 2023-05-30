#include "protheus.ch"

/*/{Protheus.doc} User Function ADOA005
	Este ponto de entrada � executado ap�s as aberturas dos SXs(dicion�rio de dados).Ao acessar pelo SIGAMDI, este ponto de entrada � chamado ao entrar na rotina. Pelo modo SIGAADV, a abertura dos SXs � executado ap�s o login.
	@type  Function
	@author William Costa
	@since 04/12/2019
	@version 01
	@history Chamado T.I - William Costa - 07/02/2020 - Adicionado parametro para habilitar e desabilitar o log de login
	@history Ticket 82578   - Fernando Macieira - 08/11/2022 - Transfer�ncia de Ativo - Lock SX5
	@history Ticket TI 17/02/2023 - Fernando Macieira - CONSISTE AMBIENTE
/*/    
User Function AfterLogin()

	Local cId	    := ParamIXB[1]
	Local cNome     := ParamIXB[2]     
	Local nCod      := 0
	Local cAmbAllow := GetMV("MV_#AMBADO",,"CCZERN_|PMACIEIRA")

	// @history Ticket TI 17/02/2023 - Fernando Macieira - CONSISTE AMBIENTE
	If !(Left(AllTrim(GetEnvServer()),7) $ cAmbAllow)
		
		Alert("Voc� entrou em ambiente n�o autorizado! Voc� ser� desconectado...")
		KillApp(.t.)
		__QUIT()

	EndIf

	If Left(AllTrim(GetEnvServer()),9) == "PMACIEIRA" .and. DtoS(msDate()) < "20230310"
		Alert("Voc� entrou em ambiente n�o autorizado! Voc� ser� desconectado...")
		KillApp(.t.)
		__QUIT()
	EndIf

	If Left(AllTrim(GetEnvServer()),9) == "PMACIEIRA2" .and. DtoS(msDate()) < "20230308"
		Alert("Voc� entrou em ambiente n�o autorizado! Voc� ser� desconectado...")
		KillApp(.t.)
		__QUIT()
	EndIf

	//

	IF GETMV("MV_#LGLOGI",,.F.) == .T.
			 
		SqlContador()

		While TRB->(!EOF())

			IF ALLTRIM(TRB->ZFV_COD) == ''
				nCod := 1
			ELSE
				nCod := VAL(TRB->ZFV_COD) + 1
			ENDIF
			
			TRB->(dbSkip())
											
		ENDDO

		TRB->(dbCloseArea())
					
		IF RECLOCK("ZFV",.T.)
			ZFV->ZFV_COD    := STRZERO(nCod,20)
			ZFV->ZFV_ID     := cId
			ZFV->ZFV_NOME   := cNome
			ZFV->ZFV_DATA   := DATE()
			ZFV->ZFV_HORA   := TIME()
			ZFV->ZFV_SENTID := 'ENTRADA'
			ZFV->ZFV_MODULO := 'SIGA' + CMODULO

			ZFV->( MSUNLOCK() ) // @history Ticket 82578   - Fernando Macieira - 08/11/2022 - Transfer�ncia de Ativo - Lock SX5 (inclus�o do alias no msunlock)
		ENDIF

	ENDIF

	//ApMsgAlert("Cod:" + STRZERO(nCod,20) + " Usu�rio "+ cId + " - " + Alltrim(cNome)+" efetuou login �s "+Time())
		
Return(NIL)

Static Function SqlContador()

	BeginSQL Alias "TRB"

		%NoPARSER%

		SELECT MAX(ZFV_COD) AS ZFV_COD
		FROM ZFV010 WITH (NOLOCK)
			 
	EndSQl             

RETURN(NIL) 
