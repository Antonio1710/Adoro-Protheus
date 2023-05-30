#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'
#DEFINE  ENTER 		Chr(13)+Chr(10)
//-------------------------------------------------------------------
/*/{Protheus.doc} ADFAT062P
Meta Mensal do Mes

@author Antonio Domingos
@since 06/10/2022
@version P10
@history Ticket 8122  - 06/10/2022 - Antonio Domingos - Otimização do processo de Importação de Meta


/*/
//-------------------------------------------------------------------
User Function CADZZT()

    Private oBrowse
       
    SetFunName("ADFAT062P")
     
oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'ZZT' )
oBrowse:SetDescription( ' Mensal Metas Vendas' )
oBrowse:AddButton("Imp.Automatica",{|| MsAguarde({|| FAT062A(oBrowse) },'Importando...')  },,9,,.F.)
oBrowse:AddButton("Rec.MT Periodo",{|| MsAguarde({|| FAT062B(oBrowse) },'Recalculando ...')  },,9,,.F.)
oBrowse:Activate()


Return NIL


//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.ADFAT062P' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.ADFAT062P' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.ADFAT062P' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.ADFAT062P' OPERATION 5 ACCESS 0 
ADD OPTION aRotina Title 'Imprimir'    Action 'VIEWDEF.ADFAT062P' OPERATION 8 ACCESS 0

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZZT := FWFormStruct( 1, 'ZZT', /*bAvalCampo*/, /*lViewUsado*/ )
//Local oStruZVD := FWFormStruct( 1, 'ZVD', /*bAvalCampo*/, /*lViewUsado*/ )
Local bVldPos    := {|oModel| VldTudoOk(oModel)  }
Local oModel

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'FAT062M', /*bPreValidacao*/, bVldPos /*FAT062POS( oModel )*/, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZZTMASTER', /*cOwner*/, oStruZZT )

oModel:SetPrimaryKey( { "ZZT_FILIAL", "ZZT_VENDED", "ZZT_SUPERV" ,"ZZT_GRUPO" } ) 

// Adiciona ao modelo uma estrutura de formulário de edição por grid
//oModel:AddGrid( 'ZVDDETAIL', 'ZZTMASTER', oStruZVD, /*bLinePre*/, /*bLinePost*/, /*bVldPos*/, /*BLoad*/ )
 
// Indica que é opcional ter dados informados na Grid
//oModel:GetModel('ZVDDETAIL'):SetOptional(.T.)
//oModel:GetModel("ZVDDETAIL"):SetNoInsertLine(.T.)
//oModel:GetModel("ZVDDETAIL"):SetNoDeleteLine(.T.)

// Faz relaciomaneto entre os compomentes do model
//oModel:SetRelation( 'ZVDDETAIL', { { 'ZVD_FILIAL', 'xFilial( "ZVD" )' }, { 'ZVD_CPFMOT', 'ZZT_CPF' } }, ZVD->( IndexKey( 1 ) ) )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( ' Mensal Metas Vendas' )

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'ZZTMASTER' ):SetDescription( 'Metas Vendas' )
//oModel:GetModel( 'ZVDDETAIL' ):SetDescription( 'Historico Placa Transportadora'  )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oStruZZT := FWFormStruct( 2, 'ZZT' )
//Local oStruZVD := FWFormStruct( 2, 'ZVD' )
// Cria a estrutura a ser usada na View
Local oModel   := FWLoadModel( 'ADFAT062P' )
Local oView

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_ZZT', oStruZZT, 'ZZTMASTER' )

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
//oView:AddGrid(  'VIEW_ZVD', oStruZVD, 'ZVDDETAIL' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 100 )
//oView:CreateHorizontalBox( 'INFERIOR', 40 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZZT', 'SUPERIOR' )
//oView:SetOwnerView( 'VIEW_ZVD', 'INFERIOR' )

