#INCLUDE "Protheus.ch"
#INCLUDE "ParmType.ch"
#INCLUDE "topconn.ch" 
Static xPula   := Chr(13) + Chr(10)
/*/{Protheus.doc} User Function AXFV4
	Cadastro de veiculos.
	@type  Function
	@author WILLIAM COSTA
	@since 18/04/2001
	@version 01
	@history Enviar cadastro de transportador,veiculo e motorista para o Edata FV4EDATA() - Fernando Sigoli.
	@history Chamado: 047273. 15/02/2019 - Fernando Sigoli - Error Log,variable does not exist _CALTER on U_COKVEIC(AXFV4.PRW)-Declarado Variav.
	@history Everson - 25/04/2019. Chamado 044314. Envio de e-mail na altera��o e inclus�o de cadastro de ve�culo.
	@history Everson - 08/05/2019. Chamado 044314. Adicionado nome do usu�rio que efetuou a opera��o de inclus�o/altera�a� no e-mail de aviso.
	@history Everson - 21/02/2020. Chamado 053926 Tratamento para envio de cadastro ao SAG.
	@history Everson - 26/02/2020. Chamado 053926 Adiconadas rotinas para cadastramento de TAG SAG e caixas de transporte de ra��o.
	@history Ticket T.I.   - Leonardo P. Monteiro - 16/04/2021 - Integra��o do passaporte para o eData.
	@history Ticket T.I.   - Leonardo P. Monteiro - 14/06/2021 - Cria��o de melhoria na rotina para integra��o em lote de todos os ve�culos e transportadoras.
	@history Ticket T.I.   - Leonardo P. Monteiro - 22/07/2021 - Inclus�o de valida��es para n�o deixar que manobristas sejam vinculados a ve�culos e a transportadoras.
	@history ticket 18125  - 10/08/2021 - ADRIANO SAVOINE - Bloqueio de Exclus�o e Bloqueio do campo em modo de edi��o.
	@history ticket 61154  - 05/10/2021 - SIGOLI - Feito tratamento para mostrar o erro na tela de usuario, para quando ocorrer erro do lado do edata, apreentar na tela. 
	@history ticket 65889  	- Leonardo P. Monteiro - 05/01/2022 - Adi��o de vari�vel para indicar o LinkedServer.
	@history Everson, 18/03/2022, Chamado 18465. Envio de informa��es ao barramento.
	@history Everson, 24/03/2022, Chamado 18465. Nova rotina para cadastro de caixas de transporte.
	@history Everson, 14/06/2022, Chamado 74587. Tratamento para errorlog.
	@history Everson, 05/07/2022, Chamado 18465. Tratamento para removar caractere especial na leitura da tag.
	@history Everson, 15/07/2022, Chamado TI   . Tratamento para errorlog.
	@history Everson, 19/09/2022, Chamado 80194. Rotina para envio de cadastros para o app LogRank.
	@history Everson, 29/09/2022, Chamado 80379. Corre��o na chamada da fun��o.
	@history Sigoli,  12/12/2022, TKT; TI. Deixar fixo, independete de filial ou empresa, pois o cadastro sempre integra no edata de VP        
	@history Ticket 85319  - Antonio Domingos - 26/01/2023 - REtirado seek pois ja est� posicionado
	@history Ticket 93281  - Antonio Domingos - 10/05/203 - Erro no cadastro de transportador e motorista no ambiente SAFFEG
	@history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa.
	@history ticket TI - Antonio Domingos - 30/05/2023 - Ajuste Nova Empresa
/*/

User Function AXFV4() 

	Local aRotAdic   :={}
// Local cUsrSAG    := Alltrim(GetMv("MV_#VEISAG",,""))
	Local aButtons   := {}
	Local bNoTTs	 := {|| fInteDa()}
	Private cLinkSe  := "LNKMIMS"  // Fernando SIgoli - Deixar fixo, independete de filial adoro, pois o cadastro sempre integra no edata de VP//Alltrim(SuperGetMV("MV_#UEPSRV",,"LNKMIMS")) //Alltrim(SuperGetMv("MV_#IEDATA",,"[LNKMIMS].[SMART].[dbo]"))
	Private _CALTER  := "" //Chamado: 047273 //Everson - 26/02/2020. Chamado 053926.
	Private _cEmpFLD := SuperGetMv("MV_#EMPFLD",.F.,"0103/0105") //Codigos de Empresas+Filiais Ativas Grupo D //ticket TI - Antonio Domingos - 30/05/2023

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de veiculos')

	aadd(aRotAdic,{ "* LOGS"		,"u_FV4LOG()"  , 0 , 10 }) 
	aadd(aRotAdic,{ "Carga eData"	,"Processa( { || U_fCEDATA()  }, 'Integrando...', 'Aguarde...')"  , 0 , 11 }) //Everson - 29/09/2022 - Ticket 80379.

	If cNumEmp == "0102"
		aadd(aRotAdic,{ "Carga Rank"	,"Processa( { || U_fCRANK() }, 'Integrando...', 'Aguarde...')"  , 0 , 12 }) 

	EndIf

	//aadd(aRotAdic,{ "* Env.Edata"   ,"u_FV4EDATA()", 0 , 7 }) 

	//Everson - 21/02/2020. Chamado 053926.
	If alltrim(cEmpAnt)+alltrim(cFilAnt) $ _cEmpFLD //Everson - 26/02/2020. Chamado 053926. //Everson, 18/10/2020, Chamado 18465.

		Aadd(aButtons,{"Cad Caixas","U_FV4Caixas()","Cad Caixas","Cad Caixas"})
		Aadd(aButtons,{"Tag Fixa"  ,"U_FV4TGSG()"  ,"Tag Fixa","Tag Fixa"})

		aadd(aRotAdic,{ "* Env.SAG"   	,"MsAguarde({|| u_FV4SAG() },'Aguarde','Enviando registro...')"  , 0 , 13 })

	EndIf

	DbSelectArea("ZV4")
	DbSetOrder(1)
	Dbgotop()

	AXCADASTRO("ZV4","Cadastro de Veiculos ","U_EXCLUI()","U_COKVEIC()",aRotAdic,,,,bNoTTs,,,aButtons) //Everson - 26/02/2020. Chamado 

Return Nil

Static Function fInteDa()
	// *** INICIO CHAMADO
	Local cEMPIED := SuperGetMv("MV_#EMPIED",.F.,"01/13")  //Parametro para empresas que integram Edata - ticket 93281 - Antonio Domingos - 10/05/2023
	Default INCLUI := .F.
	Default ALTERA := .F.

	IF INCLUI .OR. ALTERA
		//ticket TI - Antonio Domingos - 30/05/2023 - Ajuste Nova Empresa
		If alltrim(cEmpAnt) $ cEMPIED //ticket 93281 - Antonio Domingos - 10/05/2023
			MsAguarde({|| u_FV4EDATA() },"Aguarde","Integrando registro no eData, aguarde...")
		EndIf
		grvBarr(Iif(INCLUI, "I", "A"), ZV4->ZV4_PLACA) //Everson, 18/10/2020, Chamado 18465.

	ENDIF

return .T.

