//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Definicao de Includes                                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
#Include "Protheus.CH"
#Include "TopConn.CH"
/*/              
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    � ADEST001R � Autor � LUCIANO MAFRA      � Data � 09/04/2015 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao � Relatorio Requisi寤es de Consumo interno                   낢�
굇쳐컴컴컴컴�|컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � U_ADEST001R()                                              낢�
굇쳐컴컴컴컴�|컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros�                                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�  
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
User Function ADEST001R()  

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis Locais                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local _cReport	:= "ADEST001R"
Local _cAlias	:= "SD3"
Local _cTitle	:= ""
Local _cDesc	:= "Este relatorio apresenta registros para analise das requisi寤es de Materiais de Consumo"
Local _lInd		:= .T.      
Local _cRet := ""

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis Private                                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Private aReturn	:= { "Zebrado", 01, "Administracao", 02, 02, 01, "", 01 }
Private _cPerg	:= PADR("ADEST001R",10," ")

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio Requisi寤es de Consumo interno')

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Pergunte                                                     �
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                         �
//� mv_par01     // De  Centro de Custo                          �
//� mv_par02     // Ate Centro de Custo                          �
//� mv_par03     // De  Local                                    �
//� mv_par04     // Ate Local                                    �
//� mv_par05     // Da  Data                                     �
//� mv_par06     // Ate Data                                     �
//� mv_par07     // Do  Produto                                  �
//� mv_par08     // Ate Produto                                  �
//� mv_par09     // Do  Tipo                                     �
//� mv_par10     // Ate Tipo                                     �
//� mv_par11     // Do  Grupo                                    �
//� mv_par12     // Ate Grupo                                    �
//� mv_par13     // Da  Conta Contabil                           �
//� mv_par14     // Ate Conta Contabil                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//
//ValidPerg()
//
If !Pergunte( _cPerg, .T. )
	Return ( Nil )
EndIf	
//
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Emissao                                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If FindFunction( "TRepInUse" ) .And. TRepInUse()
	MPReport( _cReport, _cAlias, _cTitle, _cDesc,, _lInd )	
Else
	ImpADEST001R()
EndIf

Return ( Nil )
/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    쿔mpADEST001R� Autor � Luciano Mafra       � Data �28/11/2007낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao � Impressao                                                  낢�
굇쳐컴컴컴컴�|컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � ImpADEST001R()                                             낢�
굇쳐컴컴컴컴�|컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros�                                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
Static Function ImpADEST001R()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis Locais                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local WnRel		:= "ADEST001R"
Local cbCont	:= 00
Local Cabec1	:= "Requisi寤es para Consumo"
Local Cabec2	:= ""
Local Cabec3	:= ""
Local cString	:= "SD3"
Local Tamanho	:= "M"
Local Limite	:= 80
Local nTipo     := 18
Local cDesc1	:= "Requisi寤es para Consumo"
Local cDesc2	:= "Ira imprimir os dados das Requisi寤es de Consumo"
Local cDesc3	:= "de acordo com a configuracao do usuario."
Local aOrd		:= {}

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis Private                                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Private aReturn	:= { "Zebrado", 01, "Administracao", 02, 02, 01, "", 01 }
Private aLinha		:= {}
Private NomeProg	:= "ADEST001R"
Private nLastKey	:= 00
Private nlin		:= 80   
Private nTot        := 0
Private m_pag		:= 01
Private Titulo		:= "Requisi寤es para Consumo"

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Emite relatorio                                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
WnRel := SetPrint( cString, WnRel, _cPerg, @Titulo, cDesc1, cDesc2, cDesc3, .T., aOrd,, Tamanho )

If nLastKey = 27 
	dbClearFilter()
	Return ( Nil )
EndIf

SetDefault( aReturn, cString )

If nLastKey = 27
    dbClearFilter()
   Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Imprime relatorio                                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

RptStatus( {|lEnd| RADEST001R ( @lEnd, Cabec1, Cabec2, Cabec3, Limite, Tamanho, cbCont, WnRel ) }, Titulo )

Return ( Nil )

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    쿝ADEST001R � Autor � Celso Costa          � Data �28/11/2007낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao � Chamado do relatorio                                       낢�
굇쳐컴컴컴컴�|컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � RADEST001R()                                               낢�
굇쳐컴컴컴컴�|컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�               
굇쿛arametros�                                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
Static Function RADEST001R( lEnd, Cabec1, Cabec2, Cabec3, Limite, Tamanho, cbCont, WnRel, nTipo )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis Locais                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local _cQuery				:= ""
Local Cabec1				:= ""
Local Cabec2				:= ""
Local Cabec3				:= ""
Local cbTxt					:= Space( 10 )

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define o layout do Cabecalho                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define o layout do Cabecalho                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000011111111111111111
//000000000011111111112222222222333333333344444444445555555555666666666677777777778888888888999999999900000000001111111
//012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456
//
         //123456789 1234567890123456789012345 123456789012345 1234567890123456789012345 12 9999999999999.99 99999999999.99 9999999999999.99
		 //0         1         2         3         4         5         6         7         8         9        10        11        12        13
	     //0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012
CABEC1 := "C.C  DESCRICAO                 CODIGO DESCRICAO                     UM    QTDE.     CUSTO    C U S T O   DATA DA   SOLICITANTE"
CABEC2 := "                                                                                    UNIT.    T O T A L   REQUIS.   DO MATERIAL"									 									
//
//
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Seleciona registros                                          �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸      
//
_cQuery := "SELECT  D3_DOC,D3_CC, D3_COD, D3_QUANT, D3_GRUPO, D3_CUSTO1,D3_EMISSAO,"  
_cQuery += "CP_SOLICIT, "
_cQuery += "CTT_CUSTO, CTT_DESC01, "
_cQuery += "B1_DESC, B1_UM " 
_cQuery += "FROM "   
_cQuery += RetSqlName( "SD3" ) + " D3, "
_cQuery += RetSqlName( "SB1" ) + " B1, "
_cQuery += RetSqlName( "CTT" ) + " CTT, "
_cQuery += RetSqlName( "SCP" ) + " CP "
_cQuery += "WHERE "                                                                                // SOMENTE REQUISI합ES DE CONSUMO
_cQuery += "D3.D3_CC BETWEEN '" + ( mv_par01 ) + "' AND '" + ( mv_par02 ) + "' "                   // CENTROS DE CUSTOS A SEREM ABRANGIDOS PELO RELAT�RIO
_cQuery += "AND D3.D3_LOCAL BETWEEN '" + ( mv_par03 ) + "' AND '" + ( mv_par04 ) + "' "            // ARMAZENS ABRANGIDOS PELO RELAT�RIO
_cQuery += "AND D3.D3_EMISSAO BETWEEN '" + DtoS( mv_par05 ) + "' AND '" + DtoS( mv_par06 ) + "' "  // PERIODO A SER ABRANGIDO PELO RELAT�RIO
_cQuery += "AND D3.D3_COD BETWEEN ' "  + ( mv_par07 ) + "' AND '" + ( mv_par08 ) + "' "            // PRODUTOS ABRANGIDOS PELO RELATORIO                                                           
_cQuery += "AND D3.D3_TIPO BETWEEN ' "  + ( mv_par09 ) + "' AND '" + ( mv_par10 ) + "' "           // TIPOS DE PRODUTOS A SEREM ABRANGIDOS PELO RELATORIO                                                             
_cQuery += "AND D3.D3_GRUPO BETWEEN ' " + ( mv_par11 ) + "' AND '" + ( mv_par12 ) + "' "           // GRUPOS ABRANGIDOS PELO RELATORIO
_cQuery += "AND D3.D3_CONTA BETWEEN ' " + ( mv_par13 ) + "' AND '" + ( mv_par14 ) + "' "           // GRUPOS ABRANGIDOS PELO RELATORIO
_cQuery += "AND B1.B1_COD = D3.D3_COD "           // 
_cQuery += "AND CP.CP_NUM = D3.D3_DOC "           // 
_cQuery += "AND CTT.CTT_CUSTO = D3.D3_CC "           // 
_cQuery += "AND D3.D_E_L_E_T_ = '' "
_cQuery += "AND D3.D3_FILIAL = '" + xFilial( "SD3" ) + "' "  
_cQuery += "ORDER BY D3.D3_EMISSAO"

_cQuery := ChangeQuery( _cQuery )

MsAguarde( { ||dbUseArea( .T., "TOPCONN", TCGenQry( ,, _cQuery ), "QRYTMP", .F., .T. ) }, "Selecionando registros ..." ) 

// dbUseArea( .T., "TOPCONN", TCGenQry( ,, _cQuery ), "QRYTMP", .F., .T. )
//
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Imprime registros                                            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//
SET DEFAULT TO PRINTER
dbSelectArea( "QRYTMP" )  
While QRYTMP->( !Eof() ) 
 	If nLin > 60 
       nLin := 1                   
       Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
       nLin := 8
	Endif        	
    nLin := nLin + 1	  
    _nCalc := D3_CUSTO1 / D3_QUANT  
    @ nLin,000 PSay D3_CC
    @ nLin,006 PSay CTT_DESC01                     
    @ nLin,032 PSay D3_COD
    @ nLin,039 PSay B1_DESC
    @ nLin,069 PSay B1_UM                            
    @ nLin,071 PSay D3_QUANT  PICTURE  '@E 99,999.99'
    @ nLin,081 PSay _nCalc    PICTURE  '@E 99,999.99'   
    @ nLin,094 PSay D3_CUSTO1 PICTURE  '@E 99,999.99'        
    @ nLin,105 PSay Right(D3_EMISSAO,2) + "/" + Substr(D3_EMISSAO,5,2) + "/" + SUBSTR(D3_EMISSAO,3,2)             
    @ nLin,115 PSay CP_SOLICIT
    nLin := nLin + 1	  	
    nTot := nTot + D3_CUSTO1
	QRYTMP->( dbSkip() )           
ENDDO

nLin := nLin + 2    

If nLin > 60 
   nLin := 1                   
   Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
   nLin := 8
Endif        	

@ nLin,000 PSay "CUSTO TOTAL APURADO NO PER�ODO INFORMADO: " + ALLTRIM(STR(nTot))

If aReturn[ 05 ] = 01
   Set Printer To
   Commit
   OurSpool( WnRel )
EndIf

MS_Flush()

dbCloseArea("QRYTMP")
  
Return ( Nil )