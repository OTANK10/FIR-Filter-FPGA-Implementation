//========================================================== 
//
// University of Massachusetts, Amherst
// Department of Electrical and Computer Engineering
// ECE636 Reconfigurable Computing
//
// Created by George Provelengios on 01/31/2017
//
// Comments: Feel free to edit this testbench according to your needs
//
//==========================================================

// Define the time precision of the simulation
//========================================================== 
//
// University of Massachusetts, Amherst
// Department of Electrical and Computer Engineering
// ECE636 Reconfigurable Computing
//
// Created by George Provelengios on 01/31/2017
//
// Comments: Updated for debugging and improved functionality
//
//==========================================================

// Define the time precision of the simulation
`timescale 1ns / 1ns

module fir_tb;

    localparam CLK_PERIOD = 10;
    localparam FIR_ORDER = 4;

    reg clk;
    reg rst;
    reg load;
    reg valid_in;
    reg [(FIR_ORDER * 16) - 1:0] coeff_in;
    reg [15:0] signal_in;
    wire valid_out;
    wire [31:0] signal_out;

    // Declare arrays to store test data
    reg [15:0] coefficients[0:FIR_ORDER-1];
    reg [15:0] signal[0:127];
    reg [31:0] expected_values[0:127];

    integer i, signal_idx;

    // Instantiate the FIR filter
    fir_filter UUT (
        .clk(clk),
        .rst(rst),
        .load(load),
        .valid_in(valid_in),
        .coeff_in(coeff_in),
        .signal_in(signal_in),
        .valid_out(valid_out),
        .signal_out(signal_out)
    );

    // Clock generation
    initial clk = 0;
    always #(CLK_PERIOD / 2) clk = ~clk;

    // Load test data
    initial begin
        $readmemh("C:/Users/Om/Downloads/Project/fir_filter_arm_student/fir_filter_arm/tests/coeff.txt", coefficients);
        $readmemh("C:/Users/Om/Downloads/Project/fir_filter_arm_student/fir_filter_arm/tests/signal_in.txt", signal);
        $readmemh("C:/Users/Om/Downloads/Project/fir_filter_arm_student/fir_filter_arm/tests/expected_values.txt", expected_values);
    end

    // Reset and load coefficients
    initial begin
        rst = 1;
        load = 0;
        valid_in = 0;
        signal_idx = 0;

        // Reset the FIR filter
        #(CLK_PERIOD * 2);
        rst = 0;

        // Load coefficients
        coeff_in = {coefficients[3], coefficients[2], coefficients[1], coefficients[0]};
        load = 1;
        #(CLK_PERIOD);
        load = 0;

        // Wait for coefficient load to propagate
        #(CLK_PERIOD * 2);

        // Start testing
        for (signal_idx = 0; signal_idx < 128; signal_idx = signal_idx + 1) begin
            valid_in = 1;
            signal_in = signal[signal_idx];
            #(CLK_PERIOD);
            valid_in = 0;
            #(CLK_PERIOD * 3);

            // Compare output
            if (valid_out) begin
                if (signal_out != expected_values[signal_idx]) begin
                    $display("FAIL: index: %4d, actual: 0x%h, expected: 0x%h", signal_idx, signal_out, expected_values[signal_idx]);
                end else begin
                    $display("PASS: index: %4d, actual: 0x%h, expected: 0x%h", signal_idx, signal_out, expected_values[signal_idx]);
                end
            end
        end

        $stop;
    end
endmodule
