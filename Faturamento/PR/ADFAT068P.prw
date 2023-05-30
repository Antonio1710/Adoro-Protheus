#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "REPORT.CH"
#INCLUDE "TBICONN.CH"

/*/{Protheus.doc} User Function ADFAT068P
    ExecAuto - PV - Empresa 13 (Vista) - rotina para importação dos dados da planilha e incluir pedido de venda no Protheus, Respeitando o layout anexo, desenhado
    @type  Function
    @author Fernando Macieira
    @since 22/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @ticket 94258
/*/
User Function ADFAT068P()

    Local lOk		:= .F.
    Local alSay		:= {}
    Local alButton	:= {}
    Local clTitulo	:= 'ExecAuto - PV'
    Local clDesc1   := 'O objetivo desta rotina é gerar pedidos de vendas '
    Local clDesc2   := 'a partir de um Excel'
    Local clDesc3   := ''
    Local clDesc4   := '( Necessário converter, previamente, esta planilha em arquivo CSV = Separado por ";" )'
    Local clDesc5   := ''
    Local _lUsrAut  := GetMV("MV_#ATVUSR",,.f.) // Ativa controle de usuarios autorizados
    Local _cUsrAut  := GetMV("MV_#USRAUT",,"") // 

	Private cAliasTRB := "TRB"
    Private cRotina := "ADFAT068P"

    // Consistências
    If _lUsrAut
        If !(RetCodUsr() $ _cUsrAut)
            Aviso(cRotina+"-02", "Usuário não autorizado para utilizar esta rotina! Verifique parâmetro MV_#USRAUT", {"OK"}, 3)
            Return			
        EndIf
    EndIf

    If !LockByName(cRotina, .T., .F.)
	    Aviso(cRotina+"-03", "Atenção! Existe outro processamento sendo executado! Verifique...", {"OK"}, 3)
    	Return
	EndIf

    // Mensagens de Tela Inicial
    aAdd(alSay, clDesc1)
    aAdd(alSay, clDesc2)
    aAdd(alSay, clDesc3)
    aAdd(alSay, clDesc4)
    aAdd(alSay, clDesc5)

    // Botoes do Formatch
    aAdd(alButton, {1, .T., {|| lOk := .T., FechaBatch()}})
    aAdd(alButton, {2, .T., {|| lOk := .F., FechaBatch()}})

    FormBatch(clTitulo, alSay, alButton)

    If lOk
        Processa( { || RunPV13() }, "Gerando pedidos de vendas..." )
    EndIf

    UnLockByName(cRotina)
   
Return

