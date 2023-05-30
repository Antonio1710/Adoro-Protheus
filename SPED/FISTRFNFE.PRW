#Include "PROTHEUS.CH"
#include "rwmake.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÚÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÂÄÄÄÄÄÄÂÄÄÄÄÄÄÄÄÄÄ¿±±
±±³Funcao    ³ FISTRFNFE   ³ Autor ³ Ana Helena         ³ Data ³15/07/2011³±±
±±ÃÄÄÄÄÄÄÄÄÄÄÅÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÁÄÄÄÄÄÄÁÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descricao ³ Ponto-de-Entrada: FISTRFNFE - Inclusão de botões           ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ|ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
±±³Descrição:                                                             ³±±
±±³Este ponto de entrada tem por finalidade incluir novos botões          ³±±
±±³na rotina SPEDNFE().                                                   ³±±
±±ÃÄÄÄÄÄÄÄÄÄÄ|ÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ´±±
@history Everson, 27/03/2023, ticket 90716 - rotina para impressão de NF + boleto + romaneio.
@history Everson, 31/03/2023, ticket TI - Correção errorlog.
@history Everson, 03/04/2023, ticket 90716 - Melhoria na impressão do romaneio.
/*/

User Function FISTRFNFE()

	//Variáveis.
	Local aArea 	:= GetArea()
	Local cUsers	:= Alltrim(cValToChar(GetMv("MV_#FIST01",,"")))

	If __cUserId $cUsers
		Aadd(aRotina, {"Impressão NF + Boleto", "U_FISTRF01()" , 0 , 3, 0, Nil})

	EndIf

	Aadd(aRotina,{'Mensagem NF','U_GRAVAMSGNF' , 0 , 3,0,NIL})

	RestArea(aArea)

Return Nil              

User Function GRAVAMSGNF()

	Local aArea 	:= GetArea()

	Static oDlg
	Static oButton1
	Static oGet1
	Static cNota := space(9)
	Static oGet2
	Static cSerie := space(3)
	Static oGet3
	Static cMsgNf := space(70)

	U_ADINF009P('FISTRFNFE' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

	If MsgBox("Deseja incluir uma mensagem na nota fiscal?"," CONFIRMA INCLUSAO ","YESNO")   

		DEFINE MSDIALOG oDlg TITLE "Mensagem NF" FROM 000, 000  TO 150, 500 COLORS 0, 16777215 PIXEL

		@ 009, 048 MSGET oGet1 VAR cNota SIZE 046, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 010, 006 SAY oSay1 PROMPT "Numero da Nota" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 023, 006 SAY oSay2 PROMPT "Série" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 021, 048 MSGET oGet2 VAR cSerie SIZE 023, 010 OF oDlg COLORS 0, 16777215 PIXEL
		@ 035, 006 SAY oSay3 PROMPT "Mensagem" SIZE 040, 007 OF oDlg COLORS 0, 16777215 PIXEL
		@ 034, 048 MSGET oGet3 VAR cMsgNf SIZE 195, 010 OF oDlg COLORS 0, 16777215 PIXEL        	
		@ 057, 096 BUTTON OemToAnsi("&Confirma")  SIZE 030, 013 ACTION ( nOpc := 0, oDlg:End()) OF oDlg PIXEL	
		
		ACTIVATE MSDIALOG oDlg CENTERED	                          

		dbSelectArea("SC5")
		dbSetOrder(15)	
		If dbSeek(xFilial("SC5")+cNota+cSerie) 		
			If Alltrim(SC5->C5_MENNOT5) = ""
				RecLock("SC5",.F.)
				SC5->C5_MENNOT5 := cMsgNf
				MsUnlock()
			Else 
				Alert("Mensagem nao sera gravada. Campo ja esta preenchido")

			Endif	

		Else 
			Alert("Nf "+cNota+" "+cSerie+" não encontrada!")

		Endif
		
	EndIf

	RestArea(aArea)
		
Return .F. 
/*/{Protheus.doc} User Function FISTRF01
	Impressão de NF + Boleto
	Ticket 90716.
	@type  Function
	@author Everson
	@since 27/03/2023
	@version 01
