%{
    #include <stdio.h>
%}

%%
[ \t\n]                                 ;
"\/\/".*"\n"?                             ;
[0-9]+                                  {yylval.iValue = atoi(yytext);
                                        return INTEGER;}
([[0-9]+"."[0-9]*)|([0-9]*"."[0-9]+])   {yylval.fValue = atof(yytext); return REAL}
\".*\"                                  return(LIT_STRING);
"<"[a-zA-Z][a-zA-Z0-9]+">"              {printf("TYPE(%s)\n", yytext);}//NÃO PERTENCE AQUI
"while"                                 return(WHILE);
"for"                                   return(FOR);
"in"                                    return(IN);
"function"                              return(FUNCTION);
"return"                                return(RETURN);
"void"                                  {printf("VOID\n");}
"int"                                   {printf("INT\n");}
"float"                                 {printf("FLOAT\n");}
"bool"                                  {printf("BOOL\n");}
"string"                                {printf("STRING\n");}
"if"                                    return(IF);
"else"                                  return(ELSE);
"("                                     return(yytext[0]);
")"                                     return(yytext[0]);
"{"                                     return(yytext[0]);
"}"                                     return(yytext[0]);
"["                                     return(yytext[0]);
"]"                                     return(yytext[0]);
","                                     return(yytext[0]);
";"                                     return(SEMI);
"<<"                                    return(ASSIGN);
"<"                                     return(LESS);
">"                                     return(GREATER);
"<="                                    return(LESS_EQUAL);
">="                                    return(GREATER_EQUAL);
"=="                                    return(EQUAL);
"+"                                     return(yytext[0]);
"-"                                     return(yytext[0]);
"*"                                     return(yytext[0]);
"/"                                     return(yytext[0]);
"&&"                                    return(AND);
"||"                                    return(OR);
"!"                                     return(NOT);
"!="                                    return(NOT_EQUAL);
"++"                                    return(INCREMENT);
"--"                                    return(DECREMENT);
[a-zA-Z][a-zA-Z0-9]*                    {yylval.sValue = strdup(yytext); return ID}
.                                       {printf("invalid character(%s)\n", yytext);exit(0);}

%%
#ifndef yywrap
    int yywrap(void){return 1;}
#endif
int main(void){
    yylex();
    return 0;
}
