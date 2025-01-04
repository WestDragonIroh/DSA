// Implementing Stack with Singly Linked List

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const T = u8;
    var stack: SLLStack(T) = undefined;
    try stack.init(arena.allocator());
    defer stack.deinit();

    while (true) {
        std.debug.print("Input command for following operations in stack.\n", .{});
        std.debug.print("1 push\n2 pop\n3 peek\n4 display\n0 exit\n", .{});
        const i = try getIntInput(usize);
        if (i == 1) {
            std.debug.print("Enter data\n", .{});
            const x = try getIntInput(T);
            try stack.push(x);
        } else if (i == 2) {
            stack.pop();
        } else if (i == 3) {
            stack.peek();
        } else if (i == 4) {
            stack.display();
        } else {
            break;
        }
    }
}

// Structs

pub fn SLLStack(comptime DataType: type) type {
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
        top: ?*SLLNode,

        fn init(self: *Self, allocator: std.mem.Allocator) !void {
            self.allocator = allocator;
            self.top = null;
        }

        fn deinit(self: *Self) void {
            // This syntax is used to check temp != null
            while (self.top) |to_free| {
                self.top = to_free.next;
                self.allocator.destroy(to_free);
            }
        }

        fn push(self: *Self, x: DataType) !void {
            const new_node = try SLLNode.init(self.allocator, x, self.top);
            self.top = new_node;
        }

        fn pop(self: *Self) void {
            // This syntax is used to check temp != null
            if (self.top) |to_free| {
                self.top = to_free.next;
                std.debug.print("Removed element is {}\n", .{to_free.value});
                self.allocator.destroy(to_free);
            } else {
                std.debug.print("Underflow\n", .{});
            }
        }

        fn peek(self: *Self) void {
            if (self.top) |top| {
                std.debug.print("Top element is {}\n", .{top.value});
            } else {
                std.debug.print("Stack is empty\n", .{});
            }
        }

        fn display(self: *Self) void {
            if (self.top) |_| {
                std.debug.print("Elements of stack are:\n", .{});
                var temp = self.top;
                while (temp) |node| {
                    std.debug.print("{}\n", .{node.value});
                    temp = node.next;
                }
            } else {
                std.debug.print("Empty stack\n", .{});
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
