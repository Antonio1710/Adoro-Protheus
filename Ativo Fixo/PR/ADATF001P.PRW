#include "totvs.ch"
#include 'fwmvcdef.ch'
#include 'tbiconn.ch'
#include 'vkey.ch'

#define MVC_TITLE "Importação de Ativo Fixo."
#define MVC_VIEWDEF_NAME "VIEWDEF.ADATF001P"

/*/{Protheus.doc} User Function ADATF001P
  Função customizada para Importação de ativo fixo.
  @type  Function
  @author Rodrigo Mello
  @since 05/09/2022
  @version version
/*/

User Function ADATF001P()

	local       bProc           := {|oProc| ExecProc(oProc) }
	local       cDesc           := OEMToANSI('Importação do cadastro de ativo fixo.')
	local       cPerg           := "ADATF001P"

	private     oProcess
	private     nProcess        := 0

	private aHdSN1    := {}
	private aItSN1    := {}
	private aHdSN3    := {}
	private aItSN3    := {}

	private     __aLog          := {}

	pergunte(cPerg, .F.)

	MV_PAR03 := ";"

	tNewProcess():New("", cDesc, bProc, cDesc,cPerg , , , , , .T., .F.)

	if !empty(__aLog)
		fMakeLog( { __aLog }, { "Log de processamento - Imp. Ativo Fixo" }, NIL, NIL, NIL, cDesc, "M", "P",, .F. )
	endif

return

// Inicializacao do processamento
static function ExecProc(oProc)

	local aButtons	:= {{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.T.,"Confirmar"},{.T.,"Cancelar"},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil},{.F.,Nil}}
	local lRet  := .T.

	oProcess := oProc

	lRet := loadGrid( @oProcess )

	if ( lRet := validGrid( @oProcess ) ) 
		FWExecView( OemToAnsi("Atualização"), MVC_VIEWDEF_NAME, MODEL_OPERATION_UPDATE,,,{|| vldBtnOK()},,aButtons)
	endif

return

// Model MVC
static function ModelDef()
	local oModel
	local oStrutCab
	local oStrutN1
	local oStrutN3
	local aField
	local _i

    oStrutCab := FWFormModelStruct():New()
    oStrutCab:addTable("",{}, "Importação de Ativo Fixo" )
    oStrutCab:addField("Arq. Ativos"  , "Arq. Ativos"             , "ARQ1"   , "C", 100, 0 )
    oStrutCab:addField("Arq. Itens"   , "Arq. Itens"              , "ARQ2"   , "C", 100, 0 )

    oStrutN1 := FWFormModelStruct():New()
    oStrutN1:addTable("",{}, FwSX2Util():GetX2Name("SN1") )
	for _i:=1 to len( aHdSN1[1] )
		aField := FWSX3Util():GetFieldStruct( aHdSN1[1][_i] )
		oStrutN1:addField( GetSX3Cache(alltrim(aField[1]), "X3_TITULO"), GetSX3Cache(alltrim(aField[1]), "X3_DESCRIC"), alltrim(aField[1]), aField[2], aField[3], aField[4] )
	next i
	
    oStrutN3 := FWFormModelStruct():New()
    oStrutN3:addTable("",{}, FwSX2Util():GetX2Name("SN3") )
	for _i:=1 to len( aHdSN3[1] )
		aField := FWSX3Util():GetFieldStruct( aHdSN3[1][_i] )
		oStrutN3:addField( GetSX3Cache(alltrim(aField[1]), "X3_TITULO"), GetSX3Cache(alltrim(aField[1]), "X3_DESCRIC"), alltrim(aField[1]), aField[2], aField[3], aField[4] )
	next i	
	
	oModel := MPFormModel():New("MDADATF001P",,, {|| .T.}, {|| .T.})
	oModel:addFields("CABID", /*cOwner*/, oStrutCab, /*bPre*/   , /*bPost*/     , {|| {{MV_PAR01, MV_PAR02},1} } )
 	oModel:addGrid("GRIDID1", "CABID"   , oStrutN1, /*bLinePre*/, /*bLinePost*/ , /*bPre*/, /*bPost*/,  {|oMdl| aItSN1 })
	oModel:addGrid("GRIDID2", "GRIDID1" , oStrutN3, /*bLinePre*/, /*bLinePost*/ , /*bPre*/, /*bPost*/,  {|oMdl| fGridSN3(oMdl) })

	oModel:SetRelation( 'GRIDID1', {{ "N1_FILIAL", "N3_FILIAL" }, { "N1_CBASE", "N3_CBASE" }, { "N1_ITEM", "N3_ITEN" }}, "N1_FILIAL+N1_CBASE+N1_ITEM" )
	oModel:SetRelation( 'GRIDID2', {{ "N3_FILIAL", "N1_FILIAL" }, { "N3_CBASE", "N1_CBASE" }, { "N3_ITEM", "N1_ITEN" }}, "N3_FILIAL+N3_CBASE+N3_ITEM" )

	oModel:getModel("CABID"):setDescription(MVC_TITLE)
	oModel:getModel("GRIDID1"):setDescription(FwSX2Util():GetX2Name("SN1"))
	oModel:getModel("GRIDID2"):setDescription(FwSX2Util():GetX2Name("SN3"))

	oModel:getModel("GRIDID1"):setNoInsertLine(.T.)
	oModel:getModel("GRIDID2"):setNoInsertLine(.T.)

	oModel:setPrimaryKey({})

