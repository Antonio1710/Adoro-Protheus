#Include "Matr150.ch"
//#include "fivewin.Ch"

Static nSegundaUnid
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � MATR150  � Autor � Claudinei M. Benzi    � Data � 05/06/92 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Emissao das Cotacoes                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
�������������������������������������������������������������������������Ĵ��
��� ATUALIZACOES SOFRIDAS DESDE A CONSTRUCAO INICIAL.                     ���
�������������������������������������������������������������������������Ĵ��
��� PROGRAMADOR  � DATA   � BOPS �  MOTIVO DA ALTERACAO                   ���
�������������������������������������������������������������������������Ĵ��
��� Edson  M.    �04/11/98�xxxxxx� Acerto no lay-out p/ o ano 2000.       ���
��� Bruno        �14/12/98�melhor� Acerto na impressao do STR0031.        ���
��� Edson   M.   �30/03/99�XXXXXX�Passar o tamanho na SetPrint.           ���
��� Patricia Sal.�21/12/99�XXXXXX�Acerto Lay-Out, Fornec. com 20 pos.e Lj.���
���              �        �      �com 4 pos.                              ���
��� Patricia Sal.�08/05/00�003907�Aumentar a Pict. do campo Quantidade.   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER Function Matr150B(cNumCota) //RAFAEL H. SILVEIRA 13/04/2006


//��������������������������������������������������������������Ŀ
//� Define Variaveis                                             �
//����������������������������������������������������������������
LOCAL wnrel
LOCAL cDesc1:=STR0001	//"Emissao das cotacoes de compras"
LOCAL cDesc2:=""
LOCAL cDesc3:=" "
LOCAL Tamanho:="M"
LOCAL cTel   :=""
LOCAL cEndEnt:=""
LOCAL cEmail :=""

STATIC aTamSXG, aTamSXG2

PRIVATE titulo:=STR0002	//"Relacao de Cotacoes"
PRIVATE aReturn := { STR0003, 1,STR0004, 2, 2, 1, "",0 }		//"Zebrado"###"Administracao"
PRIVATE nomeprog:="MATR150",nLastKey := 0
PRIVATE cString :="SC8" 

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

//cPerg  :="MTR150"
cPerg  := PADR("MTR150",10," ")
wnrel  := "MATR150"
//��������������������������������������������������������������Ŀ
//� Verifica as perguntas selecionadas                           �
//����������������������������������������������������������������
//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01	     	  Do Numero                              �
//� mv_par02	     	  Ate o Numero 		                     �
//� mv_par03	     	  Do Fornecedor                          �
//� mv_par04              Ate o Fornecedor            	     	 �
//� mv_par05              Ate a data de validade      	   	     �
//� mv_par06              Campo Descricao do Produto             �
//� mv_par07              Endrre�o Fiscal                        �
//� mv_par08              Cidade - Estado                        �
//� mv_par09              Fax                                    �
//� mv_par10              Qual Unidade de Medida ?               �
//� mv_par11              Telefone                               �
//� mv_par12              Endereco de Entrega ?                  �
//� mv_par13              Endereco de e-mail  ?                  �
//����������������������������������������������������������������

If cNumCota == Nil
	cPerg  := PADR("MTR150",10," ")
	//@history Ticket 70142  - Edvar / Flek Solution - 06/04/2022 - Retirada de fun��o PUTSX1
	//AjustaSx1(cPerg)
	pergunte(cPerg,.F.)
Else
	cPerg  := PADR("MR150A",10," ")
	//@history Ticket 70142  - Edvar / Flek Solution - 06/04/2022 - Retirada de fun��o PUTSX1
	//AjustaSx1(cPerg)
	Pergunte(cPerg,.F.)
EndIf

// Verifica conteudo da variavel static p/ Grupo Fornec. (001) e Loja (002)
aTamSXG  := If(aTamSXG  == NIL, TamSXG("001"), aTamSXG)
aTamSXG2 := If(aTamSXG2 == NIL, TamSXG("002"), aTamSXG2)

