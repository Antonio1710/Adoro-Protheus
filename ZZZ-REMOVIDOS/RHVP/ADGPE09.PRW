#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 10/10/01
#IFDEF  WINDOWS
        #DEFINE SAY PSAY
#ENDIF

User Function ADGPE09()        // incluido pelo assistente de conversao do AP5 IDE em 10/10/01

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴�

SetPrvt("CALIAS_,NREC_,CSAVIND1,NVCES_,NPCES_,NDESC_")
SetPrvt("NFALT_,CHDIA_,ATABREF,BBLOCK,IX,APD,nPerc_")

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Calcula o desconto da Cesta Basica Visa Vale (checa faltas)')

/*
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컫컴컴컴컴컴쩡컴컴컴쩡컴컴컴컴컴컴컴컴컴컴컴쩡컴컴컫컴컴컴컴컴엽�
굇쿛rograma  � ADGPE09  � Autor � Isamu Kawakami        � Data � 07/01/08 낢�
굇쳐컴컴컴컴컵컴컴컴컴컴좔컴컴컴좔컴컴컴컴컴컴컴컴컴컴컴좔컴컴컨컴컴컴컴컴눙�
굇쿏escri뇚o � Calcula o desconto da Cesta Basica Visa Vale (checa faltas)낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿞intaxe   � RDMake ( DOS e Windows )                                   낢�
굇쳐컴컴컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇� Uso      � Especifico para AD'ORO                                     낢�
굇쳐컴컴컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�         ATUALIZACOES SOFRIDAS DESDE A CONSTRU�AO INICIAL.             낢�
굇쳐컴컴컴컴컴컫컴컴컴컴쩡컴컴컫컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇쿛rogramador � Data   � BOPS �  Motivo da Alteracao                     낢�
굇쳐컴컴컴컴컴컵컴컴컴컴탠컴컴컵컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴눙�
굇�            �        �      �                                          낢�
굇읕컴컴컴컴컴컨컴컴컴컴좔컴컴컨컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�*/

#IFDEF  WINDOWS
// Movido para o inicio do arquivo pelo assistente de conversao do AP5 IDE em 10/10/01 ==>         #DEFINE SAY PSAY
#ENDIF

// Verifica se funcionario possui Visa Vale
If Sra->Ra_CestaB # "V"
        Return
End
    
// Verifica Filial Deve ser Processada (Parte da Reconstrucao do Roteiro de Calculo) - By Asr
If cEmpAnt == "01"
   If !( SRA->RA_FILIAL $ "01*02*06" )
      Return("")
   EndIf
EndIf

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Salva Ambiente                                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
cAlias_  := Alias()
nRec_    := Recno()
cSavInd1 := IndexOrd()

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Montando Variaveis de Trabalho                               �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
nPerc_  := 0
nVces_  := 0
nPces_  := 0  
nDesc_  := 0
nFalt_  := 0
cHdia_  := ' '
aTabref := {}
bBlock  := {|X,Y| X[1] < Y[1]} //Classificacao do array

//旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴커
//� Processamento                                                �
//읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴켸
//Verifica Dias de Falta
nFalt_ := Abs(fBuscaPD(aCodFol[054][1],"H"))
nFalt_ := Int(nFalt_/7.10)   //Alterado de 8.90 para 8.80 em 21.07.00
                                     //Alterado de 8.80 para 7.20 em 04.04.02
                                     // em decorencia da mudanca de horario  
                                     //Alterado de 7.20 para 7.10 em 03.08.2011 porque para os funcionarios que trabalham em turnos
                                     //que a carga horaria e 7.18 o sistema nao considerava um dia de faltas para abatimento da cesta basica
                                     
// Valor da Cesta Basica e percentual desconto
If cEmpAnt == "01"
   RCC->(dbSeek(xFilial("RCC")+"U004"))
   nVces_ := Val(Subs(Rcc->Rcc_Conteu,1,12))
   nPerc_ := Val(Subs(Rcc->Rcc_Conteu,13,6))
ElseIf cEmpAnt == "02"
   RCC->(dbSeek(xFilial("RCC")+"U003"))
   nVces_ := Val(Subs(Rcc->Rcc_Conteu,1,12))
   nPerc_ := Val(Subs(Rcc->Rcc_Conteu,13,6))
Endif

If nVces_ == 0
        nVces_ := Val(Subst(GetAdvFval("SRX","RX_TXT","  35" + xFilial()+"1",1,"       "),1,11))
Endif

If nFalt_ > 0
  // Percentual de Desconto
  dbSelectArea("SZ1")

  If SZ1->(dbSeek(xFilial()+"04"))
        
        while SZ1->Z1_COD == '04'
                aadd(aTabref,{SZ1->Z1_VAL01,SZ1->Z1_VAL02})
                SZ1->(dbSkip())
        end

        // Classifica Array
        aSort(aTabref,,,bBlock)

        For ix := 1 to Len(aTabref) 
                If aTabref[ix][1] >= nFalt_
                        nPces_ := aTabref[ix][2]
                        Exit
                End
        Next

  Else
        //Exibe Help
        Help(' ',1,'SEMTAB04')

        //Retorna Ambiente
        dbSelectArea(cAlias_) 
        dbSetOrder(cSavInd1)
        dbGoto(nRec_)
                        
        Return
  end

// Calculo do Desconto
  nDesc_ := nVces_ * nPces_/100

Else  
  nDesc_ := nVces_ * nPerc_/100
Endif
  
// Verifica Se Verba Nao Informada e Gera Valor e Valor Desconto Maior que Zero
If Sra->Ra_CestaB == "V"
   fGeraVerba(aCodFol[156][1],nDesc_,,,,,,,,,.T.)
   If nDesc_ < nVces_
      fGeraVerba(aCodFol[211][1],nVces_-nDesc_,,,,,,,,,.T.)
   Endif   
End

//Retorna Ambiente
dbSelectArea(cAlias_)
dbSetOrder(cSavInd1)
dbGoto(nRec_)

Return

/*/
複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複複�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
굇旼컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴엽�
굇�                          Fim do Programa                              낢�
굇읕컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴컴袂�
굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇굇�
賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽賽�/*/
