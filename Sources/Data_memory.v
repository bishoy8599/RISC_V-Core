`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Data_memory.v
* Project: RV32I
* Author:   Omar Elayat - omar_elayat@aucegypt.edu
*           Bishoy Sabry - bishoy8599@aucegypt.edu
* Description: This module models the data memory as a 2D array of bytes
*
* Change history: 08/03/22 – Created
* 26/03/22 – extended to cover the whole 40 RISCV instructions including the unsigned instructions
*
**********************************************************************/


module Data_memory (
 input clk, 
 input [2:0]MemRead, 
 input [1:0]MemWrite, 
 input [11:0] addr, 
 input [31:0] data_in, 
 output reg [31:0] data_out
 );
 reg [7:0] mem [(4*1024-1):0];
 
 always@(*) begin

  case (MemRead)
           3'b001  :  data_out = {24'h00 , mem [addr]};      // load byte unsigned
           3'b101  :  data_out = {{24{mem [addr][7]}}, mem [addr] };      // load byte 
           3'b010  :  data_out = {16'h00 , mem [addr+1] ,  mem [addr]};   //load half word unsigned
           3'b110  :  data_out = {{16{mem [addr+1][7]}},mem [addr+1], mem [addr] };      // load half word 
           3'b111  :  data_out = { mem [addr+3] ,  mem [addr+2], mem [addr+1], mem [addr]};   //load word
           
          default :  data_out =0;
   endcase 
end
always@(posedge clk) begin
    case (MemWrite)
        2'b01  :  mem [addr] = data_in[7:0];      // store byte
        2'b10  : { mem [addr+1] ,  mem [addr]} = data_in[15:0];    // store half word       
        2'b11  :  { mem [addr+3] ,  mem [addr+2], mem [addr+1], mem [addr]} =  data_in;  //store word
    endcase 
     end
     
     reg [4:0] n;
     initial begin
       $readmemh("C:/Users/CSE.CAL/Downloads/8_4_2022-1/Milestone 2/Full_RISCVI/hex/R_format.txt",mem);
//         mem[0]=32'd17;
//         mem[1]=0;
//         mem[2]=0;
//         mem[3]=0;
//        mem[4]=32'd9;
//        mem[5]=0;
//        mem[6]=0;
//        mem[7]=0;
//        mem[8]=32'd25; 
//        mem[9]=0;
//        mem[10]=0;
//        mem[11]=0;
         for(n=0;n<=12;n=n+1)
         $display( "%h",mem[n]);
       end 

endmodule
