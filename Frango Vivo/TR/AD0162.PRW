#include "rwmake.ch"  

User Function AD0162()     

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Atualizar Valor do Frete  Quando for fechada a Ordem de Carregamento')

// Atualizacao do Frete Arquivo (SZK010), Execblock executado dentro


/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Fun��o    � Frete � Autor � Werner  / Daniel      � Data � 22/12/05 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Atualizar Valor do Frete  Quando for fechada a Ordem de Carregamento            ���
�������������������������������������������������������������������������Ĵ��
���Sintaxe   �                                                            ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Ad'oro Alimenticia                              ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
���Desc.     �Manutencao, do fonte. Incluido filtro por tipo de frete.    ���
���          �E calculo do frete do frango VIVO                           ���
�������������������������������������������������������������������������͹��
���Uso       � AP7, FRETE                                                 ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


// Ambiente Inicial
_cAlias := Alias()
_nOrder := IndexOrd()
_nRecno := Recno()


//���������Ŀ
//�VARIAVEIS�
//�����������


Private _cCodFor   := space(6)  //Cod do fornecedor
Private _cLojFor   := space(2)  //Loja
Private _cNomFor   := space(30) //Nome do Fornecedor
Private _cTabPrec  := space(2)  //Tabela de frete
Private _TipTabela := space(2)
Private _cTipoFrt  := space(2)  //TIPO DE FRETE
Private _cParFrt   := space(10)
Private _nFV2KMSAI	:=0 		//KM DE SAIDA TABELA ZV2
Private _nFV2KMENT	:=0 		//KM DE CHEGADA TABELA ZV2
Private _cERRO		:=""		//VARIALVEL DE CONTROLE
Private _nZC0KMINI  :=0			//KM INICIAL DE ZC0
Private _nZC0KMFIM  :=0			//KM FINAL DE ZC0
Private _nZC0FRTTON :=0			//TARIFA POR RANGE
Private _nVALFRT    :=0			//VALOR DO FRETE
Private _cTPFRETINI	:=""		//TIPO DE FRETE INICIAL
Private _cTPFRETFIM	:=""		//TIPO DE FRETE FINAL
Private _nSZKRANGE 	:=0			//KM A PAGAR
Private _cMVCALFRT1 :=''			//PARAMETRO DE SX6, TIPOS DE FRETE FRANGO ABATIDO
Private _cMVCALFRT2 :=''			//PARAMETRO DE SX6, TIPO DE FRETE FRANGO VIVO
Private _cValFrtVivo:=''		//PARAMETRO QUE DIZ SE CALCULA FRETE FRANGO VIVO
Private _nMVFORMFRT :=0		//Recebe a referencia qual formula puxar da tabela SM4010
Private _cParFrt1  := SPACE (10)
Private _cParFrt2  := SPACE (10)
Private _cParFrt3  := SPACE (10)
Private _cNumOc    := SPACE (06)
Private _cMVCALFRT3:= SPACE (10)
Private _nToneladas:= 0
Private _dDat_frt  := DDATABASE 
Private _Vlton     := 0
//�����������������������������������������������������Ŀ
//�Vou procurar pelo Km Final e Incial na Tabela ZV2010.�
//�Faco a diferen�a das KM.-> Range                     �
//�Procuro essa diferen�a na tabela ZC0010              �
//�Realizo o calculo Tarifa x KM Rodado                 �
//�������������������������������������������������������
//TABELA DE FRETE
dbSelectArea("SZK")
dbsetorder(2)
If dbSeek (xFilial("SZK")+_nGuia+DTOS(_dDatEntr)+_cPlac,.T.)

	//grava log chamado 041202 - WILLIAM COSTA 23/04/2018
	u_GrLogZBE (Date(),TIME(),cUserName," RecLock(SZK,.T.)","LOGISTICA","AD0162",;
	"Filial: "+xFilial("SZK")+" Data: "+DTOS(_dDatEntr)+" Placa: "+_cPlac+" GUIA: "+CVALTOCHAR(_nGuia),ComputerName(),LogUserName())

	
	RecLock("SZK",.F.)
	//Atualizo a tabela de caminhao com a placa que efetuou a entrega
	_cNumOc       := ZK_NUMOC
	_cPlacPag     := ZK_PLACAPG	//PLACA PAGA
	_TipTabela	  := ZK_TABELA
	_cTipoFrt 	  := ZK_TPFRETE	//TIPO DE FRETE
	_nToneladas   := ZK_PESOL     //PESO LIQUIDO
	_dDat_frt     := ZK_DTENTR    //Data da Viagem
	/***CALCULANDO RANGE DE KM***/
	_nSZKRANGE    := ZK_KMPAG  //RANGE OU DIFERENCA DE KMENT - KMSAI
	//�������������������������������������������������������������|
	//�Procurando em SX6 pelo parametro .                          �
	//�Faco uma busca na variavel pelo tipo de frete de retorno de �
	//�SZK.                                                        �
	//�	                                                           �
	//�������������������������������������������������������������|
	/*
	//PARAMETROS DO FRANGO ABATIDO
	_cParFrt1 := 'MV_CALFRT1'
	DBSELECTAREA("SX6")
	dbsetorder(1)
	IF DBSEEK("  " + _cParFrt1 ,.T.)
	_cCALFRT1	 :=X6_CONTEUD
	_cCALFRT3  :=X6_CONTSPA
	ENDIF
	
	//PARAMETROS DO FRANGO VIVO
	_cParFrt2 :=	'MV_CALFRT2'
	IF DbSeek("  " + _cParFrt2 ,.T.)
	_cCALFRT2:=X6_CONTEUD
	//_cCALFRT4:=X6_CONTSPA
	ENDIF
	
	//�������������������������������������|
	//�FORMULAS ADQUIRINDO DA TABELA SM4010�
	//�������������������������������������|
	
	DBSELECTAREA ("SM4")
	DBSETORDER(1)
	//PROCURANDO NA TABELA PELO _nMVFORMFRT, CALCULO DO FRETE FRANGO ABATIDO
	If DBSEEK (xFilial("SM4")+ _cCALFRT3)
	_cFret1:=M4_FORMULA
	ELSE
	_cFret1:=''
	Endif
	
	
	//��������������������������������������������������������������|
	//�Faco a busca do tipo de frete de SZK no parametro            �
	//�Estando dentro de MV_CALFRT1 -> frete normal                 �
	//�Estando dentro de MV_CALFRT2 -> frete frango vivo            �
	//�                                                             �
	//�Marco status na variavela  _cValFrtVivo                      �
	//�                                                             �
	//�STATUS = 'N' -> nao joga valor do frete do frango vivo em SZK�
	//�STATUS = 'S' -> joga valor do frete do frango vivo em SZK    �
	//��������������������������������������������������������������|
	
	if _cTipoFrt $(_cCALFRT1)
	_cValFrt:='N'
	endif
	if _cTipoFrt $(_cCALFRT2)
	_cValFrt:='S'
	endif
	*/
	//����������������������������������������������Ŀ
	//�PROCURANDO EM ZC0 O TIPO DE FRETE ADQUIRIDO EM�
	//�SZK PARA CALCULO DO FRETE CONFORME O RANGE    �
	//������������������������������������������������
	_nVALFRT := 0                 // Caso nao encontre
	_cERRO:="Nao Calculou "       // Deixa o valor zerado
	DBSELECTAREA ("ZC0")
	DBSETORDER(1)
	IF DBSEEK (xFilial("ZC0") + _cTipoFrt,.F.)//+ DTOC('01/10/2005')  , .F.) //_dDatEntr
		WHILE !EOF() .AND. ZC0_TIPFRT == _cTipoFrt
			If ZC0_DATVAL > _dDat_frt
				Exit // Sair quando Achar data mair que 
				// a data da Ordem
			Endif
			//VERIFICANDO SE E A ULTIMA TABELA
			If ZC0_DATVAL <= _dDat_frt
				//VERIFICANDO SE ESTA NO RANGE E SE ESTA CALCULA A TARIFA
				IF ((_nSZKRANGE>=ZC0_KMINI) .AND. (_nSZKRANGE<=ZC0_KMFIM))
					_nVALFRT := ZC0_FRTTOM
					_cERRO:="OK"
					//Achou o range cai fora
					//Considerando a data sempre menor que a referencia
					//Exit // Sair quando Achou a ultima faixa 
				ENDIF
			Endif
			DBSKIP()
		ENDDO
	ENDIF

	// So grava se o Valor do Frete for maior que zero
	If _nVALFRT = 0
		// Se nao Calculou na Tabela de Km procura na Tablela de Tonelagem
		//������������������|
		//�CALCULO DO FRETE �
		//������������������|
		_Vlvei    := 0
		_Vlentre  := 0
		_Bandeir  := 0
		
		//TABELA PRECO DE FRETES
		dbSelectArea("SZG")
		dbSetOrder(1)
		If dbSeek (xFilial("SZG")+_cTipoFrt)
			dbSelectArea("ZVB")
     		dbSetOrder(1)
			If dbSeek (xFilial("ZVB")+_TipTabela)
			   While _TipTabela = ZVB->ZVB_CODTAB
			        If (_dDatEntr >= ZVB->ZVB_DATINI ).AND. (_dDatEntr <= ZVB->ZVB_DATFIM )
    			        _Vlton    := ZVB_PRECO
			        End If
			        Dbskip()
			   End Do
			Else
			   Alert("N�o existe pre�o cadastrado para este tipo de frete.")
			End If                 
			// Divide por 1000 para calcular a tonelada
			_nVALFRT  := _Vlton * _nToneladas / 1000
			If _nVALFRT <= 0
		   	    ALERT("Verifique o cadastro de frete para esta data de entrega, pois nao possui pre�o cadastrado para esta data")
		End If  
			//�����������������������������������������������������Ŀ
			//�Verificando se calcula frete do Frango Vivo          �
			//�Calcula pro um parametro                             �
			//�Verifica se foi encontrado o parametro               �
			//�Verifica se e frete Frango Vivo e altera para o mesmo�
			//�Caso nao atenda os itens acima zera o valor de frete �
			//�������������������������������������������������������
		ENDIF
	Endif
	
	//��������������������������Ŀ
	//�Atualizano tabela de Frete�
	//����������������������������
	
	//grava log chamado 041202 - WILLIAM COSTA 23/04/2018
	u_GrLogZBE (Date(),TIME(),cUserName,"2 RecLock(SZK,.T.)","LOGISTICA","AD0162",;
	"Filial: "+xFilial("SZK")+" Data: "+DTOS(_dDatEntr)+" Placa: "+_cPlac+" GUIA: "+CVALTOCHAR(_nGuia),ComputerName(),LogUserName())
	
	dbSelectArea("SZK")
	u_GrLogZBE (Date(),TIME(),cUserName,"3 RecLock(SZK,.T.)","LOGISTICA","AD0162",;
	"Filial: "+xFilial("SZK")+" Data: "+DTOS(SZK->ZK_DTENTR)+" Placa: "+SZK->ZK_PLACA+" GUIA: "+SZK->ZK_GUIA,ComputerName(),LogUserName())
	Reclock("SZK",.F.)
	Replace SZK->ZK_VALFRET With _nVALFRT
	Replace SZK->ZK_STATUS  With "C"
	MsUnlock()

