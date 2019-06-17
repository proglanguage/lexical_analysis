#include "y.tab.h"
#include "hash_table.h"


#ifndef DEBUG
#define DEBUG
#endif

hash_table* symbols;

void print_ht(hash_table* ht);

int main(void){
    symbols = create_ht(15);
    int result = yyparse();
    print_ht(symbols);
    return result;
}

void print_ht(hash_table* ht){
    int i = 0;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - Initializong print loop\n");
    #endif
    for(i = 0; i<ht->size; i++){
        cell_list* current = ((list*)((ht->items) + (i*sizeof(list*))))->head;
        if (current == NULL) {
            continue;
        }
        int timeout = 0;
        while (current != ((list*)((ht->items) + (i*sizeof(list*))))->tail && timeout <= 50) {
            ht_node* n = (ht_node*) current->value;
            printf("%s -> ", n->key);
            if (n->value->var != NULL) {
                printf("id = %s | type = %s\n", n->value->var->id, n->value->var->type);
            } else if (n->value->func) {
                printf("id = %s | type = %s | params = ", n->value->func->id, n->value->func->return_type);
                cell_list * current_param = n->value->func->params->head;
                if (current_param == NULL) {
                    continue;
                }
                while (current_param != n->value->func->params->tail) {
                    printf("id=%s-type=%s, ", ((var_info*)(current_param->value))->id, ((var_info*)(current_param->value))->type);
                    current_param = current_param->next;
                }
                printf("id=%s-type=%s\n", ((var_info*)(current_param->value))->id, ((var_info*)(current_param->value))->type);
            } else if (n->value->proc) {
                printf("id = %s | params = ", n->value->proc->id);
                cell_list * current_param = n->value->proc->params->head;
                if (current_param == NULL) {
                    continue;
                }
                while (current_param != n->value->proc->params->tail) {
                    printf("id=%s-type=%s, ", ((var_info*)(current_param->value))->id, ((var_info*)(current_param->value))->type);
                    current_param = current_param->next;
                }
                printf("id=%s-type=%s\n", ((var_info*)(current_param->value))->id, ((var_info*)(current_param->value))->type);
            }
            current = current->next;
            timeout++;
        }
        printf("\n");
    }
    
}
