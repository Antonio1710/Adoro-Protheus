/*
��������������������������������������������������������������������������
��������������������������������������������������������������������������
����������������������������������������������������������������������ͻ��
���MANUTENCAO|Autor  � DANIEL PITTHAN SILVEIRA    � Data �  10/27/06   ���
����������������������������������������������������������������������͹��
���Desc.     � CORRIGO OS PONTOS CHUMBADOS                             ���
���          �                                                         ���
����������������������������������������������������������������������͹��
���Uso       � AP                                                      ���
����������������������������������������������������������������������ͼ��
��������������������������������������������������������������������������
��������������������������������������������������������������������������
*/
#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  � AD0086   � Autor � Gustavo Gonela     � Data �  28/10/03   ���
�������������������������������������������������������������������������͹��
���Descricao � Relatorio de Movimentacao de Frete Longo Percurso          ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � Logistica                                                  ���
�������������������������������������������������������������������������Ĵ��
���REVISAO   � Revidado por Daniel 23/10/06 - Alterado e corrigido os     |��
���			 � Pontos chumbados 										  |��
���   		 � 															  |��
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������/*/

User Function AD0086

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Relatorio de Movimentacao de Frete Longo Percurso')

//��������������������������������������������������������������Ŀ
//� Variaveis utilizadas para parametros                         �
//� mv_par01             // Data de                              |
//� mv_par02             // Data ate                             �
//����������������������������������������������������������������

cPerg   := "AD0086"
Pergunte(cPerg,.F.)

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

cDesc1       := "Este programa tem como objetivo imprimir relatorio "
cDesc2       := "de acordo com os parametros informados pelo usuario."
cDesc3       := "Movimentacao de Frete Longo Percurso"
cPict        := ""
titulo       := "Movimentacao de Frete Longo Percurso"
nLin         := 80

Cabec1       := ""
Cabec2       := ""
imprime      := .T.
aOrd := {}
Private lEnd         := .F.
Private lAbortPrint  := .F.
Private CbTxt        := ""
Private limite       := 220
Private tamanho      := "G"
Private nomeprog     := "AD0086" // Coloque aqui o nome do programa para impressao no cabecalho
Private nTipo        := 15
Private aReturn      := { "Zebrado", 1, "Administracao", 2, 2, 1, "", 1}
Private nLastKey     := 0
Private cbtxt        := Space(10)
Private cbcont       := 00
Private CONTFL       := 01
Private m_pag        := 01
Private wnrel        := "AD0086" // Coloque aqui o nome do arquivo usado para impressao em disco

Private cString := "SZK"


//���������������������������������������������������������������������Ŀ
//� Monta a interface padrao com o usuario...                           �
//�����������������������������������������������������������������������

wnrel := SetPrint(cString,NomeProg,cPerg,@titulo,cDesc1,cDesc2,cDesc3,.T.,aOrd,.T.,Tamanho,,.T.)

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
���Fun��o    �RUNREPORT � Autor � AP6 IDE            � Data �  01/08/03   ���
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

Local nOrdem

dbSelectArea(cString)
dbSetOrder(1)
nLin := 80
//���������������������������������������������������������������������Ŀ
//� SETREGUA -> Indica quantos registros serao processados para a regua �
//�����������������������������������������������������������������������

SetRegua(RecCount())

_dDtEntr    := mv_par01
_dDtEntr2   := mv_par02
_nTotFatb   := 0
_nTotPesbal := 0
_nTotFret   := 0
_nTotKM     := 0


//Cabec1  := "Periodo de : " + substr(_dDataEntr,7,2)+ "/" + substr(_dDataEntr,5,2)+ "/" + substr(_dDataEntr,1,4)+ SPACE(5) +  "Ate : " + substr(_dDataEntr2,7,2)+ "/" + substr(_dDataEntr2,5,2)+ "/" + substr(_dDataEntr2,1,4)
Cabec1  := space(90)+ "Periodo de : " + DTOC(_dDtEntr) + " Ate : " + DTOC(_dDtEntr2)

Cabec3  := "|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|"
Cabec4  := "|    VEICULO     |                       |                 DISTRIBUICAO                   |                 PESAGEM                   |        SAIDA         |       RETORNO        |  CONTR.KM  |         |             |"
Cabec5  := "|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|"
Cabec6  := "|  PLACA  |  TP  |      FORNECEDOR       | ROT |No.ENTR.|ENTR.DEV.|       DESTINO         | EXPEDICAO | BALANCA |   DIF.   |  % DIF.  |   HORA   |    KM     |   HORA   |    KM     |  DIF. KM   |  GUIA   |  VL. FRETE  |"
Cabec7  := "|------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|"
//          0         1         2         3         4         5         6         7         8         9         10        11        12        13        14        15        16        17        18        19        20        21        22        23
//          01234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012

//���������������������������������������������������������������������Ŀ
//� Posicionamento do primeiro registro e loop principal. Pode-se criar �
//� a logica da seguinte maneira: Posiciona-se na filial corrente e pro �
//� cessa enquanto a filial do registro for a filial corrente. Por exem �
//� plo, substitua o dbGoTop() e o While !EOF() abaixo pela sintaxe:    �
//�                                                                     �
//� dbSeek(xFilial())                                                   �
//� While !EOF() .And. xFilial() == A1_FILIAL                           �
//�����������������������������������������������������������������������


dbSelectArea("SZK") // Arquivo de Frete
dbSetOrder(10)  // Indice (10) DTOS(ZK_DTFECH)+ZK_ROTEIRO
Dbgotop()
dbSeek(xFilial("SZK")+ dtos(_dDtEntr))
DO While !EOF () .and. (ZK_DTFECH >= _dDtEntr .and. ZK_DTFECH <= _dDtEntr2 ) .AND. (ZK_TIPFRT $ ALLTRIM(MV_PAR04))
	If lAbortPrint
		@nLin,00 PSAY "*** CANCELADO PELO OPERADOR ***"
		Exit
	Endif
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
		@nLin,000 PSAY CABEC7
		nLin := nLin + 1
		
	Endif  
	
//����������������������������������������������������������Ŀ
//�Se o tipo de frete estiver dentro do parametro imprimo ele�
//������������������������������������������������������������
	If ZK_TPFRETE $ mv_par03//'A7' 
		
		@nLin,000 PSAY "|"
		@nLin,002 PSAY ZK_PLACAPG
		@nLin,010 PSAY "|"
		@nLin,013 PSAY ZK_TPFRETE
		@nLin,017 PSAY "|"
		@nLin,019 PSAY SUBSTR (ZK_NOMFOR,1,20)
		@nLin,041 PSAY "|"
		@nLin,043 PSAY ZK_ROTEIRO
		@nLin,047 PSAY "|"
		@nLin,050 PSAY ZK_ENTREGA
		@nLin,056 PSAY "|"
		@nLin,060 PSAY ZK_ENTRDEV
		@nLin,066 PSAY "|"
		@nLin,068 PSAY SUBSTR(ZK_DESTINO,1,20)
		@nLin,090 PSAY "|"
		@nLin,092 PSAY ZK_PESFATB PICTURE '@E 999,999'
		@nLin,102 PSAY "|"
		@nLin,104 PSAY ZK_PESOBAL PICTURE '@E 999,999'
		@nLin,112 PSAY "|"
		@nLin,113 PSAY ( ZK_PESOBAL-ZK_PESFATB ) PICTURE '@E 999,999.99'
		@nLin,123 PSAY "|"
		If ZK_PESFATB > 0 .AND.  ZK_PESOBAL > 0
			@nLin,124 PSAY ((ZK_PESOBAL-ZK_PESFATB) /ZK_PESFATB) * 100 PICTURE '@E 999.999'
		Else
			@nLin,124 PSAY 0 PICTURE '@E 999,999'
		Endif
		@nLin,134 PSAY "|"
		@nLin,136 PSAY ZK_HORASAI
		@nLin,145 PSAY "|"
		@nLin,147 PSAY ZK_KMSAI PICTURE '@E 999,999'
		@nLin,157 PSAY "|"
		@nLin,159 PSAY ZK_HORAENT
		@nLin,168 PSAY "|"
		@nLin,170 PSAY ZK_KMENT PICTURE '@E 999,999'
		@nLin,180 PSAY "|"
		@nLin,184 PSAY ( ZK_KMENT - ZK_KMSAI ) PICTURE '@E 999,999'
		@nLin,193 PSAY "|"
		@nLin,195 PSAY ZK_GUIA
		@nLin,203 PSAY "|"
		@nLin,205 PSAY ZK_VALFRET PICTURE '@E 999,999.99'
		@nLin,217 PSAY "|"
		
		_nTotFatb   += ZK_PESFATB
		_nTotPesbal += ZK_PESOBAL
		_nTotKM     += ( ZK_KMENT - ZK_KMSAI )
		_nTotFret   += ZK_VALFRET
		
		nLin := nLin + 1
	Endif
	dbSkip()
Enddo

@nLin,000 PSAY "|"
@nLin,001 PSAY REPLICATE ("-",216)
@nLin,217 PSAY "|"
nLin := nLin + 1
@nLin,000 PSAY "|"
@nLin,002 PSAY "TOTAL =>"
@nLin,092 PSAY _nTotFatb PICTURE '@E 999,999'
@nLin,104 PSAY _nTotPesbal PICTURE '@E 999,999'
@nLin,184 PSAY _nTotKM PICTURE '@E 999,999'
@nLin,205 PSAY _nTotFret PICTURE '@E 999,999.99'
@nLin,217 PSAY "|"
nLin := nLin + 1
@nLin,000 PSAY "|"
@nLin,001 PSAY REPLICATE ("-",216)
@nLin,217 PSAY "|"


dbCloseArea("SZK")
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

Return
