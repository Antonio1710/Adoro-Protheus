#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function F370E5F
    Ponto Entrada CTBAFIN para filtrar registros do SE5
    @type  Function
    @author FWNM
    @since 17/09/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history ticket 1678 - Duplicidade lote no cont�bil
    @history ticket 2144 - FWNM - 05/10/2020 - Baixas nos pagamentos n�o subiram para a contabilidade.
    @history ticket 9237 - Leonardo P. Monteiro - 09/02/2021 - Melhoria na performance e custo de execu��o da consulta SQL.
    @hisotry ticket 79041- Everson/Antonio - 29/08/2022 - Altera consulta pois estava estourando o tamanho da string do script sql, no ini do appserver j� est� no limite 65536.
/*/
User Function F370E5F()

    Local cQry      := PARAMIXB
    // Local cQuery    := ""
    // Local cFilDuplic:= ""

    // If Select("Work") > 0
    //     Work->( dbCloseArea() )
    // EndIf

    // cQry := ChangeQuery(cQry)
    // tcQuery cQry New Alias "Work"

    // Work->( dbGoTop() )
    // Do While Work->( !EOF() )

    //     // CV3
    //     If Select("WorkCV3") > 0
    //         WorkCV3->( dbCloseArea() )
    //     EndIf

    //     //Ticket 2144 - FWNM - 05/10/2020 - Baixas nos pagamentos n�o subiram para a contabilidade.
    //     //Ticket 9237 - Leonardo P. Monteiro - 09/02/2021 - Melhoria na performance e custo de execu��o da consulta SQL.
    //     cQuery := " SELECT CV3_RECDES
    //     cQuery += " FROM " + RetSqlName("CV3") + " (NOLOCK)
    //     cQuery += " WHERE CV3_FILIAL='"+ xFilial("CV3") +"' AND CV3_TABORI='SE5' " 
    //     cQuery += " AND CV3_RECORI='"+AllTrim(Str(Work->SE5RECNO))+"' "
    //     cQuery += " AND D_E_L_E_T_='' "

    //     tcQuery cQuery New Alias "WorkCV3"

    //     WorkCV3->( dbGoTop() )
    //     If WorkCV3->( !EOF() )

    //         Do While WorkCV3->( !EOF() ) // ticket 2144 - FWNM - 05/10/2020 - Baixas nos pagamentos n�o subiram para a contabilidade
            
    //             // CT2
    //             If Select("WorkCT2") > 0
    //                 WorkCT2->( dbCloseArea() )
    //             EndIf
                
    //             cQuery := " SELECT COUNT(1) TTCT2
    //             cQuery += " FROM " + RetSqlName("CT2") + " (NOLOCK)
    //             cQuery += " WHERE R_E_C_N_O_='"+AllTrim(WorkCV3->CV3_RECDES)+"' 
    //             cQuery += " AND D_E_L_E_T_=''

    //             tcQuery cQuery New Alias "WorkCT2"

    //             If WorkCT2->TTCT2 >= 1 
    //                 // Registro j� contabilizado!
    //                 cFilDuplic += AllTrim(Str(Work->SE5RECNO)) + "|"
    //             EndIf

    //             If Select("WorkCT2") > 0
    //                 WorkCT2->( dbCloseArea() )
    //             EndIf

    //             WorkCV3->( dbSkip() ) // ticket 2144 - FWNM - 05/10/2020 - Baixas nos pagamentos n�o subiram para a contabilidade

    //         EndDo

    //     EndIf

    //     If Select("WorkCV3") > 0
    //         WorkCV3->( dbCloseArea() )
    //     EndIf
    //     // 

    //     Work->( dbSkip() )

    // EndDo

    // If Select("Work") > 0
    //     Work->( dbCloseArea() )
    // EndIf

    // Retiro os registros j� contabilizados!
    // If !Empty(AllTrim(cFilDuplic))
    //     cQry := cQry + " AND SE5.R_E_C_N_O_ NOT IN " + FormatIn(cFilDuplic,"|")
    // EndIf

     cQry += " AND SE5.R_E_C_N_O_ NOT IN ( "

        cQry += " SELECT  " 
            cQry += " DISTINCT SE5.R_E_C_N_O_ " 
        cQry += " FROM  " 
            cQry += " " + RetSqlName("CV3") + "  (NOLOCK) AS CV3 " 
            cQry += " INNER JOIN " 
            cQry += " " + RetSqlName("CT2") + "  (NOLOCK) AS CT2 ON " 
            cQry += " CV3_FILIAL = CT2_FILIAL " 
            cQry += " AND CV3_RECDES = CT2.R_E_C_N_O_ " 
            cQry += " AND CT2.D_E_L_E_T_ = '' " 
            cQry += " INNER JOIN " 
            cQry += " " + RetSqlName("SE5") + " (NOLOCK) AS SE5 ON " 
            cQry += " E5_FILIAL = '" + FWxFilial("SE5") + "' " 
            cQry += " AND CV3_RECORI = SE5.R_E_C_N_O_ " 
            cQry += " AND SE5.D_E_L_E_T_ = '' " 
        cQry += " WHERE  " 
            cQry += " CV3_FILIAL='" + FWxFilial("CV3") + "'  " 
            cQry += " AND CV3_TABORI='SE5'   " 
            cQry += " AND CV3_DTSEQ >= '" + DToS(MV_PAR04) + "' " 
            cQry += " AND CV3.D_E_L_E_T_='' " 
            cQry += " AND CT2.D_E_L_E_T_ = '' " 

    cQry += " ) "

Return cQry
