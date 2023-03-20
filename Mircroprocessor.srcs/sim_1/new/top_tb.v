`timescale 1ns / 1ps

module top_tb(

    );
    
    
    reg CLK;
    reg RESET;
    reg [1:0] CAR_SELECT_IN;
    wire aa;
    top uut(
    
    .CLK(CLK),
    .RESET(RESET),
    .CAR_SELECT_IN(CAR_SELECT_IN),
    .IR_LED(aa)
    
        );
        
        initial begin
        RESET = 0;
        CLK = 0;
        CAR_SELECT_IN = 2'b00;
       
        forever #5 CLK = ~CLK;
        
        end
        
        initial begin
         #100
               RESET = 1;
               #20
               RESET = 0;
        end
    
    
endmodule