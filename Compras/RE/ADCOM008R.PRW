#Include "Protheus.ch"
#Include "Topconn.ch"
#Include 'AP5mail.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADCOM008R � Autor � Everson 			 � Data �  05/05/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � Envio de relat�rio.                                        ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
���Adriana     �24/05/2019�TI-Devido a substituicao email para shared     ���
���            �          �relay, substituido MV_RELACNT p/ MV_RELFROM    ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADCOM008R() // U_ADCOM008R()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������	
	Local cEmp 		:= "01"
	Local cFil 		:= "02"
	
	//Inicia o ambiente.
	RPCSetType(3)
	RpcSetEnv(cEmp,cFil,,,,GetEnvServer(),{ })

		logZBN("1") //Log in�cio.
		U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

		relCompras()

		logZBN("2") //Log fim.

	//Fecha o ambiente.
	RpcClearEnv()

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �relCompras� Autor � Everson 			 � Data �  05/05/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � Envio de relat�rio.                                        ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function relCompras()
	
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������	
	Local aArea		:= GetArea()
	Local aUsuarios	:= {}
	Local cQuery	:= ""
	Local aDados	:= {}
	Local cCodUser	:= ""
	Local aDados	:= {}
	Local cCNPJFor	:= ""
	Local cDesCPag	:= ""
	Local cComprador:= ""
	
	//
	cQuery := scripSCR()
	
	If Select("DADOS_SCR") > 0
		DADOS_SCR->(DbCloseArea())
		
	EndIf
	
	TcQuery cQuery New Alias "DADOS_SCR"
	DbSelectArea("DADOS_SCR")
	DADOS_SCR->(DbGoTop())
	
	If DADOS_SCR->(Eof())
		Return Nil
		
	EndIf
	
	While ! DADOS_SCR->(Eof())
		
		cCodUser := DADOS_SCR->CR_USER
		
		cDesCPag  := Posicione("SE4",1,xFilial("SE4") + Alltrim(cValToChar(DADOS_SCR->C7_COND)),"E4_DESCRI" )
		cComprador:= Posicione("SY1",3,Alltrim(cValToChar(DADOS_SCR->CR_FILIAL)) + Alltrim(cValToChar(DADOS_SCR->C7_USER)),"Y1_NOME")
		
		Aadd(aDados,{;
				DADOS_SCR->CR_FILIAL,; 			//1 - Filial.
				DADOS_SCR->C7_EMISSAO,;			//2 - Data do pedido.
				DADOS_SCR->C7_XHORA,; 			//3 - Hora de inclus�o do pedido.
				DADOS_SCR->CR_NUM,;				//4 - N�mero d pedido.
				DADOS_SCR->A2_CGC,; 			//5 - CNPJ do fornecedor.
				Alltrim(cValToChar(DADOS_SCR->A2_NOME)),; // 6 - Fornecedor.
				cDesCPag,;						//7 - Condi��o de pagamento.
				DADOS_SCR->C7_DATPRF,;			//8 - Data de entrega.
				GetMv("MV_MOEDA" + Alltrim(cValToChar(DADOS_SCR->C7_MOEDA))),;//9 - Moeda.
				DADOS_SCR->CR_TOTAL,; 			//10 - Total do pedido.
				DADOS_SCR->C7_PROJETO,; 		//11 - Investimento.
				cComprador,; 					//12 - Comprador.
				DADOS_SCR->CR_USER;				//13 - Usu�rio.
		})
		
		DADOS_SCR->(DbSkip())
		
		If cCodUser <> DADOS_SCR->CR_USER
			prepEmail(aDados)
			aDados	:= {}
			
		EndIf
		
	EndDo
	
	RestArea(aArea)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �prepEmail         � Autor � Everson � Data �  05/05/2017    ���
