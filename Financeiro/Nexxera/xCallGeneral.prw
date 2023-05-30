#include "protheus.ch"

/*/{Protheus.doc} User Function XCALLGENERAL
	Job para processamento do retorno de cobrança
	@type  Function
	@author Alexandre Zapponi
	@since 24/02/20
	@history ticket 81491 - Abel Babini - 27/12/2022 - Projeto Nexxera - Retorno de baixas
	@history ticket 81491 - Abel Babini - 19/05/2023 - Projeto Nexxera - Atualização do fonte para baixas Contas a Receber via Menu
	/*/

User Function xCallGeneral()     

Local xFilAnt	:=	cFilAnt

if	MsgYesNo("Confirma processamento dos arquivos do Contas a Receber ?")
 	FwMsgRun( Nil , { || Inkey(01) , U_xFinA205()	, Inkey(01)	} , 'Processando' , "Buscando Retornos de Cobrança ..."		)
endif

cFilAnt := xFilAnt 

Return 
