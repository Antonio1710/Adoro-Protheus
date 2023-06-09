#include "rwmake.ch"  

User Function AD0003 

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Menu inicial do sistema de comissao de vendedores')

SetPrvt("CCADASTRO,AROTINA,")

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� AD0003.PRW   � Menu inicial do sistema de comissao de vendedores       ���
���              �                                                         ���
���              � Especifico Ad'oro Alimenticia                           ���
��������������������������������������������������������������������������Ĵ��
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
//ticket 85390 - Antonio - 03/02/2023 -Valid fontes v33-dic.bco     
/*/

dbSelectArea("SZA")
dbSetOrder(1)
dbGoTop()

CCadastro := "Tabela de Comissoes "
aRotina := {  { "Pesquisar"    	,"AxPesqui"           	, 0 , 1},;
              { "Visualizar"		,"axVisual"           	, 0 , 2},;
              { "Incluir"     	,"EXECBLOCK('AD0002')"	, 0 , 3},;
              { "Alterar"     	,"EXECBLOCK('AD0004')"	, 0 , 4},;
              { "Excluir" 			,"EXECBLOCK('AD0006')"	, 0 , 5}  }
mBrowse( 6, 1,22,75,"SZA")
dbSelectArea("SZA")
dbSetOrder(1)

Return

//ESTA FUNCAO FAZ INCLUSAO NA TABELA SZA DE FAIXAS DE COMISSAO DE VENDAS
USER FUNCTION AD0002 ()

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  AD0002  � Autor �  HERALDO C. HEBLING   � Data � 12/12/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Inclusao da tabela de comissoes de vendedores               ��
�������������������������������������������������������������������������Ĵ��
��� Uso      � Adoro Alimenticia                                          ���
��������������������������������������������������������������������������ٱ�
��� Arquivos � SZA                                                        ���
��� em Uso   �                                                            ���
��������������������������������������������������������������������������ٱ�
��� Manutencao :                                                          ���
���                                                                       ���
���                                                                       ���
���                                                                       ���
���                                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
Local _ni,_I //ticket 85390 - Antonio - 03/02/2023
Private aHeader := {}
Private aCols    := {}

nOpcx:=3
Public _nPerce  := 0
Public _cFaixa  := "A"
Public _nPerc
Private _valor
Private _nPercen

U_ADINF009P('AD0003' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Menu inicial do sistema de comissao de vendedores')

//@history Ticket 70142  - Rodrigo / Flek Solution - 18/07/2022 - Ajustes Dic. de dados no Banco
//FillGetDados(nOpcx,"SZA",1,,,,{"ZA_FILIAL", "ZA_CODTAB", "ZA_DTTAB", "ZA_TABELA"},,,,,,@aHeader,@aCols)


//ticket 85390 - Antonio - 03/02/2023 - INICIO
//Montando Pict dos Campos do aHeader
_cPictPERCDE  := PesqPictQt("ZA_PERCDE",TAMSX3("ZA_PERCDE")[1])
_cPictPERCATE := PesqPictQt("ZA_PERCATE",TAMSX3("ZA_PERCATE")[1])
_cPictVLFAIXA := PesqPictQt("ZA_VLFAIXA",TAMSX3("ZA_VLFAIXA")[1])
//��������������������������������������������������������������Ŀ
//� Montando aHeader                                             �
//����������������������������������������������������������������
AADD(aHeader,{ "Faixae","ZA_FAIXA","@!",TAMSX3("ZA_FAIXA")[1], TAMSX3("ZA_FAIXA")[2]    ,"","?","C","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
AADD(aHeader,{ "Percent de","ZA_PERCDE",_cPictPERCDE,TAMSX3("ZA_PERCDE")[1], TAMSX3("ZA_PERCDE")[2]    ,"","?","N","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
AADD(aHeader,{ "Percent Ate","ZA_PERCATE",_cPictPERCATE,TAMSX3("ZA_PERCATE")[1],TAMSX3("ZA_PERCATE")[2],"","?","N","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
AADD(aHeader,{ "Valor Faixa","ZA_VLFAIXA",_cPictVLFAIXA,TAMSX3("ZA_VLFAIXA")[1], TAMSX3("ZA_VLFAIXA")[2]    ,"","?","N","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
//ticket 85390 - Antonio - 03/02/2023 - FIM

_nPosFAIXA   	:= aScan(aHeader,{|x| alltrim(x[2])=="ZA_FAIXA"})
_nPosDE	    	:= aScan(aHeader,{|x| alltrim(x[2])=="ZA_PERCDE"})
_nPosATE	    := aScan(aHeader,{|x| alltrim(x[2])=="ZA_PERCATE"})
_nPosVL      	:= aScan(aHeader,{|x| alltrim(x[2])=="ZA_VLFAIXA"})

//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������
nUsado := Len(aHeader) //ticket 85390 - Antonio - 03/02/2023
aCols  := {Array(nUsado+1)}
aCols [1,nUsado+1]:=.F.
For _ni:=1 to nUsado
	aCols [1,_ni]:=CriaVar(aHeader[_ni,2])
Next

//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
nLinGetD:=0
//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������
cTitulo:="TABELA DE PRECOS"
//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������
_cCodigo	:=	Space(4)
_cTabela	:=	Space(1)
_dData		:= 	DDATABASE
//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC:={}
AADD(aC,{"_cCodigo"	,{15,10} ,"Tabela de Comissao"	,"@!"			,,,})
AADD(aC,{"_cTabela"	,{15,100},"Faixa de Comissao"	,"@!"			,"U_AD2Vl1(_cCodigo,_cTabela)",,})
AADD(aC,{"_dData"	,{15,200},"Data da Tabela"			,"@D"			,,,})
//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
aR:={}
*/
//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
	aCGD:={44,5,118,315}
