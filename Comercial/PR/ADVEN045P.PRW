#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ADVEN045P� Autor � Mauricio - MDS TEC � Data �  05/04/17   ���
�������������������������������������������������������������������������͹��
���Descricao � Tela para cadastro de valor minimo por segmento para pedido���
���          � de venda.                                                  ���
�������������������������������������������������������������������������͹��
���Uso       � ESPEC�FICO A'DORO                                          ���
�������������������������������������������������������������������������͹��
���Everson 15/05/2019. Chamado 049064. Removida rotina de envio de        ���
���altera��o pedido m�nimo do segmento. para o Salesforce.                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
User Function ADVEN045P() // U_ADVEN045P()
	
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������
	Local bNoTTS   := {|| envSF() }    
	Local aButtons := {}
	Local aRotAdic := {}
	//Aadd(aButtons,{ "SALEFORCE", {|| envSFMan() }, "Env. SF", "Env. SF" }  )
	//Aadd(aRotAdic,{ "Env. SF","U_vlrMinSfExp()", 0 , 6 })

	dbSelectArea("ZBP")
	dbSetOrder(1)

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Tela para cadastro de valor minimo por segmento para pedido de venda')

	//AxCadastro("ZBP",OemToAnsi("Valor minimo por segmento(PV)"),".T.",".T.",aRotAdic,,,, bNoTTS,,,aButtons,,) //Everson 15/05/2019. Chamado 049064.
	AxCadastro("ZBP",OemToAnsi("Valor minimo por segmento(PV)"),".T.",".T.")

Return()

//Everson 15/05/2019. Chamado 049064.
/*User Function vlrMinSfExp()
	
	//
	If MsgYesNo("Deseja enviar os registros relacionados a este segmento " + Alltrim(cValToChar(ZBP->ZBP_CODSEG)) + " para o SalesForce?","Fun��o ADVEN045P")
		envSF()
		
	EndIf

Return Nil

Static Function envSF()
	
	//
	If FindFunction("U_ADVEN076P")
		U_ADVEN076P("","",.F., " AND A1_SATIV1 = '" + Alltrim(cValToChar(ZBP->ZBP_CODSEG)) + "' ","VLRMIN",.T.," Alt - Valor m�nimo do pedido ")
	
	EndIf

Retur Nil*/