wnrel:=SetPrint(cString,wnrel,cPerg,@Titulo,cDesc1,cDesc2,cDesc3,.F.,,,Tamanho)

If nLastKey = 27
	Set Filter To
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey = 27
	Set Filter To
	Return
Endif
If !Empty(cNumCota)
    cEmail       := mv_par09
    cEndEnt      := mv_par08
	cTel         := mv_par07
	nSegundaUnid := mv_par06		// Grupo MR150A
	mv_par09     := mv_par05
	mv_par08     := mv_par04
	mv_par07     := mv_par03
	mv_par06     := mv_par02
	mv_par05     := mv_par01
	nomeprog     := "MATA130"
	mv_par01     := cNumCota
	mv_par02     := cNumCota
	mv_par03     := "      "
	mv_par04     := "ZZZZZZ"
Else
	nSegundaUnid := mv_par10
	cTel         := mv_par11		// Grupo MR150A
    cEndEnt      := mv_par12
    cEmail       := mv_par13
EndIf

RptStatus({|lEnd| R150Imp(@lEnd,wnrel,cString,@cTel,cEndEnt,cEmail)},Titulo)

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � R150IMP  � Autor � Cristina M. Ogura     � Data � 10.11.95 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada do Relatorio                                       ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MATR150                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function R150Imp(lEnd,wnrel,cString,cTel,cEndEnt,cEmail)

LOCAL cNumero  := ""
LOCAL cFornece := ""
LOCAL cLoja    := ""
LOCAL cDescri  := ""
LOCAL cCompDes  := ""
LOCAL cabec1   := ""
LOCAL cabec2   := ""
LOCAL cabec3   := ""
LOCAL cContato := ""
LOCAL cObs01   := ""
LOCAL cObs02   := ""
LOCAL cObs03   := ""
LOCAL cObs04   := ""
LOCAL cVar     := ""
LOCAL cbCont   := 0
LOCAL nItem    := 0
LOCAL nLinObs  := 0
LOCAL dEmissao

limite   := 132
li       := 80
m_pag    := 1
nPag     := 0
//�������������������������������������������������������������������Ŀ
//� Inicializa os codigos de caracter Comprimido/Normal da impressora �
//� Faz manualmente porque nao chama a funcao Cabec()                 �
//���������������������������������������������������������������������
@ 0,0 PSAY AvalImp(Limite)

//��������������������������������������������������������������Ŀ
//� Pesquisa Numero da Cotacao                                   �
//����������������������������������������������������������������
dbSelectArea("SC8")
dbSetOrder(1)
Set SoftSeek On
dbSeek(xFilial()+mv_par01)
Set SoftSeek Off

SetRegua(RecCount())

