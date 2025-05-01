// Binary Tree

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct BinaryTreeNode typedef BTNode;
BTNode *create();

// Global Variables

// Main

int main() { BTNode *root = create(); }

struct BinaryTreeNode {
    int value;
    struct BinaryTreeNode *left;
    struct BinaryTreeNode *right;
} typedef BTNode;

BTNode *create() {
    int x;
    printf("Enter data for Node(-1 for no node): ");
    scanf("%d", &x);
    if (x == -1) {
        return NULL;
    }
    BTNode *node = (BTNode *)malloc(sizeof(BTNode));
    node->value = x;
    printf("Enter left child of %d\n", x);
    node->left = create();
    printf("Enter right child of %d\n", x);
    node->right = create();
    return node;
}
