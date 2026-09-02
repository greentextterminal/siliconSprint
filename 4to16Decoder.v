/*
The mapping is as follows:

@ in = 0  -> out[0]
@ in = 1  -> out[1]
@ in = 2  -> out[2]
@ in = 3  -> out[3]
...
@ in = 15 -> out[15]

When in is 4'b0000 the 1st bit of the 16 bit out vector needs to be a 1
When in is 4'b0001 the 2nd bit of the 16 bit out vector needs to be a 1
...
When in is 4'b1111 the 16th bit of the 16 bit out vector needs to a 1

The pattern that we see emerge from this is the bit is left shifted with each iteration of in

Map the 4 bit in to the 16 bit output by generating 2D wire matrices
*/

module top(
    input  [3:0]  in,
    output [15:0] out
);
    // -----------------creating wire matrix------------------
    // 16 bit wire row each of which is 16 bits wide (2D matrix)
    //  data width                   rows
    //      |                          |
    wire [15:0] one_hot_wire_matrix [15:0];
    //
    genvar i;
    generate 
        for (i = 0; i < 16; i = i + 1) begin
            assign one_hot_wire_matrix[i] = 16'd1 << i;
        end
    endgenerate

    // using the input as an idx into the wire matrix 
    assign out = one_hot_wire_matrix[in];
    
endmodule
