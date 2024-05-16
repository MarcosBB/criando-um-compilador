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
%token <iValue> INTEGER
%token <fValue> REAL

%token WHILE FOR IF ELSE SEMI ASSIGN EQUAL FUNCTION RETURN AND OR NOT NOT_EQUAL INCREMENT DECREMENT IN PLUS MINUS TIMES DIVIDE LESS_EQUAL GREATER_EQUAL LESS GREATER LIT_STRING P_TYPE

%left PLUS MINUS
%left TIMES DIVIDE

%start prog
%%

prog : stmlist {} 
	 ;

stm : assignment                      {}
    | function

type : P_TYPE                       {}
    | list

list : P_TYPE LESS type GREATER {}

function : FUNCTION type ID '(' params ')' '{'stm'}'               {}
params : type ID {}

paramslist: type ID {}
        | paramslist ',' params
        ;


stmlist :  stm                          {}
        | stmlist SEMI stm          
        ;

assignment : ID ASSIGN ID               {printf("%s <- %s \n",$1, $3);}

%%


int main (void) {
	return yyparse ( );
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}