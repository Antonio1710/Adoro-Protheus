#INCLUDE "PROTHEUS.CH"
#INCLUDE "JPEG.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EPCP005   �Autor  �Guilherme Santos    � Data �  03/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Historicos de Inventario   		        				  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Especifico CMP                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EPCP005()
Local aArea		:= GetArea()
Local aAreaZAM	:= ZAM->(GetArea())

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Historicos de Inventario')

//@history Ticket 70142  - Edvar / Flek Solution - 06/04/2022 - Retirada de fun��o PUTSX1
//AjustaSX1()
If	Pergunte("PCP005",.T.)
	PCP005_BRW()
EndIf

//��������������������������������������������������������������Ŀ
//� Apaga o Indice + Filtro Temporario                           �
//����������������������������������������������������������������
dbClearFilter()

//��������������������������������������������������������������Ŀ
//� Restaura a Area do arquivo utilizado                         �
//����������������������������������������������������������������
RestArea(aAreaZAM)
RestArea(aArea)
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCP005_BRW�Autor  �Guilherme Santos    � Data �  03/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Browse para consulta dos Historicos de Inventario          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EPCP005                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function PCP005_BRW()
Local aCores		:=	{	{'ZAM->ZAM_STATUS=="1"'	, 'ENABLE'    },;	// Nao Processado
							{'ZAM->ZAM_STATUS=="2"'	, 'DISABLE'   },; 	// Processado
							{'ZAM->ZAM_STATUS=="3"'	, 'BR_AMARELO'},; 	// Estornado
							{'ZAM->ZAM_STATUS=="4"'	, 'BR_CINZA'  }} 	// Erro no Processamento

Local aFixe 		:= {	{"Produto"		,	"ZAM_COD"	},;
							{"Tipo Produto",	"ZAM_TIPO"	},;
							{"Quantidade"	,	"ZAM_QUANT"	},;
							{"Armazem"		,	"ZAM_LOCAL"	},;
							{"Localizacao"	,	"ZAM_LOCALI"},;
							{"Documento"	,	"ZAM_DOC"	},;
							{"Data Inicial",	"ZAM_DATA"	},;
							{"Data Final"	,	"ZAM_DTATE"	},;
							{"Num. Invent.",	"ZAM_NUM"	},;
							{"Num. Serie"	,	"ZAM_NUMSER"},;
							{"Usuario"		,	"ZAM_USUARI"},; 
							{"Dt Ult Proc"	,	"ZAM_DTPROC" },;
							{"Qtd Ini Est"	,	"ZAM_QTDINI"  },;
							{"Qtd Fim Est"	,	"ZAM_QTDFIM" },;
							{"Diferenca"	,	"ZAM_DIF"    }}
Private aRotina := Menudef()




						
						

//��������������������������������������������������������������Ŀ
//� Define o cabecalho da tela de Historico                      �
//����������������������������������������������������������������
Private cCadastro := "Historico de Inventario"

//����������������������������������������������������������������Ŀ
//� Ativa tecla F12 para acionar perguntas                         �
//������������������������������������������������������������������
Set Key VK_F12 To E005Perg()

//����������������������������������������������������������������Ŀ
//� Monta Filtro para o Arquivo ZAM                                �
//������������������������������������������������������������������
PCP005Filt()

//��������������������������������������������������������������Ŀ
//� Endereca a funcao de BROWSE                                  �
//����������������������������������������������������������������
mBrowse(,,,,"ZAM",aFixe,,,,2,aCores)

//��������������������������������������������������������������Ŀ
//� Apaga o Indice + Filtro Temporario                           �
//����������������������������������������������������������������
dbClearFilter()

Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCP005Filt�Autor  �Guilherme Santos    � Data �  04/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza o Filtro do arquivo ZAM, conforme parametros forne-���
���          �cidos pelo usuario.                                         ���
�������������������������������������������������������������������������͹��
���Uso       � EPCP005                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function PCP005Filt()
Local cBloco
Local cFiltroZAM

