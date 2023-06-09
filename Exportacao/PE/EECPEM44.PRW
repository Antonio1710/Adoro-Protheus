#INCLUDE "Protheus.ch"
#include "rwmake.ch"   
#include "topconn.ch"                                    
#include "AP5MAIL.CH" 

/*/{Protheus.doc} User Function EECPEM44
    Este ponto de entrada � executado na confirma��o da inclus�o e altera��o do pedido de exporta��o.
    @type  Function
    @author William Costa
    @since 27/02/2020
    @version 01
    @history Chamado 8465  - Leonardo P. Monteiro - 04/03/2021 - Inclus�o das valida��es do projeto de exporta��o.
    @history Chamado 8465  - Leonardo P. Monteiro - 04/03/2021 - Altera��o do campo chave do roteiro para a placa.
    @history Chamado 8465  - Leonardo P. Monteiro - 18/03/2021 - Valida se o campo Modelo Certificado foi incluso.
    @history Chamado 64964 - Leonardo P. Monteiro - 08/12/2021 - Torna obrigat�rio o modelo de certificado somente para a filial de V�rzea Paulista.
    @history Chamado 64964 - Leonardo P. Monteiro - 08/12/2021 - Ajustado o tamanho da linha para 35 caracteres.
    @history ticket TI - Antonio Domingos - 20/05/2023 - Ajuste Nova Empresa
    @history ticket TI - Antonio Domingos - 23/05/2023 - Revis�o Ajuste Nova Empresa
/*/

User Function EECPEM44()

    Local aArea	    := GetArea()
    Local lRet      := .T.
    Local cUsrVend  := ''
    Local aMsnEtq   := {}
    Local nMsnEtq   := 0
    Local nA        := 0
    Local oEST055P  := ADEST055P():New()
    Local cZZ_PEM4401 := SuperGetMv("ZZ_PEM4401",,"0102/1301") //ticket TI - Antonio Domingos - 20/05/2023 
    //PGA - Chamada das valida��es da PGA em rela��o ao cadastro.
    //Local oEST055P  := nil
    SqlVend()

    WHILE TRB->(!EOF()) 

        cUsrVend := TRB->A3_CODUSR
    
        TRB->(dbSkip())							
    ENDDO

    TRB->(dbCloseArea())

    IF cUsrVend == __cUserId

        lRet:= .T.        
        
    ELSE

        lRet    := .F.        
        MsgStop("[EECPEM44-02] - Ol� " + Alltrim(cUserName) + ", o �nico usu�rio que pode colocar pedido de exporta��o � o: " + cUsrVend + '-' + UsrFullName(cUsrVend) + " conforme carteira do comercial n� 000800")

    ENDIF
    
    //Chamado 64964 - Leonardo P. Monteiro - 08/12/2021 - Torna obrigat�rio o modelo de certificado somente para a filial de V�rzea Paulista.
    If alltrim(cEmpAnt)+alltrim(cFilAnt)$cZZ_PEM4401 //ticket TI - Antonio Domingos - 20/05/2023 
        if Empty( M->EE7_XMODCS )
            lRet    := .F.        
            MsgStop("[EECPEM44-03] - � necess�rio informar o Modelo de Certificado para finalizar a inclus�o do processo de exporta��o.")
        ENDIF

        if Empty( M->EE7_XINQLD )
            lRet    := .F.        
            MsgStop("[EECPEM44-04] - � necess�rio informar um valor no campo'Inspec. Qual' para informar se o processo est� apto ou n�o para o faturamento.")
        ENDIF

    ENDIF

    DbSelectArea("SC5")
    SC5->(DbsetOrder(1))

    If dbSeek( FWxFilial("SC5") + M->EE7_PEDFAT ) .AND. lAltera
        if !Empty(SC5->C5_PLACA) .OR. !Empty(SC5->C5_X_SQED)
            MsgAlert("[EECPEM44-01] - Pedidos de Venda faturados ou integrados ao eData n�o podem ser alterados!")
            lRet := .F.
        endif
    endif

    aMsnEtq := Separa(Alltrim(M->EE7_XETQUE),chr(10))
    nMsnEtq := Len(aMsnEtq)

    if nMsnEtq <= 10
        for nA := 1 to nMsnEtq
            if Len(Alltrim(aMsnEtq[nA])) > 35
                MsgAlert("[EECPEM44-05] - O campo de emiss�o da etiqueta cont�m uma linha ("+ Cvaltochar(nA) +") como mais de 35 caracteres.")
                lRet := .F.
            endif
        next nA
    else
        MsgAlert("[EECPEM44-05] - O campo de emiss�o da etiqueta n�o pode ter mais que 10 linhas.")
        lRet := .F.
    endif

    // Tkt 8465 - LPM - Valida se o produto est� cadastrado e vinculado ao cadastro PGA.
    // Verifica se a fun��o PGA est� habilitada.
    if lRet .and. oEST055P:lPrcPGA

        nRecno      := workit->(Recno())
        WorkIt->(DbGotop())

        While WorkIt->(!eof())
            IF !(oEST055P:PGAVldPrd(alltrim(WorkIt->EE8_COD_I), M->EE7_PAISET, Alltrim(Funname())))
                lRet := .F.
            EndIf
            WorkIt->(DbSkip())
        enddo

        workit->(Dbgoto(nRecno))

        RestArea(aArea)
    
    endif

RETURN(lRet)

Static Function SqlVend()
        
    BeginSQL Alias "TRB"
			%NoPARSER% 
            SELECT A3_CODUSR
              FROM SA3010
             WHERE A3_COD      = '000800'
               AND D_E_L_E_T_ <> '*'  
			
	EndSQl
RETURN(NIL)                  
