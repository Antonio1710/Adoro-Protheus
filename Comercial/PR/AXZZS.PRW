/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AXZZS    � Autor � Alex Borges � Data � 21/11/11 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � AxCadastro em ZZS - Pre�o Custo JOX                        ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Adoro Alimenticia                               ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
#include "rwmake.ch"  

User Function AXZZS()

	//���������������������������������������������������������������������������Ŀ
	//�Declara��o de vari�veis.                                                   �
	//�����������������������������������������������������������������������������	
	Local bNoTTS   := {|| envSF() }    
	Local aButtons := {}
	Local aRotAdic := {}
	Aadd(aButtons,{ "SALEFORCE", {|| envSFMan() }, "Env. SF", "Env. SF" }  )
	Aadd(aRotAdic,{ "Env. SF","U_custoSfExp()", 0 , 6 })

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'AxCadastro em ZZS - Pre�o Custo JOX')

	AxCadastro("ZZS","PRECO CUSTO JOX",".T.",".T.",aRotAdic,,,, bNoTTS,,,aButtons,,)


	/*
	SetPrvt("CCADASTRO,AROTINA,")

	dbSelectArea("ZZS")
	dbSetOrder(01)
	CCadastro := "Pre�o Custo JOX   "
	aRotina := {  { "Pesquisar"     ,"AxPesqui"            , 0 , 1},;
	{ "Visualizar"    ,"axVisual"            , 0 , 2},;
	{ "Incluir   "    ,"axInclui"            , 0 , 3},;
	{ "Alterar   "    ,"axAltera"            , 0 , 4},;
	{ "Excluir   "    ,"axDeleta"            , 0 , 5}}


	mBrowse( 6, 1,22,75,"ZZS")
	*/


Return

User Function custoSfExp()

	U_ADINF009P('AXZZS' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'AxCadastro em ZZS - Pre�o Custo JOX')
	
	//
	If MsgYesNo("Deseja enviar os registros do dia " + DToC(ZZS->ZZS_DATA) + " para o SalesForce.","Fun��o AXZZS")
		envSF()
		
	EndIf

Return Nil

Static Function envSF()
	
	//
	If FindFunction("U_ADVEN073P")
		U_ADVEN073P( DToS(ZZS->ZZS_DATA),DToS(ZZS->ZZS_DATA),.F.,"")
	
	EndIf

Retur Nil
