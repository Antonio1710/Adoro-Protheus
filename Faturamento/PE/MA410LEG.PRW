#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA410LEG  � Autor � MAURICIO-MDS TEC   � Data �  01/10/15   ���
�������������������������������������������������������������������������͹��
���Descricao � Legenda para cores customizadas para usuario Caio          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function MA410LEG()

	Local _aCores := PARAMIXB
	
	If __cUserID == "000559"
	
	   _aCores := {}
	   _aCores := {{"ENABLE"    ,'Pedido de Venda em Aberto'            },;
	               {"DISABLE"   ,'Pedido de Venda Encerrado'            },;
	               {"BR_AMARELO",'Pedido de Venda Liberado'             },;
	               {"BR_PRETO"  ,'Pedido de Venda ja EXCLUIDO'          },;
	               {"BR_AZUL"   ,'Pedido de Venda com Bloqueio de Regra'},;
	               {"BR_LARANJA",'Pedido de Venda com Bloqueio de Verba'}}      
	ELSE
	
		AADD( _aCores, {'BR_VIOLETA', "Pedido de Venda Doa��o Pendente Aprova��o"})
		
	Endif

Return(_aCores)