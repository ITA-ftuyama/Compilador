%{
/* Inclusao de arquivos da biblioteca de C */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Definicao dos atributos dos atomos operadores */

#define     LT      1
#define     LE      2
#define     GT      3
#define     GE      4
#define     EQ      5
#define     NE      6
#define     MAIS    7
#define     MENOS   8
#define     MULT    9
#define     DIV     10
#define     RESTO   11

/*   Definicao dos tipos de identificadores   */

#define     IDPROG      1
#define     IDVAR       2

/*  Definicao dos tipos de variaveis   */

#define     NOTVAR      0
#define     INTEGER     1
#define     LOGIC       2
#define     FLOAT       3
#define     CHAR        4

/*   Definicao de outras constantes   */

#define NCLASSHASH  23
#define TRUE        1
#define FALSE       0
#define MAXDIMS     10 

/*  Strings para nomes dos tipos de identificadores  */

char *nometipid[3] = {" ", "IDPROG", "IDVAR"};

/*  Strings para nomes dos tipos de variaveis  */

char *nometipvar[5] = {"NOTVAR",
    "INTEGER", "LOGIC", "FLOAT", "CHAR"
};

/*    Declaracoes para a tabela de simbolos     */

typedef struct celsimb celsimb;
typedef celsimb *simbolo;
struct celsimb {
    char *cadeia;
    int tid, tvar;
    int  ndims, dims[MAXDIMS+1];
    char inic, ref, array;
    simbolo prox;
};

/*  Variaveis globais para a tabela de simbolos e analise semantica
 */

simbolo tabsimb[NCLASSHASH];
simbolo simb;
int tipocorrente;
int tab = 0;

/*
    Prototipos das funcoes para a tabela de simbolos
        e analise semantica
 */

void Tabular();
void Esperado (char *);
void NaoEsperado (char *);
void InicTabSimb (void);
void ImprimeTabSimb (void);
simbolo InsereSimb (char *, int, int);
int hash (char *);
simbolo ProcuraSimb (char *);
void DeclaracaoRepetida (char *);
void TipoInadequado (char *);
void NaoDeclarado (char *);
void Incompatibilidade (char *);
void VerificaInicRef (void);
%}

/* Definicao do tipo de yylval e dos atributos dos nao terminais */

%union {
    char cadeia[50];
    int atr, valint;
    float valreal;
    char carac;
    simbolo simb;
    int tipoexpr, nsubscr;
}

/* Declaracao dos atributos dos tokens e dos nao-terminais */

%type   <simb>      Variavel
%type   <tipoexpr>  Expressao   ExprAux1    ExprAux2    
                Termo   Fator   ExprAux3    ExprAux4
%type   <nsubscr>   ListSubscr

%token  <cadeia>    ID
%token  <carac>     CTCARAC
%token  <valint>    CTINT
%token  <valreal>   CTREAL
%token  <cadeia>    CADEIA

%token  <atr>       OPAD
%token  <atr>       OPREL
%token  <atr>       OPMULT
%token  <atr>       OPNEG

%token  OR
%token  AND
%token  NOT
%token  NEG

%token  SE
%token  SENAO
%token  ENQUANTO
%token  PARA
%token  RETORNAR
%token  REPETIR
%token  VERDADE
%token  FALSO

%token  GLOBAIS
%token  LOCAIS
%token  COMANDOS
%token  FUNCOES
%token  PRINCIPAL

%token  LER
%token  ESCREVER
%token  CHAMAR

%token	INTEIRO
%token	REAL
%token	CARAC
%token	LOGICO
%token	VAZIO

%token  ABPAR
%token  FPAR
%token  ABCOL
%token  FCOL
%token  ABCHAVE
%token  FCHAVE
%token  PVIRG
%token  PONTO
%token  DPONTS
%token  VIRG
%token  ATRIB

%token	<carac> INVAL

%%

/* Producoes da gramatica:

    Os terminais sao escritos e, depois de alguns,
    para alguma estetica, ha mudanca de linha       
*/