dbSelectArea("ZAM")
cFiltroZAM := 'ZAM_FILIAL      == "' + xFilial("ZAM") + '" .And. '
cFiltroZAM += 'DtoS(ZAM_DATA)  >= "' + DtoS(MV_PAR01) + '" .And. '
cFiltroZAM += 'DtoS(ZAM_DTATE) <= "' + DtoS(MV_PAR02) + '" .And. '
cFiltroZAM += 'ZAM_COD         >= "' + MV_PAR03 + '" .And. '
cFiltroZAM += 'ZAM_COD         <= "' + MV_PAR04 + '" .And. '
cFiltroZAM += 'ZAM_DOC         >= "' + MV_PAR05 + '" .And. '
cFiltroZAM += 'ZAM_DOC         <= "' + MV_PAR06 + '"'
If MV_PAR07 <> 5
	cFiltroZAM += ' .And. ZAM_STATUS == "' + StrZero(MV_PAR07,1) + '"'
EndIf

cBloco := "{ || " + cFiltroZAM + " }"
dbSetFilter( &cBloco,  cFiltroZAM )
dbGoTop()

Return (nil)

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  �Guilherme Santos    � Data �  03/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ajusta Perguntas no SX1                                    ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � EPCP005                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Static Function AjustaSX1()
//Local cPerg := "PCP005"
////��������������������������������������������������������������Ŀ
////� Verifica as perguntas selecionadas                           �
////����������������������������������������������������������������
////��������������������������������������������������������������Ŀ
////� Variaveis utilizadas para parametros                         �
////� mv_par01	     	// Data Inicial           		         �
////� mv_par02	     	// Data Final            		         �
////� mv_par03	     	// Produto Inicial       		         �
////� mv_par04	     	// Produto Final         		         �
////� mv_par05	     	// Documento Inicial     		         �
////� mv_par06	     	// Documento Final       		         �
////� mv_par07	     	// Status dos Registros   		         �
////����������������������������������������������������������������
//
//PutSX1(cPerg,"01","Data Inicial     ","","","mv_ch1","D", 8,0,0,"G","","   ","","","mv_par01"	,""		,""		,""		,"01/01/2006"		,""		,""		,""		,"","","","","","","","","",{},{},{})
//PutSX1(cPerg,"02","Data Final       ","","","mv_ch2","D", 8,0,0,"G","","   ","","","mv_par02"	,""		,""		,""		,"31/12/2049"		,""		,""		,""		,"","","","","","","","","",{},{},{})
//PutSX1(cPerg,"03","Do Produto       ","","","mv_ch3","C",15,0,0,"G","","SB1","","","mv_par03"	,""		,""		,""		,Space(15)			,""		,""		,""		,"","","","","","","","","",{},{},{})
//PutSX1(cPerg,"04","Ate o Produto    ","","","mv_ch4","C",15,0,0,"G","","SB1","","","mv_par04"	,""		,""		,""		,"ZZZZZZZZZZZZZZZ"	,""		,""		,""		,"","","","","","","","","",{},{},{})
//PutSX1(cPerg,"05","Do  Documento    ","","","mv_ch5","C", 6,0,0,"G","","   ","","","mv_par05"	,""		,""		,""		,Space(6)			,""		,""		,""		,"","","","","","","","","",{},{},{})
//PutSX1(cPerg,"06","Ate o Documento  ","","","mv_ch6","C", 6,0,0,"G","","   ","","","mv_par06"	,""		,""		,""		,"ZZZZZZ"			,""		,""		,""		,"","","","","","","","","",{},{},{})
//PutSX1(cPerg,"07","Status Inventario","","","mv_ch7","N", 1,0,1,"C","","","","S"  ,"mv_par07", "Nao Processado","","","","Processado","","","Estornado","","","Erro Processamento","","","Todos","","",,,)
//
//Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �E005Perg  �Autor  �Guilherme Santos    � Data �  03/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Aciona a rotina de Perguntas e chama o Browse com base nas  ���
���          �Perguntas Selecionadas.                                     ���
�������������������������������������������������������������������������͹��
���Uso       � EPCP005                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function E005Perg()
If Pergunte("PCP005",.T.)
	dbSelectArea("ZAM")
	dbClearFilter()
	PCP005Filt()
