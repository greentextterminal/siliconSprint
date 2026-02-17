/*
Design a simple 2-state Finite State Machine (FSM) in Verilog. 
The FSM has two states: IDLE and ACTIVE. The FSM starts in the IDLE state. 
When the input signal 'go' is high, the FSM transitions to the ACTIVE state. 
When 'go' is low, it transitions back to the IDLE state. 
An output signal 'state' should indicate the current state: 0 for IDLE and 1 for ACTIVE.
*/

module top(
  input go,
  output state
);
  // creating the reg for procedural assignments
  reg current_state;

  // creating state params
  localparam IDLE=0, ACTIVE=1; // states
  localparam LOW=0, HIGH=1;

  // always combo block to handle state and output logic
  always @ (*) begin
    case (go)
      LOW: begin
        current_state = IDLE;
      end
      HIGH: begin
        current_state = ACTIVE;
      end
    endcase
  end

  // driving the output with our reg (current_state)
  assign state = current_state;
endmodule
