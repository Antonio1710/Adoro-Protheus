#include "Protheus.ch"
#include "rwmake.ch"

/*{Protheus.doc} User Function GERAP3
	Importacao de pre�o para tabela Matriz
	@type  Function
	@author Mauricio
	@since 07/03/2012
	@version 01
	@history Chamado 057846 - William Costa - 06/05/2020 - Retirado toda a referencia ao campo B1_ATIVO ou B1_ATIVO1
	@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
	@history Everson, 12/09/2022. Chamado TI - Tratamento para filial de Itapira.
*/

User Function IMPTBMAT()

	Local  _cPath

	Private _cTabela := ""
	Private _aNome := {}
	Private _aTipo := {}
	Private _aDado := {}
	/*LAYOUT DO ARQUIVO CSV A SER IMPORTADO conforme definido com o usuario:

	Delimitado por ";", com 1 linha de cabecalho
	Primeira linha sempre eh cabecalho  CODIGO,PRECO,A01,B01,C01,CMS,D01,E01,V00
	*/

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Importacao de pre�o para tabela Matriz')

	_nTamLin 	:= 200            		
	_nHdl    	:= Nil           		
	_cBuffer 	:= Space(_nTamLin+1) 	
	_nBytes  	:= 0                	
	_cDelimit	:= ";"                  
	_cPath      := ""
	_cPerg		:= PADR("IMPTBM",10," ")

	//@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
	//ValidPerg()
		
	if Pergunte(_cPerg,.T.)
		_cArq    	:= MV_PAR01      		
																								
		If MsgBox(OemToAnsi("Confirma importa��o para tabela Matriz do arquivo "+Alltrim(_cArq)+""),"ATENCAO","YESNO")
			_nHdl := fOpen(_cArq,2) 
			fClose(_nHdl)
			
			If _nHdl == -1
				Aviso( "AVISO",OemToAnsi("N�o foi poss�vel abrir o arquivo "+_cArq),{"Sair"} )
			else
				Processa({|| ImpTXTTB()})
			endif
			
		endif
	Endif

Return()

