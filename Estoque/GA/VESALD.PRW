#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01

User Function VESALD()        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01  

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Verifica saldo do Produto no Almoxarifado e mostra alerta')

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CRET,_NPPRODUTO,_NPLOCAL,_NPQTDVEN,X,_CPRODUTO")
SetPrvt("_CLOCAL,_NQTDVEN,_CALIAS,_NINDEX,_NREC,_CALIASB2")
SetPrvt("_NINDEXB2,_NRECB2,_CMENS,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿑uncao    � VESALD   � Autor � Rogerio Nutti         � Data � 29.11.00 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escricao � Verifica saldo do Produto no Almoxarifado e mostra alerta  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿚bs       � Alerta p/ preparar entradas Almoxarifado antes de faturar  낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿢so       � Especifico Ad'oro Alimenticia                              낢�
굇읕컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Cria variavel de retorno                                     �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_cRet := Space(15)

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Determina as posicoes dos campos do SD3 no browse            �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_npProduto := 0
_npLocal   := 0
_npQtdVen  := 0
For x:=1 To Len(aHeader)
	Do Case
		Case (AllTrim(aHeader[x][2])=="D3_COD")
			_npProduto := x
		Case (Alltrim(aHeader[X][2])=="D3_LOCAL")
			_npLocal   := x
		Case (Alltrim(aHeader[X][2])=="D3_QUANT")
			_npQtdVen  := x
	EndCase
Next

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Atribui conteudos da matriz de SD3 a outras variaveis        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_cProduto := aCols[n,_npProduto]
_cLocal   := aCols[n,_npLocal]
_nQtdVen  := aCols[n,_npQtdVen]

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Salva Integridade Inicial                                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_cAlias  := Alias()
_nIndex  := IndexOrd()
_nRec    := Recno()

dbSelectArea("SB2")
_cAliasB2  := Alias()
_nIndexB2  := IndexOrd()
_nRecB2    := Recno()


If dbSeek( xFilial("SB2") +  _cProduto + _cLocal )
    _cMens := "Saldo em estoque do Produto "+Alltrim(_cProduto)+"  /  Almoxarifado "+Alltrim(_cLocal)+"."+chr(13)
	_cMens := _cMens+ OemToAnsi("Quantidade disponivel: " + Alltrim(Subs(Str(B2_QATU,12,2),1,9))) + Chr(13)
    MsgBox(_cMens,OemToAnsi("Atencao"),"INFO")

Else
    _cMens := "Produto "+Alltrim(_cProduto)+"/Almoxarifado "+Alltrim(_cLocal)+"."+chr(13)
	_cMens := _cMens+ "Nao encontrado no SB2" + Chr(13)
    MsgBox(_cMens,OemToAnsi("Atencao"),"INFO")
Endif

dbSelectArea(_cAliasB2)
dbSetOrder(_nIndexB2)
dbGoto(_nRecB2)

dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoto(_nRec)

// Substituido pelo assistente de conversao do AP5 IDE em 14/05/01 ==> __Return(_cProduto)
Return(_cProduto)        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01