Programa    :   
//{InicTabSimb();}
                DeclGlobs   Funcoes 
                 //{VerificaInicRef (); ImprimeTabSimb ();}
            ;
DeclGlobs   :
            |   GLOBAIS  DPONTS  {tab = 1; printf("globais:\n");}
                ListDecl
            ;
ListDecl    :   Declaracao
            |   ListDecl  Declaracao
            ;
Declaracao  :   {tabular();}
                Tipo  ListElemDecl 
                PVIRG   {printf(";\n");}
            ;
Tipo        :   INTEIRO {printf("int ");    tipocorrente = INTEGER; }
            |   REAL    {printf("real ");   tipocorrente = FLOAT;   }  
            |   CARAC   {printf("carac ");  tipocorrente = CHAR;    } 
            |   LOGICO  {printf("logico "); tipocorrente = LOGICO;  } 
            |   VAZIO   {printf("vazio ");  tipocorrente = VAZIO;   } 
            ;
ListElemDecl:   ElemDecl
            |   ListElemDecl {printf(", ");} VIRG ElemDecl
            ;
ElemDecl    :   ID
                {printf ("%s", $1);}
                ListDims
            ;
ListDims    :
            |   ListDims  Dimensao
            ;
Dimensao    :   ABCOL  CTINT FCOL
                {printf("[%d]", $2);}
            ;
Funcoes     :   FUNCOES  DPONTS  {tab = 1; printf("\nfuncoes:\n");} 
                ListFunc
            ;
ListFunc    :   Funcao
            |   ListFunc  Funcao
            ;
Funcao      :   Cabecalho ABCHAVE
                {printf (" {\n"); tab++;}
                DeclLocs Cmds FCHAVE
                {tab--; tabular (); printf ("}\n");}
            ;
Cabecalho   :   PRINCIPAL   {printf("principal");}
            |   Tipo  ID {printf("%s (", $2);} ABPAR
                Params FPAR {printf(")");}
            ;
Params      :
            |   ListParam
            ;
ListParam   :   Parametro
            |   ListParam 
                VIRG {printf(", ");} Parametro
            ;
Parametro   :   Tipo  ID {printf ("%s", $2);}
            ;
DeclLocs    :
            |   LOCAIS  DPONTS {tab = 1; printf("locais:\n");}
                ListDecl
            ;
Cmds        :   COMANDOS  DPONTS  {tab = 1; printf("comandos:\n");}
                ListCmds
            ;
ListCmds    :   {tabular();} Comando
            |   ListCmds  {tabular();}  Comando
            ;
Comando     :   CmdComposto
            |   CmdSe
            |   CmdEnquanto
            |   CmdRepetir
            |   CmdPara
            |   CmdLer
            |   CmdEscrever
            |   CmdAtrib
            |   ChamadaProc
            |   CmdRetornar
            |   PVIRG           {printf(";\n");}
            ;
CmdComposto :   
                ABCHAVE {printf ("{\n"); tab++;}  ListCmds FCHAVE
                {tab--; tabular (); printf ("}\n");}
            ;
CmdSe       :   {printf("se (");} 
                SE  ABPAR Expressao 
                FPAR {printf(") ");}
                CmdInside CmdSenao
            ;
CmdInside   :   CmdComposto
            |   {printf("\n"); tab++; tabular();}
                Comando
                {tab--;}
            ;
CmdSenao    :
            |   SENAO {tabular(); printf("senao ");}
                Comando
            ;
CmdEnquanto :   {printf("enquanto (");}
                ENQUANTO  ABPAR Expressao
                {printf(") ");}
                FPAR Comando
            ;
CmdRepetir  :   REPETIR  {printf("repetir ");}
                CmdInside {tabular(); printf("enquanto (");}
                ENQUANTO   ABPAR  
                Expressao 
                FPAR PVIRG  {printf(");\n");}
            ;
CmdPara     :   PARA  ABPAR  {printf("para (");}
                Variavel
                ATRIB {printf(" := ");} Expressao
                PVIRG {printf("; ");  } Expressao
                PVIRG {printf("; ");  } Variavel
                ATRIB {printf(" := ");} Expressao  {printf(") ");  } 
                FPAR Comando
            ;