End If
	DbGoTop()
Return

/*
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �PCP005_Leg � Autor �Guilherme Santos      � Data �03/08/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cria uma janela contendo a legenda da mBrowse              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � EPCP005                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PCP005_Leg()
Local aLegenda := 	{	{"DISABLE"		,	"Processado"			},;
						{"ENABLE"		,	"Nao Processado"		},;
						{"BR_AMARELO"	,	"Estornado"				},;
						{"BR_CINZA"		,	"Erro Processamento"	}}

U_ADINF009P('EPCP005' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Historicos de Inventario')

BrwLegenda(cCadastro, "Legenda", aLegenda)
Return .T.

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PCP005_Vis�Autor  �Guilherme Santos    � Data �  03/08/06   ���
�������������������������������������������������������������������������͹��
���Desc.     �Chama tela de Visualizacao do Historico, conforme Status do ���
���          �campo ZAM_STATUS:                                            ���
���          �1 - Nao Processado                                          ���
���          �2 - Processado                                              ���
���          �3 - Estornado                                               ���
���          �4 - Erro no Processamento                                   ���
�������������������������������������������������������������������������͹��
���Uso       � EPCP005                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function PCP005_Vis(cAlias, nRegistro, nOpcao)

U_ADINF009P('EPCP005' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Historicos de Inventario')

Do Case
	Case ZAM->ZAM_STATUS == "1"		//Nao Processado
		MsgAlert ("Nao existe historico para registros nao processados.")
	Case ZAM->ZAM_STATUS == "4" .and. ZAM->ZAM_NUM <> Space(6)	//Erro Processamento
		U_PCP005_Hist(.T.)
	Otherwise						//Processado ou Estornado
		If ZAM->ZAM_NUM <> Space(6)
			U_PCP005_Hist(.T.)
		Else
			MsgAlert ("Nao existe historico para este Inventario.")
		EndIf
EndCase
Return .T.

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �PCP005_His� Autor � Guilherme Santos      � Data �05/08/2006���
�������������������������������������������������������������������������Ĵ��
���Locacao   � Fabr.Tradicional �Contato�guilherme.santos@microsiga.com.br���
�������������������������������������������������������������������������Ĵ��
���Descricao � Tela com Historico e Dados do Processamento do Inventario  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� lList2 - Se monta ou nao a Listbox2                        ���
�������������������������������������������������������������������������Ĵ��
���Retorno   �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Aplicacao �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Uso       � EPCP005                                                    ���
�������������������������������������������������������������������������Ĵ��
���Analista Resp.�  Data  � Bops � Manutencao Efetuada                    ���
�������������������������������������������������������������������������Ĵ��
���              �  /  /  �      �                                        ���
���              �  /  /  �      �                                        ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function PCP005_Hist(lList2)
//Variaveis Locais da Funcao

//�����������������������������������Ŀ
//� Inicio das variveis da Enchoice   �
//�������������������������������������
Local cAliasE  := "ZAM"        // Tabela cadastrada no Dicionario de Tabelas (SX2) que sera editada
Local nOpc     := 1            // Numero da linha do aRotina que definira o tipo de edi��o (Inclusao, Alteracao, Exclucao, Visualizacao)
Local nReg     := 1 
Local aCpoEnch := {}

// Vetor com coordenadas para criacao da enchoice no formato {<top>, <left>, <bottom>, <right>}
Local aPos		  	:= {C(002),C(002),C(085),C(392)}
Local aAlterEnch	:= {""}	   // Vetor com nome dos campos que poderao ser editados
Local nModelo	  	:= 3       	// Se for diferente de 1 desabilita execucao de gatilhos estrangeiros
Local lF3 		  	:= .F.		// Indica se a enchoice esta sendo criada em uma consulta F3 para utilizar variaveis de memoria
Local lMemoria  	:= .T.		// Indica se a enchoice utilizara variaveis de memoria ou os campos da tabela na edicao
Local lColumn	  	:= .F.		// Indica se a apresentacao dos campos sera em forma de coluna
Local caTela 	  	:= "" 		// Nome da variavel tipo "private" que a enchoice utilizara no lugar da propriedade aTela
Local lNoFolder 	:= .F.		// Indica se a enchoice nao ira utilizar as Pastas de Cadastro (SXA)
Local lProperty 	:= .T.		// Indica se a enchoice nao utilizara as variaveis aTela e aGets, somente suas propriedades com os mesmos nomes
//������������������������������������Ŀ
//� Termino das variveis da Enchoice   �
//��������������������������������������

// Variaveis da Funcao de Controle e GetArea/RestArea
Local _aArea   		:= {}
Local _aAlias  		:= {}

Local aSX3Aux		:= {}
// Variaveis Private da Funcao
Private _oDlg
Private INCLUI 		:= .F.
Private aFolder1	:= {"Historico","Lancamentos"}

U_ADINF009P('EPCP005' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Historicos de Inventario')

//@history Ticket 70142  - Rodrigo / Flek Solution - 18/07/2022 - Ajustes Dic. de dados no Banco	
aSX3Aux := FWSX3Util():GetAllFields( cAliasE )
AEVal( aSX3Aux, {|u| AAdd(aCpoEnch,{ GetSX3Cache( u,"X3_TITULO"), u } ) } )

/*
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek(cAliasE)

While !SX3->(EOF()) .And. SX3->X3_Arquivo == cAliasE

   If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo � usado.
      cNivel >= SX3->X3_Nivel                         // Nivel do Usuario � maior que o Nivel do Campo.

	  // Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao
	  // exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
      AAdd(aCpoEnch,{X3_TITULO,X3_CAMPO})
   EndIf

   SX3->(dbSkip())
End
*/

