`timescale 1ns/1ps

module fir_filter_tb;

// Parameters
parameter CLK_PERIOD = 10;  // Clock period in ns

// Signals
reg clk;
reg rst;
reg valid_in;
reg [15:0] coeffs[3:0];    // FIR coefficients
reg [15:0] signal;         // Input signal
wire valid_out;
wire [31:0] signal_out;    // Filtered signal output

// Instantiate the FIR filter module
fir_filter uut (
    .clk(clk),
    .rst(rst),
    .valid_in(valid_in),
    .coeffs(coeffs),
    .signal(signal),
    .valid_out(valid_out),
    .signal_out(signal_out)
);

// Clock generation
initial begin
    clk = 0;
    forever #(CLK_PERIOD / 2) clk = ~clk;  // Toggle clock every half period
end

// Stimulus generation
initial begin
    // Initialize inputs
    rst = 1;               // Assert reset
    valid_in = 0;
    signal = 16'd0;
    coeffs[0] = 16'd2;     // Example coefficients
    coeffs[1] = 16'd6;
    coeffs[2] = 16'd5;
    coeffs[3] = 16'd6;

    // Release reset after 2 clock cycles
    # (2 * CLK_PERIOD);
    rst = 0;

    // Apply input signal
    valid_in = 1;
    signal = 16'd10;  #CLK_PERIOD; // Input 1
    signal = 16'd20;  #CLK_PERIOD; // Input 2
    signal = 16'd15;  #CLK_PERIOD; // Input 3
    signal = 16'd5;   #CLK_PERIOD; // Input 4

    // Stop valid_in signal
    valid_in = 0;
    # (5 * CLK_PERIOD);

    $stop;  // End simulation
end

endmodule
