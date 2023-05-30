#INCLUDE "ParmType.ch"
#INCLUDE "topconn.ch"
#INCLUDE "PROTHEUS.CH"

//Posicao da estrutura TCBrowse
#DEFINE TCB_POS_CMP	1
#DEFINE TCB_POS_PIC	2
#DEFINE TCB_POS_TIT	3
#DEFINE TCB_POS_TAM	4
#DEFINE TCB_POS_TIP	5

//Largura das colunas FWLayer
#DEFINE LRG_COL01		20
#DEFINE LRG_COL02		70
#DEFINE LRG_COL03		10

//Posicoes do pergunte do SX1
#DEFINE POS_X1DES		1
#DEFINE POS_X1TIP		2
#DEFINE POS_X1TAM		3
#DEFINE POS_X1OBJ		6
#DEFINE POS_X1VLD		7
#DEFINE POS_X1VAL		8
#DEFINE POS_X1CB1		9
#DEFINE POS_X1CB2		10
#DEFINE POS_X1CB3		11
#DEFINE POS_X1CB4		12
#DEFINE POS_X1CB5		13
#DEFINE POS_X1VAR		14

//Posicoes da array de controle de NFs selecionadas
#DEFINE POS_NF_NUM		1
#DEFINE POS_NF_SER		2
#DEFINE POS_NF_CLI		3
#DEFINE POS_NF_LOJ		4

Static nQtdePerg		:= 11 //Everson - 26/09/2022. Ticket 8037
Static nTamFil			:= IIf(FindFunction("FWSizeFilial"),FWSizeFilial(),2)
Static nTamArq			:= 500
Static nTopCont			:= 003
Static nEsqCont			:= 001
Static nAltCont			:= 009
Static nDistPad			:= 002
Static nAltBot			:= 013
Static nDistAPad		:= 004
Static nDistEtq			:= 001
Static nAltEtq			:= 007
Static nLargEtq			:= 035 
Static nLargBot			:= 040
Static cHK				:= "&"

/*/{Protheus.doc} User Function CCSP_001
	Rotina para envio de carga ao edata Integracao Protheus x Edata
	@type  Function
	@author CCSKF
	@since 14/06/2012
	@history chamado 048868 - Fernando Sigoli - 02/05/2019 - Adicionado Filial na Query, SqlVerifRoteiro
	@history chamado 049906 - Fernando Sigoli - 27/06/2019 - Na integração valida no Edata, se existe carga diferente de encerrada. Caso exitir, nao deixa integrar!
	@history chamado T.I    - Fernando Sigoli - 01/07/2019 - Nao validar roteiro em Pedido diversos, que ja emitiu nota fiscal saida
	@history chamado 051387 - Fernando Sigoli - 29/08/2019 - Tratamento na query, para pesquisar o roteiro do pedido na tabela SC5
	@history chamado T.I    - Fernando Sigoli - 10/10/2020 - Retorno das funçoes de begintran
	@history TICKET 4276    - William Costa   - 29/10/2020 - Retorno das funçoes de alterado todos os begintran() endTran para begin Transaction END Transaction, não utiliza mais a função
	@history TICKET 4276    - William Costa   - 30/10/2020 - Adicionado mensagem de cErro quando a variavel que validade se o pedido está liberado por credito ou estoque é preenchida com falso
	@history ticket 9122    - Fernando Maciei - 09/02/2021 - melhoria no envio Carga EDATA
	@history ticket 63303   - Leonardo P. Monteiro - 08/11/2021 - Melhoria na validação do estorno de cargas para não permitir a exclusão de cargas que já tenham pallets vinculados ao mesmo.
	@history ticket 63303   - Leonardo P. Monteiro - 24/11/2021 - Correção na declaração da variável In utilizada na função FENCECARG.
	@history ticket TI   	  - Leonardo P. Monteiro - 28/12/2021 - Correção de error.log.
	@history ticket 65889  	- Leonardo P. Monteiro - 05/01/2022 - Validação adicional na integração de cargas no eData para bloquear PVs com adiantamentos vinculados ao PV e que não foram aprovados pelo Financeiro.
	@history ticket 71027   - Fernando Macieira    - 07/04/2022 - Liberação Pedido Antecipado sem Aprovação Financeiro - PV 9BEGCC foi incluído depois que o job do boleto parou, não gerou FIE e SE1 (PR) e foi liberado manualmente pelo financeiro, sendo faturado como pv normal... por isso da dupla checagem
	@history ticket 69334   - Abel Babini          - 05/09/2022 - Ajustes no fonte para Filial Itapira
	@history ticket TI		- Everson 			   - 16/09/2022 - Declarar variáveis como private.
	@history Ticket 80379   - Everson			   - 29/09/2022 - Operação de transbordo.
	@history Ticket 80379   - Everson			   - 30/09/2022 - Adicionado order by pela carga de transbordo.
	@history Ticket 80379   - Everson			   - 04/10/2022 - Tratamento para estorno de carga de transbordo.
	@history Ticket 80379   - Everson			   - 05/10/2022 - Adicionado roteiro do transbordo.
	@history Ticket 80379   - Everson			   - 08/11/2022 - Tratamento para troca de placa transbordo.
	@history Ticket TI      - Everson			   - 12/01/2023 - Adicionada trava de rotina LockByName.
	@history Ticket TI      - Everson			   - 13/01/2023 - Adiconado DisarmTransaction no envio de carga.
	@history Ticket TI      - Fernando Sigoli      - 26/05/2023 - Tratamento da Nova Filial ::: Vista Foods.
/*/
User Function CCSP_001()

	LOCAL oSay,oSay2,oSay3
	LOCAL oBtn1,oBtn2,oBtn3
	LOCAL oDlg            
	Local lLock := GetMv("MV_#CCSP11",,.T.)


	PRIVATE cPerg     	:="CCSP01" 
	Private cCadastro 	:="Integracao Protheus x Edata"
	Private cErro     	:= ""
	Private lVldEnv		:= SuperGetMV("MV_ZSP001A",,.T.)
	Private lTransbordo	:= SuperGetMV("MV_ZSP001B",,.F.) //Everson - 26/09/2022 - Ticket 80379.

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Integracao Protheus x Edata')

	//Tratamento de uso exclusivo por usuario, evintando que o mesmo consiga abrir mais de uma tela.?
	//Everson - 12/01/2023 - Ticket TI.
	If lLock .And. ! LockByName("CCSP_001", .T., .T.)
		Aviso("CCSP_001","Rotina já está em uso!",{"Ok"})    
		Return Nil
	EndIf

		//Acerta dicionário de perguntas       
		
		Pergunte(cPerg,.T.)

		ProcLogIni( {},"CCSP01")

		DEFINE MSDIALOG oDlg FROM  96,9 TO 320,612 TITLE OemToAnsi(cCadastro) PIXEL
		@ 11,6 TO 90,287 LABEL "" OF oDlg  PIXEL
		@ 16, 15 SAY OemToAnsi("Este programa efetua a integracao com o EDATA") SIZE 268, 8 OF oDlg PIXEL			   									

		DEFINE SBUTTON FROM 93, 163 TYPE 15 ACTION ProcLogView() ENABLE OF oDlg
		DEFINE SBUTTON FROM 93, 193 TYPE 5  ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 93, 223 TYPE 1  ACTION If(.T.,(Processa({|lEnd| E001Proces()},OemToAnsi("Integracao Protheus x Edata"),OemToAnsi("Selecionando Registros..."),.F.),oDlg:End()),) ENABLE OF oDlg
		DEFINE SBUTTON FROM 93, 253 TYPE 2  ACTION oDlg:End() ENABLE OF oDlg
		ACTIVATE MSDIALOG oDlg CENTERED    


	//Everson - 12/01/2023 - Ticket TI.
	If lLock
		UnLockByName("CCSP_001", .T., .T.)    

	EndIf

Return       

