#Include 'Protheus.ch'
#Include 'FwMVCDef.ch'
#Include 'TOPCONN.ch'

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADLOG062P �Autor  �Fernando Macieira   � Data �  01/08/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     � Markbrowse para amarracao de roteiro e atendente           ���
���          � Sera utilizado no relatorio ROTLOG                         ���
�������������������������������������������������������������������������͹��
���Chamado   � 049495 || OS 050775 || ADM.LOG || MARCEL || 8365 ||        ���
���          � || ROMANEIO ENTREGAS                                       ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ADLOG062P()

	Local aAreaAtu   := GetArea()
	Local cFunBkp    := FunName()
	Local cFiltroZFN := "" 
	Local cCabec     := "Marque os roteiros para definir um atendente "

    Private oMark, cCodZFM
	Private l061P    := .f.

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Markbrowse para amarracao de roteiro e atendente Sera utilizado no relatorio ROTLOG')
	
    If FunName() == "ADLOG061P"
    	l061p      := .t.
    	cCodZFM    := ZFM->ZFM_CODIGO
    	cCabec     := "Marque os roteiros do atendente " + ZFM->ZFM_CODIGO + " - " + ZFM->ZFM_NOME
    	cFiltroZFM := 'Empty(ZFN_CODIGO) .OR. ZFN_CODIGO = "'+ZFM->ZFM_CODIGO+'"'
    EndIf

    SetFunName("ADLOG062P")
     
   	GrvRoteiro()
    
    //Criando o MarkBrow
    oMark := FWMarkBrowse():New()
    oMark:SetAlias('ZFN')

    If l061P
    	ZFN->( dbSetFilter( { ||&cFiltroZFM }, cFiltroZFM ) )
    EndIF
    
    //Setando sem�foro, descri��o e campo de mark
    oMark:SetSemaphore(.T.)
    oMark:SetDescription(cCabec)
    oMark:SetFieldMark( 'ZFN_OK' )
     
    //Setando Legenda
    oMark:AddLegend( "Empty(ZFN->ZFN_CODIGO)"  , "GREEN",  "Roteiro sem atendente" )
    oMark:AddLegend( "!Empty(ZFN->ZFN_CODIGO)" , "RED"  ,  "Roteiro com atendente definido" )
     
    //Ativando a janela
    oMark:Activate()    
    
    SetFunName(cFunBkp)

    RestArea(aAreaAtu)
                
Return NIL
   
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADLOG062P �Autor  �Microsiga           � Data �  08/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     �                                                            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                        ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function MenuDef()

    Local aRotina := {}
     
    //Cria��o das op��es
//    ADD OPTION aRotina TITLE 'Visualizar Atendente' 	    ACTION 'VIEWDEF.ADLOG061P' OPERATION 2 ACCESS 0
//    ADD OPTION aRotina TITLE 'Incluir Atendente'	        ACTION 'VIEWDEF.ADLOG061P' OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Gravar Roteiro no Atendente'  ACTION 'u_GrvRotAt'        OPERATION 3 ACCESS 0
    ADD OPTION aRotina TITLE 'Retirar Roteiro do Atendente' ACTION 'u_ExcRotAt'        OPERATION 2 ACCESS 0

