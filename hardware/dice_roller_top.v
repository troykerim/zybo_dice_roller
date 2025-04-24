`timescale 1ns / 1ps

module dice_roller_top(
    input wire clk,              // 125 MHz system clock
    input wire rst,              // Reset button
    input wire roll,             // Roll button
    output wire [6:0] seg,       // 7-segment segments
    output reg [1:0] an          // Anode control
);

    // Internal
    reg [2:0] dice_val_1 = 3'd0; // For J1
    reg [2:0] dice_val_2 = 3'd0; // For J2
    reg display_toggle = 0;      // 0: show J1, 1: show J2

    reg [3:0] current_digit;
    wire [6:0] segment_out;
    reg [15:0] refresh_cnt = 0;
    wire refresh_clk = refresh_cnt[15];

    // Debounce roll button logic
    reg [1:0] roll_shift;
    wire roll_rise;

    always @(posedge clk)
        roll_shift <= {roll_shift[0], roll};

    assign roll_rise = (roll_shift == 2'b01);

    // Random LFSR dice generator
    reg [3:0] lfsr = 4'b1011;
    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= 4'b1011;
        else if (roll_rise)
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
    end

    // LFSR mod 6 -> value from 1 to 6
    wire [2:0] dice_out = (lfsr % 6) + 1;

    // Update dice values on roll
    always @(posedge clk) begin
        if (rst) begin
            dice_val_1 <= 3'd0;
            dice_val_2 <= 3'd0;
            display_toggle <= 0;
        end else if (roll_rise) begin
            display_toggle <= ~display_toggle;
            if (!display_toggle)
                dice_val_1 <= dice_out;
            else
                dice_val_2 <= dice_out;
        end
    end

    // SSD refresh timing
    always @(posedge clk)
        refresh_cnt <= refresh_cnt + 1;

    // Display alternating digit
    always @(posedge refresh_clk) begin
        if (!display_toggle) begin
            // Show right digit only (J1)
            an <= 2'b01;
            current_digit <= dice_val_1;
        end else begin
            // Show left digit only (J2)
            an <= 2'b10;
            current_digit <= dice_val_2;
        end
    end

    // SSD Driver
    ssd_driver ssd_inst (
        .dig(current_digit),
        .segment(segment_out)
    );

    assign seg = segment_out;

endmodule
