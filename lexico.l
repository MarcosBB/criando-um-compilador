%{
    #include <stdio.h>
%}

%%
[ \t\n]                                 ;
"--".*"\n"?                             ;
[0-9]+                                  {printf("NUMBER(%s)\n", yytext);}
([[0-9]+"."[0-9]*)|([0-9]*"."[0-9]+])   {printf("REAL(%s)\n", yytext);}
\".*\"                                  {printf("LIT_STRING\n");}
"<"[a-zA-Z][a-zA-Z0-9]+">"              {printf("TYPE(%s)\n", yytext);}
"while"     				            {printf("WHILE\n");}
"for"                                   {printf("FOR\n");}
"function"                              {printf("FUNCTION\n");}
"return"                                {printf("RETURN\n");}
"void"                                  {printf("VOID\n");}
"int"                                   {printf("INT\n");}
"float"                                 {printf("FLOAT\n");}
"bool"                                  {printf("BOOL\n");}
"string"                                {printf("STRING\n");}
"<"                                     {printf("<\n");}
">"                                     {printf(">\n");}
"("                                     {printf("(\n");}
")"                                     {printf(")\n");}
"{"				                  	    {printf("{\n");}
"}"    			                  	    {printf("}\n");}
"if"     		                  		{printf("IF\n");}
"else"                        			{printf("ELSE\n");}
","                                     {printf(",\n");}
";"      		                  		{printf("SEMI\n");}
"<<"				                  	{printf("ASSIGNMENT\n");}
"=="                                    {printf("EQUAL\n");}
"["                                     {printf("[\n");}
"]"                                     {printf("]\n");}
"+"                                     {printf("ADD\n");}
"-"                                     {printf("SUB\n");}
"*"                                     {printf("MULT\n");}
"/"                                     {printf("DIV\n");}
"&&"                                    {printf("AND\n");}
"||"                                    {printf("OR\n");}
"!"                                     {printf("NOT\n");}
[a-zA-Z][a-zA-Z0-9]*	                {printf("ID(%s)\n", yytext);}
.					                    {printf("invalid character(%s)\n", yytext);exit(0);}

%%
#ifndef yywrap
	int yywrap(void){return 1;}
#endif
int main(void){
    yylex();
    return 0;
}
