#INCLUDE "rwmake.ch"
#INCLUDE "Topconn.ch"
#Include "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³ AD0088   º Autor ³ Gustavo Gonela     º Data ³  05/11/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Fechamento por Veiculo / Transportadora                    º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Logistica                                                  º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±º02/03/07  ³ DANIEL - REFEITO, PASSADO PARA TOPCONNECT                  º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±º          ³                                                            º±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
@history ticket 70750 - Everson - 07/04/2022 - Adaptação do fonte para nova filial.
@history ticket 81601 - Everson - 20/10/2022 - Melhoria para gerar relatório em CSV e formato sintético.
@history ticket 86097 - Antonio Domingos - 04/01/2023 - Ajuste de Alias do DbCloseArea
/*/                                                                                        
User Function AD0088() // U_AD0088()

	//Everson - ticket 81601 - Everson - 20/10/2022.
	//Variáveis.
	Local nTpRel	:= 1
	Local lCSV		:= .F.

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Variaveis utilizadas para parametros                         ³
	//³ mv_par01             // Data de                              |
	//³ mv_par02             // Data ate                             ³
	//| mv_par03             // Transportadora de                    |
	//³ mv_par04             // Transportadora ate                   ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Fechamento por Veiculo / Transportadora')
	
	cPerg   := "AD0088"
	Pergunte(cPerg,.F.)	
	
	cDesc1       := "Este programa tem como objetivo imprimir relatorio "
	cDesc2       := "de acordo com os parametros informados pelo usuario."
	cDesc3       := "Fechamento Veiculo / Transportadora"
	cPict        := ""
	titulo       := "Fechamento Veiculo / Transportadora"
	nLin         := 65
	Cabec1       := ""
	Cabec2       := ""
	imprime      := .T.
	aOrd := {}
	Private lEnd         := .F.
	Private lAbortPrint  := .F.
	Private limite       := 132
	Private tamanho      := "G"
	Private nomeprog     := "AD0088" // Coloque aqui o nome do programa para impressao no cabecalho
	Private nTipo        := 18
	Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey     := 0
	Private cbtxt        := Space(10)
	Private cbcont       := 00
	Private CONTFL       := 01
	Private m_pag        := 01      
	Private wnrel        := "AD0088" // Coloque aqui o nome do arquivo usado para impressao em disco
	Private cGuiaAnt     := ""
	
	Private cString := "SZK"
	
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Monta a interface padrao com o usuario...                           ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return Nil

	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
		Return Nil

	Endif
	
	nTipo := If(aReturn[4]==1,15,18)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Processamento. RPTSTATUS monta janela com a regua de processamento. ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ

	//Everson - 18/10/2022 - ticket 81601.
	nTpRel	:= Iif(ValType(MV_PAR06) == "N", MV_PAR06, 1)
	lCSV 	:= ValType(MV_PAR07) == "N" .And. MV_PAR07 == 2

	RptStatus({|| RunReport(Cabec1, Cabec2, Titulo, nLin, nTpRel, lCSV) }, Titulo) //Everson - 18/10/2022 - ticket 81601.
	
Return Nil

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºFun‡„o    ³RUNREPORT º Autor ³ AP6 IDE            º Data ³  18/07/03   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescri‡„o ³ Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS º±±
±±º          ³ monta a janela com a regua de processamento.               º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Programa principal                                         º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

Static Function RunReport(Cabec1, Cabec2, Titulo, nLin, nTpRel, lCSV)

	//Everson - ticket 81601 - Everson - 20/10/2022.
	If nTpRel == 1 //Relatório analítico.
		detaRel(Cabec1, Cabec2, Titulo, nLin, nTpRel, lCSV)

	ElseIf nTpRel == 2 //Relatório sintético.
		sintRel(Cabec1, Cabec2, Titulo, nLin, nTpRel, lCSV)

	EndIf

Return Nil

Static Function detaRel(Cabec1, Cabec2, Titulo, nLin, nTpRel, lCSV)

	//Everson - ticket 81601 - Everson - 20/10/2022.
	//Variáveis.
	Local cArq    	:= ""
	Local cDir	  	:= ""
	Local nHdl	  	:= 0
	Local xPula	  	:= Chr(13) + Chr(10)
	Local cLin    	:= ""
	Local cIntegrado:= ""
	Local cQuery1	:= ""
	Local aACrDCr	:= {}
	Local nAux		:= 1

	dbSelectArea(cString)
	dbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SetRegua(RecCount())

	//+---------------------------------+
	//|MONTA QUERY NO SZK               |
	//+---------------------------------+
	QrySzk(nTpRel) //Everson - ticket 81601 - Everson - 20/10/2022.

	//Everson - ticket 81601 - Everson - 20/10/2022.
	If lCSV

		cArq := "Analítico" + __cUserID + "_" + DToS(Date()) + "_" + StrTran(cValToChar(Time()),":","") + ".CSV"

		cLin := "Data;Tipo de Frete;Fornecedor;Placa;Integrado;Entregas;Km;Peso;Total Frete;Descrição;Observações;Acréscimo;Desconto;"

		cDir := cGetFile("Arquivo CSV.", "Selecione o diretório para salvar o CSV",,'C:\',.T.,GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_NETWORKDRIVE)

		If Empty(Alltrim(cValToChar(cDir)))
			Return Nil

		EndIf
		
		nHdl := FCreate(cDir + cArq, 0)

		If nHdl < 0
			MsgAlert("O Arquivo não " + cArq + " pode ser criado:" + xPula + cValToChar(FError()),"Função detaRel(AD0088)")
			Return Nil

		EndIf

		DbSelectArea("ZV1")
		ZV1->(DbSetOrder(3))
		ZV1->(DbGoTop())

		While ! xSZK->(Eof())

			cLin += xPula

			cIntegrado := ""
			aACrDCr	   := {}

			If !Empty(xSZK->ZK_NUMOC) .And. Dbseek(FWxFilial("ZV1") + xSZK->ZK_NUMOC)
				cIntegrado := Alltrim(ZV1->ZV1_RGRANJ) 

			EndIf

			cQuery1 := 	scriptSZI(xSZK->ZK_PLACAPG, SToD(xSZK->ZK_DTENTR), SToD(xSZK->ZK_DTENTR), xSZK->ZK_GUIA, xSZK->ZK_ROTEIRO, nTpRel)

			TCQuery cQuery1 new alias "xSZI" 

			DbSelectArea("xSZI")
			xSZI->(DbGoTop())

			While ! xSZI->(Eof())

				Aadd(aACrDCr,{ xSZI->ZI_TIPO, SubsTr(xSZI->ZI_DESCRIC,1,25), SubsTr(xSZI->ZI_OBS,1,40), xSZI->ZI_VALOR })

				xSZI->(DbSkip())

			End

			xSZI->(DbCloseArea())

			If Len(aACrDCr) <= 0

				cLin += DToC(SToD(xSZK->ZK_DTENTR)) + ";" + cValToChar(xSZK->ZK_TIPFRT) + ";" + cValToChar(xSZK->ZK_FORNEC) + ";" + cValToChar(xSZK->ZK_PLACAPG);
						+ ";" + cIntegrado + ";"  + cValToChar(xSZK->ENTREGAS) + ";"  + cValToChar(xSZK->ZK_KMPAG) + ";"  + cValToChar(xSZK->ZK_PBRUTO);
						+ ";" + Transform(xSZK->ZK_VALFRET, "@E 999,999,999.99") + ";" + cValToChar("") + ";" + cValToChar("") + ";" + cValToChar("0") + ";" + cValToChar("0")

			Else

				For nAux := 1 To Len(aACrDCr)

					If nAux > 1

						cLin += DToC(SToD(xSZK->ZK_DTENTR)) + ";" + cValToChar(xSZK->ZK_TIPFRT) + ";" + cValToChar(xSZK->ZK_FORNEC) + ";" + cValToChar(xSZK->ZK_PLACAPG);
							+ ";"   + cIntegrado + ";0;0;0";
							+ ";0;" + cValToChar(aACrDCr[nAux][2]) + ";" + cValToChar(aACrDCr[nAux][3]);
							+ ";"   + Transform(Iif(aACrDCr[nAux][2] = "A", aACrDCr[nAux][4] , 0), "@E 999,999,999.99"); 
							+ ";"   + Transform(Iif(aACrDCr[nAux][2] = "D", aACrDCr[nAux][4] , 0), "@E 999,999,999.99"); 

					Else

						cLin += DToC(SToD(xSZK->ZK_DTENTR)) + ";" + cValToChar(xSZK->ZK_TIPFRT) + ";" + cValToChar(xSZK->ZK_FORNEC) + ";" + cValToChar(xSZK->ZK_PLACAPG);
							+ ";" + cIntegrado + ";"  + cValToChar(xSZK->ENTREGAS) + ";"  + cValToChar(xSZK->ZK_KMPAG) + ";"  + cValToChar(xSZK->ZK_PBRUTO);
							+ ";" + Transform(xSZK->ZK_VALFRET, "@E 999,999,999.99") + ";" + cValToChar(aACrDCr[nAux][2]) + ";" + cValToChar(aACrDCr[nAux][3]);
							+ ";" + Transform(Iif(aACrDCr[nAux][2] = "A", aACrDCr[nAux][4] , 0), "@E 999,999,999.99"); 
							+ ";" + Transform(Iif(aACrDCr[nAux][2] = "D", aACrDCr[nAux][4] , 0), "@E 999,999,999.99")

					EndIf

					cLin += Iif(nAux < Len(aACrDCr), xPula, "")			

				Next nAux

			EndIf

			FWrite(nHdl, cLin, Len(cLin))

			cLin := ""

			xSZK->(DbSkip())

		End

		FClose(nHdl)

		WinExec("Explorer.exe" + Space(1) + cDir )

		MsgInfo("Arquivo gerado.", "Função detaRel(AD0088)")

		Return Nil

	EndIf
	
	// Parametros
	_dDtEntr  := mv_par01
	_dDtEntr2 := mv_par02
	_cTransp  := mv_par03
	_cTransp2 := mv_par04
	_cTipFrt  := mv_par05
	
	// Variaveis de Trabalho
	_nTotFret   := 0
	_nTotPeso   := 0
	_nEntr      := 0
	_nViag      := 0
	_nTotEntr   := 0
	_ntTKmpag   := 0
	_TTotFret   := 0
	_TTotPeso   := 0
	_TTotEntr   := 0
	_TtTKmpag   := 0
	_TViag	    := 0
	_nTotAcres  := 0
	_nTotDesc   := 0
	_nTotFret   := 0
	_nTotPeso   := 0
	_nTotEntr   := 0
	_ntTKmpag   := 0
	
	//+---------------------------------+
	//|Total Geral Por transportadora   |
	//+---------------------------------+
	_nTransG:={0,0,0}

	//+---------------------------------+
	//|Total Geral                      |
	//+---------------------------------+
	_nToTG:={0,0,0}
	
	Cabec1  := SPACE(02)+ "Periodo de : " + substr(DTOS(_dDtEntr),7,2)+ "/" + substr(DTOS(_dDtEntr),5,2)+ "/" + substr(DTOS(_dDtEntr),1,4)+ SPACE(5) +  "Ate : " + substr(DTOS(_dDtEntr2),7,2)+ "/" + substr(DTOS(_dDtEntr2),5,2)+ "/" + substr(DTOS(_dDtEntr2),1,4)
	
	Cabec3  := "|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|"
	Cabec4  := "|            |           |      |            |             |               |                                           ** DESCONTO E ACRESCIMO **                                       |"
	Cabec5  := "|    DATA    | INTEGRADO | ENT. |     KM     |     PESO    |  TOTAL FRETE  |         DESCRICAO                    |            OBSERVAÇÃO              |    ACRESCIMO    |   DESCONTO   |"
	Cabec6  := "|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|"
	
	Cabec9   := "Relacao dos Fretes"
	Cabec10  := "Relacao dos Descontos e Acrescimos"

	_cFornec:= xSZK->ZK_FORNEC
	_cPlac	:= xSZK->ZK_PLACAPG

	lVez:='S'
	
	//+-------------------------------------+
	//|Enquanto nao for fim de arquivo      |
	//+-------------------------------------+
	Do While ! xSZK->(Eof())

		//+--------------------------------+
		//|Enquanto for o mesmo fornecedor |
		//+--------------------------------+    
		_cPlacAnt := ""
		_cPlac2Ant := ""

		While ! Eof() .And. _cFornec=xSZK->ZK_FORNEC
							
			//+--------------------------------+
			//|Enquanto for no mesma placa     |
			//+--------------------------------+
			While ! Eof() .And. _cPlac==xSZK->ZK_PLACAPG
										
				If nLin > 60 .or. (_cPlacAnt <> _cPlac) 
				
					If (_nTotFret <> 0  .OR. _nTotPeso <> 0) 
						@nLin,000 PSAY "|"+ Replicate ("=",183)+ "|"
						nLin := nLin + 1
						@nLin,000 PSAY "|"
						@nLin,002 PSAY " TOTAL "
						@nLin,013 PSAY "|" 
						@nLin,025 PSAY "|"                        
						@nLin,027 PSAY _nTotEntr  Picture "@E 9999"
						@nLin,032 PSAY "|"				
						@nLin,034 PSAY _ntTKmpag   Picture "@E 999,999.99"
						@nLin,045 PSAY "|"			
						@nLin,048 PSAY _nTotPeso  Picture "@E 999,999.99"
						@nLin,059 PSAY "|"			
						@nLin,064 PSAY _nTotFret Picture "@E 999,999.99"			
						@nLin,075 PSAY "|"
						
						@nLin,114 PSAY "|"					
						@nLin,116 PSAY "TOTAL "
						@nLin,151 PSAY "|"					
						@nLin,156 PSAY _nTotAcres Picture "@E 9,999,999.99"
						@nLin,169 PSAY "|"					
						@nLin,170 PSAY _nTotDesc Picture "@E 9,999,999.99"
						@nLin,184 PSAY "|"										
				
						nLin := nLin + 1
						@nLin,000 PSAY "|"+ Replicate ("=",183)+ "|"
						nLin := nLin + 1
						@nLin,000 PSAY SPACE(2)+ "TOTAL DE VIAGENS: "
						@nLin,021 PSAY _nViag                       					
						       
						nLin := nLin + 1
						@nLin,000 PSAY Replicate ("_",185)
						nLin := nLin + 1
						
						@nLin,002 PSAY "TOTAL A PAGAR: "
						@nLin,019 PSAY _nTotFret+(_nTotAcres -_nTotDesc) Picture "@E 999,999.99"	   //AB
						
						nLin := nLin + 1
						@nLin,000 PSAY Replicate ("_",185)
						nLin := nLin + 2
				
						_TTotFret  := _nTotFret
						_TTotPeso  := _nTotPeso
						_TTotEntr  := _nTotEntr
						_TtTKmpag  := _ntTKmpag
						_TViag	   := _nViag
						_nTotFret  := 0
						_nTotPeso  := 0
						_nTotEntr  := 0
						_ntTKmpag  := 0
						_nViag	   := 0
						_nTotAcres := 0
						_nTotDesc  := 0	
						_nEntr	   := 0

					Endif	
					
					DbselectArea("ZV4")
					DbSetOrder(1)
					dbseek(xFilial("ZV4")+_cPlac,.T.)
								
					Cabec2  := SPACE(02)+ "Trans.: " + ZV4_FORNEC+" "+ZV4_LOJFOR+" "+ZV4_NOMFOR+SPACE(03) +"Veiculo : " +ZV4_PLACA            
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9  				
					DbselectArea("xSZK")			
					
					@nLin,000 PSAY CABEC9
					nLin := nLin + 1
					@nLin,000 PSAY CABEC3
					nLin := nLin + 1
					@nLin,000 PSAY CABEC4
					nLin := nLin + 1
					@nLin,000 PSAY CABEC5
					nLin := nLin + 1   
					@nLin,000 PSAY CABEC6
					nLin := nLin + 1	

				Endif

				_nTotFret   += xSZK->ZK_VALFRET
				_nTotPeso   += xSZK->ZK_PBRUTO
				_ntTKmpag   += xSZK->ZK_KMPAG
				_nTotEntr   += xSZK->ENTREGAS
				_nViag      += 1
				_nEntr      := 0
								           
				@nLin,000 PSAY "|"
				@nLin,002 PSAY stod(xSZK->ZK_DTENTR)
				@nLin,013 PSAY "|" 
				
				DbselectArea("ZV1")
	            DbSetOrder(3)
				dbGoTop()			
				If dbseek(xFilial("ZV1")+xSZK->ZK_NUMOC)      //integrado (granja) NUMOC
					@nLin,019 PSAY Alltrim(ZV1->ZV1_RGRANJ) 
				Endif
				    
				@nLin,025 PSAY "|"//integrado
				@nLin,027 PSAY xSZK->ENTREGAS 	  Picture "@E 9999"
				@nLin,032 PSAY "|" 			
				@nLin,034 PSAY xSZK->ZK_KMPAG     Picture "@E 999,999.99"  
				@nLin,045 PSAY "|" 								
				@nLin,048 PSAY xSZK->ZK_PBRUTO    Picture "@E 999,999.99"			
				@nLin,059 PSAY "|"			
				@nLin,064 PSAY xSZK->ZK_VALFRET   Picture "@E 999,999.99"  

				//imprime os desconto e acrescimos da placa
				cGuiaAnt := ""

				nLin := QrySZI(_cPlac, nLin, SToD(xSZK->ZK_DTENTR), SToD(xSZK->ZK_DTENTR), xSZK->ZK_GUIA, xSZK->ZK_ROTEIRO, nTpRel)

				nLin := nLin + 1			
				
				_cPlacAnt := _cPlac			
				
				xSZK->(DbSkip())

			End

			lVez:='N'		
			
			_cPlac:=xSZK->ZK_PLACAPG
			dbSelectArea("xSZK")
		
		End	                   	
		
		_cFornec:=xSZK->ZK_FORNEC

		xSZK->(DbSkip())
	
	EndDo
	
	If (_nTotFret <> 0  .OR. _nTotPeso <> 0)            //ultima folha
		@nLin,000 PSAY "|"+ Replicate ("=",183)+ "|"
		nLin := nLin + 1
		@nLin,000 PSAY "|"
		@nLin,002 PSAY " TOTAL "
		@nLin,013 PSAY "|" 
		@nlin,025 PSAY "|"                       
		@nLin,027 PSAY _nTotEntr  Picture "@E 9999"
		@nLin,032 PSAY "|"				
		@nLin,034 PSAY _ntTKmpag   Picture "@E 999,999.99"
		@nLin,045 PSAY "|"			
		@nLin,048 PSAY _nTotPeso  Picture "@E 999,999.99"
		@nLin,059 PSAY "|"			
		@nLin,064 PSAY _nTotFret Picture "@E 999,999.99"			
		@nLin,075 PSAY "|"
		
		@nLin,114 PSAY "|"
		@nLin,116 PSAY "TOTAL "
		@nLin,151 PSAY "|"
		@nLin,156 PSAY _nTotAcres Picture "@E 9,999,999.99"
		@nLin,169 PSAY "|"
		@nLin,170 PSAY _nTotDesc Picture "@E 9,999,999.99"
		@nLin,184 PSAY "|"
				
		nLin := nLin + 1
		@nLin,000 PSAY "|"+ Replicate ("=",183)+ "|"
		nLin := nLin + 1
		@nLin,000 PSAY SPACE(2)+ "TOTAL DE VIAGENS: "
		@nLin,021 PSAY _nViag
						
		nLin := nLin + 1
		@nLin,000 PSAY Replicate ("_",185)
		nLin := nLin + 1
						
		@nLin,002 PSAY "TOTAL A PAGAR: "
		@nLin,029 PSAY _nTotFret+(_nTotAcres -_nTotDesc) Picture "@E 999,999.99" //alterado de 22 a 12
						
		nLin := nLin + 1
		@nLin,000 PSAY Replicate ("_",185)
		nLin := nLin + 2
			
		_TTotFret  := _nTotFret
		_TTotPeso  := _nTotPeso
		_TTotEntr  := _nTotEntr
		_TtTKmpag  := _ntTKmpag
		_TViag	   := _nViag
		_nTotFret  := 0
		_nTotPeso  := 0
		_nTotEntr  := 0
		_ntTKmpag  := 0
		_nViag	   := 0
		_nTotAcres := 0
		_nTotDesc  := 0			
	Endif	
	//ticket 86097 - Antonio Domingos - 04/01/2023
	If SELECT("xSZK") > 0
		xSZK->(dbCloseArea())
	EndIf
	If SELECT("xSZI") > 0
		xSZI->(dbCloseArea())
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return

Static Function sintRel(Cabec1, Cabec2, Titulo, nLin, nTpRel, lCSV)
	
	//Everson - ticket 81601 - Everson - 20/10/2022.
	//Variáveis.
	Local cArq    	:= ""
	Local cDir	  	:= ""
	Local nHdl	  	:= 0
	Local xPula	  	:= Chr(13) + Chr(10)
	Local cLin    	:= ""
	Local cIntegrado:= ""
	Local cQuery1	:= ""
	Local nTotAcres := 0
	Local nTotDecres:= 0

	dbSelectArea(cString)
	dbSetOrder(1)
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ SETREGUA -> Indica quantos registros serao processados para a regua ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SetRegua(RecCount())

	//+---------------------------------+
	//|MONTA QUERY NO SZK               |
	//+---------------------------------+
	QrySzk(nTpRel) //Everson - ticket 81601 - Everson - 20/10/2022.

	//Everson - ticket 81601 - Everson - 20/10/2022.
	If lCSV

		cArq := "Sintético" + __cUserID + "_" + DToS(Date()) + "_" + StrTran(cValToChar(Time()),":","") + ".CSV"

		cLin := "Tipo de Frete;Fornecedor;Placa;Integrado;Entregas;Km;Peso;Total Frete;Acréscimo;Desconto;Valor a Receber"

		cDir := cGetFile("Arquivo CSV.", "Selecione o diretório para salvar o CSV",,'C:\',.T.,GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_NETWORKDRIVE)

		If Empty(Alltrim(cValToChar(cDir)))
			Return Nil

		EndIf
		
		nHdl := FCreate(cDir + cArq, 0)

		If nHdl < 0
			MsgAlert("O Arquivo não " + cArq + " pode ser criado:" + xPula + cValToChar(FError()),"Função detaRel(AD0088)")
			Return Nil

		EndIf

		While ! xSZK->(Eof())

			cLin += xPula

			nTotAcres := 0
			nTotDecres:= 0

			cQuery1 := 	scriptSZI(xSZK->ZK_PLACAPG, MV_PAR01, MV_PAR02, "", "", nTpRel)

			TCQuery cQuery1 new alias "xSZI" 

			DbSelectArea("xSZI")
			xSZI->(DbGoTop())

			While ! xSZI->(Eof())

				If xSZI->ZI_TIPO = "A"
					nTotAcres  += xSZI->ZI_VALOR

				ElseIf xSZI->ZI_TIPO = "D"
					nTotDecres += xSZI->ZI_VALOR

				EndIf

				xSZI->(DbSkip())

			End

			xSZI->(DbCloseArea())

			cLin += cValToChar(xSZK->ZK_TIPFRT) + ";" + cValToChar(xSZK->ZK_FORNEC) + ";" + cValToChar(xSZK->ZK_PLACAPG);
					+ ";" + cIntegrado + ";"  + cValToChar(xSZK->ENTREGAS) + ";"  + cValToChar(xSZK->ZK_KMPAG) + ";"  + cValToChar(xSZK->ZK_PBRUTO);
					+ ";" + Transform(xSZK->ZK_VALFRET, "@E 999,999,999.99") + ";" + Transform(nTotAcres, "@E 999,999,999.99") + ";" + Transform(nTotDecres, "@E 999,999,999.99") + ";" + Transform(xSZK->ZK_VALFRET + nTotAcres - nTotDecres, "@E 999,999,999.99")

			FWrite(nHdl, cLin, Len(cLin))

			cLin := ""

			xSZK->(DbSkip())

		End

		FClose(nHdl)

		WinExec("Explorer.exe" + Space(1) + cDir )

		MsgInfo("Arquivo gerado.", "Função sintRel(AD0088)")

		Return Nil

	EndIf
	
	
	// Parametros
	_dDtEntr  := mv_par01
	_dDtEntr2 := mv_par02
	_cTransp  := mv_par03
	_cTransp2 := mv_par04
	_cTipFrt  := mv_par05
	
	// Variaveis de Trabalho
	_nTotFret   := 0
	_nTotPeso   := 0
	_nEntr      := 0
	_nViag      := 0
	_nTotEntr   := 0
	_ntTKmpag   := 0
	_TTotFret   := 0
	_TTotPeso   := 0
	_TTotEntr   := 0
	_TtTKmpag   := 0
	_TViag	    := 0
	_nTotAcres  := 0
	_nTotDesc   := 0
	_nTotFret   := 0
	_nTotPeso   := 0
	_nTotEntr   := 0
	_ntTKmpag   := 0
	
	//+---------------------------------+
	//|Total Geral Por transportadora   |
	//+---------------------------------+
	_nTransG:={0,0,0}

	//+---------------------------------+
	//|Total Geral                      |
	//+---------------------------------+
	_nToTG:={0,0,0}
	
	Cabec1  := SPACE(02)+ "Periodo de : " + substr(DTOS(_dDtEntr),7,2)+ "/" + substr(DTOS(_dDtEntr),5,2)+ "/" + substr(DTOS(_dDtEntr),1,4)+ SPACE(5) +  "Ate : " + substr(DTOS(_dDtEntr2),7,2)+ "/" + substr(DTOS(_dDtEntr2),5,2)+ "/" + substr(DTOS(_dDtEntr2),1,4)

	Cabec3  := "|-----------------------------------------------------------------------------------|"
	Cabec4  := "|       |            |             |               |                                |"
	Cabec5  := "|  ENT. |  KM TOTAL  |  PESO TOTAL |  TOTAL FRETE  |    ACRESCIMO    |   DESCONTO   |"
	Cabec6  := "|-----------------------------------------------------------------------------------|"
	
	Cabec9   := ""
	Cabec10  := ""

	_cFornec:= xSZK->ZK_FORNEC
	_cPlac	:= xSZK->ZK_PLACAPG

	lVez:='S'
	
	//+-------------------------------------+
	//|Enquanto nao for fim de arquivo      |
	//+-------------------------------------+
	Do While !Eof()

		//+--------------------------------+
		//|Enquanto for o mesmo fornecedor |
		//+--------------------------------+    
		_cPlacAnt := ""
		_cPlac2Ant := ""

		While ! Eof() .And. _cFornec=xSZK->ZK_FORNEC
							
			//+--------------------------------+
			//|Enquanto for no mesma placa     |
			//+--------------------------------+
			While ! Eof() .And. _cPlac==xSZK->ZK_PLACAPG
										
				If nLin > 60 .or. (_cPlacAnt <> _cPlac) 
				
					If (_nTotFret <> 0  .OR. _nTotPeso <> 0) 
						@nLin,000 PSAY "|"+ Replicate ("=",83)+ "|"
						nLin := nLin + 1
						
						@nLin,000 PSAY "|"
						@nLin,002 PSAY  _nTotEntr  Picture "@E 9999" 
						@nLin,008 PSAY "|" 
						@nLin,009 PSAY _ntTKmpag   Picture "@E 999,999.99"	                       
						@nLin,021 PSAY "|"
						@nLin,022 PSAY _nTotPeso  Picture "@E 999,999.99"			
						@nLin,036 PSAY "|"
						@nLin,037 PSAY _nTotFret Picture "@E 999,999.99"		
						@nLin,051 PSAY "|"
						@nLin,051 PSAY _nTotAcres Picture "@E 9,999,999.99"		
						@nLin,068 PSAY "|"			
						@nLin,066 PSAY _nTotDesc Picture "@E 9,999,999.99
						@nLin,085 PSAY "|"														
				
						nLin := nLin + 1
						@nLin,000 PSAY "|"+ Replicate ("=",83)+ "|"
						nLin := nLin + 1
						@nLin,000 PSAY SPACE(2)+ "TOTAL DE VIAGENS: "
						@nLin,021 PSAY _nViag                       					
						       
						nLin := nLin + 1
						@nLin,000 PSAY Replicate ("_",83)
						nLin := nLin + 1
						
						@nLin,002 PSAY "TOTAL A PAGAR: "
						@nLin,019 PSAY _nTotFret+(_nTotAcres -_nTotDesc) Picture "@E 999,999.99"	   //AB
						
						nLin := nLin + 1
						@nLin,000 PSAY Replicate ("_",83)
						nLin := nLin + 2
				
						_TTotFret  := _nTotFret
						_TTotPeso  := _nTotPeso
						_TTotEntr  := _nTotEntr
						_TtTKmpag  := _ntTKmpag
						_TViag	   := _nViag
						_nTotFret  := 0
						_nTotPeso  := 0
						_nTotEntr  := 0
						_ntTKmpag  := 0
						_nViag	   := 0
						_nTotAcres := 0
						_nTotDesc  := 0	
						_nEntr	   := 0

					Endif	
					
					DbselectArea("ZV4")
					DbSetOrder(1)
					dbseek(xFilial("ZV4")+_cPlac,.T.)
								
					Cabec2  := SPACE(02)+ "Trans.: " + ZV4_FORNEC+" "+ZV4_LOJFOR+" "+ZV4_NOMFOR+SPACE(03) +"Veiculo : " +ZV4_PLACA            
					Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
					nLin := 9  				
					DbselectArea("xSZK")			
					
					@nLin,000 PSAY CABEC3
					nLin := nLin + 1
					@nLin,000 PSAY CABEC4
					nLin := nLin + 1
					@nLin,000 PSAY CABEC5
					nLin := nLin + 1   

				Endif

				_nTotFret   += xSZK->ZK_VALFRET
				_nTotPeso   += xSZK->ZK_PBRUTO
				_ntTKmpag   += xSZK->ZK_KMPAG
				_nTotEntr   += xSZK->ENTREGAS
				_nViag      += 1
				_nEntr      := 0

				cGuiaAnt := ""

				nLin := QrySZI(_cPlac, nLin, _dDtEntr,  _dDtEntr2, "", "", nTpRel)

				nLin := nLin + 1			
				
				_cPlacAnt := _cPlac	
				        		
				xSZK->(DbSkip())

			End

			lVez:='N'		
			
			_cPlac:=xSZK->ZK_PLACAPG

			dbSelectArea("xSZK")
		
		End	                   	
		
		_cFornec:=xSZK->ZK_FORNEC

		xSZK->(DbSkip())
	
	EndDo
	
	// If (_nTotFret <> 0  .OR. _nTotPeso <> 0)            //ultima folha
	// 	@nLin,000 PSAY "|"+ Replicate ("=",183)+ "|"
	// 	nLin := nLin + 1
	// 	@nLin,000 PSAY "|"
	// 	@nLin,002 PSAY " TOTAL "
	// 	@nLin,013 PSAY "|" 
	// 	@nlin,025 PSAY "|"                       
	// 	@nLin,027 PSAY _nTotEntr  Picture "@E 9999"
	// 	@nLin,032 PSAY "|"				
	// 	@nLin,034 PSAY _ntTKmpag   Picture "@E 999,999.99"
	// 	@nLin,045 PSAY "|"			
	// 	@nLin,048 PSAY _nTotPeso  Picture "@E 999,999.99"
	// 	@nLin,059 PSAY "|"			
	// 	@nLin,064 PSAY _nTotFret Picture "@E 999,999.99"			
	// 	@nLin,075 PSAY "|"
		
	// 	@nLin,114 PSAY "|"
	// 	@nLin,116 PSAY "TOTAL "
	// 	@nLin,151 PSAY "|"
	// 	@nLin,156 PSAY _nTotAcres Picture "@E 9,999,999.99"
	// 	@nLin,169 PSAY "|"
	// 	@nLin,170 PSAY _nTotDesc Picture "@E 9,999,999.99"
	// 	@nLin,184 PSAY "|"
				
	// 	nLin := nLin + 1
	// 	@nLin,000 PSAY "|"+ Replicate ("=",183)+ "|"
	// 	nLin := nLin + 1
	// 	@nLin,000 PSAY SPACE(2)+ "TOTAL DE VIAGENS: "
	// 	@nLin,021 PSAY _nViag
						
	// 	nLin := nLin + 1
	// 	@nLin,000 PSAY Replicate ("_",185)
	// 	nLin := nLin + 1
						
	// 	@nLin,002 PSAY "TOTAL A PAGAR: "
	// 	@nLin,029 PSAY _nTotFret+(_nTotAcres -_nTotDesc) Picture "@E 999,999.99" //alterado de 22 a 12
						
	// 	nLin := nLin + 1
	// 	@nLin,000 PSAY Replicate ("_",185)
	// 	nLin := nLin + 2
			
	// 	_TTotFret  := _nTotFret
	// 	_TTotPeso  := _nTotPeso
	// 	_TTotEntr  := _nTotEntr
	// 	_TtTKmpag  := _ntTKmpag
	// 	_TViag	   := _nViag
	// 	_nTotFret  := 0
	// 	_nTotPeso  := 0
	// 	_nTotEntr  := 0
	// 	_ntTKmpag  := 0
	// 	_nViag	   := 0
	// 	_nTotAcres := 0
	// 	_nTotDesc  := 0			
	// Endif	
	//ticket 86097 - Antonio Domingos - 04/01/2023
	If SELECT("xSZK") > 0
		xSZK->(dbCloseArea())
	EndIf
	If SELECT("xSZI") > 0
		xSZI->(dbCloseArea())
	EndIf
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Finaliza a execucao do relatorio...                                 ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	SET DEVICE TO SCREEN
	
	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Se impressao em disco, chama o gerenciador de impressao...          ³
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	
	If aReturn[5]==1
		dbCommitAll()
		SET PRINTER TO
		OurSpool(wnrel)
	Endif
	
	MS_FLUSH()

Return

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³AD0088    ºAutor  ³DANIEL              º Data ³  03/02/07   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Monta query so SZK                                          º±±
±±º          ³                                                            º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

Static Function QrySzk(nTpRel)

	Local cQuery:=""
	
	If nTpRel == 1 //Everson - ticket 81601 - Everson - 20/10/2022.

		cQuery+=" SELECT "
		cQuery+=" 	ZK_TIPFRT, "
		cQuery+=" 	ZK_PLACAPG, "
		cQuery+=" 	ZK_DTENTR, "
		cQuery+=" 	ZK_FORNEC, "
		cQuery+=" 	ZK_VALFRET, "
		cQuery+=" 	ZK_PBRUTO, "
		cQuery+=" 	ZK_ENTREGA-ZK_ENTRDEV AS ENTREGAS, "
		cQuery+=" 	ZK_KMPAG, "
		cQuery+=" ZK_NOMFOR, "
		cQuery+=" ZK_NUMOC, "
		cQuery+=" ZK_GUIA, "
		cQuery+=" ZK_ROTEIRO "
		cQuery+=" FROM "+RETSQLNAME("SZK")+" (NOLOCK) "
		cQuery+=" WHERE "
		cQuery+=" 	ZK_FILIAL = '" + FWxFilial("SZK") + "' AND (ZK_DTENTR BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND " //ticket 70750 - Everson - 07/04/2022.
		cQuery+=" 	(ZK_FORNEC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
		cQuery+=" 	ZK_TIPFRT='"+MV_PAR05+"' AND "
		cQuery+=" 	D_E_L_E_T_='' "
		cQuery+=" ORDER BY "
		cQuery+=" ZK_PLACAPG,ZK_DTENTR "

	ElseIf nTpRel == 2 //Everson - ticket 81601 - Everson - 20/10/2022.

		cQuery+=" SELECT "
			cQuery+=" ZK_TIPFRT, " 	
			cQuery+=" ZK_PLACAPG, " 		
			cQuery+=" ZK_FORNEC,  "	
			cQuery+=" ZK_NOMFOR, "
			cQuery+=" SUM(ZK_VALFRET) AS ZK_VALFRET,  "	
			cQuery+=" SUM(ZK_PBRUTO) AS ZK_PBRUTO, " 	
			cQuery+=" SUM(ZK_ENTREGA-ZK_ENTRDEV) AS ENTREGAS, "  	
			cQuery+=" SUM(ZK_KMPAG) AS ZK_KMPAG "
		cQuery+=" FROM "+RETSQLNAME("SZK")+" (NOLOCK) "
		cQuery+=" WHERE "
		cQuery+=" 	ZK_FILIAL = '" + FWxFilial("SZK") + "' AND (ZK_DTENTR BETWEEN '"+DTOS(MV_PAR01)+"' AND '"+DTOS(MV_PAR02)+"') AND " //ticket 70750 - Everson - 07/04/2022.
		cQuery+=" 	(ZK_FORNEC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') AND "
		cQuery+=" 	ZK_TIPFRT='"+MV_PAR05+"' AND "
		cQuery+=" 	D_E_L_E_T_='' "
		cQuery+=" GROUP BY "
		cQuery+=" 	ZK_TIPFRT, "  	
		cQuery+=" 	ZK_PLACAPG, "  		
		cQuery+=" 	ZK_FORNEC, "  	
		cQuery+=" 	ZK_NOMFOR "
		cQuery+=" ORDER BY "
		cQuery+=" ZK_PLACAPG "

	EndIf
	
	TCQUERY cQuery NEW ALIAS "xSZK"
	dbselectArea("xSZK")
	xSZK->(DbgoTop())

Return Nil

//+-----------------------------+
//|seleciona as guias no SZI    |
//+-----------------------------+
Static Function QrySZI(cPlaca, xLin, cDtDe, cDtAte, cCodGuia, cRoteiro, nTpRel) //Everson - ticket 81601 - Everson - 20/10/2022.

	If Select("xSZI") > 0
	   xSZI->(DbCloseArea())

	Endif
	
	//cQuery1 +=	" ZK_GUIA=ZI_GUIA "
	//cQuery1 +=	" AND ZK_GUIA='" + Alltrim(cCodGuia) + "' "        
	
	//alteração will
	
	cQuery1 := 	scriptSZI(cPlaca, cDtDe, cDtAte, cCodGuia, cRoteiro, nTpRel) //Everson - ticket 81601 - Everson - 20/10/2022.
	
	TCQuery cQuery1 new alias "xSZI"    
	
	DBSELECTAREA("xSZI")
	DBGOTOP()
	         
	lEntrSZI := .F.
	lEntrAC  := .F.
	lEntrDS  := .F.
	xLinOri  := xLin
	While ! Eof()
		If xLin > 60
			DbselectArea("ZV4")
			DbSetOrder(1)
			dbseek(xFilial("ZV4")+cPlaca,.T.)
			//@nLin,000 PSAY "PLACA :" +_cPlac+" "+ZV4->ZV4_NOMFOR
			//nLin++		   
			Cabec1  := SPACE(02)+ "Periodo de : " + substr(DTOS(_dDtEntr),7,2)+ "/" + substr(DTOS(_dDtEntr),5,2)+ "/" + substr(DTOS(_dDtEntr),1,4)+ SPACE(5) +  "Ate : " + substr(DTOS(_dDtEntr2),7,2)+ "/" + substr(DTOS(_dDtEntr2),5,2)+ "/" + substr(DTOS(_dDtEntr2),1,4)						
			Cabec2  := SPACE(02)+ "Trans.: " + ZV4_FORNEC+" "+ZV4_LOJFOR+" "+ZV4_NOMFOR+SPACE(03) +"Veiculo : " +ZV4_PLACA            
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			xLin := 9  				
			DbselectArea("xSZK")	

			If nTpRel == 1 //Everson - ticket 81601 - Everson - 20/10/2022.			
				
				@xLin,000 PSAY CABEC9
				xLin := xLin + 1
				@xLin,000 PSAY CABEC3
				xLin := xLin + 1
				@xLin,000 PSAY CABEC4
				xLin := xLin + 1
				@xLin,000 PSAY CABEC5
				xLin := xLin + 1     
				@xLin,000 PSAY CABEC6
				xLin := xLin + 1		

			EndIf		
			
		Endif 
		
		//Ana - 07/07/14. Criação da variavel cGuiaAnt para evitar duplicidade de acrescimo / desconto quando a consulta da SZK gera mais de um retorno
		//WIlliam Costa - 30/01/2015. chamado 021752. Foi ajustado o select acima motivo, estava com a chave da tabela errado.
		//A chave da tabela e placa + data e so estava com a data gerando o erro de duplicidade adicionado a linha 485
		//cQuery1 +=	" AND ZK_DTENTR=ZI_DATALAN " //chamado 021752
		//Apos essa alteracao como a tabela esta carregando corretamente foi retirado o if que a ana fez por motivo de nao ter mais 
		//necessidade do mesmo pois a guia nao se repete mais.
		//If Alltrim(cGuiaAnt) <> Alltrim(xSZI->ZI_GUIA) // CHAMADO 021295
			IF TRIM(xSZI->ZI_TIPO) = 'A'
				_nTotAcres += xSZI->ZI_VALOR
				
				lEntrSZI := .T.

				If nTpRel == 1 //Everson - ticket 81601 - Everson - 20/10/2022.
		                       
					If xLinOri <> xLin 
						@xLin,000 PSAY "|"
						@xLin,013 PSAY "|" 
						@xLin,025 PSAY "|"
						@xLin,032 PSAY "|"
						@xLin,045 PSAY "|"	//ok
						@xLin,059 PSAY "|"	
					Endif	
				
					@xLin,075 PSAY "|" 
					@xLin,077 PSAY SUBSTR(xSZI->ZI_DESCRIC,1,25)   Picture "@!" //descrição
					@xLin,114 PSAY "|"      
					@xLin,116 PSAY SUBSTR(xSZI->ZI_OBS,1,40)   Picture "@!"
					@xLin,152 PSAY "|"		//ok
					@xLin,157 PSAY xSZI->ZI_VALOR Picture "@E 9,999,999.99"
					@xLin,170 PSAY "|"    //ok
					@xLin,185 PSAY "|"
					xLin := xLin + 1     

				EndIf 

			ELSE
				If TRIM(xSZI->ZI_TIPO) = 'D'
					_nTotDesc += xSZI->ZI_VALOR
					
					lEntrSZI := .T.

					If nTpRel == 1 //Everson - ticket 81601 - Everson - 20/10/2022.
			
						If xLinOri <> xLin 
							@xLin,000 PSAY "|"
							@xLin,013 PSAY "|" 
							@xLin,025 PSAY "|"
							@xLin,032 PSAY "|"
							@xLin,045 PSAY "|"//estava '+'
							@xLin,059 PSAY "|"	 	
						Endif		
					
						@xLin,075 PSAY "|"
						@xLin,077 PSAY SUBSTR(xSZI->ZI_DESCRIC,1,25)   Picture "@!"
						@xLin,114 PSAY "|"     //**************
						@xLin,116 PSAY SUBSTR(xSZI->ZI_OBS,1,40)   Picture "@!"
						@xLin,152 PSAY "|"
						@xLin,170 PSAY "|"			
						@xLin,171 PSAY xSZI->ZI_VALOR Picture "@E 9,999,999.99"
						@xLin,185 PSAY "|"
					
						xLin := xLin + 1

					EndIf
	
				ENDIF
			ENDIF
	    //ENDIF
		
	//	cGuiaAnt := xSZI->ZI_GUIA    // CHAMADO 021295
		dbSelectArea("xSZI")
		Dbskip() 
			
	Enddo
	
	If xLinOri == xLin .And. nTpRel == 1 //Everson - ticket 81601 - Everson - 20/10/2022.
		@xLin,075 PSAY "|"
		@xLin,114 PSAY "|"
		@xLin,151 PSAY "|"
		@xLin,169 PSAY "|"
		@xLin,184 PSAY "|"

	Endif
			          
	/*
	If _nTotAcres  <> 0 .or.  _nTotDesc  <> 0
		
		@xLin,000 PSAY "|"+ Replicate ("=",78)+ "|"
		xLin := xLin + 1
		@xLin,000 PSAY "|"
		@xLin,002 PSAY "TOTAL"
		@xLin,012 PSAY "|"
		@xLin,019 PSAY "|"
		@xLin,048 PSAY "|"
		@xLin,050 PSAY _nTotAcres   Picture "@E 9,999,999.99"
		@xLin,064 PSAY "|"
		@xLin,065 PSAY _nTotDesc    Picture "@E 9,999,999.99"
		@xLin,079 PSAY "|"
		xLin := xLin + 1
		@xLin,000 PSAY "|"+ Replicate ("=",78)+ "|"
		xLin := xLin + 1
		@xLin,000 PSAY SPACE(2)+ "TOTAL A PAGAR "
		@xLin,021 PSAY _TTotFret+(_nTotAcres -_nTotDesc) Picture "@E 999,999.99"
		xLin := xLin + 1
		@xLin,000 PSAY Replicate ("_",79)
		
	EndIf
	If _nTotAcres +_nTotDesc =0
		xLin := xLin + 1
		@xLin,000 PSAY "|"+ Replicate ("=",78)+ "|"
		xLin := xLin + 1
		@xLin,000 PSAY SPACE(2)+ "TOTAL A PAGAR "
		@xLin,021 PSAY _TTotFret Picture "@E 999,999.99"
		xLin := xLin + 1
		@xLin,000 PSAY "|"+ Replicate ("_",78)+ "|"
	endIf
	*/
	//xLin := 65 
	
	If lEntrSZI .And. nTpRel == 1
		xLin := xLin - 1

	Endif

