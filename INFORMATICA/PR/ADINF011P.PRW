#Include 'Protheus.ch'
#Include 'FwMvcDef.ch'
#Include 'Parmtype.ch'
#Include "Topconn.ch"

//Vari�veis Est�ticas.
Static cTitulo := 'Cadastro de compra de Licen�a de Software'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADINF011P   � Autor � Everson          � Data �  06/12/17   ���
�������������������������������������������������������������������������͹��
���Descricao �Produtos com exce��o de desconto.                           ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADINF011P() // U_ADINF011P()
		
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������	
	Local aArea	   := GetArea()
	Local oBrowse  := Nil
	Local cFunName := FunName()
	
	ChkFile("ZCB")
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Produtos com exce��o de desconto.')
	
	ChkFile("ZCB")
	
	SetFunName("ADINF011P")
		
		DbSelectArea("ZCB")
		ZCB->(DbSetOrder(1))
		ZCB->(DbGoTop())
		oBrowse := FWMBrowse():New()
		oBrowse:SetAlias("ZCB")
		oBrowse:SetDescription(cTitulo)

		oBrowse:Activate()
		
	SetFunName(cFunName)
	
	RestArea(aArea)
	
Return Nil

Static Function ModelDef()
		
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������
	Local oModel := Nil
	Local oStruct:= FwFormStruct(1,'ZCB')
	
	oModel:= MpFormModel():New('_VEN060P',Nil)
	oModel:AddFields('MASTERALIAS',Nil,oStruct)
	oModel:SetDescription(cTitulo)
	oModel:GetModel('MASTERALIAS'):SetDescription(cTitulo)
	
	oModel:SetPrimaryKey({})

Return oModel

Static Function ViewDef()
		
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������
	Local oModel := ModelDef()
	Local oStruct:= FwFormStruct(2,'ZCB')
	Local oView  := FwFormView():New()
	
	oView:SetModel(oModel)
	oView:AddField('VIEW_MASTER',oStruct,'MASTERALIAS')
	oView:CreateHorizontalBox('TELA',100)
	oView:SetOwnerView('VIEW_MASTER','TELA')

Return oView

Static Function MenuDef()	
	
	Local aRotina 		:= {}
	Private bSFExportar	:= {||sfExportar()}
	
	ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.ADINF011P'   OPERATION 2  ACCESS 0
	ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.ADINF011P' OPERATION 3  ACCESS 0
	ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.ADINF011P' OPERATION 4  ACCESS 0
	ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.ADINF011P' OPERATION 5  ACCESS 0
	ADD OPTION aRotina Title 'Imprimir'    Action 'VIEWDEF.ADINF011P' OPERATION 8  ACCESS 0
	ADD OPTION aRotina Title 'Copiar'      Action 'VIEWDEF.ADINF011P' OPERATION 9  ACCESS 0
	
Return aRotina