CmdLer      :   LER  ABPAR  {printf("ler (");}
                ListLeit    {printf(");\n");}
                FPAR  PVIRG 
            ;
ListLeit    :   Variavel
            |   ListLeit 
                VIRG   {printf(", ");} Variavel
            ;
CmdEscrever :   ESCREVER  ABPAR  {printf("escrever (");}
                ListEscr    {printf(");\n");}
                FPAR  PVIRG 
            ;
ListEscr    :   ElemEscr
            |   ListEscr {printf(", ");}
                VIRG  
                ElemEscr
            ;
ElemEscr    :   CADEIA      {printf("%s", $1);}
            |   Expressao
            ;
ChamadaProc :   CHAMAR  ID ABPAR
                {printf("chamar %s(", $2);}
                Argumentos {printf(");\n");}
                FPAR  PVIRG 
            ;
Argumentos  :
            |   ListExpr
            ;
ListExpr    :   Expressao
            |   ListExpr {printf(", ");}
                VIRG   Expressao
            ;
CmdRetornar :   RETORNAR  PVIRG  {printf("retornar;\n");}
            |   RETORNAR  {printf("retornar ");}
                Expressao
                PVIRG {printf(";\n");}
            ;
CmdAtrib    :   Variavel ATRIB  {printf (" := ");}
                Expressao PVIRG {printf(";\n");}
            ;
Expressao   :   ExprAux1
            |   Expressao  OR
                {printf(" || ");}
                ExprAux1
            ;
ExprAux1    :   ExprAux2
            |   ExprAux1  AND
                {printf(" && ");}
                ExprAux2
            ;
ExprAux2    :   ExprAux3
            |   NOT
                {printf("!");}
                ExprAux3
            ;
ExprAux3    :   ExprAux4
            |   ExprAux4  OPREL
            {
                switch ($2) {
                    case LT  :  printf (" < ");  break;
                    case LE  :  printf (" <= "); break;
                    case GT  :  printf (" > ");  break;
                    case GE  :  printf (" >= "); break;
                    case EQ  :  printf (" = ");  break;
                    case NE  :  printf (" != "); break;
                }
            }   ExprAux4
            ;
ExprAux4    :   Termo
            |   ExprAux4 OPAD
            {
                switch ($2) {
                    case MAIS  : printf (" + "); break;
                    case MENOS : printf (" - "); break;
                }
            }   Termo
            ;
Termo       :   Fator
            |   Termo  OPMULT
            {
                switch ($2) {
                    case MULT :  printf (" * "); break;
                    case DIV  :  printf (" / "); break;
                    case RESTO:  printf (" % "); break;
                }
            }   Fator
            ;
Fator       :   Variavel
            |   CTINT           {printf ("%d", $1);}
            |   CTREAL          {printf ("%g", $1);}
            |   CTCARAC         {printf ("\'%c\'", $1);}
            |   CADEIA          {printf ("%s", $1);}
            |   VERDADE         {printf ("true");}
            |   FALSO           {printf ("false");}
            |   NEG             {printf ("~");} Fator
            |   ABPAR           {printf("(");}
                Expressao  FPAR {printf (")");}
            |   ChamadaFunc
            ;
Variavel    :   ID {printf ("%s", $1);} ListSubscr
            ;
ListSubscr  :
            |   ListSubscr  Subscrito
            ;
Subscrito   :   ABCOL   {printf("[");}
                ExprAux4
                FCOL    {printf("]");}
            ;
ChamadaFunc :   ID ABPAR{printf ("%s (", $1);}
                Argumentos {printf(")");}
                FPAR    
            ;
%%
/* Inclusao do analisador lexico  */

#include "lex.yy.c"

/*
     Funções Auxiliares
*/

/*  Tabular: Função que realiza tabulação do PrettyPrinter   */

void tabular () {
    int i;
    for (i = 1; i <= tab; i++)
    printf ("\t");
}

void Esperado (char *s) {
    printf ("\n\n***** Esperado: %s *****\n\n", s);
}