return oModel

// View MVC
static function viewDef()
	local aField
	local oView
	local oModel
	local oStrutN1
	local oStrutN3
	local i

    oStrutCab := FWFormViewStruct():New()
    oStrutCab:AddField("ARQ1"   , "01", "Arq. Ativos"  , "Arq. Ativos"             ,, "C", "",,,.F. ) 
    oStrutCab:AddField("ARQ2" 	, "02", "Arq. Itens"   , "Arq. Itens"              ,, "C", "",,,.F. ) 

	oStrutN1 := FWFormViewStruct():New()
	for i:=1 to len( aHdSN1[1] )
		aField := FWSX3Util():GetFieldStruct( aHdSN1[1][i] )
		oStrutN1:addField( alltrim(aField[1]), StrZero(i,2), GetSX3Cache(alltrim(aField[1]), "X3_TITULO"), alltrim(aField[1]),, aField[2], GetSX3Cache(alltrim(aField[1]), "X3_PICTURE"),,, .F.)
	next i

	oStrutN3 := FWFormViewStruct():New()
	for i:=1 to len( aHdSN3[1] )
		aField := FWSX3Util():GetFieldStruct( aHdSN3[1][i] )
		oStrutN3:addField( alltrim(aField[1]), StrZero(i,2), GetSX3Cache(alltrim(aField[1]), "X3_TITULO"), alltrim(aField[1]),, aField[2], GetSX3Cache(alltrim(aField[1]), "X3_PICTURE"),,, .F.)
	next i

	oModel := FWLoadModel("ADATF001P")
	oView := FwFormView():New()
	oView:setModel(oModel)

	oView:addField("CAB", oStrutCab, "CABID" )
	oView:addGrid("GRID1", oStrutN1, "GRIDID1" )
	oView:addGrid("GRID2", oStrutN3, "GRIDID2" )

	oView:createHorizontalBox("CABEC1", 10 )
	oView:createHorizontalBox("GRIDH1", 60 )
	oView:createHorizontalBox("GRIDH2", 30 )

	oView:setOwnerView("CAB"  , "CABEC1" )
	oView:setOwnerView("GRID1", "GRIDH1" )
	oView:setOwnerView("GRID2", "GRIDH2" )

	oView:EnableTitleView("GRID1", FwSX2Util():GetX2Name("SN1"))
	oView:EnableTitleView("GRID2", FwSX2Util():GetX2Name("SN3"))

	oView:SetCloseOnOk({|| .T. })

return oView

// totalizador
static function loadTot( oMdl)
	local nTotal := 0
	nTotal += oMdl:GetModel('GRIDID2'):GetValue("QTDAPO")