// Liga a identificacao do componente
//oView:EnableTitleView('VIEW_ZVD','Historico de Placas')

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} VldTudoOk()
Inclui dados do  de Metas de venda.
Quando há alteração nos campos de  de metas de venda.
@author Antonio Domingos
@since 06/09/2022
@version P10
@history Ticket 8122 - 06/10/2022 - Antonio Domingos - Otimização do processo de Importação de Meta
/*/

//-------------------------------------------------------------------
Static Function VldTudoOk(oModel)
Local lRet       := .T.
Local aArea      := GetArea()
Local aAreaZZT   := ZZT->( GetArea() )
//Local oModel := FWModelActive()
Local nOperation := oModel:GetOperation()
Local cMesVen  := oModel:GetValue("ZZTMASTER", "ZZT_MESVEN")
Local dData    := oModel:GetValue("ZZTMASTER", "ZZT_DATA")

If nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE
	If cMesVen == ' ' .or. dtos(dData) = ' ' 
		Help(Nil, Nil, "VldTudoOk(ADFAT062P) Msg-01",,"Mes e Data Obrigatorio!", 1, 0 )
		lRet := .F.
	EndIf
EndIf

RestArea( aAreaZZT )
RestArea( aArea )

Return lRet

/*/{Protheus.doc} User Function ADCON019P
    Cria Estrutura de  de Metas de Vendas a partir de um arquivo excel
    @type  Function
    @author Antonio Domingos
    @since 07/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history ticket 8122 - 07/10/2022 - Antonio Domingos - Otimização do processo de Importação de Meta
