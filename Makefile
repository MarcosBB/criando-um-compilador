# Compiler flags
CC = gcc
LEX = lex
DEFAULT_TOOL ?= yacc
YACC = bison
YACC_FLAGS = -d -v -Wcounterexamples

# Source files
LEX_FILE = lexico.l
YACC_FILE = parser.y

# Executable name
EXEC = compiler.exe

# Input file
INPUT_FILE = mergesort.txt

# Output files
YACC_OUT_C = $(if $(filter $(DEFAULT_TOOL),yacc),y.tab.c,parser.tab.c)
YACC_OUT_H = $(if $(filter $(DEFAULT_TOOL),yacc),y.tab.h,parser.tab.h)
YACC_OUT_O = $(if $(filter $(DEFAULT_TOOL),yacc),y.output,parser.output)

# Targets
.PHONY: all clean

all: $(EXEC)

$(EXEC): lex.yy.c y.tab.c
	@echo "Compiling executable..."
	@$(CC) lex.yy.c y.tab.c -o $(EXEC)
	@echo "The bomb has been planted!"

lex.yy.c: $(LEX_FILE)
	@echo "Generating lexer..."
	@$(LEX) $(LEX_FILE)

y.tab.c: $(YACC_FILE)
	@echo "Generating parser..."
	@$(DEFAULT_TOOL) $(YACC_FLAGS) $(YACC_FILE)

run: $(EXEC)
	@echo "Running compiler with input file: $(INPUT_FILE)"
	@./$(EXEC) < $(INPUT_FILE)

clean:
	@echo "Cleaning up..."
	@rm -f lex.yy.c $(YACC_OUT_C) $(YACC_OUT_H) $(YACC_OUT_O) $(EXEC)
	@echo "The bomb has been disarmed!"
