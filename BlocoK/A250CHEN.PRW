#INCLUDE "rwmake.ch"
#INCLUDE "PROTHEUS.CH"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  A250CHEN   � Autor � Fabricio Fran�a    � Data �  02/05/06   ���
�������������������������������������������������������������������������͹��
���Descricao � Verifica o saldo no endere�o.                              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Protheus 11  - Adoro                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function A250CHEN() 

	Local aAreaAnt	:= GetArea()	
	Local aSD4 		:= ParamIXB[1] //-- Informa��es do Empenho SD4 
	Local nItem 	:= ParamIXB[2] //-- Posi��o do Registro processado 
	Local nCampo 	:= ParamIXB[3] //-- Posi��o do Item Processado 
	Local cEnd 		:= GetMv('MV_X_ENPRO',.F.,"PRODUCAO")   	// endere�o padrao para producao

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Verifica o saldo no endere�o.')
		
    If Localiza(aSD4[1][nCampo][3])                                       
    
		RestArea(aAreaAnt)
		Return (cEnd)
	
	EndIf

	RestArea(aAreaAnt)	
	
Return