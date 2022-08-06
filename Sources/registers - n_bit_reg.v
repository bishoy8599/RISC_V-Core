`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2022 12:29:38 PM
// Design Name: 
// Module Name: n_bit_reg
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


module n_bit_reg #(parameter n=32)(
    input [n-1:0] d,
    input clk,
    input rst,
    input load,
    output wire [n-1:0] q
    );
    genvar j;
    wire [n-1:0] temp;
    generate
    for(j = 0; j < n; j = j+1)
    begin: Gen_Modules
    assign temp[j] = load ? d[j] : q[j];    
    one_bit_FF my_reg(
        .D(temp[j]),
        .rst(rst),
        .clk(clk),
        .Q(q[j])
        );
    end
    endgenerate
endmodule
