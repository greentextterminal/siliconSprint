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
    output tx,            // assume this is the bit output of captured data from data_in
    output tx_done
);
    // wires

    // regs
    reg [1:0] next_state;
    reg [1:0] current_state;
    reg [7:0] shift_reg;
    reg [7:0] count;
    reg       data_bit;

    // localparams
    localparam [1:0] IDLE  = 2'd0,
                     START = 2'd1,
                     DATA  = 2'd2,
                     STOP  = 2'd3;

    // compile time constatnt
    localparam integer DATA_LENGTH = 8;

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
                if (tx_start) begin
                    next_state = START;
                end
            end
            START: begin
                // transition to DATA state by next clock cycle
                next_state = DATA;
            end
            DATA: begin
                if (count == (DATA_LENGTH - 1)) begin
                    next_state = STOP;
                end
            end
            STOP: begin
                // move into new by state in next clock cycle
                if (tx_start) begin
                    next_state = START;
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
    
    // creating the 8 clock cycle counter and handling the shift register logic
    always @ (posedge clk) begin
        // reset condition
        if (rst_n) begin
            count     <= 0;
            shift_reg <= 0;
            data_bit  <= 0;
        end
        // reset the count if 8 clock cycles passed
        else if (count == (DATA_LENGTH - 1)) begin
            count     <= 0;
            shift_reg <= 0;
            data_bit  <= 0;
        end
        // enable if the next_state is DATA (to begin capturing the data as state transitions fro START to DATA)
        else if (next_state == DATA) begin
            count <= count + 1;
            // capturing data into shift register (using the count as in index into data_in)
            shift_reg <= {data_in[count], shift_reg[7:1]}; 
            // loading the data bit register to output the captured bit
            data_bit <= data_in[count];
        end
        else begin
            count     <= 0;
            shift_reg <= 0;
            data_bit  <= 0;
        end
    end

    // driving outputs
    assign tx_done = (current_state == STOP) ? 1 : 0;
    assign tx      = data_bit;
  
endmodule
