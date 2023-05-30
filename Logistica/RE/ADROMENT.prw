#INCLUDE "protheus.ch"   
#INCLUDE "topconn.ch"
              
/*/{Protheus.doc} User Function ADROMENT
	Relatorio de Romaneio de Entrega
	@type  Function
	@author HCCONSYS
	@since 19/11/2008
	@version version
	@history Alteração - Everson	     - 24/04/2019 - Chamado: 048650 - Alterado script sql para impressão derelatório para pedidos para fornecedor.
	@history Alteração - FWNM   	     - 02/08/2019 - Chamado: 049495 - OS 050775  ADM.LOG || MARCEL  || ROMANEIO ENTREGAS   
  	@history Alteração - FWNM   	     - 08/08/2019 - Chamado: 049495 - 049495 || OS 050775 || ADM.LOG || MARCEL Incluir novo campo ZFM_NUMCE2
	@history Alteração - Fernando Sigoli - 29/10/2019 - Chamado: 052915 || OS 054267 || FISCAL || RAUL || 8423 || REL. ROMANEIO 
	@history Alteração - William Costa   - 25/11/2019 - Adiciona para não trazer placas iguais a branco no relatório
	@hisotry Alteração - Everson         - 02/07/2020 - Chamado: 059359. Adicionado impressão de vale palete. 
	@history Alteração - Everosn         - 03/07/2020 - Chamado: 059401. Tratamento para utilizar o vale palete no relatório ROTLOG.
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history Ticket 69574   - Abel Babini          - 25/04/2022 - Projeto FAI
	@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de função PUTSX1
	@history Alteração - Everson - 23/06/2022 - Ticket 75212 - Adicionar filtro por placa de veículo e nota fiscal. 
	@history Ticket 79163 - Antonio Domingos - 20/09/2022 - CANHOTO - MELHORIA
	@history Ticket 81179 - Everson - 18/10/2022 - Melhorias.
	@history Ticket T.I   - Sigoli  - 03/11/2022 - ajustado query com joyn no edata para seguir o indice do banco de dados	
	@history Everson, 10/01/2023 - Ticket 86371 - Ajuste da query com Edata.
	@history Everson, 27/03/2023, ticket 90716 - rotina para impressão de NF + boleto + romaneio.
	@history Everson, 03/04/2023, ticket 90716 - Melhoria na impressão do romaneio.
/*/

