#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#Include "RwMake.ch"
#Include "Totvs.ch"
#Include "Topconn.ch"

// ##########################################################################################
// Projeto: Cadastro de Lote de Criação por Centro de Custo
// Modulo : SIGAFAT
// Fonte  : ADFAT008P
// ---------+-------------------+--------------------------------------------+---------------
// Data     | Autor             | Descricao                                  | Chamado
// ---------+-------------------+--------------------------------------------+---------------
// 08/10/18 | Ricardo Lima      | Lote de Criação por Centro de Custo        | 037647
// ---------+-------------------+--------------------------------------------+---------------
// 26/06/19 | FWNM              | Obrigatoriedade condicional ZVN_REVISA     | 048153/049708
// ---------+-------------------+--------------------------------------------+---------------
// ##########################################################################################
//@history Everson, 15/12/2022 - ticket 84225 - Adicionado log.
User Function ADFAT008P()

    LOCAL oBrowse
    PRIVATE aRotina := MnDef()

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Lote de Criação por Centro de Custo')

    oBrowse := FWMBrowse():New()
    oBrowse:SetAlias("ZCN")
    oBrowse:SetDescription("Lote de Criação por Centro de Custo")
        
    oBrowse:Activate()

Return

// ##########################################################################################
// Projeto: Cadastro de Lote de Criação por Centro de Custo
// Modulo : SIGAFAT
// Fonte  : MnDef
// ---------+-------------------+--------------------------------------------+---------------
// Data     | Autor             | Descricao                                  | Chamado
// ---------+-------------------+--------------------------------------------+---------------
// 08/10/18 | Ricardo Lima      | Lote de Criação por Centro de Custo        | 037647
// ---------+-------------------+--------------------------------------------+---------------
// ##########################################################################################

STATIC Function MnDef()

	LOCAL aRotina := {}

	ADD OPTION aRotina TITLE "Visualizar"      ACTION "VIEWDEF.ADFAT008P" OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Incluir"         ACTION "VIEWDEF.ADFAT008P" OPERATION 3 ACCESS 0
	ADD OPTION aRotina TITLE "Alterar"         ACTION "VIEWDEF.ADFAT008P" OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Excluir"         ACTION "VIEWDEF.ADFAT008P" OPERATION 5 ACCESS 0

Return aRotina

// ##########################################################################################
// Projeto: Cadastro de Lote de Criação por Centro de Custo
// Modulo : SIGAFAT
// Fonte  : ModelDef
// ---------+-------------------+--------------------------------------------+---------------
// Data     | Autor             | Descricao                                  | Chamado
// ---------+-------------------+--------------------------------------------+---------------
// 08/10/18 | Ricardo Lima      | Lote de Criação por Centro de Custo        | 037647
// ---------+-------------------+--------------------------------------------+---------------
// ##########################################################################################

STATIC Function ModelDef()

	LOCAL oModel
	LOCAL oStruZCN := FWFormStruct( 1, "ZCN", /*bAvalCampo*/, /*lViewUsado*/ )

	// Chamado n. 048153 | Obrigatoriedade condicional ZVN_REVISA | FWNM | 26/06/2019 
	Local bVldPos := {|| u_ZCNPos()} // Validacao ao clicar no botao confirmar

	// Editando caracteristicas do dicionario
	oStruZCN:SetProperty("ZCN_ARMAZE", MODEL_FIELD_OBRIGAT, .T.) // CAMPO OBRIGATORIO
	oStruZCN:SetProperty("ZCN_CENTRO", MODEL_FIELD_OBRIGAT, .T.) // CAMPO OBRIGATORIO
	
	oStruZCN:SetProperty("ZCN_TIPO",  MODEL_FIELD_WHEN, FWBuildFeature(STRUCT_FEATURE_WHEN, '.F.')) // MODO EDICAO
	// 

	oModel := MPFormModel():New("ModelDef_MVC", /*bPreValidacao*/, bVldPos, /*bCommit*/, /*bCancel*/ )

	oModel:SetDescription("Lote de Criação por Centro de Custo")
	oModel:AddFields("ZCNMASTER", /*cOwner*/, oStruZCN, /*bPreValidacao*/, /*bPosValidacao*/, /*bCarga*/ )
	oModel:SetPrimaryKey( {"ZCN_FILIAL" } )

