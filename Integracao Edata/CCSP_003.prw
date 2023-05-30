#Include "Protheus.ch"
#Include "ParmType.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"

/*/{Protheus.doc} User Function CCSP_003 
	Integracao Protheus x Edata - Pedido de Devolu็ใo 
	@type  Function
	@author Microsiga
	@since 02/05/10
	@version version
	@version 01
	@history  28/01/2019 - Fernando Sigoli Chamado: 046731 - Tratamento na query para trazer nota fiscal de entrada de Quebra - D1_LOCAL <> '11' 
	@history  12/02/2019 - Fernando Sigoli Chamado: 047155 - Enviar carga para edata apenas notas fiscais com volume fisico, excluimos nf de quebra
	@history  08/10/2021 - Fernando Sigoli Ticket : 61334  - Comentado Begin Tran nao faz sentido essa rotina, desarmar.
	@history chamado  62436 - Everson      - 14/10/2021 - Tratamento para verifica็ใo de conexใo com Edata.
	@history chamado  TI - Leonardo P. Monteiro - 17/10/2021 - Tratamento de error.log na chamada da fun็ใo CCSP_002.
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history chamado  72284 - Everson - 03/05/2022 - Tratamento para quando o registro nใo ้ flagado do lado do Protheus.
	@history Everson, 29/06/2022, ticket 75370 - tratamento para nใo carregar nota classificada.
	@history Ticket 69334  - Abel Babini - 05/09/2022 - Altera็ใo
	@history Ticket 84573  - Everson - 20/12/2022 - Tratamento para agrupar mesma placa substituta atribuํda em diversas NF de devolu็ใo em uma ๚nica carga de devolu็ใo.
	@history Ticket 84573  - Everson - 23/12/2022 - Tratamento para agrupar mesma placa substituta atribuํda em diversas NF de devolu็ใo em uma ๚nica carga de devolu็ใo para devolu็ใo normal.
/*/

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

Static nQtdePerg		:= 4
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
Static cLinkSe  		:= Alltrim(SuperGetMV("MV_#UEPSRV",,"LNKMIMS"))

User Function CCSP_003() // U_CCSP_003()

	//Variแveis.
	Local oDlg     

	Private cPerg	  :="CCSP03" 
	Private cCadastro :="Integracao Protheus x Edata - Pedido de Devolu็ใo"

	U_ADINF009P(SUBSTRING(Alltrim(PROCNAME()),3,LEN(Alltrim(PROCNAME()))) + '.PRW',SUBSTRING(Alltrim(PROCNAME()),3,LEN(Alltrim(PROCNAME()))),'Integracao Protheus x Edata - Pedido de Devolu็ใo ')

	chkEdtLk() //Everson - 14/10/2021. Chamado 62436.     

	Pergunte(cPerg,.T.)
		
	ProcLogIni( {},"CCSP03")
	
	DEFINE MSDIALOG oDlg FROM  96,9 TO 320,612 TITLE OemToAnsi(cCadastro) PIXEL

		@ 11,6 TO 90,287 LABEL "" OF oDlg  PIXEL
		@ 16, 15 SAY OemToAnsi("Este programa efetua a integracao com o EDATA - Pedido de Devolu็ใo") SIZE 268, 8 OF oDlg PIXEL			   									
				
		DEFINE SBUTTON FROM 93, 163 TYPE 15 ACTION ProcLogView() ENABLE OF oDlg
		DEFINE SBUTTON FROM 93, 193 TYPE 5  ACTION Pergunte(cPerg,.T.) ENABLE OF oDlg
		DEFINE SBUTTON FROM 93, 223 TYPE 1  ACTION If(.T.,(Processa({|lEnd| E001Proces()},OemToAnsi("Integracao Protheus x Edata"),OemToAnsi("Selecionando Registros..."),.F.),oDlg:End()),) ENABLE OF oDlg
		DEFINE SBUTTON FROM 93, 253 TYPE 2  ACTION oDlg:End() ENABLE OF oDlg
		
	ACTIVATE MSDIALOG oDlg CENTERED    
	
