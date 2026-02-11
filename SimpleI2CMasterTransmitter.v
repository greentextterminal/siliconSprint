/*
Design a simple I2C Master Transmitter module in SystemVerilog. The module should be able to send a 7-bit address followed by an 8-bit data byte to an I2C slave device. 
The I2C protocol should be implemented with start, stop, and acknowledge bits. Assume a simple clock for synchronization.
*/

/*
I2C consists of 2 wires. They are set up in an open drain configuration.
The lines are pulled high by a pull up resistor. The devices can pull the line low.
SCL : Serial Clock (driven by master)
SDA : Serial Data (bidirectional data)

Start condition: SDA = 1 -> 0 while SCL = 1
                 (the master begins communication)

Address + R/W bit: 7 bit slave address + 1 bit (R/W)

Acknowledge: reciever pulls SDA low on the 9th clock
             if SDA stays high then NACK (no acknowledge)

Data transfer: sent in 8 bit data bytes + 1 ACK bit
                (repeats for as many bytes as needed)

Stop condition: SDA 0 -> 1 while SCL = 1
                (the master ends communication)

*/

module top(
  input logic clk,
  input logic [6:0] address, // 7 bit address + R/W bit
  input logic [7:0] data,    // 8 bits of data, the 9th CC will be followed by either an ACK or NACK
  output logic sda,          // bidirectional
  output logic scl           // master -> slave
);
  
  always @ (posedge clk) begin
    
  end
  
endmodule
