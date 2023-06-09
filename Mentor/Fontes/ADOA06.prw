#INCLUDE "PROTHEUS.CH"


/*/{Protheus.doc} User Function �ADOA06
	Interface de altera��o de dados do cliente.
	@type  Function
	@author Microsiga
	@since 03/26/2010
	@history Ticket 49882 || OS 051171 || FINANCAS || ANDREA || 8319 || PB3 X SZF - WILLIAM COSTA 18/06/2019 - Campo PB3_CODRED Salvando errado onde salvava o campo A1_REDE o correto e o A1_CODRED.
	@history Ticket T.I   - Fernando Sigoli        - 04/05/2019 Adicionado novos campos 'A1_XSFLFDS' ,'A1_XPALETE'.
	@history Ticket T.I   - Leonardo P. Monteiro   - 10/02/2021 - Corre��o na grava��o do campo A1_DESC para A1_ZZDESCB.
    @history Ticket 69520 - Leonardo P. Monteiro   - 17/03/2022 - Prepara��o da rotina para integra��es de diferentes Empresas/Filiais com a entrada da nova filial de Itupeva.
    @history Ticket 69520 - Fernando Macieira      - 01/04/2022 - Error log array out of bounds ( 3 of 2 )  on FWMBROWSE:ACTIVATE(FWMBROWSE.PRW) 18/05/2020 17:21:58 line : 399
    @history Ticket 70142 - Rodrigo Mello/Flek     - 10/06/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
    @history Ticket 78721 - Everson                - 24/08/2022 - Adicionado o campo A1_NREDUZ.
/*/

User Function ADOA06()

    Local aArea			:= GetArea()
    Private cCadastro	:= "Cadastro de Clientes"
    Private cString		:= "SA1"
    Private aRotina		:= { {"Pesquisar"	,"AxPesqui"		,0,1},;
                             {"Visualizar"	,"U_AD06CLI"	,0,2},;
                             {"Alterar"		,"U_AD06CLI"	,0,4},;
                             {"Enviar SF"	,"u_0080A0(1)"  ,0,2} } // @history Ticket 69520 - Fernando Macieira      - 01/04/2022 - Error log array out of bounds ( 3 of 2 )  on FWMBROWSE:ACTIVATE(FWMBROWSE.PRW) 18/05/2020 17:21:58 line : 399
                                                                    // @history Ticket 70142 - Rodrigo Mello/Flek     - 10/06/2022 - Substituicao de funcao Static Call por User Function MP 12.1.33
                                                                                                                                                            
    U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Interface de altera��o de dados do cliente ')

    DbSelectArea(cString)
    DbSetOrder(1)
    mBrowse( 6,1,22,75,cString)
    RestArea( aArea )

Return Nil       


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �ADOA06    �Autor  �Microsiga           � Data �  03/26/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �manuten��o em campo especificos no cadastro de clientes     ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function AD06Cli(cAlias, nRec, nOpc)

Local aCampos 	:= {'NOUSER', 'A1_COD', 'A1_NOME' , 'A1_SATIV1', 'A1_SATIV2','A1_ULTCOM',;
                    'A1_VEND', 'A1_GRPVEN', 'A1_TABELA', 'A1_REDE', 'A1_DESC',;
                    'A1_DDD','A1_DDI','A1_TEL','A1_TEL1','A1_FAX','A1_CONTATO','A1_EMAIL',;
                    'A1_SHELFLF','A1_PERSHEL','A1_PALLETZ','A1_TEL2','A1_TEL3','A1_TEL4',;
                    'A1_TEL5','A1_TEL6','A1_XVEND2','A1_XSFLFDS' ,'A1_XPALETE','A1_XLOCEXP','A1_XPEDMIN', 'A1_NREDUZ '}			   //Chamado: T.I - Fernando Sigoli 04/05/2019 //Ticket 78721 - Everson - 24/08/2022.


Local aAlter := {'A1_SATIV1', 'A1_SATIV2','A1_VEND','A1_XVEND2', 'A1_GRPVEN', 'A1_TABELA',;
                 'A1_REDE', 'A1_DESC','A1_DDD','A1_DDI','A1_TEL','A1_TEL1','A1_FAX',;
                 'A1_CONTATO','A1_EMAIL','A1_SHELFLF','A1_PERSHEL','A1_PALLETZ','A1_TEL2',;
                 'A1_TEL3','A1_TEL4','A1_TEL5','A1_TEL6','A1_XSFLFDS' ,'A1_XPALETE','A1_XLOCEXP','A1_XPEDMIN', 'A1_NREDUZ '} //Chamado: T.I - Fernando Sigoli 04/05/2019 //Ticket 78721 - Everson - 24/08/2022.	

