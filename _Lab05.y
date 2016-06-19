%{
/* Inclusao de arquivos da biblioteca de C */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/****************************************************/
/*                                                  */
/*          Análise Sintática - Definições          */
/*                                                  */
/****************************************************/

/* Definicao dos atributos dos atomos operadores */

#define     LT          1
#define     LE          2
#define     GT          3
#define     GE          4
#define     EQ          5
#define     NE          6
#define     MAIS        7
#define     MENOS       8
#define     MULT        9
#define     DIV         10
#define     RESTO       11

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
#define     VOID        5
#define     FUNC        6

/*   Definicao de outras constantes   */

#define NCLASSHASH      23
#define TRUE            1
#define FALSE           0
#define MAXDIMS         10

/****************************************************/
/*                                                  */
/*          Análise Semântica - Exceptions          */
/*                                                  */
/****************************************************/

/*  Mensagens de erros semanticos  */

#define errorDeclIndevida   "Declaracao Indevida"
#define errorDeclRepetida   "Declaracao Repetida"
#define errorEsperado       "Esperado"
#define errorIncomp         "Incompatibilidade"
#define errorNaoDecl        "Nao Declarado"
#define errorNaoEsperado    "Nao Esperado"
#define errorTipoInadeq     "Tipo Inadequado"
#define errorRecursiva      "Recursividade"

/*  Definicao de mensagens de incompatibilidade */

#define INCOMP_AND          "Operando improprio para AND"
#define INCOMP_ENQUANTO     "Expressao no Enquanto deveria ser logico"
#define INCOMP_FUNPRIN1     "Funcao principal deveria ser a ultima"
#define INCOMP_FUNPRIN2     "Funcao principal deveria ser unica"
#define INCOMP_NOT          "Operando improprio para NOT"
#define INCOMP_NUMSUB       "Numero de subscritos incompativel com declaracao"
#define INCOMP_OPARIT       "Operando improprio para operador aritmetico"
#define INCOMP_OPNEG        "Operando improprio para menos unario"
#define INCOMP_OPREL        "Operando improprio para operador relacional"
#define INCOMP_OPREST       "Operando improprio para operador resto"
#define INCOMP_OR           "Operando improprio para OR"
#define INCOMP_PARAEXP1     "Expressao1 no Para deveria ser inteira ou caractere"
#define INCOMP_PARAEXP2     "Expressao2 no Para deveria ser logico"
#define INCOMP_PARAEXP3     "Expressao3 no Para deveria ser inteira ou caractere"
#define INCOMP_PARAVAR1     "Variavel1 no Para deveria ser inteira ou caractere"
#define INCOMP_PARAVAR2     "Variavel2 no Para deveria ser inteira ou caractere"
#define INCOMP_PARAVAR12    "Variavel2 no Para nao corresponde a Variavel1"
#define INCOMP_REPETIR      "Expressao no Repetir deveria ser logico"
#define INCOMP_SE           "Expressao no Se deveria ser logico"
#define INCOMP_TIPOSUB      "Tipo inadequado para subscrito"
#define INCOMP_NARG         "Numero de argumentos diferente do numero de parametros"
#define INCOMP_PARAM        "Incompatibilidade de parametros"

/****************************************************/
/*                                                  */
/*          Código Intermediário - Operandos        */
/*                                                  */
/****************************************************/

/*  Definicao de constantes para os operadores de quadruplas */

#define     OPOR            1
#define     OPAND           2
#define     OPLT            3
#define     OPLE            4
#define     OPGT            5
#define     OPGE            6
#define     OPEQ            7
#define     OPNE            8
#define     OPMAIS          9
#define     OPMENOS         10
#define     OPMULTIP        11
#define     OPDIV           12
#define     OPRESTO         13
#define     OPMENUN         14
#define     OPNOT           15
#define     OPATRIB         16
#define     OPENMOD         17
#define     NOP             18
#define     OPJUMP          19
#define     OPJF            20
#define     PARAM           21
#define     OPREAD          22
#define     OPWRITE         23
#define     OPEXIT          24
#define     OPCALL          25
#define     OPRETURN        26
#define     OPIND           27
#define     OPINDEX         28
#define     OPATRIBPONT     29
#define     OPCONTAPONT     30

/* Definicao de constantes para os tipos de operandos de quadruplas */

#define     IDLEOPND        0
#define     VAROPND         1
#define     INTOPND         2
#define     REALOPND        3
#define     CHAROPND        4
#define     LOGICOPND       5
#define     CADOPND         6
#define     ROTOPND         7
#define     MODOPND         8
#define     FUNCOPND        9
#define     PROCOPND        10

/****************************************************/
/*                                                  */
/*    Análise Sintática & Semântica - Undefines     */
/*                                                  */
/****************************************************/

/*  Strings para nomes dos tipos de identificadores  */

char *nometipid[4] = {" ", "IDGLOB", "IDFUNC", "IDVAR"};

/*  Strings para nomes dos tipos de variaveis  */

char *nometipvar[7] = {
    "null", "int", "logico", "real", "carac", "vazio", "funcao"
};

/*  Strings para nomes dos tipos esperados em atrib */

char *nometipesp[7] = {
    "null", "int ou carac", "logico", "int ou carac ou real", "int ou carac", "vazio", "funcao"
};

/****************************************************/
/*                                                  */
/*          Código Intermediário - Undefines        */
/*                                                  */
/****************************************************/

/* Strings para operadores de quadruplas */

char *nomeoperquad[31] = {"",
    "OR", "AND", "LT", "LE", "GT", "GE", "EQ", "NE", "MAIS",
    "MENOS", "MULT", "DIV", "RESTO", "MENUN", "NOT", "ATRIB",
    "OPENMOD", "NOP", "JUMP", "JF", "PARAM", "READ", "WRITE",
    "EXIT", "CALL", "RET", "IND", "INDEX", "ATRIBPONT", "CONTAPONT"
};

/* Strings para tipos de operandos de quadruplas */

char *nometipoopndquad[11] = {"IDLE","VAR", "INT", "REAL", "CARAC", "LOGIC", "CADEIA",
    "ROTULO", "MODULO", "FUNC", "PROC"
};

/****************************************************/
/*                                                  */
/*   Análise Sintática & Semântica - Declarações    */
/*                                                  */
/****************************************************/

/* Declaracoes para a tabela de simbolos */

typedef char bool;
typedef struct celsimb celsimb;
typedef celsimb *simbolo;
typedef struct elemlistsimb elemlistsimb;
typedef elemlistsimb *listsimb;
typedef struct infolistexpr infolistexpr;
typedef struct exprtipo exprtipo;
typedef exprtipo *pontexprtipo;

/* Declaracoes para a estrutura do codigo intermediario */

typedef union atribopnd atribopnd;
typedef struct operando operando;
typedef struct celquad celquad;
typedef celquad *quadrupla;
typedef struct celmodhead celmodhead;
typedef celmodhead *modhead;

struct elemlistsimb {
    simbolo simb;
    listsimb prox;
};
struct celsimb {
    char *cadeia;
    int tid, tvar, tparam;
    int  nparam, ndims, dims[MAXDIMS+1];
    bool inic, ref, array, param;
    listsimb listvardecl, listparam, listfunc; 
    simbolo escopo, prox;
    modhead fhead;
};
struct infolistexpr {
    pontexprtipo listtipo;
    int nargs;
};
struct exprtipo {
    int tipo;
    pontexprtipo prox;
};

/*  
    Variaveis globais para a tabela de simbolos e analise semantica
*/

simbolo tabsimb[NCLASSHASH], simb, escopo;
listsimb pontvardecl, pontfunc, pontparam;
int tipocorrente, tab = 0;
bool declparam, declfunc;

/*
    Prototipos das funcoes para a tabela de simbolos
        e analise semantica
 */

/*  Tabulacao para prettyPrinter  */

void tabular();

/*  Manipulacao da Tabela de Simbolos  */

int hash (char *);
void InicTabSimb (void);
void ImprimeTabSimb (void);
void ImprimeDeclaracoes (simbolo s);
void InsereListSimb (simbolo, listsimb *);
simbolo InsereSimb (char *, int, int, simbolo);
void VerificaInicRef (void);

/*  Verificação de Declaracao de Simbolo */

simbolo SimbDeclaradoEscopo (char *, listsimb, simbolo);
simbolo SimbDeclarado (char *);

/*  Testes de compatibilidade entre parametros 
        e argumentos escalares   */

pontexprtipo InicListTipo (int);
pontexprtipo ConcatListTipo (pontexprtipo, pontexprtipo);

/* Verificação de erros semanticos */

void ExceptionIncomp (char *, char *, char *);
void Exception (char *, char *);

/* Verifica se os tipos sao incompativeis na atribuicao */

void ChecArgumentos (pontexprtipo, listsimb);
char EhIncompativel (int, int);

/****************************************************/
/*                                                  */
/*          Código Intermediário - Declarações      */
/*                                                  */
/****************************************************/

union atribopnd {
    simbolo simb; int valint; float valfloat;
    char valchar; bool vallogic; char *valcad;
    quadrupla rotulo; modhead modulo, func;
};

struct operando {
    int tipo; atribopnd atr;
};

struct celquad {
    int num, oper; operando opnd1, opnd2, result;
    quadrupla prox;
};

struct celmodhead {
    simbolo modname; modhead prox;
   int modtip;
    quadrupla listquad;
};

/* Variaveis globais para o codigo intermediario */

quadrupla quadcorrente, quadaux, quadaux2, quadIndex;
modhead codintermed, modcorrente;
int oper, numquadcorrente, numtemp = 0;
operando opnd1, opnd2, result, opndaux;
const operando opndidle = {IDLEOPND, 0};

/* Prototipos das funcoes para o codigo intermediario */

void InicCodIntermed (void);
void InicCodIntermMod (simbolo);
void ImprimeQuadruplas (void);
void ImprimeTipoOpnd (operando);
quadrupla GeraQuadrupla (int, operando, operando, operando);
simbolo NovaTemp (int);
void RenumQuadruplas (quadrupla, quadrupla);

/* Declaracoes para atributos das expressoes e variaveis */

typedef struct infoexpressao infoexpressao;
struct infoexpressao {
    int tipo;
    operando opnd;
};

typedef struct infovariavel infovariavel;
struct infovariavel {
    simbolo simb;
    operando opnd;
};

%}

