#include "rwmake.ch"
#include "topconn.ch"

User Function AD0138()   

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("AORD,TAMANHO,LIMITE,NOMEPROG,MV_TABPR,NTIPO")
SetPrvt("ARETURN,NLASTKEY,NLIN,NITEM,LCONTINUA,HISTORICO")
SetPrvt("_nTotal,M_PAG,IMPRIME,CSTRING,TITULO,CPERG")
SetPrvt("CDESC1,CDESC2,CDESC3,NOMEREL,ASTRU,_CNOMTRB")
SetPrvt("_VENDEDOR,")


/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  �  REGCOB  � Autor 쿝ogerio Nutti / Eduardo� Data � 26/06/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Relatorio de Titulos a Receber por Regiao de Cobranca      낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Adoro Alimenticia                                          낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Manuten  �                                                            낢�
굇�          �                                                            낢�
굇�          �                                                            낢�
굇�          �                                                            낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

_cSupVends	:=""
_cCodVen	:=""
_cCodSup 	:=""
_bFlagVend	:=""
CABEC1:="CENTRO DE CUSTO                   JANEIRO     FEVEREIRO   MARCO     ABRIL       MAIO         JUNHO        JULHO        AGOSTO       SETEMBRO     OUTUBRO      NOVEMBRO     DEZEMBRO     ACUMULADO"
CABEC2:="------------------------------   ---------   ----------- -------   -------    ---------    ----------   ----------   ----------   -----------   ---------    ----------   ----------   -----------"


//CABECALHO ORIGINAL//Cabec1		:="CENTRO DE CUSTO                     JANEIRO     FEVEREIRO    MARCO       ABRIL          MAIO        JUNHO      JULHO      AGOSTO    SETEMBRO  OUTUBRO   NOVEMBRO DEZEMBRO  ACUMULADO"
Cabec2		:=""

/*NOVO LAY OUT
___________________________________________________________________________________________________________________________________________________________________________________________
CENTRO DE CUSTO    JANEIRO     FEVEREIRO   MARCO     ABRIL       MAIO         JUNHO        JULHO        AGOSTO       SETEMBRO     OUTUBRO      NOVEMBRO     DEZEMBRO     ACUMULADO
XXXXXXXXXX         XXXXXXXXXX XXXXXXXXXX XXXXXXXXXX  XXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXX XXXXXXXXXXXX
-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
0         1         2         3         4         5         6         7         8         9        10        11        12        13         14       15        16        17        18
___________________________________________________________________________________________________________________________________________________________________________________________
*/


//CENTRO DE CUSTO       JANEIRO     FEVEREIRO    MARCO       ABRIL          MAIO        JUNHO      JULHO      AGOSTO    SETEMBRO  OUTUBRO   NOVEMBRO DEZEMBRO  ACUMULADO"
//--------------------  -----------  ----------- ---------- ----------- ----------- ---------- ----------- ----------- ---------- ---------- ----------- ----------- ------------"
//20501 AAAAAAAAA     999,999.99  999,999.99  999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99 999,999.99  9999,999.99
//                              31             46               63            77             92            106            121          134           148           162           176           190            205
//
//
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para parametros                         |
//� mv_par01             // do Projeto                           �
//� mv_par02             // Ate o Projeto                        �
//� mv_par03             // Centro Custo de                      �
//� mv_par04             // Centro Custo ate                     �
//� mv_par05             // C.Contabil  de                       �
//� mv_par06             // C.Contabil ate                       �
//� mv_par07             // Acumulado Ate o dia                  |
//� mv_par08             // Imprime 1 P/Pagina ?                 |
//� mv_par09             // Sint/Analitico                       |
//| mv_par10             // Imprime Movimento?                   |
//| mv_par11             // Deseja subtotal? (Grupo / Conta Cont)|
//| mv_par12             // Considera data (Emissao / Digitacao) |
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//�                                                                        �
//�    > > > > >           Valores Fixos no Relatorio         < < < < <    �
//�                                                                        �
//�                                                                        �
//쿟ipo de Requisicao:                                                     �
//�                                                                        �
//�                   Entrada ---> 501                                     �
//�                   Saida -----> 101                                     �
//�                                                                        �
//� Fixado nas linhas:                                                     �
//�                                                                        �
//�     308 --> _cQuery += " AND   (D3_TM = '501' OR D3_TM = '101')"       �
//�     543 --> If D3_TM == '101' // VERIFICA SE E ENTRADA NO ALMOXARIFADO �
//�                                                                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸


