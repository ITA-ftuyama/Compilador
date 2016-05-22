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

#define     IDGLOB      1
#define     IDFUNC      2
#define     IDVAR       3

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

/*  Definicao de mensagens de incompatibilidade */

#define INCOMP_SE       "Expressao no Se deveria ser logico"
#define INCOMP_ENQUANTO "Expressao no Enquanto deveria ser logico"
#define INCOMP_REPETIR  "Expressao no Repetir deveria ser logico"
#define INCOMP_ATRIB    "Lado direito de comando de atribuicao improprio"
#define INCOMP_PARA     "Expressao no Para deveria ser logico"
#define INCOMP_OR       "Operando improprio para OR"
#define INCOMP_AND      "Operando improprio para AND"
#define INCOMP_NOT      "Operando improprio para NOT"
#define INCOMP_OPREL    "Operando improprio para operador relacional"
#define INCOMP_OPARIT   "Operando improprio para operador aritmetico"
#define INCOMP_OPREST   "Operando improprio para operador resto"
#define INCOMP_OPNEG    "Operando improprio para menos unario"
#define INCOMP_NUMSUB   "Numero de subscritos incompativel com declaracao"
#define INCOMP_TIPOSUB  "Tipo inadequado para subscrito"


/*  Strings para nomes dos tipos de identificadores  */

char *nometipid[4] = {" ", "IDGLOB", "IDFUNC", "IDVAR"};

/*  Strings para nomes dos tipos de variaveis  */

char *nometipvar[5] = {
    "NOTVAR", "INTEGER", "LOGIC", "FLOAT", "CHAR"
};

/*    Declaracoes para a tabela de simbolos     */

typedef struct celsimb celsimb;
typedef celsimb *simbolo;
typedef struct elemlistsimb elemlistsimb;
typedef elemlistsimb *listsimb;
struct elemlistsimb {
    simbolo simb, prox;
};
struct celsimb {
    char *cadeia;
    int tid, tvar, tparam;
    int  nparam, ndims, dims[MAXDIMS+1];
    char inic, ref, array, param;
    listsimb listvardecl, listparam, listfunc; 
    simbolo escopo, prox;
};

/*  
    Variaveis globais para a tabela de simbolos e analise semantica
*/

simbolo tabsimb[NCLASSHASH];
simbolo simb, escopo, aux;
listsimb pontvardecl, pontfunc, pontparam;
int tipocorrente;
int tab = 0;
char declparam;

/*
    Prototipos das funcoes para a tabela de simbolos
        e analise semantica
 */

/*  Tabulacao para prettyPrinter  */

void Tabular();

/*  Manipulacao da Tabela de Simbolos  */

int hash (char *);
void InicTabSimb (void);
void ImprimeTabSimb (void);
void InsereListSimb (simbolo, listsimb *);
simbolo InsereSimb (char *, int, int, simbolo);
simbolo ProcuraSimb (char *);

/*  Mensagens de erros semanticos  */

void Esperado (char *);
void NaoEsperado (char *);
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

Programa    :   {InicTabSimb();}
                DeclGlobs   Funcoes 
                {VerificaInicRef (); ImprimeTabSimb ();}
            ;
DeclGlobs   :
            |   GLOBAIS  DPONTS  {
                    printf("globais:\n");
                    tab = 1; declparam = FALSE;
                    escopo = simb = 
                        InsereSimb("Global", IDGLOB, NOTVAR, NULL);
                    pontvardecl = simb->listvardecl;
                    pontfunc = simb->listfunc;
                }
                ListDecl
            ;
ListDecl    :   Declaracao
            |   ListDecl  Declaracao
            ;
Declaracao  :   {tabular();}
                Tipo  ListElemDecl 
                PVIRG   {printf(";\n");}
            ;
Tipo        :   INTEIRO {printf("int ");    tipocorrente = INTEGER;}
            |   REAL    {printf("real ");   tipocorrente = FLOAT;  }  
            |   CARAC   {printf("carac ");  tipocorrente = CHAR;   } 
            |   LOGICO  {printf("logico "); tipocorrente = LOGIC;  } 
            |   VAZIO   {printf("vazio ");  tipocorrente = VAZIO;  } 
            ;
ListElemDecl:   ElemDecl
            |   ListElemDecl {printf(", ");} VIRG ElemDecl
            ;
ElemDecl    :   ID {
                    printf ("%s", $1);
                    if  (SimbDeclarado($1) == TRUE) {
                        DeclaracaoRepetida ($1);
                    }
                    else {
                        simb =  InsereSimb ($1, IDVAR, tipocorrente, escopo);
                    }
                } ListDims
            ;
ListDims    :
            |   ListDims  Dimensao {simb->array = TRUE;}
            ;
