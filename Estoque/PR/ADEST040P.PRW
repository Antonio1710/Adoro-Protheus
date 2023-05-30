#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TOTVS.CH"
#Include "Topconn.ch"

/*/{Protheus.doc} User Function ADEST040P
	Gera ordem de produção por integração do SAG
	ADEST033P - Rotina JOB que importa as OPs do SAG e popula a tabela ZCV
	@type  Function
	@author Ricardo Lima
	@since 01/11/2018
	@version 01
	@chamado 037647
	@history chamado 048153 - FWNM            - 01/04/2019 - OS 049415 || CONTROLADORIA || ANDRESSA || 45968437 OP DE OVOS
	@history chamado 049347 - Fernando Sigoli - 06/06/2019 - OS 050685 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || SAG VS PROTHEUS
	@history chamado 048347 - FWNM            - 18/06/2019 - OS 051224 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || OP SAG X PROTHEUS
	@history chamado 058675 - Everson         - 23/06/2020 - OS 060165 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || ADEST040P
	@history chamado 059430 - Everson		  - 07/08/2020 - Alterado nome do arquivo temporário.
	@history chamado 7087   - Everson		  - 04/01/2021 - Tratamento para execução de sincronização com o SAG.
	@hystory Ticket 65674   - ADRIANO SAVOINE - 28/12/2021 - Gerado no sistema o novo campo para trazer a descrição do Tipo Ovo ZCV_DESCTP.
	@hystory Ticket 67537   - Fer Macieira    - 02/02/2022 - Importação de Ovos - Ordem de Produção
	@hystory Ticket 69257   - Fernan Macieira - 08/03/2022 - Redundancia na consistência de duplicação das OPs
	@history Ticket 70142   - Edvar / Flek Solution - 06/04/2022 - Retirada de função PUTSX1
	@history Ticket 84332   - Jonathan        - 02/12/2022 - Inclusão do Tipo de Ovo C
    @history Ticket 85787 - 23/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	@history Ticket 89487 - 06/03/2023 - Adriano Savoine   - Criado a Tabela Temporaria e removidos comentarios errados no Fonte.
	@history Ticket 85787 - 08/03/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	@history ticket 90345 - Fernando Macieira - 17/03/2023 - Empenhos OPS de Ovos Fev/23 / Erro estorno OP filial 0D
	@history ticket 93215 - 04/05/2023 - Fernando Macieira - Erro processamento de OP de Ovos
	@history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 23/05/2023 - Revisão Ajuste Nova Empresa
/*/
User Function ADEST040P()

	Local EmpHbl := Alltrim(SuperGetMv( "MV_#ADE401" , .F. , '07|09' , ) ) // Chamado n. 058675 || OS 060165 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || ADEST040P - FWNM - 03/06/2020
	Local FilHbl := Alltrim(SuperGetMv( "MV_#ADE402" , .F. , '01' , ) )
	
	Private oBrowse
	Private aRotina := AdMnDef()
	Private _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 23/05/2023

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Gera ordem de produção por integração do SAG')
	
	If !cEmpAnt $ EmpHbl
		If !cFilAnt $ FilHbl
			ApMsgInfo('Empresa ou Filial NÃO Habilitada para usar essa Rotina, Verifique!','Controle de OP')
			Return Nil
		EndIf
	Endif
	
	//@history Ticket 70142  - Edvar / Flek Solution - 06/04/2022 - Retirada de função PUTSX1
	//MontaPerg()
	//Pergunte("ADES040P",.F.)
	
	oBrowse := FWMBrowse():New()
	oBrowse:SetAlias("ZCV")
	oBrowse:SetDescription("Controle de Ordem de Produção")
	oBrowse:AddLegend("ZCV_NUMERP = ' '","BR_VERDE"   ,"Apto para Gerar OP")
	oBrowse:AddLegend("ZCV_NUMERP <>' '","BR_VERMELHO","OP Gerada")
	//oBrowse:SetFilterDefault("ZCV_FILIAL = '" + FWxFilial("ZCV") + "' ") // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	oBrowse:Activate()

Return

/*/{Protheus.doc} STATIC Function ModelDef()
	Chamado: 037647,Gera ordem de produção por integração do SAG
	@type  Static Function
	@author Ricardo Lima
	@since 01/11/2018
/*/
Static Function ModelDef()

	Local oModel	:= Nil
	Local oStruZCV  := FWFormStruct( 1, "ZCV", /*bAvalCampo*/, /*lViewUsado*/ )
	
	oModel := MPFormModel():New("ModelDef_MVC",/*bPreVld*/,/*bPosValidacao*/,/*bCommit*/,/*bCancel*/ )
	oModel:SetDescription("Controle de Ordem de Produção")
	oModel:AddFields("ZCVMASTER", /*cOwner*/, oStruZCV,/*bPreValidacao*/,/*bPosValidacao*/,/*bCarga*/ )
	oModel:SetPrimaryKey( {"ZCV_FILIAL" } )

Return oModel

/*/{Protheus.doc} STATIC Function ViewDef()
	Chamado: 037647,Gera ordem de produção por integração do SAG
	@type  Static Function
	@author Ricardo Lima
	@since 01/11/2018
	@version 01
/*/
Static Function ViewDef()

	Local oView
	Local oModel   := ModelDef()
	Local oStruZCV := FWFormStruct( 2, "ZCV" )
	
	oView := FWFormView():New()
	oView:SetModel( oModel )
	oView:AddField("VIEW_ZCV", oStruZCV, "ZCVMASTER" )
	oView:CreateHorizontalBox("TELA" , 100 )
	oView:SetCloseOnOk( { || .T. } )

Return oView

/*/{Protheus.doc} STATIC Function AdMnDef()
	Chamado: 037647,Gera ordem de produção por integração do SAG
	@type  Static Function
	@author Ricardo Lima
	@since 01/11/2018
	@version 01
/*/
Static Function AdMnDef()

	Local aRotina := {}
	
	ADD OPTION aRotina TITLE "Visualizar" 		 ACTION "VIEWDEF.ADEST040P" OPERATION 2 ACCESS 0
	ADD OPTION aRotina TITLE "Gerar OP"   		 ACTION "U_ADES40GO(1)"      OPERATION 4 ACCESS 0
	ADD OPTION aRotina TITLE "Estorna OP" 		 ACTION "U_ADES40GO(2)"      OPERATION 4 ACCESS 0

	//Everson - 04/01/2021. Chamado 7087.
	If cEmpAnt == "07"
		ADD OPTION aRotina TITLE "Sincroniza OP SAG" ACTION "Processa({|| U_ADEST033P() },,'Atualizando...')"     OPERATION 3 ACCESS 0

	ElseIf cEmpAnt == "09"
		ADD OPTION aRotina TITLE "Sincroniza OP SAG" ACTION "Processa({|| U_ADEST049P() },,'Atualizando...')"     OPERATION 3 ACCESS 0

	ElseIf cEmpAnt $ _cEmpAt1 //ticket TI - Antonio Domingos - 23/05/2023 
		ADD OPTION aRotina TITLE "Sincroniza OP SAG" ACTION "Processa({|| U_ADEST053P() },,'Atualizando...')"     OPERATION 3 ACCESS 0

	EndIf
	//

	ADD OPTION aRotina TITLE "Legenda"    		 ACTION "U_ADES040L()"      OPERATION 9 ACCESS 0

