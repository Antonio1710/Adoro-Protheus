#Include "Protheus.ch"
#Include "Rwmake.ch"
#Include "Totvs.ch"
#Include "Topconn.ch"
#Include "Tbiconn.ch"
#Include "Fileio.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADVEN037R     �Autor  �Everson          �Data �  16/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Relat�rio an�lise de cliente sem compra por per�odo.        ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADVEN037R() // U_ADVEN037R()

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//���������������������������������������������������������������� 
	Local cPerg	:= "ADVEN037R"
	
	Private lDiret := .F.
	Private lGerent:= .F.
	Private lSuperv:= .F.
	Private lVended:= .F.
	Private cCodigo:= ""
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relat�rio an�lise de cliente sem compra por per�odo.')
	
	//
	logAcesso("ADVEN037R")
	
	DbSelectArea("SA3")
	SA3->(DbSetOrder(7))
	SA3->(DbGoTop())
	
	If Dbseek(xFilial("SA3") + Alltrim(cValToChar(__cUserID)))
	//If Dbseek(xFilial("SA3") + Alltrim(cValToChar("000835")))
	   If SA3->A3_NIVETAB == "4"
	      lDiret := .T.
	      
	   Elseif SA3->A3_NIVETAB == "3"
	      lGerent := .T.
	      cCodigo := SA3->A3_COD
	      
	   Elseif SA3->A3_NIVETAB == "2"
	      lSuperv := .T.
	      cCodigo := SA3->A3_CODSUP
	      
	   Else
	      lVended := .T.
	      cCodigo := SA3->A3_COD  
	            
	   Endif
	   
	Else
	   MsgStop("Seu usu�rio n�o possui cadastro na tabela de vendedores e n�o poder� emitir este relat�rio.","Fun��o ADVEN037R")
	   Return Nil
	   
	Endif
	
	//@history Ticket 70142  - Edvar / Flek Solution - 06/04/2022 - Retirada de fun��o PUTSX1
	//Cria pergunta.
	//criarPergunta(cPerg)
	
	//Executa a pergunta.
	If ! Pergunte(cPerg,.T.)
		Return Nil
		
	EndIf
	
	//Processa relat�rio.
	MsAguarde({||relatorio()},"Aguarde","Gerando relat�rio...")

Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �relatorio     �Autor  �Everson          �Data �  16/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa o relat�rio.                                       ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function relatorio()

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//���������������������������������������������������������������� 
	Local folder		:= "C:\temp\"
	Local arq			:= "Analise_Cliente_Sem_Compra_qtd_motivo.html"
	Local nHandle		
	Local cPulaLin		:= Chr(13) + Chr(10)
	Local aDados		:= {}
	Local aMotivos		:= {}
	Local aDadosOrd		:= {}
	Local aAux			:= {}
	Local cPerDe		:= ""
	Local cPerAte		:= ""
	Local cPerEntre		:= ""
	Local i				:= 1
	Local nPosDados		:= 0
	Local nPosMot		:= 0
	Local cCodSuper		:= ""
	Local cNumMotivo	:= ""
	
	//
	cPerAte	:= Alltrim(cValToChar(MV_PAR01))
	cPerAte	:= Substr(cPerAte,3,4) + Substr(cPerAte,1,2)

	cPerDe 	:= DToS(MonthSub(SToD(cPerAte+"01"),2))
	cPerDe		:= Substr(cPerDe,1,4) + Substr(cPerDe,5,2)
	
	cPerEntre	:= DToS(MonthSub(SToD(cPerAte+"01"),1))
	cPerEntre	:= Substr(cPerEntre,1,4) + Substr(cPerEntre,5,2)
	
	//Obt�m motivos apontados dentro do per�odo para preenchimento do cabe�alho do relat�rio.
	MsAguarde({||aMotivos := motivos(cPerDe,cPerAte)},"Aguarde","Obtendo dados...")
	
	//Obt�m dados do relat�rio.
	MsAguarde({||aDados := dadosRel(cPerDe,cPerAte)},"Aguarde","Obtendo dados...")
	
	//Valida retorno das fun��es motivos e dadosRel.
	If Len(aMotivos) <= 0 .Or. Len(aDados) <= 0
		MsgStop("N�o h� dados para os par�metros informados.","Fun��o relatorio")
		Return Nil
		
	EndIf
	
	//Cria arquivo.
	nHandle := FCreate(Alltrim(folder)+arq, FC_NORMAL)
	
	//Valida se foi poss�vel criar o arquivo.
	If nHandle == -1      
		MsgStop('Erro de abertura de arquivo : ' + cPulaLin + 'FERROR ' + cValToChar(ferror(),4),"Fun��o relatorio")	
		Return Nil
		  
	Endif 
	
	//String HTML.
	MsAguarde({||gerarHtml(nHandle,aDados,aMotivos,cPerDe,cPerEntre,cPerAte)},"Aguarde","Gerando HTML...")
	
	//Fecha arquivo. 
	FClose(nHandle)
	
	//Executa programa padr�o para abertura de arquivo HTML.
	MsAguarde({||shellExecute("Open", "C:\temp\Analise_Cliente_Sem_Compra_qtd_motivo.html", "NULL", "C:\",3)},"Aguarde","Abrindo relat�rio...")
	
	//
	MsgInfo("Relat�rio gerado.","Fun��o relatorio")
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �gerarHtml     �Autor  �Everson          �Data �  21/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Gera arquivo html.                                          ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function gerarHtml(nHandle,aDados,aMotivos,cPerDe,cPerEntre,cPerAte)

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//���������������������������������������������������������������� 
	Local cHtml		:= ""
	Local i			:= 1
	Local x			:= 1
	Local y			:= 1
	Local aSup		:= {}
	Local cNmSup	:= ""
	Local nTotMo	:= 0
	Local nTotMog	:= 0
	Local nPosQtd	:= 0
	Local nVlPer	:= 0
	
	cHtml := ''
	cHtml += ' <!DOCTYPE html> '
	cHtml += ' <html> '
	cHtml += ' <head> '
	cHtml += ' <meta charset="UTF-8"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.bootstrap.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.bootstrap.min.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.bootstrap4.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.bootstrap4.min.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.dataTables.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.dataTables.min.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.foundation.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.foundation.min.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.jqueryui.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.jqueryui.min.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.semanticui.css"> '
	cHtml += ' <link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/colreorder/1.3.2/css/colReorder.semanticui.min.css"> '
	cHtml += ' <style> '
	cHtml += ' html{width:97%; '
	cHtml += ' margin-left: auto; '
	cHtml += ' margin-right: auto;} '
	cHtml += ' table{width: 4000px } '
	cHtml += ' </style> '
	cHtml += ' </head> '
	cHtml += ' <body> '
	cHtml += ' <div class="container"> ' 
	cHtml += ' <h3>Analise de Cliente sem Compra - Supervisor x Qtd. Motivo</h3> '
	cHtml += ' <br/> '
	cHtml += ' <table> '
	cHtml += ' <thead> '
	cHtml += ' </thead> '
	cHtml += ' <tbody> '
	cHtml += ' <tr> '
	cHtml += ' <td>Usuario: ' + cUserName + '</td> ' 
	cHtml += ' </tr>  '
	
	cHtml += ' <tr> '
	cHtml += ' <td>Data: ' + DToC(Date()) + ' | Hora: ' + cValToChar(Time()) + '</td> '
	cHtml += ' </tr> '
	
	cHtml += ' <tr> '
	cHtml += ' <td><input type="button" value="Exportar" id="btnExportar"></td> '
	cHtml += ' </tr> '
	cHtml += ' </tbody> '
	cHtml += ' </table> '
	cHtml += ' <table id="dadosTabela" class="table table-responsive table-striped table-bordered"> '
	cHtml += ' <thead> '
	cHtml += ' <tr> '
	cHtml += ' <td>Codigo</td> '
	cHtml += ' <td>Motivos</td> '
	
	//
	For i := 1 To Len(aDados)
	
		nPos := AScan(aSup,{|x| Alltrim(cValToChar(x[1])) == Alltrim(cValToChar(aDados[i][1])) })
		
		If nPos == 0
			
			cNmSup := Posicione("SZR",1,xFilial("SZR") + Alltrim(cValToChar(aDados[i][1])),"ZR_DESCRIC")
			
			Aadd(aSup,{Alltrim(cValToChar(aDados[i][1])),cNmSup,0})
			
		EndIf
	
	Next i
	
	//
	For i := 1 To Len(aSup)
		cHtml += ' <td>' + Alltrim(cValToChar(aSup[i][1])) + "-" + Alltrim(cValToChar(aSup[i][2])) + '</td> '
		
	Next i
	
	//
	cHtml += ' <td>Total</td> '
	cHtml += ' <td>%</td> '
	
	cHtml += ' </tr> '
	cHtml += ' </thead> '
	cHtml += ' <tbody> '
	
	//
	//aSort(aMotivos,,,{|x,y| Val(cValToChar(x[1])) <  Val(cValToChar(y[1])) })
	
	nTotMog := 0
	For i := 1 To Len(aMotivos)
		
		nTotMog += Val(cValToChar(aMotivos[i][3]))
		
	Next i
	
	//
	For i := 1 To Len(aMotivos)
		
		cHtml += ' <tr> '
		
		cHtml += ' <td>' + Alltrim(cValToChar(aMotivos[i][1])) + '</td> '
		cHtml += ' <td>' + Alltrim(cValToChar(aMotivos[i][2])) + '</td> '
		
		cMot := Alltrim(cValToChar(aMotivos[i][1]))
		
		For x := 1 To Len(aSup)
			
			cSuper := Alltrim(cValToChar(aSup[x][1]))
			
			nPosQtd := 0
			nPosQtd := Ascan(aDados,{|x| Alltrim(cValToChar(x[4])) == cSuper+cMot})
			
			If nPosQtd > 0
				cHtml  += ' <td>' + cValToChar(aDados[nPosQtd][3]) + '</td> '
				nTotMo += Val(cValToChar(aDados[nPosQtd][3]))
				aSup[x][3] += Val(cValToChar(aDados[nPosQtd][3]))
				
			Else
				cHtml += ' <td>0</td> '
				
			EndIf
			

		Next x
		
		cHtml  += ' <td>' + cValToChar(nTotMo) + '</td> '
		
		nVlPer := StrTran(Substr(cValToChar(Iif(nTotMog > 0, (nTotMo/nTotMog) * 100 ,0)),1,5),".",",")
		
		cHtml  += ' <td>' + nVlPer + '</td> '
		
		nTotMo := 0
		
		cHtml += ' </tr> '
		
	Next i
	
	//
	cHtml += ' <tr> '
	cHtml += ' <td>Total</td> '
	cHtml += ' <td></td> '	
	For x := 1 To Len(aSup)
	
		cHtml   += ' <td>' + cValToChar(aSup[x][3]) + '</td> '
		
	Next x
	
	cHtml += ' <td>' + cValToChar(nTotMog) + '</td> '
		
	cHtml += ' </tr> '
	
	//
	cHtml += ' </tbody> '
	cHtml += ' </table> '
	cHtml += ' </div> '
	cHtml += ' <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script> '
	cHtml += ' <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script> '
	cHtml += ' <script src="https://cdn.datatables.net/1.10.12/js/jquery.dataTables.min.js"></script> '
	cHtml += ' <script src="https://cdn.datatables.net/1.10.12/js/dataTables.bootstrap.min.js"></script> '
	cHtml += ' <script src="https://cdn.datatables.net/colreorder/1.3.2/js/dataTables.colReorder.js"></script> '
	cHtml += ' <script src="https://cdn.datatables.net/colreorder/1.3.2/js/dataTables.colReorder.min.js"></script> '
	cHtml += scriptCSV()
	cHtml += ' </body> '
	cHtml += ' </html> '
	
	FWrite(nHandle,cHtml)
	cHtml := ""
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �dadosRel      �Autor  �Everson          �Data �  16/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Obt�m dados dos relt�ario.                                  ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static function dadosRel(cPerDe,cPerAte)

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//����������������������������������������������������������������
	Local cQuery		:= ""  
	Local aRetorno	:= {}
	
	//Monta script sql.
	cQuery := scriptDados(cPerAte)
	cQuery += " ORDER BY ZBI_MOTIVO, ZBI_CODSUP "

	//Verifica se o alias j� existe.
	If Select("REGISTROS") > 0
		REGISTROS->(DbCloseArea())
		
	EndIf
	
	//Executa consulta no BD.
	TcQuery cQuery New Alias "REGISTROS"
	
	DbSelectArea("REGISTROS")
	REGISTROS->(DbGoTop())
	While ! REGISTROS->(Eof())
		
		Aadd(aRetorno,{;
							REGISTROS->ZBI_CODSUP,;
							REGISTROS->ZBI_MOTIVO,;
							REGISTROS->QTD,;
							REGISTROS->CHAVE;
		})
		
		REGISTROS->(DbSkip())
	EndDo
	DbCloseArea("REGISTROS")
		
Return aRetorno
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �scriptDados   �Autor  �Everson          �Data �  16/06/2017 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna script sql com os dados do relat�rio.               ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function scriptDados(cPerAte)

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//����������������������������������������������������������������	
	Local aArea	:= GetArea()
	Local cQuery:= ""
	
	cQuery := ""
	cQuery += " SELECT   " 
	cQuery += " ZBI_CODSUP, ZBI_MOTIVO, COUNT(X5_DESCRI)  AS QTD, RTRIM(LTRIM(ZBI_CODSUP)) + RTRIM(LTRIM(ZBI_MOTIVO)) AS CHAVE " 
	cQuery += " FROM   " 
	cQuery += " " + RetSqlName("ZBI") + "  AS ZBI   " 
	cQuery += " INNER JOIN   " 
	cQuery += " (   " 
	cQuery += " SELECT *   " 
	cQuery += " FROM   " 
	cQuery += " " + RetSqlName("SX5") + "  AS SX5   " 
	cQuery += " WHERE   " 
	cQuery += " SX5.D_E_L_E_T_ = ''   " 
	cQuery += " AND X5_TABELA = 'ZY'   " 
	cQuery += " ) AS MOTIVO ON   " 
	cQuery += " ZBI_MOTIVO = MOTIVO.X5_CHAVE   " 
	cQuery += " WHERE   " 
	cQuery += " ZBI.D_E_L_E_T_ = ''   " 
	cQuery += " AND ZBI_MOTIVO <> ''   " 
	
	cQuery += " AND SUBSTRING(ZBI_PERIOD,3,4)+SUBSTRING(ZBI_PERIOD,1,2) = '" + cPerAte+ "'  " 
	
	If lDiret .Or. lGerent
		cQuery += " AND ZBI_CODSUP >= '" + cValToChar(MV_PAR02) + "' "
		cQuery += " AND ZBI_CODSUP <= '" + cValToChar(MV_PAR03) + "' " 
	
	ElseIf lSuperv
		cQuery += " AND ZBI_CODSUP = '" + cValToChar(cCodigo) + "' "
	
	ElseIf lVended
		cQuery += " AND ZBI_VEND  = '" + cValtoChar(cCodigo) + "' "
	
	EndIf

	cQuery += " GROUP BY ZBI_CODSUP, ZBI_MOTIVO " 
	
	//
	RestArea(aArea)
	
Return cQuery
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �motivos       �Autor  �Everson          �Data �  21/11/2016 ���
�������������������������������������������������������������������������͹��
���Desc.     �Retorna os motivos existentes dentro do per�odo.            ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function motivos(cPerDe,cPerAte)

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//����������������������������������������������������������������
	Local cQuery		:= ""  
	Local aRetorno	:= {}
	
	//Monta script sql.
	cQuery := ""
	
	cQuery += " SELECT "
	cQuery += " CAST(FONTE.ZBI_MOTIVO AS NUMERIC) AS ZBI_MOTIVO, MOTIVO.X5_DESCRI, SUM(FONTE.QTD) AS QTD "
	cQuery += " FROM "
	cQuery += " ( "

	cQuery += scriptDados(cPerAte)
	
	cQuery += " ) AS FONTE "
	cQuery += " INNER JOIN "
	cQuery += " (   "
	cQuery += " SELECT *   "
	cQuery += " FROM   "
	cQuery += " " + RetSqlName("SX5") + "  AS SX5   "
	cQuery += " WHERE   "
	cQuery += " SX5.D_E_L_E_T_ = ''   "
	cQuery += " AND X5_TABELA = 'ZY'  " 
	cQuery += " ) AS MOTIVO ON   "
	cQuery += " FONTE.ZBI_MOTIVO = MOTIVO.X5_CHAVE  " 

	cQuery += " GROUP BY "
	cQuery += " FONTE.ZBI_MOTIVO, "
	cQuery += " MOTIVO.X5_DESCRI "

	cQuery += " ORDER BY QTD DESC "
	
	//Verifica se o alias existe.
	If Select("MOTIVOS") > 0
		MOTIVOS->(DbCloseArea())
		
	EndIf
	
	//Executa consulta no BD.
	TcQuery cQuery New Alias "MOTIVOS"
	DbSelectArea("MOTIVOS")
	MOTIVOS->(DbGoTop())
	While ! MOTIVOS->(Eof())
		
		Aadd(aRetorno,{;
							Val(cValToChar(MOTIVOS->ZBI_MOTIVO)),;
							MOTIVOS->X5_DESCRI,;
							MOTIVOS->QTD ;
		})
		
		MOTIVOS->(DbSkip())
	EndDo
	
	DbCloseArea("MOTIVOS")

Return aRetorno
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �scriptCSV �Autor  �Everson            � Data �  16/11/2016  ���
�������������������������������������������������������������������������͹��
���Desc.     � JavaScript a ser adicionado na p�gina do relat�rio.        ���
�������������������������������������������������������������������������͹��
���Uso       � Comercial                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function scriptCSV()

	//��������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                     �
	//���������������������������������������������������������������� 	
	Local cScript := ""
	
	cScript := "<script>"
	cScript += " $(document).ready(function() { "
   cScript += " $('#dadosTabela').DataTable({'bPaginate': false, colReorder: true, 'ordering': false}); "
	cScript += " } ); "
	cScript += " function download(strData, strFileName, strMimeType) {var D = document, a = D.createElement('a');strMimeType= strMimeType || 'application/octet-stream'; "
	cScript += " if (navigator.msSaveBlob) {return navigator.msSaveBlob(new Blob([strData], {type: strMimeType}), strFileName);} "
	cScript += " if ('download' in a) { a.href = 'data:' + strMimeType + ',' + encodeURIComponent(strData); a.setAttribute('download', "
	cScript += " strFileName); a.innerHTML = 'downloading...';D.body.appendChild(a); setTimeout(function() {a.click(); D.body.removeChild(a);}, 66);return true;} "
	cScript += " var f = D.createElement('iframe'); "
	cScript += " D.body.appendChild(f); f.src = 'data:' +  strMimeType   + ',' + encodeURIComponent(strData);setTimeout(function() { D.body.removeChild(f);}, 333);return true;} "	
	cScript += " jQuery.fn.table2CSV = function(options){var options = jQuery.extend({separator: ';',header: [],headerSelector: 'th',columnSelector: 'td', "
	cScript += " delivery: 'popup',filename: 'poweredd_by_sinri.csv',transform_gt_lt: true},	options); "
	cScript += " var csvData = [];var headerArr = [];var el = this; "
	cScript += " var numCols = options.header.length;var tmpRow = []; "
	cScript += " if (numCols > 0){for (var i = 0; i < numCols; i++) {tmpRow[tmpRow.length] = formatData(options.header[i]);}"
	cScript += " } else {$(el).filter(':visible').find(options.headerSelector).each(function() {if ($(this).css('display') != 'none') tmpRow[tmpRow.length] = formatData($(this).html());});} "
	cScript += " row2CSV(tmpRow); "
	cScript += " $(el).find('tr').each(function() {var tmpRow = [];$(this).filter(':visible').find(options.columnSelector).each(function() { "
	cScript += " if ($(this).css('display') != 'none') tmpRow[tmpRow.length] = formatData($(this).html());});row2CSV(tmpRow);}); "
	cScript += " if (options.delivery == 'popup') {var mydata = csvData.join('\n');if(options.transform_gt_lt){mydata=sinri_recover_gt_and_lt(mydata);} "
	cScript += " return popup(mydata);}"
	cScript += " else if(options.delivery == 'download') {var mydata = csvData.join('\n');if(options.transform_gt_lt){mydata=sinri_recover_gt_and_lt(mydata);} "
	cScript += " var url='data:text/csv;charset=utf8,' + encodeURIComponent(mydata);	window.open(url);	return true;} "
	cScript += " else {var mydata = csvData.join('\n');if(options.transform_gt_lt){mydata=sinri_recover_gt_and_lt(mydata);}return mydata;} "
	cScript += " function sinri_recover_gt_and_lt(input){var regexp=new RegExp(/&gt;/g);var input=input.replace(regexp,'>'); "
	cScript += " var regexp=new RegExp(/&lt;/g);var input=input.replace(regexp,'<');	return input;} "
	cScript += " function row2CSV(tmpRow) {var tmp = tmpRow.join(''); if (tmpRow.length > 0 && tmp != '') {	var mystr = tmpRow.join(options.separator); "
	cScript += " csvData[csvData.length] = mystr;	}} "
	cScript += " function formatData(input) {
	cScript += " var regexp = new RegExp(/[']/g); "
	cScript += " var output = input.replace(regexp, '�'); "
	cScript += " var regexp = new RegExp(/\<[^\<]+\>/g); "
	cScript += " var output = output.replace(regexp, ''); "
	cScript += " output = output.replace(/&nbsp;/gi,' '); "
	cScript += " if (output == '') return ''; "
	cScript += " return '"
	cScript += '"'
	cScript += " ' "
	cScript += " + output.trim() + '"
	cScript += '"'
	cScript += " '; } "
			
	cScript += " function popup(data) { "
	cScript += " var generator = window.open('', 'csv', 'height=400,width=600'); "
	cScript += " generator.document.write('<html><head><title>CSV</title>'); "
	cScript += " generator.document.write('</head><body >'); "
	cScript += " generator.document.write('<textArea cols=70 "
	cScript += ' rows=15 wrap="off" '
	cScript += " >'); "
	cScript += " generator.document.write(data); "
	cScript += " generator.document.write('</textArea>'); "
	cScript += " generator.document.write('</body></html>'); "
	cScript += " generator.document.close(); "
	cScript += " return true; "
	cScript += " } "
	cScript += " }; "
	
	cScript += " $(document).ready(function () { "
	
	cScript += " $('#dadosTabela').each(function () { "
	cScript += " var $table = $(this); "
	cScript += " var $button = $('#btnExportar'); "
	cScript += ' $button.text("Exportar"); '
	cScript += " $button.click(function () { "
	cScript += " var csv = $table.table2CSV({ "
	cScript += " delivery: 'value' "
	cScript += " }); "
	cScript += ' download(csv, "processado.csv", "text/csv");'
	cScript += " }); "
	cScript += " }); "
	
	cScript += " }) "
		
	cScript += "</script>"
		
Return cScript
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �criarPergunta �Autor  �Everson          �Data �16/11/2016   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria pergunta na SX1.                                       ���
�������������������������������������������������������������������������͹��
���Uso       �Comercial.                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Static Function criarPergunta(cPerg)
//
//	//��������������������������������������������������������������Ŀ
//	//� Declara��o de vari�veis.                                     �
//	//���������������������������������������������������������������� 
//	Local aArea := GetArea()
//	
//	PutSx1(cPerg,"01","Per�odo(mmaaaa)  ?"," "," ","mv_ch1","C",6,0,0,	"G","","","","","mv_par01"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o per�odo de apura��o"} ,{"Informe o per�odo de apura��o"}, {"Informe o per�odo de apura��o"})
//	PutSx1(cPerg,"02","Supervisor de    ?"," "," ","mv_ch2","C",6,0,0,	"G","","","","","mv_par02"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o c�digo do supervisor"},{"Informe o c�digo do supervisor"},{"Informe o c�digo do supervisor"})
//	PutSx1(cPerg,"03","Supervisor At�   ?"," "," ","mv_ch3","C",6,0,0,	"G","","","","","mv_par03"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o c�digo do supervisor"},{"Informe o c�digo do supervisor"},{"Informe o c�digo do supervisor"})
//	//PutSx1(cPerg,"04","Vendedor de      ?"," "," ","mv_ch4","C",6,0,0,	"G","","SA3","","","mv_par04"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o c�digo do vendedor"},{"Informe o c�digo do vendedor"},{"Informe o c�digo do vendedor"})
//	//PutSx1(cPerg,"05","Vendedor At�     ?"," "," ","mv_ch5","C",6,0,0,	"G","","SA3","","","mv_par05"," "," "," ","",	" "," "," "," "," "," ", " "," "," "," ",	" "," ",{"Informe o c�digo do vendedor"},{"Informe o c�digo do vendedor"},{"Informe o c�digo do vendedor"})
//	
//	RestArea(aArea)
// 
//Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �logAcesso         � Autor � Everson � Data �  16/06/2017    ���
�������������������������������������������������������������������������͹��
���Descricao �Log de acesso de rotina.                                    ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado .                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function logAcesso(cRotina)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������		
	Local aArea		:= GetArea()
	
	cRotina := Alltrim(cValToChar(cRotina))

	//Log.
	RecLock("ZBE",.T.)
		ZBE->ZBE_FILIAL := xFilial("SE1")
		ZBE->ZBE_DATA	:= Date()
		ZBE->ZBE_HORA	:= cValToChar(Time())
		ZBE->ZBE_USUARI	:= cUserName
		ZBE->ZBE_LOG	:= "ACESSO A ROTINA " + cRotina
		ZBE->ZBE_MODULO	:= "COMERCIAL"
		ZBE->ZBE_ROTINA	:= "ADVEN037R"
	MsUnlock()
	
	RestArea(aArea)
	
Return Nil