User Function ADROMENT(aRoteiros) // U_ADROMENT() //Everson - 27/03/2023 - ticket 90716.

	Private cDesc1			:= "Este programa tem como objetivo imprimir relatorio "
	Private cDesc2			:= "de acordo com os parametros informados pelo usuario."
	Private cDesc3			:= ""
	Private cPict			:= ""
	Private titulo			:= "Relatorio de Romaneio de Entrega"
	Private nLin			:= 80
	Private Cabec1			:= ""
	Private Cabec2			:= ""
	Private imprime			:= .T.
	Private aOrd			:= {}
	
	Private lEnd   	    	:= .F.
	Private lAbortPrint 	:= .F.
	Private limite			:= 220
	Private tamanho			:= "G"
	Private nomeprog		:= "ADROMENT" 
	Private nTipo			:= 18
	Private aReturn			:= { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
	Private nLastKey		:= 0
	Private cbtxt			:= Space(10)
	Private cbcont			:= 00
	Private CONTFL			:= 01
	Private m_pag			:= 01
	Private wnrel			:= "ADROMENT"
	//Private cPerg			:= "ADROEU" && "ADROET"
	Private cPerg			:= PADR("ADROEU",10," ")
	Private cString			:= "SD2"
	Private aResult 		:= {} 

	Default aRoteiros		:= {} //Everson - 27/03/2023 - ticket 90716.
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio de Romaneio de Entrega')
	
	//Everson - 27/03/2023 - ticket 90716.
	If IsInCallStack("U_FISTRF01") .And. Len(aRoteiros) > 0
	
		zAtuPerg(cPerg, "MV_PAR01" , aRoteiros[1]) //Data de entrega de
        zAtuPerg(cPerg, "MV_PAR02" , aRoteiros[2]) //Data de entrega até
        zAtuPerg(cPerg, "MV_PAR03" , aRoteiros[3]) //Roteiro de
        zAtuPerg(cPerg, "MV_PAR04" , Space(2))
        zAtuPerg(cPerg, "MV_PAR05" , aRoteiros[4]) //Roteiro até
        zAtuPerg(cPerg, "MV_PAR06" , "ZZ")
        zAtuPerg(cPerg, "MV_PAR07" , Space(6))
        zAtuPerg(cPerg, "MV_PAR08" , "ZZZZZZ")
        zAtuPerg(cPerg, "MV_PAR09" , Space(6))
        zAtuPerg(cPerg, "MV_PAR010", "ZZZZZZ")
        zAtuPerg(cPerg, "MV_PAR011", Space(7))
        zAtuPerg(cPerg, "MV_PAR012", "ZZZZZZZ")

		//Everson - 03/04/2023 - ticket 90716
        zAtuPerg(cPerg, "MV_PAR13", aRoteiros[5])
        zAtuPerg(cPerg, "MV_PAR14", aRoteiros[6])
        zAtuPerg(cPerg, "MV_PAR15", aRoteiros[7])
        zAtuPerg(cPerg, "MV_PAR16", aRoteiros[8])

	EndIf
	
	If !Pergunte(cPerg,.T.)
		Return
	EndIf

	wnrel := SetPrint(cString,NomeProg,"",@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)
	
	If nLastKey == 27
		Return
	Endif
	
	SetDefault(aReturn,cString)
	
	If nLastKey == 27
	   Return
	Endif                     
	
	Processa( {|| fSelect()},"")  && Retornar arquivo temporario de impressao
	
	nTipo := If(aReturn[4]==1,15,18)
	
	dbSelectArea("TARQ")
	Count to nRegs
	TARQ->(dbGoTop())
		
	If nRegs > 0
		Processa( {|| RunReport()},"Emitindo relatorio....")  
	Else
		SET DEVICE TO SCREEN
		
		If aReturn[5]==1
		   dbCommitAll()
		   SET PRINTER TO
		   OurSpool(wnrel)
		Endif
		
		MS_FLUSH()	
	Endif	
	
	If Select("TARQ") > 0
		TARQ->(dbCloseArea())
	Endif	

Return()

              
/*/{Protheus.doc} Static Function RUNREPORT
	Relatorio de Romaneio de Entrega
	@type  Function
	@author HCCONSYS
	@since 18/11/2008
	@version version
	@history Alteração - MOTIVO DA ALTERACAO
/*/

Static Function RunReport()

	Local nRegs		:= 0
	Local cChave	:= ""
	Local nTotCx	:= 0
	Local nTotKg	:= 0
	Local cDescP	:= CriaVar("B1_DESC",.F.)
	Local cLinhaca  := ""
	Local cCanhoto  := ""
	Local nNumero1  := 0 
	Local cRoteiroC := ""
	Local cPlacaCan := ""
	Local aDanfesCa := {}
	Local nQuantasD := 0
	Local cDanfesC1 := ""
	Local cDanfesC2 := ""
	Local cDanfesC3 := ""
	Local nIndice   := 0
	Local nTotGCx	:= 0       //Incluido totalizador conforme chamado 026388
	Local nTotGKg	:= 0       //Incluido totalizador conforme chamado 026388
	Local n1    
	Local cRotZFN   := ""
	Local aNumDoc   :=  {}
	Local _cNumDoc  := " "
	
	dbSelectArea("TARQ")
	Count to nRegs
	TARQ->(dbGoTop())
	
	ProcRegua(nRegs)
	
	if !TARQ->(Eof())
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8                                        		
		
		// Chamado n. 049495 || OS 050775 || ADM.LOG || MARCEL || 8365 || ROMANEIO ENTREGAS - FWNM - 02/08/2019
		cRotZFN   := TARQ->F2_ROTEIRO
		UpRotAtend(cRotZFN, @nLin)
		//
	endif
	
	While TARQ->(!Eof())
	
		IncProc()
		If lAbortPrint
			@ nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
			Exit
		Endif
		If nLin+8 > 60
		@ 65,000 PSAY 'Motorista (Nome): ____________________________   Assinatura:  _______________________   RG: _______________    DATA: ___/____/_____' 		
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8                                        		

			// Chamado n. 049495 || OS 050775 || ADM.LOG || MARCEL || 8365 || ROMANEIO ENTREGAS - FWNM - 02/08/2019
			cRotZFN   := TARQ->F2_ROTEIRO
			UpRotAtend(cRotZFN, @nLin)
			//
		Endif
	    
		&& Impressao Cabecalho
	
		@ nLin,000 PSAY Replicate("-",132)
		nLin ++	
		@ nLin,000 PSAY 'Danfe No. '		+ Alltrim(TARQ->F2_DOC)+"/"+Alltrim(TARQ->F2_SERIE) 	//TARQ->F2_NFELETR
		Aadd(aDanfesCa, Alltrim(TARQ->F2_DOC)+"/"+Alltrim(TARQ->F2_SERIE) )
		_cNumDoc := Alltrim(TARQ->F2_DOC)+"/"+Alltrim(TARQ->F2_SERIE)
		_cNomeCli := TARQ->A1_NOME
		If ASCAN(aNumDoc, _cNumDoc) == 0
			Aadd(aNumDoc, {_cNumDoc,_cNomeCli} )
		EndIf
		@ nLin,045 PSAY 'Roteiro: ' 		+ TARQ->F2_ROTEIRO 
		cRoteiroC := TARQ->F2_ROTEIRO
		&&Mauricio - 04/08/17 - Chamado 036478 - 
		IF Alltrim(TARQ->C5_PRIOR) == "R"	   
		   @ nLin,065 PSAY 'REPROGRAMADO'
		ENDIF		
		@ nLin,100 PSAY 'Sequencia: '  	+ TARQ->F2_SEQUENC
		cLinhaca := Alltrim(TARQ->F2_DOC)+"/"+Alltrim(TARQ->F2_SERIE) + Space(8)
		// @ nLin,120 PSAY 'R ou P '	&& Verificar com Heversom impressao deste campo 
		
		nLin ++ 
		
		@ nLin,000 PSAY 'Cliente   ' 		+ Alltrim(TARQ->F2_CLIENTE) + "/" + Alltrim(TARQ->F2_LOJA) + " - " + Alltrim(TARQ->A1_NOME)
		@ nLin,090 PSAY 'Nome Fantasia: '+ Alltrim(TARQ->A1_NREDUZ)
		
		nLin ++
		
		@ nLin,000 PSAY '**Placa** '		+ Alltrim(TARQ->F2_PLACA) //Chamado: 052915 || OS 054267 - Fernando Sigoli 29/10/2019
		cPlacaCan := TARQ->F2_PLACA
		@ nLin,050 PSAY 'Endereco '		+ Alltrim(TARQ->A1_END)
		@ nLin,100 PSAy 'Fone   '    		+ Alltrim(TARQ->A1_TEL)
		
		nLin ++
		
		@ nLin,000 PSAY 'Bairro    ' 		+ Alltrim(TARQ->A1_BAIRRO)
		@ nLin,050 PSAY 'Cidade   '		+ Alltrim(TARQ->A1_MUN)
		@ nLin,100 PSAY 'Estado '			+ Alltrim(TARQ->A1_EST)
		
		nLin ++      
		
		@ nLin,000 PSAY 'Vendedor  ' 		+ Alltrim(TARQ->F2_VEND1) 
		
		@ nLin,020 PSAY 'Hora Entrega: ' + "M: " + UPPER(TARQ->C5_HRINIM) + " - " +	UPPER(TARQ->C5_HRFINM) + " | T: " + UPPER(TARQ->C5_HRINIT) + " - " +	UPPER(TARQ->C5_HRFINT) //Everson - 09/11/2017. Chamado 037879.,1,64))) //WILLIAM COSTA CHAMADO 030817
		
		If !Empty(TARQ->A1_CEP)
			@ nLin,100 PSAY 'CEP    '			+ Substr(TARQ->A1_CEP,1,5) + "-" + Substr(TARQ->A1_CEP,6,3)
		Else
			@ nLin,100 PSAY 'CEP    '
		Endif
		
		cChave	:= TARQ->F2_DOC + TARQ->F2_SERIE          
		
		&& Impressao de Cabecalho dos Itens
		
		nLin ++
		@ nLin,000 PSAY 'PRIORIDADE: ' + Alltrim(TARQ->C5_PRIOR)
		
		nLin+=2
		/* 				 012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789 */
		/* 				          10        20        30        40        50        60        70        80        90       100       110      120*/
		@ nLin,000 PSAY 'PRODUTO            DESCRICAO                                                              CAIXAS                KG'
		
		nLin +=2           
		//@ nLin,000 PSAY Replicate("-",132)
		//nLin++	
	
		nTotCx	:= 0	&& Total de Caixas
		nTotKg	:= 0	&& Total em Kgs.
		While TARQ->F2_DOC + TARQ->F2_SERIE == cChave
	
			If lAbortPrint
				@ nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
				Exit
			Endif 
			If nLin > 60
				@ 65,000 PSAY 'Motorista (Nome): ____________________________   Assinatura:  _______________________   RG: _______________    DATA: ___/____/_____' 		
				Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
				nLin := 8

				// Chamado n. 049495 || OS 050775 || ADM.LOG || MARCEL || 8365 || ROMANEIO ENTREGAS - FWNM - 02/08/2019
				cRotZFN   := TARQ->F2_ROTEIRO
				UpRotAtend(cRotZFN, @nLin)
				//
			Endif
	    	
	    	@ nLin,000 PSAY TARQ->D2_COD
	    	cDescP	:= Posicione("SB1",1,xFilial("SB1") + TARQ->D2_COD, "B1_DESC")
	    	@ nLin,019 PSAY Alltrim(cDescP)
	    	@ nLin,082 Psay TARQ->D2_QTSEGUM			Picture '@E 999,999,999.99'
	    	@ nLin,100 Psay TARQ->D2_QUANT			Picture '@E 999,999,999.99'
	    			
			nTotCx += TARQ->D2_QUANT
			nTotKg += TARQ->D2_QTSEGUM
			
			nLin ++
			TARQ->(dbSkip())
		
		
		Enddo	
	
		If nLin > 60
			@ 65,000 PSAY 'Motorista (Nome): ____________________________   Assinatura:  _______________________   RG: _______________    DATA: ___/____/_____' 		
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := 8

			// Chamado n. 049495 || OS 050775 || ADM.LOG || MARCEL || 8365 || ROMANEIO ENTREGAS - FWNM - 02/08/2019
			cRotZFN   := TARQ->F2_ROTEIRO
			UpRotAtend(cRotZFN, @nLin)
			//
		Endif	

		&& Impressao dos Totais
	   	@ nLin,070 PSAY	'TOTAL'
	   	@ nLin,082 PSAY nTotKg					Picture '@E 999,999,999.99'
	   	@ nLin,100 PSAY nTotCx					Picture '@E 999,999,999.99'
	    	
		nTotGCx += nTotCx
		nTotGKg += nTotKg
	
	  	nLin ++ 
	
	Enddo
	
	&& Impressao dos Totais
	//Incluido totalizador conforme chamado 026388
	@ nLin,000 PSAY Replicate("-",132)
	nLin ++	
	@ nLin,064 PSAY	'TOTAL GERAL'
	@ nLin,082 PSAY nTotGKg					Picture '@E 999,999,999.99'
	@ nLin,100 PSAY nTotGCx					Picture '@E 999,999,999.99'
	nLin ++	
	@ nLin,000 PSAY Replicate("-",132)
	nLin ++	
	@ 65,000 PSAY 'Motorista (Nome): ____________________________   Assinatura:  _______________________   RG: _______________    DATA: ___/____/_____' 		
	nLin := 0

	ASort(aDanfesCa)
	nQuantasD:= Len(aDanfesCa)
	nNumero1 := Val(Substr(dtoc(dDatabase),4,2) + Left(dtoc(dDatabase),2) + Left(time(),2) + Substr(time(),4,2) + Right(time(),2) )
	cCanhoto := Padl(dec2hex(nNumero1), 8, "0")

	nContador:= 1
	aImpCanhoto:={}		
	aSort(aNumDoc, , , {|x, y| x[1] < y[1]})
	For n1:=1 to Len(aNumDoc)
		Aadd(aImpCanhoto,{aNumDoc[n1,1],aNumDoc[n1,2]})
		If nContador == 5 .or. n1==Len(aNumDoc) 
			u_fCanhotos(aImpCanhoto,cRoteiroC,cPlacaCan,cCanhoto)
			aImpCanhoto:={}		
			nContador  :=0
		EndIf
		nContador++
	Next n1
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin:=8

	@ nLin++, 000 PSAY "                                                                                                                                                                               |                                                        "
	@ nLin++, 000 PSAY "____________________________________________________________________________________________________________________________________________________________________________         __________________________________________________ "
	@ nLin++, 000 PSAY "                                                                                                                                                                               |    |                                                  |"
	@ nLin++, 000 PSAY " AD'ORO S/A                                                          Relatorio de conferencia de canhotos                                                   Data: " + DtoC(dDATABASE) + "        |                    AD'ORO  S/A                   |"
	@ nLin++, 000 PSAY "____________________________________________________________________________________________________________________________________________________________________________   |    |                                                  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                                    |         Recibo de conferencia de canhotos        |"
	@ nLin++, 000 PSAY "                                                                                                                                                                               |    |                                                  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                                    |                                                  |"
	@ nLin++, 000 PSAY "            Roteiro: " + cRoteiroC + "    **Placa**: " + cPlacaCan + "                                                                                                                                |    |       Roteiro: " + cRoteiroC + "    **Placa**: "+cPlacaCan +"         |"  //Chamado: 052915 || OS 054267 - Fernando Sigoli 29/10/2019  
	@ nLin++, 000 PSAY "                                                                                                                                                                                    |                                                  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                               |    |                                                  |"
	@ nLin++, 000 PSAY "         Recebi os canhotos ref. NF's abaixo:                                                                                                                                       |   Recebi os canhotos ref. NF's abaixo:           |"
	@ nLin++, 000 PSAY "                                                                                                                                                                               |    |                                                  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                                    |                                                  |"
	nIndice := 1
	While nIndice <= nQuantasD
		cDanfesC1 := Space(12)
		cDanfesC2 := Space(12)
		cDanfesC3 := Space(12)
		If nQuantasD >= nIndice
			cDanfesC1 = aDanfesCa[nIndice]
		Endif
		If nQuantasD >= (nIndice + 1)
			cDanfesC2 = aDanfesCa[nIndice + 1]
		Endif
		If nQuantasD >= (nIndice + 2)
			cDanfesC3 = aDanfesCa[nIndice + 2]
		Endif
		@ nLin++, 000 PSAY "      " + cDanfesC1 + "      " + cDanfesC2 + "     " + cDanfesC3 + "                                                                                                                          |    | " + cDanfesC1 + "      " + cDanfesC2 + "     " + cDanfesC3 + "  |"
		nIndice += 3
	EndDo

	//Everson - 18/10/2022 - ticket 81179.
	@ nLin++, 000 PSAY "                                                                                                                                                                               |    |                                                  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                                    |                                                  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                               |    |                                                  |"
	@ nLin++, 000 PSAY "      Conferente (Nome): ____________________________                                                                                                                               | Conferente (Nome): ____________________________  |" //Everson - 18/10/2022 - ticket 81179.
	@ nLin++, 000 PSAY "                                                                                                                                                                               |    |                                                  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                                    |                                                  |"
	@ nLin++, 000 PSAY "                   Data: _______/________/___________                                                                                                                          |    |              Data: _______/________/___________  |" //Everson - 18/10/2022 - ticket 81179.
	@ nLin++, 000 PSAY "                                                                                                                                                                                    |                                                  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                               |    |                                                  |"
	@ nLin++, 000 PSAY "             Assinatura: ____________________________                                                                                                                               |        Assinatura: ____________________________  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                               |    |                                                  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                                    |                                                  |"
	
	//Everson - 18/10/2022 - ticket 81179.
	@ nLin++, 000 PSAY "                                                         A T E N Ç Ã O ! ! !   Sr. Transportador: entregar os canhotos e esta folha organizada em ordem numérica               |    |                                         
	@ nLin++, 000 PSAY "                                                         ==================================================================================================================         |                                                  |"
	@ nLin++, 000 PSAY "  can." + cCanhoto + "                                                                                                                                                                 |    | can." + cCanhoto + "                   Data: " + DtoC(dDATABASE) + "  |"
	@ nLin++, 000 PSAY "                                                                                                                                                                                    |__________________________________________________|"
	While nLin <= 78
	   @ nLin,175 PSAY "|"
	   nLin += 2
	Enddo

	//Everson - 02/07/2020. Chamado 059359.
	If GetMv("MV_#PALTIM",,.T.)
		MsAguarde({|| vlPalete(MV_PAR01,MV_PAR02,MV_PAR03,MV_PAR05,MV_PAR04,MV_PAR06) },"Função RunReport(ADROMENT)","Gerando recibo de paletes...")
	
	EndIf
	//
	
	SET DEVICE TO SCREEN
	
	//If aReturn[5]==1
	//   dbCommitAll()
	//   SET PRINTER TO
	//   OurSpool(wnrel)
	//Endif
	
	//MS_FLUSH()
	 
	Set Device to Screen 
	If aReturn[5] = 1   	
		Set Printer To    	
		dbCommitAll()   	
		OurSpool(wnrel)
	Endif 
	
	MS_FLUSH()
	
	
Return()
	
/* Funcao para selecionar regitros a emitir */
Static Function fSelect()
	
	Local cQuery		:= ""           
	
	Local _cCodSup 	:= CriaVar("A3_COD", .F.)
	Local _cSupVends 	:= CriaVar("A3_COD", .F.)
	Local _cUserName  := Subs(cUsuario,7,15)   	// Nome do Usuario
	
	// 1a. Verificacao - E' Gerente ?
	If !(Alltrim(_cUserName) $ GetMV("MV_GERENTE") )	// Se for gerente nao tem Filtro
		
		// 2a. Verificacao - E' Supervisor ?
		dbSelectArea("SZR")
		dbSetOrder(2)		// ZR_FILIAL+ZR_DESCRIC
		If dbSeek( xFilial("SZR")+_cUserName )
			
			_cCodSup := SZR->ZR_CODIGO            			// Busca Codigo Supervisor
			
			dbSelectArea("SA3")
			dbSetOrder(5)	// A3_FILIAL+A3_SUPER
			If dbSeek( xFilial("SA3")+_cCodSup )
				
				&& Armazena em _cSupVends todos os Vendedores do Supervisor
				_cSupVends  := ""
				
				While SA3->(!Eof()) .AND. xFilial("SA3") == SA3->A3_FILIAL	.and. _cCodSup == SA3->A3_SUPER
					
					_cSupVends  :=  _cSupVends + "'"	+ SA3->A3_COD + "', "
					
					dbSelectArea("SA3")
					SA3->(dbSkip())
				
				Enddo  
				
				If !empty(_cSupVends)
					_cSupVends := Left(_cSupVends,Len(_cSupVends)-2)
				Endif
				
			Endif   
			
		Else
	
			// 3a. Verificacao - E' Vendedor ?
	
			dbSelectArea("SA3")
			dbSetOrder(2)
			If dbSeek( xFilial("SA3")+_cUserName )
	
				_cSupVends := "'"+SA3->A3_COD+"'"
				
			Endif
			
		Endif
		
	Endif 
	//
	cQuery 	:= " SELECT "
	cQuery 	+= " SF2.F2_DOC,SF2.F2_SERIE,SF2.F2_CLIENTE,SF2.F2_LOJA,SF2.F2_ROTEIRO,SF2.F2_SEQUENC,SF2.F2_PLACA,SF2.F2_VEND1,SF2.F2_NFELETR,SF2.F2_VEND1,  "
	cQuery 	+= " SD2.D2_COD,SD2.D2_QUANT,SD2.D2_QTSEGUM, C5_NUM, C5_DTENTR, C5_VEND1, C5_XHRENTR, C5_PRIOR, "
	
	//Everson - 24/04/19. Chamado 048650.
	cQuery 	+= " CASE WHEN C5_TIPO = 'B' THEN SA2.A2_NOME   ELSE SA1.A1_NOME END AS  A1_NOME, "
	cQuery 	+= " CASE WHEN C5_TIPO = 'B' THEN SA2.A2_NREDUZ ELSE SA1.A1_NREDUZ END AS A1_NREDUZ, "
	cQuery 	+= " CASE WHEN C5_TIPO = 'B' THEN SA2.A2_END    ELSE SA1.A1_END END AS A1_END, "
	cQuery 	+= " CASE WHEN C5_TIPO = 'B' THEN SA2.A2_TEL    ELSE SA1.A1_TEL END AS A1_TEL, "
	cQuery 	+= " CASE WHEN C5_TIPO = 'B' THEN SA2.A2_MUN    ELSE SA1.A1_MUN END AS A1_MUN, "
	cQuery 	+= " CASE WHEN C5_TIPO = 'B' THEN SA2.A2_BAIRRO ELSE SA1.A1_BAIRRO END AS A1_BAIRRO, "
	cQuery 	+= " CASE WHEN C5_TIPO = 'B' THEN SA2.A2_EST    ELSE SA1.A1_EST END AS A1_EST, "
	cQuery 	+= " CASE WHEN C5_TIPO = 'B' THEN SA2.A2_CEP    ELSE SA1.A1_CEP END AS A1_CEP, "
	//
	
	cQuery	+= " SA3.A3_CODSUP,SA3.A3_COD, SC5.C5_HRINIM, SC5.C5_HRFINM, SC5.C5_HRINIT, SC5.C5_HRFINT, SC5.C5_PRIOR  "
	cQuery	+= " FROM " 
	cQuery	+= " " + RETSQLNAME("SF2") + " SF2 WITH(NOLOCK) INNER JOIN "+RETSQLNAME("SC5") +" SC5 WITH(NOLOCK) "  
	cQuery	+= " ON SC5.C5_NOTA = SF2.F2_DOC AND SC5.C5_FILIAL = SF2.F2_FILIAL AND SC5.C5_SERIE = SF2.F2_SERIE "
	cQuery	+= " INNER JOIN " + RETSQLNAME("SD2") + " SD2 WITH(NOLOCK)" 
	cQuery	+= " ON SF2.F2_DOC =	SD2.D2_DOC AND SF2.F2_SERIE = SD2.D2_SERIE AND SF2.F2_FILIAL = SD2.D2_FILIAL "
	
	//Everson - 24/04/19. Chamado 048650.
	cQuery	+= " LEFT OUTER JOIN "
	cQuery	+= " (SELECT A1_COD, A1_LOJA, A1_NOME, A1_NREDUZ, A1_END, A1_TEL, A1_MUN, A1_BAIRRO, A1_EST, A1_CEP FROM " + RetSqlName("SA1") +  " SA1 WITH(NOLOCK) WHERE SA1.D_E_L_E_T_ = '') AS SA1  " 
	cQuery	+= " ON SF2.F2_CLIENTE 	= 	SA1.A1_COD  "
	cQuery	+= " AND SF2.F2_LOJA = SA1.A1_LOJA  " 
	
	//Everson - 24/04/19. Chamado 048650.
	cQuery	+= " LEFT OUTER JOIN "
	cQuery	+= " (SELECT A3_COD, A3_CODSUP FROM " + RetSqlName("SA3") +  " SA3 WITH(NOLOCK) WHERE SA3.D_E_L_E_T_ = '') AS SA3 "
	cQuery	+= " ON SF2.F2_VEND1 = SA3.A3_COD  " 
	
	//Everson - 24/04/19. Chamado 048650.
	/*// *** INICIO CHAMADO 040508 WILLIAM COSTA 22/03/2018 *** //
	IF CEMPANT == '01'
	
		cQuery	+= " INNER JOIN " + RETSQLNAME("SA3") + " SA3 WITH(NOLOCK) ON SF2.F2_VEND1 = SA3.A3_COD "
		cQuery	+= " AND SA3.D_E_L_E_T_  = ' ' "
		cQuery 	+= " AND SA3.A3_CODSUP 	BETWEEN '"	+ MV_PAR07			+ "' AND '"	+ MV_PAR08		+ "' "
		 
		
	ELSE 
	
		cQuery	+= " LEFT JOIN " + RETSQLNAME("SA3") + " SA3 WITH(NOLOCK) ON SF2.F2_VEND1 = SA3.A3_COD "
		cQuery	+= " AND SA3.D_E_L_E_T_  = ' ' "
		cQuery 	+= " AND SA3.A3_CODSUP 	BETWEEN '"	+ MV_PAR07			+ "' AND '"	+ MV_PAR08		+ "' "
		 
	
	ENDIF
	// *** FINAL CHAMADO 040508 WILLIAM COSTA 22/03/2018 *** //
	*/
	
	//Everson - 24/04/19. Chamado 048650.
	cQuery	+= " LEFT OUTER JOIN "
	cQuery	+= " (SELECT A2_COD, A2_LOJA, A2_NOME, A2_NREDUZ, A2_END, A2_TEL, A2_MUN, A2_BAIRRO, A2_EST, A2_CEP FROM " + RetSqlName("SA2") +  " SA2 (NOLOCK) WHERE SA2.D_E_L_E_T_ = '') AS SA2 "
	cQuery	+= " ON SF2.F2_CLIENT = SA2.A2_COD "
	cQuery	+= " AND SF2.F2_LOJA = SA2.A2_LOJA "  
	
	cQuery	+= " WHERE " 
	cQuery	+= " SC5.D_E_L_E_T_  = ' ' "  
	cQuery	+= " AND SF2.F2_FILIAL   = '" + XFILIAL("SF2") 			+ "' AND SF2.D_E_L_E_T_ = ' ' "
	cQuery	+= " AND SD2.D2_FILIAL 	 = '" + XFILIAL("SD2") 			+ "' AND SD2.D_E_L_E_T_ = ' ' " 
	cQuery	+= " AND SF2.F2_ROTEIRO	BETWEEN '" 	+ MV_PAR03 			+ "' AND '" + MV_PAR05 		+ "' "
	cQuery  += " AND SF2.F2_SEQUENC BETWEEN '" 	+ MV_PAR04			+ "' AND '" + MV_PAR06 		+ "' "
	
	cQuery	+= " AND C5_DTENTR 		BETWEEN '" 	+ DTOS(MV_PAR01)	+ "' AND '" + DTOS(MV_PAR02)+ "' "

	cQuery	+= " AND C5_PLACA  BETWEEN '" + cValToChar(MV_PAR11) + "' AND '" + cValToChar(MV_PAR12) + "' " //William Costa - 25/11/2019 - Chamado 053588 //Everson - 23/06/2022. Chamado 75212.
	cQuery	+= " AND F2_DOC    BETWEEN '" + cValToChar(MV_PAR13) + "' AND '" + cValToChar(MV_PAR15) + "' "   //Everson - 23/06/2022. Chamado 75212.
	cQuery	+= " AND F2_SERIE  BETWEEN '" + cValToChar(MV_PAR14) + "' AND '" + cValToChar(MV_PAR16) + "' " //Everson - 23/06/2022. Chamado 75212.

	cQuery 	+= " AND ISNULL(C5_VEND1,'')  		BETWEEN '"	+ MV_PAR09   		+ "' AND '" + MV_PAR10 		+ "' " //Everson - 24/04/19. Chamado 048650.
	cQuery 	+= " AND ISNULL(SA3.A3_CODSUP,'') 	BETWEEN '"	+ MV_PAR07			+ "' AND '"	+ MV_PAR08		+ "' " //Everson - 24/04/19. Chamado 048650.
	
	If !Empty(_cSupVends)
		cQuery 	+= "AND C5_VEND1  	IN ("+ _cSupVends +") " 
	Endif
	
	cQuery	+= " ORDER BY SF2.F2_ROTEIRO,SF2.F2_SEQUENC,SF2.F2_DOC,SF2.F2_SERIE 
	
	MEMOWRITE( "C:\TEMP\ADROMENT.SQL", cQuery )

	Conout( DToC(Date()) + " " + Time() + " ADROMENT - fSelect - cQuery " + cQuery )
	
	TcQuery cQuery New Alias "TARQ"        
	
	TARQ->(dbGoTop())

Return()

/*/{Protheus.doc} Static Function ValidPerg
	Funcao para criacao de Grupo de Perguntas 
	@type  Function
	@author HCCONSYS
	@since 08/02/2019
	@version version
/*/

//Static Function ValidPerg()
//
//	Local _sAlias := Alias()
//	Local aRegs := {}
//	Local i,j
//	
//	dbSelectArea("SX1")
//	dbSetOrder(1)
//	cPerg := PADR(cPerg,Len(SX1->X1_GRUPO))
//	
//	// Grupo/Ordem/Pergunta/Variavel/Tipo/Tamanho/Decimal/Presel/GSC/Valid/Var01/Def01/Cnt01/Var02/Def02/Cnt02/Var03/Def03/Cnt03/Var04/Def04/Cnt04/Var05/Def05/Cnt05
//	aAdd(aRegs,{cPerg,"01","Entrega de 			? " ,""  ,""	,"MV_CH1","D",08,0,0,"G",""	,"MV_PAR01","","","","","","","","","","","","","","","","","","","","","","","","",""})
//	aAdd(aRegs,{cPerg,"02","Entrega Ate			? " ,""  ,""	,"MV_CH2","D",08,0,0,"G",""	,"MV_PAR02","","","","","","","","","","","","","","","","","","","","","","","","",""})
//	aAdd(aRegs,{cPerg,"03","Roteiro de			? " ,""  ,""	,"MV_CH3","C",03,0,0,"G",""	,"MV_PAR03","","","","","","","","","","","","","","","","","","","","","","","","",""})
//	aAdd(aRegs,{cPerg,"04","Sequencia de 		? " ,""  ,""	,"MV_CH4","C",02,0,0,"G",""	,"MV_PAR04","","","","","","","","","","","","","","","","","","","","","","","","",""})
//	aAdd(aRegs,{cPerg,"05","Roteiro ate			? " ,""  ,""	,"MV_CH5","C",03,0,0,"G",""	,"MV_PAR05","","","","","","","","","","","","","","","","","","","","","","","","",""})
//	aAdd(aRegs,{cPerg,"06","Sequencia Ate		? " ,""  ,""	,"MV_CH6","C",02,0,0,"G",""	,"MV_PAR06","","","","","","","","","","","","","","","","","","","","","","","","",""})
//	aAdd(aRegs,{cPerg,"07","Do Supervisor     ? " ,""  ,""	,"MV_CH7","C",06,0,0,"G",""	,"MV_PAR07","","","","","","","","","","","","","","","","","","","","","","","","","ZR1"})
//	aAdd(aRegs,{cPerg,"08","Ate Supervisor    ? " ,""  ,""	,"MV_CH8","C",06,0,0,"G",""	,"MV_PAR08","","","","","","","","","","","","","","","","","","","","","","","","","ZR1"})
//	aAdd(aRegs,{cPerg,"09","Do Vendedor       ? " ,""  ,""	,"MV_CH9","C",06,0,0,"G",""	,"MV_PAR09","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
//	aAdd(aRegs,{cPerg,"10","Ate Vendedor      ? " ,""  ,""	,"MV_CHA","C",06,0,0,"G",""	,"MV_PAR10","","","","","","","","","","","","","","","","","","","","","","","","","SA3"})
//	
//	For i:=1 to Len(aRegs)
//		If !dbSeek(cPerg+aRegs[i,2])
//			RecLock("SX1",.T.)
//			For j:=1 to FCount()
//				If j <= Len(aRegs[i])
//					FieldPut(j,aRegs[i,j])
//				Endif
//			Next
//			MsUnlock()
//		Endif
//	Next
//	dbSelectArea(_sAlias)
//
//Return

/*/{Protheus.doc} Static Function ValidPerg
	Decimal para hexadecimal
	@type  Function
	@author HCCONSYS
	@since 08/02/2019
	@version version
/*/

STATIC FUNCTION dec2hex(num) 

	local matrizc := {"1","2","3","4","5","6","7","8","9","A","B","C","D","E","F"} 
	local caract  := "" 
	local resto   := 0 
	local tamanho := 0 
	local retorno := "" 
	local nx 
	  
	do while .t. 
	   inteiro := int(num/16) 
	   resto   := mod(num,16)   
	   if resto > 0 
	      caract  += matrizc[resto] 
	   else 
	      caract  += "0" 
	   endif   
	   num := inteiro    
	   if num > 16 
	      loop 
	   else 
	      resto  := mod(num,16) 
	      caract += matrizc[resto] 
	      exit 
	   endif 
	enddo   
	tamanho := len(caract) 
	if tamanho == 0 
	   return("") 
	endif 
	for nx := tamanho to 1 step -1 
	    retorno += substr(caract,nx,1) 
	next       
	
return(retorno)

/*/{Protheus.doc} Static Function UpRotAtend
	Relatorio de Romaneio de Entrega
	@type  Function
	@author HCCONSYS
	@since 08/02/2019
	@version version
	@history Alteração - 049495 || OS 050775 || ADM.LOG || MARCEL || 8365 ||ROMANEIO ENTREGAS 
/*/

Static Function UpRotAtend(cRoteiro, nLin)
       
	Local aAreaAtu := GetArea() 
	
	nLin ++	
	@ nLin,000 PSAY Replicate("-",limite)
	nLin ++	
	@ nLin,000 PSAY 'CONTATOS ATENDENTES RESPONSAVEIS'
	nLin ++	
	@ nLin,000 PSAY Replicate("-",limite)

	ZFN->( dbSetOrder(1) ) // ZFN_FILIAL+ZFN_ROTEIR+ZFN_CODIGO                                                                                                                                
	If ZFN->( dbSeek( FWxFilial("ZFN")+cRoteiro ) )
	
		ZFM->( dbSetOrder(1) ) // ZFM_FILIAL+ZFM_CODIGO+ZFM_NOME                                                                                                                                  
		If ZFM->( dbSeek( FWxFilial("ZFM")+ZFN->ZFN_CODIGO ) )
			
			nLin ++	
			@ nLin,000 PSAY "Nome: " + AllTrim(ZFM->ZFM_NOME)
			nLin ++	
//			@ nLin,000 PSAY "Celular/Fixo: " + AllTrim(ZFM->ZFM_NUMCEL) + " / " + AllTrim(ZFM->ZFM_NUMFIX) 
			@ nLin,000 PSAY "Celular/Fixo: " + AllTrim(ZFM->ZFM_NUMCEL) + " / " + AllTrim(ZFM->ZFM_NUMFIX) + " / " + AllTrim(ZFM->ZFM_NUMCE2) // Chamado n. 049495 || OS 050775 || ADM.LOG || MARCEL || 8365 || Incluir novo campo ZFM_NUMCE2 - FWNM - 08/08/2019
			nLin ++	
			@ nLin,000 PSAY "Almoco: " + AllTrim(ZFM->ZFM_HORALM)
			nLin ++	
			@ nLin,000 PSAY "Durante almoco contatar: " + AllTrim(ZFM->ZFM_OBSALM)
			nLin ++	
			@ nLin,000 PSAY Replicate("-",limite)
			nLin ++	
		
		Else
			
			nLin ++	
			@ nLin,000 PSAY "Nome: " 
			nLin ++	
			@ nLin,000 PSAY "Celular/Fixo: "
			nLin ++	
			@ nLin,000 PSAY "Almoco: "
			nLin ++	
			@ nLin,000 PSAY "Durante almoco contatar: "
			nLin ++	
			@ nLin,000 PSAY Replicate("-",limite)
			nLin ++	
		
		EndIf
	
	EndIf
		
	RestArea( aAreaAtu )

Return
/*/{Protheus.doc} vlPalete
	Imprime vale palete.
	@type  Static Function
	@author Everson
	@since 02/07/2020
	@version 01
	******** Função também utilizada no relatório ROTLOG ********
	/*/
Static Function vlPalete(dDtIni,dDtFim,cRotDe,cRotAte,cSeqIni,cSeqFim,cQuery) //Everson - 03/07/2020. Chamado 059401. 

	//Variáveis.
	Local aArea		:= GetArea()
	Local cCliente	:= ""
	Local cCarga   	:= ""
	Local cDtFech  	:= ""
	Local cPlaca   	:= ""
	Local cMotorit 	:= ""
	Local aEmb     	:= ""

	Default cQuery  := sqlVlPlt(dDtIni,dDtFim,cRotDe,cRotAte,cSeqIni,cSeqFim) //Everson - 03/07/2020. Chamado 059401. 

	//
	If Select("D_PLT") > 0
		D_PLT->(DbCloseArea())

	EndIf

	//
	TcQuery cQuery New Alias "D_PLT"
	DbSelectArea("D_PLT")
	D_PLT->(DbGoTop())

	While ! D_PLT->(Eof())

		//
		cCarga   := Alltrim(cValToChar(D_PLT->NUMERO_CARGA))
		cCliente := Alltrim(D_PLT->CLIENTE)
		cDtFech  := cValToChar(D_PLT->DATA_FECHA_CARGA)
		cPlaca   := Alltrim(D_PLT->VEICULO)
		cMotorit := Alltrim(D_PLT->MOTORISTA)
		aEmb     := {}

		//
		While cCarga == Alltrim(cValToChar(D_PLT->NUMERO_CARGA)) .And. cCliente == Alltrim(D_PLT->CLIENTE) 

			//
			Aadd(aEmb,{Alltrim(D_PLT->EMBALAGEM),D_PLT->QUANTIDADE})

			//
			D_PLT->(DbSkip())

		End

		//
		prtVlPlt(cCarga,cCliente,cDtFech,cPlaca,cMotorit,aEmb)

	End

	//
	RestArea(aArea)

Return Nil
/*/{Protheus.doc} sqlVlPlt
	Script sql para geração do vale palete.
	@type  Static Function
	@author Everson
	@since 02/07/2020
	@version 01
	/*/
Static Function sqlVlPlt(dDtIni,dDtFim,cRotDe,cRotAte,cSeqIni,cSeqFim)

	//Variáveis.
	Local cQuery 	:= ""
	Local cLnkSrv	:= Alltrim(SuperGetMV("MV_#UEPSRV",,"LNKMIMS")) //Ticket 69574   - Abel Babini          - 25/04/2022 - Projeto FAI
	Local cNxtAlias	:= GetNextAlias()
	Local cSeqs		:= "99999999999999999"

	//Everson, 10/01/2023 - Ticket 86371
	cQuery := ""
	cQuery += " SELECT  " 
	cQuery += " DISTINCT C5_X_SQED*1 AS SEQ " 
	cQuery += " FROM  " 
	cQuery += " " + RetSqlName("SC5") + " (NOLOCK) AS SC5 " 
	cQuery += " INNER JOIN " 
	cQuery += " " + RetSqlName("SF2") + " (NOLOCK) AS SF2 ON " 
	cQuery += " SC5.C5_FILIAL = SF2.F2_FILIAL  " 
	cQuery += " AND SC5.C5_NOTA = SF2.F2_DOC  " 
	cQuery += " AND SC5.C5_SERIE = SF2.F2_SERIE " 
	cQuery += " WHERE  " 
	cQuery += " C5_FILIAL = '" + FWxFilial("SC5") + "'  " 
	cQuery += " AND F2_ROTEIRO BETWEEN '" + cRotDe + "' AND '" + cRotAte + "' " 
	cQuery += " AND C5_DTENTR BETWEEN '" + DToS(dDtIni) + "' AND '" + DToS(dDtFim) + "' " 
	cQuery += " AND F2_SEQUENC BETWEEN '" + cSeqIni + "' AND '" + cSeqFim + "' " 
	cQuery += " AND SC5.D_E_L_E_T_ = '' " 

	DbUseArea(.T., "TOPCONN", TCGenQry(,,cQuery), cNxtAlias, .F., .T.)

	(cNxtAlias)->(DbGoTop())

	If ! (cNxtAlias)->(Eof())

		cSeqs := ""

		While ! (cNxtAlias)->(Eof())

			cSeqs += Alltrim(cValToChar((cNxtAlias)->SEQ)) + ","

			(cNxtAlias)->(DbSkip())

		End

		cSeqs := Substr(cSeqs, 1, Len(cSeqs) - 1)

	EndIf

	(cNxtAlias)->(DbCloseArea())
	//

	cQuery := ""
	cQuery += " SELECT  " 
	cQuery += " TOP 1 EDATA.NUMERO_CARGA,  " 
	cQuery += " EDATA.DATA_FECHA_CARGA,  " 
	cQuery += " EDATA.TRANSPORTADOR,  " 
	cQuery += " EDATA.MOTORISTA, " 
	cQuery += " EDATA.VEICULO, " 
	cQuery += " EDATA.CLIENTE,  " 
	cQuery += " EDATA.EMBALAGEM, " 
	cQuery += " SUM(EDATA.QUANTIDADE) AS QUANTIDADE " 
	cQuery += " FROM ["+cLnkSrv+"].[SMART].[dbo].ADORO_VW_VALEPALETE AS EDATA " 
	cQuery += " WHERE " 
	cQuery += " EDATA.NUMERO_CARGA IN ( " + cSeqs + " ) " //Everson, 10/01/2023 - Ticket 86371
	cQuery += " GROUP BY " 
	cQuery += " EDATA.NUMERO_CARGA,  " 
	cQuery += " EDATA.DATA_FECHA_CARGA,  " 
	cQuery += " EDATA.TRANSPORTADOR,  " 
	cQuery += " EDATA.MOTORISTA, " 
	cQuery += " EDATA.VEICULO, " 
	cQuery += " EDATA.CLIENTE,  " 
	cQuery += " EDATA.EMBALAGEM "
	cQuery += " ORDER BY EDATA.NUMERO_CARGA "

	//
	//Conout( DToC(Date()) + " " + Time() + " ADROMENT - sqlVlPlt - cQuery " + cQuery ) 

Return cQuery
/*/{Protheus.doc} prtVlPlt
	Imprimi vale palete.
	@type  Static Function
	@author Everson
	@since 02/07/2020
	@version 01
	/*/
Static Function prtVlPlt(cCarga,cCliente,cDtFech,cPlaca,cMotorit,aEmb)

	//Variáveis.
	Local aArea		:= GetArea()
	Local nTotEm  	:= 0
	Local nLInicio	:= 0
	Local nVias   	:= GetMv("MV_#PALTVI",,3)
	Local nAux    	:= 1
	Local nAux2   	:= 1
	Local nLim1   	:= 132

	//
	nLin := nLInicio

	//
	For nAux := 1 To nVias 

		//
		@ nLin++, 000 PSAY Replicate("_",nLim1) 
		@ nLin++, 000 PSAY Replicate(" ",nLim1)
		@ nLin++, 000 PSAY " AD'ORO S/A" +  Replicate(" ",34) + "Ticket de Coleta de Embalagens - Expedição" + Replicate(" ",28) + " Data: " + DtoC(dDATABASE)
		@ nLin++, 000 PSAY Replicate("_",nLim1)

		//
		@ nLin,000 PSAY Replicate("-",nLim1)
		nLin++
		@ nLin,000 PSAY "Nº Carga: " + cCarga
		@ nLin,099 PSAY "Data Fechamento Carga: " + cDtFech
		nLin++
		@ nLin,000 PSAY "Placa: " + cPlaca
		nLin++
		@ nLin,000 PSAY "Motorista: " + cMotorit
		nLin++
		@ nLin,000 PSAY Replicate("-",nLim1)
		nLin++
		@ nLin,020 PSAY "Cliente" 
		@ nLin,060 PSAY "Embalagem" 
		@ nLin,117 PSAY "Qtd. Embalagens" 

		//
		nTotEm := 0
		For nAux2 := 1 To Len(aEmb)

			//
			nLin++
			@ nLin,000 PSAY cCliente
			@ nLin,055 PSAY aEmb[nAux2][1]
			@ nLin,125 Psay aEmb[nAux2][2] Picture '@E 999'
			nTotEm += aEmb[nAux2][2]

		Next nAux2

		//
		nLin++
		@ nLin,000 PSAY Replicate("-",nLim1)
		nLin++
		@ nLin,117 PSAY "Total" 
		@ nLin,125 Psay nTotEm Picture '@E 999'

		//
		nLin += 2

		@ nLin,035 PSAY "Declaro estar de acordo com as informações acima apresentadas." 

		//
		nLin += 2
		@ nLin,010 PSAY Replicate("_",30)
		@ nLin,092 PSAY Replicate("_",30)
		nLin++
		@ nLin,017 PSAY "- MOTORISTA -"
		@ nLin,099 PSAY "- CONFERENTE -"
		nLin+= 2
		@ nLin,000 PSAY Replicate("-",nLim1)
		nLin++

		//
		nLin += 5

		//
		If nLin > 60 .And. nAux < nVias
			Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
			nLin := nLInicio

		Endif

	Next nAux

	//
	RestArea(aArea)

Return Nil

/*/{Protheus.doc} u_ROMENTA0
Ticket 70142 - Substituicao de funcao Static Call por User Function MP 12.1.33
@type function
@version 1.0
@author Edvar   / Flek Solution
@since 16/03/2022
@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
/*/
Function u_ROMENTA0( uPar1, uPar2, uPar3, uPar4, uPar5, uPar6, uPar7 )
Return( vlPalete( uPar1, uPar2, uPar3, uPar4, uPar5, uPar6, uPar7 ) )

/*/{Protheus.doc} fCanhotos
Impressão de Novos Canhotos
@type function
@version 1.0
@author Antonio Domingos
@since 06/09/2022
@history Ticket 79163  - Antonio Domingos - 06/09/2022 - CANHOTO - MELHORIA

/*/
User Function fCanhotos(aImpCanhoto,cRoteiroC,cPlacaCan,cCanhoto)

	_cDoc1:=_cDoc2:=_cDoc3:=_cDoc4:=_cDoc5:= Space(9)
	_cSerie1:=_cSerie2:=_cSerie3:=_cSerie4:=_cSerie5:= Space(3)
	
	If Len(aImpCanhoto) >= 1
		_cDoc1:= Substr(aImpCanhoto[1][1],1,9)
		_cSerie1 := Substr(aImpCanhoto[1][1],11,3)
		_cCliente := aImpCanhoto[1][2]
		_cLinha21Prot:='| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO | Cliente - '+_cCliente  +'         | NF-e                    |    '
		_cLinha41Prot:='| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No.   '+_cDoc1    +'         |    '
		_cLinha51Prot:='|                     |                                                                                                                       | Serie '+_cSerie1  +'               |    '
	EndIf
	If Len(aImpCanhoto) >= 2
		_cDoc2:= Substr(aImpCanhoto[2][1],1,9)
		_cSerie2 := Substr(aImpCanhoto[2][1],11,3)
		_cCliente := aImpCanhoto[2][2]
		_cLinha22Prot:='| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO | Cliente - '+_cCliente  +'         | NF-e                    |    '
		_cLinha42Prot:='| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No.   '+_cDoc2    +'         |    '
		_cLinha52Prot:='|                     |                                                                                                                       | Serie '+_cSerie2  +'               |    '
	EndIf
	If Len(aImpCanhoto) >= 3
		_cDoc3:= Substr(aImpCanhoto[3][1],1,9)
		_cSerie3 := Substr(aImpCanhoto[3][1],11,3)
		_cCliente := aImpCanhoto[3][2]
		_cLinha23Prot:='| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO | Cliente - '+_cCliente  +'         | NF-e                    |    '
		_cLinha43Prot:='| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No.   '+_cDoc3    +'         |    '
		_cLinha53Prot:='|                     |                                                                                                                       | Serie '+_cSerie3  +'               |    '
	EndIf
	If Len(aImpCanhoto) >= 4
		_cDoc4:= Substr(aImpCanhoto[4][1],1,9)
		_cSerie4 := Substr(aImpCanhoto[4][1],11,3)
		_cCliente := aImpCanhoto[4][2]
		_cLinha24Prot:='| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO | Cliente - '+_cCliente  +'         | NF-e                    |    '
		_cLinha44Prot:='| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No.   '+_cDoc4    +'         |    '
		_cLinha54Prot:='|                     |                                                                                                                       | Serie '+_cSerie4  +'               |    
	EndIf
	If Len(aImpCanhoto) == 5
		_cDoc5:= Substr(aImpCanhoto[5][1],1,9)
		_cSerie5 := Substr(aImpCanhoto[5][1],11,3)
		_cCliente := aImpCanhoto[5][2]
		_cLinha25Prot:='| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO | Cliente - '+_cCliente  +'         | NF-e                    |    '
		_cLinha45Prot:='| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No.   '+_cDoc5    +'         |    '
		_cLinha55Prot:='|                     |                                                                                                                       | Serie '+_cSerie5  +'               |    
	EndIf
	
	_cLinha1Prot:='+_____________________________________________________________________________________________________________________________________________|                         |    '
	_cLinha2Prot:='| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO |                                                            | Nfe                     |    '
	_cLinha3Prot:='+_____________________________________________________________________________________________________________________________________________|                         |    '
	_cLinha4Prot:='| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No.   '+_cDoc1    +'         |    '
	_cLinha5Prot:='|                     |                                                                                                                       | Serie '+_cSerie1  +'               |    
	_cLinha6Prot:='|                     |                                                                                                                       |                         |    '
	_cLinha7Prot:='|                     |                                                                                                                       |                         |    '
	_cLinha8Prot:='|                     |                                                                                                                       |                         |    '
	_cLinha9Prot:='+_____________________________________________________________________________________________________________________________________________|_________________________|    '
	
	_cRecibo01 := '|                                                  |'
	_cRecibo02 := '|    Recibo de conferencia de canhotos             |'
	_cRecibo03 := '|                                                  |'
	_cRecibo04 := '|                                                  |'
	_cRecibo05 := '|       Roteiro: ' + cRoteiroC + '    **Placa**: '+cPlacaCan +'         |'
	_cRecibo06 := '|                                                  |'
	_cRecibo07 := '|                                                  |'
	_cRecibo08 := '|   Recebi os canhotos ref. NFs abaixo:            |'
	_cRecibo09 := '|                                                  |'
	_cRecibo10 := '|                                                  |'
	_cRecibo11 := '| ' + _cDoc1 + '      ' + _cDoc2 + '     ' + _cDoc3 + '           |'
	_cRecibo12 := '| ' + _cDoc4 + '      ' + _cDoc5 + '                         |'
	_cRecibo13 := '|                                                  |'
	_cRecibo14 := '| Conferente (Nome): ____________________________  |' //Everson - 18/10/2022 - ticket 81179.
	_cRecibo15 := '|                                                  |'
	_cRecibo16 := '|              Data: _______/________/___________  |' //Everson - 18/10/2022 - ticket 81179.
	_cRecibo17 := '|                                                  |'
	_cRecibo18 := '|                                                  |'
	_cRecibo19 := '|        Assinatura: ____________________________  |'
	_cRecibo20 := '|                                                  |'
	_cRecibo21 := '|                                                  |'
	_cRecibo22 := '|                                                  |'
	_cRecibo23 := '|                                                  |
	_cRecibo24 := '|                                                  |'
	_cRecibo25 := '|                                                  |'	
	_cRecibo26 := '|                                                  |'
	_cRecibo27 := '| can.' + cCanhoto + '                   Data: ' + DtoC(dDATABASE) + '    |'
	_cRecibo28 := '|__________________________________________________|'
	
	Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
	nLin:=8
	
	@ nLin++, 000 PSAY "_________________________________________________________________________________________________________________________________________________________________________________________________________________________________ "
	@ nLin++, 000 PSAY "                                                                                                                                                                        |    |                                                  |"
	@ nLin++, 000 PSAY ' ADORO S/A                                                          Relatorio de conferencia de canhotos                                                 Data: ' + DtoC(dDATABASE) + ' |    |                    ADORO  S/A                    |'      			
	@ nLin++, 000 PSAY "________________________________________________________________________________________________________________________________________________________________________|    |                                                  |"
	If Len(aImpCanhoto) >= 1
		@ nLin++, 000 PSAY _cLinha1Prot+_cRecibo01
		@ nLin++, 000 PSAY _cLinha21Prot+_cRecibo02
		@ nLin++, 000 PSAY _cLinha3Prot+_cRecibo03
		@ nLin++, 000 PSAY _cLinha41Prot+_cRecibo04
		@ nLin++, 000 PSAY _cLinha51Prot+_cRecibo05
		@ nLin++, 000 PSAY _cLinha6Prot+_cRecibo06
		@ nLin++, 000 PSAY _cLinha7Prot+_cRecibo07
		@ nLin++, 000 PSAY _cLinha8Prot+_cRecibo08
		@ nLin++, 000 PSAY _cLinha9Prot+_cRecibo09
	EndIf
	If Len(aImpCanhoto) >= 2
		@ nLin++, 000 PSAY _cLinha1Prot+_cRecibo10
		@ nLin++, 000 PSAY _cLinha22Prot+_cRecibo11
		@ nLin++, 000 PSAY _cLinha3Prot+_cRecibo12
		@ nLin++, 000 PSAY _cLinha42Prot+_cRecibo13
		@ nLin++, 000 PSAY _cLinha52Prot+_cRecibo14
		@ nLin++, 000 PSAY _cLinha6Prot+_cRecibo15
		@ nLin++, 000 PSAY _cLinha7Prot+_cRecibo16
		@ nLin++, 000 PSAY _cLinha8Prot+_cRecibo17
		@ nLin++, 000 PSAY _cLinha9Prot+_cRecibo18
	else
		@ nLin++, 000 PSAY Space(Len(_cLinha1Prot))+_cRecibo10
		@ nLin++, 000 PSAY Space(Len(_cLinha2Prot))+_cRecibo11
		@ nLin++, 000 PSAY Space(Len(_cLinha3Prot))+_cRecibo12
		@ nLin++, 000 PSAY Space(Len(_cLinha4Prot))+_cRecibo13
		@ nLin++, 000 PSAY Space(Len(_cLinha5Prot))+_cRecibo14
		@ nLin++, 000 PSAY Space(Len(_cLinha6Prot))+_cRecibo15
		@ nLin++, 000 PSAY Space(Len(_cLinha7Prot))+_cRecibo16
		@ nLin++, 000 PSAY Space(Len(_cLinha8Prot))+_cRecibo17
		@ nLin++, 000 PSAY Space(Len(_cLinha9Prot))+_cRecibo18
	EndIf
	If Len(aImpCanhoto) >= 3
		@ nLin++, 000 PSAY _cLinha1Prot+_cRecibo19
		@ nLin++, 000 PSAY _cLinha23Prot+_cRecibo20
		@ nLin++, 000 PSAY _cLinha3Prot+_cRecibo21
		@ nLin++, 000 PSAY _cLinha43Prot+_cRecibo22
		@ nLin++, 000 PSAY _cLinha53Prot+_cRecibo23
		@ nLin++, 000 PSAY _cLinha6Prot+_cRecibo24
		@ nLin++, 000 PSAY _cLinha7Prot+_cRecibo25
		@ nLin++, 000 PSAY _cLinha8Prot+_cRecibo26
		@ nLin++, 000 PSAY _cLinha9Prot+_cRecibo27
	else
		@ nLin++, 000 PSAY Space(Len(_cLinha1Prot))+_cRecibo19
		@ nLin++, 000 PSAY Space(Len(_cLinha2Prot))+_cRecibo20
		@ nLin++, 000 PSAY Space(Len(_cLinha3Prot))+_cRecibo21
		@ nLin++, 000 PSAY Space(Len(_cLinha4Prot))+_cRecibo22
		@ nLin++, 000 PSAY Space(Len(_cLinha5Prot))+_cRecibo23
		@ nLin++, 000 PSAY Space(Len(_cLinha6Prot))+_cRecibo24
		@ nLin++, 000 PSAY Space(Len(_cLinha7Prot))+_cRecibo25
		@ nLin++, 000 PSAY Space(Len(_cLinha8Prot))+_cRecibo26
		@ nLin++, 000 PSAY Space(Len(_cLinha9Prot))+_cRecibo27
	EndIf
	If Len(aImpCanhoto) >= 4
		@ nLin++, 000 PSAY _cLinha1Prot+_cRecibo28
		@ nLin++, 000 PSAY _cLinha24Prot
		@ nLin++, 000 PSAY _cLinha3Prot
		@ nLin++, 000 PSAY _cLinha44Prot
		@ nLin++, 000 PSAY _cLinha54Prot
		@ nLin++, 000 PSAY _cLinha6Prot
		@ nLin++, 000 PSAY _cLinha7Prot
		@ nLin++, 000 PSAY _cLinha8Prot
		@ nLin++, 000 PSAY _cLinha9Prot
	else
		@ nLin++, 000 PSAY Space(Len(_cLinha1Prot))+_cRecibo28
		@ nLin++, 000 PSAY Space(Len(_cLinha2Prot))
		@ nLin++, 000 PSAY Space(Len(_cLinha3Prot))
		@ nLin++, 000 PSAY Space(Len(_cLinha4Prot))
		@ nLin++, 000 PSAY Space(Len(_cLinha5Prot))
		@ nLin++, 000 PSAY Space(Len(_cLinha6Prot))
		@ nLin++, 000 PSAY Space(Len(_cLinha7Prot))
		@ nLin++, 000 PSAY Space(Len(_cLinha8Prot))
		@ nLin++, 000 PSAY Space(Len(_cLinha9Prot))
	EndIf
	If Len(aImpCanhoto) >= 5
		@ nLin++, 000 PSAY _cLinha1Prot
		@ nLin++, 000 PSAY _cLinha25Prot
		@ nLin++, 000 PSAY _cLinha3Prot
		@ nLin++, 000 PSAY _cLinha45Prot
		@ nLin++, 000 PSAY _cLinha55Prot
		@ nLin++, 000 PSAY _cLinha6Prot
		@ nLin++, 000 PSAY _cLinha7Prot
		@ nLin++, 000 PSAY _cLinha8Prot
		@ nLin++, 000 PSAY _cLinha9Prot
	EndIf
	
		/*
		@ nLin++, 000 PSAY "_________________________________________________________________________________________________________________________________________________________________________________________________________________________________ "
		@ nLin++, 000 PSAY "                                                                                                                                                                        |    |                                                  |"
		@ nLin++, 000 PSAY ' ADORO S/A                                                          Relatorio de conferencia de canhotos                                                 Data: ' + DtoC(dDATABASE) + ' |    |                    ADORO  S/A                    |'      			
		@ nLin++, 000 PSAY "________________________________________________________________________________________________________________________________________________________________________|    |                                                  |"
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|                         |    |                                                  |'
		@ nLin++, 000 PSAY  '| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO | NF-e                                                       |                         |    |    Recibo de conferencia de canhotos             |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|                         |    |                                                  |'
		@ nLin++, 000 PSAY  '| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No. '+_cDoc1    +'           |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |Serie '+_cSerie1  +'                |    |       Roteiro: ' + cRoteiroC + '    **Placa**: '+cPlacaCan +'         |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |   Recebi os canhotos ref. NFs abaixo:            |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|_________________________|    |                                                  |'
		@ nLin++, 000 PSAY "                                                                                                                                               |                        |    |                                                  |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|                         |    | ' + _cDoc1 + "      " + _cDoc2 + "     " + _cDoc3 + "           |'
		@ nLin++, 000 PSAY  '| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO | NF-e                                                       |                         |    | ' + _cDoc4 + "      " + _cDoc5 + "                         |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|                         |    |                                                  |'
		@ nLin++, 000 PSAY  '| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No. '+_cDoc2     +'           |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |Serie '+_cSerie2  +'                |    |              Data: _______/________/___________  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    | Conferente (Nome): ____________________________  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|_________________________|    |                                                  |'
		@ nLin++, 000 PSAY  '                                                                                                                                              |                         |    |        Assinatura: ____________________________  |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|                         |    |                                                  |'
		@ nLin++, 000 PSAY  '| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO | NF-e                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|                         |    |                                                  |'
		@ nLin++, 000 PSAY  '| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No. '+_cDoc3     +'           |    |                                                  |
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |Serie '+_cSerie3  +'                |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|_________________________|    |                                                  |'
		@ nLin++, 000 PSAY  '                                                                                                                                              |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|                         |    |                                                  |'
		@ nLin++, 000 PSAY  '| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO | NF-e                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|                         |    |                                                  |'
		@ nLin++, 000 PSAY  '| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No. '+_cDoc4     +'           |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |Serie '+_cSerie4  +'                |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    |                                                  |'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|_________________________|    |__________________________________________________|'
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|                         |    '
		@ nLin++, 000 PSAY  '| RECEBEMOS DA ADORO S.A. OS PRODUTOS CONSTANTES DA NOTA FISCAL INDICADA AO LADO | NF-e                                                       |                         |    '
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|                         |    '
		@ nLin++, 000 PSAY  '| DATA DE RECEBIMENTO | IDENTIFICAÇÃO E ASSINATURA DO RECEBEDOR                                                                               | No. '+_cDoc5     +'           |    '
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |Serie '+_cSerie5  +'                |    '
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    '
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    '
		@ nLin++, 000 PSAY  '|                     |                                                                                                                       |                         |    '
		@ nLin++, 000 PSAY  '+_____________________________________________________________________________________________________________________________________________|_________________________|    '
		*/
Return
/*/{Protheus.doc} zAtuPerg
	Carrega o conteúdo na variável da pergunta. 
	@type  Static Function
	@author Everson
	@since 27/03/2023
	@version 01
/*/
Static Function zAtuPerg(cPergAux, cParAux, xConteud)

	//Variáveis.
	Local aArea      := GetArea()
	Local nPosPar    := 14
	Local nLinEncont := 0
	Local aPergAux   := {}

	Default xConteud := ""

	//Se não tiver pergunta, ou não tiver ordem.
	If Empty(cPergAux) .Or. Empty(cParAux)
		Return Nil

	EndIf

	//Chama a pergunta em memória.
	Pergunte(cPergAux, .F., /*cTitle*/, /*lOnlyView*/, /*oDlg*/, /*lUseProf*/, @aPergAux)

	//Procura a posição do MV_PAR.
	nLinEncont := aScan(aPergAux, {|x| Upper(Alltrim(x[nPosPar])) == Upper(cParAux) })

	//Se encontrou o parâmetro
	If nLinEncont > 0
		//Caracter
		If ValType(xConteud) == 'C'
			&(cParAux+" := '"+xConteud+"'")

		//Data
		ElseIf ValType(xConteud) == 'D'
			&(cParAux+" := sToD('"+dToS(xConteud)+"')")

		//Numérico ou Lógico
		ElseIf ValType(xConteud) == 'N' .Or. ValType(xConteud) == 'L'
			&(cParAux+" := "+cValToChar(xConteud)+"")

		EndIf

		//Chama a rotina para salvar os parâmetros
		__SaveParam(cPergAux, aPergAux)

	EndIf

	RestArea(aArea)

Return Nil