Return aRotina

/*/{Protheus.doc} User Function ADES040L()
	Chamado: 037647,Gera ordem de produção por integração do SAG
	@type  Static Function
	@author Ricardo Lima
	@since 01/11/2018
	@version 01
/*/
User Function ADES040L()

	//Variáveis.
	Local aLegenda := {}
	
	aAdd(aLegenda,{"BR_VERDE"   ,"Apto para Gerar OP"})
	aAdd(aLegenda,{"BR_VERMELHO","OP Gerada"})
	
	BrwLegenda("Frete","Legenda",aLegenda)

Return NiL

/*/{Protheus.doc} User Function ADES40GO(nOpc)
	Chamado: 037647,Gera ordem de produção por integração do SAG
	@type  Static Function
	@author Ricardo Lima
	@since 01/11/2018
	@version 01
/*/
User Function ADES40GO(nOpc)	

	Local oFont      := TFont():New("Verdana",,014,,.T.,,,,,.F.,.F.)
	//Local cAglutOP   := GetMV("MV_#SAGOVO",,"2") // 1 = OP SAG x OP P12; 2 = OP p/ DIA+LOTE; 3 = OP p/ periodo selecionado
	
	Private oDlg	                                                 //fernando sigoli chamado 049347 data 06/06/2019
	Private aBtcfm   := {}
	Private aCpoBro	 := {}
	Private cProdOP  := SuperGetMv( "MV_#ADE334" , .F. , '384413' , )
	Private cCcusto  := SuperGetMv( "MV_#ADE332" , .F. , '1103' , )
	Private nNumOp   := ZCV->ZCV_NUMERP
	Private nQtdOp   := 0
	Private nQtdTl   := 0

	// Markbrowse
	Private lInverte := .F.
	Private cMark    := GetMark()
	Private oMark
	Private oContainer
	Private oModal

	Private aParamBox   := {}
    Private aRet        := {}

	Private dMVParam01  := ""
	Private dMVParam02  := ""
	Private cMVParam03  := ""
	Private cMVParam04  := ""

	U_ADINF009P('ADEST040P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Gera ordem de produção por integração do SAG')

	//Define as cores dos itens de legenda.
	aCores := {}
	aAdd(aCores,{"Empty(ZCV_NUMERP)","BR_VERDE"	})
	aAdd(aCores,{"!Empty(ZCV_NUMERP)","BR_VERMELHO"})

	ApMsgInfo('Selecione o Periodo para Geração de Ordem de Produção.','Ordem de Produção')

	// // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	//Pergunte("ADES040P",.T.) // @history Ticket 85787 - 08/03/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO

    aAdd(aParamBox ,{1,"Dt Produção De"  					,msDate(),"" ,'.T.',"",'.T.',80,.F.})
	aAdd(aParamBox ,{1,"Dt Produção Até" 					,msDate(),"" ,'.T.',"",'.T.',80,.F.})
	aAdd(aParamBox ,{1,"Filial De"  						,Space(2) ,"" ,'.T.',"SM0",'.T.',80,.F.})
	aAdd(aParamBox ,{1,"Filial Até"  						,"ZZ" ,"" ,'.T.',"SM0",'.T.',80,.F.})

    If ParamBox(aParamBox,"Parâmetros",@aRet)

		// @history ticket 90345 - Fernando Macieira - 17/03/2023 - Empenhos OPS de Ovos Fev/23 / Erro estorno OP filial 0D
		dMVParam01  := MV_PAR01
		dMVParam02  := MV_PAR02
		cMVParam03  := MV_PAR03
		cMVParam04  := MV_PAR04
		//

		Aadd( aCpoBro,{"OK" 		,  , "Mark"            , "@!"} )
		Aadd( aCpoBro,{"ZCV_FILIAL" ,  , "Filial"          , " " } ) // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
		Aadd( aCpoBro,{"ZCV_CODOP"  ,  , "Num OP SAG"      , " " } )
		Aadd( aCpoBro,{"ZCV_CODTIP" ,  , "Tipo"            , " " } )
		Aadd( aCpoBro,{"ZCV_DESCTP" ,  , "Descricao Tipo"  , " " } )  //Ticket 65674   - ADRIANO SAVOINE - 28/12/2021
		Aadd( aCpoBro,{"ZCV_CDLOTE" ,  , "Lote"            , " " } )
		Aadd( aCpoBro,{"ZCN_DESCLT" ,  , "Descricao Lote"  , " " } )
		Aadd( aCpoBro,{"ZCV_DATA"   ,  , "Data"            , " " } )
		Aadd( aCpoBro,{"ZCV_IDADEO" ,  , "Idade Ovo"       , " " } )
		Aadd( aCpoBro,{"ZCV_QTDOVO" ,  , "Quantidade"      , " " } )
		Aadd( aCpoBro,{"ZCV_CODAOJ" ,  , "Cod. Alojamento" , " " } )
		Aadd( aCpoBro,{"ZCV_NUMERP" ,  , "Num OP Protheus" , " " } )
		
		DEFINE MSDIALOG oDlg TITLE "Itens para Geração de Ordem de Produção" From 5,0 To 500,1200 PIXEL

		/*
		oModal := FWDialogModal():New()
		oModal:SetEscClose(.T.)
		oModal:setTitle("Ordem de Produção")
		oModal:setSubTitle("Itens para Geração de Ordem de Produção.")
		oModal:setSize( 250 , 600 )
		oModal:createDialog()
		oModal:addButtons( aBtcfm )
		oModal:addCloseButton(nil, "Fechar")
		
		oContainer := TPanel():New( ,,, oModal:getPanelMain() )
		oContainer:Align := CONTROL_ALIGN_ALLCLIENT
		
		TSay():New(003,002,{|| "Produto"  },oContainer,,oFont,,,,.T.,,,40,20,,,,,,.T.)
		TGet():New(015,002,{|u| if( PCount() > 0, cProdOP := u, cProdOP ) } ,oContainer,30,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SB1","cProdOP")
		
		oContainer := TPanel():New( ,,, oModal:getPanelMain() )
		oContainer:Align := CONTROL_ALIGN_ALLCLIENT

		TSay():New(003,002,{|| "Produto"  },oContainer,,oFont,,,,.T.,,,40,20,,,,,,.T.)
		TGet():New(015,002,{|u| if( PCount() > 0, cProdOP := u, cProdOP ) } ,oContainer,30,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F.,"SB1","cProdOP")
		*/
		
		ADES40DO(nOpc)
		
		TSay():New(160,002,{|| "Ordem de Produção Gerada"  },oContainer,,oFont,,,,.T.,,,120,20,,,,,,.T.)
		TGet():New(175,002,{|u| if( PCount() > 0, nNumOp := u, nNumOp ) } ,oContainer,50,009,"@!",,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"nNumOp")
		TSay():New(160,120,{|| "Quantidade da Ordem de Produção"  },oContainer,,oFont,,,,.T.,,,150,20,,,,,,.T.)
		TGet():New(175,120,{|u| if( PCount() > 0, nQtdOp := u, nQtdOp ) } ,oContainer,60,009,X3Picture('ZCV_QTDOVO'),,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"nQtdOp")
		TSay():New(160,240,{|| "Quantidade Selecionada para Geração"  },oContainer,,oFont,,,,.T.,,,150,20,,,,,,.T.)
		TGet():New(175,240,{|u| if( PCount() > 0, nQtdTl := u, nQtdTl ) } ,oContainer,60,009,X3Picture('ZCV_QTDOVO'),,0,,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F.,,"nQtdTl")
		
		//	MsSelect():New("TRBZCV","OK","",aCpoBro,@lInverte,@cMark,{030,000,150,600}, , , oContainer )           
		oMark := MsSelect():New("TRBZCV","OK","",aCpoBro,@lInverte,@cMark,{030,000,150,600},,, oContainer)
		oMark:bMark := { || Disp() }
		oMark:bAval := {|| FA340Mark("TRBZCV", oMark, cMark, .F.) } 
		oMark:oBrowse:lhasMark    := .T.
		oMark:oBrowse:lCanAllmark := .T.
		oMark:oBrowse:bAllMark := {|| FA340Mark("TRBZCV", oMark, cMark, .T.) }
		
		If nOpc == 1
			obTGerOP := TButton():New(224,526,"Gerar OP"	  ,oDlg,{|| MsgRun("Gerando OPs...","Aguarde...", {|| zADES40GR( cProdOP , cCcusto , nNumOp ) })   } ,055,012,,,,.T.  )
		Else
			obTEstOP := TButton():New(224,526,"Estornar OP"	  ,oDlg,{|| MsgRun("Estornando OPs...","Aguarde...", {|| ADES40GR( cProdOP , cCcusto , nNumOp ) })   } ,055,012,,,,.T.  )
		EndIf
		
		//	oModal:Activate()
		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{|| oDlg:End()},{|| oDlg:End()})

	EndIf

