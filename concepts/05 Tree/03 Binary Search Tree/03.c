// Binary Search Tree

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct BinaryTreeNode typedef BTNode;
BTNode *insert(BTNode *node, int x);
BTNode *delete(BTNode *node, int x);
int inorderPredecessor(BTNode *node);
void inorderPrint(BTNode *node);

// Global Variables

// Main

int main() {
    int array[11] = {11, 6, 8, 19, 4, 10, 5, 17, 43, 49, 31};
    int size = 11;
    BTNode *root = NULL;
    for (int i = 0; i < size; i++) {
        root = insert(root, array[i]);
    }
    inorderPrint(root);
    printf("\n");
    root = delete (root, 31);
    root = delete (root, 4);
    root = delete (root, 11);
    inorderPrint(root);
}

struct BinaryTreeNode {
    int value;
    struct BinaryTreeNode *left;
    struct BinaryTreeNode *right;
} typedef BTNode;

BTNode *insert(BTNode *node, int x) {
    if (node == NULL) {
        BTNode *new_node = (BTNode *)malloc(sizeof(BTNode));
        new_node->value = x;
        return new_node;
    }
    if (node->value < x) {
        node->right = insert(node->right, x);
    } else {
        node->left = insert(node->left, x);
    }
    return node;
}

BTNode *delete(BTNode *node, int x) {
    if (node == NULL) {
        return node;
    }
    if (node->value < x) {
        node->right = delete (node->right, x);
    } else if (node->value > x) {
        node->left = delete (node->left, x);
    } else if (node->value == x) {
        BTNode *to_free = node;
        if (node->left == NULL && node->right == NULL) {
            node = NULL;
        } else if (node->left == NULL) {
            node = node->right;
        } else if (node->right == NULL) {
            node = node->left;
        } else {
            int prev = inorderPredecessor(node->left);
            BTNode *new_node = (BTNode *)malloc(sizeof(BTNode));
            new_node->value = prev;
            new_node->left = delete (node->left, prev);
            new_node->right = node->right;
            node = new_node;
        }
        free(to_free);
    }
    return node;
}

int inorderPredecessor(BTNode *node) {
    while (node->right != NULL) {
        node = node->right;
    }
    return node->value;
}

void inorderPrint(BTNode *node) {
    if (node == NULL) {
        return;
    }
    inorderPrint(node->left);
    printf("%d ", node->value);
    inorderPrint(node->right);
}
