#INCLUDE "rwmake.ch"
#INCLUDE "protheus.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ADVEN045P   � Autor � Mauricio - MDS TEC � Data �  05/04/17���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de entrada executado ap�s a altera��o do cadastro do ���
���          � de clientes.                                               ���
�������������������������������������������������������������������������͹��
���Uso       �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
/*/{Protheus.doc} User Function ADVEN045P
  Ponto de entrada executado ap�s a altera��o do cadastro do de clientes.
  @type  Function
  @author Mauricio
  @since 26/05/2020
  @version 1
  @history TI - Leonardo P. Monteiro - 16/03/2022 - Grava��o no campo XCODLOJ a concatena��o do c�digo do cliente e loja.
													Rotina auxiliar para avalia��o de cr�dito na emiss�o de PVs.
  @history Everson, 18/10/2020, Chamado 18465. Envio de informa��es ao barramento.  
  @history Everson, 10/02/2023, Chamado 18465. Alterada fun��o static function para user function.  
  @history Everson, 13/02/2023, Chamado 88406. Tratamento para mensagem de erro.  
  @history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
  @history ticket TI - Antonio Domingos - 31/05/2023 - Ajuste Nova Empresa
/*/
User Function MALTCLI()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������		
	Local aArea      := GetArea()
	Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 26/05/2023
	//
	If FindFunction("U_ADVEN076") .And. cEmpAnt $ _cEmpAt1 //ticket TI - Antonio Domingos - 31/05/2023 
		U_ADVEN076("","",.F.," AND A1_COD = '" + Alltrim(cValToChar(A1_COD)) + "' AND A1_LOJA = '" + Alltrim(cValToChar(A1_LOJA)) + "' ","",.T.)
	
	EndIf
	
	RECLOCK("SA1",.F.)
        SA1->A1_XCODLOJ := SA1->A1_COD+SA1->A1_LOJA
    SA1->(MSUNLOCK())

	U_MALTCLI1(SA1->A1_COD, SA1->A1_LOJA) //Everson, 18/10/2020, Chamado 18465.

	RestArea(aArea)
	
Return Nil
/*/{Protheus.doc} grvBarr
    Salva o registro para enviar ao barramento.
    @type  User Function
    @author Everson
    @since 18/03/2022
    @version 01
/*/
User Function MALTCLI1(cCod, cLoja)

    //Vari�veis.
    Local aArea := GetArea()

	U_ADFAT27C("SA1", 1, "cadastro_de_clientes_protheus", "A", FWxFilial("SA1") + cCod + cLoja)

    If IsInCAllStack("U_ADOA005") .Or. IsInCAllStack("U_ADOA002") .Or. IsInCAllStack("U_AltCliB3")
        INCLUI := .F.
        ALTERA := .T.

    EndIf

    RestArea(aArea)

Return Nil
