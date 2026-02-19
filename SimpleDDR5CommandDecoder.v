/*
Design a simple DDR5 command decoder in SystemVerilog. 
The module should take a 3-bit command input and output the corresponding command name as a 2-bit binary code. 
The command decoder should recognize the following commands: 000 for 'NOP', 001 for 'READ', 010 for 'WRITE', and 011 for 'REFRESH'. 
Any other command input should default to 'NOP'.
*/

module top(
  input [2:0] command,
  output [1:0] command_name
);

  // creating params for commands
  localparam NOP     = 0; // 3'b000
  localparam READ    = 1; // 3'b001
  localparam WRITE   = 2; // 3'b010
  localparam REFRESH = 3; // 3'b011

  // reg var to hold the value of the decoded command name
  reg [1:0] decoded_command;
  
  always @ (*) begin
    case (command)
      NOP:     decoded_command = 2'b00;
      READ:    decoded_command = 2'b01;
      WRITE:   decoded_command = 2'b10;
      REFRESH: decoded_command = 2'b11;
      default: decoded_command = 2'b00;
    endcase
  end

  // drive the output with procedurally assigned decoded_command reg
  assign command_name = decoded_command;
  
endmodule
