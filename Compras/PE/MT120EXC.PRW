#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"  
#INCLUDE "AP5MAIL.CH"   
#INCLUDE "topconn.ch"
                                

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �MT120EXC  �Autor  �WILLIAM COSTA       � Data �  04/11/2016 ���
//�������������������������������������������������������������������������͹��
//���Desc.     �O ponto se encontra no final do evento 3 da MaAvalPc        ���
//���          �(Exclus�o do PC) antes dos eventos de contabiliza��o        ���
//�������������������������������������������������������������������������͹��
//���Uso       � SIGACOM                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

USER FUNCTION MT120EXC()
    
Local cQuery 	 := ""
Local cNumPedido := SC7->C7_NUM

	DBSELECTAREA("SCR")
	DBGOTOP()
	DBSETORDER(3)
	
		IF DBSEEK(xFilial("SC7")+SC7->C7_NUM)
	
			Reclock("SCR",.F.)
				dbDelete()
			MsUnlock()  
		ENDIF
			
	DBCLOSEAREA("SCR")   
	
	
	//fernando sigoli 09/10/2017 -  chamado:034249
	cQuery := "SELECT C7_FILIAL, C7_NUM, C7_XPCORIG  FROM "+RetSqlName('SC7')+" WHERE  C7_FILIAL = '"+xFilial("SC7")+"' AND C7_XPCORIG LIKE '%"+SC7->C7_NUM+"%' AND D_E_L_E_T_ = ''  GROUP BY C7_FILIAL, C7_NUM, C7_XPCORIG"
	 
	If Select( "QRYSC7" ) > 0
		DbSelectArea( "QRYSC7" )
		QRYSC7->(DbCloseArea())
	EndIf
	
	TCQUERY cQuery NEW ALIAS "QRYSC7"

	DbSelectArea("QRYSC7")
	Dbgotop()
	While !EOF()
	
		DbSelectArea("SC7")
		SC7->(dbSetOrder(1)) 
		If DbSeek(xFilial("SC7") + Alltrim(QRYSC7->C7_NUM))
			While SC7->(!EOF()) .and. SC7->C7_FILIAL == xFilial("SC7") .and. SC7->C7_NUM == Alltrim(QRYSC7->C7_NUM)
			
				nSUBISTITUIR  := AT(cNumPedido,SC7->C7_XPCORIG)
				
				If nSUBISTITUIR > 0
				
					IF nSUBISTITUIR == 1
	         			cPedNew  := Substr(SC7->C7_XPCORIG,nSUBISTITUIR + 7,Len(SC7->C7_XPCORIG))
	      			Else   
	         			cPedNew  := Substr(SC7->C7_XPCORIG,1,nSUBISTITUIR - 2)+Substr(SC7->C7_XPCORIG,nSUBISTITUIR + 6,Len(SC7->C7_XPCORIG))
	      			Endif   
				
					RecLock("SC7",.F.)
						SC7->C7_XPCORIG	:= cPedNew
					MsunLock()
				
				EndIf
				  
			SC7->(DbSkip())	
			EndDo
	  	EndIf	
	 	
	DbSelectArea("QRYSC7")
	DbSkip()
	EndDO     
	
	QRYSC7->(DbCloseArea())
	
	
RETURN(NIL)                                