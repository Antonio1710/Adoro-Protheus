/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � Modulo11 � Autor � GUSTAVO GONELA        � Data � 06/06/03 潮�
北媚哪哪哪哪呐哪哪哪哪哪聊哪哪哪聊哪哪哪哪哪哪哪哪哪哪哪聊哪哪牧哪哪哪哪哪幢�
北矰escri噮o � Calculo do modulo 11, retornando digito de controle        潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砈intaxe   � ExpL1 := Modulo11(ExpC1,ExpN1,ExpN2)                       潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北砅arametros� ExpC1 = String para calcular o digito                      潮�
北�          � ExpN1 = Primeiro numero de multiplicacao do modulo 11      潮�
北�          � ExpN2 = Ultimo numero de multiplicacao do modulo 11)       潮�
北�          �                                                            潮�
北�          � ExpC2 = Digito de verificacao (Retornado pela funcao)      潮�
北媚哪哪哪哪呐哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪幢�
北� Uso      � Especifico Ad'oro Alimenticia                              潮�
北�          � Banco do Brasil                                            潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Modulo 11 - Padrao Microsiga                                   �
//�             1 7 7 4 0 0  0 0 0 2 1  ?                          �
//�             x x x x x x  x x x x x  ?                          �
//�             4 3 2 9 8 7  6 5 4 3 2  ?                          �
//�                                                                �
//� Modulo 11 - Padrao Banco do Brasil                             �
//�             1 7 7 4 0 0  0 0 0 2 1  ?                          �
//�             x x x x x x  x x x x x  ?                          �
//�             7 8 9 2 3 4  5 6 7 8 9  ?                          �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
/*/

User Function MOD11SAF()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Calculo do modulo 11, retornando digito de controle')

_cNum := PARAMIXB

nMin := 9
nMax := 2



// Alterado RNUTTI 03/02/2003 - Ajuste
//
//     nLen := Len( _cNum ) ;
//          , nSum := 0;
//          , nFat;
//          , i

nLen := Len( _cNum )
nSum := 0

// Fim alteracoes

nMin := If( nMin == NIL, 9, nMin )
nMax := If( nMax == NIL, 2, nMax )
nFat := nMin
_ret  := 0
for _ni := 1 to nLen  step 1
	
	nSum += Val( SubStr( _cNum, _ni, 1 ) ) * nFat
	
	if nFat == nMax
		
		nFat := nMin
	else
		nFat --
	end
next

_ni := (nSum % 11) 

if _ni == 0
		_ret := "1"

elseif  _ni == 1
		_ret := "0"  
	
else
	_ret := Strzero(11 - _ni,1)   
//	 	_ret := substr(_ret,1) 
		
endif  

return(_ret)






/*/ programa original alterado em 12/09/02 - Marcos Bido

Local _i, _nModulo := 0, _cChar, _nMult
_nMultIni := 9     // 2   - Banco do Brasil e' invertido
_nMultFim := 2     // 9   - Banco do Brasil e' invertido

_nMult := _nMultIni
_cStr := AllTrim(_cStr)
_cRet := " "

For _i := Len(_cStr) to 1 Step -1
	_cChar := Substr(_cStr,_i,1)
	If isAlpha( _cChar )
		Help(" ", 1, "ONLYNUM")
		Return .F.
	End
	_nModulo += Val(_cChar)*_nMult
	//_nMult:= IIf(_nMult==_nMultfim,2,_nMult+1) - Banco do Brasil e' invertido
	_nMult:= IIf(_nMult==_nMultfim,9,_nMult-1)
	
	
Next

_nRest := _nModulo % 11

// Alteracao RNUTTI 03/09/2002 - Banco Itau, para resto 10, digito e' "X"
// nRest := IIf(nRest==0 .or. nRest==1,0,11-nRest)


If _nRest==0 .or. _nRest==1
	_cRet := "0"
ElseIf _nRest==10
	_cRet := "X"
Else
	_cRet := StrZero(11-_nRest,1)
Endif

// Fim Alteracoes

Return( _cRet )
/*/