void NaoEsperado (char *s) {
    printf ("\n\n***** Nao Esperado: %s *****\n\n", s);
}

/*  InicTabSimb: Inicializa a tabela de simbolos   */

void InicTabSimb () {
    int i;
    for (i = 0; i < NCLASSHASH; i++)
        tabsimb[i] = NULL;
}

/*
    ProcuraSimb (cadeia): Procura cadeia na tabela de simbolos;
    Caso ela ali esteja, retorna um ponteiro para sua celula;
    Caso contrario, retorna NULL.
 */

simbolo ProcuraSimb (char *cadeia) {
    simbolo s; int i;
    i = hash (cadeia);
    for (s = tabsimb[i]; (s!=NULL) && strcmp(cadeia, s->cadeia);
        s = s->prox);
    return s;
}

/*
    InsereSimb (cadeia, tid, tvar): Insere cadeia na tabela de
    simbolos, com tid como tipo de identificador e com tvar como
    tipo de variavel; Retorna um ponteiro para a celula inserida
 */

simbolo InsereSimb (char *cadeia, int tid, int tvar) {
    int i; simbolo aux, s;
    i = hash (cadeia); aux = tabsimb[i];
    s = tabsimb[i] = (simbolo) malloc (sizeof (celsimb));
    s->cadeia = (char*) malloc ((strlen(cadeia)+1) * sizeof(char));
    strcpy (s->cadeia, cadeia);
    s->tid = tid;       s->tvar = tvar;
    s->inic = FALSE;    s->ref = FALSE;
    s->prox = aux;  return s;
}

/*
    hash (cadeia): funcao que determina e retorna a classe
    de cadeia na tabela de simbolos implementada por hashing
 */

int hash (char *cadeia) {
    int i, h;
    for (h = i = 0; cadeia[i]; i++) {h += cadeia[i];}
    h = h % NCLASSHASH;
    return h;
}

/* ImprimeTabSimb: Imprime todo o conteudo da tabela de simbolos  */

void ImprimeTabSimb () {
    int i; simbolo s;
    printf ("\n\n   TABELA  DE  SIMBOLOS:\n\n");
    for (i = 0; i < NCLASSHASH; i++)
        if (tabsimb[i]) {
            printf ("Classe %d:\n", i);
            for (s = tabsimb[i]; s!=NULL; s = s->prox){
                printf ("  (%s, %s", s->cadeia,  nometipid[s->tid]);
                if (s->tid == IDVAR) {
                    printf (", %s, %d, %d",
                        nometipvar[s->tvar], s->inic, s->ref);
                    if (s->array == TRUE) 
                    { 
                        int j;
                        printf (", EH ARRAY\n\tndims = %d, dimensoes:", s->ndims);
                        for (j = 1; j <= s->ndims; j++)
                            printf ("  %d", s->dims[j]);
                    }
                }
                printf(")\n");
            }
        }
}

/*  Mensagens de erros semanticos  */

void DeclaracaoRepetida (char *s) {
    printf ("\n\n***** Declaracao Repetida: %s *****\n\n", s);
}

void NaoDeclarado (char *s) {
printf ("\n\n***** Identificador Nao Declarado: %s *****\n\n", s);
}

void TipoInadequado (char *s) {
printf
("\n\n***** Identificador de Tipo Inadequado: %s *****\n\n", s);
}

void Incompatibilidade (char *s) {
printf ("\n\n***** Incompatibilidade: %s *****\n\n", s);
}

/*  Verificacao das variaveis inicializadas e referenciadas  */

void VerificaInicRef () {
    int i; simbolo s;

    printf ("\n");
    for (i = 0; i < NCLASSHASH; i++)
        if (tabsimb[i])
            for (s = tabsimb[i]; s!=NULL; s = s->prox)
                if (s->tid == IDVAR) {
                    if (s->inic == FALSE)
                        printf ("%s: Nao Inicializada\n", s->cadeia);
                    if (s->ref == FALSE)
                        printf ("%s: Nao Referenciada\n", s->cadeia);
                }
}


