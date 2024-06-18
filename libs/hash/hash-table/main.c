#include "hash-table.h"
#include <stdio.h>

int main() {
	hash_table_base *hash_table = hash_table_create();

	hash_table_set(hash_table, "key1", "value1");
	hash_table_set(hash_table, "key2", "value2");
	hash_table_set(hash_table, "key3", "value3");

	printf("key1: %s\n", hash_table_get(hash_table, "key1"));
	printf("key2: %s\n", hash_table_get(hash_table, "key2"));
	printf("key3: %s\n", hash_table_get(hash_table, "key3"));

	hash_table_dump(hash_table);

	hash_table_free(hash_table);

	return 0;
}
