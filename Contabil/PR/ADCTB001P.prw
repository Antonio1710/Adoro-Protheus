#include "protheus.ch"
#include "topconn.ch"

#DEFINE  ENTER 		Chr(13)+Chr(10)

/*/{Protheus.doc} User Function ADCTB001P
    Rotina para bloquear produtos que não tiveram utilização nos últimos 6 meses
    @type  Function
    @author Fernando Macieira
    @since 15/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @ticket 93078
/*/
User Function ADCTB001P()

	Local cKeyBloq := "ADCTB001P" + AllTrim(FWCodEmp())
    Local bProcess := { |oSelf| RunPainel(oSelf) }
	Local cDescri  := "Rotina para bloquear produtos que não tiveram utilização nos últimos 6 meses!" + ENTER + ENTER +;
	" "

	Private cTitulo  := "Bloqueio de produtos "
	Private oProcess
    Private cAliasTRB := ""

	// Garanto uma única thread sendo executada
	If !LockByName(cKeyBloq, .T., .F.)
		msgAlert("Existe outro processamento sendo executado nesta empresa! " + chr(13)+chr(10) + "Aguarde ou peça para seu colega de trabalho encerrar! Esta rotina será desconectada...")
		KillApp(.T.)
        Return
	EndIf

    oProcess := tNewProcess():New("PAINEL",cTitulo,bProcess,cDescri,/*cPerg*/,, .T.,5, "RUNPAINEL", .T.)

	//Destrava a rotina para o usuário
	UnLockByName(cKeyBloq)

Return

