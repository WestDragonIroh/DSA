// B Plus Tree

#include <stdio.h>
#include <stdlib.h>

// Function Prototypes

struct InternalNode typedef InternalNode;
struct LeafNode typedef LeafNode;
enum NodeType typedef NodeType;
struct Node typedef Node;
struct BPlusTree typedef BPlusTree;
InternalNode *InternalNode_init(int m);
LeafNode *LeafNode_init(int m);
Node Node_createNewNode(Node node, int m);
void Node_freeNode(Node node);
int Node_getLen(Node node);
void Node_setLen(Node node, int len);
InternalNode *Node_getParent(Node node);
void Node_setParent(Node node, InternalNode *parent);
int *Node_getKeys(Node node);
void Node_setKeys(Node node, int *keys);
Node *Node_getChildren(Node node);
void Node_setChildren(Node node, Node *children);
char **Node_getData(Node node);
void Node_setData(Node node, char **data);
LeafNode *Node_getNext(Node node);
void Node_setNext(Node node, LeafNode *next);
BPlusTree *BPlusTree_init(int m);
int binarySearch(int *list, int len, int key);
char *BPlusTree_search(BPlusTree *tree, int key);
int BPlusTree_successorKey(Node node);
void BPlusTree_insert(BPlusTree *tree, int key, char *data);
void BPlusTree_splitNode(BPlusTree *tree, Node node, int extra_key,
                         char *extra_data);
void BPlusTree_delete(BPlusTree *tree, int val);
void BPlusTree_mergeChildren(BPlusTree *tree, InternalNode *node, int index);
void BPlusTree_borrowLeft(InternalNode *parent, int index);
void BPlusTree_borrowRight(InternalNode *parent, int index);
void BPlusTree_fixRoutes(Node node);
void BPlusTree_print(BPlusTree *tree);
void __BPlusTree_printDepth(Node node, int depth);
int ceilDivide(int a, int b);

// Global Variables

// Main

int main() {
    int size = 13;
    int m = 5;
    char *data[] = {"This", "is",   "sample", "text",  "to", "check",    "if",
                    "B",    "plus", "tree",   "works", "as", "expected."};
    BPlusTree *tree = BPlusTree_init(m);
    for (int i = 0; i < size; i++) {
        BPlusTree_insert(tree, i + 1, data[i]);
    }
    BPlusTree_print(tree);
    printf("%s\n", BPlusTree_search(tree, 3));
    printf("%s\n", BPlusTree_search(tree, 10));
    printf("%s\n", BPlusTree_search(tree, 17));
    printf("%s\n", BPlusTree_search(tree, 8));
    BPlusTree_delete(tree, 3);
    BPlusTree_delete(tree, 9);
    BPlusTree_delete(tree, 12);
    BPlusTree_print(tree);
}

// Enums, Structs, Unions

struct InternalNode {
    int len;
    struct InternalNode *parent;
    int *keys;
    struct Node *children;
} typedef InternalNode;

struct LeafNode {
    int len;
    struct InternalNode *parent;
    int *keys;
    char **data;
    struct LeafNode *next;
} typedef LeafNode;

enum NodeType {
    Internal,
    Leaf,
} typedef NodeType;

struct Node {
    /// Tag
    NodeType t;
    /// Field
    union {
        InternalNode *Internal;
        LeafNode *Leaf;
    } f;
} typedef Node;

struct BPlusTree {
    Node root;
    int m;
    int mid;
    int min_keys;
} typedef BPlusTree;

// Functions

InternalNode *InternalNode_init(int m) {
    InternalNode *node = malloc(sizeof(InternalNode));
    node->len = 0;
    node->parent = NULL;
    node->keys = malloc((m - 1) * sizeof(int));
    node->children = malloc(m * sizeof(Node));
    return node;
}

LeafNode *LeafNode_init(int m) {
    LeafNode *node = malloc(sizeof(LeafNode));
    node->len = 0;
    node->parent = NULL;
    node->keys = malloc((m - 1) * sizeof(int));
    node->data = malloc((m - 1) * sizeof(char *));
    node->next = NULL;
    return node;
}

Node Node_createNewNode(Node node, int m) {
    if (node.t == Internal) {
        InternalNode *new_node = InternalNode_init(m);
        Node n = {.t = Internal, .f = {.Internal = new_node}};
        return n;
    } else {
        LeafNode *new_node = LeafNode_init(m);
        Node n = {.t = Leaf, .f = {.Leaf = new_node}};
        return n;
    }
}

void Node_freeNode(Node node) {
    if (node.t == Internal) {
        free(node.f.Internal);
    } else {
        free(node.f.Leaf);
    }
}

