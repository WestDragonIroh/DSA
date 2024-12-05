// Initalization of Array

const std = @import("std");

pub fn main() !void {
    const a1: [4]u8 = [4]u8{ 1, 2, 3, 4 };
    const a2 = [3]u4{ 5, 6, 7 };
    const a3 = [_]u4{ 8, 9 };
    _ = a1;
    _ = a2;
    _ = a3;
}
