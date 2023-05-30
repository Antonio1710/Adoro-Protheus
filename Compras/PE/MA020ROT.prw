#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �MA020ROT  � Autor � Mauricio da Silva  � Data �  18/05/10   ���
�������������������������������������������������������������������������͹��
���Descricao � Inclui nova opcao no cadastro de fornecedores              ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
 
User Function MA020ROT()

  Local _aRot   := {}
  Local lFilPreC := SuperGetMv( "MV_#PRECAD" , .F. , .F. ,  )
  
  if lFilPreC 
    // Ricardo Lima - 14/12/17
    AAdd( _aRot, { "Pr�-Cadastro"   , "U_ADCOM015P()", 3, 0 } )   
    AAdd( _aRot, { "Recusa Cadastro", "U_ADCOM012()" , 3, 0 } )   
  endif

  If __cUserID $ GETMV("MV_#USUFIN") // chamado 036079 - Fernando Sigoli 03/07/2017
    AAdd( _aRot, { "* Adm/Fin",      "U_ADFIN038P()", 8 , 0 })  
  EndIf
Return(_aRot)