/* Definicao do tipo de yylval e dos atributos dos nao terminais */

%union {
    char cadeia[50];
    int atr, valint;
    float valreal;
    char carac;
    simbolo simb;
    infoexpressao infoexpr;
    infolistexpr infolexpr;
    infovariavel infovar;
    int tipoexpr, nsubscr, nargs;
    quadrupla quad;
}

/****************************************************/
/*                                                  */
/*          Análise Sintática - Types, Tokens       */
/*                                                  */
/****************************************************/

/* Declaracao dos atributos dos tokens e dos nao-terminais */

%type   <infovar>   Variavel    ChamadaFunc ChamadaProc
%type   <infoexpr>  Expressao   ExprAux1    ExprAux2    Termo
                    ElemEscr    ExprAux3    ExprAux4    Fator  
%type   <nsubscr>   ListSubscr
%type   <nargs>     ListLeit    ListEscr
%type   <infolexpr> ListExpr    Argumentos

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

%token  INTEIRO
%token  REAL
%token  CARAC
%token  LOGICO
%token  VAZIO

%token  ABCHAVE
%token  ABCOL
%token  ABPAR
%token  ATRIB
%token  DPONTS
%token  FCHAVE
%token  FCOL
%token  FPAR
%token  PONTO
%token  PVIRG
%token  VIRG

%token  <carac> INVAL

%%

/****************************************************/
/*                                                  */
/*      Linguagem COMP ITA 2016 - Gramática         */
/*                                                  */
/****************************************************/

/* Producoes da gramatica:

    Os terminais sao escritos e, depois de alguns,
    para alguma estetica, ha mudanca de linha       
*/

Programa    :   {
                    InicTabSimb(); InicCodIntermed ();
                    escopo = simb = 
                        InsereSimb("Global", IDGLOB, NOTVAR, NULL);
                    InicCodIntermMod (simb);
                    opnd1.tipo = MODOPND;
                    opnd1.atr.modulo = modcorrente;
                    GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
                    pontvardecl = simb->listvardecl;
                    pontfunc = simb->listfunc;
                    declparam = FALSE; declfunc = TRUE;
                }
                DeclGlobs   Funcoes 
                {
                    GeraQuadrupla (OPEXIT, opndidle, opndidle, opndidle);
                    VerificaInicRef (); ImprimeTabSimb (); ImprimeQuadruplas ();
                }
            ;
