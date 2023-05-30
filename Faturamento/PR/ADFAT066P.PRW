#include "protheus.ch"
#include "topconn.ch"
#include "FWMVCDef.ch"
#include 'parmtype.ch'
#include 'prtopdef.ch'
#INCLUDE "RWMAKE.CH"
#INCLUDE "TOTVS.CH"
#INCLUDE "TBICONN.CH"
#Include 'TOTVS.ch'
#include 'fwbrowse.ch'   
#include 'rptdef.ch'
#include 'MSMGADD.CH'

#DEFINE  CRLF 		Chr(13)+Chr(10)

/*/{Protheus.doc} ADFAT066P
    Gestão de Canhotos
    @type  Function
    @author Antonio Domingos
    @since 21/03/2023
    @version version
    @param param_name, param_type, param_deSC5
    @return return_var, return_type, return_deSC5iption
    @example
    (examples)
    @see (links_or_references)
    @history ticket 90508 - Antonio Domingos - 03/04/2023 - Otimização da rotina de Canhotos 
    @history ticket 92712 - Jonathan Carvalho - 26/04/2023 - Correção do ErrorLog
    /*/
//---------------------------------------------------------------------
User Function ADFAT066P() 

Local cTxtIntro	   := "Rotina responsável pela Gestão de Canhotos"
Local aInfoCustom 	:= {}
//Variáveis.
//Everson - 20/02/2023 - ticket 79230.
Local cUsr1 := GetMv("MV_#CANHT1", , "")
Local cUsr2 := GetMv("MV_#CANHT2", , "")
Private cAssunto   := "Gestão de Canhotos"
Private oSelf
Private oProcess
Private oBrowse
Private oTempTable
Private bProcess 	   := {|oSelf| U_FAT066PP(oSelf) }
Private cPerg 	   := "ADFAT066P"

If !(__cUserId $cUsr1) .And. !(__cUserId $cUsr2)
	MsgStop("Usuário sem premissão de acesso à rotina.", "Função ADFAT066P-Gestão de Canhotos")
	Return Nil
EndIf
    
_cNomeEmpFil := ALLTRIM(SM0->M0_NOME)+'-'+ALLTRIM(SM0->M0_FILIAL)
oProcess := tNewProcess():New("ADFAT066","Gestão de Canhotos",bProcess,cTxtIntro,cPerg,aInfoCustom, .T.,5, "Canhotos", .T. )

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio de Horas Disponiveis x Realizadas')

Return

/*/{Protheus.doc} FAT066PP
    FAT066PP processamento da rotina Gestão de Canhotos
    @type  Function User
    @author Antonio Domingos
    @since 27/03/2023
    @version versionC5_CANHOTO
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FAT066PP(oProcess)

    Local aArea   := FWGetArea()
    Local aStruSC5 := {}
    Local aColunas := {}
    Local aPesquisa := {}
    Private aRotina := {}
    Private _cAlias1 
	Private cTitulo := "Gestão de Canhotos"
    Private aColumns := {}
    Private cMarca := "X" //Mark()
    Private lInverte := .F.    
    Private lMarca := .T.
    Private _cFiltro := "I"
    
    //Definicao do menu
    aRotina := MenuDef()

    //Cria Tabela Temporaria
    U_FAT066PY(aStruSC5)
    
    //Criar Arquivo de Trabalho
    U_FAT066PB(_cAlias1,oProcess,_cFiltro)

    //Definindo as colunas que serão usadas no browse
    aAdd(aColunas, {"Filial"    , "C5_FILIAL" ,"C",TAMSX3('C5_FILIAL')[1], 0, "@!"})
    aAdd(aColunas, {"Dt.Entrega", "C5_DTENTR" ,"D",TAMSX3('C5_DTENTR')[1], 0, "@D"})
    aAdd(aColunas, {"Nota"      , "C5_NOTA"   ,"C",TAMSX3('C5_NOTA')[1], 0, "@!"})
    aAdd(aColunas, {"Pedido"    , "C5_NUM"    ,"C",TAMSX3('C5_PLACA')[1], 0, "@!"})
   	aAdd(aColunas, {"Placa"     , "C5_PLACA"  ,'C',TAMSX3('C5_PLACA')[1],0,"@!"})
	aAdd(aColunas, {"Nome Cli"  , "C5_NOMECLI",'C',TAMSX3('C5_NOMECLI')[1],0,"@!"})
	aAdd(aColunas, {"Cidade"    , "C5_CIDADE" ,'C',TAMSX3('C5_CIDADE')[1],0,"@!"})
	aAdd(aColunas, {"Estado"    , "C5_EST"    ,'C',TAMSX3('C5_EST')[1],0,"@!"})
	aAdd(aColunas, {"Roteiro"   , "C5_ROTEIRO",'C',TAMSX3('C5_ROTEIRO')[1],0,"@!"})
	aAdd(aColunas, {"Usuario"   , "C5_CANHUSU",'C',TAMSX3('C5_CANHUSU')[1],0,"@!"})
	aAdd(aColunas, {"Data"      , "C5_CANHDAT",'D',TAMSX3('C5_CANHDAT')[1],0,"@!"})
	aAdd(aColunas, {"Hora"      , "C5_CANHHOR",'C',TAMSX3('C5_CANHHOR')[1],0,"@D"})
	aAdd(aColunas, {"Motivo"    , "C5_CANHMOT",'C',TAMSX3('C5_CANHMOT')[1],0,"@!"})
    aAdd(aColunas, {"Canhoto"   , "C5_CANHOTO","C",TAMSX3('C5_CANHOTO')[1],0,"@!"})

    //Adiciona os indices para pesquisar
    /*
        [n,1] Título da pesquisa
        [n,2,n,1] LookUp
        [n,2,n,2] Tipo de dados
        [n,2,n,3] Tamanho
        [n,2,n,4] Decimal
        [n,2,n,5] Título do campo
        [n,2,n,6] Máscara
        [n,2,n,7] Nome Físico do campo - Opcional - é ajustado no programa
        [n,3] Ordem da pesquisa
        [n,4] Exibe na pesquisa
    */
    aAdd(aPesquisa, {"Filial+Nota", {{"", "C", 9, 0, "Nota", "@!", "C5_NOTA"}} } )
    aAdd(aPesquisa, {"Filial+Pedido", {{"", "C", 6, 0, "Pedido", "@!", "C5_NUM"}} } ) 
    aAdd(aPesquisa, {"Filial+Data de Entrega", {{"", "D", 8, 0, "Dt Entrega", "@!", "C5_DTENTR"}} } ) 
    aAdd(aPesquisa, {"Filial+Placa", {{"", "C", 7, 0, "Placa", "@!", "C5_PLACA"}} } )

	//Criando o browse da temporária
    oBrowse:= FWMarkBrowse():New()
	oBrowse:SetAlias(_cAlias1)
    oBrowse:SetTemporary(.T.)
    oBrowse:SetFields(aColunas)
    oBrowse:DisableDetails()
    oBrowse:SetDescription(cTitulo)
    oBrowse:SetSeek(.T., aPesquisa)
    oBrowse:SetFieldMark("C5_CMARK")
	oBrowse:SetMark(cMarca, _cAlias1, "C5_CMARK")
    oBrowse:SetAfterMark({|| U_FAT066PU(_cAlias1)})
    oBrowse:SetAllMark( { || U_FAT066PI(_cAlias1,cMarca,lMarcar, lInvert) })
	oBrowse:bAllMark := { || U_FAT066PT(_cAlias1,oBrowse:Mark(),lMarcar := !lMarcar,.F. ), oBrowse:Refresh(.T.)  }
    oBrowse:AddLegend("C5_CANHOTO =  'X' ","BR_VERMELHO" )
	oBrowse:AddLegend("C5_CANHOTO <> 'X' ","BR_VERDE"    )
    oBrowse:Activate()
    oTempTable:delete()
    FWRestArea(aArea)
