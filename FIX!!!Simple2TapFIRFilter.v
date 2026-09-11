/*
Design a module named 'top' that implements a simple 2‑tap finite impulse response (FIR) filter: y[n] = x[n]+x[n-1]. 
The module should include a clock input (clk), an active‑high reset (rst), and a 16‑bit signed data input (data_in). 
The output (data_out) must be a 16‑bit signed value that is the sum of the current input and the previous input sample. 
Use a shift register to store the previous sample and register the result on the rising edge of clk. Reset clears the shift register to zero.
*/

module top(
    input  clk,
    input  rst,
    input  signed [15:0] data_in,
    output signed [15:0] data_out
);
    // Write your code here
    
endmodule
