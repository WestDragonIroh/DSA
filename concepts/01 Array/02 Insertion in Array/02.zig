// Insertion in Array

const std = @import("std");

pub fn main() !void {
    var a: [50]u8 = undefined;
    var size: u8 = 0;
    std.debug.print("Enter size of array: ", .{});
    size = try getIntInput();
    std.debug.print("Enter array elements:\n", .{});
    for (0..size) |i| {
        a[i] = try getIntInput();
    }
    std.debug.print("Enter data you want to insert: ", .{});
    const num = try getIntInput();
    std.debug.print("Enter the position to enter data: ", .{});
    const pos = try getIntInput();
    if (pos >= 0 and pos < size) {
        var i: u8 = size;
        while (i > pos) : (i -= 1) {
            a[i] = a[i - 1];
        }
        a[pos] = num;
        size += 1;
    } else {
        std.debug.print("Position out of bound", .{});
    }
    for (0..size) |i| {
        std.debug.print("{} ", .{a[i]});
    }
}

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
            std.debug.print("Invalid input. Please enter a valid integer.\n", .{});
            continue;
        };
        return parsed_value;
    }
}
