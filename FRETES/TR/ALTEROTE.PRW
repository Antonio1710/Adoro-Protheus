#include "TOTVS.ch"
#include "Protheus.ch"
#include "rwmake.ch"
#include "TOPCONN.CH"

/*/{Protheus.doc} User Function ALTEROTE
	Alteracao do Roteiro e Sequencia de Entrega de Produtos O Advanced Protheus nao permite alteracao. Especifico Ad'oro Alimenticia 
	@type  Function
	@author Marcos Bido
	@since 20/11/2001
	@version 01
	@history Chamado TI   - DANIEL PITTHAN SILVEIRA - 27/10/2006 - ALTERADO O 'SET FILTER' PELO FILTRO DA MICROSIGA
	@history Chamado 4992 - William Costa           - 24/11/2020 - Adicionado no Filtro para ver notas que est�o com 'XXXXXX' que s�o notas denegadas ou Canceladas, e conseguir limpar a Placa delas.
	@history Chamado 5657 - William Costa           - 26/11/2020 - Voltado vers�o de limpa placa, pq n�o deu certo o jeito que foi pensado ser� feito na tela de Ocorr�ncias de Devolu��es.
	@history Chamado TI   - Leonardo P. Monteiro    - 21/01/2022 - Grava��o de log de acesso a rotina.
	@history Ticket 69574 - Abel Bab                - 21/03/2022 - Projeto FAI
	@history Ticket 90348 - Adriano Savoine         - 22/03/2023 - Retirado a trava que n�o deixava pedidos bloqueados por regra comercial aparecer no roteiro manual e criada a legenda para tomarem decis�o.
/*/

User Function ALTEROTE()

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Alteracao do Roteiro e Sequencia de Entrega de Produtos')
	SetPrvt("CCADASTRO,AROTINA,")

	dbSelectArea("SC5")
	
	SC5->(DBORDERNICKNAME("SC5_6")) //atualiza��o protheus 12 WILLIAM COSTA 28/12/2017 CHAMADO 036032

	//Variaveis utilizadas para parametros                         
	//mv_par01             // Do Roteiro                           
	//mv_par02             // Ate Roteiro                          
	//mv_par03             // Da Emissao                           
	//mv_par04             // Ate Emissao                          
	
	u_GrLogZBE( Date(),;
                TIME(),;
                cUserName,;
                "Altera Roteiro Manual",;
                "LOGISTICA",;
                "ALTEROTE",;
                "Acesso do usu�rio "+Alltrim(cUserName)+" � rotina para altera��o manual dos roteiros.",;
                ComputerName(),;
                LogUserName())

	cPerg   := "GERABO"                                   

	Pergunte(cPerg,.T.)
	Public _DtEntr := MV_PAR05

	//Filtra os pedidos que ja foram liberado pelo credito e nao foram faturados
	//FILTRO MICROSIGA                                                    
	
	Private _cCond     := "C5_FILIAL == '" + xFilial("SC5") + "' .AND. DTOS(C5_DTENTR) >= '"+ALLTRIM(DTOS(MV_PAR03))+"' .AND. DTOS(C5_DTENTR) <= '"+ALLTRIM(DTOS(MV_PAR04))+"' .AND. " + ; 
	                      "C5_ROTEIRO >= '" + ALLTRIM(MV_PAR01)+"' .AND. C5_ROTEIRO <= '" + ALLTRIM(MV_PAR02)+"' .AND. EMPTY(C5_NOTA)"  //.AND. C5_LIBEROK == 'S'.AND. C5_BLQ <> '1' "
	Private aCores     := {}
	Private aIndSC5    := {}
	Private bFiltraBrw := {|| FilBrowse( "SC5", @aIndSC5, @_cCond ) }

	aAdd(aCores,{ "C5_STATDOA == 'B'.AND. Empty(C5_NOTA)", 'BR_AZUL'})   //Pedido doa��o Bloqueado
	aAdd(aCores,{ "C5_STATDOA == 'A'.AND. Empty(C5_NOTA)", 'BR_AMARELO'})      //Pedido doa��o Aprovado
	aAdd(aCores,{ "Empty(C5_LIBEROK).And.Empty(C5_NOTA) .And. Empty(C5_BLQ).And. Empty(C5_STATDOA)",'BR_BRANCO'  })	                           //Pedido em Aberto
	aAdd(aCores,{ "!Empty(C5_NOTA).Or.C5_LIBEROK=='E' .And. Empty(C5_BLQ).And. Empty(C5_STATDOA)" ,'BR_CINZA'})	   	                       //Pedido Encerrado
	aAdd(aCores,{ "!Empty(C5_LIBEROK).And.Empty(C5_NOTA).And. Empty(C5_BLQ).And. Empty(C5_STATDOA)",'BR_VERDE'})	                            //Pedido aprovado.
	aAdd(aCores,{ "C5_BLQ == '1'",'BR_VERMELHO'   })                                                                           //Pedido Bloquedo por regra
	aAdd(aCores,{ "C5_BLQ == '2'",'BR_MARROM'})	                                                                     //Pedido Bloquedo por verba


	CCadastro := "Alteracao do Roteiro de Entrega "
	aRotina   := {{ "Pesquisar  "        ,"AxPesqui"               , 0 , 1},;                                         
	              { "Visualizar  "       ,"axVisual"               , 0 , 2},;
	              { "Bairro -> Roteiro"  ,'ExecBlock("ABAIRRO")'   , 0 , 3},;
	              { "Roteiro-> Roteiro"  ,'ExecBlock("AVENDE")'    , 0 , 4},;
	              { "Alterar Roteiro  "  ,'ExecBlock("ARote")'     , 0 , 5},;
	              { "Placa X Roteiro  "  ,'ExecBlock("AD0055")'    , 0 , 6},;
	              { "Limp. Placa "       ,'ExecBlock("UnRote")'    , 0 , 7},;
	              { "Insp. Sanitaria "   ,'ExecBlock("ASIF")'      , 0 , 7},;
	              { "Env. SF. "          ,'U_placaSFexp()'         , 0 , 8},;
				  { "Legenda "           ,'U_LegSC5()'             , 0 , 9}}

	dbSelectArea("SC9")
	Dbsetorder(1)

	dbSelectArea("SZC")
	dbSetOrder(1)

	Eval( bFiltraBrw )
	Processa( {|| ProcX() },"Aguarde Verificando Pedidos ..." )
	dbSelectArea("SC5")
	dbGoTop()

	mBrowse( 06, 01, 22, 75, "SC5",,,,,,aCores)

	EndFilBrw( "SC5", aIndSC5 )

