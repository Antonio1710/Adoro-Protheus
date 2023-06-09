
#INCLUDE "rwmake.ch"
#INCLUDE "TOPCONN.CH"
/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �  AD0024  � Autor �   Gustavo Gonela   � Data �  21/01/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio das Guias de Pesagem                             ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Portaria                                                   ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AD0024()
                        
U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio das Guias de Pesagem ')

//��������������������������������������Ŀ
//� Verifica as perguntas                �
//����������������������������������������
cPerg   := "BALAN"
Pergunte(cPerg,.F.)

//����������������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                                 �
//� mv_par01             // Tipo de pesagem - Entrega/Devolucao/Diversas �
//� mv_par02             // Data de                            			 �
//� mv_par03             // Dara ate                            		 �
//� mv_par04             // Numero Guia de                      		 �
//� mv_par05             // Numero Guia ate                			     �
//� mv_par06             // Placa de                            		 �
//� mv_par07             // Placa ate                       		     �
//������������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������


Private cString
aOrd := {}
Private CbTxt        := ""
cDesc1         := "Este programa tem como objetivo imprimir relatorio "
cDesc2         := "de acordo com os parametros informados pelo usuario."
cDesc3         := "Relatorio das Guias de Pesagem"
cPict          := ""
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private limite           := 220
Private tamanho          := "G"
Private nomeprog         := "AD0024"
Private nTipo            := 18
Private aReturn          := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey        := 0
titulo       := "Relatorio das Guias de Pesagem"
nLin         := 80

Cabec1       := ""
Cabec2       := ""
Private cbtxt      := Space(10)
Private cbcont     := 00
Private CONTFL     := 01
Private m_pag      := 01
imprime      := .T.
Private wnrel      := "AD0024" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString    := "ZV2"
dData              := dtos(DDATABASE)
dData1             := dtos(mv_par02)
dData2             := dtos(mv_par03)

//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,wnrel,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

If nLastKey == 27
	Return
Endif

SetDefault(aReturn,cString)

If nLastKey == 27
	Return
Endif

nTipo := If(aReturn[4]==1,15,18)

//���������������������������������������������������������������������Ŀ
//� Processamento. RPTSTATUS monta janela com a regua de processamento. �
//�����������������������������������������������������������������������

RptStatus({|| RunReport(Cabec1,Cabec2,Titulo,nLin) },Titulo)
Return

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Fun��o    �RUNREPORT � Autor � AP5 IDE            � Data �  21/01/03   ���
�������������������������������������������������������������������������͹��
���Descri��o � Funcao auxiliar chamada pela RPTSTATUS. A funcao RPTSTATUS ���
���          � monta a janela com a regua de processamento.               ���
�������������������������������������������������������������������������͹��
���Uso       � Programa principal                                         ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

Static Function RunReport(Cabec1,Cabec2,Titulo,nLin)

nOrdem   := ""

dbSelectArea(cString)
dbSetOrder(1)

//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������

//Cabec1  := "AD0024.PRW "+SPACE(47)+"ADORO ALIMENTICIA"
Cabec1  := SPACE(44)+"Periodo de : " + substr(dData1,7,2)+ "/" + substr(dData1,5,2)+ "/" + substr(dData1,1,4)+ SPACE(5) +  "Ate : " + substr(dData2,7,2)+ "/" + substr(dData2,5,2)+ "/" + substr(dData2,1,4)
cabec2	:= " "
Cabec3  := "|--------------------------------------------------------------------------------------------------------------------------------------|"
Cabec4  := "|N.GUIA | PLACA  | ROT |   MOTORISTA    |        1a Pesagem        |        2a Pesagem        |        3a Pesagem         |  % Dif     |"
Cabec5  := "|       |        |     |                |   Peso    Data   Hora    |  Peso     Data    Hora   |  Peso     Data    Hora    |            |"
Cabec6  := "|--------------------------------------------------------------------------------------------------------------------------------------|"


//���������������������������������������������������������������������Ŀ
//� Verifica o cancelamento pelo usuario...                             �
//�����������������������������������������������������������������������

If lAbortPrint
	@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
	//	Exit
Endif

//���������������������������������������������������������������������Ŀ
//� Impressao do cabecalho do relatorio. . .                            �
//�����������������������������������������������������������������������
If mv_par01 = 1
	_cTipo := 'E'
Else
	if mv_par01 = 2
		_cTipo := 'D'
	else
		_cTipo := 'A'
	Endif
Endif

If _cTipo = 'E'
	
	cQuery:="select * "+;
	"from "+retsqlname("ZV2")+" (NOLOCK) "+;
	"where ZV2_FILIAL='"+XFILIAL("ZV2")+"' and "+;
	"ZV2_TIPOPE='"+ _cTipo +"' and "+;
	"ZV2_DTENTR between '"+dtos(mv_par02)+"' and '"+ dtos(mv_par03)+"' and "+;
	"ZV2_PLACA between '"+   mv_par06   +"' and '"+    mv_par07    +"' and "+;
	"ZV2_GUIA  between '"+   mv_par04   +"' and '"+    mv_par05    +"' and "+;
	"D_E_L_E_T_= '' "+;
	"order by ZV2_GUIA"
	
Else
	
	cQuery:="select * "+;
	"from "+retsqlname("ZV2")+" (NOLOCK) "+;
	"where ZV2_FILIAL='"+XFILIAL("ZV2")+"' and "+;
	"ZV2_TIPOPE='"+ _cTipo +"' and "+;
	"ZV2_DATA1 between '"+dtos(mv_par02)+"' and '"+ dtos(mv_par03)+"' and "+;
	"ZV2_PLACA between '"+   mv_par06   +"' and '"+    mv_par07    +"' and "+;
	"ZV2_GUIA  between '"+   mv_par04   +"' and '"+    mv_par05    +"' and "+;
	"D_E_L_E_T_= '' "+;
	"order by ZV2_GUIA"
	
