#INCLUDE "protheus.ch"

/*/{Protheus.doc} User Function MT100GRV
  Ponto de Entrada desenvolvido para corrigir data de emiss�o dos Doc. de Entrada conforme regra:
    Tipo = Devolu��o
    Formul�rio Pr�prio = N�o
    Esse erro come�ou a ocorrer ap�s a atualiza��o da MATA103 de Dez/2019.
    As vari�veis do cabe�alho da pr� nota est�o declaradas como Private e s�o: cTipo / cFormul / cNFiscal / cSerie / dDEmissao / cA100For / cLoja / cEspecie / cUfOrigP
    Apesar da vari�vel dDEmissao ser atualizada a mesma n�o foi apresentada na tela de forma correta, sendo necess�rio atualizar tamb�m o array aAutoCab.
    Esse ponto de entrada permite manipular os dados da Pr� Nota antes de exibir a tela.
  @type User Function
  @author Abel Babini
  @since 02/03/2020
  @version 1
  @history Chamado Interno TI - Abel Babini			- 02/03/2020 - Cria��o de valida��o para n�o permitir a grava��o de documento de entrada com data de emiss�o incorreta
  /*/

User Function MT140CAB(lExp01)

  Local nPosEmis  := 0
  Local nPosTipo  := 0
  Local nPosForm  := 0
  Local lRet      := .T.

   // ticket 84085 - 01/12/2022 - Fernando Macieira - TRANSFERENCIA DE ATIVO IMOBILIZADO nota fiscal n�o aparece no Faturamento
	If AllTrim(FUNNAME())=="ATFA060" .or. IsInCallStack("ATFA060")
		Return lRet
	EndIf

  nPosEmis  := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_EMISSAO"})
   nPosTipo  := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_TIPO"})
   nPosForm  := aScan(aAutoCab,{|x| AllTrim(Upper(x[1]))=="F1_FORMUL"})


  IF  INCLUI .AND. ;
      IsInCallStack( "U_CENTNFEXM" ) .AND. ;
      aAutoCab[nPosTipo,2] == 'D' .AND. ;
      aAutoCab[nPosForm,2] == 'N'
    
    aAutoCab[nPosEmis,2] := RECNFXML->XML_EMISSA
    dDEmissao := RECNFXML->XML_EMISSA
  ENDIF

Return lRet
