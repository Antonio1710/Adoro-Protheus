#INCLUDE "PROTHEUS.CH"

//ฺ---------ย------------------ย------B----------------------------------------ย----ย-----------ฟ
//|PROGRAMA | MT140OK          |AUTOR | DANIEL PITTHAN SILVEIRA                |DATA|20/03/07   |
//ร---------+------------------ม------ม----------------------------------------ม----ม-----------ด
//|DESCRICAO| Ponto de entrada executado na validacao da pre-nota.                              |
//|         | Usado para consistir a Loja do pedido de compras com a Loja do fornecedor         |
//|         | na pre-nota                                                                       |
//|         |                                                                                   |
//ร---------+----------------------ย-----ย------------------------------------------------------ด
//|MODULO   | COMPRAS              |TIPO | [ ] - PROCESSAMENTO          [ ] - TRANSACAO         |
//|         |                      |     | [X] - PONTO DE ENTRADA       [ ] - VALIDACAO         |
//|         |                      |     | [ ] - GATILHO                [ ] - CONSULTA          |
//|         |                      |     | [ ] - RELATORIO                                      |
//ร---------+--------------ย-------ม-----ม----ย-------------------------------------------------ด
//|MANUT.   |DATA          | AUTOR            |DESCRICAO                                        |
//ร---------+--------------+------------------+-------------------------------------------------ด
//|CH TI    |09/05/2019    |Everson           | Everson 09/05/2019.Valida็ใo data de emissใo.   |
//|CH TI    |10/05/2019    |Everson           | Everson 09/05/2019.Valida็ใo esp้cia documento. |
//|         |              |                  |                                                 |
//|         |              |                  |                                                 |
//ภ---------ม--------------ม------------------ม-------------------------------------------------ู

USER FUNCTION MT140TOK 

	Local dDtLEmis	:= GetMV('MV_#DTEMIS') //Everson - 09/05/2019. Chamado TI.

	Private _aAreaSF1	:= {}
	Private _aAreaSD1	:= {}
	Private _aAreaSC7	:= {}

	Private _cFilSF1	:= xFilial("SF1")
	Private _cFilSD1	:= xFilial("SD1")
	Private _cFilSC7	:= xFilial("SC7")


	//+----------------------------------+
	//|DADOS                             |
	//+----------------------------------+
	Private _cPed		:=''		//Pedido de Compras
	Private _lRet		:=.T.		//retono

	   // ticket 84085 - 01/12/2022 - Fernando Macieira - TRANSFERENCIA DE ATIVO IMOBILIZADO nota fiscal nใo aparece no Faturamento
	If AllTrim(FUNNAME())=="ATFA060" .or. IsInCallStack("ATFA060")
		Return _lRet
	EndIf

	 _aAreaSF1	:=SF1->(GetArea())		//SD1
	 _aAreaSD1	:=SD1->(GetArea())		//SF1
	 _aAreaSC7	:=SC7->(GetArea())		//SC7

	//ษอออออออออออออออออออออออออออออออออป
	//บ PROGRAMA PRINCIPAL              บ
	//ศอออออออออออออออออออออออออออออออออผ
	DBSELECTAREA("SC7"); DBSETORDER(3)		//FILIAL+FORNECEDOR+LOJA+PEDIDO

	//+----------------------------------+
	//|OBTENDO DADOS DO PEDIDO           |
	//+----------------------------------+
	_cPed	:=aCols[1][aScan	( aHeader, {|x| ALLTRIM(x[2])=="D1_PEDIDO"		} 	)]

	//+-----------------------------------+
	//|POSICIONANDO NO PEDIDO             |
	//+-----------------------------------+
	DBSELECTAREA("SC7")
	If DbSeek(_cFilSC7+cA100For+cLoja+_cPed,.T.)
		If SC7->C7_LOJA<>cLoja    
			MsgInfo("Loja do Fonecedor nao e igual ao do pedido.")
			_lRet:=.F.
		EndIf
	EndIf

	//ษอออออออออออออออออออออออออออออออออป
	//บ FIM                             บ
	//ศอออออออออออออออออออออออออออออออออผ
	
	//Everson - 09/05/2019. Chamado TI.
	If Len(Alltrim(DTOS(dDtLEmis))) > 0
		If DDEMISSAO <= dDtLEmis
			AVISO('Bloqueio de Data de Emissใo', 'A data de emissใo do documento ้ inferior ao permitido para digita็ใo. Consulte o Depto. Fiscal!', {"Fechar"}, 1 )   
			_lRet := .F.			 
		Endif
	Endif
	//
	
	//Everson - 10/05/2019. Chamado TI.
	If Empty(Alltrim(cValToChar(CESPECIE)))
		AVISO('Bloqueio de Espec. Docum.', 'ษ obrigat๓rio informar a esp้cie do documento.', {"Fechar"}, 1 )   
		_lRet := .F.	
	
	EndIf
	//

	//+----------------------------------+
	//|RESTAURANDO O AMBIENTE            |
	//+----------------------------------+
	RestArea(_aAreaSF1)
	RestArea(_aAreaSD1)
	RestArea(_aAreaSC7)
	
RETURN (_lRet)
