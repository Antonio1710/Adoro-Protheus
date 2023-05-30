#INCLUDE "rwmake.ch"
#include "Protheus.ch"
/*/
������������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �          � Autor � Everaldo Casaroli  � Data �  14/07/08   ���
�������������������������������������������������������������������������͹��
���Descri��o � Programa para alteracao do parametro MV_DATAFIS            ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Altera��o � Ch. 048912 - ABEL BABINI | DEJAIME | FISCAL | Cria Bloqueio���
���          � por data de emiss�o de documentos                          ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
User Function ADTFIS()
	Local aAreaAnt := GetArea() 
	  
	Static oDlg
	Static oRadMenu1
	Static nRadMenu1 := 1
	Static oSay1       

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Programa para alteracao do parametro MV_DATAFIS')   
	
	DEFINE MSDIALOG oDlg TITLE "Altera��o de Parametro" FROM 000, 000  TO 250, 300 COLORS 0, 16777215 PIXEL
	
	@ 036, 047 RADIO oRadMenu1 VAR nRadMenu1 ITEMS "Liberacao de Estoque","Data Fiscal","Data Emiss�o" SIZE 064, 016 OF oDlg COLOR 0, 16777215 PIXEL
	@ 018, 022 SAY oSay1 PROMPT "Escolha o parametro que deseja alterar:" SIZE 103, 008 OF oDlg COLORS 0, 16777215 PIXEL
	@ 088, 026 BUTTON "Confirmar" SIZE 034, 018 OF oDlg PIXEL ACTION ( nOpc := 1, oDlg:End()) OF oDlg PIXEL
	@ 087, 087 BUTTON "Cancelar"  SIZE 034, 018 OF oDlg PIXEL ACTION ( nOpc := 0, oDlg:End()) OF oDlg PIXEL
	ACTIVATE MSDIALOG oDlg CENTERED
	                   
	If nOpc == 1
		If nRadMenu1 == 1  
	       if ALLTRIM(__cUserID) $ GETMV("MV_#USULIB")   //usuario liberacao de estoque 	                                     
		      If GETMV("MV_ESTNEG") == "N"	
			     IF MsgBox("O parametro de Estoque Negativo esta bloqueado"+ CHR(13)+ CHR(13)+ "Deseja liberar o par�metro?"," Altera par�metro MV_ESTNEG ","YESNO")    	
		    		PutMv("MV_ESTNEG","S")
				 Endif
			  Else
				 IF MsgBox("O parametro de Estoque Negativo esta desbloqueado"+ CHR(13)+ CHR(13)+ "Deseja bloquear o par�metro?"," Altera par�metro MV_ESTNEG ","YESNO")    	
		    		PutMv("MV_ESTNEG","N")
				 Endif	
			  Endif	
		   ELSE
		      ALERT("Usuario sem permissao para alterar o parametro de Estoque Negativo")
		      return
		   ENDIF
		//Else     	// ABEL BABINI 06/05/2019 CHAMADO 048912 | FISCAL | DEJAIME | Impede a entrada de documentos com data de emiss�o anterior � permitida
		Elseif nRadMenu1 == 2       
	       if ALLTRIM(__cUserID) $ GETMV("MV_#USUDTF")   //usuario ALTERA DATA DE FECHAMENTO DO ESTOQUE.	                                     	
	          IF MsgBox("O per�odo atualmente esta fechado at� o dia: " + (DTOC(STOD(DTOS(GETMV("MV_DATAFIS")))))+"."+ CHR(13)+ CHR(13)+ "Deseja alterar o par�metro?"," Altera par�metro MV_DATAFIS ","YESNO")    		
			     IF(PERGUNTE("ADTFIS"))
					PutMv("MV_DATAFIS",	DTOS(MV_PAR01)) 
				 Endif
			  Endif	
		   else     
		      ALERT("Usuario sem permissao para alterar a data de fechamento de estoque")
		      return	   
		   endif
		// INICIO ABEL BABINI 06/05/2019 CHAMADO 048912 | FISCAL | DEJAIME | Impede a entrada de documentos com data de emiss�o anterior � permitida
		Elseif nRadMenu1 == 3
	       if ALLTRIM(__cUserID) $ GETMV("MV_#USUDTF")   //usuario ALTERA DATA DE FECHAMENTO DE DATA DE EMISS�O	                                     	
	          IF MsgBox("O per�odo atualmente esta fechado at� o dia: " + (DTOC(GETMV("MV_#DTEMIS")))+"."+ CHR(13)+ CHR(13)+ "Deseja alterar o par�metro?"," Altera par�metro MV_#DTEMIS ","YESNO")    		
			     IF(PERGUNTE("ADTFIS"))
					PutMv("MV_#DTEMIS",	DTOS(MV_PAR01)) 
				 Endif
			  Endif	
		   else     
		      ALERT("Usuario sem permissao para alterar a data de fechamento de estoque")
		      return	   
		   endif
		// FIM ABEL BABINI 06/05/2019 CHAMADO 048912 | FISCAL | DEJAIME | Impede a entrada de documentos com data de emiss�o anterior � permitida
		Endif
	Endif	
	
	RestArea(aAreaAnt)

Return 