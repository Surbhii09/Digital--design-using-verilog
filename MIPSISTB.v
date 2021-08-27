module tb; 
reg clk; 
reg rst;
 
wire [31:0] aluresult; processor uut (
.clk(clk),
.rst(rst),

.aluresult(aluresult)
);
initial begin clk = 0;
rst = 1;
#100;
rst=0;
 end
always #10 clk=~clk; 
endmodule

