#include "protheus.ch"
#DEFINE  CRLF 		Chr(13)+Chr(10)
/*/{Protheus.doc} User Function nomeFunction
	ponto de entrada F330DTFIN para permitir ao cliente decidir se quer validar a data do parâmetro MV_DATAFIN ou não. 
	O RdMake precisa apenas retornar:
	.T.: Para que o sistema efetue a validação;
	.F.: Para que o sistema ignore a validação;
	@type  Function
	@author FWNM
	@since 26/09/2019
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@chamado 051550 || OS 052878 || CONTROLADORIA || MONIK_MACEDO || 8956 || INDEXADORES 
	@history chamado 059655 - FWNM - 21/07/2020 - || OS 061193 || FINANCAS || MARILIA || 8353 || CANCELAMENTO RA 
    @history ticket 90222 - Antonio Domingos - 02/05/2023 - COMPENSACAO DE RA X NFE
/*/
User Function F330DTFIN()

	Local lRet := .T.
	Local _cMensagem := ""
	Local _aGetArea  := GetArea()
	
	// Chamado 059655 - FWNM - 21/07/2020 - || OS 061193 || FINANCAS || MARILIA || 8353 || CANCELAMENTO RA 
	/*
	If IsInCallStack("FINA330") // Compensacao CR
		If (SE1->E1_TIPO $ MVABATIM) .or. (SE1->E1_TIPO $ MVRECANT) .or. (SE1->E1_TIPO $ MV_CRNEG)
			lRet := .T.
			Alert("[ F330DTFIN-01 ] - Compensação/Estorno não permitido! Necessário posicionar sobre a NF...")
		EndIf
	EndIf
	*/
	//INICIO ticket 90222 - Antonio Domingos - 29/03/2023
 	//COMPENSACAO DE RA X NFE - DESVINCULA TITULO DE PEDIDO.
	FIE->(dbSetOrder(1))
	If FIE->(dbSeek(SE1->E1_FILIAL+"R"+SE1->E1_PEDIDO))
		_cMensagem+= "Olá " + cUserName                   + ;
		            ' O Titulo: ' +CRLF+" FILIAL "+SE1->E1_FILIAL+" PREFIXO "+SE1->E1_PREFIXO + " NUMERO "+SE1->E1_NUM +" PARCELA "+SE1->E1_PARCELA +" TIPO "+SE1->E1_TIPO +" do Cliente "+SE1->E1_CLIENTE + SE1->E1_LOJA +"."      + ;
		            CRLF+' Tem '+FIE->FIE_TIPO+'; Vinculado ao PEDIDO '+FIE->FIE_PEDIDO+', ' + ;
				    CRLF+' Deseja Retirar o vinculo? ' + CHR(10) + CHR(13) + CHR(10) + CHR(13)

		If MsgYesNo(_cMensagem)
			//carrega variaveis dos registros vinculados
			_cFilial   := SE1->E1_FILIAL
			_cPrefixo  := SE1->E1_PREFIXO
			_cNum      := SE1->E1_NUM
			_cParcela  := SE1->E1_PARCELA
			_cTipo     := SE1->E1_TIPO
			_cF_Filial := FIE->FIE_FILIAL
			_cF_PEDIDO := FIE->FIE_PEDIDO

			//Apaga registro vinculado
			RecLock("FIE", .F.)
				FIE->( dbDelete() )
			FIE->( msUnLock() )
			Aviso("Atenção", "Título FILIAL "+_cFILIAL+" PREFIXO "+_cPREFIXO + " NUMERO "+_cNUM +" PARCELA "+_cPARCELA +" TIPO "+_cTIPO +" DESVINCULADO com SUCESSO, do PEDIDO "+_cF_Filial+"-"+_cF_PEDIDO+"!", {"OK"}, 3)
			
			//Registrando Log		
			DbSelectArea("ZBE")
			RecLock("ZBE",.T.)
			Replace ZBE_FILIAL 	   	WITH cFilAnt
			Replace ZBE_DATA 	   	WITH dDataBase
			Replace ZBE_HORA 	   	WITH Time()
			Replace ZBE_USUARI	    WITH Upper(Alltrim(cUserName))
			Replace ZBE_LOG	        WITH "Título FILIAL "+SE1->E1_FILIAL+" PREFIXO "+SE1->E1_PREFIXO + " NUMERO "+SE1->E1_NUM +" PARCELA "+SE1->E1_PARCELA +" TIPO "+SE1->E1_TIPO +" DESVINCULADO do PEDIDO "+_cF_Filial+_cF_PEDIDO+"."
			Replace ZBE_MODULO	    WITH "SIGAFIN"
			Replace ZBE_ROTINA	    WITH "FINA330"
			Replace ZBE_PARAME      WITH "R"+SE1->E1_FILIAL+SE1->E1_PEDIDO
			ZBE->( MsUnLock())
			
			//Restaura Area Atual
			RestArea(_aGetArea)
		else
			Aviso("Atenção", "Título FILIAL "+SE1->E1_FILIAL+" PREFIXO "+SE1->E1_PREFIXO + " NUMERO "+SE1->E1_NUM +" PARCELA "+SE1->E1_PARCELA +" TIPO "+SE1->E1_TIPO +" NÃO foi DESVINCULADO do PEDIDO "+FIE->(FIE_FILIAL+FIE_PEDIDO)+".", {"OK"}, 3)
			//Registrando Log		
			DbSelectArea("ZBE")
			RecLock("ZBE",.T.)
			Replace ZBE_FILIAL 	   	WITH cFilAnt
			Replace ZBE_DATA 	   	WITH dDataBase
			Replace ZBE_HORA 	   	WITH Time()
			Replace ZBE_USUARI	    WITH Upper(Alltrim(cUserName))
			Replace ZBE_LOG	        WITH "Opção Compensação de CR, usuario NÃO confirmou operação, título FILIAL "+SE1->E1_FILIAL+" PREFIXO "+SE1->E1_PREFIXO + " NUMERO "+SE1->E1_NUM +" PARCELA "+SE1->E1_PARCELA +" TIPO "+SE1->E1_TIPO +" NÃO foi DESVINCULADO do PEDIDO "+FIE->(FIE_FILIAL+"-"+FIE_PEDIDO)+"."
			Replace ZBE_MODULO	    WITH "SIGAFIN"
			Replace ZBE_ROTINA	    WITH "FINA330"
			Replace ZBE_PARAME      WITH "R"+SE1->( E1_CLIENTE + E1_LOJA + E1_PREFIXO + E1_NUM + E1_PARCELA + E1_TIPO)
			ZBE->( MsUnLock())
		EndIf
	EndIf
	//FIM ticket 90222 - Antonio Domingos - 29/03/2023
Return lRet