/*/
Static Function FAT062A(oBrowse)
    Local bProcess 		:= {|oSelf| Executa(oSelf) }
    Local lOk		:= .F.
    Local alSay		:= {}
    Local alButton	:= {}
    Local clTitulo	:= 'IMPORTAÇÃO Estrutura  de Mensal Metas de Vendas - ZZT'
    Local clDesc1   := 'O objetivo desta rotina é criar/alterar a tab. Mensal Metas de Vendas. Arq.TXT.'
    Local clDesc2   := 'Regras:'
    Local clDesc3   := '- Incluirá um  de Meta qdo não existir o cadastro na tabela (ZZT);'
    Local clDesc4   := '- substituirá a Meta quando a coluna Meta estiver preenchida;'
    Local clDesc5   := '- Estrutura: vend;grp;periodo;data;s/n;volmet'
    Local cPerg     := ""
	Local aInfoCustom 	:= {}

    Private cAliasTRB := ""

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
        oProcess := tNewProcess():New("ImpADFAT062","Criando Metas de Vendas.",bProcess,clTitulo,cPerg,aInfoCustom, .T.,5, "ImpMetas.", .T. )
    EndIf
   
    oBrowse:Refresh()

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cria Estrutura de Metas de Vendas a partir de um excel')

Return

/*/{Protheus.doc} Static Function RUNADFAT062
    Importação do  Mensal de Vendas
    @type  Static Function
    @author Antonio Domingos
    @since 07/10/2022 
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history ticket  8122  - Antonio Domingos - 07/10/2022 - Otimização do processo de Importação de Meta
/*/
Static Function Executa(oProcess)

    Local lFile      := .f.
    Local cTxt       := ""
    Local _nCountZZT := 0
    Local aDadZZT    := {}
    Local aCampos    := {}

    //oView:GetModel("ZZTMASTER")

	cFile := cGetFile("Arquivos TXT (Separados por Vírgula) | *.TXT",;
    ("Selecione o diretorio onde encontra-se o arquivo a ser processado"), 0, "Servidor\", .t., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE)// + GETF_RETDIRECTORY)

    If At(".TXT", upper(cFile)) > 0
        lFile := .t.
        ft_fUse(cFile)
    Else
        Aviso("ADFAT062-01", "Não foi possível abrir o arquivo...", {"&Ok"},, "Arquivo não identificado!")
    EndIf

    // Arquivo TXT
    If lFile
        
        ft_fGoTop()
        
        oProcess:SetRegua1(ft_fLastRec())  

        cVerTab := "vend;grp;periodo;data;s/n;volmet "

        cTxt := AllTrim(ft_fReadLn())
        
        If cVerTab <> cTXT
            
            Aviso("ADFAT062-02", "A importação não será realizada! As colunas do excel precisam ser " + cVerTab, {"&Ok"},, "Versão/Leiaute da planilha incorreta!")
            
        Else

            If Select("TRB") > 0
                TRB->( dbCloseArea() )
            EndIf
            
            // Crio TRB para impressão
            // https://tdn.totvs.com.br/display/framework/FWTemporaryTable
            oTempTable := FWTemporaryTable():New("TRB")
            
            // Arquivo TRB
            aCampos := {}

			aAdd( aCampos, {'CODIGO',"C",06, 0} )
            aAdd( aCampos, {'STATUS',"C",40, 0} )
            aAdd( aCampos, {'LINHA' ,"C",250, 0} )

			oTempTable:SetFields(aCampos)
            oTempTable:AddIndex("01", {"CODIGO"} )
            oTempTable:Create()
            
            ft_fSkip() // Pula linha do cabeçalho       

            // Consistência
            Do While !ft_fEOF()
                
                oProcess:IncRegua1("Consistindo TXT..."+StrZero(_nCountZZT++, 9))  

                cTxt    := ft_fReadLn()
                aDadZZT := Separa(cTxt, ";")
                
                //vend;grp;periodo;data;s/n;volmet 
                //ZZT_VENDED	ZZT_GRUPO	ZZT_PERIOD ZZT_DATA  ZZT_ENTREG	ZZT_METDIA
			    cZZT_VENDED  := PadR( AllTrim(aDadZZT[1]), TAMSX3("ZZT_VENDED")[1] )
                cZZT_GRUPO   := PadR( AllTrim(aDadZZT[2]), TAMSX3("ZZT_GRUPO")[1] )
                cZZT_PERIOD  := PadR( AllTrim(aDadZZT[3]), TAMSX3("ZZT_PERIOD")[1] )
                dZZT_DATA    := CTOD(AllTrim(aDadZZT[4]))
                cZZT_ENTREG  := PadR( AllTrim(aDadZZT[5]), TAMSX3("ZZT_ENTREG")[1] )
                //nZZT_METDIA  := Val(StrTran(AllTrim(aDadZZT[6]),",","."))

                //Validando Vendedor
				SA3->( dbSetOrder(1) ) // A3_FILIAL, A3_COD, R_E_C_N_O_, D_E_L_E_T_
                If SA3->( !dbSeek(FWxFilial("SA3")+cZZT_VENDED) )
                    GrvTRB(1, cZZT_VENDED, cTXT)
                Else
                    If AllTrim(SA3->A3_MSBLQL) == "1"
                        GrvTRB(2, cZZT_VENDED, cTXT)
                    EndIf
                EndIf

                //Validando Grupo do SKU
				SBM->( dbSetOrder(1) ) // BM_FILIAL, BM_COD, R_E_C_N_O_, D_E_L_E_T_
                If SBM->( !dbSeek(FWxFilial("SBM")+cZZT_GRUPO) )
                    GrvTRB(3, cZZT_GRUPO, cTXT)
                EndIf

                aDadZZT := {}
                
                ft_fSkip()
                
            EndDo
            
            TRB->( dbGoTop() )
            If TRB->( !EOF() )

                If msgYesNo("Consistência finalizada! Existem problemas nos dados que impediram a geração da estrutura. Deseja listá-las agora?")
                    ReportZZT("TRB")
                EndIf
            
            Else

                _nCountZZT  := 0
                aDadZZT     := {}

                ft_fGoTop()
                oProcess:SetRegua1(ft_fLastRec())      
                
                ft_fSkip() // Pula linha do cabeçalho       

                // Geração ZZT
                Do While !ft_fEOF()
                    
                    cTxt    := ft_fReadLn()
                    aDadZZT := Separa(cTxt, ";")

                    oProcess:IncRegua1("Importando Meta Venda..."+PadR( AllTrim(aDadZZT[2]), TAMSX3("ZZT_GRUPO")[1] ))  

					//vend;grp;periodo;data;s/n;volmet 
                    //ZZT_VENDED	ZZT_GRUPO	ZZT_DATA ZZT_PERIOD	ZZT_METDIA
                    cZZT_VENDED  := PadR( AllTrim(aDadZZT[1]), TAMSX3("ZZT_VENDED")[1] )
                    cZZT_GRUPO   := PadR( AllTrim(aDadZZT[2]), TAMSX3("ZZT_GRUPO")[1] )
                    cZZT_PERIOD  := PadR( AllTrim(aDadZZT[3]), TAMSX3("ZZT_PERIOD")[1] )
                    dZZT_DATA    := CTOD(AllTrim(aDadZZT[4]))
                    cZZT_ENTREG  := PadR( AllTrim(aDadZZT[5]), TAMSX3("ZZT_ENTREG")[1] )
                    //nZZT_METDIA  := Val(StrTran(AllTrim(aDadZZT[6]),",","."))

                    lLockZZT := .t.
                    If !Empty(cZZT_VENDED)
                        ZZT->( dbSetOrder(6) ) // ZZT_FILIAL+ZZT_VENDED+ZZT_GRUPO+ZZT_PERIOD+DTOS(ZZT_DATA)
                        If ZZT->( dbSeek(FWxFilial("ZZT")+cZZT_VENDED+cZZT_GRUPO+cZZT_PERIOD+DTOS(dZZT_DATA)) )
                            lLockZZT := .f.
                        EndIf
                    EndIf
	
                    If lLockZZT
                        nTipo := 4
                    else
                        nTipo := 5
                    EndIf                        
                    //ZZT_FILIAL	ZZT_VENDED	ZZT_NOMVEN	ZZT_GRUPO	ZZT_NOMGRU	ZZT_DATA	ZZT_VALOR	ZZT_PESMET	D_E_L_E_T_	R_E_C_N_O_	ZZT_USERGI	ZZT_USERGA	ZZT_SUPERV	ZZT_PERIOD	ZZT_ENTREG	ZZT_METDIA
                    RecLock("ZZT", lLockZZT)
						If lLockZZT
							ZZT->ZZT_FILIAL	:= FWxFilial("ZZT")
							ZZT->ZZT_VENDED	:= cZZT_VENDED
                            ZZT->ZZT_GRUPO	:= cZZT_GRUPO
                            ZZT->ZZT_DATA   := dZZT_DATA 	
							ZZT->ZZT_PERIOD := cZZT_PERIOD 	
                        EndIf
						ZZT->ZZT_NOMVEN := Posicione("SA3",1,xFilial("SA3")+cZZT_VENDED,"A3_NOME")
						ZZT->ZZT_NOMGRU := Posicione("SBM",1,xFilial("SBM")+cZZT_GRUPO,"BM_DESC")
						ZZT->ZZT_SUPERV := Posicione("SA3",1,xFilial("SA3")+cZZT_VENDED,"A3_CODSUP")
                        ZZT->ZZT_ENTREG := cZZT_ENTREG
                        //ZZT->ZZT_METDIA	:= nZZT_METDIA
					ZZT->( msUnLock() )

                    GrvTRB(nTipo, cZZT_VENDED, cTXT)

                    aDadZZT := {}
                    
                    ft_fSkip()
                    
                EndDo
                
                ZZT->(dbSetOrder(1))    
				ZZT->(DbGotop())
                
                TRB->( dbGoTop() )
                If TRB->( !EOF() )

                    If msgYesNo("Importação finalizada com sucesso! Deseja listar o log de inclusão/alteração agora?")
                        ReportZZT("TRB")
                    EndIf
                    
                EndIf
            EndIf

        EndIf
    EndIf    
Return

/*/{Protheus.doc} Static Function GrvTRB(1, cCodigo, cTXT)
    Popula TRB para listagem
    @type  Static Function
    @author Antonio Domingos
    @since 07/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function GrvTRB(nTipo, cCodigo, cTXT)

    Local cStatus := ""

    If nTipo == 1
        cStatus := "Vendedor não cadastrado"
    ElseIf nTipo == 2
        cStatus := "Vendedor bloqueado A3_MSBLQL"
    ElseIf nTipo == 3
        cStatus := "Grupo SKU não cadastrado"
    ElseIf nTipo == 4
        cStatus := "Registro incluido"
    ElseIf nTipo == 5
        cStatus := "Registro alterado"
    EndIf

    RecLock("TRB", .T.)

	    TRB->CODIGO  := cCodigo
		TRB->STATUS  := cStatus
		TRB->LINHA   := cTXT

	TRB->( msUnLock() )
	
