#Include 'Protheus.ch'
#include "rwmake.ch"
#include "topconn.ch"
#INCLUDE "FWMVCDEF.CH"
#INCLUDE "FWMBROWSE.CH"
#INCLUDE "FILEIO.CH"


/*/{Protheus.doc} User Function F050ROT
	Ponto de entrada que permite modificar os itens de menu do browse de sele��o de t�tulos a pagar , por meio de edi��o da vari�vel aRotina (passada como par�metro no ponto de entrada). 
	O retorno deve conter a variavel aRotina customizada, com as op��es que podem ser selecionadas. 
	@author Ricardo Lima
    @since 12/07/2018
	@version 01
	@history Chamado 050958 - FWNM          - 19/08/2019 - Tela para alteracao de campos controlados (SISPAG) 
	@history Chamado 050958 - FWNM          - 20/08/2019 - Desenvolvimento funcao VldE2CODBAR
	@history Chamado T.I    - WILLIAM COSTA - 30/08/2019 - Adicionado para poder altera a P.A tambem
	@history Chamado 050958 - FWNM          - 04/09/2019 - Permitir Tipo de Imposto vazio
	@history Chamado 043974 - WILLIAM COSTA - 18/09/2019 - Adicionado o campo de Codigo do Imposto
	@history Chamado 052897 - WILLIAM COSTA - 28/10/2019 - Adicionado os campos cnpj, nome benefeciario, banco, agencia, digito agencia, conta, digito da conta
	@history Chamado T.I    - ABEL BABINI   - 14/07/2020 - Ajustes na chamada da fun��o para vers�o 12.1.27
	@history Ticket 18035 - Leonardo P. Monteiro - 27/12/2021 - Ajustes na rotina e separa��o referente ao ponto de entrada F050ROT.
	@history ticket 85390 - Antonio - 31/01/2023 -Validacao fontes v33 - dic. banco de dados.       
/*/

User Function F050ROT()

Local aRotina := ParamIxb

		// Chamado T.I    - ABEL BABINI   - 14/07/2020 - Ajustes na chamada da fun��o para vers�o 12.1.27
    aAdd( aRotina, { "Consulta Aprova��o" , "U_ADFIN061P(SE2->E2_FILIAL , SE2->E2_FORNECE, SE2->E2_LOJA, SE2->E2_PREFIXO, SE2->E2_NUM, SE2->E2_PARCELA, SE2->E2_TIPO)" , 0 , 8 , 0 , .F. } )
    
		// Chamado T.I    - ABEL BABINI   - 14/07/2020 - Ajustes na chamada da fun��o para vers�o 12.1.27
    // Chamado n. 050958 - Tela para alteracao de campos controlados (SISPAG)
    aAdd( aRotina, { "Altera T�tulos RH e PA" , "u_AltCodBar()" , 0 , 8 , 0 , .F. } ) // CHAMADO T.I 30/08/2019
	aAdd( aRotina, { "Importa��o de NDF�s"    , "u_ADFIN117P()" , 0 , 8 , 0 , .F. } ) // CHAMADO T.I 30/08/2019
Return aRotina                                        

/*/{Protheus.doc} User Function AltCodBar
	Tela para alteracao de campos controlados
	@author Fernando Macieira
    @since 08/09/2019
	@version 01
/*/

