#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function M310ITENS
	Ponto de Entrada para realizar a entrada de informações complementares
    na transferencia entre filiais
	@type  Function 
	@author Andre Mendes - Obify
	@since  28/04/21 
	@version 01
    @history Chamado 8566 	- André Mendes 	- 29/04/2021 - Transferência entre Filiais 
    @history Ticket  16982  - Abel Babini   - 27/07/2021 - Ajuste no armazém padrão de destino
    @history Ticket  16982  - Abel Babini   - 03/08/2021 - Acrescentar aviso para o usuário sobre o armazém de destino padrão.
    @history Ticket  16982  - Abel Babini   - 03/08/2021 - Acrescentar aviso para o usuário sobre o armazém de destino padrão.
    @history ticket 90838 - 29/03/2023 - Fernando Macieira - TRANSFERENCIA DE ITENS DE ALMOXARIFADO - MATRIZES
/*/
User Function M310ITENS

    Local cPrograma:=PARAMIXB[1]
    Local aItens   :=PARAMIXB[2]
    Local lRet
    Local aCpos := {}
    //Ticket  16982  - Abel Babini   - 27/07/2021 - Ajuste no armazém padrão de destino
    Local i := 0
    Local j := 0
    Local cLocPad := ''

    If cPrograma $ "MATA140,MATA103" // entrada
    // ARRAY AITENS (PADRAO DAS ROTINAS AUTOMATICAS)
    // [1]       ITEM 1
    // [1][1]    CAMPO 1 DO ITEM 1
    // [1][1][1] NOME DO CAMPO
    // [1][1][2] CONTEUDO DO CAMPO
    // [1][1][3] VALIDACAO A SER UTILIZADA

    // Exemplo MUDANDO ARMAZEM
        //aCpos:={"D1_CC","D1_ITEMCTA"}
        aCpos := {"D1_CC","D1_ITEMCTA","D1_XLOTECC"} // @history ticket 90838 - 29/03/2023 - Fernando Macieira - TRANSFERENCIA DE ITENS DE ALMOXARIFADO - MATRIZES
        // aItens
        lRet := fGetCps(@aItens, aCpos, cPrograma)
        //INICIO Ticket  16982  - Abel Babini   - 27/07/2021 - Ajuste no armazém padrão de destino
        for i:=1 to Len(aItens)
            for j:=1 to Len(aItens[i])
                if Alltrim(aItens[i][j][1]) == 'D1_COD'
                    dbSelectArea("SBZ")
                    SBZ->(dbSetOrder(1))
                    if SBZ->(dbSeek(cFilAnt+Alltrim(aItens[i][j][2])))
                        cLocPad := SBZ->BZ_LOCPAD
                    endif
                    exit
                endif
            next j
        next i
        if cLocPad <> ''
            for i:=1 to Len(aItens)
                for j:=1 to Len(aItens[i])
                    //Ticket  16982  - Abel Babini   - 03/08/2021 - Acrescentar aviso para o usuário sobre o armazém de destino padrão.
                    if Alltrim(aItens[i][j][1]) == 'D1_LOCAL' .AND. Alltrim(aItens[i][j][2]) <> Alltrim(cLocPad)
                        Aviso(	"M310ITENS-01",;
						"Armazém de destino alterado conf. Indicador de Produtos (SBZ) para : " + Alltrim(cLocPad) + "." + Chr(13) + Chr(10) +;
						"Armazém substituído: " + Alltrim(aItens[i][j][2]) + ".",;
						{ "&Retorna" },,;
						"Aviso Controladoria" )
                        aItens[i][j][2]:=cLocPad
                        exit
                    endif
                next j
            next i
        endif
        //FIM Ticket  16982  - Abel Babini   - 27/07/2021 - Ajuste no armazém padrão de destino
    
    ElseIf AllTrim(cPrograma) $ "MATA410"
        
        // @history ticket 90838 - 29/03/2023 - Fernando Macieira - TRANSFERENCIA DE ITENS DE ALMOXARIFADO - MATRIZES
        If _lMatrizes_ // Variável pública oriunda do PE MTA310OK
            aCpos := Array(2)
            aCpos[1] := "C6_XLOTECC"
            aCpos[2] := "C6_CC"
            Do While .t.
                lRet := fGetCps(@aItens, aCpos, cPrograma)
                If lRet
                    Exit
                EndIf
            EndDo
        Else
            If MsgYesNo("Deseja informar Lote x CC para os itens do pedido de venda?", "Lote x CC")
                aCpos:={"C6_XLOTECC"}
                lRet := fGetCps(@aItens, aCpos, cPrograma)
            Endif
        EndIf
    
    EndIf

RETURN aItens

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 29/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fGetCps(aItens, aCpos, cPrograma)

    Local aArea := GetArea()
    Local nX := 0
    //Local nTamAc := 0
    //Local nDel := 0
    Local nOpc := 0
    Local oDlg, oGetD1
    Local lRet := .F.
    Local nz
    Local nC
    Local aAlter
    Local aHTab := {}
    Local i

    If Empty(aHTab)
        
        aAlter := aClone(aCpos)
        For nx:=1 to Len(aItens)
            For nz:=1 to Len(aItens[nx])
                aAdd(aCpos,aItens[nx,nz,1])
            Next nz
        Next nx

        aHTab:={}
        aCTab:={}

        //@history Ticket 70142  - Rodrigo / Flek Solution - 18/07/2022 - Ajustes Dic. de dados no Banco
        /*DbSelectArea("SX3")
        DbSetOrder(2)
        For nX:=1 To Len(aCpos)
            If MsSeek(aCpos[nX])
                If (X3USO(SX3->X3_USADO) .AND. cNivel >= SX3->X3_NIVEL )
                    Aadd(aHTab,{AllTrim(X3Titulo()),;
                                    SX3->X3_CAMPO,;
                                    SX3->X3_PICTURE,;
                                    SX3->X3_TAMANHO,;
                                    SX3->X3_DECIMAL,;
                                    SX3->X3_VALID,;
                                    SX3->X3_USADO,;
                                    SX3->X3_TIPO,;
                                    SX3->X3_F3,;
                                    SX3->X3_CONTEXT,;
                                    X3CBOX(),;
                                    SX3->X3_RELACAO,;
                                    ".T."})
                EndIf
            Endif
        Next*/
        For nX:=1 To Len(aCpos)
            Aadd(aHTab,{AllTrim(GetSX3Cache(aCpos[nX], 'X3_TITULO')),;
                        GetSX3Cache(aCpos[nX], 'X3_CAMPO'),;
                        GetSX3Cache(aCpos[nX], 'X3_PICTURE'),;
                        GetSX3Cache(aCpos[nX], 'X3_TAMANHO'),;
                        GetSX3Cache(aCpos[nX], 'X3_DECIMAL'),;
                        GetSX3Cache(aCpos[nX], 'X3_VALID'),;
                        GetSX3Cache(aCpos[nX], 'X3_USADO'),;
                        GetSX3Cache(aCpos[nX], 'X3_TIPO'),;
                        GetSX3Cache(aCpos[nX], 'X3_F3'),;
                        GetSX3Cache(aCpos[nX], 'X3_CONTEXT'),;
                        GetSX3Cache(aCpos[nX], 'X3_CBOX'),;
                        GetSX3Cache(aCpos[nX], 'X3_RELACAO' ),;
                        ".T."})
        Next

        For nz:= 1 To Len(aItens)

            Aadd(aCTab,Array(Len(aHTab)+1))

            // @history ticket 90838 - 29/03/2023 - Fernando Macieira - TRANSFERENCIA DE ITENS DE ALMOXARIFADO - MATRIZES
            If _lMatrizes_ // Variável pública oriunda do PE MTA310OK

                // Origem - Saída
                If AllTrim(cPrograma) $ "MATA410"
                
                    nPosPRD := aScan( aItens[nz], { |X| ALLTRIM(X[nz]) == "C6_PRODUTO" } )
                    nPosLOC := aScan( aItens[nz], { |X| ALLTRIM(X[nz]) == "C6_LOCAL" } )
                    nPosQTD := aScan( aItens[nz], { |X| ALLTRIM(X[nz]) == "C6_QTDVEN" } )
                    nPosPRC := aScan( aItens[nz], { |X| ALLTRIM(X[nz]) == "C6_PRCVEN" } )
                    nPosPRU := aScan( aItens[nz], { |X| ALLTRIM(X[nz]) == "C6_PRUNIT" } )
                    nPosVLR := aScan( aItens[nz], { |X| ALLTRIM(X[nz]) == "C6_VALOR" } )
                    If nPosPRC > 0 .and. nPosPRU > 0 .and. nPosVLR > 0 .and. nPosPRD > 0 .and. nPosLOC > 0 .and. nPosQTD > 0
                        
                        cCodPro := aItens[nz,nPosPRD,2]
                        cLocal  := aItens[nz,nPosLOC,2]
                        nVlrUni := aItens[nz,nPosPRC,2]
                        nQtd    := aItens[nz,nPosQTD,2]
                        
                        nVlrSB9 := GetSB9(cCodPro, cLocal, nVlrUni)
                        
                        aItens[nz,nPosPRC,2] := nVlrSB9
                        aItens[nz,nPosPRU,2] := nVlrSB9
                        aItens[nz,nPosVLR,2] := Round(nVlrSB9*nQtd,2)
                    
                    EndIf
                
                EndIf

                // Destino - Entrada
                If AllTrim(cPrograma) $ "MATA140|MATA103"
                    nPosCC := aScan( aItens[nz], { |X| ALLTRIM(X[nz]) == "D1_CC" } )
                    nPosLT := aScan( aItens[nz], { |X| ALLTRIM(X[nz]) == "D1_XLOTECC" } )
                    If nPosCC > 0 .and. nPosLT > 0
                        aItens[nz,nPosCC,2] := SC6->C6_CC
                        aItens[nz,nPosLT,2] := SC6->C6_XLOTECC
                    EndIf
                EndIf

            EndIf

            For nX:=1 To Len(aHTab)
                nC := aScan( aItens[nz],{ | x | x[01] == Alltrim(aHTab[nX][2])  }) 
                If  nC > 0
                    aCTab[nz][nX]:= aItens[nz][nC][02]
                Else
                    aCTab[nz][nX]:=Criavar(aHTab[nX][2])
                Endif

            Next

            aCTab[1][Len(aCTab[1])]:=.F.

        Next nz

    Endif

    DEFINE MSDIALOG oDlg TITLE "[M310ITENS] - Informar Campos Complementares - "+cPrograma From 0,0 To 400,1200 Of oMainWnd Pixel
        oGetD1 := MsNewGetDados():New(050,030,175,600,GD_UPDATE,,"AllwaysTrue()" ,,aAlter,/*freeze*/,,/*fieldok*/,/*superdel*/,/*delok*/,oDlg,@aHTab,@aCTab)
    ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||aCTab:=oGetD1:aCols,nOpc:=1,oDlg:End()},{||nOpc:=0,oDlg:End()}) CENTERED

    lRet:=(nOpc==1)
    If nOpc==1
        For nX := 1 To Len(aAlter)
            nC := aScan(aHTab, { |x| Alltrim(x[2]) ==  Alltrim(aAlter[nX])  })
            If nC >0
                for nz := 1 to Len(aCTab)
                    aAdd(aItens[nz], {aAlter[nX]	,aCTab[nz][nC],Nil} )
                next
            Endif
            
        Next nX
    /*
        nOpc:=Len(aCTab)
        nLenAc:=Len(aCTab[1])
        nDel:=0
        For nX:=nOpc To 1 Step -1
            If aCTab[nX][nLenAc]
                nDel++
                Adel(aCTab,nX)
            Endif
        Next
        If nDel>0
            aCTab:=aSize(aCTab,nOpc-nDel)
        Endif
        */
    Endif

    // @history ticket 90838 - 29/03/2023 - Fernando Macieira - TRANSFERENCIA DE ITENS DE ALMOXARIFADO - MATRIZES
    If _lMatrizes_ // Variável pública oriunda do PE MTA310OK

        For i:=1 to Len(aItens)

            // Origem - Saída
            If AllTrim(cPrograma) $ "MATA410"
                nPosCC := aScan( aItens[i], { |X| ALLTRIM(X[i]) == "C6_CC" } )
                nPosLT := aScan( aItens[i], { |X| ALLTRIM(X[i]) == "C6_XLOTECC" } )
                If nPosCC > 0 .and. nPosLT > 0
                    If Empty(aItens[i,nPosCC,2]) .and. Empty(aItens[i,nPosLT,2])
                        lRet := .f.
                            Alert("Obrigatório preencher os campos Centro de Custo e Lote Recria! Verifique...")
                        Exit
                    EndIf
                EndIf
            EndIf

            // Destino - Entrada
            If AllTrim(cPrograma) $ "MATA140|MATA103"
                nPosCC := aScan( aItens[i], { |X| ALLTRIM(X[i]) == "D1_CC" } )
                nPosLT := aScan( aItens[i], { |X| ALLTRIM(X[i]) == "D1_XLOTECC" } )
                If nPosCC > 0 .and. nPosLT > 0
                    aItens[i,nPosCC,2] := SC6->C6_CC
                    aItens[i,nPosLT,2] := SC6->C6_XLOTECC
                    If Empty(aItens[i,nPosCC,2]) .and. Empty(aItens[i,nPosLT,2])
                        lRet := .f.
                            Alert("Obrigatório preencher os campos Centro de Custo e Lote Recria! Verifique...")
                        Exit
                    EndIf
                EndIf
            EndIf

        Next i

    EndIf

    RestArea(aArea)

