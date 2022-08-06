`timescale 1ns / 1ps
/*******************************************************************
*
* Module: ALU_control_unit.v
* Project: RV32I
* Author:   Omar Elayat - omar_elayat@aucegypt.edu
*           Bishoy Sabry - bishoy8599@aucegypt.edu
* Description: This module models the alu control unit as a combinational circuit whose inputs come
* from the control unit and the 32-bit instruction itself
*
* Change history: 28/02/22 – Created
* 26/03/22 – extended to cover the whole 40 RISCV instructions
*
**********************************************************************/

`include"defines.v"


module ALU_control_unit(
    input instIM,
    input [2:0] Inst1,   //func3
    input [1:0] ALUOP,
    input Inst2,  //inst30
    input R_type,  //opcode[3]
    output reg [4:0] ALU_SEL
    );
    
always@(*)begin
if(instIM)begin
    case({ALUOP,Inst1})
    6'b10_000: ALU_SEL = `ALU_MUL;  
    6'b10_001: ALU_SEL = `ALU_MULH;  
    6'b10_010: ALU_SEL = `ALU_MULHSU;   
    6'b10_011: ALU_SEL = `ALU_MULHU; 
    6'b10_100: ALU_SEL = `ALU_DIV;  
    6'b10_101: ALU_SEL = `ALU_DIVU;  
    6'b10_110: ALU_SEL = `ALU_REM;  
    6'b10_111: ALU_SEL = `ALU_REMU;  
    default: ALU_SEL = 5'b00000;
    endcase 
end
else begin
casex({ALUOP,Inst1,Inst2})
6'b00_xxx_x: ALU_SEL = `ALU_ADD;  //add
6'b01_xxx_x: ALU_SEL = `ALU_SUB;  //sub
6'b10_000_0: ALU_SEL = `ALU_ADD;  //add
6'b10_000_1: begin               //sub
if(R_type) ALU_SEL = `ALU_SUB;
else ALU_SEL = `ALU_ADD;
end
6'b10_111_x: ALU_SEL = `ALU_AND;  //and
6'b10_110_x: ALU_SEL = `ALU_OR;  //or
6'b10_001_0: ALU_SEL = `ALU_SLL;  //sll 
6'b10_010_x: ALU_SEL = `ALU_SLT;  //slt
6'b10_011_x: ALU_SEL = `ALU_SLTU;  //sltu
6'b10_100_x: ALU_SEL = `ALU_XOR;  //xor
6'b10_101_0: ALU_SEL = `ALU_SRL;  //srl 
6'b10_101_1: ALU_SEL = `ALU_SRA;  //sra 
default: ALU_SEL = 5'b00000;
endcase
end
end
endmodule
