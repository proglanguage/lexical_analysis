#include <assert.h>
#include <stdlib.h>
#include <stdio.h>
#include "linked_list.h"


#ifndef DEBUG
#define DEBUG
FILE* debug;
#endif

void test_push();
void test_get();
void test_remove();
void test_merge();

int main(void){
    fprintf(stdout,"[INFO] - Start linked list test.\n");
    #ifdef DEBUG
        debug = stderr;
        // debug = fopen("debug.log","w+");
        fprintf(debug, "[TEST] - Starting push method test\n");
    #endif
    test_push();
    #ifdef DEBUG
        fprintf(debug, "[TEST] - End of push method test\n");
        fprintf(debug, "[TEST] - Starting get method test\n");
    #endif
    test_get();
    #ifdef DEBUG
        fprintf(debug, "[TEST] - End of get method test\n");
        fprintf(debug, "[TEST] - Starting remove method test\n");
    #endif
    test_remove();
    #ifdef DEBUG
        fprintf(debug, "[TEST] - End of remove method test\n");
        fprintf(debug, "[TEST] - Starting merge method test\n");
    #endif
    test_merge();
    #ifdef DEBUG
        fprintf(debug, "[TEST] - End of merge method test\n");
        // fprintf(debug, "[TEST] - Starting remove method test\n");
    #endif
    fprintf(stdout,"[INFO] - End linked list test.\n");
    return 0;
}

void test_push(){
    #pragma GCC diagnostic ignored "-Wint-conversion"
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Creating a list with max size 10\n");
    #endif
    list* ll = create_ll(sizeof(int*));
    if (ll == NULL) {
        fprintf(stderr, "[ERROR] - Something go wrong\n");
        return;
    }
    int in;
    in = 2;
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Inserting the value %d in list\n", in);
    #endif
    assert(ll->push(ll, in));
    ll->clean(ll);
    // free(ll);
}

void test_get(){
    #pragma GCC diagnostic ignored "-Wpointer-to-int-cast"
    #pragma GCC diagnostic ignored "-Wformat="
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Creating a list with max size 10\n");
    #endif
    list* ll = create_ll(sizeof(int*));
    if (ll == NULL) {
        fprintf(stderr, "[ERROR] - Something go wrong\n");
        return;
    }
    int in = 2;
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Inserting the value %d in list\n", in);
    #endif
    ll->push(ll, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll->size);
    #endif
    ll->push(ll, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll->size);
    #endif
    ll->push(ll, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll->size);
        for(in = 0; in < ll->size; in++){
            fprintf(debug, "[INFO] - l[%d]=%d, l[%d]=%d, l[%d]=%d\n", in - 1, ll->get(ll, in - 1), in, ll->get(ll, in), in + 1, ll->get(ll, in + 1));
        }
    #endif
    assert(((int) ll->get(ll, 1)) == 1);
    ll->clean(ll);
    // free(ll);
}

void test_remove(){
    #pragma GCC diagnostic ignored "-Wformat="
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Creating a list with max size 10\n");
    #endif
    list* ll = create_ll(sizeof(int*));
    if (ll == NULL) {
        fprintf(stderr, "[ERROR] - Something go wrong\n");
        return;
    }
    int in = 2;
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Inserting the value %d in list\n", in);
    #endif
    ll->push(ll, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll->size);
    #endif
    ll->push(ll, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll->size);
    #endif
    ll->push(ll, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll->size);
        for(in = 0; in < ll->size; in++){
            fprintf(debug, "[INFO] - l[%d]=%d, l[%d]=%d, l[%d]=%d\n", in - 1, ll->get(ll, in - 1), in, ll->get(ll, in), in + 1, ll->get(ll, in + 1));
        }
    #endif
    assert(((int) ll->remove(ll, 1)) == 1);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll->size);
        for(in = 0; in < ll->size; in++){
            fprintf(debug, "[INFO] - l[%d]=%d, l[%d]=%d, l[%d]=%d\n", in - 1, ll->get(ll, in - 1), in, ll->get(ll, in), in + 1, ll->get(ll, in + 1));
        }
    #endif
    assert(((int) ll->get(ll, 1)) == 0);
    ll->clean(ll);
    // free(ll);
}

void test_merge(){
    #pragma GCC diagnostic ignored "-Wformat="
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Creating a list with max size 10\n");
    #endif
    list* ll1 = create_ll(sizeof(int*));
    if (ll1 == NULL) {
        fprintf(stderr, "[ERROR] - Something go wrong\n");
        return;
    }
    int in = 2;
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Inserting the value %d in list\n", in);
    #endif
    ll1->push(ll1, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll1->size);
    #endif
    ll1->push(ll1, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll1->size);
    #endif
    ll1->push(ll1, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll1->size);
        for(in = 0; in < ll1->size; in++){
            fprintf(debug, "[INFO] - l[%d]=%d, l[%d]=%d, l[%d]=%d\n", in - 1, ll1->get(ll1, in - 1), in, ll1->get(ll1, in), in + 1, ll1->get(ll1, in + 1));
        }
    #endif
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Creating a list with max size 10\n");
    #endif
    list* ll2 = create_ll(sizeof(int*));
    if (ll2 == NULL) {
        fprintf(stderr, "[ERROR] - Something go wrong\n");
        return;
    }
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Inserting the value %d in list\n", in);
    #endif
    ll2->push(ll2, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll2->size);
    #endif
    ll2->push(ll2, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll2->size);
    #endif
    ll2->push(ll2, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll2->size);
        for(in = 0; in < ll2->size; in++){
            fprintf(debug, "[INFO] - l[%d]=%d, l[%d]=%d, l[%d]=%d\n", in - 1, ll2->get(ll2, in - 1), in, ll2->get(ll2, in), in + 1, ll2->get(ll2, in + 1));
        }
    #endif
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Initializing merge\n");
    #endif
    ll1 = ll1->merge(ll1,ll2);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll1->size);
        for(in = 0; in < ll1->size; in++){
            fprintf(debug, "[INFO] - l[%d]=%d, l[%d]=%d, l[%d]=%d\n", in - 1, ll1->get(ll1, in - 1), in, ll1->get(ll1, in), in + 1, ll1->get(ll1, in + 1));
        }
    #endif
    ll1->clean(ll1);
    // ll2->clean(ll2);
    // free(ll);
}

void test_clean(){
    #pragma GCC diagnostic ignored "-Wformat="
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Creating a list with max size 10\n");
    #endif
    list* ll = create_ll(sizeof(int*));
    if (ll == NULL) {
        fprintf(stderr, "[ERROR] - Something go wrong\n");
        return;
    }
    int in = 2;
    #ifdef DEBUG
        fprintf(debug, "[INFO] - Inserting the value %d in list\n", in);
    #endif
    ll->push(ll, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll->size);
    #endif
    ll->push(ll, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll->size);
    #endif
    ll->push(ll, in--);
    #ifdef DEBUG
        fprintf(debug, "[INFO] - List size = %d\n", ll->size);
        for(in = 0; in < ll->size; in++){
            fprintf(debug, "[INFO] - l[%d]=%d\n", in, ll->get(ll, in));
        }
    #endif
    assert(ll->clean(ll) == 1);
    ll->clean(ll);
    // free(ll);
}
