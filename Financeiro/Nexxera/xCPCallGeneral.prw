#include "protheus.ch"       		

/*/{Protheus.doc} User Function xCPCallGeneral
	Job para processamento de Retorno de Pagamentos, Extratos e DDA
	@type  Function
	@author Alexandre Zapponi
	@since 24/02/20
	@history ticket 81491 - Abel Babini - 27/12/2022 - Projeto Nexxera - Retorno de baixas
	/*/
User Function xCPCallGeneral() 

if	MsgYesNo("Confirma processamento dos arquivos do Contas a Pagar ?")
 	FwMsgRun( Nil , { || Inkey(01) , U_xJobRetTit()	, Inkey(01)	} , 'Processando' , "Buscando Retornos de Pagamentos ..."	)
	FwMsgRun( Nil , { || Inkey(01) , U_xJobRetExt()	, Inkey(01)	} , 'Processando' , "Buscando Extratos Bancários ..." 		)   		
 	FwMsgRun( Nil , { || Inkey(01) , U_xJobRetDDA()	, Inkey(01)	} , 'Processando' , "Buscando Arquivos de DDA ..." 			)
endif

Return 
