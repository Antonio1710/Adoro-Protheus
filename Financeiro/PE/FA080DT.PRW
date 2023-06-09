#include "rwmake.ch"   
#include "TOPCONN.CH"
#INCLUDE "PROTHEUS.CH"    

User Function FA080DT()
                         
Local _cRet := ""   


SetPrvt("_SALIAS,_SINDEX,_SRECNO,_NVALBX,_SNUMF1,_SNUMD1")
SetPrvt("_NPERC,_NVALRAT,_CFORNECE,_CNOMFOR,_SINDE2,_SNUME2, _aAreaE2")
SetPrvt("_NCONTFOR,CTELAENTR,_cMens,_lRET,_lPASE2,_cSql,_cCNPJ,_cCodSa1,_cNumTit,_lSe1,_cAutBx")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � FA080DT � Autor � Luciano Mafra       �Data � 05/02/2014   ���
�������������������������������������������������������������������������Ĵ��
���Descricao � PONTO DE ENTRADA Baixa de Titulos a Pagar                  ���
���          � Mensagem de data de Baixa divergente da Database do sistema���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Ad'oro Alimenticia                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
//����������������������������Ŀ
//� Grava ambiente inicial     �
//������������������������������

_sAlias := Alias()
_sIndex := IndexOrd()
_sRecno := Recno()
_aAreaE2 := GetArea("SE2")
_lRet := .T.
_lPASE2 := .F.
_lSe1 := .F.

//�������������������������������������������������Ŀ
//� Rotina de aviso de Adiantamento de Fornecedores �
//���������������������������������������������������
_cFornece := SE2->E2_FORNECE
_cNomFor  := SE2->E2_NOMFOR
_cAutBx   := ""  && SE2->E2_YAUTBX  Retirado por gerar error.log na baixa por falta do campo.
_cCNPJ :=  SubStr(Posicione("SA2",1,xFilial("SA2")+_cFornece,"A2_CGC"),1,8)  //Captura o CNPJ do fornecedor para procurar no SA1
_cCodSa1 := ""
_cNumTit := ""


If SE2->E2_TIPO = "PFA"
	dbSelectArea("SZ9")
	dbsetorder(1)
	If dbSeek( xFilial("SZ9")+SE2->E2_APAGTO)
		RecLock("SZ9",.F.)
		   SZ9->Z9_DTPGTO := DDATABASE
		   SZ9->Z9_STATUS := "3"
		Msunlock()
	Endif	
Endif   
DBAIXA := DDATABASE    //Alterado por Luciano em 28/11/14 - chamado 20945                                                                          
DDEBITO := M->DBAIXA   //

dbSelectArea(_sAlias)
dbSetOrder(_sIndex)
dbGoto(_sRecno)

Return _lRet