ELSE

	//grava log chamado 041202 - WILLIAM COSTA 23/04/2018
	u_GrLogZBE (Date(),TIME(),cUserName,"ELSE RecLock(SZK,.T.)","LOGISTICA","AD0162",;
	"Filial: "+xFilial("SZK")+" Data: "+DTOS(_dDatEntr)+" Placa: "+_cPlac+" GUIA: "+CVALTOCHAR(_nGuia),ComputerName(),LogUserName())

Endif
// Se nao calculou informe os detelhes
If _nVALFRT = 0	
	_cERRO:="NAO CALCULOU FRETE, SEM DADOS TABELA O.C. "+_cNumOc 
	ALERT (_cERRO)
Endif

// Zerar Variaveis
_Vlvei    := 0
_Vlentre  := 0
_Nentre   := 0
_Bandeir  := 0

dbCloseArea("SZK")
dbCloseArea("SZG")
dbCloseArea("ZV4")
dbCloseArea("SX6")
dbCloseArea("ZV2")
dbCloseArea("ZC0")
dbCloseArea("SA2")
dbCloseArea("SZH")
DBCLOSEAREA("SM4")

// Restaura ambiente Inicial
dbSelectArea(_cAlias)
dbSetOrder(_nOrder)
dbGoto(_nRecno)

// Retorna o Valor do Frete

Return
