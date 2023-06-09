/*/{Protheus.doc} User Function MT103TPC
  Acrescentar mais TES ao par�metro MV_TESPCNF
  @type  Function
  @author Abel Babini
  @since 31/01/2023
  @history Interno TI - Abel Babini  - 31/03/2023 - Acrescentar mais TES ao par�metro MV_TESPCNF
  /*/
User Function MT103TPC()
  Local cTes := PARAMIXB[1] //Rela��o que vem do par�metro MV_TESPCNF
  Local cTESComp := GetMV("MV_#TSPCNF",,"") //Rela��o de TES para adicionar no MV_TESPCNF

  cTes := Alltrim(cTes)+'/'+Alltrim(cTESComp)

Return cTes
