
#INCLUDE "Protheus.ch"
#INCLUDE "TopConn.ch"

#DEFINE ENTER CHR(13)+CHR(10)

/*/{Protheus.doc} User Function MA330TRB
	Ponto de Entrada Recalculo Custo Medio Altera ordem de processamento de movimentos  
	https://tdn.totvs.com/display/public/mp/Ponto+de+Entrada+MA330TRB
	https://tdn.totvs.com/pages/releaseview.action?pageId=340361781
	https://tdn.totvs.com/display/public/PROT/Materiais+-+Monitor+de+Custos
	@type  Function 
	@author Fernando Macieira
	@since  09/04/18 
	@version version
	@history 01/12/2020, Andre Mendes, TKT:3515 - Ajustar a ordem das transfer�ncias, colocando as mesmas em primeiro lugar, ou seja 100.
	@history 27/01/2022, Fer Macieira, TKT:66653- Regra Sequencia de Calculo arm 11 filial 02 TM 503 - Mudan�a sequ�ncia c�lculo armaz�m devolu��o quebra
	@history 18/07/2022, Fernando Macieira, TKT:75632- Sequencia de Calculo filial 02 arm 46
	@history ticket TI - Antonio Domingos - 20/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 23/05/2023 - Revis�o Ajuste Nova Empresa
/*/
User Function MA330TRB()

	Local aArea 	:= GetArea()
	Local aAreaSD3 	:= SD3->( GetArea() )
	Local nTt       := 0
	Local nTtAlt    := 0
	//Local cEmpProc	:= GetMV("MV_#CMEMP",,"01")
	//Local cFilProc	:= GetMV("MV_#CMFIL",,"02")
	Local cTMProc	:= GetMV("MV_#CMTM",,"503")
	Local cAlmProc	:= GetMV("MV_#CMALM",,"11")
	Local cAlmDev	:= GetMV("MV_#CMALD",,"46") // @history 18/07/2022, Fernando Macieira, TKT:75632- Sequencia de Calculo filial 02 arm 46
	Local _cEmpFL1 := SuperGetMv("MV_#EMPFL1",.F.,"0102/1301") //Codigos de Empresas+Filiais Ativas Grupo 1 //ticket TI - Antonio Domingos - 20/05/2023
	//cTimeIni := time()
	
	//Copy to "CMTEMP1"+GETDBEXTENSION() //copia trb antes da mudan�a das sequ�ncias 

	dbSelectArea("TRB")
	TRB->( dbSetOrder(9) )
	TRB->( dbGoTop() )
	Do While TRB->( !EOF() )

		nTt++

		// @history 27/01/2022, Fer Macieira, TKT:66653- Regra Sequencia de Calculo arm 11 filial 02 TM 503 - Mudan�a sequ�ncia c�lculo armaz�m devolu��o quebra
		//If (AllTrim(cEmpAnt) $ AllTrim(cEmpProc)) .and. (AllTrim(TRB->TRB_FILIAL) $ AllTrim(cFilProc))
		If AllTrim(cEmpAnt)+AllTrim(TRB->TRB_FILIAL) $ _cEmpFL1 //ticket TI - Antonio Domingos - 20/05/2023 

			If AllTrim(TRB->TRB_LOCAL) $ AllTrim(cAlmProc) .and. AllTrim(TRB->TRB_ALIAS) == "SD3"
			
				SD3->( dbGoTo( TRB->TRB_RECNO ) ) // Posiciono na SD3 e confiro registro setado para ter ctz de que est� no movimento correto!
				If !SD3->( EOF() ) .and. AllTrim(SD3->D3_COD) == AllTrim(TRB->TRB_COD) .and. AllTrim(SD3->D3_NUMSEQ) == AllTrim(TRB->TRB_SEQ) .and. AllTrim(SD3->D3_TM) $ AllTrim(cTMProc) .and. AllTrim(TRB->TRB_LOCAL) == AllTrim(SD3->D3_LOCAL)

					nTtAlt++
					RecLock("TRB", .F.)
						TRB->TRB_ORDEM := "601"
						TRB->TRB_NIVEL := Subs(TRB_NIVEL,1,2)+"z"
					TRB->( msUnlock() )

				EndIf

			EndIf

			// @history 18/07/2022, Fernando Macieira, TKT:75632- Sequencia de Calculo filial 02 arm 46
			/*
			500 = Sa�da para Vendas
			500 = Entrada por Devolu��o de Venda - Per�odo Atual
			*/
			If AllTrim(TRB->TRB_LOCAL) $ AllTrim(cAlmDev) .and. AllTrim(TRB->TRB_ALIAS) == "SD1" .and. AllTrim(TRB->TRB_TIPONF) == "D"
				RecLock("TRB", .F.)
					TRB->TRB_ORDEM := "499"
					TRB->TRB_NIVEL := Subs(TRB_NIVEL,1,2)+"z"
				TRB->( msUnlock() )
			EndIf
			//

		EndIf

		//TKT:3515- Ajustar a ordem das transfer�ncias, colocando as mesmas em primeiro lugar, ou seja 100.  
		If TRB->TRB_ALIAS == "SD1" .and. TRB->TRB_ORDEM == "300" .and. TRB->TRB_USATRA == "S"
			RecLock("TRB", .F.)
				TRB_ORDEM := "100"
			TRB->( MsUnlock() )
		Endif      
	
		TRB->( dbSkip() )

	EndDo

	//dbSelectArea("TRB")
	//dbGoTop()
	//Copy to "CMTEMP2"+GETDBEXTENSION() //copia trb ap�s as mudan�as das sequ�ncias

	/*
	Alert("Total regs TRB:" + Str(nTt))
	Alert("Total regs TRB alterados:" + Str(nTtAlt))
	Alert("Tempo total: " + ElapTime(cTimeIni, Time()))
	*/

	RestArea( aAreaSD3 )
	RestArea( aArea )

