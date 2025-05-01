// Binary Search Tree

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const T = u8;
    const array = [_]T{ 11, 6, 8, 19, 4, 10, 5, 17, 43, 49, 31 };

    var tree: BinarySearchTree(T) = undefined;
    tree.init(arena.allocator());

    for (array) |v| {
        tree.root = try tree.insert(tree.root, v);
    }

    tree.inorderPrint(tree.root);
    std.debug.print("\n", .{});
    tree.root = try tree.delete(tree.root, 31);
    tree.root = try tree.delete(tree.root, 4);
    tree.root = try tree.delete(tree.root, 11);
    tree.inorderPrint(tree.root);
}

// Structs

pub fn BinarySearchTree(comptime DataType: type) type {
    return struct {
        const Self = @This();

        const BTNode = struct {
            value: DataType,
            left: ?*BTNode,
            right: ?*BTNode,

            fn init(allocator: std.mem.Allocator, value: DataType) !*BTNode {
                var node = try allocator.create(BTNode);
                node.value = value;
                node.left = null;
                node.right = null;
                return node;
            }
        };

        allocator: std.mem.Allocator,
        root: ?*BTNode,

        fn init(self: *Self, allocator: std.mem.Allocator) void {
            self.allocator = allocator;
            self.root = null;
        }

        fn insert(self: *Self, maybe_node: ?*BTNode, x: DataType) !*BTNode {
            if (maybe_node) |node| {
                if (node.value < x) {
                    node.right = try self.insert(node.right, x);
                } else {
                    node.left = try self.insert(node.left, x);
                }
                return node;
            } else {
                const new_node = try BTNode.init(self.allocator, x);
                return new_node;
            }
        }

        fn delete(self: *Self, maybe_node: ?*BTNode, x: DataType) !?*BTNode {
            var temp = maybe_node;
            if (maybe_node) |node| {
                if (node.value < x) {
                    temp.?.right = try self.delete(node.right, x);
                } else if (node.value > x) {
                    temp.?.left = try self.delete(node.left, x);
                } else if (node.value == x) {
                    const to_free = node;
                    if (node.left == null and node.right == null) {
                        temp = null;
                    } else if (node.left == null) {
                        temp = node.right;
                    } else if (node.right == null) {
                        temp = node.left;
                    } else {
                        const prev = inorderPredecessor(node.left);
                        const new_node = try BTNode.init(self.allocator, prev);
                        new_node.left = try self.delete(node.left, prev);
                        new_node.right = node.right;
                        temp = new_node;
                    }
                    self.allocator.destroy(to_free);
                }
                return temp;
            } else {
                return null;
            }
        }

        fn inorderPredecessor(maybe_node: ?*BTNode) DataType {
            var temp = maybe_node;
            while (temp.?.right) |node| {
                temp = node.right;
            }
            return temp.?.value;
        }

        fn inorderPrint(self: *Self, maybe_node: ?*BTNode) void {
            if (maybe_node) |node| {
                self.inorderPrint(node.left);
                std.debug.print("{} ", .{node.value});
                self.inorderPrint(node.right);
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
