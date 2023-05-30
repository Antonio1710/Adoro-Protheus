#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'
//-------------------------------------------------------------------
/*/{Protheus.doc} ADFAT062P
Calendario Mensal de Metas em MVC

@author Antonio Domingos
@since 06/10/2022
@version P10
@history Ticket 8122  - 06/10/2022 - Antonio Domingos - Otimização do processo de Importação de Meta


/*/
//-------------------------------------------------------------------
User Function ADFAT062P()

    Local oBrowse
       
    SetFunName("ADFAT062P")
     
oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'ZVG' )
oBrowse:SetDescription( 'Meta Mensal Vendas' )
oBrowse:AddButton("Imp.Metas",{|| MsAguarde({|| FAT062A(oBrowse) },'Gerando Impportação Metas...')  },,9,,.F.)
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
Local oStruZVG := FWFormStruct( 1, 'ZVG', /*bAvalCampo*/, /*lViewUsado*/ )
//Local oStruZVD := FWFormStruct( 1, 'ZVD', /*bAvalCampo*/, /*lViewUsado*/ )
Local bVldPos    := {|oModel| VldTudoOk(oModel)  }
Local oModel

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'FAT062M', /*bPreValidacao*/, bVldPos /*FAT062POS( oModel )*/, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZVGMASTER', /*cOwner*/, oStruZVG )
//ZVG_FILIAL	ZVG_VENDED	ZVG_SUPERV	ZVG_GRUPO	ZVG_PERIOD	ZVG_VLMDIA	D_E_L_E_T_	R_E_C_N_O_	R_E_C_D_E_L_
oModel:SetPrimaryKey( { "ZVG_FILIAL", "ZVG_VENDED", "ZVG_SUPERV" ,"ZVG_GRUPO" } )  

// Adiciona ao modelo uma estrutura de formulário de edição por grid
//oModel:AddGrid( 'ZVDDETAIL', 'ZVGMASTER', oStruZVD, /*bLinePre*/, /*bLinePost*/, /*bVldPos*/, /*BLoad*/ )
 
// Indica que é opcional ter dados informados na Grid
//oModel:GetModel('ZVDDETAIL'):SetOptional(.T.)
//oModel:GetModel("ZVDDETAIL"):SetNoInsertLine(.T.)
//oModel:GetModel("ZVDDETAIL"):SetNoDeleteLine(.T.)

// Faz relaciomaneto entre os compomentes do model
//oModel:SetRelation( 'ZVDDETAIL', { { 'ZVD_FILIAL', 'xFilial( "ZVD" )' }, { 'ZVD_CPFMOT', 'ZVG_CPF' } }, ZVD->( IndexKey( 1 ) ) )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Meta Mensal Vendas' )

// Adiciona a descricao do Meta do Modelo de Dados
oModel:GetModel( 'ZVGMASTER' ):SetDescription( 'Metas Vendas' )
//oModel:GetModel( 'ZVDDETAIL' ):SetDescription( 'Historico Placa Transportadora'  )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oStruZVG := FWFormStruct( 2, 'ZVG' )
//Local oStruZVD := FWFormStruct( 2, 'ZVD' )
// Cria a estrutura a ser usada na View
Local oModel   := FWLoadModel( 'ADFAT062P' )
Local oView

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_ZVG', oStruZVG, 'ZVGMASTER' )

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
//oView:AddGrid(  'VIEW_ZVD', oStruZVD, 'ZVDDETAIL' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 100 )
//oView:CreateHorizontalBox( 'INFERIOR', 40 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZVG', 'SUPERIOR' )
//oView:SetOwnerView( 'VIEW_ZVD', 'INFERIOR' )

// Liga a identificacao do Meta
//oView:EnableTitleView('VIEW_ZVD','Historico de Placas')

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} VldTudoOk()
Inclui dados do Ordem de Serviço na tabela ZVG-Ordem de Serviço
Quando há alteração nos campos de Transportadora e ou Placa do veiculo.
@author Antonio Domingos
@since 06/09/2022
@version P10
@history Ticket 8122 - 06/10/2022 - Antonio Domingos - Otimização do processo de Importação de Meta
Otimização do processo de Importação de Meta

