#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01
#IFNDEF WINDOWS
	#DEFINE PSAY SAY
#ENDIF

User Function RFIN170()        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01   

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("WNREL,CDESC1,CDESC2,CDESC3,CSTRING,TAMANHO")
SetPrvt("LEND,TITULO,ARETURN,NOMEPROG,ALINHA,NLASTKEY")
SetPrvt("CPERG,M_PAG,LI,CFORANT,CDOCANT,NIPI")
SetPrvt("NICM,NCT,NY,LCONTINUA,LPEDCOM,ADIVERGENCIA")
SetPrvt("APEDIDOS,CPEDIDOS,DDATASAV,ACQ,CLOCDEST,CNOMEGRUPO")
SetPrvt("CABEC1,CABEC2,CABEC3,CBCONT,LIMITE,CSERIE")
SetPrvt("CIMPINC,NIMPINC,NIMPNOINC,CCAMPO,DDATABASE,CPROBLEMA")
SetPrvt("CDIV,NX,COL,NRECN,NORDER,NLIN")
SetPrvt("NCOL,AVENCTO,COLDALIAS,CSPACE,")

#IFNDEF WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 14/05/01 ==> 	#DEFINE PSAY SAY
#ENDIF
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � RFIN170  � Autor � Paulo R. Trivelatto   � Data � 02.02.00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Emissao do Boletim de Entrada                              낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � SIGACOM                                                    낢�
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             낢�
굇쳐컴컴컴컴컴컫컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛rogramador � Data   � BOPS �  Motivo da Alteracao                     낢�
굇쳐컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿘arcelo Pim.�09/02/98�05088A쿔ncluir perg. Imprime Custo Total ou Unit.낢�
굇쿝odrigo Sar.�27/05/98�11234A쿔ncluir impressao do ICMS solidario.      낢�
굇쿘arcos Simi.�24/06/98쿦XXXXX쿌certos do lay-out,Nro. NF com 12 bytes.  낢�
굇쿍runo       �15/12/98쿺elhor쿌certos da soma do total dos impostos para낢�
굇�            �        �      쿹ocalizacoes.                             낢�
굇� Edson   M. �30/03/99쿦XXXXX쿛assar o tamanho na SetPrint.             낢�
굇쿌line C.Vale�18/10/99�21163a쿔mprimir titulos de INSS                  낢�
굇쿛aulo R.Triv�02/02/00쿦XXXXX쿎onversao p/ RdMake                       낢�
굇읕컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
//Function Matr170()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Define Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel   :=""
cDesc1  :="Este programa ira emitir o Boletim de Entrada."
cDesc2  :=""
cDesc3  :=""
cString :="SF1"
tamanho :="P"
lEnd    :=.F.

titulo  :="Boletim de Entrada"
aReturn := { "Zebrado", 1,"Administracao", 1, 2, 1, "",1 }
nomeprog:="RFIN170"
aLinha  := {}
nLastKey:= 0
cPerg   :="MTR170"
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utiLizadas para Impressao do Cabecalho e Rodape    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
m_pag   := 1
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Verifica as perguntas selecionadas                           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Pergunte("MTR170",.T.)
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Variaveis utiLizadas para parametros                         �
//� mv_par01             // da Data                              �
//� mv_par02             // ate a Data                           �
//� mv_par03             // Nota De                              �
//� mv_par04             // Nota Ate                             �
//� mv_par05             // Imprime Centro Custo X Cta. Contabil �
//� mv_par06             // Imprimir o Custo ? Total ou Unit rio �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Envia controle para a funcao SETPRINT                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
wnrel:="RFIN170"
wnrel:=SetPrint(cString,wnrel,cPerg,titulo,cDesc1,cDesc2,cDesc3,.F.,"",,tamanho)

If nLastKey == 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Set Filter To
	Return
Endif

#IFDEF WINDOWS
   RptStatus({|| R170Imp()})// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==>    RptStatus({|| Execute(R170Imp)})
	Return
// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==>    Function R170Imp
Static Function R170Imp()
#ENDIF

/*
#IFDEF WINDOWS
   RptStatus({|lEnd| R170Imp()},Titulo)
#ELSE
   R170Imp()
#ENDIF

Return

複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � R170IMP  � Autor � Cristina M. Ogura     � Data � 10.11.95 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Chamada do Relatorio                                       낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � MATR170                                                    낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�

// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==> Function R170Imp
Static Function R170Imp()
*/

