#include "y.tab.h"
#include "hash_table.h"


// #ifndef DEBUG
// #define DEBUG
// #endif

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
        cell_list* current = (((list*)(ht->items[i])))->head;
        if (current == NULL) {
            continue;
        }
        #ifdef DEBUG
            fprintf(stderr,"[INFO] - Initializong list %i, size %i, print loop\n", i, (((list*)(ht->items[i])))->size);
        #endif
        int j = 0;
        for (j = 0; j < (((list*)(ht->items[i])))->size; j++) {
            #ifdef DEBUG
                fprintf(stderr,"[INFO] - While on current node value %s\n", ((ht_node*)current->value)->key);
            #endif
            ht_node* n = (ht_node*) current->value;
            if (n == NULL) {
                continue;
            }
            printf("%s -> ", n->key);
            #ifdef DEBUG
                fprintf(stderr,"[INFO] - Node %s on list %i\n", n->key, i);
            #endif
            if (n->value->var != NULL) {
                #ifdef DEBUG
                    fprintf(stderr,"[INFO] - var_info type id = %s\n", n->value->var->id);
                    fprintf(stderr,"[INFO] - var_info type value = %s\n", n->value->var->type);
                #endif
                printf("id = %s | type = %s\n", n->value->var->id, n->value->var->type);
            } else if (n->value->func != NULL) {
                #ifdef DEBUG
                    fprintf(stderr,"[INFO] - func_info type\n");
                #endif
                printf("id = %s | type = %s | params = ", n->value->func->id, n->value->func->r_type);
                cell_list * current_param = n->value->func->params->head;
                if (current_param != NULL) {
                    int k = 0;
                    for (k = 0; k < n->value->func->params->size; k++) {
                        printf("id=%s-type=%s, ", ((var_info*)(current_param->value))->id, ((var_info*)(current_param->value))->type);
                        current_param = current_param->next;
                    }
                    printf("id=%s-type=%s\n", ((var_info*)(current_param->value))->id, ((var_info*)(current_param->value))->type);
                } else {
                    printf("\n");
                }
            } else if (n->value->proc != NULL) {
                #ifdef DEBUG
                    fprintf(stderr,"[INFO] - proc_info type\n");
                #endif
                printf("id = %s | params = ", n->value->proc->id);
                cell_list * current_param = n->value->proc->params->head;
                if (current_param != NULL) {
                    int k = 0;
                    for (k = 0; k < n->value->proc->params->size; k++) {
                        printf("id=%s-type=%s, ", ((var_info*)(current_param->value))->id, ((var_info*)(current_param->value))->type);
                        current_param = current_param->next;
                    }
                    printf("id=%s-type=%s\n", ((var_info*)(current_param->value))->id, ((var_info*)(current_param->value))->type);
                }
                else {
                    printf("\n");
                }
            }
            current = current->next;
        }
        // printf("\n");
    }
    
}
