/*/{Protheus.doc} User Function MT103TPC
  Acrescentar mais TES ao parâmetro MV_TESPCNF
  @type  Function
  @author Abel Babini
  @since 31/01/2023
  @history Interno TI - Abel Babini  - 31/03/2023 - Acrescentar mais TES ao parâmetro MV_TESPCNF
  /*/
User Function MT103TPC()
  Local cTes := PARAMIXB[1] //Relação que vem do parâmetro MV_TESPCNF
  Local cTESComp := GetMV("MV_#TSPCNF",,"") //Relação de TES para adicionar no MV_TESPCNF

  cTes := Alltrim(cTes)+'/'+Alltrim(cTESComp)

Return cTes
