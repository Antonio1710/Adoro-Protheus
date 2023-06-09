#INCLUDE "PROTHEUS.CH" 
#INCLUDE "TOPCONN.CH"  
#INCLUDE "AP5MAIL.CH"                                    
/*/{Protheus.doc} ADLOG030P
	Programa de WebService - desenvolvido para Fazer a leitura
	do Webservice CTAPLUS e gravar na tabela ZBB do protheus.  
	Realizar a Leitura Manualmente.                           
	@type  Static Function
	@author WILLIAM COSTA
	@since 20/06/2016
	@version 01
	@history Everson, 27/02/2020. Tratamento para marca��o do sistema origem do lan�amento.
	@history Everson, 11/03/2020. Ch. 053926 Alterado o �ndice de busca da rotina.
	@history Everson, 17/06/2020. Ch. 058732 Tratamento para o fonte utilizar a mesma fun��o que est� no fonte ADLOG022P.
	@history Ticket 70142   - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
	/*/
User Function ADLOG030P() // U_ADLOG030P()

	//Vari�veis.       
	Local aSays		    := {}
	Local aButtons	    := {}   
	Local cCadastro	    := "ADLOG030P - Leitura Manual de Ol�o CTAPLUS"    
	Local cPerg		    := 'ADLOG030P' 

	//	
	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Programa de WebService - desenvolvido para Fazer a leitura do Webservice CTAPLUS e gravar na tabela ZBB do protheus Realizar a Leitura Manualmente.')
	
	//+------------------------------------------------+
	//|Cria grupo de Perguntas                         |
	//+------------------------------------------------+
	 //@history Ticket 70142  - Edvar / Flek Solution - 07/04/2022 - Retirada de fun��o PUTSX1
	 //MontaPerg(cPerg)
	 Pergunte(cPerg,.T.)

	 //+-----------------------------------------------+
	//|Monta Form Batch - Interface com o Usuario     |
	//+-----------------------------------------------+
	Aadd(aSays,"Leitura Manual de Ol�o CTAPLUS. " )
	
	Aadd(aButtons, { 5,.T.,{|o| Pergunte(cPerg,.T.) }})
	//Aadd(aButtons, { 1,.T.,{|o| o:oWnd:End(), MsAguarde({|| Static Call(ADLOG022P,impDados,MV_PAR01,MV_PAR02) },"Fun��o ADLOG030P(LERCTAPLUS)","Obtendo registros...")}})
	
	//@history Ticket 70142  - Edvar   / Flek Solution - 23/03/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
	Aadd(aButtons, { 1,.T.,{|o| o:oWnd:End(), MsAguarde({|| u_LOG022A0( MV_PAR01,MV_PAR02 ) },"Fun��o ADLOG030P(LERCTAPLUS)","Obtendo registros...")}})

	Aadd(aButtons, { 2,.T.,{|o| o:oWnd:End() }})
	  
	FormBatch( cCadastro, aSays, aButtons )  

Return Nil     
/*/{Protheus.doc} MontaPerg
	(long_description)
	@type  Static Function
	@author 
	@since
	@version 01
	/*/
//Static Function MontaPerg(cPerg) 
//
//	//Vari�veis.                             
//	Local bValid := Nil                                                                                                                    
//	Local cF3	 := Nil
//	Local cSXG	 := Nil
//	Local cPyme	 := Nil
//	
//	//
//    PutSx1(cPerg,'01','Data Fechamento Ini ?','','','mv_ch01','D',08,0,0,'G',bValid,cF3,cSXG,cPyme,'MV_PAR01')
//    PutSx1(cPerg,'02','Data Fechamento Fim ?','','','mv_ch02','D',08,0,0,'G',bValid,cF3,cSXG,cPyme,'MV_PAR02')
//	Pergunte(cPerg,.T.)
//	
//Return Nil
