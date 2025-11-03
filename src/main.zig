const std = @import("std");
const zigvent = @import("zigvent");
const expect = std.testing.expect;

pub fn main() !void {
    try day1_pt1();
    try day1_pt2();
}

pub fn day1_pt1() !void {
    var buf: [14_000]u8 = undefined;
    var file = try std.fs.cwd().openFile("files/day1.txt", .{});
    defer file.close();

    const bytes_read = try file.read(&buf);
    std.debug.print("bytes_read: {d}\n", .{bytes_read});

    //create arraylist (need to optimize)
    const allocator = std.heap.page_allocator;

    var left: std.ArrayList(i32) = .empty;
    var right: std.ArrayList(i32) = .empty;
    defer left.deinit(allocator);
    defer right.deinit(allocator);

    var it = std.mem.tokenizeAny(u8, buf[0..bytes_read], " \n\r\t");
    var count: usize = 0;

    while (it.next()) |val| : (count += 1) {
        const d = try std.fmt.parseInt(i32, val, 10);
        if (count % 2 == 0) {
            try left.append(allocator, d);
        } else {
            try right.append(allocator, d);
        }
    }

    try bubbleSort(left);
    try bubbleSort(right);

    var diffSum: usize = 0;
    for (0..left.items.len) |i| {
        diffSum += @abs(left.items[i] - right.items[i]);
    }

    std.debug.print("Answer: {d}\n", .{diffSum});
}

pub fn day1_pt2() !void {
    var buf: [14_000]u8 = undefined;
    var file = try std.fs.cwd().openFile("files/day1.txt", .{});
    defer file.close();

    const bytes_read = try file.read(&buf);
    std.debug.print("bytes_read: {d}\n", .{bytes_read});

    //create arraylist (need to optimize)
    const allocator = std.heap.page_allocator;

    var left: std.ArrayList(u32) = .empty;
    var right: std.ArrayList(u32) = .empty;
    defer left.deinit(allocator);
    defer right.deinit(allocator);

    var it = std.mem.tokenizeAny(u8, buf[0..bytes_read], " \n\r\t");
    var count: usize = 0;

    while (it.next()) |val| : (count += 1) {
        const d = try std.fmt.parseInt(u32, val, 10);
        if (count % 2 == 0) {
            try left.append(allocator, d);
        } else {
            try right.append(allocator, d);
        }
    }

    var inc: usize = 0;
    for (0..left.items.len) |i| {
        inc += std.mem.count(u32, right.items, &.{left.items[i]}) * left.items[i];
    }

    std.debug.print("Answer: {d}\n", .{inc});
}

pub fn sortList(list: std.ArrayList(i32)) !void {
    return std.mem.sort(i32, list.items, {}, comptime std.sort.asc(i32));
}

pub fn bubbleSort(list: std.ArrayList(i32)) !void {
    var itms = list.items;
    if (itms.len <= 1) return;

    var swapped = true;
    while (swapped) {
        swapped = false;
        var i: usize = 1;

        while (i < itms.len) : (i += 1) {
            if (itms[i - 1] > itms[i]) {
                const temp = itms[i - 1];
                itms[i - 1] = itms[i];
                itms[i] = temp;
                swapped = true;
            }
        }
    }
}

pub fn printList(list: std.ArrayList(i32)) !void {
    const itms = list.items;
    for (itms, 0..) |fruit, i| {
        std.debug.print("  [{d}] {d}\n", .{ i, fruit });
    }
}

test "simple test" {
    const gpa = std.testing.allocator;
    var list: std.ArrayList(i32) = .empty;
    defer list.deinit(gpa); // Try commenting this out and see if zig detects the memory leak!
    try list.append(gpa, 42);
    try std.testing.expectEqual(@as(i32, 42), list.pop());
}
