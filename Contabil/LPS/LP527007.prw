#INCLUDE 'PROTHEUS.CH'
#include 'PARMTYPE.CH'

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP527007  ºAutor  ³William Costa       º Data ³  06/11/2018 º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³Lancamento padrao de cancelamento de baixa contas a receber º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ CONTABILIDADE GERENCIA LANCAMENTO PADRAO                   º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
@history ticket 79332 - Antonio Domingos - 12/09/2022 - Abertura do LP 520-007 - Clientes CERES.
@history ticket 84816 - Antonio Domingos - 05/12/2022 - lp 527-007 Incluir regra de aceita do Centro de Custo
*/

USER FUNCTION LP527007()

	Local nValor := ''

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	nValor := IF(SE1->E1_NATUREZ="10150",0,IF(SE1->E1_SITUACA$"1/0/F/G/H/Z",IF(!ALLTRIM(SE5->E5_MOTBX)$"DAC,LIQ,DEV,SIN,JPN".AND.SE5->E5_TIPO<>"RA ".AND.ALLTRIM(SE5->E5_TIPODOC)<>"JR",SE5->(E5_VALOR-E5_VLJUROS-E5_VLMULTA+E5_VLDESCO-E5_VLCORRE),0),0))                                                                         
	
RETURN(nValor)

/*{Protheus.doc} User Function LPCTA520007
	Excblock utilizado para retornar o Conta Contabil debito de cancelamento de baixa contas a receber
	@type  Function
	@author Antonio Domingos
	@since 16/09/2022
	@version 01
	@history ticket 79332 - Antonio Domingos - 12/09/2022 - Abertura do LP 520/527-007 - Clientes CERES.
*/	
User Function LPCTA527007()

	Local cConta := ''
	Local cParCliIntC := SuperGetMV("MV_XCLINTC",.F.,"097623/097658/014999") //Codigos de Clientes Intercompany
	Local cCtaCliIntC := TABELA("Z@","A05",.F.) //Conta Contabil de Clientes Intercompany
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	//LINHA ANTERIOR A ALTERAÇÃO             
	//IIF(ALLTRIM(SE5->E5_TIPO)=="JP","191110097",IF((SE5->E5_TIPO)=="NCC","111210002",IF(!EMPTY(SA1->A1_CONTA),SA1->A1_CONTA, IF(SA1->A1_EST<>"EX",TABELA("Z@","A00",.F.),TABELA("Z@","A01",.F.)))))                                                           
	
	//LINHA POSTERIOR A ULTIMA ALTERAÇÃO
	cConta := IIF(SM0->M0_CODIGO='02' .AND. SE5->E5_CLIFOR $ cParCliIntC,cCtaCliIntC,;
	IIF(ALLTRIM(SE5->E5_TIPO)=="JP","191110097",;
	IIF((SE5->E5_TIPO)=="NCC","111210002",;
	IIF(!EMPTY(SA1->A1_CONTA),SA1->A1_CONTA,; 
	IIF(SA1->A1_EST<>"EX",TABELA("Z@","A00",.F.),TABELA("Z@","A01",.F.))))))

RETURN(cConta) 

/*{Protheus.doc} User Function LPCTA520007
	Excblock utilizado para retornar o Centro de Custo a debito de cancelamento de baixa contas a receber
	somente a se a conta Aceita Centro de Custo - Campo CT1_ACCUST = '1'
	@type  Function
	@author Antonio Domingos
	@since 05/12/2022
	@version 01
	@history ticket 84816 - Antonio Domingos - 05/12/2022 - lp 527-007 Incluir regra de aceita do Centro de Custo
*/	
User Function LPCCD527007()

	Local cDebito   := CTK->CTK_DEBITO
	Local cCCusto   := " " 
	Local cAceitaCC := POSICIONE("CT1",1,xFilial("CT1")+cDebito,"CT1_ACCUST")	
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
    cCCusto := IIF(cAceitaCC="1",IIF(ALLTRIM(SE5->E5_TIPO)=="JP","1302","1303")," ")

RETURN(cCCusto) 