int Node_getLen(Node node) {
    if (node.t == Internal) {
        return node.f.Internal->len;
    } else {
        return node.f.Leaf->len;
    }
}
void Node_setLen(Node node, int len) {
    if (node.t == Internal) {
        node.f.Internal->len = len;
    } else {
        node.f.Leaf->len = len;
    }
}

InternalNode *Node_getParent(Node node) {
    if (node.t == Internal) {
        return node.f.Internal->parent;
    } else {
        return node.f.Leaf->parent;
    }
}
void Node_setParent(Node node, InternalNode *parent) {
    if (node.t == Internal) {
        node.f.Internal->parent = parent;
    } else {
        node.f.Leaf->parent = parent;
    }
}

int *Node_getKeys(Node node) {
    if (node.t == Internal) {
        return node.f.Internal->keys;
    } else {
        return node.f.Leaf->keys;
    }
}
void Node_setKeys(Node node, int *keys) {
    if (node.t == Internal) {
        node.f.Internal->keys = keys;
    } else {
        node.f.Leaf->keys = keys;
    }
}

Node *Node_getChildren(Node node) {
    if (node.t == Internal) {
        return node.f.Internal->children;
    } else {
        return NULL;
    }
}
void Node_setChildren(Node node, Node *children) {
    if (node.t == Internal) {
        node.f.Internal->children = children;
    }
}

char **Node_getData(Node node) {
    if (node.t == Internal) {
        return NULL;
    } else {
        return node.f.Leaf->data;
    }
}
void Node_setData(Node node, char **data) {
    if (node.t == Leaf) {
        node.f.Leaf->data = data;
    }
}

LeafNode *Node_getNext(Node node) {
    if (node.t == Internal) {
        return NULL;
    } else {
        return node.f.Leaf->next;
    }
}
void Node_setNext(Node node, LeafNode *next) {
    if (node.t == Leaf) {
        node.f.Leaf->next = next;
    }
}

BPlusTree *BPlusTree_init(int m) {
    BPlusTree *tree = malloc(sizeof(BPlusTree));
    LeafNode *leaf = LeafNode_init(m);
    tree->root = (Node){.t = Leaf, .f = {.Leaf = leaf}};
    tree->m = m;
    tree->mid = m / 2;
    tree->min_keys = ceilDivide(m, 2) - 1;
    return tree;
}

int binarySearch(int *list, int len, int key) {
    int low = 0;
    int high = len;
    while (low < high) {
        int mid = low + ((high - low) >> 1);
        if (list[mid] < key) {
            low = mid + 1;
        } else {
            high = mid;
        }
    }
    return low;
}

char *BPlusTree_search(BPlusTree *tree, int key) {
    Node node = tree->root;
    while (1) {
        if (node.t == Internal) {
            InternalNode *n = node.f.Internal;
            int i = binarySearch(n->keys, n->len, key);
            if (i < n->len && n->keys[i] == key) {
                node = n->children[i + 1];
            } else {
                node = n->children[i];
            }
        } else {
            LeafNode *n = node.f.Leaf;
            if (n->len > 0) {
                int i = binarySearch(n->keys, n->len, key);
                if (i < n->len && n->keys[i] == key) {
                    return n->data[i];
                }
            }
            return NULL;
        }
    }
}

int BPlusTree_successorKey(Node node) {
    while (1) {
        if (node.t == Internal) {
            node = node.f.Internal->children[0];
        } else {
            return node.f.Leaf->keys[0];
        }
    }
}

void BPlusTree_insert(BPlusTree *tree, int key, char *data) {
    Node current = tree->root;
    int i;
    while (1) {
        if (current.t == Internal) {
            InternalNode *n = current.f.Internal;
            i = binarySearch(n->keys, n->len, key);
            current = n->children[i];
        } else {
            LeafNode *n = current.f.Leaf;
            if (n->len > 0) {
                i = binarySearch(n->keys, n->len, key);
                int extra_key = n->keys[n->len - 1];
                char *extra_data = n->data[n->len - 1];
                if (i == n->len) {
                    extra_key = key;
                    extra_data = data;
                }
                int j = 1;
                while (j < (n->len - i)) {
                    n->keys[n->len - j] = n->keys[n->len - j - 1];
                    n->data[n->len - j] = n->data[n->len - j - 1];
                    j += 1;
                }
                if (i < n->len) {
                    n->keys[i] = key;
                    n->data[i] = data;
                }
                if (n->len < (tree->m - 1)) {
                    n->keys[n->len] = extra_key;
                    n->data[n->len] = extra_data;
                    n->len += 1;
                } else {
                    BPlusTree_splitNode(tree, current, extra_key, extra_data);
                }
            } else {
                n->keys[0] = key;
                n->data[0] = data;
                n->len += 1;
            }
            break;
        }
    }
}