tamanho   := "G"
limite    := 220
nomeprog  := "ADO138"
mv_tabpr  := ""
nTipo     := 18
//aReturn   := { "Zebrado", 1,"Administracao", 2, 2, 1,"",1}
aReturn   := { "Zebrado", 1,"Administracao", 1, 2, 1,"",1}
nLastKey  := 0
nlin      := 70
nItem     := 1
lContinua := .T.

historico := space(20)
_nTotal   := 0

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utilizadas para Impressao do Cabecalho e Rodape	 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
m_pag     := 01
imprime   := .T.

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Tela padrao de impressao                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

cString  := "CT3"
titulo     := " Acompanhamento de Investimentos por Setor"
cPerg    := "AD0138"
cDesc1  := "Este programa tem como objetivo imprimir Investimentos Sinteticos"
cDesc2  := "ou Analiticos por Setor"
cDesc3  := ""
NomeRel := "AD0138"

//Variaveis Criadas


//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Pergunte(cPerg,.F.)

nomerel := SetPrint(cString,Nomerel,cPerg,Titulo,cDesc1,cDesc2,cDesc3,.F., ,.T.,Tamanho)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Inicializa a regua de processamento                                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

Processa({|| RptDetail()},"Acompanhamentos de Investimentos por Setor")
Return
Static Function RptDetail()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿣erifica quantidade de digitos do Ano               �
//쿞e estiver no formato dd/mm/aa pega duas casas.     �
//쿎aso esteja no formato dd/mm/aaaa pega quatro casas.�
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
If Len(DtoS(DDataBase)) == 6
	_dDataIni := CTOD('01/01/'+SUBSTR(DTOC(mv_par07),7,2) )
	_dDataMes := CTOD('01/'+SUBSTR(DTOC(mv_par07),4,5) )
Else
	_dDataIni := CTOD('01/01/'+SUBSTR(DTOC(mv_par07),7,4) )
	_dDataMes := CTOD('01/'+SUBSTR(DTOC(mv_par07),4,7) )
Endif
//
// BUSCANDO DADOS EM PROJETOS
_cQuery := "SELECT AF8_FILIAL, AF8_PROJET, AF8_DESCRI FROM " +  RetSqlName("AF8")
_cQuery	+= " WHERE (AF8_PROJET BETWEEN '" + ALLTRIM(mv_par01)  +"' AND '"+ALLTRIM(mv_par02)+ "')"
_cQuery	+= " AND (D_E_L_E_T_ <> '*') "
_cQuery	+= " ORDER BY AF8_PROJET"
TCQUERY _cQuery new alias "XF8"
XF8->(dbgotop())
                                                                                                 

_cQuery:=" SELECT CTT_CUSTO,CTT_DESC01 FROM "+RETSQLNAME("CTT")+" " 
_cQuery	+= " WHERE (CTT_CUSTO BETWEEN '" + ALLTRIM(mv_par03)  +"' AND '"+ALLTRIM(mv_par04)+ "')"
_cQuery	+= " AND (RTRIM(CTT_DESC01) <> ' ') "
_cQuery	+= " AND ("+retsqlname("CTT")+".D_E_L_E_T_ <> '*') "
_cQuery	+= " ORDER BY CTT_CUSTO"
TCQUERY _cQuery new alias "XI3"
XI3->(dbgotop())
//
_cProj      := '????'  // Codigo do Projeto
_x1Vez	    :=	.T.
nLin        := 8
_nTotMes    := {}
_nTotGer    := {}
_nTotPrj    := {}
//
_cCentro    := ''            // codigo centro de custo
_nTotAcu    := 0
_nTotAcuG   := 0  // Total acumulado anual
_nTotAcuM   := 0  // Total acumulado centro custo mensal
_nTotAcuP   := 0  // Total acumulado por projeto
//

// Incluido por Ricardo em 08/02/2006 para tratar o parametro mv_par11
_GrupoAnt   := ""   // Armazena o grupo anterior para verificacao do parametro mv_par11
_ccAnt      := ""   // Armazena o Centro de Custo anterior para verificacao do parametro mv_par11
_nAcumTot   := 0    // Armazena o acumulado do total unitario

//
_nVetor      := 1
DO WHILE _nVetor <= 12
	AADD(_nTotMes,{_nVetor,0.00})
	AADD(_nTotGer,{_nVetor,0.00})
	AADD(_nTotPrj,{_nVetor,0.00})
	//
	_nTotMes[_nVetor][1] :=0
	_nTotGer[_nVetor][1] :=0
	_nTotPrj[_nVetor][1] :=0
	//
	_nVetor := _nVetor + 1
ENDDO
//
cFilterUser:=aReturn[7]
//


