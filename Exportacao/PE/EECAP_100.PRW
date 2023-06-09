#include "rwmake.ch"
#Include "Protheus.ch"

/*/{Protheus.doc} User Function EECAP100
	Ponto de Entrada rotina de inclus�o processo de exporta��o e confec��o do Pedido de Venda
	@type  Function
	@author  
	@since 16/10/2018
	@version 01
	@history 29/10/2018 - Chamado 044318 Fernando Sigoli - Projeto Controle de laudos
	@history 06/08/2019 - Chamado 050701 Abel Babini Filho - Corrige Local Padr�o baseado no Indicador de Produtos SC6
	@history 26/08/2019 - Chamado 051303 Abel Babini Filho - Corrige Local Padr�o baseado no Indicador de Produtos SC9
	@history 07/11/2019 - Chamado 053097 Adriana Oliveira - Corrige grava��o do campo C5_VOLUME1, considerando todos os itens do pedido                       
    @history 17/03/2021 - Chamado  11022 Leonardo P. Monteiro - Tratamento do tipo de frete na integra��o do SIGAEEC (EE7) com o m�dulo de faturamento(SC5).
    @history 25/03/2021 - Chamado   8465 Leonardo P. Monteiro - Tratamento da data de entrega do pedido de venda no m�dulo de faturamento e tipo de frete.
    @history 14/04/2021 - Chamado  12079 Leonardo P. Monteiro - Preenchimento do grupo de inspe��o como '01-Mercado Interno' quando campo est� em branco.
    @history 16/04/2021 - Chamado   8465 Leonardo P. Monteiro - Implementa��o do tratamento dos campos e gatilhos na c�pia dos pedidos de exporta��o.
    @history 22/05/2021 - Chamado   8465 Leonardo P. Monteiro - Implementa��o dos campos de container, temperatura, lacres SIF, lacres armador, e datas de produ��o.
    @history 22/05/2021 - Chamado   8465 Leonardo P. Monteiro - Altera��o na valida��o para considerar o n�mero da placa ao inv�s do roteiro.
    @history 04/06/2021 - Chamado   8465 Leonardo P. Monteiro - Corre��o do error.log na linha 85.
    @history 22/07/2021 - Chamado   8465 Leonardo P. Monteiro - Limpa os campos na c�pia do pedido de exporta��o.
    @history 17/08/2021 - Chamado  18514 Leonardo P. Monteiro - Grava��o das mensagens nos pedidos de venda.
    @history 06/01/2022 - Chamado  18301 Leonardo P. Monteiro - Grava o flag da inspe��o da Qualidade.
    @history 19/01/2022 - Chamado  18301 Leonardo P. Monteiro - Na c�pia dos pedidos de exporta��o o campo de inspe��o da qualidade vir como "2-N�o" e gravar a temperatura como '-18.0'.
    @history 29/03/2022 - Chamado  70523 Leonardo P. Monteiro - PEDIDO COM DATA DE CORREGAMENTO DIVERGENTE. Posiciona no PVs no faturamento para a correta valida��o e bloqueio dos campos habilitados para edi��o.
/*/
User Function EECAP100()

    Local cRespAux := ""
    Local EE7PESLIQ := EE7->EE7_PESLIQ
    Local EE7PESBRU := EE7->EE7_PESBRU
    Local EE8QE     := 0
    Local EE8EMBAL1 := ""
    Local EE7XGRPIN := EE7->EE7_XGRPIN
    Local cAuxFil 	:= ""
    Local cAuxPed	:= ""
    Local cLocal	:= ""
    Local dDtEntr   := Stod("")
    Local EE7XTPF   := EE7->EE7_XTPFRE
    Local EE7XETQ   := EE7->EE7_XETQUE
    
    If Type("ParamIXB") == "C"
        cRespAux := ParamIXB
    ElseIf Type("ParamIXB") == "A"
        cRespAux := ParamIXB[1] 
    Else
        cRespAux := ""
    EndIf

    IF cRespAux == 'GRV_PED'

        dbSelectArea("EE7")
        if !Empty(EE7->EE7_XWFNED)
            IF msgYesNo("Deseja reenviar o workflow de notifica��o de embarque?")
                If Reclock("EE7",.F.)
                    EE7->EE7_XWFNEE := "N"
                    MsUnLock("EE7")
                endif
            endif
        endif

        dbSelectArea("EE8")
        EE8->(dbSetOrder(1))
        if EE8->(dbSeek( FWxFilial("EE8") + EE7->EE7_PEDIDO ))

            EE8EMBAL1 := EE8->EE8_EMBAL1 

            While EE8->EE8_FILIAL = FWxFilial("EE8") .AND. EE8->EE8_PEDIDO = EE7_PEDIDO

                EE8QE     += EE8->EE8_QTDEM1

                if !Empty(EE8->EE8_DTENTR)
                    if EE8->EE8_DTENTR <= dDtEntr .or. Empty(dDtEntr)
                        dDtEntr := EE8->EE8_DTENTR
                    endif
                endif

                EE8->(DbSkip())

            Enddo    

        endif

        dbSelectArea("SC5")
        SC5->(dbSetOrder(1))
        If SC5->(dbSeek( FWxFilial("SC5") + EE7->EE7_PEDFAT ))
            IF SC5->C5_NUM == EE7->EE7_PEDFAT
                RecLock("SC5",.F.)
                    SC5->C5_PESOL   := EE7PESLIQ
                    SC5->C5_PBRUTO  := EE7PESBRU
                    SC5->C5_VOLUME1 := EE8QE
                    SC5->C5_ESPECI1 := IIF(EE8EMBAL1='BX','CAIXAS',EE8EMBAL1)
                    
                    //Ticket  12079 Leonardo P. Monteiro - Preenchimento do grupo de inspe��o como '01-Mercado Interno' quando campo est� em branco.
                    if Empty(EE7XGRPIN)
                        SC5->C5_XGRPINS := "01"
                    else
                        SC5->C5_XGRPINS := EE7XGRPIN                             //Chamado 044318
                    endif

                    SC5->C5_XETQUET := EE7XETQ
                        IF !Empty(dDtEntr)
                            SC5->C5_DTENTR  := dDtEntr
                        endif
                    if !EMPTY(EE7XTPF)
                        SC5->C5_TPFRETE := EE7XTPF
                    ENDIF
                    SC5->C5_XESPEM  := EE7->EE7_XESPEM
                    SC5->C5_CONTAIN := EE7->EE7_CONTAI
                    SC5->C5_NLACRE1 := EE7->EE7_NLACR1
                    SC5->C5_NLACRE2 := EE7->EE7_NLACR2
                    SC5->C5_TEMPERA := EE7->EE7_TEMPER
                    SC5->C5_DTPROD  := EE7->EE7_DTPROD

                    //Grava os dados da mensagem.
                    SC5->C5_MENNOTA  := EE7->EE7_MENSG
                    SC5->C5_MENNOT2  := EE7->EE7_MENSG2
                    SC5->C5_MENNOT3  := EE7->EE7_MENSG3
                    
                    // Grava o flag de inspe��o da qualidade.
                    SC5->C5_XINSQLD  := EE7->EE7_XINQLD

                MsUnlock("SC5")


                //INICIO Chamado 050701 - Abel Babini - Corrigi Local Padr�o baseado no Indicador de Produtos - 06/08/2019
                If SC6->(dbSeek( FWxFilial("SC6") + EE7->EE7_PEDFAT ))
                    cAuxFil := FWxFilial("SC6")
                    cAuxPed	:= EE7->EE7_PEDFAT
                    While !SC6->(EOF()) .AND. SC6->C6_FILIAL == cAuxFil  .AND. SC6->C6_NUM == cAuxPed
                        cLocal := IIF(!RetArqProd(SC6->C6_PRODUTO),POSICIONE("SBZ",1,xFilial("SBZ")+SC6->C6_PRODUTO,"BZ_LOCPAD"),POSICIONE("SB1",1,xFilial("SB1")+SC6->C6_PRODUTO,"B1_LOCPAD"))
                        RecLock("SC6",.F.)
                        SC6->C6_LOCAL := cLocal
                        
                        //Data 25/03/2021 - Chamado   8465 Leonardo P. Monteiro - Tratamento da data de entrega do pedido de venda no m�dulo de faturamento e tipo de frete.
                        //if Empty(SC5->C5_PLACA).AND. Empty(SC5->C5_X_SQED)
                            if !Empty(dDtEntr)
                                SC6->C6_ENTREG := dDtEntr
                            endif
                        //endif

                        SC6->(MsUnlock())
                        SC6->(DbSkip())
                    Enddo
                Endif
                //FIM Chamado 050701 - Abel Babini - Corrigi Local Padr�o baseado no Indicador de Produtos - 06/08/2019
                //INICIO Chamado 051303 - Abel Babini - Corrigir Local Padr�o baseado no Indicador de Produtos SC9 - 26/08/2019
                If SC9->(dbSeek( FWxFilial("SC9") + EE7->EE7_PEDFAT ))
                    cAuxFil := FWxFilial("SC9")
                    cAuxPed	:= EE7->EE7_PEDFAT
                    While !SC9->(EOF()) .AND. SC9->C9_FILIAL == cAuxFil  .AND. SC9->C9_PEDIDO == cAuxPed
                        
                        if Empty(SC9->C9_NFISCAL)
                            cLocal := IIF(!RetArqProd(SC9->C9_PRODUTO),POSICIONE("SBZ",1,xFilial("SBZ")+SC9->C9_PRODUTO,"BZ_LOCPAD"),POSICIONE("SB1",1,xFilial("SB1")+SC9->C9_PRODUTO,"B1_LOCPAD"))
                            
                            RecLock("SC9",.F.)
                                SC9->C9_LOCAL   := cLocal
                                // @history 22/05/2021 - Chamado   8465 Leonardo P. Monteiro - Implementa��o dos campos de container, temperatura, lacres SIF, lacres armador, e datas de produ��o.
                                //if Empty(SC5->C5_PLACA).AND. Empty(SC5->C5_X_SQED)
                                    SC9->C9_DATENT	:= dDtentr
                                //endif
                            SC9->(MsUnlock())
                        endif
                        
                        SC9->(DbSkip())
                    Enddo
                Endif
                //FIM Chamado 051303 - Abel Babini - Corrigir Local Padr�o baseado no Indicador de Produtos SC9 - 26/08/2019
            else
                    msginfo("Pedido de venda n�o atualizado!")
            endif
        EndIf
    // Preenchimento dos campos na c�pia dos processos de exporta��o.
    ELSEIF cRespAux == 'PE_COPYPED'    
        // Limpa os campos quando � feita a c�pia dos pedidos de exporta��o. 
        M->EE7_XWFEMD   := Stod("")
        M->EE7_XWFNED   := Stod("")
        M->EE7_XWFEMH   := ""
        M->EE7_XWFNEE   := "N"
        M->EE7_XMODCS   := Criavar("EE7_XMODCS")
        M->EE7_XINQLD   := "2"
        M->EE7_TEMPER   := "-18.0"
        RunTrigger(1,nil,nil,,'EE7_VIA')
        RunTrigger(1,nil,nil,,'EE7_PAISET')
    EndIf

Return
