#include "hash-table.h"

#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define TABLE_SIZE 10

unsigned int hash(const char *key) {
  unsigned long int value = 0;
  unsigned int i = 0;
  unsigned int key_length = strlen(key);

  //  do several rounds of multiplication
  for (; i < key_length; ++i) {
    value = value * 37 + key[i];
  }

  //  make sure value is 0 <= value < TABLE_SIZE
  value = value % TABLE_SIZE;

  return value;
}

entry_point_base *hash_table_pair(const char *key, const char *value) {
  //  allocate the entry point
  entry_point_base *entry_point = malloc(sizeof(entry_point_base) * 1);
  entry_point->key = malloc(strlen(key) + 1);
  entry_point->value = malloc(strlen(value) + 1);

  //  copy the key and the value in place
  strcpy(entry_point->key, key);
  strcpy(entry_point->value, value);

  //  next starts out null but may be set later on
  entry_point->next = NULL;

  return entry_point;
}

hash_table_base *hash_table_create(void) {
  //  allocate table
  hash_table_base *hash_table = malloc(sizeof(hash_table_base) * 1);

  //  allocate table entries
  hash_table->entries = malloc(sizeof(entry_point_base *) * TABLE_SIZE);

  //  set each to null (needed for proper operation)
  int i = 0;
  for (; i < TABLE_SIZE; ++i) {
    hash_table->entries[i] = NULL;
  }

  return hash_table;
}

char *hash_table_get(hash_table_base *hash_table, const char *key) {
  unsigned int slot = hash(key);

  //  try to find a valid slot
  entry_point_base *entry_point = hash_table->entries[slot];

  //  no slot means no entry
  if (entry_point == NULL) {
    return NULL;
  }

  //  walk through each entry in the slot, which could just be a single thing
  while (entry_point != NULL) {
    //  return value if found
    if (strcmp(entry_point->key, key) == 0) {
      return entry_point->value;
    }

    //  proceed to the next key if available
    entry_point = entry_point->next;
  }

  //  reaching here means there were >= 1 entries, but no key match
  return NULL;
}

void hash_table_set(hash_table_base *hash_table, const char *key, const char *value) {
  unsigned int slot = hash(key);

  //  try to look up an entry set
  entry_point_base *entry_point = hash_table->entries[slot];

  //  no entry means slot empty, insert immediately
  if (entry_point == NULL) {
    hash_table->entries[slot] = hash_table_pair(key, value);
    return;
  }

  entry_point_base *previous;

  //  walk through each entry until either the end is reached or a matching key
  //  is found
  while (entry_point != NULL) {
    //  check key
    if (strcmp(entry_point->key, key) == 0) {
      //  match found, replace value
      free(entry_point->value);
      entry_point->value = malloc(strlen(value) + 1);
      strcpy(entry_point->value, value);
      return;
    }

    //  walk to next
    previous = entry_point;
    entry_point = previous->next;
  }

  //  end of chain reached without a match, add new one
  previous->next = hash_table_pair(key, value);
}

void hash_table_dump(hash_table_base *hash_table) {
  for (int i = 0; i < TABLE_SIZE; ++i) {
    entry_point_base *entry_point = hash_table->entries[i];

    if (entry_point == NULL) {
      continue;
    }

    printf("slot[%5d]: ", i);

    while (entry_point != NULL) {
      printf("%s -> %s", entry_point->key, entry_point->value);

      if (entry_point->next != NULL) {
        printf(", ");
      } else {
        break;
      }

      entry_point = entry_point->next;
    }

    printf("\n");
  }
}

void hash_table_free(hash_table_base *hash_table) {
  // free the allocate memory
  for (int i = 0; i < TABLE_SIZE; ++i) {
    entry_point_base *entry_point = hash_table->entries[i];

    while (entry_point != NULL) {
      entry_point_base *temporary = entry_point;
      entry_point = entry_point->next;
      free(temporary->key);
      free(temporary->value);
      free(temporary);
    }
  }

  free(hash_table->entries);
  free(hash_table);
}
