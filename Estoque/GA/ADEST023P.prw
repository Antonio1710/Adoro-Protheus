#INCLUDE 'PROTHEUS.ch'
#INCLUDE 'PARMTYPE.ch'
//@history ticket TI - Antonio Domingos - 20/05/2023 - Ajuste Nova Empresa
//@history ticket TI - Antonio Domingos - 23/05/2023 - Revisão Ajuste Nova Empresa
USER FUNCTION ADEST023P()

	Local cRet
	Local _cEmpFL1 := SuperGetMv("MV_#EMPFL1",.F.,"0102/1301") //Codigos de Empresas+Filiais Ativas Grupo 1 //ticket TI - Antonio Domingos - 20/05/2023
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
	
	//cRet := IIF(CFILANT=="02",Posicione("SBE",10,xFilial("SBE")+SB1->B1_COD+IIF(!RetArqProd(SB1->B1_COD),POSICIONE("SBZ",1,xFilial("SBZ")+SB1->B1_COD,"BZ_LOCPAD"),POSICIONE("SB1",1,xFilial("SB1")+SB1->B1_COD,"B1_LOCPAD")) ,"BE_LOCALIZ"),SB1->B1_ENDALM2)  
	cRet := IIF(alltrim(cEmpAnt)+alltrim(CFILANT)$_cEmpFL1,Posicione("SBE",10,xFilial("SBE")+SB1->B1_COD+IIF(!RetArqProd(SB1->B1_COD),POSICIONE("SBZ",1,xFilial("SBZ")+SB1->B1_COD,"BZ_LOCPAD"),POSICIONE("SB1",1,xFilial("SB1")+SB1->B1_COD,"B1_LOCPAD")) ,"BE_LOCALIZ"),SB1->B1_ENDALM2)  

RETURN(cRet)
