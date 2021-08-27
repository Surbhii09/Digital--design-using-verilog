//REGISTER FILE

module regfile(srd1, srd2, sr1, sr2, dr,regw, clk, wd); input [4:0] sr1, sr2, dr;
input [31:0] wd;
output reg [31:0] srd1, srd2; reg [31:0] regbank [0:31]; input clk, regw;
integer i; initial begin
for (i=0;i<32;i=i+1) begin
regbank [i]<=32'd0; end
end
always @ (*) begin
if (regw) begin
regbank [dr]<=wd; end
srd1<= regbank[sr1]; srd2<= regbank[sr2]; end
endmodule

//INSTRUCTION MEMORY:

module instrmem (pc, instruction); input [31:0] pc;
output reg [31:0] instruction; reg [31:0] regbank [0:63]; initial
begin
///32 bit instructions regbank[0]<=32'b001000_00011_00001_0000000000000001;
//load $1,1($3) regbank[1]<=32'b001000_00100_00110_0000000000000011;
 
//load $6,3($4) regbank[2]<=32'b000000_00001_00110_00101_00000_00000;
// add $5,$1,$6 regbank[3]<=32'b001000_00010_01000_0000000000000111;
//load $8, 7($2) regbank[4]<=32'b001010_00101_01000_0000000000001001;
//beq $5,$8,9 regbank[8]<=32'b001000_00111_01001_0000000000000101;
//load $9, 5($7) regbank[9]<=32'b001011_00000000000000000000001101;
//jmp 13
regbank[12]<=32'b001000_00111_01010_0000000000000101;
//load $10, 5($7) end
always @ (pc) begin
instruction=regbank[pc[5:0]]; end
endmodule
//DATA MEMORY:
module datamem (readdata, writedata, memread,memwrite, address, clk); input memwrite, memread, clk;
input [31:0] address;
input [31:0] writedata; output reg [31:0] readdata; integer i;
reg [31:0] regbank [0:63]; always @ (*)
begin if(memwrite) begin
regbank[address[5:0]]<=writedata; end
end
always @ (*) begin if(memread)
begin readdata<=regbank[address[5:0]]; end
 
end initial begin
for(i=0;i<64;i=i+1) begin
if(i==1) regbank[i]<=32'd6; else if(i==3) regbank[i]<=32'd10; else if (i==7) regbank[i]<=16; else if (i==5) regbank[i]<=32'd12; else
regbank[i]<=32'd0; end
end endmodule

//ALU UNIT:
module alu(alu_r, alu_a, alu_b, aluout); input [2:0] aluout;
input [31:0] alu_a, alu_b; output reg [31:0] alu_r; reg jr;
always @ (*) begin case(aluout)
0:alu_r<=alu_a+alu_b; 1:alu_r<=alu_a-alu_b; 2:alu_r<=alu_a&alu_b; 3:alu_r<=alu_a|alu_b; 4:begin if(alu_a==alu_b)
alu_r<=32'd0; else
alu_r<=32'd1; end
5:jr<=1;
default:alu_r<=32'b0;
 
endcase end
endmodule

//ALU CONTROL UNIT:
module alucontrolunit (aluout, aluop, fcode); input [2:0] aluop;
output reg [2:0] aluout; input [5:0] fcode;
wire [8:0] operation;
assign operation={aluop, fcode}; always @ (*)
begin casex(operation)
9'b000000000: aluout<=0; //add 9'b000000001: aluout<=1; //sub 9'b000000010: aluout<=2; //and 9'b000000011: aluout<=3; //or 9'b001xxxxxx: aluout<=0; //addi 9'b010xxxxxx: aluout<=1; //subi 9'b100xxxxxx: aluout<=2; //andi 9'b101xxxxxx: aluout<=3; //ori 9'b110xxxxxx: aluout<=4; //beq 9'b011xxxxxx: aluout<=0; //load\ 9'b011xxxxxx: aluout<=0; //store 9'b111xxxxxx: aluout<=5; //jump endcase
end endmodule

//CONTROL UNIT:
module controlunit (regdst, memread, memwrite,
aluop, regorimm, aluormem, regw, jump, branch, opcode, rst); input [5:0] opcode;
input rst;
output reg [2:0] aluop;
output reg regdst, memread, memwrite, regorimm, aluormem, regw, branch, jump;
always @ (*)
 
