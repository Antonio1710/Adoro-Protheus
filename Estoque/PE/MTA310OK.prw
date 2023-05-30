#include "protheus.ch"

/*/{Protheus.M310FILIAL()
    LOCALIZA��O: Ponto de entrada localizado na fun��o "A310ValOK()" da rotina de transfer�ncia entre filiais. Esta fun��o � a respons�vel por realizar as valida��es do bot�o "OK" da janela principal da rotina.EM QUE PONTO: Ser� executado antes que sejam obtidos
    Para as notas fiscais de transfer�ncia da filial 03 para as matrizes (filiais 0C a 0S) ser obrigat�rio o preenchimento do lote recria e do centro de custo;
    Criar lan�amento padr�o para que o custo das notas sejam contabilizadas com conta, centro de custo, item e lote;
    Sobre o valor dos itens na Nota Fiscal, � poss�vel que o sistema j� sugerir o valor de acordo com a ultima SB9 conhecida?
    @type  
    @author Fernando Macieira
    @since 29/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @ticket 90838 - 29/03/2023 - Fernando Macieira - TRANSFERENCIA DE ITENS DE ALMOXARIFADO - MATRIZES
/*/
User Function MTA310OK()

    Local lOk := .t.
    Local cGranjas := GetMV("MV_#GRANJS",,"0C|0D|0E|0F|0G|0H|0I|0J|0K|0L|0M|0N|0O|0P|0Q|0R|0S")

    Public _lMatrizes_ := .f. // Vari�vel ser� utilizada no PE M310ITENS

    If Len(ParamIXB) > 0
        If AllTrim(ParamIXB[1,1,1]) == "03" .and. AllTrim(ParamIXB[1,1,6]) $ cGranjas
            _lMatrizes_ := .T.
        EndIf
    EndIf
    
Return lOk
