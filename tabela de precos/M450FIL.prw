#include "rwmake.ch"       
#include "topconn.ch"

Static _dDTENTRA := CTOD("  /  /  ")
Static _dDTENTRB := CTOD("  /  /  ")

/*/{Protheus.doc} User Function M450FIL
	Ponto de Entrada na analise de credito para filtrar pela data de entrega
	@type  Function
	@author Mauricio
	@since 15/06/2011
	@version 01
	@history ticket T.I   - Mauricio      -            - Parametros incluidos manualmente na tabela SX1, MV_PAR03, MV_PAR05 e MV_PAR05(MTA451). 
	@history ticket T.I   - Mauricio      - 28/06/2011 - solicitado filtrar por carteira Estadual/Interestadual. Conforme vagner a separa��o de carteira � pelo codigo do vendedor no SA3.
	@history ticket T.I   - Mauricio      -            - Estadual do codigo 000001 a 000135. Demais codigos eh interestadual.
	@history ticket T.I   - WILLIAM COSTA - 17/05/2023 - INCLUSAO DA EMPRESA 13
	@history ticket TI - Antonio Domingos - 26/05/2023 - Revis�o Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 02/06/2023 - Valida��o Ajuste Nova Empresa
/*/

User Function M450FIL() 

	Local _cFiltro := " .T."
	Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 02/06/2023

	_dDTENTRA := MV_PAR03
	_dDTENTRB := MV_PAR04

	IF ALLTRIM(CEMPANT) $ _cEmpAt1 //Codigo de Empresas Ativas Grupo 1 -  ticket TI - Antonio Domingos - 02/06/2023

		If MV_PAR05 == 1  &&estadual 
			_cFiltro := " (DTOS(SC9->C9_DTENTR) >= '" + Dtos(_dDtEntrA) + "' .and. DTOS(SC9->C9_DTENTR) <= '" + Dtos(_dDtEntrB)  + "') .And. (SC9->C9_VEND1 >= '000001' .AND. SC9->C9_VEND1 <= '000135') "
		elseif MV_PAR05 == 2 &&interestadual
			_cFiltro := " (DTOS(SC9->C9_DTENTR) >= '" + Dtos(_dDtEntrA) + "' .and. DTOS(SC9->C9_DTENTR) <= '" + Dtos(_dDtEntrB)  + "') .And. (SC9->C9_VEND1 < '000001' .OR. SC9->C9_VEND1 > '000135') "
		Else  &&todos
			_cFiltro := " (DTOS(SC9->C9_DTENTR) >= '" + Dtos(_dDtEntrA) + "' .and. DTOS(SC9->C9_DTENTR) <= '" + Dtos(_dDtEntrB)  + "') "
		Endif   

	ENDIF 

Return( _cFiltro)

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �FC010BTN   � Autor � Ana Helena             � Data �21.11.12���
�������������������������������������������������������������������������Ĵ��
���Descricao �O ponto de entrada FC010BTN permite a exibi��o e acionamento���
��� de um bot�o customizado pelo cliente, na tela de consulta de posi��o  ���
��� de clientes.                                                          ���
��� Nome do botao: "Limite Dispon"                                        ���
��� O botao s� � habilitado se a pergunta "Considera loja" = Sim          ���
�������������������������������������������������������������������������Ĵ��
��� Exibe o limite de cr�dito disponivel do cliente                       ���
�������������������������������������������������������������������������Ĵ��
���          �               �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FC010BTN()

	Local cCodCli     := SA1->A1_COD

	If Paramixb[1] == 1 // Deve retornar o nome a ser exibido no botao
		
		Return "Limite Dispon"
		
	ElseIf Paramixb[1] == 2 // Deve retornar a mensagem do botao
		
		Return
		
	Else // Comandos que ser�o executados do ponto de entrada assim que clicar no botao// comando 1// comando 2//Comando3...//Comando n
		
		lMostra := .F.
		IF IsInCallStack('U_ADVEN018P')
			U_ConsLimFin(cCodCli,"Con","",_dDTENTR1,_dDTENTR2)
			lMostra := .T.
		Elseif IsInCallStack('MATA450')
			U_ConsLimFin(cCodCli,"Con","",_dDTENTRA,_dDTENTRB)
			lMostra := .T.
		Else  &&Sera mostrada tela com data de entrega maior que database como era anteriormente sem parametros.
			U_ConsLimFin(cCodCli,"Out","",_dDTENTRA,_dDTENTRB)
			lMostra := .T.
		Endif
		
		If lMostra
			
			@ 116,090 To 400,501 Dialog oDlgMemo Title "Limite de Credito Disponivel"
			@ 003,002 To 040,207
			@ 012,008 Say OemToAnsi("Cliente:  "+_cCliente+" - "+_cNomeCli)
			@ 025,008 Say OemToAnsi("Tipo:     "+_cTipoCli+Iif(!Empty(_cRede)," - "," ")+_cRede)
			@ 041,005 Say OemToAnsi("Limite Disponivel     :  ")
			@ 041,150 Say OemToAnsi(Str(_nValLim))
			@ 003,002 To 050,207
			@ 003,002 To 120,207
			@ 052,005 Say OemToAnsi("Detalhado :  ")
			@ 062,005 Say OemToAnsi("(+) Limite do Aprovado:  ")
			@ 062,150 Say OemToAnsi(Str(_nVlLmCad))
			@ 072,005 Say OemToAnsi("(-) Pedidos � Faturar :  ")
			@ 072,150 Say OemToAnsi(Str(_nVlPed))
			@ 082,005 Say OemToAnsi("(-) Saldo de Titulos  :  ")
			@ 082,150 Say OemToAnsi(Str(_nSldTit))
			@ 092,005 Say OemToAnsi("(+) Saldo de Titulos em Portadores Especiais         :  ")
			@ 092,150 Say OemToAnsi(Str(_nSldTPor))
			@ 102,005 Say OemToAnsi("(+) Saldo de Titulos com Percentual dentro da Tolerancia:  ")
			@ 102,150 Say OemToAnsi(Str(_nSldTPerc))
			@ 125,100 BmpButton Type 1 Action oDlgMemo:End()
			
			Activate Dialog oDlgMemo Centered
			
		Endif
		
		Return
		
	Endif

Return    