/*/{Protheus.doc} nomeStaticFunction
    Tabelas SD1, SD2, SD3, SC6, SC7, SCP, SC1
    @type  Static Function
    @author user
    @since 15/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function RunPainel(oProcess)

    Local cQuery  := ""
    Local dDtIni  := msDate()-180
    Local aCampos := {}
    Local oTempXLS, oTempTRB
    Local nAtual  := 0
    Local nTotal  := 0

    Local lUsrAut  := GetMV("MV_#USROFF",,.T.) // Ativa controle de usuarios autorizados
    Local cUsrAut  := GetMV("MV_#USRAUT",,"001428|02362") // Usuarios autorizados "DANIELLE_MEIRA|DYANE_SILVA"

    If msgYesNo("Confirma processamento do bloqueio dos produtos?")

        // Checo login autorizado
        If lUsrAut
            If !(RetCodUsr() $ cUsrAut)
                Aviso("MV_#USRAUT", "Usuário não autorizado para utilizar esta rotina!", {"OK"}, 3)
                Return			
            EndIf
        EndIf

        // Checo compartilhamento entre empresas da SB1
        If !X2SB1OK()
            Return
        EndIf

        oProcess:SetRegua1( 0 )
        oProcess:IncRegua1( " Bloqueando produtos que não tiveram utilização nos últimos 6 meses... " )

        oProcess:SetRegua2( 0 )

        // Crio TRB para impressão
        If Select("TRBXLS") > 0
            TRBXLS->( dbCloseArea() )
        EndIf
            
        // https://tdn.totvs.com.br/display/framework/FWTemporaryTable
        oTempXLS := FWTemporaryTable():New("TRBXLS")
        
        // Arquivo TRBXLS
        aCampos := {}
        aAdd( aCampos, {'B1_COD'    ,TamSX3("B1_COD")[3]     ,TamSX3("B1_COD")[1]     , 0} )
        aAdd( aCampos, {'B1_DESC'   ,TamSX3("B1_DESC")[3]    ,TamSX3("B1_COD")[1]+50  , 0} )

        oTempXLS:SetFields(aCampos)
        oTempXLS:AddIndex("01", {"B1_COD"} )
        oTempXLS:Create()


        // Crio TRB para varredura
        If Select("TRB") > 0
            TRB->( dbCloseArea() )
        EndIf
            
        // https://tdn.totvs.com.br/display/framework/FWTemporaryTable
        oTempTRB := FWTemporaryTable():New("TRB")
        
        // Arquivo TRB
        aCampos := {}
        aAdd( aCampos, {'B1_COD'    ,TamSX3("B1_COD")[3]     ,TamSX3("B1_COD")[1]     , 0} )
        
        oTempTRB:SetFields(aCampos)
        oTempTRB:AddIndex("01", {"B1_COD"} )
        oTempTRB:Create()

        
        // Seleciono produtos utilizados nestes últimos 6 meses e com saldo diferente de zero
        If Select("Work") > 0
            Work->( dbCloseArea() )
        EndIf

        // SD1
        cQuery := " SELECT DISTINCT D1_COD PRODUTO
        cQuery += " FROM " + RetSqlName("SD1") + " (NOLOCK)
        cQuery += " WHERE D1_FILIAL BETWEEN '' AND 'ZZ'
        cQuery += " AND D1_DTDIGIT>='"+DtoS(dDtIni)+"' 
        cQuery += " AND D_E_L_E_T_=''
        
        cQuery += " UNION

        // SD2
        cQuery += " SELECT DISTINCT D2_COD PRODUTO
        cQuery += " FROM " + RetSqlName("SD2") + " (NOLOCK)
        cQuery += " WHERE D2_FILIAL BETWEEN '' AND 'ZZ'
        cQuery += " AND D2_EMISSAO>='"+DtoS(dDtIni)+"' 
        cQuery += " AND D_E_L_E_T_=''

        cQuery += " UNION

        // SD3
        cQuery += " SELECT DISTINCT D3_COD PRODUTO
        cQuery += " FROM " + RetSqlName("SD3") + " (NOLOCK)
        cQuery += " WHERE D3_FILIAL BETWEEN '' AND 'ZZ'
        cQuery += " AND D3_EMISSAO>='"+DtoS(dDtIni)+"' 
        cQuery += " AND D_E_L_E_T_=''

        cQuery += " UNION

        // SC6
        cQuery += " SELECT DISTINCT C6_PRODUTO PRODUTO
        cQuery += " FROM " + RetSqlName("SC6") + " (NOLOCK)
        cQuery += " WHERE C6_FILIAL BETWEEN '' AND 'ZZ'
        cQuery += " AND C6_ENTREG>='"+DtoS(dDtIni)+"' 
        cQuery += " AND D_E_L_E_T_=''

        cQuery += " UNION

        // SC7
        cQuery += " SELECT DISTINCT C7_PRODUTO PRODUTO
        cQuery += " FROM " + RetSqlName("SC7") + " (NOLOCK)
        cQuery += " WHERE C7_FILIAL BETWEEN '' AND 'ZZ'
        cQuery += " AND C7_EMISSAO>='"+DtoS(dDtIni)+"' 
        cQuery += " AND D_E_L_E_T_=''

        cQuery += " UNION

        // SCP
        cQuery += " SELECT DISTINCT CP_PRODUTO PRODUTO
        cQuery += " FROM " + RetSqlName("SCP") + " (NOLOCK)
        cQuery += " WHERE CP_FILIAL BETWEEN '' AND 'ZZ'
        cQuery += " AND CP_EMISSAO>='"+DtoS(dDtIni)+"' 
        cQuery += " AND D_E_L_E_T_=''

        cQuery += " UNION

        // SC1
        cQuery += " SELECT DISTINCT C1_PRODUTO PRODUTO
        cQuery += " FROM " + RetSqlName("SC1") + " (NOLOCK)
        cQuery += " WHERE C1_FILIAL BETWEEN '' AND 'ZZ'
        cQuery += " AND C1_EMISSAO>='"+DtoS(dDtIni)+"' 
        cQuery += " AND D_E_L_E_T_=''
        
        cQuery += " ORDER BY 1

        tcQuery cQuery New Alias "Work"

        Work->( dbGoTop() )
        Do While Work->( !EOF() )

            oProcess:IncRegua1("Analisando produtos utilizados e com saldo...")
            oProcess:IncRegua2("Produto " + AllTrim(Work->PRODUTO) )

            RecLock("TRB", .T.)
                TRB->B1_COD := Work->PRODUTO
            TRB->( msUnLock() )

            Work->( dbSkip() )

        EndDo

        If Select("Work") > 0
            Work->( dbCloseArea() )
        EndIf


        // Varrendo cadastro produtos para bloquear
        nTotal := 0
        SB1->( dbEval( { || nTotal++ },,{ || !EOF() } ) )

        SB1->( dbGoTop() )
        Do While SB1->( !EOF() )

            nAtual++

            // já Bloqueado
            If AllTrim(SB1->B1_MSBLQL) == "1"
                SB1->( dbSkip() )
                Loop
            EndIf

            oProcess:IncRegua1("Processamento em "+cValToChar(Int(nAtual/nTotal*100))+"% de "+cValToChar(nTotal)+" registros")

            If TRB->( !dbSeek(SB1->B1_COD) )

                If AllB2Zero()

                    oProcess:IncRegua2("Bloqueando produto " + AllTrim(SB1->B1_COD) + " - " + SB1->B1_DESC )

                    RecLock("SB1", .F.)
                        SB1->B1_MSBLQL := "1" // Bloqueado
                    SB1->( msUnLock() )

                    // Incluo no XLS para listagem posterior
                    RecLock("TRBXLS", .T.)
                        TRBXLS->B1_COD  := SB1->B1_COD
                        TRBXLS->B1_DESC := SB1->B1_DESC
                    TRBXLS->( msUnLock() )

                    // Log ZBE
                    u_GrLogZBE(msDate(),TIME(),cUserName,"Bloqueio de produtos que nao tiveram utilizacao nos ultimos 6 meses ou saldo zero","CONTABILIDADE","ADCTB001P",;
                    "PRODUTO: "+SB1->B1_COD+" DESCRICAO: "+SB1->B1_DESC,ComputerName(),LogUserName())

                    //Exit // apenas debug
                
                EndIf

            EndIf

            SB1->( dbSkip() )

        EndDo

        // lista produtos bloqueados
        TRBXLS->( dbGoTop() )
        If TRBXLS->( !EOF() )
            
            If msgYesNo("Consistência finalizada! Deseja listar produtos que foram bloqueados?")
                ReportXLSTAB()
            EndIf

        EndIf

    EndIf
    
Return

/*/{Protheus.doc} Static Function ReportXLSTAB
    Gera listagem de inconsistência
    @type  Static Function
    @author user
    @since 01/06/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ReportXLSTAB()

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
	Local oProdutos
	Local aOrdem := {}
	  
	cAliasTRB := "TRBXLS"
	
	oReport := TReport():New("BLOQUEADOS",OemToAnsi(cTitulo), /*cPerg*/, ;
	{|oReport| ReportPrint(cAliasTRB)},;
	OemToAnsi(" ")+CRLF+;
	OemToAnsi("")+CRLF+;
	OemToAnsi("") )

	oReport:nDevice     := 4 // XLS

	oReport:SetLandscape()
	//oReport:SetTotalInLine(.F.)
	
	oProdutos := TRSection():New(oReport, OemToAnsi(cTitulo),{"TRBXLS"}, aOrdem /*{}*/, .F., .F.)
	//oReport:SetTotalInLine(.F.)
	TRCell():New(oProdutos,	"B1_COD"    ,"","Produto"        /*Titulo*/,  /*Picture*/,TamSX3("B1_COD")[1] /*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
	TRCell():New(oProdutos,	"B1_DESC"   ,"","Descrição"      /*Titulo*/,  /*Picture*/,TamSX3("B1_DESC")[1]+50 /*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)

Return oReport

/*/{Protheus.doc} Static Function ReportPrint
	ReportPrint
	@type  Function
	@version 01
/*/
Static Function ReportPrint(cAliasTRB)

	Local oProdutos := oReport:Section(1)
	
	dbSelectArea("TRBXLS")
	TRBXLS->( dbSetOrder(1) )
	
	oProdutos:SetMeter( LastRec() )
	
	TRBXLS->( dbGoTop() )
	Do While TRBXLS->( !EOF() )
		
		oProdutos:IncMeter()
		
		oProdutos:Init()
		
		If oReport:Cancel()
			oReport:PrintText(OemToAnsi("Cancelado"))
			Exit
		EndIf
		
		//Impressao propriamente dita....
        oProdutos:Cell("B1_COD")   :SetBlock( {|| TRBXLS->B1_COD} )
		oProdutos:Cell("B1_DESC")  :SetBlock( {|| TRBXLS->B1_DESC} )

		oProdutos:PrintLine()
		oReport:IncMeter()
	
		TRBXLS->( dbSkip() )
		
	EndDo
	
	oProdutos:Finish()

	If Select("TRBXLS") > 0
		TRBXLS->( dbCloseArea() )
	EndIf
	
	If Select("QRY") > 0
		QRY->( dbCloseArea() )
	EndIf
	
	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf
	
Return

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 16/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function AllB2Zero()

    Local lRet   := .t.
    Local cQuery := ""

    If Select("WorkB2") > 0
        WorkB2->( dbCloseArea() )
    EndIf

    // checo se tem algum almoxarifado com saldo diferente de zero
    cQuery := " SELECT TOP 1 B2_COD
    cQuery += " FROM " + RetSqlName("SB2") + " (NOLOCK)
    cQuery += " WHERE B2_FILIAL BETWEEN '' AND 'ZZ'
    cQuery += " AND B2_COD='"+SB1->B1_COD+"'
    cQuery += " AND B2_QATU<>0
    cQuery += " AND D_E_L_E_T_=''

    tcQuery cQuery New Alias "WorkB2"

    WorkB2->( dbGoTop() )
    If WorkB2->( !EOF() )
        lRet := .f. // possui algum almoxarifado com saldo, então não pode bloquear
    EndIf

    If Select("WorkB2") > 0
        WorkB2->( dbCloseArea() )
    EndIf

Return lRet

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 18/05/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function X2SB1OK()
    
    Local lRet   := .t.
    Local cQuery := ""
    Local cX2Arq := ""

    If Select("WorkX2") > 0
        WorkX2->( dbCloseArea() )
    EndIf

    cQuery := " SELECT X2_ARQUIVO 
    cQuery += " FROM " + RetSqlName("SX2") + " (NOLOCK)
    cQuery += " WHERE X2_CHAVE='SB1'
    cQuery += " AND D_E_L_E_T_=''

    tcQuery cQuery New Alias "WorkX2"

    WorkX2->( dbGoTop() )
    If WorkX2->( !EOF() )
        cX2Arq := AllTrim(WorkX2->X2_ARQUIVO)
    EndIf

    If Select("WorkX2") > 0
        WorkX2->( dbCloseArea() )
    EndIf

    If SubStr(cX2Arq,4,2) <> AllTrim(FWCodEmp())
        lRet := .f.
        Alert("O cadastro de produtos desta empresa " + AllTrim(FWCodEmp()) + " está compartilhado com a empresa " + SubStr(cX2Arq,4,2) + "! Processe essa rotina na empresa " + SubStr(cX2Arq,4,2) + " ...")
    EndIf

Return lRet
