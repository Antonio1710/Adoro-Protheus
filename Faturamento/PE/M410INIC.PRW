#Include "RwMake.ch"
#Include "Protheus.ch"
#Include "Topconn.ch"
#Include "TbiConn.ch"
#Include "TbiCode.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � M410INIC � Autor � Mauricio - MDS TEC � Data � 29/06/2016  ���
�������������������������������������������������������������������������͹��
��� Desc.    � PE para atualizar dados do cabecalho do pedido de venda com���
���          � dados de tabela do atendimento de call center(TECLAN)      ���
�������������������������������������������������������������������������͹��
��� Uso      � ADORO                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
// ---------+-------------------+-----------------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                       | Chamado
// ---------+-------------------+-----------------------------------------------------------------+---------------
// 09/05/18 | Ricardo Lima      | Valida permiss�o do vendedor na tela de pedido de vendas        |
// ---------+-------------------+-----------------------------------------------------------------+---------------
@history Ticket  TI     - Leonardo P. Monteiro - 26/02/2022 - Inclus�o de conouts no fonte. 
@history ticket TI - Antonio Domingos - 20/05/2023 - Ajuste Nova Empresa
@history ticket TI - Antonio Domingos - 23/05/2023 - Revis�o Ajuste Nova Empresa
/*/

User Function M410INIC()

	Local _cAlias 		:= Alias()
	Local _cOrder 		:= IndexOrd()
	Local _cRecno 		:= Recno()

	Private _nTcConn1	:= advConnection()
	Private lSfInt		:= (IsInCallStack('U_RESTEXECUTE') .OR. IsInCallStack('RESTEXECUTE'))
	Private _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 20/05/2023
	//Conout( DToC(Date()) + " " + Time() + " M410INIC >>> INICIO PE" )

	/* 
	INICIO Retirada trecho de fonte para o chamado 041995 || TECNOLOGIA || FERNANDO_SIGOLI || 8451 || FONTES DO TECLAN WILLIAM COSTA 07/06/2018 
	// parametros para conexao DBINTECLAN
	cBanco         := "MSSQL/DBINTECLAN"    // Nome do Banco(MSSQL7)/Nome do Ambiente(Fonte ODBC) no TOPCONNECT
	cServidor      := "10.5.1.2"  			  // Nome do Servidor onde fica o Ambiente(Fonte ODBC)
	FINAL Retirada trecho de fonte para o chamado 041995 || TECNOLOGIA || FERNANDO_SIGOLI || 8451 || FONTES DO TECLAN WILLIAM COSTA 07/06/2018 
	*/
	// Ricardo Lima - 09/05/18
	//ticket TI - Antonio Domingos - 20/05/2023
	If Alltrim(cEmpAnt) $ _cEmpAt1  .and. !lSfInt  // Somente para a Empresa AD'oro
		dbSelectArea("SA3")
		dbSetOrder(7)
		If dbSeek(xFilial("SA3")+__cUserID)
				If SUBSTR(SA3->A3_XVLDPER,1,1) = '1'
				ApMsgInfo('Vendedor sem PERMISS�O para Incluir Pedido, verifique com a Supervis�o!','Permiss�es de Vendedores')
				Return(.F.)
			Endif
		Endif
	Endif

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrder)
	dbGoto(_cRecno)

	//Conout( DToC(Date()) + " " + Time() + " M410INIC >>> FINAL PE" )

Return()
