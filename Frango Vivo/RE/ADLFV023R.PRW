#INCLUDE "PROTHEUS.CH"  
#INCLUDE "FILEIO.CH"
#INCLUDE "TopConn.CH"  
#INCLUDE "rwmake.ch"

/*{Protheus.doc} User Function ADLFV023R
	Relatorio para acompanhamento tempo de trajeto do frango vivo desde o carregamento nas granjas.
	@type  Function
	@author ADRIANO SAVOINE
	@since 30/01/2023
	@version 01
	@history Ticket: 87212 - 30/01/2023 - Adriano Savoine - Desenvolvido o Relatorio em Excel.
*/

User Function ADLFV023R()
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio para acompanhamento do Tempo de Trajeto do Frango Vivo.')
	
	Private aSays		:={}
	Private aButtons	:={}   
	Private cCadastro	:= "Relatorio Tempo de trajeto Frango Vivo."    
	PRIVATE oFontA06	:= TFont():New( "Arial",,10,,.f.,,,,,.f. )
	PRIVATE oFontA09	:= TFont():New( "Arial",,-9,,.f.,,,,,.f. )
	PRIVATE oFontA09b	:= TFont():New( "Arial",,-9,,.t.,,,,,.f. )
	PRIVATE oFontA07	:= TFont():New( "Arial",,12,,.T.,,,,,.f. )
	PRIVATE oPrn		:= TMSPrinter():New()
	Private nOpca		:= 0
	Private cPerg		:= 'ADLFV023R'
	
	//Cria grupo de Perguntas                         
	//MontaPerg()
	Pergunte(cPerg,.F.)

	//Monta Form Batch - Interface com o Usuario     
	
	AADD(aSays,"Este programa tem a finalidade de Gerar um arquivo Excel " )
	AADD(aSays,"Relatorio Tempo de trajeto Frango Vivo." )
    
	AADD(aButtons, { 5,.T.,{|o| Pergunte(cPerg,.T.) }})
	AADD(aButtons, { 1,.T.,{|o| nOpca:=1, o:oWnd:End(), Processa({||LFV023()},"Gerando arquivo","Aguarde...")    }})
	AADD(aButtons, { 2,.T.,{|o| nOpca:=2, o:oWnd:End() }})
	
	FormBatch( cCadastro, aSays, aButtons )  
	
Return (Nil)  

Static Function LFV023()    

	Public oExcel      := FWMSEXCEL():New()
	Public cPath       := 'D:\Totvs\Protheus11_Homolog\protheus_data\system\'
	Public cArquivo    := 'REL_TEMPO_TRAJETO_FRANGO_VIVO.XML'
	Public oMsExcel
	Public cPlanilha   := DTOC(MV_PAR01) + ' ate ' + DTOC(MV_PAR02)
    Public cTitulo     := "Relatorio Tempo de Trajeto Frango Vivo - " + DTOC(MV_PAR01) + ' ate ' + DTOC(MV_PAR02)
    Public cCodProdSql := ''
    Public aLinhas    := {}
   
	BEGIN SEQUENCE
		
		IF .NOT.( ApOleClient("MsExcel") )   // se nao existir o excel sai fora..
		    Alert("Não Existe Excel Instalado")
            BREAK
        EndIF
		
		Cabec()             
		GeraExcel()
	          
		SalvaXml()
		CriaExcel()
	
	    MsgInfo("Arquivo Excel gerado!")    
	    
	END SEQUENCE

Return(NIL) 