return nTotal

// Carga de dados para os grids
static function loadGrid( oProcess, nId )
	local aArea := GetArea()
	local lRet  := .T.

	oProcess:setRegua1(2)
	oProcess:incRegua1("Ativo fixo - SN1")
	oProcess:setRegua2(3)
	oProcess:incRegua2("Item do Ativo Fixo - SN3")

	if !fLoadSN1(@oProcess)
		FWAlertWarning('erro imp SN1', 'erro')
		lRet := .F.
	endif
	if lRet .and. !fLoadSN3(@oProcess)
		FWAlertWarning('erro imp SN3', 'erro')
		lRet := .F.
	endif

	restArea( aArea )

return lRet 

// Importa SN1 do csv
static function fLoadSN1( oProcess )
	local oFileSN1
	local aFileSN1  := {}
	local i, j
	local lRet      := .F.

	oFileSN1 := FWFileReader():New(MV_PAR01)
	if ( lRet := oFileSN1:open() )
		aFileSN1 := oFileSN1:getAllLines()
		for i:=1 to len(aFileSN1)
			if i == 1
				AAdd( aHdSN1, StrTokArr2( aFileSN1[i], PadR(MV_PAR03,1," "), .T. ) )
			else
				AAdd( aItSN1, { 0, StrTokArr2( aFileSN1[i], PadR(MV_PAR03,1," "), .T. ) }  )
			endif
		next i
	else
		FWAlertWarning("Não foi possível abrir o arquivo:" + CRLF + alltrim(MV_PAR01), "Ativo fixo")
	endif

	for i:=1 to len(aItSN1)
		for j:=1 to len(aItSN1[i][2])
			iif( alltrim(FWSX3Util():GetFieldStruct( aHdSN1[1][j] )[2]) $ "C|M" , aItSN1[i][2][j] := upper(fwnoaccent(decodeutf8(aItSN1[i][2][j]))) , Nil )
			iif( alltrim(FWSX3Util():GetFieldStruct( aHdSN1[1][j] )[2]) == "D"  , aItSN1[i][2][j] := CtoD(aItSN1[i][2][j]) , Nil )
			iif( alltrim(FWSX3Util():GetFieldStruct( aHdSN1[1][j] )[2]) == "N"  , aItSN1[i][2][j] := val(aItSN1[i][2][j]) , Nil )
			iif( alltrim(FWSX3Util():GetFieldStruct( aHdSN1[1][j] )[2]) == "L"  , aItSN1[i][2][j] := &(aItSN1[i][2][j]) , Nil )
		next j
	next i

return lRet

// Importa SN1 do csv
static function fLoadSN3( oProcess )
	local oFileSN3
	local aFileSN3  := {}
	local i, j
	local lRet      := .F.

	oFileSN3 := FWFileReader():New(MV_PAR02)
	if ( lRet := oFileSN3:open() )
		aFileSN3 := oFileSN3:getAllLines()
		for i:=1 to len(aFileSN3)
			if i == 1
				AAdd( aHdSN3, StrTokArr2( aFileSN3[i], PadR(MV_PAR03,1," "), .T. ) )
			else
				AAdd( aItSN3, { 0, StrTokArr2( aFileSN3[i], PadR(MV_PAR03,1," "), .T. ) }  )
			endif
		next i
	else
		FWAlertWarning("Não foi possível abrir o arquivo:" + CRLF + alltrim(MV_PAR02), "Itens do ativo fixo")
	endif

	for i:=1 to len(aItSN3)
		for j:=1 to len(aItSN3[i][2])
			iif( alltrim(FWSX3Util():GetFieldStruct( aHdSN3[1][j] )[2]) $ "C|M" , aItSN3[i][2][j] := upper(fwnoaccent(decodeutf8(aItSN3[i][2][j]))) , Nil )
			iif( alltrim(FWSX3Util():GetFieldStruct( aHdSN3[1][j] )[2]) == "D"  , aItSN3[i][2][j] := CtoD(aItSN3[i][2][j]) , Nil )
			iif( alltrim(FWSX3Util():GetFieldStruct( aHdSN3[1][j] )[2]) == "N"  , aItSN3[i][2][j] := val(aItSN3[i][2][j]) , Nil )
			iif( alltrim(FWSX3Util():GetFieldStruct( aHdSN3[1][j] )[2]) == "L"  , aItSN3[i][2][j] := &(aItSN3[i][2][j]) , Nil )
		next j
	next i

