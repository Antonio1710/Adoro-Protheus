#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "FWMVCDef.ch"

/*/{Protheus.doc} ADFAT056P
    Job para envio de relatorio para tecnico ChatGuru Envios de Rações.
    Chamado 83060.
    @type  Function
    @author Jonathan
    @since 04/05/2023
    @version 01
/*/
User Function ADFAT067P() // U_ADFAT067P()

    //Variáveis.

	// RPCSetType(3)
	RpcSetEnv("01", "03",,,,GetEnvServer(),{ }) 

        U_ADFAT64C()

    RpcClearEnv()

Return Nil
