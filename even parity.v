module even_parity_generator_behavioural( bin , pe);
    input [2:0]bin;
    output reg pe;
            
    always@(bin)
        begin
            case(bin)
               3'b000 : pe = 0;
               3'b001 : pe = 1;
               3'b010 : pe = 1;
               3'b011 : pe = 0;
               3'b100 : pe = 1;
               3'b101 : pe = 0;
               3'b110 : pe = 0;
               3'b111 : pe = 1;
            endcase
        end
            
endmodule