While xFilial() = C8_FILIAL .And. C8_NUM >= mv_par01 .And. C8_NUM <= mv_par02 .And. !Eof()
	
	IncRegua()
	
	//��������������������������������������������������������������Ŀ
	//� Verifica Fornecedor                                          �
	//����������������������������������������������������������������
	IF C8_FORNECE < mv_par03 .OR. C8_FORNECE > mv_par04
		dbSkip()
		Loop
	Endif
	
	//��������������������������������������������������������������Ŀ
	//� Verifica Data de Validade ou se ja tem pedido feito          �
	//����������������������������������������������������������������
	IF C8_VALIDA > mv_par05 .OR. !Empty(C8_NUMPED)
		dbSkip()
		Loop
	Endif
	
	cContato := SC8->C8_CONTATO
	dEmissao := SC8->C8_EMISSAO
	
	IF li > 58
		nPag ++
		@0 ,  0 PSAY STR0005	//"PREZADOS SENHORES."
		@ 00,70 PSAY STR0006 + SC8->C8_NUM +" "+SC8->C8_ITEM+ STR0007 + DTOC(SC8->C8_VALIDA) +Space(6)+"Pagina: " + STRZERO(nPag,4) 		//"COTACAO N. "###" Vencimento "
		dbSelectArea("SA2")
		dbSeek(xFilial()+SC8->C8_FORNECE+SC8->C8_LOJA)
		If aTamSXG[1] != aTamSXG[3]
			@1 ,  0 PSAY SubStr(A2_NOME,1,25)+" ("+A2_COD+" - "+A2_LOJA+")"
		Else
			@1 ,  0 PSAY SubStr(A2_NOME,1,40)+" ("+A2_COD+" - "+A2_LOJA+")"
		Endif
		@1 , 58 PSAY "|"
		@2 ,  0 PSAY A2_END
		@2 , 58 PSAY STR0008	//"| Por favor queira referenciar este numero para quaisquer troca de"
		@3 ,  0 PSAY A2_BAIRRO
		@3 , 58 PSAY STR0009	//"| informacoes referentes a esta cotacao."
		@4 ,  0 PSAY STR0010	+PADR(ALLTRIM(SA2->A2_DDD)+IIF(!EMPTY(ALLTRIM(SA2->A2_DDD))," ","")+ALLTRIM(SA2->A2_TEL),15)		//"Fone: "
		@4 , 58 PSAY "|"+Space(28)+STR0011		//"Atenciosamente."
		@5 ,  0 PSAY STR0012+SA2->A2_FAX			//"Fax : "
		@5 , 58 PSAY "| "+ SM0->M0_NOMECOM
		
		cEndere	:= Iif(Empty(MV_PAR07), Iif(Empty(SM0->M0_ENDENT),SM0->M0_ENDCOB,SM0->M0_ENDENT), MV_PAR07)
		cCidEst	:= Iif(Empty(MV_PAR08), Iif(Empty(SM0->M0_CIDENT+SM0->M0_ESTENT), SM0->M0_CIDCOB + " " + SM0->M0_ESTCOB,  SM0->M0_CIDENT + " " + SM0->M0_ESTENT),MV_PAR08)
		cFax	:= Iif(Empty(MV_PAR09), SM0->M0_FAX, MV_PAR09)
		cTel    := Iif(Empty(cTel), SM0->M0_TEL, cTel)
		@6 , 58 PSAY "| "+ cEndere
		@7 ,  0 PSAY STR0013	//"Solicitamos de V Sas. cotacao de precos para os produtos"
		@7 , 58 PSAY "| "+ cCidEst
		@8 ,  0 PSAY STR0014	//"discriminados conforme os padroes abaixo estabelecidos:"
		@8 , 58 PSAY "| "+ STR0010 + cTel +	 STR0015	 + cFax		//"| Fone : " "| Fax : "
		@9 , 58 PSAY STR0033 + cEmail // " e-mail :"	                     
		@10,  0 PSAY __PrtThinLine()
		@11,  0 PSAY STR0016	//"ITM   N/Vosso Codigo Descricao da Mercadoria        Quantidade UN Descricao Complementar"
		@12,  0 PSAY Replicate("-", 4)
		@12,  5 PSAY Replicate("-",15)
		@12, 21 PSAY Replicate("-",30)
		@12, 52 PSAY Replicate("-",11)
		@12, 64 PSAY Replicate("-", 2)
		@12, 67 PSAY Replicate("-",30)

		li:=12
		dbSelectArea("SC8")
		cNumero := C8_NUM
		cFornece:= C8_FORNECE
		cLoja   := C8_LOJA
	Endif
	
	cObs01   := " "
	cObs02   := " "
	cObs03   := " "
	cObs04   := " "
	nLinObs  := 0
	nItem    := 0
	
	While !Eof() .And. C8_NUM == cNumero .And. cFornece == C8_FORNECE .And. C8_LOJA == cLoja
		IF li > 58
			li ++
			li ++
			nPag ++
			@ li,00 PSAY Replicate("-",limite-Len(" Continua ..."))+" Continua ..."
			@ 00,00 PSAY STR0017+Replicate("-",53)		//"Continuacao ..."
			@ 00,70 PSAY STR0006 + SC8->C8_NUM + STR0007 + DTOC(SC8->C8_VALIDA) +Space(13)+"Pagina: " + STRZERO(nPag,4) 		//"COTACAO N. "###" Vencimento "
			li := 1
		Endif
		
		IncRegua()
		
		li++
		nItem++
		@li,  0 PSAY StrZero(nItem,4)
		@li,  5 PSAY C8_PRODUTO
		ImpDescr()
		cFilEnt := SC8->C8_FILENT
		
		//��������������������������������������������������������������Ŀ
		//� Inicializacao da Observacao da Cotacao                       �
		//����������������������������������������������������������������
		If !EMPTY(SC8->C8_OBS) .And. nLinObs < 5
			nLinObs++
			cVar:="cObs"+StrZero(nLinObs,2)
			Eval(MemVarBlock(cVar),SC8->C8_OBS)
		Endif
		
		dbSelectArea("SC8")
		dbSkip()
	EndDo
	
	//��������������������������������������������������������������Ŀ
	//� Acessar o Endereco para Entrega do Arquivo de Empresa SM0.   �
	//����������������������������������������������������������������
	lC8FilEnt := .F.
	If SC8->(Eof()) .Or. cFilEnt != SC8->C8_FILENT
		dbSkip(-1)        // Para ter Certeza que nao e Eof() ou trocou a filial
		lC8FilEnt := .T.  // de Entrega
	Endif
	
	dbSelectArea("SM0")
	dbSetOrder(1)   && forca o indice na ordem certa
	nRegistro := Recno()
	dbSeek(SUBS(cNumEmp,1,2)+SC8->C8_FILENT)
	
	If li > Iif(nLinObs > 0,45,50)
		li ++
		li ++
		nPag ++
		@ li,00 PSAY Replicate("-",limite-Len(" Continua ..."))+" Continua ..."
		@ 00,00 PSAY STR0017+Replicate("-",53)		//"Continuacao ..."
		@ 00,70 PSAY STR0006 + SC8->C8_NUM + STR0007 + DTOC(SC8->C8_VALIDA) +Space(13)+"Pagina: " + STRZERO(nPag,4) 		//"COTACAO N. "###" Vencimento "
		li := 1
	Endif
	If lC8FilEnt .and. !SC8->(Eof())
		SC8->(dbSkip())
	Endif
	
	If nLinObs > 0
		//��������������������������������������������������������������Ŀ
		//� Inicializar campos de Observacoes.                           �
		//����������������������������������������������������������������
		If Empty(cObs02)
			If Len(cObs01) > 50
				cObs 	:= cObs01
				cObs01:= Substr(cObs,1,50)
				For nX := 2 To 4
					cVar  := "cObs"+StrZero(nX,2)
					&cVar := Substr(cObs,(50*(nX-1))+1,50)
				Next
			EndIf
		Else
			cObs01:= Substr(cObs01,1,IIf(Len(cObs01)<50,Len(cObs01),50))
			cObs02:= Substr(cObs02,1,IIf(Len(cObs02)<50,Len(cObs01),50))
			cObs03:= Substr(cObs03,1,IIf(Len(cObs03)<50,Len(cObs01),50))
			cObs04:= Substr(cObs04,1,IIf(Len(cObs04)<50,Len(cObs01),50))
		EndIf
		
		li:=45
		@ li,000 PSAY __PrtThinLine()
		li++
		@ li,000 PSAY STR0032 //Observacoes :
		@ li,054 PSAY "|"
		li++
		@ li,000 PSAY cObs01
		@ li,054 PSAY "|"
		li++
		@ li,000 PSAY cObs02
		@ li,054 PSAY "|"
		li++
		@ li,000 PSAY cObs03
		@ li,054 PSAY "|"
		li++
		@ li,000 PSAY cObs04
		@ li,054 PSAY "|"		
	Else
		li:=50
	Endif
	
	li++
	@li,  0 PSAY __PrtThinLine()
	li++
	@li,  0 PSAY STR0018		//"Local de Entrega:"
	@li, 47 PSAY STR0019		//"|  Sub Total"
	@li, 97 PSAY STR0020		//"| Condicao de Pagamento"
	li++
    //��������������������������������������������������������������������Ŀ
    //� Imprime o End de Entrega do SM0 somente quando cEndEnt  == " "     �
    //����������������������������������������������������������������������
    If Empty(cEndEnt)
	   @li,  0 PSAY IIf( Empty(SM0->M0_ENDENT), " O mesmo ", SM0->M0_ENDENT )
    Else
       @li,  0 PSAY cEndEnt        
    EndIf
	@li, 47 PSAY STR0021		//"|  Descontos "
	@li, 97 PSAY "|"
	Go nRegistro
	dbSelectArea("SC8")
	
	li++
	@li,  0 PSAY STR0022		//"Local de Pagamento:"
	@li, 47 PSAY STR0023		//"|  Total do IPI"
	@li, 97 PSAY "|"
	
	li++
	@li,  0 PSAY Iif(Empty(SM0->M0_ENDCOB),Iif(Empty(SM0->M0_ENDENT),"O mesmo",SM0->M0_ENDENT),SM0->M0_ENDCOB)
	@li, 47 PSAY STR0024		//"|  Frete"
	@li, 97 PSAY STR0025		//"| Condicao de Reajuste"
	
	li++
	@li,  0 PSAY STR0026		//"Contato no Fornecedor"
	@li, 47 PSAY "|"+Replicate("-",23)
	@li, 97 PSAY "|"
	
	li++
	@li,  0 PSAY cContato
	@li, 47 PSAY STR0027 + Replicate(".",11)   //"|  TOTAL DO PEDIDO"
	@li, 97 PSAY "|"
	
	li++
	@li,  0 PSAY __PrtThinLine()
	
	li++
	@li,  0 PSAY STR0028		//"Alcada 1"
	@li, 28 PSAY STR0029		//"| Alcada 2"
	@li,108 PSAY STR0030		//"Emitido em :"
	@li,121 PSAY dEmissao
	
	li++
	@li, 0  PSAY __PrtThinLine()
	
	dbSelectArea("SC8")
	li := 80
	nPag := 0
