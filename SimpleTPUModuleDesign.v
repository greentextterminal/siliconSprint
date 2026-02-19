/*
Design a simple TPU (Tensor Processing Unit) module that takes two 4-bit inputs representing tensor values, performs an addition operation, and outputs a 5-bit result. 
The module should handle overflow correctly and output the sum of the inputs.
*/

module top(
  input [3:0] a,
  input [3:0] b,
  output [4:0] result
);

  // assigning to a 5 bit wide variable allows for the cout of the addition operation to be captured
  assign result = a + b;
endmodule
