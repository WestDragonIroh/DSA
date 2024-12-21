// Reverse SLL

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var a = [_]u8{ 1, 2, 3, 4, 5 };
    var sll: SLL(u8) = undefined;
    try sll.init(arena.allocator(), &a);
    sll.print();
    try sll.insert(10, 3);
    sll.print();
    sll.delete(3);
    sll.print();
    sll.reverse();
    sll.print();
}

// Structs

pub fn SLL(comptime DataType: type) type {
    return struct {
        const Self = @This();

        const SLLNode = struct {
            value: DataType,
            next: ?*SLLNode = null,

            fn init(allocator: std.mem.Allocator, value: DataType, next: ?*SLLNode) !*SLLNode {
                var node = try allocator.create(SLLNode);
                node.value = value;
                node.next = next;
                return node;
            }
        };

        allocator: std.mem.Allocator,
        head: ?*SLLNode,
        len: usize,

        fn init(self: *Self, allocator: std.mem.Allocator, arr: []DataType) !void {
            self.allocator = allocator;
            self.head = null;
            self.len = 0;
            for (arr) |value| {
                try self.insert(value, self.len);
            }
        }

        fn insert(self: *Self, value: DataType, index: usize) !void {
            if (index > self.len) {
                std.debug.print("Index out of bound\n", .{});
                return;
            }
            const new_node = try SLLNode.init(self.allocator, value, null);
            if (self.len == 0) {
                self.head = new_node;
            } else if (index == 0) {
                new_node.next = self.head;
                self.head = new_node;
            } else {
                var temp = self.head;
                for (0..(index - 1)) |_| {
                    temp = temp.?.next;
                }
                new_node.next = temp.?.next;
                temp.?.next = new_node;
            }
            self.len += 1;
        }

        fn delete(self: *Self, index: usize) void {
            if (index < 0 or index >= self.len) {
                std.debug.print("Index out of bound\n", .{});
                return;
            }
            var temp = self.head;
            if (index == 0) {
                self.head = self.head.?.next;
                self.allocator.destroy(temp.?);
            } else {
                for (0..(index - 1)) |_| {
                    temp = temp.?.next;
                }
                const next_node = temp.?.next;
                temp.?.next = temp.?.next.?.next;
                self.allocator.destroy(next_node.?);
            }
            self.len -= 1;
        }

        fn reverse(self: *Self) void {
            var prev_node: ?*SLLNode = null;
            var curr_node = self.head;
            var next_node = self.head;
            while (next_node != null) {
                next_node = next_node.?.next;
                curr_node.?.next = prev_node;
                prev_node = curr_node;
                curr_node = next_node;
            }
            self.head = prev_node;
        }

        fn print(self: *Self) void {
            var head = self.head;
            std.debug.print("The linked list is:\n", .{});
            while (head != null) {
                std.debug.print("{any} -> ", .{head.?.value});
                head = head.?.next;
            }
            std.debug.print("null\n", .{});
        }
    };
}

// User Inputs

pub fn getUserInput() ![]const u8 {
    const stdin = std.io.getStdIn().reader();
    var buffer: [256]u8 = undefined;
    const input = try stdin.readUntilDelimiter(&buffer, '\n');
    return std.mem.trim(u8, input, "\n\r");
}

pub fn getIntInput(comptime T: type) !T {
    while (true) {
        const input = try getUserInput();
        if (input.len == 0) {
            continue;
        }
        const parsed_value = std.fmt.parseInt(T, input, 10) catch {
            // std.debug.print("Invalid input. Please enter a valid integer.\n", .{});
            continue;
        };
        return parsed_value;
    }
}
