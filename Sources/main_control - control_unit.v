`timescale 1ns / 1ps
/*******************************************************************
*
* Module: control_unit.v
* Project: RV32I
* Author:   Omar Elayat - omar_elayat@aucegypt.edu
*           Bishoy Sabry - bishoy8599@aucegypt.edu
* Description: This module models the main control unit as a combinational circuit whose inputs come
* from the 32-bit instruction itself
*
* Change history: 01/03/22 – Created
* 26/03/22 – extended to cover the whole 40 RISCV instructions
*
**********************************************************************/

`include "defines.v"


module control_unit(
    input [31:0] IR,
    output reg Branch,
    output reg [2:0]MemRead,
    output reg MemtoReg,
    output reg [1:0] ALUOP,
    output reg [1:0]MemWrite,
    output reg ALUSrc,
    output reg RegWrite,
    output reg jal,
    output reg PCtoReg,
    output reg ALU_JALR_sel,
    output reg auipc_sel,
    output reg lui_sel,
    output reg break_fn,
    output reg sys_stall_fn
    );

initial break_fn =1'b0;
always@(*)begin
//if(`Extesnion == `compressed)begin
    
//end
//else begin
case(`OPCODE)
`OPCODE_Arith_R: begin
    Branch = 1'b0;
    jal = 1'b0;
    PCtoReg = 1'b0;
    MemRead= 3'b000;
    MemtoReg= 1'b0;
    ALUOP = 2'b10;
    MemWrite= 2'b00;
    ALUSrc= 1'b0;
    RegWrite= 1'b1;
    ALU_JALR_sel = 1'b0;
    lui_sel = 1'b0;
    auipc_sel = 1'b0;
    //break_fn = 1'b0;
    sys_stall_fn=1'b0;
end

`OPCODE_Arith_I: begin
    Branch = 1'b0;
    jal = 1'b0;
    PCtoReg = 1'b0;
    MemRead= 3'b000;
    MemtoReg= 1'b0;
    ALUOP = 2'b10;
    MemWrite= 2'b00;
    ALUSrc= 1'b1;
    RegWrite= 1'b1;
    ALU_JALR_sel = 1'b0;
    lui_sel = 1'b0;
    auipc_sel = 1'b0;
    //break_fn = 1'b0;
    sys_stall_fn=1'b0;
end

`OPCODE_Load: begin
    Branch = 1'b0;
    jal = 1'b0;
    PCtoReg = 1'b0;
    MemtoReg= 1'b1;
    ALUOP = 2'b00;
    MemWrite= 2'b00;
    ALUSrc= 1'b1;
    RegWrite= 1'b1;
    ALU_JALR_sel = 1'b0;
    lui_sel = 1'b0;
    auipc_sel = 1'b0;
    //break_fn = 1'b0;
    sys_stall_fn=1'b0;
    case(`F3)
        3'b000 : MemRead = 3'b101;
        3'b001 : MemRead = 3'b110;
        3'b010 : MemRead = 3'b111;
        3'b100 : MemRead = 3'b001;
        3'b101 : MemRead = 3'b010;
    endcase 

end
`OPCODE_Store: begin
    Branch = 1'b0;
    jal = 1'b0;
    PCtoReg = 1'b0;
    MemRead= 3'b000;
    MemtoReg= 1'b0;
    ALUOP = 2'b00;
    ALUSrc= 1'b1;
    RegWrite= 1'b0;
    ALU_JALR_sel = 1'b0;
    lui_sel = 1'b0;
    auipc_sel = 1'b0; 
    //break_fn = 1'b0;  
    sys_stall_fn=1'b0; 
    case(`F3)
        3'b000 : MemWrite = 3'b01;
        3'b001 : MemWrite = 3'b10;
        3'b010 : MemWrite = 3'b11;
    endcase
    end
`OPCODE_Branch: begin
    Branch = 1'b1;
    jal = 1'b0;
    PCtoReg = 1'b0;
    MemRead= 3'b000;
    MemtoReg= 1'b0;
    ALUOP = 2'b01;
    MemWrite= 2'b00;
    ALUSrc= 1'b0;
    RegWrite= 1'b0;
    ALU_JALR_sel = 1'b0;
    lui_sel = 1'b0;
    auipc_sel = 1'b0;
    //break_fn = 1'b0;
    sys_stall_fn=1'b0;
    end
`OPCODE_JAL: begin
    Branch = 1'b0;
    jal = 1'b1;
    PCtoReg = 1'b1;
    MemRead= 3'b000;
    MemtoReg= 1'b0;
    ALUOP = 2'b00;
    MemWrite= 2'b00;
    ALUSrc= 1'b0;
    RegWrite= 1'b1;
    ALU_JALR_sel = 1'b0;
    lui_sel = 1'b0;
    auipc_sel = 1'b0;
    //break_fn = 1'b0;
    sys_stall_fn=1'b0;
    end
`OPCODE_JALR: begin
    Branch = 1'b0;
    jal = 1'b1;
    PCtoReg = 1'b1;
    MemRead= 3'b000;
    MemtoReg= 1'b0;
    ALUOP = 2'b00;
    MemWrite= 2'b00;
    ALUSrc= 1'b1;
    RegWrite= 1'b1;
    ALU_JALR_sel = 1'b1;
    lui_sel = 1'b0;
    auipc_sel = 1'b0; 
    //break_fn = 1'b0;
    sys_stall_fn=1'b0;
     end    
`OPCODE_LUI: begin
    Branch = 1'b0;
    jal = 1'b0;
    PCtoReg = 1'b0;
    MemRead= 3'b000;
    MemtoReg= 1'b0;
    ALUOP = 2'b10;
    MemWrite= 2'b00;
    ALUSrc= 1'b1;
    RegWrite= 1'b1;
    ALU_JALR_sel = 1'b0;
    lui_sel = 1'b1;
    auipc_sel = 1'b0;
    //break_fn = 1'b0;
    sys_stall_fn=1'b0;
    end
`OPCODE_AUIPC: begin
    Branch = 1'b0;
    jal = 1'b0;
    PCtoReg = 1'b0;
    MemRead= 3'b000;
    MemtoReg= 1'b0;
    ALUOP = 2'b00;
    MemWrite= 2'b00;
    ALUSrc= 1'b1;
    RegWrite= 1'b1;
    ALU_JALR_sel = 1'b0;
    lui_sel = 1'b0;
    auipc_sel = 1'b1;
    //break_fn = 1'b0;
    sys_stall_fn=1'b0;
    end    
`OPCODE_SYSTEM: begin
    Branch = 1'b0;
    jal = 1'b0;
    PCtoReg = 1'b0;
    MemRead= 3'b000;
    MemtoReg= 1'b0;
    ALUOP = 2'b00;
    MemWrite= 2'b00;
    ALUSrc= 1'b0;
    RegWrite= 1'b0;
    ALU_JALR_sel = 1'b0;
    lui_sel = 1'b0;
    auipc_sel = 1'b0;
  
    sys_stall_fn=1'b1;

    if(IR[`IR_Sys] == `SYS_EB) begin
        break_fn = 1'b1;
        //end else begin
        //break_fn = 1'b0;
        end 
    end
 `OPCODE_FENCE: begin
        Branch = 1'b0;
        jal = 1'b0;
        PCtoReg = 1'b0;
        MemRead= 3'b000;
        MemtoReg= 1'b0;
        ALUOP = 2'b00;
        MemWrite= 2'b00;
        ALUSrc= 1'b0;
        RegWrite= 1'b0;
        ALU_JALR_sel = 1'b0;
        lui_sel = 1'b0;
        auipc_sel = 1'b0;
        sys_stall_fn=1'b1; 
        end      
default: begin
    Branch = 1'b0;
    jal = 1'b0;
    PCtoReg = 1'b0;
    MemRead= 3'b000;
    MemtoReg= 1'b0;
    ALUOP = 2'b00;
    MemWrite= 2'b00;
    ALUSrc= 1'b0;
    RegWrite= 1'b0;
    ALU_JALR_sel = 1'b0;
    lui_sel = 1'b0;
    auipc_sel = 1'b0;
    sys_stall_fn=1'b0;
    //break_fn = 1'b0;

    end
endcase
end

//end
endmodule
