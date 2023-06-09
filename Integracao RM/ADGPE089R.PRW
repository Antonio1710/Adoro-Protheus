#INCLUDE "totvs.ch"
#INCLUDE "TOPCONN.CH"
#Include "Colors.ch"

/*/{Protheus.doc} User Function ADGPE089R()
  Relat�rio de Demanda de Uniformes por departamento/se��o.
  @type tkt -  16833
  @author Leonardo P. Monteiro
  @since 03/02/2022
  @history Ticket 16833 - Leonardo P. Monteiro - 03/02/2022 - Desenvolvimento.
  @history Ticket: 70990 - ADRIANO SAVOINE - 11/04/2022 - Ajuste na Variavel para gerar relatorio.
/*/

User Function ADGPE089R()
	local cTitulo         	:= "RELA��O DE ARM�RIOS POR COLABORADOR"

	Private oReport
	private cPerg         	:= "ADGPE089R"
	private cConcilDe     	:= ""
	private cConcilAte		:= ""
	private dDataDe       	:= ctod("")
	private dDataAte      	:= ctod("")
	Private cAlias    		:= ""
	Private _nOrdem     	:= 2 //Ordem
	Private lAuto			:= .F.
	Private nLin			:= 0
	
	Private oFont10n 		:= TFont():New("Times New Roman",10,10,.T.,.F.,5,.T.,5,.T.,.F.)
	Private oFont12n 		:= TFont():New("Times New Roman",12,12,.T.,.F.,5,.T.,5,.T.,.F.)
	Private oFont14n 		:= TFont():New("Times New Roman",14,14,.T.,.F.,5,.T.,5,.T.,.F.)

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'RELAT�RIO DE DEMANDA DE UNIFORMES POR DEPARTAMENTO/SE��O')
	
	oFont10n:Bold := .f.
	oFont12n:Bold := .f.
	oFont14n:Bold := .f.

	lPerguntas := Pergunte("ADGPE089R")

	if lPerguntas

		cAlias := GetNextAlias()

		oReport := TReport():New(cPerg,cTitulo,{|| Pergunte("ADGPE089R") },{|oReport| PrintReport(oReport) })
		oReport:SetTitle(cTitulo)

		oReport:SetLandScape(.T.)

		//Define as se��es do relat�rio
		ReportDef(oReport)

		//Dialogo do TReport
		oReport:PrintDialog()
	endif
Return

/*/{Protheus.doc} ReportDef
  (long_description)
  @type  Static Function
  @author user
  @since 20/05/2021
  @version version
  @param param_name, param_type, param_descr
  @return return_var, return_type, return_description
  @example
  (examples)
  @see (links_or_references)
  /*/
