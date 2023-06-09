#include "Rwmake.ch"
#include "Protheus.ch"    
#include "Topconn.ch" 
/*
���Programa  �MTA450R        �Autor  �Everson      � Data �  21/03/2018   ���
���Desc.     �Ponto de entrada para rejei��o de pedido de venda.          ���
���Uso       �Chamado 037261.                                             ���
history Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
@history ticket TI - Antonio Domingos - 23/05/2023 - Ajuste Nova Empresa
@history ticket TI - Antonio Domingos - 02/06/2023 - Valida��o Ajuste Nova Empresa
*/
User Function MTA450R()
									
	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//����������������������������������������������������������������������	
	Local aArea:= GetArea()
	//Local cEmpSF:= GetMv("MV_#SFEMP",,"01|") 		//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	//Local cFilSF:= GetMv("MV_#SFFIL",,"02|0B|") 	//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	Local _cEmpFL3 := SuperGetMv("MV_#EMPFL3",.F.,"0102/010B/1301") //Codigos de Empresas+Filiais Ativas Grupo 3 //ticket TI - Antonio Domingos - 23/05/2023
	Local _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 02/06/2023

	//
	//If !(Alltrim(cEmpAnt) == "01")
	If !(Alltrim(cEmpAnt) $ _cEmpAt1) //ticket TI - Antonio Domingos - 02/06/2023 
		RestArea(aArea)
		Return Nil
		
	EndIf
	
	//
	//If Findfunction("U_ADVEN050P") .And. Alltrim(cEmpAnt) $ cEmpSF .And. Alltrim(cFilAnt) $ cFilSF
	If Findfunction("U_ADVEN050P") .And. Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ _cEmpFL3 //ticket TI - Antonio Domingos - 23/05/2023 
		If Upper(Alltrim(cValToChar(GetMv("MV_#SFATUF"))) ) == "S"
			U_ADVEN050P(,.F.,.T., " AND C5_NUM IN ('" + SC9->C9_PEDIDO + "') AND C5_XPEDSAL <> '' " ,.F.)
		
		EndIf				

	EndIf
	
	//
	RestArea(aArea)
	
Return Nil
