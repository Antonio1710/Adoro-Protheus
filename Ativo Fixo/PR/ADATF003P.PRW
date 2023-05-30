#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} ADATF003P
    Atualiza Centro de Despesa de Depreciação com o Custo do Bem
    @type  Function User
    @author Antonio Domingos
    @since 11/04/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    U_ADATF003P(_cFILIAL+_cFORNEC+_cLOJA+_cNFESPEC+_cNFISCAL+_cNSERIE+_cNFITEM,_cTES )    @see (links_or_references)
    @history ticket 91381 - Antonio Domingos - 11/04/2023 - Alteração de regra do campo centro de custo - Módulo do Ativo
/*/
User Function ADATF003P(_cFILIAL,_cFORNECE,_cLOJA,_cNFESPEC,_cNFISCAL,_cNSERIE,_cNFITEM,_cTES )
    Local _aGetArea := GetArea()
    dbSelectArea("SN1")
    dbSetOrder(8)//N1_FILIAL+N1_FORNEC+N1_LOJA+N1_NFESPEC+N1_NFISCAL+N1_NSERIE+N1_NFITEM 
    If SN1->(dbSeek(_cFILIAL+_cFORNECE+_cLOJA+_cNFESPEC+_cNFISCAL+_cNSERIE+_cNFITEM ))
        While !SN1->(Eof()) .And. SN1->(N1_FILIAL+N1_FORNEC+N1_LOJA+N1_NFESPEC+N1_NFISCAL+N1_NSERIE+N1_NFITEM );
                                ==      _cFILIAL+_cFORNECE+_cLOJA+_cNFESPEC+_cNFISCAL+_cNSERIE+_cNFITEM 
            SN3->(dbSetOrder(1))
            If SN3->(dbSeek(SN1->N1_FILIAL+SN1->N1_CBASE))
                While !SN3->(Eof()) .And. SN3->N3_FILIAL == SN1->N1_FILIAL .And. SN3->N3_CBASE == SN1->N1_CBASE
                    If !Empty(SN3->N3_CUSTBEM) .or. SN3->N3_CUSTBEM <> SN3->N3_CCDESP  
                        RECLOCK("SN3",.F.)
                        SN3->N3_CCDESP := SN3->N3_CUSTBEM
                        SN3->(MsUnLock())
                    EndIf
                    SN3->(dbSkip())    
                EndDo
            EndIf
            SN1->(dbSkip())
        EndDo
    EndIf
    RestArea(_aGetArea)
Return
