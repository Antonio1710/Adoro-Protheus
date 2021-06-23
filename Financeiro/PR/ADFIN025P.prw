#include "rwmake.ch"
#include "Protheus.ch"
/*/
苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘苘
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
北赏屯屯屯屯脱屯屯屯屯屯送屯屯屯淹屯屯屯屯屯屯屯屯屯退屯屯屯淹屯屯屯屯屯屯槐�
北篜rograma  矨DFIN025P � Autor � Fernando Sigoli    � Data �  03/01/17   罕�
北掏屯屯屯屯拓屯屯屯屯屯释屯屯屯贤屯屯屯屯屯屯屯屯屯褪屯屯屯贤屯屯屯屯屯屯贡�
北篋escri噭o � Programa para alteracao do parametro MV_BXCONC             罕�
北�          �                                                            罕�
北掏屯屯屯屯拓屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯贡�
北篣so       �                                                            罕�
北韧屯屯屯屯拖屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯屯急�
北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北北�
哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌哌
/*/
 
User Function ADFIN025P()

Local aAreaAnt := GetArea()
Local _cCodUser:= RetCodUsr()

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Programa para alteracao do parametro MV_BXCONC')

If Alltrim(_cCodUser) $ GetMV("MV_ALTBX")  

	If MsgBox("O parametro que Permite cancelamento de baixa conciliada esta como: "+IIF(GETMV("MV_BXCONC")== '1','PERMITE','N肙 PERMITE')+"."+ CHR(13)+ CHR(13)+ "Deseja alterar o par鈓etro?"," Altera par鈓etro MV_BXCONC  ","YESNO")
	
		If Pergunte("ALTBXCON")
			PutMv("MV_BXCONC ",MV_PAR01) 
			MsgAlert("Parametro Alterado")
		EndIf 
		
	Else
		MsgAlert("Processo Cancelado")
	EndIf
Else
	MsgAlert("Aten玢o! Acesso N鉶 autorizado")
EndIF	
RestArea(aAreaAnt)

Return .T.
 