Li        :=80
cForAnt   :=""
cDocAnt   :=""
nIpi      :=0
nIcm      :=0
nCt       :=0
nY        :=""
lContinua :=.T.
lPedCom   :=.F.
aDivergencia:= {}
aPedidos  :={}
cPedidos  :=""
dDataSav  :=""
aCQ       :={}
cLocDest  := GetMV("MV_CQ")
cNomeGrupo:=""
cabec1    :=""
cabec2    :=""
cabec3    :=""
cbCont    :=0
Limite    := 80
cSerie    :=""
cImpInc   :=""

nImpInc   :=0
nImpNoInc :=0
cCampo    :=""

dbSelectArea("SF1")
dbSetOrder(1)
If !Empty(mv_par03)
	dbSeek(xFilial()+mv_par03,.T.)
Else
	dbSeek(xFilial(),.F.)
EndIf

SetRegua(RecCount())

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Faz manualmente porque nao chama a funcao Cabec()                 �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
@ 0,0 PSAY AvalImp(Limite)

While !Eof() .And. F1_FILIAL == xFilial() .And. SF1->F1_DOC <= mv_par04

	#IFNDEF WINDOWS
		If LastKey() == 286    //ALT_A
			lEnd := .t.
		EndIf
	#ENDIF

	If lEnd
      @PROW()+1,001 PSAY "CANCELADO PELO OPERADOR"
		Exit
	Endif

   IncRegua()

	If F1_DTDIGIT < mv_par01 .OR. F1_DTDIGIT > mv_par02
		dbSkip()
		Loop
	EndIf

	If F1_DOC < mv_par03 .or. F1_DOC > mv_par04
		dbSkip()
		Loop
	EndIf

	If ( cPaisLoc=="ARG" )
		nImpInc	:=0
		nImpNoInc:=0
		cImpInc	:=GetMv("MV_IMPINCE")
		For nY:=1 to Len(cImpInc)
			cCampo	:="SF1->F1_VALIMP" + STR(nY,1)
			If SUBS(cImpInc,nY,1)=="S"
             nImpInc   := &cCampo + nImpInc
			Else
             nImpNoInc := &cCampo + nImpNoInc
			EndIf
		Next
	EndIf
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Impressao do Cabecalho.                                      �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If Li > 20
      R170Cabec()
	EndIf
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Impressao dos itens da Nota de Entrada.                      �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SD1")
	dbSetOrder(1)
	dbSeek(xFilial()+SF1->F1_DOC+SF1->F1_SERIE+SF1->F1_FORNECE+SF1->F1_LOJA)
	nCt  		   := 1
	cDocAnt 		:= D1_DOC+D1_SERIE
	cForAnt 		:= D1_FORNECE+D1_LOJA
	aDivergencia:= {}
	aPedidos    := {}
	aCq 			:= {}
   Li := Li + 2
   fCabIten()
//   Li := fCabIten()
	While !Eof() .And. D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA == xFilial()+cDocAnt+cForAnt
      Li := Li + 1
		If Li >= 63
			Li := 1
         fCabItem()