Static Function fGetTransp()
	Local nRet 		:= 0
	Local cQuery	:= ""


	cQuery := " SELECT	ZV4.ZV4_FORNEC, ZV4.ZV4_PLACA, "
	cQuery += " 		ZV4.ZV4_CPF, ZV4.ZV4_PASPO,   " 
	cQuery += " 		ZV4.ZV4_CPF1, ZV4.ZV4_PASPO1, "
	cQuery += " 		ZV4.ZV4_CPF2, ZV4.ZV4_PASPO2, "
	cQuery += " 		ZV4.ZV4_CPF3, ZV4.ZV4_PASPO3, "
	cQuery += " 		ZV4.ZV4_CPF4, ZV4.ZV4_PASPO4, "
	cQuery += " 		ZV4.ZV4_CPF5, ZV4.ZV4_PASPO5, "
	cQuery += " 		ZV4.ZV4_CPF6, ZV4.ZV4_PASPO6, "
	cQuery += " 		ZV4.ZV4_CPF7, ZV4.ZV4_PASPO7, "
	cQuery += " 		ZV4.ZV4_CPF8, ZV4.ZV4_PASPO8, "
	cQuery += " 		ZV4.ZV4_CPF9, ZV4.ZV4_PASPO9 "
	cQuery += " FROM "+ retsqlname("ZV4") +" ZV4 "
	cQuery += " WHERE ZV4.D_E_L_E_T_='' AND ZV4.ZV4_VEIBLQ !='T' "
	cQuery += "  AND ZV4.ZV4_PLACA  BETWEEN '"+ MV_PAR01 +"' AND '"+ MV_PAR02 +"' "
	cQuery += "  AND ZV4.ZV4_FORNEC BETWEEN '"+ MV_PAR03 +"' AND '"+ MV_PAR04 +"'; "
	
	TCQUERY cQuery ALIAS "QTRA" NEW

	Count To nRet

	QTRA->(Dbgotop())

Return nRet 

User function FCEDATA() //Everson - 29/09/2022 - Ticket 80379.

	//Vari�veis.
	Local aArea     := GetArea()
	Local lRet 		:= .T.
	Local nReg		:= 0
	Local nOk		:= 0
	Local nNo		:= 0
	Local lIntegrou	:= .F.
	Local cPergunt	:= "AXFV4A"

	if pergunte(cPergunt)
		nReg := fGetTransp()

		DbSelectArea("ZV4")
		ZV4->(DbSetOrder(1))

		ProcRegua(nReg)

		While QTRA->(!Eof())

			ZV4->( DbSeek( FWxFilial("ZV4") + QTRA->ZV4_PLACA ) )

			lIntegrou := u_FV4EDATA()

			// if (!Empty(QTRA->ZV4_CPF) .or. !Empty(QTRA->ZV4_PASPO))
			// 	lIntegrou	:= fEnveData(iif(empty(QTRA->ZV4_CPF), QTRA->ZV4_PASPO, QTRA->ZV4_CPF), QTRA->ZV4_FORNEC, QTRA->ZV4_PLACA, cEmpAnt)
			// endif
			
			// if (!Empty(QTRA->ZV4_CPF1) .or. !Empty(QTRA->ZV4_PASPO1))
			// 	lIntegrou	:= fEnveData(iif(empty(QTRA->ZV4_CPF1), QTRA->ZV4_PASPO1, QTRA->ZV4_CPF1), QTRA->ZV4_FORNEC, QTRA->ZV4_PLACA, cEmpAnt)
			// endif

			// if (!Empty(QTRA->ZV4_CPF2) .or. !Empty(QTRA->ZV4_PASPO2))
			// 	lIntegrou	:= fEnveData(iif(empty(QTRA->ZV4_CPF2), QTRA->ZV4_PASPO2, QTRA->ZV4_CPF2), QTRA->ZV4_FORNEC, QTRA->ZV4_PLACA, cEmpAnt)
			// endif

			// if (!Empty(QTRA->ZV4_CPF3) .or. !Empty(QTRA->ZV4_PASPO3))
			// 	lIntegrou	:= fEnveData(iif(empty(QTRA->ZV4_CPF3), QTRA->ZV4_PASPO3, QTRA->ZV4_CPF3), QTRA->ZV4_FORNEC, QTRA->ZV4_PLACA, cEmpAnt)
			// endif
			
			// if (!Empty(QTRA->ZV4_CPF4) .or. !Empty(QTRA->ZV4_PASPO4))
			// 	lIntegrou	:= fEnveData(iif(empty(QTRA->ZV4_CPF4), QTRA->ZV4_PASPO4, QTRA->ZV4_CPF4), QTRA->ZV4_FORNEC, QTRA->ZV4_PLACA, cEmpAnt)
			// endif
			
			// if (!Empty(QTRA->ZV4_CPF5) .or. !Empty(QTRA->ZV4_PASPO5))
			// 	lIntegrou	:= fEnveData(iif(empty(QTRA->ZV4_CPF5), QTRA->ZV4_PASPO5, QTRA->ZV4_CPF5), QTRA->ZV4_FORNEC, QTRA->ZV4_PLACA, cEmpAnt)
			// endif
			
			// if (!Empty(QTRA->ZV4_CPF6) .or. !Empty(QTRA->ZV4_PASP6))
			// 	lIntegrou	:= fEnveData(iif(empty(QTRA->ZV4_CPF6), QTRA->ZV4_PASPO6, QTRA->ZV4_CPF6), QTRA->ZV4_FORNEC, QTRA->ZV4_PLACA, cEmpAnt)
			// endif
			
			// if (!Empty(QTRA->ZV4_CPF7) .or. !Empty(QTRA->ZV4_PASPO7))
			// 	lIntegrou	:= fEnveData(iif(empty(QTRA->ZV4_CPF7), QTRA->ZV4_PASPO7, QTRA->ZV4_CPF7), QTRA->ZV4_FORNEC, QTRA->ZV4_PLACA, cEmpAnt)
			// endif
			
			// if (!Empty(QTRA->ZV4_CPF8) .or. !Empty(QTRA->ZV4_PASPO8))
			// 	lIntegrou	:= fEnveData(iif(empty(QTRA->ZV4_CPF8), QTRA->ZV4_PASPO8, QTRA->ZV4_CPF8), QTRA->ZV4_FORNEC, QTRA->ZV4_PLACA, cEmpAnt)
			// endif
			
			// if (!Empty(QTRA->ZV4_CPF9) .or. !Empty(QTRA->ZV4_PASPO9))
			// 	lIntegrou	:= fEnveData(iif(empty(QTRA->ZV4_CPF9), QTRA->ZV4_PASPO9, QTRA->ZV4_CPF9), QTRA->ZV4_FORNEC, QTRA->ZV4_PLACA, cEmpAnt)
			// endif
			
			
			IF lIntegrou
				nOk += 1
			else
				nNo	+= 1
			endif

			IncProc()
			QTRA->(DbSkip())
		Enddo

		QTRA->(DbCloseArea()) //Everson - 29/09/2022 - Ticket 80379.

		if nNo == 0
			MsgInfo("Rotina Finalizada com todos os registros integrados. Total de "+ cValtochar(nOk) +" registros.")
		else
			MsgAlert("Rotina finalizada com "+ cValToChar(nOk) +" registros integrados, "+ cValToChar(nNo) +" registro n�o integrados, Total de "+ cValToChar(nOk+nNo) +" registros. ")
		endif
	else
		MsgInfo("Opera��o cancelada pelo operador!")
	endif

	RestArea(aArea)

return lRet


