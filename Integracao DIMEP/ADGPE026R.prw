#INCLUDE "PROTHEUS.CH"  
#INCLUDE "FILEIO.CH"
#INCLUDE "TopConn.CH"  
#INCLUDE "rwmake.ch" 

/*{Protheus.doc} User Function ADGPE026R
	Relatorio para acompanhamento de refeicoes do Dimep totalizando por cafe da manha,almoco,cafe da tarde e janta Relatorio Acessos Refeitorio Dimep para funcionarios Relatorio em Excel.
	@type  Function
	@author William Costa
	@since 03/10/2017
	@version 01
	@history Chamado TI    - William Costa   - 24/09/2019 - ajustado query para nao trazer terceiro
	@history TICKET  224   - William Costa   - 11/11/2020 - Altera��o do Fonte na parte de Funcion�rios, trocar a integra��o do Protheus para a Integra��o do RM
	@history ticket  14365 - Fernando Macieir- 19/05/2021 - Novo Linked Server (de VPSRV17 para DIMEP)
	@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
	@history ticket  75853 - Adriano Savoine - 06/07/2022 - Atualizado o Fonte para Filial 03.
	@history ticket  75853 - Jonathan Carvalho 07/07/2022 - Inclus�o da coluna Ceia.
	@history Ticket  77205 - Adriano Savoine  - 27/07/2022- Alterado o Link de dados de DIMEP para DMPACESSO
*/

User Function ADGPE026R()
	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio para acompanhamento de refeicoes do Dimep totalizando por cafe da manha,almoco,cafe da tarde e janta Relatorio Acessos Refeitorio Dimep para funcionarios Relatorio em Excel.')
	
	Private aSays		:={}
	Private aButtons	:={}   
	Private cCadastro	:= "Relatorio Acessos Refeitorio Dimep"    
	PRIVATE oFontA06	:= TFont():New( "Arial",,10,,.f.,,,,,.f. )
	PRIVATE oFontA09	:= TFont():New( "Arial",,-9,,.f.,,,,,.f. )
	PRIVATE oFontA09b	:= TFont():New( "Arial",,-9,,.t.,,,,,.f. )
	PRIVATE oFontA07	:= TFont():New( "Arial",,12,,.T.,,,,,.f. )
	PRIVATE oPrn		:= TMSPrinter():New()
	Private nOpca		:= 0
	Private cPerg		:= 'ADGPE026R'
	
	//Cria grupo de Perguntas                         
	
	//@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
	//MontaPerg()
	Pergunte(cPerg,.F.)
	 
	//Monta Form Batch - Interface com o Usuario     
	
	AADD(aSays,"Este programa tem a finalidade de Gerar um arquivo Excel " )
	AADD(aSays,"Relatorio Acessos Refeitorio Dimep" )
    
	AADD(aButtons, { 5,.T.,{|o| Pergunte(cPerg,.T.) }})
	AADD(aButtons, { 1,.T.,{|o| nOpca:=1, o:oWnd:End(), Processa({||GPEADGPE026R()},"Gerando arquivo","Aguarde...")    }})
	AADD(aButtons, { 2,.T.,{|o| nOpca:=2, o:oWnd:End() }})
	
	FormBatch( cCadastro, aSays, aButtons )  
	
Return (Nil)  

