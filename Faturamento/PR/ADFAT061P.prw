#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'
//-------------------------------------------------------------------
/*/{Protheus.doc} ADFAT061P
Calendario Mensal de Metas em MVC

@author Antonio Domingos
@since 06/10/2022
@version P10
@history Ticket 8122  - 06/10/2022 - Antonio Domingos - Otimização do processo de Importação de Meta


/*/
//-------------------------------------------------------------------
User Function ADFAT061P()

    Private oBrowse
       
    SetFunName("ADFAT061P")
     
oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'ZVF' )
oBrowse:SetDescription( 'Calendario Mensal Metas Vendas' )
oBrowse:AddButton("Inc.Automatica",{|| MsAguarde({|| FAT061A(oBrowse) },'Incluindo Calendario...')  },,9,,.F.)
oBrowse:Activate()


Return NIL


//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.ADFAT061P' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.ADFAT061P' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.ADFAT061P' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.ADFAT061P' OPERATION 5 ACCESS 0 
ADD OPTION aRotina Title 'Imprimir'    Action 'VIEWDEF.ADFAT061P' OPERATION 8 ACCESS 0

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZVF := FWFormStruct( 1, 'ZVF', /*bAvalCampo*/, /*lViewUsado*/ )
//Local oStruZVD := FWFormStruct( 1, 'ZVD', /*bAvalCampo*/, /*lViewUsado*/ )
Local bVldPos    := {|oModel| VldTudoOk(oModel)  }
Local oModel

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'FAT061M', /*bPreValidacao*/, bVldPos /*FAT061POS( oModel )*/, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZVFMASTER', /*cOwner*/, oStruZVF )

oModel:SetPrimaryKey( { "ZVF_FILIAL", "ZVF_PERIOD", "ZVF_DATA" } )  

// Adiciona ao modelo uma estrutura de formulário de edição por grid
//oModel:AddGrid( 'ZVDDETAIL', 'ZVFMASTER', oStruZVD, /*bLinePre*/, /*bLinePost*/, /*bVldPos*/, /*BLoad*/ )
 
// Indica que é opcional ter dados informados na Grid
//oModel:GetModel('ZVDDETAIL'):SetOptional(.T.)
//oModel:GetModel("ZVDDETAIL"):SetNoInsertLine(.T.)
//oModel:GetModel("ZVDDETAIL"):SetNoDeleteLine(.T.)

// Faz relaciomaneto entre os compomentes do model
//oModel:SetRelation( 'ZVDDETAIL', { { 'ZVD_FILIAL', 'xFilial( "ZVD" )' }, { 'ZVD_CPFMOT', 'ZVF_CPF' } }, ZVD->( IndexKey( 1 ) ) )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Calendario Mensal Metas Vendas' )

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'ZVFMASTER' ):SetDescription( 'Metas Vendas' )
//oModel:GetModel( 'ZVDDETAIL' ):SetDescription( 'Historico Placa Transportadora'  )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oStruZVF := FWFormStruct( 2, 'ZVF' )
//Local oStruZVD := FWFormStruct( 2, 'ZVD' )
// Cria a estrutura a ser usada na View
Local oModel   := FWLoadModel( 'ADFAT061P' )
Local oView

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_ZVF', oStruZVF, 'ZVFMASTER' )

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
//oView:AddGrid(  'VIEW_ZVD', oStruZVD, 'ZVDDETAIL' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 100 )
//oView:CreateHorizontalBox( 'INFERIOR', 40 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZVF', 'SUPERIOR' )
//oView:SetOwnerView( 'VIEW_ZVD', 'INFERIOR' )