Return()

/*/{Protheus.doc} Static Function ADES40DO(nOpc)
	Chamado: 037647,Gera ordem de produção por integração do SAG
	@type  Static Function
	@author Ricardo Lima
	@since 01/11/2018
	@version 01
/*/
Static Function ADES40DO(nOpc)

	Local oTrb   
	Local cQuery   := ""
	Local lLoteOk  := .t.

	Private aCampos := {}
	
	Aadd( aCampos,{"OK"  		, "C"	 , 2  , 0  } )
	Aadd( aCampos,{"ZCV_FILIAL" , "C" 	 , 2  , 0  } ) // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	Aadd( aCampos,{"ZCV_CODOP"  , "C"    , 15 , 0  } )
	Aadd( aCampos,{"ZCV_CODTIP" , "C"    , 2  , 0  } )
	Aadd( aCampos,{"ZCV_DESCTP" , "C"    , 26 , 0  } ) //Ticket 65674   - ADRIANO SAVOINE - 28/12/2021
	Aadd( aCampos,{"ZCV_CDLOTE" , "C"    , 5  , 0  } )
	Aadd( aCampos,{"ZCN_DESCLT" , "C" 	 , 25 , 0  } )
	Aadd( aCampos,{"ZCV_DATA"   , "D"    , 8  , 0  } )
	Aadd( aCampos,{"ZCV_IDADEO" , "N"    , 6  , 0  } )
	Aadd( aCampos,{"ZCV_QTDOVO" , "N"    , 14 , 0  } )
	Aadd( aCampos,{"ZCV_CODAOJ" , "C"    , 4  , 0  } )
	Aadd( aCampos,{"ZCV_NUMERP" , "C"    , 6  , 0  } )

	// @history Ticket 85787 - 08/03/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	If Select("TRBZCV") > 0
		TRBZCV->( dbCloseArea() )
	EndIf
	//

	oTrb:= FWTemporaryTable():New("TRBZCV", aCampos)
	oTrb:AddIndex("01", {"ZCV_FILIAL","ZCV_CODOP","ZCV_CDLOTE"} )
	oTrb:Create()

	//Pergunte("ADES040P",.F.) // @history Ticket 85787 - 08/03/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	
	//Ticket 65674   - ADRIANO SAVOINE - 28/12/2021
	cQuery := " SELECT ZCV_FILIAL, ZCV_CODOP, ZCV_CODTIP, ZCV_DESCTP, ZCV_CDLOTE, ZCV_DATA, ZCV_IDADEO, ZCV_QTDOVO, ZCV_CODAOJ, ZCV_NUMERP "
	cQuery += " FROM "+RetSqlName("ZCV")+" ZCV (NOLOCK) "
	cQuery += " WHERE ZCV_FILIAL BETWEEN '"+cMVParam03+"' AND '"+cMVParam04+"' " // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	//cQuery += " WHERE ZCV_FILIAL = '"+FWxFilial("ZCV")+"' " 
	cQuery += " AND ZCV_DATA BETWEEN '"+DtoS(dMVParam01)+"' AND '"+DtoS(dMVParam02)+"' "
	
	If nOpc == 1
		cQuery += " AND ZCV_NUMERP = ' ' "
	Else
		//cQuery += " AND ZCV_NUMERP = '"+nNumOp+"' "
		cQuery += " AND ZCV_NUMERP <> ' ' "
	Endif
	
	// @hystory Ticket 67537   - Fer Macieira    - 02/02/2022 - Importação de Ovos - Ordem de Produção
	// @history Ticket 84332   - Jonathan Carvalho - 02/12/2022 - Inclusão do Tipo de Ovo C
	cQuery += " AND ZCV_CODTIP IN ('5','6','7') " 
	cQuery += " AND D_E_L_E_T_ = ' ' "

	// Chamado 048153 || OS 049415 || CONTROLADORIA || ANDRESSA || 45968437 |³ OP DE OVOS - FWNM - 01/04/2019
	cQuery += " ORDER BY ZCV_FILIAL, ZCV_DATA, ZCV_CDLOTE "
	//
	
	// @history Ticket 85787 - 08/03/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	cAliasZCV	:= GetNextAlias()
    DbUseArea(.t., "TOPCONN", TcGenQry(,, cQuery), cAliasZCV, .F., .T.)
	//

	(cAliasZCV)->( dbGotop() )
	Do WHILE (cAliasZCV)->( !EOF() )

        // Chamado n. 049347 || OS 050685 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || SAG VS PROTHEUS || FWNM - 24/05/2019
        lLoteOk := ChkLote((cAliasZCV)->ZCV_FILIAL, Alltrim((cAliasZCV)->ZCV_CDLOTE)) // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
        //lLoteOk := ChkLote(Alltrim((cAliasZCV)->ZCV_CDLOTE))
        
        If lLoteOk

			dbSelectArea("TRBZCV")
			RecLock("TRBZCV", .T.)
				TRBZCV->ZCV_FILIAL := (cAliasZCV)->ZCV_FILIAL // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
				TRBZCV->ZCV_CODOP  := (cAliasZCV)->ZCV_CODOP
				TRBZCV->ZCV_CODTIP := (cAliasZCV)->ZCV_CODTIP
				TRBZCV->ZCV_DESCTP := (cAliasZCV)->ZCV_DESCTP // Ticket 65674   - ADRIANO SAVOINE - 28/12/2021
				TRBZCV->ZCV_CDLOTE := (cAliasZCV)->ZCV_CDLOTE
				TRBZCV->ZCN_DESCLT := Posicione("ZCN",1,(cAliasZCV)->ZCV_FILIAL+PadR((cAliasZCV)->ZCV_CDLOTE,TamSX3("ZCN_LOTE")[1]),"ZCN_DESCLT") // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
				//TRBZCV->ZCN_DESCLT := Posicione("ZCN",1,FWxFilial("ZCN")+PadR((cAliasZCV)->ZCV_CDLOTE,TamSX3("ZCN_LOTE")[1]),"ZCN_DESCLT")
				TRBZCV->ZCV_DATA   := StoD((cAliasZCV)->ZCV_DATA)
				TRBZCV->ZCV_IDADEO := (cAliasZCV)->ZCV_IDADEO
				TRBZCV->ZCV_QTDOVO := (cAliasZCV)->ZCV_QTDOVO
				TRBZCV->ZCV_CODAOJ := (cAliasZCV)->ZCV_CODAOJ
				TRBZCV->ZCV_NUMERP := (cAliasZCV)->ZCV_NUMERP
			MSUnLock()
	
			nQtdOp := nQtdOp + (cAliasZCV)->ZCV_QTDOVO
			nQtdTl := nQtdTl + (cAliasZCV)->ZCV_QTDOVO

		Endif

		(cAliasZCV)->( DbSkip() )

	End

	TRBZCV->( dbGotop() )

