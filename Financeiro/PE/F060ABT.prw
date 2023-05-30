#INCLUDE "PROTHEUS.CH" 
#INCLUDE "rwmake.ch"

/*/{Protheus.doc} User Function F060ABT
	Permite considerar os abatimentos no borderô para serem enviados ao banco.
	Adoro S/A - Chamado: 041841
	@type  Function
	@author Fernando Sigoli
	@since 29/05/2018
	@history Ticket 69574   - Abel Bab - 19/04/2022 - Projeto FAI	
	@history ticket TI - Antonio Domingos - 23/05/2023 - Ajuste Nova Empresa
	/*/
User Function F060ABT()
	//Local cEmpSF:= GetMv("MV_#SFEMP",,"01|") 		//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	//Local cFilSF:= GetMv("MV_#SFFIL",,"02|0B|") 	//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI

	Local lRet := .F.
	Private _cEmpFL3 := SuperGetMv("MV_#EMPFL3",.F.,"0102/010B/1301") //Codigos de Empresas+Filiais Ativas Grupo 3 //ticket TI - Antonio Domingos - 23/05/2023
	
	//If Alltrim(cEmpAnt) $ cEmpSF .and. cFilant $ cFilSF 
	If Alltrim(cEmpAnt)+Alltrim(cFilAnt) $ _cEmpFL3  //ticket TI - Antonio Domingos - 23/05/2023 

		lRet := .T. //colocamos esse ponto de entrada na montagem do bordero, para nao mais levar o ab- na conta.

	EndIf           
     
Return lRet
