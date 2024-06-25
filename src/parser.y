
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
extern FILE * yyin, * yyout;

char * cat(char *, char *, char *, char *, char *);

hash_table_base *symbols_table;
hash_table_base *abstractions_table;
struct node *escopo_stack;
%}

%union {
    struct record * rec;
    char  *sValue;
}

%token <sValue> ID
%token <sValue> INTEGER
%token <sValue> REAL
%token <sValue> LIT_STRING P_TYPE 

%token WHILE FOR IF ELSE ELIF SEMI FUNCTION ASSIGN EQUAL RETURN AND OR NOT NOT_EQUAL INCREMENT DECREMENT IN PLUS MINUS TIMES DIVIDE LESS_EQUAL GREATER_EQUAL LESS GREATER
%token PRINT MAIN

%type <rec> prog stmlist print_command concat_string main stm variable_decl assignment type list function_call params paramslist condition comparison if_statement while_statement for_statement subprog return
%type <rec> expr term var_list list_value subprogs_list
%type <sValue> var index condition_list

%left OR
%left AND
%left EQUAL NOT_EQUAL LESS GREATER LESS_EQUAL GREATER_EQUAL
%left PLUS MINUS
%left TIMES DIVIDE
%right NOT

%start prog
%%

prog : subprogs_list main {
        printf("%s %s\n", $1->code, $2->code);
        char *s = cat($1->code, "\n",  $2->code, "", "");
        fprintf(yyout, "%s", s);
        free(s);
        freeRecord($1);
        freeRecord($2);
        free(escopo_stack);
        free(symbols_table);
        free(abstractions_table);
    }
    ;

main : FUNCTION type MAIN '(' ')' '{' stmlist '}' {
        char *s = cat("int main(){\n", $7->code, "}", "", "");
        freeRecord($7);
        $$ = createRecord(s, "");
        free(s);
    }
    ;

subprogs_list : subprog {
        printf("Subprog_list: subprog\n");
        $$ = createRecord($1->code, "");
        freeRecord($1);
    }
    | subprogs_list subprog {
        printf("Subprogs_list: %s ; %s\n", $1->code, $2->code);
        char *s1 = cat($1->code, "\n", $2->code, "", "");
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
        printf("Subprog: %s\n", s3);
        $$ = createRecord(s3, "");
        free(s1);
        free(s2);
        free(s3);
        freeRecord($2);
        freeRecord($5);
        freeRecord($8);
        free($3);
    }
    ;

stm : assignment SEMI {
        printf("Statement: %s;\n", $1->code);
        char *s1 = cat($1->code, ";\n", "", "", "");
        $$ = createRecord(s1, "");
        free(s1);
        freeRecord($1);
    }
    | if_statement { printf("Statement: if_statement\n"); }
    | while_statement { printf("Statement: while_statement\n"); }
    | for_statement { printf("Statement: for_statement\n"); }
    | return SEMI {
        printf("Statement: return %s\n", $1->code);
        char *s1 = cat("\t", $1->code, ";\n", "", "");
        $$ = createRecord(s1, "");
        freeRecord($1);
        free(s1);
    }
    | function_call SEMI {
        printf("Statement: function_call\n");
        char *s1 = cat($1->code, ";\n", "", "", "");
        $$ = createRecord(s1, "");
        freeRecord($1);
        free(s1);
    }
    | variable_decl SEMI {
        printf("Statement: variable_decl = %s\n", $1->code);
        char *s1 = cat($1->code, ";\n", "", "", "");
        printf("%s\n", ";");
        printf("%s\n", s1);
        $$ = createRecord(s1, "");
        free(s1);
        freeRecord($1);
    }
    | print_command SEMI {
        printf("Statement: print_command = %s\n", $1->code);
        char *s1 = cat("\t", $1->code, ";\n", "", "");
        printf("%s\n", ";");
        printf("%s\n", s1);
        $$ = createRecord(s1, "");
        free(s1);
        freeRecord($1);
    }
    ;