Return

/*/{Protheus.doc} Static Function ReportZZT
    Gera listagem de inconsistência
    @type  Static Function
    @author Antonio Domingos
    @since 07/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function ReportZZT(cAliasTRB)

	oReport := ReportDef(@cAliasTRB)
	oReport:PrintDialog()

Return

/*/{Protheus.doc} Static Function ReportDef
	ReportDef
	@type  Function
	@author Antonio Domingos
	@version 01
/*/
Static Function ReportDef(cAliasTRB)
                                   
	Local oReport
	Local oProdutos
	Local aOrdem  := {}
	Local cTitulo := "Estruturas de Meta de Vendas - Inconsistências"

	cAliasTRB := "TRB"
	
	oReport := TReport():New("ADFAT062",OemToAnsi(cTitulo), /*cPerg*/, ;
	{|oReport| ReportPrint(cAliasTRB)},;
	OemToAnsi(" ")+ENTER+;
	OemToAnsi("")+ENTER+;
	OemToAnsi("") )

	oReport:nDevice     := 4 // XLS

	oReport:SetLandscape()
	//oReport:SetTotalInLine(.F.)
	
	oProdutos := TRSection():New(oReport, OemToAnsi(cTitulo),{"TRB"}, aOrdem /*{}*/, .F., .F.)
	//oReport:SetTotalInLine(.F.)
	
	TRCell():New(oProdutos,	"Codigo"     ,"","Codigo"        /*Titulo*/,  /*Picture*/,6 /*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
	TRCell():New(oProdutos,	"STATUS"     ,"","Status"         /*Titulo*/,  /*Picture*/,40/*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)
	TRCell():New(oProdutos,	"LINHA"      ,"","Linha"          /*Titulo*/,  /*Picture*/,100 /*Tamanho*/,/*lPixel*/,/*{|| bloco-de-impressao }*/)

