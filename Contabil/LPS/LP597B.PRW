#Include "rwmake.ch"

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �LP597     �Autor  �Everaldo Casaroli   � Data �  30/06/08   ���
�������������������������������������������������������������������������͹��
���Desc.     � Este LP retorna dados para o LP 597 (compensa��o contas a  ���
���          � a pagar. Trata o posicionamento dos t�tulos.               ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Chamada no LP 597.                                         ���
���          �                                                            ���
�������������������������������������������������������������������������ͼ��
���Atualiz.  �                                                            ���
|��                                                                       ���
|��          �                                                            ���
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function LP597B(_cPar1,_cPar2)  

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')


// Defini��o das vari�veis.
Public _aArea   	:= GetArea()
Public _aAreaSE5	:= {}
Public _nRet		:= 0
Public _cChavePA	:= Space(23)
Public _cChaveNF	:= Space(23)
Public _cChave		:= Space(23)
_cPar1 := Upper(Alltrim(_cPar1)) // Tipo de Dado a ser retornado.
_cPar2 := Upper(Alltrim(_cPar2)) // Tipo de Dado a ser retornado.

dbSelectArea("SE5")
_aAreaSE5 := GetArea()
If Alltrim(SE5->E5_TIPO) $ "PA/NDF" // Usu�rio compensou posicionando na NF.
	_cChaveNF := SUBSTR(SE5->E5_DOCUMEN,1,15)+SE5->E5_CLIFOR+SE5->E5_LOJA+SE5->E5_SEQ
	_cChavePA := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
Else // Usu�rio compensou posicionando no PA/NDF
	_cChaveNF := SE5->(E5_PREFIXO+E5_NUMERO+E5_PARCELA+E5_TIPO+E5_CLIFOR+E5_LOJA)
	_cChavePA := SUBSTR(SE5->E5_DOCUMEN,1,15)+SE5->E5_CLIFOR+SE5->E5_LOJA
EndIf
RestArea(_aAreaSE5)


//Casaroli
IF _cPar1 == "SE5" // Retorna o valor a ser contabilizado 
                                     
	dbSelectArea("SE5")
	_aAreaSE2 := GetArea()
	dbSetOrder(7) //E2_FILIAL+E2_PREFIXO+E2_NUM+E2_PARCELA+E2_TIPO+E2_FORNECE+E2_LOJA
	If dbSeek(xFilial("SE5")+_cChaveNF,.T.)                                                                                               

		IF _cPar2 == "E5D"
			_nRet := SE5->E5_VLDECRE
		Elseif _cPar2 == "E5J"
			_nRet := SE5->E5_VLACRES
		Endif		

	//Casaroli
	EndIf
Endif	

RestArea(_aAreaSE5)

// Restaura �reas de trabalho.
RestArea(_aArea)

// Retorna dado para o LP.
Return(_nRet)
