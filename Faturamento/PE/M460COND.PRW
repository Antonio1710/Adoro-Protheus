#Include "Protheus.ch"

/*/{Protheus.doc} User Function nomeFunction
	Ponto de entrada Alterar data utilizada como base para calcular o vencimento
	do titulo.                                                                    
	//PARA ALTERAR DATA DE VENCIMENTO, TENDO COMO BASE A DATA DA ENTREGA E NAO A DATA DE EMISSAO DA NOTA
	(...)
	Local dDataCnd  := SF2->F2_EMISSAO
	(...)
	If ( aEntry[EP_M460COND] )
	dDataCnd := ExecBlock("M460COND", .F., .F.,{dDataCnd})               
	@type  Function
	@author HCCONSYS
	@since 16/10/2007
	@version 01
	@history Everson, 14/10/2020, Chamado 2663 - Incluída filial 03.
	@history /Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	@history /Ticket 77755   - Fernando Macieira    - 15/08/2022 - Tratamento nos vencimentos da Filial 0A (São Carlos)
	@history ticket TI - Antonio Domingos - 20/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 24/05/2023 - Revisão Ajuste Nova Empresa 1634
/*/
User Function M460COND()

	Local aArea  := {}
	Local _DtIni := paramixb[1]  
	Local cMVFil := GetMV("MV_#VENENF",,"01/02/03/0B/0A") // @history /Ticket 77755   - Fernando Macieira    - 15/08/2022 - Tratamento nos vencimentos da Filial 0A (São Carlos)
	Local cMVEmp := GetMV("MV_#VENENE",,"01/13") // @history /Ticket 77755   - Fernando Macieira    - 15/08/2022 - Tratamento nos vencimentos da Filial 0A (São Carlos)
	Private _cEmpFLC := SuperGetMv("MV_#EMPFLC",.F.,"0102/0103/010B/010A/1301") //Codigos de Empresas+Filiais Ativas Grupo C //ticket TI - Antonio Domingos - 20/05/2023
    
	// ticket 84085 - 01/12/2022 - Fernando Macieira - TRANSFERENCIA DE ATIVO IMOBILIZADO nota fiscal não aparece no Faturamento
	If AllTrim(FUNNAME())=="ATFA060" .or. IsInCallStack("ATFA060")
		Return _DtIni
	EndIf

	aArea  := GetArea()

	//Ticket 69574   - Abel Babini          - 21/03/2022 - Projeto FAI
	//if xFilial("SC9") $  "02/03/0B	" .and. Alltrim(cEmpAnt)=="01"  //para filial VARZEA //Everson - 14/10/2020. Chamado 2665.
	If ( AllTrim(FWCodFil()) $ cMVFil .OR. AllTrim(FWxFilial("SC9")) $ cMVFil ) .and. Alltrim(FWCodEmp()) $ cMVEmp // @history /Ticket 77755   - Fernando Macieira    - 15/08/2022 - Tratamento nos vencimentos da Filial 0A (São Carlos)
		_DtIni := iif(Empty(SC9->C9_DTENTR), iif(Empty(SC6->C6_ENTREG), _DtIni, SC6->C6_ENTREG) , SC9->C9_DTENTR)    
		_DtIni := iif(_DtIni < Date(), Date(), _DtIni)  // por Adriana para não apresentar rejeicao na transmissao da nfe  em 01/08/2018 Chamado 042882
	endif 

	//
	RestArea(aArea) 

RETURN _DtIni
