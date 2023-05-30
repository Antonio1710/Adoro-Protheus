#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function FA110BUT
	Ponto de entrada para manutenção dos titulos antes baixa - CHAMADO N. 045499 
	@type  Function
	@author Fernando Macieira
	@since 12/07/2018
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 90028 - 13/03/2023 - Fernando Macieira - Alias does not exist QRYSE1 on U_EXCABLT(FA110BUT.PRW) 23/02/2023 16:02:57 line : 165
	@history ticket 89996 - 13/03/2023 - Fernando Macieira - BAIXA EM LOTE - Alias does not exist QRYSE1
/*/
User Function FA110BUT()

	Local aButtons := {}
	
	// Botoes a adicionar
	aadd(aButtons,{ 'Acresc/Decresc' 		,{||  U_AltValor() },'Acresc/Decresc','Acresc/Decresc' } )
	aadd(aButtons,{ 'Exclui AB-'   			,{||  U_ExcAB() },'Exclui AB-','Exclui AB-' } )
	aadd(aButtons,{ 'Exclui AB- (em lote)'  ,{||  U_ExcABLt() },'Exclui AB- (em lote)','Exclui AB- (em lote)' } )  // @history ticket 90028 - 13/03/2023 - Fernando Macieira - Alias does not exist QRYSE1 on U_EXCABLT(FA110BUT.PRW) 23/02/2023 16:02:57 line : 165 // @history ticket 89996 - 13/03/2023 - Fernando Macieira - BAIXA EM LOTE
	
	If Type("oMark") <> "U"
		oMark:oBrowse:Refresh(.t.)
	EndIf

Return aButtons

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AltValor  ºAutor  ³Microsiga           º Data ³  12/07/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Recurso de acrescimo/decrescimo                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Adoro                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function AltValor()

	Local lOK      := .f.
	Local nAcresc  := (cAlias)->E1_ACRESC  //QRYSE1->E1_ACRESC @history ticket 89996 - 13/03/2023 - Fernando Macieira - BAIXA EM LOTE - Alias does not exist QRYSE1
	Local nDecresc := (cAlias)->E1_DECRESC //QRYSE1->E1_DECRESC // @history ticket 89996 - 13/03/2023 - Fernando Macieira - BAIXA EM LOTE - Alias does not exist QRYSE1
	
	Local oCmp  := Array(02)
	Local oBtn  := Array(02)
	
	DEFINE MSDIALOG oDlg TITLE "Acréscimo/Decréscimo" FROM 0,0 TO 100,350  OF oMainWnd PIXEL
	
	@ 003, 003 TO 050,165 PIXEL OF oDlg
	
	@ 010,020 Say "Acréscimo:" of oDlg PIXEL
	@ 005,060 MsGet oCmp Var nAcresc SIZE 70,12 of oDlg PIXEL Valid Positivo() Picture "@E 999,999.99"
	
	@ 020,020 Say "Decréscimo:" of oDlg PIXEL
	@ 015,060 MsGet oCmp Var nDecresc SIZE 70,12 of oDlg PIXEL Valid (Positivo() .and. nDecresc < (cAlias)->E1_SALDO) Picture "@E 999,999.99"
	
	@ 030,015 BUTTON oBtn[01] PROMPT "Confirma"     of oDlg   SIZE 68,12 PIXEL ACTION (lOK := .t. , oDlg:End())
	@ 030,089 BUTTON oBtn[02] PROMPT "Cancela"      of oDlg   SIZE 68,12 PIXEL ACTION oDlg:End()
	
	ACTIVATE MSDIALOG oDlg CENTERED
	
	If lOK
		
		aAreaSE1 := SE1->( GetArea() )
		
		SE1->( dbSetOrder(1) ) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
		
		If SE1->( dbSeek((cAlias)->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+E1_TIPO)) )
			RecLock("SE1", .f.)
				SE1->E1_ACRESC := nAcresc
				SE1->E1_DECRESC := nDecresc
			SE1->( msUnLock() )
		EndIf
		
		RestArea( aAreaSE1 )
		
		If Type("oMark") <> "U"
			oMark:oBrowse:Refresh(.t.)
		EndIf
		
	Endif
	
	If Type("oMark") <> "U"
		oMark:oBrowse:Refresh(.t.)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExcAB     ºAutor  ³Fernando Macieira   º Data ³  12/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclui AB-                                                 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Adoro                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function ExcAB()

	Local cTipo    := "AB-"
	Local aAreaSE1 := SE1->( GetArea() )
	
	SE1->( dbSetOrder(1) ) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
	If SE1->( dbSeek((cAlias)->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+cTipo)) ) // @history ticket 89996 - 13/03/2023 - Fernando Macieira - BAIXA EM LOTE - Alias does not exist QRYSE1
	//If SE1->( dbSeek(QRYSE1->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+cTipo)) )
		
		If msgYesNo("Confirma exclusão do AB- no valor de R$ " + Transform(SE1->E1_SALDO, "@E 999,999,999.99") + " ?" )
			
			RecLock("SE1", .f.)
		   		SE1->( dbDelete() )
			SE1->( msUnLock() )
			
			If Type("oMark") <> "U"
				oMark:oBrowse:Refresh(.t.)
			EndIf
					
			msgInfo("Ab- n. " + (cAlias)->E1_NUM + " excluído com sucesso! Recarregue o browse ou remarque o título para atualização do saldo na tela...")
			
		EndIf
		
	Else
		msgAlert("Título n. " + (cAlias)->E1_NUM + "/" + (cAlias)->E1_PARCELA + " não possui AB-!")
	EndIf
	
	RestArea( aAreaSE1 )
	
	If Type("oMark") <> "U"
		oMark:oBrowse:Refresh(.t.)
	EndIf

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ExcABLt   ºAutor  ³Fernando Macieira   º Data ³  12/10/18   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Exclui AB- em lote                                         º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Adoro                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/
User Function ExcABLt()

	Local cTipo    := "AB-"
	Local aAreaSE1 := SE1->( GetArea() )
	
	// @history ticket 89996 - 13/03/2023 - Fernando Macieira - BAIXA EM LOTE
	//Local aAreaQRY := QRYSE1->( GetArea() ) 
	Local cAlias   := Alias()
	//
	
	If msgYesNo("Tem certeza de que deseja excluir todos os AB- marcados desta lista?")
	
		SE1->( dbSetOrder(1) ) // E1_FILIAL + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO
		
		ProcRegua(0)
		
		(cAlias)->( dbGoTop() )
		Do While (cAlias)->( !EOF() )
		
			IncProc((cAlias)->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+cTipo))
			
			If !Empty((cAlias)->E1_OK) // Marcado
			
				If SE1->( dbSeek((cAlias)->(E1_FILIAL+E1_PREFIXO+E1_NUM+E1_PARCELA+cTipo)) )
				
					RecLock("SE1", .f.)
				   		SE1->( dbDelete() )
					SE1->( msUnLock() )
					
					If Type("oMark") <> "U"
						oMark:oBrowse:Refresh(.t.)
					EndIf
							
				EndIf
			
			EndIf
			
			(cAlias)->( dbSkip() )
			
		EndDo
	
	EndIf	
	
	RestArea( aAreaSE1 )
	//RestArea( aAreaQRY )
	
	If Type("oMark") <> "U"
		oMark:oBrowse:Refresh(.t.)
	EndIf

Return
