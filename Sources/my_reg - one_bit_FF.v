`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2022 12:05:52 PM
// Design Name: 
// Module Name: one_bit_FF
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


module one_bit_FF(
    input D,
    input rst,
    input clk,
    output reg Q
    );
    always @(posedge clk or posedge rst) begin
    if(rst) begin
    Q <= 1'b0;
    end 
    else begin
    Q <= D;
    
    end
    end
endmodule
