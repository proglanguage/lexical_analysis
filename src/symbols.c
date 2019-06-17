#include "symbols.h"

var_info* create_var_info(char* id, char* type){
    var_info* result = malloc(sizeof(var_info));
    result->id = malloc(strlen(id)+1);
    result->id = strcpy(result->id, id);
    result->type = malloc(strlen(type)+1);
    result->type = strcpy(result->type, type);
}

proc_info* create_proc_info(char* id, list* params){
    proc_info* result = malloc(sizeof(proc_info));
    result->id = malloc(strlen(id)+1);
    result->id = strcpy(result->id, id);
    result->params = params;
}

func_info* create_func_info(char* id, char* r_type, list* params){
    func_info* result = malloc(sizeof(func_info));
    result->id = malloc(strlen(id)+1);
    result->id = strcpy(result->id, id);
    result->r_type = malloc(strlen(r_type)+1);
    result->r_type = strcpy(result->r_type, r_type);
    result->params = params;
}
