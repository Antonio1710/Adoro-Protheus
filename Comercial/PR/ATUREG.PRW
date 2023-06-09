#include "Protheus.ch"
#include "rwmake.ch"


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � ATUREG � Autor � Alex Borges            � Data � 09/01/12  ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Importa��o CSV para atualizar regiao das cidades(CC2)      ���
���          �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Comercial                                                  ���
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

User Function ATUREG()


/*LAYOUT DO ARQUIVO CSV A SER IMPORTADO:

Delimitado por ";", com 1 linha de cabecalho
 

1= UF 	
2= Cod. Municipio  
3= Cod. Regiao 	

*/

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Importa��o CSV para atualizar regiao das cidades(CC2)')

_nTamLin 	:= 100            		// Tamanho da linha no arquivo texto
_nHdl    	:= Nil           		// Handle para abertura do arquivo
_cBuffer 	:= Space(_nTamLin+1) 	// Variavel para leitura
_nBytes  	:= 0                	// Variavel para verificacao do fim de arquivo
_cFileLog 	:= ""                   // Arquivo para gravacao do log de execucao da rotina
_cPath 		:= ""  					//caminho onde sera gravado o arquivo de LOG
_nQtChar 	:= 2
_cDelimit	:= ";"                 //Delimitador do arquivo CSV


_cPerg		:= PADR("IMPMET",10," ")
//@history Ticket 70142  - Edvar / Flek Solution - 06/04/2022 - Retirada de fun��o PUTSX1
//ValidPerg()

if Pergunte(_cPerg,.T.)
	_cArq    	:= MV_PAR01      		// Arquivo texto a importar
	
	If MsgBox(OemToAnsi("Confirma atualiza��o de regi�es do arquivo "+Alltrim(_cArq)+" para a tabela de municipios? "),"ATENCAO","YESNO")
		_nHdl := fOpen(_cArq,2) // Abre o arquivo
		fClose(_nHdl)
		If _nHdl == -1
			Aviso( "AVISO",OemToAnsi("N�o foi poss�vel abrir o arquivo "+_cArq),{"Sair"} )
		else
			Processa({|| ImpReg()})
		endif
	endif
Endif

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  ImpReg �Autor  �Alex Borges -        � Data �  09/01/12   ���
�������������������������������������������������������������������������͹��
���Desc.     �Executa rotina de importacao com regua de processamento     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

Static Function ImpReg()

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
				_UF    := _cTxtPos
			elseif _nCmp = 2   
			    _CodMun := _cTxtPos 
				//Verifica se existe o municipio
			 	DbSelectArea("CC2")
				Dbsetorder(1)//FILIAL+UF+COD MUNICIPIO
				If !DBSEEK(xFilial("CC2")+_UF+_CodMun,.T.)
					ALERT("CODIGO DO MUNICIPIO "+_CodMun+" INVALIDO NA LINHA :"+ALLTRIM(Str(_nLin)))
					Return
				End If
				
			elseif _nCmp = 3   
				_CodRegiao := _cTxtPos 
				//Verifica se existe o codigo de regiao
			 	DbSelectArea("ZZI")
				Dbsetorder(2)//FILIAL+UF+REGIAO
				If !DBSEEK(xFilial("ZZI")+_UF+_CodRegiao,.T.)
					ALERT("CODIGO DE REGIAO "+_CodRegiao+" INVALIDO NA LINHA :"+ALLTRIM(Str(_nLin)))
					Return
				End If
			endif  
			_cBuffer := Substr(_cBuffer,At(";", _cBuffer)+1)
			_nCmp++
		End
	   	IncProc("Importando : "+_UF + " Cod. Mun: " + _CodMun ) 
	   
		dbSelectArea("CC2")
	    // Verifica se ja tem existe o municipio
	    If dbseek(xFilial("CC2")+_UF+_CodMun,.t.)
		    RecLock("CC2",.F.)
		    // Sobrepor informacoes da Meta Preco
		    Replace CC2_XREGIA   With _CodRegiao
		    MSUNLOCK()
   		Endif
		
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
