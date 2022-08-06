`timescale 1ns / 1ps
/*******************************************************************
*
* Module: RCA_nbit.v
* Project: RV32I
* Author:   Omar Elayat - omar_elayat@aucegypt.edu
*           Bishoy Sabry - bishoy8599@aucegypt.edu
* Description: This module models an n-bit ripple carry adder as an array of 1-bit fulladders
*
* Change history: 25/02/22 – Created
*
**********************************************************************/

module RCA_nbit #(parameter n=32)(
    input [n-1:0] A,
    input [n-1:0] B,
    output wire Cout,
    output wire [n-1:0] Sum
    );
   wire Cin_vector[n:0];
assign Cin_vector[0] = 0;

       genvar j;
    generate
    for(j = 0; j < n; j = j+1)
    begin: Gen_Modules
    fulladder adder1(
            .A(A[j]),
            .B(B[j]),
            .Cin(Cin_vector[j]),
            .Sum(Sum[j]),
            .Cout(Cin_vector[j+1])
            );
    end
    assign Cout = Cin_vector[n];
    endgenerate

endmodule
