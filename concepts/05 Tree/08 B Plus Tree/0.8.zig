// B Plus Tree

const std = @import("std");

// Main

pub fn main() !void {
    // var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    // defer arena.deinit();
    // const allocator = arena.allocator();

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer {
        _ = gpa.deinit();
    }
    const allocator = gpa.allocator();

    const KeyType = u64;
    const DataType = []const u8;
    const m: usize = 5;

    const keys = [_]KeyType{ 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20 };
    var data = [_]DataType{ "This", "is", "sample", "text", "to", "check", "if", "B", "plus", "tree", "works", "as", "expected." };

    var tree: BPlusTree(m, KeyType, DataType, std.math.order) = undefined;
    try tree.init(allocator);
    defer tree.deinit();

    for (&data, 0..) |*v, i| {
        try tree.insert(keys[i], v);
    }
    tree.print();
    std.debug.print("{s}\n", .{tree.search(keys[3]).?.*});
    std.debug.print("{s}\n", .{tree.search(keys[10]).?.*});
    std.debug.print("{any}\n", .{tree.search(keys[17])});
    std.debug.print("{s}\n", .{tree.search(keys[8]).?.*});
    tree.delete(keys[3]);
    tree.delete(keys[9]);
    tree.delete(keys[12]);
    tree.print();
}

// Enums, Structs, Unions