stmlist : stm {
        printf("Statement list: %s\n", $1->code);
        $$ = createRecord($1->code, "");
        freeRecord($1);
    }
    | stm stmlist {
        printf("Statement list: multiple\n");
        char *s1 = cat($1->code, $2->code, "", "", "");
        $$ = createRecord(s1, "");
        freeRecord($1);
        freeRecord($2);
        free(s1);
    }
    ;

variable_decl : type ID {
        printf("Variable Declaration: %s \n", $2);
        char *escopo = top();
        char *key = cat(escopo, "#", $2, "", "");
        hash_table_set(symbols_table, key, $1->type);
        char *s1 = cat($1->code, " ", $2, "", "");
        $$ = createRecord(s1, "");
    }
    ;

assignment : type ID ASSIGN expr {
        char *s1 = cat($1->type, " ", $2, " ", "=");
        char *s2 = cat(s1, " ", $4->code, "", "");
        char *escopo = top();
        char *key = cat(escopo, "#", $2, "", "");
        printf("Assignment: %s\n", s2);
        hash_table_set(symbols_table, key, $1->type);
        $$ = createRecord(s2, "");
        free(s1);
        free(s2);
        free($2);
        freeRecord($1);
        freeRecord($4);
    }
    | type ID ASSIGN function_call {   
        char *s1 = cat($1->type, " ", $2, " ", "=");
        char *s2 = cat(s1, " ", $4->code, "", "");
        char *escopo = top();
        char *key = cat(escopo, "#", $2, "", "");
        printf("Assignment: %s\n", s2);
        hash_table_set(symbols_table, key, $1->type);
        $$ = createRecord(s2, "");
        free(s1);
        free(s2);
        free($2);
        freeRecord($1);
        freeRecord($4);
    } 
    | ID ASSIGN expr { printf("Assignment: id = expr\n"); }
    | list_value ASSIGN expr { printf("Assignment: list_value = expr\n"); }
    | ID INCREMENT { printf("Assignment: id++\n"); }
    | ID DECREMENT { printf("Assignment: id--\n"); }
    | ID ASSIGN function_call {
        printf("Assignment: function_call");
    }
    ;

return : RETURN expr {
        printf("Statement: return %s\n", $2->code);
        char *s1 = cat("return", " ", $2->code, "", "");
        $$ = createRecord(s1, "");
        freeRecord($2);
        free(s1);
    }
    ;

expr : term {
        printf("Expr: %s\n", $1->code);
        $$ = createRecord($1->code, "");
        freeRecord($1);
    }
    | expr PLUS term { 
        printf("Expr: %s + %s\n", $1->code, $3->code);
        char *s1 = cat($1->code, "+", $3->code, "", "");
        $$ = createRecord(s1, "");
        free(s1);
        freeRecord($1);
        freeRecord($3);
    }
    | expr MINUS term {
        printf("Expr: %s - %s\n", $1->code, $3->code);
        char *s1 = cat($1->code, "-", $3->code, "", "");
        $$ = createRecord(s1, "");
        free(s1);
        freeRecord($1);
        freeRecord($3);
    }
    | expr TIMES term { printf("Expr: %s * %s\n", $1->code, $3->code); }
    | expr DIVIDE term { printf("Expr: %s / %s\n", $1->code, $3->code); }
    ;

term : ID {
        char *escopo = top();
        char *key = cat(escopo, "#", $1, "", "");
        struct record *value = hash_table_get(symbols_table, key);
        printf("Term: %s\n", $1);
        $$ = createRecord($1, value->type);
        free($1);
    }
    | INTEGER {
        printf("Term: %s\n", $1);
        $$ = createRecord($1, "int");
    }
    | REAL {
        printf("Term: %s\n", $1);
        $$ = createRecord($1, "real");
    }
    | LIT_STRING {
        printf("Term: %s\n", $1);
        $$ = createRecord($1, "string");
    }
    | list_value { printf("Term: list_value\n"); }
    | function_call { printf("Term: function_call\n"); }
    ;

type : P_TYPE { 
        printf("Type: %s\n", $1);
        $$ = createRecord("", $1);
    }
    | P_TYPE index { 
        char *s1 = cat($1, $2, "", "", "");
        printf("Type: %s\n", s1);
        $$ = createRecord("", s1);
        free(s1);
        free($2);
    }
    ;

