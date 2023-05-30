#INCLUDE "Protheus.CH"

/*/{Protheus.doc} User Function ADFIS050R
  Relatório para Controle do que deve ser da Filial Itapira
  @type  Function
  @author Abel Babini
  @since 03/10/2022
  @version version
  @history Ticket 69334   - Abel Babini   - 11/10/2022 - Relatório controle de remessas e vendas na filial Itapira
  @history Ticket 81920   - Abel Babini   - 17/10/2022 - Ajustes para desconsiderar as devoluções e corrigir valores
  @history Ticket 81920   - Abel Babini   - 31/10/2022 - Ajustes para desconsiderar as devoluções e corrigir valores
  @history Ticket 81920   - Abel Babini   - 20/12/2022 - Ajustes nos valores unitários e saldos de quantidade.
  @history Ticket 81920   - Abel Babini   - 23/12/2022 - Erro no relatório
  @history Ticket 81920   - Abel Babini   - 02/01/2023 - Correções no resumo de vendas e quantidades no detalhado
  /*/
User Function ADFIS050R(param_name)
	Local aArea		:= GetArea()
	Local aPergs	:= {}
	Local aRet    := {}
  Local cFlAF50R   := Alltrim(GetMV("MV_#AD5006",,"0B"))
  IF Alltrim(cFilAnt) $ cFlAF50R
    aAdd( aPergs ,{1,"Data Venda De "     ,Ctod(space(8)),"" ,'.T.',,'.T.',80,.T.})
    aAdd( aPergs ,{1,"Data Venda Até"     ,Ctod(space(8)),"" ,'.T.',,'.T.',80,.T.})
    aAdd( aPergs ,{6,"Local de Gravação",Space(50),"","","",50,.T.,"Todos os arquivos (*.*) |*.*","C:\TEMP\",GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_NETWORKDRIVE})

    //Executa as perguntas ao usuário e só executa o relatório caso o usuário confirme a tela de parâmetros;
    If ParamBox(aPergs ,"Parâmetros ",aRet,,,,,,,,.T.,.T.)
      MsgRun( "Carregando dados - Relatório de Remessas e Vendas Itapira, aguarde...",,{ || PrcFis50(aRet) } )
    Endif
  ELSE  
    Alert('Esse relatório somente pode ser emitido para a Filial:'+cFlAF50R)
  ENDIF
	RestArea(aArea)

Return 


/*/{Protheus.doc} User Function PrcFis50
  Relatório para Controle do que deve ser da Filial Itapira
  @type  Function
  @author Abel Babini
  @since 03/10/2022
  @version version
  /*/
Static Function PrcFis50(aRet)
  Local cQry01    := GetNextAlias()
  Local cCNPJ     := '%'+FormatIn(GetMV("MV_#AD5001",,"20844980000116"),",")+'%'
  Local cCFOPRem  := '%'+FormatIn(GetMV("MV_#AD5002",,"5949"),",")+'%'
  Local cCFOPVen  := '%'+FormatIn(GetMV("MV_#AD5003",,"5101,5102,5403"),",")+'%'
  Local cCFOPDev  := '%'+FormatIn(GetMV("MV_#AD5004",,"1201,1202"),",")+'%'
  // Local cCFOPSim   := '%'+FormatIn(GetMV("MV_#AD5005",,"1949"),",")+'%'

  Local aDetalhe  := {}
  Local aResumo   := {}
  // Local i         := 0
  Local nSldPrd   := 0
  Local cAuxPrd   := ''
  Local cAuxPrdD  := ''
  Local cAuxUM    := ''
  Local nPrcUnit  := 0
  Local nQtdVend  := 0

  //Ticket 81920   - Abel Babini   - 02/01/2023 - Correções no resumo de vendas e quantidades no detalhado
  Local nResQtd   := 0
  Local nResVlr   := 0

  BeginSQL alias cQry01
    COLUMN DATAFISCAL AS DATE
    SELECT 
        '1R' AS TPOPE,
        SD2.D2_FILIAL	  AS FILIAL, 
        SD2.D2_DOC		  AS NFISCAL,
        SD2.D2_SERIE	  AS SERIE, 
        SD2.D2_ITEM		  AS ITEM,
        SD2.D2_TIPO		  AS TIPO,
        SD2.D2_EMISSAO	AS DATAFISCAL,
        SD2.D2_CLIENTE	AS CODCLIFOR,
        SD2.D2_LOJA		  AS LOJCLIFOR,
        SA2.A2_NOME		  AS NOMECLIFOR,
        SA2.A2_CGC			AS CNPJCLIFOR,
        SD2.D2_EST		  AS UF,
        SD2.D2_COD		  AS CODPRODUTO,
        SB1.B1_DESC		  AS PRODUTO,
        SD2.D2_TP		    AS TIPOPRODUTO,
        SD2.D2_UM		    AS UM,
        SD2.D2_SEGUM	  AS SEGUM,
        SD2.D2_QUANT	  AS QUANT,
        SD2.D2_PRCVEN	  AS PRCUNIT,
        SD2.D2_TOTAL	  AS TOTAL,
        SD2.D2_TES		  AS TES,
        SD2.D2_CF		    AS CFOP,
        SD2.D2_PEDIDO	  AS NUMPEDIDO,
        SD2.D2_ITEMPV	  AS ITEMPEDIDO,
        SD2.D2_QTDEDEV	AS QTDDEV,
        SD2.D2_VALDEV	  AS VALDEV
      FROM %TABLE:SD2% SD2
      LEFT JOIN %TABLE:SB1% SB1 ON
        SB1.B1_FILIAL = %xFilial:SB1% AND
        SB1.B1_COD = SD2.D2_COD AND
        SB1.%notDel%
      LEFT JOIN %TABLE:SA2% SA2 ON
        SA2.A2_FILIAL = %xFilial:SA2% AND
        SA2.A2_COD = SD2.D2_CLIENTE AND
        SA2.A2_LOJA = SD2.D2_LOJA AND 
        SA2.%notDel%
      WHERE D2_FILIAL = %xFilial:SD2%
        AND D2_CF IN %Exp:cCFOPRem%
        AND D2_TIPO IN ('B','D')
        AND SD2.%notDel%
        AND SD2.D2_EMISSAO <= %Exp:DTOS(aRet[2])%
        AND A2_CGC IN %Exp:cCNPJ%

    UNION All
  
    SELECT 
        '2V' AS TPOPE,
        SD2.D2_FILIAL	  AS FILIAL, 
        SD2.D2_DOC		  AS NFISCAL,
        SD2.D2_SERIE	  AS SERIE, 
        SD2.D2_ITEM		  AS ITEM,
        SD2.D2_TIPO		  AS TIPO,
        SD2.D2_EMISSAO	AS DATAFISCAL,
        SD2.D2_CLIENTE	AS CODCLIFOR,
        SD2.D2_LOJA		  AS LOJCLIFOR,
        SA1.A1_NOME		  AS NOMECLIFOR,
        SA1.A1_CGC			AS CNPJCLIFOR,
        SD2.D2_EST		  AS UF,
        SD2.D2_COD		  AS CODPRODUTO,
        SB1.B1_DESC		  AS PRODUTO,
        SD2.D2_TP		    AS TIPOPRODUTO,
        SD2.D2_UM		    AS UM,
        SD2.D2_SEGUM	  AS SEGUM,
        SD2.D2_QUANT	  AS QUANT,
        SD2.D2_PRCVEN	  AS PRCUNIT,
        SD2.D2_TOTAL	  AS TOTAL,
        SD2.D2_TES		  AS TES,
        SD2.D2_CF		    AS CFOP,
        SD2.D2_PEDIDO	  AS NUMPEDIDO,
        SD2.D2_ITEMPV	  AS ITEMPEDIDO,
        SD2.D2_QTDEDEV	AS QTDDEV,
        SD2.D2_VALDEV	  AS VALDEV
      FROM %TABLE:SD2% SD2
      LEFT JOIN %TABLE:SB1% SB1 ON
        SB1.B1_FILIAL = %xFilial:SB1% AND
        SB1.B1_COD = SD2.D2_COD AND
        SB1.%notDel%
      LEFT JOIN %TABLE:SA1% SA1 ON
        SA1.A1_FILIAL = %xFilial:SA2% AND
        SA1.A1_COD = SD2.D2_CLIENTE AND
        SA1.A1_LOJA = SD2.D2_LOJA AND 
        SA1.%notDel%
      WHERE D2_FILIAL = %xFilial:SD2%
        AND D2_CF IN %Exp:cCFOPVen%
        AND D2_TIPO NOT IN ('B','D')
        AND SD2.D2_EMISSAO <= %Exp:DTOS(aRet[2])%
        AND SD2.%notDel%

    UNION All
  
    SELECT 
        '3D' AS TPOPE,
        SD1.D1_FILIAL	  AS FILIAL, 
        SD1.D1_DOC		  AS NFISCAL,
        SD1.D1_SERIE	  AS SERIE, 
        SD1.D1_ITEM		  AS ITEM,
        SD1.D1_TIPO		  AS TIPO,
        SD1.D1_DTDIGIT	AS DATAFISCAL,
        SD1.D1_FORNECE	AS CODCLIFOR,
        SD1.D1_LOJA		  AS LOJCLIFOR,
        CASE WHEN SD1.D1_TIPO IN ('D','B') THEN SA1.A1_NOME ELSE SA2.A2_NOME END AS NOMECLIFOR,
        CASE WHEN SD1.D1_TIPO IN ('D','B') THEN SA1.A1_CGC ELSE SA2.A2_CGC END AS CNPJCLIFOR,
        CASE WHEN SD1.D1_TIPO IN ('D','B') THEN SA1.A1_EST ELSE SA2.A2_EST END AS UF,
        SD1.D1_COD		  AS CODPRODUTO,
        SB1.B1_DESC		  AS PRODUTO,
        SD1.D1_TP		    AS TIPOPRODUTO,
        SD1.D1_UM		    AS UM,
        SD1.D1_SEGUM	  AS SEGUM,
        SD1.D1_QUANT	  AS QUANT,
        SD1.D1_VUNIT	  AS PRCUNIT,
        SD1.D1_TOTAL	  AS TOTAL,
        SD1.D1_TES		  AS TES,
        SD1.D1_CF		    AS CFOP,
        SD1.D1_PEDIDO	  AS NUMPEDIDO,
        SD1.D1_ITEMPV	  AS ITEMPEDIDO,
        SD1.D1_QTDEDEV	AS QTDDEV,
        SD1.D1_VALDEV	  AS VALDEV
      FROM %TABLE:SD1% SD1
      LEFT JOIN %TABLE:SB1% SB1 ON
        SB1.B1_FILIAL = %xFilial:SB1% AND
        SB1.B1_COD = SD1.D1_COD AND
        SB1.%notDel%  
      LEFT JOIN %TABLE:SA1% SA1 ON
        SA1.A1_FILIAL = '' AND
        SA1.A1_COD = SD1.D1_FORNECE AND
        SA1.A1_LOJA = SD1.D1_LOJA AND 
        SA1.%notDel% AND
        SD1.D1_TIPO IN ('B','D')
      LEFT JOIN %TABLE:SA2% SA2 ON
        SA2.A2_FILIAL = '' AND
        SA2.A2_COD = SD1.D1_FORNECE AND
        SA2.A2_LOJA = SD1.D1_LOJA AND 
        SA2.%notDel% AND
        SD1.D1_TIPO NOT IN ('B','D')
      WHERE D1_FILIAL = %xFilial:SD1%
        AND D1_CF IN %Exp:cCFOPDev%
        AND SD1.%notDel%
        AND SD1.D1_DTDIGIT <= %Exp:DTOS(aRet[2])%
        AND (SA1.A1_CGC IN %Exp:cCNPJ% OR SA2.A2_CGC IN %Exp:cCNPJ%)

    ORDER BY FILIAL,CODPRODUTO,DATAFISCAL,TPOPE,SERIE,NFISCAL,ITEM
  EndSQL
  //        (SELECT SD1.D1_QUANT FROM %TABLE:SD1% SD1 WHERE SD1.D1_FILIAL = SD2.D2_FILIAL AND SD1.D1_NFORI ) AS QTDEDEV_ENT,
  // Inicializa Arrays
  aResumo	  := {}
  aDetalhe  := {}
  aRemessa  := {}

	DbSelectArea(cQry01)
	(cQry01)->(DbGoTop())
  nSldPrd   := 0
  cAuxPrd   := ''
  cAuxPrdD  := ''
  cAuxUM    := ''
  nPrcUnit  := 0
  nQtdVend  := 0
  nVlrPrd   := 0
  //Ticket 81920   - Abel Babini   - 02/01/2023 - Correções no resumo de vendas e quantidades no detalhado
  nResQtd   := 0
  nResVlr   := 0 

  While !(cQry01)->(eof())
    // IF (cQry01)->NFISCAL =='000010498' .AND. Alltrim((cQry01)->CODPRODUTO) == '197772'
    //   alert('teste')
    // ENDIF
    IF !Empty(Alltrim(cAuxPrd)) .and. cAuxPrd != (cQry01)->CODPRODUTO
      AADD(aDetalhe,{ ;// REMESSA
                      (cQry01)->FILIAL,;      // 01
                      "",;  // 02
                      "TT",;       // 03
                      "",;       // 04
                      "",;     // 05
                      "",;        // 06
                      "",;        // 07
                      "",;   // 08
                      "",;   // 09
                      "*** TOTAL DO PRODUTO ***",;     // 00
                      "",;      // 10
                      "",;      // 11
                      cAuxPrd,;  // 12
                      cAuxPrdD,;     // 13
                      "",; // 14
                      "",;        // 15
                      "",;          // 16
                      "",;       // 17
                      0,;       // 18 QUANT
                      0,;     // 19 PRCUNIT
                      0,;       // 20 TOTAL
                      "",;         // 21
                      "",;   // 22
                      "",;  // 23
                      0,;      // 24
                      0,;      // 25
                      ; //VENDAS
                      CTOD('  /  /  '),;      // 26
                      '',;                    // 27
                      '',;                    // 28
                      '',;                    // 29
                      '',;                    // 30
                      '',;                    // 31
                      '',;                    // 32
                      '',;                    // 33
                      '',;                    // 34
                      '',;                    // 35
                      '',;                    // 36
                      '',;                    // 37
                      '',;                    // 38
                      '',;                    // 39
                      '',;                    // 40
                      '',;                    // 41
                      '',;                    // 42
                      0,;                     // 43
                      0,;                     // 44
                      0,;                     // 45
                      '',;                    // 46
                      '',;                    // 47
                      '',;                    // 48
                      0,;                     // 49
                      0,;                     // 50
                      ; //DEVOLUÇÃO
                      CTOD('  /  /  '),;      // 51
                      '',;                    // 52
                      '',;                    // 53
                      '',;                    // 54
                      '',;                    // 55
                      '',;                    // 56
                      '',;                    // 57
                      '',;                    // 58
                      '',;                    // 59
                      '',;                    // 60
                      '',;                    // 61
                      '',;                    // 62
                      '',;                    // 63
                      '',;                    // 64
                      '',;                    // 65
                      '',;                    // 66
                      '',;                    // 67
                      0,;                     // 68
                      0,;                     // 69
                      0,;                     // 70
                      '',;                    // 71
                      '',;                    // 72
                      '',;                    // 73
                      0,;                     // 74
                      0,;                     // 75
                      ; //SALDO
                      nSldPrd,;                     // 76 QUANTIDADE
                      Round(nSldPrd*nPrcUnit,2);                      // 77 VALOR      
      })

      //Quadro Resumo
        // (cQry01)->DATAFISCAL,;
      IF nResQtd > 0 
        AADD(aResumo, {;
          cAuxPrd,;
          cAuxPrdD,;
          nResQtd,;//nSldPrd
          Round(nResVlr/nResQtd,2),;//nSldPrd //nPrcUnit,;
          nResVlr,;
          cAuxUM;
        })
      ENDIF
      nQtdVend := 0
      nSldPrd := 0
      nPrcUnit := 0
      nVlrPrd   := 0
      //Ticket 81920   - Abel Babini   - 02/01/2023 - Correções no resumo de vendas e quantidades no detalhado
      nResQtd   := 0
      nResVlr   := 0 
    ENDIF
    cAuxPrd := (cQry01)->CODPRODUTO
    cAuxPrdD  := (cQry01)->PRODUTO
    cAuxUM    := (cQry01)->UM

    IF (cQry01)->TPOPE == '1R' //REMESSA
      //Ticket 81920   - Abel Babini   - 20/12/2022 - Ajustes nos valores unitários e saldos de quantidade.
      IF nSldPrd < 0
        nSldRem := nSldPrd + (cQry01)->QUANT
      ELSE
        nSldRem := (cQry01)->QUANT
      ENDIF
      nSldPrd   += (cQry01)->QUANT //Ticket 81920   - Abel Babini   - 20/12/2022 - Ajustes nos valores unitários e saldos de quantidade.
      nVlrPrd   += Round((cQry01)->QUANT*(cQry01)->PRCUNIT,2)
      // nPrcUnit  := (cQry01)->PRCUNIT
      AADD(aDetalhe,{ ;// REMESSA
                      (cQry01)->FILIAL,;      // 01
                      (cQry01)->DATAFISCAL,;  // 02
                      (cQry01)->TPOPE,;       // 03
                      (cQry01)->SERIE,;       // 04
                      (cQry01)->NFISCAL,;     // 05
                      (cQry01)->ITEM,;        // 06
                      (cQry01)->CFOP,;        // 07
                      (cQry01)->CODCLIFOR,;   // 08
                      (cQry01)->LOJCLIFOR,;   // 09
                      (cQry01)->NOMECLIFOR,;     // 00
                      (cQry01)->CNPJCLIFOR,;      // 10
                      (cQry01)->UF,;      // 11
                      (cQry01)->CODPRODUTO,;  // 12
                      (cQry01)->PRODUTO,;     // 13
                      (cQry01)->TIPOPRODUTO,; // 14
                      (cQry01)->TIPO,;        // 15
                      (cQry01)->UM,;          // 16
                      (cQry01)->SEGUM,;       // 17
                      (cQry01)->QUANT,;       // 18
                      (cQry01)->PRCUNIT,;     // 19
                      (cQry01)->TOTAL,;       // 20
                      (cQry01)->TES,;         // 21
                      (cQry01)->NUMPEDIDO,;   // 22
                      (cQry01)->ITEMPEDIDO,;  // 23
                      (cQry01)->QTDDEV,;      // 24
                      (cQry01)->VALDEV,;      // 25
                      ; //VENDAS
                      CTOD('  /  /  '),;      // 26
                      '',;                    // 27
                      '',;                    // 28
                      '',;                    // 29
                      '',;                    // 30
                      '',;                    // 31
                      '',;                    // 32
                      '',;                    // 33
                      '',;                    // 34
                      '',;                    // 35
                      '',;                    // 36
                      '',;                    // 37
                      '',;                    // 38
                      '',;                    // 39
                      '',;                    // 40
                      '',;                    // 41
                      '',;                    // 42
                      0,;                     // 43
                      0,;                     // 44
                      0,;                     // 45
                      '',;                    // 46
                      '',;                    // 47
                      '',;                    // 48
                      0,;                     // 49
                      0,;                     // 50
                      ; //DEVOLUÇÃO
                      CTOD('  /  /  '),;      // 51
                      '',;                    // 52
                      '',;                    // 53
                      '',;                    // 54
                      '',;                    // 55
                      '',;                    // 56
                      '',;                    // 57
                      '',;                    // 58
                      '',;                    // 59
                      '',;                    // 60
                      '',;                    // 61
                      '',;                    // 62
                      '',;                    // 63
                      '',;                    // 64
                      '',;                    // 65
                      '',;                    // 66
                      '',;                    // 67
                      0,;                     // 68
                      0,;                     // 69
                      0,;                     // 70
                      '',;                    // 71
                      '',;                    // 72
                      '',;                    // 73
                      0,;                     // 74
                      0,;                     // 75
                      ; //SALDO
                      nSldPrd,;                     // 77 QUANTIDADE
                      nVlrPrd;    // 78 VALOR
      })
      if nSldRem > 0 //@history Ticket 81920   - Abel Babini   - 23/12/2022 - Erro no relatório
        AADD(aRemessa,{ ;// REMESSA
                      Alltrim((cQry01)->CODPRODUTO),;//+dtos((cQry01)->DATAFISCAL),;  // 12
                      (cQry01)->FILIAL,;      // 01
                      (cQry01)->DATAFISCAL,;  // 02
                      (cQry01)->TPOPE,;       // 03
                      (cQry01)->SERIE,;       // 04
                      (cQry01)->NFISCAL,;     // 05
                      (cQry01)->ITEM,;        // 06
                      (cQry01)->CFOP,;        // 07
                      (cQry01)->CODCLIFOR,;   // 08
                      (cQry01)->LOJCLIFOR,;   // 09
                      (cQry01)->NOMECLIFOR,;     // 00
                      (cQry01)->CNPJCLIFOR,;      // 10
                      (cQry01)->UF,;      // 11
                      (cQry01)->CODPRODUTO,;  // 12
                      (cQry01)->PRODUTO,;     // 13
                      (cQry01)->TIPOPRODUTO,; // 14
                      (cQry01)->TIPO,;        // 15
                      (cQry01)->UM,;          // 16
                      (cQry01)->SEGUM,;       // 17
                      (cQry01)->QUANT,;       // 18
                      (cQry01)->PRCUNIT,;     // 19
                      (cQry01)->TOTAL,;       // 20
                      (cQry01)->TES,;         // 21
                      (cQry01)->NUMPEDIDO,;   // 22
                      (cQry01)->ITEMPEDIDO,;  // 23
                      (cQry01)->QTDDEV,;      // 24
                      (cQry01)->VALDEV,;      // 25
                      ; //SALDO
                      nSldRem,;//Ticket 81920   - Abel Babini   - 20/12/2022 - Ajustes nos valores unitários e saldos de quantidade.
                      0;                      // 77 VALOR
        })
      ENDIF
      ASORT(aRemessa, , ,  { | x,y | y[1]+dtos(y[3]) > x[1]+dtos(x[3]) } )

    ELSEIF (cQry01)->TPOPE == '2V' //VENDA
      // nSldPrd   -= ((cQry01)->QUANT)//-(cQry01)->QTDDEV) //Ticket 81920   - Abel Babini   - 17/10/2022 - Ajustes para desconsiderar as devoluções
      nQtdVend := (cQry01)->QUANT
      
      While nQtdVend > 0
        //Localiza Remessa com saldo
        nPEn	:= ASCAN(aRemessa,{|X| X[1] == Alltrim((cQry01)->CODPRODUTO) })
        IF nPEn > 0 
          nPrcUnit  := aRemessa[nPEn,21]
          nVlrPrd   -= Round((cQry01)->QUANT*nPrcUnit,2)

          //Saldo de Remessa >= Quantidade de Venda 
          IF aRemessa[nPEn,28] >= nQtdVend
            nSldPrd   -= (cQry01)->QUANT
            //Ticket 81920   - Abel Babini   - 02/01/2023 - Correções no resumo de vendas e quantidades no detalhado
            AADD(aDetalhe,{ ;// REMESSA
                                    CTOD('  /  /  '),;      
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    (cQry01)->CODPRODUTO,;                    
                                    (cQry01)->PRODUTO,;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    nQtdVend,;//(cQry01)->QUANT,;
                                    aRemessa[nPEn,21],;
                                    0,;                     
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    0,;                     
                                    0,;                         
                                    ; // VENDA
                                    (cQry01)->DATAFISCAL,;
                                    (cQry01)->TPOPE,;
                                    (cQry01)->SERIE,;
                                    (cQry01)->NFISCAL,;
                                    (cQry01)->ITEM,;
                                    (cQry01)->CFOP,;
                                    (cQry01)->CODCLIFOR,;
                                    (cQry01)->LOJCLIFOR,;
                                    (cQry01)->NOMECLIFOR,;
                                    (cQry01)->CNPJCLIFOR,;
                                    (cQry01)->UF,;
                                    (cQry01)->CODPRODUTO,;
                                    (cQry01)->PRODUTO,;
                                    (cQry01)->TIPOPRODUTO,;
                                    (cQry01)->TIPO,;
                                    (cQry01)->UM,;
                                    (cQry01)->SEGUM,;
                                    (cQry01)->QUANT,;
                                    (cQry01)->PRCUNIT,;     
                                    (cQry01)->TOTAL,;       
                                    (cQry01)->TES,;         
                                    (cQry01)->NUMPEDIDO,;   
                                    (cQry01)->ITEMPEDIDO,;  
                                    (cQry01)->QTDDEV,;      
                                    (cQry01)->VALDEV,;  
                                    ; //DEVOLUÇÃO
                                    CTOD('  /  /  '),;      
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    0,;                     
                                    0,;                     
                                    0,;                     
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    0,;                     
                                    0,;                     
                                    ; //SALDO
                                    nSldPrd,;                     // 76 QUANTIDADE
                                    nVlrPrd;                      // 77 VALOR
            })
            IF (cQry01)->DATAFISCAL >= aRet[1] .and. (cQry01)->DATAFISCAL <= aRet[2]
              // nQtdVend  += ((cQry01)->QUANT)//-(cQry01)->QTDDEV) //Ticket 81920   - Abel Babini   - 17/10/2022 - Ajustes para desconsiderar as devoluções
              nResQtd   += nQtdVend
              nResVlr   += nPrcUnit*nQtdVend
            ENDIF
            nQtdVend -= (cQry01)->QUANT
            aRemessa[nPEn,28] -= nQtdVend//(cQry01)->QUANT
          ELSEIF aRemessa[nPEn,28] > 0 .AND. aRemessa[nPEn,28] < nQtdVend
            nSldPrd -= aRemessa[nPEn,28]
            IF (cQry01)->DATAFISCAL >= aRet[1] .and. (cQry01)->DATAFISCAL <= aRet[2]
              // nQtdVend  += ((cQry01)->QUANT)//-(cQry01)->QTDDEV) //Ticket 81920   - Abel Babini   - 17/10/2022 - Ajustes para desconsiderar as devoluções
              nResQtd   += aRemessa[nPEn,28]
              nResVlr   += nPrcUnit*aRemessa[nPEn,28]
            ENDIF
            nQtdVend -= aRemessa[nPEn,28]
            AADD(aDetalhe,{ ;// REMESSA
                                    CTOD('  /  /  '),;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    (cQry01)->CODPRODUTO,;
                                    (cQry01)->PRODUTO,;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    aRemessa[nPEn,28],;
                                    aRemessa[nPEn,21],;
                                    0,;
                                    '',;
                                    '',;
                                    '',;
                                    0,;
                                    0,;
                                    ; // VENDA
                                    (cQry01)->DATAFISCAL,;  
                                    (cQry01)->TPOPE,;       
                                    (cQry01)->SERIE,;       
                                    (cQry01)->NFISCAL,;     
                                    (cQry01)->ITEM,;        
                                    (cQry01)->CFOP,;        
                                    (cQry01)->CODCLIFOR,;   
                                    (cQry01)->LOJCLIFOR,;   
                                    (cQry01)->NOMECLIFOR,;     
                                    (cQry01)->CNPJCLIFOR,;      
                                    (cQry01)->UF,;      
                                    (cQry01)->CODPRODUTO,;  
                                    (cQry01)->PRODUTO,;     
                                    (cQry01)->TIPOPRODUTO,; 
                                    (cQry01)->TIPO,;        
                                    (cQry01)->UM,;          
                                    (cQry01)->SEGUM,;       
                                    (cQry01)->QUANT,;       
                                    (cQry01)->PRCUNIT,;     
                                    (cQry01)->TOTAL,;       
                                    (cQry01)->TES,;         
                                    (cQry01)->NUMPEDIDO,;   
                                    (cQry01)->ITEMPEDIDO,;  
                                    (cQry01)->QTDDEV,;      
                                    (cQry01)->VALDEV,;  
                                    ; //DEVOLUÇÃO
                                    CTOD('  /  /  '),;      
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    0,;                     
                                    0,;                     
                                    0,;                     
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    0,;                     
                                    0,;                     
                                    ; //SALDO
                                    nSldPrd,;                     // 76 QUANTIDADE
                                    Round(nSldPrd*nPrcUnit,2);                      // 77 VALOR
            })
            aRemessa[nPEn,28] := 0
          ELSE //@history Ticket 81920   - Abel Babini   - 23/12/2022 - Erro no relatório
            nSldPrd   -= aRemessa[nPEn,28]
            AADD(aDetalhe,{ ;// REMESSA
                                    CTOD('  /  /  '),;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    (cQry01)->CODPRODUTO,;
                                    (cQry01)->PRODUTO,;
                                    '',;
                                    '',;
                                    '',;
                                    '',;
                                    aRemessa[nPEn,28],;
                                    aRemessa[nPEn,21],;
                                    0,;
                                    '',;
                                    '',;
                                    '',;
                                    0,;
                                    0,;
                                    ; // VENDA
                                    (cQry01)->DATAFISCAL,;  
                                    (cQry01)->TPOPE,;       
                                    (cQry01)->SERIE,;       
                                    (cQry01)->NFISCAL,;     
                                    (cQry01)->ITEM,;        
                                    (cQry01)->CFOP,;        
                                    (cQry01)->CODCLIFOR,;   
                                    (cQry01)->LOJCLIFOR,;   
                                    (cQry01)->NOMECLIFOR,;     
                                    (cQry01)->CNPJCLIFOR,;      
                                    (cQry01)->UF,;      
                                    (cQry01)->CODPRODUTO,;  
                                    (cQry01)->PRODUTO,;     
                                    (cQry01)->TIPOPRODUTO,; 
                                    (cQry01)->TIPO,;        
                                    (cQry01)->UM,;          
                                    (cQry01)->SEGUM,;       
                                    (cQry01)->QUANT,;       
                                    (cQry01)->PRCUNIT,;     
                                    (cQry01)->TOTAL,;       
                                    (cQry01)->TES,;         
                                    (cQry01)->NUMPEDIDO,;   
                                    (cQry01)->ITEMPEDIDO,;  
                                    (cQry01)->QTDDEV,;      
                                    (cQry01)->VALDEV,;  
                                    ; //DEVOLUÇÃO
                                    CTOD('  /  /  '),;      
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    0,;                     
                                    0,;                     
                                    0,;                     
                                    '',;                    
                                    '',;                    
                                    '',;                    
                                    0,;                     
                                    0,;                     
                                    ; //SALDO
                                    nSldPrd,;                     // 76 QUANTIDADE
                                    Round(nSldPrd*nPrcUnit,2);                      // 77 VALOR
            })
            IF (cQry01)->DATAFISCAL >= aRet[1] .and. (cQry01)->DATAFISCAL <= aRet[2]
              // nQtdVend  += ((cQry01)->QUANT)//-(cQry01)->QTDDEV) //Ticket 81920   - Abel Babini   - 17/10/2022 - Ajustes para desconsiderar as devoluções
              nResQtd   += nQtdVend
              nResVlr   += nPrcUnit*nQtdVend
            ENDIF
            nQtdVend -= aRemessa[nPEn,28]
            aRemessa[nPEn,28] := 0
          ENDIF

          IF aRemessa[nPEn,28] == 0 
            ADEL(aRemessa,nPEn)
            ASIZE(aRemessa,Len(aRemessa)-1)
          ENDIF
        ELSE
          //Ticket 81920   - Abel Babini   - 02/01/2023 - Correções no resumo de vendas e quantidades no detalhado
          nSldPrd   -= nQtdVend //((cQry01)->QUANT)
          AADD(aDetalhe,{ ;// REMESSA
                                  CTOD('  /  /  '),;      
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  (cQry01)->CODPRODUTO,;                    
                                  (cQry01)->PRODUTO,;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  nQtdVend,;//(cQry01)->QUANT,;
                                  nPrcUnit,;
                                  0,;                     
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  0,;                     
                                  0,;                         
                                  ; // VENDA
                                  (cQry01)->DATAFISCAL,;
                                  (cQry01)->TPOPE,;
                                  (cQry01)->SERIE,;
                                  (cQry01)->NFISCAL,;
                                  (cQry01)->ITEM,;
                                  (cQry01)->CFOP,;
                                  (cQry01)->CODCLIFOR,;
                                  (cQry01)->LOJCLIFOR,;
                                  (cQry01)->NOMECLIFOR,;
                                  (cQry01)->CNPJCLIFOR,;
                                  (cQry01)->UF,;
                                  (cQry01)->CODPRODUTO,;
                                  (cQry01)->PRODUTO,;
                                  (cQry01)->TIPOPRODUTO,;
                                  (cQry01)->TIPO,;
                                  (cQry01)->UM,;
                                  (cQry01)->SEGUM,;
                                  (cQry01)->QUANT,;
                                  (cQry01)->PRCUNIT,;     
                                  (cQry01)->TOTAL,;       
                                  (cQry01)->TES,;         
                                  (cQry01)->NUMPEDIDO,;   
                                  (cQry01)->ITEMPEDIDO,;  
                                  (cQry01)->QTDDEV,;      
                                  (cQry01)->VALDEV,;  
                                  ; //DEVOLUÇÃO
                                  CTOD('  /  /  '),;      
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  0,;                     
                                  0,;                     
                                  0,;                     
                                  '',;                    
                                  '',;                    
                                  '',;                    
                                  0,;                     
                                  0,;                     
                                  ; //SALDO
                                  nSldPrd,;                     // 76 QUANTIDADE
                                  Round(nSldPrd*nPrcUnit,2);                      // 77 VALOR
          })

          IF (cQry01)->DATAFISCAL >= aRet[1] .and. (cQry01)->DATAFISCAL <= aRet[2]
            nResQtd   += nQtdVend
            nResVlr   += nPrcUnit*nQtdVend
          ENDIF
          nQtdVend := 0//-= (cQry01)->QUANT

        ENDIF
        
      EndDo


      
    ELSEIF (cQry01)->TPOPE == '3D' //DEVOLUÇÃO
      nSldPrd   += ((cQry01)->QUANT)//-(cQry01)->QTDDEV) //Ticket 81920   - Abel Babini   - 17/10/2022 - Ajustes para desconsiderar as devoluções
      AADD(aDetalhe,{ ;// REMESSA
                      CTOD('  /  /  '),;      
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      (cQry01)->CODPRODUTO,;                    
                      (cQry01)->PRODUTO,;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      0,;                     
                      0,;                     
                      0,;                     
                      '',;                    
                      '',;                    
                      '',;                    
                      0,;                     
                      0,;                         
                      ; // VENDA
                      CTOD('  /  /  '),;      
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      '',;                    
                      0,;                     
                      0,;                     
                      0,;                     
                      '',;                    
                      '',;                    
                      '',;                    
                      0,;                     
                      0,;                     
                      ; //DEVOLUÇÃO
                      (cQry01)->DATAFISCAL,;  
                      (cQry01)->TPOPE,;       
                      (cQry01)->SERIE,;       
                      (cQry01)->NFISCAL,;     
                      (cQry01)->ITEM,;        
                      (cQry01)->CFOP,;        
                      (cQry01)->CODCLIFOR,;   
                      (cQry01)->LOJCLIFOR,;   
                      (cQry01)->NOMECLIFOR,;     
                      (cQry01)->CNPJCLIFOR,;      
                      (cQry01)->UF,;      
                      (cQry01)->CODPRODUTO,;  
                      (cQry01)->PRODUTO,;     
                      (cQry01)->TIPOPRODUTO,; 
                      (cQry01)->TIPO,;        
                      (cQry01)->UM,;          
                      (cQry01)->SEGUM,;       
                      (cQry01)->QUANT,;       
                      (cQry01)->PRCUNIT,;     
                      (cQry01)->TOTAL,;       
                      (cQry01)->TES,;         
                      (cQry01)->NUMPEDIDO,;   
                      (cQry01)->ITEMPEDIDO,;  
                      (cQry01)->QTDDEV,;      
                      (cQry01)->VALDEV,;  
                      ; //SALDO
                      nSldPrd,;                     // 76 QUANTIDADE
                      Round(nSldPrd*nPrcUnit,2);                      // 77 VALOR
      })     
    ENDIF

    (cQry01)->(DbSkip())
    
    IF (cQry01)->(eof())
      //Ticket 81920   - Abel Babini   - 02/01/2023 - Correções no resumo de vendas e quantidades no detalhado
      // Último Produto
      AADD(aResumo, {;
        cAuxPrd,;
        cAuxPrdD,;
        nResQtd,;//nSldPrd
        Round(nResVlr/nResQtd,2),;//nSldPrd //nPrcUnit,;
        nResVlr,;
        cAuxUM;
      })
    ENDIF

  EndDo

	(cQry01)->(dbCloseArea())

  xRelBr50(Alltrim(aret[3]),aDetalhe,aret[1],aret[2],aResumo)
Return 

/*/{Protheus.doc} Static Function xRelBr50  
	Gera Relatório de Controle de Remessas, Vendas, Retornos e Devoluções da Filial Itapira
	@author Abel Babini Filho
	@since 10/10/2022
	@version 01
	/*/
Static Function xRelBr50(cPathRel,aDetalhe,dDtIni,dDtFim,aResumo)
	Local aSays			:= {}
	Local aButtons		:= {}
	Local nOpca			:= 0
  Local cCadastr  := OemToAnsi("CONTROLE DE REMESSAS E VENDAS - ITAPIRA - v1.00")
	//+-----------------------------------------------+
	//|Monta Form Batch - Interface com o Usuario     |
	//+-----------------------------------------------+
	AADD(aSays,"Este programa tem a finalidade de Gerar um arquivo Excel " )
	AADD(aSays,"Relatorio de Controle de Remessa e Retorno - Filial Itapira" )
    
	AADD(aButtons, { 1,.T.,{|o| nOpca:=1, o:oWnd:End(), Processa({||xRBr50a(cPathRel,aDetalhe,dDtIni,dDtFim,aResumo)},"Gerando arquivo","Aguarde...")    }})
	AADD(aButtons, { 2,.T.,{|o| nOpca:=2, o:oWnd:End() }})	
	FormBatch( cCadastr, aSays, aButtons )
	
	MsgInfo("Arquivo Excel gerado!")        
	
Return

/*/{Protheus.doc} Static Function xRelBr10b  
	Gera Relatorio de Controle de Remessa e Retorno - Filial Itapira
	@author Abel Babini Filho
	@since 10/10/2022
	@version 01
	/*/
Static Function xRBr50a(cPathRel,aDetalhe,dDtIni,dDtFim,aResumo)
	Private oExcel     := FWMSEXCELEX():New()
	//Private cArquivo	:= cGetFile("Arquivo XML", "Selecione o diretório para salvar o relatório",,'C:\',.T.,GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_NETWORKDRIVE)	
	Private oMsExcel   := NIL
  Private cFld501 := 'Resumo'
  Private cFld50t1 := 'Resumo de Vendas - Itapira - De: '+DTOC(dDtIni)+' Até: '+DTOC(dDtFim)
  Private cFld502 := 'Detalhes'
  Private cFld50t2 := 'Detalhes Remessas e Vendas'

	cArquivo := cPathRel +  'RREMVEN_ITAPIRA_' + DTOS(DATE()) + STRTRAN(TIME(),':','') + '.XML'
	BEGIN SEQUENCE
		
		//IF .NOT.( ApOleClient("MsExcel") )   // se nao existir o excel sai fora..
		//	Alert("Nao Existe Excel Instalado")
		//	BREAK
		//EndIF
        	
		//Planilha1 - Resumo por Vendas
		Cab50P1()             
		GEx50P1(aResumo)
			
		//Planilha2 - Detalhe de Remessas e Vendas
		Cab50P2()
		GEx50P2(aDetalhe)

		//Planilha2 - Mat Uso e Consumo, Imobilizado
		//Cab50P3()
		//GEx50P3()

		//Planilha1 - Resumo com CFOP
		//Cab50P4()             
		//GEx50P4()

		SalvaXml()
		CriaExcel()
	
	END SEQUENCE

Return

/*/{Protheus.doc} Static Function SalvaXml  
	Salva Arquivo XML - Excel
	@author Abel Babini Filho
	@since 10/10/2022
	@version 01

	/*/
Static Function SalvaXml()
	oExcel:Activate()
	oExcel:GetXMLFile(cArquivo)
Return()

/*/{Protheus.doc} Static Function CriaExcel  
	Cria Arquivo XML - Excel
	@author Abel Babini Filho
	@since 10/10/2022
	@version 01
	/*/
Static Function CriaExcel()
  IF ( ApOleClient("MsExcel") )   // se nao existir o excel sai fora..
    oMsExcel := MsExcel():New()
    oMsExcel:WorkBooks:Open(cArquivo)
    oMsExcel:SetVisible( .T. )
    oMsExcel:Destroy()
  ELSE
    Alert("Nao Existe Excel Instalado ou não foi possível localizá-lo. Tente novamente!")
  ENDIF
Return() 

/*/{Protheus.doc} Static Function Cab10P1  
	Gera Relatório Ref. Devolução de Compras  
	@author Abel Babini Filho
	@since 02/09/2019
	@version 01
	/*/
Static Function Cab50P1()
	oExcel:AddworkSheet(cFld501)
	oExcel:AddTable(cFld501,cFld50t1)
  oExcel:AddColumn(cFld501,cFld50t1,"Cod. Prod.",1,1)
  oExcel:AddColumn(cFld501,cFld50t1,"Produto",1,1)
  oExcel:AddColumn(cFld501,cFld50t1,"Qtd.",1,1)
  oExcel:AddColumn(cFld501,cFld50t1,"UM",1,1)
  oExcel:AddColumn(cFld501,cFld50t1,"Vl.Unit.Remessa",2,3)
  oExcel:AddColumn(cFld501,cFld50t1,"Total",2,3)
Return(nil)
/*/{Protheus.doc} Static Function Cab10P2
	Gera Relatório Ref. Devolução de Compras  
	@author Abel Babini Filho
	@since 02/09/2019
	@version 01
	/*/
Static Function Cab50P2()
	oExcel:AddworkSheet(cFld502)
	oExcel:AddTable(cFld502,cFld50t2)
  oExcel:AddColumn(cFld502,cFld50t2,"Filial",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Data Remessa",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"NF",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Série",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Item",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"CFOP",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Cod.CliFor",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Loj.CliFor",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Cliente/Fornecedor",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Cod.Produto",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Produto",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Qtd Enviada",2,2)
  oExcel:AddColumn(cFld502,cFld50t2,"Saldo Envio",2,2)
  oExcel:AddColumn(cFld502,cFld50t2,"Prc.Unit",2,3)
  oExcel:AddColumn(cFld502,cFld50t2,"Valor Envio",2,3)
  oExcel:AddColumn(cFld502,cFld50t2,"Qtd Vendida",2,2)
  oExcel:AddColumn(cFld502,cFld50t2,"Prc. Unit Remessa",2,3)
  oExcel:AddColumn(cFld502,cFld50t2,"Vlr Total",2,3)
  oExcel:AddColumn(cFld502,cFld50t2,"Data Venda",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"NF",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Série",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Item",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"CFOP",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Cod.CliFor",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Loj.CliFor",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Cliente/Fornecedor",1,1)
  oExcel:AddColumn(cFld502,cFld50t2,"Saldo Quantidade",2,2)
  oExcel:AddColumn(cFld502,cFld50t2,"Saldo Vlr Total",2,3)

RETURN(NIL)  
/*/{Protheus.doc} Static Function GEx10P1  
	Gera Relatório Ref. Devolução de Compras  
	@author Abel Babini Filho
	@since 02/09/2019
	@version 01
	/*/
Static Function GEx50P1(aResumo)
  Local i := 0
  FOR i:=1 to len(aResumo) 
    oExcel:AddRow(cFld501,cFld50t1,{ ;
      aResumo[i,1],;
      aResumo[i,2],;
      aResumo[i,3],;
      aResumo[i,6],;
      aResumo[i,4],;
      aResumo[i,5];
    })
  NEXT i
  oExcel:AddRow(cFld501,cFld50t1,{ "", "", "", "", "", "" })
Return (nil)
/*/{Protheus.doc} Static Function GEx10P2
	Gera Relatório Ref. Devolução de Compras  
	@author Abel Babini Filho
	@since 02/09/2019
	@version 01
	/*/
Static Function GEx50P2(aDetalhe)
  Local i := 0
  // oExcel:SetCelBold(.T.)
  // oExcel:SetCelFrColor("#FFFFFF")
  // oExcel:SetCelBgColor("#000666")   
  // oExcel:SetCelFont('Arial')
  // oExcel:SetCelItalic(.T.)
  // oExcel:SetCelUnderLine(.T.)
  // oExcel:SetCelSizeFont(15)
  cAuxPrd := ''
  FOR i:=1 to len(aDetalhe) 
    oExcel:AddRow(cFld502,cFld50t2,{ ;
      aDetalhe[i,1],; //"Filial",;
      aDetalhe[i,2],; //"Data Remessa",;
      aDetalhe[i,5],; //"NF",;
      aDetalhe[i,4],; //"Série",;
      aDetalhe[i,6],; //"Item",;
      aDetalhe[i,7],; //"CFOP",;
      aDetalhe[i,8],; //"Cod.CliFor",;
      aDetalhe[i,9],; //"Loj.CliFor",;
      aDetalhe[i,10],; //"Cliente/Fornecedor",;
      iif(aDetalhe[i,3]=='1R',aDetalhe[i,13],aDetalhe[i,38]),; //"Cod.Produto",;
      iif(aDetalhe[i,3]=='1R',aDetalhe[i,14],aDetalhe[i,39]),; //"Produto",;
      iif(aDetalhe[i,3]=='1R',aDetalhe[i,19],0),; //"Qtd Enviada",;
      aDetalhe[i,77],; //"Saldo Envio",;
      aDetalhe[i,20],; //"Prc.Unit",;
      iif(aDetalhe[i,3]=='1R',aDetalhe[i,21],Round(aDetalhe[i,44]*aDetalhe[i,45],2)),; //"Valor Envio",;//Round((aDetalhe[i,19]-aDetalhe[i,25])*aDetalhe[i,20],2),; //"Valor Envio",;
      iif(aDetalhe[i,3]=='1R',0,aDetalhe[i,19]),; //"Qtd Vendida",;
      iif(aDetalhe[i,19]>0,aDetalhe[i,20],0),; //"Prc. Unit Remessa",;
      Round(aDetalhe[i,19]*aDetalhe[i,20],2),; //"Vlr Total",;
      aDetalhe[i,27],; //"Data Venda",;
      aDetalhe[i,30],; //"NF",;
      aDetalhe[i,29],; //"Série",;
      aDetalhe[i,31],; //"Item",;
      aDetalhe[i,32],; //"CFOP",;
      aDetalhe[i,33],; //"Cod.CliFor",;
      aDetalhe[i,34],; //"Loj.CliFor",;
      aDetalhe[i,35],; //"Cliente/Fornecedor",;
      aDetalhe[i,77],; //"Saldo Quantidade",;
      aDetalhe[i,78]; //"Saldo Vlr Total",;
      })
    // },{10,11,14,15,17,18,19})
  NEXT i
	//Linha em Branco
	oExcel:AddRow(cFld502,cFld50t2,{ "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", ""})
  //	
Return