/*/

//-------------------------------------------------------------------
Static Function VldTudoOk(oModel)
Local lRet       := .T.
Local aArea      := GetArea()
Local aAreaZVG   := ZVG->( GetArea() )
//Local oModel := FWModelActive()
Local nOperation := oModel:GetOperation()
Local cVENDED  := oModel:GetValue("ZVGMASTER", "ZVG_VENDED")
Local cSUPERV  := oModel:GetValue("ZVGMASTER", "ZVG_SUPERV")
Local cGRUPO  := oModel:GetValue("ZVGMASTER", "ZVG_GRUPO")
//ZVG_FILIAL	ZVG_VENDED	ZVG_SUPERV	ZVG_GRUPO	ZVG_PERIOD	ZVG_VLMDIA	D_E_L_E_T_	R_E_C_N_O_	R_E_C_D_E_L_
If nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE
	If cVENDED == ' ' .or. cSUPERV = ' ' .or. cGRUPO = ' '  
		Help(Nil, Nil, "VldTudoOk(ADFAT062P) Msg-01",,"Vendedor, Supervisor e GrupoSKU Obrigatorio!", 1, 0 )
		lRet := .F.
	EndIf
EndIf

RestArea( aAreaZVG )
RestArea( aArea )

Return lRet



/*/{Protheus.doc} User Function ADCON019P
    Cria Estrutura de Metas de Vendas a partir de um excel
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
    Local clTitulo	:= 'IMPORTAÇÃO Estrutura de Metas de Vendas - ZVG'
    Local clDesc1   := 'O objetivo desta rotina é criar as estruturas das Metas de Vendas. Arq.TXT'
    Local clDesc2   := 'Regras:'
    Local clDesc3   := '- incluirá uma Meta qdo existir o Grupo SKU e a coluna Meta vazia;'
    Local clDesc4   := '- substituirá o Meta quando a coluna Meta estiver preenchida;'
    Local clDesc5   := '- Estrutura: vend;sup;grp;periodo;volmet'
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
        oProcess := tNewProcess():New("RunADFAT062","Criando Metas de Vendas.",bProcess,clTitulo,cPerg,aInfoCustom, .T.,5, "MetaVendas", .T. )
    EndIf
   
    oBrowse:Refresh()

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cria Estrutura de Metas de Vendas a partir de um excel')

Return

