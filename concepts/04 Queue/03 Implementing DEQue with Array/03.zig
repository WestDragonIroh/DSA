// Implementing DEQue with Array

const std = @import("std");

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    const T = u8;
    const size: usize = 3;
    var queue: ArrayDEQue(T) = undefined;
    try queue.init(arena.allocator(), size);
    defer queue.deinit();

    while (true) {
        std.debug.print("Input command for following operations in queue.\n", .{});
        std.debug.print("1 enqueueFront\n2 enqueueRear\n3 dequeueFront\n", .{});
        std.debug.print("4 dequeueRear\n5 peekFront\n6 peekRear\n7 display\n", .{});
        std.debug.print("0 exit\n", .{});
        const i = try getIntInput(usize);
        if (i == 1 or i == 2) {
            std.debug.print("Enter data\n", .{});
            const x = try getIntInput(T);
            if (i == 1) {
                queue.enqueueFront(x);
            } else {
                queue.enqueueRear(x);
            }
        } else if (i == 3) {
            queue.dequeueFront();
        } else if (i == 4) {
            queue.dequeueRear();
        } else if (i == 5) {
            queue.peekFront();
        } else if (i == 6) {
            queue.peekRear();
        } else if (i == 7) {
            queue.display();
        } else {
            break;
        }
    }
}

// Structs

pub fn ArrayDEQue(comptime DataType: type) type {
    return struct {
        const Self = @This();

        allocator: std.mem.Allocator,
        queue: []DataType,
        size: usize,
        front: usize,
        rear: usize,

        fn init(self: *Self, allocator: std.mem.Allocator, size: usize) !void {
            self.allocator = allocator;
            self.queue = try allocator.alloc(DataType, size);
            self.size = size;
            self.front = size;
            self.rear = size;
        }

        fn deinit(self: *Self) void {
            self.allocator.free(self.queue);
        }

        fn enqueueFront(self: *Self, x: DataType) void {
            if (self.rear == self.size) {
                self.front = 0;
                self.rear = 0;
                self.queue[self.front] = x;
            } else if ((self.front + self.size - 1) % self.size == self.rear) {
                std.debug.print("Overflow\n", .{});
            } else {
                self.front = (self.front + self.size - 1) % self.size;
                self.queue[self.front] = x;
            }
        }

        fn enqueueRear(self: *Self, x: DataType) void {
            if (self.rear == self.size) {
                self.front = 0;
                self.rear = 0;
                self.queue[self.rear] = x;
            } else if (((self.rear + 1) % self.size) == self.front) {
                std.debug.print("Overflow\n", .{});
            } else {
                self.rear = (self.rear + 1) % self.size;
                self.queue[self.rear] = x;
            }
        }

        fn dequeueFront(self: *Self) void {
            if (self.front == self.size) {
                std.debug.print("Underflow\n", .{});
            } else {
                std.debug.print("Removed element is {}\n", .{self.queue[self.front]});
                if (self.front == self.rear) {
                    self.front = self.size;
                    self.rear = self.size;
                } else {
                    self.front = (self.front + 1) % self.size;
                }
            }
        }

        fn dequeueRear(self: *Self) void {
            if (self.rear == self.size) {
                std.debug.print("Underflow\n", .{});
            } else {
                std.debug.print("Removed element is {}\n", .{self.queue[self.rear]});
                if (self.front == self.rear) {
                    self.front = self.size;
                    self.rear = self.size;
                } else {
                    self.rear = (self.rear + self.size - 1) % self.size;
                }
            }
        }

        fn peekFront(self: *Self) void {
            if (self.front == self.size) {
                std.debug.print("Queue is empty\n", .{});
            } else {
                std.debug.print("Front element is {}\n", .{self.queue[self.front]});
            }
        }

        fn peekRear(self: *Self) void {
            if (self.front == self.size) {
                std.debug.print("Queue is empty\n", .{});
            } else {
                std.debug.print("Rear element is {}\n", .{self.queue[self.rear]});
            }
        }

        fn display(self: *Self) void {
            if (self.front == self.size) {
                std.debug.print("Empty queue\n", .{});
            } else {
                std.debug.print("Elements of queue are \n", .{});
                var i = self.front;
                while (i != self.rear) {
                    std.debug.print(" {}", .{self.queue[i]});
                    i = (i + 1) % self.size;
                }
                std.debug.print(" {}\n", .{self.queue[i]});
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
