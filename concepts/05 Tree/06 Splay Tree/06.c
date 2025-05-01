// Splay Tree

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct SplayTreeNode typedef STNode;
STNode *createNode(int val);
STNode *splay(STNode *root, STNode *node);
STNode *search(STNode *root, int val);
STNode *insert(STNode *root, int val);
STNode *delete(STNode *root, int x);
STNode *inorderSuccessor(STNode *node);
STNode *leftRotate(STNode *root, STNode *x);
STNode *rightRotate(STNode *root, STNode *z);
STNode *parentCorrection(STNode *root, STNode *old_node, STNode *parent,
                         STNode *new_node);
void printTree(STNode *root, int depth);

// Global Variables

// Main

int main() {
    int array[8] = {15, 10, 17, 7, 13, 16, 14, 12};
    int size = 8;
    STNode *root = NULL;
    for (int i = 0; i < size; i++) {
        root = insert(root, array[i]);
    }
    printTree(root, 0);
    printf("----------\n");
    root = search(root, 12);
    root = search(root, 15);
    printTree(root, 0);
    printf("----------\n");
    root = delete (root, 16);
    root = delete (root, 12);
    root = delete (root, 7);
    printTree(root, 0);
}

struct SplayTreeNode {
    int value;
    struct SplayTreeNode *left, *right, *parent;
} typedef STNode;

STNode *createNode(int val) {
    STNode *node = (STNode *)malloc(sizeof(STNode));
    node->value = val;
    node->left = NULL;
    node->right = NULL;
    node->parent = NULL;
    return node;
}

STNode *splay(STNode *root, STNode *node) {
    while (node->parent != NULL) {
        STNode *parent = node->parent;
        STNode *grandparent = parent->parent;
        if (grandparent == NULL) {
            if (node == parent->left) {
                root = rightRotate(root, parent);
            } else {
                root = leftRotate(root, parent);
            }
        } else {
            if (node == parent->left && parent == grandparent->left) {
                root = rightRotate(root, grandparent);
                root = rightRotate(root, parent);
            } else if (node == parent->right && parent == grandparent->right) {
                root = leftRotate(root, grandparent);
                root = leftRotate(root, parent);
            } else if (node == parent->left && parent == grandparent->right) {
                root = rightRotate(root, parent);
                root = leftRotate(root, grandparent);
            } else {
                root = leftRotate(root, parent);
                root = rightRotate(root, grandparent);
            }
        }
    }
    return root;
}

STNode *search(STNode *root, int val) {
    STNode *temp = root;
    while (temp != NULL) {
        if (val < temp->value) {
            temp = temp->left;
        } else if (val > temp->value) {
            temp = temp->right;
        } else {
            root = splay(root, temp);
            temp = NULL;
        }
    }
    return root;
}

STNode *insert(STNode *root, int val) {
    STNode *current = root;
    STNode *parent = NULL;
    while (current != NULL) {
        parent = current;
        if (val < current->value) {
            current = current->left;
        } else {
            current = current->right;
        }
    }
    STNode *node = createNode(val);
    node->parent = parent;
    if (parent == NULL) {
        root = node;
    } else if (val < parent->value) {
        parent->left = node;
    } else {
        parent->right = node;
    }
    root = splay(root, node);
    return root;
}

STNode *delete(STNode *root, int val) {
    STNode *node_to_delete = root;
    while (node_to_delete != NULL && node_to_delete->value != val) {
        if (val < node_to_delete->value) {
            node_to_delete = node_to_delete->left;
        } else {
            node_to_delete = node_to_delete->right;
        }
    }
    if (node_to_delete == NULL) {
        return root;
    }
    STNode *parent = node_to_delete->parent;
    if (node_to_delete->left != NULL && node_to_delete->right != NULL) {
        STNode *replacement = inorderSuccessor(node_to_delete->right);
        if (node_to_delete->right == replacement) {
            node_to_delete->right = replacement->right;
        } else {
            replacement->parent->left = replacement->right;
            if (replacement->right != NULL) {
                replacement->right->parent = replacement->parent;
            }
        }
        node_to_delete->value = replacement->value;
        node_to_delete = replacement;
    } else if (node_to_delete->left != NULL) {
        STNode *replacement = node_to_delete->left;
        replacement->parent = parent;
        root = parentCorrection(root, node_to_delete, parent, replacement);
    } else if (node_to_delete->right != NULL) {
        STNode *replacement = node_to_delete->right;
        replacement->parent = parent;
        root = parentCorrection(root, node_to_delete, parent, replacement);
    } else {
        root = parentCorrection(root, node_to_delete, parent, NULL);
    }
    free(node_to_delete);
    if (parent != NULL) {
        root = splay(root, parent);
    }
    return root;
}

STNode *inorderSuccessor(STNode *node) {
    while (node->left != NULL) {
        node = node->left;
    }
    return node;
}

STNode *leftRotate(STNode *root, STNode *x) {
    STNode *z = x->right;
    STNode *y = z->left;
    z->parent = x->parent;
    z->left = x;
    x->parent = z;
    x->right = y;
    if (y != NULL) {
        y->parent = x;
    }
    root = parentCorrection(root, x, z->parent, z);
    return root;
}

STNode *rightRotate(STNode *root, STNode *z) {
    STNode *x = z->left;
    STNode *y = x->right;
    x->parent = z->parent;
    x->right = z;
    z->parent = x;
    z->left = y;
    if (y != NULL) {
        y->parent = z;
    }
    root = parentCorrection(root, z, x->parent, x);
    return root;
}

STNode *parentCorrection(STNode *root, STNode *old_node, STNode *parent,
                         STNode *new_node) {
    if (parent == NULL)
        root = new_node;
    else if (parent->left == old_node)
        parent->left = new_node;
    else
        parent->right = new_node;
    return root;
}

void printTree(STNode *root, int depth) {
    if (root == NULL) {
        return;
    }
    printTree(root->right, depth + 1);
    for (int i = 0; i < depth; i++) {
        printf("    ");
    }
    printf("%d \n", root->value);
    printTree(root->left, depth + 1);
}
