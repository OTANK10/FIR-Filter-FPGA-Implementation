module fir_filter (
    input wire clk,
    input wire rst,
    input wire valid_in,
    input wire load,              // Signal to load coefficients
    input wire [63:0] coeff_in,   // 4 coefficients, each 16 bits
    input wire [15:0] signal_in,  // 16-bit input signal
    output reg valid_out,         // Indicates valid output
    output reg [31:0] signal_out  // Final filtered signal output
);

    // Register array to store coefficients
    reg [15:0] coeffs [3:0];

    // Registers for pipeline stages
    reg [15:0] signal_pipeline [3:0];
    reg [31:0] tap_out [3:0];

    // Load coefficients into the registers
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            coeffs[0] <= 16'd0;
            coeffs[1] <= 16'd0;
            coeffs[2] <= 16'd0;
            coeffs[3] <= 16'd0;
        end else if (load) begin
            coeffs[0] <= coeff_in[15:0];
            coeffs[1] <= coeff_in[31:16];
            coeffs[2] <= coeff_in[47:32];
            coeffs[3] <= coeff_in[63:48];
        end
    end

    // Pipeline for signal input and multiplication
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            signal_pipeline[0] <= 16'd0;
            signal_pipeline[1] <= 16'd0;
            signal_pipeline[2] <= 16'd0;
            signal_pipeline[3] <= 16'd0;

            tap_out[0] <= 32'd0;
            tap_out[1] <= 32'd0;
            tap_out[2] <= 32'd0;
            tap_out[3] <= 32'd0;
        end else if (valid_in) begin
            signal_pipeline[0] <= signal_in;
            signal_pipeline[1] <= signal_pipeline[0];
            signal_pipeline[2] <= signal_pipeline[1];
            signal_pipeline[3] <= signal_pipeline[2];

            tap_out[0] <= coeffs[0] * signal_pipeline[0];
            tap_out[1] <= coeffs[1] * signal_pipeline[1];
            tap_out[2] <= coeffs[2] * signal_pipeline[2];
            tap_out[3] <= coeffs[3] * signal_pipeline[3];
        end
    end

    // Sum the outputs and set valid_out
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            signal_out <= 32'd0;
            valid_out <= 1'b0;
        end else if (valid_in) begin
            signal_out <= tap_out[0] + tap_out[1] + tap_out[2] + tap_out[3];
            valid_out <= 1'b1;
        end else begin
            valid_out <= 1'b0;
        end
    end
endmodule