Return oModel

// ##########################################################################################
// Projeto: Cadastro de Lote de Criação por Centro de Custo
// Modulo : SIGAFAT
// Fonte  : ViewDef
// ---------+-------------------+--------------------------------------------+---------------
// Data     | Autor             | Descricao                                  | Chamado
// ---------+-------------------+--------------------------------------------+---------------
// 08/10/18 | Ricardo Lima      | Lote de Criação por Centro de Custo        | 037647
// ---------+-------------------+--------------------------------------------+---------------
// ##########################################################################################

STATIC Function ViewDef()

	Local oView
	Local oModel	:= ModelDef()
	Local oStruZCN	:= FWFormStruct( 2, "ZCN" )

	oView := FWFormView():New()

	oView:SetModel( oModel )
	oView:AddField("VIEW_ZCN", oStruZCN, "ZCNMASTER" )
	oView:CreateHorizontalBox("TELA" , 100 )
    oView:SetCloseOnOk( { || .T. } )

Return oView

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ZCNPOS    ºAutor  ³Fernando Macieira   º Data ³  26/06/19   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Funcao chamada no clique do botao OK do modelo de dados    º±±
±±º          ³ (POS-VALIDACAO)                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºChamado   ³ N. 048153 | Obrigatoriedade condicional ZVN_REVISA         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ZCNPos()

	Local oModelPad := FWModelActive()
	Local cTipo     := AllTrim(oModelPad:GetValue("ZCNMASTER", "ZCN_TIPO"))
	Local cRevisa   := AllTrim(oModelPad:GetValue("ZCNMASTER", "ZCN_REVISA"))
	Local lRet      := .t.
	Local cMVTipo   := AllTrim(GetMV("MV_#SAGTIP",,"PRODUCAO"))
	Local cTexto    := ""
	Local nOpc      := oModelPad:GetOperation()

	U_ADINF009P('ADFAT008P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Lote de Criação por Centro de Custo')
	                      
	If cTipo == cMVTipo .and. Empty(cRevisa) 
		lRet := .f.
		Aviso("Atenção", "Obrigatório o preencimento do campo revisão quando o tipo do lote for " + cMVTipo, {"OK"}, 03)
	EndIf

	If lRet
		cTexto := "Operacao " + cValToChar(nOpc) + " - Lote/Desc/Status "  + AllTrim(oModelPad:GetValue("ZCNMASTER", "ZCN_LOTE")) + " " + AllTrim(oModelPad:GetValue("ZCNMASTER", "ZCN_DESCLT")) + " " + AllTrim(oModelPad:GetValue("ZCNMASTER", "ZCN_STATUS")) 
		
		logZBE(cTexto)

	EndIf

Return lRet
/*/{Protheus.doc} Static Function LOGZBE
	Gera log ZBE
	@type  Static Function
	@author Everson
	@since 15/12/2022
	@version 01
/*/
Static Function logZBE(cMensagem)

	RecLock("ZBE", .T.)
		Replace ZBE_FILIAL 	   	With FWxFilial("ZBE")
		Replace ZBE_DATA 	   	With msDate()
		Replace ZBE_HORA 	   	With Time()
		Replace ZBE_USUARI	    With Upper(Alltrim(cUserName))
		Replace ZBE_LOG	        With cMensagem
		Replace ZBE_MODULO	    With "FATURAMENTO"
		Replace ZBE_ROTINA	    With "ADFAT008P" 
	ZBE->( msUnlock() )

Return
