#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function FA290
	Ponto Entrada para grava��o do c�digo de barras e linha digit�vel no momento da gera��o da fatura
	@type  Function
	@author Davi Jesus
	@since 31/07/2007
	@history chamado 054608 - FWNM           - 06/01/2020 - OS 056001 || FINANCAS || ANA || 8384 || DESDOBRAMENTO (Error log quando fatura gera 2 ou + t�tulos)
	@history Ticket 4220    -  William Costa - 16/11/2020 - Gravar o campo E2_LOGDTHR 
	@history Ticket  429    - Abel Babini - 14/11/2020 - Atualizar os dados banc�rios do fornecedor da fatura com os dados banc�rios do cadastro do fornecedor
	@history Ticket 6543    - Abel Babini - 14/12/2020 - Ajuste nos campos de informa��es banc�rias do fornecedor no t�tulo a pagar
	@history Ticket 6543    - Abel Babini - 14/12/2020 - Ajuste nos campos de informa��es banc�rias do fornecedor no t�tulo a pagar
	@history Ticket 83514 - 17/11/2022 - Fernando Macieira - TABELA SE2 - COM ITEM ERRADO
/*/
User Function FA290()                                       

	Local aAreaAnt  := GetArea()
	Local cAntes    := "AFI290" //SX1->X1_GRUPO // Chamado n. 054608 || OS 056001 || FINANCAS || ANA || 8384 || DESDOBRAMENTO - FWNM - 06/01/2020
	Local cPar01    := "" //MV_PAR01  // Chamado n. 054608 || OS 056001 || FINANCAS || ANA || 8384 || DESDOBRAMENTO - FWNM - 06/01/2020
	Local nCont     := 0
	Local nPrefixo  := 0
	Local nNum      := 0
	Local nParcela  := 0
	Local nTipo     := 0
	Local _cAlias   := ''
	Local _cIndex   := ''
	Local _cRecno   := ''
	Local lContabOn := .F.
	Local cItemCta  := GetMV("MV_#CTD0B",,"125") // // @history Ticket 83514 - 17/11/2022 - Fernando Macieira - TABELA SE2 - COM ITEM ERRADO

	Pergunte(cAntes, .f.)
	cPar01 := MV_PAR01

	Private cPerg   := "CODBAR"
	
	lContabOn := IIF(MV_PAR03,.T.,.F.)
	
	//CriaSX1(cPerg)
	
	Pergunte(cPerg,.T.)
	
	_cAlias  := Alias()
	_cIndex  := IndexOrd()
	_cRecno  := Recno()

	nPrefixo := Ascan(aHeader,{|x| Trim(x[2]) == "E2_PREFIXO"})
	nNum     := Ascan(aHeader,{|x| Trim(x[2]) == "E2_NUM"})
	nParcela := Ascan(aHeader,{|x| Trim(x[2]) == "E2_PARCELA"})
	nTipo    := Ascan(aHeader,{|x| Trim(x[2]) == "E2_TIPO"})
	
	FOR nCont:=1 TO LEN(aCols)
	
		DBSELECTAREA("SE2")
		DBGOTOP()
		DBSETORDER(1) 	
				
		IF DBSEEK(FwXfilial("SE2")+aCols[nCont][nPrefixo] + aCols[nCont][nNum] + aCols[nCont][nParcela] + aCols[nCont][nTipo],.T.)
	
			RecLock("SE2",.F.)
			
				SE2->E2_CODBAR:=MV_PAR01
				
				//GRAVA O ITEM CONTABIL
				IF (SE2->E2_FILIAL$"01/02")

					SE2->E2_ITEMD:="121"
					SE2->E2_ITEMC:="121"

				ELSEIF (SE2->E2_FILIAL="03")

					SE2->E2_ITEMD:="114"
					SE2->E2_ITEMC:="114"

				ELSEIF (SE2->E2_FILIAL="07") //incluido por Adriana em 22/09/2014 para filial 07 - chamado 020321

					SE2->E2_ITEMD:="123"
					SE2->E2_ITEMC:="123"

				ELSE

					SE2->E2_ITEMD:="112"
					SE2->E2_ITEMC:="112"

				ENDIF    

				// @history Ticket 83514 - 17/11/2022 - Fernando Macieira - TABELA SE2 - COM ITEM ERRADO
				If (AllTrim(FWCodFil())=="0B" .or. FWxFilial("SE2")=="0B") .and. AllTrim(FWCodEmp()) == "01"
					SE2->E2_ITEMC := cItemCta
					SE2->E2_ITEMD := cItemCta
				EndIf
				//

				//GRAVA A CONTA CONTABIL
				SE2->E2_DEBITO:=POSICIONE("SED",1,XFILIAL("SED")+SE2->E2_NATUREZ,"ED_CONTA")

				//Ticket  429    - Abel Babini - 13/11/2020 - Atualizar os dados banc�rios do fornecedor da fatura com os dados banc�rios do cadastro do fornecedor
				IF SA2->( MsSeek( xFilial( "SA2" ) + SE2->E2_FORNECE + SE2->E2_LOJA ) )
					SE2->E2_CREDIT	:= SA2->A2_CONTA
					SE2->E2_BANCO	:= SA2->A2_BANCO 			//Ticket 6543    - Abel Babini - 13/12/2020 - Ajuste nos campos de informa��es banc�rias do fornecedor no t�tulo a pagar
					SE2->E2_AGEN	:= SA2->A2_AGENCIA 		//Ticket 6543    - Abel Babini - 13/12/2020 - Ajuste nos campos de informa��es banc�rias do fornecedor no t�tulo a pagar
					SE2->E2_DIGAG	:= SA2->A2_DIGAG 			//Ticket 6543    - Abel Babini - 13/12/2020 - Ajuste nos campos de informa��es banc�rias do fornecedor no t�tulo a pagar
					SE2->E2_NOCTA	:= SA2->A2_NUMCON 		//Ticket 6543    - Abel Babini - 13/12/2020 - Ajuste nos campos de informa��es banc�rias do fornecedor no t�tulo a pagar
					SE2->E2_DIGCTA:= SA2->A2_DIGCTA 		//Ticket 6543    - Abel Babini - 13/12/2020 - Ajuste nos campos de informa��es banc�rias do fornecedor no t�tulo a pagar
				ENDIF

				//Incluido 29/08/11 - Ana. Pois, ap�s atualiza��o do campo E2_PARCELA de tamanho 1 para 3, as parcelas da fatura passaram a serem geradas como "00A", "00B", "00C". Onde o correto ?apenas
				// gravar a letra, sem os "00" iniciais.                                                                                            
				IF Substr(SE2->E2_PARCELA,1,2) == "00"

					SE2->E2_PARCELA := Substr(SE2->E2_PARCELA,3,3)

				ENDIF
				
				SE2->E2_DATALIB := DDatabase
				SE2->E2_HIST    := Alltrim(SE2->E2_HIST) + ' FA290'  // Ricardo Lima - 05/06/18

				// Se a contabilizacao for On Line marca o titulo que ja contabilizou
				IF lContabOn == .T.

					SE2->E2_LA := 'S'

				ENDIF

				SE2->E2_LOGDTHR	:= IIF(EMPTY(SE2->E2_LOGDTHR),DTOC(DATE()) + ' ' + TIME(),SE2->E2_LOGDTHR)
			  
			SE2->(MsUnlock())
			
		ENDIF

	NEXT
	
	//Volto a posi��o de chamada
	DBSELECTAREA(_cAlias)
	DBSETORDER(_cIndex)
	DBGOTO(_cRecno)
	RestArea(aAreaAnt)

	Pergunte(cAntes, .F.)
	MV_PAR01 := cPar01

RETURN 

/*/{Protheus.doc} Static Function CriaSX1
	Mensagem codigo barras inv�lido
	@type  Function
	@author Davi Jesus
	@since 31/07/2007	
