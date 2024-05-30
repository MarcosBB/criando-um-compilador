# Criando um compilador
Este é um projeto de estudo de engenharia de linguagem que visa a criação de uma linguagem de programação.

## Rodando o projeto
Para executar basta rodar com `lex` e `yacc`:
```bash
lex lexico.l
yacc parser.y -d -v 
gcc lex.yy.c y.tab.c -o compiler.exe
./compiler.exe < mergesort.txt
```

Para rodar com `lex` e `bison`: 
```bash
lex lexico.l
bison parser.y -d -v -o y.tab.c
gcc lex.yy.c y.tab.c -o compiler.exe
./compiler.exe < mergesort.txt
```
