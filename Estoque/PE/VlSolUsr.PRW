#include "protheus.ch"
#include "topconn.ch"


/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �VlSolUsr   �Autor  �Fernando Macieira   � Data � 09/Abr/09   ���
�������������������������������������������������������������������������͹��
���Desc.     � Valida usuario na requisicao ao armazem.                   ���
�������������������������������������������������������������������������͹��
���Uso       � Adoro                                                     ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/


User Function VlSolUsr()

Local lRet := .t.
Local cUser := AllTrim( Substr(cUsuario,7,15) ) 

If AllTrim(cSolic) <> cUser
	lRet := .f.
	Aviso(	"VLDUSER-01",;
	"Solicitando diferente do login... Contate o Administrador do sistema!",;
	{"&Ok"},,;
	"Solicitante nao permitido" )
EndIf

Return lRet 
