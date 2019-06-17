#ifndef __SYMBOLS_H__
#define __SYMBOLS_H__

#include <stdio.h>
#include <stdlib.h>
#include "linked_list.h"

typedef struct var_info{
    char* id; ///> The alias to the variable
    char* type; ///> The type of the function
}var_info;

typedef struct proc_info{
    list* params; ///> Vector of var_info
}proc_info;

typedef struct func_info{
    char* return_type; ///> The type id of the return
    list* params; ///> Vector of var_info
}func_info;

#endif /** __SYMBOLS_H__ **/