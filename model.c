/* Producoes da gramatica:

    Os terminais sao escritos e, depois de alguns,
    para alguma estetica, ha mudanca de linha       */

Programa        :   {InicTabSimb ();}  ID  ABCHAVE  {
                        printf ("%s {\n", $2);
                        InsereSimb ($2, IDPROG, NOTVAR);
                    }
                    DeclLocs  Cmds  FCHAVE  {
                        printf ("}\n");
                        VerificaInicRef ();
                        ImprimeTabSimb ();
                    }
                ;
DeclLocs        :
                |   LOCAIS  DPONTS  {printf ("locais :\n");}  ListDecl
                ;
ListDecl        :   Declaracao
                |   ListDecl  Declaracao
                ;
Declaracao      :   Tipo  ListElemDecl  PVIRG  {printf (";\n");}
                ;
Tipo            :   INTEIRO  {printf ("int "); tipocorrente = INTEGER;}
                |   REAL  {printf ("real "); tipocorrente = FLOAT;}
                |   CARAC  {printf ("carac "); tipocorrente = CHAR;}
                |   LOGICO  {printf ("logico "); tipocorrente = LOGIC;}
                ;
ListElemDecl    :   ElemDecl
                |   ListElemDecl  VIRG  {printf (", ");}  ElemDecl
                ;
ElemDecl        :   ID  {
                        printf ("%s ", $1);
                        if  (ProcuraSimb ($1) != NULL)
                            DeclaracaoRepetida ($1);
                        else {
                            simb =  InsereSimb ($1, IDVAR, tipocorrente);
                            simb->array = FALSE; simb->ndims;
                        }
                    }  ListDims
                ;
ListDims        :
                |   ListDims  Dimensao {simb->array = TRUE;}
                ;
Dimensao        :   ABCOL  CTINT  FCOL  {
                        printf ("[ %d ] ", $2);
                        if ($2 <= 0) Esperado ("Valor inteiro positivo");
                        simb->ndims++; simb->dims[simb->ndims] = $2;
                    }
                ;
Cmds            :   COMANDOS  DPONTS  {printf ("comandos :\n");}
                    ListCmds
                ;
ListCmds        :   Comando
                |   ListCmds  Comando
                ;
Comando         :   CmdComposto
                |   CmdSe
                |   CmdEnquanto
                |   CmdLer
                |   CmdEscrever
                |   CmdAtrib
                ;
CmdComposto     :   ABCHAVE  {printf ("{\n");}  ListCmds
                    FCHAVE  {printf ("}\n");}
                ;
CmdSe           :   SE  ABPAR  {printf ("se ( "); }  Expressao
                    FPAR  {printf (") "); if ($4 != LOGIC)
                            Incompatibilidade ("Expressao no Se deveria ser logico");
                        }  Comando  CmdSenao
                ;
CmdSenao        :
                |   SENAO  {printf ("senao ");}  Comando
                ;
CmdEnquanto     :   ENQUANTO  ABPAR  { printf ("enquanto ( "); } Expressao  
                    FPAR  {printf (") "); if ($4 != LOGIC)
                            Incompatibilidade ("Expressao no Enquanto deveria ser logico"); 
                        }   Comando
                ;
CmdLer          :   LER  ABPAR  {printf ("ler ( ");}  ListLeit
                    FPAR  PVIRG  {printf (") ;\n");}
                ;
ListLeit        :   Variavel {if ($1 != NULL) $1->inic = $1->ref = TRUE;}
                |   ListLeit  VIRG  {printf (", ");}  Variavel
                ;
CmdEscrever     :   ESCREVER  ABPAR  {printf ("escrever ( ");}  ListEscr
                    FPAR  PVIRG  {printf (") ;\n");}
                ;
ListEscr        :   ElemEscr
                |   ListEscr  VIRG  {printf (", ");}  ElemEscr
                ;
ElemEscr        :   CADEIA  {printf ("\"%s\" ", $1);}
                |   Expressao
                ;
CmdAtrib        :   Variavel  {if ($1 != NULL) $1->inic = $1->ref = TRUE;}
                    ATRIB  {printf (":= ");}  Expressao
                    PVIRG  {
                        printf (";\n");
                        if ($1 != NULL)
                            if ((($1->tvar == INTEGER || $1->tvar == CHAR) &&
                                ($5 == FLOAT || $5 == LOGIC)) ||
                                ($1->tvar == FLOAT && $5 == LOGIC) ||
                                ($1->tvar == LOGIC && $5 != LOGIC))
                                Incompatibilidade ("Lado direito de comando de atribuicao improprio");
                    }
                ;
Expressao       :   ExprAux1
                |   Expressao  OR  {printf ("|| ");}  ExprAux1  {
                        if ($1 != LOGIC || $4 != LOGIC)
                            Incompatibilidade   ("Operando improprio para OR");
                        $$ = LOGIC;
                    }
                ;
