#Include "RwMake.ch"
#Include 'Protheus.ch'
#Include 'FWMVCDef.ch'
#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} User Function ADVEN092P
	Rotina para alterar determinados campos no pedido de venda.
	@type  Function
	@author Ricardo Lima 
	@since 09/05/2018
	@version 01
	@history Everson, 30/08/2022, Ticket 79123 - Alterada condi��o do if
/*/
User Function ADVEN092P()

	Local aArea	   	:= GetArea()
	Local oTelMenu	:= Nil
	Local oDeP		:= Nil
	Local oAtP		:= Nil
	Local oDev		:= Nil
	Local oAtV		:= Nil
	Local oCanc  	:= Nil
	Local oOk		:= Nil
	Local cDeC      := SC5->C5_CONDPAG
	Local cAteC     := SC5->C5_CONDPAG
	Local cDeT      := Space(3)
	Local cAteT     := Space(3)
	Local cUserPer  := SuperGetMv( "MV_#ADVE92" , .F. , "" ,  )

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Rotina para alterar determinados campos no pedido de venda')
	
	IF !__cUserID $ cUserPer
		ApMsgInfo('Usuario sem Permiss�o para Alterar a Condi��o de Pagamento!','Altera Condi��o Pagamento do Pedido') 
		Return Nil
	EndIf

	IF ( EMPTY(SC5->C5_PLACA) .And. EMPTY(SC5->C5_NOTA) ) //Everson - 30/08/2022. Ticket 79123.
	
		oTelMenu		   := MsDialog():Create()
		oTelMenu:cName     := "oTelMenu"
		oTelMenu:cCaption  := "Altera Condi��o Pagamento do Pedido"
		oTelMenu:nLeft     := 34
		oTelMenu:nTop      := 222
		oTelMenu:nWidth    := 250
		oTelMenu:nHeight   := 320
		oTelMenu:lShowHint := .F.
		oTelMenu:lCentered := .T.

		oDeP:= TGet():New(010,010,{|u|If(PCount() == 0,cDeC,cDeC := u)}  ,oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.T.,.F. ,'SE4',"cDeC",,,,.T.,,,"Da Condi��o Pag.:",1)		
		oAtP:= TGet():New(010,065,{|u|If(PCount() == 0,cAteC,cAteC := u)},oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,'SE4',"cAteC",,,,.T.,,,"Para Condi��o Pag:",1)		
				
		oOk     := TButton():New(126,010,"Confirma",oTelMenu,{|| ADVE092C(cDec,cAteC,cDeT,cAteT), oTelMenu:End() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
		oCanc   := TButton():New(126,075,"Cancelar",oTelMenu,{|| oTelMenu:End() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )	
		
		oTelMenu:Activate(,,,.T.,{||.T.},,{||  })
	
	ELSE
		ApMsgInfo('Pedido com Placa Informada ou J� Faturado n�o pode ser alterado!','Altera Condi��o Pagamento do Pedido') 
	EndIf
	
	
	RestArea(aArea)
		
Return Nil

// ##############################################################################################################
// Projeto: Projeto WorkFlow
// Modulo : SIGAFAT
// Fonte  : ADVE092C
// ---------+-------------------+-----------------------------------------------------------------+---------------
// Data     | Autor             | Descricao                                                       | Chamado
// ---------+-------------------+-----------------------------------------------------------------+---------------
// 09/05/18 | Ricardo Lima      | Rotina para alterar determinados campos no pedido de venda      |
// ---------+-------------------+-----------------------------------------------------------------+---------------
// ###############################################################################################################
Static Function ADVE092C(cDec,cAteC,cDeT,cAteT)

	If  RecLock("SC5",.F.)
			SC5->C5_CONDPAG := cAteC
		MsUnlock()
        u_GrLogZBE( Date(),TIME(),cUserName,"ALTERACAO PEDIDO DE VENDA - C5_CONDPAG","COMERCIAL","ADVEN092P","PEDIDO: "+SC5->C5_NUM,ComputerName(),LogUserName() )
	EndIf

Return Nil
