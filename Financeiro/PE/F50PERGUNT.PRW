#Include "RwMake.ch"

// ##############################################################################################
// Projeto: Projeto Financas
// Modulo : SIGAFIN
// Fonte  : F50PERGUNT
// ---------+-------------------+------------------------------------------------+---------------
// Data     | Autor             | Descricao                                      | Chamado
// ---------+-------------------+------------------------------------------------+---------------
// 12/03/18 | Ricardo Lima      | Integração no Financeiro de PA Gerada pelo SAG | 
// ---------+-------------------+------------------------------------------------+---------------
// ##############################################################################################
//@history ticket TI - Antonio Domingos - 23/05/2023 - Ajuste Nova Empresa
//@history ticket TI - Antonio Domingos - 30/05/2023 - Ajuste Nova Empresa...
User Function F50PERGUNT

Local cOpc := SuperGetMv( "MV_#F50PER" , .F. , 1  ,  )
Private _cEmpAt2 := SuperGetMv("MV_#EMPAT2",.F.,"01/02/13") //Codigo de Empresas Ativas Grupo 2 //ticket TI - Antonio Domingos - 23/05/2023

    //If CEMPANT $ "01|02"
    //ticket TI - Antonio Domingos - 30/05/2023 - Ajuste Nova Empresa
    If alltrim(CEMPANT) $ _cEmpAt2 //ticket TI - Antonio Domingos - 23/05/2023 
        if cOpc = 1
            MV_PAR05 := 2 // Gera Chq. para Adiantamento == Nao
            MV_PAR09 := 1 // Gera movimento sem cheque   == Sim	
        else
            MV_PAR05 := 2 // Gera Chq. para Adiantamento == Nao
            MV_PAR09 := 2 // Gera movimento sem cheque   == Nao
        endif
    Endif

Return
