`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Full_RISCVI.v
* Project: RV32I
* Author:   Omar Elayat - omar_elayat@aucegypt.edu
*           Bishoy Sabry - bishoy8599@aucegypt.edu
* Description: This module connects all the processor blocks together 
*
* Change history: 08/03/2022 – Created
* 26/03/22 – extended to cover the whole 40 RISCV instructions
*
**********************************************************************/
`include"defines.v"

module Full_RISCVI(
    input clk,
    input CLK,
    input rst,
        input  [3:0] ssdSel,
        input [1:0] ledselect,    
        output reg [15:0] Leds,
        output [3:0] Anode,
        output [6:0] LED_out
    );
    

    

        
    reg [12:0] number;
    reg [15:0] internal;
       
    wire [31:0] PC_in;
    wire [31:0] PC_out;
    wire [31:0] instruction;
    wire Branch;
    wire [2:0]MemRead;
    wire [1:0]MemWrite;
    wire MemtoReg;
    wire [1:0] ALUOP;
    wire [31:0] memtoreg_mux_out;
    wire [31:0] lui_mux_out;
    wire [31:0] RD1;
    wire [31:0] RD2;
    wire [31:0] gen_out;
    wire [31:0] ALU_mux_out;
    wire [4:0] ALU_SEL;
    wire [31:0] ALU_out;
    wire zf, cf, vf, sf;
    
    wire lui_sel;
    wire [31:0]luiMuxtoReg;
    
    wire auipc_sel;
    wire [31:0] AUIPC_Mux_out;
    
    wire break_fn;
    wire [31:0]pc_adder_const_in;
    
    wire branch_ctrl_out;
    wire [31:0] memtomux;
    wire [31:0] PC_adder;
    wire [31:0] shifter_out;
    wire [31:0] branch_adder;
    wire ALUSrc;
    wire RegWrite;
    wire jal;
    wire PCtoReg;
    wire [31:0] jalMuxtoReg;
    wire ALU_JALR_sel;
    wire [31:0] ALU_JALR_mux_out;
    wire [31:0] EX_MEM_JALR_mux_out, Ex_MEM_Imm, EX_MEM_PC_plus_four,
    EX_MEM_ALU_out, EX_MEM_RegR2;
    wire [4:0] MEM_WB_Rd;
    wire sys_stall_fn;
    
    wire [1:0] forward_A;
    wire [1:0] forward_B;

    wire [31:0] forwarding_mux_A_out;
    wire [31:0] forwarding_mux_B_out;
    
    wire stall;
    wire [15:0] control_flush_mux_out;
    wire [31:0] inst_flush_mux_out;
    wire [10:0] EX_MEM_flush_mux_out;
    
    wire [11:0] Mem_address;
    wire [2:0] Main_MemRead;
    
    wire [31:0] IF_ID_PC, IF_ID_Inst, IF_ID_PC_plus_four;


    wire [31:0] ID_EX_PC, ID_EX_RegR1, ID_EX_RegR2, ID_EX_Imm, ID_EX_PC_plus_four;
    wire [15:0] ID_EX_Ctrl;
    wire R_type_signal;
    wire [4:0] ID_EX_Func;
    wire [4:0] ID_EX_Rs1, ID_EX_Rs2, ID_EX_Rd;
    
    
    wire [10:0] EX_MEM_Ctrl;
    wire [4:0] EX_MEM_Rd;
    wire [3:0] EX_MEM_flags;
    wire [2:0] EX_MEM_func3;
    
    wire [31:0] MEM_WB_Mem_out, MEM_WB_ALU_out;
    wire [3:0] MEM_WB_Ctrl;
    wire [31:0] MEM_WB_PC_plus_four, MEM_WB_IMM_gen;
    
/////////////////////////////////////////fetch/////////////////////////////////////

 n_bit_two_one_mux #(32) Branch_mux(
                        .a(EX_MEM_JALR_mux_out),
                        .b(PC_adder),
                        .sel(branch_ctrl_out | EX_MEM_Ctrl[0]),
                        .q(PC_in)
                        );
                        /*branch_ctrl_out | EX_MEM_Ctrl[0]*/
   thirty_two_bit_reg #(32) PC(
        .d(PC_in),
        .clk(clk),
        .rst(rst),
        .load(~(break_fn | stall)),
        .q(PC_out)
        );
    