Static Function ReportDef(oReport)

	oSection1 := TRSection():New(oReport,"Colaboradores Desligados")
	TRCell():New(oSection1,"ZI1_MAT"    			,cAlias,"Matr�cula" 	,"@!"               	,015,  ,,"LEFT",,"LEFT",,,,,,,) //01
	TRCell():New(oSection1,"ZI1_NOME"    			,cAlias,"Colaborador" 	,"@!"               	,060,  ,,"LEFT",,"LEFT",,,,,,,) //02
	TRCell():New(oSection1,"ZHL_CODIGO"            	,cAlias,"C�d Arm."    	,"@!"               	,007,  ,,"CENTER",,"CENTER",,,,,,,) //03
	TRCell():New(oSection1,"ZHL_DESCRI"            	,cAlias,"Arm�rio"    	,"@!"               	,040,  ,,"LEFT",,"LEFT",,,,,,,) //04
	TRCell():New(oSection1,"ZHL_VESTIA"            	,cAlias,"Vesti�rio"    	,"@!"               	,004,  ,,"CENTER",,"CENTER",,,,,,,) //03
	
	oBreak1 := TRBreak():New(oSection1,{|| },"Total Desligados",.F.)
	
	TRFunction():New(oSection1:Cell("ZHL_VESTIA"),/*cId*/,"COUNT",oBreak1,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
	oSection1:SetTotalText({|| "Total Desligados" })

	oSection2 := TRSection():New(oReport,"Colaboradores Desligados")
	TRCell():New(oSection2,"ZI1_MAT"    			,cAlias,"Matr�cula" 	,"@!"               	,015,  ,,"LEFT",,"LEFT",,,,,,,) //01
	TRCell():New(oSection2,"ZI1_NOME"    			,cAlias,"Colaborador" 	,"@!"               	,060,  ,,"LEFT",,"LEFT",,,,,,,) //02
	TRCell():New(oSection2,"ZHL_CODIGO"            	,cAlias,"C�d Arm."    	,"@!"               	,007,  ,,"CENTER",,"CENTER",,,,,,,) //03
	TRCell():New(oSection2,"ZHL_DESCRI"            	,cAlias,"Arm�rio"    	,"@!"               	,040,  ,,"LEFT",,"LEFT",,,,,,,) //04
	TRCell():New(oSection2,"ZHL_VESTIA"            	,cAlias,"Vesti�rio"    	,"@!"               	,004,  ,,"CENTER",,"CENTER",,,,,,,) //03
	
	oBreak2 := TRBreak():New(oSection2,{|| },"Total Ativos",.F.)
	
	TRFunction():New(oSection2:Cell("ZHL_VESTIA"),/*cId*/,"COUNT",oBreak2,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
	
	oSection2:SetTotalText({|| "Total Ativos" })

	oSection3 := TRSection():New(oReport,"Arm�rios Livres")
	TRCell():New(oSection3,"ZI1_MAT"    			,cAlias,"Matr�cula" 	,"@!"               	,015,  ,,"LEFT",,"LEFT",,,,,,,) //01
	TRCell():New(oSection3,"ZI1_NOME"    			,cAlias,"Colaborador" 	,"@!"               	,060,  ,,"LEFT",,"LEFT",,,,,,,) //02
	TRCell():New(oSection3,"ZHL_CODIGO"            	,cAlias,"C�d Arm."    	,"@!"               	,007,  ,,"CENTER",,"CENTER",,,,,,,) //03
	TRCell():New(oSection3,"ZHL_DESCRI"            	,cAlias,"Arm�rio"    	,"@!"               	,040,  ,,"LEFT",,"LEFT",,,,,,,) //04
	TRCell():New(oSection3,"ZHL_VESTIA"            	,cAlias,"Vesti�rio"    	,"@!"               	,004,  ,,"CENTER",,"CENTER",,,,,,,) //03
	
	oBreak3 := TRBreak():New(oSection3,{|| },"Total Livres",.F.)
	
	TRFunction():New(oSection3:Cell("ZHL_VESTIA"),/*cId*/,"COUNT",oBreak3,/*cTitle*/,/*cPicture*/,/*uFormula*/,.F./*lEndSection*/,.F./*lEndReport*/,/*lEndPage*/)
	
	oSection3:SetTotalText({|| "Total Livres" })

Return

/*/{Protheus.doc} PrintReport
  (long_description)
  @type  Static Function
  @author user
  @since 20/05/2021
  @version version
  @param param_name, param_type, param_descr
  @return return_var, return_type, return_description
  @example
  (examples)
  @see (links_or_references)
  /*/
Static Function PrintReport(oReport)
	local oSection1 := NIL
	local oSection2 := NIL

	oSection1 := oReport:Section(1)
	oSection2 := oReport:Section(2)
	oSection3 := oReport:Section(3)

	//------------------------------------------
	// Imprime os Desligados
	//------------------------------------------
	if MV_PAR04 == 1
		cQuery := getSQL(1)

		TcQuery cQuery ALIAS "QREL" NEW

		Count To nRegs
		
		QREL->(Dbgotop())

		oReport:SetMeter(nRegs)

		if QREL->(!EOF())

			oSection1:Init()

			while QREL->(!EOF())

				oReport:IncMeter()
				
				oSection1:Cell("ZI1_MAT"   		):SetValue(QREL->ZI1_MAT) // 01
				oSection1:Cell("ZI1_NOME"   	):SetValue(QREL->ZI1_NOME) // 02
				oSection1:Cell("ZHL_CODIGO" 	):SetValue(QREL->ZHL_CODIGO) // 03
				oSection1:Cell("ZHL_DESCRI" 	):SetValue(QREL->ZHL_DESCRI) // 04
				oSection1:Cell("ZHL_VESTIA" 	):SetValue(iif(QREL->ZHL_VESTIA=="M","Masculino","Feminino")) // 05
					
				oSection1:PrintLine()
				
				
				oReport:IncMeter()

				QREL->(Dbskip())	
			enddo

			oSection1:Finish()

		endif

		QREL->(DBCLOSEAREA())

	endif

	//------------------------------------------
	// Imprime os ativos
	//------------------------------------------
	cQuery := getSQL(2)

	TcQuery cQuery ALIAS "QREL" NEW

	Count To nRegs
	
	QREL->(Dbgotop())

	oReport:SetMeter(nRegs)

	if QREL->(!EOF())

		oSection2:Init()

		while QREL->(!EOF())

			oReport:IncMeter()
			
			oSection2:Cell("ZI1_MAT"   		):SetValue(QREL->ZI1_MAT) // 01
			oSection2:Cell("ZI1_NOME"   	):SetValue(QREL->ZI1_NOME) // 02
			oSection2:Cell("ZHL_CODIGO" 	):SetValue(QREL->ZHL_CODIGO) // 03
			oSection2:Cell("ZHL_DESCRI" 	):SetValue(QREL->ZHL_DESCRI) // 04
			oSection2:Cell("ZHL_VESTIA" 	):SetValue(iif(QREL->ZHL_VESTIA=="M","Masculino","Feminino")) // 05
				
			oSection2:PrintLine()
			
			oReport:IncMeter()

			QREL->(Dbskip())	
		enddo

	endif

	oSection2:Finish()

	QREL->(DBCLOSEAREA())

	//------------------------------------------
	// Imprime arm�rios livres
	//------------------------------------------
	if MV_PAR05 == 1
		cQuery := getSQL(3)

		TcQuery cQuery ALIAS "QREL" NEW

		Count To nRegs
		
		QREL->(Dbgotop())

		oReport:SetMeter(nRegs)

		if QREL->(!EOF())

			oSection3:Init()

			while QREL->(!EOF())

				oReport:IncMeter()
				
				oSection3:Cell("ZI1_MAT"   		):SetValue(QREL->ZI1_MAT) // 01
				oSection3:Cell("ZI1_NOME"   	):SetValue(QREL->ZI1_NOME) // 02
				oSection3:Cell("ZHL_CODIGO" 	):SetValue(QREL->ZHL_CODIGO) // 03
				oSection3:Cell("ZHL_DESCRI" 	):SetValue(QREL->ZHL_DESCRI) // 04
				oSection3:Cell("ZHL_VESTIA" 	):SetValue(iif(QREL->ZHL_VESTIA=="M","Masculino","Feminino")) // 05
					
				oSection3:PrintLine()
				
				oReport:IncMeter()

				QREL->(Dbskip())	
			enddo
			QREL->(DBCLOSEAREA())
		endif

		oSection3:Finish()
	ENDIF

	//QREL->(DBCLOSEAREA())

Return

Static Function getSql(nTipo)
	local cQuery  	:= ""
	local CEOL		:= Chr(13)+chr(10)

	if nTipo == 1 .or. nTipo == 2
		cQuery := " SELECT ZI1.ZI1_MAT, ZI1.ZI1_NOME, ZHL_CODIGO, ZHL_DESCRI, ZHL_VESTIA  "+CEOL
		cQuery += " FROM  "+ retsqlname("ZI1") +" ZI1 INNER JOIN "+ retsqlname("ZHL") +" ZHL ON ZI1.D_E_L_E_T_='' AND ZHL.D_E_L_E_T_='' AND ZI1.ZI1_CODZHL=ZHL.ZHL_CODIGO "
		cQuery += " WHERE ZI1.D_E_L_E_T_='' "+CEOL
		cQuery += " AND ZI1.ZI1_CODZHL BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "

		if MV_PAR03 == 2
			cQuery += " AND ZHL.ZHL_VESTIA = 'M' "
		Elseif MV_PAR03 == 3
			cQuery += " AND ZHL.ZHL_VESTIA = 'F' "
		Endif

		if nTipo == 1
			cQuery += " AND ZI1.ZI1_CODZHL  != '' "
			cQuery += " AND ZI1.ZI1_DEMISS 	!= '' "
		ELSEif nTipo == 2
			cQuery += " AND ZI1.ZI1_CODZHL  != '' "
			cQuery += " AND ZI1.ZI1_DEMISS   = '' "
		endif

	elseif nTipo == 3
		cQuery := " SELECT '' ZI1_MAT, '' ZI1_NOME, ZHL_CODIGO, ZHL_DESCRI, ZHL_VESTIA  "+CEOL
		cQuery += " FROM "+ retsqlname("ZHL") +" ZHL "
		cQuery += " WHERE ZHL.D_E_L_E_T_='' "+CEOL
		cQuery += " AND ZHL.ZHL_CODIGO BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "+CEOL
		
		if MV_PAR03 == 2
			cQuery += " AND ZHL.ZHL_VESTIA = 'M' "
		Elseif MV_PAR03 == 3
			cQuery += " AND ZHL.ZHL_VESTIA = 'F' "
		Endif
		
		cQuery += " AND NOT EXISTS(SELECT * FROM "+ RetSqlName("ZI1") +" ZI1 WHERE ZI1.D_E_L_E_T_='' AND ZI1_CODZHL=ZHL_CODIGO) "+CEOL
	endif
return cQuery


