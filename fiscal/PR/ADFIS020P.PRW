#Include "Protheus.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADFIS020P         � Autor � Everson   � Data �  10/10/2017  ���
�������������������������������������������������������������������������͹��
���Descricao �Valida��o de usu�rio para preencher o campo Tipo Frete em.  ���
��           �documentos de entrada.                                      ���
�������������������������������������������������������������������������͹��
���Uso       �Chamado 033275.                                             ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function ADFIS020P() // U_ADFIS020P()

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�vies.
	//�����������������������������������������������������������������������	
	Local aArea	:= GetArea()
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Valida��o de usu�rio para preencher o campo Tipo Frete em documentos de entrada.')
	
	If IsInCallStack("MATA103")
	
		If Type("aNFeDANFE") == "A" .And. Alltrim(cValToChar(CESPECIE)) == "CTE"
		
			aNFeDANFE[18] := "N - Normal"
		
		ElseIf Type("aNFeDANFE") == "A" .And. Alltrim(cValToChar(CESPECIE)) <> "CTE"
		
			aNFeDANFE[18] := ""
			
		EndIf
	
	EndIf
	
	//
	RestArea(aArea)

Return .T.