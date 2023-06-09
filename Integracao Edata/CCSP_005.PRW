#Include "PROTHEUS.Ch"          
#Include "RWMAKE.Ch"

/*���������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CCSP_005    �Autor  �Leonardo Rios     � Data �  15/11/14   ���
�������������������������������������������������������������������������͹��
���Desc.     �Gerar Relat�rio de pedidos das quebras de devolu��es 	 	  ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �Relat�rio Pedidos		                                      ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
���������������������������������������������������������������������������*/
User Function CCSP_005()

Local oReport

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Gerar Relat�rio de pedidos das quebras de devolu��es')

oReport := ReportDef()
oReport:PrintDialog()

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � ReportDef� Autor � Leonardo Rios         � Data � 15/11/14 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Definicao do layout do Relatorio		    				  ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   � ReportDef(void)                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Generico                                                   ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportDef()
Local oReport
Local oSection1//,oSection2,oSection3,oSection4

oReport := TReport():New("CCSP_005","Relat�rio de pedidos Faturado pra transportador","CCSP_005",{|oReport| ReportPrint(oReport)},"Relat�rio de pedidos Faturado pra transportador")

oReport:SetLandScape(.T.)                                 
oReport:SetTotalInLine(.F.)		//Imprime o total em linha        

oreport:nfontbody	:=9
oreport:cfontbody	:="Lucida Sans"
oreport:nlineheight	:=50

//AjustaSx1()
pergunte("CCSP_005",.T.)
//��������������������������������������Ŀ
//� Variaveis utilizadas para parametros �
//� mv_par01	  // Data  de  		  	 �    
//� mv_par02	  // Data  ate 		  	 �
//� mv_par03	  // Filial de       	 �
//� mv_par04	  // Filial ate          �
//� mv_par05	  // Fornecedor de       �
//� mv_par06	  // Fornecedor ate      �
//� mv_par07	  // Loja de	         �
//� mv_par08	  // Loja ate 	       	 �
//����������������������������������������

//�������������                   
//�  Secao 1  �
//�������������  

oSection1 := TRSection():New(oReport,"Relat�rio de pedidos Faturado pra transportador",{"SD1","SF4","SB1","SA2"})



TRCell():New(oSection1,"C6_NUM"		,  ,"C6_NUM"		, ,TamSX3("C6_NUM")[1]	    ,.F.,)
TRCell():New(oSection1,"C6_PRODUTO"	,  ,"C6_PRODUTO"	, ,TamSX3("C6_PRODUTO")[1]	,.F.,)
TRCell():New(oSection1,"C6_QTDVEN"	,  ,"C6_QTDVEN"		, ,TamSX3("C6_QTDVEN")[1]	,.F.,)
TRCell():New(oSection1,"C6_PRCVEN"	,  ,"C6_PRCVEN"		, ,TamSX3("C6_PRCVEN")[1]   ,.F.,)
TRCell():New(oSection1,"C6_VALOR"	,  ,"C6_VALOR"		, ,TamSX3("C6_VALOR")[1]    ,.F.,)
TRCell():New(oSection1,"D1_QUANT"	,  ,"D1_QUANT"		, ,TamSX3("D1_QUANT")[1]    ,.F.,)


oSection1:Cell("C6_NUM"):SetHeaderAlign("CENTER")
oSection1:Cell("C6_PRODUTO"):SetHeaderAlign("CENTER")
oSection1:Cell("C6_QTDVEN"):SetHeaderAlign("CENTER")  
oSection1:Cell("C6_PRCVEN"):SetHeaderAlign("CENTER")  
oSection1:Cell("C6_VALOR"):SetHeaderAlign("CENTER")  
oSection1:Cell("D1_QUANT"):SetHeaderAlign("CENTER")  

oSection1:SetLineBreak(.F.)		//Quebra de linha automatica

Return oReport                                                                              

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Programa  �ReportPrint� Autor �Leonardo Rios         � Data �29/08/14   ���
��������������������������������������������������������������������������Ĵ��
���Descri��o �A funcao ReportPrint() ser� executada ao clicar no botao	   ���
���          �para imprimir										           ���
��������������������������������������������������������������������������Ĵ��
���Retorno   �Nenhum                                                       ���
���������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function ReportPrint(oReport)
                                                 
Local oSection1	:= oReport:Section(1)  
Local nOrdem 	:= oSection1:GetOrder()
// Local oBreak
Local aDados[11]

Private cAlias
Private cTitulo  	:= ""



//��������������������������������������������������������������Ŀ
//� Secao de faturamento - Notas Fiscais de Venda de PA          �
//����������������������������������������������������������������

cAlias	:= GetNextAlias()

