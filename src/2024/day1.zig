const std = @import("std");
const zigvent = @import("zigvent");

const path = "src/2024/files/day1.txt";

pub fn pt1() !void {
    const start = try std.time.Instant.now();
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var buf: [14_000]u8 = undefined;
    const bytes_read = try file.read(&buf);
    std.debug.print("bytes_read: {d}\n", .{bytes_read});

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

    // try bubbleSort(left);
    // try bubbleSort(right);
    try sortList(left);
    try sortList(right);

    var diffSum: usize = 0;
    for (0..left.items.len) |i| {
        diffSum += @abs(left.items[i] - right.items[i]);
    }
    const end = try std.time.Instant.now();
    const elapsed_ns = end.since(start);
    const elapsed_ms = @as(f64, @floatFromInt(elapsed_ns)) / 1_000_000.0;
    std.debug.print("Elapsed: {d} ns ({d:.3}) ms\n", .{ elapsed_ns, elapsed_ms });
    std.debug.print("Answer: {d}\n", .{diffSum});
}

pub fn pt2() !void {
    const start = try std.time.Instant.now();
    var buf: [14_000]u8 = undefined;
    var file = try std.fs.cwd().openFile(path, .{});
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

    const end = try std.time.Instant.now();
    const elapsed_ns = end.since(start);
    const elapsed_ms = @as(f64, @floatFromInt(elapsed_ns)) / 1_000_000.0;
    std.debug.print("Elapsed: {d} ns ({d:.3}) ms\n", .{ elapsed_ns, elapsed_ms });
    std.debug.print("{s}:{s}: Answer: {d}\n", .{ @src().file, @src().fn_name, inc });
}

pub fn sortList(list: std.ArrayList(i32)) !void {
    return std.mem.sort(i32, list.items, {}, comptime std.sort.asc(i32));
}

pub fn printList(list: std.ArrayList(i32)) !void {
    const itms = list.items;
    for (itms, 0..) |fruit, i| {
        std.debug.print("  [{d}] {d}\n", .{ i, fruit });
    }
}