//   Instruction_mem IC_mem(
//            .addr(PC_out[7:2]),
//            .data_out(instruction) 
//            );




    n_bit_two_one_mux #(12) Mem_address_mux(
                        .a({4'd0,PC_out[7:2],2'd0}),
                        .b(EX_MEM_ALU_out[11:0]),
                        .sel(clk),
                        .q(Mem_address)
                        );
       // Assuming the if stage is in the logic high half-cycle and the mem stage is in the logic low half-cycle.
       // Assuming that the first 64 words are for instructions and the rest of the memory is for data
    n_bit_two_one_mux #(3) Mem_read_mux(
                        .a(3'b111),
                        .b(EX_MEM_Ctrl[5:3]),
                        .sel(clk),
                        .q(Main_MemRead)
                        );
    
    Memory Main_mem(
                       .clk(clk), 
                       .MemRead(Main_MemRead), 
                       .MemWrite(EX_MEM_Ctrl[2:1]), 
                       .addr(Mem_address), 
                       .data_in(EX_MEM_RegR2), 
                       .data_out(instruction)
                       );
 
 assign memtomux = instruction;
        
/*    n_bit_two_one_mux #(32) inst_flush_mux(
                       .a(32'b0),
                       .b(instruction),
                       .sel(branch_ctrl_out),
                       .q(inst_flush_mux_out)
                        );*/
                          



   n_bit_two_one_mux #(32) break_function_mux(
                        .a(32'd0),
                        .b(32'd4),
                        .sel(sys_stall_fn),
                        .q(pc_adder_const_in)
                        );                    
                        
  RCA_nbit #(32) PC_RCA(
                        .A(PC_out),
                        .B(pc_adder_const_in),
                        .Cout(),
                        .Sum(PC_adder)
                        );

/////////////////////////////////////////decode/////////////////////////////////////
thirty_two_bit_reg #(96) IF_ID ({PC_adder,PC_out,instruction},~clk,rst,(~(stall)),
{IF_ID_PC_plus_four,IF_ID_PC,IF_ID_Inst} );
                 
   control_unit main_control(
                .IR(IF_ID_Inst),
                .Branch(Branch),
                .MemRead(MemRead),
                .MemtoReg(MemtoReg),
                .ALUOP(ALUOP),
                .MemWrite(MemWrite),
                .ALUSrc(ALUSrc),
                .RegWrite(RegWrite),
                .jal(jal),
                .PCtoReg(PCtoReg),
                .ALU_JALR_sel(ALU_JALR_sel),
                .lui_sel(lui_sel),
                .auipc_sel(auipc_sel),
                .break_fn(break_fn),
                .sys_stall_fn(sys_stall_fn)
                );  

   Register_file #(32) Reg_file(
                    .ReadS1(IF_ID_Inst[19:15]),
                    .ReadS2(IF_ID_Inst[24:20]),
                    .Writeaddr(MEM_WB_Rd),
                    .WriteData(luiMuxtoReg),
                    .ReadData1(RD1),
                    .ReadData2(RD2),
                    .RegWrite(MEM_WB_Ctrl[3]),
                    .clk(~clk),
                    .rst(rst)
                    );
                   
   ImmGen immediate_gen(
                    .Imm(gen_out), 
                    .IR(IF_ID_Inst[31:0]));
                    
    hazard_detection_unit haz_det(
                    .IF_ID_RS1(IF_ID_Inst[19:15]),
                    .IF_ID_RS2(IF_ID_Inst[24:20]),
                    .ID_EX_RD(ID_EX_Rd),
                    .ID_EX_MemRead(ID_EX_Ctrl[10]),
                    .stall(stall)
                    );            
                                
  n_bit_two_one_mux #(16) control_flush_mux(
                    .a(16'b0),
                    .b({RegWrite,PCtoReg,lui_sel,MemtoReg,
                     Branch,MemRead,MemWrite,jal,
                     ALUOP,ALUSrc,ALU_JALR_sel,auipc_sel}),
                    .sel(stall | branch_ctrl_out ),
                    .q(control_flush_mux_out)
                    );          
                                