DEFINE MSDIALOG _oDlg TITLE OemtoAnsi("Historico Inventario") FROM C(177),C(183) TO C(664),C(969) PIXEL

// Defina aqui a chamada dos Aliases para o GetArea
CtrlArea(1,@_aArea,@_aAlias,{"ZAM","ZAN"}) // GetArea

// Cria as Folders do Sistema
oFolder1	:= TFolder():New(C(089),C(002),aFolder1,{},_oDlg,,,,.T.,.F.,C(383),C(148),)

// Chamadas da Enchoice do Sistema
RegToMemory(cAliasE, .F., .F.)
Enchoice(cAliasE,nReg,nOpc,/*aCRA*/,/*cLetra*/,/*cTexto*/,aCpoEnch,aPos,;
aAlterEnch,nModelo,/*nColMens*/,/*cMensagem*/,/*cTudoOk*/,_oDlg,lF3,;
lMemoria,lColumn,caTela,lNoFolder,lProperty)

// Cria Componentes Padroes do Sistema
@ C(223),C(330) Button OemtoAnsi("Fechar") Action(_oDlg:End()) Size C(045),C(012) PIXEL OF _oDlg

// Chamadas das ListBox do Sistema

PCPCList1()
If lList2			//Somente monta a Listbox2 se houve movimentacao do SD3
	PCPCList2()
EndIf

CtrlArea(2,_aArea,_aAlias) // RestArea

ACTIVATE MSDIALOG _oDlg CENTERED

