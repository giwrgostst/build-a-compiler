# Mini C Compiler

A simple compiler for a C-like language using Flex and Bison, producing MIPS assembly. Includes lexer, parser, symbol table, AST construction, and MIPS code generator.

## 📂 Contents

- `lexer.l` – Lexical analyzer (Flex)
- `parser.y` – Grammar and parser (Bison)
- `symtab.h` – Symbol table definitions
- `ast.h` – Abstract syntax tree structures
- `mips.h` – MIPS code generation
- `test.c` – Sample C-like source input

## 🛠️ Technologies

C, Flex, Bison, MIPS Assembly

## 🚀 How to Run

Use `flex` and `bison` to compile the lexer and parser, then compile with `gcc`.
