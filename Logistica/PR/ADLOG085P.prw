#INCLUDE 'PROTHEUS.CH'
#INCLUDE 'FWMVCDEF.CH'
#INCLUDE 'TOPCONN.CH'
#INCLUDE 'TOTVS.CH'
//-------------------------------------------------------------------
/*/{Protheus.doc} ADLOG085P
Cadastro de Motorista em MVC

@author Antonio Domingos
@since 06/09/2022
@version P10
@history Ticket  77042  - 25/07/2022 - Antonio Domingos - AMBIENTE 39- CADASTRO DE MOTORISTAS- ADICIONAR CAMPOS E WORKFLOW
/*/
//-------------------------------------------------------------------
User Function ADLOG085P()

    Local oBrowse
       
    SetFunName("ADLOG085P")
     
oBrowse := FWmBrowse():New()
oBrowse:SetAlias( 'ZVC' )
oBrowse:SetDescription( 'Motoristas' )
oBrowse:AddButton("*Hist.Log",{|| MsAguarde({|| LOG085HLog()},'Gerando Historico...')  },,9,,.F.)
oBrowse:AddButton("*Bloq.Mot",{|| MsAguarde({|| LOG085BMot()},'Bloqueio de Motorista...')  },,9,,.F.)

oBrowse:Activate()


Return NIL


//-------------------------------------------------------------------
Static Function MenuDef()
Local aRotina := {}

ADD OPTION aRotina Title 'Visualizar'  Action 'VIEWDEF.ADLOG085P' OPERATION 2 ACCESS 0
ADD OPTION aRotina Title 'Incluir'     Action 'VIEWDEF.ADLOG085P' OPERATION 3 ACCESS 0
ADD OPTION aRotina Title 'Alterar'     Action 'VIEWDEF.ADLOG085P' OPERATION 4 ACCESS 0
ADD OPTION aRotina Title 'Excluir'     Action 'VIEWDEF.ADLOG085P' OPERATION 5 ACCESS 0 
ADD OPTION aRotina Title 'Imprimir'    Action 'VIEWDEF.ADLOG085P' OPERATION 8 ACCESS 0

Return aRotina


//-------------------------------------------------------------------
Static Function ModelDef()
// Cria a estrutura a ser usada no Modelo de Dados
Local oStruZVC := FWFormStruct( 1, 'ZVC', /*bAvalCampo*/, /*lViewUsado*/ )
Local oStruZVD := FWFormStruct( 1, 'ZVD', /*bAvalCampo*/, /*lViewUsado*/ )
Local bVldPos    := {|oModel| VldTudoOk(oModel) .And. GrvLOgAlt() }
Local oModel

// Cria o objeto do Modelo de Dados
oModel := MPFormModel():New( 'LOG085M', /*bPreValidacao*/, bVldPos /*LOG085POS( oModel )*/, /*bCommit*/, /*bCancel*/ )

// Adiciona ao modelo uma estrutura de formulário de edição por campo
oModel:AddFields( 'ZVCMASTER', /*cOwner*/, oStruZVC )

oModel:SetPrimaryKey( { "ZVC_FILIAL", "ZVC_CPF" } )  

// Adiciona ao modelo uma estrutura de formulário de edição por grid
oModel:AddGrid( 'ZVDDETAIL', 'ZVCMASTER', oStruZVD, /*bLinePre*/, /*bLinePost*/, /*bVldPos*/, /*BLoad*/ )
 
// Indica que é opcional ter dados informados na Grid
oModel:GetModel('ZVDDETAIL'):SetOptional(.T.)
oModel:GetModel("ZVDDETAIL"):SetNoInsertLine(.T.)
oModel:GetModel("ZVDDETAIL"):SetNoDeleteLine(.T.)

// Faz relaciomaneto entre os compomentes do model
oModel:SetRelation( 'ZVDDETAIL', { { 'ZVD_FILIAL', 'xFilial( "ZVD" )' }, { 'ZVD_CPFMOT', 'ZVC_CPF' } }, ZVD->( IndexKey( 1 ) ) )

// Adiciona a descricao do Modelo de Dados
oModel:SetDescription( 'Modelo de Motoristas' )

