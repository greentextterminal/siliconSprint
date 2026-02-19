/*
Design a SystemVerilog module named top that implements a basic 4‑port Network‑on‑Chip (NoC) router. 
The router has four bidirectional data ports (North, South, East, West). 
Each port receives a 16‑bit data word and a 2‑bit destination address on the same cycle. 
The destination address uses the following encoding: 00 → North, 01 → South, 10 → East, 11 → West. 
The router must forward the incoming packet to the correct output port while preserving the data value. 
In case multiple packets arrive simultaneously, the router services them in a deterministic order: North first, then South, East, and West (first‑come, first‑served). 
The module should be fully combinational with no clock or storage elements.
*/

module top(
  input   [15:0] north_data,  input  [1:0] north_dest,
  input   [15:0] south_data,  input  [1:0] south_dest,
  input   [15:0] east_data,   input  [1:0] east_dest,
  input   [15:0] west_data,   input  [1:0] west_dest,
  output  [15:0] north_out,  output  north_valid,
  output  [15:0] south_out,  output  south_valid,
  output  [15:0] east_out,   output  east_valid,
  output  [15:0] west_out,   output  west_valid
);

  // priority servicing: north, south, east, and west
  // first come first serve

  localparam NORTH = 0; // 00
  localparam SOUTH = 1; // 01
  localparam EAST  = 2; // 10
  localparam WEST  = 3; // 11

  // creating reg component for procedural assignment
  reg [15:0] north_target, south_target, east_target, west_target;
  reg n_v, s_v, e_v, w_v;

  // creating priority ordered case statements
  always @ (*) begin
    // north source
    case (north_dest)
      NORTH: begin
        north_target = north_data;
        n_v = 1;
      end
      SOUTH: begin
        south_target = north_data;
        n_v = 1;
      end
      EAST:  begin
        east_target  = north_data;
        n_v = 1;
      end
      WEST:  begin
        west_target  = north_data;
        n_v = 1;
      end
      default: n_v = 0;
    endcase

    // south source
    case (south_dest)
      NORTH: begin
        north_target = south_data;
        s_v = 1;
      end
      SOUTH: begin
        south_target = south_data;
        s_v = 1;
      end
      EAST:  begin
        east_target  = south_data;
        s_v = 1;
      end
      WEST:  begin
        west_target  = south_data;
        s_v = 1;
      end
      default: s_v = 0;
    endcase

    // east source
    case (east_dest)
      NORTH: begin
        north_target = east_data;
        e_v = 1;
      end
      SOUTH: begin
        south_target = east_data;
        e_v = 1;
      end
      EAST:  begin
        east_target  = east_data;
        e_v = 1;
      end
      WEST:  begin
        west_target  = east_data;
        e_v = 1;
      end
      default: e_v = 0;
    endcase

    // west source
    case (west_dest)
      NORTH: begin
        north_target = west_data;
        w_v = 1;
      end
      SOUTH: begin
        south_target = west_data;
        w_v = 1;
      end
      EAST:  begin
        east_target  = west_data;
        w_v = 1;
      end
      WEST:  begin
        west_target  = west_data;
        w_v = 1;
      end
      default: w_v = 0;
    endcase
  end

  // driving the outputs
  assign north_out = north_target;
  assign south_out = south_target;
  assign east_out  = east_target;
  assign west_out  = west_target;

  assign north_valid = n_v;
  assign south_valid = s_v;
  assign east_valid  = e_v;
  assign west_valid  = w_v;
endmodule