Return(xLin)

//Everson - ticket 81601 - Everson - 20/10/2022.
Static Function scriptSZI(cPlaca, cDtDe, cDtAte, cCodGuia, cRoteiro, nTpRel)

	//Variáveis.
	Local cQuery1 := ""

	Default cCodGuia := ""
	Default cRoteiro := ""

	If Alltrim(MV_PAR05) = 'FV' //FRANGO VIVO
	
		cQuery1 := 	" SELECT ZI_GUIA, ZI_PLACA, ZI_DATALAN,ZI_TIPO, ZI_VALOR,ZI_DESCRIC,ZI_OBS "
		cQuery1 +=	" FROM "+RETSQLNAME("SZI")+" (NOLOCK) , "+RETSQLNAME("SZK")+" (NOLOCK) "
		cQuery1 +=	" WHERE "
		cQuery1 +=	" ZK_FILIAL = '" + FWxFilial("SZK") + "' AND ZI_FILIAL = '" + FWxFilial("SZI") + "' " + Iif(nTpRel == 1, "", "AND ZK_GUIA='" + Alltrim(cCodGuia) + "' ") //ticket 70750 - Everson - 07/04/2022.
		cQuery1 +=	" AND ZK_TIPFRT='"+MV_PAR05+"' "
		cQuery1 +=	" AND (ZK_FORNEC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') "
		cQuery1 +=	" AND ( ZK_DTENTR BETWEEN '"+DTOS(cDtDe) +"' AND '"+DTOS(cDtAte)+"')"
		cQuery1 +=	" AND ZI_PLACA='"+cPlaca+"' "
		cQuery1 +=	" AND ZK_DTENTR=ZI_DATALAN " //chamado 021752
		cQuery1 +=	" AND ZK_PLACA=ZI_PLACA "
		cQuery1 +=	" AND ZK_GUIA=ZI_GUIA "
		cQuery1 +=	" AND "+RetSqlName("SZK")+ ".D_E_L_E_T_ <> '*' "
		cQuery1 +=	" AND "+RetSqlName("SZI")+ ".D_E_L_E_T_ <> '*' "
		cQuery1 +=	" ORDER BY ZI_PLACA, ZI_DATALAN "
	
	Else  // FRETE NORMAL
	
		cQuery1 := 	" SELECT ZI_GUIA, ZI_PLACA, ZI_DATALAN,ZI_TIPO, ZI_VALOR,ZI_DESCRIC,ZI_OBS "
		cQuery1 +=	" FROM "+RETSQLNAME("SZI")+" (NOLOCK) , "+RETSQLNAME("SZK")+" (NOLOCK) "
		cQuery1 +=	" WHERE "
		cQuery1 +=	" ZK_FILIAL = '" + FWxFilial("SZK") + "' AND ZI_FILIAL = '" + FWxFilial("SZI") + "' " + Iif(nTpRel == 1, "", "AND ZK_GUIA='" + Alltrim(cCodGuia) + "' ")//ticket 70750 - Everson - 07/04/2022.
		cQuery1 +=	" AND ZK_TIPFRT='"+MV_PAR05+"' "
		cQuery1 +=	" AND (ZK_FORNEC BETWEEN '"+MV_PAR03+"' AND '"+MV_PAR04+"') "
		cQuery1 +=	" AND ( ZK_DTENTR BETWEEN '"+DTOS(cDtDe) +"' AND '"+DTOS(cDtAte)+"')"
		cQuery1 +=	" AND ZK_PLACA='"+cPlaca+"' "

		If nTpRel == 1
			cQuery1 +=	" AND ZK_ROTEIRO='"+cRoteiro+"' "

		EndIf

		cQuery1 +=	" AND ZK_DTENTR=ZI_DATALAN " //chamado 021752
		cQuery1 +=	" AND ZK_PLACA=ZI_PLACA "
		cQuery1 +=	" AND ZK_ROTEIRO = ZI_ROTEIRO "
		cQuery1 +=	" AND "+RetSqlName("SZK")+ ".D_E_L_E_T_ <> '*' "
		cQuery1 +=	" AND "+RetSqlName("SZI")+ ".D_E_L_E_T_ <> '*' "
		cQuery1 +=	" ORDER BY ZI_PLACA, ZI_DATALAN "
	
	EndIf

Return cQuery1