Static Function GeraExcel()

	Local   nExcel     := 0
    Private nLinha     := 0
	Private dData      := ''
    Private cPlaca     := ''
    Private cMotorista := ''
    Private cTransp    := ''
    Private nOrdem     := ''
    Private nGalpao    := ''
    Private cCodGra    := ''   
    Private cNmGranja  := ''
    Private dDtcarreg  := ''    
    Private dDtsaida   := ''
    Private dDtChad    := ''
    Private cTempTj    := ''
    Private cKmperc    := ''
    Private dInipend   := ''
    Private dFimpend   := ''
    Private dSaidad    := ''
    Private nLat       := ''
    Private nLog       := ''
    Private cBairro    := ''
    Private cCidade    := ''
    Private cEst       := ''

    SqlGeral() 
	
	DBSELECTAREA("TRB")
		TRB->(DBGOTOP())
		
		WHILE TRB->(!EOF()) 

            dData      := TRB->DATA
            cPlaca     := TRB->PLACA
            cMotorista := TRB->MOTORISTA
            cTransp    := TRB->TRANSPORTADORA
            nOrdem     := TRB->ORDEM_CARREGAMENTO
            nGalpao    := TRB->GALPAO
            cCodGra    := TRB->COD_GRANJA   
            cNmGranja  := TRB->DESCRICAO
            dDtcarreg  := TRB->DT_CARREGAMENTO_GRANJA    
            dDtsaida   := TRB->DT_SAIDA_GRANJA
            dDtChad    := TRB->DT_CHEGADA_BALANÇA_ADORO
            cTempTj    := TRB->TEMPO_TRAJETO
            cKmperc    := TRB->KM_PERCORRIDO
            dInipend   := TRB->INICIO_PENDURA
            dFimpend   := TRB->FIM_PENDURA
            dSaidad    := TRB->DT_SAIDA_BALANÇA_ADORO
            nLat       := TRB->LATITUDE
            nLog       := TRB->LONGITUDE
            cBairro    := TRB->BAIRRO
            cCidade    := TRB->CIDADE
            cEst       := TRB->ESTADO

            IMPRIMELINHA()    

			TRB->(dbSkip())    
		
		END //end do while TRB
		TRB->( DBCLOSEAREA() )
		
		
        //============================== INICIO IMPRIME LINHA NO EXCEL
		FOR nExcel := 1 TO nLinha
	   		oExcel:AddRow(cPlanilha,cTitulo,{aLinhas[nExcel][01],; // 01 A  
            	                             aLinhas[nExcel][02],; // 02 B  
            	                             aLinhas[nExcel][03],; // 03 C  
	   	        	                         aLinhas[nExcel][04],; // 04 D  
	   	            	                     aLinhas[nExcel][05],; // 05 E  
	   	                	                 aLinhas[nExcel][06],; // 06 F  
	   	                	                 aLinhas[nExcel][07],; // 07 G  
	   	                	                 aLinhas[nExcel][08],; // 08 H
                                             aLinhas[nExcel][09],; // 09 I
                                             aLinhas[nExcel][10],; // 10 J
                                             aLinhas[nExcel][11],; // 11 K
                                             aLinhas[nExcel][12],; // 12 L
                                             aLinhas[nExcel][13],; // 13 M
                                             aLinhas[nExcel][14],; // 14 N
                                             aLinhas[nExcel][15],; // 15 O
                                             aLinhas[nExcel][16],; // 16 P
                                             aLinhas[nExcel][17],; // 17 Q
                                             aLinhas[nExcel][18],; // 18 R
                                             aLinhas[nExcel][19],; // 19 S
                                             aLinhas[nExcel][20],; // 20 T
	   	                	                 aLinhas[nExcel][21] ; // 21 U
                                                                  }) //GRAVANDO NA LINHA MANDANDO PARA O EXCEL O ARRAY COM AS LINHAS				
       NEXT 
	   //============================== FINAL IMPRIME LINHA NO EXCEL
Return()    

Static Function IMPRIMELINHA()
			
	nLinha  := nLinha + 1                                       

                //===================== INICIO CRIA VETOR COM POSICAO VAZIA 
   	AADD(aLinhas,{ "", ; // 01 A  
   	               "", ; // 02 B   
   	               "", ; // 03 C   
   	               "", ; // 04 D  
   	               "", ; // 05 E  
   	               "", ; // 06 F  
   	               "", ; // 07 G  
   	               "", ; // 08 H
                   "", ; // 09 I 
                   "", ; // 10 J 
                   "", ; // 11 K 
                   "", ; // 12 L 
                   "", ; // 13 M 
                   "", ; // 14 N 
                   "", ; // 15 O 
                   "", ; // 16 P 
                   "", ; // 17 Q 
                   "", ; // 18 R 
                   "", ; // 19 S 
                   "", ; // 20 T   
   	               ""  ; // 21 U  
   	                   })
	//===================== FINAL CRIA VETOR COM POSICAO VAZIA
	
	//======================================= INICIO ADICIONANDO OS CAMPOS NAS LINHAS ===================
	aLinhas[nLinha][01] := dData                //A
	aLinhas[nLinha][02] := cPlaca               //B
	aLinhas[nLinha][03] := cMotorista           //C
	aLinhas[nLinha][04] := cTransp              //D
	aLinhas[nLinha][05] := nOrdem               //E
	aLinhas[nLinha][06] := nGalpao              //F
	aLinhas[nLinha][07] := cCodGra              //G
	aLinhas[nLinha][08] := cNmGranja            //H
	aLinhas[nLinha][09] := dDtcarreg            //I
    aLinhas[nLinha][10] := dDtsaida             //J
    aLinhas[nLinha][11] := dDtChad              //K
    aLinhas[nLinha][12] := cTempTj              //L
    aLinhas[nLinha][13] := cKmperc              //M
    aLinhas[nLinha][14] := dInipend             //N
    aLinhas[nLinha][15] := dFimpend             //O
    aLinhas[nLinha][16] := dSaidad              //P
    aLinhas[nLinha][17] := nLat                 //Q
    aLinhas[nLinha][18] := nLog                 //R
    aLinhas[nLinha][19] := cBairro              //S
    aLinhas[nLinha][20] := cCidade              //T
    aLinhas[nLinha][21] := cEst                 //U
	
	//======================================= FINAL ADICIONANDO OS CAMPOS NAS LINHAS ===================			
	

