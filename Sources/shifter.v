`timescale 1ns / 1ps
/*******************************************************************
*
* Module: shifter.v
* Project: RV32I
* Author:   Omar Elayat - omar_elayat@aucegypt.edu
*           Bishoy Sabry - bishoy8599@aucegypt.edu
* Description: This module models the shifer block in the ALU
*
* Change history: 26/03/22 – Created
*
**********************************************************************/

module shifter(
    input signed [31:0] a,
    input [4:0] shamt, 
    input [1:0] type,
    output reg [31:0] r
    );
    always @(*)begin
    case(type) 
    2'b00 : r = a >> shamt;
    2'b01 : r = a << shamt;
    2'b10 : r = a >>> shamt;
    default: r = a;
    endcase
    end
endmodule
