// Pointers and 2D Array

const std = @import("std");

pub fn main() !void {
    const a: [3][3]u8 = .{ .{ 6, 2, 5 }, .{ 0, 1, 3 }, .{ 4, 9, 8 } };
    var p: [*]const [3]u8 = &a;
    p += 1;
    std.debug.print("{any} {any}", .{ &&a, p });
}