RETURN

//GRAVA PESO BRUTO NO SC5
STATIC FUNCTION PROCX()

	IF cFILANT <> "06"  //Mauricio somente para teste de corre��o 06/07/11.

		dbSelectArea("SC5")
		dbGoTop()
		PROCREGUA(RECCOUNT())

		DO WHILE !EOF()

			INCPROC(SC5->C5_NUM+" "+SC5->C5_CLIENTE)

			_cNumPed    := SC5->C5_NUM
			_cCliente   := SC5->C5_CLIENTE
			_cLoja      := SC5->C5_LOJACLI

			_nTotalCx   := 0
			_nTotalPedi := 0
			_nTotalKg   := 0
			_nTotalBr   := 0

			//Posiciona SC5 e SC6, a partir do pedido                             

			dbSelectArea("SC9")
			dbSetOrder(1)
			IF dbSeek( xFilial("SC9") + _cNumPed )

				Do While !Eof() .AND. SC9->C9_PEDIDO == _cNumPed

					dbSelectArea("SB1")
					dbSetOrder(1)
					dbSeek(xFilial("SB1") + SC9->C9_PRODUTO)      

					_nTotalCx   := _nTotalCx   + SC9->C9_QTDLIB2   // Soma qtd caixas (2a. UM)
					_nTotalKg   := _nTotalKg   + IIF(SB1->B1_SEGUM="BS",0,SC9->C9_QTDLIB)   // Soma qtd peso   <1a. UM)//alterado por Adriana, se bolsa nao soma 1a unidade como peso

					//Posiciona Cadastro de Tara                                          
					
					dbSelectArea("SZC")
					dbSetOrder(1)
					IF dbSeek( xFilial("SZC") + SB1->B1_SEGUM )

						_nTotalBr   := _nTotalBr + (SC9->C9_QTDLIB2 * SZC->ZC_TARA) // PESO BRUTO

					ELSE

						IF Alltrim(SB1->B1_SEGUM) <> ""                            //Incluido 12/07/11 - Ana. Tratamento para peso duplicado

							_nTotalBr   := _nTotalBr + (SC9->C9_QTDLIB  * 1)       // PESO BRUTO

						ELSE

							_nTotalBr   := _nTotalBr                               // PESO BRUTO				

						ENDIF
					ENDIF

					dbSelectArea("SC9")
					dbSkip()

				ENDDO
			ENDIF

			//Grava Informacoes em SC5                                            
			IF _nTotalKg > 0
				dbSelectArea("SC5")
				RecLock("SC5",.F.)

					// Ricardo Lima - 23/10/18	  
					IF SC5->C5_EST <> 'EX'

						IF cEmpAnt == "02"	

							Replace C5_PBRUTO  With _nTotalKg

						ELSE

							Replace C5_PBRUTO  With _nTotalBr + _nTotalKg	

						ENDIF
					ENDIF

					// Ricardo Lima - 23/10/18	  

					IF SC5->C5_EST <> 'EX'

						Replace C5_PESOL   With _nTotalKg
						Replace C5_VOLUME1 With _nTotalCx

					ENDIF

				MsUnlock()
			ENDIF
			dbskip()
		ENDDO
	ENDIF

