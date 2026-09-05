/*
Design a finite state machine (FSM) that detects a specific sequence '1011' on a single input bit stream.
The FSM should have an asynchronous reset and should output a high signal for one clock cycle when the sequence is detected.

Active low: 0 is high, 1 is low

[combo logic] -> [next state] -> [state]
     ^______________________________|
*/

module top(
    input  clk,
    input  rst_n,
    input  in_bit,
    output seq_detected
);
    // reg
    reg [2:0] current_state, next_state;
    
    // state parameters
    localparam [2:0] IDLE  = 3'd0,
                     S1    = 3'd1,
                     S10   = 3'd2,
                     S101  = 3'd3,
                     S1011 = 3'd4;

    // next state logic
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    // next state logic
    always @ (*) begin
        // this is the blanket else statement
        next_state = IDLE;
        case (current_state)
            IDLE: begin
                if (in_bit) begin
                    next_state = S1;
                end
            end
            S1: begin
                if (~in_bit) begin
                    next_state = S10;
                end
                else if (in_bit) begin
                    next_state = S1;
                end
            end
            S10: begin
                if (in_bit) begin
                    next_state = S101;
                end
            end
            S101: begin
                if (in_bit) begin
                    next_state = S1011;
                end
                else if (~in_bit) begin
                    next_state = S10;
                end
            end
            S1011: begin
                if (in_bit) begin
                    next_state = S1;
                end
                else if (~in_bit) begin
                    next_state = S10;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end

    // drive the output
    assign seq_detected = (current_state == S1011) ? 1 : 0;
    
endmodule