Dimensao    :   ABCOL  CTINT FCOL {
                    printf("[%d]", $2);
                     if ($2 <= 0) Esperado ("Valor inteiro positivo");
                    simb->ndims++; simb->dims[simb->ndims] = $2;
                }
            ;
Funcoes     :   FUNCOES  DPONTS  {tab = 1; printf("\nfuncoes:\n");} 
                ListFunc
            ;
ListFunc    :   Funcao
            |   ListFunc  Funcao
            ;
Funcao      :   Cabecalho ABCHAVE
                {printf (" {\n"); tab++;}
                DeclLocs Cmds FCHAVE {
                    tab--; tabular (); printf ("}\n");
                    escopo = escopo->escopo; 
                }
            ;
Cabecalho   :   PRINCIPAL   {printf("principal");}
            |   Tipo  ID {declparam = TRUE;} ABPAR {
                    printf("%s (", $2);
                    escopo = simb = 
                        InsereSimb ($2, IDFUNC, tipocorrente, escopo);
                    pontvardecl = simb->listvardecl;
                    pontparam = simb->listparam;
                } 
                Params {declparam = FALSE;} FPAR  
                {printf(")");}
            ;
Params      :
            |   ListParam
            ;
ListParam   :   Parametro
            |   ListParam 
                VIRG {printf(", ");} Parametro
            ;
Parametro   :   Tipo  ID {
                    printf ("%s", $2);
                    if  (SimbDeclarado($2) == TRUE) {
                        DeclaracaoRepetida ($2);
                    }
                    else {
                        simb =  InsereSimb ($2, IDVAR, tipocorrente, escopo);
                    }
                }
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
                FPAR {printf (") "); if ($4 != LOGIC)
                        Incompatibilidade (INCOMP_SE);
                    } CmdInside CmdSenao
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
CmdEnquanto :   ENQUANTO  ABPAR {printf("enquanto (");} Expressao
                FPAR {printf (") "); if ($4 != LOGIC)
                        Incompatibilidade (INCOMP_ENQUANTO); 
                    } Comando
            ;
CmdRepetir  :   REPETIR  {printf("repetir ");}
                CmdInside {tabular(); printf("enquanto (");}
                ENQUANTO   ABPAR  
                Expressao FPAR PVIRG  {
                    printf(");\n"); 
                    if ($7 != LOGIC)
                        Incompatibilidade (INCOMP_REPETIR); 
                }
            ;
CmdPara     :   PARA  ABPAR {printf("para (");}
                Variavel    {if ($4 != NULL) $4->inic = $4->ref = TRUE;}
                ATRIB       {printf(" := ");} 
                Expressao PVIRG {
                    printf ("; ");
                    if ($4 != NULL)
                        if ((($4->tvar == INTEGER || $4->tvar == CHAR) &&
                            ($8 == FLOAT || $8 == LOGIC)) ||
                            ($4->tvar == FLOAT && $8 == LOGIC) ||
                            ($4->tvar == LOGIC && $8 != LOGIC))
                            Incompatibilidade (INCOMP_ATRIB);
                } 
                Expressao PVIRG {
                    printf("; "); 
                    if ($11 != LOGIC) Incompatibilidade (INCOMP_PARA); 
                }
                Variavel        {if ($14 != NULL) $14->ref = TRUE;}
                ATRIB           {printf(" := ");} 
                Expressao FPAR  {printf (") ");}
                Comando
            ;
CmdLer      :   LER  ABPAR  {printf("ler (");}
                ListLeit    {printf(");\n");}
                FPAR  PVIRG 
            ;
ListLeit    :   Variavel {if ($1 != NULL) $1->inic = $1->ref = TRUE;}
            |   ListLeit 
                VIRG   {printf(", ");} Variavel
            ;
CmdEscrever :   ESCREVER  ABPAR  {printf("escrever (");}
                ListEscr  FPAR  PVIRG  {printf(");\n");}
            ;
ListEscr    :   ElemEscr
            |   ListEscr VIRG {printf(", ");} ElemEscr
            ;
ElemEscr    :   CADEIA      {printf("%s", $1);}
            |   Expressao
            ;
ChamadaProc :   CHAMAR  ID ABPAR
                {printf("chamar %s(", $2);}
                Argumentos FPAR PVIRG {printf(");\n");}
            ;
Argumentos  :
            |   ListExpr
            ;
ListExpr    :   Expressao
            |   ListExpr VIRG   {printf(", ");} Expressao
            ;
CmdRetornar :   RETORNAR  PVIRG {printf("retornar;\n");}
            |   RETORNAR        {printf("retornar ");}
                Expressao PVIRG {printf(";\n");}
            ;
