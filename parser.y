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

%type <sValue> prog stmlist stm assignment type list function params paramslist condition comparison if_statement while_statement
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

assignment : P_TYPE ID ASSIGN expr { printf("Assignment: 1\n"); }
           | ID ASSIGN expr { printf("Assignment: 2\n"); }
           ;

expr : term { printf("Expr: 1\n"); }
     | expr PLUS term { $$ = $1 + $3; printf("Expr: 2\n"); }
     | expr MINUS term { $$ = $1 - $3; printf("Expr: 3\n"); }
     ;

term : var { printf("Term: 1\n"); }
     | term TIMES var { printf("Term: 2\n"); }
     | term DIVIDE var { printf("Term: 3\n"); }
     ;

var : INTEGER { printf("Var: 1\n"); }
    | REAL { printf("Var: 2\n"); }
    | ID { printf("Var: 1\n"); }
    ;

type : P_TYPE { printf("Type: 1\n"); }
     | list { printf("Type: 2\n"); }
     ;

list : P_TYPE LESS type GREATER { printf("List: 1\n"); }
     ;

function : FUNCTION type ID '(' paramslist ')' '{' stmlist '}' { printf("Function: 1\n"); }
         ;

params : type ID { printf("Param: 1\n"); }
       | {}
       ;

paramslist : params { printf("Paramlist: 1\n"); }
           | params ',' paramslist { printf("Paramlist: 2\n"); }
           ;

condition : expr comparison expr { printf("Condition: 1\n"); }
          | NOT ID { printf("Condition: 2\n"); }
          | '(' condition ')' { printf("Condition: 3\n"); }
          ;

comparison : EQUAL { printf("Comparisson: ==\n"); }
           | NOT_EQUAL { printf("Comparisson: !=\n"); }
           | LESS { printf("Comparisson: <\n"); }
           | GREATER { printf("Comparisson: >\n"); }
           | LESS_EQUAL { printf("Comparisson: <=\n"); }
           | GREATER_EQUAL { printf("Comparisson: >=\n"); }
           | AND { printf("Comparisson: &&\n"); }
           | OR { printf("Comparisson: ||\n"); }
           ;

if_statement : IF '(' condition ')' '{' stmlist '}' { printf("If: {...}\n"); }
             | IF '(' condition ')' '{' stmlist '}' ELSE '{' stmlist '}' { printf("If-Else: {...} else {...}\n"); }
             ;

while_statement : WHILE '(' condition ')' '{' stmlist '}' { printf("While: {...}\n"); }
              ;

%%

int main (void) {
	return yyparse ();
}

int yyerror (char *msg) {
	fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
	return 0;
}
