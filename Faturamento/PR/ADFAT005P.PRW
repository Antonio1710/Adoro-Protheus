#include "rwmake.ch"
#include "protheus.ch"
#include "topconn.ch"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ADFAT005P � Autor � Adriana Oliveira     � Data � 14.06.17 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Chamada rotina padrao MATA500 com restricao por usuario    ���
���          � conforme parametro MV_#MTA500                              ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Adoro - Chamada para Rotina Eliminacao de residuo          ���
�������������������������������������������������������������������������Ĵ��
���Alterado  � Data   � Motivo                                            ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/                   

User Function ADFAT005P()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Chamada rotina padrao MATA500 com restricao por usuario conforme parametro MV_#MTA500')

_cUsuarios 	:= GETMV("MV_#MTA500") //formato XXXXXXFF;XXXXXXFF; onde XXXXXX codigo do usuario, FF codigo da filial
_emp_fil	:= ""
if Alltrim(__CUSERID) $ _cUsuarios 
	_emp_fil := Substr(_cUsuarios,At(Alltrim(__CUSERID),_cUsuarios)+6,2)
endif

if Alltrim(cfilant) = _emp_fil
	MATA500() //Chama rotina padr�o 
else
	MsgBox("Rotina n�o Permitida para filial "+_emp_fil+" !!! ")
endif	

return Nil