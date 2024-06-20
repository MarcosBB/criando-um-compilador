#include "pilha.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



Stack* createStack() {
    Stack *stack = (Stack *)malloc(sizeof(Stack));
    stack->top = NULL;
    return stack;
}

void push(Stack *stack, const char *escopo, const char *type) {
    Node *newNode = (Node *)malloc(sizeof(Node));
    newNode->escopo = strdup(escopo);
    newNode->type = strdup(type);
    newNode->next = stack->top;
    stack->top = newNode;
}

void pop(Stack *stack) {
    if (stack->top == NULL) {
        printf("Pilha está vazia!\n");
        return;
    }
    Node *temp = stack->top;
    stack->top = stack->top->next;
    free(temp->escopo);
    free(temp->type);
    free(temp);
}

Node* top(Stack *stack) {
    if (stack->top == NULL) {
        printf("Pilha está vazia!\n");
        return NULL;
    }
    return stack->top;
}

void freeStack(Stack *stack) {
    while (stack->top != NULL) {
        pop(stack);
    }
    free(stack);
}