EndDo

dbSelectArea("SC8")
Set Filter To
dbSetOrder(1)

dbSelectArea("SA5")
dbSetOrder(1)

//��������������������������������������������������������������Ŀ
//� Se em disco, desvia para Spool                               �
//����������������������������������������������������������������
If aReturn[5] = 1    // Se Saida para disco, ativa SPOOL
	Set Printer To
	Commit
	OurSpool(wnrel)
Endif

MS_FLUSH()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �ImpValores� Autor � Jose Lucas            � Data � 19.07.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir Valores da Cotacao.	  							  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpValores(Void) 		                        		  ���
�������������������������������������������������������������������������Ĵ��
���Parametros� 					                    					  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR150                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpValores()

dbSelectArea("SC8")

If nSegundaUnid == 2 .And. !Empty(SC8->C8_QTSEGUM)
	@li, 52 PSAY  SC8->C8_QTSEGUM Picture "99999999.99"
	@li, 64 PSAY  SC8->C8_SEGUM
Else
	@li, 52 PSAY  SC8->C8_QUANT Picture "99999999.99"
	@li, 64 PSAY  SC8->C8_UM
Endif

@li, 68 PSAY ALLTRIM(cCompDes)

//@li,119 PSAY  STR0031	//"dias"
//@li,124 PSAY  SC8->C8_DATPRF

