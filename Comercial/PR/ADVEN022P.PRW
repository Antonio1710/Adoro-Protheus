#INCLUDE "Protheus.ch"


//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �ADVEN022P � Autor � WILLIAM COSTA      � Data �  07/06/2016 ���
//�������������������������������������������������������������������������͹��
//���Descricao � Cadastro da tabela ZB7 de/para de codigo de barras para o  ���
//���          � EDI.                                                       ���
//�������������������������������������������������������������������������͹��
//���Uso       � SIGAFAT                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������


User Function ADVEN022P()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	
	Local cVldAlt := ".T." // Validacao para permitir a alteracao. Pode-se utilizar ExecBlock.
	Local cVldExc := ".T." // Validacao para permitir a exclusao. Pode-se utilizar ExecBlock.
	
	Private cString := "ZB7"
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro da tabela ZB7 de/para de codigo de barras para o EDI')
	
	dbSelectArea("ZB7")
	dbSetOrder(1)
	
	AxCadastro("ZB7","Cadastro de Codigo de Barras EDI",cVldExc,cVldAlt)

Return(NIL)
