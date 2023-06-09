#Include 'Protheus.ch'
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MT110TEL � Autor � �verson             � Data �  31/08/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Este ponto tem a finalidade de manipular o cabe�alho da    ���
���          � Solicita��o de Compras permitindo a inclus�o e altera��o   ���
���          � de campos.													    ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function MT110TEL()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local oTelaSC		:= PARAMIXB[1]		//Objeto Dialog da solicita��o de compras.
	Local aPosGet    	:= PARAMIXB[2]		//Posi��o dos Gets da solicita��o de compras.
	Local nOpcx      	:= PARAMIXB[3]		//Op��o selecionada na solicita��o de compras.
	Local nReg       	:= PARAMIXB[4]		//N�mero do recno do registro da solicita��o de compras selecionada.
	Local oGrpCompra							//Objeto ComboBox
	Local aGrCompra	:= {}	
	Local lAltera		:= .T.
	Local cGetFiliais	:= GetMv("MV_#SCFILI")
	
	Local oHoraSC
	
	//Vari�vel p�blica para que seja vis�vel nos pontos de entrada MT110OK e MT110GRV.
	Public lRotHabil	:= .F.	//Vari�vel define a utiliza��o da rotina.
	Public cGrCompra	:= ""	//Vari�vel para armazenar a op��o selecionada.
	Public cHora	:= Substr(cValToChar(Time()),1,10)
	
	//Verifica se a regra � aplicada � filial corrente.
	If !(cFilAnt $(Alltrim(cValToChar(cGetFiliais))))
		Return Nil
	
	EndIf
	
	//Obt�m os grupos de compra presentes no campo C1_XGRCOMP.
	aGrCompra	:= obterOpcGrComp()
	
	//Valida o retorno da fun��o obterOpcGrComp(). 
	//Se n�o h� grupos de compra informados no campo C1_XGRCOMP, a rotina n�o � implementada.
	If Len(aGrCompra) == 0
		MsgStop("Por favor, verifique as op��es dispon�veis para o campo Tp. Compra! A SC n�o poder� ser salva!","Fun��o MT110TEL")
		RestArea(aArea)
		Return Nil
	
	EndIf
	
	//Verifica a opera��o selecionada para carregar valor no campo.
	If nOpcx <> 3 .And. ! Empty(Alltrim(cValToChar(SC1->C1_XGRCOMP)))//Se n�o for opera��o de inclus�o e o campo C1_XGRCOMP n�o estiver vazio.
		//Carrega op��o.
		cGrCompra:= Alltrim(cValToChar(SC1->C1_XGRCOMP))
		cHora  := SC1->C1_XHORASC
		
	//ElseIf nOpcx == 4 .And. Empty(Alltrim(cValToChar(SC1->C1_XGRCOMP))) //Altera��es de SC antes da implementa��o da rotina.
		//cGrCompra:= "1"
		
	Else //Se for opera��o de inclus�o ou o campo estiver vazio.
		cGrCompra:= aGrCompra[1]
			
	EndIf
	
	//Adiciona as posi��es da label do campo e ComboBox.
	Aadd(aPosGet[1],0) 
	Aadd(aPosGet[1],0)
	Aadd(aPosGet[1],0)
	Aadd(aPosGet[1],0)
	
	//Define a posi��o da label do campo.
	aPosGet[1,7]:=30
	aPosGet[1,9]:=312   //alterado por Adriana - Chamado 036032 - Projeto V12 
	
	//Define a posi��o do ComboBox e MsGet.
	aPosGet[1,8]:=74
	aPosGet[1,10]:= 360 //alterado por Adriana - Chamado 036032 - Projeto V12 
	
	//Valida altera��o do objeto ComboBox pela opera��o.
	If (nOpcx <> 3 .And. nOpcx <> 4) .Or. (nOpcx == 4 .And. ! Empty(Alltrim(cValToChar(SC1->C1_COTACAO))))
		lAltera := .F.
		
	EndIf
	
	//Habilita rotina.
	lRotHabil := .T.
	
	//Adiciona label e ComboBox a tela de soli��o de compras.
	//Alterada linha por Adriana 
	@63,aPosGet[1,7] Say RetTitle("C1_XGRCOMP") Pixel Size 30,09 Of oTelaSC
	@62,aPosGet[1,8] MsComboBox oGrpCompra Var cGrCompra Items aGrCompra Size 080, 20 Of oTelaSC Colors 0,16777215 Pixel;
					   on Change msgGrpComp(cGrCompra) When lAltera
					   
					  
	@63,aPosGet[1,9] Say "Hora" Pixel Size 30,09 Of oTelaSC
	@62,aPosGet[1,10] MsGet oHoraSC Var cHora  Size 50,10 Of oTelaSC Colors 0,16777215 Pixel When .F.   
        
	RestArea(aArea)
	
Return Nil
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �msgGrpComp � Autor � �verson         �   Data �  30/08/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o existe mensagem conforme gurpo de compra			    ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function msgGrpComp(cGrCompra)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local cMsg1		:= "Compra Normal" + Chr(13) + Chr(10) + "Sua SC ser� atendida em at� 05 dias �teis."
	Local cMsg2		:= "Compra Urgente" + Chr(13) + Chr(10) + "Obrigat�rio envio de autoriza��o da diretoria para atendimento da compra urgente (por e-mail)."
	
	If cGrCompra == "1"
		MsgInfo(cMsg1,"Fun��o msgGrpComp (MT110TEL)")
		
	ElseIf cGrCompra == "2"
		MsgInfo(cMsg2,"Fun��o msgGrpComp (MT110TEL)")
			
	EndIf

Return Nil
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �obterOpcGrComp � Autor � �verson        � Data �  29/08/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Obt�m os grupos de compra 									    ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function obterOpcGrComp()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis                                             �
	//�����������������������������������������������������������������������
	Local cGrOpcCompra	:= ""
	Local aGrCompra		:= {}
	Local aRetorno		:= {}
	Local i				:= 1

	//Obt�m as op��es (Grupo de compras).
	DbSelectArea("SX3")
	SX3->(DbSetOrder(2))
	If ! SX3->(dbSeek("C1_XGRCOMP"))
		Return aGrCompra
		
	Endif
	
	//Obt�m as op��es do campo C1_XGRCOMP.
	cGrOpcCompra  := X3Cbox()
	cGrOpcCompra	:= Alltrim(cValToChar(cGrOpcCompra))
	aGrCompra		:= StrToKarr(cGrOpcCompra,";")
	
	//Valida retorno da fun��o X3Cbox().
	If Len(aGrCompra) > 0 
		Aadd(aRetorno,"")
		For i := 1 To Len(aGrCompra)
			Aadd(aRetorno,aGrCompra[i])
			
		Next i
	
	EndIf
	
Return aRetorno