/*/{Protheus.doc} Static Function RunPV13
    (long_description)
    @type  Static Function
    @author user
    @since 22/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function RunPV13()

    Local lFile      := .f.
    Local cTxt       := ""
    Local nCount     := 0
    Local aDadPV     := {}
    Local aCampos    := {}

    Private nPerc   := 0

    cFile := cGetFile("Arquivos CSV (Separados por Vírgula) | *.CSV",;
    ("Selecione o diretorio onde encontra-se o arquivo a ser processado"), 0, "Servidor\", .t., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)// + GETF_RETDIRECTORY)

    If At(".CSV", upper(cFile)) > 0
        lFile := .t.
        ft_fUse(cFile)
    Else
        Aviso(cRotina+"-01", "Não foi possível abrir o arquivo...", {"&Ok"},, "Arquivo não identificado!")
    EndIf

    // Arquivo TXT
    If lFile
        
        ft_fGoTop()

        cVerTab := "C5_NUM;C5_TIPO;C5_CLIENTE;C5_LOJACLI;C5_LATITUDE;C5_LOGITUDE;C5_CONDPAG;C5_EMISSAO;C5_DTENTR;C5_MENNOTA;C5_PBRUTO;C5_PESOL;C5_DESC1;C5_VEND1;C6_ITEM;C6_PRODUTO;C6_UNSVEN;C6_SEGUM;C6_QTDVEN;C6_UM;C6_PRCVEN;C6_PRUNIT;C6_VALOR;C6_DESCONT;C6_VALDESC;C6_ENTREG"
        cTxt  := AllTrim(ft_fReadLn())
        
        If cVerTab <> cTXT
            
            Aviso(cRotina+"-04", "A importação não será realizada! As colunas do excel precisam ser: " + chr(13)+chr(10) + cVerTab , {"&Ok"},, "Versão/Leiaute da planilha incorreta!")
            
        Else
                    
            // Crio TRB para impressão
            If Select("TRB") > 0
                TRB->( dbCloseArea() )
            EndIf

            // https://tdn.totvs.com.br/display/framework/FWTemporaryTable
            oTRBTable := FWTemporaryTable():New("TRB")
            
            // Arquivo TRB
            aCampos := {}
            aAdd( aCampos, {'LINHA'     ,TamSX3("C5_NUM")[3]     ,10 , 0} )
            aAdd( aCampos, {'PEDIDO'    ,TamSX3("C5_NUM")[3]     ,20 , 0} )
            aAdd( aCampos, {'STATUS'    ,TamSX3("B1_DESC")[3]    ,100, 0} )
            aAdd( aCampos, {'TXT'       ,TamSX3("B1_DESC")[3]    ,254, 0} )

            oTRBTable:SetFields(aCampos)
            oTRBTable:AddIndex("01", {"PEDIDO"} )
            oTRBTable:Create()


            // Crio TRBPV para EXECAUTO
            If Select("TRBPV") > 0
                TRBPV->( dbCloseArea() )
            EndIf
                
            // https://tdn.totvs.com.br/display/framework/FWTemporaryTable
            oPVTable := FWTemporaryTable():New("TRBPV")
            
            // Arquivo TRBPV
            aCampos := {}
            aAdd( aCampos, {'C5_NUM'        ,TamSX3("C5_NUM")[3]          ,TamSX3("C5_NUM")[1]          , 0} )
            aAdd( aCampos, {'C5_CLIENTE'    ,TamSX3("C5_CLIENTE")[3]      ,TamSX3("C5_CLIENTE")[1]      , 0} )
            aAdd( aCampos, {'C5_LOJACLI'    ,TamSX3("C5_LOJACLI")[3]      ,TamSX3("C5_LOJACLI")[1]      , 0} )
            /*
            aAdd( aCampos, {'C5_LATITUDE'   ,TamSX3("C5_LATITUDE")[3]     ,TamSX3("C5_LATITUDE")[1]     , TamSX3("C5_LATITUDE")[2]} )
            aAdd( aCampos, {'C5_LOGITUDE'   ,TamSX3("C5_LOGITUDE")[3]     ,TamSX3("C5_LOGITUDE")[1]     , TamSX3("C5_LOGITUDE")[2]} )
            */
            aAdd( aCampos, {'C5_CONDPAG'    ,TamSX3("C5_CONDPAG")[3]      ,TamSX3("C5_CONDPAG")[1]      , TamSX3("C5_CONDPAG")[2]} )
            aAdd( aCampos, {'C5_EMISSAO'    ,TamSX3("C5_EMISSAO")[3]      ,TamSX3("C5_EMISSAO")[1]      , TamSX3("C5_EMISSAO")[2]} )
            aAdd( aCampos, {'C5_DTENTR'     ,TamSX3("C5_DTENTR")[3]       ,TamSX3("C5_DTENTR")[1]       , TamSX3("C5_DTENTR")[2]} )
            aAdd( aCampos, {'C5_MENNOTA'    ,TamSX3("C5_MENNOTA")[3]      ,TamSX3("C5_MENNOTA")[1]      , TamSX3("C5_MENNOTA")[2]} )
            aAdd( aCampos, {'C5_PBRUTO'     ,TamSX3("C5_PBRUTO")[3]       ,TamSX3("C5_PBRUTO")[1]       , TamSX3("C5_PBRUTO")[2]} )
            aAdd( aCampos, {'C5_PESOL'      ,TamSX3("C5_PESOL")[3]        ,TamSX3("C5_PESOL")[1]        , TamSX3("C5_PESOL")[2]} )
            aAdd( aCampos, {'C5_DESC1'      ,TamSX3("C5_DESC1")[3]        ,TamSX3("C5_DESC1")[1]        , TamSX3("C5_DESC1")[2]} )
            aAdd( aCampos, {'C5_VEND1'      ,TamSX3("C5_VEND1")[3]        ,TamSX3("C5_VEND1")[1]        , TamSX3("C5_VEND1")[2]} )

            aAdd( aCampos, {'C6_ITEM'       ,TamSX3("C6_ITEM")[3]         ,TamSX3("C6_ITEM")[1]         , 0} )
            aAdd( aCampos, {'C6_PRODUTO'    ,TamSX3("C6_PRODUTO")[3]      ,TamSX3("C6_PRODUTO")[1]      , 0} )
            aAdd( aCampos, {'C6_UNSVEN'     ,TamSX3("C6_UNSVEN")[3]       ,TamSX3("C6_UNSVEN")[1]       , TamSX3("C6_UNSVEN")[2]} )
            aAdd( aCampos, {'C6_SEGUM'      ,TamSX3("C6_SEGUM")[3]        ,TamSX3("C6_SEGUM")[1]        , TamSX3("C6_SEGUM")[2]} )
            aAdd( aCampos, {'C6_QTDVEN'     ,TamSX3("C6_QTDVEN")[3]       ,TamSX3("C6_QTDVEN")[1]       , TamSX3("C6_QTDVEN")[2]} )
            aAdd( aCampos, {'C6_UM'         ,TamSX3("C6_UM")[3]           ,TamSX3("C6_UM")[1]           , TamSX3("C6_UM")[2]} )
            aAdd( aCampos, {'C6_PRCVEN'     ,TamSX3("C6_PRCVEN")[3]       ,TamSX3("C6_PRCVEN")[1]       , TamSX3("C6_PRCVEN")[2]} )
            aAdd( aCampos, {'C6_PRUNIT'     ,TamSX3("C6_PRUNIT")[3]       ,TamSX3("C6_PRUNIT")[1]       , TamSX3("C6_PRUNIT")[2]} )
            aAdd( aCampos, {'C6_VALOR'      ,TamSX3("C6_VALOR")[3]        ,TamSX3("C6_VALOR")[1]        , TamSX3("C6_VALOR")[2]} )
            aAdd( aCampos, {'C6_DESCONT'    ,TamSX3("C6_DESCONT")[3]      ,TamSX3("C6_DESCONT")[1]      , TamSX3("C6_DESCONT")[2]} )
            aAdd( aCampos, {'C6_VALDESC'    ,TamSX3("C6_VALDESC")[3]      ,TamSX3("C6_VALDESC")[1]      , TamSX3("C6_VALDESC")[2]} )
            aAdd( aCampos, {'C6_ENTREG'     ,TamSX3("C6_ENTREG")[3]       ,TamSX3("C6_ENTREG")[1]       , TamSX3("C6_ENTREG")[2]} )

            oPVTable:SetFields(aCampos)
            oPVTable:AddIndex("01", {"C5_NUM","C6_ITEM"} )
            oPVTable:Create()

            // Consistência
            ft_fSkip() // pulo cabeçalho
            Do While !ft_fEOF()
                
                IncProc( "Consistindo CSV... " + StrZero(nCount++, 9) )
                
                cTxt    := ft_fReadLn()
                aDadPV  := Separa(cTxt, ";")
                
                cNumPV    := AllTrim(aDadPV[1])
                cCliCod   := AllTrim(aDadPV[3])
                cCliLoj   := AllTrim(aDadPV[4])
                cCodPro   := AllTrim(aDadPV[16])
                nLatitude := Val(StrTran(aDadPV[5],",","."))
                nLogitude := Val(StrTran(aDadPV[6],",","."))
                dEmissao  := CtoD(aDadPV[8])
                dEntrega  := CtoD(aDadPV[9])
                dIEntreg  := CtoD(aDadPV[26])
                nPBruto   := Val(StrTran(aDadPV[11],",","."))
                nPLiquido := Val(StrTran(aDadPV[12],",","."))
                nC6UNSVEN := Val(StrTran(aDadPV[17],",","."))
                nC6QTDVEN := Val(StrTran(aDadPV[19],",","."))
                nC6PRCVEN := Val(StrTran(aDadPV[21],",","."))
                nC6PRUNIT := Val(StrTran(aDadPV[22],",","."))
                nC6VALOR  := Val(StrTran(aDadPV[23],",","."))

                cMsgNF    := aDadPV[10]
                nDesc1    := Val(StrTran(aDadPV[13],",","."))
                nItem     := StrZero(Val(aDadPV[15]),TamSX3("C6_ITEM")[1])
                c1UM      := aDadPV[20]
                c2UM      := aDadPV[18]
                nC6DESCONT:= Val(StrTran(aDadPV[24],",","."))
                nC6VALDESC:= Val(StrTran(aDadPV[25],",","."))

                lPVOk := .t.

                // ignoro linha com num PV em branco
                If Empty(AllTrim(cNumPV))
                    ft_fSkip()
                    Loop
                EndIf

                // ignoro linha com num PV em branco
                If Empty(AllTrim(cNumPV)) .or. Empty(AllTrim(cCliCod)) .or. Empty(AllTrim(cCliLoj)) .or. Empty(AllTrim(cCodPro))
                    lPVOk := .f.
                    GrvTRB(0, cNumPV, cNumPV+cCliCod+cCliLoj+cCodPro, cTXT, nCount)
                EndIf

                // Verifico se o PV já existe
                If lExistPV(cNumPV)
                    lPVOk := .f.
                    GrvTRB(1, cNumPV, cNumPV, cTXT, nCount)
                EndIf

                // Verifico se o cliente existe
                SA1->( dbSetOrder(1) ) // A1_FILIAL+A1_COD+A1_LOJA
                If SA1->( !dbSeek(FWxFilial("SA1")+PadR(cCliCod,TamSX3("A1_COD")[1])+PadR(cCliLoj,TamSX3("A1_LOJA")[1])) )
                    lPVOk := .f.
                    GrvTRB(2, cNumPV, cCliCod+cCliLoj, cTXT, nCount)
                Else
                    // Cliente Bloqueado
                    If AllTrim(SA1->A1_MSBLQL) == "1"
                        lPVOk := .f.
                        GrvTRB(3, cNumPV, cCliCod+cCliLoj, cTXT, nCount)
                    EndIf
                EndIf

                // Verifico se o produto existe
                SB1->( dbSetOrder(1) ) // B1_FILIAL+B1_COD
                If SB1->( !dbSeek(FWxFilial("SB1")+cCodPro) )
                    lPVOk := .f.
                    GrvTRB(4, cNumPV, cCodPro, cTXT, nCount)
                Else
                    // Produto bloqueado
                    If AllTrim(SB1->B1_MSBLQL) == "1"
                        lPVOk := .f.
                        GrvTRB(5, cNumPV, cCodPro, cTXT, nCount)
                    EndIf
                EndIf

                /*If nLatitude == 0 .or. nLogitude == 0
                    lPVOk := .f.
                    GrvTRB(6, cNumPV, AllTrim(Str(0)), cTXT, nCount)
                EndIf*/

                If dIEntreg <= msDate() .or. dIEntreg < dEntrega
                    lPVOk := .f.
                    GrvTRB(7, cNumPV, DtoC(dIEntreg), cTXT, nCount)
                EndIf

                If dEmissao < msDate()
                    lPVOk := .f.
                    GrvTRB(8, cNumPV, DtoC(dEmissao), cTXT, nCount)
                EndIf

                If dEntrega <= msDate() .or. dEntrega <= dEmissao
                    lPVOk := .f.
                    GrvTRB(9, cNumPV, DtoC(dEntrega), cTXT, nCount)
                EndIf

                If nPBruto <= 0 .or. nPLiquido <= 0
                    lPVOk := .f.
                    GrvTRB(10, cNumPV, AllTrim(Str(0)), cTXT, nCount)
                EndIf

                If nC6UNSVEN<=0 .or. nC6QTDVEN<=0 .or. nC6PRCVEN<=0 .or. nC6PRUNIT<=0 .or. nC6VALOR<=0
                    lPVOk := .f.
                    GrvTRB(11, cNumPV, "C6UNSVEN+C6QTDVEN+C6PRCVEN+C6PRUNIT+C6VALOR", cTXT, nCount)
                EndIf

                //Populo TRBPV para execauto
                If lPVOk // variável para otimizar performance

                    RecLock("TRBPV", .T.)

                        TRBPV->C5_NUM      := cNumPV
                        TRBPV->C5_CLIENTE  := cCliCod
                        TRBPV->C5_LOJACLI  := cCliLoj
                        /*
                        TRBPV->C5_LATITUDE := nLatitude
                        TRBPV->C5_LOGITUDE := nLogitude
                        */
                        TRBPV->C5_CONDPAG  := SA1->A1_COND
                        TRBPV->C5_EMISSAO  := dEmissao
                        TRBPV->C5_DTENTR   := dEntrega
                        TRBPV->C5_MENNOTA  := cMsgNF
                        TRBPV->C5_PBRUTO   := nPBruto
                        TRBPV->C5_PESOL    := nPLiquido
                        TRBPV->C5_DESC1    := nDesc1
                        TRBPV->C5_VEND1    := SA1->A1_VEND

                        TRBPV->C6_ITEM     := nItem
                        TRBPV->C6_PRODUTO  := cCodPro
                        TRBPV->C6_UNSVEN   := nC6UNSVEN
                        TRBPV->C6_SEGUM    := c2UM
                        TRBPV->C6_QTDVEN   := nC6QTDVEN
                        TRBPV->C6_UM       := c1UM
                        TRBPV->C6_PRCVEN   := nC6PRCVEN
                        TRBPV->C6_PRUNIT   := nC6PRUNIT
                        TRBPV->C6_VALOR    := nC6VALOR
                        TRBPV->C6_DESCONT  := nC6DESCONT
                        TRBPV->C6_VALDESC  := nC6VALDESC
                        TRBPV->C6_ENTREG   := dIEntreg
              
                    TRBPV->( msUnLock() )

                EndIf
                
                aDadPV := {}
                
                ft_fSkip()
                
            EndDo
            
            TRB->( dbGoTop() )
            If TRB->( !EOF() )
                
                If msgYesNo("Consistência finalizada! Existem problemas nos dados que impediram a geração dos pedidos de vendas. Deseja listá-los agora?")
                    ReportXLSPV()
                EndIf
            
            Else

                u_GrLogZBE(msDate(), TIME(), cUserName, cRotina, "FATURAMENTO", "ARQUIVO " + cFile,;
                "ARQUIVO: " + cFile,;
                ComputerName(), LogUserName() )

                // Gero PV
                MyMata410()
            
                TRB->( dbGoTop() )
                If TRB->( !EOF() )

                    If msgYesNo("Pedidos de Vendas gerados com sucesso! Deseja emitir listagem para conferência?")
                        ReportXLSPV()
                    EndIf

                EndIf
            
            EndIf
            
        EndIf
        
    EndIf
    
