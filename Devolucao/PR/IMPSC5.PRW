#include "rwmake.ch"
User Function IMPSC5() 

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � IMPSC5   � Autor � Marcos Bido           � Data � 30/08/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Importa Roteiro e Sequencia do RS                          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
@history Ticket 85319  - Antonio Domingos - 10/01/2023 - Valida��o Fontes V33 - Dic. Banco de Dados.
@history Ticket 85319  - Antonio Domingos - 24/01/2023 - Valida��o Fontes V33 - Dic. Banco de Dados.
/*/


cPerg := "IMPSC5"
If !Pergunte(cPerg,.T.)
  Return()
EndIf


//���������������������������������������������������Ŀ
//� Declara variaveis                                 �
//�����������������������������������������������������

_cPath   := ALLTRIM(GETMV("MV_ROADSHO"))
_cArq    := alltrim(mv_par01)+".TXT"         // "ROTA.TXT / Arquivo texto a importar

If !MsgYesNo(OemToAnsi("Inicia a Importacao do Pedidos ? "))
	Return()
EndIf


//������������������������������������Ŀ
//� Guarda Area do Siga                �
//��������������������������������������
_cAli := Alias()
_nOrd := IndexOrd()
_nRec := Recno()

dbSelectArea("SC5")
dbSetorder(1)

dbSelectArea("SC6")
dbSetorder(1)

//���������������������������������������������������������������������Ŀ
//� Cria Arquivo Temporario para apendar arquivo temporario             �
//�����������������������������������������������������������������������

aStru := {} //Ticket 85319  - Antonio Domingos - 24/01/2023
/*AADD (aStru,{"LINHA"  , "C",60,0})
_cNomTrb := CriaTrab(aStru)
dbUseArea(.T.,,_cNomTrb,"TEMP",.F.,.F.)*/
oTemp := FWTemporaryTable():New("TEMP", aStru)
oTemp:Create()
	
dbSelectArea("TEMP")           // Inc RNUTTI 29/08/02
Append From &(_cPath+_cArq) SDF //ROTEIRO\PEDIDO.TXT SDF
dbGoTop()

Do While !eof()
	
	_Pedido := Substr(LINHA,13,6)
	_Roteiro:= Substr(LINHA,4,3)
	_Sequenc:= Substr(LINHA,30,2)
	
	dbSelectArea("SC5")
	dbSetOrder(1)        // Inc RNUTTI 29/08/02
	
	If dbSeek(xfilial("SC5") + _Pedido)
		
		RecLock("SC5",.F.)
		Replace C5_ROTEIRO With _Roteiro
		Replace C5_SEQUENC With StrZero(VAL(_Sequenc),2)
		MsUnlock()
		
		dbSelectArea("SC6")
                dbSetOrder(1)        // Inc RNUTTI 29/08/02
		
		If dbSeek( xFilial("SC6")+_Pedido )
			Do While !Eof() .and. SC6->C6_FILIAL == xFilial("SC6") .and. SC6->C6_NUM =_Pedido
				RecLock("SC6",.F.)
				Replace C6_ROTEIRO With _Roteiro
				Replace C6_Sequenc With StrZero(VAL(_Sequenc),2)  // Alt RNUTTI 29/08/2002
				MsUnlock()
				dbSkip()
			Enddo
		Endif


	Endif
	DbSelectArea("temp")
	dbSkip()
	
EndDo

MsgStop("Fim do Processamento")

Return
