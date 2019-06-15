#ifndef __HASH_TABLE_H__
#define __HASH_TABLE_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "linked_list.h"
#include "symbols.h"

typedef union _info {
    var_info* var;
    proc_info* proc;
    func_info* func;
}info;

typedef struct _node
{
    char* key;
    info value;
}node;

typedef struct _hash_table
{
    int size;
    void** items;

    /** Methods **/
    int (*hash)(char*);
    int (*insert)(struct _hash_table*, node*);
    node* (*get)(struct _hash_table*, char*);
    node* (*purge)(struct _hash_table*, char*);
    int (*destroy)(struct _hash_table*);
}hash_table;

hash_table* create_ht(int size);

int _hash(char* value);

int ht_insert(hash_table* ht, node* value);

node* ht_get(hash_table* ht, char* key);

node* ht_purge(hash_table* ht, char* key);

int destroy_ht(hash_table* ht);

#endif /** __HASH_TABLE_H__ **/