�������������������������������������������������������������������������͹��
���Descricao �Prepara e-mail para ser enviado.                            ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function prepEmail(aDados)
	
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local i			:= 1
	Local x			:= 1
	Local cEmail	:= ""
	Local cAssunto	:= "Pedidos de Compra Pendentes de Aprova��o"
	Local cBuffer	:= ""
	Local cAtach	:= ""
	Local aUsuario	:= {}
	Local cNmUser	:= ""
	Local cFilNm	:= ""
	Local cPrazoPag	:= ""
	Local aCondPag	:= {}
	Local nMaxAprov	:= 0
	Local aProvadores	:= {}
	Local nNumAprov	:= 0
	Local cFxCor	:= ""
	Local cFxEnt	:= ""
	Local cCC		:= ""
	
	//Obt�m informa��es do usu�rio.
	//cEmail 		:= "everson.silva@adoro.com.br;eduardo.santamaria@adoro.com.br"
	cEmail      := Alltrim(cValToChar(UsrRetMail(Alltrim(cValToChar(aDados[1][13])))))
	
	//>>>>>>>>>>>>>>>>>> REMOVER IF, DEPOIS DE EFETUAR VALIDA��O <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	If Alltrim(cValToChar(aDados[1][13])) <> "001657" .And. Alltrim(cValToChar(aDados[1][13])) <> "000605"
		RestArea(aArea)
		Return Nil
		
	EndIf
	
	//cEmail 		:= "everson.silva@adoro.com.br"

	//
	nMaxAprov	:= maxNvAprv(Alltrim(cValToChar(aDados[1][13])))
	//cNmUser		:= cValToChar(UserRetname(Alltrim(cValToChar(aDados[1][13]))))
	cNmCompl	:= cValToChar(UsrFullName(Alltrim(cValToChar(aDados[1][13]))))

	//Monta html.
	cBuffer := "<!DOCTYPE hmtl>"
	cBuffer += "<html>"
	cBuffer += "<head>"
	cBuffer += "<meta charset='UTF-8'>"
	cBuffer += "<style>"
	cBuffer += "body{width:98%;background-color: #fdfdfd; color:#28377c;background-color:#fdfdfd;}"
	cBuffer += "td {border-bottom: 1px solid white;padding-left:5px;padding-right:5px;padding-top:2px;}"
	cBuffer += "hr{border: 0 0 1px 0 0 solid #28377c;}"
	cBuffer += ".cabec{border-right: 1px solid white;}"
	cBuffer += "p{margin:0px; padding:0px; border:0px;}"
	cBuffer += "</style>"
	cBuffer += "</head>"
	cBuffer += "<body>"
	cBuffer += "<p style='color:black;'><strong>Ol�, " + Capital(Lower(Substr(cNmCompl,1,At(" ",cNmCompl)))) + ". Segue relat�rio de pedidos de compra pendentes de aprova��o.</strong></p>"
	cBuffer += "<br/>"

	cBuffer += "<div style='margin: 0 auto;width: 100%;padding: 10px;font-size: 8px'>"
	cBuffer += "<table style='border-collapse: collapse;background-color:#f7be62;border: 1px solid white;border-radius: 10px 0 0 0;'>"
	cBuffer += "<tr style='border: 1px solid white;border-radius: 10px 0 0 0;'><td colspan='2'style='background-color: #96191d;color: white;text-align: left;border-radius: 10px 0 0 0; border-bottom: 1px solid white'>Legenda</td></tr>"
	cBuffer += "<tr><td>Dt. entrega menor que Dt. vigente</td><td style='background-color:red;color:black;'>Vermelho</td></tr>"
	cBuffer += "<tr><td>Dt. entrega igual a Dt. vigente</td><td style='background-color:yellow;color:black;'>Amarelo</td></tr>"
	cBuffer += "<tr><td>Dt. entrega maior que Dt. vigente</td><td style='background-color:green;color:black;'>Verde</td></tr>"
	cBuffer += "</table>"
	cBuffer += "<br/>
	
	cBuffer += "<table  style='width:600px;border-collapse: collapse;padding:10px;background-color:#f7be62;border: 1px solid white;border-radius: 10px 15px 0 0;'>"
	cBuffer += "<tr><td style='background-color: #96191d;color: white;text-align: left;border-radius: 10px 0 0 0; border-bottom: 1px solid white'>Gerado em: </td><td style='text-align: left; border-bottom: 1px solid white'>" + DToC(Date()) + " - " + Substr(cValToChar(Time()),1,8) + "</td></tr>"
	cBuffer += "<tr><td style='background-color: #96191d; color: white;text-align: left; border-bottom: 1px solid white'>Aprovador: </td><td style='text-align: left; border-bottom: 1px solid white'>" + Alltrim(cValToChar(aDados[1][13])) + "-" + cNmCompl + "</td></tr>"
	cBuffer += "</table>"
	
	cBuffer += "<table style='width:100%;padding-left: 5px;background-color:#f7be62;border: 1px solid white;border-radius: 0 15px 15px 15px;padding-right: 5px;padding-bottom:10px;padding-top:5px'>"
	cBuffer += "<tr>"
	cBuffer += "<td style='border: 0px'>"
	
	cBuffer += "<table style='width:100%;border-collapse: collapse;border-bottom: 1px solid white;font-size:small;'>"
	
	cBuffer += "<tr>"
	cBuffer += "<td style='color:#28377c;background-color:#fdfdfd;text-align:center;font-size:22px;font-weight:bold;border-radius: 10px 0 0 0;' colspan='12'>Pedidos de Compra Pendentes de Aprova��o</td>"
	cBuffer += "<td style='text-align:center;border-collapse: collapse;background-color: #96191d; color: white;border-bottom: 1px solid white;border-right: 0px solid white;border-radius: 0 10px 0 0;' colspan='" + cValToChar(nMaxAprov) + "'>N�veis de Aprova��o</td>"
	cBuffer += "</tr> "
	
	cBuffer += "<tr style='border-collapse: collapse;background-color: #96191d; color: white;'>"
	cBuffer += "<td class='cabec' style='text-align:center'>Filial</td>"
	cBuffer += "<td class='cabec' style='text-align:center'>Dt. Pedido</td>"
	cBuffer += "<td class='cabec' style='text-align:center'>Hr. Pedido</td>"
	cBuffer += "<td class='cabec' style='text-align:center'>Pedido</td>" 
	//cBuffer += "<td class='cabec' style='text-align:center'>CNPJ</td>" 
	cBuffer += "<td class='cabec' style='text-align:center'>Fornecedor</td>"
	cBuffer += "<td class='cabec' style='text-align:center'>Cond. Pag.</td>"
	cBuffer += "<td class='cabec' style='text-align:center'>Dt. Entrega</td>"
	cBuffer += "<td class='cabec' style='text-align:center'>Moeda</td>"  
	cBuffer += "<td class='cabec' style='text-align:center'>Total</td>"
	cBuffer += "<td class='cabec' style='text-align:center'>Invest.</td>"
	cBuffer += "<td class='cabec' style='text-align:center'>Comprador</td>"
	cBuffer += "<td class='cabec' style='text-align:center'>Centro de Custo</td>"
	
	//Adiciona campos de n�veis de aprova��o.
	For i := 1 To nMaxAprov
	
		If i == nMaxAprov
			cBuffer += "<td style='text-align:center'>Nv" + cValToChar(i) + "</td>"
		
		Else
			cBuffer += "<td class='cabec' style='text-align:center'>Nv" + cValToChar(i) + "</td>"
			
		EndIf
		
	Next i
	
	cBuffer += "</tr>"
	
	For i := 1 To Len(aDados)
		
		cFornecedor	:= Alltrim(cValToChar(aDados[i][6]))
		cTotal		:= Transform(Val(cValToChar(aDados[i][10])),"@E 999,999,999.99")
		cFilNm		:= Alltrim(cValToChar(FWFilialName(cEmpAnt,Alltrim(cValToChar(aDados[i][1])),1)))
		
		//Obt�m os prazos de pagamento da condi��o de pagamento.
	   aCondPag  := CondPag(cTotal,Alltrim(cValToChar(aDados[i][7])))
