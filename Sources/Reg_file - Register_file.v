`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Register_file.v
* Project: RV32I
* Author:   Omar Elayat - omar_elayat@aucegypt.edu
*           Bishoy Sabry - bishoy8599@aucegypt.edu
* Description: This module models the instructions memory as an array of 32 bit registers
*
* Change history: 01/03/22 – Created
*
**********************************************************************/


module Register_file #(parameter n = 32)(
    input [4:0] ReadS1,
    input [4:0] ReadS2,
    input [4:0] Writeaddr,
    input [n-1:0] WriteData,
    output reg[n-1:0] ReadData1,
    output reg[n-1:0] ReadData2,
    input RegWrite,
    input clk,
    input rst
    );
    
  reg [31:0]load ; 
  wire [n-1:0] out[31:0] ;
    genvar j;
        wire [n-1:0] temp;
        generate
        for(j = 0; j < n; j = j+1)
        begin: Gen_Modules
        if ( j == 0) begin
        n_bit_reg #(32) registers(
            .d(0),
            .clk(clk),
            .rst(rst),
            .load(load[j]),
            .q(out[j])
           );
       end else begin
         n_bit_reg #(32) registers(
             .d(WriteData),
             .clk(clk),
             .rst(rst),
             .load(load[j]),
             .q(out[j])
            );
            end
        end
        endgenerate
        
   always@(*) begin
   if(RegWrite) begin
     load =32'd0;
     load[Writeaddr] = 1;
     end
     else load =32'd0; 
     
   ReadData1 = out[ReadS1];     
   ReadData2 = out[ReadS2];     
    end 
endmodule
