#include "protheus.ch"
#include "topconn.ch"

/*/{Protheus.doc} User Function LPCTH
    Função utilizada na CT5, campos de classe de valor

    Regra: 
    Se estiver:
•	Entre as contas 131210001 e 131220009 e o centro de custo for diferente de 9000 a 9998, utilizar classe de valor 999999997;
•	Entre as contas 131240001 e 131250003 e o centro de custo for diferente de 9000 a 9998, utilizar classe de valor 999999997;
•	Entre as contas 131270001 e 131270003 e o centro de custo for diferente de 9000 a 9998, utilizar classe de valor 999999997.
*** centro de custo da nota fiscal.

    @type  Function
    @author FWNM
    @since 14/02/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @chamado 055749 || OS 057158 || CONTROLADORIA || ANDRE || 8386 || CLASSE DE VALOR SIG
    @Ticket 69338 	- Leonardo P. Monteiro - 	Ajuste no CC para 5131 quando o produto for '190590'. Alterar LanÇamento PadrÃo 641-008 - Quirera.
    @history ticket 76679 - 18/07/2022 - Fernando Macieira - alteração LP 641-007 DEVOLUCAO DE VENDAS EMBUTIDOS - SALSICHA
    @history ticket 76679 - 19/07/2022 - Fernando Macieira - alteração LP 641-007 DEVOLUCAO DE VENDAS EMBUTIDOS - SALSICHA - Desabilitar
    @history ticket 83982 - 30/11/2022 - Antonio Domingos  - incluido "E FILIAL DA NOTA FOR DIFERENTE DE "0B"-ITAPIRA" - Regra de centro de custo
    @history Ticket 85817 - Abel Babini       - 09/01/2023 - Ajuste campo N1_PROJETO para N1_XPROJET
    @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabilização pos golive migração dicionário dados
    @history ticket 91913 - 26/04/2023 - Antonio Domingos - Alteração LPs 660-000 - 650-001 - 650-006 - 650-007 // Empresa Adoro
    @history Ticket 93089 - 03/05/2023 - Fernando Macieira - Alterar LP 650-01 - Item contábil filiais novas
/*/
User Function LPCTH(cTab, cEntidade)

    Local cClasse := ""
    Local cCCusto := ""
    Local aAreaAtu := GetArea()
    Local aAreaSD2 := SD2->( GetArea() )
    Local aAreaSCP := SCP->( GetArea() )
    Local aAreaSN1 := SN1->( GetArea() )

    Default cTab := cEntidade := ""

    // Define evento/tabela/lp para buscar dados condicionais
    If AllTrim(cTab) == "SD1" // LPs 640, 641, 650 e 655 (COMPRAS E DEV COMPRAS)
        cClasse := SD1->D1_PROJETO
        cCCusto := AllTrim(SD1->D1_CC)
    ElseIf AllTrim(cTab) == "SDE" // LP 651 (RATEIO CC)
        cClasse := SDE->DE_CLVL
        cCCusto := AllTrim(SDE->DE_CC)

    ElseIf AllTrim(cTab) == "SD3" // LPs 666 e 668 (SOLICITACAO ARMAZEM)
        cClasse := Posicione("SCP",1,SD3->(D3_FILIAL+D3_NUMSA+D3_ITEMSA),"CP_CONPRJ")
        
        If AllTrim(cEntidade) == "DEBITO"
            cCCusto := AllTrim(CTK->CTK_CCD)
        ElseIf AllTrim(cEntidade) == "CREDITO"
            cCCusto := AllTrim(CTK->CTK_CCC)
        EndIf

    ElseIf AllTrim(cTab) == "SN1" // LP 812 BAIXA ADIANTAMENTOS PROJETOS
        //Ticket 85817 - Abel Babini       - 09/01/2023 - Ajuste campo N1_PROJETO para N1_XPROJET
        cClasse := SN1->N1_XPROJET
        If Empty(cClasse)
            // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM+D1_COD                                                                                                     
            SD1->(dbOrderNickName("D1INTERFAC"))
            If SD1->( dbSeek(SN1->(N1_FILIAL+N1_NFISCAL+N1_NSERIE+N1_FORNEC+N1_LOJA+N1_NFITEM)) )
                cClasse := SD1->D1_PROJETO
            EndIf
        EndIf

        // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM+D1_COD                                                                                                     
        SD1->(dbOrderNickName("D1INTERFAC"))
        If SD1->( dbSeek(SN1->(N1_FILIAL+N1_NFISCAL+N1_NSERIE+N1_FORNEC+N1_LOJA+N1_NFITEM)) )
            cCCusto := SD1->D1_CC
        EndIf

        If Empty(cCCusto)
            If AllTrim(cEntidade) == "DEBITO"
                cCCusto := AllTrim(CTK->CTK_CCD)
            ElseIf AllTrim(cEntidade) == "CREDITO"
                cCCusto := AllTrim(CTK->CTK_CCC)
            EndIf
        EndIf

    EndIf

    // Define classe de valor da excecao
    If AllTrim(cCCusto) < '9000' .or. AllTrim(cCCusto) > '9998'
    
        // LPs Debito
        If AllTrim(cEntidade) == "DEBITO"

            If (AllTrim(CTK->CTK_DEBITO) >= '131210001' .and. AllTrim(CTK->CTK_DEBITO) <= '131220009') .or.;
               (AllTrim(CTK->CTK_DEBITO) >= '131240001' .and. AllTrim(CTK->CTK_DEBITO) <= '131250003') .or.;
               (AllTrim(CTK->CTK_DEBITO) >= '131270001' .and. AllTrim(CTK->CTK_DEBITO) <= '131270003')
                cClasse := "999999997"
            EndIf

        // LPs Credito
        ElseIf AllTrim(cEntidade) == "CREDITO"

            If (AllTrim(CTK->CTK_CREDIT) >= '131210001' .and. AllTrim(CTK->CTK_CREDIT) <= '131220009') .or.;
               (AllTrim(CTK->CTK_CREDIT) >= '131240001' .and. AllTrim(CTK->CTK_CREDIT) <= '131250003') .or.;
               (AllTrim(CTK->CTK_CREDIT) >= '131270001' .and. AllTrim(CTK->CTK_CREDIT) <= '131270003')
                cClasse := "999999997"
            EndIf
        
        EndIf

    EndIf

    RestArea( aAreaAtu )
    RestArea( aAreaSD2 )
    RestArea( aAreaSCP )
    RestArea( aAreaSN1 )
    
