**FIR-Filter-FPGA-Implementation**

* Overview  

This project implements a 4-tap FIR filter on the Intel DE1-SoC FPGA using Verilog HDL. The design features a modular architecture with ARM Hard Processor System (HPS) integration for comprehensive testing and real-time signal processing capabilities.

*Key Features

Modular Design: Reusable single-tap modules for scalability  
ARM-HPS Integration: Real-time testing via dual-core ARM Cortex-A9  
Complete I/O System: 7-segment display output with BIN2BCD conversion  
Comprehensive Testing: Both simulation and hardware verification  
Resource Efficient: Optimized FPGA resource utilization  

*Prerequisites

Intel Quartus Prime Lite Edition 16.1+  
ModelSim-Intel FPGA Start Edition  
Intel FPGA Monitor Program  
DE1-SoC Development Board  

* What is a 4-tap FIR filter? 
A 4-tap FIR filter is a type of Finite Impulse Response (FIR) filter with 4 coefficients (or 
taps). FIR filters are widely used in signal processing to filter or modify signals by applying a 
weighted sum of the current and past input samples.   
A basic FIR filter is kind of a digital filter where the output calculated as a weighted sum of the 
current input and a fixed number of past inputs. The finite part of FIR means that the output 
depends on a finite number of input samples.   
A 4-tap FIR filter, where the term “taps” corresponds to the number of coefficients (weights) and 
the number of input samples. So for 4-tap 4 coefficients and 4 input samples, for a 8-tap 8 
coefficients and 8 input samples.

![image](https://github.com/user-attachments/assets/33000e3f-17c1-4db8-a83f-018734328063)  

The FIR filter pipeline has multiple applications, such as  noise filtration, audio processing by 
enhancing sound, image processing by blurring or sharpening images and in communication 
systems for filtering frequencies in modulated signals.  

* RTL Schematic
![image](https://github.com/user-attachments/assets/8d149dce-33b1-4f29-aba1-d28ef21efc50)

The design of the FIR module is based on a modular and hierarchical approach, which ensures 
clarity, functionality, and ease of integration with the ARM-HPS on the DE1 development 
board.The FIR module is designed with a clear separation of components to enhance reusability 
and debugging:   
● FIR Filter Core: Implements the actual FIR filtering logic, including the multiplication of 
input samples with coefficients and accumulation of results.   
● Wrapper Module: Acts as an interface between the FIR filter and the ARM-HPS, 
handling data transfers, signal synchronization, and control signals.   
● FIFO Buffer: Ensures proper buffering of output data from the FIR filter to handle 
mismatched clock domains or processing speeds between the FPGA and the ARM 
processor.   
* The high-level design, as shown in the Qsys block diagram: 
● HPS-FPGA Communication: The ARM-HPS communicates with the FPGA via parallel 
input/output (PIO) ports for signal transfer, coefficient loading, and result validation.   
● BIN2BCD Converter: Converts binary output data to BCD format for display on the 
7-segment HEX displays.   
● Display Logic: Controls the 7-segment displays based on the converted BCD values. 
● LED Indicators: Used for debugging and to signal the status of the FIR module, such as 
test completion (LED0) and test success (LED1).   
● Key Input Handling: Triggers specific operations like starting the test procedure. 
The FIR filter core implements:   
● Coefficient Multiplication: Each input sample is multiplied by its corresponding 
coefficient.   
● Taps and Accumulation: A series of taps handle the delay and multiplication stages. 
The results are accumulated to produce the final filtered output. 
● Output Validation: Ensures that the output is valid and corresponds to the expected 
value during testing.   
* Testing:  
The FIR design is verified through: 
● Simulation: Testbenches are used to validate the FIR module against predefined input 
signals and expected outputs in simulation tools like ModelSim.   
● On-Board Testing: The design is uploaded to the DE1 board, where the ARM-HPS 
provides test data and reads the results for validation  

* Output  
![image](https://github.com/user-attachments/assets/25d35126-de51-4d84-93be-289169e64ebe)

The output was more legible in the terminal and the error was easily noticeable.  

![image](https://github.com/user-attachments/assets/0affe4c3-59e1-4f56-ac2a-149a1d77a2cd)  


* Results

![image](https://github.com/user-attachments/assets/4de73d50-d86a-433c-a21b-ec0c4a98abc5)

The FIR filter design efficiently utilizes FPGA resources, employing 1092 Adaptive Logic Modules (ALMs) and 1860 Adaptive Look-Up Tables (ALUTs) for implementing logic functions, with a balanced distribution across 3-to-7 input functions. The design leverages 1268 dedicated registers for sequential logic and data storage while requiring 276 I/O pins for communication with external systems such as the ARM-HPS and peripherals. It uses 32,768 block memory bits for buffering and intermediate computations, demonstrating efficient memory management. Notably, the design avoids using DSP blocks, instead relying on combinational logic for arithmetic operations, which optimizes resource usage. A single Phase-Locked Loop (PLL) ensures stable and precise clock generation, critical for real-time signal processing. With a maximum fan-out of 1254 and an average fan-out of 3.24, the design achieves effective signal distribution, minimizing delays. This resource-efficient implementation leaves room for future scalability, making it well-suited for the intended FPGA-based FIR filter application.

* Conclusion

In conclusion, the FIR filter module was successfully implemented and synthesized on the FPGA, demonstrating efficient utilization of resources and functional verification through simulation. The design effectively uses ALMs, ALUTs, and dedicated registers, while leveraging block memory and a PLL for stable operation. The synthesis and simulation results confirm the correctness of the design, aligning with expected outputs.However, several challenges were encountered during the implementation process. One significant issue was the incompatibility of the FPGA's JTAG interface with the computer, likely due to hardware or driver conflicts. Additionally, problems with installing and configuring the appropriate drivers for the FPGA board caused delays in testing the design on hardware. These issues highlight the importance of ensuring compatibility between development tools and hardware platforms. Despite these challenges, the project provides a solid foundation for further optimization and real-world deployment of the FIR filter on FPGA systems.








