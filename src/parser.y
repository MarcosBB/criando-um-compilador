%{
#include <stdio.h>
#include <stdlib.h>
#include "./auxiliares/registro/record.h"
#include "./auxiliares/pilha/pilha.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char *yytext;

%}

%union {
    struct record * rec;
    char  *sValue; /* string value */
    bool bValue;
}

%token <sValue> ID
%token <sValue> INTEGER
%token <sValue> REAL
%token <sValue> LIT_STRING P_TYPE
%token <sValue> BOOLEAN

%token WHILE FOR IF ELSE ELIF SEMI ASSIGN EQUAL FUNCTION RETURN AND OR NOT NOT_EQUAL INCREMENT DECREMENT IN PLUS MINUS TIMES DIVIDE LESS_EQUAL GREATER_EQUAL LESS GREATER

%type <rec> prog stmlist stm assignment var type list function params paramslist condition comparison if_statement while_statement for_statement 
%type <rec> expr term var_list list_value

%left OR
%left AND
%left EQUAL NOT_EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT

%start prog
%%

prog : subprogs_list { printf("Program\n");  }
     ;

subprogs_list : subprog { printf("Subprog_list: subprog\n"); }
              | subprogs_list subprog { printf("Subprogs_list: subprogs_list SEMI subprog\n"); }
              ;

subprog : function { printf("Subprog: function\n"); }
        
        ;

stm : assignment SEMI { printf("Statement: assignment\n"); }
    | function { printf("Statement: function\n"); }
    | if_statement { printf("Statement: if_statement\n"); }
    | while_statement { printf("Statement: while_statement\n"); }
    | for_statement { printf("Statement: for_statement\n"); }
    | return_statement SEMI { printf("Statement: return\n"); }
    | function_call SEMI { printf("Statement: function_call\n"); }
    ;

stmlist : stm { printf("Statement list: single\n"); }
        | stm stmlist  { printf("Statement list: multiple\n"); }
        ;

assignment : type ID ASSIGN expr{ printf("Assignment: type %s << expr\n", $2); }
           | type ID ASSIGN function_call {}
           | ID ASSIGN expr { printf("Assignment: id << expr\n"); }
           | list_value ASSIGN expr { printf("Assignment: list_value << expr\n"); }
           | ID INCREMENT { printf("Assignment: id++\n"); }
           | ID DECREMENT { printf("Assignment: id--\n"); }
           | ID ASSIGN function_call { printf("Assignment: function_call"); }
           ;

return_statement : RETURN { printf("Return: empty\n"); }
                 | RETURN expr { printf("Return: expr\n"); }
                 ;

expr : term{ printf("Expr: term\n"); $$ = $1;}
     | expr PLUS term { printf("Expr: expr + term\n"); $$ = $1 + $3;}
     | expr MINUS term { printf("Expr: expr - term\n"); $$ = $1 - $3;}
     | '('expr')'{ printf("Expr: (exp)\n"); $$ = $2;}
     ;

term : var { printf("Term: var\n"); $$ = $1;}
     | term TIMES var { printf("Term: term * var\n"); $$ = $1 * $3;}
     | term DIVIDE var { printf("Term: term / var\n"),; $$ = $1 / $3;}
     ;

var : INTEGER { printf("Var: integer\n"); $$ = $1;}
    | REAL { printf("Var: real\n"); $$ = $1;}
    | list_value { printf("Var: list_value\n"); $$ = $1; }
    | ID                        { 
                                    printf("Var: id\n"); $$ = $1;
                                    createRecord($1, look_up();
                                }
    | BOOLEAN { printf("Var: boolean\n"); $$ = $1;}
    | LIT_STRING { printf("Var: string\n"); $$ = $1;}
    ;

var_list : var { printf("Var_list: var\n"); }
         | var_list ',' var { printf("Var_list , Var\n");;}
         | { printf("Var_list: empty\n"); }
         ;

type : P_TYPE { printf("Type: P_TYPE\n"); }
     | list { printf("Type: list\n"); }
     ;

list : P_TYPE LESS type GREATER { printf("List: P_TYPE < type >\n");}
     ;

list_value : ID '[' index ']' { printf("List_value: ID[index]\n"); $$ = $1}
           | '[' var_list ']' { printf("List_value: Var_list\n");}
           ;

index : ID { printf("Index: ID\n"); }
      | INTEGER { printf("Index: INTEGER\n"); }
      ;

function : FUNCTION type ID '(' paramslist ')' '{' stmlist '}' { printf("Function: function definition\n"); }
         ;

function_call : ID '(' paramslist ')'  { printf("Function_call: ID(paramslist)\n"); }
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

condition_list : condition { printf("Condition_list: condition\n"); }
               | condition_list comparison condition { printf("Condition_list: condition_list comparison condition\n"); }
               ;

comparison : EQUAL { printf("Comparison: ==\n"); }
           | NOT_EQUAL { printf("Comparison: !=\n"); }
           | LESS { printf("Comparison: <\n"); }
           | GREATER { printf("Comparison: >\n"); }
           | LESS_EQUAL { printf("Comparison: <=\n"); }
           | GREATER_EQUAL { printf("Comparison: >=\n"); }
           | AND { printf("Comparison: &&\n"); }
           | OR { printf("Comparison: ||\n"); }
           ;

if_statement : IF '(' condition_list ')' '{' stmlist '}' { printf("If statement: if ( condition_list ) { stmlist }\n"); }
             | IF '(' condition_list ')' '{' stmlist '}' else_if_statements ELSE  '{' stmlist '}' { printf("If statement: if ( condition_list ) { stmlist } else_if_statements\n"); }
             ;

else_if_statements : ELIF '(' condition_list ')' '{' stmlist '}' else_if_statements { printf("Else if statement: elif ( condition list ) { stmlist }\n"); }
                   | { printf("Else if statements: empty\n"); }
                   ;


while_statement : WHILE '(' condition_list ')' '{' stmlist '}' { printf("While statement: while ( condition_list ) { stmlist }\n"); }
                ;

for_statement : FOR '(' assignment ';' condition ';' assignment ')' '{' stmlist '}' { printf("For statement: for ( assignment ; condition ; assignment ) { stmlist }\n"); }
              | FOR '(' P_TYPE ID IN ID ')' '{' stmlist '}' { printf("For statement: for ( type id in id ) { stmlist }\n"); }
              ;

%%

int main(void) {
    return yyparse();
}

int yyerror(char *msg) {
    fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
    return 0;
}
