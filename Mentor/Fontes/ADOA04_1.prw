#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噭o    � ADOA04_1 � Autor � Vogas Junior          � Data � 09/09/09 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噭o � Cadastro de Motivos de Bloqueio de Cadastro.               潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Adoro - Cadastro espelho de ciente e aprovacao de credito  潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北矨nalista  � Data/Bops/Ver 矼anutencao Efetuada                         潮�
北媚哪哪哪哪呐哪哪哪哪履哪哪穆哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北�          �        �      �                                            潮�
北滥哪哪哪哪牧哪哪哪哪聊哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌�*/

User Function ADOA04_1()

	Local aArea			:= GetArea()

	Private cCadastro	:= "Cadastro de Motivos de Bloqueio de Cadastro"
	Private cString		:= "PB5"
	Private aRotina		:=	{	{"Pesquisar"	,"AxPesqui"							,0,1} ,;
								{"Visualizar"	,"AxVisual(cString, RecNo(), 2)"	,0,2} ,;
								{"Incluir"		,"AxInclui(cString, RecNo(), 3)"	,0,3} ,;
								{"Alterar"		,"AxAltera(cString, RecNo(), 4)"	,0,4} ,;
								{"Excluir"		,"AxDeleta(cString, RecNo(), 5)"	,0,5} }					

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Motivos de Bloqueio de Cadastro.')

	dbSelectArea(cString)
	dbSetOrder(1)
	mBrowse( 6,1,22,75,cString)
	RestArea( aArea )

Return Nil       
