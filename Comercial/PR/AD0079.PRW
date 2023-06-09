#include "rwmake.ch"
#include "PRTOPDEF.CH"

User Function AD0079()
                         
U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Chamada para  MATA410 Vendedores   - Somente seus PVs dos respectivos clientes Supervisores - Somente seus PVs e PVs de seus vendedores Gerentes     - Todos os PVs')

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � AD0079   � Autor � Rogerio Eduardo Nutti � Data � 01.10.03 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Filtra Pedidos de Venda conforme nivel do usuario          ���
�������������������������������������������������������������������������Ĵ��
��� Uso      � Especifico Ad'oro Alimenticia                              ���
���          � Chamada para  MATA410                                      ���
���          �                                                            ���
���          � Vendedores   - Somente seus PV's dos respectivos clientes  ���
���          � Supervisores - Somente seus PV's e PV's de seus vendedores ���
���          � Gerentes     - Todos os PV's                               ���
�������������������������������������������������������������������������Ĵ��
��� Revis�o  �                                          � Data �          ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


Private aInd    := {}
Private bFiltraBrw := {|| Nil}

//��������������������������������������������������������������Ŀ
//� Variaveis                                                    �
//����������������������������������������������������������������
&&Mauricio - 02/07/14 - mudado logica para trazer codigo do usuario conforme apurado com o Sr. Vagner
//_cUserName  := Subs(cUsuario,7,15)   // Nome do Usuario 
_cUserName := Alltrim(cUsername)

//��������������������������������������������������������������Ŀ
//� 1a. Verificacao - E' Gerente ?                               �
//����������������������������������������������������������������
If ! Alltrim(_cUserName) $ GetMV("MV_GERENTE")         // Se for gerente nao tem Filtro
   &&Mauricio - 02/07/04 - novo processo citado acima....
   _cCodUs := __cUserID

	//��������������������������������������������������������������Ŀ
	//� 2a. Verificacao - E' Supervisor ?                            �
	//����������������������������������������������������������������
	//dbSelectArea("SZR")
	//dbSetOrder(2)            // ZR_FILIAL+ZR_DESCRIC
	//If dbSeek( xFilial("SZR")+_cUserName )
	
    //   	_cCodSup := SZR->ZR_CODIGO            // Busca Codigo Supervisor

		dbSelectArea("SA3")
		dbSetOrder(7)
		If dbSeek( xFilial("SA3")+_cCodUs )
		   If SA3->A3_NIVETAB == "2"  &&Supervisor
              _aCodSup := {}
              While SA3->(!Eof()) .And. SA3->A3_CODUSR == _cCodUs
                    AADD(_aCodSup,{SA3->A3_SUPER})           
                    SA3->(dbSkip())
              Enddo 
           
			  //��������������������������������������������������������������Ŀ
			  //� Armazena em _cSupVends todos os Vendedores do Supervisor     �
			  //����������������������������������������������������������������		
			  _cSupVends  := ""
			
			  For _ni := 1 to len(_aCodSup)
			      dbSelectArea("SA3")
		          dbSetOrder(5)        // A3_FILIAL+A3_SUPER
		          If dbSeek( xFilial("SA3")+_aCodSup[_ni][1] )			    
		  	         Do While !Eof() .and. xFilial("SA3") == SA3->A3_FILIAL	.and. ;
				 				  _aCodSup[_ni][1]       == SA3->A3_SUPER
				        _cSupVends  :=  _cSupVends + SA3->A3_COD+"/" 							
				        SA3->(dbSkip())
		             Enddo
		          Endif   	 				  
		      Next _ni
			  //��������������������������������������������������������������Ŀ
			  //� Filtra PV's e Clientes pelos Vendedores do Supervisor        �
			  //����������������������������������������������������������������
              If !Empty(_cSupVends) 

                 //dbSelectArea("SC5")
                 //Set Filter to C5_VEND1 $ _cSupVends
							 
				 dbSelectArea("SC5")
    	         cCondicao  := " C5_VEND1  $ '"+ _cSupVends + "'"   
                 bFiltraBrw := {|| FilBrowse("SC5",@aInd,@cCondicao)}
                 Eval(bFiltraBrw)
				 
				 dbSelectArea("SA1")
				 Set Filter to A1_VEND  $ _cSupVends
				 
				 
				 //dbSelectArea("SA1")
    	         //cCondicao  := " A1_VEND  $ '"+ _cSupVends + "'"   
                 //bFiltraBrw := {|| FilBrowse("SA1",@aInd,@cCondicao)}
                 //Eval(bFiltraBrw)
			  Endif	
           Elseif SA3->A3_NIVETAB == "1"  &&Vendedor
                  _cCodVen := SA3->A3_COD              // Busca Codigo Vendedor

			      //��������������������������������������������������������������Ŀ
			      //� Filtra PV's e Clientes pelo Codigo do Vendedor               �
			      //����������������������������������������������������������������
			      dbSelectArea("SC5")
    	          cCondicao  := " C5_VEND1  == '"+ _cCodVen + "'"   
                  bFiltraBrw := {|| FilBrowse("SC5",@aInd,@cCondicao)}
                  Eval(bFiltraBrw)
                  //dbSelectArea("SC5")					 
			      //Set Filter to C5_VEND1 == _cCodVen		
			
			      dbSelectArea("SA1")					
			      Set Filter to A1_VEND  == _cCodVen		
			
 		   Endif                  
	    Endif	
Endif

MATA410()

//dbSelectArea("SC5") ; Set Filter to
//dbSelectArea("SA1") ; Set Filter to

dbSelectArea("SC5") 
EndFilBrw("SC5",aInd)

dbSelectArea("SA1") ; Set Filter to

Return()