/*	   cPrazoPag := ""
	   For x := 1 To Len(aCondPag)
			cPrazoPag += cValToChar(aCondPag[x][1]) + " " 
			
	   Next x*/
	   
	    cFxCor := ""
	   	If (i%2) == 0
	   		cFxCor := ""
	   		
	   	Else
	   		cFxCor := " style='background-color:#f7cd8a;' "
	   		
	   	EndIf
		
		cBuffer += " <tr " + cFxCor + ">"
		
		cBuffer += " <td>" + Alltrim(cValToChar(aDados[i][1])) + "-" + cFilNm + "</td>" //Filial.
		cBuffer += " <td>" + Alltrim(cValToChar(aDados[i][2])) + "</td>"
		cBuffer += " <td>" + Alltrim(cValToChar(aDados[i][3])) + "</td>"
		cBuffer += " <td>" + Alltrim(cValToChar(aDados[i][4])) + "</td>"
		//cBuffer += " <td>" + Alltrim(cValToChar(aDados[i][5])) + "</td>"
		cBuffer += " <td>" + cFornecedor + "</td>"
		cBuffer += " <td>" + Alltrim(cValToChar(aDados[i][7])) + "</td>"
		
		If CToD(cValToChar(aDados[i][8])) < Date()
			cFxEnt := " style='background-color:red;color:black;' "
			
		ElseIf CToD(cValToChar(aDados[i][8])) == Date()
			cFxEnt := " style='background-color:yellow;color:black;' "
			
		Else
			cFxEnt:= " style='background-color:green;color:black;' "
			
		EndIf
		
		//Obt�m os centros de custo.
		cCC := obtCC(Alltrim(cValToChar(aDados[i][1])),Alltrim(cValToChar(aDados[i][4])))
		
		cBuffer += " <td " + cFxEnt + ">" + Alltrim(cValToChar(aDados[i][8])) + "</td>"
		cBuffer += " <td>" + Alltrim(cValToChar(aDados[i][9])) + "</td>"
		cBuffer += " <td style='text-align:right;'>" + Alltrim(cValToChar(cTotal)) + "</td>"
		cBuffer += " <td>" + Alltrim(cValToChar(aDados[i][11])) + "</td>"
		cBuffer += " <td>" + Alltrim(cValToChar(aDados[i][12])) + "</td>"
		cBuffer += " <td>" + cCC + "</td>"
		
		//
		aProvadores := obtAprovadores(Alltrim(cValToChar(aDados[1][13])),Alltrim(cValToChar(aDados[i][4])))
		nNumAprov	:= Len(aProvadores)
		//
		For x := 1 To Len(aProvadores)
			
			cFxCor := ""
			If Alltrim(cValToChar(aDados[1][13])) == Alltrim(cValToChar(aProvadores[x][2]))
				cFxCor := " style='background-color:#28377c;color:white;' "
				  
			Else
				cFxCor := ""
				
			Endif
			
			cBuffer += "<td " + cFxCor + " >"
			cBuffer += "<p>" + Alltrim(cValToChar(aProvadores[x][3])) + "</p>"
			
			If ! Empty(Alltrim(cValToChar(aProvadores[x][4])))
			
				cBuffer += "<p> Dt. Lib: " + DToC(SToD(Alltrim(cValToChar(aProvadores[x][4])))) + "</p>"
				cBuffer += "<p> Hr. Lib: " + Alltrim(cValToChar(aProvadores[x][5])) + "</p>"
			
			EndIf
			
			cBuffer += "</td>"
		
		Next x
		//Iif(.T.,MsgAlert(cValToChar(nNumAprov) + " " + Alltrim(cValToChar(aDados[1][13])) + " " + Alltrim(cValToChar(aDados[i][4])) + " -- " + cValToChar(nMaxAprov) ),Nil)
		//
		If  (nMaxAprov > nNumAprov)
			
			For x := 1 To (nMaxAprov - nNumAprov)
				cBuffer += "<td></td>"
				
			Next x
			
		EndIf
		
		cBuffer += " </tr>"
	
	Next i
		
	cBuffer += "</table>"
	cBuffer += "</td>"
	cBuffer += "</tr>"
	cBuffer += "</table>"
	cBuffer += "</div>"
	cBuffer += "</body>"
	cBuffer += "</html>"
	
	//Enviar e-mail.
	enviarEmail(cAssunto,cBuffer,cEmail,cAtach)
	
	//
	RestArea(aArea)

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �obtCC             � Autor � Everson � Data �  16/05/2017    ���
�������������������������������������������������������������������������͹��
���Descricao �Obt�m os centros de custo do pedido de compra.              ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function obtCC(cFil,cNum)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local aArea	 := GetArea()
	Local cQuery := ""
	Local cCC	 := ""
	Local aCC	 := {}
	//Iif(.T.,MsgAlert(cFil + " " + cNum),Nil)
	//
	cFil := Alltrim(cValToChar(cFil))
	cNum := Alltrim(cValToChar(cNum))
	
	cQuery := " SELECT C7_CC FROM " + RetSqlName("SC7") + " (NOLOCK) AS SC7 WHERE SC7.D_E_L_E_T_ = '' AND C7_FILIAL = '" + cFil + "' AND C7_NUM = '" + cNum + "' "
	
	//
	If Select("CC_SC7") >0
		CC_SC7->(DbCloseArea())
		
	EndIf
	
	//
	TcQuery cQuery New Alias "CC_SC7"
	
	DbSelectArea("CC_SC7")
	CC_SC7->(DbGoTop())
	While ! CC_SC7->(Eof())
	
		If Ascan(aCC,{|x| Alltrim(cValToChar(x[1])) == Alltrim(cValToChar(CC_SC7->C7_CC)) }) == 0
	
		Aadd(aCC,{Alltrim(cValToChar(CC_SC7->C7_CC))})
		
		EndIf
		
		CC_SC7->(DbSkip())
	EndDo
	DbCloseArea("CC_SC7")
	
	//
	For i := 1 To Len(aCC)
		cCC += Alltrim(cValToChar(aCC[i][1])) + " | "
		
	Next i
	
	cCC := Substr(cCC,1,Len(cCC) -2)

	RestArea(aArea)
	
