#ifndef __LINKED_LIST_H__
#define __LINKED_LIST_H__

#include <stdio.h>
#include <stdlib.h>
#define LISTEND -1

typedef struct cell_list
{
    struct cell_list* prev;
    struct cell_list* next;
    void* value;
}cell_list;


typedef struct list
{
    // int capacity;
    int t_size;
    int size;
    cell_list* head;
    cell_list* tail;

    /** Methods **/
    int (*push)(struct list*, void*);
    void* (*get)(struct list*, int);
    void* (*remove)(struct list*, int);
    int (*clean)(struct list*);
    int (*is_empty)(struct list*);
}list;

list* create_ll(int t_size);

int push_in_ll(list* ll, void* val);

void* get_from_ll(list* ll, int index);

void* remove_from_ll(list* ll, int index);

int clean_ll(list* ll);

int ll_is_empty(list* ll);

#endif /** __LINKED_LIST_H__ **/