// Adiciona a descricao do Componente do Modelo de Dados
oModel:GetModel( 'ZVCMASTER' ):SetDescription( 'Motorista' )
oModel:GetModel( 'ZVDDETAIL' ):SetDescription( 'Historico Placa Transportadora'  )

Return oModel


//-------------------------------------------------------------------
Static Function ViewDef()
// Cria um objeto de Modelo de Dados baseado no ModelDef do fonte informado
Local oStruZVC := FWFormStruct( 2, 'ZVC' )
Local oStruZVD := FWFormStruct( 2, 'ZVD' )
// Cria a estrutura a ser usada na View
Local oModel   := FWLoadModel( 'ADLOG085P' )
Local oView

// Cria o objeto de View
oView := FWFormView():New()

// Define qual o Modelo de dados será utilizado
oView:SetModel( oModel )

//Adiciona no nosso View um controle do tipo FormFields(antiga enchoice)
oView:AddField( 'VIEW_ZVC', oStruZVC, 'ZVCMASTER' )

//Adiciona no nosso View um controle do tipo FormGrid(antiga newgetdados)
oView:AddGrid(  'VIEW_ZVD', oStruZVD, 'ZVDDETAIL' )

// Criar um "box" horizontal para receber algum elemento da view
oView:CreateHorizontalBox( 'SUPERIOR', 60 )
oView:CreateHorizontalBox( 'INFERIOR', 40 )

// Relaciona o ID da View com o "box" para exibicao
oView:SetOwnerView( 'VIEW_ZVC', 'SUPERIOR' )
oView:SetOwnerView( 'VIEW_ZVD', 'INFERIOR' )

// Liga a identificacao do componente
oView:EnableTitleView('VIEW_ZVD','Historico de Placas')

Return oView

//-------------------------------------------------------------------
/*/{Protheus.doc} VldTudoOk()
Inclui dados do motorista na tabela ZVD-Historico Placa Motorista
Quando há alteração nos campos de Transportadora e ou Placa do veiculo.
@author Antonio Domingos
@since 06/09/2022
@version P10
@history Ticket  77042  - 25/07/2022 - Antonio Domingos - AMBIENTE 39- CADASTRO DE MOTORISTAS- ADICIONAR CAMPOS E WORKFLOW
/*/

//-------------------------------------------------------------------
Static Function VldTudoOk(oModel)
Local lRet       := .T.
Local aArea      := GetArea()
Local aAreaZVC   := ZVC->( GetArea() )
//Local oModel := FWModelActive()
Local nOperation := oModel:GetOperation()
Local cTipCon   := oModel:GetValue("ZVCMASTER", "ZVC_TIPCON")
Local cCNPJ     := oModel:GetValue("ZVCMASTER", "ZVC_CNPJ")
Local cCPF      := oModel:GetValue("ZVCMASTER", "ZVC_CPF")
Local cPASPOR   := oModel:GetValue("ZVCMASTER", "ZVC_PASPOR")

If nOperation == MODEL_OPERATION_INSERT .OR. nOperation == MODEL_OPERATION_UPDATE
	If cTipCon $ '23' .and. Empty(cCNPJ)
		Help(Nil, Nil, "VldTudoOk(ADLOG085P) Msg-01",,"Campo CNPJ obrigatorio quando Tip.Contrato for 2-PJ-MEI ou 3-PJ-ME! Solução: Preencha o CNPJ!", 1, 0 )
		lRet := .F.
	EndIf
