#include "Protheus.ch"    
#include "rwmake.ch"    

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � IMPFRET � Autor � ALEX BORGES          � Data � 21/02/11   ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Importacao de precos de arquivo texto para tabela ZC0 -    ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Logistica                                                  ���
��������������������������������������������������������������������������ٱ�
��� Arquivos �                                                            ���
��� em Uso   �                                                            ���
��������������������������������������������������������������������������ٱ�
��� Manutencao :                                                          ���
���                                                                       ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function IMPFRET()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Importacao de precos de arquivo texto para tabela ZC0')

/*LAYOUT DO ARQUIVO CSV A SER IMPORTADO:

Delimitado por ";", com 1 linha de cabecalho

1= Cod. Tabela 	(Tipo Caracter)
2= Data Limite  (Data)
3= km inicial 	(Tipo Numerico)
4= km Final  	(Tipo Numerico)
5= Preco 	    (Tipo Numerico, com 2 decimais, mascara 999999,99)

Exemplo:
TABELA;DATALIMITE;KMINICIAL;KMFINAL;PRE�O
FV;01/01/2011;1;10;346.04 
FV;01/01/2011;11;20;346.04 
FV;01/01/2011;21;30;346.04 
FV;01/01/2011;31;40;346.04 
FV;01/01/2011;41;50;346.04 
FV;01/01/2011;51;60;346.04 
FV;01/01/2011;61;70;346.04 
*/

_nTamLin 	:= 100            		// Tamanho da linha no arquivo texto
_nHdl    	:= Nil           		// Handle para abertura do arquivo
_cBuffer 	:= Space(_nTamLin+1) 	// Variavel para leitura
_nBytes  	:= 0                	// Variavel para verificacao do fim de arquivo
_cFileLog 	:= ""                   // Arquivo para gravacao do log de execucao da rotina
_cPath 		:= ""  					//caminho onde sera gravado o arquivo de LOG
_nQtChar 	:= 2
_cDelimit	:= ";"                 //Delimitador do arquivo CSV


_cPerg		:= PADR("IMPFRET",10," ")
//@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
//ValidPerg()

if Pergunte(_cPerg,.T.)
	_cArq    	:= MV_PAR01      		// Arquivo texto a importar
	
	If MsgBox(OemToAnsi("Confirma importa��o de Valores do arquivo "+Alltrim(_cArq)+" para as Tabelas de Pre�os? "),"ATENCAO","YESNO")
		_nHdl := fOpen(_cArq,2) // Abre o arquivo
		fClose(_nHdl)
		If _nHdl == -1
			Aviso( "AVISO",OemToAnsi("N�o foi poss�vel abrir o arquivo "+_cArq),{"Sair"} )
		else
			Processa({|| RunImpTXT()})
		endif
	endif
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �RUNIMPTXT �Autor  �ADRIANA - HC        � Data �  27/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Executa rotina de importacao com regua de processamento     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function RunImpTXT()

Dbgotop()

ft_fUse(_cArq) 	//Abre o arquivo

ProcRegua(RecCount())
	ft_fGoTop()		//Posiciona no inicio do arquivo
	_nLin := 1     
	
	Do While !ft_fEOF() 
	     _arqOk := .T.
		_cBuffer := ft_fReadLn() 
		_nCmp := 1 

		FOR I := 1 TO 5
	   	    _cTxtPos := Substr(_cBuffer,1,At(_cDelimit, _cBuffer)-1)
			if _nCmp = 1	
				_cCod    := _cTxtPos
			elseif _nCmp = 2   
				_datlim := ctod(_cTxtPos)
			elseif _nCmp = 3   
				_kmi := _cTxtPos 
		    elseif _nCmp = 4 
				_kmf := _cTxtPos
		    elseif _nCmp = 5  
				npreco := Val(StrTran(_cBuffer,",","."))
			endif  
			_cBuffer := Substr(_cBuffer,At(";", _cBuffer)+1)
			_nCmp++
		End
	   	IncProc("Importando - Tabela: "+_cCod + " KM Inicial: " + _kmi + " KM Final: "+_kmf + " Pre�o: "+ cvaltochar(npreco)) 
		dbselectarea("ZC0")
		dbsetorder(2)  
		    RecLock("ZC0",.T.) // .T. - Inclusao / .F. - Alteracao
			ZC0->ZC0_FILIAL  := FwxFilial("ZC0")
			ZC0->ZC0_FILIAL  := "" 
	    	ZC0->ZC0_TIPFRT  := _cCod  
	    	ZC0->ZC0_DATVAL	 := _datlim 
		    ZC0->ZC0_KMINI	 := VAL(_kmi)
	    	ZC0->ZC0_KMFIM	 := VAL(_kmf )
		    ZC0->ZC0_FRTTOM	 := Round(npreco,2)
		    MSUnLock()   
	
			

		
		ft_fSkip()
		_nLin ++
	

End
      
iF _arqOk
     msgInfo("Processamento concluido com sucesso!")
endIf

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VALIDPERG �Autor  �ADRIANA - HC        � Data �  27/10/10   ���
�������������������������������������������������������������������������͹��
���Desc.     � Para incluir perguntas no SX1                              ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

//Static Function ValidPerg
//
//PutSx1(_cPerg,"01","Importar do Arquivo CSV ?", "Importar do Arquivo ?", "Importar do Arquivo ?", "mv_ch1","C",50,0,0,"G",""         ,"","","","mv_par01","","","","","","","","","","","","","","","","","","","")
//
//
//Return