/*/{Protheus.doc} User Function EXCLUI
	(VALIDA��O ANTES DA EXCLUS�O)
	@type  Function
	@author ADRIANO SAVOINE
	@since 10/08/2021
	@history ticket 18125 - 10/08/2021 - ADRIANO SAVOINE - Bloqueio de Exclus�o e Bloqueio do campo em modo de edi��o.
	/*/
User Function EXCLUI()

Local eXcluir := .F.

IF RetCodUsr() $ GetMV("MV_#ALTPLC") 
	eXcluir := .T.
	
	Else
	
	MsgInfo('<h1>Aten��o:</h1><br>Voc� n�o pode excluir cadastros de placa para isso voc� tem que estar cadastrado no parametro,</b><font color="#FF0000"> MV_#ALTPLC </font>', "Abrir Ticket para aprova��o do Gerente ou Supervisor.")

EndIf

Return eXcluir


/*/{Protheus.doc} User Function COKVEIC
	(long_description)
	@type  Function
	@author 
	@since 
	@version 01
/*/

User Function COKVEIC()    

	Local _aNomCpo 	:= {}
	Local lOk		:= .T.
	Local cCmpAlt	:= "" //Everson - 25/04/2019. Chamado 044314.
	Local _nx       := 0

	// Valida se os CPFs cadastrados pertencem a algum manobrista.
	lOk := fVldMan()

	if lOk
		//rotina para aterar 	
		If ALTERA
			//@history Ticket 70142  - Rodrigo / Flek Solution - 27/07/2022 - Ajustes Dic. de dados no Banco
			AEVal( FWSX3Util():GetAllFields( "ZV4", .F. ), {|u| AADD(_aNomCpo,{ u, GetSX3Cache(u, "X3_TIPO")}) } )
			/*
			DbSelectArea("SX3")
			DbSetOrder(1)
			SX3->(DbSetOrder(1))
			SX3->(DbSeek('ZV4'))
			While SX3->(!Eof()) .And. SX3->X3_ARQUIVO == 'ZV4'
				If X3USO(SX3->X3_USADO) .And. cNivel >= SX3->X3_NIVEL .And. SX3->X3_CONTEXT <> "V"
					AADD(_aNomCpo,{SX3->X3_CAMPO,SX3->X3_TIPO,X3Titulo()})
				EndIf
				SX3->(DbSkip())
			Enddo
			*/
			//dbSelectArea("ZV4")  //Ticket 85319  - Antonio Domingos - 26/01/2023
			//DbSetOrder(1)        //Ticket 85319  - Antonio Domingos - 26/01/2023
			//If dbseek(xFilial("ZV4")+M->ZV4_PLACA) //Ticket 85319  - Antonio Domingos - 26/01/2023
	
				For _nx := 1 to len(_aNomCpo)
					_mCampo := "M->"+_aNomCpo[_nx][1]
					_cCampo := "ZV4->"+_aNomCpo[_nx][1]
					IF &_mCampo <> &_cCampo  //Sendo diferentes campo foi alterado
						//MsgInfo("Campo "+_cCampo+" foi alterado de "+&_cCampo+" para "+&_mCampo+" ")
						_mCpoGrv := ""
						_cCpoGrv := ""
						If _aNomCpo[_nx][2] == "C"
							_mCpoGrv := &_mCampo
							_cCpoGrv	:= &_cCampo					
						Elseif _aNomCpo[_nx][2] == "N"
							_mCpoGrv := Alltrim(STR(&_mCampo))
							_cCpoGrv	:= Alltrim(STR(&_cCampo))						
						Elseif _aNomCpo[_nx][2] == "D"
							_mCpoGrv := DTOC(&_mCampo)
							_cCpoGrv	:= DTOC(&_cCampo)
						Else
							_mCpoGrv := "conteudo memo"    //conteudo memo n�o vai ser possivel gravar conteudo por conta do tamanho.
							_cCpoGrv := "Conteudo memo"
						Endif

						_cAlter := "Campo "+Alltrim(_cCampo)+" de "+Alltrim(_cCpoGrv)+" para "+Alltrim(_mCpoGrv)+" "
						
						//Everson - 25/04/2019. Chamado 044314.
						cCmpAlt += "<p>Campo " + cValToChar(_aNomCpo[_nx][1]) +" de "+Alltrim(_cCpoGrv)+" para "+Alltrim(_mCpoGrv)+ "</p>" + Chr(13) + Chr(10) //Ticket 85319  - Antonio Domingos - 26/01/2023

						dbSelectArea("ZBE")
						RecLock("ZBE",.T.)
						Replace ZBE_FILIAL 	   	WITH xFilial("ZBE")
						Replace ZBE_DATA 	   	WITH Date()
						Replace ZBE_HORA 	   	WITH TIME()
						Replace ZBE_USUARI	    WITH UPPER(Alltrim(cUserName))
						Replace ZBE_LOG	        WITH _cAlter
						Replace ZBE_MODULO	    WITH "FV4-VEICULO"
						Replace ZBE_ROTINA	    WITH "AXFV4"
						Replace ZBE_PARAME	    WITH "PLACA VEICULO: " + M->ZV4_PLACA
						ZBE->(MsUnlock())

					Endif
				Next

				If !Empty(_cAlter)
					M->ZV4_XUSUAL	:= "USUARIO: "+UPPER(Alltrim(cUserName))+" DATA: "+DTOC(Date()) //grava o ultimo usuario na altera��o	
				EndIf

				//Everson - 25/04/2019. Chamado 044314.
				envEmail("Altera��o de cadastro " + cValToChar(M->ZV4_PLACA) + ".",cCmpAlt)

			//Endif //Ticket 85319  - Antonio Domingos - 26/01/2023

		Endif

		//Everson - 25/04/2019. Chamado 044314.
		If INCLUI
			Conout( DToS(Date()) + " " + Time() + " AXFV4 - COKVEIC - INCLUI" )
			envEmail("Inclus�o de cadastro " + cValToChar(M->ZV4_PLACA) + ".","")

		EndIf

	endif

Return lOk

Static Function fVldMan()
	Local lRet 		:= .T.
	Local cQuery 	:= ""
	Local cMens		:= ""

	cQuery := " SELECT ZEB_NOME, ZEB_CPF "
	cQuery += " FROM "+ RetSqlName("ZEB") +" "
	cQuery += " WHERE D_E_L_E_T_='' AND ZEB_FILIAL='"+ xFilial("ZEB") +"' AND "
	cQuery += "  (   ZEB_CPF='"+ M->ZV4_CPF +"' "
	cQuery += "   OR ZEB_CPF ='"+ M->ZV4_CPF1 +"' "
	cQuery += "   OR ZEB_CPF ='"+ M->ZV4_CPF2 +"' "
	cQuery += "   OR ZEB_CPF ='"+ M->ZV4_CPF3 +"' "
	cQuery += "   OR ZEB_CPF ='"+ M->ZV4_CPF4 +"' "
	cQuery += "   OR ZEB_CPF ='"+ M->ZV4_CPF5 +"' "
	cQuery += "   OR ZEB_CPF ='"+ M->ZV4_CPF6 +"' "
	cQuery += "   OR ZEB_CPF ='"+ M->ZV4_CPF7 +"' "
	cQuery += "   OR ZEB_CPF ='"+ M->ZV4_CPF8 +"' "
	cQuery += "   OR ZEB_CPF ='"+ M->ZV4_CPF9 +"'); "

	TcQuery cQuery ALIAS "QZEB" NEW

	if QZEB->(!eof())

		cMens := "Os CPFs abaixo est�o cadastrados como manobristas e n�o pode ser vinculados a ve�culos e nem transportadoras:"+CHR(13)+CHR(10)+CHR(13)+CHR(10)
		
		while QZEB->(!eof())
			cMens += " - "+QZEB->ZEB_NOME +"("+ QZEB->ZEB_CPF +")"+CHR(13)+CHR(10)
			QZEB->(Dbskip())
		end
		MsgInfo(cMens, "Alerta")
		lRet := .F.
	endif
	
	QZEB->(DbCloseArea())