dbSelectArea("SA5")
dbSetOrder(2)
//@li,117 PSAY  STR0031	//"dias"
li++
If dbSeek(xFilial()+SC8->C8_PRODUTO+SC8->C8_FORNECE+SC8->C8_LOJA)
	If !Empty(SA5->A5_CODPRF)
		@li,3 PSAY Alltrim(SA5->A5_CODPRF)
	EndIf
Endif
dbSelectArea("SC8")
Return Nil

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ImpDescr � Autor � Jose Lucas            � Data � 19.07.93 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Imprimir descricao do Produto.	  						  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ImpProd(Void)  			                      			  ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � MatR150                                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ImpDescr()
LOCAL cDesc := " ", cDescri := " ", nLinRef := 1

If Empty(mv_par06)
	mv_par06 := "B1_DESC"
EndIf

//��������������������������������������������������������������Ŀ
//� Impressao da descricao cientifica do Produto.                �
//����������������������������������������������������������������
If AllTrim(mv_par06) == "B5_CEME"
	dbSelectArea("SB5")
	dbSetOrder(1)
	If dbSeek(xFilial()+SC8->C8_PRODUTO)
		cDescri := B5_CEME
	EndIf
ElseIf AllTrim(mv_par06) == "A5_NOMPROD"
	dbSelectArea("SA5")
	dbSetOrder(1)
	If dbSeek(xFilial()+SC8->C8_FORNECE+SC8->C8_LOJA+SC8->C8_PRODUTO)
		cDescri := A5_NOMPROD
	EndIf
