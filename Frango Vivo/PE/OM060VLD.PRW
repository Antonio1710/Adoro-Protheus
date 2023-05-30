#INCLUDE "rwmake.ch"
#INCLUDE "Protheus.ch"

/*/
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³OM060VLD  º Autor ³ MAURICIO - MDS TEC º Data ³  23/06/17   º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDescricao ³ Verifica se e grava log de campos alterados                º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ ADORO                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
/*/

User Function OM060VLD()

	Local _aArea   := GetArea()
	Local _aNomCpo := {}
	Local _cAlter  := '' // Ricardo Lima - 14/11/18 | Declarado Variavel, gerava error.log
	local _nx
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Verifica se e grava log de campos alterados ')

If ALTERA
	//@history Ticket 70142  - Rodrigo / Flek Solution - 27/07/2022 - Ajustes Dic. de dados no Banco
	AEVal( FWSX3Util():GetAllFields( "DA3", .F. ), {|u| AADD(_aNomCpo,{ u, GetSX3Cache(u, "X3_TIPO")}) } )
	dbSelectArea("DA3")
	DbSetOrder(1)
	If dbseek(xFilial("DA3")+M->DA3_COD)
		For _nx := 1 to len(_aNomCpo)
			_mCampo := "M->"+_aNomCpo[_nx][1]
			_cCampo := "DA3->"+_aNomCpo[_nx][1]
			IF &_mCampo <> &_cCampo  &&Sendo diferentes campo foi alterado
				//MsgInfo("Campo "+_cCampo+" foi alterado de "+&_cCampo+" para "+&_mCampo+" ")
				_mCpoGrv := ""
				_cCpoGrv := ""
				If _aNomCpo[_nx][2] == "C"
				   _mCpoGrv := &_mCampo
				   _cCpoGrv	:= &_cCampo					
				Elseif _aNomCpo[_nx][2] == "N"
				   _mCpoGrv := cValToChar(&_mCampo)
				   _cCpoGrv	:= cValToChar(&_cCampo)
				Elseif _aNomCpo[_nx][2] == "D"
				   _mCpoGrv := DTOC(&_mCampo)
				   _cCpoGrv	:= DTOC(&_cCampo)
				Else
				   _mCpoGrv := "conteudo memo"    &&conteudo memo não vai ser possivel gravar conteudo por conta do tamanho.
			       _cCpoGrv := "Conteudo memo"
				Endif
				
				//MsgInfo("Campo "+_cCampo+" foi alterado de "+_cCpoGrv+" para "+_mCpoGrv+" ")
				_cAlter := "Campo "+Alltrim(_cCampo)+" de "+Alltrim(_cCpoGrv)+" para "+Alltrim(_mCpoGrv)+" "
								
				dbSelectArea("ZBE")
				RecLock("ZBE",.T.)
				Replace ZBE_FILIAL 	   	WITH xFilial("ZBE")
				Replace ZBE_DATA 	   	WITH Date()
				Replace ZBE_HORA 	   	WITH TIME()
				Replace ZBE_USUARI	    WITH UPPER(Alltrim(cUserName))
				Replace ZBE_LOG	        WITH _cAlter
				Replace ZBE_MODULO	    WITH "DA3"
				Replace ZBE_ROTINA	    WITH "OM060VLD"
				Replace ZBE_PARAME	    WITH "CODIGO VEICULO: " + M->DA3_COD
				ZBE->(MsUnlock())
																				
			Endif
		Next
		
		If !Empty(_cAlter) //chamado 029467 02/07/2017 - Fernando Sigoli
		
			Reclock("DA3",.F.)
			
			DA3->DA3_XINTEG := "A"  &&alteracao		
			DA3->DA3_XUSUAL := "USUARIO: "+UPPER(Alltrim(cUserName))+" DATA: "+DTOC(Date())
		
			DA3->(MsUnlock())
		
		
		EndIf	
	
	Endif
	
Endif

RestArea(_aArea)
Return(.T.)