User Function AltCodBar()

	Local lOk     := .F.
	Local oBtnLib := Array(02)
	Local oCampos := Array(10)
	Local aTpImp  := {}
	Local cTpImp  := AllTrim(SE2->E2_XTIPOIM)
	Local cCodBar := SE2->E2_CODBAR
	Local cCodImp := SE2->E2_XCODPAG
    Local cCnpj   := SE2->E2_CNPJ
	Local cNomCta := SE2->E2_NOMCTA
	Local cBanco  := SE2->E2_BANCO
	Local cAgen   := SE2->E2_AGEN
	Local cDigAg  := SE2->E2_DIGAG
	Local cNocta  := SE2->E2_NOCTA
	Local cDigCta := SE2->E2_DIGCTA

	Local cOrigem := AllTrim(SE2->E2_ORIGEM)
	
	If cOrigem <> "GPEM670" .AND. ALLTRIM(SE2->E2_TIPO) <> 'PA' // CHAMADO T.I 30/08/2019
		msgAlert("Este t�tulo n�o foi gerado pelo RH OU n�o � PA... (" + SE2->E2_PREFIXO + "/" + SE2->E2_NUM + ") - Altera��o n�o permitida!")
	
	Else  
	
		aTpImp  := CBOSX3("E2_XTIPOIM")
		
		DEFINE MSDIALOG oDlgLib TITLE "Altera T�tulos RH / P.A - Voc� est� alterando: " + SE2->E2_PREFIXO + "/" + SE2->E2_NUM FROM 0,0 TO 350,500  OF oMainWnd PIXEL
		
			@ 005,001 Say "Codigo Barra:" of oDlgLib PIXEL
			@ 005,060 msGet oCampos[01] Var @cCodBar of oDlgLib PIXEL SIZE 170,10 Valid VldE2CODBAR(@cCodBar)
		
			@ 020,001 Say "Codigo Imposto:" of oDlgLib PIXEL //043974 || OS 047749 || FINANCAS || ANA || 8384 || SISPAG - WILLIAM COSTA - 18/0/2019
			@ 020,060 msGet oCampos[02] Var @cCodImp of oDlgLib PIXEL SIZE 170,10 //043974 || OS 047749 || FINANCAS || ANA || 8384 || SISPAG - WILLIAM COSTA - 18/0/2019

			@ 035,001 Say "Tipo Impostos:" of oDlgLib PIXEL
			@ 035,060 ComboBox oCampos[03] Var cTpImp of oDlgLib PIXEL ITEMS aTpImp SIZE 170,10 

			@ 050,001 Say "CNPJ:" of oDlgLib PIXEL 
			@ 050,060 msGet oCampos[04] Var @cCnpj of oDlgLib PIXEL SIZE 170,10 

			@ 065,001 Say "Nome Beneficiario:" of oDlgLib PIXEL 
			@ 065,060 msGet oCampos[05] Var @cNomCta of oDlgLib PIXEL SIZE 170,10 

			@ 080,001 Say "Banco:" of oDlgLib PIXEL 
			@ 080,060 msGet oCampos[06] Var @cBanco of oDlgLib PIXEL SIZE 170,10 

			@ 095,001 Say "Num Agencia:" of oDlgLib PIXEL 
			@ 095,060 msGet oCampos[07] Var @cAgen of oDlgLib PIXEL SIZE 170,10 

			@ 110,001 Say "Dig Agencia:" of oDlgLib PIXEL 
			@ 110,060 msGet oCampos[08] Var @cDigAg of oDlgLib PIXEL SIZE 170,10 

			@ 125,001 Say "Num Conta:" of oDlgLib PIXEL 
			@ 125,060 msGet oCampos[09] Var @cNocta of oDlgLib PIXEL SIZE 170,10 

			@ 140,001 Say "Dig Conta:" of oDlgLib PIXEL 
			@ 140,060 msGet oCampos[10] Var @cDigCta of oDlgLib PIXEL SIZE 170,10 

			@ 157,010   BUTTON oBtnLib[01] PROMPT "Confirma"     of oDlgLib   SIZE 88,10 PIXEL ACTION (lOk := .T. , oDlgLib:End())
			@ 157,129   BUTTON oBtnLib[02] PROMPT "Cancela"      of oDlgLib   SIZE 88,10 PIXEL ACTION (lOk := .F. , oDlgLib:End())
		
		ACTIVATE MSDIALOG oDlgLib CENTERED
		
		If lOk
			If msgYesNo("Confirma altera��o do t�tulo: " + SE2->E2_PREFIXO + "/" + SE2->E2_NUM + " ?")
				RecLock("SE2", .f.)

					SE2->E2_CODBAR  := cCodBar
					SE2->E2_XTIPOIM := cTpImp
					SE2->E2_XCODPAG := cCodImp //043974 || OS 047749 || FINANCAS || ANA || 8384 || SISPAG - WILLIAM COSTA - 18/0/2019
					SE2->E2_CNPJ    := cCnpj 
					SE2->E2_NOMCTA  := cNomCta 
					SE2->E2_BANCO   := cBanco 
					SE2->E2_AGEN    := cAgen 
					SE2->E2_DIGAG   := cDigAg 
					SE2->E2_NOCTA   := cNocta 
					SE2->E2_DIGCTA  := cDigCta 

				SE2->( msUnLock() )
				msgInfo("T�tulo: " + SE2->E2_PREFIXO + "/" + SE2->E2_NUM + " alterado com sucesso!")
			EndIf
		Endif
		
	EndIf

Return

/*/{Protheus.doc} Static Function CBOSX3
	Carregar Valores de Combo Box do Tipo Imposto
	@author Fernando Macieira
    @since 20/08/2019
	@version 01
/*/

Static Function CBOSX3(cCampo,cTipo)

	//Local aSaveSX3 := SX3->( GetArea() )
	Local aRet := {}
                            
	Default cTipo := ";"
	
	//@history Ticket 70142  - Rodrigo / Flek Solution - 18/07/2022 - Ajustes Dic. de dados no Banco
	aRet := StrToKarr(AllTrim(GetSX3Cache( cCampo, 'X3_CBOX')), cTipo) 
	/*
	SX3->( dbSetOrder(2) )
	If SX3->( dbSeek(cCampo) )
		aRet := StrToKarr(AllTrim(SX3->X3_CBOX), cTipo) 
	Endif
	*/
	aAdd(aRet, "") // Chamado n. 050958 - Permitir Tipo de Imposto vazio - fwnm - 04/09/2019 

	//RestArea( aSaveSX3 )
	
Return aRet

/*/{Protheus.doc} Static Function VldE2CODBAR(cCodBar)
	Valida��o do Campo de Codigo de Barras do titulo do Contas a Pagar
	@author Fernando Macieira
    @since 20/08/2019
	@version 01
/*/

Static Function VldE2CODBAR(cCodBar)

	Local lRet := .f.
	
	// Variaveis de memoria
	M->E2_CODBAR  := AllTrim(cCodBar)
	M->E2_SALDO   := SE2->E2_SALDO
	M->E2_ACRESC  := SE2->E2_ACRESC
	M->E2_DECRESC := SE2->E2_DECRESC

	IF ALLTRIM(cCodBar) <> ''
	
		cCodBar := U_CONVLD()
		M->E2_CODBAR := cCodBar
		
		cCodBar := U_ChkVlBol()
		M->E2_CODBAR := cCodBar                                                                 
		
		lRet := VldCodBar(cCodBar)
		
		If lRet
			lRet := EXECBLOCK('CODBAR',.T.)
		EndIf
	
	ELSE

		lRet := .T.


	ENDIF

Return lRet