//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk:="U_AD2LinOk()
cTudoOk:="U_AD2TudoOk()
//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

//��������������������������������������������������������������Ŀ
//� Grava tabela                                                 �
//����������������������������������������������������������������
If lRetMod2
	_nCtlin := 0
	For _I := 1 To Len(aCols)
		IF	!aCols[_I,5]
			_nCtlin++
			RecLock("SZA",.T.)
			SZA->ZA_FILIAL		:=	cFilAnt
			SZA->ZA_CODTAB		:=  _cCodigo
			SZA->ZA_TABELA		:=  _cTabela
			SZA->ZA_DTTAB		:=	_dData
			SZA->ZA_FAIXA		:=	U_FLETRA(_nCtlin)
			SZA->ZA_PERCDE		:=	aCols[_I,_nPosDE]
			SZA->ZA_PERCATE		:=	aCols[_I,_nPosATE]
			SZA->ZA_VLFAIXA		:=	aCols[_I,_nPosVL]
			MSUNLOCK()
		Endif
    NEXT _I
Endif

Return
//��������������������������������������������������������������Ŀ
//� Funcao para montar as letras da faixa                        �
//����������������������������������������������������������������

USER FUNCTION FLETRA(_nI)

	U_ADINF009P('AD0003' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Menu inicial do sistema de comissao de vendedores')
    If 		_nI == 1
    		_cFaixa := 'A'
    ElseIf 	_nI == 2
    		_cFaixa := 'B'
    ElseIf 	_nI == 3
    		_cFaixa := 'C'
    ElseIf 	_nI == 4
    		_cFaixa := 'D'
    ElseIf 	_nI == 5
    		_cFaixa := 'E'
    ElseIf 	_nI == 6
    		_cFaixa := 'F'
    ElseIf 	_nI == 7
    		_cFaixa := 'G'
    ElseIf 	_nI == 8
    		_cFaixa := 'H'
    ElseIf 	_nI == 9
    		_cFaixa := 'I'
    ElseIf 	_cnI == 10
    		_cFaixa := 'J'
    ElseIf 	_cnI == 11
    		_cFaixa := 'K'
    ElseIf 	_cnI == 12
    		_cFaixa := 'L'
    ElseIf 	_cnI == 13
    		_cFaixa := 'M'
    ElseIf 	_cnI == 14
    		_cFaixa := 'N'
    ElseIf 	_cnI == 15
    		_cFaixa := 'O'
    ElseIf 	_cnI == 16
       		_cFaixa := 'P'
    ElseIf 	_cnI == 17
    		_cFaixa := 'Q'
    ElseIf 	_cnI == 18
    		_cFaixa := 'R'
    ElseIf 	_cnI == 19
    		_cFaixa := 'S'
    ElseIf 	_cnI == 20
    		_cFaixa := 'T'
    ElseIf 	_cnI == 21
    		_cFaixa := 'U'
    ElseIf 	_cnI == 22
    		_cFaixa := 'V'
    ElseIf 	_cnI == 23
    		_cFaixa := 'W'
    ElseIf 	_cnI == 24
    		_cFaixa := 'X'
    ElseIf 	_cnI == 25
    		_cFaixa := 'Y'
    ElseIf 	_cnI == 26
    		_cFaixa := 'Z'
    Endif
Return(_cFaixa)





//ESTA FUNCAO ALTERA A TABELA SZA DE FAIXAS DE COMISSAO DE VENDAS
USER  FUNCTION AD0004
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  AD0004  � Autor �  HERALDO C. HEBLING   � Data � 12/12/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Manutencao da tabela de comissoes de vendedores             ��
�������������������������������������������������������������������������Ĵ��
��� Uso      � Adoro Alimenticia                                          ���
��������������������������������������������������������������������������ٱ�
��� Arquivos � SZA                                                        ���
��� em Uso   �                                                            ���
��������������������������������������������������������������������������ٱ�
��� Manutencao :                                                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
Local cSeek := ""
Local cWhile := ""
Local _I //ticket 85390 - Antonio - 03/02/2023
nOpcx:=3
Public _nPerce  := 0
Public _nPerc
Public _cFaixa  := "A"
Private aHeader := {}
Private aCols    := {}
Private _valor
Private _nPercen
_cAlias	:=alias()
_corder:=indexord()
_nrecno:=	recno()	

//@history Ticket 70142  - Rodrigo / Flek Solution - 18/07/2022 - Ajustes Dic. de dados no Banco
dbSelectArea("SZA")
dbSetOrder(1)
dbgoto(_nrecno)
_cFilial    :=  SZA->ZA_FILIAL //ticket 85390 - Antonio - 03/02/2023
_cCodigo	:=	SZA->ZA_CODTAB
_cTabela	:=	SZA->ZA_TABELA
_dData		:= 	SZA->ZA_DTTAB
cSeek 	:= _cFilial+_cCodigo+_cTabela //ticket 85390 - Antonio - 03/02/2023
cWhile 	:= 'SZA->ZA_FILIAL+SZA->ZA_CODTAB+SZA->ZA_TABELA' //ticket 85390 - Antonio - 03/02/2023
//FillGetDados(nOpcx,"SZA",1,cSeek,{|| cWhile },,{"ZA_FILIAL", "ZA_CODTAB", "ZA_DTTAB", "ZA_TABELA"},,,,,,@aHeader,@aCols)

//ticket 85390 - Antonio - 03/02/2023 - INICIO
//Montando Pict dos Campos do aHeader
_cPictPERCDE  := PesqPictQt("ZA_PERCDE",TAMSX3("ZA_PERCDE")[1])
_cPictPERCATE := PesqPictQt("ZA_PERCATE",TAMSX3("ZA_PERCATE")[1])
_cPictVLFAIXA := PesqPictQt("ZA_VLFAIXA",TAMSX3("ZA_VLFAIXA")[1])
// Montando aHeader
AADD(aHeader,{ "Faixae","ZA_FAIXA","@!",TAMSX3("ZA_FAIXA")[1], TAMSX3("ZA_FAIXA")[2]    ,"","?","C","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
AADD(aHeader,{ "Percent de","ZA_PERCDE",_cPictPERCDE,TAMSX3("ZA_PERCDE")[1], TAMSX3("ZA_PERCDE")[2]    ,"","?","N","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
AADD(aHeader,{ "Percent Ate","ZA_PERCATE",_cPictPERCATE,TAMSX3("ZA_PERCATE")[1],TAMSX3("ZA_PERCATE")[2],"","?","N","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
AADD(aHeader,{ "Valor Faixa","ZA_VLFAIXA",_cPictVLFAIXA,TAMSX3("ZA_VLFAIXA")[1], TAMSX3("ZA_VLFAIXA")[2]    ,"","?","N","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
//ticket 85390 - Antonio - 03/02/2023 - FIM

_nPosFAIXA   	:= aScan(aHeader,{|x| alltrim(x[2])=="ZA_FAIXA"})
_nPosDE	    	:= aScan(aHeader,{|x| alltrim(x[2])=="ZA_PERCDE"})
_nPosATE	    := aScan(aHeader,{|x| alltrim(x[2])=="ZA_PERCATE"})
_nPosVL      	:= aScan(aHeader,{|x| alltrim(x[2])=="ZA_VLFAIXA"})

//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
nLinGetD:=0
//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������
cTitulo:="TABELA DE PRECOS"
//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

//ticket 85390 - Antonio - 03/02/2023 - INICIO
dbSelectArea("SZA")
dbSetOrder(1)
dbgoto(_nrecno)
_cFilial    :=  SZA->ZA_FILIAL //ticket 85390 - Antonio - 03/02/2023
_cCodigo	:=	SZA->ZA_CODTAB
_cTabela	:=	SZA->ZA_TABELA
_dData		:= 	SZA->ZA_DTTAB
dbseek(_cFilial+_cCodigo+_cTabela) //ticket 85390 - Antonio - 03/02/2023
Do while	!eof()	.and.	(SZA->ZA_FILIAL==_cFilial .And. SZA->ZA_CODTAB==_cCodigo .and. _cTabela	==	SZA->ZA_TABELA) //ticket 85390 - Antonio - 03/02/2023

   aAdd(aCols,{SZA->ZA_FAIXA,SZA->ZA_PERCDE,SZA->ZA_PERCATE,SZA->ZA_VLFAIXA, .F.} )

   dbSkip()

EndDo
//ticket 85390 - Antonio - 03/02/2023 - FIM
//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC:={}
AADD(aC,{"_cCodigo"	,{15,10} ,"Tabela de Comissao"	,"@!"			,,,.f.})
AADD(aC,{"_cTabela"	,{15,100},"Faixa de Comissao"	,"@!"			,"U_AD2Vl2(_cCodigo+_cTabela)",,.f.})
AADD(aC,{"_dData"	,{15,200},"Data da Tabela"			,"@D"		,,,.f.})
//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
aR:={}
//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
	aCGD:={44,5,118,315}
//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk:="U_AD2LinOk()"
cTudoOk:= "U_AD2TudoOk()"
//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)

If lRetMod2
	If  dbSeek( _cFilial + _cCodigo+_cTabela+"A"  ) //ticket 85390 - Antonio - 03/02/2023
		Do while (SZA->ZA_FILIAL==_cFilial .And. SZA->ZA_CODTAB == _cCodigo .and. SZA->ZA_TABELA == _cTabela) //ticket 85390 - Antonio - 03/02/2023
			RecLock("SZA",.F.)
			dbdelete()
			MSUNLOCK()
			dbskip()
		enddo
	Endif
	_nCtlin := 0
	For _I := 1 To Len(aCols)
		IF	!aCols[_I,5]
			_nCtlin++
			RecLock("SZA",.T.)
			SZA->ZA_FILIAL		:=	_cFilial //ticket 85390 - Antonio - 03/02/2023
			SZA->ZA_CODTAB		:=  _cCodigo
			SZA->ZA_TABELA		:=	_cTabela
			SZA->ZA_DTTAB		:=	_dData
			SZA->ZA_FAIXA		:=	U_FLETRA(_nCtlin)
			SZA->ZA_PERCDE		:=	aCols[_I,_nPosDE]
			SZA->ZA_PERCATE		:=	aCols[_I,_nPosATE]
			SZA->ZA_VLFAIXA		:=	aCols[_I,_nPosVL]
			MSUNLOCK()
		Endif
    NEXT _I
Endif
RETURN

//��������������������������������������������������������������Ŀ
//� Funcao para montar as letras da faixa                        �
//����������������������������������������������������������������

/*STATIC FUNCTION FLETRA(_nI)
    If 		_nI == 1
    		_cFaixa := 'A'
    ElseIf 	_nI == 2
    		_cFaixa := 'B'
    ElseIf 	_nI == 3
    		_cFaixa := 'C'
    ElseIf 	_nI == 4
    		_cFaixa := 'D'
    ElseIf 	_nI == 5
    		_cFaixa := 'E'
    ElseIf 	_nI == 6
    		_cFaixa := 'F'
    ElseIf 	_nI == 7
    		_cFaixa := 'G'
    ElseIf 	_nI == 8
    		_cFaixa := 'H'
    ElseIf 	_nI == 9
    		_cFaixa := 'I'
    ElseIf 	_cnI == 10
    		_cFaixa := 'J'
    ElseIf 	_cnI == 11
    		_cFaixa := 'K'
    ElseIf 	_cnI == 12
    		_cFaixa := 'L'
    ElseIf 	_cnI == 13
    		_cFaixa := 'M'
    ElseIf 	_cnI == 14
    		_cFaixa := 'N'
    ElseIf 	_cnI == 15
    		_cFaixa := 'O'
    ElseIf 	_cnI == 16
       		_cFaixa := 'P'
    ElseIf 	_cnI == 17
    		_cFaixa := 'Q'
    ElseIf 	_cnI == 18
    		_cFaixa := 'R'
    ElseIf 	_cnI == 19
    		_cFaixa := 'S'
    ElseIf 	_cnI == 20
    		_cFaixa := 'T'
    ElseIf 	_cnI == 21
    		_cFaixa := 'U'
    ElseIf 	_cnI == 22
    		_cFaixa := 'V'
    ElseIf 	_cnI == 23
    		_cFaixa := 'W'
    ElseIf 	_cnI == 24
    		_cFaixa := 'X'
    ElseIf 	_cnI == 25
    		_cFaixa := 'Y'
    ElseIf 	_cnI == 26
    		_cFaixa := 'Z'
    Endif
Return(_cFaixa)
*/
                                                   
//EXCLUSAO
USER  FUNCTION AD0006
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �  AD0006  � Autor �  HERALDO C. HEBLING   � Data � 12/12/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Exclusao de tabela de comissoes de vendedores               ��
�������������������������������������������������������������������������Ĵ��
��� Uso      � Adoro Alimenticia                                          ���
��������������������������������������������������������������������������ٱ�
��� Arquivos � SZA                                                        ���
��� em Uso   �                                                            ���
��������������������������������������������������������������������������ٱ�
��� Manutencao :                                                          ���
���                                                                       ���
���                                                                       ���
���                                                                       ���
���                                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//��������������������������������������������������������������Ŀ
//� Opcao de acesso para o Modelo 2                              �
//����������������������������������������������������������������
// 3,4 Permitem alterar getdados e incluir linhas
// 6 So permite alterar getdados e nao incluir linhas
// Qualquer outro numero so visualiza
//Local cSeek := ""
Local cWhile := ""

nOpcx:=3
Public _nPerce  := 0
Public _nPerc
Public _cFaixa  := "A"
Private aHeader := {}
Private aCols    := {}
Private _valor
Private _nPercen
_cAlias	:=alias()
_corder:=indexord()
_nrecno:=	recno()	

//@history Ticket 70142  - Rodrigo / Flek Solution - 18/07/2022 - Ajustes Dic. de dados no Banco
//cSeek 	:= _cFilial+_cCodigo+_cTabela //ticket 85390 - Antonio - 03/02/2023
dbSelectArea("SZA")
dbSetOrder(1)
dbgoto(_nrecno)
_cFilial    :=  SZA->ZA_FILIAL //ticket 85390 - Antonio - 03/02/2023
_cCodigo	:=	SZA->ZA_CODTAB
_cTabela	:=	SZA->ZA_TABELA
_dData		:= 	SZA->ZA_DTTAB
cWhile 	:= 'SZA->ZA_CODTAB+SZA->ZA_TABELA'
//FillGetDados(nOpcx,"SZA",1,cSeek,{|| cWhile },,{"ZA_FILIAL", "ZA_CODTAB", "ZA_DTTAB", "ZA_TABELA"},,,,,,@aHeader,@aCols)

//ticket 85390 - Antonio - 03/02/2023 - INICIO
//Montando Pict dos Campos do aHeader
_cPictPERCDE  := PesqPictQt("ZA_PERCDE",TAMSX3("ZA_PERCDE")[1])
_cPictPERCATE := PesqPictQt("ZA_PERCATE",TAMSX3("ZA_PERCATE")[1])
_cPictVLFAIXA := PesqPictQt("ZA_VLFAIXA",TAMSX3("ZA_VLFAIXA")[1])
// Montando aHeader
AADD(aHeader,{ "Faixae","ZA_FAIXA","@!",TAMSX3("ZA_FAIXA")[1], TAMSX3("ZA_FAIXA")[2]    ,"","?","C","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
AADD(aHeader,{ "Percent de","ZA_PERCDE",_cPictPERCDE,TAMSX3("ZA_PERCDE")[1], TAMSX3("ZA_PERCDE")[2]    ,"","?","N","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
AADD(aHeader,{ "Percent Ate","ZA_PERCATE",_cPictPERCATE,TAMSX3("ZA_PERCATE")[1],TAMSX3("ZA_PERCATE")[2],"","?","N","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
AADD(aHeader,{ "Valor Faixa","ZA_VLFAIXA",_cPictVLFAIXA,TAMSX3("ZA_VLFAIXA")[1], TAMSX3("ZA_VLFAIXA")[2]    ,"","?","N","SZA","R"} ) //ticket 85390 - Antonio - 03/02/2023
//ticket 85390 - Antonio - 03/02/2023 - FIM

_nPosFAIXA   	:= aScan(aHeader,{|x| alltrim(x[2])=="ZA_FAIXA"})
_nPosDE	    	:= aScan(aHeader,{|x| alltrim(x[2])=="ZA_PERCDE"})
_nPosATE	    := aScan(aHeader,{|x| alltrim(x[2])=="ZA_PERCATE"})
_nPosVL      	:= aScan(aHeader,{|x| alltrim(x[2])=="ZA_VLFAIXA"})

//��������������������������������������������������������������Ŀ
//� Montando aCols                                               �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis do Rodape do Modelo 2                              �
//����������������������������������������������������������������
nLinGetD:=0
//��������������������������������������������������������������Ŀ
//� Titulo da Janela                                             �
//����������������������������������������������������������������
cTitulo:="TABELA DE PRECOS"
//��������������������������������������������������������������Ŀ
//� Variaveis do Cabecalho do Modelo 2                           �
//����������������������������������������������������������������

dbSelectArea("SZA")
dbSetOrder(1)
dbgoto(_nrecno)
_cFilial    :=  SZA->ZA_FILIAL //ticket 85390 - Antonio - 03/02/2023
_cCodigo	:=	SZA->ZA_CODTAB
_cTabela	:=	SZA->ZA_TABELA
_dData		:= 	SZA->ZA_DTTAB
dbseek(_cFilial+_cCodigo+_cTabela) //ticket 85390 - Antonio - 03/02/2023
Do while	!eof()	.and.	(SZA->ZA_FILIAL==_cFilial .And. SZA->ZA_CODTAB==_cCodigo .and. _cTabela	==	SZA->ZA_TABELA) //ticket 85390 - Antonio - 03/02/2023

   aAdd(aCols,{SZA->ZA_FAIXA,SZA->ZA_PERCDE,SZA->ZA_PERCATE,SZA->ZA_VLFAIXA, .F.} )

   dbSkip()

EndDo

//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Cabecalho do Modelo 2      �
//����������������������������������������������������������������
aC:={}
AADD(aC,{"_cCodigo"	,{15,10} ,"Tabela de Comissao"	,"@!"			,"U_AD2Vl2(_cCodigo)",,.f.})
AADD(aC,{"_cTabela"	,{15,100},"Faixa de Comissao"	,"@!"			,,,.f.})
AADD(aC,{"_dData"	,{15,200},"Data da Tabela"			,"@D"		,,,.f.})
//��������������������������������������������������������������Ŀ
//� Array com descricao dos campos do Rodape do Modelo 2         �
//����������������������������������������������������������������
aR:={}
//AADD(aR,{"_nPercen"	,{120,10},"Percentual"	,"@E 999.999",,,.F.})
*/
//��������������������������������������������������������������Ŀ
//� Array com coordenadas da GetDados no modelo2                 �
//����������������������������������������������������������������
	aCGD:={44,5,118,315}
//��������������������������������������������������������������Ŀ
//� Validacoes na GetDados da Modelo 2                           �
//����������������������������������������������������������������
cLinhaOk:="U_AD2LinOk()"
cTudoOk:= "U_AD2TudoOk()"
//��������������������������������������������������������������Ŀ
//� Chamada da Modelo2                                           �
//����������������������������������������������������������������

lRetMod2:=Modelo2(cTitulo,aC,aR,aCGD,nOpcx,cLinhaOk,cTudoOk)
//FAZ A DELECAO
If lRetMod2
	If  dbSeek( xFilial("SZA") + _cCodigo+_cTabela+"A"  ) //ticket 85390 - Antonio - 03/02/2023
		Do while (SZA->ZA_FILIAL =_cFilial .And. SZA->ZA_CODTAB == _cCodigo .and. SZA->ZA_TABELA == _cTabela) //ticket 85390 - Antonio - 03/02/2023
			RecLock("SZA",.F.)
			dbdelete()
			MSUNLOCK()
			dbskip()
		enddo
	Endif
Endif
RETURN

//
USER FUNCTION AD2VALID

U_ADINF009P('AD0003' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Menu inicial do sistema de comissao de vendedores')
nLinGetD:=n
_nPos	:= aScan(aHeader,{|x| x[2]=="ZA_PERCATE"})

_nPerce	:=	aCols[n,_nPos]
RETURN(.T.)

//
USER FUNCTION AD2LINOK

U_ADINF009P('AD0003' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Menu inicial do sistema de comissao de vendedores')
nLinGetD:=n 
	_nPerce := _nPerce + 0.001
	_cFaixa := CHR(ASC(_cFaixa)+1)
RETURN(.T.)	

//
USER FUNCTION AD2TUDOOK
//	MsgStop("Existem "+Str(Len(aCols))+" linhas na GetDados")
RETURN(.T.)

//
USER FUNCTION AD2VL1 (_Codigo,_Tabela)

U_ADINF009P('AD0003' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Menu inicial do sistema de comissao de vendedores')
dbSelectArea("SZA")
dbSetOrder(1)
if !dbSeek(xFilial()+_cCodigo+_Tabela)
	RETURN(.T.)
ELSE
	MSGSTOP("TABELA EXISTENTE! ENTRE COM OUTRO CODIGO")
	RETURN(.F.)
Endif
RETURN(.T.)
//
USER FUNCTION AD2VL2 (_Codigo,_Tabela)

U_ADINF009P('AD0003' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Menu inicial do sistema de comissao de vendedores')
dbSelectArea("SZA")
dbSetOrder(1)
if  dbSeek(xfilial()+_Codigo,_Tabela)
	RETURN(.T.)
ELSE
	MSGSTOP("TABELA NAO EXISTE! ENTRE COM OUTRO CODIGO")
	RETURN(.F.)
Endif
RETURN(.T.)
