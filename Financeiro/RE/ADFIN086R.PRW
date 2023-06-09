#INCLUDE "PROTHEUS.CH"
#Include "TopConn.CH"
//#Include "TbiConn.CH"
#include "ap5mail.ch"

/*/{Protheus.doc} User Function ADFIN086R
  Workflow Financeiro - Solicita��es de Pagamento Antecipado
  @type  Function
  @author Abel Babini
  @since 27/04/2020
  @history Chamado 056918 - Abel Babini - 27/04/2020 - Workflow Financeiro Solicita��o de Pagamentos Antecipados
	@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
  /*/
User Function ADFIN086R()

  Private aTables := {"ZFQ","SA2","SE2","SB1"}
  //Private _lExec 		:= Iif(ValType(nPar) == 'N',.T.,.F.)	//Verifica chamada de Menu

  //Registro da execu��o no Console.LOG
  ConOut('ADFIN086R - Execucao por JOB ||' + DTOC(DATE()) + '||' + TIME())

  //Se execu��o via JOB, prepara ambiente
  //PREPARE ENVIRONMENT EMPRESA "01" FILIAL "01" MODULO "FIN" 
  
  RpcClearEnv()

  // Seta job para nao consumir licensas
  RpcSetType(3)

  //seta o ambiente com a empresa 99 filial 01 com os direitos do usu�rio administrador, m�dulo CTB
  RpcSetEnv( '01','02', , , "FIN", 'ADFIN086R', aTables, , , ,  )

  // Garanto uma �nica thread sendo executada - // Adoro - Chamado n. 050729 || OS 052035 || TECNOLOGIA || LUIZ || 8451 || REDUCAO DE BASE - fwnm - 30/06/2020
	If !LockByName("ADFIN086R", .T., .F.)
		ConOut("[ADFIN086R] - Existe outro processamento sendo executado! Verifique...")
		RPCClearEnv()
		Return
	EndIf

  /****** COMANDOS *************/

  //@history Ticket 70142 	- Rodrigo Mello | Flek - 22/03/2022 - Substituicao de funcao PTInternal por FWMonitorMsg MP 12.1.33
  //FWMonitorMsg(ALLTRIM(PROCNAME()))
  
  U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Workflow de Solicita��o de PA')

  FIN86EXE()	// Execucao da Funcao de Processamento

	//��������������������������������������?
	//�Destrava a rotina para o usu�rio	    ?
	//��������������������������������������?
	UnLockByName("ADFIN086R")

  RpcClearEnv() //Limpa o ambiente, liberando a licen�a e fechando as conex�es    
  //RESET ENVIRONMENT

Return 

