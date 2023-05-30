///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Função            : MT103IPC                                                                              //
// Autor             : Mauricio - HC Consys                                                                  //
// Data criação      : 06/07/2009                                                                            //
// Descrição         : Grava campo projeto na NF de entrada com campo projeto do Pedido de Compra.Cham.004603//
// Parâmetros        : nenhum                                                                                //
// Retorno           : nenhum                                                                                //
// Utilização        : Empresa Adoro                                                                         //
// ----------------------------------------------------------------------------------------------------------//
// ALTERAÇÕES EFETUADAS                                                                                      //
// Nº | Data        | Programador         | Descrição                                                        //
// 01 |             |                     |                                                                  //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
  @history Everson, 13/03/2023, ticket 18465 - Tratamento para os dados do pedido de compra não substituir os dados da NF, quando a entrada da nota vier pela rotina U_INTNFEB.
  @history Jonathan, 06/04/2023, ticket 91493 - Tratamento para pegar valores por item lançado e Trocado campo D1_DESC para D1_VALDESC
  @history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
  @history ticket TI - Antonio Domingos - 22/05/2023 - Revisão Ajuste Nova Empresa
  @history ticket TI - Antonio Domingos - 24/05/2023 - Correção Ajuste Nova Empresa
*/
//   JUNTAR COM PE DA PRODUCAO
#INCLUDE "rwmake.ch"

User Function MT103IPC()

	//Alteração 01 - INÍCIO
	Local _cOldArea
	Local _nTipPro	 := 0
	Local _nPosPedido  := 0
	Local _nPosAliqIPI := 0
	Local _nOrdemSC7   := 0
	Local _nPosValIPI  := 0
	Local _nCntaCol    := 0  
	Local cFiliais     := Alltrim(GetMv("MV_#FAT171",,""))
	Local nPQuant      := 0
	Local nPVunit	   := 0
	Local nPTotal	   := 0	
	Local nPDesc       := 0
	Private _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - Antonio Domingos - 23/05/2023


	_cOldArea := GetArea() //Salva área atual 

	if cEmpAnt $ _cEmpAt1

		_nPosPedido   := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_PEDIDO"})
		_nPosItem	  := aScan(aHeader,{|x|AllTRim(x[2]) == "D1_ITEMPC"})
		_nPosVerba    := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_PROJETO"})

		_cDoc		  := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_DOC"})
		_cSerie		  := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_SERIE"})
		_cFornec	  := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_FORNECE"})
		_cLoja		  := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_LOJA"})
		_cItem		  := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_ITEM"})
		_cProd		  := aScan(aHeader,{|x|AllTrim(x[2]) == "D1_COD"})

		_nOrderSC7	:= SC7->( RetIndex() )

		SC7->( dbSetOrder(1) )

		For _nCntaCol := 1 to Len(aCols)
			
			SC7->( dbSeek(xFilial("SC7")+aCols[_nCntaCol][_nPosPedido]+aCols[_nCntaCol][_nPosItem]))
			
			If SC7->( Found() )
				aCols[_nCntaCol][_nPosVerba] := SC7->C7_PROJETO

			EndIf

			If cFilAnt $cFiliais .And. IsInCallSTack("U_INTNFEB")

				//Ticket 91493 - Jonathan 06/04/2023
				nPQuant := aScan(aItens[_nCntaCol],{|x|AllTrim(x[1]) == "D1_QUANT"})
				nPVunit := aScan(aItens[_nCntaCol],{|x|AllTrim(x[1]) == "D1_VUNIT"})
				nPTotal := aScan(aItens[_nCntaCol],{|x|AllTrim(x[1]) == "D1_TOTAL"})
				nPDesc  := aScan(aItens[_nCntaCol],{|x|AllTrim(x[1]) == "D1_VALDESC"})

				//Ticket 91493 - Jonathan 06/04/2023
				aCols[_nCntaCol][aScan(aHeader,{|x|AllTrim(x[2]) == "D1_QUANT"})] := aItens[_nCntaCol][nPQuant][2]  
				aCols[_nCntaCol][aScan(aHeader,{|x|AllTrim(x[2]) == "D1_VUNIT"})] := aItens[_nCntaCol][nPVunit][2]
				aCols[_nCntaCol][aScan(aHeader,{|x|AllTrim(x[2]) == "D1_TOTAL"})] := aItens[_nCntaCol][nPTotal][2]
				aCols[_nCntaCol][aScan(aHeader,{|x|AllTrim(x[2]) == "D1_VALDESC"})] := aItens[_nCntaCol][nPDesc][2]

			EndIf

		Next _nCntaCol

		SC7->( dbSetOrder(_nOrderSC7) )


	endif

	RestArea(_cOldArea) // Devolve área atual 

Return(Nil)