return lRet


/*/{Protheus.doc} envEmail
	Envio de e-mail.
	@type  Static Function
	@author Everson
	@since 25/04/2019
	@version 01
/*/ 

Static Function envEmail(cTexto,cTexto2)

	Local aArea		:= GetArea()
	Local cMensagem	:= ""
	Local cPara		:= SuperGetMv( "MV_#LG0421" , .F. , '' ,  )
	
	Conout( DToS(Date()) + " " + Time() + " AXFV4 - COKVEIC - envEmail " )

	cMensagem := "<html> "
	cMensagem += "    <body> "
	cMensagem += "        <div style='text-align: left;'>&nbsp;</div> "
	cMensagem += "        <div style='text-align: left;'> "
	cMensagem += "            <span style='font-size:14px;'><span style='font-family:verdana,geneva,sans-serif;'>" + cTexto + "</span></span></div> "	
	cMensagem += "        <div style='text-align: left;'>&nbsp;</div> "

	If ! Empty(cTexto2)
		cMensagem += "        <div style='text-align: left;'>" + cTexto2 + "</div> "
		cMensagem += "        <div style='text-align: left;'>&nbsp;</div> "	

	EndIf

	cMensagem += "        <div style='text-align: left;'>Usu�rio: " + Upper(Alltrim(cUserName)) + "</div> "	 //Everson - 08/05/2019. Chamado 044314.
	cMensagem += "        <div style='text-align: left;'>&nbsp;</div> "
	cMensagem += "        <div style='text-align: left;'> 
	cMensagem += "        <div style='text-align: left;'> "
	cMensagem += "            <span style='font-size:14px;'><span style='font-family:verdana,geneva,sans-serif;'>Enviado em " + DToC(Date()) + " " + Time() + "</span></span></div> "							
	cMensagem += "        <div style='text-align: left;'> "
	cMensagem += "            <span style='font-size:14px;'><span style='font-family:verdana,geneva,sans-serif;'>Sistema de Frete - Ad&#39;oro - e-mail enviado automaticamente. Por favor, n�o responda.</span></span></div> "
	cMensagem += "    </body> "
	cMensagem += "</html> "

	Conout( DToS(Date()) + " " + Time() + " AXFV4 - COKVEIC - envEmail - U_F50En2WF " )
	U_F50En2WF(cPara,Nil,"Cadastro de Ve�culos" ,cMensagem,Nil)

	RestArea(aArea)

Return Nil

/*/{Protheus.doc} User Function FV4LOG
	Apresenta Historico/Log com todas as acoes tomadas. Chamado 029467. 
	@type  Function
	@author Fernando Sigoli
	@since 02/07/2017
	@version 01
/*/

User Function FV4LOG()

	Local aArea		:= GetArea()
	Local oDlg
	Local Query     := ""

	Local aSize    	:= MsAdvSize()
	Local aPosObj  	:= {}
	Local aObjects 	:= {}
	Local aInfo		:= {}
	Local nOpcao	:= 0
	Local aListBox	:= {}
	Private aTela	[0][0]
	Private aGets	[0]

	//Tamanho da tela
	aObjects := {}
	aAdd( aObjects, { 100,  20, .t., .f. } )
	aAdd( aObjects, { 100,  80, .t., .t. } )
	aInfo   := { aSize[ 1 ], aSize[ 2 ], aSize[ 3 ], aSize[ 4 ], 3, 3 }
	aPosObj := MsObjSize( aInfo, aObjects )

	Query := " SELECT ZBE_DATA,ZBE_HORA,ZBE_USUARI,ZBE_LOG,ZBE_PARAME FROM "+retsqlname("ZBE")+" ZBE WHERE ZBE_ROTINA = 'AXFV4' and ZBE_PARAME LIKE '%"+ZV4->ZV4_PLACA+"%'   ORDER BY ZBE.ZBE_DATA DESC, ZBE.ZBE_HORA DESC  "
	TCQUERY Query new alias "LOG1"    

	// Adiciona elementos ao Array da ListBox
	LOG1->(dbgotop())
	While !EOF()  
		aAdd( aListBox,{ LOG1->ZBE_USUARI, LOG1->ZBE_DATA, LOG1->ZBE_HORA, LOG1->ZBE_LOG,  })
		DbSkip()
	End  

	LOG1->(DbCloseArea()) //Everson, 15/07/2022, Chamado TI   . Tratamento para errorlog.

	If Empty( aListBox )

		Alert( 'Nenhuma ocorrencia de Log para este Veiculo' )

	Else

		DEFINE MSDIALOG oDlg TITLE "Hist�rico/Log" FROM aSize[7],00 To aSize[6],aSize[5] OF oMainWnd PIXEL

		@ 010,10 Say 'Veiculo: '+Alltrim(ZV4->ZV4_PLACA) SIZE 200,15 OF oDlg PIXEL

		@ aPosObj[2,1],aPosObj[2,2] ListBox oListBox Fields HEADER "Usuario", "Data", "Hora", "LOG/Alteracao";
		Size aPosObj[2,4]-aPosObj[2,2],aPosObj[2,3]-aPosObj[2,1] Of oDlg Pixel ColSizes 50,50,50,70,100

		oListBox:SetArray(aListBox)

		oListBox:bLine := {|| {	aListBox[oListBox:nAT,01], DTOC(STOD(aListBox[oListBox:nAT,02])) ,aListBox[oListBox:nAT,03], aListBox[oListBox:nAT,04]}}

		ACTIVATE MSDIALOG oDlg CENTERED ON INIT EnchoiceBar(oDlg,{||nOpcao:=1, If( Obrigatorio( aGets, aTela) ,oDlg:End(),Nil)},{||nOpcao:=0,oDlg:End()},.F.,)

	Endif

	RestArea( aArea )

Return Nil 

/*/{Protheus.doc} User Function FV4EDATA
	Enviar cadastro de transportador,veiculo e motorista para o Edata. Chamado: 053926.
	@type  Function
	@author Fernando Sigoli
	@since 
	@version 01
/*/

