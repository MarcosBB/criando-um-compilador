#ifndef STACK
#define STACK

typedef struct Node {
    char *var;
    struct Node *next;
} Node;

typedef struct Stack {
    Node *top;
} Stack;

Stack* createStack();

void push(Stack *stack, const char *escopo, const char *type);

void pop(Stack *stack);

Node* top(Stack *stack);

void freeStack(Stack *stack);

#endif