Return cCC
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �maxNvAprv         � Autor � Everson � Data �  08/05/2017    ���
�������������������������������������������������������������������������͹��
���Descricao �Obt�m o n�mero m�ximo de n�vel de aprova��o.                ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function maxNvAprv(cUsuario)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local cQuery 	:= ""
	Local nNum		:= 0
	
	cUsuario := Alltrim(cValToChar(cUsuario))
	
	cQuery := ""
	cQuery := " SELECT MAX(CR_NIVEL) AS CR_NIVEL FROM " + RetSqlName("SCR") + " (NOLOCK) AS SCR WHERE SCR.D_E_L_E_T_ = '' AND CR_FILIAL+CR_NUM IN "
	cQuery += " ( "
	cQuery += " SELECT CR_FILIAL+CR_NUM AS CR_NIVEL FROM " + RetSqlName("SCR") + " (NOLOCK) AS SCR WHERE SCR.D_E_L_E_T_ = '' AND CR_USER = '" + cUsuario + "' AND CR_STATUS = '02' "
	cQuery += " ) "
	
	If Select("NR_NV") > 0
		NR_NV->(DbCloseARea())
		
	EndIf
	
	TcQuery cQuery New Alias "NR_NV"
	DbSelectArea("NR_NV")
		nNum := Val(cValToChar(NR_NV->CR_NIVEL))
	DbCloseArea("NR_NV")
	
