// B_Tree

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct B_TreeNode typedef B_TNode;
struct B_Trees typedef B_Tree;
B_TNode *createNode(int m, int is_leaf);
B_Tree *createTree(int m);
int search(B_Tree *tree, int val);
void insert(B_Tree *tree, int val);
void splitNode(B_Tree *tree, B_TNode *node, int extra_key);
void delete(B_Tree *tree, int val);
void mergeChildren(B_Tree *tree, B_TNode *node, int index);
B_TNode *predecessorNode(B_TNode *node);
B_TNode *successorNode(B_TNode *node);
void borrowLeft(B_TNode *parent, int index);
void borrowRight(B_TNode *parent, int index);
void printTree(B_Tree *tree);
void __printTreeDepth(B_TNode *node, int depth);
int ceilDivide(int a, int b);

// Global Variables

// Main

int main() {
    int size = 20;
    int m = 3;
    B_Tree *tree = createTree(m);
    for (int i = 0; i < size; i++) {
        insert(tree, i + 1);
        // printTree(tree);
    }
    printTree(tree);
    delete (tree, 3);
    delete (tree, 16);
    delete (tree, 12);
    printTree(tree);
}

struct B_TreeNode {
    int num_keys;
    int is_leaf;
    struct B_TreeNode *parent;
    int *keys;
    struct B_TreeNode **children;
} typedef B_TNode;

struct B_Trees {
    B_TNode *root;
    int m;
    int mid;
    int min_keys;
} typedef B_Tree;

B_TNode *createNode(int m, int is_leaf) {
    B_TNode *node = malloc(sizeof(B_TNode));
    node->num_keys = 0;
    node->is_leaf = is_leaf;
    node->parent = NULL;
    node->keys = malloc((m - 1) * sizeof(int));
    node->children = malloc(m * sizeof(B_TNode *));
    for (int i = 0; i < m; i++) {
        node->children[i] = NULL;
    }
    return node;
}

B_Tree *createTree(int m) {
    B_Tree *tree = malloc(sizeof(B_Tree));
    tree->root = createNode(m, 1);
    tree->m = m;
    tree->mid = m / 2;
    tree->min_keys = ceilDivide(m, 2) - 1;
    return tree;
}

int search(B_Tree *tree, int val) {
    B_TNode *node = tree->root;
    while (node != NULL) {
        int i = 0;
        while (i < node->num_keys && val > node->keys[i]) {
            i++;
        }
        if (i < node->num_keys && val == node->keys[i]) {
            return 1;
        }
        if (node->is_leaf) {
            return 0;
        }
        node = node->children[i];
    }
    return 0;
}

void insert(B_Tree *tree, int val) {
    B_TNode *current = tree->root;
    int i;
    while (1) {
        for (i = 0; i < current->num_keys; i++) {
            if (val < current->keys[i]) {
                break;
            }
        }
        if (current->is_leaf) {
            break;
        } else {
            current = current->children[i];
        }
    }
    if (current->num_keys > 0) {
        int extra_key;
        if (i == current->num_keys) {
            extra_key = val;
        } else {
            extra_key = current->keys[current->num_keys - 1];
        }
        for (int j = 1; j < (current->num_keys - i); j++) {
            current->keys[current->num_keys - j] =
                current->keys[current->num_keys - j - 1];
        }
        if (i < current->num_keys) {
            current->keys[i] = val;
        }
        if (current->num_keys < (tree->m - 1)) {
            current->keys[current->num_keys] = extra_key;
            current->num_keys++;
        } else {
            splitNode(tree, current, extra_key);
        }
    } else {
        current->keys[0] = val;
        current->num_keys++;
    }
}