dbSelectArea("XF8")
dbGotop()
DO WHILE !EOF()
	//
	IF (_x1Vez .or. nLin > 45)
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 10
		_x1Vez	:=	.F.
	ENDIF
	//
	_cProj := AF8_PROJET
	@nLin,000 PSAY 'PROJETO: ' + AF8_PROJET + '  ----->  ' + ALLTRIM(AF8_DESCRI)
	nLin++
	//
	
	_nTotAcuP  := 0
	_nVetor      := 1
	DO WHILE _nVetor <= 12
		_nTotPrj[_nVetor][1] := 0
		_nVetor := _nVetor + 1
	ENDDO
	//
	dbSelectArea("XI3")
	dbGotop()
	DO WHILE !EOF()
		//
		IF (_x1Vez .or. nLin > 60)
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 10
			_x1Vez	:=	.F.
		ENDIF
		//
		//	IF !EMPTY(cFilterUser).AND.!(&cFilterUser)
		// 		DBSKIP()
		//	   LOOP
		//	ENDIF
		//
		_cCusto      := CTT_CUSTO
		_nTotAcuM    := 0
		_nVetor      := 1
		DO WHILE _nVetor <= 12
			_nTotMes[_nVetor][1] := 0
			_nVetor := _nVetor + 1
		ENDDO
		//
		IF mv_par10 <> 3
			// pesquisando todos os lanctos de entrada ref. ccusto, ccontabil e periodo de data
			_cQuery := "SELECT D1_FILIAL, D1_COD, D1_QUANT, D1_TOTAL, D1_CONTA, D1_GRUPO, D1_CC, D1_PEDIDO, D1_FORNECE, D1_EMISSAO, D1_DOC,D1_PROJETO,D1_VUNIT,D1_GRUPO,D1_DTDIGIT FROM " +  RetSqlName("SD1")
			_cQuery	+= " WHERE (D1_PROJETO = '" + _cProj + "')"
			_cQuery	+= " AND   (D1_CC      = '" + _cCusto+ "')"
			IF ALLTRIM(mv_par06) <> '' .OR. ALLTRIM(mv_par05) <> ''
				_cQuery	+= " AND (D1_CONTA BETWEEN '" + AllTrim(mv_par05)  +"' AND '"+AllTrim(mv_par06)+ "')"
			ENDIF
			If mv_par12 == 1 // considera data de emissao
				_cQuery	+= "AND (D1_EMISSAO BETWEEN '" + DTOS(_dDataIni) +"' AND '"+DTOS(mv_par07)+ "')"
			Else             // considera data de digitacao
				_cQuery	+= "AND (D1_DTDIGIT BETWEEN '" + DTOS(_dDataIni) +"' AND '"+DTOS(mv_par07)+ "')"
			Endif
			_cQuery	+= " AND (D_E_L_E_T_ <> '*') "
			TCQUERY _cQuery new alias "XD1"
			//
			dbSelectArea("XD1")
			dbGotop()
			DO WHILE ! EOF()
				IF mv_par12 == 1 // considera data de emissao
					_dEmissao 	   := Ctod(Right(XD1->D1_EMISSAO,2) +"/"+Substr(XD1->D1_EMISSAO,5,2) +"/"+Left(XD1->D1_EMISSAO,4))
				ELSE             // considera data de digitacao
					_dEmissao 	   := Ctod(Right(XD1->D1_DTDIGIT,2) +"/"+Substr(XD1->D1_DTDIGIT,5,2) +"/"+Left(XD1->D1_DTDIGIT,4))
				ENDIF
				
				_NMes       	   := Month(_dEmissao)
				_nTotMes[_nMes][1] := _nTotMes[_nMes][1] + XD1->D1_TOTAL
				_nTotGer[_nMes][1] := _nTotGer[_nMes][1] + XD1->D1_TOTAL
				_nTotPrj[_nMes][1] := _nTotPrj[_nMes][1] + XD1->D1_TOTAL
				_nTotAcu           := _nTotAcu           + XD1->D1_TOTAL
				_nTotAcuM          := _nTotAcuM          + XD1->D1_TOTAL
				_nTotAcuG          := _nTotAcuG          + XD1->D1_TOTAL
				_nTotAcuP          := _nTotAcuP          + XD1->D1_TOTAL
		        //
		        // verificando se tem devolucao
				SD2->(DbSetOrder()) // Indexa por Filial + Nota Fiscal
				IF SD2->(DbSeek(xFilial("SD2") + XD1->D1_DOC))
					_dEmissao 		   := Ctod(Right(SD2->D2_EMISSAO,2) +"/"+Substr(SD2->D2_EMISSAO,5,2) +"/"+Left(SD2->D2_EMISSAO,4))
					_NMes       	   := Month(_dEmissao)
					_nTotMes[_nMes][1] := _nTotMes[_nMes][1] - SD2->D2_TOTAL
					_nTotGer[_nMes][1] := _nTotGer[_nMes][1] - SD2->D2_TOTAL
					_nTotPrj[_nMes][1] := _nTotPrj[_nMes][1] - SD2->D2_TOTAL
					_nTotAcu           := _nTotAcu           - SD2->D2_TOTAL
					_nTotAcuM          := _nTotAcuM          - SD2->D2_TOTAL
					_nTotAcuG          := _nTotAcuG          - SD2->D2_TOTAL
					_nTotAcuP          := _nTotAcuP          - SD2->D2_TOTAL
                ENDIF
				DBSKIP()
			ENDDO
		ENDIF
		//
		IF mv_par10 <> 2
			_cQuery := "SELECT D3_CC,D3_TM,D3_CONTA,D3_EMISSAO,D3_PROJETO,D3_QUANT,D3_CUSTO1,D3_DOC,D3_GRUPO,D3_COD FROM "  +  RetSqlName("SD3")
			_cQuery	+= " WHERE (D3_PROJETO = '" + _cProj + "')"
			_cQuery += " AND   (D3_TM = '501' OR D3_TM = '101' OR D3_TM = '499')"
			_cQuery	+= " AND   (D3_CC      = '" + _cCusto+ "')"
			IF ALLTRIM(mv_par06) <> '' .OR. ALLTRIM(mv_par05) <> ''
				_cQuery	+= " AND   (D3_CONTA BETWEEN '" + AllTrim(mv_par05)  +"' AND '"+AllTrim(mv_par06)+ "')"
			ENDIF
			_cQuery	+= " AND   (D3_EMISSAO BETWEEN '" + DTOS(_dDataIni) +"' AND '"+DTOS(mv_par07)+ "')"
			_cQuery	+= " AND   (D_E_L_E_T_ <> '*') "
			
			// verifica se a quebra e por conta contabil ou grupo
			If mv_par11 == 1  // quebra por conta contabil
				_cQuery += " ORDER BY D3_CONTA"
			Else              // quebra por grupo
				_cQuery += " ORDER BY D3_GRUPO"
			Endif
			
			TCQUERY _cQuery new alias "XD3"
			dbSelectArea("XD3")
			dbGotop()
			DO WHILE ! EOF()
				_dEmissao 			:= Ctod(Right(XD3->D3_EMISSAO,2) +"/"+Substr(XD3->D3_EMISSAO,5,2) +"/"+Left(XD3->D3_EMISSAO,4))
				_NMes       		:= Month(_dEmissao)
				_TotReg           	:= XD3->D3_CUSTO1
				_TotUnt             := (XD3->D3_CUSTO1/XD3->D3_QUANT)
				IF (XD3->D3_TM == '101' .OR. XD3->D3_TM == '499')  // VERIFICA SE E ENTRADA NO ALMOXARIFADO(DEVOLUCAO)
					_nTotMes[_nMes][1] 	:= _nTotMes[_nMes][1]	  -  _TotReg
					_nTotGer[_nMes][1]  := _nTotGer[_nMes][1]	  -  _TotReg
					_nTotPrj[_nMes][1]  := _nTotPrj[_nMes][1]	  -  _TotReg
					_nTotAcu            := _nTotAcu               -  _TotReg
					_nTotAcuM           := _nTotAcuM              -  _TotReg
					_nTotAcuG           := _nTotAcuG              -  _TotReg
					_nTotAcuP           := _nTotAcuP              -  _TotReg
				ELSE
					_nTotMes[_nMes][1] 	:= _nTotMes[_nMes][1]	  +  _TotReg
					_nTotGer[_nMes][1]  := _nTotGer[_nMes][1]	  +  _TotReg
					_nTotPrj[_nMes][1]  := _nTotPrj[_nMes][1]	  +  _TotReg
					_nTotAcu            := _nTotAcu               +  _TotReg
					_nTotAcuM           := _nTotAcuM              +  _TotReg
					_nTotAcuG           := _nTotAcuG              +  _TotReg
					_nTotAcuP           := _nTotAcuP              +  _TotReg
				ENDIF	
				DBSKIP()
			ENDDO
		ENDIF
		//
		// imprimindo os totais
		IF _nTotAcuM <> 0
			//IMPRESSAO DANIEL   picture muda o posicionamento precisa alinhar a esquerda pela picture
			@nLin,000 PSAY XI3->CTT_CUSTO +' '+SUBSTR(XI3->CTT_DESC01,1,15)
			@nLin,034 PSAY _nTotMes[01][1]     		PICTURE   '@E 999,999.99'
			@nLin,045 PSAY _nTotMes[02][1]      	PICTURE   '@E 999,999.99'
			@nLin,056 PSAY _nTotMes[03][1]      	PICTURE   '@E 999,999.99'
			@nLin,068 PSAY _nTotMes[04][1]      	PICTURE   '@E 999,999.99'
			@nLin,080 PSAY _nTotMes[05][1]      	PICTURE   '@E 999,999.99'
			@nLin,093 PSAY _nTotMes[06][1]      	PICTURE   '@E 999,999.99'
			@nLin,106 PSAY _nTotMes[07][1]       	PICTURE   '@E 999,999.99'
			@nLin,119 PSAY _nTotMes[08][1]      	PICTURE   '@E 999,999.99'
			@nLin,132 PSAY _nTotMes[09][1]      	PICTURE   '@E 999,999.99'
			@nLin,145 PSAY _nTotMes[10][1]      	PICTURE   '@E 999,999.99'
			@nLin,155 PSAY _nTotMes[11][1]      	PICTURE   '@E 999,999.99'
			@nLin,171 PSAY _nTotMes[12][1]      	PICTURE   '@E 999,999.99'
			@nLin,184 PSAY _nTotAcuM  	     	  	PICTURE '@E 9,999,999.99'
			nLin++
			//
			// verificando se a opcao do usuario foi por analitico
			//
			IF mv_par09 = 2
				IF mv_par10 <> 3   // se for opcao analitica
					//
					dbSelectArea("XD1")
					dbGotop()
					_cPrm     := 'S'
					_nTot1    := 0
					_nAcumTot := 0
					//
					DO WHILE ! EOF()
						IF mv_par12 == 1 // considera data de emissao
							_dEmissao 	   := Ctod(Right(XD1->D1_EMISSAO,2) +"/"+Substr(XD1->D1_EMISSAO,5,2) +"/"+Left(XD1->D1_EMISSAO,4))
						ELSE             // considera data de digitacao
							_dEmissao 	   := Ctod(Right(XD1->D1_DTDIGIT,2) +"/"+Substr(XD1->D1_DTDIGIT,5,2) +"/"+Left(XD1->D1_DTDIGIT,4))
						ENDIF
						IF (_dEmissao < _dDataMes)
							dbSkip()
							Loop
						ENDIF
						//
						IF  _cPrm = 'S'
							nLin++
							@nLin,001 PSAY '   TOTAL DAS ENTRADAS ----->>'
							@nLin,073 PSAY 'DATA            CONTA CONTABIL                    GRUPO     QUANT  UNITARIO     TOTAL    NF/FORNECEDOR--------------------------------'
							//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
							//70        80        90        100       110       120       130       140       150       160       170       180       190       200
							nLin++  //        xx/xx/xx 123456 1111111111111X
							_cPrm := 'N'
						ENDIF
						//
						dbSelectArea("CT1") //"SI1") ALTERADO PARA CT1 
						dbSetOrder(1)  //FILIAL+CODIGO
						
						dbSeek(xFilial("CT1")+XD1->D1_CONTA, .T.)
						_cNomC := CT1_DESC01
						//
						
						// COMENTADO PARA NAO MAIS EXIBIR O NOME DO PRODUTO E EXIBIR SEU FORNECEDOR
						//dbSelectArea("SB1")
						//dbSetOrder(1)
						//dbSeek(xFilial("SB1")+XD1->D1_COD,.T.)
						//_cNom := B1_DESC
						//
						
						// Armazena na variavel cNom o Nome do Fornecedor
						dbSelectArea("SA2")
						dbSetOrder(1)
						dbSeek(xFilial("SA2")+XD1->D1_FORNECE,.T.)
						_cNom := LEFT(A2_NOME,15)
						
						// +---------------------------------------------------------------------+
						// | Verifica se a quebra sera executada por conta contabil ou por grupo |
						// | e imprime o totalizador quando houver quebra definida no parametro  |
						// +---------------------------------------------------------------------+
						If mv_par11 == 1 // quebra por grupo
							If _GrupoAnt <> XD1->D1_GRUPO
								_GrupoAnt := XD1->D1_GRUPO
								If _nAcumTot <> 0
									@ nLin,090 PSay "Total do Grupo:"
									@ nLin,147 PSay _nAcumTot Picture '@E 9999,999.99'
									_nAcumTot := 0
									nLin := nLin + 2
								Endif
							Endif
						Else   // quebra por conta contabil
							If _ccAnt <> SUBSTR(XD1->D1_CONTA,1,12)
								_ccAnt := SUBSTR(XD1->D1_CONTA,1,12)
								If _nAcumTot <> 0
									nLin := nLin + 1
									@ nLin,090 PSay "Total da Conta Ctb:"
									@ nLin,147 PSay _nAcumTot Picture '@E 9999,999.99'
									_nAcumTot := 0
									nLin := nLin + 2
								Endif
							Endif
						Endif
						
						dbSelectArea("XD1")
						_dEmissao 		   := Ctod(Right(D1_EMISSAO,2) +"/"+Substr(D1_EMISSAO,5,2) +"/"+Left(D1_EMISSAO,4))
						@nLin,073  PSAY _dEmissao
						//@nLin,082  PSAY D1_DOC
						@nLin,089  PSAY SUBSTR(D1_CONTA,1,12) + ' '+SUBSTR(_cNomC,1,20)
						@nLin,123  PSAY D1_GRUPO
						@nLin,130  PSAY D1_QUANT      PICTURE '@E 9,999.99'
						@nLin,137  PSAY D1_VUNIT      PICTURE '@E 99,999.99'
						@nLin,147  PSAY D1_TOTAL      PICTURE '@E 999,999.99'
						//@nLin,161  PSAY D1_COD + ' ' + _cNom // COMENTADO PARA EXIBIR O NOME DO FORNECEDOR
						@nLin,161  PSAY D1_DOC + ' ' + _cNom
						_cNom     := ""
						_nAcumTot := _nAcumTot + D1_TOTAL
						_nTot1    := _nTot1    + D1_TOTAL
						nLin++
						
						// +-----------------------------------------------------------+
						// | Verifica se Existe devolucao para o item que foi impresso |
						// +-----------------------------------------------------------+
						SD2->(DbSetOrder()) // Indexa por Filial + Nota Fiscal
						If SD2->(DbSeek(xFilial("SD2") + XD1->D1_DOC))
							_dEmissao 		   := Ctod(Right(SD2->D2_EMISSAO,2) +"/"+Substr(SD2->D2_EMISSAO,5,2) +"/"+Left(SD2->D2_EMISSAO,4))
							@nLin,073  PSAY _dEmissao
							//@nLin,082  PSAY SD2->D2_DOC
							@nLin,089  PSAY SUBSTR(SD2->D2_CONTA,1,12) + ' '+SUBSTR(_cNomC,1,20)
							@nLin,123  PSAY SD2->D2_GRUPO
							@nLin,130  PSAY SD2->D2_QUANT         PICTURE '@E 9,999.99'
							@nLin,137  PSAY SD2->D2_VUNIT + "(-)" PICTURE '@E 99,999.99'
							@nLin,147  PSAY SD2->D2_TOTAL + "(-)" PICTURE '@E 999,999.99'
							//@nLin,161  PSAY D1_COD + ' ' + _cNom // COMENTADO PARA EXIBIR O NOME DO FORNECEDOR
							@nLin,161  PSAY D2_DOC + ' ' + _cNom
							_cNom     := ""
							_nAcumTot := _nAcumTot - SD2->D2_TOTAL
							_nTot1   := _nTot1 + D1_TOTAL
							nLin := nLin + 1
						Endif
						//
						IF (_x1Vez .or. nLin > 60)
							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							nLin := 10
							_x1Vez	:=	.F.
						ENDIF
						//
						dbSkip()
					ENDDO
					//
					// verificando se saiu do lanco mas nao imprimiu o sub-total do grupo ou conta
					//
					IF mv_par11 == 1 // quebra por grupo
						IF _nAcumTot <> 0
							@ nLin,090 PSay "Total do Grupo:"
							@ nLin,147 PSay _nAcumTot Picture '@E 9999,999.99'
							_nAcumTot := 0
							nLin := nLin + 2
						ENDIF
					ELSE   // quebra por conta contabil
						IF _nAcumTot <> 0
							nLin := nLin + 1
							@ nLin,090 PSay "Total da Conta Ctb:"
							@ nLin,147 PSay _nAcumTot Picture '@E 9999,999.99'
							_nAcumTot := 0
							nLin := nLin + 2
						ENDIF
					ENDIF
					//
					_nAcumTot   := 0
					_GrupoAnt   := ""
					_ccAnt      := ""
					_nAcumTot   := 0
					//
					IF _nTot1 <> 0
						@nLin,090  PSAY 'Total das Entradas:'
						@nLin,148  PSAY _nTot1      PICTURE '@E 999,999.99'
						nLin++
						@nLin,000 PSAY "                                                                         -------------------------------------------------------------------------------------------------------------------------------------"
						nLin++
					ENDIF
					//
				ENDIF
				//
				IF mv_par10 <> 2
					//
					dbSelectArea("XD3")
					dbGotop()
					_cPrm := 'S'
					_nTot1:= 0
					DO WHILE ! EOF()
						_dEmissao 		   := Ctod(Right(D3_EMISSAO,2) +"/"+Substr(D3_EMISSAO,5,2) +"/"+Left(D3_EMISSAO,4))
						IF (_dEmissao < _dDataMes)
							dbSkip()
							Loop
						ENDIF
						//
						IF _cPrm = 'S'
							nLin++
							@nLin,001 PSAY '   TOTAL REQ.ALMOXARIFADO ->>'
							@nLin,073 PSAY 'DATA            CONTA CONTABIL                    GRUPO     QUANT  UNITARIO     TOTAL   NF/FORNECEDOR--------------------------------'
							//01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789
							//70        80        90        100       110       120       130       140       150       160       170       180       190       200
							nLin++  //        xx/xx/xx 123456 1111111111111X
							_cPrm := 'N'
						ENDIF
						//
						dbSelectArea("CT1")  //SI1 ALTERADO PARA CT1
						dbSetOrder(1)
						dbSeek(xFilial("CT1")+XD3->D3_CONTA, .T.)
						_cNomC := CT1_DESC01
						//
						dbSelectArea("SB1")
						dbSetOrder(1)
						dbSeek(xFilial("SB1")+XD3->D3_COD,.T.)
						_cNom := B1_DESC
						//
						dbSelectArea("XD3")
						_dEmissao 		   := Ctod(Right(D3_EMISSAO,2) +"/"+Substr(D3_EMISSAO,5,2) +"/"+Left(D3_EMISSAO,4))
						_nTotReg           := D3_CUSTO1
						_TotUnt            := (XD3->D3_CUSTO1/XD3->D3_QUANT)
						
						//
						
						// +---------------------------------------------------------------------+
						// | Verifica se a quebra sera executada por conta contabil ou por grupo |
						// | e imprime o totalizador quando houver quebra definida no parametro  |
						// +---------------------------------------------------------------------+
						If mv_par11 == 1 // quebra por grupo
							If _GrupoAnt <> D3_GRUPO
								_GrupoAnt := D3_GRUPO
								If _nAcumTot <> 0
									@ nLin,090 PSay "Total do Grupo:"
									@ nLin,147 PSay _nAcumTot Picture '@E 9999,999.99'
									_nAcumTot := 0
									nLin := nLin + 1
								Endif
							Endif
						Else   // quebra por conta contabil
							If _ccAnt <> SUBSTR(D3_CONTA,1,12)
								_ccAnt := SUBSTR(D3_CONTA,1,12)
								If _nAcumTot <> 0
									nLin := nLin + 1
									@ nLin,090 PSay "Total da Conta Ctb:"
									@ nLin,147 PSay _nAcumTot Picture '@E 9999,999.99'
									_nAcumTot := 0
									nLin := nLin + 2
								Endif
							Endif
						Endif
						//
						@nLin,073  PSAY _dEmissao
						@nLin,089  PSAY SUBSTR(D3_CONTA,1,12) + ' '+ SUBSTR(_cNomC,1,20)
						@nLin,123  PSAY D3_GRUPO
						@nLin,130  PSAY D3_QUANT      PICTURE '@E 9,999.99'
						//
   						IF (D3_TM == '101' .OR. D3_TM == '499')  // VERIFICA SE E ENTRADA NO ALMOXARIFADO(DEVOLUCAO)
 							@nLin,137  PSAY _TotUnt           PICTURE '@E 99,999.99'
							@nLin,147  PSAY D3_CUSTO1         PICTURE '@E 999,999.99'
							@nLin,158  PSAY 'DV'
							_nAcumTot := _nAcumTot - D3_CUSTO1
							_nTot1 	  := _nTot1    - _nTotReg
						ELSE
							@nLin,137  PSAY _TotUnt           PICTURE '@E 99,999.99'
							@nLin,147  PSAY D3_CUSTO1         PICTURE '@E 999,999.99'
							_nAcumTot := _nAcumTot + D3_CUSTO1
							_nTot1 	  := _nTot1    + _nTotReg
						ENDIF
						//
						@nLin,161  PSAY D3_DOC + ' ' + _cNom
						nLin++
						//
						IF (_x1Vez .or. nLin > 60)
							Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
							nLin := 10
							_x1Vez	:=	.F.
						ENDIF
						//
						dbSkip()
						//
					ENDDO
					//
					// verificando se saiu do lanco mas nao imprimiu o sub-total do grupo ou conta
					//
					If mv_par11 == 1 // quebra por grupo
						If _nAcumTot <> 0
							@ nLin,090 PSay "Total do Grupo:"
							@ nLin,147 PSay _nAcumTot Picture '@E 9999,999.99'
							_nAcumTot := 0
							nLin := nLin + 2
						Endif
					Else   // quebra por conta contabil
						If _nAcumTot <> 0
							nLin := nLin + 1
							@ nLin,090 PSay "Total da Conta Ctb:"
							@ nLin,147 PSay _nAcumTot Picture '@E 9999,999.99'
							_nAcumTot := 0
							nLin := nLin + 2
						Endif
					Endif
					//
					IF _nTot1 <> 0
						@nLin,090  PSAY 'Total Req. Almoxarifado:'
						@nLin,148  PSAY _nTot1      PICTURE '@E 999,999.99'
						nLin++
						@nLin,000 PSAY "                                                                         -------------------------------------------------------------------------------------------------------------------------------------"
						nLin++
					ENDIF
				ENDIF
			ENDIF
			//
			IF mv_par09 = 2   // se for opcao analitica
				@nLin,000 PSAY "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
				nLin++
				nLin++
				nLin++
			ENDIF
			//
		ENDIF
		//
		IF mv_par10 <> 3
			XD1->(dbclosearea())
		ENDIF
		IF mv_par10 <> 2
      		XD3->(dbclosearea())
  		ENDIF
		//
		dbSelectArea("XI3")
		dbSkip()
	ENDDO
	// Total Projeto
	@nLin,000 PSAY "TOTAL PROJETO "+_cProj+":"
	@nLin,034 PSAY _nTotPrj[01][1]     		PICTURE   '@E 999,999.99'
	@nLin,045 PSAY _nTotPrj[02][1]      	PICTURE   '@E 999,999.99'
	@nLin,056 PSAY _nTotPrj[03][1]      	PICTURE   '@E 999,999.99'
	@nLin,068 PSAY _nTotPrj[04][1]      	PICTURE   '@E 999,999.99'
	@nLin,080 PSAY _nTotPrj[05][1]     		PICTURE   '@E 999,999.99'
	@nLin,093 PSAY _nTotPrj[06][1]      	PICTURE   '@E 999,999.99'
	@nLin,106 PSAY _nTotPrj[07][1]      	PICTURE   '@E 999,999.99'
	@nLin,119 PSAY _nTotPrj[08][1]      	PICTURE   '@E 999,999.99'
	@nLin,132 PSAY _nTotPrj[09][1]      	PICTURE   '@E 999,999.99'
	@nLin,145 PSAY _nTotPrj[10][1]     		PICTURE   '@E 999,999.99'
	@nLin,155 PSAY _nTotPrj[11][1]      	PICTURE   '@E 999,999.99'
	@nLin,171 PSAY _nTotPrj[12][1]      	PICTURE   '@E 999,999.99'
	@nLin,184 PSAY _nTotAcuP  	     	  	PICTURE '@E 9,999,999.99'
	nLin++
	@nLin,000 PSAY "=============================================================================================================================================================================================================="
	nLin++
	nLin++
	IF mv_par08 = 2
		_x1Vez := .T.
	ENDIF
	//
	dbSelectArea("XF8")
	dbSkip()