Return nNum
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �obtAprovadores    � Autor � Everson � Data �  08/05/2017    ���
�������������������������������������������������������������������������͹��
���Descricao �Obt�m aprovadores.                                          ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function obtAprovadores(cUsuario,cPedido)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local cQuery	:= ""
	Local aAporv	:= {}
	Local cNmCompl	:= ""
	Local aNmCompl	:= {}
	
	//
	cUsuario := Alltrim(cValToChar(cUsuario))
	cPedido	 := Alltrim(cValToChar(cPedido))
	
	//
	cQuery := ""
	cQuery := " SELECT CR_NIVEL, CR_USER, CR_DATALIB, CR_XHORA FROM " + RetSqlName("SCR") + " (NOLOCK) AS SCR WHERE SCR.D_E_L_E_T_ = '' AND CR_FILIAL+CR_NUM IN "
	cQuery += " ( "
	cQuery += " SELECT CR_FILIAL+CR_NUM AS CR_NIVEL FROM " + RetSqlName("SCR") + " (NOLOCK) AS SCR WHERE SCR.D_E_L_E_T_ = '' "
	cQuery += " AND CR_USER = '" + cUsuario + "' AND CR_STATUS = '02' AND CR_NUM = '" + cPedido + "' "
	cQuery += " ) "
	cQuery += " ORDER BY CR_NIVEL "
	
	If Select("NR_NV") > 0
		NR_NV->(DbCloseARea())
		
	EndIf
	
	TcQuery cQuery New Alias "NR_NV"
	DbSelectArea("NR_NV")
	While ! NR_NV->(Eof())
	
		cNmCompl := cValToChar(UsrFullName(Alltrim(cValToChar(NR_NV->CR_USER))))
		
		aNmCompl := StrtoKarr(cNmCompl," ")
		
		Aadd(aAporv,{NR_NV->CR_NIVEL,NR_NV->CR_USER,Iif(Len(aNmCompl) > 0,aNmCompl[1],"ERRO!!!"),CR_DATALIB,CR_XHORA})
		
		NR_NV->(DbSkip())
	EndDo
	DbCloseArea("NR_NV")
	
	//
	RestArea(aArea)
	
