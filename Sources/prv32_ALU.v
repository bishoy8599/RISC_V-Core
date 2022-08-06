`timescale 1ns / 1ps
/*******************************************************************
*
* Module: prv32_ALU.v
* Project: RV32I
* Author:   Provided by the professor.
* Description: This module models the ALU of the processor
*
* Change history: 28/02/22 – Created
* 26/03/22 – extended to cover the whole 40 RISCV instructions
*
**********************************************************************/
`include"defines.v"

module prv32_ALU(
	input   wire [31:0] a, b,
	input   wire [4:0]  shamt,  //rs2[4:0]
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [4:0]  alufn
);

    wire [31:0] add, sub, op_b;
    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
    
    wire[31:0] sh;
    shifter shifter0(.a(a), .shamt(shamt), .type(alufn[1:0]),  .r(sh));
    
    
    reg [63:0] res;
    reg signed [31:0] a_signed;
    reg signed [31:0] b_signed;
    
    always @ * begin
        a_signed = a ;
        b_signed = b;
        r = 0;
        (* parallel_case *)
        case (alufn)
            // Multiplication
            `ALU_MUL: begin 
            res = a_signed * b_signed;
            r = res[31:0];
            end
            `ALU_MULH: begin 
            res = a_signed * b_signed;
            r = res[63:32];
            end
            `ALU_MULHSU: begin 
            res = a_signed * b;
            r = res[63:32];
            end
            `ALU_MULHU: begin 
            res = a * b;
            r = res[63:32];
            end
            // Division
            `ALU_DIV: r = a_signed / b_signed;
            `ALU_DIVU: r = a / b;
            `ALU_REM: r = a_signed % b_signed;
            `ALU_REMU: r = a % b;                         
            // arithmetic
            5'b000_00 : r = add;
            5'b000_01 : r = add;
            5'b000_11 : r = b;
            // logic
            5'b001_00:  r = a | b;
            5'b001_01:  r = a & b;
            5'b001_11:  r = a ^ b;
            // shift
            5'b010_00:  r=sh; //srl
            5'b010_01:  r=sh; //sll
            5'b010_10:  r=sh; //sra
            // slt & sltu
            5'b011_01:  r = {31'b0,(sf != vf)}; //slt
            5'b011_11:  r = {31'b0,(~cf)};   //sltu           	
        endcase
    end
endmodule