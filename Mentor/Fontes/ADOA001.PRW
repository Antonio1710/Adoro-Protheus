#INCLUDE "PROTHEUS.CH"
#INCLUDE "TOPCONN.CH"

/*��������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ADOA001  � Autor � Microsiga             � Data � 22/07/09 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Cadastro de Departamentos.                                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Adoro - Cadastro espelho de ciente e aprovacao de credito  ���
�������������������������������������������������������������������������Ĵ��
���Analista  � Data/Bops/Ver �Manutencao Efetuada                         ���
�������������������������������������������������������������������������Ĵ��
���          �        �      �                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function ADOA001

Local aArea			:= GetArea()

Private cCadastro	:= "Cadastro de Departamentos"
Private cString		:= "PB0"

Private aRotina		:=	{	{"Pesquisar"	,"AxPesqui"							,0,1} ,;
							{"Visualizar"	,"AxVisual(cString, RecNo(), 2)"	,0,2} ,;
							{"Incluir"		,"AxInclui(cString, RecNo(), 3)"	,0,3} ,;
							{"Alterar"		,"AxAltera(cString, RecNo(), 4)"	,0,4} ,;
							{"Excluir"		,"u_ADOA1EXC(cString, RecNo(), 5)"	,0,5} }


U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Departamentos')
dbSelectArea(cString)
dbSetOrder(1)
mBrowse( 6,1,22,75,cString)
RestArea( aArea )

Return Nil       

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � ADOA1EXC � Autor � Microsiga          � Data �  22/07/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Rotina para validar a exclusao do departamento.            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro - Cadastro espelho de ciente e aprovacao de credito  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/ 

User Function ADOA1EXC(cString, nReg, nOpc)

Local lVal		:= .T.
Local aArea		:= GetArea()
Local aAreaPB1	:= PB1->( GetArea() )

U_ADINF009P('ADOA001' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Departamentos')

//------------------------------------------
//Valida se o departamento pode ser excluido
//------------------------------------------
DbSelectArea("PB1") // Amarracao Depto x Usuario x Nivel
DbSetorder(2) //FILIAL + DEPTO
If DbSeek( xFilial("PB1") + PB0->PB0_CODIGO ) 
	lVal := .F.
EndIf

DbSelectArea("PB0")
RestArea( aAreaPB1 )
RestArea( aArea )

If !lVal
	MsgAlert('Este Departamento est� sendo utilizado na amarra��o Depto x Usu�rio x N�vel. N�o pode ser exclu�do.')
	Return Nil
Else
	AxDeleta(cString,nReg,nOpc)
	Return Nil
EndIf

Return Nil