oSection1:BeginQuery()   
     
    If(mv_par01 == Nil .OR. Empty(mv_par01) )
		mv_par01 := ddatabase
	Else
		mv_par01 := STOD(DTOS(mv_par01))
	EndIf
         
    If(mv_par02 == Nil .OR. Empty(mv_par02) )
		mv_par02 := ddatabase  
	Else
		mv_par02 := STOD(DTOS(mv_par02))
	EndIf

	If(mv_par04 == Nil .OR. Empty(ALLTRIM(mv_par04)) )
		mv_par04 := PADC("", TamSX3("C6_NUM")[1], "z")
	EndIf

	If(mv_par06 == Nil .OR. Empty(ALLTRIM(mv_par06)) )
		mv_par06 := PADC("", TamSX3("C6_CLI")[1], "z")
	EndIf

	If(mv_par08 == Nil .OR. Empty(ALLTRIM(mv_par08)) )
		mv_par08 := PADC("", TamSX3("C6_LOJA")[1], "z")
	EndIf                                         
	
	If(mv_par10 == Nil .OR. Empty(ALLTRIM(mv_par10)) )
		mv_par10 := PADC("", TamSX3("D1_NFORI")[1], "z")
	EndIf
	
	If(mv_par12 == Nil .OR. Empty(ALLTRIM(mv_par12)) )
		mv_par12 := PADC("", TamSX3("D1_SERIORI")[1], "z")
	EndIf
	
	If(mv_par13 == Nil .OR. Empty(mv_par13) )
		mv_par13 := ddatabase 
	Else
		mv_par13 := STOD(DTOS(mv_par13))		
	EndIf
	                                     
	If(mv_par14 == Nil .OR. Empty(mv_par14) )
		mv_par14 := ddatabase             
	Else
		mv_par14 := STOD(DTOS(mv_par14))		
	EndIf

    

BeginSql Alias cAlias
	
	SELECT C6_NUM, C6_PRODUTO, C6_QTDVEN, C6_PRCVEN, C6_VALOR, D1_QUANT
	
	FROM %table:SD1% SD1, %table:SC6% SC6, %table:SC5% SC5
		
	WHERE 
	C6_FILIAL = C5_FILIAL
	AND C6_NUM = C5_NUM
	AND C6_FILIAL = D1_FILIAL
	AND C6_XRECSD1 = SD1.R_E_C_N_O_
	AND C6_XIDNDEV = D1_MSIDENT
	AND D1_XPVDEV = '1'
	AND D1_TIPO = 'D'
	AND D1_CTRDEVO <> ' '
	
	AND C5_EMISSAO BETWEEN %Exp:mv_par01% AND %Exp:mv_par02%
	AND C6_NUM     BETWEEN %Exp:mv_par03% AND %Exp:mv_par04%
	AND C6_CLI     BETWEEN %Exp:mv_par05% AND %Exp:mv_par06%
	AND C6_LOJA    BETWEEN %Exp:mv_par07% AND %Exp:mv_par08%
	AND D1_NFORI   BETWEEN %Exp:mv_par09% AND %Exp:mv_par10% 
	AND D1_SERIORI BETWEEN %Exp:mv_par11% AND %Exp:mv_par12% 
	AND D1_DTDIGIT BETWEEN %Exp:mv_par13% AND %Exp:mv_par14% 

	AND SC6.%notDel% AND SC5.%notDel% AND SD1.%notDel%
	
EndSql


oSection1:EndQuery()

DbSelectArea(cAlias)
Dbgotop()
                       
oSection1:Cell("C6_NUM"    ):SetBlock( 	{ || aDados[1 ]	})
oSection1:Cell("C6_PRODUTO"):SetBlock(	{ || aDados[2 ]	})
oSection1:Cell("C6_QTDVEN" ):SetBlock( 	{ || aDados[3 ]	})
oSection1:Cell("C6_PRCVEN" ):SetBlock( 	{ || aDados[4 ]	})
oSection1:Cell("C6_VALOR"  ):SetBlock( 	{ || aDados[5 ]	})
oSection1:Cell("D1_QUANT"  ):SetBlock( 	{ || aDados[6 ]	})



//��������������������������������������������������������������Ŀ
//� Define as quebras da se��o, conforme a ordem escolhida.      �
//����������������������������������������������������������������

//oBreak  := TRBreak():New(oSection1,{|| (cAliasSD2)->D2_COD },{|| "---------------" + cCod})

If (cAlias)->(EOF())
	Aviso("CCSP_005-Section1","N�o existem pedidos de acordo com a parametriza��o",{"Ok"})
EndIf

oReport:NoUserFilter()

oSection1:Init()

oReport:SetMeter((cAlias)->(RecCount()))

cTitulo := "Relatorio de Pedidos"
oReport:SetTitle(cTitulo)

