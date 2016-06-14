%{
/* Inclusao de arquivos da biblioteca de C */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Definicao dos atributos dos atomos operadores */

#define 	LT 		1
#define 	LE 		2
#define		GT		3
#define		GE		4
#define		EQ		5
#define		NE		6
#define		MAIS    7
#define		MENOS   8
#define		MULT    9
#define		DIV   	10
#define		RESTO   11

/*   Definicao dos tipos de identificadores   */

#define 	IDPROG		1
#define 	IDVAR		2
#define 	IDFUNC		3
#define 	IDGLOB		4

/*  Definicao dos tipos de variaveis   */

#define 	NOTVAR		0
#define 	INTEGER		1
#define 	LOGIC		2
#define 	FLOAT		3
#define 	CHAR		4

/*  Definicao de constantes para os operadores de quadruplas */

#define		OPOR			1
#define		OPAND	 		2
#define 	OPLT	 		3
#define 	OPLE	 		4
#define		OPGT		    5
#define		OPGE			6
#define		OPEQ			7
#define		OPNE			8
#define		OPMAIS		    9
#define		OPMENOS		    10
#define		OPMULTIP		11
#define		OPDIV			12
#define		OPRESTO		    13
#define		OPMENUN		    14
#define		OPNOT			15
#define		OPATRIB		    16
#define		OPENMOD		    17
#define		NOP			    18
#define		OPJUMP		    19
#define		OPJF			20
#define		PARAM			21
#define		OPREAD		    22
#define		OPWRITE		    23
#define		OPEXIT		    24

/* Definicao de constantes para os tipos de operandos de quadruplas */

#define		IDLEOPND		0
#define		VAROPND		    1
#define		INTOPND		    2
#define		REALOPND		3
#define		CHAROPND		4
#define		LOGICOPND	    5
#define		CADOPND		    6
#define		ROTOPND		    7
#define		MODOPND		    8

/*   Definicao de outras constantes   */

#define	    NCLASSHASH	    23
#define	    TRUE		    1
#define	    FALSE		    0
#define     MAXDIMS		    10

/*  Strings para verdade e falso */

char *boolean[2] = {"FALSO", "VERDADE"};

/*  Strings para nomes dos tipos de identificadores  */

char *nometipid[5] = {" ", "IDPROG", "IDVAR", "IDFUNC", "IDGLOB"};

/*  Strings para nomes dos tipos de variaveis  */

char *nometipvar[5] = {"NOTVAR",
	"INTEGER", "LOGIC", "FLOAT", "CHAR"
};

/* Strings para operadores de quadruplas */

char *nomeoperquad[25] = {"",
	"OR", "AND", "LT", "LE", "GT", "GE", "EQ", "NE", "MAIS",
	"MENOS", "MULT", "DIV", "RESTO", "MENUN", "NOT", "ATRIB",
	"OPENMOD", "NOP", "JUMP", "JF", "PARAM", "READ", "WRITE",
	"EXIT"
};

/* Strings para tipos de operandos de quadruplas */

char *nometipoopndquad[9] = {"IDLE",
	"VAR", "INT", "REAL", "CARAC", "LOGIC", "CADEIA", "ROTULO", "MODULO"
};

/*    Declaracoes para a tabela de simbolos     */

typedef struct celsimb celsimb;
typedef celsimb *simbolo;
struct celsimb {
	char *cadeia;
	int tid, tvar, ndims, dims[MAXDIMS+1];
	char inic, ref, array;
	simbolo prox;
	int *valint;
	float *valfloat;
  	char *valchar, *vallogic;
};

/*  Variaveis globais para a tabela de simbolos e analise semantica
 */

simbolo tabsimb[NCLASSHASH];
simbolo simb;
int tipocorrente;

/*
	Prototipos das funcoes para a tabela de simbolos
    	e analise semantica
 */

void InicTabSimb (void);
void ImprimeTabSimb (void);
simbolo InsereSimb (char *, int, int);
int hash (char *);
simbolo ProcuraSimb (char *);
void DeclaracaoRepetida (char *);
void TipoInadequado (char *);
void NaoDeclarado (char *);
void Incompatibilidade (char *);
void Esperado (char *);
void NaoEsperado (char *);
void VerificaInicRef (void);

/* Declaracoes para a estrutura do codigo intermediario */

typedef union atribopnd atribopnd;
typedef struct operando operando;
typedef struct celquad celquad;
typedef celquad *quadrupla;
typedef struct celmodhead celmodhead;
typedef celmodhead *modhead;

union atribopnd {
	simbolo simb; int valint; float valfloat;
	char valchar; char vallogic; char *valcad;
	quadrupla rotulo; modhead modulo;
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

quadrupla quadcorrente, quadaux;
modhead codintermed, modcorrente;
int oper, numquadcorrente;
operando opnd1, opnd2, result, opndaux;
int numtemp;
const operando opndidle = {IDLEOPND, 0};

/* Prototipos das funcoes para o codigo intermediario */

void InicCodIntermed (void);
void InicCodIntermMod (simbolo);
void ImprimeQuadruplas (void);
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

/* Prototipos das funcoes para o interpretador */

void InterpCodIntermed (void);
void AlocaVariaveis (void);
void ExecQuadWrite (quadrupla);
void ExecQuadMais (quadrupla);
void ExecQuadLT (quadrupla);
void ExecQuadAtrib (quadrupla);
void ExecQuadRead (quadrupla);

/*	Declaracoes para pilhas de operandos  */

typedef struct nohopnd nohopnd;
struct nohopnd {
	operando opnd;
	nohopnd *prox;
};
typedef nohopnd *pilhaoperando;
pilhaoperando pilhaopnd;

/*  Prototipos das funcoes para pilhas de operandos  */

void EmpilharOpnd (operando, pilhaoperando *);
void DesempilharOpnd (pilhaoperando *);
operando TopoOpnd (pilhaoperando);
void InicPilhaOpnd (pilhaoperando *);
char VaziaOpnd (pilhaoperando);

FILE *finput;

%}

/* Definicao do tipo de yylval e dos atributos dos nao terminais */

%union {
	char cadeia[50];
	int atr, valint;
	float valreal;
	char carac;
	simbolo simb;
	infoexpressao infoexpr;
	infovariavel infovar;
	int nsubscr, nargs;
	quadrupla quad;
}

/* Declaracao dos atributos dos tokens e dos nao-terminais */

%type	    <infovar>	        Variavel
%type 	    <infoexpr> 	    Expressao  ExprAux1  ExprAux2
                            ExprAux3   ExprAux4   Termo   Fator
                            ElemEscr
%type       <nsubscr>       ListSubscr
%type       <nargs>		    ListLeit   ListEscr
%token		<cadeia>		ID
%token		<carac>		    CTCARAC
%token		<valint>		CTINT
%token		<valreal>	    CTREAL
%token		<cadeia>		CADEIA
%token		OR
%token		AND
%token		NOT
%token		<atr>			OPREL
%token		<atr>			OPAD
%token		<atr>			OPMULT
%token		NEG
%token		ABPAR
%token		FPAR
%token		ABCOL
%token		FCOL
%token		ABCHAVE
%token		FCHAVE
%token		VIRG
%token		PVIRG
%token		DPONTS
%token		ATRIB
%token		CARAC
%token		COMANDOS
%token		ENQUANTO
%token		ESCREVER
%token		FALSO
%token		INT
%token		LER
%token		LOCAIS
%token		LOGICO
%token		REAL
%token		SE
%token		SENAO
%token		VERDADE
%token		<carac>         INVAL
%%

/* Producoes da gramatica:

	Os terminais sao escritos e, depois de alguns,
	para alguma estetica, ha mudanca de linha       */

Programa		:   {InicTabSimb (); InicCodIntermed (); numtemp = 0;}
                    ID  ABCHAVE  {
                        printf ("%s {\n", $2);
                        simb = InsereSimb ($2, IDPROG, NOTVAR);
                        InicCodIntermMod (simb);
                        opnd1.tipo = MODOPND;
                        opnd1.atr.modulo = modcorrente;
                        GeraQuadrupla (OPENMOD, opnd1, opndidle, opndidle);
                    }
                    DeclLocs  Cmds  FCHAVE  {
                        printf ("}\n");
                        GeraQuadrupla (OPEXIT, opndidle, opndidle, opndidle);
                        VerificaInicRef ();
                        ImprimeTabSimb (); ImprimeQuadruplas ();
                        InterpCodIntermed ();
                    }
                ;
DeclLocs		:
				|   LOCAIS  DPONTS  {printf ("locais :\n");}  ListDecl
				;
ListDecl		:   Declaracao
				|   ListDecl  Declaracao
				;
Declaracao	    :   Tipo  ListElemDecl  PVIRG  {printf (";\n");}
				;
Tipo			:   INT  {printf ("int "); tipocorrente = INTEGER;}
				|   REAL  {printf ("real "); tipocorrente = FLOAT;}
                |   CARAC  {printf ("carac "); tipocorrente = CHAR;}
                |   LOGICO  {printf ("logico "); tipocorrente = LOGIC;}
				;
ListElemDecl    :   ElemDecl
				|   ListElemDecl  VIRG  {printf (", ");}  ElemDecl
				;
ElemDecl  	    :	ID  {
                        printf ("%s ", $1);
                        if  (ProcuraSimb ($1) != NULL)
                            DeclaracaoRepetida ($1);
                        else {
                            simb = InsereSimb ($1, IDVAR, tipocorrente);
                            simb->array = FALSE; simb->ndims = 0;
                        }
                    }  ListDims
				;
ListDims		:
				|   ListDims  Dimensao  {
                        simb->array = TRUE;
                    }
                ;
Dimensao		:	ABCOL  CTINT  FCOL  {
                        printf ("[ %d ] ", $2);
                        if ($2 <= 0) Esperado ("Valor inteiro positivo");
                        simb->ndims++; simb->dims[simb->ndims] = $2;
                    }
				;
Cmds			:   COMANDOS  DPONTS  {printf ("comandos :\n");}
                    ListCmds
				;
ListCmds		:   Comando
				|   ListCmds  Comando
				;
Comando  	    :   CmdComposto
				|   CmdSe
                |   CmdEnquanto
                |   CmdLer
                |   CmdEscrever
                |   CmdAtrib
				;
CmdComposto	    :   ABCHAVE  {printf ("{\n");}  ListCmds
                    FCHAVE  {printf ("}\n");}
				;
CmdSe			:   SE  ABPAR  {printf ("se ( ");}  Expressao  {
                        if ($4.tipo != LOGIC)
                            Incompatibilidade ("Expressao de tipo improprio para comando condicional");
                        opndaux.tipo = ROTOPND;
                        $<quad>$ = GeraQuadrupla (OPJF, $4.opnd, opndidle, opndaux);
                    }
                    FPAR  {printf (")\n");}  Comando  {
                        $<quad>$ = quadcorrente;
                        $<quad>5->result.atr.rotulo =
                            GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }  CmdSenao {
                        if ($<quad>9->prox != quadcorrente) {
                            quadaux = $<quad>9->prox;
                        	$<quad>9->prox = quadaux->prox;
                        	quadaux->prox = $<quad>9->prox->prox;
                        	$<quad>9->prox->prox = quadaux;
                        	RenumQuadruplas ($<quad>9, quadcorrente);
                        }
                    }
				;
CmdSenao		:
				|   SENAO  {
                        printf ("senao ");
                        opndaux.tipo = ROTOPND;
                        $<quad>$ = GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
                    }  Comando  {
                        $<quad>2->result.atr.rotulo =
                            GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }
				;
CmdEnquanto	    :   ENQUANTO  ABPAR  {
                        printf ("enquanto ( ");
                        $<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }
                    Expressao  {
                        if ($4.tipo != LOGIC)
                            Incompatibilidade ("Expressao de tipo improprio para comando enquanto");
                        opndaux.tipo = ROTOPND;
                        $<quad>$ = GeraQuadrupla (OPJF, $4.opnd, opndidle, opndaux);
                    }
                    FPAR  {printf (")\n");}   Comando  {
                        opndaux.tipo = ROTOPND;
                        opndaux.atr.rotulo = $<quad>3;
                        GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
                        $<quad>5->result.atr.rotulo = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }
				;
CmdLer		    :   LER  ABPAR  {printf ("ler ( ");}  ListLeit  {
                        opnd1.tipo = INTOPND;
                        opnd1.atr.valint = $4;
                        GeraQuadrupla (OPREAD, opnd1, opndidle, opndidle);
                    }  FPAR  PVIRG  {printf (") ;\n");}
				;
ListLeit		:   Variavel  {
                        if ($1.simb != NULL) $1.simb->inic = $1.simb->ref = TRUE;
                        $$ = 1;
                        GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                    }
                |   ListLeit  VIRG  {printf (", ");}  Variavel  {
                        if ($4.simb != NULL) $4.simb->inic = $4.simb->ref = TRUE;
                        $$ = $1 + 1;
                        GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                    }
				;
CmdEscrever	    :   ESCREVER  ABPAR  {printf ("escrever ( ");}  ListEscr  {
                        opnd1.tipo = INTOPND;
                        opnd1.atr.valint = $4;
                        GeraQuadrupla (OPWRITE, opnd1, opndidle, opndidle);
                    }  FPAR  PVIRG  {printf (") ;\n");}
				;
ListEscr		:   ElemEscr  {
                        $$ = 1;
                        GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                    }
                |   ListEscr  VIRG  {printf (", ");}  ElemEscr  {
                        $$ = $1 + 1;
                        GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                    }
				;
ElemEscr		:   CADEIA  {
                        printf ("\"%s\" ", $1);
                        $$.opnd.tipo = CADOPND;
                        $$.opnd.atr.valcad = malloc (strlen($1) + 1);
                        strcpy ($$.opnd.atr.valcad, $1);
                    }
                |   Expressao
				;
CmdAtrib  	    :   Variavel  {if ($1.simb != NULL) $1.simb->inic = $1.simb->ref = TRUE;}
                    ATRIB  {printf (":= ");}  Expressao
                    PVIRG  {
                        printf (";\n");
                        if ($1.simb != NULL)
                            if ((($1.simb->tvar == INTEGER || $1.simb->tvar == CHAR) &&
                                ($5.tipo == FLOAT || $5.tipo == LOGIC)) ||
                                ($1.simb->tvar == FLOAT && $5.tipo == LOGIC) ||
                                ($1.simb->tvar == LOGIC && $5.tipo != LOGIC))
                                Incompatibilidade ("Lado direito de comando de atribuicao improprio");
                                GeraQuadrupla (OPATRIB, $5.opnd, opndidle, $1.opnd);
                    }
				;
Expressao  	    :   ExprAux1
				|   Expressao  OR  {printf ("|| ");}  ExprAux1  {
                        if ($1.tipo != LOGIC || $4.tipo != LOGIC)
                            Incompatibilidade	("Operando improprio para OR");
                        $$.tipo = LOGIC;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        GeraQuadrupla (OPOR, $1.opnd, $4.opnd, $$.opnd);
                    }
				;
ExprAux1  	    :   ExprAux2
				|   ExprAux1  AND  {printf ("&& ");}  ExprAux2  {
                        if ($1.tipo != LOGIC || $4.tipo != LOGIC)
                            Incompatibilidade	("Operando improprio para AND");
                        $$.tipo = LOGIC;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        GeraQuadrupla (OPAND, $1.opnd, $4.opnd, $$.opnd);
                    }
				;
ExprAux2  	    :   ExprAux3
				|   NOT  {printf ("! ");}  ExprAux3  {
                        if ($3.tipo != LOGIC)
                            Incompatibilidade	("Operando improprio para NOT");
                        $$.tipo = LOGIC;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($3.tipo);
                        GeraQuadrupla (OPNOT, $3.opnd, opndidle, $$.opnd);
                    }
				;
ExprAux3  	    :   ExprAux4
				|   ExprAux4   OPREL   {
                        switch ($2) {
                            case LT: printf ("< "); break;
                            case LE: printf ("<= "); break;
                            case EQ: printf ("= "); break;
                            case NE: printf ("!= "); break;
                            case GT: printf ("> "); break;
                            case GE: printf (">= "); break;
                        }
            	 	}   ExprAux4  {
                        switch ($2) {
                            case LT: case LE: case GT: case GE:
                                if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR || $4.tipo != INTEGER && $4.tipo!=FLOAT && $4.tipo!=CHAR)
                                    Incompatibilidade	("Operando improprio para operador relacional");
                                break;
                            case EQ: case NE:
                                if (($1.tipo == LOGIC || $4.tipo == LOGIC) && $1.tipo != $4.tipo)
                                    Incompatibilidade ("Operando improprio para operador relacional");
                                break;
                        }
                        $$.tipo = LOGIC;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        switch ($2) {
                            case LT:
                                GeraQuadrupla (OPLT, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case LE:
                                GeraQuadrupla (OPLE, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case GT:
                                GeraQuadrupla (OPGT, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case GE:
                                GeraQuadrupla (OPGE, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case EQ:
                                GeraQuadrupla (OPEQ, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case NE:
                                GeraQuadrupla (OPNE, $1.opnd, $4.opnd, $$.opnd);
                                break;
                        }
                    }
				;
ExprAux4  	    :   Termo
				|   ExprAux4  OPAD  {
                        switch ($2) {
                            case MAIS: printf ("+ "); break;
                            case MENOS: printf ("- "); break;
                        }
         			}  Termo  {
                        if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR || $4.tipo != INTEGER && $4.tipo!=FLOAT && $4.tipo!=CHAR)
                            Incompatibilidade	("Operando improprio para operador aritmetico");
                        if ($1.tipo == FLOAT || $4.tipo == FLOAT) $$.tipo = FLOAT;
                        else $$.tipo = INTEGER;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        if ($2 == MAIS)
                            GeraQuadrupla (OPMAIS, $1.opnd, $4.opnd, $$.opnd);
                        else
                            GeraQuadrupla (OPMENOS, $1.opnd, $4.opnd, $$.opnd);

                    }
				;
Termo  		    :   Fator
				|   Termo  OPMULT   {
                        switch ($2) {
                            case MULT: printf ("* "); break;
                            case DIV: printf ("/ "); break;
                            case RESTO: printf ("%% "); break;
                        }
         			}  Fator  {
                        switch ($2) {
                            case MULT: case DIV:
                                if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR
                                    || $4.tipo != INTEGER && $4.tipo!=FLOAT && $4.tipo!=CHAR)
                Incompatibilidade ("Operando improprio para operador aritmetico");
                                if ($1.tipo == FLOAT || $4.tipo == FLOAT) $$.tipo = FLOAT;
                                else $$.tipo = INTEGER;
                                $$.opnd.tipo = VAROPND;
                                $$.opnd.atr.simb = NovaTemp ($$.tipo);
                                if ($2 == MULT)
                                    GeraQuadrupla   (OPMULTIP, $1.opnd, $4.opnd, $$.opnd);
                                else  GeraQuadrupla  (OPDIV, $1.opnd, $4.opnd, $$.opnd);
                                break;
                            case RESTO:
                                if ($1.tipo != INTEGER && $1.tipo != CHAR
                                    ||  $4.tipo != INTEGER && $4.tipo != CHAR)
                Incompatibilidade ("Operando improprio para operador resto");
                                $$.tipo = INTEGER;
                                $$.opnd.tipo = VAROPND;
                                $$.opnd.atr.simb = NovaTemp ($$.tipo);
                                GeraQuadrupla (OPRESTO, $1.opnd, $4.opnd, $$.opnd);
                                break;
                        }
                    }
				;
Fator			:   Variavel  {
                        if  ($1.simb != NULL)  {
                            $1.simb->ref  =  TRUE;
                            $$.tipo = $1.simb->tvar;
                            $$.opnd = $1.opnd;
                        }
                    }
				|   CTINT  {
                        printf ("%d ", $1); $$.tipo = INTEGER;
                        $$.opnd.tipo = INTOPND;
                        $$.opnd.atr.valint = $1;
                    }
                |   CTREAL  {
                        printf ("%g ", $1); $$.tipo = FLOAT;
                        $$.opnd.tipo = REALOPND;
                        $$.opnd.atr.valfloat = $1;
                    }
                |   CTCARAC  {
                        printf ("\'%c\' ", $1); $$.tipo = CHAR;
                        $$.opnd.tipo = CHAROPND;
                        $$.opnd.atr.valchar = $1;
                    }
                |   VERDADE  {
                        printf ("verdade "); $$.tipo = LOGIC;
                        $$.opnd.tipo = LOGICOPND;
                        $$.opnd.atr.vallogic = 1;
                    }
                |   FALSO  {
                        printf ("falso "); $$.tipo = LOGIC;
                        $$.opnd.tipo = LOGICOPND;
                        $$.opnd.atr.vallogic = 0;
                    }
                |   NEG  {printf ("~ ");}  Fator  {
                        if ($3.tipo != INTEGER && $3.tipo != FLOAT && $3.tipo != CHAR)
                            Incompatibilidade  ("Operando improprio para menos unario");
                        if ($3.tipo == FLOAT) $$.tipo = FLOAT;
                        else $$.tipo = INTEGER;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo);
                        GeraQuadrupla  (OPMENUN, $3.opnd, opndidle, $$.opnd);
                    }
                |   ABPAR  {printf ("( ");}  Expressao
                    FPAR   {
                        printf (") "); $$.tipo = $3.tipo; $$.opnd = $3.opnd;
                    }
				;
Variavel		:   ID  {
                        printf ("%s ", $1);
                        simb = ProcuraSimb ($1);
                        if (simb == NULL)   NaoDeclarado ($1);
                        else if (simb->tid != IDVAR)  TipoInadequado ($1);
                        $<simb>$ = simb;
                    }  ListSubscr  {
                        $$.simb = $<simb>2;
                        if ($$.simb != NULL) {
                            if ($$.simb->array == FALSE && $3 > 0)
                                NaoEsperado ("Subscrito\(s)");
                            else if ($$.simb->array == TRUE && $3 == 0)
                                Esperado ("Subscrito\(s)");
                            else if ($$.simb->ndims != $3)
                                Incompatibilidade ("Numero de subscritos incompativel com declaracao");
                            $$.opnd.tipo = VAROPND;
                            if ($3 == 0)
                                $$.opnd.atr.simb = $$.simb;
                        }
                    }
                ;
ListSubscr	    :   {$$ = 0;}
				|   ListSubscr  Subscrito  {$$ = $1 + 1;}
                ;
Subscrito	    :	ABCOL  {printf ("[ ");}
                    ExprAux4  FCOL  {
                        printf ("] ");
                        if ($3.tipo != INTEGER && $3.tipo != CHAR)
                            Incompatibilidade ("Tipo inadequado para subscrito");
                    }
                ;
%%

/* Inclusao do analisador lexico  */

#include "lex.yy.c"

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
	s->tid = tid;		s->tvar = tvar;
	s->inic = FALSE;	s->ref = FALSE;
	s->prox = aux;	return s;
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
                    if (s->array == TRUE) { int j;
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

void Esperado (char *s) {
	printf ("\n\n***** Esperado: %s *****\n\n", s);
}

void NaoEsperado (char *s) {
	printf ("\n\n***** Nao Esperado: %s *****\n\n", s);
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

/*
	Funcoes para o codigo intermediario
 */

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
	simb = InsereSimb (nometemp, IDVAR, tip);
	simb->inic = simb->ref = TRUE;
   simb->array = FALSE;
	return simb;
}

void ImprimeQuadruplas () {
	modhead p;
	quadrupla q;
	for (p = codintermed->prox; p != NULL; p = p->prox) {
		printf ("\n\nQuadruplas do modulo %s:\n", p->modname->cadeia);
		for (q = p->listquad->prox; q != NULL; q = q->prox) {
			printf ("\n\t%4d) %s", q->num, nomeoperquad[q->oper]);
			printf (", (%s", nometipoopndquad[q->opnd1.tipo]);
			switch (q->opnd1.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->opnd1.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->opnd1.atr.valint); break;
				case REALOPND: printf (", %g", q->opnd1.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->opnd1.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->opnd1.atr.vallogic); break;
				case CADOPND: printf (", %s", q->opnd1.atr.valcad); break;
				case ROTOPND: printf (", %d", q->opnd1.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->opnd1.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
			printf (", (%s", nometipoopndquad[q->opnd2.tipo]);
			switch (q->opnd2.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->opnd2.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->opnd2.atr.valint); break;
				case REALOPND: printf (", %g", q->opnd2.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->opnd2.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->opnd2.atr.vallogic); break;
				case CADOPND: printf (", %s", q->opnd2.atr.valcad); break;
				case ROTOPND: printf (", %d", q->opnd2.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->opnd2.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
			printf (", (%s", nometipoopndquad[q->result.tipo]);
			switch (q->result.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->result.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->result.atr.valint); break;
				case REALOPND: printf (", %g", q->result.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->result.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->result.atr.vallogic); break;
				case CADOPND: printf (", %s", q->result.atr.valcad); break;
				case ROTOPND: printf (", %d", q->result.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->result.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
		}
	}
   printf ("\n");
}

void RenumQuadruplas (quadrupla quad1, quadrupla quad2) {
	quadrupla q; int nquad;
	for (q = quad1->prox, nquad = quad1->num; q != quad2; q = q->prox) {
      nquad++;
		q->num = nquad;
	}
}

/* Funcoes para o codigo intermediario */

void InterpCodIntermed () {
	quadrupla quad, quadprox;  char encerra;
	printf ("\n\nINTERPRETADOR:\n");
    InicPilhaOpnd (&pilhaopnd);
	encerra = FALSE;
    char condicao;
	quad = codintermed->prox->listquad->prox;
    finput = fopen ("entrada2016.txt", "r");
	while (! encerra) {
		printf ("\n%4d) %s", quad->num,
			nomeoperquad[quad->oper]);
		quadprox = quad->prox;
		switch (quad->oper) {
			case OPEXIT:    encerra = TRUE;                         break;
            case OPENMOD:   AlocaVariaveis ();                      break;
            case PARAM:     EmpilharOpnd (quad->opnd1, &pilhaopnd); break;
            case OPWRITE:   ExecQuadWrite (quad);                   break;
            case OPMAIS:    ExecQuadMais (quad);                    break;
            case OPATRIB:   ExecQuadAtrib (quad);                   break;
            case OPLT:      ExecQuadLT (quad);                      break;
            case OPREAD:    ExecQuadRead (quad);                    break;
            case OPJUMP:    quadprox = quad->result.atr.rotulo;     break;
            case OPJF:
                if (quad->opnd1.tipo == LOGICOPND)
                    condicao = quad->opnd1.atr.vallogic;
                if (quad->opnd1.tipo == VAROPND)
                    condicao = *(quad->opnd1.atr.simb->vallogic);
                if (! condicao)
                    quadprox = quad->result.atr.rotulo;
                break;
		}
		if (! encerra) quad = quadprox;
	}
	printf ("\n");
}

void AlocaVariaveis () {
    simbolo s; int nelemaloc, i, j;
    printf ("\n\t\tAlocando as variaveis:");
    for (i = 0; i < NCLASSHASH; i++)
        if (tabsimb[i]) {
            for (s = tabsimb[i]; s != NULL; s = s->prox){
                if (s->tid == IDVAR) {
                    nelemaloc = 1;
                    if (s->array) 
                        for (j = 1; j <= s->ndims; j++)  
                            nelemaloc *= s->dims[j];
                    switch (s->tvar) {
                       case INTEGER:    s->valint   = malloc (nelemaloc * sizeof (int));    break;
                       case FLOAT:      s->valfloat = malloc (nelemaloc * sizeof (float));  break;
                       case CHAR:       s->valchar  = malloc (nelemaloc * sizeof (char));   break;
                       case LOGIC:      s->vallogic = malloc (nelemaloc * sizeof (char));   break;
                   }
                   printf ("\n\t\t\t%6s: %2d elemento(s) alocado(s) ", s->cadeia, nelemaloc);
            }
        }
    }
}

void ExecQuadWrite (quadrupla quad) {
    int i;  operando opndaux;  pilhaoperando pilhaopndaux;

    printf ("\n\t\tEscrevendo: \n\n");
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
        printf ("\n");
    }
}

void ExecQuadMais (quadrupla quad) {
    int tipo1, tipo2, valint1, valint2;
    float valfloat1, valfloat2;
    switch (quad->opnd1.tipo) {
        case INTOPND:
            tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
        case REALOPND:
            tipo1 = REALOPND;  valfloat1 = quad->opnd1.atr.valfloat; break;
        case CHAROPND:
            tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valchar;  break;
        case VAROPND:
            switch (quad->opnd1.atr.simb->tvar) {
                case INTEGER:
                    tipo1 = INTOPND;
                    valint1 = *(quad->opnd1.atr.simb->valint);  break;
                case FLOAT:
                    tipo1 = REALOPND;
                    valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
                case CHAR:
                    tipo1 = INTOPND;
                    valint1 = *(quad->opnd1.atr.simb->valchar); break;
            }
            break;
    }
    switch (quad->opnd2.tipo) {
        case INTOPND:
            tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
        case REALOPND:
            tipo2 = REALOPND;  valfloat2 = quad->opnd2.atr.valfloat;  break;
        case CHAROPND:
            tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valchar;  break;
        case VAROPND:
            switch (quad->opnd2.atr.simb->tvar) {
                case INTEGER:
                    tipo2 = INTOPND;
                    valint2 = *(quad->opnd2.atr.simb->valint);  break;
                case FLOAT:
                    tipo2 = REALOPND;
                    valfloat2=*(quad->opnd2.atr.simb->valfloat);break;
                case CHAR:
                    tipo2 = INTOPND;
                    valint2=*(quad->opnd2.atr.simb->valchar);break;
            }
            break;
    }
    switch (quad->result.atr.simb->tvar) {
        case INTEGER:
            *(quad->result.atr.simb->valint) = valint1 + valint2;
            break;
        case FLOAT:
            if (tipo1 == INTOPND && tipo2 == INTOPND)
                *(quad->result.atr.simb->valfloat) = valint1 + valint2;
            if (tipo1 == INTOPND && tipo2 == REALOPND)
                *(quad->result.atr.simb->valfloat) = valint1 + valfloat2;
            if (tipo1 == REALOPND && tipo2 == INTOPND)
                *(quad->result.atr.simb->valfloat) = valfloat1 + valint2;
            if (tipo1 == REALOPND && tipo2 == REALOPND)
                *(quad->result.atr.simb->valfloat) = valfloat1 + valfloat2;
            break;
    }
}

void ExecQuadAtrib (quadrupla quad) {
    int tipo1, valint1;
    float valfloat1;
    char valchar1, vallogic1;
    switch (quad->opnd1.tipo) {
        case INTOPND:
            tipo1 = INTOPND;
            valint1 = quad->opnd1.atr.valint; break;
        case REALOPND:
            tipo1 = REALOPND;
            valfloat1 = quad->opnd1.atr.valfloat; break;
        case CHAROPND:
            tipo1 = CHAROPND;
            valchar1 = quad->opnd1.atr.valchar; break;
        case LOGICOPND:
            tipo1 = LOGICOPND;
            vallogic1 = quad->opnd1.atr.vallogic; break;
        case VAROPND:
            switch (quad->opnd1.atr.simb->tvar) {
                case INTEGER:
                    tipo1 = INTOPND;
                    valint1 = *(quad->opnd1.atr.simb->valint); break;
                case FLOAT:
                    tipo1 = REALOPND;
                    valfloat1=*(quad->opnd1.atr.simb->valfloat);break;
                case CHAR:
                    tipo1 = CHAROPND;
                    valchar1=*(quad->opnd1.atr.simb->valchar);break;
                case LOGIC:
                    tipo1 = LOGICOPND;
                    vallogic1 = *(quad->opnd1.atr.simb->vallogic);
                    break;
            }
            break;
    }
    switch (quad->result.atr.simb->tvar) {
        case INTEGER:
            if (tipo1 == INTOPND)  *(quad->result.atr.simb->valint) = valint1;
            if (tipo1 == CHAROPND)*(quad->result.atr.simb->valint)=valchar1;
            break;
        case CHAR:
            if (tipo1 == INTOPND) *(quad->result.atr.simb->valchar) = valint1;
            if (tipo1==CHAROPND)*(quad->result.atr.simb->valchar)=valchar1;
            break;
        case LOGIC:  *(quad->result.atr.simb->vallogic) = vallogic1; break;
        case FLOAT:
            if (tipo1 == INTOPND)
                *(quad->result.atr.simb->valfloat) = valint1;
            if (tipo1 == REALOPND)
                *(quad->result.atr.simb->valfloat) = valfloat1;
            if (tipo1 == CHAROPND)
                *(quad->result.atr.simb->valfloat) = valchar1;
            break;
    }
}

void ExecQuadLT (quadrupla quad) {
    int tipo1, tipo2, valint1, valint2;
    float valfloat1, valfloat2;

    switch (quad->opnd1.tipo) {
    case INTOPND:
        tipo1 = INTOPND;  valint1 = quad->opnd1.atr.valint;  break;
    case REALOPND:
        tipo1 = REALOPND; valfloat1=quad->opnd1.atr.valfloat;break;
    case CHAROPND:
        tipo1 = INTOPND; valint1 = quad->opnd1.atr.valchar; break;
    case VAROPND:
        switch (quad->opnd1.atr.simb->tvar) {
            case INTEGER:  tipo1 = INTOPND;
                valint1 = *(quad->opnd1.atr.simb->valint);
                break;
            case FLOAT:  tipo1 = REALOPND;
                valfloat1 = *(quad->opnd1.atr.simb->valfloat);
                break;
            case CHAR:  tipo1 = INTOPND;
                valint1 = *(quad->opnd1.atr.simb->valchar);
                break;
        }
        break;
    }
    switch (quad->opnd2.tipo) {
        case INTOPND:
            tipo2 = INTOPND;  valint2 = quad->opnd2.atr.valint;  break;
        case REALOPND:
            tipo2=REALOPND;valfloat2 = quad->opnd2.atr.valfloat;break;
        case CHAROPND:
            tipo2 = INTOPND;valint2 = quad->opnd2.atr.valchar; break;
        case VAROPND:
            switch (quad->opnd2.atr.simb->tvar) {
                case INTEGER:  tipo2 = INTOPND;
                    valint2 = *(quad->opnd2.atr.simb->valint);
                    break;
                case FLOAT:  tipo2 = REALOPND;
                    valfloat2 = *(quad->opnd2.atr.simb->valfloat);
                    break;
                case CHAR:  tipo2 = INTOPND;
                    valint2 = *(quad->opnd2.atr.simb->valchar);
                    break;
                }
            break;
    }
    if (tipo1 == INTOPND && tipo2 == INTOPND)
        *(quad->result.atr.simb->vallogic) = valint1 < valint2;
    if (tipo1 == INTOPND && tipo2 == REALOPND)
        *(quad->result.atr.simb->vallogic) = valint1 < valfloat2;
    if (tipo1 == REALOPND && tipo2 == INTOPND)
        *(quad->result.atr.simb->vallogic) = valfloat1 < valint2;
    if (tipo1 == REALOPND && tipo2 == REALOPND)
        *(quad->result.atr.simb->vallogic) = valfloat1 < valfloat2;
}

void ExecQuadRead (quadrupla quad) {
    int i;  operando opndaux;  pilhaoperando pilhaopndaux;

    printf ("\n\t\tLendo: \n");
    InicPilhaOpnd (&pilhaopndaux);
    for (i = 1; i <= quad->opnd1.atr.valint; i++) {
        EmpilharOpnd (TopoOpnd (pilhaopnd), &pilhaopndaux);
        DesempilharOpnd (&pilhaopnd);
    }
    for (i = 1; i <= quad->opnd1.atr.valint; i++) {
        opndaux = TopoOpnd (pilhaopndaux);
        DesempilharOpnd (&pilhaopndaux);
        switch (opndaux.atr.simb->tvar) {
            case INTEGER:
                    fscanf (finput, "%d", opndaux.atr.simb->valint); break;
                case FLOAT:
                    fscanf (finput, "%g", opndaux.atr.simb->valfloat);break;
                case LOGIC:
                    fscanf (finput, "%d", opndaux.atr.simb->vallogic); break;
                case CHAR:
                    fscanf (finput, "%c", opndaux.atr.simb->valchar); break;
            }
    }
}


void EmpilharOpnd (operando x, pilhaoperando *P) {
    nohopnd *temp;
    temp = *P;   
    *P = (nohopnd *) malloc (sizeof (nohopnd));
    (*P)->opnd = x; (*P)->prox = temp;
}

void DesempilharOpnd (pilhaoperando *P) {
    nohopnd *temp;
    if (! VaziaOpnd (*P)) {
        temp = *P;  *P = (*P)->prox; free (temp);
    }
    else  printf ("\n\tDelecao em pilha vazia\n");
}

operando TopoOpnd (pilhaoperando P) {
    if (! VaziaOpnd (P))  return P->opnd;
    else  printf ("\n\tTopo de pilha vazia\n");
}

void InicPilhaOpnd (pilhaoperando *P) { 
    *P = NULL;
}

char VaziaOpnd (pilhaoperando P) {
    if  (P == NULL)  return 1;  
    else return 0; 
}

