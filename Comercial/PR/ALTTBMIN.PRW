///////////////////////////////////////////////////////////////////////////////////////////////////////////////
// Fun��o        : ALTTBMIN.prw                                                                              //
// Autor         : Mauricio da Silva - MDS TECNOLOGIA                                                        //
// Data Cria��o  : 01/02/2012                                                                                //
// Descricao     : Altera parametro MV_TBPRMN                                                                //
// Pr�-Requisito :                                                                                           //
// --------------------------------------------------------------------                                      //
// ALTERA��ES EFETUADAS                                                                                      //
// N� | Data/Hora        | Programador         | Descri��o                                                   //
//    |                  |                     |                                                             //
///////////////////////////////////////////////////////////////////////////////////////////////////////////////
//@history Ticket 85319  - Antonio Domingos - 10/01/2023 - Valida��o Fontes V33 - Dic. Banco de Dados.
//@history ticket 85390 - Antonio - 31/01/2023 -Validacao fontes v33 - dic. banco de dados.       
#INCLUDE "PROTHEUS.CH"
#Include "RwMake.ch"
//#include "fivewin.ch"

User Function ALTTBMIN()
//Local _cValUsu := GETMV("MV_XALTPAR")
Private _cTab   := "   "
Private oDlg    := Nil
Private _cParF  := GetMV("MV_TBPRMN")

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Altera parametro MV_TBPRMN')

//If !(__cUserID $ _cValUsu)
//   MsgInfo("Voce n�o tem permiss�o para utilizar esta rotina!","Aten��o") 
//   Return()
//Endif   

cAlias:=Alias()
Index :=IndexOrd()
Rec   :=Recno()
            
@0,0 TO 220,500 DIALOG oDlg TITLE "Altera��o Tabela preco minimo"

@10,5 SAY "Tabela preco minimo : "
@10,80 MSGET _cTab SIZE 30,10 PIXEL OF oDlg

@50,5 SAY "Conteudo Atual Parametro  : "
@50,140 SAY _cParF SIZE 30,10 PIXEL OF oDlg                          

@ 88,100 BUTTON "&Alterar" SIZE 33,14 PIXEL ACTION oCons()
@ 88,200 BUTTON "&Sair" SIZE 33,14 PIXEL ACTION oDlg:End()  

ACTIVATE DIALOG oDlg CENTER

RETURN

STATIC FUNCTION oCons()
IF !MSGBOX("Tem certeza?","CONFIRMACAO","YESNO")
	return
endif

_nMax := _cTab  
PutMv("MV_TBPRMN", _nMax)
/*
GetMV("MV_TBPRMN")
DbSelectArea("SX6")
While !MsRlock(); End
MsRlock()
    SX6->X6_CONTEUD:=_nMax
    SX6->X6_CONTENG:=_nMax
    SX6->X6_CONTSPA:=_nMax
MsRunlock()
        
dbSelectArea(cAlias)
dbSetOrder(Index)     
dbGoto(Rec)
*/
Close(oDlg)

RETURN(.T.)

