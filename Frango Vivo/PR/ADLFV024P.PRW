#include 'protheus.ch'
#include 'parmtype.ch'
#Include 'TOTVS.ch'
#Include 'Topconn.ch'

/*/{Protheus.doc} User Function ADLFV024P
    (Programa para ajustar as pesagens de Frango Vivo do Edata que não integraram corretamente no Protheus.)
    @type  Function
    @author Adriano Savoine
    @since 19/04/2023
    @version 01
    @history Ticket: 92238 - 19/04/2023 - ADRIANO SAVOINE - Rotina elaborada para corrigir falhas na integração.
    @history Ticket: 92619 - 27/04/2023 - ADRIANO SAVOINE - Corrigido para corrigir a Filial de Itapira quando ocorrer alguma Falha na integração.
    /*/

User Function ADLFV024P(aParam)

    //Default aParam    	:= Array(2)
	//Default aParam[1] 	:= "01"
	//Default aParam[2] 	:= "02"
	
	RPCClearEnv()
	RPCSetType(3)  //Nao consome licensas
    RpcSetEnv(aParam[1],aParam[2],,,,GetEnvServer(),{ }) //Abertura do ambiente em rotinas automáticas	
		
        AjustaPesagem()

	RpcClearEnv() 

    
Return Nil


Static Function AjustaPesagem()

    //Variáveis.
	Local aArea 	:= GetArea()
    Local cGuia     := ''

    ConsultaEdata()

    PesaEdata->( DbGoTop() )
	While PesaEdata->(!EOF())

        cGuia:= PesaEdata->ZV1GUIAPE

        If EMPTY(cGuia)

            cGuia:= NovaGuia()

            DbSelectArea("ZV2")
            RecLock("ZV2", .T.)	

                ZV2->ZV2_FILIAL  := xFilial("ZV2")
                ZV2->ZV2_GUIA    := cGuia
                ZV2->ZV2_TIPOPE  := 'F'
                ZV2->ZV2_PLACA   := PesaEdata->GN_PLACCAMIENTRAVEVIVA
                ZV2->ZV2_DATA1   := StoD(PesaEdata->ZV2DATA1)
                ZV2->ZV2_HORA1   := PesaEdata->ZV2HORA1
                ZV2->ZV2_KMENT   := PesaEdata->QN_KMINICENTRAVEVIVA
                ZV2->ZV2_KMSAI   := PesaEdata->QN_KMFINAENTRAVEVIVA
                ZV2->ZV2_1PESO   := PesaEdata->TARA + PesaEdata->PESLIQ
                ZV2->ZV2_2PESO   := PesaEdata->TARA
                ZV2->ZV2_OBS3    := 'NAO TEM'
                ZV2->ZV2_X_PESE  := PesaEdata->ID_ENTRAVEVIVA

            MsUnLock() // Confirma e finaliza a operação


        EndIf

        DbSelectArea("ZV1")
        ZV1->(DbSetOrder(3))
        If ZV1->(DbSeek(AllTrim(PesaEdata->ZV1_FILIAL) + AllTrim(PesaEdata->ID_LOTECRIAEXTEENTRAVEVIVA)))	
            RecLock("ZV1", .F.)	

                ZV1->ZV1_GUIAPE  := cGuia
                ZV1->ZV1_NUMNFS  := PesaEdata->NOTA
				ZV1->ZV1_NUMGTA  := PesaEdata->GTA
				ZV1->ZV1_SERIE   := '01'
				ZV1->ZV1_TARAPD  := PesaEdata->TARA
				ZV1->ZV1_STATUS  := 'R'
				ZV1->ZV1_LACRE1  := PesaEdata->NR_LACR1ENTRAVEVIVA
				ZV1->ZV1_LACRE2  := PesaEdata->NR_LACR2ENTRAVEVIVA
				ZV1->ZV1_PAVES   := PesaEdata->QN_CABEENTRAVEVIVA
				ZV1->ZV1_RELOTE  := PesaEdata->NR_LOTECOMPENTRAVEVIVA
                ZV1->ZV1_PESOME  := PesaEdata->PESOME
                ZV1->ZV1_RPESOT  := PesaEdata->RPESOT
                ZV1->ZV1_PPESOT  := PesaEdata->PESOME * PesaEdata->QN_CABEENTRAVEVIVA
                ZV1->ZV1_PESLIQ  := PesaEdata->PESLIQ
                ZV1->ZV1_X_PESE  := PesaEdata->ID_ENTRAVEVIVA
                ZV1->ZV1_FECHA   := '2'
            
            MsUnLock() //Confirma e finaliza a operação
        EndIf
        
        


        PesaEdata->(dbSkip())
    End

    RestArea(aArea)
Return 


