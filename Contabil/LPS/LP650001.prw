#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'PARMTYPE.CH'

/*/{Protheus.doc} LP650001
    (long_description)
    @type  Function User
    @author Antonio Domingos
    @since 10/04/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    U_LP650001("DEBITO")
    U_LP650001("CREDITO")
    @see (links_or_references)
    @history ticket 91380 - Antonio Domingos - 10/04/2023 - LP 650-001 NFE ITEM P/ESTOQUE / Empresa ADORO (despojos)
/*/
USER FUNCTION LP650001(_cTipoCta)

	Local cRet := SD1->D1_CONTA

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
    If _cTipoCta == "DEBITO"
        IF SD1->D1_GRUPO == "9047" .AND. ALLTRIM(SD1->D1_CF)=="1125"
            cRet := "332160013"
        ENDIF
        IF SD1->D1_TES=="08B" 
            cRet := "131270003"
        ENDIF
        IF ALLTRIM(SD1->D1_FILIAL) =="0B" 
            IF SD1->D1_GRUPO $ "9006/9007" 
                cRet := "111530013"
            ENDIF
            IF ALLTRIM(SD1->D1_COD) $ "356278/302213/343442" .AND. ALLTRIM(SD1->D1_CF) $ "1101"
                cRet := "111530011"
            ENDIF
        ENDIF
    else
        cRet := " "
    EndIf

RETURN(cRet)