ElseIf nOperation == MODEL_OPERATION_DELETE

	cQuery := " SELECT COUNT(*) CONTADOR "
	cQuery += " FROM "+ retsqlname("ZV4") +" ZV4 "
	cQuery += " WHERE D_E_L_E_T_='' AND ZV4_FILIAL='"+ xFilial("ZV4") +"' AND "
	
	if !Empty(cCPF)
		cQuery += "   (ZV4_CPF  = '"+ alltrim(cCPF) +"' "
		cQuery += " OR ZV4_CPF1 = '"+ alltrim(cCPF) +"' "
		cQuery += " OR ZV4_CPF2 = '"+ alltrim(cCPF) +"' "
		cQuery += " OR ZV4_CPF3 = '"+ alltrim(cCPF) +"' "
		cQuery += " OR ZV4_CPF4 = '"+ alltrim(cCPF) +"' "
		cQuery += " OR ZV4_CPF5 = '"+ alltrim(cCPF) +"' "
		cQuery += " OR ZV4_CPF6 = '"+ alltrim(cCPF) +"' "
		cQuery += " OR ZV4_CPF7 = '"+ alltrim(cCPF) +"' "
		cQuery += " OR ZV4_CPF8 = '"+ alltrim(cCPF) +"' "
		cQuery += " OR ZV4_CPF9 = '"+ alltrim(cCPF) +"') "
	else
		cQuery += "   (ZV4_PASPO  = '"+ alltrim(cPASPOR) +"' "
		cQuery += " OR ZV4_PASPO1 = '"+ alltrim(cPASPOR) +"' "
		cQuery += " OR ZV4_PASPO2 = '"+ alltrim(cPASPOR) +"' "
		cQuery += " OR ZV4_PASPO3 = '"+ alltrim(cPASPOR) +"' "
		cQuery += " OR ZV4_PASPO4 = '"+ alltrim(cPASPOR) +"' "
		cQuery += " OR ZV4_PASPO5 = '"+ alltrim(cPASPOR) +"' "
		cQuery += " OR ZV4_PASPO6 = '"+ alltrim(cPASPOR) +"' "
		cQuery += " OR ZV4_PASPO7 = '"+ alltrim(cPASPOR) +"' "
		cQuery += " OR ZV4_PASPO8 = '"+ alltrim(cPASPOR) +"' "
		cQuery += " OR ZV4_PASPO9 = '"+ alltrim(cPASPOR) +"') "
	endif

	Tcquery cQuery ALIAS "QZV4" NEW

	if QZV4->CONTADOR > 0
		lRet := .F.
		Help(Nil, Nil, "VldTudoOk(ADLOG085P) Msg-02",,"Esse motorista está vinculado a um veículo, por isso, não poderá ser deletado.", 1, 0 )
	endif

	QZV4->(DBCLOSEAREA())
EndIf

RestArea( aAreaZVC )
RestArea( aArea )

Return lRet

