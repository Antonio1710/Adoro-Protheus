#INCLUDE "Protheus.ch"
#include "rwmake.ch"   
#include "topconn.ch"                                    
#include "AP5MAIL.CH" 

/*/{Protheus.doc} User Function EECPEM36 
    Ponto de entrada EMBARQUE DE EXPORTACAO BOTAO OK Caminho: Atualiza��es/Embarque/Cons.Manuten��o/Op��es Incluir ou Alterar/Bot�o OK.Descri��o: Chamada no bot�o de OK da fun��o de manuten��o de embarque AE100MAN() para as op��es de inclus�o ou altera��o.Uso: Executar rotinas de valida��es nos dados digitados. Os campos s�o todos de mem�ria, seguindo p/ o arquivo ap�s a execu��o completa da fun��o em que est� o ponto de entrada. utilizado para garantir que o campo DATA DE EMBARQUE e DUE sejam preenchidos corretamente
    @type  Function
    @author William Costa
    @since 03/03/2020
    @version 01
/*/

User Function EECPEM36()

    Local aArea	    := GetArea()
    Local lRet      := .T.
    
    IF VALTYPE(PARAMIXB) <> "U"

        lRet := .T.
        RETURN(lRet)   

    ENDIF

    IF !EMPTY(M->EEC_DTEMBA)        .AND. ;
       ALLTRIM(M->EEC_NRODUE) == '' 

        lRet:= .F.        
        MsgStop("Ol� " + Alltrim(cUserName) + ", necess�rio digitar o numero do DUE para continuar, favor verificar")
        
    ELSE

        lRet:= .T.

    ENDIF

    RestArea(aArea)

RETURN(lRet)         