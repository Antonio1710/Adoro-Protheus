#INCLUDE "protheus.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ADGPE034 � Autor � Adriana Oliveira      � Data � 10/07/18 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Validacao do inicio do calculo de rescisao                 ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico para Adoro                                      ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             ���
�������������������������������������������������������������������������Ĵ��
���Programador � Data   �  OS  �  Motivo da Alteracao                     ���
�������������������������������������������������������������������������Ĵ��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������*/
User Function ADGPE034()
// User Function GPM040CO
// O ponto de entrada n�o esta mais funcionando na versao 12, ent�o o fonte est� sendo chamado por valida��o de campo RG_DATAHOM  

Local _aArea := GETAREA()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Validacao do inicio do calculo de rescisao')

// Alteradas condicoes abaixo para atender chamado 040695 por Adriana em 10/07/2018

If SRA->RA_SINDICA = "04"  
   If (dDataDem1 - SRA->RA_NASC)/365.25  >= 45            
	   Aviso("ATENCAO","SIND.EMP.VEND.VIAJ.DO COM.SP e Funcionario nascido em " + Dtoc(SRA->RA_NASC) + " com mais de 45 anos!!! Valide a continua��o do processo...",{"Ok"})
   Endif
else     
	if cFilAnt $ "01*02"
   		If (dDataDem1 - SRA->RA_NASC)/365.25  >= 50            
	   		Aviso("ATENCAO","Funcionario nascido em " + Dtoc(SRA->RA_NASC) + " e com mais de 50 anos!!! Valide a continua��o do processo...",{"Ok"})
   		Endif     
	ElseIf cFilAnt $ "03*04"
   		If (dDataDem1 - SRA->RA_NASC)/365.25  >= 45            
	   		Aviso("ATENCAO","Funcionario nascido em " + Dtoc(SRA->RA_NASC) + " e com mais de 45 anos!!! Valide a continua��o do processo...",{"Ok"})
	   	Endif
   	Endif     
Endif   

RESTAREA(_aArea) //Retorna o ambiente inicial

Return( .T. ) 