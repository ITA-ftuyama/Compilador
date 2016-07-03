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

#define     NCLASSHASH      23
#define     TRUE            1
#define     FALSE           0
#define     MAXDIMS         10

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

/*  Definicao de mensagens de Esperado / NaoEsperado */
#define ESP_FUNC_PARAM      "Funcao no parametro"
#define ESP_SUBSCRITO       "Subscrito\(s)"
#define ESP_VALOR_POSITIVO  "Valor inteiro positivo"

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

/*  Definicao de RUN TIME Exception */
#define EXCEPTION_RECURSIVE "A linguagem nao admite recursividade."
#define EXCEPTION_INPUTFILE "Arquivo de entrada nao encontrado."
#define EXCEPTION_READFILE  "Leitura inesperada do arquivo entrada."
#define EXCEPTION_DIVZERO   "Tentativa de divisao por zero."

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
#define     OPMULT          11
#define     OPDIV           12
#define     OPRESTO         13
#define     OPMENUN         14
#define     OPNOT           15
#define     OPATRIB         16
#define     OPENMOD         17
#define     NOP             18
#define     OPJUMP          19
#define     OPJF            20
#define     OPJT            21
#define     PARAM           22
#define     OPREAD          23
#define     OPWRITE         24
#define     OPEXIT          25
#define     OPCALL          26
#define     OPRETURN        27
#define     OPIND           28
#define     OPINDEX         29
#define     OPATRIBPONT     30
#define     OPCONTAPONT     31
#define     OPABRIR         32

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

/*  Strings para verdade e falso */

char *boolean[2] = {"FALSO", "VERDADE"};

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

char *nomeoperquad[33] = {"",
    "OR", "AND", "LT", "LE", "GT", "GE", "EQ", "NE", "MAIS",
    "MENOS", "MULT", "DIV", "RESTO", "MENUN", "NOT", "ATRIB",
    "OPENMOD", "NOP", "JUMP", "JF", "JT", "PARAM", "READ", "WRITE",
    "EXIT", "CALL", "RET", "IND", "INDEX", "ATRIBPONT", "CONTAPONT",
    "ABRIR"
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
    /* Tabela de Símbolos */
    char *cadeia;
    int tid, tvar, tparam;
    int  nparam, ndims, dims[MAXDIMS+1];
    bool inic, ref, array, param, active;
    listsimb listvardecl, listparam, listfunc; 
    simbolo escopo, prox;
    modhead fhead;
    /*  Interpretador */
    int *valint;    float *valfloat;
    char *valchar;  bool *vallogic;
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

void tabular(int);

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
void RunTimeException (char *);

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
    modhead modulo;
    quadrupla prox;
};

struct celmodhead {
    simbolo modname; modhead prox;
    quadrupla listquad;
    int modtip;
};

/* Variaveis globais para o codigo intermediario */

quadrupla quadcorrente, quadaux, quadaux2;
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
    operando varindex;
};

/****************************************************/
/*                                                  */
/*          Interpretador - Declarações             */
/*                                                  */
/****************************************************/

/* Prototipos das funcoes para o interpretador */

void InterpCodIntermed (void);
void AlocaVariaveis (listsimb);
void DesalocaVariaveis (modhead *);
void ExecQuadCall (quadrupla, quadrupla*, modhead *);
void ExecQuadReturn (quadrupla, quadrupla*, modhead *);
void ExecQuadIndex (quadrupla);
void ExecQuadWrite (quadrupla);
void ExecQuadAbrir (quadrupla);
void ExecQuadAritmetica (quadrupla);
void ExecQuadResto (quadrupla);
void ExecQuadMenun (quadrupla);
void ExecQuadNot (quadrupla);
void ExecQuadAndOr (quadrupla);
void ExecQuadRel (quadrupla);
void ExecQuadAtrib (quadrupla);
void ExecQuadRead (quadrupla);
void ExecQuadJump (quadrupla, quadrupla*);

/****************************************************/
/*                                                  */
/*       Implementação de Pilha de Operandos        */
/*                                                  */
/****************************************************/

/*  Declaracoes para pilhas de operandos  */

typedef struct nohopnd nohopnd;
struct nohopnd {
    operando opnd;
    nohopnd *prox;
};
typedef nohopnd *pilhaoperando;
pilhaoperando pilhaopnd, pilhaindex;

/*  Prototipos das funcoes para pilhas de operandos  */

void EmpilharOpnd (operando, pilhaoperando *);
void DesempilharOpnd (pilhaoperando *);
operando TopoOpnd (pilhaoperando);
void InicPilhaOpnd (pilhaoperando *);
char VaziaOpnd (pilhaoperando);

/****************************************************/
/*                                                  */
/*       Implementação de Pilha de Quádruplas       */
/*                                                  */
/****************************************************/

/*  Declaracoes para pilhas de quádruplas  */

typedef struct nohquad nohquad;
struct nohquad {
    quadrupla quad;
    nohquad *prox;
};
typedef nohquad *pilhaquadruplas;
pilhaquadruplas pilhaquads;

/*  Prototipos das funcoes para pilhas de quádruplas  */

void EmpilharQuad (quadrupla, pilhaquadruplas *);
void DesempilharQuad (pilhaquadruplas *);
quadrupla TopoQuad (pilhaquadruplas);
void InicPilhaQuad (pilhaquadruplas *);
char VaziaQuad (pilhaquadruplas);

FILE *finput;
bool DEBUG = FALSE;

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

%token  <atr>       OPADD
%token  <atr>       OPREL
%token  <atr>       OPMULTIP
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
%token  ABRIR
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

                    // Chamada da função Principal
                    opnd1.tipo = PROCOPND;  opnd1.atr.func = NULL;
                    opnd2.tipo = INTOPND;   opnd2.atr.valint = 0;
                    $<quad>$ = 
                        GeraQuadrupla (OPCALL, opnd1, opnd2, opndidle);
                    GeraQuadrupla (OPEXIT, opndidle, opndidle, opndidle);
                }
                DeclGlobs   Funcoes 
                {
                    simb = SimbDeclarado ("Principal");
                    $<quad>1->opnd1.atr.func = simb->fhead;
                    if (!simb) Exception (errorNaoDecl, "Principal");
                    VerificaInicRef (); ImprimeTabSimb (); ImprimeQuadruplas ();
                    InterpCodIntermed ();
                }
            ;
DeclGlobs   :
            |   GLOBAIS  DPONTS  { tabular(1); tab = 1; printf("globais:");}
                ListDecl
            ;
ListDecl    :   Declaracao
            |   ListDecl  Declaracao
            ;