Return aRotina
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADLOG062P �Autor  �Microsiga           � Data �  08/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria��o do modelo de dados MVC                             ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ModelDef()
Return FWLoadModel('ADLOG061P')
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADLOG062P �Autor  �Microsiga           � Data �  08/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Cria��o da vis�o MVC                                       ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ViewDef()
Return FWLoadView('ADLOG061P')
 
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADLOG062P �Autor  �Microsiga           � Data �  08/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para gravacao das amarracoes entre roteiros e aten- ���
���          � dentes                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function GrvRotAt()                                   

    Local aArea    := GetArea()
    Local cMarca   := oMark:Mark()
    Local lInverte := oMark:IsInvert()
    Local nCt      := 0
     
	Local oCmpAte  := Array(01)
	Local oBtnAte  := Array(02)
	Local lOK      := .t.
	
	Private cCodAte  := Space(TamSX3("ZFM_CODIGO")[1])

	U_ADINF009P('ADLOG062P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Markbrowse para amarracao de roteiro e atendente Sera utilizado no relatorio ROTLOG')

	If l061P
		cCodAte := cCodZFM
	
	Else
		DEFINE MSDIALOG oDlgAte TITLE "Atendente" FROM 0,0 TO 100,350  OF oMainWnd PIXEL
		
			@ 003, 003 TO 050,165 PIXEL OF oDlgAte
			
			@ 010,020 Say "Atendente:" of oDlgAte PIXEL
			@ 005,060 MsGet oCmpAte Var cCodAte SIZE 70,12 of oDlgAte PIXEL Valid ExistCpo("ZFM",cCodAte) F3 "ZFM" 
			
			@ 030,015 BUTTON oBtnAte[01] PROMPT "Confirma" of oDlgAte SIZE 68,12 PIXEL ACTION (lOK   := .T., oDlgAte:End()) 
			@ 030,089 BUTTON oBtnAte[02] PROMPT "Cancela"  of oDlgAte SIZE 68,12 PIXEL ACTION (lSair := .T., lOK := .F., oDlgAte:End()) 
			
		ACTIVATE MSDIALOG oDlgAte CENTERED
	EndIf
	
    If lOk

    	ZFM->( dbSetOrder(1) ) // ZFM_FILIAL+ZFM_CODIGO+ZFM_NOME
    	If ZFM->( dbSeek(FWxFilial("ZFM")+cCodAte) )
	
		    ZFN->( dbGoTop() )
		    Do While !ZFN->( EOF() )
		    	cMarca   := oMark:Mark()
		    	
		    	If oMark:IsMark(cMarca) .and. !Empty(ZFN->ZFN_CODIGO) .and. ZFN->ZFN_CODIGO <> cCodAte
		    		msgAlert("A rota " + ZFN->ZFN_ROTEIR + " est� amarrada para outro atendente! Esta n�o ser� gravada para o atendente escolhido! Exclua a amarra��o primeiro e refa�a as amarra��es...")
		    	EndIf

		        If oMark:IsMark(cMarca) .and. Empty(ZFN->ZFN_CODIGO)
		            nCt++
		            RecLock('ZFN', .F.)
		                ZFN->ZFN_OK 	:= cMarca
		                ZFN->ZFN_CODIGO := cCodAte
		            ZFN->(MsUnlock())
		        EndIf
		         
		        ZFN->(DbSkip())
		    EndDo
		     
		    MsgInfo('Foram marcados <b>' + cValToChar( nCt ) + ' roteiros para o atendente </b>' + cCodAte + " - " + POSICIONE("ZFM",1,FWxFilial("ZFM")+cCodAte,"ZFM_NOME"), "Aten��o")
		
		Else
			MsgAlert("Atendente informado n�o est� cadastrado!")

		EndIf
	
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADLOG062P �Autor  �Microsiga           � Data �  08/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para gravacao das amarracoes entre roteiros e aten- ���
���          � dentes                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function GrvRoteiro()
      
    Local lGrv := .t.
    Local nRotIni, nRotFim, cRotGrv
	Local cRotIni := GetMV("MV_#ROTINI",,"001")
	Local cRotFim := GetMV("MV_#ROTINI",,"999")
	
	nRotIni := Val(cRotIni)
	nRotFim := Val(cRotFim)	
	
	ZFN->( dbSetOrder(1) ) // ZFN_FILIAL+ZFN_ROTEIR+ZFN_CODIGO                                                                                                                                
	If ZFN->( !dbSeek( FWxFilial("ZFN")+cRotFim ) )
		
		For i := nRotIni to nRotFim
		
			cRotGrv := StrZero(i,TamSX3("ZFN_ROTEIR")[1])
			
			ZFN->( dbSetOrder(1) ) // ZFN_FILIAL+ZFN_ROTEIR+ZFN_CODIGO                                                                                                                                
			If ZFN->( dbSeek( FWxFilial("ZFN")+cRotGrv ) )
				lGrv := .f.
			EndIf
			
			RecLock("ZFN", lGrv)
				ZFN->ZFN_FILIAL := FWxFilial("ZFN")
				ZFN->ZFN_ROTEIR := cRotGrv
			ZFN->( msUnLock() )
			
		Next i
		
	EndIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADLOG062P �Autor  �Microsiga           � Data �  08/01/19   ���
�������������������������������������������������������������������������͹��
���Desc.     � Rotina para gravacao das amarracoes entre roteiros e aten- ���
���          � dentes                                                     ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ExcRotAt()                                   

    Local aArea    := GetArea()
    Local cMarca   := oMark:Mark()
    Local lInverte := oMark:IsInvert()
    Local nCt      := 0

	U_ADINF009P('ADLOG062P' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Markbrowse para amarracao de roteiro e atendente Sera utilizado no relatorio ROTLOG')
     
    If msgYesNo("Confirma a retirada dos atendentes e suas rotas?")
	    ZFN->( dbGoTop() )
	    Do While !ZFN->( EOF() )
	    	If oMark:IsMark(cMarca)
	    		nCt++
	    		RecLock('ZFN', .F.)
	    			ZFN->ZFN_OK := ""
	    			ZFN->ZFN_CODIGO := ""
	    		ZFN->(MsUnlock())
	    	EndIf
			         
	    	ZFN->(DbSkip())
	    EndDo
			     
	    MsgInfo('Foram retirados <b>' + cValToChar( nCt ) + ' roteiros dos atendentes selecionados.', "Aten��o")
    EndIf
		
Return