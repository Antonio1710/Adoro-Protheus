#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"  
#INCLUDE "AP5MAIL.CH"                                   

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �ADCON005P �Autor  �WILLIAM COSTA       � Data �  17/10/2016 ���
//�������������������������������������������������������������������������͹��
//���Desc.     �Programa de ITEM CONTABIL PARA GUARDAR A FORMULA CORRETA    ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       � SIGACTB                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//@history ticket TI - Antonio Domingos - 19/05/2023 - Ajuste Nova Empresa
//@history ticket TI - Antonio Domingos - 23/05/2023 - Revis�o Ajuste Nova Empresa

USER FUNCTION ADCON005P()

	Private cItemctb := ''
	Private _cEmpFL1 := SuperGetMv("MV_#EMPFL1",.F.,"0102/1301") //Codigos de Empresas+Filiais Ativas Grupo 1 //ticket TI - Antonio Domingos - 19/05/2023
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	//cItemctb := IIF(AllTrim(SM0->M0_CODIGO) == "01"  .AND. AllTrim(SM0->M0_CODFIL) == "02", "121",IIF(AllTrim(SM0->M0_CODIGO) == "02","121",IIF(SEF->EF_FILIAL$"03/05","114",IIF(SEF->EF_FILIAL=="06","122",IIF(SEF->EF_FILIAL=="07","123",IIF(SEF->EF_FILIAL=="08","115",IIF(SEF->EF_FILIAL=="09","116",112))))))) // @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabiliza��o pos golive migra��o dicion�rio dados
	cItemctb := IIF(AllTrim(SM0->M0_CODIGO)+AllTrim(SM0->M0_CODFIL) $ _cEmpFL1, "121",IIF(AllTrim(SM0->M0_CODIGO) == "02","121",IIF(SEF->EF_FILIAL$"03/05","114",IIF(SEF->EF_FILIAL=="06","122",IIF(SEF->EF_FILIAL=="07","123",IIF(SEF->EF_FILIAL=="08","115",IIF(SEF->EF_FILIAL=="09","116",112))))))) // @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabiliza��o pos golive migra��o dicion�rio dados

RETURN(cItemctb)