Declaracao  :   {tabular(1);}
                Tipo  ListElemDecl 
                PVIRG   {printf(";");}
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
                     if ($2 <= 0) Exception (errorEsperado, ESP_VALOR_POSITIVO);
                    simb->ndims++; simb->dims[simb->ndims] = $2;
                }
            ;
Funcoes     :   FUNCOES  DPONTS  {tab = 0; tabular(1); printf("funcoes:"); tabular(1);} 
                ListFunc
            ;
ListFunc    :   Funcao
            |   ListFunc Funcao
            ;
Funcao      :   Cabecalho ABCHAVE
                {tab++; printf (" {"); }
                DeclLocs Cmds FCHAVE {
                    tab--; tabular(1); printf ("}"); tabular(1);
                    escopo = escopo->escopo; 
                }
            ;
Cabecalho   :   {tabular(1);}  PRINCIPAL   {
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
            |   {tabular(1);}  Tipo  ID ABPAR {
                    declparam = TRUE;
                    printf("%s (", $3);
                    if (declfunc == FALSE)
                        Exception (errorIncomp, INCOMP_FUNPRIN1);
                    if  ( SimbDeclaradoEscopo($3, escopo->listfunc, escopo) != NULL
                       || SimbDeclaradoEscopo($3, escopo->listvardecl, escopo) != NULL) {
                        Exception (errorDeclIndevida, $3);
                    }
                    escopo = simb = 
                        InsereSimb ($3, IDFUNC, tipocorrente, escopo);
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
                        Exception (errorNaoEsperado, ESP_FUNC_PARAM);
                    else if (tipocorrente == VOID)
                        Exception (errorTipoInadeq, $2);
                    simb =  InsereSimb ($2, IDVAR, tipocorrente, escopo);
                }
            ;
DeclLocs    :
            |   LOCAIS  DPONTS {tab = 0; tabular(1); printf("locais:"); tab = 1;}
                ListDecl
            ;
Cmds        :   COMANDOS  DPONTS  {tab = 0; tabular(1); printf("comandos:"); tab = 1;} ListCmds {
                    if (quadcorrente->oper != OPRETURN)
                        GeraQuadrupla (OPRETURN, opndidle, opndidle, opndidle);
                }
            ;
ListCmds    :   Comando
            |   ListCmds Comando
            ;
Comando     :   CmdComposto
            |   {tabular(1);} CmdSe
            |   {tabular(1);} CmdEnquanto
            |   {tabular(1);} CmdRepetir
            |   {tabular(1);} CmdPara
            |   {tabular(1);} CmdLer
            |   {tabular(1);} CmdAbrir
            |   {tabular(1);} CmdEscrever
            |   {tabular(1);} CmdAtrib
            |   {tabular(1);} ChamadaProc
            |   {tabular(1);} CmdRetornar
            |   {tabular(1);} PVIRG         {printf(";"); GeraQuadrupla (NOP, opndidle, opndidle, opndidle);}
            ;
CmdComposto :   ABCHAVE {tab++; printf ("{"); }  ListCmds FCHAVE
                {tab--; tabular(1); printf ("}");}
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
            |   {tab++;} Comando {tab--;}
            ;
CmdSenao    :
            |   SENAO {
                    tabular(1); printf("senao ");
                    opndaux.tipo = ROTOPND;
                    $<quad>$ = 
                        GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
                }
                CmdInside {
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
CmdRepetir  :   REPETIR  {
                    printf("repetir ");
                    $<quad>$ =
                        GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                }
                CmdInside ENQUANTO   ABPAR  {
                    tabular(1); printf("enquanto ("); 
                }
                Expressao FPAR PVIRG  {
                    printf(");"); 
                    if ($7.tipo != LOGIC)
                        Exception (errorIncomp, INCOMP_REPETIR); 
                    opndaux.tipo = ROTOPND;
                    opndaux.atr.rotulo = $<quad>2;
                    GeraQuadrupla (OPJT, $7.opnd, opndidle, opndaux);
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
                        GeraQuadrupla (OPATRIBPONT, $7.opnd, opndidle, $4.varindex);
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
                        GeraQuadrupla (OPATRIBPONT, $17.opnd, opndidle, $14.varindex);
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
                ListLeit  FPAR  PVIRG {printf(");");}
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
                            GeraQuadrupla (OPATRIBPONT, opnd1, opndidle, $1.varindex);
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
                            GeraQuadrupla (OPATRIBPONT, opnd1, opndidle, $4.varindex);
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
CmdAbrir    :   ABRIR   ABPAR   CADEIA {
                    printf("abrir (\"%s\");", $3);
                    opndaux.tipo = CADOPND;
                    opndaux.atr.valcad = malloc (strlen($3) + 1);
                    strcpy (opndaux.atr.valcad, $3);
                    GeraQuadrupla (OPABRIR, opndaux, opndidle, opndidle);
                }
                FPAR  PVIRG
            ;
CmdEscrever :   ESCREVER  ABPAR  {printf("escrever (");} ListEscr {
                    opnd1.tipo = INTOPND;
                    opnd1.atr.valint = $4;
                    GeraQuadrupla (OPWRITE, opnd1, opndidle, opndidle);
                } 
                FPAR  PVIRG  {printf(");");}
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
                    printf(");");
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
                    if ($1.tipo == FUNC) Exception(errorNaoEsperado, ESP_FUNC_PARAM);
                    $$.nargs = 1;   $$.listtipo = InicListTipo ($1.tipo); 
                    GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                }
            |   ListExpr VIRG   {printf(", ");} Expressao {
                    if ($4.tipo == FUNC) Exception(errorNaoEsperado, ESP_FUNC_PARAM);
                    $$.nargs = $1.nargs + 1;
                    $$.listtipo = ConcatListTipo ($1.listtipo, InicListTipo ($4.tipo));
                    GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                }
            ;
CmdRetornar :   RETORNAR  PVIRG {
                    printf("retornar;");
                    if (escopo != NULL && escopo->tvar != VOID)
                        ExceptionIncomp(errorIncomp, "vazio", nometipesp[escopo->tvar]);
                    GeraQuadrupla (OPRETURN, opndidle, opndidle, opndidle);
                }
            |   RETORNAR        {printf("retornar ");}
                Expressao PVIRG {
                    printf (";");
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
                    printf (";");
                    if ($1.simb != NULL && EhIncompativel($5.tipo, $1.simb->tvar) == TRUE)
                        ExceptionIncomp(errorIncomp, nometipesp[$1.simb->tvar], nometipvar[$5.tipo]);
                    if ($1.simb->array == TRUE)
                        GeraQuadrupla (OPATRIBPONT, $5.opnd, opndidle, $1.varindex);
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
            |   ExprAux4 OPADD {
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
            |   Termo  OPMULTIP
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
                             GeraQuadrupla (OPMULT, $1.opnd, $4.opnd, $$.opnd);
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
                            GeraQuadrupla(OPCONTAPONT, $1.varindex, opndidle, result);
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
                            Exception (errorNaoEsperado, ESP_SUBSCRITO);
                        else if ($$.simb->array == TRUE && $3 == 0)
                            Exception (errorEsperado, ESP_SUBSCRITO);
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
                            $$.varindex = result;
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

void tabular (int n) {
    int i = 0, j = 0;
    while (i++ < n)
        printf("\n");
    while (j++ < tab)
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
    aux->prox = (*list)->prox;
    (*list)->prox = aux;
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
    if (!DEBUG) return; 
    printf ("\n\n\tTABELA  DE  SIMBOLOS:\n");
    printf ("-----------------------\n\n");
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
            Exception(errorEsperado, ESP_FUNC_PARAM);

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
    tabular(2); printf ("***** Exception<%s>: Obtido: %s. Esperado: %s *****", type, got, expected); 
    tabular(1); exit(0);
}

void Exception (char *type, char *error) {
    tabular(2); printf ("***** Exception<%s>: %s *****", type, error); 
    tabular(1); exit(0);
}

/****************************************************/
/*                                                  */
/*    Código Intermediário - Funções Auxiliares     */
/*                                                  */
/****************************************************/

/* Inicializa o código intermediário */

void InicCodIntermed () {
    modcorrente = codintermed = malloc (sizeof (celmodhead));
    modcorrente->listquad = NULL;
    modcorrente->prox = NULL;
}

/* Inicializa o código intermediário a partir do módulo global */

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

/* Cria uma nova quádrupla de operandos */

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
    quadcorrente->modulo = modcorrente;
    return quadcorrente;
}

/* Cria nova variável temporária */

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

/* Imprime todas as quádruplas do código intermediário */

void ImprimeQuadruplas () {
    modhead p;
    quadrupla q;
    if (!DEBUG) return; 
    printf ("\n\n\tCODIGO INTEMEDIARIO:\n");
    printf ("-----------------------\n");
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

/* Imprime o valor do operando em questão */

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

/* Renumera todas as quádruplas entre duas quádruplas */

void RenumQuadruplas (quadrupla quad1, quadrupla quad2) {
    quadrupla q; int nquad;
    for (q = quad1->prox, nquad = quad1->num; q != quad2; q = q->prox)
        q->num = ++nquad;
}

/****************************************************/
/*                                                  */
/*        Interpretador - Funções Auxiliares        */
/*                                                  */
/****************************************************/

/* 
    Executa rodas as quádruplas do Código Intermediário
    núcleo do interpretador da linguagem
    */

void InterpCodIntermed () {
    quadrupla quad, quadprox;
    
    // Inicialização de Pilhas e Entradas
    InicPilhaOpnd (&pilhaopnd);
    InicPilhaOpnd (&pilhaindex);
    InicPilhaQuad (&pilhaquads);

    // A execução começa no módulo global
    bool encerra = FALSE;
    modhead mod = codintermed->prox;
    printf ("\n\n\tINTERPRETADOR:\n");
    printf ("-----------------------\n\n");

    // Executa as quádruplas do módulo Principal
    for (quad = mod->listquad->prox; (!encerra && quad != NULL); quad = quadprox) {
        if (DEBUG) printf ("\n%4d# %s", quad->num, nomeoperquad[quad->oper]);
        quadprox = quad->prox;
        switch (quad->oper) {
            case OPEXIT     :   encerra = TRUE;                             break;
            case OPENMOD    :   AlocaVariaveis (mod->modname->listvardecl); break;
            case OPCALL     :   ExecQuadCall (quad, &quadprox, &mod);       break;
            case OPRETURN   :   ExecQuadReturn (quad, &quadprox, &mod);     break;
            case PARAM      :   EmpilharOpnd (quad->opnd1, &pilhaopnd);     break;
            case OPIND      :   EmpilharOpnd (quad->opnd1, &pilhaindex);    break;
            case OPINDEX    :   ExecQuadIndex (quad);                       break;
            case OPWRITE    :   ExecQuadWrite (quad);                       break;
            case OPABRIR    :   ExecQuadAbrir (quad);                       break;
            case OPMAIS     :   case OPMENOS:   
            case OPMULT     :   case OPDIV  :
                                ExecQuadAritmetica (quad);                  break;
            case OPRESTO:       ExecQuadResto (quad);                       break;
            case OPMENUN    :   ExecQuadMenun (quad);                       break;   
            case OPNOT      :   ExecQuadNot (quad);                         break;                   
            case OPAND      :   case OPOR:
                                ExecQuadAndOr (quad);                       break;
            case OPATRIB    :   case OPATRIBPONT:
            case OPCONTAPONT:   ExecQuadAtrib (quad);                       break;
            case OPLT       :   case OPLE:      
            case OPGT       :   case OPGE:      
            case OPEQ       :   case OPNE:  
                                ExecQuadRel (quad);                         break;
            case OPREAD     :   ExecQuadRead (quad);                        break;
            case OPJUMP     :   ExecQuadJump (quad, &quadprox);             break;
            case OPJF       :   ExecQuadJump (quad, &quadprox);             break;
            case OPJT       :   ExecQuadJump (quad, &quadprox);             break;
            case NOP        :                                               break;
            default         :                                               break;
        }
    }
}

/* Abre o arquivo de entrada do programa */

void ExecQuadAbrir (quadrupla quad) {
    // Se existe outro aberto, fecha
    if (finput != NULL)
        fclose (finput);

    // Abre um novo arquivo de entrada
    finput = fopen (quad->opnd1.atr.valcad, "r");
    if (finput == NULL)
        RunTimeException(EXCEPTION_INPUTFILE);
}

/* 
    Aloca em memória todas as variáveis presentes
    na Tabela de Símbolo, inclusive as temporárias
    */

void AlocaVariaveis (listsimb varlist) {
    if (DEBUG) printf ("\n\t\tAlocando as variaveis:");

    // Percorrendo as variáveis declaradas no módulo
    int j, nelemaloc; simbolo simb; listsimb var = NULL;

    if (varlist == NULL)
        return;

    for (var = varlist->prox; var != NULL; var = var->prox) {

        simb = var->simb;
        if (simb->tid == IDVAR) {
            nelemaloc = 1;
            if (simb->array) 
                for (j = 1; j <= simb->ndims; j++)  
                    nelemaloc *= simb->dims[j];
            switch (simb->tvar) {
               case INTEGER:    simb->valint   = malloc (nelemaloc * sizeof (int));    *(simb->valint)   = 0;  break;
               case FLOAT:      simb->valfloat = malloc (nelemaloc * sizeof (float));  *(simb->valfloat) = 0;  break;
               case CHAR:       simb->valchar  = malloc (nelemaloc * sizeof (char));   *(simb->valchar)  = 0;  break;
               case LOGIC:      simb->vallogic = malloc (nelemaloc * sizeof (char));   *(simb->vallogic) = 0;  break;
           }
           if (DEBUG) printf ("\n\t\t\t%6s: %2d elemento(s) alocado(s) ", simb->cadeia, nelemaloc);
        }  
    }
}

/* 
    Desaloca em memória todas as variáveis presentes
    no dado módulo, inclusive as temporárias
    */

void DesalocaVariaveis (modhead *mod) {
    if (DEBUG) printf ("\n\t\tDesalocando as variaveis:");

    // Percorrendo as variáveis declaradas no módulo
    int i, j, nelemaloc; simbolo simb; listsimb var = NULL;

    for (i = 0; i < 2; i++) {
        if (i == 0 && (*mod)->modname->listvardecl != NULL)
            var = (*mod)->modname->listvardecl->prox; 
        if (i == 1 && (*mod)->modname->listparam != NULL)
            var = (*mod)->modname->listparam->prox;
        for (; var != NULL; var = var->prox) {

            simb = var->simb;
            if (simb->tid == IDVAR) {
                nelemaloc = 1;
                if (simb->array) 
                    for (j = 1; j <= simb->ndims; j++)  
                        nelemaloc *= simb->dims[j];
                switch (simb->tvar) {
                   case INTEGER:    free(simb->valint);     break;
                   case FLOAT:      free(simb->valfloat);   break;
                   case CHAR:       free(simb->valchar);    break;
                   case LOGIC:      free(simb->vallogic);   break;
               }
               if (DEBUG) printf ("\n\t\t\t%6s: %2d elemento(s) alocado(s) ", simb->cadeia, nelemaloc);
            }  
        }
    }
}

/* 
    Chamada de procedimento/função
    - Deposita os argumentos nos parâmetros
    - Guarda o valor do PC
    - Faz as ligações de controle
    */

void ExecQuadCall (quadrupla quad, quadrupla *quadprox, modhead *mod) {

    // Guarda valor do PC
    EmpilharQuad (quad, &pilhaquads);

    // Faz as ligações de controle
    *mod = quad->opnd1.atr.func;
    *quadprox = (*mod)->listquad->prox;

    // A linguagem não suporta recursividade
    if ((*mod)->modname->active == TRUE) {
        RunTimeException(EXCEPTION_RECURSIVE);
    } (*mod)->modname->active = TRUE;

    // Deposita os argumentos nos parâmetros
    int i; simbolo simb; listsimb param; operando opndaux;

    if ((*mod)->modname->listparam == NULL)
        return;
    AlocaVariaveis((*mod)->modname->listparam);

    for (i = 1, param = (*mod)->modname->listparam->prox; 
        i <= quad->opnd2.atr.valint && param != NULL; 
        i++, param = param->prox) {

        simb = param->simb;
        opndaux = TopoOpnd (pilhaopnd);
        DesempilharOpnd (&pilhaopnd);
        switch (opndaux.tipo) {
            case INTOPND:   *(simb->valint)   = opndaux.atr.valint;     break;
            case REALOPND:  *(simb->valfloat) = opndaux.atr.valfloat;   break;
            case CHAROPND:  *(simb->valchar)  = opndaux.atr.valchar;    break;
            case LOGICOPND: *(simb->vallogic) = opndaux.atr.vallogic;   break;
            case VAROPND:
                switch (opndaux.atr.simb->tvar) {
                    case INTEGER:   *(simb->valint)   = *(opndaux.atr.simb->valint);    break;
                    case FLOAT:     *(simb->valfloat) = *(opndaux.atr.simb->valfloat);  break;
                    case LOGIC:     *(simb->vallogic) = *(opndaux.atr.simb->vallogic);  break;
                    case CHAR:      *(simb->valchar)  = *(opndaux.atr.simb->valchar);   break;
                }
        }
    }
}

/* 
    Retorno de procedimento/função
    - Coloca o valor a ser retornado em posição
    - Restaura o valor do PC e registradores
    - Desempilha registro de ativação
    */

void ExecQuadReturn (quadrupla quad, quadrupla *quadprox, modhead *mod) {
    int tipo1, valint1;
    float valfloat1;
    char valchar1, vallogic1;
    quadrupla quadCall, quadNext;

    // Restaura o valor do PC
    quadCall = TopoQuad(pilhaquads);
    DesempilharQuad (&pilhaquads);

    // Desaloca as variáveis do módulo
    DesalocaVariaveis (mod);

    // A linguagem não suporta recursividade
    (*mod)->modname->active = FALSE;

    // Faz as ligações de controle
    *mod = quadCall->modulo;
    *quadprox = quadCall->prox;
 
    // Retorno vazio ou chamada de procedimento:
    if (quad->opnd1.tipo == IDLEOPND || quadCall->result.tipo == IDLEOPND)
        return;

    // Coloca o valor a ser retornado em posição
    switch (quad->opnd1.tipo) {
        case INTOPND:   tipo1 = INTOPND;    valint1   = quad->opnd1.atr.valint;     break;
        case REALOPND:  tipo1 = REALOPND;   valfloat1 = quad->opnd1.atr.valfloat;   break;
        case CHAROPND:  tipo1 = CHAROPND;   valchar1  = quad->opnd1.atr.valchar;    break;
        case LOGICOPND: tipo1 = LOGICOPND;  vallogic1 = quad->opnd1.atr.vallogic;   break;
        case VAROPND:
            switch (quad->opnd1.atr.simb->tvar) {
                case INTEGER:   tipo1 = INTOPND;    valint1   = *(quad->opnd1.atr.simb->valint);    break;
                case FLOAT:     tipo1 = REALOPND;   valfloat1 = *(quad->opnd1.atr.simb->valfloat);  break;
                case CHAR:      tipo1 = CHAROPND;   valchar1  = *(quad->opnd1.atr.simb->valchar);   break;
                case LOGIC:     tipo1 = LOGICOPND;  vallogic1 = *(quad->opnd1.atr.simb->vallogic);  break;
            }
            break;
    }

    if (quadCall->result.tipo == VAROPND) {
        switch (quadCall->result.atr.simb->tvar) {
            case INTEGER:
                if (tipo1 == INTOPND)   *(quadCall->result.atr.simb->valint) = valint1;
                if (tipo1 == CHAROPND)  *(quadCall->result.atr.simb->valint) = valchar1;
                break;
            case CHAR:
                if (tipo1 == INTOPND)   *(quadCall->result.atr.simb->valchar) = valint1;
                if (tipo1 == CHAROPND)  *(quadCall->result.atr.simb->valchar) = valchar1;
                break;
            case LOGIC:                 *(quadCall->result.atr.simb->vallogic) = vallogic1; 
                break;
            case FLOAT:
                if (tipo1 == INTOPND)   *(quadCall->result.atr.simb->valfloat) = valint1;
                if (tipo1 == REALOPND)  *(quadCall->result.atr.simb->valfloat) = valfloat1;
                if (tipo1 == CHAROPND)  *(quadCall->result.atr.simb->valfloat) = valchar1;
                break;
        }
    }
}

/* Executa a quádrupla do CmdWrite */

void ExecQuadWrite (quadrupla quad) {
    int i;  operando opndaux;  pilhaoperando pilhaopndaux;

    if (DEBUG) printf ("\n\t\tEscrevendo: \n\n");
    InicPilhaOpnd (&pilhaopndaux);
    for (i = 1; i <= quad->opnd1.atr.valint; i++) {
        EmpilharOpnd (TopoOpnd (pilhaopnd), &pilhaopndaux);
        DesempilharOpnd (&pilhaopnd);
    }
    for (i = 1; i <= quad->opnd1.atr.valint; i++) {
        opndaux = TopoOpnd (pilhaopndaux);
        DesempilharOpnd (&pilhaopndaux);
        switch (opndaux.tipo) {
            case INTOPND:   printf ("%d", opndaux.atr.valint);              break;
            case REALOPND:  printf ("%g", opndaux.atr.valfloat);            break;
            case CHAROPND:  printf ("%c", opndaux.atr.valchar);             break;
            case LOGICOPND: printf ("%s", boolean[opndaux.atr.vallogic]);   break;
            case CADOPND:   printf ("%s", opndaux.atr.valcad);              break;
            case VAROPND:
                switch (opndaux.atr.simb->tvar) {
                    case INTEGER:   printf ("%d", *(opndaux.atr.simb->valint));             break;
                    case FLOAT:     printf ("%g", *(opndaux.atr.simb->valfloat));           break;
                    case LOGIC:     printf ("%s", boolean[*(opndaux.atr.simb->vallogic)]);  break;
                    case CHAR:      printf ("%c", *(opndaux.atr.simb->valchar));            break;
                }
        }
    }
}

/* Executa a quádrupla dos operadores aritméticos */

void ExecQuadAritmetica (quadrupla quad) {
    int tipo1, tipo2, valint1, valint2;
    float valfloat1, valfloat2;
    switch (quad->opnd1.tipo) {
        case INTOPND:   tipo1 = INTOPND;    valint1   = quad->opnd1.atr.valint;       break;
        case REALOPND:  tipo1 = REALOPND;   valfloat1 = quad->opnd1.atr.valfloat;     break;
        case CHAROPND:  tipo1 = INTOPND;    valint1   = quad->opnd1.atr.valchar;      break;
        case VAROPND:
            switch (quad->opnd1.atr.simb->tvar) {
                case INTEGER:   tipo1 = INTOPND;    valint1   = *(quad->opnd1.atr.simb->valint);      break;
                case FLOAT:     tipo1 = REALOPND;   valfloat1 = *(quad->opnd1.atr.simb->valfloat);    break;
                case CHAR:      tipo1 = INTOPND;    valint1   = *(quad->opnd1.atr.simb->valchar);     break;
            }
            break;
    }
    switch (quad->opnd2.tipo) {
        case INTOPND:   tipo2 = INTOPND;    valint2   = quad->opnd2.atr.valint;       break;
        case REALOPND:  tipo2 = REALOPND;   valfloat2 = quad->opnd2.atr.valfloat;     break;
        case CHAROPND:  tipo2 = INTOPND;    valint2   = quad->opnd2.atr.valchar;      break;
        case VAROPND:
            switch (quad->opnd2.atr.simb->tvar) {
                case INTEGER:   tipo2 = INTOPND;    valint2   = *(quad->opnd2.atr.simb->valint);      break;
                case FLOAT:     tipo2 = REALOPND;   valfloat2 = *(quad->opnd2.atr.simb->valfloat);    break;
                case CHAR:      tipo2 = INTOPND;    valint2   = *(quad->opnd2.atr.simb->valchar);     break;
            }
            break;
    }
    if (quad->result.tipo == VAROPND) {
        switch (quad->result.atr.simb->tvar) {
            case INTEGER:
                switch (quad->oper) {
                    case OPMAIS :   *(quad->result.atr.simb->valint) = valint1 + valint2;   break;
                    case OPMENOS:   *(quad->result.atr.simb->valint) = valint1 - valint2;   break;
                    case OPMULT :   *(quad->result.atr.simb->valint) = valint1 * valint2;   break;
                    case OPDIV  :   if (valint2 == 0) RunTimeException(EXCEPTION_DIVZERO);
                                    *(quad->result.atr.simb->valint) = valint1 / valint2;   break;
                }
                break;
            case FLOAT:
                if (tipo1 == INTOPND && tipo2 == INTOPND)
                    switch (quad->oper) {
                        case OPMAIS :   *(quad->result.atr.simb->valfloat) = valint1 + valint2; break;
                        case OPMENOS:   *(quad->result.atr.simb->valfloat) = valint1 - valint2; break;
                        case OPMULT :   *(quad->result.atr.simb->valfloat) = valint1 * valint2; break;
                        case OPDIV  :   if (valint2 == 0) RunTimeException(EXCEPTION_DIVZERO);
                                        *(quad->result.atr.simb->valfloat) = valint1 / valint2; break;
                    }
                if (tipo1 == INTOPND && tipo2 == REALOPND)
                    switch (quad->oper) {
                        case OPMAIS :   *(quad->result.atr.simb->valfloat) = valint1 + valfloat2;   break;
                        case OPMENOS:   *(quad->result.atr.simb->valfloat) = valint1 - valfloat2;   break;
                        case OPMULT :   *(quad->result.atr.simb->valfloat) = valint1 * valfloat2;   break;
                        case OPDIV  :   if (valfloat2 == 0) RunTimeException(EXCEPTION_DIVZERO);
                                        *(quad->result.atr.simb->valfloat) = valint1 / valfloat2;   break;
                    }
                if (tipo1 == REALOPND && tipo2 == INTOPND)
                    switch (quad->oper) {
                        case OPMAIS :   *(quad->result.atr.simb->valfloat) = valfloat1 + valint2;   break;
                        case OPMENOS:   *(quad->result.atr.simb->valfloat) = valfloat1 - valint2;   break;
                        case OPMULT :   *(quad->result.atr.simb->valfloat) = valfloat1 * valint2;   break;
                        case OPDIV  :   if (valint2 == 0) RunTimeException(EXCEPTION_DIVZERO);
                                        *(quad->result.atr.simb->valfloat) = valfloat1 / valint2;   break;
                    }
                if (tipo1 == REALOPND && tipo2 == REALOPND)
                    switch (quad->oper) {
                        case OPMAIS :   *(quad->result.atr.simb->valfloat) = valfloat1 + valfloat2; break;
                        case OPMENOS:   *(quad->result.atr.simb->valfloat) = valfloat1 - valfloat2; break;
                        case OPMULT :   *(quad->result.atr.simb->valfloat) = valfloat1 * valfloat2; break;
                        case OPDIV  :   if (valfloat2 == 0) RunTimeException(EXCEPTION_DIVZERO);
                                        *(quad->result.atr.simb->valfloat) = valfloat1 / valfloat2; break;
                    }
                break;
        }
    }
}

/* Executa a quádrupla do operador resto */

void ExecQuadResto (quadrupla quad) {
    int valint1, valint2;
    switch (quad->opnd1.tipo) {
        case INTOPND:   valint1 = quad->opnd1.atr.valint;       break;
        case CHAROPND:  valint1 = quad->opnd1.atr.valchar;      break;
        case VAROPND:
            switch (quad->opnd1.atr.simb->tvar) {
                case INTEGER:   valint1 = *(quad->opnd1.atr.simb->valint);      break;
                case CHAR:      valint1 = *(quad->opnd1.atr.simb->valchar);     break;
            }
            break;
    }
    switch (quad->opnd2.tipo) {
        case INTOPND:   valint2 = quad->opnd2.atr.valint;       break;
        case CHAROPND:  valint2 = quad->opnd2.atr.valchar;      break;
        case VAROPND:
            switch (quad->opnd2.atr.simb->tvar) {
                case INTEGER:   valint2 = *(quad->opnd2.atr.simb->valint);      break;
                case CHAR:      valint2 = *(quad->opnd2.atr.simb->valchar);     break;
            }
            break;
    }
    switch (quad->result.atr.simb->tvar) {
        case INTEGER:   if (valint2 == 0) RunTimeException(EXCEPTION_DIVZERO);
                        *(quad->result.atr.simb->valint) = valint1 % valint2;   break;
    }
}

/* Executa a quádrupla do operador menos unário */

void ExecQuadMenun (quadrupla quad) {
    int valint;
    float valfloat;
    switch (quad->opnd1.tipo) {
        case INTOPND:   valint = quad->opnd1.atr.valint;       break;
        case REALOPND:  valfloat = quad->opnd1.atr.valfloat;   break;
        case CHAROPND:  valint = quad->opnd1.atr.valchar;      break;
        case VAROPND:
            switch (quad->opnd1.atr.simb->tvar) {
                case INTEGER:   valint = *(quad->opnd1.atr.simb->valint);      break;
                case FLOAT:     valfloat = *(quad->opnd1.atr.simb->valfloat);  break;
                case CHAR:      valint = *(quad->opnd1.atr.simb->valchar);     break;
            }
            break;
    }
    switch (quad->result.atr.simb->tvar) {
        case INTEGER:   *(quad->result.atr.simb->valint) = valint * (-1);       break;
        case FLOAT:     *(quad->result.atr.simb->valfloat) = valfloat * (-1);   break;
    }
}

/* Executa a quádrupla do operador Not */

void ExecQuadNot (quadrupla quad) {
    bool vallogic;
    switch (quad->opnd1.tipo) {
        case LOGICOPND: vallogic = quad->opnd1.atr.vallogic; break;
        case VAROPND:
            if (quad->opnd1.atr.simb->tvar == LOGIC)
                vallogic = *(quad->opnd1.atr.simb->vallogic);
            break;
    }
    if (quad->result.tipo == VAROPND) {
        switch (quad->result.atr.simb->tvar) {
            case LOGIC: *(quad->result.atr.simb->vallogic) = !vallogic; break;
        }
    }
}


/* Executa a quádrupla dos operadores And e Or */

void ExecQuadAndOr (quadrupla quad) {
    bool vallogic1, vallogic2;

    switch (quad->opnd1.tipo) {
        case LOGICOPND: vallogic1 = quad->opnd1.atr.vallogic;  break;
        case VAROPND:
            if (quad->opnd1.atr.simb->tvar == LOGIC)
                vallogic1 = *(quad->opnd1.atr.simb->vallogic);
            break;
    }
    switch (quad->opnd2.tipo) {
        case LOGICOPND: vallogic2 = quad->opnd2.atr.vallogic;   break;
        case VAROPND:   
            if (quad->opnd2.atr.simb->tvar == LOGIC)
                vallogic2 = *(quad->opnd2.atr.simb->vallogic);
            break;
    }
    switch (quad->result.atr.simb->tvar) {
        case LOGIC: 
            switch (quad->oper) {
                case OPAND: *(quad->result.atr.simb->vallogic) = vallogic1 && vallogic2;    break;      
                case OPOR : *(quad->result.atr.simb->vallogic) = vallogic1 || vallogic2;    break;  
            }
            break;
    }
}

/* Executa a quádrupla do operador index */

void ExecQuadIndex (quadrupla quad) {
    int i;
    operando indexaux;  pilhaoperando pilhaindexaux;
    // Inverte a pilha colocando na ordem certa
    InicPilhaOpnd (&pilhaindexaux);
    for (i = 1; i <= quad->opnd2.atr.valint; i++) {
        EmpilharOpnd (TopoOpnd (pilhaindex), &pilhaindexaux);
        DesempilharOpnd (&pilhaindex);
    }

    // Acessa a posição desejada do vetor
    int index, proxDim, offset = 0;
    for (i = 1; i <= quad->opnd2.atr.valint; i++) {
        if (i < quad->opnd1.atr.simb->ndims)
            proxDim = quad->opnd1.atr.simb->dims[i];
        else proxDim = 1;
        indexaux = TopoOpnd(pilhaindexaux);
        if (indexaux.tipo == VAROPND) 
            index = *(indexaux.atr.simb->valint);
        else index = indexaux.atr.valint;
        offset = proxDim*(offset + index);
        DesempilharOpnd (&pilhaindexaux);
    }
    
    // O resultado recebe o endereço da posição da matriz
    switch (quad->opnd1.atr.simb->tvar) {
        case INTEGER: quad->result.atr.simb->valint   = quad->opnd1.atr.simb->valint   + offset;  break;
        case FLOAT  : quad->result.atr.simb->valfloat = quad->opnd1.atr.simb->valfloat + offset;  break;
        case CHAR   : quad->result.atr.simb->valchar  = quad->opnd1.atr.simb->valchar  + offset;  break;
        case LOGIC  : quad->result.atr.simb->vallogic = quad->opnd1.atr.simb->vallogic + offset;  break;
    }
}

/* Executa a quádrupla do operador de atribuição */

void ExecQuadAtrib (quadrupla quad) {
    int tipo1, valint1; 
    float valfloat1;
    char valchar1, vallogic1;

    switch (quad->opnd1.tipo) {
        case INTOPND:   tipo1 = INTOPND;    valint1   = quad->opnd1.atr.valint;     break;
        case REALOPND:  tipo1 = REALOPND;   valfloat1 = quad->opnd1.atr.valfloat;   break;
        case CHAROPND:  tipo1 = CHAROPND;   valchar1  = quad->opnd1.atr.valchar;    break;
        case LOGICOPND: tipo1 = LOGICOPND;  vallogic1 = quad->opnd1.atr.vallogic;   break;
        case VAROPND:
            switch (quad->opnd1.atr.simb->tvar) {
                case INTEGER:   tipo1 = INTOPND;    valint1   = *(quad->opnd1.atr.simb->valint);    break;
                case FLOAT:     tipo1 = REALOPND;   valfloat1 = *(quad->opnd1.atr.simb->valfloat);  break;
                case CHAR:      tipo1 = CHAROPND;   valchar1  = *(quad->opnd1.atr.simb->valchar);   break;
                case LOGIC:     tipo1 = LOGICOPND;  vallogic1 = *(quad->opnd1.atr.simb->vallogic);  break;
            }
            break;
    }

    switch (quad->result.atr.simb->tvar) {
        case INTEGER:
            if (tipo1 == INTOPND)   *(quad->result.atr.simb->valint) = valint1;
            if (tipo1 == CHAROPND)  *(quad->result.atr.simb->valint) = valchar1;
            break;
        case CHAR:
            if (tipo1 == INTOPND)   *(quad->result.atr.simb->valchar) = valint1;
            if (tipo1 == CHAROPND)  *(quad->result.atr.simb->valchar) = valchar1;
            break;
        case LOGIC:                 *(quad->result.atr.simb->vallogic) = vallogic1; 
            break;
        case FLOAT:
            if (tipo1 == INTOPND)   *(quad->result.atr.simb->valfloat) = valint1;
            if (tipo1 == REALOPND)  *(quad->result.atr.simb->valfloat) = valfloat1;
            if (tipo1 == CHAROPND)  *(quad->result.atr.simb->valfloat) = valchar1;
            break;
    }
}

/* Executa a quádrupla de operadores relacionais */

void ExecQuadRel (quadrupla quad) {
    int tipo1, tipo2, valint1, valint2;
    float valfloat1, valfloat2;

    switch (quad->opnd1.tipo) {
        case INTOPND:   tipo1 = INTOPND;    valint1   = quad->opnd1.atr.valint;     break;
        case REALOPND:  tipo1 = REALOPND;   valfloat1 = quad->opnd1.atr.valfloat;   break;
        case CHAROPND:  tipo1 = INTOPND;    valint1   = quad->opnd1.atr.valchar;    break;
        case VAROPND:
            switch (quad->opnd1.atr.simb->tvar) {
                case INTEGER:   tipo1 = INTOPND;    valint1   = *(quad->opnd1.atr.simb->valint);      break;
                case FLOAT:     tipo1 = REALOPND;   valfloat1 = *(quad->opnd1.atr.simb->valfloat);    break;
                case CHAR:      tipo1 = INTOPND;    valint1   = *(quad->opnd1.atr.simb->valchar);     break;
            }
            break;
    }
    switch (quad->opnd2.tipo) {
        case INTOPND:   tipo2 = INTOPND;    valint2   = quad->opnd2.atr.valint;       break;
        case REALOPND:  tipo2 = REALOPND;   valfloat2 = quad->opnd2.atr.valfloat;     break;
        case CHAROPND:  tipo2 = INTOPND;    valint2   = quad->opnd2.atr.valchar;      break;
        case VAROPND:
            switch (quad->opnd2.atr.simb->tvar) {
                case INTEGER:   tipo2 = INTOPND;    valint2   = *(quad->opnd2.atr.simb->valint);      break;
                case FLOAT:     tipo2 = REALOPND;   valfloat2 = *(quad->opnd2.atr.simb->valfloat);    break;
                case CHAR:      tipo2 = INTOPND;    valint2   = *(quad->opnd2.atr.simb->valchar);     break;
                }
            break;
    }
    if (tipo1 == INTOPND && tipo2 == INTOPND)
        switch (quad->oper) {
            case OPLE:  *(quad->result.atr.simb->vallogic) = valint1 <= valint2;    break;      
            case OPGT:  *(quad->result.atr.simb->vallogic) = valint1 >  valint2;    break;     
            case OPGE:  *(quad->result.atr.simb->vallogic) = valint1 >= valint2;    break;     
            case OPEQ:  *(quad->result.atr.simb->vallogic) = valint1 == valint2;    break;      
            case OPNE:  *(quad->result.atr.simb->vallogic) = valint1 != valint2;    break; 
            case OPLT:  *(quad->result.atr.simb->vallogic) = valint1 <  valint2;    break;
        }
    if (tipo1 == INTOPND && tipo2 == REALOPND)
        switch (quad->oper) {
            case OPLE:  *(quad->result.atr.simb->vallogic) = valint1 <= valfloat2;   break;      
            case OPGT:  *(quad->result.atr.simb->vallogic) = valint1 >  valfloat2;   break;       
            case OPGE:  *(quad->result.atr.simb->vallogic) = valint1 >= valfloat2;   break;    
            case OPEQ:  *(quad->result.atr.simb->vallogic) = valint1 == valfloat2;   break;      
            case OPNE:  *(quad->result.atr.simb->vallogic) = valint1 != valfloat2;   break; 
            case OPLT:  *(quad->result.atr.simb->vallogic) = valint1 <  valfloat2;   break;
        }
    if (tipo1 == REALOPND && tipo2 == INTOPND)
        switch (quad->oper) {
            case OPLE:  *(quad->result.atr.simb->vallogic) = valfloat1 <= valint2;   break;      
            case OPGT:  *(quad->result.atr.simb->vallogic) = valfloat1 >  valint2;   break;      
            case OPGE:  *(quad->result.atr.simb->vallogic) = valfloat1 >= valint2;   break;     
            case OPEQ:  *(quad->result.atr.simb->vallogic) = valfloat1 == valint2;   break;      
            case OPNE:  *(quad->result.atr.simb->vallogic) = valfloat1 != valint2;   break; 
            case OPLT:  *(quad->result.atr.simb->vallogic) = valfloat1 <  valint2;   break;
        }
    if (tipo1 == REALOPND && tipo2 == REALOPND)
        switch (quad->oper) {
            case OPLE:  *(quad->result.atr.simb->vallogic) = valfloat1 <= valfloat2; break;      
            case OPGT:  *(quad->result.atr.simb->vallogic) = valfloat1 >  valfloat2; break;     
            case OPGE:  *(quad->result.atr.simb->vallogic) = valfloat1 >= valfloat2; break;     
            case OPEQ:  *(quad->result.atr.simb->vallogic) = valfloat1 == valfloat2; break;     
            case OPNE:  *(quad->result.atr.simb->vallogic) = valfloat1 != valfloat2; break; 
            case OPLT:  *(quad->result.atr.simb->vallogic) = valfloat1 <  valfloat2; break;
        }
}

/* Executa a quádrupla do operador de leitura */

void ExecQuadRead (quadrupla quad) {
    int i;  operando opndaux;  pilhaoperando pilhaopndaux, pilhaindex;

    if (finput == NULL)
        RunTimeException(EXCEPTION_INPUTFILE);

    if (DEBUG) printf ("\n\t\tLendo: \n");
    InicPilhaOpnd (&pilhaopndaux);
    for (i = 1; i <= quad->opnd1.atr.valint; i++) {
        EmpilharOpnd (TopoOpnd (pilhaopnd), &pilhaopndaux);
        DesempilharOpnd (&pilhaopnd);
    }
    for (i = 1; i <= quad->opnd1.atr.valint; i++) {
        opndaux = TopoOpnd (pilhaopndaux);
        DesempilharOpnd (&pilhaopndaux);
        int check;
        switch (opndaux.atr.simb->tvar) {
            case INTEGER:   
                if (fscanf (finput, "%d", opndaux.atr.simb->valint) != TRUE)
                    RunTimeException(EXCEPTION_READFILE);  break;
            case FLOAT:
                if (fscanf (finput, "%g", opndaux.atr.simb->valfloat) != TRUE)
                    RunTimeException(EXCEPTION_READFILE);  break;  
            case LOGIC: 
                if (fscanf (finput, "%d", opndaux.atr.simb->vallogic) != TRUE)
                    RunTimeException(EXCEPTION_READFILE);  break;   
            case CHAR: 
                if (fscanf (finput, "%c", opndaux.atr.simb->valchar) != TRUE)
                    RunTimeException(EXCEPTION_READFILE);  break;     
        }
    }
}

/* Executa a quádrupla do operador jump condicional/incondicional */

void ExecQuadJump (quadrupla quad, quadrupla *quadprox) {
    bool condicao = FALSE;
    switch (quad->oper) {
        case OPJUMP:    *quadprox = quad->result.atr.rotulo;    break;
        case OPJF: case OPJT:
            if (quad->opnd1.tipo == LOGICOPND)
                condicao = quad->opnd1.atr.vallogic;
            if (quad->opnd1.tipo == VAROPND)
                condicao = *(quad->opnd1.atr.simb->vallogic);
            switch (quad->oper) {
                case OPJT:  if (condicao == TRUE)   *quadprox = quad->result.atr.rotulo;    break;
                case OPJF:  if (condicao == FALSE)  *quadprox = quad->result.atr.rotulo;    break;
            }
            break;
    }
}

/****************************************************/
/*                                                  */
/*       Implementação de Pilha de Operandos        */
/*                                                  */
/****************************************************/

/* Inicializa uma nova pilha de operandos */

void InicPilhaOpnd (pilhaoperando *P) { 
    *P = NULL;
}

/* Verifica se a pilha de operandos está vazia */

char VaziaOpnd (pilhaoperando P) {
    if  (P == NULL)  return 1;  
    else return 0; 
}

/* Empilha operando na pilha de operandos */

void EmpilharOpnd (operando x, pilhaoperando *P) {
    nohopnd *temp;
    temp = *P;   
    *P = (nohopnd *) malloc (sizeof (nohopnd));
    (*P)->opnd = x; (*P)->prox = temp;
}

/* Desempilha operando na pilha de operandos */

void DesempilharOpnd (pilhaoperando *P) {
    nohopnd *temp;
    if (! VaziaOpnd (*P)) {
        temp = *P;  *P = (*P)->prox; free (temp);
    }
    else  printf ("\n\tDelecao em pilha vazia\n");
}

/* Retorna operando no topo da pilha de operandos */

operando TopoOpnd (pilhaoperando P) {
    if (! VaziaOpnd (P))  return P->opnd;
    else  printf ("\n\tTopo de pilha vazia\n");
}

/****************************************************/
/*                                                  */
/*       Implementação de Pilha de Quádruplas       */
/*                                                  */
/****************************************************/

/* Inicializa uma nova pilha de quádruplas */

void InicPilhaQuad (pilhaquadruplas *P) { 
    *P = NULL;
}

/* Verifica se a pilha de quádruplas está vazia */

char VaziaQuad (pilhaquadruplas P) {
    if  (P == NULL)  return 1;  
    else return 0; 
}

/* Empilha operando na pilha de quádruplas */

void EmpilharQuad (quadrupla x, pilhaquadruplas *P) {
    nohquad *temp;
    temp = *P;   
    *P = (nohquad *) malloc (sizeof (nohquad));
    (*P)->quad = x; (*P)->prox = temp;
}

/* Desempilha operando na pilha de quádruplas */

void DesempilharQuad (pilhaquadruplas *P) {
    nohquad *temp;
    if (! VaziaQuad (*P)) {
        temp = *P;  *P = (*P)->prox; free (temp);
    }
    else  printf ("\n\tDelecao em pilha vazia\n");
}

/* Retorna operando no topo da pilha de quádruplas */

quadrupla TopoQuad (pilhaquadruplas P) {
    if (! VaziaQuad (P))  return P->quad;
    else  printf ("\n\tTopo de pilha vazia\n");
}

/*  Mensagens de Run Time Exception */

void RunTimeException (char *error) {
    printf ("\n\n***** RunTimeException<>: %s *****\n", error);
    exit(0);
}