Return(oProcess)


/*/{Protheus.doc} nomeStaticFunction
    (long_deSC5iption)
    @type  Static Function
    @author Antonio Domingo
    @since 21/03/2023
    @version version
    @param param_name, param_type, param_deSC5
    @return return_var, return_type, return_deSC5iption
    @example
    (examples)
    @see (links_or_references)
/*/
Static Function MenuDef()
    Local aRotina := {}
    //Adicionando opcoes do menu
	ADD OPTION aRotina TITLE "Visualizar" ACTION "U_FAT066PV(_cAlias1)"   OPERATION 1 ACCESS 0 
    ADD OPTION aRotina TITLE "Motivo"     ACTION "U_FAT066PM(_cAlias1)" OPERATION 3 ACCESS 0 
    ADD OPTION aRotina TITLE "Quantidade" Action "U_FAT066PQ(_cAlias1)" OPERATION 3 ACCESS 0 
    ADD OPTION aRotina TITLE "Relatorio"  ACTION "U_ADFAT006R()"        OPERATION 4 ACCESS 0 
    ADD OPTION aRotina TITLE "Parametros"  ACTION "U_FAT066PX(oBrowse,oProcess,_cAlias1)"        OPERATION 4 ACCESS 0 
    ADD OPTION aRotina TITLE "Demarcar Fiscal" ACTION "U_FAT066PF(Space(1),_cAlias1)" OPERATION 2 ACCESS 0 
    ADD OPTION aRotina TITLE "Legenda"    ACTION "U_FAT066PL()"          OPERATION 4 ACCESS 0 
Return aRotina

/*/{Protheus.doc} ModelDef
Modelo de dados na funcao zVid0022
@author Antonio Domingos
@since 23/03/2023
@version 1.0
/*/
  