RETURN(NIL)		     	

Static Function SalvaXml()

	oExcel:Activate()
	oExcel:GetXMLFile("C:\temp\REL_TEMPO_TRAJETO_FRANGO_VIVO.XML")

Return()

Static Function CriaExcel()              

    oMsExcel := MsExcel():New()
	oMsExcel:WorkBooks:Open("C:\temp\REL_TEMPO_TRAJETO_FRANGO_VIVO.XML")
	oMsExcel:SetVisible( .T. )
	oMsExcel := oMsExcel:Destroy()

Return()       

                                        
Static Function Cabec() 

    oExcel:AddworkSheet(cPlanilha)
	oExcel:AddTable (cPlanilha,cTitulo)                                    
	oExcel:AddColumn(cPlanilha,cTitulo,"Data "                      ,1,1) // 01 A
    oExcel:AddColumn(cPlanilha,cTitulo,"Placa "                     ,1,1) // 02 B
    oExcel:AddColumn(cPlanilha,cTitulo,"Motorista "                 ,1,1) // 03 C    
    oExcel:AddColumn(cPlanilha,cTitulo,"Transportadora "            ,1,1) // 04 D
    oExcel:AddColumn(cPlanilha,cTitulo,"Ordem Carregamento "        ,1,1) // 05 E
  	oExcel:AddColumn(cPlanilha,cTitulo,"Galpao "                    ,1,1) // 06 F
	oExcel:AddColumn(cPlanilha,cTitulo,"Cod. Granja "               ,1,1) // 07 G
	oExcel:AddColumn(cPlanilha,cTitulo,"Descricao "                 ,1,1) // 08 H
	oExcel:AddColumn(cPlanilha,cTitulo,"DT Carregamento Granja "    ,1,1) // 09 I
    oExcel:AddColumn(cPlanilha,cTitulo,"DT Saida Granja "           ,1,1) // 10 J
    oExcel:AddColumn(cPlanilha,cTitulo,"DT Chegada Balanca Adoro "  ,1,1) // 11 K
    oExcel:AddColumn(cPlanilha,cTitulo,"Tempo Trajeto "             ,1,1) // 12 L
    oExcel:AddColumn(cPlanilha,cTitulo,"KM Percorrido "             ,1,1) // 13 M
    oExcel:AddColumn(cPlanilha,cTitulo,"Inicio Pendura "            ,1,1) // 14 N
    oExcel:AddColumn(cPlanilha,cTitulo,"Fim Pendura "               ,1,1) // 15 O
    oExcel:AddColumn(cPlanilha,cTitulo,"DT Saida Balanca Adoro "    ,1,1) // 16 P
    oExcel:AddColumn(cPlanilha,cTitulo,"Latitude "                  ,1,1) // 17 Q
    oExcel:AddColumn(cPlanilha,cTitulo,"Longitude "                 ,1,1) // 18 R
    oExcel:AddColumn(cPlanilha,cTitulo,"Bairro "                    ,1,1) // 19 S
    oExcel:AddColumn(cPlanilha,cTitulo,"Cidade "                    ,1,1) // 20 T
    oExcel:AddColumn(cPlanilha,cTitulo,"Estado "                    ,1,1) // 21 U
	
RETURN(NIL)