return lRet

static function fGridSN3(oMdl)
	local cN3Filial 
	local cN3CBase
	local cN3Item
	local i
	local aData 	 := {}
	local nPosFilial := AScan( aHdSN3[1], {|u| u == "N3_FILIAL"})
	local nPosCBase	 := AScan( aHdSN3[1], {|u| u == "N3_CBASE"})
	local nPosItem	 := AScan( aHdSN3[1], {|u| u == "N3_ITEM"})
	
	cN3Filial 	:= alltrim(oMdl:GetModel():GetModel('GRIDID1'):GetValue("N1_FILIAL"))
	cN3CBase 	:= alltrim(oMdl:GetModel():GetModel('GRIDID1'):GetValue("N1_CBASE"))
	cN3Item 	:= alltrim(oMdl:GetModel():GetModel('GRIDID1'):GetValue("N1_ITEM"))

	for i:=1 to len(aItSN3)
		if len(aItSN3[i]) > 1 .and. aItSN3[i][2][nPosFilial]+aItSN3[i][2][nPosCBase]+aItSN3[i][2][nPosItem] == cN3Filial+cN3CBase+cN3Item
			AAdd( aData, aItSN3[i])
		endif
	next i

return aData

// Validaï¿½ï¿½o dos campos existentes no arquivo
static function validGrid( oProcess )

	local aFieldsN1 := FWSX3Util():GetListFieldsStruct("SN1")
	local aFieldsN3 := FWSX3Util():GetListFieldsStruct("SN3")
	local aObrigN1  := {}
	local aObrigN3  := {}
	local i
	local lRet := .T.

	AEval( aFieldsN1, {|u| iif( X3Obrigat(u[1]), AAdd( aObrigN1, u), Nil) })
	AEval( aFieldsN3, {|u| iif( X3Obrigat(u[1]), AAdd( aObrigN3, u), Nil) })

	oProcess:setRegua1(4)
	oProcess:incRegua1("Ativo fixo - SN1")
	oProcess:setRegua2(5)
	oProcess:incRegua2("Item do Ativo Fixo - SN3")
	// valida campo SN1
	if lRet 
		for i:=1 to len(aHdSN1[1])
			if alltrim(aHdSN1[1][i]) != "N1_FILIAL" .and. AScan( aFieldsN1, {|x| alltrim(x[1]) ==  aHdSN1[1][i] } ) <= 0 
				FWAlertWarning("Campo informado no arquivo não existe no dicionário." + CRLF + aHdSN1[1][i] , FwSX2Util():GetX2Name( "SN1" ))
				lRet := .F.
				exit
			endif
		next i
	endif
	// valida campo SN3
	if lRet 
		for i:=1 to len(aHdSN3[1])
			if alltrim(aHdSN3[1][i]) != "N3_FILIAL" .and. AScan( aFieldsN3, {|x| alltrim(x[1]) ==  aHdSN3[1][i] } ) <= 0 
				FWAlertWarning("Campo informado no arquivo não existe no dicionário." + CRLF + aHdSN3[1][i] , FwSX2Util():GetX2Name( "SN3" ) )
				lRet := .F.
				exit
			endif
		next i
	endif
	// valida campo obrigatorios SN1
	if lRet 
		for i:=1 to len(aObrigN1)
			if AScan( aHdSN1[1], {|x| alltrim(x) ==  aObrigN1[i][1] } ) <= 0 
				FWAlertWarning("Campo obrigatório não informado no arquivo." + CRLF + aObrigN1[i], FwSX2Util():GetX2Name( "SN1" ) )
				lRet := .F.
				exit
			endif
		next i
	endif
	// valida campo obrigatorios SN3
	if lRet 
		for i:=1 to len(aObrigN3)
			if AScan( aHdSN3[1], {|x| alltrim(x) ==  aObrigN3[i][1] } ) <= 0 
				FWAlertWarning("Campo obrugatório não informado no arquivo." + CRLF + aObrigN3[i], FwSX2Util():GetX2Name( "SN3" ) )
				lRet := .F.
				exit
			endif
		next i
	endif