// Liga a identificacao do componente
//oView:EnableTitleView('VIEW_ZVD','Historico de Placas')

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} VldTudoOk()
Inclui dados do calendario de Metas de venda.
Quando há alteração nos campos de calendario de metas de venda.
@author Antonio Domingos
@since 06/09/2022
@version P10
@history Ticket 8122 - 06/10/2022 - Antonio Domingos - Otimização do processo de Importação de Meta
/*/

//-------------------------------------------------------------------
Static Function VldTudoOk(oModel)
Local lRet       := .T.
Local aArea      := GetArea()
Local aAreaZVF   := ZVF->( GetArea() )
//Local oModel := FWModelActive()
Local nOperation := oModel:GetOperation()
Local cPeriodo  := oModel:GetValue("ZVFMASTER", "ZVF_PERIOD")
Local dData    := oModel:GetValue("ZVFMASTER", "ZVF_DATA")

If nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE
	If cPeriodo == ' ' .or. dtos(dData) = ' ' 
		Help(Nil, Nil, "VldTudoOk(ADFAT061P) Msg-01",,"Mes e Data Obrigatorio!", 1, 0 )
		lRet := .F.
	EndIf
EndIf

RestArea( aAreaZVF )
RestArea( aArea )

Return lRet

/*/{Protheus.doc} User Function ADCON019P
    Cria Estrutura de calendario de Metas de Vendas a partir de um arquivo TXT
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
Static Function FAT061A(oBrowse)
    Local bProcess 		:= {|oSelf| Executa(oSelf) }
    Local lOk		:= .F.
    Local alSay		:= {}
    Local alButton	:= {}
    Local clTitulo	:= 'IMPORTAÇÃO Estrutura Calendario de Metas de Vendas - ZVF '
    Local clDesc1   := 'O objetivo desta rotina é criar o calendario das Metas de Vendas. Arq.TXT.'
    Local clDesc2   := 'Regras:'
    Local clDesc3   := '- Incluirá um calendario de Meta qdo não existir o cadastro na tabela (ZVF);'
    Local clDesc4   := '- substituirá o calendario de Meta quando a coluna Entrega(S/N) estiver preenchida;'
    Local clDesc5   := '- Estrutura: MesAno;Data;Entrega'
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
        oProcess := tNewProcess():New("ImpADFAT061","Criando calendario das Metas de Vendas.",bProcess,clTitulo,cPerg,aInfoCustom, .T.,5, "ImpCalend.", .T. )
    EndIf
   
    oBrowse:Refresh()

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cria Estrutura de Metas de Vendas a partir de um excel')

Return

/*/{Protheus.doc} Static Function RUNADFAT061
    Importação do Calendario Mensal de Vendas
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
    Local nCount    := 0
    Local aDadZVF   := {}
    //Local aCampos   := {}

    //oView:GetModel("ZVFMASTER")

	cFile := cGetFile("Arquivos TXT (Separados por Vírgula) | *.TXT",;
    "Selecione o diretorio onde encontra-se o arquivo a ser processado", 0, "Servidor\", .t., GETF_LOCALFLOPPY + GETF_LOCALHARD + GETF_NETWORKDRIVE) // + GETF_RETDIRECTORY)


    If At(".TXT", upper(cFile)) > 0
        lFile := .t.
        ft_fUse(cFile)
    Else
        Aviso("ADFAT061-01", "Não foi possível abrir o arquivo...", {"&Ok"},, "Arquivo não identificado!")
    EndIf

    // Arquivo TXT
    If lFile
        
        ft_fGoTop()
        oProcess:SetRegua1(FT_FLASTREC())        
        cVerTab := "MesAno;Data;Entrega"

        cTxt := AllTrim(ft_fReadLn())
        
        If cVerTab <> cTXT
            
            Aviso("ADFAT061-02", "A importação não será realizada! As colunas do excel precisam ser " + cVerTab, {"&Ok"},, "Versão/Leiaute da planilha incorreta!")
            
        Else

            	nCount  := 0
                aDadZVF := {}

                ft_fSkip() // Pula linha do cabeçalho       
         
                // Geração ZVF
                Do While !ft_fEOF()
                    
                    cTxt    := ft_fReadLn()
                    aDadZVF := Separa(cTxt, ";")
                    
                    oProcess:IncRegua1("Gerando Calend..."+PADR(CTOD(aDadZVF[2]), 10 ))  

					//MesAno;Data;Entrega
					cZVF_PERIOD  := aDadZVF[1]
					cZVF_DATA    := PADR(CTOD(aDadZVF[2]), 10 )
					cZVF_ENTREG  := SUBSTR(aDadZVF[3],1,1)

                    lLockZVF := .t.
                    If !Empty(cZVF_PERIOD) .And. !Empty(cZVF_DATA)
                        ZVF->( dbSetOrder(1) ) // ZVF_FILIAL	ZVF_VENDED	ZVF_SUPERV	ZVF_GRUPO	ZVF_MESENT	ZVG_VLMETM	
                        If ZVF->( dbSeek(FWxFilial("ZVF")+DTOS(CTOD(ALLTRIM(cZVF_DATA)))+cZVF_PERIOD) )
                            lLockZVF := .f.
                        EndIf
                    EndIf
	
                    RecLock("ZVF", lLockZVF)
						If lLockZVF
							ZVF->ZVF_FILIAL	:= FWxFilial("ZVF")
							ZVF->ZVF_PERIOD	:= cZVF_PERIOD
							ZVF->ZVF_DATA   := CTOD(cZVF_DATA)
						EndIf
						ZVF->ZVF_ENTREG	:= cZVF_ENTREG
					ZVF->( msUnLock() )

                    aDadZVF := {}
                    
                    ft_fSkip()
                    
                EndDo
				
                ZVF->(dbSetOrder(1))    
				ZVF->(DbGotop())
              	
                Alert("Importação finalizada com sucesso!")
                
              EndIf
            
        EndIf
        
Return