RETURN

/*/{Protheus.doc} User Function placaSFexp
	Fun��o para envio de registro ao SalesForce.
	@type  Function
	@author Everson
	@since 02/04/2018
	@version 01
/*/

User Function placaSFexp()

	Local aArea	   	:= GetArea()
	Local cFilSF    := GetMv("MV_#SFFIL",,"02|0B|") 	//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	Local cEmpSF    := GetMv("MV_#SFEMP",,"01|") 		//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	Private cEmpFL3 := SuperGetMv("MV#EMPFL3",.F.,"0102/010B/1301") //Codigos de Empresas+Filiais Ativas Grupo 3 //ticket TI - William Costa - 23/05/2023

	U_ADINF009P('ALTEROTE' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Alteracao do Roteiro e Sequencia de Entrega de Produtos')

	IF !MsgYesNo("Deseja enviar o(s) registro(s) referentes ao roteiro " + Alltrim(cValToChar(SC5->C5_ROTEIRO)) + "-" + Alltrim(DToC(SC5->C5_DTENTR)) + " ao SalesForce?","Fun��o placaSFexp (ALTEROTE)")

		RestArea(aArea)
		RETURN(NIL)

	ENDIF

	//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	//IF FindFunction("U_ADVEN050P") .And. Alltrim(cEmpAnt) $ cEmpSF .And. Alltrim(cFilAnt) $ cFilSF
	IF FindFunction("U_ADVEN050P") .And. Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ cEmpFL3  //ticket TI - William Costa - 23/05/2023 

		IF Upper(Alltrim(cValToChar(GetMv("MV_#SFATUL")))) == "S"

			U_ADVEN050P("",,," AND C5_ROTEIRO = '" + Alltrim(cValToChar(SC5->C5_ROTEIRO)) + "' AND C5_DTENTR = '" + Alltrim(DToS(SC5->C5_DTENTR)) + "' AND C5_XPEDSAL <> '' ",,,,,,.T.)
		
		ENDIF
		
	ENDIF

	RestArea(aArea)

RETURN(NIL)

/*/{Protheus.doc} User Function LegSC5
	(Legenda para pedidos)
	@type  Function
	@author Adriano Savoine
	@since 21/03/2023
	/*/

User Function LegSC5()

	LOCAL aLegenda := {}

	AAdd(aLegenda , {"BR_VERDE", "Pedido Liberado para Roterizar"})
	AAdd(aLegenda , {"BR_AMARELO", "Pedido doa��o Liberado"})
	AAdd(aLegenda , {"BR_AZUL", "Pedido doa��o Bloqueado"})
	AAdd(aLegenda , {"BR_BRANCO", "Pedido em Aberto"})
	AAdd(aLegenda , {"BR_CINZA", "Pedido Encerrado"})
	AAdd(aLegenda , {"BR_VERMELHO", "Pedido Bloquedo por regra Comercial"})
	AAdd(aLegenda , {"BR_MARROM", "Pedido Bloquedo por verba"})
	
	BrwLegenda("ROTEIRO MANUAL","LEGENDA",aLegenda )
	
Return