Return

/*/{Protheus.doc} Static Function ADES40GR( cProdOP , cCcusto , _NumOp )
	Chamado: 037647,Gera ordem de produção por integração do SAG
	@type  Static Function
	@author Ricardo Lima
	@since 01/11/2018
	@version 01
/*/
Static Function ADES40GR( cProdOP , cCcusto , _NumOp )

	//Variáveis.
	Local aAuto    := {}
	Local nNumOP   := ""
	//Local aVetor   := {}
	//Local aMata650 := {}
	//Local nOpc     := 5
	Local nQtdGrOp := 0
	Local lEstorno := .f.
	Local cFilBkp := cFilAnt // @history ticket 90345 - 17/03/2023 - FERNANDO MACIEIRA - Empenhos OPS de Ovos Fev/23 / Erro estorno OP filial 0D
	
	Private lMsErroAuto := .F.
	
	// Chamado 048153 || OS 049415 || CONTROLADORIA || ANDRESSA || 45968437 || OP DE OVOS - FWNM - 01/04/2019
	// Estorno producao

	TRBZCV->( dbGoTop() )
	While TRBZCV->( !EOF() )
	
		If !Empty(TRBZCV->OK)
	
			dDtOPSAG := TRBZCV->ZCV_DATA
			//nNumOP := AllTrim(TRBZCV->ZCV_CODOP) // Chamado n. 048153 || OS 049415 || CONTROLADORIA || ANDRESSA || 8459 || SAG VS PROTHEUS || FWNM - 11/06/2019
			nNumOP := AllTrim(TRBZCV->ZCV_NUMERP)+"01001" // Chamado n. 048153 || OS 049415 || CONTROLADORIA || ANDRESSA || 8459 || SAG VS PROTHEUS || FWNM - 11/06/2019
			cFilSAG := AllTrim(TRBZCV->ZCV_FILIAL) // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO

			If !Empty(cFilSAG)
				cFilAnt := cFilSAG
			EndIf
			//

			SD3->( dbSetOrder(1) ) // D3_FILIAL+D3_OP+D3_COD+D3_LOCAL                                                                                                                                 
			If SD3->( dbSeek( FWxFilial("SD3")+nNumOP ) ) // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
			//If SD3->( dbSeek( FWxFilial("SD3")+nNumOP ) )
			
				aAuto := {	{"D3_FILIAL"    , SD3->D3_FILIAL	, Nil}, ;
							{"D3_TM"        , SD3->D3_TM		, Nil}, ;
							{"D3_COD"       , SD3->D3_COD       , Nil}, ;
							{"D3_QUANT"     , SD3->D3_QUANT     , Nil}, ;
							{"D3_OP"        , SD3->D3_OP		, Nil}, ;
							{"D3_LOCAL"     , SD3->D3_LOCAL     , Nil}, ;
							{"D3_EMISSAO"   , SD3->D3_EMISSAO   , Nil}, ;
							{"D3_CC"        , SD3->D3_CC        , Nil}, ;
							{"D3_DOC"       , SD3->D3_DOC       , Nil}, ;
							{"D3_PARCTOT"	, SD3->D3_PARCTOT   , Nil}, ;
							{"D3_NUMSEQ"    , SD3->D3_NUMSEQ    , Nil}, ;
							{"D3_CHAVE"     , SD3->D3_CHAVE     , Nil}, ;
							{"INDEX"     	, 4        			, Nil}   }
				
				lMsErroAuto := .F.
				MSExecAuto({|x,y| MATA250(x,y)}, aAuto, 5)  // 3 - Inclusão, 4 - Alteração e 5 - Exclusão
			
				If lMsErroAuto
					MostraErro()
				Else
					lEstorno := .t.
					//ApMsgInfo('Apontamento de Produção: '+nNumOP+', Foi Excluida com sucesso!','Apontamento da Ordem de Produção')
				EndIf
		
			Endif
			// 
	
			// OP
			dbSelectArea("SB1")
			dbSetOrder(1)
			dbSeek(xFilial("SB1") + cProdOP )
			
			aAuto := {  {"C2_FILIAL"  , cFilAnt             , Nil},;
			{"C2_NUM"     , Left(AllTrim(nNumOP),6)     , .F.},;
			{"C2_ITEM"    , "01"		        , Nil},;
			{"C2_SEQUEN"  , "001"				, Nil},;
			{"C2_PRODUTO" , SB1->B1_COD	        , Nil},;
			{"C2_LOCAL"   , SB1->B1_LOCPAD		, Nil},;
			{"C2_CC"      , cCCusto             , Nil},;
			{"C2_QUANT"   , nQtdGrOp            , Nil},;
			{"C2_UM"      , SB1->B1_UM        	, Nil},;
			{"C2_DATPRI"  , dDtOPSAG            , Nil},;
			{"C2_DATPRF"  , dDtOPSAG /*DDATABASE*/       	, Nil},; // Chamado n. 049347 || OS 050685 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || SAG VS PROTHEUS || FWNM - 24/06/2019 
			{"C2_EMISSAO" , dDtOPSAG		    , Nil},;
			{"C2_TPOP"    , "F"                 , Nil},;
			{"C2_REVISAO" , '001'            	, Nil},;
			{"AUTEXPLODE" , "S"                 , Nil}	}
	
			dbSelectArea("SC2")
			dbSetOrder(1)
			If dbSeek( FWxFilial("SC2") + nNumOP ) // Chamado n. 048153 || OS 049415 || CONTROLADORIA || ANDRESSA || 8459 || SAG VS PROTHEUS || FWNM - 11/06/2019

				MSExecAuto({|x,y| MATA650(x,y)}, aAuto, 5)

				If lMsErroAuto
					MostraErro()
				Else
					lEstorno := .t.
					// Chamado n. 048153 || OS 049415 || CONTROLADORIA || ANDRESSA || 8459 || SAG VS PROTHEUS || FWNM - 11/06/2019
					/*
					dbSelectArea("ZCV")
					dbSetOrder(1)
					If dbSeek( FWxFilial("ZCV") + TRBZCV->ZCV_CODOP )
						RecLock("ZCV",.F.)
							ZCV->ZCV_NUMERP := ''
						MSUnLock()
					Endif
					*/
					cSql := " UPDATE " + RetSqlName("ZCV") + " SET ZCV_NUMERP = '' "
					cSql += " WHERE ZCV_FILIAL='"+FWxFilial("ZCV")+"' "
					cSql += " AND ZCV_NUMERP='"+Left(AllTrim(nNumOP),6)+"' "
					cSql += " AND D_E_L_E_T_='' "
						
					nStatus := tcSqlExec(cSql)
						
					If nStatus < 0
						msgAlert("Estorno da OP foi realizada porém o número permaneceu gravado na tabela ZCV! Envie o erro que será mostrado na próxima tela ao TI... ")
						MessageBox(tcSqlError(),"",16)
					EndIf
					
				Endif

			EndIf

		EndIf
		
		TRBZCV->(dbSkip())
	End

	If lEstorno
		ApMsgInfo('Ordem de Produção - Excluídas com sucesso!','Ordem de Produção')
	Else
		msgAlert('Nenhuma OP foi Excluída!','Ordem de Produção')
	EndIf

	ADES40DO(2)
	
	oMark:oBrowse:Refresh(.T.)
	oDlg:End()

	// @history ticket 90345 - 17/03/2023 - FERNANDO MACIEIRA - Empenhos OPS de Ovos Fev/23 / Erro estorno OP filial 0D
	cFilAnt := cFilBkp
	//