/////////////////////////////////////////execute/////////////////////////////////////

 thirty_two_bit_reg #(197) ID_EX ({IF_ID_Inst[5],IF_ID_PC_plus_four,
 control_flush_mux_out,
 IF_ID_PC,RD1,RD2,gen_out,
 IF_ID_Inst[25],IF_ID_Inst[30],IF_ID_Inst[14:12],
 IF_ID_Inst[19:15],IF_ID_Inst[24:20],IF_ID_Inst[11:7]},clk,rst,1'b1,
 
 {R_type_signal,ID_EX_PC_plus_four,ID_EX_Ctrl,ID_EX_PC,ID_EX_RegR1,ID_EX_RegR2,
 ID_EX_Imm,ID_EX_Func,ID_EX_Rs1,ID_EX_Rs2,ID_EX_Rd} );
 // Rs1 and Rs2 are needed later for the forwarding unit
 
 Forwarding_unit for_uni(
                .EX_MEM_RD(EX_MEM_Rd),
                .MEM_WB_RD(MEM_WB_Rd),
                .RS1(ID_EX_Rs1),
                .RS2(ID_EX_Rs2),
                .EX_MEM_RegWrite(EX_MEM_Ctrl[10]),
                .MEM_WB_RegWrite(MEM_WB_Ctrl[3]),
                                   
                .forward_A(forward_A),
                .forward_B(forward_B)
                );     
                
                
    n_bit_four_one_mux #(32) forwarding_mux_A(
                 .a(ID_EX_RegR1),
                 .b(luiMuxtoReg),
                 .c(EX_MEM_ALU_out),
                 .d(32'd0),
                 .sel(forward_A),
                 .q(forwarding_mux_A_out)
    );
    n_bit_four_one_mux #(32) forwarding_mux_B(
                 .a(ID_EX_RegR2),
                 .b(luiMuxtoReg),
                 .c(EX_MEM_ALU_out),
                 .d(32'd0),
                 .sel(forward_B),
                 .q(forwarding_mux_B_out)
                 );
  
  n_bit_two_one_mux #(32) ALU_source(
                        .a(ID_EX_Imm),
                        .b(forwarding_mux_B_out),
                        .sel(ID_EX_Ctrl[2]),
                        .q(ALU_mux_out)
                        );
                        
 n_bit_two_one_mux #(32) AUIPC_Mux (
                        .a(ID_EX_PC),
                        .b(forwarding_mux_A_out),
                        .sel(ID_EX_Ctrl[0]),
                        .q(AUIPC_Mux_out)
                        );        
                                                          
  ALU_control_unit ALU_ctrl(
                            .instIM(ID_EX_Func[4]),
                            .Inst1(ID_EX_Func[2:0]),
                            .ALUOP(ID_EX_Ctrl[4:3]),
                            .Inst2(ID_EX_Func[3]),
                            .ALU_SEL(ALU_SEL),
                            .R_type(R_type_signal)
                            );
                         
   prv32_ALU My_extended_ALU(
                          .a(AUIPC_Mux_out), 
                          .b(ALU_mux_out),
                          .shamt(ALU_mux_out[4:0]),
                          .r(ALU_out),
                          .cf(cf),
                          .zf(zf), 
                          .vf(vf),
                          .sf(sf),
                          .alufn(ALU_SEL)
                           );
     RCA_nbit #(32)Branch_RCA(
                          .A(ID_EX_PC),
                          .B(ID_EX_Imm),
                          .Cout(),
                          .Sum(branch_adder)
                           );
    n_bit_two_one_mux #(32) jalr_alu_mux(
                          .a(ALU_out),
                          .b(branch_adder),
                          .sel(ID_EX_Ctrl[1]),
                          .q(ALU_JALR_mux_out)
                          );
                          
n_bit_two_one_mux #(11) EX_MEM_flush_mux(
                          .a(11'b0),
                          .b(ID_EX_Ctrl[15:5]),
                          .sel( branch_ctrl_out ),
                          .q(EX_MEM_flush_mux_out)
                          ); 
 /////////////////////////////////////////memory/////////////////////////////////////