//         Li := fCabIten()
         Li := Li + 1
		Endif
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Posiciona Todos os Arquivos Ref. ao Itens                    �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		dbSelectArea("SB1")
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_COD)

		dbSelectArea("SX5")
		dbSetOrder(1)
		dbSeek(xFilial()+"03"+SB1->B1_GRUPO)
		cNomeGrupo := SubStr(SX5->X5_DESCRI,1,10)

		dbSelectArea("SC7")
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_PEDIDO+SD1->D1_ITEMPC)
		If Found() .and. SD1->D1_COD == C7_PRODUTO
			lPedCom:=.T.
			dbSelectArea("SF4")
			dbSetOrder(1)
			dbSeek(xFilial()+SD1->D1_TES)
			dDataSav  := dDataBase
			dDataBase := SD1->D1_DTDIGIT
			cProblema := ""
         cDiv := "Q =DIF.NA QUANTIDADE / P =DIF.NO PRECO / E =DIF.DATA DE ENTREGA"
			If SC7->C7_QUANT #SD1->D1_QUANT
            cProblema := cProblema + "Q"
			Else
            cProblema := cProblema + " "
			EndIf
			If IIf(Empty(SC7->C7_REAJUSTE),SC7->C7_PRECO,Formula(SC7->C7_REAJUSTE)) #SD1->D1_VUNIT
            cProblema := cProblema + "P"
			Else
            cProblema := cProblema + " "
			EndIf
			If SC7->C7_DATPRF #SD1->D1_DTDIGIT
            cProblema := cProblema + "E"
			Else
            cProblema := cProblema + " "
			EndIf
			If !Empty(cProblema)
				AADD(aDivergencia,cProblema+" "+SC7->C7_NUM+"-"+SC7->C7_ITEM+" "+SubStr(SB1->B1_DESC,1,30)+" "+Str(SC7->C7_QUANT,11,2)+" "+Transform(IIf(Empty(SC7->C7_REAJUSTE),SC7->C7_PRECO,Formula(SC7->C7_REAJUSTE)),"@E 99,999,999.99")+" "+DTOC(SC7->C7_DATPRF))
			Else
				AADD(aPedidos,SC7->C7_NUM+"-"+SC7->C7_ITEM)
			Endif
			dDataBase := dDataSav
		Endif
		dbSelectArea("SF4")
		dbSetOrder(1)
		dbSeek(xFilial()+SD1->D1_TES)
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
		//� Inicializa array dos itens que foram enviados ao CQ (SD7)    �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
		If !Empty(SD1->D1_NUMCQ) .AND. SF4->F4_ESTOQUE == "S"
			AADD(aCQ,SD1->D1_NUMCQ+SD1->D1_COD+cLocDest+"001"+DTOS(SD1->D1_DTDIGIT))
		Endif

		@Li,00 PSAY SD1->D1_COD
		@Li,16 PSAY SD1->D1_UM
		@Li,19 PSAY SubStr(SB1->B1_DESC,1,30)
		@Li,49 PSAY SD1->D1_VUNIT Picture PesqPict("SD1","D1_VUNIT",14)
		@Li,66 PSAY SD1->D1_TOTAL Picture PesqPict("SD1","D1_TOTAL",14)
      Li := Li + 1
		@Li,00 PSAY SD1->D1_QUANT Picture PesqPictQt("D1_QUANT",15)
		@Li,17 PSAY SD1->D1_IPI	Picture PesqPict("SD1","D1_IPI",5)
		If ( cPaisLoc=="BRA" )
			@Li,23 PSAY SD1->D1_PICM  Picture PesqPict("SD1","D1_PICM",5)
		EndIf

		If mv_par05 == 1
			@Li,29 PSAY Substr(SD1->D1_CONTA,1,15)
		Else
			@Li,29 PSAY SD1->D1_CC
		EndIf
		If ( cPaisLoc=="BRA" )
			@Li,45 PSAY SD1->D1_CF
		Endif
		@Li,49 PSAY SD1->D1_TES
		If mv_par06 == 1
			@Li,55 PSAY SD1->D1_CUSTO Picture PesqPict("SD1","D1_CUSTO",14)
		Else
			@Li,55 PSAY SD1->D1_CUSTO/SD1->D1_QUANT Picture PesqPict("SD1","D1_CUSTO",14)
		Endif
		@Li,70 PSAY cNomeGrupo
      Li := Li + 1
		dbSelectArea("SD1")
		dbSkip()
	EndDo
   Li := Li + 1
	If Li >= 60
		Li := 1
	Endif
   fCabNF()
