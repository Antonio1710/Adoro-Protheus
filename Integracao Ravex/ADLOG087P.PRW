#Include "Protheus.ch"
#Include "Apwebsrv.ch"
#Include "Tbiconn.ch"
#Include "Tbicode.ch"   
#Include "Xmlxfun.ch"  

/*/{Protheus.doc} User Function ADLOG087P
    Envia cadastro de fornecedor para o Ravex.
    Ticket 78062.
    @type  Function
    @author Everson
    @since 29/11/2022
    @version 01
/*/
User Function ADLOG087P(cFornec, cLoja)

    //Variáveis.
    Local aArea             := GetArea()
    Local aCli              := {}
    Local oWsCli            := WSsivirafullWebService():New()
    Local oWSGrade1Diaria   := Nil
    Local oWSGrade2Diaria   := Nil
    Local oResp             := Nil
	Local nCont             := 0
    Local aEmails           := {}

	oWsCli:cLogin := "adoro_user_ws"
	oWsCli:cSenha := "SdUdWSdA"

    DbSelectArea("SA2")
    SA2->(DbSetOrder(1))
    SA2->(DbGoTop())

    If ! SA2->(DbSeek( FWxFilial("SA2") + cFornec + cLoja ))
        RestArea(aArea)
        Return {}

    EndIf

    aEmails := Separa(Alltrim(cValToChar(SA2->A2_EMAIL)), ";", .F.)
	
    oWsCli:oWSCliente:cCodigo                                  := Alltrim(SA2->A2_CGC)  
    oWsCli:oWSCliente:cTipoPessoa                              := Alltrim(SA2->A2_TIPO) 
    oWsCli:oWSCliente:cCNPJCPF                                 := Alltrim(SA2->A2_CGC)
    oWsCli:oWSCliente:cRGInscricao                             := ""
    oWsCli:oWSCliente:cNome                                    := FwNoAccent(Alltrim(SA2->A2_NOME))
    oWsCli:oWSCliente:cRazaoSocial                             := FwNoAccent(Alltrim(SA2->A2_NREDUZ))
    oWsCli:oWSCliente:cTelefone                                := Alltrim(SA2->A2_DDD+SA2->A2_TEL)
    oWsCli:oWSCliente:cEmail                                   := Iif(Len(aEmails) > 0, aEmails[1], "")
    oWsCli:oWSCliente:cResponsavel                             := ""
    oWsCli:oWSCliente:cEndereco                                := FwNoAccent(Alltrim(SA2->A2_END))
    oWsCli:oWSCliente:cComplemento                             := FwNoAccent(Alltrim(SA2->A2_COMPLEM))
    oWsCli:oWSCliente:cBairro                                  := FwNoAccent(Alltrim(SA2->A2_BAIRRO))
    oWsCli:oWSCliente:cCidade                                  := FwNoAccent(Alltrim(SA2->A2_MUN))
    oWsCli:oWSCliente:cEstado                                  := FwNoAccent(Alltrim(SA2->A2_EST))
    oWsCli:oWSCliente:cPais                                    := FwNoAccent(Alltrim(SA2->A2_PAIS))
    oWsCli:oWSCliente:cCep                                     := Alltrim(SA2->A2_CEP)

    oWsCli:oWSCliente:nLatitude                                := Val(STRTRAN(SA2->A2_XLATITU,',','.'))
    oWsCli:oWSCliente:nLongitude                               := Val(STRTRAN(SA2->A2_XLONGIT,',','.'))

    oWsCli:oWSCliente:nRaioEntrega                             := 0 
    oWsCli:oWSCliente:nTempoEntrega                            := 0
    oWsCli:oWSCliente:cRegiao                                  := Alltrim(SA2->A2_REGIAO) 
    oWsCli:oWSCliente:cPreRota                                 := ""    
    oWsCli:oWSCliente:cNegocio                                 := Posicione("SX5",1,cFilAnt+"_S"+SA2->A2_SATIV1,"X5_DESCRI")
    oWsCli:oWSCliente:cCodigoTabelaFrete                       := ""  

    //Janela de atendimento.
    oWsCli:oWSCliente:oWSGradeAtendimento                      := sivirafullWebService_JanelaAtendimento():New()
    oWsCli:oWSCliente:oWSGradeAtendimento:CCODIGO              := Alltrim(SA2->A2_CGC)
    oWsCli:oWSCliente:oWSGradeAtendimento:CNOME                := FwNoAccent(Alltrim(SA2->A2_NOME))
    oWsCli:oWSCliente:oWSGradeAtendimento:CREGIONALVENDA       := ""
    oWsCli:oWSCliente:oWSGradeAtendimento:CUNIDADE             := ""
    oWsCli:oWSCliente:oWSGradeAtendimento:OWSATENDIMENTODIARIO := sivirafullWebService_ArrayOfGradeDiaria():New()
    
    For nCont := 1 To 7
     
        oWSGrade1Diaria                  := sivirafullWebService_GradeDiaria():New()
        oWSGrade1Diaria:NDIASEMANA       := nCont
        oWSGrade1Diaria:CTIPOATENDIMENTO := ""
        oWSGrade1Diaria:NPERIODO         := 0
        oWSGrade1Diaria:CINICIO          := Substr(DToS(Date()),1,4)+ '-' + Substr(DToS(Date()),5,2)+ '-' + Substr(DToS(Date()),7,2) +  "T" + Iif(EMPTY(SA2->A2_HRINIM), '00:00', SA2->A2_HRINIM) + ':00'
        oWSGrade1Diaria:CTERMINO         := Substr(DToS(Date()),1,4)+ '-' + Substr(DToS(Date()),5,2)+ '-' + Substr(DToS(Date()),7,2) +  "T" + Iif(EMPTY(SA2->A2_HRFINM), '23:59', SA2->A2_HRFINM) + ':00'
                
        oWSGrade2Diaria                  := sivirafullWebService_GradeDiaria():New()
        oWSGrade2Diaria:NDIASEMANA       := nCont
        oWSGrade2Diaria:CTIPOATENDIMENTO := ""
        oWSGrade2Diaria:NPERIODO         := 1
        oWSGrade2Diaria:CINICIO          := Substr(DToS(Date()),1,4)+ '-' + Substr(DToS(Date()),5,2)+ '-' + Substr(DToS(Date()),7,2) +  "T" + Iif(EMPTY(SA2->A2_HRINIT), '00:00', SA2->A2_HRINIT) + ':00'
        oWSGrade2Diaria:CTERMINO         := Substr(DToS(Date()),1,4)+ '-' + Substr(DToS(Date()),5,2)+ '-' + Substr(DToS(Date()),7,2) +  "T" + Iif(EMPTY(SA2->A2_HRFINT), '23:59', SA2->A2_HRFINT) + ':00'
    
        Aadd(oWsCli:oWSCliente:oWSGradeAtendimento:OWSATENDIMENTODIARIO:oWSGradeDiaria,oWSGrade1Diaria)
        Aadd(oWsCli:oWSCliente:oWSGradeAtendimento:OWSATENDIMENTODIARIO:oWSGradeDiaria,oWSGrade2Diaria)
        
    Next nCont 
    
    If oWsCli:IntegrarClienteCompleto()
        oResp   := oWsCli:oWSIntegrarClienteCompletoResult
        Aadd(aCli, Iif(Type("oResp:CIDENTIFICADOR") == "U", "", oResp:CIDENTIFICADOR) + " || " + oResp:cmensagem)
        
    Else
        Aadd(aCli, Alltrim(SA2->A1_COD + SA2->A1_LOJA) + "||" + GetWSCError())
        
    EndIf

    FreeObj(oWsCli)
    oWsCli := Nil

    FreeObj(oWSGrade1Diaria)
    oWSGrade1Diaria := Nil

    FreeObj(oWSGrade2Diaria)
    oWSGrade2Diaria := Nil
		
	SA2->(dbCloseArea()) 

    RestArea(aArea)
	
Return aCli
