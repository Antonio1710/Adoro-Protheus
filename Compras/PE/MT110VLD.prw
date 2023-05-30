#INCLUDE "Topconn.ch"
#INCLUDE "Protheus.ch"
/*ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±ºPrograma    ³MT110VLD³Ponto de Entrada que valida o registro na solicitação de compras º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºAutor       ³01/08/12 Ana Helena                                                       º±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºPonto de entrada executado ao clicar nos botões incluir / alterar / excluir / copiar daº±±
±±ºsolicitacao de compras. ExpN1: Contém o valor da operação selecionada:                 º±±
±±º                                       3- Inclusão, 4- Alteração, 8- Copia, 6- Exclusãoº±±
±±ÌÍÍÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
@history Jonathan Carvalho, 01/11/2022, Chamado 82195 incluido o GetArea e RestArea para pegar o Numero da Solicitação SC1->C1_NUM
@history Everson, 22/12/2022, Ticket TI - Adicionada validação de usuário para todas empresas/filiais e para todos os centros de custo.

*/

User Function MT110VLD()

	Local aArea    := GetArea() //Jonathan Carvalho 01/11/2022 - tkt 82195
	Local ExpN1    := Paramixb[1]
	Local ExpL1    := .T. 

	If ExpN1 <> 3 .And. ExpN1 <> 8
		
		// If (cEmpAnt $ _cEmpAt1 .And. cFilAnt == "03") .Or. cEmpAnt == "07" //Everson, 22/12/2022, Ticket TI.

			cNumSC := SC1->C1_NUM
			
			dbselectArea("SC1")
			SC1->(DbSetOrder(1))
			SC1->(DbGoTop())
			dbseek(xFilial("SC1")+cNumSC)
			While !Eof() .And. SC1->C1_NUM == cNumSC

				If Alltrim(SC1->C1_USER) != Alltrim(__CUSERID)  // Validação do Usuario para interromper a gravação                                               
					// If Alltrim(SC1->C1_CC) == "8001" //Everson, 22/12/2022, Ticket TI.
						ExpL1 := .F.  
					// EndIf 
					Exit  
				Endif	
				dbSkip()
			End	                             
		
			If !ExpL1
				Alert("Só é permitido alteração desta solicitação pelo usuário que a incluiu")
			Endif		 
			
		// Endif

	Endif

	restArea(aArea)//Jonathan Carvalho 01/11/2022 - tkt 82195

Return ExpL1
