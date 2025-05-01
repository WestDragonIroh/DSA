// Binary Tree

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const T = u8;
    var tree: BinaryTree(T) = undefined;
    try tree.init(arena.allocator());
}

// Structs

pub fn BinaryTree(comptime DataType: type) type {
    return struct {
        const Self = @This();

        const BTNode = struct {
            value: DataType,
            left: ?*BTNode = null,
            right: ?*BTNode = null,

            fn init(allocator: std.mem.Allocator, value: DataType) !*BTNode {
                var node = try allocator.create(BTNode);
                node.value = value;
                return node;
            }
        };

        allocator: std.mem.Allocator,
        root: ?*BTNode,

        fn init(self: *Self, allocator: std.mem.Allocator) !void {
            self.allocator = allocator;
            self.root = try self.create();
        }

        fn create(self: *Self) !?*BTNode {
            std.debug.print("Enter data for Node(0 for no node): ", .{});
            const x = try getIntInput(DataType);
            if (x == 0) {
                return null;
            } else {
                var node = try BTNode.init(self.allocator, x);
                std.debug.print("Enter left child of {}\n", .{x});
                node.left = try self.create();
                std.debug.print("Enter right child of {}\n", .{x});
                node.right = try self.create();
                return node;
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
