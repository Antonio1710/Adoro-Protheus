#INCLUDE "rwmake.ch"
#include "Protheus.ch"
/*/
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
����������������������������������������������������������������������������ͻ��
���Programa  �          � Autor � ADRIANO SAVOINE    � Data �  29/07/2019 	 ���
����������������������������������������������������������������������������͹��
���Descri��o � Programa para alteracao do parametro MV_#QTDREF               ���
���          �                                                               ���
����������������������������������������������������������������������������͹��
���Chamado:  � Chamado: 050739                                               ���
���				Foi desenvolvido para a Rosangela alterar a Qtd de Referencia���
���          | de caixas para os pedidos de venda, hoje � obrigatorio 15 cx  ���
���          | porem ela pode alterar para uma quantidade menor.             ���                                             
����������������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������������
��������������������������������������������������������������������������������
/*/
User Function ADFIS034P()

Local aAreaAnt := GetArea()
Local cUsr     := Alltrim(SuperGetMv("MV_#QTREFU", .F. , '',))
Local cCaixa   := Alltrim(cValToChar(GetMv("MV_#QTDREF")))

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Programa para alteracao do parametro MV_#QTDREF ')

IF Alltrim(cValToChar(__cUserId))$ cUsr
	IF MsgBox("A Quantidade Atual Obrigatoria de Caixas para Pedidos de Venda � de: " + CVALTOCHAR(GETMV("MV_#QTDREF")) +"."+ CHR(13)+ CHR(13)+ "Deseja alterar o par�metro?"," Altera par�metro MV_#QTDREF ","YESNO")

		IF(PERGUNTE("ADFIS034P"))
		PutMv("MV_#QTDREF",(MV_PAR01)) 
		ENDIF
		
		//gera log de reprogramacao
		u_GrLogZBE (Date(),TIME(),cUserName," REPROGRAMACAO","FISCAL","ADFIS034P",;
	    "REFATURAMENTO CAIXAS - De "+ cCaixa + " Para " + CVALTOCHAR(GETMV("MV_#QTDREF")),ComputerName(),LogUserName())
									

	ENDIF
ELSEIF Alert("Seu Usuario do Protheus n�o pode alterar a Quantidade de Caixas Obrigatoria para Pedidos de Venda.")
	
ENDIF
	

RestArea(aAreaAnt)


Return 