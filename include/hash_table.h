#ifndef __HASH_TABLE_H__
#define __HASH_TABLE_H__

#include <stdio.h>
#include <stdlib.h>
#include "linked_list.h"
#include "symbols.h"

typedef struct _node
{
    char* key;
    union info {
        var_info* var;
        proc_info* proc;
    } value;
    struct _node* next;
}node;

int hash(char* value);

int insert(node* value);

node* get(char* key);

node* purge(char* key);

#endif /** __HASH_TABLE_H__ **/