Static Function ConsultaEdata()

    Local cLinkSe  	:= Alltrim(SuperGetMV("MV_#UEPSRV",,"LNKMIMS"))
    Local cQuery    := ""

    cQuery := "SELECT  ZV1.ZV1_FILIAL,EAV.ID_LOTECRIAEXTEENTRAVEVIVA, "
    cQuery += "CASE WHEN ZV1.ZV1_GUIAPE IS NULL THEN  (SELECT ZV2_GUIA FROM "+retsqlname("ZV2")+" WHERE ZV2_FILIAL = '"+xFilial("ZV2")+"' AND ZV2_X_PESE IN (ZV1.ZV1_X_PESE)) ELSE ZV1.ZV1_GUIAPE  END ZV1GUIAPE,EAV.NR_NOTAFISCENTRAVEVIVA, "
    cQuery += "CAST(REPLICATE(' ', 6 - LEN(CAST(NR_GTAENTRAVEVIVA AS CHAR(6)))) + CAST(NR_GTAENTRAVEVIVA AS CHAR(6)) AS VARCHAR) AS GTA, "
    cQuery += "EAV.DT_ENTRCAMIENTRAVEVIVA,EAV.FL_CLIMCARRENTRAVEVIVA,EAV.FL_CLIMVOLTENTRAVEVIVA,EAV.NR_LACR1ENTRAVEVIVA,EAV.NR_LACR2ENTRAVEVIVA, "
    cQuery += "EAV.QN_CABEENTRAVEVIVA,CAST(REPLICATE(' ', 6 - LEN(CAST(NR_NOTAFISCENTRAVEVIVA AS CHAR(6)))) + CAST(NR_NOTAFISCENTRAVEVIVA AS CHAR(6)) AS VARCHAR) AS NOTA, "
    cQuery += "REPLICATE(' ', 10 - LEN(CAST(EAV.ID_ENTRAVEVIVA AS CHAR(10)))) + CAST(EAV.ID_ENTRAVEVIVA AS CHAR(10)) AS ID_ENTRAVEVIVA, "
    cQuery += "EAV.QN_PESOTARAENTRAVEVIVA,EAV.GN_OBSETARAENTRAVEVIVA,EAV.GN_PLACCAMIENTRAVEVIVA, "
    cQuery += "CAST(((QN_PESOBRUTENTRAVEVIVA - QN_PESOTARAENTRAVEVIVA) / QN_CABEENTRAVEVIVA) AS DECIMAL(10,2)) AS PESOME, "
    cQuery += "CAST((QN_PESOBRUTENTRAVEVIVA  - QN_PESOTARAENTRAVEVIVA + '0')+ ((QN_PESOBRUTENTRAVEVIVA - QN_PESOTARAENTRAVEVIVA + '0') * 0.007)as NUMERIC(15,2)) AS RPESOT, "
    cQuery += "CAST((QN_PESOBRUTENTRAVEVIVA  - QN_PESOTARAENTRAVEVIVA) AS NUMERIC(15,2)) AS PESLIQ, "
    cQuery += "CONVERT(CHAR(8),DT_ENTRCAMIENTRAVEVIVA,108) AS ZV2HORA1, "
    cQuery += "COALESCE(QN_PESOTARAENTRAVEVIVA, 0) AS TARA, "
    cQuery += "SUBSTRING(CONVERT(VARCHAR(10),DT_ENTRCAMIENTRAVEVIVA, 23), 1, 4) + SUBSTRING(CONVERT(VARCHAR(10),DT_ENTRCAMIENTRAVEVIVA, 23), 6, 2) + SUBSTRING(CONVERT(VARCHAR(10),DT_ENTRCAMIENTRAVEVIVA, 23), 9, 2) AS ZV2DATA1, "
    cQuery += "EAV.DT_SAIDCAMIENTRAVEVIVA,CONVERT(CHAR(8),EAV.DT_SAIDCAMIENTRAVEVIVA,108)AS HR_SAIDCAMIENTRAVEVIVA,EAV.QN_PESOBRUTENTRAVEVIVA,EAV.FL_CLIMBALAENTRAVEVIVA,EAV.QN_GAIOENTRAVEVIVA, "
    cQuery += "QN_KMINICENTRAVEVIVA,QN_KMFINAENTRAVEVIVA,NR_LOTECOMPENTRAVEVIVA "
    cQuery += "FROM ["+cLinkSe+"].[SMART].[dbo].ENTRADA_AVE_VIVA EAV  WITH (NOLOCK) "
    cQuery += "INNER JOIN "+retsqlname("ZV1")+" ZV1 WITH (NOLOCK) "
    cQuery += "ON ZV1.ZV1_NUMOC = EAV.ID_LOTECRIAEXTEENTRAVEVIVA COLLATE Latin1_general_CI_AS "
    cQuery += "AND ZV1.ZV1_FILIAL = '"+xFilial("ZV1")+"' "
    cQuery += "AND ZV1.D_E_L_E_T_ = '' "
    cQuery += "AND (ZV1.ZV1_FECHA = '' OR ZV1.ZV1_GUIAPE = '') "
    cQuery += "WHERE CONVERT(date,EAV.DT_ENTRCAMIENTRAVEVIVA) >= CONVERT(date, GETDATE() -5) "
    cQuery += "AND CONVERT(date,EAV.DT_ENTRCAMIENTRAVEVIVA) <=  CONVERT(date, GETDATE()) "
    cQuery += "AND EAV.FL_STATENTRAVEVIVA = 'FE' "
    cQuery += "AND EAV.FL_STATPENDENTRAVEVIVA = 'FE' "

    TcQuery cQuery New alias "PesaEdata"
    
Return 


Static Function NovaGuia()

    If Select("MaxGuia") > 0
     dbSelectArea("MaxGuia")
     dbCloseArea()
    EndIf

    BeginSQL Alias "MaxGuia"
		%NoPARSER%  

       SELECT REPLICATE(' ', 6 - LEN(CAST(PROX AS CHAR(6)))) + CAST(PROX AS CHAR(6)) AS PROXIMO
        FROM (SELECT MAX (ZV2.ZV2_GUIA)+1 AS PROX
                 FROM %TABLE:ZV2% ZV2 WITH (NOLOCK)   
                 WHERE ZV2.D_E_L_E_T_ = '')M

		
	EndSQl

    
Return (MaxGuia->PROXIMO)
