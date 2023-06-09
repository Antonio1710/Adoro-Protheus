#INCLUDE "PROTHEUS.CH"
#INCLUDE "RWMAKE.CH"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �STATUZAM  � Autor �Erike Yuri da Silva    � Data �04/02/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualiza o campo ZAM_STATUS na tabela de digitacao de inventa���
���          �rio informando que ja foi feito o acerto do inventario para ���
���          �o produto lido.                                             ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �EPCP002                                                     ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function StatusZAM(cLog,cNumInv,lEstorno)
Default lEstorno := .F.

U_ADINF009P('EPCPXFUN' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Atualiza o campo ZAM_STATUS na tabela de digitacao de inventario informando que ja foi feito o acerto do inventario para o produto lido.')

ZAM->(dbSetOrder(4))
IF ZAM->(dbSeek(xFilial("ZAM")+cNumInv))
	RecLock("ZAM",.F.)
		If lEstorno
			ZAM->ZAM_STATUS := "3"
		Else	
			If cLog == "B2BF" .Or. cLog == "B2D3" .Or. cLog == "S/OP" .Or.cLog == "SB2 " .Or.;
			   cLog == "ERRO" .Or. cLog == "SBF0" .Or. cLog == "SB2-"  
				ZAM->ZAM_STATUS := "4"	
			ElseIF cLog <> "NULO"
				ZAM->ZAM_STATUS := "2"
			Endif
			ZAM->ZAM_DTPROC  := dDataBase
		Endif	
	ZAM->(MsUnLock())
Endif

Return
                  
/*
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �PesqHist  �Autor  �Eduardo Fernandes      � Data �  22/08/06   ���
����������������������������������������������������������������������������͹��
���Descricao �Pesquisa se existe o historico gravado para o vetor	         ���
����������������������������������������������������������������������������͹��
���Parametros�aVet    - Vetor onde sera efetuado a busca                     ���
���			 �cNumInv - Chave de pesquisa				                     ���
����������������������������������������������������������������������������͹��
���Retorno   �Nao se aplica                                                  ���
����������������������������������������������������������������������������͹��
���Analista      � Data   �Bops  �Manutencao Efetuada                        ���
����������������������������������������������������������������������������͹��
���              �        �      �                                           ���
����������������������������������������������������������������������������͹��
���Uso       �14612 - CMP		                                         ���
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
*/                                                                                              

User Function PesqHist(aVet,cNumInv)

Local lRet   := .T. 
Local nAchou := 0

U_ADINF009P('EPCPXFUN' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Pesquisa se existe o historico gravado para o vetor')

nAchou:=Ascan(aVet,{|x| x[1] == cNumInv})                    

If nAchou > 0
	lRet := .F.
EndIf

Return lRet                                                

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    �TOTALZAM  � Autor �Eduardo Fernandes      � Data �04/02/2006���
�������������������������������������������������������������������������Ĵ��
���Descri��o �Atualiza os campos da pasta Totais da tabela de digitacao   ���
���          �do inventario, totalizando as quantidades das OPs que foram ���
���          �processadas sem erros. Quando o estorno e concluido, zera os���
���          �campos numericos e grava a data de estorno (ZAM_DTESTOR).    ���
�������������������������������������������������������������������������Ĵ��
��� Uso      �EPCP002 e EPCP006                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function TotalZAM(cNumInv,lEstorno,nDif,nSaldIni,nSaldFim)
Local aAreaZAM	:= GetArea("ZAM") 

Default lEstorno := .F. 
Default nDif     := 0
Default nSaldIni := 0
Default nSaldFim := 0

U_ADINF009P('EPCPXFUN' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Atualiza os campos da pasta Totais da tabela de digitacao do inventario, totalizando as quantidades das OPs que foram processadas sem erros. Quando o estorno e concluido, zera os campos numericos e grava a data de estorno (ZAM_DTESTOR).')

ZAM->(dbSetOrder(4))
IF ZAM->(dbSeek(xFilial("ZAM")+cNumInv))
	RecLock("ZAM",.F.)
		If lEstorno
			ZAM->ZAM_DTESTO := dDatabase
		Endif	
		ZAM->ZAM_QTDINI  := nSaldIni
		ZAM->ZAM_QTDFIM  := nSaldFim
		ZAM->ZAM_DIF     := nDif						
	ZAM->(MsUnLock())	
Endif
RestArea(aAreaZAM)

Return
                  