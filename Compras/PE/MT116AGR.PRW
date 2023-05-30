#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function MT116AGR
  PE para corrigir a natureza financeira dos títulos gerados pela rotina de Conhecimento de Frete, pois o mesmo está trazendo a natureza do fornecedor e não a natureza informada na Central XML.
  @type  Function
  @author Abel
  @since 23/03/2020
  @history Chamado n.056718 - OS n.058181 - Abel Babini - 23/03/2020 - ADM || LUCINEIA || 3575 || CTE - NATUREZA FINAN - Corrigir Natureza Financeira do título para respeitar o que foi informado pela Central XML
  @history Everson, 03/01/2023 - Ticket 18465 - Tratamento para envio de registro para o barramento.
  @history ticket 18465   - Everson - 28/02/2023 - Adicionada função para envio de registro ao barramento.
  @history Everson, 13/03/2023 - ticket 18465 - Envio de CT-e para o barramento.
/*/

USER FUNCTION MT116AGR()

  Local aArea := GetArea()
  Local cAlS116
  Local nPosNat  := aScan(aAutoCab,{ |x| Upper(AllTrim(x[1])) == "NF_NATUREZA"})

  IF INCLUI .and. ( IsInCallStack("U_CENTNFEXM") .or. IsInCallStack("U_RECNFEXML") .or. IsInCallStack("U_RECNFECTE") )

    If Select(cAlS116) > 0
      (cAlS116)->(dbCloseArea())
    Endif
    cAlS116:=GetNextAlias()

    BeginSQL  Alias cAlS116
      SELECT 
        E2_PREFIXO,
        E2_NUM,
        E2_PARCELA,
        E2_TIPO,
        E2_FORNECE,
        E2_LOJA,
        E2_NATUREZ
      FROM %TABLE:SE2% SE2
      WHERE SE2.E2_FILIAL = %xFilial:SE2%
      AND SE2.E2_PREFIXO = %Exp:SF1->F1_SERIE%
      AND SE2.E2_NUM = %Exp:SF1->F1_DOC%
      AND SE2.E2_FORNECE = %Exp:SF1->F1_FORNECE%
      AND SE2.E2_LOJA = %Exp:SF1->F1_LOJA%
      AND SE2.%notDel%
    EndSQL

    DbSelectArea(cAlS116)
    (cAlS116)->(DbGoTop())
    dbSelectArea('SE2')
    SE2->(dbSetOrder(1))
    While !(cAlS116)->(eof())
      
      IF SE2->(DbSeek(xFilial('SE2')+(cAlS116)->E2_PREFIXO+(cAlS116)->E2_NUM+(cAlS116)->E2_PARCELA+(cAlS116)->E2_TIPO+(cAlS116)->E2_FORNECE+(cAlS116)->E2_LOJA))
        IF Alltrim(SE2->E2_NATUREZ) <> Alltrim(aAutoCab[nPosNat,2])
          RECLOCK('SE2',.F.)
            SE2->E2_NATUREZ := aAutoCab[nPosNat,2]
          MSUNLOCK()
        ENDIF
      ENDIF
      (cAlS116)->(DbSkip())
    EndDo

    (cAlS116)->(dbCloseArea())

  ENDIF

  // //Everson - 02/01/2023 - Ticket 18465.
  // If INCLUI .And. arotina[1][4] == 6
  //   grvBarr(3, SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)

  // EndIf
  // //
  
  RestArea(aArea)

RETURN
/*/{Protheus.doc} grvBarr
    Salva o registro para enviar ao barramento.
    @type  User Function
    @author Everson
    @since 02/01/2022
    @version 01
/*/
Static Function grvBarr(nOpc, cNumero)

    //Variáveis.
    Local aArea     := GetArea()
    Local cFilter   := ""
    Local cTopico   := "documentos_de_entrada_protheus"
    Local cOperacao := ""
    Local cFiliais  := Alltrim(GetMv("MV_#FAT171",,"")) //Ticket 18465   - Everson - 21/07/2022.
    Local aPropCab  := {} //Everson - 03/01/2023 - ticket 18465.
    Local cChave    := Alltrim(cValToChar(SF1->F1_CHVNFE))
    Local aPropItem := obtDados(cNumero, cChave)

    Private lJaPos  := .T.

    If !(cFilAnt $cFiliais)
        RestArea(aArea)
        Return Nil

    EndIf

    If nOpc == 4 
        cOperacao := "A"

    ElseIf nOpc == 3 
        cOperacao := "I"
    
    ElseIf nOpc == 5
        cOperacao := "D"

    Else
        RestArea(aArea)
        Return Nil

    EndIf
    
    cFilter := " D1_FILIAL ='" + FWxFilial("SD1") + "' .And. D1_DOC = '" + SF1->F1_DOC + "' .And. D1_SERIE = '" + SF1->F1_SERIE + "' .And. D1_FORNECE = '" + SF1->F1_FORNECE + "' .And. D1_LOJA = '" + SF1->F1_LOJA  + "' "
    
    U_ADFAT27D("SF1", 1, FWxFilial("SF1") + cNumero,;
               "SD1", 1, FWxFilial("SD1") + cNumero, "D1_COD+D1_ITEM",cFilter,;
               cTopico, cOperacao,;
               .T., .T.,.T., Nil,, aPropCab, aPropItem) //Everson - 03/01/2023 - ticket 18465.

    RestArea(aArea)
 
Return Nil
/*/{Protheus.doc} obtDados
  Carrega dados para o CT-e.
  @type  Static Function
  @author user
  @since 03/01/2023
  @version 01
/*/
Static Function obtDados(cNumero, cChave)

  //Variáveis.
  Local aArea     := GetArea()
  Local cQuery    := " SELECT * FROM " + RetSqlName("SF8") + " (NOLOCK) AS SF8 WHERE F8_FILIAL = '" + FWxFilial("SF8") + "' AND  F8_NFDIFRE + F8_SEDIFRE + F8_TRANSP +  F8_LOJTRAN = '" + cNumero + "' AND SF8.D_E_L_E_T_ = ''  "
  Local cNxtAlias := GetNextAlias()
  Local aDados    := {}
  Local aItem     := {}

  DbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuery), cNxtAlias,.F.,.T. )
  (cNxtAlias)->(DbGoTop())

  While ! (cNxtAlias)->(Eof())

    aItem  := {}

    Aadd(aItem,{"NF_ORI", (cNxtAlias)->F8_NFORIG  })
    Aadd(aItem,{"SR_ORI", (cNxtAlias)->F8_SERORIG })
    Aadd(aItem,{"FR_ORI", (cNxtAlias)->F8_FORNECE })
    Aadd(aItem,{"LJ_ORI", (cNxtAlias)->F8_LOJA    })

    Aadd(aDados, aItem)

    (cNxtAlias)->(DbSkip())

  End
  
  (cNxtAlias)->(DbCloseArea())

  RestArea(aArea)
  
Return aDados
/*/{Protheus.doc} User Function nomeFunction
  (long_description)
  @type  Function
  @author user
  @since 28/02/2023
  @version 01
/*/
User Function MT116A1(nOpc, cNumero)

  grvBarr(nOpc, cNumero)
  
Return Nil