//   Li := fCabNF()

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Imprime produtos enviados ao Controle de Qualidade SD7       �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If Len(aCQ) > 0
		Li := Li+2
		If Li >= 60
			Li := 1
		Endif
      @ Li, 0 PSAY '----------------- PRODUTO(s) ENVIADO(s) AO CONTROLE DE QUALIDADE -----------------'
		//         123456789012345           99            99          dd/mm/aa
		//                   1         2         3         4         5         6
		//         0123456789012345678901234567890123456789012345678901234567890
      Li := Li + 1
      @Li,0 PSAY "Produto         Local Origem Local Destino Data Transferencia"
      Li := Li + 1
      For nX := 1 to Len(aCQ)
			dbSelectArea("SD7")
			dbSetOrder(1)
			If dbSeek(xFilial()+aCQ[nX],.F.)
            @ Li := Li + 2,00 PSAY SD7->D7_PRODUTO
				@ Li,26 PSAY SD7->D7_LOCAL
				@ Li,40 PSAY SD7->D7_LOCDEST
				@ Li,52 PSAY SD7->D7_DATA
			Endif
		Next nX
	Endif

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Imprime Divergencia com Pedido de Compra.                    �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
   Li := Li + 2
   @ Li, 0 PSAY '-------------------- DIVERGENCIAS COM O PEDIDO DE COMPRA -----------------------'
   Li := Li + 1
	IF lPedCom
		If !Empty(aPedidos)
         Li := Li + 1
			cPedidos := ""
			For nX := 1 To Len(aPedidos)
            cPedidos := cPedidos + aPedidos[nX]+"\"
			Next nX
			cPedidos := SubStr(cPedidos,1,Len(cPedidos)-1)
         @Li, 0 PSAY "Nao ha divergencias no(s) pedido(s) "+cPedidos
		EndIf
      Li := Li + 1
      @Li, 0 PSAY "COD DIVERGENCIA: "+cDiv
      Li := Li + 1
		If Len(aDivergencia) > 0
         Li := Li + 2
			If Li >= 64
				Li := 1
			Endif
         @Li,0 PSAY "Div Numero    Descricao do Produto            Quantidade Preco Unitar.  Entrega"
			//         123 123456-12 123456789012345678901234567890 99999999,99 99.999.999,99 99/99/99
			//                   1         2         3         4         5         6         7
			//         01234567890123456789012345678901234567890123456789012345678901234567890123456789
		EndIf

		For nX := 1 to Len(aDivergencia)
         Li := Li + 1
			If Li >= 64
				Li := 1
			Endif
			@Li, 0 PSAY aDivergencia[nX]
		Next nX
	Else
		If !Empty(aPedidos)
         Li := Li + 1
			cPedidos := ""
			For nX := 1 To Len(aPedidos)
            cPedidos := cPedidos + aPedidos[nX]+"\"
			Next nX
			cPedidos := SubStr(cPedidos,1,Len(cPedidos)-1)
         @Li, 0 PSAY "Nao ha divergencias no(s) pedido(s) "+cPedidos
		Else
         Li := Li + 1
         @Li, 0 PSAY "Nao ha Pedidos"
		Endif
	EndIF

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Imprime desdobramento de Duplicatas.                         �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	dbSelectArea("SE2")
	dbSetOrder(6)

   cSerie := GETMV("MV_2DUPREF")
	cSerie := IIF(Len(cSerie) < 3, cSerie+Space(3 - Len(cSerie)), Substr(cSerie,1,3))

	If dbSeek(xFilial("SF1")+SF1->F1_FORNECE+SF1->F1_LOJA+cSerie+SF1->F1_DOC,.F.)
      Li := Li + 2
		If Li >= 62
			Li := 1
		Endif
		Li := fCabDup(Li)
		Col := 0
		While !Eof() .And. (E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM == xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+cSerie+SF1->F1_DOC)

			If cPaisLoc=="BRA"
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				//� Imprime dados das duplicatas para Nf com 06 bytes.          �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				If Li >= 62
					Li := 1
					Li := fCabDup(Li)
				Endif

				@Li,Col PSAY SE2->E2_PREFIXO+" "+SE2->E2_NUM+' '+SE2->E2_PARCELA+'  '+dtoc(SE2->E2_VENCTO)+Transform(SE2->E2_VALOR,'@E 99,999,999,999.99')
				If Col == 0
					Col := 41
				Else
					Col := 0
               Li := Li + 1
				EndIf

				R170ImpIR( @Li,@Col )
				R170ImpIN( @Li,@Col )
			Else
				//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				//� Imprime dados das duplicatas para Nf com 12 bytes.          �
				//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
				If Li >= 62
					Li := 1
					Li := fCabDup(Li)
				Endif

				@Li,0 PSAY SE2->E2_PREFIXO+" "+SE2->E2_NUM+' '+SE2->E2_PARCELA+'  '+dtoc(SE2->E2_VENCTO)+Transform(SE2->E2_VALOR,'@E 99,999,999,999.99')

            Li := Li + 1

				R170ImpIR( @Li, 0 )
				R170ImpIN( @Li, 0 )

			Endif

			dbSkip()
		EndDo
	Endif

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//� Imprime Dados do Livros Fiscais.                             �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
	If ( cPaisLoc=="BRA") //Provisorio, Bruno
		dbSelectArea("SF3")
		dbSetOrder(4)
		If dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE,.F.)
         Li := Li + 2
			If Li >= 58
				Li := 1
			Endif
			Li := fCabLiv(Li)
			While ! Eof() .And. ;
					xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_DOC+SF1->F1_SERIE==F3_FILiAL+F3_CLiEFOR+F3_LOJA+F3_NFISCAL+F3_SERIE

				If Li >= 58
					Li := 1
					Li := fCabLiv(Li)
				Endif

            Li := Li + 2
            @Li,01 PSAY "Valor Contabil:"
				@Li,16 PSAY SF3->F3_VALCONT	Picture "@E 999,999,999,999.99"
            @Li,54 PSAY "Classificacao Fiscal:"
				@Li,76 PSAY SF3->F3_CFO
            Li := Li + 2
				@Li, 0 PSAY 'ICM'
				@Li,04 PSAY SF3->F3_BASEICM	Picture "@E 999,999,999,999.99"
				@Li,23 PSAY SF3->F3_ALIQICM   Picture "99"
				@Li,26 PSAY SF3->F3_VALICM		Picture "@E 99,999,999,999.99"
				@Li,44 PSAY SF3->F3_ISENICM	Picture "@E 999,999,999,999.99"
				@Li,63 PSAY SF3->F3_OUTRICM	Picture "@E 9,999,999,999.99"
            Li := Li + 1
				If ! EMPTY(SF3->F3_ICMSRET)
					@Li,63 PSAY SF3->F3_ICMSRET	Picture "@E 9,999,999,999.99"
               Li := Li + 1
				Endif
            Li := Li + 1
				If ! EMPTY(SF3->F3_ICMSCOM)
					@Li,63 PSAY SF3->F3_ICMSCOM Picture "@E 9,999,999,999.99"
               Li := Li + 1
				Endif
				@Li, 0 PSAY 'IPI'
				@Li,04 PSAY SF3->F3_BASEIPI	Picture "@E 999,999,999,999.99"
				@Li,26 PSAY SF3->F3_VALIPI		Picture "@E 99,999,999,999.99"
				@Li,44 PSAY SF3->F3_ISENIPI	Picture "@E 999,999,999,999.99"
				@Li,63 PSAY SF3->F3_OUTRIPI	Picture "@E 9,999,999,999.99"
            Li := Li + 1
				If SF3->F3_IPIOBS>0
					@Li,63 PSAY SF3->F3_IPIOBS Picture "@E 9,999,999,999.99"
				Endif

				If !Empty(SF1->F1_CONTSOC)
               LI := Li + 1
					@LI,00 PSAY SF3->F3_OBSERV
               LI := Li + 1
				Endif

				dbSkip()
			EndDo
		Endif
	Endif

	If Li < 60
		Li := 60
	Endif

   @Li,0 PSAY '------------------------------------ VISTOS ------------------------------------'
   Li := Li + 1
	@Li,0 PSAY '                     |                   |                   |'
   Li := Li + 1
	@Li,0 PSAY '--------------------------------------------------------------------------------'
	dbSelectArea("SF1")
	dbSkip()

