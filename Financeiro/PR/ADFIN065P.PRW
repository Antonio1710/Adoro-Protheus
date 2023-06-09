#Include "Protheus.ch"
#Include 'Totvs.ch'
#Include 'Topconn.ch'
#include "rwmake.ch"

/*/{Protheus.doc} User Function ADFIN065P
    Altera Data PA SAG
    @type  Function
    @author Ricardo Lima
    @since 13/08/2018
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history chamado 050729 - FWNM     - 01/07/2020 - || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - Fonte n�o compilado no R27
    @history Ticket 81308   - Antonio Domingos  - 07/10/2022 - ALTERAR VENCIMENTO DE TITULOS A PAGAR NO DIA 12/10
    @history Ticket 92295 - 19/04/2023 - Fernando Macieira - PA IMPORTA��O > Altera��o Data de Emiss�o
/*/
User Function ADFIN065P

    LOCAL aArea      := GetArea()
    LOCAL dDataAgend := CTOD("")
    LOCAL nOpca      := 0                    
    LOCAL cTitulo	 := "Altera��o Vencimento PA SAG"
    Local lRet		 := .T.

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Altera Data PA SAG')

    if SE2->E2_TIPO <> 'PA'
        lRet := .F.
        ApMsgInfo('Essa Rotina n�o pode ser usada para esse tipo de Titulo.','Altera��o Vencimento - PA SAG')
    EndIf
    if SE2->E2_XDIVERG = 'S'
        lRet := .F.
        ApMsgInfo('Titulo Bloqueado, solicite a Aprova��o antes de alterar a Data.','Altera��o Vencimento - PA SAG')
    EndIf
    if lRet
        If SE2->E2_SALDO < SE2->E2_VALOR
            lRet := .F.
            ApMsgInfo('Data de Vencimento n�o pode ser alterada, Titulo j� sofreu baixa parcial ou compensa��o parcial.','Altera��o Vencimento - PA SAG')
        ELSE
            dDataAgend := SE2->E2_VENCREA
                    
            DEFINE MSDIALOG oDlg TITLE cTitulo FROM 00,00 TO 150,500 OF oMainWnd PIXEL
                //@ 035, 035 MSGET "Data Vencimento"  			SIZE 090,10 WHEN .F. OF oDlg PIXEL 
                @ 035, 035 SAY "Data Vencimento"  			SIZE 090,10 OF oDlg PIXEL // Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - FWNM - 01/07/2020
                @ 035, 124 MSGET oDataAge  	VAR dDataAgend		SIZE 090,10 PICTURE "@D" VALID Fa050VAge(dDataAgend)	OF oDlg PIXEL
            ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{||nOpca:=1,if(Fa050AOk(oDlg),nOpca:=1,nOpca := 0)},{||oDlg:End()}) CENTERED
            
            If nOpcA == 1                
                dDataAgend := DataValida(dDataAgend)
                RecLock("SE2",.F.)
                    //SE2->E2_EMISSAO := dDataAgend // @history Ticket 92295 - 19/04/2023 - Fernando Macieira - PA IMPORTA��O > Altera��o Data de Emiss�o
                    //SE2->E2_EMIS1   := dDataAgend // @history Ticket 92295 - 19/04/2023 - Fernando Macieira - PA IMPORTA��O > Altera��o Data de Emiss�o
                    SE2->E2_VENCTO  := dDataAgend
					//@history Ticket 81308 - Antonio Domingos  - 07/10/2022 - ALTERAR VENCIMENTO DE TITULOS A PAGAR NO DIA 12/10
                    //SE2->E2_VENCREA := dDataAgend
                    SE2->E2_VENCREA := DataValida( dDataAgend, .T. )
                    SE2->E2_DATALIB := dDataAgend
                MsUnLock()
                
                // @history Ticket 92295 - 19/04/2023 - Fernando Macieira - PA IMPORTA��O > Altera��o Data de Emiss�o
                /*
                dbSelectArea("SE5")
                dbSetOrder(7)
                if dbSeek( FWxFilial("SE2") + SE2->E2_PREFIXO + SE2->E2_NUM + SE2->E2_PARCELA + SE2->E2_TIPO + SE2->E2_FORNECE + SE2->E2_LOJA )
                    RecLock("SE5",.F.)
                    SE5->E5_DATA    := dDataAgend
                    SE5->E5_DTDIGIT := dDataAgend
                    SE5->E5_DTDISPO := dDataAgend
                    MsUnLock()
                */
                    ApMsgInfo('Data Alterada com Sucesso!','Altera��o Vencimento - PA SAG')
                //Endif
            EndIf
            RestArea( aArea )
        Endif
    Endif

Return(lRet)
