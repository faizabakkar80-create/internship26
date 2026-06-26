`timescale 1ns / 1ps

module radar_tb;

    reg clk;
    reg rst;
    reg start_ping;
    reg echo_rx;

    wire [7:0] count_value;
    wire [7:0] distance_um;

    radar uut (
        .clk(clk),
        .rst(rst),
        .start_ping(start_ping),
        .echo_rx(echo_rx),
        .count_value(count_value),
        .distance_um(distance_um)
    );

    // 100 MHz clock
    always #5 clk = ~clk;

    initial
    begin
        clk = 0;
        rst = 1;
        start_ping = 0;
        echo_rx = 0;

        // Reset
        #20;
        rst = 0;

        // Start ping
        #20;
        start_ping = 1;

        #10;
        start_ping = 0;

        // Echo after ~5 clock counts
        #45;
        echo_rx = 1;

        #10;
        echo_rx = 0;

        #50;

        $display("Count Value  = %d", count_value);
        $display("Distance(um) = %d", distance_um);

        $finish;
    end

endmodule