DeclGlobs   :
            |   GLOBAIS  DPONTS  {
                    printf("globais:\n"); tab = 1; 
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
            |   VAZIO   {printf("vazio ");  tipocorrente = VOID;   } 
            ;
ListElemDecl:   ElemDecl
            |   ListElemDecl {printf(", ");} VIRG ElemDecl
            ;
ElemDecl    :   ID {
                    printf ("%s", $1);
                    if  (SimbDeclaradoEscopo($1, escopo->listvardecl, escopo) != NULL) 
                        Exception (errorDeclRepetida, $1);
                    else if (tipocorrente == VOID)
                        Exception (errorTipoInadeq, $1);
                    simb =  InsereSimb ($1, IDVAR, tipocorrente, escopo);
                    simb->ndims = 0;
                } ListDims
            ;
ListDims    :
            |   ListDims  Dimensao {simb->array = TRUE;}
            ;
Dimensao    :   ABCOL  CTINT FCOL {
                    printf("[%d]", $2);
                     if ($2 <= 0) Exception (errorEsperado, "Valor inteiro positivo");
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
Cabecalho   :   PRINCIPAL   {
                    printf("principal");
                    if (declfunc == FALSE) {
                        Exception (errorIncomp, INCOMP_FUNPRIN2);
                    }
                    escopo = simb = 
                        InsereSimb ("Principal", IDFUNC, VOID, escopo);
                    pontvardecl = simb->listvardecl;
                    pontparam = simb->listparam;
                    declfunc = FALSE;

                    InicCodIntermMod (simb);
                    opnd1.tipo = MODOPND;
                    opnd1.atr.modulo = modcorrente;
                    GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
                }
            |   Tipo  ID ABPAR {
                    declparam = TRUE;
                    printf("%s (", $2);
                    if (declfunc == FALSE)
                        Exception (errorIncomp, INCOMP_FUNPRIN1);
                    if  ( SimbDeclaradoEscopo($2, escopo->listfunc, escopo) != NULL
                       || SimbDeclaradoEscopo($2, escopo->listvardecl, escopo) != NULL) {
                        Exception (errorDeclIndevida, $2);
                    }
                    escopo = simb = 
                        InsereSimb ($2, IDFUNC, tipocorrente, escopo);
                    pontvardecl = simb->listvardecl;
                    pontparam = simb->listparam; 

                    InicCodIntermMod (simb);
                    opnd1.tipo = MODOPND;
                    opnd1.atr.modulo = modcorrente;
                    GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
                } 
                Params FPAR {declparam = FALSE; printf(")");} 
            ;
Params      :
            |   ListParam
            ;
ListParam   :   Parametro
            |   ListParam VIRG {printf(", ");} Parametro
            ;
Parametro   :   Tipo  ID {
                    printf ("%s", $2);
                    simb = SimbDeclarado ($2);
                    if  (SimbDeclaradoEscopo($2, escopo->listparam, escopo) != NULL)
                        Exception (errorDeclRepetida, $2);
                    else if  (simb != NULL && simb->tid == IDFUNC)
                        Exception (errorNaoEsperado, "Funcao no argumento");
                    else if (tipocorrente == VOID)
                        Exception (errorTipoInadeq, $2);
                    simb =  InsereSimb ($2, IDVAR, tipocorrente, escopo);
                }
            ;
DeclLocs    :
            |   LOCAIS  DPONTS {tab = 1; printf("locais:\n");}
                ListDecl
            ;
Cmds        :   COMANDOS  DPONTS  {tab = 1; printf("comandos:\n");} ListCmds {
                    if (quadcorrente->oper != OPRETURN)
                        GeraQuadrupla (OPRETURN, opndidle, opndidle, opndidle);
                }
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
            |   PVIRG           {printf(";\n"); GeraQuadrupla (NOP, opndidle, opndidle, opndidle);}
            ;
CmdComposto :   ABCHAVE {printf ("{\n"); tab++;}  ListCmds FCHAVE
                {tab--; tabular (); printf ("}\n");}
            ;
CmdSe       :   SE  ABPAR {printf("se (");} Expressao {
                    if ($4.tipo != LOGIC)
                        Exception (errorIncomp, INCOMP_SE);
                    opndaux.tipo = ROTOPND;
                        $<quad>$ = 
                            GeraQuadrupla (OPJF, $4.opnd, opndidle, opndaux);
                }  
                FPAR {printf (") "); } CmdInside {
                    $<quad>$ = quadcorrente;
                    $<quad>5->result.atr.rotulo =
                        GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                } CmdSenao {
                    if ($<quad>9->prox != quadcorrente) {
                        quadaux = $<quad>9->prox;
                        $<quad>9->prox = quadaux->prox;
                        quadaux->prox = $<quad>9->prox->prox;
                        $<quad>9->prox->prox = quadaux;
                        RenumQuadruplas ($<quad>9, quadcorrente);
                    }
                }
            ;
CmdInside   :   CmdComposto
            |   {printf("\n"); tab++; tabular();}
                Comando
                {tab--;}
            ;
CmdSenao    :
            |   SENAO {
                    tabular(); printf("senao ");
                    opndaux.tipo = ROTOPND;
                    $<quad>$ = 
                        GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
                }
                Comando {
                    $<quad>2->result.atr.rotulo =
                        GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                }
            ;
CmdEnquanto :   ENQUANTO  ABPAR {
                    printf("enquanto (");
                    $<quad>$ = 
                        GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                } 
                Expressao {
                    if ($4.tipo != LOGIC)
                        Exception (errorIncomp, INCOMP_ENQUANTO); 
                    opndaux.tipo = ROTOPND;
                    $<quad>$ = 
                        GeraQuadrupla (OPJF, $4.opnd, opndidle, opndaux);
                }
                FPAR { printf (") "); } Comando  {
                    opndaux.tipo = ROTOPND;
                    opndaux.atr.rotulo = $<quad>3;
                    GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
                    $<quad>5->result.atr.rotulo =
                        GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                }
            ;
CmdRepetir  :   REPETIR  {printf("repetir ");}
                CmdInside ENQUANTO   ABPAR  {
                    tabular(); printf("enquanto ("); 
                    $<quad>$ =
                        GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                }
                Expressao FPAR PVIRG  {
                    printf(");\n"); 
                    if ($7.tipo != LOGIC)
                        Exception (errorIncomp, INCOMP_REPETIR); 
                    opndaux.tipo = ROTOPND;
                    opndaux.atr.rotulo = $<quad>6;
                    GeraQuadrupla (OPJF, $7.opnd, opndidle, opndaux);
                }
            ;
CmdPara     :   PARA  ABPAR {printf("para (");}
                Variavel    {
                    if ($4.simb != NULL) {
                        $4.simb->inic = $4.simb->ref = TRUE;
                        if (!($4.simb->tvar == INTEGER || $4.simb->tvar == CHAR))
                            Exception (errorIncomp, INCOMP_PARAVAR1);
                    }
                    printf(" := ");
                }
                ATRIB Expressao PVIRG {
                    printf ("; ");
                    if (!($7.tipo == INTEGER || $7.tipo == CHAR)) 
                        Exception (errorIncomp, INCOMP_PARAEXP1);
                    if ($4.simb->array == TRUE)
                        GeraQuadrupla (OPATRIBPONT, $7.opnd, opndidle, quadIndex->result);
                    else GeraQuadrupla (OPATRIB, $7.opnd, opndidle, $4.opnd);
                    $<quad>$ = 
                        GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                } 
                Expressao {
                    if ($10.tipo != LOGIC) 
                        Exception (errorIncomp, INCOMP_PARAEXP2); 
                    opndaux.tipo = ROTOPND;
                    $<quad>$ = 
                        GeraQuadrupla (OPJF, $10.opnd, opndidle, opndaux);
                } PVIRG {
                    printf("; ");
                    $<quad>$ = 
                        GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                }
                Variavel {
                    if ($14.simb != NULL) {
                        $14.simb->ref = TRUE;
                        if (!($14.simb->tvar == INTEGER || $14.simb->tvar == CHAR))
                            Exception (errorIncomp, INCOMP_PARAVAR2);
                        if (strcmp($4.simb->cadeia, $14.simb->cadeia)!=0)
                            Exception(errorIncomp, INCOMP_PARAVAR12);
                    }
                    printf(" := ");
                }
                ATRIB Expressao FPAR  {
                    if (!($17.tipo == INTEGER || $17.tipo == CHAR)) 
                        Exception (errorIncomp, INCOMP_PARAEXP3);
                    printf (") ");
                    if ($14.simb->array == TRUE)
                        GeraQuadrupla (OPATRIBPONT, $17.opnd, opndidle, quadIndex->result);
                    else GeraQuadrupla (OPATRIB, $17.opnd, opndidle, $14.opnd);
                    $<quad>$ = quadcorrente;
                }{ 
                    $<quad>$ = 
                        GeraQuadrupla (NOP, opndidle, opndidle, opndidle); 
                }
                Comando {
                    quadaux = quadcorrente;
                    opndaux.tipo = ROTOPND;  opndaux.atr.rotulo = $<quad>9;
                    quadaux2 = GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
                    $<quad>11->result.atr.rotulo = 
                        GeraQuadrupla (NOP, opndidle, opndidle, opndidle); 
                    // Correcao da ordem das quadruplas
                    $<quad>11->prox = $<quad>20;
                    quadaux->prox = $<quad>13;
                    $<quad>19->prox = quadaux2;
                    RenumQuadruplas ($<quad>11,  quadcorrente);
                }
            ;
CmdLer      :   LER  ABPAR  {printf("ler (");}
                ListLeit  FPAR  PVIRG {printf(");\n");}
            ;
ListLeit    :   Variavel {
                    if ($1.simb != NULL) {
                        $1.simb->inic = $1.simb->ref = TRUE;
                        $$ = 1;
                        if ($1.simb->array == TRUE) {
                            opnd1.tipo = VAROPND;
                            opnd1.atr.simb = NovaTemp ($1.simb->tvar); 
                            GeraQuadrupla (PARAM, opnd1, opndidle, opndidle);
                            opndaux.tipo = INTOPND;
                            opndaux.atr.valint = 1;
                            GeraQuadrupla (OPREAD, opndaux, opndidle, opndidle);
                            GeraQuadrupla (OPATRIBPONT, opnd1, opndidle, quadIndex->result);
                        }
                        else {
                            GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                            opndaux.tipo = INTOPND;
                            opndaux.atr.valint = 1;
                            GeraQuadrupla (OPREAD, opndaux, opndidle, opndidle);
                        }
                    }
                }
            |   ListLeit VIRG   
                {printf(", ");} Variavel {
                    if ($4.simb != NULL) {
                        $4.simb->inic = $4.simb->ref = TRUE;
                        $$ = $1 + 1;
                        if ($4.simb->array == TRUE) {
                            opnd1.tipo = VAROPND;
                            opnd1.atr.simb = NovaTemp ($4.simb->tvar); 
                            GeraQuadrupla (PARAM, opnd1, opndidle, opndidle);
                            opndaux.tipo = INTOPND;
                            opndaux.atr.valint = 1;
                            GeraQuadrupla (OPREAD, opndaux, opndidle, opndidle);
                            GeraQuadrupla (OPATRIBPONT, opnd1, opndidle, quadIndex->result);
                        }
                        else {
                            GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                            opndaux.tipo = INTOPND;
                            opndaux.atr.valint = 1;
                            GeraQuadrupla (OPREAD, opndaux, opndidle, opndidle);
                        }
                    }
                } 
            ;
CmdEscrever :   ESCREVER  ABPAR  {printf("escrever (");} ListEscr {
                    opnd1.tipo = INTOPND;
                    opnd1.atr.valint = $4;
                    GeraQuadrupla (OPWRITE, opnd1, opndidle, opndidle);
                } 
                FPAR  PVIRG  {printf(");\n");}
            ;
ListEscr    :   ElemEscr {
                    $$ = 1;
                    GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                }
            |   ListEscr VIRG {printf (", ");}  ElemEscr {
                    $$ = $1 + 1;
                    GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                }
            ;
ElemEscr    :   CADEIA  {
                    printf("\"%s\"", $1);
                    $$.opnd.tipo = CADOPND;
                    $$.opnd.atr.valcad = malloc (strlen($1) + 1);
                    strcpy ($$.opnd.atr.valcad, $1);
                }
            |   Expressao
            ;
ChamadaProc :   CHAMAR ID ABPAR {
                    printf("chamar %s(", $2);
                    simb = SimbDeclarado ($2);
                    if (! simb) 
                        Exception (errorNaoDecl, $2);
                    else if (simb->tid != IDFUNC || simb->tvar != VOID)
                        Exception (errorTipoInadeq, $2);
                    else if (escopo == simb)
                        Exception (errorRecursiva, $2);
                    $<simb>$ = simb;
                }
                Argumentos FPAR PVIRG {
                    printf(");\n");
                    $$.simb = $<simb>4;
                    if ($$.simb && $$.simb->tid == IDFUNC) {
                        if ($$.simb->nparam != $5.nargs)
                            Exception (errorIncomp, INCOMP_NARG);
                        ChecArgumentos  ($5.listtipo, $$.simb->listparam); 
                    }
                    opnd1.tipo = PROCOPND;  opnd1.atr.func = $$.simb->fhead;
                    opnd2.tipo = INTOPND;   opnd2.atr.valint = $5.nargs;
                    GeraQuadrupla (OPCALL, opnd1, opnd2, opndidle);
                }
            ;
Argumentos  :   { $$.nargs = 0;  $$.listtipo = NULL; }
            |   ListExpr
            ;
ListExpr    :   Expressao { 
                    if ($1.tipo == FUNC) Exception(errorNaoEsperado, "Funcao no parametro");
                    $$.nargs = 1;   $$.listtipo = InicListTipo ($1.tipo); 
                    GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                }
            |   ListExpr VIRG   {printf(", ");} Expressao {
                    if ($4.tipo == FUNC) Exception(errorNaoEsperado, "Funcao no parametro");
                    $$.nargs = $1.nargs + 1;
                    $$.listtipo = ConcatListTipo ($1.listtipo, InicListTipo ($4.tipo));
                    GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                }
            ;
CmdRetornar :   RETORNAR  PVIRG {
                    printf("retornar;\n");
                    if (escopo != NULL && escopo->tvar != VOID)
                        ExceptionIncomp(errorIncomp, "vazio", nometipesp[escopo->tvar]);
                    GeraQuadrupla (OPRETURN, opndidle, opndidle, opndidle);
                }
            |   RETORNAR        {printf("retornar ");}
                Expressao PVIRG {
                    printf (";\n");
                    if (EhIncompativel($3.tipo, escopo->tvar) == TRUE)
                        ExceptionIncomp(errorIncomp, nometipvar[$3.tipo], nometipesp[escopo->tvar]);
                    GeraQuadrupla (OPRETURN, $3.opnd, opndidle, opndidle);
                }
            ;
CmdAtrib    :   Variavel {
                    if ($1.simb != NULL) $1.simb->inic = $1.simb->ref = TRUE;
                }
                ATRIB    {printf (" := ");}
                Expressao PVIRG {
                    printf (";\n");
                    if ($1.simb != NULL && EhIncompativel($5.tipo, $1.simb->tvar) == TRUE)
                        ExceptionIncomp(errorIncomp, nometipvar[$5.tipo], nometipesp[$1.simb->tvar]);
                    if ($1.simb->array == TRUE)
                        GeraQuadrupla (OPATRIBPONT, $5.opnd, opndidle, quadIndex->result);
                    else GeraQuadrupla (OPATRIB, $5.opnd, opndidle, $1.opnd);
                }
            ;
Expressao   :   ExprAux1
            |   Expressao  OR {printf(" || ");} ExprAux1 {
                    if ($1.tipo != LOGIC || $4.tipo != LOGIC)
                        Exception (errorIncomp, INCOMP_OR);
                    $$.tipo = LOGIC;
                    $$.opnd.tipo = VAROPND;
                    $$.opnd.atr.simb = NovaTemp ($$.tipo);
                    GeraQuadrupla (OPOR, $1.opnd, $4.opnd, $$.opnd);
                }
            ;
ExprAux1    :   ExprAux2
            |   ExprAux1  AND {printf(" && ");} ExprAux2 {
                    if ($1.tipo != LOGIC || $4.tipo != LOGIC)
                        Exception (errorIncomp, INCOMP_AND);
                    $$.tipo = LOGIC;
                    $$.opnd.tipo = VAROPND;
                    $$.opnd.atr.simb = NovaTemp ($$.tipo);
                    GeraQuadrupla (OPAND, $1.opnd, $4.opnd, $$.opnd);
                }
            ;
ExprAux2    :   ExprAux3
            |   NOT {printf ("!");}  ExprAux3  {
                    if ($3.tipo != LOGIC)
                        Exception (errorIncomp, INCOMP_NOT);
                    $$.tipo = LOGIC;
                    $$.opnd.tipo = VAROPND;
                    $$.opnd.atr.simb = NovaTemp ($3.tipo);
                    GeraQuadrupla (OPNOT, $3.opnd, opndidle, $$.opnd);
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
                        if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR 
                         || $4.tipo != INTEGER && $4.tipo != FLOAT && $4.tipo != CHAR)
                            Exception (errorIncomp, INCOMP_OPREL);
                        break;
                    case EQ: case NE:
                        if (($1.tipo == LOGIC || $4.tipo == LOGIC) && $1.tipo != $4.tipo)
                            Exception (errorIncomp, INCOMP_OPREL);
                        break;
                    }
                    $$.tipo = LOGIC;
                    $$.opnd.tipo = VAROPND;
                    $$.opnd.atr.simb = NovaTemp ($$.tipo);
                    switch ($2) {
                        case LT: GeraQuadrupla (OPLT, $1.opnd, $4.opnd, $$.opnd); break;
                        case LE: GeraQuadrupla (OPLE, $1.opnd, $4.opnd, $$.opnd); break;
                        case GT: GeraQuadrupla (OPGT, $1.opnd, $4.opnd, $$.opnd); break;
                        case GE: GeraQuadrupla (OPGE, $1.opnd, $4.opnd, $$.opnd); break;
                        case EQ: GeraQuadrupla (OPEQ, $1.opnd, $4.opnd, $$.opnd); break;
                        case NE: GeraQuadrupla (OPNE, $1.opnd, $4.opnd, $$.opnd); break;
                    }
                }
            ;
