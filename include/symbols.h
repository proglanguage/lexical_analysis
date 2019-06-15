#ifndef __SYMBOLS_H__
#define __SYMBOLS_H__

#include <stdio.h>
#include <stdlib.h>

typedef struct var_info{
    char* type; ///> The type of the function
}var_info;

typedef struct proc_info{
    var_info* params; ///> Vector of var_info
}proc_info;

typedef struct func_info{
    char* return_type; ///> The type id of the return
    var_info* params; ///> Vector of var_info
}func_info;

#endif /** __SYMBOLS_H__ **/