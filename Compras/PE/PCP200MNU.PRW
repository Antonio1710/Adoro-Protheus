#include "protheus.ch"
#include "topconn.ch"
#INCLUDE "REPORT.CH"

/*/{Protheus.doc} User Function PCP200MNU
    Ponto Entrada adicionar botão no cadastro de estrutura
    Ticket 78955 
    @type  Function
    @author Everson
    @since 29/08/2022
    @version 01
/*/
User Function PCP200MNU()

    aAdd( aRotina, { "* Importa XLS", "U_ADCON019P()", 0, 5, , .F. } )
    
Return aRotina
