%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define 	LT 		    1
#define 	LE 		    2
#define	    GT		    3
#define 	GE		    4
#define 	NE		    5
#define     EQU         6
#define		MAIS		7
#define		MENOS		8
#define     MULT        10
#define     DIV         11
#define     REST        12

int tab = 0;
%}
%union {
	char cadeia[50];
	int atr, valint;
	float valreal;
	char caractere;
}

%token  se
%token  senao
%token  enquanto
%token  para
%token  retornar
%token  repetir
%token  verdade
%token  falso

%token  globais
%token  locais
%token  comandos
%token  funcoes
%token  principal

%token  ler
%token  escrever
%token  chamar

%token	<cadeia>	ID
%token	<valint>	CTINT
%token  <valreal>   CTREAL
%token  <cadeia>    CTCARAC
%token  <cadeia>    CADEIA

%token	inteiro
%token	real
%token	carac
%token	logico
%token	vazio

%token	<atr>		OPAD
%token	<atr>		OPREL
%token	<atr>		OPMULT
%token	<atr>		OPNEG

%token              OR
%token              AND
%token              NOT
%token              NEG

%token			    ABPAR
%token			    FPAR
%token			    ABCOL
%token			    FCOL
%token			    ABCHAVE
%token			    FCHAVE
%token			    PVIRG
%token              PONTO
%token              DPONTS
%token              VIRG
%token			    ATRIB

%token	<caractere> INVAL

%%
Programa	:   {printf("/* $Felipe Tuyama$ */");}
                DeclGlobs   Funcoes
            ;
DeclGlobs	:
            |   {tab = 1; printf("globais:\n");}
                globais  DPONTS  ListDecl
            ;
ListDecl	:   Declaracao
            |   ListDecl  Declaracao
            ;
Declaracao  :   {tabular();}
                Tipo  ListElemDecl
                {printf(";\n");}
                PVIRG
            ;
Tipo		:   {printf("int ");}   inteiro
            |   {printf("real ");}  real
            |   {printf("carac ");} carac
            |   {printf("logico ");}logico
            |   {printf("vazio ");} vazio
            ;
ListElemDecl:	ElemDecl
            |   ListElemDecl
                {printf(", ");}
                VIRG  ElemDecl
            ;
ElemDecl	:   ID
                {printf ("%s", $1);}
                ListDims
            ;
ListDims	:
            |   ListDims  Dimensao
            ;
Dimensao	:	ABCOL  CTINT
                {printf("[%d]", $2);}
                FCOL
            ;
Funcoes	    :	{tab = 1; printf("\nfuncoes:\n");}
                funcoes  DPONTS  ListFunc
            ;
ListFunc	:	Funcao
            |   ListFunc  Funcao
            ;
Funcao	    :	Cabecalho   ABCHAVE
                {printf (" {\n"); tab++;}
				DeclLocs Cmds FCHAVE
				{tab--; tabular (); printf ("}\n");}
            ;
Cabecalho	:   {printf("principal");}
                principal
            |   Tipo  ID
                {printf("%s (", $2);}
                ABPAR  Params
                {printf(")");}
                FPAR
            ;
Params	    :
            |   ListParam
            ;
ListParam	:	Parametro
            |   ListParam
                {printf(", ");}
                VIRG  Parametro
            ;
Parametro	:   Tipo  ID {printf ("%s", $2);}
            ;
DeclLocs	:
            |   {tab = 1; printf("locais:\n");}
                locais  DPONTS  ListDecl
            ;
Cmds		:   {tab = 1; printf("comandos:\n");}
                comandos  DPONTS  ListCmds
            ;
ListCmds	:   {tabular();} Comando
            |   ListCmds  {tabular();}  Comando
            ;
Comando  	:   CmdComposto
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
CmdComposto :   ABCHAVE
				{printf ("{\n"); tab++;}
				ListCmds FCHAVE
				{tab--; tabular (); printf ("}\n");}
            ;
CmdSe	    :   {printf("se (");}
                se  ABPAR  Expressao
                {printf(") ");}
                FPAR CmdInside CmdSenao
            ;