EndDO

dbSelectArea("SF1")
Set Filter To
dbSetOrder(1)

Set device to Screen
If aReturn[5] == 1
	Set Printer TO
	dbcommitAll()
	ourspool(wnrel)
Endif

MS_FLUSH()

Return
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � R170ImpIR() � Autor 쿍en-Hur M Castilho  � Data � 03/05/96 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Impressao do Titulo de IR no Desdobramento de Duplicatas   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � R170ImpIR( ExpN1,ExpN2 )                                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros� ExpN1 - Linha da Impressao                                 낢�
굇�          � ExpN2 - Coluna da Impressao                                낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==> Function R170ImpIR
Static Function R170ImpIR()

nRecN  := 0
nOrder := 0

If !Empty(SE2->E2_IRRF )

	nRecN  := RecNo()
	nOrder := IndexOrd()

	dbSetOrder(1)
   If dbSeek(xFilial()+SE2->E2_PREFIXO+SE2->E2_NUM+SE2->E2_PARCIR+"TX ",.F.)
		If nLin >= 62
			nLin := 1
         nLin := fCabDup()
		Endif
		@nLin,nCol PSAY SE2->E2_PREFIXO+" "+SE2->E2_NUM+' '+SE2->E2_PARCELA+'  '+dtoc(SE2->E2_VENCTO)+Transform(SE2->E2_VALOR,'@E 999,999,999.99')+" IR"
		If cPaisLoc=="BRA"
			If nCol == 0
				nCol := 41
			Else
				nCol := 0
            nLin := Li + 1
			EndIf
		Else
         nLin := Li + 1
		Endif
	EndIf

	dbSetOrder(nOrder)
	dbGoTo(nRecN)
EndIf

Return
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � R170ImpIN() � Autor 쿌line Correa do Vale� Data � 18/10/99 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Impressao do Titulo de INSS no Desdobramento de Duplicatas 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � R170ImpIN( ExpN1,ExpN2 )                                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛arametros� ExpN1 - Linha da Impressao                                 낢�
굇�          � ExpN2 - Coluna da Impressao                                낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==> Function R170ImpIN       //(nLin,nCol)
Static Function R170ImpIN       //(nLin,nCol)()

