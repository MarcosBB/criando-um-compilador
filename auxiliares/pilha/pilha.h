// doubly_linked_list.h

#ifndef DOUBLY_LINKED_LIST_H
#define DOUBLY_LINKED_LIST_H

#include <stdio.h>
#include <stdlib.h>

// Estrutura de nó da lista duplamente encadeada
struct node {
    char * data;
    struct node* next;
    struct node* prev;
};

// Declaração dos ponteiros para a cabeça e a cauda da lista
extern struct node* head;
extern struct node* tail;

// Funções para manipulação da lista duplamente encadeada
struct node* create_node(char * data);
void insert_at_head(char * data);
void insert_at_tail(char * data);
void delete_at_head();
void delete_at_tail();
void display_forward();
void display_backward();

#endif // DOUBLY_LINKED_LIST_H
