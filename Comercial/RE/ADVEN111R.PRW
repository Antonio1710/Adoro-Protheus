#Include "Protheus.ch"
#include "TopConn.CH"

/*/{Protheus.doc} User Function ADVEN111R
	Relatorio AgriStats.
	@type  Function
	@author Jonathan
	@since 30/07/2022
	@version version
	@history Jonathan 30/07/2022, ticket 10921 - Relatorio Agristas
    @history Jonathan 11/10/2022, ticket 10921 - Ajustado campo SIGLA 
/*/
User Function ADVEN111R() 

	Local cPerg := "ADVEN111R" //Declarando as perguntas
	Pergunte(cPerg, .T.)
	Private oSay

	FwMsgRun(,{|oSay| GeraDados()}, "Processando Dados", "Aguarde o fim da execusão...")   

Return Nil

/*/{Protheus.doc} RPTPrint
    Gera relatório AgriStas.
    @type  Static Function
    @author Jonathan
    @since 30/07/2022
    @version 01
    @see https://tdn.totvs.com/display/framework/FWMsExcelEx
    @see https://tdn.totvs.com/display/framework/FwmsgRun
    @see https://tdn.totvs.com/display/tec/CpyS2T
/*/
Static Function GeraDados()

    //Variáveis.
	Local cAlias := GetNextAlias() //Nome dados ao alias do arquivo que recebera o conteudo do SQL
    Local aDados := {} //Array que recebera os dados SQL

	BeginSql Alias cAlias
		%NoPARSER%
		SELECT '965,,,,'+SD2.D2_EMISSAO+','+SD2.D2_DOC+',915,'
		+REPLICATE('0', 6 - LEN(SD2.D2_CLIENTE+1234)) + RTrim(SD2.D2_CLIENTE+1234)+',,,'
		+SA1.A1_EST+','
		+CASE WHEN SA1.A1_VEND = '000800' 
			THEN '2' 
				WHEN SA1.A1_SATIV2 IN ('11','31','32','33','81') 
			THEN '5' 
				WHEN SA1.A1_SATIV2 IN ('21','22','23','24','25','61','62','63','64','41','42','43','44','45','46','47','48','49','51','52','53','71','72','73','74') 
			THEN '7'
				WHEN SA1.A1_SATIV2 IN ('91','92','93','94','95','96','99') 
			THEN '8' 
		END+',01,'+CONVERT(VARCHAR(10),SD2.D2_COD * 1)+','+REPLACE(SB1.B1_DESC, ',','_')+','
		+REPLACE(SD2.D2_QUANT, ',', '.')+','+REPLACE(SD2.D2_QTSEGUM * 1, ',', '.')+','
		+REPLACE(round((SD2.D2_PRUNIT * (1-(SA1.A1_DESC/100))),3), ',', '.')+','
		+REPLACE(round((SD2.D2_QUANT-SD2.D2_QTDEDEV) * (SD2.D2_PRUNIT * (1-(SA1.A1_DESC/100))),2), ',', '.')+','
		+REPLACE((SC5.C5_FRETAPV*(SD2.D2_QUANT-SD2.D2_QTDEDEV)*1), ',', '.')+','
		+(CASE WHEN SC5.C5_TPFRETE = 'C' 
			THEN '1' ELSE '0' END)+',,,'
		+(CASE WHEN (SD2.D2_QUANT-SD2.D2_QTDEDEV)*1 >0 
			THEN '0' ELSE '1' END)+','
		+SB1.B1_UM+','
		+CASE WHEN SA1.A1_EST = 'EX' 
			THEN (SELECT (CASE WHEN LEN(YA_XAGRIS) = 0 THEN YA_SIGLA ELSE YA_XAGRIS END) AS SIGLA FROM SYA010 SYA (NOLOCK) // 10921 - 11/10/2022 - Jonathan Carvalho
					WHERE  SYA.D_E_L_E_T_ = '' AND YA_CODGI = (SELECT EEC_PAISET 
																FROM EEC010 EEC (NOLOCK) 
																WHERE EEC.D_E_L_E_T_ = '' 
																AND EEC_PREEMB = (SELECT EE7_PEDIDO 
																					FROM EE7010 EE7 (NOLOCK) 
																					WHERE EE7.D_E_L_E_T_ = '' AND EE7_PEDFAT = SD2.D2_PEDIDO))) 
			ELSE 'BRA' END+',' AS Resultado
	
		FROM %Table:SD2% SD2 WITH(NOLOCK) 
		INNER JOIN %Table:SC5% SC5 WITH(NOLOCK) ON C5_NUM = D2_PEDIDO AND C5_CLIENTE = D2_CLIENTE 
			AND C5_LOJACLI = D2_LOJA   AND C5_FILIAL = %xFilial:SD2% 
		INNER JOIN %Table:SA1% SA1 WITH(NOLOCK) ON SD2.D2_CLIENTE = SA1.A1_COD AND SD2.D2_LOJA = SA1.A1_LOJA 
		INNER JOIN %Table:SB1% SB1 WITH(NOLOCK)	ON SB1.B1_COD = SD2.D2_COD 

		WHERE SD2.D2_EMISSAO >='20200902' AND SA1.A1_COD NOT LIKE '%A%' 
		AND SA1.A1_XVEND2 NOT LIKE '%A%' 
		AND (SD2.D2_QUANT-SD2.D2_QTDEDEV) > 0 
		AND SD2.D2_CF IN ('7105','7101','5101','5109','5105','5107','5116','5122','6101','6105','6107','6116','6122','5118','6118','5401','6401','6109','6501','5501') 
		AND SD2.%notDel% AND SA1.%notDel% AND SC5.%notDel%
		AND SD2.D2_FILIAL in ('02','06','07') 
		AND SD2.D2_GRUPO IN ('0111','0121','0122','0123','0131','0151','0152','0153','0154','0171','0175','0212','0213','0214','0215','0322','0324','0331','0332','0333','0335','0341','0345','0346','0351','0352','0353','0355','0356','0357','0358','0359','0363','0453','0459','0471','0473','0621','0622','0623','0628','0629','0632','0633','0635','0636','0722','0723','0724','0731','0732','0733','0734','0735','0738','0739','0744','0745','0746','0751','0752','0762','0764','0765','0766','0767','0771','0773') 
		AND (SD2.D2_EMISSAO BETWEEN %exp:DTOS(MV_PAR01)% AND %exp:DTOS(MV_PAR02)% ) 
		ORDER BY SD2.D2_EMISSAO 

	EndSql 

	While !(cAlias)->(EOF())//Enquanto não terminar as linha vai incluindo os registros dentro do excel

        //Inclui os registros do select nas linhas, tentar manter a mesma ordem que foi feita o SELECT
        Aadd(aDados, {Resultado})
        //Passa para o proximo registro do select
        (cAlias)->(DbSkip())

    EndDo

	FwMsgRun(, {|oSay| GeraExcel(aDados, oSay)}, "Gerando planilha AgriStas","Aguarde o fim da execução")