Return cClasse

/*/{Protheus.doc} User Function LPCTHCC
    Função utilizada na CT5, campos de CCustos, atrelados a classe de valor

    Regra: 
    Se estiver:
•	Entre as contas 131210001 e 131220009 e o centro de custo for diferente de 9000 a 9998, utilizar classe de valor 999999997;
•	Entre as contas 131240001 e 131250003 e o centro de custo for diferente de 9000 a 9998, utilizar classe de valor 999999997;
•	Entre as contas 131270001 e 131270003 e o centro de custo for diferente de 9000 a 9998, utilizar classe de valor 999999997.
*** centro de custo da nota fiscal.

    @type  Function
    @author FWNM
    @since 23/03/2020
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @chamado 055749 || OS 057158 || CONTROLADORIA || ANDRE || 8386 || CLASSE DE VALOR SIG
    @history Ticket 69338 	- Leonardo P. Monteiro - 	Ajuste no CC para 5131 quando o produto for '190590'. Alterar Lançamento Padrão 641-008 - Quirera.
    @history ticket 76679 - 18/07/2022 - Fernando Macieira - alteração LP 641-007 DEVOLUCAO DE VENDAS EMBUTIDOS - SALSICHA
    @history Ticket 80109 - Abel Babini - 19/09/2022 - LP de Devolução venda - EMPRESAS CERES
    @history Ticket 80487 - Antonio Domingos - 03/10/2022 - Regra de contabilização centro de custo
/*/
User Function LPCTHCC(cTab, cEntidade)

    Local cCCusto := ""
    Local cConta  := ""
    Local aAreaAtu := GetArea()
    Local aAreaSD2 := SD2->( GetArea() )
    Local aAreaSCP := SCP->( GetArea() )
    Local aAreaSN1 := SN1->( GetArea() )
    Local cCodClFr := GetMV("MV_#LPNFDV",,"")

    Default cTab := cEntidade := ""

    If AllTrim(cEntidade) == "DEBITO"
        cConta := CTK->CTK_DEBITO
    ElseIf AllTrim(cEntidade) == "CREDITO"
        cConta := CTK->CTK_CREDIT
    EndIf

    If Left(AllTrim(cConta),1) $ "3|4" .or. (;
        (AllTrim(cConta) >= '131210001' .and. AllTrim(cConta) <= '131220009') .or.;
        (AllTrim(cConta) >= '131240001' .and. AllTrim(cConta) <= '131250003') .or.;
        (AllTrim(cConta) >= '131270001' .and. AllTrim(cConta) <= '131270003') )

        // Define evento/tabela/lp para buscar dados condicionais
        If AllTrim(cTab) == "SD1" // LPs 640, 641, 650 e 655 (COMPRAS E DEV COMPRAS)
            cCCusto := AllTrim(SD1->D1_CC)

            If Empty(cCCusto) .and. AllTrim(SD1->D1_TIPO) == "D"
                // SD2 - ORDER 3 = D2_FILIAL+D2_DOC+D2_SERIE+D2_CLIENTE+D2_LOJA+D2_COD+D2_ITEM                                                                                                     
                cCCusto := Posicione("SD2",3,SD1->(D1_FILIAL+D1_NFORI+D1_SERIORI+D1_FORNECE+D1_LOJA+D1_COD+D1_ITEMORI),"D2_CCUSTO")
            elseif AllTrim(cEntidade) == "CREDITO"
                //@history Ticket 69338	- Leonardo P. Monteiro - 	Ajuste no CC para 5131 quando o produto for '190590'. Alterar Lançamento Padrão 641-008 - Quirera.
                //@history Ticket 73213	- Antonio Domingos - Ajuste no CC para 5131 quando o produto for '190590' e Filial 03/05. Alterar Lançamento Padrão 641-008 - Quirera.
                if Alltrim(SD1->D1_COD) == "190590" .And. SD1->D1_FILIAL $ "03/05"
                    cCCusto := "5131"
                endif
            EndIf

            // @history ticket 76679 - 19/07/2022 - Fernando Macieira - alteração LP 641-007 DEVOLUCAO DE VENDAS EMBUTIDOS - SALSICHA - Desabilitar
            // @history ticket 76679 - 18/07/2022 - Fernando Macieira - alteração LP 641-007 DEVOLUCAO DE VENDAS EMBUTIDOS - SALSICHA
            /*
            Se CFOP igual a 1410 ou 1201: 6120
            Se CFOP igual a 2410 ou 2201: 6220
            */
            /*
            If AllTrim(SD1->D1_CF) == "1410" .or. AllTrim(SD1->D1_CF) == "1201"
                cCCusto := "6120"
            ElseIf AllTrim(SD1->D1_CF) == "2410" .or. AllTrim(SD1->D1_CF) == "2201"
                cCCusto := "6220"
            EndIf
            */
            //

            //ticket 80450 - Antonio Domingos - 22/09/2022 - Inclusao de regra programas U_LP610CC(), U_610002() , U_LPCTHCC
            //IIF(FINDFUNCTION("U_LPCTHCC"),U_LPCTHCC("SD1","DEBITO"),"") 
            If alltrim(SD1->D1_FILIAL)== '0B' .AND. AllTrim(cTab) == "SD1" .AND. AllTrim(SD1->D1_TIPO) == "D"
                //Se a D1_FILIAL for 0B E  D1_CF  = 1202 e D1_GRUPO diferente de 0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314, 
                //então Centro custo 6111
                If ALLTRIM(SD1->D1_CF) == '1202' .AND. !(SD1->D1_GRUPO $ '0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314')
                    cCCusto := '6111'
                //Se a D1_FILIAL for 0B E  D1_CF  = 2202 e D1_GRUPO diferente de 0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314, 
                //então Centro custo 6211
                ElseIf ALLTRIM(SD1->D1_CF) == '2202' .AND. !(SD1->D1_GRUPO $ '0542/0511/0541/0213/0312/0313/0318/0317/0319/0454/0314')
                    cCCusto := '6211'
                //Se a D1_FILIAL for 0B E  D1_CF  = 1202/1411 e D1_GRUPO igual  542/0511/0541, então Centro custo 6121
                ElseIf ALLTRIM(SD1->D1_CF) $ '1202/1411' .AND. SD1->D1_GRUPO $ '542/0511/0541'
                    cCCusto := '6121'
                //Se a D1_FILIAL for 0B E  D1_CF  = 2202/2411 e D1_GRUPO igual  542/0511/0541, então Centro custo 6221
                ElseIf ALLTRIM(SD1->D1_CF) $ '2202/2411' .AND. SD1->D1_GRUPO $ '542/0511/0541'
                    cCCusto := '6221'
                //Se a D1_FILIAL for 0B E  D1_CF  = 1202 e D1_GRUPO igual 0213/0312/0313/0318/0317/0319/0454/0314, então Centro custo 6191
                ElseIf ALLTRIM(SD1->D1_CF) == '1202' .AND. SD1->D1_GRUPO $ '0213/0312/0313/0318/0317/0319/0454/0314'
                    cCCusto := '6191'
                //Se a D1_FILIAL for 0B E  D1_CF  = 2202 e D1_GRUPO igual 0213/0312/0313/0318/0317/0319/0454/0314, então Centro custo 6291
                ElseIf ALLTRIM(SD1->D1_CF) == '2202' .AND. SD1->D1_GRUPO $ '0213/0312/0313/0318/0317/0319/0454/0314'
                    cCCusto := '6291'
                EndIf
            EndIf

        ElseIf AllTrim(cTab) == "SDE" // LP 651 (RATEIO CC)
            cCCusto := AllTrim(SDE->DE_CC)

        /*
        ElseIf AllTrim(cTab) == "SD3" // LPs 666 e 668 (SOLICITACAO ARMAZEM)
            If !Empty(SD3->D3_CC)
                cCCusto := SD3->D3_CC
            Else
                cCCusto := Posicione("SCP",1,SD3->(D3_FILIAL+D3_NUMSA+D3_ITEMSA),"CP_CC")
            EndIf
        */

        ElseIf AllTrim(cTab) == "SN1" // LP 812 BAIXA ADIANTAMENTOS PROJETOS
            If !Empty(SN3->N3_CCUSTO)
                cCCusto := SN3->N3_CCUSTO
            Else
                If !Empty(SN3->N3_CUSTBEM)   
                    cCCusto := SN3->N3_CUSTBEM
                Else
                    // D1_FILIAL+D1_DOC+D1_SERIE+D1_FORNECE+D1_LOJA+D1_ITEM+D1_COD                                                                                                     
                    SD1->(dbOrderNickName("D1INTERFAC"))
                    If SD1->( dbSeek(SN1->(N1_FILIAL+N1_NFISCAL+N1_NSERIE+N1_FORNEC+N1_LOJA+N1_NFITEM)) )
                        cCCusto := AllTrim(SD1->D1_CC)
                    EndIf
                EndIf
            EndIf
        EndIf
    EndIf

    //Ticket 80109 - Abel Babini - 19/09/2022 - LP de Devolução venda - EMPRESAS CERES
    If Alltrim(cEmpAnt)=='02' .AND. AllTrim(cEntidade) == "DEBITO" .AND. AllTrim(cTab) == "SD1"
        IF SD1->D1_TIPO == 'D' .AND. SD1->D1_FORNECE $ Alltrim(cCodClFr)
            cConta := '311220007'
        ENDIF
    ElseIf Alltrim(cEmpAnt)=='02' .AND. AllTrim(cEntidade) == "CREDITO" .AND. AllTrim(cTab) == "SD1"
        IF SD1->D1_TIPO == 'D' .AND. SD1->D1_FORNECE $ Alltrim(cCodClFr)
            cConta := '111210006'
        ENDIF
    Endif
    //Ticket 80487 - Antonio Domingos - 03/10/2022
    If Left(AllTrim(cConta),1) $ "3|4" .or. (;
            (AllTrim(cConta) >= '131210001' .and. AllTrim(cConta) <= '131220009') .or.;
            (AllTrim(cConta) >= '131240001' .and. AllTrim(cConta) <= '131250003') .or.;
            (AllTrim(cConta) >= '131270001' .and. AllTrim(cConta) <= '131270003') )
            //*** Incluiddo regra referente Ticket 83982 - Antonio Domingos - 30/11/2022
            //*** Somente mudar o Centro de Custo quando a Filial da Nota for diferente de "0B"-ITAPIRA
            If AllTrim(SM0->M0_CODIGO) == "01" .AND. AllTrim(SM0->M0_CODFIL) != "03"  .AND. SF1->F1_FILIAL != "0B" //*** SE EMPRESA 01 – MATRIZ e FILIAL DIFERENTE DA FILIAL 03-SÃO CARLOS // @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabilização pos golive migração dicionário dados
                IF SF1->F1_EST == SM0->M0_ESTENT //*** SE ESTADO DO CLIENTE DA NOTA FOR IGUAL AO ESTADO DA EMPRESA EM USO
                    If SD1->D1_TIPO = 'D' .AND. SD1->D1_GRUPO $ "0541/0542/0543/0511/0512/0513/0514/0515/0516"
                        cCCusto := '6120'
                    EndIf
                EndIf
            EndIf
    EndIf
    
    RestArea( aAreaAtu )
    RestArea( aAreaSD2 )
    RestArea( aAreaSCP )
    RestArea( aAreaSN1 )

