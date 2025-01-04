// Implementing Stack with Array

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    std.debug.print("Enter size of stack\n", .{});
    const size = try getIntInput(usize);
    var stack: ArrayStack(u8) = undefined;
    try stack.init(arena.allocator(), size);
    defer stack.deinit();

    while (true) {
        std.debug.print("Input command for following operations in stack.\n", .{});
        std.debug.print("1 push\n2 pop\n3 peek\n4 display\n0 exit\n", .{});
        const i = try getIntInput(usize);
        if (i == 1) {
            try stack.push();
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

pub fn ArrayStack(comptime DataType: type) type {
    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        stack: []DataType,
        size: usize,
        top: usize,

        fn init(self: *Self, allocator: std.mem.Allocator, size: usize) !void {
            self.allocator = allocator;
            self.stack = try allocator.alloc(DataType, size);
            self.size = size;
            self.top = 0;
        }

        fn deinit(self: *Self) void {
            self.allocator.free(self.stack);
        }

        fn push(self: *Self) !void {
            if (self.top == self.size) {
                std.debug.print("Overflow\n", .{});
            } else {
                std.debug.print("Enter data\n", .{});
                self.stack[self.top] = try getIntInput(DataType);
                self.top += 1;
            }
        }

        fn pop(self: *Self) void {
            if (self.top == 0) {
                std.debug.print("Underflow\n", .{});
            } else {
                self.top -= 1;
                std.debug.print("Removed element is {}\n", .{self.stack[self.top]});
            }
        }

        fn peek(self: *Self) void {
            if (self.top == 0) {
                std.debug.print("Stack is empty\n", .{});
            } else {
                std.debug.print("Top element is {}\n", .{self.stack[self.top - 1]});
            }
        }

        fn display(self: *Self) void {
            if (self.top == 0) {
                std.debug.print("Empty stack\n", .{});
            } else {
                std.debug.print("Stack is \n", .{});
                for (0..self.top) |i| {
                    std.debug.print("{}\n", .{self.stack[self.top - 1 - i]});
                }
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
