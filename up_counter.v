module up_counter(clk,clr, out);
input clk,clr;
output [3:0]out;

reg [3:0] count;
always@(negedge clk or)
begin
    if(clr==1)
	    
		  count<=count+4'b0001;
		  
		  else if(clr==0) 
		  count<=4'b0;
		  
		  end
		  assign out=count;
		  endmodule