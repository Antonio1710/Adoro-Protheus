#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADEST010P � Autor � WILLIAM COSTA      � Data �  08/07/2016 ���
�������������������������������������������������������������������������͹��
���Descricao � Cadastro de Regras de  Transfer�ncias ZBA010               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � SIGAEST                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function ADEST010P()
     
	Local 	aCores    := { { "ZBA_STATUS == '1'" , 'BR_VERDE'    } ,; // Ativo
	                       { "ZBA_STATUS == '2'" , 'BR_VERMELHO' }}   // Inativo
	Private cCadastro := "Cadastro de Regras de Transfer�ncia"
	Private aRotina   := { {"Pesquisar" ,"AxPesqui",0,1} ,;
	                       {"Visualizar","AxVisual",0,2} ,;
	        		       {"Incluir"   ,"AxInclui",0,3} ,;
			               {"Alterar"   ,"AxAltera",0,4} ,;
			               {"Excluir"   ,"AxDeleta",0,5} }
	
	Private cDelFunc  := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock
	Private cString   := "ZBA"
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Cadastro de Regras de  Transfer�ncias ZBA010')
	
	mBrowse( 6,1,22,75,"ZBA",,,,,2,aCores)


Return(NIL)