Return

/*/{Protheus.doc} Static Function GrvTRB(1, G1_COD, cTXT, nLinha)
    Popula TRB para listagem
    @type  Static Function
    @author user
    @since 22/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GrvTRB(nTipo, cPV13, cKey, cTXT, nLinha)

    Local cStatus := ""
    
    Default nTipo  := 99
    Default cPV13  := ""
    Default cKey   := ""
    Default cTXT   := ""
    Default nLinha := 0

    If nTipo == 0
        cStatus := "PV ou Cliente ou Produto em branco - " + cKey

    ElseIf nTipo == 1
        cStatus := "PV já cadastrado - n. " + cKey

    ElseIf nTipo == 2
        cStatus := "Cliente não cadastrado - Código " + cKey
    ElseIf nTipo == 3
        cStatus := "Cliente bloqueado A1_MSBLQL - Código " + cKey

    ElseIf nTipo == 4
        cStatus := "Produto não cadastrado - Código " + cKey
    ElseIf nTipo == 5
        cStatus := "Produto bloqueado B1_MSBLQL - Código " + cKey

    ElseIf nTipo == 6
        cStatus := "Latitude e/ou Logitudo zerada "

    ElseIf nTipo == 7
        cStatus := "Data entrega do item inferior ou igual a data de hoje e/ou inferior a entrega contida no cabeçalho - " + cKey

    ElseIf nTipo == 8
        cStatus := "Emissão inferior a data de hoje - " + cKey

    ElseIf nTipo == 9
        cStatus := "Entrega inferior ou igual a data de hoje ou Entrega inferior ou igual a emissão - " + cKey

    ElseIf nTipo == 10
        cStatus := "Peso Bruto e/ou Líquido inválidos "

    ElseIf nTipo == 11
        cStatus := "Valores e/ou quantidades inválidos - " + cKey

    ElseIf nTipo == 200
        cStatus := "OK - PV incluído com sucesso - n. " + cKey

    EndIf

    RecLock("TRB", .T.)

        TRB->LINHA  := AllTrim(Str(nLinha))
        TRB->PEDIDO := cPV13
		TRB->STATUS := cStatus
		TRB->TXT    := cTXT

	TRB->( msUnLock() )
	
Return

/*/{Protheus.doc} Static Function ReportXLSPV
    Gera listagem de inconsistência
    @type  Static Function
    @author user
    @since 22/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ReportXLSPV()

	oReport := ReportDef(@cAliasTRB)
	oReport:PrintDialog()

