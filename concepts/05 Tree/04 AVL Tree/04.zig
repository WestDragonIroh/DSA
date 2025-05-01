// AVL Tree

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const T = u8;
    const array = [_]T{ 14, 17, 11, 7, 53, 4, 13, 12, 8, 60, 19, 16, 20 };

    var tree: AVLTree(T) = undefined;
    tree.init(arena.allocator());

    for (array) |v| {
        tree.root = try tree.insert(tree.root, v);
    }

    tree.inorderPrint(tree.root);
    std.debug.print("\n", .{});
    tree.preorderPrint(tree.root);
    std.debug.print("\n", .{});
    tree.root = try tree.delete(tree.root, 8);
    tree.root = try tree.delete(tree.root, 7);
    tree.root = try tree.delete(tree.root, 11);
    tree.root = try tree.delete(tree.root, 14);
    tree.root = try tree.delete(tree.root, 17);
    tree.inorderPrint(tree.root);
    std.debug.print("\n", .{});
    tree.preorderPrint(tree.root);
    std.debug.print("\n", .{});
}

// Structs

pub fn AVLTree(comptime DataType: type) type {
    return struct {
        const Self = @This();

        const AVLTNode = struct {
            value: DataType,
            left: ?*AVLTNode,
            right: ?*AVLTNode,
            height: i64,

            fn init(allocator: std.mem.Allocator, value: DataType) !*AVLTNode {
                var node = try allocator.create(AVLTNode);
                node.value = value;
                node.left = null;
                node.right = null;
                node.height = 0;
                return node;
            }
        };

        allocator: std.mem.Allocator,
        root: ?*AVLTNode,

        fn init(self: *Self, allocator: std.mem.Allocator) void {
            self.allocator = allocator;
            self.root = null;
        }

        fn insert(self: *Self, maybe_node: ?*AVLTNode, val: DataType) !?*AVLTNode {
            if (maybe_node) |node| {
                if (node.value < val) {
                    node.right = try self.insert(node.right, val);
                } else {
                    node.left = try self.insert(node.left, val);
                }
                node.height = 1 + @max(height(node.left), height(node.right));
                return balanceNode(node);
            } else {
                return try AVLTNode.init(self.allocator, val);
            }
        }

        fn delete(self: *Self, maybe_node: ?*AVLTNode, val: DataType) !?*AVLTNode {
            var node = maybe_node orelse return null;

            switch (std.math.order(node.value, val)) {
                .lt => node.right = try self.delete(node.right, val),
                .gt => node.left = try self.delete(node.left, val),
                .eq => {
                    const to_free = node;
                    defer self.allocator.destroy(to_free);

                    if (node.left) |left| {
                        if (node.right) |right| {
                            const prev = inorderPredecessor(left);
                            const new_node = try AVLTNode.init(self.allocator, prev);
                            new_node.left = try self.delete(node.left, prev);
                            new_node.right = right;
                            node = new_node;
                        } else {
                            node = left;
                        }
                    } else {
                        if (node.right) |right| {
                            node = right;
                        } else {
                            return null;
                        }
                    }
                },
            }
            node.height = 1 + @max(height(node.left), height(node.right));
            return balanceNode(node);
        }

        fn inorderPredecessor(node: *AVLTNode) DataType {
            var temp: *AVLTNode = node;
            while (temp.right) |right| {
                temp = right;
            }
            return temp.value;
        }

        fn balanceNode(maybe_node: ?*AVLTNode) ?*AVLTNode {
            var res_node = maybe_node;
            if (maybe_node) |node| {
                const balance = getBalance(node);
                if (balance > 1 and getBalance(node.left) >= 0) {
                    res_node = rightRotate(node);
                } else if (balance > 1 and getBalance(node.left) < 0) {
                    node.left = leftRotate(node.left);
                    res_node = rightRotate(node);
                } else if (balance < -1 and getBalance(node.right) <= 0) {
                    res_node = leftRotate(node);
                } else if (balance < -1 and getBalance(node.right) > 0) {
                    node.right = rightRotate(node.right);
                    res_node = leftRotate(node);
                }
            }
            return res_node;
        }

        fn getBalance(maybe_node: ?*AVLTNode) i64 {
            if (maybe_node) |node| {
                return height(node.left) - height(node.right);
            } else {
                return 0;
            }
        }
        fn height(maybe_node: ?*AVLTNode) i64 {
            if (maybe_node) |node| {
                return node.height;
            } else {
                return 0;
            }
        }

        fn leftRotate(maybe_node: ?*AVLTNode) ?*AVLTNode {
            if (maybe_node) |x| {
                if (x.right) |z| {
                    const y = z.left;
                    z.left = x;
                    x.right = y;
                    x.height = 1 + @max(height(x.left), height(x.right));
                    z.height = 1 + @max(height(z.left), height(z.right));
                    return z;
                }
            }
            return maybe_node;
        }

        fn rightRotate(maybe_node: ?*AVLTNode) ?*AVLTNode {
            if (maybe_node) |z| {
                if (z.left) |x| {
                    const y = x.right;
                    x.right = z;
                    z.left = y;
                    z.height = 1 + @max(height(z.left), height(z.right));
                    x.height = 1 + @max(height(x.left), height(x.right));
                    return x;
                }
            }
            return maybe_node;
        }

        fn preorderPrint(self: *Self, maybe_node: ?*AVLTNode) void {
            if (maybe_node) |node| {
                std.debug.print("{} ", .{node.value});
                self.preorderPrint(node.left);
                self.preorderPrint(node.right);
            }
        }

        fn inorderPrint(self: *Self, maybe_node: ?*AVLTNode) void {
            if (maybe_node) |node| {
                self.inorderPrint(node.left);
                std.debug.print("{} ", .{node.value});
                self.inorderPrint(node.right);
            }
        }

        fn postorderPrint(self: *Self, maybe_node: ?*AVLTNode) void {
            if (maybe_node) |node| {
                self.postorderPrint(node.left);
                self.postorderPrint(node.right);
                std.debug.print("{} ", .{node.value});
            }
        }
    };
}

// User Inputs

pub fn getUserInput(buffer: []u8) ![]const u8 {
    const stdin = std.io.getStdIn().reader();
    const input = try stdin.readUntilDelimiter(buffer, '\n');
    return std.mem.trim(u8, input, "\n\r");
}

pub fn getIntInput(comptime T: type) !T {
    var buffer: [256]u8 = undefined;
    while (true) {
        const input = try getUserInput(&buffer);
        if (input.len == 0) {
            continue;
        }
        const parsed_value = std.fmt.parseInt(T, input, 10) catch |err| {
            std.debug.print("{any} {any}\n", .{ T, err });
            std.debug.print("Invalid input. Please enter a valid integer.\n", .{});
            continue;
        };
        return parsed_value;
    }
}
