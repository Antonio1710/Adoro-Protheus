#Include "RwMake.ch"
#Include 'Protheus.ch'

/*/{Protheus.doc} User Function FA040DEL
	Exclui divergencia da central de aprovacao quando o titulo com bloqueio for excluido
	@type  Function
	@author Ricardo Lima
	@since 28/03/2018
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@chamado 038609
    @history Chamado 053347 - FWNM         - 29/11/2019 - 053347 || OS 054719 || FINANCAS || EDUARDO || 8352 || IMPLANTAR CENTRAL
    @history ticket 88193   - Rodrigo Mello | Flek Solutions - 11/05/2023 - Projeto Nexxera Instrucoes de cobranca
/*/
User Function Fa040DEL

    Local _aArea    := GetArea()

    //if cEmpAnt = '01' .or. cEmpAnt = '02' // Chamado n. 053347 || OS 054719 || FINANCAS || EDUARDO || 8352 || IMPLANTAR CENTRAL - FWNM - 02/12/2019 
    DbSelectArea("ZC7")
    DbSetOrder(2)  // ZC7_FILIAL, ZC7_CLIFOR, ZC7_LOJA, ZC7_PREFIX, ZC7_NUM, ZC7_PARCEL, ZC7_TIPO
    If DbSeek( xFilial("ZC7") + M->E1_CLIENTE + M->E1_LOJA + M->E1_PREFIXO + M->E1_NUM + M->E1_PARCELA + M->E1_TIPO )
        If RecLock("ZC7",.f.)
            ZC7->(dbDelete())
            ZC7->(MsUnlock())
        Endif
    Endif
    //endif
    
    // @history ticket 88193   - Rodrigo Mello | Flek Solutions - 11/05/2023 - Projeto Nexxera Instrucoes de cobranca
    If (SE1->E1_TIPO $ MVABATIM ) 
        cTitPai := SE1->E1_TITPAI
        if SE1->(dbSeek(cTitPai)) .and. !empty(SE1->E1_IDCNAB) .AND. !empty(SE1->E1_PORTADO)
			u_ADFIN136P(/*lDelFI2*/, .T. /*lBaixa*/, .T. /*lDesconto*/)
		endif
    endif

    RestArea(_aArea)

Return
