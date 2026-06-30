module edge_capture(
  input clk,
  input rst_n,
  input enable,
  input [7:0] in,
  output [7:0] q
);
  // creating regs
  reg [7:0] buffer;
  reg enable_dly;

  // creating positive edge detector for enable
  always @ (posedge clk) begin
    if (~rst_n)
      enable_dly <= 1'b0;
    else 
      enable_dly <= enable;
  end

  // rising edge detection logic for enable signal
  assign enable_rising_edge = enable & ~ enable_dly;

  // creating the enable based logic for registering, holding, or reregistering the data
  always @ (posedge clk or posedge rst_n) begin
    if (~rst_n)
      buffer <= 8'b0;
    else begin
      if (enable_rising_edge)
        buffer <= in;
      else
        buffer <= buffer;
    end
  end

  // driving output with data
  assign q = buffer;
endmodule