nRecN  := RecNo()
nOrder := IndexOrd()

If !Empty( E2_INSS )
	dbSetOrder(1)
	If dbSeek(xFilial()+E2_PREFIXO+E2_NUM+E2_PARCINS+"INS",.F.)
		If nLin >= 62
			nLin := 1
			nLin := fCabDup(nLin)
		Endif
		@nLin,nCol PSAY SE2->E2_PREFIXO+" "+SE2->E2_NUM+' '+SE2->E2_PARCELA+'  '+dtoc(SE2->E2_VENCTO)+Transform(SE2->E2_VALOR,'@E 999,999,999.99')+" INSS"
		If cPaisLoc=="BRA"
			If nCol == 0
				nCol := 41
			Else
				nCol := 0
            nLin := nLin + 1
			EndIf
		Else
         nLin := nLin + 1
		Endif
	EndIf

	dbSetOrder(nOrder)
	dbGoTo(nRecN)
EndIf

Return(NIL)
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � fCabIten()  � Autor �                    � Data � 19.11.93 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Cabecalho de Itens.                                        낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � fCabNF()                                                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==> Function fCabIten
Static Function fCabIten()

@Li, 0 PSAY "----------------------------- DADOS DA NOTA FISCAL -----------------------------"
Li := Li + 1
@Li, 0 PSAY "Codigo Material UN Descricao da Mercadoria       Valor Unitario      Valor Total"
Li := Li + 1
@Li, 0 PSAY "Quantidade         IPI  ICM  " + IIF(mv_par05 == 1,"Cta Contabil    ","Centro de Custo ") + IIF(mv_par06 == 2 ,"CFO TE    Custo Unitario Grupo","CFO TE       Custo Total Grupo")
Li := Li + 1
@Li, 0 PSAY RepLi('-',80)

Return
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � fCabNF()    � Autor �                    � Data � 19.11.93 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Dados Totais da Nota Fiscal.                               낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � fCabIten()                                                 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==> Function fCabNF
Static Function fCabNF()

dbSelectArea("SF1")

@Li,  0 PSAY repLi('-',80)
Li := Li + 1
@Li,  0 PSAY "Valor Mercadoria "
@Li, 18 PSAY SF1->F1_VALMERC 			Picture '@E 999,999,999,999.99'
@Li, 37 PSAY "ICM"
If ( cPaisLoc=="BRA" )
	@Li, 41 PSAY SF1->F1_VALICM			Picture '@E 99,999,999,999.99'
Else
	@Li, 41 PSAY nImpNoInc					Picture '@E 99,999,999,999.99'
EndIf

@Li, 59 PSAY "IPI"

If ( cPaisLoc=="ARG" )
	@Li, 64 PSAY nImpInc			Picture '@E 9,999,999,999.99'
Else
	@Li, 64 PSAY SF1->F1_VALIPI			Picture '@E 9,999,999,999.99'
EndIf
Li := Li + 1

If SF1->F1_ICMSRET > 0
   @Li,  0 PSAY "ICMS Solid."
	@Li, 18 PSAY SF1->F1_ICMSRET Picture '@E 999,999,999,999.99'
   Li := Li + 1
Endif

If SF1->F1_CONTSOC > 0
   @Li,  0 PSAY "Desp. Acessorias"
	@Li, 18 PSAY (SF1->F1_DESPESA+SF1->F1_FRETE) 	Picture '@E 999,999,999,999.99'
   @Li, 37 PSAY "Contr.Seguridade Social"
	@LI, 64 PSAY SF1->F1_CONTSOC 							Picture '@E 9,999,999,999.99'
Else
   @Li,  0 PSAY "Desp. Acessorias"
	@Li, 18 PSAY (SF1->F1_DESPESA+SF1->F1_FRETE) 	Picture '@E 999,999,999,999.99'
Endif

Li := Li + 1
@Li, 0 PSAY "Descontos "
@Li,18 PSAY SF1->F1_DESCONT 																						Picture '@E 999,999,999,999.99'
@Li,37 PSAY "Valor Total da Nota"
If ( cPaisLoc=="ARG" )
   @Li,60 PSAY (SF1->F1_VALMERC+SF1->F1_DESPESA+SF1->F1_FRETE-SF1->F1_DESCONT+nImpInc) 	Picture '@E 999,999,999,999.99'
Else
	@Li,60 PSAY (SF1->F1_VALMERC+If(SF1->F1_TIPO=="P",0,SF1->F1_VALIPI)+SF1->F1_DESPESA+SF1->F1_FRETE+SF1->F1_ICMSRET-SF1->F1_DESCONT) 	Picture '@E 999,999,999,999.99'