Return(lRet)

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 29/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GetSB9(cCodPro, cLocal, nVlrUni)

    Local nVlr := 0
    Local cQuery := ""

    Default cCodPro := ""
    Default cLocal  := ""
    Default nVlrUni := 0

    nVlr := nVlrUni

    If Select("WorkSB9") > 0
        WorkSB9->( dbCloseArea() )
    EndIf

    cQuery := " SELECT B9_DATA, B9_CM1 
    cQuery += " FROM " + RetSqlName("SB9") + " (NOLOCK)
    cQuery += " WHERE B9_FILIAL='"+FWxFilial("SB9")+"' 
    cQuery += " AND B9_COD='"+cCodPro+"'
    cQuery += " AND B9_LOCAL='"+cLocal+"'
    cQuery += " AND D_E_L_E_T_=''
    cQuery += " ORDER BY 1 DESC

    tcQuery cQuery new Alias "WorkSB9"

    aTamSX3	:= TamSX3("B9_CM1")
	tcSetField("WorkSB9", "B9_CM1", aTamSX3[3], aTamSX3[1], aTamSX3[2])

    WorkSB9->( dbGoTop() )
    If WorkSB9->( !EOF() )
        nVlr := WorkSB9->B9_CM1
    EndIf

    If Select("WorkSB9") > 0
        WorkSB9->( dbCloseArea() )
    EndIf
    
Return nVlr