Return oReport

/*/{Protheus.doc} Static Function ReportPrint
	ReportPrint
	@type  Function
	@version 01
/*/
Static Function ReportPrint(cAliasTRB)

	Local oProdutos := oReport:Section(1)
	
	dbSelectArea("TRB")
	TRB->( dbSetOrder(1) )
	
	oProdutos:SetMeter( LastRec() )
	
	TRB->( dbGoTop() )
	Do While TRB->( !EOF() )
		
		oProdutos:IncMeter()
		
		oProdutos:Init()
		
		If oReport:Cancel()
			oReport:PrintText(OemToAnsi("Cancelado"))
			Exit
		EndIf
		
		//Impressao propriamente dita....
		oProdutos:Cell("CODIGO")    :SetBlock( {|| TRB->CODIGO} )
		oProdutos:Cell("STATUS")    :SetBlock( {|| TRB->STATUS} )
		oProdutos:Cell("LINHA")     :SetBlock( {|| TRB->LINHA} )

		oProdutos:PrintLine()
		oReport:IncMeter()
	
		TRB->( dbSkip() )
		
	EndDo
	
	oProdutos:Finish()

	If Select("TRB") > 0
		TRB->( dbCloseArea() )
	EndIf
	
	//oTempTable:Delete()  

Return

/*/{Protheus.doc} User Function FAT062B(oBrowse)
    recalcular as Metas de Vendas
    @type  Function
    @author Antonio Domingos
    @since 07/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history ticket 8122 - 07/10/2022 - Antonio Domingos - Otimização do processo de Importação de Meta
/*/
Static Function FAT062B(oBrowse)
    Local bProcess 		:= {|oSelf| fRecMetDia(oSelf) }
    Local lOk		:= .F.
    Local alSay		:= {}
    Local alButton	:= {}
    Local clTitulo	:= 'Recalculo de Metas de Vendas'
    Local clDesc1   := 'O objetivo desta rotina é recalcular as Metas de Vendas.'
    Local clDesc2   := 'Regras:'
    Local clDesc3   := '- Incluirá um  de Meta qdo não existir o cadastro na tabela (ZZT);'
    Local clDesc4   := '- substituirá a Meta quando a coluna Meta Dia estiver preenchida;'
    Local clDesc5   := ''
    Local cPerg     := ""
	Local aInfoCustom 	:= {}

    Private cAliasTRB := ""

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
        oProcess := tNewProcess():New("fRecMetDia","Criando Metas de Vendas.",bProcess,clTitulo,cPerg,aInfoCustom, .T.,5, "ImpMetas.", .T. )
    EndIf
   
    oBrowse:Refresh()

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cria Estrutura de Metas de Vendas a partir de um excel')

Return

