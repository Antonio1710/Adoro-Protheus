#include "rwmake.ch"

User Function Ativo()
                     
U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Valida se o vendedor pode incluir pedido para o cliente Escolhido')

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  �ATIVO     � Autor � DANIEL             � Data �  01/02/07   ���
�������������������������������������������������������������������������Ĵ��
���Desc.     �Valida se o vendedor pode incluir pedido para o cliente     ���
���          �Escolhido                                                   ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Comercial                                                  ���
�������������������������������������������������������������������������Ĵ��
���         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.          	  ���
�������������������������������������������������������������������������Ĵ��
���Programador� Data   � BOPS �  Motivo da Alteracao                  	  ���
�������������������������������������������������������������������������Ĵ��
���           �        �      �                                           ���
���           �        �      �                                           ���
���           �        �      �                                           ���
���           �        �      �                                           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������  
@history ticket TI - Antonio Domingos - 17/05/2023 - Ajuste Nova Empresa
@history ticket TI - Antonio Domingos - 22/05/2023 - Revis�o Ajuste Nova Empresa
*/

//+-------------------------------------------------+
//|Declaracao de variaveis                          |
//+-------------------------------------------------+
Private _aArea:=GetArea()   
//+----------------------------------+
//|Retorno da Consulta Padrao        |
//+----------------------------------+
Private _cCli			:= M->C5_CLIENTE				//CLIENTE
Private _cLoja			:= M->C5_LOJACLI				//CLIENTE
Private _cVend			:= ''								//VENDEDOR
//+----------------------------------+
//|Controle                          |
//+----------------------------------+
Private _lRet		  	:= .T.						//Retorno
Private _User			:= ALLTRIM(CUSERNAME)	//Usuario Logado
Private _cSup			:= ''							//Supervisor
Private _aVnds			:= {}							//Vendedores do supervisor
Private _nPos											//Retorno da Busca em Array

//+----------------------------------+
//|Ambiente                          |
//+----------------------------------+
Private SA3FIL			:= xFilial("SA3")
Private SZRFIL			:= xFilial("SZR")
Private SA1FIL			:= xFilial("SA1")
Private _cEmpFL1 := SuperGetMv("MV_#EMPFL1",.F.,"0102/1301") //Codigo de Empresas+Filiais Ativas Grupo 1 //ticket TI - Antonio Domingos - 17/05/2023

DbSelectArea("SA3")
DbSetOrder(2)				//FILIAL+CODIGO
      
DbSelectArea("SZR")
DbSetOrder(2)       		//FILIAL+CODIGO       

DbselectArea("SA1")
DbsetOrder(1)          //FILIAL+CODIGO+LOJA

//==========================================
//============PROGRAMA PRINCIPAL============
//==========================================

//IF AllTrim(SM0->M0_CODIGO) = '01' .AND. AllTrim(SM0->M0_FILIAL)='02'
IF AllTrim(SM0->M0_CODIGO)+AllTrim(SM0->M0_CODFIL) $ _cEmpFL1 //ticket TI - Antonio Domingos - 17/05/2023 

//+-----------------------------------+
//|Procurando Vendedor do cliente     |
//+-----------------------------------+
DbselectArea("SA1")
If dbSeek(SA1FIL+_cCli+_cLoja)
	_cVend:=A1_VEND
EndIf


//+-----------------------------------------+
//|Verificar se e' supervisor               |
//|Verifica se o vendedor faz parte do      |
//|supervisor                               |
//+-----------------------------------------+
DBSELECTAREA("SZR")
If DbSeek(SZRFIL+_User,.T.)
	_cSup:=ZR_CODIGO
	//+-------------------------------------+
	//|Procurando Supervisor nos Vendedores |
	//+-------------------------------------+	
	DbselectArea("SA3")	
	DbSetOrder(5)					//FILIAL+CODSUP
	If DbSeek(SA3FIL+_cSup,.T.)                
		//+-----------------------------------+
		//|Carrega vendedores do supervisor   | 
		//+-----------------------------------+		
		While !eof() .and. A3_CODSUP==_cSup
			AADD(_aVnds,{A3_COD})
			Dbskip()
		End          
		//+-------------------------------------+		
		//|Verificando se o vendedor do cliente |
		//|pertence ao supervisor               |
		//+-------------------------------------+
		_nPos:=Ascan(_aVnds,_cVend)
		If _nPos<>0  
			_lRet:=.T.
		Else 
			_lRet:=.F.
		EndIf		
	Else
		_lRet:=.T.
	EndIf
Else
	//+-----------------------------------------+
	//|Verifico se o usuario logado e vendedor  |
	//|Se for vendedor verifico se o clinete    |
	//|faz parte de sua carteira                |
	//+-----------------------------------------+  
	DbSelectArea("SA3")
	If Dbseek(SA3FIL+_User,.T.)
		If _cVend=SA3->A3_COD
			_lRet:=.T.
		Else 
			_lRet:=.F.
		EndIf	
	Else
		_lRet:=.T.
	EndIf                  
EndiF           

RestArea(_aArea)
If !_lRet
	MsgInfo("Cliente nao pertence a sua carteira")
	M->C5_CLIENTE:=""
EndIf
     

//===============================
//=============FIM===============
//===============================

ENDIF
Return(_lRet)
