# Criando um compilador
Este é um projeto de estudo de engenharia de linguagem que visa a criação de uma linguagem de programação.

## Rodando o projeto
Para executar basta rodar:
```bash
lex lexico.l
yacc parser.y -d -v ou bison parser.y -d -v
gcc lex.yy.c y.tab.c -o compiler.exe
./compiler.exe < mergesort.txt
```