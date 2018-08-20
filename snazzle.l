%{
#include <cstdio>

#include "snazzle.tab.h"

extern "C" int yylex();

%}
%%
[ \t\n]         ;
,               { return COMMA; }
:               { return COLON; }
\<=              { return LESS_EQ; }
\>=              { return GREATER_EQ; }
\<               { return LESS; }
\>               { return GREATER; }
=               { return EQUAL; }
\*              { return MULTIPLY; }
\+              { return PLUS; }
private         { return PRIVATE; }
prove           { return PROVE; }
\(              { return L_BRACKET; }
\)              { return R_BRACKET; }
represent       { return REPRESENT; }
linear_equation { return LINEAR_EQUATION; }
range_proof     { return RANGE_PROOF; }
any             { return ANY; }
all             { return ALL; }
version         { return VERSION; }
[0-9]+\.[0-9]+  { yylval.fval = atof(yytext); return FLOAT; }
[0-9]+          { yylval.ival = atoi(yytext); return INT; }
[a-zA-Z]+[a-zA-Z0-9_]*  {
    yylval.sval = strdup(yytext);
    return TOKEN;
}
.               ;
%%