pub fn BPlusTree(m: usize, comptime KeyType: type, comptime DataType: type, compare: fn (anytype, anytype) std.math.Order) type {
    // TODO: Fix type for compare func.
    return struct {
        const InternalNode = struct {
            len: usize,
            parent: ?*InternalNode,
            keys: [m - 1]KeyType,
            children: [m]Node,

            fn init(allocator: std.mem.Allocator) !*InternalNode {
                var node = try allocator.create(InternalNode);
                node.len = 0;
                node.parent = null;
                return node;
            }
        };

        const LeafNode = struct {
            len: usize,
            parent: ?*InternalNode,
            keys: [m - 1]KeyType,
            data: [m - 1]*DataType,
            next: ?*LeafNode,

            fn init(allocator: std.mem.Allocator) !*LeafNode {
                const node = try allocator.create(LeafNode);
                node.len = 0;
                node.parent = null;
                node.next = null;
                return node;
            }
        };

        const Node = union(enum) {
            Internal: *InternalNode,
            Leaf: *LeafNode,

            /// Returns new node of same type as self.
            fn createNewNode(self: Node, allocator: std.mem.Allocator) !Node {
                switch (self) {
                    .Internal => {
                        const node = try InternalNode.init(allocator);
                        return Node{ .Internal = node };
                    },
                    .Leaf => {
                        const node = try LeafNode.init(allocator);
                        return Node{ .Leaf = node };
                    },
                }
            }

            fn freeNode(self: Node, allocator: std.mem.Allocator) void {
                switch (self) {
                    .Internal => |n| allocator.destroy(n),
                    .Leaf => |n| allocator.destroy(n),
                }
            }

            fn getLen(self: Node) usize {
                return switch (self) {
                    .Internal => |n| n.len,
                    .Leaf => |n| n.len,
                };
            }
            fn setLen(self: Node, len: usize) void {
                switch (self) {
                    .Internal => |n| n.len = len,
                    .Leaf => |n| n.len = len,
                }
            }

            fn getParent(self: Node) ?*InternalNode {
                return switch (self) {
                    .Internal => |n| n.parent,
                    .Leaf => |n| n.parent,
                };
            }
            fn setParent(self: Node, parent: ?*InternalNode) void {
                switch (self) {
                    .Internal => |n| n.parent = parent,
                    .Leaf => |n| n.parent = parent,
                }
            }

            fn getKeys(self: Node) []KeyType {
                return switch (self) {
                    .Internal => |n| n.keys[0..n.len],
                    .Leaf => |n| n.keys[0..n.len],
                };
            }
            fn setKeys(self: Node, keys: []KeyType) void {
                switch (self) {
                    .Internal => |n| n.keys = keys,
                    .Leaf => |n| n.keys = keys,
                }
            }

            fn getChildren(self: Node) ?[]Node {
                return switch (self) {
                    .Internal => |n| n.children[0..(n.len + 1)],
                    .Leaf => null,
                };
            }
            fn setChildren(self: Node, children: []Node) void {
                switch (self) {
                    .Internal => |n| n.children = children,
                    .Leaf => unreachable,
                }
            }

            fn getData(self: Node) ?[]*DataType {
                return switch (self) {
                    .Internal => null,
                    .Leaf => |n| n.data[0..n.len],
                };
            }
            fn setData(self: Node, data: []*DataType) void {
                switch (self) {
                    .Internal => unreachable,
                    .Leaf => |n| n.data = data,
                }
            }

            fn getNext(self: Node) ?*LeafNode {
                return switch (self) {
                    .Internal => null,
                    .Leaf => |n| n.next,
                };
            }
            fn setNext(self: Node, next: ?*LeafNode) void {
                return switch (self) {
                    .Internal => unreachable,
                    .Leaf => |n| n.next = next,
                };
            }
        };

        const Self = @This();
        const mid = m / 2;
        const min_keys = ceilDivide(m, 2) - 1;

        allocator: std.mem.Allocator,
        root: Node,

        fn init(self: *Self, allocator: std.mem.Allocator) !void {
            self.allocator = allocator;
            const leaf = try LeafNode.init(allocator);
            self.root = .{ .Leaf = leaf };
        }

        fn deinit(self: *Self) void {
            self.deleteNodeAndSubNode(self.root);
        }

        fn binarySearch(list: []KeyType, len: usize, key: KeyType) usize {
            var low: usize = 0;
            var high: usize = len;
            while (low < high) {
                const md = low + ((high - low) >> 1);
                switch (compare(list[md], key)) {
                    .lt => low = md + 1,
                    else => high = md,
                }
            }
            return low;
        }

        fn search(self: *Self, key: KeyType) ?*DataType {
            var node = self.root;
            while (true) {
                switch (node) {
                    .Internal => |n| {
                        const i = binarySearch(&n.keys, n.len, key);
                        if (i < n.len and compare(n.keys[i], key) == .eq) {
                            node = n.children[i + 1];
                        } else {
                            node = n.children[i];
                        }
                    },
                    .Leaf => |n| {
                        if (n.len > 0) {
                            const i = binarySearch(&n.keys, n.len, key);
                            if (i < n.len and compare(n.keys[i], key) == .eq) {
                                return n.data[i];
                            }
                        }
                        return null;
                    },
                }
            }
        }

        fn successorKey(node: Node) KeyType {
            var temp = node;
            while (true) {
                switch (temp) {
                    .Internal => |n| temp = n.children[0],
                    .Leaf => |n| return n.keys[0],
                }
            }
        }

        fn insert(self: *Self, key: KeyType, data: *DataType) !void {
            var current = self.root;
            var i: usize = 0;
            while (true) {
                switch (current) {
                    .Internal => |n| {
                        i = binarySearch(&n.keys, n.len, key);
                        current = n.children[i];
                    },
                    .Leaf => |n| {
                        if (n.len > 0) {
                            i = binarySearch(&n.keys, n.len, key);
                            var extra_key = n.keys[n.len - 1];
                            var extra_data = n.data[n.len - 1];
                            if (i == n.len) {
                                extra_key = key;
                                extra_data = data;
                            }
                            var j: usize = 1;
                            while (j < (n.len - i)) : (j += 1) {
                                n.keys[n.len - j] = n.keys[n.len - j - 1];
                                n.data[n.len - j] = n.data[n.len - j - 1];
                            }
                            if (i < n.len) {
                                n.keys[i] = key;
                                n.data[i] = data;
                            }
                            if (n.len < (m - 1)) {
                                n.keys[n.len] = extra_key;
                                n.data[n.len] = extra_data;
                                n.len += 1;
                            } else {
                                try self.splitNode(current, extra_key, extra_data);
                            }
                        } else {
                            n.keys[0] = key;
                            n.data[0] = data;
                            n.len += 1;
                        }
                        break;
                    },
                }
            }
        }

        fn splitNode(self: *Self, child: Node, extra_key: KeyType, extra_data: *DataType) !void {
            var node = child;
            var e_k = extra_key;
            var extra_child: Node = undefined;
            while (true) {
                const new_node = try node.createNewNode(self.allocator);
                new_node.setParent(node.getParent());
                switch (node) {
                    .Internal => |n| {
                        const nn = new_node.Internal;
                        for ((mid + 1)..n.len) |i| {
                            nn.keys[i - mid - 1] = n.keys[i];
                            nn.children[i - mid - 1] = n.children[i];
                            nn.children[i - mid - 1].setParent(nn);
                            nn.len += 1;
                        }
                        nn.keys[nn.len] = e_k;
                        nn.children[nn.len] = n.children[n.len];
                        nn.children[nn.len].setParent(nn);
                        nn.len += 1;
                        nn.children[nn.len] = extra_child;
                        extra_child.setParent(nn);
                        n.len = mid;
                    },
                    .Leaf => |n| {
                        const nn = new_node.Leaf;
                        for (mid..n.len) |i| {
                            nn.keys[i - mid] = n.keys[i];
                            nn.data[i - mid] = n.data[i];
                            nn.len += 1;
                        }
                        nn.keys[nn.len] = extra_key;
                        nn.data[nn.len] = extra_data;
                        nn.len += 1;
                        n.len = mid;
                        nn.next = n.next;
                        n.next = nn;
                    },
                }
                const new_key = successorKey(new_node);
                if (node.getParent()) |parent| {
                    const i = binarySearch(&parent.keys, parent.len, new_key);
                    if (i == parent.len) {
                        e_k = new_key;
                        extra_child = new_node;
                    } else {
                        e_k = parent.keys[parent.len - 1];
                        extra_child = parent.children[parent.len];
                    }
                    var j: usize = 1;
                    while (j < (parent.len - i)) : (j += 1) {
                        parent.keys[parent.len - j] = parent.keys[parent.len - j - 1];
                        parent.children[parent.len + 1 - j] =
                            parent.children[parent.len - j];
                    }
                    if (i < parent.len) {
                        parent.keys[i] = new_key;
                        parent.children[i + 1] = new_node;
                    }
                    if (parent.len < (m - 1)) {
                        parent.keys[parent.len] = e_k;
                        parent.len += 1;
                        parent.children[parent.len] = extra_child;
                        break;
                    }
                    node = .{ .Internal = parent };
                } else {
                    const p = try InternalNode.init(self.allocator);
                    p.keys[0] = new_key;
                    p.len = 1;
                    p.children[0] = node;
                    p.children[1] = new_node;
                    node.setParent(p);
                    new_node.setParent(p);
                    self.root = .{ .Internal = p };
                    break;
                }
            }
        }

        fn delete(self: *Self, key: KeyType) void {
            var current = self.root;
            var i: usize = undefined;
            while (true) {
                switch (current) {
                    .Internal => |n| {
                        i = binarySearch(&n.keys, n.len, key);
                        if (i < n.len and compare(n.keys[i], key) == .eq) {
                            current = n.children[i + 1];
                        } else {
                            current = n.children[i];
                        }
                    },
                    .Leaf => |n| {
                        if (n.len > 0) {
                            i = binarySearch(&n.keys, n.len, key);
                            if (i < n.len and compare(n.keys[i], key) == .eq) {
                                var j: usize = 0;
                                while (j < n.len - i - 1) : (j += 1) {
                                    n.keys[i + j] = n.keys[i + j + 1];
                                    n.data[i + j] = n.data[i + j + 1];
                                }
                                n.len -= 1;
                                break;
                            }
                        }
                        return;
                    },
                }
            }
            while (current.getParent()) |parent| : (current = .{ .Internal = parent }) {
                if (current.getLen() < min_keys) {
                    i = binarySearch(&parent.keys, parent.len, key);
                    if (i < parent.len and compare(parent.keys[i], key) == .eq) {
                        i += 1;
                    }
                    const sibling1: ?Node = if (i == 0) null else parent.children[i - 1];
                    const sibling2: ?Node = if (i == parent.len) null else parent.children[i + 1];
                    if (sibling1 != null and sibling1.?.getLen() > min_keys) {
                        borrowLeft(parent, i);
                    } else if (sibling2 != null and sibling2.?.getLen() > min_keys) {
                        borrowRight(parent, i);
                    } else if (sibling1 != null) {
                        self.mergeChildren(parent, i - 1);
                    } else {
                        self.mergeChildren(parent, i);
                    }
                    if (parent.len == 0 and parent.parent == null) {
                        self.allocator.destroy(parent);
                        break;
                    }
                }
            }
            fixRoutes(self.root);
        }

        fn mergeChildren(self: *Self, node: *InternalNode, index: usize) void {
            const child = node.children[index];
            const node_to_free = node.children[1 + index];
            switch (child) {
                .Internal => |n| {
                    const nf = node_to_free.Internal;
                    n.keys[n.len] = successorKey(nf.children[0]);
                    n.len += 1;
                    n.children[n.len] = nf.children[0];
                    nf.children[0].setParent(n);
                    for (0..nf.len) |i| {
                        n.keys[n.len] = nf.keys[i];
                        n.len += 1;
                        n.children[n.len] = nf.children[i + 1];
                        nf.children[i + 1].setParent(n);
                    }
                },
                .Leaf => |n| {
                    const nf = node_to_free.Leaf;
                    for (0..nf.len) |i| {
                        n.keys[n.len] = nf.keys[i];
                        n.data[n.len] = nf.data[i];
                        n.len += 1;
                    }
                    n.next = nf.next;
                },
            }
            node.len -= 1;
            for (index..node.len) |i| {
                node.keys[i] = node.keys[i + 1];
                node.children[i + 1] = node.children[i + 2];
            }
            if (node.len == 0 and node.parent == null) {
                self.root = child;
                child.setParent(null);
            }
            node_to_free.freeNode(self.allocator);
        }

        fn borrowLeft(parent: *InternalNode, index: usize) void {
            const child = parent.children[index];
            const left_child = parent.children[index - 1];
            switch (child) {
                .Internal => |n| {
                    const lc = left_child.Internal;
                    n.children[n.len + 1] = n.children[n.len];
                    for (0..n.len) |i| {
                        n.keys[n.len - i] = n.keys[n.len - 1 - i];
                        n.children[n.len - i] = n.children[n.len - 1 - i];
                    }
                    n.keys[0] = successorKey(n.children[1]);
                    n.children[0] = lc.children[lc.len];
                    n.len += 1;
                    lc.len -= 1;
                },
                .Leaf => |n| {
                    const lc = left_child.Leaf;
                    for (0..n.len) |i| {
                        n.keys[n.len - i] = n.keys[n.len - 1 - i];
                        n.data[n.len - i] = n.data[n.len - 1 - i];
                    }
                    n.keys[0] = lc.keys[lc.len - 1];
                    n.data[0] = lc.data[lc.len - 1];
                    n.len += 1;
                    lc.len -= 1;
                },
            }
        }

        fn borrowRight(parent: *InternalNode, index: usize) void {
            const child = parent.children[index];
            const right_child = parent.children[index + 1];
            switch (child) {
                .Internal => |n| {
                    const rc = right_child.Internal;
                    n.keys[n.len] = successorKey(rc.children[0]);
                    n.len += 1;
                    n.children[n.len] = rc.children[0];
                    rc.len -= 1;
                    for (0..rc.len) |i| {
                        rc.keys[i] = rc.keys[i + 1];
                        rc.children[i] = rc.children[i + 1];
                    }
                    rc.children[rc.len] = rc.children[rc.len + 1];
                },
                .Leaf => |n| {
                    const rc = right_child.Leaf;
                    n.keys[n.len] = rc.keys[0];
                    n.data[n.len] = rc.data[0];
                    n.len += 1;
                    rc.len -= 1;
                    for (0..rc.len) |i| {
                        rc.keys[i] = rc.keys[i + 1];
                        rc.data[i] = rc.data[i + 1];
                    }
                },
            }
        }

        fn fixRoutes(node: Node) void {
            switch (node) {
                .Internal => |n| {
                    for (0..n.len) |i| {
                        n.keys[i] = successorKey(n.children[i + 1]);
                    }
                },
                .Leaf => {},
            }
        }

        fn print(self: *Self) void {
            __printDepth(self.root, 0);
            std.debug.print("----------\n", .{});
        }

        fn __printDepth(node: Node, depth: usize) void {
            if (node.getLen() == 0) {
                return;
            }
            const keys = node.getKeys();
            for (0..depth) |_| {
                std.debug.print("    ", .{});
            }
            std.debug.print("Keys: ", .{});
            for (keys) |key| {
                std.debug.print("{} ", .{key});
            }
            std.debug.print("\n", .{});
            switch (node) {
                .Internal => |n| {
                    for (0..(n.len + 1)) |i| {
                        __printDepth(n.children[i], depth + 1);
                    }
                },
                else => {},
            }
        }

        fn deleteNodeAndSubNode(self: *Self, node: Node) void {
            switch (node) {
                .Internal => |n| {
                    for (0..(n.len + 1)) |i| {
                        self.deleteNodeAndSubNode(n.children[i]);
                    }
                    self.allocator.destroy(n);
                },
                .Leaf => |n| {
                    self.allocator.destroy(n);
                },
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
