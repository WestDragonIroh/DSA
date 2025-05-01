// Red Black Tree

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const T = u8;
    const array = [_]T{ 10, 18, 7, 15, 16, 30, 25, 40, 60, 2, 1, 70 };

    var tree: RBTree(T) = undefined;
    try tree.init(arena.allocator());

    for (array) |v| {
        try tree.insert(v);
    }
    tree.printTree();
    std.debug.print("----------\n", .{});
    try tree.delete(16);
    try tree.delete(60);
    try tree.delete(10);
    try tree.delete(25);
    try tree.delete(40);
    tree.printTree();
}

// Structs

pub fn RBTree(comptime DataType: type) type {
    return struct {
        const Self = @This();

        const RBTNode = struct {
            value: DataType,
            colour: u1,
            is_null: u1,
            left: ?*RBTNode,
            right: ?*RBTNode,
            parent: ?*RBTNode,

            fn init(allocator: std.mem.Allocator, value: DataType, is_null: u1) !*RBTNode {
                var node = try allocator.create(RBTNode);
                node.value = value;
                node.colour = 1; // Red node by default.
                node.is_null = is_null;
                node.left = null;
                node.right = null;
                node.parent = null;
                if (is_null == 1) {
                    node.colour = 0;
                } else {
                    node.left = try RBTNode.init(allocator, 0, 1);
                    node.left.?.parent = node;
                    node.right = try RBTNode.init(allocator, 0, 1);
                    node.right.?.parent = node;
                }
                return node;
            }
        };

        allocator: std.mem.Allocator,
        root: *RBTNode,

        fn init(self: *Self, allocator: std.mem.Allocator) !void {
            self.allocator = allocator;
            self.root = try RBTNode.init(allocator, 0, 1);
        }

        fn insert(self: *Self, val: DataType) !void {
            var node = try RBTNode.init(self.allocator, val, 0);
            var current: *RBTNode = self.root;
            var parent: ?*RBTNode = null;
            while (current.is_null == 0) {
                parent = current;
                if (current.value < val) {
                    current = current.right orelse unreachable;
                } else {
                    current = current.left orelse unreachable;
                }
            }
            node.parent = parent;
            if (parent) |par| {
                if (par.value < val) {
                    par.right = node;
                } else {
                    par.left = node;
                }
            } else {
                node.colour = 0;
                self.root = node;
            }
            self.fixupInsertion(node);
            self.allocator.destroy(current);
        }

        fn fixupInsertion(self: *Self, new_node: *RBTNode) void {
            var node = new_node;
            while (node != self.root and node.parent.?.colour == 1) {
                const parent = node.parent orelse unreachable;
                const grandparent = parent.parent orelse unreachable;
                if (node.parent == grandparent.left) {
                    const uncle = grandparent.right orelse unreachable;
                    if (uncle.colour == 1) {
                        parent.colour = 0;
                        uncle.colour = 0;
                        grandparent.colour = 1;
                        node = grandparent;
                    } else {
                        if (node == parent.right) {
                            node = parent;
                            self.leftRotate(node);
                        }
                        node.parent.?.colour = 0;
                        grandparent.colour = 1;
                        self.rightRotate(grandparent);
                    }
                } else {
                    const uncle = grandparent.left orelse unreachable;
                    if (uncle.colour == 1) {
                        parent.colour = 0;
                        uncle.colour = 0;
                        grandparent.colour = 1;
                        node = grandparent;
                    } else {
                        if (node == parent.left) {
                            node = parent;
                            self.rightRotate(node);
                        }
                        node.parent.?.colour = 0;
                        grandparent.colour = 1;
                        self.leftRotate(grandparent);
                    }
                }
            }
            self.root.colour = 0;
        }

        fn delete(self: *Self, val: DataType) !void {
            var node_to_delete = self.root;
            while (node_to_delete.is_null == 0 and node_to_delete.value != val) {
                if (val < node_to_delete.value) {
                    node_to_delete = node_to_delete.left orelse unreachable;
                } else {
                    node_to_delete = node_to_delete.right orelse unreachable;
                }
            }
            if (node_to_delete.is_null == 1) return;

            var temp = node_to_delete;
            var original_colour = temp.colour;
            var replacement = temp;
            if (node_to_delete.left.?.is_null == 1) {
                replacement = node_to_delete.right orelse unreachable;
                self.transplant(node_to_delete, replacement);
            } else if (node_to_delete.right.?.is_null == 1) {
                replacement = node_to_delete.left orelse unreachable;
                self.transplant(node_to_delete, replacement);
            } else {
                temp = inorderSuccessor(node_to_delete.right.?);
                original_colour = temp.colour;
                replacement = temp.right orelse unreachable;
                if (temp.parent == node_to_delete) {
                    replacement.parent = temp;
                } else {
                    self.transplant(temp, replacement);
                    temp.right = node_to_delete.right;
                    temp.right.?.parent = temp;
                }
                self.transplant(node_to_delete, temp);
                temp.left = node_to_delete.left;
                temp.left.?.parent = temp;
                temp.colour = node_to_delete.colour;
            }
            if (original_colour == 0) {
                self.fixupDeletion(replacement);
            }
            self.allocator.destroy(node_to_delete);
        }

        fn fixupDeletion(self: *Self, new_node: *RBTNode) void {
            var node = new_node;
            while (node != self.root and node.colour == 0) {
                const parent = node.parent orelse unreachable;
                if (node == parent.left) {
                    var sibling = parent.right orelse unreachable;
                    if (sibling.colour == 1) {
                        sibling.colour = 0;
                        parent.colour = 1;
                        self.leftRotate(parent);
                        sibling = parent.right.?;
                    }
                    if (sibling.left.?.colour == 0 and sibling.right.?.colour == 0) {
                        sibling.colour = 1;
                        node = parent;
                    } else {
                        if (sibling.right.?.colour == 0) {
                            sibling.left.?.colour = 0;
                            sibling.colour = 1;
                            self.rightRotate(sibling);
                            sibling = parent.right.?;
                        }
                        sibling.colour = parent.colour;
                        parent.colour = 0;
                        sibling.right.?.colour = 0;
                        self.leftRotate(parent);
                        node = self.root;
                    }
                } else {
                    var sibling = parent.left orelse unreachable;
                    if (sibling.colour == 1) {
                        sibling.colour = 0;
                        parent.colour = 1;
                        self.rightRotate(parent);
                        sibling = parent.left.?;
                    }
                    if (sibling.left.?.colour == 0 and sibling.right.?.colour == 0) {
                        sibling.colour = 1;
                        node = parent;
                    } else {
                        if (sibling.left.?.colour == 0) {
                            sibling.right.?.colour = 0;
                            sibling.colour = 1;
                            self.leftRotate(sibling);
                            sibling = parent.left.?;
                        }
                        sibling.colour = parent.colour;
                        parent.colour = 0;
                        sibling.left.?.colour = 0;
                        self.rightRotate(parent);
                        node = self.root;
                    }
                }
            }
            node.colour = 0;
        }

        fn inorderSuccessor(node: *RBTNode) *RBTNode {
            var temp = node;
            while (temp.left.?.is_null == 0) {
                temp = temp.left orelse unreachable;
            }
            return temp;
        }

        fn transplant(self: *Self, u: *RBTNode, v: *RBTNode) void {
            if (u.parent) |parent| {
                if (u == parent.left) {
                    parent.left = v;
                } else {
                    parent.right = v;
                }
            } else {
                self.root = v;
            }
            v.parent = u.parent;
        }

        fn leftRotate(self: *Self, x: *RBTNode) void {
            if (x.right) |z| {
                const maybe_y = z.left;
                z.parent = x.parent;
                z.left = x;
                x.parent = z;
                x.right = maybe_y;
                if (maybe_y) |y| {
                    y.parent = x;
                }
                self.corrParAftRota(x, z);
            }
        }

        fn rightRotate(self: *Self, z: *RBTNode) void {
            if (z.left) |x| {
                const maybe_y = x.right;
                x.parent = z.parent;
                x.right = z;
                z.parent = x;
                z.left = maybe_y;
                if (maybe_y) |y| {
                    y.parent = z;
                }
                self.corrParAftRota(z, x);
            }
        }

        /// Correct Parent After Rotation
        fn corrParAftRota(self: *Self, node: *RBTNode, rotated: *RBTNode) void {
            if (rotated.parent) |parent| {
                if (parent.left == node) {
                    parent.left = rotated;
                } else {
                    parent.right = rotated;
                }
            } else {
                self.root = rotated;
            }
        }

        fn printTree(self: *Self) void {
            __printTreeDepth(self.root, 0);
            std.debug.print("----------\n", .{});
        }

        fn __printTreeDepth(root: *RBTNode, depth: u32) void {
            if (root.is_null == 1) {
                return;
            }

            __printTreeDepth(root.right.?, depth + 1);
            for (0..depth) |_| {
                std.debug.print("    ", .{});
            }
            std.debug.print("{} ({s})\n", .{ root.value, if (root.colour == 1) "R" else "B" });
            __printTreeDepth(root.left.?, depth + 1);
        }
    };
}
