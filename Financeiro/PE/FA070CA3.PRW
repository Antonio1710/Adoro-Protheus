#INCLUDE "PROTHEUS.CH"

/*{Protheus.doc} User Function FA070CA3
	O ponto de entrada FA070CA3 sera executado antes da entrada na rotina cancelamento de baixa do contas a receber, para verificar se esta pode ou nao ser cancelada.Não deixar apertar o botão excluir somente se for o tipo R.A
	@type  Function
	@author William Cosata
	@since 21/09/2020
	@version 01
    @history ticket 91505 - Antonio Domingos - 26/04/2023 - ESTORNO BAIXA P98 - ERRO NO FECHAMENTO NCC MARCO_2023
*/    

User Function FA070CA3()

    Local lRet     := .T.    
	Local _dDtCanc 	:= SE5->E5_DATA
	Local _nRecno  	:= SE5->(RECNO())
	Local _lAEstCan := SuperGetMv("MV_#AESTCAN",.F.,.T.) //ticket 91505 - Antonio Domingos - 26/04/2023
	Local _cMensagem:=""
	
	IF PARAMIXB == 5 // Botão Cancelar
    
        //Inicio ticket 91505 - Antonio Domingos - 26/04/2023
        If _lAEstCan
            
            If Empty(SE5->E5_LOTE) .And. SE5->E5_TIPODOC $ "BA"
                _cMensagem := "FA070CA3-01. O Titulo"+" FIL "+SE5->E5_FILIAL+" BCO "+SE5->E5_BANCO+"-"+alltrim(SE5->E5_AGENCIA)+"-"+alltrim(SE5->E5_CONTA)+" TIT "+ALLTRIM(SE5->E5_PREFIXO)+" NUMERO "+ALLTRIM(SE5->E5_NUMERO)+" - "+ALLTRIM(SE5->E5_PARCELA)+", está sem numero de Lote!"+CHR(13)+CHR(10)
                _cMensagem += "Portanto, não gerará movimento bancario de estorno!"
                _cMensagem += "Deseja informar um numero de lote para gerar o estorno deste cancelamento de baixa?"
                If MsgYesNo(_cMensagem)
                    fGetLoteSE5("PX",_dDtCanc,_nRecno)
                EndIf			
            EndIf
        EndIf
        //Fim ticket 91505 - Antonio Domingos - 26/04/2023

    ELSEIF PARAMIXB == 6 // Botão Excluir

        IF GetMv("MV_#EXCBAI",,.F.) == .F.

            IF ALLTRIM(SE1->E1_TIPO) <> 'RA'

                MSGSTOP("OLÁ " + Alltrim(cUserName) + ", Só é permitido excluir baixa se for R.A, use o botão cancelamento de baixa, obrigado.", "FA070CA3-01")

                lRet     := .F.    

            ENDIF
        ENDIF
    ENDIF

Return(lRet)

//----------------------------------------------------------
/*/{Protheus.doc} fGetLoteSE5()
Função gerada para resolver a questão do FINA070 no cancelamento de baixa sem numero de Lote:
---------------------------------------------------------------------------
 Cancela as baixas gerando um lancamento de estorno no SE5
 Se for baixa por lote, estorna saldo bancario
 Só faz estorno de baixa tipo BA se a mesma for gerada atraves da
 baixa por lote( !empty(cLoteFin)), caso contrario ela ‚ apenas altera para cancelada.
---------------------------------------------------------------------------
Função fGetLoteSE5
@param 
@return Não retorna nada
@author Antonio Domingos
@owner Adoro S/a
@obs Funcao para ajustar o estorno de movimento Bancario
@history ticket 91505 - Antonio Domingos - 26/04/2023 - ESTORNO BAIXA P98 - ERRO NO FECHAMENTO NCC MARCO_2023
/*/
//----------------------------------------------------------

Static Function fGetLoteSE5(_cPref,_dData,_nRecno)

Local oDlgSE5
Local aArea     := GetArea()
Local _cNmLoteAtu := _cPref+Substr(DTOS(_dData),3,6) //PX230413
Local _nOpca := 0
Local _cPict := "@!"

   DEFINE MSDIALOG oDlgSE5 TITLE "Confirme o numero de Lote"  OF oDlgSE5 PIXEL FROM 010,010 TO 200,265 
   DEFINE FONT oBold   NAME "Arial" SIZE 0, -12 BOLD

   @ 034,005 SAY "Numero de Lote"                       SIZE 040,10 PIXEL OF oDlgSE5 FONT oBold 
   @ 030,053 MSGET oVar  VAR  _cNmLoteAtu  Picture _cPict  SIZE 050,10 PIXEL OF oDlgSE5  Valid(!Empty(_cNmLoteAtu))
   //@ 075,050 BUTTON "&Confirmar" SIZE 30,14 PIXEL ACTION (fAjusta(cOpcao,cLocal,,,,nQuant),oDlgSE5:End())
   //@ 075,090 BUTTON "&Sair"      SIZE 30,14 PIXEL ACTION oDlgSE5:End()

	Define sButton From 075, 050 When .T. Type 1 Action ( _nOpca := 1, oDlgSE5:End() ) Enable Of oDlgSE5
	Define sButton From 075, 090 When .T. Type 2 Action ( _nOpca := 2, oDlgSE5:End() ) Enable Of oDlgSE5

   	ACTIVATE MSDIALOG oDlgSE5  CENTERED

	If _nOpca == 1
		_cNmLoteAnt:=SE5->E5_LOTE
		//If SE5->(dbGoto(_nRecno))
			RECLOCK("SE5",.F.)
			SE5->E5_LOTE := _cNmLoteAtu
			MSUNLOCK()
			//gera log - 
			u_GrLogZBE(msDate(),TIME(),cUserName," ALTERAÇÃO","SIGAFIN","FA070CA4",;
					"ALTERADO LOTE DO MOV BCO "+" DE "+alltrim(_cNmLoteAnt)+" PARA "+alltrim(_cNmLoteAtu)+" FIL "+SE5->E5_FILIAL+" BCO "+SE5->E5_BANCO+"-"+alltrim(SE5->E5_AGENCIA)+"-"+alltrim(SE5->E5_CONTA)+" TIT "+ALLTRIM(SE5->E5_PREFIXO)+" NUMERO "+ALLTRIM(SE5->E5_NUMERO)+" - "+ALLTRIM(SE5->E5_PARCELA),ComputerName(),LogUserName())
		//EndIf
	EndIf

	RestArea(aArea)          

Return
