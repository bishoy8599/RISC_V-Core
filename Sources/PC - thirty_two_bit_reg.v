`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Thirty_two_bit_reg.v
* Project: RV32I
* Author:   Omar Elayat - omar_elayat@aucegypt.edu
*           Bishoy Sabry - bishoy8599@aucegypt.edu
* Description: This module models a 32 bit register
* Change history: 12/03/22 – Created
*
**********************************************************************/

module thirty_two_bit_reg #(parameter n=8)(
    input [n-1:0] d,
    input clk,
    input rst,
    input load,
    output [n-1:0] q
    );
    
    wire[n-1:0] Ds;
    
    genvar j;
    generate
    for(j = 0; j <= n-1; j = j+1)
    begin: Gen_Modules
    one_bit_FF my_reg(
        .D(Ds[j]),
        .rst(rst),
        .clk(clk),
        .Q(q[j])
        );
    assign Ds[j] = (~load) ? q[j] : d[j];
    end
    endgenerate
    
endmodule
