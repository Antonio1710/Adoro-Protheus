#INCLUDE "totvs.ch"
#INCLUDE "FWMVCDef.ch"

/*/{Protheus.doc} User Function ADGPE084P
    Cadastro de hor�rios e turnos dos eleg�veis (Frango).
    @type  Function
    @author Leonardo P. Monteiro
    @since 07/09/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)

    U_ADGPE084P()
/*/

#define ZHLEXCLUS  '|ZHL_FILIAL|' // Registro de produtos.
#define ZHPEXCLUS  '|ZHP_FILIAL|ZHP_CODZHL|' // Embalagens.

Static cTitulo := "..:: Cadastro Arm�rios ::.."

User Function ADGPE084P()
    Local aArea   := GetArea()
    Local oBrowse
    //Local cFunBkp := FunName()
     
    SetFunName("ADGPE084P")

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Grupo de inspe��o Relacionado na tabela de clientes SA1 e SC5')
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMarkBrowse():New()
     
    //Setando a tabela de cadastro de grupo de inspe��o
    oBrowse:SetAlias("ZHL")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)

    //Ativa a Browse
    oBrowse:Activate()
     
    //SetFunName(cFunBkp)
    RestArea(aArea)
Return .T.

Static Function MenuDef() 

	Local aRotina := {}  
	
	ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.ADGPE084P' OPERATION MODEL_OPERATION_INSERT ACCESS 0 DISABLE MENU
	ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.ADGPE084P' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 DISABLE MENU
	ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.ADGPE084P' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 DISABLE MENU
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.ADGPE084P' OPERATION MODEL_OPERATION_DELETE ACCESS 0 DISABLE MENU
    
Return aRotina

// --------------------------------------------------------------------------------------------------------
// Início da ViewDef e ModelDef.
// --------------------------------------------------------------------------------------------------------
Static Function ModelDef()
    Local oModel		:= MPFormModel():New("mdlADGPE084P",, {|| .T.})
    Local oStrutZHL	:= FWFormStruct(1,"ZHL")
    Local oStrutZHP	:= FWFormStruct(1,"ZHP")
    Local aZHLZHP   := {}
    
    oModel:SetDescription(cTitulo)
    
    oModel:addFields("CABECZHL",nil,oStrutZHL)
    oModel:addGrid("DETAIZHP","CABECZHL", oStrutZHP)

    oModel:GetModel("DETAIZHP"):SetDescription("Historico de Limpeza")
    oModel:GetModel("DETAIZHP"):SetOptional(.T.)
    oModel:GetModel("DETAIZHP"):SetOnlyQuery(.T.)
    oModel:GetModel("DETAIZHP"):SetNoInsertLine(.T.)
    oModel:GetModel("DETAIZHP"):SetNoUpdateLine(.T.)
    oModel:GetModel("DETAIZHP"):SetNoDeleteLine(.T.)

    aAdd( aZHLZHP, {"ZHP_FILIAL", "ZHL_FILIAL"} )
    aAdd( aZHLZHP, {"ZHP_CODZHL", "ZHL_CODIGO"} )

    oModel:SetRelation("DETAIZHP", aZHLZHP, ZHP->(IndexKey(1)) ) // IndexKey -> quero a ordenacao e depois filtrado

    oModel:setPrimaryKey({"ZHL_FILIAL","ZHL_CODIGO"})

return oModel


Static Function viewDef()
    Local oView		:= Nil
    Local oModel		:= FWLoadModel("ADGPE084P")
    Local oStrutZHL	:= FWFormStruct(2,"ZHL",{| cCampo | !(AllTrim( cCampo ) + '|' $ ZHLEXCLUS)  })
    Local oStrutZHP	:= FWFormStruct(2,"ZHP",{| cCampo | !(AllTrim( cCampo ) + '|' $ ZHPEXCLUS)  })
    
    DbSelectArea("ZHL")
    
    ZHL->(DbSetOrder(1))
    
    oView	:= FWFormView():New()
    oView:setModel(oModel)
    
    oView:GetProgressBar(.T.)
    
    oView:addField("V_CABECZHL",oStrutZHL,"CABECZHL")
    oView:AddGrid("DETAIL_ZHP",oStrutZHP, "DETAIZHP")

    
    oView:createHorizontalBox("H_CABEC",30)
    oView:createHorizontalBox("H_DETAI",70)

    oView:setOwnerView("V_CABECZHL","H_CABEC")
    oView:setOwnerView("DETAIL_ZHP","H_DETAI")
  
Return oView
