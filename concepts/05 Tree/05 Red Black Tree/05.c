// Red Black Tree

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct RedBlackTreeNode typedef RBTNode;
RBTNode *createNode(int val, int is_null);
RBTNode *insert(RBTNode *root, int val);
RBTNode *fixupInsertion(RBTNode *root, RBTNode *node);
RBTNode *delete(RBTNode *root, int x);
RBTNode *fixupDeletion(RBTNode *root, RBTNode *node);
RBTNode *inorderSuccessor(RBTNode *node);
RBTNode *transplant(RBTNode *root, RBTNode *u, RBTNode *v);
RBTNode *leftRotate(RBTNode *root, RBTNode *x);
RBTNode *rightRotate(RBTNode *root, RBTNode *z);
RBTNode *corrParAftRota(RBTNode *root, RBTNode *node, RBTNode *rotated);
void printTree(RBTNode *root, int depth);

// Global Variables

// Main

int main() {
    int array[12] = {10, 18, 7, 15, 16, 30, 25, 40, 60, 2, 1, 70};
    int size = 12;
    RBTNode *root = createNode(0, 1);
    for (int i = 0; i < size; i++) {
        root = insert(root, array[i]);
    }
    printTree(root, 0);
    printf("----------\n");
    root = delete (root, 16);
    root = delete (root, 60);
    root = delete (root, 10);
    root = delete (root, 25);
    root = delete (root, 40);
    printTree(root, 0);
}

struct RedBlackTreeNode {
    int value, colour, is_null;
    struct RedBlackTreeNode *left, *right, *parent;
} typedef RBTNode;

RBTNode *createNode(int val, int is_null) {
    RBTNode *node = (RBTNode *)malloc(sizeof(RBTNode));
    node->value = val;
    node->colour = 1;
    node->left = NULL;
    node->right = NULL;
    node->parent = NULL;
    node->is_null = is_null;
    if (is_null == 1) {
        node->colour = 0;
    } else {
        node->left = createNode(0, 1);
        node->left->parent = node;
        node->right = createNode(0, 1);
        node->right->parent = node;
    }
    return node;
}

RBTNode *insert(RBTNode *root, int val) {
    RBTNode *node = createNode(val, 0);
    RBTNode *current = root;
    RBTNode *parent = NULL;
    while (current->is_null == 0) {
        parent = current;
        if (current->value < val) {
            current = current->right;
        } else {
            current = current->left;
        }
    }
    node->parent = parent;
    if (parent == NULL) {
        root = node;
        root->colour = 0;
    } else if (parent->value < val) {
        parent->right = node;
    } else {
        parent->left = node;
    }
    root = fixupInsertion(root, node);
    free(current);
    return root;
}

RBTNode *fixupInsertion(RBTNode *root, RBTNode *node) {
    RBTNode *grandparent, *uncle, *rotated;
    while (node != root && node->parent->colour == 1) {
        grandparent = node->parent->parent;
        if (node->parent == grandparent->left) {
            uncle = grandparent->right;
            if (uncle->colour == 1) {
                node->parent->colour = 0;
                uncle->colour = 0;
                grandparent->colour = 1;
                node = grandparent;
            } else {
                if (node == node->parent->right) {
                    node = node->parent;
                    root = leftRotate(root, node);
                }
                node->parent->colour = 0;
                grandparent->colour = 1;
                root = rightRotate(root, grandparent);
            }
        } else {
            uncle = grandparent->left;
            if (uncle->colour == 1) {
                node->parent->colour = 0;
                uncle->colour = 0;
                grandparent->colour = 1;
                node = grandparent;
            } else {
                if (node == node->parent->left) {
                    node = node->parent;
                    root = rightRotate(root, node);
                }
                node->parent->colour = 0;
                grandparent->colour = 1;
                root = leftRotate(root, grandparent);
            }
        }
    }
    root->colour = 0;
    return root;
}