Static Function ImpTXTTB()

	//Vari�veis.
	Local nX 	:= 1
	Local nY	:= 1
	Local nI	:= 1
	Local nZZ	:= 1
	Local nYY	:= 1

	_cProduto := ""
	_nPreco   := 0.00
	_nPer1    := 0.0000
	_aEstrPro := {}
	_lcont    := .T.
	_lret     := .T.

	Dbgotop()

	ft_fUse(_cArq)

	ProcRegua(RecCount())

	ft_fGoTop()
	_nLin := 1
	_aTab := {}

	AutoGrLog("LOG ALTERACAO IMPORTACAO TABELA MATRIZ")
	AutoGrLog("--------------------------------------")
	AutoGrLog(" ")
	AutoGrLog(" ")
	
	Do While !ft_fEOF()

		_arqOk   := .T.
		_cBuffer := ft_fReadLn()
		_nCmp    := 1
		
		If _nLin == 1

			_ntot := 2
			_nfim := 0
			
			For nX := 1 to len(_cBuffer)
				//conto aqui total de colunas relativas as tabelas de preco e associo cada coluna a uma tabela de pre�o
				if _nFim > 0
					exit
				endif    	       	       
				if ";" $ _cBuffer
					_cCab := Alltrim(Substr(_cBuffer,1,At(_cDelimit, _cBuffer)-1))	          
					If nX >= 3
						AADD(_aTab,_cCab)
					Endif 	          	        	            
					_cBuffer := Substr(_cBuffer,At(";", _cBuffer)+1)
				Else
					_cCab := Alltrim(_cBuffer)                    
					AADD(_aTab,_cCab)
					_nfim ++
				endif   
			next
		
			_nTotCol := 2 + Len(_aTab)   //Totais de tabelas no arquivo
			
			_aTabDA0 := {}

			dbSelectArea("DA0")
			dbSetOrder(1)
			dbseek(FWxFilial("DA0"))

			While DA0->(!Eof()) .And. DA0->DA0_FILIAL == FWxFilial("DA0")  //pego as tabela da filial corrente aonde o programa esta sendo rodado(Assumimos que as filiais est�o iguais)
					AADD(_aTabDA0,ALLTRIM(DA0->DA0_CODTAB))
					DA0->(dbSkip())
			EndDo
			
			_aColTab := {}
		
			for nY := 1 to len(_aTab)
				_cTab := _aTab[nY]
				//_nPos := Ascan(_aTabDA0, &_cTab ) //Retorna a posi��o da tabela na sequencia do cadastro de tabelas para alimentar a tabela ZZ
				_nPos := Ascan(_aTabDA0,_cTab) //Retorna a posi��o da tabela na sequencia do cadastro de tabelas para alimentar a tabela ZZ
				AADD(_aColTab,{_cTab,_nPos})                           //na mesma sequencia.	

			next nY
				
			ft_fSkip()
			_nLin ++
			loop

		Endif
			
		for nI := 1 to _nTotCol

			_cTxtPos := Substr(_cBuffer,1,At(_cDelimit, _cBuffer)-1)
			_nVar := "_nQTD"+ALLTRIM(STR(nI))
			if nI = 1
				_cProduto    := _cTxtPos
			elseif nI = 2
				_nPreco := Val(StrTran(_cBuffer,",","."))
			else
				&_nVar := Val(StrTran(_cBuffer,",","."))
			endif		
			_cBuffer := Substr(_cBuffer,At(";", _cBuffer)+1)
			_nCmp++

		next
		
		IncProc("Importando...")

		_aValLog := {}

		DbSelectArea("ZZK")
		DbSetOrder(1)
		if dbseek(FWxFilial("ZZK") + _cProduto)

			_nPrcAnt := ZZK->ZZK_PRBASE	   

			RecLock("ZZK",.F.)

				ZZK->ZZK_PRBASE := _nPreco             
				_t := 3	         
				For nZZ := 1 to len(_aColTab)	        
					_cVar2 := "_nQTD"+ALLTRIM(STR(_t))
					_nPos := _aColTab[nZZ][2]	         
					_cCpo1 := "ZZK_COEF"+ALLTRIM(STR(_nPos))
					_cCpo2 := "ZZK_VAL"+ALLTRIM(STR(_nPos))	         
					//filial, produto, fob anterior, fob atual, tabela,preco atual, preco anterior,coeficiente atual, coeficiente anterior.
					AADD(_aValLog,{FWxFilial("ZZK"),_cProduto,_nPrcAnt,_nPreco,_aColTab[nZZ][1],&_cVar2,ZZK->&_cCpo1,_nPreco *(&_cVar2),ZZK->&_cCpo2,Substr(ZZK->ZZK_DESCRI,1,40)})	         	          	          
					ZZK->&_cCpo1 := &_cVar2                         
					ZZK->&_cCpo2 := _nPreco *(&_cVar2)              
					_t ++

				next

			MsUnlock()

		Else  
			_cBloqueado :=Posicione('SB1',1,xFilial("SB1")+_cProduto,"B1_MSBLQL")
			
			If _cBloqueado <> "1"
				RecLock("ZZK",.T.)

				ZZK->ZZK_FILIAL := FWxFilial("ZZK")
				ZZK->ZZK_PRODUT := _cProduto
				ZZK->ZZK_PRBASE := _nPreco
				ZZK->ZZK_DESCRI := Posicione('SB1',1,xFilial("SB1")+_cProduto,"B1_DESC")
				ZZK->ZZK_UNIDAD := Posicione('SB1',1,xFilial("SB1")+_cProduto,"B1_UM")
				_nPrcAnt := 0	     
				_t := 3
				For nZZ := 1 to len(_aColTab)
					_cVar2 := "_nQTD"+ALLTRIM(STR(_t))
					_nPos := _aColTab[nZZ][2]


					_cCpo1 := "ZZK_COEF"+ALLTRIM(STR(_nPos))
					_cCpo2 := "ZZK_VAL"+ALLTRIM(STR(_nPos))
		//	          AADD(_aValLog,{"02",_cProduto,_aColTab[nZZ][1],_nPrcAnt,_nPreco,&_cVar2,0,_nPreco *(&_cVar2),0,_nPreco *(&_cVar2),Substr(ZZK->ZZK_DESCRI,1,40)})  
					AADD(_aValLog,{FWxFilial("ZZK"),Alltrim(_cProduto)+"*",_nPrcAnt,_nPreco,_aColTab[nZZ][1],&_cVar2,ZZK->&_cCpo1,_nPreco *(&_cVar2),ZZK->&_cCpo2,Substr(ZZK->ZZK_DESCRI,1,40)})	         	          	          
					ZZK->&_cCpo1 := &_cVar2
					ZZK->&_cCpo2 := _nPreco *(&_cVar2)
					_t ++

				next

				MsUnlock()   

			else    
					AADD(_aValLog,{FWxFilial("ZZK"),_cProduto,0,0,"O produto esta inativo no cadastro B1_MSBLQL="+_cBloqueado,0,0,0,0," ----> NAO IMPORTADO !!!"})	         	          	          
			endif

		Endif
		
		//gero o log
		If len(_aValLog) > 0
		_cLog := ""
		For nYY := 1 to len(_aValLog)
			_cFil := _aValLog[nYY][1]
			If nYY == 1
				_clog += " Produto: "+_aValLog[nYY][2]+" "+_aValLog[nYY][10]+" Preco de: "+transform(_aValLog[nYY][3],"@E 9,999.99")+;
						" para: "+transform(_aValLog[nYY][4],"@E 9,999.99")+" Tab.: "+_aValLog[nYY][5]+" % de: "+transform(_aValLog[nYY][7],"@E 99.9999")+" para: "+transform(_aValLog[nYY][6],"@E 99.9999") 
			Else
				If _aValLog[nYY - 1][2] == _aValLog[nYY][2]
					_cLog += " Tab.: "+_aValLog[nYY][5]+;
							" % de: "+transform(_aValLog[nYY][7],"@E 99.9999")+" para: "+transform(_aValLog[nYY][6],"@E 99.9999") 	             
				Else      
					_cLog += CHR(13)+CHR(10)                            
					_cLog := " Produto: "+_aValLog[nYY][2]+" "+_aValLog[nYY][10]+" Preco de: "+transform(_aValLog[nYY][3],"@E 9,999.99")+;
							" para: "+transform(_aValLog[nYY][4],"@E 9,999.99")+" Tab.: "+_aValLog[nYY][5]+" % de: "+transform(_aValLog[nYY][7],"@E 99.9999")+" para: "+transform(_aValLog[nYY][6],"@E 99.9999")	          
				Endif
			Endif     	          
		Next nYY
		_cLog += CHR(13)+CHR(10) 
		AutoGrLog(_cLog)
			
		Endif
		
		ft_fSkip()
		_nLin ++
		
	End
	_cFileLog := Left(MV_PAR01,At(".",MV_PAR01)-1)+".LOG"
	_cFileLog := Alltrim(Substr(_cFileLog,RAt("\",_cFileLog)+1,20))
	_cPath    := Substr(MV_PAR01,1,RAt("\",MV_PAR01))
	MostraErro(_cPath,_cFileLog)	
	msgInfo("Processamento concluido com sucesso!")

Return()

//Static Function ValidPerg
//
//	PutSx1(_cPerg,"01","Importar do Arquivo TXT ?", "Importar do Arquivo  TXT ?", "Importar do Arquivo  TXT ?", "mv_ch1","C",50,0,0,"G",""         ,"","","","mv_par01","","","","","","","","","","","","","","","","","","","")
//
//Return