Return

/*/{Protheus.doc} Static Function MontaPerg()
	Chamado: 037647,Gera ordem de produção por integração do SAG
	@type  Static Function
	@author Ricardo Lima
	@since 01/11/2018
	@version 01
/*/
/*
Static Function MontaPerg()

	//Variáveis.
	Private bValid := Nil
	Private cF3	   := Nil
	Private cSXG   := Nil
	Private cPyme  := Nil
	Private cPerg  := "ADES040P"

	u_xPutSx1(cPerg,'01','Dt Produção De  ?','Dt Produção De  ?','Dt Produção De  ?','mv_ch1','D',8,0,0,'G',bValid,cF3,cSXG,cPyme,'MV_PAR01')
	u_xPutSx1(cPerg,'02','Dt Produção Ate ?','Dt Produção Ate ?','Dt Produção Ate ?','mv_ch2','D',8,0,0,'G',bValid,cF3,cSXG,cPyme,'MV_PAR02')

Return Nil
*/

/*/{Protheus.doc} Static Function zADES40GR( cProdOP , cCcusto , _NumOp )
	Chamado 048153 || OS 049415 || CONTROLADORIA || ANDRESSA || 45968437 |³ OP DE OVOS - FWNM - 01/04/2019
	@type  Static Function
	@author FWNM
	@since 01/04/2020
	@version 01
/*/
Static Function zADES40GR( cProdOP , cCcusto , _NumOp )

	Local aAuto    := {}
	Local nNumOP   := ""
	Local nQtdGrOp := 0
	Local cTM      := Alltrim(GetMv('MV_XTMPRD',.F., "010"))   		//Tm para movimentação
	Local cLotes   := ""	
	
	Local cFilBkp := cFilAnt

	Private lMsErroAuto := .F.

	cTimeIni := Time()
	
	GrvMark(1)
	
	//Everson - 07/08/2020. Chamado 060348.
	If Select("D_DDOP") > 0
		D_DDOP->( dbCloseArea() )
	EndIf

	cQuery := " SELECT ZCV_FILIAL, ZCV_DATA, ZCV_CDLOTE, SUM(ZCV_QTDOVO) TT_ZCV_QTDOVO "
	cQuery += " FROM " + RetSqlName("ZCV") + " ZCV (NOLOCK) "
	cQuery += " WHERE ZCV_FILIAL BETWEEN '"+cMVParam03+"' AND '"+cMVParam04+"' " // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	cQuery += " AND ZCV_DATA BETWEEN '"+DtoS(dMVParam01)+"' AND '"+DtoS(dMVParam02)+"' " // @history ticket 93215 - 04/05/2023 - Fernando Macieira - Erro processamento de OP de Ovos
	cQuery += " AND ZCV_NUMERP = ' ' "
	cQuery += " AND ZCV_MARKOK <> ' ' "
	cQuery += " AND D_E_L_E_T_ = ' ' "
	cQuery += " GROUP BY ZCV_FILIAL, ZCV_DATA, ZCV_CDLOTE "
	cQuery += " ORDER BY 1,2,3 "
	
	tcQuery cQuery new alias "D_DDOP" //Everson - 07/08/2020. Chamado 060348.
	
	aTamSX3 := TamSX3("ZCV_DATA")
	tcSetField("D_DDOP", "ZCV_DATA", aTamSX3[3], aTamSX3[1], aTamSX3[2]) //Everson - 07/08/2020. Chamado 060348.
	
	aTamSX3 := TamSX3("ZCV_QTDOVO")
	tcSetField("D_DDOP", "ZCV_QTDOVO", aTamSX3[3], aTamSX3[1], aTamSX3[2])

	// Processa OPs SAG por data+lote
	D_DDOP->( dbGoTop() )
	Do While D_DDOP->( !EOF() ) //Everson - 07/08/2020. Chamado 060348.
	
		// @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
		cFilSAG := AllTrim(D_DDOP->ZCV_FILIAL) // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
		
		If !Empty(cFilSAG)
			cFilAnt := cFilSAG
		EndIf
		//

		//Begin Transaction
	
		nQtdGrOp := D_DDOP->TT_ZCV_QTDOVO //Everson - 07/08/2020. Chamado 060348.
	
		If nQtdGrOp > 0
			
			nNumOP := GETNUMSC2()
			dbSelectArea("SC2")
			dbSetOrder(1)
			While dbSeek( FWxFilial("SC2") + nNumOP + '01001' )
				ConOut('o Numero de OP: '+nNumOP+', Já existe, o sistema vai gerar um novo numero')
				nNumOP := GETNUMSC2()
				Loop
			End
		Endif
		//Everson - 07/08/2020. Chamado 060348.
		// Posiciono ZCN - Cadastro Lote Recria
		ZCN->( dbSetOrder(1) ) // ZCN_FILIAL + ZCN_LOTE
		ZCN->( dbSeek( FWxFilial("ZCN")+PadR(D_DDOP->ZCV_CDLOTE,TamSX3("ZCN_LOTE")[1]) ) )
		
		cObs := AllTrim( AllTrim(ZCN->ZCN_DESCLT) + " OP SAG AGLUTINADA DATA+LOTE" )
		//Everson - 07/08/2020. Chamado 060348.
		nQtdGrOp := D_DDOP->TT_ZCV_QTDOVO
		dDtOPSAG := D_DDOP->ZCV_DATA
		cArmazem := PadR(ZCN->ZCN_ARMAZE,TamSX3("NNR_CODIGO")[1])
		
		// Posiciono SB1
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1") + cProdOP )
		
		aAuto := {  {"C2_FILIAL"  , cFilAnt, Nil},;
		{"C2_NUM"     , nNumOP	            , .F.},;
		{"C2_ITEM"    , "01"		        , Nil},;
		{"C2_SEQUEN"  , "001"				, Nil},;
		{"C2_PRODUTO" , SB1->B1_COD	        , Nil},;
		{"C2_LOCAL"   , cArmazem			, Nil},;
		{"C2_CC"      , ZCN->ZCN_CENTRO     , Nil},;
		{"C2_QUANT"   , nQtdGrOp            , Nil},;
		{"C2_UM"      , SB1->B1_UM        	, Nil},;
		{"C2_DATPRI"  , dDtOPSAG    	    , Nil},;
		{"C2_DATPRF"  , dDtOPSAG /*DDATABASE*/       	, Nil},; // Chamado n. 049347 || OS 050685 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || SAG VS PROTHEUS || FWNM - 24/06/2019 
		{"C2_EMISSAO" , dDtOPSAG		    , Nil},;
		{"C2_TPOP"    , "F"                 , Nil},;
		{"C2_REVISAO" , ZCN->ZCN_REVISA   	, Nil},;
		{"C2_OBS"     , cObs            	, Nil},;
		{"AUTEXPLODE" , "S"                 , Nil}	}
		
		// Ordem de Producao
		If nQtdGrOp > 0
			MSExecAuto({|x,y| MATA650(x,y)}, aAuto, 3)
		Endif

		// @history ticket 90345 - Fernando Macieira - 17/03/2023 - Empenhos OPS de Ovos Fev/23 / Erro estorno OP filial 0D
		SD4->( dbSetOrder(2) ) // D4_FILIAL, D4_OP, D4_COD, D4_LOCAL, R_E_C_N_O_, D_E_L_E_T_
		If SD4->( !dbSeek(FWxFilial("SD4")+nNumOP) )
			lEstorno := .t.
			Alert("ATENCAO! Nenhum empenho foi gerado para a OP " + nNumOP)
			DisarmTransaction() 
			Return
		EndIf
		//

		If lMsErroAuto
			MostraErro()
			
			If msgYesNo("Deseja interromper a geração das OPs?")
				DisarmTransaction()
				Return
			EndIf

		Else

			If nQtdGrOp > 0

				cSql := " UPDATE " + RetSqlName("ZCV") + " SET ZCV_NUMERP = '"+nNumOP+"' "
				cSql += " WHERE ZCV_FILIAL='"+FWxFilial("ZCV")+"' "
				cSql += " AND ZCV_DATA='"+DtoS(D_DDOP->ZCV_DATA)+"' "
				cSql += " AND ZCV_CDLOTE='"+D_DDOP->ZCV_CDLOTE+"' "
				cSql += " AND ZCV_NUMERP = ' ' "
				cSql += " AND ZCV_MARKOK <> ' ' "
				cSql += " AND D_E_L_E_T_='' "
					
				nStatus := tcSqlExec(cSql)
					
				If nStatus < 0
					msgAlert("Numero da OP gerada não foi gravada na tabela ZCV! Envie o erro que será mostrado na próxima tela ao TI... ")
					MessageBox(tcSqlError(),"",16)
				EndIf
							
				//ApMsgInfo('Ordem de Produção: '+nNumOP+', na data ' + DtoC(D_DDOP->ZCV_DATA) + ' gerada com sucesso!','Lote ' + D_DDOP->ZCV_CDLOTE)
				
				cLotes := cLotes + Chr(13) + Chr(10) + D_DDOP->ZCV_CDLOTE + " - " + Posicione("ZCN",1,FWxFilial("ZCN")+PadR(D_DDOP->ZCV_CDLOTE,TamSX3("ZCN_LOTE")[1]),"ZCN_DESCLT") + " - OP Protheus: " + nNumOP 

			EndIf

		Endif

		// Aponto Producao
		SC2->( dbSetOrder(1) )  // C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD                                                                                                                   
		If SC2->( dbSeek( FWxFilial("SC2") + nNumOP ) )
	
			aAuto := {	{"D3_FILIAL"       , cFilAnt , Nil}, ;
						{"D3_OP"           , SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) , Nil}, ;
						{"D3_TM"           , cTM				                        , Nil}, ;
						{"D3_COD"          , SC2->C2_PRODUTO                            , Nil}, ;
						{"D3_QUANT"        , SC2->C2_QUANT-SC2->C2_QUJE                 , Nil}, ;
						{"D3_LOCAL"        , SC2->C2_LOCAL                              , Nil}, ;
						{"D3_EMISSAO"      , SC2->C2_EMISSAO  /*SC2->C2_DATPRF*/        , Nil}, ; // Chamado n. 049347 || OS 051224 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || OP SAG X PROTHEUS - FWNM - 18/06/2019 
						{"D3_CC"           , SC2->C2_CC                                 , Nil}, ;
						{"D3_OBSERVA"      , cObs            							, Nil}, ;
						{"D3_OBS"          , cObs            							, Nil}, ;
						{"D3_RECORI"       , StrZero(SC2->(Recno()),10)        		    , Nil}}
			
			lMsErroAuto := .F.
		
			MSExecAuto({|x,y| MATA250(x,y)}, aAuto, 3)  // 3 - Inclusão, 4 - Alteração e 5 - Exclusão
			
			If lMsErroAuto
				MostraErro()

				If msgYesNo("Deseja interromper o apontamento das OPs?")
					DisarmTransaction()
					Return
				EndIf

			EndIf
	
		EndIf
	
		//End Transaction			

		D_DDOP->( dbSkip() ) //Everson - 07/08/2020. Chamado 060348.

	EndDo
	
	If Select("D_DDOP") > 0 //Everson - 07/08/2020. Chamado 060348.
		D_DDOP->( dbCloseArea() )
	EndIf
	
	GrvMark(2)
	
	cTimeFim := Time()
	
	Aviso("ADEST040P-02", "OPs e apontamentos gerados com sucesso!" + chr(13) + chr(10) + " Tempo Processamento: " + Elaptime(cTimeIni,cTimeFim) + chr(13) + chr(10) + "Lotes: " + cLotes, {"OK"}, 3)

	ADES40DO(1)
	
	oMark:oBrowse:Refresh(.T.)
	oDlg:End()

	// @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	cFilAnt := cFilBkp
	//
	
