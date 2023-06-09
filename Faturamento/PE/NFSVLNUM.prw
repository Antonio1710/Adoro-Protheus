//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Includes/Defines                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
#Include "Protheus.CH"  
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    � NFSVLNUM   � Autor � HCConsys - Celso    � Data �14/10/2009낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao � Validacao do numero de nota fiscal de saida                낢�
굇쳐컴컴컴컴�|컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Especifico Adoro                                           낢�
굇쳐컴컴컴컴�|컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros�                                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
User Function NFSVLNUM()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis Locais                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local _aArea		:= GetArea()
Local _aSX5Num		:= {}
Local _cAliasSF1	:= ""
Local _cAliasSF2	:= ""
Local _lRet			:= .T. 

if cEmpant == "01" .AND. cfilant == "03"

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Valida usuario                                               �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   If AllTrim( Upper( PswRet( 01 )[ 01 ][ 02 ] ) ) == "BALANCA/SC"
	   MsgStop( "Usuario sem permissao para alteracao do Numero de Nota Fiscal", "NFSVLNUM" )
	   Return ( .F. )
   EndIf	

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Variaveis Publicas                                           �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   Public _lVldNFAD

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Sequencia de Notas de Entrada - Formulario proprio = "S"     �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   _cAliasSF1 := GetNextAlias()

   BeginSql Alias _cAliasSF1
	   SELECT TOP 01 SF1.F1_DOC
	   FROM %Table:SF1% SF1
	   WHERE SF1.F1_FILIAL = %xFilial:SF1%
	   AND SF1.F1_FORMUL = %Exp:'S'%
	   AND SF1.F1_SERIE = %Exp:ParamIxb[ 02 ]%
	   AND SF1.F1_ESPECIE = %Exp:'SPED'%
	   AND LEN(SF1.F1_DOC) > 6
	   ORDER BY SF1.F1_DOC DESC
   EndSql					

   While ( _cAliasSF1 )->( !Eof() )

	      aAdd( _aSX5Num, ( _cAliasSF1 )->F1_DOC )
	
	     ( _cAliasSF1 )->( dbSkip() )
	
   EndDo

   ( _cAliasSF1 )->( dbCloseArea() )

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Sequencia de Notas de Saida                                  �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   _cAliasSF2 := GetNextAlias()

   BeginSql Alias _cAliasSF2
	   SELECT TOP 01 SF2.F2_DOC
	   FROM %Table:SF2% SF2
	   WHERE SF2.F2_FILIAL = %xFilial:SF2%
	   AND SF2.F2_SERIE = %Exp:ParamIxb[ 02 ]%
	   AND SF2.F2_ESPECIE = %Exp:'SPED'%
	   AND LEN(SF2.F2_DOC) > 6
	   ORDER BY SF2.F2_DOC DESC
   EndSql					

   While ( _cAliasSF2 )->( !Eof() )

	      aAdd( _aSX5Num, ( _cAliasSF2 )->F2_DOC )
	
	      ( _cAliasSF2 )->( dbSkip() )
	
   EndDo

   ( _cAliasSF2 )->( dbCloseArea() )

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Indexa Array de sequencia de numeracao                       �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   aSort( _aSX5Num )

   //旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
   //� Valida sequencial de numeracao                               �
   //읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   If Len( _aSX5Num ) > 00

	   If RetAsc( ( Val( ParamIxb[ 01 ] ) - 01 ), 06, .T. ) > AllTrim( _aSX5Num[ Len( _aSX5Num ) ] )
		   _lRet := MsgStop( "Existem divergencias no sequencial de numeracao de Notas Fiscais, ultima NF gerada " + AllTrim( _aSX5Num[ Len( _aSX5Num ) ] ) + " e sequencial " + AllTrim( ParamIxb[ 01 ] ), "NFSVLNUM" )
		   _lRet			:= .F.
		   _lVldNFAD	:= .F.
	   Else
		  _lVldNFAD	:= .T.
	   EndIf

   EndIf
endif
Return ( _lRet )