CmdAtrib    :   Variavel {if ($1 != NULL) $1->inic = $1->ref = TRUE;}
                ATRIB    {printf (" := ");}
                Expressao PVIRG {
                    printf (";\n");
                    if ($1 != NULL)
                        if ((($1->tvar == INTEGER || $1->tvar == CHAR) &&
                            ($5 == FLOAT || $5 == LOGIC)) ||
                            ($1->tvar == FLOAT && $5 == LOGIC) ||
                            ($1->tvar == LOGIC && $5 != LOGIC))
                            Incompatibilidade (INCOMP_ATRIB);
                }
            ;
Expressao   :   ExprAux1
            |   Expressao  OR {printf(" || ");} ExprAux1 {
                    if ($1 != LOGIC || $4 != LOGIC)
                        Incompatibilidade (INCOMP_OR);
                    $$ = LOGIC;
                }
            ;
ExprAux1    :   ExprAux2
            |   ExprAux1  AND {printf(" && ");} ExprAux2 {
                    if ($1 != LOGIC || $4 != LOGIC)
                        Incompatibilidade (INCOMP_AND);
                    $$ = LOGIC;
                }
            ;
ExprAux2    :   ExprAux3
            |   NOT {printf ("!");}  ExprAux3  {
                    if ($3 != LOGIC)
                        Incompatibilidade (INCOMP_NOT);
                    $$ = LOGIC;
                }
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
            }   ExprAux4 {
                switch ($2) {
                    case LT: case LE: case GT: case GE:
                        if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR 
                         || $4 != INTEGER && $4 != FLOAT && $4 != CHAR)
                            Incompatibilidade (INCOMP_OPREL);
                        break;
                    case EQ: case NE:
                        if (($1 == LOGIC || $4 == LOGIC) && $1 != $4)
                            Incompatibilidade (INCOMP_OPREL);
                        break;
                    }
                    $$ = LOGIC;
                }
            ;
ExprAux4    :   Termo
            |   ExprAux4 OPAD 
            {
                switch ($2) {
                    case MAIS  : printf (" + "); break;
                    case MENOS : printf (" - "); break;
                }
            } Termo  {
                if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR || $4 != INTEGER && $4!=FLOAT && $4!=CHAR)
                    Incompatibilidade (INCOMP_OPARIT);
                if ($1 == FLOAT || $4 == FLOAT) $$ = FLOAT;
                else $$ = INTEGER;
            }
            ;
Termo       :   Fator
            |   Termo  OPMULT
            {
                switch ($2) {
                    case MULT :  printf (" * "); break;
                    case DIV  :  printf (" / "); break;
                    case RESTO:  printf (" % "); break;
                }
            }  Fator {
                switch ($2) {
                    case MULT: case DIV:
                        if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR
                         || $4 != INTEGER && $4 != FLOAT && $4 != CHAR)
                            Incompatibilidade (INCOMP_OPARIT);
                        if ($1 == FLOAT || $4 == FLOAT) $$ = FLOAT;
                        else $$ = INTEGER;
                    break;
                    case RESTO:
                        if ($1 != INTEGER && $1 != CHAR
                        ||  $4 != INTEGER && $4 != CHAR)
                            Incompatibilidade (INCOMP_OPREST);
                        $$ = INTEGER;
                    break;
                }
            }
            ;
Fator       :   Variavel {
                    if  ($1 != NULL)  {
                        $1->ref  =  TRUE;
                        $$ = $1->tvar;

                    }
                }
            |   CTINT       {printf ("%d", $1); $$ = INTEGER; }
            |   CTREAL      {printf ("%g", $1); $$ = FLOAT;   }
            |   CTCARAC     {printf ("\'%c\'", $1); $$ = CHAR;}
            |   CADEIA      {printf ("%s", $1); $$ = CADEIA;  }
            |   VERDADE     {printf ("true");   $$ = LOGIC;   }
            |   FALSO       {printf ("false");  $$ = LOGIC;   }
            |   NEG         {printf ("~");}  Fator  
            {
                if ($3 != INTEGER && $3 != FLOAT && $3 != CHAR)
                    Incompatibilidade  (INCOMP_OPNEG);
                if ($3 == FLOAT) $$ = FLOAT;
                else $$ = INTEGER;
            }
            |   ABPAR           {printf("(");}
                Expressao  FPAR {printf (")"); $$ = $3;}
            |   ChamadaFunc
            ;
Variavel    :   ID {
                    printf ("%s", $1);
                    simb = ProcuraSimb ($1);
                    if (simb == NULL)   NaoDeclarado ($1);
                    else if (simb->tid != IDVAR)  TipoInadequado ($1);
                    $<simb>$ = simb;
                } ListSubscr  {
                    $$ = $<simb>2;
                    if ($$ != NULL) {
                        if ($$->array == FALSE && $3 > 0)
                            NaoEsperado ("Subscrito\(s)");
                        else if ($$->array == TRUE && $3 == 0)
                            Esperado ("Subscrito\(s)");
                        else if ($$->ndims != $3)
                            Incompatibilidade (INCOMP_NUMSUB);
                    }
                }
            ;