Static Function GPEADGPE026R()    

	Public oExcel      := FWMSEXCEL():New()
	Public cPath       := 'D:\Totvs\Protheus11_Homolog\protheus_data\system\'
	Public cArquivo    := 'REL_FUNCIONARIOS_DIMEP.XML'
	Public oMsExcel
	Public cPlanilha   := DTOC(MV_PAR03) + ' ate ' + DTOC(MV_PAR04)
    Public cTitulo     := "Relatorio Acessos Refeitorio DIMEP - " + DTOC(MV_PAR03) + ' ate ' + DTOC(MV_PAR04)
    Public cCodProdSql := ''
    Public aLinhas    := {}
   
	BEGIN SEQUENCE
		
		IF .NOT.( ApOleClient("MsExcel") )   // se nao existir o excel sai fora..
		    Alert("N�o Existe Excel Instalado")
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
	Private nCred      := ''
    Private nCredold   := ''
    Private nCafeManha := 0 
    Private nAlmoco    := 0
    Private nCafeTarde := 0
    Private nJantar    := 0
	Private nCeia      := 0
    Private cCcusto    := ''   
    Private cNmCCusto  := ''
    Private cNome      := ''    
    Private cMat       := ''

    SqlGeral() 
	
	DBSELECTAREA("TRB")
		TRB->(DBGOTOP())
		
		nCredold  := TRB->NU_CREDENCIAL
		cCcusto   := TRB->NU_ESTRUTURA
		cNmCCusto := TRB->NM_ESTRUTURA
		cNome     := TRB->NM_PESSOA 
		cMat      := ALLTRIM(TRB->MATRICULA)
		
		WHILE TRB->(!EOF()) 
		
		    IF TRB->NU_CREDENCIAL ==  nCredold
			
				nCafeManha := nCafeManha + TRB->CAFE_MANHA
			    nAlmoco    := nAlmoco    + TRB->ALMOCO
			    nCafeTarde := nCafeTarde + TRB->CAFE_TARDE
			    nJantar    := nJantar    + TRB->JANTAR 
				nCeia      := nCeia      + TRB->CEIA
			    cCcusto    := TRB->NU_ESTRUTURA
			    cNmCCusto  := TRB->NM_ESTRUTURA
			    cNome      := TRB->NM_PESSOA
			    cMat       := TRB->MATRICULA
	            
			ELSE // GERA CABECALHO DO GRUPO DE PRODUTOS
			
			    IMPRIMELINHA()
			    
			    nCredold   := TRB->NU_CREDENCIAL
			    nCafeManha := nCafeManha + TRB->CAFE_MANHA
			    nAlmoco    := nAlmoco    + TRB->ALMOCO
			    nCafeTarde := nCafeTarde + TRB->CAFE_TARDE
			    nJantar    := nJantar    + TRB->JANTAR
				nCeia      := nCeia      + TRB->CEIA
			    cCcusto    := TRB->NU_ESTRUTURA 
			    cNmCCusto  := TRB->NM_ESTRUTURA
			    cNome      := TRB->NM_PESSOA
			    cMat       := TRB->MATRICULA
			    
			ENDIF	
				
			TRB->(dbSkip())    
		
		END //end do while TRB
		TRB->( DBCLOSEAREA() )
		
		IMPRIMELINHA()
		
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
											 aLinhas[nExcel][10] ; // 10 J
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
				   ""  ; // 10 J
   	                   })
	//===================== FINAL CRIA VETOR COM POSICAO VAZIA
	
	//======================================= INICIO ADICIONANDO OS CAMPOS NAS LINHAS ===================
	aLinhas[nLinha][01] := cValToChar(nCredold) //A
	aLinhas[nLinha][02] := cMat                 //B
	aLinhas[nLinha][03] := cNome                //C
	aLinhas[nLinha][04] := cCcusto              //D
	aLinhas[nLinha][05] := cNmCCusto            //E
	aLinhas[nLinha][06] := nCafeManha           //F
	aLinhas[nLinha][07] := nAlmoco              //G
	aLinhas[nLinha][08] := nCafeTarde           //H
	aLinhas[nLinha][09] := nJantar              //I
	aLinhas[nLInha][10] := nCeia                //J
	
	//======================================= FINAL ADICIONANDO OS CAMPOS NAS LINHAS ===================			
	
	nCafeManha := 0
    nAlmoco    := 0
    nCafeTarde := 0
    nJantar    := 0
	nCeia      := 0
    cCcusto    := ''
    cNome      := ''
    cMat       := ''

RETURN(NIL)		     	

Static Function SalvaXml()

	oExcel:Activate()
	oExcel:GetXMLFile("C:\temp\REL_FUNCIONARIOS_DIMEP.XML")

Return()

