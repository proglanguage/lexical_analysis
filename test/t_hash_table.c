#include "hash_table.h"
#include <assert.h>

// #ifndef DEBUG
// #define DEBUG
// FILE* debug;
// #endif

void test_hash();
void test_create_hash_table();
void test_insert();
void test_get();
void test_purge();
void test_destroy();

int main(){
    fprintf(stderr, "[INFO] - Start hash table test.\n");
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
        fprintf(debug, "[TEST] - Starting get method test\n");
    #endif
    test_get();
    #ifdef DEBUG
        fprintf(debug, "[TEST] - End of get method test\n");
        fprintf(debug, "[TEST] - Starting purge method test\n");
    #endif
    test_purge();
    #ifdef DEBUG
        fprintf(debug, "[TEST] - End of purge method test\n");
        // fprintf(debug, "[TEST] - Starting insert method test\n");
    #endif
    fprintf(stderr, "[INFO] - End of hash table test.\n");
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
}

void test_insert(){
    hash_table* ht = create_ht(10);
    ht_node n1;
    n1.key = "foo";
    n1.value = malloc(sizeof(info));
    var_info* inf = malloc(sizeof(var_info));
    inf->type = "bar";
    n1.value->var = inf;
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion of the first element\n");
    #endif
    assert(ht->insert(ht, &n1));
    ht_node n2;
    n2.key = "bar";
    n2.value = malloc(sizeof(info));
    inf = malloc(sizeof(var_info));
    inf->type = "foo";
    n2.value->var = inf;
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion of the second element\n");
    #endif
    assert(ht->insert(ht, &n2));
    ht_node n3;
    n3.key = "foo";
    n3.value = malloc(sizeof(info));
    inf = malloc(sizeof(var_info));
    inf->type = "bar2";
    n3.value->var = inf;
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion of the third element\n");
    #endif
    assert(!ht->insert(ht, &n3));
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Insertion succeeded\n");
    #endif
    ht->destroy(ht);
}

void test_get(){
    hash_table* ht = create_ht(10);
    ht_node n1;
    n1.key = "foo";
    n1.value = malloc(sizeof(info));
    var_info* inf = malloc(sizeof(var_info));
    inf->type = "bar";
    n1.value->var = inf;
    assert(ht->insert(ht, &n1));
    ht_node n2;
    n2.key = "bar";
    n2.value = malloc(sizeof(info));
    inf = malloc(sizeof(var_info));
    inf->type = "foo";
    n2.value->var = inf;
    ht->insert(ht, &n2);
    ht_node n3;
    n3.key = "foo2";
    n3.value = malloc(sizeof(info));
    inf = malloc(sizeof(var_info));
    inf->type = "bar2";
    n3.value->var = inf;
    ht->insert(ht, &n3);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Getting the 'foo' node\n");
    #endif
    assert(strcmp(ht->get(ht, "foo")->key, "foo") == 0);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Succeeded\n");
    #endif
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Getting the 'bar' node\n");
    #endif
    assert(strcmp(ht->get(ht, "bar")->key, "foo") != 0);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Succeeded\n");
    #endif
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Getting the 'bar2' node\n");
    #endif
    assert(ht->get(ht, "bar2") == NULL);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Succeeded on failling\n");
    #endif
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Getting the 'foo2' node\n");
    #endif
    assert(strcmp(ht->get(ht, "foo2")->key, "foo2") == 0);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Succeeded\n");
    #endif
    ht->destroy(ht);
}


void test_purge(){
    hash_table* ht = create_ht(10);
    ht_node n1;
    n1.key = "foo";
    n1.value = malloc(sizeof(info));
    var_info* inf = malloc(sizeof(var_info));
    inf->type = "bar";
    n1.value->var = inf;
    ht->insert(ht, &n1);
    ht_node n2;
    n2.key = "bar";
    n2.value = malloc(sizeof(info));
    inf = malloc(sizeof(var_info));
    inf->type = "foo";
    n2.value->var = inf;
    ht->insert(ht, &n2);
    ht_node n3;
    n3.key = "foo2";
    n3.value = malloc(sizeof(info));
    inf = malloc(sizeof(var_info));
    inf->type = "bar2";
    n3.value->var = inf;
    ht->insert(ht, &n3);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Purging the 'foo2' node\n");
    #endif
    assert(strcmp(ht->purge(ht, "foo2")->key, "foo2") == 0);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Succeeded\n");
    #endif
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Purging the 'bar' node\n");
    #endif
    assert(strcmp(ht->purge(ht, "bar")->key, "foo") != 0);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Succeeded\n");
    #endif
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Purging the 'bar2' node\n");
    #endif
    assert(ht->purge(ht, "bar2") == NULL);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Succeeded on failling\n");
    #endif
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Purging the 'foo' node\n");
    #endif
    assert(strcmp(ht->purge(ht, "foo")->key, "foo") == 0);
    #ifdef DEBUG
        fprintf(debug,"[INFO] - Succeeded\n");
    #endif
    ht->destroy(ht);
}

// void test_destroy(){
// }
