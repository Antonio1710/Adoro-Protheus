#Include "Protheus.ch"

/*/{Protheus.doc} User Function ADFAT025P
    Job para obter os registros de pesagem do Guardian.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 03/12/2021
    @version 01
    @history Everson, 06/02/2023, ticket 18465 - Tratamento para enviar ao barramento comunicação do job com a balança.
/*/
User Function ADFAT025P(aXEmpFil) // U_ADFAT025P()

    Default aXEmpFil:= {"01", "03"}

    RPCSetType(3)
	RpcSetEnv(aXEmpFil[1], aXEmpFil[2],,,,GetEnvServer(),{ })

        U_ADFAT251()

	RpcClearEnv()

Return Nil
/*/{Protheus.doc} User Function ADFAT251
    Processa obtenção dos registros de pesagem do Guardian.
    Chamado 18465.
    @type  Function
    @author Everson
    @since 01/04/2022
    @version 01
/*/
User Function ADFAT251()

    //Variáveis.
    Local nCount      := 1
    Local nCiclos	  := GetMV("MV_#ADF252",,900)
    Local lBarramento := GetMv("MV_#ADF251",,.T.) //Registros de pesagem vindos do barramento.
    Local nSleep      := GetMv("MV_#FAT290",,1000)

    While nCount <= nCiclos

        Conout(DToC(Date()) + " " + Time() + " ADFAT025P - Ciclos Balança " + cValToChar(nCount))
        
        If lBarramento
            U_ADFAT29H() //Processa registros de pesagem vindos pelo barramento.
        
        Else
            U_ADFAT24C() //Obtém registros diretamente do WS da balança.

        EndIf

        U_ADFAT24D() //Processa registros de pesagem.

        U_ADFAT29O() //Processa requisições que devem ser enviadas à balança.
 
        If Time() > "23:50:00"
            Exit

        EndIf

        Sleep(nSleep)

        nCount++

    End

Return Nil
