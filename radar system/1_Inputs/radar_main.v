`timescale 1 ns/10 ps

module radar_main(

    input clk_pad,
    input rst_pad,
    input start_ping_pad,
    input echo_rx_pad,

    output [7:0] count_value_pad,
    output [7:0] distance_um_pad
);

wire clk;
wire rst;
wire start_ping;
wire echo_rx;

wire radar_clk;

reg [7:0] count_value;
reg [7:0] distance_um;

/////////////////////////////////////////////////
// Clock Buffering
/////////////////////////////////////////////////

pc3c01 pc3c01_1 (
    .CCLK(radar_clk),
    .CP(clk)
);

/////////////////////////////////////////////////
// Input Pad Instantiation
/////////////////////////////////////////////////

pc3d01 pc3d01_1 (
    .PAD(clk_pad),
    .CIN(radar_clk)
);

pc3d01 pc3d01_2 (
    .PAD(rst_pad),
    .CIN(rst)
);

pc3d01 pc3d01_3 (
    .PAD(start_ping_pad),
    .CIN(start_ping)
);

pc3d01 pc3d01_4 (
    .PAD(echo_rx_pad),
    .CIN(echo_rx)
);

/////////////////////////////////////////////////
// Output Pad Instantiation
/////////////////////////////////////////////////

pc3o05 pc3o05_1 (.I(count_value[0]), .PAD(count_value_pad[0]));
pc3o05 pc3o05_2 (.I(count_value[1]), .PAD(count_value_pad[1]));
pc3o05 pc3o05_3 (.I(count_value[2]), .PAD(count_value_pad[2]));
pc3o05 pc3o05_4 (.I(count_value[3]), .PAD(count_value_pad[3]));
pc3o05 pc3o05_5 (.I(count_value[4]), .PAD(count_value_pad[4]));
pc3o05 pc3o05_6 (.I(count_value[5]), .PAD(count_value_pad[5]));
pc3o05 pc3o05_7 (.I(count_value[6]), .PAD(count_value_pad[6]));
pc3o05 pc3o05_8 (.I(count_value[7]), .PAD(count_value_pad[7]));

pc3o05 pc3o05_9  (.I(distance_um[0]), .PAD(distance_um_pad[0]));
pc3o05 pc3o05_10 (.I(distance_um[1]), .PAD(distance_um_pad[1]));
pc3o05 pc3o05_11 (.I(distance_um[2]), .PAD(distance_um_pad[2]));
pc3o05 pc3o05_12 (.I(distance_um[3]), .PAD(distance_um_pad[3]));
pc3o05 pc3o05_13 (.I(distance_um[4]), .PAD(distance_um_pad[4]));
pc3o05 pc3o05_14 (.I(distance_um[5]), .PAD(distance_um_pad[5]));
pc3o05 pc3o05_15 (.I(distance_um[6]), .PAD(distance_um_pad[6]));
pc3o05 pc3o05_16 (.I(distance_um[7]), .PAD(distance_um_pad[7]));

/////////////////////////////////////////////////
// Radar Core
/////////////////////////////////////////////////

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
