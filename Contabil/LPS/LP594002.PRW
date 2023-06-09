#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP594002  �Autor  �William Costa       � Data �  11/09/2015 ���
�������������������������������������������������������������������������͹��
���Desc.     � Este LP retorna dados para o LP 594002                     ���
���          � enviando o item credito para este lancamento padrao        ���
�������������������������������������������������������������������������͹��
���Uso       � Chamada no LP 594002                                       ���
�������������������������������������������������������������������������͹��
���Atualiz.  �                                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LP594002()

	Local _aArea   	:= GetArea()
	Local cITemCred := ''   
	Local cIDENTEE  := ''
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	cIDENTEE := SE5->E5_IDENTEE
	
	SqlTitPag(cIDENTEE)
	   
	While LP594002->(!EOF())
	    				
	 	cITemCred := LP594002->E2_ITEMC 
			       	
	    LP594002->(dbSkip())
	ENDDO
	LP594002->(dbCloseArea()) 
		
	RestArea(_aArea)
	
Return(cITemCred)      

Static Function SqlTitPag(cIDENTEE)

	BeginSQL Alias "LP594002"
			%NoPARSER%   
			SELECT SE2.E2_ITEMC 
			  FROM %Table:SE2% SE2 WITH(NOLOCK)
			 WHERE SE2.E2_IDENTEE = %EXP:cIDENTEE%
	EndSQl             
RETURN(NIL) 