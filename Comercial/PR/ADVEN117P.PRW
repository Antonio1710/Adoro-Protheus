#INCLUDE "totvs.ch"
#INCLUDE "FWMVCDef.ch"

/*/{Protheus.doc} User Function ADVEN117P
    Cadastro de dias �teis, DSR e dias totais por m�s.
    @type  Function
    @author Leonardo P. Monteiro
    @since 07/09/2021
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history Ticket  64069  - Leonardo P. Monteiro  - 23/11/2021 - Cria��o de cadastro de DSR.
    @history Ticket  64069  - Leonardo P. Monteiro  - 06/12/2021 - Grava��o de logs de altera��o.
    
/*/

Static cTitulo := "..:: Cadastro Dias �teis por M�s ::.."

User Function ADVEN117P()
    Local aArea   := GetArea()
    Local oBrowse
    //Local cFunBkp := FunName()
     
    SetFunName("ADVEN117P")

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Grupo de inspe��o Relacionado na tabela de clientes SA1 e SC5')
     
    //Inst�nciando FWMBrowse - Somente com dicion�rio de dados
    oBrowse := FWMarkBrowse():New()
     
    //Setando a tabela de cadastro de grupo de inspe��o
    oBrowse:SetAlias("ZHA")
 
    //Setando a descri��o da rotina
    oBrowse:SetDescription(cTitulo)

    //Ativa a Browse
    oBrowse:Activate()
     
    //SetFunName(cFunBkp)
    RestArea(aArea)
Return .T.

Static Function MenuDef() 

	Local aRotina := {}  
	
	ADD OPTION aRotina TITLE 'Incluir'      ACTION 'VIEWDEF.ADVEN117P' OPERATION MODEL_OPERATION_INSERT ACCESS 0 DISABLE MENU
	ADD OPTION aRotina TITLE 'Visualizar'   ACTION 'VIEWDEF.ADVEN117P' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 DISABLE MENU
	ADD OPTION aRotina TITLE 'Alterar'      ACTION 'VIEWDEF.ADVEN117P' OPERATION MODEL_OPERATION_UPDATE ACCESS 0 DISABLE MENU
    ADD OPTION aRotina TITLE 'Excluir'      ACTION 'VIEWDEF.ADVEN117P' OPERATION MODEL_OPERATION_DELETE ACCESS 0 DISABLE MENU
    
Return aRotina

// --------------------------------------------------------------------------------------------------------
// Início da ViewDef e ModelDef.
// --------------------------------------------------------------------------------------------------------
Static Function ModelDef()
 Local oModel		:= MPFormModel():New("mdlADVEN117P",, {|| ZHAPos()})
 Local oStrutZHA	:= FWFormStruct(1,"ZHA")
 
 oModel:SetDescription(cTitulo)
 
 oModel:addFields("CABEC_ZHA",nil,oStrutZHA)

 oModel:setPrimaryKey({"ZHA_FILIAL","ZHA_ANOMES"})

return oModel

Static Function ZHAPos()

	Local oModelVld := FWModelActive()
	
	Local cPeriodo  := oModelVld:GetValue("CABEC_ZHA", "ZHA_ANOMES")
	Local nTotDias  := oModelVld:GetValue("CABEC_ZHA", "ZHA_DIATOT")
	Local nDUteis   := oModelVld:GetValue("CABEC_ZHA", "ZHA_DUTEIS")
	Local nDSR      := oModelVld:GetValue("CABEC_ZHA", "ZHA_DSR")
    Local nOper     := oModelVld:GetOperation()
	
	Local lRet      := .t.

	DbSelectArea("ZBE")
	RecLock("ZBE",.T.)
		Replace ZBE_FILIAL 	   	With xFilial("ZBE")
		Replace ZBE_DATA 	   	With Date()
		Replace ZBE_HORA 	   	With Time()
		Replace ZBE_USUARI	    With Upper(Alltrim(cUserName))
		Replace ZBE_LOG	        With "ADVEN117P - Altera��o de registros"
		Replace ZBE_PARAME 		With 'Alterado o per�odo'+cPeriodo+",Opera��o: "+ cValtochar(nOper) +", Dias Totais: "+ cValtochar(nTotDias)+", Dias �teis: "+ cValtochar(nDUteis)+", Dias DSR: "+ cValtochar(nDSR)
		Replace ZBE_MODULO	    With "COMERCIAL"
		Replace ZBE_ROTINA	    With "ADVEN117P" 
	MsUnlock()
	
Return lRet

Static Function viewDef()
 Local oView		:= Nil
 Local oModel		:= FWLoadModel("ADVEN117P")
 Local oStrutZHA	:= FWFormStruct(2,"ZHA")
  
 DbSelectArea("ZHA")
 
 ZHA->(DbSetOrder(1))
  
 oView	:= FWFormView():New()
 oView:setModel(oModel)
 
 oView:GetProgressBar(.T.)
 
 oView:addField("V_CABEC_ZHA",oStrutZHA,"CABEC_ZHA")
   
 oView:createHorizontalBox("H_CABEC",100)
 oView:createVerticalBox("V_CABEC",100	,"H_CABEC")
 
 oView:setOwnerView("V_CABEC_ZHA","V_CABEC")
  
Return oView