U_ADINF009P('ADOA06' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Interface de altera��o de dados do cliente ')				 

If nOpc = 3 // Alterar
	AxAltera(cAlias  , nRec  , nOpc  , aCampos, aAlter ,           ,            ,          , 'U_ATUPB3' ) 
Else 
	AxVisual(cAlias, nRec, nOpc, aCampos)
Endif	                 

Return

/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �U_ATUPB3  �Autor  �Alexandre Circenis  � Data �  04/28/10   ���
�������������������������������������������������������������������������͹��
���Desc.     �Atualiza Pb3 com os dados Alterados                         ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP                                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/

User Function AtuPB3()

Local aArea := GetArea()
Local cVend := Posicione("SA3",1,xFilial("SA3")+M->A1_VEND, "A3_CODUSR")

U_ADINF009P('ADOA06' + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Interface de altera��o de dados do cliente ')

DbSelectArea("PB3")
DbSetOrder(11)
If dbSeek(xFilial("PB3")+M->A1_COD+M->A1_LOJA)
	RecLock("PB3",.F.)

	PB3->PB3_VEND   := cVend
	PB3->PB3_CODVEN := M->A1_VEND
	PB3->PB3_XVEND2 := M->A1_XVEND2
	PB3->PB3_SEGTO  := M->A1_SATIV1
	PB3->PB3_SUBSEG := M->A1_SATIV2
	PB3->PB3_TABELA := M->A1_TABELA
	PB3->PB3_GRPVEN := M->A1_GRPVEN
	PB3->PB3_CODRED := M->A1_CODRED  // William Costa 18/06/2019 049882 || OS 051171 || FINANCAS || ANDREA || 8319 || PB3 X SZF
	//PB3->PB3_DESC   := M->A1_DESC // Leonardo P. Monteiro - 10/02/2021 - Corre��o na grava��o do campo A1_DESC para A1_ZZDESCB.
	PB3->PB3_DDD    := M->A1_DDD
	PB3->PB3_DDI    := M->A1_DDI
	PB3->PB3_TEL    := M->A1_DDD+M->A1_TEL
	PB3->PB3_FAX    := M->A1_DDD+M->A1_FAX
	PB3->PB3_CONTAT := M->A1_CONTATO
	PB3->PB3_EMAIL  := M->A1_EMAIL
	PB3->PB3_XLOCPA	:= M->A1_XLOCEXP
    PB3->PB3_NREDUZ := M->A1_NREDUZ //Ticket 78721 - Everson - 24/08/2022.	

	msUnlock()
Endif
DbSetOrder(1)
	
RestArea(aArea)

Return

/* Busca as informa��es do cabe�alho. */
Static Function fgetSX3(cCampos)
    Local aRet      := {}
    Local cCampo    := ""
    Local nX        := 0
    Local nCampos   := 0
    Local bValid
    Local aCampos   := Separa(cCampos,",")
    
    dbselectarea("SX3")
    sx3->(dbsetorder(2)) // Campo
    nCampos := len(aCampos)
    
    for nx := 1 to nCampos

        cCampo := Alltrim(aCampos[nX])
        cUsado := GetSX3Cache(cCampo, "X3_USADO")
        
        if !Empty(GetSX3Cache(cCampo, "X3_CAMPO"))

            bValid := Alltrim(GetSX3Cache(cCampo, "X3_VALID"))

            if Empty(bValid)
                bValid := {|| .T. }
            ELSE
                bValid := &("{|| "+Alltrim(GetSX3Cache(cCampo, "X3_VALID")) +" }")
            endif

            aadd(aRet,{ alltrim(GetSX3Cache(cCampo, "X3_TITULO")),;
            GetSX3Cache(cCampo, "X3_CAMPO")	,;
            GetSX3Cache(cCampo, "X3_PICTURE"),;
            GetSX3Cache(cCampo, "X3_TAMANHO"),;
            GetSX3Cache(cCampo, "X3_DECIMAL"),;
            bValid,;
            GetSX3Cache(cCampo, "X3_USADO"),;
            GetSX3Cache(cCampo, "X3_TIPO"),;
            GetSX3Cache(cCampo, "X3_F3"),;
            GetSX3Cache(cCampo, "X3_CONTEXT"),;
            GetSX3Cache(cCampo, "X3_CBOX"),;
            GetSX3Cache(cCampo, "X3_RELACAO")})
        endif
    next nx

return aRet