EndIf

Return
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � fCabDup()   � Autor �                    � Data � 19.11.93 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Impressao de Desdobramento de DupLicatas.                  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � fCabDup()		                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==> Function fCabDup         //(Li)
Static Function fCabDup         //(Li)()

If cPaisLoc=="BRA"
   @Li, 0 PSAY '------------------------ DESDOBRAMENTO DE DUPLICATAS ---------------------------'
   Li := Li + 1
   @Li, 0 PSAY "Ser Titulo PC Vencmnto  Valor do Titulo  Ser.Titulo PC Vencmnto  Valor do Titulo"
   Li := Li + 1
Else
   @Li, 0 PSAY '------------------------ DESDOBRAMENTO DE DUPLICATAS ---------------------------'
   Li := Li + 1
   @Li, 0 PSAY "Ser Titulo       PC Vencmnto  Valor do Titulo "
   Li := Li + 1
Endif

Return
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � fCabLiv()   � Autor �                    � Data � 19.11.93 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Impressao de Demonstrativos dos Livros Fiscais.            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � fCabLiv()		                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==> Function fCabLiv        //(Li)
Static Function fCabLiv        //(Li)()

@Li,0 PSAY '--------------------- DEMONSTRATIVO DOS LIVROS FISCAIS -------------------------'
Li := Li + 2
@Li,08 PSAY 'Operacoes c/ credito de Imposto        Operacoes s/ credito de Imposto'
Li := Li + 1
@Li,09 PSAY 'Base de     ALiq.     Imposto            Isentas         Outras'
Li := Li + 1
@Li,09 PSAY 'Calculo              Creditado                              Obsevacoes'

Return(Li)
/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴컴컫컴컴컴컫컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑un뇚o    � R170Cabec() � Autor � Jose Lucas         � Data � 19.11.93 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컨컴컴컴컨컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Imprime cabecalho do Boletim.                              낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � A170Cabec()		                                            낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Generico                                                   낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/
// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==> Function R170Cabec
Static Function R170Cabec()

aVencto  := {}
cOldAlias:= "" 
cSpace   := IF(Len(DTOC(SF1->F1_EMISSAO))==8," ","")
cSerie   := ""

If SF1->F1_TIPO $ "DB"
	dbSelectArea("SE1")
	dbSetOrder(2)
	dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC)
   Do While !Eof() .And. E1_FILIAL+E1_CLIENTE+E1_LOJA+E1_PREFIXO+E1_NUM == xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+SF1->F1_SERIE+SF1->F1_DOC
		AADD(aVencto,E1_VENCTO)
		dbSkip()
   EndDo
	Li := 01
   @Li,0 PSAY 'BOLETIM DE ENTRADA      Material recebido em: '+dtoc(SF1->F1_DTDIGIT)+IIf( SF1->F1_TIPO == 'D'," - (Devolucao)","")
   Li := Li + 1
	@li,0 PSAY SM0->M0_NOME + "-" + SM0->M0_FILIAL
   Li := Li + 1
	@Li,0 PSAY Replicate('-',80)
   Li := Li + 1
	dbSelectArea("SA1")
	dbSetOrder(1)
	dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA)

	If cPaisLoc=="BRA"
      @Li,0 PSAY 'CLiente                                      | Nota Fiscal  | Emissao  | Vencto'
      Li := Li + 1
		@Li, 0 PSAY SUBS(SA1->A1_NOME,1,27)+' '+SA1->A1_COD
		@Li,43 PSAY '| '+SF1->F1_SERIE+' '+SF1->F1_DOC
		@Li,58 PSAY '|'+cSpace+DTOC(SF1->F1_EMISSAO)+cSpace+'|'
	Else
      @Li,0 PSAY 'CLiente                                      | Nota Fiscal  | Emissao  | Vencto'
      Li := Li + 1
		@Li, 0 PSAY SUBS(SA1->A1_NOME,1,29)+' '+SA1->A1_COD
		@Li,39 PSAY '| '+SF1->F1_SERIE+' '+SF1->F1_DOC
		@Li,60 PSAY '| '+DTOC(SF1->F1_EMISSAO)+' |'
	Endif

	cOldAlias:=Alias()
	dbSelectArea("SE2")
	dbSetOrder(6)

	cSerie := &(GETMV("MV_2DUPREF"))
	cSerie := IIF(Len(cSerie) < 3, cSerie+Space(3 - Len(cSerie)), Substr(cSerie,1,3))

	If dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+cSerie+SF1->F1_DOC,.F.)
      @Li,70 PSAY cSpace+IIf( Len(aVencto) == 1, DTOC(aVencto[1]),"Diversos" )
	EndIf
	dbSelectArea(cOldAlias)
   Li := Li + 1
	@Li,0 PSAY Substr(SA1->A1_END,1,29)
   @Li,45-IIf(cPaisLoc=="BRA",0,6) PSAY '| Valor Total   '+transform((SF1->F1_VALMERC+SF1->F1_VALiPI+SF1->F1_DESPESA+SF1->F1_FRETE-SF1->F1_DESCONT),"@E 99,999,999,999.99")
   Li := Li + 1
	@Li,0 PSAY SA1->A1_MUN+' '+SA1->A1_EST+' '+transform(SA1->A1_CGC,"@R 99.999.999/9999-99")
