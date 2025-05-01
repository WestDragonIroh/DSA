// AVL Tree

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct AVLTreeNode typedef AVLTNode;
AVLTNode *create_node(int x);
AVLTNode *insert(AVLTNode *node, int x);
AVLTNode *delete(AVLTNode *node, int x);
int inorderPredecessor(AVLTNode *node);
AVLTNode *balanceNode(AVLTNode *node);
int getBalance(AVLTNode *node);
int height(AVLTNode *node);
int max(int x, int y);
AVLTNode *leftRotate(AVLTNode *x);
AVLTNode *rightRotate(AVLTNode *z);
void preorderPrint(AVLTNode *node);
void inorderPrint(AVLTNode *node);
void postorderPrint(AVLTNode *node);

// Global Variables

// Main

int main() {
    int array[13] = {14, 17, 11, 7, 53, 4, 13, 12, 8, 60, 19, 16, 20};
    int size = 13;
    AVLTNode *root = NULL;
    for (int i = 0; i < size; i++) {
        root = insert(root, array[i]);
    }
    inorderPrint(root);
    printf("\n");
    preorderPrint(root);
    printf("\n");
    root = delete (root, 8);
    root = delete (root, 7);
    root = delete (root, 11);
    root = delete (root, 14);
    root = delete (root, 17);
    inorderPrint(root);
    printf("\n");
    preorderPrint(root);
    printf("\n");
}

struct AVLTreeNode {
    int value;
    struct AVLTreeNode *left;
    struct AVLTreeNode *right;
    int height;
} typedef AVLTNode;

AVLTNode *create_node(int x) {
    AVLTNode *node = (AVLTNode *)malloc(sizeof(AVLTNode));
    node->value = x;
    node->left = NULL;
    node->right = NULL;
    node->height = 0;
    return node;
}

AVLTNode *insert(AVLTNode *node, int val) {
    if (node == NULL) {
        return create_node(val);
    }
    if (node->value < val) {
        node->right = insert(node->right, val);
    } else {
        node->left = insert(node->left, val);
    }
    node->height = 1 + max(height(node->left), height(node->right));
    return balanceNode(node);
}

AVLTNode *delete(AVLTNode *node, int val) {
    if (node == NULL) {
        return node;
    }
    if (node->value < val) {
        node->right = delete (node->right, val);
    } else if (node->value > val) {
        node->left = delete (node->left, val);
    } else if (node->value == val) {
        AVLTNode *to_free = node;
        if (node->left == NULL && node->right == NULL) {
            node = NULL;
        } else if (node->left == NULL) {
            node = node->right;
        } else if (node->right == NULL) {
            node = node->left;
        } else {
            int prev = inorderPredecessor(node->left);
            AVLTNode *new_node = (AVLTNode *)malloc(sizeof(AVLTNode));
            new_node->value = prev;
            new_node->left = delete (node->left, prev);
            new_node->right = node->right;
            node = new_node;
        }
        free(to_free);
    }
    if (node == NULL) {
        return NULL;
    }
    node->height = 1 + max(height(node->left), height(node->right));
    return balanceNode(node);
}

int inorderPredecessor(AVLTNode *node) {
    while (node->right != NULL) {
        node = node->right;
    }
    return node->value;
}

AVLTNode *balanceNode(AVLTNode *node) {
    int balance = getBalance(node);
    if (balance > 1 && getBalance(node->left) >= 0) {
        node = rightRotate(node);
    } else if (balance > 1 && getBalance(node->left) < 0) {
        node->left = leftRotate(node->left);
        node = rightRotate(node);
    } else if (balance < -1 && getBalance(node->right) <= 0) {
        node = leftRotate(node);
    } else if (balance < -1 && getBalance(node->right) > 0) {
        node->right = rightRotate(node->right);
        node = leftRotate(node);
    }
    return node;
}

int getBalance(AVLTNode *node) {
    if (node == NULL) {
        return 0;
    }
    return height(node->left) - height(node->right);
}

int height(AVLTNode *node) {
    if (node == NULL) {
        return 0;
    }
    return node->height;
}

int max(int x, int y) { return (x > y) ? x : y; }

AVLTNode *leftRotate(AVLTNode *x) {
    AVLTNode *z = x->right;
    AVLTNode *y = z->left;
    z->left = x;
    x->right = y;
    x->height = 1 + max(height(x->left), height(x->right));
    z->height = 1 + max(height(z->left), height(z->right));
    return z;
}

AVLTNode *rightRotate(AVLTNode *z) {
    AVLTNode *x = z->left;
    AVLTNode *y = x->right;
    x->right = z;
    z->left = y;
    z->height = 1 + max(height(z->left), height(z->right));
    x->height = 1 + max(height(x->left), height(x->right));
    return x;
}

void preorderPrint(AVLTNode *node) {
    if (node == NULL) {
        return;
    }
    printf("%d ", node->value);
    preorderPrint(node->left);
    preorderPrint(node->right);
}

void inorderPrint(AVLTNode *node) {
    if (node == NULL) {
        return;
    }
    inorderPrint(node->left);
    printf("%d ", node->value);
    inorderPrint(node->right);
}

void postorderPrint(AVLTNode *node) {
    if (node == NULL) {
        return;
    }
    postorderPrint(node->left);
    postorderPrint(node->right);
    printf("%d ", node->value);
}
