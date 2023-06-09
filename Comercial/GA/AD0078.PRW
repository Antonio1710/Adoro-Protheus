#INCLUDE "RWMAKE.CH"

/*/{Protheus.doc} User Function AD0078
	
	@type  Function
	@author 
	@since 28/02/2022
	@version 01
	@history Ticket  TI     - Leonardo P. Monteiro - 26/02/2022 - Inclus�o de conouts no fonte. 
	@history ticket TI - Antonio Domingos - 17/05/2023 - Ajuste Nova Empresa
	@history ticket TI - Antonio Domingos - 22/05/2023 - Revis�o Ajuste Nova Empresa
/*/

USER FUNCTION AD0078(_ori)

	Private lSfInt	:= (IsInCallStack('U_RESTEXECUTE') .OR. IsInCallStack('RESTEXECUTE'))
	Private _cEmpFL2 := SuperGetMv("MV_#EMPFL2",.F.,"0102/0106/1301") //Codigo de Empresas+Filiais Ativas Grupo 2 //ticket TI - Antonio Domingos - 17/05/2023

	//Conout( DToC(Date()) + " " + Time() + " AD0078 >>> INICIO PE" )

	//U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')

	//CONTROLE DE TABELAS DE PRECO
	//OTIMIZACAO BASEADA NO AD0078 DA ADORO (ROG�RIO NUTTI, 2003)
	//RAFAEL HENRIQUE DA SILVEIRA, 10/12/2007
	_LCOPIA		:= iif(valtype(VAR_IXB)="A",iif(VAR_IXB[1]="COPIA_PV",.T.,.F.),.F.) //VERIFICA SE E COPIA, VARIAVEL PUBLICA VAR_IXB, ALIMENTADA NO PONTO DE ENTRADA MT410CPY
	_LPRECOOK    := .T. //alterado para tratar retorno para o ponto de entrada M410LIOK por Adriana em 10/08/10
	_NPRECOUNIT  := 0
	_NPOSPRODUTO := ASCAN( AHEADER, { |X| ALLTRIM(X[2]) == "C6_PRODUTO" } )
	_CPRODUTO    := ACOLS[N,_NPOSPRODUTO]
	_NPOSPRCVEN  := ASCAN( AHEADER, { |X| ALLTRIM(X[2]) == "C6_PRCVEN" } )
	_CTABELA     := M->C5_TABELA
	_NPRCVEN     := ACOLS[N,_NPOSPRCVEN]
	_NPOSPRUNIT  := ASCAN( AHEADER, { |X| ALLTRIM(X[2]) == "C6_PRUNIT" } ) //Alterado 28/02/11 - ANA
	_M410LIOK	:= iif(valtype(_ori)=="U",.F.,.T.)   //alterado para tratar o retorno para o ponto de entrada M410LIOK por Adriana em 10/08/10
	//VARIAVEIS INCLUIDAS PARA TRATAR COPIA DE PEDIDO DE VENDA COM PRECO MENOR QUE O DA TABELA DE PRECOS
	//por Adriana HC em 31/08/10 chamado 007766

	_cUSUCOPIA	:= GetMv( "MV_#USUCOP" , .F. , "000000" )  //Usuarios da Logistica - somente neste caso valida a data
	_lUSUCOPIA	:= (Alltrim(__CUSERID) $ _cUSUCOPIA) //Usuario pertence a logistica e pode utilizar copia.
	_nDIACOPIA  := GetMv( "MV_#DIACOP" , .F. , 0 )  //LIMITE DE DIAS (QUANTIDADE) PARA COPIA DOS PEDIDOS COM PRECO ABAIXO DA TABELA DE PRECOS
	_dDATAANT   := iif(valtype(VAR_IXB)="A",iif(VAR_IXB[1]="COPIA_PV",VAR_IXB[2],ddatabase),ddatabase)  //DATA DE ENTREGA DO PEDIDO ORIGINAL PASSADO NO PONTO DE ENTRADA MT410CPY
	_dData		:= iif(dow(_dDataAnt+_nDiaCopia)=1,_dDataAnt+_nDiaCopia+1,iif(dow(_dDataAnt+_nDiaCopia)=7,_dDataAnt+_nDiaCopia+2,_dDataAnt+_nDiaCopia))
	_lCOPIAOK   := .F.

	//IF !_lUSUCOPIA  &&Mauricio 16/02/11 - Conforme Ana Helena usuarios no parametro(logistica) nao precisam validar o pre�o minimo somente data.

	IF !_lUSUCOPIA .And. ! IsInCallStack('RESTEXECUTE') //Everson - 27/12/2017. Chamado 037261.

			IF !M->C5_TIPO $ 'IPBD'     //ALTERADO POR ADRIANA PARA PERMITIR A ALTERACAO DO VALOR PARA NOTAS DE COMPLEMENTO DE ICMS E IPI, DEVOLUCAO E BENEFICIAMENTO
				DBSELECTAREA("DA1")
				DBSETORDER(1)          		
				IF !DBSEEK( XFILIAL("DA1") + _CTABELA + _CPRODUTO )  .OR. EMPTY(_CTABELA)
					DBSELECTAREA("SA3")
					DBSETORDER(7)
					IF DBSEEK (XFILIAL()+__CUSERID) .AND. alltrim(cEmpAnt)+alltrim(cfilant) $ _cEmpFL2 //@history ticket TI - Antonio Domingos - 17/05/2023
							_lRet   := .F. &&Mauricio - 02/03/11 - Solicitdo por Alex bloqueio quando nao tem tabela no cadastro do Cliente.
							IF IsInCallStack('U_ADVEN002P')  == .T.
									Aadd(aPedidos,{cchave, ;
												''    , ;
												''    , ;
												''    , ;
												'Cliente sem tabela de pre�o em seu cadastro.Contate Depto. Comercial.O pedido nao podera ser incluido!' , ;
												cVendedor}) 
								
								ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
									Aadd(aPedidos,{"Cliente sem tabela de pre�o em seu cadastro.Contate Depto. Comercial.O pedido nao podera ser incluido!"})								
								ELSE							
									MsgInfo("Cliente sem tabela de pre�o em seu cadastro.Contate Depto. Comercial.O pedido nao podera ser incluido!","Cliente sem Tabela")									
								ENDIF
							
					Else  
							_lRet   := .T. 
					Endif     
				ELSE
					
					DBSELECTAREA("SA3")
					DBSETORDER(7)
					IF DBSEEK (XFILIAL()+__CUSERID)
						IF A3_NIVETAB = '3' .OR. A3_NIVETAB = '4'
							_PRECO:="DA1_PRCGER"
							_TABELA:="GER�NCIA"
						ELSEIF A3_NIVETAB = '2'
							_PRECO:="DA1_PRCSUP"
							_TABELA:="SUPERVIS�O"
						ELSEIF A3_NIVETAB = '1'
							_PRECO:="DA1_PRCVEN"
							_TABELA:="VENDEDOR"
						ENDIF
					ELSE
						_PRECO:="DA1_PRCVEN"
						_TABELA:="USU�RIO NAO CADASTRADO"
					ENDIF
					
					_NPRECOUNIT := DA1->&(_PRECO)
											

					IF _NPRCVEN < _NPRECOUNIT      
						IF IsInCallStack('U_ADVEN002P')  == .T.
							Aadd(aPedidos,{cchave, ;
										''    , ;
										''    , ;
										''    , ;
										'PRECO M�NIMO DO PRODUTO '+ALLTRIM(_CPRODUTO)+' PARA '+_TABELA+' � DE R$ '+ALLTRIM(STR(_NPRECOUNIT)) , ;
										cVendedor}) 
						
						ELSEIF lSfInt //Everson - 25/09/2017. Chamado 037261.
								Aadd(aPedidos,{'PRECO M�NIMO DO PRODUTO '+ALLTRIM(_CPRODUTO)+' PARA '+_TABELA+' � DE R$ '+ALLTRIM(STR(_NPRECOUNIT))})
								
						ELSE
						
							MSGBOX("PRECO M�NIMO DO PRODUTO "+ALLTRIM(_CPRODUTO)+" PARA "+_TABELA+" � DE R$ "+ALLTRIM(STR(_NPRECOUNIT)),"ATENCAO","INFO")
							
						ENDIF
					
						_LPRECOOK   := .F.
					ELSE
						_LPRECOOK   := .T.
					ENDIF
					
				ENDIF
				
				IF ! _LPRECOOK
					ACOLS[N,_NPOSPRCVEN]	:=  _NPRECOUNIT //0
					_NPRCVEN	:= _NPRECOUNIT 
					ACOLS[N,_NPOSPRUNIT]	:=  _NPRECOUNIT //0   //Alterado 28/02/11 - ANA
				
				ELSE
					ACOLS[N,_NPOSPRCVEN]	:=  _NPRCVEN
				
				ENDIF
			ENDIF
	ENDIF

	//Conout( DToC(Date()) + " " + Time() + " AD0078 >>> FINAL PE" )

RETURN(iif(_M410LIOK,_LPRECOOK,_NPRCVEN)) //alterado para tratar retorno para o ponto de entrada M410LIOK  por Adriana em 10/08/10	
