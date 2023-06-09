#Include "Protheus.ch"
#include 'Fileio.ch'
#Include 'Totvs.ch'
#Include 'Restful.ch'
#Include 'Topconn.ch'
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADVEN088P      �Autor  �Everson      � Data �  04/01/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Fun��o para envio de status dos pedidos de venda ao         ���
��           �ao SalesForce pelo departamento financeiro.                 ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADVEN088P() // U_ADVEN088P()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������
	Local aArea := GetArea()
	Local cPerg	:= "SFLIBFIN"
	Local cDtDe	:= ""
	Local cDtAt := ""
	Local cPlaca:= ""
	Local cPedDe:= ""
	Local cPedAt:= ""

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Fun��o para envio de status dos pedidos de venda ao SalesForce pelo departamento financeiro.')
	
	//
	//criaPerg(cPerg)

	//
	If ! Pergunte(cPerg,.T.)
		RestArea(aArea)
		Return Nil
		
	EndIf
	
	//
	cDtDe := DToS(mv_par01)
	cDtAt := DToS(mv_par02)
	cPlaca:= Alltrim(cValToChar(mv_par03))
	cPedDe:= Alltrim(cValToChar(mv_par04))
	cPedAt:= Alltrim(cValToChar(mv_par05))
	
	MsAguarde({|| procAprv(cDtDe,cDtAt,cPlaca,cPedDe,cPedAt) },"Aguarde","Processando pedidos aprovados...")
	
	MsAguarde({|| procBlq(cDtDe,cDtAt,cPedDe,cPedAt) },"Aguarde","Processando pedidos reprovados...")
	
	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �procAprv       �Autor  �Everson      � Data �  13/04/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa pedidos aprovados.                                 ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function procAprv(cDtDe,cDtAt,cPlaca,cPedDe,cPedAt)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aArea 	:= GetArea()
	Local cExpSql	:= ""
	
	//
	If cPlaca == "1"
		cExpSql += " AND C5_PLACA <> '' "
	
	EndIf
	
	//
	cExpSql += " AND C5_XPEDSAL <> '' "
	cExpSql += " AND C5_BLQ = '' "
	cExpSql += " AND C5_XGERSF = '2' "
	cExpSql += " AND C5_XSFSTAT <> '2' "
	//cExpSql += " AND C5_NUM = '9A56UW'  "
	cExpSql += " AND ( SC5.C5_FLAGFIN = 'B' OR SC5.D_E_L_E_T_ <> '') "
	cExpSql += " AND SC5.C5_DTENTR >= '" + cDtDe + "' "
	cExpSql += " AND SC5.C5_DTENTR <= '" + cDtAt + "' ""
	cExpSql += " AND C5_NUM BETWEEN '" + cValToChar(cPedDe) + "' AND '" + cValToChar(cPedAt) + "' "
	
	U_ADVEN050P("",.F.,.T.,cExpSql,.T.)
	
	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �procAprv       �Autor  �Everson      � Data �  13/04/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Processa pedidos reprovados.                                ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function procBlq(cDtDe,cDtAt,cPedDe,cPedAt)

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aArea 	:= GetArea()
	Local cExpSql	:= ""

	//
	cExpSql += " AND C5_XPEDSAL <> '' "
	cExpSql += " AND C5_BLQ = '' "
	cExpSql += " AND C5_XGERSF = '2' "
	//cExpSql += " AND C5_NOTA   = ''  "
	cExpSql += " AND ( SC5.C5_FLAGFIN = 'B' OR SC5.D_E_L_E_T_ <> '') "
	cExpSql += " AND SC5.C5_DTENTR >= '" + cDtDe + "' "
	cExpSql += " AND SC5.C5_DTENTR <= '" + cDtAt + "' "
	//cExpSql += " AND SC5.D_E_L_E_T_ = '' "
	cExpSql += " AND C5_NUM BETWEEN '" + cValToChar(cPedDe) + "' AND '" + cValToChar(cPedAt) + "' "
		
	U_ADVEN050P("",.F.,.T.,cExpSql,.F.)
	
	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �criaPerg       �Autor  �Everson      � Data �  13/04/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Cria pergunta.                                              ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 037261.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
/*Static Function criaPerg(cPerg)  

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������                                
	
    PutSX1(cPerg,"01","Data Emiss�o De " ,"Data Emiss�o De "  ,"Data Emiss�o De "  ,"mv_ch1","D",08,0,0,"G","" ,"","","","mv_par01" ,"","","","","","","","","","","","","","",""," ")
    PutSX1(cPerg,"02","Data Emiss�o Ate" ,"Data Emiss�o Ate"  ,"Data Emiss�o Ate"  ,"mv_ch2","D",08,0,0,"G","" ,"","","","mv_par02" ,"","","","","","","","","","","","","","",""," ")
	
Return Nil*/
