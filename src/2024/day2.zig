const std = @import("std");
const zigvent = @import("zigvent");

const path = "src/2024/files/day2.txt";
pub fn pt1() !void {
    //open file
    var file = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    //read to buffer
    var buf: [20_000]u8 = undefined;
    const bytes_read = try file.read(&buf);
    std.debug.print("bytes_read: {d}\n", .{bytes_read});

    var lines = std.mem.tokenizeAny(u8, buf[0..bytes_read], "\n");

    var safe: usize = 0;
    while (lines.next()) |line| {
        //std.debug.print("line: {s}\n", .{line});
        var items = std.mem.tokenizeAny(u8, line, " \t\r");

        const first_str = items.next().?;
        var prev = try std.fmt.parseInt(i32, first_str, 10);

        var cur: i32 = prev;
        var inc: ?bool = null;
        var valid = true;

        inner: while (items.next()) |item| {
            cur = try std.fmt.parseInt(i32, item, 10);
            //std.debug.print("cur: {d}, prev: {d}\n", .{ cur, prev });
            //at start check if increasing or decreasing
            if (inc == null) {
                inc = cur > prev;
            }

            if (inc == true) {
                if (cur > prev + 3 or cur <= prev) {
                    valid = false;

                    //std.debug.print("FAIL: cur: {d}, prev: {d}\n", .{ cur, prev });
                    break :inner;
                }
            } else {
                if (cur < prev - 3 or cur >= prev) {
                    valid = false;
                    //std.debug.print("FAIL: cur: {d}, prev: {d}\n", .{ cur, prev });
                    break :inner;
                }
            }
            prev = cur;
        }
        //we made it safe and sound 😅
        if (valid) {
            //std.debug.print("SAFE\n", .{});
            safe += 1;
        }
    }

    std.debug.print("Answer: {d}\n", .{safe});
}

fn pt2() !void {}
