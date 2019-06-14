#ifndef __SYMBOLS_H__
#define __SYMBOLS_H__

// #include <stdio.h>
// #include <stdlib.h>
#include "linked_list.h"


typedef struct _var_info{
    char* type;
}var_info;

typedef struct _proc_info{
    char* return_type;
    list* params;
}proc_info;


#endif /** __SYMBOLS_H__ **/