While (cAlias)->(!EOF())

   	oReport:IncMeter()

	aDados[1] := (cAlias)->C6_NUM
	aDados[2] := (cAlias)->C6_PRODUTO
	aDados[3] := (cAlias)->C6_QTDVEN
	aDados[4] := (cAlias)->C6_PRCVEN
	aDados[5] := (cAlias)->C6_VALOR
	aDados[6] := (cAlias)->D1_QUANT

	oSection1:PrintLine()
 
	DbSelectArea(cAlias)		
	(cAlias)->(DbSkip())
	
EndDo

oSection1:Finish()  


DbSelectArea(cAlias)
dbCloseArea()


Return



/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AjustaSX1 �Autor  �Leonardo Rios    � Data �29/08/2014   	  ���
�������������������������������������������������������������������������͹��
���Desc.     �Insere novas perguntas ao sx1 para o relat�rio de compras   ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       �CCSP_005                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
//Static Function AjustaSX1()
//
////���������������������������������������Ŀ
////� Variaveis utilizadas para parametros  �
////� mv_par01	  // Emissao  de	  	 �
////� mv_par02	  // Emissao  ate 	  	 �
////� mv_par03	  // Pedido de  	     �
////� mv_par04	  // Pedido ate	    	 �
////� mv_par05	  // Cliente de     	 �
////� mv_par06	  // Cliente ate	     �
////� mv_par07	  // Loja de	         �
////� mv_par08	  // Loja ate 	       	 �
////� mv_par09	  // Nota de    	   	 �
////� mv_par10	  // Nota ate	         �
////� mv_par11	  // Serie de       	 �
////� mv_par12	  // Serie ate 		     �
////� mv_par13	  // Entrada Dev  de	 �
////� mv_par14	  // Entrada Dev  de	 �
////�����������������������������������������
//
//PutSx1("CCSP_005", "01", "Emissao  de    " 	  , "Emissao  de    " , "Emissao de     ", "mv_cha", "D", 8					   	 , 0, 1, "G", "", ""   , "", "", "mv_par01", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "02", "Emissao  ate   "    , "Emissao  ate   " , "Emissao ate    ", "mv_chb", "D", 8					   	 , 0, 1, "G", "", ""   , "", "", "mv_par02", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "03", "Pedido de  	 "    , "Pedido de  	" , "Pedido de 	    ", "mv_chc", "C", TamSX3("C6_NUM" 	 )[1], 0, 1, "G", "", "SC5", "", "", "mv_par03", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "04", "Pedido ate 	 "    , "Pedido ate 	" , "Pedido ate	    ", "mv_chd", "C", TamSX3("C6_NUM" 	 )[1], 0, 1, "G", "", "SC5", "", "", "mv_par04", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "05", "Cliente de  	 "    , "Cliente de  	" , "Cliente de     ", "mv_che", "C", TamSX3("C6_CLI"	 )[1], 0, 1, "G", "", "SA1", "", "", "mv_par05", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "06", "Cliente ate 	 "    , "Cliente ate 	" , "Cliente ate    ", "mv_chf", "C", TamSX3("C6_CLI"	 )[1], 0, 1, "G", "", "SA1", "", "", "mv_par06", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "07", "Loja de        "    , "Loja de        " , "Loja de        ", "mv_chg", "C", TamSX3("C6_LOJA"	 )[1], 0, 1, "G", "", ""   , "", "", "mv_par07", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "08", "Loja ate       "    , "Loja Ate       " , "Loja ate       ", "mv_chh", "C", TamSX3("C6_LOJA"	 )[1], 0, 1, "G", "", ""   , "", "", "mv_par08", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "09", "Nota de	     "    , "Nota de        " , "Nota de        ", "mv_chi", "C", TamSX3("D1_NFORI"	 )[1], 0, 1, "G", "", ""   , "", "", "mv_par09", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "10", "Nota ate       "    , "Nota ate       " , "Nota ate       ", "mv_chj", "C", TamSX3("D1_NFORI"	 )[1], 0, 1, "G", "", ""   , "", "", "mv_par10", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "11", "Serie de	     "    , "Serie de       " , "Serie de       ", "mv_chk", "C", TamSX3("D1_SERIORI")[1], 0, 1, "G", "", ""   , "", "", "mv_par11", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "12", "Serie ate      "    , "Serie ate      " , "Serie ate      ", "mv_chl", "C", TamSX3("D1_SERIORI")[1], 0, 1, "G", "", ""   , "", "", "mv_par12", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "13", "Entrada Dv. de "    , "Entrada Dv. de " , "Entrada Dv. de ", "mv_chm", "D", 8					   	 , 0, 1, "G", "", ""   , "", "", "mv_par13", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//PutSx1("CCSP_005", "14", "Entrada Dv. ate"    , "Entrada Dv. ate" , "Entrada Dv. ate", "mv_chn", "D", 8					   	 , 0, 1, "G", "", ""   , "", "", "mv_par14", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "", "")
//
//Return
