// Singly Linked List

const std = @import("std");

// Structs

const SLLNode = struct {
    value: u8,
    next: ?*SLLNode = null,
};

// Main

pub fn main() !void {
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();

    var head: ?*SLLNode = null;
    var new_node: ?*SLLNode = null;
    var temp: ?*SLLNode = null;
    var choice: u8 = 1;

    while (choice == 1) {
        new_node = try arena.allocator().create(SLLNode);
        std.debug.print("Enter data: ", .{});
        new_node.?.value = try getIntInput();
        new_node.?.next = null;
        if (head == null) {
            head = new_node;
            temp = new_node;
        } else {
            temp.?.next = new_node;
            temp = new_node;
        }
        std.debug.print("Do you want to continue(0, 1)? )", .{});
        choice = try getIntInput();
    }
    temp = head;
    while (temp != null) {
        std.debug.print("{} -> ", .{temp.?.value});
        temp = temp.?.next;
    }
    std.debug.print("Null", .{});
}

// User Inputs

pub fn getUserInput() ![]const u8 {
    const stdin = std.io.getStdIn().reader();
    var buffer: [256]u8 = undefined;
    const input = try stdin.readUntilDelimiter(&buffer, '\n');
    return input;
}

pub fn getIntInput() !u8 {
    while (true) {
        const input = try getUserInput();
        const trimmed_input = std.mem.trim(u8, input, " \n\r");
        if (trimmed_input.len == 0) {
            continue;
        }
        const parsed_value = std.fmt.parseInt(u8, trimmed_input, 10) catch {
            // std.debug.print("Invalid input. Please enter a valid integer.\n", .{});
            continue;
        };
        return parsed_value;
    }
}
