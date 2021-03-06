#include "hash_table.h"

// #ifndef DEBUG
// #define DEBUG
// #endif

ht_node* create_ht_node(char * key, info* info){
    ht_node* result = malloc(sizeof(ht_node));
    result->key = malloc(strlen(key)+1);
    strcpy(result->key, key);
    result->value = info;
    return result;
}

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
        val->items[i] = create_ll(sizeof(ht_node*));
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
int ht_insert(hash_table* ht, ht_node* value){
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
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - Startup lookup for key %s\n", value->key);
    #endif
    for(i = 0; i < ll->size; i++){
        ht_node* n = (ht_node*) current->value;
        #ifdef DEBUG
            fprintf(stderr,"[INFO] - Verifying equality of %s and %s\n", value->key, n->key);
        #endif
        if (strcmp(value->key, n->key) == 0) {
            #ifdef DEBUG
                fprintf(stderr,"[INFO] - Key %s already in table\n", n->key);
            #endif
            return 0;
        }
        current = current->next;
    }
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - Inserting %s\n", value->key);
    #endif
    ll->push(ll, value);
    return 1;
}

ht_node* ht_get(hash_table* ht, char* key){
    int pos = ht->hash(key)%ht->size;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - getting items at column %d on table\n", pos);
    #endif
    list* ll = (list*) ht->items[pos];
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - check if items list is empty\n");
    #endif
    if (ll->is_empty(ll)) {
        #ifdef DEBUG
            fprintf(stderr,"[INFO] - List is empty. Element not inserted\n");
        #endif
        return NULL;
    }
    int i = 0;
    cell_list* current = ll->head;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - Startup lookup for key %s\n", key);
    #endif
    for(i = 0; i < ll->size; i++){
        ht_node* n = (ht_node*) current->value;
        #ifdef DEBUG
            fprintf(stderr,"[INFO] - Verifying equality of %s and %s\n", key, n->key);
        #endif
        if (strcmp(key, n->key) == 0) {
            #ifdef DEBUG
                fprintf(stderr,"[INFO] - Found key %s in table\n", n->key);
            #endif
            return n;
        }
        current = current->next;
    }
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - Found no key %s\n", key);
    #endif
    return NULL;
}

ht_node* ht_purge(hash_table* ht, char* key){
    list* ll = (list*) ht->items[ht->hash(key)%ht->size];
    if (ll == NULL || ll->is_empty(ll)) {
        #ifdef DEBUG
            fprintf(stderr,"[INFO] - Empty list\n");
        #endif
        return NULL;
    }
    if (ll->size == 1 && strcmp(key,((ht_node*) ll->head->value)->key) == 0){
        #ifdef DEBUG
            fprintf(stderr,"[INFO] - Removing %s in index %d\n", key, 0);
        #endif
        return (ht_node*) ll->remove(ll, 0);
    }
    int i = 0;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - Start search\n");
    #endif
    cell_list* tmp = ll->head;
    while(tmp != NULL && strcmp(key,((ht_node*) tmp->value)->key)){
        tmp = tmp->next;
        i++;
    }
    if(tmp != NULL){
        #ifdef DEBUG
            fprintf(stderr,"[INFO] - Removing %s in index %d\n", key, i);
        #endif
        ht_node *val = (ht_node*) ll->remove(ll,i);
        return val;
    }
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - Key %s not in table\n", key);
    #endif
    return NULL;
}

int destroy_ht(hash_table* ht){
    int i = 0;
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - Cleaning table\n");
    #endif
    for(i = 0; i < ht->size; i++) {
        ((list*) ht->items[i])->clean((list*) ht->items[i]);
    }
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - Table cleaned\n");
    #endif
    free(ht->items);
    #ifdef DEBUG
        fprintf(stderr,"[INFO] - Freeing pointers\n");
    #endif
    free(ht);
    return 1;
}