Return aAporv
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �enviarEmail       � Autor � Everson � Data �  05/05/2017    ���
�������������������������������������������������������������������������͹��
���Descricao �Envia e-mail.                                               ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function enviarEmail(cAssunto,cMensagem,cEmail,cAtach)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	 Local lOk           := .T.
	 Local cBody         := cMensagem
	 Local cErrorMsg     := ""
	 Local aFiles        := {}
	 Local cServer       := Alltrim(GetMv("MV_RELSERV"))
	 Local cAccount      := AllTrim(GetMv("MV_RELACNT"))
	 Local cPassword     := AllTrim(GetMv("MV_RELPSW"))
	 Local cFrom         := AllTrim(GetMv("MV_RELFROM")) //Por Adriana em 24/05/2019 substituido MV_RELACNT por MV_RELFROM
	 Local cTo           := cEmail
	 Local lSmtpAuth     := GetMv("MV_RELAUTH",,.F.)
	 Local lAutOk        := .F.  
	 Local cSubject      := ""
	
	//Assunto do e-mail.
	 cSubject := cAssunto
	 
	 //Conecta ao servidor SMTP.
	 Connect Smtp Server cServer Account cAccount  Password cPassword Result lOk
	 
	 If !lAutOk
	    If ( lSmtpAuth )
	       lAutOk := MailAuth(cAccount,cPassword)
	       
	    Else
	       lAutOk := .T.
	       
	    EndIf
	    
	 EndIf
	 
	 If lOk .And. lAutOk   
	    
	    //Envia o e-mail.     
	    Send Mail From cFrom To cTo Subject cSubject Body cBody ATTACHMENT cAtach Result lOk  
	     
	    //Tratamento de erro no envio do e-mail.          
	    If !lOk
	       Get Mail Error cErrorMsg
	       ConOut("N�o foi poss�vel enviar o e-mail ao comprador. 3 - " + cErrorMsg)
	       
	    EndIf
	    
	 Else
	    Get Mail Error cErrorMsg
	    ConOut("N�o foi poss�vel enviar o e-mail ao comprador. 4 - " + cErrorMsg)
	    
	 EndIf
	 
	 If lOk
	    Disconnect Smtp Server
	    
	 EndIf
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �scripSCR          � Autor � Everson � Data �  05/05/2017    ���
�������������������������������������������������������������������������͹��
���Descricao �Script sql com os dados dos pedidos de compra.              ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function scripSCR()
	
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������	
	Local cQuery	:= ""
	
	cQuery += " SELECT " 
	cQuery += " DISTINCT CR_FILIAL " 
	cQuery += " , CONVERT(VARCHAR(10),CAST(ITENS.C7_EMISSAO AS DATE),103) AS C7_EMISSAO " 
	cQuery += " , CR_NUM " 
	cQuery += " , CR_TOTAL " 
	cQuery += " , CR_APROV " 
	cQuery += " , CR_USER " 
	cQuery += " , ITENS.C7_FORNECE " 
	cQuery += " , ITENS.C7_LOJA " 
	cQuery += " , ITENS.C7_USER "
	cQuery += " , ITENS.C7_PROJETO "
	cQuery += " , ITENS.C7_XHORA "
	cQuery += " , ITENS.A2_NOME "
	cQuery += " , ITENS.A2_CGC " 
	cQuery += " , CR_USERLIB  " 
	cQuery += " , ITENS.C7_MOEDA "
	cQuery += " , CR_TIPO " 
	cQuery += " , CONVERT(VARCHAR(10),CAST(ITENS.C7_DATPRF AS DATE),103) AS C7_DATPRF, ITENS.C7_COND, CR_NIVEL "
	cQuery += " FROM " 
	cQuery += " " + RetSqlName("SCR") + " (NOLOCK) AS SCR " 
	cQuery += " INNER JOIN " 
	cQuery += " ( " 
	cQuery += " SELECT  " 
	cQuery += " DISTINCT C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA, A2_CGC, A2_NOME, C7_MOEDA,C7_DATPRF, C7_EMISSAO, C7_COND, C7_USER, CASE WHEN C7_PROJETO <> '' THEN 'Sim' ELSE 'N�o' END AS C7_PROJETO  ,MAX(C7_XHORA) AS C7_XHORA "
	cQuery += " FROM  " 
	cQuery += "  " + RetSqlName("SC7") + "  (NOLOCK) AS SC7  " 
	cQuery += " INNER JOIN " 
	cQuery += "  " + RetSqlName("SA2") + "  (NOLOCK) AS SA2 " 
	cQuery += " ON C7_FORNECE = A2_COD " 
	cQuery += " AND C7_LOJA = A2_LOJA " 
	cQuery += " WHERE  " 
	cQuery += " SC7.D_E_L_E_T_ = '' " 
	cQuery += " AND C7_CONAPRO = 'B' " 
	cQuery += " GROUP BY "
	cQuery += " C7_FILIAL, C7_NUM, C7_FORNECE, C7_LOJA, A2_CGC, A2_NOME, C7_MOEDA,C7_DATPRF, C7_EMISSAO, C7_COND, C7_USER, C7_PROJETO "
	cQuery += " ) AS ITENS ON " 
	cQuery += " SCR.CR_FILIAL = ITENS.C7_FILIAL " 
	cQuery += " AND SCR.CR_NUM = ITENS.C7_NUM " 
	cQuery += " WHERE " 
	cQuery += " SCR.D_E_L_E_T_ = '' " 
	cQuery += " AND CR_STATUS = '02' " 
	cQuery += " AND CR_TIPO = 'PC' " 
	cQuery += " AND CR_USER <> '' " 
	cQuery += " AND ITENS.C7_EMISSAO >= '20170101' " 
	cQuery += " ORDER BY " 
	cQuery += " CR_USER, CR_FILIAL, CR_NUM " 
	
