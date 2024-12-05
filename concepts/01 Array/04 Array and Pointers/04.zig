// Array and Pointers

const std = @import("std");

// Zig doesn't follow same array pointer concept as C.
// * is format specifer for address in zig
// For pointer arithmetic and slicing use multi item pointer [*]T insted of *T.
// const a: [?]u32 = [_]u32{6, 2, 1, 5, 3};
// &a = [5]100 and a != &a
// var p: [*]u32 = &a
// We can't derefrence this multi item pointer like p.*
// Instead it would be used same as array name.
// p[1] = 2

pub fn main() !void {
    const a = [_]u8{ 6, 2, 1, 5, 3 };
    var p: [*]const u8 = &a;
    p += 1;
    std.debug.print("{any} {any}\n", .{ a[0], p[0] });
}
