#INCLUDE "TOTVS.CH"
/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP 650 001³ Autor ³Mauricio - HC Consysº Data ³ 20/08/09    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Utilizado LP 650-001 - Chamado 004807 - Rosana             º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Adoro                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
@history ticket 82245 - Antonio Domingos - 24/20/2022 -  Incluido exceção programação na função U_VL650001() 82245. Incluido exceção programação na função U_VL650001()
*/
User Function VL650001()                 

Local _nValor
Local cProduto    := GETMV("MV_#PRDCON")  //chamado 036846 - fernando sigoli //24/08/2017
//@history ticket 82245 - Antonio Domingos - 24/20/2022 -  Incluido exceção programação na função U_VL650001() 82245. Incluido exceção programação na função U_VL650001()
//Parametros com os códigos de Exceção
Local _cMV650EFL := SUPERGETMV("MV_#650EFL",.F.,"0B") //Codigo(s) da(s) Filiais de Exceção Para o LP 650-001 campo CT5_VLR01 Funcao U_VL650001() 
Local _cMV650EFN := SUPERGETMV("MV_#650EFN",.F.,"031495")  //Código(s) dos(s) Fornecedores de Exceção Para o LP 650-001 campo CT5_VLR01 Funcao U_VL650001() 
Local _cMV650ETE := SUPERGETMV("MV_#650ETE",.F.,"190/19H/19N")  //Código(s) da(s) TES de Exceção Para o LP 650-001 campo CT5_VLR01 
Local _cMV650ECF := SUPERGETMV("MV_#650ECF",.F.,"1949") //Codigo(s) do(s) CFO´S de Exceção Para o LP 650-001 campo CT5_VLR01 

U_ADINF009P('LP650' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

IF SF4->F4_XCTB             == "S"              .AND. ;
   SF4->F4_XTM               $ "E01/E04"        .AND. ;
   SD1->D1_TIPO             <> "D"              .AND. ;
   SD1->D1_RATEIO           != "1"              .AND. ;
   !Alltrim(SD1->D1_COD)    $  cProduto         .AND. ; //chamado 036846 - fernando sigoli //24/08/2017
   !ALLTRIM(SD1->D1_CF)     $ "2556/2551/1551"  .AND. ; //chamado 036846 - fernando sigoli //24/08/2017
   !(ALLTRIM(SD1->D1_SERIE) == "ST"             .OR. ;
     ALLTRIM(SD1->D1_SERIE) == "ICM"            .OR. ;
     ALLTRIM(SD1->D1_SERIE) == "PAR")           .AND. ; 
   SD1->D1_GRUPO            != "9043"
   _nValor := SD1->D1_CUSTO
Else
   _nValor := 0
Endif       
//@history ticket 82245 - Antonio Domingos - 24/20/2022 -  Incluido exceção programação na função U_VL650001() 82245. Incluido exceção programação na função U_VL650001()
//Se a NF conter as informações abaixo, não deverá constar na regra da programação:
If SD1->D1_FILIAL  $ _cMV650EFL .And.;
   SD1->D1_FORNECE $ _cMV650EFN .And. ;
   alltrim(SD1->D1_CF) $ _cMV650ECF .And.;
   SD1->D1_TES $ _cMV650ETE
   _nValor := 0
EndIf
Return(_nValor)

/*
ÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜÜ
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
±±ÉÍÍÍÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍËÍÍÍÍÍÍÑÍÍÍÍÍÍÍÍÍÍÍÍÍ»±±
±±ºPrograma  ³LP 650 114³ Autor ³Ana Helena          º Data ³ 13/06/11    º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÊÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºDesc.     ³ Utilizado LP 650-114 - Chamado 010428                      º±±
±±º          ³                                                            º±±
±±ÌÍÍÍÍÍÍÍÍÍÍØÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¹±±
±±ºUso       ³ Adoro                                                      º±±
±±ÈÍÍÍÍÍÍÍÍÍÍÏÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍÍ¼±±
±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±±
ßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßßß
*/

User Function VL650114()                 

Local _nValor     

U_ADINF009P('LP650' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
        
IF SF4->F4_XCTB             == "S"         .AND. ;
   SF4->F4_XTM               $ "E07"       .AND. ;
   SD1->D1_TIPO             <> "D"         .AND. ;
   SD1->D1_RATEIO           != "1"         .AND. ;
   !ALLTRIM(SD1->D1_CF)      $ "2556/2551" .AND. ;
   !(ALLTRIM(SD1->D1_SERIE) == "ST"         .OR. ;
     ALLTRIM(SD1->D1_SERIE) == "ICM"        .OR. ;
     ALLTRIM(SD1->D1_SERIE) == "PAR")      .AND. ;
   SD1->D1_GRUPO            == "9043"
	
		_nValor := SD1->D1_TOTAL
Else
   _nValor := 0
Endif       

Return(_nValor)