Static Function CriaExcel()              

    oMsExcel := MsExcel():New()
	oMsExcel:WorkBooks:Open("C:\temp\REL_FUNCIONARIOS_DIMEP.XML")
	oMsExcel:SetVisible( .T. )
	oMsExcel := oMsExcel:Destroy()

Return()       

//Static Function MontaPerg()                                  
//
//	Private bValid	:= Nil 
//	Private cF3		:= Nil
//	Private cSXG	:= Nil
//	Private cPyme	:= Nil
//	
//    PutSx1(cPerg,'01','Funcionario de      ?','','','mv_ch1','C',11,0,0,'G',bValid,cF3 ,cSXG,cPyme,'MV_PAR01')
//	PutSx1(cPerg,'02','Funcionario Ate     ?','','','mv_ch2','C',11,0,0,'G',bValid,cF3 ,cSXG,cPyme,'MV_PAR02')
//	PutSx1(cPerg,'03','Data Refeitorio De  ?','','','mv_ch3','D',08,0,0,'G',bValid,cF3 ,cSXG,cPyme,'MV_PAR03')
//	PutSx1(cPerg,'04','Data Refeitorio Ate ?','','','mv_ch4','D',08,0,0,'G',bValid,cF3 ,cSXG,cPyme,'MV_PAR04')
//	Pergunte(cPerg,.F.)
//	
//Return Nil            
                                
Static Function Cabec() 

    oExcel:AddworkSheet(cPlanilha)
	oExcel:AddTable (cPlanilha,cTitulo)                                    
	oExcel:AddColumn(cPlanilha,cTitulo,"Num Credencial "      ,1,1) // 01 A
    oExcel:AddColumn(cPlanilha,cTitulo,"Num Matricula"        ,1,1) // 02 B
    oExcel:AddColumn(cPlanilha,cTitulo,"Nome "                ,1,1) // 03 C    
    oExcel:AddColumn(cPlanilha,cTitulo,"Cod CC "              ,1,1) // 04 D
    oExcel:AddColumn(cPlanilha,cTitulo,"Centro de Custo "     ,1,1) // 05 E
  	oExcel:AddColumn(cPlanilha,cTitulo,"Total Cafe da Manha " ,1,1) // 06 F
	oExcel:AddColumn(cPlanilha,cTitulo,"Total Almoco "        ,1,1) // 07 G
	oExcel:AddColumn(cPlanilha,cTitulo,"Total Cafe da Tarde " ,1,1) // 08 H
	oExcel:AddColumn(cPlanilha,cTitulo,"Total Jantar "        ,1,1) // 09 I
	oExcel:AddColumn(cPlanilha,cTitulo,"Total Ceia "          ,1,1) // 10 J
	
RETURN(NIL)

