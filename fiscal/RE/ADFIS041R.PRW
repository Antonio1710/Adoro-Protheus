#include "Protheus.ch"
/*/{Protheus.doc} User Function ADFIS041R
	Relat�rio de CT-e cancelados e que est�o escriturados no sistema
	@type  Function
	@author Abel Babini
	@since 07/04/2020
	@version 1
	@history Ticket 6 - Chamado 051196 - Abel Babini - 21/09/2020 - Ajustes no relat�rio que causavam error.log
	@history Everson, 10/11/2020, Chamado 4672. Tratamento para executar o relat�rio via job.
	@history Everson, 11/11/2020, Chamado 4672. Tratamento para executar o relat�rio via job.
	@history Everson, 13/11/2020, Chamado 4672. Tratamento para executar o relat�rio via job.
	@history Everson, 17/11/2020, Chamado 4672. Tratamento para executar o relat�rio via job.
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
/*/
User Function ADFIS041R() // U_ADFIS041R()
	
	//Vari�veis.
	Local aArea		:= GetArea()
	Local aPergs	:= {}
	Local aRet		:= {}
	Local cArquivo	:= ""
	Local dmvpr01 	:= "" // Ticket      6 - Chamado 051196 - Abel Babini - 21/09/2020 - Ajustes no relat�rio que causavam error.log
	Local dmvpr02 	:= "" // Ticket      6 - Chamado 051196 - Abel Babini - 21/09/2020 - Ajustes no relat�rio que causavam error.log
	
	U_ADINF009P('ADFIS041R' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Rel Cte Cancelados')
	
	//Adiciona Perguntas / Par�metros ao relat�rio
	aAdd( aPergs ,{1,"Data Emissao De " ,Ctod(space(8))	,"" ,'.T.',,'.T.',80,.T.})
	aAdd( aPergs ,{1,"Data At�"     	,Ctod(space(8))	,"" ,'.T.',,'.T.',80,.T.})
	aAdd( aPergs ,{6,"Local de Grava��o",Space(50),"","","",50,.T.,"Todos os arquivos (*.*) |*.*","C:\TEMP\",GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_NETWORKDRIVE})

	//Executa as perguntas ao usu�rio e s� executa o relat�rio caso o usu�rio confirme a tela de par�metros;
	If ParamBox(aPergs ,"Par�metros ",aRet,,,,,,,,.T.,.T.)
		dmvpr01	 := aRet[1]
		dmvpr02	 := aRet[2]
		cArquivo := alltrim(aRet[3]) +  'RCTE_CANC_' + DTOS(DATE()) + STRTRAN(TIME(),':','') + '.XML'
		MsgRun( "Carregando dados - Relat�rio CT-e�s Cancelados, aguarde...",,{ || UFIS041R(dmvpr01,dmvpr02,cArquivo) } ) // Ticket      6 - Chamado 051196 - Abel Babini - 21/09/2020 - Ajustes no relat�rio que causavam error.log

	Else
		Alert("N�o foram informados os par�metros. Opera��o cancelada!")
	
	EndIf

	RestArea(aArea)

Return Nil 
/*/{Protheus.doc} UFIS041R
	(long_description)
	@type  Static Function
	@author Abel Babini
	@since 10/11/2020
	@version 01
	/*/
Static Function UFIS041R(dmvpr01,dmvpr02,cArquivo) //Everson - 10/11/2020. Chamado 4672.

	//Vari�veis.
	Local cQuery1		:= Nil
	Local _cCNPJ		:= SM0->M0_CGC
	Local oExcel		:= Nil
	Local oMsExcel		:= Nil
	Local cFld41R		:= "CTE CANC"
	Local cFld41t1		:= "CTEs Cancelados"
	Local nNmLin		:= 0
	Local aDados		:= {} //Everson - 17/11/2020. Chamado 4672.

	If Select(cQuery1) > 0
		(cQuery1)->(dbCloseArea())

	EndIf
	cQuery1 := GetNextAlias()

	//Everson - 10/11/2020. Chamado 4672.
	scriptSql(cQuery1,dmvpr01,dmvpr02,_cCNPJ)

	//AND REC.XML_KEYF1 <> ''
	nNmLin := Contar(cQuery1,"!Eof()") //Everson - 10/11/2020. Chamado 4672.
	ProcRegua(nNmLin) // Ticket      6 - Chamado 051196 - Abel Babini - 21/09/2020 - Ajustes no relat�rio que causavam error.log //Everson - 10/11/2020. Chamado 4672.
	
	//Everson - 10/11/2020. Chamado 4672.
	If nNmLin <= 0
		(cQuery1)->(dbCloseArea())
		MsgAlert("N�o h� dados a serem impressos.","Fun��o UFIS041R(ADFIS041R)")
		Return nNmLin

	EndIf
	//
	
	//Prepara Cabe�alho
	oExcel:= FWMSEXCELEX():New()
	oExcel:AddworkSheet(cFld41R)
	oExcel:AddTable(cFld41R,cFld41t1)
	oExcel:AddColumn(cFld41R,cFld41t1,"Empresa",1,1) //Everson - 13/11/2020. Chamado 4672.
	oExcel:AddColumn(cFld41R,cFld41t1,"Filial",1,1)
	oExcel:AddColumn(cFld41R,cFld41t1,"Dt. Emissao",1,1)
	oExcel:AddColumn(cFld41R,cFld41t1,"Dt. Digit.",1,1)
	oExcel:AddColumn(cFld41R,cFld41t1,"S�rie",1,1)
	oExcel:AddColumn(cFld41R,cFld41t1,"Nota Fiscal",2,1)
	oExcel:AddColumn(cFld41R,cFld41t1,"Codigo",1,1)
	oExcel:AddColumn(cFld41R,cFld41t1,"Loja",1,1)
	oExcel:AddColumn(cFld41R,cFld41t1,"Fornecedor",1,1)
	oExcel:AddColumn(cFld41R,cFld41t1,"Valor Total",2,3)
	oExcel:AddColumn(cFld41R,cFld41t1,"Chave XML",1,1)

	(cQuery1)->(DbGoTop())
	While !(cQuery1)->(Eof())
		IncProc()
		oExcel:AddRow(cFld41R,cFld41t1,{cEmpAnt,; //Everson - 13/11/2020. Chamado 4672.
										(cQuery1)->FILIAL,;
										(cQuery1)->DTEMISSAO,;
										(cQuery1)->DTENTRADA,;
										(cQuery1)->SERIE,;
										(cQuery1)->NFISCAL,;
										(cQuery1)->FORNECE,;
										(cQuery1)->LOJA,;
										(cQuery1)->NOMEFORN,;
										(cQuery1)->VALBRUT,;
										(cQuery1)->CHAVE})

		//Everson - 17/11/2020. Chamado 4672.
		Aadd(aDados,{cEmpAnt,(cQuery1)->FILIAL,(cQuery1)->DTEMISSAO,(cQuery1)->DTENTRADA,(cQuery1)->SERIE,(cQuery1)->NFISCAL,;
					(cQuery1)->FORNECE,(cQuery1)->LOJA,(cQuery1)->NOMEFORN,(cQuery1)->VALBRUT,(cQuery1)->CHAVE})

		(cQuery1)->(DbSkip())
	EndDo
	(cQuery1)->(dbCloseArea())
	oExcel:AddRow(cFld41R,cFld41t1,{ "","","","","","","","","","","" })
	oExcel:Activate()
	oExcel:GetXMLFile(cArquivo)

	If ( ApOleClient("MsExcel") )  .And. ! IsInCallStack("U_ADFIS045R") // se nao existir o excel sai fora.. //Everson, 11/11/2020, Chamado 4672.
		oMsExcel := MsExcel():New()
		oMsExcel:WorkBooks:Open(cArquivo)
		oMsExcel:SetVisible( .T. )
		oMsExcel:Destroy()

	ElseIf ! IsInCallStack("U_ADFIS045R") //Everson, 11/11/2020, Chamado 4672.
		Alert("Nao Existe Excel Instalado ou n�o foi poss�vel localiz�-lo. Tente novamente!")

	EndIf

Return aDados //Everson - 17/11/2020. Chamado 4672.
/*/{Protheus.doc} scriptSql
	Script sql.
	@type  Static Function
	@author Abel Babini
	@since 07/04/2020
	@version 01
	/*/
Static Function scriptSql(cQuery1,dmvpr01,dmvpr02,_cCNPJ)

	//
	BeginSQL Alias cQuery1
		COLUMN DTEMISSAO	AS DATE
		COLUMN DTENTRADA	AS DATE
		COLUMN DTRECEB		AS DATE
		SELECT
			XML_CHAVE			AS CHAVE,
			XML_EMIT			AS CNPJEMIT,
			XML_NOMEMT			AS NOMEFORN,
			XML_NUMNF			AS NUMNF,
			XML_EMISSA 			AS DTEMISSAO,
			XML_DEST			AS DEST,
			XML_RECEB			AS DTRECEB,
			XML_HORREC			AS HORAREC,
			XML_KEYF1			AS KEYF1,
			SF1.F1_FILIAL		AS FILIAL,
			SF1.F1_DOC			AS NFISCAL,
			SF1.F1_SERIE		AS SERIE,
			SF1.F1_FORNECE		AS FORNECE,
			SF1.F1_LOJA			AS LOJA,
			SF1.F1_DTDIGIT		AS DTENTRADA,
			SF1.F1_VALBRUT		AS VALBRUT
		FROM 
			RECNFCTE REC
		LEFT JOIN 
			 %table:SF1%  SF1 ON //Everson - 13/11/2020. Chamado 4672.
			SF1.F1_FILIAL = %Exp:cFilAnt%
			AND %Exp:cFilAnt%+SF1.F1_DOC+SF1.F1_SERIE+SF1.F1_FORNECE+SF1.F1_LOJA+SF1.F1_TIPO = XML_KEYF1
			AND SF1.%notDel%
		WHERE 
			XML_EMISSA BETWEEN %Exp:DToS(dmvpr01)% AND %Exp:DToS(dmvpr02)%
			AND XML_DEST = %Exp:_cCNPJ%
			AND SF1.F1_DOC IS NOT NULL
			AND REC.XML_CANCEL = 'X'
			AND REC.%notDel%
	EndSQL

Return Nil

/*/{Protheus.doc} u_FIS041A0
Ticket 70142 - Substituicao de funcao Static Call por User Function MP 12.1.33
@type function
@version 1.0
@author Edvar   / Flek Solution
@since 16/03/2022
@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
/*/
Function u_FIS041A0( uPar1, uPar2, uPar3 )
Return( UFIS041R( uPar1, uPar2, uPar3 ) )
