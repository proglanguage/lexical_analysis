#ifndef __HASH_TABLE_H__
#define __HASH_TABLE_H__

/** \headerfile hash_table.h "hash_table.h"
 *  This file is the header with informations to use this hash_table
 *  \author Ailson F. dos Santos ailsonforte@hotmail.com
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "linked_list.h"
#include "symbols.h"

typedef union _info {
    var_info* var; ///< Variable informations
    proc_info* proc; ///< Procedure informations
    func_info* func; ///< Function infomations
}info; ///< An union type that can store variables, functions and procedures informations

typedef struct _node
{
    char* key; ///< ht_node field that stores the key of the node
    info value; ///< ht_node field that stores a value to the node
}ht_node; ///< \typedef A structure to store code informations

typedef struct _hash_table
{
    int size; ///< The number of columns in the "table"
    void** items; ///< The items list storing all data in the table

    /** Methods **/
    int (*hash)(char*); ///< Method that calculate the hash
    int (*insert)(struct _hash_table*, ht_node*); ///< Method to store an object in the table
    ht_node* (*get)(struct _hash_table*, char*); ///< Method that recover an object data stored in the table
    ht_node* (*purge)(struct _hash_table*, char*); ///< Method the delete an object in the table
    int (*destroy)(struct _hash_table*); ///< Method the clean the table and free the pointer
}hash_table;

/** \fn hash_table* create_ht(int size)
 *   A constructor for a hash table
 * 
 *  \param size the number of colums used by the hash table
 */
hash_table* create_ht(int size);

int _hash(char* value);

int ht_insert(hash_table* ht, ht_node* value);

ht_node* ht_get(hash_table* ht, char* key);

ht_node* ht_purge(hash_table* ht, char* key);

int destroy_ht(hash_table* ht);

#endif /** __HASH_TABLE_H__ **/