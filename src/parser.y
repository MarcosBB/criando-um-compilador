%{
#include <stdio.h>
#include <stdlib.h>
#include "./auxiliares/registro/record.h"
#include "./auxiliares/pilha/pilha.h"
#include "./auxiliares/hash_table/hash-table.h"

int yylex(void);
int yyerror(char *s);
extern int yylineno;
extern char *yytext;

char * cat(char *, char *, char *, char *, char *);

hash_table_base *symbols_table;
hash_table_base *abstractions_table;
struct node *escopo_stack;



%}

%union {
    struct record * rec;
    char  *sValue; /* string value */
}

%token <sValue> ID
%token <sValue> INTEGER
%token <sValue> REAL
%token <sValue> LIT_STRING P_TYPE 

%token WHILE FOR IF ELSE ELIF SEMI FUNCTION ASSIGN EQUAL RETURN AND OR NOT NOT_EQUAL INCREMENT DECREMENT IN PLUS MINUS TIMES DIVIDE LESS_EQUAL GREATER_EQUAL LESS GREATER


%type <rec> prog stmlist stm variable_decl assignment type list function_call params paramslist condition comparison if_statement while_statement for_statement subprog return
%type <rec> expr term var_list list_value subprogs_list
%type <sValue> var

%left OR
%left AND
%left EQUAL NOT_EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT

%start prog
%%

prog : subprogs_list                        {
                                                printf("Program\n");
                                                printf("C code\n");
                                                printf("%s\n", $1 -> code);
                                                freeRecord($1);
                                                free(escopo_stack);
                                                free(symbols_table);
                                                free(abstractions_table);
                                            }
     ;

subprogs_list : subprog                     {
                                                printf("Subprog_list: subprog\n");
                                                $$ = createRecord($1 ->code, "");
                                                freeRecord($1);
                                            }
              | subprogs_list subprog       {
                                                printf("Subprogs_list: %s ; %s\n", $1->code, $2->code);
                                                char *s1 = cat($1->code,"\n", $2->code, "","");

                                                $$ = createRecord(s1, "");
                                                free(s1);
                                                freeRecord($1);
                                                freeRecord($2);
                                            }
              ;

subprog : FUNCTION type ID '(' paramslist ')' '{' stmlist '}' { 
                                                                    char *s1 = cat($2->type, " ", $3, "","");
                                                                    char *s2 = cat(s1, "(", $5->code, ")","");
                                                                    char *s3 = cat(s2, "{\n", "\t", $8->code, "}");
                                                                    printf("Subprog: %s\n",s3);

                                                        
                                                                    $$ = createRecord(s3,"");
                                                                    free(s1);
                                                                    free(s2);
                                                                    free(s3);
                                                                    freeRecord($2);
                                                                    freeRecord($5);
                                                                    freeRecord($8);
                                                                    free($3);
                                                                }
         ;

stm : assignment SEMI                                           {
                                                                    printf("Statement: %s;\n", $1->code);

                                                                    char *s1 = cat($1->code, ";\n","","", "");
                                                                    $$ = createRecord(s1, "");

                                                                    free(s1);
                                                                    freeRecord($1);
                                                                }
    | if_statement { printf("Statement: if_statement\n"); }
    | while_statement { printf("Statement: while_statement\n"); }
    | for_statement { printf("Statement: for_statement\n"); }
    | return SEMI                      {
                                                printf("Statement: return %s\n", $1->code);
                                                char *s1 = cat($1->code, ";\n" , "","", "");

                                                $$ = createRecord(s1,"");
                                                freeRecord($1);
                                                free(s1);
                                            }
    | function_call SEMI                    {
                                                printf("Statement: function_call\n");
                                                char *s1 = cat($1->code, ";\n","","","");
                                                $$ = createRecord(s1,"");
                                                freeRecord($1);
                                                free(s1);
                                            }
    | variable_decl SEMI                    {
                                                printf("Statement: variable_decl = %s\n", $1 -> code);

                                                char *s1 = cat($1->code, ";\n","","","");
                                                printf("%s\n", ";");
                                                printf("%s\n", s1);
                                                $$ = createRecord(s1, "");
                                                free(s1);
                                                freeRecord($1);
                                            }
    ;

