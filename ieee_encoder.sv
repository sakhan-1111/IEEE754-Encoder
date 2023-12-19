///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	EE 5320 Final Project
//	Shafiqul Alam Khan
//	Due Date: 12/04/23
//	Objectives:
//	> Convert binary real number to IEEE format in single precision.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Create module name
module ieee_encoder(
  input wire rst,
  input wire clk,
  input wire enable,
  input wire [35:0] fp,
  output reg [31:0] sp_ieee,
  output reg [1:0] state);
  
// Define resistors
  reg [35:0] reg_shift;
  reg [7:0] reg_exp;
  reg [7:0] reg_counter;
  reg [1:0] reg_state;
  
// Set up the outputs
  always @ (posedge clk) begin
    sp_ieee = {1'b0, reg_exp, reg_shift[35:13]};
//  This is IEEE 754 output. The sign is set to 0, sign is not considered here, next 8 bit is exponent, next 23 bits are mantissa.
    state = reg_state;
//  State 0 = busy and 1 = Done.
  end
  
// Take integer to locate MSB in FP
  integer f;
  
// Define states
  parameter IDLE = 2'd0;
  parameter EXP = 2'd1;
  parameter MANTISSA = 2'd2;
  
// Set up reset
// Here for rest pin = 1, set state, counter & exponent resitors to 0
  always @ (*) begin
    if(rst == 1'b1) begin
      reg_state <= 2'b0;
      reg_counter <= 8'b0;
      reg_exp <= 8'b0;
    end
  end
  
// FP Encoding happens here
  always @ (posedge clk) begin
    if (rst == 1'b0)begin
      case (reg_state)
        IDLE: begin
          if (enable == 1'b1) begin
            reg_shift <= fp;
            reg_state <= EXP;
          end
          else begin
            reg_state <= IDLE;
          end
        end
        EXP: begin
          for(f=0; f<35; f=f+1) begin
            if (reg_shift[f] == 1'b1) begin
              reg_counter <= 35 - f;
              reg_exp <= f + 103;
            end
          end
          reg_state <= MANTISSA;
        end
        MANTISSA: begin
          reg_shift <= reg_shift << 1;
          reg_counter <= reg_counter - 1;
          reg_state <= (reg_counter == 0) ? IDLE : MANTISSA ;
        end
        default: begin
          reg_state <= 2'd3;
        end
        endcase
    end
  end
  endmodule