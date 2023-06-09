#Include "Protheus.ch"
#Include 'Topconn.ch'

/*/{Protheus.doc} User Function EAE100MNU
    Ponto de entrada na rotina de consulta/manuten��o de embarque no m�dulo de exporta��o. Chamado 046689.
    Chamado 046689
    @type  Function
    @author Everson
    @since 24/01/2019
    @version 01
    @history Chamado 8465 - Leonardo P. Monteiro - 04/03/2021 - Inclus�o das valida��es do projeto de exporta��o.
/*/
User Function EAE100MNU()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local aArea			:= GetArea()
	Local aFuncoes		:={}
	Local cUsuarios		:= Alltrim(cValToChar( GetMv("MV_#USREXP",,"")  ))
	Local lPrcPGA   	:= SUPERGETMV("MV_XPGAPRC",,.T.)
	//
	If Alltrim(cValToChar( __cUserId )) $cUsuarios
		Aadd(aFuncoes,{"Reabrir Embarque"	,"U_EAE100_rem()"	,0,8})
		
	EndIf
	

	if lPrcPGA
		Aadd(aFuncoes,{"Cons. Cadastro PGA"	,"U_ADEST055P()"	,0,8})
	endif
	
	//
	RestArea(aArea)

Return aFuncoes
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �EAE100_rem �Autor  �Everson            � Data �  24/01/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Reabre processo de embarque.                                ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 046689.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function EAE100_rem()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local aArea		:= GetArea()
	Local cProcesso	:= Alltrim(cValToChar(EEC->EEC_PREEMB))
	Local cStatus	:= Alltrim(cValToChar(EEC->EEC_STATUS))
	
	//
	If Alltrim(cValToChar(EEC->EEC_STATUS)) <> "*"
		MsgStop("N�o � poss�vel reabrir o registro selecionado. Embarque/processo " + cProcesso + " (EEC_STATUS = " + cStatus + ").","Fun��o EAE100_rem (EAE100MNU)")
		RestArea(aArea)
		Return Nil
		
	EndIf
	
	//
	If ! MsgYesNo("Deseja reabrir o embarque/processo " + cProcesso + "?","Fun��o EAE100_rem (EAE100MNU)")
		RestArea(aArea)
		Return Nil
			
	EndIf
	
	//
	DbSelectArea("EEC")
	RecLock("EEC",.F.)
		EEC->EEC_FIM_PE	:= CToD(" ")
		EEC->EEC_STATUS	:= "4"
		EEC->EEC_STTDES	:= "Aguardando Confeccao Documentos"
	MsUnlock()

	//
	DbSelectArea("ZBE")
	RecLock("ZBE",.T.)
		ZBE->ZBE_FILIAL := cFilAnt
		ZBE->ZBE_DATA	:= Date()
		ZBE->ZBE_HORA	:= Substr(cValToChar(Time()),1,8)
		ZBE->ZBE_USUARI	:= cUserName
		ZBE->ZBE_LOG	:= "Embarque/processo " + cProcesso + " reaberto."
		ZBE->ZBE_MODULO	:= "EXPORTACAO"
		ZBE->ZBE_ROTINA	:= "EAE100MNU"
		ZBE->ZBE_PARAME	:= cProcesso
	MsUnlock()
	
	//
	MsgInfo("Embarque/processo " + cProcesso + " reaberto.","Fun��o EAE100_rem (EAE100MNU)")
	
	//
	RestArea(aArea)
	
Return Nil
