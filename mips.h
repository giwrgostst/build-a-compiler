#ifndef MIPS_H
#define MIPS_H

#define SP 29
#define GP 28
#define V0 2

void assignOffsets();
void generateArrayAccessCode(ASTNode *node);
void generateFunctionCall(ASTNode *node);
void generateLoadCode(ASTNode *node);
void generatePrintfCall(ASTNode *node);
void assignTempVariable(ASTNode *node);
void assignRegisters(ASTNode *node);
void spillTempVariable(ASTNode *node);
void saveRegistersBeforeCall();
void restoreRegistersAfterCall();
void generateFinalCode(ASTNode *node);

#endif