/*/
User Function FISTRF01()

	//Variáveis.
	Local aArea 	:= GetArea()
	Local cQuery	:= ""
	Local cNxtAlias	:= ""
	Local aParamFat	:= {}
	Local nCount	:= 0
	Local aRoteiros	:= {}
	Local dDtIni	:= Nil
	Local dDtFim	:= Nil
	Local cRotIni	:= ""
	Local cRotFim	:= ""

	//Everson - 03/04/2023 - ticket 90716.
	Local cNFde		:= ""
	Local cSrde		:= ""
	Local cNFAte	:= ""
	Local cSrAte	:= ""

	MsAguarde({|| SpedDanfe() }, "FISTRF01(FISTRFNFE)", "Imprimindo NFs...")

	If MV_PAR04 <> 2
		RestArea(aArea)
		Return Nil
	
	EndIf

	cQuery := ""
	cQuery += " SELECT  " 
		cQuery += " F2_SERIE, F2_DOC, F2_EMISSAO, C5_DTENTR, C5_ROTEIRO, SE1.R_E_C_N_O_ AS RECNO " 
	cQuery += " FROM  " 
		cQuery += " " + RetSqlName("SE1") + " (NOLOCK) AS SE1  " 
		cQuery += " INNER JOIN " 
		cQuery += " " + RetSqlName("SF2") + " (NOLOCK) AS SF2 ON " 
		cQuery += " E1_FILIAL = F2_FILIAL " 
		cQuery += " AND E1_PREFIXO = F2_SERIE " 
		cQuery += " AND E1_NUM = F2_DOC " 
		cQuery += " AND E1_CLIENTE = F2_CLIENTE " 
		cQuery += " AND E1_LOJA = F2_LOJA " 
		cQuery += " AND E1_EMISSAO = F2_EMISSAO " 
		cQuery += " INNER JOIN " 
		cQuery += " " + RetSqlName("SC5") + " (NOLOCK) AS SC5 ON " 
		cQuery += " F2_FILIAL = C5_FILIAL " 
		cQuery += " AND F2_SERIE = C5_SERIE " 
		cQuery += " AND F2_DOC = C5_NOTA " 
		cQuery += " AND F2_CLIENTE = C5_CLIENT " 
		cQuery += " AND F2_LOJA = C5_LOJACLI " 
	cQuery += " WHERE  " 
		cQuery += " F2_FILIAL = '" + FWxFilial("SF2") + "' " 
		cQuery += " AND F2_SERIE = '" + MV_PAR03 + "' " 
		cQuery += " AND F2_DOC BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " 
		cQuery += " AND F2_EMISSAO BETWEEN '" + DToS(MV_PAR07) + "' AND '" +  DToS(MV_PAR08) + "' " 
		cQuery += " AND F2_DUPL <> '' " 
		cQuery += " AND E1_TIPO = 'NF' " 
		cQuery += " AND E1_NUMBCO <> '' " 
		cQuery += " AND SE1.D_E_L_E_T_ = '' " 
		cQuery += " AND SF2.D_E_L_E_T_ = '' " 
	cQuery += " ORDER BY F2_SERIE, F2_DOC, F2_EMISSAO " 

	cNxtAlias := GetNextAlias()

	DbUseArea(.T., "TOPCONN", TcGenQry(,, cQuery), cNxtAlias, .F., .T.)

	TcSetField(cNxtAlias, "F2_EMISSAO", "D", 8, 0 )
	TcSetField(cNxtAlias, "C5_DTENTR", "D", 8, 0 )

	(cNxtAlias)->(DbGoTop())

	While ! (cNxtAlias)->(Eof())

		nCount++

		If nCount == 1

			Aadd(aParamFat, (cNxtAlias)->F2_SERIE)
			Aadd(aParamFat, (cNxtAlias)->F2_SERIE)
			Aadd(aParamFat, (cNxtAlias)->F2_DOC)
			Aadd(aParamFat, (cNxtAlias)->F2_DOC)
			Aadd(aParamFat, (cNxtAlias)->F2_EMISSAO)
			Aadd(aParamFat, (cNxtAlias)->F2_EMISSAO)

		Else
			
			If (cNxtAlias)->F2_SERIE > aParamFat[2]
				aParamFat[2] := (cNxtAlias)->F2_SERIE
			
			EndIf

			If (cNxtAlias)->F2_DOC > aParamFat[4]
				aParamFat[4] := (cNxtAlias)->F2_DOC

			EndIf

			If (cNxtAlias)->F2_EMISSAO > aParamFat[6]
				aParamFat[6] := (cNxtAlias)->F2_EMISSAO

			EndIf

		EndIf

		dDtIni	:= (cNxtAlias)->C5_DTENTR
		dDtFim	:= (cNxtAlias)->C5_DTENTR
		cRotIni	:= (cNxtAlias)->C5_ROTEIRO
		cRotFim	:= (cNxtAlias)->C5_ROTEIRO

		//Everson - 03/04/2023 - ticket 90716
		cNFde	:= (cNxtAlias)->F2_DOC
		cSrde	:= (cNxtAlias)->F2_SERIE
		cNFAte	:= (cNxtAlias)->F2_DOC
		cSrAte	:= (cNxtAlias)->F2_SERIE

		If nCount == 1

			Aadd(aRoteiros, dDtIni)
			Aadd(aRoteiros, dDtFim)
			Aadd(aRoteiros, cRotIni)
			Aadd(aRoteiros, cRotFim)

			//Everson - 03/04/2023 - ticket 90716
			Aadd(aRoteiros, cNFde)
			Aadd(aRoteiros, cSrde)
			Aadd(aRoteiros, cNFAte)
			Aadd(aRoteiros, cSrAte)

	
		Else

			If dDtIni < aRoteiros[1]
				aRoteiros[1] := dDtIni

			EndIf

			If dDtFim > aRoteiros[2]
				aRoteiros[2] := dDtFim

			EndIf

			If cRotIni < aRoteiros[3]
				aRoteiros[3] := cRotIni

			EndIf

			If cRotFim > aRoteiros[4]
				aRoteiros[4] := cRotFim

			EndIf

			//Everson - 03/04/2023 - ticket 90716
			If cNFde < aRoteiros[5]
				aRoteiros[5] := cNFde

			EndIf

			If cSrde < aRoteiros[6]
				aRoteiros[6] := cSrde

			EndIf

			If cNFAte > aRoteiros[7]
				aRoteiros[7] := cNFAte

			EndIf

			If cSrAte > aRoteiros[8]
				aRoteiros[8] := cSrAte

			EndIf

		EndIf

		(cNxtAlias)->(DbSkip())

	End

	(cNxtAlias)->(DbCloseArea())

	If Len(aParamFat) > 0 .And. MsgYesNo("Deseja imprimir os boletos da NF " + aParamFat[1] + aParamFat[3] + " até " + aParamFat[2] + aParamFat[4] + "?", "Função FISTRF01(FISTRFNFE)")
		MsAguarde({|| U_HCRFIBLT(Nil, aParamFat) }, "FISTRF01(FISTRFNFE)", "Imprimindo boletos...")

	EndIf

	If Len(aRoteiros)  > 0 .And. MsgYesNo("Deseja imprimir os relatórios de romaneio?", "Função FISTRF01(FISTRFNFE)")
		MsAguarde({|| U_ADROMENT(aRoteiros) }, "FISTRF01(FISTRFNFE)", "Imprimindo relatórios...")

	EndIf 

	RestArea(aArea)

Return Nil