ExprAux4    :   Termo
            |   ExprAux4 OPAD {
                switch ($2) {
                    case MAIS  : printf (" + "); break;
                    case MENOS : printf (" - "); break;
                }
            } Termo  {
                if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR 
                 || $4.tipo != INTEGER && $4.tipo != FLOAT && $4.tipo != CHAR)
                    Exception (errorIncomp, INCOMP_OPARIT);
                if ($1.tipo == FLOAT || $4.tipo == FLOAT) $$.tipo = FLOAT;
                else $$.tipo = INTEGER;
                $$.opnd.tipo = VAROPND;
                $$.opnd.atr.simb = NovaTemp ($$.tipo);
                if ($2 == MAIS)
                     GeraQuadrupla (OPMAIS, $1.opnd, $4.opnd, $$.opnd);
                else GeraQuadrupla (OPMENOS, $1.opnd, $4.opnd, $$.opnd);
            }
            ;
Termo       :   Fator
            |   Termo  OPMULT
            {
                switch ($2) {
                    case MULT :  printf (" * "); break;
                    case DIV  :  printf (" / "); break;
                    case RESTO:  printf (" %% "); break;
                }
            }  Fator {
                switch ($2) {
                    case MULT: case DIV:
                        if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR
                         || $4.tipo != INTEGER && $4.tipo != FLOAT && $4.tipo != CHAR)
                            Exception (errorIncomp, INCOMP_OPARIT);
                        if ($1.tipo == FLOAT || $4.tipo == FLOAT) $$.tipo = FLOAT;
                        else $$.tipo = INTEGER;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        if ($2 == MULT)
                             GeraQuadrupla (OPMULTIP, $1.opnd, $4.opnd, $$.opnd);
                        else GeraQuadrupla (OPDIV, $1.opnd, $4.opnd, $$.opnd);
                    break;
                    case RESTO:
                        if ($1.tipo != INTEGER && $1.tipo != CHAR
                        ||  $4.tipo != INTEGER && $4.tipo != CHAR)
                            Exception (errorIncomp, INCOMP_OPREST);
                        $$.tipo = INTEGER;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        GeraQuadrupla (OPRESTO, $1.opnd, $4.opnd, $$.opnd);
                    break;
                }
            }
            ;
