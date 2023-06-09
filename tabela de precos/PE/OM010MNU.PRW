#Include "Totvs.ch"
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �OM010MNU       �Autor  �Everson      � Data �  04/03/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Adicionar rotinas ao menu da tabela de pre�os.              ���
��           �http://tdn.totvs.com/pages/releaseview.action?pageId=6091276���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
@history Everson, 14/04/2022. Chamado 71231 - Tratamento para envio de meta apenas pela empresa 01 e filial 02.
@history Everson, 12/09/2022. Chamado TI - Tratamento para filial de Itapira.
@history ticket TI - Antonio Domingos    - 13/05/2023 - Ajuste Nova Empresa
@history ticket TI - Antonio Domingos - 26/05/2023 - Revis�o Ajuste Nova Empresa

*/
User Function OM010MNU()

	//���������������������������������������������������������������������Ŀ
	//� Declaracao de Variaveis                                             �
	//�����������������������������������������������������������������������	
	Local aArea	  := GetArea()
	Local _cEmpFL1 := SuperGetMv("MV_#EMPFL1",.F.,"0102/1301") //Codigo de Empresas+Filiais Ativas Grupo 1
	Local _cEmpFL3 := SuperGetMv("MV_#EMPFL3",.F.,"0102/010B/1301") //Codigo de Empresas+Filiais Ativas Grupo 3
	//

	//Everson - 04/03/2018. Chamado 037261. SalesForce.
	If alltrim(cEmpAnt)+alltrim(cFilAnt) $ _cEmpFL3 //Chamado TI - Tratamento para filial de Itapira. //ticket TI - Antonio Domingos    - 13/05/2023
		Aadd(aRotina,{'SF Exportar'      ,'U_intTabPEnvSF(1)' , 0 , 6,0,NIL}) 

	EndIf

	If alltrim(cEmpAnt)+alltrim(cFilAnt)  $ _cEmpFL1 //Chamado TI - Tratamento para filial de Itapira. ticket TI - Antonio Domingos    - 13/05/2023
		Aadd(aRotina,{'SF Exp. Max. Min.','U_intTabPEnvSF(2)' , 0 , 7,0,NIL}) 
	EndIf
	
	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �intEnvSF       �Autor  �Everson      � Data �  04/03/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Envia tabela de pre�o para o SalesForce.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
User Function intTabPEnvSF(nOpc)

	//���������������������������������������������������������������������Ŀ
	//� Declara��o de vari�veis.
	//�����������������������������������������������������������������������	
	Local aArea	   	:= GetArea()
	Local oTelMenu	:= Nil
	Local oDe		:= Nil
	Local oAt		:= Nil
	Local oCanc  	:= Nil
	Local oOk		:= Nil
	Local oSay1		:= Nil
	
	//Private aItems	:= {'1=Cadastro','2=Contrato','3=Frete','4=Vl Min. Seg'}
	Private cCombo1 := ""
	Private oCombo1	:= Nil
	Private cDe		:= Space(TamSX3("DA0_CODTAB")[1])
	Private cAte	:= Space(TamSX3("DA0_CODTAB")[1])
	
	//
	If nOpc == 2
		U_ADVEN073P( DToS(Date()), DToS(Date()),.F.,"",.T.)
		RestArea(aArea)
		Return Nil
		
	EndIf
	
	oTelMenu			:= MsDialog():Create()
	oTelMenu:cName     := "oTelMenu"
	oTelMenu:cCaption  := "Envio SalesForce"
	oTelMenu:nLeft     := 34
	oTelMenu:nTop      := 222
	oTelMenu:nWidth    := 250
	oTelMenu:nHeight   := 210
	oTelMenu:lShowHint := .F.
	oTelMenu:lCentered := .T.
	
		//
		//cCombo1:= aItems[1]
		//oCombo1 := TComboBox():New(010,010,{|u|if(PCount()>0,cCombo1:=u,cCombo1)},;
		//aItems,100,20,oTelMenu,,{|| };
		//,,,,.T.,,,,,,,,,'cCombo1')
		
		oSay1:= TSay():New(010,010,{||'Informe as tabelas a serem enviadas ao SalesForce.'},oTelMenu,,,,,,.T.,CLR_RED,CLR_WHITE,100,15)
		
		oDe  := TGet():New(030,010,{|u|If(PCount() == 0,cDe,cDe := u)},oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cDe",,,,.T.,,,"De:",2)
		
		oAt  := TGet():New(050,010,{|u|If(PCount() == 0,cAte,cAte := u)},oTelMenu,050,010,"@C",,0,16777215,,.F.,,.T.,,.F.,,.F.,.F.,,.F.,.F. ,,"cAte",,,,.T.,,,"At�:",2)
		
		oOk     := TButton():New(070,010,"Enviar"  ,oTelMenu,{|| exTabPSfExp(cDe,cAte), oTelMenu:End() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )
		oCanc   := TButton():New(070,075,"Cancelar",oTelMenu,{|| oTelMenu:End() },040,010,,,.F.,.T.,.F.,,.F.,,,.F. )	
		
	oTelMenu:Activate(,,,.T.,{||.T.},,{||  })
	
	//
	RestArea(aArea)
	
Return Nil
/*
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �envSF          �Autor  �Everson      � Data �  04/03/2018   ���
�������������������������������������������������������������������������͹��
���Desc.     �Envia tabela de pre�o para o SalesForce.                    ���
�������������������������������������������������������������������������͹��
���Uso       � Chamado 037261.                                            ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
*/
Static Function exTabPSfExp(cDe,cAte)
	
	//
	If FindFunction("U_ADVEN072P")
		U_ADVEN072P(cDe,cAte,.F.,"")
	
	EndIf

Return Nil