/*/{Protheus.doc} User Function E001Proces
	Rotina para envio de carga ao edata Integracao Protheus x Edata
	@type  Function
	@author CCSKF
	@since 02/05/10
/*/
Static Function E001Proces()

	Local aArea				:= SaveArea1({"SC5","SC6","SA1","SA2","SX3",Alias()})
	Local oArea				:= FWLayer():New()
	Local aCoord			:= FWGetDialogSize(oMainWnd)
	Local lMDI				:= oAPP:lMDI
	Local aTamObj			:= Array(4)
	Local aParam			:= Array(nQtdePerg)
	Local cTMP				:= ""
	Local cSepara			:= Space(1)
	Local aLstRotAux		:= {"CCSKFXFUN.PRW"}
	Local lTOP				:= .F.
	Local nCoefDif			:= 1
	Local aPergunte			:= {}
	Local cFile				:= Space(nTamArq)
	Local cDrive			:= ""
	Local cDir				:= ""
	Local cArqP				:= ""
	Local cExt				:= ""
	Local cDelim			:= ";"
	Local nRegua			:= 0
	Local ni				:= 0
	Local nx				:= 0
	Local lOk				:= .F.
	Local aLstC01			:= {" ","C5_DTENTR","C5_ROTEIRO","C5_PLACA","C5_NUM","C5_CLIENTE","A1_NREDUZ","C5_X_SQED","C5_XINT","C5_XOBS","C5_FILIAL","C5_XFATANT", "C5_XCAGRUP", "C5_XPAGRUP", "C5_XEAGRUP"}
	Local cLine01			:= ""
	Local oOk 				:= LoadBitmap(GetResources(),"LBOK")
	Local oNo 				:= LoadBitmap(GetResources(),"LBNO")
	Local bAtGD				:= {|lAtGD,lFoco| IIf(lAtGD,(oGD01:SetArray(_aDados01),oGD01:bLine := &(cLine01),oGD01:GoTop()),.T.),;
	IIf(ValType(lFoco) == "L" .AND. lFoco,oGD01:SetFocus(),.T.)}
	
	//Objetos graficos
	Local oTela
	Local oPainel01
	Local oPainel02
	Local oPainel03
	Local oPainelS01
	Local oBot01
	Local oBot02
	Local oBot03
	Local oBot04
	Local oBot05
	Local oBot06 //Everson - 26/09/2022 - Ticket 80379.
	Local oGD01																							//Getdados

	Private cRotNome	:= "[" + StrTran(ProcName(0),"U_","") + "]" + Space(1)
	Private __oDlg
	Private cRotDesc	:= "Integracao Protheus x Edata"
	Private cNomeUs		:= Capital(AllTrim(UsrRetName(__cUserID)))
	Private oRegua
	Private aLstPED		:= {}																		//Lista de notas fiscais selecionadas
	Private aHeader01	:= {}
	Private _aDados01	:= {}
	Private cLnkSrv		:= Alltrim(SuperGetMV("MV_#UEPSRV",,"LNKMIMS"))
	Private cLinkBD     := Alltrim(SuperGetMV("MV_#UEPSBD",,"SMART"))

	#IFDEF TOP
	lTop := .T.
	#EndIf
	
	//Validacoes  
	
	If !lTOP 
		MsgAlert(cNomeUs + ", esta rotina s?pode ser executada a partir de um banco de dados relacional.")
		Return Nil
	Endif
	For ni := 1 to Len(aLstRotAux)
		If Empty(GetAPOInfo(aLstRotAux[ni]))
			MsgAlert(cNomeUs + ", uma rotina auxiliar (" + aLstRotAux[ni] + ") necessária para a execução desta rotina não pode ser encontrada!")
			Return Nil		
		Endif
	Next ni

	//Montar o grupo de perguntas  

	aFill(aTamObj,0)
	
	//Montar a lista de campos a utilizar na GD  
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For ni := 1 to Len(aLstC01)
		If !Empty(aLstC01[ni]) .AND. SX3->(dbSeek(PadR(aLstC01[ni],10)))
			aAdd(aHeader01,{SX3->X3_CAMPO,;
			SX3->X3_PICTURE,;
			AllTrim(X3Titulo()),;
			SX3->X3_TAMANHO,;
			SX3->X3_TIPO})
		Endif
	Next ni
	
	//Montar a lista de dados da GD  
	_aDados01 := Array(1,Len(aHeader01) + 1)
	For ni := 1 to Len(_aDados01)
		_aDados01[ni][1] := .F.
		For nx := 1 to Len(aHeader01)
			_aDados01[ni][nx + 1] := CriaVar(aHeader01[nx][TCB_POS_CMP],.F.)
		Next nx
	Next ni
	
	//Montar o codeblock para montar as listas de dados da GD  
	cLine01 := "{|| {"
	cLine01 += "IIf(_aDados01[oGD01:nAt,1],oOk,oNo),"
	For ni := 2 to Len(aLstC01)
		cLine01 += "_aDados01[oGD01:nAt," + cValToChar(ni) + "]" + IIf(ni < Len(aLstC01),",","")
	Next ni
	cLine01 += "}}"
	
	//Substituir o nome dos campos pelos titulos  
	
	For ni := 1 to Len(aLstC01)
		aLstC01[ni] := Posicione("SX3",2,PadR(aLstC01[ni],10),"X3Titulo()")
	Next ni
	
	//Interface  
	
	aCoord[3] := aCoord[3] * 0.95
	aCoord[4] := aCoord[4] * 0.95
	If U_ApRedFWL(.T.)
		nCoefDif := 0.95
	Endif

	CCSP001At(aClone(aHeader01),@_aDados01) 

	// **** INICIO VERIFICAR SE OS PEDIDOS ESTAO LIBERADO CHAMADO 031417 - WILLIAM COSTA**** //

	If EMPTY(_aDados01)

		MsgAlert("Ol?" + cNomeUs + ", Pedidos não liberados", "Não Existe Pedidos Liberados")
		RestArea1(aArea)
		ProcLogAtu("FIM")

		RETURN NIL

	EndIf  

	// **** FINAL VERIFICAR SE OS PEDIDOS ESTAO LIBERADO CHAMADO 031417 - WILLIAM COSTA**** //

	DEFINE MSDIALOG oTela TITLE (Capital(cRotDesc) + " " + cRotNome) FROM aCoord[1],aCoord[2] TO aCoord[3],aCoord[4] OF oMainWnd COLOR "W+/W" PIXEL

	oArea:Init(oTela,.F.)
	//Mapeamento da area
	oArea:AddLine("L01",100 * nCoefDif,.T.)
	
	//Colunas  
	
	oArea:AddCollumn("L01C01",LRG_COL01,.F.,"L01")
	oArea:AddCollumn("L01C02",LRG_COL02,.F.,"L01")
	oArea:AddCollumn("L01C03",LRG_COL03,.F.,"L01")
	
	//Paineis  
	
	oArea:AddWindow("L01C01","L01C01P01","Parâmetros",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oPainel01 := oArea:GetWinPanel("L01C01","L01C01P01","L01")
	oArea:AddWindow("L01C02","L01C02P01","Dados adicionais",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oPainel02 := oArea:GetWinPanel("L01C02","L01C02P01","L01")
	oArea:AddWindow("L01C03","L01C03P01","Funções",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
	oPainel03 := oArea:GetWinPanel("L01C03","L01C03P01","L01")
	
	//Painel 01 - Filtros  
	
	//PERGUNTAS
	U_DefTamObj(@aTamObj,000,000,(oPainel01:nClientHeight / 2) * 0.9,oPainel01:nClientWidth / 2)
	oPainelS01 := tPanel():New(aTamObj[1],aTamObj[2],"",oPainel01,,.F.,.F.,,CLR_WHITE,aTamObj[4],aTamObj[3],.T.,.F.)

	Pergunte(cPerg,.T.,,.F.,oPainelS01,,@aPergunte,.T.,.F.)

	//BOTAO PESQUISA
	U_DefTamObj(@aTamObj,(oPainel01:nClientHeight / 2) - nAltBot,000,(oPainel01:nClientWidth / 2),nAltBot,.T.)
	oBot01 := tButton():New(aTamObj[1],aTamObj[2],cHK + "Pesquisar",oPainel01,;
	{|| IIf(PFATA2VlP(cPerg,@aPergunte),;
	MsAguarde({|| CursorWait(),CCSP001At(aClone(aHeader01),@_aDados01),Eval(bAtGD,.T.,.T.),CursorArrow()},cRotNome,"Pesquisando",.F.),.F.)},;
	aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)
	
	//Painel 02 - Lista de dados  
	
	oGD01 := TCBrowse():New(000,000,000,000,/*bLine*/,aLstC01,,oPainel02,,,,/*bChange*/,/*bLDblClick*/,/*bRClick*/,/*oFont*/,,,,,,,.T.,/*bWhen*/,,/*bValid*/,.T.,.T.)
	oGD01:bHeaderClick	:= {|oObj,nCol| CCSP001GD(2,@_aDados01,@oGD01,nCol,aClone(aHeader01)),oGD01:Refresh()}
	oGD01:blDblClick	:= {|| CCSP001GD(1,@_aDados01,@oGD01,,aClone(aHeader01)),oGD01:Refresh()}
	oGD01:Align 		:= CONTROL_ALIGN_ALLCLIENT
	Eval(bAtGD,.T.,.F.)

	//Painel 03 - Funcoes  
	
	//ENVIO EDATA
	U_DefTamObj(@aTamObj,000,000,(oPainel03:nClientWidth / 2),nAltBot,.T.)
	oBot01 := tButton():New(aTamObj[1],aTamObj[2],cHK + "Envio Edata",oPainel03,;
	{|| IIf(!Empty(aLstPED),;
	MsAguarde({|| CursorWait(),lOk := CCS_001P(@oTela),CursorArrow(),IIf(lOk,(CCSP001At(aClone(aHeader01),@_aDados01),Eval(bAtGD,.T.,.T.)),AllwaysTrue())},;
	cRotNome,"Processando",.F.),MsgAlert(cNomeUs + ", para processar ?necessário que ao menos um registro seja selecionado!",cRotNome))},;
	aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)

	//ESTORNO EDATA
	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBot02 := tButton():New(aTamObj[1],aTamObj[2],cHK + "Estorno",oPainel03,;
	{|| IIf(!Empty(aLstPED),;
	MsAguarde({|| CursorWait(),lOk := CCS_001E(@oTela),CursorArrow(),IIf(lOk,(CCSP001At(aClone(aHeader01),@_aDados01),Eval(bAtGD,.T.,.T.)),AllwaysTrue())},;
	cRotNome,"Processando",.F.),MsgAlert(cNomeUs + ", para processar ?necessário que ao menos um registro seja selecionado!",cRotNome))},;
	aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)

	//CONSULTA LOG
	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBot03 := tButton():New(aTamObj[1],aTamObj[2],cHK + "ConsultaLog",oPainel03,{||CCS_001L(@oTela) },aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)

	//Troca de Placa
	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBot04 := tButton():New(aTamObj[1],aTamObj[2],cHK + "Troca de Placa",oPainel03,{|| CCS_001T(@oTela)},aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)
	
	//Everson - 26/09/2022. Ticket 80379.
	//Placa transbordo.
	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBot06 := tButton():New(aTamObj[1],aTamObj[2],cHK + "Placa Transbordo",oPainel03,{||;
	MsAguarde({|| CursorWait(),plcTrans(@oTela, @oGD01), CCSP001At(aClone(aHeader01),@_aDados01), Eval(bAtGD,.T.,.T.) }, "Aguarde", "Processando...");
	},aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)
	oBot06:bWhen := {|| lTransbordo }
	//
	
	//Sair
	U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
	oBot05 := tButton():New(aTamObj[1],aTamObj[2],cHK + "Sair",oPainel03,{|| oTela:End()},aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)

	oTela:Activate(,,,.T.,/*valid*/,,{|| .T.})

	RestArea1(aArea)

	ProcLogAtu("FIM")

Return Nil


/*/{Protheus.doc} plcTrans
	(long_description)
	@type  Static Function
	@author Everson
	@since 26/09/2022
	@version 01
/*/
Static Function plcTrans(oTela, oGD01)

	//Variáveis.
	Local aArea   	:= GetArea()
	Local cTransp 	:= ""
	Local xBckMV1 	:= MV_PAR01
	Local xBckMV2 	:= MV_PAR02
	Local cPlaca  	:= ""
	Local cRotTrans	:= ""
	Local nKm		:= 0

	If Empty(aLstPED) .OR. ValType(aLstPED) # "A"
		MsgInfo("Não há pedido(s) selecionado(s).", "Função plcTrans(CCSP_001)")
		Return .F.

	EndIf

	If ! Pergunte("CCSP0011",.T.)
		MV_PAR01 := xBckMV1
		MV_PAR02 := xBckMV2
		RestArea(aArea)
		Return .F.

	EndIf

	cPlaca 		:= MV_PAR01
	cRotTrans	:= MV_PAR02
	MV_PAR01 	:= xBckMV1
	MV_PAR02 	:= xBckMV2

	If ! Empty(cPlaca)

		DbSelectArea("ZV4")
		ZV4->(DbSetOrder(1))
		ZV4->(DbGoTop())

		If ! ZV4->(DbSeek( FWxFilial("ZV4") + cPlaca ))
			MsgInfo("Placa " + cValToChar(cPlaca) + " não localizada.", "Função plcTrans(CCSP_001)")
			RestArea(aArea)
			Return .F.

		EndIf

		cTransp := Alltrim(cValToChar(ZV4->ZV4_FORNEC))

		If Empty(cTransp)
			MsgInfo("Não foi possível obter o código da transportadora da placa " + cValToChar(cPlaca) + ".", "Função plcTrans(CCSP_001)")
			RestArea(aArea)
			Return .F.

		EndIf

		If Empty(cRotTrans)
			MsgInfo("Necessário informar a rota do transbordo.", "Função plcTrans(CCSP_001)")
			RestArea(aArea)
			Return .F.

		EndIf

		//Everson - 05/10/2022 - Ticket 80379.
		DbSelectArea("ZHZ")
		ZHZ->(DbSetOrder(1))
		ZHZ->(DbGoTop())
		If ! ZHZ->(DbSeek( FWxFilial("ZHZ") + cRotTrans ))
			MsgInfo("Rota de transbordo " + cValToChar(cRotTrans) + " não localizada.", "Função plcTrans(CCSP_001)")
			RestArea(aArea)
			Return .F.

		EndIf

		cRotTrans := ZHZ->ZHZ_CODIGO
		nKm		  := ZHZ->ZHZ_KM

	Else //Everson - 05/10/2022 - Ticket 80379.

		cRotTrans	:= ""
		nKm			:= 0

	EndIf

	Processa({|| prcPlcT(aLstPED, cPlaca, cTransp, cRotTrans, nKm) }, "Aguarde", "Processando...")

	If oGD01 # Nil
		oGD01:DrawSelect()
		oGD01:Refresh()

	EndIf

	If oTela # Nil
		oTela:SetFocus()

	EndIf

	RestArea(aArea)

Return .T.


/*/{Protheus.doc} prcPlcT
	Atribui placa ao transbordo.
	@type  Static Function
	@author Everson
	@since 26/09/2022
	@version 01
/*/
Static Function prcPlcT(aLstPED, cPlaca, cTransp, cRotTrans, nKm) //Everson - 05/10/2022 - Ticket 80379.

	//Variáveis.
	Local aArea   	:= GetArea()
	Local cNewAlias	:= GetNextAlias()
	Local cSeq	  	:= ""
	Local cQuery  	:= " SELECT ISNULL(MAX(C5_XCAGRUP),'0') AS C5_XCAGRUP FROM " + RetSqlName("SC5") + " (NOLOCK) AS SC5 WHERE C5_FILIAL = '" + FWxFilial("SC5") + "' AND C5_XCAGRUP <> '' AND SC5.D_E_L_E_T_ = '' "
	Local ni		:= 1
	Local nCount	:= 0
	Local cMens		:= ""
	Local cPedido   := ""
	Local nTotReg	:= 0
	Local dDtEntr	:= Nil
	Local cStatus	:= ""
 
	If !LockByName("prcPlcT", .T., .F.)
	    u_GrLogZBE(Date(),TIME(),cUserName,"Lockbyname executado para a rotina prcPlcT.","SIGAFAT","CCS_001P",;
			    "Rotina já iniciada por outro usuário através da rotina prcPlcT. ",ComputerName(),LogUserName())
        
        MsgInfo("Rotina sendo executada por outro usuário! Aguarde o término da execução.", "..:: Em execução ::.. ")

		RestArea(aArea)
		Return Nil

    EndIf

	If ! Empty(cPlaca)

		DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNewAlias, .F., .T.)

		(cNewAlias)->(DbGoTop())
			cSeq := PadL(Soma1((cNewAlias)->C5_XCAGRUP), 10, "0")
		(cNewAlias)->(DbCloseArea())

	EndIf

	DbSelectArea("SC5")
	SC5->(DbSetOrder(1))
	SC5->(DbGoTop())

	nTotReg := Len(aLstPED)

	Begin Transaction

		u_GrLogZBE(Date(),TIME(),cUserName,"Emplacamento transbordo","SIGAFAT","CCS_001P",;
			"Seq/cPlaca/Transp/RotTrans/nKm" + cSeq + "/" + cPlaca + "/" + cTransp + "/" + cRotTrans + "/" + cValToChar(nKm),ComputerName(),LogUserName())

		For ni := 1 To nTotReg

			IncProc("Registro " + cValToChar(ni) + " de " + cValToChar(nTotReg))                  
			
			cStatus := aLstPED[ni][8]
			cPedido := aLstPED[ni][4]

			If !(cStatus $ "1|2|4| " )
				cMens += "Pedido " + cValToChar(cPedido) + " possui status já enviado " + CRLF
				DisarmTransaction()
				Break

			EndIf

			If ! Empty(aLstPED[ni][7])
				cMens += "Pedido " + cValToChar(cPedido) + " possui carga Edata vinculada " + CRLF
				DisarmTransaction()
				Break

			EndIf

			If SC5->(DbSeek( FWxFilial("SC5") + cPedido ))

				nCount++

				RecLock("SC5", .F.)
				
					SC5->C5_XCAGRUP	:= cSeq
					SC5->C5_XPAGRUP	:= cPlaca
					SC5->C5_XTAGRUP	:= cTransp	

					//Everson - 05/10/2022 - Ticket 80379.
					SC5->C5_XRAGRUP	:= cRotTrans	
					SC5->C5_XKAGRUP	:= nKm	
					//
					
					If Empty(cSeq)
						SC5->C5_XDAGRUP	:= CToD(" / / ")	
						SC5->C5_XEAGRUP	:= CToD(" / / ")

					Else
						SC5->C5_XDAGRUP	:= Date()

					EndIf

				SC5->(MsUnlock())

				If Empty(dDtEntr) .Or. SC5->C5_DTENTR < dDtEntr
					dDtEntr := SC5->C5_DTENTR

				EndIf

			Else

				cMens += "Pedido " + cValToChar(cPedido) + " não localizado " + CRLF

			EndIf

		Next ni

	End Transaction

	If ! Empty(cSeq) .And. nCount > 0
		TcSqlExec( " UPDATE " + RetSqlName("SC5") + " SET C5_XEAGRUP = '" + DToS(dDtEntr) + "' WHERE C5_FILIAL = '" + FWxFilial("SC5") + "' AND C5_XCAGRUP = '" + cSeq + "' AND D_E_L_E_T_ = '' " )

	EndIf

	UnLockByName("prcPlcT")

	If ! Empty(cMens)
		cMens := "Lista de itens que não foram processados : " + CRLF + cMens
		U_ExTelaMen(cRotDesc,cMens,"Arial",10,,.F.,.T.)

	EndIf

	RestArea(aArea)

Return Nil


/*/{Protheus.doc} User Function CCSP001AT
	Rotina de atualizacao da lista de dados
	@type  Function
	@author Pablo Gollan Carreras
	@since 14/06/2012
/*/

Static Function CCSP001At(aHeader01,_aDados01)

	Local ni				:= 0
	Local nx				:= 0
	Local cLstC01			:= ""
	Local cAliasT			:= GetNextAlias()
	Local cTipoNF			:= "%('N')%"
	Local aTMP				:= {}
	Local nCont				:= 0
	Local aDtRef			:= Array(2)
	Local cDtVz				:= Space(8)

	//Definicoes de filtros  
	
	_aDados01 := Array(0)
	aDtRef[1] := DtoS(MV_PAR05)
	aDtRef[2] := DtoS(MV_PAR06)

	If MV_PAR07 == 1		//Pend. classificacao
		cRest01 := "C5_XINT IN ('1', ' ') "
	ElseIf MV_PAR07 == 5		//Pend. classificacao
		cRest01 := " 1 = 1"
	Else
		cRest01 := "C5_XINT = '" + ALLTRIM(STR(MV_PAR07)) + "' "
	EndIf

	cRest01 := "%" + cRest01 + "%"

	//Fazer a pesquisa dos dados  
	
	(cLstC01 := "",aEval(aHeader01,{|x| IIf(!Empty(x[TCB_POS_CMP]),cLstC01 += x[TCB_POS_CMP] + ",","")}),cLstC01 := "%" + Substr(cLstC01,1,Len(cLstC01) - 1) + "%")

	BeginSQL Alias cAliasT    

		SELECT C5_DTENTR,C5_ROTEIRO,C5_PLACA,C5_NUM,C5_CLIENTE,A1_NREDUZ,C5_X_SQED,C5_XINT,C5_XOBS,C5_FILIAL,C5_XFATANT,C5_XCAGRUP, C5_XPAGRUP, C5_XEAGRUP //Everson - 26/09/2022. Ticket 80379.
		FROM %table:SC5% SC5,  %table:SA1% SA1 
		WHERE SC5.%notDel% AND SA1.%notDel% AND SC5.C5_FILIAL = %xFilial:SC5% AND SA1.A1_FILIAL = %xFilial:SA1% 
		AND SC5.C5_CLIENTE = SA1.A1_COD
		AND SC5.C5_LOJACLI = SA1.A1_LOJA
		AND SC5.C5_TIPO = 'N'
		AND SC5.C5_PLACA <> ' '
		AND SC5.C5_NOTA = ' '
		AND SC5.C5_ROTEIRO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
		AND SC5.C5_PLACA BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%	
		AND SC5.C5_DTENTR BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%		
		AND SC5.C5_XCAGRUP BETWEEN %exp:MV_PAR08% AND %exp:MV_PAR09% //Everson - 26/09/2022. Ticket 80379		
		AND SC5.C5_XPAGRUP BETWEEN %exp:MV_PAR10% AND %exp:MV_PAR11% //Everson - 26/09/2022. Ticket 80379		
		AND %exp:cRest01% 	
		UNION ALL	
		SELECT C5_DTENTR,C5_ROTEIRO,C5_PLACA,C5_NUM,C5_CLIENTE,A2_NREDUZ,C5_X_SQED,C5_XINT,C5_XOBS,C5_FILIAL,C5_XFATANT,C5_XCAGRUP, C5_XPAGRUP, C5_XEAGRUP //Everson - 26/09/2022. Ticket 80379.
		FROM %table:SC5% SC5,  %table:SA2% SA2 
		WHERE SC5.%notDel% AND SA2.%notDel% AND SC5.C5_FILIAL = %xFilial:SC5% AND SA2.A2_FILIAL = %xFilial:SA2% 
		AND SC5.C5_CLIENTE = SA2.A2_COD
		AND SC5.C5_LOJACLI = SA2.A2_LOJA
		AND SC5.C5_TIPO = 'B'
		AND SC5.C5_PLACA <> ' '
		AND SC5.C5_NOTA = ' '
		AND SC5.C5_ROTEIRO BETWEEN %exp:MV_PAR01% AND %exp:MV_PAR02%
		AND SC5.C5_PLACA BETWEEN %exp:MV_PAR03% AND %exp:MV_PAR04%		
		AND SC5.C5_DTENTR BETWEEN %exp:MV_PAR05% AND %exp:MV_PAR06%	
		AND SC5.C5_XCAGRUP BETWEEN %exp:MV_PAR08% AND %exp:MV_PAR09% //Everson - 26/09/2022. Ticket 80379	
		AND SC5.C5_XPAGRUP BETWEEN %exp:MV_PAR10% AND %exp:MV_PAR11% //Everson - 26/09/2022. Ticket 80379		
		AND %exp:cRest01% 	
		ORDER BY SC5.C5_XCAGRUP, SC5.C5_DTENTR,SC5.C5_ROTEIRO,SC5.C5_PLACA,SC5.C5_NUM //Everson - 30/09/2022. Ticket 80379	

	EndSQL
	(cAliasT)->(dbGoTop())
	If !(cAliasT)->(Eof())
		
		//Tratamento de tipo de dados  
		
		dbSelectArea("SX3")
		SX3->(dbSetOrder(2))
		For ni := 1 to Len(aHeader01)
			If !Empty(aHeader01[ni][TCB_POS_CMP]) .AND. aHeader01[ni][TCB_POS_TIP] # "C"
				SX3->(dbSeek(PadR(aHeader01[ni][TCB_POS_CMP],10)))
				If SX3->(Found())
					TcSetField(cAliasT,SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL)
				Endif
			Endif
		Next ni
		
		//Alimentar dados  
		
		Do While !(cAliasT)->(Eof())

			_lLib := .T.
			
			//Mauricio 08/01/16 - Novo tratamento para liberacao a integração.
			SC6->(dbSetOrder(1)) // Indice ( pedido )
			If SC6->(dbSeek((cAliasT)->(C5_FILIAL+C5_NUM)))
				While !SC6->(Eof()) .and. SC6->(C6_FILIAL+C6_NUM) == (cAliasT)->(C5_FILIAL+C5_NUM)

					SC9->(dbSetOrder(1)) // Indice ( pedido )
					If SC9->(dbSeek( SC6->(C6_FILIAL+C6_NUM+C6_ITEM)))
						If SC6->C6_PRODUTO == SC9->C9_PRODUTO	//confiro se o produto eh o mesmo.
							If !Empty(SC9->C9_BLEST ) .OR. !Empty(SC9->C9_BLCRED) 
								
								_lLib := .F.
								cErro += "Ola " + cNomeUs + ", Existe Produto nesse Pedido que não está liberado credito ou Estoque Verifique com o Financeiro, Pedido: " + (cAliasT)->C5_NUM + CHR(13) + CHR(10)


							Endif
						Else
							_lLib := .F.
							cErro += "Ola " + cNomeUs + ", Existe Produto nesse Pedido que não está liberado credito ou Estoque Verifique com o Financeiro, Pedido: " + (cAliasT)->C5_NUM + CHR(13) + CHR(10)
						Endif
					Else
						_lLib := .F.
						cErro += "Ola " + cNomeUs + ", Existe Produto nesse Pedido que não está liberado credito ou Estoque Verifique com o Financeiro, Pedido: " + (cAliasT)->C5_NUM + CHR(13) + CHR(10)
					Endif
					SC6->(dbSkip())
				EndDo
			Else
				_lLib := .F.		
				cErro += "Ola " + cNomeUs + ", Existe Produto nesse Pedido que não está liberado credito ou Estoque Verifique com o Financeiro, Pedido: " + (cAliasT)->C5_NUM + CHR(13) + CHR(10)
			EndIf

			If _lLib
				aTMP := Array((cAliasT)->(FCount()) + 1)
				aTMP[1] := .F.
				For ni := 1 to (cAliasT)->(FCount())
					aTMP[ni + 1] := (cAliasT)->(FieldGet(ni))
				Next ni
				aAdd(_aDados01,aClone(aTMP))			
			EndIf                          
			(cAliasT)->(dbSkip())
		EndDo
	Else
		
		//Zerar lista de dados  
		
		_aDados01 := Array(1,Len(aHeader01) + 1)
		For ni := 1 to Len(_aDados01)
			_aDados01[ni][1] := .F.
			For nx := 1 to Len(aHeader01)
				_aDados01[ni][nx + 1] := CriaVar(aHeader01[nx][TCB_POS_CMP],.F.)
			Next nx
		Next ni	
	Endif
	U_FecArTMP(cAliasT)

Return Nil


/*/{Protheus.doc} User Function CCSP001GD
	Rotina pra fazer o tratamento de selecao de dados
	@type  Function
	@author Pablo Gollan Carreras
	@since 14/06/2012
	
/*/
Static Function CCSP001GD(nOpc,aDados,oGDSel,nColSel,aHead)

	Local ni				:= 0
	Local cRoteiro			:= ""

	PARAMTYPE 0	VAR nOpc		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 1	VAR aDados		AS Array		OPTIONAL	DEFAULT Array(0)
	PARAMTYPE 2	VAR oGDSel		AS Object		OPTIONAL	DEFAULT Nil
	PARAMTYPE 3	VAR nColSel		AS Numeric		OPTIONAL	DEFAULT 1
	PARAMTYPE 4	VAR aHead		AS Array		OPTIONAL	DEFAULT Array(0)

	If nOpc == 1
		dData     := U_GDField(2,aHead,aDados,TCB_POS_CMP,"C5_DTENTR",oGDSel:nAt,.T.)
		cRoteiro  := U_GDField(2,aHead,aDados,TCB_POS_CMP,"C5_ROTEIRO",oGDSel:nAt,.T.)
		cPlaca    := U_GDField(2,aHead,aDados,TCB_POS_CMP,"C5_PLACA",oGDSel:nAt,.T.)	

		cCrgAgr	  := U_GDField(2,aHead,aDados,TCB_POS_CMP,"C5_XCAGRUP",oGDSel:nAt,.T.) //Everson - 26/09/2022. Ticket 80379.

		//Everson - 26/09/2022. Ticket 80379.
		If ! Empty(cCrgAgr)

			aDados[oGDSel:nAt][1] := !aDados[oGDSel:nAt][1]
			For ni := 1 to Len(aDados)
				If oGDSel:nAt<>ni 
					If U_GDField(2,aHead,aDados,TCB_POS_CMP,"C5_XCAGRUP",ni,.T.) == cCrgAgr
						aDados[ni][1] := !aDados[ni][1]
					EndIf
				Endif
			Next ni

		ElseIf !Empty(cRoteiro)
			aDados[oGDSel:nAt][1] := !aDados[oGDSel:nAt][1]
			For ni := 1 to Len(aDados)
				If oGDSel:nAt<>ni 
					If U_GDField(2,aHead,aDados,TCB_POS_CMP,"C5_DTENTR",ni,.T.) == dData .and. ;
					U_GDField(2,aHead,aDados,TCB_POS_CMP,"C5_ROTEIRO",ni,.T.) == cRoteiro .and. ;
					U_GDField(2,aHead,aDados,TCB_POS_CMP,"C5_PLACA",ni,.T.) == cPlaca
						aDados[ni][1] := !aDados[ni][1]
					EndIf
				Endif
			Next ni
		Endif

	Else

		If nColSel == 1

			For ni := 1 to Len(aDados)
			
				If !Empty(U_GDField(2,aHead,aDados,TCB_POS_CMP,"C5_ROTEIRO",ni,.T.))
					aDados[ni][1] := !aDados[ni][1]

				Endif

			Next ni

		Else
			aDados := aSort(aDados,,,{|x,y| x[nColSel] < y[nColSel]})

		EndIf

	Endif
	
	//Montar a lista de titulos selecionados  
	
	aLstPED := Array(0)
	For ni := 1 to Len(aDados)
		If aDados[ni][1]
			aAdd(aLstPED,U_GDField(2,aHead,aDados,TCB_POS_CMP,{"C5_DTENTR","C5_ROTEIRO","C5_PLACA","C5_NUM","C5_CLIENTE","A1_NREDUZ","C5_X_SQED","C5_XINT","C5_XOBS","C5_FILIAL","C5_XFATANT", "C5_XCAGRUP", "C5_XPAGRUP", "C5_XEAGRUP"},ni,.T.)) //Everson - 26/09/2022. Ticket 80379.
		Endif
	Next ni
	//Forcar a atualizacao do browse
	oGDSel:DrawSelect()

Return Nil



/*/{Protheus.doc} User Function CCS_001P
	Rotina de processamento de registros selecionados
	@type  Function
	@author Pablo Gollan Carreras
	@since 14/06/2012
	
/*/
Static Function CCS_001P(oTela)

	//Variáveis.
	Local lRet				:= .T.
	Local _xx				:= 0
	Local _nPedDiv			:= 0
	Local cChave			:= ""
	Local cMens				:= ""
	Local cRest01			:= ""
	Local cQuery            := "" 
	Local cPed              := ""
	Local cProduto          := ""
	Local nLstPED			:= len(aLstPED)

	//Everson - 26/09/2022. Ticket 80379.
	Local cStatus			:= ""
	Local cCrgAgr			:= "" 
	Local cPlcAgr			:= ""
	Local cQryCrg			:= ""
	Local cNewAlias			:= ""
	Local aRoteiros			:= {}
	Local lProcTrans		:= .T.
	Local nCount			:= 0
	Local cScriptSql		:= ""
	//
	
	Private _nx				:= 0
	Private ni				:= 0
	Private cFilia         	:= ""
	
	// @history ticket 63303   - Leonardo P. Monteiro - 08/11/2021 - Melhoria na validação do estorno de cargas para não permitir a exclusão de cargas que já tenham pallets vinculados ao mesmo.
	If lVldEnv .And. ! LockByName("CCS_001P", .T., .F.)
	    u_GrLogZBE(Date(),TIME(),cUserName,"Lockbyname executado para a rotina CCS_001P.","SIGAFAT","CCS_001P",;
			    "Rotina já iniciada por outro usuário através da rotina CCS_001P. ",ComputerName(),LogUserName())
        
        MsgInfo("Rotina sendo executada por outro usuário! Aguarde o término da execução.", "..:: Em execução ::.. ")

		Return .T.

    EndIf

	PARAMTYPE 0	VAR oTela	AS Object	OPTIONAL	DEFAULT Nil

	If Empty(aLstPED) .OR. ValType(aLstPED) # "A"
		Return .F.

	Endif

	//Montar a lista de contabilizacao  
	cData	 := ""
	cRoteiro := ""
	cPlaca	 := ""
	cCrgAgr  := "" //Everson - 26/09/2022. Ticket 80379.

	//Mauricio - 26/06/2017 - chamado 35017 - INICIO - Não processar se existir mais de um pedido DIVERSOS com roteiros iguais. Roteiros devem ser diferentes.
	_aPedDiv := {}

	//Obtém pedidos diversos.
	For nCount := 1 to nLstPED

		fchkped(aLstPED[nCount][4],aLstPED[nCount][5],aLstPED[nCount][10]) //Pedido, Cliente, Filial
		cFilia := aLstPED[nCount][10]

	Next nCount

	If Len(_aPedDiv) > 0  // tem pedido diversos. Cada linha eh uma data de entrega + roteiro + pedido diferente.

		_aRotDiv := {}
		l_Ret := .F.
		_nPedDiv	:= _aPedDiv
		For _xx := 1 to _nPedDiv
			_nAscan := Ascan( _aRotDiv, { |x|x[ 01 ] == _aPedDiv[_xx][1]+_aPedDiv[_xx][2] } )
			If _nAscan <= 00
				Aadd( _aRotDiv, { _aPedDiv[_xx][1]+_aPedDiv[_xx][2] } )
			Else             //achou data de entrega + roteiro repetido
				l_Ret := .T.
			Endif
		Next _xx

		If l_Ret
			MsgInfo("Existem pedidos DIVERSOS com roteiros IGUAIS! Corrija isso antes do envio ao Edata.","Atenção")
			Return .F.  

		Endif

	Endif   

	For ni := 1 to nLstPED

		If (Empty(AllTrim(aLstPED[ni][12])) .And. cData+cRoteiro+cPlaca == AllTrim(Dtos(aLstPED[ni][1]))+AllTrim(aLstPED[ni][2])+AllTrim(aLstPED[ni][3])); //Everson - 26/09/2022. Ticket 80379.
		   .Or. (!Empty(AllTrim(aLstPED[ni][12])) .And. cCrgAgr == AllTrim(aLstPED[ni][12]))  //Everson - 26/09/2022. Ticket 80379.
			Loop

		EndIf

		//Salva Roteiro em processamento
		cStatus		:= aLstPED[ni][8]
		cData	    := AllTrim(Dtos(aLstPED[ni][1]))
		cRoteiro    := AllTrim(aLstPED[ni][2])
		cPlaca	    := AllTrim(aLstPED[ni][3])

		//Everson - 26/09/2022. Ticket 80379.
		cCrgAgr 	:= AllTrim(aLstPED[ni][12])
		cPlcAgr		:= AllTrim(aLstPED[ni][13])
		cDtTrans    := AllTrim(Dtos(aLstPED[ni][14]))
		aRoteiros	:= {}
		lProcTrans	:= .T.
		//

		cErro       := ""
		cPed        := ""
		cProduto    := ""

		If !(cStatus $ "1|2|4| " )
			cMens += "- Roteiro não processado, enviado anteriormente Roteiro: [" + AllTrim(cRoteiro) + "]" + Iif(Empty(cCrgAgr), "", " Transbordo: [" + cCrgAgr + "]") + CRLF
			Loop

		EndIf

		//Everson - 26/09/2022 - Ticket 80379.
		If Empty(cCrgAgr)  //Carga sem agrupamento.

			//Diversas validações da carga.
			   //vldCarga(cData, cRoteiro, cPlaca, cCrgAgr, cPlcAgr, cNomeUs, cMens)
			If ! vldCarga(cData, cRoteiro, cPlaca, cCrgAgr, cPlcAgr, cNomeUs, @cMens)
				Loop

			EndIf

			//Cria sequencia Edata.
			aRet := CCSP_001S(cData,cRoteiro,cPlaca)
			If 	aRet[1]
				cSeq := aRet[2]

			Else
				cMens += "- Roteiro não processado, erro no sequenciamento do edata: [" + AllTrim(aLstPED[ni][2]) + "]" + CRLF			
				loop

			EndIf  

		Else //Carga com agrupamento.

			cQryCrg := " SELECT DISTINCT C5_DTENTR, C5_ROTEIRO, C5_PLACA FROM " + RetSqlName("SC5") + " (NOLOCK) AS SC5 WHERE C5_FILIAL = '" + FWxFilial("SC5") + "' AND C5_XCAGRUP = '" + cCrgAgr + "' AND SC5.D_E_L_E_T_ = '' ORDER BY C5_ROTEIRO "

			cNewAlias := GetNextAlias()
			DbUseArea(.T., "TOPCONN", TCGenQry(,, cQryCrg), cNewAlias, .F., .T.)
			(cNewAlias)->(DbGoTop())

			If (cNewAlias)->(Eof())
				cMens += "- Não foi possível obter os roteiros do Transbordo: [" + cCrgAgr + "]" + CRLF	
				(cNewAlias)->(DbCloseArea())		
				Loop

			EndIf
			
			While ! (cNewAlias)->(Eof())

				Aadd(aRoteiros, { (cNewAlias)->C5_DTENTR, (cNewAlias)->C5_ROTEIRO, (cNewAlias)->C5_PLACA })
	
				(cNewAlias)->(DbSkip())

			End

			(cNewAlias)->(DbCloseArea())

			lProcTrans := .T.

			For nCount := 1 To Len(aRoteiros)

				//Diversas validações da carga.
				   //vldCarga(cData, cRoteiro, cPlaca, cCrgAgr, cPlcAgr, cNomeUs, cMens)
				If ! vldCarga(aRoteiros[nCount][1], aRoteiros[nCount][2], aRoteiros[nCount][3], cCrgAgr, cPlcAgr, cNomeUs, @cMens)
					lProcTrans := .F.
					Exit

				EndIf

			Next nCount

			If ! lProcTrans
				Loop

			EndIf

			Begin Transaction

				For nCount := 1 To Len(aRoteiros)

					aRet := CCSP_001S(aRoteiros[nCount][1], aRoteiros[nCount][2], aRoteiros[nCount][3])

					If ! aRet[1]
						lProcTrans := .F.
						cMens += "- Roteiro não processado, erro no sequenciamento do edata: [" + AllTrim(aRoteiros[nCount][2]) + "] Transbordo: [" + cCrgAgr + "]" + CRLF			
						DisarmTransaction()
						Break

					EndIf

				Next nCount

			End Transaction

			If ! lProcTrans
				Loop

			EndIf

		EndIf
		
		Begin Transaction //CHAMADO: T.I FERNANDO SIGOLI 10/02/2020       

			//Everson - 26/09/2022 - Ticket 80379.
			If lTransbordo

				
				IF Alltrim(cEmpAnt) == '01' //ADORO
					
					If Alltrim(cFilAnt) == "02"

						cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"

					ElseIf  Alltrim(cFilAnt) <> "02" 

						cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"

					Endif

				ElseIF Alltrim(cEmpAnt) == '02' //CERES
					
					cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' +Str(Val(cSeq))+",'0',"+"'"+cEmpAnt+"'"

				ElseIF Alltrim(cEmpAnt) == '13' //VISTA FOODS
					
					cScriptSql := 'EXEC ['+cLnkSrv+'].[SMARTSCA].[dbo].[FI_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"

				ENDIF
			Else

				IF Alltrim(cEmpAnt) == '01' //ADORO
				
					IF Alltrim(cFilAnt) == "02"
						
						cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"

					Else
						
						cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"
					
					EndIF
				
				ElseIF Alltrim(cEmpAnt) == '02' //CERES

					cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"
					

				ElseIF Alltrim(cEmpAnt) == '13' //VISTA FOODS

					cScriptSql := 'EXEC ['+cLnkSrv+'].[SMARTSCA].[dbo].[FI_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"
						
				
				EndIf

			EndIf
			//

			TcSQLExec(cScriptSql)

			cErro := ""
			cErro := U_RetErroED() 

			//Everson - 13/01/2023 - Ticket TI. 
			If ! Empty(cErro)
				DisarmTransaction()
				Break

			EndIf

		End Transaction //CHAMADO: T.I FERNANDO SIGOLI 10/02/2020  	

		//Everson - 13/01/2023 - Ticket TI. 
		If Empty(cErro)

			If Empty(cCrgAgr)	   
				CCSP_001F(cData,cRoteiro,cPlaca,"3","OK")

			Else

				For nCount := 1 To Len(aRoteiros)
					CCSP_001F(aRoteiros[nCount][1], aRoteiros[nCount][2], aRoteiros[nCount][3],"3","OK")

				Next nCount

			EndIf

		Else
		
			cMens += cErro

			If Empty(cCrgAgr)	   
				CCSP_001F(cData, cRoteiro, cPlaca, "4", cErro)

			Else

				For nCount := 1 To Len(aRoteiros)
					CCSP_001F(aRoteiros[nCount][1], aRoteiros[nCount][2], aRoteiros[nCount][3], "4", cErro)

				Next nCount

			EndIf

		Endif								

		//envio carga edata
		If Empty(cCrgAgr)
			u_GrLogZBE(Date(),TIME(),cUserName,"INTEGRACAO CARGA EDATA","LOGISTICA","CCS_001P",;
			" CHAVE "+AllTrim(Dtos(aLstPED[ni][1]))+" "+AllTrim(aLstPED[ni][2])+" "+AllTrim(aLstPED[ni][3])+" "+AllTrim(aLstPED[ni][4]),ComputerName(),LogUserName()) 

		Else
			u_GrLogZBE(Date(),TIME(),cUserName,"INTEGRACAO CARGA EDATA TRANSBORDO","LOGISTICA","CCS_001P",;
			" CHAVE TRANSBORDO " + cCrgAgr, ComputerName(), LogUserName()) 

		EndIf

	Next ni

	If !Empty(cMens)
		cMens := "Lista de itens que não foram processados : " + CRLF + cMens
		U_ExTelaMen(cRotDesc,cMens,"Arial",10,,.F.,.T.)
		
	Endif

	If lVldEnv
		UnLockByName("CCS_001P")

	EndIf

	If oTela # Nil
		oTela:SetFocus()
	Endif

Return lRet
/*/{Protheus.doc} vldCarga
	Validações da carga
	@type  Static Function
	@author Everson
	@since 26/09/2022
	@version 01
/*/
Static Function vldCarga(cData, cRoteiro, cPlaca, cCrgAgr, cPlcAgr, cNomeUs, cMens)

	//Variáveis.
	Local cErro		:= ""
	Local lCargaOk	:= .F.
	Local lRet		:= .F.
	
	lRet := fExistCarg(@lCargaOk, cData, cRoteiro, @cErro); 					  		// Valida se a carga já existe no eData. //****************Verificar os campos a serem validados, quando a carga for transbordo.
			.And. fEnceCarg(@lCargaOk, Iif(Empty(cCrgAgr), cPlaca, cPlcAgr), @cErro);   // Valida se a carga já existe no eData e não foi encerrada. //****************Verificar os campos a serem validados, quando a carga for transbordo.
			.And. fVerFin(cData, cRoteiro, cPlaca, cCrgAgr, @cErro); 				  	// Valida condição financeira.
			.And. chkPed(cData, cRoteiro, cNomeUs, @cErro) 							  	// Valida pedidos diversos.
				
	If ! lRet .And. ! lCargaOk	

		cMens += "- Roteiro não processado: [" + cRoteiro + "]" + CRLF + " " + Iif(Empty(cCrgAgr), "", " Transbordo: [" + cCrgAgr + "] ") + " - Erro : [" + cErro + "]"  + CRLF				
				
		CCSP_001F(cData, cRoteiro, cPlaca, "4", cErro)		
			
	EndIf	

Return lRet
/*/{Protheus.doc} chkPed
	Valida pedido de venda.
	@type  Static Function
	@author Everson
	@since 26/09/2022
	@version 01
/*/
Static Function chkPed(cData, cRoteiro, cNomeUs, cErro)

	//Variáveis.
	Local lRet		  := .T.
	Local ncontPedTot := 0
	Local ncontPedNor := 0
	Local ncontPedDiv := 0
	Local cPed		  := ""
	Local cProduto	  := ""

	// *** INICIO CHAMADO 038577 WILLIAM COSTA *** //
	// *** INICIO VERIFICA SE EXISTE CARGA DIVERSA EM CARGA NORMAL *** //
	
	SqlVerifRoteiro(cData,cRoteiro) //ve quantos pedidos tem no roteiro
	
	While TDIX->(!EOF())

		If TDIX->CONT_PED > 0

			ncontPedTot := ncontPedTot + TDIX->CONT_PED   //Quantidade de Pedidos Normais

		EndIf     

		If TDIX->CONT_NORMAL > 0

			ncontPedNor := ncontPedNor + TDIX->CONT_NORMAL   //Quantidade de Pedidos Normais

		EndIf

		If TDIX->CONT_DIVERSOS > 0

			ncontPedDiv := ncontPedDiv + TDIX->CONT_DIVERSOS //Quantidade de Pedidos Diversos

		EndIf     
		TDIX->(dbSkip())

	End
	TDIX->(dbCloseArea())

	If ncontPedNor > 0 .AND. ncontPedDiv > 0 //significa que tem mais de um pedido no roteiro

		SqlVerifDiversos(cData, cRoteiro)

		While TDIZ->(!EOF())

			cPed := cPed + TDIZ->C5_NUM + ', '

			TDIZ->(dbSkip())

		ENDDO
		TDIZ->(dbCloseArea())

		lRet := .F.
		cErro += "Olá " + cNomeUs + ", Existem pedidos DIVERSOS e pedidos normais dentro do mesmo Roteiro! Corrija isso antes do envio ao Edata." + " Pedidos: " + cPed + "não pode ficar junto com os outros. Pedidos Diversos C5_XTIPO == 2" + CRLF

	EndIf

	// *** FINAL VERIFICA SE EXISTE CARGA DIVERSA EM CARGA NORMAL *** //

	// *** INICIO VERIFICA SE TODOS OS PRODUTOS QUE SERAO ENVIADOS ESTAO NO EDATA *** //

	If ncontPedTot <> ncontPedDiv //significa que o pedidos sao normais

		SqlVerifProdutos(cData,cRoteiro)

		While TDJA->(!EOF())

			If ALLTRIM(TDJA->IE_MATEEMBA) == "" //significa que o produto não esta cadastrado no Edata

				cProduto := cProduto + ALLTRIM(TDJA->C6_PRODUTO) + ', '

			EndIf    
			TDJA->(dbSkip())

		ENDDO
		TDJA->(dbCloseArea())

	EndIf	

	If !EMPTY(cProduto)
		lRet := .F.
		cErro += "Olá " + cNomeUs + ", Existe Produto nesse Roteiro que não está cadastrado no Edata! Corrija isso antes do envio ao Edata." + " Produto: " + cProduto + "Verifique com o PCP" + CRLF

	EndIf	

	// *** FINAL VERIFICA SE TODOS OS PRODUTOS QUE SERAO ENVIADOS ESTAO NO EDATA *** //

	// *** FINAL CHAMADO 038577 WILLIAM COSTA *** //	

Return lRet

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 07/04/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function fVerFin(cData, cRoteiro, cPlaca, cCrgAgr, cErro)

	Local cQuery 	:= ""
	Local lRet		:= .T.

	Default cCrgAgr := ""

	cQuery := " SELECT DISTINCT C5_NUM, C5_XWSPAGO, E1.E1_SALDO, C5.R_E_C_N_O_ REGSC5  "
	cQuery += " FROM  "+ Retsqlname("SC5") +" C5 WITH(NOLOCK) "
	cQuery += " 	INNER JOIN "+ RetsqlName("FIE") +" FIE WITH(NOLOCK) ON FIE.D_E_L_E_T_='' AND C5.C5_FILIAL=FIE.FIE_FILIAL AND C5.C5_NUM=FIE.FIE_PEDIDO AND FIE.FIE_CART='R' "
	CqUERY += " 	INNER JOIN "+ Retsqlname("SE1") +" E1  WITH(NOLOCK) ON E1.D_E_L_E_T_='' AND FIE.FIE_FILIAL=E1.E1_FILIAL AND FIE.FIE_CLIENT=E1.E1_CLIENTE AND FIE.FIE_LOJA=E1.E1_LOJA AND FIE.FIE_PREFIX=E1.E1_PREFIXO AND FIE.FIE_NUM=E1.E1_NUM AND FIE.FIE_PARCEL=E1.E1_PARCELA AND FIE.FIE_TIPO=E1.E1_TIPO "
	cQuery += " WHERE "
	cQuery += " C5.C5_FILIAL='"+ xFilial("SC5") +"' AND C5.D_E_L_E_T_='' "

	//Everson - 26/09/2022. Ticket 80379.
	If Empty(cCrgAgr)
		cQuery += " AND C5.C5_DTENTR='"+ cData +"' AND C5.C5_ROTEIRO='"+ cRoteiro +"' AND C5.C5_PLACA='"+ cPlaca +"'; "

	Else
		cQuery += " AND C5_XCAGRUP = '" + cCrgAgr + "'; "

	EndIf
	//

	TcQuery cQuery ALIAS "QSC5" NEW

	While QSC5->(!eof())
		if empty(QSC5->C5_XWSPAGO)
			lRet := .f.
			cErro += "Roteiro ["+ cRoteiro +"] não pôde ser integrado devido ao PV ["+ QSC5->C5_NUM +"] ter adiantamentos pendentes de aprovação."
		endif

		QSC5->(Dbskip())
	Enddo

	QSC5->(DBCLOSEAREA())

	// @history ticket 71027   - Fernando Macieira    - 07/04/2022 - Liberação Pedido Antecipado sem Aprovação Financeiro - PV 9BEGCC foi incluído depois que o job do boleto parou, não gerou FIE e SE1 (PR) e foi liberado manualmente pelo financeiro, sendo faturado como pv normal... por isso da dupla checagem
	If lRet 
		
		If Select("QSC5") > 0
			QSC5->( dbCloseArea() )
		EndIf
		
		cQuery := " SELECT DISTINCT C5_NUM, C5_XWSPAGO, C5.R_E_C_N_O_ REGSC5
		cQuery += " FROM  "+ Retsqlname("SC5") +" C5 WITH (NOLOCK)
		cQuery += " INNER JOIN " + RetSqlName("SE4") + " SE4 (NOLOCK) ON E4_FILIAL='"+FWxFilial("SE4")+"' AND E4_CODIGO=C5_CONDPAG AND E4_CTRADT='1' AND SE4.D_E_L_E_T_=''
		cQuery += " WHERE C5.D_E_L_E_T_='' AND C5.C5_FILIAL='"+ xFilial("SC5") +"' AND C5.C5_DTENTR='"+ cData +"' AND C5.C5_ROTEIRO='"+ cRoteiro +"' AND C5.C5_PLACA='"+ cPlaca +"'; "

		TcQuery cQuery ALIAS "QSC5" NEW

		While QSC5->(!eof())
			if empty(QSC5->C5_XWSPAGO)
				lRet := .f.
				cErro += "Roteiro ["+ cRoteiro +"] não pôde ser integrado devido ao PV ["+ QSC5->C5_NUM +"] ter adiantamentos pendentes de aprovação."
			endif
			QSC5->(Dbskip())
		Enddo

		If Select("QSC5") > 0
			QSC5->( dbCloseArea() )
		EndIf

	EndIf
	//

return lRet

Static Function fEnceCarg(lCargaOk, cPlaca, cErro)

	//Variáveis.
	Local lRet := .T.

	//Inicio. Chamado: 049906  Fernando Sigoli 24/06/2019
	cQry := " SELECT IE_PEDIVEND, "
	cQry += "        ID_CARGEXPE, "
	cQry += "        GN_PLACVEICTRAN, "
	cQry += "        ROTEIRO, " 
	cQry += "        DT_ENTRPEDIVEND "
	cQry += "   FROM ["+cLnkSrv+"].["+cLinkBD+"].[dbo].[VW_ERRO_03] " //alterado 26/05/2023 - Sigoli
	cQry += "   WHERE FL_STATCARGEXPE   <> 'FE' "
	cQry += "   AND GN_PLACVEICTRAN = " + "'" + ALLTRIM(cPlaca) + "'"

	dbUseArea( .T., "TOPCONN", TCGenQry( ,, cQry ), "TRF", .F., .T. )             

	While TRF->(!EOF())

		If TRF->ID_CARGEXPE > 0 //so retorna erro se tiver informacao da carga na tabela do edata

			lRet := .F.
			cErro += "Carga não enviada, carga: " + cvaltochar(TRF->ID_CARGEXPE) + " nao encerrada no EDATA para este veiculo " +ALLTRIM(cPlaca)+ ", favor verificar!!! " + CRLF  //Chamado: 049906  Fernando Sigoli 27/06/2019	

			If VAL(AllTrim(aLstPED[ni][7])) == TRF->ID_CARGEXPE .OR. ;
			   AllTrim(aLstPED[ni][7])      == ""

				lCargaOk := .T.  

			EndIf	    
		EndIf
	TRF->(dbSkip())
	ENDDO
	TRF->(dbCloseArea())	
	
	//Fim. Chamado: 049906  Fernando Sigoli 24/06/2019
return lRet


Static Function fExistCarg(lCargaOk, cData, cRoteiro, cErro)

	//Variáveis.
	Local lRet := .T.

	// * INICIO VERIFICACAO SE A CARGA JA FOI ENVIADA PARA O  EDATA - WILLIAM COSTA *//
	// ** INICIO VERIFICACAO SE A CARGA FOI DELETADA NO EDATA - WILLIAM COSTA ** //

	cQuery := " SELECT IE_PEDIVEND, "
	cQuery += "        ID_CARGEXPE, "
	cQuery += "        GN_PLACVEICTRAN, "
	cQuery += "        ROTEIRO, " 
	cQuery += "        DT_ENTRPEDIVEND "
	cQuery += "   FROM ["+cLnkSrv+"].["+cLinkBD+"].[dbo].[VW_ERRO_02] " //alterado 26/05/2023 - Sigoli
	cQuery += "  WHERE ROTEIRO         = " + "'" + ALLTRIM(cRoteiro) + "'"
	cQuery += "    AND DT_ENTRPEDIVEND = " + "'" + ALLTRIM(cData)    + "'"

	dbUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )             

	While TRB->(!EOF())

		If TRB->ID_CARGEXPE > 0 //so retorna erro se tiver informacao da carga na tabela do edata
			
			lRet := .F.
			cErro += "Carga não enviada para o EDATA, já existe a carga no Edata, favor estornar antes de enviar novamente, favor verificar!!! " + CRLF

			If VAL(AllTrim(aLstPED[ni][7])) == TRB->ID_CARGEXPE .OR. ;
			AllTrim(aLstPED[ni][7])      == ""

				lCargaOk := .T.  

			EndIf	    
		EndIf
		TRB->(dbSkip())
	ENDDO
	TRB->(dbCloseArea())	
	// ** FINAL VERIFICACAO SE A CARGA FOI DELETADA NO EDATA - WILLIAM COSTA ** //

return lRet

/*/{Protheus.doc} User Function CCS_001E
	Rotina de estorno processamento de registros selecionados
	@type  Function
	@author Pablo Gollan Carreras
	@since 14/06/2012
	
/*/

Static Function CCS_001E(oTela)

	Local lRet				:= .T.
	Local aArea				:= {}
	Local ni				:= 0
	Local cChave		  	:= ""
	Local cMens				:= ""
	Local cRest01			:= ""
	Local cQuery            := "" 
	Local cScriptSql		:= ""

	////Ticket 80379   - Everson - 04/10/2022 - Tratamento para estorno de carga de transbordo.
	Local cNewAlias			:= ""
	Local aRoteiros			:= {}
	Local nCount			:= 1
	Local cQryCrg			:= ""

	// @history ticket 63303   - Leonardo P. Monteiro - 08/11/2021 - Melhoria na validação do estorno de cargas para não permitir a exclusão de cargas que já tenham pallets vinculados ao mesmo.
	If !LockByName("CCS_001E", .T., .F.) .AND. lVldEnv
	    u_GrLogZBE(Date(),TIME(),cUserName,"Lockbyname executado para a rotina CCS_001E.","SIGAFAT","CCS_001E",;
			    "Rotina já iniciada por outro usuário através da função CCS_001E. ",ComputerName(),LogUserName())
        
        MsgInfo("Rotina sendo executada por outro usuário! Aguarde o término da execução.", "..:: Em execução ::.. ")
    else

		PARAMTYPE 0	VAR oTela	AS Object	OPTIONAL	DEFAULT Nil

		If Empty(aLstPED) .OR. ValType(aLstPED) # "A"
			Return !lRet
		Endif

		//Montar a lista de contabilizacao  
		
		cSeq	 := ""
		cCrgAgr  := ""

		For ni := 1 to Len(aLstPED)                   

			If !(aLstPED[ni][8] $ "3" )
				cMens += "- Roteiro não pode ser estornado pois ainda não foi processado: [" + AllTrim(aLstPED[ni][2]) + "]" + CRLF
			
			//Ticket 80379   - Everson - 04/10/2022 - Tratamento para estorno de carga de transbordo.
			// @history ticket 63303   - Leonardo P. Monteiro - 08/11/2021 - Melhoria na validação do estorno de cargas para não permitir a exclusão de cargas que já tenham pallets vinculados ao mesmo.
			elseif fVldEst(Iif(Empty(aLstPED[ni][12]),aLstPED[ni][7],aLstPED[ni][12]))
				cMens += "- Roteiro não pode ser estornado pois existe paletes vinculados a carga: [" + AllTrim(Iif(Empty(aLstPED[ni][12]),aLstPED[ni][7],aLstPED[ni][12])) + "]."+Chr(13)+Chr(10)+" Solicite ao setor de Expedição que estorne as cargas vinculadas." + CRLF
			elseif fVldLei(Iif(Empty(aLstPED[ni][12]),aLstPED[ni][7],aLstPED[ni][12]))
				cMens += "- Desmarcar no eData a leitura da observação da carga número [" + AllTrim(Iif(Empty(aLstPED[ni][12]),aLstPED[ni][7],aLstPED[ni][12])) + "]."+Chr(13)+Chr(10)+" Solicite ao setor de Expedição que retire o registro de leitura." + CRLF
			elseif fVldlPe(Iif(Empty(aLstPED[ni][12]),aLstPED[ni][7],aLstPED[ni][12]))
				cMens += "- Desmarcar no eData a leitura da observação do pedido contido na carga número [" + AllTrim(Iif(Empty(aLstPED[ni][12]),aLstPED[ni][7],aLstPED[ni][12])) + "]."+Chr(13)+Chr(10)+" Solicite ao setor de Expedição que retire o registro de leitura do pedido de venda." + CRLF
			Else

				If (Empty(aLstPED[ni][12]) .And. cSeq <> AllTrim(aLstPED[ni][7])) .Or.; //Ticket 80379   - Everson - 04/10/2022 - Tratamento para estorno de carga de transbordo.
				   ( !Empty(aLstPED[ni][12]) .And. cCrgAgr <> AllTrim(aLstPED[ni][12]) )

					//Salva Roteiro em processamento
					cData	 := AllTrim(Dtos(aLstPED[ni][1]))
					cRoteiro := AllTrim(aLstPED[ni][2])
					cPlaca	 := AllTrim(aLstPED[ni][3])
					cSeq	 := AllTrim(aLstPED[ni][7])
					cCrgAgr	 := aLstPED[ni][12]

					//Ticket 80379   - Everson - 04/10/2022 - Tratamento para estorno de carga de transbordo.
					If ! Empty(cCrgAgr)

						cQryCrg := " SELECT DISTINCT C5_DTENTR, C5_ROTEIRO, C5_PLACA FROM " + RetSqlName("SC5") + " (NOLOCK) AS SC5 WHERE C5_FILIAL = '" + FWxFilial("SC5") + "' AND C5_XCAGRUP = '" + cCrgAgr + "' AND SC5.D_E_L_E_T_ = '' ORDER BY C5_ROTEIRO "

						cNewAlias := GetNextAlias()
						DbUseArea(.T., "TOPCONN", TCGenQry(,, cQryCrg), cNewAlias, .F., .T.)
						(cNewAlias)->(DbGoTop())

						If (cNewAlias)->(Eof())
							cMens += "- Não foi possível obter os roteiros do Transbordo: [" + cCrgAgr + "]" + CRLF	
							(cNewAlias)->(DbCloseArea())		
							Loop

						EndIf
						
						While ! (cNewAlias)->(Eof())

							Aadd(aRoteiros, { (cNewAlias)->C5_DTENTR, (cNewAlias)->C5_ROTEIRO, (cNewAlias)->C5_PLACA })
				
							(cNewAlias)->(DbSkip())

						End

						(cNewAlias)->(DbCloseArea())

					EndIf

					Begin Transaction //CHAMADO: T.I FERNANDO SIGOLI 10/02/2020  

					If lTransbordo

						If Alltrim(cEmpAnt) == '01'//Adoro 

							If Alltrim(cFilAnt) == "02"

								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"

							ElseIf Alltrim(cFilAnt) <> "02"

								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"
							
							Endif

						ElseIf Alltrim(cEmpAnt) == '02' //Ceres

							cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' +Str(Val(cSeq))+",'0',"+"'"+cEmpAnt+"'"


						ElseIf Alltrim(cEmpAnt) == '13'

							cScriptSql := 'EXEC ['+cLnkSrv+'].[SMARTSCA].[dbo].[FD_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"

						
						Endif

							
					Else

						If Alltrim(cEmpAnt) == '01' //Adoro

							If Alltrim(cFilAnt) == "02"
								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"
							Else
								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"
							EndIf

						ElseIf Alltrim(cEmpAnt) == '02' //Ceres
							
							cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"

						ElseIf Alltrim(cEmpAnt) == '13' //Vista Foods

							cScriptSql := 'EXEC ['+cLnkSrv+'].[SMARTSCA].[dbo].[FD_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"
							

						EndIf
					
					EndIf

					TcSQLExec(cScriptSql)

					cErro := ""
					cErro := U_RetErroED() 

					End Transaction //CHAMADO: T.I FERNANDO SIGOLI 10/02/2020  	

					// ** INICIO VERIFICACAO SE A CARGA FOI DELETADA NO EDATA - WILLIAM COSTA ** //

					cQuery := " SELECT COUNT(*) AS TOTAL"
					cQuery +=   " FROM ["+cLnkSrv+"].["+cLinkBD+"].[dbo].[VW_ERRO_02] " //alterado 26/05/2023 - Sigoli
					cQuery +=  " WHERE ROTEIRO         = " + "'" + ALLTRIM(cRoteiro) + "'"
					cQuery +=    " AND DT_ENTRPEDIVEND = " + "'" + ALLTRIM(cData)    + "'"

					dbUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )             

					While TRB->(!EOF())

						If TRB->TOTAL > 0 //so retorna erro se tiver informacao da carga na tabela do edata

							cErro += "Carga não estorna do EDATA, favor verificar!!! (LIGUE PARA O SUPORTE EDATA) "

						Endif
						TRB->(dbSkip())
					ENDDO
					TRB->(dbCloseArea())	

					// ** FINAL VERIFICACAO SE A CARGA FOI DELETADA NO EDATA - WILLIAM COSTA ** //				

					If Empty(cErro)

						//Ticket 80379   - Everson - 04/10/2022 - Tratamento para estorno de carga de transbordo.
						If Empty(cCrgAgr)
							CCSP_001F(cData, cRoteiro, cPlaca,"2","OK")

						Else

							For nCount := 1 To Len(aRoteiros)
								CCSP_001F(aRoteiros[nCount][1], aRoteiros[nCount][2], aRoteiros[nCount][3],"2","OK")

							Next nCount

						EndIf

					Else

						// Flag pedido	   
						cMens += "- Roteiro não estornado: [" + AllTrim(aLstPED[ni][2]) + "]" + Iif(Empty(cCrgAgr), "", " transbordo: [" + cCrgAgr + "]") + CRLF + "- Erro : [" + cErro + "]"  + CRLF			
						//CCSP_001F (cData,cRoteiro,cPlaca,"4",cErro)							

					Endif
				EndIf	        
			Endif

			u_GrLogZBE(Date(),TIME(),cUserName,"ESTORNO CARGA EDATA","LOGISTICA","CCS_001E",;
			" CHAVE "+AllTrim(Dtos(aLstPED[ni][1]))+" "+AllTrim(aLstPED[ni][2])+" "+AllTrim(aLstPED[ni][3])+" "+AllTrim(aLstPED[ni][4]),ComputerName(),LogUserName()) 

		Next ni

		If !Empty(cMens)
			cMens := "Lista de itens que não foram processados : " + CRLF + cMens
			U_ExTelaMen(cRotDesc,cMens,"Arial",10,,.F.,.T.)
		Endif

		If oTela # Nil
			oTela:SetFocus()
		Endif
		
		UnLockByName("CCS_001E")	
	endif

