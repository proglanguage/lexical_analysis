#include "hash_table.h"
#include <assert.h>

#ifndef DEBUG
#define DEBUG
FILE* debug;
#endif

void test_hash();
void test_create_hash_table();
void test_insert();
void test_get();
void test_purge();
void test_destroy();

int main(){
    #ifdef DEBUG
        debug = stderr;
        fprintf(debug, "[TEST] - Starting hash test\n");
    #endif
    test_hash();
    #ifdef DEBUG
        fprintf(debug, "[TEST] - End of hash test\n");
        fprintf(debug, "[TEST] - Starting create hash table test\n");
    #endif
    test_create_hash_table();
    #ifdef DEBUG
        fprintf(debug, "[TEST] - End of create hash table test\n");
        fprintf(debug, "[TEST] - Starting insert method test\n");
    #endif
    test_insert();
    #ifdef DEBUG
        fprintf(debug, "[TEST] - End of insert method test\n");
        // fprintf(debug, "[TEST] - Starting insert method test\n");
    #endif
    
    return 0;
}

void test_hash(){
    assert((_hash("foo")==(102+111+111)?1:0));
    #ifdef DEBUG
        fprintf(debug,"[INFO] - hash to 'foo' is correct\n");
    #endif
    assert(!(_hash("bar")==(102+111+111)?1:0));
    assert((_hash("bar")==(98+97+114)?1:0));
    #ifdef DEBUG
        fprintf(debug,"[INFO] - hash to 'bar' is correct\n");
    #endif
}

void test_create_hash_table(){
    hash_table* ht = create_ht(10);
    assert(ht->size==10);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - size attribute is correct\n");
    #endif
    ht->destroy(ht);
    free(ht);
}

void test_insert(){
    hash_table* ht = create_ht(10);
    node n1;
    n1.key = "foo";
    var_info* inf = malloc(sizeof(var_info));
    inf->type = "bar";
    n1.value.var = inf;
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion of the first element\n");
    #endif
    assert(ht->insert(ht, &n1));
    node n2;
    n2.key = "bar";
    inf = malloc(sizeof(var_info));
    inf->type = "foo";
    n2.value.var = inf;
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion of the second element\n");
    #endif
    assert(ht->insert(ht, &n2));
    node n3;
    n3.key = "foo";
    inf = malloc(sizeof(var_info));
    inf->type = "bar2";
    n3.value.var = inf;
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion of the third element\n");
    #endif
    assert(ht->insert(ht, &n3));
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion succeeded\n");
    #endif
}

void test_get(){
    hash_table* ht = create_ht(10);
    node n1;
    n1.key = "foo";
    var_info* inf = malloc(sizeof(var_info));
    inf->type = "bar";
    n1.value.var = inf;
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion of the first element\n");
    #endif
    assert(ht->insert(ht, &n1));
    node n2;
    n2.key = "bar";
    inf = malloc(sizeof(var_info));
    inf->type = "foo";
    n2.value.var = inf;
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion of the second element\n");
    #endif
    assert(ht->insert(ht, &n2));
    node n3;
    n3.key = "foo";
    inf = malloc(sizeof(var_info));
    inf->type = "bar2";
    n3.value.var = inf;
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion of the third element\n");
    #endif
    assert(ht->insert(ht, &n3));
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion succeeded\n");
    #endif
}

