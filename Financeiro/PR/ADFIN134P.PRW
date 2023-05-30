#include 'fileio.ch'
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} User Function ADFIN134P
  Exporta Arquivo de Sacado para Nexxera
  @type  Function
  @author Abel Babini
  @since 14/11/2022
  @version 1
  @history Ticket 81491  - Abel Babini    - 14/11/2022 - Projeto Nexxera - Cadastro de Sacados em Massa
  @history Ticket 81491  - Abel Babini    - 22/11/2022 - Projeto Nexxera - Ajuste no código de Tipo de Acesso
  @history Ticket 81491  - Abel Babini    - 22/12/2022 - Projeto Nexxera - Ajuste na query
  /*/
User Function ADFIN134P(aParam)
  
  Local cDir 		:= ""
  Local cAlFn134 := ''
  Local _Eof 	:= Chr(13) + Chr(10)
  Local aXEmps := {{"01","01"},{"02","01"},{"07","01"},{"09","01"}}
  Local i := 0
  Local cTpAcce := '2' //VIDE ABAIXO
  /*
  0 - Sem acesso 
  1 - Acesso via e-mail com boleto 
  2 - Acesso via site com login e senha 
  3 - Acesso via link com login direto 
  4 - Acesso via e-mail com boleto em pdf 
  5 - E-mail de notificação de boletos sem anexo ou URL 
  */

  Default aParam    := Array(2)
	Default aParam[1] := "01"
	Default aParam[2] := "01"

  FOR i:=1 to len(aXEmps) 
    aParam[1] := aXEmps[i,1] 
    aParam[2] := aXEmps[i,2]

    RpcClearEnv()
    RpcSetType(3)
    
    RpcSetEnv(aParam[1],aParam[2],,,,GetEnvServer(),{ })
    
    If !LockByName("FIN134P"+AllTrim(cEmpAnt)+AllTrim(cFilAnt), .T., .F.)
      ConOut("[ADFIN134P] - Existe outro processamento sendo executado! Verifique...")
      RPCClearEnv()
      Return
    EndIf
    
    Conout( DToC(Date()) + " " + Time() + " ADFIN134P - Início Job de exportação de clientes para Nexxera. Emp/Fil " + cEmpAnt + "/" + cFilAnt )

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Exportado cadastro de clientes para Nexxera')

    //Ticket 81491  - Abel Babini    - 22/12/2022 - Projeto Nexxera - Ajuste na query
    cAlFn134 := GetNextAlias()
    BeginSQL alias cAlFn134
      SELECT
        A1_NOME AS NOME,
        A1_CGC AS NUMINSCR,
        CASE 
          WHEN A1_PESSOA = 'J' THEN '2'
          WHEN A1_PESSOA = 'F' THEN '1'
        END AS TIPINSCR,
        A1_END AS ENDERECCO,
        A1_BAIRRO AS BAIRRO,
        A1_CEP AS CEP,
        A1_MUN AS MUNICIP,
        A1_EST AS UF,
        A1_EMAIL AS EMAIL,
        A1_COD+A1_LOJA AS CODCED
      FROM %TABLE:SA1% SA1 (NOLOCK)
      WHERE 
        A1_MSBLQL <> '1'
        AND substring(A1_CGC,1,8) IN ('60037058','02090384','12097672','20052541')
        AND SA1.%notDel%
    EndSQL
    cDir  := GetSrvProfString("InstallPath","")+"CNAB/Clientes/"
    cArq  := cDir+"CADCLI_"+cEmpAnt+".CSV"
    nHdl := fCreate(cArq,0)

    If nHdl > 0
      DbSelectArea(cAlFn134)
      (cAlFn134)->(DbGoTop())
      While !(cAlFn134)->(eof())
        cLin1 :=  Alltrim((cAlFn134)->NOME)+';'+;
                  Alltrim((cAlFn134)->NUMINSCR)+';'+;
                  Alltrim((cAlFn134)->TIPINSCR)+';'+;
                  Alltrim((cAlFn134)->ENDERECCO)+';'+;
                  Alltrim((cAlFn134)->BAIRRO)+';'+;
                  Alltrim((cAlFn134)->CEP)+';'+;
                  Alltrim((cAlFn134)->MUNICIP)+';'+;
                  Alltrim((cAlFn134)->UF)+';'+;
                  ';'+;
                  Alltrim(cTpAcce)+';'+;
                  Alltrim((cAlFn134)->CODCED)+_Eof
        fWrite(nHdl,cLin1,Len(cLin1))
        (cAlFn134)->(DbSkip())
      EndDo
      fClose(nHdl)
    Else
      Conout( DToC(Date()) + " " + Time() + " ADFIN134P - Erro na criação do arquivo. Emp/Fil " + cEmpAnt + "/" + cFilAnt )
    Endif
    (cAlFn134)->(dbCloseArea())
    //

    Conout( DToC(Date()) + " " + Time() + " ADFIN134P - Término Job de exportação de clientes para Nexxera. Emp/Fil " + cEmpAnt + "/" + cFilAnt )

    UnLockByName("FIN134P"+AllTrim(cEmpAnt)+AllTrim(cFilAnt))

    RpcClearEnv()
  NEXT i

Return