/*/
// @history Ticket 70142  - Rodrigo / Flek Solution - 07/07/2022 - Ajustes Dic. de dados no Banco
/*
STATIC FUNCTION CriaSx1(cPerg)

	Local j := 0
	Local nY := 0
	Local aAreaAnt := GetArea()
	Local aReg := {}

	//aAdd(aReg,{cPerg,"01","Linha Dig. ?","mv_ch1","C", 48,0,0,"G","","mv_par01","","","","","","","","","","","","","","",""})
	aAdd(aReg,{cPerg,"01","Cod. Barras ?","mv_ch2","C",44,0,0,"G","U_MSG()","mv_par01","","","","","","","","","","","","","","",""})
	aAdd(aReg,{"X1_GRUPO","X1_ORDEM","X1_PERGUNT","X1_VARIAVL","X1_TIPO","X1_TAMANHO","X1_DECIMAL","X1_PRESEL","X1_GSC","X1_VALID","X1_VAR01","X1_DEF01","X1_CNT01","X1_VAR02","X1_DEF02","X1_CNT02","X1_VAR03","X1_DEF03","X1_CNT03","X1_VAR04","X1_DEF04","X1_CNT04","X1_VAR05","X1_DEF05","X1_CNT05","X1_F3"})

	dbSelectArea("SX1")
	dbSetOrder(1)
	For ny:=1 to Len(aReg)-1
		If !dbSeek(aReg[ny,1]+aReg[ny,2])
			RecLock("SX1",.T.)
			For j:=1 to Len(aReg[ny])
				FieldPut(FieldPos(aReg[Len(aReg)][j]),aReg[ny,j])
			Next j
			MsUnlock()
		EndIf
	Next ny

	RestArea(aAreaAnt)

RETURN(NIL)
*/

/*/{Protheus.doc} User Function MSG
	Mensagem codigo barras inv�lido
	@type  Function
	@author Davi Jesus
	@since 31/07/2007	
/*/

USER FUNCTION MSG()

	IF(LEN(ALLTRIM(MV_PAR01))<>44 .AND. !EMPTY(MV_PAR01),(ALERT("C�digo de Barras Inv�lido. Informe o c�digo de barras ou linha digit�vel diretamente no t�tulo."),.F.),.T.)

RETURN()
