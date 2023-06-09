#INCLUDE "PROTHEUS.CH"  
#INCLUDE "AP5MAIL.CH"     
#INCLUDE "rwmake.ch"  
#INCLUDE "topconn.ch"
#INCLUDE 'FWMVCDEF.CH'  

/*/{Protheus.doc} User Function ADGPE045P
	Modelo 1 da tabela ZFG Usuario Protheus X Usuario Dimep
	@type  Function
	@author WILLIAM COSTA
	@since 19/03/2019
	@version 01
	@history TICKET  224 - William Costa - 11/11/2020 - Altera��o do Fonte na parte de Funcion�rios, trocar a integra��o do Protheus para a Integra��o do RM
	/*/
USER FUNCTION ADGPE045P()
         
    Local aArea   	  := GetArea()  
    Local oBrowse   
    Local cFiltro     := ''         
    Local cFunNamBkp  := FunName()
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Modelo 1 da tabela ZFG Usuario Protheus X Usuario Dimep')
    
	SetFunName("ADGPE045P")
	
	// Instanciamento da Classe de Browse 
	oBrowse := FWMBrowse():New() 
	 
	// Defini��o da tabela do Browse 
	oBrowse:SetAlias('ZFG') 
	 
	// Defini��o da legenda 
	//oBrowse:AddLegend( "!EMPTY(ZFG_CODDE) .AND. !EMPTY(ZFG_CODPAR)", "RED", "COD EAN AJUSTADO"  ) 
	    
	// Titulo da Browse 
	oBrowse:SetDescription('Usuario Protheus X Usuario Dimep') 
	 
	// Opcionalmente pode ser desligado a exibi��o dos detalhes 
	//oBrowse:DisableDetails() 
	 
	// Ativa��o da Classe 
	oBrowse:Activate() 
	        
	SetFunName("cFunNamBkp")
	RestArea(aArea)
	 
Return NIL

Static Function ModelDef() 
               
	// Cria a estrutura a ser usada no Modelo de Dados 
	Local oStruZFG := FWFormStruct( 1, 'ZFG' ) 
	Local oModel // Modelo de dados que ser� constru�do 
	  
	// Cria o objeto do Modelo de Dados 
	oModel := MPFormModel():New( '_GPE047P' )           
	 
	// Adiciona ao modelo um componente de formul�rio 
	oModel:AddFields( 'ZFGMASTER', /*cOwner*/, oStruZFG )
	
	oModel:SetPrimaryKey( { "ZFG_FILIAL", "ZFG_CODUSR" } )       
	        
	// Adiciona a descri��o do Modelo de Dados 
	oModel:SetDescription( 'Modelo Usuario Protheus X Usuario Dimep' )
	 
	// Adiciona a descri��o do Componente do Modelo de Dados 
	oModel:GetModel( 'ZFGMASTER' ):SetDescription( 'Usuario Protheus X Usuario Dimep' )  
      
// Retorna o Modelo de dados 
Return oModel     

Static Function ViewDef()                                                         

	// Cria um objeto de Modelo de dados baseado no ModelDef() do fonte informado 
	Local oModel := FWLoadModel( 'ADGPE045P' )        
	
	// Cria a estrutura a ser usada na View 
	Local oStruZFG := FWFormStruct( 2, 'ZFG' ) 
	 
	// Interface de visualiza��o constru�da 
	Local oView   
	
	// Cria o objeto de View 
	oView := FWFormView():New() 
	 
	// Define qual o Modelo de dados ser� utilizado na View 
	oView:SetModel( oModel ) 
    
	// Adiciona no nosso View um controle do tipo formul�rio  
	// (antiga Enchoice) 
	oView:AddField( 'VIEW_ZFG', oStruZFG, 'ZFGMASTER' ) 
	   
	// Criar um "box" horizontal para receber algum elemento da view 
	oView:CreateHorizontalBox( 'TELA' , 100 ) 
	
	// Relaciona o identificador (ID) da View com o "box" para exibi��o 
	oView:SetOwnerView( 'VIEW_ZFG', 'TELA' )  
	
	//Colocando t�tulo do formul�rio
	
	oView:EnableTitleView('VIEW_ZFG', 'Usuario Protheus X Usuario Dimep' )  
	
    //For�a o fechamento da janela na confirma��o
	
	oView:SetCloseOnOk({||.T.})
	
	//O formul�rio da interface ser� colocado dentro do container
	
	oView:SetOwnerView("VIEW_ZFG","TELA")

// Retorna o objeto de View criado 	
Return oView 

Static Function MenuDef() 

	Local aRotina := {}  
	
		ADD OPTION aRotina TITLE 'Incluir'    ACTION 'VIEWDEF.ADGPE045P' OPERATION MODEL_OPERATION_INSERT ACCESS 0
		ADD OPTION aRotina TITLE 'Alterar'    ACTION 'VIEWDEF.ADGPE045P' OPERATION MODEL_OPERATION_UPDATE ACCESS 0
		ADD OPTION aRotina TITLE 'Visualizar' ACTION 'VIEWDEF.ADGPE045P' OPERATION MODEL_OPERATION_VIEW   ACCESS 0 
		ADD OPTION aRotina TITLE 'Excluir'    ACTION 'VIEWDEF.ADGPE045P' OPERATION MODEL_OPERATION_DELETE ACCESS 0 
		 
Return aRotina                           