//-------------------------------------------------------------------
/*/{Protheus.doc} GrvLOgAlt()
//rotina para gravar o log de alteração
@author Antonio Domingos
@since 06/09/2022
@version P10
@history Ticket  77042  - 25/07/2022 - Antonio Domingos - AMBIENTE 39- CADASTRO DE MOTORISTAS- ADICIONAR CAMPOS E WORKFLOW
/*/
Static Function GrvLOgAlt()    

	Local _aNomCpo 	:= {}
	Local _cAlter  	:= ''
	Local _nx		:= 0
	Local lRet		:= .T.

	U_ADINF009P('CADFVC' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Tela para cadastro de motoristas')
	
	//rotina para aterar 	
	if INCLUI
		cQuery := " SELECT COUNT(*) CONTADOR "
		cQuery += " FROM "+ retsqlname("ZVC") +" ZVC "
		cQuery += " WHERE D_E_L_E_T_='' AND ZVC_FILIAL='"+ xFilial("ZVC") +"' AND "
		
		if !Empty(M->ZVC_CPF)
			cQuery += "  ZVC_CPF  = '"+ alltrim(M->ZVC_CPF) +"' "
		else
			cQuery += "  ZVC_PASPOR  = '"+ alltrim(M->ZVC_PASPOR) +"' "
		endif

		Tcquery cQuery ALIAS "QZVC" NEW

		if QZVC->CONTADOR > 0
			lRet := .F.
			Help(Nil, Nil, "GrvLOgAlt(ADLOG085P)",,"Já existe um motorista cadastrado com esse CPF.", 1, 0 )
		endif

		QZVC->(DBCLOSEAREA())

	ElseIf ALTERA
		
		DbSelectArea("SX3")
		DbSetOrder(1)
		SX3->(DbSetOrder(1))
		SX3->(DbSeek('ZVC'))
		While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == 'ZVC'
			If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_CONTEXT <> "V"
				AADD(_aNomCpo,{SX3->X3_CAMPO,SX3->X3_TIPO})
			EndIf
			SX3->(DbSkip())
		Enddo
		
		dbSelectArea("ZVC")
		DbSetOrder(1)
		If dbseek(xFilial("ZVC")+M->ZVC_CPF)
			For _nx := 1 to len(_aNomCpo)
				_mCampo := "M->"+_aNomCpo[_nx][1]
				_cCampo := "ZVC->"+_aNomCpo[_nx][1]
				IF &_mCampo <> &_cCampo  &&Sendo diferentes campo foi alterado
					//MsgInfo("Campo "+_cCampo+" foi alterado de "+&_cCampo+" para "+&_mCampo+" ")
					_mCpoGrv := ""
					_cCpoGrv := ""
					If _aNomCpo[_nx][2] == "C"
					   _mCpoGrv := &_mCampo
					   _cCpoGrv	:= &_cCampo					
					Elseif _aNomCpo[_nx][2] == "N"
					   _mCpoGrv := Alltrim(STR(&_mCampo))
					   _cCpoGrv	:= Alltrim(STR(&_cCampo))						
					Elseif _aNomCpo[_nx][2] == "D"
					   _mCpoGrv := DTOC(&_mCampo)
					   _cCpoGrv	:= DTOC(&_cCampo)
					Else
					   _mCpoGrv := "conteudo memo"    &&conteudo memo não vai ser possivel gravar conteudo por conta do tamanho.
				       _cCpoGrv := "Conteudo memo"
					Endif
				
					_cAlter := "Campo "+Alltrim(_cCampo)+" de "+Alltrim(_cCpoGrv)+" para "+alltrim(_mCpoGrv)+" "
								
					dbSelectArea("ZBE")
					RecLock("ZBE",.T.)
					Replace ZBE_FILIAL 	   	WITH xFilial("ZBE")
					Replace ZBE_DATA 	   	WITH Date()
					Replace ZBE_HORA 	   	WITH TIME()
					Replace ZBE_USUARI	    WITH UPPER(Alltrim(cUserName))
					Replace ZBE_LOG	        WITH _cAlter
					Replace ZBE_MODULO	    WITH "ZVC-MOTORISTA"
					Replace ZBE_ROTINA	    WITH "ADLOG085P"
					Replace ZBE_PARAME	    WITH "CODIGO MOTORISTA: " + M->ZVC_CPF
					ZBE->(MsUnlock())
																					
				Endif
			Next
			
			If !Empty(_cAlter)
			
				M->ZVC_XUSUAL	:= "USUARIO: "+UPPER(Alltrim(cUserName))+" DATA: "+DTOC(Date()) //grava o ultimo usuario na alteração	
			
			EndIf
			
		Endif
		If !Empty(ZVC->ZVC_CODTRP) .OR. !Empty(ZVC->ZVC_LOJTR) .OR. !Empty(ZVC->ZVC_PLACAV)
			If FWFLDGET("ZVC_CODTRP") <> ZVC->ZVC_CODTRP .OR.;
				FWFLDGET("ZVC_LOJTR") <> ZVC->ZVC_LOJTR .OR.;
				FWFLDGET("ZVC_PLACAV") <> ZVC->ZVC_PLACAV 
					dbSelectArea('ZVD')
					RecLock("ZVD",.T.)
					ZVD->ZVD_FILIAL := xFilial("ZVD")
					ZVD->ZVD_CODTRP := ZVC->ZVC_CODTRP
					ZVD->ZVD_LOJTRP := ZVC->ZVC_LOJTR  
					ZVD->ZVD_NOMTRP := POSICIONE("SA4",1,xFilial("SA4")+ZVC->ZVC_CODTRP,"A4_NOME")
					ZVD->ZVD_PLACAV := ZVC->ZVC_PLACAV 
					ZVD->ZVD_CPFMOT := FWFLDGET("ZVC_CPF")
					ZVD->ZVD_NOMMOT := FWFLDGET("ZVC_MOTORI")
					ZVD->ZVD_DATALT := dDATABASE
					ZVD->ZVD_HORALT := TIME()
					ZVD->ZVD_USUARI := __cUserID
					ZVD->ZVD_NOMUSU := AllTrim(UsrRetName(__cUserID))
					ZVD->(MsUnlock())
			EndIf
		EndIf
	Endif
	
Return lRet  
//-------------------------------------------------------------------
/*/{Protheus.doc} LOG085HLog()
//Apresenta Historico/Log com todas as acoes tomadas
//chamado 029467 02/07/2017 - Fernando Sigoli
@author Antonio Domingos
@since 06/09/2022
@version P10
@history Ticket  77042  - 25/07/2022 - Antonio Domingos - AMBIENTE 39- CADASTRO DE MOTORISTAS- ADICIONAR CAMPOS E WORKFLOW
/*/  
Static Function LOG085HLog()    

	Local aArea		:= GetArea()
	Local oDlg
	Local Query     := ""
	//Local nx 		:= 0
	Local aSize    	:= MsAdvSize()
	Local aPosObj  	:= {}
	Local aObjects 	:= {}
	Local aInfo		:= {}
	//Local aCpos		:= {}
	Local nOpcao	:= 0
	Local aListBox	:= {}
	//Local oTik		:= LoadBitMap(GetResources(), 'LBTIK')
	//Local oNo		:= LoadBitMap(GetResources(), 'LBNO' )
	//Local oMarca	:= LoadBitMap(GetResources(), 's4wb018n.png')
	//Local cCampos 	:= ''
	
	Private aTela	[0][0]
	Private aGets	[0]
	
	//Tamanho da tela
	aObjects := {}
	aAdd( aObjects, { 100,  20, .t., .f. } )
	aAdd( aObjects, { 100,  80, .t., .t. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )
	
	Query := " SELECT ZBE_DATA,ZBE_HORA,ZBE_USUARI,ZBE_LOG,ZBE_PARAME FROM "+retsqlname("ZBE")+" WHERE (ZBE_ROTINA = 'ADLOG085P' OR ZBE_ROTINA = 'CADFVC')  and ZBE_PARAME LIKE '%"+ZVC->ZVC_CPF+"%' ORDER BY ZBE_DATA DESC, ZBE_HORA DESC "
	TCQUERY Query new alias "LOG1"    
	
	// Adiciona elementos ao Array da ListBox
	LOG1->(dbgotop())
	While !EOF()  
		aAdd( aListBox,{ LOG1->ZBE_USUARI, LOG1->ZBE_DATA, LOG1->ZBE_HORA, LOG1->ZBE_LOG,  })
	DbSkip()
	End  
	
	LOG1->(DbCloseArea())
	   
	If Empty( aListBox )
	
		Alert( 'Nenhuma ocorrencia de Log para este Motorista' )
	
	Else
	
		
		DEFINE MSDIALOG oDlg TITLE "Histórico/Log" FROM aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL
		
		@ 010,10 Say 'Motorista: '+Alltrim(ZVC->ZVC_MOTORI) SIZE 200,15 OF oDlg PIXEL
		
		@ aPosObj[2,1],aPosObj[2,2] ListBox oListBox Fields HEADER "Usuario", "Data", "Hora", "LOG/Alteracao";
		Size aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1] Of oDlg Pixel ColSizes 50,50,50,70,100
		
		oListBox:SetArray(aListBox)
		
		oListBox:bLine := {|| {	aListBox[oListBox:nAT,01], DTOC(STOD(aListBox[oListBox:nAT,02]))  ,aListBox[oListBox:nAT,03], aListBox[oListBox:nAT,04]}}
		
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcao:=1, If( Obrigatorio( aGets, aTela) ,oDlg:End(),Nil)},{||nOpcao:=0,oDlg:End()},.F.,)
	
	Endif
	
	RestArea( aArea )