/*/{Protheus.doc} Static Function RUNADFAT062
    (long_description)
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

    Local lFile     := .f.
    Local cTxt      := ""
    Local _nCountZVG    := 0
    Local aDadZVG   := {}
    Local aCampos   := {}

    
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
        
        Count to _nCountZVG
        ft_fGoTop()
        oProcess:SetRegua1(_nCountZVG)        
        
        cVerTab := "vend;sup;grp;periodo;volmet"

        cTxt := AllTrim(ft_fReadLn())
        
        If cVerTab <> cTXT
            
            Aviso("ADFAT062-02", "A importação não será realizada! As colunas do excel precisam ser " + cVerTab, {"&Ok"},, "Versão/Leiaute da planilha incorreta!")
            
        Else
                    
            ft_fSkip() // Pula linha do cabeçalho
            
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

            // Consistência
            Do While !ft_fEOF()
                
                oProcess:IncRegua1("Consistindo TXT..."+StrZero(_nCountZVG++, 9))  

                cTxt    := ft_fReadLn()
                aDadZVG := Separa(cTxt, ";")
                
                //vend;sup;grp;periodo;volmet
                //ZVG_FILIAL	ZVG_VENDED	ZVG_SUPERV	ZVG_GRUPO	ZVG_PERIOD	ZVG_VLMDIA
				cZVG_VENDED  := PadR( AllTrim(aDadZVG[1]), TAMSX3("ZVG_VENDED")[1] )
                cZVG_SUPERV  := PadR( AllTrim(aDadZVG[2]), TAMSX3("ZVG_SUPERV")[1] )
                cZVG_GRUPO  := PadR( AllTrim(aDadZVG[3]), TAMSX3("ZVG_GRUPO")[1] )
                cZVG_PERIOD  := PadR( AllTrim(aDadZVG[4]), TAMSX3("ZVG_PERIOD")[1] )
                nZVG_VLMTME  := Val(StrTran(aDadZVG[5],",","."))

                //Validando Vendedor
				SA3->( dbSetOrder(1) ) // A3_FILIAL, A3_COD, R_E_C_N_O_, D_E_L_E_T_
                If SA3->( !dbSeek(FWxFilial("SA3")+cZVG_VENDED) )
                    GrvTRB(1, cZVG_VENDED, cTXT)
                Else
                    If AllTrim(SA3->A3_MSBLQL) == "1"
                        GrvTRB(2, cZVG_VENDED, cTXT)
                    EndIf
                EndIf
				//Validando Supervisor
                SA3->( dbSetOrder(1) ) // A3_FILIAL, A3_COD, R_E_C_N_O_, D_E_L_E_T_
                If SA3->( !dbSeek(FWxFilial("SA3")+cZVG_SUPERV) )
                    GrvTRB(3, cZVG_SUPERV, cTXT)
                Else
                    If AllTrim(SA3->A3_MSBLQL) == "1"
                        GrvTRB(4, cZVG_SUPERV, cTXT)
                    EndIf
                EndIf

                //Validando Grupo do SKU
				SBM->( dbSetOrder(1) ) // BM_FILIAL, BM_COD, R_E_C_N_O_, D_E_L_E_T_
                If SBM->( !dbSeek(FWxFilial("SBM")+cZVG_GRUPO) )
                    GrvTRB(5, cZVG_GRUPO, cTXT)
                EndIf

                If nZVG_VLMTME <= 0
                    GrvTRB(7, alltrim(Str(nZVG_VLMTME,5,0)), cTXT)
                EndIf

                aDadZVG := {}
                
                ft_fSkip()
                
            EndDo
            
            TRB->( dbGoTop() )
            If TRB->( !EOF() )

                If msgYesNo("Consistência finalizada! Existem problemas nos dados que impediram a geração da estrutura. Deseja listá-las agora?")
                    ReportZVG()
                EndIf
            
            Else

                _nCountZVG  := 0
                aDadZVG     := {}

                Count to _nCountZVG
                ft_fGoTop()
                oProcess:SetRegua1(_nCountZVG)        
                
                oProcess:IncRegua1("Importando Mesta Venda..."+StrZero(_nCountZVG++, 9))  
                
                ft_fSkip() // Pula linha do cabeçalho       

                // Geração ZVG
                Do While !ft_fEOF()
                    
                    cTxt    := ft_fReadLn()
                    aDadZVG := Separa(cTxt, ";")

                    oProcess:IncRegua1("Importando Mesta Venda..."+PadR( AllTrim(aDadZVG[3]), TAMSX3("ZVG_GRUPO")[1] ))  

					//vend;sup;grp;periodo;volmet
					cZVG_VENDED  := PadR( AllTrim(aDadZVG[1]), TAMSX3("ZVG_VENDED")[1] )
					cZVG_SUPERV  := PadR( AllTrim(aDadZVG[2]), TAMSX3("ZVG_SUPERV")[1] )
					cZVG_GRUPO  := PadR( AllTrim(aDadZVG[3]), TAMSX3("ZVG_GRUPO")[1] )
					cZVG_PERIOD  := PadR( AllTrim(aDadZVG[4]), TAMSX3("ZVG_PERIOD")[1] )
					nZVG_VLMTME  := Val(StrTran(aDadZVG[5],",","."))

                    lLockZVG := .t.
                    If !Empty(nZVG_VLMTME)
                        ZVG->( dbSetOrder(1) ) // ZVG_FILIAL	ZVG_VENDED	ZVG_SUPERV	ZVG_GRUPO	ZVG_PERIOD	ZVG_VLMDIA	
                        If ZVG->( dbSeek(FWxFilial("ZVG")+cZVG_VENDED+cZVG_SUPERV+cZVG_GRUPO+cZVG_PERIOD) )
                            lLockZVG := .f.
                        EndIf
                    EndIf
	
                    RecLock("ZVG", lLockZVG)
						If lLockZVG
							ZVG->ZVG_FILIAL	:= FWxFilial("ZVG")
							ZVG->ZVG_VENDED	:= cZVG_VENDED
							ZVG->ZVG_SUPERV := cZVG_SUPERV 	
							ZVG->ZVG_GRUPO	:= cZVG_GRUPO
							ZVG->ZVG_PERIOD	:= cZVG_PERIOD
						Else
							ZVG->ZVG_VLMETM	:= nZVG_VLMTME
						EndIf
					ZVG->( msUnLock() )

                    aDadZVG := {}
                    
                    ft_fSkip()
                    
                EndDo
                
                ZVG->(dbSetOrder(1))    
				ZVG->(DbGotop())
                
                Alert("Importação finalizada com sucesso!")
                
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
        cStatus := "Supervisor não cadastrado"

    ElseIf nTipo == 4
        cStatus := "Supervisor bloqueado A3_MSBLQL"

    ElseIf nTipo == 5
        cStatus := "Grupo SKU não cadastrado"

    ElseIf nTipo == 6
        cStatus := "Grupo SKU bloqueado BM_MSBLQL"

    ElseIf nTipo == 7
        cStatus := "Volume dia Invalido"

    EndIf

    RecLock("TRB", .T.)

	    TRB->CODIGO  := cCodigo
		TRB->STATUS  := cStatus
		TRB->LINHA   := cTXT

	TRB->( msUnLock() )
	
Return

/*/{Protheus.doc} Static Function ReportZVG
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
Static Function ReportZVG()

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
	OemToAnsi(" ")+CRLF+;
	OemToAnsi("")+CRLF+;
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