Return

/*
https://tdn.totvs.com/display/public/mp/Ponto+de+Entrada+MA330TRB

Rec�lculo do Custo M�dio - Ponto de entrada MA330TRB

   A fun��o primordial da rotina de rec�lculo do custo m�dio � reordenar as movimenta��es de forma que todas as entradas sejam processadas antes das sa�das em um mesmo per�odo. As informa��es dispon�veis para realizar esta ordena��o s�o: data da movimenta��o (i.e.: movimenta��es que ocorreram no in�cio do per�odo influenciar�o o custo das demais, e n�o o inverso) e a natureza da movimenta��o (i.e.: normalmente uma produ��o utiliza a mat�ria prima j� existente no estoque, por isso consideramos que movimenta��es de entrada de mat�ria prima ter�o influ�ncia no custo do produto a ser produzido, e n�o o contr�rio). Para casos em que ocorrem v�rias movimenta��es em um mesmo per�odo, como  por exemplo, no m�todo de apropria��o mensal, com todas as movimenta��es que ocorreram dentro do m�s devem ser ordenadas independentemente da data em que tenha ocorrido, utilizamos apenas a natureza da movimenta��o como crit�rio de desempate nesta reordena��o.

   Para atender a maioria dos casos encontrados em nossos clientes definimos que nossa rotina de rec�lculo de custo m�dio deve ordenar as naturezas das movimenta��es ocorridas dentro de um mesmo per�odo (dia, semana, m�s etc.) da seguinte forma:

 Ordem de C�lculo

Tipo de Movimenta��o

Observa��o

080

Movimento de Ajuste Cambial (para a localiza��o da Bol�via)

Tabela SD3

095

Entrada por Remito de Compra (apenas para algumas localiza��es)

Tabela SCM

100

Entrada por Compra

Tabela SD1

110

Entrada por Libera��o ou Rejei��o de CQ

Tabela SD3

120

Entrada direcionada a OP (i.e.: gera RE5) de Produto de terceiros a ser Beneficiado por mim - Per�odo Anterior

Tabelas SD1/SD3

120

Entrada direcionada a OP (i.e.: gera RE5) - Per�odo Anterior

Tabelas SD1/SD3

145

Entrada por Devolu��o de Compra (apenas para algumas localiza��es)

Tabela SCM

150

Entrada por Devolu��o Compra

Tabela SD2

195

Entrada por Devolu��o de Vendas (apenas para algumas localiza��es) - Per�odo Anterior

Tabela SCN

200

Entrada por Devolu��o de Vendas - Per�odo Anterior

Tabela SD1

250

Entrada por Recebimento de Produto de terceiros a ser Beneficiado por mim - Per�odo Atual

Tabela SD1

280

Entrada por Recebimento de Produto de terceiros a ser Beneficiado por mim - Per�odo Anterior

Tabela SD1

290

Sa�da para Envio de Beneficiamento feito por mim

Tabela SD2

300w

Transfer�ncia

Tabela SD3

300w

Sa�da para Transfer�ncia entre Filiais

Tabela SD2

300w

Entrada de Transfer�ncia entre Filiais

Tabela SD1

300x

Sa�da - Envio de Produto sem estrutura para Beneficiamento a ser feito por terceiros

Tabela SD2

300x

Entrada por Recebimento de Produtos com estrutura que foi Beneficiado por terceiros

Tabela SD1

300y

Entrada por Recebimento de Produtos sem estrutura que foi Beneficiado por terceiros

Tabela SD1

300y

Sa�da - Envio de Produto com estrutura para Beneficiamento a ser feito por terceiros

Tabela SD2

300

Movimenta��es Internas, exceto Requisi��o para Consumo (i.e.: ordem 301) e Transfer�ncia (i.e.: ordem 300w).

Tabela SD3

300

Entrada direcionada a OP (i.e.: gera RE5) de Produto de terceiros a ser Beneficiado por mim - Per�odo Atual

Tabelas SD1/SD3

300

Entrada direcionada a OP (i.e.: gera RE5) - Per�odo Atual

Tabelas SD1/SD3

301

Sa�da para Requisi��o de Consumo

Tabela SD3

480

Sa�da para Apontamento de Projetos (SIGAPMS)

SIGAPMS

495

Sa�da para Remito de Venda (apenas para algumas localiza��es)

Tabela SCN

500

Sa�da para Vendas

Tabela SD2

500

Entrada por Devolu��o de Venda - Per�odo Atual

Tabela SD1

545

Entrada por Devolu��o de Venda (apenas para algumas localiza��es) - Per�odo Atual

Tabela SCN

600

Reavalia��o de Custo (REA/DEA)

Tabela SD3

610

Movimento de acerto do custo de reposi��o

Tabela SD3

 

 

   Com esta seq�encia atendemos grande parte da opera��o de nossos clientes, mas h� casos particulares ou situa��es pontuais que exigem que as movimenta��es sejam ordenadas de forma diferente desta mostrada acima. Veja: normalmente as opera��es de transfer�ncia devem ser consideradas em uma seq��ncia posterior a opera��es de movimentos internos para que o custo das devolu��es ao estoque seja agregado ao custo do produto antes que este seja transferido. Observe que esta situa��o est� coberta pela seq��ncia padr�o de calculo acima, onde movimenta��es internas recebem a seq��ncia de c�lculo 300 e movimenta��es de transfer�ncia recebem a seq��ncia de c�lculo 300w. Se por qualquer motivo uma empresa precise que seja feita uma transfer�ncia entre diferentes produtos, fazendo com que o estoque de produto A seja transferido para (i.e.: se �transforme� em) produto B para que a seguir o estoque deste produto B seja requisitado para determinada OP... Neste caso a seq��ncia padr�o j� n�o seria mais v�lida; A transfer�ncia de produtos receberia a seq��ncia de c�lculo 300w e a requisi��o para OP, feita logo a seguir, receba a seq��ncia de c�lculo 300...

   Neste exemplo a ordena��o proposta pelo sistema padr�o inverteria a ordem natural da movimenta��o, fazendo com que o custo da devolu��o da transfer�ncia n�o fosse considerado na requisi��o para OP. Mais um ponto: se estas fossem as primeiras movimenta��es no per�odo e se o produto n�o tivesse custo hist�rico o custo do mesmo ficaria negativo!

   A ferramenta disponibilizada para adequar casos como o exemplificado acima � o ponto de entrada MA330TRB ( neste link do TDN existem mais informa��es sobre este ponto, inclusive com um exemplo real de utiliza��o postado pelo Henrique Magalhaes Dias da Silva), que possibilita a altera��o da seq��ncia de c�lculo que � atribu�da pelo sistema � determinada movimenta��o durante o rec�lculo do custo; No exemplo acima o tratamento deveria abranger apenas as transfer�ncia de produtos que tivessem c�digos diferentes na entrada e sa�da de uma mesma movimenta��o de transfer�ncia � para estes casos a seq��ncia de c�lculo pode ser alterada, por exemplo, de 300w para 290w, incluindo esta movimenta��o antes dos movimentos internos, que possuem seq��ncia de c�lculo 300.

   Este ponto de entrada interfere no desempenho da rotina e  n�o fere a integridade dos dados, sendo considerado como um dispositivo padr�o de parametriza��o do rec�lculo do custo m�dio nos casos, onde a ordena��o padr�o sugerida n�o atende as necessidades espec�ficas encontradas em determinadas empresas.


*/
