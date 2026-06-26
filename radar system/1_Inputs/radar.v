`timescale 1ns / 1ps

module radar(
    input clk,
    input rst,
    input start_ping,
    input echo_rx,

    output reg [7:0] count_value,
    output reg [7:0] distance_um
);

    reg [7:0] count;
    reg measuring;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            count <= 8'd0;
            count_value <= 8'd0;
            distance_um <= 8'd0;
            measuring <= 1'b0;
        end
        else
        begin
            // Start measurement
            if(start_ping && !measuring)
            begin
                count <= 8'd1;      // Immediate first count
                measuring <= 1'b1;
            end

            // Continue counting
            else if(measuring)
            begin
                count <= count + 1'b1;
            end

            // Echo received
            if(echo_rx && measuring)
            begin
                measuring <= 1'b0;

                count_value <= count;

                // Distance calculation
                distance_um <= (count * 10 * 343) / 2000;
            end
        end
    end

endmodule`timescale 1ns / 1ps

module radar(
    input clk,
    input rst,
    input start_ping,
    input echo_rx,

    output reg [7:0] count_value,
    output reg [7:0] distance_um
);

    reg [7:0] count;
    reg measuring;

    always @(posedge clk or posedge rst)
    begin
        if(rst)
        begin
            count <= 8'd0;
            count_value <= 8'd0;
            distance_um <= 8'd0;
            measuring <= 1'b0;
        end
        else
        begin
            // Start measurement
            if(start_ping && !measuring)
            begin
                count <= 8'd1;      // Immediate first count
                measuring <= 1'b1;
            end

            // Continue counting
            else if(measuring)
            begin
                count <= count + 1'b1;
            end

            // Echo received
            if(echo_rx && measuring)
            begin
                measuring <= 1'b0;

                count_value <= count;

                // Distance calculation
                distance_um <= (count * 10 * 343) / 2000;
            end
        end
    end

endmodule