return lRet

// Validacoes de confirmacao do form
static function vldBtnOK()
	local lRet := .T.

	if ( lRet := aviso("Confirma", OemToAnsi("Confirma a importação dos ativos e movimentos?"), {"Sim", "Não"}, 3 )  == 1 )
		FWMsgRun(, {|oSay| lRet := procImport(oSay) }, "Processando", "Processando a rotina...")
		
	endif

return lRet

// processamento das rotinas automaticas
static function procImport(oSay)
	local oMdlAct := FWModelActive()
	local i, j 
	local aItSN1  := {}
	local aItSN3  := {}
	local aTmpSN3 := {}
	local lRet    := .T.
	local nImpN1	  := 0
	local nImpN3	  := 0
	local __cFilAnt   := cFilAnt
	local __cNumEmp	  := cNumEmp
	local nPosFil     := 0

	local _MV_PAR01   := MV_PAR01
	local _MV_PAR02   := MV_PAR02

	private 	lMsErroAuto 	:= .F.
	//private 	lAutoErrNoFile  := .T.

	begin Transaction

		for i:=1 to oMdlAct:getModel('GRIDID1'):length()

			aItSN1  := {}
			aItSN3  := {}
			oMdlAct:lModify := .T.
			oMdlAct:getModel('GRIDID1'):goLine(i)
			
			Aeval( aHdSN1[1], {|u| iif( !empty(oMdlAct:getModel('GRIDID1'):GetValue(u)), AAdd( aItSN1 , { u, oMdlAct:getModel('GRIDID1'):GetValue(u), Nil } ), Nil ) } )
			
			for j:=1 to oMdlAct:getModel('GRIDID2'):length()
				oMdlAct:getModel('GRIDID2'):goLine(j)
				aTmpSN3 := {}
				Aeval( aHdSN3[1], {|u| iif( !empty(oMdlAct:getModel('GRIDID2'):GetValue(u)), AAdd( aTmpSN3 , { u, oMdlAct:getModel('GRIDID2'):GetValue(u), Nil } ), Nil ) } )
				AAdd( aItSN3, aTmpSN3)
			next j

			aItSN1 := FWVetByDic( aItSN1 , "SN1", .F.)    
			aItSN3 := FWVetByDic( aItSN3 , "SN3", .T.)    

			// Caso exista filial no arquivo csv, alteramos para execucao do MSExecAuto
			if ( nPosFil := AScan( aItSN1, {|u| alltrim(u[1]) == "N1_FILIAL" }) ) > 0
				cFilAnt := aItSN1[nPosFil,2]
				cNumEmp := cEmpAnt + cFilAnt
			endif

			MSExecAuto({|x,y,z| ATFA012(x,y,z)}, aItSN1, aItSN3, 3 )
			if lMsErroAuto 
				lRet := .F.
				MostraErro()
				//AeVal( GetAutoGRLog(), {|u| iif( !empty(u), AAdd( __aLog, cValToChar(u) ), nil) })
				DisarmTransaction()
				exit
			else
				nImpN1 ++
				nImpN3 += oMdlAct:getModel('GRIDID2'):length()
			endif

			cFilAnt := __cFilAnt
			cNumEmp := __cNumEmp

		next i

	end Transaction

	if lRet
		AAdd( __aLog, "Arquivo - SN1: " + _MV_PAR01)
		AAdd( __aLog, Space(10) + "Registros processados: " + StrZero(nImpN1, 12))
		AAdd( __aLog, "Arquivo - SN3: " + _MV_PAR02)
		AAdd( __aLog, Space(10) + "Registros processados: " + StrZero(nImpN3, 12))
	endif

return lRet
