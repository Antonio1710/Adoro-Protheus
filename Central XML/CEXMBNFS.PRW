#Include "Totvs.ch"
                    

 /*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �CEXMBNFS �Autor  �Fernando Sigoli      � Data �  19/02/2018 ���
�������������������������������������������������������������������������͹��
���Desc.     � P.E  CEXMBNFS  Adiciona bot�o de usuario na tela da NFS-e  ���
�������������������������������������������������������������������������͹��
���Uso       � Central XML                                                ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
   


/*/{Protheus.doc} CEXMBNFS
@description 	Exemplo de ponto de entrada CEXMBNFS
				Adiciona bot�o de usuario na tela da NFS-e
@author 		Amedeo D. Paoli Filho
@version		1.0
@return			ExpA1, A, Array de 3 Posicoes
@type 			Function
/*/

User Function CEXMBNFS()
	
	Local aRetorno	:= Array( 03 )

	aRetorno[1]	:= "ALTERAR SERIE"	//[01] - Descri��o da Fun��o (Ser� exibida no menu lateral)
	aRetorno[2]	:= "TRMIMG32.PNG"	//[02] - Imagem (Precisa estar no repositorio)
	aRetorno[3]	:= "CEXFESP"		//[03] - Fun��o de Usu�rio (User Function)

	U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'CENTRALXML- P.E Adiciona bot�o de usuario na tela da NFS-e ')

Return aRetorno


/*/{Protheus.doc} CEXFESP
@description 	Funcao acionada por botao especifico NFS-e
@author 		Amedeo D. Paoli Filho
@version		1.0
@type 			Function
/*/

User Function CEXFESP()

Private lOpt   := .F. 
Private oDlg	
Private cGet1  := Space(03)
Private oGet1

DEFINE MSDIALOG oDlg TITLE "Serie NF Servi�o" FROM C(178),C(181) TO C(284),C(308) PIXEL

	@ 008,048 MsGet oGet1 Var cGet1 Size 026,009 COLOR CLR_BLACK Picture "@!" PIXEL OF oDlg
	@ 009,014 Say "Serie NF" Size 029,007 COLOR CLR_BLACK PIXEL OF oDlg
	DEFINE SBUTTON FROM 037,012 TYPE 1 ACTION (lOpt := .T.,oDlg:End()) ENABLE OF oDlg
	DEFINE SBUTTON FROM 037,052 TYPE 2 ACTION (lOpt := .F.,oDlg:End()) ENABLE OF oDlg 
	
ACTIVATE MSDIALOG oDlg CENTERED 


If lOpt .and. Empty(cGet1)

	Alert("Informar serie da Nota Fiscal")
	lOpt := .F.
	Return .F.

EndIf

/*/		
Registro posicionado na tabela RECNFSXML
Campo com o numero da NF --> RECNFSXML->XML_NUMNF 
/*/

If lOpt   

	DbSelectArea("RECNFSXML")
	RecLock("RECNFSXML",.F.)
	Replace RECNFSXML->XML_NUMNF With ALLTRIM(cGet1)+SPACE(( TamSX3("F1_SERIE")[1] - LEN(ALLTRIM(cGet1)))) + SUBSTR(Alltrim(RECNFSXML->XML_NUMNF),LEN(Alltrim(RECNFSXML->XML_NUMNF))-8,LEN(Alltrim(RECNFSXML->XML_NUMNF)))
	MSUNLOCK()
	
EndIf
     
Return Nil