Return

/*/{Protheus.doc} Static Function ReportDef
	ReportDef
	@type  Function
	@author Fernando Macieira
	@version 01
/*/
Static Function ReportDef(cAliasTRB)
                                   
	Local oReport
	Local oPedidos
	Local aOrdem := {}
	  
	Local cTitulo := "Pedidos Vendas - Log Conferência"

	cAliasTRB := "TRB"
	
	oReport := TReport():New(cRotina,OemToAnsi(cTitulo), /*cPerg*/, ;
	{|oReport| ReportPrint(cAliasTRB)},;
	OemToAnsi(" ")+CRLF+;
	OemToAnsi("")+CRLF+;
	OemToAnsi("") )

	oReport:nDevice     := 4 // XLS

	oReport:SetLandscape()
	//oReport:SetTotalInLine(.F.)
	
	oPedidos := TRSection():New(oReport, OemToAnsi(cTitulo),{"TRB"}, aOrdem /*{}*/, .F., .F.)
	//oReport:SetTotalInLine(.F.)
	TRCell():New(oPedidos,	"LINHA"      ,"","Linha"         /*Titulo*/,  /*Picture*/,10 /*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
	TRCell():New(oPedidos,	"PEDIDO"     ,"","Pedido"        /*Titulo*/,  /*Picture*/,20 /*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
	TRCell():New(oPedidos,	"STATUS"     ,"","Status"        /*Titulo*/,  /*Picture*/,100 /*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
	TRCell():New(oPedidos,	"TXT"        ,"","TXT"           /*Titulo*/,  /*Picture*/,254 /*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)

Return oReport

/*/{Protheus.doc} Static Function ReportPrint
	ReportPrint
	@type  Function
	@version 01
/*/
Static Function ReportPrint(cAliasTRB)

	Local oPedidos := oReport:Section(1)
	
	dbSelectArea("TRB")
	TRB->( dbSetOrder(1) )
	
	oPedidos:SetMeter( LastRec() )
	
	TRB->( dbGoTop() )
	Do While TRB->( !EOF() )
		
		oPedidos:IncMeter()
		
		oPedidos:Init()
		
		If oReport:Cancel()
			oReport:PrintText(OemToAnsi("Cancelado"))
			Exit
		EndIf
		
		//Impressao propriamente dita....
		oPedidos:Cell("LINHA")    :SetBlock( {|| TRB->LINHA} )
        oPedidos:Cell("PEDIDO")   :SetBlock( {|| TRB->PEDIDO} )
		oPedidos:Cell("STATUS")   :SetBlock( {|| TRB->STATUS} )
		oPedidos:Cell("TXT")      :SetBlock( {|| TRB->TXT} )

		oPedidos:PrintLine()
		oReport:IncMeter()
	
		TRB->( dbSkip() )
		
	EndDo
	
	oPedidos:Finish()

	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	EndIf
	
	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf
	
Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 22/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MyMata410()

    Local nOpcX      := 3                 //Seleciona o tipo da operacao (3-Inclusao / 4-Alteracao / 5-Exclusao)
    Local cF4TES     := SB1->B1_TS        //Codigo do TES
    Local aCabec     := {}
    Local aItens     := {}
    Local aLinha     := {}
    Local cPVDet     := ""
    Local nCount     := 0

    Private lMsErroAuto    := .F.
    Private lAutoErrNoFile := .F.  

    Begin Transaction
    
        If Select("Work") > 0
            Work->( dbCloseArea() )
        EndIf

        cQuery := " SELECT DISTINCT C5_NUM
        cQuery += " FROM TRBPV (NOLOCK)

        tcQuery cQuery new Alias "Work"

        Work->( dbGoTop() )
        Do While Work->( !EOF() )
            
            IncProc( "Gerando pedidos vendas... " + Work->C5_NUM )
            
            TRBPV->( dbSetOrder(1) )
            If TRBPV->( dbSeek(Work->C5_NUM) )
                
                nCount++
                cPVDet   := ""
                
                /*cDoc     := GetSxeNum("SC5", "C5_NUM")
                ConfirmSX8()*/
                cDoc     := _valNumC5() // CONTIDO DENTRO DO X3_RELACAO
                
                //****************************************************************
                //* INCLUSAO - INICIO
                //****************************************************************
                aCabec   := {}
                aItens   := {}
                aLinha   := {}
                aAdd(aCabec, {"C5_NUM"    , cDoc               , Nil})
                aAdd(aCabec, {"C5_EDI"    , Work->C5_NUM       , Nil})
                aAdd(aCabec, {"C5_TIPO"   , "N"                , Nil})
                aAdd(aCabec, {"C5_CLIENTE", TRBPV->C5_CLIENTE  , Nil})
                aAdd(aCabec, {"C5_LOJACLI", TRBPV->C5_LOJACLI  , Nil})
                aAdd(aCabec, {"C5_LOJAENT", TRBPV->C5_LOJACLI  , Nil})
                aAdd(aCabec, {"C5_CONDPAG", TRBPV->C5_CONDPAG  , Nil})             

                Do While TRBPV->C5_NUM == Work->C5_NUM
            
                    aLinha := {}
                    aadd(aLinha,{"LINPOS"    , "C6_ITEM", TRBPV->C6_ITEM})
                    aadd(aLinha,{"AUTDELETA" , "N"                 , Nil           })
                    aadd(aLinha,{"C6_PRODUTO", TRBPV->C6_PRODUTO   , Nil           })
                    aadd(aLinha,{"C6_QTDVEN" , TRBPV->C6_QTDVEN    , Nil           })
                    aadd(aLinha,{"C6_PRCVEN" , TRBPV->C6_PRCVEN    , Nil           })
                    aadd(aLinha,{"C6_PRUNIT" , TRBPV->C6_PRUNIT    , Nil           })
                    aadd(aLinha,{"C6_VALOR"  , TRBPV->C6_VALOR     , Nil           })
                    aadd(aLinha,{"C6_TES"    , cF4TES              , Nil           })
                    aadd(aItens, aLinha)

                    cPVDet += TRBPV->(C5_NUM+" / "+C6_ITEM+" - "+C6_PRODUTO)
                    
                    u_GrLogZBE(msDate(), TIME(), cUserName, cRotina, "FATURAMENTO", "PV N " + Work->C5_NUM,;
                    "ITEM/PRODUTO: " + TRBPV->(C6_ITEM+"/"+C6_PRODUTO),;
                    ComputerName(), LogUserName() )
            
                    TRBPV->( dbSkip() )

                EndDo

                lMsErroAuto    := .F.
                lAutoErrNoFile := .F.  

                msExecAuto({|a, b, c, d| MATA410(a, b, c, d)}, aCabec, aItens, nOpcX, .F.)

                If lMsErroAuto
                    DisarmTransaction()
                    MOSTRAERRO()
                    Break
                Else
                    GrvTRB(200, Work->C5_NUM, Work->C5_NUM, cPVDet, nCount)
                EndIf

            EndIf

            Work->( dbSkip() )
            
        EndDo

    End Transaction

Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 22/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function lExistPV(cNumPV)

    Local lExist := .f.
    Local cQuery := ""

    If Select("WorkEDI") > 0
        WorkEDI->( dbCloseArea() )
    EndIf

    cQuery := " SELECT TOP 1 C5_FILIAL, C5_NUM
    cQuery += " FROM " + RetSqlName("SC5") + " (NOLOCK)
    cQuery += " WHERE C5_FILIAL='"+FWxFilial("SC5")+"' 
    cQuery += " AND C5_EDI='"+cNumPV+"' 
    cQuery += " AND D_E_L_E_T_=''

    tcQuery cQuery New Alias "WorkEDI"

    WorkEDI->( dbGoTop() )
    If WorkEDI->( !EOF() )
        lExist := .t.
    EndIf

    If Select("WorkEDI") > 0
        WorkEDI->( dbCloseArea() )
    EndIf
    
Return lExist