Fator       :   Variavel {
                    if  ($1.simb != NULL)  {
                        $1.simb->ref  =  TRUE;
                        $$.tipo = $1.simb->tvar;
                        $$.opnd = $1.opnd;

                        if($1.simb->array == TRUE) {
                            result.tipo = VAROPND;
                            result.atr.simb = NovaTemp ($1.simb->tvar); 
                            GeraQuadrupla(OPCONTAPONT, quadIndex->result, opndidle, result);
                            $$.opnd = result;
                        }
                    }
                }
            |   CTINT {
                    printf ("%d", $1); $$.tipo = INTEGER; 
                    $$.opnd.tipo = INTOPND;
                    $$.opnd.atr.valint = $1;
                }
            |   CTREAL {
                    printf ("%g", $1); $$.tipo = FLOAT;
                    $$.opnd.tipo = REALOPND;
                    $$.opnd.atr.valfloat = $1;
                }
            |   CTCARAC {
                    printf ("\'%c\' ", $1); $$.tipo = CHAR;
                    $$.opnd.tipo = CHAROPND;
                    $$.opnd.atr.valchar = $1;
                }
            |   CADEIA {
                    printf ("\"%s\"", $1); $$.tipo = CADEIA;
                    $$.opnd.tipo = CADOPND;
                    $$.opnd.atr.valcad = malloc (strlen($1) + 1);
                    strcpy($$.opnd.atr.valcad, $1);
                }
            |   VERDADE {
                    printf ("true");   $$.tipo = LOGIC;
                    $$.opnd.tipo = LOGICOPND;
                    $$.opnd.atr.vallogic = TRUE;
                }
            |   FALSO {
                    printf ("false");  $$.tipo = LOGIC;
                    $$.opnd.tipo = LOGICOPND;
                    $$.opnd.atr.vallogic = FALSE;
                }
            |   NEG {printf ("~");} Fator  
                {
                    if ($3.tipo != INTEGER && $3.tipo != FLOAT && $3.tipo != CHAR)
                        Exception (errorIncomp, INCOMP_OPNEG);
                    if ($3.tipo == FLOAT) $$.tipo = FLOAT;
                    else $$.tipo = INTEGER;
                    $$.opnd.tipo = VAROPND;
                    $$.opnd.atr.simb = NovaTemp ($$.tipo);
                    GeraQuadrupla  (OPMENUN, $3.opnd, opndidle, $$.opnd);
                }
            |   ABPAR           {printf("(");}
                Expressao  FPAR {printf (")"); $$.tipo = $3.tipo; $$.opnd = $3.opnd;}
            |   ChamadaFunc     {
                    $$.tipo = quadcorrente->result.atr.simb->tvar; 
                    $$.opnd.tipo = VAROPND; 
                    $$.opnd.atr.simb = quadcorrente->result.atr.simb;
                }
            ;