Return lRet

Static Function fVldEst(cSeqCarg)

	Local lRet := .F.

	cQuery := " SELECT COUNT(*) CONTADOR "
  	cQuery += " FROM ["+ cLnkSrv +"].["+cLinkBD+"].[dbo].[EXPEDICAO_CARGA_PALETE] " //alterado 26/05/2023 - Sigoli
	cQuery += " WHERE [ID_CARGEXPE] = '"+ Alltrim(cSeqCarg) +"'; "

	TCQUERY cQuery ALIAS "TRB" NEW

	While TRB->(!EOF())

		If TRB->CONTADOR > 0
			lRet := .T.
		EndIf
		TRB->(dbSkip())
	ENDDO

	TRB->(dbCloseArea())	
	
return lRet

Static Function fVldLei(cSeqCarg)
	Local lRet := .F.

	cQuery := " SELECT COUNT(*) CONTADOR "
  	cQuery += " FROM ["+ cLnkSrv +"].["+cLinkBD+"].[dbo].[EXPEDICAO_CARGA_LEIT_OBSE] " //alterado 26/05/2023 - Sigoli
	cQuery += " WHERE [ID_CARGEXPE] = '"+ Alltrim(cSeqCarg) +"'; "

	TCQUERY cQuery ALIAS "TRB" NEW

	While TRB->(!EOF())

		If TRB->CONTADOR > 0
			lRet := .T.
		EndIf
		TRB->(dbSkip())
	ENDDO

	TRB->(dbCloseArea())	
	