Return cQuery
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CondPag   �Autor  �Everson         �Data     �05/05/2017    ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o retornar os prazos da condi��o de pagamento.         ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function CondPag(nValor,cCondicao)

	//��������������������������������������������������������������Ŀ
	//�Declara��o de vari�veis.                                      �
	//���������������������������������������������������������������� 
	Local aArea		:= GetArea()	
	Local aDatas		:= {}
	Local i			:= 1
	Local nValor		:= 1000
	Local nValIpi		:= 0
	Local dDEmissao	:= Date()
	Local nValSol		:= 0
	Local cParcela	:= ""
	Local aParcelas	:= {}
	
	aDatas 	:= Condicao(nValor,cCondicao,nValIpi,dDEmissao,nValSol)
	
	For i := 1 To Len(aDatas)
		cParcela := cValToChar(DateDiffDay(CToD(cValToChar(aDatas[i][1])),Date()))
		Aadd(aParcelas,{cParcela})

	Next i
	
	RestArea(aArea)
	
Return aParcelas
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �logZBN    � Autor � Everson 			 � Data �  30/05/2017 ���
�������������������������������������������������������������������������͹��
���Descricao � Log Job.                                                   ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 034873.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function logZBN(cStatus)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������
	Local aArea	:= GetArea()
	
	DbSelectArea("ZBN") 
	ZBN->(DbSetOrder(1))
	ZBN->(DbGoTop()) 
	If ZBN->(DbSeek(xFilial("ZBN") + 'ADCOM008R'))
	
		RecLock("ZBN",.F.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_ROTINA	:= 'ADCOM008R'
			ZBN_DESCRI  := 'Gerar relat�rio de pedidos pendentes de aprova��o'
			ZBN_DATA    := dDataBase
			ZBN_HORA    := TIME()
			ZBN_PERIOD  := '1'
			ZBN_PERDES  := 'DIA'
			ZBN_QTDVEZ  := 1
			ZBN_HORAIN  := '12:00:00'
			ZBN_DATAPR  := dDataBase + 1
			ZBN_HORAPR  := '12:00:00'
			ZBN_STATUS	:= cStatus
			
		MsUnlock() 
		
	Else
	
		RecLock("ZBN",.T.)
		
			ZBN_FILIAL  := xFilial("ZBN")
			ZBN_ROTINA	:= 'ADCOM008R'
			ZBN_DESCRI  := 'Gerar relat�rio de pedidos pendentes de aprova��o'
			ZBN_DATA    := dDataBase
			ZBN_HORA    := TIME()
			ZBN_PERIOD  := '1'
			ZBN_PERDES  := 'DIA'
			ZBN_QTDVEZ  := 1
			ZBN_HORAIN  := '12:00:00'
			ZBN_DATAPR  := dDataBase + 1
			ZBN_HORAPR  := '12:00:00'
			ZBN_STATUS	:= cStatus
	
		MsUnlock() 	
	
	EndIf
	
	ZBN->(dbCloseArea())
		
	RestArea(aArea)

Return Nil