Static Function FIN86EXE

  Local cMVEFex := GETMV("MV_#EF86EM",,"01,02/01,03/01,04") //Empresas e Filiais para executar o JOB
  Local aMVEFex := StrTokArr(cMVEFex,'/')  
  Local _aEmFlEx:= {}
  Local cQuery1
  Local cPara   := GETMV("MV_#EF86PR",,"CONTASAPAGAR@ADORO.COM.BR") //Destinat�rio dos email do Workflow.
  Local cDtExec := Date()
  Local _cMsgIte:= ''
  Local nExec
  Private _cMens := ''

  FOR nExec := 1 to Len(aMVEFex)

    //Prepara o ambiente para cada empresa/filial do par�metro
    _aEmFlEx := StrTokArr(aMVEFex[nExec],',')  
    RpcClearEnv() //Limpa o ambiente, liberando a licen�a e fechando as conex�es
    RpcSetType(3)
    RpcSetEnv( _aEmFlEx[1],_aEmFlEx[2], , , "FIN", 'ADFIN086R', aTables, , , ,  )

    //Seleciona registros a serem enviados por email
    If Select(cQuery1) > 0
      (cQuery1)->(dbCloseArea())
    Endif
    cQuery1:=GetNextAlias()

    BeginSQL  Alias cQuery1
      Column DTEMISSAO as DATE
      Column DTVENCTO as DATE
      Column DTVENCRE as DATE
      SELECT 
        ZFQ.ZFQ_FILIAL  AS FILIAL,
        ZFQ.ZFQ_PREFIX  AS PREFIXO,
        ZFQ.ZFQ_NUM     AS NUMERO,
        ZFQ.ZFQ_PARCEL  AS PARCELA,
        ZFQ.ZFQ_TIPO    AS TIPO,
        ZFQ.ZFQ_NATURE  AS NATUREZA,
        ZFQ.ZFQ_FORNEC  AS FORNECEDOR,
        ZFQ.ZFQ_LOJA    AS LOJA,
        SA2.A2_NOME     AS NOME,
        ZFQ.ZFQ_EMISSA  AS DTEMISSAO,
        ZFQ.ZFQ_VENCTO  AS DTVENCTO,
        ZFQ.ZFQ_VENCRE  AS DTVENCRE,
        ZFQ.ZFQ_VALOR   AS VALOR,
        ZFQ.ZFQ_HIST    AS HISTORICO,
        ZFQ.ZFQ_MOEDA   AS MOEDA,
        (SELECT TOP 1
        	  SY1.Y1_NOME 
	        FROM %TABLE:SC7% SC7
	        LEFT JOIN %TABLE:SY1% SY1 ON
		          SY1.Y1_FILIAL = SC7.C7_FILIAL
		      AND SY1.Y1_USER = SC7.C7_USER
		      AND SY1.%notDel%
	      WHERE SC7.C7_NUM = ZFQ.ZFQ_NUM
		      AND SC7.C7_FILIAL = ZFQ.ZFQ_FILIAL
          AND SC7.%notDel%
	      ) AS SOLICITANTE
      FROM %TABLE:ZFQ% ZFQ (NOLOCK)
      LEFT JOIN %TABLE:SA2% SA2 (NOLOCK) ON
            SA2.A2_COD  = ZFQ.ZFQ_FORNEC
        AND SA2.A2_LOJA = ZFQ.ZFQ_LOJA
        AND SA2.%notDel%
      WHERE
            ZFQ.ZFQ_FILIAL=%xFilial:SFT%
        AND ZFQ.ZFQ_EMISSA <= %Exp:DToS(cDtExec)%
        AND ZFQ.ZFQ_STSLIB = '1'
        AND ZFQ.ZFQ_OPEINT = 'I'
        AND ZFQ.%notDel%
    EndSQL

    //Monta estrutura das linhas a serem enviadas no email
    DbSelectArea(cQuery1)
    (cQuery1)->(DbGoTop())
    nCntReg := 0
    (cQuery1)->(DbGoTop())
    _cMsgIte := ''
    While !(cQuery1)->(eof())
      nCntReg += 1
      _cMsgIte += '<tr height="20" style="height:15.0pt">'
      _cMsgIte += '		<td height="20" style="height: 15.0pt; color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: 1.0pt solid windowtext; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMsgIte += '		'+Alltrim(SM0->M0_NOME)+' &nbsp;</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->FILIAL+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->PREFIXO+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->NUMERO+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="61">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->PARCELA+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="79">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->TIPO+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="71">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->NATUREZA+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="53">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->FORNECEDOR+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="73">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->LOJA+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="51">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->NOME+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="51">'
      _cMsgIte += '		&nbsp;'+DTOC((cQuery1)->DTEMISSAO)+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="51">'
      _cMsgIte += '		&nbsp;'+DTOC((cQuery1)->DTVENCTO)+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="51">'
      _cMsgIte += '		&nbsp;'+DTOC((cQuery1)->DTVENCRE)+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="51">'
      _cMsgIte += '		&nbsp;'+Transform((cQuery1)->VALOR,"@E 999,999,999,999.99")+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="51">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->HISTORICO+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="51">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->MOEDA+'</td>'
      _cMsgIte += '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: .5pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="51">'
      _cMsgIte += '		&nbsp;'+(cQuery1)->SOLICITANTE+'</td>'
      _cMsgIte += '	</tr>'	

      (cQuery1)->(DbSkip())
    EndDo
    (cQuery1)->(dbCloseArea())

    //Se o n�mero de linhas maior que zero, envia email, se n�o vai para a pr�xima empresa/filial
    IF nCntReg > 0 
      cDe         := AllTrim(GetMv("MV_#MAILVC")) 
      cBcc        := ""
      cCC         := AllTrim(GetMv("MV_#MAILCC")) 
      cSubject    := "Solicita��es de PA("+DTOC(cDtExec)+")"
      _cMens  :=  '<html>'
      _cMens  +=  '<head>'
      _cMens  +=  '<meta http-equiv="Content-Language" content="pt-br">'
      _cMens  +=  '<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">'
      _cMens  +=  '<title>Solicita��es de PA Pendentes</title>'
      _cMens  +=  '</head>'
      _cMens  +=  '<body>'
      _cMens  +=  '<p>Bom Dia</p>'
      //_cMens  +=  '<p>A/C Contas a Pagar,</p>'
      _cMens  +=  '<p>Segue rela��o de Solicita��es de Pagamento Antecipado pendentes de aprova��o / agendamento.'
      _cMens  +=  '</p>'
      _cMens  +=  '<table border="0" cellpadding="0" cellspacing="0" style="border-collapse: collapse; width: 660px">'
      _cMens  +=  '	<colgroup>'
      _cMens  +=  '		<col width="64" span="17" style="width:48pt">'
      _cMens  +=  '	</colgroup>'
      _cMens  +=  '	<tr height="21" style="height:15.75pt">'
      _cMens  +=  '		<td colspan="17" height="21" style="height: 15.75pt; width: 656px; text-align: center; color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; vertical-align: bottom; white-space: nowrap; border-left: 1.0pt solid windowtext; border-right: 1.0pt solid black; border-top: 1.0pt solid windowtext; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		&nbsp;<b>Solicita��o de Pagamento Antecipado pendente - '+DTOC(cDtExec)+'</b><p>&nbsp;</td>'
      _cMens  +=  '	</tr>'
      _cMens  +=  '	<tr height="21" style="height:15.75pt">'
      _cMens  +=  '		<td height="21" style="height: 15.75pt; color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: 1.0pt solid windowtext; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		<b>&nbsp;Empresa&nbsp;</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		<b>Filial&nbsp;</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		<b>Prefixo&nbsp;</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		<b>No T�tulo&nbsp;</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		<b>&nbsp;Parcela</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		<b>Tipo&nbsp;</b></td>'

      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		<b>Natureza&nbsp;</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		<b>Cod.Forn.&nbsp;</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		<b>Loja&nbsp;</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px">'
      _cMens  +=  '		<b>Fornecedor&nbsp;</b></td>'

      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="61">'
      _cMens  +=  '		<b>&nbsp;Dt. Emiss�o</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="79">'
      _cMens  +=  '		<b>&nbsp;Vencimento</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="71">'
      _cMens  +=  '		<b>&nbsp;Venc. Real</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="71">'
      _cMens  +=  '		<b>&nbsp;Vlr. Titulo</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="53">'
      _cMens  +=  '		<b>&nbsp;Hist�rico</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="73">'
      _cMens  +=  '		<b>Moeda&nbsp;</b></td>'
      _cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="73">'
      _cMens  +=  '		<b>Solicitante&nbsp;</b></td>'
      //_cMens  +=  '		<td style="color: black; font-size: 11.0pt; font-weight: 400; font-style: normal; text-decoration: none; font-family: Calibri, sans-serif; text-align: general; vertical-align: bottom; white-space: nowrap; border-left: medium none; border-right: 1.0pt solid windowtext; border-top: medium none; border-bottom: 1.0pt solid windowtext; padding-left: 1px; padding-right: 1px; padding-top: 1px" width="51">'
      //_cMens  +=  '		<b>&nbsp;Atraso (dias)</b></td>'
      _cMens  +=  '	</tr>'

      //Adiciona linhas de detalhe
      _cMens  += _cMsgIte

      //Finaliza montagem do HTML
      _cMens  +=  '</table>'
      //_cMens  +=  '<p>Contamos com a habitual compreens�o e provid�ncias e desde j� agradecemos.'
      //_cMens  +=  '</p>'
      //_cMens  +=  '<p>Quaisquer d�vidas, favor entrar em contato.</p>'
      //_cMens  +=  '<p>Telefone: (11) 4596.8450 / (11) '      
      //_cMens  +=  '4596.8376 </p>'
      //_cMens  +=  '<p>Email: cobranca@adoro.com.br </p>'
      _cMens  +=  '<p><span style="background-color: #FFFF00">****ESTE � UM E-MAIL AUTOM�TICO, '
      _cMens  +=  'FAVOR N�O RESPONDER**** </span></p>'
      _cMens  +=  '</body>'
      _cMens  +=  '</html>'

      Dispara(cPara,cBcc,cCC,cSubject,_cMens,.t.,cDe)

    ENDIF
  NEXT nExec