void BPlusTree_splitNode(BPlusTree *tree, Node node, int extra_key,
                         char *extra_data) {
    Node extra_child = tree->root;
    Node new_node;
    while (1) {
        Node new_node = Node_createNewNode(node, tree->m);
        Node_setParent(new_node, Node_getParent(node));
        if (node.t == Internal) {
            InternalNode *n = node.f.Internal;
            InternalNode *nn = new_node.f.Internal;
            for (int i = (tree->mid + 1); i < n->len; i++) {
                nn->keys[i - tree->mid - 1] = n->keys[i];
                nn->children[i - tree->mid - 1] = n->children[i];
                Node_setParent(nn->children[i - tree->mid - 1], nn);
                nn->len += 1;
            }
            nn->keys[nn->len] = extra_key;
            nn->children[nn->len] = n->children[n->len];
            Node_setParent(nn->children[nn->len], nn);
            nn->len += 1;
            nn->children[nn->len] = extra_child;
            Node_setParent(extra_child, nn);
            n->len = tree->mid;
        } else {
            LeafNode *n = node.f.Leaf;
            LeafNode *nn = new_node.f.Leaf;
            for (int i = tree->mid; i < n->len; i++) {
                nn->keys[i - tree->mid] = n->keys[i];
                nn->data[i - tree->mid] = n->data[i];
                nn->len += 1;
            }
            nn->keys[nn->len] = extra_key;
            nn->data[nn->len] = extra_data;
            nn->len += 1;
            nn->next = n->next;
            n->next = nn;
            n->len = tree->mid;
        }
        int new_key = BPlusTree_successorKey(new_node);
        InternalNode *parent = Node_getParent(node);
        if (parent != NULL) {
            int i = binarySearch(parent->keys, parent->len, new_key);
            if (i == parent->len) {
                extra_key = new_key;
                extra_child = new_node;
            } else {
                extra_key = parent->keys[parent->len - 1];
                extra_child = parent->children[parent->len];
            }
            int j = 1;
            while (j < (parent->len - i)) {
                parent->keys[parent->len - j] =
                    parent->keys[parent->len - j - 1];
                parent->children[parent->len + 1 - j] =
                    parent->children[parent->len - j];
                j += 1;
            }
            if (i < parent->len) {
                parent->keys[i] = new_key;
                parent->children[i + 1] = new_node;
            }
            if (parent->len < (tree->m - 1)) {
                parent->keys[parent->len] = extra_key;
                parent->len += 1;
                parent->children[parent->len] = extra_child;
                break;
            }
            node = (Node){.t = Internal, .f = {.Internal = parent}};
        } else {
            parent = InternalNode_init(tree->m);
            parent->keys[0] = new_key;
            parent->len = 1;
            parent->children[0] = node;
            parent->children[1] = new_node;
            Node_setParent(node, parent);
            Node_setParent(new_node, parent);
            tree->root = (Node){.t = Internal, .f = {.Internal = parent}};
            break;
        }
    }
}

void BPlusTree_delete(BPlusTree *tree, int key) {
    Node current = tree->root;
    int i;
    while (1) {
        if (current.t == Internal) {
            InternalNode *n = current.f.Internal;
            i = binarySearch(n->keys, n->len, key);
            if (i < n->len && n->keys[i] == key) {
                current = n->children[i + 1];
            } else {
                current = n->children[i];
            }
        } else {
            LeafNode *n = current.f.Leaf;
            if (n->len > 0) {
                i = binarySearch(n->keys, n->len, key);
                if (i < n->len && n->keys[i] == key) {
                    int j = 0;
                    while (j < n->len - i - 1) {
                        n->keys[i + j] = n->keys[i + j + 1];
                        n->data[i + j] = n->data[i + j + 1];
                        j += 1;
                    }
                    n->len -= 1;
                    break;
                }
            }
            return;
        }
    }
    InternalNode *parent = Node_getParent(current);
    while (parent != NULL) {
        if (Node_getLen(current) < tree->min_keys) {
            i = binarySearch(parent->keys, parent->len, key);
            if (i < parent->len && parent->keys[i] == key) {
                i += 1;
            }
            if (i != 0 &&
                Node_getLen(parent->children[i - 1]) > tree->min_keys) {
                BPlusTree_borrowLeft(parent, i);
            } else if (i != parent->len &&
                       Node_getLen(parent->children[i + 1]) > tree->min_keys) {
                BPlusTree_borrowRight(parent, i);
            } else if (i != 0) {
                BPlusTree_mergeChildren(tree, parent, i - 1);
            } else {
                BPlusTree_mergeChildren(tree, parent, i);
            }
            if (parent->len == 0 && parent->parent == NULL) {
                free(parent);
                break;
            }
        }
        current = (Node){.t = Internal, .f = {.Internal = parent}};
        parent = parent->parent;
    }
    BPlusTree_fixRoutes(tree->root);
}

