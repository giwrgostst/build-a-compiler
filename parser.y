%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "symtab.h"
#include "ast.h"

extern int yylineno;
extern int yylex();
void yyerror(const char *s);

SymbolTableEntry symbolTable[100];
int symbolTableSize = 0;
%}

%union {
    int intval;
    char* id;
    ASTNode* node;
}

%token PROGRAM VAR BEGIN END IF THEN ELSE WHILE DO 
%token <intval> ICONST
%token <id> ID
%token ASSIGN ADDOP MULDIVANDOP RELOP

%type <node> program declarations statement expression

%%

program:
    PROGRAM ID SEMI declarations BEGIN statement_list END DOT {
        printf("Program syntax and semantic analysis successful.\n");
    }
    | error {
        printf("Syntax error in program structure.\n");
    }
    ;

declarations:
    VAR variable_defs SEMI {
        for (int i = 0; i < $$->size; i++) {
            addSymbol($$->ids[i], $2->type);
        }
    }
    | 
    ;

variable_defs:
    identifiers COLON type {
        $$ = create_var_node($1, $3);
    }
    ;

identifiers:
    ID {
        $$ = create_id_node($1);
    }
    | identifiers COMMA ID {
        add_id($1, $3);
    }
    ;

type:
    INTEGER {
        $$ = create_type_node(INT_TYPE);
    }
    | REAL {
        $$ = create_type_node(REAL_TYPE);
    }
    ;

statement_list:
    statement {
        $$ = create_stmt_list_node($1);
    }
    | statement_list SEMI statement {
        add_stmt_to_list($1, $3);
    }
    ;

statement:
    ID ASSIGN expression {
        int index = findSymbol($1);
        if (index == -1) {
            yyerror("Variable not declared.");
        }
        if (symbolTable[index].type != $3->type) {
            yyerror("Type mismatch in assignment.");
        }
        $$ = create_assign_node($1, $3);
    }
    | IF expression THEN statement ELSE statement {
        $$ = create_if_node($2, $4, $6);
    }
    ;

expression:
    expression ADDOP expression {
        $$ = create_op_node(ADDOP, $1, $3);
    }
    | expression MULDIVANDOP expression {
        $$ = create_op_node(MULDIVANDOP, $1, $3);
    }
    | ID {
        $$ = create_var_ref_node($1);
    }
    | ICONST {
        $$ = create_const_node(INT_TYPE, $1);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s at line %d\n", s, yylineno);
}