Return(.T.)

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �PCPCList1() � Autor � Guilherme Santos      � Data �05/08/2006���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Montagem da ListBox - Historico                              ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function PCPCList1()
Local oListBox
Local cQuerZAN
Local aListBox	:= {}
Local aTam      := {}  
Local cObs		:= ""

//Query com dados do Historico de Processamento
cQuerZAN		:= "SELECT ZAN_FILIAL, ZAN_NUM, ZAN_ITEM, ZAN_USUARI, ZAN_DATA, ZAN_HORA, "
cQuerZAN		+= "ZAN_OP, ZAN_PERC, ZAN_QTDRAT, ZAN_TIPO, ZAN_OBS "
cQuerZAN		+= "FROM " + RetSqlName("ZAN") + " ZAN "
cQuerZAN		+= "WHERE ZAN_NUM = '" + ZAM->ZAM_NUM + "' AND D_E_L_E_T_ = ' ' "
cQuerZAN		+= "ORDER BY ZAN_ITEM, ZAN_DATA, ZAN_HORA"
cQuerZAN		:= ChangeQuery(cQuerZAN)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerZAN),"SQLZAN",.T.,.T.)

TCSetField("SQLZAN","ZAN_DATA","D",8,0)
//@history Ticket 70142  - Rodrigo / Flek Solution - 18/07/2022 - Ajustes Dic. de dados no Banco	
/*
dbSelectArea("SX3")
dbSetOrder(1)
dbSeek("ZAN")

While !SX3->(EOF()) .And. SX3->X3_Arquivo == "ZAN"

   If X3Uso(SX3->X3_Usado)    .And.;                  // O Campo � usado.
      cNivel >= SX3->X3_Nivel                         // Nivel do Usuario � maior que o Nivel do Campo.

	  // Vetor com nome dos campos que serao exibidos. Os campos de usuario sempre serao
	  // exibidos se nao existir no parametro um elemento com a expressao "NOUSER"
      AAdd(aTam,IIF(Len(AllTrim(RetTitle(X3_CAMPO)))<X3_TAMANHO,X3_TAMANHO,Len(AllTrim(RetTitle(X3_CAMPO)))))
   EndIf

   SX3->(dbSkip())
End
*/

@ C(002),C(002) ListBox oListBox Fields HEADER ;
	RetTitle("ZAN_FILIAL"),;
	RetTitle("ZAN_NUM"),;
	RetTitle("ZAN_ITEM"),;
	RetTitle("ZAN_USUARI"),;
	RetTitle("ZAN_DATA"),;
	RetTitle("ZAN_HORA"),;
	RetTitle("ZAN_OP"),;
	RetTitle("ZAN_PERC"),;  
	RetTitle("ZAN_QTDRAT"),; 
	RetTitle("ZAN_TIPO"),;
	RetTitle("ZAN_OBS"); 
	COLSIZES TamSX3("ZAN_FILIAL")[1],;
			 TamSX3("ZAN_NUM")[1],;
			 TamSX3("ZAN_ITEM")[1],;
			 TamSX3("ZAN_USUARI")[1],;
			 TamSX3("ZAN_DATA")[1],;
			 TamSX3("ZAN_HORA")[1],;
			 TamSX3("ZAN_OP")[1],;
			 TamSX3("ZAN_PERC")[1],;  
			 TamSX3("ZAN_QTDRAT")[1],; 
			 TamSX3("ZAN_TIPO")[1],;
			 TamSX3("ZAN_OBS")[1]; 
	Size C(370),C(120) Of oFolder1:aDialogs[1] Pixel
	oListBox:SetArray(aListBox)
	
