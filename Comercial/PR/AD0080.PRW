#include "rwmake.ch"
#include "PRTOPDEF.CH"
#Include "Topconn.ch"
//�����������������������������������������������������������������������������������������������
//�����������������������������������������������������������������������������������������������
//�������������������������������������������������������������������������������������������Ŀ��
//���Funcao    � AD0080   � Autor � Rogerio Eduardo Nutti                   � Data � 06.10.03 ���
//�������������������������������������������������������������������������������������������Ĵ��
//���Descri��o � Filtra Clientes conforme nivel do usuario                                    ���
//�������������������������������������������������������������������������������������������Ĵ��
//��� Uso      � Especifico Ad'oro Alimenticia                                                ���
//���          � Chamada para  MATA030                                                        ���
//���          �                                                                              ���
//���          � Vendedores   - Somente seus clientes                                         ���
//���          � Supervisores - Somente seus clientes e de seus vendedores                    ���
//���          � Gerentes     - Todos os clientes                                             ���
//�������������������������������������������������������������������������������������������Ĵ��
//���ALTERA��O � RICARDO LIMA-CH:037647-04/01/2019-RNX2 CADASTRA CLIENTE SEM USAR PRE-CADASTRO���
//�������������������������������������������������������������������������������������������Ĵ��
//���          � Adriana chamado 051044 em 27/08/2019 para SAFEGG                             ���
//��������������������������������������������������������������������������������������������ٱ�
//�����������������������������������������������������������������������������������������������
//�����������������������������������������������������������������������������������������������
//@history Everson, 10/02/2023, Chamado 18465. Envio de registro para o barramento.

