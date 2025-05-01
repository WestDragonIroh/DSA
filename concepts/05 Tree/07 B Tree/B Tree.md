# B Tree

- Balanced m-way(order) tree.
- Generalization of BST in which a node can have more than one key and more than 2 children.
- Maintains sorted data.
- All leaf node must be at same level.
- Insertion will always be on leaf nodes.
- Min value of `m` possible is 3.
- B tree of order `m` has following properties.
    1. Every node has max `m` children.
    2. Min children:
        - Leaf -> 0
        - Root -> 2 (if not leaf)
        - Internal node -> [`m`/2] (celing)
    3. Every node has max (`m` - 1) keys.
    4. Min keys:
        - Root -> 1
        - Other nodes -> [`m`/2] - 1


## Insertion

- If number of keys in node is less than min keys then add value.
- Else split the node and send mid index value to parent.
- If parent not present then create new parent which will also become tree's new root.


## Deletion

-  For leaf node, if number of keys is more than min keys then just delete the value.
- For non-leaf node
    1. If both child have min keys then merge them
    2. Replace deleted key with it's inorder predecessor/successor if their node have more than min key else repeat deletion logic on them.
- If number of keys is less than min keys after deletion than borrow a key from immediate sibling if they have enough keys.
- If sibling don't have enough keys then merge node with its sibling.



#

Reference [B_Trees // Michael Sambol](https://www.youtube.com/playlist?list=PL9xmBV_5YoZNFPPv98DjTdD9X6UI9KMHz)