/*
Design a SystemVerilog module named 'top' that performs a simple image processing task: inverting a grayscale image. 
The module receives a single pixel value as input (8-bit grayscale) and outputs the inverted pixel value. 
Inversion is defined as output = 255 - input.
*/

module top(
    input  [7:0] pixel_in,
    output [7:0] pixel_out
);

    assign pixel_out = 8'd255 - pixel_in;
endmodule
