#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/08/02
#include "topconn.ch"

User Function AD0067()        // incluido pelo assistente de conversao do AP5 IDE em 13/08/02

//teste vss
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � AD0067   � Autor � Gustavo Gonela        � Data � 08/09/03 ���
�������������������������������������������������������������������������Ĵ��
���          �Uso Logistica                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

_sAlias := Alias()
_nOrder := IndexOrd()
_sRec   := Recno()

//��������������������������������������������������������������Ŀ
//� Variaveis                                                    �
//����������������������������������������������������������������
Private aHeader  := {}
Private aCols    := {}
Private cTitulo := "Atualizacao das Cidades de Frete"
Private aC:={}
Private aR:={}

Private _cZV9COD
Private _cZV9REGIAO
Private _dZV9DTVAL
Private _nZV9VLTON
Private _nZV9VLTK
Private _nZV9VLTC
_cCod	:= space(4)
 
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Do Roteiro                           �
//� 									                         �
//� mv_par03             // Da Emissao                           �
//� mv_par04             // Ate Emissao                          �
//����������������������������������������������������������������
//��������������������������������������Ŀ
//� Verifica as perguntas                �
//����������������������������������������

//cPerg   := "AD0067"
//Pergunte(cPerg,.t.)

//��������������������������������������������������������������Ŀ
//� Monta GetDados ( aHeader, aC, aR e aCols )                   �
//����������������������������������������������������������������
MsAguarde( { || u_Monta() }, "Aguarde", "Selecionando os Itens....", .F. )

//��������������������������������������������������������������Ŀ
//� Verifica se ha' dados para serem exibidos e alterados        �
//����������������������������������������������������������������
//If Empty( aCols)
//	MsgStop( "Nao existem dados para estes parametros  " )
//	dbSelectArea(_sAlias)
//	dbSetOrder( _nOrder )
//	dbGoto(_sRec)
//	Return
//Endif

//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 1) 3,4 - Permitem alterar getdados e incluir linhas
// 2) 6   - So permite alterar getdados e nao incluir linhas
// 3)     - Qualquer outro numero so visualiza
nOpcx  := 3

//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������

// aCGD    := {15,5,128,315}              // Tela do GetDados
aCGD    := {15,5,178,230}              // Tela do GetDados

//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������
// lRetMod2 = .T. se confirmou
// lRetMod2 = .F. se cancelou

// Alteracao RNUTTI
// lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,{125,0,500,600},)
//           Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLineOk,cAllOk,aGetsGD,bF4,cIniCpos,nMax,aCordW,lDelGetD)
//           aCordW  := {125,0,400,635}   // Tela de Fora (dos botoes) PADRAO MICROSIGA
//           aCordW  := {125,0,500,770}   // Tela de Fora (dos botoes) PADRAO AD'ORO
// Fim das Alteracoes

//��������������������������������������������������������������Ŀ
//� Grava GetDados - Gravacao dos registros a partir de aCols    �
//����������������������������������������������������������������
MsAguarde( { || u_Grava() }, "Aguarde", "Atualizando as Cidades...", .F. )

dbSelectArea(_sAlias)
dbSetOrder( _nOrder )
dbGoto(_sRec)

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � u_Monta  � Autor � Rogerio Eduardo Nutti � Data � 13/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Montagem da Getdados (aHeader, aC, aR, aCols )             ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function u_Monta()

_nItem := 0
_nProp := 0
_nUm   := 0
_nNorm := 0
_nEspe := 0

//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������

MsProcTxt( "Montando Estrutura da Entrada de Dados" )

dbSelectArea("SX3")
dbSetOrder(1)
_aCampos := { { "ZV9_DTVAL"   , 08 },;
{ "ZV9_VLTON"   , 09 },;
{ "ZV9_VLTK"    , 09 },;
{ "ZV9_VLTC"    , 09 }}


nUsado  := 0
aHeader := {}

