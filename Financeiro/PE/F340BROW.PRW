#include "protheus.ch"

/*{Protheus.doc} User Function F340BROW
	Garante uma unica thread por empresa
	@type  Function
	@author FWNM
	@since 31/10/2019
	@version 01
	@history Chamado 049953 - FWNM            - 31/10/2019 - 049953 || OS 051296 || CONTROLADORIA || MONIK_MACEDO || 8956 || CONTAB. IMBOLIZADO  
*/

User Function F340BROW()   

	Local cKeyBloq := "FINA340" // Compensacao contas pagar

	// Garanto uma unica thread por empresa sendo executada
	If !LockByName(cKeyBloq, .T., .F.)
		msgAlert("[F340BROW-01] - Existe outro processamento sendo executado! Aguarde ou pe�a para seu colega de trabalho fechar a rotina... Esta rotina ser� desconectada pelo administrador...")
		KillApp(.T.)
	EndIf
		
Return