begin begin
case(opcode) 0:begin //add regdst<=1; memread<=0; memwrite<=0; regorimm<=0; aluormem<=0; regw<=1; aluop<=3'b000; jump<=0; branch<=0; end
1:begin //sub regdst<=1; memread<=0; memwrite<=0; regorimm<=0; aluormem<=0; regw<=1; aluop<=3'b000; jump<=0; branch<=0;
end
2:begin //and regdst<=1; memread<=0; memwrite<=0; regorimm<=0; aluormem<=0; regw<=1; aluop<=3'b000; jump<=0; branch<=0;
end 3:begin //or
regdst<=1; memread<=0; memwrite<=0;
 
regorimm<=0; aluormem<=0; regw<=1; aluop<=3'b000; jump<=0; branch<=0;
end
4:begin //addi regdst<=0; memread<=0; memwrite<=0; regorimm<=1; aluormem<=0; regw<=1; aluop<=3'b001; jump<=0; branch<=0;
end
5:begin //subi regdst<=0; memread<=0; memwrite<=0; regorimm<=1; aluormem<=0; regw<=1; aluop<=3'b010; jump<=0; branch<=0;
end
6:begin //andi regdst<=0; memread<=0; memwrite<=0; regorimm<=1; aluormem<=0; regw<=1; aluop<=3'b100; jump<=0; branch<=0;
end
 
7:begin //ori regdst<=0; memread<=0; memwrite<=0; regorimm<=1; aluormem<=0; regw<=1; aluop<=3'b101; jump<=0; branch<=0;
end
8:begin //load regdst<=0; memread<=1; memwrite<=0; regorimm<=1; aluormem<=1; regw<=1; aluop<=3'b011; jump<=0; branch<=0;
end
9:begin //store regdst<=0; memread<=0; memwrite<=1; regorimm<=1; aluormem<=1; regw<=0; aluop<=3'b011; jump<=0; branch<=0;
end
10:begin //beq regdst<=0; memread<=0; memwrite<=0; regorimm<=0; aluormem<=0; regw<=0;
 
aluop<=3'b110; branch<=1; jump<=0;
end
11:begin //jump regdst<=0; memread<=0; memwrite<=0; regorimm<=0; aluormem<=0; regw<=0; aluop<=3'b111; jump<=1;branch<=0;

end endcase end
end endmodule

//TOP MODULE:
//PROCESSOR CORE:
module processor (clk, rst, aluresult); input clk, rst;
output [31:0] aluresult;
reg [31:0] pc;
wire [31:0] npc;
wire [31:0] srd1, srd2, wd, instruction; wire [4:0] sr1, sr2, dr1;
wire [31:0] readdata;
wire [31:0] alu_a, alu_b1, alu_r, imm; wire [2:0] aluout;
wire regdst, memread, memwrite, regorimm, aluormem, regw, jump, branch;
wire [2:0] aluop;
reg [27:0] instructionjmp ; always @ (posedge clk) begin
if(rst)
 
begin pc<=0; end
else if (instruction[31:25]==6'd10 && alu_r==32'd0) begin
pc<=pc+1+imm; end
else if(instruction[31:25]==6'd11) begin
instructionjmp<={2'b0,instruction[25:0]}; pc<={4'b0,instructionjmp};
end else
begin pc<=pc+1; end
end
assign sr1=instruction[25:21]; assign sr2=instruction[20:16];
//modules instatiations
regfile r(srd1, srd2, sr1, sr2, dr1, regw, clk, wd);
datamem dm(readdata, srd2, memread, memwrite, alu_r, clk);
 instrmem im(pc, instruction);
controlunit cu(regdst, memread, memwrite, aluop, regorimm, aluormem, regw, jump, branch, instruction[31:26], rst);
alucontrolunit alcu (aluout, aluop, instruction[5:0]);
 alu alunit(alu_r, srd1, alu_b1, aluout);
assign dr1= regdst? instruction[15:11]: sr2; assign alu_b1 = regorimm? imm: srd2;
assign imm=instruction[15]?{16'h1111, instruction[15:0]}:{16'h0000,
instruction[15:0]}; 
assign wd= aluormem? readdata: alu_r;
assign alu_result=alu_r; 
endmodule