thirty_two_bit_reg #(183) EX_MEM ({ID_EX_Func[2:0],ID_EX_Imm,ID_EX_PC_plus_four,
EX_MEM_flush_mux_out,
ALU_JALR_mux_out,cf,vf,sf,zf,ALU_out,forwarding_mux_B_out,ID_EX_Rd}
,~clk,rst,1'b1,
{EX_MEM_func3,Ex_MEM_Imm,EX_MEM_PC_plus_four,EX_MEM_Ctrl, EX_MEM_JALR_mux_out,
EX_MEM_flags,
EX_MEM_ALU_out, EX_MEM_RegR2, EX_MEM_Rd} );

  
 Branch_control branch_ctrl_unit(
                          .branch(EX_MEM_Ctrl[6]),
                          .zf(EX_MEM_flags[0]),
                          .cf(EX_MEM_flags[3]),
                          .sf(EX_MEM_flags[1]),
                          .vf(EX_MEM_flags[2]),
                          .funct3(EX_MEM_func3),
                          .b_ctrl_out(branch_ctrl_out)
                          );                                           
      
//  Data_memory data_mem( .clk(clk),
//                        .MemRead(EX_MEM_Ctrl[5:3]),
//                        .MemWrite(EX_MEM_Ctrl[2:1]),
//                        .addr(EX_MEM_ALU_out[11:0]),
//                        .data_in(EX_MEM_RegR2),
//                        .data_out(memtomux));

/////////////////////////////////////////write_back/////////////////////////////////////

//2 ctrl 7 rd 32 gen 32 pc adder
 thirty_two_bit_reg #(137) MEM_WB ({Ex_MEM_Imm,EX_MEM_PC_plus_four,
 EX_MEM_Ctrl[10:7],memtomux,EX_MEM_ALU_out,EX_MEM_Rd}
 ,clk,rst,1'b1,
 {MEM_WB_IMM_gen,MEM_WB_PC_plus_four,MEM_WB_Ctrl,MEM_WB_Mem_out, MEM_WB_ALU_out,
 MEM_WB_Rd} );

  n_bit_two_one_mux #(32) MemToReg(
                        .a(MEM_WB_Mem_out),
                        .b(MEM_WB_ALU_out),
                        .sel(MEM_WB_Ctrl[0]),
                        .q(memtoreg_mux_out)
                        );
  n_bit_two_one_mux #(32) jal_regwrite_mux(
                        .a(MEM_WB_PC_plus_four),
                        .b(memtoreg_mux_out),
                        .sel(MEM_WB_Ctrl[2]),
                        .q(jalMuxtoReg)
                        );
                       
                                       
                                       
 n_bit_two_one_mux #(32) lui_mux(
                        .a(MEM_WB_IMM_gen),
                        .b(jalMuxtoReg),
                        .sel(MEM_WB_Ctrl[1]),
                        .q(luiMuxtoReg)
                        );    
////////////////////////////////////////////////////////////////////////////////////////
Four_Digit_Seven_Segment_Driver we(
     .clk(CLK),
     .num(number),
     .Anode(Anode),
     .LED_out(LED_out)
     );


    always@(*) begin
        internal = {2'b00, ALUOP, ALU_SEL, zf,Branch & zf,MemRead, MemtoReg,MemWrite,RegWrite,Branch,ALUSrc};

    case(ledselect) 
    2'b00:begin
    Leds = instruction[15:0] ;
    end
    2'b01:begin
    Leds = instruction[31:16];
    end
    2'b10:begin
    Leds ={2'b00, ALUOP, ALU_SEL, zf,Branch & zf,MemRead, MemtoReg,MemWrite,RegWrite,Branch,ALUSrc};
    end
    default: Leds =0;
    endcase
    
    
    case(ssdSel)
    4'b0000: begin
    number = PC_out[12:0];
    end
    4'b0001: begin 
    number = PC_adder[12:0];
    end
    4'b0010: begin 
    number = branch_adder[12:0];
    end
    4'b0011: begin 
    number = PC_in[12:0];
    end
    4'b0100: begin 
    number = RD1[12:0];
    end
    4'b0101: begin 
    number = RD2[12:0];
    end
    4'b0110: begin 
    number = memtoreg_mux_out[12:0];
    end
    4'b0111: begin 
    number = gen_out[12:0];
    end
    4'b1000: begin 
    number = shifter_out[12:0];
    end
    4'b1001: begin 
    number = ALU_mux_out[12:0];
    end
    4'b1010: begin 
    number = ALU_out[12:0];
    end
    4'b1011: begin 
    number = memtomux[12:0];
    end
    default: begin
    number = 0;
    end
    endcase
    end    
endmodule