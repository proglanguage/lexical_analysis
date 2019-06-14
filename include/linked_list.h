#ifndef __LINKED_LIST_H__
#define __LINKED_LIST_H__

#include <stdio.h>
#include <stdlib.h>

typedef struct _cell_list
{
    struct _cell_list* prev;
    struct _cell_list* next;
    char* value;
}cell_list;


typedef struct _list
{
    int capacity;
    cell_list* head;
    cell_list* tail;
    cell_list* body;
}list;

int push(cell_list* val);

cell_list* pop(cell_list* val);

int clean();

int isEmpty();

#endif /** __LINKED_LIST_H__ **/