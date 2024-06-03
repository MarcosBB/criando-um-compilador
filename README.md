# Criando um compilador
Este é um projeto de estudo de engenharia de linguagem que visa a criação de uma linguagem de programação.

## Rodando o projeto

Para executar com a ferramenta padrão (yacc):

```bash
make all
```

Limpar arquivos compilados & executáveis

```bash
make clean
```

Para executar com `lex` e `yacc`:

_Make_

```bash
make DEFAULT_TOOL=yacc
```

_Manual_

```bash
lex lexico.l
```

```bash
yacc parser.y -d -v 
```

```bash
gcc lex.yy.c y.tab.c -o compiler.exe
```

```bash
./compiler.exe < mergesort.txt
```

```bash
rm -f lex.yy.c y.tab.c y.tab.h y.output compiler.exe
```

Para executar com `lex` e `bison` 

_Make_

```bash
make DEFAULT_TOOL=bison
```

_Manual_

```bash
lex lexico.l
```

```bash
bison parser.y -d -v -o y.tab.c
```

```bash
gcc lex.yy.c y.tab.c -o compiler.exe
```

```bash
./compiler.exe < mergesort.txt
```

```bash
rm -f lex.yy.c parser.tab.c parser.tab.h parser.output compiler.exe
```