User Function AD0080()   // U_AD0080()

	//TABELAS USADAS
	//SA1	-CLIENTES
	//SZR -SUPERVISORES
	//SA3 -VENDEDORES
	  
	//��������������������������������������������������������������Ŀ
	//� Variaveis                                                    �
	//����������������������������������������������������������������
	//_cUserName  := Subs(cUsuario,7,15)   // Nome do Usuario
	_cUserName  := Alltrim(cusername) //Alterado 04/03/13 - Ana. Devido atualizacao P11. Pois CUsuario traz o Nome do usuario e nao mais o Login
	
	//��������������������������������������������������������������Ŀ
	//� 1a. Verificacao - E' Gerente ?                               �
	//����������������������������������������������������������������
	
	Private aInd    := {}
	Private bFiltraBrw := {|| Nil}
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Chamada para  MATA030 Vendedores   - Somente seus clientes Supervisores - Somente seus clientes e de seus vendedores Gerentes     - Todos os clientes')
	
	&&Mauricio - 26/05/2017 - Chamado 036186 - novo tratamento a principio para usuaria Andrea(MV_#SA1E02) do Financeiro para empresa Ceres(completo) e Adoro(Visualiza)
	IF !(__cUserID $ GETMV("MV_#SA1E02"))
		
		If ! Alltrim(_cUserName) $ GetMV("MV_GERENTE")          // Se for gerente nao tem Filtro
			
			//��������������������������������������������������������������Ŀ
			//� 2a. Verificacao - E' Supervisor ?                            �
			//����������������������������������������������������������������
			dbSelectArea("SZR")
			dbSetOrder(2)            // ZR_FILIAL+ZR_DESCRIC
			If dbSeek( xFilial("SZR")+_cUserName )
				
				_cCodSup := SZR->ZR_CODIGO            // Busca Codigo Supervisor
				
				dbSelectArea("SA3")
				dbSetOrder(5)        // A3_FILIAL+A3_SUPER
				If dbSeek( xFilial("SA3")+_cCodSup )
					
					//��������������������������������������������������������������Ŀ
					//� Armazena em _cSupVends todos os Vendedores do Supervisor     �
					//����������������������������������������������������������������
					_cSupVends  := ""
					Do While !Eof() .and. xFilial("SA3") == SA3->A3_FILIAL	.and. ;
						_cCodSup       == SA3->A3_SUPER
						_cSupVends  :=  _cSupVends + SA3->A3_COD+"/"
						
						dbSelectArea("SA3")
						dbSkip()
					Enddo
					
					//��������������������������������������������������������������Ŀ
					//� Filtra Clientes pelos Vendedores do Supervisor               �
					//����������������������������������������������������������������
					If !Empty(_cSupVends)
						dbSelectArea("SA1")
						cCondicao  := " A1_VEND  $ '"+ _cSupVends + "'"
						bFiltraBrw := {|| FilBrowse("SA1",@aInd,@cCondicao)}
						Eval(bFiltraBrw)
					Endif
					
				Endif
			Else
				//��������������������������������������������������������������Ŀ
				//� 3a. Verificacao - E' Vendedor ?                              �
				//����������������������������������������������������������������
				dbSelectArea("SA3")
				dbSetOrder(2)
				If dbSeek( xFilial("SA3")+_cUserName )
					
					_cCodVen := SA3->A3_COD              // Busca Codigo Vendedor
					
					//��������������������������������������������������������������Ŀ
					//� Filtra Clientes pelo Codigo do Vendedor                      �
					//����������������������������������������������������������������
					dbSelectArea("SA1")
					cCondicao  := " A1_VEND  == '"+_cCodVen + "'"
					bFiltraBrw := {|| FilBrowse("SA1",@aInd,@cCondicao)}
					Eval(bFiltraBrw)
					
				Endif
				
			Endif
			
		Endif
		
		//MATA030()
		MyMata030()
		
	Else
		If (cEmpAnt == "02" .And. (__cUserID $ GETMV("MV_#SA1E02"))) .OR. cEmpAnt $ "07 /09 " // RICARDO LIMA-CH:037647-04/01/2019-RNX2 CADASTRA CLIENTE SEM USAR PRE-CADASTRO //Incluido empresa 09 por Adriana chamado 051044 em 27/08/2019
			MATA030()
		Else
			//MATA030()
			MyMata030()
		Endif
	Endif
	
	
	dbSelectArea("SA1") 
	EndFilBrw("SA1",aInd)

Return

//Rotinas desenvolvida para apenas visualizar cadastro de clientes pela rotina.
//Chamado: 034934 

Static Function MyMata030()

	Local aArea			:= GetArea()
	Local aRotinaold    := {}
	
	Private bSF			:= {|| intEnvSF(1)  }
	Private bSFL		:= {|| intEnvSFL() }
	Private bEnVB		:= {|| grvBarr() } //Everson - 10/03/2023 - ticket 18465.
	
	If !(Alltrim(FunName()) == "AD0080")
		aRotinaold    := aRotina
	EndIF
	
	Private cCadastro := "Cadastro de Clientes"
	Private aRotina   := {{"Pesquisar " ,"AxPesqui"    , 0 , 1},;
	                      {"Visualizar" ,"axVisual"    , 0 , 2},;
	                      {"Posicao"	,"u_PosCli"    , 0 , 3}} 
						   
	If !(Alltrim(FunName()) == "AD0080") // chamado 035726 William Costa 23/06/2017
		aAdd( aRotina ,{"Alterar Logistica"    ,"u_ALTERCLI" , 0 , 4})
		
	EndIF		
	
	aAdd( aRotina ,{"Comp. DESC"       ,"U_ADVEN062P" , 0 , 5})	
	aAdd( aRotina ,{"Env. SF"          ,"Eval(bSF)", 0 , 6})	
	aAdd( aRotina ,{"Env. Lote SF"     ,"Eval(bSFL)", 0 , 6})	   
	aAdd( aRotina ,{"Env. Barramento"  ,"Eval(bEnVB)", 0 , 10}) //Everson - 10/02/2023. ticket 18465.	   
	                       
	DbSelectArea("SA1")
	MBrowse( 6, 1,22,75,"SA1")
	
	RestArea( aArea )    
	
	aRotina := aRotinaold

Return 

//rotina padrao para posi��o de cliente
User Function PosCli ()

	U_ADINF009P('AD0080' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Chamada para  MATA030 Vendedores   - Somente seus clientes Supervisores - Somente seus clientes e de seus vendedores Gerentes     - Todos os clientes')

	Pergunte("FIC010",.T.)
	fc010con( 'SA1', SA1->( Recno() ), 2 )                                      

Return

// User function criada para o chamado 035726 William Costa 23/06/2017
USER FUNCTION ALTERCLI()

	Local aArea  	  := GetArea()
	Local aAcho  	  := {"NOUSER","A1_XHRENTR","A1_HRINIM","A1_HRFINM","A1_HRINIT","A1_HRFINT","A1_XLONGIT","A1_XLATITU"}
    Private aButtons  := {}

	U_ADINF009P('AD0080' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Chamada para  MATA030 Vendedores   - Somente seus clientes Supervisores - Somente seus clientes e de seus vendedores Gerentes     - Todos os clientes')
	                      
	If  AxAltera("SA1",SA1->(Recno()),4,,aAcho,,,,,,aButtons,,,,.T.,) == 1    
	   
		DBSELECTAREA("PB3")
		DbSetOrder(11)
	   		
		IF PB3->(DbSeek(xFilial("PB3")+SA1->A1_COD+SA1->A1_LOJA))
			RecLock("PB3",.F.)              
			
				PB3->PB3_HRINIM	:= SA1->A1_HRINIM
			    PB3->PB3_HRFINM	:= SA1->A1_HRFINM
				PB3->PB3_HRINIT	:= SA1->A1_HRINIT
				PB3->PB3_HRFINT	:= SA1->A1_HRFINT
				PB3->PB3_XLONGI	:= SA1->A1_XLONGIT					
				PB3->PB3_XLATIT	:= SA1->A1_XLATITU
					
			MsUnlock()	   
			
		ENDIF		
	
		MsgInfo("Alterado com sucesso!")  
		
	EndIf
	
	RestArea(aArea)

RETURN(NIL)  
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �intEnvSF       � Autor � Everson       � Data �  31/01/18   ���
�������������������������������������������������������������������������͹��
���Descricao �Interface envio de registro ao SalesForce.                  ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
// U_AD0080()
Static Function intEnvSF(nOPc)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������	
	Local aArea	   	:= GetArea()
	Local oTelMenu	:= Nil
	Local oDe		:= Nil
	Local oAt		:= Nil
	Local oCanc  	:= Nil
	Local oOk		:= Nil
	
	
	Private aItems	:= {'1=Cadastro','2=Contrato','3=Frete','4=Vl Min. Seg'}
	Private cCombo1 := ""
	Private oCombo1	:= Nil
	
	Private aItems2 := {'1=Desbloqueados','2=Bloquedos','3=Todos'}
	Private cCombo2 := ""
	Private oCombo2	:= Nil
	Private cDe		:= ""
	Private cAte	:= ""

	//
	If nOPc == 2
		cDe		:= Alltrim(cValToChar(ZBC->ZBC_CODCLI)) + Alltrim(cValToChar(ZBC->ZBC_LOJA))
		cAte	:= Alltrim(cValToChar(ZBC->ZBC_CODCLI)) + Alltrim(cValToChar(ZBC->ZBC_LOJA))
		
	ElseIf nOPc == 3
		cDe		:= Alltrim(cValToChar(ZC6->ZC6_CODCLI)) + Alltrim(cValToChar(ZC6->ZC6_LOJA))
		cAte	:= Alltrim(cValToChar(ZC6->ZC6_CODCLI)) + Alltrim(cValToChar(ZC6->ZC6_LOJA))
					
	ElseIf nOPc == 1
		cDe		:= Alltrim(cValToChar(SA1->A1_COD)) + Alltrim(cValToChar(SA1->A1_LOJA))
		cAte	:= Alltrim(cValToChar(SA1->A1_COD)) + Alltrim(cValToChar(SA1->A1_LOJA))
	
	EndIf
	
	Private cDeV	:= Space(6)//Alltrim(cValToChar(SA1->A1_VEND))
	Private cAteV	:= "ZZZZZZ"//Alltrim(cValToChar(SA1->A1_VEND))
	
	Private cDeR	:= Space(6)
	Private cAteR	:= "ZZZZZZ"
	
	oTelMenu			:= MsDialog():Create()
	oTelMenu:cName     := "oTelMenu"
	oTelMenu:cCaption  := "Envio SalesForce"
	oTelMenu:nLeft     := 34
	oTelMenu:nTop      := 222
	oTelMenu:nWidth    := 250
	oTelMenu:nHeight   := 397
	oTelMenu:lShowHint := .F.
	oTelMenu:lCentered := .T.
	
		//
		cCombo1:= aItems[1]
		oCombo1 := TComboBox():New(007,010,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
		aItems,100,20,oTelMenu,,{|| };
		,,,,.T.,,,,,,,,,'cCombo1')
		
		//
		cCombo2:= aItems2[3]
		oCombo2 := TComboBox():New(030,010,{|u|if(PCount()>0,cCombo2:=u,cCombo2)},;
		aItems2,100,20,oTelMenu,,{|| };
		,,,,.T.,,,,,,,,,'cCombo2')
		oCombo2:nAt := 3
		oCombo2:Refresh()
		
		oDe := TGet():New(060,010,{|u|If(PCount() == 0,cDe,cDe := u)}    ,oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cDe",,,,.T.,,,"De cliente:",1)
		
		oAt := TGet():New(060,065,{|u|If(PCount() == 0,cAte,cAte := u)}  ,oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cAte",,,,.T.,,,"At� cliente:",1)
		
		oDeV:= TGet():New(090,010,{|u|If(PCount() == 0,cDeV,cDeV := u)}  ,oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cDeV",,,,.T.,,,"De vendedor:",1)
		
		oAtV:= TGet():New(090,065,{|u|If(PCount() == 0,cAteV,cAteV := u)},oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cAteV",,,,.T.,,,"At� vendedor:",1)

		oDeR:= TGet():New(120,010,{|u|If(PCount() == 0,cDeR,cDeR := u)}  ,oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cDeR",,,,.T.,,,"De Rede:",1)
		
		oAtr:= TGet():New(120,065,{|u|If(PCount() == 0,cAteR,cAteR := u)},oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cAteR",,,,.T.,,,"At� Rede:",1)
				
		oOk     := TButton():New(156,010,"Enviar"  ,oTelMenu,{|| envSF(cCombo1,cDe,cAte,cDeV,cAteV,cCombo2,cDeR,cAteR), oTelMenu:End() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
		oCanc   := TButton():New(156,075,"Cancelar",oTelMenu,{|| oTelMenu:End() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )	
		
	oTelMenu:Activate(,,,.T.,{||.T.},,{||  })
	
	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �envSF          � Autor � Everson       � Data �  06/02/18   ���
�������������������������������������������������������������������������͹��
���Descricao �Envio de registro ao SalesForce.                            ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function envSF(cCombo1,cDe,cAte,cDeV,cAteV,cCombo2,cDeR,cAteR)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������	
	Local aArea	   	:= GetArea()
	Local cBlq		:= ""
	
	//
	If cCombo2 == "1"
		cBlq := " AND A1_MSBLQL = '2' "
	ElseIf cCombo2 == "2"
		cBlq := " AND A1_MSBLQL = '1' "
	
	EndIf
	
	//
	If Alltrim(cValToChar(cCombo1)) == "1" //Envio de cadastro.
		
		MsAguarde(U_ADVEN076P("","",.F.," AND (RTRIM(LTRIM(A1_COD)) + RTRIM(LTRIM(A1_LOJA))) BETWEEN '" + cDe + "' AND '" + cAte + "' AND A1_VEND BETWEEN '" + cDeV + "' AND '" + cAteV + "' AND A1_COD = A1_REDE AND A1_LOJA = '00' AND A1_REDE BETWEEN '" + cDeR + "' AND '" + cAteR + "' ","",.T.,""),"Aguarde","Processando Matrizes...")
		
		MsAguarde(U_ADVEN076P("","",.F.," " + cBlq + " AND (RTRIM(LTRIM(A1_COD)) + RTRIM(LTRIM(A1_LOJA))) BETWEEN '" + cDe + "' AND '" + cAte + "' AND A1_VEND BETWEEN '" + cDeV + "' AND '" + cAteV + "' AND A1_REDE BETWEEN '" + cDeR + "' AND '" + cAteR + "' ","",.T.,""),"Aguarde","Processando Lojas...")
	
	ElseIf Alltrim(cValToChar(cCombo1)) == "2" //Envio de contrato.
	
		U_ADVEN055P( "",.F.,"   " + cBlq + " AND (RTRIM(LTRIM(A1_COD)) + RTRIM(LTRIM(A1_LOJA))) BETWEEN '" + cDe + "' AND '" + cAte + "' AND A1_VEND BETWEEN '" + cDeV + "' AND '" + cAteV + "' AND A1_REDE BETWEEN '" + cDeR + "' AND '" + cAteR + "' ")

	ElseIf Alltrim(cValToChar(cCombo1)) == "3" //Frete.
		
		U_ADVEN076P("","",.F.," " + cBlq + " AND (RTRIM(LTRIM(A1_COD)) + RTRIM(LTRIM(A1_LOJA))) BETWEEN '" + cDe + "' AND '" + cAte + "' AND A1_VEND BETWEEN '" + cDeV + "' AND '" + cAteV + "' AND A1_REDE BETWEEN '" + cDeR + "' AND '" + cAteR + "' ","FRT",.T.,"")
		
	ElseIf Alltrim(cValToChar(cCombo1)) == "4" //Valor m�nimo segmento.
	
		U_ADVEN076P("","",.F.," " + cBlq + " AND (RTRIM(LTRIM(A1_COD)) + RTRIM(LTRIM(A1_LOJA))) BETWEEN '" + cDe + "' AND '" + cAte + "' AND A1_VEND BETWEEN '" + cDeV + "' AND '" + cAteV + "' AND A1_REDE BETWEEN '" + cDeR + "' AND '" + cAteR + "' ","VLRMIN",.T.,"")
		
	EndIf
	
	//
	RestArea(aArea)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �intEnvSFL      � Autor � Everson       � Data �  07/06/18   ���
�������������������������������������������������������������������������͹��
���Descricao �Envio de cadastro de clientes.                              ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function intEnvSFL()

	Processa({||  ProcessarL() },"Lendo arquivo...")

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �Processar      �Autor  �Everson      � Data �  07/06/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para processar envio de cadastro ao SalesForce.      ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ProcessarL()

	//���������������������������������������������������������������������������Ŀ
	//�Declara��o de vari�veis.                                                   �
	//�����������������������������������������������������������������������������
	Local cBuffer	:= ""
	Local aDados	:= {}
	Local cCliente	:= ""
	Local cLoja		:= ""
	Local aCarga	:= {}
	Local cArq		:= ""

	//Obt�m arquivo.
	cArq := cGetFile('Arquivo CSV|*.*|Arquivo *|*.*','Selecione arquivo',0,'C:\',.T.,GETF_LOCALHARD + GETF_NETWORKDRIVE,.T.)

	//Valida arquivo.  
	If Empty(cArq)
		MsgStop( "N�o foi poss�vel obter o arquivo.","Processar(ProcessarL - AD0080)")
		Return Nil

	Endif
	
	//Abre o arquivo.
	nHdl := FT_FUse(cArq)

	//Valida abertura do arquivo.
	If nHdl == -1
		MsgStop("N�o foi poss�vel abrir o arquivo " + Chr(13) + Chr(13) + cArq,"Fun��o lerArquivo")
		Return Nil

	Endif

	FT_FGoTop()

	//Obt�m a quantidade de linhas.
	nTotLinhas := FT_FLastRec()

	//Atribui o tamanho da r�gua.
	ProcRegua(nTotLinhas)

	FT_FGoTop()
	FT_FGoto(1)

	//Percorre arquivo.
	While ! FT_FEof()

		cBuffer  := Alltrim(cValToChar(DecodeUTF8(FT_FReadln())))

		If ! Empty(cBuffer)

			aDados	 := StrToKarr(cBuffer,";")
			
			/*If Len(aDados) <> 2
				MsgStop("O arquivo CSV deve ser composto por c�digo;loja .","Fun��o Processar(ProcessarL - AD0080)")
				Return Nil
				
			EndIf*/

			cCliente := Alltrim(cValToChar(aDados[1]))
			cLoja    := Alltrim(cValToChar(aDados[2]))
					
			//Incrementa regua de processamento.
			IncProc("Cliente: " + cCliente + " | Loja: " + cLoja)

			Aadd(aCarga,cCliente+cLoja)

		EndIf

		FT_FSkip()

	EndDo
	
	//
	If Len(aCarga) > 0 .And. MsgYesNo("Ser�o enviados " + cValToChar(Len(aCarga)) + " registros. Deseja prosseguir?","Fun��o ProcessarL")
	
		Processa({||  checkRede(aCarga) },"Checando Matrizes...")
	
	EndIf
	
	//
	MsgInfo("Processo finalizado","Fun��o ProcessarL")

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �checkRede      �Autor  �Everson      � Data �  13/09/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Checa matrizes.                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function checkRede(aCarga)

	//���������������������������������������������������������������������������Ŀ
	//�Declara��o de vari�veis.                                                   �
	//�����������������������������������������������������������������������������
	Local i		   := 1
	Local aRedes   := {}
	Local aLojas   := {}
	
	//
	DbSelectArea("SA1")
	SA1->(DbSetOrder(1))
	SA1->(DbGoTop())
	For i := 1 To Len(aCarga)
		
		If SA1->(DbSeek( xFilial("SA1") + aCarga[i] ))
			
			//Checa se � matriz de rede.
			If Alltrim(cValToChar(SA1->A1_REDE)) == Substr(Alltrim(cValToChar(aCarga[i])),1,6) .And. Substr(Alltrim(cValToChar(aCarga[i])),7,2) == "00"
				Aadd(aRedes,aCarga[i])
				
			Else
				Aadd(aLojas,aCarga[i])
				
			EndIf
		
		EndIf
	
	Next i

	//Envia matrizes.
	If Len(aRedes) > 0
		CONOUT(VARINFO("TSAY",aRedes))
		Processa({||  envLoteSF(aRedes) },"Enviando Matrizes...")
	
	EndIf
	
	//Envia lojas.
	If Len(aLojas) > 0
		CONOUT(VARINFO("TSAY",aLojas))
		Processa({||  envLoteSF(aLojas) },"Enviando Lojas...")
	
	EndIf
		
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �envLoteSF      �Autor  �Everson      � Data �  07/06/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para processar envio de cadastro ao SalesForce.      ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function envLoteSF(aCarga)

	//���������������������������������������������������������������������������Ŀ
	//�Declara��o de vari�veis.                                                   �
	//�����������������������������������������������������������������������������
	Local cCodigos := ""
	Local i		   := 1
	Local nAux     := 0
	
	//
	For i := 1 To Len(aCarga)
	
		//
		cCodigos += "'" + Alltrim(cValToChar(aCarga[i])) + "',"
		nAux++
	
		//
		If (nAux == 200) .Or. (nAux == Len(aCarga)) .Or. (i == Len(aCarga))  
			   
			cCodigos := Substr(cCodigos,1,Len(cCodigos)-1)
	
			U_ADVEN076P("","",.F.," AND (RTRIM(LTRIM(A1_COD)) + RTRIM(LTRIM(A1_LOJA))) IN (" + cCodigos + ") ","",.T.,"")
			nAux := 0
			cCodigos := ""
			
		EndIf
	
	Next i

Return Nil

/*/{Protheus.doc} u_0080A0
Ticket 70142 - Substituicao de funcao Static Call por User Function MP 12.1.33
@type function
@version 1.0
@author Edvar   / Flek Solution
@since 16/03/2022
@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
/*/
Function u_0080A0( uPar1 )
Return( intEnvSF( uPar1 ) )

/*/{Protheus.doc} u_0080A1
Ticket 70142 - Substituicao de funcao Static Call por User Function MP 12.1.33
@type function
@version 1.0
@author Edvar   / Flek Solution
@since 16/03/2022
@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
/*/
Function u_0080A1()
Return( ProcessarL() )

/*/{Protheus.doc} grvBarr
	Envia registro para o barramento.
	ticket 18465.
	@type  Static Function
	@author Everson
	@since 10/02/2023
	@version 01
/*/
Static Function grvBarr()
	
	//Vari�veis.
	Local aArea := GetARea()

	If ! MsgYesNo("Deseja enviar o registro para o barramento?", "fun��o grvBarr(AD0080)")
		RestArea(aArea)
		Return Nil

	EndIf

	U_MALTCLI1(SA1->A1_COD, SA1->A1_LOJA)

	MsgInfo("Processo finalizado.", "fun��o grvBarr(AD0080)")

	RestArea(aArea)

Return Nil
