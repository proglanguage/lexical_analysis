#include "hash_table.h"

#ifndef DEBUG
#define DEBUG
#endif

hash_table* create_ht(int size){
    hash_table* val = (hash_table*) malloc(sizeof(hash_table));
    if (val == NULL) {
        fprintf(stderr, "[ERROR] - Could not initialize with malloc\n");
    }
    val->size = size;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - It's possible the access to size attribute. Size = %d\n", val->size);
    #endif
    val->items = malloc(sizeof(list*)*val->size);
    if (val->items == NULL) {
        fprintf(stderr, "[ERROR] - Could not initialize with malloc\n");
    }
    int i;
    for(i = 0; i < val->size; i++){
        val->items[i] = create_ll(sizeof(node*));
        if (val->items[i] == NULL) {
            fprintf(stderr, "[ERROR] - Check malloc function");
        }
        #ifdef DEBUG
            fprintf(stderr,"[INFO] - It's possible the access the items attribute %d\n", i);
        #endif
    }
    val->hash = _hash;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - hash method initialized\n");
    #endif
    val->insert = ht_insert;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - insert method initialized\n");
    #endif
    val->get = ht_get;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - get method initialized\n");
    #endif
    val->purge = ht_purge;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - purge method initialized\n");
    #endif
    val->destroy = destroy_ht;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - destroy method initialized\n");
    #endif
    return val;
}

int _hash(char* value){
    int hash_val = 0;
    int i;
    for(i = 0; i < strlen(value); i++){
        hash_val += (int) value[i];
    }
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - hash value is %d\n", hash_val);
    #endif
    return hash_val;
}

/*!
 * @return 1 if insertion is suceeded or 0 if item is already inserted
 */
int ht_insert(hash_table* ht, node* value){
    int pos = ht->hash(value->key)%ht->size;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - getting items at column %d on table\n", pos);
    #endif
    list* ll = (list*) ht->items[pos];
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - check if items list is empty\n");
    #endif
    if (ll->is_empty(ll)) {
        ll->push(ll, value);
        #ifdef DEBUG
            fprintf(stderr,"[INFO] - List is empty. Inserting node to list\n");
        #endif
        return 1;
    }
    int i = 0;
    cell_list* current = ll->head;
    for(i = 0; i < ll->size; i++){
        node* n = (node*) current->value;
        if (strcmp(value->key, n->key)) {
            return 0;
        }
    }
    return 1;
}

node* ht_get(hash_table* ht, char* key){
    list* items = (list*) ht->items[ht->hash(key)%ht->size];
    int i = 0;
    for(i = 0; i < items->size; i++){
        // node* n = (node*) items->get(items, key);
    }
    node* val;
    return val;
}

node* ht_purge(hash_table* ht, char* key){
    node* val = (node*) ht->items[ht->hash(key)%ht->size];
    return val;
}

int destroy_ht(hash_table* ht){
    return 0;
}