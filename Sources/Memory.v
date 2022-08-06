`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 04/09/2022 07:53:34 PM
// Design Name: 
// Module Name: Memory
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Memory (
 input clk, 
 input [2:0]MemRead, 
 input [1:0]MemWrite, 
 input [11:0] addr, 
 input [31:0] data_in, 
 output reg [31:0] data_out
 );
 parameter memory_size = 4 *1024;
 reg [7:0] mem [(memory_size-1):0];
 
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
always@(negedge clk) begin
    case (MemWrite)
        2'b01  :  mem [addr] = data_in[7:0];      // store byte
        2'b10  : { mem [addr+1] ,  mem [addr]} = data_in[15:0];    // store half word       
        2'b11  :  { mem [addr+3] ,  mem [addr+2], mem [addr+1], mem [addr]} =  data_in;  //store word
    endcase 
     end
     
     integer i,c=0;
     reg [7:0] x[(4*1024-1):0];
     reg [4:0] n;
     initial begin
       $readmemh("C:/Users/CSE.CAL/Downloads/Milestone_3/Full_RISCVI/hex/forward_testing.txt",x);
         for (i=0;i<=((memory_size/4)-1);i=i+1)begin
         for(n=0;n<=3;n=n+1)begin
         mem[c] = x[(4*i)+(3-n)];
         c =c+1;
         end
         end
         for(n=0;n<=12;n=n+1)
         $display( "%h",mem[n]);
       end 

endmodule
