#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"  
#INCLUDE "AP5MAIL.CH"                                   

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �ADLOG028P �Autor  �WILLIAM COSTA       � Data �  20/06/2016 ���
//�������������������������������������������������������������������������͹��
//���Desc.     �Programa de Modo Edicao para o campo ZBB_PLACA nele e verifi���
//���          �cado se a placa e generica ou nao tabela ZBF ai libera o cam���
//���          �po para edicao                                              ���
//�������������������������������������������������������������������������͹��
//���Uso       � SIGAFAT                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

USER FUNCTION ADLOG028P()

	Private lRet := .F.
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Programa de Modo Edicao para o campo ZBB_PLACA nele e verificado se a placa e generica ou nao tabela ZBF ai libera o campo para edicao')
	
	DbSelectArea("ZBF")
    dbSetOrder(2) 
    IF DbSeek(xFilial("ZBF") + M->ZBB_PLACA,.T.) // Busca exata
    
    	lRet := .T.
        
	ENDIF 
	ZBF->(dbCloseArea())

RETURN(lRet)