#INCLUDE "RWMAKE.ch"
#INCLUDE "PROTHEUS.ch" 
#INCLUDE "TOPCONN.ch"  
#INCLUDE "TBICONN.CH" 

//@history ticket 70750 - Everson - 07/04/2022 - Adapta��o do fonte para nova filial.
User Function AD0068()

// Rotina AD0068.PRW para exclus�o de Frete
// Gustavo a Logica � a seguinte
// 1 =  Busca o Frete
// 2 =  Verifica se tem pedido com nota fiscal 
// 3 =  Se n�o tem pedido pede confirma��o para exclus�o
// 4 =  Se confirmado Exclui
// 5 =  Retorno para Tela anterior

Local aArea	:= GetArea()
Local nCont := 0

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'exclus�o de Frete')

//Posiciona no Registro de Frete
_dDatEntr := SZK->ZK_DTENTR
_cRote    := SZK->ZK_ROTEIRO
_cPlac    := SZK->ZK_PLACA      
_nGuia    := SZK->ZK_GUIA
_cConfirm := .T.              
// Salva a situacao Atual
_sAlias := Alias()
_nOrder := IndexOrd()
_sRec   := Recno()


dbSelectArea("SZK")
//dbsetorder(2)                                            //Retirado esse dbSeek onde gerava desposicionamento da tabela e apagar o registro errado
//If dbSeek (xFilial("SZK")+_nGuia+DTOS(_dDatEntr)+_cPlac) //Apos os ajustes os erros foram sanados William Costa - CHAMADO 021041
	RecLock("SZK",.F.)                            
	// Verifica se Tem Relacionamento com Pedidos (Integridade Referencial)
	dbSelectArea("SC5")
	//dbSetOrder(9)
	SC5->(DBORDERNICKNAME("SC5_9")) //atualiza��o protheus 12 WILLIAM COSTA 28/12/2017 CHAMADO 036032
	If dbSeek( xFilial("SC5")+ DTOS(_dDatEntr)+_cRote + _cPlac )
	
		While SC5->C5_FILIAL == xFilial("SC5") .And.; //Everson - 26/12/2016. Chamado 031848.
		 	  SC5->C5_DTENTR == _dDatEntr .And.;
		 	  SC5->C5_ROTEIRO == _cRote .And.;
		 	  SC5->C5_PLACA == _cPlac
	
			If C5_NOTA <> Space(6) .And. checarSD2(C5_NUM) //Everson - 26/12/2016. Chamado 031848.
				_cConfirm := .F.
				Exit
				
			Endif
			
			SC5->(DbSkip())
			
		EndDo
		
	Endif
	// Confirma se Exclui ou nao o Frete se nao tiver pedido com Nota Fiscal
	If _cConfirm
		RecLock("SZK",.F.)
		_cTexto := " ROTEIRO: "+_cRote+" ENTREGA: "+DTOC(_dDatEntr)+" PLACA: "+_cPlac
		If MsgBox(_cTexto," CONFIRMA EXCLUSAO ","YESNO")
			dbDelete()
		Endif 
		MsUnlock()
	Else
	    
	    // *** INICIO CHAMADO WILLIAM 12/06/2018 - 042056 || ADM.LOG || BRUNA || 8446                           || EXCLUIR FRETE
		SqlVDuplicade(DTOS(_dDatEntr),_cPlac,_cRote)
		While TRC->(!EOF())
	                  
	            nCont := TRC->COUNT_SZK 
	            
            	TRC->(dbSkip())
		ENDDO
		TRC->(dbCloseArea())
		
		IF nCont >= 2
		
			IF SZK->ZK_KMENT > 0
		
				MsgBox("Ol� " + cUserName + CHR(10)+ CHR(13) + " S� � possivel deletar Frete Duplicado que o KM de Entrada n�o tenha sido calculado, favor verificar!!! ","AD0068")
				
			ELSE
			
				RecLock("SZK",.F.)
				_cTexto := " ROTEIRO: "+_cRote+" ENTREGA: "+DTOC(_dDatEntr)+" PLACA: "+_cPlac
				If MsgBox(_cTexto," CONFIRMA EXCLUSAO ","YESNO")
					dbDelete()
				Endif 
				MsUnlock()
			
			ENDIF
		ELSE
		
			MsgBox( " FRETE COM NOTAS FISCAIS RELACIONADAS. !!! (Exclusao nao Permitida)  ","AD0068" )
			
		ENDIF
		
		// *** FINAL CHAMADO WILLIAM 12/06/2018 - 042056 || ADM.LOG || BRUNA || 8446                           || EXCLUIR FRETE		
	Endif
//Endif

RestArea(aArea)

Return Nil
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �checarSD2         � Autor � Everson    � Data �26/12/2016   ���
�������������������������������������������������������������������������͹��
���Descricao � Fun��o para validar pedido nos documentos de sa�da.        ���
�������������������������������������������������������������������������͹��
���Uso       �  Chamado 031848                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/
Static Function checarSD2(cPedido)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.                                           �
	//�����������������������������������������������������������������������	
	Local aArea	:= GetArea()
	Local lRet 	:= .F.
	
	//Remove espa�os em branco.
	cPedido := Alltrim(cValToChar(cPedido))
	
	//Busca pedido na tabela SD2.
	DbSelectArea("SD2")
	SD2->(DbSetOrder(8)) //Filial + Pedido + Item
	If SD2->(DbSeek(xFilial("SD2") + cPedido))
		lRet := .T.
		
	EndIf
	
	RestArea(aArea)
	
Return lRet

STATIC FUNCTION SqlVDuplicade(cData,cPlaca,cRoteiro)

	BeginSQL Alias "TRC"
			%NoPARSER%  
			 SELECT COUNT(*) AS COUNT_SZK 
			   FROM %TABLE:SZK% WITH(NOLOCK)
			  WHERE ZK_FILIAL   = %EXP:FWFILIAL('SZK')% //ticket 70750 - Everson - 07/04/2022.
			    AND ZK_DTENTR   = %EXP:cData% 
			    AND ZK_PLACA    = %EXP:cPlaca%
			    AND ZK_ROTEIRO  = %EXP:cRoteiro%
			    AND D_E_L_E_T_ <> '*'			    
	EndSQl      
	   
RETURN(NIL)