ListSubscr  :   {$$ = 0;}
            |   ListSubscr  Subscrito {$$ = $1 + 1;}
            ;
Subscrito   :   ABCOL   {printf("[");}
                ExprAux4
                FCOL    {
                    printf("]");
                    if ($3 != INTEGER && $3 != CHAR)
                        Incompatibilidade (INCOMP_TIPOSUB);
                }
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

/*  InicTabSimb: Inicializa a tabela de simbolos   */

void InicTabSimb () {
    int i;
    for (i = 0; i < NCLASSHASH; i++)
        tabsimb[i] = NULL;
}

/*
    SimbDeclarado(cadeia):
    Verifica se um dado símbolo possui declaração repetida;
    Isso é, já existe na tabela de símbolos no escopo atual;
    Retorna char TRUE ou FALSE;
 */

char SimbDeclarado (char *cadeia) {
    simbolo s = ProcuraSimb(cadeia);
    if (s != NULL && s->escopo == escopo) {
        return TRUE;
    }
    else return FALSE;
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
    InsereListSimb (cadeia, listasimbolos): Insere cadeia na lista de
    simbolos, com tid como tipo de identificador e com tvar como
    tipo de variavel; Retorna um ponteiro para a celula inserida
 */

void InsereListSimb (simbolo simb, listsimb *list) {

}

/*
    InsereSimb (cadeia, tid, tvar): Insere cadeia na tabela de
    simbolos, com tid como tipo de identificador e com tvar como
    tipo de variavel; Retorna um ponteiro para a celula inserida
 */

simbolo InsereSimb (char *cadeia, int tid, int tvar, simbolo escopo) {
    int i; simbolo aux, s;
    i = hash (cadeia); aux = tabsimb[i];
    s = tabsimb[i] = (simbolo) malloc (sizeof (celsimb));
    s->cadeia = (char*) malloc ((strlen(cadeia)+1) * sizeof(char));
    strcpy (s->cadeia, cadeia);
    s->tid = tid;       s->tvar = tvar;     
    s->prox = aux;      s->escopo = escopo;
     
    if (tid == IDVAR) {
        if (declparam) {
            s->inic = s->ref = s->param = TRUE;
            s->array = FALSE;   s->ndims = 0;
            if (s->tid == IDVAR)
                InsereListSimb (s, &pontparam);
            s->escopo->nparam++;
        }
        else {
            s->inic = s->ref = s->param = FALSE;
            s->array = FALSE;   s->ndims = 0;
            if (s->tid == IDVAR)
                InsereListSimb (s, &pontvardecl);
            s->tvar = tvar;
            s->tparam = tvar;   
        }     
    }
    if (tid == IDGLOB || tid == IDFUNC) {
        s->listvardecl = (elemlistsimb *) 
            malloc  (sizeof (elemlistsimb));
        s->listvardecl->prox = NULL;
    }
    if (tid == IDGLOB) {
        s->listfunc = (elemlistsimb *) 
            malloc  (sizeof (elemlistsimb));
        s->listfunc->prox = NULL;
    }
    if (tid == IDFUNC) {
        s->listparam = (elemlistsimb *) 
            malloc  (sizeof (elemlistsimb));
        s->listparam->prox = NULL;
        s->nparam = 0;
        InsereListSimb (s, &pontfunc);
    }

    return s;
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
                printf ("  (%-8s, %s", s->cadeia,  nometipid[s->tid]);
                if (s->tid == IDVAR) {
                    printf (", %-7s, %d, %d",
                        nometipvar[s->tvar], s->inic, s->ref);
                    if (s->array == TRUE) 
                    { 
                        int j;
                        printf (", EH ARRAY\n\tndims = %d, dimensoes:", s->ndims);
                        for (j = 1; j <= s->ndims; j++)
                            printf ("  %d", s->dims[j]);
                    }
                }
                if (s->escopo != NULL)
                    printf(", escopo: %s", s->escopo->cadeia);
                else printf(", escopo: NULL");
                printf(")\n");
            }
        }
}

/*  Mensagens de erros semanticos  */

void Esperado (char *s) {
    printf ("\n\n***** Esperado: %s *****\n\n", s);
}

void NaoEsperado (char *s) {
    printf ("\n\n***** Nao Esperado: %s *****\n\n", s);
}

void DeclaracaoRepetida (char *s) {
    printf ("\n\n***** Declaracao Repetida: %s *****\n\n", s);
}

void NaoDeclarado (char *s) {
    printf ("\n\n***** Identificador Nao Declarado: %s *****\n\n", s);
}

void TipoInadequado (char *s) {
    printf("\n\n***** Identificador de Tipo Inadequado: %s *****\n\n", s);
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