stmlist : stm                                   { 
                                                    printf("Statement list: %s\n", $1->code);

                                                    $$ = createRecord($1->code, "");
                                                    freeRecord($1);
                                                }
        | stm stmlist                           { 
                                                    printf("Statement list: multiple\n");
                                                    char *s1 = cat($1->code, $2->code, "", "","");
                                                    $$ = createRecord(s1, "");
                                                    freeRecord($1);
                                                    freeRecord($2);
                                                    free(s1);
                                                }
        ;

variable_decl: type ID                                  {printf("Variable Declaration: %s \n", $2);
                                                            char *escopo = top();
                                                            char *key = cat(escopo, "#", $2, "", "");
                                                            
                                                            
                                                           
                                                            hash_table_set(symbols_table, key, $1 -> type);
                                                            char* s1 = cat($1 -> code, " ", $2, "","");
                                                            $$ = createRecord(s1, "");
                                                       
                                                            }
            ;

assignment : type ID ASSIGN expr            {
                                                char *s1 = cat($1->type, " ", $2, " ", "<<");
                                                char *s2 = cat(s1, " ", $4->code,"","");
                                                char *escopo = top();
                                                char *key = cat(escopo, "#", $2,"","");
                                                printf("Assignment: %s\n", s2);

                                                hash_table_set(symbols_table, key, $1->type);

                                                $$ = createRecord(s2,"");
                                                free(s1);
                                                free(s2);
                                                free($2);
                                                freeRecord($1);
                                                freeRecord($4);

                                            }
           | type ID ASSIGN function_call   {   
                                                char *s1 = cat($1->type, " ", $2, " ", "<<");
                                                char *s2 = cat(s1, " ", $4->code,"","");
                                                char *escopo = top();
                                                char *key = cat(escopo, "#", $2,"","");
                                                printf("Assignment: %s\n", s2);

                                                hash_table_set(symbols_table, key, $1->type);

                                                $$ = createRecord(s2,"");
                                                free(s1);
                                                free(s2);
                                                free($2);
                                                freeRecord($1);
                                                freeRecord($4);

                                            } 
           | ID ASSIGN expr { printf("Assignment: id << expr\n"); }
           | list_value ASSIGN expr { printf("Assignment: list_value << expr\n"); }
           | ID INCREMENT { printf("Assignment: id++\n"); }
           | ID DECREMENT { printf("Assignment: id--\n"); }
           | ID ASSIGN function_call        {
                                                printf("Assignment: function_call");

                                            }
           ;

return: RETURN expr                         {
                                                printf("Statement: return %s\n", $2->code);
                                                char *s1 = cat("return", " ", $2->code, "", "");

                                                $$ = createRecord(s1,"");
                                                freeRecord($2);
                                                free(s1);
                                            }

expr : term                                 {
                                                printf("Expr: %s\n", $1->code);

                                                $$ = createRecord($1->code, "");
                                                freeRecord($1);
                                            }
     | expr PLUS term                       { 
                                                printf("Expr: %s + %s\n", $1->code, $3->code);

                                                char *s1 = cat($1->code, "+", $3->code,"","");

                                                $$ = createRecord(s1,"");
                                                free(s1);
                                                freeRecord($1);
                                                freeRecord($3);
                                            }
     | expr MINUS term                      {
                                                printf("Expr: %s - %s\n", $1->code, $3->code);

                                                char *s1 = cat($1->code, "-", $3->code,"","");

                                                $$ = createRecord(s1,"");
                                                free(s1);
                                                freeRecord($1);
                                                freeRecord($3);
                                            }
     | '(' expr ')'                         {
                                                printf("Expr: (%s)\n", $2->code);

                                                char *s1 = cat("(", $2->code, ")","","");

                                                $$ = createRecord(s1,"");
                                                free(s1);
                                                freeRecord($2);
                                            }
     ;

term : var                                  {
                                                printf("Term: %s\n", $1);

                                                $$ = createRecord($1,"");
                                                
                                                free($1);
                                            }
     | term TIMES var                       {
                                                printf("Term: %s * %s\n", $1->code, $3);
                                                char *s1 = cat($1->code, "*", $3, "","");
                                                

                                                $$ = createRecord(s1,"");
                                                free(s1);
                                                freeRecord($1);
                                                free($3);
                                            }
     | term DIVIDE var                      {
                                                printf("Term: %s / %s\n", $1->code, $3);

                                                char *s1 = cat($1->code, "/", $3,"","");  

                                                $$ = createRecord(s1,"");
                                                free(s1);
                                                freeRecord($1);
                                                free($3);
                                            
                                            }
     ;

