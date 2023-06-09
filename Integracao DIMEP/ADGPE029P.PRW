#INCLUDE "PROTHEUS.CH"
#INCLUDE "TBICONN.CH"       
#INCLUDE "RWMAKE.CH"
#include "FONT.CH"

/*{Protheus.doc} User Function ADGPE029P
	Integracao com o sistema DIMEP de catracas Adicionar uma matricula de funcionario para subir ao dimep Usando o linked Server para DIMEP
	@type  Function
	@author William Costa
	@since 03/04/2017
	@version 01
	@history TICKET  224    - William Costa - 11/11/2020 - Altera��o do Fonte na parte de Funcion�rios, trocar a integra��o do Protheus para a Integra��o do RM
	@history ticket  14365  - Fernando Macieir- 19/05/2021 - Novo Linked Server (de VPSRV17 para DIMEP)
*/

USER FUNCTION ADGPE029P() 

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio para acompanhamento de tempo de permanencia do dimep de funcionarios.Relatorio em Excel.')

	MsgAlert("OL� " + Alltrim(cUserName)                 + CHR(10) + CHR(13)+;
	         "Programa de Envio de Funcion�rio para ao Dimep Descontinuado pela T.I" + CHR(10) + CHR(13)+;
	         "Motivo: Novas Regras de Integra��o foram implementadas, para n�o ficar replica��o de regra, o envio de funcion�rios ser� somente pela integra��o.", "ADGPE029P")
   
RETURN(NIL)  	                                                                                                                                
