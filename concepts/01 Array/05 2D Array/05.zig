// 2D Array

const std = @import("std");

pub fn main() !void {
    var a: [2][3]u8 = undefined;
    std.debug.print("Enter elemnts of array\n", .{});
    for (0..a.len) |i| {
        for (0..a[0].len) |j| {
            a[i][j] = try getIntInput();
        }
    }
    std.debug.print("Entered array is\n", .{});
    for (a) |row| {
        for (row) |value| {
            std.debug.print("{} ", .{value});
        }
        std.debug.print("\n", .{});
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