dbSelectArea("SQLZAN")
dbGoTop()
If !SQLZAN->(EOF())
	While !Eof()
		cObs := StrTran(SQLZAN->ZAN_OBS,Chr(13)+Chr(10)," ")
		Aadd(aListBox,{	SQLZAN->ZAN_FILIAL,;
						SQLZAN->ZAN_NUM,;
						SQLZAN->ZAN_ITEM,;
						SQLZAN->ZAN_USUARI,;
						SQLZAN->ZAN_DATA,;
						SQLZAN->ZAN_HORA,;
						SQLZAN->ZAN_OP,;
						SQLZAN->ZAN_PERC,;
						SQLZAN->ZAN_QTDRAT,;						
						SQLZAN->ZAN_TIPO,;
						cObs})
		dbSkip()
	End
Else
	Aadd(aListBox,{	"NAO HA HISTORICO","","","","","","",""})		
Endif

oListBox:bLine     := {|| aListBox[oListBox:nAT]}

dbSelectArea("SQLZAN")
dbCloseArea()

Return Nil

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �PCPCList2() � Autor � Guilherme Santos      � Data �05/08/2006���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Montagem da ListBox                                          ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function PCPCList2()
Local aListBox		:= {}
Local oListBox
Local cQuerSD3

//Query com os Lancamentos
cQuerSD3 := "SELECT D3_FILIAL, D3_TM, D3_COD, D3_UM, D3_QUANT, D3_OP, D3_LOCAL, D3_LOCALIZ, "
cQuerSD3 += "D3_CC, D3_EMISSAO, D3_DTLANC, D3_FLAGINV, D3_NUMINV "
cQuerSD3 += "FROM " + RetSqlName("SD3") + " SD3 "
cQuerSD3 += "WHERE D3_FLAGINV = '2' AND D3_NUMINV = '" + ZAM->ZAM_NUM + "' AND D_E_L_E_T_ = ' ' OR "
cQuerSD3 += "D3_FLAGINV = '3' AND D3_NUMINV = '" + ZAM->ZAM_NUM + "' AND D_E_L_E_T_ = ' ' "
cQuerSD3 += "ORDER BY D3_NUMSEQ, D3_EMISSAO"
cQuerSD3	:= ChangeQuery(cQuerSD3)
dbUseArea(.T.,"TOPCONN",TcGenQry(,,cQuerSD3),"SQLSD3",.T.,.T.)

TCSetField("SQLSD3","D3_QUANT","N",16,3)
TCSetField("SQLSD3","D3_EMISSAO","D",8,0)
TCSetField("SQLSD3","D3_DTLANC","D",8,0)

@ C(002),C(002) ListBox oListBox Fields HEADER ;
	RetTitle("D3_FILIAL"),;
	RetTitle("D3_TM"),;
	RetTitle("D3_COD"),;
	RetTitle("D3_UM"),;
	RetTitle("D3_QUANT"),;
	RetTitle("D3_OP"),;
	RetTitle("D3_LOCAL"),;
	RetTitle("D3_LOCALIZ"),;
	RetTitle("D3_CC"),;
	RetTitle("D3_EMISSAO"),;
	RetTitle("D3_DTLANC"),;
	RetTitle("D3_FLAGINV"),;
	RetTitle("D3_NUMINV");
	Size C(370),C(120) Of oFolder1:aDialogs[2] Pixel
	oListBox:SetArray(aListBox)

dbSelectArea("SQLSD3")
dbGoTop()

If !SQLSD3->(EOF())
	While !Eof()
		Aadd(aListBox,{	SQLSD3->D3_FILIAL,;
		SQLSD3->D3_TM,;
		SQLSD3->D3_COD,;
		SQLSD3->D3_UM,;
		SQLSD3->D3_QUANT,;
		SQLSD3->D3_OP,;
		SQLSD3->D3_LOCAL,;
		SQLSD3->D3_LOCALIZ,;
		SQLSD3->D3_CC,;
		SQLSD3->D3_EMISSAO,;
		SQLSD3->D3_DTLANC,;
		SQLSD3->D3_NUMINV})
		dbSkip()
	End
Else
	Aadd(aListBox,{	"NAO HA LANCAMENTOS","","","","","","","","","","",""})
EndIf

