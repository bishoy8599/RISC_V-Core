`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/01/2022 12:21:05 PM
// Design Name: 
// Module Name: ALU
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module ALU #(parameter n=32)(
    input [n-1:0] A,
    input [n-1:0] B,
    input [3:0] sel,
    output reg [n-1:0] out,
    output reg zerof
    );  
 wire [n-1:0] summer_out;
 wire  winter_out;

RCA_nbit #(n) x(
        .A(A),
        .B((sel[2])? ((~B)+1):B),
        .Cout(winter_out),
        .Sum(summer_out)
        );
always@(*) begin
case(sel)
4'b0010: out = summer_out;
4'b0110: out = summer_out;
4'b0000: out = A & B;
4'b0001: out = A | B;
default: out = 0;
endcase

if(out==0) zerof = 1;
else zerof=0;
end 
endmodule