Static Function SqlGeral()

	Local cDataIni := DTOS(MV_PAR01)
	Local cDataFin := DTOS(MV_PAR02)                                    
	
    BeginSQL Alias "TRB"
        %NoPARSER%
        SELECT CONVERT(VARCHAR,EAV.DT_ENTRTRANENTRAVEVIVA,103) AS DATA,
            EAV.GN_PLACCAMIENTRAVEVIVA AS PLACA,
            TM.NM_MOTOTRAN AS MOTORISTA,
            F.NM_FORNECEDOR AS TRANSPORTADORA,
            EAV.ID_LOTECRIAEXTEENTRAVEVIVA AS ORDEM_CARREGAMENTO,
            ZFB.ZFB_GALPAO AS GALPAO,ZFB.ZFB_GRACOD AS COD_GRANJA,ZF3.ZF3_GRADES AS DESCRICAO,
            (CONVERT(VARCHAR,EAV.DT_ENTRTRANENTRAVEVIVA,103)+' '+CONVERT(VARCHAR,EAV.DT_ENTRTRANENTRAVEVIVA,8)) AS DT_CARREGAMENTO_GRANJA, 
            (CONVERT(VARCHAR,EAV.DT_SAIDTRANENTRAVEVIVA,103)+' '+CONVERT(VARCHAR,EAV.DT_SAIDTRANENTRAVEVIVA,8)) AS DT_SAIDA_GRANJA ,
            (CONVERT(VARCHAR,EAV.DT_ENTRCAMIENTRAVEVIVA,103)+' '+CONVERT(VARCHAR,EAV.DT_ENTRCAMIENTRAVEVIVA,8)) AS DT_CHEGADA_BALANÇA_ADORO,
            CONVERT(VARCHAR,(EAV.DT_ENTRCAMIENTRAVEVIVA-EAV.DT_SAIDTRANENTRAVEVIVA),8) AS TEMPO_TRAJETO,
            (EAV.QN_KMFINAENTRAVEVIVA - EAV.QN_KMINICENTRAVEVIVA)KM_PERCORRIDO,
            (CONVERT(VARCHAR,EAV.DT_ABERPENDENTRAVEVIVA,103)+' '+CONVERT(VARCHAR,EAV.DT_ABERPENDENTRAVEVIVA,8)) AS INICIO_PENDURA,
            (CONVERT(VARCHAR,EAV.DT_FECHPENDENTRAVEVIVA,103)+' '+CONVERT(VARCHAR,EAV.DT_FECHPENDENTRAVEVIVA,8)) AS FIM_PENDURA,
            (CONVERT(VARCHAR,EAV.DT_SAIDCAMIENTRAVEVIVA,103)+' '+CONVERT(VARCHAR,EAV.DT_SAIDCAMIENTRAVEVIVA,8)) AS DT_SAIDA_BALANÇA_ADORO,
            ZF3.ZF3_LATITU AS LATITUDE,ZF3.ZF3_LONGIT AS LONGITUDE,A2_BAIRRO AS BAIRRO,A2_MUN AS CIDADE, A2_EST AS ESTADO
        FROM [LNKMIMS].[SMART].[dbo].ENTRADA_AVE_VIVA EAV
            INNER JOIN [LNKMIMS].[SMART].[dbo].TRANSPORTADOR_MOTORISTA_TRANSP TMT ON
            TMT.ID_TRANMOTOTRAN = EAV.ID_TRANMOTOTRAN
            INNER JOIN [LNKMIMS].[SMART].[dbo].TRANSPORTADOR_MOTORISTA TM ON
            TM.ID_MOTOTRAN = TMT.ID_MOTOTRAN
            INNER JOIN [LNKMIMS].[SMART].[dbo].FORNECEDOR F ON
            F.ID_FORNECEDOR = TMT.ID_FORNECEDOR_TRANSPORTADOR
            INNER JOIN ZFC010 ZFC ON
            ZFC.ZFC_NUMERO = EAV.ID_LOTECRIAEXTEENTRAVEVIVA COLLATE Latin1_general_CI_AS
            AND ZFC.D_E_L_E_T_ = ''
            INNER JOIN ZFB010 ZFB ON
            ZFB.ZFB_CODIGO = ZFC.ZFC_CODIGO
            AND ZFB.D_E_L_E_T_ = ''
            INNER JOIN ZF3010 ZF3 ON 
            ZF3.ZF3_GRACOD = ZFB.ZFB_GRACOD
            AND ZF3.D_E_L_E_T_ = ''
            INNER JOIN SA2010 SA2 ON
            SA2.A2_COD = ZF3.ZF3_FORCOD
            AND SA2.D_E_L_E_T_ = ''
        WHERE CONVERT(DATE,EAV.DT_ENTRCAMIENTRAVEVIVA) >= %EXP:cDataIni%
        AND CONVERT(DATE,EAV.DT_ENTRCAMIENTRAVEVIVA) <= %EXP:cDataFin%
            
    EndSQl             
		
		
RETURN    
