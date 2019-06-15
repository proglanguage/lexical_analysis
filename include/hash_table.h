#ifndef __HASH_TABLE_H__
#define __HASH_TABLE_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "linked_list.h"
#include "symbols.h"

/*! An union type that can store variables, functions and procedures informations
 * \union info
 * \typedef info
 *
 * \headerfile hash_table.h "hash_table.h"
 * \author Ailson F. dos Santos ailsonforte@hotmail.com
 * \var var
 * \var proc
 * \var func
 */
typedef union info {
    var_info* var; ///< Variable informations
    proc_info* proc; ///< Procedure informations
    func_info* func; ///< Function infomations
}info; ///< An union type that can store variables, functions and procedures informations

/*! A structure to store code informations
 * \struct ht_node
 * \typedef ht_node
 * 
 * \headerfile hash_table.h "hash_table.h"
 * \author Ailson F. dos Santos ailsonforte@hotmail.com
 * \var key ht_node field that stores the key of the node
 * \var value ht_node field that stores a value to the node
 */
typedef struct ht_node
{
    char* key; ///< ht_node field that stores the key of the node
    info value; ///< ht_node field that stores a value to the node
}ht_node; ///< \typedef ht_node A structure to store code informations

/*! A struct representing a hash table
 * \struct hash_table
 * \typedef hash_table
 *  
 * \headerfile hash_table.h "hash_table.h"
 * \author Ailson F. dos Santos ailsonforte@hotmail.com
 * \var size The number of columns in the "table"
 * \var items The items list storing all data in the table
 */
typedef struct hash_table
{
    int size; ///< The number of columns in the "table"
    void** items; ///< The items list storing all data in the table


    /* Methods */

    int (*hash)(char*); ///< Method that calculate the hash
    int (*insert)(struct hash_table*, ht_node*); ///< Method to store an object in the table
    ht_node* (*get)(struct hash_table*, char*); ///< Method that recover an object data stored in the table
    ht_node* (*purge)(struct hash_table*, char*); ///< Method the delete an object in the table
    int (*destroy)(struct hash_table*); ///< Method the clean the table and free the pointer
}hash_table; ///< \typedef hash_table A struct representing a hash table

///< \fn hash_table* create_ht(int size)
///< A constructor for a hash table
///< \param size the number of colums used by the hash table
///< \return a pointer to the new hash table
hash_table* create_ht(int size);

///< \fn int _hash(char* value)
///< A hash calculator
///< \param value the number of colums used by the hash table
///< \return the hash corresponded to the key
int _hash(char* value);

///< \fn int ht_insert(hash_table* ht, ht_node* value)
///< A insertion function.
///< \param ht a hash table to insert into it
///< \param value the ht_node to be stored
///< \return 1 if succeed
int ht_insert(hash_table* ht, ht_node* value);

///< \fn int ht_get(hash_table* ht, char* key)
///< A get function.
///< \param ht a hash table that will be analised
///< \param key the key to look for
///< \return the node searched
ht_node* ht_get(hash_table* ht, char* key);

///< \fn ht_node* ht_purge(hash_table* ht, char* key)
///< A remove function.
///< \param ht a hash table that will be analised
///< \param key the key to remove
///< \return the node removed
ht_node* ht_purge(hash_table* ht, char* key);

///< \fn int ht_purge(hash_table* ht)
///< A function to destroy the table.
///< \param ht a hash table to be destroyed
///< \return 1 if succeed
int destroy_ht(hash_table* ht);

#endif /** __HASH_TABLE_H__ **/