var : INTEGER                               {
                                                printf("Var: %s\n", $1);
                                                
                                                $$ = $1;
    
                                               
                                            }
    | REAL                                  {
                                                printf("Var: %s\n", $1);

                                                $$ = $1;
    
                                                
                                            }
    | ID                                    {
                                                printf("Var: %s\n", $1);
                                                
                                                $$ = $1;
    
                                                
                                            }
    | LIT_STRING { printf("Var: %s\n", $1); }
    | list_value { printf("Var: %s\n", $1->code);  }
    ;

var_list : var { printf("Var_list: var\n"); }
         | var_list ',' var { printf("Var_list , Var\n"); }
         | { printf("Var_list: empty\n"); }
         ;

type : P_TYPE                           {
                                            printf("Type: %s\n", $1); 
                                            $$ = createRecord($1, $1);
                                            free($1);
                                        }
     | list                             {
                                            printf("Type: list\n");
                                            $$ = createRecord($1->code, "");
                                            freeRecord($1);
                                        }
     ;

list : P_TYPE LESS type GREATER { printf("List: P_TYPE < type >\n"); }
     ;

list_value : ID '[' index ']' { printf("List_value: ID[index]\n");  }
           | '[' var_list ']' { printf("List_value: Var_list\n"); }
           ;

index : ID { printf("Index: ID\n"); }
      | INTEGER { printf("Index: INTEGER\n"); }
      ;

function_call : ID '(' paramslist ')'                   {
                                                            printf("Function_call: %s(%s)\n", $1, $3->code);
                                                            char *s1 = cat($1, "(", $3->code, ")", "");
                                                            $$ = createRecord(s1, "");
                                                            freeRecord($3);
                                                            free($1);
                                                            free(s1);
                                                        }
              ;

params : type ID                                        {
                                                            printf("Params: %s %s\n", $1->code, $2); 
                                                            char *s1 = cat($1->code, " ", $2, "", "");
                                                            char *key = cat(top(), "#", $2, "", "");

                                                            hash_table_set(symbols_table, key, $1->type);
                                                            $$ = createRecord(s1, "");
                                                            free(key);
                                                            free(s1);
                                                            free($2);
                                                            freeRecord($1);   
                                                        }
       | expr                                           { 
                                                            printf("Params: expr\n");
                                                            $$ = createRecord($1 -> code, "");
                                                            freeRecord($1);
                                                        }
       | { printf("Params: empty\n"); $$ = createRecord("", "");};
       ;

paramslist : params                                             { printf("Params list: single\n"); 
                                                                    $$ = createRecord($1 -> code, "");
                                                                    freeRecord($1); 
                                                                    }
           | params ',' paramslist                              { printf("Params list: multiple\n"); 
                                                                    char *s1 = cat($1->code, ",", $3->code, "","");
                                                                    freeRecord($1);
                                                                    freeRecord($3);
                                                                    $$ = createRecord(s1, "");
                                                                    free(s1);
                                                                }
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
    symbols_table = hash_table_create();
    abstractions_table = hash_table_create();
    escopo_stack = malloc(sizeof(struct node));
    insert_at_head("main");
    char *a_symbol = cat(top(), "#","A","","");
    hash_table_set(symbols_table,a_symbol, "float");
    return yyparse();
}

int yyerror(char *msg) {
    fprintf(stderr, "%d: %s at '%s'\n", yylineno, msg, yytext);
    return 0;
}
char * cat(char * s1, char * s2, char * s3, char * s4, char * s5){
  int tam;
  char * output;

  tam = strlen(s1) + strlen(s2) + strlen(s3) + strlen(s4) + strlen(s5)+ 1;
  output = (char *) malloc(sizeof(char) * tam);
  
  if (!output){
    printf("Allocation problem. Closing application...\n");
    exit(0);
  }
  
  sprintf(output, "%s%s%s%s%s", s1, s2, s3, s4, s5);
  
  return output;
}