comparison : expr LESS expr { printf("Comparison: expr < expr\n"); }
    | expr GREATER expr { printf("Comparison: expr > expr\n"); }
    | expr LESS_EQUAL expr { printf("Comparison: expr <= expr\n"); }
    | expr GREATER_EQUAL expr { printf("Comparison: expr >= expr\n"); }
    | expr EQUAL expr { printf("Comparison: expr == expr\n"); }
    | expr NOT_EQUAL expr { printf("Comparison: expr != expr\n"); }
    ;

condition : comparison { printf("Condition: comparison\n"); }
    | condition AND condition { printf("Condition: cond AND cond\n"); }
    | condition OR condition { printf("Condition: cond OR cond\n"); }
    | NOT condition { printf("Condition: NOT cond\n"); }
    | '(' condition ')' { printf("Condition: (condition)\n"); }
    ;

if_statement : IF '(' condition ')' '{' stmlist '}' {
        char *s1 = cat("if(", $3->code, ")", "\n", "{\n");
        char *s2 = cat(s1, $6->code, "}\n", "", "");
        printf("IF statement: %s\n", s2);
        $$ = createRecord(s2, "");
        freeRecord($3);
        freeRecord($6);
        free(s1);
        free(s2);
    }
    | IF '(' condition ')' '{' stmlist '}' elif_list {
        printf("IF statement: IF, ELIF\n");
    }
    | IF '(' condition ')' '{' stmlist '}' else_statement {
        printf("IF statement: IF, ELSE\n");
    }
    | IF '(' condition ')' '{' stmlist '}' elif_list else_statement {
        printf("IF statement: IF, ELIF, ELSE\n");
    }
    ;

elif_list : ELIF '(' condition ')' '{' stmlist '}' { printf("ELIF statement\n"); }
    | elif_list ELIF '(' condition ')' '{' stmlist '}' { printf("ELIF list\n"); }
    ;

else_statement : ELSE '{' stmlist '}' { printf("ELSE statement\n"); }
    ;

while_statement : WHILE '(' condition ')' '{' stmlist '}' {
        printf("While statement\n");
        char *s1 = cat("while(", $3->code, ")\n{\n", $6->code, "}\n");
        $$ = createRecord(s1, "");
        free(s1);
        freeRecord($3);
        freeRecord($6);
    }
    ;

for_statement : FOR '(' assignment SEMI condition SEMI assignment ')' '{' stmlist '}' {
        printf("For statement\n");
        char *s1 = cat("for(", $3->code, ";", $5->code, ";");
        char *s2 = cat(s1, $7->code, "){\n", $10->code, "}\n");
        $$ = createRecord(s2, "");
        free(s1);
        free(s2);
        freeRecord($3);
        freeRecord($5);
        freeRecord($7);
        freeRecord($10);
    }
    ;

function_call : ID '(' paramslist ')' {
        printf("Function call: %s\n", $1);
        char *s1 = cat($1, "(", $3->code, ")", "");
        $$ = createRecord(s1, "");
        free(s1);
        free($1);
        freeRecord($3);
    }
    ;

paramslist : params {
        $$ = createRecord($1->code, "");
        freeRecord($1);
    }
    | params ',' paramslist {
        printf("Parameter list: multiple\n");
        char *s1 = cat($1->code, ",", $3->code, "", "");
        $$ = createRecord(s1, "");
        free(s1);
        freeRecord($1);
        freeRecord($3);
    }
    | {
        $$ = createRecord("", "");
    }
    ;

params : ID {
        printf("Parameter: %s\n", $1);
        $$ = createRecord($1, "");
        free($1);
    }
    | ID '=' expr {
        printf("Parameter: %s = %s\n", $1, $3->code);
        char *s1 = cat($1, "=", $3->code, "", "");
        $$ = createRecord(s1, "");
        free(s1);
        free($1);
        freeRecord($3);
    }
    | type ID {
        printf("Parameter: %s %s\n", $1->type, $2);
        char *s1 = cat($1->type, " ", $2, "", "");
        $$ = createRecord(s1, "");
        freeRecord($1);
        free(s1);
        free($2);
    }
    | type ID '=' expr {
        printf("Parameter: %s %s = %s\n", $1->type, $2, $4->code);
        char *s1 = cat($1->type, " ", $2, "=", $4->code);
        $$ = createRecord(s1, "");
        freeRecord($1);
        freeRecord($4);
        free(s1);
        free($2);
    }
    ;

