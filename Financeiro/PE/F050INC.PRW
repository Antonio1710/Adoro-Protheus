#include "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � F050INC  � Autor � Heraldo C. Hebling � Data �  08/03/2004 ���
�������������������������������������������������������������������������͹��
���Item      � PE apos confirmacao de inclusao titulos a pagar            ���
�������������������������������������������������������������������������͹��
���Descri��o � Ponto de Entrada para gravar campos Z9_NUMPA/Z9_STATUS     ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Ad'oro                                          ���
�������������������������������������������������������������������������͹��
���ALTERACAO � 051260 || OS 052577 || FINANCAS || FLAVIA || 8461          ���
���          � || TITULOS SAG - William Costa - 23/08/2019 alterado o     ���
���          � ponto de entrada para adicionar campos de banco,agencia,   ���
���          � conta e CNPJ cadastros na tabela FIL caso contrario carrega���
���          � os campos do fornecedor para todos os titulos criados      ���
�������������������������������������������������������������������������͹��
���ALTERACAO � 051326 || OS 052652 || FINANCAS || FLAVIA || 8461 ||       ���
���          � || TITULOS SAG - William Costa - 26/08/2019 alterado o     ���
���          � TRB para TRS pois ja existe fonte chamador que tem o TRB   ���
���          � no seus programas                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function F050INC()       

	//��������������������������������������������������������������Ŀ
	//� Posicionamento original dos arquivos envolvidos              �
	//����������������������������������������������������������������
	_cAlias := Alias()
	_cOrder := IndexOrd()
	_cRecno := Recno()
	
	//���������������������������������������������������������������������Ŀ
	//� Grava Informacoes em SC6                                            �
	//�����������������������������������������������������������������������
	IF !EMPTY(SE2->E2_APAGTO)
	
		dbSelectArea("SZ9")
		DBSETORDER(1)
		IF dbSeek( xFilial("SZ9") + SE2->E2_APAGTO )
			
			dbSelectArea("SZ9")
			RecLock("SZ9",.F.)
			Replace Z9_NUMPA  	With SE2->E2_NUM
			Replace Z9_STATUS  	With "3"
			MsUnlock()
			
		ENDIF
	ENDIF
	
	dbSelectArea(_cAlias)
	dbSetOrder(_cOrder)
	dbGoto(_cRecno)    
	
	//FAZ A GRAVACAO DOS DADOS BANCARIOS DO FORNECEDOR NO TITULO
	
	// ALEX BORGES - 09/01/12
	SE2->E2_DATALIB := DDatabase
	
	// *** INICIO WILLIAM COSTA 21/08/2019 CHAMADO 051260 || OS 052577 || FINANCAS || FLAVIA || 8461 || TITULOS SAG
	// *** INICIO WILLIAM COSTA 26/08/2019 CHAMADO 051326 || OS 052652 || FINANCAS || FLAVIA || 8461 || TITULOS SAG  - alterado de TRB para TRS dependendo do programa que chama ja e utilizado
	
	SqlOutBanc(SA2->A2_FILIAL,SA2->A2_COD,SA2->A2_LOJA)
	
	IF TSB->(!EOF())
				
		SE2->E2_BANCO   := TSB->FIL_BANCO
		SE2->E2_AGEN    := TSB->FIL_AGENCI
		SE2->E2_DIGAG   := TSB->FIL_DVAGE
		SE2->E2_NOCTA   := TSB->FIL_CONTA
		SE2->E2_DIGCTA  := TSB->FIL_DVCTA
		SE2->E2_CNPJ    := TSB->FIL_XCGC
	       	
    ELSE
    
    	SE2->E2_BANCO   := SA2->A2_BANCO
		SE2->E2_AGEN    := SA2->A2_AGENCIA
		SE2->E2_DIGAG   := SA2->A2_DIGAG
		SE2->E2_NOCTA   := SA2->A2_NUMCON
		SE2->E2_DIGCTA  := SA2->A2_DIGCTA
		SE2->E2_CNPJ    := IIF(EMPTY(SA2->A2_CPF),SA2->A2_CGC,SA2->A2_CPF)
         
	ENDIF
	TSB->(dbCloseArea()) 
	
	// *** FINAL WILLIAM COSTA 21/08/2019 CHAMADO 051260 || OS 052577 || FINANCAS || FLAVIA || 8461 || TITULOS SAG
	// *** FINAL WILLIAM COSTA 26/08/2019 CHAMADO 051326 || OS 052652 || FINANCAS || FLAVIA || 8461 || TITULOS SAG  - alterado de TRB para TRS dependendo do programa que chama ja e utilizado
	
RETURN(NIL)

Static Function SqlOutBanc(cFilAtu,cCodFor,cLojaFor)                          

	BeginSQL Alias "TSB"
			%NoPARSER%
			SELECT TOP(1) FIL_FORNEC,
			              FIL_LOJA,
				          FIL_BANCO,
				          FIL_AGENCI,
				          FIL_DVAGE,
				          FIL_CONTA,
				          FIL_DVCTA,
				          FIL_XCGC
			         FROM %Table:FIL% WITH (NOLOCK)
			        WHERE FIL_FILIAL  = %EXP:cFilAtu%
			          AND FIL_FORNEC  = %EXP:cCodFor%
			          AND FIL_LOJA    = %EXP:cLojaFor%
			          AND FIL_BANCO  <> ''
			          AND FIL_AGENCI <> ''
			          AND FIL_CONTA  <> ''
			          AND D_E_L_E_T_ <> '*'
			
			  ORDER BY FIL_TIPO
			
	EndSQl 
	            
RETURN(NIL) 