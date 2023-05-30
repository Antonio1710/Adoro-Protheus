//Bibliotecas
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#include "topconn.ch"
  
//Variáveis Estáticas
Static cTitulo := "Alterar dados NDI"

/*/{Protheus.doc} User Function ADFI134
    Permite alterar dados do título NDI (desde que não baixados)
    https://www.youtube.com/watch?v=dG9RMEo-WhQ (0011560-38.2021.5.15.0105)
    @type  Function
    @author FWNM
    @since 24/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @ticket 77598 - Fernando Macieira - 24/08/2022 - RM - Acordos - Alteração NDI (CNPJ ou CPF e dados bancários)
    @history ticket 78884 - Everson - 25/08/2022 - Tratamento para error log.
/*/
User Function ADFI134()

    Local aArea       := GetArea()
    Local oBrowse
    Local cFunBkp     := FunName()
    Local aBrowse     := {}
    Local aIndex      := {}
    Local aCampos     := {}

	Private oTempTable
    Private cAliasTmp := "TRBNDI"
     
    If Select("TRBNDI") > 0
        TRBNDI->( dbCloseArea() )
    EndIf
		
	// Crio TRB para impressão
	// https://tdn.totvs.com.br/display/framework/FWTemporaryTable
	oTempTable := FWTemporaryTable():New("TRBNDI")
	
	////////////////////
    // Arquivo TRBNDI //
    ////////////////////

    // Título NDI
    aAdd( aCampos, {'E2_NUM'     ,TamSX3("E2_NUM")[3]     ,TamSX3("E2_NUM")[1]     , 0} )
    aAdd( aCampos, {'E2_PARCELA' ,TamSX3("E2_PARCELA")[3] ,TamSX3("E2_PARCELA")[1] , 0} )
    // Dados Bancários
    aAdd( aCampos, {'E2_BANCO'   ,TamSX3("E2_BANCO")[3]   ,TamSX3("E2_BANCO")[1] , 0} )
	aAdd( aCampos, {'E2_AGEN'    ,TamSX3("E2_AGEN")[3]    ,TamSX3("E2_AGEN")[1]  , 0} )
	aAdd( aCampos, {'E2_DIGAG'   ,TamSX3("E2_DIGAG")[3]   ,TamSX3("E2_DIGAG")[1] , 0} )
    aAdd( aCampos, {'E2_NOCTA'   ,TamSX3("E2_NOCTA")[3]   ,TamSX3("E2_NOCTA")[1] , 0} )
    aAdd( aCampos, {'E2_DIGCTA'  ,TamSX3("E2_DIGCTA")[3]  ,TamSX3("E2_DIGCTA")[1], 0} )
    // Favorecido
    aAdd( aCampos, {'E2_NOMCTA'  ,TamSX3("E2_NOMCTA")[3]  ,TamSX3("E2_NOMCTA")[1], 0} )
    aAdd( aCampos, {'E2_CNPJ'    ,TamSX3("E2_CNPJ")[3]    ,TamSX3("E2_CNPJ")[1]  , 0} )

	oTempTable:SetFields(aCampos)
	oTempTable:AddIndex("01", {"E2_NUM","E2_PARCELA"} )
	oTempTable:Create()

    PopulaTRB()
     
    //Definindo as colunas que serão usadas no browse
    aAdd(aBrowse, {"Número",      "E2_NUM"    , TamSX3("E2_NUM")[3]    , TamSX3("E2_NUM")[1]    , 0, "@!"})
    aAdd(aBrowse, {"Parcela",     "E2_PARCELA", TamSX3("E2_PARCELA")[3], TamSX3("E2_PARCELA")[1], 0, "@!"})
    aAdd(aBrowse, {"Banco",       "E2_BANCO"  , TamSX3("E2_BANCO")[3]  , TamSX3("E2_BANCO")[1]  , 0, "@!"})
    aAdd(aBrowse, {"Agência",     "E2_AGEN"   , TamSX3("E2_AGEN")[3]   , TamSX3("E2_AGEN")[1]   , 0, "@!"})
    aAdd(aBrowse, {"Dig-Agência", "E2_DIGAG"  , TamSX3("E2_DIGAG")[3]  , TamSX3("E2_DIGAG")[1]  , 0, "@!"})
    aAdd(aBrowse, {"Conta",       "E2_NOCTA"  , TamSX3("E2_NOCTA")[3]  , TamSX3("E2_NOCTA")[1]  , 0, "@!"})
    aAdd(aBrowse, {"Dig-Conta",   "E2_DIGCTA" , TamSX3("E2_DIGCTA")[3] , TamSX3("E2_DIGCTA")[1] , 0, "@!"})
    aAdd(aBrowse, {"Favorecido",  "E2_NOMCTA" , TamSX3("E2_NOMCTA")[3] , TamSX3("E2_NOMCTA")[1] , 0, "@!"})
    aAdd(aBrowse, {"CPF/CNPJ",    "E2_CNPJ"   , TamSX3("E2_CNPJ")[3]   , TamSX3("E2_CNPJ")[1]   , 0, "@!"})

    SetFunName("ADFI134")
     
    aAdd(aIndex, "E2_NUM")    
    aAdd(aIndex, "E2_PARCELA")    
     
    //Criando o browse da temporária
    cTitulo := "Alterar dados NDI - Processo " + ZHB->ZHB_PROCES
    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias(cAliasTmp)
    oBrowse:SetQueryIndex(aIndex)
    oBrowse:SetTemporary(.T.)
    oBrowse:SetFields(aBrowse)
    oBrowse:DisableDetails()
    oBrowse:SetDescription(cTitulo)
    oBrowse:Activate()
     
    SetFunName(cFunBkp)
    
    RestArea(aArea)

    If oTempTable == "O"
        oTempTable:Delete()
    EndIf

    //ticket 78884 - Everson - 25/08/2022.
    // oModel:DeActivate()
    // oModel:Destroy()
    // oModel := Nil

