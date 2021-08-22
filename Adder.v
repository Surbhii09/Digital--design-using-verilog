module Adder(A,B,CIN,SUM,COUT);
input [3:0]A,B;
input CIN;
output wire [3:0]SUM;
output COUT;
FullAdder FA1(A[0],B[0],CIN,SUM[0],COUT1);
FullAdder FA2(A[1],B[1],COUT1,SUM[1],COUT2);
FullAdder FA3(A[2],B[2],COUT2,SUM[2],COUT3);
FullAdder FA4(A[3],B[3],COUT3,SUM[3],COUT);
endmodule

module FullAdder(A,B,CIN,SUM,COUT);
input A,B,CIN;
output wire SUM,COUT;
wire s1,c1,c2,c3;
xor(s1,A,B);
xor(SUM,s1,CIN);
and(c1,A,B);
and(c2,B,CIN);
and(c3,A,CIN);
or(COUT,c1,c2,c3);
endmodule