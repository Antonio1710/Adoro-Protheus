#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"  
#INCLUDE "AP5MAIL.CH"                                   

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �ADCON004P �Autor  �WILLIAM COSTA       � Data �  11/10/2016 ���
//�������������������������������������������������������������������������͹��
//���Desc.     �Programa de Gatilho para trazer o item contabil correto de  ���
//���          �acordo a filial                                             ���
//�������������������������������������������������������������������������͹��
//���Uso       � SIGACTB                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//@history ticket TI - Antonio Domingos - 19/05/2023 - Ajuste Nova Empresa
//@history ticket TI - Antonio Domingos - 23/05/2023 - Revis�o Ajuste Nova Empresa

USER FUNCTION ADCON004P()
	
	Private _cEmpFLB := SuperGetMv("MV_#EMPFLB",.F.,"0101/0102/1301") //Codigos de Empresas+Filiais Ativas Grupo B //ticket TI - Antonio Domingos - 20/05/2023
	Private cItemctb := ''
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	//ticket TI - Antonio Domingos - 19/05/2023 
	cItemctb := IIF(alltrim(cEmpAnt)+alltrim(cFilAnt)$_cEmpFLB,"121",IIF(CFILANT="03","114",IIF(CFILANT="06","122",IIF(CFILANT="07","123",IIF(CFILANT="08","115",IIF(CFILANT="09","116","112"))))))
	
RETURN(cItemctb)
