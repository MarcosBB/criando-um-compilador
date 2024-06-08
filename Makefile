# Compiler flags
CC = gcc
LEX = lex
DEFAULT_TOOL ?= yacc
YACC = $(DEFAULT_TOOL)
FLAGS = -d -v

# Source files
LEX_FILE = src/lexer.l
PARSE_FILE = src/parser.y

# Executable name
EXEC = compiler.exe

# Input file
INPUT_FILE = tests/mergesort.txt

# Output files
L_OUT_C = lex.yy.c
Y_OUT_C = $(if $(filter $(DEFAULT_TOOL),yacc),y.tab.c,parser.tab.c)
Y_OUT_H = $(if $(filter $(DEFAULT_TOOL),yacc),y.tab.h,parser.tab.h)
Y_OUT_O = $(if $(filter $(DEFAULT_TOOL),yacc),y.output,parser.output)

# Targets
.PHONY: all clean

all: $(EXEC)

$(EXEC): $(L_OUT_C) $(Y_OUT_C)
	@echo "Compiling executable..."
	@$(CC) $(L_OUT_C) $(Y_OUT_C) -o $(EXEC)
	@echo "The bomb has been planted!"

$(L_OUT_C): $(LEX_FILE)
	@echo "Generating lexer..."
	@$(LEX) $(LEX_FILE)

$(Y_OUT_C): $(PARSE_FILE)
	@echo "Generating parser..."
	@$(YACC) $(FLAGS) $(PARSE_FILE)

run: $(EXEC)
	@echo "Running compiler with input file: $(INPUT_FILE)"
	@./$(EXEC) < $(INPUT_FILE)

clean:
	@echo "Cleaning up..."
	@rm -f $(L_OUT_C) $(Y_OUT_C) $(Y_OUT_H) $(Y_OUT_O) $(EXEC)
	@echo "The bomb has been defused!"
