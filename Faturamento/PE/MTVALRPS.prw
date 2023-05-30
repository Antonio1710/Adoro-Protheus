#Include "Protheus.CH" 


/*/{Protheus.doc} User Function MTVALRPS
   (Validacao do numero de nota fiscal de saida)
   @type  Function
   @author HCConsys - Celso
   @since 14/10/2009
   @version 01
   @history TICKET 82508 - 26/10/2022 - ADRIANO SAVOINE - AJUSTADO O FONTE PARA VALIDAR AS SEQUENCIAS SEM CONSIDERAR A O FILTRO DE ESPECIES.
   @history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa.
   /*/

User Function MTVALRPS()

   Local  _aArea		   := GetArea()
   Local  _aSX5Num		:= {}
   Local  _cAliasSF1	   := ""
   Local  _cAliasSF2	   := ""
   Local  _lRet			:= .T. 
   Private _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 26/05/2023
   Public _lVldNFAD


   if cEmpAnt $ _cEmpAt1 .AND. cfilant == "03"

      If AllTrim( Upper( PswRet( 01 )[ 01 ][ 02 ] ) ) == "BALANCA/SC"
         Return ( .T. )
      EndIf	


      If ValType( _lVldNFAD ) != "U"
         If _lVldNFAD
            Return ( .T. )
         EndIf
      EndIf

      _cAliasSF1 := GetNextAlias()

      // SEQUENCIA DE NOTAS DE ENTRADA 

      BeginSql Alias _cAliasSF1

         SELECT TOP 01 SF1.F1_DOC
         FROM %Table:SF1% SF1
            WHERE SF1.F1_FILIAL = %xFilial:SF1%
            AND SF1.F1_FORMUL = %Exp:'S'%
            AND SF1.F1_SERIE = %Exp:ParamIxb[ 01 ]%
            AND LEN(SF1.F1_DOC) > 6
         ORDER BY F1_DOC DESC

      EndSql					

      While ( _cAliasSF1 )->( !Eof() )      
         aAdd( _aSX5Num, (_cAliasSF1)->F1_DOC)
            ( _cAliasSF1 )->( dbSkip() )
      EndDo

      ( _cAliasSF1 )->( dbCloseArea() )


      _cAliasSF2 := GetNextAlias()

      //SEQUENCIA DE NOTAS DE SAIDA 

      BeginSql Alias _cAliasSF2

         SELECT TOP 01 SF2.F2_DOC
         FROM %Table:SF2% SF2
            WHERE SF2.F2_FILIAL = %xFilial:SF2%
            AND SF2.F2_SERIE = %Exp:ParamIxb[ 01 ]%
            AND SF2.F2_EMISSAO > %Exp:'20100201'%
            AND LEN(SF2.F2_DOC) > 6
         ORDER BY SF2.F2_DOC DESC

      EndSql					

      While ( _cAliasSF2 )->( !Eof() )
            aAdd( _aSX5Num, ( _cAliasSF2 )->F2_DOC )
         ( _cAliasSF2 )->( dbSkip() )
      
      EndDo

      ( _cAliasSF2 )->( dbCloseArea() )

      aSort( _aSX5Num )

      If Len( _aSX5Num ) > 00  //Numero de Itens

         dbSelectArea( "SX5" )
         SX5->( dbSetOrder( 01 ) )

         If SX5->( dbSeek( xFilial( "SX5" ) + "01" + ParamIxb[ 01 ] ) ) .And. RetAsc( ( Val( SX5->X5_DESCRI ) - 01 ), 09, .T. ) > AllTrim( _aSX5Num[ Len( _aSX5Num ) ] ) //Alterado de 6 para 9 digitos de acordo com o numero da nota. Eduardo.
            MsgStop( "Existem divergencias no sequencial de numeracao de Notas Fiscais, ultima NF gerada " + AllTrim( _aSX5Num[ Len( _aSX5Num ) ] ) + " e sequencial " + AllTrim( SX5->X5_DESCRI ), "MTVALRPS" )
            _lRet := .F.
         EndIf

      EndIf

   endif

   RestArea(_aArea)

Return ( _lRet )
