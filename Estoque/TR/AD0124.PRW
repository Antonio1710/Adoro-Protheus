#INCLUDE "rwmake.ch"

/*/
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
�������������������������������������������������������������������������ͻ��
���Programa  �AD0204     � Autor � WERNER           � Data �   07/04/05   ���
�������������������������������������������������������������������������͹��
���Descricao � Codigo gerado pelo AP6 IDE.                                ���
���          �                                                            ���
�������������������������������������������������������������������������͹��
���Uso       � AP6 IDE                                                    ���
�������������������������������������������������������������������������ͼ��
�����������������������������������������������������������������������������
�����������������������������������������������������������������������������
/*/

User Function AD0124   

U_ADINF009P(SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))) + '.PRW',SUBSTRING(ALLTRIM(PROCNAME()),3,LEN(ALLTRIM(PROCNAME()))),'Solicita��o de Requisi��o')

//���������������������������������������������������������������������Ŀ
//� Declaracao de Variaveis                                             �
//�����������������������������������������������������������������������

Private cCadastro := " Solicita��o de Requisi��o "
//���������������������������������������������������������������������Ŀ
//� Onde: <DESCRICAO> - Permite selecionar a requisi��o pelo numero e   �
//�                     imprimir na impressora de ticket                �
//�����������������������������������������������������������������������

//���������������������������������������������������������������������Ŀ
//� aRotina padrao. Utilizando a declaracao a seguir, a execucao da     �
//� MBROWSE sera identica a da AXCADASTRO:                              �
//�                                                                     �
//� cDelFunc  := ".T."                                                  �
//� aRotina   := { { "Pesquisar"    ,"AxPesqui" , 0, 1},;               �
//�                { "Visualizar"   ,"AxVisual" , 0, 2},;               �
//�                { "Imprimir "      ,"AxAltera" , 0, 4},;               �
//�                                                                     �
//�����������������������������������������������������������������������


//���������������������������������������������������������������������Ŀ
//� Monta um aRotina proprio                                            �
//�����������������������������������������������������������������������

Public  _cAutNome  := cusername
Public  _cNumRequi := space(15)

Private aRotina   := { {"Pesquisar","AxPesqui",0,1} ,;
                       {"Visualizar","AxVisual",0,2},;
                       {"Imprimir", 'ExecBlock("AD0125")',0,3}}
               

Private cDelFunc := ".T." // Validacao para a exclusao. Pode-se utilizar ExecBlock

Private cString := "SCP"

dbSelectArea("SCP")
dbSetOrder(1)



//���������������������������������������������������������������������Ŀ
//� Executa a funcao MBROWSE. Sintaxe:                                  �
//�                                                                     �
//� mBrowse(<nLin1,nCol1,nLin2,nCol2,Alias,aCampos,cCampo)              �
//� Onde: nLin1,...nCol2 - Coordenadas dos cantos aonde o browse sera   �
//�                        exibido. Para seguir o padrao da AXCADASTRO  �
//�                        use sempre 6,1,22,75 (o que nao impede de    �
//�                        criar o browse no lugar desejado da tela).   �
//�                        Obs.: Na versao Windows, o browse sera exibi-�
//�                        do sempre na janela ativa. Caso nenhuma este-�
//�                        ja ativa no momento, o browse sera exibido na�
//�                        janela do proprio SYSTEM.                   �
//� Alias                - Alias do arquivo a ser "Browseado".          �
//� aCampos              - Array multidimensional com os campos a serem �
//�                        exibidos no browse. Se nao informado, os cam-�
//�                        pos serao obtidos do dicionario de dados.    �
//�                        E util para o uso com arquivos de trabalho.  �
//�                        Segue o padrao:                              �
//�                        aCampos := { {<CAMPO>,<DESCRICAO>},;         �
//�                                     {<CAMPO>,<DESCRICAO>},;         �
//�                                     . . .                           �
//�                                     {<CAMPO>,<DESCRICAO>} }         �
//�                        Como por exemplo:                            �
//�                        aCampos := { {"TRB_DATA","Data  "},;         �
//�                                     {"TRB_COD" ,"Codigo"} }         �
//� cCampo               - Nome de um campo (entre aspas) que sera usado�
//�                        como "flag". Se o campo estiver vazio, o re- �
//�                        gistro ficara de uma cor no browse, senao fi-�
//�                        cara de outra cor.                           �
//�����������������������������������������������������������������������

dbSelectArea(cString)

Public  _cAlias := Alias()
Public  _nIndex := IndexOrd()
Public  _nRecno := Recno()

_cNumRequi := SCP->CP_NUM

mBrowse( 6,1,22,75,cString)

Return

