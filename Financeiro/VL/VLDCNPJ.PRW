#include "rwmake.ch"  
#INCLUDE "protheus.ch"
#INCLUDE "topconn.ch"      

User Function VLDCNPJ() 

/*/                                                      
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
��� Programa � VLDCNPJ  � Autor � Alex Borges        � Data � 16/11/2011  ���
�������������������������������������������������������������������������͹��
���Descri��o � Valida�ao do campo A1_CNPJ                                 ���
�������������������������������������������������������������������������͹��
���Uso       � Espec�fico Ad'oro                                          ���
�������������������������������������������������������������������������͹��
���Altera��es� Descri��o                                                  ���
���Ch.052614 � 052614 || OS 053991 || INCUBATORIO || VALERIA ||           ���
���          � CAD. CLIENTES || ABEL BABINI || 18/10/2019                 ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

/* 
Alex Borges - 16/11/2011
Esta validacao estava no campo, devido o tamanho do campo no configurador, precisou criar este programa.
Iif(M->A1_EST!="EX",(Cgc(M->A1_CGC).And.(Existchav("SA1",M->A1_CGC,3).Or.Len(AllTrim(M->A1_CGC))<1)),.T.)       

*/

_lRetor := .T.

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Valida�ao do campo A1_CNPJ ')

 ALERT("GR "+M->A1_SATIV1+ " SUB "+ M->A1_SATIV2+" CGC "+M->A1_CGC)
 If (M->A1_EST!="EX")
		//052614 || OS 053991 || INCUBATORIO || VALERIA || CAD. CLIENTES || ABEL BABINI || 18/10/2019 || LIBERADO PARA PRODUTOR RURAL POIS PODEM POSSUIR MAIS DE UMA INSCRI��O ESTADUAL.
       //If (M->A1_SATIV1 = "50" .AND. M->A1_SATIV2 $ "51/52/53") //COZINHA INDUSTRIAL PODERIA INSERIR CNPJ DUPLICADO
       If ((M->A1_SATIV1 = "50" .AND. M->A1_SATIV2 $ "51/52/53")) .OR. ; //COZINHA INDUSTRIAL PODERIA INSERIR CNPJ DUPLICADO
       		M->A1_TIPO $ 'L' //LIBERADO PARA PRODUTOR RURAL POIS PODEM POSSUIR MAIS DE UMA INSCRI��O ESTADUAL.
       	_lRetor := A030CGC(M->A1_PESSOA, M->A1_CGC).OR.Cgc(M->A1_CGC).Or.Len(AllTrim(M->A1_CGC))<1
       Else
       	_lRetor := A030CGC(M->A1_PESSOA, M->A1_CGC).OR.Cgc(M->A1_CGC).And.(Existchav("SA1",M->A1_CGC,3).Or.Len(AllTrim(M->A1_CGC))<1)
       End If
 End If

Return(_lRetor)
