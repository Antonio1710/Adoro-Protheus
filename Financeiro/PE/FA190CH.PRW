#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01

User Function FA190CH()        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01  

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("_CALI,_NORD,_NREC,_NUM,_BANCO,_AGENCIA")
SetPrvt("_CONTA,_PREFIXO,")

/*/                                                      
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴佶袴袴袴袴藁袴袴袴錮袴袴袴袴袴袴袴袴袴袴箇袴袴錮袴袴袴袴袴袴敲굇
굇� Programa � FA190CH  � Autor � Joaquim Assis      � Data 쿥ed  07/07/99볍�
굇勁袴袴袴袴曲袴袴袴袴袴姦袴袴袴鳩袴袴袴袴袴袴袴袴袴菰袴袴袴鳩袴袴袴袴袴袴묽�
굇튒escri뇙o � Ponto de Entrada na Juncao dos Cheques, Adiciona Prefixo   볍�
굇�          � no cheque Aglutinador. Segundo Sr.Fernando e Sr.Ricardo nao볍�
굇�          � ha posibilidade de Aglutinar Titulos de Outras Unidades.   볍�
굇勁袴袴袴袴曲袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Espec죉ico Ad'oro                                          볍�
굇훤袴袴袴袴賈袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/
//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Guarda Area do Siga                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_cAli := Alias()
_nOrd := IndexOrd()
_nRec := Recno()

dbSelectArea("SEF")                
_cAliSEF := Alias()
_nOrdSEF:= IndexOrd()
_nRecSEF := Recno()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Declaracao de Variaveis Utilizadas �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
_cFilial  := Space(02)
_cNum     := Space(15)
_cBanco   := Space(03)
_cAgencia := Space(05)
_cConta   := Space(10)
_cPrefixo := Space(03)

_cFilial  := xFilial("SEF")
_cNum     := cCheque190+Repl(" ",15-Len(cCheque190))     //SEF->EF_NUM
_cBanco   := cBanco190+Repl(" ",15-Len(cBanco190))      //SEF->EF_BANCO
_cAgencia := cAgencia190+Repl(" ",15-Len(cAgencia190))    //SEF->EF_AGENCIA
_cConta   := cConta190+Repl(" ",15-Len(cConta190))      //SEF->EF_CONTA

//------------------------------------------------------------------------------------
//MsgBox("Filial: ["+Alltrim(Str(Len(xFilial("SEF"))))+"]" ,"Atencao","INFO")
//MsgBox("Cheque: ["+Alltrim(Str(Len(_Num)))+"]" ,"Atencao","INFO")
//MsgBox("Banco: ["+Alltrim(Str(Len(_Banco)))+"]" ,"Atencao","INFO")
//MsgBox("Agencia: ["+Alltrim(Str(Len(_Agencia)))+"]" ,"Atencao","INFO")
//MsgBox("Conta Cor: ["+Alltrim(Str(Len(_Conta)))+"]" ,"Atencao","INFO")
//------------------------------------------------------------------------------------

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Processamento                      �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea("SEF")
// Corrigido conforme pedido do Rogerio Nutti da Microsiga
//dbSetOrder(5)
dbSetOrder(8)
//           2        15    3         5        10     1
If dbSeek(_cFilial+_cNum+_cBanco+_cAgencia+_cConta+"A")
   _Prefixo := SEF->EF_PREFIXO
   If dbSeek(_cFilial+_cNum+_cBanco+_cAgencia+_cConta+" ")
      RecLock("SEF",.F.)
      Replace EF_PREFIXO With _Prefixo
      MsUnLock()
   Else
      MsgBox("Nao Achou o Cheque Aglutinador","Atencao","INFO")
   EndIf
Else
   MsgBox("Nao Achou o Cheque Aglutinado Tipo A","Atencao","INFO")
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Retorna ambiente inicial           �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
dbSelectArea(_cAliSEF)
dbSetOrder(_nOrdSEF)
dbGoTo(_nRecSEF)

dbSelectArea(_cAli)
dbSetOrder(_nOrd)
dbGoTo(_nRec)

Return 