Return Nil 
 

 /*/{Protheus.doc} Static Function LOG085BMOT()
	Botão para bloquear motorista
	@author Antonio Domingos
	@since 02/09/2022
	@version 01
	@history Antonio Domingos, 02/09/2022, ticket 77042. AMBIENTE 39- CADASTRO DE MOTORISTAS- ADICIONAR CAMPOS E WORKFLOW
/*/

Static Function LOG085BMOT()

Local cMotivo  := CriaVar("ZVC_BLQJUS")
Local aGetArea := GetArea()
Local oBmp
Local oDlg
Local nOpt    := 2

	If ZVC->ZVC_MOTBLQ == .T.
		Aviso("Atenção", "Motorista ja foi bloqueado!", {"OK"}, 3)
	Else
		If MsgYesNo('Bloqueia Motorista '+alltrim(ZVC->ZVC_MOTORI)+'?')
			DEFINE MSDIALOG oDlg FROM	18,1 TO 80,550 TITLE "ADORO S/A Motorista -  Tela de Bloqueio" PIXEL
			@  1, 3 	TO 28, 242 OF oDlg  PIXEL
			If File("adoro.bmp")
				@ 3,5 BITMAP oBmp FILE "adoro.bmp" OF oDlg NOBORDER SIZE 25,25 PIXEL
				oBmp:lStretch:=.T.
			EndIf
			@ 05, 37	SAY "Motivo Bloqueiro:" SIZE 24, 7 OF oDlg PIXEL
			@ 12, 37  	MSGET cMotivo  SIZE	200, 9 OF oDlg PIXEL Valid !Empty(cMotivo)
			DEFINE SBUTTON FROM 02,246 TYPE 1 ACTION (nOpt := 1,oDlg:End()) ENABLE OF oDlg
			
			ACTIVATE MSDIALOG oDlg CENTERED

			If nOpt == 1                                                                            
				
				_cCampo1 := "ZVC_MOTBLQ"
				_cCampo2 := "ZVC_BLQJUS"
				_cCpoGrv1 := "F"
				_cCpoGrv2 := ZVC->ZVC_BLQJUS

				ZVC->(RECLOCK("ZVC",.F.))
				ZVC->ZVC_MOTBLQ := .T.
				ZVC->ZVC_BLQJUS := cMotivo
				ZVC->(MsUnlock())
			
				_mCpoGrv1 := "T"
				_mCpoGrv2 := ZVC->ZVC_BLQJUS
				
				_cAlter1 := "Campo "+Alltrim(_cCampo1)+" de "+Alltrim(_cCpoGrv1)+" para "+alltrim(_mCpoGrv1)+" "
				_cAlter2 := "Campo "+Alltrim(_cCampo2)+" de "+Alltrim(_cCpoGrv2)+" para "+alltrim(_mCpoGrv2)+" "

				dbSelectArea("ZBE")
				RecLock("ZBE",.T.)
				Replace ZBE_FILIAL 	   	WITH xFilial("ZBE")
				Replace ZBE_DATA 	   	WITH Date()
				Replace ZBE_HORA 	   	WITH TIME()
				Replace ZBE_USUARI	    WITH UPPER(Alltrim(cUserName))
				Replace ZBE_LOG	        WITH _cAlter1
				Replace ZBE_MODULO	    WITH "ZVC-MOTORISTA"
				Replace ZBE_ROTINA	    WITH "CADFVC"
				Replace ZBE_PARAME	    WITH "CODIGO MOTORISTA: " + ZVC->ZVC_CPF
				ZBE->(MsUnlock())

				dbSelectArea("ZBE")
				RecLock("ZBE",.T.)
				Replace ZBE_FILIAL 	   	WITH xFilial("ZBE")
				Replace ZBE_DATA 	   	WITH Date()
				Replace ZBE_HORA 	   	WITH TIME()
				Replace ZBE_USUARI	    WITH UPPER(Alltrim(cUserName))
				Replace ZBE_LOG	        WITH _cAlter2
				Replace ZBE_MODULO	    WITH "ZVC-MOTORISTA"
				Replace ZBE_ROTINA	    WITH "CADFVC"
				Replace ZBE_PARAME	    WITH "CODIGO MOTORISTA: " + ZVC->ZVC_CPF
				ZBE->(MsUnlock())

			Else
				Aviso("Atenção", "Motorista não foi bloqueado! Para bloquear informe o motivo", {"OK"}, 3)
			Endif
		
		EndIf
	EndIf

RestArea(aGetArea)

Return Nil 
