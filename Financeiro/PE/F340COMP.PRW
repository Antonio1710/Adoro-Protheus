#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"

/*/{Protheus.doc} User Function F340COMP
	Valida��o para n�o permitir compensar t�tulos em border�
	@type  Function
	@author Fernando Sigoli
	@since 10/09/2020
	@version 01
	@history Chamado    712 - O ponto de entrada F340COMP possibilita incluir valida��o para permitir compensar o t��tulo selecionado ou n�o
*/

USER FUNCTION F340COMP()

	Local lRet		:= .T.   
	Local cNcompen 	:= GetMV("MV_#NCOMP",,"PA,")
	Local aAreaAtu 	:= GetArea()

	If !Empty(SE2->E2_NUMBOR) .and. !(Alltrim(SE2->E2_TIPO) $ cNcompen)

		MsgStop("T�tulo " + SE2->E2_NUM  +" em Bordero. N�o � permitido compensar", "Aten��o. F340COMP-01 " )
		lRet := .F.

	EndIf

	

RestArea( aAreaAtu )

Return lRet
