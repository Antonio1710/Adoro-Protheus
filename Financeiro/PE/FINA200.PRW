#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01

User Function FINA200()        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01 

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("NVALREC,NDESPES,")

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇�袴袴袴袴袴箇袴袴袴袴藁袴袴袴藁袴袴袴袴袴袴袴袴袴袴箇袴袴藁袴袴袴袴袴袴敲굇
굇� Programa � FINA200  � Autor � Rogerio Nutti      � Data �  25/08/00   볍�
굇勁袴袴袴袴誥袴袴袴袴袴姦袴袴袴姦袴袴袴袴袴袴袴袴袴菰袴袴袴姦袴袴袴袴袴袴묽�
굇튒escri뇙o � Ponto de Entrada para manipular variaveis no retorno do    볍�
굇�          � Banco Itau 341, Ag 0350, Conta 59690-4.                    볍�
굇�          � Tratamento das despesas de cobranca de boletos (R$ 1,19)   볍�
굇勁袴袴袴袴誥袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴묽�
굇튧so       � Espec죉ico Ad'oro                                          볍�
굇훤袴袴袴袴菰袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴袴선�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�
/*/

If nDespes > 0
   //Alltrim(mv_par06) == "341"  .and.;
   //Alltrim(mv_par07) == "0350" .and.;
   //Alltrim(mv_par08) == "59690-4"
   nValRec := nValRec + nDespes
// nDespes := 0
Endif

If MV_PAR06 == '399'

      dBaixa := DDATABASE
      
Endif

//MsgBox( SE1->E1_NUM ,"E1_NUM" ,"ALERT")
//MsgBox( "nDesPes "     +Str(nDesPes,20,2)     ,"nDesPes"     ,"ALERT")
//MsgBox( "nDescont "    +Str(nDescont,20,2)    ,"nDescont"    ,"ALERT")
//MsgBox( "nOutrDesp "   +Str(nOutrDesp,20,2)   ,"nOutrDesp"   ,"ALERT")
//MsgBox( "nTotAbat "    +Str(nTotAbat,20,2)    ,"nTotAbat"    ,"ALERT")
//MsgBox( "nValRec "     +Str(nValRec,20,2)     ,"nValRec"     ,"ALERT")
//MsgBox( "nJuros "      +Str(nJuros,20,2)      ,"nJuros"      ,"ALERT")
//MsgBox( "nMulta "      +Str(nMulta,20,2)      ,"nMulta"      ,"ALERT")
//MsgBox( "nTotaGer "    +Str(nTotaGer,20,2)    ,"nTotaGer"    ,"ALERT")
//MsgBox( "nValEstrang " +Str(nValEstrang,20,2) ,"nValEstrang" ,"ALERT")

Return
