#include "Protheus.ch"
#include "FWMVCDef.ch"

// Variaveis estaticas
Static cTitulo  := "Cadastro de Sponsor do Projeto"
Static cDefault := "DEFAULT"
Static cTabela  := "ZCH"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPMS003P     �Autor  �FERNANDO MACIEIRA           � Data �  02/03/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � CADASTRO SPONSOR - Modelo 1 com validacoes                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � ADORO                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ADPMS003P()

Local oBrowse
Local aAreaAtu := GetArea()
Local cFunBkp  := FunName()

PRIVATE aRotina		:= MenuDef()

SetFunName("ADPMS003P")

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'CADASTRO SPONSOR - Modelo 1 com validacoes')

// Instanciando FWMBROWSE - Somente com dicionario de dados
oBrowse := FWMBrowse():New()

// Setando a tabela de cadastros 
oBrowse:SetAlias(cTabela)

// Setando a descricao da rotina
oBrowse:SetDescription(cTitulo)

// Ativa o browse
oBrowse:Activate()

SetFunName(cFunBkp)

RestArea(aAreaAtu)

Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPMS003P     �Autor  �Microsiga           � Data �  11/28/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Criacao do MENU MVC                                        ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MenuDef()


LOCAL aRotina := {}

// Adicionando opcoes
ADD OPTION aRotina TITLE "Visualizar" ACTION "VIEWDEF.ADPMS003P" OPERATION MODEL_OPERATION_VIEW   ACCESS 0 // OPERACAO 1
ADD OPTION aRotina TITLE "Incluir"    ACTION "VIEWDEF.ADPMS003P" OPERATION MODEL_OPERATION_INSERT ACCESS 0 // OPERACAO 3
ADD OPTION aRotina TITLE "Alterar"    ACTION "VIEWDEF.ADPMS003P" OPERATION MODEL_OPERATION_UPDATE ACCESS 0 // OPERACAO 4
ADD OPTION aRotina TITLE "Excluir"    ACTION "VIEWDEF.ADPMS003P" OPERATION MODEL_OPERATION_DELETE ACCESS 0 // OPERACAO 5

Return aRotina



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPMS003P     �Autor  �Microsiga           � Data �  11/28/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Criacao do MODELO de dados MVC                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ModelDef()

// Criacao do objeto do modelo de dados
Local oModel

// Criacao da estrutura de dados utilizada na interface
Local oStDad := FWFormStruct(1, cTabela)


// Instanciando o modelo, nao e recomendado colocar o nome da user function (por causa do u_), respeitando o limite de 10 caracteres
//oModel := MPFormModel():New("ADPMS003P", bVldPre, bVldPos, bVldCom, bVldCan)
oModel := MPFormModel():New("MODELDEF_MVC")

// Atribuindo formularios para o modelo 
oModel:AddFields("FORMZCH", /*cOwner*/, oStDad)

// Setando a chave primaria da rotina
oModel:SetPrimaryKey({"ZCH_FILIAL","ZCH_CODIGO"})

Return oModel




/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPMS003P     �Autor  �Microsiga           � Data �  11/28/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Criacao da VISAO MVC                                       ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ViewDef()

Local aStruZZ1 := ZCH->( dbStruct() )

// Criacao do objeto do modelo de dados da interface do cadastro
Local oModel := FWLoadModel("ADPMS003P")

// Criacao da estrutura de dados utilizada na interface do cadastro
Local oStDad := FWFormStruct(2, cTabela) // pode se usar um terceiro parametro para filtrar os campos exibidos [ |cCampo| cCampo $ "SZZ1_NOME|SZZ1_

// Criando oView como nulo
Local oView := Nil

// Criando a VIEW que sera o retorno da funcao e setando o modelo da rotina
oView := FWFormView():New()
oView:SetModel(oModel)
                      
// Atribuindo formularios para interface
oView:AddField("VIEW_ZCH", oStDad, "FORMZCH")

// Criando container com nome tela 100%
oView:CreateHorizontalBox("TELA", 100)

// Colocando titulo do formulario
oView:EnableTitleView("VIEW_ZCH", "Dados - " + cTitulo)

// Forca o fechamento da janela na confirmacao
oView:SetCloseOnOK( {|| .t.} )
                        
// O formulario da interface sera colocado dentro do container
oView:SetOwnerView("VIEW_ZCH", "TELA")