print_command : PRINT '(' concat_string ')' {
        printf("Print: %s\n", $3->code);
        char *s1 = cat("printf(", $3->code, ");", "", "");
        $$ = createRecord(s1, "");
        free(s1);
        freeRecord($3);
    }
    ;

concat_string : LIT_STRING {
        printf("Concat: %s\n", $1);
        char *s1 = cat("\"", $1, "\"", "", "");
        $$ = createRecord(s1, "");
        free(s1);
    }
    | concat_string '+' LIT_STRING {
        printf("Concat: %s + %s\n", $1->code, $3);
        char *s1 = cat($1->code, " + ", "\"", $3, "\"");
        $$ = createRecord(s1, "");
        free(s1);
        freeRecord($1);
    }
    | concat_string '+' ID {
        printf("Concat: %s + %s\n", $1->code, $3);
        char *s1 = cat($1->code, " + ", $3, "", "");
        $$ = createRecord(s1, "");
        free(s1);
        freeRecord($1);
        free($3);
    }
    ;

list_value : ID index {
        printf("List value: %s %s\n", $1, $2);
        char *s1 = cat($1, $2, "", "", "");
        $$ = createRecord(s1, "");
        free($1);
        free($2);
        free(s1);
    }
    ;

index : '[' expr ']' {
        printf("Index: [expr]\n");
        char *s1 = cat("[", $2->code, "]", "", "");
        $$ = s1;
        freeRecord($2);
    }
    | index '[' expr ']' {
        printf("Index: index [expr]\n");
        char *s1 = cat($1, "[", $3->code, "]", "");
        $$ = s1;
        free($1);
        freeRecord($3);
    }
    ;

list : ID index {
        printf("List: %s %s\n", $1, $2);
        char *s1 = cat($1, $2, "", "", "");
        $$ = createRecord(s1, "");
        free($1);
        free($2);
        free(s1);
    }
    ;

%%

char * cat(char *a, char *b, char *c, char *d, char *e) {
    char *s = (char *) malloc(strlen(a) + strlen(b) + strlen

(c) + strlen(d) + strlen(e) + 1);
    strcpy(s, a);
    strcat(s, b);
    strcat(s, c);
    strcat(s, d);
    strcat(s, e);
    return s;
}

char* top() {
    if (stackIndex < 0) {
        return NULL;
    }
    return scope_stack[stackIndex];
}

void push(char * scope) {
    stackIndex++;
    scope_stack[stackIndex] = strdup(scope);
}

void pop() {
    if (stackIndex >= 0) {
        free(scope_stack[stackIndex]);
        stackIndex--;
    }
}

void print_stack() {
    printf("Scope stack: ");
    for (int i = 0; i <= stackIndex; i++) {
        printf("%s ", scope_stack[i]);
    }
    printf("\n");
}

char* new_label() {
    char label[10];
    sprintf(label, "L%d", labelCounter);
    labelCounter++;
    return strdup(label);
}

struct record* createRecord(char* code, char* type) {
    struct record* rec = (struct record*) malloc(sizeof(struct record));
    rec->code = strdup(code);
    rec->type = strdup(type);
    return rec;
}

void freeRecord(struct record* rec) {
    if (rec) {
        if (rec->code) free(rec->code);
        if (rec->type) free(rec->type);
        free(rec);
    }
}

void yyerror(char *s) {
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv) {
    if (argc != 2) {
        fprintf(stderr, "Usage: %s <source-file>\n", argv[0]);
        exit(1);
    }
    
    FILE *file = fopen(argv[1], "r");
    if (!file) {
        fprintf(stderr, "Error opening file: %s\n", argv[1]);
        exit(1);
    }

    yyin = file;
    
    symbols_table = hash_table_create();
    
    yyparse();

    fclose(file);
    hash_table_destroy(symbols_table);

    return 0;
}