Return Nil

/*/{Protheus.doc} Static Function yADES40GR( cProdOP , cCcusto , _NumOp )
	Chamado 048153 || OS 049415 || CONTROLADORIA || ANDRESSA || 45968437 |³ OP DE OVOS - FWNM - 01/04/2019
	@type  Static Function
	@author FWNM
	@since 01/04/2020
	@version 01
/*/
Static Function yADES40GR( cProdOP , cCcusto , _NumOp )

	//Variáveis.
	Local aAuto    := {}
	Local nNumOP   := ""
	Local nQtdGrOp := 0
	Local cTM      := Alltrim(GetMv('MV_XTMPRD',.F., "010"))   		//Tm para movimentação	

	Local cFilBkp := cFilAnt
	
	Private lMsErroAuto := .F.

    cTimeIni := Time()
    
	// Processo OPs SAG
	Do While TRBZCV->(!Eof())
		
		// @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
		cFilSAG := AllTrim(TRBZCV->ZCV_FILIAL) // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	
		If !Empty(cFilSAG)
			cFilAnt := cFilSAG
		EndIf
		//

		//Begin Transaction
		
		// Numero da proxima OP
		nNumOP := GETNUMSC2()
		dbSelectArea("SC2")
		dbSetOrder(1)
		While dbSeek( FWxFilial("SC2") + nNumOP + '01001' )
			ConOut('o Numero de OP: '+nNumOP+', Já existe, o sistema vai gerar um novo numero')
			nNumOP := GETNUMSC2()
			Loop
		End
	
		// Posiciono ZCN - Cadastro Lote Recria
		ZCN->( dbSetOrder(1) ) // ZCN_FILIAL + ZCN_LOTE
		ZCN->( dbSeek( FWxFilial("ZCN")+PadR(TRBZCV->ZCV_CDLOTE,TamSX3("ZCN_LOTE")[1]) ) )
		
		cObs := AllTrim( "OP SAG " + AllTrim(TRBZCV->ZCV_CODOP) + " - LOTE " + AllTrim(ZCN->ZCN_DESCLT) )

		nQtdGrOp := TRBZCV->ZCV_QTDOVO
		dDtOPSAG := TRBZCV->ZCV_DATA
		cArmazem := PadR(ZCN->ZCN_ARMAZE,TamSX3("NNR_CODIGO")[1])

		// Posiciona SB1
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial("SB1") + cProdOP )
		
		aAuto := {  {"C2_FILIAL"  , cFilAnt             , Nil},;
		{"C2_NUM"     , nNumOP	            , .F.},;
		{"C2_ITEM"    , "01"		        , Nil},;
		{"C2_SEQUEN"  , "001"				, Nil},;
		{"C2_PRODUTO" , SB1->B1_COD	        , Nil},;
		{"C2_LOCAL"   , cArmazem			, Nil},;
		{"C2_CC"      , ZCN->ZCN_CENTRO     , Nil},;
		{"C2_QUANT"   , nQtdGrOp            , Nil},;
		{"C2_UM"      , SB1->B1_UM        	, Nil},;
		{"C2_DATPRI"  , dDtOPSAG            , Nil},;
		{"C2_DATPRF"  , dDtOPSAG /*DDATABASE*/       	, Nil},; // Chamado n. 049347 || OS 050685 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || SAG VS PROTHEUS || FWNM - 24/06/2019 
		{"C2_EMISSAO" , dDtOPSAG		    , Nil},;
		{"C2_TPOP"    , "F"                 , Nil},;
		{"C2_REVISAO" , ZCN->ZCN_REVISA   	, Nil},;
		{"C2_OBS"     , cObs            	, Nil},;
		{"AUTEXPLODE" , "S"                 , Nil}	}
	
		// Ordem de Producao
		If nQtdGrOp > 0
			MSExecAuto({|x,y| MATA650(x,y)}, aAuto, 3)
		Endif
	
		// @history ticket 90345 - Fernando Macieira - 17/03/2023 - Empenhos OPS de Ovos Fev/23 / Erro estorno OP filial 0D
		SD4->( dbSetOrder(2) ) // D4_FILIAL, D4_OP, D4_COD, D4_LOCAL, R_E_C_N_O_, D_E_L_E_T_
		If SD4->( !dbSeek(FWxFilial("SD4")+nNumOP) )
			lEstorno := .t.
			Alert("ATENCAO! Nenhum empenho foi gerado para a OP " + nNumOP)
			DisarmTransaction() 
			Return
		EndIf
		//

		If lMsErroAuto
		
			MostraErro()
			
			If msgYesNo("Deseja interromper a geração das OPs?")
				DisarmTransaction()
				//Return
			EndIf

		Else
		
			If nQtdGrOp > 0
		
				dbSelectArea("ZCV")
				dbSetOrder(1)
				If dbSeek( FWxFilial("ZCV") + TRBZCV->ZCV_CODOP )
					RecLock("ZCV",.F.)
						ZCV->ZCV_NUMERP := nNumOP
					MSUnLock()
				Endif

			EndIf

		Endif

		// Aponto Producao
		SC2->( dbSetOrder(1) )  // C2_FILIAL+C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD                                                                                                                   
		If SC2->( dbSeek( FWxFilial("SC2") + nNumOP ) )
	
			aAuto := {	{"D3_FILIAL"       , cFilAnt , Nil}, ;
			        	{"D3_OP"           , SC2->(C2_NUM+C2_ITEM+C2_SEQUEN+C2_ITEMGRD) , Nil}, ;
						{"D3_TM"           , cTM				                        , Nil}, ;
						{"D3_COD"          , SC2->C2_PRODUTO                            , Nil}, ;
						{"D3_QUANT"        , SC2->C2_QUANT-SC2->C2_QUJE                 , Nil}, ;
						{"D3_LOCAL"        , SC2->C2_LOCAL                              , Nil}, ;
						{"D3_EMISSAO"      , SC2->C2_DATPRF	                            , Nil}, ;
						{"D3_CC"           , SC2->C2_CC                                 , Nil}, ;
						{"D3_OBSERVA"      , cObs            							, Nil}, ;
						{"D3_OBS"          , cObs            							, Nil}, ;
						{"D3_RECORI"       , StrZero(SC2->(Recno()),10)        		    , Nil}}
			
			lMsErroAuto := .F.
		
			MSExecAuto({|x,y| MATA250(x,y)}, aAuto, 3)  // 3 - Inclusão, 4 - Alteração e 5 - Exclusão
			
			If lMsErroAuto
				MostraErro()

				If msgYesNo("Deseja interromper o apontamento das OPs?")
					DisarmTransaction()
					//Return
				EndIf

			EndIf
	
		EndIf
	
		//End Transaction

		TRBZCV->(dbSkip())
	
	EndDo
	
	cTimeFim := Time()
	
	Aviso("ADEST040P-01", "OPs e apontamentos gerados com sucesso!" + chr(13) + chr(10) + " Tempo Processamento: " + Elaptime(cTimeIni,cTimeFim), {"OK"}, 3)

	// @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	cFilAnt := cFilBkp
	//