void splitNode(B_Tree *tree, B_TNode *node, int extra_key) {
    B_TNode *extra_child = tree->root;
    while (extra_child != NULL) {
        B_TNode *parent = node->parent;
        if (parent == NULL) {
            parent = createNode(tree->m, 0);
            parent->children[0] = node;
            tree->root->parent = parent;
            tree->root = parent;
        }
        B_TNode *new_node = createNode(tree->m, node->is_leaf);
        new_node->parent = parent;
        for (int i = 0; i < node->num_keys - tree->mid - 1; i++) {
            new_node->keys[i] = node->keys[tree->mid + 1 + i];
            new_node->num_keys++;
        }
        new_node->keys[new_node->num_keys] = extra_key;
        new_node->num_keys++;
        if (!new_node->is_leaf) {
            for (int i = 0; i < node->num_keys - tree->mid; i++) {
                new_node->children[i] = node->children[tree->mid + 1 + i];
                new_node->children[i]->parent = new_node;
            }
            new_node->children[new_node->num_keys] = extra_child;
            extra_child->parent = new_node;
        }
        int new_val = node->keys[tree->mid];
        node->num_keys = tree->mid;
        int i;
        for (i = 0; i < parent->num_keys; i++) {
            if (new_val < parent->keys[i]) {
                break;
            }
        }
        if (parent->num_keys > 0) {
            if (i == parent->num_keys) {
                extra_key = new_val;
                extra_child = new_node;
            } else {
                extra_key = parent->keys[parent->num_keys - 1];
                extra_child = parent->children[parent->num_keys];
            }
            for (int j = 1; j < (parent->num_keys - i); j++) {
                parent->keys[parent->num_keys - j] =
                    parent->keys[parent->num_keys - j - 1];
                parent->children[parent->num_keys + 1 - j] =
                    parent->children[parent->num_keys - j];
            }
            if (i < parent->num_keys) {
                parent->keys[i] = new_val;
                parent->children[i + 1] = new_node;
            }
            if (parent->num_keys < (tree->m - 1)) {
                parent->keys[parent->num_keys] = extra_key;
                parent->num_keys++;
                parent->children[parent->num_keys] = extra_child;
                extra_child = NULL;
            }
        } else {
            parent->keys[0] = new_val;
            parent->num_keys++;
            parent->children[1] = new_node;
            extra_child = NULL;
        }
        node = parent;
    }
}

void delete(B_Tree *tree, int val) {
    B_TNode *current = tree->root;
    int i;
    while (1) {
        for (i = 0; i < current->num_keys; i++) {
            if (val <= current->keys[i]) {
                break;
            }
        }
        if (i < current->num_keys && val == current->keys[i]) {
            break;
        }
        if (current->is_leaf) {
            return;
        } else {
            current = current->children[i];
        }
    }
    if (current->is_leaf) {
        for (int j = 0; j < current->num_keys - i; j++) {
            current->keys[i + j] = current->keys[i + j + 1];
        }
        current->num_keys--;
    } else {
        B_TNode *predecessor = predecessorNode(current->children[i]);
        B_TNode *successor = successorNode(current->children[i + 1]);
        if (predecessor->num_keys > tree->min_keys) {
            current->keys[i] = predecessor->keys[predecessor->num_keys - 1];
            predecessor->num_keys--;
        } else {
            current->keys[i] = successor->keys[0];
            for (int j = 0; j < successor->num_keys - 1; j++) {
                successor->keys[j] = successor->keys[j + 1];
            }
            successor->num_keys--;
            if (successor->num_keys < tree->min_keys) {
                current = successor;
            }
        }
    }
    while (current->num_keys < tree->min_keys && current->parent != NULL) {
        B_TNode *parent = current->parent;
        for (i = 0; i <= parent->num_keys; i++) {
            if (parent->children[i] == current) {
                break;
            }
        }
        B_TNode *sibling1, *sibling2;
        if (i == 0) {
            sibling1 = NULL;
        } else {
            sibling1 = parent->children[i - 1];
        }
        if (i == parent->num_keys) {
            sibling2 = NULL;
        } else {
            sibling2 = parent->children[i + 1];
        }
        if (sibling1 != NULL && sibling1->num_keys > tree->min_keys) {
            borrowLeft(parent, i);
        } else if (sibling2 != NULL && sibling2->num_keys > tree->min_keys) {
            borrowRight(parent, i);
        } else if (sibling1 != NULL) {
            mergeChildren(tree, parent, i - 1);
        } else {
            mergeChildren(tree, parent, i);
        }
        current = parent;
    }
}

