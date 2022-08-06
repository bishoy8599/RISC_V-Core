`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2022 01:24:34 PM
// Design Name: 
// Module Name: n_shift_left
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


module n_shift_left #(parameter n = 8)(
    input [n-1:0]in,
    output  [n-1:0]out 
    );
    assign out = {in[n-1],in[n-3:0],1'b0};
endmodule