Return

Static Function GeraExcel(aDados, oSay)

    Local oExcel                := FWMsExcel():New()
    Local oExcelApp             := NIL

    /*Variaveis de Nome da planilha do excel*/
    Local cPastadeTrabalho1     := "AgriStas"
    Local cPlanilha1            := "AgriStas"
    Local cArquivo              := cPastadeTrabalho1+"_"+DToS(Date())+"_"+Replace(Time(),":","-")+".xls" 

    //Variaveis de diretorio
    Local cDestino            := "C:\temp\"
    Local cDiretorioPadrao      := GETSRVPROFSTRING( "StartPath", "\system\" ) 

    //Contador do meu FOR
    Local nCount

    If Len(aDados) <= 0
        MsgAlert("Não existem dados para os parametros escolhidos", "Atenção")
    else
        //Verifico se o Excel esta instalado
        If !ApOleClient("MSExcel")
            MsgAlert("Microsoft Excel não instalado!", "Contate o setor de TI")
            //Sai do progroma
            Return
        EndIf

        oSay:SetText("Criando estrutura da planilha Excel")

        //Criando planilha + Aba1
        oExcel:AddWorkSheet(cPastadeTrabalho1)
        oExcel:AddTable(cPastadeTrabalho1,cPlanilha1,.F.)

        //Criar colunas
        oExcel:AddColumn(cPastadeTrabalho1, cPlanilha1, "",1,1,.F.)
        

        oSay:SetText("Adicionando linhas e células à Planilha")

        //Verifica todas as linhas do Array
        For nCount := 1 to Len(aDados)
            //Usando o método AddRow(Adicionar linha), adicionamos cada dado do array em sua devida coluna
            //por isso atentar-se a ordem dos dados no select, bem como no laço de repetição
            //mostrando a quantidde de linhas 
            oSay:SetText("Adicionando linha "+CValToChar(nCount)+" de "+CValToChar(Len(aDados)))   
            oExcel:AddRow(cPastadeTrabalho1, cPlanilha1,{aDados[nCount,1]})            

        Next nCount

        //Quando o trecho do FOR, acima e execultado, usando o ADDROW, o array aWorkSheet e criado pelo sistema
        If !Empty(oExcel:aWorkSheet)//Se o array não estiver vazio, significa que tem linhas
            oSay:SetText("Abrindo arquivo...")
            
            //Gerando o arquivo nos diretorios
            oExcel:Activate()
            oExcel:GetXMLFile(cArquivo)

            CpyS2T(cDiretorioPadrao+cArquivo, cDestino)//Copia o arquivo para a pasta C:\reports

            //Abrindo o arquivo
            oExcelApp := MsExcel():New()
            oExcelApp:WorkBooks:Open(cDestino+cArquivo)//Abre o arquivo, do diretorio que recebeu a copia do arquivo
            oExcelApp:SetVisible(.T.)

        EndIf

    EndIf

Return
