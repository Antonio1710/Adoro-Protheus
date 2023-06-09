#INCLUDE "PROTHEUS.CH" 

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �ADEST004P �Autor  �William Costa       � Data �  01/02/2016 ���
//�������������������������������������������������������������������������͹��
//���Desc.     �Fonte utilizado a partir do gatilho CP_PRODUTO Seq 009      ���
//���          �este fonte verifica se o local padrao do produto e igual a  ���
//���          �69 se for faz uma pergunta para o usuario se deseja trocar  ���
//���          �o local da requisi��o de armazem conforme parametro.        ���
//�������������������������������������������������������������������������͹��
//���Uso       � SIGAEST                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
	
User Function ADEST004P(cProd,cArmazem)
    
	Local cLocal := cArmazem 
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Fonte utilizado a partir do gatilho CP_PRODUTO Seq 009')
	
	IF !(__cUserID $ GETMV("MV_#USUSLA"))
	   
		RETURN(cLocal)
	
	ENDIF
	
	// *** INICIO ALTERACAO REFERENTE A TABELA SBZ INDICADORES DE PRODUTOS CHAMADO 030317 - WILLIAM COSTA *** //
	
	IF !RetArqProd(cProd)
	
		cLocal:= POSICIONE("SBZ",1,xFilial("SBZ")+cProd,"BZ_LOCPAD")
	ELSE
	
		cLocal:= POSICIONE("SB1",1,xFilial("SB1")+cProd,"B1_LOCPAD")

	ENDIF
	
	// *** FINAL ALTERACAO REFERENTE A TABELA SBZ INDICADORES DE PRODUTOS CHAMADO 030317 - WILLIAM COSTA *** //
	
	IF cLocal <> cArmazem .AND. __cUserID $ GETMV("MV_#USUSLA")
    	
    	IF MSGYESNO("Ol�, " + UsrRetName(__cUserID) + " Deseja trocar o armaz�m para: " + cLocal)
    	
			cLocal := cLocal  
			
		ELSE
		
			cLocal := cArmazem  
			
		ENDIF
    ENDIF
    
Return(cLocal)