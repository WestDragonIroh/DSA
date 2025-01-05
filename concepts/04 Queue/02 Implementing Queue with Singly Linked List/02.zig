// Implementing Queue with Singly Linked List

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const T = u8;
    var queue: SLLQueue(T) = undefined;
    try queue.init(arena.allocator());
    defer queue.deinit();

    while (true) {
        std.debug.print("Input command for following operations in queue.\n", .{});
        std.debug.print("1 enqueue\n2 dequeue\n3 peek\n4 display\n0 exit\n", .{});
        const i = try getIntInput(usize);
        if (i == 1) {
            std.debug.print("Enter data\n", .{});
            const x = try getIntInput(T);
            try queue.enqueue(x);
        } else if (i == 2) {
            queue.dequeue();
        } else if (i == 3) {
            queue.peek();
        } else if (i == 4) {
            queue.display();
        } else {
            break;
        }
    }
}

// Structs

pub fn SLLQueue(comptime DataType: type) type {
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
        front: ?*SLLNode,
        rear: ?*SLLNode,

        fn init(self: *Self, allocator: std.mem.Allocator) !void {
            self.allocator = allocator;
            self.front = null;
            self.rear = null;
        }

        fn deinit(self: *Self) void {
            // This syntax is used to check temp != null
            while (self.front) |to_free| {
                self.front = to_free.next;
                self.allocator.destroy(to_free);
            }
        }

        fn enqueue(self: *Self, x: DataType) !void {
            const new_node = try SLLNode.init(self.allocator, x, null);
            if (self.rear) |rear| {
                rear.next = new_node;
                self.rear = new_node;
            } else {
                self.front = new_node;
                self.rear = new_node;
            }
        }

        fn dequeue(self: *Self) void {
            // This syntax is used to check temp != null
            if (self.front) |to_free| {
                self.front = to_free.next;
                if (to_free == self.rear) {
                    self.rear = to_free.next;
                }
                std.debug.print("Removed element is {}\n", .{to_free.value});
                self.allocator.destroy(to_free);
            } else {
                std.debug.print("Underflow\n", .{});
            }
        }

        fn peek(self: *Self) void {
            if (self.front) |front| {
                std.debug.print("Front element is {}\n", .{front.value});
            } else {
                std.debug.print("Queue is empty\n", .{});
            }
        }

        fn display(self: *Self) void {
            if (self.front) |_| {
                std.debug.print("Elements of queue are:\n", .{});
                var temp = self.front;
                while (temp) |node| {
                    std.debug.print(" {}", .{node.value});
                    temp = node.next;
                }
                std.debug.print("\n", .{});
            } else {
                std.debug.print("Empty queue\n", .{});
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
