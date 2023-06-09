#INCLUDE "PROTHEUS.CH"

/*/{Protheus.doc} User Function ADFIN088R
  Relat�rio de Pedidos de Venda Liberados
  @type  Function
  @author Abel Babini
  @since 26/05/2020
  @version 1
  @history Chamado 057841 - Abel Babini - 26/05/2020 - Re. Pedidos Liberados, Vers�o inicial
  @history Chamado 059049 - Eveson - 18/06/2020. Removido (cQuery1)-> para carregar o valor da vari�vel, pois n�o existe o campo NTTACUM 
  no retorno da consulta.
  @history Ticket 1562    - Abel Babini - 26/04/2022 - Relat�rio de Pedidos liberados deve trazer todos os pedidos.
  @history Ticket 1562    - Abel Babini - 31/05/2022 - Ajustes no relat�rio
  /*/
User Function ADFIN088R()
	Local aArea		:= GetArea()
	Local aPergs	:= {}
  Local aRet    := {}

  aAdd( aPergs ,{1,"Data Entrega De "     ,Ctod(space(8)),"" ,'.T.',,'.T.',80,.T.})
	aAdd( aPergs ,{1,"Data Entrega At�"     ,Ctod(space(8)),"" ,'.T.',,'.T.',80,.T.})
	aAdd( aPergs ,{6,"Local de Grava��o"    ,Space(50),"","","",80,.T.,"Todos os arquivos (*.*) |*.*","C:\TEMP\",GETF_RETDIRECTORY + GETF_LOCALHARD + GETF_NETWORKDRIVE})
	aAdd( aPergs ,{1,"Pedido de"            ,Space(TAMSX3("C5_NUM")[1]),"" ,'.T.',"SC5",'.T.',80,.F.})//Ticket 1562    - Abel Babini - 31/05/2022 - Ajustes no relat�rio
	aAdd( aPergs ,{1,"Pedido Ate"           ,Space(TAMSX3("C5_NUM")[1]),"" ,'.T.',"SC5",'.T.',80,.F.})//Ticket 1562    - Abel Babini - 31/05/2022 - Ajustes no relat�rio
	//Executa as perguntas ao usu�rio e s� executa o relat�rio caso o usu�rio confirme a tela de par�metros;
	If ParamBox(aPergs ,"Par�metros ",aRet,,,,,,,,.T.,.T.)

    MsgRun( "Carregando dados - Apenas Pedidos Liberados, aguarde...",,{ || RPEDLIB(aRet[1], aRet[2], aRet[3], aRet[4], aRet[5]) } )

  Endif

  RestArea(aArea)

  //
  U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relat�rio de Pedidos de Venda Liberados')


Return

/*/{Protheus.doc} Static Function RPEDLIB
  (long_description)
  @type  Static Function
  @author Abel Babini
  @since 26/05/2020
  /*/
Static Function RPEDLIB(MVPAR01, MVPAR02, CRELPATH, MVPAR04, MVPAR05)
  Private cQuery1
  Private oExcel		:= FWMSEXCELEX():New()
  Private oMsExcel	:= NIL
  Private cWorksht	:= 'LibPedidos'
  Private cPlan01		:= 'Libera��o de Pedidos - Detalhes'
  Private cArquivo  := Alltrim(CRELPATH) +  'LIBPEDIDOS_' + DTOS(DATE()) + STRTRAN(TIME(),':','') + '.XML'
  
  cQuery1:=GetNextAlias()
  //Ticket 1562    - Abel Babini - 31/05/2022 - Ajustes no relat�rio
  BeginSql Alias cQuery1
    COLUMN DTLIB AS DATE
    SELECT
      SC5.C5_FILIAL               AS FILIAL,
      SC5.C5_CLIENTE              AS CODCLI,
      SC5.C5_LOJACLI              AS LOJACLI,
      SA1.A1_NOME                 AS CLIENTE,
      SA1.A1_SATIV1               AS CODSEGMENTO,
      SX5.X5_DESCRI               AS SEGMENTO,
      SC5.C5_NUM                  AS NUMPEDIDO,
      ISNULL(ZEJ.ZEJ_PERFPG,'')   AS PERFILPAGTO,
      ISNULL(ZEJ.ZEJ_RATCIS,'')   AS RCISP,
      ISNULL(C5_XTOTPED,0)        AS TOT_PEDIDO,
      ISNULL(ZEJ.ZEJ_VLPED,0)    AS TOT_LIBERADO,
      ISNULL(ZEJ.ZEJ_MEDATR,0)   AS MED_ATRASO,
      ISNULL(ZEJ.ZEJ_VLAVEN,0)   AS TIT_AVENCER,
      ISNULL(ZEJ.ZEJ_VLVENC,0)   AS TIT_VENCIDO,
      ISNULL(ZEJ.ZEJ_LIMCRD,0)   AS LIMITE,
      ISNULL(ZEJ.ZEJ_PERCEN,0)   AS PERCENTUAL,
      ISNULL(ZEJ.ZEJ_VLUTIL,0)   AS VLUTIL,
      ISNULL(ZEJ.ZEJ_QTDPED,0)   AS QTDPED,
      ISNULL(ZEJ.ZEJ_TTUTIL,0)   AS TTUTIL,
      IIF(ZEJ.ZEJ_USRLIB IS NULL,'LIBERA��O AUTOM�TICA',ISNULL(ZEJ.ZEJ_USRLIB,''))   AS LIBERADOR,
      ISNULL(ZEJ.ZEJ_PARECE,'')   AS TXT_LIBERACAO,
      ISNULL(ZEJ.ZEJ_DTLIB,'')    AS DTLIB,
      ISNULL(ZEJ.ZEJ_HRLIB,'')    AS HRLIB,
      ISNULL(ZEJ.ZEJ_VLLIB,0)    AS VLLIB,
      ISNULL(ZEJ_MOTLIB,'')       AS MOTLIB
    FROM %TABLE:SC5% SC5 (NOLOCK)
    LEFT JOIN %TABLE:SA1% SA1 ON
	    SA1.A1_COD = SC5.C5_CLIENTE
    AND SA1.A1_LOJA = SC5.C5_LOJACLI
    AND SA1.%notDel%
    LEFT JOIN %TABLE:SX5% SX5 ON
	    SX5.X5_FILIAL = SC5.C5_FILIAL
    AND SX5.X5_TABELA = '_S'
    AND SX5.X5_CHAVE = SA1.A1_SATIV1
    AND SX5.%notDel%
    LEFT JOIN %TABLE:ZEJ% ZEJ ON
      ZEJ.ZEJ_FILIAL = SC5.C5_FILIAL
    AND ZEJ.	ZEJ_NUM = SC5.C5_NUM
    AND ZEJ.%notDel%
    WHERE 
      SC5.C5_FILIAL = %xFilial:SC5%
    AND SC5.C5_DTENTR BETWEEN %EXP:DTOS(MVPAR01)% AND %EXP:DTOS(MVPAR02)%
    AND SC5.C5_TIPO NOT IN ('D','B')
    AND SC5.C5_NUM BETWEEN %EXP:MVPAR04% AND %EXP:MVPAR05%
    AND SC5.%notDel%
  EndSql

  //Ticket 1562    - Abel Babini - 26/04/2022 - Relat�rio de Pedidos liberados deve trazer todos os pedidos.
  //AND ZEJ.ZEJ_DTLIB IS NOT NULL
  // Cria estrutura do Excel
  BEGIN SEQUENCE
    
    IF .NOT.( ApOleClient("MsExcel") )   // se nao existir o excel sai fora..
      Alert("Nao Existe Excel Instalado")
      BREAK
    EndIF
          
    //Planilha1 - Detalhamento
    ExlCab01()             
    ExlDet01()					

    SalvaXml()
    CriaExcel()
  
  END SEQUENCE

  (cQuery1)->(dbCloseArea())
Return

/*/{Protheus.doc} Static Function ExlCab01
  Cabe�alho da Planilha - Relat�rio Pedidos Liberados
  @type  Static Function
  @author Abel Babini
  @since 01/06/2020
  /*/
Static Function ExlCab01()
  
	oExcel:AddworkSheet(cWorksht)
	oExcel:AddTable(cWorksht,cPlan01)
	oExcel:AddColumn(cWorksht,cPlan01,"Empresa"				        ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Filial"				        ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Cod.Cliente"		        ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Loja.Cliente"	        ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Cliente"			          ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Segmento"				      ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"N� Pedido"			        ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Perfil Pagto"			    ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Rating CISP"		        ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Motivo Reten��o"	      ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"M�dia Atraso Cliente"	,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Vl.Pedido"				      ,2,2,.T.)
	oExcel:AddColumn(cWorksht,cPlan01,"Tit.A Vencer"			    ,2,3,.T.)
	oExcel:AddColumn(cWorksht,cPlan01,"Tit.Vencidos"			    ,2,3,.T.)
	// oExcel:AddColumn(cWorksht,cPlan01,"Tit.Port.Especial"		  ,2,3,.T.)
	oExcel:AddColumn(cWorksht,cPlan01,"Tot. Acumulado"			  ,2,3,.T.)
	oExcel:AddColumn(cWorksht,cPlan01,"Limite Cr�dito"			  ,2,3,.T.)
	oExcel:AddColumn(cWorksht,cPlan01,"Percentual"			      ,2,2)
	oExcel:AddColumn(cWorksht,cPlan01,"Valor Utilizado"			  ,2,3,.T.)
	oExcel:AddColumn(cWorksht,cPlan01,"Total Utilizado"			  ,2,3,.T.)
	oExcel:AddColumn(cWorksht,cPlan01,"Qtd Pedido"			      ,2,2,.T.)
  oExcel:AddColumn(cWorksht,cPlan01,"Login Liberador"			  ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Texto Libera��o"			  ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Data Libera��o"			  ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Hora Libera��o"			  ,1,1)
	oExcel:AddColumn(cWorksht,cPlan01,"Valor Libera��o"			  ,2,3,.T.)
  oExcel:AddColumn(cWorksht,cPlan01,"Rotina"			          ,1,1) //Ticket 1562    - Abel Babini - 31/05/2022 - Ajustes no relat�rio

Return 

/*/{Protheus.doc} Static Function ExlDet01
  Conte�do da Planilha - Relat�rio Pedidos Liberados
  @type  Static Function
  @author Abel Babini
  @since 01/06/2020
  /*/
Static Function ExlDet01()
  Local nTtAcum := 0
  Local cRotina := ''
  Local cQryMot := ''
  Local cMotBlq := ''
  DbSelectArea(cQuery1)
  (cQuery1)->(DbGoTop())
  While !(cQuery1)->(eof())
    //Ticket 1562    - Abel Babini - 31/05/2022 - Ajustes no relat�rio
    cMotBlq := ''

    cQryMot:=GetNextAlias()
    BeginSQL Alias cQryMot
      SELECT TRIM(ZBH.ZBH_MOTIVO) AS MOTIVO
        FROM %TABLE:ZBH% ZBH  (NOLOCK)
        WHERE 
          ZBH.ZBH_FILIAL = %Exp:(cQuery1)->FILIAL%
        AND ZBH.ZBH_PEDIDO = %Exp:(cQuery1)->NUMPEDIDO%
        AND ZBH.ZBH_CLIENT = %Exp:(cQuery1)->CODCLI%
        AND ZBH.ZBH_LOJA = %Exp:(cQuery1)->LOJACLI%
        AND ZBH.%notDel%
    ENDSQL
    (cQryMot)->(DbGoTop())
    While !(cQryMot)->(eof())
      if !Empty(Alltrim(cMotBlq))
        cMotBlq += ',' + Alltrim((cQryMot)->MOTIVO)
      else
        cMotBlq += Alltrim((cQryMot)->MOTIVO)
      endif
      (cQryMot)->(DbSkip())  
    EndDo
    (cQryMot)->(dbCloseArea())
    //Ticket 1562    - Abel Babini - 31/05/2022 - Ajustes no relat�rio
    //IF Alltrim((cQuery1)->MOT_RETENCAO) <> '' .AND. (cQuery1)->MOT_RETENCAO <> nil
      nTtAcum := (cQuery1)->TOT_PEDIDO + (cQuery1)->TIT_AVENCER + (cQuery1)->TIT_VENCIDO

      If Alltrim((cQuery1)->MOTLIB) == 'MTA450'
        cRotina := 'MATA450 Lib. Cred/Estoque'
      ElseIF Alltrim((cQuery1)->LIBERADOR) =='LIBERA��O AUTOM�TICA'
        cRotina := 'Libera��o Autom�tica'
      Else
        cRotina := 'Libera��o Manual'
      Endif

      oExcel:AddRow(cWorksht,cPlan01,{;
                                      cEmpAnt,;
                                      cFilAnt,;
                                      (cQuery1)->CODCLI,;
                                      (cQuery1)->LOJACLI,;
                                      (cQuery1)->CLIENTE,;
                                      (cQuery1)->SEGMENTO,;
                                      (cQuery1)->NUMPEDIDO,;
                                      (cQuery1)->PERFILPAGTO,;
                                      (cQuery1)->RCISP,;
                                      substring(cMotBlq,1,250),;
                                      (cQuery1)->MED_ATRASO,;
                                      (cQuery1)->TOT_PEDIDO,;
                                      (cQuery1)->TIT_AVENCER,;
                                      (cQuery1)->TIT_VENCIDO,;
                                      nTtAcum,; //Everson - 18/06/2020. Chamado 059049. Removido (cQuery1)->
                                      (cQuery1)->LIMITE,;
                                      (cQuery1)->PERCENTUAL,;
                                      (cQuery1)->VLUTIL,;
                                      (cQuery1)->TTUTIL,;
                                      (cQuery1)->QTDPED,;
                                      (cQuery1)->LIBERADOR,;
                                      (cQuery1)->TXT_LIBERACAO,;
                                      DTOC((cQuery1)->DTLIB),;
                                      (cQuery1)->HRLIB,;
                                      (cQuery1)->VLLIB,;
                                      cRotina})
    //ENDIF 
    // IIF(alltrim(DTOS((cQuery1)->DTLIB)) == '','',DTOC((cQuery1)->DTLIB)),;
                                      // nTtAcum,; //Tot Port Especial //Everson - 18/06/2020. Chamado 059049. Removido (cQuery1)->

    (cQuery1)->(DbSkip())
  EndDo
  
  oExcel:AddRow(cWorksht,cPlan01,{"","","","","","","","","","","","","","","","","","","","","","","","","",""})

Return 

	/*/{Protheus.doc} Static Function SalvaXml  
	Salva Arquivo XML - Excel
	@author Abel Babini Filho
	@since 01/06/2020
	@version 01
	/*/
	Static Function SalvaXml()
	oExcel:Activate()
	oExcel:GetXMLFile(cArquivo)
Return()

/*/{Protheus.doc} Static Function CriaExcel  
	Cria Arquivo XML - Excel
	@author Abel Babini Filho
	@since 01/06/2020
	@version 01
	/*/
Static Function CriaExcel()
  oMsExcel := MsExcel():New()
	oMsExcel:WorkBooks:Open(cArquivo)
	oMsExcel:SetVisible( .T. )
	oMsExcel:Destroy()
Return() 

/*
LIMITE EXCEDIDO     
Limite de cr�dito do
Pedido de Venda com 
TITULO EM ATRASO. Ti
VLR PEDIDO INF MINIM
VLR PARC INF MINIMO 
LIMITE EXCEDIDO - RE
Prazo medio da condi
TITULO EM ATRASO. RE
TITULO ATRASO - PERC
*/
