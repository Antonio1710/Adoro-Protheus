/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �DescTpPrj �Autor  �Fernando Macieira   � Data �  02/13/18   ���
�������������������������������������������������������������������������͹��
���Desc.     � Funcao utilizada no X3_RELACAO do campo AF8_DESCRI         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                      ���
���versionamento:														  ���
���Everson - 25/01/2018, chamado 046699. Tratamento para obter o valor da ���
���do c�digo do projeto.  	    										  ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function ADPMS004P() 

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������
	Local cDescTpPrj := ""
	Local aAreaSX5   := SX5->( GetArea() )
	Local cChavePrj  := Subs(AllTrim(cValToChar(U_PMANvPrj())),5,2) // Subs(AllTrim(cNewCod),5,2) - Everson - 25/01/2018, chamado 046699. 

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Funcao utilizada no X3_RELACAO do campo AF8_DESCRI')
	
	SX5->( dbSetOrder(1) ) // X5_FILIAL + X5_TABELA + X5_CHAVE
	If SX5->( dbSeek(xFilial("SX5")+"_M"+cChavePrj) )
		cDescTpPrj := "[" + AllTrim(SX5->X5_DESCRI) + "]"
	EndIf
	
	RestArea( aAreaSX5 )

Return cDescTpPrj