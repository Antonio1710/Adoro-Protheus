#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � FA110SE5 � Autor � Rogerio Nutti      �Data � 12/04/2006   ���
�������������������������������������������������������������������������Ĵ��
���Descricao � PONTO DE ENTRADA Baixa de Titulos a Receber Automat FINA110���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Ad'oro Alimenticia                              ���
�������������������������������������������������������������������������Ĵ��
��� Alteracao�fwnm - 10/12/2018 - chamado n. 045499                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA110SE5()   

	// CHAMADO N. 045499 - FWNM EM 10/12/2018
	Local cPerg    := "F110FIL"
	Local cHistSE5 := ""
	// 
	
	//����������������������������Ŀ
	//� Grava ambiente inicial     �
	//������������������������������
	_sAlias := Alias()
	_sIndex := IndexOrd()
	_sRecno := Recno()
	
	dbSelectArea("SA1")
	_sAliasSA1 := Alias()
	_sIndexSA1 := IndexOrd()
	_sRecnoSA1 := Recno()
	
	//���������������������������������������������������������������Ŀ
	//� Se � baixa por Perda/PDD (MV_MOTBXRE), altera risco para "E"  �
	//�����������������������������������������������������������������
	If SE5->E5_MOTBX $ Alltrim( GETMV("MV_MOTBXRE") ) 
	
		dbSelectArea("SA1")	
		dbSetOrder(1)
		If dbSeek( xFilial("SA1")+SE5->(E5_CLIFOR+E5_LOJA ) ) 
			RecLock("SA1",.F.)
			Replace A1_RISCO With "E"
			MsUnlock()
		Endif
	
	Endif
	
	// CHAMADO N. 045499 - FWNM EM 10/12/2018
	Pergunte(cPerg, .F.)
	cHistSE5 := Upper(MV_PAR07) // Criado no PE F110FIL
	
	// Restauro pergunte padrao
	Pergunte( "FIN110", .F. )
	
	// Gravo historico informado pelo user no pergunte contido no PE F110FIL
	If !Empty(cHistSE5)
		RecLock("SE5", .F.)
			SE5->E5_HISTOR := cHistSE5
		SE5->( msUnLock() )
	EndIf
	//
	
	//����������������������������Ŀ
	//� Restaura ambiente inicial  �
	//������������������������������
	dbSelectArea(_sAliasSA1)
	dbSetOrder(_sIndexSA1)
	dbGoto(_sRecnoSA1)
	
	dbSelectArea(_sAlias)
	dbSetOrder(_sIndex)
	dbGoto(_sRecno)

Return