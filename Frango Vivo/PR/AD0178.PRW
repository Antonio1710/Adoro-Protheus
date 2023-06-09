#include "rwmake.ch"

/*/{Protheus.doc} User Function AD0178
	Rotina de Processamento por Periodo do Frete
	@type  Function
	@author Werner dos Santos
	@since 21/02/06
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
	@history ticket 69945 - Fernando Macieira - 21/03/2022 - Projeto FAI - Ordens Carregamento - Frango vivo
/*/
User Function AD0178()

	Private _dData   := dDatabase
	Private _dData2  := dDatabase
	Private _dDataF  := dDatabase
	Public  _ProcPrd := 'S'

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Rotina de Processamento por Periodo do Frete')

	@ 00,000 TO 300,350 DIALOG oDlg1 TITLE "PROCESSAR FRETE FRANGO VIVO"
	nLin := 30
	@ nLin,030 SAY "Periodo de      : "
	@ nLin,090 GET  _dData SIZE 40,70
	nLin := nLin + 15
	@ nLin,030 SAY "Periodo ate     : "
	@ nLin,090 GET _dData2 SIZE 40,70
	nLin := nLin + 15
	@ nLin,030 SAY "Data Fechamento : "
	@ nLin,090 GET _dDataF SIZE 40,70
	nLin := nLin + 25

	@ nLin,040 BMPBUTTON TYPE 01 ACTION GravaFech()
	@ nLin,094 BMPBUTTON TYPE 02 ACTION Close(oDlg1)

	ACTIVATE DIALOG oDlg1 CENTER

Return

/*/
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
��� GravaFech    � Gravacao da Informa�oes                                 ���
���              �                                                         ���
��������������������������������������������������������������������������Ĵ��
��� Werner       | 21/02/06 � Funcao de Gravacao                           ���
���������������������������������������������������������������������������ٱ�
������������������������������������������������������������������������������
������������������������������������������������������������������������������
/*/
Static Function GravaFech()

	bBloco := {|lEnd| Proc_Fret()}
	MsAguarde(bBloco,"Aguarde, Gerando Valores do Frete ","Processando...",.T.)

	//Processa( {|| Proc_Fret() } , " Gerando Valores do Frete ")

	Close(Odlg1)

Return(.T.)

/*/{Protheus.doc} nomeStaticFunction
	(long_description)
	@type  Static Function
	@author user
	@since 21/03/2022
	@version version
	@param param_name, param_type, param_descr
	@return return_var, return_type, return_description
	@example
	(examples)
	@see (links_or_references)
/*/
Static Function Proc_Fret()

	_dDat_Abt  := DTOS(_dData)
	_dDat_Abt2 := DTOS(_dData2)

	dbSelectArea("ZV1") // Lancamentos de Descontos e Acrescimos
	dbSetOrder(4) // data + placa
	dbSeek(xFilial("ZV1")+_dDat_Abt ,.F.)

	//Do While !EOF() .and. DTOS(ZV1_DTABAT) >= (_dDat_Abt) 
	Do While !EOF() .and. DTOS(ZV1_DTABAT) >= (_dDat_Abt) .and. ZV1->ZV1_FILIAL==FWxFilial("ZV1") // @history ticket 69945 - Fernando Macieira - 21/03/2022 - Projeto FAI - Ordens Carregamento - Frango vivo
		//��������������������������������������������������������������������������Ŀ
		//� Guarda ambiente inicial                                                  �
		//����������������������������������������������������������������������������
		_cAliasZV1 := Alias()
		_nIndexZV1 := IndexOrd()
		_nRecnoZV1 := Recno()	
		If DTOS(ZV1_DTABAT) > (_dDat_Abt2)
			Exit                
		Endif
		if ALLTRIM(ZV1_STATUS)==''  &&Chamado 005157. Mauricio HC Consys 23/10/09. Ordem nao utilizada.
		dbSelectArea("ZV1")
		DbSkip()
		Loop
		endif   
		if ZV1_CAVES == 0 .and. ZV1_RAVES == 0 &&Chamado 005157. Mauricio HC Consys 23/10/09. Sem preenchimento pelo PCP.
		dbSelectArea("ZV1")
		DbSkip()
		Loop
		endif   
		Execblock("AD0153")
		//Replace ZI_DTFECH  With _dDataF
		//MsUnlock()
		MsprocTxt("Atualizando Frete da O.C.: " + ZV1_NUMOC)
		//��������������������������������������������������������������������������Ŀ
		//� Restaura ambiente inicial                                                �
		//����������������������������������������������������������������������������
		dbSelectArea("ZV1")
		dbSetOrder(_nIndexZV1)
		dbGoto(_nRecnoZV1)
		DbSkip()
	Enddo

Return(.T.)
