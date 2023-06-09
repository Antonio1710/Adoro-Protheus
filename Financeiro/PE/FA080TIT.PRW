#include "rwmake.ch"   

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � FA080TIT � Autor � Rogerio Nutti      �Data � 19/12/2001   ���
�������������������������������������������������������������������������Ĵ��
���Descricao � PONTO DE ENTRADA Baixa de Titulos a Pagar                  ���
���          � Mensagem de Adiantamento a Fornecedor                      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Ad'oro Alimenticia                              ���
�������������������������������������������������������������������������Ĵ��
��� Alteracao� 26/05/2004 - Heraldo                                       ���
���          � Incluido o procedimento de atualizacao da Tabela SZ9       ���
���          � quando for pagamento antecipado de frete.                  ���
�������������������������������������������������������������������������Ĵ��
���Chamado   � n. 051017 - Desenvolver tratativa no estorno e             ���
���          � cancelamento na mesma data da baixa - TI - FWNM - 09/09/19 ���
��������������������������������������������������������������������������ٱ�  
�����������������������������������������������������������������������������
��� Alterado em 20/02/2014 por Luciano Mafra atendendo o chamado N�18577  ���  
�����������������������������������������������������������������������������
*/

User Function FA080TIT()    

	Local lRet := .t.
	Local dDataFin := GetMV("MV_DATAFIN")

	SetPrvt("_SALIAS,_SINDEX,_SRECNO,_NVALBX,_SNUMF1,_SNUMD1")
	SetPrvt("_NPERC,_NVALRAT,_CFORNECE,_CNOMFOR,_SINDE2,_SNUME2")
	SetPrvt("_NCONTFOR,CTELAENTR,_cMens,")
	
	//����������������������������Ŀ
	//� Grava ambiente inicial     �
	//������������������������������
	_sAlias := Alias()
	_sIndex := IndexOrd()
	_sRecno := Recno()        
	
	//�������������������������������������������������Ŀ
	//� Chamado N�18577
	//���������������������������������������������������                                                                            
	IF DBAIXA != Ddatabase
	   ALERT("Data de Pagamento Diferente da Data Base do Sistema")
	   RETURN .F.
	endif 
	
	// Chamado n. 051017 - Desenvolver tratativa no estorno e cancelamento na mesma data da baixa - FWNM - 09/09/2019
	If dDataBase < dDataFin
		lRet := .f.
		Aviso("FA080TIT-01", "Baixa n�o permitida! Financeiro bloqueado nesta data. Ajuste a database ou contate o departamento financeiro...",{"OK"},, "MV_DATAFIN: " + DtoC(dDataFin))
	EndIf

	If lRet
		If dBaixa < dDataFin
			lRet := .f.
			Aviso("FA080TIT-02", "Baixa n�o permitida! Financeiro bloqueado nesta data. Ajuste o campo 'Data Pagto.' ou contate o departamento financeiro...",{"OK"},, "MV_DATAFIN: " + DtoC(dDataFin))
		EndIf
	EndIf

	If lRet
		If dDebito < dDataFin
			lRet := .f.
			Aviso("FA080TIT-03", "Baixa n�o permitida! Financeiro bloqueado nesta data. Ajuste o campo 'Data Debito' ou contate o departamento financeiro...",{"OK"},, "MV_DATAFIN: " + DtoC(dDataFin))
		EndIf
	EndIf
	
	Return lRet
	//

	//�������������������������������������������������Ŀ
	//� Rotina de aviso de Adiantamento de Fornecedores �
	//���������������������������������������������������
	_cFornece := SE2->E2_FORNECE
	_cNomFor  := SE2->E2_NOMFOR
	
	If SE2->E2_TIPO = "PFA"
		dbSelectArea("SZ9")
		dbsetorder(1)
		If dbSeek( xFilial("SZ9")+SE2->E2_APAGTO)
			RecLock("SZ9",.F.)
			Z9_DTPGTO := DDATABASE
			Z9_STATUS := "3"	
			Msunlock()
		Endif
		
	Endif
	
	dbSelectArea("SE2")
	_sAliasSE2 := Alias()
	_sIndexSE2 := IndexOrd()
	_sRecnoSE2 := Recno()
	dbSetOrder(14)  // E2_FILIAL+E2_TIPO+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_FORNECE+E2_LOJA
	
	//�������������������������������������������������Ŀ
	//� Posiciona o primeiro titulo do Tipo PA          �
	//���������������������������������������������������
	If dbSeek( xFilial("SE2")+"PA " )
	
	   //�������������������������������������������������Ŀ
	   //� Faz a leitura dos titulos do Fornecedor         �
	   //���������������������������������������������������
	   Do While !Eof() .and. Alltrim(E2_TIPO) == "PA"
	   
	      //�������������������������������������������������Ŀ
	      //� Despreza titulos diferentes de PA               �
	      //���������������������������������������������������
	      If _cFornece # SE2->E2_FORNECE
	         dbSkip()
	         Loop
	      Endif
	      
	      //�����������������������������������������������������������������������Ŀ
	      //� Se achou PA do Forneceodor e valor > 0, apresenta msg e sai do laco   �
	      //�������������������������������������������������������������������������
	      If E2_SALDO >0
	         _cMens := OemToAnsi("Este titulo foi baixado,  porem existem titulos  de ")          +Chr(13)
	         _cMens := _cMens + OemToAnsi("de Adiantamento deste fornecedor ainda nao baixados.") +Chr(13)
	         _cMens := _cMens + OemToAnsi(_cFornece + " - " + _cNomFor                          ) +Chr(13)
	         _cMens := _cMens + OemToAnsi("Verifique e cancele a baixa antes de emitir cheques.")  +Chr(13)
	         _cMens := _cMens + OemToAnsi("Efetue a Baixa por compensacao dos titulos PA (Pagto Antecipado).") +Chr(13)
	         MsgBox(_cMens,"ATENCAO","ALERT")
	         Exit
	      Endif
	      dbSkip()
	   Enddo  
	   
	Endif
	
	//����������������������������Ŀ
	//� Restaura ambiente inicial  �
	//������������������������������
	dbSelectArea(_sAliasSE2)
	dbSetOrder(_sIndexSE2)
	dbGoto(_sRecnoSE2)
	
	dbSelectArea(_sAlias)
	dbSetOrder(_sIndex)
	dbGoto(_sRecno)

Return  .T.