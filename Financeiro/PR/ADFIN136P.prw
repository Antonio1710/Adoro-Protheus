#include "totvs.ch"
/*/{Protheus.doc} ADFIN136P
Funcao para automacao do processo de geracao das instrucoes de cobranca
@type function
@version 12.1.33
@author Rodrigo Mello
@since 12/04/2023
@return variant, return_description
@history ticket 88193   - Rodrigo Mello | Flek Solutions - 27/04/2023 - Projeto Nexxera Instrucoes de cobranca
/*/
User function ADFIN136P(lDelFI2, lBaixa, lDesconto)

    local aArea := SE1->(getArea())
    local aRegra := {}
    local i
    local lGrv := .T.
    local cCodOcor

    DEFAULT lDelFI2 := .F.
    DEFAULT lBaixa  := .T.
    DEFAULT lDesconto := .F.

    dbSelectArea("FI2")
    FI2->(dbSetOrder(1))
    dbSelectArea("ZJG")
    ZJG->(dbEval( {|| iif( FWTabPref(ZJG_CAMPO) == "SE1" .AND. SE1->E1_PORTADO == ZJG_BANCO .AND. ZJG_HABILT, AAdd( aRegra, { ZJG_CAMPO, ZJG_OCORR } ), Nil ) }))
    
    if  FWIsInCallStack("U_FA330CMP")   .OR.    FWIsInCallStack("U_FA330BX")    .OR.    FWIsInCallStack("U_F450GRAVA")  
        Do Case 
            Case SE1->E1_PORTADO == "104" // CEF
                cCodOcor := iif( !lBaixa, "03" /*abatimento*/,"02" /*baixa - pagamento ao beneficiario*/)
            Case SE1->E1_PORTADO $ "237|422|SFF" // Brasdesco - Safra
                cCodOcor := iif( !lBaixa, "04" /*abatimento*/,"02" /*baixa - pagamento ao beneficiario*/)
            OtherWise 
                cCodOcor := iif( !lBaixa, "04" /*abatimento*/,"34" /*baixa - pagamento ao beneficiario*/)
        endCase

        FI2->(dbGoTop())
        lGrv := !(FI2->(dbSeek(xFilial("FI2")+"1"+SE1->(E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA+cCodOcor+"2"))))
        RecLock('FI2',lGrv)
        if lDelFI2 .and. !lGrv
            FI2->(dbDelete())
        elseif !lDelFI2     
            FI2->FI2_FILIAL	:= xFilial("FI2")
            FI2->FI2_CARTEI	:= "1"
            FI2->FI2_OCORR 	:= cCodOcor
            FI2->FI2_GERADO	:= "2"
            FI2->FI2_NUMBOR	:= SE1->E1_NUMBOR
            FI2->FI2_PREFIX	:= SE1->E1_PREFIXO
            FI2->FI2_TITULO	:= SE1->E1_NUM
            FI2->FI2_PARCEL	:= SE1->E1_PARCELA
            FI2->FI2_TIPO  	:= SE1->E1_TIPO
            FI2->FI2_CODCLI	:= SE1->E1_CLIENTE
            FI2->FI2_LOJCLI	:= SE1->E1_LOJA
            FI2->FI2_DTOCOR	:= dDataBase
            FI2->FI2_DESCOC	:= Posicione('SEB',1,xFilial('SEB')+SE1->E1_PORTADO+Pad(FI2->FI2_OCORR,Len(SEB->EB_REFBAN))+"E","SEB->EB_DESCRI")
            FI2->FI2_VALANT	:= cValToChar(cSaldo)
            FI2->FI2_VALNOV	:= cValToChar(nValor)
            FI2->FI2_CAMPO 	:= "E1_SALDO"
            FI2->FI2_TIPCPO	:= "N"
        endif
        FI2->(MsUnLock())
    endif

    if FWIsInCallStack("U_FA070TIT") .or. FWIsInCallStack("U_FA070CAN")

        Do Case 
            Case SE1->E1_PORTADO == "104" // CEF
                cCodOcor := iif( !lBaixa, "03" /*abatimento*/,"02" /*baixa - pagamento ao beneficiario*/)
            Case SE1->E1_PORTADO $ "237|422|SFF" // Brasdesco - Safra
                cCodOcor := iif( !lBaixa, "04" /*abatimento*/,"02" /*baixa - pagamento ao beneficiario*/)
            OtherWise 
                cCodOcor := iif( !lBaixa, "04" /*abatimento*/,"34" /*baixa - pagamento ao beneficiario*/)
        endCase

        FI2->(dbGoTop())
        lGrv := !(FI2->(dbSeek(xFilial("FI2")+"1"+SE1->(E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA+cCodOcor+"2"))))
        //lGrv := !(FI2->(dbSeek(xFilial("FI2")+"1"+SE1->(E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA))) .and. FI2->FI2_GERADO == "2") // FI2_FILIAL+FI2_CARTEI+FI2_NUMBOR+FI2_PREFIX+FI2_TITULO+FI2_PARCEL+FI2_TIPO+FI2_CODCLI+FI2_LOJCLI+FI2_OCORR+FI2_GERADO                                           
        RecLock('FI2', lGrv)
        if lDelFI2 .and. !lGrv
            FI2->(dbDelete())
        elseif !lDelFI2     
            FI2->FI2_FILIAL	:= xFilial("FI2")
            FI2->FI2_CARTEI	:= "1"
            FI2->FI2_OCORR 	:= cCodOcor
            FI2->FI2_GERADO	:= "2"
            FI2->FI2_NUMBOR	:= SE1->E1_NUMBOR
            FI2->FI2_PREFIX	:= SE1->E1_PREFIXO
            FI2->FI2_TITULO	:= SE1->E1_NUM
            FI2->FI2_PARCEL	:= SE1->E1_PARCELA
            FI2->FI2_TIPO  	:= SE1->E1_TIPO
            FI2->FI2_CODCLI	:= SE1->E1_CLIENTE
            FI2->FI2_LOJCLI	:= SE1->E1_LOJA
            FI2->FI2_DTOCOR	:= dDataBase
            FI2->FI2_DESCOC	:= Posicione('SEB',1,xFilial('SEB')+SE1->E1_PORTADO+Pad(FI2->FI2_OCORR,Len(SEB->EB_REFBAN))+"E","SEB->EB_DESCRI")
            FI2->FI2_VALANT	:= cValToChar(nValorLiq)
            FI2->FI2_VALNOV	:= cValToChar(nValRec)
            FI2->FI2_CAMPO 	:= "E1_SALDO"
            FI2->FI2_TIPCPO	:= "N"
        endif
        FI2->(MsUnLock())

    endif

    if FWIsInCallStack("U_FA040ALT") .OR. FWIsInCallStack("U_ADFIN046P") .OR. FWIsInCallStack("U_ADFINL46") 
        for i:=1 to len(aRegra)
            if !(&("M->"+aRegra[i,1])) == Nil .and. SE1->(FieldGet(FieldPos(aRegra[i,1]))) != &("M->"+aRegra[i,1])
                FI2->(dbGoTop())
                lGrv := !FI2->(dbSeek(xFilial("FI2")+"1"+SE1->(E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)+aRegra[i,2]+"2"))
                RecLock('FI2',lGrv)
                if lDelFI2 .and. !lGrv
                    FI2->(dbDelete())
                else     
                    FI2->FI2_FILIAL	:= xFilial("FI2")
                    FI2->FI2_CARTEI	:= "1"
                    FI2->FI2_OCORR 	:= aRegra[i,2]
                    FI2->FI2_GERADO	:= "2"
                    FI2->FI2_NUMBOR	:= SE1->E1_NUMBOR
                    FI2->FI2_PREFIX	:= SE1->E1_PREFIXO
                    FI2->FI2_TITULO	:= SE1->E1_NUM
                    FI2->FI2_PARCEL	:= SE1->E1_PARCELA
                    FI2->FI2_TIPO  	:= SE1->E1_TIPO
                    FI2->FI2_CODCLI	:= SE1->E1_CLIENTE
                    FI2->FI2_LOJCLI	:= SE1->E1_LOJA
                    FI2->FI2_DTOCOR	:= dDataBase
                    FI2->FI2_DESCOC	:= Posicione('SEB',1,xFilial('SEB')+SE1->E1_PORTADO+Pad(FI2->FI2_OCORR,Len(SEB->EB_REFBAN))+"E","SEB->EB_DESCRI")
                    FI2->FI2_VALANT	:= cValToChar(SE1->(FieldGet(FieldPos(aRegra[i,1]))))
                    FI2->FI2_VALNOV	:= cValToChar(&("M->"+aRegra[i,1]))
                    FI2->FI2_CAMPO 	:= aRegra[i,1]
                    FI2->FI2_TIPCPO	:= GetSX3Cache(aRegra[i,1], "X3_TIPO")
                endif
                FI2->(MsUnLock())
            endif
        next i

    endif

    if FWIsInCallStack("U_FA040DEL") .and. lDesconto
                
        cCodOcor := iif( SE1->E1_PORTADO == "104", "09", "31" ) // codigo de alteracao de outros dados
        FI2->(dbGoTop())
        lGrv := !FI2->(dbSeek(xFilial("FI2")+"1"+SE1->(E1_NUMBOR+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO+E1_CLIENTE+E1_LOJA)+aRegra[i,2]+"2"))
        RecLock('FI2',lGrv)
            FI2->FI2_FILIAL	:= xFilial("FI2")
            FI2->FI2_CARTEI	:= "1"
            FI2->FI2_OCORR 	:= cCodOcor
            FI2->FI2_GERADO	:= "2"
            FI2->FI2_NUMBOR	:= SE1->E1_NUMBOR
            FI2->FI2_PREFIX	:= SE1->E1_PREFIXO
            FI2->FI2_TITULO	:= SE1->E1_NUM
            FI2->FI2_PARCEL	:= SE1->E1_PARCELA
            FI2->FI2_TIPO  	:= SE1->E1_TIPO
            FI2->FI2_CODCLI	:= SE1->E1_CLIENTE
            FI2->FI2_LOJCLI	:= SE1->E1_LOJA
            FI2->FI2_DTOCOR	:= dDataBase
            FI2->FI2_DESCOC	:= Posicione('SEB',1,xFilial('SEB')+SE1->E1_PORTADO+Pad(FI2->FI2_OCORR,Len(SEB->EB_REFBAN))+"E","SEB->EB_DESCRI")
            FI2->FI2_VALANT	:= 0
            FI2->FI2_VALNOV	:= cValToChar(&("M->"+aRegra[i,1]))
            FI2->FI2_CAMPO 	:= aRegra[i,1]
            FI2->FI2_TIPCPO	:= GetSX3Cache(aRegra[i,1], "X3_TIPO")
        FI2->(MsUnLock())

    endif

    restArea(aArea)

return
