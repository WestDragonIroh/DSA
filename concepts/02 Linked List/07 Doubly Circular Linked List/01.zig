// Doubly Circular Linked List

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
    var a = [_]u8{ 1, 2, 3, 4, 5 };
    var dcll: DCLL(u8) = undefined;
    try dcll.init(arena.allocator(), &a);
    dcll.print();
    try dcll.insert(10, 3);
    dcll.print();
    dcll.delete(3);
    dcll.print();
    dcll.reverse();
    dcll.print();
    dcll.free();
    // std.debug.print("{any}", .{dcll});
}

// Structs

pub fn DCLL(comptime DataType: type) type {
    return struct {
        const Self = @This();

        const DCLLNode = struct {
            value: DataType,
            prev: ?*DCLLNode,
            next: ?*DCLLNode,

            fn init(allocator: std.mem.Allocator, value: DataType) !*DCLLNode {
                var node = try allocator.create(DCLLNode);
                node.value = value;
                node.prev = null;
                node.next = null;
                return node;
            }
        };

        allocator: std.mem.Allocator,
        head: ?*DCLLNode,
        len: usize,

        fn init(self: *Self, allocator: std.mem.Allocator, arr: []DataType) !void {
            self.allocator = allocator;
            self.head = null;
            self.len = 0;
            var temp = self.head;
            for (arr, 0..) |value, i| {
                const new_node = try DCLLNode.init(allocator, value);
                if (i == 0) {
                    self.head = new_node;
                    new_node.prev = new_node;
                    new_node.next = new_node;
                    temp = new_node;
                } else {
                    new_node.prev = temp;
                    temp.?.next = new_node;
                    temp = new_node;
                }
                self.len += 1;
            }
            self.head.?.prev = temp;
            temp.?.next = self.head;
        }

        fn insert(self: *Self, value: DataType, index: usize) !void {
            if (index > self.len) {
                std.debug.print("Index out of bound\n", .{});
                return;
            }
            const new_node = try DCLLNode.init(self.allocator, value);
            if (self.len == 0) {
                new_node.prev = new_node;
                new_node.next = new_node;
                self.head = new_node;
            } else {
                var temp = self.head;
                var i: usize = 0;
                while (temp.?.next != self.head) {
                    if (i + 1 == index) {
                        new_node.prev = temp;
                        new_node.next = temp.?.next;
                        new_node.next.?.prev = new_node;
                        temp.?.next = new_node;
                    }
                    temp = temp.?.next;
                    i += 1;
                }
                if (index == 0) {
                    new_node.next = temp.?.next;
                    temp.?.next = new_node;
                    self.head = new_node;
                }
            }
            self.len += 1;
        }

        fn delete(self: *Self, index: usize) void {
            if (index < 0 or index >= self.len) {
                std.debug.print("Index out of bound\n", .{});
                return;
            }
            var temp = self.head;
            var i: usize = index;
            if (index == 0) {
                self.head = temp.?.next;
                i = self.len;
            }
            for (0..(i - 1)) |_| {
                temp = temp.?.next;
            }
            const next_node = temp.?.next;
            next_node.?.next.?.prev = temp;
            temp.?.next = temp.?.next.?.next;
            self.allocator.destroy(next_node.?);
            self.len -= 1;
        }

        fn reverse(self: *Self) void {
            if (self.head != null and self.head.?.next != self.head) {
                var curr_node = self.head;
                while (curr_node.?.next != self.head) {
                    const next_node = curr_node.?.next;
                    curr_node.?.next = curr_node.?.prev;
                    curr_node.?.prev = next_node;
                    curr_node = next_node;
                }
                curr_node.?.next = curr_node.?.prev;
                curr_node.?.prev = self.head;
                self.head.?.next = curr_node;
                self.head = curr_node;
            }
        }

        fn print(self: *Self) void {
            var temp = self.head;
            std.debug.print("The linked list is:\n", .{});
            if (self.len == 0) {
                std.debug.print("null\n", .{});
            } else {
                while (temp.?.next != self.head) {
                    std.debug.print("{any} -> ", .{temp.?.value});
                    temp = temp.?.next;
                }
                std.debug.print("{d} -> HEAD\n", .{temp.?.value});
            }
        }

        fn free(self: *Self) void {
            if (self.len > 0) {
                var temp = self.head;
                while (temp.?.next != self.head) {
                    const to_free = temp;
                    temp = temp.?.next;
                    self.allocator.destroy(to_free.?);
                    self.len -= 1;
                }
                self.allocator.destroy(temp.?);
                self.len -= 1;
                self.head = null;
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
