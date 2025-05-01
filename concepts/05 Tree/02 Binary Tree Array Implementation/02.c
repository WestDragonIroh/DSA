// Binary Tree Array Implementation

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct BinaryTreeNode typedef BTNode;
BTNode *create();
BTNode *arrayToTree(int x);
void treeToArray(BTNode *node, int x);

// Global Variables

int size = 100;
int tree[100] = {1, 2, 3, 4, 5, 6, 7, 8, 9};

// Main

int main() {
    // BTNode *root = create();
    BTNode *root = arrayToTree(0);
    treeToArray(root, 0);
    for (int i = 0; i < size; i++) {
        printf("%d,", tree[i]);
    }
}

struct BinaryTreeNode {
    int value;
    struct BinaryTreeNode *left;
    struct BinaryTreeNode *right;
} typedef BTNode;

BTNode *create() {
    int x;
    printf("Enter data for Node(0 for no node): ");
    scanf("%d", &x);
    if (x == 0) {
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

BTNode *arrayToTree(int x) {
    if (x >= size || tree[x] == 0) {
        return NULL;
    }
    BTNode *node = (BTNode *)malloc(sizeof(BTNode));
    node->value = tree[x];
    node->left = arrayToTree(2 * x + 1);
    node->right = arrayToTree(2 * x + 2);
    return node;
}

void treeToArray(BTNode *node, int x) {
    if (x >= size) {
        return;
    }
    if (node == NULL) {
        tree[x] = 0;
    } else {
        tree[x] = node->value;
        treeToArray(node->left, 2 * x + 1);
        treeToArray(node->right, 2 * x + 2);
    }
}
