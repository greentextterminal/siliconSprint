/*
Enable is positive edge detected
Active low: 0 is high, 1 is low

capture the input when the enable goes from low to high
*/

module edge_capture(
    input  clk,
    input  rst_n,
    input  enable,
    input  [7:0] in,
    output [7:0] q
);
    // wires
    wire enable_posedge_detected;
    
    // reg
    reg enable_dly;
    reg [7:0] registered_data;

    // delay registers
    always @ (posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            enable_dly <= 1'b0;
            registered_data <= 8'b0;
        end
        else begin
            enable_dly <= enable;
            if (enable_posedge_detected) begin
                registered_data <= in;
            end
            else begin
                registered_data <= registered_data;
            end
        end
    end

    // detecting posedge of enable signal
    assign enable_posedge_detected = (enable & ~enable_dly) & rst_n;

    // drive output with registered data
    assign q = registered_data;
endmodule
