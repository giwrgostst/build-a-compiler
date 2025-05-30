#include <stdio.h>
#include <ctype.h>
#include <string.h>

#define MAX_LEXEME_LEN 100

typedef enum {
    ID, ICONST, RCONST, BCONST, CCONST, RELOP, ADDOP, LOGICOP, MULDIVANDOP, 
    PROGRAM, VAR, BEGIN, END, IF, THEN, ELSE, WHILE, DO, EOF_SYM, ERROR
} TokenType;

typedef struct {
    TokenType token;
    char lexeme[MAX_LEXEME_LEN];
    int lineNumber;
} Token;

typedef struct {
    char name[MAX_LEXEME_LEN];
    TokenType type;
} SymbolTableEntry;

SymbolTableEntry symbolTable[100];
int symbolTableSize = 0;

FILE *sourceCode;
Token nextToken;
int currentLine = 1;

int addToSymbolTable(char *lexeme) {
    for (int i = 0; i < symbolTableSize; i++) {
        if (strcmp(symbolTable[i].name, lexeme) == 0) {
            return i;
        }
    }
    strcpy(symbolTable[symbolTableSize].name, lexeme);
    symbolTable[symbolTableSize].type = ID;
    return symbolTableSize++;
}

void getToken() {
    char ch;
    while ((ch = fgetc(sourceCode)) != EOF) {
        if (isspace(ch)) {
            if (ch == '\n') currentLine++;
            continue;
        }
        
        if (isalpha(ch)) {
            int i = 0;
            nextToken.lexeme[i++] = ch;
            while (isalnum(ch = fgetc(sourceCode))) {
                nextToken.lexeme[i++] = ch;
            }
            nextToken.lexeme[i] = '\0';
            ungetc(ch, sourceCode);

            if (strcmp(nextToken.lexeme, "PROGRAM") == 0) nextToken.token = PROGRAM;
            else if (strcmp(nextToken.lexeme, "VAR") == 0) nextToken.token = VAR;
            else if (strcmp(nextToken.lexeme, "BEGIN") == 0) nextToken.token = BEGIN;
            else if (strcmp(nextToken.lexeme, "END") == 0) nextToken.token = END;
            else nextToken.token = ID;
            return;
        }

        if (isdigit(ch)) {
            int i = 0;
            nextToken.lexeme[i++] = ch;
            while (isdigit(ch = fgetc(sourceCode))) {
                nextToken.lexeme[i++] = ch;
            }
            nextToken.lexeme[i] = '\0';
            ungetc(ch, sourceCode);
            nextToken.token = ICONST;
            return;
        }

        switch (ch) {
            case '=': nextToken.token = RELOP; strcpy(nextToken.lexeme, "="); return;
            case '+': nextToken.token = ADDOP; strcpy(nextToken.lexeme, "+"); return;
            case '*': nextToken.token = MULDIVANDOP; strcpy(nextToken.lexeme, "*"); return;
            case ';': nextToken.token = ERROR; strcpy(nextToken.lexeme, ";"); return;
            case ':': 
                if ((ch = fgetc(sourceCode)) == '=') {
                    nextToken.token = RELOP; strcpy(nextToken.lexeme, ":=");
                } else {
                    ungetc(ch, sourceCode);
                    nextToken.token = ERROR;
                }
                return;
        }
    }
    nextToken.token = EOF_SYM;
}

void printToken(Token token) {
    printf("Token: %d, Lexeme: %s, Line: %d\n", token.token, token.lexeme, token.lineNumber);
}