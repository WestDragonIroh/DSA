# Red Black Tree

- It is self balancing BST.
- Every node is either `Black` or `Red`.
- Root is always `Black`.
- `Nil` nodes are `Black`.
- `Red` node's children are `Black`.
- Every path from a node to it's decendent `Nil` node has same number of `Black` nodes.
- All AVL trees can be red black tree.
- It is roughly height balanced.
- Longest path from a node is no more than twice length of shortest path to any leaf.

## Insertion

1. If tree is empty, create `new_node` as root node with colour `Black`.
2. If tree is not empty, create `new_node` as leaf node with colour `Red`.
3. If parent of `new_node` is `Black` then exit.
4. If parent of `new_node` is `Red` then check the colour of uncle.
    - If colour is `Black` or `NULL` then do suitable rotation and recolour.
    - If colour is `Red` then recolour and also check if grandparent is not root node then recolour it and recheck.

## Deletion

1. Do normal BST deletion.
2. If deleted node is red then no furthur steps needed.
3. If sibling of `deleted_node` is `Red` then make sibling `Black`, parent `Red` and do suitable rotation
4. If sibling of `deleted_node` is `Black` then change colour to `Red` and check children of sibling.
    - If both of them are `Black` do nothing.
    - If either of them is `Red` do suitable rotation.

#

Reference [Red-Black Trees // Michael Sambol](https://youtube.com/playlist?list=PL9xmBV_5YoZNqDI8qfOZgzbqahCUmUEin&si=u9bKTPogDpPudonx)
