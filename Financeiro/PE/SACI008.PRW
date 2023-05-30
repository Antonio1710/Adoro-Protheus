#include "rwmake.ch"
#include "protheus.ch" 
#include "topconn.ch"

/*/{Protheus.doc} User Function SACI008
	PONTO DE ENTRADA Baixa de Titulos a Receber Manual FINA070 - Especifico Ad'oro Alimenticia
	@type  Function
	@author Rogerio Nutti
	@since 12/04/2006
	@history Ticket 8       - Abel Babini  - 05/07/2021 - Efetua avaliação de crédito do cliente após a baixa.
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history ticket 69598 - 22/11/2022 - Fernando Macieira - Titulo com problema no relatório financeiro
/*/
User Function SACI008()        

	_sAlias := Alias()
	_sIndex := IndexOrd()
	_sRecno := Recno()

	dbSelectArea("SA1")
	_sAliasSA1 := Alias()
	_sIndexSA1 := IndexOrd()
	_sRecnoSA1 := Recno()

	dbSelectArea("SE1")
	_sAliasSE1 := Alias()
	_sIndexSE1 := IndexOrd()
	_sRecnoSE1 := Recno()

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se é baixa por Perda/PDD (MV_MOTBXRE), altera risco para "E"  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	If SE5->E5_MOTBX $ Alltrim( GETMV("MV_MOTBXRE") ) 

		dbSelectArea("SA1")	
		dbSetOrder(1)
		If dbSeek( xFilial("SA1")+SE5->(E5_CLIFOR+E5_LOJA ) ) 
			RecLock("SA1",.F.)
				Replace A1_RISCO With "E"
			SA1->( MsUnlock() )
		Endif

	Endif

	//Inicio Sigoli Chamado:027642 19/12/2016
	DbSelectArea("SE1")	
	DbSetOrder(1)
	If dbSeek(xFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA)

		// Ticket 8       - Abel Babini  - 05/07/2021 - Efetua avaliação de crédito do cliente após a baixa.
		//Static Call(M410STTS,fLibCred, SE1->E1_CLIENTE, SE1->E1_LOJA, MsDate()) 
		//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
		u_10STTSA1( SE1->E1_CLIENTE, SE1->E1_LOJA, MsDate() )  

		While !Eof() .and. E1_PREFIXO = SE5->E5_PREFIXO .and. E1_NUM = SE5->E5_NUMERO .and. E1_PARCELA = SE5->E5_PARCELA .and. SE5->E5_BANCO <> ''
			If !EMPTY(E1_BAIXA).and. EMPTY(E1_XDTDISP) 
				RecLock("SE1",.F.)
					Replace E1_XDTDISP With SE5->E5_DTDISPO
				SE1->( MsUnlock() )
			EndIF	
			DbSkip() 
		Enddo

	Endif
	//Fim Sigoli Chamado: 027642 19/12/2016

	// @history ticket 69598 - 22/11/2022 - Fernando Macieira - Titulo com problema no relatório financeiro
	SE1->( dbSetOrder(1) ) // 
	If SE1->( dbSeek( FWxFilial("SE1")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO ) )
		If SE1->E1_BAIXA <> SE5->E5_DTDISPO
			FixDtBx()
		EndIf
	EndIf
	//

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Restaura ambiente inicial  ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	dbSelectArea(_sAliasSE1)
	dbSetOrder(_sIndexSE1)
	dbGoto(_sRecnoSE1)

	dbSelectArea(_sAliasSA1)
	dbSetOrder(_sIndexSA1)
	dbGoto(_sRecnoSA1)

	dbSelectArea(_sAlias)
	dbSetOrder(_sIndex)
	dbGoto(_sRecno)

Return  

/*/{Protheus.doc} Static Function FixDtBx
   Coloca sempre a maior data de baixa no título principal para não impactar no relatório FINR150
   @type  Static Function
   @author FWNM
   @since 22/11/2022
   @version version
   @param param_name, param_type, param_descr
   @return return_var, return_type, return_description
   @example
   (examples)
   @see (links_or_references)
/*/
Static Function FixDtBx()

   Local cQuery := ""

   If Select("Work") > 0
      Work->( dbCloseArea() )
   EndIf

   cQuery := " SELECT MAX(E5_DTDISPO) E5_DTDISPO
   cQuery += " FROM " + RetSqlName("SE5") + " (NOLOCK)
   cQuery += " WHERE E5_PREFIXO='"+SE1->E1_PREFIXO+"' 
   cQuery += " AND E5_NUMERO='"+SE1->E1_NUM+"' 
   cQuery += " AND E5_PARCELA='"+SE1->E1_PARCELA+"' 
   cQuery += " AND E5_TIPO='"+SE1->E1_TIPO+"' 
   cQuery += " AND E5_CLIFOR='"+SE1->E1_CLIENTE+"' 
   cQuery += " AND E5_LOJA='"+SE1->E1_LOJA+"' 
   cQuery += " AND E5_DTCANBX=''
   cQuery += " AND D_E_L_E_T_=''

   tcQuery cQuery New Alias "Work"

	aTamSX3	:= TamSX3("E5_DTDISPO")
	tcSetField("Work", "E5_DTDISPO", aTamSX3[3], aTamSX3[1], aTamSX3[2])

   Work->( dbGoTop() )
   If Work->( !EOF() )
      RecLock("SE1", .F.)
         SE1->E1_BAIXA := Work->E5_DTDISPO
      SE1->( msUnLock() )
   EndIf

   If Select("Work") > 0
      Work->( dbCloseArea() )
   EndIf

Return
