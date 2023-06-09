#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "FWMVCDEF.CH"

/*/{Protheus.doc} User Function ADEST055P
    Tela de manutenção dos cadastros:
        - Requisitos de Mercado (PGA).
        - Mercados.
        - Países.
        - Produtos.
    Chamado 8465
    @type  Function
    @author Leonardo P. Monteiro
    @since 12/02/2021
    @version 01
/*/

// --------------------------------------------------------------------------------------------------------
// Início da ViewDef e ModelDef.
// --------------------------------------------------------------------------------------------------------
Static Function ModelDef()
 Local oModel		:= MPFormModel():New("mdlADEST059P",, {|| .T.})
 Local oStrutZE2	:= FWFormStruct(1,"ZE2")
 
 U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Tela de manutenção dos cadastros PGA')
 

 oModel:SetDescription("..:: Cadastro Mercado ::..")
 
 // Cabeçalho ZT3 (Pedidos)
 oModel:addFields("CABEC_ZE2",nil,oStrutZE2)

 oModel:setPrimaryKey({"ZE2_FILIAL","ZE2_MERCAD","ZE2_ZE1REQ"})

return oModel


Static Function viewDef()
 Local oView		:= Nil
 Local oModel		:= FWLoadModel("ADEST059P")
 Local oStrutZE2	:= FWFormStruct(2,"ZE2")
  
 DbSelectArea("ZE2")
 
 ZE2->(DbSetOrder(1))
  
 oView	:= FWFormView():New()
 oView:setModel(oModel)
 
 oView:GetProgressBar(.T.)
 
 oView:addField("V_CABEC_ZE2",oStrutZE2,"CABEC_ZE2")
   
 oView:createHorizontalBox("H_CABEC",100)
 oView:createVerticalBox("V_CABEC",100	,"H_CABEC")
 
 oView:setOwnerView("V_CABEC_ZE2","V_CABEC")
 
 //oView:SetAfterOkButton({|oView|  fButAftAc(oView)}) 
 oView:SetViewAction("BUTTONOK"		, {|oView| fVldModel(oView)}) 
Return oView

Static Function fVldModel(oView)

	Local lRet			:= .T.
	Local oModel		:= FWModelActive()
	Local oModCAB		:= oModel:getModel("CABEC_ZE2")

	Local cReqMerc		:= oModCAB:getValue("ZE2_ZE1REG")
    //Local cMercado		:= oModCAB:getValue("ZE2_MERCAD")
    Local nOper         := oView:getOperation()
    
    // Opera��o de exclus�o.
    if nOper == 5
        If MsgYesNo("A exclus�o desse mercado ir� excluir todos os relacionamentos de Pa�ses e produtos homologados."+chr(13)+chr(10)+;
        " Deseja confirmar essa a��o?","Confirma��o de Exclus�o")
            lRet := .T.
        Else
            lRet := .F.
        EndIF

    endif

Return lRet
