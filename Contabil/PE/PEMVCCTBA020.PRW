#include 'protheus.ch'
#include 'parmtype.ch'

/*/{Protheus.doc} CTBA020()
	Ponto de Entrada MVC - CTBA02
	@type  Function User PE
	@author user
	@since 11/12/2018
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@History Chamado n. 044316 (SIG VELHO x PRODUCAO) Fernando Macieira
	@History Ticket  83605 - 18/11/2022 - Antonio Domingos - Incluido Alias CT1-> na função FieldPos() - exclusão de conta contábil e Habilitado browse do campo CT1_XMSEXP
/*/	
User Function CTBA020()

	Local aParam     := PARAMIXB
	Local xRet       := .T.
	Local oObj       := ''
	Local cIdPonto   := ''
	Local cIdModel   := ''
	Local lIsGrid    := .F.
	Local nLinha     := 0
	Local nQtdLinhas := 0
	Local cClasse 	 := ''
	Local cMsg       := ''
	
	If aParam <> NIL
		
		oObj       := aParam[1]
		cIdPonto   := aParam[2]
		cIdModel   := aParam[3]
		lIsGrid    := ( Len( aParam ) > 3 )
		
		If cIdPonto == 'MODELVLDACTIVE'
		    // Ticket  83605 - 18/11/2022 - Antonio Domingos 
			If CT1->(FieldPos("CT1_XMSEXP")) <= 0
				
				xRet := .f.
				
				Aviso(	"PEMVCCTBA020-01",;
				"Campo CT1_XMSEXP não existente..." + CRLF +;
				"Solicite a criação deste campo ao Administrador do sistema para prosseguir...",;
				{ "&Retorna" },,;
				"Conta Contábil x SIG" )
				
			EndIf
				
		ElseIf cIdPonto == 'MODELCOMMITNTTS'
	
			RecLock("CT1", .f.)
				CT1->CT1_XMSEXP := ""
			CT1->( msUnLock() )
	
		EndIf
			
	EndIf

Return xRet