Return Nil  
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณE001ProcesบAutor  ณMicrosiga           บ Data ณ  02/05/10   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                         บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function E001Proces()

	//Variแveis.
	Local aArea			:= SaveArea1({"SF1","SD1","SA1","SX3",Alias()})
	Local oArea			:= FWLayer():New()
	Local aCoord		:= FWGetDialogSize(oMainWnd)
	Local aTamObj		:= Array(4)
	Local aLstRotAux	:= {"CCSKFXFUN.PRW"}
	Local lTOP			:= .F.                                        
	Local nCoefDif		:= 1
	Local aPergunte		:= {}
	Local ni			:= 0
	Local nx			:= 0
	Local lOk			:= .F.
	Local aLstC01		:= {" ","F1_DTDIGIT","F1_PLACA","F1_DOC","A1_NREDUZ","F1_X_SQED","F1_XINT","F1_XOBS","D1_XPLACAS"} //Everson - 19/12/2022 - Ticket 85237.
	Local cLine01		:= ""

	Local bAtGD			:= {|lAtGD,lFoco| IIf(lAtGD,(oGD01:SetArray(_aDados01),oGD01:bLine := &(cLine01),oGD01:GoTop()),.T.),;
							Iif(ValType(lFoco) == "L" .AND. lFoco,oGD01:SetFocus(),.T.)}
	//Objetos graficos
	Local oTela
	Local oPainel01
	Local oPainel02
	Local oPainel03
	Local oPainelS01
	Local oBot01
	Local oBot02
	Local oBot03
	Local oBot05
	Local oGD01																							//Getdados

	Private oOk 		:= LoadBitmap(GetResources(),"LBOK")
	Private oNo 		:= LoadBitmap(GetResources(),"LBNO")
	Private cRotNome	:= "[" + StrTran(ProcName(0),"U_","") + "]" + Space(1)
	Private __oDlg
	Private cRotDesc	:= "Integracao Protheus x Edata - Pedido de Devolu็ใo"
	Private cNomeUs		:= Capital(AllTrim(UsrRetName(__cUserID)))
	Private oRegua
	Private aLstPED		:= {}																		//Lista de notas fiscais selecionadas
	Private aHeader01	:= {}
	Private _aDados01	:= {}

	#IFDEF TOP
		lTop := .T.

	#ENDIF

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณValidacoes  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤู

	If !lTOP 
		MsgAlert(cNomeUs + ", esta rotina s๓ pode ser executada a partir de um banco de dados relacional.")
		Return Nil
	
	EndIf

	For ni := 1 to Len(aLstRotAux)

		If Empty(GetAPOInfo(aLstRotAux[ni]))
			MsgAlert(cNomeUs + ", uma rotina auxiliar (" + aLstRotAux[ni] + ") necessแria para a execu็ใo desta rotina nใo pode ser encontrada!")
			Return Nil		
		
		EndIf
	
	Next ni

	aFill(aTamObj,0)

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontar a lista de campos a utilizar na GD  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	dbSelectArea("SX3")
	SX3->(dbSetOrder(2))
	For ni := 1 to Len(aLstC01)
		If !Empty(aLstC01[ni]) .AND. SX3->(dbSeek(PadR(aLstC01[ni],10)))
			aAdd(aHeader01,{SX3->X3_CAMPO,;
							SX3->X3_PICTURE,;
							AllTrim(X3Titulo()),;
							SX3->X3_TAMANHO,;
							SX3->X3_TIPO})
		EndIf

	Next ni

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontar a lista de dados da GD  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_aDados01 := Array(1,Len(aHeader01) + 1)
	For ni := 1 to Len(_aDados01)
		_aDados01[ni][1] := .F.
		For nx := 1 to Len(aHeader01)
			_aDados01[ni][nx + 1] := CriaVar(aHeader01[nx][TCB_POS_CMP],.F.)

		Next nx

	Next ni

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontar o codeblock para montar as listas de dados da GD  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	cLine01 := "{|| {"
	cLine01 += "IIf(_aDados01[oGD01:nAt,1],oOk,oNo),"
	For ni := 2 to Len(aLstC01)
		cLine01 += "_aDados01[oGD01:nAt," + cValToChar(ni) + "]" + IIf(ni < Len(aLstC01),",","")

	Next ni
	cLine01 += "}}"

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณSubstituir o nome dos campos pelos titulos  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	For ni := 1 to Len(aLstC01)
		aLstC01[ni] := Posicione("SX3",2,PadR(aLstC01[ni],10),"X3Titulo()")

	Next ni

	//ฺฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณInterface  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤู
	aCoord[3] := aCoord[3] * 0.95
	aCoord[4] := aCoord[4] * 0.95
	If U_ApRedFWL(.T.)
		nCoefDif := 0.95

	EndIf

	DEFINE MSDIALOG oTela TITLE (Capital(cRotDesc) + " " + cRotNome) FROM aCoord[1],aCoord[2] TO aCoord[3],aCoord[4] OF oMainWnd COLOR "W+/W" PIXEL

		oArea:Init(oTela,.F.)
		//Mapeamento da area
		oArea:AddLine("L01",100 * nCoefDif,.T.)
		//ฺฤฤฤฤฤฤฤฤฤฟ
		//ณColunas  ณ
		//ภฤฤฤฤฤฤฤฤฤู
		oArea:AddCollumn("L01C01",LRG_COL01,.F.,"L01")
		oArea:AddCollumn("L01C02",LRG_COL02,.F.,"L01")
		oArea:AddCollumn("L01C03",LRG_COL03,.F.,"L01")
		//ฺฤฤฤฤฤฤฤฤฤฟ
		//ณPaineis  ณ
		//ภฤฤฤฤฤฤฤฤฤู
		oArea:AddWindow("L01C01","L01C01P01","Parโmetros",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
		oPainel01 := oArea:GetWinPanel("L01C01","L01C01P01","L01")
		oArea:AddWindow("L01C02","L01C02P01","Dados adicionais",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
		oPainel02 := oArea:GetWinPanel("L01C02","L01C02P01","L01")
		oArea:AddWindow("L01C03","L01C03P01","Fun็๕es",100,.F.,.F.,/*bAction*/,"L01",/*bGotFocus*/)
		oPainel03 := oArea:GetWinPanel("L01C03","L01C03P01","L01")
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPainel 01 - Filtros  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		//PERGUNTAS
		U_DefTamObj(@aTamObj,000,000,(oPainel01:nClientHeight / 2) * 0.9,oPainel01:nClientWidth / 2)
		oPainelS01 := tPanel():New(aTamObj[1],aTamObj[2],"",oPainel01,,.F.,.F.,,CLR_WHITE,aTamObj[4],aTamObj[3],.T.,.F.)

		Pergunte(cPerg,.T.,,.F.,oPainelS01,,@aPergunte,.T.,.F.)

		CCSP001At(aClone(aHeader01),@_aDados01)

		//BOTAO PESQUISA
		U_DefTamObj(@aTamObj,(oPainel01:nClientHeight / 2) - nAltBot,000,(oPainel01:nClientWidth / 2),nAltBot,.T.)
		oBot01 := tButton():New(aTamObj[1],aTamObj[2],cHK + "Pesquisar",oPainel01,;
			{|| IIf(PFATA2VlP(cPerg,@aPergunte),;
			MsAguarde({|| CursorWait(),CCSP001At(aClone(aHeader01),@_aDados01),Eval(bAtGD,.T.,.T.),CursorArrow()},cRotNome,"Pesquisando",.F.),.F.)},;
			aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPainel 02 - Lista de dados  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		oGD01 := TCBrowse():New(000,000,000,000,/*bLine*/,aLstC01,,oPainel02,,,,/*bChange*/,/*bLDblClick*/,/*bRClick*/,/*oFont*/,,,,,,,.T.,/*bWhen*/,,/*bValid*/,.T.,.T.)
		oGD01:bHeaderClick	:= {|oObj,nCol| CCSP001GD(2,@_aDados01,@oGD01,nCol,aClone(aHeader01)),oGD01:Refresh()}
		oGD01:blDblClick	:= {|| CCSP001GD(1,@_aDados01,@oGD01,,aClone(aHeader01)),oGD01:Refresh()}
		oGD01:Align 		:= CONTROL_ALIGN_ALLCLIENT
		Eval(bAtGD,.T.,.F.)

		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณPainel 03 - Funcoes  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

		//ENVIO EDATA
		U_DefTamObj(@aTamObj,000,000,(oPainel03:nClientWidth / 2),nAltBot,.T.)
		oBot01 := tButton():New(aTamObj[1],aTamObj[2],cHK + "Envio Edata",oPainel03,;
			{|| IIf(!Empty(aLstPED),;
			MsAguarde({|| CursorWait(),lOk := CCS_001P(@oTela),CursorArrow(),IIf(lOk,(CCSP001At(aClone(aHeader01),@_aDados01),Eval(bAtGD,.T.,.T.)),AllwaysTrue())},;
			cRotNome,"Processando",.F.),MsgAlert(cNomeUs + ", para processar ้ necessแrio que ao menos um registro seja selecionado!",cRotNome))},;
			aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)

		//ESTORNO EDATA
		U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
		oBot02 := tButton():New(aTamObj[1],aTamObj[2],cHK + "Estorno",oPainel03,;
			{|| IIf(!Empty(aLstPED),;
			MsAguarde({|| CursorWait(),lOk := CCS_001E(@oTela),CursorArrow(),IIf(lOk,(CCSP001At(aClone(aHeader01),@_aDados01),Eval(bAtGD,.T.,.T.)),AllwaysTrue())},;
			cRotNome,"Processando",.F.),MsgAlert(cNomeUs + ", para processar ้ necessแrio que ao menos um registro seja selecionado!",cRotNome))},;
			aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)

		//CONSULTA LOG
		U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
		oBot03 := tButton():New(aTamObj[1],aTamObj[2],cHK + "ConsultaLog",oPainel03,{||CCS_001L(@oTela) },aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)

		//Sair
		U_DefTamObj(@aTamObj,aTamObj[1] + nAltBot + nDistPad)
		oBot05 := tButton():New(aTamObj[1],aTamObj[2],cHK + "Sair",oPainel03,{|| oTela:End()},aTamObj[3],aTamObj[4],,/*Font*/,,.T.,,,,{|| .T.}/*When*/)

	oTela:Activate(,,,.T.,/*valid*/,,{|| .T.})

	RestArea1(aArea)

	ProcLogAtu("FIM")
	
Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณCCSP001AT   บAutor  ณPablo Gollan Carreras บ Data ณ04/06/12        บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDesc.     ณRotina de atualizacao da lista de dados                           บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                                  บฑฑ
ฑฑบ          ณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณPACE                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CCSP001At(aHeader01,_aDados01)

	//Variแveis.
	Local ni				:= 0
	Local nx				:= 0
	Local cLstC01			:= ""
	Local cAliasT			:= GetNextAlias()
	Local aTMP				:= {}
	Local aDtRef			:= Array(2)

	//Everson - 14/10/2021. Chamado 62436.
	If ! chkEdtLk()
		Return Nil

	EndIf
	//

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณDefinicoes de filtros  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	_aDados01 := Array(0)
	aDtRef[1] := MV_PAR01
	aDtRef[2] := DtoS(MV_PAR02)

	If MV_PAR03 == 1		//Pend. classificacao
		cRest01 := "F1_XINT IN ('1', ' ') "

	ElseIf MV_PAR03 == 5		//Pend. classificacao
		cRest01 := " 1 = 1"

	Else
		cRest01 := "F1_XINT = '" + Alltrim(STR(MV_PAR03)) + "' "

	EndIf      

	If MV_PAR04 == 1 //ENVIO
		cRest02 := "F1_X_SQED = ' ' "	

	Else
		cRest02 := "F1_X_SQED <> ' ' "	

	EndIf

	cRest01 := "%" + cRest01 + "%"
	cRest02 := "%" + cRest02 + "%"

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณFazer a pesquisa dos dados  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	(cLstC01 := "",aEval(aHeader01,{|x| IIf(!Empty(x[TCB_POS_CMP]),cLstC01 += x[TCB_POS_CMP] + ",","")}),cLstC01 := "%" + Substr(cLstC01,1,Len(cLstC01) - 1) + "%")

	//Inicio 28/01/2019 - fernando sigoli 28/01 Chamado 046731
	BeginSQL Alias cAliasT   

		SELECT 
			F1_DTDIGIT,F1_PLACA,F1_DOC,A1_NREDUZ,F1_X_SQED,F1_XINT,F1_XOBS, D1_XPLACAS //Everson - 19/12/2022 - Ticket 85237.
		FROM 
			%table:SF1% SF1,  %table:SA1% SA1 , %table:SD1% SD1
		WHERE 
			SF1.D_E_L_E_T_ = '' AND SA1.D_E_L_E_T_ = '' AND SF1.F1_FILIAL = %xFilial:SF1% AND SA1.A1_FILIAL =  %xFilial:SA1% 
			AND SD1.D_E_L_E_T_ = ''
			AND SF1.F1_FORNECE = SA1.A1_COD
			AND SF1.F1_LOJA = SA1.A1_LOJA
			AND ((SD1.D1_FILIAL=SF1.F1_FILIAL)
			AND (SD1.D1_DOC=SF1.F1_DOC) 
			AND (SD1.D1_SERIE=SF1.F1_SERIE) 
			AND (SD1.D1_FORNECE=SF1.F1_FORNECE)
			AND (SD1.D1_LOJA=SF1.F1_LOJA))
			AND SF1.F1_TIPO = 'D'
			AND SF1.F1_PLACA <> ' '
			and SD1.D1_LOCAL <> '11'  //NAO TRAZER NOTA DE QUEBRA
			AND SF1.F1_STATUS = ' '
			AND (SF1.F1_PLACA = %exp:MV_PAR01% OR SD1.D1_XPLACAS = %exp:MV_PAR01%)
			AND SF1.F1_DTDIGIT = %exp:MV_PAR02%
			AND SD1.D1_TES = '' //Everson - 29/06/2022. Ticket 75370.
			AND %exp:cRest01% 	
			AND %exp:cRest02% 	

		GROUP BY 
			F1_DTDIGIT,F1_PLACA,F1_DOC,A1_NREDUZ,F1_X_SQED,F1_XINT,F1_XOBS, D1_XPLACAS //Everson - 19/12/2022 - Ticket 85237.
		ORDER BY 
			SF1.F1_DTDIGIT,SD1.D1_XPLACAS,SF1.F1_PLACA,SF1.F1_DOC //Everson - 19/12/2022 - Ticket 85237.

	EndSQL
	//Fim 28/01/2019 - fernando sigoli 28/01 Chamado 046731	


	(cAliasT)->(dbGoTop())
	If !(cAliasT)->(Eof())
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณTratamento de tipo de dados  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		dbSelectArea("SX3")
		SX3->(dbSetOrder(2))
		For ni := 1 to Len(aHeader01)
			If !Empty(aHeader01[ni][TCB_POS_CMP]) .AND. aHeader01[ni][TCB_POS_TIP] # "C"
				SX3->(dbSeek(PadR(aHeader01[ni][TCB_POS_CMP],10)))
				If SX3->(Found())
					TcSetField(cAliasT,SX3->X3_CAMPO,SX3->X3_TIPO,SX3->X3_TAMANHO,SX3->X3_DECIMAL)
				EndIf
			EndIf
		Next ni
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณAlimentar dados  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		Do While !(cAliasT)->(Eof())
			
			_lLib := .T.
					
			// AVALIAR NECESSIDADE DE ALGUM TIPO DE FILTRO DE SELECAO DOS REGISTROS 
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
		//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
		//ณZerar lista de dados  ณ
		//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
		_aDados01 := Array(1,Len(aHeader01) + 1)
		For ni := 1 to Len(_aDados01)
			_aDados01[ni][1] := .F.
			For nx := 1 to Len(aHeader01)
				_aDados01[ni][nx + 1] := CriaVar(aHeader01[nx][TCB_POS_CMP],.F.)
			Next nx
		Next ni	
	EndIf

	U_FecArTMP(cAliasT)

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณCCSP001GD บAutor  ณPablo Gollan Carreras บ Data ณ04/06/12        บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDesc.     ณRotina pra fazer o tratamento de selecao de dados                 บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                                  บฑฑ
ฑฑบ          ณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณPACE                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CCSP001GD(nOpc,aDados,oGDSel,nColSel,aHead)

	Local ni		:= 0
	// Local lSubst	:= .F. //Everson - 19/12/2022 - Ticket 85237.

	PARAMTYPE 0	VAR nOpc		AS Numeric		OPTIONAL	DEFAULT 0
	PARAMTYPE 1	VAR aDados		AS Array		OPTIONAL	DEFAULT Array(0)
	PARAMTYPE 2	VAR oGDSel		AS Object		OPTIONAL	DEFAULT Nil
	PARAMTYPE 3	VAR nColSel		AS Numeric		OPTIONAL	DEFAULT 1
	PARAMTYPE 4	VAR aHead		AS Array		OPTIONAL	DEFAULT Array(0)

	If nOpc == 1

		// lSubst 	  := ! Empty(AllTrim(U_GDField(2,aHead,aDados,TCB_POS_CMP,"D1_XPLACAS",oGDSel:nAt,.T.))) //Everson - 19/12/2022 - Ticket 85237.

		// dData     := U_GDField(2,aHead,aDados,TCB_POS_CMP,"F1_DTDIGIT",oGDSel:nAt,.T.)
		// cPlaca    := U_GDField(2,aHead,aDados,TCB_POS_CMP, Iif(lSubst, "D1_XPLACAS","F1_PLACA"),oGDSel:nAt,.T.)	//Everson - 19/12/2022 - Ticket 85237.
		// cSeq      := U_GDField(2,aHead,aDados,TCB_POS_CMP,"F1_X_SQED",oGDSel:nAt,.T.)	

		aDados[oGDSel:nAt][1] := !aDados[oGDSel:nAt][1]

		For ni := 1 to Len(aDados)

			If oGDSel:nAt<>ni 

				If MV_PAR04 == 1 //ENVIO
					// If 	U_GDField(2,aHead,aDados,TCB_POS_CMP,"F1_DTDIGIT",ni,.T.) == dData .And. ;
					// 	U_GDField(2,aHead,aDados,TCB_POS_CMP,Iif(lSubst, "D1_XPLACAS","F1_PLACA"),ni,.T.) == cPlaca

							aDados[ni][1] := !aDados[ni][1]

					// EndIf

				Else

					// If 	U_GDField(2,aHead,aDados,TCB_POS_CMP,"F1_DTDIGIT",ni,.T.) == dData .And. ;
					// 	U_GDField(2,aHead,aDados,TCB_POS_CMP,Iif(lSubst, "D1_XPLACAS","F1_PLACA"),ni,.T.) == cPlaca .And. ;
					// 	U_GDField(2,aHead,aDados,TCB_POS_CMP,"F1_X_SQED",ni,.T.) == cSeq

							aDados[ni][1] := !aDados[ni][1]

					// EndIf
				
				EndIf
				
			EndIf

		Next ni

	Else

		If nColSel == 1

			// lSubst 	  := ! Empty(AllTrim(U_GDField(2,aHead,aDados,TCB_POS_CMP,"D1_XPLACAS",oGDSel:nAt,.T.))) //Everson - 19/12/2022 - Ticket 85237.

			For ni := 1 to Len(aDados)
			
				// If !Empty(U_GDField(2,aHead,aDados,TCB_POS_CMP,Iif(lSubst, "D1_XPLACAS","F1_PLACA"),ni,.T.))
					aDados[ni][1] := !aDados[ni][1]
			
				// EndIf
			
			Next ni

		Else
			aDados := aSort(aDados,,,{|x,y| x[nColSel] < y[nColSel]})
		
		EndIf

	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontar a lista de titulos selecionados  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู
	aLstPED := Array(0)
	For ni := 1 to Len(aDados)
		If aDados[ni][1]
			aAdd(aLstPED,U_GDField(2,aHead,aDados,TCB_POS_CMP,{"F1_DTDIGIT","F1_PLACA","A1_NREDUZ","F1_X_SQED","F1_XINT","F1_XOBS","D1_XPLACAS"},ni,.T.)) //Everson - 19/12/2022 - Ticket 85237.
		EndIf
	
	Next ni

	//Forcar a atualizacao do browse
	oGDSel:DrawSelect()

Return Nil
/*/{Protheus.doc} CCS_001P
	Rotina de processamento de registros selecionados 
	@type  Static Function
	@author Pablo Gollan Carreras
	@since 04/06/12
	@version 01
/*/
Static Function CCS_001P(oTela)

	//Variแveis.
	Local aArea 	:= GetArea()
	Local cStatus	:= ""
	Local cData	 	:= ""
	Local cPlaca	:= ""
	Local cMens 	:= "Lista de itens que nใo foram processados : " + CRLF
	Local cErro		:= ""

	PARAMTYPE 0	VAR oTela	AS Object	OPTIONAL	DEFAULT Nil

	If Empty(aLstPED) .OR. ValType(aLstPED) # "A"
		RestArea(aArea)
		Return .F.

	EndIf

	cStatus := aLstPED[1][5] 
	cData	:= AllTrim(Dtos(aLstPED[1][1]))
	cPlaca	:= Iif(!Empty(AllTrim(aLstPED[1][7])), AllTrim(aLstPED[1][7]), AllTrim(aLstPED[1][2])) //Everson - 19/12/2022 - Ticket 85237.

	If cStatus == "3"
		cMens += "- Devolu็ใo nใo processada, enviado anteriormente - Roteiro: [" + Iif(Empty(AllTrim(aLstPED[1][7])), AllTrim(aLstPED[1][2]), AllTrim(aLstPED[1][7])) + "]" + CRLF
		U_ExTelaMen(cRotDesc, cMens, "Arial",10,,.F.,.T.)
		RestArea(aArea)
		Return .F.

	EndIf
	
	//Cria sequencia edata
	aRet := CCSP_003S(cData, cPlaca) //Everson - 19/12/2022 - Ticket 85237.

	If ! aRet[1]
		cMens += "- Devolu็ใo nใo processada, erro no sequenciamento do edata: [" + cData + cPlaca + "]" + CRLF			
		U_ExTelaMen(cRotDesc, cMens, "Arial",10,,.F.,.T.)
		RestArea(aArea)
		Return .F.

	EndIf

	cSeq := aRet[2]

	//Executa a Stored Procedure
	If Alltrim(cFilAnt) == '02'
		TcSQLExec('EXEC ['+cLinkSe+'].[SMART].[dbo].[FI_DEVOCARG_01] ' +Str(Val(cSeq)) ) 

	Else
		TcSQLExec('EXEC ['+cLinkSe+'].[SMART].[dbo].[FI_DEVOCARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"','"+cFilAnt+"'") 
	
	EndIf
	
	cErro := U_RetErroED()
	
	//Processamento sem erros.
	If Empty(cErro)
		CCSP_003F(cData, cPlaca, "3", "OK", cSeq) //Everson - 19/12/2022 - Ticket 85237.
		RestArea(aArea)
		Return .T.

	EndIf

	//Everson - 03/05/2022. Chamado 72284.
	If "jแ foi enviada para o EDATA" $Alltrim(cValToChar(cErro))

		If Alltrim(cFilAnt) == '02'
			TcSQLExec('EXEC ['+cLinkSe+'].[SMART].[dbo].[FD_DEVOCARG_01] ' +Str(Val(cSeq))) 

		Else
			TcSQLExec('EXEC ['+cLinkSe+'].[SMART].[dbo].[FD_DEVOCARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"','"+cFilAnt+"'")

		EndIf

		CCSP_003F(cData,cPlaca,"4",cErro,cSeq)	//Everson - 19/12/2022 - Ticket 85237.
		
		cMens += "- Roteiro nใo processado: [" + cData + cPlaca + "]" + CRLF + "- Erro : [*** Refa็a o envio ***]"  + CRLF

	Else
 
		cMens += "- Roteiro nใo processado: [" + cData + cPlaca + "]" + CRLF + "- Erro : [" + cErro + "]"  + CRLF			
		CCSP_003F(cData,cPlaca,"4",cErro,cSeq) //Everson - 19/12/2022 - Ticket 85237.		

	EndIf			

	If ! Empty(cMens)
		U_ExTelaMen(cRotDesc, cMens, "Arial",10,,.F.,.T.)

	EndIf

	If oTela # Nil
		oTela:SetFocus()

	EndIf

	RestArea(aArea)

Return .T.
/*/{Protheus.doc} CCS_001E
	Rotina de estorno processamento de registros selecionados.
	@type  Static Function
	@author Pablo Gollan Carreras
	@since 04/06/12
	@version 01
/*/
Static Function CCS_001E(oTela)

	//Variแveis.
	Local aArea		:= GetArea()
	Local cStatus	:= ""
	Local cSeq 		:= ""
	Local cMens 	:= "Lista de itens que nใo foram processados : " + CRLF
	Local cErro		:= ""

	PARAMTYPE 0	VAR oTela	AS Object	OPTIONAL	DEFAULT Nil

	If Empty(aLstPED) .OR. ValType(aLstPED) # "A"
		RestArea(aArea)
		Return .F.

	EndIf

	cStatus	 := aLstPED[1][5]
	cData	 := AllTrim(Dtos(aLstPED[1][1]))
	cPlaca	 := Iif(!Empty(AllTrim(aLstPED[1][7])), AllTrim(aLstPED[1][7]), AllTrim(aLstPED[1][2])) //Everson - 19/12/2022 - Ticket 85237.
	cSeq	 := AllTrim(aLstPED[1][4])

	If cStatus <> "3"
		cMens += "- Roteiro nใo pode ser estornado pois ainda nใo foi processado: [" + AllTrim(aLstPED[1][4]) + "]" + CRLF
		U_ExTelaMen(cRotDesc,cMens,"Arial",10,,.F.,.T.)
		RestArea(aArea)
		Return .F.

	EndIf

	//Executa a Stored Procedure
	If Alltrim(cFilAnt) == "02"
		TcSQLExec('EXEC ['+cLinkSe+'].[SMART].[dbo].[FD_DEVOCARG_01] ' +Str(Val(cSeq)) ) 

	Else
		TcSQLExec('EXEC ['+cLinkSe+'].[SMART].[dbo].[FD_DEVOCARG_01] ' +Str(Val(cSeq))+","+"'"+cEmpAnt+"','"+cFilAnt+"'") 

	EndIf

	cErro := U_RetErroED()

	If Empty(cErro) 
		CCSP_003F(cData, cPlaca, "2", "OK", cSeq) //Everson - 19/12/2022 - Ticket 85237.
		RestArea(aArea)
		Return .T.

	EndIf
		       
	cMens += "- Roteiro nใo estornado: [" + cSeq + "]" + CRLF + "- Erro : [" + cErro + "]"  + CRLF								

	If ! Empty(cMens)
		U_ExTelaMen(cRotDesc,cMens,"Arial",10,,.F.,.T.)

	EndIf

	If oTela # Nil
		oTela:SetFocus()

	EndIf

Return .T.
/*/{Protheus.doc} PFATA2VlP
	Rotina para validacao do SX1 da rotina
	@type  Static Function
	@author Pablo Gollan Carreras
	@since 04/06/12
	@version 01
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
			MsgAlert(cNomeUs + ", inconsist๊ncia na pergunta " + StrZero(ni,2) + " (" + StrTran(AllTrim(Capital(aPergunte[ni][POS_X1DES])),"?","") + ")")
			Return !lRet
		EndIf
	Next ni                               

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัอออออออออออหอออออออัออออออออออออออออออออออหออออออัออออออออออออออออปฑฑ
ฑฑบPrograma  ณPFAT2Val   บAutor  ณPablo Gollan Carreras บ Data ณ04/06/12        บฑฑ
ฑฑฬออออออออออุอออออออออออสอออออออฯออออออออออออออออออออออสออออออฯออออออออออออออออนฑฑ
ฑฑบDesc.     ณRotina que atribui dinamicamente a validacao de cada pergunta     บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบParametrosณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบRetorno   ณ                                                                  บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณPACE                                                              บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
User Function CCSPVal3()

	Local lRet				:= .T.
	Local cVarAt			:= Upper(AllTrim(ReadVar()))
	Local nPos				:= 0
	Local aLstVld			:= {	{1,{|| Vazio() }},;
									{3,{|| Empty(StrTran(Upper(&(cVarAt)),"Z","")) }},;
									{5,{|| NaoVazio()}},;
									{6,{|| NaoVazio()}},;
									{7,{|| cValToChar(&(cVarAt)) $ "12345"}}}
	Local bConvNum			:= {|x| x := GetDToVal(x)}

	U_ADINF009P('CCSP_003' + '.PRW',SUBSTRING(Alltrim(PROCNAME()),3,LEN(Alltrim(PROCNAME()))),'Integracao Protheus x Edata - Pedido de Devolu็ใo ')

	If "MV_PAR" $ cVarAt
		If !Empty(nPos := aScan(aLstVld,{|x| x[1] == Eval(bConvNum,Right(cVarAt,2))}))
			lRet := Eval(aTail(aLstVld[nPos]))
		EndIf
	EndIf

Return lRet
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCSP_003F  บAutor  ณMicrosiga           บ Data ณ  11/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Adoro                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CCSP_003F(cData,cPlaca,cFlag,cObs,cSeq)

	//Variแveis.
	Local cQuery	:= ""
	Local cNewAlias	:= ""
	Local nRecno	:= 0

	Default cSeq	:= ""

	Begin Transaction

		DbSelectArea("SF1")
		SF1->(DbGoTop())

		cQuery := ""
		cQuery += " SELECT " 
			cQuery += " DISTINCT SF1.R_E_C_N_O_ AS RECSF1 " 
		cQuery += " FROM " 
			cQuery += " " + RetSqlName("SF1") + " (NOLOCK) AS SF1 " 
			cQuery += " INNER JOIN " 
			cQuery += " " + RetSqlName("SD1") + " (NOLOCK) AS SD1 ON " 
			cQuery += " F1_FILIAL = D1_FILIAL " 
			cQuery += " AND F1_DOC = D1_DOC " 
			cQuery += " AND F1_SERIE = D1_SERIE " 
			cQuery += " AND F1_FORNECE = D1_FORNECE " 
			cQuery += " AND F1_LOJA = D1_LOJA " 
			cQuery += " AND SD1.D_E_L_E_T_ = '' " 
		cQuery += " WHERE " 
			cQuery += " F1_FILIAL = '" + FWxFilial("SF1") + "' " 
			cQuery += " AND F1_X_SQED = '" + cSeq + "' " 
			cQuery += " AND SF1.D_E_L_E_T_ = '' " 
		cQuery += " ORDER BY RECSF1 " 

		cNewAlias := GetNextAlias()

		DbUseArea(.t., "TOPCONN", TcGenQry(,, cQuery), cNewAlias, .F., .T.)
		(cNewAlias)->(DbGoTop())

		While ! (cNewAlias)->(Eof())

			nRecno := Val(cValToChar((cNewAlias)->RECSF1))

			If nRecno <= 0
				(cNewAlias)->(DbSkip())
				Loop

			EndIf

			SF1->(DbGoTo(nRecno))

			_lLib:=.T.
			
			If _lLib .And. RecLock("SF1",.F.)

					SF1->F1_XOBS	:= cObs
					SF1->F1_XINT	:= cFlag
					If IsInCallStack("CCS_001E") .or. cFlag=="4"
						SF1->F1_X_SQED	:= ""

					EndIf

				SF1->(MsUnlock())

			EndIf

			(cNewAlias)->(DbSkip())

		End	

		(cNewAlias)->(DbCloseArea())

		//GRAVA LOG
		If cFlag $ "2|3"
			RecLock("ZZ6",.T.)
			ZZ6->ZZ6_FILIAL := XFILIAL("ZZ6")
			ZZ6->ZZ6_TIPO	:= "D" //VERIFICAR
			ZZ6->ZZ6_CHAVE  := cData+cPlaca+cSeq
			ZZ6->ZZ6_DATA 	:= DDATABASE
			ZZ6->ZZ6_HORA 	:= TIME()
			ZZ6->ZZ6_USER 	:= Substring(cUsuario,7,15)
			ZZ6->ZZ6_OPER 	:= cFlag
			ZZ6->ZZ6_OBS 	:= cObs
			ZZ6->(MsUnlock())	 
		EndIf

	End Transaction

Return Nil
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCSP_003S  บAutor  ณMicrosiga           บ Data ณ  11/19/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Adoro                                                      บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CCSP_003S(cData, cPlaca) //Everson - 19/12/2022 - Ticket 85237.

	//Variแveis.
	Local aArea		:= GetArea()
	Local lRet   	:= .F.
	Local lRetD1 	:= .F.
	Local cQuery	:= ""
	Local cNewAlias	:= ""
	Local nRecno    := 0
								
	Begin Transaction

		_cSQED:= U_NextNum("SF1","F1_X_SQED",.F.)

		DbSelectArea("SF1")
		SF1->(DbGoTop())

		cQuery := ""
		cQuery += " SELECT " 
			cQuery += " DISTINCT SF1.R_E_C_N_O_ AS RECSF1 " 
		cQuery += " FROM " 
			cQuery += " " + RetSqlName("SF1") + " (NOLOCK) AS SF1 " 
			cQuery += " INNER JOIN " 
			cQuery += " " + RetSqlName("SD1") + " (NOLOCK) AS SD1 ON " 
			cQuery += " F1_FILIAL = D1_FILIAL " 
			cQuery += " AND F1_DOC = D1_DOC " 
			cQuery += " AND F1_SERIE = D1_SERIE " 
			cQuery += " AND F1_FORNECE = D1_FORNECE " 
			cQuery += " AND F1_LOJA = D1_LOJA " 
			cQuery += " AND SD1.D_E_L_E_T_ = '' " 
		cQuery += " WHERE " 
			cQuery += " F1_FILIAL = '" + FWxFilial("SF1") + "' " 
			cQuery += " AND F1_DTDIGIT = '" + cData + "' " 
			cQuery += " AND ( F1_PLACA = '" + cPlaca + "' OR D1_XPLACAS = '" + cPlaca + "' ) " 
			cQuery += " AND SF1.D_E_L_E_T_ = '' " 
		cQuery += " ORDER BY RECSF1 " 

		cNewAlias := GetNextAlias()

		DbUseArea(.t., "TOPCONN", TcGenQry(,, cQuery), cNewAlias, .F., .T.)
		(cNewAlias)->(DbGoTop())

		While ! (cNewAlias)->(Eof())

			nRecno := Val(cValToChar((cNewAlias)->RECSF1))

			If nRecno <= 0
				(cNewAlias)->(DbSkip())
				Loop

			EndIf

			SF1->(DbGoTo(nRecno))

			lRetD1 := ADVALSD1(SF1->F1_FILIAL, SF1->F1_DOC, SF1->F1_SERIE, SF1->F1_FORNECE, SF1->F1_LOJA) //chamado:047155 Fernando Sigoli 12/02/2019
				
			If lRetD1 .And. Empty(SF1->F1_X_SQED)
				
				RecLock("SF1",.F.)
					SF1->F1_X_SQED	:= _cSQED
				SF1->(MsUnlock())			 
				
				lRet:=.T.

			EndIf

			(cNewAlias)->(DbSkip())

		End

		(cNewAlias)->(DbCloseArea())

	End Transaction

	RestArea(aArea)

Return {lRet, _cSQED} 
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณADVALSD1 บAutor  ณFernando Sigoli      บ Data ณ  12/02/19   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ Chamado:047155 Fernando Sigoli 12/02/2019                  บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function ADVALSD1(cFil,cDoc,cSerie,cFornece,cLoja)

	Local lRt  := .F.
	Local cQry := "" 
	
	If Select ("QSD1") > 0
		DbSelectArea("QSD1")
		QSD1->(DbCloseArea())
	EndIf
	
	cQry += " SELECT COUNT(DISTINCT(D1_DOC)) AS D1_DOC FROM "+ RetSqlName( "SD1" ) + " WHERE D1_FILIAL = '"+cFil+"' AND D1_DOC  = '"+cDoc+"'  "
	cQry += " AND D1_SERIE = '"+cSerie+"' AND D1_FORNECE = '"+cFornece+"' AND D1_LOJA = '"+cLoja+"' AND D_E_L_E_T_ = '' "
	cQry += " AND D1_LOCAL <> '11' "  
	
	TcQuery cQry NEW ALIAS "QSD1" 
	

	
	If QSD1->D1_DOC > 0
		lRt := .T.
	EndIf  
	
	QSD1->(DbCloseArea())
	
Return(lRt)    
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
ฑฑษออออออออออัออออออออออหอออออออัออออออออออออออออออออหออออออัอออออออออออออปฑฑ
ฑฑบPrograma  ณCCSP_003  บAutor  ณMicrosiga           บ Data ณ  12/02/13   บฑฑ
ฑฑฬออออออออออุออออออออออสอออออออฯออออออออออออออออออออสออออออฯอออออออออออออนฑฑ
ฑฑบDesc.     ณ                                                            บฑฑ
ฑฑบ          ณ                                                            บฑฑ
ฑฑฬออออออออออุออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออนฑฑ
ฑฑบUso       ณ AP                                                        บฑฑ
ฑฑศออออออออออฯออออออออออออออออออออออออออออออออออออออออออออออออออออออออออออผฑฑ
ฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑฑ
฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿฿
*/
Static Function CCS_001L(oTela)

	Local lRet:=.T.
	Local cMens :=""
	Local cMens1:=""  
	Local ni

	If Empty(aLstPED) .OR. ValType(aLstPED) # "A"
		Return !lRet
	EndIf

	//ฺฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฟ
	//ณMontar a lista de contabilizacao  ณ
	//ภฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤฤู

	cData	 := ""
	cPlaca	 := ""

	For ni := 1 to Len(aLstPED)                   

		If (aLstPED[ni][5] $ "1| " )
			cMens += "- Devolu็ใo sem Log [" + AllTrim(aLstPED[ni][2]) + "]" + CRLF
		Else
			
			If cData+cPlaca <> AllTrim(Dtos(aLstPED[ni][1]))+AllTrim(aLstPED[ni][2])
			
				//Salva Roteiro em processamento
				cData	 := AllTrim(Dtos(aLstPED[ni][1]))
				cPlaca	 := AllTrim(aLstPED[ni][2])
				
				ZZ6->(dbSetOrder(2)) // Indice ( pedido )
				If ZZ6->(dbSeek(FWxFilial("ZZ6")+"D"+cData+cPlaca))
					While !ZZ6->(Eof()) .And. Alltrim(ZZ6->(ZZ6_FILIAL+ZZ6_TIPO+ZZ6_CHAVE)) == Alltrim(FWxFilial("ZZ6")+"D"+cData+cPlaca)

						cMens  := "Chave	 : " + ZZ6->ZZ6_CHAVE + CRLF
						cMens  += "Data 	 : " + DTOC(ZZ6->ZZ6_DATA) + CRLF
						cMens  += "Hora 	 : " + ZZ6->ZZ6_HORA + CRLF
						cMens  += "Usuแrio   : " + ZZ6->ZZ6_USER + CRLF
						cMens  += "Opera็ใo  : " + IIF(ZZ6->ZZ6_OPER == "2","Estorno","Envio") + CRLF + CRLF
																		
						cMens1 := cMens1 + cMens + CRLF
						
						ZZ6->(dbSkip())
					EndDo
				EndIf	
			EndIf	        
		EndIf
		
	Next ni

	If !Empty(cMens1)
		U_ExTelaMen(cRotDesc,cMens1,"Arial",10,,.F.,.T.)
	EndIf

	If oTela # Nil
		oTela:SetFocus()
	EndIf


Return lRet 
/*/{Protheus.doc} chkEdtLk
	Fun็ใo checa comunica็ใo com bd do Edata.
	Chamado 62436.
	@type  Static Function
	@author Everson
	@since 14/10/2021
	@version 01
/*/
Static Function chkEdtLk()

	//Variแveis.
	Local aArea := GetArea()
	Local lRet	:= Nil

	//lRet := Static Call(CCSP_002, chkEdtLk)
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	lRet := u_SP_002A0()

	RestArea(aArea)

Return lRet
