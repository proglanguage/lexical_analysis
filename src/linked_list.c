#include "linked_list.h"

// #ifndef DEBUG
// #define DEBUG
// #endif

list* create_ll(int t_size){
    list* val = (list*) malloc(sizeof(list));
    if (val == NULL) {
        fprintf(stderr, "[ERROR] - malloc not initializing list");
        return NULL;
    }
    // val->capacity = capacity;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - can access capacity value\n");
    #endif
    val->t_size = t_size;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - can access t_size value\n");
    #endif
    val->size = 0;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - can access size value\n");
    #endif
    val->head = NULL;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - can access head value\n");
    #endif
    val->tail = NULL;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - can access tail value\n");
    #endif
    val->push = push_in_ll;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - init push method\n");
    #endif
    val->get = get_from_ll;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - init get method\n");
    #endif
    val->remove = remove_from_ll;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - init remove method\n");
    #endif
    val->clean = clean_ll;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - init clean method\n");
    #endif
    val->is_empty = ll_is_empty;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - init is_empty method\n");
    #endif
    return val;
}

int push_in_ll(list* ll, void* val){
    #pragma GCC diagnostic ignored "-Wformat="
    cell_list* item = (cell_list*) malloc(sizeof(cell_list));
    if (item == NULL) {
        fprintf(stderr, "[ERROR] - Something go wrong on malloc\n");
        return -1;
    }
    item->value = malloc(ll->t_size);
    if (item == NULL) {
        fprintf(stderr, "[ERROR] - Something go wrong on malloc\n");
        return -1;
    }
    (*item).value = val;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - Value %i is going to be inserted\n", (*item).value);
    #endif
    if (!ll->tail && !ll->head) {
        ll->head = item;
        ll->tail = item;
    } else if(!ll->tail || !ll->head) {
        return 0;
    } else {
        ll->tail->next = item;
    }
    item->next = ll->head;
    item->prev = ll->tail;
    ll->tail = item;
    ll->size++;
    #ifdef DEBUG
        fprintf(stderr, "[INFO] - Value %i inserted\n", (*item).value);
    #endif
    return 1;
}

void* get_from_ll(list* ll, int index){
    // if (index >= ll->capacity) {
    //     fprintf(stderr, "[ERROR] - Index out of range\n");
    //     return NULL;
    // } else
    #pragma GCC diagnostic ignored "-Wint-conversion"
    if (index == 0) {
        #ifdef DEBUG
            fprintf(stderr, "[INFO] - Returning linked list head value\n");
        #endif
        return ll->head->value;
    } else if (index == ll->size - 1) {
        #ifdef DEBUG
            fprintf(stderr, "[INFO] - Returning linked list tail value\n");
        #endif
        return ll->tail->value;
    } else if (index < ll->size/2 && index > 0){
        cell_list *current = ll->head;
        while(index < ll->size && index-- > 0){
            current = current->next;
        }
        #ifdef DEBUG
            fprintf(stderr, "[INFO] - Returning linked list value in first half\n");
        #endif
        return current->value;
    } else if (index >= ll->size/2 && index < ll->size){
        cell_list *current = ll->tail;
        while(index < ll->size && index-- > 0){
            current = current->prev;
        }
        #ifdef DEBUG
            fprintf(stderr, "[INFO] - Returning linked list value in second half\n");
        #endif
        return current->value;
    }
    return LISTEND;
}

void* remove_from_ll(list* ll, int index){
    // if (index >= ll->capacity) {
    //     fprintf(stderr, "[ERROR] - Index out of range\n");
    //     return NULL;
    // } else 
    #pragma GCC diagnostic ignored "-Wint-conversion"
    if (index == 0) {
        #ifdef DEBUG
            fprintf(stderr, "[INFO] - Removing linked list head value\n");
        #endif
        void* value = ll->head->value;
        cell_list* new_head = ll->head->next;
        new_head->prev = ll->tail;
        ll->tail->next = new_head;
        free(ll->head);
        ll->head = new_head;
        ll->size--;
        return value;
    } else if (index == ll->size - 1) {
        #ifdef DEBUG
            fprintf(stderr, "[INFO] - Removing linked list tail value\n");
        #endif
        void* value = ll->tail->value;
        cell_list* new_tail = ll->tail->prev;
        new_tail->next = ll->head;
        ll->head->prev = new_tail;
        free(ll->tail);
        ll->tail = new_tail;
        ll->size--;
        return value;
    } else if (index < ll->size/2){
        cell_list *current = ll->head;
        while(index < ll->size && index-- > 0){
            current = current->next;
        }
        #ifdef DEBUG
            fprintf(stderr, "[INFO] - Removing linked list value in first half\n");
        #endif
        void* value = current->value;
        cell_list* change = current->prev;
        change->next = current->next;
        current->next->prev = change;
        free(current);
        ll->size--;
        return value;
    } else {
        cell_list *current = ll->tail;
        while(index < ll->size && index-- > 0){
            current = current->prev;
        }
        #ifdef DEBUG
            fprintf(stderr, "[INFO] - Removing linked list value in second half\n");
        #endif
        void* value = current->value;
        cell_list* change = current->prev;
        change->next = current->next;
        current->next->prev = change;
        free(current);
        ll->size--;
        return value;
    }
    return LISTEND;
}

int clean_ll(list* ll){
    while (!ll->is_empty(ll)) {
        ll->remove(ll,0);
    }
    return 1;
}

int ll_is_empty(list* ll){
    return ll->size==0?1:0;
}
