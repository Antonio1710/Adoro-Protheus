/*/
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � ModSuda  � Autor � Gustavo Gonela        � Data � 03/09/02 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Calculo do modulo 11, retornando digito de controle        ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ExpL1 := Modulo11(ExpC1,ExpN1,ExpN2)                       ���
�������������������������������������������������������������������������Ĵ��
���Parametros� ExpC1 = String para calcular o digito                      ���
���          � ExpN1 = Primeiro numero de multiplicacao do modulo 11      ���
���          � ExpN2 = Ultimo numero de multiplicacao do modulo 11)       ���
���          �                                                            ���
���          � ExpC2 = Digito de verificacao (Retornado pela funcao)      ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Ad'oro Alimenticia                              ���
���          � Banco Sudameris                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
//����������������������������������������������������������������Ŀ
//� Modulo 11 - Padrao Microsiga e Sudameris                                  �
//�             1 7 7 4 0 0  0 0 0 2 1  ?                          �
//�             x x x x x x  x x x x x  ?                          �
//�             4 3 2 9 8 7  6 5 4 3 2  ?                          �
//�                                                                �
//� Modulo 11 - Padrao Banco Banco do Brasil                            �
//�             1 7 7 4 0 0  0 0 0 2 1  ?                          �
//�             x x x x x x  x x x x x  ?                          �
//�             7 8 9 2 3 4  5 6 7 8 9  ?                          �
//������������������������������������������������������������������
/*/

User Function MODSUDA()        

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
_ret :=" "
// Fim alteracoes

nMin := If( nMin == NIL, 2, nMin )
nMax := If( nMax == NIL, 9, nMax )
//nFat := nMin
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

if _ni == 0
		_ret := "1"

elseif  _ni == 1
		_ret := "0"  
	
else
	_ret := Strzero(11 - _ni,1)   
		
endif  

return(_ret)
