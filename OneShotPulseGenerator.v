/*
Design a module named top that generates a single-cycle pulse when an input level signal transitions from low to high.
Reset is active low and asynchronous.
    - 0 is active
    - 1 is inactive
    
Assume the module starts in reset, then if reset is ever reasserted it will be negedge.
*/

module top(
    input  clk,
    input  rst_n,
    input  level1,
    output one_shot
);
    // wire
    wire posedge_detect;
    
    // reg
    reg level1_dly;
    reg registered_posedge;

    // sig dly for positive edge detection
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            level1_dly         <= 0;
            registered_posedge <= 0;
        end
        else begin
            level1_dly         <= level1;
            registered_posedge <= posedge_detect;
        end
    end

    // positive edge detection logic with reset suppression
    assign posedge_detect = (level1 & ~level1_dly) & rst_n;
    // registering the positive edge detection to last one full clock cycle
    assign one_shot = registered_posedge;
    
endmodule