return lRet

Static Function fVldlPe(cSeqCarg)
	Local lRet := .F.

	cQuery := " SELECT COUNT(*) CONTADOR "
  	cQuery += " FROM ["+ cLnkSrv +"].["+cLinkBD+"].[dbo].[PEDIDO_VENDA_LEIT_OBSE_EXPE] " //alterado 26/05/2023 - Sigoli
	cQuery += " WHERE [ID_CARGEXPE] = '"+ Alltrim(cSeqCarg) +"'; "

	TCQUERY cQuery ALIAS "TRB" NEW

	While TRB->(!EOF())

		If TRB->CONTADOR > 0
			lRet := .T.
		EndIf
		TRB->(dbSkip())
	ENDDO

	TRB->(dbCloseArea())	
	
return lRet

/*/{Protheus.doc} User Function CCS_001T 
	Troca de Placa
	@type  Function
	@author Pablo Gollan Carreras
	@since 14/06/2012
	
/*/

Static Function CCS_001T(oTela)

	Local lRet				:= .T.
	Local aArea				:= {}
	Local ni				:= 0
	Local cChave			:= ""
	Local cMens				:= ""
	Local cRest01			:= ""
	Local cQuery            := ""
	//ticket 69334   - Abel Babini          - 05/09/2022 - Ajustes no fonte para Filial Itapira
	Local cFilSF:= GetMv("MV_#SFFIL",,"02|0B|") 	//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	Local cEmpSF:= GetMv("MV_#SFEMP",,"01|") 		//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI

	//Everson - 08/11/2022 - ticket 80379.
	Local cScriptSql		:= ""
	Local cCrgAgr			:= ""
	// 

	If Empty(aLstPED) .OR. ValType(aLstPED) # "A"
		Return !lRet
	Endif

	cData	  := ""
	cRoteiro := ""
	cPlaca	  := ""
	_NewPlaca:= ""

	For ni := 1 to Len(aLstPED)                   

		If (aLstPED[ni][8] $ "3" .AND. aLstPED[ni][11] $ "1" .And. Empty(AllTrim(aLstPED[ni][12]))) //Everson - 08/11/2022 - ticket 80379.


			If cData+cRoteiro+cPlaca <> AllTrim(Dtos(aLstPED[ni][1]))+AllTrim(aLstPED[ni][2])+AllTrim(aLstPED[ni][3])

				//Pega a placa substituta           
				
				_NewPlaca:= U_PLACASUB(AllTrim(Dtos(aLstPED[ni][1])),AllTrim(aLstPED[ni][2]),AllTrim(aLstPED[ni][3]))
				If Empty(_NewPlaca)
					U_ExTelaMen("Troca de Placa","Processo cancelado","Arial",12,,.F.,.T.)
					Return !lRet
				EndIf

				//Salva Roteiro em processamento
				cData	 := AllTrim(Dtos(aLstPED[ni][1]))
				cRoteiro := AllTrim(aLstPED[ni][2])
				cPlaca	 := AllTrim(aLstPED[ni][3])
				cSeq	 := AllTrim(aLstPED[ni][7])

				Begin Transaction //CHAMADO: T.I FERNANDO SIGOLI 10/02/2020  

					//Everson - 08/11/2022 - ticket 80379.
					cScriptSql := ""
					If lTransbordo

						If Alltrim(cEmpAnt) == '01' //Adoro

							If Alltrim(cFilAnt) == "02"

								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"

							ElseIf Alltrim(cFilAnt) <> "02"

								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"

							EndIf

						ElseIf Alltrim(cEmpAnt) == '02' //Ceres
							
							cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' +Str(Val(cSeq))+",'0',"+"'"+cEmpAnt+"'"

						ElseIf Alltrim(cEmpAnt) == '13' //Vista Foods

							cScriptSql := 'EXEC ['+cLnkSrv+'].[SMARTSCA].[dbo].[FD_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"


						EndIf 

					Else

						If Alltrim(cEmpAnt) == '01' //Adoro
						
							If Alltrim(cFilAnt) == "02"
								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"

							Else 
								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"

							EndIf

						ElseIf Alltrim(cEmpAnt) == '02' //Ceres
					
							cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FD_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"

						ElseIf Alltrim(cEmpAnt) == '13' //Vista Foods

							cScriptSql := 'EXEC ['+cLnkSrv+'].[SMARTSCA].[dbo].[FD_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"


						EndIf

					EndIf
				
					TcSQLExec(cScriptSql)

					cErro := ""
					cErro := U_RetErroED()

				End Transaction //CHAMADO: T.I FERNANDO SIGOLI 10/02/2020  

				// ** INICIO VERIFICACAO SE A CARGA FOI DELETADA NO EDATA - WILLIAM COSTA ** //

				cQuery := " SELECT COUNT(*) AS TOTAL"
				cQuery +=   " FROM ["+cLnkSrv+"].["+cLinkBD+"].[dbo].[VW_ERRO_02] " //alterado 26/05/2023 - Sigoli
				cQuery +=  " WHERE ROTEIRO         = " + "'" + ALLTRIM(cRoteiro) + "'"
				cQuery +=    " AND DT_ENTRPEDIVEND = " + "'" + ALLTRIM(cData)    + "'"

				dbUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )             

				While TRB->(!EOF())

					If TRB->TOTAL > 0 //so retorna erro se tiver informacao da carga na tabela do edata

						cErro := "Carga não estorna do EDATA, favor verificar!!! (LIGUE PARA O SUPORTE EDATA) "

					Endif
					TRB->(dbSkip())
				ENDDO
				TRB->(dbCloseArea())	

				// ** FINAL VERIFICACAO SE A CARGA FOI DELETADA NO EDATA - WILLIAM COSTA ** //

				If Empty(cErro)
					// Flag pedido	   
					CCSP_001F(cData,cRoteiro,cPlaca,"2","OK")

					//Cria nova sequencia edata - verificar
					aRet := CCSP_001S(cData,cRoteiro,cPlaca,_NewPlaca)
					If 	aRet[1]
						cSeq := aRet[2]
					Else
						cMens += "- Roteiro não processado, erro no sequenciamento do edata: [" + AllTrim(aLstPED[ni][2]) + "]" + CRLF			
						loop
					EndIf

					Begin Transaction //CHAMADO: T.I FERNANDO SIGOLI 10/02/2020  

						//Everson - 08/11/2022 - ticket 80379.
						cScriptSql := ""

						If lTransbordo

							If Alltrim(cEmpAnt) == '01' //Adoro

								If Alltrim(cFilAnt) == "02"

									cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"

								ElseIf Alltrim(cFilAnt) <> "02"

									cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"
								
								EndIf

							ElseIf Alltrim(cEmpAnt) == '02' //Ceres
								
								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' +Str(Val(cSeq))+",'0',"+"'"+cEmpAnt+"'"

							ElseIf Alltrim(cEmpAnt) == '13' //Vista Foods

								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMARTSCA].[dbo].[FI_EXPECARG_01] ' + "'" + Iif(!Empty(cCrgAgr), "0", Str(Val(cSeq))) + "'," + Iif(!Empty(cCrgAgr), Str(Val(cCrgAgr)), "0") +","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"

							Endif 
						
						Else

							If Alltrim(cEmpAnt) == '01'
							
								If Alltrim(cFilAnt) == "02"
									cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"

								Else 
									cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"

								EndIf 

							ElseIf Alltrim(cEmpAnt) == '02' //Ceres

								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMART].[dbo].[FI_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"
							
							ElseIf Alltrim(cEmpAnt) == '13' //Vista Foods

								cScriptSql := 'EXEC ['+cLnkSrv+'].[SMARTSCA].[dbo].[FI_EXPECARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"'"+","+"'"+cFilAnt+"'"
	
							EndIf


						EndIf
						//

						TcSQLExec(cScriptSql)

						cErro := ""
						cErro := U_RetErroED()

					End Transaction //CHAMADO: T.I FERNANDO SIGOLI 10/02/2020   

					// ** INICIO VERIFICACAO SE A CARGA FOI DELETADA NO EDATA - WILLIAM COSTA ** //

					cQuery := " SELECT COUNT(*) AS TOTAL"
					cQuery +=   " FROM ["+cLnkSrv+"].["+cLinkBD+"].[dbo].[VW_ERRO_02] " //alterado 26/05/2023 - Sigoli
					cQuery +=  " WHERE ROTEIRO         = " + "'" + ALLTRIM(cRoteiro) + "'"
					cQuery +=    " AND DT_ENTRPEDIVEND = " + "'" + ALLTRIM(cData)    + "'"

					dbUseArea( .T., "TOPCONN", TCGenQry( ,, cQuery ), "TRB", .F., .T. )             

					While TRB->(!EOF())

						If TRB->TOTAL > 0 //so retorna erro se tiver informacao da carga na tabela do edata

							cErro := "Carga não enviada para o EDATA, j?existe a carga no Edata, favor estornar antes de enviar novamente, favor verificar!!! "

						Endif
						TRB->(dbSkip())
					ENDDO
					TRB->(dbCloseArea())	

					// ** FINAL VERIFICACAO SE A CARGA FOI DELETADA NO EDATA - WILLIAM COSTA ** //

					If Empty(cErro)
						// Flag pedido	   
						CCSP_001F (cData,cRoteiro,cPlaca,"3","OK")
					Else

						// Flag pedido	   
						cMens += "- Roteiro de troca de placa não processado: [" + AllTrim(aLstPED[ni][2]) + "]" + CRLF + "- Erro : [" + cErro + "]"  + CRLF			
						CCSP_001F (cData,cRoteiro,cPlaca,"4",cErro)							
					Endif								
				Else

					// Flag pedido	   
					cMens += "- Roteiro de troca de placa não estornado: [" + AllTrim(aLstPED[ni][2]) + "]" + CRLF + "- Erro : [" + cErro + "]"  + CRLF			
				Endif
			EndIf

			u_GrLogZBE(Date(),TIME(),cUserName,"TROCA DE PLACA - EDATA","LOGISTICA","CCS_001T",;
			" CHAVE "+AllTrim(Dtos(aLstPED[ni][1]))+" "+AllTrim(aLstPED[ni][2])+" "+AllTrim(aLstPED[ni][3])+" "+AllTrim(aLstPED[ni][4]),ComputerName(),LogUserName()) 
			
			//Everson - 02/04/2018. Chamado 037261.
			//If FindFunction("U_ADVEN050P") .And. cEmpAnt == "01" .And. cFilAnt == "02" //ticket 69334   - Abel Babini          - 05/09/2022 - Ajustes no fonte para Filial Itapira
			If FindFunction("U_ADVEN050P") .And. Alltrim(cEmpAnt) $ cEmpSF .And. Alltrim(cFilAnt) $ cFilSF
				If Upper(Alltrim(cValToChar(GetMv("MV_#SFATUL")))) == "S"
					U_ADVEN050P("",,," AND C5_ROTEIRO = '" + Alltrim(cValToChar(aLstPED[ni][2])) + "' AND C5_DTENTR = '" + Alltrim(DToS(aLstPED[ni][1])) + "' AND C5_XPEDSAL <> '' ",,,,,,.T.)
				
				EndIf
			EndIf

		Else
			cMens += "- Opção disponível apenas para roteiros integrados do tipo Fat.Antecipado e não transbordo: [" + AllTrim(aLstPED[ni][2]) + "]" + CRLF //Everson - 08/11/2022 - ticket 80379.   
		Endif

	Next ni

	If !Empty(cMens)
		cMens := "Lista de itens que não foram processados : " + CRLF + cMens
		U_ExTelaMen(cRotDesc,cMens,"Arial",10,,.F.,.T.)
	Endif

	If oTela # Nil
		oTela:SetFocus()
	Endif

Return lRet

/*/{Protheus.doc} User Function PFATA2VlP
	Rotina para validacao do SX1 da rotina
	@type  Function
	@author Pablo Gollan Carreras
	@since 14/06/2012
	
/*/

Static Function PFATA2VlP(cPerg,aPergunte)

	Local lRet				:= .T.
	Local ni				:= 0

	//Gravar variaveis no grupo de perguntas do SX1
	__SaveParam(cPerg,@aPergunte)	
	//Reinicializar as perguntas
	ResetMVRange()
	For ni := 1 to Len(aPergunte)
		//Inicializar as perguntas c/ array caso existam diferencas, para as validacoes
		Do Case
			Case AllTrim(aPergunte[ni][POS_X1OBJ]) == "C"
			aPergunte[ni][POS_X1VAL] := &(aPergunte[ni][POS_X1VAR])
			Otherwise
			&(aPergunte[ni][POS_X1VAR]) := aPergunte[ni][POS_X1VAL]
		EndCase
		//Definir a variavel corrente como sendo o parametro a validar, para aquelas validacoes que utilizar a variavel de campo posicionado
		__ReadVar := aPergunte[ni][POS_X1VAR]
		//Executar validacao
		If !Eval(&("{|| " + aPergunte[ni][POS_X1VLD] + "}"))
			MsgAlert(cNomeUs + ", inconsistência na pergunta " + StrZero(ni,2) + " (" + StrTran(AllTrim(Capital(aPergunte[ni][POS_X1DES])),"?","") + ")")
			Return !lRet
		Endif
	Next ni                               

Return lRet

/*/{Protheus.doc} User Function PFAT2Val
	Rotina que atribui dinamicamente a validacao de cada pergunta
	@type  Function
	@author Pablo Gollan Carreras
	@since 14/06/2012
	
/*/

User Function CCSPVal()

	Local lRet				:= .T.
	Local cVarAt			:= Upper(AllTrim(ReadVar()))
	Local nPos				:= 0
	Local aLstVld			:= {	{1,{|| Vazio() }},;
	{3,{|| Empty(StrTran(Upper(&(cVarAt)),"Z","")) }},;
	{5,{|| NaoVazio()}},;
	{6,{|| NaoVazio()}},;
	{7,{|| cValToChar(&(cVarAt)) $ "12345"}}}
	Local bConvNum			:= {|x| x := GetDToVal(x)}

	U_ADINF009P('CCSP_001' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Integracao Protheus x Edata')

	If "MV_PAR" $ cVarAt
		If !Empty(nPos := aScan(aLstVld,{|x| x[1] == Eval(bConvNum,Right(cVarAt,2))}))
			lRet := Eval(aTail(aLstVld[nPos]))
		Endif
	Endif

Return lRet

/*/{Protheus.doc} User Function CCSP_001F
	Rotina que atribui dinamicamente a validacao de cada pergunta
	@type  Function
	@author Pablo Gollan Carreras
	@since 11/19/13
	
/*/

Static Function CCSP_001F (cData,cRoteiro,cPlaca,cFlag,cObs)

	DbSelectArea("SC5")
	DBORDERNICKNAME("SC5_9")
	DbSeek(xFilial("SC5")+cData+cRoteiro+cPlaca)
	WHile !EOF() .and. xFilial("SC5") + cData+cRoteiro+cPlaca == SC5->C5_FILIAL+DTOS(SC5->C5_DTENTR)+SC5->C5_ROTEIRO+SC5->C5_PLACA

		_lLib:=.T.
		
		//Mauricio 08/01/16 - Novo tratamento para liberacao a integração.
		SC6->(dbSetOrder(1)) // Indice ( pedido )
		SC6->(dbSeek(SC5->(C5_FILIAL+C5_NUM)))
		While !SC6->(Eof()) .and. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)

			SC9->(dbSetOrder(1)) // Indice ( pedido )
			If SC9->(dbSeek( SC6->(C6_FILIAL+C6_NUM+C6_ITEM)))
				If SC6->C6_PRODUTO == SC9->C9_PRODUTO	//confiro se o produto eh o mesmo.
					If !Empty(SC9->C9_BLEST ) .OR. !Empty(SC9->C9_BLCRED) 
						//!Empty(SC9->C9_BLEST ) .AND. !Empty(SC9->C9_BLCRED) -- alterado para OR para considerar quaisquer bloqueio chamado 032206 por Adriana em 03/01/2017
						_lLib := .F.
						cErro += "Ola " + cNomeUs + ", Existe Produto nesse Pedido que não está liberado credito ou Estoque Verifique com o Financeiro, Pedido: " + SC5->C5_NUM + CHR(13) + CHR(10)

					Endif
				Else
					_lLib := .F.
					cErro += "Ola " + cNomeUs + ", Existe Produto nesse Pedido que não está liberado credito ou Estoque Verifique com o Financeiro, Pedido: " + SC5->C5_NUM + CHR(13) + CHR(10)

				Endif
			Else
				_lLib := .F.
				cErro += "Ola " + cNomeUs + ", Existe Produto nesse Pedido que não está liberado credito ou Estoque Verifique com o Financeiro, Pedido: " + SC5->C5_NUM + CHR(13) + CHR(10)
			Endif
			SC6->(dbSkip())
		EndDo

		If _lLib

			If RecLock("SC5",.F.)

				SC5->C5_XOBS	:= cObs
				SC5->C5_XINT	:= cFlag 
				SC5->C5_XERRO   := SC5->C5_XERRO+"// "+cFlag+" - "+DTOC(Ddatabase)+" "+Time()+" por "+Alltrim(cusername)+" // "+cObs //incluido por Adriana em 23/04/15 para gravar log completo

				//If IsInCallStack("CCS_001E") // @history ticket 9122    - Fernando Maciei - 09/02/2021 - melhoria no envio Carga EDATA
				If IsInCallStack("CCS_001E") .or. AllTrim(cFlag) == "4" // @history ticket 9122    - Fernando Maciei - 09/02/2021 - melhoria no envio Carga EDATA
					SC5->C5_X_SQED	:= ""
				EndIf

				If SC5->C5_XFATANT=="1"

					If IsInCallStack("CCS_001P") .and. cFlag=="3"
						SC5->C5_XFLAGE	:= "2"                   
					ElseIf IsInCallStack("CCS_001P")
						SC5->C5_XFLAGE	:= "1"                   			
					EndIf                                               

				EndIf

				SC5->(MsUnlock()) 
			else
				MsgAlert("Não foi possível alterar o PV "+SC5->C5_NUM+".", "Problema na gravação do PV")
			EndIf
		EndIf	 

		DbSelectArea("SC5")
		DbSkip()
	EndDo                    

	//GRAVA LOG
	If cFlag $ "2|3"
		RecLock("ZZ6",.T.)
		ZZ6->ZZ6_FILIAL := XFILIAL("ZZ6")
		ZZ6->ZZ6_CHAVE  := cData+cRoteiro+cPlaca
		ZZ6->ZZ6_DATA 	:= DDATABASE
		ZZ6->ZZ6_HORA 	:= TIME()
		ZZ6->ZZ6_USER 	:= cUserName
		ZZ6->ZZ6_OPER 	:= cFlag
		ZZ6->ZZ6_OBS 	:= cObs
		ZZ6->(MsUnlock())	 
	EndIf

Return

/*/{Protheus.doc} User Function CCSP_001S
	@type  Function
	@author Pablo Gollan Carreras
	@since 11/19/13
	
/*/

Static Function CCSP_001S(cData,cRoteiro,cPlaca,cNewPlaca)

	Local lRet:=.F.
	Default cNewPlaca:=""

	Begin Transaction//CHAMADO: T.I FERNANDO SIGOLI 10/02/2020  

		_cSQED:= U_NextNum("SC5","C5_X_SQED",.F.)

		DbSelectArea("SC5")
		DBORDERNICKNAME("SC5_9")
		If DbSeek(xFilial("SC5")+cData+cRoteiro+cPlaca)
			While !EOF() .and. xFilial("SC5")+cData+cRoteiro+cPlaca == SC5->C5_FILIAL+DTOS(SC5->C5_DTENTR)+SC5->C5_ROTEIRO+SC5->C5_PLACA

				_lLib:=.T.
				
				//Mauricio 08/01/16 - Novo tratamento para liberacao a integração.
				SC6->(dbSetOrder(1)) // Indice ( pedido )
				SC6->(dbSeek(SC5->(C5_FILIAL+C5_NUM)))
				While !SC6->(Eof()) .and. SC6->(C6_FILIAL+C6_NUM) == SC5->(C5_FILIAL+C5_NUM)

					SC9->(dbSetOrder(1)) // Indice ( pedido )
					If SC9->(dbSeek( SC6->(C6_FILIAL+C6_NUM+C6_ITEM)))
						If SC6->C6_PRODUTO == SC9->C9_PRODUTO	//confiro se o produto eh o mesmo.
							If !Empty(SC9->C9_BLEST ) .OR. !Empty(SC9->C9_BLCRED) 
								//!Empty(SC9->C9_BLEST ) .AND. !Empty(SC9->C9_BLCRED) -- alterado para OR para considerar quaisquer bloqueio chamado 032206 por Adriana em 03/01/2017
								_lLib := .F.
								cErro += "Ola " + cNomeUs + ", Existe Produto nesse Pedido que não está liberado credito ou Estoque Verifique com o Financeiro, Pedido: " + SC5->C5_NUM + CHR(13) + CHR(10)
							Endif
						Else
							_lLib := .F.
							cErro += "Ola " + cNomeUs + ", Existe Produto nesse Pedido que não está liberado credito ou Estoque Verifique com o Financeiro, Pedido: " + SC5->C5_NUM + CHR(13) + CHR(10)
						Endif
					Else
						_lLib := .F.
						cErro += "Ola " + cNomeUs + ", Existe Produto nesse Pedido que não está liberado credito ou Estoque Verifique com o Financeiro, Pedido: " + SC5->C5_NUM + CHR(13) + CHR(10)
					Endif
					SC6->(dbSkip())
				EndDo	

				If _lLib
					RecLock("SC5",.F.)
					SC5->C5_X_SQED	:= _cSQED
					SC5->C5_X_DATA	:= DDATABASE
					SC5->C5_XPLACAS	:= cNewPlaca
					SC5->(MsUnlock())			 
					lRet:=.T.
				EndIf

				DbSelectArea("SC5")			
				DbSkip()
			EndDo
		EndIf

	End Transaction //CHAMADO: T.I FERNANDO SIGOLI 10/02/2020  

Return {lRet,_cSQED}       

/*/{Protheus.doc} User Function CCSP_001
	@type  Function
	@author Pablo Gollan Carreras
	@since 12/02/13
	
/*/

Static Function CCS_001L(oTela)

	Local lRet	:=.T.
	Local cMens :=""
	Local cMens1:=""  
	Local ni

	If Empty(aLstPED) .OR. ValType(aLstPED) # "A"
		Return !lRet
	Endif

	//Montar a lista de contabilizacao  
	
	cData	 := ""
	cRoteiro := ""
	cPlaca	 := ""

	For ni := 1 to Len(aLstPED)                   

		If (aLstPED[ni][8] $ "1| " )
			cMens += "- Roteiro sem Log [" + AllTrim(aLstPED[ni][2]) + "]" + CRLF
		Else

			If cData+cRoteiro+cPlaca <> AllTrim(Dtos(aLstPED[ni][1]))+AllTrim(aLstPED[ni][2])+AllTrim(aLstPED[ni][3])

				//Salva Roteiro em processamento
				cData	 := AllTrim(Dtos(aLstPED[ni][1]))
				cRoteiro := AllTrim(aLstPED[ni][2])
				cPlaca	 := AllTrim(aLstPED[ni][3])

				ZZ6->(dbSetOrder(1)) // Indice ( pedido )
				If ZZ6->(dbSeek(xFilial("ZZ6")+cData+cRoteiro+cPlaca))
					While !ZZ6->(Eof()) .and. Alltrim(ZZ6->(ZZ6_FILIAL+ZZ6_CHAVE)) == Alltrim(xFilial("ZZ6")+cData+cRoteiro+cPlaca)

						cMens  := "Chave	 : " + ZZ6->ZZ6_CHAVE + CRLF
						cMens  += "Data 	 : " + DTOC(ZZ6->ZZ6_DATA) + CRLF
						cMens  += "Hora 	 : " + ZZ6->ZZ6_HORA + CRLF
						cMens  += "Usuário   : " + ZZ6->ZZ6_USER + CRLF
						cMens  += "Operação  : " + IIF(ZZ6->ZZ6_OPER == "2","Estorno","Envio") + CRLF + CRLF

						cMens1 := cMens1 + cMens + CRLF

						ZZ6->(dbSkip())
					EndDo
				EndIf	
			EndIf	        
		Endif

	Next ni

	If !Empty(cMens1)
		U_ExTelaMen(cRotDesc,cMens1,"Arial",10,,.F.,.T.)
	Endif

	If oTela # Nil
		oTela:SetFocus()
	Endif


Return lRet 

Static Function AjustaSX1(cPerg)

	Local aMensHlp			:= Array(nQtdePerg)
	Local cRotVld			:= ""
	Local aOpc				:= Array(2,5)
	Local ni				:= 0

	For ni := 1 to Len(aOpc)
		aFill(aOpc[ni],"")
	Next ni

	aOpc[2][1] := "Pendente"
	aOpc[2][2] := "Estornado"
	aOpc[2][3] := "Integrado"
	aOpc[2][4] := "Erro"
	aOpc[2][5] := "Todos"

	//				PERGUNTA					TIPO	TAM							DEC	OBJETO	PS	COMBO		SXG		F3		VALID				HELP
	aMensHlp[01] := {"Roteiro de?"				,"C"	,TamSX3("C5_ROTEIRO")[1]	,00	,"G"	,0	,aOpc[1]	,"001"	,""		,cRotVld	,"Informe o ROTEIRO inicial do intervalo"}
	aMensHlp[02] := {"Roteiro ate?"				,"C"	,TamSX3("C5_ROTEIRO")[1]	,00	,"G"	,0	,aOpc[1]	,"002"	,""		,cRotVld	,"Informe o ROTEIRO final do intervalo"}
	aMensHlp[03] := {"Placa de ?"				,"C"	,TamSX3("C5_PLACA")[1]		,00	,"G"	,0	,aOpc[1]	,"001"	,""		,cRotVld	,"Informe a PLACA inicial do intervalo"}
	aMensHlp[04] := {"Placa ate?"				,"C"	,TamSX3("C5_PLACA")[1]		,00	,"G"	,0	,aOpc[1]	,"002"	,""		,cRotVld	,"Informe a PLACA final do intervalo"}
	aMensHlp[05] := {"Entrega de?"				,"D"	,008						,00	,"G"	,0	,aOpc[1]	,""		,""		,cRotVld	,"Informe a data inicial de entrega."}
	aMensHlp[06] := {"Entrega ate?"				,"D"	,008						,00	,"G"	,0	,aOpc[1]	,""		,""		,cRotVld	,"Informe a data final de entrega."}
	aMensHlp[07] := {"Status?"					,"N"	,001						,00	,"C"	,1	,aOpc[2]	,""		,""		,cRotVld	,"Informe as opções para o filtro"}
	
	//Everson - 26/09/2022. Ticket 8037
	aMensHlp[08] := {"Transbordo de"			,"C"	,TamSX3("C5_XCAGRUP")[1]	,00	,"G"	,0	,aOpc[1]	,""		,""		,cRotVld	,"Informe o TRANSBORDO do intervalo"}
	aMensHlp[09] := {"Transbordo ate"			,"C"	,TamSX3("C5_XCAGRUP")[1]	,00	,"G"	,0	,aOpc[1]	,""		,""		,cRotVld	,"Informe o TRANSBORDO do intervalo"}
	aMensHlp[10] := {"Placa Transb de"			,"C"	,TamSX3("C5_XPAGRUP")[1]	,00	,"G"	,0	,aOpc[1]	,""		,""		,cRotVld	,"Informe a PLACA do TRANSBORDO"}
	aMensHlp[11] := {"Placa Transb ate"			,"C"	,TamSX3("C5_XPAGRUP")[1]	,00	,"G"	,0	,aOpc[1]	,""		,""		,cRotVld	,"Informe a PLACA do TRANSBORDO"}

	//U_GravaSX1(cPerg,aMensHlp)

Return Nil


//Mauricio - 26/05/2017 - chamado 35017 - Roteiro Pedido "diversos"  
Static Function fchkped(_cNrPd,_cCli,c_Fil)
	
	If Select("TDIV") > 0
		dbSelectArea("TDIV")
		DbCLoseArea("TDIV")
	EndIf 

	//Select para  trazer apenas pedidos diversos da lista
	_cQuery := "SELECT C5_NUM, C5_DTENTR, C5_ROTEIRO FROM "+RetSqlName("SC5")+" C5 WITH(NOLOCK), "+RetSqlName("SC6")+" C6 WITH(NOLOCK), "+RetSqlName("SF4")+" F4 WITH(NOLOCK) "
	_cQuery += "WHERE C5.C5_NUM = '"+_cNrPd+"' AND C5.C5_NUM = C6.C6_NUM AND " 
	_cQuery += "      C5.C5_CLIENTE = '"+_cCli+"' AND C5.C5_FILIAL = '"+c_Fil+"' AND "
	_cQuery += "      C6.C6_TES = F4.F4_CODIGO AND F4.F4_XTIPO = '2' AND "
	_cQuery += "      C5.C5_FILIAL = C6.C6_FILIAL AND "
	_cQuery += "      C6.D_E_L_E_T_ <> '*' AND F4.D_E_L_E_T_ <> '*' AND C5.D_E_L_E_T_ <> '*' "
	_cQuery += "      GROUP BY C5.C5_DTENTR, C5.C5_ROTEIRO, C5.C5_NUM "
	//_cQuery += "ORDER BY C5.C5_NUM,C5.C5_ROTEIRO"
	_cQuery += "ORDER BY C5.C5_DTENTR, C5.C5_ROTEIRO, C5.C5_NUM "

	TCQUERY _cQuery NEW ALIAS "TDIV"

	dbSelectArea("TDIV")
	dbGoTop()

	While TDIV->(!Eof())
		AADD(_aPedDiv,{TDIV->C5_DTENTR,TDIV->C5_ROTEIRO,TDIV->C5_NUM})     
		TDIV->(DbSkip())
	Enddo

	DbCloseArea("TDIV")

Return()

STATIC FUNCTION SqlVerifRoteiro(cDtEntr,cRoteiro)

	BeginSQL Alias "TDIX"
		%NoPARSER% 

		SELECT COUNT(*) AS CONT_PED,
		CASE WHEN C5_XTIPO = '1' THEN COUNT(*) ELSE 0 END AS CONT_NORMAL,
		CASE WHEN C5_XTIPO = '2' THEN COUNT(*) ELSE 0 END AS CONT_DIVERSOS    //Chamado: T.I - Fernando Sigoli - 01/07/2019
		FROM %Table:SC5%  WITH(NOLOCK)
		WHERE C5_FILIAL = %EXP:cFilia%		 //Chamado: 048868 - 02/05/2019 - FERNANDO SIGOLI
		AND C5_DTENTR   = %EXP:cDtEntr%     
		AND C5_ROTEIRO  = %EXP:cRoteiro%
		AND D_E_L_E_T_ <> '*'
		AND C5_NOTA     = ""                //Chamado: T.I - Fernando Sigoli - 01/07/2019
		GROUP BY C5_ROTEIRO,C5_DTENTR,C5_XTIPO

	EndSQl   

RETURN(NIL)

STATIC FUNCTION SqlVerifDiversos(cDtEntr,cRoteiro)

	BeginSQL Alias "TDIZ"
		%NoPARSER% 

		SELECT C5_NUM,C5_XTIPO
		FROM %Table:SC5%  WITH(NOLOCK)
		WHERE C5_FILIAL = %EXP:cFilia% //Chamado: 048868 - 02/05/2019 - FERNANDO SIGOLI
		AND C5_DTENTR   = %EXP:cDtEntr% 
		AND C5_ROTEIRO  = %EXP:cRoteiro% 
		AND C5_XTIPO    = '2'
		AND C5_NOTA     = ""           //Chamado: T.I - Fernando Sigoli - 01/07/2019
		AND D_E_L_E_T_ <> '*'

	EndSQl   

RETURN(NIL)

STATIC FUNCTION SqlVerifProdutos(cDtEntr,cRoteiro)
	Local cQuery := ""
	//BeginSQL Alias "TDJA"
	//	%NoPARSER% 
		
	cQuery := " SELECT C6_NUM,C6_PRODUTO,IE_MATEEMBA "
	cQuery += " FROM "+ retsqlname("SC6") +" SC6  WITH(NOLOCK) "
	cQuery += " 	LEFT JOIN ["+cLnkSrv+"].["+cLinkBD+"].[dbo].[VW_MATERIAL_EMBALAGEM] ON IE_MATEEMBA    = (C6_PRODUTO COLLATE Latin1_General_CI_AS) " //alterado 26/05/2023 - Sigoli
	//Chamado: 051387 - Fernando Sigoli - 29/08/2019  
	cQuery += " 	INNER JOIN "+ retsqlname("SC5") +" SC5 WITH(NOLOCK) ON SC5.C5_FILIAL = SC6.C6_FILIAL AND SC5.C5_NUM = SC6.C6_NUM AND SC5.C5_CLIENTE = SC6.C6_CLI AND SC5.C5_LOJACLI = SC6.C6_LOJA "
	cQuery += " 	WHERE  "
	cQuery += " 	  C6_FILIAL  = '"+cFilia +"' " //Chamado: 048868 - 02/05/2019 - FERNANDO SIGOLI
	cQuery += " 	  AND C6_ENTREG   = '"+cDtEntr+"' "  
	cQuery += " 	  AND C5_ROTEIRO  = '"+cRoteiro+"' "
	cQuery += " 	  AND C6_NOTA     =  '' "
	cQuery += " 	  AND SC6.D_E_L_E_T_ <> '*' "
	cQuery += " 	  AND SC5.D_E_L_E_T_ <> '*' "
		  
	Tcquery cQuery ALIAS "TDJA" NEW	  
	//EndSQl   

RETURN(NIL)