RBTNode *delete(RBTNode *root, int val) {
    RBTNode *node_to_delete = root;
    while (node_to_delete->is_null == 0 && node_to_delete->value != val) {
        if (val < node_to_delete->value) {
            node_to_delete = node_to_delete->left;
        } else {
            node_to_delete = node_to_delete->right;
        }
    }
    if (node_to_delete->is_null == 1) {
        return root;
    }
    RBTNode *temp = node_to_delete;
    int original_colour = temp->colour;
    RBTNode *replacement;
    if (node_to_delete->left->is_null == 1) {
        replacement = node_to_delete->right;
        root = transplant(root, node_to_delete, replacement);
    } else if (node_to_delete->right->is_null == 1) {
        replacement = node_to_delete->left;
        root = transplant(root, node_to_delete, replacement);
    } else {
        temp = inorderSuccessor(node_to_delete->right);
        original_colour = temp->colour;
        replacement = temp->right;
        if (temp->parent == node_to_delete) {
            replacement->parent = temp;
        } else {
            root = transplant(root, temp, replacement);
            temp->right = node_to_delete->right;
            temp->right->parent = temp;
        }
        root = transplant(root, node_to_delete, temp);
        temp->left = node_to_delete->left;
        temp->left->parent = temp;
        temp->colour = node_to_delete->colour;
    }
    free(node_to_delete);
    if (original_colour == 0) {
        root = fixupDeletion(root, replacement);
    }
    return root;
}

RBTNode *fixupDeletion(RBTNode *root, RBTNode *node) {
    while (node != root && node->colour == 0) {
        RBTNode *parent = node->parent;
        if (node == parent->left) {
            RBTNode *sibling = parent->right;
            if (sibling->colour == 1) {
                sibling->colour = 0;
                parent->colour = 1;
                root = leftRotate(root, parent);
                sibling = parent->right;
            }
            if (sibling->left->colour == 0 && sibling->right->colour == 0) {
                sibling->colour = 1;
                node = parent;
            } else {
                if (sibling->right->colour == 0) {
                    sibling->left->colour = 0;
                    sibling->colour = 1;
                    root = rightRotate(root, sibling);
                    sibling = parent->right;
                }
                sibling->colour = parent->colour;
                parent->colour = 0;
                if (sibling->right) {
                    sibling->right->colour = 0;
                }
                root = leftRotate(root, parent);
                node = root;
            }
        } else {
            RBTNode *sibling = parent->left;
            if (sibling->colour == 1) {
                sibling->colour = 0;
                parent->colour = 1;
                root = rightRotate(root, parent);
                sibling = parent->left;
            }
            if (sibling->left->colour == 0 && sibling->right->colour == 0) {
                sibling->colour = 1;
                node = parent;
            } else {
                if (sibling->left->colour == 0) {
                    if (sibling->right) {
                        sibling->right->colour = 0;
                    }
                    sibling->colour = 1;
                    root = leftRotate(root, sibling);
                    sibling = parent->left;
                }
                sibling->colour = parent->colour;
                parent->colour = 0;
                sibling->left->colour = 0;
                root = rightRotate(root, parent);
                node = root;
            }
        }
    }
    node->colour = 0;
    return root;
}

RBTNode *inorderSuccessor(RBTNode *node) {
    while (node->left->is_null == 0) {
        node = node->left;
    }
    return node;
}

RBTNode *transplant(RBTNode *root, RBTNode *u, RBTNode *v) {
    if (u->parent == NULL) {
        root = v;
    } else if (u == u->parent->left) {
        u->parent->left = v;
    } else {
        u->parent->right = v;
    }
    v->parent = u->parent;
    return root;
}

RBTNode *leftRotate(RBTNode *root, RBTNode *x) {
    RBTNode *z = x->right;
    RBTNode *y = z->left;
    z->parent = x->parent;
    z->left = x;
    x->parent = z;
    x->right = y;
    if (y != NULL) {
        y->parent = x;
    }
    root = corrParAftRota(root, x, z);
    return root;
}

RBTNode *rightRotate(RBTNode *root, RBTNode *z) {
    RBTNode *x = z->left;
    RBTNode *y = x->right;
    x->parent = z->parent;
    x->right = z;
    z->parent = x;
    z->left = y;
    if (y != NULL) {
        y->parent = z;
    }
    root = corrParAftRota(root, z, x);
    return root;
}

// Correct Parent After Rotation
RBTNode *corrParAftRota(RBTNode *root, RBTNode *node, RBTNode *rotated) {
    if (rotated->parent == NULL)
        root = rotated;
    else if (rotated->parent->left == node)
        rotated->parent->left = rotated;
    else
        rotated->parent->right = rotated;
    return root;
}

void printTree(RBTNode *root, int depth) {
    if (root->is_null == 1) {
        return;
    }
    printTree(root->right, depth + 1);
    for (int i = 0; i < depth; i++) {
        printf("    ");
    }
    printf("%d (%s)\n", root->value, root->colour == 1 ? "R" : "B");
    printTree(root->left, depth + 1);
}