Variavel    :   ID {
                    printf ("%s", $1);
                    simb = SimbDeclarado ($1);
                    if (simb == NULL)   
                        Exception (errorNaoDecl, $1);
                    else if (simb->tid != IDVAR)  
                        Exception (errorTipoInadeq, $1);
                    $<simb>$ = simb;
                } ListSubscr  {
                    $$.simb = $<simb>2;
                    if ($$.simb != NULL) {
                        if ($$.simb->array == FALSE && $3 > 0)
                            Exception (errorNaoEsperado, "Subscrito\(s)");
                        else if ($$.simb->array == TRUE && $3 == 0)
                            Exception (errorEsperado, "Subscrito\(s)");
                        else if ($$.simb->ndims != $3)
                            Exception (errorIncomp, INCOMP_NUMSUB);
                        $$.opnd.tipo = VAROPND;
                        if ($3 == 0)
                            $$.opnd.atr.simb = $$.simb;
                        else {
                            $$.opnd.atr.simb = $$.simb;
                            opnd2.tipo = INTOPND;   
                            opnd2.atr.valint = $3;
                            result.tipo = VAROPND;
                            result.atr.simb = NovaTemp ($$.simb->tvar); 
                            quadIndex =
                                GeraQuadrupla(OPINDEX, $$.opnd, opnd2, result);
                        }
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
                    if ($3.tipo != INTEGER && $3.tipo != CHAR)
                        Exception (errorIncomp, INCOMP_TIPOSUB);

                    GeraQuadrupla(OPIND, $3.opnd, opndidle, opndidle);
                }
            ;
ChamadaFunc :   ID ABPAR {
                    printf ("%s (", $1);
                    simb = SimbDeclarado ($1);
                    if (! simb) 
                        Exception (errorNaoDecl, $1);
                    else if (simb->tid != IDFUNC || simb->tvar == VOID)
                        Exception (errorTipoInadeq, $1);
                    else if (escopo == simb)
                        Exception (errorRecursiva, $1);
                    $<simb>$ = simb;
                }
                Argumentos {printf(")");}
                FPAR  {
                    $$.simb = $<simb>3;
                    if ($$.simb && $$.simb->tid == IDFUNC) {
                        if ($$.simb->nparam != $4.nargs)
                            Exception (errorIncomp, INCOMP_NARG);
                        ChecArgumentos  ($4.listtipo, $$.simb->listparam); 
                    }
                    opnd1.tipo = FUNCOPND;  opnd1.atr.func = $$.simb->fhead;
                    opnd2.tipo = INTOPND;   opnd2.atr.valint = $4.nargs;
                    if ($$.simb->tvar == NOTVAR) result = opndidle;
                    else { 
                        result.tipo = VAROPND;
                        result.atr.simb = NovaTemp ($$.simb->tvar); 
                    }   
                    GeraQuadrupla (OPCALL, opnd1, opnd2, result);
                    $$.opnd = result;
                }  
            ;
%%
/* Inclusao do analisador lexico  */

#include "lex.yy.c"

/****************************************************/
/*                                                  */
/*          Compilador - Funções Auxiliares         */
/*                                                  */
/****************************************************/

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
    SimbDeclaradoEscopo(cadeia, escopo):
    Verifica se o símbolo foi declarado no escopo atual;

    Sua chamada é dividida conforme o tipo do símbolo:
        Variável, Parâmetro, Função

    Caso ela ali esteja, retorna um ponteiro para sua celula;
    Caso contrário, retorna NULL;
 */

simbolo SimbDeclaradoEscopo (char *cadeia, listsimb listHeader, simbolo escopo) {
    listsimb list;
    if (listHeader == NULL) return NULL;
    for (list = listHeader->prox; list != NULL; list = list->prox)
        if (strcmp(cadeia, list->simb->cadeia) == 0)
            return list->simb;
    return NULL;
}

/*
    SimbDeclarado(cadeia):
    Verifica se o símbolo foi declarado no escopo atual ou ancestral;
    Caso ela ali esteja, retorna um ponteiro para sua celula;
    Caso contrário, retorna NULL;
 */

simbolo SimbDeclarado (char *cadeia) {
    simbolo esc, s = NULL;
    for (esc = escopo; esc!=NULL; esc = esc->escopo) {
        s = SimbDeclaradoEscopo(cadeia, esc->listvardecl, escopo);
        if (s!=NULL) return s;
        s = SimbDeclaradoEscopo(cadeia, esc->listparam, escopo);
        if (s!=NULL) return s;
        s = SimbDeclaradoEscopo(cadeia, esc->listfunc, escopo);
        if (s!=NULL) return s;
    }
    return NULL;
}

/*
    InsereListSimb (simbolo, listasimbolos): 
    Insere simbolo na lista de simbolos, usando lista encadeada.
 */

void InsereListSimb (simbolo simb, listsimb *list) {
    listsimb aux = (elemlistsimb *) 
            malloc  (sizeof (elemlistsimb));
    aux->simb = simb;
    aux->prox = NULL;
    (*list)->prox = aux;
    (*list) = aux;
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
    s->tid = tid;       s->tvar = tvar;     s->array = FALSE;
    s->prox = aux;      s->escopo = escopo;
    s->listvardecl = s->listparam = s->listfunc = NULL;

    if (tid == IDVAR) {
        if (declparam == TRUE) {
            s->inic = s->ref = s->param = TRUE;
            if (s->tid == IDVAR)
                InsereListSimb (s, &pontparam);
            s->escopo->nparam++;
        }
        else {
            s->inic = s->ref = s->param = FALSE;
            if (s->tid == IDVAR)
                InsereListSimb (s, &pontvardecl);
            s->tvar = tvar;
            s->tparam = tvar;   
        }     
        s->array = FALSE;   
        s->ndims = 0;
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
    for (h = i = 0; cadeia[i]; i++) h += cadeia[i];
    return h % NCLASSHASH;
}

/* 
    ImprimeTabSimb: Imprime todo o conteudo da tabela de simbolos  
*/

void ImprimeTabSimb () {
    int i, j; simbolo s;
    printf ("\n\n\tTABELA  DE  SIMBOLOS:\n\n");
    for (i = 0; i < NCLASSHASH; i++)
        if (tabsimb[i]) {
            printf ("Classe %d:\n", i);
            for (s = tabsimb[i]; s!=NULL; s = s->prox){
                printf ("  (%-8s, %s, %-6s", s->cadeia, nometipid[s->tid], nometipvar[s->tvar]);
                if (s->tid == IDVAR) {
                    printf (", %d, %d", s->inic, s->ref);
                    if (s->array == TRUE) 
                    { 
                        printf (", EH ARRAY\n\tndims = %d, dimensoes:", s->ndims);
                        for (j = 1; j <= s->ndims; j++)
                            printf ("  %d", s->dims[j]);
                    }
                }
                if (s->escopo != NULL)
                    printf(", escopo: %s", s->escopo->cadeia);
                else printf(", escopo: NULL");
                ImprimeDeclaracoes(s);
                printf(");\n");
            }
        }
}

/* 
    ImprimeDeclaracoes(simbolo): Imprime todo o conteudo da 
    Lista de Variaveis, Parametros e Funcoes do dado simbolo
  */

void ImprimeDeclaracoes (simbolo s) {
    listsimb aux; int j;
    if (s->listvardecl != NULL) {
        printf("\n\tVariaveis: ");
        if (s->listvardecl->prox == NULL) printf("NULL");
        for(aux = s->listvardecl->prox; aux != NULL; aux = aux->prox) {
            printf("%s %s", nometipvar[aux->simb->tvar], aux->simb->cadeia);
            if (aux->simb->array == TRUE)
                for (j = 1; j <= aux->simb->ndims; j++)
                    printf ("[%d]", aux->simb->dims[j]);
            if (aux->prox != NULL) printf(", ");
        }
    }
    if (s->listparam != NULL) {
        printf("\n\tParametros: ");
        if (s->listparam->prox == NULL) printf("NULL");
        for(aux = s->listparam->prox; aux != NULL; aux = aux->prox) {
            printf("%s %s", nometipvar[aux->simb->tvar], aux->simb->cadeia);
            if (aux->simb->array == TRUE)
                for (j = 1; j <= aux->simb->ndims; j++)
                    printf ("[%d]", aux->simb->dims[j]);
            if (aux->prox != NULL) printf(", ");
        }
    }
    if (s->listfunc != NULL) {
        printf("\n\tFuncoes: ");
        if (s->listfunc->prox == NULL) printf("NULL");
        for(aux = s->listfunc->prox; aux != NULL; aux = aux->prox) {
            printf("%s %s", nometipvar[aux->simb->tvar], aux->simb->cadeia);
            if (aux->prox != NULL) printf(", ");
        }
    }
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

/*  Inicializacao da lista de tipos     */

pontexprtipo InicListTipo (int tvar) {
    pontexprtipo listtipo;
    listtipo = (pontexprtipo) (malloc (sizeof(pontexprtipo)));
    listtipo->prox = (pontexprtipo) (malloc (sizeof(pontexprtipo)));
    listtipo->prox->tipo = tvar;
    listtipo->prox->prox = NULL;
    return listtipo;
}

/*  Concantena listas de tipos     */

pontexprtipo ConcatListTipo (pontexprtipo lista1, pontexprtipo lista2) {
    pontexprtipo p = lista1->prox;
    while(p->prox != NULL)
        p = p->prox;
    p->prox = lista2->prox;
    free(lista2);
    return lista1;
}

/* Funcao que checa os argumentos de uma chamada de funcao*/

void ChecArgumentos (pontexprtipo Ltiparg, listsimb Lparam) {
    if (Ltiparg == NULL || Lparam == NULL) return;
    pontexprtipo p = Ltiparg->prox;
    listsimb q = Lparam->prox;
    for (; p != NULL && q != NULL;  p = p->prox, q = q->prox) {
        if (q->simb->tid == IDFUNC)
            Exception(errorEsperado, "Esperado parâmetro");

        if (EhIncompativel(p->tipo, q->simb->tvar) == TRUE)
            ExceptionIncomp(errorIncomp, nometipvar[p->tipo], nometipesp[q->simb->tvar]);
    }
}

/* Funcao que verifica compatibilidade entre dois lados de atribuicao */

bool EhIncompativel (int tipoP, int tipoQ) {
    if (  (tipoQ == INTEGER
        || tipoQ  == CHAR) && (tipoP == FLOAT || tipoP == LOGIC)
        || tipoQ  == FLOAT && tipoP == LOGIC
        || tipoQ  == LOGIC && tipoP != LOGIC
        || tipoQ  == VOID)
        return TRUE;
    return FALSE;
}

/*  Mensagens de erros semanticos  */

void ExceptionIncomp (char *type, char *got, char *expected) {
    printf ("\n\n***** Exception<%s>: Obtido: %s. Esperado: %s *****\n", type, got, expected);
}

void Exception (char *type, char *error) {
    printf ("\n\n***** Exception<%s>: %s *****\n", type, error);
}

/****************************************************/
/*                                                  */
/*    Código Intermediário - Funções Auxiliares     */
/*                                                  */
/****************************************************/

void InicCodIntermed () {
    modcorrente = codintermed = malloc (sizeof (celmodhead));
    modcorrente->listquad = NULL;
    modcorrente->prox = NULL;
}

void InicCodIntermMod (simbolo simb) {
    modcorrente->prox = malloc (sizeof (celmodhead));
    modcorrente = modcorrente->prox;
    modcorrente->prox = NULL;
    modcorrente->modname = simb;
    modcorrente->modtip = simb->tid;
    modcorrente->listquad = malloc (sizeof (celquad));
    quadcorrente = modcorrente->listquad;
    quadcorrente->prox = NULL;
    numquadcorrente = 0;
    quadcorrente->num = numquadcorrente;
    simb->fhead = modcorrente;
}

quadrupla GeraQuadrupla (int oper, operando opnd1, operando opnd2,
    operando result) {
    quadcorrente->prox = malloc (sizeof (celquad));
    quadcorrente = quadcorrente->prox;
    quadcorrente->oper = oper;
    quadcorrente->opnd1 = opnd1;
    quadcorrente->opnd2 = opnd2;
    quadcorrente->result = result;
    quadcorrente->prox = NULL;
    numquadcorrente ++;
    quadcorrente->num = numquadcorrente;
    return quadcorrente;
}

simbolo NovaTemp (int tip) {
    simbolo simb; int temp, i, j;
    char nometemp[10] = "##", s[10] = {0};

    numtemp ++; temp = numtemp;
    for (i = 0; temp > 0; temp /= 10, i++)
        s[i] = temp % 10 + '0';
    i --;
    for (j = 0; j <= i; j++)
        nometemp[2+i-j] = s[j];
    simb = InsereSimb (nometemp, IDVAR, tip, escopo);
    simb->inic = simb->ref = TRUE;
    simb->array = FALSE;
    return simb;
}

void ImprimeQuadruplas () {
    modhead p;
    quadrupla q;
    printf ("\n\n\tCODIGO INTEMEDIARIO:\n");
    for (p = codintermed->prox; p != NULL; p = p->prox) {
        printf ("\n\nQuadruplas do modulo %s:\n", p->modname->cadeia);
        for (q = p->listquad->prox; q != NULL; q = q->prox) {
            printf ("\n\t%4d# %7s", q->num, nomeoperquad[q->oper]);
            printf (", (%s", nometipoopndquad[q->opnd1.tipo]);
                ImprimeTipoOpnd(q->opnd1);
            printf ("), (%s", nometipoopndquad[q->opnd2.tipo]);
                ImprimeTipoOpnd(q->opnd2);
            printf ("), (%s", nometipoopndquad[q->result.tipo]);
                ImprimeTipoOpnd(q->result);
            printf (")");
        }
    }
   printf ("\n");
}

void ImprimeTipoOpnd (operando op) {
    switch (op.tipo) {
        case IDLEOPND:                                                   break;
        case VAROPND:   printf (", %s", op.atr.simb->cadeia);            break;
        case INTOPND:   printf (", %d", op.atr.valint);                  break;
        case REALOPND:  printf (", %g", op.atr.valfloat);                break;
        case CHAROPND:  printf (", %c", op.atr.valchar);                 break;
        case LOGICOPND: printf (", %d", op.atr.vallogic);                break;
        case CADOPND:   printf (", %s", op.atr.valcad);                  break;
        case ROTOPND:   printf (", %d", op.atr.rotulo->num);             break;
        case MODOPND:   printf (", %s", op.atr.modulo->modname->cadeia); break;
        case FUNCOPND:  printf (", %s", op.atr.func->modname->cadeia);   break;
        case PROCOPND:  printf (", %s", op.atr.func->modname->cadeia);   break;
    } 
}

void RenumQuadruplas (quadrupla quad1, quadrupla quad2) {
    quadrupla q; int nquad;
    for (q = quad1->prox, nquad = quad1->num; q != quad2; q = q->prox)
        q->num = ++nquad;
}