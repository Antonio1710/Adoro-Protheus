#include 'fileio.ch'
#Include "Protheus.ch"
#Include "Topconn.ch"

/*/{Protheus.doc} User Function ADFIN135P
  Exporta Arquivo de Emails de Sacado para Nexxera
  @type  Function
  @author Abel Babini
  @since 13/12/2022
  @version 1
  @history Ticket 81491  - Abel Babini    - 13/12/2022 - Projeto Nexxera - Cadastro de Email de Sacados em Massa
  @history Ticket 81491  - Abel Babini    - 22/12/2022 - Projeto Nexxera - Ajuste na query
  /*/
User Function ADFIN135P(aParam)
  
  Local cDir 		:= ""
  Local cAlFn135 := ''
  Local _Eof 	:= Chr(13) + Chr(10)
  Local aXEmps := {{"01","01"},{"02","01"},{"07","01"},{"09","01"}}
  Local i := 0
  
  Default aParam    := Array(2)
	Default aParam[1] := "01"
	Default aParam[2] := "01"

  FOR i:=1 to len(aXEmps) 
    aParam[1] := aXEmps[i,1] 
    aParam[2] := aXEmps[i,2]


    RpcClearEnv()
    RpcSetType(3)
    
    RpcSetEnv(aParam[1],aParam[2],,,,GetEnvServer(),{ })
    
    If !LockByName("FIN135P"+AllTrim(cEmpAnt)+AllTrim(cFilAnt), .T., .F.)
      ConOut("[ADFIN135P] - Existe outro processamento sendo executado! Verifique...")
      RPCClearEnv()
      Return
    EndIf
    
    Conout( DToC(Date()) + " " + Time() + " ADFIN135P - Início Job de exportação de clientes para Nexxera. Emp/Fil " + cEmpAnt + "/" + cFilAnt )

    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Exportado cadastro de clientes para Nexxera')

    //Ticket 81491  - Abel Babini    - 22/12/2022 - Projeto Nexxera - Ajuste na query
    cAlFn135 := GetNextAlias()
    BeginSQL alias cAlFn135  
      SELECT
        A1_NOME AS NOME,
        A1_CGC AS NUMINSCR,
        CASE 
          WHEN A1_PESSOA = 'J' THEN '2'
          WHEN A1_PESSOA = 'F' THEN '1'
        END AS TIPINSCR,
        A1_EMAIL AS EMAIL,
        A1_COD+A1_LOJA AS CODCED
        FROM %TABLE:SA1% SA1 (NOLOCK)
      WHERE 
        A1_MSBLQL <> '1'
        AND substring(A1_CGC,1,8) in ('60037058','02090384','12097672','20052541')
        AND SA1.%notDel%
    EndSQL
    cDir  := GetSrvProfString("InstallPath","")+"CNAB/email/"
    cArq  := cDir+"EMAIL_"+cEmpAnt+".CSV"
    nHdl := fCreate(cArq,0)

    If nHdl > 0
      DbSelectArea(cAlFn135)
      (cAlFn135)->(DbGoTop())
      While !(cAlFn135)->(eof())
        cLin1 :=  Alltrim((cAlFn135)->NOME)+';'+;
                  Alltrim((cAlFn135)->NUMINSCR)+';'+;
                  Alltrim((cAlFn135)->TIPINSCR)+';'+;
                  Alltrim((cAlFn135)->EMAIL)+';'+;
                  Alltrim((cAlFn135)->CODCED)+_Eof
        fWrite(nHdl,cLin1,Len(cLin1))
        (cAlFn135)->(DbSkip())
      EndDo
      fClose(nHdl)
    Else
      Conout( DToC(Date()) + " " + Time() + " ADFIN135P - Erro na criação do arquivo. Emp/Fil " + cEmpAnt + "/" + cFilAnt )
    Endif
    (cAlFn135)->(dbCloseArea())
    //

    Conout( DToC(Date()) + " " + Time() + " ADFIN135P - Término Job de exportação de clientes para Nexxera. Emp/Fil " + cEmpAnt + "/" + cFilAnt )

    UnLockByName("FIN134P"+AllTrim(cEmpAnt)+AllTrim(cFilAnt))

    RpcClearEnv()
    
  NEXT i

Return
