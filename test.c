#include <stdio.h>
#include "ast.h"
#include "symtab.h"
#include "mips.h"

void assignOffsets() {
    int globalOffset = 0;
    int localOffset = 0;

    for (int i = 0; i < symbolTableSize; i++) {
        if (symbolTable[i].storageClass == STATIC_VAR) {
            symbolTable[i].address = globalOffset;
            globalOffset += sizeof(int);
        } else if (symbolTable[i].storageClass == LOCAL_VAR) {
            symbolTable[i].address = localOffset;
            localOffset += sizeof(int);
        }
    }
}

void generateArrayAccessCode(ASTNode *node) {
    printf("lw $t0, %d($gp)\n", node->left->symbol->address);
    printf("lw $t1, %d($gp)\n", node->right->symbol->address);
    printf("mul $t1, $t1, 4\n");
    printf("add $t0, $t0, $t1\n");
}

void generateFunctionCall(ASTNode *node) {
    int paramCount = 0;
    ASTNode *param = node->left;
    
    while (param != NULL) {
        printf("lw $t%d, %d($gp)\n", paramCount, param->symbol->address);
        printf("sw $t%d, %d($sp)\n", paramCount, paramCount * 4);
        param = param->right;
        paramCount++;
    }
    
    printf("jal %s\n", node->symbol->name);
    printf("move $t0, $v0\n");
}

void generateLoadCode(ASTNode *node) {
    if (node->symbol->storageClass == LOCAL_VAR) {
        printf("lw $t0, %d($sp)\n", node->symbol->address);
    } else {
        printf("lw $t0, %d($gp)\n", node->symbol->address);
    }
}

void generatePrintfCall(ASTNode *node) {
    printf(".data\nfmt_string: .asciiz \"%s\"\n.text\n", node->symbol->name);
    printf("la $a0, fmt_string\n");
    printf("lw $a1, %d($gp)\n", node->left->symbol->address);
    printf("jal _printf\n");
}

void assignTempVariable(ASTNode *node) {
    static int tempVarCount = 0;
    printf("sw $t0, %d($sp)\n", tempVarCount * 4);
    node->symbol->address = tempVarCount * 4;
    tempVarCount++;
}

void assignRegisters(ASTNode *node) {
    printf("move $t%d, $t0\n", node->symbol->address / 4);
}

void spillTempVariable(ASTNode *node) {
    printf("sw $t0, %d($sp)\n", node->symbol->address);
}

void saveRegistersBeforeCall() {
    printf("sw $t0, 0($sp)\n");
    printf("sw $t1, 4($sp)\n");
}

void restoreRegistersAfterCall() {
    printf("lw $t0, 0($sp)\n");
    printf("lw $t1, 4($sp)\n");
}

void generateFinalCode(ASTNode *node) {
    if (node == NULL) return;

    switch (node->type) {
        case ADDOP:
            generateLoadCode(node->left);
            generateLoadCode(node->right);
            printf("add $t0, $t1, $t2\n");
            assignTempVariable(node);
            break;
        case MULOP:
            generateLoadCode(node->left);
            generateLoadCode(node->right);
            printf("mul $t0, $t1, $t2\n");
            assignTempVariable(node);
            break;
    }

    generateFinalCode(node->left);
    generateFinalCode(node->right);
}