User Function FV4EDATA()

	Local aArea		:= GetArea()
	Local lIntegrou := .T.
	Local cErro     := ""

	BEGIN TRANSACTION

		// *** INICIO CAMPO ZV4_CPF **** // 
		IF (ALLTRIM(ZV4->ZV4_CPF) <> '' .OR. ALLTRIM(ZV4->ZV4_PASPO) <> '')

			lIntegrou := fEnveData(iif(empty(ZV4->ZV4_CPF), ZV4->ZV4_PASPO, ZV4->ZV4_CPF), ZV4->ZV4_FORNEC, ZV4->ZV4_PLACA, cEmpAnt)

		ENDIF
		// *** FINAL CAMPO ZV4_CPF **** //

		// *** INICIO CAMPO ZV4_CPF1 **** // 
		IF (ALLTRIM(ZV4->ZV4_CPF1) <> '' .OR. ALLTRIM(ZV4->ZV4_PASPO1) <> '') .AND. lIntegrou

			lIntegrou := fEnveData(iif(empty(ZV4->ZV4_CPF1), ZV4->ZV4_PASPO1, ZV4->ZV4_CPF1), ZV4->ZV4_FORNEC, ZV4->ZV4_PLACA, cEmpAnt)
		
		ENDIF
		// *** FINAL CAMPO ZV4_CPF1 **** //

		// *** INICIO CAMPO ZV4_CPF2 **** // 
		
		IF (ALLTRIM(ZV4->ZV4_CPF2) <> '' .OR. ALLTRIM(ZV4->ZV4_PASPO2) <> '') .AND. lIntegrou

			lIntegrou := fEnveData(iif(empty(ZV4->ZV4_CPF2), ZV4->ZV4_PASPO2, ZV4->ZV4_CPF2), ZV4->ZV4_FORNEC, ZV4->ZV4_PLACA, cEmpAnt)

		ENDIF
		
		// *** FINAL CAMPO ZV4_CPF2 **** //

		// *** INICIO CAMPO ZV4_CPF3 **** // 
		
		IF (ALLTRIM(ZV4->ZV4_CPF3) <> '' .OR. ALLTRIM(ZV4->ZV4_PASPO3) <> '') .AND. lIntegrou
			
			lIntegrou := fEnveData(iif(empty(ZV4->ZV4_CPF3), ZV4->ZV4_PASPO3, ZV4->ZV4_CPF3), ZV4->ZV4_FORNEC, ZV4->ZV4_PLACA, cEmpAnt)

		ENDIF
		
		// *** FINAL CAMPO ZV4_CPF3 **** //

		// *** INICIO CAMPO ZV4_CPF4 **** // 
		// LPM 15/04/2021
		
		IF (ALLTRIM(ZV4->ZV4_CPF4) <> '' .OR. ALLTRIM(ZV4->ZV4_PASPO4) <> '') .AND. lIntegrou

			lIntegrou := fEnveData(iif(empty(ZV4->ZV4_CPF4), ZV4->ZV4_PASPO4, ZV4->ZV4_CPF4), ZV4->ZV4_FORNEC, ZV4->ZV4_PLACA, cEmpAnt)

		ENDIF
		
		// *** FINAL CAMPO ZV4_CPF4 **** //

		// *** INICIO CAMPO ZV4_CPF5 **** // 
		// LPM 15/04/2021
		
		IF (ALLTRIM(ZV4->ZV4_CPF5) <> '' .OR. ALLTRIM(ZV4->ZV4_PASPO5) <> '') .AND. lIntegrou

			lIntegrou := fEnveData(iif(empty(ZV4->ZV4_CPF5), ZV4->ZV4_PASPO5, ZV4->ZV4_CPF5), ZV4->ZV4_FORNEC, ZV4->ZV4_PLACA, cEmpAnt)

		ENDIF
		
		// *** FINAL CAMPO ZV4_CPF5 **** //

		// *** INICIO CAMPO ZV4_CPF6 **** // 
		// LPM 15/04/2021
		
		IF (ALLTRIM(ZV4->ZV4_CPF6) <> '' .OR. ALLTRIM(ZV4->ZV4_PASPO6) <> '') .AND. lIntegrou

			lIntegrou := fEnveData(iif(empty(ZV4->ZV4_CPF6), ZV4->ZV4_PASPO6, ZV4->ZV4_CPF6), ZV4->ZV4_FORNEC, ZV4->ZV4_PLACA, cEmpAnt)

		ENDIF
		
		// *** FINAL CAMPO ZV4_CPF6 **** //

		// *** INICIO CAMPO ZV4_CPF7 **** // 
		
		IF (ALLTRIM(ZV4->ZV4_CPF7) <> '' .OR. ALLTRIM(ZV4->ZV4_PASPO7) <> '') .AND. lIntegrou

			lIntegrou := fEnveData(iif(empty(ZV4->ZV4_CPF7), ZV4->ZV4_PASPO7, ZV4->ZV4_CPF7), ZV4->ZV4_FORNEC, ZV4->ZV4_PLACA, cEmpAnt)

		ENDIF
		
		// *** FINAL CAMPO ZV4_CPF7 **** //

		// *** INICIO CAMPO ZV4_CPF8 **** // 
		
		IF (ALLTRIM(ZV4->ZV4_CPF8) <> '' .OR. ALLTRIM(ZV4->ZV4_PASPO8) <> '') .AND. lIntegrou

			lIntegrou := fEnveData(iif(empty(ZV4->ZV4_CPF8), ZV4->ZV4_PASPO8, ZV4->ZV4_CPF8), ZV4->ZV4_FORNEC, ZV4->ZV4_PLACA, cEmpAnt)

		ENDIF
		
		// *** FINAL CAMPO ZV4_CPF8 **** //

		// *** INICIO CAMPO ZV4_CPF9 **** // 
		//LPM - 15/04/2021
		
		IF (ALLTRIM(ZV4->ZV4_CPF9) <> '' .OR. ALLTRIM(ZV4->ZV4_PASPO9) <> '') .AND. lIntegrou

			lIntegrou := fEnveData(iif(empty(ZV4->ZV4_CPF9), ZV4->ZV4_PASPO9, ZV4->ZV4_CPF9), ZV4->ZV4_FORNEC, ZV4->ZV4_PLACA, cEmpAnt)

		ENDIF
		
		// *** FINAL CAMPO ZV4_CPF9 **** //
		
		cErro := ''
		cErro := U_RetErroED() 

		IF lIntegrou == .T. .AND. SUBSTRING(cErro,12,11) <> 'FI_TRANVEIC'
		
			If ! IsInCallStack("U_FCEDATA")

				MSGINFO("Atualizado com sucesso "+ZV4->ZV4_PLACA," Integra�ao E-data - AXFV4-01 ")

			EndIf

		ELSE

			DisarmTransaction()	
			MSGSTOP( 'Dados n�o atualizado '+ZV4->ZV4_PLACA + CHR(13) + CHR(10) + cErro, 'Erro Integra��o E-data - AXFV4-02' )

		ENDIF

	END TRANSACTION	

	RestArea(aArea)

Return lIntegrou		

Static Function fEnveData(cCPFPass, cFornece, cPlaca, cEmpresa)
	Local lRet 		:= .F.
	Local nStatus 	:= 0
	Local cError     := ''
	Local cRotDesc	:= "Integracao Protheus x Edata - U_AXFV4"

	if SqlMotorista(cCPFPass)
		

		nStatus :=  TcSQLExec('EXEC ['+cLinkSe+'].[SMART].[dbo].[FI_TRANVEIC] '+    "'"+cFornece+"'"    +","+     "'"+cPlaca+"'"   +",'"+  cCPFPass +"',"+  "'"+cEmpresa+"'" )
		
		// Inicio Ticket 61154  - 05/10/2021 - SIGOLI 
		cError := U_RetErroED() 
		
		
		IF !Empty(cError) .or. (nStatus < 0)
			If nStatus < 0 
			
				cError := cError +" -  Erro na procedure e/ou comunica��o com Edata"

			ENDIF

			U_ExTelaMen(cRotDesc,cError,"Arial",10,,.F.,.T.)
			lRet := .F.
		
		ELSE
			lret := .T. 
		ENDIF
		// Fim Ticket 61154  - 05/10/2021 - SIGOLI 
		
	else
		MSGSTOP( 'N�o foi encontrado o cadastro do Motorista com o CPF/Passaporte '+ cCPFPass + CHR(13) + CHR(10) + '. O registro n�o foi enviado ao E-data - AXFV4-03' )
		lRet 	:= .F.
		
	Endif
	
