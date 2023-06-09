#Include 'Protheus.ch'
#Include 'Topconn.ch'

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADEST012P � Autor � �verson           � Data �  23/08/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o para validar se um produto pode ou n�o ser inativo, ���
���          � dependendo do saldo de estoque. Se o saldo for diferente   ���
���          � de 0, n�o deixar o usu�rio prosseguir com o bloqueio.      ���
���          � projetos/investimentos(Requisicoes e Pedidos de Compras)   ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ADEST012P(nOpc,cCodProduto,nStatus) // U_ADEST012P(3,SB1->B1_COD,M->B1_MSBLQL)
	
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local lRet			:= .T.
	Local i			:= 1
	Local xPulaLinha	:= Chr(13) + Chr(10)
	Local cMsg			:= "N�o � poss�vel bloquear o produto #PROD, pois este possui saldo em estoque diferente de zero." + xPulaLinha + xPulaLinha
	
	Private aRetorno	:= {}
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Fun��o para validar se um produto pode ou n�o ser inativo, dependendo do saldo de estoque. Se o saldo for diferente de 0, n�o deixar o usu�rio prosseguir com o bloqueio. projetos/investimentos(Requisicoes e Pedidos de Compras)')
	
	//Valida status selecionado - 1-Bloqueio / 2-Desbloqueio.
	If Alltrim(cValToChar(nStatus)) == "2"
		Return lRet
		
	EndIf
	
	//Verifica a op��o de c�lculo selecionada.
	If     nOpc == 1 //C�lculo pela fun��o SaldoSB2.
		MsAguarde({||obterSldSaldoSB2(cCodProduto)},"Aguarde(ADEST012P)","Verificando estoque (SaldoSB2)")
	
	ElseIf nOpc == 2 //C�lculo pela soma dos valores da tabela SB2.
		MsAguarde({||obterSldSB2(cCodProduto)},"Aguarde(ADEST012P)","Verificando estoque (Tab SB2)")
		
	ElseIf nOpc == 3 //C�lculo pela fun�ao CalcEst
		MsAguarde({||obterSldCalcEst(cCodProduto)},"Aguarde(ADEST012P)","Verificando estoque (CalcEst)")
		
	Else
		MsgStop("Op��o de c�lculo de saldo de estoque inv�lida.","Fun��o ADEST012P")
		lRet := .F.
		 
	EndIf
	
	//Valida retorno da fun��o obterSldSaldoSB2.
	If Len(aRetorno) > 0
		
		//
		lRet := .F.
		
		//Monta mensagem.
		cMsg := StrTran(cMsg,"#PROD",Alltrim(cValToChar(cCodProduto)) + "-" + Alltrim(cValToChar(SB1->B1_DESC)))
		
		For i := 1 To Len(aRetorno)
			cMsg += cValToChar(aRetorno[i][1]) + " / Armaz�m: " + cValToChar(aRetorno[i][2]) + " | Saldo: " +;
			Transform(aRetorno[i][3],"@E 999,999,999.999") + xPulaLinha
			
		Next i
		
		MsgStop(cMsg,"Fun��o ADEST012P")
	
	EndIf
	
	RestArea(aArea)
	
Return lRet
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADEST012P � Autor � �verson           � Data �  24/08/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o devolve o saldo do produto pela fun��o SaldoSB2()   ���
���          � (fun��o calcula o saldo atual do produto (do Arquivo SB2), ���
���          � descontando os valores empenhados, reservados, etc).       ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function obterSldSaldoSB2(cCodProduto)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local nSaldo		:= 0
	Local aFiliais	:= obterFiliais()
	Local i			:= 1
	Local cTipoProd	:= ""
	
	//Remove espa�os em branco.
	cCodProduto := Alltrim(cValToChar(cCodProduto))
	
	//Obt�m o grupo do produto.
	cTipoProd := Alltrim(cValToChar(Posicione("SB1",1,xFilial("SB1") + cCodProduto,"B1_TIPO")))
	
	For i := 1 To Len(aFiliais)
	
		//Busca o c�digo do produto na tabela SB2.
		DbSelectArea("SB2")
		SB2->(DbSetOrder(1))
		SB2->(DbGoTop())
		If ! SB2->(DbSeek(Alltrim(cValToChar(aFiliais[i][1])) + cCodProduto))
			//MsgStop("N�o foi poss�vel localizar o produto " + cCodProduto + " - Filial " + Alltrim(cValToChar(aFiliais[i][1])) +;
					 //" nos registros de saldos f�sicos e financeiros (SB2).","Fun��o obterSldSaldoSB2")
			Loop
			
		EndIf
		
		//Obt�m o saldo do produto em todos os armaz�ns.
		While Alltrim(cValToChar(SB2->B2_COD)) == cCodProduto .And. ! SB2->(Eof())
			nSaldo := Val(cValToChar(SaldoSb2()))
			
			//Valida tipo do produto com o armaz�m e o saldo.
			If !(cTipoProd == "PA" .And. Alltrim(cValToChar(SB2->B2_LOCAL)) == "10") .And. nSaldo <> 0
			
				//Atribui os valores � vari�vel de retorno.
				Aadd(aRetorno,{Alltrim(cValToChar(aFiliais[i][1])) + "-" + Alltrim(cValToChar(aFiliais[i][2])),;
					            Alltrim(cValToChar(SB2->B2_LOCAL)),nSaldo})
			
			EndIf
			
			SB2->(DbSkip())
			
		EndDo
		
		DbCloseArea("SB2")
		
	Next i
	
	RestArea(aArea)
	
