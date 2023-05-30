#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'
//-------------------------------------------------------------------
/*/{Protheus.doc} ADFIS053P
Parametros CAT 83 Ev Produtos em MVC

@author Antonio Domingos
@since 08/11/2022
@version P10
@history Ticket 78168  - 08/11/2022 - Antonio Domingos - RELATÓRIOS PORTARIA CAT/83


/*/
//-------------------------------------------------------------------
User Function ADFIS053P()

    Local oBrowse
       
    SetFunName("ADFIS053P")
     
oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'ZVH' )
oBrowse:SetDescription( 'Param Rel CAT83 Ev Produtos' )
oBrowse:Activate()


Return NIL


//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.ADFIS053P' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.ADFIS053P' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.ADFIS053P' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.ADFIS053P' OPERATION 5 ACCESS 0 
ADD OPTION aRotina Title 'Imprimir'    Action 'VIEWDEF.ADFIS053P' OPERATION 8 ACCESS 0

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZVH := FWFormStruct( 1, 'ZVH', /*bAvalCampo*/, /*lViewUsado*/ )
Local bVldPos    := {|oModel| VldTudoOk(oModel)  }
Local oModel

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'FIS053M', /*bPreValidacao*/, bVldPos /*FIS053POS( oModel )*/, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZVHMASTER', /*cOwner*/, oStruZVH )

oModel:SetPrimaryKey( { "ZVH_FILIAL", "ZVH_CODIGO", "ZVH_DESCRI" } )  

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Param Rel Ev Prod' )

// Adiciona a descricao do Meta do Modelo de Dados
oModel:GetModel( 'ZVHMASTER' ):SetDescription( 'Ev Produto' )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oStruZVH := FWFormStruct( 2, 'ZVH' )

// Cria a estrutura a ser usada na View
Local oModel   := FWLoadModel( 'ADFIS053P' )
Local oView

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_ZVH', oStruZVH, 'ZVHMASTER' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 100 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZVH', 'SUPERIOR' )

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} VldTudoOk()
Inclui dados do Ordem de Serviço na tabela ZVH-Ordem de Serviço
Quando há alteração nos campos de Transportadora e ou Placa do veiculo.
@author Antonio Domingos
@since 06/09/2022
@version P10
@history Ticket 78168 - 08/11/2022 - Antonio Domingos - RELATÓRIOS PORTARIA CAT/83

/*/

//-------------------------------------------------------------------
Static Function VldTudoOk(oModel)
Local lRet       := .T.
Local aArea      := GetArea()
Local aAreaZVH   := ZVH->( GetArea() )
//Local oModel := FWModelActive()
Local nOperation := oModel:GetOperation()
Local cCODIGO  := oModel:GetValue("ZVHMASTER", "ZVH_CODIGO")

If nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE
	If cCodigo == ' '   
		Help(Nil, Nil, "VldTudoOk(ADFIS053P) Msg-01",,"CODIGO Obrigatorio!", 1, 0 )
		lRet := .F.
	EndIf
EndIf

RestArea( aAreaZVH )
RestArea( aArea )

Return lRet