Return

Static Function Dispara(cTo,cBcc,cCC,cSubject,cHtml,lMens,cFrom)
Local lOk       	:= .T.
Local cBody			:= cHtml
Local cErrorMsg		:=	""
Local aFiles 		:= {} 
Local cServer      := Alltrim(GetMv("MV_RELSERV")) 
Local cAccount      := AllTrim(GetMv("MV_RELACNT")) //Por Adriana em 29/05/2019 substituido MV_#MAILVC por MV_RELACNT
Local cPassword     := AllTrim(GetMv("MV_RELPSW"))  //Por Adriana em 29/05/2019 substituido MV_#PSWCOB por MV_RELPSW
Local cFrom         := AllTrim(GetMv("MV_RELFROM")) //Por Adriana em 29/05/2019 substituido MV_#MAILVC por MV_RELFROM
Local lSmtpAuth  	:= GetMv("MV_RELAUTH",,.F.)
Local lAutOk     	:= .F.
Local cAtach 		:= ""

Connect Smtp Server cServer Account cAccount 	Password cPassword Result lOk

If !lAutOk
	If ( lSmtpAuth )
		lAutOk := MailAuth(cAccount,cPassword)
	Else
		lAutOk := .T.
	EndIf
EndIf

If lOk .And. lAutOk
	
	Send Mail From cFrom To cTo CC cCC Subject cSubject Body cBody ATTACHMENT cAtach Result lOk
	
	If !lOk
		Get Mail Error cErrorMsg
		ConOut("3 - " + cErrorMsg)
	EndIf
Else
	Get Mail Error cErrorMsg
	ConOut("4 - " + cErrorMsg)
EndIf

If lOk
	Disconnect Smtp Server
Endif

Return 