Static Function SqlGeral()

	Local nFil     := 0                                   
	Local cDataIni := DTOS(MV_PAR03)
	Local cDataFin := DTOS(MV_PAR04)
	
	IF CEMPANT == '01' .AND. xFilial("SRA") == '02'
	
		nFil   := 9      //Emresa Adoro codigo da filial de Varzea no Dimep

	ELSEIF CEMPANT == '01' .AND. xFilial("SRA") == '03'	
	
		nFil   := 10        //Empresa Adoro codigo da filial de S�o Carlos ticket  75853 - Adriano Savoine - 06/07/2022
		
	ELSEIF CEMPANT == '02' .AND. xFilial("SRA") == '01'	
	
		nFil   := 17     //Empresa Ceres codigo da filial de Varzea	

	ENDIF	

	IF nFil = 9 .OR. nFil = 17
	// *** inicio chamado TI 24/09/2019
		BeginSQL Alias "TRB"
				%NoPARSER%
				SELECT LOG_ACESSO.NU_CREDENCIAL,
						LOG_ACESSO.NU_MATRICULA AS MATRICULA,
						LOG_ACESSO.NM_PESSOA,
						NU_ESTRUTURA,
						LOG_ACESSO.NM_ESTRUTURA,
						CASE WHEN CONVERT(VARCHAR(11),DT_REQUISICAO,114) >= '03:30:00.000' AND CONVERT(VARCHAR(11),DT_REQUISICAO,114) <= '08:01:00.000' THEN 1 ELSE 0 END AS CAFE_MANHA,
						CASE WHEN CONVERT(VARCHAR(11),DT_REQUISICAO,114) >= '09:45:00.000' AND CONVERT(VARCHAR(11),DT_REQUISICAO,114) <= '13:31:00.000' THEN 1 ELSE 0 END AS ALMOCO,
						CASE WHEN CONVERT(VARCHAR(11),DT_REQUISICAO,114) >= '14:45:00.000' AND CONVERT(VARCHAR(11),DT_REQUISICAO,114) <= '17:01:00.000' THEN 1 ELSE 0 END AS CAFE_TARDE,
						CASE WHEN CONVERT(VARCHAR,DT_REQUISICAO,24) >= '18:00:00' AND CONVERT(VARCHAR,DT_REQUISICAO,24) <= '23:59:59' THEN 1 
							WHEN CONVERT(VARCHAR,DT_REQUISICAO,24) >= '00:00:00' AND CONVERT(VARCHAR,DT_REQUISICAO,24) <= '01:00:00' THEN 1 
						ELSE 0 END AS JANTAR,
						0 AS CEIA
					FROM [DMPACESSO].[DMPACESSOII].[DBO].[LOG_ACESSO] AS LOG_ACESSO 
					INNER JOIN  [DMPACESSO].[DMPACESSOII].[DBO].[ESTRUTURA_ORGANIZACIONAL] AS ESTRUTURA_ORGANIZACIONAL
							ON ESTRUTURA_ORGANIZACIONAL.CD_ESTRUTURA_ORGANIZACIONAL = LOG_ACESSO.CD_ESTRUTURA
							AND CD_ESTRUTURA_RELACIONADA                             = %EXP:nFil% // codigo da filial no Dimep
					INNER JOIN [DMPACESSO].[DMPACESSOII].[DBO].[PESSOA]
							ON PESSOA.NU_MATRICULA                                  = LOG_ACESSO.NU_MATRICULA
					INNER JOIN [DMPACESSO].[DMPACESSOII].[DBO].[PERFIL_ACESSO]
							ON PERFIL_ACESSO.CD_PERFIL_ACESSO                       = PESSOA.CD_PERFIL_ACESSO
							AND (LEFT(PERFIL_ACESSO.NM_PERFIL_ACESSO,6)              < '102900'
							OR LEFT(PERFIL_ACESSO.NM_PERFIL_ACESSO,6)               > '102999') 
						WHERE CD_GRUPO                                             = 1          // Refeitorio 
							AND LOG_ACESSO.NU_DATA_REQUISICAO                       >= %EXP:cDataIni%
							AND LOG_ACESSO.NU_DATA_REQUISICAO                       <= %EXP:cDataFin%
							AND LOG_ACESSO.NU_MATRICULA                             >= %EXP:MV_PAR01%
							AND LOG_ACESSO.NU_MATRICULA                             <= %EXP:MV_PAR02%
							AND CD_VISITANTE                                        IS NULL
							AND CD_AREA_ORIGEM                                       = 2              // Externo
							AND CD_AREA_DESTINO                                      = 3              // Refeitorio
							AND NU_EQUIPAMENTO                                      IN (1,2)          // EQUIPAMENTO
							AND (TP_EVENTO                                           = '27'           // Acesso Master
							OR TP_EVENTO                                            = '10'           // Acesso Concluido
							OR TP_EVENTO                                            = '12')          // Acesso Batch
						
				ORDER BY LOG_ACESSO.NU_MATRICULA
							
		EndSQl  
	ELSE
				BeginSQL Alias "TRB"
				%NoPARSER%
				SELECT LOG_ACESSO.NU_CREDENCIAL,
						LOG_ACESSO.NU_MATRICULA AS MATRICULA,
						LOG_ACESSO.NM_PESSOA,
						NU_ESTRUTURA,
						LOG_ACESSO.NM_ESTRUTURA,
						CASE WHEN CONVERT(VARCHAR(11),DT_REQUISICAO,114) >= '03:30:00.000' AND CONVERT(VARCHAR(11),DT_REQUISICAO,114) <= '08:01:00.000' THEN 1 ELSE 0 END AS CAFE_MANHA,
						CASE WHEN CONVERT(VARCHAR(11),DT_REQUISICAO,114) >= '09:45:00.000' AND CONVERT(VARCHAR(11),DT_REQUISICAO,114) <= '13:31:00.000' THEN 1 ELSE 0 END AS ALMOCO,
						CASE WHEN CONVERT(VARCHAR(11),DT_REQUISICAO,114) >= '14:45:00.000' AND CONVERT(VARCHAR(11),DT_REQUISICAO,114) <= '17:01:00.000' THEN 1 ELSE 0 END AS CAFE_TARDE,
						CASE WHEN CONVERT(VARCHAR(11),DT_REQUISICAO,114) >= '17:30:00.000' AND CONVERT(VARCHAR(11),DT_REQUISICAO,114) <= '21:01:00.000' THEN 1 ELSE 0 END AS JANTAR,
						CASE WHEN CONVERT(VARCHAR,DT_REQUISICAO,24) >= '23:00:00' AND CONVERT(VARCHAR,DT_REQUISICAO,24) <= '23:59:59' THEN 1 
							WHEN CONVERT(VARCHAR,DT_REQUISICAO,24) >= '00:00:00' AND CONVERT(VARCHAR,DT_REQUISICAO,24) <= '03:01:00' THEN 1 
						ELSE 0 END AS CEIA
					FROM [DMPACESSO].[DMPACESSOII].[DBO].[LOG_ACESSO] AS LOG_ACESSO 
					INNER JOIN  [DMPACESSO].[DMPACESSOII].[DBO].[ESTRUTURA_ORGANIZACIONAL] AS ESTRUTURA_ORGANIZACIONAL
							ON ESTRUTURA_ORGANIZACIONAL.CD_ESTRUTURA_ORGANIZACIONAL = LOG_ACESSO.CD_ESTRUTURA
							AND CD_ESTRUTURA_RELACIONADA                             = %EXP:nFil% // codigo da filial no Dimep
					INNER JOIN [DMPACESSO].[DMPACESSOII].[DBO].[PESSOA]
							ON PESSOA.NU_MATRICULA                                  = LOG_ACESSO.NU_MATRICULA
					INNER JOIN [DMPACESSO].[DMPACESSOII].[DBO].[PERFIL_ACESSO]
							ON PERFIL_ACESSO.CD_PERFIL_ACESSO                       = PESSOA.CD_PERFIL_ACESSO
							AND (LEFT(PERFIL_ACESSO.NM_PERFIL_ACESSO,6)              < '102900'
							OR LEFT(PERFIL_ACESSO.NM_PERFIL_ACESSO,6)               > '102999') 
						WHERE CD_GRUPO                                             = 1          // Refeitorio 
							AND LOG_ACESSO.NU_DATA_REQUISICAO                       >= %EXP:cDataIni%
							AND LOG_ACESSO.NU_DATA_REQUISICAO                       <= %EXP:cDataFin%
							AND LOG_ACESSO.NU_MATRICULA                             >= %EXP:MV_PAR01%
							AND LOG_ACESSO.NU_MATRICULA                             <= %EXP:MV_PAR02%
							AND CD_VISITANTE                                        IS NULL
							AND CD_AREA_ORIGEM                                       = 2              // Externo
							AND CD_AREA_DESTINO                                      = 3              // Refeitorio
							AND NU_EQUIPAMENTO                                       = 29             // EQUIPAMENTO
							AND (TP_EVENTO                                           = '27'           // Acesso Master
							OR TP_EVENTO                                             = '10'           // Acesso Concluido
							OR TP_EVENTO                                             = '12')          // Acesso Batch
						
				ORDER BY LOG_ACESSO.NU_MATRICULA
							
		EndSQl  
	ENDIF         
    // *** final chamado TI 24/09/2019
RETURN()    
