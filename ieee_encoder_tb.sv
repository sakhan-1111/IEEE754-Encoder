///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//	EE 5320 Final Project
//	Shafiqul Alam Khan
//	Due Date: 12/04/23
//	Objectives:
//	> Testbench code for converting binary real number to IEEE format in single precision.
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Create module name
module ieee_encoder_tb();
  reg [35:0] fp_tb;
  reg clk_tb;
  reg rst_tb;
  reg enable_tb;
  reg correct;
  
  wire [31:0] sp_ieee_out;
  wire [1:0] state_out;
  
// Instantiate the ieee encoder
  ieee_encoder dut(
    .rst(rst_tb),
    .clk(clk_tb),
    .enable(enable_tb),
    .fp(fp_tb),
    .sp_ieee(sp_ieee_out),
    .state(state_out));
  
// Set initial values and dump variables
  initial begin
    $dumpfile("dump.vcd");
    $dumpvars(1,ieee_encoder);
    rst_tb = 1;
    clk_tb = 0;
    enable_tb = 0;
    correct = 0;
    
    forever #15 clk_tb = ~clk_tb; // 30ns per cc
  end
  
// Set up code run time
  initial #700ns $finish;
  
// Test
// Give input for test
  initial begin
    #30;
    rst_tb = 0;
    enable_tb = 1;
    fp_tb = {12'b0000_0000_0000, 24'b0011_0011_0000_0000_0000_0000};
    
// Check output of test
    #30;
    enable_tb = 0;
    while (state_out != 0) #15;
    if (sp_ieee_out == 32'h3E4C_0000) correct = 1;
  end
endmodule