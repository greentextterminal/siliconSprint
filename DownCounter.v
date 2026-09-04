/*
4-bit synchronous down counter. 
The counter should decrement on every positive clock edge and wrap around after reaching zero.

15 -> 14 -> ... > 2 -> 1 -> 0 -> 15
                            ^
              detect when count reg is at 0

This counter operates on the principle of rollover. 
When the count hits 0 and 1 is subtracted the 4 bit counter.
*/

module top(
    input  clk,
    input  rst_n,
    output [3:0] count
);  
    // register
    reg [3:0] count_reg;
    
    // params
    localparam LOAD_VAL = 4'd0; // 0000 in binary
    
    // describing down count logic
    always @ (posedge clk) begin
        if (~rst_n) begin
            count_reg <= LOAD_VAL; 
        end
        else begin
            count_reg <= count_reg - 1;
        end
    end

    // driving output
    assign count = count_reg;
    
endmodule