void mergeChildren(B_Tree *tree, B_TNode *node, int index) {
    B_TNode *child = node->children[index];
    B_TNode *node_to_free = node->children[1 + index];
    child->keys[child->num_keys] = node->keys[index];
    child->num_keys++;
    for (int i = 0; i < node_to_free->num_keys; i++) {
        if (!child->is_leaf) {
            child->children[child->num_keys] = node_to_free->children[i];
        }
        child->keys[child->num_keys] = node_to_free->keys[i];
        child->num_keys++;
    }
    if (!child->is_leaf) {
        child->children[child->num_keys] =
            node_to_free->children[node_to_free->num_keys];
    }
    for (int i = index; i < node->num_keys; i++) {
        node->keys[i] = node->keys[i + 1];
        node->children[i + 1] = node->children[i + 2];
    }
    node->num_keys--;
    if (node->num_keys == 0 && node->parent == NULL) {
        tree->root = child;
    }
    free(node_to_free);
}

B_TNode *predecessorNode(B_TNode *node) {
    while (node->children[node->num_keys]) {
        node = node->children[node->num_keys];
    }
    return node;
}

B_TNode *successorNode(B_TNode *node) {
    while (node->children[0]) {
        node = node->children[0];
    }
    return node;
}

void borrowLeft(B_TNode *parent, int index) {
    B_TNode *child = parent->children[index];
    B_TNode *left_child = parent->children[index - 1];
    for (int i = 0; i < child->num_keys; i++) {
        child->keys[child->num_keys - i] = child->keys[child->num_keys - 1 - i];
        if (!child->is_leaf) {
            child->children[child->num_keys + 1 - i] =
                child->children[child->num_keys - i];
        }
    }
    if (!child->is_leaf) {
        child->children[1] = child->children[0];
        child->children[0] = left_child->children[left_child->num_keys];
        left_child->children[left_child->num_keys] = NULL;
    }
    child->keys[0] = parent->keys[index - 1];
    child->num_keys++;
    parent->keys[index - 1] = left_child->keys[left_child->num_keys - 1];
    left_child->num_keys--;
}

void borrowRight(B_TNode *parent, int index) {
    B_TNode *child = parent->children[index];
    B_TNode *right_child = parent->children[index + 1];
    child->keys[child->num_keys] = parent->keys[index];
    child->num_keys++;
    parent->keys[index] = right_child->keys[0];
    if (!child->is_leaf) {
        child->children[child->num_keys] = right_child->children[0];
    }
    for (int i = 0; i < right_child->num_keys - 1; i++) {
        right_child->keys[i] = right_child->keys[i + 1];
        if (!right_child->is_leaf) {
            right_child->children[i] = right_child->children[i + 1];
        }
    }
    if (!right_child->is_leaf) {
        right_child->children[right_child->num_keys - 1] =
            right_child->children[right_child->num_keys];
        right_child->children[right_child->num_keys] = NULL;
    }
    right_child->num_keys--;
}

void printTree(B_Tree *tree) {
    __printTreeDepth(tree->root, 0);
    printf("----------\n");
}

void __printTreeDepth(B_TNode *node, int depth) {
    if (node == NULL) {
        return;
    }
    for (int i = 0; i < depth; i++) {
        printf("    ");
    }
    printf("Keys: ");
    for (int i = 0; i < node->num_keys; i++) {
        printf("%d ", node->keys[i]);
    }
    printf("\n");
    if (!node->is_leaf) {
        for (int i = 0; i <= node->num_keys; i++) {
            __printTreeDepth(node->children[i], depth + 1);
        }
    }
}

int ceilDivide(int a, int b) {
    int c = a / b;
    if (a != (b * c) && c > 0) {
        c++;
    }
    return c;
}
