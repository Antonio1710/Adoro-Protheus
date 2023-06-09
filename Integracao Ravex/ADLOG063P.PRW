#INCLUDE "PROTHEUS.CH"
#INCLUDE "APWEBSRV.CH"
#INCLUDE "TBICONN.CH"
#INCLUDE "TBICODE.CH"   
#INCLUDE "XMLXFUN.CH"  

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ADLOG063P �Autor  �WILLIAM COSTA       � Data �  09/10/2019 ���
�������������������������������������������������������������������������͹��
���Desc.     �Programa gera viagem planejada manual do ravex              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAFAT                                                    ���
�������������������������������������������������������������������������͹��
���ALTERACAO �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

USER FUNCTION ADLOG063P()

    Private cPerg      := 'ADLOG063P'
    Private aSays		:= {}
    Private aButtons	:= {}   
    Private cCadastro	:= "ADLOG063P - Gera Viagem Planejada Manual"

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Programa gera viagem planejada manual do ravex') 

    //+------------------------------------------------+
    //|Cria grupo de Perguntas                         |
    //+------------------------------------------------+
    //@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
    //MontaPerg()
    Pergunte(cPerg,.F.)
    
    //+-----------------------------------------------+
    //|Monta Form Batch - Interface com o Usuario     |
    //+-----------------------------------------------+
    AADD(aSays,"Este programa tem a finalidade de gerar manualmente " )
    AADD(aSays,"Viagem Planejada" )

    AADD(aButtons, { 5,.T.,{|o| Pergunte(cPerg,.T.) }})
    AADD(aButtons, { 1,.T.,{|o| o:oWnd:End(), Processa({||GERA_ADLOG063P()},"Gerando arquivo","Aguarde...")    }})
    AADD(aButtons, { 2,.T.,{|o| o:oWnd:End() }})

    FormBatch( cCadastro, aSays, aButtons )  

RETURN(NIL)

STATIC FUNCTION GERA_ADLOG063P()

    u_ADLOG017P()

RETURN(NIL)

//Static Function MontaPerg()
//    
//    U_xPutSX1(cPerg,"01",'Gerar de Todos ?','','',"mv_ch1","N",01,0,01,"C","","","","","MV_PAR01" ,"N�o","N�o","N�o","","Sim","Sim","Sim","","","","","","","",""," ")
//    
//	Pergunte(cPerg,.F.)
//	
//Return(Nil)     
