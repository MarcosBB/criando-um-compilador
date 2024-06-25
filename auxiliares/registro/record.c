#include "record.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void freeRecord(record *rec)
{
  if (rec)
  {
    free(rec->code);
    free(rec->type);
    free(rec);
  }
}

record *createRecord(char *code, char *type)
{
  record *rec = (record *)malloc(sizeof(record));
  if (rec == NULL)
  {
    printf("Failed to allocate memory for record.\nClosing application...\n");
    exit(EXIT_FAILURE);
  }

  rec->code = strdup(code);
  rec->type = strdup(type);

  return rec;
}