For _I := 1 to Len(_aCampos)
	dbSeek("ZV9")
	
	Do While X3_ARQUIVO == "ZV9" .and. !Eof()
		If Alltrim(X3_CAMPO) == _aCampos[_I,1]
			nUsado:=nUsado+1
			AADD(aHeader,{ TRIM(X3_TITULO), Alltrim(X3_CAMPO), X3_PICTURE,;
			_aCampos[_I,2], X3_DECIMAL,, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
		Endif
		dbSkip()
	Enddo
Next

//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������


dbSelectArea("ZV8")
Dbgoto(_sRec)

dbSelectArea("ZV9")
dbSetOrder(2)
IF dbSeek(xFilial("ZV9")+ ZV8->ZV8_COD)
   	_cCod := ZV9->ZV9_COD

ENDIF


Do While !Eof() .and. ZV9->ZV9_FILIAL   ==  xFilial("ZV9") .and.;
	ZV9->ZV9_REGIAO  ==  ZV8->ZV8_COD
	
	MsProcTxt( "Selecionando Cidades: " + ZV9_REGIAO)
	
	aAdd(aCols,{ ZV9->ZV9_DTVAL , ZV9->ZV9_VLTON  ,ZV9->ZV9_VLTK  ,ZV9->ZV9_VLTC, .F.} )
	
	dbSkip()
	
EndDo

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
// aC:={}
// aC[n,1] = Nome da Variavel Ex.:"cCliente"
// aC[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aC[n,3] = Titulo do Campo
// aC[n,4] = Picture
// aC[n,5] = Validacao
// aC[n,6] = F3
// aC[n,7] = Se campo e' editavel .t. se nao .f.

AADD(aC,{"_dZV9DTVAL  " ,{20,10} ,"",,,,.F.})
AADD(aC,{"_nZV9VLTON  " ,{20,10} ,"",,,,.F.})   // .T. pode ser alterado
AADD(aC,{"_nZV9VLTK   " ,{20,10} ,"",,,,.F.})   // .T. pode ser alterado
AADD(aC,{"_nZV9VLTC   " ,{20,10} ,"",,,,.F.})   // .T. pode ser alterado

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
// aR:={}
// aR[n,1] = Nome da Variavel Ex.:"cCliente"
// aR[n,2] = Array com coordenadas do Get [x,y], em Windows estao em PIXEL
// aR[n,3] = Titulo do Campo
// aR[n,4] = Picture
// aR[n,5] = Validacao
// aR[n,6] = F3
// aR[n,7] = Se campo e' editavel .t. se nao .f.
// AADD(aR,{"cObs" ,{20,03},"Observa��o"    ,"@!",,,})

Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � u_Grava  � Autor �Jose Carlos S.Veloso Jr� Data � 20/05/97 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Gravacao da Getdados                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Substituido pelo assistente de conversao do AP5 IDE em 13/08/02 ==> Function u_Grava
Static Function u_Grava()

//��������������������������������������������������������������Ŀ
//� Pegando posicao dos campos na matriz aCols                   �
//����������������������������������������������������������������

_nPosDTVAL   := aScan(aHeader,{|x| x[2]== "ZV9_DTVAL"  })
_nPosVLTON   := aScan(aHeader,{|x| x[2]== "ZV9_VLTON"  })
_nPosVLTK    := aScan(aHeader,{|x| x[2]== "ZV9_VLTK"   })
_nPosVLTC    := aScan(aHeader,{|x| x[2]== "ZV9_VLTC"   })

//��������������������������������������������������������������Ŀ
//� Gravacao dos itens a partir da matriz aCols                  �
//����������������������������������������������������������������
If lRetMod2
	
	dbSelectArea("ZV9")
	dbSetOrder(4)
	
	
	For _I := 1 To Len(aCols)
		
				
		If dbSeek( xFilial("ZV9")+ dtos(aCols[_I][_nPosDTVAL])+ZV8->ZV8_COD)
			
			RecLock("ZV9",.F.)
			Replace ZV9_DTVAL   With aCols[_I,_nPosDTVAL]
			Replace ZV9_VLTON   With aCols[_I,_nPosVLTON]
			Replace ZV9_VLTK    With aCols[_I,_nPosVLTK]
			Replace ZV9_VLTC    With aCols[_I,_nPosVLTC]
			MsUnLock()
		Else
			_cCod := GETSX8NUM("ZV9","ZV9_COD")
			RecLock("ZV9",.T.)
			Replace ZV9_FILIAL  With FwxFilial("ZV9")
		   	Replace ZV9_COD     With _cCod
			Replace ZV9_REGIAO  With ZV8->ZV8_COD
			Replace ZV9_DTVAL   With aCols[_I,_nPosDTVAL]
			Replace ZV9_VLTON   With aCols[_I,_nPosVLTON]
			Replace ZV9_VLTK    With aCols[_I,_nPosVLTK]
			Replace ZV9_VLTC    With aCols[_I,_nPosVLTC]
			MsUnLock()
			ConfirmSX8()
		Endif
		
	Next _I
	
Endif
Return
