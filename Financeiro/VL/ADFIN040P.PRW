#INCLUDE "PROTHEUS.CH"  

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �ADFIN040P �Autor  �WILLIAM COSTA       � Data �  05/07/2017 ���
//�������������������������������������������������������������������������͹��
//���Desc.     �Validacao de Campos para retirar acentos para parar de trav ���
//���          �ar a nota fiscal no momento da transmissao                  ���
//�������������������������������������������������������������������������͹��
//���Uso       � SIGAFIN                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

USER FUNCTION ADFIN040R() 

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Validacao de Campos para retirar acentos para parar de travar a nota fiscal no momento da transmissao')

	IF VALTYPE(M->PB3_EMAIL) == 'C' .AND. !EMPTY(M->PB3_EMAIL)
	
		M->PB3_EMAIL := NOACENTO2(M->PB3_EMAIL)
		
	ENDIF
 

RETURN(NIL) 


STATIC FUNCTION NoAcento2(cString)
	Local cChar  := ""
	Local nX     := 0 
	Local nY     := 0
	Local cVogal := "aeiouAEIOU"
	Local cAgudo := "�����"+"�����"
	Local cCircu := "�����"+"�����"
	Local cTrema := "�����"+"�����"
	Local cCrase := "�����"+"�����" 
	Local cTio   := "����"
	Local cCecid := "��"
	Local cMaior := "&lt;"
	Local cMenor := "&gt;"
	
	For nX:= 1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		IF cChar$cAgudo+cCircu+cTrema+cCecid+cTio+cCrase
			nY:= At(cChar,cAgudo)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCircu)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cTrema)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf
			nY:= At(cChar,cCrase)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr(cVogal,nY,1))
			EndIf		
			nY:= At(cChar,cTio)
			If nY > 0          
				cString := StrTran(cString,cChar,SubStr("aoAO",nY,1))
			EndIf		
			nY:= At(cChar,cCecid)
			If nY > 0
				cString := StrTran(cString,cChar,SubStr("cC",nY,1))
			EndIf
		Endif
	Next
	
	If cMaior$ cString 
		cString := strTran( cString, cMaior, "" ) 
	EndIf
	If cMenor$ cString 
		cString := strTran( cString, cMenor, "" )
	EndIf
	
	cString := StrTran( cString, CRLF, " " )
	
	For nX:=1 To Len(cString)
		cChar:=SubStr(cString, nX, 1)
		If (Asc(cChar) < 32 .Or. Asc(cChar) > 123) .and. !cChar $ '|' 
			cString:=StrTran(cString,cChar,".")
		Endif
	Next nX
	//Especifico Adoro devido a erro XML n�o solucionado versao 3.10
	cString := StrTran(cString,"&","e")
Return cString   	  