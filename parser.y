%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char * yytext;

%}

%union {
	int    iValue; /* integer value */
	float  fValue; /* float value */
	char   cValue; /* char value */
	char * sValue; /* string value */
}

%token <sValue> ID
%token <iValue> INTEGER
%token <fValue> REAL
%token <sValue> LIT_STRING P_TYPE

%token WHILE FOR IF ELSE SEMI ASSIGN EQUAL FUNCTION RETURN AND OR NOT NOT_EQUAL INCREMENT DECREMENT IN PLUS MINUS TIMES DIVIDE LESS_EQUAL GREATER_EQUAL LESS GREATER

%type <sValue> prog stmlist stm assignment type list function params paramslist condition comparison if_statement while_statement for_statement
%type <iValue> expr term
%type <sValue> var

%left OR
%left AND
%left EQUAL NOT_EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT

%start prog
%%

prog : stmlist {}
	 ;

stm : assignment {}
    | function {}
    | if_statement {}
    | while_statement {}
    | expr {}
    ;

stmlist : stm {}
        | stmlist SEMI stm {}
        ;

assignment : P_TYPE ID ASSIGN expr {}
           | ID ASSIGN expr {}
           ;

expr : term {}
     | expr PLUS term {}
     | expr MINUS term {}
     ;

term : var {}
     | var TIMES term {}
     | var DIVIDE term {}
     ;

var : INTEGER {}
    | REAL {}
    | ID {}
    ;

type : P_TYPE {}
     | list {}
     ;

list : P_TYPE LESS type GREATER {}
     ;

function : FUNCTION type ID '(' paramslist ')' '{' stmlist '}' {}
         ;

params : type ID {}
       | {}
       ;

paramslist : params {}
           | params ',' paramslist {}
           ;

condition : expr comparison expr {}
          | NOT ID {}
          | '(' condition ')' {}
          ;

comparison : EQUAL {}
           | NOT_EQUAL {}
           | LESS {}
           | GREATER {}
           | LESS_EQUAL {}
           | GREATER_EQUAL {}
           | AND {}
           | OR {}
           ;

if_statement : IF '(' condition ')' '{' stmlist '}' {}
             | IF '(' condition ')' '{' stmlist '}' ELSE '{' stmlist '}' {}
             ;

while_statement : WHILE '(' condition ')' '{' stmlist '}' {}
                ;

%%

int main (void) {
	return yyparse ();
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
