module dff_logic(d,clk,reset,q,qbar);
input d,clk,reset;
output qbar;
output reg q;

always @(posedge clk)
 begin
     if (reset)
	 q=0;
	 else
	
     q=d;	 
 end	 
 
 
 assign qbar=~q;
 
endmodule