oListBox:bLine := {|| aListBox[oListBox:nAT]}

dbSelectArea("SQLSD3")
dbCloseArea()

Return Nil

/*������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������Ŀ��
���Programa   �   C()      � Autor � Norbert Waage Junior  � Data �10/05/2005���
����������������������������������������������������������������������������Ĵ��
���Descricao  � Funcao responsavel por manter o Layout independente da       ���
���           � resolu��o horizontal do Monitor do Usuario.                  ���
�����������������������������������������������������������������������������ٱ�
��������������������������������������������������������������������������������
������������������������������������������������������������������������������*/
Static Function C(nTam)
Local nHRes	:=	GetScreenRes()[1]	//Resolucao horizontal do monitor
Do Case
	Case nHRes == 640	//Resolucao 640x480
		nTam *= 0.8
	Case nHRes == 800	//Resolucao 800x600
		nTam *= 1
	OtherWise			//Resolucao 1024x768 e acima
		nTam *= 1.28
	End Case
	//���������������������������Ŀ
	//�Tratamento para tema "Flat"�
	//�����������������������������
	If (Alltrim(GetTheme()) == "FLAT").Or. SetMdiChild()
		nTam *= 0.90
	EndIf
	Return Int(nTam)
	
/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � CtrlArea � Autor �Ricardo Mansano     � Data � 18/05/2005  ���
�������������������������������������������������������������������������͹��
���Locacao   � Fab.Tradicional  �Contato � mansano@microsiga.com.br       ���
�������������������������������������������������������������������������͹��
���Descricao � Static Function auxiliar no GetArea e ResArea retornando   ���
���          � o ponteiro nos Aliases descritos na chamada da Funcao.     ���
���          � Exemplo:                                                   ���
���          � Local _aArea  := {} // Array que contera o GetArea         ���
���          � Local _aAlias := {} // Array que contera o                 ���
���          �                     // Alias(), IndexOrd(), Recno()        ���
���          �                                                            ���
���          � // Chama a Funcao como GetArea                             ���
���          � P_CtrlArea(1,@_aArea,@_aAlias,{"SL1","SL2","SL4"})         ���
���          �                                                            ���
���          � // Chama a Funcao como RestArea                            ���
���          � P_CtrlArea(2,_aArea,_aAlias)                               ���
�������������������������������������������������������������������������͹��
���Parametros� nTipo   = 1=GetArea / 2=RestArea                           ���
���          � _aArea  = Array passado por referencia que contera GetArea ���
���          � _aAlias = Array passado por referencia que contera         ���
���          �           {Alias(), IndexOrd(), Recno()}                   ���
���          � _aArqs  = Array com Aliases que se deseja Salvar o GetArea ���
�������������������������������������������������������������������������͹��
���Aplicacao � Generica.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
Static Function CtrlArea(_nTipo,_aArea,_aAlias,_aArqs)
Local _nN
// Tipo 1 = GetArea()
If _nTipo == 1
	_aArea   := GetArea()
	For _nN  := 1 To Len(_aArqs)
		DbSelectArea(_aArqs[_nN])
		AAdd(_aAlias,{ Alias(), IndexOrd(), Recno()})
	Next
	// Tipo 2 = RestArea()
Else
	For _nN := 1 To Len(_aAlias)
		DbSelectArea(_aAlias[_nN,1])
		DbSetOrder(_aAlias[_nN,2])
		DbGoto(_aAlias[_nN,3])
	Next
	RestArea(_aArea)
Endif
Return Nil   

// Menudef()
Static Function MenuDef()

	Local aRotina := {	{"Pesquisar"	, "axPesqui"		, 	0,	1	},;	//"Pesquisar"
						{"Historico"	, "U_PCP005_Vis"	,	0,	2	},;	//"Historico"
						{"Legenda"		, "U_PCP005_Leg"	,	0,	3	}}	//"Legenda" 
Return(aRotina)
