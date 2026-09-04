/*
Design a sequence detector to detect the sequence '101'.

4 states IDLE, S1, S10, S101

[combo logic] -> [next state] -> [state]
        ^___________________________|
*/

module top(
    input  in,
    input  clk,
    input  rst,
    output out
);    
    // FSM state registers
    reg [1:0] state, next_state;
    
     // defining states
    localparam [1:0] IDLE = 2'd0,
                     S1   = 2'd1,
                     S10  = 2'd2,
                     S101 = 2'd3;

    // state control block
    always @ (posedge clk) begin
        if (rst) begin
            state <= IDLE;
        end
        else begin
            state <= next_state;
        end
    end

    // next state control block
    always @ (*) begin
        // prevents latches by providing this FSM with a blanket "else" condition
        next_state = IDLE;
        case (state)
            IDLE: begin
                if (in) begin
                    next_state = S1;
                end
            end
            S1: begin
                if (~in) begin
                    next_state = S10;
                end
            end
            S10: begin
                if (in) begin
                    next_state = S101;
                end
            end
            S101: begin
                if (in) begin
                    next_state = S1;
                end
                else begin
                    next_state = S10;
                end
            end
            default: next_state = IDLE;
        endcase
    end

    // sequence detection output control
    assign out = (state == S101) ? 1 : 0;

endmodule
