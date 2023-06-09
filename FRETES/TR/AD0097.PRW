#include "rwmake.ch"

User Function AD0097()

SetPrvt("_CALIAS,_NINDEX,_NRECNO")

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Rotina de Fechamento Mensal dos Desc/Acresc.')

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � AD0097   � Autor � Gustavo Gonela        � Data � 21/01/04 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Rotina de Fechamento Mensal dos Desc/Acresc.               ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � AD0097 , Sub-Funcao de AD0063                              ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Logistica                                                  ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

//��������������������������������������������������������������������������Ŀ
//� Guarda ambiente inicial                                                  �
//����������������������������������������������������������������������������
_cAlias := Alias()
_nIndex := IndexOrd()
_nRecno := Recno()

//��������������������������������������������������������������������������Ŀ
//� Iniciando Variaveis                                                      �
//����������������������������������������������������������������������������

_dData   := dDatabase
_dData2  := dDatabase
_dDataF  := dDatabase

@ 00,000 TO 300,350 DIALOG oDlg1 TITLE "FECHAMENTO MENSAL DOS DESCONTOS E ACRESCIMOS"
nLin := 30
@ nLin,030 SAY "Periodo de      : "
@ nLin,090 GET  _dData SIZE 40,70
nLin := nLin + 15
@ nLin,030 SAY "Periodo ate     : "
@ nLin,090 GET _dData2 SIZE 40,70
nLin := nLin + 15
@ nLin,030 SAY "Data Fechamento : "
@ nLin,090 GET _dDataF SIZE 40,70
nLin := nLin + 25

@ nLin,040 BMPBUTTON TYPE 01 ACTION GravaFech()
@ nLin,094 BMPBUTTON TYPE 02 ACTION Close(oDlg1)

ACTIVATE DIALOG oDlg1 CENTER


//��������������������������������������������������������������������������Ŀ
//� Restaura ambiente inicial                                                �
//����������������������������������������������������������������������������
dbSelectArea(_cAlias)
dbSetOrder(_nIndex)
dbGoto(_nRecno)

Return


/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� GravaFech    � Gravacao da Informa�oes                                 ���
���              �                                                         ���
��������������������������������������������������������������������������Ĵ��
��� Gustavo      | 21/01/04 � Funcao de Gravacao                           ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function GravaFech()

dbSelectArea("SZI") // Lancamentos de Descontos e Acrescimos
dbSetOrder(1) // data + placa
dbSeek(xFilial("SZI")+DTOS(_dData),.T.)
Do While !EOF() .and. DTOS(ZI_DATALAN) >= DTOS(_dData) .and. DTOS(ZI_DATALAN) <= DTOS(_dData2) 
	RecLock("SZI",.F.)
	Replace ZI_DTFECH  With _dDataF
	MsUnlock()
	
	DbSkip()
Enddo

Close(Odlg1)
Return(.T.)
                
