#INCLUDE "TOTVS.CH"
/*/{Protheus.doc} SD1100I
    Ponto de Entrada do Item da Nota para regra de atualização de centro de custo no Ativo Fixo
    @type  Function
    @author Antonio Domingos
    @since 11/04/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history ticket 91381 - Antonio Domingos - 11/04/2023 - Alteração de regra do campo centro de custo - Módulo do Ativo
    /*/
User Function SD1100I() 	

Local _cAtuAtf := Posicione("SF4",1,xFilial("SF4")+SD1->D1_TES,"F4_ATUATF")

//Executa atualização somente para Notas tipo N-Normal e que geram Ativo Fixo pelo TES.
If _cAtuAtf == "S" .And. SD1->D1_TIPO = 'N'
    U_ADATF003P(SD1->D1_FILIAL,SD1->D1_FORNECE,SD1->D1_LOJA,SF1->F1_ESPECIE,SD1->D1_DOC,SD1->D1_SERIE,SD1->D1_ITEM,SD1->D1_TES)
EndIf

Return Nil
