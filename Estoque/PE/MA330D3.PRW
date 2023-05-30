#include "rwmake.ch"        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01

User Function MA330D3()        // incluido pelo assistente de conversao do AP5 IDE em 14/05/01  

//���������������������������������������������������������������������Ŀ
//� Declaracao de variaveis utilizadas no programa atraves da funcao    �
//� SetPrvt, que criara somente as variaveis definidas pelo usuario,    �
//� identificando as variaveis publicas do sistema utilizadas no codigo �
//� Incluido pelo assistente de conversao do AP5 IDE                    �
//�����������������������������������������������������������������������

SetPrvt("COS001,CORDEM,")

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Programa  � MA330D3  � Autor � NG Informatica        � Data � 04712/00 ���
�������������������������������������������������������������������������Ĵ��
���Descri��o � Ponto de Entrada recalculo custo medio                     ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Generico                                                   ���
���          �                                                            ���
���          � Objetivo: atualizar o custo do movimento da O.S.           ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/


If !Empty(SD3->D3_OP) .and. SubStr(SD3->D3_CF,1,2) == "RE"
	
	cOS001 := SUBSTR(SD3->D3_OP,7,5)
	cORDEM := SUBSTR(SD3->D3_OP,1,6)
	
	If cOS001 == "OS001"
		
		DbSelectArea("STL")
		DbSetorder(7)
		IF DbSeek(xFilial("STL")+SD3->D3_NUMSEQ)
			Reclock("STL",.F.)
			STL->TL_CUSTO := SD3->D3_CUSTO1
			MSUNLOCK("STL")
		Endif
	Endif
	
Endif
DbSelectArea("SD3")

Return(.T.)