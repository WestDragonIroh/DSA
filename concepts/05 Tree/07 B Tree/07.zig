// B_Tree

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const T = u64;
    const m: usize = 3;
    // const array = [_]T{ 15, 10, 17, 7, 13, 16, 14, 12 };

    var tree: B_Tree(T, m) = undefined;
    try tree.init(arena.allocator());
    for (0..20) |i| {
        try tree.insert(@as(T, i + 1));
        // tree.printTree();
    }
    tree.printTree();
    tree.delete(3);
    tree.delete(16);
    tree.delete(12);
    tree.printTree();
}

// Structs

pub fn B_Tree(comptime DataType: type, m: usize) type {
    return struct {
        const Self = @This();

        const B_TNode = struct {
            num_keys: usize,
            is_leaf: u1,
            parent: ?*B_TNode,
            keys: []DataType,
            children: []?*B_TNode,

            fn init(allocator: std.mem.Allocator, is_leaf: u1) !*B_TNode {
                var node = try allocator.create(B_TNode);
                node.num_keys = 0;
                node.is_leaf = is_leaf;
                node.parent = null;
                node.keys = try allocator.alloc(DataType, m - 1);
                node.children = try allocator.alloc(?*B_TNode, m);
                for (0..m) |i| {
                    node.children[i] = null;
                }
                return node;
            }
        };

        const mid = m / 2;
        const min_keys = ceilDivide(m, 2) - 1;

        allocator: std.mem.Allocator,
        root: *B_TNode,

        fn init(self: *Self, allocator: std.mem.Allocator) !void {
            self.allocator = allocator;
            self.root = try B_TNode.init(allocator, 1);
        }

        fn search(self: *Self, val: DataType) !u1 {
            var node = self.root;
            while (node) |n| {
                var i: usize = 0;
                while (i < n.num_keys and val > n.keys[i]) {
                    i += 1;
                }
                if (i < n.num_keys and val == n.keys[i]) {
                    return 1;
                }
                if (n.is_leaf) {
                    return 0;
                }
                node = n.children[i];
            }
            return 0;
        }

        fn insert(self: *Self, val: DataType) !void {
            var current = self.root;
            var i: usize = 0;
            while (true) {
                i = 0;
                while (i < current.num_keys) : (i += 1) {
                    if (val < current.keys[i]) {
                        break;
                    }
                }
                if (current.is_leaf == 1) {
                    break;
                } else {
                    current = current.children[i] orelse unreachable;
                }
            }
            if (current.num_keys > 0) {
                var extra_key = current.keys[current.num_keys - 1];
                if (i == current.num_keys) {
                    extra_key = val;
                }
                var j: usize = 1;
                while (j < (current.num_keys - i)) : (j += 1) {
                    current.keys[current.num_keys - j] =
                        current.keys[current.num_keys - j - 1];
                }
                if (i < current.num_keys) {
                    current.keys[i] = val;
                }
                if (current.num_keys < (m - 1)) {
                    current.keys[current.num_keys] = extra_key;
                    current.num_keys += 1;
                } else {
                    try self.splitNode(current, extra_key);
                }
            } else {
                current.keys[0] = val;
                current.num_keys += 1;
            }
        }

        fn splitNode(self: *Self, child: *B_TNode, extra_val: DataType) !void {
            var node = child;
            var extra_key = extra_val;
            var extra_child: ?*B_TNode = self.root;
            while (extra_child) |e_c| {
                if (node.parent == null) {
                    const p = try B_TNode.init(self.allocator, 0);
                    p.children[0] = node;
                    self.root.parent = p;
                    self.root = p;
                }
                var parent = node.parent orelse unreachable;
                const new_node = try B_TNode.init(self.allocator, node.is_leaf);
                new_node.parent = parent;
                for (0..(node.num_keys - mid - 1)) |i| {
                    new_node.keys[i] = node.keys[mid + 1 + i];
                    new_node.num_keys += 1;
                }
                new_node.keys[new_node.num_keys] = extra_key;
                new_node.num_keys += 1;
                if (new_node.is_leaf == 0) {
                    for (0..(node.num_keys - mid)) |i| {
                        new_node.children[i] = node.children[mid + 1 + i];
                        new_node.children[i].?.parent = new_node;
                    }
                    new_node.children[new_node.num_keys] = e_c;
                    e_c.parent = new_node;
                }
                const new_val = node.keys[mid];
                node.num_keys = mid;
                var i: usize = 0;
                while (i < parent.num_keys) : (i += 1) {
                    if (new_val < parent.keys[i]) {
                        break;
                    }
                }
                if (parent.num_keys > 0) {
                    if (i == parent.num_keys) {
                        extra_key = new_val;
                        extra_child = new_node;
                    } else {
                        extra_key = parent.keys[parent.num_keys - 1];
                        extra_child = parent.children[parent.num_keys];
                    }
                    var j: usize = 1;
                    while (j < (parent.num_keys - i)) : (j += 1) {
                        parent.keys[parent.num_keys - j] =
                            parent.keys[parent.num_keys - j - 1];
                        parent.children[parent.num_keys + 1 - j] =
                            parent.children[parent.num_keys - j];
                    }
                    if (i < parent.num_keys) {
                        parent.keys[i] = new_val;
                        parent.children[i + 1] = new_node;
                    }
                    if (parent.num_keys < (m - 1)) {
                        parent.keys[parent.num_keys] = extra_key;
                        parent.num_keys += 1;
                        parent.children[parent.num_keys] = extra_child;
                        extra_child = null;
                    }
                } else {
                    parent.keys[0] = new_val;
                    parent.num_keys += 1;
                    parent.children[1] = new_node;
                    extra_child = null;
                }
                node = parent;
            }
        }

        fn delete(self: *Self, val: DataType) void {
            var current = self.root;
            var i: usize = 0;
            while (true) {
                i = 0;
                while (i < current.num_keys) : (i += 1) {
                    if (val <= current.keys[i]) {
                        break;
                    }
                }
                if (i < current.num_keys and val == current.keys[i]) {
                    break;
                }
                if (current.is_leaf == 1) {
                    return;
                } else {
                    current = current.children[i] orelse unreachable;
                }
            }
            if (current.is_leaf == 1) {
                for (0..(current.num_keys - i)) |j| {
                    current.keys[i + j] = current.keys[i + j + 1];
                }
                current.num_keys -= 1;
            } else {
                const predecessor = predecessorNode(current.children[i].?);
                const successor = successorNode(current.children[i + 1].?);
                if (predecessor.num_keys > min_keys) {
                    current.keys[i] = predecessor.keys[predecessor.num_keys - 1];
                    predecessor.num_keys -= 1;
                } else {
                    current.keys[i] = successor.keys[0];
                    for (0..(successor.num_keys - 1)) |j| {
                        successor.keys[j] = successor.keys[j + 1];
                    }
                    successor.num_keys -= 1;
                    if (successor.num_keys < min_keys) {
                        current = successor;
                    }
                }
            }
            while (current.parent) |parent| : (current = parent) {
                if (current.num_keys < min_keys) {
                    i = 0;
                    while (i <= parent.num_keys) : (i += 1) {
                        if (parent.children[i] == current) {
                            break;
                        }
                    }
                    const sibling1: ?*B_TNode = if (i == 0) null else parent.children[i - 1];
                    const sibling2: ?*B_TNode = if (i == parent.num_keys) null else parent.children[i + 1];
                    if (sibling1 != null and sibling1.?.num_keys > min_keys) {
                        borrowLeft(parent, i);
                    } else if (sibling2 != null and sibling2.?.num_keys > min_keys) {
                        borrowRight(parent, i);
                    } else if (sibling1 != null) {
                        self.mergeChildren(parent, i - 1);
                    } else {
                        self.mergeChildren(parent, i);
                    }
                } else {
                    break;
                }
            }
        }

        fn mergeChildren(self: *Self, node: *B_TNode, index: usize) void {
            const child = node.children[index] orelse unreachable;
            const node_to_free = node.children[1 + index] orelse unreachable;
            child.keys[child.num_keys] = node.keys[index];
            child.num_keys += 1;
            for (0..node_to_free.num_keys) |i| {
                if (child.is_leaf == 0) {
                    child.children[child.num_keys] = node_to_free.children[i];
                }
                child.keys[child.num_keys] = node_to_free.keys[i];
                child.num_keys += 1;
            }
            if (child.is_leaf == 0) {
                child.children[child.num_keys] =
                    node_to_free.children[node_to_free.num_keys];
            }
            for (index..node.num_keys) |i| {
                node.keys[i] = node.keys[i + 1];
                node.children[i + 1] = node.children[i + 2];
            }
            node.num_keys -= 1;
            if (node.num_keys == 0 and node.parent == null) {
                self.root = child;
            }
            self.allocator.destroy(node_to_free);
        }

        fn predecessorNode(node: *B_TNode) *B_TNode {
            var temp = node;
            while (temp.children[temp.num_keys]) |c| : (temp = c) {}
            return temp;
        }

        fn successorNode(node: *B_TNode) *B_TNode {
            var temp = node;
            while (temp.children[0]) |c| : (temp = c) {}
            return temp;
        }

        fn borrowLeft(parent: *B_TNode, index: usize) void {
            const child = parent.children[index] orelse unreachable;
            const left_child = parent.children[index - 1] orelse unreachable;
            for (0..child.num_keys) |i| {
                child.keys[child.num_keys - i] = child.keys[child.num_keys - 1 - i];
                if (child.is_leaf == 0) {
                    child.children[child.num_keys + 1 - i] =
                        child.children[child.num_keys - i];
                }
            }
            if (child.is_leaf == 0) {
                child.children[1] = child.children[0];
                child.children[0] = left_child.children[left_child.num_keys];
                left_child.children[left_child.num_keys] = null;
            }
            child.keys[0] = parent.keys[index - 1];
            child.num_keys += 1;
            parent.keys[index - 1] = left_child.keys[left_child.num_keys - 1];
            left_child.num_keys -= 1;
        }

        fn borrowRight(parent: *B_TNode, index: usize) void {
            const child = parent.children[index] orelse unreachable;
            const right_child = parent.children[index + 1] orelse unreachable;
            child.keys[child.num_keys] = parent.keys[index];
            child.num_keys += 1;
            parent.keys[index] = right_child.keys[0];
            if (child.is_leaf == 0) {
                child.children[child.num_keys] = right_child.children[0];
            }
            for (0..(right_child.num_keys - 1)) |i| {
                right_child.keys[i] = right_child.keys[i + 1];
                if (right_child.is_leaf == 0) {
                    right_child.children[i] = right_child.children[i + 1];
                }
            }
            if (right_child.is_leaf == 0) {
                right_child.children[right_child.num_keys - 1] =
                    right_child.children[right_child.num_keys];
                right_child.children[right_child.num_keys] = null;
            }
            right_child.num_keys -= 1;
        }

        fn printTree(self: *Self) void {
            __printTreeDepth(self.root, 0);
            std.debug.print("----------\n", .{});
        }

        fn __printTreeDepth(node: ?*B_TNode, depth: usize) void {
            const n = node orelse return;

            for (0..depth) |_| {
                std.debug.print("    ", .{});
            }
            std.debug.print("Keys: ", .{});
            for (0..n.num_keys) |i| {
                std.debug.print("{} ", .{n.keys[i]});
            }
            std.debug.print("\n", .{});
            if (n.is_leaf == 0) {
                for (0..(n.num_keys + 1)) |i| {
                    __printTreeDepth(n.children[i], depth + 1);
                }
            }
        }
    };
}

// Functions

pub fn ceilDivide(a: i64, b: i64) i64 {
    var c = a / b;
    if (a != (b * c) and c > 0) {
        c += 1;
    }
    return c;
}
