/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � ModBra   � Autor � Gustavo               � Data � 10/09/03 潮�
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
北�          � BANCO BRADESCO                              潮�
北滥哪哪哪哪牧哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪俦�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
//谀哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪目
//� Modulo 11 - Padrao Microsiga                                   �
//�             1 7 7 4 0 0  0 0 0 2 1  ?                          �
//�             x x x x x x  x x x x x  ?                          �
//�             4 3 2 9 8 7  6 5 4 3 2  ?                          �
//�                                                                �
//滥哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪哪馁
/*/

User Function MOD237()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Calculo do modulo 11, retornando digito de controle')

_cNum := PARAMIXB

nMin := 7
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

nMin := If( nMin == NIL, 2, nMin )
nMax := If( nMax == NIL, 7, nMax )
nFat := nMax

for _ni := nLen to 1 step -1
	
	nSum += Val( SubStr( _cNum, _ni, 1 ) ) * nFat
	
	if nFat == nMin
		
		nFat := nMax
	else
		nFat ++
	end
next

_ni := (nSum % 11)

if _ni = 1
	_ni := "P"
else 
	If  _ni = 0
	
		_ni := str(_ni,1)
	 Else 
	    
	    _ni := str(11 - _ni, 1)
	    
	 Endif
endif

return(_ni)