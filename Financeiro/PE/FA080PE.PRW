#include "rwmake.ch"   
#include "topconn.ch"

/*/{Protheus.doc} User Function FA080PE
   Pontos de Entrada FA080PE sera executado na saida da funcao de baixa, apos gravar todos os dados e após a contabilização
   @type  Function
   @author Rogerio Nutti
   @since 19/12/2001
   @version version
   @param param_name, param_type, param_descr
   @return return_var, return_type, return_description
   @example
   (examples)
   @see (links_or_references)
   @history ticket 69598 - 03/11/2022 - Fernando Macieira - Titulo com problema no relatório financeiro FINR150
/*/

User Function Fa080PE()   

   SetPrvt("_SALIAS,_SINDEX,_SRECNO,_NVALBX,_SNUMF1,_SNUMD1")
   SetPrvt("_NPERC,_NVALRAT,_CFORNECE,_CNOMFOR,_SINDE2,_SNUME2")
   SetPrvt("_NCONTFOR,CTELAENTR,_cMens,")

   _sAlias := Alias()
   _sIndex := IndexOrd()
   _sRecno := Recno()

   _cFornece := SE2->E2_FORNECE
   _cNomFor  := SE2->E2_NOMFOR

   dbSelectArea("SE2")
   _sAliasSE2 := Alias()
   _sIndexSE2 := IndexOrd()
   _sRecnoSE2 := Recno()
   dbSetOrder(10)  // E2_FILIAL+E2_TIPO+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_FORNECE+E2_LOJA
   If dbSeek( xFilial("SE2")+"PA " )

      //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
      //³ Faz a leitura dos titulos do Fornecedor         ³
      //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
      Do While !Eof() .and. Alltrim(SE2->E2_TIPO) == "PA"
      
         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Despreza titulos diferentes de PA               ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         If _cFornece # SE2->E2_FORNECE
            dbSkip()
            Loop
         Endif
         
         //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
         //³ Se achou PA do Forneceodor e valor > 0, apresenta msg e sai do laco   ³
         //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
         If E2_SALDO >0
            _cMens := OemToAnsi("Este titulo foi baixado,  porem existem titulos  de ")          +Chr(13)
            _cMens := _cMens + OemToAnsi("de Adiantamento deste fornecedor ainda nao baixados.") +Chr(13)
            _cMens := _cMens + OemToAnsi(_cFornece + " - " + _cNomFor                          ) +Chr(13)
            _cMens := _cMens + OemToAnsi("Verifique e cancele a baixa antes de emitir cheques.")  +Chr(13)
            _cMens := _cMens + OemToAnsi("Efetue a Baixa por compensacao dos titulos PA (Pagto Antecipado).") +Chr(13)
            MsgBox(_cMens,"ATENCAO","ALERT")
            Exit
         Endif

         dbSelectArea("SE2")
         dbSkip()

      Enddo  
      
   Endif

   // @history ticket 69598 - 03/11/2022 - Fernando Macieira - Titulo com problema no relatório financeiro FINR150
   SE2->( dbSetOrder(1) ) // 
	If SE2->( dbSeek( FWxFilial("SE2")+SE5->E5_PREFIXO+SE5->E5_NUMERO+SE5->E5_PARCELA+SE5->E5_TIPO+SE5->E5_CLIFOR+SE5->E5_LOJA ) )
      If SE2->E2_BAIXA <> SE5->E5_DTDISPO
         FixDtBx()
      EndIf
   EndIf
   //

   //ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
   //³ Restaura ambiente inicial  ³
   //ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
   dbSelectArea(_sAliasSE2)
   dbSetOrder(_sIndexSE2)
   dbGoto(_sRecnoSE2)

   dbSelectArea(_sAlias)
   dbSetOrder(_sIndex)
   dbGoto(_sRecno)

Return

/*/{Protheus.doc} Static Function FixDtBx
   Coloca sempre a maior data de baixa no título principal para não impactar no relatório FINR150
   @type  Static Function
   @author FWNM
   @since 03/11/2022
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
   cQuery += " WHERE E5_PREFIXO='"+SE2->E2_PREFIXO+"' 
   cQuery += " AND E5_NUMERO='"+SE2->E2_NUM+"' 
   cQuery += " AND E5_PARCELA='"+SE2->E2_PARCELA+"' 
   cQuery += " AND E5_TIPO='"+SE2->E2_TIPO+"' 
   cQuery += " AND E5_CLIFOR='"+SE2->E2_FORNECE+"' 
   cQuery += " AND E5_LOJA='"+SE2->E2_LOJA+"' 
   cQuery += " AND E5_DTCANBX=''
   cQuery += " AND D_E_L_E_T_=''

   tcQuery cQuery New Alias "Work"

	aTamSX3	:= TamSX3("E5_DTDISPO")
	tcSetField("Work", "E5_DTDISPO", aTamSX3[3], aTamSX3[1], aTamSX3[2])

   Work->( dbGoTop() )
   If Work->( !EOF() )
      RecLock("SE2", .F.)
         SE2->E2_BAIXA := Work->E5_DTDISPO
      SE2->( msUnLock() )
   EndIf

   If Select("Work") > 0
      Work->( dbCloseArea() )
   EndIf

Return
