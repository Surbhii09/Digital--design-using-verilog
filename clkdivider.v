module dffdiv(clk,rst,Q);
  input clk,rst;
  output reg Q;
  always@(clk or rst)
    begin
      if(!rst)
        Q<=1'b0;
      else if(clk)
        Q<=~Q;
    end
endmodule

