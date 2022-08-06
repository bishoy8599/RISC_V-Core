`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/15/2022 12:30:35 PM
// Design Name: 
// Module Name: full_adder
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


module fulladder(
    input A,
    input B,
    input Cin,
    output Sum,
    output Cout
    );
    wire [1:0] temp;
    assign temp = A + B + Cin;
    assign Sum = temp[0];
    assign Cout = temp[1];
endmodule
