/*
The transmitter should send an 8‑bit data byte with 1 start bit, 8 data bits (LSB first), no parity, and 1 stop bit. 
The module receives a system clock, an active‑high reset, a data_in (8‑bit), and a tx_start signal. 
On a rising edge of tx_start, the transmitter should begin sending the start bit, then the 8 data bits, and finally the stop bit, outputting one bit per clock cycle. 
When the frame is finished, the module should raise a tx_done flag to indicate completion. 
This problem focuses on shift‑register logic and state sequencing without worrying about baud‑rate timing.

               ________________________________________________________________________
Clock Cycles   |  CC 10   | CC9 | CC8 | CC7 | CC6 | CC5 | CC4 | CC3 | CC2 |    CC1    |
               |__________|_______________________________________________|___________|
Bit Definition | Stop Bit | <MSB----------------DATA-----------------LSB> | Start Bit |
               |   1'b1   |                                               |    1'b0   |

Assumptions:
- synchronous reset
*/

module top(
    input  clk,
    input  rst_n,         // assume the reset is synchronous (reset is active high despite _n in name)
    input  tx_start,
    input  [7:0] data_in,
    output tx,            // this is the bit output of the data frame: {stop_bit, data_in, start_bit}
    output tx_done        // done flag
);
    // regs
    reg [1:0] next_state;
    reg [1:0] current_state;
    reg [2:0] bit_count;       // holds count 0 to 7
    reg [7:0] shift_reg;       // 8 bit shift register
    reg       tx_reg;          // creating reg to prodedurally drive tx output

    // localparams
    localparam [1:0] IDLE       = 2'd0,
                     SEND_START = 2'd1,
                     SEND_DATA  = 2'd2,
                     SEND_STOP  = 2'd3;

    // compile time constatnt (clock cycle counts 8, but - 1 to account for starting from 0)
    localparam CLOCK_CYCLE_COUNT = 3'd7;

    // current_state transition logic
    always @ (posedge clk) begin
        if (rst_n) begin
            current_state <= IDLE;
        end
        else begin
            current_state <= next_state;
        end
    end

    // next_state transition logic
    always @ (*) begin
        // default next_state assignment to prevent latching
        next_state = IDLE;
        case (current_state) 
            IDLE: begin
                if (~tx_start) begin
                    next_state = SEND_START;
                end
            end
            SEND_START: begin
                // transition to DATA state by next clock cycle
                next_state = SEND_DATA;
            end
            SEND_DATA: begin
                // move to STOP state once counter counts 8 clock cycles
                if (bit_count == CLOCK_CYCLE_COUNT) begin
                    next_state = SEND_STOP;
                end
                // stay in DATA state until counter hits
                else begin
                    next_state = SEND_DATA;
                end
            end
            SEND_STOP: begin
                // move into new by state in next clock cycle
                if (~tx_start) begin
                    next_state = SEND_DATA;
                end
                else begin
                    next_state = IDLE;
                end
            end
            default: begin
                next_state = IDLE;
            end
        endcase
    end
    
    // creating the 8 clock cycle counter
    always @ (posedge clk) begin
        // reset condition
        if (rst_n) begin
            bit_count <= 3'b0;
        end
        else if (current_state == SEND_DATA) begin
            // reset the count if 8 clock cycles passed (count == 7)
            if (bit_count == CLOCK_CYCLE_COUNT) begin
                bit_count <= 3'b0;
            end
            // increment the counter
            else begin
                bit_count <= bit_count + 1'b1;
            end
        end
        // clear the count once outside of DATA state
        else begin
            bit_count <= 3'b0;
        end
    end

    // creating the shift register for the UART data frame
    always @ (posedge clk) begin
        if (rst_n) begin
            shift_reg <= 0;
        end
        // IDLE
        else if (current_state == IDLE) begin
            if (tx_start) begin
                shift_reg <= data_in;
            end
            // if ~tx_start
            else begin
                shift_reg <= {1'b0, shift_reg[7:1]};
            end
        end
        // START: start bit is 0
        else if ((current_state == SEND_START) & tx_start) begin
            shift_reg <= data_in;
        end
        //!!!!!!
        // DATA: data_in
        else if (next_state == SEND_DATA) begin
            shift_reg <= {data_in[bit_count], shift_reg[9:1]};
        end
        // STOP: stop bit is 1
        else if (next_state == SEND_STOP) begin
            shift_reg <= {1'b1, shift_reg[9:1]};
        end
        // hold the current frame
        else begin
            shift_reg <= shift_reg;
        end
    end

    // driving output
    assign tx_done = (current_state == SEND_STOP);

    // driving tx output
    always @ (*) begin
        // catch all "else" to prevent latches
        tx_reg = 1'b0;
        case (current_state)
            IDLE: begin
                tx_reg = 1'b1;
            end
            SEND_START: begin
                tx_reg = 1'b0;
            end
            SEND_DATA: begin
                tx_reg = shift_reg[0];
            end
            SEND_STOP: begin
                tx_reg = 1'b1;
            end
            default: begin
                tx_reg = 1'b0;
            end
        endcase
    end
    // driving tx with 
    assign tx = tx_reg;
  
endmodule