CmdInside   :   CmdComposto
            |   {printf("\n"); tab++; tabular();}
                Comando
                {tab--;}
            ;
CmdSenao	:
            |   senao {tabular(); printf("senao ");}
                Comando
            ;
CmdEnquanto :   {printf("enquanto (");}
                enquanto  ABPAR  Expressao
                {printf(") ");}
                FPAR  Comando
            ;
CmdRepetir  :   {printf("repetir ");}
                repetir  CmdInside
                {tabular(); printf("enquanto (");}
                enquanto  ABPAR  Expressao
                {printf(");\n");}
                FPAR PVIRG
            ;
CmdPara     :   {printf("para (");}
                para  ABPAR  Variavel
                {printf(" := ");}
                ATRIB  Expressao
                {printf("; ");}
                PVIRG Expressao
                {printf("; ");}
                PVIRG  Variavel
                {printf(" := ");}
                ATRIB  Expressao
                {printf(") ");}
                FPAR   Comando
            ;
CmdLer	    :   {printf("ler (");}
                ler  ABPAR  ListLeit
                {printf(");\n");}
                FPAR  PVIRG
            ;
ListLeit	:   Variavel
            |   ListLeit
                {printf(", ");}
                VIRG  Variavel
            ;
CmdEscrever :   {printf("escrever (");}
                escrever  ABPAR  ListEscr
                {printf(");\n");}
                FPAR  PVIRG
            ;
ListEscr	:   ElemEscr
            |   ListEscr
                {printf(", ");}
                VIRG  ElemEscr
            ;
ElemEscr	:   CADEIA      {printf("%s", $1);}
            |   Expressao
            ;
ChamadaProc :   chamar  ID
                {printf("chamar %s(", $2);}
                ABPAR  Argumentos
                {printf(");\n");}
                FPAR  PVIRG
            ;
Argumentos  :
            |   ListExpr
            ;
ListExpr	:	Expressao
            |   ListExpr
                {printf(", ");}
                VIRG  Expressao
            ;
CmdRetornar :   retornar  PVIRG  {printf("retornar;\n");}
            |   retornar  {printf("retornar ");}
                Expressao
                {printf(";\n");}
                PVIRG
            ;
CmdAtrib    :   Variavel ATRIB
                {printf (" := ");}
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
                    case EQU :  printf (" = ");  break;
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
Termo  	    :   Fator
            |   Termo  OPMULT
            {
				switch ($2) {
					case MULT :  printf (" * "); break;
					case DIV  :  printf (" / "); break;
					case REST :  printf (" % "); break;
				}
			}   Fator
            ;
Fator	    :   Variavel
            |   CTINT           {printf ("%d", $1);}
            |   CTREAL          {printf ("%g", $1);}
            |   CTCARAC         {printf ("%s", $1);}
            |   CADEIA          {printf ("%s", $1);}
            |   verdade         {printf ("true");}
            |   falso           {printf ("false");}
            |   NEG             {printf ("~");} Fator
            |   ABPAR           {printf("(");}
                Expressao  FPAR {printf (")");}
            |	ChamadaFunc
            ;
Variavel	:   ID {printf ("%s", $1);} ListSubscr
            ;
ListSubscr  :
            |   ListSubscr  Subscrito
            ;
Subscrito	:   {printf("[");}
                ABCOL  ExprAux4
                {printf("]");}
                FCOL
            ;
ChamadaFunc :   ID ABPAR
                {printf ("%s (", $1);}
                Argumentos
                {printf(")");}
                FPAR
            ;
%%
#include "lex.yy.c"
tabular () {
	int i;
	for (i = 1; i <= tab; i++)
   	printf ("\t");
}
comentario () {
	char c;  int estado;
	estado = 1;
	printf("\n/*");
	while (estado != 3) {
		switch (estado) {
			case 1:
				c = input ();
				printf("%c",c);
				if (c == EOF) estado = 3;
				else if (c == '*') estado = 2;
				break;
            case 2:
                c = input ();
                printf("%c",c);
				if (c == EOF) estado = 3;
				else if (c == '/') estado = 3;
				else if (c == '*') estado = 2;
				else estado = 1;
                break;
		}
	}
	printf("\n\n");
}
