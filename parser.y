%{
#include <stdio.h>
#include <stdlib.h>

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char *yytext;

%}

%union {
    int    iValue; /* integer value */
    float  fValue; /* float value */
    char   cValue; /* char value */
    char  *sValue; /* string value */
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

prog : subprogs_list{ printf("Program\n"); }
     ;

subprogs_list: subprog { printf("Subprog_list: subprog\n"); }
    | subprogs_list SEMI subprog { printf("Subprogs_list: subprogs_list SEMI subprog\n"); }
    ;

subprog: function { printf("Subprog: function\n"); }
    | { printf("Subgprog: empty \n");}
    ;
    

stm : assignment { printf("Statement: assignment\n"); }
    | function { printf("Statement: function\n"); }
    | if_statement { printf("Statement: if_statement\n"); }
    | while_statement { printf("Statement: while_statement\n"); }
    | expr { printf("Statement: expr\n"); }
    | return { printf("Statement: return\n");}
    | function_call { printf("Statement: function_call\n"); }
    ;

stmlist : stm { printf("Statement list: single\n"); }
        | stmlist SEMI stm { printf("Statement list: multiple\n"); }
        ;

assignment : P_TYPE ID ASSIGN expr { printf("Assignment: type id << expr\n"); }
           | ID ASSIGN expr { printf("Assignment: id << expr\n"); }
           | list_value ASSIGN expr { printf("ssignment: list_value << expr \n"); }
           ;

return: RETURN {printf("Return:empty\n");}
        | RETURN expr {printf("Return: expr\n");}
        ;

expr : term { printf("Expr: term\n"); }
     | expr PLUS term { printf("Expr: expr + term\n"); }
     | expr MINUS term { printf("Expr: expr - term\n"); }
     ;

term : var { printf("Term: var\n"); }
     | term TIMES var { printf("Term: term * var\n"); }
     | term DIVIDE var { printf("Term: term / var\n"); }
     ;

var : INTEGER { printf("Var: integer\n"); }
    | REAL { printf("Var: real\n"); }
    | ID { printf("Var: id\n"); }
    | list_value { printf("Var: list_value\n"); }
    ;

type : P_TYPE { printf("Type: P_TYPE\n"); }
     | list { printf("Type: list\n"); }
     ;

list : P_TYPE LESS type GREATER { printf("List: P_TYPE < type >\n"); }
     ;

list_value : ID '['index']'  { printf("list_value: ID[index] \n"); }
    ;

index: ID { printf("index: ID \n"); }
    | INTEGER { printf("index: INTEGER \n"); }
    ;

function : FUNCTION type ID '(' paramslist ')' '{' stmlist '}' { printf("Function: function definition\n"); }
         ;

function_call: ID '('paramslist')' { printf("Function_call: ID(paramslist)\n"); }
        ;

params : type ID { printf("Params: type id\n"); }
       | expr { printf("Params: expr\n"); }
       | { printf("Params: empty\n"); }
       ;

paramslist : params { printf("Params list: single\n"); }
           | params ',' paramslist { printf("Params list: multiple\n"); }
           ;

condition : expr comparison expr { printf("Condition: expr comparison expr\n"); }
          | NOT ID { printf("Condition: not id\n"); }
          | '(' condition ')' { printf("Condition: ( condition )\n"); }
          ;

condition_list: condition  { printf("condition_list: condition \n"); }
            | condition_list comparison condition { printf("condition_list: condition_list comparison condition \n"); }

comparison : EQUAL { printf("Comparison: ==\n"); }
           | NOT_EQUAL { printf("Comparison: !=\n"); }
           | LESS { printf("Comparison: <\n"); }
           | GREATER { printf("Comparison: >\n"); }
           | LESS_EQUAL { printf("Comparison: <=\n"); }
           | GREATER_EQUAL { printf("Comparison: >=\n"); }
           | AND { printf("Comparison: &&\n"); }
           | OR { printf("Comparison: ||\n"); }
           ;

if_statement : IF '(' condition ')' '{' stmlist '}' { printf("If statement: if ( condition ) { stmlist }\n"); }
             | IF '(' condition ')' '{' stmlist '}' ELSE '{' stmlist '}' { printf("If statement: if ( condition ) { stmlist } else { stmlist }\n"); }
             ;

while_statement : WHILE '(' condition_list ')' '{' stmlist '}' { printf("While statement: while ( condition ) { stmlist }\n"); }
                ;

%%

int main (void) {
    return yyparse ();
}

int yyerror (char *msg) {
    fprintf (stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
    return 0;
}
