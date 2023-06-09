#INCLUDE "TOPCONN.CH"
#INCLUDE "RWMAKE.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �FA390TOK() � Autor � HCCONSYS          � Data �  12/02/09   ���
�������������������������������������������������������������������������͹��
���Descricao � Ponto de Entrada utilizado na Geracao de Cheque S/Titulo   ���
���          � Nao permite que sejam utilizados cheques de mesmo numero   ���
���          � para mesma banco/agencia/conta independ. da Filial   		  ���
�������������������������������������������������������������������������͹��
���Uso       � MP8		                                                  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function FA390TOK()

Local aArea		:= GetArea()
Local lRet		:= .T.       
Local cQuery	:= ""
Local nRegs		:= 0     

//--------------------------------------
// Se op��o for Redep�sito de Cheques   
// n�o executa valida��o abaixo 
//--------------------------------------
if paramIxb:CTITLE == "Redepositar Cheque"
   return(lRet) 
endif 


&& Verificar se ja existe cheque com numero informado, nao importando a Filial.
cQuery := "SELECT EF_BANCO,EF_AGENCIA,EF_CONTA,EF_NUM,EF_FILIAL "
cQuery += "FROM " + RETSQLNAME("SEF") + "  "
cQuery += "WHERE D_E_L_E_T_ = ' ' "
cQuery += "AND EF_BANCO 	= '" + cBanco390 		+ "'  "
cQuery += "AND EF_AGENCIA 	= '" + cAgencia390 	+ "'  "
cQuery += "AND EF_CONTA 	= '" + cConta390 		+ "'  "
cQuery += "AND EF_NUM 		= '" + cCheque390		+ "'  "

TcQuery cQuery New Alias "TSEF"

Count to nRegs

TSEF->(dbGoTop())

If nRegs > 0 
	
	MsgInfo("Numero de cheque ja informado para a Filial " + TSEF->EF_FILIAL + ". Verifique!" )
	lRet	:= .F. 	
Endif

TSEF->(dbCloseArea())      

RestArea(aArea)

Return(lRet)
            

/*
CBANCO390
CAGENCIA39
CCONTA390
CCHEQUE390
DVENCINI
DVENCFIM
NLIMIT190
CFORN390
CBENEF390
CNATUR390
CHIST390
*/