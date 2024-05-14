%{
#include <stdio.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}

%union {
	int    iValue; 	/* integer value */
    float  fValue; /* float value */
	char   cValue; 	/* char value */
	char * sValue;  /* string value */
	};

%token <sValue> ID
%token <iValue> NUMBER
%token <fValue> REAL

%token WHILE FOR IF ELSE SEMI ASSIGN EQUAL FUNCTION RETURN AND OR NOT NOT_EQUAL INCREMENT DECREMENT IN
%start prog


%%

prog : stmlist {} 
	 ;

stm : ID ASSING ID {printf("%s <- %s \n",$1, $3);}

stmlist : stm								{}
		| stmlist SEMI stm					{}
	    ;
%%


int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}