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

// Hash function
unsigned int hash(const char *key);

// Create a key-value pair
entry_point_base *hash_table_pair(const char *key, const char *value);

// Create a new hash table
hash_table_base *hash_table_create(void);

// Retrieve a value from the hash table
char *hash_table_get(hash_table_base *hash_table, const char *key);

// Insert or update a key-value pair in the hash table
void hash_table_set(hash_table_base *hash_table, const char *key, const char *value);

// Print the contents of the hash table
void hash_table_dump(hash_table_base *hash_table);

// Free the memory allocated for the hash table
void hash_table_free(hash_table_base *hash_table);

#endif //HASH_TABLE_H