ENDDO
nLin++
//imprimindo daniel
@nLin,000 PSAY "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
nLin++
IF (_x1Vez .or. nLin > 55)
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin := 10
	_x1Vez	:=	.F.
	@nLin,000 PSAY "--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
	nLin++
ENDIF
//
@nLin,000 PSAY "TOTAL GERAL:"
@nLin,034 PSAY _nTotGer[01][01]    		PICTURE   '@E 999,999.99'
@nLin,045 PSAY _nTotGer[02][01]      	PICTURE   '@E 999,999.99'
@nLin,056 PSAY _nTotGer[03][01]      	PICTURE   '@E 999,999.99'
@nLin,068 PSAY _nTotGer[04][01]      	PICTURE   '@E 999,999.99'
@nLin,080 PSAY _nTotGer[05][01]      	PICTURE   '@E 999,999.99'
@nLin,093 PSAY _nTotGer[06][01]      	PICTURE   '@E 999,999.99'
@nLin,106 PSAY _nTotGer[07][01]      	PICTURE   '@E 999,999.99'
@nLin,119 PSAY _nTotGer[08][01]      	PICTURE   '@E 999,999.99'
@nLin,132 PSAY _nTotGer[09][01]      	PICTURE   '@E 999,999.99'
@nLin,145 PSAY _nTotGer[10][01]      	PICTURE   '@E 999,999.99'
@nLin,155 PSAY _nTotGer[11][01]      	PICTURE   '@E 999,999.99'
@nLin,171 PSAY _nTotGer[12][01]      	PICTURE   '@E 999,999.99'
@nLin,184 PSAY _nTotAcuG  	     	  	PICTURE '@E 9,999,999.99'

XI3->(dbclosearea())
XF8->(dbclosearea())
Roda(0,"","M")

Set Device to Screen
If aReturn[5]==1
	Set Printer to
	OurSpool(NomeRel)
Endif
Return

