# Compiler flags
CC = gcc
LEX = lex
YACC_TOOL ?= yacc
YACC = bison
YACC_FLAGS = -d -v -Wcounterexamples

# Source files
LEX_FILE = lexico.l
YACC_FILE = parser.y

# Executable name
EXEC = compiler.exe

# Input file
INPUT_FILE = mergesort.txt

# Targets
.PHONY: all clean

all: $(EXEC)

$(EXEC): lex.yy.c y.tab.c
	@echo "Compiling executable..."
	@$(CC) lex.yy.c y.tab.c -o $(EXEC)
	@echo "Everything seems fine!"

lex.yy.c: $(LEX_FILE)
	@echo "Generating lexer..."
	@$(LEX) $(LEX_FILE)

y.tab.c: $(YACC_FILE)
	@echo "Generating parser..."
	@$(YACC_TOOL) $(YACC_FLAGS) $(YACC_FILE)

run: $(EXEC)
	@echo "Running compiler with input file: $(INPUT_FILE)"
	@./$(EXEC) < $(INPUT_FILE)

clean:
	@echo "Cleaning up..."
	@rm -f lex.yy.c y.tab.c y.tab.h y.output parser.tab.c parser.tab.h parser.output $(EXEC)
