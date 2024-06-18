//
// Created by thiagosilva on 18/06/24.
//

#ifndef HASH_TABLE_H
#define HASH_TABLE_H

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct entry_point_base {
	char *key;
	char *value;
	struct entry_point_base *next;
} entry_point_base;

typedef struct {
	entry_point_base **entries;
} hash_table_base;

unsigned int hash(const char *key);

char *hash_table_get(hash_table_base *hash_table, const char *key);

void hash_table_set(hash_table_base *hash_table, const char *key, const char *value);

void hash_table_dump(hash_table_base *hash_table);

#endif //HASH_TABLE_H