ExprAux1        :   ExprAux2
                |   ExprAux1  AND  {printf ("&& ");}  ExprAux2  {
                        if ($1 != LOGIC || $4 != LOGIC)
                            Incompatibilidade   ("Operando improprio para AND");
                        $$ = LOGIC;
                    }
                ;
ExprAux2        :   ExprAux3
                |   NOT  {printf ("! ");}  ExprAux3  {
                        if ($3 != LOGIC)
                            Incompatibilidade   ("Operando improprio para NOT");
                        $$ = LOGIC;
                    }
                ;
ExprAux3        :   ExprAux4
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
                                if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR || $4 != INTEGER && $4!=FLOAT && $4!=CHAR)
                                    Incompatibilidade   ("Operando improprio para operador relacional");
                                break;
                            case EQ: case NE:
                                if (($1 == LOGIC || $4 == LOGIC) && $1 != $4)
                                    Incompatibilidade ("Operando improprio para operador relacional");
                                break;
                        }
                        $$ = LOGIC;
                    }
                ;
ExprAux4        :   Termo
                |   ExprAux4  OPAD  {
                        switch ($2) {
                            case MAIS: printf ("+ "); break;
                            case MENOS: printf ("- "); break;
                        }
                    }  Termo  {
                        if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR || $4 != INTEGER && $4!=FLOAT && $4!=CHAR)
                            Incompatibilidade   ("Operando improprio para operador aritmetico");
                        if ($1 == FLOAT || $4 == FLOAT) $$ = FLOAT;
                        else $$ = INTEGER;
                    }
                ;
Termo           :   Fator
                |   Termo  OPMULT   {
                        switch ($2) {
                            case MULT: printf ("* "); break;
                            case DIV: printf ("/ "); break;
                            case RESTO: printf ("%% "); break;
                        }
                    }  Fator  {
                        switch ($2) {
                            case MULT: case DIV:
                                if ($1 != INTEGER && $1 != FLOAT && $1 != CHAR
                                    || $4 != INTEGER && $4!=FLOAT && $4!=CHAR)
                Incompatibilidade ("Operando improprio para operador aritmetico");
                                if ($1 == FLOAT || $4 == FLOAT) $$ = FLOAT;
                                else $$ = INTEGER;
                            break;
                            case RESTO:
                                if ($1 != INTEGER && $1 != CHAR
                                    ||  $4 != INTEGER && $4 != CHAR)
                Incompatibilidade ("Operando improprio para operador resto");
                                $$ = INTEGER;
                                break;
                        }
                    }
                ;
Fator           :   Variavel  {
                        if  ($1 != NULL)  {
                            $1->ref  =  TRUE;
                            $$ = $1->tvar;
                        }
                    }
                |   CTINT  {printf ("%d ", $1); $$ = INTEGER;}
                |   CTREAL  {printf ("%g ", $1); $$ = FLOAT;}
                |   CTCARAC  {printf ("\'%c\' ", $1); $$ = CHAR;}
                |   VERDADE  {printf ("verdade "); $$ = LOGIC;}
                |   FALSO  {printf ("falso "); $$ = LOGIC;}
                |   NEG  {printf ("~ ");}  Fator  {
                        if ($3 != INTEGER && $3 != FLOAT && $3 != CHAR)
                            Incompatibilidade  ("Operando improprio para menos unario");
                        if ($3 == FLOAT) $$ = FLOAT;
                        else $$ = INTEGER;
                    }
                |   ABPAR  {printf ("( ");}  Expressao
                    FPAR   {printf (") "); $$ = $3;}
                ;
Variavel        :   ID  {
                        printf ("%s ", $1);
                        simb = ProcuraSimb ($1);
                        if (simb == NULL)   NaoDeclarado ($1);
                        else if (simb->tid != IDVAR)  TipoInadequado ($1);
                        $<simb>$ = simb;
                    }  ListSubscr  {
                        $$ = $<simb>2;
                        if ($$ != NULL) {
                            if ($$->array == FALSE && $3 > 0)
                                NaoEsperado ("Subscrito\(s)");
                            else if ($$->array == TRUE && $3 == 0)
                                Esperado ("Subscrito\(s)");
                            else if ($$->ndims != $3)
                                Incompatibilidade ("Numero de subscritos incompativel com declaracao");
                        }
                    }
                ;
ListSubscr      :   {$$ = 0;}
                |   ListSubscr  Subscrito {$$ = $1 + 1;}
                ;
Subscrito       :   ABCOL  {printf ("[ ");}
                    ExprAux4  FCOL  {
                        printf ("] "); 
                        if ($3 != INTEGER && $3 != CHAR)
                            Incompatibilidade ("Tipo inadequado para subscrito");
                    }
                ;