#Include 'Protheus.ch'
#Include 'FwMvcDef.ch'
#Include 'Parmtype.ch'
#Include 'Topconn.ch'

//Vari�veis Est�ticas.
Static cTitulo := 'Cadastro Regra Data de Entrega'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADVEN071P   � Autor � Everson          � Data �  19/12/17   ���
�������������������������������������������������������������������������͹��
���Descricao �Cadastro regra de data de entrega.                          ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037426.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADVEN071P() // U_ADVEN071P()
		
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������	
	Local aArea	   := GetArea()
	Local oTelDias
	Local oGroup1
	Local oOk
	Local oFechar
	
	Private oDom
	Private oSeg
	Private oTer
	Private oQua
	Private oQui
	Private oSex
	Private oSab
	
	Private nDom := 0
	Private nSeg := 0
	Private nTer := 0
	Private nQua := 0
	Private nQui := 0
	Private nSex := 0
	Private nSab := 0
	
	//
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro regra de data de entrega.')
	
	//
	oTelDias			:= MsDialog():Create()
	oTelDias:cName     := "oTelDias"
	oTelDias:cCaption  := "Dias da Semana x Entrega"
	oTelDias:nLeft     := 34
	oTelDias:nTop      := 222
	oTelDias:nWidth    := 250
	oTelDias:nHeight   := 345
	oTelDias:lShowHint := .F.
	oTelDias:lCentered := .T.
		
		//
		TSay():New(005,005,{||'Domingo'}      ,oTelDias,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,10)
		TSay():New(020,005,{||'Segunda-feira'},oTelDias,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,10) 
		TSay():New(035,005,{||'Ter�a-feira'}  ,oTelDias,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,10) 
		TSay():New(050,005,{||'Quarta-feira'} ,oTelDias,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,10) 
		TSay():New(065,005,{||'Quinta-feira'} ,oTelDias,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,10) 
		TSay():New(080,005,{||'Sexta-feira'}  ,oTelDias,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,10) 
		TSay():New(095,005,{||'S�bado'}       ,oTelDias,,,,,,.T.,CLR_BLACK,CLR_WHITE,070,10)  
		
		//
		oDom   := TGet():New(005,075,{|u|If(PCount() == 0,nDom,nDom := u)},oTelDias,020,010,"@E 999",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nDom",,,,.T.,,,"",2) 
		oSeg   := TGet():New(020,075,{|u|If(PCount() == 0,nSeg,nSeg := u)},oTelDias,020,010,"@E 999",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nSeg",,,,.T.,,,"",2) 
		oTer   := TGet():New(035,075,{|u|If(PCount() == 0,nTer,nTer := u)},oTelDias,020,010,"@E 999",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nTer",,,,.T.,,,"",2) 
		oQua   := TGet():New(050,075,{|u|If(PCount() == 0,nQua,nQua := u)},oTelDias,020,010,"@E 999",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nQua",,,,.T.,,,"",2) 
		oQui   := TGet():New(065,075,{|u|If(PCount() == 0,nQui,nQui := u)},oTelDias,020,010,"@E 999",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nQui",,,,.T.,,,"",2) 
		oSex   := TGet():New(080,075,{|u|If(PCount() == 0,nSex,nSex := u)},oTelDias,020,010,"@E 999",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nSex",,,,.T.,,,"",2) 
		oSab   := TGet():New(095,075,{|u|If(PCount() == 0,nSab,nSab := u)},oTelDias,020,010,"@E 999",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"nSab",,,,.T.,,,"",2) 
		
		
		//
		oGroup1  := TGroup():Create(oTelDias,131,005,151,120,"",,,.T.)
			oOk     := TButton():New(136,010,"Ok"      ,oTelDias,{|| oTelDias:End(), MsAguarde({|| salvar() },"Aguarde","Atualizando par�metro...") },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
			oFechar := TButton():New(136,075,"Cancelar",oTelDias,{|| oTelDias:End() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
		
	oTelDias:Activate(,,,.T.,{||.T.},,{|| MsAguarde({|| carrParam() },"Aguarde","Carregando par�metro...") })

	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �carrParam      � Autor � Everson       � Data �  19/12/17   ���
�������������������������������������������������������������������������͹��
���Descricao �Carrega par�metro.                                          ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037426.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function carrParam()
		
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������	
	Local aArea := GetArea()
	Local cDias := Alltrim(cValToChar(GetMv("MV_#DIASEN")))
	Local aDias := {}
	
	//
	If Empty(cDias)
		RestArea(aArea)
		Return Nil
		
	EndIf
	
	//
	aDias := StrToKarr(cDias,"/")
	
	//
	nDom := aDias[1]
	nSeg := aDias[2]
	nTer := aDias[3]
	nQua := aDias[4]
	nQui := aDias[5]
	nSex := aDias[6]
	nSab := aDias[7]
	
	//
	oDom:Refresh()
	oSeg:Refresh()
	oTer:Refresh()
	oQua:Refresh()
	oQui:Refresh()
	oSex:Refresh()
	oSab:Refresh()
	
	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �salvar      � Autor � Everson          � Data �  19/12/17   ���
�������������������������������������������������������������������������͹��
���Descricao �Salva par�metro.                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037426.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function salvar()
		
	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������	
	Local aArea	:= GetArea()
	Local cDias	:= ""
	
	//
	cDias += cValToChar(nDom) + "/"
	cDias += cValToChar(nSeg) + "/"
	cDias += cValToChar(nTer) + "/"
	cDias += cValToChar(nQua) + "/"
	cDias += cValToChar(nQui) + "/"
	cDias += cValToChar(nSex) + "/"
	cDias += cValToChar(nSab)
	
	//
	PutMv("MV_#DIASEN",cDias)
	
	//
	MsgInfo("Par�metro salvo.","Fun��o salvar")
	
	//
	RestArea(aArea)
	
Return Nil