Return cCCusto

/*/{Protheus.doc} User Function LPCTHIC
    Função utilizada na CT5, campos de Item Contabil
    @type  Function
    @author Antonio Domingos
    @since 03/10/2022
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    @history Ticket 80883 - Antonio Domingos - 03/10/2022 - Alteração de LPs - Item contábil / Adoro
    @history ticket 91913 - 26/04/2023 - Antonio Domingos - Alteração LPs 660-000 - 650-001 - 650-006 - 650-007 // Empresa Adoro
/*/
User Function LPCTHIC(cTab, cEntidade)

    Local cItemConta := SD1->D1_ITEMCTA
    //Local _cPIt125   := SuperGetMv("MV_#PIT125",.F.,"856470/856472")
    Local cGranjas   := GetMV("MV_#GRANJS",,"0C|0D|0E|0F|0G|0H|0I|0J|0K|0L|0M|0N|0O|0P|0Q|0R|0S") // @history Ticket 93089 - 03/05/2023 - Fernando Macieira - Alterar LP 650-01 - Item contábil filiais novas

    //640-001, 640-002
    //ANTES
    //IIF(SD1->D1_FILIAL$"01/02",121,IIF(SD1->D1_FILIAL$"03/05",114,IIF(SD1->D1_FILIAL=="06",122,IIF(SD1->D1_FILIAL=="07",123,IIF(SD1->D1_FILIAL=="08",115,IIF(SD1->D1_FILIAL=="09",116,IIF(SD1->D1_FILIAL=="0B",125,122)))))))                                 
    //DEPOIS
    If cTab == "SD1"
        
        // @history Ticket 93089 - 03/05/2023 - Fernando Macieira - Alterar LP 650-01 - Item contábil filiais novas

        /*
        cItemConta := SD1->D1_ITEMCTA
        If alltrim(cEntidade) $ "DEBITO/CREDITO"
            cItemConta := IIF(alltrim(SD1->D1_COD)=='300042','113',IIF(SD1->D1_FILIAL$"01/02",121,IIF(SD1->D1_FILIAL$"03/05",114,IIF(SD1->D1_FILIAL=="06",122,IIF(SD1->D1_FILIAL=="07",123,IIF(SD1->D1_FILIAL=="08",115,IIF(SD1->D1_FILIAL=="09",116,IIF(SD1->D1_FILIAL=="0B",125,122))))))))                                 
        EndIf
        //ticket 91913 - 26/04/2023 - Antonio Domingos
        //Criar uma regra que quando tiver os produtos 856470 e 856472 sejam contabilizados no item 125, independente da filial da nota.
        If alltrim(cEntidade) $ "DEBITO"
            If ALLTRIM(SD1->D1_COD) $ _cPIt125
                cItemConta := "125"
            EndIf
        EndIf
        */


        If AllTrim(SD1->D1_FILIAL)$"01/02"
            cItemConta := "121"
        
        ElseIf AllTrim(SD1->D1_FILIAL)$"03/05"
            cItemConta := "114"

            // Exceções da 03
            If AllTrim(SD1->D1_FILIAL) == "03

                If AllTrim(SD1->D1_CC) == "5318"
                    cItemConta := "111"
                EndIf

                If AllTrim(SD1->D1_CC) == "5134"
                    cItemConta := "113"
                EndIf

                If AllTrim(SD1->D1_CC) == "5908"
                    cItemConta := "112"
                EndIf

                If AllTrim(SD1->D1_CC) == "5121"
                    cItemConta := "112"
                EndIf

                If AllTrim(SD1->D1_CC) == "5131" 
                    cItemConta := "113"
                EndIf

                If Left(AllTrim(SD1->D1_CC),1) == "7"
                    cItemConta := "111"
                EndIf

                If Left(AllTrim(SD1->D1_CC),2) == "97"
                    cItemConta := "111"
                EndIf

            EndIf
            
        ElseIf AllTrim(SD1->D1_FILIAL)=="04"
                cItemConta := "112"
        
        ElseIf AllTrim(SD1->D1_FILIAL)=="06"
            cItemConta := "122"
            
        ElseIf AllTrim(SD1->D1_FILIAL)=="07"
            cItemConta := "123"
            
        ElseIf AllTrim(SD1->D1_FILIAL)=="08"
            cItemConta := "115" 
            
        ElseIf AllTrim(SD1->D1_FILIAL)=="09"
            cItemConta := "116"
            
        ElseIf AllTrim(SD1->D1_FILIAL)=="0A"
            cItemConta := "114"
            If AllTrim(SD1->D1_CC) == "5134" // Exceção da 0A
                cItemConta := "113"
            EndIf

        ElseIf AllTrim(SD1->D1_FILIAL)=="0B"
            cItemConta := "125"
            
        Else
            cItemConta := "122"

        EndIf

        // Granjas de 0C até 0S
        If AllTrim(SD1->D1_FILIAL) $ AllTrim(cGranjas)
            cItemConta := "111"
        EndIf

        // Produtos - sobressair das regras acima
        IF alltrim(SD1->D1_COD)=='300042'
            cItemConta := '113'
        ElseIf alltrim(SD1->D1_COD)=='856470'
            cItemConta := '125'
        ElseIf alltrim(SD1->D1_COD)=='856472'
            cItemConta := '125'
        EndIf

    EndIf

Return cItemConta



