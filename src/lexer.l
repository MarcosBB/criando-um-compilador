%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include "y.tab.h"
%}

%%
[ \t\n]+                                ;  // Ignora espaços em branco
"\/\/".*"\n"?                           ;  // Ignora comentários
[0-9]+                                  { yylval.iValue = atoi(yytext); return INTEGER; }
([[0-9]+"."[0-9]*)|([0-9]*"."[0-9]+])   { yylval.fValue = atof(yytext); return REAL; }
\"[^\"]*\"                              { yylval.sValue = strdup(yytext); return LIT_STRING; }
"while"                                 return WHILE;
"for"                                   return FOR;
"in"                                    return IN;
"function"                              return FUNCTION;
"return"                                return RETURN;
"void"                                  { yylval.sValue = strdup(yytext); return P_TYPE; }
"int"                                   { yylval.sValue = strdup(yytext); return P_TYPE; }
"float"                                 { yylval.sValue = strdup(yytext); return P_TYPE; }
"bool"                                  { yylval.sValue = strdup(yytext); return P_TYPE; }
"string"                                { yylval.sValue = strdup(yytext); return P_TYPE; }
"list"                                  { yylval.sValue = strdup(yytext); return P_TYPE; }
"if"                                    return IF;
"else"                                  return ELSE;
"("                                     return yytext[0];
")"                                     return yytext[0];
"{"                                     return yytext[0];
"}"                                     return yytext[0];
"["                                     return yytext[0];
"]"                                     return yytext[0];
","                                     return yytext[0];
";"                                     return SEMI;
"<<"                                    return ASSIGN;
"<"                                     return LESS;
">"                                     return GREATER;
"<="                                    return LESS_EQUAL;
">="                                    return GREATER_EQUAL;
"=="                                    return EQUAL;
"+"                                     return PLUS;
"-"                                     return MINUS;
"*"                                     return TIMES;
"/"                                     return DIVIDE;
"&&"                                    return AND;
"||"                                    return OR;
"!"                                     return NOT;
"!="                                    return NOT_EQUAL;
"++"                                    return INCREMENT;
"--"                                    return DECREMENT;
[a-zA-Z][a-zA-Z0-9-]*                  { yylval.sValue = strdup(yytext); return ID; }
.                                       { printf("invalid character(%s)\n", yytext); exit(0); }

%%
#ifndef yywrap
int yywrap(void) { return 1; }
#endif
