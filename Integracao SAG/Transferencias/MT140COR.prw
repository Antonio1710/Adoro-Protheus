#Include 'Protheus.ch'

/*
������������������������������������������������������������������������������
������������������������������������������������������������������������������
��������������������������������������������������������������������������Ŀ��
���Fun��o	 ?MT140COR     ?Autor ?Leonardo Rios	     ?Data ?13.04.16 ��?
��������������������������������������������������������������������������Ĵ��
���Desc.     ?Efetua tratamento no menu da Rotina de Pr?Nota para possibi��?
��?		 ?litar o tratamento do estorno de pr?notas			   	   ��?
��������������������������������������������������������������������������Ĵ��
���Uso		 ?MATA140 - Pr?Documento de Entrada						   ��?
��?		 ?Ponto de entrada para manipular o array com as regras e     ��?
��?		 ?cores da Mbrowse											   ��?
��?		 ?Projeto SAG II											   ��?
��������������������������������������������������������������������������Ĵ��
������������������������������������������������������������������������������
������������������������������������������������������������������������������
@history ticket TI - Antonio Domingos - 26/05/2023 - Revis?o Ajuste Nova Empresa
*/
User Function MT140COR()

	Local aRet	     := paramixb[1]
	Local n		     := 0
	Private _cEmpAt1 := SuperGetMv("MV_#EMPAT1",.F.,"01/13") //Codigo de Empresas Ativas Grupo 1 //ticket TI - William Costa - 20/05/2023

   // ticket 84085 - 01/12/2022 - Fernando Macieira - TRANSFERENCIA DE ATIVO IMOBILIZADO nota fiscal n�o aparece no Faturamento
	If AllTrim(FUNNAME())=="ATFA060" .or. IsInCallStack("ATFA060")
		Return aRet
	EndIf


	If Alltrim(cEmpAnt) $ _cEmpAt1 //ticket TI - William Costa - 20/05/2023
		If ISINCALLSTACK("U_INTNFEB")
			Return aRet
		EndIf

		For n:=1 To Len(aRotina)    
			If aRotina[n][1] $ "Es&torna Classif"	
				aRotina[n][2] := "U_ADSAG001"		
			EndIf
		Next n                 
	Endif	

Return aRet
