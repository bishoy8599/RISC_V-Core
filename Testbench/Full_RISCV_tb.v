`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/08/2022 02:52:54 PM
// Design Name: 
// Module Name: full_path_tb
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


module full_path_tb(

    );
        reg clock;
        reg CLK;
        reg rst;
        reg [3:0] ssdSel;
        wire [15:0] Leds;
        wire [3:0] Anode;
        wire [6:0] LED_out;
    Full_RISCVI uut(
        .clk(CLK),
        .CLK(CLK),
        .rst(rst),
        .ssdSel(ssdSel),
        .ledselect(ledselect),    
        .Leds(Leds),
         .Anode(Anode),
         .LED_out(LED_out)
        );
        
       initial begin 

       CLK= 0;
       forever #20 CLK = ~CLK;
       end
       
       initial begin 
       clock= 0;
       forever #2000 clock = ~clock;
       end
       
       initial begin
      ssdSel = 4'b0101;      
       rst = 1;
       #40;
       rst = 0;
       end         
endmodule