Endif

TCQUERY cQuery new alias "XV2"

XV2->(dbgotop())

//Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
dbSelectArea("XV2")
DO While !EOF ()
	If nLin > 60
		Cabec(Titulo,Cabec1,Cabec2,NomeProg,Tamanho,nTipo)
		nLin := 8
		@nLin,000 PSAY CABEC3
		nLin := nLin + 1
		@nLin,000 PSAY CABEC4
		nLin := nLin + 1
		@nLin,000 PSAY CABEC5
		nLin := nLin + 1
		@nLin,000 PSAY CABEC6
		nLin := nLin + 1
	
	Endif
	
	_cDia1	:=	substr((XV2->ZV2_DATA1),7,2)
	_cMes1	:=	substr((XV2->ZV2_DATA1),5,2)
	_cAno1	:=	substr((XV2->ZV2_DATA1),3,2)
	_cDia2	:=	substr((XV2->ZV2_DATA2),7,2)
	_cMes2	:=	substr((XV2->ZV2_DATA2),5,2)
	_cAno2	:=	substr((XV2->ZV2_DATA2),3,2)
	_cDia3	:=	substr((XV2->ZV2_DATA3),7,2)
	_cMes3	:=	substr((XV2->ZV2_DATA3),5,2)
	_cAno3	:=	substr((XV2->ZV2_DATA3),3,2)
	_cHora1	:=	substr((XV2->ZV2_HORA1),1,2)
	_cMin1	:=	substr((XV2->ZV2_HORA1),4,2)
	_cHora2	:=	substr((XV2->ZV2_HORA2),1,2)
	_cMin2	:=	substr((XV2->ZV2_HORA2),4,2)
	_cHora3	:=	substr((XV2->ZV2_HORA3),1,2)
	_cMin3	:=	substr((XV2->ZV2_HORA3),4,2)
	/*
	|N.GUIA | PLACA  |ROT|   MOTORISTA    |        1a Pesagem        |        2a Pesagem        |        3a Pesagem        |"
	|       |        |   	|                |  Peso       Data   Hora  |  Peso      Data    Hora  |  Peso      Data    Hora  |"
	999.999 XXX-9999 999 XXXXXXXXXXXXXXX  9.999.999  99/99/99 99:99  9.999.999  99/99/99 99:99  9.999.999  99/99/99 99:99
	*/
	@nLin,000 PSAY "|"
	@nLin,001 PSAY XV2->ZV2_GUIA
	@nLin,009 PSAY SUBSTR(XV2->ZV2_PLACA,1,3)+"-"+SUBSTR(XV2->ZV2_PLACA,4,4)
	@nLin,019 PSAY XV2->ZV2_ROTEIR
	@nLin,026 PSAY SUBSTR(XV2->ZV2_MOTORI,1,12)
	@nLin,040 PSAY "|"
	@nLin,041 PSAY XV2->ZV2_1PESO  PICTURE "@E 9999,999"
	@nLin,050 PSAY _cDia1	+ "/" + _cMes1	+	"/"	+ _cAno1
	@nLin,059 PSAY _cHora1  + ":" + _cMin1
	@nLin,067 PSAY "|"
	@nLin,068 PSAY XV2->ZV2_2PESO PICTURE "@E 9999,999"
	@nLin,077 PSAY _cDia2	+ "/" + _cMes2	+	"/"	+ _cAno2
	@nLin,087 PSAY _cHora2  + ":" + _cMin2
	@nLin,094 PSAY "|"
	@nLin,095 PSAY XV2->ZV2_3PESO PICTURE "@E 9999,999"
	@nLin,104 PSAY _cDia3	+ "/" + _cMes3	+	"/"	+ _cAno3
	@nLin,114 PSAY _cHora3  + ":" + _cMin3
	@nLin,122 PSAY "|"
	@nLin,123 PSAY XV2->ZV2_PERDIF PICTURE "@E 9999.999"
	@nLin,135 PSAY "|"
	nLin := nLin + 1
	@nLin,000 PSAY "|"
	@nLin,040 PSAY "|"
	@nLin,041 PSAY "OBS: " + SUBSTR (XV2->ZV2_OBS1,1,21)
	@nLin,067 PSAY "|"
	@nLin,068 PSAY "OBS: " + SUBSTR (XV2->ZV2_OBS2,1,21)
	@nLin,094 PSAY "|"
	@nLin,095 PSAY "OBS: " + SUBSTR (XV2->ZV2_OBS3,1,21)
	@nLin,135 PSAY "|"
	
	nLin := nLin + 1
	@nLin,000 PSAY "|" + Replicate("-",134)+ "|"
	nLin := nLin + 1
	
	dbSkip() // Avanca o ponteiro do registro no arquivo
EndDo

//���������������������������������������������������������������������Ŀ
//� Finaliza a execucao do relatorio...                                 �
//�����������������������������������������������������������������������

SET DEVICE TO SCREEN

//���������������������������������������������������������������������Ŀ
//� Se impressao em disco, chama o gerenciador de impressao...          �
//�����������������������������������������������������������������������

If aReturn[5]==1
	dbCommitAll()
	SET PRINTER TO
	OurSpool(wnrel)
Endif

MS_FLUSH()
dbclosearea("XV2")

Return

