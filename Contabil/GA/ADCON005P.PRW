#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"  
#INCLUDE "AP5MAIL.CH"                                   

//ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
//±±ºPrograma  ³ADCON005P ºAutor  ³WILLIAM COSTA       º Data ³  17/10/2016 º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºDesc.     ³Programa de ITEM CONTABIL PARA GUARDAR A FORMULA CORRETA    º±±
//±±º          ³                                                            º±±
//±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
//±±ºUso       ³ SIGACTB                                                    º±±
//±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
//±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
//ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
//@history ticket TI - Antonio Domingos - 19/05/2023 - Ajuste Nova Empresa
//@history ticket TI - Antonio Domingos - 23/05/2023 - Revisão Ajuste Nova Empresa

USER FUNCTION ADCON005P()

	Private cItemctb := ''
	Private _cEmpFL1 := SuperGetMv("MV_#EMPFL1",.F.,"0102/1301") //Codigos de Empresas+Filiais Ativas Grupo 1 //ticket TI - Antonio Domingos - 19/05/2023
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	//cItemctb := IIF(AllTrim(SM0->M0_CODIGO) == "01"  .AND. AllTrim(SM0->M0_CODFIL) == "02", "121",IIF(AllTrim(SM0->M0_CODIGO) == "02","121",IIF(SEF->EF_FILIAL$"03/05","114",IIF(SEF->EF_FILIAL=="06","122",IIF(SEF->EF_FILIAL=="07","123",IIF(SEF->EF_FILIAL=="08","115",IIF(SEF->EF_FILIAL=="09","116",112))))))) // @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabilização pos golive migração dicionário dados
	cItemctb := IIF(AllTrim(SM0->M0_CODIGO)+AllTrim(SM0->M0_CODFIL) $ _cEmpFL1, "121",IIF(AllTrim(SM0->M0_CODIGO) == "02","121",IIF(SEF->EF_FILIAL$"03/05","114",IIF(SEF->EF_FILIAL=="06","122",IIF(SEF->EF_FILIAL=="07","123",IIF(SEF->EF_FILIAL=="08","115",IIF(SEF->EF_FILIAL=="09","116",112))))))) // @history Ticket TI - 28/02/2023 - Fernando Macieira - Ajustes estabilização pos golive migração dicionário dados

RETURN(cItemctb)
