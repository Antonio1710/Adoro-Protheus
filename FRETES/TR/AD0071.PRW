#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 13/08/02
#include "topconn.ch"

User Function AD0071()        // incluido pelo assistente de conversao do AP5 IDE em 13/08/02

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � AD0071   � Autor � Werner dos Santos     � Data � 16/09/03 ���
�������������������������������������������������������������������������Ĵ��
���          �Uso Logistica                                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

// Salva a situacao Atual
_sAlias := Alias()
_nOrder := IndexOrd()
_sRec   := Recno()

//��������������������������������������������������������������Ŀ
//� Variaveis                                                    �
//����������������������������������������������������������������
Private aHeader  := {}
Private aCols    := {}
Private cTitulo := " Notas Fiscais do Frete "
Private aC:={}
Private aR:={}
Private _dDatEntr := SZK->ZK_DTENTR
Private _cRote    := SZK->ZK_ROTEIRO
Private _cPlac    := SZK->ZK_PLACAPG
Private _nGuia    := SZK->ZK_GUIA

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

//��������������������������������������������������������������Ŀ
//� Monta GetDados ( aHeader, aC, aR e aCols )                   �
//����������������������������������������������������������������
MsAguarde( { || u_Monta() }, "Aguarde", "Selecionando os Notas ....", .F. )

//��������������������������������������������������������������Ŀ
//� Verifica se ha' dados para serem exibidos e alterados        �
//����������������������������������������������������������������
If Empty( aCols)
	dbSelectArea(_sAlias)
	dbSetOrder( _nOrder )
	dbGoto(_sRec)
	MsgStop( "Nao existem dados para estes parametros  " )
	Return
Endif

//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 1) 3,4 - Permitem alterar getdados e incluir linhas
// 2) 6   - So permite alterar getdados e nao incluir linhas
// 3)     - Qualquer outro numero so visualiza
nOpcx  := 5
//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������

aCGD    := {120,0,30,30} //{37,9,178,365}              // Tela do GetDados

//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk := "AllWaysTrue()"
cTudoOk  := "AllWaysTrue()"

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk,,,,,{125,0,500,750},.T.,.T.)
// Fim das Alteracoes

//��������������������������������������������������������������Ŀ
//� Grava GetDados - Gravacao dos registros a partir de aCols    �
//����������������������������������������������������������������
// MsAguarde( { || u_Grava() }, "Aguarde", "Atualizando as Cidades...", .F. )

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

dbSelectArea("SC5")
//dbSetOrder(9)
SC5->(DBORDERNICKNAME("SC5_9")) //atualiza��o protheus 12 WILLIAM COSTA 28/12/2017 CHAMADO 036032
_aCampos := {{ "C5_NOTA"    , 06 },;
{ "C5_NUM"       , 06 },;
{ "C5_PLACA"     , 07 },;
{ "C5_DTENTR"    , 08 },;
{ "C5_ROTEIRO"   , 06 },;
{ "C5_PBRUTO"    , 10,2 },;
{ "C5_PESOL"     , 10,2 },;
{ "C5_CLIENTE"   , 06 },;
{ "C5_LOJACLI"   , 02 },;
{ "C5_NOMECLI"   , 20 },;
{ "C5_ENDERE"    , 40},;
{ "C5_BAIRRO"    , 15},;
{ "C5_CIDADE"    , 15}}

nUsado  := 0
aHeader := {}
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("SC5")

For _I := 1 to Len(_aCampos)
	dbSeek("SC5")
	Do While X3_ARQUIVO == "SC5" .and. !Eof()
		If Alltrim(X3_CAMPO) == _aCampos[_I,1]
			nUsado := nUsado + 1
			AADD(aHeader,{ TRIM(X3_TITULO), Alltrim(X3_CAMPO), X3_PICTURE,;
			_aCampos[_I,2], X3_DECIMAL,, X3_USADO, X3_TIPO, X3_ARQUIVO, X3_CONTEXT } )
		Endif
		dbSkip()
	Enddo
Next

//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������

dbSelectArea("SC5")
//dbSetOrder(9)
SC5->(DBORDERNICKNAME("SC5_9")) //atualiza��o protheus 12 WILLIAM COSTA 28/12/2017 CHAMADO 036032

If dbSeek( xFilial("SC5")+ DTOS(_dDatEntr)+_cRote + _cPlac )
	// Carrega os as notas do roteiro
	//��������������������������������������������������������������Ŀ
	//� Array com descricao dos campos do Cabecalho do Modelo 2      �
	//����������������������������������������������������������������
	AADD(aC,{"SZK->ZK_DTENTR"   ,{20,10} ,"ENTREGA : ",,,,.F.})
	AADD(aC,{"SZK->ZK_PLACAPG"  ,{20,110} ,"PLACA : ",,,,.F.})
	AADD(aC,{"SZK->ZK_ROTEIRO"  ,{20,200} ,"ROTEIRO :",,,,.F.})
	Do While !Eof() .and. C5_FILIAL == xFilial("SC5") .and. ;
		DTOS(SC5->C5_DTENTR) == DTOS(_dDatEntr) .and.;
		C5_ROTEIRO ==  _cRote .AND. C5_PLACA == _cPlac
		// SOMA PESO BRUTO DAS NOTAS QUE FORAM FATURADAS
		If C5_NOTA <> Space(9)   &&Mauricio 29/03/10 - Alterado de 6 para 9 casas.   
			aAdd(aCols,	{C5_NUM  ,;
			C5_NOTA     ,; 
			C5_PLACA    ,;
			C5_DTENTR   ,;
			C5_ROTEIRO  ,;
			C5_PBRUTO   ,;
			C5_PESOL    ,;
			C5_CLIENTE  ,;
			C5_LOJACLI  ,;
			C5_NOMECLI  ,;
			C5_ENDERE   ,;
			C5_BAIRRO   ,;
			C5_CIDADE   ,;
			.F.} )
		Endif
		dbSkip()
	EndDo
	
Else
	MsgBox( " FRETE SEM NOTAS FISCAIS RELACIONADAS. !!!   " )
Endif