Return Nil

/*/{Protheus.doc} User Function BRWADEST040()
	Usado no campo virtual do campo ZCV_DESCLT
	@type  Static Function
	@author FWNM
	@since 03/06/2020
	@version 01
/*/
User Function BRWADEST040()
Return Posicione("ZCN",1,FWxFilial("ZCN")+PadR(ZCV->ZCV_CDLOTE,TamSX3("ZCN_LOTE")[1]),"ZCN_DESCLT")

/*/{Protheus.doc} Static Function Disp()
	Funcao executada ao Marcar/Desmarcar um registro.
	@type  Static Function
	@author FWNM
	@since 03/06/2020
	@version 01
/*/
Static Function Disp()

	RecLock("TRBZCV", .F.)
		If Marked("OK")
			TRBZCV->OK := cMark
		Else	
			TRBZCV->OK := ""
		Endif
	TRBZCV->( msUnLock() )

	oMark:oBrowse:Refresh()

Return

/*/{Protheus.doc} Static Function ChkLote(cCodLt)
	Checa se lote pode ser importado.  
	@type  Static Function
	@author FWNM
	@since 03/06/2020
	@version 01
/*/
Static Function ChkLote(cFilGrj, cCodLt)

	Local lOk    := .t.
	Local cQuery := ""

    // Chamado n. 049347 || OS 050685 || CONTROLADORIA || DANIELLE_MEIRA || 8459 || SAG VS PROTHEUS || FWNM - 24/05/2019
    cDescLt  := GetMV("MV_#LOTSAG",,"COBB")
    //
	
	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf

	cQuery := " SELECT COUNT(1) TT "
	cQuery += " FROM " + RetSqlName("ZCN") + " (NOLOCK) "
	cQuery += " WHERE ZCN_FILIAL='"+cFilGrj+"' " //     @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
	cQuery += " AND ZCN_LOTE='"+cCodLt+"' "
	cQuery += " AND ZCN_DESCLT LIKE '%"+cDescLt+"%' "
	cQuery += " AND D_E_L_E_T_='' "
	
	tcquery cquery new alias "Work"
	
	Work->( dbGoTop() )
	
	If Work->TT >= 1
		lOk := .f. // Lote nao autorizado a importar
	EndIf

	If Select("Work") > 0
		Work->( dbCloseArea() )
	EndIf

