`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Branch_control.v
* Project: RV32I
* Author:   Omar Elayat - omar_elayat@aucegypt.edu
*           Bishoy Sabry - bishoy8599@aucegypt.edu
* Description: This module models the branch control units which control the B-type instructions execution
*
* Change history: 26/03/22 – Created
*
**********************************************************************/

`include"defines.v"

module Branch_control(
    input branch, zf, cf, sf, vf,
    input [2:0] funct3,
    output reg b_ctrl_out
    );
    always@(*)begin
    case(funct3)
    `BR_BEQ: b_ctrl_out = branch & zf;   //beq
    `BR_BNE: b_ctrl_out = branch & (~zf); //bne
    `BR_BLT: b_ctrl_out = branch & (sf != vf); //blt
    `BR_BGE: b_ctrl_out = branch & (sf == vf); //bge
    `BR_BLTU: b_ctrl_out = branch & (~cf); //bltu
    `BR_BGEU: b_ctrl_out = branch & cf; //bgeu
    default: b_ctrl_out = 0;
    endcase
    end
endmodule
