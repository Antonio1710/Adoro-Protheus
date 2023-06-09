

#include "protheus.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �PMA200GRV �Autor  �Fernando Macieira   � Data � 02/Mai/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Ponto de Entrada para consistir alteracao de fase          ���
���          � Chamado 041254                                             ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������

/*
If lOk
If ExistBlock("PMA200GRV")
lOk := ExecBlock("PMA200GRV", .F., .F.)
EndIf
EndIf
*/


User Function PMA200GRV()

Local lOk 	  := .t.
Local cMail2  := ""
Local cMail   := ""
Local cMail3  := ""

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'P.E p/ consistir alteracao de fase de projetos')
	

// Consisto se esta na central de aprovacao
ZC7->( dbSetOrder(3) ) // ZC7_FILIAL+ZC7_PROJET
If ZC7->( dbSeek( FWxFilial("ZC7") + M->AF8_PROJET + M->AF8_REVISA ) )
	
	// Checo se est� aguardando aprovacao
	If Empty(ZC7->ZC7_USRAPR)
		
		lOk := .f.
		Aviso("PMA200GRV-02", "Projeto encontra-se na central de aprova��o... Altera��o de fase n�o permitida!" , {"OK"}, 3, "Altera��o de fase")
		
	EndIf
	
EndIf


// Permite apenas fase que far� o encerramento
If lOk
	
	If AllTrim(AEA->AEA_EVEN97) <> "1"
		
		lOk := .f.
		Aviso("PMA200GRV-01", "Fase escolhida " + Alltrim(AEA->AEA_COD) + " n�o est� configurada para encerrar projeto! Altera��o de fase n�o permitida..." , {"OK"},, "Altera��o de fase")
		
	
	Else
		
		// Envia email de aviso do encerramento para os envolvidos
		aDadWF := {}
		cMail  := UsrRetMail(AF8->AF8_XUSER) 
		
		If ZCH->(FieldPos("ZCH_EMAIL")) > 0
			cMail2 := UsrRetMail(Posicione("ZCH",1,xFilial("ZCH")+AF8->AF8_XSPONS,"ZCH_EMAIL"))
			If !Empty(cMail2)
				cMail := cMail + ";" + cMail2
			EndIf
		EndIf                                       
		                                     
		cMail3 := UsrRetMail(AF8->AF8_XCODAP)
		If !Empty(cMail2)
			cMail := cMail + ";" + cMail3
		EndIf
		
		// DEBUG
		If Empty(cMail)
		//	cMail := "fwnmacieira@gmail.com"
		EndIf
		
		aAdd( aDadWF, { M->AF8_PROJET, M->AF8_REVISA, "", cUserName, msDate(), time(), AF8->AF8_XVALOR, cMail, AF8->AF8_DESCRI, AF8->AF8_XCODAP } )
		
		u_ADPRJ004P(aDadWF, "ENCERRAPRJ") 
                                                                     
 		/*
	aWFItens := { {cCodPrj, TamSX3("AF8_PROJETO")[1], "left"},;
		{cRevPrj, TamSX3("AF8_REVISA")[1], "left"},;
		{aDadWF[1,9], TamSX3("AF8_DESCRI")[1], "left"},;
		{aDadWF[1,7], TamSX3("AF8_XVALOR")[1], "right"},;
		{aDadWF[1,4], TamSX3("ZC7_NOMAPR")[1], "left"},;
		{DtoC(dDtaApr), TamSX3("ZC7_DTAPR")[1], "right"},;
		{cHrApr, TamSX3("ZC7_HRAPR")[1], "right"} }

 		*/
	
	EndIf
	
EndIf



Return lOk
