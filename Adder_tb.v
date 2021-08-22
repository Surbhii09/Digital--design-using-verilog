module Adder_tb;

 // Inputs

  reg [3:0] A;

  reg [3:0] B;

 reg CIN;

 // Outputs

  wire [3:0] SUM;

 wire COUT;

 // Instantiate the Unit Under Test (UUT)

 Adder uut (

   .A(A), 

   .B(B), 

   .CIN(CIN), 

   .SUM(SUM), 

   .COUT(COUT)

                );

 initial begin
   // $dumpfile("dump.vcd");
  //$dumpvars;

  // Initialize Inputs

  A    = 4'b0;

  B    = 4'b0;

  CIN = 4'b0;

  // Wait 100 ns for global reset to finish

  #10;

  // Add stimulus here

  A    = 4'b0011;

  B    = 4'b1100;

  CIN  = 4'b0;

  #20;

    A  = 4'b1111;

 B   = 4'b1101;

  CIN  = 4'b1;
 #20;

    A  = 4'b1101;

 B   = 4'b1001;

  CIN  = 4'b1;

 #20;

    A = 4'b1001;

 B   = 4'b1111;

  CIN  = 4'b1;
 end

endmodule
