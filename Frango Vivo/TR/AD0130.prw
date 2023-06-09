#Include "rwmake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"

/*/
	Programa  �NOVO3     � Autor � AP6 IDE            � Data �  10/08/17  
	Descricao � Codigo gerado pelo AP6 IDE.                               
	Uso       � AP6 IDE                                                   
	Alteracao � William Costa 12/02/2019 046955 Adiciona Valida��o Alterar
	@history Ticket 69574   - Abel Babini          - 25/04/2022 - Projeto FAI
	@history Ticket 79442   - Adriano Savoine      - 07/09/2022 - N�o permite alterar ordens fechadas.
	@history TICKET 86586   - ADRIANO SAVOINE      - 09/02/2023 - Criado um novo campo na tela para alterar o numero do Galp�o da apanha de aves.
/*/

User Function AD0130() //U_AD0130()

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Frango Vivo')
	
	Private cCadastro := "Cadastro de Frango Vivo"
	PRIVATE aCores    := {{"ZV1_STATUS='I'"  	     ,"BR_AZUL" },;
	                       {"ZV1_STATUS='R'"  	     ,"BR_LARANJA"},;
	                       {"ZV1_STATUS='M'"  	     ,"BR_MARRON"},;
	                       {"ZV1_STATUS='G'"  	     ,"BR_VERDE"},;
	                       {"ALLTRIM(ZV1_STATUS)=''" ,"BR_PRETO"}}
	Private aRotina   := {{"Pesquisar"          ,"AxPesqui"               ,0,1},;
	                       {"Visualizar "       ,"AxVisual"               ,0,2},;
	                       { "Alterar   "       ,"U_XAltZV1" 	   		  ,0,3},; //Fernando Sigoli Chamado:043085 13/08/2018
	                       {"Guia Cupom       " ,'ExecBlock("AD0145")'    ,0,4},;                    
	                       {"Gerar Frete      " ,'ExecBlocK("AD0153")'    ,0,5},;
	                       {"Ajuste de Pesos  " ,'ExecBlocK("AD0167")'    ,0,6},;
	                       {"Gerar PV Complem." ,'ExecBlocK("ADLFV010P")' ,0,7},;
	                       {"Legenda"           ,'ExecBlock("LgdFV1")'    ,0,8}}  

							//Ticket: 79442 - Adriano Savoine - 07/09/2022 - removido
						    //{"Primeira Pesagem " ,'ExecBlock("AD0131")'    ,0,4},;
	                       //{"Segunda Pesagem  " ,'ExecBlock("AD0132")'    ,0,5},;
	                      // {"Pesagem Manual   " ,'ExecBlock("AD0144")'    ,0,6},; 
	                       
	//  {"Alterar" ,"AxAltera",0,3},; //removido - Fernando Sigoli Chamado:043085 13/08/2018
	                   
	Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cString := "ZV1"
	
	dbSelectArea("ZV1")
	dbSetOrder(1)
	dbSelectArea(cString) 
	mBrowse( 6,1,22,75,cString,,,,,2,aCores)

Return
 
//-------------------------------------------------------------------|        
//fun��o de alteracao                                                |
//Fernando Sigoli Chamado:043085 13/08/2018                          |
//-------------------------------------------------------------------|        
User Function XAltZV1()

	Local cFlgInt  := ZV1->ZV1_INTEGR 
	Local cNumOC   := ZV1->ZV1_NUMOC 
	Local _nOpca   := 0
	Local cfecha   := ZV1->ZV1_FECHA

	U_ADINF009P('AD0130' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Frango Vivo')
	
	If cFlgInt = 'I'
		MsgAlert ("Aten��o, Ordem ja integrada no SAG. Altera��o nao permitida! " + cvaltochar(cNumOC)) //chamado 043188 20/08/2018 -Fernando Sigoli
		Return  .F.
	ElseIf !Empty(cfecha)
		MsgAlert ("Aten��o, Ordem ja Fechada. Altera��o nao permitida! " + cvaltochar(cNumOC)) //Ticket: 79442 - Adriano Savoine - 07/09/2022
		Return  .F.
	Else
		_nOpca := AxAltera( "ZV1", ZV1->( Recno() ), 04,,,,, "U_ZV1AltOK()",,,,, )   
	EndIf

Return                                                                                                                                    

//-------------------------------------------------------------------|        
//valida alteracao                                                   |
//Fernando Sigoli Chamado:043085 13/08/2018                          |
//-------------------------------------------------------------------|        
User function ZV1AltOK()

	Local nNumNf    := ZV1->ZV1_NUMNFS
	Local nGuia    	:= ZV1->ZV1_X_PESE
	Local lRet 		:= .T.
	Local cUpdate  	:= ""
	Local nOpcao
	Local cLnkSrv		:= Alltrim(SuperGetMV("MV_#UEPSRV",,"LNKMIMS")) //Ticket 69574   - Abel Babini          - 25/04/2022 - Projeto FAI

	U_ADINF009P('AD0130' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Frango Vivo')

	// *** INICIO WILLIAM COSTA 12/02/2019 CHAMADO 046955 || OS 048207 || CONTROLADORIA || REINALDO_FRANCISCHINELLI || 8947 || ORDEM CARREGAMENTO *** //
	
	lRet := U_VALNFFV1() 
	
	// *** FINAL WILLIAM COSTA 12/02/2019 CHAMADO 046955 || OS 048207 || CONTROLADORIA || REINALDO_FRANCISCHINELLI || 8947 || ORDEM CARREGAMENTO *** // 

	If !Empty(nNumNf) .AND. lRet == .T. 
   		
   		cUpdate += " update ["+cLnkSrv+"].SMART.[dbo].[ENTRADA_AVE_VIVA] SET NR_NOTAFISCENTRAVEVIVA = ' " + alltrim(nNumNf) + "' WHERE ID_ENTRAVEVIVA = "+ nGuia
    
	 	PROCESSA({|| nOpcao := TCSQLExec(cUpdate)  },"atualizando Edata [Nota Fiscal]...") 
	 
	 	If nOpcao <> 0
	 		MsgAlert ("Nao atualizado nota fiscal na pesagem do Edata " + cvaltochar(nNumNf))
	  	EndIF
	  	
	EndIF  

	//TICKET 86586 - 09/02/2023 - ADRIANO SAVOINE
	DbSelectArea('ZFC')
	ZFC->(DbSetOrder(4)) // Filial + ordem
 
	//Se conseguir posicionar na Ordem
	If ZFC->(DbSeek(FWxFilial('ZFC') + ZV1->ZV1_NUMOC))
		RecLock('ZFC', .F.)
			ZFC->ZFC_GALPAO := M->ZV1_GALPAO
		ZFC->(MsUnlock())
		ZFC->(DbCloseArea())
	EndIf



Return lRet 