/*/{Protheus.doc} fRecMetDia(oBrowse)
    Executa Função que Recalcula Meta Dia.
    @type  Static Function
    @author Antonio Domingos
    @since 11/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function fRecMetDia(oProcess)
    
Local _aAtuArea   := GetArea()
Local _aZVFArea   := ZVF->(GetArea())
Local _nCountZZT  := 0
Local _cQuery := " "
Private aParamBox := {}
Private aRet      := {}

    Aadd( aParamBox ,{1,"Vendedor De "    ,Space(6),"" ,'.T.',"SA3",'.T.',50,.F.,})
    Aadd( aParamBox ,{1,"Vendedor Até "   ,Space(6),"" ,'.T.',"SA3",'.T.',50,.T.,})
    Aadd( aParamBox ,{1,"Periodo",REPLICATE(" ", TAMSX3("ZZT_PERIOD")[1]),"" ,'.T.',"",'.T.',50,.F.})

	//
	If ParamBox(aParamBox, "", @aRet,,,,,,,,.T.,.T.)
        cHrIni := Time()

    If SELECT("TMP_ZZT") > 0
        TMP_ZZT->(dbCloseArea())
    EndIf
    
    _cQuery := " SELECT ZVG_VLMETM,ZZT_VENDED, ZZT_PERIOD, ZZT.R_E_C_N_O_ ZZT_RECNO,  "+ENTER
    _cQuery += " (SELECT COUNT(*) REGS FROM "+RETSQLNAME('ZVF')+" ZVF (NOLOCK)  "+ENTER
    _cQuery += "    WHERE ZVF_PERIOD = ZZT.ZZT_PERIOD  "+ENTER
    _cQuery += "    AND ZVF_ENTREG = 'S' "+ENTER
    _cQuery += "    AND ZVF.D_E_L_E_T_ = ' ' "+ENTER
	_cQuery += "    GROUP BY ZVF_PERIOD ) AS ZVF_NENTREG  "+ENTER
    _cQuery += "  FROM "+RETSQLNAME('ZZT')+" ZZT (NOLOCK)  "+ENTER
    _cQuery += "    LEFT OUTER JOIN "+RETSQLNAME('ZVG')+" ZVG (NOLOCK)  "+ENTER
    _cQuery += "        ON ZVG_FILIAL = ' '  "+ENTER
    _cQuery += "        AND ZVG_VENDED = ZZT_VENDED  "+ENTER
    _cQuery += "        AND ZVG_GRUPO = ZZT_GRUPO  "+ENTER
    _cQuery += "        AND ZVG_PERIOD = ZZT_PERIOD  "+ENTER
    _cQuery += "        AND ZVG.D_E_L_E_T_ = ' '  "+ENTER
    _cQuery += " WHERE ZZT.D_E_L_E_T_ = ' ' "+ENTER
    _cQuery += "  AND ZZT.ZZT_FILIAL = '  ' "+ENTER
    _cQuery += "  AND ZZT.ZZT_VENDED BETWEEN '"+mv_par01+"' AND '"+mv_par01+"' "+ENTER
    _cQuery += "  AND ZZT.ZZT_PERIOD = '"+mv_par03+"' "+ENTER

    memowrite("C:\TEMP\CADZTT-01.SQL",_cQuery)

    tcquery _cQuery New Alias "TMP_ZZT"
    TcSetField("TMP_ZZT","ZZT_RECNO","N",10,0)
        dbSelectArea("TMP_ZZT")
        Count to _nCountZZT
        oProcess:SetRegua1(_nCountZZT)  
        TMP_ZZT->(dbGotop())
        While !TMP_ZZT->(Eof())
            oProcess:IncRegua1("Atualizando Meta Diaria..."+StrZero(_nCountZZT++, 9))  
            dbSelectArea("ZZT")
            dbGoto(TMP_ZZT->ZZT_RECNO)
            RECLOCK("ZZT",.F.)
            ZZT->ZZT_METDIA := TMP_ZZT->ZVG_VLMETM / TMP_ZZT->ZVF_NENTREG
            MSUNLOCK()
            TMP_ZZT->(dbSkip())
        EndDo
        TMP_ZZT->(dbCloseArea())
        RestArea(_aZVFArea)
        RestArea(_aAtuArea)
        cHrFim := Time()
        Aviso("Fim", "Recálculos das Metas de Vendas finalizados!" + ENTER + ENTER + "Iniciado as: " + cHrIni + ENTER + "Finalizado as: " + cHrFim, {"OK"}, 3)    
    EndIf
Return
