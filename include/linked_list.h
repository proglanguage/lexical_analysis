#ifndef __LINKED_LIST_H__
#define __LINKED_LIST_H__

#include <stdio.h>
#include <stdlib.h>
#define LISTEND -1

typedef struct _cell_list
{
    struct _cell_list* prev;
    struct _cell_list* next;
    void* value;
}cell_list;


typedef struct _list
{
    // int capacity;
    int t_size;
    int size;
    cell_list* head;
    cell_list* tail;

    /** Methods **/
    int (*push)(struct _list*, void*);
    void* (*get)(struct _list*, int);
    void* (*remove)(struct _list*, int);
    int (*clean)(struct _list*);
    int (*is_empty)(struct _list*);
}list;

list* create_ll(int t_size);

int push_in_ll(list* ll, void* val);

void* get_from_ll(list* ll, int index);

void* remove_from_ll(list* ll, int index);

int clean_ll(list* ll);

int ll_is_empty(list* ll);

#endif /** __LINKED_LIST_H__ **/