/*/
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北谀哪哪哪哪穆哪哪哪哪哪履哪哪哪履哪哪哪哪哪哪哪哪哪哪哪履哪哪穆哪哪哪哪哪勘�
北矲un噮o    � Modulo11 � Autor � Rogerio Eduardo Nutti � Data � 03/09/02 潮�
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

User Function MODUL11()
                           
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

nMin := If( nMin == NIL, 2, nMin )
nMax := If( nMax == NIL, 9, nMax )
nFat := nMin

for _ni := nLen to 1 step -1
	
	nSum += Val( SubStr( _cNum, _ni, 1 ) ) * nFat
	
	if nFat == nMax
		
		nFat := nMin
	else
		nFat --
	end
next

_ni := (nSum % 11)

if _ni > 9
	_ni := "X"
else
	_ni := str(_ni,1)
	
endif

return(_ni)