void BPlusTree_mergeChildren(BPlusTree *tree, InternalNode *node, int index) {
    Node child = node->children[index];
    Node node_to_free = node->children[1 + index];
    if (child.t == Internal) {
        InternalNode *n = child.f.Internal;
        InternalNode *nf = node_to_free.f.Internal;
        n->keys[n->len] = BPlusTree_successorKey(nf->children[0]);
        n->len += 1;
        n->children[n->len] = nf->children[0];
        for (int i = 0; i < nf->len; i++) {
            n->keys[n->len] = nf->keys[i];
            n->len += 1;
            n->children[n->len] = nf->children[i + 1];
            Node_setParent(nf->children[i + 1], n);
        }

    } else {
        LeafNode *n = child.f.Leaf;
        LeafNode *nf = node_to_free.f.Leaf;
        for (int i = 0; i < nf->len; i++) {
            n->keys[n->len] = nf->keys[i];
            n->data[n->len] = nf->data[i];
            n->len += 1;
        }
        n->next = nf->next;
    }
    node->len -= 1;
    for (int i = index; i < node->len; i++) {
        node->keys[i] = node->keys[i + 1];
        node->children[i + 1] = node->children[i + 2];
    }
    if (node->len == 0 && node->parent == NULL) {
        tree->root = child;
        Node_setParent(child, NULL);
    }
    Node_freeNode(node_to_free);
}

void BPlusTree_borrowLeft(InternalNode *parent, int index) {
    Node child = parent->children[index];
    Node left_child = parent->children[index - 1];
    if (child.t == Internal) {
        InternalNode *n = child.f.Internal;
        InternalNode *lc = left_child.f.Internal;
        n->children[n->len + 1] = n->children[n->len];
        for (int i = 0; i < n->len; i++) {
            n->keys[n->len - i] = n->keys[n->len - 1 - i];
            n->children[n->len - i] = n->children[n->len - 1 - i];
        }
        n->keys[0] = BPlusTree_successorKey(n->children[1]);
        n->children[0] = lc->children[lc->len];
        n->len += 1;
        lc->len -= 1;
    } else {
        LeafNode *n = child.f.Leaf;
        LeafNode *lc = left_child.f.Leaf;
        for (int i = 0; i < n->len; i++) {
            n->keys[n->len - i] = n->keys[n->len - 1 - i];
            n->data[n->len - i] = n->data[n->len - 1 - i];
        }
        n->keys[0] = lc->keys[lc->len - 1];
        n->data[0] = lc->data[lc->len - 1];
        n->len += 1;
        lc->len -= 1;
    }
}

void BPlusTree_borrowRight(InternalNode *parent, int index) {
    Node child = parent->children[index];
    Node right_child = parent->children[index + 1];
    if (child.t == Internal) {
        InternalNode *n = child.f.Internal;
        InternalNode *rc = right_child.f.Internal;
        n->keys[n->len] = BPlusTree_successorKey(rc->children[0]);
        n->len += 1;
        n->children[n->len] = rc->children[0];
        rc->len -= 1;
        for (int i = 0; i < rc->len; i++) {
            rc->keys[i] = rc->keys[i + 1];
            rc->children[i] = rc->children[i + 1];
        }
        rc->children[rc->len] = rc->children[rc->len + 1];
    } else {
        LeafNode *n = child.f.Leaf;
        LeafNode *rc = right_child.f.Leaf;
        n->keys[n->len] = rc->keys[0];
        n->data[n->len] = rc->data[0];
        n->len += 1;
        rc->len -= 1;
        for (int i = 0; i < rc->len; i++) {
            rc->keys[i] = rc->keys[i + 1];
            rc->data[i] = rc->data[i + 1];
        }
    }
}

void BPlusTree_fixRoutes(Node node) {
    if (node.t == Internal) {
        InternalNode *n = node.f.Internal;
        for (int i = 0; i < n->len; i++) {
            n->keys[i] = BPlusTree_successorKey(n->children[i + 1]);
        }
    }
}

void BPlusTree_print(BPlusTree *tree) {
    __BPlusTree_printDepth(tree->root, 0);
    printf("----------\n");
}

void __BPlusTree_printDepth(Node node, int depth) {
    int len = Node_getLen(node);
    if (len == 0) {
        return;
    }
    int *keys = Node_getKeys(node);
    for (int _ = 0; _ < depth; _++) {
        printf("    ");
    }
    printf("Keys: ");
    for (int i = 0; i < len; i++) {
        printf("%d ", keys[i]);
    }
    printf("\n");
    if (node.t == Internal) {
        InternalNode *n = node.f.Internal;
        for (int i = 0; i < (len + 1); i++) {
            __BPlusTree_printDepth(n->children[i], depth + 1);
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
