// Splay Tree

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const T = u8;
    const array = [_]T{ 15, 10, 17, 7, 13, 16, 14, 12 };

    var tree: SplayTree(T) = undefined;
    try tree.init(arena.allocator());

    for (array) |v| {
        try tree.insert(v);
    }
    tree.printTree();
    std.debug.print("----------\n", .{});
    _ = tree.search(12);
    _ = tree.search(15);
    tree.printTree();
    std.debug.print("----------\n", .{});
    try tree.delete(16);
    try tree.delete(12);
    try tree.delete(7);
    tree.printTree();
}

// Structs

pub fn SplayTree(comptime DataType: type) type {
    return struct {
        const Self = @This();

        const STNode = struct {
            value: DataType,
            left: ?*STNode,
            right: ?*STNode,
            parent: ?*STNode,

            fn init(allocator: std.mem.Allocator, value: DataType) !*STNode {
                var node = try allocator.create(STNode);
                node.value = value;
                node.left = null;
                node.right = null;
                node.parent = null;
                return node;
            }
        };

        allocator: std.mem.Allocator,
        root: ?*STNode,

        fn init(self: *Self, allocator: std.mem.Allocator) !void {
            self.allocator = allocator;
            self.root = null;
        }

        fn splay(self: *Self, node: *STNode) void {
            while (node.parent) |parent| {
                if (parent.parent) |grandparent| {
                    if (node == parent.left and parent == grandparent.left) {
                        self.rightRotate(grandparent);
                        self.rightRotate(parent);
                    } else if (node == parent.right and parent == grandparent.right) {
                        self.leftRotate(grandparent);
                        self.leftRotate(parent);
                    } else if (node == parent.left and parent == grandparent.right) {
                        self.rightRotate(parent);
                        self.leftRotate(grandparent);
                    } else {
                        self.leftRotate(parent);
                        self.rightRotate(grandparent);
                    }
                } else {
                    if (node == parent.left) {
                        self.rightRotate(parent);
                    } else {
                        self.leftRotate(parent);
                    }
                }
            }
        }

        fn search(self: *Self, val: DataType) bool {
            var temp = self.root;
            while (temp) |n| {
                if (val < n.value) {
                    temp = n.left;
                } else if (val > n.value) {
                    temp = n.right;
                } else {
                    self.splay(n);
                    return true;
                }
            }
            return false;
        }

        fn insert(self: *Self, val: DataType) !void {
            var current = self.root;
            var parent: ?*STNode = null;
            while (current) |curr| {
                parent = curr;
                if (val < curr.value) {
                    current = curr.left;
                } else {
                    current = curr.right;
                }
            }
            var node = try STNode.init(self.allocator, val);
            node.parent = parent;
            if (parent) |par| {
                if (val < par.value) {
                    par.left = node;
                } else {
                    par.right = node;
                }
            } else {
                self.root = node;
            }
            self.splay(node);
        }

        fn delete(self: *Self, val: DataType) !void {
            var temp = self.root;
            while (temp) |node| {
                if (val < node.value) {
                    temp = node.left;
                } else if (val > node.value) {
                    temp = node.right;
                } else {
                    break;
                }
            }
            var node_to_delete = temp orelse return;
            const parent = node_to_delete.parent;
            if (node_to_delete.left) |left| {
                if (node_to_delete.right) |right| {
                    const replacement = inorderSuccessor(right);
                    if (right == replacement) {
                        node_to_delete.right = replacement.right;
                    } else {
                        replacement.parent.?.left = replacement.right;
                        if (replacement.right) |r_right| {
                            r_right.parent = replacement.parent;
                        }
                    }
                    node_to_delete.value = replacement.value;
                    node_to_delete = replacement;
                } else {
                    left.parent = parent;
                    self.parentCorrection(node_to_delete, parent, left);
                }
            } else {
                if (node_to_delete.right) |right| {
                    right.parent = parent;
                    self.parentCorrection(node_to_delete, parent, right);
                } else {
                    self.parentCorrection(node_to_delete, parent, null);
                }
            }
            if (parent) |p| {
                self.splay(p);
            }
            self.allocator.destroy(node_to_delete);
        }

        fn inorderSuccessor(node: *STNode) *STNode {
            var temp = node;
            while (temp.left) |left| {
                temp = left;
            }
            return temp;
        }

        fn leftRotate(self: *Self, x: *STNode) void {
            if (x.right) |z| {
                const maybe_y = z.left;
                z.parent = x.parent;
                z.left = x;
                x.parent = z;
                x.right = maybe_y;
                if (maybe_y) |y| {
                    y.parent = x;
                }
                self.parentCorrection(x, z.parent, z);
            }
        }

        fn rightRotate(self: *Self, z: *STNode) void {
            if (z.left) |x| {
                const maybe_y = x.right;
                x.parent = z.parent;
                x.right = z;
                z.parent = x;
                z.left = maybe_y;
                if (maybe_y) |y| {
                    y.parent = z;
                }
                self.parentCorrection(z, x.parent, x);
            }
        }

        fn parentCorrection(self: *Self, old_node: ?*STNode, parent: ?*STNode, new_node: ?*STNode) void {
            if (parent) |p| {
                if (p.left == old_node) {
                    p.left = new_node;
                } else {
                    p.right = new_node;
                }
            } else {
                self.root = new_node;
            }
        }

        fn printTree(self: *Self) void {
            __printTreeDepth(self.root, 0);
            std.debug.print("----------\n", .{});
        }

        fn __printTreeDepth(root: ?*STNode, depth: u32) void {
            const node = root orelse return;

            __printTreeDepth(node.right, depth + 1);
            for (0..depth) |_| {
                std.debug.print("    ", .{});
            }
            std.debug.print("{}\n", .{node.value});
            __printTreeDepth(node.left, depth + 1);
        }
    };
}
