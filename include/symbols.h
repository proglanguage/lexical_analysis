#ifndef __SYMBOLS_H__
#define __SYMBOLS_H__

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "linked_list.h"

typedef struct var_info{
    char* id; ///> The alias to the variable
    char* type; ///> The type of the function
}var_info;

typedef struct proc_info{
    char* id; ///> The alias to the variable
    list* params; ///> Vector of var_info
}proc_info;

typedef struct func_info{
    char* id; ///> The alias to the variable
    char* r_type; ///> The type id of the return
    list* params; ///> Vector of var_info
}func_info;

/*! An struct type that can store variables, functions and procedures informations
 * \struct info
 * \typedef info
 *
 * \headerfile hash_table.h "hash_table.h"
 * \author Ailson F. dos Santos ailsonforte@hotmail.com
 * \var var
 * \var proc
 * \var func
 */
typedef struct info {
    var_info* var; ///< Variable informations
    proc_info* proc; ///< Procedure informations
    func_info* func; ///< Function infomations
}info; ///< An struct type that can store variables, functions and procedures informations

var_info* create_var_info(char* id, char* type);
proc_info* create_proc_info(char* id, list* params);
func_info* create_func_info(char* id, char* r_type, list* params);

#endif /** __SYMBOLS_H__ **/