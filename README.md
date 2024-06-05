# Criando um compilador
Este é um projeto de estudo de engenharia de linguagem que visa a criação de uma linguagem de programação.

## Compilando e executando o projeto usando o Makefile

Para compilar com a ferramenta padrão (yacc):

```bash
make all
```

Executar a aplicação:

```bash
make run
```

Limpar arquivos compilados & executáveis

```bash
make clean
```

Para compilar usando o `yacc` ou `bison` como ferramenta padrão:

```bash
make DEFAULT_TOOL=yacc
```

```bash
make DEFAULT_TOOL=bison
```

## Compilando e executando o projeto de forma manual

- **1° passo**

```bash
lex lexer.l
```
- **2° passo**

Para compilar com `lex` & `yacc`:

```bash
yacc parser.y -d -v 
```

Para compilar com `lex` & `bison`:

```bash
bison parser.y -d -v
```

- **3° passo**

Gerando objeto executável:

```bash
gcc lex.yy.c y.tab.c -o compiler.exe
```

- **4° passo**

Executando com o arquivo de teste:

```bash
./compiler.exe < mergesort.txt
```

Sempre que necessário, remover:

1. Os arquivos compilados e executáveis com `yacc`.

```bash
rm -f lex.yy.c y.tab.c y.tab.h y.output compiler.exe
```

2. Os arquivos compilados e executáveis com `bison`.

```bash
rm -f lex.yy.c parser.tab.c parser.tab.h parser.output compiler.exe
```

## Autores

- Hilton
- Marcos
- Thiago

## Licença

[MIT](./license.md)
