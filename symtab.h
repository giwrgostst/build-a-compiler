#ifndef SYMTAB_H
#define SYMTAB_H

#define MAX_LEXEME_LEN 100

typedef enum { STATIC_VAR, LOCAL_VAR } StorageClass;

typedef struct {
    char name[MAX_LEXEME_LEN];  
    VarType type;               
    int address;                
    StorageClass storageClass;   
} SymbolTableEntry;

extern SymbolTableEntry symbolTable[100];
extern int symbolTableSize;

void addSymbol(char *name, VarType type, StorageClass storageClass);
int findSymbol(char *name);
void printSymbolTable();

#endif