Static Function ModelDef()
    Local oModel 
    Local oStruSC5 := FWFormModelStruct():New()
       
    //Na estrutura, define os campos e a temporária
    oStruSC5:AddTable(_cAlias1, {'C5_FILIAL', 'C5_DTENTR', 'C5_NOTA', 'C5_NUM', 'C5_PLACA','C5_NOMECLI','C5_CIDADE','C5_EST','C5_ROTEIRO','C5_CANHUSU','C5_CANHDAT','C5_CANHHOR','C5_CANHMOT','C5_CANHOTO' }, "Canhotos")

    //Adicionando campos da estrutura
    oStruSC5:AddField(;
        "C5_FILIAL",;                 // [01]  C   Nome do Campo
        "01",;                      // [02]  C   Ordem
        "Filial",;                  // [03]  C   Titulo do campo
        "Filial",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .F.,;                        // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
    oStruSC5:AddField(;
        "C5_DTENTR",;               // [01]  C   Nome do Campo
        "02",;                      // [02]  C   Ordem
        "Dt.Entrega",;              // [03]  C   Titulo do campo
        "Dt.Entrega",;              // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "D",;                       // [06]  C   Tipo do campo
        " ",;                       // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
    oStruSC5:AddField(;
        "C5_NOTA",;                 // [01]  C   Nome do Campo
        "03",;                      // [02]  C   Ordem
        "Nota",;                    // [03]  C   Titulo do campo
        "Nota",;                    // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
    oStruSC5:AddField(;
        "C5_NUM",;                  // [01]  C   Nome do Campo
        "04",;                      // [02]  C   Ordem
        "Pedido",;                  // [03]  C   Titulo do campo
        "Pedido",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
     
	 oStruSC5:AddField(;
        "C5_PLACA",;                  // [01]  C   Nome do Campo
        "05",;                      // [02]  C   Ordem
        "Placa",;                  // [03]  C   Titulo do campo
        "Placa",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
     
	 oStruSC5:AddField(;
        "C5_NOMECLI",;                  // [01]  C   Nome do Campo
        "06",;                      // [02]  C   Ordem
        "Nome Cli",;                  // [03]  C   Titulo do campo
        "Nome Cliente",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStruSC5:AddField(;
        "C5_CIDADE",;                  // [01]  C   Nome do Campo
        "07",;                      // [02]  C   Ordem
        "Placa",;                  // [03]  C   Titulo do campo
        "Placa",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStruSC5:AddField(;
        "C5_EST",;                  // [01]  C   Nome do Campo
        "08",;                      // [02]  C   Ordem
        "Estado",;                  // [03]  C   Titulo do campo
        "Estado",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStruSC5:AddField(;
        "C5_ROTEIRO",;                  // [01]  C   Nome do Campo
        "09",;                      // [02]  C   Ordem
        "Roteiro",;                  // [03]  C   Titulo do campo
        "Roteiro",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStruSC5:AddField(;
        "C5_CANHUSU",;                  // [01]  C   Nome do Campo
        "10",;                      // [02]  C   Ordem
        "Usuario",;                  // [03]  C   Titulo do campo
        "Usuario",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruSC5:AddField(;
        "C5_CANHDAT",;                  // [01]  C   Nome do Campo
        "11",;                      // [02]  C   Ordem
        "Data",;                  // [03]  C   Titulo do campo
        "Data",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "D",;                       // [06]  C   Tipo do campo
        "@D",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruSC5:AddField(;
        "C5_CANHHOR",;                  // [01]  C   Nome do Campo
        "12",;                      // [02]  C   Ordem
        "Horario",;                  // [03]  C   Titulo do campo
        "Horario",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
	
	oStruSC5:AddField(;
        "C5_CANHMOT",;                  // [01]  C   Nome do Campo
        "13",;                      // [02]  C   Ordem
        "Motivo",;                  // [03]  C   Titulo do campo
        "MOtivo",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruSC5:AddField(;
        "C5_CANHOTO",;                  // [01]  C   Nome do Campo
        "14",;                      // [02]  C   Ordem
        "Status",;                  // [03]  C   Titulo do campo
        "Status",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

	//Instanciando o modelo
    oModel := MPFormModel():New("ADFAT066P",/*bPre*/, /*bPos*/,/*bCommit*/,/*bCancel*/) 
    oModel:AddFields("FORMTMP",/*cOwner*/,oStruSC5)
    oModel:SetPrimaryKey({'C5_FILIAL','C5_NOTA'})
    oModel:SetDescription("Modelo de Dados do Cadastro "+cTitulo)
    oModel:GetModel("FORMTMP"):SetDescription("Formulário do Cadastro "+cTitulo)
Return oModel

/*/{Protheus.doc} ViewDef
Visualizacao de dados na funcao ADFAT066
@author Antonio Domingos
@since 23/03/2023
@version 1.0
/*/

Static Function ViewDef()
    Local oModel := FWLoadModel("ADFAT066P")
    Local oStruSC5 := FwFormStruct( 1, _cAlias1 , /*bFiltro*/ ) //FWFormViewStruct():New()
    Local oView 

    oView := FWFormView():New()
    oView:SetModel(oModel)
    oView:AddField("VIEW_TMP", oStruSC5, "FORMTMP")
    oView:CreateHorizontalBox("TELA",100)
    oView:EnableTitleView('VIEW_TMP', 'Dados - '+cTitulo )  
    oView:SetCloseOnOk({||.T.})
    oView:SetOwnerView("VIEW_TMP","TELA")

    //Adicionando campos da estrutura
    oStruSC5:AddField(;
        "C5_FILIAL",;                 // [01]  C   Nome do Campo
        "01",;                      // [02]  C   Ordem
        "Filial",;                  // [03]  C   Titulo do campo
        "Filial",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .F.,;                        // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
    oStruSC5:AddField(;
        "C5_DTENTR",;               // [01]  C   Nome do Campo
        "02",;                      // [02]  C   Ordem
        "Dt.Entrega",;              // [03]  C   Titulo do campo
        "Dt.Entrega",;              // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "D",;                       // [06]  C   Tipo do campo
        " ",;                       // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
    oStruSC5:AddField(;
        "C5_NOTA",;                 // [01]  C   Nome do Campo
        "03",;                      // [02]  C   Ordem
        "Nota",;                    // [03]  C   Titulo do campo
        "Nota",;                    // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
    oStruSC5:AddField(;
        "C5_NUM",;                  // [01]  C   Nome do Campo
        "04",;                      // [02]  C   Ordem
        "Pedido",;                  // [03]  C   Titulo do campo
        "Pedido",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
       
    	 oStruSC5:AddField(;
        "C5_PLACA",;                  // [01]  C   Nome do Campo
        "05",;                      // [02]  C   Ordem
        "Placa",;                  // [03]  C   Titulo do campo
        "Placa",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
     
	 oStruSC5:AddField(;
        "C5_NOMECLI",;                  // [01]  C   Nome do Campo
        "06",;                      // [02]  C   Ordem
        "Nome Cli",;                  // [03]  C   Titulo do campo
        "Nome Cliente",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStruSC5:AddField(;
        "C5_CIDADE",;                  // [01]  C   Nome do Campo
        "07",;                      // [02]  C   Ordem
        "Placa",;                  // [03]  C   Titulo do campo
        "Placa",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStruSC5:AddField(;
        "C5_EST",;                  // [01]  C   Nome do Campo
        "08",;                      // [02]  C   Ordem
        "Estado",;                  // [03]  C   Titulo do campo
        "Estado",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStruSC5:AddField(;
        "C5_ROTEIRO",;                  // [01]  C   Nome do Campo
        "09",;                      // [02]  C   Ordem
        "Roteiro",;                  // [03]  C   Titulo do campo
        "Roteiro",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

    oStruSC5:AddField(;
        "C5_CANHUSU",;                  // [01]  C   Nome do Campo
        "10",;                      // [02]  C   Ordem
        "Usuario",;                  // [03]  C   Titulo do campo
        "Usuario",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruSC5:AddField(;
        "C5_CANHDAT",;                  // [01]  C   Nome do Campo
        "11",;                      // [02]  C   Ordem
        "Data",;                  // [03]  C   Titulo do campo
        "Data",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "D",;                       // [06]  C   Tipo do campo
        "@D",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruSC5:AddField(;
        "C5_CANHHOR",;                  // [01]  C   Nome do Campo
        "12",;                      // [02]  C   Ordem
        "Horario",;                  // [03]  C   Titulo do campo
        "Horario",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
	
	oStruSC5:AddField(;
        "C5_CANHMOT",;                  // [01]  C   Nome do Campo
        "13",;                      // [02]  C   Ordem
        "Motivo",;                  // [03]  C   Titulo do campo
        "MOtivo",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupa do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo

	oStruSC5:AddField(;
        "C5_CANHOTO",;                  // [01]  C   Nome do Campo
        "14",;                      // [02]  C   Ordem
        "Status",;                  // [03]  C   Titulo do campo
        "Status",;                  // [04]  C   Descricao do campo
        Nil,;                       // [05]  A   Array com Help
        "C",;                       // [06]  C   Tipo do campo
        "@!",;                      // [07]  C   Picture
        Nil,;                       // [08]  B   Bloco de PictTre Var
        Nil,;                       // [09]  C   Consulta F3
        .T.,;                       // [10]  L   Indica se o campo é alteravel
        Nil,;                       // [11]  C   Pasta do campo
        Nil,;                       // [12]  C   Agrupamento do campo
        Nil,;                       // [13]  A   Lista de valores permitido do campo (Combo)
        Nil,;                       // [14]  N   Tamanho maximo da maior opção do combo
        Nil,;                       // [15]  C   Inicializador de Browse
        Nil,;                       // [16]  L   Indica se o campo é virtual
        Nil,;                       // [17]  C   Picture Variavel
        Nil)                        // [18]  L   Indica pulo de linha após o campo
	//Criando a view que será o retorno da função e setando o modelo da rotina
Return oView


/*/{Protheus.doc} FAT066PB
    Gestão de Canhotos - Montagem do Filtro - Query
    @type  User Function
    @author Antonio Domingos
    @since 21/03/2023
    @version version
    @param param_name, param_type, param_deSC5
    @return return_var, return_type, return_deSC5iption
    @example
    (examples)
    @see (links_or_references)
    @history ticket 90508 - Antonio Domingos - 21/03/2023 - Otimização da rotina de Canhotos 
    /*/
User Function FAT066PB(_cAlias1,oProcess,_cFiltro)

	Local _cQuery := ""
	Local _cAliasQry := "TMP_SC5" 
    Local _nCount1   := 0

    _cQuery := "SELECT C5_FILIAL,C5_DTENTR,C5_NOTA,C5_NUM,C5_PLACA,C5_NOMECLI,C5_CIDADE,C5_EST,C5_ROTEIRO,C5_CANHUSU,C5_CANHDAT,C5_CANHHOR,C5_CANHMOT,C5_CANHOTO,C5_XTIPO,R_E_C_N_O_ C5_RECNO FROM "+RETSQLNAME("SC5")+ " SC5 (NOLOCK) "+CRLF
    _cQuery += " WHERE SC5.D_E_L_E_T_ = ' ' "+CRLF
    _cQuery += " AND C5_FILIAL  = '"+xFilial("SC5") + "' "+CRLF
    _cQuery += " AND C5_DTENTR >= '"+dtos(MV_PAR01) +"' "+CRLF
    _cQuery += " AND C5_DTENTR <= '"+dtos(MV_PAR02) +"' "+CRLF
    If !Empty(MV_PAR03)
        _cQuery += " AND C5_PLACA = '"+MV_PAR03 +"' "+CRLF //Ticket 92712 - Jonathan 26/04/2023
    EndIf
    _cQuery += " AND C5_ROTEIRO >= '"+MV_PAR04+"' "+CRLF
    _cQuery += " AND C5_ROTEIRO <= '"+MV_PAR05+"' "+CRLF
    _cQuery += " AND C5_NOTA >= '"+MV_PAR07+"' "+CRLF
    _cQuery += " AND C5_NOTA <= '"+MV_PAR08+"' "+CRLF
    If MV_PAR06 == 2 
        _cQuery += " AND C5_CANHOTO != 'X' "+CRLF
    EndIf
    _cQuery += " AND C5_NOTA != ' ' "+CRLF
    _cQuery += " ORDER BY C5_FILIAL,C5_DTENTR,C5_NOTA,C5_NUM,C5_PLACA "
    
    //MemoWrite("C:\TEMP\FAT066PB.SQL",_cQuery)

    TCQUERY _cQuery new alias &_cAliasQry
    
	TcSetField(_cAliasQry, "C5_DTENTR" ,"D",08,0)
	TcSetField(_cAliasQry, "C5_CANHDAT","D",08,0)
    TcSetField(_cAliasQry, "C5_RECNO"  ,"N",10,0)
    
    dbSelectArea(_cAliasQry)
	Count to _nCount1
    (_cAliasQry)->(dbGotop())
    If Valtype(oProcess) <> "U" .And. _cFiltro == "I"
        oProcess:SetRegua1(_nCount1)
    Else
        ProcRegua(_nCount1)
        (_cAliasQry)->(dbGotop())
    EndIf
    While ! (_cAliasQry)->(Eof())
        If Valtype(oProcess) <> "U" .And. _cFiltro == "I"
            oProcess:IncRegua1("Carregando Notas..."+(_cAliasQry)->C5_NOTA)        
        else
            IncProc((_cAliasQry)->C5_NOTA)        
        EndIf
        Reclock(_cAlias1,.T.)
		(_cAlias1)->C5_FILIAL  := (_cAliasQry)->C5_FILIAL
		(_cAlias1)->C5_DTENTR  := (_cAliasQry)->C5_DTENTR
		(_cAlias1)->C5_NOTA    := (_cAliasQry)->C5_NOTA
		(_cAlias1)->C5_NUM 	 := (_cAliasQry)->C5_NUM
		(_cAlias1)->C5_PLACA   := (_cAliasQry)->C5_PLACA
		(_cAlias1)->C5_NOMECLI := (_cAliasQry)->C5_NOMECLI
		(_cAlias1)->C5_CIDADE  := (_cAliasQry)->C5_CIDADE
		(_cAlias1)->C5_EST 	 := (_cAliasQry)->C5_EST
		(_cAlias1)->C5_ROTEIRO := (_cAliasQry)->C5_ROTEIRO
		(_cAlias1)->C5_CANHUSU := (_cAliasQry)->C5_CANHUSU
		(_cAlias1)->C5_CANHDAT := (_cAliasQry)->C5_CANHDAT
		(_cAlias1)->C5_CANHHOR := (_cAliasQry)->C5_CANHHOR
		(_cAlias1)->C5_CANHMOT := (_cAliasQry)->C5_CANHMOT
		(_cAlias1)->C5_CANHOTO := (_cAliasQry)->C5_CANHOTO
        (_cAlias1)->C5_RECNO   := (_cAliasQry)->C5_RECNO
        (_cAlias1)->C5_XTIPO   := (_cAliasQry)->C5_XTIPO
        (_cAlias1)->C5_CANHOTO := (_cAliasQry)->C5_CANHOTO
        (_cAlias1)->C5_CMARK   := (_cAliasQry)->C5_CANHOTO
        (_cAliasQry)->(dbSkip())
	Enddo

    (_cAliasQry)->(dbCloseArea())

Return

User Function FAT066PQ() //Quantidade

	Local _nVerde:=0
	Local _nVermelho:=0
	
	Count to _nVerde	for C5_CANHOTO != "X"
	Count to _nVermelho	for C5_CANHOTO == "X"
	
	_nTotal   := _nVerde + _nVermelho
	_aLegenda := {	{ "BR_VERDE"		, " Não Devolvidos      " + Space(4) + Transform(_nVerde, "@E ##9,999") },;
					{ "BR_VERMELHO"		, " Devolvidos  " + Space(1) + Transform(_nVermelho, "@E ##9,999") },;
					{ ""				, "___________________________________________________" },;
					{ ""				, Space(18) + "Total " + Space(3) + Transform(_nTotal, "@E ##9,999") } }
						
	BrwLegenda( "Total", "FAT066PQ - Gestão de Canhotos", _aLegenda )
	
Return(Nil)

/*/{Protheus.doc} FAT066PL()
    LEGENDA
    @type  User Function
    @author Antonio Domingos
    @since 28/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FAT066PL() 

	//ÚÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄ¿
	//³ Declaração de variáveis.                                            |
	//ÀÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÄÙ
	Local aArea		:= GetArea()
	Local aLegenda  := {}
    Local cCadastro := "Canhotos"

	Aadd(aLegenda,{"BR_VERDE"   ,"Não devolvidos" })
	Aadd(aLegenda,{"BR_VERMELHO","Devolvido"})

	//
	BrwLegenda(cCadastro,"FAT066PL - Legenda",aLegenda)

	//
	RestArea(aArea)

Return NiL

/*/{Protheus.doc} User Function FAT066PE(cMotivo)
	(Grava motivo para itens marcados)
	@type  Function
	@author  Antonio Domingos
	@since 11/11/2022
	@version 01
	@history Ticket   82901  - Antonio Domingos, 11/11/2022 - Melhoria baixa de canhoto - Motivo para itens marcados
	/*/
Static Function FAT066PE(cMotivo,_cAlias1)

	Local _aGetArea := GetArea()
	Local _cMensagem := ""
	While ! (_cAlias1)->(EOF())
		IF ALLTRIM((_cAlias1)->C5_CANHOTO) == 'X' 
			//INICIO Ticket   88472  - Antonio Domingos, 14/02/2023
			dDtEntrega := (_cAlias1)->C5_DTENTR
			If (_cAlias1)->(RecLock("SC5",.F.)) 
				(_cAlias1)->C5_CANHMOT := cMotivo
				(_cAlias1)->C5_CANHUSU := Iif(Empty(C5_CANHOTO) .And. Empty(C5_CANHMOT),"",CUSERNAME)
				(_cAlias1)->C5_CANHDAT := Iif(Empty(C5_CANHOTO) .And. Empty(C5_CANHMOT),CtoD(""),DATE())
				(_cAlias1)->C5_CANHHOR := Iif(Empty(C5_CANHOTO) .And. Empty(C5_CANHMOT),"",SUBSTR(Time(),1,5))
				(_cAlias1)->(MsUnLock())
                If SC5->(dbGoto((_cAlias1)->C5_RECNO))
                    RecLock("SC5",.F.)
                    SC5->C5_CANHOTO := cMarca
                    SC5->C5_CANHUSU := IIF(cMarca=="X",CUSERNAME,"")
                    SC5->C5_CANHDAT := IIF(cMarca=="X",DATE(),CTOD(""))
                    SC5->C5_CANHHOR := IIF(cMarca=="X",SUBSTR(Time(),1,5),"")
                    SC5->(MsUnLock())
                EndIf
                _cMensagem += " Motivo Gravado Ped: "+(_cAlias1)->C5_NUM+" DT: "+DTOC((_cAlias1)->C5_CANHDAT)+" HR: "+(_cAlias1)->C5_CANHHOR+" MOTIVO: "+alltrim((_cAlias1)->C5_CANHMOT)+CRLF //Ticket   82901  - Antonio Domingos, 10/02/2023
			Endif	
			//FIM Ticket   88472  - Antonio Domingos, 14/02/2023
		else
            _cMensagem += " Canhoto não marcado - Motivo não gravado Gravado Ped: "+(_cAlias1)->C5_NUM+" DT: "+DTOC((_cAlias1)->C5_CANHDAT)+" HR: "+(_cAlias1)->C5_CANHHOR+" MOTIVO: "+alltrim((_cAlias1)->C5_CANHMOT)+CRLF //Ticket   82901  - Antonio Domingos, 10/02/2023
        EndIf
		(_cAlias1)->(DBSkip())
	End
	U_ExTelaMen("CANHOTOS ", _cMensagem, "Arial", 10, , .F., .T.) //Ticket   82901  - Antonio Domingos, 10/02/2023
	RestArea(_aGetArea)    
Return

//Marca todos
//SetKey(VK_F10,{||MARCA("X"), oBrowse :Refresh(.T.) })
User Function FAT066PT(_cAlias1,cMarca,lMarcar, lInvert) 

	LOCAL dDtEntrega := CTOD("")
	Local cMensagem  := ''
	Local cRot       := ''
	Local cRotOld    := ''
	Local cDtEntr    := ''
	Local cDtEntrOld := ''
	
	cDtEntrOld := (_cAlias1)->C5_DTENTR
	cRotOld    := (_cAlias1)->C5_ROTEIRO

	WHILE ! (_cAlias1)->(EOF())
	
		IF ALLTRIM((_cAlias1)->C5_CANHOTO) == ''   
	
			dDtEntrega := (_cAlias1)->C5_DTENTR
			cDtEntr    := (_cAlias1)->C5_DTENTR
			cRot       := (_cAlias1)->C5_ROTEIRO
	
			IF (dDtEntrega > Date()) .Or. dDtEntrega <= DATE() .OR. ALLTRIM((_cAlias1)->C5_XTIPO) = '2'     
			   
			   IF cDtEntr == cDtEntrOld .AND. ;
			      cRot    == cRotOld          // e a mesma data de entrega e o mesmo roteiro altera 
			   
				   IF (_cAlias1)->(RecLock("SC5",.F.))
					
						(_cAlias1)->C5_CMARK   := cMarca
                        (_cAlias1)->C5_CANHOTO := (_cAlias1)->C5_CMARK
						(_cAlias1)->C5_CANHUSU := IIF((_cAlias1)->C5_CANHOTO=="X",CUSERNAME,"")
						(_cAlias1)->C5_CANHDAT := IIF((_cAlias1)->C5_CANHOTO=="X",DATE(),CTOD(""))
						(_cAlias1)->C5_CANHHOR := IIF((_cAlias1)->C5_CANHOTO=="X",SUBSTR(Time(),1,5),"")
						(_cAlias1)->(MsUnLock())
						
                        If SC5->(dbGoto((_cAlias1)->C5_RECNO))
                            RecLock("SC5",.F.)
                            SC5->C5_CANHOTO := (_cAlias1)->C5_CANHOTO
                            SC5->C5_CANHUSU := (_cAlias1)->C5_CANHUSU
                            SC5->C5_CANHDAT := (_cAlias1)->C5_CANHDAT
                            SC5->C5_CANHHOR := (_cAlias1)->C5_CANHHOR
                            SC5->(MsUnLock())
                        EndIf
                        dbSelectArea(_cAlias1)

                    ENDIF
					
				ELSE
				
					cMensagem+= "Olá " + cUserName                   + ;
					            ' Nota Fiscal: ' + (_cAlias1)->C5_NOTA       + ;
					            ' Não pode ser marcado o canhoto, ' + ;
							    ' Só poderá marcar canhoto do Roteiro: ' + cRot + CHR(10) + CHR(13) + CHR(10) + CHR(13)
					
				ENDIF
			ENDIF	
		ENDIF

		(_cAlias1)->(DBSkip())
		
	ENDDO

	IF !EMPTY(cMensagem)
	 
		U_ExTelaMen("FAT066PT - Tela de Canhotos!!!", cMensagem, "Arial", 10, , .F., .T.)
		
	ENDIF	
    oBrowse:Refresh(.T.)
Return
/*/{Protheus.doc} FAT066PM(
    Edição do Motivo na Devolução do Canhoto
    @type  Function
    @author Antonio Domingos
    @since 28/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FAT066PM(_cAlias1)  

	Local cMotivo    := (_cAlias1)->C5_CANHMOT
	Local oDlg       := Nil
	Local _cMensagem := ""  //Ticket   82901  - Antonio Domingos, 10/02/2023
	Local _nOpt1     := 0

    DEFINE MSDIALOG oDlg FROM 0,0 TO 95,400 PIXEL	TITLE "Motivo de Não Devolução do Canhoto"
	
		@ 10,08 MSGET oPed Var cMotivo Valid !Empty(cMotivo) SIZE 160,13 PIXEL OF oDlg
		DEFINE SBUTTON FROM 35,008 TYPE 1 ACTION (_nOpt := 1,oDlg:End()) ENABLE OF oDlg
		DEFINE SBUTTON FROM 35,038 TYPE 2 ACTION oDlg:End() ENABLE OF oDlg

	ACTIVATE DIALOG oDlg CENTER
	
	If _nOpt1 == 1
	
        _lRetMot := MsgYesNo("Deseja Atualizar motivo para os Itens marcados?", "Tela de confirmação do processamento")
        
        If _lRetMot
            FAT066PE(cMotivo,_cAlias1)
        Else
            IF ALLTRIM((_cAlias1)->C5_CANHOTO) == 'X' 
                //INICIO Ticket   88472  - Antonio Domingos, 14/02/2023
                dDtEntrega := (_cAlias1)->C5_DTENTR //Ticket   82901  - Antonio Domingos, 10/02/2023
                If (_cAlias1)->(RecLock("SC5",.F.))
                    (_cAlias1)->C5_CANHMOT := cMotivo
                    (_cAlias1)->C5_CANHUSU := Iif(Empty(C5_CANHOTO) .And. Empty(C5_CANHMOT),"",CUSERNAME)
                    (_cAlias1)->C5_CANHDAT := Iif(Empty(C5_CANHOTO) .And. Empty(C5_CANHMOT),CtoD(""),DATE())
                    (_cAlias1)->C5_CANHHOR := Iif(Empty(C5_CANHOTO) .And. Empty(C5_CANHMOT),"",SUBSTR(Time(),1,5))
                    (_cAlias1)->(MsUnLock())
                    _cMensagem += (_cAlias1)->(" Motivo gravado Ped: "+C5_NUM+" DT: "+DTOC(C5_CANHDAT)+" HR: "+C5_CANHHOR+" MOTIVO: "+alltrim(C5_CANHMOT))+CRLF //Ticket   82901  - Antonio Domingos, 10/02/2023
                    If SC5->(dbGoto((_cAlias1)->C5_RECNO))
                        RecLock("SC5",.F.)
                        SC5->C5_CANHOTO := cMarca
                        SC5->C5_CANHUSU := IIF(cMarca=="X",CUSERNAME,"")
                        SC5->C5_CANHDAT := IIF(cMarca=="X",DATE(),CTOD(""))
                        SC5->C5_CANHHOR := IIF(cMarca=="X",SUBSTR(Time(),1,5),"")
                        SC5->(MsUnLock())
                    EndIf
                EndIf
                //FIM Ticket   88472  - Antonio Domingos, 14/02/2023
                U_ExTelaMen("CANHOTOS ", _cMensagem, "Arial", 10, , .F., .T.)
            else
                Aviso("Atenção", "Item não está marcado, Motivo não alterado! Verifique...", {"OK"}, 3)
            EndIf
        EndIf
    else
        Aviso("Atenção", "Motivo não alterado! Verifique...", {"OK"}, 3)
    EndIf

Return

/*/{Protheus.doc} FAT066PI
	Inverte Marca do Marbrowse
	@type  User Function
	@author Antonio Domingos
	@since 24/03/2023
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 
/*/
User Function FAT066PI(cAliasSC5,cMarca,lMarcar, lInvert)

	Local aGetArea  := GetArea()
    
    IF !(ALLTRIM(__CUSERID) $ GETMV("MV_#USUCAN")) //chamado 039784
	
		MsgStop("Usuário sem premissão de acesso à rotina.", "Função FAT066PI - Inverte Marca")
		Return Nil
		
	ENDIF

    _cAlias1 := Alias()

	(_cAlias1)->( dbGoTop() )
	Do While !(_cAlias1)->( EOF() )
		RecLock( (_cAlias1), .F. )
		If lInvert
			(_cAlias1)->C5_CMARK := IIf( (cAlias)->C5_CANHOTO == cMarca , '  ',cMarca )
            (_cAlias1)->C5_CANHOTO := (_cAlias1)->C5_CMARK 
        Else
			(_cAlias1)->C5_CMARK := IIf( (cAlias)->C5_CANHOTO == cMarca , '  ',cMarca )
		    (_cAlias1)->C5_CANHOTO := (_cAlias1)->C5_CANHOTO
        Endif
		(_cAlias1)->(MsUnlock())
        If SC5->(dbGoto((_cAlias1)->C5_RECNO))
            RecLock("SC5",.F.)
            SC5->C5_CANHOTO := (_cAlias1)->C5_CANHOTO
            SC5->(MsUnLock())
         EndIf
		(_cAlias1)->( dbSkip() )
	EndDo

	RestArea( aGetArea )
    oBrowse:Refresh(.T.)
Return .T.
/*/{Protheus.doc} FAT066PU
    Desmarca Unico Item com validações
    @type  User Function 
    @author Antonio Domingos
    @since 28/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
//SetKey(VK_F9 ,{||MarquUne(), oBrowse :Refresh(.F.) })
User Function FAT066PU(_cAlias1) //MarquUne(_cAlias1)

	LOCAL dDtEntrega := CTOD("")
	
	dDtEntrega := (_cAlias1)->C5_DTENTR

	IF ALLTRIM((_cAlias1)->C5_CANHOTO) == '' .OR. ALLTRIM((_cAlias1)->C5_XTIPO) == '2' //Everson - 23/06/2022. Chamado 75031.

		IF (_cAlias1)->(RecLock("SC5",.F.))
            (_cAlias1)->C5_CMARK   := IIF(EMPTY((_cAlias1)->C5_CANHOTO),"X"," ")
            (_cAlias1)->C5_CANHOTO := (_cAlias1)->C5_CMARK
			(_cAlias1)->C5_CANHUSU := IIF(EMPTY((_cAlias1)->C5_CANHOTO) .And. EMPTY((_cAlias1)->C5_CANHMOT),"",CUSERNAME)
			(_cAlias1)->C5_CANHDAT := IIF(EMPTY((_cAlias1)->C5_CANHOTO) .And. EMPTY((_cAlias1)->C5_CANHMOT),CTOD(""),DATE())
			(_cAlias1)->C5_CANHHOR := IIF(EMPTY((_cAlias1)->C5_CANHOTO) .And. EMPTY((_cAlias1)->C5_CANHMOT),"",SUBSTR(Time(),1,5))
			(_cAlias1)->(MsUnLock())

            SC5->(dbGoto((_cAlias1)->C5_RECNO))
            RecLock("SC5",.F.)
            SC5->C5_CANHOTO := (_cAlias1)->C5_CANHOTO
            SC5->C5_CANHUSU := (_cAlias1)->C5_CANHUSU
            SC5->C5_CANHDAT := (_cAlias1)->C5_CANHDAT
            SC5->C5_CANHHOR := (_cAlias1)->C5_CANHHOR
            SC5->(MsUnLock())
		ENDIF
	ELSE	
	
		IF ALLTRIM((_cAlias1)->C5_CANHOTO) == 'X'   
	
			dDtEntrega := (_cAlias1)->C5_DTENTR
		
			IF (dDtEntrega > Date()) .Or. (dDtEntrega == DATE()      .OR. ; //Everson - 23/06/2022. Chamado 75031.
			   dDtEntrega  == (DATE()  - GETMV("MV_#DIACAN"))) .OR. ALLTRIM((_cAlias1)->C5_XTIPO) = '2'
			   
				    IF (_cAlias1)->(RecLock((_cAlias1),.F.))
                            (_cAlias1)->C5_CMARK   := IIF(EMPTY((_cAlias1)->C5_CANHOTO),"X"," ")
                            (_cAlias1)->C5_CANHOTO := (_cAlias1)->C5_CMARK
                            (_cAlias1)->C5_CANHUSU := IIF(EMPTY((_cAlias1)->C5_CANHOTO) .And. EMPTY((_cAlias1)->C5_CANHMOT),"",CUSERNAME)
                            (_cAlias1)->C5_CANHDAT := IIF(EMPTY((_cAlias1)->C5_CANHOTO) .And. EMPTY((_cAlias1)->C5_CANHMOT),CTOD(""),DATE())
                            (_cAlias1)->C5_CANHHOR := IIF(EMPTY((_cAlias1)->C5_CANHOTO) .And. EMPTY((_cAlias1)->C5_CANHMOT),"",SUBSTR(Time(),1,5))
						(_cAlias1)->(MsUnLock())

					    SC5->(dbGoto((_cAlias1)->C5_RECNO))
                        RecLock("SC5",.F.)
                            SC5->C5_CANHOTO := (_cAlias1)->C5_CANHOTO
                            SC5->C5_CANHUSU := (_cAlias1)->C5_CANHUSU
                            SC5->C5_CANHDAT := (_cAlias1)->C5_CANHDAT
                            SC5->C5_CANHHOR := (_cAlias1)->C5_CANHHOR
                        SC5->(MsUnLock())
				    ENDIF
		    ELSE
                (_cAlias1)->(RecLock((_cAlias1),.F.))
                    (_cAlias1)->C5_CMARK := 'X'
                (_cAlias1)->(MsUnLock())

                ALERT("Olá " + cUserName                   + ;
				      ' Nota Fiscal: ' + (_cAlias1)->C5_NOTA       + ;
				      ' Não pode ser desmarcar o canhoto, ' + ;
					  ' para desmarcar entre em contato com a Gerente Fiscal, devido estar fora da data de liberação ' + ;
					  DTOC(DATE()- GETMV("MV_#DIACAN")) + ' até ' + DTOC(DATE()))
			ENDIF	
		ENDIF
		
	ENDIF	
    oBrowse:Refresh(.T.)
Return
/*/{Protheus.doc} FAT066PF(cMarca,_cAlias1)
    Desmarcar Fiscal
    @type  User Function 
    @author Antonio Domingos
    @since 28/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FAT066PF(cMarca,_cAlias1) 

    IF !(ALLTRIM(__CUSERID) $ GETMV("MV_#USUCAN")) //chamado 039784
	
		MsgStop("FAT066PF - Usuário sem premissão de acesso à rotina.", "Função FAT066PF - Desmarca Fiscal")
		Return Nil
		
	ENDIF
	
	While ! (_cAlias1)->(EOF())
        If alltrim((_cAlias1)->C5_CANHOTO) == "X"
            If (_cAlias1)->(RecLock((_cAlias1),.F.))
                    (_cAlias1)->C5_CMARK   := " "
                    (_cAlias1)->C5_CANHUSU := ""
                    (_cAlias1)->C5_CANHDAT := CtoD("")
                    (_cAlias1)->C5_CANHHOR := ""
                (_cAlias1)->(MsUnLock())

                SC5->(dbGoto((_cAlias1)->C5_RECNO))
                    RecLock("SC5",.F.)
                    SC5->C5_CANHOTO := (_cAlias1)->C5_CANHOTO
                    SC5->C5_CANHUSU := (_cAlias1)->C5_CANHUSU
                    SC5->C5_CANHDAT := (_cAlias1)->C5_CANHDAT
                    SC5->C5_CANHHOR := (_cAlias1)->C5_CANHHOR
                SC5->(MsUnLock())
            Endif
		EndIf
        (_cAlias1)->(DBSkip())
	EndDo
    oBrowse:Refresh(.T.)
Return()
/*/{Protheus.doc} FAT066PR(cMarca)
    DESMARCA(cMarca) Item posicionado do Browse
    @type  User Function
    @author Antonio Domingos
    @since 28/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
//SetKey(VK_F11,{||DESMARCA(Space(1)), oBrowse :Refresh(.T.) })
User Function FAT066PR(cMarca) 

	LOCAL dDtEntrega := CTOD("")
	Local cMensagem  := ''

	WHILE ! (_cAlias1)->(EOF())
	
		IF !Emtpy((_cAlias1)->C5_CANHOTO)
	
			dDtEntrega := (_cAlias1)->C5_DTENTR
		
			IF (dDtEntrega > Date()) .Or. (dDtEntrega == DATE()      .OR. ; //Everson - 23/06/2022. Chamado 75031.
			   dDtEntrega  == (DATE() - GETMV("MV_#DIACAN"))) .OR. ALLTRIM((_cAlias1)->C5_XTIPO) = '2'
			   
				   IF (_cAlias1)->(RecLock("SC5",.F.))
                            (_cAlias1)->C5_CANHOTO      := cMarca
                            (_cAlias1)->C5_CANHOTO := "X"
                            (_cAlias1)->C5_CANHUSU := IIF(cMarca=="X",CUSERNAME,"")
                            (_cAlias1)->C5_CANHDAT := IIF(cMarca=="X",DATE(),CTOD(""))
                            (_cAlias1)->C5_CANHHOR := IIF(cMarca=="X",SUBSTR(Time(),1,5),"")
						(_cAlias1)->(MsUnLock())

                        SC5->(dbGoto((_cAlias1)->C5_RECNO))
                        RecLock("SC5",.F.)
                            SC5->C5_CANHOTO := (_cAlias1)->C5_CANHOTO
                            SC5->C5_CANHUSU := (_cAlias1)->C5_CANHUSU
                            SC5->C5_CANHDAT := (_cAlias1)->C5_CANHDAT
                            SC5->C5_CANHHOR := (_cAlias1)->C5_CANHHOR
                        SC5->(MsUnLock())
                    ENDIF
					
			ELSE
			
				cMensagem+= "Olá " + cUserName                   + ;
				            ' Nota Fiscal: ' + (_cAlias1)->C5_NOTA       + ;
				            ' Não pode ser desmarcar o canhoto, ' + ;
						    ' para desmarcar entre em contato com a Gerente Fiscal, devido estar fora da data de liberação ' + ;
						    DTOC(DATE()- GETMV("MV_#DIACAN")) + ' até ' + DTOC(DATE()) + CHR(10) + CHR(13) + CHR(10) + CHR(13)
				
				
			ENDIF	
		ENDIF
		(_cAlias1)->(DBSkip())
		
	ENDDO

	IF !EMPTY(cMensagem)
	 
		U_ExTelaMen("FAT066PR - Tela de Canhotos!!!", cMensagem, "Arial", 10, , .F., .T.)
		
	ENDIF	
	oBrowse :Refresh()

Return

/*/{Protheus.doc} FAT066PX(oBrowse,oProcess)
    Parametros para nova consulta da Gestão de Canhotos
    @type  Function User
    @author Antonio Domingos
    @since 28/03/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FAT066PX(oBrowse,oProcess,_cAlias1)
    Processa( { || P_FAT066PX(_cAlias1) }, "Limpando Filtro" )
Return

Static Function P_FAT066PX(_cAlias1)
    Local nCount1 := 0
    _cFiltro := "P" //Carregando via opção de Parametro
    Pergunte(cPerg,.t.)
    //Apaga Registro para novo Filtro
    (_cAlias1)->(dbGotop())
    Count to nCount1 
    ProcRegua(nCount1)
    (_cAlias1)->(dbGotop())
    While !(_cAlias1)->(Eof())
        IncProc((_cAlias1)->C5_NOTA)
        Reclock(_cAlias1,.F.)
        (_cAlias1)->(dbDelete())
        (_cAlias1)->(MsUnLOck())
        (_cAlias1)->(dbSkip())
    Enddo
    //Cria Arquivo de Trabalho
    Processa( { || U_FAT066PB(_cAlias1,oProcess,_cFiltro) }, "Carregando Notas" )
    (_cAlias1)->(dbGotop())
    oBrowse:Refresh(.t.)
Return Nil


/*/{Protheus.doc} FAT066PV
Função para visualizar dados da Tabela Temporaria

@author Antonio Domingos
@since 29/03/2023
/*/
User Function FAT066PV(_cAlias1)
	Local nI := 0
	Local nRec := (_cAlias1)->(RecNo())
	Local nTop := 0
	Local nLeft := 0
	Local nBottom := 0
	Local nRight := 0
    Local aRet
	Local aInfo := {}
	Local oDlg
	Local oEnchoice
    Local _aEstruCpo := {}
    Local _aTituloX3 := {}
    Local _aStruct   := (_cAlias1)->(dbStruct())
    Local _cTitRotin := "Visualizar - Canhotos"
    Local _nX
    //Local oModel := FWLoadModel("ADFAT066P")
    Local aSaveLines := FWSaveRows()
    //oModel:GetModel("FORMTMP"):SetDescription("Formulário do Cadastro "+cTitulo)
    
    // Campos que estarão somente na tabela temporaria
    //                     ALIAS,COLUNA TABELA,{TAM,DEC,TIPO} 				,CPO TAB TEMP	, PICTURE
	AADD( _aEstruCpo, {_cAlias1,'C5_FILIAL'	,{02,0,"C","Filial"}			,"C5_FILIAL"	,"@!"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_DTENTR'	,{08,0,"D","Dt Entr"}			,"C5_DTENTR"	,"@D"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_NOTA'  	,{09,0,"C","Nota"}			,"C5_NOTA"	    ,"@!"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_NUM'    ,{06,0,"C","Pedido"}			,"C5_NUM"	    ,"@!"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_PLACA'  ,{07,0,"C","Placa"}			,"C5_PLACA"	    ,"@X"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_NOMECLI',{20,0,"C","NomeCli"}			,"C5_NOMECLI"	,"@!"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_CIDADE' ,{20,0,"C","Cidade"}			,"C5_CIDADE"	,"@!"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_EST'    ,{02,0,"C","Est"}			,"C5_EST"	    ,"@!"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_ROTEIRO',{03,0,"C","Roteiro"}			,"C5_ROTEIRO"	,"@999"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_CANHUSU',{10,0,"C","Usuario"}			,"C5_CANHUSU"	,"@!"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_CANHDAT',{12,0,"C","Data"}			,"C5_CANHDAT"	,"@D"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_CANHHOR',{12,0,"C","Hora"}			,"C5_CANHHOR"	,"@!"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_CANHMOT',{12,0,"C","Motivo"}			,"C5_CANHMOT"	,"@!"	}	)
	AADD( _aEstruCpo, {_cAlias1,'C5_CANHOTO',{12,0,"C","Canhoto"}			,"C5_CANHOTO"	,"@!"	}	)
   	AADD( _aEstruCpo, {_cAlias1,'C5_RECNO'  ,{12,0,"C","Registro"}			,"C5_RECNO"	    ,"@999999999999"	}	)
    AADD( _aEstruCpo, {_cAlias1,'C5_XTIPO'  ,{01,0,"C","Tipo"}			,"C5_XTIPO"	    ,"@X"	}	)
    AADD( _aEstruCpo, {_cAlias1,'C5_CMARK'  ,{01,0,"C","Marca"}			,"C5_CMARK"	    ,"@!"	}	)
    
    // Adiciona Tipo, Tamanho, Decimal e Titulo
    For _nX :=1 to Len(_aEstruCpo)
        If _aEstruCpo[_nx][3] == nil
            aRet	:=	TamSX3( _aEstruCpo[_nx][2])
            AADD( _aTituloX3, RetTitle(_aEstruCpo[_nx][2]) )
        ElseIf ValType( _aEstruCpo[_nx][3]) == "C"
            aRet	:=	TamSX3( _aEstruCpo[_nx][3])
            AADD( _aTituloX3, RetTitle(_aEstruCpo[_nx][3]) )
        Else
            aRet :=	_aEstruCpo[_nx][3]
            AADD( _aTituloX3, aRet[4] )
        Endif
    Next    
	// Carregar o vetor com os títulos dos campos.
	_aStruct := (_cAlias1)->( dbStruct() )	// Buscar a estrutura da área de trabalho.
	For nI :=	1	TO	LEN(_aStruct )	// Montar os SAY e GET da Enchoice.
		ADD FIELD aInfo TITULO _aTituloX3[nI] CAMPO _aStruct[nI,1] TIPO _aStruct[nI,2] TAMANHO _aStruct[nI,3] DECIMAL _aStruct[nI,4] NIVEL 1
		cField := aInfo[nI][2]
		M->&(cField) := (_cAlias1)->&(cField)
	Next
	If SetMDIChild()		// Definir as coordenadas para a janela.
		oMainWnd:ReadClientCoors()
		nTop := 40
		nLeft := 30
		nBottom := oMainWnd:nBottom-80
		nRight := oMainWnd:nRight-70
	Else
		nTop := 135
		nLeft := 0
		nBottom := TranslateBottom(.T.,28)
		nRight := 632
	Endif
	// Apresentar os dados para visualização no objeto.
	DEFINE MSDIALOG oDlg TITLE _cTitRotin FROM nTop,nLeft TO nBottom,nRight PIXEL
	oEnchoice := MsMGet():New( _cAlias1 ,nRec,2,,,,,{0,0,0,0},,,,,,oDlg,,,.F.,,,,aInfo)
	oEnchoice:oBox:Align := CONTROL_ALIGN_ALLCLIENT
	ACTIVATE MSDIALOG oDlg ON INIT EnchoiceBar(oDlg,{|| oDlg:End() }, {|| oDlg:End() })
    FWRestRows( aSaveLines )
Return

/*/{Protheus.doc} nomeFunction
    (long_description)
    @type  Function
    @author user
    @since 04/04/2023
    @version version
    @param param_name, param_type, param_descr
    @return return_var, return_type, return_description
    @example
    (examples)
    @see (links_or_references)
    /*/
User Function FAT066PY(aStruSC5)
   
    _cAlias1 := GetNextAlias()

    aAdd(aStruSC5, {'C5_FILIAL' ,'C',TAMSX3('C5_FILIAL')[1],0})
	aAdd(aStruSC5, {'C5_DTENTR' ,'D',TAMSX3('C5_DTENTR')[1],0})
	aAdd(aStruSC5, {'C5_NOTA'   ,'C',TAMSX3('C5_NOTA')[1],0})
	aAdd(aStruSC5, {'C5_NUM'    ,'C',TAMSX3('C5_NUM')[1],0})
	aAdd(aStruSC5, {'C5_PLACA'  ,'C',TAMSX3('C5_PLACA')[1],0})
	aAdd(aStruSC5, {'C5_NOMECLI','C',TAMSX3('C5_NOMECLI')[1],0})
	aAdd(aStruSC5, {'C5_CIDADE' ,'C',TAMSX3('C5_CIDADE')[1],0})
	aAdd(aStruSC5, {'C5_EST'    ,'C',TAMSX3('C5_EST')[1],0})
	aAdd(aStruSC5, {'C5_ROTEIRO','C',TAMSX3('C5_ROTEIRO')[1],0})
	aAdd(aStruSC5, {'C5_CANHUSU','C',TAMSX3('C5_CANHUSU')[1],0})
	aAdd(aStruSC5, {'C5_CANHDAT','D',TAMSX3('C5_CANHDAT')[1],0})
	aAdd(aStruSC5, {'C5_CANHHOR','C',TAMSX3('C5_CANHHOR')[1],0})
	aAdd(aStruSC5, {'C5_CANHMOT','C',TAMSX3('C5_CANHMOT')[1],0})
	aAdd(aStruSC5, {'C5_CANHOTO','C',TAMSX3('C5_CANHOTO')[1],0})  
    aAdd(aStruSC5, {'C5_RECNO'  ,'N',10,0})  
    aAdd(aStruSC5, {'C5_XTIPO'  ,'C',1,0})  
    aAdd(aStruSC5, {'C5_CMARK'  ,'C',1,0})  

    //Cria a temporária
    oTempTable := FWTemporaryTable():New(_cAlias1)
    oTempTable:SetFields(aStruSC5)
    oTempTable:AddIndex("01", {"C5_FILIAL",'C5_NOTA'} )
    oTempTable:AddIndex("02", {"C5_FILIAL",'C5_NUM'} )
    oTempTable:AddIndex("03", {"C5_FILIAL",'C5_DTENTR'} )
    oTempTable:AddIndex("04", {"C5_FILIAL",'C5_PLACA'} )
    oTempTable:Create()
 
Return 
