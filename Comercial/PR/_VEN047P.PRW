#INCLUDE "PROTHEUS.CH"  
#INCLUDE "AP5MAIL.CH"     
#INCLUDE "rwmake.ch"  
#INCLUDE "topconn.ch"
#INCLUDE 'FWMVCDEF.CH' 

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �_VEN047P  �Autor  �WILLIAM COSTA       � Data �  07/07/2017 ���
//�������������������������������������������������������������������������͹��
//���Desc.     �Pontos de Entrada referente ao fonte MVC ADVEN047P          ���
//���          �                                                            ���
//�������������������������������������������������������������������������͹��
//���Uso       � SIGAFAT                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������

USER FUNCTION _VEN047P()   

	LOCAL aParam     := PARAMIXB
	LOCAL xRet       := .T.
	LOCAL oObj       := ''
	LOCAL cIdPonto   := ''
	LOCAL cIdModel   := ''
	LOCAL lIsGrid    := .F.
	LOCAL nLinha     := 0
	LOCAL nQtdLinhas := 0
	LOCAL cMsg       := ''
	
	IF aParam <> NIL
	      
	       oObj       := aParam[1]
	       cIdPonto   := aParam[2]
	       cIdModel   := aParam[3]
	       lIsGrid    := (LEN(aParam) > 3) 
	        
	       IF cIdPonto == 'MODELPOS' // Na valida��o total do modelo. 
	       
           		u_GrLogZBE (Date(),;
	       		            TIME(),;
	       		            cUserName,;         
	       		            IIF(oObj:NOPERATION == 3, 'INCLUI'                           , ;
	       		            IIF(oObj:NOPERATION == 4, 'ALTERA'                           , ;
	       		            IIF(oObj:NOPERATION == 5, 'EXCLUI',' ')))                    + ;
	       		            " Cod Rede / Cod Cli: " + M->ZB7_REDE + "||" + M->ZB7_CODCLI + ;
	       		            " Dt Entrega De: "      + DTOC(ZB7->ZB7_DTENTR)              + ;
 	                        " Dt Entrega Para: "    + DTOC(M->ZB7_DTENTR)                + ;
 	                        " Ean De: "             + M->ZB7_CODDE                       + ;
 	                        " Ean Para: "           + M->ZB7_CODPAR                      , ;
	       		            "COMERCIAL"                                                  , ;
	       		            "ADVEN047P"                                                  , ;
	       		            "TELA DE/PARA PEDIDO EDI "                                   , ;
 	                        ComputerName()                                               , ;
 	                        LogUserName())
 	                        
				xRet := .T.    
					                        
	       ENDIF
	ENDIF       
      
RETURN(xRet)