Return lOk

/*/{Protheus.doc} Static Function GrvMark(nOpc)
	Checa se lote pode ser importado.  
	@type  Static Function
	@author FWNM
	@since 03/06/2020
	@version 01
/*/
Static Function GrvMark(nOpc)

	Local aArea    := GetArea()
	Local aAreaZCV := ZCV->( GetArea() )
	
	If nOpc == 1

		cSql := " UPDATE " + RetSqlName("ZCV") + " SET ZCV_MARKOK = ' ' "
		cSql += " WHERE ZCV_FILIAL BETWEEN '"+cMVParam03+"' AND '"+cMVParam04+"' " // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
		//cSql += " WHERE ZCV_FILIAL='"+FWxFilial("ZCV")+"' "

		//cSql += " AND ZCV_DATA BETWEEN '"+DtoS(MV_PAR01)+"' AND '"+DtoS(MV_PAR02)+"' "
		cSql += " AND ZCV_DATA BETWEEN '"+DtoS(dMVParam01)+"' AND '"+DtoS(dMVParam02)+"' " // @history ticket 93215 - 04/05/2023 - Fernando Macieira - Erro processamento de OP de Ovos

		cSql += " AND ZCV_MARKOK <> ' ' "
		cSql += " AND D_E_L_E_T_='' "
						
		tcSqlExec(cSql)
	
	EndIf
	
	TRBZCV->( dbGoTop() )
	Do While TRBZCV->( !EOF() )
	
		If !Empty(TRBZCV->OK)
			ZCV->( dbSetOrder(1) ) // ZCV_FILIAL+ZCV_CODOP                                                                                                                                            
			If ZCV->( dbSeek( TRBZCV->ZCV_FILIAL + TRBZCV->ZCV_CODOP ) ) // @history Ticket 85787 - 13/02/2023 - Fernando Macieira - OPERAÇÃO NOVA MATRIZES - APONTAMENTO DE PRODUÇÃO
			//If ZCV->( dbSeek( FWxFilial("ZCV") + TRBZCV->ZCV_CODOP ) )
				RecLock( "ZCV", .f. )
					If nOpc == 1
						ZCV->ZCV_MARKOK := TRBZCV->OK
					Else
						ZCV->ZCV_MARKOK := ""
					EndIf
				ZCV->( msUnLock() )
			EndIf
		EndIf
		
		TRBZCV->( dbSkip() )

	EndDo
	
	RestArea( aArea )
	RestArea( aAreaZCV )
	
Return

/*/{Protheus.doc} nomeStaticFunction
	Função para marcar e desmarcar
	@type  Static Function
	@author Sivaldo Oliveira
	@since 03/11/2018
	@version 01
	/*/
Static Function FA340Mark(cTblTmp As Character, oMark As Object, cMarca, lTodos)

	Local lRet As Logical
	Local nRec As Numeric
	
	Default cTblTmp := ""
	Default oMark   := Nil
	Default cMarca  := "" 
	Default lTodos  := .F.
	
	//Inicializa variáveis
	nRec := 0
	lRet := !Empty(cTblTmp) .And. oMark != Nil .And. !Empty(cMarca) 	
	
	If lRet

		(cTblTmp)->(DbSetOrder(1))
		
		If lTodos
			(cTblTmp)->(DbGotop())	
		EndIf
		
		nRec := (cTblTmp)->(Recno()) 
		
		While (cTblTmp)->(!Eof())
			RecLock(cTblTmp)
			
			If (cTblTmp)->OK == cMarca
				(cTblTmp)->OK := ""	
			Else
				(cTblTmp)->OK := cMarca
			EndIf
			
			(cTblTmp)->(MsUnlock())
			
			If lTodos
				(cTblTmp)->(DbSkip())	
			Else
				Exit
			EndIf
		EndDo
		
		(cTblTmp)->(DbGoto(nRec))

		oMark:oBrowse:Refresh(.T.)

	EndIf

Return Nil 