Else
	dbSelectArea("SE2")
	dbSetOrder(6)

   cSerie := GETMV("MV_2DUPREF")
	cSerie := IIF(Len(cSerie) < 3, cSerie+Space(3 - Len(cSerie)), Substr(cSerie,1,3))

	dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+cSerie+SF1->F1_DOC)
	While !Eof() .And. E2_FILIAL+E2_FORNECE+E2_LOJA+E2_PREFIXO+E2_NUM == xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+cSerie+SF1->F1_DOC
		AADD(aVencto,E2_VENCTO)
		dbSkip()
	End
	Li := 01
   @Li,0 PSAY 'BOLETIM DE ENTRADA      Material recebido em: '+dtoc(SF1->F1_DTDIGIT)+IIf( SF1->F1_TIPO == 'D'," - (Devolucao)","")
   Li := Li + 1
	@li,0 PSAY SM0->M0_NOME + "-" + SM0->M0_FILIAL
   Li := Li + 1
	@Li,0 PSAY Replicate('-',80)
   Li := Li + 1

	dbSelectArea("SA2")
	dbSetOrder(1)
	dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA)

	If cPaisLoc=="BRA"
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//� Imprime dados das duplicatas para Nf com 06 bytes.          �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
      @Li,0 PSAY 'Fornecedor                                 | Nota Fiscal  | Emissao  |  Vencto'
      Li := Li + 1
		@Li,00 PSAY SUBS(SA2->A2_NOME,1,32)+' '+SA2->A2_COD
		@Li,43 PSAY '| '+SF1->F1_SERIE+' '+SF1->F1_DOC
		@Li,58 PSAY '|'+cSpace+DTOC(SF1->F1_EMISSAO)+cSpace+'|'
	Else
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//� Imprime dados das duplicatas para Nf com 12 bytes.          �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
      @Li,0 PSAY 'Fornecedor                                   | Nota Fiscal  | Emissao  | Vencto'
      Li := Li + 1
		@Li,00 PSAY SUBS(SA2->A2_NOME,1,29)+' '+SA2->A2_COD
		@Li,39 PSAY '| '+SF1->F1_SERIE+' '+SF1->F1_DOC
		@Li,60 PSAY '| '+DTOC(SF1->F1_EMISSAO)+' |'
	Endif

	cOldAlias:=Alias()
	dbSelectArea("SE2")
	dbSetOrder(6)
	If dbSeek(xFilial()+SF1->F1_FORNECE+SF1->F1_LOJA+cSerie+SF1->F1_DOC,.F.)
		@Li,70 PSAY cSpace+IIf( Len(aVencto) == 1, DTOC(aVencto[1]),"Diversos" )
	EndIf

	dbSelectArea(cOldAlias)
   Li := Li + 1
	@Li,0 PSAY Substr(SA2->A2_END,1,35)
   @Li,45-IIf(cPaisLoc=="BRA",0,6) PSAY '| Valor Total   '+Transform(IIf(cPaisLoc=="BRA",(SF1->F1_VALMERC+SF1->F1_VALiPI+SF1->F1_DESPESA+SF1->F1_FRETE-SF1->F1_DESCONT),(SF1->F1_VALMERC+nImpInc+SF1->F1_DESPESA+SF1->F1_FRETE-SF1->F1_DESCONT)),"@E 9,999,999,999.99")
   Li := Li + 1
	@Li,0 PSAY SA2->A2_MUN+' '+SA2->A2_EST+' '+Transform(SA2->A2_CGC,Iif(cPaisLoc=="ARG","@R 99-99.999.999-9","@R 99.999.999/9999-99"))
EndIf

Return