Return
 
/*---------------------------------------------------------------------*
 | Func:  MenuDef                                                      |
 | Desc:  Criação do menu MVC                                          |
 *---------------------------------------------------------------------*/
Static Function MenuDef()

    Local aRot := {}
     
    //ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ADFI134' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4

    ADD OPTION aRot TITLE 'Visualizar' ACTION 'VIEWDEF.ADFI134' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 //OPERATION 1
    ADD OPTION aRot TITLE 'Incluir'    ACTION 'VIEWDEF.ADFI134' OPERATION MODEL_OPERATION_INSERT ACCESS 0 //OPERATION 3
    ADD OPTION aRot TITLE 'Alterar'    ACTION 'VIEWDEF.ADFI134' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 //OPERATION 4
    ADD OPTION aRot TITLE 'Excluir'    ACTION 'VIEWDEF.ADFI134' OPERATION MODEL_OPERATION_DELETE ACCESS 0 //OPERATION 5
 
Return aRot
 
/*---------------------------------------------------------------------*
 | Func:  ModelDef                                                     |
 | Desc:  Criação do modelo de dados MVC                               |
 *---------------------------------------------------------------------*/
Static Function ModelDef()

    // Blocos de codigos nas validacoes
    //Local bVldPre := {|| u_zM1Pre()} // Antes de abrir a tela
    //Local bVldPos := {|| u_zM1Pos()} // Validacao ao clicar no botao confirmar
    Local bVldCom := {|| u_zNDICom()} // Funcao chamada no commit
    //Local bVldCan := {|| u_zM1Can()} // Funcao chamada no cancelar

    //Criação do objeto do modelo de dados
    Local oModel := Nil
     
    //Criação da estrutura de dados utilizada na interface
    Local oStTMP := FWFormModelStruct():New()
     
    oStTMP:AddTable(cAliasTmp, {'E2_NUM', 'E2_PARCELA', 'E2_BANCO', 'E2_AGEN', 'E2_DIGAG', 'E2_NOCTA', 'E2_DIGCTA', 'E2_NOMCTA', 'E2_CNPJ' }, "Dados NDI")
     
    //Adiciona os campos da estrutura
    oStTmp:AddField(;
        "Número",;                                                                                  // [01]  C   Titulo do campo
        "Número",;                                                                                  // [02]  C   ToolTip do campo
        "E2_NUM",;                                                                                  // [03]  C   Id do Field
        TamSX3("E2_NUM")[3],;                                                                       // [04]  C   Tipo do campo
        TamSX3("E2_NUM")[1],;                                                                       // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->E2_NUM,'')" ),;          // [11]  B   Code-block de inicializacao do campo
        .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual

    oStTmp:AddField(;
        "Parcela",;                                                                                  // [01]  C   Titulo do campo
        "Parcela",;                                                                                  // [02]  C   ToolTip do campo
        "E2_PARCELA",;                                                                                  // [03]  C   Id do Field
        TamSX3("E2_PARCELA")[3],;                                                                       // [04]  C   Tipo do campo
        TamSX3("E2_PARCELA")[1],;                                                                       // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->E2_PARCELA,'')" ),;          // [11]  B   Code-block de inicializacao do campo
        .T.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual

    oStTmp:AddField(;
        "Banco",;                                                                                  // [01]  C   Titulo do campo
        "Banco",;                                                                                  // [02]  C   ToolTip do campo
        "E2_BANCO",;                                                                                  // [03]  C   Id do Field
        TamSX3("E2_BANCO")[3],;                                                                       // [04]  C   Tipo do campo
        TamSX3("E2_BANCO")[1],;                                                                       // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->E2_BANCO,'')" ),;          // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual

    oStTmp:AddField(;
        "Agência",;                                                                                  // [01]  C   Titulo do campo
        "Agência",;                                                                                  // [02]  C   ToolTip do campo
        "E2_AGEN",;                                                                                  // [03]  C   Id do Field
        TamSX3("E2_AGEN")[3],;                                                                       // [04]  C   Tipo do campo
        TamSX3("E2_AGEN")[1],;                                                                       // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->E2_AGEN,'')" ),;          // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual

    oStTmp:AddField(;
        "Dig-Agência",;                                                                                  // [01]  C   Titulo do campo
        "Dig-Agência",;                                                                                  // [02]  C   ToolTip do campo
        "E2_DIGAG",;                                                                                  // [03]  C   Id do Field
        TamSX3("E2_DIGAG")[3],;                                                                       // [04]  C   Tipo do campo
        TamSX3("E2_DIGAG")[1],;                                                                       // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .F.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->E2_DIGAG,'')" ),;          // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual

    oStTmp:AddField(;
        "Conta",;                                                                                  // [01]  C   Titulo do campo
        "Conta",;                                                                                  // [02]  C   ToolTip do campo
        "E2_NOCTA",;                                                                                  // [03]  C   Id do Field
        TamSX3("E2_NOCTA")[3],;                                                                       // [04]  C   Tipo do campo
        TamSX3("E2_NOCTA")[1],;                                                                       // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->E2_NOCTA,'')" ),;          // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual

    oStTmp:AddField(;
        "Dig-Conta",;                                                                                  // [01]  C   Titulo do campo
        "Dig-Conta",;                                                                                  // [02]  C   ToolTip do campo
        "E2_DIGCTA",;                                                                                  // [03]  C   Id do Field
        TamSX3("E2_DIGCTA")[3],;                                                                       // [04]  C   Tipo do campo
        TamSX3("E2_DIGCTA")[1],;                                                                       // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->E2_DIGCTA,'')" ),;          // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual

    oStTmp:AddField(;
        "Favorecido",;                                                                                  // [01]  C   Titulo do campo
        "Favorecido",;                                                                                  // [02]  C   ToolTip do campo
        "E2_NOMCTA",;                                                                                  // [03]  C   Id do Field
        TamSX3("E2_NOMCTA")[3],;                                                                       // [04]  C   Tipo do campo
        TamSX3("E2_NOMCTA")[1],;                                                                       // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->E2_NOMCTA,'')" ),;          // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual

    oStTmp:AddField(;
        "CPF/CNPJ",;                                                                                  // [01]  C   Titulo do campo
        "CPF/CNPJs",;                                                                                  // [02]  C   ToolTip do campo
        "E2_CNPJ",;                                                                                  // [03]  C   Id do Field
        TamSX3("E2_CNPJ")[3],;                                                                       // [04]  C   Tipo do campo
        TamSX3("E2_CNPJ")[1],;                                                                       // [05]  N   Tamanho do campo
        0,;                                                                                         // [06]  N   Decimal do campo
        Nil,;                                                                                       // [07]  B   Code-block de validação do campo
        Nil,;                                                                                       // [08]  B   Code-block de validação When do campo
        {},;                                                                                        // [09]  A   Lista de valores permitido do campo
        .T.,;                                                                                       // [10]  L   Indica se o campo tem preenchimento obrigatório
        FwBuildFeature( STRUCT_FEATURE_INIPAD, "Iif(!INCLUI,"+cAliasTmp+"->E2_CNPJ,'')" ),;          // [11]  B   Code-block de inicializacao do campo
        .F.,;                                                                                       // [12]  L   Indica se trata-se de um campo chave
        .F.,;                                                                                       // [13]  L   Indica se o campo pode receber valor em uma operação de update.
        .F.)                                                                                        // [14]  L   Indica se o campo é virtual

    //Instanciando o modelo, não é recomendado colocar nome da user function (por causa do u_), respeitando 10 caracteres
    oModel := MPFormModel():New("zADFI134",/*bPre*/, /*bPos*/,bVldCom,/*bCancel*/) 
     
    //Atribuindo formulários para o modelo
    oModel:AddFields("FORMTMP",/*cOwner*/,oStTMP)
     
    //Setando a chave primária da rotina
    oModel:SetPrimaryKey({'E2_NUM','E2_PARCELA'})
     
    //Adicionando descrição ao modelo
    oModel:SetDescription(cTitulo)
     
    //Setando a descrição do formulário
    oModel:GetModel("FORMTMP"):SetDescription(cTitulo)

Return oModel
 
/*---------------------------------------------------------------------*
 | Func:  ViewDef                                                      |
 | Desc:  Criação da visão MVC                                         |
 *---------------------------------------------------------------------*/
Static Function ViewDef()

    //Local aStruTMP := (cAliasTmp)->( dbStruct() )
    Local oModel := FWLoadModel("ADFI134")
    Local oStTMP := FWFormViewStruct():New()
    Local oView := Nil
 
    //Adicionando campos da estrutura
    oStTmp:AddField(;
        "E2_NUM",;                  // [01]  C   Nome do Campo
        "01",;                      // [02]  C   Ordem
        "Número",;                  // [03]  C   Titulo do campo
        "Número",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStTmp:AddField(;
        "E2_PARCELA",;              // [01]  C   Nome do Campo
        "02",;                      // [02]  C   Ordem
        "Parcela",;                 // [03]  C   Titulo do campo
        "Parcela",;                 // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        Iif(INCLUI, .T., .F.),;     // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
     
    oStTmp:AddField(;
        "E2_BANCO",;                // [01]  C   Nome do Campo
        "03",;                      // [02]  C   Ordem
        "Banco",;                   // [03]  C   Titulo do campo
        "Banco",;                   // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStTmp:AddField(;
        "E2_AGEN",;                // [01]  C   Nome do Campo
        "04",;                      // [02]  C   Ordem
        "Agência",;                   // [03]  C   Titulo do campo
        "Agência",;                   // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStTmp:AddField(;
        "E2_DIGAG",;                // [01]  C   Nome do Campo
        "05",;                      // [02]  C   Ordem
        "Dig-Agência",;                   // [03]  C   Titulo do campo
        "Dig-Agência",;                   // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStTmp:AddField(;
        "E2_NOCTA",;                // [01]  C   Nome do Campo
        "06",;                      // [02]  C   Ordem
        "Conta",;                   // [03]  C   Titulo do campo
        "Conta",;                   // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStTmp:AddField(;
        "E2_DIGCTA",;                // [01]  C   Nome do Campo
        "07",;                      // [02]  C   Ordem
        "Dig-Conta",;                   // [03]  C   Titulo do campo
        "Dig-Conta",;                   // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStTmp:AddField(;
        "E2_NOMCTA",;                // [01]  C   Nome do Campo
        "08",;                      // [02]  C   Ordem
        "Favorecido",;                   // [03]  C   Titulo do campo
        "Favorecido",;                   // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStTmp:AddField(;
        "E2_CNPJ",;                // [01]  C   Nome do Campo
        "09",;                      // [02]  C   Ordem
        "CPF/CNPJ",;                   // [03]  C   Titulo do campo
        "CPF/CNPJ",;                   // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    //Criando a view que será o retorno da função e setando o modelo da rotina
    oView := FWFormView():New()
    oView:SetModel(oModel)
     
    //Atribuindo formulários para interface
    oView:AddField("VIEW_TMP", oStTMP, "FORMTMP")
     
    //Criando um container com nome tela com 100%
    oView:CreateHorizontalBox("TELA",100)
     
    //Colocando título do formulário
    oView:EnableTitleView('VIEW_TMP', cTitulo + " - Título sem borderô e com saldo" )  
     
    //Força o fechamento da janela na confirmação
    oView:SetCloseOnOk({||.T.})
     
    //O formulário da interface será colocado dentro do container
    oView:SetOwnerView("VIEW_TMP","TELA")

Return oView

/*/{Protheus.doc} nomeStaticFunction
    (long_description)
    @type  Static Function
    @author user
    @since 24/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function PopulaTRB()

    Local cQuery    := ""
    Local cTitulos  := ""
    Local cTipoNDI  := GetMV("MV_#ACOTIP",,"NDI")

    // Títulos do processo
    If Select("Work")
        Work->( dbCloseArea() )
    EndIf

    cQuery := " SELECT ZHB_NUM
    cQuery += " FROM " + RetSqlName("ZHB") + " (NOLOCK)
    cQuery += " WHERE ZHB_PROCES='"+ZHB->ZHB_PROCES+"' 
    cQuery += " AND ZHB_NUM<>''
    cQuery += " AND ZHB_GERPAR='T'
    cQuery += " AND D_E_L_E_T_=''

    tcQuery cQuery New Alias "Work"

    Work->( dbGoTop() )
    Do While Work->( !EOF() )
        cTitulos += Work->ZHB_NUM + "|"
        Work->( dbSkip() )
    EndDo

    cTitulos := Left(AllTrim(cTitulos),Len(AllTrim(cTitulos))-1)

    // Títulos do processo em aberto e fora de borderô
    If Select("Work")
        Work->( dbCloseArea() )
    EndIf

    cQuery := " SELECT E2_NUM, E2_PARCELA, E2_BANCO, E2_AGEN, E2_DIGAG, E2_NOCTA, E2_DIGCTA, E2_NOMCTA, E2_CNPJ
    cQuery += " FROM " + RetSqlName("SE2") + " (NOLOCK)
    cQuery += " WHERE E2_NUM IN " + FormatIn(cTitulos,"|")
    cQuery += " AND E2_TIPO='"+cTipoNDI+"'
    cQuery += " AND E2_SALDO>0
    cQuery += " AND E2_NUMBOR=''
    cQuery += " AND D_E_L_E_T_=''

    tcQuery cQuery New Alias "Work"

    Work->( dbGoTop() )
    Do While Work->( !EOF() )

        RecLock(cAliasTmp, .T.)
            (cAliasTmp)->E2_NUM     := Work->E2_NUM
            (cAliasTmp)->E2_PARCELA := Work->E2_PARCELA
            (cAliasTmp)->E2_BANCO   := Work->E2_BANCO
            (cAliasTmp)->E2_AGEN    := Work->E2_AGEN
            (cAliasTmp)->E2_DIGAG   := Work->E2_DIGAG
            (cAliasTmp)->E2_NOCTA   := Work->E2_NOCTA
            (cAliasTmp)->E2_DIGCTA  := Work->E2_DIGCTA
            (cAliasTmp)->E2_NOMCTA  := Work->E2_NOMCTA
            (cAliasTmp)->E2_CNPJ    := Work->E2_CNPJ
        (cAliasTmp)->( msUnLock() )

        Work->( dbSkip() )

    EndDo

    If Select("Work")
        Work->( dbCloseArea() )
    EndIf

Return

/*/{Protheus.doc} User Function nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 24/08/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
/*/
User Function zNDICom()

    Local oModelPad   := FWModelActive()
    
    Local cE2_NUM     := oModelPad:GetValue("FORMTMP", "E2_NUM")
    Local cE2_PARCELA := oModelPad:GetValue("FORMTMP", "E2_PARCELA")
    Local cBanco      := oModelPad:GetValue("FORMTMP", "E2_BANCO")
    Local cAgencia    := oModelPad:GetValue("FORMTMP", "E2_AGEN")
    Local cDigAg      := oModelPad:GetValue("FORMTMP", "E2_DIGAG")
    Local cConta      := oModelPad:GetValue("FORMTMP", "E2_NOCTA")
    Local cDigCta     := oModelPad:GetValue("FORMTMP", "E2_DIGCTA")
    Local cFavore     := oModelPad:GetValue("FORMTMP", "E2_NOMCTA")
    Local cCPFCGC     := oModelPad:GetValue("FORMTMP", "E2_CNPJ")

    Local nOpc        := oModelPad:GetOperation()
    Local lRet        := .t.

    Local cPrefixo  := GetMV("MV_#ZC7PRE",,"GPE")
    // Local cTipoPR   := GetMV("MV_#ZC7TIP",,"PR")
    Local cTipoNDI := GetMV("MV_#ACOTIP",,"NDI")
    // Local cNaturez  := GetMV("MV_#ZC7NAT",,"22326")
    Local cFornece  := GetMV("MV_#ZC7SA2",,"001901")
    Local cLoja     := GetMV("MV_#ZC7LOJ",,"01")
    Local cSql      := ""

// Se for inclusao
If nOpc == MODEL_OPERATION_INSERT
	
	Alert("Inclusão - Operação não permitida!")
    lRet        := .F.
		
// Se for alteracao
ElseIf nOpc == MODEL_OPERATION_UPDATE
	
	SE2->( dbSetOrder(1) ) // E2_FILIAL, E2_PREFIXO, E2_NUM, E2_PARCELA, E2_TIPO, E2_FORNECE, E2_LOJA, R_E_C_N_O_, D_E_L_E_T_
    If SE2->( dbSeek(FWxFilial("SE2")+cPrefixo+cE2_NUM+cE2_PARCELA+cTipoNDI+cFornece+cLoja) )
    
        //gera log
        u_GrLogZBE( msDate(), TIME(), cUserName, "ALTEROU DADOS NDI (ANTES) - TITULO/PARCELA/TIPO " + SE2->E2_NUM+"/"+SE2->E2_PARCELA+"/"+SE2->E2_TIPO,"RH-ACORDOS","ADFI134",;
        "DADOS BANCARIOS + FAVORECIDO " + SE2->E2_BANCO + "," + SE2->E2_AGEN + "," + SE2->E2_DIGAG + "," + SE2->E2_NOCTA + "," + SE2->E2_DIGCTA + "," + AllTrim(SE2->E2_NOMCTA) + "," + SE2->E2_CNPJ, ComputerName(), LogUserName() )

        RecLock("SE2", .F.)

            // Banco
            SE2->E2_BANCO := cBanco

            // Agencia
            SE2->E2_AGEN := cAgencia

            // Dig Agencia
            SE2->E2_DIGAG := cDigAg

            // Conta
            SE2->E2_NOCTA := cConta

            // Dig Conta
            SE2->E2_DIGCTA := cDigCta

            // Favorecido
            SE2->E2_NOMCTA := AllTrim(cFavore)
            SE2->E2_CNPJ   := cCPFCGC

        SE2->( msUnLock() )   

        //gera log
        u_GrLogZBE( msDate(), TIME(), cUserName, "ALTEROU DADOS NDI (DEPOIS) - TITULO/PARCELA/TIPO " + SE2->E2_NUM+"/"+SE2->E2_PARCELA+"/"+SE2->E2_TIPO,"RH-ACORDOS","ADFI134",;
        "DADOS BANCARIOS + FAVORECIDO " + SE2->E2_BANCO + "," + SE2->E2_AGEN + "," + SE2->E2_DIGAG + "," + SE2->E2_NOCTA + "," + SE2->E2_DIGCTA + "," + AllTrim(SE2->E2_NOMCTA) + "," + SE2->E2_CNPJ, ComputerName(), LogUserName() )
	
    	//Aviso("OK", "Alteração realizada com sucesso!", {"OK"}, 03)

        cSql := " UPDATE " + oTempTable:GetRealName()
        cSql += " SET E2_BANCO = '"+cBanco+"',
        cSql += " E2_AGEN = '"+cAgencia+"',
        cSql += " E2_DIGAG = '"+cDigAg+"',
        cSql += " E2_NOCTA = '"+cConta+"',
        cSql += " E2_DIGCTA = '"+cDigCta+"',
        cSql += " E2_NOMCTA = '"+AllTrim(cFavore)+"',
        cSql += " E2_CNPJ = '"+cCPFCGC+"'
        cSql += " WHERE E2_NUM='"+cE2_NUM+"' 
        cSql += " AND E2_PARCELA='"+cE2_PARCELA+"' 

        tcSqlExec(cSql)

    Else

        lRet        := .f.
    
    EndIf
	
// Se for exclusao
ElseIf nOpc == MODEL_OPERATION_DELETE

	Alert("Exclusão - Operação não permitida!")
    lRet        := .F.
                              
EndIf

Return lRet
