#include "protheus.ch"
#include "topconn.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFISA01   �Autor  �Fernando Macieira   � Data � 07/Abr/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cadastro de Tipos de Transacao.                            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function RFISA01()

Local cAlias := "ZZ0"
Local cCadastro := "Cadastro de Tipo de Transacao"    
Local cVldAlt := "u_FISA01()"
Local cVldExc := "u_FISA02()"

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Tipos de Transacao.')

axCadastro( cAlias, cCadastro, cVldExc, cVldAlt )

Return


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFISA01   �Autor  �Microsiga           � Data �  04/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function FISA01()

Local lRet := .t.

U_ADINF009P('RFISA01' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Tipos de Transacao.')

If INCLUI
	ZZ0->( dbSetOrder(1) ) // ZZ0_FILIAL+ZZ0_COD
	If ZZ0->( dbSeek( xFilial("ZZ0")+M->ZZ0_COD ) )
		lRet := .f.
		Aviso( "RFISA01-01",;
			   "Tipo de Transacao j� existente... Verifique!", {"Ok"},, "Cadastro inv�lido" )
	EndIf
EndIf
	
Return lRet


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RFISA01   �Autor  �Microsiga           � Data �  04/07/09   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function FISA02()

Local lRet := .t.
Local cQuery := ""

U_ADINF009P('RFISA01' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Tipos de Transacao.')

If Select("WorkZZ0") > 0
	WorkZZ0->( dbCloseArea() )
EndIf

cQuery := " SELECT COUNT(1) TT "
cQuery += " FROM " +RetSqlName("SF4")
cQuery += " WHERE F4_FILIAL='"+xFilial("SF4")+"' "
cQuery += " AND F4_XTM='"+ZZ0->ZZ0_COD+"' "
cQuery += " AND D_E_L_E_T_=' ' "
tcQuery cQuery New Alias "WorkZZ0"

If WorkZZ0->TT >= 1
	lRet := .f.
	Aviso( "RFISA01-02",;
			"Tipo de Transacao j� utilizada... Verifique!", {"Ok"},, "Exclusao nao permitida" )
EndIf

WorkZZ0->( dbCloseArea() )

Return lRet

