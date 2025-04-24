`timescale 1ns / 1ps
module dice_roller(
    input wire clk,
    input wire rst,
    input wire roll,             // Trigger to roll (e.g., button press)
    output reg [2:0] dice        // Output: 3-bit number from 1 to 6
);

    reg [3:0] lfsr = 4'b1011;    // 4-bit LFSR with a non-zero seed

    always @(posedge clk or posedge rst) begin
        if (rst)
            lfsr <= 4'b1011;     // Reset to seed
        else if (roll) begin
            // 4-bit LFSR with taps at bits 4 and 3 (XOR feedback)
            lfsr <= {lfsr[2:0], lfsr[3] ^ lfsr[2]};
        end
    end

    // Map LFSR value to a 1-6 dice roll
    always @(*) begin
        case (lfsr % 6)
            0: dice = 3'd1;
            1: dice = 3'd2;
            2: dice = 3'd3;
            3: dice = 3'd4;
            4: dice = 3'd5;
            5: dice = 3'd6;
            default: dice = 3'd1;
        endcase
    end

endmodule
