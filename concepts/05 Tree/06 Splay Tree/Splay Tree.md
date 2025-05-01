# Splay Tree

- Self adjusted BST.
- It is roughly balanced BST.
- All oprations(search, insertion and deletion) are followed by splaying operation.
- Splaying operation is rearranging of tree so that the element on which you are performing the operation becomes root of tree.

## Splaying

1. If node is root node then return root.
2. If parent is root then
    - If node is left child do right rotation on parent.
    - If node is right child do left rotation on parent.
3. If node have parent and grandparent then
    - If node and parent are both left child then do right rotation on grandparent and parent.
    - If node and parent are both right child then do left rotation on grandparent and parent.
    - If node is left child and parent is right child then right rotate parent and left rotate grandparent.
    - If node is right child and parent is left child then left rotate parent and right rotate grandparent.