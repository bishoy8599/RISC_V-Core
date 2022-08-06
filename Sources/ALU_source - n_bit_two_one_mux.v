`timescale 1ns / 1ps
/*******************************************************************
*
* Module: n_bit_two_one_mux.v
* Project: RV32I
* Author:   Omar Elayat - omar_elayat@aucegypt.edu
*           Bishoy Sabry - bishoy8599@aucegypt.edu
* Description: This module models a 2x1 n-bit wide mux
*
* Change history: 22/02/22 – Created
*
**********************************************************************/


module n_bit_two_one_mux #(parameter n =8)(
    input [n-1:0]a,
    input [n-1:0]b,
    input sel,
    output [n-1:0] q
    );
    genvar j;
    generate
    for(j = 0; j < n; j = j+1)
    begin: Gen_Modules
    two_one_mux my_mux(
        .a(a[j]),
        .b(b[j]),
        .sel(sel),
         .out(q[j])
        );
    end
    endgenerate
endmodule
