module fir_tap (
    input wire clk,
    input wire rst,
    input wire valid_in,
    input wire [15:0] coeff,   // 16-bit coefficient
    input wire [15:0] signal,  // 16-bit input signal
    output reg [31:0] tap_out  // 32-bit output (to handle multiplication overflow)
);
    always @(posedge clk or posedge rst) begin
        if (rst)
            tap_out <= 32'b0; // Reset output
        else if (valid_in)
            tap_out <= coeff * signal; // Multiply coefficient and signal
    end
endmodule