Return Nil
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADEST012P � Autor � �verson           � Data �  24/08/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna saldo em saldo pelo saldo total na SB2.            ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function obterSldSB2(cCodProduto)
	
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local cQuery		:= ""
	Local aFiliais	:= obterFiliais()
	Local cNomeFilial	:= ""
	Local nPosFil		:= 0
	Local cTipoProd	:= ""
	
	//Remove espa�os em branco.
	cCodProduto := Alltrim(cValToChar(cCodProduto))
	
	//Obt�m o grupo do produto.
	cTipoProd := Alltrim(cValToChar(Posicione("SB1",1,xFilial("SB1") + cCodProduto,"B1_TIPO")))
	
	//Monta script sql.
	cQuery	:= ""
	cQuery += " SELECT  " 
	cQuery += " *  " 
	cQuery += " FROM  " 
	cQuery += " " + RetSqlName("SB2") + " AS SB2 " 
	cQuery += " WHERE " 
	cQuery += " SB2.D_E_L_E_T_ = '' " 
	cQuery += " AND B2_COD = '" + cCodProduto + "' " 
	cQuery += " AND B2_QATU <> 0 "
	
	If Select("SALDO_SB2") > 0
		SALDO_SB2->(DbCloseArea())
		
	EndIf
	
	//Executa consulta no BD.
	TcQuery cQuery New Alias "SALDO_SB2"
	DbSelectArea("SALDO_SB2")
	SALDO_SB2->(DbGoTop())
	
	//Percorre a tabela SB2.
	While ! SALDO_SB2->(Eof())
		
		//Valida a quantidade atual do produto.
		If !(cTipoProd == "PA" .And. Alltrim(cValToChar(SALDO_SB2->B2_LOCAL)) == "10") .And. SALDO_SB2->B2_QATU <> 0
			
			//Obt�m o nome da filial.
			cNomeFilial := ""
			nPosFil := Ascan(aFiliais,{|x| AllTrim(cValToChar(x[1])) == Alltrim(cValToChar(SALDO_SB2->B2_FILIAL))})
			
			If nPosFil > 0
				cNomeFilial := aFiliais[nPosFil][2]
				
			EndIf
			
			//Adiciona os dados � vari�vel de retorno.
			Aadd(aRetorno,{;
								Alltrim(cValToChar(SALDO_SB2->B2_FILIAL)) + "-" + Alltrim(cValToChar(cNomeFilial)),;
								Alltrim(cValToChar(SALDO_SB2->B2_LOCAL)),;
								Val(cValToChar(SALDO_SB2->B2_QATU));
							})
		
		EndIf
		
		SALDO_SB2->(DbSkip())
		
	EndDo
	
	DbCloseArea("SALDO_SB2")
	
	RestArea(aArea)
	
Return Nil
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADEST012P � Autor � �verson           � Data �  24/08/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Retorna o saldo do produto pela fun��o CalcEst()           ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function obterSldCalcEst(cCodProduto)
	
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local aEstoque	:= {}
	Local aFiliais	:= obterFiliais()
	Local aArmazens	:= obterLocEst()
	Local i			:= 1
	Local w			:= 1
	Local cFilBkp		:= cFilAnt
	
	//Obt�m o grupo do produto.
	cTipoProd := Alltrim(cValToChar(Posicione("SB1",1,xFilial("SB1") + cCodProduto,"B1_TIPO")))
			
	//Corre vetor de filiais.
	For i := 1 To Len(aFiliais)
		
		//Altera a filial do sistema.
		cFilAnt := aFiliais[i][1]
		
		//Corre vetor de armazens.
		For w := 1 To Len(aArmazens)
			
			//Valida tipo do produto com o armaz�m.
			If !(cTipoProd == "PA" .And. Alltrim(cValToChar(aArmazens[w][1])) == "10")
			
				//Executa a fun��o CalcEst.
				aEstoque := CalcEst(cCodProduto,aArmazens[w][1],dDataBase + 1, aFiliais[i][1])	
				
				//Verifica se o saldo � diferente de 0.
				If aEstoque[1] <> 0
					Aadd(aRetorno,{;
										Alltrim(cValToChar(aFiliais[i][1])) + "-" + Alltrim(cValToChar(aFiliais[i][2])),;
										Alltrim(cValToChar(aArmazens[w][1])),;
										Val(cValToChar(aEstoque[1]));
									})
								
				EndIf
			
			Endif
			
		Next w
		
	Next i
	
	//Volta a filial em que o usu�rio est� logado.
	cFilAnt := cFilBkp
	
	RestArea(aArea)
	
Return Nil
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADEST012P � Autor � �verson           � Data �  23/08/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o obt�m os locais de armazenagem.                     ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function obterLocEst()
	
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aArea	:= GetArea()
	Local aLocais	:= {}
	
	DbSelectArea("NNR")
	NNR->(DbSetOrder(1))
	While ! NNR->(Eof())
		
		Aadd(aLocais,{NNR->NNR_CODIGO})
		
		NNR->(DbSkip())
		
	EndDo 
	
	DbCloseArea("NNR")
	
	RestArea(aArea)
	
Return aLocais
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADEST012P � Autor � �verson           � Data �  24/08/2016  ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o obt�m as filiais da empresa corrente.               ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function obterFiliais()
	
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aAreaSM0	:= GetArea("aAreaSM0")
	Local aRetorno	:= {}
	
	//Obt�m os c�digos das filiais da empresa.
	DbSelectArea("SM0")
	SM0->(DbGoTop())
	While SM0->(!Eof() .And. AllTrim(SM0->M0_CODIGO) == AllTrim(cEmpAnt))
		
		Aadd(aRetorno,{AllTrim(SM0->M0_CODFIL),AllTrim(SM0->M0_FILIAL)}) // @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabiliza��o pos golive migra��o dicion�rio dados
	    
	    SM0->(DbSkip())
	     
	EndDo

	RestArea(aAreaSM0)
	
Return aRetorno
