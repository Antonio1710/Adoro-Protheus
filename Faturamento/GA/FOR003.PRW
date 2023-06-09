#include "rwmake.ch"

/*/{Protheus.doc} User Function FOR003
	
	@type  Function
	@author 
	@since 
	@version 01
	@history Ticket  TI     - Leonardo P. Monteiro - 26/02/2022 - Inclus�o de conouts no fonte.
	@history Ticket  83991  - Everson - 29/11/2022 - Tratamento para inclus�o de CT-e pela rotina ADFIS032P.
	@history ticket TI    - Everson - 30/11/2022 - Inclus�o de CT-e pela Ceres.
/*/

User Function FOR003()  

	Private lSfInt	:= (IsInCallStack('U_RESTEXECUTE') .OR. IsInCallStack('RESTEXECUTE'))

	//Conout( DToC(Date()) + " " + Time() + " FOR003 >>> INICIO PE" )

	//U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Verifica se o Fornecedor (atraves do conteudo da variavel) utilizando:  ExecBlock("FOR003",.F.,.F.,PARAMIXB)')

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
	//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
	//� identificando as variaveis publicas do sistema utilizadas no codigo �
	//� Incluido pelo assistente de conversao do AP5 IDE                    �
	//�����������������������������������������������������������������������

	SetPrvt("_CFORNECE,_LRETURN,_CALIAS,_CORDER,_CRECNO,_CORDERSA2")
	SetPrvt("_CRECNOSA2,")

	/*/
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	�������������������������������������������������������������������������ͻ��
	��� Programa � FOR003   � Autor � Rogerio Nutti      � Data �     17/08/00���
	�������������������������������������������������������������������������͹��
	���Descri��o � Verifica se o Fornecedor (atraves do conteudo da variavel) ���
	���          � utilizando:  ExecBlock("FOR003",.F.,.F.,PARAMIXB)          ���
	�������������������������������������������������������������������������͹��
	���Uso       � Espec�fico Ad'oro                                          ���
	�������������������������������������������������������������������������ͼ��
	�������������������������������������������������������������������������Ĵ��
	���   DATA   � Programador   �Manutencao efetuada                         ���
	�������������������������������������������������������������������������Ĵ��
	���25/04/2019�Adriana 048333 �Apresenta msg quando Fornecedor tem liminar ���
	�����������������������������������������������������������������������������
	�����������������������������������������������������������������������������
	/*/

	_cFornece := Alltrim(PARAMIXB) //Chamado: 034249 Fernando Sigoli 29/09/2017
	_lReturn  := .T.

	_cAlias := Alias()
	_cOrder := IndexOrd()
	_cRecno := Recno()

	dbSelectArea("SA2")
	_cOrderSA2 := IndexOrd()
	_cRecnoSA2 := Recno()
	dbSetOrder(1)


	if cmodulo <> "EEC" .And. ! IsInCallStack("U_ADFIS032P") .And. !IsInCallStack("U_ADFIS042P") // Incluido por Adriana, para desconsiderar quando pedido compra for gerado pelo eec //Everson - 29/11/2022 - Tratamento para inclus�o de CT-e pela rotina ADFIS032P. //Everson - 30/11/2022 - ticket TI.

		If dbSeek( xFilial("SA2")+_cFornece)

			If SA2->A2_ATIVO <> "S"
				if lSfInt
					Aadd(aPedidos,{"Fornecedor "+Alltrim(_cFornece)+"-"+ Alltrim(SA2->A2_NOME)+" inativo"})
				else
					MsgAlert("Fornecedor "+Alltrim(_cFornece)+"-"+ Alltrim(SA2->A2_NOME)+" inativo","Alerta")
				endif
				_lReturn := .F.

			Endif

			If SA2->A2_XLIMINS = "S" //incluido por Adriana Chamado 048333 em 25/04/2019
				if lSfInt
					Aadd(aPedidos,{"Fornecedor "+Alltrim(_cFornece)+"-"+ Alltrim(SA2->A2_NOME)+" com Liminar INSS !"})
				else
					MsgAlert("Fornecedor "+Alltrim(_cFornece)+"-"+ Alltrim(SA2->A2_NOME)+" com Liminar INSS !","")
				endif
			Endif
		Else
			if lSfInt
				Aadd(aPedidos,{"Fornecedor "+Alltrim(_cFornece)+"-"+ Alltrim(SA2->A2_NOME)+" nao encontrado"})
			else
				MsgAlert("Fornecedor "+Alltrim(_cFornece)+"-"+ Alltrim(SA2->A2_NOME)+" nao encontrado","Alerta")
			endif
			
			_lReturn := .F.

		Endif                      

	Endif
	
	dbSelectArea("SA2")
	dbSetOrder(_cOrderSA2)
	dbGoto(_cRecnoSA2)

	dbSelectArea(_cAlias)
	dbSetOrder(_cOrder)
	dbGoto(_cRecno)

	//Conout( DToC(Date()) + " " + Time() + " FOR003 >>> FINAL PE" )

Return(_lReturn)
