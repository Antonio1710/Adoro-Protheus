/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������Ŀ��
���Funcao    � CNABKOB� Autor �Ana Helena              � Data �14/02/2012 ���
�������������������������������������������������������������������������Ĵ��
���Descricao � Programa chamado pelo CNAB KOBOLD.REM. Posicao 111 a 120   ���
���          � Tem a funcao de gerar o numero do titulo de acordo com a   ���
���          | solicitacao do banco KOBOLD: NUMERO DO TITULO / PARCELA    ���
�������������������������������������������������������������������������Ĵ��
���Uso       � Especifico Ad'oro Alimenticia                              ���
�������������������������������������������������������������������������Ĵ��
���Observacao�                                                            ���
��������������������������������������������������������������������������ٱ�
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/  

User  Function CNABKOB()       

Local cRetCKO := ""

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'')
      
cRetCKO := Alltrim(Str(Val(SE1->E1_NUM)))

If Alltrim(SE1->E1_PARCELA) <> ""
	cRetCKO += "/"	
Endif
            
cRetCKO += Alltrim(SE1->E1_PARCELA)

Return cRetCKO