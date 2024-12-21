// Doubly Linked List

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var a = [_]u8{ 1, 2, 3, 4, 5 };
    var dll: DLL(u8) = undefined;
    try dll.init(arena.allocator(), &a);
    dll.print();
    try dll.insert(10, 3);
    dll.print();
    dll.delete(3);
    dll.print();
    dll.reverse();
    dll.print();
    dll.free();
}

// Structs

pub fn DLL(comptime DataType: type) type {
    return struct {
        const Self = @This();

        const DLLNode = struct {
            value: DataType,
            prev: ?*DLLNode,
            next: ?*DLLNode,

            fn init(allocator: std.mem.Allocator, value: DataType) !*DLLNode {
                var node = try allocator.create(DLLNode);
                node.value = value;
                node.prev = null;
                node.next = null;
                return node;
            }
        };

        allocator: std.mem.Allocator,
        head: ?*DLLNode,
        len: usize,

        fn init(self: *Self, allocator: std.mem.Allocator, arr: []DataType) !void {
            self.allocator = allocator;
            self.head = null;
            self.len = 0;
            var temp = self.head;
            for (arr, 0..) |value, i| {
                const new_node = try DLLNode.init(allocator, value);
                if (i == 0) {
                    self.head = new_node;
                    temp = new_node;
                } else {
                    temp.?.next = new_node;
                    new_node.prev = temp;
                    temp = new_node;
                }
                self.len += 1;
            }
        }

        fn insert(self: *Self, value: DataType, index: usize) !void {
            if (index > self.len) {
                std.debug.print("Index out of bound\n", .{});
                return;
            }
            const new_node = try DLLNode.init(self.allocator, value);
            if (index == 0) {
                new_node.next = self.head;
                self.head = new_node;
            } else {
                var temp = self.head;
                for (0..(index - 1)) |_| {
                    temp = temp.?.next;
                }
                new_node.prev = temp;
                new_node.next = temp.?.next;
                temp.?.next.?.prev = new_node;
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
                self.head.?.prev = null;
                self.allocator.destroy(temp.?);
            } else {
                for (0..(index - 1)) |_| {
                    temp = temp.?.next;
                }
                const next_node = temp.?.next;
                temp.?.next = temp.?.next.?.next;
                next_node.?.next.?.prev = temp;
                self.allocator.destroy(next_node.?);
            }
            self.len -= 1;
        }

        fn reverse(self: *Self) void {
            var curr_node = self.head;
            while (curr_node != null) {
                const next_node = curr_node.?.next;
                curr_node.?.next = curr_node.?.prev;
                curr_node.?.prev = next_node;
                if (next_node == null) {
                    self.head = curr_node;
                }
                curr_node = next_node;
            }
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

        fn free(self: *Self) void {
            while (self.head != null) {
                const temp = self.head;
                self.head = self.head.?.next;
                self.allocator.destroy(temp.?);
                self.len -= 1;
            }
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
