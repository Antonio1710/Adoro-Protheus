#INCLUDE "rwmake.ch"

/*/{Protheus.doc} User Function nomeFunction
	Manutencao  Tabela ZV1 do Frango Vivo
	@type  Function
	@author Daniel Pitthan Silveira
	@since 11/07/2005
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 69945 - Fernando Macieira - 21/03/2022 - Projeto FAI - Ordens Carregamento - Frango vivo
/*/
User Function AD0135 ()
                        
	Local _cRet := ""

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Manutencao  Tabela ZV1 do Frango Vivo')

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Declaracao de Variaveis                                             �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	Private cCadastro := "Manutencao Frango Vivo"
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Array (tambem deve ser aRotina sempre) com as definicoes das opcoes �
	//� que apareceram disponiveis para o usuario. Segue o padrao:          �
	//� aRotina := { {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
	//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>},;                      �
	//�              . . .                                                  �
	//�              {<DESCRICAO>,<ROTINA>,0,<TIPO>} }                      �
	//� Onde: <DESCRICAO> - Descricao da opcao do menu                      �
	//�       <ROTINA>    - Rotina a ser executada. Deve estar entre aspas  �
	//�                     duplas e pode ser uma das funcoes pre-definidas �
	//�                     do sistema (AXPESQUI,AXVISUAL,AXINCLUI,AXALTERA �
	//�                     e AXDELETA) ou a chamada de um EXECBLOCK.       �
	//�                     Obs.: Se utilizar a funcao AXDELETA, deve-se de-�
	//�                     clarar uma variavel chamada CDELFUNC contendo   �
	//�                     uma expressao logica que define se o usuario po-�
	//�                     dera ou nao excluir o registro, por exemplo:    �
	//�                     cDelFunc := 'ExecBlock("TESTE")'  ou            �
	//�                     cDelFunc := ".T."                               �
	//�                     Note que ao se utilizar chamada de EXECBLOCKs,  �
	//�                     as aspas simples devem estar SEMPRE por fora da �
	//�                     sintaxe.                                        �
	//�       <TIPO>      - Identifica o tipo de rotina que sera executada. �
	//�                     Por exemplo, 1 identifica que sera uma rotina de�
	//�                     pesquisa, portando alteracoes nao podem ser efe-�
	//�                     tuadas. 3 indica que a rotina e de inclusao, por�
	//�                     tanto, a rotina sera chamada continuamente ao   �
	//�                     final do processamento, ate o pressionamento de �
	//�                     <ESC>. Geralmente ao se usar uma chamada de     �
	//�                     EXECBLOCK, usa-se o tipo 4, de alteracao.       �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
	//� MBROWSE sera identica a da AXCADASTRO:                              �
	//�                                                                     �
	//� cDelFunc  := ".T."                                                  �
	//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
	//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
	//�                { "Incluir"      ,"AxInclui" , 0, 3},;               �
	//�                { "Alterar"      ,"AxAltera" , 0, 4},;               �
	//�                { "Excluir"      ,"AxDeleta" , 0, 5} }               �
	//�                                                                     �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
	//쿞EMAFORO                                                    �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

	aCores            := {{"ZV1_STATUS='I'"  	,"BR_AZUL" },;
						{"ZV1_STATUS='R'"  	,"BR_LARANJA"},;
						{"ZV1_STATUS='M'"  	,"BR_MARRON"},;
						{"ZV1_STATUS='G'"  	,"BR_VERDE"},;
						{"ALLTRIM(ZV1_STATUS)=''"  	,"BR_PRETO"}}
						

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Monta um aRotina proprio                                            �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	/*
	Private aRotina := {{"Pesquisar"  ,"AxPesqui"    ,0,1},;
						{"Visualizar" ,"AxVisual"    ,0,2},; 
						{"Alterar "   ,'ExecBlock("AltFv1")' ,0,3},;
						{"Excluir"    ,'ExecBlock("DelFv1")' ,0,4},;                         
						{"Mnt Frete"  ,'ExecBlock("MntFrt")' ,0,5},;
						{"Pesagem Manual   " ,'ExecBlock("AD0144")' ,0,6},; 
						{"Guia Cupom       " ,'ExecBlock("AD0145")' ,0,7},;                    
						{"Gerar Frete      " ,'ExecBlocK("AD0153")' ,0,8},;
						{"Ajuste de Pesos  " ,'ExecBlocK("AD0167")' ,0,9},; 
						{"Legenda"           ,'ExecBlock("LgdFV1")' ,0,10}}                  
	*/                     

	// Nova a Rotina chamado 037812 William Costa
	Private aRotina := {{"Pesquisar"  ,"AxPesqui"    ,0,1},;
						{"Mnt Frete"  ,'ExecBlock("MntFrt")' ,0,5},;
						{"Legenda"           ,'ExecBlock("LgdFV1")' ,0,10}}                     

	Private cDelFunc:= ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

	Private cString := "ZV1"        
	/*Criado parametro MV_#BLQFV onde o valor ser� subtraido a database do sistema e comparado com a data do ZV1 para total bloqueio do registro - HC */
	Private dDtCorte :=(dDataBase-GetMV("MV_#BLQFV"))
	Private lControl := .F.
	/**********************************************************************************/
	dbSelectArea("ZV1")
	dbSetOrder(1)

	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//� Executa a funcao MBROWSE. Sintaxe:                                  �
	//�                                                                     �
	//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
	//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
	//�                        exibido. Para seguir o padrao da AXCADASTRO  �
	//�                        use sempre 6,1,22,75 (o que nao impede de    �
	//�                        criar o browse no lugar desejado da tela).   �
	//�                        Obs.: Na versao Windows, o browse sera exibi-�
	//�                        do sempre na janela ativa. Caso nenhuma este-�
	//�                        ja ativa no momento, o browse sera exibido na�
	//�                        janela do proprio SYSTEM.                   �
	//� Alias                - Alias do arquivo a ser "Browseado".          �
	//� aCampos              - Array multidimensional com os campos a serem �
	//�                        exibidos no browse. Se nao informado, os cam-�
	//�                        pos serao obtidos do dicionario de dados.    �
	//�                        E util para o uso com arquivos de trabalho.  �
	//�                        Segue o padrao:                              �
	//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
	//�                                     {<CAMPO>,<DESCRICAO>},;         �
	//�                                     . . .                           �
	//�                                     {<CAMPO>,<DESCRICAO>} }         �
	//�                        Como por exemplo:                            �
	//�                        aCampos := { {"TRB_DATA","Data  "},;         �
	//�                                     {"TRB_COD" ,"Codigo"} }         �
	//� cCampo               - Nome de um campo (entre aspas) que sera usado�
	//�                        como "flag". Se o campo estiver vazio, o re- �
	//�                        gistro ficara de uma cor no browse, senao fi-�
	//�                        cara de outra cor.                           �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

	dbSelectArea(cString)
	mBrowse( 6,1,22,75,cString,,,,,2,aCores)

