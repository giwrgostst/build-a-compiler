#ifndef AST_H
#define AST_H

typedef enum { INT_TYPE, REAL_TYPE, BOOL_TYPE, CHAR_TYPE } VarType;

typedef struct ASTNode {
    VarType type;
    struct ASTNode *left;
    struct ASTNode *right;
    char operation[3];
} ASTNode;

ASTNode* createASTNode(VarType type, char *operation, ASTNode *left, ASTNode *right);

void printAST(ASTNode *node);

#endif