Return oView
            













/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPMS003P     �Autor  �Microsiga           � Data �  11/28/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao chamada na criacao do modelo de dados               ���
���          � (PRE-VALIDACAO)                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
                     
User Function zzM1Pre()

Local oModelPad := FWModelActive()
Local nOpc      := oModelPad:GetOperation()
Local lRet      := .t.

U_ADINF009P('ADPMS003P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'CADASTRO SPONSOR - Modelo 1 com validacoes')

// Se for inclusao ou exclusao
If nOpc == MODEL_OPERATION_INSERT
	//If RetCodUsr() == "000000"
		oModelPad:GetModel("FORMZCH"):GetStruct():SetProperty("ZCH_CODIGO", MODEL_FIELD_WHEN, FWBuildFeature(STRUCT_FEATURE_WHEN, ".T."))
	//EndIf
EndIf

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPMS003P     �Autor  �Microsiga           � Data �  11/28/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao chamada no clique do botao OK do modelo de dados    ���
���          � (POS-VALIDACAO)                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function zzM1Pos()

Local oModelPad := FWModelActive()
Local cDescri   := oModelPad:GetValue("FORMZCH", "ZCH_NOME")
Local lRet      := .t.

U_ADINF009P('ADPMS003P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'CADASTRO SPONSOR - Modelo 1 com validacoes')
                      
// Se a descricao estiver em branco
If Empty(cDescri)
	lRet := .f.
	Aviso("Aten��o", "Campo NOME est� em branco!", {"OK"}, 03)
EndIf

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPMS003P     �Autor  �Microsiga           � Data �  11/28/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao chamada apos validar o OK da rotina para os dados   ���
���          � serem salvos                                               ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function zzM1Com()

Local cModelPad := FWModelActive()
Local cCodigo   := oModelPad:GetValue("FORMZCH", "ZCH_CODIGO")
Local cDescri   := oModelPad:GetValue("FORMZCH", "ZCH_NOME")
Local nOpc      := oModelPad:GetOperation()
Local lRet      := .t.

U_ADINF009P('ADPMS003P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'CADASTRO SPONSOR - Modelo 1 com validacoes')

// Se for inclusao
If nOpc == MODEL_OPERATION_INSERT
	
	RecLock("ZCH", .T.)
		ZCH_FILIAL := FWxFilial("ZCH")
		ZCH_CODIGO := cCodigo
		ZCH_NOME   := cDescri
	ZCH->( msUnLock() )
	ConfirmSX8()
	
	Aviso("Aten��o", "Inclus�o realizada!", {"OK"}, 03)
		
// Se for alteracao
ElseIf nOpc == MODEL_OPERATION_UPDATE
	
	RecLock("ZCH", .F.)
		ZCH_NOME := cDescri
	ZCH->( msUnLock() )   
	
	Aviso("Aten��o", "Altera��o realizada!", {"OK"}, 03)
	
// Se for exclusao
ElseIf nOpc == MODEL_OPERATION_DELETE

	RecLock("ZCH", .F.)
		dbDelete()
	ZCH->( msUnLock() )   
	
	Aviso("Aten��o", "Exclus�o realizada!", {"OK"}, 03)
                              
EndIf

Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPMS003P     �Autor  �Microsiga           � Data �  11/28/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao chamada ao CANCELAR as informacoes do modelo dados  ���
���          � (botao CANCELAR)                                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function zzM1Can()

Local oModelPad := FWModelActive()
Local lRet      := .t.

U_ADINF009P('ADPMS003P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'CADASTRO SPONSOR - Modelo 1 com validacoes')

// Somente permite cancelar se o usuario confirmar
lRet := MsgYesNo("Deseja cancelar a opera��o?", "Aten��o")

Return lRet



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADPMS003P     �Autor  �Microsiga           � Data �  11/28/17   ���
�������������������������������������������������������������������������͹��
���Desc.     � Define se pode abrir o Modelo de Dados                     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function fAlterar( oModel )

Local lRet       := .t.
Local nOperation := oModel:GetOperation()

// Se for exclusao
If nOperation == MODEL_OPERATION_DELETE
	If RetCodUsr() <> "000000"
		lRet := .f.
		Aviso("Aten��o", "Somente o admin pode excluir registros!", {"OK"}, 03)
	EndIf
EndIf

Return lRet