Return()                             

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿗gdFV1    튍utor  쿏ANIEL              � Data �  06/21/06   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     쿘ONTA A LEGENDA PARA O USU핾IO NO MENU                      볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AD0135()                                                   볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/


User Function LgdFV1()

U_ADINF009P('AD0135' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Manutencao  Tabela ZV1 do Frango Vivo')

BrwLegenda(cCadastro,"Valores",{{"BR_AZUL"   	,"PRIMEIRA PESAGEM" },;
								{"BR_LARANJA"	,"SEGUNDA PESAGEM" },;
								{"BR_MARRON"   	,"PESAGEM MANUAL" },;
								{"BR_VERDE"   	,"GERADO FRETE" },;
								{"BR_PRETO"   	,"ORDEM NAO UTILIZADA" }})
Return(.T.)      


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿌ltFv1    튍utor  쿏ANIEL              � Data �  06/21/06   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     쿑AZ A VALIDACAO PARA ALTERACAO DOS REGISTROS EM ZV1010      볍�
굇�          쿣ERIFICA O STATUS PARA PERMITIR A ALTERACAO                 볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AD0135()                                                   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튝anut     쿐xecBlock Ante ALTERACAO   PALTFV01                         볍�
굇�          쿐xecBlock POS  ALTERACAO   PALTFV02                         볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/



User Function AltFv1()

Local Reg:=Recno()       
Local Opc:=3  

U_ADINF009P('AD0135' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Manutencao  Tabela ZV1 do Frango Vivo')

/*Incluir variaval com  o campo ZV1_DTABAT */
lControl := fValAlt(ZV1->ZV1_DTABAT)  // Criado em 21/07  -  HC para travar por data os registros
                     
	If  ExistBlock("PALTFV01")
 	     ExecBlock("PALTFV01")
 	EndIf
  &&Chamado 006739 em 11/05/10 e corrigido (forcado return) para nao efetuar nenhuma alteracao.
  &&If lControl .Or. (!EMPTY(ZV1_STATUS=''))
  If lControl .Or. ZV1->ZV1_STATUS=='G'
  	MsgInfo("Guia Processada,Nao posso alterar")
  	return()
  Else                  
    //Abre o AxAltera, alias, Recno e OPC
    //OPC = 1 Vizualiza
    //OPC = 3 Altera com validacao 
  	AxAltera("ZV1",Reg,Opc)	
  EndIf     
 	If  ExistBlock("PALTFV02")
 	     ExecBlock("PALTFV02")
 	EndIf
  
Return()  
          
/************************************************************************/
/* Fun豫o para validar alteracoes de registros    */
Static Function fValAlt(dPar)
if dPar < dDtCorte
   lControl := .T.
Else
   lControl := .F.
Endif
Return(lControl)                                   
/************************************************************************/

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿛ALTFV02  튍utor  쿏aniel              � Data �  07/24/06   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     � Ponto de Entrada apos Alteracao das Ordens de Carregamento 볍�
굇�          �                                                            볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AD0135 - MANUTENCAO FRANGO VIVO							  볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/

USER FUNCTION PALTFV02()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿝etorno                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
Local _lRet:=.F.
Local _aArea:=GetArea()
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿣ariaves de atualizacao                        �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//ZV5
Local ZV1NUMOC	:=ZV1_NUMOC
Local ZV1QTDAPN :=ZV1_QTDAPN
Local ZV1DTAREA :=ZV1_DTAREA
//ZV2
/*Local ZV11PESO :=ZV1->ZV1_1PESO
Local ZV12PESO :=ZV1->ZV1_2PESO 
Local ZV1GUIA  :=ZV1->ZV1_GUIAPE
*/ 

U_ADINF009P('AD0135' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Manutencao  Tabela ZV1 do Frango Vivo')

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿛ROCURO EM ZV5 A QTD DE APN, SE ENCONTRO ALTERO�
//쿞E NAO ENCONTRO CRIO REC EM ZV5                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
IF  ZV1QTDAPN <>0
	DbSelectArea("ZV5")
	DbGoTop()
	DbSetOrder(1)
	If DbSeek(xFilial("ZV5")+ZV1NUMOC,.T.)
		RecLock("ZV5",.F.)
		REPLACE ZV5_QTDAVE WITH ZV1QTDAPN
		MsUnlock()
	Else  
		Reclock("ZV5",.T.)
			ZV5->ZV5_FILIAL := FWxFilial("ZV5") // @history ticket 69945 - Fernando Macieira - 21/03/2022 - Projeto FAI - Ordens Carregamento - Frango vivo
			REPLACE ZV5_NUMOC 	WITH ZV1NUMOC
			REPLACE ZV5_QTDAVE  WITH ZV1QTDAPN
			REPLACE ZV5_DTABAT	WITH ZV1DTAREA
	   MsUnlock() 
	EndIf                       
ENDIF

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴��
//쿌TUALIZA ZV2010  COM OS PESOS           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴��
/*DbSelectArea("ZV2")
DbSetOrder(1)
IF 	DbSeek(xFilial("ZV2")+ZV1GUIA,.T.) 
	RECLOCK("ZV2",.F.)
	REPLACE ZV2_1PESO WITH ZV11PESO
	REPLACE ZV2_2PESO WITH ZV12PESO
	MSUNLOCK()	
Else
	
EndIf*/
	RestArea(_aArea)
Return(_lRet)



/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿏elFv1    튍utor  쿏ANIEL              � Data �  06/21/06   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     쿣ALIDACAO DE EXCLUSAO DAS ORDENS DE CARREGAMENTO            볍�
굇�          쿣ERIFICA SE A ORDEM NAO ESTA RELACIONADA COM ZV2010         볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AD0135()                                                   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튝anut     쿐xecBlock Ante Delecao   PDELFV01                           볍�
굇�          쿐xecBlock POS  Delecao   PDELFV02                           볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�


*/

User Function DelFv1()	

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿣erificar se FV1 n�o possui relacionamento em Fv2�
//쿎aso tenha Perguntar se deve excluir FV2 e FV1   �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�  
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//쿏ECLARACAO DE VARIAVEIS                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Local _aArea:=GetArea()
Local _cChave                          
Local _dtaExOc:=GETMV("MV_DTAEXOC")

U_ADINF009P('AD0135' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Manutencao  Tabela ZV1 do Frango Vivo')
    
//旼컴컴컴컴컴컴컴커
//쿛ONTO DE ENTRADA�
//읕컴컴컴컴컴컴컴켸
  
	If  ExistBlock("PDELFV01")
    	ExecBlock("PDELFV01")
  	EndIf
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿣ALIDACAO DA DATA                                         �
//|GETMV("MV_DTAEXOC") PARAMETROS DOS DIAS DE EXCLUSAO       |
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸

IF !(DTOS(ZV1->ZV1_DTABAT)>=DTOS(DATE()-_dtaExOc))
  MsgInfo("Data Abate "+DTOC(ZV1_DTABAT)+" Inferior a data "+DTOC(DATE()-_dtaExOc))
  RestArea(_aArea)
  Return() 	
EndIf      
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿣ALIDACAO DO FRETE                                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
lControl := fValAlt(ZV1->ZV1_DTABAT) 
IF lControl .Or. !ALLTRIM(ZV1_STATUS)=''
  MsgInfo("Frete ja gerado para esse registro.")
  RestArea(_aArea)
  Return() 	
ENDIF 
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//쿣ALIDACAO EM ZV2                                              �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸  
//ZV2_FILIAL+ZV2_GUIA+ZV2_PLACA
	_cChave:=xFilial("ZV1")+ZV1->ZV1_GUIAPE+ZV1_PPLACA

/*SUBSTITUIDO PELAS INSTRU합ES ABAIXO, POIS QDO TEM PESAGEM N홒 DEIXA EXCLUIR A ORDEM.
//POR ADRIANA EM 13/05/2008
	dbselectArea("ZV2") 
	DbSetOrder(2)
	IF DBSEEK(_cChave,.T.)	
		//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
		//쿞E ENCONTREI RELACIONAMENTO EM ZV2 PERGUNTO�
		//쿞E DEVO EXCLUIR EM ZV1  E ZV2              �
		//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�		
		MsgInfo("Registro Relacionado Com ZV2(Pesagens). Nao posso Apagar")
		RestArea(_aArea)
	Return() 	
	Else   
	  RestArea(_aArea)
	  RecLock("ZV1",.F.)     
        DbDelete()
      MsUnLock()          		  
      RestArea(_aArea)
      Return()
	EndIf	      
RestArea(_aArea)
*/
dbselectArea("ZV2")
DbSetOrder(2)
IF DBSEEK(_cChave,.T.)
	//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	//쿞E ENCONTREI RELACIONAMENTO EM ZV2 PERGUNTO�
	//쿞E DEVO EXCLUIR EM ZV1  E ZV2              �
	//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
	if !MsgBox("Registro Relacionado Com ZV2(Pesagens). Confirma Exclusao da Ordem e pesagem?","ATEN플O","YESNO")
		RestArea(_aArea)
		Return()
	endif
   MsgInfo("ATEN플O!!! EXCLUINDO ORDEM E PESAGEM NO PROTHEUS, INFORMAR LOGISTICA QUE A PESAGEM REFERENTE A ORDEM "+ZV1->ZV1_NUMOC+" DEVER� TAMBEM SER EXCLUIDA NO MICRA.")
	while ZV2_FILIAL+ZV2_GUIA+ZV2_PLACA = _cChave
		RecLock("ZV2",.F.)
		DbDelete()
		msUnLock()
		dbskip()
	enddo
endif
RecLock("ZV1",.F.)
DbDelete()
msUnLock()
RestArea(_aArea)

//旼컴컴컴컴컴컴컴커
//쿛ONTO DE ENTRADA�
//읕컴컴컴컴컴컴컴�
 	If  ExistBlock("PDELFV02")
 	     ExecBlock("PDELFV02")
    EndIf
Return()  
         


/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇튡rograma  쿘ntFrt    튍utor  쿏ANIEL              � Data �  06/21/06   볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒esc.     쿗IBERA A ORDEM APOS GERADO O FRETE.						  볍�
굇�          쿣ERIFICA RELACIONAMENTO EM SZK.							  볍�
굇�          쿐XCLUI REGESTRO EM SZK. 									  볍�
굇�          쿗IMPA STATUS EM ZV1 PARA MANUTENCAO DA ORDEM                볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � AD0135                                                     볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
*/                      
User Function MntFrt()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de Variaveis                                             �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
Local _aArea:=GetArea()
Local _NumOc:=ZV1_NUMOC
Local _Guia :=ZV1_GUIAPE
Local _DtaBt:=ZV1_DTABAT
Local _Plac :=UPPER(ZV1_PPLACA)
Local _Sts  :=ZV1_STATUS
Private _Chave 

U_ADINF009P('AD0135' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Manutencao  Tabela ZV1 do Frango Vivo')

lControl := fValAlt(ZV1->ZV1_DTABAT)  // Criado em 21/07  -  HC para travar por data os registros

if lControl
  	MsgInfo("Guia Processada,Nao posso alterar")
   RestArea(_aArea)
   Return
Endif   

// inicio chamado 037812 WILLIAM COSTA, GARANTE QUE A GUIA N홒 E EM BRANCO
if ALLTRIM(_Guia) == ''
	MsgStop("OL� " + Alltrim(cUserName) + CHR(10) + CHR(13) + ;
			"A Guia n�o pode estar em branco, favor verificar!!!", "AD0135")
	RestArea(_aArea)
    Return
Endif   
// final chamado 037812 WILLIAM COSTA, GARANTE QUE A GUIA N홒 E EM BRANCO

//Pergunto se devo fazer manutencao do frete
If !MsgBox("Manutencao de Frete","Faz Manutencao?","YESNO") 
	RestArea(_aArea)
	Return
EndIf

//______________________________
//Verifico se foi Gerado Frete
//______________________________
If !Empty(_Sts)
  //___________________________________________
  //Monto a Chave                           
  //ZK_FILIAL+ZK_GUIA+DTOS(ZK_DTENTR)+ZK_PLACA
  //___________________________________________    
  _Chave:=xFilial("ZV1")+_Guia+DTOS(_DtaBt) //+_Plac chamado 037812 retirado o _PLAC da chave, pois indiferente da placa tem que encontrar o frete baseado na guia para deletar e voltar a ajustar a ordem de carregamento William Costa 26/10/2017  
  DbSelectArea("SZK")  
  DbSetOrder(2) 
  //____________________________________
  //Se encontro o registro em SZk
  //Apago o Registro 
  //e limpo o status em ZV1
  //____________________________________  
  If DbSeek(_Chave,.T.)
  	
  	//grava log chamado 041202 - WILLIAM COSTA 23/04/2018
  	u_GrLogZBE (Date(),TIME(),cUserName," RecLock(SZK,.T.)","LOGISTICA","AD0135",;
  	"Filial: "+xFilial("ZV1")+" Data: "+DTOS(_DtaBt)+" GUIA: "+CVALTOCHAR(_Guia),ComputerName(),LogUserName())
  
    RecLock("SZK",.F.)
    DbDelete()
    MsUnlock()   
    RestArea(_aArea)
    //Replace ZV1_STATUS WITH ''  Chamado 005562 - HC Consys Mauricio 18/12/09.
    IF ZV1_STATUS == "G"
       RecLock("ZV1",.F.)
          Replace ZV1_STATUS WITH 'R'
       MsUnlock()
    ENDIF          
    MsgInfo("Registro pronto para manutencao")
  Else
  	//____________________________________________________
  	//Se nao encontro o registro em SZK 
  	//pergunto se ele quer gerar o frete 
  	//para esse registro 
  	//limpo o status em ZV1
  	//____________________________________________________
  	
  	//grava log chamado 041202 - WILLIAM COSTA 23/04/2018
  	u_GrLogZBE (Date(),TIME(),cUserName," ELSE RecLock(SZK,.T.)","LOGISTICA","AD0135",;
  	"Filial: "+xFilial("ZV1")+" Data: "+DTOS(_DtaBt)+" GUIA: "+CVALTOCHAR(_Guia),ComputerName(),LogUserName())
  	  	
    If !MsgBox("Gerar frete?","Gerar frete para esse registro?","YESNO")
	    RestArea(_aArea)
		 Return 
    Else       
      RestArea(_aArea)
      //Replace ZV1_STATUS WITH ''   Chamado 005562 - HC Consys Mauricio 18/12/09.
      IF ZV1_STATUS == "G"
         RecLock("ZV1",.F.)
            Replace ZV1_STATUS WITH 'R'
         MsUnlock()
      ENDIF         
      U_AD0153()
      MsgInfo ("Frete processado.")
    EndIf    
  EndIf
Else
  //____________________________________
  //Verifico se esta relacionado com ZV2
  //____________________________________  
  If (Empty(_Guia))
    //___________________________________________________
    //Caso nao esteja pergunto se deve apagar o registro
    //chamo a rotina de exclusao
    //___________________________________________________
	If !MsgInfo ("Registro Sem Guia.")	 
		RestArea(_aArea)
		Return 
	Else		
		U_DelFv1()
		MsgInfo("Ordem Excluida.")
	EndIf         
  Else
    MsgInfo("Registro Relacionado Com ZV2(Pesagens). Nao Posso Apagar")
	RestArea(_aArea)
	Return 
  EndIf		
EndIf 
RestArea(_aArea)
Return 
