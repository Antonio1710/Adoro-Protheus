#include "Rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} User Function ADEST054P
    Gera lote de producao por integra��o do SAG na empresa Ad'oro filial 04.
    Chamado 7989.
    @type  Function
    @author Everson
    @since 13/01/2021
    @version 01
    @history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
    /*/
User Function ADEST054P()  // U_ADEST054P()

    //Vari�veis.
    Local lAutoJob := .F.

    //
    If Select("SX6") == 0
        lAutoJob := .T.

    EndIf

    //
    If lAutoJob

        RpcClearEnv()
        RpcSetType(3)
        RpcSetEnv("01","04",,,,GetEnvServer(),{})

        //
        If ! LockByName("ADEST054P", .T., .F.)
            ConOut("[ADEST054P] - Existe outro processamento sendo executado! Verifique...")
            RPCClearEnv()
            Return Nil 

        EndIf

        //	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
        //FWMonitorMsg(ALLTRIM(PROCNAME()))

    EndIf

        //
        Conout( DToC(Date()) + " " + Time() + " ADEST054P - In�cio Job de importa��o de lotes de cria��o do SAG. Emp/Fil " + cEmpAnt + "/" + cFilAnt )

        //
        logZBN("1","ADEST054P")

        //
        U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),"Gera lote de producao por integra��o do SAG")
        
            //
            //Static Call(ADEST034P,procRot)
            //@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
            u_EST034A0()            

        //
        logZBN("2","ADEST054P")

        //
        Conout( DToC(Date()) + " " + Time() + " ADEST054P - Fim Job de importa��o de lotes de cria��o do SAG. Emp/Fil " + cEmpAnt + "/" + cFilAnt )

     //
    If lAutoJob 

        //
        UnLockByName("ADEST054P")

		RpcClearEnv()

	Endif

Return Nil
/*/{Protheus.doc} logZBN
    Gera log na tabela ZBN. Chamado 058675.
    @type  Static Function
    @author Everson
    @since 04/01/2021
    @version 01
    /*/
Static Function logZBN(cStatus,cJob)

    //Vari�veis.
	Local aArea	:= GetArea()
	
	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + cJob))
	
		RecLock("ZBN",.F.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_ROTINA	:= cJob 
			ZBN_DATA    := dDataBase
			ZBN_HORA    := Time()
			ZBN_STATUS	:= cStatus
			
		MsUnlock() 
		
	Else
	
		RecLock("ZBN",.T.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_ROTINA	:= cJob 
			ZBN_DATA    := dDataBase
			ZBN_HORA    := Time()
			ZBN_STATUS	:= cStatus
	
		MsUnlock() 	
	
	EndIf
	
	ZBN->(dbCloseArea())
		
	RestArea(aArea)

Return Nil
