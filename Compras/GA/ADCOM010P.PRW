#Include "Protheus.ch"
#Include "TopConn.ch"

//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������
//�������������������������������������������������������������������������ͻ��
//���Programa  �ADCOM010P �Autor  �William Costa       � Data �19/09/2017   ���
//�������������������������������������������������������������������������͹��
//���Desc.     �Consulta Especifica para a Tabela SD1 com compra Ordem      ���
//���          �e Remessa Ordem                                             ���
//�������������������������������������������������������������������������͹��
//���Uso       � SIGACOM                                                    ���
//�������������������������������������������������������������������������ͼ��
//�����������������������������������������������������������������������������
//�����������������������������������������������������������������������������


/*BEGINDOC
//������������������������������������������������������������������������������������������������������������x�
//�Fun��o para consulta gen�rica                                                                              �
//�@author Daniel Atilio                                                                                      �
//�@since 15/12/2016                                                                                          �
//�@version 1.0                                                                                               �
//�    @param cConsSQLM, Caracter, Consulta SQL                                                               �
//�    @param cRetorM, Caracter, Campo que ser� retornado                                                     �
//�    @param cAgrupM, Caracter, Group By do SQL                                                              �
//�    @param cOrderM, Caracter, Order By do SQL                                                              �
//�    @return lRetorn, retorno se a consulta foi confirmada ou n�o                                           �
//�    @example                                                                                               �
//�    lOK := u_zConsSQL("SELECT B1_COD, B1_DESC FROM SB1010 WHERE D_E_L_E_T_ = ' ' ", "B1_COD", "", "B1_COD")�
//�    ...                                                                                                    �
//�    u_zConsSQL("SELECT * FROM ZA0990", "ZA0_COD", "", "")                                                  �
//�    ...                                                                                                    �
//�    @obs O retorno da consulta � p�blica (__cRetorno) para ser usada em consultas espec�ficas              �
//�    A consulta n�o pode ter ORDER BY, pois ele j� � especificado em um par�metro                           �
//������������������������������������������������������������������������������������������������������������x�
ENDDOC*/

//Constantes
#Define STR_PULA        Chr(13)+ Chr(10)

User Function ADCOM010P()   

	Local cTexto := ''
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	cTexto := u_ConsultEspecif("SELECT D1_FILIAL,D1_DOC,D1_SERIE,D1_ITEM,D1_FORNECE,D1_LOJA,D1_COD FROM SD1010 WHERE D_E_L_E_T_<>'*' AND D1_EMISSAO>=CONVERT(VARCHAR(8),(GETDATE()-60),112) AND D1_CF IN('2118','1118')", "D1_FILIAL,D1_DOC,D1_SERIE,D1_ITEM,D1_FORNECE,D1_LOJA","","D1_DOC")                                   

RETURN(cTexto)

    