return lRet


/*/{Protheus.doc} cadSAG
	(long_description)
	@type  Static Function
	@author Everson
	@since 21/02/2020
	@version 01
/*/

User Function FV4SAG()

	Local aArea		:= GetArea()
	Local nStatus   := 0
	Local cScript	:= ""

	U_ADINF009P('AXFV4' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de veiculos SAG')

	If Empty(Alltrim(ZV4->ZV4_CPF)) .Or. Empty(Alltrim(ZV4->ZV4_FORNEC))
		MsgStop("� necess�rio que o ve�culo tenha vinculo com transportadora e motorista.","Fun��o FV4SAG(AXFV4)")
		RestArea(aArea)
		Return Nil 

	EndIf

	If ! MsgNoYes("Deseja Atualizar/Enviar o cadastro do ve�culo " + ZV4->ZV4_PLACA + " ao sistema SAG?","Fun��o FV4SAG(AXFV4)")
		RestArea(aArea)
		Return Nil 

	EndIf

	cScript	:= ' EXEC [SCSRV03].[ADORO].[dbo].[ADO_INTEGRA_VEICULO_PROTHEUS] ' +    "'" + Alltrim(ZV4->ZV4_PLACA) + "';"

	Conout( DToC(Date()) + " " + Time() + " AXFV4 - FV4SAG - cScript " + cValToChar(cScript) )

	nStatus :=  TcSQLExec(cScript)

	Conout( DToC(Date()) + " " + Time() + " AXFV4 - FV4SAG - nStatus " + cValToChar(nStatus) )

	MsgInfo("Processo conclu�do.","Fun��o FV4SAG(AXFV4)")

	RestArea(aArea)

Return Nil

/*/{Protheus.doc} User Function FV4Caixas
	Cadastro de caixas para ve�culos de ra��o.
	@type  Function
	@author Everson
	@since 26/02/2020
	@version 01
/*/

User Function FV4Caixas()

	//Vari�veis.
	Local aArea := GetArea()

	//Everson, 24/03/2022, Chamado 18465.
	If ALTERA
		U_ADFAT37A(M->ZV4_PLACA)

	EndIf

	RestArea(aArea)
	
	// Local oCadCx	:= Nil
	// Local cTitulo	:= "Cadastro de Caixas"
	// Local aHCaixas	:= {}
	// Local oCaixas	:= Nil
	// Local aColsCx	:= {}
	// Local aAltCx	:= {"NCX","CAP","CAPC"}
	// Local oFechar	:= Nil

	// oCadCx		     := MsDialog():Create()
	// oCadCx:cName     := "oCadCx"
	// oCadCx:cCaption  := cTitulo
	// oCadCx:nLeft     := 34
	// oCadCx:nTop      := 222
	// oCadCx:nWidth    := 530
	// oCadCx:nHeight   := 450
	// oCadCx:lShowHint := .F.
	// oCadCx:lCentered := .T.
	
	// aAdd(aHCaixas,{"Num Cx"    ,"NCX" ,"@E 99"     ,02,0,"","","N","",""})
	// aAdd(aHCaixas,{"Capacidade","CAPC","@E 999999" ,06,0,"","","N","",""})	
	
	// oCaixas := MsNewGetDados():New(000,000,180,265,GD_INSERT+GD_UPDATE+GD_DELETE,"Allwaystrue()","Allwaystrue()","",aAltCx,,15,Nil,Nil,Nil,oCadCx,aHCaixas,@aColsCx)

	// TButton():New(190,170,"Ok",oCadCx,{|| MsAguarde({|| grvComp(oCaixas,aHCaixas,oCadCx) },"Aguarde","Salvando dados...") },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	
	// oFechar	 := TButton():New(190,215,"Fechar",oCadCx,{|| oCadCx:End() },40,10,,,.F.,.T.,.F.,,.F.,,,.F. )
	// oFechar:SetCss("QPushButton{background-color: qlineargradient(x1: 0, y1: 0, x2: 0, y2: 1, stop: 0 #FF0000, stop: 1 #8C1717);color: white}")	

	// oCadCx:Activate(,,,.T.,{||.T.},,{|| MsAguarde({|| carrDados(oCaixas,aHCaixas) },"Aguarde","Carregando dados...")  })

	// RestArea(aArea)

Return Nil

/*/{Protheus.doc} carrDados
	(long_description)
	@type  Static Function
	@author Everson
	@since 26/02/2020
	@version 01
/*/

Static Function carrDados(oCaixas,aHCaixas)

	Local aArea	  := GetArea()
	Local cDados1 := Alltrim(cValToChar(M->ZV4_CAIXAS))
	Local aDados1 := {}
	Local aDados2 := {}
	Local i		  := 1
	Local x		  := 1

	aDados1 := StrToKarr(cDados1,",")
	varinfo("aDados1",aDados1)

	If Len(aDados1) > 0
		oCaixas:aCols := {}

	EndIf

	For i := 1 To Len(aDados1)
		
		If At("-",Alltrim(aDados1[i])) > 0

			//
			aDados2 := StrToKarr(Alltrim(aDados1[i]),"-")
			varinfo("aDados2",aDados2)

			Aadd(oCaixas:aCols , Array(Len(aHCaixas)+1) )
			oCaixas:aCols[i,Ascan(aHCaixas,{|x| AllTrim(x[2]) == "NCX"  })]  := Val(cValToChar(aDados2[1]))
			oCaixas:aCols[i,Ascan(aHCaixas,{|x| AllTrim(x[2]) == "CAPC"  })] := Val(cValToChar(aDados2[2]))
		
		EndIf
			
	Next i
	
	oCaixas:Refresh()

	RestArea(aArea)
	
Return Nil 

/*/{Protheus.doc} grvComp
	Grava dados de caixas dos ve�culos.
	@type  Static Function
	@author Everson
	@since 26/02/2020
	@version 01
/*/

Static Function grvComp(oCaixas,aHCaixas,oCadCx)

	Local aArea	:= GetArea()
	Local i 	:= 1
	Local cDados:= ""
	
	For i := 1 To Len(oCaixas:aCols)
		
		If ! (oCaixas:aCols[i,Len(aHCaixas)+1]) 
			
			cDados  += Alltrim(cValToChar(oCaixas:aCols[i][aScan(aHCaixas,{|x| Alltrim(x[2]) == "NCX"})])) + "-" + Alltrim(cValToChar(oCaixas:aCols[i][aScan(aHCaixas,{|x| Alltrim(x[2]) == "CAPC"})])) + ","
			
		EndIf
	
	Next i

	M->ZV4_CAIXAS := cDados

	oCadCx:End()
	
	RestArea(aArea)

Return Nil

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 26/02/2020
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/

User Function FV4TGSG() // U_FV4TGSG()

    Local aArea     := GetArea()
	Local nPort		:= 0
	Local cIp		:= ""
    Local oObj      := TSocketClient():New()
    Local nX        := 1
    Local nTEspC    := 10000        
    Local nNumT     := 3           
    Local nResp     := -1           
    Local nSleep    := 2000        
    Local nTEspR    := 10000        
    Local cBuffer   := ""          
    Local cErro     := ""
	Local aLeitor1	:= StrToKarr(Alltrim(GetMV("MV_#LTGUA1")),"/")
	Local aLeitor2	:= StrToKarr(Alltrim(GetMV("MV_#LTGUA2")),"/")

	If ! Pergunte("TAGSAG")
		RestArea(aArea)
		Return Nil 

	EndIf

	If MV_PAR01 == 1 //Leitor 1.
		cIp   := aLeitor1[1]//"10.6.3.230"
		nPort := Val(aLeitor1[2])//8881

	Else //Leitor 2.
		cIp   := aLeitor2[1]//"10.6.3.231"
		nPort := Val(aLeitor2[2])//8881

	EndIf

	Conout( DToC(Date()) + " " + Time() + " AXFV4 - Leitor / cIp / nPort " + cValToChar(MV_PAR01) + " " + cValToChar(cIp) + " / " + cValToChar(nPort) )
 
    //Tenta conectar.
    For nX := 1 To nNumT        
    
        FWMsgRun(, {|oSay| nResp := oObj:Connect( nPort,cIp, nTEspC ) }, "Aguarde", "Estabelecendo conex�o...")

        //Se conectou sai o For.
        If(nResp == 0 )
            exit

        Else
            Conout( DToC(Date()) + " " + Time() + " --> Tentativa de Conex�o porta: " + cValToChar(nPort) + " IP: " + cValToChar(cIp) + " " + StrZero(nX,3) )
            Sleep(nSleep)

        EndIf

    Next nX          
     
    // Verifica se a conex�o foi bem sucedida.
    If( ! oObj:IsConnected() )
        Conout( DToC(Date()) + " " + Time() + " --> Falha na conex�o ")
        MsgStop("N�o foi poss�vel estabelecer conex�o.","Fun��o ")
        RestArea(aArea)
        Return Nil 

    Else 
        Conout( DToC(Date()) + " " + Time() + " --> Conex�o OK ")

    EndIf 
 
    // Teste de recebimento do socket.
    If( ! oObj:IsConnected() )
        Conout( DToC(Date()) + " " + Time() + " --> Falha na conex�o ")
        RestArea(aArea)
        Return Nil
    
    Else 
        Conout( DToC(Date()) + " " + Time() + " --> Conectado ")

    EndIf
    
    FWMsgRun(, {|oSay| nResp := oObj:Receive( @cBuffer, nTEspR ) }, "Aguarde", "Efetuando leitura...")
    Conout( DToC(Date()) + " " + Time() + " --> nResp " + cValToChar(nResp) )
    If ( nResp >= 0 )
		cBuffer := Alltrim(cValToChar(StrTran(StrTran(cBuffer,Chr(2),""),Chr(3),""))) //Everson - 05/07/2022. Chamado 18465.
		cBuffer := U_ADFAT50O(cBuffer)
        Conout( DToC(Date()) + " " + Time() + " --> cBuffer " + cValToChar(cBuffer) )
		M->ZV4_TGFIXA := Alltrim(cValToChar(cBuffer))

    ElseIf nResp < 0 
        oObj:GetError(@cErro)
        Conout( DToC(Date()) + " " + Time() + " --> Erro " + cValToChar(cErro) )
        MsgStop("Ocorreu erro na leitura dos dados." + Chr(13) + Chr(10) + cValToChar(cErro) ,"Fun��o ")

    EndIf 
 
    //Fecha conex�o.
    oObj:CloseConnection()
    Conout( DToC(Date()) + " " + Time() +  " --> Conex�o fechada" )

    RestArea(aArea)

Return cBuffer

STATIC FUNCTION SqlMotorista(cDoc)
	
	Local lRet		:= .T.

    BeginSQL Alias "TRC"
			%NoPARSER% 
			SELECT *
			  FROM %TABLE:ZVC% WITH(NOLOCK)
			 WHERE D_E_L_E_T_='' AND (ZVC_CPF     = %EXP:cDoc% OR ZVC_PASPOR     = %EXP:cDoc%) AND 
					NOT ((ZVC_CPF     = '' AND ZVC_PASPOR     = '') OR (ZVC_CPF    <> '' AND ZVC_PASPOR    <> ''))
			   AND D_E_L_E_T_ <> '*'
		
    EndSQl          

	if TRC->(!eof())
		lRet := .T.
	else
		lRet := .F.
	endif

	TRC->(DbCloseArea())

RETURN lRet
/*/{Protheus.doc} grvBarr
    Salva o registro para enviar ao barramento.
    @type  User Function
    @author Everson
    @since 18/03/2022
    @version 01
/*/
Static Function grvBarr(cOperacao, cNumero)

    //Vari�veis.
    Local aArea    := GetArea()
    Local cFilter  := " ZIX_FILIAL ='" + FWxFilial("ZIX") + "' .And. ZIX_PLACA = '" + cNumero + "' "

	U_ADFAT27D("ZV4", 1, FWxFilial("ZV4") + cNumero,;
			   "ZIX", 1, FWxFilial("ZIX") + cNumero, "ZIX_NUMERO",cFilter,;
			   "cadastro_de_veiculos_protheus", cOperacao,;
			   .T., .T.,.T., Nil, "caixas")

    RestArea(aArea)

Return Nil
/*/{Protheus.doc} fCRANK
	Cria cadastro no appLogRank.
	@type  User Function
	@author Everson
	@since 16/09/2022
	@version 01
/*/
User Function fCRANK()

	//Vari�veis.
	Local aArea 	:= GetArea()
	Local cUrl      := Alltrim(cValToChar(GetMV("MV_#ZV4001",,"http://3.144.125.195:8080")))
	Local cServico  := ""
	Local cMetodo 	:= "Post"
	Local cQuery	:= ""
	Local cNewAlias	:= ""
	Local oJson		:= Nil
	Local cBody		:= ""
	Local cToken	:= ""
	Local cMsgError	:= ""
	Local cMsg		:= ""
	Local lRetEnv	:= .F.
	Local nAux		:= 1
	Local aPlacas	:= {}

	If ! Pergunte("AXFV41",.T.)
		RestArea(aArea)
		Return Nil

	EndIf

	MsAguarde({|| lRetEnv := login(cUrl, @cToken, @cMsgError) }, "Fun��o fCRANK(AXFV4)", "Efetuando login...")

	If ! lRetEnv
		MsgInfo("N�o foi poss�vel efetuar login " + xPula + cMsgError, "Fun��o fCRANK(AXFV4)")
		RestArea(aArea)
		Return Nil

	EndIf

	cQuery := ""
	cQuery += " SELECT  " 
		cQuery += " ZV4_PLACA, A4_EMAIL, A4_NOME  " 
	cQuery += " FROM  " 
		cQuery += " " + RetSqlName("ZV4") + " (NOLOCK) AS ZV4  " 
		cQuery += " LEFT OUTER JOIN " 
		cQuery += " " + RetSqlName("SA4") + " (NOLOCK) AS SA4 ON " 
		cQuery += " ZV4_FORNEC = A4_COD " 
		cQuery += " AND ZV4_LOJFOR = A4_LOJTRA " 
	cQuery += " WHERE  " 
		cQuery += " ZV4_FILIAL = '" + FWxFilial("ZV4") + "'  " 
		cQuery += " AND ZV4_PLACA BETWEEN '" + MV_PAR01 + "' AND '" + MV_PAR02 + "' " 
		cQuery += " AND ZV4.D_E_L_E_T_ = ''  " 
		cQuery += " AND SA4.D_E_L_E_T_ = '' " 
		cQuery += " ORDER BY  " 
		cQuery += " ZV4_PLACA " 

	cNewAlias := GetNextAlias()

	DbUseArea( .T., "TOPCONN", TcGenQry( ,, cQuery), cNewAlias, .F., .T. )

	(cNewAlias)->(DbGoTop())

	If (cNewAlias)->(Eof())
		MsgInfo("N�o h� dados a serem enviados.", "Fun��o fCRANK(AXFV4)")
		(cNewAlias)->(DbCloseArea())
		RestArea(aArea)
		Return Nil

	EndIf

	If ! sendAWS(cUrl, "/api/users", "Get", cToken, "", @cMsg)
		 U_TExTelaMen("Erro", cMsg, "Arial",10,,.F.,.F.)
		(cNewAlias)->(DbCloseArea())
		RestArea(aArea)
		Return Nil

	EndIf

	If ! Empty(cMsg)

		oJson := JsonObject():new()

		oJson:FromJson(cMsg)

		For nAux := 1 To Len(oJson)

			Aadd(aPlacas, oJson[nAux]['username'])

		Next nAux

		FreeObj(oJson)
		oJson := Nil


	EndIf

	While ! (cNewAlias)->(Eof())

		cMetodo   := "Post"
		cServico  := "/api/auth/signup"

		oJson := JsonObject():new()

		oJson['username'] := Alltrim(CValToChar( (cNewAlias)->ZV4_PLACA ))
		oJson['name'] 	  := Alltrim(CValToChar( (cNewAlias)->A4_NOME ))
		oJson['licenses'] := Alltrim(CValToChar( (cNewAlias)->ZV4_PLACA ))
		oJson['email'] 	  := Alltrim(CValToChar( (cNewAlias)->A4_EMAIL ))
		oJson['password'] := Alltrim(CValToChar( (cNewAlias)->ZV4_PLACA ))

		cBody := oJson:toJSON()

		FreeObj(oJson)
		oJson := Nil
		cMsg  := ""

		If MV_PAR03 == 2
			cMetodo  := "Delete"
			cServico := "/api/users"

		ElseIf Len(aPlacas) > 0 .And. Ascan(aPlacas, Alltrim(CValToChar( (cNewAlias)->ZV4_PLACA ))) > 0
			cMetodo  := "Put"
			cServico := "/api/users"

		EndIf

        MsAguarde({|| lRetEnv := sendAWS(cUrl, cServico, cMetodo, cToken, cBody, @cMsg) }, "Aguarde", "Enviando " + Alltrim(cValToChar((cNewAlias)->ZV4_PLACA)) )

        If ! lRetEnv
            U_TExTelaMen("Erro - " + Alltrim(cValToChar((cNewAlias)->ZV4_PLACA)) , cMsg, "Arial",10,,.F.,.F.)

        EndIf

		(cNewAlias)->(DbSkip())

	End

	(cNewAlias)->(DbCloseArea())

	MsgInfo("Processo finalizado.", "Fun��o fCRANK(AXFV4)")

	RestArea(aArea)

Return Nil
/*/{Protheus.doc} ADVEN591
	Efetua login.
	@type  Static Function
	@author Everson
	@since 31/07/2022
	@version 01
/*/
Static Function login(cUrl, cToken, cMsgError)

	//Vari�veis.
	Local aArea  	:= GetArea()
	Local lRet   	:= .F.
	Local cServico 	:= "/api/auth/signin"
	Local cUser  	:= Alltrim(cValToChar(GetMV("MV_#ZV4002",,"sistemas")))
	Local cPassword := Alltrim(cValToChar(GetMV("MV_#ZV4004",,"123456")))
	Local aHeader	:= {}
	Local oJson     := JsonObject():new()
	Local cBody		:= ""
	Local cMsg		:= ""
	Local lRest		:= .F.
	
	Default cToken	:= ""

	Aadd(aHeader, "Content-Type: application/json")
	
	oJson['username'] := cUser
	oJson['password'] := cPassword

	cBody := oJson:toJSON()

	FreeObj(oJson)
	oJson := Nil

	oRestClient := FWRest():New(cUrl)
	oRestClient:setPath(cServico)

	oRestClient:SetPostParams(cBody)
	lRest := oRestClient:Post(aHeader)

	If ! lRest
		cMsgError := Alltrim(cValToChar(oRestClient:GetLastError())) + xPula + Alltrim(cValToChar(oRestClient:GetResult()))
		
	Else
		lRet := .T.
		cMsg := Alltrim(cValToChar(oRestClient:GetResult()))

		oJson := JsonObject():new()
        oJson:fromJson(cMsg)

		cToken := oJson['accessToken']

		FreeObj(oJson)
		oJson := Nil

	EndIf

	RestArea(aArea)

Return lRet
/*/{Protheus.doc} ADVEN593
    Envia requisi��o.
    @type  Static Function
    @author Everson
    @since 31/07/2022
    @version 01
/*/
Static Function sendAWS(cUrl, cServico, cMetodo, cToken, cBodyRq, cMsg)

    //Vari�veis.
	Local aArea 		:= GetArea()
	Local lRet			:= .T.
	Local oRestClient 	:= Nil
	Local lRest			:= .F.

    Private aHeader	:= {}
    Private cBody       := cBodyRq

	Default cServico	:= ""
	Default cBody		:= ""
	Default cMsg		:= ""
	Default aResponse	:= {}

    Aadd(aHeader, "Content-Type: application/json")
	Aadd(aHeader, "x-access-token: " + cToken)

	oRestClient := FWRest():New(cUrl)
	oRestClient:setPath(cServico)

    If cMetodo == "Post"
        oRestClient:SetPostParams(cBody)
        lRest := oRestClient:Post(aHeader)

    ElseIf cMetodo == "Put"
        lRest := oRestClient:Put(aHeader, cBody)

    ElseIf cMetodo == "Get"
        lRest := oRestClient:Get(aHeader)

    ElseIf cMetodo == "Delete"
        lRest := oRestClient:Delete(aHeader, cBody)

    Endif

	cMsg := ""

	If ! lRest

		If Substr(Alltrim(cValToChar(oRestClient:GetLastError())),1,1) <> "2" 

			cMsg := Alltrim(cValToChar(oRestClient:GetLastError())) + Chr(13) + Chr(10)
			cMsg += "URL: "      + cUrl + Chr(13) + Chr(10)
			cMsg += "EndPoint: " + cServico + Chr(13) + Chr(10)
			cMsg += "M�todo: "   + cMetodo + Chr(13) + Chr(10)
			cMsg += "Body: "     + Chr(13) + Chr(10) + cValToChar(cBody) + Chr(13) + Chr(10)
			cMsg += "Resp: "     + Chr(13) + Chr(10) + Alltrim(cValToChar(oRestClient:GetResult())) + Chr(13) + Chr(10)
			lRet := .F.

		EndIf

	EndIf
	
	If lRet 
        cMsg := Alltrim(cValToChar(oRestClient:GetResult()))

	EndIf

	FreeObj(oRestClient)
	oRestClient := Nil
	RestArea(aArea)

Return lRet
