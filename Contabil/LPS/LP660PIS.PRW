#Include "rwmake.ch"

User Function LP660PIS()

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP660PIS  �Autor  �hcconsys            � Data �  28/03/07   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este LP retorna dados para o LP 660 (Nf de entrada         ���
���          � o valor referente a retencao do pis quando existe retencao ���
���          � na entrada da nota fiscal                                  ���
�������������������������������������������������������������������������͹��
���Uso       � Chamada no LP 660                                          ���
���          � Protheus 710/811                                           ���
�������������������������������������������������������������������������͹��
���Atualiz.  �                                                            ���
|��          � - alterado l�gica de memoria��o dos alias (getarea).       ���
|��          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

// Defini��o das vari�veis.  


Local _aArea   	:= GetArea()
Local _aAreaSF1	:= SF1->(GetArea() )
Local _aAreaSE2	:= SE2->(GetArea() )

Local _nvlRetPis   := 0
Local _cUniao		:= SuperGetMv("MV_UNIAO") + " "   // Codigo Fornecedor 
Local _cLojaUniao	:= "00" // Numero da Loja 
Local _cEspecie := IF(EMPTY(SF1->F1_ESPECIE),"NF",SF1->F1_ESPECIE)  

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

// CT5_VALOR = IF(SF4->(F4_XCTB=="S".AND. SF4->F4_XTM="E01"),SF1->F1_VALPIS,0)

//SF4->F4_XCTB=="S".AND.SF4->F4_XTM$"E01/E04".AND.SD1->D1_TIPO<>"D"

If SF4->F4_XCTB == "S" .AND. SF4->F4_XTM $ "E01/E04" .And. SD1->D1_TIPO <> "D" 

	// ***************** INICIO ALTERACAO CHAMADO 024322 ********************************************** //
    SqlTitPag(Xfilial("SE2"),SF1->F1_FORNECE,SF1->F1_LOJA,SF1->F1_SERIE,SF1->F1_DOC)
        
	/*BEGINDOC
	//����������������������������������������������������������������������������������������������������������Ŀ
	//�apos a atualizacao do sistema protheus no dia 03/08/2015, passou-se no momento do estorno da classificacao�
	//�da nota de entrada foi alterado pela totvs, anteriormente fazia o seguinte processo:                      �
	//�ESTORNO NF COMPRAS -> LANCAMENTOS PADROES -> EXCLUSAO DO TITULO                                           �
	//�agora com a alteracao ficou assim                                                                         �
	//�ESTORNO NF COMPRAS -> EXCLUSAO DO TITULO -> LANCAMENTOS PADROES                                           �
	//�portanto foi refeito esse select para ler arquivos do SE2 deletados mais ordenado por R_E_C_N_O_          �
	//�para garantir que pegue o ultimo excluido.                                                                �
	//�EXPLICACAO POR WILLIAM COSTA                                                                              �
	//������������������������������������������������������������������������������������������������������������
	ENDDOC*/
    
    While TRB->(!EOF())
    				
    	_nVlRetPis	+= TRB->E2_VALOR  // VALOR DE RETENCAO DE CSLL 
		       	
        TRB->(dbSkip())
	ENDDO
	TRB->(dbCloseArea()) 
	
Endif


// Restaura �reas de trabalho.
RestArea(_aArea) 
RestArea(_aAreaSF1)
RestArea(_aAreaSE2) 


// Retorna dado para o LP.

Return(_nVlRetPis)

Static Function SqlTitPag(cFil,cFornece,cLoja,cPrefixo,cDoc)                        

	BeginSQL Alias "TRB"
			%NoPARSER% 
			SELECT TOP(1) SE2_AUX.E2_VALOR
					 FROM %Table:SE2% SE2 WITH(NOLOCK) 
					 INNER JOIN %Table:SE2% SE2_AUX WITH(NOLOCK) 
					  ON SE2_AUX.E2_FILIAL  = SE2.E2_FILIAL 
					 AND SE2_AUX.E2_FORNECE = 'UNIAO'
					 AND SE2_AUX.E2_LOJA    = '00'
					 AND SE2_AUX.E2_PREFIXO = SE2.E2_PREFIXO
					 AND SE2_AUX.E2_NUM     = SE2.E2_NUM
					 AND SE2_AUX.E2_PARCELA = SE2.E2_PARCPIS 
			       WHERE SE2.E2_FILIAL      = %EXP:cFil%
					 AND SE2.E2_FORNECE     = %EXP:cFornece%
					 AND SE2.E2_LOJA        = %EXP:cLoja%
					 AND SE2.E2_PREFIXO     = %EXP:cPrefixo%
					 AND SE2.E2_NUM         = %EXP:cDoc%
					    
					  ORDER BY SE2_AUX.R_E_C_N_O_ DESC
    EndSQl             
RETURN(NIL) 