EndIf

//��������������������������������������������������������������Ŀ
//� Impressao da descricao do produto do arquivo de Cotacoes.    �
//����������������������������������������������������������������
If AllTrim(mv_par06) == "C1_DESCRI"
	dbSelectArea("SC1")
	dbSetOrder(1)
	If dbSeek(xFilial()+SC8->C8_NUMSC+SC8->C8_ITEMSC)
		cDescri := C1_DESCRI
	Endif
EndIf

//��������������������������������������������������������������Ŀ
//� Impressao da descricao do Produto SB1.		         		 �
//����������������������������������������������������������������
If Empty(cDescri)
	dbSelectArea("SB1")
	dbSeek(xFilial()+SC8->C8_PRODUTO)
	cDescri := SB1->B1_DESC
	cCompDes := SB1->B1_DESCOMP
EndIf

dbSelectArea("SC8")
nBegin:=0
@ li,021 PSAY SubStr(cDescri,1,30)
ImpValores()
For nBegin := 31 To Len(Trim(cDescri)) Step 30
	nLinRef++
	li++
	If nLinRef == 2
		li--
	EndIf
	cDesc := Substr(cDescri,nBegin,30)
	@ li,021 PSAY cDesc
Next nBegin
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AjustaSX1    �Autor � Alex Lemes           �Data� 28/05/01 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ajusta perguntas do SX1                                    ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Static Function AjustaSX1(cGrupo)
//Local cAlias := Alias();aRegistros:={};j:=0;i:=0
//
//If AllTrim(cGrupo) == "MTR150"
//    PutSx1(cGrupo,"12","Endereco de Entrega?","Local de Entrega    ","Delivery Address    ","mv_chc","C",40,0,0,"G","","","","","mv_par12","","","","","","","","","","","","","","","","",;
//          {"Forneca o endereco ou sera impresso o  ","endereco que consta no arquivo SM0.   "},;
//          {"                                       ","                                      "},;
//          {"                                       ","                                      "})
//    PutSx1(cGrupo,"13","e-mail              ","e-mail              ","e-mail              ","mv_chd","C",40,0,0,"G","","","","","mv_par13","","","","","","","","","","","","","","","","",;   
//          {"Forneca o e-mail da empresa para       ","impressao no relatorio.               "},;
//          {"                                       ","                                      "},;
//          {"                                       ","                                      "})
//Else
//    PutSx1(cGrupo,"08","Endereco de Entrega?","Local de Entrega    ","Delivery Address    ","mv_ch8","C",40,0,0,"G","","","","","mv_par08","","","","","","","","","","","","","","","","",;   
//          {"Forneca o endereco ou sera impresso o  ","endereco que consta no arquivo SM0.   "},;
//          {"                                       ","                                      "},;
//          {"                                       ","                                      "})
//    PutSx1(cGrupo,"09","e-mail              ","e-mail              ","e-mail              ","mv_ch9","C",40,0,0,"G","","","","","mv_par09","","","","","","","","","","","","","","","","",;   
//          {"Forneca o e-mail da empresa para       ","impressao no relatorio.               "},;
//          {"                                       ","                                      "},;
//          {"                                       ","                                      "})
//Endif
//dbSelectArea(cAlias)
//Return NIL
