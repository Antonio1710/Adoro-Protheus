#INCLUDE "RWMAKE.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � F240TBOR � Autor � EVERALDO CASAROLIg � Data �  20/08/2007 ���
�������������������������������������������������������������������������͹��
���Item      � PE apos confirmacao do Bordero                             ���
�������������������������������������������������������������������������͹��
���Descri��o � Ponto de Entrada para atualizar os campos Banco, Agencia e ���
���          � Conta do Fornecedor no SE2.                                ���
�������������������������������������������������������������������������͹��
���ALTERACAO � WILLIAM COSTA - 27/08/2019 - 051344 || OS 052668 ||        ���
���          � FINANCAS || BIANCA || 8408 || FATURA - Ao retirar o ponto  ���
���          � de entrada do Protheus, foi identificado que as faturas    ���
���          � ficavam sem preencher banco agencia e conta foi voltado o  ���
���          � programa em producao                                       ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Ad'oro                                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
@history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
@history ticket TI - Antonio Domingos - 30/05/2023 - Ajuste Nova Empresa
/*/

USER FUNCTION F240TBOR()

	LOCAL CVAR := GETAREA() 
	Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 26/05/2023

	RecLock("SE2",.F.)
	
	IF ALLTRIM(SE2->E2_TIPO) == 'FT'
	
		IF EMPTY(SE2->E2_CNPJ)
		
			SE2->E2_BANCO  := POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_BANCO")
			SE2->E2_AGEN   := ALLTRIM(POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_AGENCIA"))
			SE2->E2_DIGAG  := ALLTRIM(POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_DIGAG"))
			SE2->E2_NOCTA  := ALLTRIM(POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_NUMCON"))
			SE2->E2_DIGCTA := ALLTRIM(POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_DIGCTA"))
			SE2->E2_NOMCTA := SUBSTR(ALLTRIM(POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_NOME")),1,30)
			      
			IF  alltrim(cEmpAnt) $ _cEmpAt1 //ticket TI - Antonio Domingos - 30/05/2023 - Ajuste Nova Empresa
			
				SE2->E2_CNPJ  :=IF(EMPTY(POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CPF")),POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CGC"),POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CPF"))
				
			ELSE
			
				SE2->E2_CNPJ  := POSICIONE("SA2",1,XFILIAL("SA2")+SE2->E2_FORNECE+SE2->E2_LOJA,"A2_CGC")
				
			ENDIF
		
		ENDIF     
	ENDIF
	
	MsUnlock()
	
	RESTAREA(CVAR)

RETURN(NIL)
