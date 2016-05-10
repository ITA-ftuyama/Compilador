delim		[ \t\n\r]
ws			{delim}+
digito	    [0-9]
letra		[A-Za-z]
ctint 		{digito}+
id			{letra}({letra}|{digito})*
ctreal      {digito}+\.{digito}*([Ee][+-]?{digito}+)?
carac1		\\.|[^\\']
carac2		\\.|[^\\\"]
ctcarac 	'{carac1}'
cadeia		\"{carac2}*\"
%%

{ws}		{ ;}

se			{return se;}
senao		{return senao;}
enquanto	{return enquanto;}
para        {return para;}
retornar    {return retornar;}
repetir     {return repetir;}
true        {return verdade;}
false       {return falso;}

globais     {return globais;}
locais      {return locais;}
comandos    {return comandos;}
funcoes     {return funcoes;}
principal   {return principal;}

ler         {return ler;}
escrever    {return escrever;}
chamar      {return chamar;}

int         {return inteiro;}
real        {return real;}
carac       {return carac;}
logico      {return logico;}
vazio       {return vazio;}

{id}		{strcpy (yylval.cadeia, yytext);    return ID;}
{ctint}		{yylval.valint  = atoi(yytext);     return CTINT;}
{ctreal}    {yylval.valreal = atof(yytext);     return CTREAL;}
{ctcarac}   {strcpy (yylval.cadeia, yytext);    return CTCARAC;}
{cadeia}	{strcpy (yylval.cadeia, yytext);    return CADEIA;}

"<"		    {yylval.atr = LT;   return OPREL;}
"<="		{yylval.atr = LE;   return OPREL;}
">"		    {yylval.atr = GT;   return OPREL;}
">="		{yylval.atr = GE;   return OPREL;}
"!="		{yylval.atr = NE;   return OPREL;}
"="		    {yylval.atr = EQU;  return OPREL;}

"+"         {yylval.atr = MAIS; return OPAD;}
"-"         {yylval.atr = MENOS;return OPAD;}
"*"         {yylval.atr = MULT; return OPMULT;}
"/"         {yylval.atr = DIV;  return OPMULT;}
"%"         {yylval.atr = REST; return OPMULT;}
"&&"        {return AND;}
"||"        {return OR;}
"!"         {return NOT;}
"~"         {return NEG;}

";"         {return PVIRG;}
"."         {return PONTO;}
":"         {return DPONTS;}
","         {return VIRG;}
"("         {return ABPAR;}
")"         {return FPAR;}
"["         {return ABCOL;}
"]"         {return FCOL;}
"{"         {return ABCHAVE;}
"}"         {return FCHAVE;}
":="        {return ATRIB;}

"/*"		{comentario ();}
.			{yylval.caractere = yytext[0]; return INVAL;}
%%
